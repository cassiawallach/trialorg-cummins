/**********************************************************************
Name: FSL_CL_RepairDisplaySolution
Copyright Â© 2019  Cummins
=======================================================
=======================================================
Purpose:                                                            
-------  
This class is to Display the Solution Content in Repair
=======================================================
=======================================================
History                                                            
-------                                                            
VERSION    AUTHOR                    DATE                             
1.0        Mallika Subhashini        03/13/2019
***********************************************************************/
public class FSL_CL_RepairDisplaySolution {
    
    @AuraEnabled
    Public static list<Knowledge__kav> getknowledge(String solutionId)
    {
        string solname = '';
        string solTitle = '';
        system.debug('**solutionId**'+solutionId);
        for(CSS_Solutions__c sol :[select Name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c from CSS_Solutions__c where Id =:solutionId order by FSL_Solution_Position__c])
        {
            solname = sol.FSL_Solution_Position__c+' '+sol.Name;
            solTitle = sol.Solution_Title__c;
        }        
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        knowledgeList = [Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav where UrlName =:solname];
        
        return knowledgeList;
    }
    
    /* method added by Mallika.P */ 
    @AuraEnabled
    Public static void woselecomnull(String workOrderId)
    {
        workorder wo = [select id,Asset.Name from workorder where id =:workOrderId];
        Service_Order_Extension__c soExtn = [SELECT Id, SelectedSolution__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =:workOrderId ];

        soExtn.SelectedSolution__c='';
        update soExtn;
    }
    
    /* method to fetch related knowledge articles,solutions by passing service order id
Author :Mallika PgetSolknowledge

*/
    @AuraEnabled
    Public static list<FSL_wrapperSolSort> getSolknowledge(String workOrderId)
    {
        set<string> solNameSET = new set<string>();
        List<string> SolutionName = new List<string>();
        list<workOrder> listWo = new list<workOrder>();
        list<Service_Order_Extension__c> SOextn = new list<Service_Order_Extension__c>();
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        list<FSL_wrapperSolSort> wrapperSolList=new list<FSL_wrapperSolSort>();
        system.debug('workOrderId '+workOrderId);
        listWo = [select id,Asset.Name,Process_Step__c from workorder where id =:workOrderId];
        SOextn = [SELECT Id, SelectedSolution__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =:workOrderId ];
        system.debug('listWo '+listWo);
        list<string> nameList=new list<string>();
        string selectedsol =SOextn[0].SelectedSolution__c;
        string defSolName='';
        string parentSolUpdate='';
        string solname='';
        list<string> ksolu=new list<string>();
        string sdiag='';
        string scomment='';
        string srepair='';
        string srepairnotes='';
        string nestedSol='';
        Map<string,string> solMap=new Map<string,string>();
        Map<string,string> solparentMap=new Map<string,string>();
        Map<string,CSS_Solutions__c> solDetails=new Map<string,CSS_Solutions__c>();
        List<CSS_Solutions__c> defSol=new List<CSS_Solutions__c>();
        List<CSS_Solutions__c> relSol=new List<CSS_Solutions__c>();
        String kurlName='';
        // Id kurlName=''; // Added by Bharat - changed from String to Id
        String solPos;
        Map<string,CSS_Solutions__c> solMapSort=new Map<string,CSS_Solutions__c>();
        string kValidations='';
        string kRepairs='';
        string ksol='';
        //added by vinod on 5-22
        Map<String, Id> cssSoldIdMap=new Map<String, Id>(); 
        
        //Sruthi - To pull the FaultCodeID from Service Order Extension
        
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: listWo[0].Id];
        String FCId = woExtList[0].FaultCodeId__c;
        
