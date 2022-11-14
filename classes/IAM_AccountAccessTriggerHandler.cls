/*************************************************************************************
Author          :Amarnath Mishra
Create Date     :04/15/2019
Last Modified by:Amarnath Mishra
Description     :This class is a helper class for the trigger IAM_AccountAccessTrigger
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Amarnath Mishra                ----------        INITIAL DEVELOPMENT
1.1 -    Shubhangi Sardar               12/03/2020        Added FT-NPBU Dignostics app logic
1.2 -    Karthik Raj Golakaram          12/15/2020        Added line at Connected Solutions check.
1.3 -    Shubhangi Sardar               05/02/2021        Updated Expiration date logic for MM/DD format
1.4 -    Shubhangi Sardar               21/01/2021        Added PS Pro Subscription for Field Test Guidanz Mobile 
1.5 -    Shubhnagi Sardar               16/02/2021        Auto Creation of guidanz mobile subscription at contact level - OSM Request
1.6 -    Mohsin Sayed                   09/03/2021        Method created for AutoRenewal of Qsol subscriptions 
1.7 -    Shubhangi sardar               02/09/2021        Added method to automate GM subscriptions.
1.8 -    Vinod Kankatala                06/01/2021        Added Guidanz Mobile Power Plus subscription
1.9 -    Sandeep Vuyyuru                17/01/2021        Added chnages for Marketplace/Guidanz as prod issue 101 SOQL error fix. 
2.0 -	 Chetan Gaikwad					10/08/2022		  EDS/CST access deactivation if QSOL deactivated
**************************************************************************************/

