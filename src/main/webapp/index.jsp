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
        <a href="${pageContext.request.contextPath}/profile?customer_id=1" id="profileLink">
            <i class="material-icons" style="vertical-align: middle; font-size: 18px;">person</i>
            View Profile
        </a>
        <a href="${pageContext.request.contextPath}/orderHistory?customer_id=1" id="orderHistoryLink">
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

    <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">

        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h3 style="margin: 0;">Available Products</h3>
                <div id="cartSummary" class="cart-summary" style="display: none;">
                    <i class="material-icons" style="vertical-align: middle; font-size: 18px;">shopping_cart</i>
                    <span id="selectedCount">0</span> item(s) selected
                </div>
            </div>

            <c:if test="${not empty products}">
                <div style="margin-bottom: 15px; padding: 12px; background: #f5f5f5; border-radius: 6px; display: flex; gap: 10px; align-items: center;">
                    <input type="checkbox" id="selectAll" style="width: 18px; height: 18px; cursor: pointer;">
                    <label for="selectAll" style="cursor: pointer; font-weight: 600; margin: 0;">Select All Products</label>
                    <button type="button" id="clearSelection" class="btn-clear" style="margin-left: auto; padding: 6px 14px; font-size: 12px;">
                        <i class="material-icons" style="vertical-align: middle; font-size: 16px;">clear</i>
                        Clear Selection
                    </button>
                </div>
            </c:if>

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
                            <tr class="product-row" data-product-id="${p.product_id}">
                                <td>
                                    <input type="checkbox"
                                           name="product_id"
                                           value="${p.product_id}"
                                           id="product_${p.product_id}"
                                           class="product-checkbox">
                                </td>
                                <td><label for="product_${p.product_id}" style="cursor: pointer;">${p.product_name}</label></td>
                                <td><strong>${p.unit_price}</strong> EGP</td>
                                <td>
                                    <span class="stock-badge ${p.quantity_available > 10 ? 'in-stock' : p.quantity_available > 0 ? 'low-stock' : 'out-of-stock'}">
                                        ${p.quantity_available} units
                                    </span>
                                </td>
                                <td>
                                    <input type="number"
                                           name="quantity_${p.product_id}"
                                           class="quantity-input"
                                           min="1"
                                           max="${p.quantity_available}"
                                           value="1"
                                           data-product-id="${p.product_id}"
                                           disabled>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 50px;">
                                <i class="material-icons" style="font-size: 64px; color: #d0d0d0; display: block; margin-bottom: 15px;">inventory_2</i>
                                <strong style="font-size: 1.2em; color: #757575;">No products available at the moment.</strong>
                                <p style="color: #9e9e9e; margin-top: 10px;">Please check back later or contact support.</p>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <div class="card">
            <h3>Customer Information</h3>
            <label for="customer_id">Select Customer:</label>
            <select id="customer_id" name="customer_id" required style="max-width: 300px;">
                <option value="1" selected>1 - Ahmed Hassan</option>
                <option value="2">2 - Sara Mohamed</option>
                <option value="3">3 - Omar Ali</option>
            </select>
            <small style="color: #757575; display: block; margin-top: 8px;">
                <i class="material-icons" style="vertical-align: middle; font-size: 14px;">info</i>
                Select your customer profile to continue
            </small>
        </div>

        <div class="actions">
            <button type="submit" class="btn btn-success" id="checkoutBtn">
                <i class="material-icons" style="vertical-align: middle; font-size: 18px;">shopping_cart</i>
                Proceed to Checkout
            </button>
        </div>
    </form>
</div>

