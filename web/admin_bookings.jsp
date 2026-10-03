<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Global Bookings Audit — Urban Genie Admin</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
if (session.getAttribute("name") == null || session.getAttribute("pwd") == null) {
    response.sendRedirect("admin.jsp");
    return;
}

int totalCount = 0;
int pendingCount = 0;
int confirmedCount = 0;
int completedCount = 0;
int cancelledCount = 0;

Connection conMetrics = null;
Statement stMetrics = null;
ResultSet rsMetrics = null;
try {
    conMetrics = DBUtil.getConnection();
    stMetrics = conMetrics.createStatement();
    
    rsMetrics = stMetrics.executeQuery("SELECT COUNT(*) FROM booking");
    if (rsMetrics.next()) totalCount = rsMetrics.getInt(1);
    rsMetrics.close();

    rsMetrics = stMetrics.executeQuery("SELECT COUNT(*) FROM booking WHERE LOWER(status)='pending'");
    if (rsMetrics.next()) pendingCount = rsMetrics.getInt(1);
    rsMetrics.close();

    rsMetrics = stMetrics.executeQuery("SELECT COUNT(*) FROM booking WHERE LOWER(status)='confirmed'");
    if (rsMetrics.next()) confirmedCount = rsMetrics.getInt(1);
    rsMetrics.close();

    rsMetrics = stMetrics.executeQuery("SELECT COUNT(*) FROM booking WHERE LOWER(status)='completed'");
    if (rsMetrics.next()) completedCount = rsMetrics.getInt(1);
    rsMetrics.close();

    rsMetrics = stMetrics.executeQuery("SELECT COUNT(*) FROM booking WHERE LOWER(status)='cancelled' OR LOWER(status)='declined'");
    if (rsMetrics.next()) cancelledCount = rsMetrics.getInt(1);
    rsMetrics.close();
} catch(Exception ignore) {
} finally {
    if (rsMetrics != null) try { rsMetrics.close(); } catch(Exception ignore) {}
    if (stMetrics != null) try { stMetrics.close(); } catch(Exception ignore) {}
    if (conMetrics != null) try { conMetrics.close(); } catch(Exception ignore) {}
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
        <a href="user_list.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-users"></i> Users</a>
        <a href="showfeedback.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-comments"></i> Reviews</a>
        <a href="adminprofile.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-gauge"></i> Dashboard</a>
      </div>
    </div>
  </header>

  <main class="app-container" style="max-width: 1400px;">
    <div class="action-bar">
      <div class="page-heading">
        <h1>Global Appointments & Bookings Audit</h1>
        <p>Monitor platform-wide domestic service transactions and provider fulfillment in Ambajogai</p>
      </div>
      <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
        <div class="search-box" style="margin: 0; min-width: 260px;">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="bookingSearch" class="search-input" placeholder="Search customer, shop, phone..." onkeyup="filterTable('bookingSearch', 'adminBookingsTable')">
        </div>
        <button type="button" onclick="exportTableToCSV('adminBookingsTable', 'UrbanGenie_Global_Bookings_Audit.csv')" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-file-csv"></i> Export CSV
        </button>
        <a href="adminprofile.jsp" class="btn btn-outline">
          <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
      </div>
    </div>

    <!-- Metrics Cards -->
    <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); margin-bottom: 24px;">
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Total Appointments</div>
          <div class="stat-value"><%= totalCount %></div>
        </div>
        <div class="stat-icon primary"><i class="fa-solid fa-calendar-check"></i></div>
      </div>
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Pending Response</div>
          <div class="stat-value"><%= pendingCount %></div>
        </div>
        <div class="stat-icon warning"><i class="fa-solid fa-clock"></i></div>
      </div>
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Confirmed Active</div>
          <div class="stat-value"><%= confirmedCount %></div>
        </div>
        <div class="stat-icon success"><i class="fa-solid fa-circle-check"></i></div>
      </div>
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Completed Jobs</div>
          <div class="stat-value"><%= completedCount %></div>
        </div>
        <div class="stat-icon indigo"><i class="fa-solid fa-badge-check"></i></div>
      </div>
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Declined / Cancelled</div>
          <div class="stat-value"><%= cancelledCount %></div>
        </div>
        <div class="stat-icon" style="background:#fee2e2; color:#b91c1c;"><i class="fa-solid fa-ban"></i></div>
      </div>
    </div>

    <!-- Status Filter Tabs -->
    <div class="filter-tabs" style="margin-bottom: 16px;">
      <button type="button" class="filter-tab active" onclick="filterTableByStatus('all', 'adminBookingsTable', this)">All Bookings</button>
      <button type="button" class="filter-tab" onclick="filterTableByStatus('pending', 'adminBookingsTable', this)">Pending</button>
      <button type="button" class="filter-tab" onclick="filterTableByStatus('confirmed', 'adminBookingsTable', this)">Confirmed</button>
      <button type="button" class="filter-tab" onclick="filterTableByStatus('completed', 'adminBookingsTable', this)">Completed</button>
      <button type="button" class="filter-tab" onclick="filterTableByStatus('declined', 'adminBookingsTable', this)">Declined / Cancelled</button>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="adminBookingsTable">
          <thead>
            <tr>
              <th>Ref #</th>
              <th>Date & Time</th>
              <th>Customer</th>
              <th>Customer Contact</th>
              <th>Shop / Provider</th>
              <th>Trade</th>
              <th>Location</th>
              <th>Status</th>
              <th>Provider Contact</th>
            </tr>
          </thead>
          <tbody>
