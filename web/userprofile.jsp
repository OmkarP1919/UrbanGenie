<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Account Settings — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

  <script>
    function preventBack(){ window.history.forward(); }
    setTimeout(preventBack, 0);
    window.onunload = function(){ null; };
  </script>
</head>
<body style="background: var(--bg-app);">

<%
String sessionUser = (String) session.getAttribute("name");
if (sessionUser == null) {
    response.sendRedirect("user.jsp");
    return;
}

String pParam = request.getParameter("profile");
if (pParam == null || pParam.trim().isEmpty()) {
    pParam = (String) session.getAttribute("reg");
}

Connection c1 = null;
PreparedStatement st = null;
ResultSet r = null;

int regId = 0;
String name = "", adr = "", email = "", gen = "", pwd = "", status = "", no = "";

try {
    c1 = DBUtil.getConnection();
    if (pParam != null && !pParam.trim().isEmpty()) {
        regId = Integer.parseInt(pParam.trim());
        st = c1.prepareStatement("SELECT * FROM user WHERE reg=?");
        st.setInt(1, regId);
    } else {
        st = c1.prepareStatement("SELECT * FROM user WHERE name=?");
        st.setString(1, sessionUser);
    }

    r = st.executeQuery();
    if (r.next()) {
        regId  = r.getInt("reg");
        name   = r.getString("name");
        email  = r.getString("email");
        no     = r.getString("no");
        adr    = r.getString("adr");
        gen    = r.getString("gen");
        pwd    = r.getString("pwd");
        status = r.getString("status");
    } else {
        response.sendRedirect("userprofile111.jsp");
        return;
    }
} catch(Exception ex) {
    out.println("<script>alert('Error retrieving profile: " + ex.getMessage().replace("'", "\\'") + "'); location.href='userprofile111.jsp';</script>");
    return;
} finally {
    if (r != null) try { r.close(); } catch(Exception ignore) {}
    if (st != null) try { st.close(); } catch(Exception ignore) {}
    if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
}
%>

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="userprofile111.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
      </a>
      <div style="display: flex; gap: 10px;">
        <a href="userprofile111.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-gauge"></i> Dashboard</a>
      </div>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card" style="max-width: 500px;">
      <div class="auth-header">
        <div class="auth-icon">
          <i class="fa-solid fa-user-pen"></i>
        </div>
        <h2>Account Settings</h2>
        <p>Update your personal information and contact details</p>
      </div>

      <form action="user_update111.jsp" method="post" id="userUpdateForm" onsubmit="return validateForm('userUpdateForm');">
        <!-- Account ID -->
        <div class="form-group">
          <label class="form-label">Registration ID</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-hashtag input-icon"></i>
            <input type="number" name="reg" value="<%= regId %>" class="form-control" readonly>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="userNameInput">Full Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user input-icon"></i>
            <input type="text" id="userNameInput" name="name" value="<%= name %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="userEmailInput">Email Address</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-envelope input-icon"></i>
            <input type="email" id="userEmailInput" name="email" value="<%= email %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="userPhoneInput">Mobile Phone (10 digits)</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-phone input-icon"></i>
            <input type="tel" id="userPhoneInput" name="no" value="<%= no %>" class="form-control" pattern="[0-9]{10}" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="userAdrInput">Ambajogai Address</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-location-dot input-icon"></i>
            <input type="text" id="userAdrInput" name="adr" value="<%= adr %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Gender</label>
          <div style="display: flex; gap: 24px; padding: 4px 0;">
            <label style="display: flex; align-items: center; gap: 6px; font-size: 0.9rem; cursor: pointer;">
              <input type="radio" name="gen" value="male" <%= "male".equalsIgnoreCase(gen) ? "checked" : "" %>> Male
            </label>
            <label style="display: flex; align-items: center; gap: 6px; font-size: 0.9rem; cursor: pointer;">
              <input type="radio" name="gen" value="female" <%= "female".equalsIgnoreCase(gen) ? "checked" : "" %>> Female
            </label>
            <label style="display: flex; align-items: center; gap: 6px; font-size: 0.9rem; cursor: pointer;">
              <input type="radio" name="gen" value="other" <%= (!"male".equalsIgnoreCase(gen) && !"female".equalsIgnoreCase(gen)) ? "checked" : "" %>> Other
            </label>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="userPwdInput">Change Password</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-lock input-icon"></i>
            <input type="password" id="userPwdInput" name="pwd" value="<%= pwd %>" class="form-control" required>
            <button type="button" class="input-action" onclick="togglePasswordVisibility('userPwdInput', 'userUpdateEye')" title="Toggle visibility">
              <i class="fa-regular fa-eye" id="userUpdateEye"></i>
            </button>
          </div>
          <div class="form-hint">Leave untouched to keep your current password</div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block">
            <i class="fa-solid fa-floppy-disk"></i> Save Profile Updates
          </button>
        </div>
      </form>

      <div class="auth-footer">
        <a href="userprofile111.jsp"><i class="fa-solid fa-arrow-left"></i> Cancel</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>