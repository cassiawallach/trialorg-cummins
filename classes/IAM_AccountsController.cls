/************************************************************
Name:  IAM_AccountsController
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
This is test class for IAM_AccountsController class.                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         20/04/2019        INITIAL DEVELOPMENT  
1.1 -    Nishant Verma             02/10/2020        Fluidwatch Changes for site admin page 
1.2 -    Shubhangi Sardar          12/03/2020        Added FT-NPBU Dignostics app logic
1.3 -    Karthik Raj Golakaram     01/25/2021        Making Changes for OSM High Prod issue - INC1022619
1.4 -    Shubhangi Sardar          21/01/2021        Added PS Pro Subscription for Field Test Guidanz Mobile 
1.5 -    Karthik Raj Golakaram     03/24/2021        Added Changes for Market place Bulk User API defect. 
1.6 -    Karthik Raj Golakaram     03/29/2021        Added Changes to dispaly proper success message
1.7 -    Anupam Adhikari           03/23/2021        Made changes for Global Dealer portal.
1.8 -    Vishnu Mamidi             04/23/2021        Added changes for ecommerce changes fro language translation and email.
1.9 -    Vinod Kankatala           06/01/2021        Added Guidanz Mobile Power Plus subscription
1.10-    Shubhangi Sardar          11/18/2021        Added method to get GuidanzServicePortalRole
1.11-    Chetan Gaikwad            04/21/2022        code optimized to not update unchanged records in bulk app assignment
1.12-    Suresh Rathod             29/06/2022        Added code to allow modules update for Cumpas provisioning
*****************************************************/
/********************************************************************************
***********************************************************************************/ 

