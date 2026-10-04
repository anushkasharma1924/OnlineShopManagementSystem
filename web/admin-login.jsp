<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
</head>
<body>

    <h1>Admin Login</h1>

    <form action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">

        <label>Email:</label><br>
        <input type="email" name="email" required>
        <br><br>

        <label>Password:</label><br>
        <input type="password" name="password" required>
        <br><br>

        <button type="submit">Login</button>

    </form>

    <br>

    <a href="${pageContext.request.contextPath}/login.jsp">
        Customer Login
    </a>

</body>
</html>