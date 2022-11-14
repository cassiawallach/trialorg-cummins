@isTest
private class FSLSiebelCode_Test {
    
    @isTest static void testCallout2() {
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/gettoken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'OAGOAuth';
        conDetails.Method_Type__c = 'POST';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https://services-dev.cummins.com/csswarranty/csssite';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'CSS_SBL_FailCodes'; 
        conDetails1.Method_Type__c = 'POST';
        insert conDetails1;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSLSiebelCodeMock ());
        CSS_SiebelFailCodeResponseJ2A fslcwrapp = new CSS_SiebelFailCodeResponseJ2A();
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        List<CSS_SiebelFailCodeResponseJ2A> res = FSL_siebelService.storeApplicationOrCategoryComplaintList();
    }
    
    @isTest static void testIterable() {
        FSLsiebelIterator  FSLIterator = new FSLsiebelIterator ();
        Test.setMock(HttpCalloutMock.class, new FSLSiebelCodeMock ());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.setMock(HttpCalloutMock.class, new FSLSiebelCodeMock ());
        CSS_SiebelFailCodeResponseJ2A  fslcwrapp = new CSS_SiebelFailCodeResponseJ2A();
        FSL_siebelService FslFaultCodecls1 = new FSL_siebelService();
        String responseBody;
        responseBody = '{"DataArea":{"Details":[{"Active":"N","BusinesUnit":"CMI","ServiceGroupCode":"","UpdatedDate":"2016-11-11T14:44:19.000-06:00","SystemCode":"FY","ComponentCode":"NS","FailureName":"NOZZLE SPRING","SystemName":"INJ (CEL)","ComponentName":"NOZZLE SPRING","Created":"2016-11-11T14:40:01.000-06:00"},{"Active":"Y","BusinesUnit":"CMI","ServiceGroupCode":"16","UpdatedDate":"2016-11-11T14:44:19.000-06:00","SystemCode":"AR","ComponentCode":"CM","FailureName":"COOLING MTG HDWE","SystemName":"MTG ADAPT","ComponentName":"COOLING MTG HDWE","Created":"2016-11-11T14:40:01.000-06:00"}]},"Header":{"Status":"Success","ReturnCode":"","ReturnCodeDescription":"","MessageIdentifier":"3c62aeb8-17d5-4a61-ac45-aa2a6b760553"}}';
        responseBody = ' [ ' + responseBody + ' ] '; 
        FSLIterator.fssCdsRecs = (list<CSS_SiebelFailCodeResponseJ2A>)JSON.deserialize(responseBody ,list<CSS_SiebelFailCodeResponseJ2A>.class);
        // FSL_siebelService.storeApplicationOrCategoryComplaintList();
        Boolean next=FSLIterator.hasNext();
        FSLIterator.Next();
    }
    
    @isTest static void testIterator() {
        FSLSiebelRespIterable fslIterable = new FSLSiebelRespIterable();
        fslIterable.Iterator();
    }
    
    @isTest static void testBatch() {  
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/gettoken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'OAGOAuth';
        conDetails.Method_Type__c = 'POST';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https://services-dev.cummins.com/csswarranty/csssite';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'CSS_SBL_FailCodes';
        conDetails1.Method_Type__c = 'POST';
        insert conDetails1;
        Test.setMock(HttpCalloutMock.class, new FSLSiebelCodeMock ());
        list<CSS_SiebelFailCodeResponseJ2A>  fslcwrapp = new list<CSS_SiebelFailCodeResponseJ2A>();
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        FSL_siebelService FslFaultCodecls1 = new FSL_siebelService ();
        List<CSS_SiebelFailCodeResponseJ2A > res = FSL_siebelService.storeApplicationOrCategoryComplaintList();
        FSLSiebelRespIterable fslIterable = new FSLSiebelRespIterable();
        fslIterable.Iterator();
        FSL_SiebelWSbatch fslBatch = new FSL_SiebelWSbatch();
        string responseBody;
        responseBody = '{"DataArea":{"Details":[{"Active":"N","BusinesUnit":"CMI","ServiceGroupCode":"","UpdatedDate":"2016-11-11T14:44:19.000-06:00","SystemCode":"FY","ComponentCode":"NS","FailureName":"NOZZLE SPRING","SystemName":"INJ (CEL)","ComponentName":"NOZZLE SPRING","Created":"2016-11-11T14:40:01.000-06:00"},{"Active":"Y","BusinesUnit":"CMI","ServiceGroupCode":"16","UpdatedDate":"2016-11-11T14:44:19.000-06:00","SystemCode":"AR","ComponentCode":"CM","FailureName":"COOLING MTG HDWE","SystemName":"MTG ADAPT","ComponentName":"COOLING MTG HDWE","Created":"2016-11-11T14:40:01.000-06:00"}]},"Header":{"Status":"Success","ReturnCode":"","ReturnCodeDescription":"","MessageIdentifier":"3c62aeb8-17d5-4a61-ac45-aa2a6b760553"}}';
        responseBody = ' [ ' + responseBody + ' ] '; 
        fslcwrapp = (list<CSS_SiebelFailCodeResponseJ2A>)JSON.deserialize(responseBody ,list<CSS_SiebelFailCodeResponseJ2A>.class);
        // Database.executebatch(fslBatch);
        fslBatch.execute(null,fslcwrapp);
    }
    
    static testMethod void testScheduleClass() {
        Test.startTest();
        SchedulableContext sc = null;
        FSLSiebelFailCodeSC tsc = new FSLSiebelFailCodeSC();
        tsc.execute(sc);
        Test.stopTest();
    }
}