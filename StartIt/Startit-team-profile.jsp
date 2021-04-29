<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="StartitClasses.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
  int startupID = Integer.parseInt(request.getParameter("startup"));
  StartupDAO sdao = new StartupDAO();
  Startup startup = sdao.findById(startupID);
  People user = (People)session.getAttribute("userObj");
  PeopleDAO ppldao = new PeopleDAO();
  ArrayList<People> ppl= new ArrayList<People>();
  ppl =ppldao.findPeopleFromSID(startupID);
  NotificationDao ndao = new NotificationDao();
  ArrayList<Notification> notifarr = ndao.getNotifications(user.getID()); 
  ArrayList<Startup> myStartups = new ArrayList<Startup>();
  if( sdao.loadMyStartups(user.getID()) != null){
	myStartups = sdao.loadMyStartups(user.getID());
  }else{
	myStartups = null;
  }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/startit-teams-profil.css" />
	<link rel="stylesheet" href="css/profil.css" />

        <title>Welcome to StartIt</title>
	<title>Team Profile</title>
	<link rel="icon" href="images/favicon.ico">

        
    </head>
<body>
    <header class="hero">
        <div class="navbar" >
          <div class="logo2">
            <a href="Startit.jsp">StartIt</a>
          </div>
          <nav>
             <ul >
                <li><a href="Startit-applications.jsp"><img src="images/connection.png" alt="" style="width: 45px; margin-top: 1vw"></a></li>
		<% if(myStartups.isEmpty()){%>
                <li><a href="Startit-oupspage.jsp"><img src="images/team.png" alt="" style="width: 40px; margin-top: 1vw;"></a></li>
		<%}else{%>
		<li><a href="Startit-myteams.jsp"><img src="images/team.png" alt="" style="width: 40px; margin-top: 1vw;"></a></li>
		<%}%>
                <li><a href="#pop-notifications" class="notifications" id="notifications"><img src="images/notification 2.png" alt="" style="width: 55px; margin-top: 0.5vw;"></a></li>
                <li><a href="Startit-profile.jsp"><img src="Uploads/<%= user.getID()%>.jpg" onerror="this.onerror=null; this.src='Uploads/user.jpg'" alt="" style="border: 1px solid grey; border-radius: 50%; width: 80px; height: 80px;"></a></li>
            </ul>
         </nav>  
        </div>
    </header> 
        <div class="contain1">
          <div class="banner"> 
            <div class="flexcontent">
                <div>
 		              <div class="profile-pic-div">
                    <img src="TeamUploads/<%=startup.getID()%>.jpg" onerror="this.onerror=null; this.src='TeamUploads/user.jpg'" id="photo">
                    <% if (sdao.isStartupLeader(startupID, user.getID())){ %>
                      <form action = "<%=request.getContextPath() %>/StartIt/UploadFileTeam.jsp" method = "post"
                        enctype = "multipart/form-data">
                          <input type="hidden" name="startup" value= <%=startupID%> >
                          <input type = "file" id="file" name = "file" size = "50" />
                          <label for="file" id="uploadBtn" >Choose Photo</label>
                          <input type = "submit" id="submit"  value = "Upload File" />                      
                      </form>
                    <% } %>                 
		              </div>
                </div>
                <div class="profile">
                  <h1> <%= startup.getName()%></h1>		
                  <ul>
		    <li><b>Info:</b> <%= startup.getWords()%></li>
                    <li><b>Stage:</b> <%= startup.getStage()%></li>
                    <li><b>Location:</b> <%= startup.getLocation()%></li>
                    <li><b>Markets:</b> <%
                    if (startup.getMarkets() != null){
                    for (String mark:startup.getMarkets()){ %> <%=mark+ " "%>  <% } } %></li>
                  </ul> 
                </div>
              </div>  
       
          
          </div>
          <div class="row">
           <%   for ( People i:ppl) {  %>
            <section class="card">
              <img src="Uploads/<%= i.getID()%>.jpg" onerror="this.onerror=null; this.src='Uploads/user.jpg'" alt="" style="border: 1px solid grey; border-radius: 50%; width: 80px; height: 80px;">
              <h1><%=i.getName()%> <%=i.getSurname()%>, <%=i.getAge()%></h1>
              <ul>
                  <li><b>Based in:</b> <%=i.getLocation()%></li>
                  <li><b>Languages:</b>  <% if (i.getLanguages() != null){
                    for (String lang:i.getLanguages()) { %> <%= lang + " "%>  <% }} %></li> 
                  <li><b>Skills:</b> <%
                    if (i.getSpecialties() != null){
                    for (String spec:i.getSpecialties()){ %> <%=spec+ " "%>  <% } } %></li>
		  
              </ul> 
              <form action = "<%=request.getContextPath() %>/StartIt/Startit-strangerprofile.jsp" method = "post">
                <input type="hidden" name="personID" value= <%=i.getID()%>>
                <button>Learn more</button>
              </form>
            </section>
            <% } %>
          </div>  
        </div>     
    <section id="pop-notifications" class="pop-notifications">
      <h1> Notifications</h1>
      <%
      try{
        if (notifarr.size() > 0){
          for (Notification notif:notifarr){
            int type = notif.getType();
            String[] notifString = ndao.type2string(notif);
            String whereto = "Startit-team-profile.jsp?startup=" + notif.getStartupID(); %>  
            <div class="notif">
              <a href=<%=whereto%>> <img class="notificon"  src="images/notificationsv.svg" alt="">  </a>
              <div class="notifcontent">
                  <h2><%= notifString[0] %></h2>
                  <h3><%= notifString[1] %></h3>          
                <%if (type==1 || type==4){ %>
                    <form method="post"
                    action="<%=request.getContextPath() %>/StartIt/Startit-notificationController.jsp">
                      <input type="hidden" name="notification" value=<%=notif.getNotificationId()%> >
                      <input type="hidden" name="answer" value="accepted">
                      <input type="hidden" name="whatabout" value="reply">
                      <input type="hidden" name="url" value="Startit-profile.jsp">
                      <button type="submit">Accept</button>
                    </form>
                  <% } %>
                <form method="post"
                  action="<%=request.getContextPath() %>/StartIt/Startit-notificationController.jsp">
                  <input type="hidden" name="notification" value= <%=notif.getNotificationId()%> >
                  <input type="hidden" name="answer" value="declined">
                  <input type="hidden" name="whatabout" value="reply">
                  <input type="hidden" name="url" value="Startit-profile.jsp">
                  <button type="submit">Dismiss</button>
                </form>
                  
              </div>
            </div> 
        
      <%}}
      }catch (Exception e){
        e.printStackTrace();
      }
      %> 
    </section>
    <script src="js/startit-script-team-profil.js"></script>
    <script src="<%=request.getContextPath() %>/js/jquery-3.5.1.min.js"></script>
    <script src="<%=request.getContextPath() %>/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
      $(".notifications").on('click',function(){
          $(".pop-notifications").toggleClass("show");
      });
   </script>

</body>
</html>