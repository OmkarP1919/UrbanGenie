<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Schedule Service — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body style="background: var(--bg-app); display: flex; align-items: center; justify-content: center; min-height: 100vh; padding: 24px 16px;">

<%
String name = (String) session.getAttribute("name");
String preg = request.getParameter("approve");
if (name == null) {
    String currentUrl = "bookservice.jsp?approve=" + (preg != null ? preg.trim() : "");
    response.sendRedirect("user.jsp?returnTo=" + java.net.URLEncoder.encode(currentUrl, "UTF-8"));
    return;
}

if (preg == null || preg.trim().isEmpty()) {
    response.sendRedirect("service.jsp");
    return;
}

String reg = (String) session.getAttribute("reg");
if (reg == null) reg = (String) session.getAttribute("ureg");

String email = (String) session.getAttribute("email");
if (email == null) email = (String) session.getAttribute("uemail");

String mob = (String) session.getAttribute("mob");
if (mob == null) mob = (String) session.getAttribute("umob");
if (mob == null) mob = "";

String adr = (String) session.getAttribute("adr");
if (adr == null) adr = (String) session.getAttribute("uadr");
if (adr == null) adr = "";

Connection c1 = null;
PreparedStatement st = null;
ResultSet r = null;

String shop = "", cat = "", pEmail = "", pMob = "", pAdr = "", pTime = "", pAbout = "";
boolean providerFound = false;

try {
    c1 = DBUtil.getConnection();
    st = c1.prepareStatement("SELECT shop, category, email, no, adr, time, about FROM provider WHERE reg=?");
    st.setString(1, preg.trim());
    r = st.executeQuery();
    if (r.next()) {
        providerFound = true;
        shop = r.getString("shop");
        cat = r.getString("category");
        pEmail = r.getString("email");
        pMob = r.getString("no");
        pAdr = r.getString("adr");
        pTime = r.getString("time");
        pAbout = r.getString("about");
    }
} catch(Exception ex) {
    // handled below
} finally {
    if (r != null) try { r.close(); } catch(Exception ignore) {}
    if (st != null) try { st.close(); } catch(Exception ignore) {}
}

if (!providerFound) {
%>
  <div class="card" style="max-width: 480px; width: 100%; text-align: center; padding: 36px 24px;">
    <div style="width: 56px; height: 56px; border-radius: 50%; background: var(--danger-subtle); color: var(--danger); display: inline-flex; align-items: center; justify-content: center; font-size: 1.6rem; margin-bottom: 14px;">
      <i class="fa-solid fa-triangle-exclamation"></i>
    </div>
    <h2 style="font-size: 1.3rem; font-weight: 700; color: var(--text-main);">Provider Not Found</h2>
    <p style="color: var(--text-secondary); font-size: 0.9rem; margin: 8px 0 20px;">The requested service provider could not be located or is currently inactive.</p>
    <a href="service.jsp" class="btn btn-primary">Browse Services</a>
  </div>
<%
    if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
    return;
}

String isConfirm = request.getParameter("confirmBooking");
boolean bookingSuccess = false;
String errorMessage = "";
int bookingSr = 0;
String waUrl = "";
String scheduledDate = "";
String scheduledSlot = "";