public without sharing class IAM_AccountsController {
    @AuraEnabled
    public static sObject getsObjectInfo(id recordid) {
        System.debug('recordid::' + recordid);
        String sName=recordid.getSObjectType().getDescribe().getName();
        sObject sObj;
        if(sName=='Account'){ 
          sObj=Database.Query('SELECT Id, name, industry, Type, NumberOfEmployees, TickerSymbol, Phone,CMI_Account_Status__c,CMI_Care_Service_Level__c,CMI_CDA_Status__c,CMI_Cummins_Customer_Id__c FROM Account where id=:recordid');
        }
        if(sName=='Contact'){
           sObj=Database.Query('Select id,Name,FirstName,LastName,Email,CMI_Contact_Type__c,IAM_Contact_Status__c from Contact where id=:recordid');
        } 
        if(sName=='IAM_Contact_Provisioning__c'){
           sObj=Database.Query('Select id,Name,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c from IAM_Contact_Provisioning__c where id=:recordid');
        }
        if(sName=='IAM_Application__c'){
           sObj=Database.Query('Select id,Name,IAM_Account_Name__c,IAM_Application_Name__c,IAM_Subscription_Name__c,IAM_Role__c,IAM_Status__c,IAM_Free_Subscription__c from IAM_Application__c where id=:recordid');
        }
        return sObj;
    }
    
    //Amarnath Mishra added for the fetching profile of a logged in user
    //04-19-2019
      @AuraEnabled
      public static String getProfile() {
          Id profileId=userinfo.getProfileId();
          String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
          system.debug('ProfileName'+profileName);
          
          return profileName;
      }
      
      //Amarnath Mishra added for the fetching application name
      
      @AuraEnabled
      public static String getsApplicationName(Id recordId) {
          Id profileId=userinfo.getProfileId();
          String appName=[Select Id,IAM_Application_Name__c FROM IAM_Contact_Provisioning__c where Id=:recordId].IAM_Application_Name__c;
          system.debug('Application Name'+appName);
          
          return appName;
      }
      
      //Amarnath Mishra added for edit role change
      //04-23-2019
      @AuraEnabled
      Public Static Map<String,list<String>> getApplicationNRoleNames(id recordid){  
          //we are calling below class to apply sharing rules so that User may assaign only apps related to his application only.
        
         Map<String,list<String>> options= new Map<String,list<String>>();
         User currentUser = [select id,Profile.name from user where id=:userinfo.getuserId() limit 1];
         if(currentUser.Profile.name == 'IAM_Site_Admin_Community'||currentUser.Profile.name == 'IAM User') {
         //Class without sharing
          options=IAM_getSubscriptionNameswithout.getApplicationNRoleNames(recordid);
         } else {
         //Class with sharing
          options=IAM_getSubscriptionNames.getApplicationNRoleNames(recordid);
         } 
          return options;
      }
      
      //Amarnath added for the applicaion other than CUMPAS 2.0 update roles and modularity
  //Date 04-26-2019
   @AuraEnabled
  public static string updateRoles(Id recordid,string rolesNames,string serviceId){
      system.debug('===Inside updateRoles method===');
      string returnmessage;
      
      IAM_Contact_Provisioning__c iamContactProvisioningRecord = new IAM_Contact_Provisioning__c();
      iamContactProvisioningRecord = [SELECT Id,IAM_Role__c,IAM_Application_Name__c,IAM_Guidanz_Mobile_Roles__c FROM IAM_Contact_Provisioning__c WHERE id =:recordid];
      returnmessage = 'Record Updated';
      if(iamContactProvisioningRecord != null){
          iamContactProvisioningRecord.IAM_Role__c = rolesNames;
          //iamContactProvisioningRecord.IAM_Role__c = '';
          if(iamContactProvisioningRecord.IAM_Application_Name__c == System.Label.IAM_AppName_guidanzmobile){
              //iamContactProvisioningRecord.IAM_Guidanz_Mobile_Roles__c = rolesNames;
          }
          if(iamContactProvisioningRecord.IAM_Application_Name__c == 'Cummins Service Training'){
                  iamContactProvisioningRecord.IAM_Promotion__c= serviceId;
              }
          try{
              update iamContactProvisioningRecord;
          }catch(Exception ex){
              returnmessage=fieldCustomValidation(ex);
            /* if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnmessage = ex.getdmlMessage(0);
                  }
                  else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
                  }*/
                  
              
          }
      }
      else{
          returnmessage = 'Record not found';
      }
      return returnmessage;
  }
  
  //Amarnath added for the CUMPAS2.0 update roles and modularity
   @AuraEnabled
  public static string updateAppCumpas(Id recordid,string rolesNames,string moudularity){
      system.debug('===Inside updateCumpas method===');
      string returnmessage;
      
      IAM_Contact_Provisioning__c iamContactProvisioningRecord = new IAM_Contact_Provisioning__c();
      iamContactProvisioningRecord = [SELECT Id,IAM_Role__c,IAM_Cumpas_Modularity__c FROM IAM_Contact_Provisioning__c WHERE id =:recordid];
      returnmessage = 'Record Updated';
      if(iamContactProvisioningRecord != null){
          iamContactProvisioningRecord.IAM_Role__c = rolesNames;
          iamContactProvisioningRecord.IAM_Cumpas_Modularity__c = moudularity;
          try{
              update iamContactProvisioningRecord;
          }catch(Exception ex){
              returnmessage=fieldCustomValidation(ex);
              /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnmessage = ex.getdmlMessage(0);
                  }
              else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
              }*/
          }
      }
      else{
          returnmessage = 'Record not found';
      }
      return returnmessage;
  }
  
   //Amarnath Mishra added for the internal issue#78
      @AuraEnabled
      public static map<string,string> getUserType(id recordid) {
      Id myId = recordid;
      Boolean isCSTUser= false; 
      Boolean isCST=false;
     
         
      
          
      map<string,string> mapuserstatus= new map<string,string>();
      map<string,string> mapuserstatusBlank= new map<string,string>();
      mapuserstatusBlank.put('IAM_Internal__c','false');
      mapuserstatusBlank.put('IAM_Contact_Status__c','');
      mapuserstatusBlank.put('Username__c','' );
      mapuserstatusBlank.put('IAM_Legacy_User__c','false');
      mapuserstatusBlank.put('CMI_CId__c','');
      
      String sObjName = myId.getSObjectType().getDescribe().getName();
          if(sObjName == 'Contact'){
              Contact con = [SELECT id,IAM_Internal__c,Account.CMI_CId__c,IAM_Contact_Status__c,Account.type,IAM_Legacy_User__c,Username__c,Account.IAM_Internal_Account__c FROM Contact WHERE Id =:recordid];
              if(con != null){
                 
                  mapuserstatus.put('IAM_Internal__c',string.valueOf(con.IAM_Internal__c));
                  mapuserstatus.put('IAM_Contact_Status__c',con.IAM_Contact_Status__c);
                  mapuserstatus.put('IAM_Legacy_User__c',string.valueOf(con.IAM_Legacy_User__c));
                  mapuserstatus.put('Username__c',con.Username__c );
                  if(string.isNotBlank(con.Account.CMI_CId__c)){
                      mapuserstatus.put('CMI_CId__c',string.valueOf(con.Account.CMI_CId__c ));
                  }
                  
                  if(con.Account.Type == 'Internal' && con.Account.IAM_Internal_Account__c == True) {
                      mapuserstatus.put('IsInternalAccount', 'True');
                  } else {
                      mapuserstatus.put('IsInternalAccount', 'False');
                  }
                  return mapuserstatus;
              }
              else{
                                      
                  return mapuserstatus;
              }
          }
          else{
              
              return mapuserstatus;
          }
      }
          
  //Amarnath Mishra added for the internal issue#78
  @AuraEnabled
  public static boolean getUserReclaimStatus(id recordid) {
  Id myId = recordid;
  String sObjName = myId.getSObjectType().getDescribe().getName();
      if(sObjName == 'Contact'){
          Contact con = [SELECT id,IAM_Contact_Status__c FROM Contact WHERE Id =:recordid];
          if(con != null){
              if(con.IAM_Contact_Status__c == 'Reclaim'){
                  return true;
              }
              else{
                  return false;
              }
              
          }
          else{
          return false;
          }
      }
      else{
          return false;
      }
  }
  
      
     @AuraEnabled
       public static String getName(id recordid) {
      String Name=recordid.getSObjectType().getDescribe().getName();
         return Name;
    }
     @AuraEnabled
      Public static Boolean resetButton(id recordid){
          Boolean restpswrd=false;
            List<User> u=[Select id,isActive from user where contactid=:recordid];
          if(!u.isEmpty()&&u[0].isActive==True){
              restpswrd=true;
          }
          return restpswrd;
      }
      @AuraEnabled
      public static Boolean unlockButton(id recordid){
          Boolean unlock=false;
          List<User> u=[Select id from user where contactid=:recordid];
          if(!u.isEmpty()){
              UserLogin usr=[Select IsPasswordLocked from UserLogin where userid=:u[0].id];
              if(usr.IsPasswordLocked==true){
                  unlock=true;
              }
          }
          return unlock;
      }
      @AuraEnabled
       public static String SendPCInfo(id recordid,string buName) {
          System.debug('Printing button name'+buName);
          List<Account> acc= new List<Account>();
           List<IAM_Application__c> appDA= new List<IAM_Application__c>();
           id accidToSend ;
           String Tspvalidation,accStatus;
           try{
            //Checking the object from where the send to pc is called.
            String ObjectName=recordid.getSObjectType().getDescribe().getName();
               System.debug('Printing application Name'+ObjectName);
               if(ObjectName=='Account'){  
          acc=[SELECT Id, name, industry, Type, NumberOfEmployees, TickerSymbol, Phone,CMI_Account_Status__c,(select id,IAM_Application_Name__c,IAM_Status__c,CMI_CDA_Status__c from Applications__r where IAM_Application_Name__c='Connected Solutions' LIMIT 1),CMI_Cummins_Customer_Id__c FROM Account where id=:recordid LIMIT 1]; 
          accidToSend=acc[0].Id;  
      
                   if(!acc[0].Applications__r.isEmpty()){
                       appDA[0]=acc[0].Applications__r[0];
                   }
               }else if(ObjectName=='IAM_Application__c'){
                   appDA=[SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Account_Name__c FROM IAM_Application__c where id=:recordid LIMIT 1];
                  acc=[Select id,Name from account where id=:appDA[0].IAM_Account_Name__c LIMIT 1];
                   System.debug('Printing application Info'+appDA);
                   if(!appDA.isEmpty()){
                   accidToSend=appDA[0].IAM_Account_Name__c;
                   }
               }
              System.debug('Printing account id that is going to the send to PC'+accidToSend); 
              
                
           System.debug('Account size'+acc.size());
               if(!acc.isEmpty()&&!appDA.isEmpty()){
                   
                   if(buName=='Activate'){
               accStatus='Active';
           }else if(buName=='De-Activate'){
               accStatus='Inactive';
           }else{
               accStatus=appDA[0].IAM_Status__c;
           }
            //calling company info class to validate all the required fields.     
                   if(!Test.isRunningTest()){     
           Tspvalidation=CMI_CompanyInformation.TspValidation(recordid,accidToSend,buName);   
                   }else{ 
                      Tspvalidation='valid';  
                   }
            if(Tspvalidation=='valid'){
               //calling company info class to send information to PC.
           String sendInfo=CMI_CompanyInformation.CalloutResponseContents(recordid,accidToSend,accStatus,buName);
               if(sendInfo=='successfull.'||sendInfo=='OK'){
                  return 'Ok' ;
               }else{     
                   return sendInfo;
               }
            } else{
             return Tspvalidation;
            }
         }         
         return 'No Customer present.Please contact System Administrator.';
           }catch(exception ex){
               string returnmessage=fieldCustomValidation(ex);
                  /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnmessage = ex.getdmlMessage(0);
                  }
                  else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
                  }*/
              return returnmessage;
           }       
    }
      
      @AuraEnabled
      public static String accUpdate(id recordid,string buName,string rejectReason,string rejectcomments){
          //This function reads button name and update the account status accordly
          System.debug('Printing button name'+buName);
         // String accStatus;
         String objName=IAM_AccountsController.getName(recordid);
          if(objName=='Account'){
          List<Account> acc=[SELECT Id, name, Type,Account.OwnerId, CMI_Account_Status__c,CMI_CDA_Status__c from Account where id=:recordid];
          if(buName=='Activate'||buName=='Generate User ID'){
               acc[0].CMI_Account_Status__c='Active';
           }
          if(buName=='De-Activate'){
               acc[0].CMI_Account_Status__c='Inactive';
          }
          if(buName=='Generate Service Agreement'){
             acc[0].CMI_CDA_Status__c='Sent To Customer'; 
          }
          
          if(!acc.isEmpty()){
              try{
                System.debug('Printing account details before update'+acc);  
              //acc[0].CMI_Account_Status__c=accStatus;
              update acc;
                //Do not change the Return value. Controller script depends upon this value  
               return 'Ok';
              }catch(exception ex){
                 string returnmessage;
                 /* if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnmessage = ex.getdmlMessage(0);
                  }
                  else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
                  }*/
                  //Commented by Karthik on - 01-30-2021
                  return returnmessage=fieldCustomValidation(ex);
              }
          }
        }
          else if(objName=='Contact'){
              List<contact> con=[Select id,IAM_Applications__c,IAM_Internal__c,IAM_Application_Roles__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,FirstName,email,IAM_Contact_Status__c,Account.CMI_Account_Status__c,Account.id,(select id,IAM_Status__c from Contact_Provisionings__r) from Contact where id=:recordid LIMIT 1];
             List<IAM_Contact_Provisioning__c> toActivate=new List<IAM_Contact_Provisioning__c>();
             List<user> u=[select id,Name from user where contactid=:recordid];
              if(!con.isEmpty()){
                  if(buName=='Activate'){
                      con[0].IAM_Contact_Status__c ='Active';
                      con[0].IAM_Reject_Reason__c = '';
                      con[0].IAM_Reason__c = '';
                      con[0].IAM_Deactivation_Mail_Sent__c = false;
                      if(con[0].Account.CMI_Account_Status__c!='Active')
                      con[0].Account.CMI_Account_Status__c='Active';
                      for(IAM_Contact_Provisioning__c conP :con[0].Contact_Provisionings__r){
                          if(conp.IAM_Status__c!='Inactive'){
                              conp.IAM_User__c=u[0].id;
                              //conp.IAM_Status__c='Active';
                              //issue# 38 making this check box unchecked to triggering application access approval email contact status set to Active
                              conp.IAM_Is_Reclaim_Access_Email_Send__c = false;
                              System.debug('Printing..contactpro ..IAM_Is_Reclaim_Access_Email_Send__c... ' + conp.IAM_Is_Reclaim_Access_Email_Send__c);
                              //toActivate.add(conP);
                          }
                          conp.IAM_Status__c='Inactive';
                          toActivate.add(conP);
                          
                      }
                  }
                  if(buName=='De-Activate'){
                      con[0].IAM_Contact_Status__c='Inactive';
                      con[0].IAM_Applications__c = '';
                      con[0].IAM_Application_Roles__c ='';
                      con[0].IAM_Qsolexpiration__c = '';
                      con[0].IAM_Qsolview__c = '';
                      con[0].IAM_Reject_Reason__c = rejectReason;
                      con[0].IAM_Reason__c = rejectcomments;
                      con[0].IAM_Deactivation_Mail_Sent__c = true;
                  }
                  try{
                      System.debug('Printing Contact Details that need to be updated'+con[0]);
                      update con[0];
                      if(!toActivate.isEmpty()){
                          // Amarnath Mishra commented
                          update toActivate;
                      }
                      //update con[0].Contact_Provisionings__r;
                      if(con[0].Account.CMI_Account_Status__c=='Inactive'&&buName=='Activate'){
                          update con[0].Account;
                      }
                      //since contact is deactivated we need to remove all the application access so deleting all application.
                      //because of the trigger respective permissions sets should get deleted.
                      if(buName=='De-Activate'){
                          List<IAM_Contact_Provisioning__c> toUpdate=new list<IAM_Contact_Provisioning__c>();
                          for(IAM_Contact_Provisioning__c conprov:con[0].Contact_Provisionings__r){
                              if(conprov.IAM_Status__c=='Active'){
                              conprov.IAM_Status__c='Inactive';
                              toUpdate.add(conProv);
                              }
                          }  
                          if(!toUpdate.isEmpty()){
                              update toUpdate;
                          }
                          //update con[0].Contact_Provisionings__r;
                      //delete con[0].Contact_Provisionings__r;
                      }
                      
                     return 'Ok'; 
                  }catch(exception ex){
                      string returnmessage=fieldCustomValidation(ex);
                      System.debug('Printing exception'+ex.getMessage());
                      /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnmessage = ex.getdmlMessage(0);
                      }
                      else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
                      }*/
                      return returnmessage;
                  }
              }else{
                  return 'No contact is Present';
              }
          }
          return 'Ctrical issue has happened please contact Administrator.';
      }
      
    //Function for Generating Service Agreement.
    @AuraEnabled
      Public static string generateCDA(id recordid,String buName){
          System.debug('Printing Record id and Button name'+ recordId +' '+buName );
          List<Account> accnt=new List<Account>();//Account variable to store account information
          List<IAM_Application__c> appDA=new List<IAM_Application__c>();//Account applicatino variable to store application information
          List<Contact> con= new List<Contact>();
          id accId;
          String ObjName=recordid.getSObjectType().getDescribe().getName();
          System.debug('Printing Object Name'+ObjName);
          try{
              if(ObjName=='Account'){     
              accnt=[Select id,Name,(select id,firstName,LastName,email from Contacts where CMI_Contact_Type__c='Primary'),(select id,IAM_Application_Name__c,IAM_Status__c,CMI_CDA_Status__c from Applications__r where IAM_Application_Name__c='Connected Solutions') from Account where id=:recordid ];
              accId=accnt[0].id;
              if(!accnt[0].Applications__r.isEmpty()){
              appDA[0]=accnt[0].Applications__r[0];
              }
              if(!accnt[0].Contacts.isEmpty()){
                  con[0]=accnt[0].Contacts[0];
              }
              
              }else if(ObjName=='IAM_Application__c'){
                  
                  System.debug('Entered Application Location part');
                  appDA=[SELECT id,IAM_Application_Name__c,IAM_Status__c,CMI_CDA_Status__c,IAM_Account_Name__c FROM IAM_Application__c where id=:recordid];
                  System.debug('Printing application name'+appDA);
                  accnt=[SELECT id,Name,(select id,firstName,LastName,email from Contacts where CMI_Contact_Type__c='Primary') FROM Account where id=:appDA[0].IAM_Account_Name__c];
                  accId=accnt[0].id;
                  System.debug('Printing account details'+accnt);
                  if(!accnt[0].contacts.isEmpty()){
                      System.debug('Printing contact details'+accnt[0].contacts);
                      con=accnt[0].Contacts;
                  }
              }        
          System.debug('Printing account details'+accnt);
          System.debug('Printing contact details'+con);
          System.debug('Printng application details'+appDA);
          if(!accnt.isEmpty()&&!con.isEmpty()&&!appDA.isEmpty()){
              //if(con[0].email!=null||con[0].email!=''){
              if(con[0].email!=null && con[0].email!=''){  //Code Scan Fix
                  String sendInfo=CMI_CompanyInformation.CalloutResponseContents(recordid,accId,appDA[0].IAM_Status__c,buName);
                      if(sendInfo=='OK'||sendInfo=='successfull.'){
                          String CDAGenerate=CMI_CdaHttpRest.send(recordid,accId,buName);
                          System.debug('Printing return values from CDA GEnerate class'+CDAGenerate);
                          if(CDAGenerate=='successfull.'||CDAGenerate=='OK'||CDAGenerate=='200'){
                              //Do not change the return value.Depending upon this Ctroller side script has functionality 
                              return 'CDA';
                          }else{
                              return CDAGenerate;
                          }
                      }else{
                          return sendInfo; 
                      }  
              }else{
                  return 'Primary Contact Email is Required.';
              }
              
          }else{
              return 'There is no Specific account with this Name or Id.';
          }        
          }catch(exception ex){
              string returnmessage=fieldCustomValidation(ex);
              /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnmessage = ex.getdmlMessage(0);
                  }
                  else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
                  }*/
              return returnmessage;
          } 
      } 
      
      //below function is for Generate user Id button
      @AuraEnabled
      Public static string generateUser(id recordid,string buName){
          Account accnt=[Select id,Name,CMI_CDA_Status__c,CMI_Primary_Contact_Email__c,CMI_Account_Status__c,IsCustomerPortal,CMI_Indemnified__c,CMI_Moratorium__c,CMI_Moratorium_End_Date__c,CMI_Moratorium_Start_Date__c,CMI_Request_withdrawn__c,Recordtype.Name from Account where id=:recordid];
         
          String  error='';
          if(accnt.IsCustomerPortal==True){
              error=error+'User Already Exists.\n';
          }else{
              error=IAM_AccountsController.validate(accnt);
          }
          if(error==''||error==null){
              if(accnt.CMI_Account_Status__c== 'Active-Indemnified'&&accnt.CMI_Moratorium_End_Date__c<date.today()&&accnt.CMI_Moratorium_End_Date__c!=null&&accnt.CMI_CDA_Status__c!='New Customer Request'&&accnt.CMI_Request_withdrawn__c==False&&accnt.CMI_Moratorium__c=='Yes'){
                 String generateUsr=CMI_clsGenerateUserIdOnAccount.generateUserId(recordid,'CMI_clsGenerateUserIdOnAccount');
                 return  generateUsr;
              }
          }               
          return error;
      }
      //this is for GenerateUser Id button validation
      @AuraEnabled
      public static string validate(account acc){
          String error='';
          
          if(acc.Recordtype.Name!='PC_API'){
              error=error+'RecordType of Account should be PC AP.\n';
          }
          if(acc.CMI_Account_Status__c!='Active-Indemnified'){
              error=error+'Account Status should be Active -Indemnified.\n';
          }
          if(acc.CMI_Moratorium_End_Date__c==null||acc.CMI_Moratorium_End_Date__c>=date.today()){
              error=error+'Moratorium End Date must be provided and must be less than today date.\n';
          }
          if(acc.CMI_CDA_Status__c=='New Customer Request'){
              error=error+'CDA Status cannot be New Customer Request.\n';
          }
          if(acc.CMI_Request_withdrawn__c!=False){
              error=error+'Request Withdrawn should be false.\n';
          }
          if(acc.CMI_Moratorium__c!='Yes' ){
              error=error+'Moratorium should be Yes.\n';
          }
        return error;
              
      }
      
      //Below function is for Contact object in order to activate contact.The same 
      //function will check if contact can be activated or not.
      @AuraEnabled 
      Public Static String ActivateContact(id recordid,string buName){
          //when Buttonis pressed first check for applicatins and Contact Status and depending upon that return display message.
          System.debug('Printing  Activate contactr enter');
          List<Contact> con=[select id,IAM_Legacy_User__c,IAM_Site_Admin__c,IAM_Site_Admin_Role__c,FirstName,LastName,Email,IAM_Internal__c,Account.OwnerId,Account.CMI_Account_Num__c,Phone,IAM_Contact_Status__c,IAM_Applications__c,IAM_Final_Approver__c,Username__c,IAM_Work_Group_Id__c,CMI_Contact_Type__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,Account.Location__c,Account.Recordtype.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_ABO_Code_Formula__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,Account.Type,Account.IAM_WWSPS_Regions__c,Account.IAM_Movex_Customer_Code__c,(select id,IAM_Application_Name__c,IAM_DA_Customer_List__c,IAM_RLS_Customer_Number__c, IAM_RLS_Group_Admin_Email__c,IAM_Role__c,IAM_Status__c,IAM_Active_Contact_Provisioning__c from Contact_Provisionings__r where IAM_Active_Contact_Provisioning__c=:recordid) from contact where id=:recordid Limit 1];
          
          System.debug('Printing contacct value in the activate con'+con);
          String ConStatus='';
          
          if(!con.isempty()&&buName=='Activate'){

               if(!Test.isRunningTest()){ 
              ConStatus = IAM_AccountsController.ConValue(con,buName);    
              }else if(Test.isRunningTest()){ 
                 ConStatus = '' ; 
              }
              System.debug('Printing ConStatus Value'+ConStatus);
              
              if(ConStatus == ''){
                  List<user> usr = [select id,isActive from user where contactid =: recordid];
                  if(!usr.isEmpty()){
                      if(usr[0].isActive == False){
                          //then simply update the user record to true
                          usr[0].isActive = True;
                          try{
                              update usr[0];
                              setpass(usr[0].id);
                              //need to call set password class to send password reset email
                              //setPassword(recordid,'Reset Password');   
                              return 'Success';
                          }catch(exception ex){
                              string returnmessage;
                              /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                                  returnmessage = ex.getdmlMessage(0);
                              }
                              else{
                                  returnmessage ='Something went wrong. Please contact System Administrator.';
                              }*/
                              //Commented By Karthik on 01/30/2021
                              return returnmessage=fieldCustomValidation(ex);
                          }    
                      }
                  }else{

                      //cAlling Another class to Create use record.
                      String Value=IAM_CreateUser.CreateUser(con);
                      System.debug('Printing return value for create user'+Value);
                      if(Value!='OK'){
                          return Value;
                      }else if(Value=='OK'){
                          return 'Success';
                      }

                  }               
              }else{
                  return ConStatus;
              }

          }
          if(!con.isempty()&&buName=='De-Activate'){
              //Login to deactivate User record.
              System.debug('Printing Contact Status'+con);
              if(con[0].IAM_Contact_Status__c == 'Active'){
                  List<user> u=[Select id,username,isActive,IAM_Deactivation_Mail_Sent__c,FederationIdentifier,IAM_UID__c from user where contactid=:con[0].id];
                  System.debug('Printing user record'+u);
                  if(!u.isEmpty()){
                      try{
                          u[0].isActive = false;
                          u[0].IAM_Applicationgroups__c = '';
                          u[0].IAM_Deactivation_Mail_Sent__c= true;
                          u[0].FederationIdentifier='';
                          //u[0].IAM_UID__c=u[0].FederationIdentifier;
                          update u;
                          //need to se if no error occurs.here

                          return 'Success';
                      }catch(exception ex){
                          string returnmessage;
                          /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                              returnmessage = ex.getdmlMessage(0);
                          }
                          else{
                              returnmessage ='Something went wrong. Please contact System Administrator.';
                          }*/
                          return returnmessage=fieldCustomValidation(ex);
                      }
                  }   
              }
              else{
                  return 'Contact is already in Inactive State';   
              }
              
          }
          return 'something went wrong please contact admin for support.';
      }
      
      @auraEnabled
      //this method is to deactivate multiple applications under single Contact.
      Public static string appDelete(id recordid, string buName,string rejectReason){
          list<IAM_Contact_Provisioning__c> lstToUpdateContactProvisioningRecord = new list<IAM_Contact_Provisioning__c>();
          List<Contact> Con= new List<contact>();
          if(Limits.getQueries()<Limits.getLimitQueries()){
          con=[select id,FirstName,IAM_Internal__c,LastName,Email,IAM_Contact_Status__c,Account.Recordtype.Name,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,(select id,IAM_Application_Name__c,IAM_DA_Customer_List__c,IAM_RLS_Customer_Number__c,IAM_Status__c,IAM_RLS_Group_Admin_Email__c,IAM_Role__c from Contact_Provisionings__r where IAM_Status__c='Active') from contact where id=:recordid Limit 1];
          }
          try{ 
              System.debug('Printing all the apps thta user has'+con);
              //Here instead of deletion need to update Application status to Inactive and then trigger must execute to remove permission sets
              for(IAM_Contact_Provisioning__c conp:con[0].Contact_Provisionings__r){
                  conp.IAM_Status__c='Inactive';
                  conp.Location_Change__c=True;
                  conp.IAM_Reject_Reason__c = rejectReason;
                  lstToUpdateContactProvisioningRecord.add(conp);
              }
              //update con[0].Contact_Provisionings__r;
              system.debug('=====lstToUpdateContactProvisioningRecord====='+lstToUpdateContactProvisioningRecord.size());
              system.debug('=====lstToUpdateContactProvisioningRecord records======'+lstToUpdateContactProvisioningRecord);
              system.debug('=====con===='+con);
              if(lstToUpdateContactProvisioningRecord.size()>0){
                  update lstToUpdateContactProvisioningRecord;
              }
              /* fix - Defect - D-2985
              if(con.size()>0){
                  con[0].IAM_Reject_Reason__c = rejectReason;
                  
                  update con;
              }*/
              //IAM_contactHelperClass.updateRejectReason(con[0].id,rejectReason);
              //Delete con[0].Contact_Provisionings__r;
              return 'Ok';
          }catch(exception ex){
                  string returnmessage=fieldCustomValidation(ex);
                  /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnmessage = ex.getdmlMessage(0);
                  }
                  else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
                  }*/
              return returnmessage;
          }
          
      }
      //checking Contact Status always.
      public static string ConValue(List <Contact> Con,String bName){
          String Error='';


          //for below condition to work we need to maku few changes in activate button login on account and after user creation we need to update contact.
          if(Con[0].IAM_Contact_Status__c=='Active'&&bName=='Activate'){
              Error=Error+'Contact is Already Active. If you want to add application please add in applications tab.\n';
          }

          if(Con[0].Account.CMI_Account_Status__c!='Active'&&bName=='Activate'){   
              Error=Error+'Customer/Account is Not active to Activate user.\n';
          }
          
          // remove error message as a feedback/fix
          /*if(bName=='Activate'){
              if(Con[0].Contact_Provisionings__r.isEmpty()){
                  Error=Error+'Please Add Proper Application for user to get access.\n';
              }
          }*/

          if(Con[0].IAM_Contact_Status__c=='Inactive'&&bName=='DeActivate'){
              Error=Error+'Contact is already inactive.\n';
          }        
          return Error;
      } 
      
      @AuraEnabled
      Public static String setPassword(id recordid,string buName){
          System.debug('Printing button name'+buName);
          List<user> u=[Select id,name from user where contactid=:recordid];
          
          if(!u.isEmpty()){
              UserLogin usr=[SELECT IsPasswordLocked FROM UserLogin WHERE UserId =:u[0].id];
              if(buName=='Reset Password'){
                  //fixed - D-2880 - when user reset password then only reset password email should be send instead of registration processed
                  resetPasswordUser(u[0].id);
                  //setpass(u[0].id);
                  return 'Password reset link is sent to your email.';
              }
              if(buName=='Unlock'){ 
                  try{
                      usr.IsPasswordLocked=false;
                     update usr; 
                     return 'User unlocked successfully ';
                  }catch(Exception ex){
                      string returnmessage=fieldCustomValidation(ex);
                      /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                          returnmessage = ex.getdmlMessage(0);
                      }
                      else{
                          returnmessage ='Something went wrong. Please contact System Administrator.';
                      }*/
                      return returnmessage;
                  }
                 
              } 
          }
          return 'there is a issue.Please contact system administrator.';
      }
      
      @AuraEnabled
      //below method is to deactivate a single Application record.
      public static String AppDeleteSingle(id recordid,string rejectReason,string rejectcomments){
          IAM_Contact_Provisioning__c c=[select id, IAM_Assigned_Units__c, IAM_Remaining_Units__c,IAM_Account_Application__r.IAM_Source__c,IAM_Account_Application__r.OSM_Max_Allowed_Users__c,IAM_Status__c,IAM_Account_Application__c,IAM_Account_Application__r.IAM_Provisioned_User_Count__c,IAM_Account_Application__r.IAM_Subscription_Count__c  from IAM_Contact_Provisioning__c where id=:recordid];
          if(c.IAM_Status__c=='Active'){
                if(c.IAM_Assigned_Units__c != null && c.IAM_Remaining_Units__c !=null 
                && c.IAM_Assigned_Units__c != 0 && c.IAM_Remaining_Units__c != 0
                && c.IAM_Assigned_Units__c > c.IAM_Remaining_Units__c) {
                    return Label.IAM_UnitsUserSubCannotDeactivate;
                } else if(c.IAM_Assigned_Units__c != null && c.IAM_Remaining_Units__c !=null 
                && c.IAM_Assigned_Units__c != 0 && c.IAM_Remaining_Units__c != 0
                && c.IAM_Assigned_Units__c == c.IAM_Remaining_Units__c) {
                    c.IAM_Assigned_Units__c = 0;
                }
              system.debug('Update the value of the record ');
              c.IAM_Status__c='Inactive';
              c.IAM_Reject_Reason__c = rejectReason;
              c.IAM_Reason__c = rejectcomments;
              
              //insert end date and increase and decrease of count on deactivation
            
            //Need to uncomment back  
          c.IAM_End_Date__c=date.today();
          
          //IAM_Application__c  App=new IAM_Application__c(id=c.IAM_Account_Application__c);
          
          IAM_Application__c  App = [SELECT Id,Name,IAM_Subscription_Count__c,IAM_Provisioned_User_Count__c FROM IAM_Application__c WHERE Id =: c.IAM_Account_Application__c];           
          
          
          /*if(app.IAM_Subscription_Count__c!=null){
              system.debug('===Inside if app.IAM_Subscription_Count__c===');
              app.IAM_Subscription_Count__c=c.IAM_Account_Application__r.IAM_Subscription_Count__c+1;
          }
          if(app.IAM_Provisioned_User_Count__c!=null){ 
              system.debug('====Inside if app.IAM_Provisioned_User_Count__c====');
              app.IAM_Provisioned_User_Count__c=c.IAM_Account_Application__r.IAM_Provisioned_User_Count__c-1;
          }*/
          
          
          try{
              update c;
              //IAM_contactHelperClass.updateRejectReason(c.id,rejectReason);
              System.debug('Printing value of updated record'+c);
              system.debug('=====value of app=========='+app);
              Update app;
              return 'Ok';
          }catch(exception ex){
              string returnmessage=fieldCustomValidation(ex);
              /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                  returnmessage = ex.getdmlMessage(0);
              }
              else{
                  returnmessage ='Something went wrong. Please contact System Administrator.';
              }*/
              return returnmessage;   
          }
          }else{
              //This tells us that  application status is Inactive and proper message should be Displayed
            return 'Application already in Inactive State.';  
          }    
      }
      
      
      @AuraEnabled
      Public Static List<String> GetSubcriptionNames(id recordid,String type){  
          //we are calling below class to apply sharing rules so that User may assaign only apps related to his application only.
         //Karthik Vemula changes start for 97 UAT issue
         List<String> options= new List<String>();
         User currentUser = [select id,Profile.name from user where id=:userinfo.getuserId() limit 1];
         if(currentUser.Profile.name == 'IAM_Site_Admin_Community'||currentUser.Profile.name == 'IAM User') {
         //Class without sharing
          options=IAM_getSubscriptionNameswithout.SubscriptionNames(recordid,type);
         } else {
         //Class with sharing
         options=IAM_getSubscriptionNames.SubscriptionNames(recordid,type);
         } //Karthik changes end for 97 UAT issue
          return options;
      }

      //Method to get application names
      /*@AuraEnabled
      Public Static List<String> getApplicationNames(id recordid,String selectedVal){
          List<String> optionsApp;
          List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
         
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Subscription_Name__c=:selectedVal];
          System.debug('Printing application names'+App);
          if(!App.isEmpty()){ 
          Set<String> Applications=new set<String>();
          for(IAM_Application__c ap:App){
              if(ap.IAM_Free_Subscription__c==false){
              Applications.add(ap.IAM_Application_Name__c);
              }
          }
          optionsApp =new List<String>(Applications);//Final list of applications that need to be return to the function.
              
          }else{
              optionsApp.add('No Applications are Present in the System');
          }
          return optionsApp;
      }*/
     //Below class needs to be used to display all the applications at once and then perform necessary actions. 
      @AuraEnabled
      Public Static Map<String,List<String>> getApplicationNames(id recordid,String selectedVal){
          Map<string,List<String>>appMap=new Map<String,List<String>>();
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          List<String> roleNames;//List to hold one set of applications and then add them to maps
          List<Contact> con=[Select id,Accountid,IAM_Internal__c  from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          List<Contact> cont=[Select id,IAM_Internal__c,Accountid from Contact where id=:recordid];
          if(!cont.isEmpty()){
           Account acc=[Select id, Type from Account where id=:con[0].AccountId];  // D-2818 start
        //if(appNames.contains('QuickServe Online') && (con[0].IAM_Internal__c==true || acc.Type=='Individual'))
         if(appNames.contains('QuickServe Online') && (acc.Type=='Internal' || acc.Type=='Individual'))
          {
              appNames.remove('QuickServe Online');
          }
           //  if(appNames.contains('Guidanz Mobile') && (cont[0].IAM_Internal__c==true || acc.Type=='Individual'))
          if(appNames.contains('Guidanz Mobile') && (acc.Type=='Internal' || acc.Type=='Individual'))
           {
              appNames.remove('Guidanz Mobile');
          }
          }
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Subscription_Name__c=:selectedVal AND IAM_Status__c='Active' AND IAM_Application_Name__c IN :appNames];
          System.debug('Printing application names'+App);
          roleNames=new List<String>();
          if(!App.isEmpty()){ 
          Set<String> Applications=new set<String>();
          for(IAM_Application__c ap:App){
              if(ap.IAM_Free_Subscription__c==false){
              Applications.add(ap.IAM_Application_Name__c);
              }
          }
          List<String> optionsApp =new List<String>(Applications);
          
          //Code logic to get IDM Role to display in the new layout
         System.debug('Printing application names with free checkbox as false'+optionsApp);
         
          for(integer i=0;i<optionsApp.size();i++){
              roleNames=new List<String>();
              for (IAM_Application__c app2:App){
                  if(optionsApp[i]==app2.IAM_Application_Name__c){
                      roleNames=app2.IAM_Role__c.split(';');
                  }
              }
              System.debug('Printing map values');
              System.debug('Printing application name'+optionsApp[i]);
              System.debug('Printing rolenames to be displayed for account'+roleNames);
              appMap.put(optionsApp[i],roleNames);
          }}
          else{
              roleNames.add('List has no values to display');
              appMap.put('NoValue',roleNames);
          } 
          return appMap;
      }
      
      @AuraEnabled
      Public Static map<String,List<String>> getModularandRole(id recordid,String selectedApp){
           map<String,List<string>> optionsRole=new map<string,List<string>>();
          List<String> modularName=new List<String>();
          List<String> roleNames=new List<string>();
          List<String> roles= new List<String>();
          List<String> error=new List<string>();
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          try{
          
          List<Contact> Con= new List<Contact>();
          if(Limits.getQueries()<Limits.getLimitQueries()){
          con=[Select id,Accountid from Contact where id=:recordid];
          }
          System.debug('Printing Contacct names'+con);
          
          List<IAM_Application__c> App= new List<IAM_Application__c>();
          if(Limits.getQueries()<Limits.getLimitQueries()){
          App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Cumpas_Modularity__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
          }
          System.debug('Printing application names'+App);
          if(!App.isempty()){
              if(!String.isEmpty(App[0].IAM_Cumpas_Modularity__c)){
                  modularName=App[0].IAM_Cumpas_Modularity__c.split(';');
              }
              if(!String.isEmpty(App[0].IAM_Role__c)){
                  roles=App[0].IAM_Role__c.split(';');
              }
          }
          System.debug('Printing modular and Roles lists'+modularName);
          System.debug('Printing Role Names'+roles);
          if(!modularName.isEmpty()&&!roles.isEmpty()){
              System.debug('Both are not empty');
              optionsRole.put('modular',modularName);
              error.add('No Error');
              optionsRole.put('error',error);
              optionsRole.put('roles',roles);
          }else if(modularName.isEmpty()&&!roles.isEmpty()){
              System.debug('Printing modularity is empty');
              error.add('No Modular access defined at Account/Location level.');
              
          }else if(roles.isEmpty()&&!modularName.isEmpty()){
            error.add('No Roles are defined at Account/Location level.');  
              System.debug('Printing Roles is empty');
          }
           System.debug('Printing map of roles and modularity'+optionsRole);   
              if(!error.isEmpty()){
                  optionsRole.put('error',error);
              }
          }catch(exception e){
              system.debug('Printing exception'+e.getStackTraceString());
              System.debug('Printing exception messgae'+e.getMessage());
              optionsRole.put('error',error);
          }
          System.debug('Printing optionRole'+optionsRole);
          return optionsRole;
       }
      
      @AuraEnabled
      public Static string saveFreeApp(id recordid,map<String,String> App,String appName){
          System.debug('App.....123... '+App);
          System.debug('appName.....123... '+appName);
          string finalValue=IAM_ApplicationSave.saveFreeApplication(recordid,App,appName);
          System.debug('finalValue.....123... '+finalValue);
          return finalValue;
      }
     
      @AuraEnabled
      public Static string saveFreeAppCumpas(id recordid,map<String,String> App,String appName,List<String> modularity,List<String> rolesNames){
          string finalValue=IAM_ApplicationSave.saveFreeApplicationCumpass(recordid,App,appName,modularity,rolesNames);
          return finalValue;
      }
  
      @AuraEnabled
      Public Static String saveApplication(id recordid,map<String,String> appInfo){
          String finalValue=IAM_ApplicationSave.saveSubApplication(recordid,appInfo);
          return finalValue;
      }
      
      @future
      Public static void setpass(id userid){
          List<User> u=[Select id,isActive from User where id=:userid];   
          if(u[0].isActive){  
          System.resetPassword(userid,true);  
          }
      }
      
      @AuraEnabled
      public Static String deactivateAccountSub(id recordId,string rejectReason,string rejectcomments){
        String returnString;
        try{
        List<IAM_Application__c> app=[select id,IAM_Status__c,IAM_Application_Name__c, IAM_Assigned_Units__c,IAM_Subscription_Name__c,IAM_Account_Name__c,(select id,IAM_Status__c from Contact_Provisionings__r) from IAM_Application__c where id=:recordId];
        if(!app.isEmpty()){
            //Checking app Status in for validation
            if(app[0].IAM_Status__c=='Inactive'){
                returnString='Cannot Inactivate Subscription.It is already in Inactive State.';
            }else{
                //Method ot check connected solutions
                if(app[0].IAM_Application_Name__c=='Connected Solutions'){
                    //calling Send to PC for sending Deactivae.
                    String sendInfo=CMI_CompanyInformation.CalloutResponseContents(recordid,app[0].IAM_Account_Name__c,'Inactive','De-Activate');
                    if(sendInfo=='successfull.'||sendInfo=='OK'){
                        returnString=deactivateConProvisionings(app[0],rejectReason,rejectcomments);  
                    }else{
                        returnString=sendInfo;
                    }
                }else if((app[0].IAM_Application_Name__c == Label.IAM_AppName_guidanzmobile 
                || app[0].IAM_Application_Name__c == Label.IAM_App_GuidanzMobileFieldTest)
                && app[0].IAM_Subscription_Name__c.containsIgnoreCase('Units')
                && app[0].IAM_Assigned_Units__c > 0) {
                    return Label.IAM_UnitsLocationSubCannotDeactivate;
                } else {
                    //Simply call below deactivation method an return the same values
                    returnString=deactivateConProvisionings(app[0],rejectReason,rejectcomments);
                }
            }
      }else{
          returnString='Something unexpected happened, please contact support for help.';
      }
     }catch(exception ex){
              System.debug('Printing Exception message'+ex.getMessage());
              /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnString = ex.getdmlMessage(0);
              }
              else{
                      returnString ='Something went wrong. Please contact System Administrator.';
              }*/
            returnString=fieldCustomValidation(ex);   
         }
          
          return returnString;
      }
   
    //Creating contactprovisioning record for each app selected
  public static String deactivateConProvisionings(IAM_Application__c app,string rejectReason,string rejectcomments){
      String returnVariable='';
      try{
          //Update all child record status to inacitve.
                          for(IAM_Contact_Provisioning__c c:app.Contact_Provisionings__r){
                              c.IAM_Status__c='Inactive';
                              c.IAM_Reject_Reason__c = rejectReason;
                              c.IAM_Reason__c  = rejectcomments;
                          }
                          update app.Contact_Provisionings__r;
                          //Updating parent status to inactive
                          app.IAM_Status__c='Inactive';
                          app.IAM_Reject_Reason__c = rejectReason;
                          app.IAM_Reason__c = rejectcomments;
                          update app;
                          //IAM_contactHelperClass.updateRejectReason(app.id,rejectReason);
                          returnVariable='OK';
      }catch(exception ex){
          System.debug('Printing exception'+ex.getStackTraceString());
         /* if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                  returnVariable = ex.getdmlMessage(0);
          }
          else{
              returnVariable ='Something went wrong. Please contact System Administrator.';
          }*/
          returnVariable=fieldCustomValidation(ex);
      }
      return returnVariable;
  }
   
   //Creating contactprovisioning record for each app selected

   @AuraEnabled   
      public static string ProcessSubscriptionAppRec(String Conid,String SelectedSubscription,List<String> SelectedApps,map<String,List<String>> applicationMap, Integer assignedCount)
  {
  
  //Karthik Reddy
  System.debug('Printing all the values in the function'+Conid+'selected sub'+SelectedSubscription+'selected apps'+SelectedApps);
  System.debug('Printing pp map'+applicationMap);
  System.debug('Printing pp map key set'+applicationMap.keySet());
  Boolean creation=false;
  try{
    Set<String> appNames=new Set<String>();
    Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
    if(!appsCanBeAssigned.isEmpty()){
        appNames=appsCanBeAssigned.KeySet();    
    }
    //Karthik changes start for 97 UAT issue
    Boolean isCreateApp = true;
    List < Contact > Con= new List<Contact>();
    if(Limits.getQueries()<Limits.getLimitQueries()){
        Con = [Select AccountId,ownerid,owner.Isactive,IAM_legacy_user__c,IAM_Contact_Status__c,IAM_Internal__c,Username__c from contact where id =: conid];
    }
    String ServiceId;
    string EDSapp ='';
    for(string ss : applicationMap.keySet()) {
        if(ss == 'EDS') {
            EDSapp = ss;
        } 
        if(ss=='IAM_Promotion__c') {
            ServiceId=applicationMap.get(ss)[0];
        }
    }
    if(EDSapp == 'EDS') {
        System.debug('Printing pp EDS'+EDSapp);

        List<IAM_Application__c> QSOLapps= new List<IAM_Application__c>();
        if(Limits.getQueries()<Limits.getLimitQueries()){
            QSOLapps = [select id,IAM_Role__c ,IAM_Subscription_Name__c,IAM_Status__c, IAM_Application_Name__c from IAM_Application__c where  IAM_Account_Name__c =: Con[0].AccountId and IAM_Application_Name__c = 'QuickServe Online' AND IAM_Status__c = 'Active'];
        }
        System.debug('Printing Account QSOL'+QSOLapps);
        if(QSOLapps.isEmpty() && QSOLapps.size() == 0) {
            //isCreateApp = false;
            //return 'User must have QSOL application before assigning EDS access';
        }
    }
    //Karthik changes end for 97 UAT issue
    List < IAM_Contact_Provisioning__c > CPtoinsert = new list < IAM_Contact_Provisioning__c > ();
    List < String > SelectedSubscriptionAppList = new List < string > ();
    Map < String, IAM_Application__c > AppNameMap = new Map < string, IAM_Application__c > ();

    if(isCreateApp) { //Karthik changes start for 97 UAT issue 

        for (String x: SelectedApps) {
            x = x.normalizespace();
            SelectedSubscriptionAppList.add(x);
        }
  
        // pulling info of Apps selected
        //Need to add IDM_Subscription_End_Date again the query
        if(Limits.getQueries()<Limits.getLimitQueries()){
            for (IAM_Application__c CMIapp: [select id, IAM_Remaining_Units__c,IAM_Source__c,OSM_Max_Allowed_Users__c,IAM_Subscription_Count__c,IAM_Subscription_Name__c,IAM_Qsolexpiration__c,IAM_License_Type__c,IAM_swregExpire__c,IAM_Subscription_End_Date__c,IAM_Provisioned_User_Count__c,IAM_Provisioned_Count__c,IAM_Role__c ,IAM_Free_Subscription__c, IAM_Status__c,IAM_Subscription_Start_Date__c, IAM_Application_Name__c from IAM_Application__c where  IAM_Account_Name__c =: Con[0].AccountId and IAM_Subscription_Name__c=:SelectedSubscription AND IAM_Application_Name__c IN :appNames AND IAM_Status__c = 'Active']) {
                
                AppNameMap.put(CMIapp.IAM_Application_Name__c, CMIapp);
            }
        }   
        //Instantiating contactprovisioning record for each app selected
        for (String app: AppNameMap.keyset()) {
            if(applicationMap.ContainsKey(app)){
                system.debug('=======AppNameMap.get(app).IAM_Source__c========='+AppNameMap.get(app).IAM_Source__c);
                system.debug('=======AppNameMap.get(app).OSM_Max_Allowed_Users__c=='+AppNameMap.get(app).OSM_Max_Allowed_Users__c);
                system.debug('=======AppNameMap.get(app).IAM_Provisioned_User_Count__c======'+AppNameMap.get(app).IAM_Provisioned_User_Count__c);
                system.debug('======AppNameMap.get(app).IAM_Subscription_Count__c==='+AppNameMap.get(app).IAM_Subscription_Count__c);
                
                String subName = AppNameMap.get(app).IAM_Subscription_Name__c;
                if((String.isNotBlank(AppNameMap.get(app).IAM_Source__c) 
                    && AppNameMap.get(app).IAM_Source__c == 'Marketplace' 
                    && AppNameMap.get(app).OSM_Max_Allowed_Users__c!= 0 
                    && AppNameMap.get(app).OSM_Max_Allowed_Users__c != AppNameMap.get(app).IAM_Provisioned_Count__c) 
                    || (((String.isNotBlank(AppNameMap.get(app).IAM_Source__c) 
                    && AppNameMap.get(app).IAM_Source__c != 'Marketplace') 
                    || (String.isBlank(AppNameMap.get(app).IAM_Source__c))) 
                    && AppNameMap.get(app).IAM_Subscription_Count__c!= 0 
                    && AppNameMap.get(app).IAM_Subscription_Count__c!=AppNameMap.get(app).IAM_Provisioned_Count__c)
                    || (subName.equalsIgnoreCase(Label.IAM_GuidanzMobileFleetCount) 
                    || subName.equalsIgnoreCase(Label.IAM_GuidanzMobileZapitCount) 
                    || subName.equalsIgnoreCase(Label.IAM_GuidanzMobileZapitOEMCount))){
                    
                    if(assignedCount != null && assignedCount <= 0) {
                        return Label.IAM_EnterValidUnits;
                    }
                    if(assignedCount != null && assignedCount > AppNameMap.get(app).IAM_Remaining_Units__c) {
                        return Label.IAM_InsufficientUnits;
                    }
                    IAM_Contact_Provisioning__c ICP = new IAM_Contact_Provisioning__c();
                    ICP.IAM_Contact__c = conid;
                    ICP.IAM_userId__c=con[0].Username__c;                  
              
                    //ICP.IAM_Start_Date__c = AppNameMap.get(app).IAM_Subscription_Start_Date__c;
                    ICP.IAM_Start_Date__c=System.today();
                    if(AppNameMap.get(app).IAM_Free_Subscription__c==false) {
                        //Need t o uncomment the below line
                        ICP.IAM_End_Date__c = AppNameMap.get(app).IAM_Subscription_End_Date__c;
                    }
              
                    System.debug('Printing application NAme 757'+AppNameMap.get(app).IAM_Application_Name__c);    
                    if(AppNameMap.get(app).IAM_Application_Name__c!=null)
                        System.debug('role name'+string.Valueof(applicationMap.get(AppNameMap.get(app).IAM_Application_Name__c.normalizeSpace())).replace(',',';'));
              
                    ICP.IAM_Application_Name__c = AppNameMap.get(app).IAM_Application_Name__c.normalizeSpace();
                    if(ServiceId!='' && ServiceId!=null && ICP.IAM_Application_Name__c=='Cummins Service Training') { 
                        ICP.IAM_Promotion__c =ServiceId;
                    }
              
                    System.debug('Prinitng application Service training Id'+ICP.IAM_Promotion__c );
                    System.debug('Printing service traiing Id'+ServiceId);
                    ICP.IAM_Account_Application__c = AppNameMap.get(app).Id;
                    if(AppNameMap.get(app).IAM_Role__c!=null)
                        ICP.IAM_Role__c=(string.Valueof(applicationMap.get(AppNameMap.get(app).IAM_Application_Name__c.normalizeSpace())).replace(',',';')).replace('(','').replace(')','').normalizeSpace();
                        if(con[0].IAM_Contact_Status__c=='Active'){
                            System.debug('Entered contact Active Status');
                            List<user> usr=[select id from user where Contactid=:conid and isActive=True LIMIT 1];
                            if(!usr.isEmpty()){
                                ICP.IAM_User__c=usr[0].id;
                                ICP.IAM_Status__c = 'Active';
                            } else if(con[0].IAM_Internal__c==True ){
                                ICP.IAM_Status__c = 'Active';
                            } else if (con[0].IAM_legacy_user__c==true && con[0].IAM_Internal__c==false){
                                //update status to pending for user feature record creation for Reclaim contacts - @Anupam
                                ICP.IAM_Status__c = 'Active';
                            }
                            system.debug('ICP.IAM_Status__c'+ICP.IAM_Status__c);                    
                        }else if(con[0].IAM_Contact_Status__c=='Reclaim'){
                            System.debug('Entered contact Reclaim Status');
                            List<user> usr=[select id from user where Contactid=:conid and isActive=True LIMIT 1];
                            if(!usr.isEmpty()){
                                ICP.IAM_User__c=usr[0].id;
                                ICP.IAM_Status__c = 'Active';
                            } else if(con[0].IAM_Internal__c==True ){
                                ICP.IAM_Status__c = 'Active';
                            } else if (con[0].IAM_legacy_user__c==true && con[0].IAM_Internal__c==false){
                                //update status to pending for user feature record creation for Reclaim contacts - @Anupam
                                ICP.IAM_Status__c = 'Pending';
                            }                        
                        }else{
                            ICP.IAM_Status__c = 'Pending';
                        }                       
                    //ICP.IAM_User__c=con[0].ownerid;
                    if(AppNameMap.get(app).IAM_Subscription_Name__c!=null&&AppNameMap.get(app).IAM_Subscription_Name__c!='')
                        ICP.IAM_Subscription_Name__c=AppNameMap.get(app).IAM_Subscription_Name__c;
                    System.debug('Printing application name before record id'+AppNameMap.get(app).IAM_Application_Name__c);
                    if(AppNameMap.get(app).IAM_Application_Name__c!=null)
                        ICP.recordtypeid=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(AppNameMap.get(app).IAM_Application_Name__c.normalizeSpace()).getRecordTypeId();
                    System.debug('Printing record id that is going to insert'+ICP.recordtypeid);
                    
                    if(AppNameMap.get(app).IAM_Application_Name__c!=null && AppNameMap.get(app).IAM_Application_Name__c==System.Label.IAM_AppName_QSOL) {
                        ICP.IAM_Qsolexpiration__c=AppNameMap.get(app).IAM_Qsolexpiration__c;
                        ICP.IAM_License_Type__c=AppNameMap.get(app).IAM_License_Type__c;
                    }
                    if(AppNameMap.get(app).IAM_Application_Name__c!=null && AppNameMap.get(app).IAM_Application_Name__c==System.Label.IAM_AppName_guidanzmobile) {
                        ICP.IAM_Assigned_Units__c = assignedCount;
                        ICP.IAM_Remaining_Units__c = assignedCount;
                        ICP.IAM_swregExpire__c=AppNameMap.get(app).IAM_swregExpire__c;
                        if(AppNameMap.get(app).IAM_Role__c!=null)
                            ICP.IAM_Guidanz_Mobile_Roles__c=(string.Valueof(applicationMap.get(AppNameMap.get(app).IAM_Application_Name__c.normalizeSpace())).replace(',',';')).replace('(','').replace(')','').normalizeSpace();
                    }
                    ICP.IAM_Source__c = AppNameMap.get(app).IAM_Source__c;
                    //below changes added to insert QSOL first and then EDS - @Anupam Priority Backlogs
                    if(AppNameMap.get(app).IAM_Application_Name__c==System.Label.IAM_AppName_QSOL){
                        if(CPtoinsert.isEmpty()){
                            CPtoinsert.add(ICP);
                        }else{
                            CPtoinsert.add(0,ICP);
                        }                        
                    }else{
                        CPtoinsert.add(ICP);
                    }
                    //CPtoinsert.add(ICP);
                    //code to increase and decrease the counts on subscribed app insertion
                    /*if(AppNameMap.get(app).IAM_Source__c == 'Marketplace'){
                        //AppNameMap.get(app).IAM_Subscription_Count__c=AppNameMap.get(app).IAM_Subscription_Count__c-1;=AppNameMap.get(app).OSM_Max_Allowed_Users__c-1;
                        AppNameMap.get(app).IAM_Provisioned_User_Count__c = AppNameMap.get(app).IAM_Provisioned_User_Count__c+1;    
                        AppNameMap.get(app).IAM_Subscription_Count__c = AppNameMap.get(app).OSM_Max_Allowed_Users__c - AppNameMap.get(app).IAM_Provisioned_User_Count__c;
                    } else{
                        AppNameMap.get(app).IAM_Subscription_Count__c=AppNameMap.get(app).IAM_Subscription_Count__c-1;
                        AppNameMap.get(app).IAM_Provisioned_User_Count__c= AppNameMap.get(app).IAM_Provisioned_User_Count__c+1;
                    }*/                  
                }
            }
        }
    } //Karthik  Vemula changes end for 97 UAT issue
    System.debug('Printing size of the cpto insert'+CPtoinsert.size()); 
    String myMsg ='';
    List<String> sss = new List<String>();
    if (CPtoinsert.size() > 0) {
        system.debug(CPtoinsert);
        //  insert CPtoinsert;
        //Using below code, in order to ignore any exception, if assiging app for multi app and any of them already assigned
        Database.SaveResult[] lstSR2 = Database.insert(CPtoinsert, false);
        myMsg=databaseErrorString(lstSR2);
        creation=dataBaseSaveSuccessValue(lstSR2);
        /*for (Database.SaveResult sr : lstSR2) {
            if (sr.isSuccess()) {
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            } else {              
                for(Database.Error err : sr.getErrors()) {
                    myMsg=err.getMessage();
                    if (err instanceof Database.DuplicateError) {
                        myMsg='';
                        myMsg=System.Label.IAM_Existing_Provisioning_Error;
                        Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                        Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                        Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                        Datacloud.MatchResult matchResult = matchResults[0];

                        Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                        for (Datacloud.MatchRecord matchRecord : matchRecords) {
                            System.debug('MatchRecord: ' + matchRecord.getRecord());
                            sss.add(matchRecord.getRecord().Id);
                        }
                    }
                    if(!sss.isEmpty() && sss!=null) {
                        if(Limits.getQueries()<Limits.getLimitQueries()){   
                            IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                            //myMsg=conP.IAM_Application_Name__c + ' : '+myMsg;
                            myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                        }
                    }
                    System.debug('===myMsg==='+myMsg);
                }
            }
        } */  
        System.debug('Return Value from error message'+myMsg);
        System.debug('Printing Success message from method'+creation);

        update AppNameMap.values();
        system.debug('=====After update==AppNameMap======'+AppNameMap);
        if(myMsg!='' && myMsg!=null&&!Creation){ 
            return myMsg;
        } else {
            return 'Record Created'; 
        }
    } else {
        return 'No insert was possible';
    }

  }catch(Exception ex){
      //Amarnath Mishra added for the customize error message.
      string returnString;
      System.debug('Printing exceptions e'+ex.getMessage());
      System.debug('Printing exceptions e stack strace'+ex.getStackTraceString());
       if(ex.getMessage().contains('first error: DUPLICATES_DETECTED')){
              returnString=System.Label.IAM_Existing_Provisioning_Error;
          }
          else{
              returnString=fieldCustomValidation(ex);
             /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                  returnString = ex.getdmlMessage(0);
              }
              else{
                  returnString ='Something went wrong. Please contact System Administrator.';
              }*/
          }
      return returnString;
  }
  }
  
  
  //Below method is to set the regions value to the picklist.
  @AuraEnabled 
  Public static List<String> wrkGrpRegions(id recordId){
     system.debug('Printing workgrop regions...');
     //fix of issue#209 user should be see those location which he has access to
     List<String> returnList = IAM_getSubscriptionNames.getwrkGrpRegions(recordId);
     return returnList;
  }
  
  //Below method is to get the assigned work group in the contact
  @AuraEnabled 
  Public static List<Account> getAssignedWorkGroup(id recordId){
      system.debug('Printing getAssignedWorkGroup recordId...' + recordId);
      List<Contact> lstContact = [select IAM_Work_Group_Id__c from contact where id =: recordId];
      system.debug('Printing getAssignedWorkGroup lstContact...' + lstContact);
      String wrkGroup = null;
      List<String> wrkGrpId = new List<String>();
      List<String> lstwrkGrpId = new List<String>();
      for(Contact con : lstContact)
          wrkGroup = con.IAM_Work_Group_Id__c;
      system.debug('Printing getAssignedWorkGroup wrkGroup...' + wrkGroup);   
      if(null != wrkGroup){
          wrkGrpId = wrkGroup.split('\\|');
          System.debug('Prinitng wrkGrpId values... ' + wrkGrpId);
          for(String wrkgrp : wrkGrpId){
              if(!wrkGrp.contains('-P')) // remove workgroupid button should not remove primary location - Pratima
              {lstwrkGrpId.add(wrkgrp.substring(0,wrkgrp.length()-2));
              system.debug('##'+wrkGrp);
              }
          } 
          system.debug('Printing getAssignedWorkGroup lstwrkGrpId...' + lstwrkGrpId);
      }
          
      return [select Account.Name,Account.Location__c,Type from account where Location__c in: lstwrkGrpId];
  }
  
  //Below method is the copy of above, just the diff is it will return the Primary wrkgrp as well Defect-3122
   @AuraEnabled 
  Public static List<Account> getAllAssignedWorkGroup(id recordId){
      system.debug('Printing getAssignedWorkGroup recordId...' + recordId);
      List<Contact> lstContact = [select IAM_Work_Group_Id__c from contact where id =: recordId];
      system.debug('Printing getAssignedWorkGroup lstContact...' + lstContact);
      String wrkGroup = null;
      List<String> wrkGrpId = new List<String>();
      List<String> lstwrkGrpId = new List<String>();
      for(Contact con : lstContact)
          wrkGroup = con.IAM_Work_Group_Id__c;
      system.debug('Printing getAssignedWorkGroup wrkGroup...' + wrkGroup);   
      if(null != wrkGroup){
          wrkGrpId = wrkGroup.split('\\|');
          System.debug('Prinitng wrkGrpId values... ' + wrkGrpId);
          for(String wrkgrp : wrkGrpId){
              lstwrkGrpId.add(wrkgrp.substring(0,wrkgrp.length()-2));
              system.debug('##'+wrkGrp);
              } 
          system.debug('Printing getAssignedWorkGroup lstwrkGrpId...' + lstwrkGrpId);
      }
          
      return [select Account.Name,Account.Location__c,Type from account where Location__c in: lstwrkGrpId];
  }
  
  
  //Below method is to set the Primary location value to the work group popup.
  //Edited by Amarnath Mishra for the UAT Issue# D-2751
  @AuraEnabled 
  Public static Map<String,String> getPrimaryLocation(id recordId){
      Map<string,string>mapAllAccountsPrimryLocation=new Map<string,string>();
      list <string> lstprimaryLocation = new list<string>();
      list<Account> lstAccount = new list<Account>();
      list <string> allAccounts = new list<string>();
      string allSelectedAccount;
      string formatlocation;
      system.debug('Printing workgrop regions..recordId... ' + recordId);
      String primaryLocation ='';
      //fix of issue#209 user should be see those location which he has access to
      List<Contact> lstCont = [SELECT Account.Location__c FROM Contact WHERE id=:recordId];
      system.debug('Printing workgrop regions..lstCont... ' + lstCont);
      if(null != lstCont && lstCont.size() > 0)
          primaryLocation = lstCont[0].Account.Location__c + '-P';
      system.debug('Printing workgrop regions..primaryLocation... ' + primaryLocation);        
      //return primaryLocation;
      lstprimaryLocation.add(primaryLocation);
      lstAccount = getAssignedWorkGroup(recordId);
      system.debug('====lstAccount=='+lstAccount);
      for(Account acc:lstAccount){
          if(String.isNotBlank(allSelectedAccount)){
              formatlocation = acc.Location__c;
              //fix -Defect - D-3026 - secondary workgorup id should have - 
              //formatlocation = formatlocation.remove('-');
              formatlocation = formatlocation+'-S';
              allSelectedAccount = allSelectedAccount +' | '+formatlocation;
          }
          else{
              formatlocation = acc.Location__c;
              //fix -Defect - D-3026 - secondary workgorup id should have - 
              //formatlocation = formatlocation.remove('-');
              formatlocation = formatlocation+'-S';
              allSelectedAccount = formatlocation;
          }
      }
      //allSelectedAccount = String.valueOf(lstAccount);
      system.debug('====allSelectedAccount=='+allSelectedAccount);
      //allAccounts.add(allSelectedAccount);
      system.debug('===allAccounts==='+allAccounts);
      mapAllAccountsPrimryLocation.put('primaryLocation',primaryLocation);
      mapAllAccountsPrimryLocation.put('allAccounts',allSelectedAccount);
      return mapAllAccountsPrimryLocation;
  }
  
  //Below method is to get the location type value to the picklist.
  @AuraEnabled 
  Public static List<String> showLocationType(id recordid, String selectedDistributor){
      system.debug('Printing location type selectedDistributor....' + selectedDistributor);
      //fix of issue#209 user should be see those location which he has access to
      List<String> returnList = IAM_getSubscriptionNames.getLocationType(recordid,selectedDistributor);
     
      return returnList;
  }
  
  //Below Method is to get the distributors based on selected region
  @AuraEnabled Public static Account[] getAccountList(string region) {
      //fix of issue#209 user should be see those location which he has access to
      return IAM_getSubscriptionNames.getLocations(region);
  }
  
  //Below method is to get the accounts list to display in the table region of the wrokGrp Id pop up.
      @AuraEnabled
      Public static List<Account> AccountsList(id recordid, String selectedDistributor, String selectedType){
          System.debug('Printing list of accounts enter');
          //fix of issue#209 user should be see those location which he has access to
          List<Account> accntsToDisplay = IAM_getSubscriptionNames.getLocationByType(recordid,selectedDistributor, selectedType);
          return accntsToDisplay; 
      }
  
      
  //Methhod to update the Workgroup id on the contact 
  @AuraEnabled
  Public Static String assaignWrokGrpID(id recordId,List<Account> accnts){
      String returnString;
      try{
          Set<String> remDupWrkGrp = new Set<String>();
          List<Account> wrkGrpAccnts = new List<Account>(accnts);
          String newWrkGrpID = '';
          List<Contact> con=[SELECT id,IAM_Work_Group_Id__c,CMI_Contact_Type__c,IAM_Internal__c,Accountid,Account.Name,Account.IAM_Service_Provider_Code__c FROM Contact WHERE id=:recordId]; 
          System.debug('Prinitng contact values'+con);
          System.debug('Prinitng accnts values'+accnts);
          System.debug('Printing Workgroup Id ......'+con[0].IAM_Work_Group_Id__c);
          List<Account> primaryAcc = null;
          if(null != con && con.size() > 0){
              primaryAcc = [select Location__c from Account where id =: con[0].Accountid];
              if(null != primaryAcc && primaryAcc.size() > 0){
                 // if(null != primaryAcc[0].Location__c || primaryAcc[0].Location__c != '')
                 if(null != primaryAcc[0].Location__c && primaryAcc[0].Location__c != '')   //Code Scan Fix
                      remDupWrkGrp.add(primaryAcc[0].Location__c + '-P');
              }
              System.debug('Printing  primary remDupWrkGrp .. '+remDupWrkGrp);
              
              if(!String.isEmpty(con[0].IAM_Work_Group_Id__c)){
                  List<String> wrkGrpId = con[0].IAM_Work_Group_Id__c.split('\\|');
                  System.debug('Prinitng wrkGrpId values' + wrkGrpId);
                  for(String wrkgrp : wrkGrpId){
                      remDupWrkGrp.add(wrkgrp);
                  }   
              }
              
              for(Account an : wrkGrpAccnts){
                  if(an.id==con[0].Accountid){
                      remDupWrkGrp.add(an.Location__c + '-P');
                  }
                      
                  else{
                      if(!String.isBlank(an.Location__c)){
                          remDupWrkGrp.add(an.Location__c + '-S');
                      }
                      
                  }
                      
              }
              System.debug('Printing  remDupWrkGrp .. '+remDupWrkGrp);
              String finalWorkGrp = '';
              for(String wg : remDupWrkGrp){
                  finalWorkGrp += wg +'|';
              }
                  
              con[0].IAM_Work_Group_Id__c = finalWorkGrp.removeEnd('|');
              //Amar added for the 
              if(con[0].IAM_Work_Group_Id__c.length() > 1024){
                  returnString = 'Only 72 secondary work group IDs can be assigned to a user at one time. Please adjust your selection to not exceed a total of 72.';
              }
              else{
              System.debug('Printing updated Workgroup Id'+con[0].IAM_Work_Group_Id__c);
              
              update con;
              returnString='Updated Successfully'; 
              }
          }
           
      }catch(exception ex){
          system.debug('Printing application error'+ex.getMessage());
          System.debug('Printing errors stack trace'+ex.getStackTraceString());
          System.debug('Printing error Line number'+ex.getLineNumber());
          System.debug('Printing cause'+ex.getCause());
          /*returnString='Something unexpected happened, please contact System Administrator';
          if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                  returnString = ex.getdmlMessage(0);
              }
          else{
              returnString ='Something went wrong. Please contact System Administrator.';
          }*/
          returnString=fieldCustomValidation(ex);
      }   
      return returnString;
  }
  
  //Methhod to remove the Workgroup id on the contact 
  @AuraEnabled
  Public Static String removeWrokGrpID(id recordId,List<Account> accnts){
      String returnString;
      try{
          Set<String> ConWrkGrp = new Set<String>();
          
          List<Account> wrkGrpAccnts = new List<Account>(accnts);
          String newWrkGrpID = '';
          List<Contact> con=[SELECT id,IAM_Work_Group_Id__c,CMI_Contact_Type__c,Accountid,IAM_Internal__c,Account.Name,Account.IAM_Service_Provider_Code__c FROM Contact WHERE id=:recordId]; 
          System.debug('Prinitng contact values'+con);
          System.debug('Prinitng accnts values'+accnts);
          System.debug('Printing Workgroup Id ......'+con[0].IAM_Work_Group_Id__c);
        
          if(null != con && con.size() > 0){
             if(!String.isEmpty(con[0].IAM_Work_Group_Id__c)){
                  List<String> wrkGrpId = con[0].IAM_Work_Group_Id__c.split('\\|');
                  System.debug('Prinitng wrkGrpId values' + wrkGrpId);
                  for(String wrkgrp : wrkGrpId){
                      ConWrkGrp.add(wrkgrp);
                  }   
              }
              System.debug('Printing  ConWrkGrp before remove.. '+ConWrkGrp);
              
              for(Account an : wrkGrpAccnts){
                  if(an.id==con[0].Accountid)
                      ConWrkGrp.remove(an.Location__c + '-P');
                  else
                      ConWrkGrp.remove(an.Location__c + '-S');
              }
              System.debug('Printing  ConWrkGrp after remove .. '+ConWrkGrp);
              
              String finalWorkGrp = '';
              for(String wg : ConWrkGrp){
                  finalWorkGrp += wg +'|';
              }
                  
              con[0].IAM_Work_Group_Id__c = finalWorkGrp.removeEnd('|');
              
              
              System.debug('Printing updated Workgroup Id'+con[0].IAM_Work_Group_Id__c);
              
              Update con;
          }
          returnString='Updated Successfully';   
      }catch(exception ex){
          system.debug('Printing application error'+ex.getMessage());
          System.debug('Printing errors stack trace'+ex.getStackTraceString());
          System.debug('Printing error Line number'+ex.getLineNumber());
          System.debug('Printing cause'+ex.getCause());
          /* Solution - #483 - Displaying error message occured by validation rules. */
         /* if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
              returnString = ex.getdmlMessage(0);
          }
          else{
              returnString ='Something went wrong. Please contact System Administrator.';
          }*/
          returnString=fieldCustomValidation(ex);
      }   
      return returnString;
  }
  
  @AuraEnabled
  Public static string getUserInfo(){
      user u=[select id,Name,UserRole.Name from user where id=:UserInfo.getUserId()];
      return u.UserRole.Name; 
  }
  
  @AuraEnabled
      public static String appDAUpdate(id recordid,string buName){
         String returnString;
          try{
          List<IAM_Application__c> appDA=[SELECT id,IAM_Application_Name__c,IAM_Status__c,CMI_CDA_Status__c FROM IAM_Application__c where id=:recordid];
              if(!appDA.isEmpty()){
                  if(buName=='Generate Service Agreement'){
                      appDA[0].CMI_CDA_Status__c='Sent To Customer';
                      update appDA[0];
                      returnString='Ok';
                  }
              }else{
                  returnString='Something Wrong has happened. Please contact System Administrator.';
              }
          }catch(exception ex){
              returnString=fieldCustomValidation(ex);
              /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                  returnString = ex.getdmlMessage(0);
              }
              else{
                  returnString ='Something went wrong. Please contact System Administrator.';
              }*/
          }
            return returnString;
      }
  
  @AuraEnabled
       public static String appActivateDA(id recordid,string buName){
         String returnString;
         String Tspvalidation='';
         String sendInfo;
         System.debug('Printing button Name'+buName); 
          try{
              List<IAM_Application__c> appDA=[select id,CMI_CDA_Status__c,IAM_Status__c,IAM_Account_Name__c,IAM_Subscription_End_Date__c,  IAM_Subscription_Start_Date__c,IAM_Account_Name__r.CMI_CId__c from IAM_Application__c where id=:recordid];
              List<IAM_Contact_Provisioning__c> appCon=new List<IAM_Contact_Provisioning__c>();
      List<Contact> con= new List<Contact>();
              if(!appDA.isEmpty()){
                  
                  if(appDA[0].IAM_Status__c!='Active'){
                      if(!Test.isRunningTest()){  
                      Tspvalidation=CMI_CompanyInformation.TspValidation(recordid,appDA[0].IAM_Account_Name__c,buName);   
                      }else if(Test.isRunningTest()){ 
                          Tspvalidation='valid';  
                      }
                          if(Tspvalidation=='valid'){
                              //calling company info class to send information to PC.
                              System.debug('Printing TSP Validation'+TspValidation);
                              if(Test.isRunningTest()){
                                  sendInfo= 'OK';
                              }
                              else{
                                  sendInfo=CMI_CompanyInformation.CalloutResponseContents(recordid,appDA[0].IAM_Account_Name__c,'Active',buName);
                              }
                              
                              //String sendInfo=CMI_CompanyInformation.CalloutResponseContents(recordid,appDA[0].  IAM_Account_Name__c,'Active',buName);
                              
                              if(sendInfo=='successfull.'||sendInfo=='OK'){
                                  System.debug('Printing send to pc is success for Account status active'+SendInfo);
                //Query for all contacts and create users or update users Respectively.
                con=[Select id,Account.Name,IAM_Contact_Status__c,CMI_Contact_type__c,IAM_Internal__c,IAM_Legacy_User__c from Contact where Accountid=:appDA[0].IAM_Account_Name__c];
                System.debug('Printing Contacts Under applications'+con);
                  //there should be atleast one contat since we have passed the Primary Contact Validation from CMI_CompanyInformation class
                  if(!con.isEmpty()){
                    Set<id> conIds=new set<id>();
                    for(Contact c:con){
                      Conids.add(c.id);
                    }
                    List<User> usr=[Select id,isActive,username,ContactId,Contact.IAM_Contact_Status__c from user where Contactid=:conids];
                    System.debug('Printing user list'+usr);
                    if(!usr.isEmpty()){
                                              String createConProv='';
                      Set<id> activeIds=new Set<id>();// set to store Active User Ids.
                      Set<id> inActiveIds=new Set<id>();//Set to Store Inactive User Ids.
                                              Set<id> NoUser= new Set<id>();//Set to Store no Users are present.
                                              for(id i:conIds){  
                                                for(user u:usr){
                          if(u.isActive==true){
                            activeIds.add(u.ContactId);
                          }else if(u.isActive==false){
                            inActiveIds.add(u.ContactId);
                          }
                                                      if(i==u.contactid){
                                                          //User record i Present
                                                      }else{
                                                          NoUser.add(u.ContactId);
                                                      }
                                                }
                                              } 
                        //If users are active then Update the user and add Contact access feature at the contac level with status active.
                        //Process builder should tke care of the Permission set assignemnt.
                        if(!activeIds.isEmpty()){
                                                      System.debug('Printing ActiveIds'+activeIds);
                          //Calling methond to create Contact Provisioning records this will automatically take care of permission set assignemnet
                          createConProv=CreateConProv(activeIds,appDA[0]);
                                                      System.debug('Printing Create Con Prov Status'+createConProv);
                                                      String updatefeatures=updatefeatureAccess(appDA[0],appCon,true,false);
                                                      System.debug('Printing features'+updatefeatures);
                                                      returnString='Activated';
                        }
                        
                        if(!inActiveIds.isEmpty()){
                                                      System.debug('Printing inactive IDs'+inActiveIds);
                          //Calling Update user method to update user attibutes in Future method an make the necessary ches respectively.
                          //here we meed to make contact staus to Active if con Status in inactive or Pendnig.
                          List<Contact> conUpd= [Select id,IAM_Contact_Status__c ,IAM_Internal__c,IAM_Legacy_User__c  from Contact where id=:inActiveIds];
                          if(!ConUpd.isEmpty()){
                            For(Contact c:ConUpd){
                              c.IAM_Contact_Status__c='Active';
                            }
                            Update ConUpd;
                          }
                          UpdateUserFlag(inActiveIds);
                                                      String created=CreateConProv(inActiveIds,appDA[0]);
                                                          system.debug('Printing Con PRov Creation'+created);
                            String updatefeature=updatefeatureAccess(appDA[0],appCon,true,false);
                                                          System.debug('Printing Update Feature'+updatefeature);
                                                      returnString='Activated';
                        }
                                                
                                              if(!NoUser.isEmpty()){
                                                  System.debug('Printing Non User'+NoUser);
                                                  //call create user class if it is ok then call Create Con prov.
                                                List<Contact> objCon = [select id,IAM_Legacy_User__c ,firstname,lastname,email,phone,Account.OwnerId,Account.CMI_Account_Num__c, Accountid,Account.Name,CMI_Contact_Type__c,IAM_Internal__c,Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.Type,Account.IAM_Movex_Customer_Code__c,Account.IAM_WWSPS_Regions__c from Contact where id in :NoUser];
                                            String returnvalue='';
                                            System.debug('Printing return value in lightnign Account Controller class'+returnvalue);
                                                  if(Test.isRunningTest()){
                                                     returnvalue='OK';
                                                  }else{
                                                      returnvalue=IAM_CreateUser.CreateUser(objCon);
                                                  }
                                                  if(returnValue=='OK'){
                                                      //IF users got created then we need to see if these contacts have Contact Provisionings if yes update their status to Active
                                                      //else create all the records.
                                                      //Removed space from the below query by Lavanya Javvadi
                          List<IAM_Contact_Provisioning__c> appConDA=[Select id,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c='Connected Solutions' and IAM_Contact__c=:NoUser and (IAM_Status__c='Pending' OR IAM_Status__c='Pending Account Approval') ];
                          if(appDA.isEmpty()){
                            //Create User access features
                            String created=CreateConProv(NoUser,appDA[0]);
                                                          system.debug('Printing Con PRov Creation'+created);
                            String updatefeature=updatefeatureAccess(appDA[0],appConDA,true,false);
                                                          System.debug('Printing Update Feature'+updatefeature);
                          }else if(!appDA.isEmpty()){
                              String upfeature=updatefeatureAccess(appDA[0],appConDA,true,true);
                              System.debug('Printing Update Feature'+upFeature);
                                                      }
                          returnString='Activated';
                                                  }else{
                          returnString=returnValue;
                        }
                      }
                      System.debug('User not empty');  
                        
                    }else{
                      // if user list si empty create Users for all contacts.
                      List<Contact> objCon = [select id,firstname,lastname,IAM_Internal__c,email,phone,IAM_Legacy_User__c,Account.CMI_Account_Num__c,Account.OwnerId, Accountid,Account.Name,CMI_Contact_Type__c,Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.Type,Account.IAM_Movex_Customer_Code__c,Account.IAM_WWSPS_Regions__c from Contact where id in :Conids];
                                           String returnvalue='';
                                           if(Test.isRunningTest()){
                                                     returnvalue='OK';
                                                  }else{
                                                      returnvalue=IAM_CreateUser.CreateUser(objCon);
                                                  }
                                              if(returnvalue=='OK'){
                                                      For(Contact cn:ObjCon){
                                                          cn.IAM_Contact_Status__c='Active';
                                                      }
                                                      Update ObjCon;
                                                      //IF users got created then we need to see if these contacts have Contact Provisionings if yes update their status to Active
                                                      //else create all the records.
                                                      //Removed space from the below query by Lavanya Javvadi
                          List<IAM_Contact_Provisioning__c> appConDA=[Select id,IAM_Status__c,IAM_Contact__c from IAM_Contact_Provisioning__c where (IAM_Application_Name__c='Connected Solutions' OR IAM_Application_Name__c='Marketplace') and IAM_Contact__c=:Conids and (IAM_Status__c='Pending' OR IAM_Status__c='Pending Account Approval') ];
                          System.debug('Printign Contact Provisionings'+appConDA);
                                                      if(appConDA.isEmpty()){
                            //Create User access features
                            String Cnpro=CreateConProv(Conids,appDA[0]);
                                                          System.debug('CnPro Creation'+CnPro);
                                                          
                            updatefeatureAccess(appDA[0],appConDA,true,false);
                          }else if(!appConDA.isEmpty()){
                              updatefeatureAccess(appDA[0],appConDA,true,true);
                          }
                                                      returnString='Activated';
                                                  }
                                          else{
                                              returnString=returnValue;
                                          }
                                         }  
                  }else{
                    returnString='No Contacts are present to Create a User or Give access to Connected Solutions Application.';
                  }
                                      
                
                              }else{     
                                  return sendInfo;
                              }
                          }else{
                          return Tspvalidation;
                          }
                         
                  }else{
                      returnString='Application is already Active';
                  }
          }else{
              returnString='Something went wrong please contact Adminstrator.';
          }   
          }catch(exception ex){
              returnString=fieldCustomValidation(ex);
              /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                  returnString = ex.getdmlMessage(0);
              }
              else{
                  returnString ='Something went wrong. Please contact System Administrator.';
              }*/
          }
            return returnString;
      }
      
  Public Static String CreateConProv(Set<id> ConIds,IAM_Application__c appDA){
    //Should call this method on ly if users are activr inactive. Just for creating Contact Provisioning Records.
    //for inactive users user update happens in future an Applciation sets are assigned approprialty.  
    System.Debug('Printing Contacts that came in the Method'+conIds);
    String returnString='';
    List<User> usr=[Select id,Contactid,isActive,username,Contact.CMI_Contact_type__c,Contact.Account.id from user where Contactid=:ConIds];
    List<IAM_Contact_Provisioning__c> appcon=new List<IAM_Contact_Provisioning__c>();
          Map<id,IAM_Contact_Provisioning__c> conAppDA=new Map<id,IAM_Contact_Provisioning__c>();
          Map<id,IAM_Contact_Provisioning__c> conAppOSM=new Map<id,IAM_Contact_Provisioning__c>();
          List<IAM_Contact_Provisioning__c> appConActive=[select id,IAM_Application_Name__c,IAM_Contact__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:ConIds and IAM_Status__c='Active' and (IAM_Application_Name__c='Connected Solutions' OR IAM_Application_Name__c='Marketplace')];
          System.debug('Printing active Contct Provisionigs'+appConActive);
          if(!appConActive.isEmpty()){
              for(IAM_Contact_Provisioning__c ap:appConActive){
                  if(ap.IAM_Application_Name__c=='Connected Solutions'){
                      conAppDA.put(ap.IAM_Contact__c,ap);
                  }
                  if(ap.IAM_Application_Name__c=='Marketplace'){
                      conAppOSM.put(ap.IAM_Contact__c,ap);
                  }
              }
          }
    List<IAM_Application__c> appMP=[select id,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:usr[0].Contact.Account.id and IAM_Application_Name__c='Marketplace' LIMIT 1];
    System.debug('Printing application name'+appMP);
    try{
      if(!usr.isEmpty()){
        for(user u:usr){
                      //before this need to check if this contact has a active record behind the scenes
                      if(!conAppDA.ContainsKey(u.contact.id)){
                          System.debug('Printing active status connected solutions');
          IAM_Contact_Provisioning__c iam= new IAM_Contact_Provisioning__c();
          iam.IAM_Application_Name__c='Connected Solutions';
          iam.IAM_Account_Application__c=appDA.id;
          iam.IAM_Contact__c=u.ContactId;
          iam.IAM_User__c=u.id;
          iam.IAM_DA_Customer_List__c=appDA.IAM_Account_Name__r.CMI_CId__c;
          iam.IAM_DA_Session_Time_Out__c='864000000';
          iam.IAM_Status__c='Active';
          if(u.Contact.CMI_Contact_type__c=='Primary'){
            iam.IAM_Role__c='PrimaryContact';
          }else{
            iam.IAM_Role__c='User';
          }
          iam.IAM_Start_Date__c=system.Today();
          //iam.IAM_End_Date__c=appDA.IAM_End_Date__c;
          iam.recordTypeid=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
          appCon.add(iam);
                      }
          if(u.Contact.CMI_Contact_type__c=='Primary'){
            if(!appMP.isEmpty()){
                              System.debug('PRinting app Mapp Market place'+appMP);
                           //before this need to check if this contact has a active record behind the scenes
                              if(!conAppOSM.ContainsKey(u.Contactid)){
              System.debug('Printing active status MArket place');
                                  IAM_Contact_Provisioning__c appOSM= new IAM_Contact_Provisioning__c();
                appOSM.IAM_Account_Application__c=appMP[0].id;
                appOSM.IAM_Status__c='Active';
                appOSM.IAM_Start_Date__c=system.Today();
                appOSM.IAM_Application_Name__c='Marketplace';
                // appOSM.DA_Connected_Solutions_Role__c='OSM Fleet Admin';
                appOSM.recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
                appOSM.IAM_Contact__c = u.contact.id;
                appOSM.IAM_User__c=u.id;
                appOSM.IAM_Role__c = 'OSM Fleet Admin';
                appCon.add(appOSM);
                              }      
            }
          }
        }
        insert appCon;
        returnString='OK';
      }  
    }catch(exception ex){
      System.debug('Printing exception e'+ex.getStackTraceString());
      IAM_ErrorHandling.IAMerrorCapture(appDA.id,'DA-Lightning Activate',ex.getMessage());
            ReturnString=fieldCustomValidation(ex);
          /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
              ReturnString = ex.getdmlMessage(0);
          }
          else{
              ReturnString ='Something went wrong. Please contact System Administrator.';
          }*/
    }
    return ReturnString;
  }
  
  @future
  Public Static Void UpdateUserFlag(Set<id> ConIds){
    System.debug('Entered user permission set list');
    List<User> usr=[Select id,isActive,Contact.CMI_Contact_Type__c from user where ContactId=:ConIds];
    List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
          try{
    if(!usr.isEmpty()){
      
      for(user u:usr){
        u.isActive=True;
        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = System.Label.IAM_App_DA_PermissionSet_ID, AssigneeId = u.Id);
        permissionSetList.add(psa);
          
        if(u.Contact.CMI_Contact_Type__c=='Primary'){
          PermissionSetAssignment psaOSM = new PermissionSetAssignment (PermissionSetId = System.Label.IAM_App_OSM_FleetAdmin_PermissionSet_ID, AssigneeId = u.Id);
          permissionSetList.add(psaOSM);  
        }
                  System.resetPassword(u.id,True );
      }
      update usr;
      Insert permissionSetList;
    }
          }catch(exception e){
              
              System.debug('Printing apex exception'+e);
          }     
  }
  
  Public Static String updatefeatureAccess(IAM_Application__c appDA,List<IAM_Contact_Provisioning__c> appConDA,Boolean isAcntFeature, Boolean isContFeature){
              String returnValue='';
      Set<id>Conids=new Set<id>();
      List<user> usr=new List<user>();
      Map<id,id> conUserMap=new Map<id,id>();
      for(IAM_Contact_Provisioning__c con:appConDA){
          Conids.add(con.IAM_Contact__c);
      }
      if(!Conids.isEmpty()){
          usr=[Select id,ContactId from user where ContactId=:conIds];
          System.debug('Printing user List'+usr);
          if(!usr.isEmpty()){
            for(user u:usr){
                conUserMap.put(u.Contactid,u.id);
            }
          }    
      }
              try{
                  if(isAcntFeature||isContFeature){
                          if(appDA!=null&&isAcntFeature){
                              appDA.IAM_Status__c='Active';
                              Update appDA;
                          }
                          
                          if(!appConDA.isEmpty()&&isContFeature){
                              for(IAM_Contact_Provisioning__c app:appConDA){
                                      app.IAM_Status__c='Active';
                                      app.IAM_DA_Customer_List__c=appDA.IAM_Account_Name__r.CMI_CId__c;
                            
                                  if(!conUserMap.isEmpty()){
                                      if(conUserMap.containsKey(app.IAM_Contact__c)){
                                          app.IAM_User__c=conUserMap.get(app.IAM_Contact__c);
                                      }
                                  }
                              }
                              Update appConDA;
                          }
                  returnValue='Ok';   
                  }
              }catch(exception ex){
                  System.debug('Printing exception message'+ex.getMessage());
                  returnValue=fieldCustomValidation(ex);
                  /*if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                      returnValue = ex.getdmlMessage(0);
                  }
                  else{
                      returnValue ='Something went wrong. Please contact System Administrator.';
                  }*/
              }
              return returnValue;
          }
  @AuraEnabled
  Public Static Map<String,List<Contact>> getContacts1(String recordId){
    
      System.debug('Printing record ID'+recordId);
      Map<String,List<Contact>> ContactToDisplay=new Map<String,List<Contact>>();
      List<Contact> selected= new List<Contact>();
      List<Contact> available=new List<Contact>();
      List<IAM_Contact_Provisioning__c> appCons= new List<IAM_Contact_Provisioning__c>();
      List<IAM_Application__c> app=[SELECT id,IAM_Account_Name__c from IAM_Application__c where Id=:RecordId]; 
      System.debug('Printing app'+app);
      if(!app.isEmpty()){
          appCons=[SELECT id,IAM_Contact__c FROM IAM_Contact_Provisioning__c Where IAM_Account_Application__c=:app[0].IAM_Account_Name__c and (IAM_Status__c='Active' OR IAM_Status__c='Pending')];
          System.debug('Printing con apps'+appCons);
          List<Contact> allContacts=[Select id,Name,FirstName,LastName,email,IAM_Contact_Status__c,IAM_Internal__c from Contact where AccountId=:app[0].IAM_Account_Name__c AND (IAM_Contact_Status__c='Active' OR IAM_Contact_Status__c='Reclaim')];
          System.debug('Printing Contacts size'+allContacts.Size());
          if(!allContacts.isEmpty()){
              if(appCons.isEmpty()){
                  //Means this subscription is not tied to any contact.So selected should be null.
                  for(Contact c:allContacts){
                      available.add(c);
                  }
              }else{
                  //Means subcription is assigned to few contacts. Need to loop through contacts and Contact provisionings to seperate contacts.
                  for(Contact c:allContacts){
                      for(IAM_Contact_Provisioning__c con:appCons){
                          if(con.IAM_Contact__c==c.id){
                              //application is assigned to Contact.
                             selected.add(c); 
                          }else{
                              //application is not assigned to contact and can be displayed in the available section.
                              available.add(c);
                          }
                      }
                  }   
              }
              //adding lists into Map.
              if(!available.isEmpty()){
              ContactToDisplay.put('available',available);
              }
              if(!selected.isEmpty()){
              ContactToDisplay.put('selected',selected);
              }
          }else{
              //Need to set that no Contacts are present at Account level 
          }
      }else{
          //set the error message string as error.
      }
      System.debug('Printing available contacts'+available.Size());
      System.debug('Printing selected contacts'+selected.size());
      return ContactToDisplay;
  }
  
  //method to get guidanz roles
    @AuraEnabled
     Public Static List<String> getGuidanzRole(id recordid,String selectedApp){
           
          List<String> roles= new List<String>();//Variable to store return roles to java script controller
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          try{
          
          List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Cumpas_Modularity__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
          System.debug('Printing application names'+App);
          if(!App.isempty()){
              
              if(!String.isEmpty(App[0].IAM_Role__c)){
                  roles=App[0].IAM_Role__c.split(';');
              }
          }else{
              roles.add('Please Contact administrator. Something went wrong');
          }
          }catch(exception e){
              system.debug('Printing exception'+e.getStackTraceString());
              System.debug('Printing exception messgae'+e.getMessage());
              roles.add('Please Contact administrator. Something went wrong');
          }
          System.debug('Printing optionRole'+roles);
          return roles;
       }
       
       //Fix - D-3194 added method for getting RSW roles
      @AuraEnabled
      Public Static List<String> getRSWRole(id recordid,String selectedApp){
           
          List<String> roles= new List<String>();//sVariable to store return roles to java script controller
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          try{
          
          List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
          System.debug('Printing application names'+App);
          if(!App.isempty()){
              
              if(!String.isEmpty(App[0].IAM_Role__c)){
                  roles=App[0].IAM_Role__c.split(';');
              }
          }else{
              roles.add('Please Contact administrator. Something went wrong');
          }
          }catch(exception e){
              system.debug('Printing exception'+e.getStackTraceString());
              System.debug('Printing exception messgae'+e.getMessage());
              roles.add('Please Contact administrator. Something went wrong');
          }
          System.debug('Printing optionRole'+roles);
          return roles;
      }
  
      //Amarnath added for the MarketPlace Roles
      @AuraEnabled
      Public Static List<String> getMarketPlaceRole(id recordid,String selectedApp){
           
          List<String> roles= new List<String>();//sVariable to store return roles to java script controller
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          string OSMstorefront =Label.IAM_OSM_ContPro_Default_Roles;
           boolean haveaccess=false; // OSM D-3265 Nishant Verma
         // OSM D-3265 Nishant Verma
          List<PermissionSetAssignment> assignedPSList=[SELECT AssigneeId,PermissionSet.Name FROM PermissionSetAssignment where AssigneeId=:Userinfo.getUserId()];
          for(PermissionSetAssignment assignedPSObj:assignedPSList){
              if(assignedPSObj.PermissionSet.Name =='OSM_Distributor_Admin' ||assignedPSObj.PermissionSet.Name=='OSM_Support_Admin'){
                  haveaccess=true;
              }
          }
          
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          try{
          
          List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c, IAM_Account_Name__r.type from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
          System.debug('Printing application names'+App);
          if(!App.isempty()){
              
              if(!String.isEmpty(App[0].IAM_Role__c)){
                  if((App[0].IAM_Account_Name__r.type != 'Distributor Account' || App[0].IAM_Account_Name__r.type != 'Distributor Branch Account') && haveaccess){ // OSM D-3265 Nishant Verma
                      system.debug('Cooming First if');
                      if(App[0].IAM_Role__c.Contains(OSMstorefront)){
                           system.debug('Cooming 2 if');
                          List<String> OSMRole =App[0].IAM_Role__c.split(';');
                          for(String roleObj :OSMRole){
                              if(roleObj== System.Label.IAM_OSM_ContPro_Default_Roles){
                                  system.debug('Cooming 2 if');
                                  roles.add(roleObj);
                                  break;
                              }
                          }
                      }
                  }else{
                      roles=App[0].IAM_Role__c.split(';');
                  } // OSM D-3265 Nishant Verma
                  system.debug('Cooming 2 if'+roles);                    
              }
          }else{
              roles.add('Please Contact administrator. Something went wrong');
          }
          }catch(exception e){
              system.debug('Printing exception'+e.getStackTraceString());
              System.debug('Printing exception messgae'+e.getMessage());
              roles.add('Please Contact administrator. Something went wrong');
          }
          System.debug('Printing optionRole'+roles);
          return roles;
      }
      
  //Amarnath Mishra added for the Connected solution roles
      
      @AuraEnabled
      Public Static List<String> getConnectedSolutionRole(id recordid,String selectedApp){
           
          List<String> roles= new List<String>();//sVariable to store return roles to java script controller
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          try{
          
          List<Contact> con=[Select id,Accountid,Account.CMI_CId__c from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
          System.debug('Printing application names'+App);
          if(!App.isempty()){
              
              if(!String.isEmpty(App[0].IAM_Role__c)){
                  roles=App[0].IAM_Role__c.split(';');
              }
          }else{
              roles.add('Please Contact administrator. Something went wrong');
          }
          }catch(exception e){
              system.debug('Printing exception'+e.getStackTraceString());
              System.debug('Printing exception messgae'+e.getMessage());
              roles.add('Please Contact administrator. Something went wrong');
          }
          System.debug('Printing optionRole'+roles);
          return roles;
      }
      
      @AuraEnabled
  public static String saveFreeAppGuidanzMobileFT(id recordid, String appName, List<String> rolesNames, Date subEndDate, Integer assignedCount){
      System.debug('Printing Contact id'+recordid);
      System.debug('Prinintg selected App'+appName);
      System.debug('Printing role names'+rolesNames);
      System.debug('#### subEndDate - '+subEndDate);
      String finalRoles= '';
      Boolean creation=false;
      if(!rolesNames.isEmpty()){
          for(String a : rolesNames){
              finalRoles = +a;
          }            
      }            
      System.debug('Printing final Role Values'+finalRoles);        
      String returnValue = '';      
      try {
          List<Contact> Con = [
              SELECT Id
                   , Name
                   , Account.Id
                   , IAM_Contact_Status__c
                   , IAM_Internal__c
                   , Account.Type
                   , Account.IAM_Internal_Account__c
                FROM Contact
               WHERE Id = :recordId];
          if(!Con.isEmpty()){
              /* 12/03/2020 - Updated to add NPBU Expiration Dates */
              List<IAM_Application__c> appGuidanzFT = [
                    SELECT Id
                         , IAM_Subscription_Name__c
                         , IAM_Application_Name__c
                         , IAM_Subscription_Start_Date__c
                         , IAM_Subscription_End_Date__c
                         , IAM_Role__c
                         , IAM_Status__c
                         , IAM_swregExpire__c
                         , IAM_Remaining_Units__c
                         , IAM_NpbuDiagExpire__c
                      FROM IAM_Application__c
                     WHERE IAM_Application_Name__c = :appName
                       AND IAM_Status__c = 'Active'
                       AND IAM_Account_Name__c = :con[0].Accountid
                       AND IAM_Role__c IN :rolesNames
                      LIMIT 1
              ];
              System.debug('Prinitng application Name '+appGuidanzFT);
              if(!appGuidanzFT.isEmpty()){
                  if(Con[0].IAM_Internal__c) {
                    if(subEndDate < Date.today()) {
                        return Label.IAM_EndDateShouldBeInFuture;
                    } else if(subEndDate > appGuidanzFT[0].IAM_Subscription_End_Date__c) {
                        return Label.IAM_UserSubEndDateNotGTAppSubEndDate;
                    }
                  }
                if(assignedCount != null && assignedCount <= 0) {
                    return Label.IAM_EnterValidUnits;
                }
                if(assignedCount > appGuidanzFT[0].IAM_Remaining_Units__c) {
                    return Label.IAM_InsufficientUnits;
                }
                  IAM_Contact_Provisioning__c conProv = new IAM_Contact_Provisioning__c();
                  conProv.IAM_Application_Name__c = appName;
                  conProv.IAM_Account_Application__c = appGuidanzFT[0].id;
                  if(Con[0].IAM_Contact_Status__c == System.Label.IAM_Status_Active){
                      conProv.IAM_Status__c = System.Label.IAM_Status_Active;
                  } else {
                      conProv.IAM_Status__c = System.Label.IAM_Status_Pending;
                  }
                  conProv.IAM_Start_Date__c = System.Today();
                  conProv.IAM_Role__c = finalRoles;
                  if(assignedCount != null) {
                    conProv.IAM_Assigned_Units__c = assignedCount;
                    conProv.IAM_Remaining_Units__c = assignedCount;
                  }
                  if(Con[0].IAM_Internal__c && Con[0].Account.Type == 'Internal' && Con[0].Account.IAM_Internal_Account__c == True) {
                    conProv.IAM_End_Date__c = appGuidanzFT[0].IAM_Subscription_End_Date__c;
                    if(appGuidanzFT[0].IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)) {
                        conProv.IAM_swregExpire__c = getSWRegExpireValue(appGuidanzFT[0].IAM_Subscription_Name__c,
                        subEndDate);
                        conProv.IAM_Guidanz_Mobile_Roles__c = finalRoles;
                    }
                    if(appGuidanzFT[0].IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics)) {
                        //FT-NPBU End Date changes - @Anupam Backlog clearance
                        if(appGuidanzFT[0].IAM_Subscription_End_Date__c > system.today() + 365){
                            conProv.IAM_End_Date__c =  system.today() + 365;
                            conProv.IAM_NpbuDiagExpire__c = getNPBUDignExpireValue(appGuidanzFT[0].IAM_Subscription_Name__c,
                                                                     conProv.IAM_End_Date__c);
                        }else{
                            conProv.IAM_NpbuDiagExpire__c = getNPBUDignExpireValue(appGuidanzFT[0].IAM_Subscription_Name__c,
                                                                    appGuidanzFT[0].IAM_Subscription_End_Date__c);
                        }
                    }                                                                         
                } else {
                    conProv.IAM_End_Date__c = appGuidanzFT[0].IAM_Subscription_End_Date__c;
                    if(appGuidanzFT[0].IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)) {
                        conProv.IAM_swregExpire__c = getSWRegExpireValue(appGuidanzFT[0].IAM_Subscription_Name__c, 
                        appGuidanzFT[0].IAM_Subscription_End_Date__c);
                        conProv.IAM_Guidanz_Mobile_Roles__c = finalRoles;
                    }
                    if(appGuidanzFT[0].IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics)) {
                        //FT-NPBU End Date changes - @Anupam Backlog clearance
                        if(appGuidanzFT[0].IAM_Subscription_End_Date__c > system.today() + 365){
                            conProv.IAM_End_Date__c =  system.today() + 365;
                            conProv.IAM_NpbuDiagExpire__c = getNPBUDignExpireValue(appGuidanzFT[0].IAM_Subscription_Name__c,
                                                                      conProv.IAM_End_Date__c);
                        }else{
                            conProv.IAM_NpbuDiagExpire__c = getNPBUDignExpireValue(appGuidanzFT[0].IAM_Subscription_Name__c,
                                                                      appGuidanzFT[0].IAM_Subscription_End_Date__c);
                        }
                    }  
                  }                    
                  conProv.IAM_Contact__c = Con[0].id;
                  conProv.IAM_Subscription_Name__c = appGuidanzFT[0].IAM_Subscription_Name__c;
                  
                  conProv.IAM_Source__c = 'IAM';
                  System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                  conProv.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                  list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                  list<String> sss = new list<String>();
                  string myMsg;
                  lstconpro.add(conProv);
                  //insert conProv;
                  
                  Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                  myMsg=databaseErrorString(lstSR2);
                  creation=dataBaseSaveSuccessValue(lstSR2);
                  /*for (Database.SaveResult sr : lstSR2) {
                      if (sr.isSuccess()) {
                          System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                      } else {              
                          for(Database.Error err : sr.getErrors()) {
                              myMsg=err.getMessage();
                              if (err instanceof Database.DuplicateError) {
                                  myMsg='';
                                  myMsg=System.Label.IAM_Existing_Provisioning_Error;
                                  Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                                  Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                                  Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                                  Datacloud.MatchResult matchResult = matchResults[0];
                                  
                                  Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                  for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                      System.debug('MatchRecord: ' + matchRecord.getRecord());
                                      sss.add(matchRecord.getRecord().Id);
                                  }
                              }
                              if(!sss.isEmpty() && sss!=null) {
                                  IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                                  myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                              }
                              System.debug('===myMsg==='+myMsg);
                          }
                      }
                  }*/
                  if(myMsg!='' && myMsg!=null&&!Creation){
                      return myMsg;
                  } else {
                      returnValue='Record Created';
                  }                    
              } else {
                  //This section for Contact is not present
                  returnValue='Something unexpected happened, please contact your System Administrator.';
              }
          } else {
              //This section for Contact is not present
              returnValue='Something unexpected happened, please contact your System Administrator.';
          }
      } catch(exception e) {
          System.debug('Priniting Exception'+e);
          if(!Test.isRunningTest()){
              returnValue = e.getdmlMessage(0);
          }
          if(String.isBlank(returnValue)) {
              returnValue = 'Something unexpected happened please contact System Administrator';
          } 
      }       
      return returnValue;
  }
  
  /* 12/03/2020 - Updated to add Expiration Dates */
  public static String getSWRegExpireValue(String role, Date subEndDate) {
    String swRegExpireDate = '';
    if(role.equalsIgnoreCase('Field Test IAS Guidanz Mobile')) {
        swRegExpireDate = getExpirationStr('IASF', subEndDate);
    } else if(role.equalsIgnoreCase('Field Test CMP Guidanz Mobile')) {
        swRegExpireDate = getExpirationStr('CMPF', subEndDate);
    } else if(role.equalsIgnoreCase('Field Test SRV Guidanz Mobile')) {
        swRegExpireDate = getExpirationStr('SRVF', subEndDate);
    } else if(role.equalsIgnoreCase('Field Test PS PRO Guidanz Mobile')) {
        swRegExpireDate = getExpirationStr('PPRF', subEndDate);
    } else if(role.equalsIgnoreCase('Field Test Power Plus Lite Guidanz Mobile')) {
        swRegExpireDate = getExpirationStr('PPLF', subEndDate);
    } else if(role.equalsIgnoreCase('Beta Testing Guidanz Mobile')) { // added as part of FT-Guidanz Mobile enhancement - @Anupam
        swRegExpireDate = getExpirationStr('BTGF', subEndDate);
    }
    return swRegExpireDate;
}

