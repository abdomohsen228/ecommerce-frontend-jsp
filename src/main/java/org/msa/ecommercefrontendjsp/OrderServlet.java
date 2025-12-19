package org.msa.ecommercefrontendjsp;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

class Product {
    int product_id;
    int quantity;
    Product(int id, int qty) { this.product_id = id; this.quantity = qty; }
}

@WebServlet("/submitOrder")
public class OrderServlet extends HttpServlet {
    private final HttpClient client = HttpClient.newHttpClient();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int customerId = Integer.parseInt(req.getParameter("customer_id"));
            int qty1 = Integer.parseInt(req.getParameter("qty1"));
            int qty2 = Integer.parseInt(req.getParameter("qty2"));
            int qty3 = Integer.parseInt(req.getParameter("qty3"));

            // Build list of products with quantity > 0
            List<Product> selectedProducts = new ArrayList<>();
            if (qty1 > 0) selectedProducts.add(new Product(1, qty1));
            if (qty2 > 0) selectedProducts.add(new Product(2, qty2));
            if (qty3 > 0) selectedProducts.add(new Product(3, qty3));

            if (selectedProducts.isEmpty()) {
                req.setAttribute("pricingResponse", "No products selected");
                req.setAttribute("orderResponse", "Please select at least one product");
                req.getRequestDispatcher("confirmation.jsp").forward(req, resp);
                return;
            }

            // Build clean products JSON array
            StringBuilder productsJson = new StringBuilder("[");
            for (int i = 0; i < selectedProducts.size(); i++) {
                Product p = selectedProducts.get(i);
                productsJson.append(String.format("{\"product_id\":%d,\"quantity\":%d}", p.product_id, p.quantity));
                if (i < selectedProducts.size() - 1) productsJson.append(",");
            }
            productsJson.append("]");

            // Call Pricing Service
            String pricingPayload = "{\"products\":" + productsJson.toString() + "}";
            HttpRequest pricingReq = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5003/api/pricing/calculate"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(pricingPayload))
                    .build();

            HttpResponse<String> pricingResp = client.send(pricingReq, HttpResponse.BodyHandlers.ofString());
            req.setAttribute("pricingResponse", pricingResp.body());

            double total = 0.0;
            if (pricingResp.statusCode() == 200 && pricingResp.body().contains("\"total\"")) {
                String body = pricingResp.body();
                int totalIndex = body.indexOf("\"total\":") + 8;
                int endIndex = body.indexOf(",", totalIndex);
                if (endIndex == -1) endIndex = body.indexOf("}", totalIndex);
                String totalStr = body.substring(totalIndex, endIndex).trim();
                total = Double.parseDouble(totalStr);
            }

            // Call Order Service
            String orderPayload = String.format("""
                {
                  "customer_id": %d,
                  "products": %s,
                  "total_amount": %.2f
                }
                """, customerId, productsJson.toString(), total);

            HttpRequest orderReq = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5001/api/orders/create"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(orderPayload))
                    .build();

            HttpResponse<String> orderResp = client.send(orderReq, HttpResponse.BodyHandlers.ofString());
            req.setAttribute("orderResponse", orderResp.body());

        } catch (Exception e) {
            req.setAttribute("pricingResponse", "Error: " + e.getMessage());
            req.setAttribute("orderResponse", "Backend connection failed");
        }

        req.getRequestDispatcher("confirmation.jsp").forward(req, resp);
    }
}