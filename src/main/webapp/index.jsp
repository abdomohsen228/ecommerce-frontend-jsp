<%@ page import="java.net.http.*,java.net.URI" %>
<%@ page import="org.json.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
JSONArray products = new JSONArray();
String errorMessage = null;

try {
    HttpClient client = HttpClient.newHttpClient();
    HttpRequest httpRequest = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:5002/api/inventory/all"))
            .GET()
            .build();

    HttpResponse<String> httpResponse =
            client.send(httpRequest, HttpResponse.BodyHandlers.ofString());

    if (httpResponse.statusCode() == 200) {
        products = new JSONArray(httpResponse.body());
    } else {
        errorMessage = "Inventory Service Error: HTTP " + httpResponse.statusCode() + 
                      ". Please ensure the Inventory Service is running on port 5002.";
    }
} catch (Exception e) {
    errorMessage = "Cannot connect to Inventory Service (http://localhost:5002/api/inventory/all). " +
                  "Error: " + e.getMessage() + 
                  ". Please ensure the Inventory Service is running.";
}
%>

<html>
<head>
    <title>E-Commerce Store</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        a.button { padding: 15px 30px; background: #28a745; color: white; text-decoration: none; font-size: 20px; border-radius: 8px; }
        h1 { color: #007bff; }
    </style>
</head>
<body>
<h1>Product Catalog</h1>

<% if (errorMessage != null) { %>
<div style="background-color: #f8d7da; color: #721c24; padding: 15px; margin: 20px; border: 1px solid #f5c6cb; border-radius: 5px;">
    <strong>Error:</strong> <%= errorMessage %>
</div>
<% } %>

<form action="checkout.jsp" method="get">
<table border="1">
<tr>
    <th>Select</th>
    <th>Name</th>
    <th>Price</th>
    <th>Available</th>
</tr>

<% if (products.length() == 0 && errorMessage == null) { %>
<tr><td colspan="4" style="text-align: center; padding: 20px;">No products available</td></tr>
<% } else {
    for (int i = 0; i < products.length(); i++) {
        JSONObject p = products.getJSONObject(i);
%>
<tr>
    <td>
        <input type="checkbox" name="product_id" value="<%=p.getInt("product_id")%>">
        Qty:
        <input type="number" name="qty_<%=p.getInt("product_id")%>" min="1">
    </td>
    <td><%=p.getString("product_name")%></td>
    <td>$<%=p.getDouble("unit_price")%></td>
    <td><%=p.getInt("quantity_available")%></td>
</tr>
<% 
    }
} 
%>

</table>
<br>
Customer ID:
<input type="number" name="customer_id" required>
<br><br>
<input type="submit" value="Proceed to Checkout">
</form>

</body>
</html>
