<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Appointment Requests — Urban Genie</title>

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
String providerName = (String) session.getAttribute("name");
if (providerName == null) {
    response.sendRedirect("provider.jsp");
    return;
}

String preg = (String) session.getAttribute("preg");
if (preg == null) preg = (String) session.getAttribute("reg");
String shop = (String) session.getAttribute("shop");
%>

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="providerprofile.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
        <span class="brand-badge" style="background: #fef3c7; color: #b45309; border-color: #fde68a;">Provider</span>
      </a>
      <div>
        <a href="providerlogout.jsp" class="btn btn-outline btn-sm" style="color: var(--danger); border-color: #fecaca;">
          <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </a>
      </div>
    </div>
  </header>

  <main class="app-container">
    <div class="action-bar">
      <div class="page-heading">
        <h1>Customer Appointment Requests</h1>
        <p>Manage incoming domestic service inquiries for <strong><%= shop != null ? shop : providerName %></strong></p>
      </div>
      <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
        <div class="search-box" style="margin: 0; min-width: 260px;">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="leadSearch" class="search-input" placeholder="Search customer, phone, trade..." onkeyup="filterTable('leadSearch', 'leadsTable')">
        </div>
        <button type="button" onclick="exportTableToCSV('leadsTable', '<%= (shop != null ? shop.replaceAll("[^a-zA-Z0-9]", "_") : "Provider") %>_Customer_Leads.csv')" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-file-csv"></i> Export CSV
        </button>
        <a href="providerprofile.jsp" class="btn btn-outline">
          <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
      </div>
    </div>

    <!-- Status Filter Tabs -->
    <div class="filter-tabs" style="margin-bottom: 16px;">
      <button type="button" class="filter-tab active" onclick="filterTableByStatus('all', 'leadsTable', this)">All Requests</button>
      <button type="button" class="filter-tab" onclick="filterTableByStatus('pending', 'leadsTable', this)">Pending Action</button>
      <button type="button" class="filter-tab" onclick="filterTableByStatus('confirmed', 'leadsTable', this)">Confirmed</button>
      <button type="button" class="filter-tab" onclick="filterTableByStatus('completed', 'leadsTable', this)">Completed</button>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="leadsTable">
          <thead>
            <tr>
              <th>Date & Time</th>
              <th>Customer Name</th>
              <th>Service Location</th>
              <th>Phone</th>
              <th>Email</th>
              <th>Trade</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