        if(listWo.size()>0 && woExtList.size() > 0  && FCId != null) 
        {
            relSol=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Notes__c,Repair_Response__c,Repair_Notes__c,Diagnostic_Response__c,userTimestamp__c, 
                    CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c FROM CSS_Solutions__c 
                    WHERE FaultCode__c =:FCId ORDER BY FSL_Solution_Position__c];
            system.debug('**sol**'+relSol.size());
            for(CSS_Solutions__c sol :relSol)            
            {
                String position = sol.FSL_Solution_Position__c;
                String subString = position.substringAfter('.');
                system.debug('**subString'+subString);
                
                if(subString.length() > 0) {
                    
                    solname ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +sol.FSL_Solution_Position__c+'  '+sol.Solution_Title__c;
                    
                    system.debug('**solname'+solname);
                } 
                else{
                    solname = sol.FSL_Solution_Position__c+'\r\t\r\t\r '+sol.Solution_Title__c;
                }
                system.debug('**solname'+solname);
                nameList.add(solname);
                ksolu.add(sol.Name); // contains list<string> for solution name
                cssSoldIdMap.put(sol.Name, sol.Id);//added by vinod 5-22
                solMap.put(sol.Id,solname); //contains map with solution name,related solname(concatinated sol name)
                SolutionName.add(sol.Name+'-'+sol.Id);
                solMapSort.put(sol.Id,sol);// sorting map  by position
                solDetails.put(sol.Id,sol); // map contains solution name and solution record
            }
            system.debug('**solMap'+solMap);
            system.debug('**solDetails'+solDetails);
            
            
            system.debug('**defSolName**'+defSolName);
            
           Map<String,String> urlvalidationMap = new Map<String,String>();
            Map<String,String> urlRapairMap = new Map<String,String>();
            List<Knowledge__kav> knwRecords = [Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav 
                                                    where UrlName IN:cssSoldIdMap.keySet()];
            system.debug('KnwSize:'+knwRecords.size());
            for(Knowledge__kav kl:knwRecords)
            {
                urlvalidationMap.put(kl.UrlName,kl.Validations__c);
                urlRapairMap.put(kl.UrlName,kl.Repairs__c);
            }
            
            // fetching knowledge articles based on solution name
            // changed query variable by vinod yelala - 5-22
            /*for(Knowledge__kav kl:[Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav 
                                   where UrlName IN:cssSoldIdMap.keySet()]){
                                       kValidations = kl.Validations__c;
                                       kRepairs = kl.Repairs__c;
                                       kurlName=solDetails.get(kl.UrlName).id;
                                       ksol=solMap.get(kl.UrlName);
                                       solPos = solMapSort.get(kl.UrlName);
                                       sdiag=solDetails.get(kl.UrlName).Diagnostic_Response__c;
                                       srepair = solDetails.get(kl.UrlName).Repair_Response__c;
                                       //scomment=solComment.get(kl.UrlName);
                                       scomment=solDetails.get(kl.UrlName).Diagnostic_Notes__c;
                                       srepairnotes=solDetails.get(kl.UrlName).Repair_Notes__c;
                                       parentSolUpdate=solparentMap.get(kl.UrlName);
                                       nestedSol=solDetails.get(kl.UrlName).CSS_Nested_Solutions__c;
                                       String verification = listWo[0].Asset.Name+'-'+listWo[0].Id;
                                       if(String.isNotBlank(kValidations))
                                           kValidations = kValidations.replace('{*#SnNo#*}',listWo[0].Asset.Name);                                       
                                       kRepairs = kRepairs.replace('{*#SnNo#*}',verification);
                                       wrapperSolList.add(new FSL_wrapperSolSort(selectedsol,solPos,ksol,null,kurlName,
                                                                                 kl.UrlName,null,sdiag,scomment,srepair,srepairnotes,
                                                                                 parentSolUpdate,nestedSol,cssSoldIdMap.get(kl.UrlName),
                                                                                 kRepairs,kValidations,selectedsol));
                                   }*/
            
