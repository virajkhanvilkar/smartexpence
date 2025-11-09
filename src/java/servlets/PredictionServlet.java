package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.time.LocalDate;
import model.DBConnection;

public class PredictionServlet extends HttpServlet {
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

            ResultSet rb = st.executeQuery(
                "SELECT month_balance, total_days FROM balance WHERE user_id=" + userId);
            double monthBalance = 0;
            int totalDays = 0;
            if (rb.next()) {
                monthBalance = rb.getDouble("month_balance");
                totalDays = rb.getInt("total_days");
            }

            ResultSet re = st.executeQuery(
                "SELECT SUM(amount) AS total_spent, COUNT(*) AS days_spent FROM expenses WHERE user_id=" + userId);
            double totalSpent = 0;
            int daysSpent = 0;
            if (re.next()) {
                totalSpent = re.getDouble("total_spent");
                daysSpent = re.getInt("days_spent");
            }

            double remaining = monthBalance - totalSpent;
            int daysLeft = totalDays - daysSpent;
            double dailyLimit = daysLeft > 0 ? remaining / daysLeft : 0;

            // ✅ Check today's expenses
            LocalDate today = LocalDate.now();
            PreparedStatement pstoday = conn.prepareStatement(
                "SELECT SUM(amount) AS today_total FROM expenses WHERE user_id=? AND DATE(date)=?");
            pstoday.setInt(1, userId);
            pstoday.setString(2, today.toString());
            ResultSet rtoday = pstoday.executeQuery();

            double todaySpent = 0;
            if (rtoday.next()) todaySpent = rtoday.getDouble("today_total");

            // ✅ Overspending logic
            double overSpent = todaySpent > dailyLimit ? todaySpent - dailyLimit : 0;
            String alertMsg;

            if (overSpent > 0) {
                remaining -= overSpent; // deduct overspent from remaining
                alertMsg = "⚠ You spent ₹" + String.format("%.2f", todaySpent)
                         + " today — ₹" + String.format("%.2f", overSpent)
                         + " over your limit!";
            } else {
                alertMsg = "✅ You’re within your daily limit. Spent ₹"
                         + String.format("%.2f", todaySpent) + " today.";
            }

            // ✅ Format all double values to 2 decimals
            request.setAttribute("alert", alertMsg);
            request.setAttribute("balance", String.format("%.2f", monthBalance));
            request.setAttribute("spent", String.format("%.2f", totalSpent));
            request.setAttribute("remaining", String.format("%.2f", remaining));
            request.setAttribute("daysLeft", daysLeft);
            request.setAttribute("dailyLimit", String.format("%.2f", dailyLimit));

            // Store in session for dashboard use
            session.setAttribute("remaining", String.format("%.2f", remaining));
            session.setAttribute("dailyLimit", String.format("%.2f", dailyLimit));
            session.setAttribute("todaySpent", String.format("%.2f", todaySpent));
            session.setAttribute("overSpent", String.format("%.2f", overSpent));

            RequestDispatcher rd = request.getRequestDispatcher("predict.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
