global class OSM_PopulateAccountGroups implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        string iamstring='IAM';
        string wwspsstring ='wwsps'; 
		string query='Select ID,Is_Training_Account__c,IAM_Service_Provider_Code__c,PSBU_Channel_of_Distribution__c,BillingCountry, EBU_Channel_of_Distribution__c,OSM_DA_CustomerID__c,Name, DTNA__c, Type, RecordTypeId, OSM_HHP_Dealer__c, Business_Unit__c,ccrz__E_AccountGroup__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ParentId,CSS_DistributorCode__c  from Account where RecordType.Name=:iamstring or RecordType.Name=:wwspsstring  ';
        return Database.getQueryLocator(query);
    } 
    global void execute(Database.BatchableContext BC, List<Account> scope){
        OSM_AutoPopulateAccount.updateAccountGroup(scope);
        
    } 
    global void finish(Database.BatchableContext BC){
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors,JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =:BC.getJobId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Match Merge Batch ' + a.Status);
        mail.setPlainTextBody('records processed ' + a.TotalJobItems +
                              'with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }

}