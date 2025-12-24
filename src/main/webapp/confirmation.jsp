<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>

<div class="container">
    <div class="confirmation-box">
        <i class="material-icons" style="font-size: 64px; margin-bottom: 10px;">check_circle</i>
        <h2>Order Confirmed Successfully!</h2>
        <div class="order-id">
            Order #${orderId}
        </div>
        <p style="font-size: 1.2em;">Thank you for your purchase!</p>
    </div>

    <div class="card">
        <h3>Order Details</h3>

        <div class="profile-info">
            <div class="profile-item">
                <label>Order ID:</label>
                <div class="value">#${orderId}</div>
            </div>

            <div class="profile-item">
                <label>Customer ID:</label>
                <div class="value">${customerId}</div>
            </div>

            <div class="profile-item">
                <label>Status:</label>
                <div class="value" style="color: #43a047;">${orderStatus}</div>
            </div>

            <div class="profile-item">
                <label>Total Amount:</label>
                <div class="value">
                    <fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/> EGP
                </div>
            </div>
        </div>

        <c:if test="${not empty orderTimestamp}">
            <p style="margin-top: 15px; color: #757575;">
                <i class="material-icons" style="vertical-align: middle; font-size: 18px;">schedule</i>
                <strong>Order Time:</strong> ${orderTimestamp}
            </p>
        </c:if>
    </div>

    <c:if test="${not empty loyaltyPointsEarned}">
        <div class="card loyalty-card">
            <h3 style="color: white;">Loyalty Points Earned</h3>
            <div class="loyalty-points-display">
                <i class="material-icons" style="font-size: 48px;">card_giftcard</i>
                <p style="font-size: 1.5em; margin: 10px 0;">
                    +${loyaltyPointsEarned} Points
                </p>
                <p>Total Loyalty Points: <strong>${totalLoyaltyPoints}</strong></p>
            </div>
        </div>
    </c:if>

    <c:if test="${notificationSent}">
        <div class="success">
            <i class="material-icons" style="vertical-align: middle;">email</i>
            Order confirmation has been sent to your email and phone!
        </div>
    </c:if>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/" class="btn btn-success">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">home</i>
            Back to Catalog
        </a>
        <a href="${pageContext.request.contextPath}/orderHistory?customer_id=${customerId}" class="btn btn-secondary">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">receipt_long</i>
            View Order History
        </a>
        <a href="${pageContext.request.contextPath}/profile?customer_id=${customerId}" class="btn">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">person</i>
            View Profile
        </a>
    </div>

    <div class="info" style="margin-top: 30px;">
        <i class="material-icons" style="vertical-align: middle;">info</i>
        <strong>What's Next?</strong><br>
        Your order has been successfully placed and is being processed. You will receive updates via email and SMS.
        You can track your order status in the Order History section.
    </div>
</div>

</body>
</html>
