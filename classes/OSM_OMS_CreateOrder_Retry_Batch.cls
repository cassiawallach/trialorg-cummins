/*
======================================================================
Purpose:                                                            
This is  OSM_OMS_CreateOrder_Retry_Batch batch class which will call failure 
records of order to reporcess for Create And Get Order APIs
=======================================================================
*/
//redeploying deployment issues
global class OSM_OMS_CreateOrder_Retry_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable{
    String version;
    
    global OSM_OMS_CreateOrder_Retry_Batch(){
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String emptyStr = ''; 
        
       
        String query = 'Select ID,Max_Activation_Keys__c,Successful_Activation_Keys__c, AllActivationKeysGenerated__c,(SELECT Id,OMS_Product__c FROM ccrz__E_Order__c.ccrz__E_OrderItems__r) From ccrz__E_Order__c WHERE Id IN (SELECT ccrz__Order__c FROM ccrz__E_OrderItem__c where OMS_Product__c = true) and AllActivationKeysGenerated__c = false and OSM_SW_Is_InterCompany_Order__c = false and ccrz__Storefront__c = \'SoftwareStore\' and ccrz__OrderStatus__c = \'Order Submitted\'';
        
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ccrz__E_Order__c> scope)
    {
        Set<ID> orderIdSet = new Set<ID>();
        List<ccrz__E_Order__c> listOrders= new List<ccrz__E_Order__c>();
        for(ccrz__E_Order__c order :scope)
        {
            orderIdSet.add(order.ID);
        }
        
        OSM_SW_OrderActions.call_OMS_GetAndCreateOrder(orderIdSet,null,null,true);
    }
    global void finish(Database.BatchableContext BC)
    {
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_OMS_CreateOrder_Retry_Batch' ;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        insert log;
        
        //OSM_OMS_GetTI_HourlyBatch getTIHourlyBatch = new OSM_OMS_GetTI_HourlyBatch();
        //Database.executeBatch(getTIHourlyBatch,1);
    }
    global void execute(SchedulableContext SC){
       Database.executeBatch(new OSM_OMS_CreateOrder_Retry_Batch(),1);
    }
}