if (isConfirm != null && "1".equals(isConfirm)) {
    scheduledDate = request.getParameter("serviceDate");
    scheduledSlot = request.getParameter("serviceSlot");
    String serviceAdr = request.getParameter("serviceAddress");
    String serviceMob = request.getParameter("serviceMobile");
    String serviceNotes = request.getParameter("serviceNotes");

    if (scheduledDate == null || scheduledDate.trim().isEmpty()) {
        scheduledDate = LocalDate.now().plusDays(1).toString();
    }
    if (scheduledSlot == null || scheduledSlot.trim().isEmpty()) {
        scheduledSlot = "Morning (9:00 AM - 12:00 PM)";
    }
    if (serviceAdr == null || serviceAdr.trim().isEmpty()) serviceAdr = adr;
    if (serviceMob == null || serviceMob.trim().isEmpty()) serviceMob = mob;
    if (serviceNotes == null) serviceNotes = "";

    String fullBookingSchedule = scheduledDate + " [" + scheduledSlot + "]";

    try {
        // Attempt with slot and notes columns
        try {
            st = c1.prepareStatement("INSERT INTO booking(ureg,uname,uemail,umob,uadr,udate,preg,shop,category,pemail,pmob,padr,status,slot,notes) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,'Pending',?,?)", Statement.RETURN_GENERATED_KEYS);
            st.setString(1, reg);
            st.setString(2, name);
            st.setString(3, email);
            st.setString(4, serviceMob);
            st.setString(5, serviceAdr);
            st.setString(6, fullBookingSchedule);
            st.setString(7, preg.trim());
            st.setString(8, shop);
            st.setString(9, cat);
            st.setString(10, pEmail);
            st.setString(11, pMob);
            st.setString(12, pAdr);
            st.setString(13, scheduledSlot);
            st.setString(14, serviceNotes);
            st.executeUpdate();
            ResultSet gk = st.getGeneratedKeys();
            if (gk != null && gk.next()) bookingSr = gk.getInt(1);
        } catch(Exception colEx) {
            if (st != null) try { st.close(); } catch(Exception ignore) {}
            // Fallback for older tables without slot/notes columns
            try {
                st = c1.prepareStatement("INSERT INTO booking(ureg,uname,uemail,umob,uadr,udate,preg,shop,category,pemail,pmob,padr,status) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,'Pending')", Statement.RETURN_GENERATED_KEYS);
                st.setString(1, reg);
                st.setString(2, name);
                st.setString(3, email);
                st.setString(4, serviceMob);
                st.setString(5, serviceAdr);
                st.setString(6, fullBookingSchedule);
                st.setString(7, preg.trim());
                st.setString(8, shop);
                st.setString(9, cat);
                st.setString(10, pEmail);
                st.setString(11, pMob);
                st.setString(12, pAdr);
                st.executeUpdate();
                ResultSet gk = st.getGeneratedKeys();
                if (gk != null && gk.next()) bookingSr = gk.getInt(1);
            } catch(Exception colEx2) {
                if (st != null) try { st.close(); } catch(Exception ignore) {}
                st = c1.prepareStatement("INSERT INTO booking(ureg,uname,uemail,umob,uadr,udate,preg,shop,category,pemail,pmob,padr) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS);
                st.setString(1, reg);
                st.setString(2, name);
                st.setString(3, email);
                st.setString(4, serviceMob);
                st.setString(5, serviceAdr);
                st.setString(6, fullBookingSchedule);
                st.setString(7, preg.trim());
                st.setString(8, shop);
                st.setString(9, cat);
                st.setString(10, pEmail);
                st.setString(11, pMob);
                st.setString(12, pAdr);
                st.executeUpdate();
                ResultSet gk = st.getGeneratedKeys();
                if (gk != null && gk.next()) bookingSr = gk.getInt(1);
            }
        }
        bookingSuccess = true;

        String cleanPhone = (pMob != null) ? pMob.replaceAll("[^0-9]", "") : "";
        if (cleanPhone.length() == 10) cleanPhone = "91" + cleanPhone;
        String bRefStr = (bookingSr > 0) ? ("#UG-BK" + bookingSr) : ("#" + System.currentTimeMillis() % 100000);
        String waMsg = java.net.URLEncoder.encode("Hello " + shop + ", I booked your " + cat + " service on Urban Genie (" + bRefStr + ") for " + fullBookingSchedule + ". My name is " + name + " (" + serviceMob + "). Note: " + (serviceNotes.isEmpty() ? "Standard inspection" : serviceNotes), "UTF-8");
        waUrl = "https://wa.me/" + cleanPhone + "?text=" + waMsg;

    } catch(Exception ex) {
        errorMessage = ex.getMessage();
    } finally {
        if (st != null) try { st.close(); } catch(Exception ignore) {}
        if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
    }
} else {
    if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
}

LocalDate today = LocalDate.now();
LocalDate tomorrow = today.plusDays(1);
%>

<% if (isConfirm != null && "1".equals(isConfirm)) { %>
  <!-- Confirmation Card -->
  <div class="card" style="max-width: 540px; width: 100%; padding: 36px 32px;">
  <% if (bookingSuccess) { 
      String bookingRef = (bookingSr > 0) ? ("UG-BK" + bookingSr) : ("UG-" + (System.currentTimeMillis() % 100000));
  %>
    <div style="text-align: center; margin-bottom: 24px;">
      <div style="width: 60px; height: 60px; border-radius: 50%; background: var(--success-subtle); color: var(--success); display: inline-flex; align-items: center; justify-content: center; font-size: 1.8rem; margin-bottom: 14px;">
        <i class="fa-solid fa-circle-check"></i>
      </div>
      <h2 style="font-size: 1.5rem; font-weight: 700; color: var(--text-main);">Appointment Scheduled!</h2>
      <p style="color: var(--text-secondary); font-size: 0.9rem; margin-top: 4px;">Your service request has been sent to <%= shop %>.</p>
      <div style="margin-top: 10px;">
        <span class="badge badge-primary" style="font-size: 0.85rem; padding: 4px 12px; letter-spacing: 0.5px;">Order Ref: #<%= bookingRef %></span>
      </div>
    </div>

    <div style="background: var(--bg-subtle); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 18px 20px; margin-bottom: 24px;">
      <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border-subtle); font-size: 0.88rem;">
        <span style="color: var(--text-muted); font-weight: 500;">Service Provider:</span>
        <strong style="color: var(--text-main);"><%= shop %></strong>
      </div>
      <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border-subtle); font-size: 0.88rem;">
        <span style="color: var(--text-muted); font-weight: 500;">Category:</span>
        <span class="badge badge-neutral"><%= cat %></span>
      </div>
      <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border-subtle); font-size: 0.88rem;">
        <span style="color: var(--text-muted); font-weight: 500;">Appointment Date:</span>
        <strong style="color: var(--primary);"><%= scheduledDate %></strong>
      </div>
      <div style="display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid var(--border-subtle); font-size: 0.88rem;">
        <span style="color: var(--text-muted); font-weight: 500;">Preferred Slot:</span>
        <span style="color: var(--text-main); font-weight: 600;"><%= scheduledSlot %></span>
      </div>
      <div style="display: flex; justify-content: space-between; padding: 8px 0; font-size: 0.88rem;">
        <span style="color: var(--text-muted); font-weight: 500;">Provider Phone:</span>
        <span style="color: var(--text-main);"><%= pMob %></span>
      </div>
    </div>

    <div style="display: flex; flex-direction: column; gap: 10px;">
      <a href="<%= waUrl %>" target="_blank" rel="noopener noreferrer" class="btn" style="background: #25D366; color: #fff; display: flex; align-items: center; justify-content: center; gap: 8px; font-weight: 600;">
        <i class="fa-brands fa-whatsapp" style="font-size: 1.15rem;"></i> Chat with <%= shop %> on WhatsApp
      </a>
      
      <div style="display: flex; gap: 10px;">
        <a href="tel:<%= pMob %>" class="btn btn-outline" style="flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
          <i class="fa-solid fa-phone"></i> Call Phone
        </a>
        <button type="button" onclick="window.print();" class="btn btn-outline" style="flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
          <i class="fa-solid fa-print"></i> Print Receipt
        </button>
      </div>

      <div style="display: flex; gap: 10px; margin-top: 4px;">
        <a href="userbookings.jsp" class="btn btn-primary" style="flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
          <i class="fa-solid fa-calendar-check"></i> My Bookings
        </a>
        <a href="userprofile111.jsp" class="btn btn-secondary" style="flex: 1; display: inline-flex; align-items: center; justify-content: center; gap: 6px;">
          <i class="fa-solid fa-gauge"></i> Dashboard
        </a>
      </div>
    </div>
  <% } else { %>
    <div style="text-align: center; padding: 20px 0;">
      <div style="width: 56px; height: 56px; border-radius: 50%; background: var(--danger-subtle); color: var(--danger); display: inline-flex; align-items: center; justify-content: center; font-size: 1.6rem; margin-bottom: 14px;">
        <i class="fa-solid fa-triangle-exclamation"></i>
      </div>
      <h2 style="font-size: 1.4rem; font-weight: 700; color: var(--text-main);">Booking Failed</h2>
      <p style="color: var(--danger); font-size: 0.9rem; margin: 10px 0 24px;"><%= errorMessage %></p>
      <a href="service.jsp" class="btn btn-primary">Try Again</a>
    </div>
  <% } %>
  </div>

