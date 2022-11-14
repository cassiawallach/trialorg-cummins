@isTest
public class FSL_CreateAddressAndLocationBatch_Test{

    @isTest
    public static void test_Batch(){
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        insert acc; 
        
        Account acc1 = new Account();
        acc1.RecordTypeId=accRecId;
        acc1.Name='Timothy';
        insert acc1; 
        
        IAM_CDH_Cross_references__c cross = new IAM_CDH_Cross_references__c();
        cross.Name = 'test';
        cross.FSL_Address_Line_1__c = '1595 N National Rd';
        cross.IAM_Account__c = acc1.Id;
        cross.FSL_Tax_District__c = 'NON';
        cross.FSL_Country__c = 'Canada';  
        insert cross;
        
        Test.startTest();
        Database.executeBatch(new FSL_CreateAddressAndLocationBatch());
        Test.stopTest();
        
    }
}