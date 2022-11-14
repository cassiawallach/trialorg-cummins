/************************************************************************************************
Name:FSL_CL_QSOLIntegrations
Copyright Â© 2019  Cummins
=================================================================================================
=================================================================================================
Purpose:                                                            
-------  
This class is to open QSOL Links(Procedure links) within the Solution Content and display of Fault
Code Overview
==================================================================================================
==================================================================================================
History                                                             
-------                                                            
VERSION     AUTHOR                     DATE         DETAILS                          
1.0     	SRIPRADA SESHAM			04/16/2019      Initial Devlopment 
1.1         Harsha				    05/03/2020      MODIFICATIONS
1.2			Rajender Mittapalli		06/22/2022		Added Named Credentials
***************************************************************************************************/
public class FSL_CL_QSOLIntegrations {
    /* Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
Static String executionLog = 'Log Start';*/
    public static string getToken(String serviceName)
    {
        string reqBody;
        string apiKey;
        string clientId;
        string endPoint = '';
        
        HttpRequest req = new HttpRequest();
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_Integration_Details__c.getValues(serviceName);//Causeing EVL_CL_GETSOLUTIONS_Test failure | Remove Comment Later Devon
        
        System.debug('conDetails'+conDetails);
       // test.isRunningTest(true);
        if(conDetails != null && conDetails.End_Point__c != null && conDetails.End_Point__c != ' ')  //CT2-388 : null check added     
            endPoint = conDetails != null ? conDetails.End_Point__c : '';//Causeing EVL_CL_GETSOLUTIONS_Test failure | Remove Comment Later Devon
            apiKey = conDetails != null ? conDetails.Passcode__c : '';   //CT2-388 : null check added
            clientId = conDetails != null ? ConDetails.Username__c : '';//CT2-388 : null check added
        reqBody = '{"apiKey":"'+apiKey+'","clientId":"'+clientId+'"}';
        
        system.debug('apiKey**'+apiKey);
        system.debug('clientId**'+clientId);
        system.debug('reqBody**'+reqBody);
        
        req.setEndpoint(endPoint);
        
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(reqBody);
        // req.setHeader('apiKey','apiKey');
        // req.setHeader('clientId','clientId');
        System.debug('Request:::: '+req);
        
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        res = http.send(req);
        string response = res.getBody();
        system.debug('Response:::: '+response);
        string token = '';
        if(response.contains('{"apiToken":'))
        {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null)
            {
                if(parser.getText() == 'apiToken')
                {
                    parser.nextToken();
                    token = (parser.getText());
                }
            }
        }
        return token;
    }
    
    //-----CT3-44 ----
    //Modified By: Dinesh Yadav, 28 Sept 2020 For QSOL launguage. //Added String lang
    public static string CallForProcedureLink(String docId,String srNumber,string busUnit,string doctype, String lang)
    {
        //String endPoint = 'https://qs-stg.cummins.com/integrationservices/api/linkMgmt?businessUnit='+busUnit+'&language=en&documentType=PRO&documentId='+docId+'&serialNumber='+srNumber;
        String accessToken = getToken('FSL_GetApiToken_QSOL');   
        string endPoint;
        Integer timeout;
        string serviceName;
        DateTime startTime = System.Now();
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_ProcedureLink');
        //conDetails = CSS_getConnnectionDetails.getConnection(serviceName); 
        System.debug('conDetails'+conDetails);
        endPoint = conDetails.End_Point__c;
        timeout = Integer.valueOf(conDetails.Timeout__c);
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(endPoint+'businessUnit='+busUnit+'&language='+lang+'&documentType='+doctype+'&documentId='+docId+'&serialNumber='+srNumber);        
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+accessToken);  
        String strreq = req.toString();//added by Ravikanth For error log
        System.debug('request=== '+req.getBody());  
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        if(string.isNotEmpty(accessToken))
        {
            res = http.send(req);   
        }
        string resBody='';
        if(res <> null)
            resBody = res.getBody();
        string solLink ;
        if(resBody.contains('qsolLink'))
        {          
            JSONParser parser = JSON.createParser(resBody);  
            while (parser.nextToken() != null)
            {   
                system.debug('parser.getText : '+parser.getText());
                if(parser.getText() == 'qsolLink') 
                {   
                    system.debug('parser.getText : '+parser.getText());
                    parser.nextToken();
                    parser.nextToken();
                    solLink = (parser.getText());
                    System.debug('solLink = '+solLink);
                } 
            } 
        }
        //public (String ReqBody,String ResBody,RestRequest request, RestResponse response, String serviceName, String status, String serviceVersion, String toolId, String senderId,Id workorderid,String Sourcesystem){
        
        if(!Test.isRunningTest()) system.enqueuejob(new FSL_ApplicationLoggerQueueable(strreq,res.getBody(),Null,Null,'FSL_QSOL_ProcedureLink',res.getStatus(),'code','toolid','Guidanz',NULL,'QSOL')); 
        return solLink;
    }
    
    //call out for retrieve option list
    public static string CallForOptionList(String srNumber)
    {
        
        String accessToken = getToken('FSL_GetApiToken_QSOL');   
        string endPoint;
        string serviceName;
        
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_RetrieveOptionList');
        //conDetails = CSS_getConnnectionDetails.getConnection(serviceName); 
        System.debug('conDetails'+conDetails);
        endPoint = conDetails.End_Point__c;
        // executionLog = FSL_ApplicationLogger.logMessage('End point URL '+endPoint,executionLog,isEligibleForAppLogging);
        HttpRequest req = new HttpRequest();        
        req.setEndpoint(endPoint+'serialNumber='+srNumber);        
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+accessToken);        
        System.debug('request=== '+req);        
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        String strreq = req.toString();//added by Ravikanth For error log
        system.debug('check re'+strreq);
        if(string.isNotEmpty(accessToken))
        {
            res = http.send(req);   
        }        
        System.debug('response=== '+res.getBody());
        string resBody = res.getBody();
        DateTime startTime = System.Now();
        system.debug('debug inside options list'+req.getBody());
        system.enqueuejob(new FSL_ApplicationLoggerQueueable(strreq,res.getBody(),Null,Null,'FSL_QSOL_RetrieveOptionList',res.getStatus(),'code','toolid','Guidanz',NULL,'QSOL')); 
        return resBody;
    }
    
    // CAll OUT
    public static FSL_FCOverview_Wrapper getOverViewCall(String esnCode,String fcCode, String lang)
    {       
        // String endPoint = 'https://qs-stg.cummins.com/integrationservices/api/getFaultCodeOverview?serialNumber='+esnCode+'&faultCode='+fcCode+'&Language='+lang;        
        // String reqBody ='{"serialNumber":"esnCode", "faultCode": "fcCode", "Language":"en"}';
        string serviceName;
        string endPoint;
        String accessToken = getToken('FSL_GetApiToken_QSOL');        
        HttpRequest req = new HttpRequest();        
        
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_FCOverview');
        //conDetails = CSS_getConnnectionDetails.getConnection(serviceName); 
        System.debug('conDetails'+conDetails);
        endPoint = conDetails.End_Point__c;
        //executionLog = FSL_ApplicationLogger.logMessage('End point URL '+endPoint,executionLog,isEligibleForAppLogging);
        req.setEndpoint(endPoint+'serialNumber='+esnCode+'&faultCode='+fcCode+'&language='+lang);        
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+accessToken);
        // req.setBody(reqBody);
        String strreq = req.toString();
        System.debug('request=== '+req.getBody());
        
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        if(string.isNotEmpty(accessToken))
        {
            res = http.send(req);   
        }        
        System.debug('response=== '+res.getBody());
        string resBody = res.getBody();
        FSL_FCOverview_Wrapper obj = new FSL_FCOverview_Wrapper();
        if(res.getStatusCode() == 200)
        {
            try
            {
                obj = (FSL_FCOverview_Wrapper)JSON.deserializeStrict(resBody,FSL_FCOverview_Wrapper.class);   
                
                system.enqueuejob(new FSL_ApplicationLoggerQueueable(strreq,res.getBody(),Null,Null,'FSL_GetFCOverview',res.getStatus(),'code','toolid','Guidanz',NULL,'QSOL')); 
            }
            catch(Exception e)
            {
                //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'FSL_GetFCOverview',res.getStatus(),'code','toolid','Guidanz',NULL,'QSOL')); 
                System.debug('An exception occurred: ' + e.getMessage());
            }        
        }
        system.debug(' obj =='+ obj);
        DateTime startTime = System.Now();
        return obj;
    }
    
     // CAll OUT
    public static FSL_CL_ServiceHistoryWrapper getServiceHistory(String esnNo,String locationId, String itemNumber)
    {   
        //Start Road-369: Rajender
        FSL_CL_ServiceHistoryWrapper shw;
        string resBody = '';
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper = null;
        try {
            //Start : Harsha added this code
            // For TargetId
            User usr = new User();
            usr = [SELECT Id,ERP__c
                   FROM User
                   WHERE Id=:UserInfo.getUserId() LIMIT 1];
            String TargetERP;
            TargetERP = (String)usr.ERP__c;
            //End
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.methodType = 'GET';
            reqWrapper.NamedCredential = 'FSL_NC_Services';
            reqWrapper.Path = '/servicehistory?'+'sender=CSS'+'&target='+TargetERP+'&locationId='+locationId+'&esn='+esnNo;
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            
            returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            system.debug('StatusCode#####: '+returnWrapper.response.getStatusCode());
            system.debug('Status#####: '+returnWrapper.response.getStatus());
            system.debug('Response body#####:'+returnWrapper.response.getbody());
            resBody = returnWrapper.response.getBody();
            
            if(returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201) {
                System.debug('Entered into FSL_CL_QSOLIntegrations getServiceHistory error');
                throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
            }
            if(Test.isRunningTest()){
                resBody ='{"Header": {"Sender": {"ServiceName": "GetServHistory","SenderID": "Guidanz"},"Target": {"TargetID": "BMS"     },"Location": {"LocationID": "02860-19173"    },"ReturnCodeDescription": "","Status": "SUCCESS"},"DataArea": [ {"WorkSummaryCOMPLAINT": "UNIT 140167","WorkSummaryCAUSE": "DSBKL036","ReceivedDate": "2016-03-30T08:39:52.000-05:00","BMSLink": "","BMSWOreference": "185758690","CustomerName": "SWIFT TRANSPORTATION","DistanceType": "MILES","FaultcodesCORRECTION": "MED","ProductModel": "ISX 400ST","Distance": "357989","UnitHours": "","Location": "001-711"     }]}';
            }
        }
        catch(Exception e){
            System.debug('An exception occurred: ' + e.getMessage());
            System.debug('Exception linenumber is :: '+e.getLineNumber());
            system.debug('exception message is --> '+ e.getTypeName());
        }
        shw = (FSL_CL_ServiceHistoryWrapper)JSON.deserializeStrict(resBody,FSL_CL_ServiceHistoryWrapper.class);
        system.debug('shw##### '+ shw);
        return shw;
        //End Road-369: Rajender
    }
    
    public class CSS_CustomException extends Exception {
        
    }
}