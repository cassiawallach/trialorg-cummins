@isTest(SeeAllData=false)
public class FSL_AccountService_Test {
    
    static testMethod void AccountServiceMehod1(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        //List<Account> ListAcc = new List<Account>();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        insert acc;
        //ListAcc.add(acc);
        Test.startTest();
      set<id> idset=FSL_AccountService.getChildAccountsInHierarchy(acc.id);
        system.debug('idset>>'+idset);
        system.assertEquals(acc.Name, 'Test Account', 'Matched');
        Test.stopTest();
        
    }
    
}