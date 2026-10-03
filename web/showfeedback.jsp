<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Reviews Audit — Urban Genie Admin</title>

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
        <a href="user_list.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-users"></i> Users</a>
      </div>
    </div>
  </header>

  <main class="app-container">
    <div class="action-bar">
      <div class="page-heading">
        <h1>All Customer Reviews & Ratings</h1>
        <p>Platform-wide feedback audit for Ambajogai service providers</p>
      </div>
      <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
        <div class="search-box" style="margin: 0; min-width: 240px;">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="feedbackSearch" class="search-input" placeholder="Search provider, user, review..." onkeyup="filterTable('feedbackSearch', 'adminFeedbackTable')">
        </div>
        <a href="adminprofile.jsp" class="btn btn-outline">
          <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
      </div>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="adminFeedbackTable">
          <thead>
            <tr>
              <th style="width: 220px;">Service Provider / Shop</th>
              <th style="width: 180px;">Reviewer Name</th>
              <th style="width: 130px;">Rating</th>
              <th>Customer Feedback</th>
              <th style="width: 100px;">Action</th>
            </tr>
          </thead>
          <tbody>
<%
Connection c1 = null;
Statement st = null;
ResultSet r = null;
int count = 0;
try {
    c1 = DBUtil.getConnection();
    st = c1.createStatement();
    try {
        r = st.executeQuery("SELECT * FROM feedback ORDER BY sr DESC");
    } catch(Exception eOrder) {
        r = st.executeQuery("SELECT * FROM feedback");
    }

    while (r.next()) {
        count++;
        int sr = 0;
        try { sr = r.getInt("sr"); } catch(Exception noSr) { sr = 0; }
        String shop = r.getString("shop");
        String rawFeedb = r.getString("feedb");
        String customer = r.getString("uname");
        if (customer == null || customer.trim().isEmpty() || "null".equalsIgnoreCase(customer)) {
            customer = "Verified Customer";
        }
        
        int stars = 5;
        String cleanFeedb = rawFeedb != null ? rawFeedb : "";
        if (cleanFeedb.startsWith("[") && cleanFeedb.contains("★]")) {
            try {
                int starIdx = cleanFeedb.indexOf("★]");
                stars = Integer.parseInt(cleanFeedb.substring(1, starIdx).trim());
                cleanFeedb = cleanFeedb.substring(starIdx + 2).trim();
            } catch(Exception e) {}
        }
%>
            <tr>
              <td>
                <div style="display: flex; align-items: center; gap: 10px;">
                  <div style="width: 34px; height: 34px; border-radius: var(--radius-sm); background: #fef3c7; color: #b45309; display: flex; align-items: center; justify-content: center; font-size: 0.9rem;">
                    <i class="fa-solid fa-store"></i>
                  </div>
                  <strong style="color: var(--text-main);"><%= shop %></strong>
                </div>
              </td>
              <td>
                <div style="display: flex; align-items: center; gap: 8px;">
                  <i class="fa-regular fa-user" style="color: var(--text-muted); font-size: 0.85rem;"></i>
                  <span><%= customer %></span>
                </div>
              </td>
              <td>
                <div style="color: #f59e0b; font-size: 0.85rem; display: flex; gap: 2px;">
                  <% for(int s = 1; s <= 5; s++) { %>
                    <i class="<%= s <= stars ? "fa-solid fa-star" : "fa-regular fa-star" %>" style="<%= s <= stars ? "color: #f59e0b;" : "color: #cbd5e1;" %>"></i>
                  <% } %>
                </div>
              </td>
              <td>
                <div style="color: var(--text-main); line-height: 1.5;">
                  <%= cleanFeedb %>
                </div>
              </td>
              <td>
                <% if (sr > 0) { %>
                  <a href="feedback_delete.jsp?delete=<%= sr %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this review?');" title="Delete Review">
                    <i class="fa-solid fa-trash"></i>
                  </a>
                <% } else { %>
                  <a href="feedback_delete.jsp?shop=<%= java.net.URLEncoder.encode(shop != null ? shop : "", "UTF-8") %>&feedb=<%= java.net.URLEncoder.encode(rawFeedb != null ? rawFeedb : "", "UTF-8") %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this review?');" title="Delete Review">
                    <i class="fa-solid fa-trash"></i>
                  </a>
                <% } %>
              </td>
            </tr>
<%
    }
    if (count == 0) {
%>
            <tr>
              <td colspan="5" class="empty-state">
                <div class="empty-state-icon"><i class="fa-regular fa-comments"></i></div>
                <p>No customer reviews logged on the platform yet.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr>
              <td colspan="5" style="text-align: center; color: var(--danger); padding: 24px;">
                Error loading feedback: <%= ex.getMessage() %>
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