/* 12/03/2020 - Updated to add Expiration Dates */
/* Prepare NPBU Diagnostica Expiration Date */
public static String getNPBUDignExpireValue(String role, Date subEndDate) {
    String npbuDiagExpireDate = '';
    if(role.equalsIgnoreCase('BASIC')) {
        npbuDiagExpireDate = getExpirationStr('BSCI', subEndDate);
    } else if(role.equalsIgnoreCase('Manufacturing')) {
        npbuDiagExpireDate = getExpirationStr('MFGI', subEndDate);
    } else if(role.equalsIgnoreCase('Advance')) {
        npbuDiagExpireDate = getExpirationStr('ADVI', subEndDate);
    } else if(role.equalsIgnoreCase('Pro')) {
        npbuDiagExpireDate = getExpirationStr('PROI', subEndDate);
    }
    return npbuDiagExpireDate;
}

/* Create Expiration String */
public static String getExpirationStr(String prefix, Date endDate) {
    String day = String.valueOf(endDate.day());
    String month = String.valueOf(endDate.month());
    if(day.length() == 1) {
        day = 0 + day;
    }
    if(month.length() == 1) {
        month = 0 + month;
    }
    return prefix + '-' + month + '/' + day + '/' + endDate.year();
}
      
  @AuraEnabled
      Public Static String saveFreeAppGuidanz(id recordid,String appName,List<String> rolesNames){
          System.debug('Printing Contact id'+recordid);
          System.debug('Prinintg selected App'+appName);
          System.debug('Printing role names'+rolesNames);
          Boolean creation=false;
          String finalRoles= '';
          if(!rolesNames.isEmpty()){
              for(String a:rolesNames){
                  finalRoles=+a;
              }
              
          }
          
          System.debug('Printing final Role Values'+finalRoles);
          
          String returnValue='';
    
          Try{
              List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c from Contact where id=:recordId];
              if(!Con.isEmpty()){
                List<IAM_Application__c> appGuidanz=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
                System.debug('Prinitng application Name'+appGuidanz);
                  if(!appGuidanz.isEmpty()){
                  //Now we can assign Guidanz application to Contact
                  
                  IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                  conProv.IAM_Application_Name__c=appName;
                          conProv.IAM_Account_Application__c=appGuidanz[0].id;
                      if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                          conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                      }else{
                          conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                      }
                  conProv.IAM_Start_Date__c=System.Today();
                  conProv.IAM_Role__c=finalRoles;
                  conProv.IAM_End_Date__c=appGuidanz[0].IAM_Subscription_End_Date__c;
                  ConProv.IAM_Contact__c=Con[0].id;
                  ConProv.IAM_Subscription_Name__c = appGuidanz[0].IAM_Subscription_Name__c;
                  System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                  conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                  
                  list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                  list<String> sss = new list<String>();
                  string myMsg;
                  lstconpro.add(conProv);
                  //insert conProv;
                  
                  Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                  myMsg=databaseErrorString(lstSR2);
                  creation=dataBaseSaveSuccessValue(lstSR2);
                  /*for (Database.SaveResult sr : lstSR2) {
                      if (sr.isSuccess()) {
                      System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                      }
                      else {              
                          for(Database.Error err : sr.getErrors()) {
                          myMsg=err.getMessage();
                          if (err instanceof Database.DuplicateError) {
                                      myMsg='';
                                      myMsg=System.Label.IAM_Existing_Provisioning_Error;
                                      Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                                      Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                                      Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                                      Datacloud.MatchResult matchResult = matchResults[0];

                                      Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                       for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                          System.debug('MatchRecord: ' + matchRecord.getRecord());
                                          sss.add(matchRecord.getRecord().Id);
                                          }
                                  }
                          if(!sss.isEmpty() && sss!=null)
                          {IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                          myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                          }
                           System.debug('===myMsg==='+myMsg);
                          }
                      }
                  }*/
                  if(myMsg!='' && myMsg!=null&&!creation){
                      return myMsg;
                  }
                  else{
                      returnValue='Record Created';
                  }
                  
                }else{
                  //This section for Contact is not present
                  returnValue='Something unexpected happened, please contact your System Administrator.';
                }
              }else{
              //This section for Contact is not present
              returnValue='Something unexpected happened, please contact your System Administrator.';
              }
          }
          catch(exception e){
          System.debug('Priniting Exception'+e);
              returnValue = e.getdmlMessage(0);
                  if(String.isBlank(returnValue)) {
                      returnValue = 'Something unexpected happened please contact System Administrator';
                  } 
          }       
          return returnValue;
      }
  // Added by Amarnath Mishra for Market place application
      @AuraEnabled
      Public Static String saveFreeAppMarketPlace(id recordid,String appName,List<String> rolesNames){
          System.debug('Printing Contact id'+recordid);
          System.debug('Prinintg selected App'+appName);
          System.debug('Printing role names'+rolesNames);
          String finalRoles= '';
          Boolean creation=false;
          if(!rolesNames.isEmpty()){
              for(String a:rolesNames){
                  finalRoles=+a;
              }
              
          }
          
          System.debug('Printing final Role Values'+finalRoles);
          
          String returnValue='';
          Try{
              List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c,IAM_Legacy_User__c,IAM_Internal__c,Username__c from Contact where id=:recordId];
              if(!Con.isEmpty()){
                List<IAM_Application__c> appMarketPlace=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
                System.debug('Prinitng application Name'+appMarketPlace);
                  if(!appMarketPlace.isEmpty()){
                  //Now we can assign Guidanz application to Contact
                  
                  IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                  conProv.IAM_Application_Name__c=appName;
                          conProv.IAM_Account_Application__c=appMarketPlace[0].id;
                      if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                          conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                      }else{
                          conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                      }
                  conProv.IAM_Start_Date__c=System.Today();
                  conProv.IAM_Role__c=finalRoles;
                  conProv.IAM_End_Date__c=appMarketPlace[0].IAM_Subscription_End_Date__c;
                  ConProv.IAM_Contact__c=Con[0].id;
                  ConProv.IAM_Subscription_Name__c = appMarketPlace[0].IAM_Subscription_Name__c;
                  System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                  conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                  
                  list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                  list<String> sss = new list<String>();
                  string myMsg;
                  lstconpro.add(conProv);
                  //insert conProv;
                  boolean createuser;
                    Database.SaveResult[] lstSR2;
                  if(!Test.isRunningTest()){
                      lstSR2 = Database.insert(lstconpro, false);
                  }else if(Test.isRunningTest()){
                      list<IAM_Contact_Provisioning__c> lstconprotest = new list<IAM_Contact_Provisioning__c>();
                       lstSR2 = Database.insert(lstconprotest, false);
                      
                  }
                  createUser=dataBaseSaveSuccessValue(lstSR2);
                  myMsg=databaseErrorString(lstSR2);
                  creation=dataBaseSaveSuccessValue(lstSR2);
                  /*for (Database.SaveResult sr : lstSR2) {
                      if (sr.isSuccess()) {
                      System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                          createuser= true;
                      }
                      else {              
                          for(Database.Error err : sr.getErrors()) {
                          myMsg=err.getMessage();
                          if (err instanceof Database.DuplicateError) {
                                      myMsg='';
                                      myMsg=System.Label.IAM_Existing_Provisioning_Error;
                                      Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                                      Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                                      Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                                      Datacloud.MatchResult matchResult = matchResults[0];

                                      Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                       for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                          System.debug('MatchRecord: ' + matchRecord.getRecord());
                                          sss.add(matchRecord.getRecord().Id);
                                          }
                                  }
                          if(!sss.isEmpty() && sss!=null)
                          {IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                          myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                          }
                             
                              System.debug('===myMsg==='+myMsg);
                          }
                      }
                  }*/
                      if(createuser && Con[0].IAM_Legacy_User__c && !Con[0].IAM_Internal__c ){
                        // Karthik Made Changes for Prod - INC1022619   
                        List<user> usr =[Select id,Contactid,Contact.Account.Id from user where (contactid=:con[0].Id or FederationIdentifier=:Con[0].Username__c) AND isActive=True];// Adding changes to query by Karthik -01-21-2021
                        if(usr.isempty()){
                            List<Contact> conobj=[select id,IAM_Site_Admin__c,IAM_Site_Admin_Role__c,FirstName,LastName,Email,IAM_Internal__C,IAM_Legacy_User__c,Account.OwnerId,Account.CMI_Account_Num__c,Phone,IAM_Contact_Status__c,IAM_Applications__c,IAM_Final_Approver__c,Username__c,IAM_Work_Group_Id__c,CMI_Contact_Type__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,Account.Location__c,Account.Recordtype.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_ABO_Code_Formula__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,Account.Type,Account.IAM_WWSPS_Regions__c,Account.IAM_Movex_Customer_Code__c,(select id,IAM_Application_Name__c,IAM_DA_Customer_List__c,IAM_RLS_Customer_Number__c, IAM_RLS_Group_Admin_Email__c,IAM_Role__c,IAM_Status__c,IAM_Active_Contact_Provisioning__c from Contact_Provisionings__r where IAM_Active_Contact_Provisioning__c=:recordid) from contact where id=:recordid Limit 1];
                            IAM_CreateUser.CreateUser(conobj);
                        }else{
                            if(Con[0].id!=usr[0].Contactid){
                                //Perform Contact merge and make sure Surviour has access to all the applications.
                                //Make the other Contact record as Inactive and mention comments saying that is inactive.
                                //IAM_Utility.copyContacts(Con[0].id,usr[0].Contactid);
                                Map<id,id> surviourToVictimConIds=new Map<id,id>{usr[0].Contactid=>Con[0].id};
                                List<Contact> contactList= new List<Contact>();
                                IAM_Utility.copyContacts(surviourToVictimConIds);
                                myMsg='Exsisting User-'+usr[0].Contactid; // Karthik Added line for Market place issue.
                            }
                        }
                        // Karthik Made Changes for Prod - INC1022619 
                      }
                      if(createuser && Con[0].IAM_Legacy_User__c && Con[0].IAM_Internal__c){
                          List<user> usr =[Select id from user where FederationIdentifier=:con[0].Username__c];
                          if(usr.isempty()){
                              List<Contact> conobj=[select id,IAM_Site_Admin__c,IAM_Site_Admin_Role__c,FirstName,LastName,Email,IAM_Internal__c,IAM_Legacy_User__c,Account.OwnerId,Account.CMI_Account_Num__c,Phone,IAM_Contact_Status__c,IAM_Applications__c,IAM_Final_Approver__c,Username__c,IAM_Work_Group_Id__c,CMI_Contact_Type__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,Account.Location__c,Account.Recordtype.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_ABO_Code_Formula__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,Account.Type,Account.IAM_WWSPS_Regions__c,Account.IAM_Movex_Customer_Code__c,(select id,IAM_Application_Name__c,IAM_DA_Customer_List__c,IAM_RLS_Customer_Number__c, IAM_RLS_Group_Admin_Email__c,IAM_Role__c,IAM_Status__c,IAM_Active_Contact_Provisioning__c from Contact_Provisionings__r where IAM_Active_Contact_Provisioning__c=:recordid) from contact where id=:recordid Limit 1];
                              if(!Test.isRunningTest()){  
                              IAM_CreateUser.CreateUser(conobj);  
                              }
                          }
                      }
                  if(myMsg!='' && myMsg!=null&&!creation){
                      return myMsg;
                  }
                  else{
                      returnValue='Record Created';
                  }
                  
                }else{
                  //This section for Contact is not present
                  returnValue='Something unexpected happened, please contact your System Administrator.';
                }
              }else{
              //This section for Contact is not present
              returnValue='Something unexpected happened, please contact your System Administrator.';
              }
          }
          catch(exception e){
          System.debug('Priniting Exception'+e);
              if(!Test.isRunningTest()){
              returnValue = e.getdmlMessage(0);
              }else {
                  returnValue='Something wrong';
              }
                  if(String.isBlank(returnValue)) {
                      returnValue = 'Something unexpected happened please contact System Administrator';
                  } 
          }       
          return returnValue;
      }
      
      // Fix - 3194 - save logic for rsw app
      @AuraEnabled
      Public Static String saveFreeAppRSW(id recordid,String appName,List<String> rolesNames){
          System.debug('Printing Contact id'+recordid);
          System.debug('Prinintg selected App'+appName);
          System.debug('Printing role names'+rolesNames);
          String finalRoles = '';
          Boolean creation=false;
          if(!rolesNames.isEmpty()){
              for(String a:rolesNames){
                  System.debug('role...... ' + a);
                  finalRoles = finalRoles + a + ';';
                  System.debug('finalRoles...... ' + finalRoles);
              }
              finalRoles = finalRoles.removeEnd(';');
          }
          
          System.debug('Printing final Role Values'+finalRoles);
          
          String returnValue='';
    
          Try{
              List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c from Contact where id=:recordId];
              if(!Con.isEmpty()){
                List<IAM_Application__c> appRSW=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
                System.debug('Prinitng application Name'+appRSW);
                  if(!appRSW.isEmpty()){
                  //Now we can assign Guidanz application to Contact
                  
                  IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                  conProv.IAM_Application_Name__c=appName;
                          conProv.IAM_Account_Application__c=appRSW[0].id;
                      if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                          conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                      }else{
                          conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                      }
                  conProv.IAM_Start_Date__c=System.Today();
                  conProv.IAM_Role__c=finalRoles;
                  conProv.IAM_End_Date__c=appRSW[0].IAM_Subscription_End_Date__c;
                  ConProv.IAM_Contact__c=Con[0].id;
                  ConProv.IAM_Subscription_Name__c = appRSW[0].IAM_Subscription_Name__c;
                  System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                  conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                  
                  list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                  list<String> sss = new list<String>();
                  string myMsg;
                  lstconpro.add(conProv);
                  //insert conProv;
                  
                  Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                  myMsg=databaseErrorString(lstSR2);
                  creation=dataBaseSaveSuccessValue(lstSR2);
                  /*for (Database.SaveResult sr : lstSR2) {
                      if (sr.isSuccess()) {
                      System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                      }
                      else {              
                          for(Database.Error err : sr.getErrors()) {
                          myMsg=err.getMessage();
                          if (err instanceof Database.DuplicateError) {
                                      myMsg='';
                                      myMsg=System.Label.IAM_Existing_Provisioning_Error;
                                      Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                                      Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                                      Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                                      Datacloud.MatchResult matchResult = matchResults[0];

                                      Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                       for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                          System.debug('MatchRecord: ' + matchRecord.getRecord());
                                          sss.add(matchRecord.getRecord().Id);
                                          }
                                  }
                          if(!sss.isEmpty() && sss!=null)
                          {IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                          myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                          }
                           System.debug('===myMsg==='+myMsg);
                          }
                      }
                  }*/
                  if(myMsg!='' && myMsg!=null&&!creation){
                      return myMsg;
                  }
                  else{
                      returnValue='Record Created';
                  }
                  
                }else{
                  //This section for Contact is not present
                  returnValue='Something unexpected happened, please contact your System Administrator.';
                }
              }else{
              //This section for Contact is not present
              returnValue='Something unexpected happened, please contact your System Administrator.';
              }
          }
          catch(exception e){
          System.debug('Priniting Exception'+e);
              returnValue = e.getdmlMessage(0);
                  if(String.isBlank(returnValue)) {
                      returnValue = 'Something unexpected happened please contact System Administrator';
                  } 
          }       
          return returnValue;
      }
      
            //Amarnath added for the application connected solution to update roles other fields
      //Date 07-27-2019
      @AuraEnabled
      public static string updateRolesConnectedSolution(Id recordid,string rolesNames,string customerlist){
          system.debug('===Inside updateRoles method===');
          string returnmessage;
          
          IAM_Contact_Provisioning__c iamContactProvisioningRecord = new IAM_Contact_Provisioning__c();
          if(Limits.getQueries()<Limits.getLimitQueries()){
          iamContactProvisioningRecord = [SELECT Id,IAM_Role__c,IAM_User_Type__c,IAM_DA_Calibaration_Role__c,IAM_DA_Customer_List__c,IAM_Application_Name__c,IAM_Guidanz_Mobile_Roles__c FROM IAM_Contact_Provisioning__c WHERE id =:recordid];
          }
          returnmessage = 'Record Updated';
          if(iamContactProvisioningRecord != null){
              iamContactProvisioningRecord.IAM_Role__c = rolesNames;
              //iamContactProvisioningRecord.IAM_Role__c = '';
              //iamContactProvisioningRecord.IAM_User_Type__c = usertype;
              iamContactProvisioningRecord.IAM_DA_Customer_List__c = customerlist;
              iamContactProvisioningRecord.IAM_DA_Calibaration_Role__c = rolesNames;
              try{
                  system.debug('=====value of contact prov record====='+iamContactProvisioningRecord);
                  update iamContactProvisioningRecord;
              }catch(Exception e){
                  returnmessage = e.getdmlMessage(0);
              }
          }
          else{
              returnmessage = 'Record not found';
          }
          if(String.isBlank(returnmessage)){
              returnmessage = 'Something went wrong. Please contact System Administrator.';
          }
          return returnmessage;
      }

  //Below 5 methods are for Assign Subscription button, GetRoles(), GetContacts(), SaveSubscription()
  
  

