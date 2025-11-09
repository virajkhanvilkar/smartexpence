package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import model.DBConnection;

public class DeleteExpenseServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int expId = Integer.parseInt(request.getParameter("id"));

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("DELETE FROM expenses WHERE id=?");
            ps.setInt(1, expId);
            ps.executeUpdate();

            HttpSession session = request.getSession();
            session.setAttribute("message", "🗑 Expense deleted successfully!");
            response.sendRedirect("view_exp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error deleting expense: " + e.getMessage() + "</h3>");
        }
    }
}
