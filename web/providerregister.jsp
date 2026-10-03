<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register Service Provider — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
int reg = 1;
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    con = DBUtil.getConnection();
    ps = con.prepareStatement("SELECT MAX(reg) FROM provider");
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
        <a href="provider.jsp" class="btn btn-outline btn-sm">Provider Login</a>
        <a href="index.html" class="btn btn-outline btn-sm"><i class="fa-solid fa-house"></i> Home</a>
      </div>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card" style="max-width: 520px;">
      <div class="auth-header">
        <div class="auth-icon" style="background: #fef3c7; color: #b45309;">
          <i class="fa-solid fa-store"></i>
        </div>
        <h2>Register Your Business</h2>
        <p>List your domestic services on Urban Genie Ambajogai</p>
      </div>

      <form action="providerregister101.jsp" method="post" id="providerRegForm" onsubmit="return validateForm('providerRegForm');">
        <input type="hidden" name="reg" value="<%= reg %>">

        <div class="form-group">
          <label class="form-label" for="shopName">Business / Shop Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-shop input-icon"></i>
            <input type="text" id="shopName" name="shop" class="form-control" placeholder="e.g. Patil Electrical Services" required autofocus>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="ownerName">Owner / Technician Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user-tie input-icon"></i>
            <input type="text" id="ownerName" name="name" class="form-control" placeholder="e.g. Ramesh Patil" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="provCat">Service Category</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-tag input-icon"></i>
            <select id="provCat" name="category" class="form-control" required>
              <option value="">-- Choose Category --</option>
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
          <label class="form-label" for="provAdr">Shop Address (Ambajogai)</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-location-dot input-icon"></i>
            <input type="text" id="provAdr" name="adr" class="form-control" placeholder="Near Bus Stand, Shivaji Chowk..." required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="provPhone">Contact Phone Number (10 digits)</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-phone input-icon"></i>
            <input type="tel" id="provPhone" name="no" class="form-control" placeholder="9876543210" pattern="[0-9]{10}" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="provEmail">Business Email ID</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-envelope input-icon"></i>
            <input type="email" id="provEmail" name="email" class="form-control" placeholder="shop@example.com" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="provTime">Working Hours / Availability</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-clock input-icon"></i>
            <input type="text" id="provTime" name="time" class="form-control" placeholder="e.g. 9:00 AM – 7:00 PM" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="provAbout">About Business / Services Offered</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-circle-info input-icon"></i>
            <input type="text" id="provAbout" name="about" class="form-control" placeholder="Briefly describe your expertise and services" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="provPwd">Create Login Password</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-lock input-icon"></i>
            <input type="password" id="provPwd" name="pwd" class="form-control" placeholder="Minimum 4 characters" minlength="4" required>
            <button type="button" class="input-action" onclick="togglePasswordVisibility('provPwd', 'provEyeReg')" title="Toggle visibility">
              <i class="fa-regular fa-eye" id="provEyeReg"></i>
            </button>
          </div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block" style="background: #d97706;">
            <i class="fa-solid fa-check"></i> Register Provider Profile
          </button>
        </div>
      </form>

      <div class="auth-footer">
        Already registered? <a href="provider.jsp" style="font-weight: 600; color: #b45309;">Sign in to your shop</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>