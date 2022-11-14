@isTest
private class CSS_WWSPSCertificationInfo_Test {
    static TestMethod void testCallout() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_WWSPSMockResponse()); 
        Account recAcc =  new Account(Name='Test 123', CSS_DBCode__c='16042',Type = 'Distributor Account');
        insert(recAcc);
        Test.startTest();
        list<Account> lstAcc=[select id,name,CSS_DBCode__c, CSS_DistributorCode__c, CSS_DealerCode__c, Location__c
                                from Account where Type IN ('Distributor Account','Dealer Account') and id = :recAcc.Id];
        system.debug('Location Field Value ## ' + lstAcc[0].Location__c);
        CSS_WWSPSCertificationInfo.processWWSPS();
        Test.stopTest();
    }
}