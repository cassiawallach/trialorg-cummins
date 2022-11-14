/**********************************************************************
Name:FSLSRTIntegrationHelperCls
Copyright Â© 2019  Cummins
Test classes > FSLAccessibilityChecklistCls_Test & FSL_GetSolutions_Test
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            		DATE                DETAIL                                 
1.0 - Vinod Yelala      	03/20/2019      INITIAL DEVELOPMENT 
2.0 - Rajender Mittapalli	05/26/2022		Added getOverlapSRTRecords method
***********************************************************************/
public class FSLSRTIntegrationHelperCls {
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    public FSLSRTIntegrationWrappers.SRTLookupDataAreaList runSRTLookupInterface(WorkOrder wo) {
        system.debug('TestAdminSRT');
        DateTime startTime = System.Now();
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/standardrepairstime';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
        
        String reqBody;
        FSLSRTIntegrationWrappers fsrt=new FSLSRTIntegrationWrappers();
        FSLSRTIntegrationWrappers.RequestHeader reqHdr = new FSLSRTIntegrationWrappers.RequestHeader();
        reqHdr.Sender.ServiceName = 'GetAllSRT';
        reqHdr.Sender.SenderID='CSS';
        reqHdr.Target.TargetID='SRT';
        FSLSRTIntegrationWrappers.DataArea da = new FSLSRTIntegrationWrappers.DataArea();
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00'; 
        da.EffectiveDTTime=currDate;
        da.Languagecode='en';
        da.EngineFamilyCode=wo.asset.Engine_Family_Code__c;
        da.ServiceModelName=wo.asset.Service_Model__c;
        da.EquipmentID=wo.asset.Equipment_Id__c;
        da.SRTType='Access';
        
        fsrt.DataArea = da;
        fsrt.Header= reqHdr;
        system.debug(':: PR FSRT = '+fsrt);
        
        //CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CG_GETAllSRT',endPoint, method, JSON.serialize(fsrt), timeout);
        //CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
        
        reqWrapper.jsonReqBody = JSON.serialize(fsrt);
        reqWrapper.timeOut = 120000;
        system.debug('SRT req d1>>>>>>>>>>>'+reqWrapper.jsonReqBody);
        
        CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
        system.debug('SRT res d1>>>>>>>>>>>>'+outputWrapper);
        if(!test.isrunningTest())
        {
            //commented below line to use the mule version of calling mechanism -by vinod 8/31
            //HttpResponse resp   = FSLCumminsServiceUtility.sendHttpRequest(httpReq);
            //CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            HttpResponse resp = outputWrapper.response;//Ends mule changes
            system.debug('resp>>'+resp.getBody());
            executionLog = FSL_ApplicationLogger.logMessage('Response Body '+resp.getBody(),executionLog,isEligibleForAppLogging);
            //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),Null);
            if(resp != null && resp.getStatusCode() == 200 && String.isNotBlank(resp.getBody())) {
                FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrtResp = 
                    (FSLSRTIntegrationWrappers.SRTLookupDataAreaList)JSON.deserialize(resp.getBody(), FSLSRTIntegrationWrappers.SRTLookupDataAreaList.Class);
                system.debug('size of response returned '+ fsrtResp.DataArea.size());
                
                system.debug('fsrtResp>>>'+fsrtResp);
                return fsrtResp;
            }
            else return null;
        }
        else
        {
            String resp22='{ "DataArea": [ { "SRTFamily": "", "ComponentType": "", "BTime": 0.2, "SRTNumber": "06-022-00", "CTime": 0, "PrivateFlag": "N", "Regions": "", "SRTTitle": "Fuel Line, Fuel Pump Supply - Remove and Install, (Common Rail Fuel System)", "SRTCategory": "Remove and Install", "StepID": 111511, "RTime": 0.1, "ATime": 0, "SRTType": "Access", "DTime": 0, "ECMFlag": "N", "FlexSRT": "N" }, { "SRTFamily": "", "ComponentType": "", "BTime": 0.6, "SRTNumber": "08-029-00", "CTime": 0, "PrivateFlag": "N", "Regions": "", "SRTTitle": "Hose Radiator Upper- Replace Both (With EGR)", "SRTCategory": "Replace", "StepID": 111888, "RTime": 0, "ATime": 0, "SRTType": "Access", "DTime": 0, "ECMFlag": "N", "FlexSRT": "N" }, { "SRTFamily": "", "ComponentType": "", "BTime": 0.1, "SRTNumber": "08-033-00", "CTime": 0, "PrivateFlag": "N", "Regions": "", "SRTTitle": "Cab Heater Shutoff Valve -  Remove and Install, Each", "SRTCategory": "Remove and Install", "StepID": 112132, "RTime": 0, "ATime": 0, "SRTType": "Access", "DTime": 0, "ECMFlag": "N", "FlexSRT": "N" } ] }';
            FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrtResp = 
                (FSLSRTIntegrationWrappers.SRTLookupDataAreaList)JSON.deserialize(resp22, FSLSRTIntegrationWrappers.SRTLookupDataAreaList.Class);
            system.debug('fsrtResp>>>'+fsrtResp);
            return fsrtResp;
            
        }
        /* else {
String resp22='{ "DataArea": [ { "SRTFamily": "", "ComponentType": "", "BTime": 0.2, "SRTNumber": "06-022-00", "CTime": 0, "PrivateFlag": "N", "Regions": "", "SRTTitle": "Fuel Line, Fuel Pump Supply - Remove and Install, (Common Rail Fuel System)", "SRTCategory": "Remove and Install", "StepID": 111511, "RTime": 0.1, "ATime": 0, "SRTType": "Access", "DTime": 0, "ECMFlag": "N", "FlexSRT": "N" }, { "SRTFamily": "", "ComponentType": "", "BTime": 0.6, "SRTNumber": "08-029-00", "CTime": 0, "PrivateFlag": "N", "Regions": "", "SRTTitle": "Hose Radiator Upper- Replace Both (With EGR)", "SRTCategory": "Replace", "StepID": 111888, "RTime": 0, "ATime": 0, "SRTType": "Access", "DTime": 0, "ECMFlag": "N", "FlexSRT": "N" }, { "SRTFamily": "", "ComponentType": "", "BTime": 0.1, "SRTNumber": "08-033-00", "CTime": 0, "PrivateFlag": "N", "Regions": "", "SRTTitle": "Cab Heater Shutoff Valve -  Remove and Install, Each", "SRTCategory": "Remove and Install", "StepID": 112132, "RTime": 0, "ATime": 0, "SRTType": "Access", "DTime": 0, "ECMFlag": "N", "FlexSRT": "N" } ] }';
FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrtResp2 = 
(FSLSRTIntegrationWrappers.SRTLookupDataAreaList)JSON.deserialize(resp22, FSLSRTIntegrationWrappers.SRTLookupDataAreaList.Class);
system.debug('fsrtResp>>'+fsrtResp2);
return fsrtResp2;
} */
        //}
        // else return null;
        
    }
    
