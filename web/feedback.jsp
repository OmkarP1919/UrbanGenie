<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Select Provider for Review — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
String userName = (String) session.getAttribute("name");
if (userName == null) {
    response.sendRedirect("user.jsp");
    return;
}
%>
</head>
<body style="background: var(--bg-app);">

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="userprofile111.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
      </a>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card" style="max-width: 480px;">
      <div class="auth-header">
        <div class="auth-icon" style="background: var(--warning-subtle); color: #b45309;">
          <i class="fa-solid fa-star"></i>
        </div>
        <h2>Share Your Experience</h2>
        <p>Select the service provider you hired to leave your review</p>
      </div>

      <form action="givefeedback.jsp" method="post">
        <div class="form-group">
          <label class="form-label" for="shopSelect">Choose Service Provider / Shop</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-store input-icon"></i>
            <select id="shopSelect" name="shop" class="form-control" required>
              <option value="">-- Choose Verified Shop --</option>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    con = DBUtil.getConnection();
    ps = con.prepareStatement("SELECT DISTINCT shop, category FROM provider WHERE LOWER(status)='approved' ORDER BY shop ASC");
    rs = ps.executeQuery();
    while (rs.next()) {
        String shopName = rs.getString("shop");
        String category = rs.getString("category");
%>
              <option value="<%= shopName %>"><%= shopName %> (<%= category %>)</option>
<%
    }
} catch(Exception ex) {
%>
              <option value="">Error loading shops: <%= ex.getMessage() %></option>
<%
} finally {
    if (rs != null) try { rs.close(); } catch(Exception ignore) {}
    if (ps != null) try { ps.close(); } catch(Exception ignore) {}
    if (con != null) try { con.close(); } catch(Exception ignore) {}
}
%>
            </select>
          </div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block">
            <i class="fa-solid fa-pen-to-square"></i> Proceed to Review
          </button>
        </div>
      </form>

      <div class="auth-footer">
        <a href="userprofile111.jsp"><i class="fa-solid fa-arrow-left"></i> Back to Dashboard</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>