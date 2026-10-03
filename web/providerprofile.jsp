<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Provider Dashboard — Urban Genie</title>

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
String name = (String) session.getAttribute("name");
String pwd  = (String) session.getAttribute("pwd");

if (name == null || pwd == null) {
    response.sendRedirect("provider.jsp");
    return;
}

Connection c1 = null;
PreparedStatement st = null;
ResultSet r = null;

int reg = 0;
String shop = "", owner = "", category = "", status = "", adr = "", phone = "", email = "", time = "";
int bookingCount = 0;
int feedbackCount = 0;
int pendingBookingCount = 0;

try {
    c1 = DBUtil.getConnection();
    st = c1.prepareStatement("SELECT * FROM provider WHERE name=? AND pwd=?");
    st.setString(1, name);
    st.setString(2, pwd);
    r = st.executeQuery();

    if (r.next()) {
        reg      = r.getInt("reg");
        shop     = r.getString("shop");
        owner    = r.getString("name");
        category = r.getString("category");
        status   = r.getString("status");
        adr      = r.getString("adr");
        phone    = r.getString("no");
        email    = r.getString("email");
        time     = r.getString("time");

        session.setAttribute("reg", String.valueOf(reg));
        session.setAttribute("preg", String.valueOf(reg));
        session.setAttribute("shop", shop);
        session.setAttribute("category", category);

        // Count booking requests
        PreparedStatement stBookings = null;
        ResultSet rsBookings = null;
        try {
            stBookings = c1.prepareStatement("SELECT COUNT(*) FROM booking WHERE preg=?");
            stBookings.setInt(1, reg);
            rsBookings = stBookings.executeQuery();
            if (rsBookings.next()) bookingCount = rsBookings.getInt(1);
            rsBookings.close();
            stBookings.close();

            stBookings = c1.prepareStatement("SELECT COUNT(*) FROM booking WHERE preg=? AND (status IS NULL OR LOWER(status)='pending')");
            stBookings.setInt(1, reg);
            rsBookings = stBookings.executeQuery();
            if (rsBookings.next()) pendingBookingCount = rsBookings.getInt(1);
        } catch (Exception ignore) {}
        finally {
            if (rsBookings != null) try { rsBookings.close(); } catch (Exception ignore) {}
            if (stBookings != null) try { stBookings.close(); } catch (Exception ignore) {}
        }

        // Count feedbacks for this shop
        PreparedStatement stFeedback = null;
        ResultSet rsFeedback = null;
        try {
            stFeedback = c1.prepareStatement("SELECT COUNT(*) FROM feedback WHERE shop=?");
            stFeedback.setString(1, shop);
            rsFeedback = stFeedback.executeQuery();
            if (rsFeedback.next()) feedbackCount = rsFeedback.getInt(1);
        } catch (Exception ignore) {}
        finally {
            if (rsFeedback != null) try { rsFeedback.close(); } catch (Exception ignore) {}
            if (stFeedback != null) try { stFeedback.close(); } catch (Exception ignore) {}
        }
    } else {
        response.sendRedirect("provider.jsp");
        return;
    }
} catch(Exception ex) {
    // fallback
} finally {
    if (r != null) try { r.close(); } catch(Exception ignore) {}
    if (st != null) try { st.close(); } catch(Exception ignore) {}
    if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
}

