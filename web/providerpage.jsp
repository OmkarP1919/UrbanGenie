<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Authenticating Provider...</title>
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
            out.println("<script>alert('Please enter both name and password.'); location.href='provider.jsp';</script>");
            return;
        }
        
        String pwd = PasswordUtil.hash(rawPwd.trim());
        
        st = c1.prepareStatement("SELECT * FROM provider WHERE name=? AND pwd=?");
        st.setString(1, uid.trim());
        st.setString(2, pwd);
        r = st.executeQuery();
        
        if (r.next()) {
            String status = r.getString("status");
            if (status == null || "N".equalsIgnoreCase(status) || status.trim().isEmpty()) {
                PreparedStatement upSt = c1.prepareStatement("UPDATE provider SET status='approved' WHERE name=?");
                upSt.setString(1, uid.trim());
                upSt.executeUpdate();
                upSt.close();
            }

            HttpSession se = request.getSession(true);
            int reg = r.getInt("reg");
            String shop = r.getString("shop");
            String category = r.getString("category");
            String email = r.getString("email");
            String no = r.getString("no");
            String adr = r.getString("adr");

            se.setAttribute("name", uid.trim());
            se.setAttribute("pwd", pwd);
            se.setAttribute("role", "provider");
            se.setAttribute("reg", String.valueOf(reg));
            se.setAttribute("preg", String.valueOf(reg));
            se.setAttribute("shop", shop);
            se.setAttribute("category", category);
            se.setAttribute("email", email);
            se.setAttribute("mob", no);
            se.setAttribute("adr", adr);

            response.sendRedirect("providerprofile.jsp");
        } else {
            out.println("<script>alert('Invalid Provider Credentials. Please try again.'); location.href='provider.jsp';</script>");
        }
    } catch(Exception ex) {
        out.println("<script>alert('Login Error: " + ex.getMessage().replace("'", "\\'") + "'); location.href='provider.jsp';</script>");
    } finally {
        if (r != null) try { r.close(); } catch(Exception ignore) {}
        if (st != null) try { st.close(); } catch(Exception ignore) {}
        if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
    }
%>
</body>
</html>
