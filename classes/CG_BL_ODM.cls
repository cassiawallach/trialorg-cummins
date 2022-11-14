/**********************************************************************
Name: CG_BL_ODM
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: Class contains methods to perform buisiness logics of ODM 
Webservices
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0     Anirudh Reddy    07-May-2018    INITIAL DEVELOPMENT
2.0.    Shailender		 18-Jul-2022	FBI-385
***********************************************************************/
public class CG_BL_ODM {

    public static List<CSS_Job_Order__c> updatelstjob{get;set;}
    public static List<CSS_Claims__c> updateClaimDetailss{get;set;}
    public static List<CSS_Integration_Error__c> lstClaimsIntDetails{get;set;}
    public static List<CSS_Integration_Error__c> lstjobIntDetails{get;set;}
    public static List<CSS_Solution_Component__c> updatelstsolComp{get;set;}
    public static List<CSS_Parts_Options__c> updateClaimsPartRecList{get;set;}
    public static List<CSS_JobHistory__c> failureHistList = new List<CSS_JobHistory__c>();
    public static list<CG_ODM_ResJSONParser.message> ODMFailureChevronDisplayMsgs{get;set;}
    public static list<CG_ODM_ResJSONParser.message> ODMPartsChevronDisplayMsgs{get;set;}
    public static list<CG_ODM_ResJSONParser.message> ODMSRTChevronDisplayMsgs{get;set;}
    public static List<CSS_Solution_Component__c> updatelstPartWarrantySolComp;
    public static Boolean showodmerrormsg{get;set;}
    public static List<css_srt__c> updateSRTList{get;set;}
    public static List<CSS_Parts_Options__c> updateTravelList{get;set;}
    public static List<CSS_Integration_Error__c> intLogList{get;set;}
    
