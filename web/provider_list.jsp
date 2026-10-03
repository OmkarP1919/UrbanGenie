<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Providers — Urban Genie Admin</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
if (session.getAttribute("name") == null || session.getAttribute("pwd") == null) {
    response.sendRedirect("admin.jsp");
    return;
}
%>
</head>
<body style="background: var(--bg-app);">

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="adminprofile.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--brand-indigo);"></i>
        Urban Genie
        <span class="brand-badge" style="background: #e0e7ff; color: var(--brand-indigo); border-color: #c7d2fe;">Admin Center</span>
      </a>
      <div style="display: flex; gap: 10px;">
        <a href="user_list.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-users"></i> Users</a>
        <a href="showfeedback.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-comments"></i> Reviews</a>
      </div>
    </div>
  </header>

  <main class="app-container" style="max-width: 1360px;">
    <div class="action-bar">
      <div class="page-heading">
        <h1>Service Provider Directory</h1>
        <p>Review business registrations, verify licenses, and approve or deactivate listings in Ambajogai</p>
      </div>
      <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
        <div class="search-box" style="margin: 0; min-width: 260px;">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="providerSearch" class="search-input" placeholder="Search shop, owner, trade..." onkeyup="filterTable('providerSearch', 'providerTable')">
        </div>
        <button type="button" onclick="exportTableToCSV('providerTable', 'Ambajogai_Registered_Providers.csv')" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-file-csv"></i> Export CSV
        </button>
        <a href="adminprofile.jsp" class="btn btn-outline">
          <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
      </div>
    </div>

    <!-- Status Filter Tabs -->
    <div class="filter-tabs" style="margin-bottom: 16px;">
      <button type="button" id="tabAll" class="filter-tab active" onclick="filterTableByStatus('all', 'providerTable', this)">All Providers</button>
      <button type="button" id="tabPending" class="filter-tab" onclick="filterTableByStatus('pending', 'providerTable', this)">Pending Verification</button>
      <button type="button" id="tabApproved" class="filter-tab" onclick="filterTableByStatus('approved', 'providerTable', this)">Approved Only</button>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="providerTable">
          <thead>
            <tr>
              <th>Reg No</th>
              <th>Business / Shop</th>
              <th>Owner Name</th>
              <th>Category</th>
              <th>Address</th>
              <th>Contact Phone</th>
              <th>Business Email</th>
              <th>Hours</th>
              <th>Status</th>
              <th>Management Actions</th>
            </tr>
          </thead>
          <tbody>
<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
int count = 0;
try {
    con = DBUtil.getConnection();
    st = con.createStatement();
    rs = st.executeQuery("SELECT * FROM provider ORDER BY reg DESC");

    while (rs.next()) {
        count++;
        int reg = rs.getInt("reg");
        String shop = rs.getString("shop");
        String name = rs.getString("name");
        String cat = rs.getString("category");
        String adr = rs.getString("adr");
        String no = rs.getString("no");
        String email = rs.getString("email");
        String time = rs.getString("time");
        String status = rs.getString("status");
        boolean isApproved = "approved".equalsIgnoreCase(status) || "active".equalsIgnoreCase(status);
%>
            <tr data-status="<%= isApproved ? "approved" : "pending" %>">
              <td><strong>#<%= reg %></strong></td>
              <td style="font-weight: 600; color: var(--text-main);"><%= shop %></td>
              <td><%= name %></td>
              <td><span class="badge badge-neutral"><%= cat %></span></td>
              <td><%= adr %></td>
              <td>
                <a href="tel:<%= no %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= no %>
                </a>
              </td>
              <td style="color: var(--text-secondary);"><%= email %></td>
              <td><span style="font-size: 0.8rem; color: var(--text-muted);"><%= time %></span></td>
              <td>
                <span class="badge <%= isApproved ? "badge-approved" : "badge-pending" %>">
                  <i class="fa-solid <%= isApproved ? "fa-circle-check" : "fa-clock" %>"></i>
                  <%= isApproved ? "Approved" : "Pending" %>
                </span>
              </td>
              <td>
                <div style="display: flex; gap: 8px;">
<% if (!isApproved) { %>
                  <a href="provider_approve.jsp?approve=<%= reg %>" class="btn btn-success btn-sm" title="Approve this provider">
                    <i class="fa-solid fa-check"></i> Approve
                  </a>
<% } %>
                  <a href="provider_delete.jsp?delete=<%= reg %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to remove <%= shop %>? This cannot be undone.');" title="Remove this provider">
                    <i class="fa-solid fa-trash"></i> Delete
                  </a>
                </div>
              </td>
            </tr>
<%
    }
    if (count == 0) {
%>
            <tr>
              <td colspan="10" class="empty-state">
                <div class="empty-state-icon"><i class="fa-solid fa-store-slash"></i></div>
                <p>No service providers found in the database.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr>
              <td colspan="10" style="text-align: center; color: var(--danger); padding: 24px;">
                Error retrieving providers: <%= ex.getMessage() %>
              </td>
            </tr>
<%
} finally {
    if (rs != null) try { rs.close(); } catch(Exception ignore) {}
    if (st != null) try { st.close(); } catch(Exception ignore) {}
    if (con != null) try { con.close(); } catch(Exception ignore) {}
}
%>
          </tbody>
        </table>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
  <script>
    (function() {
      var params = new URLSearchParams(window.location.search);
      if (params.get('filter') === 'pending') {
        var pendingTab = document.getElementById('tabPending');
        if (pendingTab) filterTableByStatus('pending', 'providerTable', pendingTab);
      }
    })();
  </script>
</body>
</html>