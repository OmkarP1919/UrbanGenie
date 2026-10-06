
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <script type="text/javascript">
            function preventBack()
            {
                window.history.forward();
            }
            setTimeout("preventBack()",0);
            window.onunload=function(){null};
                        </script>
        <title>JSP Page</title>
    </head>
    <body>
        <%
            HttpSession se = request.getSession(false);
            if (se != null) {
                try {
                    se.invalidate();
                } catch (Exception ignore) {}
            }
            response.sendRedirect("index.html");
        %>
    </body>
</html>
