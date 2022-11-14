@isTest
public class dbu_InventoryUtilWrapper_Test {

    @isTest
    static void testmethod1(){
        Test.startTest();
        dbu_InventoryUtilWrapper yu = new  dbu_InventoryUtilWrapper();
        	dbu_InventoryCheck_Result__c lioning = new dbu_InventoryCheck_Result__c();
            yu.inventoryResult = lioning;
        Test.stopTest();
    }
    
}