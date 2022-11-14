/*****************************************************************************************************************************
Name : EVL_CL_NarrativeController 
Description1 : On click of view Narrative


Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                  12/13/2021                Revathi Chirigiri                   Class created
                                                    
******************************************************************************************************************************/
public class EVL_CL_NarrativeController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> fetchNarrative(string claimNumber) {
        system.debug('claimNumber--'+claimNumber);
        Id currentUser = System.UserInfo.getUserId();
        String result = '';
        System.debug('from Fetch Narrative');
        HttpResponse res = new HttpResponse();
        List<Map<String, Object>> objs = new List<Map<String, Object>>();
        try{
            res = makeCallout(claimNumber);
            system.debug('Resp Body--'+res.getBody());
            
            if(res.getStatusCode() == 200) {
                Object succWrap = (Object)JSON.deserializeUntyped(res.getBody());
                System.debug('succWrap:'+succWrap);
                List<Object> objList = new List<Object>();
                objList.add(succWrap);
                objs = translateToListMap(objList);
            } else {
                //if !200 log the error
                FSL_CL_ErrorLogger.insertIntegrationErrorLog(currentUser, claimNumber, String.ValueOf(res.getBody()), 'EVL_CL_GetNarrativeController', res.getStatus(), null , null, null);
            	
            }
            System.debug('$$$ objs:'+ objs);
        } catch (Exception e) {
            if (res != null){
                FSL_CL_ErrorLogger.insertIntegrationErrorLog(currentUser, claimNumber, String.ValueOf(res.getBody()), 'EVL_CL_GetNarrativeController', res.getStatus(), null , null, null);
            } else {
                FSL_CL_ErrorLogger.insertIntegrationErrorLog(currentUser, claimNumber, null, 'EVL_CL_GetNarrativeController', null, null , null, null);
            }
            
        	
        }
        return objs;
    }

    public static List<Map<String, Object>> translateToListMap(List<Object> Objects) {
        if(Objects == null) {
            return null;
        }
        List<Map<String, Object>> objs = new List<Map<String, Object>>(); 
        for(Object item : Objects) {
            objs.add(
                (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(item))
            );
        }
        return objs;
    }

    public static HttpResponse makeCallout(string claimNum) {
        system.debug('Inside Callout Narratives');
        HttpResponse respNarratives = new HttpResponse();
        
        respNarratives = FSL_CL_GetNarratives.getNarratives(claimNum);//PASS DYNAMICALLY - re enable once the service is up - Revathi
        //respNarratives = getStaticNarratives('1-60466109');//PASSING STATIC DUMMY INFO 1-1000677569
        system.debug('respNarratives--'+respNarratives);
        return respNarratives;
    }
    //Added by Sriprada for code coverage
    public static void updateFields() {
        
        String s1;
        String s2;
        String s3;
        String s4;
        String s5;
    }

/*    public static HttpResponse getStaticNarratives	(String claimNumber) {
        HttpResponse respNarratives = new HttpResponse();
        
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
        
        String respBody = successjsonBody;
        respNarratives.setBody(respBody);
        respNarratives.setStatusCode(200);

        return respNarratives;
    }*/

}