<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Provider Business Profile — Urban Genie</title>

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
String sessionName = (String) session.getAttribute("name");
if (sessionName == null) {
    response.sendRedirect("provider.jsp");
    return;
}

String pParam = request.getParameter("profile");
if (pParam == null || pParam.trim().isEmpty()) {
    pParam = (String) session.getAttribute("reg");
}
if (pParam == null || pParam.trim().isEmpty()) {
    pParam = (String) session.getAttribute("preg");
}

Connection c1 = null;
PreparedStatement st = null;
ResultSet r = null;

int reg = 0;
String shop = "", name = "", no = "", category = "", adr = "", email = "", time = "", about = "", pwd = "", status = "";

try {
    c1 = DBUtil.getConnection();
    if (pParam != null && !pParam.trim().isEmpty()) {
        reg = Integer.parseInt(pParam.trim());
        st = c1.prepareStatement("SELECT * FROM provider WHERE reg=?");
        st.setInt(1, reg);
    } else {
        st = c1.prepareStatement("SELECT * FROM provider WHERE name=?");
        st.setString(1, sessionName);
    }

    r = st.executeQuery();
    if (r.next()) {
        reg      = r.getInt("reg");
        shop     = r.getString("shop");
        name     = r.getString("name");
        no       = r.getString("no");
        category = r.getString("category");
        adr      = r.getString("adr");
        email    = r.getString("email");
        time     = r.getString("time");
        about    = r.getString("about");
        pwd      = r.getString("pwd");
        status   = r.getString("status");
    } else {
        response.sendRedirect("providerprofile.jsp");
        return;
    }
} catch(Exception ex) {
    out.println("<script>alert('Error loading profile: " + ex.getMessage().replace("'", "\\'") + "'); location.href='providerprofile.jsp';</script>");
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
      <a href="providerprofile.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
        <span class="brand-badge" style="background: #fef3c7; color: #b45309; border-color: #fde68a;">Provider</span>
      </a>
      <div style="display: flex; gap: 10px;">
        <a href="providerprofile.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-gauge"></i> Dashboard</a>
      </div>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card" style="max-width: 520px;">
      <div class="auth-header">
        <div class="auth-icon" style="background: #ede9fe; color: #7c3aed;">
          <i class="fa-solid fa-id-card"></i>
        </div>
        <h2>Business Profile Settings</h2>
        <p>Update your trade details, opening hours, and contact information</p>
      </div>

      <form action="provider_update111.jsp" method="post" id="providerUpdateForm" onsubmit="return validateForm('providerUpdateForm');">
        <input type="hidden" name="reg" value="<%= reg %>">

        <div class="form-group">
          <label class="form-label">Shop / Business Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-store input-icon"></i>
            <input type="text" name="shop" value="<%= shop %>" class="form-control" required autofocus>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Owner / Contact Person</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user-tie input-icon"></i>
            <input type="text" name="name" value="<%= name %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Service Category</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-tag input-icon"></i>
            <select name="category" class="form-control" required>
              <option value="<%= category %>">Current: <%= category %></option>
              <option value="Plumber">Plumber</option>
              <option value="Electronics">Electronics</option>
              <option value="Carpenter">Carpenter</option>
              <option value="Automobiles">Automobiles</option>
              <option value="Home Cleaning">Home Cleaning</option>
              <option value="Agriculture">Agriculture</option>
              <option value="Furniture">Furniture</option>
              <option value="Health & Medical">Health & Medical</option>
              <option value="Food">Food</option>
              <option value="Transportation">Transportation</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Shop Address</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-location-dot input-icon"></i>
            <input type="text" name="adr" value="<%= adr %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Contact Phone (10 digits)</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-phone input-icon"></i>
            <input type="tel" name="no" value="<%= no %>" class="form-control" pattern="[0-9]{10}" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Business Email</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-envelope input-icon"></i>
            <input type="email" name="email" value="<%= email %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Working Hours</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-clock input-icon"></i>
            <input type="text" name="time" value="<%= time %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Business Description</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-circle-info input-icon"></i>
            <input type="text" name="about" value="<%= about %>" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Account Password</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-lock input-icon"></i>
            <input type="password" id="pUpdatePwd" name="pwd" value="<%= pwd %>" class="form-control" required>
            <button type="button" class="input-action" onclick="togglePasswordVisibility('pUpdatePwd', 'pUpdateEye')" title="Toggle visibility">
              <i class="fa-regular fa-eye" id="pUpdateEye"></i>
            </button>
          </div>
          <div class="form-hint">Leave unchanged to keep your current password</div>
        </div>

        <div class="form-group">
          <label class="form-label">Verification Status</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-shield-check input-icon"></i>
            <input type="text" value="<%= status != null ? status : "Active" %>" class="form-control" readonly>
          </div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block" style="background: #7c3aed;">
            <i class="fa-solid fa-floppy-disk"></i> Save Business Updates
          </button>
        </div>
      </form>

      <div class="auth-footer">
        <a href="providerprofile.jsp"><i class="fa-solid fa-arrow-left"></i> Cancel</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>