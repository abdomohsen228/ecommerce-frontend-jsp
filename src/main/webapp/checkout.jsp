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
    <title>Checkout</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        input[type=number] { width: 100px; padding: 8px; }
        label { display: inline-block; width: 150px; }
        .form-group { margin: 15px 0; }
        input[type=submit] { padding: 12px 30px; background: #007bff; color: white; border: none; font-size: 18px; cursor: pointer; }
    </style>
</head>
<body>
<h1>Place Your Order</h1>
<form action="submitOrder" method="post">
    <div class="form-group">
        <label>Customer ID:</label>
        <input type="number" name="customer_id" value="1" required min="1">
    </div>

    <h3>Products</h3>

    <div class="form-group">
        <label>Laptop (ID: 1) Qty:</label>
        <input type="number" name="qty1" value="6" min="0">
    </div>

    <div class="form-group">
        <label>Mouse (ID: 2) Qty:</label>
        <input type="number" name="qty2" value="12" min="0">
    </div>

    <div class="form-group">
        <label>Keyboard (ID: 3) Qty:</label>
        <input type="number" name="qty3" value="0" min="0">
    </div>

    <br>
    <input type="submit" value="Calculate Price & Place Order">
</form>
<br>
<a href="index.jsp">← Back to Home</a>
</body>
</html>