            for(String klName:SolutionName)
            {
                String kl = klName.subStringBefore('-');
                String klId = klName.substringAfter('-');
                
                if(urlvalidationMap.get(kl) != null && urlvalidationMap.get(kl) !=''){
                    kValidations = urlvalidationMap.get(kl);
                    if(String.isNotBlank(kValidations))
                        kValidations = kValidations.replace('{*#SnNo#*}',listWo[0].Asset.Name);
                }
                if(urlRapairMap.get(kl) != null && urlRapairMap.get(kl) !=''){
                    kRepairs = urlRapairMap.get(kl);
                    String verification = listWo[0].Asset.Name+'-'+listWo[0].Id;
                    kRepairs = kRepairs.replace('{*#SnNo#*}',verification);
                }
                kurlName=solDetails.get(klId).id;
                //kurlName=klId;
                ksol=solMap.get(klId);
                solPos = solMapSort.get(klId).FSL_Solution_Position__c;
                sdiag=solDetails.get(klId).Diagnostic_Response__c;
                srepair = solDetails.get(klId).Repair_Response__c;
                //scomment=solComment.get(kl.UrlName);
                scomment=solDetails.get(klId).Diagnostic_Notes__c;
                srepairnotes=solDetails.get(klId).Repair_Notes__c;
                parentSolUpdate=solparentMap.get(kl);
                nestedSol=solDetails.get(klId).CSS_Nested_Solutions__c;
                
         // Added by Harsha Ragam for Bug to remove No Access SRT Required in JOb Plan on 09/08/2020     
                FSL_wrapperSolSort fslwrapper=new FSL_wrapperSolSort(selectedsol,solPos,ksol,null,kurlName,
                                                          kl,null,sdiag,scomment,srepair,srepairnotes,
                                                          parentSolUpdate,nestedSol,cssSoldIdMap.get(kl),
                                                          kRepairs,kValidations,selectedsol,null,null);
                fslwrapper.stageName=listWo[0].Process_Step__c; 
                wrapperSolList.add(fslwrapper);
                // End of Changes by Harsha Ragam 09/08/2020

            }
            
