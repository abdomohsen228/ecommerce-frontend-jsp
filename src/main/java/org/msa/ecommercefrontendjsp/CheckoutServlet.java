package org.msa.ecommercefrontendjsp;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet to handle checkout process
 * Checks inventory availability and calculates pricing
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private final HttpClient client = HttpClient.newHttpClient();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int customerId = Integer.parseInt(req.getParameter("customer_id"));
            String[] productIds = req.getParameterValues("product_id");

            if (productIds == null || productIds.length == 0) {
                req.setAttribute("error", "Please select at least one product!");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            List<OrderItem> orderItems = new ArrayList<>();
            JSONArray productsArray = new JSONArray();
            boolean inventoryCheckFailed = false;
            String inventoryError = "";

            // Step 1: Check inventory for each product
            for (String pid : productIds) {
                int productId = Integer.parseInt(pid);
                String quantityParam = req.getParameter("quantity_" + pid);

                if (quantityParam == null || quantityParam.isEmpty()) {
                    continue;
                }

                int requestedQty = Integer.parseInt(quantityParam);

                // Call Inventory Service to check availability
                HttpRequest inventoryRequest = HttpRequest.newBuilder()
                        .uri(URI.create("http://localhost:5002/api/inventory/check/" + productId))
                        .header("Accept", "application/json")
                        .GET()
                        .build();

                HttpResponse<String> inventoryResponse =
                        client.send(inventoryRequest, HttpResponse.BodyHandlers.ofString());

                if (inventoryResponse.statusCode() != 200) {
                    inventoryCheckFailed = true;
                    inventoryError = "Failed to check inventory for product " + productId;
                    break;
                }

                JSONObject inventoryData = new JSONObject(inventoryResponse.body());
                int availableQty = inventoryData.getInt("quantity_available");
                String productName = inventoryData.getString("product_name");
                double unitPrice = inventoryData.getDouble("unit_price");

                // Check if requested quantity is available
                if (requestedQty > availableQty) {
                    inventoryCheckFailed = true;
                    inventoryError = String.format(
                            "Insufficient stock for %s. Requested: %d, Available: %d",
                            productName, requestedQty, availableQty
                    );
                    break;
                }

                // Add to order items
                OrderItem item = new OrderItem();
                item.setProductId(productId);
                item.setProductName(productName);
                item.setQuantity(requestedQty);
                item.setUnitPrice(unitPrice);
                orderItems.add(item);

                // Build JSON for pricing service
                JSONObject productJson = new JSONObject();
                productJson.put("product_id", productId);
                productJson.put("quantity", requestedQty);
                productsArray.put(productJson);
            }

            if (inventoryCheckFailed) {
                req.setAttribute("error", inventoryError);
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            // Step 2: Calculate total amount using Pricing Service
            JSONObject pricingPayload = new JSONObject();
            pricingPayload.put("products", productsArray);

            HttpRequest pricingRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5003/api/pricing/calculate"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(pricingPayload.toString()))
                    .build();

            HttpResponse<String> pricingResponse =
                    client.send(pricingRequest, HttpResponse.BodyHandlers.ofString());

            if (pricingResponse.statusCode() != 200) {
                throw new IOException("Pricing Service error: HTTP " + pricingResponse.statusCode());
            }

            JSONObject pricingData = new JSONObject(pricingResponse.body());
            double totalAmount = pricingData.getDouble("total");
            double subtotal = pricingData.optDouble("subtotal", totalAmount);
            double discount = pricingData.optDouble("discount", 0.0);
            double tax = pricingData.optDouble("tax", 0.0);

            // Set attributes for checkout.jsp
            req.setAttribute("customerId", customerId);
            req.setAttribute("orderItems", orderItems);
            req.setAttribute("subtotal", subtotal);
            req.setAttribute("discount", discount);
            req.setAttribute("tax", tax);
            req.setAttribute("totalAmount", totalAmount);
            req.setAttribute("productsJson", productsArray.toString());

            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid input format: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            req.setAttribute("error", "Request interrupted: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Checkout error: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }

    /**
     * OrderItem class to hold order details
     */
    public static class OrderItem {
        private int productId;
        private String productName;
        private int quantity;
        private double unitPrice;

        public int getProductId() { return productId; }
        public void setProductId(int productId) { this.productId = productId; }

        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }

        public double getUnitPrice() { return unitPrice; }
        public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

        public double getSubtotal() { return unitPrice * quantity; }
    }
}
