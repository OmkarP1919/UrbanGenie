<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submitting Review...</title>
</head>
<body>
<%
    Connection c1 = null;
    PreparedStatement st = null;
    try {
        String uname = (String) session.getAttribute("uname");
        if (uname == null) uname = (String) session.getAttribute("name");
        if (uname == null || uname.trim().isEmpty()) {
            uname = "Customer";
        }

        String shop = request.getParameter("shop");
        String feedb = request.getParameter("feedb");
        String rating = request.getParameter("rating");
        if (rating == null || rating.trim().isEmpty()) rating = "5";

        if (shop == null || feedb == null || shop.trim().isEmpty() || feedb.trim().isEmpty()) {
            out.println("<script>alert('Review content cannot be empty.'); location.href='feedback.jsp';</script>");
            return;
        }

        String formattedFeedback = "[" + rating.trim() + "★] " + feedb.trim();

        c1 = DBUtil.getConnection();
        st = c1.prepareStatement("INSERT INTO feedback(shop,feedb,uname) VALUES(?,?,?)");
        st.setString(1, shop.trim());
        st.setString(2, formattedFeedback);
        st.setString(3, uname.trim());
        st.executeUpdate();

        out.println("<script>alert('Thank you! Your " + rating + "-star review has been published.'); location.href='userprofile111.jsp';</script>");
    } catch(Exception ex) {
        out.println("<script>alert('Error submitting feedback: " + ex.getMessage().replace("'", "\\'") + "'); location.href='userprofile111.jsp';</script>");
    } finally {
        if (st != null) try { st.close(); } catch(Exception ignore) {}
        if (c1 != null) try { c1.close(); } catch(Exception ignore) {}
    }
%>
</body>
</html>
