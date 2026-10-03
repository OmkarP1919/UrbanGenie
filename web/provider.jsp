<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Provider Login — Urban Genie</title>

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
        <a href="providerregister.jsp" class="btn btn-outline btn-sm">Register Shop</a>
        <a href="index.html" class="btn btn-outline btn-sm"><i class="fa-solid fa-house"></i> Home</a>
      </div>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card">
      <div class="auth-header">
        <div class="auth-icon" style="background: #fef3c7; color: #b45309;">
          <i class="fa-solid fa-store"></i>
        </div>
        <h2>Provider Sign In</h2>
        <p>Manage customer service requests and shop profile</p>
      </div>

      <form action="providerpage.jsp" method="post" id="providerLoginForm">
        <div class="form-group">
          <label class="form-label" for="providerName">Owner / Provider Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user-tie input-icon"></i>
            <input type="text" id="providerName" name="name" class="form-control" placeholder="Enter owner name" required autofocus>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="providerPwd">Password</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-lock input-icon"></i>
            <input type="password" id="providerPwd" name="pwd" class="form-control" placeholder="Enter password" required>
            <button type="button" class="input-action" onclick="togglePasswordVisibility('providerPwd', 'provEyeIcon')" title="Toggle visibility">
              <i class="fa-regular fa-eye" id="provEyeIcon"></i>
            </button>
          </div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block" style="background: #d97706;">
            <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In to Business Portal
          </button>
        </div>
      </form>

      <div class="auth-footer">
        Need to list your business? <a href="providerregister.jsp" style="font-weight: 600; color: #b45309;">Register shop</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>