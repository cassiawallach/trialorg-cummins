@isTest

private class IAM_getDependentValuesTest{
    @isTest
    static void test01(){
        IAM_getDependentValues obj = new IAM_getDependentValues(); 
        IAM_getDependentValues.getFieldDependencies('IAM_Application__c','IAM_Application_Name__c','IAM_Role__c');
    }
}