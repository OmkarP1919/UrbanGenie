<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Public Service Directory — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body style="background: var(--bg-app);">

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="index.html" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
        <span class="brand-badge">Ambajogai</span>
      </a>
      <div style="display: flex; gap: 10px;">
        <% String sName = (String) session.getAttribute("name"); if (sName != null) { %>
          <a href="userprofile111.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-gauge"></i> Dashboard</a>
        <% } else { %>
          <a href="user.jsp" class="btn btn-primary btn-sm"><i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In</a>
        <% } %>
        <a href="index.html" class="btn btn-outline btn-sm"><i class="fa-solid fa-house"></i> Home</a>
      </div>
    </div>
  </header>

  <main class="app-container" style="max-width: 1300px;">
    <div class="action-bar">
      <div class="page-heading">
        <h1>Ambajogai Domestic Services Catalog</h1>
        <p>Public listing of verified domestic technicians, shops, and trade professionals</p>
      </div>
      <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
        <div class="search-box" style="margin: 0; min-width: 260px;">
          <i class="fa-solid fa-magnifying-glass search-icon"></i>
          <input type="text" id="catalogSearch" class="search-input" placeholder="Search service, trade, shop, area..." onkeyup="filterTable('catalogSearch', 'catalogTable')">
        </div>
        <button type="button" onclick="exportTableToCSV('catalogTable', 'Ambajogai_Services_Catalog.csv')" class="btn btn-outline" style="font-size: 0.85rem; height: 38px; display: inline-flex; align-items: center; gap: 6px;">
          <i class="fa-solid fa-file-csv"></i> Export CSV
        </button>
      </div>
    </div>

    <!-- Locality Chips -->
    <div style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; align-items: center;">
      <span style="font-size: 0.84rem; font-weight: 600; color: var(--text-secondary);"><i class="fa-solid fa-location-dot" style="color: var(--primary);"></i> Filter Area:</span>
      <button type="button" class="area-chip active" onclick="filterTableByArea('all', this, 'catalogTable')">All Ambajogai</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Mandi Bazar', this, 'catalogTable')">Mandi Bazar</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Bus Stand', this, 'catalogTable')">Bus Stand</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Shivaji Chowk', this, 'catalogTable')">Shivaji Chowk</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Parli Road', this, 'catalogTable')">Parli Road</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Ring Road', this, 'catalogTable')">Ring Road</button>
      <button type="button" class="area-chip" onclick="filterTableByArea('Morewadi', this, 'catalogTable')">Morewadi</button>
    </div>

    <div class="table-wrapper">
      <div class="table-responsive">
        <table class="app-table" id="catalogTable">
          <thead>
            <tr>
              <th>Business / Shop</th>
              <th>Owner Name</th>
              <th>Trade Category</th>
              <th>Ambajogai Address</th>
              <th>Contact Phone</th>
              <th>Working Hours</th>
              <th>Visiting Fee</th>
              <th>Action</th>
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
    r = st.executeQuery("SELECT * FROM provider WHERE LOWER(status)='approved' ORDER BY category ASC, shop ASC");

    while (r.next()) {
        count++;
        int pReg = r.getInt("reg");
        String shop = r.getString("shop");
        String name = r.getString("name");
        String cat = r.getString("category");
        String adr = r.getString("adr");
        String no = r.getString("no");
        String time = r.getString("time");
        String about = r.getString("about");
        int reviewCount = 0;
        double avgRating = 5.0;
        PreparedStatement psRate = null;
        ResultSet rsRate = null;
        try {
            psRate = c1.prepareStatement("SELECT feedb FROM feedback WHERE shop=?");
            psRate.setString(1, shop);
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

        String cleanNo = no != null ? no.replaceAll("[^0-9]", "") : "";
        if (cleanNo.length() == 10) cleanNo = "91" + cleanNo;
        String waMsg = "Hello " + shop + ", I found your listing on Urban Genie Ambajogai and would like to inquire about your " + cat + " service.";
        String waUrl = "https://wa.me/" + cleanNo + "?text=" + java.net.URLEncoder.encode(waMsg, "UTF-8");
%>
            <tr data-area="<%= adr %>">
              <td>
                <a href="provider_detail.jsp?id=<%= pReg %>" style="font-weight: 600; color: var(--text-main); text-decoration: none;" title="View Verified Profile & Reviews">
                  <%= shop %> <i class="fa-solid fa-arrow-up-right-from-square" style="font-size: 0.72rem; color: var(--primary);"></i>
                </a>
                <% if (reviewCount > 0) { %>
                  <div style="margin-top: 4px; display: inline-flex; align-items: center; gap: 4px; background: #fef3c7; color: #b45309; font-size: 0.75rem; font-weight: 600; padding: 2px 7px; border-radius: 10px;">
                    <i class="fa-solid fa-star" style="color: #f59e0b; font-size: 0.7rem;"></i> <%= avgRating %> (<%= reviewCount %>)
                  </div>
                <% } else { %>
                  <div style="font-size: 0.72rem; color: var(--text-muted); margin-top: 2px;"><i class="fa-solid fa-shield-check" style="color: var(--success);"></i> Verified</div>
                <% } %>
              </td>
              <td><%= name %></td>
              <td><span class="badge badge-neutral"><%= cat %></span></td>
              <td><%= adr %></td>
              <td>
                <a href="tel:<%= no %>" style="color: var(--primary); font-weight: 500;">
                  <i class="fa-solid fa-phone" style="font-size: 0.8rem; margin-right: 4px;"></i><%= no %>
                </a>
              </td>
              <td><span style="font-size: 0.82rem; color: var(--text-muted);"><%= time %></span></td>
              <td>
                <span class="badge" style="background: #f0fdf4; color: #166534; font-size: 0.75rem; font-weight: 600;">
                  <i class="fa-solid fa-tag"></i> ₹199
                </span>
              </td>
              <td>
                <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                  <a href="bookservice.jsp?approve=<%= pReg %>" class="btn btn-primary btn-sm" title="Schedule Service">
                    <i class="fa-solid fa-calendar-plus"></i> Book
                  </a>
                  <a href="provider_detail.jsp?id=<%= pReg %>" class="btn btn-outline btn-sm" title="View Profile & Reviews">
                    <i class="fa-regular fa-id-card"></i>
                  </a>
                  <a href="tel:<%= no %>" class="btn btn-outline btn-sm" style="color: var(--success); border-color: #bbf7d0;" title="Call Provider Directly">
                    <i class="fa-solid fa-phone"></i>
                  </a>
                  <% if (!cleanNo.isEmpty()) { %>
                  <a href="<%= waUrl %>" target="_blank" class="btn btn-outline btn-sm" style="color: #16a34a; border-color: #bbf7d0;" title="Chat on WhatsApp">
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
            <tr>
              <td colspan="8" class="empty-state">
                <div class="empty-state-icon"><i class="fa-solid fa-store-slash"></i></div>
                <p>No verified providers currently listed.</p>
              </td>
            </tr>
<%
    }
} catch(Exception ex) {
%>
            <tr>
              <td colspan="8" style="text-align: center; color: var(--danger); padding: 24px;">
                Error loading service catalog: <%= ex.getMessage() %>
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