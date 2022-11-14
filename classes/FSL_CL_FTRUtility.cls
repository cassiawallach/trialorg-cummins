/************************************************************************************************************************************************************
Name: FSL_CL_FTRUtility 
------------------------------------------------------------------------------------------------------------------------------------       
Purpose: This class is used as a utility class for FTR Functionallity(FSL Guidanz).
------------------------------------------------------------------------------------------------------------------------------------
VERSION      AUTHOR                     DATE               DETAIL                                
1.0         Sakthiraj                 07/29/2022         Added methods related to FTR Integration Automations
2.0         Sakthiraj                 08/11/2022         Added methods related to Get SRT Parts and Get Part Returns Integration
*************************************************************************************************************************************************************/
public with sharing class FSL_CL_FTRUtility {
  
    //1.0 Sakthiraj - 07/29/22 - SG-82 and SG-83 - Method to call API's for FTR Automation
    //This method will call Get solutions API
    public static string getSolutionsForFTR(Id woId, Boolean isIA){
        try {
            WorkOrder wo = [SELECT id, Process_Step__c, Status,
                                (SELECT Id, FSL_ABRFlag__c, FSL_TransactionID__c
                                FROM Service_Order_Extension__r 
                                WHERE FSL_TransactionID__c != null AND FSL_ABRFlag__c = true)
                            FROM WorkOrder 
                            WHERE Id =: woId];
                            
            if( (isIA || 
                ((wo.Process_Step__c == 'Triage & Diagnosis' || wo.Status == 'Triage & Diagnosis') &&
                wo.Service_Order_Extension__r != null &&
                wo.Service_Order_Extension__r.size() > 0)) ){
                
                Map<id,CSS_Fault_Code__c> faultCodeSolutionMap = new Map<id,CSS_Fault_Code__c>();
                Integer maxSeq = FSL_orderController.maxSequenceMethod(woId);
                List<CSS_Fault_Code__c> priorityFaultCodeList = [SELECT Id, Name, sequence__c, Number_of_Solutions__c
                                                                FROM CSS_Fault_Code__c 
                                                                WHERE Service_Order__c =: woId AND 
                                                                    Number_of_Solutions__c = null AND
                                                                    sequence__c =: maxSeq AND
                                                                        (Fault_Code_Type__c ='APD-P' OR 
                                                                        Fault_Code_Type__c ='APD-R' OR 
                                                                        Fault_Code_Type__c='BPD' OR 
                                                                        Fault_Code_Type__c='BLANK') 
                                                                ORDER BY Order__c,sequence__c ];

                if(!priorityFaultCodeList.isEmpty()){
                    //Get Solution
                    faultCodeSolutionMap = FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions(woId, priorityFaultCodeList);
                }
                return 'success';
            } else {
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // This method will call Get options, GET SRT Repait and Get Detail coverage
    public static void callGetOptionsAndOtherApis(Id serviceOrderId){
        try {
            List<String> solCompIdList = new List<String>();
            Set<String> failiureIdSet = new Set<String>();
            Set<id> solutionIdSet = new Set<Id>();
            
            WorkOrder wo = [SELECT id, FSL_Locked_Assest__c
                            FROM WorkOrder 
                            WHERE Id =: serviceOrderId];
            // Get Options
            FSL_CL_RetrieveOptionList.insertOptionsSync(wo.FSL_Locked_Assest__c, serviceOrderId);


            List<CSS_Solutions__c> cssSolutionsList = [SELECT Id
                                                        FROM CSS_Solutions__c
                                                        WHERE FSL_Service_Job__c =: serviceOrderId];
            for(CSS_Solutions__c sol:cssSolutionsList){
                solutionIdSet.add(sol.Id);
            }
            
            List<CSS_Solution_Component__c> solComponentList = [SELECT id, Component_Id__c, Selected_Component__c
                                                                FROM CSS_Solution_Component__c
                                                                WHERE Selected_Component__c = true
                                                                    AND Solutions__c IN: solutionIdSet];
            For(CSS_Solution_Component__c solComp: solComponentList){
                solCompIdList.add(solComp.id);
                if(String.isNotBlank(solComp.Component_Id__c)){
                    failiureIdSet.add(solComp.Component_Id__c);
                }
            }
            
            //Get Repair SRT and Insert
            runRepairSRTInterfaceAndInsertSRT(serviceOrderId, solCompIdList, solutionIdSet);

            // Get SRT Parts
            Id devOptionsRecordTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
                String optionNbr = '';
            for(CSS_Parts_Options__c cpo : [SELECT Option_Number__c FROM CSS_Parts_Options__c WHERE RecordTypeId = :devOptionsRecordTypeId AND Service_Order__c =: serviceOrderId LIMIT 1]) {
                optionNbr = cpo.Option_Number__c;
            }

            // Get Detail Coverage
            integer count = 0;
            for(CSS_Solution_Component__c obj : solComponentList) {
                if(obj.Selected_Component__c == true && count<90) {
                    FSL_getDetailCoverage.getSolutionCoverage(obj.Id);
                    count++;
                }
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    //2.0 Start- This method will call Get SRT Parts and Get Part Returns
    public static void callGetPartsAndPartReturn(Id serviceOrderId){

        //Call get parts API
        List<FSL_Parts__c> fslPartsList = callGetPartsForFTR(serviceOrderId);
        if(fslPartsList.size() > 0) {
            //Call Get Parts Return Integration(Future)- copied from FSL_GetSolutions.solUpdate
            FSL_CL_getEPRFlag.getEPRFlagTriggerHelper(fslPartsList);
        }
    }
    //2.0 End

    // This method's logic is copied from FSL_GetSolutions.solUpdate since for FTR we need to get only Repair SRT
    @future(callout=true)
    Public static void runRepairSRTInterfaceAndInsertSRT(Id workOrderId, List<String> solCompsIdList, Set<Id> solutionIdSet){

        List<FSL_SRT__c> Rsrts = new List<FSL_SRT__c>();
        Boolean isExistingRSRT = false;
        WorkOrder wo = [SELECT id, WorkOrderNumber, Asset.Service_Model__c, Asset.Equipment_Id__c, 
                            Asset.Engine_Family_Code__c
                        FROM WorkOrder 
                        WHERE Id =: workOrderId];
        List<FSL_SRT__c> FsrtsRep = [SELECT Id,SRT_ID__c,Name,Step_Id__c,Component_Id__c 
                                    FROM FSL_SRT__c 
                                    WHERE Service_Order__c = : workOrderId 
                                        AND Solution_Number__c =: solutionIdSet 
                                        AND Type__c = 'Repair'];
        
        FSLDiagSRTREPWrappers respREP = FSLSRTIntegrationHelperCls.runRepairSRTInterface(wo, 'REP', '', null, solCompsIdList);
            
        if(respREP != null) {
            if (respREP.DataArea != null && respREP.DataArea.CaseResponse != null) {
                List<FSLDiagSRTREPWrappers.CaseResponse> CaseResponse = respREP.DataArea.CaseResponse;
                FSL_SRT__c fsrt;
                Map <string, string> fIdWithSolCompId = new Map <string, string>();
                Map <string, string> fIdWithSolId = new Map <string, string>();
                Map <string, string> fIdWithFaultCode = new Map <string, string>();
                if(solCompsIdList != null && solCompsIdList.size() > 0)
                {
                    for(CSS_Solution_Component__c csc : [SELECT Id, Component_Id__c, Selected_Component__c, Solutions__c, Solutions__r.FaultCode__c
                                                        FROM CSS_Solution_Component__c 
                                                        WHERE Id IN: solCompsIdList]) {
                        if(String.isNotBlank(csc.Component_Id__c)){
                            fIdWithSolCompId.put(csc.Component_Id__c, csc.Id);
                            if(csc.Solutions__c != null){
                                fIdWithSolId.put(csc.Component_Id__c, csc.Solutions__c);
                                if(csc.Solutions__r.FaultCode__c != null){
                                    fIdWithFaultCode.put(csc.Component_Id__c, csc.Solutions__r.FaultCode__c);
                                }
                            }

                        }
                    }
                }
                for(FSLDiagSRTREPWrappers.CaseResponse cr : CaseResponse) {
                    Boolean booleanR = FALSE;
                    //Added by vinod for the filter out below conditions.
                    if(!cr.Assignment.equalsIgnoreCase('Diagnostic') && 
                        !cr.Assignment.equalsIgnoreCase('Unlisted')&& 
                        !cr.Assignment.equalsIgnoreCase('Not Claimable') && 
                        !cr.Assignment.equalsIgnoreCase('Not Applicable')) {

                        boolean srtselect = false;
                        if(cr.Assignment.equalsIgnoreCase('PRIMARY')) {
                            srtselect = true;
                        }
                        if(cr.SRTAccessCode == 'R') {
                            booleanR = TRUE;
                        }
                        isExistingRSRT = false;
                        for(FSL_SRT__c rsrt :  FsrtsRep){
                            if(rsrt.SRT_ID__c == cr.SRTDetails && 
                                rsrt.Step_Id__c == cr.VerifyRepeatValue.Step.StepId &&  
                                rsrt.Solution_Number__c == fIdWithSolId.get(cr.FailureID) &&
                                rsrt.Component_Id__c == fIdWithSolCompId.get(cr.FailureID)){
                                isExistingRSRT = true;
                                break;
                            }
                        }
                        if(isExistingRSRT == false) {
                            fsrt = new FSL_SRT__c(
                                Name = String.isNotBlank(cr.SRTDetails)?cr.SRTDetails:'N/A', // 08/21 Vinod - added for passing N/A when srt id is blank from srt resp
                                SRT_ID__c = cr.SRTDetails,
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
                                Component_Id__c  = fIdWithSolCompId.get(cr.FailureID),
                                Solution_Number__c = fIdWithSolId.get(cr.FailureID),
                                Type__c = 'Repair',
                                CSS_Fault_Code__c = fIdWithFaultCode.get(cr.FailureID),
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

        if(!Rsrts.isEmpty()) {
            insert Rsrts;
        }
    }
    // 1.0 Sakthiraj - 07/29/22 - SG-82 and SG-83 End
    
    //2.0 Start - This method is to call Get parts and copied from FSLSolutionComponentsCls class
    public static List<FSL_Parts__c> callGetPartsForFTR(String woId) {

        Map<String, CSS_Solution_Component__c> cscToIsrtMap = new Map<String, CSS_Solution_Component__c>();
        List<FSL_Parts__c> partsToInsert=new List<FSL_Parts__c>();

        For(CSS_Solution_Component__c solComp: [SELECT id, Component_Id__c, Selected_Component__c, Solutions__c
                                                FROM CSS_Solution_Component__c
                                                WHERE Selected_Component__c = true
                                                    AND FSL_Service_Job__c =: woId]){

            cscToIsrtMap.put(solComp.Component_Id__c, solComp);
        }

        if(cscToIsrtMap.size() > 0) {
            Id devPartsRecordTypeId = Schema.SObjectType.FSL_Parts__c.getRecordTypeInfosByName().get('GSQ').getRecordTypeId();
            Id devOptionsRecordTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
            String optionNbr = '';
            for(CSS_Parts_Options__c cpo : [SELECT Option_Number__c FROM CSS_Parts_Options__c WHERE RecordTypeId = :devOptionsRecordTypeId AND Service_Order__c =:woId LIMIT 1]) {
                optionNbr = cpo.Option_Number__c;
            }
            
            WorkOrder wo = [SELECT WorkOrderNumber, Asset.Engine_Family__c, Asset.Engine_Family_Code__c, Asset.Service_Model__c, Asset.Equipment_Id__c FROM WorkOrder WHERE id=:woId];
            FSLGetPartsListSRTIntegrationHelper fsrt=new FSLGetPartsListSRTIntegrationHelper(); // integration to get parts
            FSLGetPartsSRTListWrapper fgs = fsrt.getSRTPartsList(cscToIsrtMap.keyset(), optionNbr, wo); // Replace new Set<String>()-- with options
            if(fgs != null) {
                if(fgs.DataArea != null && !fgs.DataArea.isEmpty()) {
                    FSL_Parts__c fslPart;
                    for(FSLGetPartsSRTListWrapper.DataArea fd : fgs.DataArea) {
                        
                        fslPart = new FSL_Parts__c (
                            Name = fd.PartNumberService,
                            Part_Name__c = fd.PartNameService,
                            Part_Description__c = fd.PartNumberMfg,
                            Assignment__c = fd.Assignment,
                            Notes__c = fd.Notes,
                            Part_Quantity__c = Decimal.valueOf(fd.Qty),
                            Option_Number__c = fd.OptionNumber,
                            Part_Size__c = fd.PartSize,
                            Service_Order__c = woId,
                            OEM__c = fd.OEM,
                            FailureName__c = fd.FailureName,
                            RecordTypeId = devPartsRecordTypeId,
                            Replacement_Repair_Reason__c = 'Suggested Parts Based on Failure (GSQ Part)',
                            Solution__c = cscToIsrtMap.get(fd.FailureID).Solutions__c, // solid
                            CSS_Solution_Component__c = cscToIsrtMap.get(fd.FailureID).id,
                            Select__c = true
                        );
                        partsToInsert.add(fslPart);
                    }
                }
            }

            if(partsToInsert.size() > 0){
                insert partsToInsert;
            }
        }
        return partsToInsert;
    }
    //2.0 End

}