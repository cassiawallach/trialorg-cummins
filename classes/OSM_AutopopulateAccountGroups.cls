/************************************************************
Name:  OSM_AutopopulateAccountGroups
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is batch class to update account groups bulky

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                    DATE              DETAIL                                
1.0 -   Saikomal Kattmudi            14/03/2020     INITIAL DEVELOPMENT          
*************************************************************/
global class OSM_AutopopulateAccountGroups implements Database.Batchable<sObject>,database.stateful {
    
    global set<id> allsuccessids= new set<id>();
    global set<id> allfailureids= new set<id>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        string iamstring='IAM';
        string wwspsstring ='wwsps';
    string usstring='United States';   //Mar-1319 and few field's in below query     
       // Mar-1236 string query='Select ID,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,OSM_HHP_Dealer__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,OSM_Service_Level__c,ParentId,IAM_Service_Provider_Code__c,Is_Training_Account__c,Is_OEM_Acount__c,CSS_DistributorCode__c FROM Account where(RecordType.Name=:iamstring or RecordType.Name=:wwspsstring ) and BillingCountry=:usstring  and OSM_Accountgroupbatch__c=true';
          string query='Select ID,IAM_WWSPS_Regions__c,PSBU_Channel_of_Distribution__c,BillingCountry,OSM_Accountgroupbatch__c,EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c,Type,RecordTypeId,RecordType.Name,EngineRangeDesc__c,Business_Unit__c,ccrz__E_AccountGroup__c,OSM_Market_Segment_Code__c,CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c,ServiceLevel__c,ParentId,IAM_Service_Provider_Code__c,Is_Training_Account__c,Is_OEM_Acount__c,CSS_DistributorCode__c FROM Account where(RecordType.Name=:iamstring or RecordType.Name=:wwspsstring ) and BillingCountry=:usstring  and OSM_Accountgroupbatch__c=true';
          return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        OSM_AutoPopulateAccount.updateAccountGroup(scope);
        Set<Id> set_AccountUpdate = new Set<Id>();
        Database.SaveResult[]  batchrecords = Database.update(scope,false);
        for(integer i=0;i<batchrecords.size();i++){
            if(batchrecords.get(i).isSuccess()){
                allsuccessids.add(batchrecords.get(i).id);
                set_AccountUpdate.add(batchrecords.get(i).id);
               system.debug('in execute method allsuccessids'+allsuccessids);
            }
            
            else if(!batchrecords.get(i).isSuccess()){
                allfailureids.add(batchrecords.get(i).id);
                system.debug('allfailureids'+allfailureids);
            }            
        }

        if(set_AccountUpdate.size() > 0){
            List<Account> list_AccountUpdate = new List<Account>();
            for(Account acc : [SELECT ID, OSM_Accountgroupbatch__c FROM Account WHERE ID IN : set_AccountUpdate]){
                acc.OSM_Accountgroupbatch__c = false;
                list_AccountUpdate.add(acc);
            }
            if(list_AccountUpdate.size() > 0){
                update list_AccountUpdate;
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        system.debug('in finish methodallsuccessids***'+allsuccessids);
        //Mar-1447
        /*List<Account> updateAcc = [Select ID,OSM_Accountgroupbatch__c FROM Account where ID IN : allsuccessids];
        List<Account> toUpdate = new List<Account>();
        if(updateAcc.size() > 0)
        {
        for(Account a : updateAcc)
        {
            a.OSM_Accountgroupbatch__c = false;
            toUpdate.add(a);
        }
        }
        if(toUpdate.size()>0)
        update toUpdate;
        */
        
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors,JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =:BC.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email,'deepa.venkataraman@cummins.com'};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Match Merge Batch ' + a.Status);
        mail.setPlainTextBody('records processed ' + a.TotalJobItems +allsuccessids+
                              'with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}