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

    String idParameter = request.getParameter("id");

    if (idParameter == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin-products.jsp"
        );
        return;
    }

    int productId = Integer.parseInt(idParameter);

    String productName = "";
    String category = "";
    double price = 0;
    int quantity = 0;
    String description = "";

    String sql =
        "SELECT * FROM products WHERE product_id = ?";

    try (
        Connection connection =
            DBConnection.getConnection();

        PreparedStatement statement =
            connection.prepareStatement(sql)
    ) {

        statement.setInt(1, productId);

        ResultSet result =
            statement.executeQuery();

        if (result.next()) {

            productName =
                result.getString("product_name");

            category =
                result.getString("category");

            price =
                result.getDouble("price");

            quantity =
                result.getInt("quantity");

            description =
                result.getString("description");

        } else {

            response.sendRedirect(
                request.getContextPath() +
                "/admin-products.jsp"
            );

            return;
        }

    } catch (Exception e) {

        e.printStackTrace();

%>

        <h2>Error Loading Product</h2>

        <p><%= e.getMessage() %></p>

<%
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>
    <title>Edit Product</title>
</head>

<body>

<h1>Edit Product</h1>

<form action="${pageContext.request.contextPath}/EditProductServlet"
      method="post">

    <input type="hidden"
           name="product_id"
           value="<%= productId %>">

    <label>Product Name:</label><br>

    <input type="text"
           name="product_name"
           value="<%= productName %>"
           required>

    <br><br>

    <label>Category:</label><br>

    <input type="text"
           name="category"
           value="<%= category %>"
           required>

    <br><br>

    <label>Price:</label><br>

    <input type="number"
           name="price"
           value="<%= price %>"
           step="0.01"
           min="0"
           required>

    <br><br>

    <label>Quantity:</label><br>

    <input type="number"
           name="quantity"
           value="<%= quantity %>"
           min="0"
           required>

    <br><br>

    <label>Description:</label><br>

    <textarea name="description"
              rows="5"
              cols="40"
              required><%= description %></textarea>

    <br><br>

    <button type="submit">
        Update Product
    </button>

</form>

<br>

<a href="${pageContext.request.contextPath}/admin-products.jsp">
    Back to Manage Products
</a>

</body>
</html>