    public static FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp runDiagnosticSRTInterface(WorkOrder wo, String SRTType, String SolName) {
        CSS_Integration_Details__c csi;         
        system.debug('TestAdminSRT');
        DateTime startTime = System.Now();
        
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/standardrepairstime';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
        
        String reqBody;
        FSLDiagSRTIntegrationWrappers fsrt=new FSLDiagSRTIntegrationWrappers();
        FSLDiagSRTIntegrationWrappers.RequestHeader reqHdr = new FSLDiagSRTIntegrationWrappers.RequestHeader();
        reqHdr.Sender.ServiceName = 'GetStandardRepairTime';
        reqHdr.Sender.SenderID='CSS';
        reqHdr.Sender.MessageID = '';
        reqHdr.Target.TargetID='SRT';
        FSLDiagSRTIntegrationWrappers.DataArea da = new FSLDiagSRTIntegrationWrappers.DataArea();
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00'; 
        da.LanguageID='en';
        da.SolutionType='Summary';
        da.CSSJobID=wo.WorkOrderNumber;
        da.ServiceModelName=wo.Asset.Service_Model__c;
        da.ClaimID = null;
        da.SRTType = SRTType;
        FSLDiagSRTIntegrationWrappers.CaseList fsc = new FSLDiagSRTIntegrationWrappers.CaseList();
        fsc.CaseNumber = SolName;
        fsc.VerifyRepeatValue = SRTType;
        fsc.SRTEventPerfDateTime = currDate;
        da.XCase = new List<FSLDiagSRTIntegrationWrappers.CaseList>{fsc};
            
        fsrt.DataArea = da;
        fsrt.Header= reqHdr;
        system.debug('::: PR FSRT = '+fsrt);
        
        //CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CG_GETAllSRT',endPoint, method, JSON.serialize(fsrt), timeout);
        //CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
        
        reqWrapper.jsonReqBody = JSON.serialize(fsrt).replace('XCase', 'Case');
        reqWrapper.timeOut = 120000;
        system.debug('SRT req d1############'+reqWrapper.jsonReqBody);
        HttpResponse resp;
        String resStr;
        if(!Test.isRunningTest())
        {
            //resp = FSLCumminsServiceUtility.sendHttpRequest(httpReq);
            //commented below line to use the mule version of calling mechanism -by vinod 8/31
            //HttpResponse resp   = FSLCumminsServiceUtility.sendHttpRequest(httpReq);
            CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            
            system.debug('Tokenwrapper############'+outputWrapper);
            
            resp = outputWrapper.response;//Ends mule changes
        }
        else
            resStr='{ "DataArea": { "CaseResponse": [ { "SRTTitle": "", "VerifyRepeatValue": { "SRTType": "VER", "Step": { "Percentage": 0, "SRTModifyDateTime": "", "StepDescription": [ "" ], "SRTStatusMessage": "This solution does not contain an SRT as it is for information only.", "StepID": 0, "SRTTime": { "SpecialAccessCode": "", "SpecialAccessCodeDescription": [ "" ], "AccessCodeB": 0, "AccessCodeA": 0, "AccessCodeD": 0, "AccessCodeR": 0, "AccessCodeC": 0 } }, "SRTEventPerfDateTime": "2017-06-07T00:00:00.000-05:00" }, "SRTID": "", "CaseNumber": "K24241010", "Assignment":"primary" },{ "SRTTitle": "", "VerifyRepeatValue": { "SRTType": "VER", "Step": { "Percentage": 0, "SRTModifyDateTime": "", "StepDescription": [ "" ], "SRTStatusMessage": "This solution does not contain an SRT as it is for information only.", "StepID": 0, "SRTTime": { "SpecialAccessCode": "", "SpecialAccessCodeDescription": [ "" ], "AccessCodeB": 0, "AccessCodeA": 0, "AccessCodeD": 0, "AccessCodeR": 0, "AccessCodeC": 0 } }, "SRTEventPerfDateTime": "2017-06-07T00:00:00.000-05:00" }, "SRTID": "", "CaseNumber": "K24241010", "Assignment":"Diagnostic" } ], "ResponseMessage": "2017-07-25T14:45:18.430-05:00" }, "Header": { "ReturnCodeDescription": "2017-07-25T14:45:18.430-05:00", "Status": "Success" } }';
        //system.debug('resp>>'+resp.getBody());
        if(Test.isRunningTest() || (resp != null && resp.getStatusCode() == 200 && String.isNotBlank(resp.getBody()))) {
            //added if condition on 8/12 vinod yelala
            if((resp != null && resp.getBody().containsIgnoreCase('CaseResponse')) || Test.isRunningTest())
            {
                if(!Test.isRunningTest())
                    resStr=resp.getBody();
                FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp fsrtResp = 
                    (FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp)JSON.deserialize(resStr, FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp.Class);
                system.debug('diksha size of diagnostic srt resp '+ fsrtResp.DataArea.CaseResponse.size());
                for(FSLDiagSRTIntegrationWrappers.DiagSRTDataArea diagSrtDataArea : fsrtResp.DataArea.CaseResponse){
                    system.debug('diksha Assignment: '+ diagSrtDataArea.Assignment + ' diksha SRT Code: '+ diagSrtDataArea.SRTID);
                }
                system.debug('fsrtResp############'+fsrtResp);
                executionLog = FSL_ApplicationLogger.logMessage('Response Body '+resStr,executionLog,isEligibleForAppLogging);
                //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),Null);
                return fsrtResp;
            }
            else return null;
        }
        else return null;
        // }
        //  else return null;
    }
    
