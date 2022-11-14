@isTest
public class EVL_CL_RetryFieldActions_Test {
    
    static testMethod void RetryFieldActions() {
        WorkOrder objWorkOrder = new WorkOrder();
        //objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        //objWorkOrder.AccountId = objAccount.Id;
        //objWorkOrder.WorkTypeId = objWorkType.Id;
        //objWorkOrder.AssetId = objAsset.Id;
        insert objWorkOrder;

        EVL_CL_RetryFieldActions.getWorkOrderInfo(objWorkOrder.Id);
        
        EVL_CL_RetryFieldActions.getFADetails(objWorkOrder.Id);
    }
}