<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>📈 Prediction | Smart Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(to right, #f8f9fa, #eef3ff);
        }
        .container {
            width: 60%;
            margin: 60px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            text-align: center;
            animation: fadeIn 0.8s ease-in;
        }
        h2 {
            color: #007bff;
            margin-bottom: 15px;
        }
        p, h3 {
            font-size: 18px;
            color: #333;
            margin: 8px 0;
        }
        h3 {
            background: #e6f7ff;
            color: #0056b3;
            padding: 10px;
            border-radius: 8px;
            display: inline-block;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
            font-weight: bold;
            font-size: 16px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .alert {
            padding: 12px;
            border-radius: 8px;
            font-weight: bold;
            margin-bottom: 15px;
            width: 80%;
            margin-left: auto;
            margin-right: auto;
        }
        .alert.success {
            background: #e6ffe6;
            color: #006600;
        }
        .alert.warning {
            background: #ffe6e6;
            color: #b30000;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-5px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
<div class="container">
    <h2>📈 Expense Prediction</h2>

    <% 
        Object balObj = request.getAttribute("balance");
        Object spentObj = request.getAttribute("spent");
        Object remObj = request.getAttribute("remaining");
        Object daysObj = request.getAttribute("daysLeft");
        Object limitObj = request.getAttribute("dailyLimit");
        String alertMsg = (String) request.getAttribute("alert");

        boolean overspent = false;
        if (alertMsg != null && alertMsg.contains("⚠")) {
            overspent = true;
        }
    %>

    <% if (alertMsg != null) { %>
        <div class="alert <%= overspent ? "warning" : "success" %>">
            <%= alertMsg %>
        </div>
    <% } %>

    <p><b>Total Balance:</b> ₹<%= (balObj != null) ? String.format("%.2f", Double.parseDouble(balObj.toString())) : "0.00" %></p>
    <p><b>Total Spent:</b> ₹<%= (spentObj != null) ? String.format("%.2f", Double.parseDouble(spentObj.toString())) : "0.00" %></p>
    <p><b>Remaining:</b> ₹<%= (remObj != null) ? String.format("%.2f", Double.parseDouble(remObj.toString())) : "0.00" %></p>
    <p><b>Days Left:</b> <%= (daysObj != null) ? daysObj : "0" %></p>
    <h3>💡 Suggested Daily Limit: ₹<%= (limitObj != null) ? limitObj : "0.00" %></h3>

    <a href="home.jsp" class="back-link">⬅ Back to Dashboard</a>
</div>
</body>
</html>
