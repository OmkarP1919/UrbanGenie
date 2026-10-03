<%-- 
    Document   : user_approve
    Created on : May 29, 2023, 4:11:43 PM
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
        
             int rn=Integer.parseInt(request.getParameter("approve"));
             
            st=c1.prepareStatement("UPDATE user SET status='Approved' WHERE reg=?");
            st.setInt(1, rn);
             int r=st.executeUpdate();
            
            if(r>0)
            {
                 out.println("<script>alert('Record Approved Successfully'); location.href='user_list.jsp';</script>");
            }
            else
            {
                 out.println("<script>alert('Unable To Approve'); location.href='user_list.jsp';</script>");
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
