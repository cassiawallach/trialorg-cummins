/*
 * Written by Venkat on 12/14/2017
 */
@isTest
public class CSS_TG_IARecordsStoreBatch_Test {
    static testMethod void CSS_TG_IARecordsStoreBatch_Test() {
         CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Shanthitest';
            JO.Status__c = 'Intake';
            JO.Unit_Number__c = 'test1234';
            JO.Service_Model__c = 'ISBE CM800';
             JO.CustomerID__c= '123';
             JO.Contact_Name__c= 'shanthicontact';
             JO.Address__c= 'address';
             JO.City__c= 'bangalore';
             JO.ESN__c= '1234';  
             JO.Data_Exchange_Enabled__c=true;
                 
            insert jo;
  
            CSS_Job_Order__c cssjob = [select name from CSS_Job_Order__c where id=:JO.id];
            CSS_DataExchange_Parent__c  parent = new CSS_DataExchange_Parent__c();
            //parent.DataExchange_Status__c='UnProcessed';
            parent.CSS_Job_Number__c =cssjob.name;
            parent.MDC_Status__c = false;
           
           
           insert parent;
           String query = 'Select Id, Name, ACCESS__c, Algorithm__c, Complaint_Text__c, Created_By__c, CSS_Enabled__c, CSS_Job_Number__c, Customer_Company_Name__c, ERT__c, MAKE__c, MDC_Sent_DateTime__c, MDC_Status__c, MODEL__c, PSN__c, Request_JSON__c, Response_JSON__c, ReturnCodeDescription__c, SenderID__c, SERVICEMODELNAME__c, ServiceName__c, ServiceVersion__c, Status__c, TargetID__c, ToolID__c, Updated_By__c, User_Location__c, User_Location_filtered__c, Version__c, CreatedDate, LastModifiedDate from CSS_DataExchange_Parent__c where MDC_Status__c=false ';
           
        Test.startTest();
        CSS_TG_IARecordsStoreBatch storeBatch = new CSS_TG_IARecordsStoreBatch(query);
            Id batchProcessId = Database.ExecuteBatch(storeBatch,200);
        Test.stopTest();
    }
}