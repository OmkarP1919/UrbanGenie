<%-- 
    Document   : user_delete
    Created on : May 29, 2023, 3:48:15 PM
    Author     : shubh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
          <%
            Connection c1=null;
            PreparedStatement st=null;
            try
            {
            c1=DBUtil.getConnection();
            
            int rn=Integer.parseInt(request.getParameter("delete"));
            
            st=c1.prepareStatement("DELETE FROM user WHERE reg=?");
            st.setInt(1, rn);
            int r=st.executeUpdate();
            st=c1.prepareStatement("DELETE FROM booking WHERE ureg=?");
            st.setInt(1, rn);
            st.executeUpdate();
            
            if(r>0)
            {
                 out.println("<script>alert('User Deleted Successfully'); location.href='user_list.jsp';</script>");
            }
            else
            {
                 out.println("<script>alert('Unable to Delete'); location.href='user_list.jsp';</script>");
            }
            }
            catch(Exception ex)
            {
                out.println("Exception : "+ex);
            }
            finally
            {
                if(st!=null) try { st.close(); } catch(Exception ignore) {}
                if(c1!=null) try { c1.close(); } catch(Exception ignore) {}
            }
        %>
    </body>
</html>