public without Sharing class  IAM_AccountAccessTriggerHandler{
    /*
In this method we are checking whether logged in user has the access for the particular application or not. 
*/
    public static Boolean isFirstTime = true;
    public static Boolean isInsertFirstTime = false;
    public static Boolean isAfterFirstTime= true;
    public static void onBeforeInsertAndUpdate(list<IAM_Application__c> lstTriggerNew,list<IAM_Application__c> lstTriggerOld,map<id, IAM_Application__c> mapOldIdIamApplication,map<id, IAM_Application__c> mapNewIdIamApplication,boolean isBefore,Boolean isInsert){
        
        //Calling UserAccess toCheck class to identify user role
        Set<String> allRoles=IAM_userAccessCheckToModify.getHQUserRoleIDs();
        if(Userinfo.getProfileId()!=Label.IAM_Cummins_web_Profile){
            if(!IAM_userAccessCheckToModify.accountAccessFeature){
                if(allRoles.Contains(UserInfo.getUserRoleId())){
                        AccountAccessValidationForDistributor(Trigger.New,isBefore);
                    IAM_userAccessCheckToModify.accountAccessFeature=True;
                }
            }
        }
        
        validateAppAccessFields(lstTriggerNew);
        updateFields(lstTriggerNew, isInsert);
        List<Account> acnt=new List<Account>();
        Map<id,Account> acntMap= new Map<id,Account>();
        Set<id> accntId= new Set<id>();
        Map<Id,Boolean> accountChange  = new Map<Id,boolean>();  // Account Change Issue:- Nishant 
        
        for(IAM_Application__c apnt:lstTriggerNew){
            System.debug('apnt.IAM_Account_Name__c@@@'+apnt.IAM_Account_Name__c);
            accntId.add(apnt.IAM_Account_Name__c);
        }
        if(!accntId.isEmpty()){
            System.debug('Printing number of Quieries we can do'+Limits.getLimitQueries());
            System.debug('Printing number of Queries Used'+ Limits.getQueries()+'####'+accntId);
            if(Limits.getQueries()<Limits.getLimitQueries()){
                if(isFirstTime == true){//Sandeep added for 101 soql issue
                acnt=[select id,IAM_Service_Provider_Code__c,type from Account where id IN :accntId];
                }//Sandeep
            }
            if(!acnt.isEmpty()){
                for(Account a:acnt){
                    acntMap.put(a.id,a);
                }
            }
        }
        System.debug('Printing Account map'+acntMap);
        
        //Logic to update the customer code 
        for(IAM_Application__c appNew:lstTriggerNew){
            if(!acntMAp.isEmpty()){
                if(acntMap.ContainsKey(appNew.IAM_Account_Name__c)){
                    System.debug('Printing customer code that is being updated'+acntMap.get(appNew.IAM_Account_Name__c).IAM_Service_Provider_Code__c);
                    appNew.IAM_Customer_Code__c=acntMap.get(appNew.IAM_Account_Name__c).IAM_Service_Provider_Code__c;
                }
            }
            
            //Amarnath Mishra added for the UAT defect D-3208
            /*if(appNew.IAM_Status__c == System.Label.IAM_Inactive_Label && appNew.IAM_Source__c == 'Marketplace'){
                appNew.IAM_Provisioned_User_Count__c = 0;
                appNew.IAM_Subscription_Count__c = appNew.OSM_Max_Allowed_Users__c;
                
            }*/
        }
        
        
        //End of logic
        
        accountChange =IAM_Contact_Trigger_Helper.checkAccChangeFlag(accntId); // Account Change Issue:- Nishant  
        System.debug('Returnmap@@@@'+accountChange);
        list<IAM_Application__c> setAccAppRoleChangeIds = new list<IAM_Application__c>();
        if(isFirstTime==true){//Sandeep for 101 soql issue
        Map<String,Boolean> apps=IAM_Trigger_Check.checkApplicationAccess(userInfo.getUserId());
        
        System.debug('Printing application Name'+apps);
        System.debug('Printing logged in user id'+UserInfo.getProfileId());
        //AccTypeRoleValidation(lstTriggerNew); // Added for uat issue# 138, 235
        
        User user=new User();
        if(Limits.getQueries()<Limits.getLimitQueries()){
            user=[SELECT Id,profile.Name FROM User WHERE Id=:UserInfo.getUserId()];
            System.debug('user.Profile.Name'+user.Profile.Name);
            if(user.Profile.Name == System.Label.IAM_Profile_Admin_User || user.Profile.Name == System.Label.IAM_Profile_CSS_CPS_Advanced || user.Profile.Name == System.Label.IAM_Profile_CSS_Service_Technician || user.Profile.Name == System.Label.IAM_Profile_CSS_Service_Advanced || user.Profile.Name == System.Label.IAM_Profile_CMI_System_Admin || user.Profile.Name == System.Label.IAM_Profile_PC_Admin || user.Profile.Name == System.Label.IAM_Profile_CSS_Support){
                for(IAM_Application__c application:lstTriggerNew){
                    if(!accountChange.get(application.IAM_Account_Name__c)){
                    if(!apps.isEmpty()){
                        System.debug('Printing conditions'+apps.ContainsKey(application.IAM_Application_Name__c));
                        if(apps.ContainsKey(application.IAM_Application_Name__c)){
                            System.debug('Printing has access');
                            if(mapOldIdIamApplication!=null && !mapOldIdIamApplication.IsEmpty()){
                                if((application.IAM_Role__c != mapOldIdIamApplication.get(application.id).IAM_Role__c && 
                                    application.IAM_Role__c != '' && application.IAM_Role__c != null ) || (application.IAM_Cumpas_Modularity__c != mapOldIdIamApplication.get(application.id).IAM_Cumpas_Modularity__c && 
                                                                                                           application.IAM_Cumpas_Modularity__c != '' && application.IAM_Cumpas_Modularity__c != null )) {
                                                                                                               setAccAppRoleChangeIds.add(application);
                                                                                                               system.debug('Account level id@@@Role Change'+application.id);
                                                                                                               if(setAccAppRoleChangeIds != null && !setAccAppRoleChangeIds.isEmpty() ) {
                                                                                                                   UpdateAccRole(setAccAppRoleChangeIds);
                                                                                                               }   
                                                                                                               
                                                                                                           }
                            }
                        }   
                        else{
                            System.debug('CAme to exception place');
                            application.Adderror('Insufficient Access Privileges');
                            //throw new AuraHandledException('Insufficient Access Privilages.');
                        }    
                    }
                    else{
                        System.debug('CAme to exception place');
                        application.Adderror('Insufficient Access Privileges');
                        //throw new AuraHandledException('Insufficient Access Privilages.');
                    }
                }
            }
            
        }
        if(!accountChange.Isempty()){
            IAM_Contact_Trigger_Helper.unCheckAccChangeFlag(accntId);
        }
    }
    
    //Code part for Connected solutions where we need to change the status to Active and CDA status to Signed by customer
    if(isinsert && isBefore){
        if(lstTriggerNew.size()>0){
            for(IAM_Application__c application:lstTriggerNew){
                system.debug('testing Status@@@@@@@');
                if(acntMap.ContainsKey(application.IAM_Account_Name__c)){ //Added by Karthik Raj Golakaram - 12/14/2020
                    if(acntMap.get(application.IAM_Account_Name__c).Type == 'Distributor Account' && application.IAM_Application_Name__c == System.Label.IAM_AppName_ConnectedSolutions&&application.IAM_Status__c!='Inactive'){
                        System.debug('Printing application Name CDA Status Update');
                        application.IAM_Status__c='Active';
                        application.CMI_CDA_Status__c ='Signed by Customer';
                    } 
                }
            }
        }
    }       
    
    //This code will execute on before update D-3175
    if(isInsert==false)
    {
        List<IAM_Application__c> lstInactiveApp = new List<IAM_Application__c>();
        for(IAM_Application__c accApp : lstTriggerNew) {
            if(accApp.IAM_Status__c == System.Label.IAM_Inactive_Label && mapOldIdIamApplication.get(accApp.id).IAM_Status__c != System.Label.IAM_Inactive_Label && 
               mapOldIdIamApplication.get(accApp.id).IAM_Status__c == System.Label.IAM_Active_Status ) {
                   lstInactiveApp.add(accApp);
                   system.debug('Account level id@@@Inactive'+accApp.id);
               }
        }
        system.debug('Account level lstInactiveApp'+lstInactiveApp);
        if(lstInactiveApp!=null && !lstInactiveApp.isEmpty())
        { List<IAM_Application__c> lstapp2 = new List<IAM_Application__c>();
         for(IAM_Application__c a: lstInactiveApp)
         {
             if(a.IAM_Reject_Reason__c==null || a.IAM_Reject_Reason__c=='')
                 a.IAM_Reject_Reason__c='Requested Removal';
             if(a.IAM_Reject_Reason__c==null || a.IAM_Reject_Reason__c=='')
                 a.IAM_Reason__c='Application Inactivated';  
             
             lstapp2.add(a);   
         }
        }
    } 
    
    //Code to execute for defect D-3246 - Chetan Gaikwad
    if(isInsert==false){
        
        List<IAM_Application__c> lstActiveApp = new List<IAM_Application__c>();
        for(IAM_Application__c accApp : lstTriggerNew) {
            if(accApp.IAM_Status__c == System.Label.IAM_Active_Status) {
                lstActiveApp.add(accApp);
                system.debug('Account level id@@@Active'+accApp.id);
            }
        }
        
        system.debug('Account level lstActiveApp'+lstActiveApp);
        if(lstActiveApp!=null && !lstActiveApp.isEmpty()){
            List<IAM_Application__c> lstActapp = new List<IAM_Application__c>();
            for(IAM_Application__c a: lstActiveApp)
            {
                if(a.IAM_Reject_Reason__c!=null || a.IAM_Reject_Reason__c!='')
                    a.IAM_Reject_Reason__c='';
                if(a.IAM_Reject_Reason__c!=null || a.IAM_Reject_Reason__c!='')
                    a.IAM_Reason__c='';  
                
                lstActapp.add(a);   
            }
        } 
        isFirstTime = false;//Sandeep for 101 soql issue  
       }//Sandeep
    }
    
}

public static void deactivateConProvisionings(List<IAM_Application__c> app){
    List<IAM_Contact_Provisioning__c> conP= new List<IAM_Contact_Provisioning__c>();
    set<id> aid=new set<id>();
    Map<id,string> qsol_swreg =new Map<id,string>();
    try{
        for(IAM_Application__c aa : app){
            aid.add(aa.Id);
            system.debug('aa.IAM_Application_Name__c---'+aa.IAM_Application_Name__c+'---aa.IAM_Qsolexpiration__c---'+aa.IAM_Qsolexpiration__c);
            if(aa.IAM_Application_Name__c=='QuickServe Online')
            {qsol_swreg.put(aa.Id,aa.IAM_Qsolexpiration__c);
            }
            if(aa.IAM_Application_Name__c=='Guidanz Mobile')
            {qsol_swreg.put(aa.Id,aa.IAM_swregExpire__c);
            }
        }
        conP=[SELECT Id,IAM_Reject_Reason__c,IAM_Reason__c,IAM_Status__c,IAM_Account_Application__c,IAM_Application_Name__c,IAM_Qsolexpiration__c,IAM_swregExpire__c,IAM_End_Date__c FROM IAM_Contact_Provisioning__c where IAM_Status__c='Active' AND IAM_Account_Application__c IN : aid ];
        for(IAM_Contact_Provisioning__c c:conP){
            c.IAM_Status__c='Inactive';
            c.IAM_Reject_Reason__c = 'Requested Removal';
            c.IAM_Reason__c  = 'Application Inactivated';
            c.IAM_End_Date__c=System.Today();
            
            if(c.IAM_Application_Name__c=='QuickServe Online')
            {c.IAM_Qsolexpiration__c=qsol_swreg.get(c.IAM_Account_Application__c);
            }
            if(c.IAM_Application_Name__c=='Guidanz Mobile')
            {c.IAM_swregExpire__c=qsol_swreg.get(c.IAM_Account_Application__c);
            }
        }
        system.debug('Contact Prov to update'+conP);
        update conP;
        system.debug('Contact Prov after update'+conP);
    }catch(exception ex){
        System.debug('Printing exception'+ex.getStackTraceString());
        if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            system.debug('AN EXCEPTION OCCURED'+ ex.getdmlMessage(0));
        }
        else{
            system.debug('AN EXCEPTION OCCURED INSIDE ELSE');
        }
    }
}