boolean isApproved = "approved".equalsIgnoreCase(status) || "active".equalsIgnoreCase(status);
%>

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="providerprofile.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
        <span class="brand-badge" style="background: #fef3c7; color: #b45309; border-color: #fde68a;">Provider</span>
      </a>

      <div style="display: flex; align-items: center; gap: 14px;">
        <a href="provider_detail.jsp?id=<%= reg %>" class="btn btn-outline btn-sm" target="_blank" title="View Public Profile">
          <i class="fa-regular fa-id-card"></i> Public Page
        </a>
        <div class="profile-pill">
          <div class="profile-avatar avatar-provider"><i class="fa-solid fa-store"></i></div>
          <div>
            <div style="font-weight: 600; font-size: 0.85rem;"><%= shop %></div>
            <div style="font-size: 0.72rem; color: <%= isApproved ? "var(--success)" : "var(--warning)" %>; font-weight: 500;">
              ● <%= status != null ? status : "Active" %>
            </div>
          </div>
        </div>
        <a href="providerlogout.jsp" class="btn btn-outline btn-sm" title="Log Out">
          <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </a>
      </div>
    </div>
  </header>

  <main class="app-container">
    <!-- Top Action Bar -->
    <div class="action-bar">
      <div class="page-heading">
        <h1><%= shop %></h1>
        <p>Managed by <%= owner %> &nbsp;|&nbsp; Category: <strong><%= category %></strong> &nbsp;|&nbsp; Hours: <%= time %></p>
      </div>
      <div>
        <span class="badge <%= isApproved ? "badge-approved" : "badge-pending" %>" style="font-size: 0.85rem; padding: 6px 14px;">
          <i class="fa-solid <%= isApproved ? "fa-circle-check" : "fa-clock" %>"></i>
          Account <%= isApproved ? "Approved & Verified" : "Pending Verification" %>
        </span>
      </div>
    </div>

    <!-- Notification Banner for Pending Leads -->
    <% if (pendingBookingCount > 0) { %>
    <div class="notification-banner">
      <div style="display: flex; align-items: center; gap: 14px;">
        <div style="width: 44px; height: 44px; border-radius: 50%; background: #fee2e2; color: #dc2626; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
          <i class="fa-solid fa-bell"></i>
        </div>
        <div>
          <strong style="color: var(--text-main); font-size: 0.96rem;">Action Required: <%= pendingBookingCount %> New Service Request<%= pendingBookingCount > 1 ? "s" : "" %>!</strong>
          <p style="margin: 2px 0 0; color: var(--text-secondary); font-size: 0.84rem;">Customers in Ambajogai are waiting for your confirmation.</p>
        </div>
      </div>
      <a href="provider_users.jsp" class="btn btn-primary btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
        Review Leads Now <i class="fa-solid fa-arrow-right"></i>
      </a>
    </div>
    <% } %>

    <!-- Live Metric Cards -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Customer Leads</div>
          <div class="stat-value"><%= bookingCount %></div>
        </div>
        <div class="stat-icon primary">
          <i class="fa-solid fa-calendar-check"></i>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Customer Reviews</div>
          <div class="stat-value"><%= feedbackCount %></div>
        </div>
        <div class="stat-icon warning">
          <i class="fa-solid fa-star"></i>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Business Phone</div>
          <div class="stat-value" style="font-size: 1.15rem; font-weight: 600; margin-top: 6px;"><%= phone %></div>
        </div>
        <div class="stat-icon success">
          <i class="fa-solid fa-phone"></i>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Shop Address</div>
          <div class="stat-value" style="font-size: 1.05rem; font-weight: 600; margin-top: 6px; max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= adr %></div>
        </div>
        <div class="stat-icon indigo">
          <i class="fa-solid fa-location-dot"></i>
        </div>
      </div>
    </div>

    <!-- Action Tiles -->
    <div style="font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; color: var(--text-main);">
      Business Operations
    </div>

    <div class="actions-grid">
      <!-- Inquiries -->
      <a href="provider_users.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--primary-subtle); color: var(--primary);">
            <i class="fa-solid fa-inbox"></i>
          </div>
          <h3>Customer Appointments (<%= bookingCount %>)</h3>
          <p>View all appointment requests from consumers in Ambajogai and send instant email confirmation alerts.</p>
        </div>
        <div class="action-tile-link">
          Manage All Inquiries <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Reviews -->
      <a href="providerfeedback.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--warning-subtle); color: #b45309;">
            <i class="fa-solid fa-comments"></i>
          </div>
          <h3>Customer Ratings (<%= feedbackCount %>)</h3>
          <p>Read client reviews and track service satisfaction ratings for work delivered by your shop.</p>
        </div>
        <div class="action-tile-link" style="color: #b45309;">
          Read Reviews <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Profile -->
      <a href="provider_profile111.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: #ede9fe; color: #7c3aed;">
            <i class="fa-solid fa-id-card"></i>
          </div>
          <h3>Shop Profile & Settings</h3>
          <p>Edit your shop name, contact number, opening hours, business description, and security password.</p>
        </div>
        <div class="action-tile-link" style="color: #7c3aed;">
          Edit Business Info <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>
    </div>

    <!-- Recent Customer Inquiries Section -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 12px; margin-bottom: 16px;">
      <div style="font-size: 1.1rem; font-weight: 700; color: var(--text-main);">
        Recent Customer Appointment Leads
      </div>
      <% if (bookingCount > 0) { %>
      <a href="provider_users.jsp" class="btn btn-outline btn-sm">
        View All Inquiries (<%= bookingCount %>) <i class="fa-solid fa-arrow-right"></i>
      </a>
      <% } %>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table">
          <thead>
            <tr>
              <th>Date & Time</th>
              <th>Customer Name</th>
              <th>Location</th>
              <th>Customer Phone</th>
              <th>Status</th>
              <th>Quick Actions</th>
            </tr>
          </thead>
          <tbody>
