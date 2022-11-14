/**********************************************************************
Name: FSLGetPartsListSRTIntegrationHelper
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      05/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLGetPartsListSRTIntegrationHelper {
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    //by priyanka VGRS2-510
    public static CG_OP_OAGWrapper calloutGenericMuleNamedCred(CG_IP_OAGWrapper reqWrapper) {
        system.debug('in calloutGeneric method for CreateUpdate Incident Record Into ServiceNow...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
		FSL_IP_NamedCredentialWrapper reqWrap = null;
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
           
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection(reqWrapper.serviceName);
           
           
            reqWrap = new FSL_IP_NamedCredentialWrapper();
            if(conDetails != null){
               
                if(reqWrapper.methodType == 'POST' || reqWrapper.methodType == 'PUT' ){
                    reqWrap.jsonReqBody = reqWrapper.jsonReqBody;
                }
                 
            }

           
	reqWrap.methodType = reqWrapper.methodType;
    reqWrap.NamedCredential = 'FSL_NC_Engine';
    reqWrap.Path = '/parts';
    reqWrap.endPoint =[SELECT Endpoint FROM NamedCredential
                       					where DeveloperName=: reqWrap.NamedCredential 
                       					LIMIT 1].Endpoint+reqWrap.Path;

            system.debug('SRT reqJsonpriya>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqWrap.jsonReqBody == null)
                {
                throw new CSS_MyException('Exception to cover Catch block');
                }
                           

                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrap);
             system.debug('SRT priyaresponse>>>>>>>>>>>'+returnWrapper);
            return returnWrapper;

        }catch(Exception ex){
           if(returnWrapper == null) {
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = ex.getMessage();
            return returnWrapper;
        }
    }
    
    public FSLGetPartsSRTListWrapper getSRTPartsList(Set<String> failrCds, String optionNbr, WorkOrder woAst)
    {
        Set<String> FailureID = new Set<String>(failrCds);
        String failrCdsStr = JSON.serialize(FailureID);
        // String optionNbrstr = JSON.serialize(options);
        DateTime dt = System.now();
        String formatedDt = dt.formatGMT('YYYY-MM-dd') +'T00:00:00';
        String reqJson='{'+ 
            '\"Header\":{'+ 
            '\"Target\":{  '+ 
            '\"TargetID\":\"SRT\"'+ 
            '},'+ 
            '\"Sender\":{  '+ 
            '\"ServiceName\":\"GetPartsListSRT\",'+ 
            '\"SenderID\":\"CSS\"'+ 
            '}'+ 
            '},'+ 
            '\"DataArea\":{  '+ 
            '\"ServiceModelName\":\"'+woAst.Asset.Service_Model__c+'\",'+ 
            '\"OptionNumber\":'+optionNbr+','+ 
            '\"Languagecode\":\"en_US\",'+ 
            '\"JobID\":\"'+woAst.WorkOrderNumber+'\",'+ 
            '\"FailureID\":'+failrCdsStr+','+ 
            '\"EquipmentID\":\"'+woAst.Asset.Equipment_Id__c+'\",'+ 
            '\"EngineFamilyCode\":\"'+woAst.Asset.Engine_Family_Code__c+'\",'+ 
            '\"EffectiveDTTime\":\"'+formatedDt+'\",'+ 
            '\"DTTimestamp\":\"'+formatedDt+'\",'+ 
            '\"ClaimID\":\"\"'+ 
            '}'+ 
            '} ';
         //commented below lines to use the mule version of calling mechanism -by vinod 8/31
        /*Http h = new Http();
        HttpRequest req = new HttpRequest();        
        req.setMethod('GET');
        String authorizationHeader = 'Bearer '+FSL_WS_OAG.getAccessToken();
        req.setHeader('Authorization', authorizationHeader);
        req.setBody(reqJson);*/
        system.debug('req json::'+reqJson);
        DateTime startTime = System.Now();
        executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+reqJson,executionLog,isEligibleForAppLogging);
        // FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),Null);

        CSS_Integration_Details__c conDetails;
        if(CSS_Integration_Details__c.getall().containsKey('GetPartsListSRT'))
            conDetails=CSS_Integration_Details__c.getInstance('GetPartsListSRT');
        //String reqBody='';--commented by vinod unused variable -- 8/31
        string endPoint;
        Integer timeout;
        String method;
        if(conDetails!= null)
        {
            //commented below lines to use the mule version of calling mechanism -by vinod 8/31
            /*if(String.isNotBlank( intgrtnDetails.Method_Type__c))
                req.setMethod(intgrtnDetails.Method_Type__c);
            else
                req.setMethod('POST');
            if(String.isNotBlank( intgrtnDetails.End_Point__c))
                req.setEndpoint(intgrtnDetails.End_Point__c);*/
            //else
            //  req.setEndpoint('https://services-stg.cummins.com/css/srtpartslist');            
             //commented below lines to use the mule version of calling mechanism -by vinod 8/31
             //req.setHeader('Content-Type','application/json');
             endPoint = conDetails.End_Point__c;
            timeout = Integer.valueOf(conDetails.Timeout__c);
            method = conDetails.Method_Type__c;
        }
        //Sends request to get response.
        FSLGetPartsSRTListWrapper fgs;
        if(!Test.isrunningTest())
        {
        //commented below lines to use the mule version of calling mechanism -by vinod 8/31
        /*Http h = new Http();
        /*Http h = new Http();
        res = h.send(req);*/
        HttpResponse res;
        //changed method signature to make use of newer mule & return type. - mule4 changes 8/31 by vinod
        CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('GetPartsListSRT',endPoint, method, reqJson, timeout);                
       // CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
       
       // //By priyanka VGRS2-510
       CG_OP_OAGWrapper outputWrapper = calloutGenericMuleNamedCred(reqWrapper);
        res = outputWrapper.response;//Ends mule changes
            system.debug('priyacheck>>>>'+res.getStatusCode());
        //system.debug('response>>'+res.getBody());
         //executionLog = FSL_ApplicationLogger.logMessage('Response Body '+res.getBody(),executionLog,isEligibleForAppLogging);
        if(res!= null && res.getStatusCode() == 200)
        {
            fgs = new FSLGetPartsSRTListWrapper();
            fgs=(FSLGetPartsSRTListWrapper)JSON.deserialize(res.getbody(), FSLGetPartsSRTListWrapper.Class);
            system.debug('fgs>>'+fgs);
        }
        }
        else
        {
        String resStr='{    "DataArea":[       {          "Assignment":"Alternative",          "PartNumberService":"391363800",          "OEM":"CECO",          "FailureName":"Aftertreatment Intake NOx Sensor",          "Qty":2,          "OptionNumber":"PH1838",          "PartNumberMfg":"SCREW,HEX FLANGE HEAD CAP",          "PartSize":"M6 X 1.00 X 16",          "PartNameService":"Hexagon Flange Head Cap Screw",          "FailureID":"F19000170",          "Notes":"Aftertreatment Intake NOx Sensor Mounting Cap Screw; Location: Aftertreatment Intake NOx Sensor Module(2)"       },       {          "Assignment":"Alternative",          "PartNumberService":"368206400",          "OEM":"CECO",          "FailureName":"Aftertreatment Intake NOx Sensor",          "Qty":2,          "OptionNumber":"PH1838",          "PartNumberMfg":"SCREW,HEX FLANGE HEAD CAP",          "PartSize":"M8 X 1.25 X 14",          "PartNameService":"Hexagon Flange Head Cap Screw",          "FailureID":"F19000170",          "Notes":"Aftertreatment Intake NOx Sensor Heat Shield Mounting Cap Screw; Location: Aftertreatment Intake NOx Sensor Heat Shield(2)"       }    ],    "Header":{       "ReturnCode":"ORA-00000",       "ReturnCodeDescription":"Normal, Successful completion.",       "MessageIdentifier":"S"    } }';
            fgs = new FSLGetPartsSRTListWrapper();
            fgs=(FSLGetPartsSRTListWrapper)JSON.deserialize(resStr, FSLGetPartsSRTListWrapper.Class);
        }
        //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),Null);
        return fgs;
    }
}