<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>📊 Monthly Report | Smart Expense Tracker</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
body { font-family: Poppins, sans-serif; background: #f8f9fa; }
.container { width: 80%; margin: 30px auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
h2 { text-align: center; }
canvas { width: 100%; height: 400px; }
p.msg { text-align: center; color: #b30000; font-weight: bold; }
</style>
</head>
<body>
<div class="container">
    <h2>📊 Monthly Expense Report</h2>

    <form action="report" method="get" style="text-align:center;">
        <label><b>Select Month:</b></label>
        <select name="month" required>
            <option value="">-- Choose --</option>
            <option value="November 2025">November 2025</option>
            <option value="December 2025">December 2025</option>
            <option value="January 2026">January 2026</option>
        </select>
        <button type="submit">Generate Report</button>
    </form>

    <%
        String noData = (String) request.getAttribute("noData");
        if (noData != null) {
    %>
        <p class="msg"><%= noData %></p>
    <% } else if (request.getAttribute("categories") != null) { %>
        <canvas id="expenseChart"></canvas>
        <script>
        const ctx = document.getElementById('expenseChart').getContext('2d');
        const chartData = {
            labels: <%= request.getAttribute("categories") %>,
            datasets: [{
                data: <%= request.getAttribute("amounts") %>,
                backgroundColor: ['#ff6384', '#36a2eb', '#ffcd56', '#4bc0c0', '#9966ff']
            }]
        };
        new Chart(ctx, {
            type: 'pie',
            data: chartData,
            options: { responsive: true, plugins: { legend: { position: 'bottom' } } }
        });
        </script>
    <% } %>

    <div style="text-align:center; margin-top:15px;">
        <a href="home.jsp">⬅ Back to Dashboard</a>
    </div>
</div>
</body>
</html>
