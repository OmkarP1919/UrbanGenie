<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Authenticating User...</title>
</head>
<body>
<%
    Connection c1 = null;
    PreparedStatement st = null;
    ResultSet r = null;
    try {
        c1 = DBUtil.getConnection();
        
        String uid = request.getParameter("name");
        String rawPwd = request.getParameter("pwd");

        if (uid == null || rawPwd == null || uid.trim().isEmpty() || rawPwd.trim().isEmpty()) {
            out.println("<script>alert('Please enter both name and password.'); location.href='user.jsp';</script>");
            return;
        }
        
        String pwd = PasswordUtil.hash(rawPwd.trim());
        
        // 1. Check valid approved user
        st = c1.prepareStatement("SELECT * FROM user WHERE name=? AND pwd=?");
        st.setString(1, uid.trim());
        st.setString(2, pwd);
        r = st.executeQuery();
        
        if (r.next()) {
            String status = r.getString("status");
            // If account was previously pending ('N'), auto-activate it now
            if (status == null || "N".equalsIgnoreCase(status) || status.trim().isEmpty()) {
                PreparedStatement upSt = c1.prepareStatement("UPDATE user SET status='approved' WHERE name=?");
                upSt.setString(1, uid.trim());
                upSt.executeUpdate();
                upSt.close();
            }

            HttpSession se = request.getSession(true);
            int ureg = r.getInt("reg");
            String uemail = r.getString("email");
            String umob = r.getString("no");
            String uadr = r.getString("adr");

            se.setAttribute("name", uid.trim());
            se.setAttribute("uname", uid.trim());
            se.setAttribute("pwd", pwd);
            se.setAttribute("role", "user");
            se.setAttribute("reg", String.valueOf(ureg));
            se.setAttribute("ureg", String.valueOf(ureg));
            se.setAttribute("email", uemail);
            se.setAttribute("uemail", uemail);
            se.setAttribute("mob", umob);
            se.setAttribute("umob", umob);
            se.setAttribute("adr", uadr);
            se.setAttribute("uadr", uadr);

            String returnTo = request.getParameter("returnTo");
            if (returnTo != null && !returnTo.trim().isEmpty() && !returnTo.contains("\n") && !returnTo.contains("\r")) {
                response.sendRedirect(returnTo.trim());
            } else {
                response.sendRedirect("userprofile111.jsp");
            }
        } else {
            out.println("<script>alert('Invalid username or password. Please try again.'); location.href='user.jsp';</script>");
        }
    } catch(Exception ex) {
        out.println("<script>alert('Login Error: " + ex.getMessage().replace("'", "\\'") + "'); location.href='user.jsp';</script>");
    } finally {
        if (r != null) try { r.close(); } catch(Exception ignore) {}
        if (st != null) try { st.close(); } catch(Exception ignore) {}
        if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
    }
%>
</body>
</html>
