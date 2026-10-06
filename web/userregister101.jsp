

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
            
            int id=Integer.parseInt(request.getParameter("reg"));
            String n=request.getParameter("name");
            String mail=request.getParameter("email");
            String num=request.getParameter("no");
            String adr=request.getParameter("adr");
            String gen=request.getParameter("gen");
            String pwd=request.getParameter("pwd");
            
            // Server-side validation
            boolean valid=true;
            String errMsg="";
            if(n==null||n.trim().isEmpty())    { valid=false; errMsg="Name is required."; }
            else if(mail==null||!mail.contains("@")) { valid=false; errMsg="Valid email is required."; }
            else if(num==null||!num.matches("\\d{10}"))  { valid=false; errMsg="Phone must be 10 digits."; }
            else if(pwd==null||pwd.length()<4)  { valid=false; errMsg="Password must be at least 4 characters."; }
            
            String returnTo = request.getParameter("returnTo");
            if (returnTo == null) returnTo = "";

            if(!valid) {
                out.println("<script>alert('" + errMsg + "'); history.back();</script>");
            } else {
                st=c1.prepareStatement("INSERT INTO user(reg,name,email,no,adr,gen,pwd,status) VALUES(?,?,?,?,?,?,?,'approved')");
                st.setInt(1, id);
                st.setString(2, n.trim());
                st.setString(3, mail.trim());
                st.setString(4, num.trim());
                st.setString(5, adr != null ? adr.trim() : "");
                st.setString(6, gen != null ? gen.trim() : "");
                st.setString(7, PasswordUtil.hash(pwd));
                st.executeUpdate();

                // Auto-login into session
                HttpSession se = request.getSession(true);
                se.setAttribute("name", n.trim());
                se.setAttribute("uname", n.trim());
                se.setAttribute("pwd", PasswordUtil.hash(pwd));
                se.setAttribute("role", "user");
                se.setAttribute("reg", String.valueOf(id));
                se.setAttribute("ureg", String.valueOf(id));
                se.setAttribute("email", mail.trim());
                se.setAttribute("uemail", mail.trim());
                se.setAttribute("mob", num.trim());
                se.setAttribute("umob", num.trim());
                se.setAttribute("adr", adr != null ? adr.trim() : "");
                se.setAttribute("uadr", adr != null ? adr.trim() : "");

                if (!returnTo.trim().isEmpty() && !returnTo.contains("\n") && !returnTo.contains("\r")) {
                    response.sendRedirect(returnTo.trim());
                } else {
                    out.println("<script>alert('Welcome to Urban Genie! Account registered successfully.'); location.href='userprofile111.jsp';</script>");
                }
            }
            }
            catch(Exception ex)
            {
                out.println("<script>alert('Registration Error: " + ex.getMessage().replace("'", "\\'") + "'); history.back();</script>");
            }
        %>
    </body>
</html>