<% } else { %>
  <!-- Scheduling Form Modal Card -->
  <div class="card" style="max-width: 560px; width: 100%; padding: 32px 28px;">
    
    <!-- Provider Header Brief -->
    <div style="display: flex; align-items: flex-start; justify-content: space-between; border-bottom: 1px solid var(--border-subtle); padding-bottom: 16px; margin-bottom: 20px;">
      <div>
        <span class="badge badge-primary" style="margin-bottom: 6px;"><%= cat %></span>
        <h2 style="font-size: 1.35rem; font-weight: 700; color: var(--text-main); margin: 0;"><%= shop %></h2>
        <div style="font-size: 0.84rem; color: var(--text-muted); margin-top: 4px;">
          <i class="fa-solid fa-location-dot" style="margin-right: 4px;"></i> <%= pAdr %>
        </div>
      </div>
      <div style="text-align: right;">
        <span class="badge badge-success" style="font-size: 0.78rem;">Available</span>
        <div style="font-size: 0.8rem; color: var(--text-muted); margin-top: 4px;">
          <i class="fa-regular fa-clock"></i> <%= pTime != null && !pTime.isEmpty() ? pTime : "Standard Hours" %>
        </div>
      </div>
    </div>

    <form action="bookservice.jsp" method="POST">
      <input type="hidden" name="approve" value="<%= preg.trim() %>">
      <input type="hidden" name="confirmBooking" value="1">

      <div style="margin-bottom: 18px;">
        <label class="form-label" style="display: flex; align-items: center; gap: 6px; font-weight: 600;">
          <i class="fa-regular fa-calendar-days" style="color: var(--primary);"></i> Preferred Service Date:
        </label>
        <input type="date" name="serviceDate" class="form-control" required
               min="<%= today.toString() %>" value="<%= tomorrow.toString() %>">
      </div>

      <div style="margin-bottom: 18px;">
        <label class="form-label" style="display: flex; align-items: center; gap: 6px; font-weight: 600;">
          <i class="fa-regular fa-clock" style="color: var(--primary);"></i> Preferred Time Slot:
        </label>
        <div style="display: grid; grid-template-columns: 1fr; gap: 8px;">
          <label style="display: flex; align-items: center; gap: 10px; background: var(--bg-subtle); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; cursor: pointer;">
            <input type="radio" name="serviceSlot" value="Morning (9:00 AM - 12:00 PM)" checked>
            <div>
              <strong style="display: block; font-size: 0.88rem; color: var(--text-main);">🌅 Morning Slot</strong>
              <span style="font-size: 0.78rem; color: var(--text-muted);">9:00 AM - 12:00 PM</span>
            </div>
          </label>
          <label style="display: flex; align-items: center; gap: 10px; background: var(--bg-subtle); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; cursor: pointer;">
            <input type="radio" name="serviceSlot" value="Afternoon (12:00 PM - 4:00 PM)">
            <div>
              <strong style="display: block; font-size: 0.88rem; color: var(--text-main);">☀️ Afternoon Slot</strong>
              <span style="font-size: 0.78rem; color: var(--text-muted);">12:00 PM - 4:00 PM</span>
            </div>
          </label>
          <label style="display: flex; align-items: center; gap: 10px; background: var(--bg-subtle); border: 1px solid var(--border-subtle); border-radius: var(--radius-md); padding: 10px 14px; cursor: pointer;">
            <input type="radio" name="serviceSlot" value="Evening (4:00 PM - 8:00 PM)">
            <div>
              <strong style="display: block; font-size: 0.88rem; color: var(--text-main);">🌆 Evening Slot</strong>
              <span style="font-size: 0.78rem; color: var(--text-muted);">4:00 PM - 8:00 PM</span>
            </div>
          </label>
        </div>
      </div>

      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 18px;">
        <div>
          <label class="form-label" style="font-weight: 600;">Contact Mobile:</label>
          <input type="text" name="serviceMobile" class="form-control" value="<%= mob %>" required placeholder="10-digit number">
        </div>
        <div>
          <label class="form-label" style="font-weight: 600;">Service Address:</label>
          <input type="text" name="serviceAddress" class="form-control" value="<%= adr %>" required placeholder="House / Area in Ambajogai">
        </div>
      </div>

      <div style="margin-bottom: 22px;">
        <label class="form-label" style="font-weight: 600;">Describe Your Problem / Requirements:</label>
        <textarea name="serviceNotes" class="form-control" rows="2" placeholder="e.g., Tap leaking under kitchen sink, need repair or replacement."></textarea>
      </div>

      <div style="display: flex; gap: 10px;">
        <a href="service.jsp" class="btn btn-outline" style="flex: 1;">Cancel</a>
        <button type="submit" class="btn btn-primary" style="flex: 2; font-weight: 600;">
          <i class="fa-solid fa-calendar-check" style="margin-right: 6px;"></i> Confirm & Schedule
        </button>
      </div>
    </form>
  </div>
<% } %>

</body>
</html>
