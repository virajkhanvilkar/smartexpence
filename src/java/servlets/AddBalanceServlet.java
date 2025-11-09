package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import model.DBConnection;

public class AddBalanceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("userId");

        if (userIdObj == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = userIdObj;
        String balanceStr = request.getParameter("balance");
        String fromStr = request.getParameter("fromDate");
        String toStr = request.getParameter("toDate");

        if (balanceStr == null || fromStr == null || toStr == null ||
            balanceStr.trim().isEmpty() || fromStr.trim().isEmpty() || toStr.trim().isEmpty()) {
            session.setAttribute("message", "⚠ Please fill all fields (Balance, From, and To Dates)!");
            response.sendRedirect("home.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            double balance = Double.parseDouble(balanceStr);

            LocalDate from = LocalDate.parse(fromStr);
            LocalDate to = LocalDate.parse(toStr);
            long totalDays = ChronoUnit.DAYS.between(from, to) + 1;

            String monthName = from.getMonth().toString() + " " + from.getYear();

            // ✅ Check if balance for this user & date range exists
            PreparedStatement psCheck = conn.prepareStatement(
                "SELECT user_id FROM balance WHERE user_id = ? AND start_date = ? AND end_date = ?");
            psCheck.setInt(1, userId);
            psCheck.setDate(2, java.sql.Date.valueOf(from));
            psCheck.setDate(3, java.sql.Date.valueOf(to));
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                // ✅ Update existing record
                PreparedStatement psUpdate = conn.prepareStatement(
                    "UPDATE balance SET month_balance = ?, total_days = ?, month_name = ? WHERE user_id = ? AND start_date = ? AND end_date = ?");
                psUpdate.setDouble(1, balance);
                psUpdate.setLong(2, totalDays);
                psUpdate.setString(3, monthName);
                psUpdate.setInt(4, userId);
                psUpdate.setDate(5, java.sql.Date.valueOf(from));
                psUpdate.setDate(6, java.sql.Date.valueOf(to));
                psUpdate.executeUpdate();

                session.setAttribute("message", "✅ Balance updated for period " + fromStr + " to " + toStr + ".");
            } else {
                // ✅ Insert new record
                PreparedStatement psInsert = conn.prepareStatement(
                    "INSERT INTO balance (user_id, month_name, month_balance, total_days, start_date, end_date) VALUES (?, ?, ?, ?, ?, ?)");
                psInsert.setInt(1, userId);
                psInsert.setString(2, monthName);
                psInsert.setDouble(3, balance);
                psInsert.setLong(4, totalDays);
                psInsert.setDate(5, java.sql.Date.valueOf(from));
                psInsert.setDate(6, java.sql.Date.valueOf(to));
                psInsert.executeUpdate();

                session.setAttribute("message", "✅ Balance set from " + fromStr + " to " + toStr + ".");
            }

            response.sendRedirect("home.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "❌ Error: " + e.getMessage());
            response.sendRedirect("home.jsp");
        }
    }
}
