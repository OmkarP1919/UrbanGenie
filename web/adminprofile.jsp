<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Command Center — Urban Genie</title>

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
if (session.getAttribute("name") == null || session.getAttribute("pwd") == null) {
    response.sendRedirect("admin.jsp");
    return;
}
String admin = (String) session.getAttribute("name");

int totalUsers = 0;
int totalProviders = 0;
int totalBookings = 0;
int totalFeedbacks = 0;
int pendingProviders = 0;
int pendingUsers = 0;

Connection con = null;
Statement st = null;
ResultSet rs = null;
try {
    con = DBUtil.getConnection();
    st = con.createStatement();
    
    rs = st.executeQuery("SELECT COUNT(*) FROM user");
    if (rs.next()) totalUsers = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM user WHERE LOWER(status) != 'approved'");
    if (rs.next()) pendingUsers = rs.getInt(1);
    rs.close();
    
    rs = st.executeQuery("SELECT COUNT(*) FROM provider");
    if (rs.next()) totalProviders = rs.getInt(1);
    rs.close();

    rs = st.executeQuery("SELECT COUNT(*) FROM provider WHERE LOWER(status) != 'approved'");
    if (rs.next()) pendingProviders = rs.getInt(1);
    rs.close();
    
    rs = st.executeQuery("SELECT COUNT(*) FROM booking");
    if (rs.next()) totalBookings = rs.getInt(1);
    rs.close();
    
    rs = st.executeQuery("SELECT COUNT(*) FROM feedback");
    if (rs.next()) totalFeedbacks = rs.getInt(1);
} catch (Exception ex) {
    // defaults to 0 on error
} finally {
    if (rs != null) try { rs.close(); } catch (Exception ignore) {}
    if (st != null) try { st.close(); } catch (Exception ignore) {}
    if (con != null) try { con.close(); } catch (Exception ignore) {}
}
%>

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="adminprofile.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--brand-indigo);"></i>
        Urban Genie
        <span class="brand-badge" style="background: #e0e7ff; color: var(--brand-indigo); border-color: #c7d2fe;">Admin Center</span>
      </a>

      <div style="display: flex; align-items: center; gap: 14px;">
        <div class="profile-pill">
          <div class="profile-avatar avatar-admin"><i class="fa-solid fa-user-shield"></i></div>
          <div>
            <div style="font-weight: 600; font-size: 0.85rem;"><%= admin != null ? admin : "Administrator" %></div>
            <div style="font-size: 0.72rem; color: var(--success); font-weight: 500;">● Staff Online</div>
          </div>
        </div>
        <a href="adminlogout.jsp" class="btn btn-outline btn-sm" title="Log Out">
          <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </a>
      </div>
    </div>
  </header>

  <main class="app-container">
    <div class="action-bar">
      <div class="page-heading">
        <h1>Administrative Command Center</h1>
        <p>Operational overview and management controls for Ambajogai Dial platform</p>
      </div>
    </div>

    <% if (pendingProviders > 0 || pendingUsers > 0) { %>
    <!-- Pending Approvals Alert Banner -->
    <div style="background: #fffbeb; border: 1px solid #fef3c7; border-left: 4px solid #f59e0b; border-radius: var(--radius-md); padding: 16px 20px; margin-bottom: 24px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
      <div style="display: flex; align-items: center; gap: 14px;">
        <div style="width: 40px; height: 40px; border-radius: 50%; background: #fef3c7; display: flex; align-items: center; justify-content: center; color: #d97706; font-size: 1.1rem;">
          <i class="fa-solid fa-bell"></i>
        </div>
        <div>
          <h4 style="margin: 0; font-size: 0.95rem; font-weight: 700; color: #92400e;">Pending Verifications Require Action</h4>
          <p style="margin: 3px 0 0; font-size: 0.85rem; color: #b45309;">
            You have <strong><%= pendingProviders %></strong> provider application(s) and <strong><%= pendingUsers %></strong> user account(s) waiting for approval.
          </p>
        </div>
      </div>
      <div style="display: flex; gap: 8px;">
        <% if (pendingProviders > 0) { %>
          <a href="provider_list.jsp" class="btn btn-warning btn-sm" style="background: #f59e0b; border-color: #f59e0b; color: white;">
            <i class="fa-solid fa-store"></i> Providers (<%= pendingProviders %>)
          </a>
        <% } %>
        <% if (pendingUsers > 0) { %>
          <a href="user_list.jsp" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-users"></i> Users (<%= pendingUsers %>)
          </a>
        <% } %>
      </div>
    </div>
    <% } else { %>
    <div style="background: #f0fdf4; border: 1px solid #dcfce7; border-left: 4px solid #22c55e; border-radius: var(--radius-md); padding: 12px 18px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 0.88rem; color: #166534;">
      <i class="fa-solid fa-circle-check" style="color: #22c55e;"></i>
      <span>All service providers and consumer accounts are currently reviewed and approved.</span>
    </div>
    <% } %>

    <!-- Metrics Cards -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Registered Consumers</div>
          <div class="stat-value"><%= totalUsers %></div>
        </div>
        <div class="stat-icon primary">
          <i class="fa-solid fa-users"></i>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Service Providers</div>
          <div class="stat-value"><%= totalProviders %></div>
        </div>
        <div class="stat-icon warning">
          <i class="fa-solid fa-store"></i>
        </div>
      </div>

      <a href="admin_bookings.jsp" class="stat-card" style="text-decoration: none; color: inherit;">
        <div class="stat-info">
          <div class="stat-label">Total Service Bookings</div>
          <div class="stat-value"><%= totalBookings %></div>
        </div>
        <div class="stat-icon success">
          <i class="fa-solid fa-calendar-check"></i>
        </div>
      </a>

      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Customer Reviews</div>
          <div class="stat-value"><%= totalFeedbacks %></div>
        </div>
        <div class="stat-icon indigo">
          <i class="fa-solid fa-comments"></i>
        </div>
      </div>
    </div>

    <!-- Management Action Grid -->
    <div style="font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; color: var(--text-main);">
      System Moderation & Controls
    </div>

    <div class="actions-grid">
      <!-- Manage Providers -->
      <a href="provider_list.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: #fef3c7; color: #b45309;">
            <i class="fa-solid fa-handshake-angle"></i>
          </div>
          <h3>Service Providers Directory</h3>
          <p>Inspect incoming business applications, grant verified approvals, or delete inactive trade listings.</p>
        </div>
        <div class="action-tile-link" style="color: #b45309;">
          Manage Providers (<%= totalProviders %>) <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Manage Customers -->
      <a href="user_list.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--primary-subtle); color: var(--primary);">
            <i class="fa-solid fa-users-gear"></i>
          </div>
          <h3>Customer Accounts</h3>
          <p>Review newly registered residents, approve accounts for portal booking, and manage user memberships.</p>
        </div>
        <div class="action-tile-link">
          Manage Consumers (<%= totalUsers %>) <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Appointments Audit -->
      <a href="admin_bookings.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--success-subtle); color: var(--success);">
            <i class="fa-solid fa-calendar-days"></i>
          </div>
          <h3>Appointments & Bookings Audit</h3>
          <p>Monitor platform-wide domestic service transactions, track confirmation statuses, and resolve booking inquiries.</p>
        </div>
        <div class="action-tile-link" style="color: var(--success);">
          Audit Bookings (<%= totalBookings %>) <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Reviews -->
      <a href="showfeedback.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: #ede9fe; color: #7c3aed;">
            <i class="fa-solid fa-star-half-stroke"></i>
          </div>
          <h3>Feedback & Reviews Moderation</h3>
          <p>Read customer reviews across all shops, audit service satisfaction ratings, and delete abusive reviews.</p>
        </div>
        <div class="action-tile-link" style="color: #7c3aed;">
          Audit Reviews (<%= totalFeedbacks %>) <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Catalog -->
      <a href="showservice.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--bg-subtle); color: var(--text-secondary);">
            <i class="fa-solid fa-rectangle-list"></i>
          </div>
          <h3>Directory Catalog Preview</h3>
          <p>Inspect the live public service directory as displayed to consumers across all trade categories.</p>
        </div>
        <div class="action-tile-link" style="color: var(--text-main);">
          Inspect Catalog <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>