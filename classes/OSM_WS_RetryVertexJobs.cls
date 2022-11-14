/* Last Modified By: Swetha  for-OMG- 955 */

global class OSM_WS_RetryVertexJobs implements Database.Batchable<sObject>,Database.AllowsCallouts{
    

    global Database.QueryLocator start(Database.BatchableContext BC){
        List<String> status = new List<String>();
        status.add('Failure');
        status.add('Pending');
        // Modified query by swetha
        //String query = 'Select id,Vertex_Call_Status__c, OSM_SW_Is_Refund_Request__c,CC_Invoice__c, CC_Invoice__r.Invoice_Type__c,CC_Invoice__r.Recurring_Invoice__c,CC_Order__c from OSM_Orders_In_Invoice__c where (Vertex_Call_Status__c IN :status and CC_Invoice__r.Invoice_Type__c != \'Credit Memo\' ) OR (OSM_SW_Is_Refund_Request__c = true AND Vertex_Refund_Call_Status__c IN: status and CC_Invoice__r.Invoice_Type__c = \'Credit Memo\')';
        
        String query = 'SELECT id,Vertex_Call_Status__c, OSM_SW_Is_Refund_Request__c,CC_Invoice__c, CC_Invoice__r.Invoice_Type__c,CC_Invoice__r.Recurring_Invoice__c,CC_Order__c FROM OSM_Orders_In_Invoice__c WHERE CC_Order__r.ccrz__Storefront__c =\'SoftwareStore\' AND CC_Order__r.ccrz__OrderStatus__c != \'Failed\' AND ((CC_Order__r.OSM_SW_Is_Bolt_PO__c = false AND CC_Order__r.BMS_OrderRefNumber__c = null) OR (CC_Order__r.OSM_SW_Is_Bolt_PO__c = true AND CC_Order__r.ccrz__TotalAmount__c != 0)) AND ((Vertex_Call_Status__c IN :status AND CC_Invoice__r.Invoice_Type__c  !=\'Credit Memo\' ) OR (OSM_SW_Is_Refund_Request__c = true AND Vertex_Refund_Call_Status__c IN :status AND CC_Invoice__r.Invoice_Type__c = \'Credit Memo\'))';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<OSM_Orders_In_Invoice__c> scope){               
       
        List<Id> lstId = new List<Id>();
        List<Id> lstRefundId = new List<Id>();
        for(OSM_Orders_In_Invoice__c objJun : scope)
            if(objJun.OSM_SW_Is_Refund_Request__c && objJun.Vertex_Call_Status__c == 'Success' && objJun.CC_Invoice__r.Invoice_Type__c == 'Credit Memo')
                lstRefundId.add(objJun.Id);
            else if(objJun.CC_Invoice__r.Invoice_Type__c != 'Credit Memo')
                lstId.add(objJun.Id);
                
        if(lstRefundId != null && lstRefundId.size() > 0)
            OSM_SW_VertexinvoiceTaxCalculation.CalculateRefundInvoiceTax(lstRefundId); 
            
        if(lstId != null && lstId.size() > 0)
            OSM_SW_VertexinvoiceTaxCalculation.calculateInvoiceTax(lstId); 
    }

    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='Scheduled: OSM RetryVertexJobs' ;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
         }       
 		insert log;
        
    }   
}