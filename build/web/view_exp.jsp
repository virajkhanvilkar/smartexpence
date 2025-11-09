<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Expenses | Smart Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: #f8f9fa;
        }
        .container {
            width: 80%;
            margin: 40px auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #007bff;
            color: white;
            font-weight: 600;
        }
        tr:hover { background: #f1f1f1; }
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            color: white;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-edit { background: #28a745; }
        .btn-edit:hover { background: #218838; }
        .btn-del { background: #dc3545; }
        .btn-del:hover { background: #b02a37; }
        h2 { text-align: center; margin-bottom: 10px; color: #333; }
        a.back {
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            display: inline-block;
            margin-top: 15px;
        }
        a.back:hover { text-decoration: underline; }
        .no-exp {
            text-align: center;
            color: #888;
            font-size: 16px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📋 All Expenses</h2>

    <% 
        java.util.List<java.util.Map<String, Object>> expList = 
            (java.util.List<java.util.Map<String, Object>>) request.getAttribute("expenses");
        if (expList == null || expList.isEmpty()) { 
    %>
        <p class="no-exp">No expenses recorded yet.</p>
    <% } else { %>
        <table>
            <tr>
                <th>ID</th>
                <th>Category</th>
                <th>Amount (₹)</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
            <% 
                double total = 0;
                for (java.util.Map<String, Object> exp : expList) {
                    double amount = Double.parseDouble(exp.get("amount").toString());
                    total += amount;
            %>
                <tr>
                    <td><%= exp.get("id") %></td>
                    <td><%= exp.get("category") %></td>
                    <td>₹<%= String.format("%.2f", amount) %></td>
                    <td>
                        <%= new java.text.SimpleDateFormat("dd-MMM-yyyy")
                                .format(((java.sql.Timestamp)exp.get("date"))) %>
                    </td>
                    <td>
                        <!-- Edit Button -->
                        <a href="edit_expense.jsp?id=<%= exp.get("id") %>">
                            <button class="btn btn-edit">✏ Edit</button>
                        </a>

                        <!-- Delete Button -->
                        <a href="delete_expense?id=<%= exp.get("id") %>" 
                           onclick="return confirm('Are you sure you want to delete this expense?');">
                            <button class="btn btn-del">🗑 Delete</button>
                        </a>
                    </td>
                </tr>
            <% } %>
            <!-- Total Row -->
            <tr style="background:#f8f9fa; font-weight:bold;">
                <td colspan="2">Total</td>
                <td colspan="3">₹<%= String.format("%.2f", total) %></td>
            </tr>
        </table>
    <% } %>

    <div style="text-align:center;">
        <a class="back" href="home.jsp">⬅ Back to Dashboard</a>
    </div>
</div>
</body>
</html>
