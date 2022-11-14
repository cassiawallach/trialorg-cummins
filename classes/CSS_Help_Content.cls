public with sharing class CSS_Help_Content{
    
    public boolean contentAdmin{get;set;}
    public CSS_Help_Content(){
         contentAdmin = false;
         String ContentAdminGroupName = System.label.Cummins_Guidanz_Content_Admin_Name;
         String userId = UserInfo.getUserId();
         String uLicence = [Select id,Profile.UserLicense.Name from User where Id=: UserInfo.getUserId()].Profile.UserLicense.Name;
         System.debug('**'+uLicence );
         set<String> contentUserAdmin = new set<String>();
         if(uLicence !=System.Label.Cummins_Guidanz_Content_Licence){
             for(GroupMember  gm: [SELECT UserOrGroupId FROM GroupMember WHERE Group.Name=:ContentAdminGroupName]){
                 contentUserAdmin.add(gm.UserOrGroupId);
             }
         
        
         
         if(userId!=null && userId!='' && contentUserAdmin!=null && contentUserAdmin.size()>0 ){
             
              if(contentUserAdmin.contains(userId)){
                  contentAdmin = true;
              }
         }
       }
    }
    
}