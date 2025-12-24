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

@WebServlet(name = "ProductCatalogServlet", urlPatterns = {"", "/index", "/catalog"})
public class ProductCatalogServlet extends HttpServlet {

    private final HttpClient client = HttpClient.newHttpClient();
    // FIXED: Your backend returns the array directly, not wrapped in an object
    private static final String INVENTORY_SERVICE_URL = "http://localhost:5002/api/inventory/products";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(INVENTORY_SERVICE_URL))
                    .header("Accept", "application/json")
                    .GET()
                    .build();

            HttpResponse<String> response =
                    client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                // FIXED: Your backend returns array directly [...]
                JSONArray products = new JSONArray(response.body());
                req.setAttribute("products", parseProducts(products));

            } else {
                req.setAttribute("error",
                        "Failed to load products. Status: " + response.statusCode() +
                                ". Please ensure Inventory Service is running on port 5002.");
            }

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            req.setAttribute("error", "Request interrupted: " + e.getMessage());
        } catch (Exception e) {
            req.setAttribute("error",
                    "Cannot connect to Inventory Service. Please ensure it's running on port 5002. Error: " +
                            e.getMessage());
        }

        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }

    private java.util.List<Product> parseProducts(JSONArray jsonArray) {
        java.util.List<Product> products = new java.util.ArrayList<>();

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject json = jsonArray.getJSONObject(i);
            Product p = new Product();
            p.setProduct_id(json.getInt("product_id"));
            p.setProduct_name(json.getString("product_name"));
            p.setUnit_price(json.getDouble("unit_price"));
            p.setQuantity_available(json.getInt("quantity_available"));
            products.add(p);
        }

        return products;
    }

    public static class Product {
        private int product_id;
        private String product_name;
        private double unit_price;
        private int quantity_available;

        public int getProduct_id() { return product_id; }
        public void setProduct_id(int product_id) { this.product_id = product_id; }

        public String getProduct_name() { return product_name; }
        public void setProduct_name(String product_name) { this.product_name = product_name; }

        public double getUnit_price() { return unit_price; }
        public void setUnit_price(double unit_price) { this.unit_price = unit_price; }

        public int getQuantity_available() { return quantity_available; }
        public void setQuantity_available(int quantity_available) {
            this.quantity_available = quantity_available;
        }
    }
}