            system.debug('***solname**'+solname);
            system.debug('***nameList**'+nameList);
            // wrapperSolList.add(new wrapperSol(nameList,ksol));
            system.debug('***wrapperSolList***'+wrapperSolList);
        }        
        wrapperSolList.sort();
        return wrapperSolList;
    } // end of fetching knowledge articles,solutions method by Mallika.
    
    /*
Method to update related solution from Knowledge Accordian by passing solution id,comment,Diagnostic response
Author: Mallika P.
*/
    @AuraEnabled    
    Public static void solUpdate(id solutionId,string repairnotes,string repairresponse,String workOrderId,
                                 List<String> solComps, List<String> deSolComps, 
                                 List<FSLSolCompWrappers.CSSCompPartOptionsWrp> selectedParts, List<FSLSolCompWrappers.CSSCompPartOptionsWrp> deSelectedParts,
                                 List<FSLSolCompWrappers.CSSCompsWrp> cssSolWrappers)
    {
        system.debug('workOrderId>>'+workOrderId);
        system.debug('<<repairnotes>>'+repairnotes+'<<repairresponse>>'+repairresponse);
        System.debug('**solutionId**'+solutionId);
        
        // NIN-39: Repair SRT service call - START
        List<FSL_SRT__c> lstRepSRTsToInsert = new List<FSL_SRT__c>();
        List<FSL_SRT__c> lstRepSRTsDB = new List<FSL_SRT__c>();
        Boolean repSRTCall = false;
        
        lstRepSRTsDB  = [SELECT Id, Component_Id__r.Name FROM FSL_SRT__c WHERE Service_Order__c = : workOrderId AND Solution_Number__c = : solutionId];
        
        if(lstRepSRTsDB.size() > 0){
            for(Integer i = 0; i< lstRepSRTsDB.size(); i++){
                if(!solComps.contains(lstRepSRTsDB[i].Component_Id__r.Name)){
                    repSRTCall = true;
                }
            }
        }
        else{
            repSRTCall = true;
        }
        
        if(repSRTCall == true && (repairresponse != '' && repairresponse != 'Repair not performed.')) {
            
            CSS_Solutions__c cssSol =  [select Name,userTimestamp__c,FaultCode__c,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,Diagnostic_Notes__c,
                                     Repair_Notes__c,Repair_Response__c,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c,
                                     FSL_Service_Job__r.Type__c,FSL_Service_Job__r.Status,FSL_Service_Job__r.EVL_Stage__c
                                     from CSS_Solutions__c where Id =:solutionId]; 
            
            WorkOrder woRec = [SELECT Id, Asset.Make__c, Asset.Model__c, Asset.Equipment_Id__c, Asset.Engine_Family_Code__c, Asset.Engine_Family__c, Asset.Service_Model__c, WorkOrderNumber FROM WorkOrder WHERE Id=:workOrderId];
            FSLDiagSRTREPWrappers respREP = FSLSRTIntegrationHelperCls.runRepairSRTInterface(woRec, 'REP', cssSol.Name, cssSol.Id, solComps);
            
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
                        if(!cr.Assignment.equalsIgnoreCase('Diagnostic') && !cr.Assignment.equalsIgnoreCase('Unlisted')&& !cr.Assignment.equalsIgnoreCase('Not Claimable') && !cr.Assignment.equalsIgnoreCase('Not Applicable')) {
                            boolean srtselect = false;
                            if(cr.Assignment.equalsIgnoreCase('PRIMARY')) {
                                srtselect = true;
                            }
                            if(cr.SRTAccessCode == 'R') {
                                booleanR = TRUE;
                            }
                            fsrt = new FSL_SRT__c(
                                Name = String.isNotBlank(cr.SRTDetails)?cr.SRTDetails:'N/A', 
                                SRT_ID__c = cr.SRTDetails,
                                SRT_Quantity__c = cr.SRTQuantity,
                                SRT_Time__c = cr.SRTTime,
                                Use_R_Time__c = booleanR,
                                SRT_Access_Code__c = cr.SRTAccessCode,
                                SRT_Title__c = String.isNotBlank(cr.SRTTitle)?cr.SRTTitle:cr.SRTMessage, 
                                Access_Code_B__c = (cr.AccessCodeB!=null?Decimal.valueOf(cr.AccessCodeB):null),
                                Access_Code_C__c = (cr.AccessCodeC!=null?Decimal.valueOf(cr.AccessCodeC):null),
                                Step_Id__c = cr.VerifyRepeatValue.Step.StepId,
                                Access_Code_R__c = (cr.AccessCodeR!=null?Decimal.valueOf(cr.AccessCodeR):null),
                                Access_Code_A__c = (cr.AccessCodeA!=null?Decimal.valueOf(cr.AccessCodeA):null),
                                SRT_Type__c = cr.VerifyRepeatValue.SRTType,
                                Access_Code_D__c = (cr.AccessCodeA!=null?Decimal.valueOf(cr.AccessCodeD):null),
                                Service_Order__c = workOrderId,
                                Repair_SRTs__c = workOrderId, 
                                Repair_SRTs_Boolean__c = true,
                                Component_Id__c  = FIDs.get(cr.FailureID),
                                Solution_Number__c = solutionId,
                                Type__c = 'Repair',
                                CSS_Fault_Code__c = cssSol.FaultCode__c,
                                Assignment__c = cr.Assignment,
                                SRT_Select__c = srtselect,
                                Step_Description__c = String.join(cr.VerifyRepeatValue.Step.StepDescription, '\r\n')
                            );
                            lstRepSRTsToInsert.add(fsrt);
                        }
                    }
                }
            }
        }
        
        // NIN-39: Repair SRT service call - END

        
        //Call RSW WebService for Dealer. Dealer condition is checked in the EVL_CL_RSW Classs.
        EVL_CL_RSW.buildRSWUpdateClaimReqWrapper(workOrderId);
        
        // NIN-39: Repair SRT service call - START
        if(!lstRepSRTsToInsert.isEmpty()) {
            insert lstRepSRTsToInsert;
        }
        // NIN-39: Repair SRT service call - END
        
        Map<Id, FSL_Parts__c> csps = new Map<Id, FSL_Parts__c>();        
        system.debug('selectedParts size::' + selectedParts.size());
        system.debug('deSelectedParts size::' + deSelectedParts.size());
        if(selectedParts != null && selectedParts.size() > 0)
        {
            for(FSLSolCompWrappers.CSSCompPartOptionsWrp csp : selectedParts)
            {
                system.debug('csp::'+csp);
                //added by vinod 8/21
                if(csp.selectedPart == null) {
                    csp.selectedPart = FALSE;
                }
                csps.put(csp.partOptId, new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = csp.defQty, 
                                                         Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));
            }
        }
        if(deSelectedParts != null && deSelectedParts.size() > 0)
        {
            for(FSLSolCompWrappers.CSSCompPartOptionsWrp csp : deSelectedParts)
            {
                //added by vinod 8/21
                if(csp.selectedPart == null) {
                    csp.selectedPart = FALSE;
                }
                csps.put(csp.partOptId, new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = 1,//csp.defQty, 
                                                         Select__c = FALSE, Replacement_Repair_Reason__c = 'Suggested Parts Based on Failure (GSQ Part)'));// csp.replReason));
            }
        }
        // Starts sadded below if condition to handle save on all rows - by vinod  9/17
        if(cssSolWrappers != null & cssSolWrappers.size() > 0)
        {
            for(FSLSolCompWrappers.CSSCompsWrp csw : cssSolWrappers)
            {
                if(csw.cssSoldOpts != null && !csw.cssSoldOpts.isEmpty())
                {
                    for(FSLSolCompWrappers.CSSCompPartOptionsWrp csp : csw.cssSoldOpts)
                    {
                        if(!csps.containsKey(csp.partOptId))
                        {
                            system.debug('show change>>csp::'+csp);
                            //added by vinod 8/21
                            if(csp.selectedPart == null)
                                csp.selectedPart = FALSE;
                            csps.put(csp.partOptId, new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = csp.defQty, 
                                                                     Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));
                        }
                    }
                }
            }
        }
        
        system.debug('solComps>>'+solComps+':::deSolComps>'+deSolComps);
        system.debug((solComps != null && !solComps.isEmpty()));
        system.debug((deSolComps != null && !deSolComps.isEmpty()));
        List<CSS_Solution_Component__c> solCmpsToUpdate=new List<CSS_Solution_Component__c>();
        if((solComps != null && !solComps.isEmpty()) || (deSolComps != null && !deSolComps.isEmpty()))
        {
            if(solComps != null && !solComps.isEmpty())
            {
                for(String compid : solComps)
                {
                    system.debug('compid>'+compid);
                    solCmpsToUpdate.add(new CSS_Solution_Component__c(id=(Id)compid,Selected_Component__c=true));
                }
            }
        }
        
        if(deSolComps != null && !deSolComps.isEmpty())
        {
            List<CSS_Solution_Component__c> delComps = new List<CSS_Solution_Component__c>();
            for(String compid : deSolComps)
            {
                system.debug('compid>'+compid);
                solCmpsToUpdate.add(new CSS_Solution_Component__c(id=(Id)compid,Selected_Component__c=false));
                delComps.add(new CSS_Solution_Component__c(id=(Id)compid));
            }
            //added by vinod for deleting FSL SRTs
            List<FSL_SRT__c> fsrtsToDel = [select id from FSL_SRT__c where Type__c = 'Repair' AND
                                           Solution_Number__c = :solutionId AND Service_Order__c = :workOrderId];
            if(fsrtsToDel != null && !fsrtsToDel.isEmpty())
            {
                delete fsrtsToDel;
                
            }
            //if(delComps != null && !delComps.isEmpty())
                //delete delComps;
            //Ends
        }
        if(!solCmpsToUpdate.isEmpty())
            update solCmpsToUpdate;
        
        //Sruthi - Moving this logic here to update the GSQ LookUp
        //  Ends sadded below if condition to handle save on all rows - by vinod 
        system.debug('csps to upsert::'+csps);
            if(!csps.isEmpty()) {
                upsert csps.values();
            }
        
        //update css solution details. 
        CSS_Solutions__c cs =  [select Name,userTimestamp__c,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,Diagnostic_Notes__c,
                                Repair_Notes__c,Repair_Response__c,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c,
                                FSL_Service_Job__r.Type__c,FSL_Service_Job__r.Status,FSL_Service_Job__r.EVL_Stage__c
                                from CSS_Solutions__c where Id =:solutionId];  
        cs.Repair_Notes__c=repairnotes;
        cs.Repair_Response__c=repairresponse;
        system.debug('Type:::::::::::'+cs.FSL_Service_Job__r.Type__c);
        //added by sai as part of CT1-400
        if(cs.FSL_Service_Job__r.Type__c == 'Dealer'){
           /* cs.FSL_Service_Job__r.Status = 'Repair';
            cs.FSL_Service_Job__r.EVL_Stage__c = 'Repair';
           system.debug('DealerTestrep'+cs.FSL_Service_Job__r.EVL_Stage__c); */
            Workorder wod = new Workorder();
            wod.Id = workOrderId;
            wod.Status = 'Repair';
            wod.EVL_Stage__c = 'Repair';
          //  wod.EVL_Solution_Marked_Most_Likely__c = false;
            update wod;
        }
       
        update cs; 

        //Sruthi - Moving this Logic here to include Solution Response in Integration call
        //Call RSW WebService for Dealer. Dealer condition is checked in the EVL_CL_RSW Classs.
        EVL_CL_RSW.callRSWFutureCall(workOrderId);
        
    }
    
    // End of Solution update method by Mallika.
    
    // Added Ravi To hide/show Input/Output spec Radio buttons 
    @AuraEnabled
    public static WorkOrder getjobordernumber(string strjobId) {
        return [select id, user__r.id from WorkOrder where id=:strjobId limit 1];//User__c modified by Ravi   
    }
    
    /* 
* @Author - Rajashekar Nallapati
* @Date - 06/26/2019
* @Method - getWorkOrderRecordType
* @Argument - String Type of WorkOrder Id
* @Purpose - To get the Work order record type 
*/
    @AuraEnabled
    public static String getWorkOrderRecordType(String strWorkOrderId){
        //  system.debug('strWorkOrderId  '+ strWorkOrderId);
        String strRecordName = [SELECT Id,RecordType.Name 
                                FROM WorkOrder 
                                WHERE id=:strWorkOrderId].RecordType.Name;
        system.debug('strRecordName  '+ strRecordName);
        return strRecordName;
    }
    
    /* 
* @Author - Rajashekar Nallapati
* @Date - 07/10/2019
* @Method - getWorkOrderRecordType
* @Argument - String Type of WorkOrder Id
* @Purpose - To get the Work order record type 
*/
    @AuraEnabled
    public static void insertPerformedRepairAuditEvent(String cssSolutionId, String repairRadio, String comments,String solId) {
        System.debug('repairRadio'+repairRadio);
        System.debug('comments'+comments);
        System.debug('solId'+solId);
        List<CSS_Solutions__c> listObjCSSSolution = [SELECT Id,Name,Solution_Title__c,FaultCode__c, FaultCode__r.Name,
                                                     FSL_Solution_Position__c, Repair_Response__c
                                                     FROM CSS_Solutions__c
                                                     WHERE Id=:cssSolutionId LIMIT 1];
        if(listObjCSSSolution != null && listObjCSSSolution.size() > 0){
            List<CSS_Fault_Code__c> listObjFaultCode =  [SELECT Id,
                                                         (SELECT Id from CSS_Solutions__r)
                                                         FROM CSS_Fault_Code__c
                                                         WHERE Id=:listObjCSSSolution[0].FaultCode__c LIMIT 1];
            Integer size =  listObjFaultCode[0].CSS_Solutions__r.size();
            String rank = listObjCSSSolution[0].FSL_Solution_Position__c+' of '+ String.valueOf(size);
            String eventDes = 'Updated verification : '+repairRadio+'\n'+'Comments : '+comments;
            FSL_CumminsUtilities.auditTrailInsert('Event-17',solId,eventDes,listObjCSSSolution[0].FaultCode__r.Name,rank,listObjCSSSolution[0].Repair_Response__c);   
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
        List<CSS_Solutions__c> listObjCSSSolution = [SELECT Id,Name,Solution_Title__c,FaultCode__c, FaultCode__r.Name,
                                                     FSL_Solution_Position__c, Repair_Response__C
                                                     FROM CSS_Solutions__c
                                                     WHERE Id=:cssSolutionId LIMIT 1];
        if(listObjCSSSolution != null && listObjCSSSolution.size() > 0){
            List<CSS_Fault_Code__c> listObjFaultCode =  [SELECT Id,
                                                         (SELECT Id from CSS_Solutions__r)
                                                         FROM CSS_Fault_Code__c
                                                         WHERE Id=:listObjCSSSolution[0].FaultCode__c LIMIT 1];
            Integer size =  listObjFaultCode[0].CSS_Solutions__r.size();
            String rank = listObjCSSSolution[0].FSL_Solution_Position__c+' of '+ String.valueOf(size);
            String eventDes = 'Viewed Solution '+listObjCSSSolution[0].Name+'-'+listObjCSSSolution[0].Solution_Title__c;
            FSL_CumminsUtilities.auditTrailInsert('Event-19',solId,eventDes,listObjCSSSolution[0].FaultCode__r.Name,rank,listObjCSSSolution[0].Repair_Response__c);                   
        }
    }
    
    /* 
* @Author - Rajashekar Nallapati
* @Date - 07/11/2019
* @Method - insertSelectedRootCauseOnRepair
* @Argument -
* @Purpose - 
*/
    @AuraEnabled
    public static void insertSelectedRootCauseOnRepair(String cssSolutionId, List<Id> cssSolutionCompId, String solId) {
        System.debug('cssSolutionCompId'+ cssSolutionCompId);
        System.debug('solId'+ solId);
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
            for(CSS_Solution_Component__c objcssSOlCom :listObjCSSSolutioncomp) {
                rootCause = rootCause + ',' + objcssSOlCom.Name;
            }
            System.debug(rootCause.substring(1));
            listRootCause = rootCause.substring(1);
            listObjCSSSolution = [SELECT Id,Name,Solution_Title__c,FaultCode__c, FaultCode__r.Name,
                                  FSL_Solution_Position__c, Repair_Response__C
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
                FSL_CumminsUtilities.auditTrailInsert('Event-18',solId,eventDes,listObjCSSSolution[0].FaultCode__r.Name,rank,listObjCSSSolution[0].Repair_Response__c);
            }
        } catch(Exception ex) {
            
        }
    }
    
    //added by sriprada
    @AuraEnabled
    public static void changeRecord(string workId,string solId)
    {
      System.debug('CHANGE REC:::'+solId);
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c, RecordTypeId,Type__c from WorkOrder where id=: workId];//Piyush added Type in query for VGRS2-16
        if(wo1.size() > 0)
        {
            if(wo1[0].Process_Step__c == 'Repair')
            {
                recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
                    .get('SolutionT_D').getRecordTypeId();
                // string processStep = 'Triage & Diagnosis';
                //wo1[0].Process_Step__c = processStep;
            }
            //wo1[0].Process_Step__c    = 'Triage & Diagnosis';
        }
        //  Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
        //     .get('SolutionT_D').getRecordTypeId();
        
        WorkOrder wo        = new WorkOrder();
        wo.Id               = workId;
        wo.Process_Step__c      = 'Triage & Diagnosis';
        wo.Status               = 'Triage & Diagnosis'; 
        wo.EVL_Solution_Marked_Most_Likely__c = false;
        
        //wo.RecordTypeId     = recdtypeId;
        Profile po = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        UserRole userRole = [select Id,Name from UserRole WHERE Id =: UserInfo.getUserRoleId()];//Added by Piyush for VGRS2-16 11/30
        
        if((po != null && po.Name != null && !po.Name.containsIgnoreCase('dealer') && wo1[0].Type__c != 'Dealer')
           || (userRole != NULL && userRole.Name != NULL && userRole.Name.EqualsIgnoreCase('Factory') && wo1[0].Type__c != 'Dealer') ) //Added by Piyush for VGRS2-16 11/30
        { 
        wo.RecordTypeId     = recdtypeId;                 
        system.debug('wo.RecordTypeId ' + wo.RecordTypeId);
        }
        wo.Repair_Solution__c  = solId;
        system.debug('to update wo '+wo);        
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            update wo;   
            system.debug('RecordType'+recdtypeId);
        }
    }
  // Added by Sriprada for VGRS2-6 for displaying fault code overview for Dealer jobs within the EVL_RepairDisplaySolution.cmp - 10/20/2021 
     @AuraEnabled
     Public static string getFCOverview(String workOrderId)
    {
        list<workOrder> listWo = new list<workOrder>();
       // list<FSL_Fault_Code__c> listFault = new list<FSL_Fault_Code__c>();
        list<CSS_Fault_Code__c> listFault = new list<CSS_Fault_Code__c>();
        FSL_FCOverview_Wrapper wrap = new FSL_FCOverview_Wrapper();
        string esnCode ;
        string faultName ;
        string jsonResponse ; 
        string FCName; 
        system.debug('workOrderId '+workOrderId);
        listWo = [select id,Asset.Name from workorder where id =:workOrderId];
        
        //Sruthi - To pull the FaultCodeID from Service Order Extension
        
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: listWo[0].Id];
  
         if(listWo.size()>0 && woExtList.size() > 0)
        {
            esnCode = listWo[0].Asset.Name;
            if(woExtList[0].FaultCodeId__c != null)
            {
                listFault = [select id,name from CSS_Fault_Code__c where Id=:woExtList[0].FaultCodeId__c];        
                system.debug('FaultCodeID is:'+woExtList[0].FaultCodeId__c);
            }
            if(listFault.size()>0)
            {
                faultName = listFault[0].name;
            }
        }
        if(string.isNotBlank(esnCode) && string.isNotBlank(faultName))
        {
            //-----CT3-44 ----
            //Modified By: Dinesh Yadav, 24 Sept 2020 For QSOL launguage.
            System.debug(' ::::: ' + UserInfo.getLanguage()) ;
            CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
            system.debug('csAccountLang :: '+csAccountLang);
            string strCSS_QsolLanguage ='en';
            if(csAccountLang != null){
                if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
                    strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
            }
            
            wrap = FSL_CL_QSOLIntegrations.getOverViewCall(esnCode,faultName,strCSS_QsolLanguage);
            /* ------------End * CT3-44 -----*/
        }
        System.debug('jsonResponse  :'+jsonResponse);        
        //return jsonResponse;
        return JSON.serialize(wrap);
    } 
    
       @AuraEnabled
    public static Boolean fetchFCSolData(String recordId){
        Boolean fcCount;
        WorkOrder[]  wo = [Select Id from WorkOrder where id =: recordId LIMIT 1];
        //Sruthi - To pull the FaultCodeID from Service Order Extension
        
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: wo[0].Id];
        if(wo.size() >= 0 && woExtList.size() > 0 && woExtList[0].FaultCodeId__c != null){
            fcCount = true;
                } 
        else{
            fcCount = false;
        }
        return fcCount;
    }// Code ends here
}