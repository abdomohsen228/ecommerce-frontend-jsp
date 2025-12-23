package org.msa.ecommercefrontendjsp;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/submitOrder")
public class OrderServlet extends HttpServlet {

    private final HttpClient client = HttpClient.newHttpClient();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int customerId = Integer.parseInt(req.getParameter("customer_id"));
            String[] productIds = req.getParameterValues("product_id");

            JSONArray products = new JSONArray();

            for (String pid : productIds) {
                int qty = Integer.parseInt(req.getParameter("quantity_" + pid));
                JSONObject p = new JSONObject();
                p.put("product_id", Integer.parseInt(pid));
                p.put("quantity", qty);
                products.put(p);
            }

            JSONObject pricingPayload = new JSONObject();
            pricingPayload.put("products", products);

            HttpRequest pricingReq = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5003/api/pricing/calculate"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(pricingPayload.toString()))
                    .build();

            HttpResponse<String> pricingResp =
                    client.send(pricingReq, HttpResponse.BodyHandlers.ofString());

            if (pricingResp.statusCode() != 200) {
                throw new IOException("Pricing Service returned HTTP " + pricingResp.statusCode() + 
                                    ". Please ensure the Pricing Service is running on port 5003.");
            }

            JSONObject pricing = new JSONObject(pricingResp.body());
            double total = pricing.getDouble("total");

            // Order Service
            JSONObject orderPayload = new JSONObject();
            orderPayload.put("customer_id", customerId);
            orderPayload.put("products", products);
            orderPayload.put("total_amount", total);

            HttpRequest orderReq = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5001/api/orders/create"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(orderPayload.toString()))
                    .build();

            HttpResponse<String> orderResp =
                    client.send(orderReq, HttpResponse.BodyHandlers.ofString());

            if (orderResp.statusCode() != 200) {
                throw new IOException("Order Service returned HTTP " + orderResp.statusCode() + 
                                    ". Please ensure the Order Service is running on port 5001.");
            }

            req.setAttribute("orderResponse", orderResp.body());

        } catch (IOException | InterruptedException | NumberFormatException | JSONException e) {
            req.setAttribute("error", e.getMessage());
        }

        req.getRequestDispatcher("confirmation.jsp").forward(req, resp);
    }
}
