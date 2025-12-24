<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
  <title>Checkout - Review Your Order</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>

<div class="container">
  <h1>Order Checkout</h1>

  <nav>
    <a href="${pageContext.request.contextPath}/">
      <i class="material-icons" style="vertical-align: middle; font-size: 18px;">arrow_back</i>
      Back to Catalog
    </a>
  </nav>

  <div class="checkout-container">
    <!-- Order Items Section -->
    <div class="order-items">
      <h2>Order Items</h2>

      <table>
        <thead>
        <tr>
          <th>Product</th>
          <th>Unit Price</th>
          <th>Quantity</th>
          <th>Subtotal</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${orderItems}">
          <tr>
            <td><strong>${item.productName}</strong></td>
            <td><fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/> EGP</td>
            <td>${item.quantity}</td>
            <td><fmt:formatNumber value="${item.subtotal}" pattern="#,##0.00"/> EGP</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>

      <div class="order-summary">
        <table style="width: 100%; box-shadow: none; border: none;">
          <tr>
            <td><strong>Subtotal:</strong></td>
            <td style="text-align: right;">
              <fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/> EGP
            </td>
          </tr>
          <c:if test="${discount > 0}">
            <tr>
              <td><strong>Discount:</strong></td>
              <td style="text-align: right; color: #43a047;">
                -<fmt:formatNumber value="${discount}" pattern="#,##0.00"/> EGP
              </td>
            </tr>
          </c:if>
          <c:if test="${tax > 0}">
            <tr>
              <td><strong>Tax:</strong></td>
              <td style="text-align: right;">
                <fmt:formatNumber value="${tax}" pattern="#,##0.00"/> EGP
              </td>
            </tr>
          </c:if>
        </table>

        <div class="order-total">
          Total: <fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/> EGP
        </div>
      </div>
    </div>

    <!-- Customer Information Section -->
    <div class="customer-info">
      <h2>Customer Information</h2>
      <p><strong>Customer ID:</strong> ${customerId}</p>
      <div style="margin-top: 20px; padding: 16px; background: #fff3cd; border-radius: 6px; border-left: 4px solid #ffc107; display: flex; align-items: center; gap: 10px;">
        <i class="material-icons" style="color: #f57c00; font-size: 24px;">warning</i>
        <div>
          <strong>Please review your order carefully before confirming.</strong>
          <p style="margin: 8px 0 0 0; font-size: 13px; color: #856404;">Once confirmed, your order will be processed and cannot be cancelled.</p>
        </div>
      </div>
    </div>
  </div>

  <!-- Action Buttons -->
  <div class="actions">
    <form action="${pageContext.request.contextPath}/confirmOrder" method="post" style="display: inline;" id="confirmForm">
      <input type="hidden" name="customer_id" value="${customerId}">
      <input type="hidden" name="total_amount" value="${totalAmount}">
      <input type="hidden" name="products_json" value="${productsJson}">

      <button type="submit" class="btn btn-success" id="confirmBtn">
        <i class="material-icons" style="vertical-align: middle; font-size: 18px;">check_circle</i>
        Confirm Order
      </button>
    </form>

    <a href="${pageContext.request.contextPath}/" class="btn btn-cancel" id="cancelBtn">
      <i class="material-icons" style="vertical-align: middle; font-size: 18px;">cancel</i>
      Cancel
    </a>
  </div>
</div>

<script>
(function() {
    const confirmForm = document.getElementById('confirmForm');
    const confirmBtn = document.getElementById('confirmBtn');
    const cancelBtn = document.getElementById('cancelBtn');

    if (confirmForm) {
        confirmForm.addEventListener('submit', function(e) {
            // Show loading state
            confirmBtn.disabled = true;
            cancelBtn.style.pointerEvents = 'none';
            cancelBtn.style.opacity = '0.6';
            confirmBtn.innerHTML = '<i class="material-icons" style="vertical-align: middle; font-size: 18px;">hourglass_empty</i> Processing Order...';
        });
    }
})();
</script>

</body>
</html>
