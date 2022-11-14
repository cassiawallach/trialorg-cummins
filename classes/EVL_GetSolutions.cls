/**********************************************************************
Name: EVL_GetSolutions
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is to Display the Solution Content and Default Landing
======================================================
======================================================
History                                                            
-------                                                            
VERSION    AUTHOR                    DATE                             
1.0        Sriprada Sesham           03/13/2019     
1.1        Mallika Subhashini        03/18/2019
***********************************************************************/
public class EVL_GetSolutions {
    
    @AuraEnabled
    Public static list<Knowledge__kav> getknowledge(String solutionId) {
        
        string solname = '';
        string solTitle = '';
        system.debug('**solutionId**'+solutionId);
        for(CSS_Solutions__c sol :[select Name,Solution_Title__c,userTimestamp__c,FSL_Solution_Position__c,Diagnostic_Response__c from CSS_Solutions__c where Id =:solutionId order by FSL_Solution_Position__c])
        {
            solname = sol.FSL_Solution_Position__c+' '+sol.Name;
            solTitle = sol.Solution_Title__c;
        }        
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        knowledgeList = [Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav where UrlName =:solname];
        
        return knowledgeList;
    }
    
    /* method to fetch related knowledge articles,solutions by passing service order id
Author :Mallika P
*/
    @AuraEnabled
    Public static list<FSL_wrapperSolSort> getSolknowledge(String workOrderId) {
        
        set<string> solNameSET = new set<string>();
        list<workOrder> listWo = new list<workOrder>();
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        list<FSL_wrapperSolSort> wrapperSolList=new list<FSL_wrapperSolSort>();
        system.debug('workOrderId '+workOrderId);
        listWo = [SELECT Id, WorkOrderNumber, Repair_Solution__c, selectedsolution__c, FaultCodeId__c, Asset.Name FROM WorkOrder WHERE Id =:workOrderId];
        system.debug('listWo '+listWo);
        list<string> nameList=new list<string>();
        //string continueRepair='' ;//by mallika to redirect from solutiontd
        string defSolName='';
        string parentSolUpdate='';
        string solname='';
        list<string> ksolu=new list<string>();
        string kVerification='';
        string sdiag='';
        string scomment='';
        string nestedSol='';
        Map<string,string> solMap=new Map<string,string>();
        Map<string,string> solparentMap=new Map<string,string>();
        Map<string,CSS_Solutions__c> solDetails=new Map<string,CSS_Solutions__c>();
        List<CSS_Solutions__c> defSol=new List<CSS_Solutions__c>();
        String kurlName='';
        // Id kurlName=''; // Added by Bharat - changed from String to Id
        String solPos;
        Map<string,String> solMapSort=new Map<string,String>();
        // string kValidations='';
        string ksol='';
        //added by vinod on 5-22
        Map<String, Id> cssSoldIdMap=new Map<String, Id>(); 
        if(listWo.size() > 0) {
            for(CSS_Solutions__c sol :[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Notes__c,Diagnostic_Response__c,
                                       userTimestamp__c,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c FROM CSS_Solutions__c
                                       WHERE FaultCode__c =:listWo[0].FaultCodeId__c ORDER BY FSL_Solution_Position__c ])
            {
                String position = sol.FSL_Solution_Position__c;
                String subString = position.substringAfter('.');
                system.debug('**subString'+subString);
                if(subString.length() > 0) {
                    solname ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +sol.FSL_Solution_Position__c+'  '+sol.Solution_Title__c;
                    system.debug('**solname' + solname);
                } 
                else{
                    solname = sol.FSL_Solution_Position__c+'\r\t\r\t\r '+sol.Solution_Title__c;
                }
                system.debug('**solname'+solname);
                nameList.add(solname);
                ksolu.add(sol.Name); // contains list<string> for solution name
                cssSoldIdMap.put(sol.Name, sol.Id);//added by vinod 5-22
                solMap.put(sol.Name,solname); //contains map with solution name,related solname(concatinated sol name)
                solMapSort.put(sol.Name,position);// sorting map  by position
                solDetails.put(sol.Name,sol); // map contains solution name and solution record
            }
            //system.debug('**sol'+sol);
            system.debug('**solMap'+solMap);
            system.debug('**solDetails'+solDetails);
            
            // fetching lowest unperformed solution
            
            list<CSS_Solutions__c> childSol = [SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,CSS_Nested_Solutions__c,
                                               CSS_Nested_Solutions__r.userTimestamp__c,FSL_PositionOfSolution__c FROM CSS_Solutions__c WHERE FaultCode__c =:listWo[0].FaultCodeId__c ORDER BY FSL_PositionOfSolution__c];
            
            //to verify parent solution is performed or not
            for(CSS_Solutions__c csol:childSol) {
                if(csol.CSS_Nested_Solutions__c != null) {
                    solparentMap.put(csol.Name,string.valueof(csol.CSS_Nested_Solutions__r.userTimestamp__c));
                }
            }
            system.debug('**solparentMap**'+solparentMap);
            /*defSol=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,CSS_Nested_Solutions__r.userTimestamp__c, 
CSS_Nested_Solutions__r.Diagnostic_Response__c FROM CSS_Solutions__c WHERE FaultCode__c =:listWo[0].FaultCodeId__c  
ORDER BY userTimestamp__c limit 1];
system.debug('**defSol**'+defSol);*/
            defSol=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,CSS_Nested_Solutions__r.userTimestamp__c,FSL_PositionOfSolution__c   
                    FROM CSS_Solutions__c WHERE FaultCode__c =:listWo[0].FaultCodeId__c AND userTimestamp__c =null ORDER BY  FSL_PositionOfSolution__c limit 1];
            system.debug('**defSol**'+defSol);
            /*            
if(defSol[0].CSS_Nested_Solutions__c != null){
parentSolUpdate=string.valueof(defSol[0].CSS_Nested_Solutions__r.userTimestamp__c);
system.debug('**parentSolUpdate'+parentSolUpdate);
} */
            if(defSol.size() > 0) {
                string solposition = string.valueOf(defSol[0].FSL_Solution_Position__c);
                String solsubString = solposition.substringAfter('.');
                if(solsubString.length() > 0) {
                    defSolName ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +defSol[0].FSL_Solution_Position__c+'  '+defSol[0].Solution_Title__c;
                    system.debug('**defSolName'+defSolName);
                } 
                else {
                    defSolName = defSol[0].FSL_Solution_Position__c+'\r\t\r\t\r '+defSol[0].Solution_Title__c;
                } 
            } else {
                //if all solutions are performed default will be last performed solution
                defSol=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,
                        LastModifiedDate FROM CSS_Solutions__c WHERE userTimestamp__c !=null AND FaultCode__c =:listWo[0].FaultCodeId__c ORDER BY LastModifiedDate desc limit 1];
                defSolName = defSol[0].FSL_Solution_Position__c+'\r\t\r\t\r '+defSol[0].Solution_Title__c;
                system.debug('**defSol**'+defSol);
            }
            
