<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Dashboard — Urban Genie</title>

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
    response.sendRedirect("user.jsp");
    return;
}

Connection c1 = null;
PreparedStatement st = null;
ResultSet r = null;
int ureg = 0;
String userEmail = "", userPhone = "", userAdr = "";
int myBookingsCount = 0;
int confirmedBookingsCount = 0;

try {
    c1 = DBUtil.getConnection();
    st = c1.prepareStatement("SELECT reg,email,no,adr,gen FROM user WHERE name=? AND pwd=?");
    st.setString(1, name);
    st.setString(2, pwd);
    r = st.executeQuery();

    if (r.next()) {
        ureg = r.getInt("reg");
        userEmail = r.getString("email");
        userPhone = r.getString("no");
        userAdr   = r.getString("adr");

        session.setAttribute("reg", String.valueOf(ureg));
        session.setAttribute("ureg", String.valueOf(ureg));
        session.setAttribute("email", userEmail);
        session.setAttribute("uemail", userEmail);
        session.setAttribute("mob", userPhone);
        session.setAttribute("umob", userPhone);
        session.setAttribute("adr", userAdr);
        session.setAttribute("uadr", userAdr);
        session.setAttribute("name", name);
        session.setAttribute("uname", name);

        // Count user bookings
        PreparedStatement stCount = null;
        ResultSet rsCount = null;
        try {
            stCount = c1.prepareStatement("SELECT COUNT(*) FROM booking WHERE ureg=?");
            stCount.setInt(1, ureg);
            rsCount = stCount.executeQuery();
            if (rsCount.next()) myBookingsCount = rsCount.getInt(1);
            rsCount.close();
            stCount.close();

            stCount = c1.prepareStatement("SELECT COUNT(*) FROM booking WHERE ureg=? AND LOWER(status)='confirmed'");
            stCount.setInt(1, ureg);
            rsCount = stCount.executeQuery();
            if (rsCount.next()) confirmedBookingsCount = rsCount.getInt(1);
        } catch (Exception ignore) {}
        finally {
            if (rsCount != null) try { rsCount.close(); } catch (Exception ignore) {}
            if (stCount != null) try { stCount.close(); } catch (Exception ignore) {}
        }
    } else {
        response.sendRedirect("user.jsp");
        return;
    }
} catch(Exception ex) {
    // fallback
} finally {
    if (r != null) try { r.close(); } catch (Exception ignore) {}
    if (st != null) try { st.close(); } catch (Exception ignore) {}
    if (c1 != null) try { c1.close(); } catch (Exception ignore) {}
}
%>

  <!-- Topbar Navigation -->
  <header class="app-header">
    <div class="navbar">
      <a href="userprofile111.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
        <span class="brand-badge">Customer</span>
      </a>

      <div style="display: flex; align-items: center; gap: 14px;">
        <div class="profile-pill">
          <div class="profile-avatar"><i class="fa-solid fa-user"></i></div>
          <div>
            <div style="font-weight: 600; font-size: 0.85rem;"><%= name %></div>
            <div style="font-size: 0.72rem; color: var(--success); font-weight: 500;">● Active</div>
          </div>
        </div>
        <a href="userlogout.jsp" class="btn btn-outline btn-sm" title="Log Out">
          <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
        </a>
      </div>
    </div>
  </header>

  <main class="app-container">
    <!-- Header -->
    <div class="action-bar">
      <div class="page-heading">
        <h1>Welcome, <%= name %></h1>
        <p>Book verified trade professionals and track your domestic service requests in Ambajogai.</p>
      </div>
    </div>

    <!-- Notification Banner for Confirmed Appointments -->
    <% if (confirmedBookingsCount > 0) { %>
    <div class="notification-banner" style="background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); border-color: #bbf7d0;">
      <div style="display: flex; align-items: center; gap: 14px;">
        <div style="width: 44px; height: 44px; border-radius: 50%; background: #dcfce7; color: #16a34a; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
          <i class="fa-solid fa-circle-check"></i>
        </div>
        <div>
          <strong style="color: #14532d; font-size: 0.96rem;">Service Appointment Confirmed!</strong>
          <p style="margin: 2px 0 0; color: #166534; font-size: 0.84rem;">You have <%= confirmedBookingsCount %> confirmed booking<%= confirmedBookingsCount > 1 ? "s" : "" %> ready. View booking details or connect with the provider.</p>
        </div>
      </div>
      <a href="userbookings.jsp" class="btn btn-success btn-sm" style="display: inline-flex; align-items: center; gap: 6px;">
        View Bookings <i class="fa-solid fa-arrow-right"></i>
      </a>
    </div>
    <% } %>

    <!-- Quick Metrics -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">My Total Bookings</div>
          <div class="stat-value"><%= myBookingsCount %></div>
        </div>
        <div class="stat-icon primary">
          <i class="fa-solid fa-calendar-check"></i>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Registered Phone</div>
          <div class="stat-value" style="font-size: 1.15rem; font-weight: 600; margin-top: 6px;"><%= userPhone != null ? userPhone : "N/A" %></div>
        </div>
        <div class="stat-icon success">
          <i class="fa-solid fa-phone"></i>
        </div>
      </div>

      <div class="stat-card">
        <div class="stat-info">
          <div class="stat-label">Ambajogai Location</div>
          <div class="stat-value" style="font-size: 1.05rem; font-weight: 600; margin-top: 6px; max-width: 180px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"><%= userAdr != null ? userAdr : "Ambajogai" %></div>
        </div>
        <div class="stat-icon indigo">
          <i class="fa-solid fa-location-dot"></i>
        </div>
      </div>
    </div>

    <!-- Main Navigation Tiles -->
    <div style="font-size: 1.1rem; font-weight: 700; margin-bottom: 16px; color: var(--text-main);">
      Service Actions
    </div>
    
    <div class="actions-grid">
      <!-- Book Service -->
      <a href="service.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--primary-subtle); color: var(--primary);">
            <i class="fa-solid fa-magnifying-glass"></i>
          </div>
          <h3>Find & Book Service</h3>
          <p>Browse plumbers, electricians, carpenters, cleaners, and mechanics with verified shop profiles.</p>
        </div>
        <div class="action-tile-link">
          Explore Services <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- My Bookings -->
      <a href="userbookings.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--success-subtle); color: var(--success);">
            <i class="fa-solid fa-clock-rotate-left"></i>
          </div>
          <h3>My Bookings (<%= myBookingsCount %>)</h3>
          <p>View your complete booking history, provider contact numbers, and appointment receipts.</p>
        </div>
        <div class="action-tile-link" style="color: var(--success);">
          View All History <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Give Feedback -->
      <a href="feedback.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: var(--warning-subtle); color: #b45309;">
            <i class="fa-solid fa-star"></i>
          </div>
          <h3>Submit Provider Review</h3>
          <p>Rate the craftsmanship and punctuality of service providers you have booked in Ambajogai.</p>
        </div>
        <div class="action-tile-link" style="color: #b45309;">
          Write Feedback <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>

      <!-- Profile -->
      <a href="userprofile.jsp" class="action-tile">
        <div>
          <div class="action-tile-icon" style="background: #ede9fe; color: #7c3aed;">
            <i class="fa-solid fa-user-gear"></i>
          </div>
          <h3>Account Settings</h3>
          <p>Update your residential address, contact mobile number, or update your account password.</p>
        </div>
        <div class="action-tile-link" style="color: #7c3aed;">
          Manage Account <i class="fa-solid fa-arrow-right"></i>
        </div>
      </a>
    </div>

    <!-- Recent Bookings Table Section -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 12px; margin-bottom: 16px;">
      <div style="font-size: 1.1rem; font-weight: 700; color: var(--text-main);">
        Recent Service Requests
      </div>
      <% if (myBookingsCount > 0) { %>
      <a href="userbookings.jsp" class="btn btn-outline btn-sm">
        View All (<%= myBookingsCount %>) <i class="fa-solid fa-arrow-right"></i>
      </a>
      <% } %>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table">
          <thead>
            <tr>
              <th>Date & Time</th>
              <th>Provider / Shop</th>
              <th>Category</th>
              <th>Provider Phone</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