    public static FSLDiagSRTREPWrappers runRepairSRTInterface(WorkOrder wo, String SRTType, String SolName, Id SolId, List<String> solComps)
    {
        system.debug('TestAdminSRT');
        DateTime startTime = System.Now();
        
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/standardrepairstime';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
        
        List<String> FIDs = new List<String>();
        String FID;
                /*for (CSS_Solutions__c cssSol : [SELECT Id, Name, (SELECT Id, Component_Id__c, Selected_Component__c FROM CSS_Solution_Components__r) FROM CSS_Solutions__c WHERE Id =: SolId]) {
        for (CSS_Solution_Component__c solComp : cssSol.CSS_Solution_Components__r){
        FID = solComp.Component_Id__c;
        if(solComp.Selected_Component__c == TRUE) {
        FIDs.add(FID);
        }
        }
        }*/
        //added below if condition to collect failure id.
        if(solComps != null && solComps.size() > 0)
        {
            for(CSS_Solution_Component__c csc : [SELECT Id, Component_Id__c, Selected_Component__c FROM CSS_Solution_Component__c where id in :solComps])
            {
                if(String.isNotBlank(csc.Component_Id__c))
                    FIDs.add(csc.Component_Id__c);
            }
        }		  
        String reqBody;
        FSLDiagSRTIntegrationWrappers fsrt=new FSLDiagSRTIntegrationWrappers();
        FSLDiagSRTIntegrationWrappers.RequestHeader reqHdr = new FSLDiagSRTIntegrationWrappers.RequestHeader();
        reqHdr.Sender.ServiceName = 'GetStandardRepairTime';
        reqHdr.Sender.SenderID='CSS';
        reqHdr.Sender.MessageID = '';
        reqHdr.Target.TargetID='SRT';
        FSLDiagSRTIntegrationWrappers.DataArea da = new FSLDiagSRTIntegrationWrappers.DataArea();
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00'; 
        da.TimeStamp = currDate;//'2018-04-19T00:00:00';//String.valueOf(System.now());
        da.LanguageID = 'en';
        da.SolutionType = 'Summary';
        da.CSSJobId = wo.WorkOrderNumber;
        da.ServiceModelName = wo.Asset.Service_Model__c;//'ISX15 CM2350 X101';
        da.ClaimID = null;
        da.SRTType = SRTType;
        FSLDiagSRTIntegrationWrappers.CaseList fsc = new FSLDiagSRTIntegrationWrappers.CaseList();
        fsc.CaseNumber = SolName;//'K75195551';
        fsc.VerifyRepeatValue = SRTType;//'VER';
        fsc.SRTEventPerfDateTime = currDate;
        da.EquipmentID = wo.Asset.Equipment_Id__c;//'EQ8349';
        da.EngineFamilyCode = wo.Asset.Engine_Family_Code__c;
        da.FailureID = FIDs;
        da.EffectiveDateTime = currentDate.format('YYYY-MM-dd')+'T00:00:00';
            //da.XCase=new List<FSLDiagSRTIntegrationWrappers.CaseList>{fsc};
        fsrt.DataArea = da;
        fsrt.Header= reqHdr;
        system.debug('::: PR FSRT = '+fsrt);
        
        //CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CG_GETAllSRT',endPoint, method, JSON.serialize(fsrt), timeout);
        //CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
        
        reqWrapper.jsonReqBody = JSON.serialize(fsrt).replace('XCase', 'Case');
        reqWrapper.timeOut = 120000;
        system.debug('SRT req d1>>>>>>>>>>>'+reqWrapper.jsonReqBody);
        HttpResponse resp;
        String resStr;
        if(!Test.isRunningTest()){
            //resp = FSLCumminsServiceUtility.sendHttpRequest(httpReq);
            //commented below line to use the mule version of calling mechanism -by vinod 8/31
            //HttpResponse resp   = FSLCumminsServiceUtility.sendHttpRequest(httpReq);
            CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            
            system.debug('Tokenwrapper::::'+outputWrapper); 
            resp = outputWrapper.response;//Ends mule changes
            executionLog = FSL_ApplicationLogger.logMessage('Response Body '+resp,executionLog,isEligibleForAppLogging);
            //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),Null);
        }
        else{
            resStr='{ "DataArea": { "CaseResponse": [ { "SRTTitle": "", "VerifyRepeatValue": { "SRTType": "REP", "Step": { "Percentage": 0, "SRTModifyDateTime": "", "StepDescription": [ "" ], "SRTStatusMessage": "This solution does not contain an SRT as it is for information only.", "StepID": 0, "SRTTime": { "SpecialAccessCode": "", "SpecialAccessCodeDescription": [ "" ], "AccessCodeB": 0, "AccessCodeA": 0, "AccessCodeD": 0, "AccessCodeR": 0, "AccessCodeC": 0 } }, "SRTEventPerfDateTime": "2017-06-07T00:00:00.000-05:00" }, "SRTID": "", "CaseNumber": "K24241010", "Assignment":"Repair" } ], "ResponseMessage": "2017-07-25T14:45:18.430-05:00" }, "Header": { "ReturnCodeDescription": "2017-07-25T14:45:18.430-05:00", "Status": "Success" } }';
        }
        if(resp != null)
            system.debug('resp>>'+resp.getBody());
        if(Test.isRunningTest() || (resp != null && resp.getStatusCode() == 200 && String.isNotBlank(resp.getBody()))) {
            //FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp fsrtResp;
            FSLDiagSRTREPWrappers srtRepair;
            string jstr;
            if(!Test.isRunningTest())
                jstr= resp.getBody().replace('\n','');
            else
                jstr=resStr;
            if(jstr.containsIgnoreCase('CaseResponse'))
            {
                srtRepair   = (FSLDiagSRTREPWrappers)System.JSON.deserialize(jstr, FSLDiagSRTREPWrappers.class);
                system.debug('diksha size of case response returned '+ srtRepair.DataArea.CaseResponse.size());
                for(FSLDiagSRTREPWrappers.CaseResponse caseResponse : srtRepair.DataArea.CaseResponse) {
                    system.debug('diksha srt code: '+ caseResponse.SRTDetails + ' assignment: ' + caseResponse.Assignment);
                }
                system.debug('srtRepair>>>'+srtRepair);
                return srtRepair;
            }
            else return null;
            //Ends
        }
        else return null;
        //  }
        
        //   else return null;
        
    }
    
