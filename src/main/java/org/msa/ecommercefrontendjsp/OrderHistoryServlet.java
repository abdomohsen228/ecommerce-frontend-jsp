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

@WebServlet("/orderHistory")
public class OrderHistoryServlet extends HttpServlet {

    private final HttpClient client = HttpClient.newHttpClient();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String customerIdParam = req.getParameter("customer_id");

            if (customerIdParam == null || customerIdParam.isEmpty()) {
                req.setAttribute("error", "Customer ID is required");
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            int customerId = Integer.parseInt(customerIdParam);

            HttpRequest customerOrdersRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5004/api/customers/" + customerId + "/orders"))
                    .header("Accept", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> customerOrdersResponse =
                    client.send(customerOrdersRequest, HttpResponse.BodyHandlers.ofString());

            if (customerOrdersResponse.statusCode() == 404) {
                req.setAttribute("error", "Customer not found with ID: " + customerId);
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            }

            if (customerOrdersResponse.statusCode() != 200) {
                throw new IOException("Customer Service error: HTTP " + customerOrdersResponse.statusCode());
            }

            JSONObject customerOrdersData = new JSONObject(customerOrdersResponse.body());
            JSONArray orderIds = customerOrdersData.optJSONArray("order_ids");

            List<OrderDetails> orderDetailsList = new ArrayList<>();

            // Step 2: Get details for each order from Order Service
            if (orderIds != null && orderIds.length() > 0) {
                for (int i = 0; i < orderIds.length(); i++) {
                    int orderId = orderIds.getInt(i);

                    HttpRequest orderDetailsRequest = HttpRequest.newBuilder()
                            .uri(URI.create("http://localhost:5001/api/orders/" + orderId))
                            .header("Accept", "application/json")
                            .GET()
                            .build();

                    try {
                        HttpResponse<String> orderDetailsResponse =
                                client.send(orderDetailsRequest, HttpResponse.BodyHandlers.ofString());

                        if (orderDetailsResponse.statusCode() == 200) {
                            JSONObject orderData = new JSONObject(orderDetailsResponse.body());

                            OrderDetails details = new OrderDetails();
                            details.setOrderId(orderData.getInt("order_id"));
                            details.setCustomerId(orderData.getInt("customer_id"));
                            details.setTotalAmount(orderData.getDouble("total_amount"));
                            details.setStatus(orderData.optString("status", "completed"));
                            details.setTimestamp(orderData.optString("created_at", "N/A"));

                            // Parse products
                            JSONArray products = orderData.optJSONArray("products");
                            if (products != null) {
                                List<ProductItem> productItems = new ArrayList<>();
                                for (int j = 0; j < products.length(); j++) {
                                    JSONObject product = products.getJSONObject(j);
                                    ProductItem item = new ProductItem();
                                    item.setProductId(product.getInt("product_id"));
                                    item.setQuantity(product.getInt("quantity"));
                                    productItems.add(item);
                                }
                                details.setProducts(productItems);
                            }

                            orderDetailsList.add(details);
                        }
                    } catch (Exception e) {
                        System.err.println("Failed to fetch order " + orderId + ": " + e.getMessage());
                    }
                }
            }

            // Set attributes for JSP
            req.setAttribute("customerId", customerId);
            req.setAttribute("customerName", customerOrdersData.optString("customer_name", "Customer"));
            req.setAttribute("orders", orderDetailsList);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid customer ID format");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            req.setAttribute("error", "Request interrupted: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        } catch (Exception e) {
            req.setAttribute("error", "Error fetching order history: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }

        req.getRequestDispatcher("/order-history.jsp").forward(req, resp);
    }

    public static class OrderDetails {
        private int orderId;
        private int customerId;
        private double totalAmount;
        private String status;
        private String timestamp;
        private List<ProductItem> products;

        public int getOrderId() { return orderId; }
        public void setOrderId(int orderId) { this.orderId = orderId; }

        public int getCustomerId() { return customerId; }
        public void setCustomerId(int customerId) { this.customerId = customerId; }

        public double getTotalAmount() { return totalAmount; }
        public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getTimestamp() { return timestamp; }
        public void setTimestamp(String timestamp) { this.timestamp = timestamp; }

        public List<ProductItem> getProducts() { return products; }
        public void setProducts(List<ProductItem> products) { this.products = products; }

        public int getProductCount() {
            return products != null ? products.size() : 0;
        }

        public int getTotalItems() {
            if (products == null) return 0;
            return products.stream().mapToInt(ProductItem::getQuantity).sum();
        }
    }

    public static class ProductItem {
        private int productId;
        private int quantity;

        public int getProductId() { return productId; }
        public void setProductId(int productId) { this.productId = productId; }

        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
    }
}
