<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.onlineshop.util.DBConnection" %>

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
    <title>Manage Products</title>
</head>

<body>

<h1>Manage Products</h1>

<a href="${pageContext.request.contextPath}/add-product.jsp">
    Add New Product
</a>

<br><br>

<table border="1" cellpadding="10">

<tr>
    <th>ID</th>
    <th>Product Name</th>
    <th>Category</th>
    <th>Price</th>
    <th>Quantity</th>
    <th>Description</th>
    <th>Actions</th>
</tr>

<%
    String sql =
        "SELECT * FROM products " +
        "ORDER BY product_id DESC";

    try (
        Connection connection =
            DBConnection.getConnection();

        PreparedStatement statement =
            connection.prepareStatement(sql);

        ResultSet result =
            statement.executeQuery()
    ) {

        while (result.next()) {
%>

<tr>

    <td>
        <%= result.getInt("product_id") %>
    </td>

    <td>
        <%= result.getString("product_name") %>
    </td>

    <td>
        <%= result.getString("category") %>
    </td>

    <td>
        ?<%= result.getDouble("price") %>
    </td>

    <td>
        <%= result.getInt("quantity") %>
    </td>

    <td>
        <%= result.getString("description") %>
    </td>

    <td>

        <a href="${pageContext.request.contextPath}/edit-product.jsp?id=<%= result.getInt("product_id") %>">
            Edit
        </a>

        <br><br>

        <a href="${pageContext.request.contextPath}/DeleteProductServlet?id=<%= result.getInt("product_id") %>"
           onclick="return confirm('Are you sure you want to delete this product?');">
            Delete
        </a>

    </td>

</tr>

<%
        }

    } catch (Exception e) {

        e.printStackTrace();
%>

<tr>

    <td colspan="7">
        Error: <%= e.getMessage() %>
    </td>

</tr>

<%
    }
%>

</table>

<br><br>

<a href="${pageContext.request.contextPath}/admin-orders.jsp">
    View Customer Orders
</a>

<br><br>

<a href="${pageContext.request.contextPath}/admin-dashboard.jsp">
    Back to Admin Dashboard
</a>

</body>
</html>