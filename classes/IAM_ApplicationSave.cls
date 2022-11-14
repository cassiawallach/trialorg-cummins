public  with sharing class  IAM_ApplicationSave {

    @AuraEnabled
    //code to save free application values.
    public Static string saveFreeApplication(id recordid,map<String,String> App,String appName){
        string returnString;
        System.debug('Printing the map that got to application'+App);
        System.debug('Printing application name'+appName);
        Contact con=[select id,IAM_Contact_Status__c,Accountid,Account.CMI_CId__c from Contact where id=:recordid];
        List<IAM_Application__c> accApp=[Select id,IAM_Subscription_Name__c,IAM_Subscription_Start_Date__c,IAM_Subscription_Count__c,IAM_Provisioned_User_Count__c from IAM_Application__c where IAM_Account_Name__c=:con.Accountid AND IAM_Application_Name__c=:App.get('Application') AND IAM_Role__c includes (:App.get('Role')) LIMIT 1];
        System.debug('Account access feature that is going to get assaigned'+accApp);
        IAM_Contact_Provisioning__c conProv=new IAM_Contact_Provisioning__c();
        conProv.IAM_Account_Application__c=accApp[0].id;
        conProv.IAM_Contact__c=con.id;
        conProv.IAM_Application_Name__c=App.get('Application');
        conProv.IAM_Role__c=App.get('Role');
        if(con.IAM_Contact_Status__c==System.Label.IAM_Status_Active){
            conProv.IAM_Status__c=System.Label.IAM_Status_Active;
        }else{
            conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
        }
        //conProv.IAM_Status__c='Active';
        conProv.IAM_Subscription_Name__c=accApp[0].IAM_Subscription_Name__c; // Added as updated duplicate rule to check for subscription name D-2799
        conProv.IAM_Start_Date__c=System.Today();
        //conProv.IDM_End_Date__c=accApp[0].IAM_Subscription_End_Date__c;
        System.debug('Prinitng record type id value'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(App.get('Application')).getRecordTypeId());
        conProv.recordtypeid=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(App.get('Application')).getRecordTypeId();
        //this needs to be assaigned only when contact status is active because then only Contact will have an associated user.
        if(con.IAM_Contact_Status__c=='Active'){
        System.debug('Entered contact Active Status');
        List<user> usr=[select id from user where Contactid=:con.id and isActive=True LIMIT 1];
            if(!usr.isEmpty()){
                conProv.IAM_User__c=usr[0].id;
            }
        }
        if(appName=='Connected Solutions'){
          //Now Assaign App Specific values
          System.debug('Printing values of custlist and session'+App.get('custList')+''+App.get('session'));
            if(App.get('custList')!=null||App.get('custList')!=''){
         conProv.IAM_DA_Customer_List__c=App.get('custList');
            }else{
             conProv.IAM_DA_Customer_List__c=con.Account.CMI_CId__c;   
            }
         //conProv.IAM_DA_Session_Time_Out__c=App.get('session'); 
         conProv.IAM_DA_Session_Time_Out__c='864000000';
         //Amarnath Mishra added for the connected solution.
         system.debug('====App.get user type====='+App.get('usertype'));
         if(string.isNotBlank(App.get('usertype'))){
                conProv.IAM_User_Type__c =  App.get('usertype');
         }
         //IAM_DA_Calibaration_Role__c
         if(string.isNotBlank(App.get('Role'))){
             conProv.IAM_DA_Calibaration_Role__c =  App.get('Role');
         }
           
        }
        if(appName=='Repair logistics and Service'){
           conProv.IAM_RLS_Group_Admin_Email__c=App.get('rlsEmail');
           conProv.IAM_RLS_Customer_Number__c=App.get('rlsNumber'); 
        }
        try{
            //Amarnath Mishra added for the issue fix D-2854
            list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
            list<String> sss = new list<String>();
            string myMsg;
            
            //insert conProv;
            lstconpro.add(conProv);
            Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
            for (Database.SaveResult sr : lstSR2) {
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
            }
            if(myMsg!='' && myMsg!=null){
                return myMsg;
            }
            else{
                returnString='Record Created';
            }    
            //returnString='Record Created';
        }catch(Exception ex){
            if(ex.getMessage().contains('first error: DUPLICATES_DETECTED')){
                returnString=System.Label.IAM_Existing_Provisioning_Error;
            }
            else{
                
                if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                        returnString = ex.getdmlMessage(0);
                    }
                    else{
                        returnString ='Something went wrong. Please contact System Administrator.';
                }
            }
            
            System.debug('Printing return error'+ex.getMessage());
        }
        return returnString;
    }
    
     @AuraEnabled
    //code to save free application values for Cumpass 2.0 application. this need to check if we can modify code any more.
    public Static string saveFreeApplicationCumpass(id recordid,map<String,String> App,String appName,List<String> modularity,List<String> roleNames){
        string returnString;
        System.debug('Printing the map that got to application cumpas'+App);
        System.debug('Printing application name for cumpas'+appName);
        Contact con=[select id,IAM_Contact_Status__c,Accountid from Contact where id=:recordid];
        List<IAM_Application__c> accApp=[Select id,IAM_Subscription_Name__c,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c,IAM_Subscription_Count__c,IAM_Provisioned_User_Count__c from IAM_Application__c where IAM_Account_Name__c=:con.Accountid AND IAM_Application_Name__c=:App.get('Application')  LIMIT 1];
        System.debug('Account access feature that is going to get assaigned'+accApp);
        IAM_Contact_Provisioning__c conProv=new IAM_Contact_Provisioning__c();
        conProv.IAM_Account_Application__c=accApp[0].id;
        conProv.IAM_Contact__c=con.id;
        conProv.IAM_Application_Name__c=App.get('Application');
        conProv.IAM_Subscription_Name__c=accApp[0].IAM_Subscription_Name__c; // Added as updated duplicate rule to check for subscription name D-2799
        if(con.IAM_Contact_Status__c==System.Label.IAM_Status_Active){
            conProv.IAM_Status__c=System.Label.IAM_Status_Active;
        }else{
            conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
        }
        //conProv.IAM_Status__c='Active';
        conProv.IAM_Start_Date__c=System.Today();
        conProv.IAM_End_Date__c=accApp[0].IAM_Subscription_End_Date__c;
        System.debug('Prinitng record type id value'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(App.get('Application')).getRecordTypeId());
        conProv.recordtypeid=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(App.get('Application')).getRecordTypeId();
        //this needs to be assaigned only when contact status is active because then only Contact will have an associated user.
        if(con.IAM_Contact_Status__c=='Active'){
        System.debug('Entered contact Active Status');
        List<user> usr=[select id from user where Contactid=:con.id and isActive=True LIMIT 1];
            if(!usr.isEmpty()){
                conProv.IAM_User__c=usr[0].id;
            }

        }
       
        if(appName=='Cumpas 2.0'){
            System.debug('Printng Modularity name'+modularity);
            System.debug('Printing role anme'+roleNames);
            System.debug('Printng Modularity name'+App.get('UserGroup'));
            string Modular = string.join(modularity,';');
            string role= string.Join(roleNames,';');
            conProv.IAM_Role__c=role;
            conProv.IAM_Cumpas_Modularity__c=Modular;
            
        }
        try{
            list<IAM_Contact_Provisioning__c> lstconpro = new list<IAM_Contact_Provisioning__c>();
            list<String> sss = new list<String>();
            string myMsg;
            lstconpro.add(conProv);
            //insert conProv;
            Database.SaveResult[] lstSR2 = Database.insert(lstconpro, false);
            for (Database.SaveResult sr : lstSR2) {
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
            }
            if(myMsg!='' && myMsg!=null){
                return myMsg;
            }
            else{
                returnString='Record Created';
            }
            //returnString='Record Created';
        }catch(exception ex){
            //UAT issue#432 by Pratima START
            if(ex.getMessage().contains('first error: DUPLICATES_DETECTED')){
                returnString=System.Label.IAM_Existing_Provisioning_Error;
            }
            else{
                if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                        returnString = ex.getdmlMessage(0);
                    }
                else{
                    returnString ='Something went wrong. Please contact System Administrator.';
                }
            }
            System.debug('Printing return error'+ex.getMessage());
        }
        return returnString;
    }                     
    
    @AuraEnabled
    //Code to save Subscribed  application values
    Public Static String saveSubApplication(id recordid,map<String,String> appInfo){
        System.debug('Printing all the values in the subscribed '+appInfo);
        String returnString;
        Contact con=[select id,IAM_Contact_Status__c,Accountid from Contact where id=:recordid];
        List<IAM_Application__c> accApp=[Select id,IAM_Subscription_Name__c,IAM_Subscription_Start_Date__c,IAM_Subscription_Count__c,IAM_Provisioned_User_Count__c, IAM_Subscription_End_Date__c from IAM_Application__c where IAM_Account_Name__c=:con.Accountid and IAM_Subscription_Name__c=:appInfo.get('Subscription')];
        if(accApp[0].IAM_Subscription_Count__c!=0){
        IAM_Contact_Provisioning__c conProv=new IAM_Contact_Provisioning__c();
        conProv.IAM_Contact__c=con.id;
        conProv.IAM_Application_Name__c=appInfo.get('Application');
        conProv.IAM_Role__c=appInfo.get('Role');
        if(con.IAM_Contact_Status__c==System.Label.IAM_Status_Active){
            conProv.IAM_Status__c=System.Label.IAM_Status_Active;
        }else{
            conProv.IAM_Status__c=System.Label.IAM_Status_Pending;
        }
        //conProv.IAM_Status__c='Active';
        conProv.IAM_Start_Date__c=accApp[0].IAM_Subscription_Start_Date__c;
        conProv.IAM_End_Date__c=accApp[0].IAM_Subscription_End_Date__c;
        conProv.IAM_Subscription_Name__c=accApp[0].IAM_Subscription_Name__c; // Added as updated duplicate rule to check for subscription name D-2799
        System.debug('Printng application name'+appInfo.get('Application'));
        System.debug('Printing record type name'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appInfo.get('Application')).getRecordTypeId());
        conProv.recordtypeid=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appInfo.get('Application')).getRecordTypeId();
        //conProv.recordtype.id=[select id from RecordType WHERE SobjectType='IAM_Contact_Provisioning__c' AND Name=:Application LIMIT 1].id;
        //this needs to be assaigned only when contact status is active because then only Contact will have an associated user.
        if(con.IAM_Contact_Status__c=='Active'){
        System.debug('Entered contact Active Status');
        List<user> usr=[select id from user where Contactid=:con.id and isActive=True LIMIT 1];
            if(!usr.isEmpty()){
                conProv.IAM_User__c=usr[0].id;
            }

        }
        //After assaigning values
        try{
            insert conProv;
            returnString='Record Created';
        }catch(exception ex){
            if(ex.getMessage().contains('first error: DUPLICATES_DETECTED')){
                returnString=System.Label.IAM_Existing_Provisioning_Error;
            }
            else{
                if(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                    returnString = ex.getdmlMessage(0);
                }
                else{
                    returnString ='Something went wrong. Please contact System Administrator.';
                }
            }
            System.debug('Printing return error'+ex.getMessage());
          
        }
        }else{
            returnString='Subcriptions for this Locations are over.';
        }    
        return returnString;
    }
    
}