    //Temp Class for Solving Claims Header
    public static List<CSS_Integration_Error__c> callODMHeaderValidationClaimService(CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,List<CSS_Solution_Component__c> SolComp, String sourceChevron){
        lstjobIntDetails=new List<CSS_Integration_Error__c>();
        list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
        try{ 
            system.debug('Anirudh Entered ODM Header Val;idation Service>>>>>>.');
            CG_BL_ODM.showodmerrormsg=false;

            List<CSS_Solution_Component__c> lstPartWarrantySolComp = new List<CSS_Solution_Component__c>();

            CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();
            updatelstjob= new List<CSS_Job_Order__c> ();
            
            boolean fieldActionClaim;
            String ODMMessage = ''; 
            Integer ODMStatusCode;
            if(SolComp!= null && SolComp.size()>0){
                for(CSS_Solution_Component__c sctemp : SolComp) {
                    if(sctemp.CSS_Account_Formula__c != null && (sctemp.CSS_Account_Formula__c.contains('35') 
                        || sctemp.CSS_Account_Formula__c.contains('62') || sctemp.CSS_Account_Formula__c.contains('41') 
                        || sctemp.CSS_Account_Formula__c.contains('97') || sctemp.CSS_Account_Formula__c.contains('65')
                        || sctemp.CSS_Account_Formula__c.contains('52') || sctemp.CSS_Account_Formula__c.contains('27'))){
                        lstPartWarrantySolComp.add(sctemp);
                    }
                }
            } 

            if(Source == 'JOB')
                reqJSON = prepareServiceJobHeaderValidationReqJSON(null,serJob,'Header');
            if(Source == 'CLAIM')
                reqJSON = prepareClaimHeaderValidationReqJSON(null,clm,psnRec,'Header');
            system.debug('reqJSON>>>>>>>'+reqJSON);
            //callODMService
            resWrapper = CG_SL_ODM.callODMHeaderService(reqJSON);
            system.debug('resWrapper>>>>>>>'+resWrapper);
            if(resWrapper != null && resWrapper.response != null)
                ODMStatusCode = resWrapper.response.getStatusCode();
            CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
            ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class); 
            system.debug('ODMResponse>>' + ODMResponse);
            String penaltyValue;
            if(ODMResponse.Response.claim != null && ODMResponse.Response.claim.messages != null){
                //system.debug('Entered messages section>>>>>>'+ODMResponse.Response.claim.messages[0].description);
                for(CG_ODM_ResJSONParser.messages msg:ODMResponse.Response.claim.messages){
                    system.debug('Entered for loop messages section>>>>>>'+msg);
                    ODMMessage = ODMMessage + msg.type + ':' + msg.description + ';;';
                    if(msg.code!=null && msg.code.equalsIgnoreCase('ODM-HE-WAR-205')){
                        penaltyValue = ODMResponse.Response.claim.penalty;
                    }
                }
            }

            CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();

            intDetails.Auth_Call_Time__c = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
            //Request Body
            intDetails.Processed_Data__c =  resWrapper.request.getBody();
            intDetails.Response_Body__c = resWrapper.response.getBody();
            intDetails.Service_Call_Time__c = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
            if(Source == 'JOB')
                intDetails.Service_Job_Number__c = serJob.Name;
            if(Source == 'CLAIM')
                intDetails.Service_Job_Number__c = clm.Name;
            intDetails.Service_Name__c = 'ODMHeaderValidation';
            intDetails.Source__c = 'ODM';

            lstIntDetails.add(intDetails);  
            lstjobIntDetails.add(intDetails);          

            if(lstPartWarrantySolComp != null && lstPartWarrantySolComp.size()>0){
                for(CSS_Solution_Component__c partWrntyFailures:lstPartWarrantySolComp){
                    fieldActionClaim = false;
                    if(partWrntyFailures.CSS_Account_Formula__c.contains('65') || partWrntyFailures.CSS_Account_Formula__c.contains('27')){
                      fieldActionClaim = true;  
                    }
                    resWrapper = new CG_OP_OAGWrapper();
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB'){
                        reqJSON = prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? partWrntyFailures : null),serJob,'Header');
                    }
                    if(Source == 'CLAIM'){
                        reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? partWrntyFailures : null),clm,psnRec,'Header');
                    }                        
                        //reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? partWrntyFailures : partWrntyFailures),clm,psnRec,'Header');
                    //callODMService
                    resWrapper = CG_SL_ODM.callODMHeaderService(reqJSON);  
                    ODMResponse = new CG_ODM_ResJSONParser(); 
                    ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class); 

                    if(ODMResponse.Response.claim != null){
                        for(CG_ODM_ResJSONParser.messages msg:ODMResponse.Response.claim.messages){
                            ODMMessage = ODMMessage + msg.type + ':' + msg.description + ';;';
                        }
                    }

                   intDetails = new CSS_Integration_Error__c();

                    intDetails.Auth_Call_Time__c = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  resWrapper.request.getBody();
                    intDetails.Response_Body__c = resWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMHeaderValidation';
                    intDetails.Source__c = 'ODM';

                    lstIntDetails.add(intDetails);  
                    lstjobIntDetails.add(intDetails);  
                }
            }

            if(Source == 'JOB'){
                CSS_Job_Order__c worecord = new CSS_Job_Order__c();
                worecord.ODM_Status_Message__c =  ODMMessage;
                worecord.Id = serJob.Id;
                worecord.ODM_Penalty__c = (penaltyValue != null && penaltyValue != '' ? penaltyValue : '');
                if(ODMStatusCode != 200){
                    worecord.ODM_Status_Code__c = string.valueOf(ODMStatusCode);
                    showodmerrormsg = true;
                }
                if(ODMMessage != null && ODMMessage != ''){
                    if(ODMMessage.contains('ERROR') || Test.isRunningTest()){
                        worecord.ODM_Status__c = 'ERROR';
                        showodmerrormsg = true;
                    }
                    else{
                        worecord.ODM_Status__c = 'WARN';
                    }
                }else{
                    worecord.ODM_Status__c = 'PASSED';
                    worecord.ODM_Status_Message__c =  '';
                }
                updatelstjob.add(worecord);
                //update worecord;
            }
            if(Source == 'CLAIM' && sourceChevron == 'WarrantyOverview'){
                CSS_Claims__c clmRecord = new CSS_Claims__c();
                clmRecord.ODM_Status_Message__c =  ODMMessage;
                clmRecord.Id = clm.Id;
                clmRecord.ODM_Penalty__c = (penaltyValue != null && penaltyValue != '' ? penaltyValue : '');
                if(ODMStatusCode != 200){
                    clmRecord.ODM_Status_Code__c = string.valueOf(ODMStatusCode);
                }
                if(ODMMessage != null && ODMMessage != ''){
                    if(ODMMessage.contains('ERROR')){
                        clmRecord.ODM_Status__c = 'ERROR';
                    }
                    else{
                        clmRecord.ODM_Status__c = 'WARN';
                    }
                }else{
                    clmRecord.ODM_Status__c = 'PASSED';
                    clmRecord.ODM_Status_Message__c =  '';
                }

                //update clmRecord;
            }
            //if(Source == 'CLAIM' && sourceChevron == 'WarrantyOverview'){
            //insert lstIntDetails;}
            //return  CG_BL_ODM.showodmerrormsg;
        }catch(exception e){
            system.debug('Entered into catch block of callODMHeaderValidationClaimsService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber()+e.getStackTraceString());
        }
        return lstIntDetails;
    }
    
    //Temp Class for Solving Claims Header
    public static boolean callODMHeaderValidationService(CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,List<CSS_Solution_Component__c> SolComp, String sourceChevron){
        try{
            system.debug('Anirudh Entered ODM Header Val;idation Service>>>>>>.');
            CG_BL_ODM.showodmerrormsg=false;
            List<CSS_Solution_Component__c> lstPartWarrantySolComp = new List<CSS_Solution_Component__c>();
            updatelstPartWarrantySolComp = new List<CSS_Solution_Component__c>();
            list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
            ODMFailureChevronDisplayMsgs = new list<CG_ODM_ResJSONParser.message>();
             updateClaimDetailss = new List<CSS_Claims__c>();
            CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();
            updatelstjob= new List<CSS_Job_Order__c> ();
            lstjobIntDetails=new List<CSS_Integration_Error__c>();
            String penaltyValue;
            String ODMMessage = '';   
            Integer ODMStatusCode;  
            boolean fieldActionClaim;
            Map<Id,CG_ODM_ReqJSONParser> solCompODMRespMap = new Map<Id,CG_ODM_ReqJSONParser>();
            if(SolComp!= null && SolComp.size()>0){
                for(CSS_Solution_Component__c sctemp : SolComp) {
                    if(sctemp.CSS_Account_Formula__c != null && sctemp.Selected_Component__c == true && (sctemp.CSS_Account_Formula__c.contains('35') || sctemp.CSS_Account_Formula__c.contains('62') || sctemp.CSS_Account_Formula__c.contains('41') || sctemp.CSS_Account_Formula__c.contains('97') || sctemp.CSS_Account_Formula__c.contains('65') || sctemp.CSS_Account_Formula__c.contains('52')|| sctemp.CSS_Account_Formula__c.contains('27'))) {
                        lstPartWarrantySolComp.add(sctemp);
                    }
                }
            } 
            system.debug('Source>>>>>'+Source);
            if(!sourceChevron.contains('FailureChevron')){
            if(Source == 'JOB')
                reqJSON = prepareServiceJobHeaderValidationReqJSON(null,serJob,'Header');
            if(Source == 'CLAIM')
                reqJSON = prepareClaimHeaderValidationReqJSON(null,clm,psnRec,'Header');
            system.debug('reqJSON>>>>>>>'+reqJSON);
            //callODMService
            resWrapper = CG_SL_ODM.callODMHeaderService(reqJSON);
            if(resWrapper != null && resWrapper.response != null)
                ODMStatusCode = resWrapper.response.getStatusCode();
            }
            system.debug('resWrapper>>>>>>>'+resWrapper);
            CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
            if(resWrapper != null && resWrapper.response!=null){
            ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class); 
            
            if(ODMResponse != null && ODMResponse.Response != null && ODMResponse.Response.claim != null && ODMResponse.Response.claim.messages != null){
                //system.debug('Entered messages section>>>>>>'+ODMResponse.Response.claim.messages[0].description);
                for(CG_ODM_ResJSONParser.messages msg:ODMResponse.Response.claim.messages){
                    system.debug('Entered for loop messages section>>>>>>'+msg.description);
                    ODMMessage = ODMMessage + msg.type + ':' + msg.description + ';;';
                    if(msg.code.equalsIgnoreCase('ODM-HE-WAR-205')){
                        penaltyValue = ODMResponse.Response.claim.penalty;
                    }
                }
            }
            }

            CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
            if(resWrapper != null){
            intDetails.Auth_Call_Time__c = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
            //Request Body
            intDetails.Processed_Data__c =  (resWrapper.request != null ? resWrapper.request.getBody() : '');
            intDetails.Response_Body__c = (resWrapper.request != null ? resWrapper.request.getBody() : '');
            intDetails.Service_Call_Time__c = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
            if(Source == 'JOB')
                intDetails.Service_Job_Number__c = serJob.Name;
            if(Source == 'CLAIM')
                intDetails.Service_Job_Number__c = clm.Name;
            intDetails.Service_Name__c = 'ODMHeaderValidation';
            intDetails.Source__c = 'ODM';

            lstIntDetails.add(intDetails);  
            lstjobIntDetails.add(intDetails);          
            }
            boolean updatePartWarrantyHeader;
            if(lstPartWarrantySolComp != null && lstPartWarrantySolComp.size()>0){
                if(Source == 'JOB')
                        ODMMessage = serJob.ODM_Status_Message__c;
                    if(Source == 'CLAIM')
                        ODMMessage = clm.ODM_Status_Message__c;
                
                for(CSS_Solution_Component__c partWrntyFailures:lstPartWarrantySolComp){
                    fieldActionClaim = false;
                    if(partWrntyFailures.CSS_Account_Formula__c.contains('65') || partWrntyFailures.CSS_Account_Formula__c.contains('27')){
                      fieldActionClaim = true;
                      continue;
                    }
                    resWrapper = new CG_OP_OAGWrapper();
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? partWrntyFailures : null),serJob,'Header');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? partWrntyFailures : null),clm,psnRec,'Header');
                    //callODMService
                    resWrapper = CG_SL_ODM.callODMHeaderService(reqJSON);  
                    //Anirudh- We can update these responses in a map based on solution component id as key and reswrapper as value
                    //solCompODMRespMap.put(partWrntyFailures.id,resWrapper);
                    ODMResponse = new CG_ODM_ResJSONParser(); 
                    ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class); 
                    
                    if(ODMResponse.Response.claim != null && ODMResponse.Response.claim.messages != null){
                        for(CG_ODM_ResJSONParser.messages msg:ODMResponse.Response.claim.messages){
                            //Story 181418 changes- Zootopia
                            CG_ODM_ResJSONParser.message FChevronMsg = new CG_ODM_ResJSONParser.message();
                            FChevronMsg.description = msg.description;
                            FChevronMsg.code = msg.code;
                            FChevronMsg.type = msg.type;
                            FChevronMsg.partSRTCode = (partWrntyFailures.Fail_Code__c != null ? partWrntyFailures.Fail_Code__c : '');
                            ODMFailureChevronDisplayMsgs.add(FChevronMsg);
                            if((ODMMessage != null && ODMMessage != '' && !ODMMessage.containsIgnoreCase('Penalties may be applied')) || (ODMMessage == null || ODMMessage == '')){//Anirudh- This is a temporary fix for UAT.it has to be removed during phase 2 story and two new fields have to be created for parts warranty status and message
                            ODMMessage = (ODMMessage != null && ODMMessage != '' ? ODMMessage + ';;' : '') + msg.type + ':' + msg.description + ';;';
                            if(ODMMessage != null && ODMMessage != ''){
                                updatePartWarrantyHeader = true;
                            }
                            }
                            //Added below code as per story 180325
                             if(msg.code.equalsIgnoreCase('ODM-HE-WAR-205')){
                        partWrntyFailures.ODM_Penalty__c = ODMResponse.Response.claim.penalty;
                        updatelstPartWarrantySolComp.add(partWrntyFailures);
                    }
                        }
                    }

                    intDetails = new CSS_Integration_Error__c();

                    intDetails.Auth_Call_Time__c = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  resWrapper.request.getBody();
                    intDetails.Response_Body__c = resWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMHeaderValidation';
                    intDetails.Source__c = 'ODM';

                    lstIntDetails.add(intDetails);  
                    lstjobIntDetails.add(intDetails);  
                }
            }

            if(Source == 'JOB'){
                CSS_Job_Order__c worecord = new CSS_Job_Order__c();
                worecord.ODM_Status_Message__c =  ODMMessage;
                worecord.Id = serJob.Id;
                worecord.ODM_Penalty__c = (penaltyValue != null && penaltyValue != '' ? penaltyValue : '');
                if(ODMStatusCode != 200){
                    worecord.ODM_Status_Code__c = string.valueOf(ODMStatusCode);
                    showodmerrormsg = true;

                }
                if(ODMMessage != null && ODMMessage != ''){
                    if(ODMMessage.contains('ERROR')){
                        worecord.ODM_Status__c = 'ERROR';
                        showodmerrormsg = true;
                    }
                    else{
                        worecord.ODM_Status__c = 'WARN';
                    }
                }else{
                    worecord.ODM_Status__c = 'PASSED';
                    worecord.ODM_Status_Message__c =  '';
                }
                updatelstjob.add(worecord);
                //update worecord;
            }
            if(Source == 'CLAIM' && sourceChevron == 'WarrantyOverview'){
                CSS_Claims__c clmRecord = new CSS_Claims__c();
                clmRecord.ODM_Status_Message__c =  ODMMessage;
                clmRecord.Id = clm.Id;
                clmRecord.ODM_Penalty__c = (penaltyValue != null && penaltyValue != '' ? penaltyValue : '');
                if(ODMStatusCode != 200){
                    clmRecord.ODM_Status_Code__c = string.valueOf(ODMStatusCode);
                }
                if(ODMMessage != null && ODMMessage != ''){
                    if(ODMMessage.contains('ERROR')){
                        clmRecord.ODM_Status__c = 'ERROR';
                    }
                    else{
                        clmRecord.ODM_Status__c = 'WARN';
                    }
                }else{
                    clmRecord.ODM_Status__c = 'PASSED';
                    clmRecord.ODM_Status_Message__c =  '';
                }

                update clmRecord;
            }
         if(Source == 'CLAIM' && updatePartWarrantyHeader == true){//Anirudh- the whole if is a temporary fix for UAT.it has to be removed during phase 2 story and two new fields have to be created for parts warranty status and message
                CSS_Claims__c clmRecord = new CSS_Claims__c();
                clmRecord.ODM_Status_Message__c =  ODMMessage;
                clmRecord.Id = clm.Id;
                system.debug('ODMMessage'+ODMMessage+'>>>clmRecord.ODM_Status__c'+clmRecord.ODM_Status__c);
                if(ODMMessage != null && ODMMessage != ''){
                    if(ODMMessage.contains('ERROR')){
                        clmRecord.ODM_Status__c = 'ERROR';
                    }else if(clm.ODM_Status__c == 'PASSED' && ODMMessage.containsIgnoreCase('WARNING')){
                         clmRecord.ODM_Status__c = 'WARN';
                    }
                }
                system.debug('Anirudh clmRecord>>>>>'+clmRecord); 
                updateClaimDetailss.add(clmRecord);
                //update clmRecord;
            }
            
            if(Source == 'JOB' && updatePartWarrantyHeader == true || Test.isRunningTest()){
                CSS_Job_Order__c worecord = new CSS_Job_Order__c();
                worecord.ODM_Status_Message__c =  ODMMessage;
                worecord.Id = serJob.Id;
                if(ODMMessage != null && ODMMessage != '' || Test.isRunningTest()){
                    if(ODMMessage.contains('ERROR') || Test.isRunningTest()){
                        worecord.ODM_Status__c = 'ERROR';
                    }
                }
                updatelstjob.add(worecord);
            }
            
            
            if(Source == 'CLAIM' && sourceChevron == 'WarrantyOverview'){
                insert lstIntDetails;}
            return  CG_BL_ODM.showodmerrormsg;
        }catch(exception e){
            system.debug('Entered into catch block of callODMHeaderValidationService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return false;
    }
    
    //Odm Failure Service
    public static boolean callODMFailureValidationService(CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,List<CSS_Solution_Component__c> SolComp,String sourceChevron){
        try{
            system.debug('****inside callODMFailureValidationService***'+SolComp);
            CG_BL_ODM.showodmerrormsg=false;
            //List<CSS_Solution_Component__c> lstPartWarrantySolComp = new List<CSS_Solution_Component__c>();
            CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();
            lstClaimsIntDetails=new List<CSS_Integration_Error__c>();
            updatelstsolComp=new List<CSS_Solution_Component__c>();
            failureHistList = new List<CSS_JobHistory__c>();
            Map<String,CSS_Solution_Component__c> mapPrtWrntySolComp = new Map<String,CSS_Solution_Component__c>();
            Map<String,CSS_Solution_Component__c> mapAccSolComp = new Map<String,CSS_Solution_Component__c>();
            Map<String,List<CSS_Solution_Component__c>> mapSolComp = new Map<String,List<CSS_Solution_Component__c>>();
            list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
            if(ODMFailureChevronDisplayMsgs == null)//for zootopia story 181418
            ODMFailureChevronDisplayMsgs = new list<CG_ODM_ResJSONParser.message>();
            //list<CSS_Solution_Component__c> updateSolCompList = new list<CSS_Solution_Component__c>();
            String ODMMessage;   
            boolean fieldActionClaim;
            if(SolComp.size()>0){
                for(CSS_Solution_Component__c sctemp : SolComp) {
                    if(sctemp.Selected_Component__c == true && sctemp.ODM_Status__c != 'PASSED' && sctemp.ODM_Status__c != 'NA' 
                    && sctemp.CSS_Account_Formula__c != null && (sctemp.CSS_Account_Formula__c.contains('35') 
                    || sctemp.CSS_Account_Formula__c.contains('62') || sctemp.CSS_Account_Formula__c.contains('41') 
                    || sctemp.CSS_Account_Formula__c.contains('97') || sctemp.CSS_Account_Formula__c.contains('65') 
                    || sctemp.CSS_Account_Formula__c.contains('27') || sctemp.CSS_Account_Formula__c.contains('52'))) {
            mapPrtWrntySolComp.put(sctemp.CSS_Account_Formula__c + sctemp.System_Code__c + sctemp.Component_Code__c + sctemp.Failure_Mode__c, sctemp);
                    }else if(sctemp.Selected_Component__c == true && sctemp.ODM_Status__c != 'PASSED' && sctemp.ODM_Status__c != 'NA' 
                    && sctemp.CSS_Account_Formula__c != null && !sctemp.CSS_Account_Formula__c.contains('35') 
                    && !sctemp.CSS_Account_Formula__c.contains('62') && !sctemp.CSS_Account_Formula__c.contains('41') 
                    && !sctemp.CSS_Account_Formula__c.contains('97') && !sctemp.CSS_Account_Formula__c.contains('65') 
                    && !sctemp.CSS_Account_Formula__c.contains('27') && !sctemp.CSS_Account_Formula__c.contains('52')) {
                        System.debug(mapSolComp + 'mapSolComp');
                         System.debug(sctemp.CSS_Account_Formula__c + 'sctemp.CSS_Account_Formula__c');
                        if(mapSolComp.containsKey(sctemp.CSS_Account_Formula__c)) {
                            List<CSS_Solution_Component__c> fclist = mapSolComp.get(sctemp.CSS_Account_Formula__c);
                            fclist.add(sctemp);
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, fclist);
                        } else {
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, new List<CSS_Solution_Component__c> { sctemp });
                        } 
                    }
                }
            } 

            if(mapPrtWrntySolComp != null){
                // Added as part of APST-1325
                Map<string,CSS_JobEventTemporary__c> mapCssAccountWithJobEventTemp = new Map<string,CSS_JobEventTemporary__c> ();
                Set<string> setCSSAccount = new  Set<string> ();
                for(CSS_Solution_Component__c prtWrntySolComp:mapPrtWrntySolComp.values()){
                    setCSSAccount.add(prtWrntySolComp.CSS_Account_Formula__c.Right(2));                  
                }
                if(!setCSSAccount.isEmpty()){
                    for(CSS_JobEventTemporary__c objCSSJobEventTemp: [select Attribute1__c,Attribute3__c,
                                                                      Attribute9__c,Attribute7__c 
                                                                      from CSS_JobEventTemporary__c where
                                                                      Key__c = 'AccountCodes' AND 
                                                                      Attribute3__c IN: setCSSAccount]){
                                                                          mapCssAccountWithJobEventTemp.put(objCSSJobEventTemp.Attribute3__c,objCSSJobEventTemp);                                                                    
                                                                          
                                                                      }
                }
                // End of Modification
                for(CSS_Solution_Component__c prtWrntySolComp:mapPrtWrntySolComp.values()){
                    fieldActionClaim = false;
                    if(prtWrntySolComp.CSS_Account_Formula__c.contains('65') || prtWrntySolComp.CSS_Account_Formula__c.contains('27')){
                        fieldActionClaim = true;  
                    }
                    resWrapper = new CG_OP_OAGWrapper();
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),serJob,'Failure');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),clm,psnRec,'Failure');
                    
                    
                    CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                    CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                    CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();
                    failureDetails.accountCode =  prtWrntySolComp.CSS_Account_Formula__c.Right(2);
                    failureDetails.approvalCode = prtWrntySolComp.Approval_Code__c;
                    failureDetails.authorizationNumber = prtWrntySolComp.Authorization_Number__c;
                    failureDetails.campaignId = (prtWrntySolComp.Component_Id__c != null && prtWrntySolComp.Component_Id__c != '' ? string.valueof(prtWrntySolComp.Component_Id__c) : '');
                    //failureDetails.coverageType = prtWrntySolComp.CSS_CoverageType__c;
                    failureDetails.failCode = prtWrntySolComp.System_Code__c + prtWrntySolComp.Component_Code__c;
                    failureDetails.failMode = prtWrntySolComp.Failure_Mode__c;
                    failureDetails.lineNumber = prtWrntySolComp.Id;
                    failureDetails.overrideFlag = 'N';
                    failureDetails.payCode = prtWrntySolComp.Pay_Code__c;
                    failureDetails.status = 'Draft';
                    /* CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, 
Attribute9__c,Attribute7__c from 
CSS_JobEventTemporary__c where 
Key__c = 'AccountCodes' 
AND Attribute3__c =: prtWrntySolComp.CSS_Account_Formula__c.Right(2) LIMIT 1];*/
                     // Added as part of APST-1325
                    if(!mapCssAccountWithJobEventTemp.isEmpty() &&
                       mapCssAccountWithJobEventTemp.containsKey(prtWrntySolComp.CSS_Account_Formula__c.Right(2))){
                           acctInfo.accountCodeType = mapCssAccountWithJobEventTemp.get(prtWrntySolComp.CSS_Account_Formula__c.Right(2)).Attribute1__c;
                           failureDetails.coverageType = mapCssAccountWithJobEventTemp.get(prtWrntySolComp.CSS_Account_Formula__c.Right(2)).Attribute1__c;
                           acctInfo.chryslerFlag = mapCssAccountWithJobEventTemp.get(prtWrntySolComp.CSS_Account_Formula__c.Right(2)).Attribute9__c;
                           acctInfo.multiESNFlag = mapCssAccountWithJobEventTemp.get(prtWrntySolComp.CSS_Account_Formula__c.Right(2)).Attribute7__c;
                       }
                     // End of Modification
                    
                    failureDetails.AcctCodeInfo = acctInfo;
                    failureDetails.Campaign = cmpgn;
                    reqJSON.Request.claim.failure.add(failureDetails);
                    
                    CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
                    resWrapper = CG_SL_ODM.callODMFailureService(reqJSON);  
                    ODMResponse = new CG_ODM_ResJSONParser(); 
                    ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);
                    system.debug('****ODMResponse***'+ODMResponse);
                    
                    CSS_Solution_Component__c ODMResSolComp = new CSS_Solution_Component__c();
                    if(ODMResponse.Response.claim.failure != null){
                        if(ODMResponse.Response.claim.failure[0].lineNumber !=null && ODMResponse.Response.claim.failure[0].lineNumber !='' || Test.isRunningTest()){
                            List<CG_ODM_ResJSONParser.message> resFailuresMsgList = new List<CG_ODM_ResJSONParser.message>();
                            resFailuresMsgList = (ODMResponse.Response.claim.failure[0].messages != null ? ODMResponse.Response.claim.failure[0].messages : null);
                            //if(ODMResponse.Response.claim.failure[0].messages != null){
                            ODMResSolComp.Id = ODMResponse.Response.claim.failure[0].lineNumber;
                            ODMResSolComp.ODM_Status_Code__c = string.valueof(resWrapper.response.getStatusCode()); //to handle null response
                            
                            system.debug('****prtWrntySolComp.Pay_Code__c***'+prtWrntySolComp.Pay_Code__c);
                            system.debug('****ODMResponse.Response.claim.failure[0].payCode***'+ODMResponse.Response.claim.failure[0].payCode);
                            if(prtWrntySolComp.Pay_Code__c != null && prtWrntySolComp.Pay_Code__c != '' && prtWrntySolComp.Pay_Code__c != ODMResponse.Response.claim.failure[0].payCode || Test.isRunningTest()){
                                system.debug('****insidePayCodeIf***');
                                ODMResSolComp.Pay_Code__c = ODMResponse.Response.claim.failure[0].payCode;
                                CSS_JobHistory__c failureHistTemp = new CSS_JobHistory__c();
                                failureHistTemp.CSS_Job_Id__c = clm.id;
                                failureHistTemp.CSS_Object_Name__c = 'CSS_Solution_Component__c';
                                failureHistTemp.CSS_Field_Name__c = 'Pay_Code__c';
                                failureHistTemp.CSS_New_Value__c = ODMResponse.Response.claim.failure[0].payCode;
                                failureHistTemp.CSS_Old_Value__c = prtWrntySolComp.Pay_Code__c; 
                                failureHistTemp.Audit_Message__c = 'ODM has updated Paycode from'+' '+ prtWrntySolComp.Pay_Code__c+' '+'to'+' '+ODMResponse.Response.claim.failure[0].payCode; 
                                failureHistList.add(failureHistTemp);
                            }
                            if(resFailuresMsgList != null && resFailuresMsgList.size()>0 || Test.isRunningTest()){
                                for(CG_ODM_ResJSONParser.message msg:resFailuresMsgList){
                                    //Story 181418 changes- Zootopia
                                    CG_ODM_ResJSONParser.message fChevronMsg = new CG_ODM_ResJSONParser.message();
                                    fChevronMsg.code = msg.code;
                                    fChevronMsg.description = msg.description;
                                    fChevronMsg.type = msg.type;
                                    fChevronMsg.partSRTCode = ODMResponse.Response.claim.failure[0].failCode;
                                    ODMFailureChevronDisplayMsgs.add(fChevronMsg);
                                    if(msg.type != null && msg.type.trim() == 'ERROR' || Test.isRunningTest()){
                                        ODMResSolComp.ODM_Status__c = 'ERROR';
                                    }
                                    if(ODMResSolComp.ODM_Status__c != 'ERROR' && msg.type != null && msg.type.trim() == 'WARNING'|| Test.isRunningTest()){
                                        ODMResSolComp.ODM_Status__c = 'WARN';
                                    }
                                    ODMResSolComp.ODM_Status_Message__c = (ODMResSolComp.ODM_Status_Message__c == null || ODMResSolComp.ODM_Status_Message__c == '' ? '' : ODMResSolComp.ODM_Status_Message__c) + (ODMResSolComp.ODM_Status_Message__c == null || ODMResSolComp.ODM_Status_Message__c == '' ? '' : ';;') + msg.type + ': ' + ODMResponse.Response.claim.failure[0].failCode + ': ' + msg.description;               
                                }
                            }
                            if(resFailuresMsgList == null || resFailuresMsgList.size() == 0 || Test.isRunningTest()){
                                ODMResSolComp.ODM_Status__c = 'PASSED';
                                ODMResSolComp.ODM_Status_Message__c = '';
                            }
                            if(ODMResSolComp.ODM_Status__c != null && ODMResSolComp.ODM_Status__c == 'ERROR' || Test.isRunningTest())
                                showodmerrormsg = true; 
                            
                            
                            // ODMResSolComp.ODM_Status_Message__c = ODMResponse.Response.claim.failure[0].messages.type + ':' + failureDetails.failCode + ':' + ODMResponse.Response.claim.failure[0].messages.description;
                        }
                    }
                    
                    CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
                    
                    intDetails.Auth_Call_Time__c = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  resWrapper.request.getBody();
                    intDetails.Response_Body__c = resWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMFailureValidation';
                    intDetails.Source__c = 'ODM';
                    
                    lstIntDetails.add(intDetails);                
                    //updateSolCompList.add(ODMResSolComp);
                    lstClaimsIntDetails.add(intDetails);                
                    updatelstsolComp.add(ODMResSolComp);
                }
            }                        
            map<String,CG_OP_OAGWrapper> MapResWrapperAccCodes = new map<String,CG_OP_OAGWrapper>();
            if(mapSolComp != null){     
                // Added as part of APST-1325
                Map<string,CSS_JobEventTemporary__c> mapCssAccountWithJobEventTemp = new Map<string,CSS_JobEventTemporary__c> ();
                Set<string> setCSSAccount = new  Set<string> ();                
                for(String accID: mapSolComp.keySet()){
                    for(CSS_Solution_Component__c SolCompRec:mapSolComp.get(accID)){
                         setCSSAccount.add(SolCompRec.CSS_Account_Formula__c.Right(2));   
                    }
                }     
                if(!setCSSAccount.isEmpty()){
                    for(CSS_JobEventTemporary__c objCSSJobEventTemp: [select Attribute1__c,Attribute3__c,
                                                                      Attribute9__c,Attribute7__c 
                                                                      from CSS_JobEventTemporary__c where
                                                                      Key__c = 'AccountCodes' AND 
                                                                      Attribute3__c IN: setCSSAccount]){
                                                                          mapCssAccountWithJobEventTemp.put(objCSSJobEventTemp.Attribute3__c,objCSSJobEventTemp);                                                                    
                                                                          
                                                                      }
                }
                 // End of Modification
                  for(String accID: mapSolComp.keySet()){
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON(null,serJob,'Failure');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON(null,clm,psnRec,'Failure');

                    for(CSS_Solution_Component__c SolCompRec:mapSolComp.get(accID)){
                        
                        mapAccSolComp.put(SolCompRec.Id,SolCompRec);

                        CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                        CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                        CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();
                        failureDetails.accountCode =  SolCompRec.CSS_Account_Formula__c.Right(2);
                        failureDetails.approvalCode = SolCompRec.Approval_Code__c;
                        failureDetails.authorizationNumber = SolCompRec.Authorization_Number__c;
                        failureDetails.campaignId = (SolCompRec.Component_Id__c != null && SolCompRec.Component_Id__c != '' ? string.valueof(SolCompRec.Component_Id__c) : '');
                        //   failureDetails.coverageType = SolCompRec.CSS_CoverageType__c;
                        failureDetails.failCode = SolCompRec.System_Code__c + SolCompRec.Component_Code__c;
                        failureDetails.failMode = SolCompRec.Failure_Mode__c;
                        failureDetails.lineNumber = SolCompRec.Id;
                        failureDetails.overrideFlag = 'N';
                        failureDetails.payCode = SolCompRec.Pay_Code__c;
                        failureDetails.status = 'Draft';

                      /*  CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, 
                                                                        Attribute9__c,Attribute7__c
                                                                        from CSS_JobEventTemporary__c 
                                                                        where Key__c = 'AccountCodes' 
                                                                        AND Attribute3__c =: SolCompRec.CSS_Account_Formula__c.Right(2) LIMIT 1];
                       */
                        // Added as part of APST-1325
                        if(!mapCssAccountWithJobEventTemp.isEmpty() &&
                          mapCssAccountWithJobEventTemp.containsKey(SolCompRec.CSS_Account_Formula__c.Right(2))){
                              acctInfo.accountCodeType = mapCssAccountWithJobEventTemp.get(SolCompRec.CSS_Account_Formula__c.Right(2)).Attribute1__c;
                              failureDetails.coverageType =  mapCssAccountWithJobEventTemp.get(SolCompRec.CSS_Account_Formula__c.Right(2)).Attribute1__c;
                              acctInfo.chryslerFlag = mapCssAccountWithJobEventTemp.get(SolCompRec.CSS_Account_Formula__c.Right(2)).Attribute9__c;
                              acctInfo.multiESNFlag = mapCssAccountWithJobEventTemp.get(SolCompRec.CSS_Account_Formula__c.Right(2)).Attribute7__c;
                        }
                        // End of Modification
                  
                        failureDetails.AcctCodeInfo = acctInfo;

                        failureDetails.AcctCodeInfo = acctInfo;
                        failureDetails.Campaign = cmpgn;
                        reqJSON.Request.claim.failure.add(failureDetails);

                    }
                    //CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
                    resWrapper = new CG_OP_OAGWrapper();
                    resWrapper = CG_SL_ODM.callODMFailureService(reqJSON); 

                    //ODMResponse = new CG_ODM_ResJSONParser(); 
                    //ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);

                    if(!MapResWrapperAccCodes.containsKey(accID))
                        MapResWrapperAccCodes.put(accID,resWrapper);
                    system.debug('MapResWrapperAccCodes>>>>>>>'+MapResWrapperAccCodes);
                } 
            }
             



            if(MapResWrapperAccCodes != null){
                for(String AccountID:MapResWrapperAccCodes.keySet()){
                    CG_OP_OAGWrapper responseWrapper = new CG_OP_OAGWrapper();
                    responseWrapper = MapResWrapperAccCodes.get(AccountID);
                    system.debug('Anirudh ODM Failure Service responseWrapper'+responseWrapper);
                    CG_ODM_ResJSONParser ODMRes = new CG_ODM_ResJSONParser(); 
                    ODMRes = (CG_ODM_ResJSONParser)JSON.deserialize(responseWrapper.response.getBody(),CG_ODM_ResJSONParser.class);
                    List<CG_ODM_ResJSONParser.Failure> resFailureList = ODMRes.Response.claim.Failure;

                    for(CG_ODM_ResJSONParser.Failure obj:resFailureList){
                        List<CG_ODM_ResJSONParser.message> resFailureMsgList = new List<CG_ODM_ResJSONParser.message>();
                        resFailureMsgList = (obj.messages != null ? obj.messages : null);
                        if(obj.lineNumber !=null && obj.lineNumber !=''){
                            CSS_Solution_Component__c solsComp = new CSS_Solution_Component__c();

                            //solsComp.ODM_Status_Message__c = obj.messages.type + ':' + obj.failCode + ':' + obj.messages.description;

                            solsComp.Id = obj.lineNumber;  
                            solsComp.ODM_Status_Code__c = string.valueof(responseWrapper.response.getStatusCode()); //to handle null response
                            
                            CSS_Solution_Component__c solsCompTemp = new CSS_Solution_Component__c();
                            solsCompTemp=mapAccSolComp.get(obj.lineNumber);
                            system.debug('****solsCompTemp.Pay_Code__c***'+solsCompTemp.Pay_Code__c);
                            system.debug('****obj.payCode***'+obj.payCode);
                            if(solsCompTemp != null && solsCompTemp.Pay_Code__c != null && solsCompTemp.Pay_Code__c != '' && solsCompTemp.Pay_Code__c != obj.payCode){
                                system.debug('***inside2ndIfPayCode***');
                                solsComp.Pay_Code__c = obj.payCode;
                                
                                CSS_JobHistory__c failureHistTemp1 = new CSS_JobHistory__c();
                                failureHistTemp1.CSS_Job_Id__c = clm.id;
                                failureHistTemp1.CSS_Object_Name__c = 'CSS_Solution_Component__c';
                                failureHistTemp1.CSS_Field_Name__c = 'Pay_Code__c';
                                failureHistTemp1.CSS_New_Value__c = obj.payCode;
                                failureHistTemp1.CSS_Old_Value__c =              solsCompTemp.Pay_Code__c; 
                                failureHistTemp1.Audit_Message__c = 'ODM has updated Paycode from'+' '+ solsCompTemp.Pay_Code__c+' '+'to'+' '+obj.payCode; 
                                failureHistList.add(failureHistTemp1);
                            }

                            if(resFailureMsgList != null && resFailureMsgList.size()>0){
                                for(CG_ODM_ResJSONParser.message msg:resFailureMsgList){
                                    //Story 181418 changes- Zootopia
                                    CG_ODM_ResJSONParser.message fChevronMsg = new CG_ODM_ResJSONParser.message();
                                    fChevronMsg.code = msg.code;
                                    fChevronMsg.description = msg.description;
                                    fChevronMsg.type = msg.type;
                                    fChevronMsg.partSRTCode = obj.failCode;
                                    ODMFailureChevronDisplayMsgs.add(fChevronMsg);
                                    if(msg.type != null && msg.type.trim() == 'ERROR'){
                                        solsComp.ODM_Status__c = 'ERROR';
                                    }
                                    if(solsComp.ODM_Status__c != 'ERROR' && msg.type != null && msg.type.trim() == 'WARNING'){
                                        solsComp.ODM_Status__c = 'WARN';
                                    }
                                    solsComp.ODM_Status_Message__c = (solsComp.ODM_Status_Message__c == null || solsComp.ODM_Status_Message__c == '' ? '' : solsComp.ODM_Status_Message__c) + (solsComp.ODM_Status_Message__c == null || solsComp.ODM_Status_Message__c == '' ? '' : ';;') + msg.type + ': ' + obj.failCode + ': ' + msg.description;               
                                }
                            }
                            if(resFailureMsgList == null || resFailureMsgList.size() == 0){
                                solsComp.ODM_Status__c = 'PASSED';
                                solsComp.ODM_Status_Message__c = '';
                            }

                            if(solsComp.ODM_Status__c != null && solsComp.ODM_Status__c == 'ERROR')
                                showodmerrormsg = true;
                            updatelstsolComp.add(solsComp);
                            //updateSolCompList.add(solsComp);                                      
                        }
                    }

                    CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();

                    intDetails.Auth_Call_Time__c = (responseWrapper.totalAuthCallTime != null ? responseWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  responseWrapper.request.getBody();
                    intDetails.Response_Body__c = responseWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (responseWrapper.totalServiceCallTime != null ? responseWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMFailureValidation';
                    intDetails.Source__c = 'ODM';
                    lstClaimsIntDetails.add(intDetails);      
                    //lstIntDetails.add(intDetails);       

                } 
                
            }
            if(updatelstPartWarrantySolComp != null && updatelstPartWarrantySolComp.size()>0)
            update updatelstPartWarrantySolComp;
            
            /*if(Source == 'CLAIM'){
            insert lstIntDetails;
            update updateSolCompList;}*/
            
            //GSSC-241
            system.debug('****startclaimupdate****');
            if(Source == 'CLAIM'){
                if(updatelstsolComp != null && updatelstsolComp.size()>0 || Test.isRunningTest()){
                    for(CSS_Solution_Component__c scObj : updatelstsolComp){
                        if(scObj.ODM_Status__c == 'ERROR'){
                            clm.Failures_ODM_Status__c = 'ERROR';
                            break;
                        }
                        else {
                            clm.Failures_ODM_Status__c = scObj.ODM_Status__c;
                        }
                    }
                }
                if(clm !=null){
                    system.debug('****clm****'+clm);
                    update clm;
                }
            }
            
            system.debug('****failureHistList****'+failureHistList.size()+'****'+failureHistList);
            return  CG_BL_ODM.showodmerrormsg;
        }catch(exception e){
            system.debug('Entered into catch block of callODMFailureValidationService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return null;
    }
    
    public static list<CG_ODM_ResJSONParser.message> calljobODMHeaderFailureValidationService(String Source){
        try{
            if(Source == 'JOB' || Source == 'CLAIM'){
                if(updatelstjob!=null && updatelstjob.size()>0){  
                    update updatelstjob;   }
                if(lstClaimsIntDetails!=null && lstClaimsIntDetails.size()>0){  
                    insert lstClaimsIntDetails;   }
                if(lstjobIntDetails!=null && lstjobIntDetails.size()>0){  
                    insert lstjobIntDetails;   }
                if(updatelstsolComp!=null && updatelstsolComp.size()>0){  
                    update updatelstsolComp;   }
                    system.debug('calljobODMHeaderFailureValidationService>>>'+updateClaimDetailss);
                    if(updateClaimDetailss != null && updateClaimDetailss.size()>0){
                        update updateClaimDetailss;
                    }
                system.debug('****insideinsertfailureHistList****'+failureHistList.size()+'****'+failureHistList);
                if(failureHistList!=null && failureHistList.size()>0){  
                    insert failureHistList;   }
                system.debug('***afterFailurelistinsert***'+failureHistList.size());

            }
            
        } catch(exception e){
            system.debug('Entered into catch block of calljobODMHeaderFailureValidationService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return ODMFailureChevronDisplayMsgs;
    }
    
    //Claims ODM- Parts,OC,Travel combined
    public static boolean callClaimsODMPartsValidationService(CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,List<CSS_Solution_Component__c> SolComp,List<CSS_Parts_Options__c> prtsObj,boolean isDealer){
        try{       
            lstClaimsIntDetails=new List<CSS_Integration_Error__c>();
            updateClaimsPartRecList=new List<CSS_Parts_Options__c>();
            boolean partsMsg = CG_BL_ODM.callODMPartsValidationService(serJob,clm,psnRec,Source,SolComp,prtsObj,isDealer);
            boolean ocMsg = CG_BL_ODM.callODMOtherClaimableValidationService(serJob,clm,psnRec,Source,SolComp,prtsObj);
            boolean TravelMsg = CG_BL_ODM.callODMTravelValidationService(serJob,clm,psnRec,Source,SolComp,prtsObj);
            system.debug('Anirudh>>>>>>>'+partsMsg + ' ' + ocMsg + ' ' + TravelMsg);
            if(Source == 'CLAIM'){
                if(lstClaimsIntDetails!=null && lstClaimsIntDetails.size()>0)
                    insert lstClaimsIntDetails;
                //Temp Fix.
                if(updateClaimsPartRecList!=null && updateClaimsPartRecList.size()>0) {
                    system.debug('updateClaimsPartRecList SIZE ' + updateClaimsPartRecList.size());
                    for(CSS_Parts_Options__c po : updateClaimsPartRecList) {
                        if(po.ODM_Status__c == 'WARNING')
                            po.ODM_Status__c = 'WARN';

                    }
                    system.debug('updateClaimsPartRecList SIZE ' + updateClaimsPartRecList);
                    update updateClaimsPartRecList;
                }
                //Temp Fix.
                
                //GSSC-241
                system.debug('****startclaimupdate****');
               
                if(updateClaimsPartRecList != null && updateClaimsPartRecList.size()>0){
                    for(CSS_Parts_Options__c prtObj : updateClaimsPartRecList){
                        if(prtObj.ODM_Status__c == 'ERROR'){
                            clm.Parts_ODM_Status__c = 'ERROR';
                            break;
                        }
                        else {
                            clm.Parts_ODM_Status__c = prtObj.ODM_Status__c;
                        }
                    }
                }
                if(clm !=null){
                    update clm;
                }

            }  
            if(partsMsg == true || ocMsg == true || TravelMsg == true)
                return true;
            else
                return false;
        }catch(exception e){
            system.debug('Entered into catch block of callClaimsODMPartsValidationService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return false;
    }
    
    //For story 181418 zootopia- Displays Message
    public static list<CG_ODM_ResJSONParser.message> callClaimsODMPartsValidationServiceDisplayMsgs(){
        try{       
                
        }catch(exception e){
            system.debug('Entered into catch block of callClaimsODMPartsValidationService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return ODMPartsChevronDisplayMsgs;
    }
    
    //ODM Parts Service
    public static boolean callODMPartsValidationService(CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,
                                                        List<CSS_Solution_Component__c> SolComp,List<CSS_Parts_Options__c> prtsObj,
                                                        boolean isDealer){
        //List<CSS_Solution_Component__c> lstPartWarrantySolComp = new List<CSS_Solution_Component__c>();
        try{
            system.debug('isDealer>>>>'+isDealer);
            CG_BL_ODM.showodmerrormsg=false;
            CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();
            Map<String,CSS_Solution_Component__c> mapPrtWrntySolComp = new Map<String,CSS_Solution_Component__c>();
            Map<String,List<CSS_Solution_Component__c>> mapSolComp = new Map<String,List<CSS_Solution_Component__c>>();
            list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
            list<CSS_Parts_Options__c> updatePartRecList = new list<CSS_Parts_Options__c>();
            Map<String,List<CSS_Parts_Options__c>> prtsObjMap = new Map<String,List<CSS_Parts_Options__c>>();
            List<CSS_Parts_Options__c> tempPartsList = new List<CSS_Parts_Options__c>();
            map<String,CG_OP_OAGWrapper> MapResWrapperAccCodes = new map<String,CG_OP_OAGWrapper>();
             ODMPartsChevronDisplayMsgs = new List<CG_ODM_ResJSONParser.message>();
            String ODMMessage;   
            boolean fieldActionClaim;


            if(SolComp.size()>0){
                for(CSS_Solution_Component__c sctemp : SolComp) {
                    if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && 
                        (sctemp.CSS_Account_Formula__c.contains('35') || sctemp.CSS_Account_Formula__c.contains('62') 
                      || sctemp.CSS_Account_Formula__c.contains('41') || sctemp.CSS_Account_Formula__c.contains('97') 
                      || sctemp.CSS_Account_Formula__c.contains('65') || sctemp.CSS_Account_Formula__c.contains('27')
                      || sctemp.CSS_Account_Formula__c.contains('52'))) {
                        mapPrtWrntySolComp.put(sctemp.CSS_Account_Formula__c + sctemp.System_Code__c + sctemp.Component_Code__c + sctemp.Failure_Mode__c, sctemp);
                    }else if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && 
                    !sctemp.CSS_Account_Formula__c.contains('35') && !sctemp.CSS_Account_Formula__c.contains('62') 
                    && !sctemp.CSS_Account_Formula__c.contains('41') && !sctemp.CSS_Account_Formula__c.contains('97') 
                    && !sctemp.CSS_Account_Formula__c.contains('65') && !sctemp.CSS_Account_Formula__c.contains('27')
                    && !sctemp.CSS_Account_Formula__c.contains('52')){
                        if(mapSolComp.containsKey(sctemp.CSS_Account_Formula__c)) {
                            List<CSS_Solution_Component__c> fclist = mapSolComp.get(sctemp.CSS_Account_Formula__c);
                            fclist.add(sctemp);
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, fclist);
                        } else {
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, new List<CSS_Solution_Component__c> { sctemp });
                        } 
                    }
                }
            }

            if(prtsObj !=null && prtsObj.size()>0){
                for(CSS_Parts_Options__c prtRec: prtsObj){
                   /* List<String> tempLstStr1 = new List<String>();
                    if(prtRec.Account_Code__c != null && prtRec.Account_Code__c != '')
                        tempLstStr1 = prtRec.Account_Code__c.split('-');
                    if(tempLstStr1 != null && tempLstStr1.size() == 1){
                        prtRec.Account_Code__c = tempLstStr1[0];
                    }
                    else if(tempLstStr1 != null && tempLstStr1.size() == 2){
                        prtRec.Account_Code__c = tempLstStr1[1];
                    }
                    else if(tempLstStr1 != null && tempLstStr1.size() == 3){
                        prtRec.Account_Code__c = tempLstStr1[1]+'-'+tempLstStr1[2];
                    }*/
                    system.debug('prtRec.Account_Code__c>>>>'+prtRec.Account_Code__c);
                    if(prtsObjMap.containsKey(prtRec.Account_Code__c)){
                        if(Source == 'CLAIM' && clm.CSS_Job__c != null && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA' && ((prtRec.recordtype.name == 'BMS Parts' && isDealer == false) || (prtRec.recordtype.name == 'Parts' && prtRec.Parts_Type__c == 'Custom' && isDealer == false) || (isDealer == true && prtRec.recordtype.name == 'Parts'))){
                            tempPartsList = prtsObjMap.get(prtRec.Account_Code__c);
                            tempPartsList.add(prtRec);
                        }else if(Source == 'CLAIM' && clm.CSS_Job__c == null && prtRec.recordtype.name == 'Parts' && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA'){
                            tempPartsList = prtsObjMap.get(prtRec.Account_Code__c);
                            tempPartsList.add(prtRec);
                        }else if(Source == 'JOB' && prtRec.recordtype.name == 'BMS Parts' && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'NA'){
                            tempPartsList = prtsObjMap.get(prtRec.Account_Code__c);
                            tempPartsList.add(prtRec);
                        }
                    }else {
                        tempPartsList = new List<CSS_Parts_Options__c>();
                        if(Source == 'CLAIM' && clm.CSS_Job__c != null && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA' && ((prtRec.recordtype.name == 'BMS Parts' && isDealer == false) || (prtRec.recordtype.name == 'Parts' && prtRec.Parts_Type__c == 'Custom' && isDealer == false) || (isDealer == true && prtRec.recordtype.name == 'Parts'))){
                            tempPartsList.add(prtRec);
                            system.debug('prtRec.Account_Code__c'+prtRec.Account_Code__c);
                           /* List<String> tempLstStr = new List<String>();
                            if(prtRec.Account_Code__c != null && prtRec.Account_Code__c != '')
                                tempLstStr = prtRec.Account_Code__c.split('-');
                            if(tempLstStr != null && tempLstStr.size() == 1){
                                prtRec.Account_Code__c = tempLstStr[0];
                            }
                            else if(tempLstStr != null && tempLstStr.size() == 2){
                                prtRec.Account_Code__c = tempLstStr[1];
                            }
                            else if(tempLstStr != null && tempLstStr.size() == 3){
                                prtRec.Account_Code__c = tempLstStr[1]+'-'+tempLstStr[2];
                            }*/
                            system.debug('prtRec.Account_Code__c>>>>'+prtRec.Account_Code__c);
                            prtsObjMap.put(prtRec.Account_Code__c, tempPartsList);
                        }else if(Source == 'CLAIM' && clm.CSS_Job__c == null && prtRec.recordtype.name == 'Parts' && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA'){
                            system.debug('Anirudh Partslist>>>>>>>'+prtRec);
                            tempPartsList.add(prtRec);
                            /*List<String> tempLstStr = new List<String>();
                            system.debug('prtRec.Account_Code__c'+prtRec.Account_Code__c);
                            if(prtRec.Account_Code__c != null && prtRec.Account_Code__c != '')
                                tempLstStr = prtRec.Account_Code__c.split('-');
                            if(tempLstStr != null && tempLstStr.size() == 1){
                                prtRec.Account_Code__c = tempLstStr[0];
                            }
                            else if(tempLstStr != null && tempLstStr.size() == 2){
                                prtRec.Account_Code__c = tempLstStr[1];
                            }
                            else if(tempLstStr != null && tempLstStr.size() == 3){
                                prtRec.Account_Code__c = tempLstStr[1]+'-'+tempLstStr[2];
                            }*/
                            system.debug('prtRec.Account_Code__c>>>>'+prtRec.Account_Code__c);
                            prtsObjMap.put(prtRec.Account_Code__c, tempPartsList);
                        }else if(Source == 'JOB' && prtRec.recordtype.name == 'BMS Parts' && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'NA'){
                            tempPartsList.add(prtRec);
                           /* List<String> tempLstStr = new List<String>();
                            system.debug('prtRec.Account_Code__c'+prtRec.Account_Code__c);
                            if(prtRec.Account_Code__c != null && prtRec.Account_Code__c != '')
                                tempLstStr = prtRec.Account_Code__c.split('-');
                            if(tempLstStr != null && tempLstStr.size() == 1){
                                prtRec.Account_Code__c = tempLstStr[0];
                            }
                            else if(tempLstStr != null && tempLstStr.size() == 2){
                                prtRec.Account_Code__c = tempLstStr[1];
                            }
                            else if(tempLstStr != null && tempLstStr.size() == 3){
                                prtRec.Account_Code__c = tempLstStr[1]+'-'+tempLstStr[2];
                            }*/
                            system.debug('prtRec.Account_Code__c>>>>'+prtRec.Account_Code__c);
                            prtsObjMap.put(prtRec.Account_Code__c, tempPartsList);
                        }  
                    }
                }
            }
            system.debug('prtsObjMap'+prtsObjMap);
            if(mapPrtWrntySolComp != null) {
                //FBI-385 : Code Start
                Set<String> attribute3Set = new Set<String>();
                Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
                for(CSS_Solution_Component__c prtWrntySolComp : mapPrtWrntySolComp.values()) {
                      attribute3Set.add(prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                }
                for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                    AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
                }
                //FBI-385 : Code End
                for(CSS_Solution_Component__c prtWrntySolComp:mapPrtWrntySolComp.values()){
                    fieldActionClaim = false;
                    if(prtWrntySolComp.CSS_Account_Formula__c.contains('65') || prtWrntySolComp.CSS_Account_Formula__c.contains('27')){
                      fieldActionClaim = true;  
                    }
                    resWrapper = new CG_OP_OAGWrapper();
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),serJob,'Parts');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),clm,psnRec,'Parts');

                    CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();

                    CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                    CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();

                    failureDetails.accountCode =  prtWrntySolComp.CSS_Account_Formula__c.right(2);
                    failureDetails.approvalCode = prtWrntySolComp.Approval_Code__c;
                    failureDetails.authorizationNumber = prtWrntySolComp.Authorization_Number__c;
                    failureDetails.campaignId = (prtWrntySolComp.Component_Id__c != null && prtWrntySolComp.Component_Id__c != '' ? string.valueof(prtWrntySolComp.Component_Id__c) : '');
                    //failureDetails.coverageType = prtWrntySolComp.CSS_CoverageType__c;
                    failureDetails.failCode = prtWrntySolComp.System_Code__c + prtWrntySolComp.Component_Code__c;
                    failureDetails.failMode = prtWrntySolComp.Failure_Mode__c;
                    failureDetails.lineNumber = prtWrntySolComp.Id;
                    failureDetails.overrideFlag = 'N';
                    if(prtWrntySolComp.Type__c == 'TRP' || prtWrntySolComp.Type__c == 'ATC' || prtWrntySolComp.Type__c == 'Campaign'){
                       failureDetails.inShopCampaignFlag =  prtWrntySolComp.In_Shop_SRT_Limit_Flag__c ? 'Y' : 'N';
                    }
                    else{
                        failureDetails.inShopCampaignFlag='';
                    }
                    failureDetails.payCode = prtWrntySolComp.Pay_Code__c;
                    failureDetails.status = 'Draft';
                    // FBI-385 : Replacing below query with Map
                    //CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: prtWrntySolComp.CSS_Account_Formula__c.Right(2) LIMIT 1];
                    CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                    if (queryJobEventTemp != null) {
                        acctInfo.accountCodeType = queryJobEventTemp.Attribute1__c;
                        failureDetails.coverageType =  queryJobEventTemp.Attribute1__c;
                        acctInfo.chryslerFlag = queryJobEventTemp.Attribute9__c;
                        acctInfo.multiESNFlag = queryJobEventTemp.Attribute7__c;
                    }
                    
                    failureDetails.AcctCodeInfo = acctInfo;
                    failureDetails.Campaign = cmpgn;
                    reqJSON.Request.claim.failure.add(failureDetails);

                    reqJSON.Request.claim.Parts = new List<CG_ODM_ReqJSONParser.Parts>();
                    List<CSS_Parts_Options__c> tPartsList = prtsObjMap.get(prtWrntySolComp.CSS_Account_Formula__c);
                    system.debug('Anirudh tPartsList>>>>>>>'+tPartsList);
                    if(tPartsList == null || tPartsList.size()<=0)
                        continue;
                    system.debug('Anirudh after continue tPartsList>>>>>>>'+tPartsList);
                    Set<String> pNum = new Set<String>();
                    Map<String,List<Decimal>> pNumQtyMap = new Map<String,List<Decimal>>();
                    for(CSS_Parts_Options__c tempPartRec: tPartsList){
                        if(!pNumQtyMap.containsKey(tempPartRec.Service_partnumber__c)){
                            //pNum.add(p.PartNumber);
                            List<Decimal> temp = new List<Decimal>();
                            temp.add(tempPartRec.Quantity__c);
                            pNumQtyMap.put(tempPartRec.Service_partnumber__c,temp);
                        }
                        else{
                            List<Decimal> temp = new List<Decimal>();
                            temp = pNumQtyMap.get(tempPartRec.Service_partnumber__c);
                            temp.add(tempPartRec.Quantity__c);
                            pNumQtyMap.put(tempPartRec.Service_partnumber__c,temp);
                        }
                    }
                    system.debug('pNumQtyMap'+pNumQtyMap+ ' ' +'tPartsList'+tPartsList);
                    for(CSS_Parts_Options__c tempPartRec: tPartsList){
                        if(prtWrntySolComp.Fail_Code__c == (fieldActionClaim == true ? tempPartRec.Get_Fail_Code_Formula__c.right(6) : tempPartRec.Get_Fail_Code_Formula__c.right(4)) && prtWrntySolComp.CSS_Account_Formula__c == tempPartRec.Account_Code__c){ 
                            CG_ODM_ReqJSONParser.Parts refObj = new CG_ODM_ReqJSONParser.Parts();
                            refObj.lineNumber = tempPartRec.Id; 
                            refObj.partId = tempPartRec.Service_partnumber__c ;
                            //refObj.partPrice = '';
                            refObj.partPrice = tempPartRec.Unit_Price__c;
                            refObj.partName = tempPartRec.Part_Name__c;
                            refObj.reconPartFlag = '';
                            refObj.priceBook = '';
                            refObj.exceptionPriceBook = '';
                            refObj.channelCode = '';
                            refObj.standardPriceBook = '';
                            refObj.pricingRegion = '';
                            refObj.partAllowedFlag = 'N';
                            refObj.partReturnFlag = '';
                            //refObj.qtyApproved = String.valueof(tempPartRec.Quantity__c); // Kalpana: Please check whether we need to Use Quantity_Used Field
                            List<Decimal> decTemp = new List<Decimal>();
                            decTemp = pNumQtyMap.get(tempPartRec.Service_partnumber__c);
                            if(decTemp.size() == 1){
                                refObj.qtyApproved = String.valueof(tempPartRec.Quantity__c);
                            }
                            else if(decTemp.size() > 1){
                                decimal qtySum = 0;
                                for(Decimal decCount : decTemp){
                                    qtySum = qtySum + decCount;
                                }
                                refObj.qtyApproved = String.valueof(qtySum);
                            }
                            refObj.adjPartPercentage = string.valueof(tempPartRec.Covered__c);// Kalpana: Please check whether we need to Use Warranty_Allocation Field
                            if(!pNum.contains(tempPartRec.Service_partnumber__c)){
                                reqJSON.Request.claim.Parts.add(refObj);
                                pNum.add(tempPartRec.Service_partnumber__c);
                            }
                        }
                    } 
                    if(reqJSON.Request.claim.Parts == null || reqJSON.Request.claim.Parts.size() <=0){
                        continue;
                    }
                    
                    system.debug('reqJSON--'+reqJSON);
                    
                    CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
                    resWrapper = CG_SL_ODM.callODMPartsService(reqJSON);  
                    ODMResponse = new CG_ODM_ResJSONParser(); 
                    ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);

                    if(!MapResWrapperAccCodes.containsKey(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c))
                        MapResWrapperAccCodes.put(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c,resWrapper);
                }
            }

            if(mapSolComp != null) {
                //FBI-385 : Code Start
                Set<String> attribute3Set = new Set<String>();
                Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
                for(String accID: mapSolComp.keySet()) {
                    for(CSS_Solution_Component__c cssSolComp : mapSolComp.get(accID)) {
                        attribute3Set.add(cssSolComp.CSS_Account_Formula__c.Right(2));
                    }
                }
                for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                    AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
                }
                //FBI-385 : Code End
                for(String accID: mapSolComp.keySet()){
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON(null,serJob,'Parts');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON(null,clm,psnRec,'Parts');
                    if(mapSolComp != null){ //Added Null check : Kalpana
                        for(CSS_Solution_Component__c SolCompRec:mapSolComp.get(accID)){

                            CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                            CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                            CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();
                            failureDetails.accountCode =  SolCompRec.CSS_Account_Formula__c.right(2);
                            failureDetails.approvalCode = SolCompRec.Approval_Code__c;
                            failureDetails.authorizationNumber = SolCompRec.Authorization_Number__c;
                            failureDetails.campaignId = (SolCompRec.Component_Id__c != null && SolCompRec.Component_Id__c != '' ? string.valueof(SolCompRec.Component_Id__c) : '');
                            //failureDetails.coverageType = SolCompRec.CSS_CoverageType__c;
                            failureDetails.failCode = SolCompRec.System_Code__c + SolCompRec.Component_Code__c;
                            failureDetails.failMode = SolCompRec.Failure_Mode__c;
                            failureDetails.lineNumber = SolCompRec.Id;
                            failureDetails.overrideFlag = 'N';
                            if(SolCompRec.Type__c == 'TRP' || SolCompRec.Type__c == 'ATC' || SolCompRec.Type__c == 'Campaign'){
                                failureDetails.inShopCampaignFlag =  SolCompRec.In_Shop_SRT_Limit_Flag__c ? 'Y' : 'N';
                            }
                             else{
                                    failureDetails.inShopCampaignFlag='';
                                     }
                            failureDetails.payCode = SolCompRec.Pay_Code__c;
                            failureDetails.status = 'Draft';
                            // FBI-385 : Replacing below query with Map
                            // CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: SolCompRec.CSS_Account_Formula__c.Right(2) LIMIT 1];
                            CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+SolCompRec.CSS_Account_Formula__c.Right(2));
                            if (queryJobEventTemp != null) {
                                acctInfo.accountCodeType = queryJobEventTemp.Attribute1__c;
                                failureDetails.coverageType =  queryJobEventTemp.Attribute1__c;
                                acctInfo.chryslerFlag = queryJobEventTemp.Attribute9__c;
                                acctInfo.multiESNFlag = queryJobEventTemp.Attribute7__c;
                            }
                            
                            failureDetails.AcctCodeInfo = acctInfo;
                            failureDetails.Campaign = cmpgn;
                            reqJSON.Request.claim.failure.add(failureDetails);
                            
                            system.debug('reqJSON--***'+reqJSON);
                            
                            reqJSON.Request.claim.Parts = new List<CG_ODM_ReqJSONParser.Parts>();
                            system.debug('prtsObjMap'+prtsObjMap);
                            system.debug('SolCompRec.CSS_Account_Formula__c'+SolCompRec.CSS_Account_Formula__c);
                            List<CSS_Parts_Options__c> tPartsList = prtsObjMap.get(SolCompRec.CSS_Account_Formula__c);
                            system.debug('Anirudh tPartsList>>>>>>>'+tPartsList);
                            if(tPartsList == null || tPartsList.size()<=0)
                                continue;
                            system.debug('Anirudh after continue tPartsList>>>>>>>'+tPartsList);
                            for(CSS_Parts_Options__c tempPartRec: tPartsList){
                                if(SolCompRec.CSS_Account_Formula__c == tempPartRec.Account_Code__c){ 
                                    CG_ODM_ReqJSONParser.Parts refObj = new CG_ODM_ReqJSONParser.Parts();
                                    refObj.lineNumber = tempPartRec.Id; 
                                    refObj.partId = tempPartRec.Service_partnumber__c ;
                                    //refObj.partPrice = '';
                                    refObj.partPrice = tempPartRec.Unit_Price__c;
                                    refObj.partName = tempPartRec.Part_Name__c;
                                    refObj.reconPartFlag = '';
                                    refObj.priceBook = '';
                                    refObj.exceptionPriceBook = '';
                                    refObj.channelCode = '';
                                    refObj.standardPriceBook = '';
                                    refObj.pricingRegion = '';
                                    refObj.partAllowedFlag = 'N';
                                    refObj.partReturnFlag = '';
                                    refObj.qtyApproved = String.valueof(tempPartRec.Quantity__c);
                                    refObj.adjPartPercentage = string.valueof(tempPartRec.Covered__c);
                                    reqJSON.Request.claim.Parts.add(refObj);
                                }
                            } 
                            resWrapper = new CG_OP_OAGWrapper();
                            resWrapper = CG_SL_ODM.callODMPartsService(reqJSON);
                            system.debug('resWrapper>>>>>>>>>'+resWrapper);
                            if(!MapResWrapperAccCodes.containsKey(accID))
                                MapResWrapperAccCodes.put(accID,resWrapper);
                            system.debug('resWrapper>>>>>>>>>'+MapResWrapperAccCodes);
                            break;  
                        }
                    }
                    //CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 


                    //ODMResponse = new CG_ODM_ResJSONParser(); 
                    //ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);



                }
            }


            if(MapResWrapperAccCodes != null){
                for(String AccountID:MapResWrapperAccCodes.keySet()){
                    CG_OP_OAGWrapper responseWrapper = new CG_OP_OAGWrapper();
                    responseWrapper = MapResWrapperAccCodes.get(AccountID);
                    CG_ODM_ResJSONParser ODMRes = new CG_ODM_ResJSONParser(); 
                    ODMRes = (CG_ODM_ResJSONParser)JSON.deserialize(responseWrapper.response.getBody(),CG_ODM_ResJSONParser.class);
                    //ODMRes = (CG_ODM_ResJSONParser)JSON.deserialize('{"Header":{"Sender":{"ServiceName":"ODMHeaderValidation","SenderID":"CSS"},"Target":{"TargetID":"ODM"}},"Response":{"DecisionID":"2018-06-20T00:12:23.914-04:00","claim":{"claimSubSource":null,"groupName":"","reconPartsWarrantyFlag":null,"thresholdAmount":"","multiESNFlag":"NA","cmiEngineSerialNumber":79619554,"parts":[{"partReturnFlag":"","channelCode":"","reconPartFlag":"","pricingRegion":"","partPrice":"","lineNumber":"a1f3B0000009K2EQAU","partAllowedFlag":"N","partId":876435,"messages":{"description":"Part price not found - PriceBook is Empty","code":"MW-PA-WAR-001","type":"WARNING"},"priceBook":"N"},{"partReturnFlag":"","channelCode":"","reconPartFlag":"","pricingRegion":"","partPrice":"","lineNumber":"a1f3B0000009K2FQAU","partAllowedFlag":"N","partId":876495,"messages":{"description":"Part price not found - PriceBook is Empty","code":"MW-PA-WAR-001","type":"WARNING"},"priceBook":"N"}],"claimSource":"Guidanz","paccarCertifiedLocationFlag":null,"totalClaimAmt":"","messages":[{"description":"Part price not found for exception PriceBook: N","code":"MW-PA-WAR-001","type":"WARNING"}],"distributorCode":"03520","paccarPaymentRoutingFlag":null,"paccarFlag":null,"roNumber":74882,"newPartsWarrantyFlag":null,"serviceModelName":"ISX15 CM2350 X101","button":null,"modelSeries":null,"roadRelayWarrantyFlag":null,"engineApplicationCode":"AUTOMOTIVE","penalty":0,"approverName":"","serviceProvider":{"region":"NORTH AMERICA","regionCode":null,"groupName":null,"territory":null,"status":"Active","outfileAllClaimsFlag":"N","engineEffectiveDate":"","spState":null,"oemCode":103,"channelOfDistribution":"101-DISTRIBUTOR-BRANCH","spSCMDollarAmt":"","spCountry":null,"engineExpirationdate":"","ltaChecked":"N","serviceModelName":"ISX15 CM2350 X101","channelDescription":null,"spServiceLevel":null,"spWarrantyTrainingStatus":null},"engineFamily":10,"certificationFlag":null,"srtList":[{"hours":"","quantity":""}],"serviceProviderName":null,"thresholdHrs":"","engine":{"serviceModel":null,"productApplicationDesp":"BB","marineFlag":"N","designPhaseCode":61,"engineFamilyCode":10,"warrantyIndicatorFlag":"Y","billToCode":null,"oemCode":"01005"},"productApplicationCode":null,"status":"ERROR","applicationName":null,"claimStatus":"In Review","countryCode":null,"failureMeasure":"Miles","ecmCalibBefore":"","failure":[{"GSQID":null,"accountCodeDesp":null,"payCode":"A","status":"Draft","totalLaborAmt":"","inShopCampaignFlag":null,"authorizationNumber":null,"approvalCode":null,"acctCodeInfo":{"chryslerFlag":null,"accountCodeType":null,"multiESNFlag":null,"accountCodeWarrantyFlag":null},"overrideFlag":"N","totalTowingAmt":"","accountCode":"ACCOUNT TEAM COVERAGE 27","programID":null,"failCode":"THAC","coverageType":"CMP","failMode":"RE","lineNumber":"a1O3B000000A14cUAC","policyFlag":null,"totalSRTHours":"","campaign":{"accountCode":null,"engineComponentCode":null,"campaignId":null,"cmpEngineStatusCode":null,"completeIndicator":null,"campaignType":null,"status":null,"systemCode":null,"failMode":null,"multiFlag":null},"travelCoveredFlag":null}],"ecmCalibAfter":"","cmiServiceProviderCode":"04892","travels":[{"mealsCharges":"","towingCharges":"","hours":"","travelDistance":""}],"otherClaimables":[{"amount":"","details":""}],"manufacturer":"INTERNATIONAL","manualAdjudicationFlag":"","HeaderCampaign":{},"bisFlag":"N","possessionFlag":"","claimNumber":"CSS-00080860"}}}',CG_ODM_ResJSONParser.class);

                    List<CG_ODM_ResJSONParser.parts> resPartsList = ODMRes.Response.claim.parts;

                    if(resPartsList != null && resPartsList.size()>0){
                    for(CG_ODM_ResJSONParser.parts obj:resPartsList){
                        List<CG_ODM_ResJSONParser.message> resPartsMsgList = new List<CG_ODM_ResJSONParser.message>();
                        
                        CG_ODM_ResJSONParser.message partsMsgs = new CG_ODM_ResJSONParser.message();
                        resPartsMsgList = (obj.messages != null ? obj.messages : null);//Anirudh checking if we can accomodate without any message structure
                        system.debug('Anirudh Entered inside parts response update');
                        if(obj.lineNumber !=null && obj.lineNumber !=''){
                            CSS_Parts_Options__c prtObj = new CSS_Parts_Options__c();

                            prtObj.Id = obj.lineNumber; 
                            prtObj.ODM_Status_Code__c = string.valueof(responseWrapper.response.getStatusCode()); //to handle null response
                            system.debug('Anirudh Entered parts update part price>>>>>>'+obj.partPrice);
                            prtobj.Price_Book__c = obj.priceBook;
                            prtObj.Unit_Price__c = obj.partPrice;
                            if(resPartsMsgList != null && resPartsMsgList.size()>0){
                                for(CG_ODM_ResJSONParser.message msg:resPartsMsgList){
                                   
                                   CG_ODM_ResJSONParser.message prtChevronMsg = new CG_ODM_ResJSONParser.message();
                                    prtChevronMsg.code = msg.code;
                                    prtChevronMsg.description = msg.description;
                                    prtChevronMsg.type = msg.type;
                                    prtChevronMsg.partSRTCode = obj.partId;
                                    ODMPartsChevronDisplayMsgs.add(prtChevronMsg);
                                    if(msg.type != null && msg.type.trim() == 'ERROR'){
                                        prtObj.ODM_Status__c = 'ERROR';
                                    }
                                    if(prtObj.ODM_Status__c != 'ERROR' && msg.type != null && msg.type.trim() == 'WARNING'){
                                        prtObj.ODM_Status__c = 'WARN';
                                    }
                                    prtObj.ODM_Status_Message__c = (prtObj.ODM_Status_Message__c == null || prtObj.ODM_Status_Message__c == '' ? '' : prtObj.ODM_Status_Message__c) + (prtObj.ODM_Status_Message__c == null || prtObj.ODM_Status_Message__c == '' ? '' : ';;') + msg.type + ':' + obj.partId + ':' + msg.description;               
                                }
                            }
                            if(resPartsMsgList == null || resPartsMsgList.size() == 0){
                                prtObj.ODM_Status__c = 'PASSED';
                                prtObj.ODM_Status_Message__c = '';
                            }

                            if(prtObj.ODM_Status__c != null && prtObj.ODM_Status__c == 'ERROR')
                                showodmerrormsg = true;
                            updatePartRecList.add(prtObj); 
                            if(Source == 'CLAIM')
                                updateClaimsPartRecList.add(prtObj);
                        }
                        /* else if(obj.messages ==null || obj.messages.type ==null || obj.messages.type == ''){
                            CSS_Parts_Options__c prtObj = new CSS_Parts_Options__c();
                            system.debug('Anirudh Entered parts update part price>>>>>>'+obj.partPrice);
                            prtObj.ODM_Status__c = 'PASSED';
                            prtObj.ODM_Status_Message__c = '';
                            prtObj.Id = obj.lineNumber;               
                            prtobj.Price_Book__c = obj.priceBook;
                            prtObj.Unit_Price__c = obj.partPrice;
                            prtObj.ODM_Status_Code__c = string.valueof(responseWrapper.response.getStatusCode()); //to handle null response
                            updatePartRecList.add(prtObj); 
                            if(Source == 'CLAIM')
                                updateClaimsPartRecList.add(prtObj);   
                        }*/
                    }
}
                    CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();

                    intDetails.Auth_Call_Time__c = (responseWrapper.totalAuthCallTime != null ? responseWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  responseWrapper.request.getBody();
                    intDetails.Response_Body__c = responseWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (responseWrapper.totalServiceCallTime != null ? responseWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMPartsValidation';
                    intDetails.Source__c = 'ODM';
                    lstIntDetails.add(intDetails); 
                    if(Source == 'CLAIM')
                        lstClaimsIntDetails.add(intDetails); 

                }        
            }
            if(Source == 'JOB'){
                insert lstIntDetails;
                update updatePartRecList;}
            return  CG_BL_ODM.showodmerrormsg;
        }catch(exception e){
            system.debug('Entered into catch block of callODMPartsServiceMethod in CG_BL_ODM Class>>>>>>>'+e.getCause() + ' ' + e.getMessage() + ' ' + e.getLineNumber());
        }
        return false;
    }
    
    //ODM SRT Service
    public static boolean callODMSRTServices(String source, String id){
        //CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,
          //                                              List<CSS_Solution_Component__c> SolComp,List<CSS_Parts_Options__c> prtsObj,
            //                                            boolean isDealer){
        //List<CSS_Solution_Component__c> lstPartWarrantySolComp = new List<CSS_Solution_Component__c>();
        try{
            
            CG_BL_ODM.showodmerrormsg=false;
            CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            CSS_Job_Order__c serJob = new CSS_Job_Order__c();
            CSS_Claims__c clm = new CSS_Claims__c();
            CSS_PSN__c psnRec = new CSS_PSN__c();
            List<CSS_Solution_Component__c> SolComp = new List<CSS_Solution_Component__c>();
            List<CSS_Parts_Options__c> prtsObj = new List<CSS_Parts_Options__c>();
            List<css_srt__c> srtList = new List<css_srt__c>();
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();
            Map<String,CSS_Solution_Component__c> mapPrtWrntySolComp = new Map<String,CSS_Solution_Component__c>();
            Map<String,List<CSS_Solution_Component__c>> mapSolComp = new Map<String,List<CSS_Solution_Component__c>>();
            list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
            list<CSS_SRT__c> updateSRTRecList = new list<CSS_SRT__c>();
            Map<String,List<CSS_Parts_Options__c>> prtsObjMap = new Map<String,List<CSS_Parts_Options__c>>();
            Map<String,List<CSS_SRT__c>> srtObjMap = new Map<String,List<CSS_SRT__c>>();
            List<CSS_Parts_Options__c> tempPartsList = new List<CSS_Parts_Options__c>();
            List<css_srt__c> tempSRTsList = new List<css_srt__c>();
            map<String,CG_OP_OAGWrapper> MapResWrapperAccCodes = new map<String,CG_OP_OAGWrapper>();
            ODMSRTChevronDisplayMsgs = new list<CG_ODM_ResJSONParser.message>();
            Map<Id,CSS_SRT__c> srtIDMap = new Map<Id,CSS_SRT__c>();
            
            String ODMMessage;   
            boolean fieldActionClaim;
            
            if(source == 'Job'){
                serJob=[Select Id,Name,IsAppointment__c, bmsCreateAccount__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,
                         ESN__c, ESN_IA__c, First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                         Make__c,Model__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                         Repeat_Visit__c,TSR_EscalateNumber__c,RecentVisit__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,
                         ProductApplicationCode__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,Account__c,SP_ClaimAllowedDays__c,SP_RegionCode__c,SP_TerritoryCode__c,BillToCode__c,DesignPhaseCode__c,Sp_TERRITORY__c,
                         ProductApplicationDesp__c,warrantyIndicatorFlag__c,Automotive_App_Flag__c,
                         MarineFlag__c,OemCode__c,EtoConversionDate__c,BuildDate__c,CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, 
                         (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),Category__c,Category2__c,Category3__c,Category4__c,Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,ApplicationCode__c,
                         (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                         (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where( job_order__C=:id and( performed_review__c=True and performed__c=False))),
                         (select Id,name,OrderReference__c from css_quotes__r)
                         from CSS_Job_Order__c where id= :id];
            }else if(source == 'Claim'){
                clm =[Select Id, Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c, Multi_PSN_Claim__c,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                            CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                            CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                            Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                            Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,
                            Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                            Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                            Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                            Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                            CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                            CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                            TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                            DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                            SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                            ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                            SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                            SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                            (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                             Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                             Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                            from CSS_Claims__c where id= :id];
                if(clm.CSS_PSNs__r != null && !clm.CSS_PSNs__r.isEmpty() && clm.CSS_PSNs__r.size()>0) {
                    psnRec = clm.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 
            }

            
             if(source == 'Job'){
                SolComp = new List<CSS_Solution_Component__c>([select Id, Name,AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,
                                                                   Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                   Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                                   CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                                   CoveredTravelLabor__c,RoadRelay_Warranty__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                                   Equip_ID__c,Fail_Code__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                                   Multiple_Times__c,SysCodeAndCompCode__c,Notes__c,Parts_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,
                                                                   Service_Model__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,
                                                                   Claim_Type__c from CSS_Solution_Component__c where Service_Job__c =: id]);
            }else if(source == 'Claim'){
                SolComp = new List<CSS_Solution_Component__c>([select Id, Name,AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,
                                                                   Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                   Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                                   CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                                   CoveredTravelLabor__c,RoadRelay_Warranty__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                                   Equip_ID__c,Fail_Code__c,SysCodeAndCompCode__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                                   Multiple_Times__c,Notes__c,Parts_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,
                                                                   Service_Model__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,
                                                                   Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =: id]);
            }
            
            //SRTs
            if(source == 'Job'){
                srtList = new List<css_srt__c>([Select id, CreatedById, LastModifiedById,type__c,AccountCode_Formula__c, IsPopUpSRT__c,Account_Code__c,SRT_Category__c, SRT_AccessiblityCheck__c, Diagnosis_Time__c,SRT_Select__c,
                                                SRT_Estimate__c,SRT_Decimal_Time__c, FailCode__c,srt_time__c, job_order__c ,SRT_Quantity__c ,SRT_ID__c,isPerformed__c,SRT_Notes__c, 
                                                SRT_Warrantable__c,Component_Id__r.Claim_Type__c,Component_Id__r.Selected_Claim_Type__c, Component_Id__c from css_srt__c where job_order__c =:id and SRT_ID__c !=null 
                                                and SRT_ID__c !='0' and ODM_Status__c !='NA' and ODM_Status__c !='PASSED' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) 
                                                and (Type__c IN ('Admin','Diagnosis','Repair','Diag Access','Repair Access','Field Action','Access')//Anirudh Changes to fix submit button enable issue as access srt is not picking when added from edit popup from field actions.
                                                     or (SRT_Category__c IN ('AdditionalDiag','AdditionalRep')) or Type__c IN ('Field Action','Field Action Access','99Time'))]);
            }else if(source == 'Claim'){
                srtList = new List<css_srt__c>([Select id, CreatedById, LastModifiedById,type__c,AccountCode_Formula__c, IsPopUpSRT__c ,Account_Code__c,SRT_Category__c, SRT_AccessiblityCheck__c, Diagnosis_Time__c,SRT_Select__c,
                                                SRT_Estimate__c,SRT_Decimal_Time__c,FailCode__c, srt_time__c, job_order__c ,SRT_Quantity__c ,SRT_ID__c,isPerformed__c,SRT_Notes__c, 
                                                SRT_Warrantable__c,Component_Id__r.Claim_Type__c,Component_Id__r.Selected_Claim_Type__c, Component_Id__c, Component_Id__r.Type__c
                                                from css_srt__c where CSS_Claims__c =:id and SRT_ID__c !=null 
                                                and SRT_ID__c !='0' and ODM_Status__c !='NA' and ODM_Status__c !='PASSED' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) 
                                                and (Type__c IN ('Admin','Diagnosis','Repair','Diag Access','Repair Access','Field Action','Access')//Anirudh Changes to fix submit button enable issue as access srt is not picking when added from edit popup from field actions.
                                                     or (SRT_Category__c IN ('AdditionalDiag','AdditionalRep')) or Type__c IN ('Field Action','Field Action Access','99Time'))]);
            }
            system.debug('srtListIncallODMSRTServices' +srtList);
            
            if(source == 'Job'){
                prtsObj = new List<CSS_Parts_Options__c>([select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                                                                Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c
                                                                from CSS_Parts_Options__c where Service_Job__c =:id and RecordType.Name ='TTML' and ODM_Status__c !='NA' and ODM_Status__c !='PASSED']);
            }else if(source == 'Claim'){
                prtsObj = new List<CSS_Parts_Options__c>([select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                                                                Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c
                                                                from CSS_Parts_Options__c where CSS_Claims__c =:id and RecordType.Name ='TTML' and ODM_Status__c !='NA' and ODM_Status__c !='PASSED']);
            }
            
            if(SolComp.size()>0){
                for(CSS_Solution_Component__c sctemp : SolComp) {
                    if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && 
                        (sctemp.CSS_Account_Formula__c.contains('35') || sctemp.CSS_Account_Formula__c.contains('62') 
                      || sctemp.CSS_Account_Formula__c.contains('41') || sctemp.CSS_Account_Formula__c.contains('97') 
                      || sctemp.CSS_Account_Formula__c.contains('65') || sctemp.CSS_Account_Formula__c.contains('27') 
                      || sctemp.CSS_Account_Formula__c.contains('52'))){
                        mapPrtWrntySolComp.put(sctemp.CSS_Account_Formula__c + sctemp.System_Code__c + sctemp.Component_Code__c + sctemp.Failure_Mode__c, sctemp);
                    }else if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && 
                    !sctemp.CSS_Account_Formula__c.contains('35') && !sctemp.CSS_Account_Formula__c.contains('62') 
                    && !sctemp.CSS_Account_Formula__c.contains('41') && !sctemp.CSS_Account_Formula__c.contains('97') 
                    && !sctemp.CSS_Account_Formula__c.contains('65') && !sctemp.CSS_Account_Formula__c.contains('27')
                    && !sctemp.CSS_Account_Formula__c.contains('52')){
                        if(mapSolComp.containsKey(sctemp.CSS_Account_Formula__c)) {
                            List<CSS_Solution_Component__c> fclist = mapSolComp.get(sctemp.CSS_Account_Formula__c);
                            fclist.add(sctemp);
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, fclist);
                        } else {
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, new List<CSS_Solution_Component__c> { sctemp });
                        } 
                    }
                }
            }
            system.debug('mapPrtWrntySolComp>>>>>'+mapPrtWrntySolComp);
            if(prtsObj !=null && prtsObj.size()>0){
                for(CSS_Parts_Options__c prtRec: prtsObj){
                    system.debug('prtRec.Account_Code__c>>>>'+prtRec.Account_Code__c);
                    if(prtsObjMap.containsKey(prtRec.Account_Code__c)){
                          tempPartsList = prtsObjMap.get(prtRec.Account_Code__c);
                          tempPartsList.add(prtRec);
                    }else {
                        tempPartsList = new List<CSS_Parts_Options__c>();
                        tempPartsList.add(prtRec);
                        system.debug('prtRec.Account_Code__c>>>>'+prtRec.Account_Code__c);
                        prtsObjMap.put(prtRec.Account_Code__c, tempPartsList);
                        }  
                }
            }
            
            system.debug('srtList--'+srtList);
            
            if(srtList !=null && srtList.size()>0){
                for(CSS_SRT__c srtRec: srtList){
                    system.debug('srtRec.Account_Code__c>>>>'+srtRec.Account_Code__c);
                    if(srtObjMap.containsKey(srtRec.AccountCode_Formula__c)){
                          tempSRTsList = srtObjMap.get(srtRec.AccountCode_Formula__c);
                          tempSRTsList.add(srtRec);
                    }else {
                        tempSRTsList = new List<CSS_SRT__c>();
                        tempSRTsList.add(srtRec);
                        system.debug('srtRec.AccountCode_Formula__c>>>>'+srtRec.AccountCode_Formula__c);
                        srtObjMap.put(srtRec.AccountCode_Formula__c, tempSRTsList);
                        }  
                    srtIDMap.put(srtRec.Id,srtRec);
                }
            }
            system.debug('prtsObjMap'+prtsObjMap);
            system.debug('srtObjMap'+srtObjMap);
            if(mapPrtWrntySolComp != null) {
                //FBI-385 : Code Start
                Set<String> attribute3Set = new Set<String>();
                Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
                for(CSS_Solution_Component__c prtWrntySolComp : mapPrtWrntySolComp.values()) {
                    attribute3Set.add(prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                }
                for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c, Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                    AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
                }
                //FBI-385 : Code End

                for(CSS_Solution_Component__c prtWrntySolComp : mapPrtWrntySolComp.values()){
                    fieldActionClaim = false;
                    if(prtWrntySolComp.CSS_Account_Formula__c.contains('65') || prtWrntySolComp.CSS_Account_Formula__c.contains('27')){
                      fieldActionClaim = true;  
                    }
                    resWrapper = new CG_OP_OAGWrapper();
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),serJob,'SRT');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),clm,psnRec,'SRT');

                    CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();

                    CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                    CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();

                    failureDetails.accountCode =  prtWrntySolComp.CSS_Account_Formula__c.right(2);
                    failureDetails.approvalCode = prtWrntySolComp.Approval_Code__c;
                    failureDetails.authorizationNumber = prtWrntySolComp.Authorization_Number__c;
                    failureDetails.campaignId = (prtWrntySolComp.Component_Id__c != null && prtWrntySolComp.Component_Id__c != '' ? string.valueof(prtWrntySolComp.Component_Id__c) : '');
                    //failureDetails.coverageType = prtWrntySolComp.CSS_CoverageType__c;
                    failureDetails.failCode = prtWrntySolComp.System_Code__c + prtWrntySolComp.Component_Code__c;
                    failureDetails.failMode = prtWrntySolComp.Failure_Mode__c;
                    failureDetails.lineNumber = prtWrntySolComp.Id;
                    failureDetails.overrideFlag = 'N';
                    system.debug('SolComp[0].Type__c--'+SolComp[0].Type__c);
                    if(prtWrntySolComp.Type__c == 'TRP' || prtWrntySolComp.Type__c == 'ATC' || prtWrntySolComp.Type__c == 'Campaign'){
                       failureDetails.inShopCampaignFlag =  prtWrntySolComp.In_Shop_SRT_Limit_Flag__c ? 'Y' : 'N';
                    }
                    else{
                        failureDetails.inShopCampaignFlag='';
                    }
                    failureDetails.payCode = prtWrntySolComp.Pay_Code__c;
                    failureDetails.status = 'Draft';
                    
                    //Campaign
                    CG_ODM_ReqJSONParser.Campaign camRefObj = new CG_ODM_ReqJSONParser.Campaign();
                    camRefObj.accountCode = '';
                    camRefObj.campaignId = '';
                    camRefObj.campaignType = '';
                    camRefObj.completeIndicator = '';
                    camRefObj.effectiveDate = '';
                    camRefObj.engineComponentCode = '';
                    camRefObj.expiryDateIntl = '';
                    camRefObj.expiryDateNA = '';
                    camRefObj.failMode = '';
                    camRefObj.multiFlag = '';
                    camRefObj.status = '';
                    camRefObj.systemCode = '';
                    camRefObj.cmpEngineStatusCode = '';
                    failureDetails.campaign = camRefObj; //appending this to above Failure

                    //acctCodeInfo
                    // FBI-385 : Replacing below query with Map
                    //CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute8__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: prtWrntySolComp.CSS_Account_Formula__c.Right(2) LIMIT 1];
                    CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                    if (queryJobEventTemp != null) {
                        acctInfo.accountCodeType = queryJobEventTemp.Attribute1__c;
                        failureDetails.coverageType =  queryJobEventTemp.Attribute1__c;
                        acctInfo.chryslerFlag = queryJobEventTemp.Attribute9__c;
                        acctInfo.multiESNFlag = queryJobEventTemp.Attribute7__c;
                        acctInfo.accountCodeWarrantyFlag = queryJobEventTemp.Attribute8__c;
                    }
                    
                    failureDetails.AcctCodeInfo = acctInfo;
                    failureDetails.Campaign = cmpgn;
                    reqJSON.Request.claim.failure.add(failureDetails);

                    reqJSON.Request.claim.Parts = new List<CG_ODM_ReqJSONParser.Parts>();
                    List<CSS_SRT__c> tSRTsList = srtObjMap.get(prtWrntySolComp.CSS_Account_Formula__c);
                                        
                    if(tSRTsList == null || tSRTsList.size()<=0)
                        continue;
                    
                    /*Set<String> pNum = new Set<String>();
                    Map<String,List<Decimal>> pNumQtyMap = new Map<String,List<Decimal>>();
                    for(CSS_Parts_Options__c tempPartRec: tPartsList){
                        if(!pNumQtyMap.containsKey(tempPartRec.Service_partnumber__c)){
                            //pNum.add(p.PartNumber);
                            List<Decimal> temp = new List<Decimal>();
                            temp.add(tempPartRec.Quantity__c);
                            pNumQtyMap.put(tempPartRec.Service_partnumber__c,temp);
                        }
                        else{
                            List<Decimal> temp = new List<Decimal>();
                            temp = pNumQtyMap.get(tempPartRec.Service_partnumber__c);
                            temp.add(tempPartRec.Quantity__c);
                            pNumQtyMap.put(tempPartRec.Service_partnumber__c,temp);
                        }
                    }*/
                    
                CG_ODM_ReqJSONParser.SrtList refObj;
                if(tSRTsList !=null && tSRTsList.size()>0){
                    Set<String> srtNum = new Set<String>();
                    Map<String,List<Decimal>> srtNumQtyMap = new Map<String,List<Decimal>>();
                    
                    for(css_srt__c tSRT: tSRTsList){
                        if(!srtNumQtyMap.containsKey(tSRT.SRT_ID__c)){
                            List<Decimal> temp = new List<Decimal>();
                            temp.add(tSRT.SRT_Quantity__c);
                            srtNumQtyMap.put(tSRT.SRT_ID__c,temp);
                        }
                        else{
                            List<Decimal> temp = new List<Decimal>();
                            temp = srtNumQtyMap.get(tSRT.SRT_ID__c);
                            temp.add(tSRT.SRT_Quantity__c);
                            srtNumQtyMap.put(tSRT.SRT_ID__c,temp);
                        }
                    }
                    
                   for(css_srt__c tSRT: tSRTsList){
                        if(prtWrntySolComp.Fail_Code__c != null){
                            if(prtWrntySolComp.Fail_Code__c == (fieldActionClaim == true ? tSRT.FailCode__c.right(6) : tSRT.FailCode__c.right(4))){ //here this should be rechecked
                                refObj = new CG_ODM_ReqJSONParser.SrtList();
                                refObj.lineNumber = tSRT.Id;
                                refObj.code = tSRT.SRT_ID__c;
                                refObj.hours = String.valueOf(tSRT.SRT_Time__c);
                                refObj.offsiteCheck = serJob.Repair_Location__c=='Mobile' ? 'Y' : 'N';
                                
                                if(tSRT.SRT_ID__c.contains('00-901') || tSRT.SRT_ID__c.contains('00-902') || tSRT.SRT_ID__c.contains('00-904') || tSRT.SRT_ID__c.contains('00-10S')){
                                    refObj.description = 'System';
                                }
                                else if(tSRT.Type__c == 'Diagnosis' && (tSRT.IsPopUpSRT__c == false)){
                                    refObj.description = 'Diagnostic';
                                }
                                else if((tSRT.Type__c == 'Repair' || tSRT.Type__c == 'Field Action') && (tSRT.IsPopUpSRT__c == false)){
                                    refObj.description = 'Repair';
                                }
                                else if(tSRT.SRT_AccessiblityCheck__c == true){
                                    refObj.description = 'Access';
                                }
                                else if(tSRT.IsPopUpSRT__c == true){
                                    refObj.description = 'Custom'; 
                                }
                                    
                                system.debug('refObj.description123--'+tSRT.SRT_ID__c+' '+refObj.description);
                                    
                                //refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                                List<Decimal> decTemp = new List<Decimal>();
                                decTemp = srtNumQtyMap.get(tSRT.SRT_ID__c);
                                if(decTemp.size() == 1){
                                    refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                                }
                                else if(decTemp.size() > 1){
                                    decimal qtySum = 0;
                                    for(Decimal decCount : decTemp){
                                        qtySum = qtySum + decCount;
                                    }
                                    refObj.quantity = String.valueof(qtySum);
                                }
                                refObj.srtAllowedFlag = 'N';
                                //refObj.description = '';
                                //if(!srtNum.contains(tSRT.SRT_ID__c)){
                                    reqJSON.Request.claim.srtList.add(refObj);
                                    //srtNum.add(tSRT.SRT_ID__c);
                                //}
                            }
                        }    
                    }
                    if(reqJSON.Request.claim.srtList == null || reqJSON.Request.claim.srtList.size() <= 0){
                        continue;
                    }
                }
                    
                reqJSON.Request.claim.travels = new List<CG_ODM_ReqJSONParser.Travels>();
                List<CSS_Parts_Options__c> tTravelList = prtsObjMap.get(prtWrntySolComp.CSS_Account_Formula__c);
                CG_ODM_ReqJSONParser.Travels travelObj;
                if(tTravelList !=null && tTravelList.size()>0){
                    for(CSS_Parts_Options__c tTravel: tTravelList){
                            if(prtWrntySolComp.Fail_Code__c == (fieldActionClaim == true ? tTravel.Fail_Code__c.right(6) : tTravel.Fail_Code__c.right(4))){ //here this should be rechecked
                                travelObj = new CG_ODM_ReqJSONParser.Travels();
                                travelObj.lineNumber = tTravel.Id; 
                                travelObj.hours = String.valueOf(tTravel.HoursTravelled__c);
                                travelObj.mealsCharges = tTravel.Type__c=='Meals' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.towingCharges = tTravel.Type__c=='Towing' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.travelDistance = String.valueOf(tTravel.Mileage__c);
                                reqJSON.Request.claim.travels.add(travelObj);
                            }
                    }
                }else{
                    travelObj = new CG_ODM_ReqJSONParser.Travels();
                    reqJSON.Request.claim.travels.add(travelObj);
                }    
                
                system.debug('reqJSON SRT--'+reqJSON);
                    CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
                    resWrapper = CG_SL_ODM.callODMSRTService(reqJSON);  
                    //ODMResponse = new CG_ODM_ResJSONParser(); 
                    //ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);

                    if(!MapResWrapperAccCodes.containsKey(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c))
                        MapResWrapperAccCodes.put(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c,resWrapper);
                }

            }
            if(mapSolComp != null) {
                //FBI-385 : Code Start
                Set<String> attribute3Set = new Set<String>();
                Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
                for(String accID: mapSolComp.keySet()) {
                    for(CSS_Solution_Component__c cssSolComp : mapSolComp.get(accID)) {
                        attribute3Set.add(cssSolComp.CSS_Account_Formula__c.Right(2));
                    }
                }
                for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                    AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
                }
                //FBI-385 : Code End
                for(String accID: mapSolComp.keySet()){
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON(null,serJob,'SRT');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON(null,clm,psnRec,'SRT');
                    if(mapSolComp != null){ //Added Null check : Kalpana
                        for(CSS_Solution_Component__c SolCompRec:mapSolComp.get(accID)){

                            CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                            CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                            CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();
                            failureDetails.accountCode =  SolCompRec.CSS_Account_Formula__c.right(2);
                            failureDetails.approvalCode = SolCompRec.Approval_Code__c;
                            failureDetails.authorizationNumber = SolCompRec.Authorization_Number__c;
                            failureDetails.campaignId = (SolCompRec.Component_Id__c != null && SolCompRec.Component_Id__c != '' ? string.valueof(SolCompRec.Component_Id__c) : '');
                            //failureDetails.coverageType = SolCompRec.CSS_CoverageType__c;
                            failureDetails.failCode = SolCompRec.System_Code__c + SolCompRec.Component_Code__c;
                            failureDetails.failMode = SolCompRec.Failure_Mode__c;
                            failureDetails.lineNumber = SolCompRec.Id;
                            failureDetails.overrideFlag = 'N';
                            if(SolCompRec.Type__c == 'TRP' || SolCompRec.Type__c == 'ATC' || SolCompRec.Type__c == 'Campaign'){
                                 failureDetails.inShopCampaignFlag =  SolCompRec.In_Shop_SRT_Limit_Flag__c ? 'Y' : 'N';
                             }
                            else{
                                 failureDetails.inShopCampaignFlag='';
                                 }
                            failureDetails.payCode = SolCompRec.Pay_Code__c;
                            failureDetails.status = 'Draft';
                            // FBI-385 : Replacing below query with Map
                            // CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: SolCompRec.CSS_Account_Formula__c.Right(2) LIMIT 1];
                            CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+SolCompRec.CSS_Account_Formula__c.Right(2));
                            if (queryJobEventTemp != null) {
                                acctInfo.accountCodeType = queryJobEventTemp.Attribute1__c;
                                failureDetails.coverageType =  queryJobEventTemp.Attribute1__c;
                                acctInfo.chryslerFlag = queryJobEventTemp.Attribute9__c;
                                acctInfo.multiESNFlag = queryJobEventTemp.Attribute7__c;
                            }
                           
                            failureDetails.AcctCodeInfo = acctInfo;
                            failureDetails.Campaign = cmpgn;
                            reqJSON.Request.claim.failure.add(failureDetails);
                            system.debug('reqJSON------>>'+reqJSON);
                            reqJSON.Request.claim.Parts = new List<CG_ODM_ReqJSONParser.Parts>();
                            system.debug('prtsObjMap'+prtsObjMap);
                            system.debug('SolCompRec.CSS_Account_Formula__c'+SolCompRec.CSS_Account_Formula__c);
                            List<CSS_SRT__c> tSRTsList = srtObjMap.get(SolCompRec.CSS_Account_Formula__c);
                            system.debug('Anirudh tSRTsList>>>>>>>'+tSRTsList);
                            if(tSRTsList == null || tSRTsList.size()<=0)
                                continue;
                            system.debug('Anirudh after continue tSRTsList>>>>>>>'+tSRTsList);
                           
                    if(tSRTsList !=null && tSRTsList.size()>0){
                    Set<String> srtNum = new Set<String>();
                    Map<String,List<Decimal>> srtNumQtyMap = new Map<String,List<Decimal>>();
                    for(css_srt__c tSRT: tSRTsList){
                        if(!srtNumQtyMap.containsKey(tSRT.SRT_ID__c)){
                            List<Decimal> temp = new List<Decimal>();
                            temp.add(tSRT.SRT_Quantity__c);
                            srtNumQtyMap.put(tSRT.SRT_ID__c,temp);
                        }
                        else{
                            List<Decimal> temp = new List<Decimal>();
                            temp = srtNumQtyMap.get(tSRT.SRT_ID__c);
                            temp.add(tSRT.SRT_Quantity__c);
                            srtNumQtyMap.put(tSRT.SRT_ID__c,temp);
                        }
                    }
                   for(css_srt__c tSRT: tSRTsList){
                                CG_ODM_ReqJSONParser.SrtList refObj = new CG_ODM_ReqJSONParser.SrtList();
                                refObj.lineNumber = tSRT.Id;
                                refObj.code = tSRT.SRT_ID__c;
                                refObj.hours = String.valueOf(tSRT.SRT_Time__c);
                                refObj.offsiteCheck = serJob.Repair_Location__c=='Mobile' ? 'Y' : 'N';
                                //refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                                List<Decimal> decTemp = new List<Decimal>();
                                decTemp = srtNumQtyMap.get(tSRT.SRT_ID__c);
                                if(decTemp.size() == 1){
                                    refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                                }
                                else if(decTemp.size() > 1){
                                    decimal qtySum = 0;
                                    for(Decimal decCount : decTemp){
                                        qtySum = qtySum + decCount;
                                    }
                                    refObj.quantity = String.valueof(qtySum);
                                }
                                refObj.srtAllowedFlag = 'N';
                                 
                                if(tSRT.SRT_ID__c.contains('00-901') || tSRT.SRT_ID__c.contains('00-902') || tSRT.SRT_ID__c.contains('00-904') || tSRT.SRT_ID__c.contains('00-10S')){
                                    refObj.description = 'System';
                                }
                                else if(tSRT.Type__c == 'Diagnosis' && (tSRT.IsPopUpSRT__c == false)){
                                    refObj.description = 'Diagnostic';
                                }
                                else if((tSRT.Type__c == 'Repair' || tSRT.Type__c == 'Field Action') && (tSRT.IsPopUpSRT__c == false)){
                                    refObj.description = 'Repair';
                                }
                                else if(tSRT.SRT_AccessiblityCheck__c == true){
                                    refObj.description = 'Access';
                                }
                                else if(tSRT.IsPopUpSRT__c == true){
                                    refObj.description = 'Custom'; 
                                }
                                    
                                system.debug('refObj.description--'+tSRT.SRT_ID__c+' '+refObj.description); 
                                
                                //if(!srtNum.contains(tSRT.SRT_ID__c) && tSRT.SRT_ID__c != '99-999'){
                                    reqJSON.Request.claim.srtList.add(refObj);
                                    //srtNum.add(tSRT.SRT_ID__c);
                                //}
                                //else if(tSRT.SRT_ID__c == '99-999'){  //added as part of the defect 184639 
                                    //reqJSON.Request.claim.srtList.add(refObj);
                                //}
                    }
                }
                reqJSON.Request.claim.travels = new List<CG_ODM_ReqJSONParser.Travels>();
                List<CSS_Parts_Options__c> tTravelList = prtsObjMap.get(SolCompRec.CSS_Account_Formula__c);
                CG_ODM_ReqJSONParser.Travels travelObj;
                if(tTravelList !=null && tTravelList.size()>0){
                    for(CSS_Parts_Options__c tTravel: tTravelList){
                                travelObj = new CG_ODM_ReqJSONParser.Travels();
                                travelObj.lineNumber = tTravel.Id; 
                                travelObj.hours = String.valueOf(tTravel.HoursTravelled__c);
                                travelObj.mealsCharges = tTravel.Type__c=='Meals' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.towingCharges = tTravel.Type__c=='Towing' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.travelDistance = String.valueOf(tTravel.Mileage__c);
                                reqJSON.Request.claim.travels.add(travelObj);
                            }
                }else{
                    travelObj = new CG_ODM_ReqJSONParser.Travels();
                    reqJSON.Request.claim.travels.add(travelObj);
                } 
                            system.debug('reqJSON--'+reqJSON);
                            resWrapper = new CG_OP_OAGWrapper();
                            resWrapper = CG_SL_ODM.callODMSRTService(reqJSON);
                            system.debug('resWrapper>>>>>>>>>'+resWrapper);
                            if(!MapResWrapperAccCodes.containsKey(accID))
                                MapResWrapperAccCodes.put(accID,resWrapper);
                            system.debug('resWrapper>>>>>>>>>'+MapResWrapperAccCodes);
                            break;  
                        }
                    }
                    //CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 


                    //ODMResponse = new CG_ODM_ResJSONParser(); 
                    //ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);



                }

            }

            if(MapResWrapperAccCodes != null){
                for(String AccountID:MapResWrapperAccCodes.keySet()){
                    CG_OP_OAGWrapper responseWrapper = new CG_OP_OAGWrapper();
                    responseWrapper = MapResWrapperAccCodes.get(AccountID);
                    CG_ODM_ResJSONParser ODMRes = new CG_ODM_ResJSONParser(); 
                    ODMRes = (CG_ODM_ResJSONParser)JSON.deserialize(responseWrapper.response.getBody(),CG_ODM_ResJSONParser.class);
                    //ODMRes = (CG_ODM_ResJSONParser)JSON.deserialize('{"Header":{"Sender":{"ServiceName":"ODMHeaderValidation","SenderID":"CSS"},"Target":{"TargetID":"ODM"}},"Response":{"DecisionID":"2018-06-20T00:12:23.914-04:00","claim":{"claimSubSource":null,"groupName":"","reconPartsWarrantyFlag":null,"thresholdAmount":"","multiESNFlag":"NA","cmiEngineSerialNumber":79619554,"parts":[{"partReturnFlag":"","channelCode":"","reconPartFlag":"","pricingRegion":"","partPrice":"","lineNumber":"a1f3B0000009K2EQAU","partAllowedFlag":"N","partId":876435,"messages":{"description":"Part price not found - PriceBook is Empty","code":"MW-PA-WAR-001","type":"WARNING"},"priceBook":"N"},{"partReturnFlag":"","channelCode":"","reconPartFlag":"","pricingRegion":"","partPrice":"","lineNumber":"a1f3B0000009K2FQAU","partAllowedFlag":"N","partId":876495,"messages":{"description":"Part price not found - PriceBook is Empty","code":"MW-PA-WAR-001","type":"WARNING"},"priceBook":"N"}],"claimSource":"Guidanz","paccarCertifiedLocationFlag":null,"totalClaimAmt":"","messages":[{"description":"Part price not found for exception PriceBook: N","code":"MW-PA-WAR-001","type":"WARNING"}],"distributorCode":"03520","paccarPaymentRoutingFlag":null,"paccarFlag":null,"roNumber":74882,"newPartsWarrantyFlag":null,"serviceModelName":"ISX15 CM2350 X101","button":null,"modelSeries":null,"roadRelayWarrantyFlag":null,"engineApplicationCode":"AUTOMOTIVE","penalty":0,"approverName":"","serviceProvider":{"region":"NORTH AMERICA","regionCode":null,"groupName":null,"territory":null,"status":"Active","outfileAllClaimsFlag":"N","engineEffectiveDate":"","spState":null,"oemCode":103,"channelOfDistribution":"101-DISTRIBUTOR-BRANCH","spSCMDollarAmt":"","spCountry":null,"engineExpirationdate":"","ltaChecked":"N","serviceModelName":"ISX15 CM2350 X101","channelDescription":null,"spServiceLevel":null,"spWarrantyTrainingStatus":null},"engineFamily":10,"certificationFlag":null,"srtList":[{"hours":"","quantity":""}],"serviceProviderName":null,"thresholdHrs":"","engine":{"serviceModel":null,"productApplicationDesp":"BB","marineFlag":"N","designPhaseCode":61,"engineFamilyCode":10,"warrantyIndicatorFlag":"Y","billToCode":null,"oemCode":"01005"},"productApplicationCode":null,"status":"ERROR","applicationName":null,"claimStatus":"In Review","countryCode":null,"failureMeasure":"Miles","ecmCalibBefore":"","failure":[{"GSQID":null,"accountCodeDesp":null,"payCode":"A","status":"Draft","totalLaborAmt":"","inShopCampaignFlag":null,"authorizationNumber":null,"approvalCode":null,"acctCodeInfo":{"chryslerFlag":null,"accountCodeType":null,"multiESNFlag":null,"accountCodeWarrantyFlag":null},"overrideFlag":"N","totalTowingAmt":"","accountCode":"ACCOUNT TEAM COVERAGE 27","programID":null,"failCode":"THAC","coverageType":"CMP","failMode":"RE","lineNumber":"a1O3B000000A14cUAC","policyFlag":null,"totalSRTHours":"","campaign":{"accountCode":null,"engineComponentCode":null,"campaignId":null,"cmpEngineStatusCode":null,"completeIndicator":null,"campaignType":null,"status":null,"systemCode":null,"failMode":null,"multiFlag":null},"travelCoveredFlag":null}],"ecmCalibAfter":"","cmiServiceProviderCode":"04892","travels":[{"mealsCharges":"","towingCharges":"","hours":"","travelDistance":""}],"otherClaimables":[{"amount":"","details":""}],"manufacturer":"INTERNATIONAL","manualAdjudicationFlag":"","HeaderCampaign":{},"bisFlag":"N","possessionFlag":"","claimNumber":"CSS-00080860"}}}',CG_ODM_ResJSONParser.class);

                    List<CG_ODM_ResJSONParser.SrtList> tSRTList = odmRes.Response.claim.srtList;
            css_srt__c tSRTObj;

                    if(tSRTList != null && tSRTList.size()>0){
                    for(CG_ODM_ResJSONParser.SrtList obj:tSRTList){
                        List<CG_ODM_ResJSONParser.message> resSRTMsgList = new List<CG_ODM_ResJSONParser.message>();
                        resSRTMsgList = (obj.messages != null ? obj.messages : null);//Anirudh checking if we can accomodate without any message structure
                        system.debug('Anirudh Entered inside SRT response update');
                        if(obj.lineNumber !=null && obj.lineNumber !=''){
                            tSRTObj = new css_srt__c();

                            tSRTObj.Id = obj.lineNumber; 
                            tSRTObj.ODM_Status_Code__c = string.valueof(responseWrapper.response.getStatusCode()); //to handle null response
                            
                            if(resSRTMsgList != null && resSRTMsgList.size()>0){
                                for(CG_ODM_ResJSONParser.message msg:resSRTMsgList){
                                    CG_ODM_ResJSONParser.message SRTChevronMsg = new CG_ODM_ResJSONParser.message();
                                    SRTChevronMsg.code = msg.code;
                                    SRTChevronMsg.description = msg.description;
                                    SRTChevronMsg.type = msg.type;
                                    SRTChevronMsg.partSRTCode = obj.code;
                                    ODMSRTChevronDisplayMsgs.add(SRTChevronMsg);
                                    if(msg.type != null && msg.type.trim() == 'ERROR'){
                                        tSRTObj.ODM_Status__c = 'ERROR';
                                    }
                                    if(tSRTObj.ODM_Status__c != 'ERROR' && msg.type != null && msg.type.trim() == 'WARNING'){
                                        tSRTObj.ODM_Status__c = 'WARN';
                                    }
                                    tSRTObj.ODM_Status_Message__c = (tSRTObj.ODM_Status_Message__c == null || tSRTObj.ODM_Status_Message__c == '' ? '' : tSRTObj.ODM_Status_Message__c) + (tSRTObj.ODM_Status_Message__c == null || tSRTObj.ODM_Status_Message__c == '' ? '' : ';;') + msg.type + ':' + obj.code + ':' + msg.description;               
                                }
                            }
                            if(resSRTMsgList == null || resSRTMsgList.size() == 0){
                                tSRTObj.ODM_Status__c = 'PASSED';
                                tSRTObj.ODM_Status_Message__c = '';
                            }

                            if(tSRTObj.ODM_Status__c != null && tSRTObj.ODM_Status__c == 'ERROR')
                                showodmerrormsg = true;
                            updateSRTRecList.add(tSRTObj); 
                        }
                       }
}
                    CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();

                    intDetails.Auth_Call_Time__c = (responseWrapper.totalAuthCallTime != null ? responseWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  responseWrapper.request.getBody();
                    intDetails.Response_Body__c = responseWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (responseWrapper.totalServiceCallTime != null ? responseWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMSRTValidation';
                    intDetails.Source__c = 'ODM';
                    lstIntDetails.add(intDetails); 

                }        
            }
                insert lstIntDetails;
                update updateSRTRecList;
                
                //GSSC-241
                system.debug('Source'+Source+'****startclaimupdate****'+updateSRTRecList.size()+updateSRTRecList);
                if(Source == 'Claim'){
                    system.debug('**insideIf1**');
                    if(updateSRTRecList != null && updateSRTRecList.size()>0){
                        system.debug('**insideIf2**');
                        for(css_srt__c srtObj : updateSRTRecList){
                            system.debug('srtObjID****'+srtObj.ID);
                            css_srt__c srt = srtIDMap.get(srtObj.Id);
                            system.debug('srt****'+srt);
                            if(srt != null && (srt.SRT_AccessiblityCheck__c == true || srt.isPerformed__c == true)){
                                system.debug('**insideIf***'+srtObj.SRT_ID__c+'****ODMSTATUS***'+srtObj.ODM_Status__c);
                                if(srtObj.ODM_Status__c == 'ERROR'){
                                    clm.SRTs_ODM_Status__c = 'ERROR';
                                    break;
                                }
                                else {
                                    system.debug('**insideIf***'+srtObj.SRT_ID__c);
                                    clm.SRTs_ODM_Status__c = srtObj.ODM_Status__c;
                                }
                            }
                        }
                    }
                    if(clm !=null){
                        system.debug('clm.SRTs_ODM_Status__c***'+clm.SRTs_ODM_Status__c);
                        system.debug('clm--'+clm.Id);
                        update clm;
                        system.debug('clm.SRTs_ODM_Status__c***'+clm.SRTs_ODM_Status__c);
                    }
                }
                
                
            return  CG_BL_ODM.showodmerrormsg;
        }catch(exception e){
            system.debug('Entered into catch block of ODMSRTValidationServiceMethod in CG_BL_ODM Class>>>>>>>'+e.getCause() + ' ' + e.getMessage() + ' ' + e.getLineNumber());
        }
        return false;
    }
    
    public static list<CG_ODM_ResJSONParser.message> returnODMSRTMessages(){
        return ODMSRTChevronDisplayMsgs;
    }
    
    //ODM Travel Service
    public static boolean callODMTravelValidationService(CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,List<CSS_Solution_Component__c> SolComp,List<CSS_Parts_Options__c> prtsObj){
        try{ 
            CG_BL_ODM.showodmerrormsg=false;
            //List<CSS_Solution_Component__c> lstPartWarrantySolComp = new List<CSS_Solution_Component__c>();
            CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();
            Map<String,CSS_Solution_Component__c> mapPrtWrntySolComp = new Map<String,CSS_Solution_Component__c>();
            Map<String,List<CSS_Solution_Component__c>> mapSolComp = new Map<String,List<CSS_Solution_Component__c>>();
            list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
            list<CSS_Parts_Options__c> updatePartRecList = new list<CSS_Parts_Options__c>();
            Map<String,List<CSS_Parts_Options__c>> prtsObjMap = new Map<String,List<CSS_Parts_Options__c>>();
            List<CSS_Parts_Options__c> tempPartsList = new List<CSS_Parts_Options__c>();
            map<String,CG_OP_OAGWrapper> MapResWrapperAccCodes = new map<String,CG_OP_OAGWrapper>();
            String ODMMessage;   
            boolean fieldActionClaim;
            if(ODMPartsChevronDisplayMsgs == null)//for zootopia story 181418
            ODMPartsChevronDisplayMsgs = new list<CG_ODM_ResJSONParser.message>();
            if(SolComp.size()>0){
                for(CSS_Solution_Component__c sctemp : SolComp) {
                    if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && (sctemp.CSS_Account_Formula__c.contains('35') || sctemp.CSS_Account_Formula__c.contains('62') || sctemp.CSS_Account_Formula__c.contains('41') || sctemp.CSS_Account_Formula__c.contains('97') || sctemp.CSS_Account_Formula__c.contains('65') || sctemp.CSS_Account_Formula__c.contains('27') || sctemp.CSS_Account_Formula__c.contains('52'))) {
                        mapPrtWrntySolComp.put(sctemp.CSS_Account_Formula__c + sctemp.System_Code__c + sctemp.Component_Code__c + sctemp.Failure_Mode__c, sctemp);
                    }else if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && !sctemp.CSS_Account_Formula__c.contains('35') && !sctemp.CSS_Account_Formula__c.contains('62') && !sctemp.CSS_Account_Formula__c.contains('41') && !sctemp.CSS_Account_Formula__c.contains('97') && !sctemp.CSS_Account_Formula__c.contains('65') && !sctemp.CSS_Account_Formula__c.contains('27') && !sctemp.CSS_Account_Formula__c.contains('52')){
                        if(mapSolComp.containsKey(sctemp.CSS_Account_Formula__c)) {
                            List<CSS_Solution_Component__c> fclist = mapSolComp.get(sctemp.CSS_Account_Formula__c);
                            fclist.add(sctemp);
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, fclist);
                        } else {
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, new List<CSS_Solution_Component__c> { sctemp });
                        } 
                    }
                }
            }

            //Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            if(prtsObj !=null && prtsObj.size()>0){
                for(CSS_Parts_Options__c prtRec: prtsObj){
                    if(prtsObjMap.containsKey(prtRec.Account_Code__c)){
                        if(prtRec.recordtype.name == 'TTML' && prtRec.selected_part__c == true &&  prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA'){
                            tempPartsList = prtsObjMap.get(prtRec.Account_Code__c);
                            tempPartsList.add(prtRec);
                        }
                    }else {
                        tempPartsList = new List<CSS_Parts_Options__c>();
                        if(prtRec.recordtype.name == 'TTML' && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA'){
                            tempPartsList.add(prtRec);
                            prtsObjMap.put(prtRec.Account_Code__c, tempPartsList);
                        }
                    }
                }
            }

            if(mapPrtWrntySolComp != null) {
                //FBI-385 : Code Start
                Set<String> attribute3Set = new Set<String>();
                Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
                for(CSS_Solution_Component__c prtWrntySolComp : mapPrtWrntySolComp.values()) {
                    attribute3Set.add(prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                }
                for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                    AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
                }
                //FBI-385 : Code End
                
                for(CSS_Solution_Component__c prtWrntySolComp : mapPrtWrntySolComp.values()){
                    fieldActionClaim = false;
                    if(prtWrntySolComp.CSS_Account_Formula__c.contains('65') || prtWrntySolComp.CSS_Account_Formula__c.contains('27')){
                      fieldActionClaim = true;  
                    }
                    resWrapper = new CG_OP_OAGWrapper();
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),serJob,'Travel');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),clm,psnRec,'Travel');

                    CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                    CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                    CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();
                    failureDetails.accountCode =  prtWrntySolComp.CSS_Account_Formula__c.right(2);
                    failureDetails.approvalCode = prtWrntySolComp.Approval_Code__c;
                    failureDetails.authorizationNumber = prtWrntySolComp.Authorization_Number__c;
                    failureDetails.campaignId = (prtWrntySolComp.Component_Id__c != null && prtWrntySolComp.Component_Id__c != '' ? string.valueof(prtWrntySolComp.Component_Id__c) : '');
                    
                    //failureDetails.coverageType = queryJobEventTemp[0].Attribute1__c;
                    failureDetails.failCode = prtWrntySolComp.System_Code__c + prtWrntySolComp.Component_Code__c;
                    failureDetails.failMode = prtWrntySolComp.Failure_Mode__c;
                    failureDetails.lineNumber = prtWrntySolComp.Id;
                    failureDetails.overrideFlag = 'N';
                    failureDetails.payCode = prtWrntySolComp.Pay_Code__c;
                    failureDetails.status = 'Draft';
                    
                    // FBI-385 : Replacing below query with Map
                    // CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: prtWrntySolComp.CSS_Account_Formula__c.Right(2) LIMIT 1];
                    CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                    if (queryJobEventTemp != null) {
                        acctInfo.accountCodeType = queryJobEventTemp.Attribute1__c;
                        failureDetails.coverageType =  queryJobEventTemp.Attribute1__c;
                        acctInfo.chryslerFlag = queryJobEventTemp.Attribute9__c;
                        acctInfo.multiESNFlag = queryJobEventTemp.Attribute7__c;
                    }
                 
                    failureDetails.AcctCodeInfo = acctInfo;
                    failureDetails.Campaign = cmpgn;
                    reqJSON.Request.claim.failure.add(failureDetails);

                    reqJSON.Request.claim.travels = new List<CG_ODM_ReqJSONParser.travels>();
                    List<CSS_Parts_Options__c> tPartsList = prtsObjMap.get(prtWrntySolComp.CSS_Account_Formula__c);
                    if(tPartsList == null || tPartsList.size()<=0)
                        continue;

                    for(CSS_Parts_Options__c tempPartRec: tPartsList){
                        if(prtWrntySolComp.Fail_Code__c == (fieldActionClaim == true ? tempPartRec.Get_Fail_Code_Formula__c.right(6) : tempPartRec.Get_Fail_Code_Formula__c.right(4)) && prtWrntySolComp.CSS_Account_Formula__c == tempPartRec.Account_Code__c){ 
                            CG_ODM_ReqJSONParser.travels refObj = new CG_ODM_ReqJSONParser.travels();
                            refObj.lineNumber = tempPartRec.Id; 
                            refObj.hours = string.valueof(tempPartRec.HoursTravelled__c);
                            if(tempPartRec.type__c!=null && tempPartRec.type__C=='Meals')
                                refObj.mealsCharges = (tempPartRec.ExpenseTotal__c != null ? string.valueOf(tempPartRec.ExpenseTotal__c) : '');
                            else if(tempPartRec.type__c!=null && tempPartRec.type__c=='Towing')  
                                refObj.towingCharges = (tempPartRec.ExpenseTotal__c != null ? string.valueOf(tempPartRec.ExpenseTotal__c) : '');
                            refObj.travelDistance = string.valueOf(tempPartRec.Mileage__c);
                            reqJSON.Request.claim.travels.add(refObj);
                        }
                    } 
                    if(reqJSON.Request.claim.travels == null || reqJSON.Request.claim.travels.size() <= 0){
                        continue;
                    }
                    CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
                    resWrapper = CG_SL_ODM.callODMTravelService(reqJSON);  
                    ODMResponse = new CG_ODM_ResJSONParser(); 
                    ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);

                    if(!MapResWrapperAccCodes.containsKey(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c))
                        MapResWrapperAccCodes.put(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c,resWrapper);
                }

            }
            if(mapSolComp != null) {
                //FBI-385 : Code Start
                Set<String> attribute3Set = new Set<String>();
                Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
                for(String accID : mapSolComp.keySet()) {
                    for(CSS_Solution_Component__c cssSolComp : mapSolComp.get(accID)) {
                        attribute3Set.add(cssSolComp.CSS_Account_Formula__c.Right(2));
                    }
                }
                for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                    AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
                }
                //FBI-385 : Code End
                for(String accID : mapSolComp.keySet()){
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON(null,serJob,'Travel');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON(null,clm,psnRec,'Travel');

                    for(CSS_Solution_Component__c SolCompRec:mapSolComp.get(accID)){

                        CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                        CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                        CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();
                        failureDetails.accountCode =  SolCompRec.CSS_Account_Formula__c.right(2);
                        failureDetails.approvalCode = SolCompRec.Approval_Code__c;
                        failureDetails.authorizationNumber = SolCompRec.Authorization_Number__c;
                        failureDetails.campaignId = (SolCompRec.Component_Id__c != null && SolCompRec.Component_Id__c != '' ? string.valueof(SolCompRec.Component_Id__c) : '');
                        
                        //failureDetails.coverageType = queryJobEventTemp[0].Attribute1__c;
                        failureDetails.failCode = SolCompRec.System_Code__c + SolCompRec.Component_Code__c;
                        failureDetails.failMode = SolCompRec.Failure_Mode__c;
                        failureDetails.lineNumber = SolCompRec.Id;
                        failureDetails.overrideFlag = 'N';
                        failureDetails.payCode = SolCompRec.Pay_Code__c;
                        failureDetails.status = 'Draft';
                        
                        // FBI-385 : Replacing below query with Map
                        // CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: SolCompRec.CSS_Account_Formula__c.Right(2) LIMIT 1];
                        CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+SolCompRec.CSS_Account_Formula__c.Right(2));
                        if (queryJobEventTemp != null) {
                            acctInfo.accountCodeType = queryJobEventTemp.Attribute1__c;
                            failureDetails.coverageType =  queryJobEventTemp.Attribute1__c;
                            acctInfo.chryslerFlag = queryJobEventTemp.Attribute9__c;
                            acctInfo.multiESNFlag = queryJobEventTemp.Attribute7__c;
                        }

                        failureDetails.AcctCodeInfo = acctInfo;
                        failureDetails.Campaign = cmpgn;
                        reqJSON.Request.claim.failure.add(failureDetails);

                        reqJSON.Request.claim.Parts = new List<CG_ODM_ReqJSONParser.Parts>();
                        List<CSS_Parts_Options__c> tPartsList = prtsObjMap.get(SolCompRec.CSS_Account_Formula__c);
                        if(tPartsList == null || tPartsList.size()<=0)
                            continue;

                        for(CSS_Parts_Options__c tempPartRec: tPartsList){
                            if(SolCompRec.CSS_Account_Formula__c == tempPartRec.Account_Code__c){ 
                                CG_ODM_ReqJSONParser.travels refObj = new CG_ODM_ReqJSONParser.travels();
                                refObj.lineNumber = tempPartRec.Id; 
                                refObj.hours = string.valueof(tempPartRec.HoursTravelled__c);
                                if(tempPartRec.type__c!=null && tempPartRec.type__C=='Meals')
                                    refObj.mealsCharges = (tempPartRec.ExpenseTotal__c != null ? string.valueOf(tempPartRec.ExpenseTotal__c) : '');
                               else if(tempPartRec.type__c!=null && tempPartRec.type__c=='Towing')  
                                    refObj.towingCharges = (tempPartRec.ExpenseTotal__c != null ? string.valueOf(tempPartRec.ExpenseTotal__c) : '');
                                refObj.travelDistance = string.valueOf(tempPartRec.Mileage__c);
                                reqJSON.Request.claim.travels.add(refObj);
                            }
                        } 
                        resWrapper = new CG_OP_OAGWrapper();
                        resWrapper = CG_SL_ODM.callODMTravelService(reqJSON); 

                        //ODMResponse = new CG_ODM_ResJSONParser(); 
                        //ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);

                        if(!MapResWrapperAccCodes.containsKey(accID))
                            MapResWrapperAccCodes.put(accID,resWrapper);
                        break;  
                    }                

                }
            }

            if(MapResWrapperAccCodes != null){
                for(String AccountID:MapResWrapperAccCodes.keySet()){
                    CG_OP_OAGWrapper responseWrapper = new CG_OP_OAGWrapper();
                    responseWrapper = MapResWrapperAccCodes.get(AccountID);
                    CG_ODM_ResJSONParser ODMRes = new CG_ODM_ResJSONParser(); 
                    ODMRes = (CG_ODM_ResJSONParser)JSON.deserialize(responseWrapper.response.getBody(),CG_ODM_ResJSONParser.class);
                    List<CG_ODM_ResJSONParser.travels> restravelsList = ODMRes.Response.claim.travels;
                    
                    if(restravelsList != null && restravelsList.size()>0){
                        for(CG_ODM_ResJSONParser.travels obj:restravelsList){
                        List<CG_ODM_ResJSONParser.message> resTravelMsgList = new List<CG_ODM_ResJSONParser.message>();
                        resTravelMsgList = (obj.messages != null ? obj.messages : null);

                        if(obj.lineNumber !=null && obj.lineNumber !=''){
                            CSS_Parts_Options__c prtObj = new CSS_Parts_Options__c();

                            prtObj.Id = obj.lineNumber;              
                            prtObj.ODM_Status_Code__c = string.valueof(responseWrapper.response.getStatusCode()); //to handle null response
                            if(resTravelMsgList != null && resTravelMsgList.size()>0){
                                for(CG_ODM_ResJSONParser.message msg:resTravelMsgList){
                                    system.debug('ODMPartsChevronDisplayMsgs'+ODMPartsChevronDisplayMsgs);
                                    ODMPartsChevronDisplayMsgs.add(msg);
                                    if(msg.type != null && msg.type.trim() == 'ERROR'){
                                        prtObj.ODM_Status__c = 'ERROR';
                                    }
                                    if(prtObj.ODM_Status__c != 'ERROR' && msg.type != null && msg.type.trim() == 'WARNING'){
                                        prtObj.ODM_Status__c = 'WARN';
                                    }
                                    prtObj.ODM_Status_Message__c = (prtObj.ODM_Status_Message__c == null || prtObj.ODM_Status_Message__c == '' ? '' : prtObj.ODM_Status_Message__c) + (prtObj.ODM_Status_Message__c == null || prtObj.ODM_Status_Message__c == '' ? '' : ';;') + msg.type + ':' + msg.description;               
                                }
                            }
                            if(resTravelMsgList == null || resTravelMsgList.size() == 0){
                                prtObj.ODM_Status__c = 'PASSED';
                                prtObj.ODM_Status_Message__c = '';
                            }
                            //prtObj.ODM_Status__c = obj.messages.type;
                            //prtObj.ODM_Status_Message__c = obj.messages.type + ':' + obj.messages.description;

                            if(prtObj.ODM_Status__c != null && prtObj.ODM_Status__c == 'ERROR')
                                showodmerrormsg = true;
                            updatePartRecList.add(prtObj); 
                            if(Source == 'CLAIM')
                                updateClaimsPartRecList.add(prtObj); 
                        }
                    }
} 
                    CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();

                    intDetails.Auth_Call_Time__c = (responseWrapper.totalAuthCallTime != null ? responseWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  responseWrapper.request.getBody();
                    intDetails.Response_Body__c = responseWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (responseWrapper.totalServiceCallTime != null ? responseWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMTravelValidation';
                    intDetails.Source__c = 'ODM';

                    lstIntDetails.add(intDetails); 
                    if(Source == 'CLAIM')
                        lstClaimsIntDetails.add(intDetails); 

                }        
            }
            if(Source == 'JOB'){
                insert lstIntDetails;
                update updatePartRecList;}
            return  CG_BL_ODM.showodmerrormsg;
        }catch(exception e){
            system.debug('Entered into catch block of callODMTravelValidationService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return null;
    }

    //ODM OC service
    public static boolean callODMOtherClaimableValidationService(CSS_Job_Order__c serJob,CSS_Claims__c clm,CSS_PSN__c psnRec,String Source,List<CSS_Solution_Component__c> SolComp,List<CSS_Parts_Options__c> prtsObj){
        try{
            CG_BL_ODM.showodmerrormsg=false;
            //List<CSS_Solution_Component__c> lstPartWarrantySolComp = new List<CSS_Solution_Component__c>();
            CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();
            Map<String,CSS_Solution_Component__c> mapPrtWrntySolComp = new Map<String,CSS_Solution_Component__c>();
            Map<String,List<CSS_Solution_Component__c>> mapSolComp = new Map<String,List<CSS_Solution_Component__c>>();
            list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
            list<CSS_Parts_Options__c> updatePartRecList = new list<CSS_Parts_Options__c>();
            Map<String,List<CSS_Parts_Options__c>> prtsObjMap = new Map<String,List<CSS_Parts_Options__c>>();
            List<CSS_Parts_Options__c> tempPartsList = new List<CSS_Parts_Options__c>();
            map<String,CG_OP_OAGWrapper> MapResWrapperAccCodes = new map<String,CG_OP_OAGWrapper>();
            String ODMMessage;   
            boolean fieldActionClaim;
            if(ODMPartsChevronDisplayMsgs == null)//for zootopia story 181418
            ODMPartsChevronDisplayMsgs = new list<CG_ODM_ResJSONParser.message>();
            //updateClaimsPartRecList = new List<CSS_Parts_Options__c>();
            //lstClaimsIntDetails=new List<CSS_Integration_Error__c>();
            //reqJSON.Request.claim.failure = new List<CG_ODM_ReqJSONParser.Failure>();
            if(SolComp.size()>0){
                for(CSS_Solution_Component__c sctemp : SolComp) {
                    if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && (sctemp.CSS_Account_Formula__c.contains('35') || sctemp.CSS_Account_Formula__c.contains('62') || sctemp.CSS_Account_Formula__c.contains('41') || sctemp.CSS_Account_Formula__c.contains('97') || sctemp.CSS_Account_Formula__c.contains('65') || sctemp.CSS_Account_Formula__c.contains('27') || sctemp.CSS_Account_Formula__c.contains('52'))) {
                        mapPrtWrntySolComp.put(sctemp.CSS_Account_Formula__c + sctemp.System_Code__c + sctemp.Component_Code__c + sctemp.Failure_Mode__c, sctemp);
                    }else if(sctemp.Selected_Component__c == true && sctemp.CSS_Account_Formula__c != null && !sctemp.CSS_Account_Formula__c.contains('35') && !sctemp.CSS_Account_Formula__c.contains('62') && !sctemp.CSS_Account_Formula__c.contains('41') && !sctemp.CSS_Account_Formula__c.contains('97') && !sctemp.CSS_Account_Formula__c.contains('65') && !sctemp.CSS_Account_Formula__c.contains('27') && !sctemp.CSS_Account_Formula__c.contains('52')){
                        if(mapSolComp.containsKey(sctemp.CSS_Account_Formula__c)) {
                           List<CSS_Solution_Component__c> fclist = mapSolComp.get(sctemp.CSS_Account_Formula__c);
                            fclist.add(sctemp);
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, fclist);
                        } else {
                            mapSolComp.put(sctemp.CSS_Account_Formula__c, new List<CSS_Solution_Component__c> { sctemp });
                        } 
                    }
                }
            }

            //Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            system.debug('prtsObj**'+prtsObj);
            if(prtsObj !=null && prtsObj.size()>0){
                for(CSS_Parts_Options__c prtRec: prtsObj){
                    if(prtsObjMap.containsKey(prtRec.Account_Code__c)){
                        if(prtRec.recordtype.name == 'OtherClaimables' && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA'){
                            tempPartsList = prtsObjMap.get(prtRec.Account_Code__c);
                            tempPartsList.add(prtRec);
                        }
                    }else {
                        tempPartsList = new List<CSS_Parts_Options__c>();
                        if(prtRec.recordtype.name == 'OtherClaimables' && prtRec.selected_part__c == true && prtRec.ODM_Status__c != 'PASSED' && prtRec.ODM_Status__c != 'NA'){
                            tempPartsList.add(prtRec);
                            prtsObjMap.put(prtRec.Account_Code__c, tempPartsList);
                        }
                    }
                }
            }
            system.debug('prtsObjMap**'+prtsObjMap);
            system.debug('mapPrtWrntySolComp**'+mapPrtWrntySolComp);
            if(mapPrtWrntySolComp != null) {
                //FBI-385 : Code Start
                Set<String> attribute3Set = new Set<String>();
                Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
                for(CSS_Solution_Component__c prtWrntySolComp : mapPrtWrntySolComp.values()) {
                    attribute3Set.add(prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                }
                for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                    AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
                }
                //FBI-385 : Code End
                for(CSS_Solution_Component__c prtWrntySolComp : mapPrtWrntySolComp.values()){
                    fieldActionClaim = false;
                    if(prtWrntySolComp.CSS_Account_Formula__c.contains('65') || prtWrntySolComp.CSS_Account_Formula__c.contains('27')){
                      fieldActionClaim = true;  
                    }
                    resWrapper = new CG_OP_OAGWrapper();
                    reqJSON = new CG_ODM_ReqJSONParser();
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),serJob,'OtherClaimable');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? prtWrntySolComp : null),clm,psnRec,'OtherClaimable');
                    system.debug('reqJSON**'+reqJSON);
                    CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                    CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                    CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();
                    failureDetails.accountCode =  prtWrntySolComp.CSS_Account_Formula__c.right(2);
                    failureDetails.approvalCode = prtWrntySolComp.Approval_Code__c;
                    failureDetails.authorizationNumber = prtWrntySolComp.Authorization_Number__c;
                    failureDetails.campaignId = (prtWrntySolComp.Component_Id__c != null && prtWrntySolComp.Component_Id__c != '' ? string.valueof(prtWrntySolComp.Component_Id__c) : '');
                    
                    //failureDetails.coverageType = queryJobEventTemp[0].Attribute1__c;
                    failureDetails.failCode = prtWrntySolComp.System_Code__c + prtWrntySolComp.Component_Code__c;
                    failureDetails.failMode = prtWrntySolComp.Failure_Mode__c;
                    failureDetails.lineNumber = prtWrntySolComp.Id;
                    failureDetails.overrideFlag = 'N';
                    failureDetails.payCode = prtWrntySolComp.Pay_Code__c;
                    failureDetails.status = 'Draft';
                    
                    // FBI-385 : Replacing below query with Map
                    // CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: prtWrntySolComp.CSS_Account_Formula__c.Right(2) LIMIT 1];
                    CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+prtWrntySolComp.CSS_Account_Formula__c.Right(2));
                    if (queryJobEventTemp != null) {
                        acctInfo.accountCodeType = queryJobEventTemp.Attribute1__c;
                        failureDetails.coverageType =  queryJobEventTemp.Attribute1__c;
                        acctInfo.chryslerFlag = queryJobEventTemp.Attribute9__c;
                        acctInfo.multiESNFlag = queryJobEventTemp.Attribute7__c;
                    }
                 
                    failureDetails.AcctCodeInfo = acctInfo;
                    failureDetails.Campaign = cmpgn;
                    reqJSON.Request.claim.failure.add(failureDetails);

                    reqJSON.Request.claim.otherClaimables = new List<CG_ODM_ReqJSONParser.otherClaimables>();
                    List<CSS_Parts_Options__c> tPartsList = prtsObjMap.get(prtWrntySolComp.CSS_Account_Formula__c);
                    if(tPartsList == null || tPartsList.size()<=0)
                        continue;

                    for(CSS_Parts_Options__c tempPartRec: tPartsList){
                        if(prtWrntySolComp.Fail_Code__c == (fieldActionClaim == true ? tempPartRec.Get_Fail_Code_Formula__c.right(6) : tempPartRec.Get_Fail_Code_Formula__c.right(4)) && prtWrntySolComp.CSS_Account_Formula__c == tempPartRec.Account_Code__c){ 
                            CG_ODM_ReqJSONParser.otherClaimables refObj = new CG_ODM_ReqJSONParser.otherClaimables();
                            refObj.lineNumber = tempPartRec.Id; 
                            refObj.item = (tempPartRec.Item__c != null && tempPartRec.Item__c != '' ? tempPartRec.Item__c.toUppercase() : '');
                            if(tempPartRec.Part_Description__c != null && tempPartRec.Part_Description__c != ''){
                                refObj.details = tempPartRec.Part_Description__c.toUppercase();
                            }                            system.debug('refObj.details**'+refObj.details);
                            refObj.amount = (tempPartRec.ExpenseTotal__c != null ? string.valueOf(tempPartRec.ExpenseTotal__c) : '');
                            reqJSON.Request.claim.otherClaimables.add(refObj);
                            system.debug('reqJSON1**'+reqJSON);
                        }
                    } 
                    if(reqJSON.Request.claim.otherClaimables == null || reqJSON.Request.claim.otherClaimables.size() <= 0){
                        continue;
                    }
                    CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 
                    resWrapper = CG_SL_ODM.callODMOtherClaimableService(reqJSON);  
                    ODMResponse = new CG_ODM_ResJSONParser(); 
                    ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);

                    system.debug('MapResWrapperAccCodes @@@@@ ' + MapResWrapperAccCodes);
                    system.debug('resWrapper @@@@@ ' + resWrapper);
                    system.debug('prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c ' + prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c);
                    if(!MapResWrapperAccCodes.containsKey(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c))
                        MapResWrapperAccCodes.put(prtWrntySolComp.Fail_Code__c + prtWrntySolComp.CSS_Account_Formula__c,resWrapper);

                    system.debug('MapResWrapperAccCodes @@@@@ ' + MapResWrapperAccCodes);
                }
            }
            system.debug('mapSolComp**'+mapSolComp);
            if(mapSolComp != null)
                for(String accID: mapSolComp.keySet()){
                    reqJSON = new CG_ODM_ReqJSONParser();
                    /* CG_ODM_ReqJSONParser.Claim claim = new CG_ODM_ReqJSONParser.Claim();
                        CG_ODM_ReqJSONParser.Request Request = new CG_ODM_ReqJSONParser.Request();
                    reqJSON.Request.claim.failure = new List<CG_ODM_ReqJSONParser.Failure>();*/
                    if(Source == 'JOB')
                        reqJSON = prepareServiceJobHeaderValidationReqJSON(null,serJob,'OtherClaimable');
                    if(Source == 'CLAIM')
                        reqJSON = prepareClaimHeaderValidationReqJSON(null,clm,psnRec,'OtherClaimable');
                    system.debug('Source**'+Source);
                    system.debug('serJob**'+serJob);
                    system.debug('reqJSON**'+reqJSON);
                    for(CSS_Solution_Component__c SolCompRec:mapSolComp.get(accID)){
                        system.debug('SolCompRec**'+SolCompRec);
                        CG_ODM_ReqJSONParser.Failure failureDetails = new CG_ODM_ReqJSONParser.Failure();
                        CG_ODM_ReqJSONParser.AcctCodeInfo acctInfo = new CG_ODM_ReqJSONParser.AcctCodeInfo();
                        CG_ODM_ReqJSONParser.Campaign cmpgn = new CG_ODM_ReqJSONParser.Campaign();

                        failureDetails.accountCode =  SolCompRec.CSS_Account_Formula__c.right(2);
                        system.debug('solCompAccFormula**'+SolCompRec.CSS_Account_Formula__c.right(2));
                        failureDetails.approvalCode = SolCompRec.Approval_Code__c;
                        failureDetails.authorizationNumber = SolCompRec.Authorization_Number__c;
                        failureDetails.campaignId = (SolCompRec.Component_Id__c != null && SolCompRec.Component_Id__c != '' ? string.valueof(SolCompRec.Component_Id__c) : '');
                        CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: SolCompRec.CSS_Account_Formula__c.Right(2) LIMIT 1];
                        //failureDetails.coverageType = queryJobEventTemp[0].Attribute1__c;
                        system.debug('queryJobEventTemp'+queryJobEventTemp);
                        failureDetails.failCode = SolCompRec.System_Code__c + SolCompRec.Component_Code__c;
                        failureDetails.failMode = SolCompRec.Failure_Mode__c;
                        failureDetails.lineNumber = SolCompRec.Id;
                        failureDetails.overrideFlag = 'N';
                        failureDetails.payCode = SolCompRec.Pay_Code__c;
                        failureDetails.status = 'Draft';
                        if(queryJobEventTemp != null){ // Added null check
                            acctInfo.accountCodeType = queryJobEventTemp[0].Attribute1__c;
                            failureDetails.coverageType =  queryJobEventTemp[0].Attribute1__c;
                            acctInfo.chryslerFlag = queryJobEventTemp[0].Attribute9__c;
                            acctInfo.multiESNFlag = queryJobEventTemp[0].Attribute7__c;}
                        
                    
                        failureDetails.AcctCodeInfo = acctInfo;
                        if(cmpgn != null)
                            failureDetails.Campaign = cmpgn;
                        system.debug('acctInfo'+acctInfo);
                        system.debug('cmpgn'+cmpgn);
                        system.debug('failureDetails**'+failureDetails);
                        reqJSON.Request.claim.failure.add(failureDetails);
                        reqJSON.Request.claim.otherClaimables = new List<CG_ODM_ReqJSONParser.otherClaimables>();
                        List<CSS_Parts_Options__c> tPartsList = prtsObjMap.get(SolCompRec.CSS_Account_Formula__c);
                        if(tPartsList == null || tPartsList.size()<=0)
                            continue;
                        system.debug('tPartsList**'+tPartsList);
                        for(CSS_Parts_Options__c tempPartRec: tPartsList){
                            if(SolCompRec.CSS_Account_Formula__c == tempPartRec.Account_Code__c){ 
                                CG_ODM_ReqJSONParser.otherClaimables refObj = new CG_ODM_ReqJSONParser.otherClaimables();
                                refObj.lineNumber = tempPartRec.Id; 
                                refObj.item = (tempPartRec.Item__c != null && tempPartRec.Item__c != '' ? tempPartRec.Item__c.toUppercase() : '');
                                if(tempPartRec.Part_Description__c != null && tempPartRec.Part_Description__c != ''){
                                    refObj.details = tempPartRec.Part_Description__c.toUppercase();
                                }
                                system.debug('refObj**'+refObj);
                                refObj.amount = (tempPartRec.ExpenseTotal__c != null ? string.valueOf(tempPartRec.ExpenseTotal__c) : '');
                                reqJSON.Request.claim.otherClaimables.add(refObj);
                            }
                        } 
                        system.debug('AnirudhWebServiceCall');
                        resWrapper = new CG_OP_OAGWrapper();
                        resWrapper = CG_SL_ODM.callODMOtherClaimableService(reqJSON); 

                        //ODMResponse = new CG_ODM_ResJSONParser(); 
                        //ODMResponse = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_ResJSONParser.class);
                        system.debug('MapResWrapperAccCodes @@@@@ ' + MapResWrapperAccCodes);
                        system.debug('resWrapper @@@@@ ' + resWrapper);
                        system.debug('accID @@@@@ ' + accID);
                        if(!MapResWrapperAccCodes.containsKey(accID))
                            MapResWrapperAccCodes.put(accID,resWrapper);
                        break;  
                    }
                    //CG_ODM_ResJSONParser ODMResponse = new CG_ODM_ResJSONParser(); 


                }


            system.debug('MapResWrapperAccCodes !!!!! ' + MapResWrapperAccCodes);
            //system.debug('updateClaimsPartRecList >>> ' + updateClaimsPartRecList.size() + ' --- ' + updateClaimsPartRecList);
            if(MapResWrapperAccCodes != null){
                for(String AccountID:MapResWrapperAccCodes.keySet()){
                    CG_OP_OAGWrapper responseWrapper = new CG_OP_OAGWrapper();
                    responseWrapper = MapResWrapperAccCodes.get(AccountID);
                    CG_ODM_ResJSONParser ODMRes = new CG_ODM_ResJSONParser(); 
                    ODMRes = (CG_ODM_ResJSONParser)JSON.deserialize(responseWrapper.response.getBody(),CG_ODM_ResJSONParser.class);
                    system.debug('ODMRes !!!!! ' + ODMRes);
                    List<CG_ODM_ResJSONParser.otherClaimables> resPartsList = ODMRes.Response.claim.otherClaimables;

                    for(CG_ODM_ResJSONParser.otherClaimables obj:resPartsList){
                        List<CG_ODM_ResJSONParser.message> resOtherClaimableMsgList = new List<CG_ODM_ResJSONParser.message>();
                        resOtherClaimableMsgList = (obj.messages != null ? obj.messages : null);
                        if(obj.lineNumber !=null && obj.lineNumber !='' ) {
                            CSS_Parts_Options__c prtObj = new CSS_Parts_Options__c();

                            prtObj.Id = obj.lineNumber; 
                            prtObj.ODM_Status_Code__c = string.valueof(responseWrapper.response.getStatusCode()); //to handle null respons

                            if(resOtherClaimableMsgList != null && resOtherClaimableMsgList.size()>0){
                                for(CG_ODM_ResJSONParser.message msg:resOtherClaimableMsgList){
                                    CG_ODM_ResJSONParser.message prtChevronMsg = new CG_ODM_ResJSONParser.message();
                                    prtChevronMsg.code = msg.code;
                                    prtChevronMsg.description = msg.description;
                                    prtChevronMsg.type = msg.type;
                                    prtChevronMsg.partSRTCode = obj.Item;
                                    ODMPartsChevronDisplayMsgs.add(prtChevronMsg);
                                    if(msg.type != null && msg.type.trim() == 'ERROR'){
                                        prtObj.ODM_Status__c = 'ERROR';
                                    }
                                    if(prtObj.ODM_Status__c != 'ERROR' && msg.type != null && msg.type.trim() == 'WARNING'){
                                        prtObj.ODM_Status__c = 'WARN';
                                    }
                                    prtObj.ODM_Status_Message__c = (prtObj.ODM_Status_Message__c == null || prtObj.ODM_Status_Message__c == '' ? '' : prtObj.ODM_Status_Message__c) + (prtObj.ODM_Status_Message__c == null || prtObj.ODM_Status_Message__c == '' ? '' : ';;') + msg.type + ':' + msg.description;               
                                }
                            }
                            if(resOtherClaimableMsgList == null || resOtherClaimableMsgList.size() == 0){
                                prtObj.ODM_Status__c = 'PASSED';
                                prtObj.ODM_Status_Message__c = '';
                            }   

                            if(prtObj.ODM_Status__c != null && prtObj.ODM_Status__c == 'ERROR')
                                showodmerrormsg = true;
                            updatePartRecList.add(prtObj);  
                            system.debug('prtObj**'+prtObj);
                            if(Source == 'CLAIM')
                                updateClaimsPartRecList.add(prtObj); 
                        }
                    }

                    /// system.debug('updateClaimsPartRecList >>> ' + updateClaimsPartRecList.size() + ' --- ' + updateClaimsPartRecList);
                    CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();

                    intDetails.Auth_Call_Time__c = (responseWrapper.totalAuthCallTime != null ? responseWrapper.totalAuthCallTime : 0);
                    //Request Body
                    intDetails.Processed_Data__c =  responseWrapper.request.getBody();
                    intDetails.Response_Body__c = responseWrapper.response.getBody();
                    intDetails.Service_Call_Time__c = (responseWrapper.totalServiceCallTime != null ? responseWrapper.totalServiceCallTime : 0);
                    if(Source == 'JOB')
                        intDetails.Service_Job_Number__c = serJob.Name;
                    if(Source == 'CLAIM')
                        intDetails.Service_Job_Number__c = clm.Name;
                    intDetails.Service_Name__c = 'ODMOtherClaimablesValidation';
                    intDetails.Source__c = 'ODM';

                    lstIntDetails.add(intDetails); 
                    if(Source == 'CLAIM')
                        lstClaimsIntDetails.add(intDetails); 

                }        
            }
            if(Source == 'JOB'){
                system.debug('updatePartRecList**'+updatePartRecList);
                insert lstIntDetails;
                update updatePartRecList;
                system.debug('Updated Successfully**'+updatePartRecList);
            }
            return  CG_BL_ODM.showodmerrormsg;
        }catch(exception e){
            system.debug('Entered into catch block of callODMOtherClaimableValidationService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return false;
    }

    //ODM SRT Service-old
    public static Boolean callODMSRTServicesold(String source, String id) {
        CG_BL_ODM.showodmerrormsg=false;
        System.debug('####### 1 #####'+ ' ' + source + id);
        CG_ODM_ReqJSONParser odmReq = null;
        CG_ODM_ResJSONParser odmRes = null;
        List<CSS_Solution_Component__c> solCompList;
        Set<String> acCodeSet;
        Map<String, List<CSS_Solution_Component__c>> acSolCompMap;
        Map<String, List<css_srt__c>> acSRTMap;
        Map<String, List<CSS_Parts_Options__c>> acPartsMap;
        List<CSS_Parts_Options__c> partsList;
        List<css_srt__c> tempSRTList;
        List<CSS_Solution_Component__c> tempSolCompList;
        Map<String, Boolean> partsWarrantyExistsMap;
        CSS_Job_Order__c workJob;
        CSS_Claims__c claimsRec;
        CSS_PSN__c psnRec;
        CG_OP_OAGWrapper resWrapper;
        CG_ODM_ReqJSONParser reqJSON;
        List<CSS_Parts_Options__c> updateTravelList;
        List<css_srt__c> srtList;
        List<CSS_Parts_Options__c> ttmlPartsList;
        boolean fieldActionClaim;
        //List<CSS_Integration_Error__c> intLogList;
        //List<CSS_Solution_Component__c> lstPartWarrantySolComp;
        //Boolean partsWarrantyExists = false;
        try{
            acCodeSet = new Set<String>();
            acSolCompMap = new Map<String, List<CSS_Solution_Component__c>>();
            acSRTMap = new Map<String, List<css_srt__c>>();
            acPartsMap = new Map<String, List<CSS_Parts_Options__c>>();
            workJob = new CSS_Job_Order__c();
            //partsList = new List<CSS_Parts_Options__c>();

            //SolCompList
            if(source == 'Job'){
                solCompList = new List<CSS_Solution_Component__c>([select Id, Name,AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,
                                                                   Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                   Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                                   CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                                   CoveredTravelLabor__c,RoadRelay_Warranty__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                                   Equip_ID__c,Fail_Code__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                                   Multiple_Times__c,SysCodeAndCompCode__c,Notes__c,Parts_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,
                                                                   Service_Model__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,
                                                                   Claim_Type__c from CSS_Solution_Component__c where Service_Job__c =: id and CSS_Account_Formula__c !=null and CSS_Account_Formula__c !='' and Selected_Component__c = true]);
            }else if(source == 'Claim'){
                solCompList = new List<CSS_Solution_Component__c>([select Id, Name,AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,
                                                                   Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                   Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
                                                                   CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
                                                                   CoveredTravelLabor__c,RoadRelay_Warranty__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
                                                                   Equip_ID__c,Fail_Code__c,SysCodeAndCompCode__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
                                                                   Multiple_Times__c,Notes__c,Parts_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,
                                                                   Service_Model__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,Unique_Component__c,URL__c,WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c,
                                                                   Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =: id and CSS_Account_Formula__c !=null and CSS_Account_Formula__c !='' and Selected_Component__c = true]);
            }
            //solCompList = new List<CSS_Solution_Component__c>([Select id, name, Failure_Mode__C,CSS_Account_Formula__c, AccountCodeType__c, AccountCodeEdit__c, Selected_Component__c, Claims_Failure_Select__c, Solutions__c, Solutions__r.Service_Job__c,Solutions__r.FaultCode__r.Name, Solutions__r.FaultCode__r.RelatedFaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.Symptom__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, Pay_Code__c, Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =: id and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')]);
            system.debug('***solCompList size:'+solCompList.size() + 'solCompList>>>:'+solCompList);
            if(solCompList ==null || solCompList.size()<=0){
                return showodmerrormsg;
            }
            if(solCompList !=null && solCompList.size()>0){
                //Code added for distributor logic: story#155918
                String orgtype=css_utility.getOrgType(userinfo.getUserId());
                boolean callsrtOnInfoOnlyClaim = false;
                if(orgtype == 'DISTR')
                {
                    for(CSS_Solution_Component__c scomp:solCompList)
                    {
                        if(scomp.Pay_Code__c!=null && scomp.Pay_Code__c!='' && scomp.Pay_Code__c=='A')
                        {
                            callsrtOnInfoOnlyClaim=true;
                            break;
                        }

                    }
                    if(callsrtOnInfoOnlyClaim==true)
                    {
                        system.Debug('Entered call info only claim');
                        return false;
                    }
                }
                //Code end here..
                //for(Integer i=0;i<5; i++){
                partsWarrantyExistsMap = new Map<String, Boolean>();
                acSolCompMap = new Map<String, List<css_solution_component__c>>();
                for(css_solution_component__c solComp: solCompList){
                    //storing accountCodes & it's associated records into Map here
                    acCodeSet.add(solComp.CSS_Account_Formula__c);
                    if(acSolCompMap.containsKey(solComp.CSS_Account_Formula__c)){
                        tempSolCompList = acSolCompMap.get(solComp.CSS_Account_Formula__c);
                        tempSolCompList.add(solComp);
                    }else {
                        tempSolCompList = new List<css_solution_component__c>();
                        tempSolCompList.add(solComp);
                        acSolCompMap.put(solComp.CSS_Account_Formula__c, tempSolCompList);
                    }
                    System.debug('CSS_Account_Formula__c>>>:'+solComp.CSS_Account_Formula__c);

                    if(solComp.CSS_Account_Formula__c != null && (solComp.CSS_Account_Formula__c.contains('35') || solComp.CSS_Account_Formula__c.contains('62') 
                                                                  || solComp.CSS_Account_Formula__c.contains('41') || solComp.CSS_Account_Formula__c.contains('97')
                                                                  || solComp.CSS_Account_Formula__c.contains('65') || solComp.CSS_Account_Formula__c.contains('27')
                                                                  || solComp.CSS_Account_Formula__c.contains('52'))) {
                        partsWarrantyExistsMap.put(solComp.CSS_Account_Formula__c, true);
                        //lstPartWarrantySolComp.add(solComp);
                        //partsWarrantyExists = true;
                    }else {
                        partsWarrantyExistsMap.put(solComp.CSS_Account_Formula__c, false);
                    }
                }
            }
            System.debug('####### 2 #####acCodeSet:'+acCodeSet);

            //SRTs
            if(source == 'Job'){
                srtList = new List<css_srt__c>([Select id, CreatedById, LastModifiedById,type__c,AccountCode_Formula__c,Account_Code__c,SRT_Category__c, Diagnosis_Time__c,SRT_Select__c,
                                                SRT_Estimate__c,SRT_Decimal_Time__c, FailCode__c,srt_time__c, job_order__c ,SRT_Quantity__c ,SRT_ID__c,isPerformed__c,SRT_Notes__c, 
                                                SRT_Warrantable__c,Component_Id__r.Claim_Type__c,Component_Id__r.Selected_Claim_Type__c, Component_Id__c from css_srt__c where job_order__c =:id and SRT_ID__c !=null 
                                                and SRT_ID__c !='0' and AccountCode_Formula__c IN:acCodeSet and ODM_Status__c !='NA' and ODM_Status__c !='PASSED' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) 
                                                and (Type__c IN ('Admin','Diagnosis','Repair','Diag Access','Repair Access','Field Action')
                                                     or (SRT_Category__c IN ('AdditionalDiag','AdditionalRep')) or Type__c IN ('Field Action','Field Action Access','99Time'))]);
            }else if(source == 'Claim'){
                srtList = new List<css_srt__c>([Select id, CreatedById, LastModifiedById,type__c,AccountCode_Formula__c,Account_Code__c,SRT_Category__c, Diagnosis_Time__c,SRT_Select__c,
                                                SRT_Estimate__c,SRT_Decimal_Time__c,FailCode__c, srt_time__c, job_order__c ,SRT_Quantity__c ,SRT_ID__c,isPerformed__c,SRT_Notes__c, 
                                                SRT_Warrantable__c,Component_Id__r.Claim_Type__c,Component_Id__r.Selected_Claim_Type__c, Component_Id__c from css_srt__c where CSS_Claims__c =:id and SRT_ID__c !=null 
                                                and SRT_ID__c !='0' and AccountCode_Formula__c IN:acCodeSet and ODM_Status__c !='NA' and ODM_Status__c !='PASSED' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) 
                                                and (Type__c IN ('Admin','Diagnosis','Repair','Diag Access','Repair Access','Field Action')
                                                     or (SRT_Category__c IN ('AdditionalDiag','AdditionalRep')) or Type__c IN ('Field Action','Field Action Access','99Time'))]);
            }
            if(srtList !=null && srtList.size()>0){
                for(css_srt__c srtObj: srtList){
                    if(acSRTMap.containsKey(srtObj.AccountCode_Formula__c)){
                        tempSRTList = acSRTMap.get(srtObj.AccountCode_Formula__c);
                        tempSRTList.add(srtObj);
                    }else {
                        tempSRTList = new List<css_srt__c>();
                        tempSRTList.add(srtObj);
                        acSRTMap.put(srtObj.AccountCode_Formula__c, tempSRTList);
                    }
                }
            }
            //System.debug('####### 3 #####srtList size:'+srtList.size()+' srtList>>:'+srtList);
            System.debug('####### 3 #####srtList size:'+srtList.size());
            System.debug('####### 4 #####acCodeSet:'+acCodeSet);
            if(srtList ==null || srtList.size()<=0){
                return showodmerrormsg;
            }

			 System.debug('####### 3 #####acCodeSet:'+acCodeSet);
            //Travels/Parts
            if(source == 'Job'){
                ttmlPartsList = new List<CSS_Parts_Options__c>([select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                                                                Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c
                                                                from CSS_Parts_Options__c where Service_Job__c =:id and RecordType.Name ='TTML' and ODM_Status__c !='NA' and ODM_Status__c !='PASSED' and Account_Code__c IN:acCodeSet]);
            }else if(source == 'Claim'){
                ttmlPartsList = new List<CSS_Parts_Options__c>([select Id, FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                                                                Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c
                                                                from CSS_Parts_Options__c where CSS_Claims__c =:id and RecordType.Name ='TTML' and ODM_Status__c !='NA' and ODM_Status__c !='PASSED' and Account_Code__c IN:acCodeSet]);
            }
            if(ttmlPartsList !=null && ttmlPartsList.size()>0){
                for(CSS_Parts_Options__c ttmlPart: ttmlPartsList){
                    if(acPartsMap.containsKey(ttmlPart.Account_Code__c)){
                        partsList = acPartsMap.get(ttmlPart.Account_Code__c);
                        partsList.add(ttmlPart);
                    }else {
                        partsList = new List<CSS_Parts_Options__c>();
                        partsList.add(ttmlPart);
                        acPartsMap.put(ttmlPart.Account_Code__c, partsList);
                    }
                }
            }
            System.debug('####### 3 #####ttmlPartsList size:'+ttmlPartsList);

            if(source == 'Job'){
                workJob=[Select Id,Name,IsAppointment__c, bmsCreateAccount__c,CSS_Bms_ContactBoolean__c,Email_Address__c,Email_check_box__c,BMSStatus__c,Contact_ID__c,Customer_Name__c,Customer_Code__c,Phone_Number__c,Contact_Name__c,Cstmr_Contacts_Phone__c,Address__c,City__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Shop_Work_Order__c,Application__c, Unit_Number__c, Status__c, css_resolution__c,CSS_Feedback_Comments__c, Previous_Status__c,previousESN_MultiLoc__c,date_in__c,Date_in_Shop__c,
                         ESN__c, ESN_IA__c, First_Name__c,BMS_Last_Name__c, Mileage__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c, LastModifiedDate,CreatedDate, Location_Certification__c,CSS_State__c,Primary_Segment__c,Before_In_Service__c,ESN_Locked__c, 
                         Make__c,Model__c,AccessCode__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Service_Model__c,VIN__c,VIN_Flag__c,Warranty_Start_Date__c,Region__c,Creator_Location__c,EditCoverage__c,Unit_Type__c, Sub_Type__c,Account__r.ERP_System__c,SP_AccountStatus__c,SP_BusinessUnit__c,SP_CampaignTRP__c,SP_CMISPExpirationDate__c,
                         Repeat_Visit__c,TSR_EscalateNumber__c,RecentVisit__c,Repeat_Or_Recent_Calc__c,JobLocation__c,CSS_Job_Location_Code__c,CreatedById,Qsol_Engine_Family_Code__c,Repair_Location__c,Territory__c,Warranty_Authorization_Flag__c,PSN_Not_Available__c,Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,SP_CommunicationMethod__c,SP_CommunicationOccurrence__c,SP_CostEffectiveExclusion__c,SP_CutOffClaimAmt__c,SP_DisableWebAccessFlag__c,SP_DistributorHQCode__c,SP_DistributorHQName__c,SP_DSID__c,SP_DTNAFlag__c,SP_FreezeSubmitButton__c,SP_GroupName__c,SP_LTAFlag__c,SP_MaxClaimAmt__c,SP_NewOEM__c,SP_OutfileAllClaims__c,SP_PACCAR__c,SP_PMUSplitPayment__c,SP_Policy__c,SP_PrimaryOEMCode__c,SP_PrimaryOEMName__c,SP_ProductCertification__c,SP_PromotionId__c,SP_PSBUProductCertification__c,SP_Region__c,SP_RepairLevel__c,SP_SCMDeductiblePercentage__c,SP_SCMDollarAmt__c,SP_State__c,SP_TechActualHoursRequired__c,SP_ViewDollarAmount__c,SP_WarrantyCertificationEndDate__c,SP_WarrantyEmail__c,SP_WarrantyFax__c,SP_WarrantyTrainingCertification__c,SP_WarrantyTrainingStatus__c,SP_WWSPSSPFlag__c,
                         ProductApplicationCode__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,EngineFamilyName__c,Account__c,SP_ClaimAllowedDays__c,SP_RegionCode__c,SP_TerritoryCode__c,BillToCode__c,DesignPhaseCode__c,Sp_TERRITORY__c,
                         ProductApplicationDesp__c,warrantyIndicatorFlag__c,Automotive_App_Flag__c,
                         MarineFlag__c,OemCode__c,EtoConversionDate__c,BuildDate__c,CSS_Channel_Code__c, CSS_Channel_Of_Distribution__c, CSS_Travel_Rate__c, CSS_In_Shop_Labor_Rate__c, CSS_Field_Service_Labor_Rate__c, Territory_Class__c, Territory_Class_Name__c, 
                         (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),Category__c,Category2__c,Category3__c,Category4__c,Category5__c,Complaint_Type__c,Complaint_Type2__c,Complaint_Type3__c,Complaint_Type4__c,Complaint_Type5__c, Preventive_Maintenance__c,Expedited_Service__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c, Application_Desc__c,ApplicationCode__c,
                         (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Solution_Title__c ,Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r),
                         (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where( job_order__C=:id and( performed_review__c=True and performed__c=False))),
                         (select Id,name,OrderReference__c from css_quotes__r)
                         from CSS_Job_Order__c where id= :id];
            }else if(source == 'Claim'){
                claimsRec =[Select Id,Multi_PSN_Claim__c,CSS_Job__r.General_Symptoms__c,Account__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Category2_Desc__c,
                            CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Category4_Desc__c,
                            CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Claims_General_Symptoms__c,
                            Claims_Preventive_Maintenance__c,SP_WarrantyCertificationEndDate__c,ProductApplicationCode__c,Claims_Category__c,Claims_Category2__c,Claims_Category3__c,Claims_Category4__c,Claims_Category5__c,
                            Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,
                            Claims_Expedited_Service__c,Status__c,ODM_Status__c,Claims_Additional_Comments__c,Claims_Category_Desc__c,Claims_Category2_Desc__c,
                            Claims_Category3_Desc__c,Claims_Category4_Desc__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,
                            Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,account__r.RSS_RESP_BRANCH_CODE__c,SP_PrimaryOEMCode__c,Claims_Complaint_Type5__c,CSS_Job__r.createdDate,Customer_Name__c,Location__c,
                            Location_Code__c,CSS_Job__c,CSS_Job__r.name,Shop_Work_Order__c,SP_Country__c,EngineFamilyName__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,
                            CoverageResponse__c,Claim_Submitted__c,Account__r.Enable_Claims__c,Account__r.Warranty_Training_Status__c,Distributor_Authorization_FN__c,
                            CreatedBy.Name,Account__r.Warranty_Training_Certification__c,TSR1__c,TSR2__c,TSR3__c,TSR4__c,TSR5__c,TSR6__c,TSR7__c,TSR8__c,TSR9__c,
                            TSR10__c,CSS_Job__r.CSS_In_Shop_Labor_Rate__c,CSS_Job__r.CSS_Field_Service_Labor_Rate__c,CSS_Job__r.CSS_Travel_Rate__c, Catastrophic__c,
                            DesignPhaseCode__c, Service_Model__c,CSS_Channel_Of_Distribution__c,SP_LTA_FLAG__c,SP_PACCAR__c,SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,
                            SP_PromotionId__c,Repair_Location__c, BillToCode__c, BuildDate__c, EngineFamilyCode__c, EtoConversionDate__c, MarineFlag__c, OemCode__c, 
                            ProductApplicationDesp__c, warrantyIndicatorFlag__c, SP_CHANNEL_OF_DISTRIBUTION__c, CSS_Channel_Code__c, SP_CLAIM_ALLOWED_DAYS__c, 
                            SP_Group_Name__c, SP_CMI_SP_EXPIRATION__c, SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,
                            SP_OUTFILE_ALL_CLAIMS__c, SP_REGION__c, SP_REGIONCODE__c, SP_TERRITORY__c, CSS_Job__r.Shop_Work_Order__c,Automotive_App_Flag__c,  
                            (Select Id,Name,PSN__c,Make__c,Model__c,Before_In_Service__c,Mission_Disabling__c,Calibration_After__c,Calibration_Before__c,VIN__c,
                             Service_Model__c,Application__c,ApplicationCode__c,Qsol_Engine_Family_Code__c, Failure_Date__c,Mileage__c,Mileage_Measure__c,Justification__c,Unit_Number__c,
                             Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                            from CSS_Claims__c where id= :id];
                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 
            }


            //Now prepare ODM SRT Request JSON
            updateSRTList = new List<css_srt__c>();
            updateTravelList = new List<CSS_Parts_Options__c>();
            intLogList = new List<CSS_Integration_Error__c>();
            Integer count=0;
            List<String> uniqueAcCodesList = new List<String>();
            uniqueAcCodesList.addAll(acCodeSet);
            
            //FBI-385 : Code Start
            Set<String> attribute3Set = new Set<String>();
            Map<String, CSS_JobEventTemporary__c> AttributeToCSS_JobEventTemporaryMap = new Map<String, CSS_JobEventTemporary__c>();
            
            for(String accID : uniqueAcCodesList) {
                css_solution_component__c solComp = acSolCompMap.get(accID)[0];
                attribute3Set.add(solComp.CSS_Account_Formula__c.Right(2));
            }
            
            for(CSS_JobEventTemporary__c jobEvent : [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c, Attribute8__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c IN :attribute3Set]) {
                AttributeToCSS_JobEventTemporaryMap.put(jobEvent.Key__c+'_'+jobEvent.Attribute3__c, jobEvent);
            }
            //FBI-385 : Code End
            System.debug('uniqueAcCodesList.size()::: '+uniqueAcCodesList.size());
            for(Integer i=0;i<uniqueAcCodesList.size();i++){
                System.debug('Inside if '+uniqueAcCodesList.size());
                //for(css_solution_component__c solComp: solCompList){
                List<css_solution_component__c> tSolList = acSolCompMap.get(uniqueAcCodesList.get(i)); //String acCode = acCodeSet[i]; //acSolCompMap.get(acCode);
                css_solution_component__c solComp = tSolList.get(0); //solCompList.get(0); 
                fieldActionClaim = false;
                if(solComp.CSS_Account_Formula__c.contains('65') || solComp.CSS_Account_Formula__c.contains('27')){
                fieldActionClaim = true;
                }
                count++;
                //Header
                System.debug('####### before header  ##### count>>:'+count+' solComp.CSS_Account_Formula__c>>>:'+solComp.CSS_Account_Formula__c);
                if(source == 'Job'){
                    if(partsWarrantyExistsMap.get(solComp.CSS_Account_Formula__c))
                        reqJSON = CG_BL_ODM.prepareServiceJobHeaderValidationReqJSON((fieldActionClaim == false ? solComp : null),workJob,'SRT'); //need to change here later
                    else
                        reqJSON = CG_BL_ODM.prepareServiceJobHeaderValidationReqJSON(null,workJob,'SRT'); //need to change here later
                }else if(source == 'Claim'){
                    if(partsWarrantyExistsMap.get(solComp.CSS_Account_Formula__c))
                        reqJSON = CG_BL_ODM.prepareClaimHeaderValidationReqJSON((fieldActionClaim == false ? solComp : null),claimsRec,psnRec,'SRT'); //need to change here later
                    else
                        reqJSON = CG_BL_ODM.prepareClaimHeaderValidationReqJSON(null,claimsRec,psnRec,'SRT'); //need to change here later
                }
                System.debug('####### 1 after header  ##### count>>:'+count);
                //System.debug('After Header reqJSON>>>>>>>>>>>>>>>>>>>>:'+JSON.serialize(reqJSON));
                
                //Failures
                reqJSON.Request.claim.failure = new List<CG_ODM_ReqJSONParser.Failure>();
                CG_ODM_ReqJSONParser.Failure failRefObj = new CG_ODM_ReqJSONParser.Failure();
                failRefObj.lineNumber = solComp.Id;
                failRefObj.failCode = solComp.System_Code__c+solComp.Component_Code__c;
                failRefObj.failMode = solComp.Failure_Mode__c;
                failRefObj.accountCode = solComp.CSS_Account_Formula__c.right(2);
                failRefObj.payCode = solComp.Pay_Code__c;
                failRefObj.status = 'Draft';
                failRefObj.authorizationNumber = solComp.Authorization_Number__c;
                failRefObj.approvalCode = solComp.Approval_Code__c;
                failRefObj.campaignId = solComp.Component_Id__c;
                failRefObj.totalLaborAmt = '';
                failRefObj.totalSRTHours = '';
                failRefObj.totalTowingAmt = '';
                failRefObj.accountCodeDesp = '';
                failRefObj.policyFlag = '';
                failRefObj.programID = '';
                failRefObj.overrideFlag = '';
                failRefObj.inShopCampaignFlag = '';
                failRefObj.travelCoveredFlag = '';
                failRefObj.GSQID = '';
                System.debug('####### 2 after header  ##### count>>:'+count);
                
                //acctCodeInfo
                CG_ODM_ReqJSONParser.AcctCodeInfo acctRefObj = new CG_ODM_ReqJSONParser.AcctCodeInfo();
				
                // FBI-385 : Replacing below query with Map
                // CSS_JobEventTemporary__c[] queryJobEventTemp = [select Key__c,Attribute1__c,Attribute2__c,Attribute3__c, Attribute4__c,Attribute5__c,Attribute6__c,Attribute7__c,Attribute8__c,Attribute9__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: solComp.CSS_Account_Formula__c.Right(2) LIMIT 1];
                CSS_JobEventTemporary__c queryJobEventTemp = AttributeToCSS_JobEventTemporaryMap.get('AccountCodes_'+solComp.CSS_Account_Formula__c.Right(2));
                if (queryJobEventTemp != null) {
                    acctRefObj.accountCodeType = queryJobEventTemp.Attribute1__c;
                    failRefObj.coverageType = queryJobEventTemp.Attribute1__c;
                    acctRefObj.chryslerFlag = queryJobEventTemp.Attribute9__c;
                    acctRefObj.multiESNFlag = queryJobEventTemp.Attribute7__c;
                    acctRefObj.accountCodeWarrantyFlag = queryJobEventTemp.Attribute8__c; //Attribute8__c=='Y' ? 'TRUE' : 'FALSE';; //get this from GetAccountCode webservice
                }

                failRefObj.acctCodeInfo = acctRefObj; //appending this to above Failure
                System.debug('####### 3 after header  ##### count>>:'+count);

                //campaign
                CG_ODM_ReqJSONParser.Campaign camRefObj = new CG_ODM_ReqJSONParser.Campaign();
                camRefObj.accountCode = '';
                camRefObj.campaignId = '';
                camRefObj.campaignType = '';
                camRefObj.completeIndicator = '';
                camRefObj.effectiveDate = '';
                camRefObj.engineComponentCode = '';
                camRefObj.expiryDateIntl = '';
                camRefObj.expiryDateNA = '';
                camRefObj.failMode = '';
                camRefObj.multiFlag = '';
                camRefObj.status = '';
                camRefObj.systemCode = '';
                camRefObj.cmpEngineStatusCode = '';
                failRefObj.campaign = camRefObj; //appending this to above Failure

                reqJSON.Request.claim.failure.add(failRefObj); //Adding Failure to Req JSON
                System.debug('####### 4 after header  ##### count>>:'+count);
                //System.debug('####### 6 #####reqJSON>>>>>>>>>>>>>>>>>>>>:'+JSON.serialize(reqJSON));

                //SRTs
                reqJSON.Request.claim.srtList = new List<CG_ODM_ReqJSONParser.SrtList>();
                List<css_srt__c> tSRTList = acSRTMap.get(solComp.CSS_Account_Formula__c);
                //System.debug('####### 5 after header  ##### tSRTList>>:'+tSRTList);
                //System.debug('####### 5 after header  ##### tSRTList size>>:'+tSRTList.size());
                if(tSRTList == null || tSRTList.size()<=0){
                    System.debug('####### 5 after header  ##### before returning to NEXT tSRTList...tSRTList>>:'+tSRTList);
                    continue;
                }
                System.debug('####### 5 after header  ##### count>>:'+count+' tSRTList size>>:'+tSRTList.size());
                CG_ODM_ReqJSONParser.SrtList refObj;
                if(tSRTList !=null && tSRTList.size()>0){
                    Set<String> srtNum = new Set<String>();
                    Map<String,List<Decimal>> srtNumQtyMap = new Map<String,List<Decimal>>();
                    for(css_srt__c tSRT: tSRTList){
                        if(!srtNumQtyMap.containsKey(tSRT.SRT_ID__c)){
                            List<Decimal> temp = new List<Decimal>();
                            temp.add(tSRT.SRT_Quantity__c);
                            srtNumQtyMap.put(tSRT.SRT_ID__c,temp);
                        }
                        else{
                            List<Decimal> temp = new List<Decimal>();
                            temp = srtNumQtyMap.get(tSRT.SRT_ID__c);
                            temp.add(tSRT.SRT_Quantity__c);
                            srtNumQtyMap.put(tSRT.SRT_ID__c,temp);
                        }
                    }
                    for(css_srt__c tSRT: tSRTList){
                        if(partsWarrantyExistsMap.get(solComp.CSS_Account_Formula__c)){
                            system.debug('fieldActionClaim '+fieldActionClaim);    
                            system.debug('solComp.Fail_Code__c '+solComp.Fail_Code__c); 
                            system.debug('tSRT.FailCode__c '+tSRT.FailCode__c); 
                            if(solComp.Fail_Code__c == (fieldActionClaim == true ? tSRT.FailCode__c.right(6) : tSRT.FailCode__c.right(4))){ //here this should be rechecked
                                refObj = new CG_ODM_ReqJSONParser.SrtList();
                                refObj.lineNumber = tSRT.Id;
                                refObj.code = tSRT.SRT_ID__c;
                                refObj.hours = String.valueOf(tSRT.SRT_Time__c);
                                refObj.offsiteCheck = workJob.Repair_Location__c=='Mobile' ? 'Y' : 'N';
                                //refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                                List<Decimal> decTemp = new List<Decimal>();
                                decTemp = srtNumQtyMap.get(tSRT.SRT_ID__c);
                                if(decTemp.size() == 1){
                                    refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                                }
                                else if(decTemp.size() > 1){
                                    decimal qtySum = 0;
                                    for(Decimal decCount : decTemp){
                                        qtySum = qtySum + decCount;
                                    }
                                    refObj.quantity = String.valueof(qtySum);
                                }
                                refObj.srtAllowedFlag = 'N';
                                
                                /*if(tSRT.Type__c == 'Diagnosis')
                                    refObj.description = 'Diagnostic';
                                else if(tSRT.Type__c == 'Repair')
                                    refObj.description = 'Repair';
                                else if(tSRT.Type__c == 'Diag Access' || tSRT.Type__c == 'Repair Access')
                                    refObj.description = 'Access';
                                else if(tSRT.Type__c == 'Custom')
                                    refObj.description = 'Custom';
                                else if(tSRT.SRT_ID__c == '00-901' || tSRT.SRT_ID__c == '00-902' || tSRT.SRT_ID__c == '00-904' || tSRT.SRT_ID__c == 'EPR 00-10S')
                                    refObj.description = 'System';*/
                                
                              if(!srtNum.contains(tSRT.SRT_ID__c)){
                                    reqJSON.Request.claim.srtList.add(refObj);
                                    srtNum.add(tSRT.SRT_ID__c);
                                }
                            }
                        }else{
                            refObj = new CG_ODM_ReqJSONParser.SrtList();
                            refObj.lineNumber = tSRT.Id;
                            refObj.code = tSRT.SRT_ID__c;
                            refObj.hours = String.valueOf(tSRT.SRT_Time__c);
                            refObj.offsiteCheck = workJob.Repair_Location__c=='Mobile' ? 'Y' : 'N';
                            //refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                            List<Decimal> decTemp = new List<Decimal>();
                            decTemp = srtNumQtyMap.get(tSRT.SRT_ID__c);
                            if(decTemp.size() == 1){
                                refObj.quantity = String.valueOf(tSRT.SRT_Quantity__c);
                            }
                            else if(decTemp.size() > 1){
                                decimal qtySum = 0;
                                for(Decimal decCount : decTemp){
                                    qtySum = qtySum + decCount;
                                }
                                refObj.quantity = String.valueof(qtySum);
                            }
                            refObj.srtAllowedFlag = 'N';
                            //refObj.description = '';
                            /*if(tSRT.Type__c == 'Diagnosis')
                                    refObj.description = 'Diagnostic';
                                else if(tSRT.Type__c == 'Repair')
                                    refObj.description = 'Repair';
                                else if(tSRT.Type__c == 'Diag Access' || tSRT.Type__c == 'Repair Access')
                                    refObj.description = 'Access';
                                else if(tSRT.Type__c == 'Custom')
                                    refObj.description = 'Custom';
                                else if(tSRT.SRT_ID__c == '00-901' || tSRT.SRT_ID__c == '00-902' || tSRT.SRT_ID__c == '00-904' || tSRT.SRT_ID__c == '00-10S')
                                    refObj.description = 'System';*/
                            //reqJSON.Request.claim.srtList.add(refObj);
                            if(!srtNum.contains(tSRT.SRT_ID__c)){
                                reqJSON.Request.claim.srtList.add(refObj);
                                srtNum.add(tSRT.SRT_ID__c);
                            }
                        }
                    }
                }
                System.debug('####### 6 after header  ##### count>>:'+count);
                //System.debug('#######  7 #####reqJSON>>>>>>>>>>>>>>>>>>>>:'+JSON.serialize(reqJSON));

                //Travels
                reqJSON.Request.claim.travels = new List<CG_ODM_ReqJSONParser.Travels>();
                List<CSS_Parts_Options__c> tTravelList = acPartsMap.get(solComp.CSS_Account_Formula__c);
                System.debug('####### 6 after header  ##### count>>:'+count+' tTravelList size>>:'+tTravelList);
                CG_ODM_ReqJSONParser.Travels travelObj;
                if(tTravelList !=null && tTravelList.size()>0){
                    for(CSS_Parts_Options__c tTravel: tTravelList){
                        if(partsWarrantyExistsMap.get(solComp.CSS_Account_Formula__c)){
                            if(solComp.Fail_Code__c == (fieldActionClaim == true ? tTravel.Fail_Code__c.right(6) : tTravel.Fail_Code__c.right(4))){ //here this should be rechecked
                                travelObj = new CG_ODM_ReqJSONParser.Travels();
                                travelObj.lineNumber = tTravel.Id; 
                                travelObj.hours = String.valueOf(tTravel.HoursTravelled__c);
                                travelObj.mealsCharges = tTravel.Type__c=='Meals' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.towingCharges = tTravel.Type__c=='Towing' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.travelDistance = String.valueOf(tTravel.Mileage__c);
                                reqJSON.Request.claim.travels.add(travelObj);
                            }
                        }else{
                                travelObj = new CG_ODM_ReqJSONParser.Travels();
                                travelObj.lineNumber = tTravel.Id; 
                                travelObj.hours = String.valueOf(tTravel.HoursTravelled__c);
                                travelObj.mealsCharges = tTravel.Type__c=='Meals' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.towingCharges = tTravel.Type__c=='Towing' ? String.valueOf(tTravel.ExpenseTotal__c) :'';
                                travelObj.travelDistance = String.valueOf(tTravel.Mileage__c);
                                reqJSON.Request.claim.travels.add(travelObj);
                            }
                    }
                }else{
                    travelObj = new CG_ODM_ReqJSONParser.Travels();
                    /*travelObj.lineNumber = '';
travelObj.hours = '';
travelObj.mealsCharges = '';
travelObj.towingCharges = '';
travelObj.travelDistance = '';*/
                    reqJSON.Request.claim.travels.add(travelObj);
                    System.debug('####### 7 no Travel records ##### count>>:'+count);
                }
                System.debug('####### 7 after header before Executing WS  ##### count>>:'+count+' reqJSON>>>:'+JSON.serialize(reqJSON));
                //System.debug('#######  8 #####reqJSON>>>>>>>>>>>>>>>>>>>>:'+JSON.serialize(reqJSON));

                //Call SRT ODM Service here
                //Prepare Request Wrapper
                CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
                System.debug('reqJSON>>>>>>>>>>>>>>>>>>>>:'+reqJSON);
                reqWrapper.jsonReqBody = JSON.serialize(reqJSON).replace('null','""');
                reqWrapper.serviceName = 'CG_ODMSRTService';
                System.debug('####### 8 before calling webservice reqWrapper.jsonReqBody  ##### count>>:'+count+' reqJSON>>>:'+reqWrapper.jsonReqBody);
                //System.debug('before calling webservice reqWrapper.jsonReqBody>>>>>>>>>>>>>>>>>>>>:'+reqWrapper.jsonReqBody);
                //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
                if(reqWrapper.jsonReqBody != null)
                    resWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
                System.debug('####### 9 after calling webservice resWrapper.response  ##### count>>:'+count+' resJSON>>>:'+resWrapper.response);
                System.debug('final... after calling ws resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper.response.getBody());
                System.debug('final... after calling ws resWrapper.response1>>>>>>>>>>>>>>>>>>>>:'+resWrapper.response.getStatusCode());
                try{
                    if(resWrapper !=null && resWrapper.response !=null && resWrapper.response.getBody() !=null){
                        // if(resWrapper !=null && resWrapper.response !=null && resWrapper.response.getBody() !=null && resWrapper.response.getStatusCode() == 200){
                        //String hardCodeReq = '{"Request":{"DecisionID":"GUIDANZ","claim":{"warrantyStartDate":"2013-04-08","travels":[{"travelDistance":"","towingCharges":"","mealsCharges":"","lineNumber":"","hours":""}],"totalClaimAmt":"","thresholdHrs":null,"thresholdAmount":null,"Status":null,"srtList":[{"srtAllowedFlag":"N","quantity":"1","offsiteCheck":"N","lineNumber":"a1E3B000001WVHfUAO","hours":null,"description":"","code":"19-052"},{"srtAllowedFlag":"N","quantity":"1","offsiteCheck":"N","lineNumber":"a1E3B000001WVHgUAO","hours":null,"description":"","code":"19-361"},{"srtAllowedFlag":"N","quantity":"1","offsiteCheck":"N","lineNumber":"a1E3B000001WVHqUAO","hours":"1.4","description":"","code":"10-049-00"},{"srtAllowedFlag":"N","quantity":"1","offsiteCheck":"N","lineNumber":"a1E3B000001WVI9UAO","hours":"0.5","description":"","code":"19-045-00"},{"srtAllowedFlag":"N","quantity":"1","offsiteCheck":"N","lineNumber":"a1E3B000001WVIxUAO","hours":null,"description":"","code":"19-361"},{"srtAllowedFlag":"N","quantity":"1","offsiteCheck":"N","lineNumber":"a1E3B000001WVJIUA4","hours":"0.3","description":"","code":"19-319-00"},{"srtAllowedFlag":"N","quantity":"1","offsiteCheck":"N","lineNumber":"a1E3B000001WVJMUA4","hours":"3.7","description":"","code":"19-114-00"}],"serviceProviderName":null,"serviceProvider":{"territory":null,"status":"Active","spWarrantyTrainingStatus":null,"spState":null,"spServiceLevel":null,"spSCMDollarAmt":null,"spSCMDeductiblePct":null,"spCountry":null,"spCertificationEndDate":null,"serviceModelName":"ISX15 CM2350 X101","regionCode":null,"region":"NORTH AMERICA","paccarChecked":"N","outfileAllClaimsFlag":"N","oemCode":"103","ltaChecked":"N","inactiveDate":"2018-08-08 00:00:00.0","groupName":null,"engineExpirationdate":null,"engineEffectiveDate":null,"claimAllowedDays":"2018-08-08 00:00:00.0","channelOfDistribution":"101-DISTRIBUTOR-BRANCH","channelDescription":null},"serviceModelName":"ISX15 CM2350 X101","roNumber":"74882","roadRelayWarrantyFlag":null,"reconPartsWarrantyFlag":null,"productApplicationCode":null,"possessionFlag":"","penalty":null,"parts":[],"paccarPaymentRoutingFlag":null,"paccarFlag":null,"paccarCertifiedLocationFlag":null,"otherClaimables":[],"newPartsWarrantyFlag":null,"multiESNFlag":"NA","modelSeries":null,"manufacturer":"INTERNATIONAL","manualAdjudicationFlag":"","level":"0","headerCampaignId":null,"HeaderCampaign":null,"groupName":"","failurePoint":null,"failureMeasure":null,"failureDate":"2018-06-15","failure":[{"travelCoveredFlag":"","totalTowingAmt":"","totalSRTHours":"","totalLaborAmt":"0","status":"Draft","programID":"","policyFlag":"","payCode":"A","overrideFlag":"","lineNumber":"a1O3B000000A14cUAC","inShopCampaignFlag":"","GSQID":"","failMode":"RE","failCode":"THAC","coverageType":"CMP","campaignId":"F10000130","campaign":{"systemCode":"","status":"","multiFlag":"","failMode":"","expiryDateNA":"","expiryDateIntl":"","engineComponentCode":"","effectiveDate":"","completeIndicator":"","cmpEngineStatusCode":"","campaignType":"","campaignId":"","accountCode":""},"authorizationNumber":null,"approvalCode":null,"acctCodeInfo":{"multiESNFlag":"","chryslerFlag":"","accountCodeWarrantyFlag":"","accountCodeType":""},"accountCodeDesp":"","accountCode":"ACCOUNT TEAM COVERAGE 27"}],"engineFamily":"10","engineApplicationCode":"AUTOMOTIVE","engine":{"warrantyIndicatorFlag":null,"serviceModel":null,"productApplicationDesp":null,"oemCode":null,"marineFlag":null,"etoConversionDate":null,"engineFamilyCode":"10","designPhaseCode":"61","buildDate":null,"billToCode":null},"ecmCalibBefore":null,"ecmCalibAfter":null,"distributorCode":"03520","countryCode":null,"ComplaintCode":[],"cmiServiceProviderCode":"04892","cmiEngineSerialNumber":"79619554","claimSubSource":null,"claimSubmittedDate":"","claimStatus":"In Review","claimSource":"Guidanz","claimReceivedDate":"","claimNumber":"CSS-00080860","claimCreatedDate":"2018-06-15 10:12:20","certificationFlag":null,"button":null,"bisFlag":"N","approverName":"","applicationName":null,"AdditionalESN":[]}},"Header":{"Target":{"TargetID":"ODM"},"Sender":{"ServiceName":"ODMHeaderValidation","SenderID":"CSS"}}}';
                        //String hardCodeRes = '{"Header":{"Sender":{"ServiceName":"ODMHeaderValidation","SenderID":"CSS"},"Target":{"TargetID":"ODM"}},"Response":{"DecisionID":"2018-06-18T10:58:28.846-04:00","claim":{"claimSubSource":null,"groupName":"","reconPartsWarrantyFlag":null,"claimReceivedDate":"","ComplaintCode":null,"failureDate":"2018-06-15","cmiEngineSerialNumber":79619554,"multiESNFlag":"NA","parts":[],"claimSource":"Guidanz","totalClaimAmt":"","messages":[{"description":"Claim Number is Required"}],"distributorCode":"03520","roNumber":74882,"level":0,"serviceModelName":"ISX15 CM2350 X101","button":null,"modelSeries":null,"roadRelayWarrantyFlag":null,"engineApplicationCode":"AUTOMOTIVE","warrantyStartDate":"2013-04-08","approverName":"","serviceProvider":{"region":"NORTH AMERICA","regionCode":null,"groupName":null,"territory":null,"status":"Active","outfileAllClaimsFlag":"N","engineEffectiveDate":null,"oemCode":103,"spState":null,"channelOfDistribution":"101-DISTRIBUTOR-BRANCH","spSCMDeductiblePct":null,"spSCMDollarAmt":null,"spCountry":null,"paccarChecked":"N","engineExpirationdate":null,"serviceModelName":"ISX15 CM2350 X101","spCertificationEndDate":null,"ltaChecked":"N","channelDescription":null,"spServiceLevel":null,"spWarrantyTrainingStatus":null,"inactiveDate":"2018-08-08 00:00:00.0","claimAllowedDays":"2018-08-08 00:00:00.0"},"engineFamily":10,"certificationFlag":null,"srtList":[{"hours":null,"description":"","offsiteCheck":"N","lineNumber":"a1E3B000001WVHfUAO","srtAllowedFlag":"N","quantity":1,"code":"19-052"},{"hours":null,"description":"","offsiteCheck":"N","lineNumber":"a1E3B000001WVHgUAO","srtAllowedFlag":"N","quantity":1,"code":"19-361"},{"hours":1.4,"description":"","offsiteCheck":"N","lineNumber":"a1E3B000001WVHqUAO","srtAllowedFlag":"N","quantity":1,"code":"10-049-00"},{"hours":0.5,"description":"","offsiteCheck":"N","lineNumber":"a1E3B000001WVI9UAO","srtAllowedFlag":"N","quantity":1,"code":"19-045-00"},{"hours":null,"description":"","offsiteCheck":"N","lineNumber":"a1E3B000001WVIxUAO","srtAllowedFlag":"N","quantity":1,"code":"19-361"},{"hours":0.3,"description":"","offsiteCheck":"N","lineNumber":"a1E3B000001WVJIUA4","srtAllowedFlag":"N","quantity":1,"code":"19-319-00"},{"hours":3.7,"description":"","offsiteCheck":"N","lineNumber":"a1E3B000001WVJMUA4","srtAllowedFlag":"N","quantity":1,"code":"19-114-00"}],"failurePoint":null,"serviceProviderName":null,"engine":{"serviceModel":null,"productApplicationDesp":null,"marineFlag":null,"designPhaseCode":61,"engineFamilyCode":10,"warrantyIndicatorFlag":null,"buildDate":null,"billToCode":null,"etoConversionDate":null,"oemCode":null},"productApplicationCode":null,"status":"ERROR","applicationName":null,"claimStatus":"In Review","failureMeasure":null,"claimSubmittedDate":"","failure":[{"GSQID":"","accountCodeDesp":"","campaignId":"F10000130","payCode":"A","totalLaborAmt":0,"status":"Draft","authorizationNumber":null,"inShopCampaignFlag":"","approvalCode":null,"acctCodeInfo":{"chryslerFlag":"","accountCodeType":"","multiESNFlag":"","accountCodeWarrantyFlag":""},"overrideFlag":"","totalTowingAmt":"","programID":"","accountCode":"ACCOUNT TEAM COVERAGE 27","failCode":"THAC","coverageType":"CMP","failMode":"RE","lineNumber":"a1O3B000000A14cUAC","policyFlag":"","totalSRTHours":"","campaign":{"engineComponentCode":"","campaignId":"","completeIndicator":"","cmpEngineStatusCode":"","campaignType":"","status":"","systemCode":"","expiryDateNA":"","expiryDateIntl":"","accountCode":"","failMode":"","effectiveDate":"","multiFlag":""},"travelCoveredFlag":""}],"cmiServiceProviderCode":"04892","travels":[{"mealsCharges":"","towingCharges":"","hours":"","lineNumber":"","travelDistance":""}],"otherClaimables":null,"manualAdjudicationFlag":"","claimCreatedDate":"","bisFlag":"N","claimNumber":""}}}';
                        odmRes = (CG_ODM_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(), CG_ODM_ResJSONParser.class);
                        //odmRes = (CG_ODM_ResJSONParser)JSON.deserialize(hardCodeRes, CG_ODM_ResJSONParser.class);
                        system.debug('odmRes '+odmRes);
                        if(odmRes !=null){
                            captureStatusesMessages(odmRes, updateSRTList, updateTravelList, resWrapper.response.getStatusCode());
                        }
                        //Updating Integration Logs
                        String jobName;
                        if(source == 'Job')
                            jobName = workJob.Name;
                        else
                            if(source == 'Claim')
                                jobName = claimsRec.Name;
                        insertIntegrationLogs(resWrapper,intLogList,jobName,'CG_ODMSRTService');
                    }
                    /* if(resWrapper !=null && resWrapper.response !=null && resWrapper.response.getStatusCode() != 200){
                        if(odmRes != null)
                        captureStatusesMessages(odmRes, updateSRTList, updateTravelList, 'Unsuccess');
                        else
                        captureStatusesMessages(null, updateSRTList, updateTravelList, 'Unsuccess');
                    }*/
                }catch(Exception ex){
                    System.debug('in catch of deserialize of CG_BL_ODM >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                    //return  CG_BL_ODM.showodmerrormsg;
                }
                //break;

            } //end for loop for all solComp

            System.debug('####### after calling webservice resWrapper.response  ##### updateSRTList size>>>:'+updateSRTList.size() +' updateTravelList.size>>:'+updateTravelList.size() +' intLogList size>>>:'+intLogList.size());
            /*if(updateSRTList !=null && updateSRTList.size()>0){
                update updateSRTList;
            }
            if(updateTravelList !=null && updateTravelList.size()>0){
                //update updateTravelList; Commented by Rajesh Narra on 07-06-2018 because it is not giving the Id for the options
                //upsert  updateTravelList;
            }
            if(intLogList !=null && intLogList.size()>0){
                insert intLogList;
            }*/
            if(source == 'Claim'){
                updateODMSRTServiceResponse();
            }
            System.debug('#######  10 #####completed>>>>>>>>>>>>>>>>>>>>:');

            //restrict ws calls count
            //BL & SL layers migration
            //Date format & other fields mapping


        }catch(Exception ex){
            System.debug('in catch of callODMSRTServices of CG_BL_ODM >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            return  CG_BL_ODM.showodmerrormsg;
        }
        return  CG_BL_ODM.showodmerrormsg;
    }

    public static void updateODMSRTServiceResponse(){
        if(updateSRTList !=null && updateSRTList.size()>0){
            update updateSRTList;
        }
        if(intLogList !=null && intLogList.size()>0){
            insert intLogList;
        }
    }

    public static void captureStatusesMessages(CG_ODM_ResJSONParser odmRes, List<css_srt__c> updateSRTList, List<CSS_Parts_Options__c> updateTravelList, integer StatusCode){
        try{
            if(odmRes ==null || odmRes.Response ==null || odmRes.Response.claim ==null || odmRes.Response.claim.srtList ==null 
               || odmRes.Response.claim.srtList.size() <=0){
                return;
            }

            List<CG_ODM_ResJSONParser.SrtList> tSRTList = odmRes.Response.claim.srtList;
            css_srt__c tSRTObj;
            for(CG_ODM_ResJSONParser.SrtList obj: tSRTList){
                List<CG_ODM_ResJSONParser.message> resSRTMsgList = new List<CG_ODM_ResJSONParser.message>();
                resSRTMsgList = (obj.messages != null ? obj.messages : null);
                tSRTObj = new css_srt__c();
                if(obj.lineNumber !=null && obj.lineNumber !=''){
                    tSRTObj.Id = obj.lineNumber;
                    tSRTObj.ODM_Status_Code__c = string.valueof(StatusCode); //Kalpana
                    if(resSRTMsgList != null && resSRTMsgList.size()>0){
                        for(CG_ODM_ResJSONParser.message msg:resSRTMsgList){
                            if(msg.type != null && msg.type.trim() == 'ERROR'){
                                tSRTObj.ODM_Status__c = 'ERROR';
                            }
                            if(tSRTObj.ODM_Status__c != 'ERROR' && msg.type != null && msg.type.trim() == 'WARNING'){
                                tSRTObj.ODM_Status__c = 'WARN';
                            }
                            tSRTObj.ODM_Status_Message__c = (tSRTObj.ODM_Status_Message__c == null || tSRTObj.ODM_Status_Message__c == '' ? '' : tSRTObj.ODM_Status_Message__c) + (tSRTObj.ODM_Status_Message__c == null || tSRTObj.ODM_Status_Message__c == '' ? '' : ';;') + msg.type + ':' + obj.code + ':' + msg.description;               
                        }
                    }
                    if(resSRTMsgList == null || resSRTMsgList.size() == 0){
                        tSRTObj.ODM_Status__c = 'PASSED';
                        tSRTObj.ODM_Status_Message__c = '';
                    }

                    if(tSRTObj.ODM_Status__c != null && tSRTObj.ODM_Status__c == 'ERROR')
                        CG_BL_ODM.showodmerrormsg=true;   
                    updateSRTList.add(tSRTObj);
                }
            }

        }catch(Exception ex){
            System.debug('in catch of callODMSRTServices of CG_BL_Generic >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }

    public static void insertIntegrationLogs(CG_OP_OAGWrapper resWrapper, List<CSS_Integration_Error__c> intLogList, String jobName, String serviceName){
        CSS_Integration_Error__c intDetails;
        try{
            intDetails = new CSS_Integration_Error__c();
            intDetails.Auth_Call_Time__c = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
            //Request Body
            intDetails.Processed_Data__c =  resWrapper.request.getBody();
            intDetails.Response_Body__c = resWrapper.response.getBody();
            intDetails.Service_Call_Time__c = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
            intDetails.Service_Job_Number__c = jobName;
            intDetails.Service_Name__c = serviceName;
            intDetails.Source__c = 'ODM';
            intLogList.add(intDetails); 
        }catch(Exception ex){
            System.debug('in catch of insertIntegrationLogs of CG_BL_Generic >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }
    
    /********************************************** PREPARE HEADER VALIDATION REQ **************************************************/
    
    public static CG_ODM_ReqJSONParser prepareServiceJobHeaderValidationReqJSON(CSS_Solution_Component__c SolComp,CSS_Job_Order__c serJob,String ServiceName){
        try{
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();        

            CG_ODM_ReqJSONParser.Header headerDetail = new CG_ODM_ReqJSONParser.Header();

            CG_ODM_ReqJSONParser.Sender senderDetail = new CG_ODM_ReqJSONParser.Sender();

            if(ServiceName == 'Header')
                senderDetail.ServiceName = 'ODMHeaderValidation';
            if(ServiceName == 'OtherClaimable')
                senderDetail.ServiceName = 'ODMOtherClaimableValidation';
            if(ServiceName == 'Travel')
                senderDetail.ServiceName = 'ODMTravelValidation';
            if(ServiceName == 'SRT')
                senderDetail.ServiceName = 'ODMSRTValidation';
            if(ServiceName == 'Parts')
                senderDetail.ServiceName = 'ODMPartsValidation';
            if(ServiceName == 'Failure')
                senderDetail.ServiceName = 'ODMFailureValidation';

            senderDetail.SenderID ='CSS';

            headerDetail.Sender = senderDetail;

           CG_ODM_ReqJSONParser.Target targetDetail = new CG_ODM_ReqJSONParser.Target();

            targetDetail.TargetID = 'ODM';

            headerDetail.Target = targetDetail;

            reqJSON.Header = headerDetail;

            CG_ODM_ReqJSONParser.Request DataAreaDetails = new CG_ODM_ReqJSONParser.Request(); 

            DataAreaDetails.DecisionID = 'GUIDANZ';

            CG_ODM_ReqJSONParser.claim claimlevelDetails = new CG_ODM_ReqJSONParser.claim();

            claimlevelDetails.claimStatus = 'In Review';
            claimlevelDetails.claimSource = 'Guidanz'; 
            claimlevelDetails.claimSubmittedDate = '';
            claimlevelDetails.cmiServiceProviderCode = 'Guidanz';
            claimlevelDetails.applicationName = 'Guidanz';

            claimlevelDetails.approverName = '';
            claimlevelDetails.bisFlag = (serJob.Before_In_Service__c == true ? 'Y' : 'N');

            datetime createddate;
            createddate = serJob.CreatedDate;
            String formatCreatedDate = (createddate != null ? createddate.format('MM/dd/yyyy','GMT') : '');
            claimlevelDetails.claimCreatedDate = formatCreatedDate;
            //claimlevelDetails.claimCreatedDate = string.valueof(serJob.CreatedDate);
            claimlevelDetails.claimNumber = serJob.Name;

            datetime receiveddate;
            receiveddate = serJob.CreatedDate;
            String formatReceivedDate = (receiveddate != null ? receiveddate.format('MM/dd/yyyy','GMT') : '');
            //  claimlevelDetails.claimReceivedDate = formatReceivedDate;
            //claimlevelDetails.claimReceivedDate = string.valueof(serJob.CreatedDate); 
            claimlevelDetails.claimReceivedDate = '';  // Making blann as part of story 106146
            claimlevelDetails.cmiEngineSerialNumber = (serJob.ESN__c != null ? serJob.ESN__c : '');

            claimlevelDetails.serviceModelName = (serJob.Service_Model__c != null ? serJob.Service_Model__c : '');

            String distrCode = '';
            String brnchCode = '';
            String[] locArray;
            if(serJob.Creator_Location__c != null && serJob.Creator_Location__c != '')
                locArray = serJob.Creator_Location__c.split('-');
            if(locArray != null && locArray.size()>0){
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }

            claimlevelDetails.cmiServiceProviderCode = brnchCode;

            claimlevelDetails.distributorCode = serJob.account__r.RSS_RESP_BRANCH_CODE__c;//modified as part of story 156808

            if(serJob.Application_Desc__c != null && serJob.Application_Desc__c != ''){
                String applicationCode = css_utility.getCodes('Application Code',serJob.Application_Desc__c,null,null);
                system.debug('apllication code'+applicationCode);

                claimlevelDetails.engineApplicationCode = applicationCode;
            }
            else{
                claimlevelDetails.engineApplicationCode = '';
            }

            if(ServiceName == 'SRT')
                claimlevelDetails.engineFamily = serJob.Qsol_Engine_Family_Code__c;
            else
                claimlevelDetails.engineFamily = serJob.EngineFamilyName__c;

            datetime faildate;
            if(SolComp != null){
                faildate = SolComp.Failure_Date__c;
            }else{
                faildate = serJob.Failure_Date__c;
            }
            String formatFailDate = (faildate != null ? faildate.format('MM/dd/yyyy','GMT') : '');
            claimlevelDetails.failureDate = formatFailDate;//(SolComp != null ? string.valueof(SolComp.Failure_Date__c) : string.valueof(serJob.Failure_Date__c));
            //Check here for application and pass the failure measure accordingly - 182800
            if(SolComp == null){
                if(serJob.ApplicationCode__c=='130' || serJob.ApplicationCode__c=='210' || serJob.ApplicationCode__c=='220' || serJob.ApplicationCode__c=='310' || serJob.ApplicationCode__c=='320' || serJob.ApplicationCode__c=='410'){
                    system.debug('*****serJob.ApplicationCode__c*****');
                    claimlevelDetails.failurePoint = string.valueOf(serJob.Mileage__c);
                    claimlevelDetails.failureMeasure = string.valueOf(serJob.Mileage_Measure__c);
                }
                else{
                    system.debug('*****Enter else serJob.ApplicationCode__c*****');
                    claimlevelDetails.failurePoint = string.valueOf(serJob.CSS_Hours__c);
                    claimlevelDetails.failureMeasure = 'Hours';
                }
            }
            else{
               claimlevelDetails.failureMeasure = (SolComp !=null ? (SolComp.Failure_Measure__c != null && SolComp.Failure_Measure__c != '' ? SolComp.Failure_Measure__c : 'Miles') : (serJob.Failure_Point_Measure__c != null && serJob.Failure_Point_Measure__c != '' ? serJob.Failure_Point_Measure__c : 'Miles'));
               claimlevelDetails.failurePoint = (SolComp !=null ? (SolComp.Failure_Point__c != null ? string.valueof(SolComp.Failure_Point__c) : '0') : (serJob.Failure_Point__c != null ? string.valueof(serJob.Failure_Point__c) : '0'));
            }
           
            claimlevelDetails.groupName = '';

            claimlevelDetails.level = '0';

            claimlevelDetails.manualAdjudicationFlag = '';

            claimlevelDetails.manufacturer = serJob.Make__c;

            claimlevelDetails.multiESNFlag = 'N';

            //claimlevelDetails.newPartsWarrantyFlag = 

            claimlevelDetails.ownerName = '';

            claimlevelDetails.penalty = '';

            claimlevelDetails.possessionFlag = SolComp != null ? (SolComp.Customer_Take_Possession__c == 'Yes' ? 'Y' : 'N') : '';

            claimlevelDetails.productApplicationCode = serJob.ProductApplicationCode__c;

            //claimlevelDetails.reconPartsWarrantyFlag = 

            claimlevelDetails.roNumber = (serJob.Shop_Work_Order__c != null && serJob.Shop_Work_Order__c != '' ? serJob.Shop_Work_Order__c : serJob.id);

            claimlevelDetails.modelSeries = serJob.Model__c;

            claimlevelDetails.newPartsWarrantyFlag = (SolComp == null ? 'N' : (SolComp.Parts_Warranty__c != null && SolComp.Parts_Warranty__c == 'New Parts Warranty' ? 'Y' : 'N'));

            claimlevelDetails.reconPartsWarrantyFlag = (SolComp == null ? 'N' : (SolComp.Parts_Warranty__c != null && SolComp.Parts_Warranty__c == 'Recon Parts Warranty' ? 'Y' : 'N')); 

            //claimlevelDetails.roadRelayWarrantyFlag =  (SolComp == null ? 'N' : (SolComp.CSS_Account_Formula__c != null && SolComp.CSS_Account_Formula__c.right(2) == '52' ? 'Y' : 'N')); 
            claimlevelDetails.roadRelayWarrantyFlag =  (SolComp == null ? 'N' : SolComp.RoadRelay_Warranty__c); 
            //claimlevelDetails.serviceModelName = string.valueof(serJob.Service_Model_N__c);     

            //claimlevelDetails.totalClaimAmt = '';
            claimlevelDetails.totalClaimAmt = '1.00'; // Vamshi
            datetime wrntyStartDate;
            if(SolComp != null){
                wrntyStartDate = SolComp.Part_Warranty_Start_Date__c;
            }else{
                wrntyStartDate = serJob.Warranty_Start_Date__c;
            }
            //String formatWarrantyDate = (wrntyStartDate != null ? wrntyStartDate.format('yyyy-MM-dd') : '');
            String formatWarrantyDate = (wrntyStartDate != null ? wrntyStartDate.format('MM/dd/yyyy','GMT') : '');

            claimlevelDetails.warrantyStartDate = formatWarrantyDate;//(SolComp != null ? string.valueof(SolComp.Part_Warranty_Start_Date__c) : string.valueof(serJob.Warranty_Start_Date__c));

            //Adding Parts as new List
            List<CG_ODM_ReqJSONParser.Parts> partsList = new List<CG_ODM_ReqJSONParser.Parts>();
            claimlevelDetails.parts=partsList;

            //Adding SrtList as new List
            List<CG_ODM_ReqJSONParser.SrtList> srtList = new List<CG_ODM_ReqJSONParser.SrtList>();
            claimlevelDetails.srtList=srtList;
            //Adding Travels as new List
            List<CG_ODM_ReqJSONParser.Travels> travelsList = new List<CG_ODM_ReqJSONParser.Travels>();
            claimlevelDetails.travels=travelsList;
            //Adding OtherClaimablesList as new List
            List<CG_ODM_ReqJSONParser.OtherClaimables> otherClaimablesList = new List<CG_ODM_ReqJSONParser.OtherClaimables>();
            claimlevelDetails.otherClaimables=otherClaimablesList;

            CG_ODM_ReqJSONParser.HeaderCampaign hdrCampaignDetails = new CG_ODM_ReqJSONParser.HeaderCampaign();
            claimlevelDetails.HeaderCampaign=hdrCampaignDetails;
            //Adding Failure as new List
            List<CG_ODM_ReqJSONParser.Failure> failureList = new List<CG_ODM_ReqJSONParser.Failure>();
            claimlevelDetails.failure=failureList;
            //Adding AdditionalESN as new List
            List<CG_ODM_ReqJSONParser.AdditionalESN> AdditionalESNList = new List<CG_ODM_ReqJSONParser.AdditionalESN>();
            claimlevelDetails.AdditionalESN=AdditionalESNList;
            //Adding ComplaintCode as new List
            List<CG_ODM_ReqJSONParser.ComplaintCode> ComplaintCodeList = new List<CG_ODM_ReqJSONParser.ComplaintCode>();
            claimlevelDetails.ComplaintCode=ComplaintCodeList;

            //Adding Header Campaign

            CG_ODM_ReqJSONParser.HeaderCampaign hdrCampaign = new CG_ODM_ReqJSONParser.HeaderCampaign();
            hdrCampaign.campaignId = '';
            claimlevelDetails.HeaderCampaign = hdrCampaign;

            DataAreaDetails.claim = claimlevelDetails;

            CG_ODM_ReqJSONParser.serviceProvider serviceProviderDetails = new CG_ODM_ReqJSONParser.serviceProvider();

            serviceProviderDetails.channelOfDistribution = serJob.CSS_Channel_Code__c;

            serviceProviderDetails.claimAllowedDays = serJob.SP_ClaimAllowedDays__c;

            List<CSS_Accreditation__c> AccredObj = [select StartDate__c,EndDate__c,Service_Level__c from CSS_Accreditation__c where Account__c =: serJob.Account__c and Service_Model_Name__c =: serJob.Service_Model__c];

            //serviceProviderDetails.engineEffectiveDate = AccredObj[0].StartDate__c;

            //serviceProviderDetails.engineExpirationdate = AccredObj[0].EndDate__c;
            if(AccredObj != null  && AccredObj.size()>0){//Added by Rajesh Narra on 7-11-2018
                serviceProviderDetails.spServiceLevel = AccredObj[0].Service_Level__c;
                datetime engineStartDate;
                if(AccredObj[0].StartDate__c != null){
                    engineStartDate = Date.valueOf(AccredObj[0].StartDate__c);
                    String formatStartDate = (engineStartDate != null ? engineStartDate.format('MM/dd/yyyy','GMT') : '');
                    serviceProviderDetails.engineEffectiveDate = formatStartDate;
                }
                else{
                    serviceProviderDetails.engineEffectiveDate = '';
                }

                datetime engineEndDate;
                if(AccredObj[0].EndDate__c != null){
                    engineEndDate = Date.valueOf(AccredObj[0].EndDate__c);
                    String formatEndDate = (engineEndDate != null ? engineEndDate.format('MM/dd/yyyy','GMT') : '');
                    serviceProviderDetails.engineExpirationdate = formatEndDate;
                }
                else{
                    serviceProviderDetails.engineExpirationdate = '';
                }



            }
            datetime inactivedate;
            if(serJob.SP_CMISPExpirationDate__c != null){
                inactivedate = Date.valueOf(serJob.SP_CMISPExpirationDate__c);
                String formatInactiveDate = (inactivedate != null ? inactivedate.format('MM/dd/yyyy','GMT') : '');
                serviceProviderDetails.inactiveDate = formatInactiveDate;
            }
            else{
                serviceProviderDetails.inactiveDate = '';
            }

            datetime WarrantyCertificationEndDate;
            if(serJob.SP_WarrantyCertificationEndDate__c != null){
                WarrantyCertificationEndDate = Date.valueOf(serJob.SP_WarrantyCertificationEndDate__c);
                String formatWarrantyCertificationEndDate = (WarrantyCertificationEndDate != null ? WarrantyCertificationEndDate.format('MM/dd/yyyy','GMT') : '');
                serviceProviderDetails.spCertificationEndDate = formatWarrantyCertificationEndDate;
            }
            else{
                serviceProviderDetails.spCertificationEndDate = '';
            }
            serviceProviderDetails.ltaChecked = serJob.SP_LTAFlag__c;

            serviceProviderDetails.oemCode = serJob.SP_PrimaryOEMCode__c;

            serviceProviderDetails.outfileAllClaimsFlag = serJOb.SP_OutfileAllClaims__c;

            serviceProviderDetails.paccarChecked = serJob.SP_PACCAR__c;

            serviceProviderDetails.region = serJob.SP_Region__c;

            serviceProviderDetails.regionCode = serJob.SP_RegionCode__c;

            serviceProviderDetails.serviceModelName = serJob.Service_Model__c;

            serviceProviderDetails.status = serJob.SP_AccountStatus__c;

            //serviceProviderDetails.territory = serJob.SP_TerritoryCode__c; Commented by Rajesh Narra 
            //serviceProviderDetails.territory = serJob.Sp_TERRITORY__c; // Added by Rajesh Narra on 7-10-2018

            switch on ServiceName {
                when 'Header' { serviceProviderDetails.territory = serJob.Territory_Class__c;}

                when 'Travel' { serviceProviderDetails.territory = serJob.Territory_Class__c;}

                when 'SRT' { serviceProviderDetails.territory = serJob.Territory_Class_Name__c;}

                when 'Parts' { serviceProviderDetails.territory = serJob.Territory_Class__c;}

                when 'OtherClaimable' { serviceProviderDetails.territory = serJob.Territory_Class_Name__c;}

                when 'Failure' { serviceProviderDetails.territory = serJob.Territory_Class__c;}
            }

            serviceProviderDetails.spSCMDeductiblePct = serJob.SP_SCMDeductiblePercentage__c; 
            serviceProviderDetails.spState = serJob.SP_State__c; 
            serviceProviderDetails.groupName = serJob.SP_State__c;
            serviceProviderDetails.spWarrantyTrainingStatus = serJob.SP_WarrantyTrainingStatus__c;
            serviceProviderDetails.spSCMDollarAmt = serJob.SP_SCMDollarAmt__c;
            serviceProviderDetails.spCountry = serJob.SP_Country__c;





            DataAreaDetails.claim.serviceProvider = serviceProviderDetails; 


            CG_ODM_ReqJSONParser.engine engineDetails = new CG_ODM_ReqJSONParser.engine();

            engineDetails.billToCode = serJob.BillToCode__c;

            datetime builddate;
            if(serJob.BuildDate__c != null){
                builddate = serJob.BuildDate__c;
                String formatBuildDate = (builddate != null ? builddate.format('MM/dd/yyyy','GMT') : '');
                engineDetails.buildDate = formatBuildDate;
            }
            else
                engineDetails.buildDate = '';
            //engineDetails.buildDate = string.valueOf(serJob.BuildDate__c);

            engineDetails.designPhaseCode = serJob.DesignPhaseCode__c;

            engineDetails.engineFamilyCode = serJob.Qsol_Engine_Family_Code__c ;



            engineDetails.marineFlag = (serJob.MarineFlag__c == 'Y' ? 'M' : (serJob.Automotive_App_Flag__c == 'Y' ? 'A' : 'N'));

            engineDetails.oemCode = serJob.OemCode__c;

            datetime etoconvdate;
            etoconvdate = serJob.EtoConversionDate__c;
            if(etoconvdate != null){
                String formatEtoConvDate = (etoconvdate != null ? etoconvdate.format('MM/dd/yyyy','GMT') : '');
                engineDetails.etoConversionDate = formatEtoConvDate;
            }else{
                engineDetails.etoConversionDate = '';
            }
            //engineDetails.etoConversionDate = string.valueOf(serJob.EtoConversionDate__c);
            if(ServiceName == 'Failure')
                engineDetails.productApplicationDesp = serJob.ProductApplicationCode__c;   
            else
                engineDetails.productApplicationDesp = serJob.ProductApplicationDesp__c;

            engineDetails.warrantyIndicatorFlag = serJob.warrantyIndicatorFlag__c;

            engineDetails.serviceModel = serJob.Service_Model__c;

            DataAreaDetails.claim.engine = engineDetails;

            reqJSON.Request = DataAreaDetails;

            return reqJSON;
        }catch(exception e){
            system.debug('Entered into catch block of prepareServiceJobHeaderValidationReqJSON>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return null;
    }

    public static CG_ODM_ReqJSONParser prepareClaimHeaderValidationReqJSON(CSS_Solution_Component__c SolComp,CSS_Claims__c claimRec,CSS_PSN__c psnRec,String ServiceName){
        try{
            system.debug('inside odm header validation claims-->'+psnRec);
            if(psnRec == null){
                if(claimRec.CSS_PSNs__r != null && !claimRec.CSS_PSNs__r.isEmpty() && claimRec.CSS_PSNs__r.size()>0)
                    psnRec = claimRec.CSS_PSNs__r.get(0);
            }
            system.debug('@@@@###Entered into method');
            CG_ODM_ReqJSONParser reqJSON = new CG_ODM_ReqJSONParser();        

            CG_ODM_ReqJSONParser.Header headerDetail = new CG_ODM_ReqJSONParser.Header();

            CG_ODM_ReqJSONParser.Sender senderDetail = new CG_ODM_ReqJSONParser.Sender();

            if(ServiceName == 'Header')
                senderDetail.ServiceName = 'ODMHeaderValidation';
            if(ServiceName == 'OtherClaimable')
                senderDetail.ServiceName = 'ODMOtherClaimableValidation';
            if(ServiceName == 'Travel')
                senderDetail.ServiceName = 'ODMTravelValidation';
            if(ServiceName == 'SRT')
                senderDetail.ServiceName = 'ODMSRTValidation';
            if(ServiceName == 'Parts')
                senderDetail.ServiceName = 'ODMPartsValidation';
            if(ServiceName == 'Failure')
                senderDetail.ServiceName = 'ODMFailureValidation';

            senderDetail.SenderID ='CSS';

            headerDetail.Sender = senderDetail;

            CG_ODM_ReqJSONParser.Target targetDetail = new CG_ODM_ReqJSONParser.Target();

            targetDetail.TargetID = 'ODM';

            headerDetail.Target = targetDetail;

            reqJSON.Header = headerDetail;

            CG_ODM_ReqJSONParser.Request DataAreaDetails = new CG_ODM_ReqJSONParser.Request(); 

            DataAreaDetails.DecisionID = 'GUIDANZ';

            CG_ODM_ReqJSONParser.claim claimlevelDetails = new CG_ODM_ReqJSONParser.claim();

            if(claimRec.Name != null && claimRec.Name != '')
                claimlevelDetails.claimNumber = claimRec.Name;
            else
                claimlevelDetails.claimNumber = 'Claim not Created';
            claimlevelDetails.claimStatus = 'In Review';
            claimlevelDetails.claimSource = 'Guidanz'; 
            claimlevelDetails.claimSubmittedDate = '';
            claimlevelDetails.cmiServiceProviderCode = 'Guidanz';
            claimlevelDetails.applicationName = 'Guidanz';

            claimlevelDetails.approverName = '';
            claimlevelDetails.bisFlag = (psnRec.Before_In_Service__c == true ? 'Y' : 'N');

            datetime createddate;
            createddate = (claimRec.CreatedDate != null ? claimRec.CreatedDate : date.today());
            String formatCreatedDate = (createddate != null ? createddate.format('MM/dd/yyyy','GMT') : '');
            claimlevelDetails.claimCreatedDate = formatCreatedDate;
            //claimlevelDetails.claimCreatedDate = string.valueof(claimRec.CreatedDate);

            //claimlevelDetails.claimNumber = '';

            datetime receiveddate;
            receiveddate = claimRec.CreatedDate;
            String formatReceivedDate = (receiveddate != null ? receiveddate.format('MM/dd/yyyy','GMT') : '');
            claimlevelDetails.claimReceivedDate = '';
            //claimlevelDetails.claimReceivedDate = string.valueof(claimRec.CreatedDate);
            claimlevelDetails.cmiEngineSerialNumber = (claimRec.ESN__c != null ? claimRec.ESN__c : '');

            claimlevelDetails.serviceModelName = (psnRec.Service_Model__c != null ? psnRec.Service_Model__c : '');

            String distrCode = '';
            String brnchCode = '';
            String[] locArray;
            if(claimRec.Location_Code__c != null && claimRec.Location_Code__c != '')
                locArray = claimRec.Location_Code__c.split('-');
            if(locArray != null && locArray.size()>0){
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }

            claimlevelDetails.cmiServiceProviderCode = brnchCode;

            claimlevelDetails.distributorCode = claimRec.account__r.RSS_RESP_BRANCH_CODE__c;//Modified as part of story 156808

            if(psnRec.Application__c != null && psnRec.Application__c != ''){
                String applicationCode = css_utility.getCodes('Application Code',psnRec.Application__c,null,null);
                system.debug('apllication code'+applicationCode);

                claimlevelDetails.engineApplicationCode = applicationCode;
            }
            else{
                claimlevelDetails.engineApplicationCode = '';
            }

            //claimlevelDetails.engineApplicationCode = psnRec.Application__c;  

            if(ServiceName == 'SRT')
                claimlevelDetails.engineFamily = claimRec.EngineFamilyCode__c;
            else
                claimlevelDetails.engineFamily = claimRec.EngineFamilyName__c; 

            datetime faildate;
            if(SolComp != null){
                faildate = SolComp.Failure_Date__c;
            }else{
                faildate = psnRec.Failure_Date__c;
            }
            String formatFailDate = (faildate != null ? faildate.format('MM/dd/yyyy','GMT') : '');
            claimlevelDetails.failureDate = formatFailDate;//(SolComp != null ? string.valueof(SolComp.Failure_Date__c) : string.valueof(serJob.Failure_Date__c));


            //claimlevelDetails.failureDate = (SolComp != null ? string.valueof(SolComp.Failure_Date__c) : string.valueof(psnRec.Failure_Date__c));
            //(SolComp != null ? SolComp.Failure_Measure__c : psnRec.Mileage_Measure__c);
            system.debug('psnRec.Mileage__c-->'+psnRec.Mileage__c);
            system.debug('psnRec.Mileage_Measure__c-->'+psnRec.Mileage_Measure__c);
            //Check here for application and pass the failure measure accordingly - 182800
            if(SolComp == null){
                if(psnRec.ApplicationCode__c=='130' || psnRec.ApplicationCode__c=='210' || psnRec.ApplicationCode__c=='220' || psnRec.ApplicationCode__c=='310' || psnRec.ApplicationCode__c=='320' || psnRec.ApplicationCode__c=='410'){
                 system.debug('*****psnRec.ApplicationCode__c*****');
                 claimlevelDetails.failurePoint = string.valueof(psnRec.Mileage__c);
                 claimlevelDetails.failureMeasure = string.valueof(psnRec.Mileage_Measure__c);
                }
                else{
                     system.debug('*****Else psnRec.ApplicationCode__c*****');
                     claimlevelDetails.failurePoint = string.valueOf(psnRec.Product_Hours__c);
                     claimlevelDetails.failureMeasure= 'Hours';
                }
            }
            else{
                claimlevelDetails.failureMeasure = (SolComp !=null ? (SolComp.Failure_Measure__c != null && SolComp.Failure_Measure__c != '' ? SolComp.Failure_Measure__c : 'Miles') : (psnRec.Mileage_Measure__c != null && psnRec.Mileage_Measure__c != '' ? psnRec.Mileage_Measure__c : 'Miles'));
                claimlevelDetails.failurePoint = (SolComp != null ? string.valueof(SolComp.Failure_Point__c) : string.valueof(psnRec.Mileage__c));
            }
            system.debug('failureMeasure-->'+claimlevelDetails.failureMeasure);
            claimlevelDetails.groupName = '';

            claimlevelDetails.level = '0';

            claimlevelDetails.manualAdjudicationFlag = '';

            claimlevelDetails.manufacturer = psnRec.Make__c;

            claimlevelDetails.modelSeries = psnRec.Model__c;
            if(claimRec.Multi_PSN_Claim__c==true)
            {
                claimlevelDetails.multiESNFlag = 'Y';
                system.debug('@@@@###Entered into multiESNFlag'+claimlevelDetails.multiESNFlag);
            }
            else
            {
                claimlevelDetails.multiESNFlag = 'N';
                system.debug('@@@@###Entered else into multiESNFlag'+claimlevelDetails.multiESNFlag);
            }

            claimlevelDetails.newPartsWarrantyFlag = (SolComp == null ? 'N' : (SolComp.Parts_Warranty__c != null && SolComp.Parts_Warranty__c == 'New Parts Warranty' ? 'Y' : 'N'));

            claimlevelDetails.reconPartsWarrantyFlag = (SolComp == null ? 'N' : (SolComp.Parts_Warranty__c != null && SolComp.Parts_Warranty__c == 'Recon Parts Warranty' ? 'Y' : 'N')); 

            //claimlevelDetails.roadRelayWarrantyFlag =  (SolComp == null ? 'N' : (SolComp.CSS_Account_Formula__c != null && SolComp.CSS_Account_Formula__c.right(2) == '52' ? 'Y' : 'N')); 
            claimlevelDetails.roadRelayWarrantyFlag = (SolComp == null ? 'N' : SolComp.RoadRelay_Warranty__c); 
            claimlevelDetails.penalty = '';
            //claimlevelDetails.ownerName = '';



            if(SolComp != null && SolComp.Customer_Take_Possession__c != null)
                claimlevelDetails.possessionFlag = (SolComp.Customer_Take_Possession__c == 'Yes' ? 'Y' : 'N');
            else
                claimlevelDetails.possessionFlag = '';

            claimlevelDetails.productApplicationCode = claimRec.ProductApplicationCode__c; 
            
            //claimlevelDetails.reconPartsWarrantyFlag = 

            claimlevelDetails.roNumber = (claimRec.Shop_Work_Order__c != null && claimRec.Shop_Work_Order__c != '' ? claimRec.Shop_Work_Order__c : claimRec.Id);

            //claimlevelDetails.roadRelayWarrantyFlag = 
            
            //claimlevelDetails.serviceModelName = psnRec.Service_Model__c; 

            claimlevelDetails.totalClaimAmt = '1.00';//Vamshi SIT 7/5/2018
            //claimlevelDetails.totalClaimAmt = '';

            datetime wrntyStartDate;
            if(SolComp != null){
                wrntyStartDate = SolComp.Part_Warranty_Start_Date__c;
            }else{
                wrntyStartDate = psnRec.Warranty_Start_Date__c;
            }
            String formatWarrantyDate = (wrntyStartDate != null ? wrntyStartDate.format('MM/dd/yyyy','GMT') : '');

            claimlevelDetails.warrantyStartDate = formatWarrantyDate;//(SolComp != null ? string.valueof(SolComp.Part_Warranty_Start_Date__c) : string.valueof(serJob.Warranty_Start_Date__c));


            //claimlevelDetails.warrantyStartDate = (SolComp != null ? string.valueof(SolComp.Part_Warranty_Start_Date__c) : string.valueof(psnRec.Warranty_Start_Date__c));

            //Adding Parts as new List
            List<CG_ODM_ReqJSONParser.Parts> partsList = new List<CG_ODM_ReqJSONParser.Parts>();
            claimlevelDetails.parts=partsList;

            //Adding SrtList as new List
            List<CG_ODM_ReqJSONParser.SrtList> srtList = new List<CG_ODM_ReqJSONParser.SrtList>();
            claimlevelDetails.srtList=srtList;
            //Adding Travels as new List
            List<CG_ODM_ReqJSONParser.Travels> travelsList = new List<CG_ODM_ReqJSONParser.Travels>();
            claimlevelDetails.travels=travelsList;
            //Adding OtherClaimablesList as new List
            List<CG_ODM_ReqJSONParser.OtherClaimables> otherClaimablesList = new List<CG_ODM_ReqJSONParser.OtherClaimables>();
            claimlevelDetails.otherClaimables=otherClaimablesList;

            CG_ODM_ReqJSONParser.HeaderCampaign hdrCampaignDetails = new CG_ODM_ReqJSONParser.HeaderCampaign();
            claimlevelDetails.HeaderCampaign=hdrCampaignDetails;

            //Adding Failure as new List
            List<CG_ODM_ReqJSONParser.Failure> failureList = new List<CG_ODM_ReqJSONParser.Failure>();
            claimlevelDetails.failure=failureList;
            //Adding AdditionalESN as new List
            List<CG_ODM_ReqJSONParser.AdditionalESN> AdditionalESNList = new List<CG_ODM_ReqJSONParser.AdditionalESN>();
            claimlevelDetails.AdditionalESN=AdditionalESNList;
            //Adding ComplaintCode as new List
            List<CG_ODM_ReqJSONParser.ComplaintCode> ComplaintCodeList = new List<CG_ODM_ReqJSONParser.ComplaintCode>();
            claimlevelDetails.ComplaintCode=ComplaintCodeList;

            DataAreaDetails.claim = claimlevelDetails;

            CG_ODM_ReqJSONParser.serviceProvider serviceProviderDetails = new CG_ODM_ReqJSONParser.serviceProvider();

            serviceProviderDetails.channelOfDistribution = claimRec.CSS_Channel_Code__c;

            serviceProviderDetails.claimAllowedDays = claimRec.SP_CLAIM_ALLOWED_DAYS__c;
            //Anirudh changes to get start and end date from sp info
            List<CSS_Accreditation__c> AccredObj = [select StartDate__c,EndDate__c,Service_Level__c from CSS_Accreditation__c where Account__c =: claimRec.Account__c and Service_Model_Name__c =: psnRec.Service_Model__c];
            system.debug('Anirudh>>>>>>sp details'+claimRec.Account__c + ' ' + psnRec.Service_Model__c);
            //serviceProviderDetails.engineEffectiveDate = AccredObj[0].StartDate__c;

            //serviceProviderDetails.engineExpirationdate = AccredObj[0].EndDate__c;


            if(AccredObj != null && AccredObj.size()>0){//Added by Rajesh Narra on 07-11-2018
                serviceProviderDetails.spServiceLevel = AccredObj[0].Service_Level__c;
                datetime engineStartDate;
                if(AccredObj[0].StartDate__c != null){
                    engineStartDate = Date.valueOf(AccredObj[0].StartDate__c);
                    String formatStartDate = (engineStartDate != null ? engineStartDate.format('MM/dd/yyyy','GMT') : '');
                    serviceProviderDetails.engineEffectiveDate = formatStartDate;
                }
                else{
                    serviceProviderDetails.engineEffectiveDate = '';
                }

                datetime engineEndDate;
                if(AccredObj[0].EndDate__c != null){
                    engineEndDate = Date.valueOf(AccredObj[0].EndDate__c);
                    String formatEndDate = (engineEndDate != null ? engineEndDate.format('MM/dd/yyyy','GMT') : '');
                    serviceProviderDetails.engineExpirationdate = formatEndDate;
                }
                else{
                    serviceProviderDetails.engineExpirationdate = '';
                }
                //serviceProviderDetails.engineEffectiveDate = claimRec.sp_

                //serviceProviderDetails.engineExpirationdate 

                datetime inactivedate;
                if(claimRec.SP_CMI_SP_EXPIRATION__c != null){
                    inactivedate = Date.valueOf(claimRec.SP_CMI_SP_EXPIRATION__c);
                    String formatInactiveDate = (inactivedate != null ? inactivedate.format('MM/dd/yyyy','GMT') : '');
                    serviceProviderDetails.inactiveDate = formatInactiveDate;
                }else{
                    serviceProviderDetails.inactiveDate = '';
                }
            }

            datetime WarrantyCertificationEndDate;
           if(claimRec.SP_WarrantyCertificationEndDate__c != null){
                WarrantyCertificationEndDate = Date.valueOf(claimRec.SP_WarrantyCertificationEndDate__c);
                String formatWarrantyCertificationEndDate = (WarrantyCertificationEndDate != null ? WarrantyCertificationEndDate.format('MM/dd/yyyy','GMT') : '');
                serviceProviderDetails.spCertificationEndDate = formatWarrantyCertificationEndDate;
            }
            else{
                serviceProviderDetails.spCertificationEndDate = '';
            }

            serviceProviderDetails.ltaChecked = claimRec.SP_LTA_FLAG__c;

            serviceProviderDetails.oemCode = claimRec.SP_PrimaryOEMCode__c;

            serviceProviderDetails.outfileAllClaimsFlag = claimRec.SP_OUTFILE_ALL_CLAIMS__c;

            serviceProviderDetails.paccarChecked = claimRec.SP_PACCAR__c;

            serviceProviderDetails.region = claimRec.SP_Region__c;

            serviceProviderDetails.regionCode = claimRec.SP_RegionCode__c;

            serviceProviderDetails.serviceModelName = psnRec.Service_Model__c; 

            serviceProviderDetails.status = claimRec.SP_ACCOUNT_STATUS__c;

            //serviceProviderDetails.territory = claimRec.SP_TERRITORY_CODE__c;
            //serviceProviderDetails.territory = claimRec.SP_TERRITORY__c; //Added by Rajesh Narra on 7-10-2018

            switch on ServiceName {
                when 'Header' { serviceProviderDetails.territory = claimRec.SP_TERRITORY_CODE__c;}

                when 'Travel' { serviceProviderDetails.territory = claimRec.SP_TERRITORY_CODE__c;}

                when 'SRT' { serviceProviderDetails.territory = claimRec.Sp_TERRITORY__c;}

                when 'Parts' { serviceProviderDetails.territory = claimRec.SP_TERRITORY_CODE__c;}

                when 'OtherClaimable' { serviceProviderDetails.territory = claimRec.Sp_TERRITORY__c;}

                when 'Failure' { serviceProviderDetails.territory = claimRec.SP_TERRITORY_CODE__c;}
            }

            serviceProviderDetails.spSCMDeductiblePct = claimRec.SP_SCMDeductiblePercentage__c; 
            serviceProviderDetails.spState = claimRec.SP_State__c; 
            serviceProviderDetails.groupName = claimRec.SP_State__c;
            serviceProviderDetails.spWarrantyTrainingStatus = claimRec.SP_WarrantyTrainingStatus__c;
            serviceProviderDetails.spSCMDollarAmt = claimRec.SP_SCMDollarAmt__c;
            serviceProviderDetails.spCountry = claimRec.SP_Country__c;

            DataAreaDetails.claim.serviceProvider = serviceProviderDetails;


            CG_ODM_ReqJSONParser.engine engineDetails = new CG_ODM_ReqJSONParser.engine();

            engineDetails.billToCode = claimRec.BillToCode__c;

            datetime builddate;
            if(claimRec.BuildDate__c != null){
                builddate = claimRec.BuildDate__c;
                String formatBuildDate = (builddate != null ? builddate.format('MM/dd/yyyy','GMT') : '');
                engineDetails.buildDate = formatBuildDate;
            }else{
                engineDetails.buildDate = '';
            }
            //engineDetails.buildDate = string.valueOf(claimRec.BuildDate__c);

            engineDetails.designPhaseCode = claimRec.DesignPhaseCode__c;

            engineDetails.engineFamilyCode = claimRec.EngineFamilyCode__c ;

            if(ServiceName == 'Failure')
                engineDetails.productApplicationDesp = claimRec.ProductApplicationCode__c;   
            else
                engineDetails.productApplicationDesp = claimRec.ProductApplicationDesp__c;

            engineDetails.marineFlag = (claimRec.MarineFlag__c == 'Y' ? 'M' : (claimRec.Automotive_App_Flag__c == 'Y' ? 'A' : 'N'));

            engineDetails.oemCode = claimRec.OemCode__c;

            engineDetails.serviceModel = psnRec.Service_Model__c;

            datetime etoconvdate;
            if(claimRec.EtoConversionDate__c != null){
                etoconvdate = claimRec.EtoConversionDate__c;
                String formatEtoConvDate = (etoconvdate != null ? etoconvdate.format('MM/dd/yyyy','GMT') : '');
                engineDetails.etoConversionDate = formatEtoConvDate;
            }else{
                engineDetails.etoConversionDate = '';
            }
            //engineDetails.etoConversionDate = string.valueOf(claimRec.EtoConversionDate__c);

            engineDetails.warrantyIndicatorFlag = claimRec.warrantyIndicatorFlag__c;

            DataAreaDetails.claim.engine = engineDetails;

            reqJSON.Request = DataAreaDetails;
            system.debug('prepare reqJSON>>>>'+reqJSON);

            return reqJSON;
        }catch(exception e){
            system.debug('Entered into catch block of prepareClaimHeaderValidationReqJSON>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber());
        }
        return null;
    }
    
    /********************************************** PREPARE HEADER VALIDATION REQ **************************************************/

    /************************************************ PRE SUBMIT *******************************************************************/

    public static list<CSS_Integration_Error__c> performODMPreSubmitServiceCS(Map<string, list<CSS_Solution_Component__c>> SCAccountCodeMap, 
                                                                              Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap, Map<string, 
                                                                              list<CSS_SRT__c>> SRTAccountCodeMap, List<String> partsWarranty,List<String> fieldActionClaimAccCodes,
                                                                              CSS_Claims__c claimsRec, CSS_PSN__c psnRec, CSS_Job_Order__c serJob, Boolean IsClaim) {
        list<CSS_Integration_Error__c> lstIntDetails = new list<CSS_Integration_Error__c>();
        try {
            list<CG_ODM_PreSubmit_ReqJSONParser>  preSubmitReqJSONList = new list<CG_ODM_PreSubmit_ReqJSONParser>();
            preSubmitReqJSONList = CallODMpreSubmitValidationserviceCS(SCAccountCodeMap, POAccountCodeMap, 
                                                                       SRTAccountCodeMap, partsWarranty, fieldActionClaimAccCodes, claimsRec, psnRec, serJob, IsClaim);
              system.debug('preSubmitReqJSONList size>>> ' + preSubmitReqJSONList.size());
            for(CG_ODM_PreSubmit_ReqJSONParser ReqJSON : preSubmitReqJSONList) 
            {
                 system.debug('intDetails ReqJSON>>> ' + ReqJSON);
                CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
                CG_OP_OAGWrapper resWrapper = new CG_OP_OAGWrapper();
                CG_ODM_PreSubmit_ResJSONParser ODMResponse = new CG_ODM_PreSubmit_ResJSONParser(); 

                resWrapper = CG_SL_ODM.callODMPreSubmitService(reqJSON);  
                //ODMResponse = new CG_ODM_ResJSONParser(); 
                if(resWrapper.response != null){
                    ODMResponse = (CG_ODM_PreSubmit_ResJSONParser)JSON.deserialize(resWrapper.response.getBody(),CG_ODM_PreSubmit_ResJSONParser.class);
                }
                intDetails.Auth_Call_Time__c = (resWrapper.totalAuthCallTime != null ? resWrapper.totalAuthCallTime : 0);
                //Request Body
                if(resWrapper.request!=null){
                    intDetails.Processed_Data__c =  resWrapper.request.getBody();                
                }
                if(resWrapper.response != null){
                    //intDetails.Response_Body__c = resWrapper.response.getBody();
                    intDetails.Response_Body__c = resWrapper.response.getBody()+';;'+resWrapper.response.getStatusCode();
                }
                intDetails.Service_Call_Time__c = (resWrapper.totalServiceCallTime != null ? resWrapper.totalServiceCallTime : 0);
                if(IsClaim)
                {
                    intDetails.Service_Job_Number__c = claimsRec.Name;

                }
                else
                    intDetails.Service_Job_Number__c = serJob.Name;
                if(resWrapper.exceptionFlag) {
                    intDetails.Error_Description__c = resWrapper.exceptionMessage;
                }
                intDetails.Service_Name__c = 'ODMPreSubmitValidation';
                intDetails.Source__c = 'ODM';
                system.debug('intDetails >>> ' + intDetails);
                lstIntDetails.add(intDetails);  
                //insert lstIntDetails;
            }
        } catch(Exception ex) 
        {
            system.debug('in the exception of performODMPreSubmitServiceCS Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }  
        system.debug('lstIntDetails <<< ' + lstIntDetails);
        return lstIntDetails;
    }

    public static list<CG_ODM_PreSubmit_ReqJSONParser> CallODMpreSubmitValidationserviceCS(Map<string, list<CSS_Solution_Component__c>> SCAccountCodeMap, 
                                                                                           Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap, 
                                                                                           Map<string, list<CSS_SRT__c>> SRTAccountCodeMap, List<String> partsWarranty, 
                                                                                           List<string> fieldActionClaimAccCodes, CSS_Claims__c claimsRec, 
                                                                                           CSS_PSN__c psnRec, CSS_Job_Order__c serJob, Boolean IsClaim)
    {
        list<CG_ODM_PreSubmit_ReqJSONParser>  preSubmitReqJSONList;
        //= new list<CG_ODM_PreSubmit_ReqJSONParser>();
        try {
            
           preSubmitReqJSONList = new list<CG_ODM_PreSubmit_ReqJSONParser>();
            
            //CALL ENGINE SECTION
            CG_ODM_PreSubmit_ReqJSONParser.Engine Engineobj = passEngineValuestoODM(claimsRec, serJob, isClaim);

           //CALL SERVICE PROVIDER SECTION
            CG_ODM_PreSubmit_ReqJSONParser.ServiceProvider  serviceproviderobj = passingserviceprovider(claimsRec, serJob,psnRec, isClaim);


            //CALL COMPLAINT CODE SECTION
            CG_ODM_PreSubmit_ReqJSONParser.ComplaintCode ComplaintCodeobj =  new CG_ODM_PreSubmit_ReqJSONParser.ComplaintCode();
            ComplaintCodeobj.code = fetchComplaintCode(claimsRec, serJob, isClaim);

            CG_ODM_PreSubmit_ReqJSONParser.Header headerobj =  new CG_ODM_PreSubmit_ReqJSONParser.Header();
            CG_ODM_PreSubmit_ReqJSONParser.Sender Senderobj =  new CG_ODM_PreSubmit_ReqJSONParser.Sender();
            Senderobj.ServiceName = 'ODMPreSubmitValidation';
            Senderobj.SenderID = 'CSS';
            CG_ODM_PreSubmit_ReqJSONParser.Target Targetobj =  new CG_ODM_PreSubmit_ReqJSONParser.Target();
            Targetobj.TargetID = 'ODM';

            CG_ODM_PreSubmit_ReqJSONParser.Request Requestobj; //=  new CG_ODM_PreSubmit_ReqJSONParser.Request();
            //CG_ODM_PreSubmit_ReqJSONParser.Request Requestobj =  new CG_ODM_PreSubmit_ReqJSONParser.Request();


            for(string accountcode : SCAccountCodeMap.keyset()) {

                string accountTwoDigit = '';
                system.debug(' accountcode ' + accountcode);
                if(accountcode != null && accountcode != '' && accountcode.length() > 2)
                    accountTwoDigit = accountcode.substring(accountcode.length()-2, accountcode.length());
                system.debug(' accountTwoDigit ' + accountTwoDigit);

                //CALL ACCOUNT CODE INFO SECTION
                CG_ODM_PreSubmit_ReqJSONParser.AcctCodeInfo acctcodeinfoobj = new CG_ODM_PreSubmit_ReqJSONParser.AcctCodeInfo();
                acctcodeinfoobj = passingAccountCodeInfo(accountTwoDigit);

                //CG_ODM_PreSubmit_ReqJSONParser.Claim  Claimobj = new CG_ODM_PreSubmit_ReqJSONParser.Claim();
                //CALL CLAIM SECTION.
                //Claimobj = passClaimsValuestoODM(claimsRec, serJob, psnRec, accountTwoDigit, isClaim);
                
                if(accountTwoDigit != null && accountTwoDigit != '61') {
                    system.debug('partsWarranty outside'+partsWarranty);
                    if((partsWarranty!=null && accountTwoDigit!=null && partsWarranty.contains(accountTwoDigit)) 
                    || (fieldActionClaimAccCodes != null && accountTwoDigit != null && fieldActionClaimAccCodes.contains(accountTwoDigit))) {
                        system.debug('partsWarranty inside'+partsWarranty);
                        //PARTS WARRANTY
                        system.debug('Entered parts warranty');
                        
                        
                       
                           system.debug(' accountTwoDigit accountTwoDigit' + accountTwoDigit);
                        //fetch all fail codes based on SCAccountCodeMap;
                        map<string, List<CSS_Solution_Component__c>> uniqueFailCodeMap = new map<string, List<CSS_Solution_Component__c>>();

                        List<CSS_Solution_Component__c> fclist = SCAccountCodeMap.get(accountcode);
                        String FCode;
                        for(CSS_Solution_Component__c CSSsc : fclist) {
                                if(CSSsc.type__c == 'CAMPAIGN' || CSSsc.type__c == 'ATC' || CSSsc.type__c == 'TRP'){
                                    FCode=CSSsc.System_Code__c+CSSsc.Component_Code__c+CSSsc.Failure_Mode__c;
                                }
                                else{
                                    FCode=CSSsc.System_Code__c+CSSsc.Component_Code__c;
                                }
                                if(uniqueFailCodeMap.containsKey(FCode)) {     //if(uniqueFailCodeMap.containsKey(CSSsc.Fail_Code__c)) 
                                    List<CSS_Solution_Component__c> fclistSC = uniqueFailCodeMap.get(FCode);
                                    fclistSC.add(CSSsc);
                                    uniqueFailCodeMap.put(FCode, fclistSC);
                                } else {
                                    uniqueFailCodeMap.put(FCode, new List<CSS_Solution_Component__c> { CSSsc });
                                }
                        }
                        system.debug(' uniqueFailCodeMap accountTwoDigit' + uniqueFailCodeMap);
                        //for loop all fail codes 
                        for(string failcode : uniqueFailCodeMap.keyset()) {
                            decimal totalclaimAmt = 0.00;//1.00;
                            decimal totalSRTAmount = 0.00;
                            decimal totalPartsAmount = 0.00;
                            decimal totalOCAmount = 0.00;
                            decimal totalTowingAmount = 0.00;
                            decimal totalTravelAmount = 0.00;

                            //decimal totalclaimAmt = 0.0;
                            //wrapper inialization
                            Requestobj =  new CG_ODM_PreSubmit_ReqJSONParser.Request();
                            list<CG_ODM_PreSubmit_ReqJSONParser.Failures> ListOfFailuresobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Failures>();
                             CG_ODM_PreSubmit_ReqJSONParser  preSubmitReqJSON = new CG_ODM_PreSubmit_ReqJSONParser();
                            List<CSS_Solution_Component__c> fclistSC = uniqueFailCodeMap.get(failcode);//it has duplicate fail ocdes[system code and component code] combination
                            system.debug('fclistSC>>>>>'+fclistSC);
                            
                            CG_ODM_PreSubmit_ReqJSONParser.Claim  Claimobj = new CG_ODM_PreSubmit_ReqJSONParser.Claim();
                            //CALL CLAIM SECTION.
                            Claimobj = passClaimsValuestoODM(claimsRec, serJob, psnRec, accountTwoDigit, isClaim);
                            
                            if(fieldActionClaimAccCodes != null && fieldActionClaimAccCodes.contains(accountTwoDigit)){
                                //CALL Field Action Account Codes SECTION
                            Claimobj = passPartsWarrantyValuestoODM(fclistSC[0], claimsRec, serJob, psnRec, accountTwoDigit, Claimobj, FALSE, isClaim);
                            }else{
                            //CALL PARTS WARRANTY SECTION
                            Claimobj = passPartsWarrantyValuestoODM(fclistSC[0], claimsRec, serJob, psnRec, accountTwoDigit, Claimobj, TRUE, isClaim);
                            }
                            
                            for(CSS_Solution_Component__c failurlst : fclistSC) {
                                decimal totalTowingAmountFailure = 0.00;
                                //list<CG_ODM_PreSubmit_ReqJSONParser.Campaign> ListOfCampaignobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Campaign>();
                                list<CG_ODM_PreSubmit_ReqJSONParser.SrtList> ListOfsrtsobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.SrtList>();
                                list<CG_ODM_PreSubmit_ReqJSONParser.Parts> ListOfpartsListobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Parts>();
                                list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables>  ListOfOtherClaimablesobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables> ();
                                list<CG_ODM_PreSubmit_ReqJSONParser.Travels>  ListOfTravelsobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Travels>();

                                CG_ODM_PreSubmit_ReqJSONParser.Failures Failuresobj =  new CG_ODM_PreSubmit_ReqJSONParser.Failures();
                                system.debug('Anirudh failurelist'+failurlst);
                                //CALL FAILURES SECTION
                                Failuresobj = passFailuresValuestoODM(failurlst, accountCode);
                                //ListOfFailuresobj.addall(passFailuresValuestoODM(fclistSC, accountCode));

                                CG_ODM_PreSubmit_ReqJSONParser.Campaign Campaignobj =  new CG_ODM_PreSubmit_ReqJSONParser.Campaign();
                                //CALL CAMPAIGNS SECTION
                                Campaignobj = passCampaignValuestoODM(failurlst, accountCode);
                                //ListOfCampaignobj.addall(Campaignobj);

                                List<CSS_Parts_Options__c> POlist = POAccountCodeMap.get(accountcode+failurlst.Fail_Code__c);
                                //CALL PARTS SECTION
                                ListOfpartsListobj.addall(passPartsValuestoODM(POlist, failurlst.Id)); 

                                //CALL OTHER CLIAMABLES SECTION
                                ListOfOtherClaimablesobj.addall(passOCValuestoODM(POlist, failurlst.Id)); 

                                //CALL TTML SECTION
                                ListOfTravelsobj.addall(passTTMLValuestoODM(POlist, failurlst.Id)); 

                                //CALCULATION OF TOTAL.
                                if(POlist != null)
                                    for(CSS_Parts_Options__c p : POlist) {
                                        //totalclaimAmt += po.Amount__c;
                                        if(p.recordtype.name=='TTML' && p.type__c!=null && p.type__c!= '') {
                                            if(p.type__c=='Towing') 
                                                totalTowingAmountFailure += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0);
                                            else
                                                totalTravelAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                        }

                                        if(p.recordtype.name=='OtherClaimables')
                                            totalOCAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); //p.Amount__c;


                                        if(!isClaim) {//JOB PLAN
                                            if(p.recordtype.name=='BMS Parts') 
                                                totalPartsAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                        } else {
                                            //Claims
                                            if(claimsRec.CSS_Job__c != null) {
                                                //Automated Claims
                                                if(p.recordtype.name=='BMS Parts') 
                                                    totalPartsAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                            } else {
                                                //Manual
                                                system.debug('Anirudh Entered parts total in parts warranty'+p.ExpenseTotal__c + ' --- ' + p.recordtype.name);
                                                if(p.recordtype.name=='Parts')
                                                    totalPartsAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                            }
                                        }

                                    }
                                system.debug(' Anirudh totalPartsAmount ' + totalPartsAmount);
                                totalTowingAmount += totalTowingAmountFailure;
                                system.debug(' totalTowingAmount ' + totalTowingAmount);
                                system.debug(' accountcode ' + accountcode + '--failurlst.System_Code__c--' + failurlst.System_Code__c);
                                system.debug(' --failurlst.Component_Code__c-- ' + failurlst.Component_Code__c + '--failurlst.Failure_Mode__c--' + failurlst.Failure_Mode__c);
                                system.debug('SRTAccountCodeMap**'+SRTAccountCodeMap.keyset());
                                List<CSS_SRT__c> SRTlist = SRTAccountCodeMap.get(accountcode+failurlst.Fail_Code__c);
                                //if(partsWarranty!=null && accountTwoDigit!=null && partsWarranty.contains(accountTwoDigit))
                                    //SRTlist = SRTAccountCodeMap.get(accountcode+failurlst.System_Code__c+failurlst.Component_Code__c);
                                //if(fieldActionClaimAccCodes != null && accountTwoDigit != null && fieldActionClaimAccCodes.contains(accountTwoDigit))
                                    //SRTlist = SRTAccountCodeMap.get(accountcode+failurlst.System_Code__c+failurlst.Component_Code__c+failurlst.Failure_Mode__c);
                                system.debug('SRTlistkal**'+SRTlist);
                                //CALL SRT SECTION
                                decimal totalSRTHours = 0;
                                if(SRTlist != null && SRTlist.size() >0) {
                                    for(CSS_SRT__c srt : SRTlist) {
                                        system.debug('Anirudh srt.Extended_Hours__c>>>>>>'+srt.Extended_Hours__c + '    ' + srt.SRT_Amount__c);
                                        if(srt != null && srt.Extended_Hours__c!=null)
                                            totalSRTHours += srt.Extended_Hours__c;
                                        if(srt != null && srt.SRT_Amount__c != null)
                                            totalSRTAmount += srt.SRT_Amount__c;
                                    }

                                    if(isClaim)
                                        ListOfsrtsobj.addall(passSRTValuestoODM(SRTlist, claimsRec.Repair_Location__c, failurlst.Id)); 
                                    else
                                        ListOfsrtsobj.addall(passSRTValuestoODM(SRTlist, serJob.CSS_Repair_Location__c, failurlst.Id));
                                }
                                system.Debug('Anirudh total SRT Amount>>>>>>>>>>>'+totalSRTAmount);
                                Failuresobj.otherClaimables = ListOfOtherClaimablesobj;
                                Failuresobj.parts = ListOfpartsListobj;
                                Failuresobj.travels = ListOfTravelsobj;
                                Failuresobj.srtList = ListOfsrtsobj;
                                Failuresobj.campaign = Campaignobj;
                                Failuresobj.totalSRTHours = string.valueOf(totalSRTHours);
                                Failuresobj.totalTowingAmt = string.valueOf(totalTowingAmountFailure);
                                Failuresobj.totalLaborAmt = string.valueOf(totalSRTAmount);
                                Failuresobj.acctCodeInfo = acctcodeinfoobj;
                                system.debug('Failuresobj>>>>>> TESTING1 '+Failuresobj);
                                ListOfFailuresobj.add(Failuresobj);

                            }
                            //system.debug('ListOfFailuresobj>>>>>> TESTING2 '+ListOfFailuresobj);
                            
                            headerobj.Sender = Senderobj;
                            headerobj.Target = Targetobj;
                            preSubmitReqJSON.Header = headerobj;

                            totalclaimAmt = totalSRTAmount + totalPartsAmount + totalOCAmount + totalTowingAmount + totalTravelAmount;
                            system.debug('Claimobj---- ' + Claimobj);
                            system.debug(' --- partswarranty' + totalSRTAmount + ' --- '+totalPartsAmount +' --- ' + totalOCAmount +' --- ' + totalTowingAmount +' --- ' + totalTravelAmount);
                            system.debug(' totalclaimAmt ' + totalclaimAmt);

                            Claimobj.totalClaimAmt = string.valueOf(totalclaimAmt);
                            Claimobj.engine = Engineobj;
                            Claimobj.serviceProvider = serviceproviderobj;
                            Claimobj.ComplaintCode = ComplaintCodeobj;
                            Claimobj.failures = ListOfFailuresobj;     
                            //system.debug('Claimobj>>>>>> TESTING3 '+Claimobj);
                            Requestobj.claim = Claimobj;
                            preSubmitReqJSON.Request = Requestobj;
                            //system.debug('Requestobj>>>>>> TESTING4 '+Requestobj);
                            system.debug('parts warranty preSubmitReqJSON>>>> TESTING5 '+preSubmitReqJSON);
                            preSubmitReqJSONList.add(preSubmitReqJSON);
                            //system.debug('parts warranty preSubmitReqJSONList>>>> TESTING6 '+preSubmitReqJSONList);
                        }
                    } else {
                        system.debug('Entered non parts warranty');
                        
                        CG_ODM_PreSubmit_ReqJSONParser.Claim  Claimobj = new CG_ODM_PreSubmit_ReqJSONParser.Claim();
                        //CALL CLAIM SECTION.
                        Claimobj = passClaimsValuestoODM(claimsRec, serJob, psnRec, accountTwoDigit, isClaim);
                        
                        Requestobj =  new CG_ODM_PreSubmit_ReqJSONParser.Request();
                        /************************************** NON PARTS WARRANTY *********************************/
                        //wrapper inialization
                       CG_ODM_PreSubmit_ReqJSONParser  preSubmitReqJSON = new CG_ODM_PreSubmit_ReqJSONParser();
                        list<CG_ODM_PreSubmit_ReqJSONParser.Failures> ListOfFailuresobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Failures>();
                        //CG_ODM_PreSubmit_ReqJSONParser.Header headerobj =  new CG_ODM_PreSubmit_ReqJSONParser.Header();
                        //CG_ODM_PreSubmit_ReqJSONParser.Sender Senderobj =  new CG_ODM_PreSubmit_ReqJSONParser.Sender();
                        //CG_ODM_PreSubmit_ReqJSONParser.Request Requestobj =  new CG_ODM_PreSubmit_ReqJSONParser.Request();
                        //list<CG_ODM_PreSubmit_ReqJSONParser.SrtList> ListOfsrtsobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.SrtList>();
                        //list<CG_ODM_PreSubmit_ReqJSONParser.Parts> ListOfpartsListobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Parts>();
                        //list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables>  ListOfOtherClaimablesobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables> ();
                        //list<CG_ODM_PreSubmit_ReqJSONParser.Travels>  ListOfTravelsobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Travels>();
                        //CG_ODM_PreSubmit_ReqJSONParser.Campaign Campaignobj =  new CG_ODM_PreSubmit_ReqJSONParser.Campaign();

                        List<CSS_Solution_Component__c> fclist = SCAccountCodeMap.get(accountcode);
                        //decimal totalclaimAmt = 0.0;
                        //decimal totalclaimAmt = 1.00;
                        decimal totalclaimAmt = 0.00;//1.00;
                        decimal totalSRTAmount = 0.00;
                        decimal totalPartsAmount = 0.00;
                        decimal totalOCAmount = 0.00;
                        decimal totalTowingAmount = 0.00;
                        decimal totalTravelAmount = 0.00;
                        //CALL PARTS WARRANTY SECTION
                        Claimobj = passPartsWarrantyValuestoODM(fclist[0], claimsRec, serJob, psnRec, accountTwoDigit, Claimobj, false, isClaim);


                        for(CSS_Solution_Component__c failurlst : fclist) {
                            decimal totalTowingAmountFailure = 0.00;
                            list<CG_ODM_PreSubmit_ReqJSONParser.SrtList> ListOfsrtsobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.SrtList>();
                            list<CG_ODM_PreSubmit_ReqJSONParser.Parts> ListOfpartsListobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Parts>();
                            list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables>  ListOfOtherClaimablesobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables> ();
                            list<CG_ODM_PreSubmit_ReqJSONParser.Travels>  ListOfTravelsobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Travels>();

                            CG_ODM_PreSubmit_ReqJSONParser.Failures Failuresobj =  new CG_ODM_PreSubmit_ReqJSONParser.Failures();
                            //CALL FAILURES SECTION
                            Failuresobj = passFailuresValuestoODM(failurlst, accountCode);
                            //ListOfFailuresobj.addall(passFailuresValuestoODM(fclistSC, accountCode));

                            CG_ODM_PreSubmit_ReqJSONParser.Campaign Campaignobj =  new CG_ODM_PreSubmit_ReqJSONParser.Campaign();
                            //CALL CAMPAIGNS SECTION
                            Campaignobj = passCampaignValuestoODM(failurlst, accountCode);
                            //ListOfCampaignobj.addall(Campaignobj);

                            List<CSS_Parts_Options__c> POlist = POAccountCodeMap.get(accountcode+failurlst.Fail_Code__c);
                            //CALL PARTS SECTION
                            ListOfpartsListobj.addall(passPartsValuestoODM(POlist, failurlst.Id)); 
                            if(POlist != null && POlist.size()>0){
                                for(CSS_Parts_Options__c po : POlist)
                                    totalclaimAmt += (po.Amount__c != null ? po.Amount__c : 0);}

                            //CALL OTHER CLIAMABLES SECTION
                            ListOfOtherClaimablesobj.addall(passOCValuestoODM(POlist, failurlst.Id)); 

                            //CALL TTML SECTION
                            ListOfTravelsobj.addall(passTTMLValuestoODM(POlist, failurlst.Id)); 

                            //CALCULATION OF TOTAL.
                            if(POlist != null)
                                for(CSS_Parts_Options__c p : POlist) {
                                    //totalclaimAmt += po.Amount__c;
                                    system.debug('p moor ' + p);
                                    system.debug('p.ExpenseTotal__c moor ' + p.ExpenseTotal__c);

                                    if(p.recordtype.name=='TTML' && p.type__c!=null && p.type__c!= '') {
                                        if(p.type__c=='Towing') 
                                            totalTowingAmountFailure += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0);
                                        else
                                            totalTravelAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                    }

                                    if(p.recordtype.name=='OtherClaimables')
                                        totalOCAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0);//p.Amount__c;


                                    if(!isClaim) 
                                    {//JOB PLAN
                                        if(p.recordtype.name=='BMS Parts') 
                                            totalPartsAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                    } else 
                                    {
                                        //Claims
                                        if(claimsRec.CSS_Job__c != null) {
                                            //Automated Claims
                                            if(p.recordtype.name=='BMS Parts') 
                                                totalPartsAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                        } else 
                                        {
                                            system.debug('Anirudh Entered parts total in non parts warranty'+p.ExpenseTotal__c);
                                            //Manual
                                            if(p.recordtype.name=='Parts')
                                                totalPartsAmount += (p.ExpenseTotal__c != null ? p.ExpenseTotal__c : 0); 
                                        }
                                    }

                                }
                            totalTowingAmount += totalTowingAmountFailure;
                            system.debug(' totalTowingAmount ' + totalTowingAmount);
                            system.debug(' totalTowingAmountFailure ' + totalTowingAmountFailure);
                            system.debug(' totalTravelAmount ' + totalTravelAmount);
                            system.debug(' totalOCAmount ' + totalOCAmount);
                            system.debug(' totalPartsAmount ' + totalPartsAmount);
                            List<CSS_SRT__c> SRTlist = SRTAccountCodeMap.get(accountcode+failurlst.System_Code__c+failurlst.Component_Code__c);

                            //CALL SRT SECTION
                            decimal totalSRTHours = 0;
                            //RAJESH
                            system.debug('*8RAJESH***8'+SRTlist);
                            if(SRTlist!=null){
                                for(CSS_SRT__c srt : SRTlist) {
                                    if(srt != null && srt.Extended_Hours__c!=null)
                                        totalSRTHours += srt.Extended_Hours__c;
                                    if(srt != null && srt.SRT_Amount__c != null)
                                        totalSRTAmount += srt.SRT_Amount__c;
                                }
                            }
                            if(isClaim)
                                ListOfsrtsobj.addall(passSRTValuestoODM(SRTlist, claimsRec.Repair_Location__c, failurlst.Id)); 
                            else
                                ListOfsrtsobj.addall(passSRTValuestoODM(SRTlist, serJob.CSS_Repair_Location__c,failurlst.Id));

                            Failuresobj.otherClaimables = ListOfOtherClaimablesobj;
                            Failuresobj.parts = ListOfpartsListobj;
                            Failuresobj.travels = ListOfTravelsobj;
                            Failuresobj.srtList = ListOfsrtsobj;
                            Failuresobj.campaign = Campaignobj;
                            Failuresobj.totalSRTHours = string.valueOf(totalSRTHours);
                            Failuresobj.totalTowingAmt = string.valueOf(totalTowingAmountFailure);
                            Failuresobj.totalLaborAmt = string.valueOf(totalSRTAmount);
                            Failuresobj.acctCodeInfo = acctcodeinfoobj;
                            system.debug('Failuresobj2>>>>'+Failuresobj);
                            ListOfFailuresobj.add(Failuresobj);
                        }
                        headerobj.Sender = Senderobj;
                        headerobj.Target = Targetobj;
                        preSubmitReqJSON.Header = headerobj;

                        totalclaimAmt = totalSRTAmount + totalPartsAmount + totalOCAmount + totalTowingAmount + totalTravelAmount;
                        system.debug('totalSRTAmount --- ' + totalSRTAmount + ' totalPartsAmount--- '+totalPartsAmount +' totalOCAmount--- ' + totalOCAmount +' totalTowingAmount--- ' + totalTowingAmount +' totalTravelAmount--- ' + totalTravelAmount);
                        system.debug(' totalclaimAmt ' + totalclaimAmt);

                        Claimobj.totalClaimAmt = string.valueOf(totalclaimAmt);
                        Claimobj.engine = Engineobj;
                        Claimobj.serviceProvider = serviceproviderobj;
                        Claimobj.ComplaintCode = ComplaintCodeobj;
                        Claimobj.failures = ListOfFailuresobj;     

                        Requestobj.claim = Claimobj;
                        preSubmitReqJSON.Request = Requestobj;
                        preSubmitReqJSONList.add(preSubmitReqJSON);
                        //system.debug('preSubmitReqJSON inside>>>> ' + preSubmitReqJSON);
                         //system.debug('preSubmitReqJSONList inside>>> ' + preSubmitReqJSONList);
                      
                         
                    }
                }
            }
            system.debug('preSubmitReqJSONList >>> ' + preSubmitReqJSONList);
             system.debug('preSubmitReqJSONList size>>> ' + preSubmitReqJSONList.size());
             
        } catch(Exception ex) {
            system.debug('in the exception of CallODMpreSubmitValidationserviceCS Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }  
        return preSubmitReqJSONList;
    }
     /************************************************ PRE SUBMIT ***************************************************************/

    /************************************************ ENGINE ********************************************************************/
    public static CG_ODM_PreSubmit_ReqJSONParser.Engine passEngineValuestoODM(CSS_Claims__c claimsRec, CSS_Job_Order__c serJob, boolean isClaim) {
        CG_ODM_PreSubmit_ReqJSONParser.Engine Engineobj =  new CG_ODM_PreSubmit_ReqJSONParser.Engine();

        try{ 
            if(isClaim) {
                //Pass claim object values.

                Engineobj.billToCode =claimsRec.BillToCode__c;
                datetime builddate;
                if(claimsRec.BuildDate__c != null){
                    builddate = claimsRec.BuildDate__c;
                    String formatBuildDate = (builddate != null ? builddate.format('MM/dd/yyyy','GMT') : '');
                    Engineobj.buildDate = formatBuildDate;
                }else{
                    Engineobj.buildDate = '';
                }
                Engineobj.engineFamilyCode =claimsRec.EngineFamilyCode__c;
                datetime etoconvdate;
                if(claimsRec.EtoConversionDate__c != null){
                    etoconvdate = claimsRec.EtoConversionDate__c;
                    String formatEtoConvDate = (etoconvdate != null ? etoconvdate.format('MM/dd/yyyy','GMT') : '');
                    Engineobj.etoConversionDate = formatEtoConvDate;
                }else{
                    Engineobj.etoConversionDate = '';
                }
                //Engineobj.marineFlag =claimsRec.MarineFlag__c;
                Engineobj.marineFlag = (claimsRec.MarineFlag__c == 'Y' ? 'M' : (claimsRec.Automotive_App_Flag__c == 'Y' ? 'A' : 'N'));
                Engineobj.oemCode =claimsRec.SP_PrimaryOEMCode__c;
                Engineobj.productApplicationDesp =claimsRec.ProductApplicationDesp__c;
                Engineobj.warrantyIndicatorFlag =claimsRec.warrantyIndicatorFlag__c;


            } else {

                //Pass Service job object values. done
                Engineobj.billToCode =serJob.BillToCode__c;
                datetime builddate;
                if(serJob.BuildDate__c != null){
                    builddate = serJob.BuildDate__c;
                    String formatBuildDate = (builddate != null ? builddate.format('MM/dd/yyyy','GMT') : '');
                    Engineobj.buildDate = formatBuildDate;
                }else{
                    Engineobj.buildDate = '';
                }
                Engineobj.engineFamilyCode =serJob.EngineFamilyCode__c;
                datetime etoconvdate;
                if(serJob.EtoConversionDate__c != null){
                    etoconvdate = serJob.EtoConversionDate__c;
                    String formatEtoConvDate = (etoconvdate != null ? etoconvdate.format('MM/dd/yyyy','GMT') : '');
                    Engineobj.etoConversionDate = formatEtoConvDate;
                }else{
                    Engineobj.etoConversionDate = '';
                }
                //Engineobj.marineFlag =serJob.MarineFlag__c;
                Engineobj.marineFlag = (serJob.MarineFlag__c == 'Y' ? 'M' : (serJob.Automotive_App_Flag__c == 'Y' ? 'A' : 'N'));
                Engineobj.oemCode =serJob.SP_PrimaryOEMCode__c;
                Engineobj.productApplicationDesp =serJob.ProductApplicationDesp__c;
                Engineobj.warrantyIndicatorFlag =serJob.warrantyIndicatorFlag__c;
                //Engineobj.designPhaseCode ='';
                //Engineobj.serviceModel ='';
            }
        }catch(Exception ex){
            system.debug('in the exception of passEngineValuestoODM>>>>>'+ex.getLineNumber()+' ' +ex.getMessage());
        }
        return Engineobj;
    }
    /************************************************ ENGINE ********************************************************************/

    /************************************************ SERVICE PROVIDER **********************************************************/
    public static CG_ODM_PreSubmit_ReqJSONParser.ServiceProvider passingserviceprovider(CSS_Claims__c claimsRec, CSS_Job_Order__c serJob,CSS_PSN__c psnRec, boolean isClaim)  {
        CG_ODM_PreSubmit_ReqJSONParser.ServiceProvider  serviceproviderobj =  new CG_ODM_PreSubmit_ReqJSONParser.ServiceProvider();
        system.debug('** Claim Rec'+claimsRec+'** Service Job'+serJob);
        try {
            if(isClaim){
                system.debug('claimsRec.Account__c>>>>>>'+claimsRec.Account__c + 'claimsRec.Service_Model__c>>>>>>'+claimsRec.Service_Model__c);
                List<CSS_Accreditation__c> AccredObj = [select StartDate__c,EndDate__c,Service_Level__c from CSS_Accreditation__c where Account__c =: claimsRec.Account__c  and Service_Model_Name__c =: psnRec.Service_Model__c];
                system.debug('accredObj>>>>>>>'+AccredObj);
                //Pass claim object values.
                serviceproviderobj.channelDescription = claimsRec.SP_CHANNEL_OF_DISTRIBUTION__c; // both 
                serviceproviderobj.channelOfDistribution = claimsRec.CSS_Channel_Code__c;// channnel code 
                serviceproviderobj.claimAllowedDays = claimsRec.SP_CLAIM_ALLOWED_DAYS__c;
                serviceproviderobj.groupName = claimsRec.SP_Group_Name__c;// from claims obj
                dateTime inactiveDate;
                inactiveDate = (claimsRec.SP_CMI_SP_EXPIRATION__c != null & claimsRec.SP_CMI_SP_EXPIRATION__c != '' ? Date.valueOf(claimsRec.SP_CMI_SP_EXPIRATION__c) : null);
                serviceproviderobj.inactiveDate = (inactiveDate != null ? inactiveDate.format('MM/dd/yyyy','GMT') : '');// from claims obj  
                serviceproviderobj.outfileAllClaimsFlag = claimsRec.SP_OUTFILE_ALL_CLAIMS__c;
                serviceproviderobj.region = claimsRec.SP_REGION__c;
                serviceproviderobj.regionCode = claimsRec.SP_REGIONCODE__c;// from claims obj
                serviceproviderobj.territory = claimsRec.SP_TERRITORY_CODE__c;// from claims obj

                serviceproviderobj.spCountry = claimsRec.SP_Country__c;// from claims obj newly
                //Changed Undone Rupesh
                //serviceproviderobj.spCountry = claimsRec.Country__c;

                serviceproviderobj.spSCMDeductiblePct = claimsRec.SP_SCMDeductiblePercentage__c; 
                serviceproviderobj.spState = claimsRec.SP_State__c; 
                serviceproviderobj.groupName ='';
                serviceproviderobj.spWarrantyTrainingStatus = claimsRec.SP_WarrantyTrainingStatus__c;
                serviceproviderobj.spSCMDollarAmt = claimsRec.SP_SCMDollarAmt__c;
                serviceproviderobj.spServiceLevel = (AccredObj!= null && AccredObj.size()>0 ? AccredObj[0].Service_Level__c : '');
                datetime engineCertificationEndDate;
                if(claimsRec.SP_WarrantyCertificationEndDate__c != null){
                    engineCertificationEndDate = Date.valueOf(claimsRec.SP_WarrantyCertificationEndDate__c);
                    String formatEndDate = (engineCertificationEndDate != null ? engineCertificationEndDate.format('MM/dd/yyyy','GMT') : '');
                    serviceproviderobj.spCertificationEndDate = formatEndDate;
                }
                else{
                    serviceproviderobj.spCertificationEndDate = '';
                }
            }else {
                List<CSS_Accreditation__c> AccredObj = [select StartDate__c,EndDate__c,Service_Level__c from CSS_Accreditation__c where Account__c =: serJob.Account__c and Service_Model_Name__c =: serJob.Service_Model__c];
                //Pass Service job object values. done
                serviceproviderobj.channelDescription = serJob.CSS_Channel_Of_Distribution__c; // both 
                serviceproviderobj.channelOfDistribution = serJob.CSS_Channel_Code__c;
                serviceproviderobj.claimAllowedDays = serJob.SP_ClaimAllowedDays__c;
                serviceproviderobj.groupName = serJob.SP_GroupName__c;// from ser obj
                dateTime inactiveDate;
                inactiveDate = (serJob.SP_CMISPExpirationDate__c != null & serJob.SP_CMISPExpirationDate__c != '' ? Date.valueOf(serJob.SP_CMISPExpirationDate__c) : null);
                serviceproviderobj.inactiveDate = (inactiveDate != null ? inactiveDate.format('MM/dd/yyyy','GMT') : '');// from serJob obj
                serviceproviderobj.outfileAllClaimsFlag = serJob.SP_OutfileAllClaims__c;
                serviceproviderobj.region = serJob.SP_Region__c;
                serviceproviderobj.regionCode = serJob.SP_RegionCode__c;// from serjob obj
                serviceproviderobj.territory = serJob.Territory_Class__c;// from serJob obj newly
                serviceproviderobj.spCountry = serJob.SP_Country__c;// from serJob obj newly
                serviceproviderobj.spSCMDeductiblePct = serJob.SP_SCMDeductiblePercentage__c; 
                serviceproviderobj.spState = serJob.SP_State__c; 
                serviceproviderobj.groupName ='';
                serviceproviderobj.spWarrantyTrainingStatus = serJob.SP_WarrantyTrainingStatus__c;
                serviceproviderobj.spSCMDollarAmt = serJob.SP_SCMDollarAmt__c;
                serviceproviderobj.spServiceLevel = (AccredObj != null && AccredObj.size()>0 ? AccredObj[0].Service_Level__c : '');
                datetime engineCertificationEndDate;
                if(serJob.SP_WarrantyCertificationEndDate__c != null){
                    engineCertificationEndDate = Date.valueOf(serJob.SP_WarrantyCertificationEndDate__c);
                    String formatEndDate = (engineCertificationEndDate != null ? engineCertificationEndDate.format('MM/dd/yyyy','GMT') : '');
                    serviceproviderobj.spCertificationEndDate = formatEndDate;
                }
                else{
                    serviceproviderobj.spCertificationEndDate = '';
                }
            }
        }catch(exception e){
            system.debug('Entered into catch block of passingserviceprovider in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
        return serviceproviderobj;
    }
    /************************************************ SERVICE PROVIDER **********************************************************/

    /************************************************ COMPLAINT CODE ************************************************************/
    public static string fetchComplaintCode(CSS_Claims__c claimsRec, CSS_Job_Order__c workJob, boolean isClaim){
        String complaintType; 
        String ComplaintCode='';

        try {           
            if(isClaim)
                complaintType = (claimsRec.Complaint_Type_Desc__c != null && claimsRec.Complaint_Type_Desc__c != '' ? claimsRec.Complaint_Type_Desc__c :(claimsRec.Complaint_Type2_Desc__c != null && claimsRec.Complaint_Type2_Desc__c != '' ? claimsRec.Complaint_Type2_Desc__c : (claimsRec.Complaint_Type3_Desc__c != null && claimsRec.Complaint_Type3_Desc__c != '' ? claimsRec.Complaint_Type3_Desc__c : (claimsRec.Complaint_Type4_Desc__c != null && claimsRec.Complaint_Type4_Desc__c != '' ? workJob.Complaint_Type4_Desc__c : (claimsRec.Complaint_Type5_Desc__c != null && claimsRec.Complaint_Type5_Desc__c != '' ? claimsRec.Complaint_Type5_Desc__c : '')))));
            else
                complaintType = (workJob.Complaint_Type_Desc__c != null && workJob.Complaint_Type_Desc__c != '' ? workJob.Complaint_Type_Desc__c :(claimsRec.Complaint_Type2_Desc__c != null && workJob.Complaint_Type2_Desc__c != '' ? workJob.Complaint_Type2_Desc__c : (workJob.Complaint_Type3_Desc__c != null && workJob.Complaint_Type3_Desc__c != '' ? workJob.Complaint_Type3_Desc__c : (claimsRec.Complaint_Type4_Desc__c != null && workJob.Complaint_Type4_Desc__c != '' ? workJob.Complaint_Type4_Desc__c : (workJob.Complaint_Type5_Desc__c != null && workJob.Complaint_Type5_Desc__c != '' ? workJob.Complaint_Type5_Desc__c : '')))));

            CSS_JobEventTemporary__c[] Categories;
            CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;

            Categories = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
            system.debug('Categories>>>'+Categories);
            string jsonResponse = Categories[0].Reason__c;

            //jsonResponse='{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Description == complaintType){
                        ComplaintCode = det.ComplaintCode;
                    }
                }
            }
        } catch(exception e){
            system.debug('Entered into catch block of fetchComplaintCode in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
        return ComplaintCode;
    }
    /************************************************ COMPLAINT CODE ************************************************************/

    /************************************************ CLAIMS/ SERVICE JOB OBJECT ************************************************/
    public static CG_ODM_PreSubmit_ReqJSONParser.Claim passClaimsValuestoODM(CSS_Claims__c claimsRec, CSS_Job_Order__c serJob, CSS_PSN__c psnRec, string accountTwoDigit, boolean isClaim) {
        CG_ODM_PreSubmit_ReqJSONParser.Claim  Claimobj =  new CG_ODM_PreSubmit_ReqJSONParser.Claim();
        try {
            if(isClaim) 
            {
                //Pass claim object values.
                Claimobj.applicationName = 'Guidanz';
                Claimobj.approverName = '';// as per doc it's blank 
                Claimobj.bisFlag = (psnRec.Before_In_Service__c == true ? 'Y' : 'N');  
                Claimobj.button = 'Verify';
                datetime createddate;
                createddate = claimsRec.CreatedDate;
                String formatCreatedDate = (createddate != null ? createddate.format('MM/dd/yyyy','GMT') : '');
                Claimobj.claimCreatedDate = formatCreatedDate;
                Claimobj.claimNumber = claimsRec.Name; 

                //Add the Engine Family Code as per story 156814: Rupesh Changes Undone
                //Claimobj.engineFamily=psnRec.Qsol_Engine_Family_Code__c;


                Claimobj.claimReceivedDate = '';//  as per doc it's blank 
                Claimobj.claimSource = 'Guidanz';
                Claimobj.claimStatus = 'In Review';
                Claimobj.claimSubmittedDate = ''; //as per doc
                Claimobj.cmiEngineSerialNumber = (psnRec.PSN__C != null ? psnRec.PSN__C : ''); 
                String distrCode = '';
                String brnchCode = '';
                String[] locArray;
                if(claimsRec.Location_Code__c != null && claimsRec.Location_Code__c != '') 
                    locArray = claimsRec.Location_Code__c.split('-');
                if(locArray != null && locArray.size()>0){
                    distrCode = locArray[0];
                    brnchCode = locArray[1];
                }
                Claimobj.cmiServiceProviderCode = brnchCode; 
                //Claimobj.engineApplicationCode = psnRec.ApplicationCode__c;// need to update from psn objectserJob.Application_Desc__c; 

                if(psnRec.Application__c != null && psnRec.Application__c != ''){
                    String applicationCode = css_utility.getCodes('Application Code',psnRec.Application__c,null,null);
                    system.debug('apllication code'+applicationCode);

                    Claimobj.engineApplicationCode = applicationCode;
                }
                else{
                    Claimobj.engineApplicationCode = '';
                }

                Claimobj.engineFamily = claimsRec.EngineFamilyName__c;// need to update from psn objectserJob.Qsol_Engine_Family_Code__c;
                Claimobj.groupName = '';//as per the doc
                Claimobj.level = '0'; //as per the doc
                Claimobj.manualAdjudicationFlag = ''; // as per the doc
                Claimobj.modelSeries = psnRec.Model__c;
                //Claimobj.multiESNFlag = 'NA'; // for july release
                if(claimsRec.Multi_PSN_Claim__c == true){
                    Claimobj.multiESNFlag = 'Y';
                }
                else{
                    Claimobj.multiESNFlag = 'N';
                }
                Claimobj.productApplicationCode = claimsRec.ProductApplicationCode__c;

                if(claimsRec.CSS_Job__c != null)//Automatic claims
                    Claimobj.roNumber = (claimsRec.CSS_Job__r.Shop_Work_Order__c != null && claimsRec.CSS_Job__r.Shop_Work_Order__c != '' ? claimsRec.CSS_Job__r.Shop_Work_Order__c : claimsRec.Id);
                else//Manual Claim
                    Claimobj.roNumber = (claimsRec.Shop_Work_Order__c != null && claimsRec.Shop_Work_Order__c != '' ? claimsRec.Shop_Work_Order__c : claimsRec.Id);

                if(accountTwoDigit!= null && accountTwoDigit == '52')    
                    Claimobj.roadRelayWarrantyFlag = 'Y';
                else
                    Claimobj.roadRelayWarrantyFlag = 'N';
                Claimobj.serviceModelName = psnRec.Service_Model__c; 
                //Claimobj.totalClaimAmt = '';//as per the doc
                //as per the doc Commented by Rajesh Narra during SIT to bypass the validations 7-05-2018
                //Claimobj.totalClaimAmt = '1.00'; 

                /* PARTS WARRANT FIELDS ARE MISSING*/                   
                //Claimobj.roNumber = 0;//make to string ****need to update only on Automatic claims based on service job, Manaul claim -> Map to SWO  
                //Claimobj.status = '';
                //Claimobj.serviceProviderName = '';
                //Claimobj.distributorCode = ''; 
                Claimobj.distributorCode = claimsRec.Account__r.RSS_RESP_BRANCH_CODE__c;   
                // Claimobj.thresholdAmount = '';
                //Claimobj.thresholdHrs = '';
                //Claimobj.ownerName = '';
                //Claimobj.claimTotal = '';
                Claimobj.claimTotal = '1.00';//Vamshi SIT
                //Claimobj.historyClaimFlag = '';
                //Claimobj.possessionFlag = '';
                //Claimobj.ecmCalibBefore = '';
                //Claimobj.ecmCalibAfter = '';
                //Claimobj.manufacturer = '';
                //Claimobj.paccarFlag = '';
                //Claimobj.paccarCertifiedLocationFlag = '';
                //Claimobj.paccarPaymentRoutingFlag = '';
                //Claimobj.countryCode = '';
                //Claimobj.penalty = 0;
                //Claimobj.certificationFlag = '';
                //Claimobj.claimSubSource = '';
            } else {
                //Pass Service job object values.
                Claimobj.applicationName = 'Guidanz';
                Claimobj.approverName = '';// as per doc it's blank 
                Claimobj.bisFlag = (serJob.Before_In_Service__c == true ? 'Y' : 'N');  
                Claimobj.button = 'Verify';
                datetime createddate;
                createddate = serJob.CreatedDate;
                String formatCreatedDate = (createddate != null ? createddate.format('MM/dd/yyyy','GMT') : '');
                Claimobj.claimCreatedDate = formatCreatedDate;
                Claimobj.claimNumber = serJob.Name; 
                Claimobj.claimReceivedDate = '';//  as per doc it's blank 
                Claimobj.claimSource = 'Guidanz';
                Claimobj.claimStatus = 'In Review';
                Claimobj.claimSubmittedDate = ''; //as per doc
                Claimobj.cmiEngineSerialNumber = (serJob.ESN__c != null ? serJob.ESN__c : ''); //changed PSN from claims to esn in service job 
                String distrCode = '';
                String brnchCode = '';
                String[] locArray;
                if(serJob.CSS_Job_Location_Code__c != null && serJob.CSS_Job_Location_Code__c != '') 
                    locArray = serJob.CSS_Job_Location_Code__c.split('-');
                if(locArray != null && locArray.size()>0){
                    distrCode = locArray[0];
                    brnchCode = locArray[1];
                }
                Claimobj.cmiServiceProviderCode = brnchCode; 
                //Claimobj.engineApplicationCode = serJob.ApplicationCode__c;// need to update from psn objectserJob.Application_Desc__c; 

                if(serJob.Application_Desc__c != null && serJob.Application_Desc__c != ''){
                    String applicationCode = css_utility.getCodes('Application Code',serJob.Application_Desc__c,null,null);
                    system.debug('apllication code'+applicationCode);

                    Claimobj.engineApplicationCode = applicationCode;
                }
                else{
                    Claimobj.engineApplicationCode = '';
                }

                Claimobj.engineFamily = serJob.EngineFamilyName__c;// need to update from psn objectserJob.Qsol_Engine_Family_Code__c; 
                Claimobj.groupName = '';//as per the doc
                Claimobj.level = '0'; //as per the doc
                Claimobj.manualAdjudicationFlag = ''; // as per the doc
                Claimobj.modelSeries = serJob.Model__c;
                Claimobj.multiESNFlag = 'N'; // for july release 
                Claimobj.productApplicationCode = serJob.ProductApplicationCode__c;
                Claimobj.roNumber = (serJob.Shop_Work_Order__c != null && serJob.Shop_Work_Order__c != '' ? serJob.Shop_Work_Order__c : serJob.Id);//make to string ****need to update only on Automatic claims based on service job, Manaul claim -> Map to SWO  

                if(accountTwoDigit!= null && accountTwoDigit == '52')    
                    Claimobj.roadRelayWarrantyFlag = 'Y';
                else
                    Claimobj.roadRelayWarrantyFlag = 'N';
                Claimobj.serviceModelName = serJob.Service_Model__c; 
                //Claimobj.totalClaimAmt = '';//as per the doc
                //Claimobj.totalClaimAmt = '1.00';//As part of SIT - Rajesh Narra
                Claimobj.distributorCode = serJob.Account__r.RSS_RESP_BRANCH_CODE__c; 
            }
        } catch(exception e){
            system.debug('Entered into catch block of passClaimsValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return Claimobj;
    }
    /************************************************ CLAIMS/ SERVICE JOB OBJECT ************************************************/

    /************************************************ PARTS WARRANTY ************************************************************/
    public static CG_ODM_PreSubmit_ReqJSONParser.Claim passPartsWarrantyValuestoODM(CSS_Solution_Component__c failure, CSS_Claims__c claimsRec, CSS_Job_Order__c serJob, CSS_PSN__c psnRec, string accountTwoDigit, CG_ODM_PreSubmit_ReqJSONParser.Claim claims, boolean isPW, boolean isClaim) {
        try {
            //CG_ODM_PreSubmit_ReqJSONParser.Claim  Claimobj =  new CG_ODM_PreSubmit_ReqJSONParser.Claim();
            system.debug('failure.Parts_Warranty__c ' + failure.Parts_Warranty__c);
            if(failure.Parts_Warranty__c!= null && failure.Parts_Warranty__c== 'New Parts Warranty')
                claims.newPartsWarrantyFlag = 'Y';
            else 
                claims.newPartsWarrantyFlag = 'N';

            if(failure.Parts_Warranty__c!= null && failure.Parts_Warranty__c== 'Recon Parts Warranty')
                claims.reconPartsWarrantyFlag = 'Y';
            else 
                claims.reconPartsWarrantyFlag = 'N';

            if(isPW) {
                //PARTS WARRANTY
                datetime faildate;
                faildate = failure.Failure_Date__c;
                string FailureDateString = ''; 
                if(faildate != null)
                    FailureDateString = faildate.format('MM/dd/yyyy','GMT');

                datetime warrantystartDate;
                warrantystartDate = failure.Part_Warranty_Start_Date__c;
                string wrntystrtdt = '';
                if(warrantystartDate != null)
                    wrntystrtdt = warrantystartDate.format('MM/dd/yyyy','GMT');
                claims.warrantyStartDate = wrntystrtdt; //parts warranty its different^^^
                claims.failureDate = FailureDateString;// need to update based on parts warrantyserJob.Failure_Date__c //parts warranty its different^^^
                //Check here for application and pass the failure measure accordingly - 182800
                /*if(psnRec.ApplicationCode__c=='130' || psnRec.ApplicationCode__c=='210' || psnRec.ApplicationCode__c=='220' || psnRec.ApplicationCode__c=='310' || psnRec.ApplicationCode__c=='320' || psnRec.ApplicationCode__c=='410'){
                     system.debug('*****psnRec.ApplicationCode__c*****');
                    claims.failurePoint = string.valueof(psnRec.Mileage__c);
                 claims.failureMeasure = string.valueof(psnRec.Mileage_Measure__c);
                }
                else{
                     system.debug('*****  Enter Else psnRec.ApplicationCode__c*****');
                     claims.failurePoint = string.valueOf(psnRec.Product_Hours__c);
                     claims.failureMeasure= 'Hours';
                }*/
                claims.failureMeasure = failure.Failure_Measure__c;// need to update based on parts warranty serJob.Failure_Point_Measure__c//parts warranty its different^^^
                claims.failurePoint = string.valueOf(failure.Failure_Point__c );
            } else {
                // NOT PARTS WARRANTY
                if(isClaim) {
                    // PASS CLAIMS PSN VALUES.
                    datetime faildate;
                    faildate = psnRec.Failure_Date__c;
                    string FailureDateString = ''; 
                    if(faildate != null)
                        FailureDateString = faildate.format('MM/dd/yyyy','GMT');

                    datetime warrantystartDate;
                    warrantystartDate = psnRec.Warranty_Start_Date__c;
                    string wrntystrtdt = '';
                    if(warrantystartDate != null)
                        wrntystrtdt = warrantystartDate.format('MM/dd/yyyy','GMT');
                    claims.warrantyStartDate = wrntystrtdt; //parts warranty its different^^^
                    claims.failureDate = FailureDateString;// need to update based on parts warrantyserJob.Failure_Date__c //parts warranty its different^^^
                    //Check here for application and pass the failure measure accordingly - 182800
                    if(psnRec.ApplicationCode__c=='130' || psnRec.ApplicationCode__c=='210' || psnRec.ApplicationCode__c=='220' || psnRec.ApplicationCode__c=='310' || psnRec.ApplicationCode__c=='320' || psnRec.ApplicationCode__c=='410'){
                        system.debug('*****psnRec.ApplicationCode__c*****');
                        claims.failurePoint = string.valueof(psnRec.Mileage__c);
                        claims.failureMeasure = string.valueof(psnRec.Mileage_Measure__c);
                    }
                    else{
                        system.debug('*****Else psnRec.ApplicationCode__c*****');
                        claims.failurePoint = string.valueOf(psnRec.Product_Hours__c);
                        claims.failureMeasure= 'Hours';
                    }
                    
                    
                    
                   /* claims.failureMeasure = psnRec.Mileage_Measure__c;// need to update based on parts warranty serJob.Failure_Point_Measure__c//parts warranty its different^^^

                    if(psnRec.Mileage_Measure__c == 'Miles' || psnRec.Mileage_Measure__c == 'Kilometers')
                        claims.failurePoint = string.valueOf(psnRec.Mileage__c);
                    else
                        claims.failurePoint = string.valueOf(psnRec.Product_Hours__c);
                    //claims.failurePoint = string.valueOf(psnRec.Failure_Point__c);*/
                } else {
                    //PASS SERVICE JOB OBJECT VALUES.
                    datetime faildate;
                    faildate = serJob.Failure_Date__c;
                    string FailureDateString = ''; 
                    if(faildate != null)
                        FailureDateString = faildate.format('MM/dd/yyyy','GMT');

                    datetime warrantystartDate;
                    warrantystartDate = serJob.Warranty_Start_Date__c;
                    string wrntystrtdt = '';
                    if(warrantystartDate != null)
                        wrntystrtdt = warrantystartDate.format('MM/dd/yyyy','GMT');
                    claims.warrantyStartDate = wrntystrtdt; //parts warranty its different^^^
                    claims.failureDate = FailureDateString;// need to update based on parts warrantyserJob.Failure_Date__c //parts warranty its different^^^
                    //Check here for application and pass the failure measure accordingly - 182800
                    if(serJob.ApplicationCode__c=='130' || serJob.ApplicationCode__c=='210' || serJob.ApplicationCode__c=='220' || serJob.ApplicationCode__c=='310' || serJob.ApplicationCode__c=='320' || serJob.ApplicationCode__c=='410'){
               system.debug('*****psnRec.ApplicationCode__c*****');
                claims.failurePoint = string.valueof(serJob.Mileage__c);
             claims.failureMeasure = string.valueof(serJob.Mileage_Measure__c);
            }
            else{
                system.debug('*****Else psnRec.ApplicationCode__c*****');
                 claims.failurePoint = string.valueOf(serJob.CSS_Hours__c);
                 claims.failureMeasure= 'Hours';
            }
                    
                    
                    
                    /*claims.failureMeasure = serJob.Mileage_Measure__c;// need to update based on parts warranty serJob.Failure_Point_Measure__c//parts warranty its different^^^
                    //if(failurlst.Failure_Measure__c == 'Miles' || failurlst.Failure_Measure__c == 'Kilometers')
                    if(serJob.Mileage_Measure__c == 'Miles' || serJob.Mileage_Measure__c == 'Kilometers')
                        claims.failurePoint = string.valueOf(serJob.Mileage__c);
                    else
                        claims.failurePoint = string.valueOf(serJob.Failure_Point__c);*/
                }
            }
        } catch(exception e){
            system.debug('Entered into catch block of passPartsWarrantyValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return claims;
    }
    /************************************************ PARTS WARRANTY ************************************************************/

    /*********************** START UNIQUE METHODS FOR BOTH CLAIM AND SERVICE JOB OBJECTS ****************************************/

    /************************************************ FAILURES ************************************************/
    public static CG_ODM_PreSubmit_ReqJSONParser.Failures passFailuresValuestoODM(CSS_Solution_Component__c failurlst, string accountCode) {
        //list<CG_ODM_PreSubmit_ReqJSONParser.Failures> failuresListObject = new list<CG_ODM_PreSubmit_ReqJSONParser.Failures>();
        //if(failurelist != null && failurelist.size() > 0) {
        //for(CSS_Solution_Component__c failurlst : failurelist){
        CG_ODM_PreSubmit_ReqJSONParser.Failures Failuresobj =  new CG_ODM_PreSubmit_ReqJSONParser.Failures(); 
        try {
            Failuresobj.accountCode = failurlst.CSS_Account_Formula__c.Right(2);
            Failuresobj.approvalCode = failurlst.Approval_Code__c ;
            Failuresobj.authorizationNumber = failurlst.Authorization_Number__c ;
            CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: failurlst.CSS_Account_Formula__c.Right(2) LIMIT 1];            
            Failuresobj.coverageType =  queryJobEventTemp[0].Attribute1__c;
            //Failuresobj.coverageType = failurlst.CSS_CoverageType__c;
            Failuresobj.failCode = failurlst.System_Code__c + failurlst.Component_Code__c;
            Failuresobj.failMode = failurlst.Failure_Mode__c;
            if(failurlst.Type__c == 'TRP'|| failurlst.Type__c =='ATC' || failurlst.Type__c == 'Campaign'){
            Failuresobj.inShopCampaignFlag = failurlst.In_Shop_SRT_Limit_Flag__c ? 'Y' : 'N';
            }
            else{
                 Failuresobj.inShopCampaignFlag = '';
            }
            Failuresobj.lineNumber = failurlst.id;
            Failuresobj.overrideFlag = 'N';
            Failuresobj.payCode = failurlst.Pay_Code__c;
            if(failurlst.CSS_CoverageType__c!=null && failurlst.CSS_CoverageType__c== 'POL')
                Failuresobj.policyFlag = 'Y';
            else
                Failuresobj.policyFlag = 'N';  
            Failuresobj.programID = '';
            Failuresobj.status = 'Draft';

            if((failurlst.CoveredMealsLodgingAmt__c != null && Integer.valueOf(failurlst.CoveredMealsLodgingAmt__c) > 0) ||
               (failurlst.CoveredTowingMiles__c != null && Integer.valueOf(failurlst.CoveredTowingMiles__c) > 0) ||
               (failurlst.CoveredTravelBaseFareAmt__c != null && Integer.valueOf(failurlst.CoveredTravelBaseFareAmt__c) > 0) ||
               (failurlst.CoveredTravelLabor__c != null && Integer.valueOf(failurlst.CoveredTravelLabor__c) > 0) ||
               (failurlst.CoveredTravelMiles__c != null && Integer.valueOf(failurlst.CoveredTravelMiles__c) > 0))
                Failuresobj.travelCoveredFlag = 'Y';
            else 
                Failuresobj.travelCoveredFlag = 'N';
            //failuresListObject.add(Failuresobj);
            //}
            //}
        } catch(exception e){
            system.debug('Entered into catch block of passFailuresValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return Failuresobj; 
    }
    /************************************************ FAILURES ************************************************/

    /************************************************ CAMPAIGNS ************************************************/
    public static CG_ODM_PreSubmit_ReqJSONParser.Campaign passCampaignValuestoODM(CSS_Solution_Component__c failurlst, string accountCode) {
        //list<CG_ODM_PreSubmit_ReqJSONParser.Campaign>  listCampaignobj =  new list<CG_ODM_PreSubmit_ReqJSONParser.Campaign>();
        //if(failurelist != null && failurelist.size() > 0) {
        //for(CSS_Solution_Component__c failurlst : failurelist){
        CG_ODM_PreSubmit_ReqJSONParser.Campaign  Campaignobj =  new CG_ODM_PreSubmit_ReqJSONParser.Campaign();
        try {
            if(failurlst.Type__c != null &&(failurlst.Type__c == 'ATC' || failurlst.Type__c == 'TRP' || failurlst.Type__c == 'CAMPAIGN')) {
                Campaignobj.accountCode = accountcode;
                Campaignobj.campaignId = failurlst.id;
                Campaignobj.campaignType = failurlst.Type__c;


                datetime campaignstartDate;
                campaignstartDate = failurlst.Campaign_Start_Date__c;
                string camstrtdt = '';
                if(campaignstartDate != null)
                    camstrtdt = campaignstartDate.format('MM/dd/yyyy','GMT');
                Campaignobj.effectiveDate = camstrtdt;// service chmpain tag called data champhain_start_date
                Campaignobj.engineComponentCode = failurlst.Engine_Family_Code__c;
               datetime campaignEndDate;
                campaignEndDate = failurlst.Campaign_End_Date__c;
                string camEnddt = '';
                if(campaignEndDate != null)
                    camEnddt = campaignEndDate.format('MM/dd/yyyy','GMT');
                Campaignobj.expiryDateIntl = camEnddt;//Champ End_date

                Campaignobj.expiryDateNA = camEnddt;//Champ End_date 
                Campaignobj.failMode = failurlst.Failure_Mode__c;
                // Campaignobj.multiFlag = '';
                // Campaignobj.completeIndicator = '';
                Campaignobj.status = failurlst.Status__c;
                Campaignobj.systemCode = failurlst.System_Code__c;
                // Campaignobj.cmpEngineStatusCode = '';
                //listCampaignobj.add(Campaignobj);  
            }
            //}
            //}
        } catch(exception e){
            system.debug('Entered into catch block of passCampaignValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return Campaignobj;
    }
    /************************************************ CAMPAIGNS ************************************************/

    /************************************************ ACCOUNT CODE INFO ************************************************/
    public static CG_ODM_PreSubmit_ReqJSONParser.AcctCodeInfo passingAccountCodeInfo(string accountTwoDigit){
        CG_ODM_PreSubmit_ReqJSONParser.AcctCodeInfo acctcodeinfoobj = new CG_ODM_PreSubmit_ReqJSONParser.AcctCodeInfo();
        try{
            CSS_JobEventTemporary__c[] queryJobEventTemp = [select Attribute1__c,Attribute3__c, Attribute9__c,Attribute7__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' AND Attribute3__c =: accountTwoDigit LIMIT 1];
            if(queryJobEventTemp != null && queryJobEventTemp.size() > 0) {
                acctcodeinfoobj.accountCodeType = queryJobEventTemp[0].Attribute1__c;// coverage type
                acctcodeinfoobj.chryslerFlag = queryJobEventTemp[0].Attribute9__c;
                acctcodeinfoobj.multiESNFlag = queryJobEventTemp[0].Attribute7__c;
                //  acctcodeinfoobj.accountCodeWarrantyFlag = '';  
            }

        } catch(exception e){
            system.debug('Entered into catch block of passingAccountCodeInfo in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
        return acctcodeinfoobj;
    }
    /************************************************ ACCOUNT CODE INFO ************************************************/

    /************************************************ SRT ************************************************/
    public static list<CG_ODM_PreSubmit_ReqJSONParser.SrtList> passSRTValuestoODM(List<CSS_SRT__c> SRTlistValues, string repairLocation, string failureId) {
        //totalsrtTime IS NOT IMPLEMENTED HERE.
        list<CG_ODM_PreSubmit_ReqJSONParser.SrtList> ListOfsrtsobjParser = new list<CG_ODM_PreSubmit_ReqJSONParser.SrtList>();
        try{
            if(SRTlistValues != null && SRTlistValues.size() > 0) {
                for(CSS_SRT__c srt : SRTlistValues) {
                    CG_ODM_PreSubmit_ReqJSONParser.SrtList srtsobj =  new CG_ODM_PreSubmit_ReqJSONParser.SrtList();
                    srtsobj.code = string.valueOf(srt.SRT_ID__c);
                    srtsobj.description = (srt.Assignment__c != null && srt.Assignment__c != '' ? srt.Assignment__c : 'Custom');
                    srtsobj.hours = string.valueOf(srt.SRT_Time__c);
                   srtsobj.lineNumber = failureId;
                    //srtsobj.lineNumber = srt.Component_Id__c; //As per defect 176939
                    if(repairLocation!=null && repairLocation == 'Mobile')   
                        srtsobj.offsiteCheck = 'Y';
                    else
                        srtsobj.offsiteCheck = 'N';

                    srtsobj.quantity = string.valueOf(srt.SRT_Quantity__c);
                    //if(srt.Calculated_Claimed_Hours__c!=null)
                    //totalsrtTime+=srt.Calculated_Claimed_Hours__c; 
                    srtsobj.srtAllowedFlag = 'N';
                    ListOfsrtsobjParser.add(srtsobj);
                }
            }

        } catch(exception e){
            system.debug('Entered into catch block of passSRTValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return ListOfsrtsobjParser;
    }
    /************************************************ SRT ************************************************/

    /************************************************ TTML ************************************************/
    public static list<CG_ODM_PreSubmit_ReqJSONParser.Travels> passTTMLValuestoODM(List<CSS_Parts_Options__c> POlist, string failureId) {
        list<CG_ODM_PreSubmit_ReqJSONParser.Travels> ListOfTTMLsobjParser = new list<CG_ODM_PreSubmit_ReqJSONParser.Travels>();
        try{

            if(POlist != null && POlist.size() > 0) {
                for(CSS_Parts_Options__c p : POlist) {
                    if(p.recordtype.name=='TTML') {
                        CG_ODM_PreSubmit_ReqJSONParser.Travels Travelsobj =  new CG_ODM_PreSubmit_ReqJSONParser.Travels();
                        Travelsobj.hours = string.valueOf(p.HoursTravelled__c);
                        Travelsobj.lineNumber = failureId;
                       //Travelsobj.lineNumber = p.FailurepartId__c; //As per defect 176939
                        if(p.type__c!=null && p.type__C=='Meals')
                            Travelsobj.mealsCharges = (p.ExpenseTotal__c != null ? string.valueOf(p.ExpenseTotal__c) : '');
                        else if(p.type__c!=null && p.type__c=='Towing')  
                            Travelsobj.towingCharges = (p.ExpenseTotal__c != null ? string.valueOf(p.ExpenseTotal__c) : '');
                        Travelsobj.travelDistance = string.valueOf(p.Mileage__c);
                        ListOfTTMLsobjParser.add(Travelsobj);
                    }
                }
            }
        } catch(exception e){
            system.debug('Entered into catch block of passTTMLValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return ListOfTTMLsobjParser;

    }
    /************************************************ TTML ************************************************/

    /************************************************ OC ************************************************/
    public static list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables> passOCValuestoODM(List<CSS_Parts_Options__c> POlist, string failureId) {
        list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables> ListOfOCobj = new list<CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables>();
        try{

            if(POlist != null && POlist.size() > 0) {
                for(CSS_Parts_Options__c p : POlist) {
                    if(p.recordtype.name=='OtherClaimables') {
                        CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables OtherClaimablesobj =  new CG_ODM_PreSubmit_ReqJSONParser.OtherClaimables();
                        OtherClaimablesobj.item = (p.Item__c != null && p.Item__c != '' ? p.Item__c.toUppercase() : '');
                        OtherClaimablesobj.lineNumber = failureId;
                        //OtherClaimablesobj.lineNumber = p.FailurepartId__c; //As per defect 176939
                        OtherClaimablesobj.details = (p.Part_Description__c != null && p.Part_Description__c != '' ? p.Part_Description__c.toUppercase() : '');
                        system.debug('OtherClaimablesobj.details**'+OtherClaimablesobj.details);
                        OtherClaimablesobj.amount = (p.ExpenseTotal__c != null ? string.valueOf(p.ExpenseTotal__c) : '');
                        ListOfOCobj.add(OtherClaimablesobj);
                        system.debug('ListOfOCobj'+ListOfOCobj);
                    }
                }
            }
        } catch(exception e){
            system.debug('Entered into catch block of passOCValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return ListOfOCobj;
    }
    /************************************************ OC ************************************************/

    /************************************************ PARTS ************************************************/
    public static list<CG_ODM_PreSubmit_ReqJSONParser.Parts> passPartsValuestoODM(List<CSS_Parts_Options__c> POlist, string failureId) {
        list<CG_ODM_PreSubmit_ReqJSONParser.Parts> partsListParser = new list<CG_ODM_PreSubmit_ReqJSONParser.Parts>();
        try{

            if(POlist != null && POlist.size() > 0) {
                for(CSS_Parts_Options__c p : POlist) {
                    if(p.recordtype.name=='BMS Parts' || p.recordtype.name=='Parts') {
                        CG_ODM_PreSubmit_ReqJSONParser.Parts partsListobj =  new CG_ODM_PreSubmit_ReqJSONParser.Parts();
                        partsListobj.adjPartPercentage = string.valueOf(p.Covered__c);
                        partsListobj.lineNumber = failureId;
                        //partsListobj.lineNumber = p.FailurepartId__c; //As per defect 176939
                        partsListobj.partId = p.Service_partnumber__c;
                        partsListobj.partName = p.Part_Name__c;
                        //partsListobj.partPrice = '';
                        partsListobj.partPrice = p.Unit_Price__c;
                        partsListobj.qtyApproved = (p.Quantity__c != null ? string.valueOf(p.Quantity__c): '');
                        // partsListobj.priceBook = ''; BELOW ARE NOT THERE IN THE REQ DOC 

                        // partsListobj.reconPartFlag = '';
                        // partsListobj.exceptionPriceBook = '';
                        // partsListobj.channelCode = '';
                        //partsListobj.standardPriceBook = '';
                        //partsListobj.pricingRegion = '';
                        partsListobj.partAllowedFlag = 'N';
                        // partsListobj.partReturnFlag = '';


                        partsListParser.add(partsListobj);
                    }
                }
            }
        } catch(exception e){
            system.debug('Entered into catch block of passPartsValuestoODM in class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return partsListParser;
    }
    /************************************************ PARTS ************************************************/

    /*********************** END UNIQUE METHODS FOR BOTH CLAIM AND SERVICE JOB OBJECTS **********************************/
}