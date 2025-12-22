<%@ page import="org.json.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String orderJson = (String) request.getAttribute("orderResponse");
JSONObject order = new JSONObject(orderJson);
%>

<html>
<head>
<title>Order Confirmation</title>
</head>
<body>

<h2>Order Placed Successfully</h2>

<p>Order ID: <%=order.getInt("order_id")%></p>
<p>Status: <%=order.getString("status")%></p>
<p>Total Amount: $<%=order.getDouble("total_amount")%></p>
<p>Timestamp: <%=order.getString("timestamp")%></p>

<a href="index.jsp">Back to Home</a>
</body>
</html>
