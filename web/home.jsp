<%@page import="java.sql.*, java.text.SimpleDateFormat, java.util.*, model.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard | Smart Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            font-family: "Poppins", sans-serif;
            background: linear-gradient(to right,#f8f9fa,#eef3ff);
        }
        .container {
            width:80%;margin:40px auto;background:#fff;padding:30px;
            border-radius:12px;box-shadow:0 4px 20px rgba(0,0,0,0.1);
        }
        h2{text-align:center;color:#222;}
        .date-time{text-align:center;font-size:15px;color:#555;margin-bottom:15px;}
        .summary{display:flex;justify-content:space-between;flex-wrap:wrap;margin-bottom:20px;gap:15px;}
        .card{flex:1;background:#f2f9ff;padding:20px;border-radius:10px;text-align:center;font-weight:600;
            transition:0.3s;box-shadow:0 0 8px rgba(0,0,0,0.05);}
        .card:hover{transform:scale(1.03);}
        .card.red{background:#ffe6e6;color:#b30000;}
        .card.green{background:#e6ffe6;color:#006600;}
        .box{background:#f7f7f7;padding:15px;border-radius:10px;margin-bottom:20px;}
        input,button,select{
            padding:8px;width:80%;margin:6px 0;border:1px solid #ccc;border-radius:5px;
        }
        button{
            width:auto;background-color:#007bff;color:#fff;border:none;
            font-weight:bold;cursor:pointer;transition:0.3s;
        }
        button:hover{background-color:#0056b3;}
        .btn-green{background-color:#28a745;}
        .btn-green:hover{background-color:#218838;}
        .links{text-align:center;margin-top:20px;}
        .links a{color:#007bff;text-decoration:none;margin:0 8px;font-weight:600;}
        .links a:hover{text-decoration:underline;}
        .fade-in{animation:fadeIn 0.8s ease-in;}
        @keyframes fadeIn{from{opacity:0;transform:translateY(-5px);}to{opacity:1;transform:translateY(0);}}
    </style>
</head>
<body>
<div class="container fade-in">
    <h2>💰 Smart Expense Tracker Dashboard</h2>
    <div class="date-time" id="datetime"></div>

<%
    HttpSession sess = request.getSession();
    Integer userIdObj = (Integer) sess.getAttribute("userId");

    double remainingBal = 0, dailyLimit = 0, todaySpent = 0;
    double monthBalance = 0;
    int totalDays = 0;

    if (userIdObj != null) {
        int userId = userIdObj;
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // ✅ Fetch Monthly Balance
            Statement st = conn.createStatement();
            ResultSet rb = st.executeQuery("SELECT month_balance, total_days FROM balance WHERE user_id=" + userId + " ORDER BY id DESC LIMIT 1");
            if (rb.next()) {
                monthBalance = rb.getDouble("month_balance");
                totalDays = rb.getInt("total_days");
            }

            // ✅ Fetch Total Expenses
            ResultSet re = st.executeQuery("SELECT SUM(amount) AS total_spent FROM expenses WHERE user_id=" + userId);
            double totalSpent = 0;
            if (re.next()) {
                totalSpent = re.getDouble("total_spent");
            }

            // ✅ Fetch Today's Spent Amount
            String today = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
            PreparedStatement ps = conn.prepareStatement("SELECT SUM(amount) FROM expenses WHERE user_id=? AND DATE(date)=?");
            ps.setInt(1, userId);
            ps.setString(2, today);
            ResultSet rt = ps.executeQuery();
            if (rt.next()) {
                todaySpent = rt.getDouble(1);
            }

            remainingBal = monthBalance - totalSpent;
            dailyLimit = (totalDays > 0) ? (remainingBal / totalDays) : 0;

            rb.close(); re.close(); rt.close(); ps.close(); st.close();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception ex) {}
            }
        }
    }
%>

<!-- ✅ Popup Success / Info Message -->
<%
    String msg = (String) sess.getAttribute("message");
    if (msg != null) {
%>
<script>
window.onload = function() {
    alert("<%= msg.replace("\"", "\\\"") %>");
}
</script>
<%
        sess.removeAttribute("message");
    }
%>

<!-- ✅ Daily Summary Section -->
<% if (dailyLimit > 0) { %>
    <% if (todaySpent > dailyLimit) { %>
        <div class="card red fade-in">
            ⚠ You spent ₹<%= String.format("%.2f", todaySpent) %> today — ₹<%= String.format("%.2f", (todaySpent - dailyLimit)) %> over your daily limit (₹<%= String.format("%.2f", dailyLimit) %>)!<br>
            Remaining balance adjusted to ₹<%= String.format("%.2f", remainingBal) %>.
        </div>
    <% } else { %>
        <div class="card green fade-in">
            ✅ You’re within your daily limit of ₹<%= String.format("%.2f", dailyLimit) %>.<br>
            Today's spending: ₹<%= String.format("%.2f", todaySpent) %>.
        </div>
    <% } %>
<% } else { %>
    <div class="card fade-in" style="background:#fff7e6; color:#b36b00;">
        💡 Tip: Set your balance range to start tracking expenses and predictions.
    </div>
<% } %>

<!-- ✅ Summary Cards -->
<div class="summary">
    <div class="card">💼 Remaining Balance<br>₹<%= String.format("%.2f", remainingBal) %></div>
    <div class="card">📅 Daily Limit<br>₹<%= String.format("%.2f", dailyLimit) %></div>
    <div class="card">💸 Today Spent<br>₹<%= String.format("%.2f", todaySpent) %></div>
</div>

<!-- ✅ Set Balance Form (Date Range) -->
<form action="add_balance" method="post" class="box">
    <h3>Set Balance for Period</h3>
    <label><b>From Date:</b></label><br>
    <input type="date" name="fromDate" required><br>
    <label><b>To Date:</b></label><br>
    <input type="date" name="toDate" required><br>
    <input type="text" name="balance" placeholder="Enter Total Balance (₹)" required><br>
    <button type="submit" class="btn-green">💾 Save Balance</button>
</form>

<!-- ✅ Add Expense Form -->
<form action="add_expense" method="post" class="box">
    <h3>Add Expense</h3>
    <input type="text" name="category" placeholder="Category (Rent, Petrol, Mess)" required><br>
    <input type="number" name="amount" placeholder="Amount (₹)" required><br>
    <input type="date" name="expDate" required><br>
    <button type="submit">➕ Add Expense</button>
</form>

<!-- ✅ Links -->
<div class="links">
    <a href="view_exp">📋 View All Expenses</a> |
    <a href="predict">📈 View Prediction</a> |
    <a href="report.jsp">📊 Monthly Report</a> |
    <a href="index.jsp">🚪 Logout</a>
</div>
</div>

<script>
const dt = new Date();
let greeting = "Hello";
if (dt.getHours() < 12) greeting = "🌅 Good Morning";
else if (dt.getHours() < 17) greeting = "☀ Good Afternoon";
else greeting = "🌙 Good Evening";
document.getElementById("datetime").innerText =
    greeting + " — " + dt.toLocaleDateString() + " " + dt.toLocaleTimeString();
</script>
</body>
</html>
