<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Delete Review — Urban Genie</title>
</head>
<body>
<%
if (session.getAttribute("name") == null || session.getAttribute("pwd") == null) {
    response.sendRedirect("admin.jsp");
    return;
}

String delParam = request.getParameter("delete");
String shopParam = request.getParameter("shop");
String feedbParam = request.getParameter("feedb");

if ((delParam == null || delParam.trim().isEmpty()) && (shopParam == null || feedbParam == null)) {
    response.sendRedirect("showfeedback.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
try {
    con = DBUtil.getConnection();
    if (delParam != null && !delParam.trim().isEmpty()) {
        try {
            int sr = Integer.parseInt(delParam.trim());
            ps = con.prepareStatement("DELETE FROM feedback WHERE sr=?");
            ps.setInt(1, sr);
        } catch(Exception numEx) {
            // fallback
            ps = con.prepareStatement("DELETE FROM feedback WHERE shop=? AND feedb=?");
            ps.setString(1, shopParam != null ? shopParam.trim() : "");
            ps.setString(2, feedbParam != null ? feedbParam.trim() : "");
        }
    } else {
        ps = con.prepareStatement("DELETE FROM feedback WHERE shop=? AND feedb=? LIMIT 1");
        ps.setString(1, shopParam.trim());
        ps.setString(2, feedbParam.trim());
    }
    int res = ps.executeUpdate();
    if (res > 0) {
%>
    <script>
      alert("Review deleted successfully.");
      window.location = "showfeedback.jsp";
    </script>
<%
    } else {
%>
    <script>
      alert("Review could not be found or was already removed.");
      window.location = "showfeedback.jsp";
    </script>
<%
    }
} catch(Exception e) {
%>
    <script>
      alert("Error deleting review: <%= e.getMessage().replace("'", "\\'") %>");
      window.location = "showfeedback.jsp";
    </script>
<%
} finally {
    if (ps != null) try { ps.close(); } catch(Exception ignore) {}
    if (con != null) try { con.close(); } catch(Exception ignore) {}
}
%>
</body>
</html>
