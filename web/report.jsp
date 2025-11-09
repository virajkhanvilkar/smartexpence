<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>📊 Monthly Report | Smart Expense Tracker</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
body { 
    font-family: Poppins, sans-serif; 
    background: #f8f9fa; 
}
.container { 
    width: 80%; 
    margin: 30px auto; 
    background: white; 
    padding: 20px; 
    border-radius: 10px; 
    box-shadow: 0 0 10px rgba(0,0,0,0.1); 
}
h2 { 
    text-align: center; 
    color: #222;
}
canvas { 
    display: block;
    margin: 20px auto;
    max-width: 400px;   /* ✅ reduced width */
    max-height: 400px;  /* ✅ reduced height */
}
p.msg { 
    text-align: center; 
    color: #b30000; 
    font-weight: bold; 
}
form {
    text-align:center;
    margin-bottom: 20px;
}
button {
    background-color: #007bff;
    color: white;
    border: none;
    padding: 8px 14px;
    border-radius: 6px;
    cursor: pointer;
}
button:hover {
    background-color: #0056b3;
}
a {
    color: #007bff;
    text-decoration: none;
    font-weight: 600;
}
a:hover {
    text-decoration: underline;
}
</style>
</head>
<body>
<div class="container">
    <h2>📊 Monthly Expense Report</h2>

    <form action="report" method="get">
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
                backgroundColor: [
                    '#ff6384', '#36a2eb', '#ffcd56', '#4bc0c0', '#9966ff'
                ]
            }]
        };
        new Chart(ctx, {
            type: 'pie',
            data: chartData,
            options: { 
                responsive: true, 
                maintainAspectRatio: false, /* ✅ makes it scale correctly */
                plugins: { 
                    legend: { position: 'bottom' },
                    title: {
                        display: true,
                        text: '<%= request.getAttribute("selectedMonth") != null ? request.getAttribute("selectedMonth") : "" %>'
                    }
                } 
            }
        });
        </script>
    <% } %>

    <div style="text-align:center; margin-top:15px;">
        <a href="home.jsp">⬅ Back to Dashboard</a>
    </div>
</div>
</body>
</html>
