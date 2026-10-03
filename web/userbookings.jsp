<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Bookings — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
String userName = (String) session.getAttribute("name");
if (userName == null) {
    response.sendRedirect("user.jsp");
    return;
}

String ureg = (String) session.getAttribute("reg");
if (ureg == null) ureg = (String) session.getAttribute("ureg");
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
      <div style="display: flex; gap: 10px;">
        <a href="service.jsp" class="btn btn-primary btn-sm"><i class="fa-solid fa-plus"></i> New Booking</a>
        <a href="userprofile111.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-gauge"></i> Dashboard</a>
      </div>
    </div>
  </header>

  <main class="app-container" style="max-width: 1250px;">
    <div class="action-bar">
      <div class="page-heading">
        <h1>My Service Bookings</h1>
        <p>Complete record of domestic services booked by <%= userName %></p>
      </div>
      <!-- Live Search Filter -->
      <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" id="bookingSearchInput" placeholder="Filter bookings by shop or trade..." onkeyup="filterTable('bookingSearchInput', 'bookingsTable')">
      </div>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="bookingsTable">
          <thead>
            <tr>
              <th>Date & Time</th>
              <th>Service Provider</th>
              <th>Category</th>
              <th>Provider Address</th>
              <th>Provider Phone</th>
              <th>Status</th>
              <th>Actions</th>
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
    
    // Secure query: Only load bookings belonging to this authenticated user
    if (ureg != null && !ureg.trim().isEmpty()) {
        st = c1.prepareStatement("SELECT * FROM booking WHERE ureg=? ORDER BY sr DESC");
        st.setString(1, ureg.trim());
    } else {
        st = c1.prepareStatement("SELECT * FROM booking WHERE uname=? ORDER BY sr DESC");
        st.setString(1, userName);
    }

    r = st.executeQuery();
    while (r.next()) {
        count++;
        String shop = r.getString("shop");
        String cat = r.getString("category");
        String pAdr = r.getString("padr");
        String pMob = r.getString("pmob");
        String dt = r.getString("udate");
        int bSr = r.getInt("sr");
        String bStatus = "Pending";
        try {
            bStatus = r.getString("status");
            if (bStatus == null || bStatus.trim().isEmpty()) bStatus = "Pending";
        } catch(Exception eCol) {
            bStatus = "Confirmed";
        }

        String cleanMob = pMob != null ? pMob.replaceAll("[^0-9]", "") : "";
        if (cleanMob.length() == 10) cleanMob = "91" + cleanMob;
        String waMsg = "Hello " + shop + ", I booked your " + cat + " service on Urban Genie Ambajogai. Could you please share updates?";
        String waUrl = "https://wa.me/" + cleanMob + "?text=" + java.net.URLEncoder.encode(waMsg, "UTF-8");
%>
            <tr>
              <td>
                <span style="font-size: 0.82rem; font-weight: 500; color: var(--text-secondary);">
                  <i class="fa-regular fa-calendar-check" style="margin-right: 6px; color: var(--text-muted);"></i><%= dt %>
                </span>
              </td>
              <td style="font-weight: 600; color: var(--text-main);"><%= shop %></td>
              <td><span class="badge badge-neutral"><%= cat %></span></td>
              <td><%= pAdr %></td>
              <td>
                <a href="tel:<%= pMob %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= pMob %>
                </a>
              </td>
              <td>
                <% if ("confirmed".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge badge-approved" title="Provider accepted appointment">
                    <i class="fa-solid fa-circle-check"></i> Confirmed
                  </span>
                <% } else if ("declined".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge" style="background:#fee2e2; color:#b91c1c; border-color:#fecaca;" title="Provider unavailable">
                    <i class="fa-solid fa-circle-xmark"></i> Declined
                  </span>
                <% } else if ("completed".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge" style="background:#e0f2fe; color:#0369a1; border-color:#bae6fd;" title="Service completed">
                    <i class="fa-solid fa-circle-check"></i> Completed
                  </span>
                <% } else if ("cancelled".equalsIgnoreCase(bStatus)) { %>
                  <span class="badge" style="background:#f1f5f9; color:#64748b; border-color:#cbd5e1;" title="Booking cancelled">
                    <i class="fa-solid fa-ban"></i> Cancelled
                  </span>
                <% } else { %>
                  <span class="badge badge-pending" title="Awaiting provider confirmation">
                    <i class="fa-solid fa-clock"></i> Pending
                  </span>
                <% } %>
              </td>
              <td>
                <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                  <a href="tel:<%= pMob %>" class="btn btn-outline btn-sm" title="Call <%= shop %>">
                    <i class="fa-solid fa-phone"></i>
                  </a>
                  <% if (!cleanMob.isEmpty()) { %>
                    <a href="<%= waUrl %>" target="_blank" class="btn btn-outline btn-sm" style="color: #16a34a; border-color: #bbf7d0;" title="Chat on WhatsApp">
                      <i class="fa-brands fa-whatsapp"></i>
                    </a>
                  <% } %>
                  <% if ("pending".equalsIgnoreCase(bStatus)) { %>
                    <a href="user_cancel_booking.jsp?id=<%= bSr %>" class="btn btn-outline btn-sm" style="color: var(--danger); border-color: #fecaca;" onclick="return confirm('Are you sure you want to cancel this booking?');" title="Cancel Booking">
                      <i class="fa-solid fa-xmark"></i> Cancel
                    </a>
                  <% } else if ("completed".equalsIgnoreCase(bStatus) || "confirmed".equalsIgnoreCase(bStatus)) { %>
                    <a href="givefeedback.jsp?shop=<%= java.net.URLEncoder.encode(shop, "UTF-8") %>" class="btn btn-outline btn-sm" style="color: #b45309; border-color: #fde68a;" title="Rate & Review">
                      <i class="fa-solid fa-star"></i> Review
                    </a>
                  <% } else if ("declined".equalsIgnoreCase(bStatus) || "cancelled".equalsIgnoreCase(bStatus)) { %>
                    <a href="service.jsp" class="btn btn-primary btn-sm" title="Find another provider">
                      Re-book
                    </a>
                  <% } %>
                </div>
              </td>
            </tr>
<%
    }
    if (count == 0) {
%>
            <tr class="empty-state-row">
              <td colspan="7" class="empty-state">
                <div class="empty-state-icon"><i class="fa-solid fa-calendar-xmark"></i></div>
                <p>You haven't booked any service requests yet.</p>
                <div style="margin-top: 14px;">
                  <a href="service.jsp" class="btn btn-primary btn-sm">Find Local Services</a>
                </div>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr class="empty-state-row">
              <td colspan="7" style="text-align: center; color: var(--danger); padding: 24px;">
                Error retrieving bookings: <%= ex.getMessage() %>
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