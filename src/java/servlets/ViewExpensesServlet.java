package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import model.DBConnection;

public class ViewExpensesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("userId");

        if (userIdObj == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = userIdObj;
        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT id, category, amount, date FROM expenses WHERE user_id=? ORDER BY date DESC");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("id", rs.getInt("id"));
                map.put("category", rs.getString("category"));
                map.put("amount", rs.getDouble("amount"));
                map.put("date", rs.getTimestamp("date"));
                list.add(map);
            }

            request.setAttribute("expenses", list);
            RequestDispatcher rd = request.getRequestDispatcher("view_exp.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
