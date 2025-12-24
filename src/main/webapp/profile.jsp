<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Customer Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>

<div class="container">
    <h1>Customer Profile</h1>

    <nav>
        <a href="${pageContext.request.contextPath}/">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">home</i>
            Back to Catalog
        </a>
        <a href="${pageContext.request.contextPath}/orderHistory?customer_id=${customerId}">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">receipt_long</i>
            Order History
        </a>
    </nav>

    <div class="card">
        <h3>Personal Information</h3>

        <div class="profile-info">
            <div class="profile-item">
                <label>
                    <i class="material-icons" style="vertical-align: middle; font-size: 16px;">badge</i>
                    Customer ID:
                </label>
                <div class="value">${customerId}</div>
            </div>

            <div class="profile-item">
                <label>
                    <i class="material-icons" style="vertical-align: middle; font-size: 16px;">person</i>
                    Full Name:
                </label>
                <div class="value">${name}</div>
            </div>

            <div class="profile-item">
                <label>
                    <i class="material-icons" style="vertical-align: middle; font-size: 16px;">email</i>
                    Email Address:
                </label>
                <div class="value">${email}</div>
            </div>

            <div class="profile-item">
                <label>
                    <i class="material-icons" style="vertical-align: middle; font-size: 16px;">phone</i>
                    Phone Number:
                </label>
                <div class="value">${phone}</div>
            </div>

            <div class="profile-item">
                <label>
                    <i class="material-icons" style="vertical-align: middle; font-size: 16px;">calendar_today</i>
                    Member Since:
                </label>
                <div class="value">${createdAt}</div>
            </div>
        </div>
    </div>

    <div class="card loyalty-card">
        <h3 style="color: white; border-bottom-color: rgba(255,255,255,0.3);">
            <i class="material-icons" style="vertical-align: middle;">card_giftcard</i>
            Loyalty Program
        </h3>

        <div class="loyalty-points-display">
            <p style="font-size: 1.2em; margin-bottom: 10px;">Your Loyalty Points</p>
            <div class="loyalty-points-number">
                ${loyaltyPoints}
            </div>
            <p class="loyalty-points-info">
                Earn 1 point for every 10 EGP spent
            </p>
        </div>

        <div class="loyalty-tip">
            <p>
                <i class="material-icons" style="vertical-align: middle; font-size: 18px;">lightbulb</i>
                <strong>Tip:</strong> Collect more points with every purchase and unlock exclusive rewards!
            </p>
        </div>
    </div>

    <div class="info">
        <i class="material-icons" style="vertical-align: middle;">info</i>
        <strong>About Your Account</strong><br>
        Keep shopping to earn more loyalty points! Your points can be redeemed for discounts on future purchases.
        Check your order history to see all your past orders and track your shopping activity.
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/" class="btn btn-success">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">shopping_cart</i>
            Continue Shopping
        </a>
        <a href="${pageContext.request.contextPath}/orderHistory?customer_id=${customerId}" class="btn btn-secondary">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">receipt_long</i>
            View Order History
        </a>
    </div>
</div>

</body>
</html>
