/**********************************************************************
Name:FSL_CL_FaultCodeSolutions
======================================================
======================================================
Purpose:                                                            
-------  
This class is to get solution count and solution position 
for fault codes(Interaction with Insite FC) from Prioritized
and Non-Prioritized table.
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE               CHANGE                    
1.0         PiyushR                    4/02/2019  
2.0         Sailaja 				   10/22/2020
3.0         Sakthiraj                  06/02/2022    
4.0         Sakthiraj                  06/23/2022
5.0         Sakthiraj                  07/23/2022      Since we have the ABR flag check removed the feature matrix check, prevent calling get options and get diag time
6.0         Sakthiraj                  08/04/2022      Added relationship fields(Failure_Code__c and FSL_Service_Job__c) values to CSS Solution Component(SG-98).
***********************************************************************/ 
public class FSL_CL_FaultCodeSolutions {
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    
    public static Map<id,CSS_Fault_Code__c> fetchFaultCodeSolutions(String serviceOrderId,List<CSS_Fault_Code__c> cumminsfaultCodeLst){
        id orderID = Id.valueof(serviceOrderId);
        DateTime startTime = System.Now();
        executionLog = FSL_ApplicationLogger.logStart('FSL_CL_FaultCodeSolutions : fetchFaultCodeSolutions method ' + startTime, executionLog , isEligibleForAppLogging);
        
        executionLog = FSL_ApplicationLogger.logMessage('WorkOrder Id '+orderID,executionLog,isEligibleForAppLogging);
        
        String sObjName = orderID.getSObjectType().getDescribe().getName();
        Map<id,CSS_Fault_Code__c> fautlcodeMap = new Map<id,CSS_Fault_Code__c>();
        WorkOrder wo;
        
        if(sObjName =='WorkOrder'){
            //4.0 Added Inner query
            wo = [SELECT Id,WorkOrderNumber, Asset.Name, Asset.Service_Model__c,Asset.Application_Code__c,
                  FaultCode_Max_Sequence__c,ESN_Insite__c,FSL_Locked_Assest__c, Asset.Equipment_Id__c, Asset.Engine_Family_Code__c, 
                    (SELECT Id, FSL_ABRFlag__c, FSL_TransactionID__c 
                        FROM Service_Order_Extension__r 
                        WHERE FSL_TransactionID__c != null AND FSL_ABRFlag__c = true)
                  FROM WorkOrder
                  WHERE Id=:serviceOrderId];
        }
        //start: updated by Trupthi, NIN-99 Date:2/3/2022
        User usr = [SELECT Id, Profile.name, User_Location__c, userRole.name FROM user WHERE id=:userInfo.getUserId() LIMIT 1];
        system.debug('***usr fields ***'+usr);
        //updated by Trupthi, NIN-99 Date:2/3/2022 -END 
        
        integer maxSeq = FSL_orderController.maxSequenceMethod(serviceOrderId);
        system.debug('***Wo fields ***'+wo);
        Map<String,Id> faultCodeMap = new Map<String,Id>();
        for(CSS_Fault_Code__c fcl : cumminsfaultCodeLst){
            if(fcl.sequence__c == maxSeq){
                faultCodeMap.put(fcl.name,fcl.id);
            }
        }
        boolean sendREq = false;
        Boolean isWoFTR = false;
        Map<String,Id> mapFaultSol = new Map<String, Id>();
        List<CSS_Solutions__c> listtCssSolutions= new List<CSS_Solutions__c>();
        List<CSS_Solution_Component__c> uniqSolWithSolComponentList = new List<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> uniqSolWithLinkSolComponentList = new List<CSS_Solution_Component__c>();
        Set<String> failureIdSet = new Set<String>();  //6.0
        List<CSS_Solutions__c> listlinkCssSolutions= new List<CSS_Solutions__c>();
        string strLoggedInUserLanguage =UserInfo.getLanguage();
        FSL_CL_FaultCodeSolutionsParser obj=new FSL_CL_FaultCodeSolutionsParser();
        FSL_symptomRes symRes=new FSL_symptomRes(); 
        FSL_SPN_FMI__c spnfmiRecord = new FSL_SPN_FMI__c();
        //CSS_Fault_Code__c cssFaultCode = new CSS_Fault_Code__c();
        CSS_SymptomQA__c cssSymptomQA = new CSS_SymptomQA__c();
        
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        //try{ 
        reqWrapper = new CG_IP_OAGWrapper();
        FSL_SymptomFCSearch_Request_Wrap reqWrap=new FSL_SymptomFCSearch_Request_Wrap();
        reqWrap.ToolId='GuidanzWeb';
        reqWrap.Contentflag=false;
        reqWrap.Domain='Engine';
        reqWrap.JobNumber=wo.WorkOrderNumber;
        //start: updated by Trupthi, NIN-99 Date:2/3/2022
        reqWrap.WorkgroupID=usr.User_Location__c;
        reqWrap.Usertype=getUserType(usr.Profile.name, usr.UserRole.name);
        //updated by Trupthi, NIN-99 Date:2/3/2022 -END
        reqWrap.ESN= wo.Asset.Name;
        reqWrap.SMN= wo.Asset.Service_Model__c;
        reqWrap.ApplicationCode=wo.Asset.Application_Code__c;
        reqWrap.Faulttype='1';
        reqWrap.Languagekey='en';
        List<FSL_SymptomFCSearch_Request_Wrap.FaultCodelist> listf= new List<FSL_SymptomFCSearch_Request_Wrap.FaultCodelist>();
        for(CSS_Fault_Code__c fc: cumminsfaultCodeLst){
            if(fc.Number_of_Solutions__c == null){
                FSL_SymptomFCSearch_Request_Wrap.FaultCodelist dd = new FSL_SymptomFCSearch_Request_Wrap.FaultCodelist();
                dd.CumminsFaultCode=fc.name;
                dd.SPN='';
                dd.FMI='';
                dd.PCode='';
                listf.add(dd);
                sendREq = true;
            }
        }
        if(sendREq){
            reqWrap.FaultCodelist=listf;
            //4.0 start
            if(wo.Service_Order_Extension__r != null &&
                wo.Service_Order_Extension__r.size() > 0 ) {
                
                isWoFTR = true;
                reqWrap.ABRTransactionID = wo.Service_Order_Extension__r[0].FSL_TransactionID__c;
            }
            //4.0 end
            system.debug('reqWrap***'+reqWrap);
            String reqJson= System.JSON.serialize(reqWrap);
            system.debug('reqJson***'+reqJson);
            reqWrapper.jsonReqBody = reqJson;
            reqWrapper.serviceName = 'FSL_CDS_GetSolutions';
            reqWrapper.methodType = 'POST';
            
            system.debug('reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            //Call CG_WS_OAG class to call the calloutTSRService() method which will fire the callout
            if(reqJson != null){
                returnWrapper = calloutTSRService(reqWrapper); 
                executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+reqJson,executionLog,isEligibleForAppLogging);
                // FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),orderID);
            }
            
            HttpResponse response1 =returnWrapper.response;
            System.debug('returnWrapper.response '+ returnWrapper.response);
            
            List<CSS_SymptomQA__c> listSymptom = new List<CSS_SymptomQA__c>();
            System.debug('Res**'+response1.getBody());
            obj = FSL_CL_FaultCodeSolutionsParser.parse(response1.getBody());
            executionLog = FSL_ApplicationLogger.logMessage('Response Body '+obj ,executionLog,isEligibleForAppLogging);
                // FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),orderID);
            system.debug('obj******'+json.serialize(obj));
            FSL_CL_FaultCodeSolutionsParser.FaultCodeList faultlist = new FSL_CL_FaultCodeSolutionsParser.FaultCodeList();
            List<CSS_Fault_Code__c> cssFalulist = new List<CSS_Fault_Code__c>();
            if(obj !=null && obj.FaultCodeList !=null ){ 
                system.debug('obj.FaultCodeList***'+obj.FaultCodeList);
                
                //Sruthi Changes - Fix for 101 SOQL Queries
                //Start
                Map<String, List<Knowledge__kav>> klLangMap = new Map<String, List<Knowledge__kav>>();
                Map<String, List<Knowledge__kav>> klDefaultMap = new Map<String, List<Knowledge__kav>>();
                Set<String> solUrlSet = new Set<String>();
                
                //Looping through fault codes to fetch the Solution URLs
                for(FSL_CL_FaultCodeSolutionsParser.FaultCodeList fault:obj.FaultCodeList){
                   if(fault !=null && fault.Solutions !=null ) { //Added by Piyush for VGRS2-369 
                        for(FSL_CL_FaultCodeSolutionsParser.Solutions solution : fault.Solutions){
                            solUrlSet.add(solution.SolutionID); //list contains sol names
                            if(solution !=null && solution.LinkedSolutions !=null ) { //Added by Piyush for VGRS2-369 
                            for(FSL_CL_FaultCodeSolutionsParser.LinkedSolutions link : solution.LinkedSolutions){
                                solUrlSet.add(link.SolutionID); //list contains related solution names
                            }
                           }
                        }
                    } 
                }
                
                for(Knowledge__kav knwObj : [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName IN : solUrlSet AND Language =:strLoggedInUserLanguage]){
                    if(klLangMap.containsKey(knwObj.UrlName)){
                        klLangMap.get(knwObj.UrlName).add(knwObj);
                    }
                    else{
                        klLangMap.put(knwObj.UrlName, new List<Knowledge__kav>{knwObj});
                    }
                }
                
                for(Knowledge__kav knwObj : [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName IN : solUrlSet AND Language ='en_US']){
                    if(klDefaultMap.containsKey(knwObj.UrlName)){
                        klDefaultMap.get(knwObj.UrlName).add(knwObj);
                    }
                    else{
                        klDefaultMap.put(knwObj.UrlName, new List<Knowledge__kav>{knwObj});
                    }
                }
                
                for(FSL_CL_FaultCodeSolutionsParser.FaultCodeList fault:obj.FaultCodeList){
                    if((fault.Solutions).size() >0){
                        if(faultCodeMap.get(STring.valueOf(fault.FaultCode)) != null){
                            CSS_Fault_Code__c csf = new CSS_Fault_Code__c();
                            csf.id = faultCodeMap.get(STring.valueOf(fault.FaultCode));
                            csf.Number_of_Solutions__c = String.valueOf((fault.Solutions).size());
                            cssFalulist.add(csf);
                            fautlcodeMap.put(csf.id,csf);
                        }
                    }
                    List<String> solUrl = new List<String>();
                    Map<String, Id> kmap = new Map<String, Id>();
                    List<String> lsolUrl = new List<String>();
                    Map<String, Id> lkmap = new Map<String, Id>();
                    List<Knowledge__kav> kl = new List<Knowledge__kav>();
                    List<Knowledge__kav> lkl = new List<Knowledge__kav>();
                    Boolean isDefaultLanguage = FALSE;
                    // to get the solution name
                    for(FSL_CL_FaultCodeSolutionsParser.Solutions solution : fault.Solutions){
                        //solUrl.add(solution.SolutionID); //list contains sol names Sruthi - Commented out
                        //Fetching the list directly from map to prevent 101SOQL Error
                        //Fetching based on User language
                        if(klLangMap.containsKey(solution.SolutionID)){
                            kl.addAll(klLangMap.get(solution.SolutionID));
                        }
                    }
                    system.debug('**sol url**'+solUrl);
                    //If User language is NULL fetch from default language
                    //Sruthi // modified by sailaja, CHF-1587
                    if(kl.isEmpty() || kl.size() < 1){
                        for(FSL_CL_FaultCodeSolutionsParser.Solutions solution : fault.Solutions){
                            //Fetching the list directly from map to prevent 101SOQL Error
                            //Fetching based on Default language language
                            isDefaultLanguage = TRUE;
                            if(klDefaultMap.containsKey(solution.SolutionID)){
                                kl.addAll(klDefaultMap.get(solution.SolutionID));
                            }
                        }
                    }
                    /*Commenting this out to prevent SOQL 101 error
//to fetch knowledge related to sol url
// modified by sailaja, CHF-1587
//kl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: solUrl AND Language =:strLoggedInUserLanguage];
system.debug('**kl**'+kl);
if(kl != null){
//if knowledge found with logged-in user language then return the list. 
}
else{
//default should be en_US
strLoggedInUserLanguage ='en_US'; 
kl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: solUrl AND Language =:strLoggedInUserLanguage];
}*/
                    system.debug('**kl else**'+kl);
                    for(Knowledge__kav kn:kl){
                        kmap.put(kn.UrlName,kn.Id); //map with knowledge url,id
                    }
                    system.debug('**kmap**'+kmap);
                    //to fetch knowledge related to linked sol url
                    for(FSL_CL_FaultCodeSolutionsParser.Solutions solution : fault.Solutions){
                        if(solution !=null && solution.LinkedSolutions !=null ) { //Added by Piyush for VGRS2-369 
                        for(FSL_CL_FaultCodeSolutionsParser.LinkedSolutions link : solution.LinkedSolutions){
                            // lsolUrl.add(link.SolutionID); //list contains related solution names Sruthi - Commented out
                            //Fetching the list directly from map to prevent 101SOQL Error
                            //Fetching based on User/Default language based on kl list above
                            if(!isDefaultLanguage){
                                if(klLangMap.containsKey(link.SolutionID)){
                                    lkl.addAll(klLangMap.get(link.SolutionID));
                                }
                            }
                            else{
                                if(klDefaultMap.containsKey(link.SolutionID)){
                                    lkl.addAll(klDefaultMap.get(link.SolutionID));
                                }
                            }
                        }
                     }
               }
                    /*Sruthi - Commenting this out to prevent SOQL 101 error
* List lkl would be fetched from above
if(lsolUrl.size()>0){
//to fetch knowledge related linked sol urlnames
lkl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: lsolUrl AND Language =:strLoggedInUserLanguage];
}*/
                    if(lkl.size()>0){
                        for(Knowledge__kav kn:lkl){
                            lkmap.put(kn.UrlName,kn.Id); //map contains linked knowledge url,id
                        }
                    }
                    for(FSL_CL_FaultCodeSolutionsParser.Solutions solution : fault.Solutions){
                        //Knowledge__kav kl= [Select Id,UrlName from Knowledge__kav where UrlName =:solution.SolutionID];
                        CSS_Solutions__c newSolution = new CSS_Solutions__c();
                        newSolution.FaultCode__c = faultCodeMap.get(STring.valueOf(fault.FaultCode));//cssFaultCode.Id;
                        if(sObjName == 'WorkOrder') {
                            newSolution.FSL_Service_Job__c = serviceOrderId;
                        }
                        if(sObjName == 'CSS_Job_Order__c') {
                            newSolution.Service_Job__c = serviceOrderId;
                        }
                        newSolution.Unique_Solution__c = solution.SolutionID + '-' + newSolution.FaultCode__c +'-'+ String.valueOf(solution.SolutionPosition);
                        newSolution.Name = solution.SolutionID;
                        newSolution.FSL_Solution_Content__c = kmap.get(solution.SolutionID);
                        newSolution.Solution_Title__c  = solution.SolutionTitle;
                        System.debug('**(solution.SolutionPosition'+solution.SolutionPosition);
                        newSolution.FSL_Solution_Position__c  = String.valueOf(solution.SolutionPosition);
                        newSolution.FSL_Solution_Priority__c  = solution.SolutionPriority;
                        newSolution.FSL_LanguageKey__c  = solution.LanguageKey;
                        newSolution.FSL_Solution_Count__c  = fault.SolutionCount;
                        newSolution.LinkedSol_Count__c = solution.LinkedSolutionCount;
                        system.debug('newSolution**'+newSolution);
                        
                        // 4.0 Updated to support Service Order Extension field
                         if(isWoFTR) {
                            newSolution.No_Access_SRT_required__c = true;
                            newSolution.Diagnostic_Response__c = 'Most likely the solution. Repair recommended.';
                            newSolution.Diagnostic_Notes__c = 'Fast Track Repair';
                            newSolution.userTimestamp__c=system.Now();
                            uniqSolWithSolComponentList.addAll(processCompWrap(solution.Components, newSolution.Unique_Solution__c, serviceOrderId, failureIdSet));
                        }
                        listtCssSolutions.add(newSolution);

                        //linked solutions
                        if(solution.LinkedSolutionCount>0){
                            for(FSL_CL_FaultCodeSolutionsParser.LinkedSolutions link : solution.LinkedSolutions){
                                CSS_Solutions__c linkCssSolutions = new CSS_Solutions__c();
                                linkCssSolutions.FaultCode__c = faultCodeMap.get(STring.valueOf(fault.FaultCode));
                                linkCssSolutions.LinkedSol_Value__c = solution.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(solution.SolutionPosition);
                                linkCssSolutions.Unique_Solution__c = link.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(link.SolutionPosition);
                                linkCssSolutions.Name = link.SolutionID;
                                linkCssSolutions.FSL_Solution_Content__c = lkmap.get(link.SolutionID);//fetch knowledge id by passing sol urlname
                                linkCssSolutions.Solution_Title__c  = link.SolutionTitle;
                                linkCssSolutions.FSL_Solution_Position__c  = String.valueOf(link.SolutionPosition);
                                //linkCssSolutions.FSL_Solution_Priority__c  = link.SolutionPriority;
                                linkCssSolutions.FSL_LanguageKey__c  = link.LanguageKey;
                                linkCssSolutions.FSL_Service_Job__c = serviceOrderId;
                                System.debug('****linkCssSolutions**** '+ linkCssSolutions);
                                listlinkCssSolutions.add(linkCssSolutions);
                                
                                // 4.0 Updated to support Service Order Extension field
                                if(isWoFTR) {
                                    uniqSolWithLinkSolComponentList.addAll(processCompWrap(link.Components, linkCssSolutions.Unique_Solution__c, serviceOrderId, failureIdSet));
                                }
                            }
                        }
                    }
                }
                
            }
            if(sObjName =='WorkOrder' && wo != null){
                wo.FaultCode_Max_Sequence__c = maxSeq;
                if(wo.FSL_Locked_Assest__c == null){
                    //Piyush Asset Lockdown
                    //wo.FSL_Locked_Assest__c = wo.ESN_Insite__c;
                    wo.FSL_Locked_Assest__c = wo.asset.name;
                    //5.0 If Work order is FTR will call Options as separate transaction
                    if(!Test.isRunningTest() && !isWoFTR ) {

                        FSL_CL_RetrieveOptionList.insertOptions( wo.FSL_Locked_Assest__c,serviceOrderId);
                    }
                }
                system.debug('*****'+wo);
                update wo;
            }
            
            // FSL_CL_RetrieveOptionList.insertOptions(wo.asset.name,serviceOrderId);
            if(cssFalulist != null){
                System.debug('**cssFalulist**'+cssFalulist);
                update cssFalulist;
            }

            Map<String, FSL_Failure__c> failureIdWithFailure = new Map<String, FSL_Failure__c>();
            if(!failureIdSet.isEmpty()) {
                for(FSL_Failure__c failure : [SELECT Id, Failure_Id__c, Component_Code__c, System_Code__c, Service_Model_Name__c, Failure_Mode__c 
                                                FROM FSL_Failure__c
                                                WHERE Failure_Id__c IN: failureIdSet
                                                    AND Service_Model_Name__c =: wo.Asset.Service_Model__c]){
                    failureIdWithFailure.put(failure.Failure_Id__c, failure);
                }
            }
            
            List<CSS_Solution_Component__c> solutionComponentList = new List<CSS_Solution_Component__c>();

            if(listtCssSolutions.size()>0){
                
                system.debug('listtCssSolutions**'+listtCssSolutions);
                insert listtCssSolutions;  
                
                for(CSS_Solutions__c sol : listtCssSolutions){
                    //System.debug('Sol:'+sol);
                    mapFaultSol.put(sol.Unique_Solution__c,sol.id);
                }
                //Adding for diag target time for list solution with no linked solutions ROAD-222
                List<Id> lstObjSolutions1 = new List<Id>();
                for(CSS_Solutions__c objSol : listtCssSolutions ){
                    lstObjSolutions1.add(objSol.Id);
                }
                lstObjSolutions1.addAll(mapFaultSol.values());
                // 5.0 - SG-82 If WO is FTR don't want to call DiagTargetTime
                if(!isWoFTR) {
                    getDiagTargetTime(lstObjSolutions1,orderID);
                }
                //End of 5.0

                solutionComponentList.addAll(mapSolutionAndFailModeForSolComp(uniqSolWithSolComponentList, mapFaultSol, failureIdWithFailure));
            }
            if(listlinkCssSolutions.size()>0){
                List<CSS_Solutions__c> listlinkCssSolutions1 = new List<CSS_Solutions__c>();
                Map<String,Id> uniqSolWithSolId = new Map<String, Id>();

                for(CSS_Solutions__c sol : listlinkCssSolutions){
                    sol.CSS_Nested_Solutions__c = mapFaultSol.get(sol.LinkedSol_Value__c);
                    System.debug('Linked Sol:'+sol.CSS_Nested_Solutions__c);
                    listlinkCssSolutions1.add(sol);
                }
                System.debug(':::listlinkCssSolutions1 = '+listlinkCssSolutions1);
                insert listlinkCssSolutions1;
                
                List<Id> lstObjSolutions = new List<Id>();
                for(CSS_Solutions__c objSol : listlinkCssSolutions1 ){
                    lstObjSolutions.add(objSol.Id);
                    uniqSolWithSolId.put(objSol.Unique_Solution__c, objSol.id);
                }
                lstObjSolutions.addAll(mapFaultSol.values());
                // 5.0 - SG-82 If WO is FTR don't want to call DiagTargetTime
                if(!isWoFTR) {

                    getDiagTargetTime(lstObjSolutions,orderID);
                }
                
                solutionComponentList.addAll(mapSolutionAndFailModeForSolComp(uniqSolWithLinkSolComponentList, uniqSolWithSolId, failureIdWithFailure));
            }
            
            if(solutionComponentList.size() > 0) {
                insert solutionComponentList;
            }

            return fautlcodeMap;
        }
        return null;
    }

