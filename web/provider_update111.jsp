<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Updating Business Profile...</title>
</head>
<body>
<%
    Connection c1 = null;
    PreparedStatement st = null;
    try {
        String sessionUser = (String) session.getAttribute("name");
        if (sessionUser == null) {
            response.sendRedirect("provider.jsp");
            return;
        }

        c1 = DBUtil.getConnection();
        
        int reg = Integer.parseInt(request.getParameter("reg"));
        String shop = request.getParameter("shop");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String adr = request.getParameter("adr");
        String no = request.getParameter("no");
        String email = request.getParameter("email");
        String time = request.getParameter("time");
        String about = request.getParameter("about");
        String pwd = request.getParameter("pwd");
        
        // Security: Do NOT allow provider to modify their own status! Status is strictly admin-controlled.
        st = c1.prepareStatement("UPDATE provider SET shop=?, name=?, category=?, adr=?, no=?, email=?, time=?, about=?, pwd=? WHERE reg=?");
        st.setString(1, shop.trim());
        st.setString(2, name.trim());
        st.setString(3, category.trim());
        st.setString(4, adr.trim());
        st.setString(5, no.trim());
        st.setString(6, email.trim());
        st.setString(7, time.trim());
        st.setString(8, about.trim());
        
        String hashedPwd = (pwd != null && pwd.length() == 64 && pwd.matches("^[a-fA-F0-9]{64}$")) ? pwd : PasswordUtil.hash(pwd);
        st.setString(9, hashedPwd);
        st.setInt(10, reg);
        
        int r = st.executeUpdate();
        
        if (r > 0) {
            session.setAttribute("name", name.trim());
            session.setAttribute("shop", shop.trim());
            session.setAttribute("pwd", hashedPwd);
            session.setAttribute("category", category.trim());
            out.println("<script>alert('Shop profile updated successfully!'); location.href='providerprofile.jsp';</script>");
        } else {
            out.println("<script>alert('Unable to update profile.'); location.href='providerprofile.jsp';</script>");
        }
    } catch(Exception ex) {
        out.println("<script>alert('Update error: " + ex.getMessage().replace("'", "\\'") + "'); location.href='providerprofile.jsp';</script>");
    } finally {
        if (st != null) try { st.close(); } catch(Exception ignore) {}
        if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
    }
%>
</body>
</html>