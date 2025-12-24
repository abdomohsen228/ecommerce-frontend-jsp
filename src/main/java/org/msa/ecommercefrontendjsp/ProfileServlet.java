package org.msa.ecommercefrontendjsp;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

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

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("http://localhost:5004/api/customers/" + customerId))
                    .header("Accept", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> response =
                    client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JSONObject customerData = new JSONObject(response.body());

                req.setAttribute("customerId", customerData.getInt("customer_id"));
                req.setAttribute("name", customerData.getString("name"));
                req.setAttribute("email", customerData.getString("email"));
                req.setAttribute("phone", customerData.optString("phone", "N/A"));
                req.setAttribute("loyaltyPoints", customerData.optInt("loyalty_points", 0));
                req.setAttribute("createdAt", customerData.optString("created_at", "N/A"));

            } else if (response.statusCode() == 404) {
                req.setAttribute("error", "Customer not found with ID: " + customerId);
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
                return;
            } else {
                throw new IOException("Customer Service error: HTTP " + response.statusCode());
            }

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
            req.setAttribute("error",
                    "Cannot connect to Customer Service. Please ensure it's running on port 5004. Error: " +
                            e.getMessage());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
            return;
        }

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }
}