<script>
(function() {
    // Get all product checkboxes and quantity inputs
    const productCheckboxes = document.querySelectorAll('.product-checkbox');
    const quantityInputs = document.querySelectorAll('.quantity-input');
    const selectAllCheckbox = document.getElementById('selectAll');
    const clearSelectionBtn = document.getElementById('clearSelection');
    const checkoutForm = document.getElementById('checkoutForm');
    const cartSummary = document.getElementById('cartSummary');
    const selectedCountSpan = document.getElementById('selectedCount');
    const checkoutBtn = document.getElementById('checkoutBtn');

    // Update cart summary
    function updateCartSummary() {
        const selected = document.querySelectorAll('.product-checkbox:checked');
        const count = selected.length;
        
        if (count > 0) {
            cartSummary.style.display = 'inline-flex';
            selectedCountSpan.textContent = count;
        } else {
            cartSummary.style.display = 'none';
        }
    }

    // Enable/disable quantity inputs based on checkbox state
    function toggleQuantityInput(checkbox) {
        const productId = checkbox.value;
        const quantityInput = document.querySelector(`.quantity-input[data-product-id="${productId}"]`);
        if (quantityInput) {
            quantityInput.disabled = !checkbox.checked;
            if (!checkbox.checked) {
                quantityInput.value = 1;
            }
        }
        
        // Toggle row highlight
        const row = checkbox.closest('.product-row');
        if (row) {
            row.classList.toggle('selected', checkbox.checked);
        }
    }

    // Handle individual checkbox changes
    productCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            toggleQuantityInput(this);
            updateCartSummary();
            updateSelectAllState();
        });
    });

    // Handle quantity input changes
    quantityInputs.forEach(input => {
        input.addEventListener('change', function() {
            const max = parseInt(this.getAttribute('max'));
            const value = parseInt(this.value);
            if (value > max) {
                this.value = max;
                alert(`Maximum available quantity is ${max}`);
            } else if (value < 1) {
                this.value = 1;
            }
        });
    });

    // Select All functionality
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            const isChecked = this.checked;
            productCheckboxes.forEach(checkbox => {
                checkbox.checked = isChecked;
                toggleQuantityInput(checkbox);
            });
            updateCartSummary();
        });
    }

    // Clear Selection functionality
    if (clearSelectionBtn) {
        clearSelectionBtn.addEventListener('click', function() {
            productCheckboxes.forEach(checkbox => {
                checkbox.checked = false;
                toggleQuantityInput(checkbox);
            });
            if (selectAllCheckbox) {
                selectAllCheckbox.checked = false;
            }
            updateCartSummary();
        });
    }

    // Update Select All checkbox state
    function updateSelectAllState() {
        if (!selectAllCheckbox) return;
        const allChecked = productCheckboxes.length > 0 && 
                          Array.from(productCheckboxes).every(cb => cb.checked);
        const someChecked = Array.from(productCheckboxes).some(cb => cb.checked);
        selectAllCheckbox.checked = allChecked;
        selectAllCheckbox.indeterminate = someChecked && !allChecked;
    }

    // Form validation
    if (checkoutForm) {
        checkoutForm.addEventListener('submit', function(e) {
            const selectedProducts = document.querySelectorAll('.product-checkbox:checked');
            
            if (selectedProducts.length === 0) {
                e.preventDefault();
                alert('Please select at least one product to proceed to checkout.');
                return false;
            }

            // Validate quantities
            let hasInvalidQuantity = false;
            selectedProducts.forEach(checkbox => {
                const productId = checkbox.value;
                const quantityInput = document.querySelector(`.quantity-input[data-product-id="${productId}"]`);
                if (quantityInput) {
                    const quantity = parseInt(quantityInput.value);
                    const max = parseInt(quantityInput.getAttribute('max'));
                    if (quantity < 1 || quantity > max) {
                        hasInvalidQuantity = true;
                    }
                }
            });

            if (hasInvalidQuantity) {
                e.preventDefault();
                alert('Please ensure all quantities are valid (between 1 and available stock).');
                return false;
            }

            // Show loading state
            checkoutBtn.disabled = true;
            checkoutBtn.innerHTML = '<i class="material-icons" style="vertical-align: middle; font-size: 18px;">hourglass_empty</i> Processing...';
        });
    }

    // Initialize: disable all quantity inputs initially
    quantityInputs.forEach(input => {
        input.disabled = true;
    });

    // Update navigation links when customer ID changes
    const customerSelect = document.getElementById('customer_id');
    const profileLink = document.getElementById('profileLink');
    const orderHistoryLink = document.getElementById('orderHistoryLink');
    
    if (customerSelect) {
        customerSelect.addEventListener('change', function() {
            const customerId = this.value;
            if (profileLink) {
                profileLink.href = profileLink.href.split('?')[0] + '?customer_id=' + customerId;
            }
            if (orderHistoryLink) {
                orderHistoryLink.href = orderHistoryLink.href.split('?')[0] + '?customer_id=' + customerId;
            }
        });
    }

    // Smooth scroll to top on page load if there's an error
    if (document.querySelector('.error')) {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }
})();
</script>

</body>
</html>