public static void UpdateAccRole(list<IAM_Application__c> setAccAppRoleChangeIds){
    if(setAccAppRoleChangeIds != null && !setAccAppRoleChangeIds.isEmpty())
    {   
        List<string> accRole ;
        List<string> conRole ;
        List<string> currentRole =new List<string>();
        List<string> accModule ;
        List<string> conModule ;
        List<string> currentModule =new List<string>();
        List<IAM_Contact_Provisioning__c> conProv = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> toUpdate = new List<IAM_Contact_Provisioning__c>();
        Set<IAM_Contact_Provisioning__c> toupdatenew= new Set<IAM_Contact_Provisioning__c>();
        List<IAM_Contact_Provisioning__c> toUpdateFinal= new List<IAM_Contact_Provisioning__c>();
        boolean stop=false;
        // List<IAM_Application__c> lstAccApplications1 = [SELECT Id,IAM_Role__c FROM IAM_Application__c WHERE Id IN :setAccAppRoleChangeIds];
        system.debug('setAccAppRoleChangeIds@@@'+setAccAppRoleChangeIds);
        for(IAM_Application__c app : setAccAppRoleChangeIds)
        {
            conProv = [Select id,name, IAM_Role__c,IAM_Cumpas_Modularity__c,IAM_Account_Application__r.IAM_Role__c,IAM_Account_Application__r.IAM_Cumpas_Modularity__c from IAM_Contact_Provisioning__c where IAM_Status__c='Active' AND IAM_Account_Application__c =: app.id];
            system.debug('@@@@conProv'+conProv);
            for(IAM_Contact_Provisioning__c  aa : conProv)
            {
                if(currentRole!=null && !currentRole.IsEmpty())
                {
                    currentRole.clear();
                }
                conRole=aa.IAM_Role__c.split(';');
                accRole=aa.IAM_Account_Application__r.IAM_Role__c.split(';');
                system.debug('@@@@conRole'+conRole +'$$$$$$accRole'+accRole);
                for(string s : conRole)
                {
                    if(accRole.contains(s))
                    {
                        currentRole.add(s);
                    }
                }
                system.debug('@@@@currentRole'+currentRole);
                if(currentRole!=null && !currentRole.isEmpty())
                {system.debug('aaaaaaaa'+currentRole);
                 conRole.clear();
                 conRole.addAll(currentRole);
                }
                else
                {
                    // app.Adderror('One of the role removed is being used by '+aa.name);
                    app.Adderror('Please deactivate user provisioning record(s) prior to modifying the existing role(s).');
                    stop=true;
                }
                
                if(currentModule!=null && !currentModule.IsEmpty())
                {
                    currentModule.clear();
                }
                if(app.IAM_Application_Name__c=='CUMPAS 2.0')
                {
                    if(!String.isBlank(aa.IAM_Cumpas_Modularity__c)){
                        conModule=aa.IAM_Cumpas_Modularity__c.split(';');
                        
                    }
                    if(!String.isBlank(aa.IAM_Account_Application__r.IAM_Cumpas_Modularity__c)){
                        accModule=aa.IAM_Account_Application__r.IAM_Cumpas_Modularity__c.split(';');
                    }
                    
                    if(!conModule.isEmpty()){
                        for(string o : conModule)
                        {
                            if(accModule.contains(o))
                            {
                                currentModule.add(o);
                            }
                        }
                    }
                    if(currentModule!=null && !currentModule.isEmpty())
                    {system.debug('bbbbbbbbbb'+currentModule);
                     conModule.clear();
                     conModule.addAll(currentModule);
                    }
                    else
                    {
                        app.Adderror('One of the module removed is being used by '+aa.name);
                        stop=true;
                    }  
                }
                
                
                if(!stop==true)
                {  
                    String sss='';
                    String mod='';
                    if(conRole!=null && !conRole.isEmpty())
                    {system.debug('bbbbbbbb'+conRole);
                     for(string a:conRole)
                     {
                         if(sss!=null && sss!='')
                         {
                             sss=sss+';'+a;
                         }
                         else
                         {
                             sss=a;  
                         }
                     }
                     aa.IAM_Role__c=sss;
                     toUpdate.add(aa);
                    }
                    if(conModule!=null && !conModule.isEmpty())
                    {system.debug('cccccccc'+conModule);
                     for(string b:conModule)
                     {
                         if(mod!=null && mod!='')
                         {
                             mod=mod+';'+b;
                         }
                         else
                         {
                             mod=b;  
                         }
                     }
                     aa.IAM_Cumpas_Modularity__c=mod;
                     toUpdate.add(aa);
                    }
                }
            }
        }
        if(!toUpdate.isEmpty()){
            toupdatenew.addall(toUpdate);
            if(!toupdatenew.isEmpty()){
                toUpdateFinal.addall(toupdatenew);
            }
        }
        if(!stop==true)
        {
            system.debug('TO UPDATE ## '+ toUpdate);
            if(!toUpdateFinal.isEmpty()){
                update toUpdateFinal;
            }
        }
    }
}

