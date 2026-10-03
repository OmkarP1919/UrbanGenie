<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Available Service Providers — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
String userName = (String) session.getAttribute("name");

DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
LocalDateTime now = LocalDateTime.now();
String dt = dtf.format(now);
session.setAttribute("udate", dt);

String category = request.getParameter("category");
%>
</head>
<body style="background: var(--bg-app);">

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="index.html" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
      </a>
      <div style="display: flex; gap: 10px;">
        <a href="service.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-shapes"></i> Categories</a>
        <% if (userName != null) { %>
          <a href="userprofile111.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-gauge"></i> Dashboard</a>
        <% } else { %>
          <a href="user.jsp" class="btn btn-primary btn-sm"><i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In</a>
          <a href="index.html" class="btn btn-outline btn-sm"><i class="fa-solid fa-house"></i> Home</a>
        <% } %>
      </div>
    </div>
  </header>

  <main class="app-container" style="max-width: 1300px;">
    <div class="action-bar">
      <div class="page-heading">
        <h1><%= (category != null && !category.trim().isEmpty()) ? category + " Specialists" : "All Service Providers" %></h1>
        <p>Verified, background-checked local professionals in Ambajogai</p>
      </div>
      
      <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
        <!-- Live Search Box -->
        <div class="search-box" style="margin-bottom: 0;">
          <i class="fa-solid fa-magnifying-glass"></i>
          <input type="text" id="providerSearchInput" placeholder="Search by name, category, area..." onkeyup="filterTable('providerSearchInput', 'providerTable')">
        </div>
        <!-- Export CSV Button -->
        <button type="button" onclick="exportTableToCSV('providerTable', 'Ambajogai_<%= category != null ? category : "All" %>_Providers.csv')" class="btn btn-outline" style="font-size: 0.85rem; height: 38px; display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-file-csv"></i> Export CSV
        </button>
      </div>
    </div>

    <!-- Ambajogai Locality Chips -->
    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; align-items: center;">
      <span style="font-size: 0.84rem; font-weight: 600; color: var(--text-secondary);"><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> Area:</span>
      <button type="button" class="area-chip active" onclick="filterTableByArea('all', this, 'providerTable')">All Ambajogai</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Mandi Bazar', this, 'providerTable')">Mandi Bazar</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Bus Stand', this, 'providerTable')">Bus Stand</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Shivaji Chowk', this, 'providerTable')">Shivaji Chowk</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Parli Road', this, 'providerTable')">Parli Road</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Ring Road', this, 'providerTable')">Ring Road</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Morewadi', this, 'providerTable')">Morewadi</button>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="providerTable">
          <thead>
            <tr>
              <th>ID</th>
              <th>Business / Shop</th>
              <th>Owner / Contact</th>
              <th>Category</th>
              <th>Address</th>
              <th>Phone</th>
              <th>Working Hours</th>
              <th>Visiting Fee</th>
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
    
    // Only show Approved providers to customers
    if (category != null && !category.trim().isEmpty()) {
        st = c1.prepareStatement("SELECT * FROM provider WHERE category=? AND LOWER(status)='approved'");
        st.setString(1, category.trim());
    } else {
        st = c1.prepareStatement("SELECT * FROM provider WHERE LOWER(status)='approved'");
    }

    r = st.executeQuery();
    while (r.next()) {
        count++;
        int pReg = r.getInt("reg");
        String pShop = r.getString("shop");
        String pName = r.getString("name");
        String pCat = r.getString("category");
        String pAdr = r.getString("adr");
        String pNo = r.getString("no");
        String pTime = r.getString("time");
        String pAbout = r.getString("about");
        int reviewCount = 0;
        double avgRating = 5.0;
        PreparedStatement psRate = null;
        ResultSet rsRate = null;
        try {
            psRate = c1.prepareStatement("SELECT feedb FROM feedback WHERE shop=?");
            psRate.setString(1, pShop);
            rsRate = psRate.executeQuery();
            double totalStars = 0;
            while (rsRate.next()) {
                reviewCount++;
                String fb = rsRate.getString(1);
                int s = 5;
                if (fb != null && fb.startsWith("[") && fb.contains("★]")) {
                    try { s = Integer.parseInt(fb.substring(1, fb.indexOf("★]")).trim()); } catch(Exception e) {}
                }
                totalStars += s;
            }
            if (reviewCount > 0) {
                avgRating = Math.round((totalStars / reviewCount) * 10.0) / 10.0;
            }
        } catch(Exception ignore) {}
        finally {
            if (rsRate != null) try { rsRate.close(); } catch(Exception ignore) {}
            if (psRate != null) try { psRate.close(); } catch(Exception ignore) {}
        }

        String cleanProvMob = pNo != null ? pNo.replaceAll("[^0-9]", "") : "";
        if (cleanProvMob.length() == 10) cleanProvMob = "91" + cleanProvMob;
        String waProvMsg = "Hello " + pShop + ", I found your profile on Urban Genie Ambajogai and would like to inquire about your " + pCat + " service.";
        String waProvUrl = "https://wa.me/" + cleanProvMob + "?text=" + java.net.URLEncoder.encode(waProvMsg, "UTF-8");
%>
            <tr data-area="<%= pAdr %>">
              <td><strong>#<%= pReg %></strong></td>
              <td>
                <a href="provider_detail.jsp?id=<%= pReg %>" style="font-weight: 600; color: var(--text-main); text-decoration: none;" title="View Verified Profile & Reviews">
                  <%= pShop %> <i class="fa-solid fa-arrow-up-right-from-square" style="font-size: 0.72rem; color: var(--primary);"></i>
                </a>
                <% if (reviewCount > 0) { %>
                  <div style="margin-top: 4px; display: inline-flex; align-items: center; gap: 4px; background: #fef3c7; color: #b45309; font-size: 0.75rem; font-weight: 600; padding: 2px 7px; border-radius: 10px;">
                    <i class="fa-solid fa-star" style="color: #f59e0b; font-size: 0.7rem;"></i> <%= avgRating %> (<%= reviewCount %>)
                  </div>
                <% } else { %>
                  <div style="font-size: 0.72rem; color: var(--text-muted); margin-top: 2px;"><i class="fa-solid fa-shield-check" style="color: var(--success);"></i> Verified</div>
                <% } %>
              </td>
              <td><%= pName %></td>
              <td><span class="badge badge-neutral"><%= pCat %></span></td>
              <td><%= pAdr %></td>
              <td>
                <a href="tel:<%= pNo %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= pNo %>
                </a>
              </td>
              <td><span style="font-size: 0.82rem; color: var(--text-secondary);"><%= pTime %></span></td>
              <td>
                <span class="badge" style="background: #f0fdf4; color: #166534; font-size: 0.75rem; font-weight: 600;">
                  <i class="fa-solid fa-tag"></i> ₹199
                </span>
              </td>
              <td>
                <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                  <a href="bookservice.jsp?approve=<%= pReg %>" class="btn btn-primary btn-sm" title="Schedule Service">
                    <i class="fa-solid fa-calendar-check"></i> Book
                  </a>
                  <a href="provider_detail.jsp?id=<%= pReg %>" class="btn btn-outline btn-sm" title="View Full Profile & Reviews">
                    <i class="fa-regular fa-id-card"></i>
                  </a>
                  <a href="tel:<%= pNo %>" class="btn btn-outline btn-sm" title="Call <%= pShop %>">
                    <i class="fa-solid fa-phone"></i>
                  </a>
                  <% if (!cleanProvMob.isEmpty()) { %>
                  <a href="<%= waProvUrl %>" target="_blank" class="btn btn-outline btn-sm" style="color: #16a34a; border-color: #bbf7d0;" title="Chat on WhatsApp">
                    <i class="fa-brands fa-whatsapp"></i>
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
              <td colspan="9" class="empty-state">
                <div class="empty-state-icon"><i class="fa-solid fa-store-slash"></i></div>
                <p>No verified providers currently found for "<%= category != null ? category : "All" %>".</p>
                <div style="margin-top: 14px;">
                  <a href="service.jsp" class="btn btn-outline btn-sm">Browse Other Categories</a>
                </div>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr class="empty-state-row">
              <td colspan="9" style="text-align: center; color: var(--danger); padding: 24px;">
                Error loading service providers: <%= ex.getMessage() %>
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