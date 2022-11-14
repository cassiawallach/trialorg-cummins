global class FSL_createServiceOrderForAbsenceTSBatch implements Schedulable, Database.Batchable<sObject>, Database.Stateful {
    global static Integer BATCHSIZE = 20;
    global static Id WORecordTypeId_Internal = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();

    //this method is required only if this batch contains Schedulable
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new FSL_createServiceOrderForAbsenceTSBatch(), BATCHSIZE) ;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Set<String> ERPSet = new Set<String>{'BMS','MOVEX','MOVEX-UK'};
            string type_Group = 'GROUP';
        String sQuery = 'SELECT Id, Name FROM ServiceTerritory WHERE ERP__c IN :ERPSet AND Type__c !=: type_Group';
        return Database.getQueryLocator(sQuery);
    }
    
    global void execute(Database.BatchableContext bc, List<ServiceTerritory> serviceTerritoryList){
        try{
            //Savepoint sp = Database.setSavepoint();
            deactivateExistingWorkOrder(serviceTerritoryList);
            List<WorkOrder> workOrderList = createWorkOrder(serviceTerritoryList);
            system.debug('workOrderList++++'+workOrderList);
            //Database.rollback(sp);

        }catch(exception ex){
            system.debug('ERROR - '+ex.getStackTraceString());
        }
    }
    
    global void finish(database.BatchableContext bc){
        // will perform some final tasks
    }
    
    private static List<WorkOrder> deactivateExistingWorkOrder(List<ServiceTerritory> serviceTerritoryList){
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        for(WorkOrder WorkOrderObj: [SELECT Id, FSL_Active__c FROM WorkOrder WHERE RecordTypeId =: WORecordTypeId_Internal AND ServiceTerritoryId IN : serviceTerritoryList AND FSL_Active__c = true]){
            WorkOrderObj.FSL_Active__c = false;
            workOrderList.add(WorkOrderObj);
        }
        update workOrderList;
        return workOrderList;
    }
    private static List<WorkOrder> createWorkOrder(List<ServiceTerritory> serviceTerritoryList){
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        for(ServiceTerritory ServiceTerritoryObj: serviceTerritoryList){
            WorkOrder WorkOrderObj = new WorkOrder();
            WorkOrderObj.RecordTypeId = WORecordTypeId_Internal;
            WorkOrderObj.ServiceTerritoryId = ServiceTerritoryObj.Id;
            WorkOrderObj.FSL_Active__c = true;
            WorkOrderObj.Type__c = 'Internal';
            workOrderList.add(WorkOrderObj);
        }
        insert workOrderList;
        return workOrderList;
    }
    
}