    public static List<CSS_Solution_Component__c> processCompWrap(List<FSL_CL_FaultCodeSolutionsParser.Components> solCompList, String uniqSol, String serviceOrderId, Set<String> failureIdSet){
       
        List<CSS_Solution_Component__c> uniqSolAndSolComponentList = new List<CSS_Solution_Component__c>();
        if(solCompList != null && !solCompList.isEmpty()){
            for(FSL_CL_FaultCodeSolutionsParser.Components solComp: solCompList) {
                CSS_Solution_Component__c cssComp = new CSS_Solution_Component__c();
                cssComp.Selected_Component__c = true;
                cssComp.Name = solComp.ComponentName.left(80);
                cssComp.Component_Id__c = solComp.FailureID;
                cssComp.Unique_Component__c = uniqSol;
                cssComp.FSL_Service_Job__c = serviceOrderId; // 6.0
                uniqSolAndSolComponentList.add(cssComp);
                failureIdSet.add(solComp.FailureID); //6.0 
            }
        }
        return uniqSolAndSolComponentList; 
    }

    //6.0 Added to realate Solution Components to Failure
    private static List<CSS_Solution_Component__c> mapSolutionAndFailModeForSolComp(List<CSS_Solution_Component__c> solCompList, Map<String,Id> failIdWithSolId, Map<String, FSL_Failure__c> failureIdWithFailure){

        for(CSS_Solution_Component__c solComp: solCompList){
            solComp.Solutions__c = failIdWithSolId.get(solComp.Unique_Component__c);
            if(failureIdWithFailure.containsKey(solComp.Component_Id__c) && failureIdWithFailure.get(solComp.Component_Id__c) != null) {
                
                solComp.System_Code__c = (failureIdWithFailure.get(solComp.Component_Id__c).System_Code__c).subString(0, 2);
                solComp.Component_Code__c = (failureIdWithFailure.get(solComp.Component_Id__c).Component_Code__c).subString(0, 2);
                if((failureIdWithFailure.get(solComp.Component_Id__c).System_Code__c).length() > 2) {
                    solComp.SystemCode_Desc__c = (failureIdWithFailure.get(solComp.Component_Id__c).System_Code__c).subString(3);
                }
                if((failureIdWithFailure.get(solComp.Component_Id__c).Component_Code__c).length() > 2) {
                    solComp.ComponentCode_Desc__c = (failureIdWithFailure.get(solComp.Component_Id__c).Component_Code__c).subString(3);
                }
                solComp.Failure_Mode__c = failureIdWithFailure.get(solComp.Component_Id__c).Failure_Mode__c;
                solComp.Failure_Code__c = failureIdWithFailure.get(solComp.Component_Id__c).Id;
            }
        }  
        return solCompList;
    }

