<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Updating Booking Status — Urban Genie</title>
</head>
<body>
<%
String providerName = (String) session.getAttribute("name");
String shop = (String) session.getAttribute("shop");
String preg = (String) session.getAttribute("preg");
if (preg == null) preg = (String) session.getAttribute("reg");

if (providerName == null) {
    response.sendRedirect("provider.jsp");
    return;
}

String idParam = request.getParameter("id");
String action = request.getParameter("action");

if (idParam == null || action == null || idParam.trim().isEmpty() || action.trim().isEmpty()) {
    response.sendRedirect("provider_users.jsp");
    return;
}

String newStatus = "Pending";
String message = "Booking status updated.";

if ("approve".equalsIgnoreCase(action) || "accept".equalsIgnoreCase(action)) {
    newStatus = "Confirmed";
    message = "Service appointment successfully Approved & Confirmed!";
} else if ("decline".equalsIgnoreCase(action) || "reject".equalsIgnoreCase(action)) {
    newStatus = "Declined";
    message = "Appointment request has been Declined.";
} else if ("complete".equalsIgnoreCase(action)) {
    newStatus = "Completed";
    message = "Great job! Service marked as Completed.";
} else {
    response.sendRedirect("provider_users.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
try {
    con = DBUtil.getConnection();
    int sr = Integer.parseInt(idParam.trim());
    
    // Secure update: Ensure this booking belongs to this authenticated provider
    if (preg != null && !preg.trim().isEmpty()) {
        ps = con.prepareStatement("UPDATE booking SET status=? WHERE sr=? AND (preg=? OR shop=?)");
        ps.setString(1, newStatus);
        ps.setInt(2, sr);
        ps.setString(3, preg.trim());
        ps.setString(4, shop != null ? shop : "");
    } else {
        ps = con.prepareStatement("UPDATE booking SET status=? WHERE sr=?");
        ps.setString(1, newStatus);
        ps.setInt(2, sr);
    }
    
    int rows = ps.executeUpdate();
    if (rows > 0) {
%>
    <script>
      alert("<%= message %>");
      window.location = "provider_users.jsp";
    </script>
<%
    } else {
%>
    <script>
      alert("Unable to update booking status. Request not found or not authorized.");
      window.location = "provider_users.jsp";
    </script>
<%
    }
} catch(Exception ex) {
%>
    <script>
      alert("Error: <%= ex.getMessage().replace("'", "\\'") %>");
      window.location = "provider_users.jsp";
    </script>
<%
} finally {
    if (ps != null) try { ps.close(); } catch(Exception ignore) {}
    if (con != null) try { con.close(); } catch(Exception ignore) {}
}
%>
</body>
</html>