/*
In this method we are updating the status of the contact provisioning record from "pending approval" to active and its associated Account and Contact record from "pending" status to "Active".
In case of rejection also we are updating the contact provisioning record  from "pending approval" to Inactive and its associated Account and Contact record from "pending" status to "Inactive". 
*/
public static void onAfterUpdate(list<IAM_Application__c> lstTriggerNew,list<IAM_Application__c> lstTriggerOld,map<id, IAM_Application__c> mapOldIdIamApplication,map<id, IAM_Application__c> mapNewIdIamApplication){
    if(isAfterFirstTime==true || Test.isRunningTest()){//Sandeep for 101 soql issue and for test class
    System.debug('####isAfterFirstTime- '+isAfterFirstTime);
        isAfterFirstTime=false;//Sandeep  for 101 soql issue
    System.debug('####isAfterFirstTime- '+isAfterFirstTime);    
    set<id> setAccAppIds = new set<id> ();
    set<id> setAccAppInactiveIds = new set<id> ();
    set<id> setAccId = new set<id> ();
    List<IAM_Application__c> lstInactiveApp = new List<IAM_Application__c>();
    Set<Id> lstInactiveCSTEDSApp = new Set<Id>();//QSOL EDS CST deactivation
    updateConProSubEndDate(lstTriggerNew, mapOldIdIamApplication, mapNewIdIamApplication);

    for(IAM_Application__c accApp : lstTriggerNew) {
        if(accApp.IAM_Status__c == System.Label.IAM_Inactive_Label && mapOldIdIamApplication.get(accApp.id).IAM_Status__c != System.Label.IAM_Inactive_Label && 
           mapOldIdIamApplication.get(accApp.id).IAM_Status__c == System.Label.IAM_Active_Status ) {
               lstInactiveApp.add(accApp);
               system.debug('Account level id@@@Inactive'+accApp.id);
               //QSOL EDS CST deactivation
               if(accApp.IAM_Application_Name__c ==system.label.IAM_AppName_QSOL && accApp.Account_Type__c !='LOP Customer' && accApp.Account_Type__c !='SIR' && accApp.IAM_Reject_Reason__c!= 'Subscription Expired' && accApp.IAM_Role__c != 'QSOL LOP' && accApp.IAM_Role__c != 'QSOL SIR Customer' ){
                   lstInactiveCSTEDSApp.add(accApp.IAM_Account_Name__c);
               }
               //QSOL EDS CST deactivation
           }
    }
    if(lstInactiveApp!=null && !lstInactiveApp.isEmpty())
    {  
        deactivateConProvisionings(lstInactiveApp);
    }
    //QSOL EDS CST deactivation
    if(lstInactiveCSTEDSApp!=null && !lstInactiveCSTEDSApp.isEmpty())
    {  
        IAM_Remove_Subscriptions_Swift.deactivateConProvisionings(lstInactiveCSTEDSApp);
    }
    //QSOL EDS CST deactivation
    list<IAM_Application__c> setAccAppRoleChangeIds = new list<IAM_Application__c> ();
    list <processInstanceStep> stepRejectsRecords = new List<processInstanceStep>();
    
    if(Limits.getQueries()<Limits.getLimitQueries()){
        stepRejectsRecords = [SELECT ProcessInstance.TargetObject.Name, ActorId, Comments, Id, 
                              ProcessInstanceId, ProcessInstance.TargetObjectId,StepStatus FROM ProcessInstanceStep 
                              WHERE StepStatus =: 'Rejected' AND ProcessInstance.TargetObjectId in: mapOldIdIamApplication.keyset()];
    }
    List<IAM_Application__c> osmbackendFlag = new List<IAM_Application__c>();
    for(IAM_Application__c accApp : lstTriggerNew) {
        if(accApp.IAM_Status__c == System.Label.IAM_Active && mapOldIdIamApplication.get(accApp.id).IAM_Status__c != System.Label.IAM_Active && 
           mapOldIdIamApplication.get(accApp.id).IAM_Status__c == System.Label.IAM_Pending ) {
               setAccAppIds.add(accApp.id);
               system.debug('Account level id@@@'+accApp.id);
           }
        if(accApp.IAM_Status__c == System.Label.IAM_Inactive_Label && mapOldIdIamApplication.get(accApp.id).IAM_Status__c != System.Label.IAM_Inactive_Label && 
           mapOldIdIamApplication.get(accApp.id).IAM_Status__c == System.Label.IAM_Pending ) {
               setAccAppInactiveIds.add(accApp.id);
               system.debug('Account level id@@@Inactive'+accApp.id+' '+accApp.name);
           }
        system.debug('accApp.IAM_Role__c***'+accApp.IAM_Role__c+'22222222222222222'+mapOldIdIamApplication.get(accApp.id).IAM_Role__c );
        System.debug('Profile id is'+UserInfo.getProfileId());
        System.debug('accApp.IAM_OSM_Backend_Update__c$$$$'+accApp.IAM_OSM_Backend_Update__c);
        if(UserInfo.getUserRoleId()!=System.Label.IAM_FE_Admin_Role_ID && !accApp.IAM_OSM_Backend_Update__c){
            if((accApp.IAM_Role__c != mapOldIdIamApplication.get(accApp.id).IAM_Role__c && 
                accApp.IAM_Role__c != '' && accApp.IAM_Role__c != null ) || (accApp.IAM_Cumpas_Modularity__c != mapOldIdIamApplication.get(accApp.id).IAM_Cumpas_Modularity__c && 
                                                                             accApp.IAM_Cumpas_Modularity__c != '' && accApp.IAM_Cumpas_Modularity__c != null)) {
                                                                                 setAccAppRoleChangeIds.add(accApp);
                                                                                 system.debug('Account level id@@@Role Change'+accApp.id);
                                                                             }
        }
        //Nishant added flag for OSM D-3258
        if(accApp.IAM_OSM_Backend_Update__c){
            IAM_Application__c objAAF = new IAM_Application__c(Id=accApp.id);
            objAAF.IAM_OSM_Backend_Update__c= false;
            osmbackendFlag.add(objAAF);
        }
        //Amarnath Mishra added for to update reject comment during rejection
        if(stepRejectsRecords.size()>0){
            if(accApp.id == stepRejectsRecords[0].ProcessInstance.TargetObjectId && String.isNotBlank(stepRejectsRecords[0].Comments) && IAM_contactHelperClass.isFirstTimeApplicationReject == true){
                IAM_contactHelperClass.isFirstTimeApplicationReject = false;
                IAM_contactHelperClass.updateRejectReason(accApp.id,accApp.IAM_Reject_Reason__c,stepRejectsRecords[0].Comments);
            }
        }
        
        
        //Amarnath Mishra added for the rejection reason
        system.debug('=====UserInfo.UITheme() =========='+UserInfo.getUiTheme());
        system.debug('=====UserInfo.UIThemeDisplayed()===='+UserInfo.getUiThemeDisplayed());
        system.debug('=====idm.IAM_Reject_Reason__c========'+accApp.IAM_Reject_Reason__c);
        system.debug('=====mapOldIdIamApplication.get(accApp.id).IAM_Reject_Reason__c='+mapOldIdIamApplication.get(accApp.id).IAM_Reject_Reason__c);
        if(String.isNotBlank(accApp.IAM_Reject_Reason__c) && String.isBlank(mapOldIdIamApplication.get(accApp.id).IAM_Reject_Reason__c) && UserInfo.getUiThemeDisplayed() == 'Theme4d'  ){
            system.debug('======Inside if rejection==IAM_Application==');
            IAM_contactHelperClass.updateRejectReason(accApp.id,accApp.IAM_Reject_Reason__c,accApp.IAM_Reason__c);
        }
        
    }
    
    
    system.debug('Account level ids@@@'+setAccAppIds);
    system.debug('Account Inactive Reject ids@@@'+setAccAppInactiveIds); 
    try{
        if(setAccAppIds != null && !setAccAppIds.isEmpty() ) {
            
            List<IAM_Application__c>  lstAccApplications= new List<IAM_Application__c>();
            
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstAccApplications = [SELECT Id,IAM_Account_Name__r.Id FROM IAM_Application__c WHERE Id IN :setAccAppIds];
            }
            
            if(!lstAccApplications.isEmpty()){
                for(IAM_Application__c accApp: lstAccApplications){
                    setAccId.add(accApp.IAM_Account_Name__r.id);
                }
            }
            system.debug('Account ids@@@'+setAccId);
            set<id> setConId = new set<id> ();
            
            List<IAM_Contact_Provisioning__c> lstConApplicationsUpdate = new List<IAM_Contact_Provisioning__c>();
            List<IAM_Contact_Provisioning__c> lstConApplications= new List<IAM_Contact_Provisioning__c>();
            
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstConApplications = [SELECT Id,IAM_Application_Name__c,IAM_Account_Application__c,IAM_Status__c,IAM_Contact__r.Id FROM IAM_Contact_Provisioning__c WHERE IAM_Account_Application__r.Id IN :setAccAppIds AND 
                                      IAM_Status__c =: System.Label.IAM_Pending_Account_Approval];
            }
            
            if(!lstConApplications.isEmpty()){              
                for(IAM_Contact_Provisioning__c conApp : lstConApplications) {
                    conApp.IAM_Status__c = System.Label.IAM_Active; 
                    setConId.add(conApp.IAM_Contact__r.id);
                    lstConApplicationsUpdate.add(conApp);
                }
            }
            if(lstConApplicationsUpdate.size() >0 && !lstConApplicationsUpdate.isEmpty()) {
                update lstConApplicationsUpdate;
            } 
            
            List<Account> lstAccUpadte = new List<Account>();
            List<Account> lstAcc= new List<Account> ();
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstAcc = [SELECT Id,Name FROM Account WHERE Id IN :setAccId AND CMI_Account_Status__c =: System.Label.IAM_Pending];
            }
            
            if(!lstAcc.isEmpty()){
                for(Account acc: lstAcc) {
                    acc.CMI_Account_Status__c = System.Label.IAM_Active;  
                    lstAccUpadte.add(acc);
                }  
            }
            
            if(lstAccUpadte.size() >0 && !lstAccUpadte.isEmpty()) {
                update lstAccUpadte;
            }  
            List<Contact> lstConUpadte = new List<Contact>();
            List<Contact> lstCon= new List<Contact>();
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstCon = [SELECT Id,Name FROM contact WHERE Id IN :setConId AND IAM_Contact_Status__c =: System.Label.IAM_Pending];
            }
            if(!lstCon.isEmpty()){
                for(Contact con: lstCon) {
                    con.IAM_Contact_Status__c = System.Label.IAM_Active;
                    con.IAM_Approved__c='Y';  
                    con.IAM_from_Registration__c = false;
                    lstConUpadte.add(con);
                } 
            }               
            if(lstConUpadte.size() >0 && !lstConUpadte.isEmpty()) {
                update lstConUpadte;
            }   
        }   
        
        //Reject functionality start
        //In the below code section we are updating the Account,contact and contact provisioning record those are getting rejected.
        if(setAccAppInactiveIds != null && !setAccAppInactiveIds.isEmpty() ) {
            // Amarnath Mishra commented the below SOQL as it is not used in anywhere in this method
            
            List <processInstanceStep> stepRejects= new List<processInstanceStep>();
            if(Limits.getQueries()<Limits.getLimitQueries()){
                stepRejects = [SELECT ProcessInstance.TargetObject.Name, ActorId, Comments, Id, 
                               ProcessInstanceId, ProcessInstance.TargetObjectId,StepStatus FROM ProcessInstanceStep 
                               WHERE StepStatus = 'Rejected' AND ProcessInstance.TargetObjectId IN :setAccAppInactiveIds ];
                /*system.debug('stepRejects--*****'+stepRejects[0]); */  
            }
            List<IAM_Application__c> lstAccApplications = new List<IAM_Application__c>();
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstAccApplications = [SELECT Id,IAM_Account_Name__r.Id FROM IAM_Application__c WHERE Id IN :setAccAppInactiveIds];
            }
            if(!lstAccApplications.isEmpty()){
                for(IAM_Application__c accApp: lstAccApplications){
                    setAccId.add(accApp.IAM_Account_Name__r.id);
                }
            }
            system.debug('Account ids@@@'+setAccId);
            set<id> setConId = new set<id> ();
            
            List<IAM_Contact_Provisioning__c> lstConApplicationsUpdate = new List<IAM_Contact_Provisioning__c>();
            List<IAM_Contact_Provisioning__c> lstConApplications= new List<IAM_Contact_Provisioning__c>();
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstConApplications = [SELECT Id,IAM_Application_Name__c,IAM_Account_Application__c,IAM_Status__c,IAM_Contact__r.Id FROM IAM_Contact_Provisioning__c WHERE IAM_Account_Application__r.Id IN :setAccAppInactiveIds AND 
                                      IAM_Status__c =: System.Label.IAM_Pending_Account_Approval];
            }
            if(!lstConApplications.isEmpty()){
                for(IAM_Contact_Provisioning__c conApp : lstConApplications) {
                    conApp.IAM_Status__c = System.Label.IAM_Inactive_Label; 
                    setConId.add(conApp.IAM_Contact__r.id);
                    lstConApplicationsUpdate.add(conApp);
                }  
            }
            if(lstConApplicationsUpdate.size() >0 && !lstConApplicationsUpdate.isEmpty()) {
                update lstConApplicationsUpdate;
            } 
            
            List<Account> lstAccUpadte = new List<Account>();
            List<Account> lstAcc= new List<Account>();
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstAcc = [SELECT Id,Name FROM Account WHERE Id IN :setAccId AND CMI_Account_Status__c =: System.Label.IAM_Pending]; 
            }
            if(!lstAcc.isEmpty()){
                for(Account acc: lstAcc) {
                    acc.CMI_Account_Status__c = System.Label.IAM_Inactive_Label;  
                    lstAccUpadte.add(acc);
                }
            }               
            if(lstAccUpadte.size() >0 && !lstAccUpadte.isEmpty()) {
                update lstAccUpadte;
            }  
            
            List<Contact> lstConUpadte = new List<Contact>();
            List<Contact> lstCon= new List<Contact>();
            
            if(Limits.getQueries()<Limits.getLimitQueries()){
                lstCon = [SELECT Id,Name FROM Contact WHERE Id IN :setConId And IAM_Contact_Status__c =: System.Label.IAM_Pending]; 
            }
            if(!lstCon.isEmpty()){
                for(Contact con: lstCon) {
                    con.IAM_Contact_Status__c = System.Label.IAM_Inactive_Label;
                    con.IAM_Approved__c='N';
                    if(stepRejects[0].Comments != null && stepRejects[0].Comments != '') {
                        con.IAM_Reason__c =  stepRejects[0].Comments; 
                    }
                    lstConUpadte.add(con);
                } 
            }               
            if(lstConUpadte.size() >0 && !lstConUpadte.isEmpty()) {
                update lstConUpadte;
            }   
        } //Reject functionality end 
        if(setAccAppRoleChangeIds != null && !setAccAppRoleChangeIds.isEmpty())
        {
            UpdateAccRole(setAccAppRoleChangeIds);
        }
        if(!osmbackendFlag.isEmpty()){
            update osmbackendFlag;
        }
    }
    catch(Exception e){
        IAM_ErrorHandling.IAMerrorCapture(null,'IAM_AccountAccessTriggerHandler',e.getMessage()); 
    }
    
}
}//Sandeep for 101 soql issue

