<%@ page import="java.net.http.*,java.net.URI" %>
<%@ page import="org.json.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder()
        .uri(URI.create("http://localhost:5002/api/inventory/all"))
        .GET()
        .build();

HttpResponse<String> response =
        client.send(request, HttpResponse.BodyHandlers.ofString());

JSONArray products = new JSONArray(response.body());
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

<form action="checkout.jsp" method="get">
<table border="1">
<tr>
    <th>Select</th>
    <th>Name</th>
    <th>Price</th>
    <th>Available</th>
</tr>

<% for (int i = 0; i < products.length(); i++) {
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
<% } %>

</table>
<br>
Customer ID:
<input type="number" name="customer_id" required>
<br><br>
<input type="submit" value="Proceed to Checkout">
</form>

</body>
</html>
