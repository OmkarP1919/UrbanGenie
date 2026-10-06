

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
            String shop=request.getParameter("shop");
            String n=request.getParameter("name");
            String category=request.getParameter("category");
            String adr=request.getParameter("adr");
            String num=request.getParameter("no");
            String mail=request.getParameter("email");
            String time=request.getParameter("time");
            String about=request.getParameter("about");
            String pwd=request.getParameter("pwd");
            
            // Server-side validation
            boolean valid=true;
            String errMsg="";
            if(shop==null||shop.trim().isEmpty())  { valid=false; errMsg="Shop name is required."; }
            else if(n==null||n.trim().isEmpty())   { valid=false; errMsg="Name is required."; }
            else if(mail==null||!mail.contains("@")) { valid=false; errMsg="Valid email is required."; }
            else if(num==null||!num.matches("\\d{10}"))  { valid=false; errMsg="Phone must be 10 digits."; }
            else if(pwd==null||pwd.length()<4)  { valid=false; errMsg="Password must be at least 4 characters."; }
            
            if(!valid) {
                out.println("<script>alert('" + errMsg + "'); history.back();</script>");
            } else {
                st=c1.prepareStatement("INSERT INTO provider(reg,shop,name,category,adr,no,email,time,about,pwd,status) VALUES(?,?,?,?,?,?,?,?,?,?,'approved')");
                st.setInt(1, id);
                st.setString(2, shop.trim());
                st.setString(3, n.trim());
                st.setString(4, category);
                st.setString(5, adr != null ? adr.trim() : "");
                st.setString(6, num.trim());
                st.setString(7, mail.trim());
                st.setString(8, time != null ? time.trim() : "");
                st.setString(9, about != null ? about.trim() : "");
                st.setString(10, PasswordUtil.hash(pwd));
                st.executeUpdate();

                // Auto-login into provider session
                HttpSession se = request.getSession(true);
                se.setAttribute("name", n.trim());
                se.setAttribute("shop", shop.trim());
                se.setAttribute("pwd", PasswordUtil.hash(pwd));
                se.setAttribute("role", "provider");
                se.setAttribute("reg", String.valueOf(id));
                se.setAttribute("preg", String.valueOf(id));
                se.setAttribute("category", category);
                se.setAttribute("email", mail.trim());
                se.setAttribute("mob", num.trim());
                se.setAttribute("adr", adr != null ? adr.trim() : "");

                out.println("<script>alert('Congratulations! Your trade profile has been registered and is now live.'); location.href='providerprofile.jsp';</script>");
            }
            }
            catch(Exception ex)
            {
                out.println("<script>alert('Registration Error: " + ex.getMessage().replace("'", "\\'") + "'); history.back();</script>");
            }
        %>
    </body>
</html>
