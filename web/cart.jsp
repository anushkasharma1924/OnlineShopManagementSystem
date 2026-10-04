<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.onlineshop.util.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Cart</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background-color: #f5f5f5;
        }

        h1 {
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
        }

        th {
            background-color: #333;
            color: white;
            padding: 12px;
        }

        td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ddd;
        }

        .total {
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            margin-top: 20px;
        }

        .order-section {
            text-align: right;
            margin-top: 15px;
        }

        .order-button {
            padding: 10px 20px;
            background-color: #333;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .order-button:hover {
            background-color: #555;
        }

        .links {
            text-align: center;
            margin-top: 25px;
        }

        .links a {
            margin: 10px;
        }
    </style>
</head>

<body>

<%
    HttpSession sessionObj = request.getSession(false);

    if (sessionObj == null ||
        sessionObj.getAttribute("customer_id") == null) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    int customerId = Integer.parseInt(
        sessionObj.getAttribute("customer_id").toString()
    );

    double grandTotal = 0;

    String sql =
        "SELECT c.cart_id, p.product_name, p.price, " +
        "c.quantity, (p.price * c.quantity) AS total " +
        "FROM cart c " +
        "JOIN products p ON c.product_id = p.product_id " +
        "WHERE c.customer_id = ?";
%>

<h1>My Shopping Cart</h1>

<table>

    <tr>
        <th>Cart ID</th>
        <th>Product Name</th>
        <th>Price</th>
        <th>Quantity</th>
        <th>Total</th>
        <th>Action</th>
    </tr>

<%
    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
            connection.prepareStatement(sql)
    ) {

        statement.setInt(1, customerId);

        ResultSet result = statement.executeQuery();

        boolean hasItems = false;

        while (result.next()) {

            hasItems = true;

            double total = result.getDouble("total");
            grandTotal += total;
%>

    <tr>

        <td>
            <%= result.getInt("cart_id") %>
        </td>

        <td>
            <%= result.getString("product_name") %>
        </td>

        <td>
            ?<%= result.getDouble("price") %>
        </td>

        <td>
            <%= result.getInt("quantity") %>
        </td>

        <td>
            ?<%= total %>
        </td>

        <td>
            <a href="<%= request.getContextPath() %>/RemoveFromCartServlet?cart_id=<%= result.getInt("cart_id") %>">
                Remove
            </a>
        </td>

    </tr>

<%
        }

        if (!hasItems) {
%>

    <tr>
        <td colspan="6">
            Your cart is empty.
        </td>
    </tr>

<%
        }

    } catch (Exception e) {
%>

    <tr>
        <td colspan="6">
            Error: <%= e.getMessage() %>
        </td>
    </tr>

<%
    }
%>

</table>

<div class="total">
    Grand Total: ?<%= grandTotal %>
</div>

<%
    if (grandTotal > 0) {
%>

<div class="order-section">

    <form action="<%= request.getContextPath() %>/PlaceOrderServlet"
          method="post">

        <button type="submit" class="order-button">
            Place Order
        </button>

    </form>

</div>

<%
    }
%>

<div class="links">

    <a href="<%= request.getContextPath() %>/products.jsp">
        Continue Shopping
    </a>

    <br><br>

    <a href="<%= request.getContextPath() %>/customer-dashboard.jsp">
        Back to Dashboard
    </a>

</div>

</body>
</html>

