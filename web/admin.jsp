<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Login — Urban Genie</title>
  
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  
  <script>
    function preventBack(){ window.history.forward(); }
    setTimeout(preventBack, 0);
    window.onunload = function(){ null; };
  </script>
</head>
<body style="background: var(--bg-app);">

  <!-- Top Simple Nav -->
  <header style="background: #ffffff; border-bottom: 1px solid var(--border-subtle); padding: 14px 24px;">
    <div style="max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center;">
      <a href="index.html" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
      </a>
      <a href="index.html" class="btn btn-outline btn-sm">
        <i class="fa-solid fa-house"></i> Home
      </a>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card">
      <div class="auth-header">
        <div class="auth-icon" style="background: #e0e7ff; color: var(--brand-indigo);">
          <i class="fa-solid fa-shield-halved"></i>
        </div>
        <h2>Admin Authentication</h2>
        <p>Access the municipal control center and management dashboard</p>
      </div>

      <form action="adminpage.jsp" method="post" id="adminLoginForm">
        <div class="form-group">
          <label class="form-label" for="adminName">Admin Username</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user-shield input-icon"></i>
            <input type="text" id="adminName" name="name" class="form-control" placeholder="Enter admin username" required autofocus>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="adminPwd">Security Password</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-lock input-icon"></i>
            <input type="password" id="adminPwd" name="pwd" class="form-control" placeholder="Enter password" required>
            <button type="button" class="input-action" onclick="togglePasswordVisibility('adminPwd', 'toggleIcon')" title="Toggle visibility">
              <i class="fa-regular fa-eye" id="toggleIcon"></i>
            </button>
          </div>
        </div>

        <div style="margin-top: 26px;">
          <button type="submit" class="btn btn-primary btn-block" style="background: var(--brand-indigo);">
            <i class="fa-solid fa-right-to-bracket"></i> Sign In to Command Center
          </button>
        </div>
      </form>

      <div class="auth-footer">
        <a href="index.html"><i class="fa-solid fa-arrow-left"></i> Back to Homepage</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>