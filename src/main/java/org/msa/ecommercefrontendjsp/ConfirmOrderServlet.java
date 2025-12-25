package org.msa.ecommercefrontendjsp;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet to confirm and create the order
 * Calls Order Service, updates loyalty points, and sends notification
 */
@WebServlet("/confirmOrder")
public class ConfirmOrderServlet extends HttpServlet {

    private final HttpClient client = HttpClient.newHttpClient();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            int customerId = Integer.parseInt(req.getParameter("customer_id"));
            double totalAmount = Double.parseDouble(req.getParameter("total_amount"));
            String productsJson = req.getParameter("products_json");

            JSONArray products = new JSONArray(productsJson);

            // Step 1: Create Order
            JSONObject orderPayload = new JSONObject();
            orderPayload.put("customer_id", customerId);
            orderPayload.put("products", products);
            orderPayload.put("total_amount", totalAmount);

            HttpRequest orderRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5001/api/orders/create"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(orderPayload.toString()))
                    .build();

            HttpResponse<String> orderResponse =
                    client.send(orderRequest, HttpResponse.BodyHandlers.ofString());

            if (orderResponse.statusCode() != 200 && orderResponse.statusCode() != 201) {
                throw new IOException("Order Service error: HTTP " + orderResponse.statusCode());
            }

            JSONObject orderData = new JSONObject(orderResponse.body());
            int orderId = orderData.getInt("order_id");
            String orderStatus = orderData.optString("status", "confirmed");
            String orderTimestamp = orderData.optString("timestamp", "");

            // Step 2: Update Loyalty Points
            // Calculate loyalty points: 1 point per 10 EGP spent
            int loyaltyPointsEarned = (int) (totalAmount / 10);

            JSONObject loyaltyPayload = new JSONObject();
            loyaltyPayload.put("points_to_add", loyaltyPointsEarned);

            HttpRequest loyaltyRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5004/api/customers/" + customerId + "/loyalty"))
                    .header("Content-Type", "application/json")
                    .PUT(HttpRequest.BodyPublishers.ofString(loyaltyPayload.toString()))
                    .build();

            try {
                HttpResponse<String> loyaltyResponse =
                        client.send(loyaltyRequest, HttpResponse.BodyHandlers.ofString());

                if (loyaltyResponse.statusCode() == 200) {
                    JSONObject loyaltyData = new JSONObject(loyaltyResponse.body());
                    int newLoyaltyPoints = loyaltyData.optInt("points", 0);
                    req.setAttribute("loyaltyPointsEarned", loyaltyPointsEarned);
                    req.setAttribute("totalLoyaltyPoints", newLoyaltyPoints);
                }
            } catch (Exception e) {
                System.err.println("Failed to update loyalty points: " + e.getMessage());
                // Continue even if loyalty update fails
            }

            // Step 3: Send Notification
            JSONObject notificationPayload = new JSONObject();
            notificationPayload.put("order_id", orderId);
            notificationPayload.put("customer_id", customerId);

            HttpRequest notificationRequest = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5005/api/notifications/send"))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(notificationPayload.toString()))
                    .build();

            try {
                HttpResponse<String> notificationResponse =
                        client.send(notificationRequest, HttpResponse.BodyHandlers.ofString());

                if (notificationResponse.statusCode() == 200) {
                    req.setAttribute("notificationSent", true);
                }
            } catch (Exception e) {
                System.err.println("Failed to send notification: " + e.getMessage());
                // Continue even if notification fails
            }

            // Step 4: Set attributes for confirmation page
            req.setAttribute("orderId", orderId);
            req.setAttribute("orderStatus", orderStatus);
            req.setAttribute("orderTimestamp", orderTimestamp);
            req.setAttribute("customerId", customerId);
            req.setAttribute("totalAmount", totalAmount);
            req.setAttribute("products", products);

            req.getRequestDispatcher("/confirmation.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid input format: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            req.setAttribute("error", "Request interrupted: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Failed to create order: " + e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }
}
