@isTest
private class FSL_MovexServiceTerritory_Test {
    
    @isTest static void testCallout() {
        String json1 = '{"Header": {"Sender": {"ServiceName": "GetMoveXLOV","SenderID": "CSS"},"Target": {"TargetID": "MOVEX"},"Location": {"LocationID": "05340-05351"}}}';
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails1;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'FSL_QSOL_Getwarrantydocs';
        conDetails.End_Point__c = 'https//test.com/csswarranty/bmssubtype';
        conDetails.DocumentType__c='ALL';
        conDetails.Language__c ='en';
        conDetails.BusinessUnit__c ='EBU';
        //conDetails.Passcode__c = 'Admin';
        //conDetails.Username__c = 'Admin'; 
        insert conDetails;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        List<User> usrInfo = new List<User>();
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com',User_Location__c = '05340-05351');
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        usrInfo.add(u);
        insert u;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 Mobile';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = u.User_Location__c;
        serTer1.FSL_Service_Territory_Code__c = '05351';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        insert serTer1;
        
        FSL_MovexServiceTerritoryWrapper obj = FSL_MovexServiceTerritoryWrapper.parse(json1);
        system.assert(obj != null);
        system.runAs(u) { 
            test.startTest();
            FSL_MovexServiceTerritory st = new FSL_MovexServiceTerritory();
            st.getServiceTerritoryResponse();
            test.stopTest();
        }
    }
    
    @isTest static void testIterator() {  
        Test.startTest();
        FSL_MovexServiceTerritory ser = new FSL_MovexServiceTerritory();
        FSL_MovexServiceTerittoryRespIterable fslIterable = new FSL_MovexServiceTerittoryRespIterable();
        fslIterable.Iterator();
        //fslIterable.hasNext();
        
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        FSL_MovexServiceTerritoryBatchProcess fslBatch = new FSL_MovexServiceTerritoryBatchProcess();
        Database.executebatch(fslBatch);
        
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new FSL_MovexServiceTerritorySC());
        Test.stopTest();      
    }    
    @isTest static void testIterable() {
        
        FSL_MovexServiceTerritoryWrapper wrap = new FSL_MovexServiceTerritoryWrapper();
        FSL_MovexServiceTerritoryIterator ser = new FSL_MovexServiceTerritoryIterator();
        String token;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
       // token = CSS_WS_OAuth.getToken();
        ser.hasNext();
        ser.Next();
        // FSL_MovexServiceTerritoryWrapper wrap1 = ser.next(); 
    }
    
    @isTest static void test_Method_Batch(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        List<User> usrInfo1 = new List<User>();
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com',User_Location__c = '05340-05351');
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        usrInfo1.add(u);
        insert u;
        OperatingHours  oh1 = new OperatingHours ();
        oh1.Name = 'new';
        oh1.TimeZone = 'America/Chicago';
        insert oh1;
        
        ServiceTerritory serTer2 = new ServiceTerritory();
        serTer2.Name = 'ST005 Mobile';
        serTer2.OperatingHoursId = oh1.Id;
        serTer2.IsActive = true;
        serTer2.Location_Code__c = u.User_Location__c;
        serTer2.FSL_Service_Territory_Code__c = '05351';
        serTer2.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer2.Territory__c = 'AUSTRALIA';
        insert serTer2;
        
        list<FSL_MovexServiceTerritoryWrapper> lstMovexWrapperST = new list<FSL_MovexServiceTerritoryWrapper>();
        string responseBody;
        responseBody = '{"DataArea":[{"CodeDescription":"CASH SALES SERVICE - BRISBANE","CodeValue":"130SERV","Code":"Cash Sale Customer"}],"Header":{"Sender":{"ServiceName":"GetMoveXLOV","SenderID":"CSS"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}';
        responseBody = ' [ ' + responseBody + ' ] '; 
        lstMovexWrapperST = (List<FSL_MovexServiceTerritoryWrapper>)JSON.deserialize(responseBody, List<FSL_MovexServiceTerritoryWrapper>.Class);
        FSL_MovexServiceTerritoryBatchProcess fslMovexBatch = new FSL_MovexServiceTerritoryBatchProcess();
        fslMovexBatch.execute(null,lstMovexWrapperST);
    }
}