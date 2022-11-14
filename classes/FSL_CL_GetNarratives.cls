/*****************************************************************************************************************************
Name : FSL_CL_GetNarratives 

Version                 Date                    Author                             Detail
--------------------------------------------------------------------------------------------------------- 
1.0                  12/08/2021                Rajkumar BT                 To make a service call to Siebel and 
fetch Narratives

******************************************************************************************************************************/
public class FSL_CL_GetNarratives {
    
    public static HttpResponse getNarratives(String siebelNumber){
        HttpResponse httpRes = new HttpResponse();
        try{
            system.debug('Inside Narratives method');
            String connectionName = 'FSL_GetNarratives';
            Id currentUser = System.UserInfo.getUserId();
            
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection(connectionName);
            
            CG_IP_OAGWrapper reqIPWrapper;
            CG_OP_OAGWrapper outputWrapper;
            
            String EndpointURL= '';
            EndpointURL = conDetails.End_Point__c + '?siebelClaimNumber=' + siebelNumber + '&senderID=CSS&targetID=SIEBEL&serviceName=getNotes';
            
            reqIPWrapper = new CG_IP_OAGWrapper();
            reqIPWrapper.serviceName = conDetails.ApplicationName__c;
            reqIPWrapper.methodType = conDetails.Method_Type__c;
            reqIPWrapper.endPoint = EndpointURL;
            
            try {
                if(!Test.isRunningTest()){
                    outputWrapper = CG_WS_Mule.calloutGenericMule(reqIPWrapper);
                }
                else{
                    httpRes.setStatus('OK');
                    httpRes.setStatusCode(200);
                    string json='{"header": {"messageIdentifier": "1-cac8f630-88ec-11ec-ab86-022059974d50","returnCode": 200,"returnCodeDescription": "OK","status": "SUCCESS","message": "Narrative details received from Sebel Warranty","messageType": "S"},"DataArea": {"Header": {"SiebelClaimNumber": "1-60466109","Notes": [{"Note": "Test Notes","NoteType": "Narrative","CreatedDate": "2017-07-31T22:13:10"}]}}}';
                    httpRes.setbody(json);
                    outputWrapper.response = httpRes;  
                }
                httpRes = outputWrapper.response;
                //System.debug('$$ httpRes:'+httpRes.getBody().get('Header'));
                System.debug('$$ httpRes:'+httpRes);
                System.debug('$$ httpRes getStatus:'+httpRes.getStatus());
                System.debug('$$ httpRes getStatusCode:'+httpRes.getStatusCode());
                if(httpRes.getStatusCode() != 200 && httpRes.getStatus() != 'SUCCESS') {
                    //Log the result using FSL_CL_ErrorLogger, if the status is not success or if status code != 200
                    FSL_CL_ErrorLogger.insertIntegrationErrorLog(currentUser, JSON.serialize(reqIPWrapper), String.ValueOf(httpRes.getBody()), 'FSL_CL_GetNarratives', httpRes.getStatus(), null , null, null);
                }
                //system.debug('Narrative Details--'+ httpRes.getBody());
            }
            catch (Exception e) {
                FSL_CL_ErrorLogger.insertIntegrationErrorLog(currentUser, JSON.serialize(reqIPWrapper), String.ValueOf(httpRes.getBody()), 'FSL_CL_GetNarratives', httpRes.getStatus(), null , null, null);
            }
        }
        catch(Exception ex){
            system.debug('Inside GetNarratives exception--' + ex.getMessage() + ' ' + ex.getLineNumber());
        }
        return httpRes;
    }
}