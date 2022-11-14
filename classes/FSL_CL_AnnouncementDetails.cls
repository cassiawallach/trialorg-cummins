/*****************************************************************************************************************************
Name : FSL_CL_AnnouncementDetails 
Description1 : Calling Announcements metadata type.


Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                  11/01/2021                Revathi Chirigiri                   Class created
2.0                  11/02/2021                Rajkumar BT                         Create a method to retrieve
                                                                                   Metadata as wrapper
3.0                  07/12/2022                Ronnie Mishra                       Query modified as part of 
                                                                                    SG-21  to show latest announcements on top.
******************************************************************************************************************************/
public class FSL_CL_AnnouncementDetails {
    public static FINAL String EVL_DEALER_PROFILE = 'EVL_Dealer';
    public static FINAL String CSS_SERVICE_PROFILE = 'CSS_Service';
    public static FINAL String SYSADMIN_PROFILE = 'System Administrator';
     
    @AuraEnabled
    public string annCategoryName;
    
    @AuraEnabled (cacheable=true)
    public static string getAnnouncements() {
        String announcementHeaderText;
        try{
            String EVL_Profile = EVL_DEALER_PROFILE;
            String CSS_Service_Profile = CSS_SERVICE_PROFILE;
            Boolean showAnnouncement = true;
            String userType;
            String switchUserType;
            Boolean switchActive;
           
            List<FSL_CL_AnnouncementDetails> annDetailsWrapper = new List<FSL_CL_AnnouncementDetails>();
            
            Map<Id, FSL_Announcements_Data__c> mapAnnoucementDetails;
            List<FSL_Announcements_Data__c> lstAllAnnouncements;
            
            User usr = [SELECT Id, Profile.name, UserRole.Name FROM user WHERE id=:userInfo.getUserId() LIMIT 1];
            
            if(usr != null){
                if(usr.UserRole.Name.contains('Factory')){
                    userType = 'Factory';
                }
                else if(usr.Profile.Name.contains(EVL_Profile)){
                    userType = 'Dealer';
                }
                else if(usr.Profile.Name.contains(CSS_Service_Profile)){
                    userType = 'Distributor';
                }
                else{
                    userType = 'Administrator';
                }
            }
            
            List<FSL_Switch__c> lstSwitchDetails = new List<FSL_Switch__c>();
            lstSwitchDetails = [SELECT Id, Name, IsActive__c, User_Type__c FROM FSL_Switch__c WHERE Name = 'Announcement' AND IsActive__c = TRUE];
            
            if(lstSwitchDetails != null && lstSwitchDetails.size() > 0){
                switchUserType = lstSwitchDetails[0].User_Type__c;
                switchActive = lstSwitchDetails[0].IsActive__c;
                
                if(switchActive == TRUE && switchUserType != null){
                    if((switchUserType.contains(userType))){
                        announcementHeaderText = [SELECT Id, Description__c FROM FSL_Announcements_Data__c WHERE Type__c =: userType AND Category__c = 'Scrolling Text' WITH SECURITY_ENFORCED].Description__c;
                    }
                    else{
                        //announcementHeaderText = [SELECT Id, Description__c FROM FSL_Announcements_Data__c WHERE Category__c = 'Scrolling Text'].Description__c;
                    }
                }
            }
            else{
                announcementHeaderText = [SELECT Id, Description__c FROM FSL_Announcements_Data__c WHERE Category__c = 'Scrolling Text'].Description__c;
            }
            
            if((userType == 'Factory') || (userType == 'Administrator')){
                announcementHeaderText = [SELECT Id, Description__c FROM FSL_Announcements_Data__c WHERE Category__c = 'Scrolling Text'].Description__c;
            }
            
            if(Test.isRunningTest()) {
                EVL_Profile = SYSADMIN_PROFILE;
                CSS_Service_Profile = SYSADMIN_PROFILE;
            }
        }
        catch(Exception ex){
            FSL_CL_ErrorLogger.insertApplicationErrorLog(UserInfo.getUserId(), 'FSL_CL_AnnouncementDetails', ex.getStackTraceString(), ex.getMessage(), ex.getLineNumber(), 'getAnnouncements', UserInfo.getUserId());
        }
        return announcementHeaderText;
    }
    
    @AuraEnabled(cacheable = true)
    public static FSL_Announcements_Data__c getSingleRecord() {
        return [
            SELECT Id, Description__c, Type__c, Name 
            FROM FSL_Announcements_Data__c 
            WHERE Type__c = 'Dealer' 
            LIMIT 1
        ];
    }
    
    @AuraEnabled(cacheable = true)
    public static List<FSL_Announcements_Data__c> getAllAnnouncements() {
        //Query modified as part of SG-21 to show latest announcements on top.
        return [
            SELECT Id, Name, Category__c, Description__c, Type__c, Navigation_Url__c, EditableCategory__c, 
            CreatedDate FROM FSL_Announcements_Data__c ORDER BY CreatedDate DESC
        ]; 
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<ID, String> getRelatedFilesByRecordId(String recordId) {
        try{
            // Get record file IDs        
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
            
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                         FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
            return mapIdTitle;
        }
        catch(Exception ex){
            FSL_CL_ErrorLogger.insertApplicationErrorLog(UserInfo.getUserId(), 'FSL_CL_AnnouncementDetails', ex.getStackTraceString(), ex.getMessage(), ex.getLineNumber(), 'getRelatedFilesByRecordId', recordId);
            return null;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static boolean fetchUserRole(){
        User usr = [SELECT Id, Profile.name, UserRole.Name FROM user WHERE id=:userInfo.getUserId() LIMIT 1];
        
        if(usr.UserRole.Name.contains('Factory') || usr.Profile.name == 'System Administrator'){
            return TRUE;
        }else{
            return FALSE;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static boolean fetchAdminRole(){
        User usr = [SELECT Id, Profile.name, UserRole.Name FROM user WHERE id=:userInfo.getUserId() LIMIT 1];
        
        if(usr.Profile.name == 'System Administrator'){
            return TRUE;
        }else{
            return FALSE;
        }
    }
    
    //start: updated by Trupthi, NIN-47 Date:2/21/2022 - Assign blank value to a PSN from Home page 
    @AuraEnabled
    public static string fetchPSNValue(){
        string psnValue;
        Cache.Session.put('local.CSSPartition.SessionSoPSN', '');
        psnValue = (string)Cache.Session.get('local.CSSPartition.SessionSoPSN');
        return psnValue;
    }
    //updated by Trupthi, NIN-47 Date:2/21/2022 -END
    
    
}