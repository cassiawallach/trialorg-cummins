@isTest
private class FSL_CustomPartTrigger_Test {
    @TestSetup
    static void makeData(){

        List<FSL_Custom_Part__c> Custom_PartList = new List<FSL_Custom_Part__c>();
        Account account = FSLTestDataSetupCls.createAccountData();
        Asset asset = FSLTestDataSetupCls.createAssetRecord();
        ServiceTerritory serviceTerritory = FSLTestDataSetupCls.createServiceTerritory();
        Workorder workOrder = FSLTestDataSetupCls.createWorkOrder(asset, account, serviceTerritory);

        for(Integer i=0; i<5; i++){
            FSL_Custom_Part__c custom_Part = new FSL_Custom_Part__c();
            custom_Part.Quantity_Used__c = 2;
            custom_Part.Quantity_Edited__c = false;
            custom_Part.Service_Order__c = workOrder.Id;

            Custom_PartList.add(custom_Part);
        }
        insert Custom_PartList;
        
    }
    @isTest
    static void handleAfterUpdate_test(){
        List<FSL_Custom_Part__c> custom_PartUpdatedList = new List<FSL_Custom_Part__c>();
        for(FSL_Custom_Part__c custom_Part : [SELECT Id, Quantity_Used__c, Quantity_Edited__c FROM FSL_Custom_Part__c]){
            custom_Part.Quantity_Used__c += 2;
            custom_PartUpdatedList.add(custom_Part);
        }
        if(!custom_PartUpdatedList.isEmpty())
        update custom_PartUpdatedList;
    }
}