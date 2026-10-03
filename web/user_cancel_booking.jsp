<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Cancelling Booking — Urban Genie</title>
</head>
<body>
<%
String userName = (String) session.getAttribute("name");
if (userName == null) userName = (String) session.getAttribute("uname");
String ureg = (String) session.getAttribute("reg");
if (ureg == null) ureg = (String) session.getAttribute("ureg");

if (userName == null) {
    response.sendRedirect("user.jsp");
    return;
}

String idParam = request.getParameter("id");
if (idParam == null || idParam.trim().isEmpty()) {
    response.sendRedirect("userbookings.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
try {
    con = DBUtil.getConnection();
    int sr = Integer.parseInt(idParam.trim());
    
    // Secure update: ensure the customer owns this booking and only cancel if not already completed
    if (ureg != null && !ureg.trim().isEmpty()) {
        ps = con.prepareStatement("UPDATE booking SET status='Cancelled' WHERE sr=? AND (ureg=? OR uname=?) AND LOWER(status)!='completed'");
        ps.setInt(1, sr);
        ps.setString(2, ureg.trim());
        ps.setString(3, userName);
    } else {
        ps = con.prepareStatement("UPDATE booking SET status='Cancelled' WHERE sr=? AND uname=? AND LOWER(status)!='completed'");
        ps.setInt(1, sr);
        ps.setString(2, userName);
    }
    
    int rows = ps.executeUpdate();
    if (rows > 0) {
%>
    <script>
      alert("Your appointment request has been cancelled.");
      window.location = "userbookings.jsp";
    </script>
<%
    } else {
%>
    <script>
      alert("Unable to cancel booking. It may have already been completed or could not be found.");
      window.location = "userbookings.jsp";
    </script>
<%
    }
} catch(Exception ex) {
%>
    <script>
      alert("Error: <%= ex.getMessage().replace("'", "\\'") %>");
      window.location = "userbookings.jsp";
    </script>
<%
} finally {
    if (ps != null) try { ps.close(); } catch(Exception ignore) {}
    if (con != null) try { con.close(); } catch(Exception ignore) {}
}
%>
</body>
</html>
