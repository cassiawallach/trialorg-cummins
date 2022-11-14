/************************************************************
Name:  IAM_Reclaim_Utility_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Test Class for Reclaim Process for Reclaim Utility. 
Changes Made for Identifying the User license.Made changes for role assignment                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakram       09/02/2020        INITIAL DEVELOPMENT 
1.1 -    Karthik Golakaram      11/14/2020      Made Changes for Warranty Profile          
*****************************************************/

@isTest
Private Class IAM_Reclaim_Utility_Test{

    @testSetup
    Static Void testDataReclaimSetup(){
    
    //Insert a record in Reclaim Tracker
    IAM_Reclaim_Tracker__c iamTracker = new IAM_Reclaim_Tracker__c();
    iamTracker.name='userLegacyReclaim'; 
    iamTracker.IAM_New_Username__c='testnewUSerreg@gmail.com';
    insert iamTracker;
    
     Account a= new Account();
        a.Name='Reclaim Account';
        a.Type='Dealer Account';
        a.Recordtypeid= Schema.sObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        a.IAM_Service_Provider_Code__c='423415';
        a.CSS_DistributorCode__c='00000';
        a.IAM_WWSPS_Regions__c='Us and Canada';
        a.IAM_Movex_Customer_Code__c='1232323';
       // a.CSS_Locale__c='English(United States)';
        //a.CSS_Language__c='English';
        //a.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Panama)';
        insert a;
        
        List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();
         IAM_Application_Groups__c appQSOLCS= new IAM_Application_Groups__c();
         appQSOLCS.IAM_Application_Name__c='QuickServe Online';
         appQSOLCS.Name='QSOl1';
         appQSOLCS.IAM_DN_value__c='cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
         appQSOLCS.IAM_Role_Name__c='QSOL Dealer';
         lstAppGroup.add(appQSOLCS);
         
         IAM_Application_Groups__c appEDSCS= new IAM_Application_Groups__c();
         appEDSCS.IAM_Application_Name__c='EDS';
         appEDSCS.Name='EDS1';
         appEDSCS.IAM_DN_value__c='cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com';
         appEDSCS.IAM_Role_Name__c='Technician';
         lstAppGroup.add(appEDSCS);

         
         IAM_Application_Groups__c appCSTCS= new IAM_Application_Groups__c();
         appCSTCS.IAM_Application_Name__c='Cummins Service Training';
         appCSTCS.Name='CST1';
         appCSTCS.IAM_DN_value__c='cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
         appCSTCS.IAM_Role_Name__c='Service Training User';
         lstAppGroup.add(appCSTCS);
         
         IAM_Application_Groups__c appCumpasCS= new IAM_Application_Groups__c();
         appCumpasCS.IAM_Application_Name__c='CUMPAS 2.0';
         appCumpasCS.Name='Cumpas21';
         appCumpasCS.IAM_DN_value__c='cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com';
         appCumpasCS.IAM_Role_Name__c='Dealer User';
        lstAppGroup.add(appCumpasCS);
        
        IAM_Application_Groups__c appGuidanzcs= new IAM_Application_Groups__c();
         appGuidanzcs.IAM_Application_Name__c='Guidanz';
         appGuidanzcs.Name='Guidanz21';
         appGuidanzcs.IAM_DN_value__c='cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com';
         appGuidanzcs.IAM_Role_Name__c='Technician';
        lstAppGroup.add(appGuidanzcs);
        insert lstAppGroup;
        
        List<IAM_Application__c> appList= new List<IAM_Application__c>();
        
        IAM_Application__c appQSOL= new IAM_Application__c();
        appQSOL.IAM_Application_Name__c='QuickServe Online';
        appQSOL.IAM_Account_Name__c=a.id;
        appQSOL.IAM_Subscription_Name__c='QuickServe Online EBU';
        appQSOL.IAM_Role__c='QSOL Dealer';
        appQSOL.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeID();
        appQSOL.IAM_Free_Subscription__c=false;
        appQSOL.IAM_Subscription_Start_Date__c=System.Today();
        appQSOL.IAM_Subscription_End_Date__c=System.Today()+35600;
        appQSOl.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appQSOL.IAM_Status__c='Active';
        appList.add(appQSOL);
        
        IAM_Application__c appCST= new IAM_Application__c();
        appCST.IAM_Application_Name__c='Cummins Service Training';
        appCST.IAM_Account_Name__c=a.id;
        appCST.IAM_Subscription_Name__c='Cummins Service Training';
        appCST.IAM_Role__c='Service Training User';
        appCST.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeID();
        appCST.IAM_Free_Subscription__c=false;
        appCST.IAM_Subscription_Start_Date__c=System.Today();
        appCST.IAM_Subscription_End_Date__c=System.Today()+35600;
        appCST.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appCST.IAM_Status__c='Active';
        appList.add(appCST);
        
        IAM_Application__c appEDS= new IAM_Application__c();
        appEDS.IAM_Application_Name__c='EDS';
        appEDS.IAM_Account_Name__c=a.id;
        appEDS.IAM_Subscription_Name__c='QuickServe Online EBU';
        appEDS.IAM_Role__c='Technician';
        appEDS.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeID();
        appEDS.IAM_Free_Subscription__c=false;
        appEDS.IAM_Subscription_Start_Date__c=System.Today();
        appEDS.IAM_Subscription_End_Date__c=System.Today()+35600;
        appEDS.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appEDS.IAM_Status__c='Active';
        appList.add(appEDS);
        
        IAM_Application__c appCumpas= new IAM_Application__c();
        appCumpas.IAM_Application_Name__c='CUMPAS 2.0';
        //appEDS.IAM_Subscription_Name__c='QuickServe Online EBU';
        appCumpas.IAM_Role__c='Technician';
        appCumpas.IAM_Account_Name__c=a.id;
        appCumpas.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeID();
        appCumpas.IAM_Free_Subscription__c=true;
        appCumpas.IAM_Subscription_Start_Date__c=System.Today();
        appCumpas.IAM_Subscription_End_Date__c=System.Today()+35600;
        appCumpas.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appCumpas.IAM_Status__c='Active';
        appCumpas.IAM_Cumpas_Modularity__c='Parts Order';
        
        appList.add(appCumpas);
        
        
         IAM_Application__c appGuidanz= new IAM_Application__c();
        appGuidanz.IAM_Application_Name__c='Guidanz';
        //appEDS.IAM_Subscription_Name__c='QuickServe Online EBU';
        appGuidanz.IAM_Role__c='Technician';
        appGuidanz.IAM_Account_Name__c=a.id;
        appGuidanz.RecordtypeID=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeID();
        appGuidanz.IAM_Free_Subscription__c=true;
        appGuidanz.IAM_Subscription_Start_Date__c=System.Today();
        appGuidanz.IAM_Subscription_End_Date__c=System.Today()+35600;
        appGuidanz.IAM_Qsolexpiration__c='02-OCT2100EBUACTIVE';
        appGuidanz.IAM_Status__c='Active';
        appGuidanz.IAM_Cumpas_Modularity__c='Parts Order';
        
        appList.add(appGuidanz);
        
        insert appList;
        
        Contact c=new Contact();
        c.FirstName='Reclaim first';
        c.LastName='Reclaim Last';
        c.Email='oh611@cummins.com';
        c.Accountid=a.id;
        c.Username__c='extlegacyUtility';
        c.IAM_Contact_Status__c='Reclaim';
        c.Recordtypeid=Schema.sObjectType.Contact.getRecordtypeInfosByName().get('IAM').getRecordTypeId();
        c.IAM_Legacy_User__c=true;
        c.IAM_Ext_Legacy_UID__c='extlegacyUtility';
        c.IAM_Applications__c='cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com|cn=DBU_DN_DEALER_USERS,ou=App_DBU_commerce,ou=application,dc=cummins,dc=com|cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com|cn=eds_user,ou=APP_EDS,ou=application,dc=cummins,dc=com|cn=css_dn_tech,ou=app_css,ou=application,dc=cummins,dc=com';
        
        insert c;
        
    }
    
    Static TestMethod Void reclaimUtility(){
    
    List<IAM_Reclaim_Tracker__c> reclaim=[SELECT name
                                                  , IAM_New_Username__c 
                                                    FROM IAM_Reclaim_Tracker__c
                                                    WHERE name='userLegacyReclaim' ORDER BY CreatedDate LIMIT 1];
                                                    
     Contact con=[select id,firstname,lastname,email,phone,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,   
       Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c, 
       Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,   
       IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,   
       Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c, 
       Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Ext_Legacy_Uid__c,IAM_Site_Admin__c from Contact where username__c='extlegacyUtility'];
     Map<String,Boolean> reclaimTracker= new Map<String,Boolean>();
    reclaimTracker.put('Is_Contact_Update',True);
    reclaimTracker.put('Promotion API',True);
    reclaimTracker.put('Is_Assign_Permission_Set',True);
    reclaimTracker.put('Is_Guidanz_User_Update',True);
    reclaimTracker.put('Is_Create_User',True);
    reclaimTracker.put('is_LDAP_Insert_Group_Addition_API',True);
    reclaimTracker.put('is_LDAP_Insert_API',True);
                                                   
     IAM_Reclaim_Utility.updateNewUsername('userLegacyReclaim','testnewUserreg@gmail.com');
     IAM_Reclaim_Utility.UpdateReclaimTracker('testnewUserreg@gmail.com',reclaimTracker);
     IAM_Reclaim_Utility.isCSTUSer(con,'Cummins Service Training');
     IAM_Reclaim_Utility.profileToBeAssigned(con);
     IAM_Reclaim_Utility.roleToBeAssigned(con);
     IAM_Reclaim_Utility.roleOfGuidanzApplicaiton(con,'Guidanz');
     IAM_Reclaim_Utility.applicationRoles(con);
     IAM_Reclaim_Utility.allApplicationGroups(con);
     IAM_Reclaim_Utility.allAppsAndRoles(con);
     IAM_Reclaim_Utility.allApplicationGroupsFromContact(con);
     IAM_Reclaim_Utility.getUserAccessAndFeaturesForContact(con);
     IAM_Reclaim_Utility.getAccountApplications(con);
     IAM_Reclaim_Utility.contactAttributes(con.id);
     
    }
    
}