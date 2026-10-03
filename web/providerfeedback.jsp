<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Customer Feedback — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
String providerName = (String) session.getAttribute("name");
if (providerName == null) {
    response.sendRedirect("provider.jsp");
    return;
}

String shop = request.getParameter("shop");
if (shop == null || shop.trim().isEmpty()) {
    shop = (String) session.getAttribute("shop");
}
%>
</head>
<body style="background: var(--bg-app);">

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
        <h1>Client Reviews & Ratings</h1>
        <p>Customer testimonials submitted for <strong><%= shop != null ? shop : "Your Business" %></strong></p>
      </div>
      <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
        <div class="search-box" style="margin: 0; min-width: 240px;">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="reviewSearch" class="search-input" placeholder="Search reviews..." onkeyup="filterTable('reviewSearch', 'feedbackTable')">
        </div>
        <a href="providerprofile.jsp" class="btn btn-outline">
          <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
      </div>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="feedbackTable">
          <thead>
            <tr>
              <th style="width: 240px;">Customer Name</th>
              <th style="width: 140px;">Rating</th>
              <th>Review / Feedback</th>
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
    if (shop != null && !shop.trim().isEmpty()) {
        st = c1.prepareStatement("SELECT * FROM feedback WHERE shop=? ORDER BY sr DESC");
        st.setString(1, shop.trim());
    } else {
        st = c1.prepareStatement("SELECT * FROM feedback WHERE shop='' ORDER BY sr DESC");
    }

    r = st.executeQuery();
    while (r.next()) {
        count++;
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
                  <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--bg-subtle); display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 0.85rem; font-weight: 600;">
                    <%= customer.substring(0, 1).toUpperCase() %>
                  </div>
                  <div>
                    <strong style="color: var(--text-main); font-size: 0.9rem;"><%= customer %></strong>
                    <div style="font-size: 0.74rem; color: var(--text-muted);"><i class="fa-solid fa-circle-check" style="color: var(--success); font-size: 0.7rem;"></i> Verified Customer</div>
                  </div>
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
                <div style="color: var(--text-main); font-size: 0.9rem; line-height: 1.5;">
                  <%= cleanFeedb %>
                </div>
              </td>
            </tr>
<%
    }
    if (count == 0) {
%>
            <tr>
              <td colspan="3" class="empty-state">
                <div class="empty-state-icon"><i class="fa-regular fa-comment-dots"></i></div>
                <p>No customer reviews received yet.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr>
              <td colspan="3" style="text-align: center; color: var(--danger); padding: 24px;">
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