@AuraEnabled
      public static boolean UserHavePerm(id recordid) {
      Id myId = recordid;
      Boolean flag = false;
      String appName;
      Boolean IsFree = false;
      Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
      String sObjName = myId.getSObjectType().getDescribe().getName();
          if(sObjName == 'IAM_Application__c'){
          IAM_Application__c con= new IAM_Application__c();
              if(Limits.getQueries()<Limits.getLimitQueries()){
              con = [SELECT id,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Status__c FROM IAM_Application__c WHERE Id =:recordid];
              }
              if(con != null){
                  appName=con.IAM_Application_Name__c;
                  IsFree =con.IAM_Free_Subscription__c;
                  system.debug('==IsFree =='+IsFree );
                  Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
                  if(!appsCanBeAssigned.isEmpty()){
                      appNames=appsCanBeAssigned.KeySet();    
                  }
                  if(!appNames.isEmpty())
                  {
                  for(string ss : appNames)
                  {
                    if(appName==ss )
                      {
                      flag = true;
                      }
                  }
                  }
                   String IsProfileCIHR = getProfile();  // D-3164
                  if(IsFree == true)
                  {
                  flag = true;
                      if(IsProfileCIHR == System.Label.IAM_CIHR_Platform)
                      {
                      flag = false;
                      }
                  }
              }
               return flag;
           
         }
          else{
              return false;
          }
      }
      
