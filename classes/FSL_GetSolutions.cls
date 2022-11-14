/***********************************************************************
Name: FSL_GetSolutions
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
public class FSL_GetSolutions {
    
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
        
        //-----CT3-45 ----
        //Modified By: Dinesh Yadav, 9 Oct 2020, To View the Solutions content in the language based on user's Language.
        string strLoggedInUserLanguage =UserInfo.getLanguage();
        if(Test.isRunningTest() == false){
            knowledgeList = [Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav where PublishStatus ='Online' and UrlName =:solname and Language =:strLoggedInUserLanguage];
            if(knowledgeList != null && knowledgeList.size() >0){
                //if knowledge found with logged-in user language then return the list. 
            }
            else{
                //default should be en_US 
                strLoggedInUserLanguage ='en_US';
                knowledgeList = [Select Id,UrlName,Validations__c,Verification__c,Repairs__c from Knowledge__kav where PublishStatus ='Online' and UrlName =:solname and Language =:strLoggedInUserLanguage];
            }
        }
        system.debug('knowledgeList :: '+knowledgeList);
        system.debug('strLoggedInUserLanguage :: '+strLoggedInUserLanguage);
        return knowledgeList;
    }
    
    /* method to fetch related knowledge articles,solutions by passing service order id
    Author :Mallika P
    */
    @AuraEnabled
    Public static list<FSL_wrapperSolSort> getSolknowledge(String workOrderId) {
        
        set<string> solNameSET = new set<string>();
        List<string> SolutionName = new List<string>();
        List<string> KnwSolutionName = new List<string>();
        list<workOrder> listWo = new list<workOrder>();
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        list<FSL_wrapperSolSort> wrapperSolList=new list<FSL_wrapperSolSort>();
        //Commenting Road 7 Changes
        //set<String> setParentId = new set<String>(); //Added by Murali for Road 7 - 10/27/2021
        set<String> setParentId = new set<String>(); //Added by Murali for Road 106/107 - 11/29/2021
        system.debug('workOrderId '+workOrderId);
        listWo = [SELECT Id, WorkOrderNumber, Repair_Solution__c, selectedsolution__c, Asset.Name
                  FROM WorkOrder
                  WHERE Id =:workOrderId
                 ];
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
        string csssolId='';
        string diagTargetTimeOrMsg='';
        boolean checkSol;
        Map<string,string> solMap=new Map<string,string>();
        Map<string,string> solparentMap=new Map<string,string>();
        Map<string,CSS_Solutions__c> solDetails=new Map<string,CSS_Solutions__c>();
        List<CSS_Solutions__c> defSol=new List<CSS_Solutions__c>();
        List<CSS_Fault_Code__c> fcList =new List<CSS_Fault_Code__c>();
        List<CSS_Solutions__c> solutionCheck = new List<CSS_Solutions__c>();

        String kurlName='';
        // Id kurlName=''; // Added by Bharat - changed from String to Id
        String solPos;
        Map<string,CSS_Solutions__c> solMapSort=new Map<string,CSS_Solutions__c>();
        Map<string,String> KnwSolMap =new Map<string,String>();
        Map<id,string> cssKnwSolId = new Map<id,string>();
        // string kValidations='';
        string ksol='';
        //added by vinod on 5-22
        Map<String, Id> cssSoldIdMap=new Map<String, Id>(); 
        if(listWo.size() > 0) {
            //For defaulting on first solution when no solution is performed and also making all accordions closed when any of the solution is performed -- added by Sriprada
            
            //Sruthi - To pull the FaultCodeID from Service Order Extension
            
            List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
            woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: listWo[0].Id];
            if(woExtList.size() > 0 && woExtList[0].FaultCodeId__c != null){
                
                List<CSS_Solutions__c> defaultSol = [Select id, Name, FaultCode__c, FaultCode__r.Solution_Performed__c,Solution_Title__c,FSL_Solution_Position__c,  userTimestamp__c from CSS_Solutions__c WHERE FaultCode__c =:woExtList[0].FaultCodeId__c];
            //CT3-334, Dinesh Yadav, Fixed issue related to update inside for loop.
            Boolean chkCSSSolUpd = false;
            for(CSS_Solutions__c sol: defaultSol){
                if(sol.userTimestamp__c != null){
                    sol.FaultCode__r.Solution_Performed__c = true;
                    system.debug('BooleanCheck::::'+sol.FaultCode__r.Solution_Performed__c);
                    chkCSSSolUpd = true;
                }
                system.debug('SolutionListUpdate:::'+defaultSol+'----'+sol.FaultCode__c+'-----'+sol.FaultCode__r.Solution_Performed__c);
            }

            //CT3-334, Dinesh Yadav
            if(chkCSSSolUpd == true){
                update defaultSol;
            }

            if(defaultSol.isEmpty() == false && defaultSol[0].FaultCode__r.Solution_Performed__c != true && defaultSol[0].userTimestamp__c == null){
                string solposition = string.valueOf(defaultSol[0].FSL_Solution_Position__c);
                String solsubString = solposition.substringAfter('.');
                if(solsubString.length() > 0) {
                    defSolName ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +defaultSol[0].FSL_Solution_Position__c+'  '+defaultSol[0].Solution_Title__c;
                    checkSol = false;
                    system.debug('**defSolName'+defSolName);
                } 
                else {
                    defSolName = defaultSol[0].FSL_Solution_Position__c+'\r\t\r\t\r '+defaultSol[0].Solution_Title__c;
                    system.debug('**defSolName'+defSolName);
                    
                    checkSol = false;
                }
            }
           
       /*     for(CSS_Fault_Code__c fc :[SELECT id,name,(Select Id,Name,userTimestamp__c from CSS_Solutions__r) FROM CSS_Fault_Code__c where Service_Order__c =: listWo[0].id ]){
                system.debug('FCList::::'+fc);
                if(fc.CSS_Solutions__r.size() > 0){
                    for(CSS_Solutions__c sol: fc.CSS_Solutions__r){
                        system.debug('SolRelatedRecords:::'+sol);
                        system.debug('UserTimeStamp:::'+sol.userTimestamp__c);
                        if(sol.userTimestamp__c == null){
                         fc.Solution_Performed__c = true;
                        } else{
                            fc.Solution_Performed__c = false;
                        }
                    }
                   

                }
            update fc;
            }*/
            
            system.debug('**defSol**'+defSol);
            for(CSS_Solutions__c sol :[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Notes__c,Diagnostic_Response__c,
                                       userTimestamp__c,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c,DiagTargetTime__c,TargetMessage__c FROM CSS_Solutions__c
                                           WHERE FaultCode__c =:woExtList[0].FaultCodeId__c ORDER BY FSL_Solution_Position__c ])
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
                cssKnwSolId.put(sol.Id,sol.Name);
                SolutionName.add(sol.Name+'-'+sol.Id);
                KnwSolutionName.add(sol.Name);
                solMap.put(sol.id,solname); //contains map with solution name,related solname(concatinated sol name)
                solMapSort.put(sol.id,sol);// sorting map  by position
                solDetails.put(sol.id,sol); // map contains solution name and solution record
                system.debug('**solMapSort'+sol.id+'-'+position);
            }
           
            // fetching lowest unperformed solution
            list<CSS_Solutions__c> childSol = [SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,CSS_Nested_Solutions__c,
                                                   CSS_Nested_Solutions__r.userTimestamp__c,FSL_PositionOfSolution__c,DiagTargetTime__c,TargetMessage__c FROM CSS_Solutions__c WHERE FaultCode__c =:woExtList[0].FaultCodeId__c ORDER BY FSL_PositionOfSolution__c];
            
            //to verify parent solution is performed or not
            for(CSS_Solutions__c csol:childSol) {
                if(csol.CSS_Nested_Solutions__c != null) {
                    //Road 101 - Commenting Road 7 & 56 changes by Murali
                    //setParentId.add(csol.CSS_Nested_Solutions__c); 
                    //Road 106/107 - Added by Murali 11/29/2021
                    setParentId.add(csol.CSS_Nested_Solutions__c); 
                    solparentMap.put(csol.Id,string.valueof(csol.CSS_Nested_Solutions__r.userTimestamp__c));
                }
            }
            system.debug('**solparentMap**'+solparentMap);
            
           /* Commented by Sriprada inorder to remove the defaulting logic of least unperformed solution
            * 
           defSol=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,FaultCode__r.Solution_Performed__c,Diagnostic_Response__c,userTimestamp__c,CSS_Nested_Solutions__r.userTimestamp__c,FSL_PositionOfSolution__c,DiagTargetTime__c,TargetMessage__c  
                    FROM CSS_Solutions__c WHERE FaultCode__c =:listWo[0].FaultCodeId__c AND FaultCode__r.Solution_Performed__c != true AND userTimestamp__c =null ORDER BY FSL_PositionOfSolution__c limit 1];
            system.debug('**defSol**'+defSol);
            
            if(defSol.size() > 0 ) {
                system.debug('**defSolName'+defSolName);
                string solposition = string.valueOf(defSol[0].FSL_Solution_Position__c);
                String solsubString = solposition.substringAfter('.');
                if(solsubString.length() > 0) {
                    defSolName ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +defSol[0].FSL_Solution_Position__c+'  '+defSol[0].Solution_Title__c;
                      checkSol = false;
                    system.debug('**defSolName'+defSolName);
                } 
                else {
                    defSolName = defSol[0].FSL_Solution_Position__c+'\r\t\r\t\r '+defSol[0].Solution_Title__c;
                    system.debug('**defSolName'+defSolName);

                     checkSol = false;
                }
            } else {
                //if all solutions are performed default will be last performed solution
                defSol=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,
                        LastModifiedDate FROM CSS_Solutions__c WHERE userTimestamp__c !=null AND FaultCode__c =:listWo[0].FaultCodeId__c ORDER BY LastModifiedDate desc limit 1];
                if(defSol <> null && defSol.size() > 0)
                  //  defSolName = defSol[0].FSL_Solution_Position__c+'\r\t\r\t\r '+defSol[0].Solution_Title__c;
                system.debug('**defSol**'+defSol);
                
            } 
            ends here --- Sriprada */
            
            system.debug('**defSolName**'+defSolName);
            //added by Sriprada for displaying the navigated solution from repair
            string defRepairSol ;
            list<CSS_Solutions__c> solRepair = new list<CSS_Solutions__c>();            
            solRepair=[SELECT id,name,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Response__c,userTimestamp__c,DiagTargetTime__c,TargetMessage__c,
                       LastModifiedDate FROM CSS_Solutions__c WHERE id =:listWo[0].Repair_Solution__c limit 1];
            system.debug('$$$ solRepair ' +solRepair);
            if(solRepair.size() > 0)
            {
                String position = solRepair[0].FSL_Solution_Position__c;
                String subString = position.substringAfter('.');
                system.debug('**subString'+subString);
                
                if(subString.length() > 0) {
                    defRepairSol ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t'+solRepair[0].FSL_Solution_Position__c+'  '+solRepair[0].Solution_Title__c;
                } 
                else {
                    defRepairSol = solRepair[0].FSL_Solution_Position__c+'\r\t\r\t\r '+solRepair[0].Solution_Title__c;
                }
            }
            /*if(solRepair.size() > 0 && string.isNotBlank(solRepair[0].Solution_Title__c) && solRepair[0].Solution_Title__c != null)
            {
              defRepairSol = solRepair[0].FSL_Solution_Position__c + +'\r\t\r\t\r '+solRepair[0].Solution_Title__c;
            } */
            system.debug('Solution from repair##:'+defRepairSol);//code ends here --- Sriprada
            Map<String,String> urlKnwMap = new Map<String,String>();
            /*
            List<Knowledge__kav> knwRecords = [Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav 
                                               where UrlName IN:cssSoldIdMap.keySet()];
            system.debug('KnwSize:'+knwRecords.size());
            for(Knowledge__kav kl:knwRecords)
            {
                urlKnwMap.put(kl.UrlName,kl.Verification__c);
            }
            */
            
            list<Knowledge__kav> knwRecords = new list<Knowledge__kav>();
        
            //-----CT3-45 ---- 
            //Modified By: Dinesh Yadav, 9 Oct 2020, To View the Solutions content in the language based on user's Language.
            string strLoggedInUserLanguage =UserInfo.getLanguage();
            if(Test.isRunningTest() == false){
                knwRecords = [Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav 
                                                where PublishStatus ='Online' and UrlName IN:cssSoldIdMap.keySet() and Language =:strLoggedInUserLanguage];
                if(knwRecords != null && knwRecords.size() >0){
                    //if knowledge found with logged-in user language then return the list. 
                }
                else{
                    //default should be en_US
                    strLoggedInUserLanguage ='en_US';
                    knwRecords = [Select Id,UrlName,Title,Validations__c,Verification__c,Repairs__c from Knowledge__kav 
                                                where PublishStatus ='Online' and UrlName IN:cssSoldIdMap.keySet() and Language =:strLoggedInUserLanguage];
                }
            }
            system.debug('knwRecords:: '+knwRecords+ '  :KnwSize:'+knwRecords.size());
            system.debug('strLoggedInUserLanguage :: '+strLoggedInUserLanguage);
            
            if(knwRecords != null && knwRecords.size() >0){
                for(Knowledge__kav kl:knwRecords)
                {
                    urlKnwMap.put(kl.UrlName,kl.Verification__c);
                }
            }
            // fetching knowledge articles based on solution name
            // changed query variable by vinod yelala - 5-22
            //Commenting Road 7 Changes
            //boolean isParent = false; // <!-- Road 101 - Commenting Road 7 & 56 changes by Murali
            boolean isParent = false; // Road 106/107 by Murali 11/29/2021
            for(String klName:SolutionName)
            {
                String kl = klName.subStringBefore('-');
                String klId = klName.substringAfter('-');
                
                if(urlKnwMap.get(kl) != null && urlKnwMap.get(kl) !=''){
                    kVerification = urlKnwMap.get(kl);
                    String verification = listWo[0].Asset.Name+'-'+listWo[0].Id;
                    kVerification = kVerification.replace('{*#SnNo#*}',verification);
                }
                kurlName=solDetails.get(klId).id;
                //kurlName=klId;
                system.debug('kurlName**:'+kurlName);
                ksol=solMap.get(klId);
                system.debug('kurlName**:'+ksol);
                solPos = solMapSort.get(klId).FSL_Solution_Position__c;
                system.debug('kPosition**:'+solPos);
                sdiag=solDetails.get(klId).Diagnostic_Response__c;
                //scomment=solComment.get(kl.UrlName);
                scomment=solDetails.get(klId).Diagnostic_Notes__c;
                parentSolUpdate=solparentMap.get(klId);
                nestedSol=solDetails.get(klId).CSS_Nested_Solutions__c;
                //isParent = setParentId.contains(klId); Commenting for Road 7
                //Road 106/107 by Murali 11/29/2021
                isParent = setParentId.contains(klId);
               // Modified by Sailaja Guntupalli to display the target message when its not null -CT3-34
                if(solDetails.get(klId).TargetMessage__c != null) {
                    diagTargetTimeOrMsg = solDetails.get(klId).TargetMessage__c;
                } else if(solDetails.get(klId).DiagTargetTime__c != null) {
                    diagTargetTimeOrMsg = solDetails.get(klId).DiagTargetTime__c + ' Hours';
                } 

                csssolId = cssKnwSolId.get(klId);
                system.debug('kSolId**:'+klId);
                //Road 106/107 by Murali adding isParent 11/29/2021
                /*wrapperSolList.add(new FSL_wrapperSolSort(null,solPos,ksol,kVerification,kurlName,
                                                          kl,defSolName,sdiag,scomment,null,null,
                                                          parentSolUpdate,nestedSol,klId,
                                                          null,null,defRepairSol,diagTargetTimeOrMsg)); //defRepairSol -- added by Sriprada : Removed isParent for Road 7 */
                wrapperSolList.add(new FSL_wrapperSolSort(null,solPos,ksol,kVerification,kurlName,
                                                          kl,defSolName,sdiag,scomment,null,null,
                                                          parentSolUpdate,nestedSol,klId,
                                                          null,null,defRepairSol,diagTargetTimeOrMsg,isParent));
            }
            system.debug('***solname**'+solname);
            system.debug('***SolutionName**'+SolutionName);
            //wrapperSolList.add(new wrapperSol(nameList,ksol));
            system.debug('***wrapperSolList***'+wrapperSolList);
            
            //Sruthi - Adding condition to prevent unwanted update on WO when the Repair solution is already NULL
            if(listWo[0].Repair_Solution__c != NULL){
                listWo[0].Repair_Solution__c = null; 
                update listWo; // to reset the Repair_Solution__c inorder to execute defaulting logic based on Solution performed -- Sriprada
            }
        }        
        }        
        wrapperSolList.sort();
        return wrapperSolList;
    } // end of fetching knowledge articles,solutions method by Mallika.
    
    @AuraEnabled
    public static boolean getAccSRTCheck(Id solId) {  
        system.debug('Inside my Method**'+solId); 
        css_solutions__c solutions =  
                [SELECT Id, No_Access_SRT_required__c FROM css_solutions__c Where Id= :solId];
                system.debug('solutions**'+solutions);
        List<FSL_SRT__c> srts = new List<FSL_SRT__c>();
        srts = [SELECT Id,type__c from fsl_srt__c where solution_number__c = :solId and type__c IN ('Diag Access','Repair Access') LIMIT 1];
        system.debug('srts**'+srts);        
        
        if((solutions!=null && solutions.No_Access_SRT_required__c == true) || (srts!=null && srts.size()>0)) {
                system.debug('FALSE');
                return false;
        } else {
                system.debug('TRUE');
                return true;
        }
                
    }
    /* Author - Sruthi
     * Method to determine the Product Mileage and Measure on the work order
  */
    @AuraEnabled
    public static string validateProductOnWO(string workOrderId){
        
        WorkOrder woObj = [Select Id, Mileage__c, CSS_Hours__c, Application__c from WorkOrder where Id =: workOrderId LIMIT 1];
        
        //Assign App Code by splitting based on '-' and derive appflag to populate mileage and mileage measure afterwards.
        String AutomotiveAppFlag;
        if(woObj.Application__c != null  && woObj.Application__c.contains('-')) {
            String[] AppCode = woObj.Application__c.split('-');
            if(AppCode != null && AppCode.size()>0){
                switch on AppCode[0].trim() {
                    when '130','210','220','310','320','410'{
                        AutomotiveAppFlag = 'Y';
                    }
                    when else{
                        AutomotiveAppFlag = 'N';
                    }
                }
            }
        } 
        
        if(AutomotiveAppFlag == 'Y' && (woObj.Mileage__c == NULL || woObj.Mileage__c < 0)){
            return 'mileagerror';
        }
        else if(AutomotiveAppFlag == 'N' && (woObj.CSS_Hours__c == NULL || woObj.CSS_Hours__c < 0)){
            return 'hourserror';
        }
        else{
            return 'success';
        }
        
    }
    /* Author - Sruthi
     * Method to determine the Product Mileage and Measure on the work order
    */
    @AuraEnabled
    public static void updateWO(String workOrderId, Double hours, Double mileage){
        
        WorkOrder wo = new WorkOrder(Id = workOrderId);
        if(hours != NULL){
            wo.CSS_Hours__c = hours;
        }
        if(mileage != NULL){
            wo.Mileage__c = mileage;
        }
        update wo;
    }
    /*
    Method to update related solution from Knowledge Accordian by passing solution id,comment,Diagnostic response
    Author: Mallika.
    */
    //added workOrderId, solComps by vinod for diag srt integration
    
    @AuraEnabled    
    Public static boolean solUpdate(id solutionId,string responseValue,string commentValue, String workOrderId, List<String> solComps, List<String> deSolComps, 
                                 List<FSLSolCompWrappers.CSSCompPartOptionsWrp> selectedParts, List<FSLSolCompWrappers.CSSCompPartOptionsWrp> deSelectedParts,
                                 List<FSLSolCompWrappers.CSSCompsWrp> cssSolWrappers)
    {
        //return null;
        system.debug('workOrderId>>'+workOrderId);
        system.debug('cssSolWrappers>>'+cssSolWrappers);
        //system.debug('partIdReplsRsn>>'+partIdReplsRsn);
        system.debug('selectedParts>>'+selectedParts);
        system.debug('Solution component list:'+solComps);
        
        EVL_CL_RSW.FIRE_RSW_CALL = FALSE;
        //Starts--added logic for diagnostic SRTs - Added by Vinod Yelala
        WorkOrder wo = [SELECT Id, Asset.Make__c, Asset.Model__c, Asset.Equipment_Id__c, Asset.Engine_Family_Code__c, Asset.Engine_Family__c, Asset.Service_Model__c, WorkOrderNumber FROM WorkOrder WHERE Id=:workOrderId];
        List<FSL_SRT__c> FsrtsDiag = new List<FSL_SRT__c>();
        // VGRS2-677: Ramya added duplicate filtr logic
        FsrtsDiag = [SELECT Id,SRT_ID__c,Name,Step_Id__c,Component_Id__c FROM FSL_SRT__c WHERE Service_Order__c = : workOrderId AND Solution_Number__c = : solutionId AND Type__c = 'Diagnosis'];
        List<FSL_SRT__c> FsrtsRep = new List<FSL_SRT__c>();
        FsrtsRep  = [SELECT Id,SRT_ID__c,Name,Step_Id__c,Component_Id__c FROM FSL_SRT__c WHERE Service_Order__c = : workOrderId AND Solution_Number__c = : solutionId AND Type__c = 'Repair'];
        List<FSL_SRT__c> Dsrts = new List<FSL_SRT__c>();
        List<FSL_SRT__c> Rsrts = new List<FSL_SRT__c>();
        
        CSS_Solutions__c cs = [SELECT Id, Name, FaultCode__c, FaultCode__r.Name, userTimestamp__c, Solution_Title__c, FSL_Solution_Position__c, Diagnostic_Response__c, Diagnostic_Notes__c, 
                               CSS_Nested_Solutions__c, CSS_Nested_Solutions__r.userTimestamp__c,No_Access_SRT_required__c,FSL_Service_Job__r.Type__c,FSL_Service_Job__r.Status,FSL_Service_Job__r.EVL_Stage__c //CT1-401 added by sai
                               FROM CSS_Solutions__c WHERE Id =:solutionId]; //CT3-26, added field 'No_Access_SRT_required__c'
        system.debug('SolutionDetails**'+cs);
        system.debug('FsrtsDiag**'+FsrtsDiag);
        system.debug('FsrtsRep**'+FsrtsRep);
        //CT3-26:START
        system.debug('resval in Class**'+responseValue);
        boolean setErrorMsg = true;
        if((responseValue == 'Most likely the solution. Repair recommended.'|| responseValue == 'Not the solution. Continue troubleshooting.')){
        List<FSL_SRT__c> srts = new List<FSL_SRT__c>();
       srts = [SELECT Id,type__c from fsl_srt__c where solution_number__c = :solutionId and type__c IN ('Diag Access','Repair Access') LIMIT 1];
       system.debug('srts**'+srts);        
       if((cs!=null && cs.No_Access_SRT_required__c == true) || (srts!=null && srts.size()>0))
       setErrorMsg = true;
                else 
                    setErrorMsg = false;
        }
        system.debug('setErrorMsg**'+setErrorMsg);
        if(setErrorMsg == true){ //CT3-26:END
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
        //VGRS2-677: Ramya - Corrected SRTs to add
        boolean isExistingDSRT = false;
        boolean isExistingRSRT = false; 
        if(responseValue != 'Could not perform the solution verification') {
            FSLDiagSRTIntegrationWrappers.DiagnosticSRTResp resp = FSLSRTIntegrationHelperCls.runDiagnosticSRTInterface(wo, 'VER', cs.Name);
            if(resp != null) {
                if (resp.DataArea.CaseResponse != null) {
                    List<FSLDiagSRTIntegrationWrappers.DiagSRTDataArea> CaseResponse = resp.DataArea.CaseResponse;
                    FSL_SRT__c fsrt;
                    for(FSLDiagSRTIntegrationWrappers.DiagSRTDataArea cr : CaseResponse) {
                        System.debug('$$$ cr' + cr.Assignment);
                        if(cr.Assignment != null){
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
                                //VGRS2-677: Ramya added duplicate fitler logic
                                isExistingDSRT = false;
                              for(FSL_SRT__c dsrt :  FsrtsDiag){
                                    if(dsrt.SRT_ID__c == cr.SRTID && dsrt.Step_Id__c == cr.VerifyRepeatValue.Step.StepId){
                                        isExistingDSRT = true;
                                        break;
                                    }
                                }
                                if(isExistingDSRT == false) {
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
            }
        }
        
        /*Start: Vinod for Repair API call*/
        //VGRS2-677: Ramya - Corrected SRTs to add 
        // Below Get Repair SRT is also used for FTR. The same code copied to FSL_CL_FTRUtility.runRepairSRTInterfaceAndInsertSRT. Any changes made in below logic also needs to updated to FSL_CL_FTRUtility
        if(responseValue == 'Most likely the solution. Repair recommended.') {
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
                            isExistingRSRT = false;
                            for(FSL_SRT__c rsrt :  FsrtsRep){
                                if(rsrt.SRT_ID__c == cr.SRTDetails && rsrt.Step_Id__c == cr.VerifyRepeatValue.Step.StepId &&  rsrt.Component_Id__c == FIDs.get(cr.FailureID)){
                                    isExistingRSRT = true;
                                    break;
                                }
                            }
                            if(isExistingRSRT==false) {
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
                                    Repair_SRTs__c = workOrderId, // Bharat - Commenting as it is moved to PB on Repair Successful
                                    Repair_SRTs_Boolean__c = true,
                                    Component_Id__c  = FIDs.get(cr.FailureID),
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
            if(commentValue!='' && commentValue!=null){
              cs.Diagnostic_Notes__c=commentValue;
            }
            if(cs.userTimestamp__c == null && responseValue !=null){
                cs.userTimestamp__c=system.Now();
            }
        }
        else if(cs.CSS_Nested_Solutions__c !=null && cs.CSS_Nested_Solutions__r.userTimestamp__c !=null){
            cs.Diagnostic_Response__c=responseValue;
            if(commentValue!='' && commentValue!=null){
              cs.Diagnostic_Notes__c=commentValue;
            }
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
            //Call 
            EVL_CL_RSW.callRSWFutureCall(workOrderId);
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
     /*   system.debug('Type:::::::::::'+cs.FSL_Service_Job__r.Type__c);
        
        update cs; */
        
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
             //By Priyanka  Ct1-504 
               if(!addedParts.contains(csp.partOptId))
                {
                     csps.add(new FSL_Parts__c(Id = csp.partOptId, Part_Quantity__c = csp.defQty, 
                                          Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));
                addedParts.add(csp.partOptId);
                }
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
          Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));*/
          addedParts.add(csp.partOptId);
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
              Select__c = csp.selectedPart, Replacement_Repair_Reason__c = csp.replReason));*/
              addedParts.add(csp.partOptId);
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
        List<FSL_Parts__c> selectedprts = new List<FSL_Parts__c>();
        for(FSL_Parts__c obj : csps)
        {
            if(count<90)
            {
                if(csps[0].Select__c == true){
                    selectedprts.add(obj);
                    //FSL_CL_getEPRFlag.getEPRFlagTriggerHelper(csps);
                    system.debug('Parts List:'+csps[0].id);
                    count++;
                }
            }
        }
        FSL_CL_getEPRFlag.getEPRFlagTriggerHelper(selectedprts);
        //return false;
    }
        //added by sai as part of CT1-401
        if(cs.FSL_Service_Job__r.Type__c == 'Dealer'){
           /* cs.FSL_Service_Job__r.Status = 'Triage & Diagnosis';
            cs.FSL_Service_Job__r.EVL_Stage__c = 'Triage & Diagnosis';
           system.debug('DealerTest'+cs); */
            Workorder wod = new Workorder();
            wod.Id = workOrderId;
            wod.Status = 'Triage & Diagnosis';
            wod.EVL_Stage__c = 'Triage & Diagnosis';
          //  wod.EVL_Solution_Marked_Most_Likely__c = true;
            update wod;
        }
        update cs;
        EVL_CL_RSW.FIRE_RSW_CALL = TRUE;
    return setErrorMsg;
    }
    
    //added by Mallika
    @AuraEnabled
    public static void continueToRepair(string workId,string solId) {
        System.debug('Continue To Repair:::'+solId);
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        String solname = '';
        
        wo1 = [Select id,Process_Step__c, RecordTypeId, Type__c from WorkOrder where id=: workId]; //Piyush added Type in query for VGRS2-16
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
        wo.EVL_Solution_Marked_Most_Likely__c = true;
        
        //For Dealers we are using a Single record type for Work Orders. 
        //So we are adding below Conditions for Distributors.

        //wo.RecordTypeId     = recdtypeId;
        Profile po = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()]; 
        UserRole userRole = [select Id,Name from UserRole WHERE Id =: UserInfo.getUserRoleId()];//Added by Piyush for VGRS2-16 11/30
        
        if((po != null && po.Name != null && !po.Name.containsIgnoreCase('dealer') && wo1[0].Type__c != 'Dealer') 
           || (userRole != NULL && userRole.Name != NULL && userRole.Name.EqualsIgnoreCase('Factory') && wo1[0].Type__c != 'Dealer') ) //Added by Piyush for VGRS2-16 11/30
        { 
            wo.RecordTypeId     = recdtypeId; 
            
            system.debug('wo.RecordTypeId ' + wo.RecordTypeId);
        }
        //For Dealers we are using a Single record type for Work Orders. 
        //So we are adding below Conditions for Distributors.
        list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
        wo1Ext = [Select Id,Service_Order_Id__c ,Selectedsolution__c  from Service_Order_Extension__c where Service_Order_Id__c =: workId LIMIT 1];
        if(wo1Ext.size() > 0 && solname != ''){
            wo1Ext[0].Selectedsolution__c=solname; 
            system.debug('to update wo '+wo1Ext[0]);
            
            update wo1Ext;
            
        }
              
        system.debug('to update wo '+wo);        
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            update wo;   
            system.debug('RecordType'+recdtypeId);
        }
    }
    //added by kalpana
    @AuraEnabled
    public static boolean continueToRepairNew(string workId,string solId, string resval) {
       System.debug('Continue To Repair:::'+solId);
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        String solname = '';
        
        wo1 = [Select id,Process_Step__c, RecordTypeId from WorkOrder where id=: workId];
        system.debug('wo1**'+wo1);
        if(wo1.size() > 0)
        {
            if(wo1[0].Process_Step__c == 'Triage & Diagnosis')
            {
                recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
                    .get('SolutionRepair').getRecordTypeId();
            }
        }
        CSS_Solutions__c sol=[SELECT id,name,FSL_Service_Job__c,FaultCode__c,Solution_Title__c,FSL_Solution_Position__c,Diagnostic_Notes__c,Repair_Response__c,Repair_Notes__c,Diagnostic_Response__c,userTimestamp__c, 
                              CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.userTimestamp__c,No_Access_SRT_required__c FROM CSS_Solutions__c where Id =:solId ORDER BY FSL_Solution_Position__c];
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
        system.debug('resval in Class**'+resval);
        boolean setErrorMsg = true;
        if((resval == 'Most likely the solution. Repair recommended.'|| resval == 'Not the solution. Continue troubleshooting.')){
        List<FSL_SRT__c> srts = new List<FSL_SRT__c>();
       srts = [SELECT Id,type__c from fsl_srt__c where solution_number__c = :solId and type__c IN ('Diag Access','Repair Access') LIMIT 1];
       system.debug('srts**'+srts);        
       if((sol!=null && sol.No_Access_SRT_required__c == true) || (srts!=null && srts.size()>0))
       setErrorMsg = true;
                else 
                    setErrorMsg = false;
        }
        system.debug('setErrorMsg**'+setErrorMsg);
        
        WorkOrder wo     = new WorkOrder();
        wo.Id            = workId;
        if(setErrorMsg == true){
        wo.Process_Step__c  = 'Repair';
        wo.Status           = 'Repair';
        wo.RecordTypeId   = recdtypeId;
        }
        list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
        wo1Ext = [Select Id,Service_Order_Id__c ,Selectedsolution__c  from Service_Order_Extension__c where Service_Order_Id__c =: workId LIMIT 1];
        if(wo1Ext.size() > 0 && solname != ''){
            wo1Ext[0].Selectedsolution__c=solname; 
            system.debug('to update wo '+wo1Ext[0]);
            
            update wo1Ext;
            
        }
        
        system.debug('to update wo '+wo);        
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            update wo;   
            system.debug('RecordType'+recdtypeId);
        }
        return setErrorMsg;
    }

    // Added Ravi To hide/show Input/Output spec Radio buttons 
    @AuraEnabled
    public static WorkOrder getjobordernumber(string strjobId) {
        return [select id,Clock_In_User_Ids_Formula__c, user__r.id,EVL_Assigned_Technician__c,User__c,CreatedById from WorkOrder where id=:strjobId limit 1];//User__c modified by Ravi   
    }
    @AuraEnabled
    public static Boolean fetchTakeControl(string strjobId){
        
        return EVL_TDSController.fetchTakeControl(strjobId);
    }
    //Removing upsertAdminSRT method as part of CT2-720 Karthik Pedditi	06/04/2021	//	   
    //Added by Mallika for AdminSRT --CT2-10 //
  @AuraEnabled
    @future (callout=true)
    public static void upsertAdminSRT(String wrkorderId) {
        system.debug('Testworkordr'+wrkorderId);
        FSL_SRT__c adminSRT = new FSL_SRT__c();
        List<FSL_SRT__c> existingAdminSRT = new List<FSL_SRT__c>();
        WorkOrder wo=[SELECT id,asset.Equipment_Id__c,Application__c,Repair_Location__c, asset.Engine_Family_Code__c, asset.Service_Model__c,Asset.Make__c,Asset.Model__c 
                          FROM workorder WHERE id=: wrkorderId];
        List<CSS_Make_Model_Access__c> cssMakeModelAccs;
        CSS_Make_Model_Access__c cssMakeModelAcc ;
        cssMakeModelAccs= [SELECT Id, Access__c FROM CSS_Make_Model_Access__c 
                           WHERE Make__c =: wo.Asset.Make__c 
                           AND Model__c =: wo.Asset.Model__c 
                           AND EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c LIMIT 1];
        if(cssMakeModelAccs != null && cssMakeModelAccs.size() == 1) {
            cssMakeModelAcc = cssMakeModelAccs[0];
        }
        List<FSL_SRT__c> ListAllSRT = [select Id,Name,step_id__c,SRT_Warrantable__c, Assignment__c,SRT_ID__c, Type__c, SRT_Type__c,
                                        Access_Code_A__c FROM FSL_SRT__c
                                      where Service_Order__c =: wrkorderId ];
        //system.debug('Testid'+ListAllSRT);
        // if(ListAllSRT != null ){

        if(ListAllSRT != null && ListAllSRT.size() >0) 
        {
            for(FSL_SRT__c diagsrt: ListAllSRT)
            {
                if(diagsrt.Name == '00-904-00' || diagsrt.Name == '00-901-00' || diagsrt.Name == '00-902-00') {
                    existingAdminSRT.add(diagsrt);
                }
            }
        
        
        if(existingAdminSRT!=null && existingAdminSRT.size() > 0)
        {
            adminSRT.Id = existingAdminSRT[0].Id;
           
         }
          else{
                adminSRT.Service_Order__c = wrkorderId;
          }
        
                     
            if(wo.Application__c=='310 - RECREATIONAL VEHICLE'|| wo.Application__c=='320 - RECREATIONAL VEHICLE AD' || wo.Application__c=='610 - MARINE - RECREATIONAL(ALL ENG)'){
                adminSRT.Name = '00-904-00';
                adminSRT.Type__c='Admin'; 
                system.debug('TestadminSRT.Name1****'+adminSRT.Name);
            }
            
            else if(wo.Repair_Location__c == 'In Shop')
            {
                adminSRT.Name = '00-901-00';
                adminSRT.Type__c='Admin';
                system.debug('TestadminSRT.Name2****'+adminSRT.Name);
            }
            
            else if(wo.Repair_Location__c == 'Mobile') {
                adminSRT.Name = '00-902-00';
                adminSRT.Type__c='Admin';
                system.debug('TestadminSRT.Name3****'+adminSRT.Name);
            }
                //adminSRT.Service_Order__c = wrkorder.Id;
             system.debug('TestadminSRT.Name****'+adminSRT.Name);
        }   
       // }
        
       // FSL_SRTEditPopupController fsrt = new FSL_SRTEditPopupController();
        //List<FSLDiagSRTIntegrationWrappers.SRTLookupDataAreaList> fsrts =  fsrt.runSRTLookupInterface(wo);
        FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrts = FSL_SRTEditPopupController.runSRTLookupInterface(wo);
        Boolean checkAdminSRT= False;
        system.debug('Testintegration'+fsrts);
        
        if(fsrts != null){
            for(FSLSRTIntegrationWrappers.SRTLookupDataArea srt : fsrts.DataArea) {
                
                Decimal srtTm;
                String srtAccessCode;
                Boolean booleanR = FALSE;
                if(cssMakeModelAcc!=null && cssMakeModelAcc.Access__c == 'A' && srt.ATime != null) {
                    srtTm =Decimal.valueOf(srt.ATime);
                }
                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'B' && srt.BTime != null) {
                    srtTm = Decimal.valueOf(srt.BTime);
                }
                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'C' && srt.CTime  != null ) {
                    srtTm = Decimal.valueOf(srt.CTime);
                }
                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'D' && srt.DTime  != null) {
                    srtTm = Decimal.valueOf(srt.DTime);
                }
                else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'R' && srt.RTime  != null) {
                    srtTm = Decimal.valueOf(srt.RTime);
                    booleanR = TRUE;
                }
                
                if(srtTm == null || srtTm == 0.0) {
                    srtAccessCode = 'R';
                    if(srt.RTime != null){
                      srtTm = Decimal.valueOf(srt.RTime);
                    }
                    booleanR = TRUE;
                }
                else if(cssMakeModelAcc != null) {
                    srtAccessCode = cssMakeModelAcc.Access__c;
                }
                
                if(srt.SRTNumber == adminSRT.Name) {
                    adminSRT.SRT_Title__c = srt.SRTTitle;
                    adminSRT.SRT_Quantity__c = 1;
                    adminSRT.SRT_Time__c = srtTm;
                    adminSRT.SRT_Access_Code__c = srtAccessCode;
                    if(srt.BTime != null){
                      adminSRT.Access_Code_B__c = Decimal.valueOf(srt.BTime);
                    }
                    if(srt.CTime != null){
                      adminSRT.Access_Code_C__c = Decimal.valueOf(srt.CTime);
                    }
                    if(srt.DTime != null){
                      adminSRT.Access_Code_D__c = Decimal.valueOf(srt.DTime);
                    }
                    adminSRT.Step_Id__c = srt.StepID;
                    if(srt.RTime != null){
                      adminSRT.Access_Code_R__c = Decimal.valueOf(srt.RTime);
                    }
                    if(srt.ATime != null){
                      adminSRT.Access_Code_A__c = Decimal.valueOf(srt.ATime);
                    }
                    adminSRT.SRT_Type__c = srt.SRTType;
                    adminSRT.SRT_Select__c = TRUE;
                    //adminSRT.Step_Description__c= srt.StepDesc;
                    adminSRT.Use_R_Time__c = booleanR;
                    checkAdminSRT=True;     
                }
            }
        }
        if(checkAdminSRT && !Test.isRunningTest()){
        upsert adminSRT;
        }
    } 
    //End --CT2-10 //
    
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
  
    // Added by Sriprada for VGRS2-6 for displaying fault code overview for Dealer jobs within the EVL_DisplaySolution.cmp - 10/20/2021 
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
        listWo = [select id,Service_Order_Extension__c,Service_Order_Extension__r.FaultCodeId__c,Asset.Name from workorder where id =:workOrderId];
  		List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: workOrderId];
         if(listWo.size()>0)
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
    } // Code ends here
}