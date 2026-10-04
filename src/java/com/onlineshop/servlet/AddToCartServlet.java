package com.onlineshop.servlet;

import com.onlineshop.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {

@Override
protected void doPost(HttpServletRequest request,
                       HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    if (session == null ||
        session.getAttribute("customer_id") == null) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    int customerId = Integer.parseInt(
            session.getAttribute("customer_id").toString()
    );

    int productId = Integer.parseInt(
            request.getParameter("product_id")
    );

    int quantity = Integer.parseInt(
            request.getParameter("quantity")
    );

    if (quantity <= 0) {
        response.getWriter().println("Invalid quantity");
        return;
    }

    String sql = "INSERT INTO cart "
               + "(customer_id, product_id, quantity) "
               + "VALUES (?, ?, ?)";

    try (
        Connection connection = DBConnection.getConnection();
        PreparedStatement statement =
                connection.prepareStatement(sql)
    ) {

        statement.setInt(1, customerId);
        statement.setInt(2, productId);
        statement.setInt(3, quantity);

        statement.executeUpdate();

        response.sendRedirect(
                request.getContextPath() + "/cart.jsp"
        );

    } catch (Exception e) {

        e.printStackTrace();

        response.setContentType("text/html");

        response.getWriter().println(
                "<h2>Error while adding product to cart</h2>"
        );

        response.getWriter().println(
                "<p>" + e.getMessage() + "</p>"
        );
    }
}

}
