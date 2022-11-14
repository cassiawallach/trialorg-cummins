public class dbu_LoggedInUserinfo {
    @AuraEnabled(cacheable=true)
    public static List<User> getLoggedInUserInfo(){
         String loggedInUserId;
       
             id userId = UserInfo.getUserId();
        system.debug('getUserType()---->>'+UserInfo.getUserType());
        system.debug('getLocale()---->>'+UserInfo.getLocale());

       
        String Status;
        List<User> loggedInUser = new List<User>();
        try{
           if(UserInfo.getUserType() != 'Guest'){
               if(!Test.isRunningTest()) {
                   Map<String, String> usersession = Auth.SessionManagement.getCurrentSession() ;
            System.debug('currentusersession=>'+JSON.serialize(usersession));
            loggedInUserId = usersession.get('UsersId');
               }
            
            loggedInUser = [SELECT Id,FirstName, LastName,  Username FROM User WHERE Id=:loggedInUserId];
            }
        }
        catch(Exception e)
        {
            System.debug('exception=>'+e.getMessage());
        }
        return loggedInUser;
       
    }
}