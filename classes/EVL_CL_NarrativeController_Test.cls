// Sriprada - Adding comment for deploying changes
@isTest
private class EVL_CL_NarrativeController_Test {
    @isTest static void testCallout() {
        // Set mock callout class 
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'FSL_GetNarratives';
        conDetails.End_Point__c = 'http://www.test.com/test';
        conDetails.ApplicationName__c = 'FSL_GetNarratives';
        conDetails.IsActive__c = true;
        conDetails.AuthEnv__c = 'TestAuthDEV';
        conDetails.ApplicationName__c = 'FSL_TestX_ServiceHistory';
        conDetails.Key__c = 'zgZkT6rJlwriwrawZ+xt5K5Z7O5QvQ83FWZIqXWTest=';
        conDetails.Passcode__c = 'IMkd8o1GfAz1pMzSfsETThGpFRnC8IZhzhp12vAtrr7kdXS61mXmsl2O477jTaTJY/mb144vwQUDGRXTestvA==';
        conDetails.Username__c = '9uX9kGoJoG8h9Nj01BrwZbZe3qrumf4ErRTl05eZCbn8P+j0D+q6IgJgErZVF4OcHoH8A+SuL/pMUsqjzKTest==';
        conDetails.Method_Type__c = 'POST';
        insert conDetails;
        
        EVL_CL_NarrativeController.fetchNarrative('1-1000677569');
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = EVL_CL_NarrativeController.makeCallout('1-1000677569');
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        String actualValue = res.getBody();
        String expectedValue =  '{'+
                        '"header": {' +
                            '"messageIdentifier": "1-6ac9bcb0-747e-11ec-b7d8-022059974d50",' +
                            '"returnCode": 200,' +
                            '"returnCodeDescription": "OK",' +
                            '"status": "SUCCESS",' +
                            '"message": "Narrative details received from Sebel Warranty",' +
                            '"messageType": "S"' +
                        '},' +
                        '"DataArea": {' +
                            '"Header": {' +
                                '"SiebelClaimNumber": "1-60466109",' +
                                '"Notes": [' +
                                    '{' +
                                        '"Note": null,' +
                                        '"NoteType": "Narrative",' +
                                        '"CreatedDate": "2017-07-31T22:13:10"' +
                                    '},' +
                                    '{' +
                                        '"Note": "CUSTOMER COMPLAINT: COOLANT LEAK AT THERMOSTAT HOUSING. INSPECTED, FOUND THERMOSTAT SEAL LEAKING. REPLACED THERMOSTAT. STEAM CLEANED AND RAN ENGINE TO CHECK FOR LEAKS, NONE FOUND.COOLANT LEAK EXTERNALCoolant ThermostatLEAKS WATER21343SM MONDAY 31JUL2017 10:41:11 AM",' +
                                        '"NoteType": "Narrative",' +
                                        '"CreatedDate": "2017-07-31T22:13:10"' +
                                    '}' +
                                ']' +
                            '}' +
                        '}' +
                    '}'; 
        
        
        List<Object> objList = new List<Object>();
        objList.add((Object)JSON.deserializeUntyped(expectedValue));        
        EVL_CL_NarrativeController.translateToListMap(objList);
        EVL_CL_NarrativeController.translateToListMap(null);
        EVL_CL_NarrativeController.updateFields();

    }    
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        // Implement this interface method
        public HTTPResponse respond(HTTPRequest req) {
            // Optionally, only send a mock response for a specific endpoint
            // and method.
            System.assertEquals('http://www.test.com/test', req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            
            // Create a fake response	
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            String successjsonBody = '{'+
                        '"header": {' +
                            '"messageIdentifier": "1-6ac9bcb0-747e-11ec-b7d8-022059974d50",' +
                            '"returnCode": 200,' +
                            '"returnCodeDescription": "OK",' +
                            '"status": "SUCCESS",' +
                            '"message": "Narrative details received from Sebel Warranty",' +
                            '"messageType": "S"' +
                        '},' +
                        '"DataArea": {' +
                            '"Header": {' +
                                '"SiebelClaimNumber": "1-60466109",' +
                                '"Notes": [' +
                                    '{' +
                                        '"Note": null,' +
                                        '"NoteType": "Narrative",' +
                                        '"CreatedDate": "2017-07-31T22:13:10"' +
                                    '},' +
                                    '{' +
                                        '"Note": "CUSTOMER COMPLAINT: COOLANT LEAK AT THERMOSTAT HOUSING. INSPECTED, FOUND THERMOSTAT SEAL LEAKING. REPLACED THERMOSTAT. STEAM CLEANED AND RAN ENGINE TO CHECK FOR LEAKS, NONE FOUND.COOLANT LEAK EXTERNALCoolant ThermostatLEAKS WATER21343SM MONDAY 31JUL2017 10:41:11 AM",' +
                                        '"NoteType": "Narrative",' +
                                        '"CreatedDate": "2017-07-31T22:13:10"' +
                                    '}' +
                                ']' +
                            '}' +
                        '}' +
                    '}'; 
            
            res.setBody(successjsonBody);
            res.setStatusCode(200);
            return res;
        }
    }
}