<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Updating Account...</title>
</head>
<body>
<%
    Connection c1 = null;
    PreparedStatement st = null;
    try {
        String sessionUser = (String) session.getAttribute("name");
        if (sessionUser == null) {
            response.sendRedirect("user.jsp");
            return;
        }

        c1 = DBUtil.getConnection();
        
        int reg = Integer.parseInt(request.getParameter("reg"));
        String name = request.getParameter("name");
        String adr = request.getParameter("adr");
        String no = request.getParameter("no");
        String email = request.getParameter("email");
        String gen = request.getParameter("gen");
        String pwd = request.getParameter("pwd");
        
        // Security: Do NOT overwrite status to NULL! Status is managed only by Admin.
        st = c1.prepareStatement("UPDATE user SET name=?, email=?, no=?, adr=?, gen=?, pwd=? WHERE reg=?");
        st.setString(1, name.trim());
        st.setString(2, email.trim());
        st.setString(3, no.trim());
        st.setString(4, adr.trim());
        st.setString(5, gen != null ? gen : "male");
        
        String hashedPwd = (pwd != null && pwd.length() == 64 && pwd.matches("^[a-fA-F0-9]{64}$")) ? pwd : PasswordUtil.hash(pwd);
        st.setString(6, hashedPwd);
        st.setInt(7, reg);
        
        int r = st.executeUpdate();
        
        if (r > 0) {
            session.setAttribute("name", name.trim());
            session.setAttribute("uname", name.trim());
            session.setAttribute("pwd", hashedPwd);
            session.setAttribute("email", email.trim());
            session.setAttribute("mob", no.trim());
            session.setAttribute("adr", adr.trim());
            out.println("<script>alert('Profile updated successfully!'); location.href='userprofile111.jsp';</script>");
        } else {
            out.println("<script>alert('Unable to update profile.'); location.href='userprofile111.jsp';</script>");
        }
    } catch(Exception ex) {
        out.println("<script>alert('Update error: " + ex.getMessage().replace("'", "\\'") + "'); location.href='userprofile111.jsp';</script>");
    } finally {
        if (st != null) try { st.close(); } catch(Exception ignore) {}
        if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
    }
%>
</body>
</html>
