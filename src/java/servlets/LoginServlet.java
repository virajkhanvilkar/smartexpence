package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import model.DBConnection;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get login details from form
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {

            // ✅ Secure SQL Query
            String query = "SELECT id FROM users WHERE username = ? AND password = ?";
            PreparedStatement ps = conn.prepareStatement(query);
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ Successful Login
                int userId = rs.getInt("id");

                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", username);

                response.sendRedirect("home.jsp");
            } else {
                // ❌ Invalid Credentials
                request.setAttribute("error", "Invalid username or password!");
                RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Optional: Forward to error page instead of raw HTML
            request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
        }
    }
}
