global class OSM_OMS_GetTI_HourlyBatch implements Database.Batchable<sObject>,Database.AllowsCallouts,Schedulable{
    global OSM_OMS_GetTI_HourlyBatch(){
        
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        String emptyStr = '';
        List<string> list_BasicProd = new List<String>();
        List<string> list_FunctProd = new List<String>();
        list_FunctProd = Label.OSM_SingleLicense_Products.split(',');
        list_BasicProd = Label.OSM_SingleLicense_Basic_Products.split(',');
        String query = '';
        if(Test.isRunningTest()){
            query = 'Select ID, OMS_Product__c, ccrz__Product__r.Name, Activation_Key_Generated__c,Basic_Remaining_Lisences__c, Remaining_Lisences__c, ccrz__Quantity__c, Tool_Instance_Key__c, ccrz__Order__r.ccrz__OrderStatus__c From ccrz__E_OrderItem__c Where isRenew__c = false AND '+
                            +'(Remaining_Lisences__c >0 or Basic_Remaining_Lisences__c>0)';
        
        }else{
            query = 'Select id,oms_product__c, ccrz__product__r.NAME, activation_key_generated__c, basic_remaining_lisences__c, remaining_lisences__c, ccrz__quantity__c, tool_instance_key__c, ccrz__order__r.ccrz__orderstatus__c, ccrz__order__r.OSM_SW_Days_Since_Order_Date__c FROM ccrz__e_orderitem__c WHERE activation_key_generated__c > 0 AND ccrz__product__r.ccrz__sku__c NOT IN : list_FunctProd AND ( remaining_lisences__c > 0 OR basic_remaining_lisences__c > 0 ) AND ccrz__orderitemstatus__c != \'Cancelled\' AND ccrz__order__r.OSM_SW_Days_Since_Order_Date__c < 367 AND ccrz__order__r.ccrz__orderstatus__c = \'Order Submitted\'';
        
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> scope)
    {
        Set<ID> orderItemIdSet = new Set<ID>();
        
        for(ccrz__E_OrderItem__c orderItem :scope)
        {
            
                orderItemIdSet.add(orderItem.ID);
             System.debug('orderItemIdSet_____'+orderItemIdSet);
        }
        
       OSM_OMS_GetTI_Batch_Helper.callGetTILicensesAPI(orderItemIdSet);
    }
    
    
    global void finish(Database.BatchableContext BC)
    {
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM OSM_OMS_GetTI_Batch' ;
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
        System.debug('End : OSM_OMS_GetTI_Batch');
    }
    
    global void execute(SchedulableContext SC){
        Database.executeBatch(new OSM_OMS_GetTI_HourlyBatch(),1); 
    }
}