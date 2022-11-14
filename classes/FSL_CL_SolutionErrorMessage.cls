public class FSL_CL_SolutionErrorMessage {
    
    @AuraEnabled
    public static WorkOrder displayerrormessage(string workorderId) {
        System.debug('::: WorkOrder = '+workorderId);
        WorkOrder WO = new WorkOrder();
        WO = [SELECT Id, Process_Step__c, RecordTypeId, IAS_Number__c FROM WorkOrder WHERE Id =: workorderId];
        string recordtypename = Schema.SObjectType.WorkOrder.getRecordTypeInfosById().get(WO.RecordTypeId).getname();
        system.debug('Record Type Id:' + recordtypename);        
        return WO;
    }
}