            system.debug('**defSolName**'+defSolName);
            //added by Sriprada for displaying the navigated solution from repair
            string defRepairSol ;
            list<CSS_Solutions__c> solRepair = new list<CSS_Solutions__c>();            
            solRepair=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,
                       LastModifiedDate FROM CSS_Solutions__c WHERE id =:listWo[0].Repair_Solution__c limit 1];
            if(solRepair.size() > 0 && string.isNotBlank(solRepair[0].Solution_Title__c) && solRepair[0].Solution_Title__c != null)
            {
                defRepairSol = solRepair[0].FSL_Solution_Position__c + +'\r\t\r\t\r '+solRepair[0].Solution_Title__c;
            } 
            system.debug('Solution from repair:'+defRepairSol);//code ends here --- Sriprada
            system.debug('cssSoldIdMap Key Set'+cssSoldIdMap.keyset());
            // fetching knowledge articles based on solution name
            // changed query variable by vinod yelala - 5-22
            for(Knowledge__kav kl:[Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav 
                                   where UrlName IN:cssSoldIdMap.keySet()])
            {
                kVerification = kl.Verification__c;
                kurlName=solDetails.get(kl.UrlName).id;
                ksol=solMap.get(kl.UrlName);
                solPos = solMapSort.get(kl.UrlName);
                sdiag=solDetails.get(kl.UrlName).Diagnostic_Response__c;
                //scomment=solComment.get(kl.UrlName);
                scomment=solDetails.get(kl.UrlName).Diagnostic_Notes__c;
                parentSolUpdate=solparentMap.get(kl.UrlName);
                nestedSol=solDetails.get(kl.UrlName).CSS_Nested_Solutions__c;
                String verification = listWo[0].Asset.Name+'-'+listWo[0].Id;
                kVerification = kVerification.replace('{*#SnNo#*}',verification);
                wrapperSolList.add(new FSL_wrapperSolSort(null,solPos,ksol,kVerification,kurlName,
                                                          kl.UrlName,defSolName,sdiag,scomment,null,null,
                                                          parentSolUpdate,nestedSol,cssSoldIdMap.get(kl.UrlName),
                                                          null,null,defRepairSol,null)); //defRepairSol -- added by Sriprada
            }
            system.debug('***solname**'+solname);
            system.debug('***nameList**'+nameList);
            //wrapperSolList.add(new wrapperSol(nameList,ksol));
            system.debug('***wrapperSolList***'+wrapperSolList);
            
            listWo[0].Repair_Solution__c = null; 
            update listWo; // to reset the Repair_Solution__c -- Sriprada
        }        
        wrapperSolList.sort();
        return wrapperSolList;
    } // end of fetching knowledge articles,solutions method by Mallika.
    
    /*
Method to update related solution from Knowledge Accordian by passing solution id,comment,Diagnostic response
Author: Mallika.
*/
    //added workOrderId, solComps by vinod for diag srt integration
    @AuraEnabled    
    Public static void solUpdate(id solutionId,string responseValue,string commentValue, String workOrderId, List<String> solComps, List<String> deSolComps, 
                                 List<FSLSolCompWrappers.CSSCompPartOptionsWrp> selectedParts, List<FSLSolCompWrappers.CSSCompPartOptionsWrp> deSelectedParts,
                                 List<FSLSolCompWrappers.CSSCompsWrp> cssSolWrappers)
    {
        system.debug('workOrderId>>'+workOrderId);
        system.debug('cssSolWrappers>>'+cssSolWrappers);
        //system.debug('partIdReplsRsn>>'+partIdReplsRsn);
        system.debug('selectedParts>>'+selectedParts);
        system.debug('Solution component list:'+solComps);
        
        //Starts--added logic for diagnostic SRTs - Added by Vinod Yelala
        WorkOrder wo = [SELECT Id, Asset.Make__c, Asset.Model__c, Asset.Equipment_Id__c, Asset.Engine_Family_Code__c, Asset.Engine_Family__c, Asset.Service_Model__c, WorkOrderNumber FROM WorkOrder WHERE Id=:workOrderId];
        List<FSL_SRT__c> FsrtsDiag = new List<FSL_SRT__c>();
        FsrtsDiag = [SELECT Id FROM FSL_SRT__c WHERE Service_Order__c = : workOrderId AND Solution_Number__c = : solutionId AND Type__c = 'Diagnosis' Limit 1];
        List<FSL_SRT__c> FsrtsRep = new List<FSL_SRT__c>();
        FsrtsRep  = [SELECT Id FROM FSL_SRT__c WHERE Service_Order__c = : workOrderId AND Solution_Number__c = : solutionId AND Type__c = 'Repair' Limit 1];
        List<FSL_SRT__c> Dsrts = new List<FSL_SRT__c>();
        List<FSL_SRT__c> Rsrts = new List<FSL_SRT__c>();
        
        CSS_Solutions__c cs = [SELECT Id, Name, FaultCode__c, FaultCode__r.Name, userTimestamp__c, Solution_Title__c, FSL_Solution_Position__c, Diagnostic_Response__c, Diagnostic_Notes__c, 
                               CSS_Nested_Solutions__c, CSS_Nested_Solutions__r.userTimestamp__c FROM CSS_Solutions__c WHERE Id =:solutionId];
        List<CSS_Make_Model_Access__c> cssMakeModelAccs;
        CSS_Make_Model_Access__c cssMakeModelAcc ;
        cssMakeModelAccs= [SELECT Id, Access__c FROM CSS_Make_Model_Access__c 
                           WHERE Make__c =: wo.Asset.Make__c 
                           AND Model__c =: wo.Asset.Model__c 
                           AND EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c LIMIT 1];
        if(cssMakeModelAccs != null && cssMakeModelAccs.size() == 1) {
            cssMakeModelAcc = cssMakeModelAccs[0];
        }
        system.debug('responseValue::'+responseValue);
        if(FsrtsDiag.size() == 0 && responseValue != 'Could not perform the solution verification') {
            FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp resp = FSLSRTIntegrationHelperCls.runDiagnosticSRTInterface(wo, 'VER', cs.Name);
            if(resp != null) {
                if (resp.DataArea.CaseResponse != null) {
                    List<FSLDiagSRTIntegrationWrappers.DiagSRTDataArea> CaseResponse = resp.DataArea.CaseResponse;
                    FSL_SRT__c fsrt;
                    for(FSLDiagSRTIntegrationWrappers.DiagSRTDataArea cr : CaseResponse) {
                        if(!cr.Assignment.equalsIgnoreCase('Diagnostic')&& !cr.Assignment.equalsIgnoreCase('Unlisted')&& !cr.Assignment.equalsIgnoreCase('Not Claimable') && !cr.Assignment.equalsIgnoreCase('Not Applicable')) {
                            boolean srtselect = false;
                            if(cr.Assignment.equalsIgnoreCase('PRIMARY')) {
                                srtselect = true;
                            }
                            Decimal srtTm;
                            Boolean booleanR = FALSE;
                            if(String.isNotBlank(cr.SRTID) && cr.VerifyRepeatValue.Step.SRTTime != null) {
                                if(cssMakeModelAcc!=null && cssMakeModelAcc.Access__c == 'A' && cr.VerifyRepeatValue.Step.SRTTime.AccessCodeA != null) {
                                    srtTm = Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeA);
                                }
                                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'B' && cr.VerifyRepeatValue.Step.SRTTime.AccessCodeB != null) {
                                    srtTm = Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeB);
                                }
                                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'C' && cr.VerifyRepeatValue.Step.SRTTime.AccessCodeC != null) {
                                    srtTm = Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeC);
                                }
                                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'D' && cr.VerifyRepeatValue.Step.SRTTime.AccessCodeD != null) {
                                    srtTm = Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeD);
                                }
                                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'R' && cr.VerifyRepeatValue.Step.SRTTime.AccessCodeR != null) {
                                    srtTm = Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeR);
                                    booleanR = TRUE;
                                }
                                system.debug('+++cssMakeModelAcc'+cssMakeModelAcc);
                            }
                            //added null check for srt in AccessCodes A, B, C, D & R. by vinod 9/16
                            fsrt = new FSL_SRT__c(
                                Name = String.isNotBlank(cr.SRTID)?cr.SRTID:'N/A', // 08/21 Vinod - added for passing N/A when srt id is blank from srt resp
                                SRT_ID__c = cr.SRTID,
                                SRT_Quantity__c = String.isNotBlank(cr.SRTID) ? 1 : 0, // SRT_Quantity__c = cr.SRTQuantity,
                                SRT_Time__c = srtTm,
                                Use_R_Time__c = booleanR,
                                SRT_Access_Code__c = cssMakeModelAcc != null ? cssMakeModelAcc.Access__c : '',
                                // SRT_Access_Code__c = cr.SRTAccessCode, // Changed to above value because Diag SRTs return A/B/C/D in SRTAccessCode
                                SRT_Title__c = String.isNotBlank(cr.SRTTitle)?cr.SRTTitle:cr.VerifyRepeatValue.Step.SRTStatusMessage, // 08/21 Vinod - added for passing status msg when srt title is blank from srt resp
                                Access_Code_B__c = (cr.VerifyRepeatValue.Step.SRTTime.AccessCodeB != null ? Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeB) : 0),
                                Access_Code_C__c = (cr.VerifyRepeatValue.Step.SRTTime.AccessCodeC != null ? Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeC) : 0),
                                Step_Id__c = cr.VerifyRepeatValue.Step.StepId,
                                Access_Code_R__c = (cr.VerifyRepeatValue.Step.SRTTime.AccessCodeR != null ? Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeR) : 0),
                                Access_Code_A__c = (cr.VerifyRepeatValue.Step.SRTTime.AccessCodeA != null ? Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeA) : 0),
                                SRT_Type__c = cr.VerifyRepeatValue.SRTType,
                                Access_Code_D__c = (cr.VerifyRepeatValue.Step.SRTTime.AccessCodeD != null ? Decimal.valueOf(cr.VerifyRepeatValue.Step.SRTTime.AccessCodeD) : 0),
                                Service_Order__c = workOrderId,
                                Diagnostic_SRTs__c = workOrderId,
                                Solution_Number__c = solutionId,
                                Type__c = 'Diagnosis',
                                CSS_Fault_Code__c = cs.FaultCode__c,
                                Assignment__c = cr.Assignment,
                                SRT_Select__c = srtselect,
                                Step_Description__c = String.join(cr.VerifyRepeatValue.Step.StepDescription, '\r\n')
                            );
                            Dsrts.add(fsrt);
                        }
                    }
                }
            }
        }
        
        /*Start: Vinod for Repair API call*/
        if(FsrtsRep.size() == 0 && responseValue == 'Most likely the solution. Repair recommended.') {
            FSLDiagSRTREPWrappers respREP = FSLSRTIntegrationHelperCls.runRepairSRTInterface(wo, 'REP', cs.Name, cs.Id, solComps);
            
            if(respREP != null) {
                if (respREP.DataArea.CaseResponse != null) {
                    List<FSLDiagSRTREPWrappers.CaseResponse> CaseResponse = respREP.DataArea.CaseResponse;
                    FSL_SRT__c fsrt;
                    Map <string, string> FIDs = new Map <string, string>();
                    if(solComps != null && solComps.size() > 0)
                    {
                        
                        for(CSS_Solution_Component__c csc : [SELECT Id, Component_Id__c, Selected_Component__c FROM CSS_Solution_Component__c where id in :solComps])
                        {
                            if(String.isNotBlank(csc.Component_Id__c))
                                FIDs.put(csc.Component_Id__c,CSC.Id);
                        }
                    }
                    for(FSLDiagSRTREPWrappers.CaseResponse cr : CaseResponse) {
                        Boolean booleanR = FALSE;
                        //Added by vinod for the filter out below conditions.
                        if(!cr.Assignment.equalsIgnoreCase('Diagnostic') && !cr.Assignment.equalsIgnoreCase('Unlisted')&& !cr.Assignment.equalsIgnoreCase('Not Claimable') && !cr.Assignment.equalsIgnoreCase('Not Applicable')) {
                            boolean srtselect = false;
                            if(cr.Assignment.equalsIgnoreCase('PRIMARY')) {
                                srtselect = true;
                            }
                            if(cr.SRTAccessCode == 'R') {
                                booleanR = TRUE;
                            }
                            fsrt = new FSL_SRT__c(
                                Name = String.isNotBlank(cr.SRTDetails)?cr.SRTDetails:'N/A', // 08/21 Vinod - added for passing N/A when srt id is blank from srt resp
                                SRT_ID__c = cr.SRTDetails,
                                // SRT_Quantity__c = String.isNotBlank(cr.SRTDetails) ? 1 : 0,
                                SRT_Quantity__c = cr.SRTQuantity,
                                SRT_Time__c = cr.SRTTime,
                                Use_R_Time__c = booleanR,
                                SRT_Access_Code__c = cr.SRTAccessCode,
                                SRT_Title__c = String.isNotBlank(cr.SRTTitle)?cr.SRTTitle:cr.SRTMessage, // 08/21 Vinod - added for passing status msg when srt title is blank from srt resp
                                Access_Code_B__c = (cr.AccessCodeB!=null?Decimal.valueOf(cr.AccessCodeB):null),
                                Access_Code_C__c = (cr.AccessCodeC!=null?Decimal.valueOf(cr.AccessCodeC):null),
                                Step_Id__c = cr.VerifyRepeatValue.Step.StepId,
                                Access_Code_R__c = (cr.AccessCodeR!=null?Decimal.valueOf(cr.AccessCodeR):null),
                                Access_Code_A__c = (cr.AccessCodeA!=null?Decimal.valueOf(cr.AccessCodeA):null),
                                SRT_Type__c = cr.VerifyRepeatValue.SRTType,
                                Access_Code_D__c = (cr.AccessCodeA!=null?Decimal.valueOf(cr.AccessCodeD):null),
                                Service_Order__c = workOrderId,
                                Repair_SRTs__c = workOrderId,
                                Component_Id__c  = Fids.get(cr.FailureID),
                                Solution_Number__c = solutionId,
                                Type__c = 'Repair',
                                CSS_Fault_Code__c = cs.FaultCode__c,
                                Assignment__c = cr.Assignment,
                                SRT_Select__c = srtselect,
                                Step_Description__c = String.join(cr.VerifyRepeatValue.Step.StepDescription, '\r\n')
                            );
                            Rsrts.add(fsrt);
                        }
                    }
                }
            }
        }
        system.debug('Dsrts::'+Dsrts.size());
        // Inserting Diagnostic SRTs
        if(!Dsrts.isEmpty()) {
            insert Dsrts;
        }
        // Inserting Repair SRTs for Most Likely
        if(!Rsrts.isEmpty()) {
            insert Rsrts;
        }
        /*End: Vinod for Repair API call*/
        /* End Vinod */
        //Ends --added logic for diagnostic SRTs - Added by Vinod Yelala
        System.debug('**solutionId**'+solutionId+'**responseValue**'+responseValue);
        
        if(cs.CSS_Nested_Solutions__c ==null && cs.CSS_Nested_Solutions__r.userTimestamp__c ==null){
            cs.Diagnostic_Response__c=responseValue;
            cs.Diagnostic_Notes__c=commentValue;
            
            if(cs.userTimestamp__c == null && responseValue !=null){
                cs.userTimestamp__c=system.Now();
            }
        }
        else if(cs.CSS_Nested_Solutions__c !=null && cs.CSS_Nested_Solutions__r.userTimestamp__c !=null){
            cs.Diagnostic_Response__c=responseValue;
            cs.Diagnostic_Notes__c=commentValue;
            if(cs.userTimestamp__c == null && responseValue !=null){
                cs.userTimestamp__c=system.Now();
            }
        }
        system.debug('cs.id>'+cs.id);
        //update cs;
        
        system.debug('solComps>>'+solComps+':::deSolComps>'+deSolComps);
        system.debug((solComps != null && !solComps.isEmpty()));
        system.debug((deSolComps != null && !deSolComps.isEmpty()));
        if((solComps != null && !solComps.isEmpty()) || (deSolComps != null && !deSolComps.isEmpty()))
        {
            system.debug('inside if');
            List<CSS_Solution_Component__c> solCmpsToUpdate=new List<CSS_Solution_Component__c>();
            if(solComps != null && !solComps.isEmpty())
            {
                for(String compid : solComps)
                {
                    system.debug('compid>'+compid);
                    solCmpsToUpdate.add(new CSS_Solution_Component__c(id=(Id)compid,Selected_Component__c=true));
                }
            }
            if(deSolComps != null && !deSolComps.isEmpty())
            {
                for(String compid : deSolComps)
                {
                    system.debug('compid>'+compid);
                    solCmpsToUpdate.add(new CSS_Solution_Component__c(id=(Id)compid,Selected_Component__c=false));
                    //delComps.add(new CSS_Solution_Component__c(id=(Id)compid),Selected_Component__c=false);
                }
            }
            update solCmpsToUpdate;
            
            integer count = 0;
            for(CSS_Solution_Component__c obj : solCmpsToUpdate)
            {
                if(obj.Selected_Component__c == true && count<90)
                {
                    obj.Component_Id__c ='';
                    FSL_getDetailCoverage.getSolutionCoverage(obj.Id);
                    system.debug('SolutionID:'+obj.Id);
                    count++;
                }
            }
        }
        update cs;
        
       
        
        List<FSL_Parts__c> csps=new List<FSL_Parts__c>();
        Set<Id> addedParts=new Set<Id>();
        system.debug('selectedParts size::'+selectedParts.size());
        system.debug('deSelectedParts size::'+deSelectedParts.size());
        Set<Id> checkFailures = new Set<ID>();
        if(selectedParts != null && selectedParts.size() > 0)
        {
            for(FSLSolCompWrappers.CSSCompPartOptionsWrp csp : selectedParts)
            {
                system.debug('csp::'+csp);
                //added by vinod 8/21
                if(csp.selectedPart == null)
                    csp.selectedPart = FALSE;
                csps.add(new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = csp.defQty, 
                                          Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));
                addedParts.add(csp.partOptId);
                if(csp.selectedPart)
                    checkFailures.add(csp.partOptId);
            }
        }
        //added for delete scenario.
        List<FSL_Parts__c> partsToDel=new List<FSL_Parts__c>();
        if(deSelectedParts != null && deSelectedParts.size() > 0) {
            for(FSLSolCompWrappers.CSSCompPartOptionsWrp csp : deSelectedParts) {
                //added by vinod 8/21
                if(csp.selectedPart == null)
                    csp.selectedPart = FALSE;
                if(!addedParts.contains(csp.partOptId))
                {
                    csps.add(new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = 1,//csp.defQty,
                    Select__c = csp.selectedPart, Replacement_Repair_Reason__c = 'Suggested Parts Based on Failure (GSQ Part)'));//csp.replReason));
                    /*partsToDel.add(new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = csp.defQty,
                                                    Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));
                    */addedParts.add(csp.partOptId);
                }
            }
        }
        //added by vinod  for fixing update data issue.
        
        if(!cssSolWrappers.isEmpty())
        {
            for(FSLSolCompWrappers.CSSCompsWrp cws : cssSolWrappers)
            {
                if(!cws.cssSoldOpts.isEmpty())
                {
                    for(FSLSolCompWrappers.CSSCompPartOptionsWrp csp: cws.cssSoldOpts)
                    {
                        if(!addedParts.contains(csp.partOptId))
                        {
                            //commented for delete scenario.
                            csps.add(new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = csp.defQty,
                                                      Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));
                            /*partsToDel.add(new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = csp.defQty,
                                                      Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));
                            */addedParts.add(csp.partOptId);
                        }
                    }
                }
            }
        }
        /*if(!partsToDel.isEmpty())
            delete partsToDel;*/
        system.debug('csps to upsert::'+csps);
        if(!csps.isEmpty()) {
            upsert csps;
        }
        if(!checkFailures.isEmpty())
        {
            Set<Id> compsToSelect = new Set<Id>();
            List<CSS_Solution_Component__c> toselectComps = new List<CSS_Solution_Component__c>();
            for(FSL_Parts__c fslp : [select CSS_Solution_Component__c from FSL_Parts__c where id in :checkFailures AND CSS_Solution_Component__r.Selected_Component__c = FALSE])
            {
                compsToSelect.add(fslp.CSS_Solution_Component__c);
            }
            if(!compsToSelect.isEmpty())
            {
                for(Id csid : compsToSelect)
                {
                    toselectComps.add(new CSS_Solution_Component__c(Id = csid,Selected_Component__c=true ));
                }
                update toselectComps;
            }
            
        }
        if(deSolComps != null && !deSolComps.isEmpty())
        {
            
            List<CSS_Solution_Component__c> delComps = new List<CSS_Solution_Component__c>();
            for(String compid : deSolComps)
            {
                system.debug('compid>'+compid);
                //solCmpsToUpdate.add(new CSS_Solution_Component__c(id=(Id)compid,Selected_Component__c=false));
                delComps.add(new CSS_Solution_Component__c(id=(Id)compid,Selected_Component__c=false));
            }
            //added by vinod for deleting FSL SRTs
            List<FSL_SRT__c> fsrtsToDel = [select id from FSL_SRT__c where Type__c = 'Repair' AND
                                           Solution_Number__c = :solutionId AND Service_Order__c = :workOrderId];
            if(fsrtsToDel != null && !fsrtsToDel.isEmpty())
            {
                delete fsrtsToDel;
            }
            if(delComps != null && !delComps.isEmpty()){
                //delete delComps;
            }
            //Ends
            
        }
        integer count = 0;
            for(FSL_Parts__c obj : csps)
            {
                if(count<90)
                {
                    FSL_CL_getEPRFlag.getEPRFlagTriggerHelper(csps);
                    system.debug('Parts List:'+csps[0].id);
                    count++;
                }
            }
        
    }
    
    //added by Mallika
    @AuraEnabled
    public static void continueToRepair(string workId,string solId) {
        System.debug('Continue To Repair:::');
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        String solname = '';
        
        wo1 = [Select id,Process_Step__c, RecordTypeId from WorkOrder where id=: workId];
        if(wo1.size() > 0)
        {
            if(wo1[0].Process_Step__c == 'Triage & Diagnosis')
            {
                recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
                    .get('SolutionRepair').getRecordTypeId();
            }
        }
        CSS_Solutions__c sol=[SELECT id,name,FSL_Service_Job__c,FaultCode__c,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Notes__c,Repair_Response__c,Repair_Notes__c,Diagnostic_Response__c,userTimestamp__c, 
                              CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c FROM CSS_Solutions__c where Id =:solId ORDER BY FSL_Solution_Position__c];
        String position = sol.FSL_Solution_Position__c;
        String subString = position.substringAfter('.');
        system.debug('**subString'+subString);
        
        if(subString.length() > 0) {
            solname ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t'+sol.FSL_Solution_Position__c+'  '+sol.Solution_Title__c;
        } 
        else {
            solname = sol.FSL_Solution_Position__c+'\r\t\r\t\r '+sol.Solution_Title__c;
        }
        system.debug('**solname'+solname);
        WorkOrder wo     = new WorkOrder();
        wo.Id            = workId;
        wo.Process_Step__c  = 'Repair';
        wo.Status           = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        if(solname !='') {
            wo.SelectedSolution__c  = solname;
        }
        
        system.debug('to update wo '+wo);        
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            update wo;   
            system.debug('RecordType'+recdtypeId);
        }
    }
    
    // Added Ravi To hide/show Input/Output spec Radio buttons 
    @AuraEnabled
    public static WorkOrder getjobordernumber(string strjobId) {
        return [select id, user__r.id from WorkOrder where id=:strjobId limit 1];//User__c modified by Ravi   
    }
    {
        
    }
    //added by vinod for diagnostic audit insert - 7/12
    @AuraEnabled
    public static void insertViewedSolutionOnDiag(String cssSolutionId, String woId) {
        System.debug('cssSolutionId'+cssSolutionId);
        System.debug('woId'+woId);
        List<CSS_Solutions__c> listObjCSSSolution = [SELECT Id,Solution_Title__c,Name
                                                     FROM CSS_Solutions__c
                                                     WHERE Id=:cssSolutionId LIMIT 1];
        system.debug('soltitle:'+listObjCSSSolution[0].Solution_Title__c);
        String eventDes = 'Viewed Solution '+listObjCSSSolution[0].Solution_Title__c;
        FSL_CumminsUtilities.auditTrailInsert('Event-05',woId,eventDes,'','','');        
    }
    
    /* 
* @Author - Vinod yelala
* @Date - 07/18/2019
* @Method - insertPerformedRepairAuditEvent
*/
    @AuraEnabled
    public static void insertPerformedDiagAuditEvent(String cssSolutionId,String repairRadio, String comments, String woId) {
        System.debug('repairRadio'+repairRadio);
        System.debug('comments'+comments);
        System.debug('solId'+woId);
        List<CSS_Solutions__c> listObjCSSSolution = [SELECT Id,Name,Solution_Title__c,FaultCode__c, FaultCode__r.Name,FSL_Solution_Position__c,Diagnostic_Response__c  
                                                     FROM CSS_Solutions__c
                                                     WHERE Id=:cssSolutionId LIMIT 1];
        //added size check in below if condition 8/12
        if(listObjCSSSolution != null && listObjCSSSolution.size() > 0)
        {
            List<CSS_Fault_Code__c> listObjFaultCode =  [SELECT Id,
                                                         (SELECT Id from CSS_Solutions__r)
                                                         FROM CSS_Fault_Code__c
                                                         WHERE Id=:listObjCSSSolution[0].FaultCode__c LIMIT 1];
            Integer size =  listObjFaultCode[0].CSS_Solutions__r.size();
            String rank = listObjCSSSolution[0].FSL_Solution_Position__c+' of '+ String.valueOf(size);
            String eventDes = 'Updated verification : '+repairRadio+'\n'+'Comments : '+comments;
            FSL_CumminsUtilities.auditTrailInsert('Event-20',woId,eventDes,listObjCSSSolution[0].FaultCode__r.Name,rank,listObjCSSSolution[0].Diagnostic_Response__c);
        }
    }
    
    /* 
* @Author - Vinod Yelala
* @Date - 07/18/2019
*/
    @AuraEnabled
    public static void insertSelectedRootCauseOnSol(String cssSolutionId, List<Id> cssSolutionCompId, String solId) {
        System.debug('cssSolutionCompId'+cssSolutionCompId);
        System.debug('solId'+solId);
        String rootCause='';
        String listRootCause ='';
        List<CSS_Solution_Component__c> listObjCSSSolutioncomp = new List<CSS_Solution_Component__c>();
        List<CSS_Solutions__c> listObjCSSSolution = new List<CSS_Solutions__c>();
        List<CSS_Fault_Code__c> listObjFaultCode = new List<CSS_Fault_Code__c>();
        Integer size;
        String rank;
        
        if(cssSolutionCompId.size() > 0) {
            listObjCSSSolutioncomp = [SELECT Id,Name
                                      FROM CSS_Solution_Component__c
                                      WHERE Id IN : cssSolutionCompId];
        }
        try {
            for(CSS_Solution_Component__c objcssSOlCom :listObjCSSSolutioncomp){
                rootCause = rootCause+','+objcssSOlCom.Name;
            }
            System.debug(rootCause.substring(1));
            listRootCause = rootCause.substring(1);
            listObjCSSSolution = [SELECT Id,Name,Solution_Title__c,FaultCode__c, FaultCode__r.Name,
                                  FSL_Solution_Position__c, Diagnostic_Response__c
                                  FROM CSS_Solutions__c
                                  WHERE Id=:cssSolutionId LIMIT 1];
            if(listObjCSSSolution != null && listObjCSSSolution.size() > 0){
                listObjFaultCode =  [SELECT Id,
                                     (SELECT Id from CSS_Solutions__r)
                                     FROM CSS_Fault_Code__c
                                     WHERE Id=:listObjCSSSolution[0].FaultCode__c LIMIT 1];
                size =  listObjFaultCode[0].CSS_Solutions__r.size();
                rank = listObjCSSSolution[0].FSL_Solution_Position__c+' of '+ String.valueOf(size);
                String eventDes = 'Selected Root Cause '+listRootCause;
                FSL_CumminsUtilities.auditTrailInsert('Event-11',solId,eventDes,listObjCSSSolution[0].FaultCode__r.Name,rank,listObjCSSSolution[0].Diagnostic_Response__c);        
            }
        } catch(Exception ex){
            
        }       
    }
    /* 
* @Author - Rajashekar Nallapati
* @Date - 07/11/2019
* @Method - getWorkOrderRecordType
* @Argument - String Type of WorkOrder Id
* @Purpose - To get the Work order record type 
*/
    @AuraEnabled
    public static void insertViewedSolutionOnRepair(String cssSolutionId, String solId) {
        System.debug('cssSolutionId'+cssSolutionId);
        System.debug('solId'+solId);
        List<CSS_Solutions__c> listObjCSSSolution = [SELECT Id,Name,Solution_Title__c,FaultCode__c, FaultCode__r.Name,FSL_Solution_Position__c,Diagnostic_Response__c
                                                     FROM CSS_Solutions__c
                                                     WHERE Id=:cssSolutionId LIMIT 1];
        List<CSS_Fault_Code__c> listObjFaultCode =  [SELECT Id,
                                                     (SELECT Id from CSS_Solutions__r)
                                                     FROM CSS_Fault_Code__c
                                                     WHERE Id=:listObjCSSSolution[0].FaultCode__c LIMIT 1];
        Integer size =  listObjFaultCode[0].CSS_Solutions__r.size();
        String rank = listObjCSSSolution[0].FSL_Solution_Position__c+' of '+ String.valueOf(size);
        
        String eventDes = 'Viewed Solution '+listObjCSSSolution[0].Name+'-'+listObjCSSSolution[0].Solution_Title__c;
        FSL_CumminsUtilities.auditTrailInsert('Event-05',solId,eventDes,listObjCSSSolution[0].FaultCode__r.Name,rank,listObjCSSSolution[0].Diagnostic_Response__c);
    }
}