<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Provider Profile — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body style="background: var(--bg-app); min-height: 100vh;">

  <!-- Minimal Header -->
  <header style="background: var(--bg-surface); border-bottom: 1px solid var(--border-subtle); padding: 14px 24px; position: sticky; top: 0; z-index: 100;">
    <div class="container" style="display: flex; align-items: center; justify-content: space-between;">
      <a href="index11.jsp" style="display: flex; align-items: center; gap: 10px; text-decoration: none;">
        <div style="width: 36px; height: 36px; border-radius: var(--radius-md); background: var(--primary); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 1.1rem;">
          <i class="fa-solid fa-bolt"></i>
        </div>
        <div>
          <span style="font-weight: 700; font-size: 1.15rem; color: var(--text-main); letter-spacing: -0.3px;">Urban Genie</span>
          <span style="font-size: 0.72rem; color: var(--text-muted); display: block; line-height: 1;">Ambajogai Services</span>
        </div>
      </a>
      <div style="display: flex; gap: 10px; align-items: center;">
        <a href="service.jsp" class="btn btn-outline btn-sm">
          <i class="fa-solid fa-arrow-left" style="margin-right: 4px;"></i> Browse All Services
        </a>
      </div>
    </div>
  </header>

<%
String pId = request.getParameter("id");
String pShopParam = request.getParameter("shop");

if ((pId == null || pId.trim().isEmpty()) && (pShopParam == null || pShopParam.trim().isEmpty())) {
    response.sendRedirect("service.jsp");
    return;
}

Connection conn = null;
PreparedStatement st = null;
ResultSet rs = null;

String shop = "", name = "", cat = "", adr = "", mob = "", email = "", workTime = "", about = "", regId = "";
boolean found = false;

// Rating metrics
int reviewCount = 0;
double totalScore = 0.0;
java.util.List<String[]> reviewsList = new java.util.ArrayList<String[]>();

try {
    conn = DBUtil.getConnection();

    if (pId != null && !pId.trim().isEmpty()) {
        st = conn.prepareStatement("SELECT reg, shop, name, category, adr, no, email, time, about FROM provider WHERE reg=?");
        st.setString(1, pId.trim());
    } else {
        st = conn.prepareStatement("SELECT reg, shop, name, category, adr, no, email, time, about FROM provider WHERE shop=?");
        st.setString(1, pShopParam.trim());
    }

    rs = st.executeQuery();
    if (rs.next()) {
        found = true;
        regId = rs.getString("reg");
        shop = rs.getString("shop");
        name = rs.getString("name");
        cat = rs.getString("category");
        adr = rs.getString("adr");
        mob = rs.getString("no");
        email = rs.getString("email");
        workTime = rs.getString("time");
        about = rs.getString("about");
    }
    rs.close();
    st.close();

    if (found) {
        // Fetch feedbacks & compute rating
        st = conn.prepareStatement("SELECT uname, feedb FROM feedback WHERE shop=? ORDER BY sr DESC");
        st.setString(1, shop);
        rs = st.executeQuery();
        while (rs.next()) {
            reviewCount++;
            String uName = rs.getString("uname");
            String fText = rs.getString("feedb");
            int rating = 5; // default
            if (fText != null && fText.contains("★")) {
                try {
                    int starIdx = fText.indexOf("★");
                    String numStr = fText.substring(Math.max(0, starIdx - 1), starIdx).trim();
                    rating = Integer.parseInt(numStr);
                } catch(Exception ignore) {}
            }
            totalScore += rating;
            reviewsList.add(new String[]{ uName, fText, String.valueOf(rating) });
        }
    }
} catch(Exception ex) {
    // ignore
} finally {
    if (rs != null) try { rs.close(); } catch(Exception ignore) {}
    if (st != null) try { st.close(); } catch(Exception ignore) {}
    if (conn != null) try { conn.close(); } catch(Exception ignore) {}
}

if (!found) {
%>
  <div class="container" style="max-width: 600px; margin: 60px auto; text-align: center;">
    <div class="card" style="padding: 40px 24px;">
      <h2 style="font-weight: 700; color: var(--text-main);">Provider Not Found</h2>
      <p style="color: var(--text-secondary); margin: 10px 0 20px;">The requested service professional is currently not available.</p>
      <a href="service.jsp" class="btn btn-primary">Browse All Services</a>
    </div>
  </div>
<%
    return;
}

double avgRating = (reviewCount > 0) ? (totalScore / reviewCount) : 5.0;
String ratingDisplay = String.format("%.1f", avgRating);

