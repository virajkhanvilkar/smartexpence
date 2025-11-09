package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import model.DBConnection;

public class AddExpenseServlet extends HttpServlet {

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
        String category = request.getParameter("category");
        String amountStr = request.getParameter("amount");
        String expDateStr = request.getParameter("expDate");

        // ✅ Check for missing fields
        if (category == null || amountStr == null || expDateStr == null ||
            category.trim().isEmpty() || amountStr.trim().isEmpty() || expDateStr.trim().isEmpty()) {

            session.setAttribute("message", "⚠ Please fill all fields before adding an expense!");
            response.sendRedirect("home.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            double amount = Double.parseDouble(amountStr);

            // ✅ Parse date from dd-MM-yyyy or yyyy-MM-dd
            LocalDate expDate;
            if (expDateStr.contains("-")) {
                // Already yyyy-MM-dd (HTML date input format)
                expDate = LocalDate.parse(expDateStr);
            } else {
                // Fallback for dd-MM-yyyy input (if user entered manually)
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
                expDate = LocalDate.parse(expDateStr, formatter);
            }

            // ✅ Insert expense with proper date
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO expenses (user_id, category, amount, date) VALUES (?, ?, ?, ?)");
            ps.setInt(1, userId);
            ps.setString(2, category);
            ps.setDouble(3, amount);
            ps.setTimestamp(4, Timestamp.valueOf(expDate.atStartOfDay()));
            ps.executeUpdate();

            // ✅ Success message
            session.setAttribute("message",
                "✅ Expense added successfully: " + category + " ₹" + amount + " on " + expDate + ".");
            response.sendRedirect("home.jsp");

        } catch (NumberFormatException nfe) {
            session.setAttribute("message", "❌ Invalid amount entered! Please enter a number.");
            response.sendRedirect("home.jsp");
        } catch (SQLException sqle) {
            sqle.printStackTrace();
            session.setAttribute("message", "❌ Database error: " + sqle.getMessage());
            response.sendRedirect("home.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "❌ Unexpected error: " + e.getMessage());
            response.sendRedirect("home.jsp");
        }
    }
}
