Public Class FSL_PortalUser_Trigger_Helper{

    //Below method to update Contact Language of a Customer User
    @future
    public static void updateContact(Id contId, string langLocale){
        try{
            Contact contRec = new Contact();
            
            if(langLocale == 'en_US') {       
                contRec.Language_Preferences__c = 'English';
            }
            else if(langLocale == 'fr')   {
                contRec.Language_Preferences__c = 'French';
            }
            
            contRec.Id = contId;
            update contRec;
        }
        catch(Exception ex){
            System.debug('Inside Contact Language Update Exception'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(contId, Label.FSL_Service_Portal_Error_Handling, ex.getStackTraceString());
        }
    }
    
    //Below method to fetch User Language Locale key for Custom User
    Public Static Void LangContactUpdate(Map<Id, User> oldUserMap, List<User> usrs){
        try{
            List<Contact> ListContact = new  List<Contact>();
            List<Id> contactIdlist = new List<Id>();
            List<Id> UId = new List<Id>();
            for(User us:usrs){
                contactIdlist.add(us.ContactId);
                UId.add(us.id);
            }
            Profile pf=[SELECT id,name FROM Profile WHERE name='FSL_Guidanz_Customer_Community_User'];
            List<User> ListUser = [select id,LanguageLocaleKey from User where id =:UId AND ProfileId =:pf.id];
            
             if(ListUser.size() > 0 && contactIdlist.size () > 0) {
                 if(oldUserMap != null && oldUserMap.get(ListUser[0].Id).LanguageLocaleKey != ListUser[0].LanguageLocaleKey){
                    for(Contact con: [SELECT Id  FROM Contact WHERE id in: contactIdlist]) {
                       updateContact(con.Id, ListUser[0].LanguageLocaleKey);
                    }
                    
                    system.debug('**ListContact' +ListContact);
                 }
            }
        }
        catch(Exception ex){
            System.debug('Inside Contact Language Update Exception'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(usrs[0].Id, Label.FSL_Service_Portal_Error_Handling, ex.getStackTraceString());
        }
    }
}