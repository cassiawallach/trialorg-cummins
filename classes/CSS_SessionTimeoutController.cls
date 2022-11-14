public class CSS_SessionTimeoutController {
    
    public PageReference MoveUserToHomePage() {
         PageReference pageRef = new pageReference('/secur/logout.jsp'); 
         pageRef.setRedirect(true);
         return pageRef;
    }

}