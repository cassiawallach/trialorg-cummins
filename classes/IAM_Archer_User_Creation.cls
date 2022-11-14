Public class IAM_Archer_User_Creation{
    
    Public Static void createUser(Set<id> ConIds,Set<id> conProvIds){
    System.debug('Archer User creation class entered');
     List<User> usersArcher=new List<User>();
     Set<Id> archerIds= new Set<Id>();
     Set<Id> cumminsApiPortalIds= new Set<Id>();// To store ids which are related to cumminss api portal app
    try{
    List<Contact> Cons=[SELECT Id
                 , FirstName
                 , LastName
                 , IAM_Internal__c
                 , Email
                 , Phone
                 , Account.CMI_Account_Num__c
                 , AccountId
                 , Account.Name
                 , CMI_Contact_Type__c
                 , Account.Type
                 , Username__c
                 , IAM_Final_Approver__c
                 , Account.OwnerId
                 , Account.IAM_ABO_Code_Formula__c
                 , IAM_Applications__c
                 , Account.IAM_Service_Provider_Code__c
                 , Account.CSS_DBCode__c
                 , Account.CSS_DistributorCode__c
                 , Account.parentid
                 , IAM_is_Member_of__c
                 , IAM_Work_Group_Id__c
                 , IAM_Qsolexpiration__c
                 , IAM_Qsolview__c
                 , IAM_Product_Group_Access__c
                 , Account.Location__c
                 , Account.BillingStreet
                 , Account.BillingCity
                 , Account.BillingCountry
                 , Account.BillingPostalCode
                 , Account.CSS_Locale__c
                 , Account.CSS_Language__c
                 , Account.CSS_Timezone__c
                 , Account.IAM_Movex_Customer_Code__c
                 , Account.IAM_WWSPS_Regions__c
                 , IAM_Site_Admin__c
                 , IAM_Site_Admin_Role__c
                 ,IAM_Contact_Status__c
              FROM Contact
             WHERE Id =: ConIds];
             
             if(!Cons.isEmpty()){
                 String createUser=IAM_CreateUser.CreateUser(Cons);
                 System.debug('Printing value from Create user class'+createUser);
                 if(createUser=='OK'){
                 //Need to update Contact Status and User provisioning Status
                     for(Contact c:Cons){
                         if(c.IAM_Contact_Status__c!='Active'){
                             c.IAM_Contact_Status__c='Active';
                         }
                         
                         Update Cons;
                         
                         usersArcher=[select id,ContactId from User where ContactId=:ConIds];
                         
                         Map<id, User> myMap = new Map<id, User>(); 
                         for(User u : [Select id,ContactId From User where ContactId=:ConIds]){
                             myMap.put(u.Contactid,u);
                         }
                         
                         //Now need to update user id field in the contact access and features.
                         List<IAM_Contact_Provisioning__c> conProv=[select id,IAM_Status__c,IAM_Application_Name__c,IAM_User__c,IAM_Contact__c from IAM_Contact_Provisioning__c where id=:conProvIds];
                         if(!conProv.isEmpty()){
                             for(IAM_Contact_Provisioning__c cn:conProv){
                                if(!myMap.isEmpty()){
                                    if(myMap.ContainsKey(cn.IAM_Contact__c)){
                                        cn.IAM_User__c=myMap.get(cn.IAM_Contact__c).id;
                                        if(cn.IAM_Application_Name__c==System.Label.IAM_Application_Name_Archer)
                                            archerIds.add(myMap.get(cn.IAM_Contact__c).id);
                                        else if(cn.IAM_Application_Name__c==System.Label.IAM_Application_Name_Cummins_API_Portal)
                                            cumminsApiPortalIds.add(myMap.get(cn.IAM_Contact__c).id);
                                    }
                                 }
                             }
                             Update conProv;
                         }
                         
                     }
                 }
             }
        
        //once after updating the user we need to assign Archer permission set to assign application access.
        if(!archerIds.isEmpty()){
        //Now Query for th permission set Id and User ID.
        List<PermissionSet> pSetArcher=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label=:System.Label.IAM_Application_Name_Archer];
			if(!pSetArcher.isEmpty())  
            {
             //Since both Archer permission set and user are not empty we call below class to assign permission set
            IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(archerIds,pSetArcher[0].id,'Insert'); //this should take care of the application permission set assignment.
            }
        }
        if(!cumminsApiPortalIds.isEmpty()){
        // Query for Cummins API portal permission set
        List<PermissionSet> pSetCumminsAPIPortal=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label=:System.Label.IAM_Application_Name_Cummins_API_Portal];
        if(!pSetCumminsAPIPortal.isEmpty())
        //Since both Cummins API portal permission set and user are not empty we call below class to assign permission set
        IAM_Assign_Application_Permissionset.AssignPermissionSetToUsers(cumminsApiPortalIds,pSetCumminsAPIPortal[0].id,'Insert'); //this should take care of the application permission set assignment.
        }
        
        }catch(exception e){
                    
        System.debug('Printing application exception'+e);
        IAM_ErrorHandling.IAMerrorCapture(e.getMessage(),'IDENTITY-Archer',e.getStackTraceString());
        }
    }
    
}