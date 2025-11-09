package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import model.DBConnection;

public class EditExpenseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int expId = Integer.parseInt(request.getParameter("id"));
        String category = request.getParameter("category");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String date = request.getParameter("date");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE expenses SET category=?, amount=?, date=? WHERE id=?");
            ps.setString(1, category);
            ps.setDouble(2, amount);
            ps.setString(3, date);
            ps.setInt(4, expId);
            ps.executeUpdate();

            HttpSession session = request.getSession();
            session.setAttribute("message", "✅ Expense updated successfully!");
            response.sendRedirect("view_exp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error updating expense: " + e.getMessage() + "</h3>");
        }
    }
}
