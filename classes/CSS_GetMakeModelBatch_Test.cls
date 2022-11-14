/*
 * Written by Venkat on 11/20/2017
 */
@isTest
public class CSS_GetMakeModelBatch_Test {
    static testMethod void CSS_GetMakeModelBatch_Test() {
        CSS_Make_Model_Access__c makeModel = new CSS_Make_Model_Access__c();
        makeModel.UniqueKey__c = 'test';
        //makeModel.Name ='test';
        insert makeModel;
        
        Test.startTest();
        CSS_GetMakeModel_Batch obj = new CSS_GetMakeModel_Batch();
        Database.executeBatch(obj);
        Test.stopTest();
    }
}