Public Static void AccountAccessValidationForDistributor(List<IAM_Application__c> cons,Boolean isBefore){
    
    
    
    for(IAM_Application__c ObjCon:cons){
        
        
        String accessLevel=IAM_userAccessCheckToModify.userAccessCheck(objCon.IAM_Account_Name__c,'IAM_Application__c');
        if(accessLevel=='Insufficient access'){
            //adding error here.
            objCon.adderror('Insufficient Privileges');
        }
        //end of that validation to check Modify access.
        
    }
}

/**This method we updating the account fields when a new account and feature access is created for connected solutions**/

public static void AccountUpdateFields(list<IAM_Application__c> apps){     
    
    list<Account> listofParentObjToUpdate;
    set<Id> setOfids = new set<Id>();
    for(IAM_Application__c app :apps){
        if(app.IAM_Application_Name__c == Label.IAM_AppName_ConnectedSolutions && app.IAM_Status__c=='Pending'){
            setOfids.add(app.IAM_Account_Name__c);
        }
    }
    if(!setOfids.isEmpty()) {
        list<Account> listOfParentObj = [select Id, name,CMI_Cummins_Customer_Id__c,CMI_Account_Num__c,CMI_Account_Status__c  from account
                                         where Id in :setOfids];
        listofParentObjToUpdate = new list<Account>();
        
        for(Account parent : listOfParentObj) {
            
            parent.CMI_Cummins_Customer_Id__c= 'SB'+parent.CMI_Account_Num__c;
            parent.CMI_Care_Service_Level__c = 'Basic';
            
            listofParentObjToUpdate.add(parent);
            
        }
    } 
    if(listofParentObjToUpdate!=null){
        Update listofParentObjToUpdate;
    }
}

