/*****************************************************
Name:FSL_UserToolsSHGetProfile
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this controller   for view history in User Tools to get the profile 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                DATE                DETAIL                                 
1.0 -   Karthik Gorantla     10/07/2020        INITIAL DEVELOPMENT 
***********************************************************************/
public class FSL_UserToolsSHGetProfile {
@AuraEnabled
public static Profile getProfileInfo(){
  try{
    String profileId = UserInfo.getProfileId();
    Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
    system.debug('profile>>>>>>>'+profile.Name);
     if(test.isRunningTest()){
          User u1 = [SELECT Id, Name, UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];
          system.debug('User Role-->'+u1.UserRole.Name);
      }
    return profile;
      
  }catch(Exception e){
    throw new AuraHandledException(e.getMessage()); 
  }
}
    @AuraEnabled
    public static map<String, String> startRequest(String enteredPSN){
       return FSL_CL_HelpfulResource.startRequest(enteredPSN);
    }
}