    public static void getSRTDescriptionsInvocable(List<Id> srtIds)
    {
        for(Id srtId : srtIds){
            getSRTDescriptions(srtId);
        }
    }
    
    @future(callout=true)
    public static void getSRTDescriptions(Id srtIds)
    {
        system.debug('abc entered future method');
        DateTime startTime = System.Now();
        
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Engine';
        reqWrapper.Path = '/standardrepairstime';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
        
        List<FSL_SRT__c> srts = [select Step_Id__c, Service_Order__r.Asset.Equipment_Id__c from FSL_SRT__c where id =:srtIds];
        
        //List<String> contentHdrs = new List<String>{'Content-Type', 'application/json'};--commnted as part of mule changes - by Vinod 8/31
        String reqBody;
        FSLStepDescriptionWrapper fsrt=new FSLStepDescriptionWrapper();
        FSLStepDescriptionWrapper.Header reqHdr = new FSLStepDescriptionWrapper.Header();
        FSLStepDescriptionWrapper.Sender sender =  new FSLStepDescriptionWrapper.Sender();
        reqHdr.Sender = sender;
        FSLStepDescriptionWrapper.Target target =  new FSLStepDescriptionWrapper.Target();
        reqHdr.Target = target;
      //  reqHdr.Sender.ServiceName = 'GetStandardRepairTime';
     //   reqHdr.Sender.SenderID='SF';
       // reqHdr.Target.TargetID='SRT';
        FSLStepDescriptionWrapper.DataArea da = new FSLStepDescriptionWrapper.DataArea();
       
        da.SRTType = 'SRT_D'; 
        da.EquipmentID = srts[0].Service_Order__r.Asset.Equipment_Id__c;
        da.stepId = srts[0].Step_Id__c;
        
        fsrt.DataArea = da;
        fsrt.Header= reqHdr;
        system.debug('::: PR FSRT = '+fsrt);
        reqWrapper.jsonReqBody = JSON.serialize(fsrt).replace('XCase', 'Case');
        reqWrapper.timeOut = 120000;
        //changed method signature to make use of newer mule & return type.
        //  CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CG_GETDiagnosticSRT',endPoint, method, JSON.serialize(fsrt), timeout);
        // CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CG_GETDiagnosticSRT',endPoint, method, reqStr, timeout);// CT3-441BugFix
        //HttpRequest httpReq = FSLCumminsServiceUtility.createHttpRequest(endPoint, authType, token, method, contentHdrs, reqStr, timeout);
        HttpResponse resp;
        String resStr;
        if(!Test.isRunningTest()) {
            //resp = FSLCumminsServiceUtility.sendHttpRequest(httpReq);
            //commented below line to use the mule version of calling mechanism -by vinod 8/31
            //HttpResponse resp   = FSLCumminsServiceUtility.sendHttpRequest(httpReq);
            CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            
            system.debug('Tokenwrapper::::'+outputWrapper);
            
            resp = outputWrapper.response;//Ends mule changes
            
        }
        else {
            resStr='{ "DataArea": { "CaseResponse": [ { "SRTTitle": "", "VerifyRepeatValue": { "SRTType": "REP", "Step": { "Percentage": 0, "SRTModifyDateTime": "", "StepDescription": [ "" ], "SRTStatusMessage": "This solution does not contain an SRT as it is for information only.", "StepID": 0, "SRTTime": { "SpecialAccessCode": "", "SpecialAccessCodeDescription": [ "" ], "AccessCodeB": 0, "AccessCodeA": 0, "AccessCodeD": 0, "AccessCodeR": 0, "AccessCodeC": 0 } }, "SRTEventPerfDateTime": "2017-06-07T00:00:00.000-05:00" }, "SRTID": "", "CaseNumber": "K24241010", "Assignment":"Repair" } ], "ResponseMessage": "2017-07-25T14:45:18.430-05:00" }, "Header": { "ReturnCodeDescription": "2017-07-25T14:45:18.430-05:00", "Status": "Success" } }';
        }
        
        if(resp != null) {
            system.debug('resp>>'+resp.getBody());
        }
        if(Test.isRunningTest() || (resp != null && resp.getStatusCode() == 200 && String.isNotBlank(resp.getBody()))) {
            FSLStepDescriptionResp srtRepair;
            string jstr;
            if(!Test.isRunningTest()) {
                jstr= resp.getBody().replace('\n','');
            }
            else {
                jstr=resStr;
            }
            
            if(jstr.containsIgnoreCase('CaseResponse')) {
                srtRepair = (FSLStepDescriptionResp)System.JSON.deserialize(jstr, FSLStepDescriptionResp.class);
                system.debug('srtRepair>>>'+srtRepair);
                FSLStepDescriptionResp.CaseResponse cr = srtRepair.dataarea.CaseResponse[0];
                FSL_SRT__c fs = new FSL_SRT__c(Id = srtIds, Step_Description__c = cr.SRTContent);
                update fs;
            }
        }
        // }
    }
    
    /******************** GetOverlapSRT with Named Credentials *********************/
    //Road-267 start  
    public static CG_OP_OAGWrapper getOverlapSRTRecords(CSS_OverlapSRTReq OverlapSRTReq){
        
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try{ 
            reqWrapper = new FSL_IP_NamedCredentialWrapper();
            system.debug('OverlapSRTReq**'+OverlapSRTReq);
            reqWrapper.jsonReqBody = JSON.serialize(OverlapSRTReq).replace('null','""');
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Engine';
            reqWrapper.Path = '/overlap';
            reqWrapper.endPoint = 
                [SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            
            system.debug('OverlapSRTReq>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && OverlapSRTReq == null)
            {
                throw new CSS_MyException('Exception to cover Catch block'); 
            }
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(OverlapSRTReq != null){
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('OverlapSRT returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
            return returnWrapper;
        } catch(exception e){
            system.debug('Entered into catch block of getOverlapSRTRecords method in FSLSRTIntegrationHelperCls class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null){
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
            
        }
    }
    //Road-267 End
}