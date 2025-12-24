<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>E-Commerce Store - Product Catalog</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>

<div class="container">
    <h1>Product Catalog</h1>

    <nav>
        <a href="${pageContext.request.contextPath}/profile?customer_id=1">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">person</i>
            View Profile
        </a>
        <a href="${pageContext.request.contextPath}/orderHistory?customer_id=1">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">receipt_long</i>
            Order History
        </a>
    </nav>

    <c:if test="${not empty error}">
        <div class="error">
            <strong>Error:</strong> ${error}
        </div>
    </c:if>

    <c:if test="${not empty message}">
        <div class="info">
            <strong>Info:</strong> ${message}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/checkout" method="post">

        <div class="card">
            <h3>Available Products</h3>

            <table>
                <thead>
                <tr>
                    <th>Select</th>
                    <th>Product Name</th>
                    <th>Unit Price (EGP)</th>
                    <th>Available Stock</th>
                    <th>Quantity</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty products}">
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td>
                                    <input type="checkbox"
                                           name="product_id"
                                           value="${p.product_id}"
                                           id="product_${p.product_id}">
                                </td>
                                <td><label for="product_${p.product_id}">${p.product_name}</label></td>
                                <td>${p.unit_price} EGP</td>
                                <td>${p.quantity_available} units</td>
                                <td>
                                    <input type="number"
                                           name="quantity_${p.product_id}"
                                           min="1"
                                           max="${p.quantity_available}"
                                           value="1">
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 30px;">
                                <strong>No products available at the moment.</strong>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>Customer Information</h3>
            <label for="customer_id">Customer ID:</label>
            <input type="number"
                   id="customer_id"
                   name="customer_id"
                   value="1"
                   required
                   min="1">
            <small style="color: #757575; display: block; margin-top: 8px;">
                (Default: 1 - Ahmed Hassan, 2 - Sara Mohamed, 3 - Omar Ali)
            </small>
        </div>

        <div class="actions">
            <button type="submit" class="btn btn-success">
                <i class="material-icons" style="vertical-align: middle; font-size: 18px;">shopping_cart</i>
                Proceed to Checkout
            </button>
        </div>
    </form>
</div>

</body>
</html>
