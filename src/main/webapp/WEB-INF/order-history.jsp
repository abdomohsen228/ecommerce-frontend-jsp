<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order History</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>

<div class="container">
    <h1>Order History</h1>

    <nav>
        <a href="${pageContext.request.contextPath}/">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">home</i>
            Back to Catalog
        </a>
        <a href="${pageContext.request.contextPath}/profile?customer_id=${customerId}">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">person</i>
            View Profile
        </a>
    </nav>

    <div class="card">
        <h3>Orders for ${customerName} (Customer #${customerId})</h3>

        <c:choose>
            <c:when test="${not empty orders}">
                <p style="color: #757575; margin-bottom: 20px;">
                    <i class="material-icons" style="vertical-align: middle; font-size: 18px;">receipt</i>
                    Total Orders: <strong>${orders.size()}</strong>
                </p>

                <c:forEach var="order" items="${orders}">
                    <div class="order-card">
                        <div class="order-header">
                            <div>
                                <span class="order-id-badge">
                                    <i class="material-icons" style="vertical-align: middle; font-size: 16px;">shopping_bag</i>
                                    Order #${order.orderId}
                                </span>
                            </div>
                            <div>
                                <span class="order-status">
                                    <i class="material-icons" style="vertical-align: middle; font-size: 16px;">check_circle</i>
                                    ${order.status}
                                </span>
                            </div>
                        </div>

                        <div class="profile-info">
                            <div class="profile-item">
                                <label>
                                    <i class="material-icons" style="vertical-align: middle; font-size: 14px;">calendar_today</i>
                                    Order Date:
                                </label>
                                <div class="value">${order.timestamp}</div>
                            </div>

                            <div class="profile-item">
                                <label>
                                    <i class="material-icons" style="vertical-align: middle; font-size: 14px;">payments</i>
                                    Total Amount:
                                </label>
                                <div class="value">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/> EGP
                                </div>
                            </div>

                            <div class="profile-item">
                                <label>
                                    <i class="material-icons" style="vertical-align: middle; font-size: 14px;">inventory</i>
                                    Items:
                                </label>
                                <div class="value">${order.productCount} products (${order.totalItems} items)</div>
                            </div>
                        </div>

                        <c:if test="${not empty order.products}">
                            <details style="margin-top: 15px;">
                                <summary>
                                    <i class="material-icons" style="vertical-align: middle; font-size: 18px;">expand_more</i>
                                    View Order Items
                                </summary>
                                <table style="margin-top: 15px;">
                                    <thead>
                                    <tr>
                                        <th>Product ID</th>
                                        <th>Quantity</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="product" items="${order.products}">
                                        <tr>
                                            <td>Product #${product.productId}</td>
                                            <td>${product.quantity} unit(s)</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </details>
                        </c:if>
                    </div>
                </c:forEach>

            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 40px;">
                    <i class="material-icons" style="font-size: 64px; color: #d0d0d0;">inbox</i>
                    <p style="font-size: 1.2em; color: #757575; margin-top: 15px;">
                        No orders found
                    </p>
                    <p style="color: #9e9e9e; margin-top: 10px;">
                        Start shopping to see your order history here!
                    </p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/" class="btn btn-success">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">shopping_cart</i>
            Continue Shopping
        </a>
        <a href="${pageContext.request.contextPath}/profile?customer_id=${customerId}" class="btn">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">person</i>
            View Profile
        </a>
    </div>
</div>

</body>
</html>
