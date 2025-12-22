<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Checkout</title>
</head>
<body>

<h2>Confirm Order</h2>

<form action="submitOrder" method="post">
<input type="hidden" name="customer_id"
        value="<%=request.getParameter("customer_id")%>">

<%
String[] productIds = request.getParameterValues("product_id");
if (productIds != null) {
    for (String pid : productIds) {
        String qty = request.getParameter("qty_" + pid);
%>
<input type="hidden" name="product_id" value="<%=pid%>">
<input type="hidden" name="quantity_<%=pid%>" value="<%=qty%>">
Product ID: <%=pid%> | Quantity: <%=qty%><br>
<%
    }
}
%>

<br>
<input type="submit" value="Place Order">
</form>

</body>
</html>