<%
Connection conRecent = null;
PreparedStatement psRecent = null;
ResultSet rsRecent = null;
int recentCount = 0;
try {
    conRecent = DBUtil.getConnection();
    psRecent = conRecent.prepareStatement("SELECT * FROM booking WHERE ureg=? ORDER BY sr DESC LIMIT 3");
    psRecent.setInt(1, ureg);
    rsRecent = psRecent.executeQuery();
    while (rsRecent.next()) {
        recentCount++;
        String rDate = rsRecent.getString("udate");
        String rShop = rsRecent.getString("shop");
        String rCat  = rsRecent.getString("category");
        String rMob  = rsRecent.getString("pmob");
%>
            <tr>
              <td>
                <span style="font-size: 0.82rem; color: var(--text-secondary);">
                  <i class="fa-regular fa-calendar" style="margin-right: 5px; color: var(--text-muted);"></i><%= rDate %>
                </span>
              </td>
              <td style="font-weight: 600; color: var(--text-main);"><%= rShop %></td>
              <td><span class="badge badge-neutral"><%= rCat %></span></td>
              <td>
                <a href="tel:<%= rMob %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= rMob %>
                </a>
              </td>
              <td>
                <span class="badge badge-success">
                  <i class="fa-solid fa-circle-check"></i> Confirmed
                </span>
              </td>
              <td>
                <a href="givefeedback.jsp?shop=<%= java.net.URLEncoder.encode(rShop, "UTF-8") %>" class="btn btn-outline btn-sm" style="color: #b45309; border-color: #fde68a;">
                  <i class="fa-solid fa-star"></i> Review
                </a>
              </td>
            </tr>
<%
    }
    if (recentCount == 0) {
%>
            <tr class="empty-state-row">
              <td colspan="6" class="empty-state" style="padding: 32px 16px;">
                <p>No recent service requests. Ready to hire a specialist?</p>
                <div style="margin-top: 12px;">
                  <a href="service.jsp" class="btn btn-primary btn-sm"><i class="fa-solid fa-magnifying-glass"></i> Explore Services</a>
                </div>
              </td>
            </tr>
<%
    }
} catch(Exception ignore) {
} finally {
    if (rsRecent != null) try { rsRecent.close(); } catch(Exception ignore) {}
    if (psRecent != null) try { psRecent.close(); } catch(Exception ignore) {}
    if (conRecent != null) try { conRecent.close(); } catch(Exception ignore) {}
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