<%--
  Created by IntelliJ IDEA.
  User: tasnim
  Date: 12/19/2025
  Time: 2:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Order Confirmation</title>
    <style>
        body { font-family: Arial; text-align: center; margin-top: 50px; }
        pre { background: #f4f4f4; padding: 20px; margin: 20px auto; width: 80%; text-align: left; }
        .success { color: green; font-size: 24px; }
        .error { color: red; font-size: 24px; }
    </style>
</head>
<body>
<h1>Order Confirmation</h1>

<% if (request.getAttribute("error") != null) { %>
<p class="error"><%= request.getAttribute("error") %></p>
<% } else { %>
<p class="success">Order Placed Successfully!</p>
<% } %>

<h3>Pricing Details:</h3>
<pre><%= request.getAttribute("pricingResponse") != null ? request.getAttribute("pricingResponse") : "N/A" %></pre>

<h3>Order Details:</h3>
<pre><%= request.getAttribute("orderResponse") %></pre>

<br><br>
<a href="index.jsp">← Back to Home</a>
</body>
</html>
