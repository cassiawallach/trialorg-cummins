/**********************************************************************
Name:FSL_SymptomfcSearch
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is to pass fault code list or symptom values on click of GO to fetch solutions
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                                   
2.0     Shailender				    07/25/2022
***********************************************************************/ 
public with sharing class FSL_SymptomfcSearch {
    public static CG_OP_OAGWrapper callODMHeaderService(id serviceOrderId,string spn,String cumminsfaultCode,string pcode,string highLevelSymptom,string lowLevelSymptom){
        DateTime startTime = System.Now();
        system.debug('serviceOrderId:'+serviceOrderId+'--spn:'+spn+'--cumminsfaultCode'+cumminsfaultCode+'--pcode:'+pcode+'--highLevelSymptom:'+highLevelSymptom+'--lowLevelSymptom:'+lowLevelSymptom);
        WorkOrder wo = [SELECT Id, WorkOrderNumber,Service_Model__c,Application_Code__c, Asset.Name, Asset.Service_Model__c, Asset.Application_Code__c,Asset.Equipment_Id__c,Asset.Engine_Family_Code__c FROM WorkOrder WHERE Id=:serviceOrderId];
        system.debug('***Wo fields ***'+wo);
        //start: updated by Trupthi, NIN-99 Date:2/3/2022
        User usr = [SELECT Id, Profile.name, User_Location__c, userRole.name FROM user WHERE id=:userInfo.getUserId() LIMIT 1];
        system.debug('***usr fields ***'+usr);
          //updated by Trupthi, NIN-99 Date:2/3/2022 -END 
        //CSS_Fault_Code__c cssfc = [select Service_Order__c,Fault_Code_Type__c from CSS_Fault_Code__c where Service_Order__c =:serviceOrderId]; 
        List<CSS_Solutions__c> listtCssSolutions = new List<CSS_Solutions__c>();
        List<CSS_Solutions__c> listlinkCssSolutions = new List<CSS_Solutions__c>();
        FSL_uploadToSymptomQA obj = new FSL_uploadToSymptomQA();
        FSL_symptomRes symRes = new FSL_symptomRes(); 
        FSL_Fault_Code__c cumminsRecord = new FSL_Fault_Code__c();
        FSL_PCode__c pcodeRecord = new FSL_PCode__c();
        FSL_SPN_FMI__c spnfmiRecord = new FSL_SPN_FMI__c();
        FSL_Symptom__c symRec = new FSL_Symptom__c();
        CSS_Fault_Code__c cssFaultCode = new CSS_Fault_Code__c();
        List<Knowledge__kav> kav = new List<Knowledge__kav>();
        List<Knowledge__kav> kl = new List<Knowledge__kav>();
        List<Knowledge__kav> lkl = new List<Knowledge__kav>();
        List<Knowledge__kav> skl = new List<Knowledge__kav>();
        List<Knowledge__kav> lskl = new List<Knowledge__kav>();
        system.debug('***Wo fields **after3 *'+wo);
        List<String> solUrl = new List<String>();
        Map<String, Id> kmap = new  Map<String, Id>();
        List<String> lsolUrl = new List<String>();
        Map<String, Id> lkmap = new  Map<String, Id>();
        Map<string, FSL_DiagTargetTimeResponse.Solutions> mapSolIdTargetTime = new Map<string, FSL_DiagTargetTimeResponse.Solutions>();
        Set<String> solIds = new Set<String>();
        system.debug('***Wo fields **after4 *'+wo);
        String cumfc = ''; 
        String sspn = '';
        String sfmi = '';
        String spcode = '';
        String fcode = '';
        string strLoggedInUserLanguage =UserInfo.getLanguage();
        system.debug('lowlevelsymptom'+lowLevelSymptom);
        if(cumminsfaultCode != '' && cumminsfaultCode != null ) {
            cumminsRecord = [SELECT Id, Name FROM FSL_Fault_Code__c WHERE id=:cumminsfaultCode LIMIT 1];
            System.debug('cumminsRecord**'+cumminsRecord);
            cssFaultCode.Name = cumminsRecord.Name;
            cssFaultCode.Type__c = 'Fault';
            cumfc=cumminsRecord.Name;
            cssFaultCode.Fault_Code_Type__c = '1';
            fcode='1';
            cssFaultCode.Service_Order__c = serviceOrderId;
            cssFaultCode.extfield__c = cumminsRecord.id+' '+serviceOrderId;
        }
       else if(spn != '' && spn != null) {
            spnfmiRecord = [SELECT Id, Name FROM FSL_SPN_FMI__c WHERE id=:spn LIMIT 1];
            cssFaultCode.Name = spnfmiRecord.Name;//123-24
            sspn= cssFaultCode.Name.split('-')[0];
            sfmi= cssFaultCode.Name.split('-')[1]; 
            system.debug('**sspn**'+sspn);
            system.debug('**sfmi**'+sfmi);
            cssFaultCode.Type__c = 'Fault';
            cssFaultCode.Fault_Code_Type__c = '2';
            fcode='2';
            cssFaultCode.Service_Order__c = serviceOrderId;
            cssFaultCode.extfield__c = spnfmiRecord.id+' '+serviceOrderId;
        }
        else if(pcode != '' && pcode != null) {
            pcodeRecord = [SELECT Id, Name FROM FSL_PCode__c WHERE id=:pcode LIMIT 1];
            cssFaultCode.Name = pcodeRecord.Name;
            spcode=cssFaultCode.Name;
            cssFaultCode.Type__c = 'Fault';
            cssFaultCode.Fault_Code_Type__c = '3';
            fcode='3';
            cssFaultCode.Service_Order__c = serviceOrderId;
            cssFaultCode.extfield__c = pcodeRecord.id+' '+serviceOrderId;
        }
        else if(lowLevelSymptom != '' && lowLevelSymptom != null){
            system.debug('**lowLevelSymptom**'+lowLevelSymptom);
            symRec = [SELECT Id, Name, Symptom__c FROM FSL_Symptom__c WHERE Symptom__c=:lowLevelSymptom LIMIT 1];
            cssFaultCode.Name = lowLevelSymptom;
            cssFaultCode.Type__c = 'Symptom';
            cssFaultCode.Fault_Code_Type__c = '0';
            fcode='0';
            cssFaultCode.Service_Order__c = serviceOrderId;
            cssFaultCode.extfield__c = symRec.id+' '+serviceOrderId;
        }
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{ 
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
            reqWrap.SMN= wo.Service_Model__c;
            reqWrap.ApplicationCode=wo.Application_Code__c;
            //reqWrap.SMN= wo.Asset.Service_Model__c;
            // reqWrap.ApplicationCode=wo.Asset.Application_Code__c;
            reqWrap.Faulttype=fcode;
            reqWrap.Languagekey='en';
            reqWrap.Highlevelsymptom=highLevelSymptom;
            reqWrap.Lowlevelsymptom=lowLevelSymptom;            
            List<FSL_SymptomFCSearch_Request_Wrap.FaultCodelist> listf= new List<FSL_SymptomFCSearch_Request_Wrap.FaultCodelist>();
            FSL_SymptomFCSearch_Request_Wrap.FaultCodelist dd = new FSL_SymptomFCSearch_Request_Wrap.FaultCodelist();
            system.debug('**cumfc**'+cumfc);
            system.debug('**SPN**'+sspn);
            system.debug('**FMI**'+sfmi);
            system.debug('**PCode**'+spcode);
            dd.CumminsFaultCode=cumfc;
            dd.SPN=sspn;
            dd.FMI=sfmi;
            dd.PCode=spcode;
            listf.add(dd);
            reqWrap.FaultCodelist=listf;
            String reqJson= System.JSON.serialize(reqWrap);//, FSL_SymptomFCSearch_Request_Wrap.class);
            //String reqJson = '{"ToolId":"Guidanz Web","Contentflag":false,"JobNumber":"CSS-00074753","UserID":"AB123","WorkgroupID":"ALBANY-EAST-ALBANY-02024","Usertype":"Dealer","Userrole":"Technician","PGAGroup":"PGA 01","Customername":"Kenworth","Unitnumber":"22","ShopWONumber":"123456","ESN":"79612345","SMN":"QST30 CM850","Domain":"Engine","ApplicationCode":"130","Applicationdescription":"Automotive","Marketingconfigurationcode":"BB","Generatornumber":"C1600 N5CD","Alternatornumber":"C1600 N5CD","Controllername":"Deif","PSBUPlant":"CPG – UK","PSBUModel":"C550 D5","PSBUSpec":"A","ECMCode":"A01031.01","Make":"Kenworth","Model":"T600","Faulttype":1,"FaultCodelist":[{"CumminsFaultCode":"123","SPN":1328,"FMI":18,"PCode":""}],"Highlevelsymptom":"smoke","Lowlevelsymptom":"blacksmoke","Complaintcode":"302","Offlineflag":true,"Repeatvisitflag":true,"Reconflag":true,"EngineMileage":"345213","Mileageunit":"km","Enginehours":"212321","VIN":"1XKYD49X5EJ392882","Languagekey":"en"}';
            reqWrapper.jsonReqBody = reqJson;
            //executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+reqJson,executionLog,isEligibleForAppLogging);
            //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceOrderId);
            
            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            reqWrapper.serviceName = 'FSL_CDS_GetSolutions';
            reqWrapper.methodType = 'POST';
            
            system.debug('reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            //Call CG_WS_OAG class to call the calloutTSRService() method which will fire the callout
            if(reqJson != null)
                returnWrapper = calloutTSRService(reqWrapper);
            
            HttpResponse response1 =returnWrapper.response;
            System.debug('response1###'+response1.getBody());
            // List<CSS_SymptomQA__c> listSymptom = new List<CSS_SymptomQA__c>();
            List<CSS_Fault_Code__c> listSymptom = new List<CSS_Fault_Code__c>();
            if(response1.getStatusCode()==200){
                if(fcode!='0'){
                    obj = FSL_uploadToSymptomQA.parse(response1.getBody());
                    system.debug('obj>>'+obj);
                    
                    //CT3-34 Start
                    for(FSL_uploadToSymptomQA.FaultCodeList fault:obj.FaultCodeList){
                        if(fault.SolutionCount>0){
                            // to get the solution name
                            for(FSL_uploadToSymptomQA.Solutions solutions : fault.Solutions){
                                solIds.add(solutions.SolutionID); //list contains sol names
                                system.debug('solId for parent fcode not 0>>'+solIds);
                                if(solutions.LinkedSolutionCount>0){
                                    for(FSL_uploadToSymptomQA.LinkedSolutions link : solutions.LinkedSolutions){
                                        solIds.add(link.SolutionID); //list contains related solution names
                                    }
                                }
                            }
                        }
                    }//End
                }
                else if(fcode == '0'){
                    symRes=FSL_symptomRes.parse(response1.getBody()); 
                    System.debug('**symRes**'+symRes);
                    
                    //CT3-34 Start
                    for(FSL_symptomRes.Solutions solutions : symRes.Solutions){
                        solIds.add(solutions.SolutionID); //list contains sol names
                        system.debug('solId for parent fcode 0>>'+solIds);
                        if(solutions.LinkedSolutionCount>0){
                            for(FSL_symptomRes.LinkedSolutions link : solutions.LinkedSolutions){
                                solIds.add(link.SolutionID); //list contains related solution names
                            }
                        }
                    }//end
                }
                
                //Before Solutions inserted, calling Diagnostic Target Time service to get DiagTime for all solutions & to avoid Uncommited Work issue - CT3-34
                if(solIds != null && solIds.size()>0){
                    system.debug('solIds for diag int call>>'+solIds);
                    FSL_DiagTargetTimeResponse diagTargetTimeResp = FSL_getDiagnosticTargetTime.getDiagnosticTargetTime(solIds, wo.Asset.Equipment_Id__c, wo.Asset.Service_Model__c, wo.Asset.Engine_Family_Code__c, 'en'); // Charan--Added for Phoen-259
                    system.debug('diagTargetTimeResp--'+diagTargetTimeResp);
                    if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                        for(FSL_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                            mapSolIdTargetTime.put(sol.SolutionId,sol);
                            system.debug('mapSolIdTargetTime map --'+mapSolIdTargetTime);
                        }
                    }
                }//end
                
                Map<String,Id> mapFaultSol = new Map<String, Id>();
                FSL_uploadToSymptomQA.FaultCodeList faultlist = new FSL_uploadToSymptomQA.FaultCodeList();
                if(cssFaultCode != null){
                    DataBase.upsert(cssFaultCode, CSS_Fault_Code__c.extfield__c,false);
                    //insert cssFaultCode;
                    system.debug('cssFaultCode'+cssFaultCode);
                } 
                
                //Integer i=0;
                if(fcode!='0') { 
                    System.debug('obj');
                    List<String> solIdList = new List<String>();
                    //added As a part of FBI-393
                    Map<String, Knowledge__kav> solUrlKnowledgeMap = new Map<String, Knowledge__kav>();
                    for(FSL_uploadToSymptomQA.FaultCodeList fault : obj.FaultCodeList) {
                        if(fault.SolutionCount > 0) {
                            // to get the solution name
                            for(FSL_uploadToSymptomQA.Solutions solutions : fault.Solutions){
                                solIdList.add(solutions.SolutionID); //list contains sol names
                                if(solutions.LinkedSolutionCount > 0) {
                                    for(FSL_uploadToSymptomQA.LinkedSolutions link : solutions.LinkedSolutions){
                                        solIdList.add(link.SolutionID); //list contains related solution names
                                    }
                                }
                            }
                        }
                    }
                    
                    for(Knowledge__kav knowledgeRec : [SELECT Id, UrlName, Language FROM Knowledge__kav WHERE UrlName IN :solIdList AND (Language =:strLoggedInUserLanguage OR Language = 'en_US')]) {
                        solUrlKnowledgeMap.put(knowledgeRec.UrlName+'_'+knowledgeRec.Language, knowledgeRec);
                    }
                    
                    for(FSL_uploadToSymptomQA.FaultCodeList fault : obj.FaultCodeList) {
                        cssFaultCode.Number_of_Solutions__c = String.valueOf(fault.SolutionCount);
                        if(fault.SolutionCount>0){
                            // to get the solution name
                            for(FSL_uploadToSymptomQA.Solutions solutions : fault.Solutions){
                                // populate kmap, map with knowledge url,id
                                if(solUrlKnowledgeMap.containsKey(solutions.SolutionID+'_'+strLoggedInUserLanguage)) {
                                    //added As a part of FBI-393
                                    Knowledge__kav kKav = solUrlKnowledgeMap.get(solutions.SolutionID+'_'+strLoggedInUserLanguage);
                                    kmap.put(kKav.UrlName, kKav.Id);
                                } else if (solUrlKnowledgeMap.containsKey(solutions.SolutionID+'_en_US')) {
                                    //added As a part of FBI-393
                                    Knowledge__kav kKav = solUrlKnowledgeMap.get(solutions.SolutionID+'_en_US');
                                    kmap.put(kKav.UrlName, kKav.Id);
                                }
                                // populate lmap, map that contains linked knowledge url,id
                                if(solutions.LinkedSolutionCount > 0) {
                                    for(FSL_uploadToSymptomQA.LinkedSolutions link : solutions.LinkedSolutions){
                                        if(solUrlKnowledgeMap.containsKey(link.SolutionID+'_'+strLoggedInUserLanguage)) {
                                            //added As a part of FBI-393
                                            Knowledge__kav kKav = solUrlKnowledgeMap.get(link.SolutionID+'_'+strLoggedInUserLanguage);
                                            lkmap.put(kKav.UrlName, kKav.Id);
                                        } else if (solUrlKnowledgeMap.containsKey(link.SolutionID+'_en_US')) {
                                            //added As a part of FBI-393
                                            Knowledge__kav kKav = solUrlKnowledgeMap.get(link.SolutionID+'_en_US');
                                            lkmap.put(kKav.UrlName, kKav.Id);
                                        }
                                        
                                    }
                                }
                                
                               // solUrl.add(solutions.SolutionID); //list contains sol names
                            }
                            system.debug('**sol url**'+solUrl);
                            //to fetch knowledge related to sol url
                             //Modified By: Sailaja Guntupalli,CHF-1587- 04 April 2021, to fetch knowledge related to sol url and in the language based on user's Language.
                            /* kl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: solUrl AND Language =:strLoggedInUserLanguage];
                            
                            system.debug('**kl**'+kl);
                            // system.debug('**kl**'+ kl.Id);
                            if(kl != null  && kl.size() >0){
                                 //if knowledge found with logged-in user language then return the list. 
                            }
                            else{
                               //default should be en_US
                              strLoggedInUserLanguage ='en_US'; 
                                kl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: solUrl AND Language =:strLoggedInUserLanguage];
                            }
                            system.debug('**kl else**'+kl);
                            for(Knowledge__kav kn:kl){
                                kmap.put(kn.UrlName,kn.Id); //map with knowledge url,id
                            } */
                            system.debug('**kmap**'+kmap);
                            //to fetch knowledge related to linked sol url
                            /* for(FSL_uploadToSymptomQA.Solutions solutions : fault.Solutions){
                                if(solutions.LinkedSolutionCount>0){
                                    for(FSL_uploadToSymptomQA.LinkedSolutions link : solutions.LinkedSolutions){
                                        lsolUrl.add(link.SolutionID); //list contains related solution names
                                    }
                                }
                            }
                            if(lsolUrl.size()>0){
                                //to fetch knowledge related linked sol urlnames
                                lkl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: lsolUrl AND Language =:strLoggedInUserLanguage];
                            }
                            if(lkl.size()>0){
                                for(Knowledge__kav kn:lkl){
                                    lkmap.put(kn.UrlName,kn.Id); //map contains linked knowledge url,id
                                }
                            } */
                            
                            for(FSL_uploadToSymptomQA.Solutions solution : fault.Solutions){
                                CSS_Solutions__c newSolution = new CSS_Solutions__c();
                                newSolution.FaultCode__c = cssFaultCode.Id;
                                newSolution.Unique_Solution__c = solution.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(solution.SolutionPosition);
                                newSolution.Name = solution.SolutionID;
                                newSolution.FSL_Solution_Content__c = kmap.get(solution.SolutionID);//fetch knowledge id by passing sol name
                                newSolution.Solution_Title__c  = solution.SolutionTitle;
                                newSolution.FSL_Solution_Position__c  = String.valueOf(solution.SolutionPosition);
                                newSolution.FSL_Solution_Priority__c  = solution.SolutionPriority;
                                newSolution.FSL_LanguageKey__c  = solution.LanguageKey;
                                newSolution.FSL_Solution_Count__c  = fault.SolutionCount;
                                newSolution.FSL_Service_Job__c = serviceOrderId;
                                newSolution.LinkedSol_Count__c = solution.LinkedSolutionCount;
                                //CTE-34 Start
                                FSL_DiagTargetTimeResponse.Solutions solutionTime = new FSL_DiagTargetTimeResponse.Solutions();
                                solutionTime = mapSolIdTargetTime.get(solution.SolutionID);
                                system.debug('****diag target time parent Solution*****'+ solution.SolutionID);
                                if(solutionTime != null){
                                    newSolution.DiagTargetTime__c = (solutionTime.DiagnosticTargetTime != null && solutionTime.DiagnosticTargetTime != '') ? decimal.valueof(solutionTime.DiagnosticTargetTime) : 0;
                                    newSolution.TargetMessage__c = solutionTime.TargetMessage;  
                                }//CTE-34 End
                                system.debug('****newSolution*****'+ newSolution);
                                listtCssSolutions.add(newSolution);
                                
                                //linked solutions
                                if(solution.LinkedSolutionCount>0){
                                    for(FSL_uploadToSymptomQA.LinkedSolutions link : solution.LinkedSolutions){
                                        CSS_Solutions__c linkCssSolutions = new CSS_Solutions__c();
                                        linkCssSolutions.FaultCode__c = cssFaultCode.Id;
                                        linkCssSolutions.LinkedSol_Value__c = solution.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(solution.SolutionPosition);
                                        linkCssSolutions.Unique_Solution__c = link.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(link.SolutionPosition);
                                        linkCssSolutions.Name = link.SolutionID;
                                        linkCssSolutions.FSL_Solution_Content__c = lkmap.get(link.SolutionID);//fetch knowledge id by passing sol urlname
                                        linkCssSolutions.Solution_Title__c  = link.SolutionTitle;
                                        linkCssSolutions.FSL_Solution_Position__c  = String.valueOf(link.SolutionPosition);
                                        //linkCssSolutions.FSL_Solution_Priority__c  = link.SolutionPriority;
                                        linkCssSolutions.FSL_LanguageKey__c  = link.LanguageKey;
                                        linkCssSolutions.FSL_Service_Job__c = serviceOrderId;
                                        //CTE-34 Start
                                        solutionTime = new FSL_DiagTargetTimeResponse.Solutions();
                                        solutionTime = mapSolIdTargetTime.get(link.SolutionID);
                                        System.debug('****link SolutionID '+ link.SolutionID);
                                        if(solutionTime != null){
                                            linkCssSolutions.DiagTargetTime__c = (solutionTime.DiagnosticTargetTime != null && solutionTime.DiagnosticTargetTime != '') ? decimal.valueof(solutionTime.DiagnosticTargetTime) : 0;
                                            linkCssSolutions.TargetMessage__c = solutionTime.TargetMessage;  
                                        }//CTE-34 End
                                        system.debug('****linkCssSolutions**** '+ linkCssSolutions);
                                        listlinkCssSolutions.add(linkCssSolutions);
                                    }
                                }
                                //i++;
                            }
                        }
                    }
                }
                
                else if(fcode =='0'){ 
                    //for(FSL_symptomRes sym:symRes.Solutions){
                    //cssFaultCode.Number_of_Solutions__c=String.valueOf(sym.SolutionCount);
                    for(FSL_symptomRes.Solutions solutions : symRes.Solutions){
                        solUrl.add(solutions.SolutionID);
                    }
                    for(FSL_symptomRes.Solutions solutions : symRes.Solutions){
                        if(solutions.LinkedSolutionCount>0){
                            for(FSL_symptomRes.LinkedSolutions link : solutions.LinkedSolutions){
                                lsolUrl.add(link.SolutionID);
                            }
                        }
                    }
                   //Modified By: Sailaja Guntupalli,CHF-1587- 04 April 2021, to fetch knowledge related to sol url and in the language based on user's Language.
                    skl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: solUrl AND Language =:strLoggedInUserLanguage];
                    system.debug('****skl*****'+ skl);
                    if(skl != null){
                        //if knowledge found with logged-in user language then return the list. 
                    }
                    else{
                        //default should be en_US
                         strLoggedInUserLanguage ='en_US'; 
                         skl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: solUrl AND Language =:strLoggedInUserLanguage];
                    }
                     system.debug('****skl else*****'+ skl);
                    if(lsolUrl.size()>0){
                        lskl = [SELECT Id, UrlName FROM Knowledge__kav WHERE UrlName =: lsolUrl AND Language =:strLoggedInUserLanguage];
                    }
                    if(skl.size()>0){
                        for(Knowledge__kav knw:skl){
                            kmap.put(knw.UrlName,knw.Id);
                        }
                    }
                    if(lskl.size()>0){
                        for(Knowledge__kav knw:lskl){
                            lkmap.put(knw.UrlName,knw.Id);
                        }
                    }
                    
                    for(FSL_symptomRes.Solutions solution : symRes.Solutions){
                        cssFaultCode.Number_of_Solutions__c = String.valueOf(symRes.SolutionCount);
                        CSS_Solutions__c newSolution = new CSS_Solutions__c();
                        newSolution.FaultCode__c = cssFaultCode.id;
                        newSolution.Name = solution.SolutionID;
                        newSolution.FSL_Solution_Content__c = kmap.get(solution.SolutionID);
                        newSolution.Unique_Solution__c = solution.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(solution.SolutionPosition);
                        newSolution.Solution_Title__c  = solution.SolutionTitle;
                        newSolution.FSL_Solution_Position__c  = string.valueOf(solution.SolutionPosition);
                        newSolution.FSL_Solution_Priority__c  = solution.SolutionPriority;
                        newSolution.FSL_LanguageKey__c  = solution.LanguageKey;
                        newSolution.FSL_Service_Job__c = serviceOrderId;
                        newSolution.LinkedSol_Count__c = solution.LinkedSolutionCount;
                        //newSolution.FSL_Solution_Count__c  = solution.SolutionCount;
                        //CTE-34 Start
                        FSL_DiagTargetTimeResponse.Solutions solutionTime = new FSL_DiagTargetTimeResponse.Solutions();
                        solutionTime = mapSolIdTargetTime.get(solution.SolutionID);
                        if(solutionTime != null){
                            newSolution.DiagTargetTime__c = (solutionTime.DiagnosticTargetTime != null && solutionTime.DiagnosticTargetTime != '') ? decimal.valueof(solutionTime.DiagnosticTargetTime) : 0;
                            newSolution.TargetMessage__c = solutionTime.TargetMessage;  
                        }//CTE-34 End
                        listtCssSolutions.add(newSolution);
                        
                        //linked solutions
                        if(solution.LinkedSolutionCount>0){
                            for(FSL_symptomRes.LinkedSolutions link : solution.LinkedSolutions){
                                CSS_Solutions__c linkCssSolutions = new CSS_Solutions__c();
                                linkCssSolutions.FaultCode__c = cssFaultCode.Id;
                                linkCssSolutions.LinkedSol_Value__c = solution.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(solution.SolutionPosition);
                                linkCssSolutions.Unique_Solution__c = link.SolutionID+'-'+newSolution.FaultCode__c+'-'+String.valueOf(link.SolutionPosition);
                                linkCssSolutions.Name = link.SolutionID;
                                linkCssSolutions.FSL_Solution_Content__c = lkmap.get(link.SolutionID);
                                linkCssSolutions.Solution_Title__c  = link.SolutionTitle;
                                linkCssSolutions.FSL_Solution_Position__c  = String.valueOf(link.SolutionPosition);
                                //linkCssSolutions.FSL_Solution_Priority__c  = link.SolutionPriority;
                                linkCssSolutions.FSL_LanguageKey__c  = link.LanguageKey;
                                linkCssSolutions.FSL_Service_Job__c=serviceOrderId;
                                //CTE-34 Start
                                solutionTime = new FSL_DiagTargetTimeResponse.Solutions();
                                solutionTime = mapSolIdTargetTime.get(link.SolutionID); // CT3-161-child-sols-fix
                                System.debug('****link SolutionID line368'+ link.SolutionID);
                                if(solutionTime != null){
                                    linkCssSolutions.DiagTargetTime__c = (solutionTime.DiagnosticTargetTime != null && solutionTime.DiagnosticTargetTime != '') ? decimal.valueof(solutionTime.DiagnosticTargetTime) : 0;
                                    linkCssSolutions.TargetMessage__c = solutionTime.TargetMessage;  
                                }//CTE-34 End
                                listlinkCssSolutions.add(linkCssSolutions);
                            }
                        }
                    } 
                    // }
                } 
                
                if(cssFaultCode != null){
                    System.debug('**cssFaultCode**'+cssFaultCode);
                    update cssFaultCode;
                    //insert cssFaultCode;
                }        
                if(listtCssSolutions.size()>0){
                    System.debug(listtCssSolutions.size()+'**listtCssSolutions**'+listtCssSolutions);
                    DataBase.upsert (listtCssSolutions, CSS_Solutions__c.Unique_Solution__c,true);
                    for(CSS_Solutions__c sol : listtCssSolutions){
                        //System.debug('Sol:'+sol);
                        mapFaultSol.put(sol.Unique_Solution__c,sol.Id);
                    }
                    // insert listtCssSolutions;
                }
                // linked sol
                //List<CSS_Solutions__c> listlinkCssSolutions1 = new List<CSS_Solutions__c>();
                if(listlinkCssSolutions.size()>0){
                    System.debug(listlinkCssSolutions.size()+'**listlinkCssSolutions**'+listlinkCssSolutions);
                    List<CSS_Solutions__c> listlinkCssSolutions1 = new List<CSS_Solutions__c>();
                    for(CSS_Solutions__c sol : listlinkCssSolutions){
                        sol.CSS_Nested_Solutions__c = mapFaultSol.get(sol.LinkedSol_Value__c);
                        //System.debug('Linked Sol:'+sol);
                        listlinkCssSolutions1.add(sol);
                    }
                    DataBase.upsert (listlinkCssSolutions1, CSS_Solutions__c.Unique_Solution__c,true);
                    // insert listlinkCssSolutions1;
                }
                returnWrapper.bmsStatus='Passed';
                return returnWrapper;  
            }else
            {
                if(response1.getStatusCode()==412) {
                    system.debug('in failed');
                    //String expectationFlag = 'True';
                    CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                    intEngError.Processed_Data__c = 'call 412 issue';
                    intEngError.Response_Body__c = 'Access Denied';
                    //intEngError.Service_Job_Number__c = mainContr.claimsRec.Name;
                    intEngError.Service_Name__c = 'FSL_CDS_GetSolutions';
                    intEngError.Source__c = 'CDS';
                    //intEngError.WWID__c = FedId; 
                    insert intEngError;
                    //return returnWrapper;    
                }  
                
                if(response1.getStatusCode()==417) {
                    system.debug('in failed');
                    CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                    intEngError.Processed_Data__c = 'call 417 issue';
                    intEngError.Response_Body__c = 'Access Denied';
                    //intEngError.Service_Job_Number__c = mainContr.claimsRec.Name;
                    intEngError.Service_Name__c = 'FSL_CDS_GetSolutions';
                    intEngError.Source__c = 'CDS';
                    //intEngError.WWID__c = FedId; 
                    insert intEngError;
                    //return returnWrapper;    
                } 
               // executionLog = FSL_ApplicationLogger.logMessage('Response Body '+response1,executionLog,isEligibleForAppLogging);
                //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceOrderId);
                
                return returnWrapper;    
            }   
        }catch(exception e){
            system.debug('Entered into catch block of callODMWebservice method in FSL_symptomfcsearch class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = 'Unable to retrieve values. Please try again later'+e.getMessage();
            //executionLog = FSL_ApplicationLogger.logMessage('Exception Reason '+ e.getMessage(),executionLog,isEligibleForAppLogging);
            //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceOrderId);
        
            return returnWrapper;
        }
         
    }
    public static CG_OP_OAGWrapper calloutTSRService(CG_IP_OAGWrapper reqWrapper)
    {
        system.debug('**reqWrapper**'+reqWrapper);
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
           HttpRequest req = new HttpRequest();
         HttpResponse httpRes = new HttpResponse();
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_CDS_GetSolutions');
            system.debug('conDetails>>>:'+conDetails);
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
          //  HttpRequest req = new HttpRequest();
            req.setEndpoint(conDetails.End_Point__c); // added +'GetSolution' for the endpoint
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            system.debug('reqWrapper>>>>>>>>'+reqWrapper);
            req.setBody( reqWrapper.jsonReqBody);
            system.debug('conDetails.Method_Type__c>>>>>>>>>>>>>'+conDetails.Method_Type__c + '  '+ conDetails.Timeout__c);
            req.setMethod(conDetails.Method_Type__c);
            req.setTimeout(Integer.valueOf(conDetails.Timeout__c));
            system.debug('req>>>>>>>>'+req.getBody());
            Http http = new Http();  
            startDt = System.now();
            httpRes = http.send(req);
            endDt = System.now();
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalServiceCallTime = totalTime;
            returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
            returnWrapper.request = req;
            returnWrapper.response = httpRes;
            returnWrapper.accessToken = accessTokenOPWrap.accessToken;
            returnWrapper.endPoint = conDetails.End_Point__c;
            system.debug('httpRes>>>>>'+httpRes);
            system.debug(httpRes.getbody());
            return returnWrapper;
            
        }catch(Exception e)
        {
            system.debug('Entered into catch block of calloutGeneric method in CG_WS_OAG class' + e.getMessage() + ' ' + e.getLineNumber());
         // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),httpres.getBody(),Null,Null,'SymptomSearch',httpres.getStatus(),'code','toolid','Guidanz',NULL,'SymptomSearch')); 
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
         HttpResponse Res = new HttpResponse();
        try{
            System.debug('=====GETTING ACCESS TOKEN FOR SERVICE===='+serviceName);
          //  HttpRequest req = new HttpRequest(); 
            Http http = new Http();
            string client_id;
            string client_secret;
            if(!Test.isRunningTest()){
                CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(serviceName);
                //conDetails = CSS_getConnnectionDetails.getConnection(serviceName); 
                System.debug('conDetails'+conDetails);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
       }else if(Test.isRunningTest()){
                endPoint = 'conDetails';
                client_id = 'cleintid';   
                client_secret = 'secret';
            }
            
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
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.appName = 'OAGToken';
            returnWrapper.endPoint = endPoint;
        }
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'SymptomSearch',res.getStatus(),'code','toolid','Guidanz',NULL,'SymptomSearch')); 
        return returnWrapper;        
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