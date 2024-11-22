<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Login</title>
</head>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng nhập</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      background-color: #f2f2f2;
    }
    .login-container {
      width: 300px;
      padding: 20px;
      background-color: #fff;
      border: 1px solid #ccc;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      text-align: center;
    }
    .login-container h2 {
      margin-top: 0;
      margin-bottom: 20px;
      font-size: 20px;
    }
    .login-container label {
      display: block;
      text-align: left;
      margin-bottom: 5px;
      font-size: 14px;
    }
    .login-container input[type="text"],
    .login-container input[type="password"] {
      width: 100%;
      padding: 8px;
      margin-bottom: 15px;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
    }
    .login-container button {
      width: 100%;
      padding: 10px;
      border: none;
      background-color: #4CAF50;
      color: white;
      font-size: 16px;
      cursor: pointer;
      border-radius: 4px;
    }
    .login-container button:hover {
      background-color: #45a049;
    }
  </style>
</head>
<div class="login-container">
  <h2>Đăng nhập</h2>
  <form action="doLogin.jsp" method="post">
    <label for="username">Username :</label>
    <input type="text" id="username" name="username" required>
    <br/>
    <label for="password">Password :</label>
    <input type="password" id="password" name="password" required>

    <button type="submit">Login</button>
  </form>
</div>
</html>