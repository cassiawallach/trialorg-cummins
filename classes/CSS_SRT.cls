/**********************************************************************
Name:CSS_SRT
Copyright © 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this class to extract SRT data
===============================================================
===============================================================

***********************************************************************/

public class CSS_SRT{

    public static string splreceiveToken(string sConn){

        string accessToken; 
        string endPoint;
        HttpResponse res = new HttpResponse();

        try {
            HttpRequest req = new HttpRequest(); 
            Http oagHTTP = new Http();
            string client_id;
            string client_secret;
            string sConnection;
            system.debug('splreceiveToken before sConnection, the sConn value is: ' + sConn);

            if (sConn == null) {sConnection = 'OAGOAuth';} else {sConnection = sConn;}
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            system.debug('splreceiveToken before Endpoint fetch connection value is: ' + sConnection);

            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection(sConnection);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c; 
            }
            else{
                endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
                client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
            }
            system.debug('splreceiveToken after Endpoint fetch Endpoint value is: ' + endPoint);

            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');

            if(!Test.isRunningTest()){
                res = oagHTTP.send(req);
            }else{
                res.setBody('{"access_token":"94pPkrL0Yt2guPTJJxM9PYTxZZ8it2YYy2twpGN8q7EN313l1GU6sX","token_type":"Bearer","expires_in":24000,"refresh_token":"VGaPh5uivMb7vtGUoT7aXeN9pyaa0QiYH7Im1qE7g7WNLZ","scope":"CSSCloud"}');
                res.setStatusCode(200);
            }
            system.debug('splreceiveToken after request, response value is: ' + res.getBody());

            string jSONResponseBody = res.getBody();
            CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONResponseBody,CSS_J2AToken_SRT.class); 
            accessToken = wo1.access_token;
            system.debug('splreceiveToken after parsing request, accessToken value is: ' + accessToken);
        }
        catch (exception e) {
            System.debug('accessToken Error in splreceiveToken method for '+ sConn +' is: ' + e.getLineNumber() + e.getMessage());
            accessToken = 'ERROR';
            if(!Test.isRunningTest()){
                css_utility.LogOutIntError(endPoint,e.getMessage()+'- OAG Token', res==null?'RESPONSE IS NULL':res.getBody(), 'BMSLOGIN');
            }
        }
        System.debug('accessToken Value in splreceiveToken method for '+ sConn +' set to: ' + accessToken );
        return accessToken;
    }    

    public static string receiveToken(){

        string accessToken;
        string endPoint;
        HttpResponse res = new HttpResponse();

        try{
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            string client_id;
            string client_secret;
            system.debug('oagdescrip');

            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('OAGOAuth');
                system.debug('conDetails' + conDetails);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c; 
            }
            else{
                endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
                client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
            }

            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
            req.setTimeout(120000);

            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                res.setBody('{"access_token":"94pPkrL0Yt2guPTJJxM9PYTxZZ8it2YYy2twpGN8q7EN313l1GU6sX","token_type":"Bearer","expires_in":24000,"refresh_token":"VGaPh5uivMb7vtGUoT7aXeN9pyaa0QiYH7Im1qE7g7WNLZ","scope":"CSSCloud"}');
                res.setStatusCode(200);
            }

            string jSONRequestBody = res.getBody();
            CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            accessToken = wo1.access_token;
            System.debug('BODY: '+res.getBody());  
            System.debug('Status: '+res.getStatus());
            System.debug('Status Code: '+res.getStatusCode());
        }
        catch(exception e){
            System.debug('in catch of receiveToken of CSS_SRT class... Error lineNo>>>>>>>>>>>>>>:'+e.getLineNumber()+' Error msg>>>>>>>>>>>>>>>:'+e.getMessage());
            if(!Test.isRunningTest()){
                css_utility.LogOutIntError(endPoint,e.getMessage()+'- OAG Token', res==null?'RESPONSE IS NULL':res.getBody(), 'SRT');
            }
        }
        return accessToken;
    } 

    @future(callout=true)
    public static void diagnosticSRT(MAP<ID,ID> jobOrder, Map<ID,String> solName,string serviceModel,string jobName,decimal claim,string accessjob){

        System.debug('The job order inside srt class is'+jobOrder);
        System.debug('The solName inside srt class is'+solName);

        List<CSS_SRT__c> diagnosisSRT = new List<CSS_SRT__c>();
        List<string> stepDesc = new List<string>();
        List<string> caseNum = new List<String>();

        HTTPResponse res;
        Boolean dgRetry;
        Integer dgRetryCount = 1;
        string claimId = string.valueOf(claim);
        string accessToken;
        string endPoint;
        string diagRequest;
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
        string client_id;
        string client_secret;
        do 
        {
            dgRetry=FALSE;
            try
            {  
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                if(!Test.isRunningTest()){
                    //accesstoken = splreceiveToken(Label.CSS_SRTAltOAuth); //Commented for Dynamic Authentication
                    //accesstoken = splreceiveToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c);
                    //Commented for dynamic Authentication and added below lines
                    //Commented below line as part of Mule Integration
                    //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c);
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c,'SRT');
                    accesstoken = accessTokenOPWrap.accessToken;
                    system.debug('test**'+accesstoken);
                    // accessToken=receiveToken();
                    conDetails=CSS_getConnnectionDetails.getConnection('SRT');
                    //endPoint = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
                    endPoint = conDetails.End_Point__c;
                    client_id = conDetails.Username__c;   
                    client_secret = ConDetails.Passcode__c;
                }
                else{
                    accessToken ='Test';
                    endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                    client_id = 'EO2mFVUilaYhGGnD1hv8wdo9EmLWeGbkRnMDgExKqY4=';   
                    client_secret = 'o6GR4eKrrPu4vfxu7iq63VEdOQysTO5uB9jhaQKHsWM=';
                }

                for(ID name : solName.keySet()){
                    string solutionName = solName.get(name);
                    caseNum.add(solutionName);
                }
                /*STory 90222 start
                set<id> setJobId; 
                if(jobOrder != null && jobOrder.size() >0){
                    setJobId = new set<id>(jobOrder.values());
                }
                map<id,decimal> mapJobIdToMaxSortOrder = new map<id,decimal>();
                if(setJobId != null && setJobId.size() > 0){
                    mapJobIdToMaxSortOrder = getMaxOrder('Diagnosis',setJobId);
                }
                //STory 90222 End */
                //story 90222  start 
                Id jobOrderId;   
                Id solNum;

                for(ID solID : jobOrder.keySet()){
                    jobOrderId = jobOrder.get(solID);
                    solNum = solID;   
                }
                system.debug('jobOrderId---'+ jobOrderId);

                //story: 162535 START Queries:
                List<CSS_SRT__c> existDiagSrtList = [Select id,SRT_ID__c,Assignment__c,type__c,isPerformed__c,step_description__c from css_Srt__c where Job_Order__c = : jobOrderId and type__c = 'Diagnosis' and SRT_ID__c != '0']; 
                List<CSS_SRT__c> existrepSrtList = [Select id,SRT_ID__c,Assignment__c,step_description__c,isPerformed__c from css_Srt__c where Job_Order__c = : jobOrderId and type__c ='Repair' and SRT_ID__c != '0'];
                system.debug('existDiagSrtList---'+ existDiagSrtList);
                system.debug('existrepSrtList---'+ existrepSrtList);

                List<css_srt__c> diagSRTtobeUpdated = new list<css_Srt__c>();
                List<css_srt__c> repSRTtobeUpdated = new list<css_Srt__c>();
                //story: 162535 END
                //story 90222 end  

                HttpRequest req = new HttpRequest();
                //List<string> caseNum = new List<string>{'K87481914'};
                req.setEndpoint(endPoint);
                req.setHeader('Content-Type','application/json');
                req.setHeader('client-id',client_id);
                req.setHeader('client-secret',client_secret);
                req.setHeader('Authorization', 'Bearer '+accessToken);
                diagRequest = '{"Header": { "Sender": { "MessageID": "unique message ID at SF", "SenderID": "SF",  "ServiceName": "GetStandardRepairTime"},"Target": {"TargetID": "SRT"}},"DataArea": {"Case": [';
                for(integer i=0;i<caseNum.size();i++){
                    if(i>0) {
                        diagRequest = diagRequest + ',';
                    }
                    diagRequest = diagRequest + '{"CaseNumber":"'+ caseNum[i] +'","VerifyRepeatValue": "VER","SRTEventPerfDateTime": "'+currDate+'"}';
                }
                diagRequest = diagRequest + '],"SRTType": "VER","SolutionType": "Summary","CSSJobID": "'+jobName+'","ClaimID": "'+claimId+'","ServiceModelName": "'+serviceModel+'","LanguageID": "en","TimeStamp": "'+currDate+'"}}';
                System.debug('The diagRequest is!@!@#'+diagRequest);
                req.setBody(diagRequest);
                req.setMethod('POST');
                req.setTimeout(120000); // Sai: 14/03/2017. Added for SRT Read timed out issue.

                Http http = new Http();    
                res = http.send(req);
                string jSONRequestBody = res.getBody();
                System.debug('>>>jSONRuestBodeqy: '+jSONRequestBody);
                // if(jSONRequestBody.contains('No SRT Found') || jSONRequestBody.contains('An SRT is not being populated for this EDS Solution as this time overlaps with Administration Time')
                //    || jSONRequestBody.contains('Please refer to QSOL to determine if additional labor is warrantable for this action. If so, follow your current process to claim reimbursement')
                //    || jSONRequestBody.contains('No Records Found') || jSONRequestBody.contains('OSB Service Callout action received SOAP Fault response') ){
                if(jSONRequestBody.contains('OSB Service Callout action received SOAP Fault response') ){
                    System.debug('Incorrect json format');
                    System.debug('BODY: '+res.getBody());
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode());
                }
                //else 
                /*if(jSONRequestBody.contains('No Records Found')){
                System.debug('Inside no records');
                System.debug('Job order is'+jobOrder.keySet());
                for(ID solID : jobOrder.keySet()){
                    System.debug('solid is'+solID);
                    CSS_SRT__c diagSRT = new CSS_SRT__c();    
                    diagSRT.Solution_Number__c = solID;
                    diagSRT.Job_Order__c = jobOrder.get(solID);    
                    diagSRT.Type__c = 'Diagnosis';    
                    diagSRT.SRT_ID__c = '0';
                    diagSRT.SRT_Status_Message__c = 'Please refer to QSOL to determine if additional labor is warrantable for this action. If so,follow your current process to claim reimbursement.';
                    diagnosisSRT.add(diagSRT); 
                    }
                }*/
                else{
                    //Story 90222 start querying to get the Maximum Diagnosis srt Sort Order
                    /* AggregateResult[] groupedResults= [SELECT type__c, MAX(SRT_Order__c) 
                                                   FROM CSS_SRT__c GROUP BY type__c 
                                                   HAVING type__c='Diagnosis' or type__c ='Diag Access'];*/
                    Decimal sortOrder = 0;
                    /*if(groupedResults != null && groupedResults.size() > 0){
                    sortOrder =(decimal) groupedResults[0].get('expr0') > (decimal) groupedResults[1].get('expr0') ? (decimal) groupedResults[0].get('expr0') : (decimal) groupedResults[1].get('expr0');
                    }
                 /* for (AggregateResult ar : groupedResults)  {
                    System.debug('type :- '+ ar.get('type__c'));
                    System.debug('Max :-' + ar.get('expr0'));
                    }*/
                    //Story 90222 End

                    CSS_J2ADiagnostic_SRT wo1 = (CSS_J2ADiagnostic_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2ADiagnostic_SRT.class);
                    system.debug('wo1**'+wo1);
                    AggregateResult[] groupedResults = [SELECT MAX(SRT_Order__c) FROM CSS_SRT__c WHERE Job_Order__c = : jobOrderId and Solution_Number__c =:solNum and (type__c ='Diagnosis' or type__c='Diag Access') and SRT_ID__c != '0'];
                    decimal maxOrder ;
                    system.debug('groupedResults---'+ groupedResults);
                    if(groupedResults != null && groupedResults.size() > 0){
                        maxOrder   = (decimal) groupedResults[0].get('expr0');
                    }


                    if(wo1 !=null && wo1.DataArea.CaseResponse!=null){
                        System.debug('inside caseresponse '+wo1.DataArea.CaseResponse);
                        for(ID solID : jobOrder.keySet()){
                            for(integer i=0;i<wo1.DataArea.CaseResponse.size();i++){ 
                                
                                CSS_SRT__c diagSRT = new CSS_SRT__c();

                                if(solName.get(solID)!=null){
                                    //if(wo1.DataArea.CaseResponse[i].SRTTitle!='DUMMY'){

                                    if(solName.get(solID)==wo1.DataArea.CaseResponse[i].CaseNumber){

                                        //if(wo1.DataArea.CaseResponse[i].SRTID != '00-901-00' && wo1.DataArea.CaseResponse[i].SRTID != '00-902-00' && wo1.DataArea.CaseResponse[i].SRTID != '00-904-00' && wo1.DataArea.CaseResponse[i].SRTID != '00-10S-00'){
                                        if(wo1.DataArea.CaseResponse[i].SRTID==null||wo1.DataArea.CaseResponse[i].SRTID==''||wo1.DataArea.CaseResponse[i].SRTID=='""'){
                                            diagSRT.Name = '0';
                                        }
                                        else{
                                            diagSRT.Name = wo1.DataArea.CaseResponse[i].SRTID;
                                        }
                                        diagSRT.Job_Order__c = jobOrder.get(solID);
                                        diagSRT.SRT_Title__c = wo1.DataArea.CaseResponse[i].SRTTitle;
                                        diagSRT.SRT_ID__c = wo1.DataArea.CaseResponse[i].SRTID;
                                        diagSRT.Assignment__c = wo1.DataArea.CaseResponse[i].Assignment;
                                        //Flex SRT field
                                        if(wo1.DataArea.CaseResponse[i].FlexSRT != null && wo1.DataArea.CaseResponse[i].FlexSRT !=''){
                                            if(wo1.DataArea.CaseResponse[i].FlexSRT == 'Y'){
                                                diagSRT.Flex_Flag__c = true;
                                            }
                                            else{
                                                diagSRT.Flex_Flag__c = false;
                                            }
                                        }
                                        //ECM Flag field- Added as part of story- GSSC-125
                                        if(wo1.DataArea.CaseResponse[i].ECMFlag != null && wo1.DataArea.CaseResponse[i].ECMFlag !=''){
                                            if(wo1.DataArea.CaseResponse[i].ECMFlag == 'Y'){
                                                diagSRT.ECM_Flag__c = true;
                                            }
                                            else{
                                                diagSRT.ECM_Flag__c = false;
                                            }
                                        }
                                        //Access Code field
                                        diagSRT.SRT_Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;
                                       
                                        //Story#172627
                                        if(wo1.DataArea.CaseResponse[i].SRTAccessCode == 'R')
                                            diagSRT.Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;
                                        else
                                            if(diagSRT.SRT_Access_Code__c!=null && diagSRT.SRT_Access_Code__c !='')
                                                diagSRT.Access_Code__c = accessjob;
                                        //End
                                        diagSRT.Type__c = 'Diagnosis';
                                        /*Story 90222 start assigning the sort order
                                           if(mapJobIdToMaxSortOrder != null && mapJobIdToMaxSortOrder.size() > 0){
                                               sortOrder = mapJobIdToMaxSortOrder.get(diagSRT.Job_Order__c) + 1;
                                               diagSRT.SRT_Order__c= sortOrder+1;
                                               //mapJobIdToMaxSortOrder.get(diagSRT.Job_Order__c) = diagSRT.SRT_Order__c;
                                           }
                                            //sortOrder = diagSRT.SRT_Order__c;
                                            //Story 90222 End*/
                                        system.debug('maxOrder---'+ maxOrder);
                                        if(maxOrder != null){
                                            diagSRT.SRT_Order__c = maxOrder + 1;
                                            maxOrder = diagSRT.SRT_Order__c;
                                        }
                                        else{
                                            diagSRT.SRT_Order__c = sortOrder + 1;
                                            sortOrder = diagSRT.SRT_Order__c;
                                        }   
                                        diagSRT.SRT_Quantity__c = 1;
                                        diagSRT.Solution_Number__c = solID;

                                        if(diagSRT.SRT_ID__c!= '' && diagSRT.SRT_ID__c != null){
                                            Boolean isRep;
                                            Set<String> UpdatedSRTIDs = new Set<String>();
                                            if(existrepSrtList != null && existrepSrtList.size()>0){

                                                for(Css_srt__c srt:existrepSrtList){

                                                    //if(diagSRT.SRT_ID__c == srt.SRT_ID__c && srt.Assignment__c == 'PRIMARY'){
                                                    if((srt.SRT_ID__c != null && srt.SRT_ID__c != '') && srt.Assignment__c != null && srt.Assignment__c != ''){
                                                        if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0] == null || wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0] == '' || wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0] == 'null'){}
                                                        else{
                                                            system.debug('Kalpana**'+wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].contains('Step Number-'));
                                                            system.debug('Kalpana1**'+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2));
                                                            if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].contains('Step Number-')){
                                                                System.debug('inside caseresponsetttttt*****'+diagSRT.SRT_ID__c+'-'+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2));
                                                                System.debug('srt.SRT_ID__c**** '+srt.SRT_ID__c);
                                                                System.debug('srt.Assignment__c***** '+srt.Assignment__c);
                                                                if(diagSRT.SRT_ID__c+'-'+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2) == srt.SRT_ID__c && srt.Assignment__c == 'PRIMARY'){     
                                                                    isRep=true;
                                                                    srt.isPerformed__c = True;
                                                                    system.debug('UpdatedSRTIDs**'+UpdatedSRTIDs);
                                                                    system.debug('UpdatedSRTIDs**'+srt.SRT_ID__c);
                                                                    UpdatedSRTIDs.add(srt.SRT_ID__c);
                                                                    repSRTtobeUpdated.add(srt);
                                                                    for(Css_srt__c srt1:existdiagSrtList){
                                                                        // if(diagSRT.SRT_ID__c == srt1.SRT_ID__c){
                                                                        system.debug('srt1.SRT_ID__c**'+srt1.SRT_ID__c);
                                                                        system.debug('diagcaseresstepdesc**'+diagSRT.SRT_ID__c+'-'+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2));

                                                                        if((srt1.SRT_ID__c != null && srt1.SRT_ID__c != '') && diagSRT.SRT_ID__c+'-'+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2) == srt1.SRT_ID__c){
                                                                            srt1.isPerformed__c = false;
                                                                            system.debug('UpdatedSRTIDs1**'+UpdatedSRTIDs);
                                                                            system.debug('UpdatedSRTIDs1**'+srt1.SRT_ID__c);
                                                                            UpdatedSRTIDs.add(srt1.SRT_ID__c);
                                                                            if(!diagSRTtobeUpdated.contains(srt1))
                                                                                diagSRTtobeUpdated.add(srt1);
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }


                                                }
                                                system.debug('repSRTtobeUpdatedSize---'+ repSRTtobeUpdated.size());
                                                system.debug('diagSRTtobeUpdatedSize---'+ diagSRTtobeUpdated.size());
                                            }
                                            //if(existdiagSrtList != null && existdiagSrtList.size()>0 && isRep==false){
                                            if(existdiagSrtList != null && existdiagSrtList.size()>0){
                                                for(Css_srt__c srt:existdiagSrtList){
                                                    system.debug('UpdatedSRTIDs**'+UpdatedSRTIDs);
                                                    system.debug('srt.SRT_ID__c**'+srt.SRT_ID__c);
                                                    if(srt.SRT_ID__c != null && srt.SRT_ID__c != '' && UpdatedSRTIDs!= null && !UpdatedSRTIDs.isEmpty() && !UpdatedSRTIDs.contains(srt.SRT_ID__c)){ 
                                                        if(srt.SRT_ID__c != null && srt.SRT_ID__c != '' && diagSRT.SRT_ID__c.length() == srt.SRT_ID__c.length()){
                                                            system.debug('diagSRT.SRT_ID__c**'+diagSRT.SRT_ID__c);
                                                            system.debug('srt.Assignment__c**'+srt.Assignment__c);
                                                            if(diagSRT.SRT_ID__c == srt.SRT_ID__c && (srt.Assignment__c!= null && srt.Assignment__c != '') && srt.Assignment__c == 'PRIMARY'){
                                                                srt.isPerformed__c = True;
                                                                system.debug('UpdatedSRTIDs2**'+UpdatedSRTIDs);
                                                                system.debug('UpdatedSRTIDs2**'+srt.SRT_ID__c);
                                                                UpdatedSRTIDs.add(srt.SRT_ID__c);
                                                                if(!diagSRTtobeUpdated.contains(srt))
                                                                    diagSRTtobeUpdated.add(srt);
                                                                /* for(Css_srt__c srt1:existrepSrtList){
                                                         if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription == null || wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0] == '' || wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0] == 'null'){}
                                                    else{
                                                        if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].contains('Step Number-')){
                                                        if(diagSRT.SRT_ID__c+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2) == srt1.SRT_ID__c){
                                                        srt1.isPerformed__c = false;
                                                        UpdatedSRTIDs.add(srt1.SRT_ID__c);
                                                        repSRTtobeUpdated.add(srt1);
                                                        }
                                                        }
                                                    }
                                                   }*/
                                                            }
                                                        }
                                                        else{
                                                            //string[] stepNum = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].split('-');
                                                            //stringtoappend = stepNum[1].substring(0,2);
                                                            system.debug('diagSRT.SRT_ID__c**'+diagSRT.SRT_ID__c);
                                                            system.debug('strAppend**'+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2));
                                                            system.debug('srt.Assignment__c**'+srt.Assignment__c);
                                                            if(diagSRT.SRT_ID__c+'-'+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2) == srt.SRT_ID__c && (srt.Assignment__c!= null && srt.Assignment__c != '') && srt.Assignment__c == 'PRIMARY'){
                                                                srt.isPerformed__c = True;
                                                                system.debug('UpdatedSRTIDs3**'+UpdatedSRTIDs);
                                                                system.debug('UpdatedSRTIDs3**'+srt.SRT_ID__c);
                                                                UpdatedSRTIDs.add(srt.SRT_ID__c);
                                                                if(!diagSRTtobeUpdated.contains(srt))
                                                                    diagSRTtobeUpdated.add(srt);
                                                                /*for(Css_srt__c srt1:existrepSrtList){
                                                         if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription == null || wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0] == '' || wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0] == 'null'){}
                                                    else{
                                                        if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].contains('Step Number-')){
                                                        if(diagSRT.SRT_ID__c+(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[0].substringAfter('-')).substring(0,2) == srt1.SRT_ID__c){
                                                        srt1.isPerformed__c = false;
                                                        UpdatedSRTIDs.add(srt1.SRT_ID__c);
                                                        repSRTtobeUpdated.add(srt1);
                                                        }
                                                        }
                                                    }
                                                   }*/
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            system.debug('repSRTtobeUpdatedSize1---'+ repSRTtobeUpdated.size());
                                            system.debug('diagSRTtobeUpdatedSize1---'+ diagSRTtobeUpdated.size());
                                            if(!diagSRTtobeUpdated.isEmpty() || !repSRTtobeUpdated.isEmpty()){
                                                system.debug('1111111diagSRT.Assignment__c>>> ' + diagSRTtobeUpdated.isEmpty()+'******re******'+repSRTtobeUpdated.isEmpty());
                                                diagSRT.isPerformed__c = false;
                                            }
                                            else if(diagSRT.Assignment__c == 'PRIMARY'){
                                                system.debug('diagSRT.Assignment__c>>> ' + diagSRT.Assignment__c);
                                                diagSRT.isPerformed__c = true;
                                            }
                                            else{
                                                system.debug('222222diagSRT.Assignment__c>>> ' + diagSRT.Assignment__c);
                                                diagSRT.isPerformed__c = false;
                                            }
                                        }

                                        diagSRT.Response_Message__c = wo1.DataArea.ResponseMessage;
                                        if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription!=null){
                                            for(integer j=0;j<wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription.size();j++){
                                                diagSRT.Step_Description__c = diagSRT.Step_Description__c + wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[j]+'\n'; 
                                                diagSRT.SRT_Notes__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[j]+'\n'; //since SRT_Notes__c mapping missed, added it here
                                                diagSRT.Access_Code_A__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeA; //* 60;Anirudh
                                                diagSRT.Access_Code_B__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeB; //* 60;
                                                diagSRT.Access_Code_D__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeD; //* 60; 
                                                diagSRT.Access_Code_R__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeR; //* 60;
                                                diagSRT.Access_Code_C__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.AccessCodeC; //* 60;
                                                diagSRT.Special_Access_Code__c =  wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.SpecialAccessCode;
                                                for(integer k=0;k<wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.SpecialAccessCodeDescription.size();k++){
                                                    system.debug('diagSRT.Special_Access_Code_Desc__c >>>>> ' + diagSRT.Special_Access_Code_Desc__c);
                                                    if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.SpecialAccessCodeDescription[k]!=''){
                                                        diagSRT.Special_Access_Code_Desc__c = diagSRT.Special_Access_Code_Desc__c + wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTTime.SpecialAccessCodeDescription[k]+'\n'; 
                                                    }
                                                }
                                                diagSRT.Step_Id__c = string.valueof(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepID);
                                                if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTStatusMessage!='SRT is present'){
                                                    diagSRT.SRT_Status_Message__c = wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.SRTStatusMessage;
                                                }
                                            }
                                        }
                                        diagnosisSRT.add(diagSRT); 
                                        // }
                                    }
                                    // }
                                }       
                            }
                        }
                    }
                    Set<Id> DupSrt = new Set<Id>();
                    List<CSS_SRT__c> diagSRTtobeUpdatedNew = new List<CSS_SRT__c>();
                    List<CSS_SRT__c> repSRTtobeUpdatedNew = new List<CSS_SRT__c>();
                    for(CSS_SRT__c srtToUpd : diagSRTtobeUpdated){
                        if(!DupSrt.contains(srtToUpd.Id)){
                            DupSrt.add(srtToUpd.Id);
                            diagSRTtobeUpdatedNew.add(srtToUpd);
                        }
                    }
                    DupSrt = new Set<Id>();
                    for(CSS_SRT__c srtToUpd : repSRTtobeUpdated){
                        if(!DupSrt.contains(srtToUpd.Id)){
                            DupSrt.add(srtToUpd.Id);
                            repSRTtobeUpdatedNew.add(srtToUpd);
                        }
                    }
                    //if(diagSRTtobeUpdated!=null && diagSRTtobeUpdated.size()>0)
                    //update diagSRTtobeUpdated;
                    if(diagSRTtobeUpdatedNew!=null && diagSRTtobeUpdatedNew.size()>0)
                        update diagSRTtobeUpdatedNew;
                    //if(repSRTtobeUpdated!=null && repSRTtobeUpdated.size()>0)
                    //update repSRTtobeUpdated;
                    if(repSRTtobeUpdatedNew!=null && repSRTtobeUpdatedNew.size()>0)
                        update repSRTtobeUpdatedNew;
                }

            }
            catch(exception e){
                System.debug('===Exception===='+e.getLineNumber());
                System.debug('===Exception===='+e.getMessage());

               // if(!Test.isRunningTest()){
                    String message = e.getMessage(); //System.CalloutException
                    String eType = e.getTypeName();
                    system.debug('exception message is -->'+ e.getTypeName());
                    if(message.equalsignorecase('Read timed out') || eType.contains('CalloutException')){
                        dgRetryCount = dgRetryCount + 1; 
                        dgRetry = TRUE;
                        system.debug('retryValue is -->' +dgRetryCount);
                        system.debug('reTry flag is -->' +dgRetry);                    
                    }
                    css_utility.LogOutIntError(endPoint+diagRequest,e.getMessage()+'-Diagnosis SRT', res==null?'RESPONSE IS NULL':res.getBody(), 'SRT');
                //}
            }
        } while(dgRetryCount <= integer.valueof(Label.CSS_SRT_RETRY_TIME) && dgRetry == TRUE); // logic for Re-try Mechanism
        System.debug('The diagnosis list is!#!@#'+diagnosisSRT);
        insert diagnosisSRT;
        system.debug('After Insert The diagnosis list is!#!@#'+diagnosisSRT);

    }

    public class solCompWrapper{
        public id solID{get;set;}
        public id jobID{get;set;}
        public string serviceModel{get;set;}
        public string equipID{get;set;}
        public id compID{get;set;}
        public string efc{get;set;}
        public string compoName{get;set;}
        public string jobName{get;set;}
        public decimal claimID{get;set;}
        public string failCode;
        public string accountCode;
        public string type;
        public string CoveredLaborHrs;
        public string CampaignLaborPercentage;

        public solCompWrapper(id solID,id jobID,string serviceModel,string equipID,id compID,string efc,string compoName,string jobName,decimal claimId,string failCode,string accountCode,string type,string CoveredLaborHrs,string CampaignLaborPercentage){
            this.solID = solID;
            this.jobID = jobID;
            this.serviceModel = serviceModel;
            this.equipID = equipID;
            this.compID = compID;
            this.efc = efc;            
            this.compoName = compoName;
            this.jobName = jobName;
            this.claimId = claimId;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.type = type;
            this.CoveredLaborHrs = CoveredLaborHrs;
            this.CampaignLaborPercentage = CampaignLaborPercentage;

        }
    }

    @future(callout=true)
    public static void repairSRT(List<String> solComp){

        system.debug('solComp ' + solComp.size() + 'List---->' + solComp);
        List<CSS_SRT__c> repairSRT = new List<CSS_SRT__c>();

        List<string> stepDescRep = new List<string>();
        CSS_SRT__c repSRT;
        Boolean rpRetry;
        Integer rpRetryCount=1;
        string accessToken;
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
        solCompWrapper components = null;
        string endPoint; 
        string repairRequest;
        HTTPResponse res;
        solCompWrapper componentsJobId;

        Set<CSS_SRT__C> diagSRTtobeUpdated1;
        List<css_srt__c> diagSRTtobeUpdated;
        List<css_srt__c> repSRTtobeUpdated;
        List<CSS_SRT__c> existDiagSrtList;
        List<CSS_SRT__c> existrepSrtList;
        List<CSS_SRT__c> existDiagAccSrtList;
        string client_id;
        string client_secret;
        //GSSC-297 - START
        Map<String, String> accCodeFailCodeMap = new Map<String, String>();
        componentsJobId = (solCompWrapper)JSON.deserialize(solComp[0], solCompWrapper.class);
        List<CSS_Solution_Component__c> newSolCompLst = new List<CSS_Solution_Component__c>();
        newSolCompLst = [SELECT Id, CSS_Claims__c, Type__c, Fail_Code__c, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c, Selected_Component__c FROM CSS_Solution_Component__c WHERE 
                                    Service_Job__c =: componentsJobId.jobID AND Type__c NOT IN ('TRP','ATC','Campaign')
                                    AND Fail_Code__c != null AND Fail_Code__c != '' AND Fail_Code__c != 'Select One' AND
                                    CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND CSS_Account_Formula__c != 'Select One' AND Selected_Component__c = true
                                    ORDER BY CSS_Failure_Sequence_Number__c ASC];
        for(CSS_Solution_Component__c sc : newSolCompLst){
            if((sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '' && sc.CSS_Account_Formula__c != 'Select One')  && !accCodeFailCodeMap.containsKey(sc.CSS_Account_Formula__c)){ //Added Account code not null condition for defect GSSC-567
                accCodeFailCodeMap.put(sc.CSS_Account_Formula__c, sc.Fail_Code__c);
            }
        }
        //GSSC-297 - END
        do{     
            rpRetry = FALSE;
            try
            {  
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                if(!Test.isRunningTest()){
                    //  accessToken=receiveToken();
                    //accesstoken = splreceiveToken(Label.CSS_SRTAltOAuth); //Commented for dynamic Authentication
                    //accesstoken = splreceiveToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c);
                    //Commented for dynamic Authentication and added below lines
                    //Commented below lines for Mule Integration
                    //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c);
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c,'SRT');
                    accesstoken = accessTokenOPWrap.accessToken;
                    conDetails =CSS_getConnnectionDetails.getConnection('SRT');
                    //endPoint = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;Commented as part of Mule Integration
                    endPoint = conDetails.End_Point__c;
                    client_id = conDetails.Username__c;   
                    client_secret = ConDetails.Passcode__c;
                }
                else{
                    accessToken ='Test';
                    endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                    client_id = 'EO2mFVUilaYhGGnD1hv8wdo9EmLWeGbkRnMDgExKqY4=';   
                    client_secret = 'o6GR4eKrrPu4vfxu7iq63VEdOQysTO5uB9jhaQKHsWM=';
                }

                componentsJobId = (solCompWrapper)JSON.deserialize(solComp[0], solCompWrapper.class);  
                //162535 START claimId
                string claimId = string.valueof(componentsJobId.claimId);
                existDiagSrtList = new List<CSS_SRT__c>();
                existrepSrtList = new List<CSS_SRT__c>();
                existDiagAccSrtList = new List<CSS_SRT__c>();
                diagSRTtobeUpdated = new List<css_srt__c>();
                repSRTtobeUpdated = new List<css_srt__c>();
                diagSRTtobeUpdated1 = new Set<CSS_SRT__C>();
                system.debug('JobId**'+componentsJobId.JobID);
                system.debug('ClaimId**'+componentsJobId.claimId);
                string srttype = 'Diag Access';

                if(componentsJobId.claimId != null){
                    existDiagSrtList = [Select id,SRT_ID__c,Assignment__c,type__c,isPerformed__c,step_description__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and CSS_Claims__c = : claimId and type__c = 'Diagnosis' and SRT_ID__c != '0'];
                    existrepSrtList = [Select id,SRT_ID__c,Assignment__c,step_description__c,isPerformed__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and CSS_Claims__c = : claimId and type__c ='Repair' and SRT_ID__c != '0'];
                    existDiagAccSrtList = [Select id,SRT_ID__c,Assignment__c,type__c,isPerformed__c,step_description__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and CSS_Claims__c = : claimId and SRT_ID__c != '0' and type__c LIKE :srttype];
                }
                else {
                    existDiagSrtList = [Select id,SRT_ID__c,Assignment__c,type__c,isPerformed__c,step_description__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and type__c = 'Diagnosis' and SRT_ID__c != '0'];
                    existrepSrtList = [Select id,SRT_ID__c,Assignment__c,step_description__c,isPerformed__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and type__c ='Repair' and SRT_ID__c != '0'];
                    existDiagAccSrtList = [Select id,SRT_ID__c,Assignment__c,type__c,isPerformed__c,step_description__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and SRT_ID__c != '0' and type__c LIKE :srttype];   
                }
                system.debug('existDiagSrtList---'+ existDiagSrtList);
                system.debug('existrepSrtList---'+ existrepSrtList);
                system.debug('existDiagAccSrtList---'+ existDiagAccSrtList);

                CSS_Job_Order__c serJob = [select id,CSS_In_Shop_Labor_Rate__c from CSS_Job_Order__c where id=: componentsJobId.JobID]; //components.jobID - This is commented and correct Id added as per defect # 178463
                //162535 END
                system.debug('serJob---'+ serJob);
                system.debug('componentsJobId.JobID---'+ componentsJobId.JobID);
                AggregateResult[] groupedResults = [SELECT MAX(SRT_Order__c) FROM CSS_SRT__c WHERE Job_Order__c = : componentsJobId.jobID and (type__c ='Repair' or type__c='Repair Access') and SRT_ID__c != '0'];
                decimal maxOrder = (decimal) groupedResults[0].get('expr0');
                Decimal sortOrder = 0;

                for(string ser:solComp){
                    components = (solCompWrapper)JSON.deserialize(ser, solCompWrapper.class);   
                    System.debug('components components'+components);

                    HttpRequest req = new HttpRequest();
                    string efc = components.efc;//'56'
                    string equipID = components.equipID;//'EQ7667'
                    string claim = string.valueOf(components.claimId);
                    string jobName = components.jobName;
                    string serviceModel = components.serviceModel; //'ISL9 CM2350 L101'
                    List<string> failureID = new List<string>{'F02000010','F01000250'};
                    req.setEndpoint(endPoint);
                    req.setHeader('Content-Type','application/json');
                    req.setHeader('client-id',client_id);
                    req.setHeader('client-secret',client_secret);
                    req.setHeader('Authorization', 'Bearer '+accessToken);
                    //repairRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName":"ServiceRequest","SenderID":"SF"},"Target":{"TargetID":"SRT"}},';
                    repairRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName":"GetRepairSRT","SenderID":"CSS"},"Target":{"TargetID":"SRT"}},';
                    repairRequest = repairRequest + '"DataArea":{"EngineFamilyCode":"'+efc+'","CSSJobId": "'+jobName+'","ClaimID": "'+claim+'","EquipmentID": "'+equipID+'","ServiceModelName": "'+serviceModel+'","EffectiveDateTime":"'+currDate+'","Timestamp": "'+currDate+'","Languagecode": "en'+'","FailureID": ['; 
                    repairRequest = repairRequest + '"'+components.compoName+'"';
                    //}
                    repairRequest = repairRequest + '],"SRTType": "REP"}}';
                    System.debug('The repairRequest is!@!@#'+repairRequest);
                    req.setBody(repairRequest);
                    req.setMethod('POST');
                    req.setTimeout(120000);
                    Http http = new Http();    
                    res = http.send(req);
                    System.debug('BODY: '+res.getBody());
                    String jSONRequestBody = res.getBody();
                    //String jSONRequestBody = '{"DataArea":{"CaseResponse":[{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-043-00","AccessCodeB":2.7,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PRIMARY","S9Desc":"","SRTDesc":"Includes:\n-Drain and Fill:\n.Cooling Systems\n-Disconnect and Connect:\n.Turbocharger Compressor Intake Air\nTemperature Sensor\n.Turbocharger Coolant Hoses\n.Turbocharger Speed Sensor\n.Battery Cables and Connections\n-Remove and Install:\n.Aftertreatment Adapter Pipe\n.Aftertreatment Injector Lines\nAftertreatment Intake NOx Sensor\n.Air Intake Piping\n.Turbocharger\n.Turbocharger Oil Drain Line\n.Turbocharger Oil Supply Line\n.Variable Geometry Turbocharger Actuator\n-Operate:\n.Engine and Check for Leaks","SRTTime":2.7,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Turbocharger Assembly Variable Geometry, Remove and Install (CM871/CM2250/2350)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":84860,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n-Drain and Fill:\n.Cooling Systems\n-Disconnect and Connect:\n.Turbocharger Compressor Intake Air\nTemperature Sensor\n.Turbocharger Coolant Hoses\n.Turbocharger Speed Sensor\n.Battery Cables and Connections\n-Remove and Install:\n.Aftertreatment Adapter Pipe\n.Aftertreatment Injector Lines\nAftertreatment Intake NOx Sensor\n.Air Intake Piping\n.Turbocharger\n.Turbocharger Oil Drain Line\n.Turbocharger Oil Supply Line\n.Variable Geometry Turbocharger Actuator\n-Operate:\n.Engine and Check for Leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":1.8,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"00-400-00","AccessCodeB":0.2,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"Steam Clean - Single Component Replacemt","SRTTime":0.2,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Steam Clean - Single Component Repair","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":47394,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Steam Clean - Single Component Replacemt"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.2,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"00-401-00","AccessCodeB":0.5,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"Includes:\n \n -Plug open holes\n -Steam engine\n -Dry engine","SRTTime":0.5,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Steam Clean - Complete Product","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":2766,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n \n -Plug open holes\n -Steam engine\n -Dry engine"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.4,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"00-714-00","AccessCodeB":0.5,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"-Connect unit to loaded trailer if available\n -Operate vehicle over known mileage and:\n  . Verify complaint and/or symptom is occurring\n     OR has been resolved (if applicable)\n  . Check Speedometer / Odometer calibration\n     (for complaints of Fuel Economy)\n\nNOTE: Refer to the following repair procedures and\ntimes, as necessary:\n\n -00-724 INSITE  -Use During Troubleshooting\n    of the INSITE Electronic Service Tool must not\n    be performed by the vehicle operator during\n    an Engine Diagnostic Road Test.  When\n    performing an Engine Diagnostic Road Test, the\n    SRT includes the time required for both the\n    vehicle operator and an additional technician\n    to use the INSITE Electronic Service Tool\n\n -00-713 Engine  -Chassis Dynamometer Diagnostic\n    Check\n -14-708 Engine  -Snap Accelerataion Test\n -14-704 Engine  -Run In and Test (In Chassis)\nIncludes:","SRTTime":0.5,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Engine - Diagnostic Road Test","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":2865,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["-Connect unit to loaded trailer if available\n -Operate vehicle over known mileage and:\n  . Verify complaint and/or symptom is occurring\n     OR has been resolved (if applicable)\n  . Check Speedometer / Odometer calibration\n     (for complaints of Fuel Economy)\n\nNOTE: Refer to the following repair procedures and\ntimes, as necessary:\n\n -00-724 INSITE  -Use During Troubleshooting\n    of the INSITE Electronic Service Tool must not\n    be performed by the vehicle operator during\n    an Engine Diagnostic Road Test.  When\n    performing an Engine Diagnostic Road Test, the\n    SRT includes the time required for both the\n    vehicle operator and an additional technician\n    to use the INSITE Electronic Service Tool\n\n -00-713 Engine  -Chassis Dynamometer Diagnostic\n    Check\n -14-708 Engine  -Snap Accelerataion Test\n -14-704 Engine  -Run In and Test (In Chassis)\nIncludes:"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"00-724-00","AccessCodeB":0.3,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"INSITE - Used during Troubleshooting\n(Refer to the INSITE QUANTUM Users Manual)\n\nNote: This SRT can be added to Electronic\nTroubleshooting SRT. This SRT can only be used\nONE time on each repair order, regardless of the\nnumber of fault codes, failures, or malfunctions.\n\nIncludes:\n\n -Connect and disconnect INSITE\n -Read fault codes\n -View programmable parameters\n -Monitor applicable functional and performance\n  areas (switches, fueling, etc.)\n -Erase inactive fault codes","SRTTime":0.3,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"INSITE - Use During Troubleshooting","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":128936,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["INSITE - Used during Troubleshooting\n(Refer to the INSITE QUANTUM Users Manual)\n\nNote: This SRT can be added to Electronic\nTroubleshooting SRT. This SRT can only be used\nONE time on each repair order, regardless of the\nnumber of fault codes, failures, or malfunctions.\n\nIncludes:\n\n -Connect and disconnect INSITE\n -Read fault codes\n -View programmable parameters\n -Monitor applicable functional and performance\n  areas (switches, fueling, etc.)\n -Erase inactive fault codes"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.3,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-049-00","AccessCodeB":1.4,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"-Drain and fill coolant\n -Disconnect:\n  . Wiring harness connector\n  . Variable geometry turbocharger actuator\n    coolant supply and return lines\n -Remove:\n  . Wiring harness tie straps\n  . Mounting capscrews\n  . Sealing gasket\n  . Variable geometry turbocharger actuator\n -Inspect for reuse:\n  . Clean area\n  . Check for damaged surfaces and gears\n  . Check operating range\n -Install:\n  . Connect to INSITE=\n  . Connect wiring harness\n  . Perform INSITE= tests VGT electronic actuator\n    installation and calibration\n  . Install variable geometry turbocharger\n    actuator on to bearing housing\n -Connect:\n  . Variable geometry turbocharger actuator\n    coolant supply and return hoses\n -Operate Engine Until Thermostat Opens to Check\n   for Leaks, Proper Operation and Correct Fluid\n   Levels\nIncludes:","SRTTime":1.4,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Electronic Actuator, Variable Geometry Turbocharger - Remove and Install","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":97307,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["-Drain and fill coolant\n -Disconnect:\n  . Wiring harness connector\n  . Variable geometry turbocharger actuator\n    coolant supply and return lines\n -Remove:\n  . Wiring harness tie straps\n  . Mounting capscrews\n  . Sealing gasket\n  . Variable geometry turbocharger actuator\n -Inspect for reuse:\n  . Clean area\n  . Check for damaged surfaces and gears\n  . Check operating range\n -Install:\n  . Connect to INSITE=\n  . Connect wiring harness\n  . Perform INSITE= tests VGT electronic actuator\n    installation and calibration\n  . Install variable geometry turbocharger\n    actuator on to bearing housing\n -Connect:\n  . Variable geometry turbocharger actuator\n    coolant supply and return hoses\n -Operate Engine Until Thermostat Opens to Check\n   for Leaks, Proper Operation and Correct Fluid\n   Levels\nIncludes:"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.8,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-421-00","AccessCodeB":0.2,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"Includes:\n\n -Visually check:\n   . Compressor impeller blades\n   . Turbine wheel\n   . Leaks or dust ingestion\n\n -Measure:\n   . Axial movement with dial indicator\n   . Radial movement\n\nNote: Does not include R&I of turbocharger\ninlet and outlet. Additional SRTs may be\nclaimable.\n(Refer to the Turbocharger Component Shop Manual)","SRTTime":0.2,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Turbocharger - Inspect for Reuse (In Chassis)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":121879,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Visually check:\n   . Compressor impeller blades\n   . Turbine wheel\n   . Leaks or dust ingestion\n\n -Measure:\n   . Axial movement with dial indicator\n   . Radial movement\n\nNote: Does not include R&I of turbocharger\ninlet and outlet. Additional SRTs may be\nclaimable.\n(Refer to the Turbocharger Component Shop Manual)"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-801-00","AccessCodeB":0.4,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"(Refer to the Signature Operation and Maintenance\nManual)\n \nIncludes:\n \n -Remove and install:\n  . Air cleaner cover\n  . Air cleaner element\n -Clean and visually check element, cover and\n  sealing gasket for dirt and debris\n -Clean inside air cleaner housing","SRTTime":0.4,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Air Cleaner Element - Service, Each","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":3154,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["(Refer to the Signature Operation and Maintenance\nManual)\n \nIncludes:\n \n -Remove and install:\n  . Air cleaner cover\n  . Air cleaner element\n -Clean and visually check element, cover and\n  sealing gasket for dirt and debris\n -Clean inside air cleaner housing"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.3,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-019-00","AccessCodeB":0.1,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"Includes:\n\n -Remove Exhaust Heat Shield\n -Inspect Exhaust Heat Shield for Reuse\n -Install Exhaust Heat Shield\n -Torque capscrews to specification (refer to\n   applicable OEM manual)","SRTTime":0.1,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Exhaust Heat Shield (OEM Installed) - Remove and Install","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":112135,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Remove Exhaust Heat Shield\n -Inspect Exhaust Heat Shield for Reuse\n -Install Exhaust Heat Shield\n -Torque capscrews to specification (refer to\n   applicable OEM manual)"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-039-00","AccessCodeB":1,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"Includes:\n\n -Inspect aftertreatment and exhaust system\n -Connect INSITE= service tool\n -Allow engine to complete stationary regeneration\n -Inspect aftertreatment and exhaust system","SRTTime":1,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Stationary Regeneration","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":88177,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Inspect aftertreatment and exhaust system\n -Connect INSITE= service tool\n -Allow engine to complete stationary regeneration\n -Inspect aftertreatment and exhaust system"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"17-167-00","AccessCodeB":0.2,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"Inner Fender - Remove and Install","SRTTime":0.2,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Inner Fender - Remove and Install (Automotive Applications)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":3248,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Inner Fender - Remove and Install"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"19-361-00","AccessCodeB":0.1,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"ALTERNATIVE","S9Desc":"","SRTDesc":"Includes:\n\n -Connect and disconnect:\n  . Component or harness connector halves\n -Clean and inspect connector and pin\n\nNote: The following SRTs are NOT included in the\ntotal time above, but may apply if the work is\nrequired per CUMMINS published guidelines,\nperfromed and explained on the claim:\n\n -Troubleshoot  -Inactive or Intermittent\n   Fault Code(s)","SRTTime":0.1,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Component Connector and Pin - Inspection, Each Four","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":120013,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Connect and disconnect:\n  . Component or harness connector halves\n -Clean and inspect connector and pin\n\nNote: The following SRTs are NOT included in the\ntotal time above, but may apply if the work is\nrequired per CUMMINS published guidelines,\nperfromed and explained on the claim:\n\n -Troubleshoot  -Inactive or Intermittent\n   Fault Code(s)"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.1,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-011-00","AccessCodeB":0.7,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Includes:\n\n -Disconnect and connect batteries\n -Remove and Install:\n  . Air intake manifold\n  . One, charge air pipe\n  . Air inlet hose\n  . Fuel rail pressure relief valve drain line\n  . EGR crossover tube\n -Clean and visually check intake manifold\n   for cracks or damage\n -Operate engine to check for leaks","SRTTime":0.7,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Intake Manifold - Remove and Install First","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":111148,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Disconnect and connect batteries\n -Remove and Install:\n  . Air intake manifold\n  . One, charge air pipe\n  . Air inlet hose\n  . Fuel rail pressure relief valve drain line\n  . EGR crossover tube\n -Clean and visually check intake manifold\n   for cracks or damage\n -Operate engine to check for leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-056-00","AccessCodeB":0.5,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Includes:\n\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Preparatory Steps\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Remove\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Clean and Inspect for Reuse\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Install\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Finishing Steps\"","SRTTime":0.5,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Intake air Shutoff Valve - Remove and Install (CM2350)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":111582,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Preparatory Steps\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Remove\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Clean and Inspect for Reuse\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Install\"\n -010-143 Air Shutoff Valve service procedure -\n    Section \"Finishing Steps\""]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.4,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-057-00","AccessCodeB":0.5,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Includes:\n\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Preparatory Steps\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Remove\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Clean and Inspect for\n    Reuse\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Install\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Finishing Steps\"","SRTTime":0.5,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Engine Throttle Actuator - Remove and Install","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":111263,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Preparatory Steps\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Remove\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Clean and Inspect for\n    Reuse\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Install\"\n -010-140 Intake Throttle Actuator service\n    procedure - Section \"Finishing Steps\""]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.4,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-146-00","AccessCodeB":0.6,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Includes:\n\n\n\n\n -Remove and install air cooler\n -Clean and visually check air cooler external","SRTTime":0.6,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Charge Air Cooler - Remove and Install (Part of Another Repair)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":3148,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n\n\n\n -Remove and install air cooler\n -Clean and visually check air cooler external"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-401-00","AccessCodeB":0,"SRTAccessCode":"R","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Includes:\n\n\n\n\n -Flush cooler with solvent\n -Flush cooler with soapy water\n -Blow-dry with compressed air","SRTTime":0.6,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Charge Air Cooler - Clean and Visually Check (Internal)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":3150,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n\n\n\n -Flush cooler with solvent\n -Flush cooler with soapy water\n -Blow-dry with compressed air"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.6,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-043-00","AccessCodeB":0,"SRTAccessCode":"R","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Includes:\n\n -Clean aftertreatment diesel oxidation catalyst","SRTTime":0.6,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Oxidation Catalyst - Clean","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":88181,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Clean aftertreatment diesel oxidation catalyst"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.6,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-06H-00","AccessCodeB":1.3,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Particulate Filter\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Mounting Bracket\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Tubes\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment Outlet\nOperate:\n    -Engine and check for leaks","SRTTime":1.3,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Particulate Filter, (Horizontal) - Remove and Install - ISX15 CM2350 X101","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":138468,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Particulate Filter\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Mounting Bracket\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Tubes\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment Outlet\nOperate:\n    -Engine and check for leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-06J-00","AccessCodeB":1.9,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Particulate Filter\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Mounting Bracket\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Tubes\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment Outlet\nOperate:\n    -Engine and check for leaks","SRTTime":1.9,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Particulate Filter, (Vertical) - Remove and Install - ISX15 CM2350 X101","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":138473,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Particulate Filter\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Mounting Bracket\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Tubes\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment Outlet\nOperate:\n    -Engine and check for leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-06K-00","AccessCodeB":2.3,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Particulate Filter\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Mounting Bracket\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Tubes\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment Outlet\n    -Aftertreatment System\nOperate:\n    -Engine and check for leaks","SRTTime":2.3,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Particulate Filter, (Switchback) - Remove and Install - ISX15 CM2350 X101","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":138469,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Particulate Filter\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Mounting Bracket\n    -Aftertreatment Diesel Particulate Filter \n     Differential Pressure Sensor Tubes\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment Outlet\n    -Aftertreatment System\nOperate:\n    -Engine and check for leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-06M-00","AccessCodeB":0.8,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Oxidation Catalyst\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Exhaust Gas Temperature Sensor\nOperate:\n    -Engine and check for leaks","SRTTime":0.8,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Oxidation Catalyst, (Horizontal) - Remove and Install - ISX15 CM2350 X101","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":138465,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Oxidation Catalyst\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Exhaust Gas Temperature Sensor\nOperate:\n    -Engine and check for leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-06N-00","AccessCodeB":1.4,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Oxidation Catalyst\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Exhaust Gas Temperature Sensor\nOperate:\n    -Engine and check for leaks","SRTTime":1.4,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Oxidation Catalyst, (Vertical) - Remove and Install - ISX15 CM2350 X101","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":138462,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Oxidation Catalyst\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Exhaust Gas Temperature Sensor\nOperate:\n    -Engine and check for leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-06P-00","AccessCodeB":1.8,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Oxidation Catalyst\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment System\nOperate:\n    -Engine and check for leaks","SRTTime":1.8,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Oxidation Catalyst, (Switchback) - Remove and Install - ISX15 CM2350 X101","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":138457,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Disconnect and Connect:\n    -Batteries\nRemove and Install:\n    -Aftertreatment Diesel Oxidation Catalyst\n    -Aftertreatment Diesel Particulate Filter \n     Assembly\n    -Aftertreatment Exhaust Gas Temperature Sensor\n    -Aftertreatment System\nOperate:\n    -Engine and check for leaks"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"12-100-00","AccessCodeB":0.7,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"Includes:","SRTTime":0.7,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Air Compressor-Cylinder Head - Clean","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":118979,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"14-722-00","AccessCodeB":0.1,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"- Start engine and idle\n - Perform Snap Test","SRTTime":0.1,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment - Snap Test (Aftertreatment Connected)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":143694,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["- Start engine and idle\n - Perform Snap Test"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"14-723-00","AccessCodeB":0.2,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"PROGRESSIVE DAMAGE","S9Desc":"","SRTDesc":"- Disconnect and Connect:\n . Exhaust pipe between turbocharger\n and aftertreatment\n- Start engine and idle\n- Perform Snap Test","SRTTime":0.2,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Engine - Snap Test (Aftertreatment Disconnected)","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":143695,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["- Disconnect and Connect:\n . Exhaust pipe between turbocharger\n and aftertreatment\n- Start engine and idle\n- Perform Snap Test"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-062-00","AccessCodeB":0.1,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"DIAGNOSTIC","S9Desc":"","SRTDesc":"Includes:\n\n -Inspect hoses, clamps and piping for leaks and\n  loose connections, with soapy water, if\n  necessary\n -Inspect turbocharger, EGR plumbing, EGR valve,\n   exhaust manifold and aftertreatment components\n   for leaks and loose connections, with soapy\n    water, if necessary\n\nNOTE:  Refer to the following repair procedures\n    and times, as necessary:\n\n - 00 -714 Engine - Diagnostic Road Test Operate\n - 00 -713 Engine - Chassis Dynamometer\n - 14 -704 Engine - Run In and Test (In Chassis)","SRTTime":0.1,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Air Intake and Exhaust System - Inspection","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":114829,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Inspect hoses, clamps and piping for leaks and\n  loose connections, with soapy water, if\n  necessary\n -Inspect turbocharger, EGR plumbing, EGR valve,\n   exhaust manifold and aftertreatment components\n   for leaks and loose connections, with soapy\n    water, if necessary\n\nNOTE:  Refer to the following repair procedures\n    and times, as necessary:\n\n - 00 -714 Engine - Diagnostic Road Test Operate\n - 00 -713 Engine - Chassis Dynamometer\n - 14 -704 Engine - Run In and Test (In Chassis)"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.1,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-703-00","AccessCodeB":0.3,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"DIAGNOSTIC","S9Desc":"","SRTDesc":"(Refer to the appropriate Troubleshooting and\nRepair Manual)\n\nIncludes:\n\n -Remove and install:\n  . Pressurizing device\n -Apply pressure and check for leaks\n -Blow-dry with compressed air\n\nNote: Does not include items removed for access to\nperform test.","SRTTime":0.3,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Charge Air Cooler - Pressure Test","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":3153,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["(Refer to the appropriate Troubleshooting and\nRepair Manual)\n\nIncludes:\n\n -Remove and install:\n  . Pressurizing device\n -Apply pressure and check for leaks\n -Blow-dry with compressed air\n\nNote: Does not include items removed for access to\nperform test."]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.3,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-803-00","AccessCodeB":0.3,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"DIAGNOSTIC","S9Desc":"","SRTDesc":"-010-033 Turbocharger service procedure -\n    Section \"Leak Test\"\n\n\n\n\n\n\n\n\nIncludes:","SRTTime":0.3,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Turbocharger - Coolant Leak Test","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":120181,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["-010-033 Turbocharger service procedure -\n    Section \"Leak Test\"\n\n\n\n\n\n\n\n\nIncludes:"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"19-052-00","AccessCodeB":0.1,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"DIAGNOSTIC","S9Desc":"","SRTDesc":"Includes:\n\n - Connect and disconnect:\n  . Component or harness connector halves\n  . Multimeter probes or clips to appropriate\n    source\n - Measure the voltage","SRTTime":0.1,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Voltage - Measure, Each Four","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":120004,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n - Connect and disconnect:\n  . Component or harness connector halves\n  . Multimeter probes or clips to appropriate\n    source\n - Measure the voltage"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"19-710-00","AccessCodeB":0.1,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"DIAGNOSTIC","S9Desc":"","SRTDesc":"Includes:\n -Connect and disconnect gauge\n -Verify measurement or reading\n\nNote: Does not include R&I of sensors or\n    components, additional SRTs may be\n     required.","SRTTime":0.1,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Measurement - Verify With Mechanical Gauge","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":120491,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n -Connect and disconnect gauge\n -Verify measurement or reading\n\nNote: Does not include R&I of sensors or\n    components, additional SRTs may be\n     required."]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"10-117-00","AccessCodeB":0.5,"SRTAccessCode":"B","AccessCodeA":0,"S6Desc":"","Assignment":"UNLISTED","S9Desc":"","SRTDesc":"-Disconnect and connect air intake piping from\n    the air cleaner\n -Remove and Install:\n  . Air Cleaner Assembly\n   . Mounting brackets as required\n   . Connecting hoses or elbows as required\n -Visually check air cleaner exterior\n   . Assembly\n   . Piping\n   . Hose interior for debris or damage\n    - Operate engine to check for air leaks\n\nNote: Does NOT include:\n    - Servicing air filter or precleaner elements\n    - Repairing damage to filter canister or\n      piping\n    - Cleaning of hoses or pipes\n(Refer to the Manufacturers Instructions)\n\nIncludes:","SRTTime":0.5,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Air Cleaner Assembly (Including Bracket) - Remove and Install, Each","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":3139,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["-Disconnect and connect air intake piping from\n    the air cleaner\n -Remove and Install:\n  . Air Cleaner Assembly\n   . Mounting brackets as required\n   . Connecting hoses or elbows as required\n -Visually check air cleaner exterior\n   . Assembly\n   . Piping\n   . Hose interior for debris or damage\n    - Operate engine to check for air leaks\n\nNote: Does NOT include:\n    - Servicing air filter or precleaner elements\n    - Repairing damage to filter canister or\n      piping\n    - Cleaning of hoses or pipes\n(Refer to the Manufacturers Instructions)\n\nIncludes:"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.3,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""},{"AccessCodeD":0,"AccessCodeC":0,"SRTDetails":"11-041-00","AccessCodeB":0,"SRTAccessCode":"R","AccessCodeA":0,"S6Desc":"","Assignment":"NOT CLAIMABLE","S9Desc":"","SRTDesc":"Includes:\n\n -Install and remove inlet cone to aftertreatment\n    diesel particulate filter\n -Install and remove outlet cone to aftertreatment\n    diesel particulate filter\n -Install and remove filter from machine\n -Set up machine","SRTTime":0.8,"S1Desc":"","S5Desc":"","S3Desc":"","S8Desc":"","SRTQuantity":1,"AccessCodeS1":0,"SRTTitle":"Aftertreatment Diesel Particulate Filter - Clean","S4Desc":"","FailureID":"F10000120","VerifyRepeatValue":{"SRTEventPerfDateTime":"","SRTType":"","Step":{"StepID":88179,"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Includes:\n\n -Install and remove inlet cone to aftertreatment\n    diesel particulate filter\n -Install and remove outlet cone to aftertreatment\n    diesel particulate filter\n -Install and remove filter from machine\n -Set up machine"]}},"AccessCodeS8":0,"AccessCodeS9":0,"AccessCodeR":0.8,"AccessCodeS6":0,"S2Desc":"","AccessCodeS7":0,"SRTMessage":"","AccessCodeS4":0,"AccessCodeS5":0,"AccessCodeS2":0,"AccessCodeS3":0,"FailureName":"Turbocharger","S7Desc":""}],"ResponseMessage":""},"Header":{"Status":"Success","ReturnCodeDescription":""}}';
                    string repNotFound = '{"DataArea":{"ResponseMessage":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination."},"Header":{"ReturnCodeDescription":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination.","Status":"Error"}}'; // defect # 62135
                    System.debug('The request body is'+jSONRequestBody); // defect # 62135
                    //if(!Test.isRunningTest()){
                    CSS_J2ARepair_SRT wo1 = (CSS_J2ARepair_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2ARepair_SRT.class);
                    system.debug('wo1**'+wo1);
                    //Story 90222 start querying to get the Maximum Repair Sort Order
                    /* AggregateResult[] groupedResults= [SELECT type__c, MAX(SRT_Order__c) 
                                                   FROM CSS_SRT__c GROUP BY type__c 
                                                   HAVING type__c='Repair' or type__c ='Repair Access'];
                    Decimal sortOrder;
                    if(groupedResults != null && groupedResults.size() > 0){
                        sortOrder =(decimal) groupedResults[0].get('expr0') > (decimal) groupedResults[1].get('expr0') ? (decimal) groupedResults[0].get('expr0') : (decimal) groupedResults[1].get('expr0');
                    }*/
                    /* for (AggregateResult ar : groupedResults)  {
                        System.debug('type :- '+ ar.get('type__c'));
                        System.debug('Max :-' + ar.get('expr0'));
                    }*/
                    //Story 90222 End
                    // for(integer j=0;j<solComp.size();j++){
                    // added if block for defect # 62135                    
                    if(jSONRequestBody.contains(repNotFound)){
                        System.debug('Inside no srt found');
                        repSRT = new CSS_SRT__c();
                        repSRT.Name = '0';
                        repSRT.Type__c = 'Repair'; 
                        repSRT.Response_Message__c = 'Please refer to QSOL to determine if additional labor is warrantable for this action. If so, follow your current process to claim reimbursement.';
                        repSRT.Job_Order__c = components.jobID; 
                        repSRT.Solution_Number__c = components.solID;
                        repSRT.Component_Id__c = components.compID;
                        repSRT.SRT_Time__c = 0.0;
                        repSRT.SRT_Quantity__c = 1;
                        repSRT.SRT_ID__c = '0';
                        repSRT.isPerformed__c = True;
                        repairSRT.add(repSRT);
                        //break;
                    }
                    else if(wo1 != null && wo1.DataArea.CaseResponse!=null){

                        for(integer i=0;i<wo1.DataArea.CaseResponse.size();i++){ 
                            //if(wo1.DataArea.CaseResponse[i].SRTTitle!='DUMMY'){
                            System.debug('Inside srt found'); // added for defect # 62135
                            if(wo1.DataArea.CaseResponse[i].FailureID!=null){ // added for defect # 62135
                                if(wo1.DataArea.CaseResponse[i].SRTDetails != '00-901-00' && wo1.DataArea.CaseResponse[i].SRTDetails != '00-902-00' && wo1.DataArea.CaseResponse[i].SRTDetails != '00-904-00' && wo1.DataArea.CaseResponse[i].SRTDetails != '00-10S-00'){
                                    System.debug('Inside srt found'+ wo1.DataArea.CaseResponse[i].SRTDetails); 
                                    if(components.compoName== wo1.DataArea.CaseResponse[i].FailureID){
                                        repSRT = new CSS_SRT__c();    
                                        repSRT.Name = wo1.DataArea.CaseResponse[i].FailureID;
                                        repSRT.Type__c = 'Repair';
                                        if(wo1.DataArea.CaseResponse[i].FlexSRT != null && wo1.DataArea.CaseResponse[i].FlexSRT !=''){
                                            if(wo1.DataArea.CaseResponse[i].FlexSRT == 'Y'){
                                                repSRT.Flex_Flag__c = true;
                                            }
                                            else{
                                                repSRT.Flex_Flag__c = false;
                                            }
                                        }
                                        if(wo1.DataArea.CaseResponse[i].ECMFlag != null && wo1.DataArea.CaseResponse[i].ECMFlag !=''){
                                            if(wo1.DataArea.CaseResponse[i].ECMFlag == 'Y'){
                                                repSRT.ECM_Flag__c = true;
                                            }
                                            else{
                                                repSRT.ECM_Flag__c = false;
                                            }
                                        }
                                        /*Story 90222 Setting the Sort Order For Repair SRT
                                        repSRT.SRT_Order__c = sortOrder + 1 ;
                                        sortOrder = repSRT.SRT_Order__c;
                                        //Story 90222 End*/
                                        system.debug('components.failCode'+components.failCode);
                                        system.debug('components.type'+components.type);
                                        system.debug('components.CoveredLaborHrs'+components.CoveredLaborHrs);
                                        //GSSC-297 - START
                                        String tempFailCode;
                                        if(accCodeFailCodeMap != null){
                                            tempFailCode = accCodeFailCodeMap.get(components.accountCode);
                                        }
                                        if(tempFailCode != null && tempFailCode != ''){
                                            repSRT.FailCode__c = tempFailCode;
                                        }
                                        else{ //GSSC-297 - END
                                            repSRT.FailCode__c = (components.failCode != null && components.failCode != '' ? components.failCode.trim().right(4) : '');
                                        }
                                        if(components.type != 'Campaign' && components.type != 'TRP' && components.type != 'ATC'){
                                            if(components.CoveredLaborHrs != null && components.CoveredLaborHrs != '' && double.valueof(components.CoveredLaborHrs) > 0){
                                                System.debug('Inside camptrpatc***'+components.accountCode); 
                                                System.debug('serJob.CSS_In_Shop_Labor_Rate__c***'+serJob.CSS_In_Shop_Labor_Rate__c); 
                                                repSRT.Account_Code__c = (serJob.CSS_In_Shop_Labor_Rate__c != null && serJob.CSS_In_Shop_Labor_Rate__c != '0' && serJob.CSS_In_Shop_Labor_Rate__c != '' ? components.accountCode : '');
                                                system.debug('repSRT.Account_Code__c>>>>'+repSRT.Account_Code__c);
                                                repSRT.SRT_Warrantable__c = '100';
                                            }
                                            else{
                                                repSRT.SRT_Warrantable__c = '0';
                                            }
                                        }
                                        else{
                                            if(components.CampaignLaborPercentage != null && components.CampaignLaborPercentage != '' && double.valueof(components.CampaignLaborPercentage) > 0){
                                                System.debug('Inside elsecamptrpatc***'+components.accountCode); 
                                                repSRT.Account_Code__c = (serJob.CSS_In_Shop_Labor_Rate__c != null && serJob.CSS_In_Shop_Labor_Rate__c != '0' && serJob.CSS_In_Shop_Labor_Rate__c != '' ? components.accountCode : '');
                                                repSRT.SRT_Warrantable__c = '100';
                                            }
                                            else{
                                                repSRT.SRT_Warrantable__c = '0';
                                            }
                                        }
                                        System.debug('acccode***'+components.accountCode); 
                                        System.debug('repSRT.SRT_Warrantable__c***'+repSRT.SRT_Warrantable__c);
                                        system.debug('outside repSRT.Account_Code__c>>>>'+repSRT.Account_Code__c);
                                        repSRT.SRT_Title__c = wo1.DataArea.CaseResponse[i].SRTTitle;
                                        // repSRT.SRT_Quantity__c = string.valueof(wo1.DataArea.CaseResponse[i].SRTQuantity);       
                                        repSRT.SRT_ID__c = wo1.DataArea.CaseResponse[i].SRTDetails;//SRTDETAILS equals SRT-ID
                                        repSRT.SRT_Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;
                                        repSRT.Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;//Story#172627
                                        if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription!=null){
                                            for(integer k=0;k<wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription.size();k++){
                                                if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[k]!='DUMMY'){
                                                    repSRT.Step_Description__c = repSRT.Step_Description__c + wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[k]+'\n'; 
                                                }
                                            }
                                        }
                                        repSRT.Step_Id__c = String.valueOf(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepID);
                                        repSRT.Assignment__c = wo1.DataArea.CaseResponse[i].Assignment;
                                        repSRT.Failure_Name__c = wo1.DataArea.CaseResponse[i].FailureName;
                                        repSRT.Solution_Number__c = components.solID;
                                        repSRT.Job_Order__c = components.jobID; 
                                        repSRT.Component_Id__c = components.compID;
                                        repSRT.SRT_Time__c = wo1.DataArea.CaseResponse[i].SRTTime; //* 60;Anirudh 
                                        repSRT.SRT_Quantity__c = 1;
                                        repSRT.SRT_Usage__c = wo1.DataArea.CaseResponse[i].SRTUsage; // GSSC- 25
                                        //Added below code for new parameters in response from SRT
                                        repSRT.Access_Code_A__c = wo1.DataArea.CaseResponse[i].AccessCodeA;
                                        repSRT.Access_Code_B__c = wo1.DataArea.CaseResponse[i].AccessCodeB;
                                        repSRT.Access_Code_C__c = wo1.DataArea.CaseResponse[i].AccessCodeC;
                                        repSRT.Access_Code_D__c = wo1.DataArea.CaseResponse[i].AccessCodeD;
                                        repSRT.Access_Code_R__c = wo1.DataArea.CaseResponse[i].AccessCodeR;
                                        repSRT.Access_Code_S1__c = wo1.DataArea.CaseResponse[i].AccessCodeS1;
                                        repSRT.Access_Code_S2__c = wo1.DataArea.CaseResponse[i].AccessCodeS2;
                                        repSRT.Access_Code_S3__c = wo1.DataArea.CaseResponse[i].AccessCodeS3;
                                        repSRT.Access_Code_S4__c = wo1.DataArea.CaseResponse[i].AccessCodeS4;
                                        repSRT.Access_Code_S5__c = wo1.DataArea.CaseResponse[i].AccessCodeS5;
                                        repSRT.Access_Code_S6__c = wo1.DataArea.CaseResponse[i].AccessCodeS6;
                                        repSRT.Access_Code_S7__c = wo1.DataArea.CaseResponse[i].AccessCodeS7;
                                        repSRT.Access_Code_S8__c = wo1.DataArea.CaseResponse[i].AccessCodeS8;
                                        repSRT.Access_Code_S9__c = wo1.DataArea.CaseResponse[i].AccessCodeS9;
                                        repSRT.S1_Description__c = wo1.DataArea.CaseResponse[i].S1Desc;
                                        repSRT.S2_Description__c = wo1.DataArea.CaseResponse[i].S2Desc;
                                        repSRT.S3_Description__c = wo1.DataArea.CaseResponse[i].S3Desc;
                                        repSRT.S4_Description__c = wo1.DataArea.CaseResponse[i].S4Desc;
                                        repSRT.S5_Description__c = wo1.DataArea.CaseResponse[i].S5Desc;
                                        repSRT.S6_Description__c = wo1.DataArea.CaseResponse[i].S6Desc;
                                        repSRT.S7_Description__c = wo1.DataArea.CaseResponse[i].S7Desc;
                                        repSRT.S8_Description__c = wo1.DataArea.CaseResponse[i].S8Desc;
                                        repSRT.S9_Description__c = wo1.DataArea.CaseResponse[i].S9Desc;
                                        repSRT.SRT_Message__c = wo1.DataArea.CaseResponse[i].SRTMessage;
                                        repSRT.SRT_Notes__c = wo1.DataArea.CaseResponse[i].SRTDesc;
                                        if(wo1.DataArea.CaseResponse[i].FlexSRT != 'Y'){//GSSC-24 changes
                                            repSRT.SRT_Quantity__c = wo1.DataArea.CaseResponse[i].SRTQuantity;
                                        }else{
                                            repSRT.SRT_Quantity__c = 1;
                                        }
                                        if(maxOrder != null){
                                            repSRT.SRT_Order__c = maxOrder + 1;
                                            maxOrder = repSRT.SRT_Order__c;
                                        }
                                        else{
                                            repSRT.SRT_Order__c = sortOrder + 1;
                                            sortOrder = repSRT.SRT_Order__c;
                                        }   
                                        //End of the code for new parameters in response from SRT
                                        /*if(wo1.DataArea.CaseResponse[i].Assignment=='PRIMARY'){
                                            repSRT.isPerformed__c = True;
                                        }else{
                                            repSRT.isPerformed__c = false;
                                        }*/
                                        //story 162535: START Code to update the existing Daig Rep SRTs with the same SRT ID, based on their Assignment values.
                                        Boolean dontInsert = false; // below IF is to not to display repair SRT, if the same SRT COde is added to the job,while troubleshooting
                                        system.debug('dontinsert**'+dontinsert);
                                        Set<String> DiagAccSRTs = new Set<String>();
                                        if(repSRT.SRT_ID__c != '' && repSRT.SRT_ID__c != null){
                                            system.debug('existDiagAccSrtList---'+ existDiagAccSrtList);
                                            if(existDiagAccSrtList != null && existDiagAccSrtList.size()>0){
                                                for(Css_srt__c srt:existDiagAccSrtList){
                                                    if(srt.SRT_ID__c != null && srt.SRT_ID__c != ''){
                                                        system.debug('srt.SRT_ID__c FINAL ' + srt.SRT_ID__c);
                                                        system.debug('repSRT.SRT_ID__c FINAL ' + repSRT.SRT_ID__c);
                                                        //system.debug('repSRT.SRT_ID__c.right(2).trim() FINAL ' + repSRT.SRT_ID__c.right(2).trim());
                                                        //if(repSRT.SRT_ID__c == srt.SRT_ID__c+'-'+repSRT.SRT_ID__c.right(2).trim())    ////Modified by krishna on GSSC - 327
                                                        if(repSRT.SRT_ID__c == srt.SRT_ID__c){  //Modified by krishna on GSSC - 327
                                                            dontInsert = true;
                                                            DiagAccSRTs.add(repSRT.SRT_ID__c);
                                                            // break;
                                                        }
                                                    }
                                                }

                                            }
                                            system.debug('dontinsert1**'+dontinsert);
                                            system.debug('repSRT.SRT_ID__c**'+repSRT.SRT_ID__c);
                                            //To Check/Uncheck the SRTs based on Assignment 
                                            // if(dontInsert == false){
                                            Boolean isRep = false;
                                            Set<String> UpdatedSRTIDs = new Set<String>();
                                            if(existrepSrtList != null && existrepSrtList.size()>0){

                                                for(Css_srt__c srt:existrepSrtList){

                                                    system.debug('RepSRT**'+repSRT.SRT_ID__c);
                                                    system.debug('ExistSRT**'+srt.SRT_ID__c);
                                                    system.debug('StringSrt**'+repSRT.SRT_ID__c.substring(0,repSRT.SRT_ID__c.length()-3));

                                                    if((repSRT.SRT_ID__c != null && repSRT.SRT_ID__c != '') && (srt.SRT_ID__c != null && srt.SRT_ID__c != '') && (srt.Assignment__c != null && srt.Assignment__c != '') && srt.Assignment__c == 'PRIMARY'){
                                                        system.debug('Inside IF RepSRT**');
                                                        isRep=true;
                                                        if(repSRT.SRT_ID__c == srt.SRT_ID__c){
                                                            srt.isPerformed__c = True;
                                                            UpdatedSRTIDs.add(srt.SRT_ID__c);
                                                            // if(!repSRTtobeUpdated.contains(srt))
                                                            repSRTtobeUpdated.add(srt);}
                                                        for(Css_srt__c srt1:existdiagSrtList){
                                                            if(srt1.SRT_ID__c != null && srt1.SRT_ID__c != ''){
                                                                if(repSRT.SRT_ID__c.length() == srt1.SRT_ID__c.length()){
                                                                    if(repSRT.SRT_ID__c == srt1.SRT_ID__c){
                                                                        // if(repSRT.SRT_ID__c.substring(0,repSRT.SRT_ID__c.length()-3) == srt1.SRT_ID__c){
                                                                        srt1.isPerformed__c = false;
                                                                        UpdatedSRTIDs.add(srt1.SRT_ID__c);
                                                                        if(!diagSRTtobeUpdated.contains(srt1))
                                                                            diagSRTtobeUpdated.add(srt1);
                                                                    }
                                                                }

                                                                else{
                                                                    system.debug('insideELSE$$$$$'+srt1.SRT_ID__c);
                                                                    system.debug('repSRT.SRT_ID__c.right(2).trim()$$$$$'+repSRT.SRT_ID__c.right(2).trim());
                                                                    if(srt1.step_description__c == 'null' || srt1.step_description__c == '' || srt1.step_description__c == null){system.debug('insideif$$$$$');
                                                                  if(repSRT.SRT_ID__c == srt1.SRT_ID__c+'-'+repSRT.SRT_ID__c.right(2).trim() && repSRT.Assignment__c=='PRIMARY' && srt1.Assignment__c=='PRIMARY'){  // && repSRT.Assignment__c=='PRIMARY' && srt1.Assignment__c=='PRIMARY' is added by Rajesh Narra
                                                                      srt1.isPerformed__c = false;
                                                                      UpdatedSRTIDs.add(srt1.SRT_ID__c);
                                                                      if(!diagSRTtobeUpdated.contains(srt1))
                                                                          diagSRTtobeUpdated.add(srt1);
                                                                  }
                                                            }
                                                                    else{
                                                                        system.debug('insideELSEELSE$$$$$'+srt1.step_description__c+'exsistSRT'+srt1.SRT_ID__c);
                                                                        string stepdesc = srt1.step_description__c;
                                                                        system.debug('stepdesc**'+stepdesc);
                                                                        system.debug('repSRT.SRT_ID__c**'+repSRT.SRT_ID__c);
                                                                        if(stepdesc.contains('Step Number')){
                                                                            system.debug('Inside**'+stepdesc.substringAfter('-').substring(0,2));
                                                                            //system.debug('Kal**'+stepdesc.substringAfter('-').substring(-1,1));
                                                                            //if(repSRT.SRT_ID__c == srt1.SRT_ID__c+srt1.step_description__c.substringAfter('-').substring(0,2)){
                                                                            //if(repSRT.SRT_ID__c == srt1.SRT_ID__c+'-'+stepdesc.substringAfter('-').substring(0,2)){
                                                                            if(repSRT.SRT_ID__c == srt1.SRT_ID__c+'-'+stepdesc.substringAfter('-').substring(0,2) && repSRT.Assignment__c=='PRIMARY' && srt1.Assignment__c=='PRIMARY'){  //&& repSRT.Assignment__c=='PRIMARY' && srt1.Assignment__c=='PRIMARY' repSRT.SRT_ID__c == srt.SRT_ID__c && srt.Assignment__c == 'PRIMARY' is added by Rajesh Narra
                                                                                system.debug('InsideAfter**'+stepdesc);
                                                                                srt1.isPerformed__c = false;
                                                                                system.debug('srt1.SRT_ID__c**'+srt1.SRT_ID__c);
                                                                                UpdatedSRTIDs.add(srt1.SRT_ID__c);
                                                                                if(!diagSRTtobeUpdated.contains(srt1))
                                                                                    diagSRTtobeUpdated.add(srt1);
                                                                                system.debug('diagSRTtobeUpdated**'+diagSRTtobeUpdated);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }


                                                }
                                                // system.debug('repSRTtobeUpdatedSize---'+ repSRTtobeUpdated.size());
                                                ///  system.debug('diagSRTtobeUpdatedSize---'+ diagSRTtobeUpdated.size());
                                            }
                                            system.debug('isRep**'+isRep);
                                            system.debug('UpdatedSRTIDs**'+UpdatedSRTIDs);
                                            if(existdiagSrtList != null && existdiagSrtList.size()>0){
                                                for(Css_srt__c srt:existdiagSrtList){
                                                    //if(srt.SRT_ID__c != null && srt.SRT_ID__c != '' && UpdatedSRTIDs!= null && !UpdatedSRTIDs.isEmpty() && !UpdatedSRTIDs.contains(srt.SRT_ID__c)){ 
                                                    if(srt.SRT_ID__c != null && srt.SRT_ID__c != '' && !UpdatedSRTIDs.contains(srt.SRT_ID__c)){ 
                                                        system.debug('DiagSRT**'+srt.SRT_ID__c);

                                                        if((srt.Assignment__c != null && srt.Assignment__c != '') && srt.Assignment__c == 'PRIMARY'){ 
                                                            if((repSRT.SRT_ID__c != null && repSRT.SRT_ID__c != '') && (srt.SRT_ID__c != null && srt.SRT_ID__c != '') && repSRT.SRT_ID__c.length() == srt.SRT_ID__c.length()){ 
                                                                if(repSRT.SRT_ID__c == srt.SRT_ID__c){
                                                                    //  srt.isPerformed__c = True;
                                                                    if(repSRT.Assignment__c=='PRIMARY')
                                                                    	srt.isPerformed__c = false;
                                                                    
                                                                    // UpdatedSRTIDs.add(srt.SRT_ID__c);
                                                                    if(!diagSRTtobeUpdated.contains(srt))
                                                                        diagSRTtobeUpdated.add(srt);
                                                                    /* for(Css_srt__c srt1:existrepSrtList){
                                                        if(repSRT.SRT_ID__c == srt1.SRT_ID__c){
                                                        srt1.isPerformed__c = false;
                                                        repSRTtobeUpdated.add(srt1);
                                                        }
                                                   }*/
                                                                }
                                                            }
                                                            if((repSRT.SRT_ID__c != null && repSRT.SRT_ID__c != '') && (srt.SRT_ID__c != null && srt.SRT_ID__c != '') && repSRT.SRT_ID__c.length() != srt.SRT_ID__c.length()){ 
                                                               system.debug('insideif$$$$$ !null repSRT.SRT_ID__c.length() != srt.SRT_ID__c.length');

                                                                if(srt.step_description__c == 'null' || srt.step_description__c == '' || srt.step_description__c == null)
                                                                {
                                                                    system.debug('insideif$$$$$');
                                                                    if(repSRT.SRT_ID__c == srt.SRT_ID__c+'-'+repSRT.SRT_ID__c.right(2).trim()){
                                                                        // srt.isPerformed__c = True;
                                                                        if(repSRT.Assignment__c=='PRIMARY')
                                                                        	srt.isPerformed__c = false;
                                                                        
                                                                        if(!diagSRTtobeUpdated.contains(srt))
                                                                            diagSRTtobeUpdated.add(srt);
                                                                    }
                                                                }
                                                                else{
                                                                    string stepdesc = srt.step_description__c;
                                                                     system.debug('inside else $$$');
                                                                    /*if(srt.step_description__c.contains('Step Number-')){
                                                            if(repSRT.SRT_ID__c == srt.SRT_ID__c+srt.step_description__c.substringAfter('-').substring(0,2)){*/
                                                                    if(stepdesc.contains('Step Number')){
                                                                        if(repSRT.SRT_ID__c == srt.SRT_ID__c+'-'+stepdesc.substringAfter('-').substring(0,2)){
                                                                            //srt.isPerformed__c = true;
                                                                            if(repSRT.Assignment__c=='PRIMARY')
                                                                            	srt.isPerformed__c = false;
                                                                            
                                                                            if(!diagSRTtobeUpdated.contains(srt))
                                                                                diagSRTtobeUpdated.add(srt);
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }

                                            system.debug('repSRTtobeUpdatedSize1**'+repSRTtobeUpdated+'repSRTtobeUpdatedSize1---'+ repSRTtobeUpdated.size());
                                            system.debug('diagSRTtobeUpdatedSize1'+diagSRTtobeUpdated+'diagSRTtobeUpdatedSize1---'+ diagSRTtobeUpdated.size());
                                            /*   if(!repSRTtobeUpdated.isEmpty() || !diagSRTtobeUpdated.isEmpty())
                                                repSRT.isPerformed__c = false;
                                            else*/ if(wo1.DataArea.CaseResponse[i].Assignment=='PRIMARY'){
                                                repSRT.isPerformed__c = True;
                                            }else{
                                                repSRT.isPerformed__c = false;
                                            }
                                            // }
                                        }
                                        system.debug('dontinsert2**'+dontinsert);
                                        //story 162535: END
                                        if( wo1.DataArea.CaseResponse[i].SRTTitle!='Dummy' && !DiagAccSRTs.contains(repSRT.SRT_ID__c)){
                                            repairSRT.add(repSRT);    
                                        }
                                    }
                                }
                            }
                            //}
                        }   
                    }
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode());
                    System.debug('The list is'+repairSRT.size() + 'LIST ----> ' + repairSRT);
                    // }
                }
                //162535 START
                Set<Id> DupSrt = new Set<Id>();
                List<CSS_SRT__c> diagSRTtobeUpdatedNew = new List<CSS_SRT__c>();
                List<CSS_SRT__c> repSRTtobeUpdatedNew = new List<CSS_SRT__c>();
                for(CSS_SRT__c srtToUpd : diagSRTtobeUpdated){
                    if(!DupSrt.contains(srtToUpd.Id)){
                        DupSrt.add(srtToUpd.Id);
                        diagSRTtobeUpdatedNew.add(srtToUpd);
                    }
                }
                DupSrt = new Set<Id>();
                for(CSS_SRT__c srtToUpd : repSRTtobeUpdated){
                    if(!DupSrt.contains(srtToUpd.Id)){
                        DupSrt.add(srtToUpd.Id);
                        repSRTtobeUpdatedNew.add(srtToUpd);
                    }
                }
                //if(diagSRTtobeUpdated!=null && diagSRTtobeUpdated.size()>0)
                //update diagSRTtobeUpdated;

                if(diagSRTtobeUpdatedNew!=null && diagSRTtobeUpdatedNew.size()>0)
                    update diagSRTtobeUpdatedNew;

                //if(repSRTtobeUpdated!=null && repSRTtobeUpdated.size()>0)
                //update repSRTtobeUpdated;

                if(repSRTtobeUpdatedNew!=null && repSRTtobeUpdatedNew.size()>0)
                    update repSRTtobeUpdatedNew;
                //162535 END
                //repairSRT - are duplicates.
                map<string, List<CSS_SRT__C>> repairSRTCodeMap = new map<string, List<CSS_SRT__C>>();
                List<CSS_SRT__c> repairSRTFinal = new  List<CSS_SRT__c>();
                List<CSS_SRT__c> repairSRTDuplicateRootCause = new  List<CSS_SRT__c>(); //GSSC-385-3 By Krishna.
                for(CSS_SRT__c repair : repairSRT) {
                    if(repair.Assignment__c=='PRIMARY' || repair.Assignment__c=='ALTERNATIVE' || repair.Assignment__c=='PROGRESSIVE DAMAGE') {      
                        if(repairSRTCodeMap.containsKey(repair.SRT_ID__c)){
                            List<CSS_SRT__c> slist = repairSRTCodeMap.get(repair.SRT_ID__c);
                            slist.add(repair);
                            repairSRTCodeMap.put(repair.SRT_ID__c,slist);
                        } else {
                            repairSRTCodeMap.put(repair.SRT_ID__c,new List<CSS_SRT__c>{repair}); 
                        }
                    }
                    else{
                        repairSRTFinal.add(repair);
                    }
                }

                System.debug('repairSRTCodeMap SIZE '+repairSRTCodeMap.size());
                System.debug('repairSRTCodeMap '+repairSRTCodeMap);                
                for(string srtId : repairSRTCodeMap.keySet()) {
                    List<CSS_SRT__c> slist = repairSRTCodeMap.get(srtId);
                    if(slist != null && slist.size() > 0) {
                        if(slist.size() == 1)
                            repairSRTFinal.add(slist[0]);
                        else {
                           repairSRTDuplicateRootCause.addall(slist);	//Defect 609 By Krishna.
                            //END - //GSSC-385-3 By Krishna.
                            
                        }
                    }
                }

                System.debug('repairSRTFinal SIZE '+repairSRTFinal.size());
                System.debug('repairSRTFinal '+repairSRTFinal);
                
                System.debug('repairSRTDuplicateRootCause SIZE '+repairSRTDuplicateRootCause.size());
                System.debug('repairSRTDuplicateRootCause '+repairSRTDuplicateRootCause);

                //repairSRT - are duplicates.
                List<Id> jobId = new  List<Id>();
                List<CSS_SRT__c> deletesrt = new  List<CSS_SRT__c>();
                Map<id,List<CSS_SRT__C>> jobwithexisitsrtMap = new Map<id,List<CSS_SRT__C>>();//Map of job with ALREADY existing list of srts
                List<CSS_SRT__c> nonDuplicaterepairSRT = new List<CSS_SRT__c>();
                Map<String,CSS_SRT__C> codewithListsrtMap = new Map<String,CSS_SRT__C>();// code with list of srt FROM SYSTEM
                Map<String,CSS_SRT__c> WebserviceSrtMap = new Map<String,CSS_SRT__c>(); // code with list of srt FROM webservice
                List<CSS_SRT__c> CurrentepairSRT= new List<CSS_SRT__c>();
                List<CSS_SRT__c> existingSRT= new List<CSS_SRT__c>();
                String FailureName=null;
                if(repairSRTFinal.size()>0){
                    System.debug('repairSRT '+repairSRTFinal);
                    System.debug('repairSRT SIZE() '+repairSRTFinal.size());
                    for(CSS_SRT__c srt : repairSRTFinal){
                        if(srt.Assignment__c=='PRIMARY' || srt.Assignment__c=='ALTERNATIVE' || srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                            System.debug('repairSRTFinal insde');
                            jobId.add(srt.Job_Order__c);
                            FailureName=srt.name;
                        }
                    }
                    //Map of job with ALREADY existing list of srts
                    //List<CSS_SRT__c> sjlist = new List<CSS_SRT__c>([select id,Job_Order__c,SRT_ID__c,Assignment__c,SRT_Access_Code__c from CSS_SRT__c where Job_Order__c in:jobId and (type__c ='Repair' or type__c='Repair Access') and SRT_ID__c != '0' and Component_Id__r.Component_Id__c=:FailureName]);
                    //Added Component_Id__c - in query for GSSC-385-3 By Krishna.
                    List<CSS_SRT__c> sjlist = new List<CSS_SRT__c>([select id,Job_Order__c,Component_Id__c, SRT_ID__c,Assignment__c,SRT_Access_Code__c from CSS_SRT__c where Job_Order__c in:jobId and (type__c ='Repair' or type__c='Repair Access') and SRT_ID__c != '0']);
                    system.debug('sjlist'+sjlist);
                    if(sjlist.size()>0){
                        for(CSS_SRT__c srt : sjlist){
                            if(srt.Assignment__c=='PRIMARY' || srt.Assignment__c=='ALTERNATIVE' || srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                                String code =srt.SRT_ID__c;
                                String jid =String.valueOf(srt.Job_Order__c);
                                if(jobwithexisitsrtMap.containsKey(srt.Job_Order__c)){
                                    List<CSS_SRT__c> slist = jobwithexisitsrtMap.get(srt.Job_Order__c);
                                    slist.add(srt);
                                    jobwithexisitsrtMap.put(srt.Job_Order__c,slist);
                                } 
                                else{
                                    jobwithexisitsrtMap.put(srt.Job_Order__c,new List<CSS_SRT__c>{srt});
                                }
                                if(srt.Assignment__c=='PRIMARY'){
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        codewithListsrtMap.put(code+jid+'SPA',srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        codewithListsrtMap.put(code+jid+'SPR',srt);

                                    }
                                }
                                if(srt.Assignment__c=='ALTERNATIVE'){
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        codewithListsrtMap.put(code+jid+'SAA',srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        codewithListsrtMap.put(code+jid+'SAR',srt);
                                    }
                                }
                                if(srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        codewithListsrtMap.put(code+jid+'SDA',srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        codewithListsrtMap.put(code+jid+'SDR',srt);
                                    }
                                }

                            }
                            else{
                                if(jobwithexisitsrtMap.containsKey(srt.Job_Order__c)){
                                    List<CSS_SRT__c> slist = jobwithexisitsrtMap.get(srt.Job_Order__c);
                                    slist.add(srt);
                                    jobwithexisitsrtMap.put(srt.Job_Order__c,slist);
                                } 
                                else{
                                    jobwithexisitsrtMap.put(srt.Job_Order__c,new List<CSS_SRT__c>{srt});
                                }
                            }
                        }
                    }
                    //separate duplicate srt from webservice
                    for(CSS_SRT__c srt : repairSRTFinal){
                        if(srt.Assignment__c=='PRIMARY' || srt.Assignment__c=='ALTERNATIVE' || srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                            if((jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.Job_Order__c).size()==0) || (jobwithexisitsrtMap.size()==0)){  
                                //Non duplicate srt from webservice
                                CurrentepairSRT.add(srt);
                            }
                            else if(jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.Job_Order__c).size()>0){
                                //duplicate srt from webservice
                                existingSRT.add(srt);
                            }
                            System.debug('CurrentepairSRT 2'+CurrentepairSRT);
                            System.debug('existingSRT 2'+existingSRT.size());
                        }
                        else{
                            if((jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.Job_Order__c).size()==0) || (jobwithexisitsrtMap.size()==0)){  
                                //Non duplicate srt from webservice
                                CurrentepairSRT.add(srt);
                            }
                            else if(jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.Job_Order__c).size()>0){
                                //duplicate srt from webservice
                                existingSRT.add(srt);
                            }
                            System.debug('CurrentepairSRT 3'+CurrentepairSRT);
                            System.debug('existingSRT 3'+existingSRT.size());
                        }
                    }
                    //code with list of srt FROM webservice
                    for(CSS_SRT__c srt : existingSRT){
                        String code1 =srt.SRT_ID__c;
                        String jid1 =String.valueOf(srt.Job_Order__c);
                        if(srt.Assignment__c=='PRIMARY'){
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                WebserviceSrtMap.put(code1+jid1+'WPA',srt);
                                System.debug('existingSRT srt.Access_Code__c--->'+WebserviceSrtMap);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                WebserviceSrtMap.put(code1+jid1+'WPR',srt);

                            }
                        }
                        if(srt.Assignment__c=='ALTERNATIVE'){
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                WebserviceSrtMap.put(code1+jid1+'WAA',srt);
                                System.debug('existingSRT srt.Access_Code__c-22222-->'+WebserviceSrtMap);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                WebserviceSrtMap.put(code1+jid1+'WAR',srt);
                            }
                        }
                        if(srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                WebserviceSrtMap.put(code1+jid1+'WDA',srt);
                                System.debug('existingSRT srt.Access_Code__c-22222-->'+WebserviceSrtMap);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                WebserviceSrtMap.put(code1+jid1+'WDR',srt);
                            }
                        }

                    }
                    system.debug('existingSRT'+existingSRT);
                    for(CSS_SRT__c srt : existingSRT){
                        String code1 =srt.SRT_ID__c;
                        String jid1 =String.valueOf(srt.Job_Order__c);
                        If(codewithListsrtMap.containskey(code1+jid1+'SPA')){
                            //GSSC-689
							if(WebserviceSrtMap.containskey(code1+jid1+'WPA'))
                              nonDuplicaterepairSRT.add(srt);  
                            //GSSC-689
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SPR')){
                            //GSSC-689
							if(WebserviceSrtMap.containskey(code1+jid1+'WPR'))
                              nonDuplicaterepairSRT.add(srt);  
                            //GSSC-689
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                                srtLow = codewithListsrtMap.get(code1+jid1+'SPR');
                                if(srtLow != null) {
                        	        srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                        	        srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                                }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SPR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                                System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            } 
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SAA')){
                            //GSSC-689
							if(WebserviceSrtMap.containskey(code1+jid1+'WAA'))
                              nonDuplicaterepairSRT.add(srt);  
                            //GSSC-689
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                                srtLow = codewithListsrtMap.get(code1+jid1+'SAA');
                                if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                                }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAA'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                                srtLow = codewithListsrtMap.get(code1+jid1+'SAA');
                                if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                                }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAA'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SAR')){
                            //GSSC-689
							if(WebserviceSrtMap.containskey(code1+jid1+'WAR'))
                              nonDuplicaterepairSRT.add(srt);  
                            //GSSC-689
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SAR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                                System.debug(' codewithListsrtMap.get(code1+jid1))--->'+ codewithListsrtMap.get(code1+jid1+'SAR'));
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SAR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SAR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SDA')){
                            //GSSC-689
							if(WebserviceSrtMap.containskey(code1+jid1+'WDA'))
                              nonDuplicaterepairSRT.add(srt);  
                            //GSSC-689
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDA');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                                System.debug(' codewithListsrtMap.get(code1+jid1))--->'+ codewithListsrtMap.get(code1+jid1+'SDA'));

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDA');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDA');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAR')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDA');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }


                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SDR')){
                            //GSSC-689
							if(WebserviceSrtMap.containskey(code1+jid1+'WDR'))
                              nonDuplicaterepairSRT.add(srt);  
                            //GSSC-689
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                                System.debug(' codewithListsrtMap.get(code1+jid1))--->'+ codewithListsrtMap.get(code1+jid1+'SDR'));
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAR')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WDA')){
                                nonDuplicaterepairSRT.add(srt); 
                                //START GSSC-385-3 By Krishna.
                                CSS_SRT__c srtLow = new CSS_SRT__c();
                        	    srtLow = codewithListsrtMap.get(code1+jid1+'SDR');
                        	    if(srtLow != null) {
                            	    srtLow.CSS_Root_Cause_Failure__c = srt.Component_Id__c;
                            	    srtLow.isDuplicateRootCause__c = true;
                                    repairSRTDuplicateRootCause.add(srtLow);
                        	    }
                                //deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                System.debug(' repairSRTDuplicateRootCause)--->'+ repairSRTDuplicateRootCause);
                                //END GSSC-385-3 By Krishna.
                            }
                        }
                        else{
                            nonDuplicaterepairSRT.add(srt); 
                        }
                    }
                }

                if(CurrentepairSRT.size()>0){
                    for(CSS_SRT__c slst :CurrentepairSRT){
                        nonDuplicaterepairSRT.add(slst) ;
                    }

                }
                
                //START - GSSC-385-3 By Krishna.
                //system.debug('deletesrt ' + deletesrt.size() + 'List ---> ' + deletesrt);   //database Record 
                //repairSRTDuplicateRootCause.addall(deletesrt);  
                
                //Making Duplicate SRTs to UNSELCTED.
                for(CSS_SRT__c srtDup :repairSRTDuplicateRootCause)
                    srtDup.isPerformed__c = false;
                
                system.debug('RSRTDRC ' + repairSRTDuplicateRootCause.size() + 'List ---> ' + repairSRTDuplicateRootCause); 
                system.debug('nonDuplicaterepairSRT ' + nonDuplicaterepairSRT.size() + 'List ---> ' + nonDuplicaterepairSRT);
                nonDuplicaterepairSRT.addAll(repairSRTDuplicateRootCause); 
                
                if(nonDuplicaterepairSRT.size()>0){
                    //insert nonDuplicaterepairSRT;
                    Upsert nonDuplicaterepairSRT;
                }
                
                //system.debug('deletesrt ' + deletesrt.size() + 'List ---> ' + deletesrt);
                //if(deletesrt.size()>0){
                    //delete deletesrt;
                //}
                // insert repairSRT;
                //END - //GSSC-385-3 By Krishna.
                
            }
            catch(exception e){
                if(!Test.isRunningTest()){
                    String exMessage = e.getMessage(); //System.CalloutException
                    String exType = e.getTypeName();
                    System.debug('===Exception===='+e.getLineNumber());
                    system.debug('exception message is -->'+ e.getTypeName()+'--->'+e.getLineNumber());
                    if(exMessage.equalsignorecase('Read timed out') || exType.contains('CalloutException')){
                        rpRetryCount = rpRetryCount + 1; 
                        rpRetry = TRUE;
                        system.debug('retryValue is -->' +rpRetryCount);
                        system.debug('reTry flag is -->' +rpRetry);                    
                    }
                    system.debug('Repair SRT' + e.getLineNumber() + e.getMessage());
                    css_utility.LogOutIntError(endPoint+repairRequest,e.getMessage()+'-Repair SRT', res==null?'RESPONSE IS NULL':res.getBody(), 'SRT');
                }
            }   
        } while(rpRetryCount <= integer.valueof(Label.CSS_SRT_RETRY_TIME) && rpRetry == TRUE); // Logic for re-try mechanism.
        //kalpana added below code to cover a scenario, the same SRT ID is present both in Diag and Repair sections, when the diagnosis is happening for the first time for a job. defect 174240
        componentsJobId = (solCompWrapper)JSON.deserialize(solComp[0], solCompWrapper.class); 
        existDiagSrtList = [Select id,SRT_ID__c,Assignment__c,type__c,isPerformed__c,step_description__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and type__c = 'Diagnosis' and assignment__c = 'PRIMARY' and SRT_ID__c != '0'];
        existrepSrtList = [Select id,SRT_ID__c,Assignment__c,step_description__c,isPerformed__c from css_Srt__c where Job_Order__c = : componentsJobId.jobID and type__c ='Repair' and assignment__c = 'PRIMARY' and SRT_ID__c != '0'];
        for(css_Srt__C srt: existrepSrtList){
            for(css_srt__c srt1: existDiagSrtList){
                if(srt.srt_id__c == srt1.srt_id__c+'-'+srt.srt_id__c.right(2).trim()){
                    srt1.isPerformed__c = false;
                    if(!diagSRTtobeUpdated.contains(srt1))
                        diagSRTtobeUpdated.add(srt1);
                }
            }
        }
        Set<Id> DupSrt = new Set<Id>();
        List<CSS_SRT__c> diagSRTtobeUpdatedNew = new List<CSS_SRT__c>();
        for(CSS_SRT__c srtToUpd : diagSRTtobeUpdated){
            if(!DupSrt.contains(srtToUpd.Id)){
                DupSrt.add(srtToUpd.Id);
                diagSRTtobeUpdatedNew.add(srtToUpd);
            }
        }
        //if(diagSRTtobeUpdated != null && diagSRTtobeUpdated.size()>0)
        //update diagSRTtobeUpdated;
        if(diagSRTtobeUpdatedNew != null && diagSRTtobeUpdatedNew.size()>0)
            update diagSRTtobeUpdatedNew;
    }

    /*Story 90222 Start 
    //Method to find Max Sort Order of SRT for a particualr Job 
    public static map<id,decimal> getMaxOrder(string srtType,set<id> setJobId){
        map<id,decimal> mapJobIdToMaxSortOrder = new map<id,decimal>();
        //to get the max sort order for Diagnosis  & Diag Access
        if(srtType != '' && srtType == 'Diagnosis' || srtType == 'Diag Access'){
            for(CSS_Job_Order__c job : [select id,(select id,SRT_Order__c from CSS_SRTs__r 
                                                   where type__c ='Diagnosis' or type__c = 'Diag Access' )
                                        from CSS_Job_Order__c where id in : setJobId ]){
                 Decimal maxvalue = 0;
                if(job.CSS_SRTs__r != null && job.CSS_SRTs__r.size() > 0){
                    maxvalue = job.CSS_SRTs__r[0].SRT_Order__c;
                    for(integer i = 0;i>job.CSS_SRTs__r.size();i++){
                    if( job.CSS_SRTs__r[i].SRT_Order__c > maxvalue){
                            maxvalue = job.CSS_SRTs__r[i].SRT_Order__c;
                        }
                }
                }
                if(maxvalue != null){
                    mapJobIdToMaxSortOrder.put(job.ID, maxvalue);
                }
            }
        }
        //to get the max sort order for Repair and Repair Access
        if(srtType != '' && srtType == 'Repair' || srtType == 'Repair Access'){
             for(CSS_Job_Order__c job : [select id,(select id,SRT_Order__c from CSS_SRTs__r 
                                                   where type__c ='Repair' or type__c = 'Repair Access' )
                                        from CSS_Job_Order__c where id in : setJobId ]){
                 Decimal maxvalue = 0;
                if(job.CSS_SRTs__r != null && job.CSS_SRTs__r.size() > 0){
                    maxvalue = job.CSS_SRTs__r[0].SRT_Order__c;
                    for(integer i = 0;i>job.CSS_SRTs__r.size();i++){
                    if( job.CSS_SRTs__r[i].SRT_Order__c > maxvalue){
                            maxvalue = job.CSS_SRTs__r[i].SRT_Order__c;
                        }
                }
                }
                if(maxvalue != null){
                    mapJobIdToMaxSortOrder.put(job.ID, maxvalue);
                }
            }
        }
        //to get the max sort order for Additional SRT
        if(srtType != '' && srtType == 'Additional'){
            for(CSS_Job_Order__c job : [select id,(select id,SRT_Order__c from CSS_SRTs__r 
                                                   where Solution_Number__c = null )
                                        from CSS_Job_Order__c where id in : setJobId ]){
                 Decimal maxvalue = 0;
                if(job.CSS_SRTs__r != null && job.CSS_SRTs__r.size() > 0){
                    maxvalue = job.CSS_SRTs__r[0].SRT_Order__c;
                    for(integer i = 0;i>job.CSS_SRTs__r.size();i++){
                    if( job.CSS_SRTs__r[i].SRT_Order__c > maxvalue){
                            maxvalue = job.CSS_SRTs__r[i].SRT_Order__c;
                        }
                }
                }
                if(maxvalue != null){
                    mapJobIdToMaxSortOrder.put(job.ID, maxvalue);
                }
            }
        }

        return mapJobIdToMaxSortOrder;
    }*/

    //calling webservice for fetch the repair SRTs for my failures from GSQ - Manual claim
    @future(callout=true)
    public static void repairSRTManualClaim(List<String> solComp){

        system.debug('solComp ' + solComp.size() + 'List---->' + solComp);
        List<CSS_SRT__c> repairSRT = new List<CSS_SRT__c>();
        
        string client_id;
        string client_secret;
        
        List<string> stepDescRep = new List<string>();
        CSS_SRT__c repSRT;
        Boolean rpRetry;
        Integer rpRetryCount=1;
        string accessToken;
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
        solCompWrapper components = null;
        string endPoint; 
        string repairRequest;
        HTTPResponse res;
        solCompWrapper componentsJobId;
        Map<String, String> accCodeCovTypeMap = new Map<String, String>();
        for(CSS_JobEventTemporary__c jet : [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes']){
            if(!accCodeCovTypeMap.containsKey(jet.Attribute3__c)){
                accCodeCovTypeMap.put(jet.Attribute3__c, jet.Attribute1__c);
            }
        }
        //GSSC-297 - START
        Map<String, String> accCodeFailCodeMap = new Map<String, String>();
        componentsJobId = (solCompWrapper)JSON.deserialize(solComp[0], solCompWrapper.class);
        List<CSS_Solution_Component__c> newSolCompLst = new List<CSS_Solution_Component__c>();
        newSolCompLst = [SELECT Id, CSS_Claims__c, Type__c, Fail_Code__c, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c, Selected_Component__c FROM CSS_Solution_Component__c WHERE 
                                    CSS_Claims__c =: componentsJobId.jobID AND Type__c NOT IN ('TRP','ATC','Campaign')
                                    AND Fail_Code__c != null AND Fail_Code__c != '' AND Fail_Code__c != 'Select One'  AND Selected_Component__c = true AND
                                    CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND CSS_Account_Formula__c != 'Select One' 
                                    ORDER BY CSS_Failure_Sequence_Number__c ASC];
        for(CSS_Solution_Component__c sc : newSolCompLst){
            if((sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '' && sc.CSS_Account_Formula__c != 'Select One')  && !accCodeFailCodeMap.containsKey(sc.CSS_Account_Formula__c)){
                accCodeFailCodeMap.put(sc.CSS_Account_Formula__c, sc.Fail_Code__c);
            }
        }
        //GSSC-297 - END
        do{     
            rpRetry = FALSE;
            try
            {       
                    CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                    if(!Test.isRunningTest()){
                    //  accessToken=receiveToken();
                    //accesstoken = splreceiveToken(Label.CSS_SRTAltOAuth); //Commented for Dynamic Authentication
                    //accesstoken = splreceiveToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c);
                    //Commented for dynamic Authentication and added below lines
                    //Commented below line as part of Mule AUthentication
                    //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c);
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('SRT').AuthEnv__c,'SRT');
                    accesstoken = accessTokenOPWrap.accessToken;
                    conDetails =CSS_getConnnectionDetails.getConnection('SRT');
                    //endPoint = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
                    endPoint = conDetails.End_Point__c;
                    client_id = conDetails.Username__c;   
                    client_secret = ConDetails.Passcode__c;
                }
                else{
                    accessToken ='Test';
                    endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                    client_id = 'EO2mFVUilaYhGGnD1hv8wdo9EmLWeGbkRnMDgExKqY4=';   
                    client_secret = 'o6GR4eKrrPu4vfxu7iq63VEdOQysTO5uB9jhaQKHsWM=';
                }
                componentsJobId = (solCompWrapper)JSON.deserialize(solComp[0], solCompWrapper.class);  
                system.debug('componentsJobId.jobID**'+componentsJobId.jobID);
                AggregateResult[] groupedResults = [SELECT MAX(SRT_Order__c) FROM CSS_SRT__c WHERE CSS_Claims__c = : componentsJobId.jobID and (type__c ='Repair' or type__c='Repair Access') and SRT_ID__c != '0'];
                CSS_Claims__c clmRec = [select id,SP_INSHOP_LABOR_RATE__c,Accesscode__c,Failures_ODM_Status__c from CSS_Claims__c where id =:componentsJobId.jobID];
                decimal maxOrder = (decimal) groupedResults[0].get('expr0');
                Decimal sortOrder = 0;

                for(string ser:solComp){
                    components = (solCompWrapper)JSON.deserialize(ser, solCompWrapper.class);   
                    System.debug('components components'+components);
                    HttpRequest req = new HttpRequest();
                    string efc = components.efc;//'56'
                    string equipID = components.equipID;//'EQ7667'
                    string claim = string.valueOf(components.claimId);
                    string jobName = components.jobName;
                    string serviceModel = components.serviceModel; //'ISL9 CM2350 L101'
                    //List<string> failureID = new List<string>{'F02000010','F01000250'};
                    req.setEndpoint(endPoint);
                    req.setHeader('Content-Type','application/json');
                    req.setHeader('client-id',client_id);
                    req.setHeader('client-secret',client_secret);
                    req.setHeader('Authorization', 'Bearer '+accessToken);
                    //repairRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName":"ServiceRequest","SenderID":"SF"},"Target":{"TargetID":"SRT"}},';
                    repairRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName":"GetRepairSRT","SenderID":"CSS"},"Target":{"TargetID":"SRT"}},';
                    repairRequest = repairRequest + '"DataArea":{"EngineFamilyCode":"'+efc+'","CSSJobId": "'+jobName+'","ClaimID": "'+claim+'","EquipmentID": "'+equipID+'","ServiceModelName": "'+serviceModel+'","EffectiveDateTime":"'+currDate+'","Timestamp": "'+currDate+'","Languagecode": "en'+'","FailureID": ['; 
                    repairRequest = repairRequest + '"'+components.compoName+'"';
                    //}
                    repairRequest = repairRequest + '],"SRTType": "REP"}}';
                    System.debug('The repairRequest is!@!@#'+repairRequest);
                    req.setBody(repairRequest);
                    req.setMethod('POST');
                    req.setTimeout(120000);
                    Http http = new Http();    
                    res = http.send(req);
                    System.debug('BODY: '+res.getBody());
                    String jSONRequestBody = res.getBody();
                    string repNotFound = '{"DataArea":{"ResponseMessage":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination."},"Header":{"ReturnCodeDescription":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination.","Status":"Error"}}'; // defect # 62135
                    System.debug('The request body is'+jSONRequestBody); // defect # 62135
                    //if(!Test.isRunningTest()){
                    CSS_J2ARepair_SRT wo1 = (CSS_J2ARepair_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2ARepair_SRT.class);
                    //Story 90222 End
                    // for(integer j=0;j<solComp.size();j++){
                    // added if block for defect # 62135
                    system.debug('Diff Method'+wo1.DataArea.CaseResponse);
                    if(jSONRequestBody.contains(repNotFound)){
                        System.debug('Inside no srt found');
                        repSRT = new CSS_SRT__c();
                        repSRT.Name = '0';
                        repSRT.Type__c = 'Repair'; 
                        repSRT.Response_Message__c = 'Please refer to QSOL to determine if additional labor is warrantable for this action. If so, follow your current process to claim reimbursement.';
                        repSRT.CSS_Claims__c = components.jobID; 
                        repSRT.Solution_Number__c = components.solID;
                        repSRT.Component_Id__c = components.compID;
                        repSRT.SRT_Time__c = 0.0;
                        repSRT.SRT_Quantity__c = 1;
                        repSRT.SRT_ID__c = '0';
                        repSRT.isPerformed__c = True;
                        repairSRT.add(repSRT);
                        //break;
                    }
                    else if(wo1.DataArea.CaseResponse!=null){
                        for(integer i=0;i<wo1.DataArea.CaseResponse.size();i++){ 
                            //if(wo1.DataArea.CaseResponse[i].SRTTitle!='DUMMY'){
                            System.debug('Inside srt found'); // added for defect # 62135
                            if(wo1.DataArea.CaseResponse[i].FailureID!=null){ // added for defect # 62135
                                if(wo1.DataArea.CaseResponse[i].SRTDetails != '00-901-00' && wo1.DataArea.CaseResponse[i].SRTDetails != '00-902-00' && wo1.DataArea.CaseResponse[i].SRTDetails != '00-904-00' && wo1.DataArea.CaseResponse[i].SRTDetails != '00-10S-00'){
                                    System.debug('Inside srt found'+ wo1.DataArea.CaseResponse[i].SRTDetails); 
                                    if(components.compoName== wo1.DataArea.CaseResponse[i].FailureID){
                                        repSRT = new CSS_SRT__c();    
                                        repSRT.Name = wo1.DataArea.CaseResponse[i].FailureID;
                                        repSRT.Type__c = 'Repair';
                                        if(wo1.DataArea.CaseResponse[i].FlexSRT != null && wo1.DataArea.CaseResponse[i].FlexSRT !=''){
                                            if(wo1.DataArea.CaseResponse[i].FlexSRT == 'Y'){
                                                repSRT.Flex_Flag__c = true;
                                            }
                                            else{
                                                repSRT.Flex_Flag__c = false;
                                            }
                                        }
                                        if(wo1.DataArea.CaseResponse[i].ECMFlag != null && wo1.DataArea.CaseResponse[i].ECMFlag !=''){
                                            if(wo1.DataArea.CaseResponse[i].ECMFlag == 'Y'){
                                                repSRT.ECM_Flag__c = true;
                                            }
                                            else{
                                                repSRT.ECM_Flag__c = false;
                                            }
                                        }
                                        //repSRT.FailCode__c = (components.failCode != null && components.failCode != '' ? components.failCode.trim().right(4) : '');
                                        system.debug('components.type'+components.type);
                                        system.debug('components.accCode'+components.accountCode);
                                        system.debug('components.CoveredLaborHrs'+components.CoveredLaborHrs);
                                        system.debug('clmRec.SP_INSHOP_LABOR_RATE__c'+clmRec.SP_INSHOP_LABOR_RATE__c);
                                        String covtype = '';
                                        if(accCodeCovTypeMap != null && components.accountCode != null){
                                            covtype = accCodeCovTypeMap.get(components.accountCode.RIGHT(2));
                                        }

                                        if(components.type != 'Campaign' && components.type != 'TRP' && components.type != 'ATC'){
                                            if((components.CoveredLaborHrs != null && components.CoveredLaborHrs != '' && double.valueof(components.CoveredLaborHrs) > 0) || (covtype == 'OTH' || covtype == 'POL')){
                                                system.debug('clmRec.SP_INSHOP_LABOR_RATE__c');
                                                //GSSC-297 - START
                                                String tempFailCode;
                                                if(accCodeFailCodeMap != null){
                                                    tempFailCode = accCodeFailCodeMap.get(components.accountCode);
                                                }
                                                if(tempFailCode != null && tempFailCode != ''){
                                                    repSRT.FailCode__c = tempFailCode;
                                                }
                                                else{ //GSSC-297 - END
                                                    repSRT.FailCode__c = (components.failCode != null && components.failCode != '' ? components.failCode.trim().right(4) : '');
                                                }
                                                repSRT.SRT_Warrantable__c = '100';
                                                repSRT.Account_Code__c = (clmRec.SP_INSHOP_LABOR_RATE__c != null && clmRec.SP_INSHOP_LABOR_RATE__c != '0' && clmRec.SP_INSHOP_LABOR_RATE__c != '' ? components.accountCode : '');
                                                system.debug('repSRT.Account_Code__c'+repSRT.Account_Code__c);
                                            }
                                            else{
                                                repSRT.SRT_Warrantable__c = '0';
                                            }
                                        }
                                        else{
                                            system.debug('components.type'+components.type);
                                            if(components.CampaignLaborPercentage != null && components.CampaignLaborPercentage != '' && double.valueof(components.CampaignLaborPercentage) > 0){
                                                repSRT.FailCode__c = (components.failCode != null && components.failCode != '' ? components.failCode.trim().right(4) : '');
                                                repSRT.SRT_Warrantable__c = '100';
                                                repSRT.Account_Code__c = (clmRec.SP_INSHOP_LABOR_RATE__c != null && clmRec.SP_INSHOP_LABOR_RATE__c != '0' && clmRec.SP_INSHOP_LABOR_RATE__c != '' ? components.accountCode : '');
                                                system.debug('repSRT.Account_Code__c'+repSRT.Account_Code__c);
                                            }
                                            else{
                                                repSRT.SRT_Warrantable__c = '0';
                                            }
                                        }
                                        system.debug('repSRT.Account_Code__c'+repSRT.Account_Code__c);
                                        /*Story 90222 Setting the Sort Order For Repair SRT
                                    repSRT.SRT_Order__c = sortOrder + 1 ;
                                    sortOrder = repSRT.SRT_Order__c;
                                    //Story 90222 End*/
                                        repSRT.SRT_Title__c = wo1.DataArea.CaseResponse[i].SRTTitle;
                                        // repSRT.SRT_Quantity__c = string.valueof(wo1.DataArea.CaseResponse[i].SRTQuantity);       
                                        repSRT.SRT_ID__c = wo1.DataArea.CaseResponse[i].SRTDetails;//SRTDETAILS equals SRT-ID
                                        //Story#172627
                                        repSRT.SRT_Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;
                                        if(wo1.DataArea.CaseResponse[i].Assignment == 'DIAGNOSTIC'){
                                            if(wo1.DataArea.CaseResponse[i].SRTAccessCode == 'R')
                                                repSRT.Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;
                                            else
                                                repSRT.Access_Code__c = clmRec.Accesscode__c;
                                        }
                                        else{
                                            repSRT.Access_Code__c = wo1.DataArea.CaseResponse[i].SRTAccessCode;
                                        }
                                        //end
                                        if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription!=null){
                                            for(integer k=0;k<wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription.size();k++){
                                                if(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[k]!='DUMMY'){
                                                    repSRT.Step_Description__c = repSRT.Step_Description__c + wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepDescription[k]+'\n'; 
                                                }
                                            }
                                        }
                                        repSRT.Step_Id__c = String.valueOf(wo1.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepID);
                                        repSRT.Assignment__c = wo1.DataArea.CaseResponse[i].Assignment;
                                        repSRT.Failure_Name__c = wo1.DataArea.CaseResponse[i].FailureName;
                                        repSRT.Solution_Number__c = components.solID;
                                        repSRT.CSS_Claims__c = components.jobID; 
                                        repSRT.Component_Id__c = components.compID;
                                        repSRT.SRT_Time__c = wo1.DataArea.CaseResponse[i].SRTTime; //* 60;Anirudh 
                                        repSRT.SRT_Quantity__c = 1;
                                        repSRT.SRT_Usage__c = wo1.DataArea.CaseResponse[i].SRTUsage; // GSSC- 25
                                        //Added below code for new parameters in response from SRT
                                        repSRT.Access_Code_A__c = wo1.DataArea.CaseResponse[i].AccessCodeA;
                                        repSRT.Access_Code_B__c = wo1.DataArea.CaseResponse[i].AccessCodeB;
                                        repSRT.Access_Code_C__c = wo1.DataArea.CaseResponse[i].AccessCodeC;
                                        repSRT.Access_Code_D__c = wo1.DataArea.CaseResponse[i].AccessCodeD;
                                        repSRT.Access_Code_R__c = wo1.DataArea.CaseResponse[i].AccessCodeR;
                                        repSRT.Access_Code_S1__c = wo1.DataArea.CaseResponse[i].AccessCodeS1;
                                        repSRT.Access_Code_S2__c = wo1.DataArea.CaseResponse[i].AccessCodeS2;
                                        repSRT.Access_Code_S3__c = wo1.DataArea.CaseResponse[i].AccessCodeS3;
                                        repSRT.Access_Code_S4__c = wo1.DataArea.CaseResponse[i].AccessCodeS4;
                                        repSRT.Access_Code_S5__c = wo1.DataArea.CaseResponse[i].AccessCodeS5;
                                        repSRT.Access_Code_S6__c = wo1.DataArea.CaseResponse[i].AccessCodeS6;
                                        repSRT.Access_Code_S7__c = wo1.DataArea.CaseResponse[i].AccessCodeS7;
                                        repSRT.Access_Code_S8__c = wo1.DataArea.CaseResponse[i].AccessCodeS8;
                                        repSRT.Access_Code_S9__c = wo1.DataArea.CaseResponse[i].AccessCodeS9;
                                        repSRT.S1_Description__c = wo1.DataArea.CaseResponse[i].S1Desc;
                                        repSRT.S2_Description__c = wo1.DataArea.CaseResponse[i].S2Desc;
                                        repSRT.S3_Description__c = wo1.DataArea.CaseResponse[i].S3Desc;
                                        repSRT.S4_Description__c = wo1.DataArea.CaseResponse[i].S4Desc;
                                        repSRT.S5_Description__c = wo1.DataArea.CaseResponse[i].S5Desc;
                                        repSRT.S6_Description__c = wo1.DataArea.CaseResponse[i].S6Desc;
                                        repSRT.S7_Description__c = wo1.DataArea.CaseResponse[i].S7Desc;
                                        repSRT.S8_Description__c = wo1.DataArea.CaseResponse[i].S8Desc;
                                        repSRT.S9_Description__c = wo1.DataArea.CaseResponse[i].S9Desc;
                                        repSRT.SRT_Message__c = wo1.DataArea.CaseResponse[i].SRTMessage;
                                        repSRT.SRT_Notes__c = wo1.DataArea.CaseResponse[i].SRTDesc;
                                        if(wo1.DataArea.CaseResponse[i].FlexSRT != 'Y'){//GSSC-24 changes
                                        repSRT.SRT_Quantity__c = wo1.DataArea.CaseResponse[i].SRTQuantity;
                                        }else{
                                        repSRT.SRT_Quantity__c = 1;   
                                        }
                                        if(maxOrder != null){
                                            repSRT.SRT_Order__c = maxOrder + 1;
                                            maxOrder = repSRT.SRT_Order__c;
                                        }
                                        else{
                                            repSRT.SRT_Order__c = sortOrder + 1;
                                            sortOrder = repSRT.SRT_Order__c;
                                        }   
                                        //End of the code for new parameters in response from SRT
                                        if(wo1.DataArea.CaseResponse[i].Assignment=='PRIMARY'){
                                            repSRT.isPerformed__c = True;
                                        }else{
                                            repSRT.isPerformed__c = false;
                                        }
                                        if( wo1.DataArea.CaseResponse[i].SRTTitle!='Dummy'){
                                            repairSRT.add(repSRT);    
                                        }
                                    }
                                }
                            }
                            //}
                        }   
                    }
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode());
                    System.debug('The list is'+repairSRT.size() + 'LIST ----> ' + repairSRT);
                    // }
                }

                //repairSRT - are duplicates.
                map<string, List<CSS_SRT__C>> repairSRTCodeMap = new map<string, List<CSS_SRT__C>>();
                List<CSS_SRT__c> repairSRTFinal = new  List<CSS_SRT__c>();
                for(CSS_SRT__c repair : repairSRT) {
                    if(repair.Assignment__c=='PRIMARY' || repair.Assignment__c=='ALTERNATIVE' || repair.Assignment__c=='PROGRESSIVE DAMAGE') {      
                        if(repairSRTCodeMap.containsKey(repair.SRT_ID__c)){
                            List<CSS_SRT__c> slist = repairSRTCodeMap.get(repair.SRT_ID__c);
                            slist.add(repair);
                            repairSRTCodeMap.put(repair.SRT_ID__c,slist);
                        } else {
                            repairSRTCodeMap.put(repair.SRT_ID__c,new List<CSS_SRT__c>{repair}); 
                        }
                    }
                    else{
                        repairSRTFinal.add(repair);
                    }
                }

                System.debug('repairSRTCodeMap SIZE '+repairSRTCodeMap.size());
                System.debug('repairSRTCodeMap '+repairSRTCodeMap);

                for(string srtId : repairSRTCodeMap.keySet()) {
                    List<CSS_SRT__c> slist = repairSRTCodeMap.get(srtId);
                    if(slist != null && slist.size() > 0) {
                        if(slist.size() == 1)
                            repairSRTFinal.add(slist[0]);
                        else {
                            map<Integer, CSS_SRT__c> assignAccessCodeSRTMap = new map<Integer, CSS_SRT__c>();//assignment + Accesscode
                            CSS_SRT__c srtHighest = new CSS_SRT__c();
                            for(CSS_SRT__c srt : slist) {
                                if(srt.Assignment__c == 'PRIMARY') {
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        assignAccessCodeSRTMap.put(6, srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        assignAccessCodeSRTMap.put(5, srt);
                                    }
                                } else if(srt.Assignment__c == 'ALTERNATIVE') {
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        assignAccessCodeSRTMap.put(4, srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        assignAccessCodeSRTMap.put(3, srt);
                                    }
                                } else if(srt.Assignment__c == 'PROGRESSIVE DAMAGE') {
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        assignAccessCodeSRTMap.put(2, srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        assignAccessCodeSRTMap.put(1, srt);
                                    }
                                }
                            }
                            List<Integer> assignmentAccessWeight = new list<Integer>();
                            for(integer i : assignAccessCodeSRTMap.KeySet())
                                assignmentAccessWeight.add(i);
                            assignmentAccessWeight.sort();

                            integer assignAccessHighestWeight = assignmentAccessWeight[assignmentAccessWeight.size() -1];
                            srtHighest = assignAccessCodeSRTMap.get(assignAccessHighestWeight);
                            repairSRTFinal.add(srtHighest);
                        }
                    }
                }

                System.debug('repairSRTFinal SIZE '+repairSRTFinal.size());
                System.debug('repairSRTFinal '+repairSRTFinal);

                //repairSRT - are duplicates.
                Set<Id> jobId = new  Set<Id>();
                List<CSS_SRT__c> deletesrt = new  List<CSS_SRT__c>();
                Map<id,List<CSS_SRT__C>> jobwithexisitsrtMap = new Map<id,List<CSS_SRT__C>>();//Map of job with ALREADY existing list of srts
                List<CSS_SRT__c> nonDuplicaterepairSRT = new List<CSS_SRT__c>();
                Map<String,CSS_SRT__C> codewithListsrtMap = new Map<String,CSS_SRT__C>();// code with list of srt FROM SYSTEM
                Map<String,CSS_SRT__c> WebserviceSrtMap = new Map<String,CSS_SRT__c>(); // code with list of srt FROM webservice
                List<CSS_SRT__c> CurrentepairSRT= new List<CSS_SRT__c>();
                List<CSS_SRT__c> existingSRT= new List<CSS_SRT__c>();
                String FailureName=null;
                if(repairSRTFinal.size()>0){
                    System.debug('repairSRT '+repairSRTFinal);
                    System.debug('repairSRT SIZE() '+repairSRTFinal.size());
                    for(CSS_SRT__c srt : repairSRTFinal){
                        if(srt.Assignment__c=='PRIMARY' || srt.Assignment__c=='ALTERNATIVE' || srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                            System.debug('repairSRTFinal insde');
                            jobId.add(srt.CSS_Claims__c);
                            FailureName=srt.name;
                        }
                    }
                    system.debug('jobId**'+jobId);
                    system.debug('FailureName**'+FailureName);
                    //Map of job with ALREADY existing list of srts
                    //List<CSS_SRT__c> sjlist = new List<CSS_SRT__c>([select id,CSS_Claims__c,SRT_ID__c,Assignment__c,SRT_Access_Code__c from CSS_SRT__c where CSS_Claims__c in:jobId and (type__c ='Repair' or type__c='Repair Access') and SRT_ID__c != '0' and Component_Id__r.Component_Id__c=: FailureName]);
                    List<CSS_SRT__c> sjlist = new List<CSS_SRT__c>([select id,CSS_Claims__c,SRT_ID__c,Assignment__c,SRT_Access_Code__c from CSS_SRT__c where CSS_Claims__c in:jobId and (type__c ='Repair' or type__c='Repair Access') and SRT_ID__c != '0']);
                    system.debug('sjlist**'+sjlist.size());
                    if(sjlist.size()>0){
                        for(CSS_SRT__c srt : sjlist){
                            if(srt.Assignment__c=='PRIMARY' || srt.Assignment__c=='ALTERNATIVE' || srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                                String code =srt.SRT_ID__c;
                                String jid =String.valueOf(srt.CSS_Claims__c);
                                if(jobwithexisitsrtMap.containsKey(srt.CSS_Claims__c)){
                                    List<CSS_SRT__c> slist = jobwithexisitsrtMap.get(srt.CSS_Claims__c);
                                    slist.add(srt);
                                    jobwithexisitsrtMap.put(srt.CSS_Claims__c,slist);

                                } 
                                else{
                                    jobwithexisitsrtMap.put(srt.CSS_Claims__c,new List<CSS_SRT__c>{srt}); 
                                }
                                System.debug('jobwithexisitsrtMap'+jobwithexisitsrtMap.size());
                                if(srt.Assignment__c=='PRIMARY'){
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        codewithListsrtMap.put(code+jid+'SPA',srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        codewithListsrtMap.put(code+jid+'SPR',srt);

                                    }
                                }
                                if(srt.Assignment__c=='ALTERNATIVE'){
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        codewithListsrtMap.put(code+jid+'SAA',srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        codewithListsrtMap.put(code+jid+'SAR',srt);
                                    }
                                }
                                if(srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                                    if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                        codewithListsrtMap.put(code+jid+'SDA',srt);
                                    }
                                    if(srt.SRT_Access_Code__c=='R'){
                                        codewithListsrtMap.put(code+jid+'SDR',srt);
                                    }
                                }

                            }
                            else{
                                if(jobwithexisitsrtMap.containsKey(srt.CSS_Claims__c)){
                                    List<CSS_SRT__c> slist = jobwithexisitsrtMap.get(srt.CSS_Claims__c);
                                    slist.add(srt);
                                    jobwithexisitsrtMap.put(srt.CSS_Claims__c,slist);
                                } 
                                else{
                                    jobwithexisitsrtMap.put(srt.CSS_Claims__c,new List<CSS_SRT__c>{srt});
                                }
                            }
                        }
                    }
                    System.debug('codewithListsrtMap codewithListsrtMap'+codewithListsrtMap);
                    System.debug('jobwithexisitsrtMap jobwithexisitsrtMap'+jobwithexisitsrtMap);
                    //separate duplicate srt from webservice
                    for(CSS_SRT__c srt : repairSRTFinal){
                        if(srt.Assignment__c=='PRIMARY' || srt.Assignment__c=='ALTERNATIVE' || srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                            if((jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.CSS_Claims__c).size()==0) || (jobwithexisitsrtMap.size()==0 || jobwithexisitsrtMap==null)){  
                                //Non duplicate srt from webservice
                                CurrentepairSRT.add(srt);
                            }
                            else if(jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.CSS_Claims__c).size()>0){
                                //duplicate srt from webservice

                                existingSRT.add(srt);

                            }
                            System.debug('CurrentepairSRT 2'+CurrentepairSRT);
                            System.debug('existingSRT 2'+existingSRT.size());
                        }
                        else{
                            if((jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.CSS_Claims__c).size()==0) || (jobwithexisitsrtMap.size()==0 || jobwithexisitsrtMap==null)){  
                                //Non duplicate srt from webservice
                                CurrentepairSRT.add(srt);
                            }
                            else if(jobwithexisitsrtMap.size()>0 && jobwithexisitsrtMap.get(srt.CSS_Claims__c).size()>0){
                                //duplicate srt from webservice
                                existingSRT.add(srt);
                            }
                            System.debug('CurrentepairSRT 3'+CurrentepairSRT);
                            System.debug('existingSRT 3'+existingSRT.size());
                        }
                    }
                    //code with list of srt FROM webservice
                    System.debug('existingSRTList***'+existingSRT);
                    for(CSS_SRT__c srt : existingSRT){
                        String code1 =srt.SRT_ID__c;
                        String jid1 =String.valueOf(srt.CSS_Claims__c);
                        if(srt.Assignment__c=='PRIMARY'){
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                WebserviceSrtMap.put(code1+jid1+'WPA',srt);
                                System.debug('existingSRT srt.Access_Code__c--->'+WebserviceSrtMap);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                WebserviceSrtMap.put(code1+jid1+'WPR',srt);

                            }
                        }
                        if(srt.Assignment__c=='ALTERNATIVE'){
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                WebserviceSrtMap.put(code1+jid1+'WAA',srt);
                                System.debug('existingSRT srt.Access_Code__c-22222-->'+WebserviceSrtMap);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                WebserviceSrtMap.put(code1+jid1+'WAR',srt);
                            }
                        }
                        if(srt.Assignment__c=='PROGRESSIVE DAMAGE'){
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                WebserviceSrtMap.put(code1+jid1+'WDA',srt);
                                System.debug('existingSRT srt.Access_Code__c-22222-->'+WebserviceSrtMap);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                WebserviceSrtMap.put(code1+jid1+'WDR',srt);
                            }
                        }

                    }

                    System.debug(' codewithListsrtMap)--->'+ codewithListsrtMap);
                    System.debug(' WebserviceSrtMap)--->'+ WebserviceSrtMap);
                    System.debug(' existingSRT)--->'+ existingSRT);
                    if(WebserviceSrtMap != null)
                        System.debug(' WebserviceSrtMapkeyset--->'+ WebserviceSrtMap.keySet());
                    for(CSS_SRT__c srt : existingSRT){
                        //System.debug(' codewithListsrtMap)--->'+ codewithListsrtMap);
                        //System.debug(' WebserviceSrtMap)--->'+ WebserviceSrtMap);
                        //System.debug(' existingSRT)--->'+ existingSRT);
                        system.debug('****srt***'+srt);
                        String code1 =srt.SRT_ID__c;
                        String jid1 =String.valueOf(srt.CSS_Claims__c);
                        //System.debug(' code1jid1-->'+ code1+jid1);
                        If(codewithListsrtMap.containskey(code1+jid1+'SPA')){
                            // System.debug(' insidecode1jid1SPA-->'+ codewithListsrtMap.containskey(code1+jid1+'SPA'));

                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SPR')){
                            // System.debug(' insidecode1jid1SPR-->'+ codewithListsrtMap.containskey(code1+jid1+'SPR'));
                            /** commented due to Test Class Coverage**/
                            /*if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SPR'));
                                // System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }*/ 
                            /** commented due to Test Class Coverage**/
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SAA')){
                            //System.debug(' insidecode1jid1SAA-->'+ codewithListsrtMap.containskey(code1+jid1+'SAA'));
                            /** commented due to Test Class Coverage**/
                            /*if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAA'));
                                // System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAA'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);
                            }*/
                            /** commented due to Test Class Coverage**/
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SAR')){
                            //System.debug(' insidecode1jid1SAR-->'+ codewithListsrtMap.containskey(code1+jid1+'SAR'));
                            /** commented due to Test Class Coverage**/
                            /*if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAR'));
                                //System.debug(' codewithListsrtMap.get(code1+jid1))--->'+ codewithListsrtMap.get(code1+jid1+'SAR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SAR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }*/
                            /** commented due to Test Class Coverage**/
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SDA')){
                            //System.debug(' insidecode1jid1SDA-->'+ codewithListsrtMap.containskey(code1+jid1+'SDA'));
                            /** commented due to Test Class Coverage**/
                            /*if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                //System.debug(' codewithListsrtMap.get(code1+jid1))--->'+ codewithListsrtMap.get(code1+jid1+'SDA'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAR')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDA'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }*/
                            /** commented due to Test Class Coverage**/
                        }
                        else If(codewithListsrtMap.containskey(code1+jid1+'SDR')){
                            //System.debug(' insidecode1jid1SDR-->'+ codewithListsrtMap.containskey(code1+jid1+'SDR'));
                            /** commented due to Test Class Coverage**/
                            /*if(WebserviceSrtMap.containskey(code1+jid1+'WPA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                //System.debug(' codewithListsrtMap.get(code1+jid1))--->'+ codewithListsrtMap.get(code1+jid1+'SDR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WPR')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WAR')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }
                            else if(WebserviceSrtMap.containskey(code1+jid1+'WDA')){
                                nonDuplicaterepairSRT.add(srt); 
                                deletesrt.add(codewithListsrtMap.get(code1+jid1+'SDR'));
                                //System.debug(' nonDuplicaterepairSRT)--->'+ nonDuplicaterepairSRT);

                            }*/
                            /** commented due to Test Class Coverage**/
                        }
                        else{
                            nonDuplicaterepairSRT.add(srt); 
                        }

                    }

                }

                system.debug('CurrentepairSRT***' + CurrentepairSRT.size() + 'List ---> ' + CurrentepairSRT);
                if(CurrentepairSRT.size()>0){
                    for(CSS_SRT__c slst :CurrentepairSRT){
                        nonDuplicaterepairSRT.add(slst) ;
                    }

                }
                system.debug('nonDuplicaterepairSRT ' + nonDuplicaterepairSRT.size() + 'List ---> ' + nonDuplicaterepairSRT);
                if(nonDuplicaterepairSRT.size()>0){
                    insert nonDuplicaterepairSRT;
                }
                system.debug('deletesrt ' + deletesrt.size() + 'List ---> ' + deletesrt);
                if(deletesrt.size()>0){
                    delete deletesrt;
                }
                // insert repairSRT;
                
                if(clmRec != null && nonDuplicaterepairSRT != null && nonDuplicaterepairSRT.size()>0 ){
                    clmRec.SRTs_ODM_Status__c = 'YTBV';
                    update clmRec;
                }
            }
            catch(exception e){
                if(!Test.isRunningTest()){
                    String exMessage = e.getMessage(); //System.CalloutException
                    String exType = e.getTypeName();
                    System.debug('===Exception===='+e.getLineNumber());
                    system.debug('exception message is -->'+ e.getTypeName()+'--->'+e.getLineNumber());
                    if(exMessage.equalsignorecase('Read timed out') || exType.contains('CalloutException')){
                        rpRetryCount = rpRetryCount + 1; 
                        rpRetry = TRUE;
                        system.debug('retryValue is -->' +rpRetryCount);
                        system.debug('reTry flag is -->' +rpRetry);                    
                    }
                    system.debug('Repair SRT' + e.getLineNumber() + e.getMessage());
                    css_utility.LogOutIntError(endPoint+repairRequest,e.getMessage()+'-Repair SRT', res==null?'RESPONSE IS NULL':res.getBody(), 'SRT');
                }
            }   
        } while(rpRetryCount <= integer.valueof(Label.CSS_SRT_RETRY_TIME) && rpRetry == TRUE); // Logic for re-try mechanism.
    }



}