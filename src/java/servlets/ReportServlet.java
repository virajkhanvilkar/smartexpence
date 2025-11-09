package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import model.DBConnection;

public class ReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String monthParam = request.getParameter("month");

        if (userId == null || monthParam == null || monthParam.trim().isEmpty()) {
            response.sendRedirect("home.jsp");
            return;
        }

        // Extract month and year from input like "November 2025"
        String[] parts = monthParam.split(" ");
        String monthName = parts[0];
        int year = Integer.parseInt(parts[1]);

        // Convert month name to number (e.g., November → 11)
        Map<String, Integer> monthMap = new HashMap<>();
        monthMap.put("January", 1); monthMap.put("February", 2); monthMap.put("March", 3);
        monthMap.put("April", 4); monthMap.put("May", 5); monthMap.put("June", 6);
        monthMap.put("July", 7); monthMap.put("August", 8); monthMap.put("September", 9);
        monthMap.put("October", 10); monthMap.put("November", 11); monthMap.put("December", 12);

        int monthNum = monthMap.getOrDefault(monthName, 0);

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT category, SUM(amount) AS total " +
                "FROM expenses WHERE user_id=? AND MONTH(date)=? AND YEAR(date)=? " +
                "GROUP BY category"
            );
            ps.setInt(1, userId);
            ps.setInt(2, monthNum);
            ps.setInt(3, year);
            ResultSet rs = ps.executeQuery();

            List<String> categories = new ArrayList<>();
            List<Double> amounts = new ArrayList<>();

            while (rs.next()) {
                categories.add("\"" + rs.getString("category") + "\"");
                amounts.add(rs.getDouble("total"));
            }

            if (categories.isEmpty()) {
                request.setAttribute("noData", "⚠ No expenses found for " + monthParam + ".");
            }

            request.setAttribute("categories", categories.toString());
            request.setAttribute("amounts", amounts.toString());
            request.setAttribute("selectedMonth", monthParam);

            RequestDispatcher rd = request.getRequestDispatcher("report.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
