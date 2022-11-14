public class CSM_IncidentSNOWUpdateService {
    public static string getAuthenticationToken(){
        string accessToken='';
        CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('FSL_ServiceNowUpdate').AuthEnv__c,'FSL_ServiceNowUpdate');
        accessToken = accessTokenOPWrap.accessToken;  
        return accessToken;
        
    }
    public static HttpResponse doCallout(Incident inc,string accessToken){
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_getConnnectionDetails.getConnection('FSL_ServiceNow_Get');               
        string endPoint = conDetails.End_Point__c;
        if(string.isNotBlank(endPoint)){
            endPoint=endPoint.replace('{INC}', inc.CSM_Ticket_Incident_Number__c);
        }
        string client_id = conDetails.Username__c; 
        string client_secret = ConDetails.Passcode__c;
        CSS_Integration_Details__c conDetailsMain = new CSS_Integration_Details__c();
        request.setEndpoint(endPoint);
        request.setMethod('GET');
        request.setHeader('client-id', conDetails.Username__c); 
        request.setHeader('client-secret', conDetails.Passcode__c); 
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' +accessToken);
        request.setMethod(conDetails.Method_Type__c);
        response = http.send(request);
        System.debug('response==' + response);
        return response;
    }
     //this comments use for Deployment purpose. Missing CMP Set
}