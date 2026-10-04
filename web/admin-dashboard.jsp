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
    <title>Admin Dashboard</title>
</head>

<body>

<h1>Admin Dashboard</h1>

<p>Welcome Admin!</p>

<hr>

<h3>Admin Menu</h3>

<a href="${pageContext.request.contextPath}/add-product.jsp">
    Add Product
</a>

<br><br>

<a href="${pageContext.request.contextPath}/admin-products.jsp">
    Manage Products
</a>

<br><br>

<a href="${pageContext.request.contextPath}/admin-orders.jsp">
    View Customer Orders
</a>

<br><br>

<a href="${pageContext.request.contextPath}/LogoutServlet">
    Logout
</a>

</body>
</html>