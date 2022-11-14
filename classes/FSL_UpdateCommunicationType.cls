public class FSL_UpdateCommunicationType {
    @AuraEnabled
    public static void updateType(String Workid){
       // system.debug('updateTypeapex class');
        WorkOrder ObjWorkOrder = new WorkOrder();
        ObjWorkOrder = [select id,Communication_Type__c from WorkOrder  where id =: Workid ];
        ObjWorkOrder.Communication_Type__c = 'Manual Communication';
        Update ObjWorkOrder;
    }
}