    public static CG_OP_OAGWrapper calloutTSRService(CG_IP_OAGWrapper reqWrapper)
    {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        HttpRequest req = new HttpRequest();
        HttpResponse httpRes;
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_CDS_GetSolutions');
            system.debug('conDetails>>>:'+conDetails);
            system.debug('CSS_Integration_Details__c: '+conDetails);
            CG_OP_OAGWrapper accessTokenOPWrap =  getAccessToken(conDetails.AuthEnv__c);
            system.debug('accessTokenOPWrap.exceptionFlag'+accessTokenOPWrap.exceptionFlag);
            //In case of no access token
            if(accessTokenOPWrap!=null && accessTokenOPWrap.exceptionFlag==true)
            {
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = accessTokenOPWrap.errorMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;
            // HttpRequest req = new HttpRequest();
            req.setEndpoint(conDetails.End_Point__c); // added +'GetSolution' for the endpoint
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            req.setBody( reqWrapper.jsonReqBody);
            system.debug('conDetails.Method_Type__c>>>>>>>>>>>>>'+conDetails.Method_Type__c + '  '+ conDetails.Timeout__c);
            req.setMethod(conDetails.Method_Type__c);req.setTimeout(Integer.valueOf(conDetails.Timeout__c));
            system.debug('req>>>>>>>>'+req.getBody());
            Http http = new Http();  
            startDt = System.now();
            // HttpResponse httpRes;
            
            httpRes = http.send(req);
                //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),httpRes.getBody(),Null,Null,'FaultCodeSolutions',httpRes.getStatus(),'code','toolid','Guidanz',Null,'FaultCodeSolutions'));
            
            endDt = System.now();
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalServiceCallTime = totalTime;
            returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
            returnWrapper.request = req;
            returnWrapper.response =  httpRes; 
            returnWrapper.accessToken = accessTokenOPWrap.accessToken;
            returnWrapper.endPoint = conDetails.End_Point__c;
            system.debug('returnWrapper.endPoint>>>>>>>>>>>'+returnWrapper.endPoint);
            //system.debug(httpRes.getbody());
            return returnWrapper;
        }catch(Exception e)
        {
            system.debug('Entered into catch block of calloutGeneric method in CG_WS_OAG class' + e.getMessage() + ' ' + e.getLineNumber());
            //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),httpRes.getBody(),Null,Null,'FaultCodeSolutions',httpRes.getStatus(),'code','toolid','Guidanz',Null,'FaultCodeSolutions'));
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        } 
    }
    public static CG_OP_OAGWrapper getAccessToken(String serviceName){
        string accessToken;
        string endPoint;
        Datetime startDt;
        Datetime endDt;
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try{
            System.debug('=====GETTING ACCESS TOKEN FOR SERVICE===='+serviceName);
            // HttpRequest req = new HttpRequest();
            Http http = new Http();
            string client_id;
            string client_secret;
            
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(serviceName);
            //conDetails = CSS_getConnnectionDetails.getConnection(serviceName);
            System.debug('conDetails'+conDetails);
            endPoint = conDetails.End_Point__c;
            client_id = conDetails.Username__c;
            client_secret = ConDetails.Passcode__c;
            
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            //req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setHeader('client_id',client_id);
            req.setHeader('client_secret',client_secret);
            // HttpResponse res = new HttpResponse();
            startDt = System.now();
            endDt = System.now();
            if(!Test.isRunningTest()){
                res = http.send(req);
                //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'FaultCodeSolutions',res.getStatus(),'code','toolid','Guidanz',Null,'FaultCodeSolutions'));
            }
            string jSONRequestBody = res.getBody();
            if(res.getStatusCode() == 200)
            {
                accessToken=(String)JSON.deserialize(res.getBody(), String.Class);
            }
            System.debug('ACCESS TOKEN BODY: '+res.getBody());
            System.debug('ACCESS TOKEN Status: '+res.getStatus());
            System.debug('ACCESS TOKEN Status Code: '+res.getStatusCode());
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;
        }
        catch(exception e){
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
            //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'FaultCodeSolutions',res.getStatus(),'code','toolid','Guidanz',Null,'FaultCodeSolutions'));
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.appName = 'OAGToken';
            returnWrapper.endPoint = endPoint;
        }
        return returnWrapper;
    }
    
    
    /* 
Author : Sailaja G
Use Story : CT3-34 : Diag Target time insite integration
Date : 10/23/2020
*/
    @future(callout=true)
    public static void getDiagTargetTime(List<Id> solutionIds, Id workOrderId){
        System.debug('** solutionIds ** '+solutionIds);
        
        Map<String, FSL_DiagTargetTimeResponse.Solutions> mapSolIdTargetTime = new Map<String, FSL_DiagTargetTimeResponse.Solutions>();
        Set<String> setObjSolutionSIds = new Set<String>();
        List<CSS_Solutions__c> lstObjCSSSolutions = new List<CSS_Solutions__c>();
        WorkOrder objWorkOrder = null;
        lstObjCSSSolutions = [SELECT Id, Name
                              FROM CSS_Solutions__c
                              WHERE Id IN : solutionIds ];
        objWorkOrder = [SELECT Id, Asset.Service_Model__c, Asset.Equipment_Id__c,Asset.Engine_Family_Code__c
                        FROM WorkOrder
                        WHERE Id =: workOrderId];
        // Iterating list CSS Solutions to add into setObjSolutiondIds
        for(CSS_Solutions__c objCSSSolution : lstObjCSSSolutions){
            setObjSolutionSIds.add(objCSSSolution.Name);
        }
        
        System.debug('setObjSolutionSIds: '+setObjSolutionSIds);
        if(setObjSolutionSIds != null && setObjSolutionSIds.size()>0){
            //Integration call to fetch Diagnostic Target Time
            FSL_DiagTargetTimeResponse diagTargetTimeResp = FSL_getDiagnosticTargetTime.getDiagnosticTargetTime(setObjSolutionSIds, objWorkOrder.Asset.Equipment_Id__c, objWorkOrder.Asset.Service_Model__c, objWorkOrder.Asset.Engine_Family_Code__c, 'en');
            system.debug('diagTargetTimeResp--'+diagTargetTimeResp);
            if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                for(FSL_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                    mapSolIdTargetTime.put(sol.SolutionId,sol);
                }
            }
        }
        
