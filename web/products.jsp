<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.onlineshop.util.DBConnection" %>

<!DOCTYPE html>
<html>
<head>

    <title>Products</title>

</head>

<body>

<h1>Products</h1>

<!-- Search Products -->

<form method="get"
      action="${pageContext.request.contextPath}/products.jsp">

    <input type="text"
           name="search"
           placeholder="Search product or category"
           value="<%= request.getParameter("search") == null
                   ? "" : request.getParameter("search") %>">

    <button type="submit">
        Search
    </button>

</form>

<br>

<a href="${pageContext.request.contextPath}/products.jsp">
    View All Products
</a>

<br><br>

<hr>

<%
    String search = request.getParameter("search");

    String sql;

    if (search == null || search.trim().isEmpty()) {

        sql =
            "SELECT * FROM products " +
            "ORDER BY product_id DESC";

    } else {

        sql =
            "SELECT * FROM products " +
            "WHERE product_name LIKE ? " +
            "OR category LIKE ? " +
            "ORDER BY product_id DESC";
    }

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
            connection.prepareStatement(sql)
    ) {

        if (search != null && !search.trim().isEmpty()) {

            String keyword = "%" + search.trim() + "%";

            statement.setString(1, keyword);
            statement.setString(2, keyword);
        }

        ResultSet result = statement.executeQuery();

        boolean productFound = false;

        while (result.next()) {

            productFound = true;

%>

            <div>

                <h2>
                    <%= result.getString("product_name") %>
                </h2>

                <p>
                    <b>Category:</b>
                    <%= result.getString("category") %>
                </p>

                <p>
                    <b>Price:</b>
                    ?<%= result.getDouble("price") %>
                </p>

                <p>
                    <b>Available Quantity:</b>
                    <%= result.getInt("quantity") %>
                </p>

                <p>
                    <b>Description:</b>
                    <%= result.getString("description") %>
                </p>

                <form method="post"
                      action="${pageContext.request.contextPath}/AddToCartServlet">

                    <input type="hidden"
                           name="product_id"
                           value="<%= result.getInt("product_id") %>">

                    <label>Quantity:</label>

                    <input type="number"
                           name="quantity"
                           value="1"
                           min="1"
                           max="<%= result.getInt("quantity") %>"
                           required>

                    <button type="submit">
                        Add to Cart
                    </button>

                </form>

                <hr>

            </div>

<%
        }

        if (!productFound) {
%>

            <h3>No products found.</h3>

            <p>
                Try another product name or category.
            </p>

<%
        }

    } catch (Exception e) {

        e.printStackTrace();

%>

        <h2>Error while loading products</h2>

        <p>
            <%= e.getMessage() %>
        </p>

<%
    }
%>

<br>

<a href="${pageContext.request.contextPath}/cart.jsp">
    My Cart
</a>

<br><br>

<a href="${pageContext.request.contextPath}/customer-dashboard.jsp">
    Back to Customer Dashboard
</a>

</body>
</html>