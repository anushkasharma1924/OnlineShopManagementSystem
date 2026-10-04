<%
    if (session.getAttribute("admin_id") == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin-login.jsp"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>
    <title>Add Product</title>
</head>

<body>

<h1>Add Product</h1>

<form action="${pageContext.request.contextPath}/AddProductServlet"
      method="post">

    <label>Product Name:</label><br>
    <input type="text"
           name="product_name"
           required>

    <br><br>

    <label>Category:</label><br>
    <input type="text"
           name="category"
           required>

    <br><br>

    <label>Price:</label><br>
    <input type="number"
           name="price"
           step="0.01"
           min="0"
           required>

    <br><br>

    <label>Quantity:</label><br>
    <input type="number"
           name="quantity"
           min="0"
           required>

    <br><br>

    <label>Description:</label><br>
    <textarea name="description"
              rows="5"
              cols="40"
              required></textarea>

    <br><br>

    <button type="submit">
        Add Product
    </button>

</form>

<br>

<a href="${pageContext.request.contextPath}/admin-dashboard.jsp">
    Back to Admin Dashboard
</a>

</body>
</html>