<%
Connection con = null;
Statement st = null;
ResultSet rs = null;
int rowCount = 0;
try {
    con = DBUtil.getConnection();
    st = con.createStatement();
    rs = st.executeQuery("SELECT * FROM booking ORDER BY sr DESC");

    while (rs.next()) {
        rowCount++;
        int sr = rs.getInt("sr");
        String uDate = rs.getString("udate");
        String uName = rs.getString("uname");
        String uMob  = rs.getString("umob");
        String uEmail= rs.getString("uemail");
        String uAdr  = rs.getString("uadr");
        String shop  = rs.getString("shop");
        String cat   = rs.getString("category");
        String pMob  = rs.getString("pmob");
        String status= "Pending";
        try {
            status = rs.getString("status");
            if (status == null || status.trim().isEmpty()) status = "Pending";
        } catch(Exception eCol) { status = "Pending"; }

        String filterTag = status.toLowerCase();
        if ("cancelled".equals(filterTag)) filterTag = "declined";
%>
            <tr data-status="<%= filterTag %>">
              <td><strong>#<%= sr %></strong></td>
              <td>
                <span style="font-size: 0.82rem; color: var(--text-secondary);">
                  <i class="fa-regular fa-clock" style="margin-right: 4px; color: var(--text-muted);"></i><%= uDate %>
                </span>
              </td>
              <td style="font-weight: 600; color: var(--text-main);"><%= uName %></td>
              <td>
                <a href="tel:<%= uMob %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.75rem; margin-right: 4px;"></i><%= uMob %>
                </a>
              </td>
              <td style="font-weight: 600;"><%= shop %></td>
              <td><span class="badge badge-neutral"><%= cat %></span></td>
              <td><%= uAdr %></td>
              <td>
                <% if ("confirmed".equalsIgnoreCase(status)) { %>
                  <span class="badge badge-approved"><i class="fa-solid fa-circle-check"></i> Confirmed</span>
                <% } else if ("declined".equalsIgnoreCase(status)) { %>
                  <span class="badge" style="background:#fee2e2; color:#b91c1c; border-color:#fecaca;"><i class="fa-solid fa-circle-xmark"></i> Declined</span>
                <% } else if ("cancelled".equalsIgnoreCase(status)) { %>
                  <span class="badge" style="background:#f1f5f9; color:#64748b; border-color:#cbd5e1;"><i class="fa-solid fa-ban"></i> Cancelled</span>
                <% } else if ("completed".equalsIgnoreCase(status)) { %>
                  <span class="badge" style="background:#e0f2fe; color:#0369a1; border-color:#bae6fd;"><i class="fa-solid fa-badge-check"></i> Completed</span>
                <% } else { %>
                  <span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                <% } %>
              </td>
              <td>
                <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                  <% if (pMob != null && !pMob.trim().isEmpty()) { 
                     String cleanPMob = pMob.replaceAll("[^0-9]", "");
                     if (cleanPMob.length() == 10) cleanPMob = "91" + cleanPMob;
                     String waUrl = "https://wa.me/" + cleanPMob;
                  %>
                  <a href="tel:<%= pMob %>" class="btn btn-outline btn-sm" title="Call Provider">
                    <i class="fa-solid fa-phone"></i>
                  </a>
                  <% if (!cleanPMob.isEmpty()) { %>
                  <a href="<%= waUrl %>" target="_blank" class="btn btn-outline btn-sm" style="color: #16a34a; border-color: #bbf7d0;" title="WhatsApp Provider">
                    <i class="fa-brands fa-whatsapp"></i>
                  </a>
                  <% } } %>
                </div>
              </td>
            </tr>
<%
    }
    if (rowCount == 0) {
%>
            <tr>
              <td colspan="9" class="empty-state">
                <div class="empty-state-icon"><i class="fa-solid fa-calendar-xmark"></i></div>
                <p>No customer service appointments logged on the platform yet.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr>
              <td colspan="9" style="text-align: center; color: var(--danger); padding: 24px;">
                Error retrieving bookings audit: <%= ex.getMessage() %>
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
</body>
</html>
