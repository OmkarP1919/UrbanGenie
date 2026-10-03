<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Provider Approval</title>
</head>

<body>

<%

Connection con=null;
PreparedStatement ps=null;

try{

con=DBUtil.getConnection();

int rn=Integer.parseInt(request.getParameter("approve"));

String query="UPDATE provider SET status=? WHERE reg=?";

ps=con.prepareStatement(query);
ps.setString(1,"Approved");
ps.setInt(2,rn);

int result=ps.executeUpdate();

if(result>0)
{
%>

<script>
alert("Provider Approved Successfully");
window.location="provider_list.jsp";
</script>

<%
}
else
{
%>

<script>
alert("Unable to Approve Provider");
window.location="provider_list.jsp";
</script>

<%
}

}
catch(Exception e)
{
out.println("Error : "+e);
}
finally
{
try{
if(ps!=null) ps.close();
if(con!=null) con.close();
}catch(Exception e){}
}

%>

</body>
</html>