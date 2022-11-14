/*
Description     : This batch class is used to inactivate Field Test Guidanz Mobile user subscription for Internal users
if its expiration date is less than today. It is needed because internal users may have different end dates. 
History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Shubhangi Sardar            06/24/2020        INITIAL DEVELOPMENT          
1.1 -    Shubhangi Sardar            12/03/2020        Added NPBU Diagnostic Expration app
1.2 -    Ganesh K M                  16/05/2022        Made changes to pull only records having subscription end date
                                                       less than today's date. 
*/
global class IAM_Remove_Subscriptions_User implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date todayDate =  Date.today(); 
        String inactive = Label.IAM_Inactive_Label;
        String appName = Label.IAM_App_GuidanzMobileFieldTest;
        /* 12/03/2020  - Added NPBU Diagnostic app */       
        String appNameNPBU = Label.IAM_FT_NPBU_Diagnostics;
        String query;        
        if(Test.isRunningTest()){
            query = 'SELECT Id, Name, IAM_Reject_Reason__c, IAM_End_Date__c FROM IAM_Contact_Provisioning__c LIMIT 10';
        }
        else{
            /* 12/03/2020  - Added NPBU Diagnostic app */
            query = 'SELECT Id, Name, IAM_Reject_Reason__c, IAM_Status__c'
                + ' ' + 'FROM IAM_Contact_Provisioning__c'
                + ' ' + 'WHERE IAM_End_Date__c < :todayDate'
                + ' ' + 'AND IAM_Status__c != :inactive'
                + ' ' + 'AND (IAM_Application_Name__c = :appName'
                + ' ' + 'OR IAM_Application_Name__c = :appNameNPBU)'
                + ' ' + 'AND IAM_Contact__r.Account.IAM_Internal_Account__c = True'
                + ' ' + 'AND IAM_Contact__r.Account.Type = \'Internal\''
                + ' ' + 'And IAM_Contact__r.IAM_Internal__c = True';
        } 
        system.debug('Query ::'+query);
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<IAM_Contact_Provisioning__c> userSubscriptions) {
        Set<Id> idsToDeactivate= new Set<Id>();
        List<IAM_Contact_Provisioning__c> inactiveSubList = new List<IAM_Contact_Provisioning__c>();
        String Inactive = System.label.IAM_Inactive_Label;
        for(IAM_Contact_Provisioning__c conPro : userSubscriptions){
            conPro.IAM_Status__c= Label.IAM_Inactive_Label;
            conPro.IAM_Reject_Reason__c = Label.IAM_Subscription_Expired;
            inactiveSubList.add(conPro);
        }
        System.debug('=====inactiveSubList===== '+inactiveSubList);
        
        Database.SaveResult[] srList = Database.update(inactiveSubList, false);
        System.debug('=====srList====='+srList);
        for (Database.SaveResult sr : srList) {
           if (sr.isSuccess()) {
              idsToDeactivate.add(sr.getId());
              System.debug('Successfully updated Invoice. Invoice ID is : ' + sr.getId());
           }
        }
    }
     
    global void finish(Database.BatchableContext BC) {
        
    }
}