<%
Connection c1 = null;
PreparedStatement st = null;
ResultSet r = null;
int count = 0;
try {
    c1 = DBUtil.getConnection();
    
    // Secure query: Only load inquiries specifically for this authenticated provider
    if (preg != null && !preg.trim().isEmpty()) {
        st = c1.prepareStatement("SELECT * FROM booking WHERE preg=? ORDER BY sr DESC");
        st.setString(1, preg.trim());
    } else if (shop != null && !shop.trim().isEmpty()) {
        st = c1.prepareStatement("SELECT * FROM booking WHERE shop=? ORDER BY sr DESC");
        st.setString(1, shop.trim());
    } else {
        st = c1.prepareStatement("SELECT * FROM booking WHERE preg=0");
    }

    r = st.executeQuery();
    while (r.next()) {
        count++;
        int bSr = r.getInt("sr");
        String uDate = r.getString("udate");
        String uName = r.getString("uname");
        String uAdr  = r.getString("uadr");
        String uMob  = r.getString("umob");
        String uEmail= r.getString("uemail");
        String cat   = r.getString("category");
        String bShop = r.getString("shop");
        
        String bStatus = "Pending";
        try {
            bStatus = r.getString("status");
            if (bStatus == null || bStatus.trim().isEmpty()) bStatus = "Pending";
        } catch(Exception eCol) {
            bStatus = "Pending";
        }
%>
            <tr data-status="<%= bStatus.toLowerCase() %>">
              <td>
                <span style="font-size: 0.82rem; font-weight: 500; color: var(--text-secondary);">
                  <i class="fa-regular fa-clock" style="margin-right: 5px; color: var(--text-muted);"></i><%= uDate %>
                </span>
              </td>
              <td style="font-weight: 600; color: var(--text-main);"><%= uName %></td>
              <td><%= uAdr %></td>
              <td>
                <a href="tel:<%= uMob %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= uMob %>
                </a>
              </td>
              <td style="color: var(--text-secondary);"><%= uEmail %></td>
              <td><span class="badge badge-neutral"><%= cat %></span></td>
              <td>
                <% if ("confirmed".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge badge-approved"><i class="fa-solid fa-circle-check"></i> Confirmed</span>
                <% } else if ("declined".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge" style="background:#fee2e2; color:#b91c1c; border-color:#fecaca;"><i class="fa-solid fa-circle-xmark"></i> Declined</span>
                <% } else if ("completed".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge" style="background:#e0f2fe; color:#0369a1; border-color:#bae6fd;"><i class="fa-solid fa-badge-check"></i> Completed</span>
                <% } else if ("cancelled".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge" style="background:#f1f5f9; color:#64748b; border-color:#cbd5e1;"><i class="fa-solid fa-ban"></i> Cancelled</span>
                <% } else { %>
                  <span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                <% } %>
              </td>
              <td>
                <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                  <% if ("pending".equalsIgnoreCase(bStatus)) { %>
                    <a href="booking_action.jsp?id=<%= bSr %>&action=approve" class="btn btn-success btn-sm" title="Approve Request">
                      <i class="fa-solid fa-check"></i> Approve
                    </a>
                    <a href="booking_action.jsp?id=<%= bSr %>&action=decline" class="btn btn-danger btn-sm" onclick="return confirm('Decline this service appointment?');" title="Decline Request">
                      <i class="fa-solid fa-xmark"></i> Decline
                    </a>
                  <% } else if ("confirmed".equalsIgnoreCase(bStatus)) { %>
                    <a href="booking_action.jsp?id=<%= bSr %>&action=complete" class="btn btn-primary btn-sm" style="background:#7c3aed; border-color:#7c3aed;" title="Mark Service Completed">
                      <i class="fa-solid fa-check-double"></i> Mark Done
                    </a>
                  <% } %>

                  <% if (uMob != null && !uMob.trim().isEmpty()) { 
                     String cleanCustMob = uMob.replaceAll("[^0-9]", "");
                     if (cleanCustMob.length() == 10) cleanCustMob = "91" + cleanCustMob;
                     String waCustMsg = "Hello " + uName + ", this is " + (bShop != null ? bShop : providerName) + " regarding your service appointment on Urban Genie.";
                     String waCustUrl = "https://wa.me/" + cleanCustMob + "?text=" + java.net.URLEncoder.encode(waCustMsg, "UTF-8");
                  %>
                  <a href="tel:<%= uMob.trim() %>" class="btn btn-outline btn-sm" style="color: var(--success); border-color: #bbf7d0;" title="Call Customer">
                    <i class="fa-solid fa-phone"></i>
                  </a>
                  <% if (!cleanCustMob.isEmpty()) { %>
                  <a href="<%= waCustUrl %>" target="_blank" class="btn btn-outline btn-sm" style="color: #16a34a; border-color: #bbf7d0;" title="Chat with Customer on WhatsApp">
                    <i class="fa-brands fa-whatsapp"></i>
                  </a>
                  <% } } %>
                  <a href="email?uemail=<%= java.net.URLEncoder.encode(uEmail != null ? uEmail : "", "UTF-8") %>&shop=<%= java.net.URLEncoder.encode(bShop != null ? bShop : "", "UTF-8") %>" class="btn btn-outline btn-sm" title="Send Email Confirmation">
                    <i class="fa-solid fa-paper-plane"></i>
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
                <div class="empty-state-icon"><i class="fa-solid fa-inbox"></i></div>
                <p>No customer service inquiries received yet.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr>
              <td colspan="8" style="text-align: center; color: var(--danger); padding: 24px;">
                Error loading requests: <%= ex.getMessage() %>
              </td>
            </tr>
<%
} finally {
    if (r != null) try { r.close(); } catch(Exception ignore) {}
    if (st != null) try { st.close(); } catch(Exception ignore) {}
    if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
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