// Clean phone for WhatsApp
String cleanMob = (mob != null) ? mob.replaceAll("[^0-9]", "") : "";
if (cleanMob.length() == 10) cleanMob = "91" + cleanMob;
String waUrl = "https://wa.me/" + cleanMob + "?text=" + java.net.URLEncoder.encode("Hello " + shop + ", I saw your profile on Urban Genie Ambajogai and would like to inquire about " + cat + " service.", "UTF-8");
String mapUrl = "https://www.google.com/maps/search/?api=1&query=" + java.net.URLEncoder.encode(shop + " " + adr + " Ambajogai", "UTF-8");
%>

  <div class="container" style="max-width: 1080px; margin: 32px auto; padding: 0 16px;">
    
    <!-- Hero Profile Header -->
    <div class="card" style="padding: 32px; margin-bottom: 24px;">
      <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 20px;">
        <div style="display: flex; gap: 20px; align-items: center;">
          <div style="width: 80px; height: 80px; border-radius: var(--radius-lg); background: linear-gradient(135deg, var(--primary) 0%, #4338ca 100%); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 2.2rem; font-weight: 700; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);">
            <%= (shop != null && !shop.isEmpty()) ? shop.substring(0, 1).toUpperCase() : "P" %>
          </div>
          <div>
            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 6px; flex-wrap: wrap;">
              <h1 style="font-size: 1.65rem; font-weight: 700; color: var(--text-main); margin: 0;"><%= shop %></h1>
              <span class="badge badge-approved" style="font-size: 0.78rem;">
                <i class="fa-solid fa-circle-check"></i> Verified Partner
              </span>
            </div>
            
            <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap; font-size: 0.9rem;">
              <span class="badge badge-primary"><%= cat %></span>
              <span style="color: #f59e0b; font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">
                <i class="fa-solid fa-star"></i> <%= ratingDisplay %> 
                <span style="color: var(--text-muted); font-weight: 400;">(<%= reviewCount %> <%= reviewCount == 1 ? "review" : "reviews" %>)</span>
              </span>
              <span style="color: var(--text-secondary);">
                <i class="fa-solid fa-location-dot" style="color: var(--text-muted); margin-right: 4px;"></i> <%= adr %>
              </span>
            </div>
          </div>
        </div>

        <!-- Action CTAs -->
        <div style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
          <a href="<%= waUrl %>" target="_blank" rel="noopener noreferrer" class="btn" style="background: #25D366; color: #fff; font-weight: 600; display: inline-flex; align-items: center; gap: 6px;">
            <i class="fa-brands fa-whatsapp" style="font-size: 1.15rem;"></i> WhatsApp
          </a>
          <a href="tel:<%= mob %>" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 6px;">
            <i class="fa-solid fa-phone"></i> Call <%= mob %>
          </a>
          <a href="bookservice.jsp?approve=<%= regId %>" class="btn btn-primary" style="font-weight: 600; display: inline-flex; align-items: center; gap: 6px; padding: 10px 20px;">
            <i class="fa-regular fa-calendar-check"></i> Book Appointment
          </a>
        </div>
      </div>
    </div>

    <!-- Details Grid: Left Info, Right Reviews -->
    <div style="display: grid; grid-template-columns: 1fr 1.2fr; gap: 24px; align-items: start;">
      
      <!-- Left Column: Business Info -->
      <div style="display: flex; flex-direction: column; gap: 24px;">
        
        <!-- About Box -->
        <div class="card" style="padding: 24px;">
          <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--text-main); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-circle-info" style="color: var(--primary);"></i> About the Professional
          </h3>
          <p style="color: var(--text-secondary); line-height: 1.6; font-size: 0.92rem; margin: 0 0 16px;">
            <%= (about != null && !about.trim().isEmpty()) ? about : "Certified professional providing prompt domestic services across Ambajogai and neighboring areas with high-grade equipment and verified workmanship." %>
          </p>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; background: var(--bg-subtle); padding: 16px; border-radius: var(--radius-md); border: 1px solid var(--border-subtle);">
            <div>
              <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; letter-spacing: 0.5px;">Contact Person</span>
              <strong style="display: block; font-size: 0.92rem; color: var(--text-main); margin-top: 2px;"><%= name %></strong>
            </div>
            <div>
              <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; letter-spacing: 0.5px;">Operating Hours</span>
              <strong style="display: block; font-size: 0.92rem; color: var(--text-main); margin-top: 2px;"><%= (workTime != null && !workTime.isEmpty()) ? workTime : "9:00 AM - 8:00 PM" %></strong>
            </div>
            <div>
              <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; letter-spacing: 0.5px;">Service Area</span>
              <strong style="display: block; font-size: 0.92rem; color: var(--text-main); margin-top: 2px;">Ambajogai Town</strong>
            </div>
            <div>
              <span style="font-size: 0.75rem; text-transform: uppercase; color: var(--text-muted); font-weight: 600; letter-spacing: 0.5px;">Starting Fee</span>
              <strong style="display: block; font-size: 0.92rem; color: var(--primary); margin-top: 2px;">₹199 (Inspection)</strong>
            </div>
          </div>
        </div>

        <!-- Location Card -->
        <div class="card" style="padding: 24px;">
          <h3 style="font-size: 1.1rem; font-weight: 700; color: var(--text-main); margin-bottom: 12px; display: flex; align-items: center; gap: 8px;">
            <i class="fa-solid fa-map-location-dot" style="color: var(--primary);"></i> Workshop & Address
          </h3>
          <p style="color: var(--text-secondary); font-size: 0.92rem; margin-bottom: 16px;">
            <%= shop %>, <%= adr %>, Ambajogai, Maharashtra.
          </p>
          <a href="<%= mapUrl %>" target="_blank" rel="noopener noreferrer" class="btn btn-outline btn-block" style="display: inline-flex; align-items: center; justify-content: center; gap: 8px;">
            <i class="fa-solid fa-diamond-turn-right" style="color: var(--primary);"></i> Get Directions on Google Maps
          </a>
        </div>

      </div>

      <!-- Right Column: Verified Customer Reviews -->
      <div class="card" style="padding: 28px;">
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-subtle); padding-bottom: 16px; margin-bottom: 20px;">
          <div>
            <h3 style="font-size: 1.15rem; font-weight: 700; color: var(--text-main); margin: 0;">Verified Customer Reviews</h3>
            <span style="font-size: 0.82rem; color: var(--text-muted);">Real feedback from residents in Ambajogai</span>
          </div>
          <a href="feedback.jsp?shop=<%= java.net.URLEncoder.encode(shop, "UTF-8") %>" class="btn btn-outline btn-sm">
            <i class="fa-regular fa-comment-dots" style="margin-right: 4px;"></i> Write Review
          </a>
        </div>

        <% if (reviewsList.isEmpty()) { %>
          <div style="text-align: center; padding: 40px 16px; color: var(--text-secondary);">
            <i class="fa-regular fa-star" style="font-size: 2.2rem; color: var(--border-subtle); margin-bottom: 12px; display: block;"></i>
            <h4 style="font-size: 1rem; font-weight: 600; color: var(--text-main); margin-bottom: 4px;">No reviews yet</h4>
            <p style="font-size: 0.86rem; color: var(--text-muted); margin-bottom: 16px;">Be the first customer to rate and review <%= shop %>!</p>
            <a href="feedback.jsp?shop=<%= java.net.URLEncoder.encode(shop, "UTF-8") %>" class="btn btn-primary btn-sm">
              Leave a Review
            </a>
          </div>
        <% } else { %>
          <div style="display: flex; flex-direction: column; gap: 16px;">
            <% for (String[] rev : reviewsList) { 
                String rUser = rev[0] != null ? rev[0] : "Verified Customer";
                String rText = rev[1] != null ? rev[1] : "";
                int rStars = 5;
                try { rStars = Integer.parseInt(rev[2]); } catch(Exception ignore) {}
                String cleanFeedback = rText.replaceAll("\\[[0-9]★\\]", "").trim();
            %>
              <div style="background: var(--bg-subtle); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 16px 18px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                  <div style="display: flex; align-items: center; gap: 10px;">
                    <div style="width: 32px; height: 32px; border-radius: 50%; background: var(--border-subtle); color: var(--text-main); display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem;">
                      <%= rUser.substring(0, 1).toUpperCase() %>
                    </div>
                    <div>
                      <strong style="font-size: 0.9rem; color: var(--text-main); display: block;"><%= rUser %></strong>
                      <span style="font-size: 0.74rem; color: var(--text-muted);">Verified Resident</span>
                    </div>
                  </div>
                  <div style="color: #f59e0b; font-size: 0.85rem;">
                    <% for (int s = 1; s <= 5; s++) { %>
                      <i class="<%= s <= rStars ? "fa-solid" : "fa-regular" %> fa-star"></i>
                    <% } %>
                  </div>
                </div>
                <p style="margin: 0; font-size: 0.88rem; color: var(--text-secondary); line-height: 1.5;">
                  <%= cleanFeedback %>
                </p>
              </div>
            <% } %>
          </div>
        <% } %>

      </div>

    </div>

  </div>

</body>
</html>