<%
Connection conLead = null;
PreparedStatement psLead = null;
ResultSet rsLead = null;
int leadCount = 0;
try {
    conLead = DBUtil.getConnection();
    psLead = conLead.prepareStatement("SELECT * FROM booking WHERE preg=? ORDER BY sr DESC LIMIT 3");
    psLead.setInt(1, reg);
    rsLead = psLead.executeQuery();
    while (rsLead.next()) {
        leadCount++;
        int lSr       = rsLead.getInt("sr");
        String lDate  = rsLead.getString("udate");
        String lName  = rsLead.getString("uname");
        String lAdr   = rsLead.getString("uadr");
        String lMob   = rsLead.getString("umob");
        String lEmail = rsLead.getString("uemail");
        String lShop  = rsLead.getString("shop");
        
        String lStatus = "Pending";
        try {
            lStatus = rsLead.getString("status");
            if (lStatus == null || lStatus.trim().isEmpty()) lStatus = "Pending";
        } catch(Exception eCol) {
            lStatus = "Pending";
        }
%>
            <tr>
              <td>
                <span style="font-size: 0.82rem; color: var(--text-secondary);">
                  <i class="fa-regular fa-clock" style="margin-right: 5px; color: var(--text-muted);"></i><%= lDate %>
                </span>
              </td>
              <td style="font-weight: 600; color: var(--text-main);"><%= lName %></td>
              <td><%= lAdr %></td>
              <td>
                <a href="tel:<%= lMob %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= lMob %>
                </a>
              </td>
              <td>
                <% if ("confirmed".equalsIgnoreCase(lStatus)) { %>
                  <span class="badge badge-approved"><i class="fa-solid fa-circle-check"></i> Confirmed</span>
                <% } else if ("declined".equalsIgnoreCase(lStatus)) { %>
                  <span class="badge" style="background:#fee2e2; color:#b91c1c; border-color:#fecaca;"><i class="fa-solid fa-circle-xmark"></i> Declined</span>
                <% } else if ("completed".equalsIgnoreCase(lStatus)) { %>
                  <span class="badge" style="background:#e0f2fe; color:#0369a1; border-color:#bae6fd;"><i class="fa-solid fa-badge-check"></i> Completed</span>
                <% } else { %>
                  <span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                <% } %>
              </td>
              <td>
                <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                  <% if ("pending".equalsIgnoreCase(lStatus)) { %>
                    <a href="booking_action.jsp?id=<%= lSr %>&action=approve" class="btn btn-success btn-sm" title="Approve Request">
                      <i class="fa-solid fa-check"></i>
                    </a>
                    <a href="booking_action.jsp?id=<%= lSr %>&action=decline" class="btn btn-danger btn-sm" onclick="return confirm('Decline this request?');" title="Decline Request">
                      <i class="fa-solid fa-xmark"></i>
                    </a>
                  <% } else if ("confirmed".equalsIgnoreCase(lStatus)) { %>
                    <a href="booking_action.jsp?id=<%= lSr %>&action=complete" class="btn btn-primary btn-sm" style="background:#7c3aed; border-color:#7c3aed;" title="Mark Completed">
                      <i class="fa-solid fa-check-double"></i>
                    </a>
                  <% } %>
                  <% if (lMob != null && !lMob.trim().isEmpty()) { %>
                  <a href="tel:<%= lMob %>" class="btn btn-outline btn-sm" style="color: var(--success); border-color: #bbf7d0;" title="Call <%= lName %>">
                    <i class="fa-solid fa-phone"></i>
                  </a>
                  <% } %>
                </div>
              </td>
            </tr>
<%
    }
    if (leadCount == 0) {
%>
            <tr class="empty-state-row">
              <td colspan="6" class="empty-state" style="padding: 32px 16px;">
                <p>No customer service requests received yet. Customer appointments will appear here automatically.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ignore) {
} finally {
    if (rsLead != null) try { rsLead.close(); } catch(Exception ignore) {}
    if (psLead != null) try { psLead.close(); } catch(Exception ignore) {}
    if (conLead != null) try { conLead.close(); } catch(Exception ignore) {}
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