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
    <title>Customer Orders</title>
</head>

<body>

<h1>Customer Orders</h1>

<table border="1" cellpadding="10">

<tr>

    <th>Order ID</th>
    <th>Customer ID</th>
    <th>Total Amount</th>
    <th>Order Date</th>
    <th>Status</th>
    <th>Update Status</th>

</tr>

<%
    String sql =
        "SELECT * FROM orders " +
        "ORDER BY order_id DESC";

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
        <%= result.getInt("order_id") %>
    </td>

    <td>
        <%= result.getInt("customer_id") %>
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

    <td>

        <form action="${pageContext.request.contextPath}/UpdateOrderStatusServlet"
              method="post">

            <input type="hidden"
                   name="order_id"
                   value="<%= result.getInt("order_id") %>">

            <select name="status">

                <option value="Order Placed"
                    <%= "Order Placed".equals(result.getString("status")) ? "selected" : "" %>>
                    Order Placed
                </option>

                <option value="Processing"
                    <%= "Processing".equals(result.getString("status")) ? "selected" : "" %>>
                    Processing
                </option>

                <option value="Shipped"
                    <%= "Shipped".equals(result.getString("status")) ? "selected" : "" %>>
                    Shipped
                </option>

                <option value="Delivered"
                    <%= "Delivered".equals(result.getString("status")) ? "selected" : "" %>>
                    Delivered
                </option>

                <option value="Cancelled"
                    <%= "Cancelled".equals(result.getString("status")) ? "selected" : "" %>>
                    Cancelled
                </option>

            </select>

            <button type="submit">
                Update
            </button>

        </form>

    </td>

</tr>

<%
        }

    } catch (Exception e) {

        e.printStackTrace();
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

<br><br>

<a href="${pageContext.request.contextPath}/admin-dashboard.jsp">
    Back to Admin Dashboard
</a>

</body>
</html>