@AuraEnabled
  public static boolean getAppFeatStatus(id recordid) {
  Id myId = recordid;
  String sObjName = myId.getSObjectType().getDescribe().getName();
      if(sObjName == 'IAM_Application__c'){
      IAM_Application__c con= new IAM_Application__c();
          if(Limits.getQueries()<Limits.getLimitQueries()){
          con = [SELECT id,IAM_Status__c,IAM_Free_Subscription__c,IAM_Application_Name__c,IAM_Account_Name__c FROM IAM_Application__c WHERE Id =:recordid];
          }
          Account a=[select id, Type from Account where id=: con.IAM_Account_Name__c];
          if(con != null){
           if(con.IAM_Status__c == 'Active'){
              if(con.IAM_Free_Subscription__c==true){
                  return true;
              }
              else{
                  if(con.IAM_Free_Subscription__c==false){
                  if(a.Type=='Individual' || ((a.Type=='LOP Customer' || a.Type== 'Internal') &&  (con.IAM_Application_Name__c=='QuickServe Online' || con.IAM_Application_Name__c=='Guidanz Mobile')))
                 // if(a.Type=='Individual' || (a.Type=='LOP Customer' &&  (con.IAM_Application_Name__c=='QuickServe Online' || con.IAM_Application_Name__c=='Guidanz Mobile')))
                  return false;
                  else
                  return true;
              }
              }
           }   
          }
          else{
          return false;
          }
      }
      //Added below If clause for D-2863 & D-2818
      if(sObjName == 'IAM_Contact_Provisioning__c'){
      
          IAM_Contact_Provisioning__c con= new IAM_Contact_Provisioning__c();
          Contact c= new Contact();
          Account a= new Account();
          if(Limits.getQueries()<Limits.getLimitQueries()){
              con = [SELECT id,IAM_Contact__c,IAM_Status__c,IAM_Application_Name__c FROM IAM_Contact_Provisioning__c WHERE Id =:recordid];
          }
          if(Limits.getQueries()<Limits.getLimitQueries()){   
              c=[Select id ,name,AccountId,IAM_Internal__c from contact where id =: con.IAM_Contact__c];
          }
          if(Limits.getQueries()<Limits.getLimitQueries()){
              a=[select id, Type from Account where id=: c.AccountId];
          }  
            if(con != null){
                  //if(a.Type=='Individual' && c.IAM_Internal__c== true && con.IAM_Status__c == 'Active' && (con.IAM_Application_Name__c=='QuickServe Online' || con.IAM_Application_Name__c=='Guidanz Mobile')) 
                  if(con.IAM_Status__c == 'Active' && (a.Type=='Individual' || a.Type=='LOP Customer' || c.IAM_Internal__c== true) && (con.IAM_Application_Name__c=='QuickServe Online' || con.IAM_Application_Name__c=='Guidanz Mobile')) 
                  {
                      return false;
                  }
                  else{
                  
                  if(con.IAM_Status__c == 'Active'){
                      return true;
                  }
                  else{
                      return false;
                  }
                  }
                  
              }
              
              else{
              return false;
              }
          }
      else{
          return false;
      }
  }

   //Amarnath Mishra modified the logic as per the new requirement.
  @AuraEnabled
  public static map<string,list<String>> getRoles(String recordId){
      map<string,list<String>> returnString= new map<string,list<String>>();
      list<String> splitRole=new list<string>();
      list<String> splitModularity = new list<String>();
      list<String> lstsplitRole=new list<string>();
      list<String> lstsplitModularity = new list<String>();
      list<String> lstcustomerlist = new list<String>();
      list<String> lstError = new list<String>();
      list<String> lstApplicationName = new list<String>();
      string OSMstorefront =Label.IAM_OSM_ContPro_Default_Roles;
      List<PermissionSetAssignment> assignedPSList = new List<PermissionSetAssignment>();// OSM D-3265 Nishant Verma
      Boolean haveaccess=false; // OSM D-3265 Nishant Verma
      
      lstError.add('No value Found');
      list<IAM_Application__c> app=new List<IAM_Application__c>();
      if(Limits.getQueries()<Limits.getLimitQueries()){
      app=[SELECT id,IAM_Account_Name__c,IAM_Application_Name__c,IAM_Account_Name__r.CMI_CId__c,IAM_Cumpas_Modularity__c,IAM_Role__c,IAM_Account_Name__r.IsPartner,IAM_Account_Name__r.type from IAM_Application__c where Id=:RecordId];
      assignedPSList=[SELECT AssigneeId,PermissionSet.Name FROM PermissionSetAssignment where AssigneeId=:Userinfo.getUserId()];    // OSM D-3265 Nishant Verma
      }
      // OSM D-3265 Nishant Verma
      If(!assignedPSList.isempty()){
          for(PermissionSetAssignment assignedPSObj:assignedPSList){
              if(assignedPSObj.PermissionSet.Name =='OSM_Distributor_Admin' || assignedPSObj.PermissionSet.Name=='OSM_Support_Admin'){
                  haveaccess=true;
              }
          }
          system.debug('haveaccess@@@@@'+haveaccess);
      }
      
      if(!app.isEmpty()){
          if(!String.isEmpty(app[0].IAM_Role__c)){
              if(app[0].IAM_Application_Name__c ==System.Label.IAM_OSM_App_Name){  // OSM D-3265 Nishant Verma
                  if((App[0].IAM_Account_Name__r.type != 'Distributor Account' || App[0].IAM_Account_Name__r.type != 'Distributor Branch Account') && haveaccess){
                      system.debug('Cooming First if');
                      System.debug('Prinitng role value in role'+App[0].IAM_Role__c);
                      if(App[0].IAM_Role__c.ContainsIgnoreCase('OSM Storefront Admin')){
                           system.debug('Cooming 2 if');
                          List<String> OSMRole =App[0].IAM_Role__c.split(';');
                          for(String roleObj :OSMRole){
                              System.debug('Printing role object'+roleObj);
                              if(roleObj.equalsIgnoreCase(System.Label.IAM_OSM_ContPro_Default_Roles)){
                                  system.debug('Cooming 2 if');
                                  splitRole.add(roleObj);
                                  break;
                              }
                          }
                      }
                  }else{
                      splitRole=app[0].IAM_Role__c.Split(';');
                  }  //// OSM D-3265 Nishant Verma
              }else{
                  splitRole=app[0].IAM_Role__c.Split(';');
              }
              if(!splitRole.isEmpty()){
                  lstsplitRole.add('--Select--');  
                  for(string str:splitRole){
                          lstsplitRole.add(str);
                      }
                  returnString.put('Roles',lstsplitRole);             
              }else{
                  returnString.put('Roles',lstError);
              }
          }else{
             returnString.put('Roles',lstError);
          }
          if((app[0].IAM_Application_Name__c == System.Label.IAM_AppName_Cumpas ) && (!String.isEmpty(app[0].IAM_Cumpas_Modularity__c))){
              splitModularity = app[0].IAM_Cumpas_Modularity__c.Split(';');
              if(!splitModularity.isEmpty()){
                  lstsplitModularity.add('--Select--');  
                  for(string str:splitModularity){
                      lstsplitModularity.add(str);
                  }
                  returnString.put('Modularity',lstsplitModularity);
              }
              else{
                  returnString.put('Modularity',lstError);
              }
              
          }
          
          if(app[0].IAM_Application_Name__c == System.Label.IAM_AppName_ConnectedSolutions && (!String.isEmpty(app[0].IAM_Account_Name__r.CMI_CId__c))) {
              lstcustomerlist.add(app[0].IAM_Account_Name__r.CMI_CId__c);
              returnString.put('Customerlist',lstcustomerlist);
              
          }
          
          if(!String.isEmpty(app[0].IAM_Application_Name__c)){
              lstApplicationName.add(app[0].IAM_Application_Name__c);
              returnString.put('ApplicationName',lstApplicationName);
          }
          else{
              returnString.put('ApplicationName',lstError);
          }
      }
      
      
      System.debug('Printing return String'+returnString);
      return returnString;
  }
  
  //Amarnath Mishra updated for the UAT issue D3053    
  @AuraEnabled
  Public Static Map<String,List<Contact>> getContacts(String recordId,String role,String moudularity){
    
     System.debug('Printing record ID '+recordId);
      System.debug('Printing role '+role);
      System.debug('Printing Modularity '+moudularity);
      Map<String,List<Contact>> ContactToDisplay=new Map<String,List<Contact>>();
      List<Contact> selected= new List<Contact>();
      List<Contact> available=new List<Contact>();
      List<Contact> errorContact= new List<Contact>();
      List<IAM_Contact_Provisioning__c> appCons= new List<IAM_Contact_Provisioning__c>();
      Boolean isCSTApplication=false;
      List<IAM_Application__c> app= new List<IAM_Application__c>();
      Set<id> qsolConIDS= new Set<id>();
      List<IAM_Application__c> qsolApps= new List<IAM_Application__C>();
      List<IAM_Contact_Provisioning__c> qsolConProv= new List<IAM_Contact_Provisioning__c>();
      if(Limits.getQueries()<Limits.getLimitQueries()){
      app=[SELECT id,IAM_Application_Name__c,IAM_Account_Name__c from IAM_Application__c where Id=:RecordId]; 
      }
      System.debug('Printing app'+app);
      String queryString;
      if(!app.isEmpty()){
      //harshini
      //Karthik Adding changes to filter out the contacts for CST application access.
      //made changes below to below query qsolConProv to fetch records with pending status as well - @Anupam
          if(app[0].IAM_Application_Name__c=='Cummins Service Training'){
       qsolApps = [SELECT id,IAM_Application_NAme__c,IAM_Status__C FROM IAM_Application__C wHERE IAM_Account_NAme__c=:app[0].IAM_Account_Name__c AND IAM_Application_NAme__C='QuickServe Online' AND IAM_Status__C='Active'];
          if(!qsolApps.isEmpty()){
              qsolConProv=[SELECT id,IAM_Contact__c FROM IAM_Contact_Provisioning__c WHERE IAM_Account_Application__c=:qsolApps and (IAM_Status__c='Active' OR IAM_Status__c='Pending')];
              if(!qsolConProv.isEmpty()){
                  for(IAM_contact_Provisioning__c conp:qsolConProv){
                      qsolConIDS.add(conp.IAM_Contact__c);
                  }
                  if(!qsolConIDS.isEmpty()){
                      isCSTApplication=True;
                  }
              }
          }
      }
          System.debug('Printing qsolConIS'+qsolConIDs);
          //End of changes.
          //string status = 'Active';
          List<String> statusList = new List<String>{'Active','Pending'};
          //SonarQube fix
          //made changes below to both query string to fetch records with pending status as well - @Anupam
          if(app[0].IAM_Application_Name__c == System.Label.IAM_AppName_Cumpas){
              system.debug('==Inside cumpas application===');
              //queryString = 'SELECT Id, IAM_Role__c,IAM_Contact__c FROM IAM_Contact_Provisioning__c  WHERE IAM_Account_Application__c=\''+ app[0].Id +'\' and IAM_Status__c=\''+String.escapeSingleQuotes(status)+'\' and IAM_Role__c INCLUDES(\'' + String.escapeSingleQuotes(role) + '\') and IAM_Cumpas_Modularity__c INCLUDES(\'' + String.escapeSingleQuotes(moudularity) + '\')';
              queryString = 'SELECT Id, IAM_Role__c,IAM_Contact__c FROM IAM_Contact_Provisioning__c  WHERE IAM_Account_Application__c=\''+ app[0].Id +'\' and IAM_Role__c INCLUDES(\'' + String.escapeSingleQuotes(role) + '\') and IAM_Cumpas_Modularity__c INCLUDES(\'' + String.escapeSingleQuotes(moudularity) + '\')'+'and IAM_Status__c IN:statusList';
          }
          else{
              system.debug('==Inside other application===');
              //queryString = 'SELECT Id, IAM_Role__c,IAM_Contact__c FROM IAM_Contact_Provisioning__c  WHERE IAM_Account_Application__c=\''+ app[0].Id +'\' and IAM_Status__c=\''+String.escapeSingleQuotes(status)+'\' and IAM_Role__c INCLUDES(\'' + String.escapeSingleQuotes(role) + '\')';
              queryString = 'SELECT Id, IAM_Role__c,IAM_Contact__c FROM IAM_Contact_Provisioning__c  WHERE IAM_Account_Application__c=\''+ app[0].Id +'\' and IAM_Role__c INCLUDES(\'' + String.escapeSingleQuotes(role) + '\')'+'and IAM_Status__c IN:statusList';
          }
          
          system.debug('queryString=='+queryString);        
           appCons = (List<IAM_Contact_Provisioning__c>)Database.query(queryString);
          Set<String> setContactIds = new Set<String>();
          for(IAM_Contact_Provisioning__c con:appCons){
              setContactIds.add(con.IAM_Contact__c);
          }
          //system.debug('aL=='+aL);//harshini
          //appCons=[SELECT id,IAM_Contact__c FROM IAM_Contact_Provisioning__c Where IAM_Account_Application__c=:app[0].Id and IAM_Status__c='Active' and IAM_Role__c=:role];
          System.debug('Printing con apps'+appCons);
          List<Contact> allContacts= new List<Contact>();
          if(Limits.getQueries()<Limits.getLimitQueries()){
              if(isCSTApplication){
                allContacts=[Select id,Name,FirstName,LastName,email,IAM_Contact_Status__c,IAM_Internal__c,Username__c from Contact where AccountId=:app[0].IAM_Account_Name__c AND (IAM_Contact_Status__c='Active' OR IAM_Contact_Status__c='Reclaim') and id=:qsolConIDS ORDER BY LastName ASC];  
              }else{
                  allContacts=[Select id,Name,FirstName,LastName,email,IAM_Contact_Status__c,IAM_Internal__c,Username__c from Contact where AccountId=:app[0].IAM_Account_Name__c AND (IAM_Contact_Status__c='Active' OR IAM_Contact_Status__c='Reclaim') ORDER BY LastName ASC];
              }
              //allContacts=[Select id,Name,FirstName,LastName,email,IAM_Contact_Status__c,IAM_Internal__c,Username__c from Contact where AccountId=:app[0].IAM_Account_Name__c AND IAM_Contact_Status__c='Active' ORDER BY LastName ASC];
          }
          System.debug('Printing Contacts size'+allContacts.Size());
          if(!allContacts.isEmpty()){
              if(appCons.isEmpty()){
                  //Means this subscription is not tied to any contact.So selected should be null.
                  for(Contact c:allContacts){
                      available.add(c);
                  }
              }else{
                  //Means subcription is assigned to few contacts. Need to loop through contacts and Contact provisionings to seperate contacts.
                  for(Contact c:allContacts){
                      //for(IAM_Contact_Provisioning__c con:appCons){
                          if(setContactIds.Contains(c.id)){
                              //application is assigned to Contact.
                             selected.add(c); 
                          }else{
                              //application is not assigned to contact and can be displayed in the available section.
                              available.add(c);
                          }
                      //}
                  }   
              }
              //adding lists into Map.
              if(!available.isEmpty()){
             // available.sort();
              ContactToDisplay.put('available',available);
              }
              if(!selected.isEmpty()){
              ContactToDisplay.put('selected',selected);
              }
          }else{
              //Need to set that no Contacts are present at Account level 
              ContactToDisplay.put('error',errorContact);
          }
      }else{
          //set the error message string as error.
          ContactToDisplay.put('error',errorContact);
      }
      System.debug('Printing available contacts'+available.Size());
      System.debug('Printing selected contacts'+selected.size());
      System.debug('Printing total map'+ContactToDisplay);
      return ContactToDisplay;
  }
   
    //Pratima modified the logic for the bulk assign application.
    @AuraEnabled   
    public static String saveAssignedSubscription(String selectedContacts,String role,String recordId, 
    String depField) {
        String message = '';
        System.debug('selectedContacts=='+selectedContacts + ' #### role=='+role + ' #### recordId=='+recordId);  
        List<IAM_Application__c> app = new List<IAM_Application__c>();
        List<String> roles = new List<String>{role};
        List<IAM_Contact_Provisioning__c> appCons = new List<IAM_Contact_Provisioning__c>();
        Map<String,IAM_Contact_Provisioning__c> mapContactIdToProvisioning = new Map<String,IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> lstConProvisionsToDelete = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> lstConProvisionsToUpdate = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> userToCreateList = new List<IAM_Contact_Provisioning__c>();       
        app = getAccountAppList(recordId);        
        System.debug('app=='+app);    
        if(!app.isEmpty()){
            appCons = app[0].Contact_Provisionings__r;
        }
        System.debug('appCons=='+appCons);    
        for(IAM_Contact_Provisioning__c apcon : appCons) {
            if(app[0].IAM_Application_Name__c == System.Label.IAM_AppName_Cumpas) {
                if(!selectedContacts.contains(apcon.IAM_Contact__r.Username__c) 
                && apcon.IAM_Role__c == role && apcon.IAM_Cumpas_Modularity__c.contains(depField)) {
                    if(apcon.IAM_Cumpas_Modularity__c == depField) {
                        apcon.IAM_Status__c = 'Inactive';
                    } else {
                        apcon.IAM_Cumpas_Modularity__c = apcon.IAM_Cumpas_Modularity__c.remove(depField);
                        apcon.IAM_Cumpas_Modularity__c = apcon.IAM_Cumpas_Modularity__c.removeEnd(';').removeStart(';');
                    }
                    lstConProvisionsToDelete.add(apcon);
                }
            } else {
                if(!selectedContacts.contains(apcon.IAM_Contact__r.Username__c) 
                && apcon.IAM_Role__c == role) {
                    apcon.IAM_Status__c = 'Inactive';
                    lstConProvisionsToDelete.add(apcon);
                }
            }        
            if(!selectedContacts.contains(apcon.IAM_Contact__r.Username__c) 
            && apcon.IAM_Role__c.Contains(role)) {
                if(app[0].IAM_Application_Name__c != System.Label.IAM_AppName_Cumpas)
                lstConProvisionsToUpdate.add(apcon);
            }
            mapContactIdToProvisioning.put(apcon.IAM_Contact__c, apcon);
        }
        system.debug('mapContactIdToProvisioning=='+mapContactIdToProvisioning);
        system.debug('lstConProvisionsToDelete=='+lstConProvisionsToDelete);
        Id recordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(app[0].IAM_Application_Name__c).getRecordTypeId();
        List<String> lstConStr = selectedContacts.split(',');
        //added IAM_Contact_Status__c field below query for Reclaim changes CHG0065797 - @Anupam
        List<Contact> lstContacts = getContactList(lstConStr, app[0]);        
        system.debug('lstContacts=='+lstContacts);
        Set<Id> conIds = new Set<Id>();
        Set<Id> nonUserContacts = new Set<Id>();
        Set<String> usernameToCheck= new Set<String>();   
        Map<String,id> usernameToContactMap = new Map<String,id>();
        List<IAM_Contact_Provisioning__c> lstappConsToUpsert = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> listToLoop= new List<IAM_Contact_Provisioning__c>();
        boolean newrole; //added to remove unchanged records from bulk update - Chetan Gaikwad
        boolean CumpasModuleUpdateCheck;//added to remove unchanged records from bulk update for cumpas for same modules - @Suresh

        for(Contact con:lstContacts) {
            conIds.add(con.Id); 
            String tmpRole = role;
            String tmpMod = depField;
            String existingRoles;
            String existingVal;
            newrole = true;//added to remove unchanged records from bulk update - Chetan Gaikwad
            CumpasModuleUpdateCheck=false; //added to remove unchanged records from bulk update for cumpas for same modules - @Suresh
            for( IAM_Contact_Provisioning__c imConp:con.Contact_Provisionings__r) {
                listToLoop.add(imconp);
            }
            IAM_Contact_Provisioning__c contactProvisioning  = new IAM_Contact_Provisioning__c();
            if(mapContactIdToProvisioning.containsKey(con.Id)) {
                contactProvisioning.Id = mapContactIdToProvisioning.get(con.Id).Id;
                existingRoles = mapContactIdToProvisioning.get(con.Id).IAM_Role__c; 
                if(!existingRoles.contains(tmpRole)) {
                    tmpRole = existingRoles + ';'+ tmpRole;
                } else {
                    tmpRole = existingRoles;
                    newrole = false;//added to remove unchanged records from bulk update - Chetan Gaikwad
                }
                contactProvisioning.IAM_Role__c = tmpRole;
                if(app[0].IAM_Application_Name__c=='CUMPAS 2.0') {
                    existingVal = mapContactIdToProvisioning.get(con.Id).IAM_Cumpas_Modularity__c ;
                    if(existingVal!='' && existingVal!=null) {
                        if(!existingVal.contains(tmpMod)) {
                            tmpMod = existingVal + ';'+ tmpMod;
                            CumpasModuleUpdateCheck=true; //added to remove unchanged records from bulk update for cumpas for same modules - Suresh
                        } else {
                            tmpMod = existingVal;
                            //newrole = false;//added to remove unchanged records from bulk update - Chetan Gaikwad
                            CumpasModuleUpdateCheck=false; //added to remove unchanged records from bulk update for cumpas for same modules - Suresh
                        }
                        contactProvisioning.IAM_Cumpas_Modularity__c  = tmpMod;
                    }
                }                
                if(app[0].IAM_Application_Name__c=='Connected Solutions') {
                    contactProvisioning.IAM_DA_Customer_List__c  = tmpMod;
                }                
            } else {
                contactProvisioning.IAM_Contact__c = con.id;
                contactProvisioning.IAM_Application_Name__c = app[0].IAM_Application_Name__c;
                contactProvisioning.RecordTypeId =  recordTypeId;
                contactProvisioning.IAM_Role__c = tmpRole;
                if(app[0].IAM_Application_Name__c=='CUMPAS 2.0') {
                    contactProvisioning.IAM_Cumpas_Modularity__c  = tmpMod;
                }
                if(app[0].IAM_Application_Name__c=='Connected Solutions') {
                    contactProvisioning.IAM_DA_Customer_List__c  = tmpMod;
                }
                contactProvisioning.IAM_Account_Application__c = recordId;
                /* added below condition to save reclaim cont prov with pending status for Reclaim 
                changes CHG0065797 - @Anupam */
                contactProvisioning.IAM_Status__c = con.IAM_Contact_Status__c == 'Reclaim' ? 'Pending' : 'Active';
                contactProvisioning.IAM_Start_Date__c = system.today();
                contactProvisioning.IAM_Qsolexpiration__c = app[0].IAM_Qsolexpiration__c;
                contactProvisioning.IAM_Subscription_Name__c = app[0].IAM_Subscription_Name__c;
                contactProvisioning.IAM_End_Date__c=app[0].IAM_Subscription_End_Date__c;
                //FT-NPBU End Date change - @Anupam Backlog Clearance
                if(app[0].IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics)) {
                    if(app[0].IAM_Subscription_End_Date__c > system.today() + 365){
                        contactProvisioning.IAM_End_Date__c =  system.today() + 365;
                    }
                }
                contactProvisioning.IAM_userId__c=con.Username__c;
                if(app[0].IAM_Application_Name__c=='Guidanz Mobile'
                || app[0].IAM_Application_Name__c == Label.IAM_App_GuidanzMobileFieldTest) {
                    //Adding condition for Guidanz Mobile subscriptions
                    if(!String.isBlank(app[0].IAM_swregExpire__c)){
                        contactProvisioning.IAM_swregExpire__c=app[0].IAM_swregExpire__c;
                        ContactProvisioning.IAM_Guidanz_Mobile_Roles__c=tmpRole;
                    }
                }
            }        
            contactProvisioning.IAM_Source__c = app[0].IAM_Source__c; 
            system.debug('@NewRole : '+newrole);
            if(newrole||CumpasModuleUpdateCheck){//added to remove unchanged records from bulk update - Chetan Gaikwad
            lstappConsToUpsert.add(contactProvisioning);
            }//added to remove unchanged records from bulk update - Chetan Gaikwad
            userToCreateList.add(contactProvisioning);
        }
        System.debug('lstConProvisionsToUpdate ===='+lstConProvisionsToUpdate);
        if(lstConProvisionsToUpdate.size()>0) {
            for(IAM_Contact_Provisioning__c apcon : lstConProvisionsToUpdate) {
                String existingRoles = apcon.IAM_Role__c;
                List<String> lstexistingRoles = existingRoles.split(';');
                Set<String> setString = new Set<String>();
                setString.addAll(lstexistingRoles);
                System.debug('lstConProvisionsToUpdate ==existingRoles=='+existingRoles);
                System.debug('lstConProvisionsToUpdate == lstexistingRoles=='+lstexistingRoles);
                String tmpRoles = '';
                for(String strRole :lstexistingRoles) {
                    System.debug('lstConProvisionsToUpdate == strRole=='+strRole);
                    System.debug('lstConProvisionsToUpdate == role=='+role);
                    System.debug('tmpRoles == role=='+tmpRoles);
                    if(strRole != role) {
                        if(tmpRoles != '') {
                            tmpRoles = tmpRoles+ ';' + strRole;
                        } else {
                        tmpRoles = strRole;  
                        }
                    }
                    System.debug('tmpRoles == After=='+tmpRoles);   
                }
                if(tmpRoles != '') {
                existingRoles =  tmpRoles;
                }
                apcon.IAM_Role__c = existingRoles;
            }
        }
        System.debug('lstConProvisionsToUpdate ==After=='+lstConProvisionsToUpdate);
        system.debug('lstappConsToUpsert=='+lstappConsToUpsert);
    
        try {
            //code start - changed DML to unite upsert and update to avoid dual DML - Chetan Gaikwad           
            List<IAM_Contact_Provisioning__c> conProvLstUpsert = new List<IAM_Contact_Provisioning__c>();
            if(lstappConsToUpsert.size()>0) {
                //Database.upsertResult[] srList = Database.Upsert(lstappConsToUpsert,false);
                //upsert lstappConsToUpsert;
                conProvLstUpsert.addall(lstappConsToUpsert);
            }  
            if(lstConProvisionsToUpdate.size()>0 || lstConProvisionsToDelete.size()>0) {
                //Database.saveResult[] srupdate = Database.Update(lstConProvisionsToUpdate,false);
                Set<IAM_Contact_Provisioning__c> removeListSet = new Set<IAM_Contact_Provisioning__c>();
                removeListSet.addAll(lstConProvisionsToUpdate);
                removeListSet.addAll(lstConProvisionsToDelete);
                system.debug('@removeListSet : '+removeListSet);
                system.debug('@removeListSet : '+removeListSet.size());
                conProvLstUpsert.addall(removeListSet);
            }
            if(conProvLstUpsert.size()>0){
                system.debug('@conProvLstUpsert : '+conProvLstUpsert);
                system.debug('@conProvLstUpsert : '+conProvLstUpsert.size());
                upsert conProvLstUpsert;
            }
            //code end - changed DML to unite upsert and update to avoid dual DML - Chetan Gaikwad 

            if(app[0].IAM_Free_Subscription__c == false && message == ''){
                Database.saveResult srUpdateApp = Database.update(app[0],false);
            }
            if(app[0].IAM_Application_Name__c =='Marketplace') {  
                for(IAM_Contact_Provisioning__c ObjConprov :userToCreateList) {    
                    if(ObjConprov.IAM_User__c == null) {
                        System.debug('Printing application Name'+ObjConprov.IAM_Contact__r.Username__c);
                        System.debug('Printing Contact ID'+ObjConprov.IAM_Contact__c);
                        if(ObjConprov.IAM_Contact__c!=null) {
                            usernameToCheck.add(ObjConprov.IAM_userId__c);  
                            usernameToContactMap.put(ObjConprov.IAM_userId__c,ObjConprov.IAM_Contact__c);  
                        }     
                    } 
                } 
                // Need to add code logic to check for any exsisting guidnaz users.
                System.debug('Printing username To check'+usernameToCheck);
                System.debug('Printing username To usernameToContactMap'+usernameToContactMap);
                List<User> guidanzUserList=[Select id,contactId,Contact.Account.Id,username,FederationIdentifier  from User where FederationIdentifier=:usernameToCheck and isActive=True];   
                Map<String,User> guidanzUsernameToUserMap = new Map<String,User>();   
                Map<id,id> surviourToVictimConIdMap=new Map<id,id>(); 
                if(!guidanzUserList.isEmpty()) {   
                    for(User u:guidanzUserList) {    
                        guidanzUsernameToUserMap.put(u.FederationIdentifier,u); 
                    }   
                } 
                System.debug('Printing username guidanz Map'+guidanzUsernameToUserMap);
                System.debug('Prinitng username map'+guidanzUserList);    
                for(String uName:usernameToContactMap.keySet()) {  
                    if(!guidanzUsernameToUserMap.isEmpty()) {  
                        if(guidanzUsernameToUserMap.ContainsKey(uName)) {
                            if(guidanzUsernameToUserMap.get(uName).Contactid!=usernameToContactMap.get(uName)) {
                                surviourToVictimConIdMap.put(guidanzUsernameToUserMap.get(uName).Contactid,usernameToContactMap.get(uName));
                            }        
                        } else {  
                            nonUserContacts.add(usernameToContactMap.get(uName));   
                        }   
                    } else {    
                        nonUserContacts.add(usernameToContactMap.get(uName));   
                    }   
                }                      
                System.debug('Printing surviour map'+surviourToVictimConIdMap);                      
                if(!surviourToVictimConIdMap.isEmpty()) {
                    Id jobId = System.enqueueJob(new IAM_Utility(surviourToVictimConIdMap));
                } 
                
                System.debug('Contacts to create user resources'+nonUserContacts);
                if(!nonUserContacts.isEmpty()){   
                    List<Contact> lstActiveCont = IAM_contactHelperClass.getContactForUser(nonUserContacts); 
                    Id createUserJobId=System.enqueueJob(new IAM_CreateUser(lstActiveCont));  
                    System.debug('Printing return value for create user ...lstCreateUser... '+ createUserJobId);    
                }
            }
            message = 'Record Updated';
        } catch(Exception ex) {       
            if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){    
                message = ex.getdmlMessage(0);    
            } else{ 
                message ='Something went wrong. Please contact System Administrator.';    
            }
        }
        return message;
    }

    public static List<IAM_Application__c> getAccountAppList(Id recordId) {
        return [
            SELECT Id
                 , IAM_Free_Subscription__c
                 , IAM_Source__c
                 , IAM_Provisioned_User_Count__c
                 , IAM_Subscription_Count__c
                 , OSM_Max_Allowed_Users__c
                 , IAM_Account_Name__c
                 , IAM_Subscription_Name__c
                 , IAM_Qsolexpiration__c
                 , IAM_Application_Name__c
                 , IAM_swregExpire__c
                 , IAM_Subscription_End_Date__c
                 , IAM_Subscription_Start_Date__c
                 , IAM_Cumpas_Modularity__c
                 , (SELECT Id
                         , IAM_Contact__c
                         , IAM_Contact__r.Username__c
                         , IAM_Contact__r.Name,IAM_Role__c
                         , IAM_Cumpas_Modularity__c
                         , IAM_DA_Customer_List__c
                      FROM Contact_Provisionings__r 
                     WHERE (IAM_Status__c = 'Active'
                        OR IAM_Status__c = 'Pending')
                    )
              FROM IAM_Application__c
             WHERE Id = :recordId
        ];
    }

    public static List<Contact> getContactList(List<String> lstConStr, IAM_Application__c app) {
        return [
            SELECT Id
                 , Username__c
                 , IAM_Contact_Status__c
                 , (SELECT Id
                         , Name
                      FROM Contact_Provisionings__r
                     WHERE IAM_Account_Application__c = :app.Id 
                       AND IAM_Status__c = 'Active'
                   )
              FROM Contact
             WHERE Username__c IN :lstConStr
               AND AccountId = :app.IAM_Account_Name__c
               AND (RecordType.Name = 'Internal' OR RecordType.Name = 'IAM')
        ];
    }
 
 
  //fixed - D-2880 - when user reset password then only reset password email should be send instead of registration processed
  @future
  Public static void resetPasswordUser(id userid){
      System.resetPasswordWithEmailTemplate(userid,true,'IAM_Reset_Password');
  }
  
  @AuraEnabled
  Public Static String encryptUserID(String username){
      System.debug('Printing username'+username);
      //Performing encryption.
     
      
  String clearText = username.trim();
  //32 byte string. since characters used are ascii, each char is 1 byte.
   Blob key = Blob.valueOf('1234567890123456');
  Blob cipherText = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(clearText));
  String encodedCipherText = EncodingUtil.base64Encode(cipherText); 
  System.debug('Printing Names'+encodedCipherText);
  String urlEncode=EncodingUtil.urlEncode(encodedCipherText, 'UTF-8');
  System.debug('Encoded text'+urlEncode);
  Blob encodedEncryptedBlob = EncodingUtil.base64Decode(encodedCipherText);
  Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', key, encodedEncryptedBlob);
  String decryptedClearText = decryptedBlob.toString();
  System.debug('Decoed text'+decryptedClearText);
      
  
     return urlEncode;   
  }
  
  
 /* @AuraEnabled
  Public Static String encryptTheUserID(String username){
      System.debug('Printing username'+username);
      //Performing encryption.
     
      
  String clearText = username.trim();
  //32 byte string. since characters used are ascii, each char is 1 byte.
  Blob key = Blob.valueOf('1234567890123456');
  Blob cipherText = Crypto.encryptWithManagedIV('AES128', key, Blob.valueOf(clearText));
  String encodedCipherText = cipherText.toString(); 
  
      
  
     return encodedCipherText ;  
  }
  
  
  @AuraEnabled
  public static String decrypt(String username){
  
  Blob key = Blob.valueOf('1234567890123456');
  Blob dest = Blob.valueOf(username);
  Blob decrypted = Crypto.decryptWithManagedIv('AES128', key, dest);
  String decryptedText = decrypted.toString();
  
 return decryptedText;
 }*/
 
 
  /* Return Guidanz Mobile Field Test Role */
  @AuraEnabled
  public static List<String> getGuidanzFieldTestRole(id recordid,String selectedApp){
           
      List<String> roles= new List<String>();//Variable to store return roles to java script controller
      Set<String> appNames = new Set<String>();//Set to store the application names that we get in the map.
      
      Map<String,Boolean> appsCanBeassigned = IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
      if(!appsCanBeAssigned.isEmpty()){
          appNames = appsCanBeAssigned.KeySet();    
      }
      System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
      try{            
          List<Contact> con = [SELECT Id, AccountId FROM Contact WHERE Id = :recordid];
          System.debug('Printing Contacct names'+con);
          List<IAM_Application__c> App = [
              SELECT Id, IAM_Subscription_Name__c
                   , IAM_Application_Name__c
                   , IAM_Cumpas_Modularity__c
                   , IAM_Free_Subscription__c
                   , IAM_Role__c 
                FROM IAM_Application__c 
               WHERE IAM_Account_Name__c=:con[0].Accountid
                 AND IAM_Application_Name__c=:selectedApp
                 AND IAM_Status__c = 'Active'];
          System.debug('Printing application names'+App);
          if(!App.isempty()){                
              /*if(!String.isEmpty(App[0].IAM_Role__c)){
                  roles = App[0].IAM_Role__c.split(';');
              }*/
              for(IAM_Application__c a : App) {
                  roles.add(a.IAM_Role__c);
              }
          }else{
              roles.add('Please Contact administrator. Something went wrong');
          }
      }catch(exception e){
          system.debug('Printing exception'+e.getStackTraceString());
          System.debug('Printing exception messgae'+e.getMessage());
          roles.add('Please Contact administrator. Something went wrong');
      }
      System.debug('Printing optionRole'+roles);
      return roles;
  }   
 
 
 //Added method for Fleetguard Fit
  @AuraEnabled
      Public Static String saveFreeAppFleetguardFit(id recordid,String appName,String rolesNames){
          System.debug('Printing Contact id'+recordid);
          System.debug('Prinintg selected App'+appName);
          System.debug('Printing role names'+rolesNames);
          String finalRoles= '';
          if(rolesNames != null){
              //for(String a:rolesNames){
             //     finalRoles=+a;
              //}
              finalRoles = rolesNames;
          }
          
          System.debug('Printing final Role Values'+finalRoles);
          
          String returnValue='';
          Try{
              List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c,IAM_Legacy_User__c,IAM_Internal__c,Username__c from Contact where id=:recordId];
              if(!Con.isEmpty()){
                List<IAM_Application__c> appMarketPlace=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
                System.debug('Prinitng application Name'+appMarketPlace);
                  if(!appMarketPlace.isEmpty()){
                  //Now we can assign Guidanz application to Contact
                  
                  IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                  conProv.IAM_Application_Name__c=appName;
                          conProv.IAM_Account_Application__c=appMarketPlace[0].id;
                      if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                          conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                      }else{
                          conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                      }
                  conProv.IAM_Start_Date__c=System.Today();
                   
                  conProv.IAM_Role__c=finalRoles;
                  conProv.IAM_End_Date__c=appMarketPlace[0].IAM_Subscription_End_Date__c;
                  ConProv.IAM_Contact__c=Con[0].id;
                  ConProv.IAM_Subscription_Name__c = appMarketPlace[0].IAM_Subscription_Name__c;
                  System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                  conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                  
                  list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                  list<String> sss = new list<String>();
                  string myMsg;
                  lstconpro.add(conProv);
                  //insert conProv;
                  boolean createuser;
                  Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                  createUser=dataBaseSaveSuccessValue(lstSR2);
                  myMsg=databaseErrorString(lstSR2);
                  /*for (Database.SaveResult sr : lstSR2) {
                      if (sr.isSuccess()) {
                      System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                          createuser= true;
                      }
                      else {              
                          for(Database.Error err : sr.getErrors()) {
                          myMsg=err.getMessage();
                          if (err instanceof Database.DuplicateError) {
                                      myMsg='';
                                      myMsg=System.Label.IAM_Existing_Provisioning_Error;
                                      Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                                      Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                                      Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                                      Datacloud.MatchResult matchResult = matchResults[0];
                                      Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                       for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                          System.debug('MatchRecord: ' + matchRecord.getRecord());
                                          sss.add(matchRecord.getRecord().Id);
                                          }
                                  }
                          if(!sss.isEmpty() && sss!=null)
                          {IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                          myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                          }
                             
                              System.debug('===myMsg==='+myMsg);
                          }
                      }
                  }*/
                      if(createuser && Con[0].IAM_Legacy_User__c && !Con[0].IAM_Internal__c ){
                          List<user> usr =[Select id from user where contactid=:con[0].Id];
                          if(usr.isempty()){
                              List<Contact> conobj=[select id,IAM_Site_Admin__c,IAM_Site_Admin_Role__c,FirstName,LastName,Email,IAM_Internal__C,IAM_Legacy_User__c,Account.OwnerId,Account.CMI_Account_Num__c,Phone,IAM_Contact_Status__c,IAM_Applications__c,IAM_Final_Approver__c,Username__c,IAM_Work_Group_Id__c,CMI_Contact_Type__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,Account.Location__c,Account.Recordtype.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_ABO_Code_Formula__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,Account.Type,Account.IAM_WWSPS_Regions__c,Account.IAM_Movex_Customer_Code__c,(select id,IAM_Application_Name__c,IAM_DA_Customer_List__c,IAM_RLS_Customer_Number__c, IAM_RLS_Group_Admin_Email__c,IAM_Role__c,IAM_Status__c,IAM_Active_Contact_Provisioning__c from Contact_Provisionings__r where IAM_Active_Contact_Provisioning__c=:recordid) from contact where id=:recordid Limit 1];
                              if(!Test.isRunningTest()){  
                              IAM_CreateUser.CreateUser(conobj);  
                              }
                          }
                      }
                      if(createuser && Con[0].IAM_Legacy_User__c && Con[0].IAM_Internal__c){
                          List<user> usr =[Select id from user where FederationIdentifier=:con[0].Username__c];
                          if(usr.isempty()){
                              List<Contact> conobj=[select id,IAM_Site_Admin__c,IAM_Site_Admin_Role__c,FirstName,LastName,Email,IAM_Internal__c,IAM_Legacy_User__c,Account.OwnerId,Account.CMI_Account_Num__c,Phone,IAM_Contact_Status__c,IAM_Applications__c,IAM_Final_Approver__c,Username__c,IAM_Work_Group_Id__c,CMI_Contact_Type__c,IAM_is_Member_of__c,IAM_Product_Group_Access__c,Account.Location__c,Account.Recordtype.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,Account.IAM_ABO_Code_Formula__c,Account.IAM_Service_Provider_Code__c,Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,Account.Type,Account.IAM_WWSPS_Regions__c,Account.IAM_Movex_Customer_Code__c,(select id,IAM_Application_Name__c,IAM_DA_Customer_List__c,IAM_RLS_Customer_Number__c, IAM_RLS_Group_Admin_Email__c,IAM_Role__c,IAM_Status__c,IAM_Active_Contact_Provisioning__c from Contact_Provisionings__r where IAM_Active_Contact_Provisioning__c=:recordid) from contact where id=:recordid Limit 1];
                              if(!Test.isRunningTest()){  
                              IAM_CreateUser.CreateUser(conobj);  
                              }
                          }
                      }
                  if(myMsg!='' && myMsg!=null&&!CreateUser){
                      return myMsg;
                  }
                  else{
                      returnValue='Record Created';
                  }
                  
                }else{
                  //This section for Contact is not present
                  returnValue='Something unexpected happened, please contact your System Administrator.';
                }
              }else{
              //This section for Contact is not present
              returnValue='Something unexpected happened, please contact your System Administrator.';
              }
          }
          catch(exception e){
          System.debug('Priniting Exception'+e);
              
                      returnValue = 'Something unexpected happened please contact System Administrator';
                 
          }       
          return returnValue;
      }
  
  // Added For Fleetguard Fit roles
  @AuraEnabled
      Public Static List<String> getFleetguardFitRole(id recordid,String selectedApp){
           
          List<String> roles= new List<String>();//sVariable to store return roles to java script controller
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          try{
          
          List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
          System.debug('Printing application names'+App);
          if(!App.isempty()){
              
              if(!String.isEmpty(App[0].IAM_Role__c)){
                  roles=App[0].IAM_Role__c.split(';');
              }
          }else{
              roles.add('Please Contact administrator. Something went wrong');
          }
          }catch(exception e){
              system.debug('Printing exception'+e.getStackTraceString());
              System.debug('Printing exception messgae'+e.getMessage());
              roles.add('Please Contact administrator. Something went wrong');
          }
          System.debug('Printing optionRole'+roles);
          return roles;
      }
      @AuraEnabled
      Public Static List<String> getFluidwatchRole(id recordid,String selectedApp){
           
          List<String> roles= new List<String>();//sVariable to store return roles to java script controller
          Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
          
          Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
          if(!appsCanBeAssigned.isEmpty()){
              appNames=appsCanBeAssigned.KeySet();    
          }
          System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
          try{
          
          List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
          System.debug('Printing Contacct names'+con);
          List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
          System.debug('Printing application names'+App);
          if(!App.isempty()){
              
              if(!String.isEmpty(App[0].IAM_Role__c)){
                  roles=App[0].IAM_Role__c.split(';');
              }
          }else{
              roles.add('Please Contact administrator. Something went wrong');
          }
          }catch(exception e){
              system.debug('Printing exception'+e.getStackTraceString());
              System.debug('Printing exception messgae'+e.getMessage());
              roles.add('Please Contact administrator. Something went wrong');
          }
          System.debug('Printing optionRole'+roles);
          return roles;
      }
    @AuraEnabled
    Public Static String saveFreeAppFluidWatch(id recordid,String appName,List<String> rolesNames){
        System.debug('Printing Contact id'+recordid);
        System.debug('Prinintg selected App'+appName);
        System.debug('Printing role names'+rolesNames);
        String finalRoles= '';
        if(!rolesNames.isEmpty()){
            for(String a:rolesNames){
                finalRoles=+a;
            }
            
        }
        
        System.debug('Printing final Role Values'+finalRoles);
        
        String returnValue='';
        Try{
            List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c,IAM_Legacy_User__c,IAM_Internal__c,Username__c from Contact where id=:recordId];
            if(!Con.isEmpty()){
              List<IAM_Application__c> appMarketPlace=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
              System.debug('Prinitng application Name'+appMarketPlace);
                if(!appMarketPlace.isEmpty()){
                //Now we can assign Guidanz application to Contact
                
                IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                conProv.IAM_Application_Name__c=appName;
                        conProv.IAM_Account_Application__c=appMarketPlace[0].id;
                    if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                        conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                    }else{
                        conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                    }
                conProv.IAM_Start_Date__c=System.Today();
                 
                conProv.IAM_Role__c=finalRoles;
                conProv.IAM_End_Date__c=appMarketPlace[0].IAM_Subscription_End_Date__c;
                ConProv.IAM_Contact__c=Con[0].id;
                ConProv.IAM_Subscription_Name__c = appMarketPlace[0].IAM_Subscription_Name__c;
                System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                
                list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                list<String> sss = new list<String>();
                string myMsg;
                lstconpro.add(conProv);
                //insert conProv;
                boolean createuser;
                Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                createUser=dataBaseSaveSuccessValue(lstSR2);
                myMsg=databaseErrorString(lstSR2);
                /*for (Database.SaveResult sr : lstSR2) {
                    if (sr.isSuccess()) {
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                        createuser= true;
                    }
                    else {              
                        for(Database.Error err : sr.getErrors()) {
                        myMsg=err.getMessage();
                        if (err instanceof Database.DuplicateError) {
                                    myMsg='';
                                    myMsg=System.Label.IAM_Existing_Provisioning_Error;
                                    Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                                    Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                                    Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                                    Datacloud.MatchResult matchResult = matchResults[0];

                                    Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                     for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                        System.debug('MatchRecord: ' + matchRecord.getRecord());
                                        sss.add(matchRecord.getRecord().Id);
                                        }
                                }
                        if(!sss.isEmpty() && sss!=null)
                        {IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                        myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                        }
                           
                            System.debug('===myMsg==='+myMsg);
                        }
                    }
                }*/
                if(myMsg!='' && myMsg!=null&&!CreateUser){
                    return myMsg;
                }
                else{
                    returnValue='Record Created';
                }
                
              }else{
                //This section for Contact is not present
                returnValue='Something unexpected happened, please contact your System Administrator.';
              }
            }else{
            //This section for Contact is not present
            returnValue='Something unexpected happened, please contact your System Administrator.';
            }
        }
        catch(exception e){
        System.debug('Priniting Exception'+e);
        
                
                    returnValue = 'Something unexpected happened please contact System Administrator';
                
        }       
        return returnValue;
    }   
 
    //Method Added by Karthik on 01/31/2021
    Public Static string fieldCustomValidation(Exception ex){
      String returnmessage='';
        if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){

                      returnmessage = ex.getdmlMessage(0);
                  }
                  else{
                      returnmessage ='Something went wrong. Please contact System Administrator.';
                  }
          return returnmessage;
    }
    
    //Method added by Karthik on 02/13/2021 -Code Optimization.
    Public Static Boolean dataBaseSaveSuccessValue(Database.SaveResult[] saveResult){
        Boolean createUser=false;
        for(Database.SaveResult sr:saveResult){
            if(sr.isSuccess()){
                createUser=True;
            }else if(!sr.isSuccess()){
                createUser=false;
            }
        }
        return createUser;
    }
    
    //Method added by Karthik on 02/13/2021 -Code Optimization.
    Public Static String databaseErrorString(Database.SaveResult[] saveResult){
        String errorMessage='';
        List<String> sss = new List<String>();
        for(Database.SaveResult sr: saveResult){
            for(Database.Error err : sr.getErrors()){
                errorMessage=err.getMessage();
                        if (err instanceof Database.DuplicateError) {
                            
                            //Adding method to optimizize the code.
                            errorMessage='';
                            errorMessage=System.Label.IAM_Existing_Provisioning_Error;
                            Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                            Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                            Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                            Datacloud.MatchResult matchResult = matchResults[0];

                            Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                            for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                System.debug('MatchRecord: ' + matchRecord.getRecord());
                                sss.add(matchRecord.getRecord().Id);
                            }
                        }
                    if(!sss.isEmpty() && sss!=null){
                        IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                        errorMessage=conP.IAM_Application_Name__c + ' : '+errorMessage+':'+conP.id;
                    }
                    System.debug('===myMsg==='+errorMessage);
            }
        }
        if(String.isEmpty(errorMessage)){
            errorMessage='Something is wrong. Please reach out to System Administrator.';
        }
        return errorMessage;
    }
	
	 //Global Dealer Portal - D-3194 added method for getting Global Dealer Portal roles - @Anupam
     @AuraEnabled
     Public Static List<String> getGlobalDealerPortalRole(id recordid,String selectedApp){
          
         List<String> roles= new List<String>();//sVariable to store return roles to java script controller
         Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
         
         Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
         if(!appsCanBeAssigned.isEmpty()){
             appNames=appsCanBeAssigned.KeySet();    
         }
         System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
         try{
         
         List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
         System.debug('Printing Contacct names'+con);
         List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
         System.debug('Printing application names'+App);
         if(!App.isempty()){
             
             if(!String.isEmpty(App[0].IAM_Role__c)){
                 roles=App[0].IAM_Role__c.split(';');
             }
         }else{
             roles.add('Please Contact administrator. Something went wrong');
         }
         }catch(exception e){
             system.debug('Printing exception'+e.getStackTraceString());
             System.debug('Printing exception messgae'+e.getMessage());
             roles.add('Please Contact administrator. Something went wrong');
         }
         System.debug('Printing optionRole'+roles);
         return roles;
     }
   
   // Fix - 3194 - save logic for GDP app
     @AuraEnabled
     Public Static String saveFreeAppGlobalDealerPortal(id recordid,String appName,List<String> rolesNames){
         System.debug('Printing Contact id'+recordid);
         System.debug('Prinintg selected App'+appName);
         System.debug('Printing role names'+rolesNames);
         String finalRoles = '';
         Boolean creation=false;
         if(!rolesNames.isEmpty()){
             for(String a:rolesNames){
                 System.debug('role...... ' + a);
                 finalRoles = finalRoles + a + ';';
                 System.debug('finalRoles...... ' + finalRoles);
             }
             finalRoles = finalRoles.removeEnd(';');
         }
         
         System.debug('Printing final Role Values'+finalRoles);
         
         String returnValue='';
   
         Try{
             List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c from Contact where id=:recordId];
             if(!Con.isEmpty()){
               List<IAM_Application__c> appGDP=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
               System.debug('Prinitng application Name--->'+appGDP);
                 if(!appGDP.isEmpty()){
                 //Now we can assign Global Dealer Portal application to Contact
                 
                 IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                 conProv.IAM_Application_Name__c=appName;
                         conProv.IAM_Account_Application__c=appGDP[0].id;
                     if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                         conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                     }else{
                         conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                     }
                 conProv.IAM_Start_Date__c=System.Today();
                 conProv.IAM_Role__c=finalRoles;
                 conProv.IAM_End_Date__c=appGDP[0].IAM_Subscription_End_Date__c;
                 ConProv.IAM_Contact__c=Con[0].id;
                 ConProv.IAM_Subscription_Name__c = appGDP[0].IAM_Subscription_Name__c;
                 System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                 conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                 
                 list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                 list<String> sss = new list<String>();
                 string myMsg;
                 lstconpro.add(conProv);
                 //insert conProv;
                 
                 Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                 myMsg=databaseErrorString(lstSR2);
                 creation=dataBaseSaveSuccessValue(lstSR2);
                 /*for (Database.SaveResult sr : lstSR2) {
                     if (sr.isSuccess()) {
                     System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                     }
                     else {              
                         for(Database.Error err : sr.getErrors()) {
                         myMsg=err.getMessage();
                         if (err instanceof Database.DuplicateError) {
                                     myMsg='';
                                     myMsg=System.Label.IAM_Existing_Provisioning_Error;
                                     Database.DuplicateError duplicateError =   (Database.DuplicateError)err;
                                     Datacloud.DuplicateResult duplicateResult =  duplicateError.getDuplicateResult();
                                     Datacloud.MatchResult[] matchResults =  duplicateResult.getMatchResults();
                                     Datacloud.MatchResult matchResult = matchResults[0];
 
                                     Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();
                                      for (Datacloud.MatchRecord matchRecord : matchRecords) {
                                         System.debug('MatchRecord: ' + matchRecord.getRecord());
                                         sss.add(matchRecord.getRecord().Id);
                                         }
                                 }
                         if(!sss.isEmpty() && sss!=null)
                         {IAM_Contact_Provisioning__c conP=[select id,IAM_Application_Name__c,name from IAM_Contact_Provisioning__c where id=:sss[0]];
                         myMsg=conP.IAM_Application_Name__c + ' : '+myMsg+':'+conP.id;
                         }
                          System.debug('===myMsg==='+myMsg);
                         }
                     }
                 }*/
                 if(myMsg!='' && myMsg!=null && !creation){
                     return myMsg;
                 }
                 else{
                     returnValue='Record Created';
                 }
                 
               }else{
                 //This section for Contact is not present
                 returnValue='Something unexpected happened, please contact your System Administrator.';
               }
             }else{
             //This section for Contact is not present
             returnValue='Something unexpected happened, please contact your System Administrator.';
             }
         }
         catch(exception e){
         System.debug('Priniting Exception'+e);
             returnValue = e.getdmlMessage(0);
                 if(String.isBlank(returnValue)) {
                     returnValue = 'Something unexpected happened please contact System Administrator';
                 } 
         }       
         return returnValue;
     }
     /* Start - Fluid Registration Changes - @Anupam */
    @AuraEnabled
    public static List<String> getFluidRegisterRole(Id recordId, String selectedApp){
        
		List<String> roles = new List<String>();
        Set<String> appNames = new Set<String>();         
        Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
        if(!appsCanBeAssigned.isEmpty()){
            appNames = appsCanBeAssigned.keySet();    
        }
        System.debug('Printing applicaion Names from app Mapping Trigger check' + appNames);
        try {
            System.debug('#### CON ID - ' + recordId);
            System.debug('#### Selected App - ' + selectedApp);
            List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE Id = :recordId];
            System.debug('Printing Contacct names' + conList);
            List<IAM_Application__c> fluidRegAppList = [
                SELECT Id
                     , IAM_Subscription_Name__c
                     , IAM_Application_Name__c
                     , IAM_Free_Subscription__c
                     , IAM_Role__c
                  FROM IAM_Application__c
                 WHERE IAM_Account_Name__c = :conList[0].AccountId 
                   AND IAM_Application_Name__c = :selectedApp
            ];
            System.debug('Printing application names ' + fluidRegAppList);
            if(!fluidRegAppList.isEmpty()){                
                if(!String.isEmpty(fluidRegAppList[0].IAM_Role__c)){
                    roles = fluidRegAppList[0].IAM_Role__c.split(';');
                }
            } else {
                roles.add('Please Contact administrator. Something went wrong');
            }
        } catch(Exception e){
            System.debug('Printing exception'+e.getStackTraceString());
            System.debug('Printing exception messgae'+e.getMessage());
            roles.add('Please Contact administrator. Something went wrong');
        }
        System.debug('Printing optionRole'+roles);
        return roles;
    }
    // Fix - 3194 - save logic for Fluids Reg app
    @AuraEnabled
    Public Static String saveFreeAppFluidRegister(id recordid,String appName,List<String> rolesNames){
        System.debug('Printing Contact id'+recordid);
        System.debug('Prinintg selected App'+appName);
        System.debug('Printing role names'+rolesNames);
        String finalRoles = '';
        Boolean creation=false;
        if(!rolesNames.isEmpty()){
            for(String a:rolesNames){
                System.debug('role...... ' + a);
                finalRoles = finalRoles + a + ';';
                System.debug('finalRoles...... ' + finalRoles);
            }
            finalRoles = finalRoles.removeEnd(';');
        }
        
        System.debug('Printing final Role Values'+finalRoles);
        
        String returnValue='';
  
        Try{
            List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c from Contact where id=:recordId];
            if(!Con.isEmpty()){
              List<IAM_Application__c> appFluidsReg=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
              System.debug('Prinitng application Name--->'+appFluidsReg);
                if(!appFluidsReg.isEmpty()){
                //Now we can assign Fluids Reg application to Contact
                
                IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                conProv.IAM_Application_Name__c=appName;
                        conProv.IAM_Account_Application__c=appFluidsReg[0].Id;
                    if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                        conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                    }else{
                        conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                    }
                conProv.IAM_Start_Date__c=System.Today();
                conProv.IAM_Role__c=finalRoles;
                conProv.IAM_End_Date__c=appFluidsReg[0].IAM_Subscription_End_Date__c == null ? System.today().addYears(100) : appFluidsReg[0].IAM_Subscription_End_Date__c;
                ConProv.IAM_Contact__c=Con[0].id;
                ConProv.IAM_Subscription_Name__c = appFluidsReg[0].IAM_Subscription_Name__c;
                System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                
                list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                list<String> sss = new list<String>();
                string myMsg;
                lstconpro.add(conProv);
                //insert conProv;
                
                Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                myMsg=databaseErrorString(lstSR2);
                creation=dataBaseSaveSuccessValue(lstSR2);
                
                if(myMsg!='' && myMsg!=null && !creation){
                    return myMsg;
                }
                else{
                    returnValue='Record Created';
                }
                
              }else{
                //This section for Contact is not present
                returnValue='Something unexpected happened, please contact your System Administrator.';
              }
            }else{
            //This section for Contact is not present
            returnValue='Something unexpected happened, please contact your System Administrator.';
            }
        }
        catch(exception e){
        System.debug('Priniting Exception'+e);
            returnValue = e.getdmlMessage(0);
                if(String.isBlank(returnValue)) {
                    returnValue = 'Something unexpected happened please contact System Administrator';
                } 
        }       
        return returnValue;
    }

    /* Start - Guidanz Service Portal Changes */
    @AuraEnabled
    public static List<String> getGuidanzServicePortalRole(Id recordId, String selectedApp){
        
		List<String> roles = new List<String>();
        Set<String> appNames = new Set<String>();         
        Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
        if(!appsCanBeAssigned.isEmpty()){
            appNames = appsCanBeAssigned.keySet();    
        }
        System.debug('Printing applicaion Names from app Mapping Trigger check' + appNames);
        try {
            System.debug('#### CON ID - ' + recordId);
            System.debug('#### Selected App - ' + selectedApp);
            List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE Id = :recordId];
            System.debug('Printing Contacct names' + conList);
            List<IAM_Application__c> appList = [
                SELECT Id
                     , IAM_Subscription_Name__c
                     , IAM_Application_Name__c
                     , IAM_Free_Subscription__c
                     , IAM_Role__c
                  FROM IAM_Application__c
                 WHERE IAM_Account_Name__c = :conList[0].AccountId 
                   AND IAM_Application_Name__c = :selectedApp
            ];
            System.debug('Printing application names ' + appList);
            if(!appList.isEmpty()){                
                if(!String.isEmpty(appList[0].IAM_Role__c)){
                    roles = appList[0].IAM_Role__c.split(';');
                }
            } else {
                roles.add('Please Contact administrator. Something went wrong');
            }
        } catch(Exception e){
            System.debug('Printing exception'+e.getStackTraceString());
            System.debug('Printing exception messgae'+e.getMessage());
            roles.add('Please Contact administrator. Something went wrong');
        }
        System.debug('Printing optionRole'+roles);
        return roles;
    }

    /*Start - Cummins API Portal Changes -@Suresh */
    @AuraEnabled
     Public Static List<String> getCumminsAPIPortalRole(id recordid,String selectedApp){
          
         List<String> roles= new List<String>();//sVariable to store return roles to java script controller
         Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
         
         Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
         if(!appsCanBeAssigned.isEmpty()){
             appNames=appsCanBeAssigned.KeySet();    
         }
         System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
         try{
         
         List<Contact> con=[Select id,Accountid from Contact where id=:recordid];
         System.debug('Printing Contacct names'+con);
         List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Application_Name__c=:selectedApp];
         System.debug('Printing application names'+App);
         if(!App.isempty()){
             
             if(!String.isEmpty(App[0].IAM_Role__c)){
                 roles=App[0].IAM_Role__c.split(';');
             }
         }else{
             roles.add('Please Contact administrator. Something went wrong');
         }
         }catch(exception e){
             system.debug('Printing exception'+e.getStackTraceString());
             System.debug('Printing exception messgae'+e.getMessage());
             roles.add('Please Contact administrator. Something went wrong');
         }
         System.debug('Printing optionRole'+roles);
         return roles;
     }
  		
     @AuraEnabled
     Public Static String saveFreeAppCumminsAPIPortal(id recordid,String appName,List<String> rolesNames){
         System.debug('Printing Cummins API Portal Contact id'+recordid);
         System.debug('Prinintg Cummins API Portal selected App'+appName);
         System.debug('Printing Cummins API Portal role names'+rolesNames);
         String finalRoles = '';
         Boolean creation=false;
         if(!rolesNames.isEmpty()){
             for(String a:rolesNames){
                 System.debug('role...... ' + a);
                 finalRoles = finalRoles + a + ';';
                 System.debug('finalRoles...... ' + finalRoles);
             }
             finalRoles = finalRoles.removeEnd(';');
         }
         
         System.debug('Printing final Cummins API Portal Role Values'+finalRoles);
         
         String returnValue='';
   
         Try{
             List<Contact> Con=[select id,Name,Account.id,IAM_Contact_Status__c from Contact where id=:recordId];
             if(!Con.isEmpty()){
               List<IAM_Application__c> appCumminsAPIPortal=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,  IAM_Subscription_Start_Date__c,  IAM_Subscription_End_Date__c,IAM_Role__c,IAM_Status__c from IAM_Application__c where IAM_Application_Name__c=:appName and IAM_Status__c='Active' and IAM_Account_Name__c=:con[0].Accountid Limit 1];
               System.debug('Prinitng application Name--->'+appCumminsAPIPortal);
                 if(!appCumminsAPIPortal.isEmpty()){
                 //Now we can assign Global Dealer Portal application to Contact
                 
                 IAM_Contact_Provisioning__c conProv= new IAM_Contact_Provisioning__c();
                 conProv.IAM_Application_Name__c=appName;
                         conProv.IAM_Account_Application__c=appCumminsAPIPortal[0].id;
                     if(Con[0].IAM_Contact_Status__c==System.Label.IAM_Status_Active){
                         conProv.IAM_Status__c=System.Label.IAM_Status_Active;
                     }else{
                         conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
                     }
                 conProv.IAM_Start_Date__c=System.Today();
                 conProv.IAM_Role__c=finalRoles;
                 conProv.IAM_End_Date__c=appCumminsAPIPortal[0].IAM_Subscription_End_Date__c;
                 ConProv.IAM_Contact__c=Con[0].id;
                 ConProv.IAM_Subscription_Name__c = appCumminsAPIPortal[0].IAM_Subscription_Name__c;
                 System.debug('Prinitng record Id'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId());
                 conProv.RecordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
                 
                 list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
                 list<String> sss = new list<String>();
                 string myMsg;
                 lstconpro.add(conProv);
                 //insert conProv;
                 
                 Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
                 myMsg=databaseErrorString(lstSR2);
                 creation=dataBaseSaveSuccessValue(lstSR2);
                 if(myMsg!='' && myMsg!=null && !creation){
                     return myMsg;
                 }
                 else{
                     returnValue='Record Created';
                 }
                 
               }else{
                 //This section for Contact is not present
                 returnValue='Something unexpected happened, please contact your System Administrator.';
               }
             }else{
             //This section for Contact is not present
             returnValue='Something unexpected happened, please contact your System Administrator.';
             }
         }
         catch(exception e){
         System.debug('Priniting Exception'+e);
             returnValue = e.getdmlMessage(0);
                 if(String.isBlank(returnValue)) {
                     returnValue = 'Something unexpected happened please contact System Administrator';
                 } 
         }       
         return returnValue;
     }
	/* End -Cummins API Portal Changes- @Suresh*/
}