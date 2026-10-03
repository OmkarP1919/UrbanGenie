<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Login — Urban Genie</title>
  
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  
  <script>
    function preventBack(){ window.history.forward(); }
    setTimeout(preventBack, 0);
    window.onunload = function(){ null; };
  </script>
</head>
<body style="background: var(--bg-app);">

  <!-- Navbar -->
  <header style="background: #ffffff; border-bottom: 1px solid var(--border-subtle); padding: 14px 24px;">
    <div style="max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center;">
      <a href="index.html" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
      </a>
      <div style="display: flex; gap: 10px;">
        <a href="userregister.jsp" class="btn btn-outline btn-sm">Create Account</a>
        <a href="index.html" class="btn btn-outline btn-sm"><i class="fa-solid fa-house"></i> Home</a>
      </div>
    </div>
  </header>

<%
String returnTo = request.getParameter("returnTo");
if (returnTo == null) returnTo = "";
%>

  <main class="auth-wrapper">
    <div class="auth-card">
      <div class="auth-header">
        <div class="auth-icon">
          <i class="fa-solid fa-user"></i>
        </div>
        <h2>Customer Sign In</h2>
        <p><%= !returnTo.isEmpty() ? "Please sign in to proceed with your booking" : "Log in to book verified local services and track orders" %></p>
      </div>

      <form action="userpage.jsp" method="post" id="userLoginForm">
        <input type="hidden" name="returnTo" value="<%= returnTo %>">

        <div class="form-group">
          <label class="form-label" for="userName">Username / Customer Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user input-icon"></i>
            <input type="text" id="userName" name="name" class="form-control" placeholder="Enter your registered name" required autofocus>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="userPwd">Password</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-lock input-icon"></i>
            <input type="password" id="userPwd" name="pwd" class="form-control" placeholder="Enter your password" required>
            <button type="button" class="input-action" onclick="togglePasswordVisibility('userPwd', 'userEyeIcon')" title="Toggle visibility">
              <i class="fa-regular fa-eye" id="userEyeIcon"></i>
            </button>
          </div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block">
            <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In
          </button>
        </div>
      </form>

      <div class="auth-footer">
        Don't have an account? <a href="userregister.jsp<%= !returnTo.isEmpty() ? "?returnTo=" + java.net.URLEncoder.encode(returnTo, "UTF-8") : "" %>" style="font-weight: 600;">Register here</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>