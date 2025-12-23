<%@ page import="org.json.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="org.json.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String orderJson = (String) request.getAttribute("orderResponse");
String error = (String) request.getAttribute("error");
%>

<html>
<head>
<title>Order Confirmation</title>
<style>
    body { font-family: Arial, sans-serif; margin: 50px; }
    .error { background-color: #f8d7da; color: #721c24; padding: 15px; border: 1px solid #f5c6cb; border-radius: 5px; margin: 20px 0; }
    .success { background-color: #d4edda; color: #155724; padding: 15px; border: 1px solid #c3e6cb; border-radius: 5px; margin: 20px 0; }
</style>
</head>
<body>

<% if (error != null) { %>
    <div class="error">
        <h2>Order Failed</h2>
        <p><strong>Error:</strong> <%= error %></p>
        <p>Please check that all backend services are running:</p>
        <ul>
            <li>Pricing Service: http://localhost:5003/api/pricing/calculate</li>
            <li>Order Service: http://localhost:5001/api/orders/create</li>
        </ul>
    </div>
<% } else if (orderJson != null) {
    try {
        JSONObject order = new JSONObject(orderJson);
%>
    <div class="success">
        <h2>Order Placed Successfully</h2>
        <p>Order ID: <%=order.getInt("order_id")%></p>
        <p>Status: <%=order.getString("status")%></p>
        <p>Total Amount: $<%=order.getDouble("total_amount")%></p>
        <p>Timestamp: <%=order.getString("timestamp")%></p>
    </div>
<%
    } catch (JSONException e) {
%>
    <div class="error">
        <h2>Error Processing Order Response</h2>
        <p><%= e.getMessage() %></p>
    </div>
<%
    }
} else {
%>
    <div class="error">
        <h2>No Order Response</h2>
        <p>No order data was returned from the server.</p>
    </div>
<% } %>

<a href="index.jsp">Back to Home</a>
</body>
</html>