        //Assigning Diag Target time to the listtCssSolutions
        List<CSS_Solutions__c> lstUpdateCSSSolution = new List<CSS_Solutions__c>();
        for(CSS_Solutions__c objCSSSolutionTimes : lstObjCSSSolutions){
            FSL_DiagTargetTimeResponse.Solutions solutionTime = new FSL_DiagTargetTimeResponse.Solutions();
            solutionTime = mapSolIdTargetTime.get(objCSSSolutionTimes.Name);
            if(solutionTime != null){
                objCSSSolutionTimes.DiagTargetTime__c = (solutionTime.DiagnosticTargetTime != null && solutionTime.DiagnosticTargetTime != '') ? decimal.valueof(solutionTime.DiagnosticTargetTime) : 0;
                objCSSSolutionTimes.TargetMessage__c =   solutionTime.TargetMessage; 
                lstUpdateCSSSolution.add(objCSSSolutionTimes);
            }
        }
        update lstUpdateCSSSolution;
        
        
    }
    
    /*//start: updated by Trupthi, NIN-99 Date:2/3/2022
* Creating Private method to get user type based upon the profile name from usrer object
*/
    static string getUserType(String profileName, string userRoleName) {
        string userType;
        if (userRoleName =='Factory'){
            userType='Factory';
        }
        else if (profileName == 'EVL_Dealer_Advanced'|| profileName == 'EVL_Dealer_Technician') {
            userType='Dealer';
        } 
        else if (profileName == 'CSS_Service_Advanced' || profileName == 'CSS_Service_Technician') {
            userType='Distributor';
        } 
        return userType;
    }
    //updated by Trupthi, NIN-99 Date:2/3/2022 -END 
}