@istest
class CSS_WS_DetailsByUS_Test {
    static testmethod void testDetailsUS() {
    
        CSS_WS_Warranty__c Claim = new CSS_WS_Warranty__c(
            CSS_WS_IMS_Claim_Number__c = '12345',
            Name = '67890'
        );        
        insert Claim;
            
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        CSS_WS_DetailsByUS jobUSDetails = new CSS_WS_DetailsByUS();
        jobUSDetails.CSS_WS_DetailsByUS(Claim.Id);
        //jobUSDetails.detailsByUS(Claim.id);
        System.enqueueJob(jobUSDetails);
        
        Test.stopTest();
    }    
}