<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Registration — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
int reg = 1;
String returnTo = request.getParameter("returnTo");
if (returnTo == null) returnTo = "";
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    con = DBUtil.getConnection();
    ps = con.prepareStatement("SELECT MAX(reg) FROM user");
    rs = ps.executeQuery();
    if (rs.next()) {
        int maxVal = rs.getInt(1);
        if (maxVal > 0) reg = maxVal + 1;
    }
} catch (Exception ignore) {
    reg = 1;
} finally {
    if (rs != null) try { rs.close(); } catch (Exception ignore) {}
    if (ps != null) try { ps.close(); } catch (Exception ignore) {}
    if (con != null) try { con.close(); } catch (Exception ignore) {}
}
%>
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
        <a href="user.jsp<%= !returnTo.isEmpty() ? "?returnTo=" + java.net.URLEncoder.encode(returnTo, "UTF-8") : "" %>" class="btn btn-outline btn-sm">Sign In</a>
        <a href="index.html" class="btn btn-outline btn-sm"><i class="fa-solid fa-house"></i> Home</a>
      </div>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card" style="max-width: 480px;">
      <div class="auth-header">
        <div class="auth-icon">
          <i class="fa-solid fa-user-plus"></i>
        </div>
        <h2>Create Customer Account</h2>
        <p><%= !returnTo.isEmpty() ? "Sign up to quickly complete your booking" : "Sign up to book domestic services in Ambajogai" %></p>
      </div>

      <form action="userregister101.jsp" method="post" id="userRegForm" onsubmit="return validateForm('userRegForm');">
        <!-- Registration ID (Assigned) -->
        <input type="hidden" name="reg" value="<%= reg %>">
        <input type="hidden" name="returnTo" value="<%= returnTo %>">

        <div class="form-group">
          <label class="form-label" for="regName">Full Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user input-icon"></i>
            <input type="text" id="regName" name="name" class="form-control" placeholder="e.g. Rahul Sharma" required autofocus>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="regEmail">Email Address</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-envelope input-icon"></i>
            <input type="email" id="regEmail" name="email" class="form-control" placeholder="name@example.com" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="regPhone">Mobile Number (10 digits)</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-phone input-icon"></i>
            <input type="tel" id="regPhone" name="no" class="form-control" placeholder="9876543210" pattern="[0-9]{10}" required>
          </div>
          <div class="form-hint">Must be a valid 10-digit Indian phone number</div>
        </div>

        <div class="form-group">
          <label class="form-label" for="regAdr">Residential Address (Ambajogai)</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-location-dot input-icon"></i>
            <input type="text" id="regAdr" name="adr" class="form-control" placeholder="Area, Landmark, Street" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Gender</label>
          <div style="display: flex; gap: 24px; padding: 6px 0;">
            <label style="display: flex; align-items: center; gap: 8px; font-size: 0.9rem; cursor: pointer;">
              <input type="radio" name="gen" value="male" checked> Male
            </label>
            <label style="display: flex; align-items: center; gap: 8px; font-size: 0.9rem; cursor: pointer;">
              <input type="radio" name="gen" value="female"> Female
            </label>
            <label style="display: flex; align-items: center; gap: 8px; font-size: 0.9rem; cursor: pointer;">
              <input type="radio" name="gen" value="other"> Other
            </label>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="regPwd">Create Password</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-lock input-icon"></i>
            <input type="password" id="regPwd" name="pwd" class="form-control" placeholder="Minimum 4 characters" minlength="4" required>
            <button type="button" class="input-action" onclick="togglePasswordVisibility('regPwd', 'regEyeIcon')" title="Toggle visibility">
              <i class="fa-regular fa-eye" id="regEyeIcon"></i>
            </button>
          </div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block">
            <i class="fa-solid fa-check"></i> Register Account
          </button>
        </div>
      </form>

      <div class="auth-footer">
        Already registered? <a href="user.jsp<%= !returnTo.isEmpty() ? "?returnTo=" + java.net.URLEncoder.encode(returnTo, "UTF-8") : "" %>" style="font-weight: 600;">Sign in here</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>