<!DOCTYPE html>
<html>
<head>
    <title>Login | Smart Expense Tracker</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
    <h2>Smart Expense Tracker</h2>

    <!-- ? Show error message dynamically -->
    <% if (request.getAttribute("error") != null) { %>
        <p style="color: red; font-weight: bold;">
            <%= request.getAttribute("error") %>
        </p>
    <% } %>

    <form action="login" method="post">
        <input type="text" name="username" placeholder="Enter Username" required><br>
        <input type="password" name="password" placeholder="Enter Password" required><br>
        <button type="submit">Login</button>
    </form>
</div>
</body>
</html>
