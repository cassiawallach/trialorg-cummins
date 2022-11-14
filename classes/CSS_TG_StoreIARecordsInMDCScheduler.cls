global class CSS_TG_StoreIARecordsInMDCScheduler implements Schedulable{
    
	global void execute(SchedulableContext sc){
       try{
           System.debug('in execute of CSS_TG_StoreIARecordsInMDCScheduler...');
           /*String qry = 'SELECT Id, ApexClassID, CompletedDate, ExtendedStatus, JobItemsProcessed, JobType, MethodName, NumberOfErrors, Status, TotalJobItems FROM AsyncApexJob WHERE JobType=\'BatchApex\' and ApexClassID = \'01p3B000000CIHFQA4\' and Status = \'Processing\' ';
           List<AsyncApexJob> jobList = Database.query(qry);
		   System.debug('AsyncApexJob size>>>>:'+jobList.size());
           if(jobList == null || jobList.size()<=0)
               return;*/
           
           //String recordTypeId = Label.CSS_IAInbox_RecordTypeId; //'0123B0000008g0LQAQ';
           //String query = 'Select Id, Name, ACCESS__c, Algorithm__c, Complaint_Text__c, Created_By__c, CSS_Enabled__c, CSS_Job_Number__c, Customer_Company_Name__c, ERT__c, MAKE__c, MDC_Sent_DateTime__c, MDC_Status__c, MODEL__c, PSN__c, Request_JSON__c, Response_JSON__c, ReturnCodeDescription__c, SenderID__c, SERVICEMODELNAME__c, ServiceName__c, ServiceVersion__c, Status__c, TargetID__c, ToolID__c, Updated_By__c, User_Location__c, User_Location_filtered__c, Version__c from CSS_DataExchange_Parent__c where MDC_Status__c=false and RecordType.Name=:recordTypeIA limit 500';
           //String query = 'Select Id, Name, ACCESS__c, Algorithm__c, Complaint_Text__c, Created_By__c, CSS_Enabled__c, CSS_Job_Number__c, Customer_Company_Name__c, ERT__c, MAKE__c, MDC_Sent_DateTime__c, MDC_Status__c, MODEL__c, PSN__c, Request_JSON__c, Response_JSON__c, ReturnCodeDescription__c, SenderID__c, SERVICEMODELNAME__c, ServiceName__c, ServiceVersion__c, Status__c, TargetID__c, ToolID__c, Updated_By__c, User_Location__c, User_Location_filtered__c, Version__c from CSS_DataExchange_Parent__c where MDC_Status__c=false and RecordType.Name=\'IA-Inbox\' ';
           String query = 'Select Id, Name, ACCESS__c, Algorithm__c, Complaint_Text__c, Created_By__c, CSS_Enabled__c, CSS_Job_Number__c, Customer_Company_Name__c, ERT__c, MAKE__c, MDC_Sent_DateTime__c, MDC_Status__c, MODEL__c, PSN__c, Request_JSON__c, Response_JSON__c, ReturnCodeDescription__c, SenderID__c, SERVICEMODELNAME__c, ServiceName__c, ServiceVersion__c, Status__c, TargetID__c, ToolID__c, Updated_By__c, User_Location__c, User_Location_filtered__c, Version__c, CreatedDate, LastModifiedDate from CSS_DataExchange_Parent__c where MDC_Status__c=false and RecordTypeId=\''+Label.CSS_IAInbox_RecordTypeId+'\'';
           System.debug('after query of CSS_TG_StoreIARecordsInMDCScheduler...');
           if(query != null){
                CSS_TG_IARecordsStoreBatch storeBatch = new CSS_TG_IARecordsStoreBatch(query);
                Id batchProcessId = Database.ExecuteBatch(storeBatch,200);
           }
       }catch(Exception ex){
           System.debug('in catch of execute of CSS_TG_StoreIARecordsInMDCScheduler>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
       }
    }
    
}