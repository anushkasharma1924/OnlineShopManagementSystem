package com.onlineshop.controller;

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

@WebServlet("/DeleteProductServlet")
public class DeleteProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("admin_id") == null) {

            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        String idParameter =
            request.getParameter("id");

        if (idParameter == null) {

            response.sendRedirect(
                request.getContextPath() +
                "/admin-products.jsp"
            );

            return;
        }

        int productId =
            Integer.parseInt(idParameter);

        String sql =
            "DELETE FROM products WHERE product_id = ?";

        try (
            Connection connection =
                DBConnection.getConnection();

            PreparedStatement statement =
                connection.prepareStatement(sql)
        ) {

            statement.setInt(1, productId);

            statement.executeUpdate();

            response.sendRedirect(
                request.getContextPath() +
                "/admin-products.jsp"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.setContentType("text/html");

            response.getWriter().println(
                "<h2>Error Deleting Product</h2>"
            );

            response.getWriter().println(
                "<p>" + e.getMessage() + "</p>"
            );

            response.getWriter().println(
                "<br><a href='" +
                request.getContextPath() +
                "/admin-products.jsp'>" +
                "Back to Products</a>"
            );
        }
    }
}