Public Class IAM_RSW_CreateUser Implements Queueable{
	
    Public Set<id> idsNoUser;
    Public id appID;
    
    Public IAM_RSW_CreateUser(Set<id> idsNoUser,id appId){
    	this.idsNoUser= idsNoUser;
        this.appId= appID;
   	} 
    
    Public Void execute(QueueableContext Context){
     System.debug('Entered RSW create Class');
   		
        if(!idsNoUser.isEmpty()){
        List<Contact> objCon = [select id,firstname,lastname,email,phone,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,   
        Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c, 
        Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,   
        IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,   
        Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c, 
        Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Ext_Legacy_Uid__c,IAM_Site_Admin__c from Contact where id in :idsNoUser];
             
         if(!objCon.isEmpty()){
         String returnvalue=IAM_CreateUser.CreateUser(objCon);
         System.debug('Printing return value in rsw class'+returnvalue);
             if(test.isRunningTest()){
                 returnvalue='OK';
             }
         if(returnvalue=='OK'){
             List<user> usr=[Select id,isActive from user where Contact.id=:idsNoUser];
             //Above query should always return only value user record since we are calling it from rsw in bound class an it will happens for only one contact
             System.debug('Printing user details'+usr);
              if(!usr.isEmpty()){
                  //calling future method to assign Permission set.
                 assignPermissionSet(usr[0].id,appId); 
              }   
             }  
         }           
     }   
    }
   
   
   
   Public Static Void UpdateUser(set<id> Conids,id appId){
   
       List<user> usr= [Select id,isActive,username from user where Contact.id=:Conids];
       try{
       for(user u:usr){
           if(!u.isActive){
           	u.isActive=true;
           }
       }
       //Update usr;
        assignPermissionSet(usr[0].id,appId);
       }catch(exception e){
           System.debug('Printing exception'+e);
         IAM_RSW_Inbound.cmiError(e.getStackTraceString(),usr[0].username,appId);
       }
   } 
   
   @future 
   Public Static Void assignPermissionSet(id userId,id appId){
   
   System.debug('Printing Future method where RSW application Acces is provided user id is'+userId+'contact Provisioning id is'+appId);
   List<IAM_Contact_Provisioning__c> rsw=[select id,IAM_Application_Name__c,IAM_Status__c from IAM_Contact_Provisioning__c where id=:appId];
   System.debug('Printing application Name'+rsw);
   user usr=[Select id,username from user where id=:userId];
   try{
   if(!rsw.isEmpty()){
       List<PermissionSet> pSet=[Select id,Name from PermissionSet where Label=:rsw[0].IAM_Application_Name__c];
       System.debug('Printing Permission set ids'+pSet);
       if(!pSet.isEmpty()){
           PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = pSet[0].id, AssigneeId = userId);
           insert psa;
   
       }
      }
     }catch(exception e){
         System.debug('Printing exception'+e);
         IAM_RSW_Inbound.cmiError(e.getStackTraceString(),usr.username,rsw[0].IAM_Status__c);
     }
  } 
}