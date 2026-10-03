<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Authenticating Admin...</title>
</head>
<body>
<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        con = DBUtil.getConnection();
        String uid = request.getParameter("name");
        String rawPwd = request.getParameter("pwd");
        
        if (uid == null || rawPwd == null || uid.trim().isEmpty() || rawPwd.trim().isEmpty()) {
            out.println("<script>alert('Please provide both username and password.'); location.href='admin.jsp';</script>");
            return;
        }

        String pwd = PasswordUtil.hash(rawPwd.trim());
        
        ps = con.prepareStatement("SELECT * FROM admin WHERE name=? AND pwd=?");
        ps.setString(1, uid.trim());
        ps.setString(2, pwd);
        rs = ps.executeQuery();
        
        if (rs.next()) {
            HttpSession se = request.getSession(true);
            se.setAttribute("name", uid.trim());
            se.setAttribute("pwd", pwd);
            se.setAttribute("role", "admin");
            response.sendRedirect("adminprofile.jsp");
        } else {
            out.println("<script>alert('Invalid Admin Credentials. Please try again.'); location.href='admin.jsp';</script>");
        }
    } catch(Exception ex) {
        out.println("<script>alert('Authentication error: " + ex.getMessage().replace("'", "\\'") + "'); location.href='admin.jsp';</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignore) {}
        if (ps != null) try { ps.close(); } catch(Exception ignore) {}
        if (con != null) try { con.close(); } catch(Exception ignore) {}
    }
%>
</body>
</html>
