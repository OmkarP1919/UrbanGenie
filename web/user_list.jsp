<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manage Customers — Urban Genie Admin</title>

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
        <a href="provider_list.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-store"></i> Providers</a>
        <a href="showfeedback.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-comments"></i> Reviews</a>
      </div>
    </div>
  </header>

  <main class="app-container" style="max-width: 1360px;">
    <div class="action-bar">
      <div class="page-heading">
        <h1>Customer Account Management</h1>
        <p>Review and verify residents registered for domestic service booking in Ambajogai</p>
      </div>
      <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
        <div class="search-box" style="margin: 0; min-width: 260px;">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="userSearch" class="search-input" placeholder="Search customer, phone, email..." onkeyup="filterTable('userSearch', 'userTable')">
        </div>
        <button type="button" onclick="exportTableToCSV('userTable', 'Ambajogai_Registered_Customers.csv')" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-file-csv"></i> Export CSV
        </button>
        <a href="adminprofile.jsp" class="btn btn-outline">
          <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
      </div>
    </div>

    <!-- Status Filter Tabs -->
    <div class="filter-tabs" style="margin-bottom: 16px;">
      <button type="button" id="tabAllUsers" class="filter-tab active" onclick="filterTableByStatus('all', 'userTable', this)">All Customers</button>
      <button type="button" id="tabPendingUsers" class="filter-tab" onclick="filterTableByStatus('pending', 'userTable', this)">Pending Approval</button>
      <button type="button" id="tabApprovedUsers" class="filter-tab" onclick="filterTableByStatus('approved', 'userTable', this)">Approved Only</button>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="userTable">
          <thead>
            <tr>
              <th>Reg No</th>
              <th>Customer Name</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Ambajogai Address</th>
              <th>Gender</th>
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
    rs = st.executeQuery("SELECT * FROM user ORDER BY reg DESC");

    while (rs.next()) {
        count++;
        int reg = rs.getInt("reg");
        String name = rs.getString("name");
        String email = rs.getString("email");
        String no = rs.getString("no");
        String adr = rs.getString("adr");
        String gen = rs.getString("gen");
        String status = rs.getString("status");
        boolean isApproved = "approved".equalsIgnoreCase(status);
%>
            <tr data-status="<%= isApproved ? "approved" : "pending" %>">
              <td><strong>#<%= reg %></strong></td>
              <td style="font-weight: 600; color: var(--text-main);"><%= name %></td>
              <td style="color: var(--text-secondary);"><%= email %></td>
              <td>
                <a href="tel:<%= no %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= no %>
                </a>
              </td>
              <td><%= adr %></td>
              <td><span style="text-transform: capitalize;"><%= gen %></span></td>
              <td>
                <span class="badge <%= isApproved ? "badge-approved" : "badge-pending" %>">
                  <i class="fa-solid <%= isApproved ? "fa-circle-check" : "fa-clock" %>"></i>
                  <%= isApproved ? "Approved" : "Pending" %>
                </span>
              </td>
              <td>
                <div style="display: flex; gap: 8px;">
<% if (!isApproved) { %>
                  <a href="user_approve.jsp?approve=<%= reg %>" class="btn btn-success btn-sm" title="Approve customer">
                    <i class="fa-solid fa-check"></i> Approve
                  </a>
<% } %>
                  <a href="user_delete.jsp?delete=<%= reg %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete <%= name %>?');" title="Delete customer">
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
              <td colspan="8" class="empty-state">
                <div class="empty-state-icon"><i class="fa-solid fa-users-slash"></i></div>
                <p>No customer accounts found in the database.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr>
              <td colspan="8" style="text-align: center; color: var(--danger); padding: 24px;">
                Error loading users: <%= ex.getMessage() %>
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
        var pendingTab = document.getElementById('tabPendingUsers');
        if (pendingTab) filterTableByStatus('pending', 'userTable', pendingTab);
      }
    })();
  </script>
</body>
</html>