public static void AutorenewSubscriptions(list<IAM_Application__c> apps){    
    try{ 
    //this method is to auto renew the user access and features records if the QSOL,EDS or CST application subscriptions are renewed
        
        
        set<Id> setOfids = new set<Id>();
        set<Id> accessFeatureids = new set<Id>();
        
        list<String> roleList = new list<String>();
        list<String> appList = new list<String>();
        list<IAM_Contact_Provisioning__c> existUsrAccess = new list<IAM_Contact_Provisioning__c>();
        map<IAM_Application__c,IAM_Application__c> mapOldAccessNewAccess = new map<IAM_Application__c,IAM_Application__c>(); //this map will store old access feature record with the matching(duplicate) expired access feature record
        map<Id,IAM_Application__c> mapOldAccessNewAccessId = new map<Id,IAM_Application__c>();
        //map<IAM_Application__c,String> mapRole = new map<IAM_Application__c,String>();
        //map<IAM_Application__c,String> mapAppName = new map<IAM_Application__c,String>();
        map<String,IAM_Application__c> duplicateAccAccess = new map<String,IAM_Application__c>();
        Map<Id,IAM_Application__c> latestAccountAccess = new Map<Id,IAM_Application__c>();
        
    //to create a list of account ids, list of roles, list of application to run a query later to fetch existing old account access and feature records
        for(IAM_Application__c childobj :apps){
            
            if((childobj.IAM_Application_Name__c == 'QuickServe Online' || childobj.IAM_Application_Name__c == 'EDS' || childobj.IAM_Application_Name__c == 'Cummins Service Training') && childobj.IAM_Status__c == 'Active'){
                setOfids.add(childobj.IAM_Account_Name__c);
                roleList.add(childobj.IAM_Role__c);
                appList.add(childobj.IAM_Application_Name__c);
                //mapRole.put(childobj,childobj.IAM_Role__c);
                //mapAppName.put(childobj,childobj.IAM_Application_Name__c);
                
                //Creating below key to identify the existing duplicate account access feature record w.r.t role,application name and account id
                String key = childobj.IAM_Role__c + childobj.IAM_Application_Name__c + childobj.IAM_Account_Name__c;
                duplicateAccAccess.put(key,childobj);
            
            }
            
        }
        if(!setOfids.isEmpty()) {
            
            //to find the existing account access and feature records with the same role,application name and account id
            list<IAM_Application__c> existInactAccAccess = [select Id, name,IAM_Role__c,IAM_Application_Name__c,IAM_Account_Name__c  from IAM_Application__c
                                             where IAM_Account_Name__c in :setOfids AND IAM_Role__c in :roleList AND IAM_Application_Name__c in :appList AND IAM_Status__c = 'Inactive' ORDER BY LastModifiedDate ASC];
            //listofMatchingAccAccess = new list<IAM_Application__c>();

             // To get Latest Latemodified Account Access record - Ravi - 29/06/2021
             for(IAM_Application__c latestrec : existInactAccAccess){
                latestAccountAccess.put(latestrec.IAM_Account_Name__c,latestrec);
            }
            
            for(IAM_Application__c parent : latestAccountAccess.values()) {
                //the list queried above will have addtional records w.r.t filters. creating the same key to identify the exact match
                String key = parent.IAM_Role__c + parent.IAM_Application_Name__c + parent.IAM_Account_Name__c;
                IAM_Application__c duplicate = duplicateAccAccess.get(key);
                
                if(duplicate != null)
                {   system.debug('duplicate account access and feature@@@'+parent.id);
                    //listofMatchingAccAccess.add(parent);
                    accessFeatureids.add(parent.id);
                    //now we have the exact duplicate records which are inactive
                    mapOldAccessNewAccess.put(parent,duplicateAccAccess.get(key)); //we are creating map of new Account access feature & expired Account access feature. Using this ,while inserting user feature access records we can associate it with the Account Access feature record.
                    mapOldAccessNewAccessId.put(parent.Id,duplicateAccAccess.get(key));
                    
                    
                    
                }
            }
        } 
        if(!accessFeatureids.isEmpty()) {
            //We will now query on exsiting user feature and access associated to the exact duplicate Account access and features records
            
            existUsrAccess = [select Id, name,IAM_Role__c,IAM_Application_Name__c,IAM_Qsolexpiration__c,IAM_Account_Application__c,IAM_Account_Application__r.IAM_Subscription_End_Date__c,IAM_Contact__r.AccountId,IAM_End_Date__c,IAM_Reject_Reason__c,RecordTypeID  from IAM_Contact_Provisioning__c where IAM_Account_Application__c in :accessFeatureids AND IAM_Status__c ='Inactive'];
            
        }
        
        if(!existUsrAccess.isEmpty()) {
            List<IAM_Contact_Provisioning__c> toBeInsertedList = new List<IAM_Contact_Provisioning__c>();
            for(IAM_Contact_Provisioning__c usrfeature : existUsrAccess){
                
                if(usrfeature.IAM_End_Date__c == usrfeature.IAM_Account_Application__r.IAM_Subscription_End_Date__c && usrfeature.IAM_Reject_Reason__c =='Subscription Expired' && usrfeature.IAM_Contact__r.AccountId == mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Account_Name__c){
                    system.debug('usrfeature to be cloned@@@'+usrfeature.id);
                    IAM_Contact_Provisioning__c toBeInserted = new IAM_Contact_Provisioning__c();
                    toBeInserted = usrfeature.clone(false,false,false,false);
                    toBeInserted.IAM_Status__c = 'Active';
                    toBeInserted.IAM_Start_Date__c = system.today();
                    toBeInserted.IAM_Account_Application__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).Id;
                    toBeInserted.IAM_End_Date__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Subscription_End_Date__c;
                    toBeInserted.IAM_Reject_Reason__c = '';
                    toBeInserted.RecordTypeID = usrfeature.RecordTypeID; //adding this due to bad picklist error
                    toBeInserted.IAM_Subscription_Name__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Subscription_Name__c;
                    toBeInserted.IAM_Qsolexpiration__c = mapOldAccessNewAccessId.get(usrfeature.IAM_Account_Application__c).IAM_Qsolexpiration__c;
                    toBeInsertedList.add(toBeInserted);
                }
                
            }
            insert toBeInsertedList;
            
        }
      }
      
      catch(exception ex){
        System.debug('Printing exception'+ex.getStackTraceString());
        if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
            system.debug('AN EXCEPTION OCCURED'+ ex.getdmlMessage(0));
        }
        else{
            system.debug('AN EXCEPTION OCCURED INSIDE ELSE');
        }
    }
    }
  
    public static void validateAppAccessFields(List<IAM_Application__c> appList) {
        for(IAM_Application__c app : appList) {
            if(app.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)
            || app.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics)) {
                String selectedRole = app.IAM_Role__c;
                if(selectedRole.contains(';')) {
                    app.addError(Label.IAM_Error_SelectOneRole);
                }               
            }
        }
    }
    
    /* 12/03/2020  - Added FT-NPBU Dignostics app login in all below 3 methods */
    public static void updateFields(List<IAM_Application__c> appList, Boolean isInsert) {        
        for(IAM_Application__c app : appList) {  
            if(app.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)) {  
                if(isInsert) {  
                    app.IAM_Subscription_Name__c = app.IAM_Role__c;  
                    app.IAM_Guidanz_Mobile_Roles__c = app.IAM_Role__c;  
                    app.IAM_Source__c = 'IAM';  
                }  
                if(app.IAM_Role__c.equalsIgnoreCase('Field Test IAS Guidanz Mobile')) {  
                    app.IAM_swregExpire__c = getExpirationStr('IASF', app.IAM_Subscription_End_Date__c);  
                } else if(app.IAM_Role__c.equalsIgnoreCase('Field Test CMP Guidanz Mobile')) {  
                    app.IAM_swregExpire__c = getExpirationStr('CMPF', app.IAM_Subscription_End_Date__c);  
                } else if(app.IAM_Role__c.equalsIgnoreCase('Field Test SRV Guidanz Mobile')) {  
                    app.IAM_swregExpire__c = getExpirationStr('SRVF', app.IAM_Subscription_End_Date__c);  
                } else if(app.IAM_Role__c.equalsIgnoreCase('Field Test PS PRO Guidanz Mobile')){
                    app.IAM_swregExpire__c = getExpirationStr('PPRF', app.IAM_Subscription_End_Date__c);
                } else if(app.IAM_Role__c.equalsIgnoreCase('Field Test Power Plus Lite Guidanz Mobile')) {
                    app.IAM_swregExpire__c = getExpirationStr('PPLF', app.IAM_Subscription_End_Date__c);
                }else if(app.IAM_Role__c.equalsIgnoreCase('Beta Testing Guidanz Mobile')) {              //added changes for FT-Guidanz Mobile new Subscripton - @Anupam
                    app.IAM_swregExpire__c = getExpirationStr('BTGF', app.IAM_Subscription_End_Date__c);
                }
                /* Set End Date to blank for Field Test Count subscriptions 
                ** (CalAssist Units, Intapp Units, IntappOEM Units) */  
                if(app.IAM_Role__c.containsIgnoreCase('Units')) {  
                    app.IAM_Subscription_End_Date__c = null;  
                } 
            }  
            if(app.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics)) {  
                if(isInsert) {  
                    app.IAM_Subscription_Name__c = app.IAM_Role__c;  
                    app.IAM_Source__c = 'IAM';  
                }  
                if(app.IAM_Role__c.equalsIgnoreCase('BASIC')) {  
                    app.IAM_NpbuDiagExpire__c = getExpirationStr('BSCI', app.IAM_Subscription_End_Date__c);  
                } else if(app.IAM_Role__c.equalsIgnoreCase('Manufacturing')) {  
                    app.IAM_NpbuDiagExpire__c = getExpirationStr('MFGI', app.IAM_Subscription_End_Date__c);  
                } else if(app.IAM_Role__c.equalsIgnoreCase('Advance')) {  
                    app.IAM_NpbuDiagExpire__c = getExpirationStr('ADVI', app.IAM_Subscription_End_Date__c);  
                } else if(app.IAM_Role__c.equalsIgnoreCase('Pro')) {  
                    app.IAM_NpbuDiagExpire__c = getExpirationStr('PROI', app.IAM_Subscription_End_Date__c);  
                }                
            }  
            if(app.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_AppName_guidanzmobile)) {  
                if(app.IAM_Role__c.containsIgnoreCase('Units')) {  
                    app.IAM_Subscription_End_Date__c = null;  
                }  
            }  
        }                 
    }
    
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

    /* It is used to update End Date of Contact Provisioning records associated with Account Provisioning records. */
    public static void updateConProSubEndDate(List<IAM_Application__c> appList, 
    Map<Id, IAM_Application__c> oldAppMap, Map<Id, IAM_Application__c> newAppMap) {
        List<Id> appIdList = new List<Id>();
        for(IAM_Application__c app : appList) {
            if((app.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)
              || app.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics))
              && app.IAM_Status__c.equalsIgnoreCase(Label.IAM_Active_Status)
              && app.IAM_Subscription_End_Date__c != oldAppMap.get(app.Id).IAM_Subscription_End_Date__c) {
                System.debug('#### Old Date - '+oldAppMap.get(app.Id).IAM_Subscription_End_Date__c);
                System.debug('#### New Date - '+app.IAM_Subscription_End_Date__c);
                appIdList.add(app.Id);
            }            
        }
        
        if(!appIdList.isEmpty()) {            
            List<IAM_Contact_Provisioning__c> conProList = [
                SELECT Id
                     , IAM_End_Date__c
                     , IAM_Account_Application__c
                  FROM IAM_Contact_Provisioning__c
                 WHERE IAM_Account_Application__c IN :appIdList
                   AND IAM_Status__c = :Label.IAM_Active_Status
                   AND IAM_Contact__r.Account.Type != 'Internal'
                   AND IAM_Contact__r.Account.IAM_Internal_Account__c = False
            ];
            System.debug('#### conProList - '+conProList);
            if(!conProList.isEmpty()) {
                List<IAM_Contact_Provisioning__c> updateConProList = new List<IAM_Contact_Provisioning__c>();
                for(IAM_Contact_Provisioning__c conPro : conProList) {
                    IAM_Contact_Provisioning__c updatedConPro = new IAM_Contact_Provisioning__c();
                    updatedConPro.Id = conPro.Id;
                    updatedConPro.IAM_End_Date__c = newAppMap.get(conPro.IAM_Account_Application__c).IAM_Subscription_End_Date__c;
                    if(newAppMap.get(conPro.IAM_Account_Application__c).IAM_Application_Name__c.equalsIgnoreCase(
                        Label.IAM_App_GuidanzMobileFieldTest)) {
                            updatedConPro.IAM_swregexpire__c = newAppMap.get(conPro.IAM_Account_Application__c).IAM_swregexpire__c;
                    }
                    //updatedConPro.IAM_swregexpire__c = newAppMap.get(conPro.IAM_Account_Application__c).IAM_swregexpire__c;
                    if(newAppMap.get(conPro.IAM_Account_Application__c).IAM_Application_Name__c.equalsIgnoreCase(
                        Label.IAM_FT_NPBU_Diagnostics)) {
                            updatedConPro.IAM_NpbuDiagExpire__c = newAppMap.get(conPro.IAM_Account_Application__c).IAM_NpbuDiagExpire__c;
                    }
                    
                    updateConProList.add(updatedConPro);
                }
                if(!updateConProList.isEmpty()) {
                    System.debug('#### Before updateConProList - '+updateConProList);
                    update updateConProList;
                    System.debug('#### After updateConProList - '+updateConProList);
                }
            }
        }
    }
    //auto create User Feature records when subscription is added for FT-Guidanz mobile and Guidanz mobile - @Anupam
    public static void autoCreateUserFeatureForGuidanz(List<IAM_Application__c> appGuidanzList){
        system.debug('appGuidanzList--->'+appGuidanzList);
        set<Id> accIdSet = new set<Id>();
        List<Contact> conRecList = new List<Contact>();
        Map<String, Contact> mapContactRecords = new Map<String, Contact>();
        Map<String, List<IAM_Application__c>> mapAppFeatureRecords = new Map<String, List<IAM_Application__c>>();
        Map<String, RecordType> mapRecordType = new Map<String, RecordType>();
        List<IAM_Contact_Provisioning__c> UserFeatureAccessList = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Application__c> appGuidanzListIte = new List<IAM_Application__c>();//Added by Sandeep
        if(appGuidanzList.size() > 0){
            for(IAM_Application__c appRec : appGuidanzList){
                  if(appRec.IAM_Status__c == 'Active' && (appRec.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_AppName_guidanzmobile) || appRec.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)) && appRec.Account_Type__c == 'Individual'){  
                    system.debug('Inside new method if block');
                    accIdSet.add(appRec.IAM_Account_Name__c); 
                    appGuidanzListIte.add(appRec);//Added by Sandeep for 101 soql isue
                }
            }
        }
        system.debug('accIdSet##--->'+accIdSet);
        if(accIdSet.size() > 0){
            conRecList = [select Id,AccountId,Account.Name,IAM_Contact_Owner__c from Contact where AccountId IN : accIdSet AND IAM_Contact_Status__c = 'Active'];
        }
        system.debug('conRecList##--->'+conRecList);
        if(conRecList.size() > 0){
            for(Contact cc : conRecList){
                //COmmented the below line by Sandeep for 101 soql issue
                //for(IAM_Application__c acctFeatureRec : appGuidanzList){
                    for(IAM_Application__c acctFeatureRec : appGuidanzListIte){
                    system.debug('cc.AccountId--->'+cc.AccountId);
                    system.debug('acctFeatureRec.IAM_Account_Name__c--->'+acctFeatureRec.IAM_Account_Name__c);
                    if(cc.AccountId == acctFeatureRec.IAM_Account_Name__c){
                        if(!mapAppFeatureRecords.containsKey(cc.Id)){
                            mapAppFeatureRecords.put(cc.Id, new List<IAM_Application__c>{acctFeatureRec});
                            mapContactRecords.put(cc.Id, cc);
                        }
                        else{
                            mapAppFeatureRecords.get(cc.Id).add(acctFeatureRec); 
                            mapContactRecords.put(cc.Id, cc);
                        }
                    }
                }
            }
        }
        system.debug('mapAppFeatureRecords##--->'+mapAppFeatureRecords);
        system.debug('mapContactRecords##--->'+mapContactRecords);
        List<RecordType> recTypeList = new List<RecordType>();//added by sandeep for 101 soql issue
        if(mapAppFeatureRecords.size()>0){
         recTypeList = [Select Id, Name, sobjecttype from RecordType where name IN ('Field Test Guidanz Mobile', 'Guidanz Mobile') and sobjecttype = 'IAM_Contact_Provisioning__c'];
        }
        if(recTypeList.size() > 0){
            for(RecordType rr : recTypeList){
                if(!mapRecordType.containsKey(rr.Name)){
                    mapRecordType.put(rr.Name, rr);
                }  
            }
        }
        system.debug('mapRecordType---->'+mapRecordType);
        if(mapAppFeatureRecords.size() > 0){
            //Map<Id,RecordType> recTypeMap = new Map<Id,RecordType>([Select Id, Name, sobjecttype from RecordType where name IN ('Field Test Guidanz Mobile', 'Guidanz Mobile') and sobjecttype = 'IAM_Contact_Provisioning__c']);
            for(String AccFeatureKey : mapAppFeatureRecords.keyset()){
                for(IAM_Application__c appFeature : mapAppFeatureRecords.get(AccFeatureKey)){
                    IAM_Contact_Provisioning__c userFeatureAccess = new IAM_Contact_Provisioning__c();
                if(appFeature.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest)){
                    userFeatureAccess.RecordTypeId = mapRecordType.get(appFeature.IAM_Application_Name__c).Id;
                }
                else if(appFeature.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_AppName_guidanzmobile)){
                    userFeatureAccess.RecordTypeId = mapRecordType.get(appFeature.IAM_Application_Name__c).Id;
                }
                userFeatureAccess.IAM_Application_Name__c = appFeature.IAM_Application_Name__c;
                userFeatureAccess.IAM_Role__c = appFeature.IAM_Role__c;
                userFeatureAccess.IAM_Guidanz_Mobile_Roles__c = appFeature.IAM_Guidanz_Mobile_Roles__c;
                //userFeatureAccess.IAM_Cumpas_Modularity__c = mapAppFeatureRecords.get(AccFeatureKey).IAM_Cumpas_Modularity__c;
                userFeatureAccess.IAM_Contact__c = AccFeatureKey;//conRec.Id;
                userFeatureAccess.IAM_Status__c = 'Active';
                userFeatureAccess.IAM_Account_Application__c = appFeature.Id;
                userFeatureAccess.IAM_User__c = mapContactRecords.get(AccFeatureKey).IAM_Contact_Owner__c;
                userFeatureAccess.IAM_swregExpire__c = appFeature.IAM_swregExpire__c;
                userFeatureAccess.IAM_Start_Date__c = appFeature.IAM_Subscription_Start_Date__c;
                userFeatureAccess.IAM_End_Date__c = appFeature.IAM_Subscription_End_Date__c;
                userFeatureAccess.IAM_Assigned_Units__c = appFeature.IAM_Total_Units__c;
                userFeatureAccess.IAM_Remaining_Units__c = appFeature.IAM_Total_Units__c;
                userFeatureAccess.IAM_Source__c = appFeature.IAM_Source__c;
                userFeatureAccess.IAM_Subscription_Name__c = appFeature.IAM_Subscription_Name__c;
                system.debug('userFeatureAccess--->'+userFeatureAccess);
                UserFeatureAccessList.add(userFeatureAccess);
                }               
            }
        }
        
        if(UserFeatureAccessList.size() > 0){
            insert UserFeatureAccessList;
        }
        
    }
}