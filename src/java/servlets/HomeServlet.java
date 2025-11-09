package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import model.DBConnection;

public class HomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("userId");
        if (userIdObj == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = userIdObj;

        try (Connection conn = DBConnection.getConnection()) {
            Statement st = conn.createStatement();

            // Fetch balance info
            ResultSet rb = st.executeQuery("SELECT month_balance, total_days FROM balance WHERE user_id=" + userId);
            double monthBalance = 0;
            int totalDays = 0;
            if (rb.next()) {
                monthBalance = rb.getDouble("month_balance");
                totalDays = rb.getInt("total_days");
            }

            // Fetch expenses info
            ResultSet re = st.executeQuery("SELECT SUM(amount) AS total_spent FROM expenses WHERE user_id=" + userId);
            double totalSpent = 0;
            if (re.next()) {
                totalSpent = re.getDouble("total_spent");
            }

            double remaining = monthBalance - totalSpent;
            double dailyLimit = (totalDays > 0) ? (monthBalance / totalDays) : 0;

            request.setAttribute("remaining", remaining);
            request.setAttribute("dailyLimit", dailyLimit);
            request.setAttribute("totalSpent", totalSpent);

            RequestDispatcher rd = request.getRequestDispatcher("home.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
