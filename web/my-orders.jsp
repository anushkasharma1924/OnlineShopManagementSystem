
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.onlineshop.util.DBConnection" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>

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

    String sql =
        "SELECT order_id, total_amount, order_date, status " +
        "FROM orders " +
        "WHERE customer_id = ? " +
        "ORDER BY order_date DESC";
%>

<h1>My Orders</h1>

<table>

    <tr>
        <th>Order ID</th>
        <th>Total Amount</th>
        <th>Order Date</th>
        <th>Status</th>
    </tr>

<%
    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
            connection.prepareStatement(sql)
    ) {

        statement.setInt(1, customerId);

        ResultSet result = statement.executeQuery();

        boolean hasOrders = false;

        while (result.next()) {

            hasOrders = true;
%>

    <tr>

        <td>
            <%= result.getInt("order_id") %>
        </td>

        <td>
            ?<%= result.getDouble("total_amount") %>
        </td>

        <td>
            <%= result.getTimestamp("order_date") %>
        </td>

        <td>
            <%= result.getString("status") %>
        </td>

    </tr>

<%
        }

        if (!hasOrders) {
%>

    <tr>
        <td colspan="4">
            No orders found.
        </td>
    </tr>

<%
        }

    } catch (Exception e) {
%>

    <tr>
        <td colspan="4">
            Error: <%= e.getMessage() %>
        </td>
    </tr>

<%
    }
%>

</table>

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
