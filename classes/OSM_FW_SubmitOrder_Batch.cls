global class OSM_FW_SubmitOrder_Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    global list<OSM_Integration_Log__c> list_LogsToUpdate = new list<OSM_Integration_Log__c>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        string orderStatus = 'Failure';
        string target = 'WINLIMS';
        String queryForBatch = 'SELECT Id, Internal_Batch_Log__c, CC_Order__c, Is_Processed__c, Service_Name__c, CC_Order_Item__r.Id   FROM OSM_Integration_Log__c WHERE Is_Processed__c = false  And Status__c =: orderStatus AND Target__c =: target';
        return Database.getQueryLocator(queryForBatch);
    }
    
    
    global void execute(Database.BatchableContext BC, List<OSM_Integration_Log__c> scope){
        for(OSM_Integration_Log__c log : scope){
            
            OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
            list<Id> orderItemList = new list<id>();//added by swetha for mp-719
              orderItemList.add(log.CC_Order_Item__r.Id);//added by swetha for mp-719

            //Add by Swetha For MP_458
            if(log.Service_Name__c =='SubmitOrder'){ 
            	objRet = OSM_FW_SubmitOrder_Handler.getOrderInfo(log.CC_Order__c,false,null);
            	log.Is_Processed__c = true;
           		log.Internal_Batch_Log__c=true;
            	list_LogsToUpdate.add(log);
           }
            else if(log.Service_Name__c =='RefundSubmitOrder'){ 
                objRet = OSM_FW_SubmitOrder_Handler.getOrderInfo(log.CC_Order__c,true,orderItemList);//updated by swetha for mp-719
                log.Is_Processed__c = true;
                log.Internal_Batch_Log__c=true;
                list_LogsToUpdate.add(log);
            }
        }
    }
     //ended by swetha
   
   global void finish(Database.BatchableContext BC){
        /*OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_FW_SubmitOrder_Batch' ;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        insert log;*/
        database.update(list_LogsToUpdate, false);
    }
}