<%@page import="java.sql.*, model.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Expense</title>
    <style>
        body {font-family: Poppins, sans-serif; background:#f8f9fa;}
        .container {
            width:50%;
            margin:60px auto;
            background:white;
            padding:25px;
            border-radius:10px;
            box-shadow:0 4px 10px rgba(0,0,0,0.1);
        }
        input, button {
            width:90%;
            padding:8px;
            margin:8px 0;
            border:1px solid #ccc;
            border-radius:6px;
        }
        button {
            background:#007bff;
            color:white;
            border:none;
            font-weight:bold;
            cursor:pointer;
        }
        button:hover { background:#0056b3; }
        a { text-decoration:none; color:#007bff; }
        a:hover { text-decoration:underline; }
        h2 { text-align:center; }
    </style>
</head>
<body>
<div class="container">
    <h2>✏ Edit Expense</h2>

<%
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.trim().isEmpty()) {
%>
    <p style="color:red;">⚠ No expense selected!</p>
    <a href="view_exp">⬅ Back</a>
<%
    } else {
        int id = Integer.parseInt(idStr);
        String category = "";
        double amount = 0;
        String date = "";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement("SELECT * FROM expenses WHERE id=?");
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                category = rs.getString("category");
                amount = rs.getDouble("amount");
                // Convert date safely
                java.sql.Timestamp ts = rs.getTimestamp("date");
                if (ts != null) {
                    date = ts.toString().substring(0, 10); // yyyy-MM-dd
                }
            } else {
%>
                <p style="color:red;">⚠ Expense record not found.</p>
                <a href="view_exp">⬅ Back</a>
<%
            }
        } catch (Exception e) {
%>
            <p style="color:red;">❌ Error: <%= e.getMessage() %></p>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ex) {}
            if (ps != null) try { ps.close(); } catch (Exception ex) {}
            if (conn != null) try { conn.close(); } catch (Exception ex) {}
        }

        if (!category.equals("")) { // Only show form if record found
%>
    <form action="edit_expense" method="post">
        <input type="hidden" name="id" value="<%= id %>">
        <label>Category:</label><br>
        <input type="text" name="category" value="<%= category %>" required><br>
        <label>Amount (₹):</label><br>
        <input type="number" name="amount" step="0.01" value="<%= amount %>" required><br>
        <label>Date:</label><br>
        <input type="date" name="date" value="<%= date %>" required><br><br>
        <button type="submit">💾 Update Expense</button>
    </form>
    <div style="margin-top:10px;">
        <a href="view_exp">⬅ Back to Dashboard</a>
    </div>
<%
        }
    }
%>
</div>
</body>
</html>
