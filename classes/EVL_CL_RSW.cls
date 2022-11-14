/******************************************************************************************************************
Name: EVL_CL_RSW
Copyright © 2020  Cummins
===================================================================================================================
===================================================================================================================
Purpose:    This class is for Create Claims funtionality.
===================================================================================================================
===================================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Lochana Rajput     06/10/2022     Added Event type attribute in DataArea for FTR feature in JSON request of RSW 
2.0     Lochana Rajput     07/25/2022     Added Event type attribute as 'DBR' for non-FTR feature in JSON request of RSW 
*******************************************************************************************************************/
public class EVL_CL_RSW {

    //Sruthi - To prevent Integration call from Trigger when the call is invoked by certain scenarios
    public static boolean FIRE_RSW_CALL = TRUE;
   
    public static void callRSWTriggerHelperMethod(Map<Id, workorder> newMap, Map<Id,workorder> oldMap){
        for(workorder wo : newMap.values()) {
            if(wo.ServiceTerritoryId != null){//to check dealer condition
                continue;
            }
            if((oldMap.get(wo.Id).Status == 'Triage & Diagnosis' || oldMap.get(wo.Id).Status == 'Job Plan' 
               || oldMap.get(wo.Id).Status == 'Repair')
               && wo.Status != oldMap.get(wo.Id).Status && FIRE_RSW_CALL) 
            {   
                callRSWFutureCall(wo.Id);
            }
        }
    }
    
    @future(callout=true)
    public static void callRSWFutureCall(Id wId){
        buildRSWUpdateClaimReqWrapper(wId);
    }
    
    public static void buildRSWUpdateClaimReqWrapper(Id wId){
        
        WorkOrder WORec = new WorkOrder();      
        WORec = [Select id,Account.Location__c,FSL_Resolution__c,WorkOrderNumber,Dealer_Shop_Work_Order__c,Engine_Serial_Number__c,     Mileage__c,
                 Mileage_Measure__c,Failure_Date__c,Warranty_Start_Date__c,Make__c,CSS_Hours__c,Model__c,Application__c,Vehicle_Identification_Number__c,
                 Unit_Number_Formula__c,EVL_Customer__c,Solution_Created_Date__c,Solution_Last_Modified__c,Category1__c,Complaint_Type1__c,ServiceTerritoryId,
                 Status, (SELECT Id, FSL_ABRFlag__c, FSL_TransactionID__c 
                 FROM Service_Order_Extension__r)
                 FROM WorkOrder where Id =: wId];
        if(WORec.ServiceTerritoryId != null){//Condition to check if the workorder is distributor and dealer.if it is distributor code will not be executed.
            return;
        }
        
        EVL_RSW_ReqWrapper reqJSON = new EVL_RSW_ReqWrapper(); 
        
        
        
        EVL_RSW_ReqWrapper.Header headerDetail = new EVL_RSW_ReqWrapper.Header();
        
        EVL_RSW_ReqWrapper.Sender senderDetail = new EVL_RSW_ReqWrapper.Sender();
        
        senderDetail.SenderID ='CSS';
        
        headerDetail.Sender = senderDetail;
        
        EVL_RSW_ReqWrapper.Target targetDetail = new EVL_RSW_ReqWrapper.Target();
        
        targetDetail.TargetID = 'RSW';
        
        headerDetail.Target = targetDetail;
        //started by Naga Anusha Malepati 8/8/22 ,NIN-470, regarding Class variables doesn't have public accessibility
        //reqJSON.Header = headerDetail;
        reqJSON.setHeader(headerDetail);
        //Ended by Naga Anusha Malepati 8/3/22 ,NIN-470, regarding Class variables doesn't have public accessibility
        
        EVL_RSW_ReqWrapper.DataArea DataAreaDetails = new EVL_RSW_ReqWrapper.DataArea(); 
        
        /*Changes to convert DateTime String to Local Time - Sruthi
        String createdDT = '';
        String modifiedDT = '';
        if(WORec.Solution_Last_Modified__c != NULL){
            DateTime lstGMT = DateTime.ValueOfGMT(WORec.Solution_Last_Modified__c);
            modifiedDT = lstGMT.format('yyyy-MM-dd HH:mm:ss', 'America/Indiana/Indianapolis');
        }
        if(WORec.Solution_Created_Date__c != NULL){
            DateTime crtGMT = DateTime.ValueOfGMT(WORec.Solution_Created_Date__c);
            createdDT = crtGMT.format('yyyy-MM-dd HH:mm:ss', 'America/Indiana/Indianapolis');
        }*/
        
        DataAreaDetails.id = WORec.WorkOrderNumber;
        //DataAreaDetails.dsID = (WORec.Solution_Created_Date__c != null ? WORec.WorkOrderNumber : '');
        DataAreaDetails.workOrder = WORec.Dealer_Shop_Work_Order__c;
        DataAreaDetails = EVL_CL_RSW.handleSolDates(DataAreaDetails, wId, WORec.WorkOrderNumber);
        //DataAreaDetails.timestamp = modifiedDT; //Time Zone Changes - Sruthi
        //DataAreaDetails.createDate = createdDT; //Time Zone Changes - Sruthi
        DataAreaDetails.esn = WORec.Engine_Serial_Number__c;
        DataAreaDetails.dsStatus = (WORec.Status == 'Closed' ? 'Closed' : 'Open');
        DataAreaDetails.nbSearches = '0';
        DataAreaDetails.accessSRTID = ''; 
        DataAreaDetails.manufacturer = WoRec.Make__c;
        DataAreaDetails.modelSeries = WoRec.Model__c;
        DataAreaDetails.unitNumber = WoRec.Unit_Number_Formula__c;
        DataAreaDetails.customerName = '';
        // Ramya: 04/22 Fix for VGRS2-449, Truncating to 30 Characters
        if(WoRec.EVL_Customer__c != null ) {
            // Fix for VGRS2-449, Truncating to 30 Characters & removing specail characters
            DataAreaDetails.customerName =  WoRec.EVL_Customer__c.replace('\"','\\"'); //.replaceAll('[^a-zA-Z0-9\\s+]', '');
            if(DataAreaDetails.customerName.length() > 30) {
                DataAreaDetails.customerName =  DataAreaDetails.customerName.substring(0,30);
            }
        }

        //DataAreaDetails.dsClosureType = 'Resolved in Guidanz'; 
        //added by sruthi
        if(WORec.Status == 'Closed' && WORec.FSL_Resolution__c != NULL){
            if(WORec.FSL_Resolution__c.length() > 20){
                DataAreaDetails.dsClosureType = WORec.FSL_Resolution__c.subString(0,19);
            }
            else{
                DataAreaDetails.dsClosureType = WORec.FSL_Resolution__c;
            }
        }
        
        //Assign App Code by splitting based on '-' and derive appflag to populate mileage and mileage measure afterwards.
        String AutomotiveAppFlag;
        if(WoRec.Application__c != null  && WoRec.Application__c.contains('-')) {
                String[] AppCode = WoRec.Application__c.split('-');
                if(AppCode != null && AppCode.size()>0){
                    DataAreaDetails.application = AppCode[0].trim(); 
                    switch on AppCode[0].trim() {
                        when '130','210','220','310','320','410'{
                            AutomotiveAppFlag = 'Y';
                        }
                        when else{
                            AutomotiveAppFlag = 'N';
                        }
                    }
                }else{
                    DataAreaDetails.application = '';
                }
            } 
            else { DataAreaDetails.application = ''; }
        //End Derive logic for app flag.
        
        DataAreaDetails.faliurePoint = (AutomotiveAppFlag == 'Y' ? (WoRec.Mileage__c != null ? String.valueof(WoRec.Mileage__c) : '0') : (WoRec.CSS_Hours__c != null ? String.valueof(WoRec.CSS_Hours__c) : '0'));
        DataAreaDetails.faliureMeasure = (AutomotiveAppFlag == 'Y' ? (WoRec.Mileage_Measure__c == 'MILES' ? 'MI' : 'KM') : 'HR');
        
        DataAreaDetails.accessSRTID = prepareAccessSRTString(wId);
        DataAreaDetails.faultCode = prepareFaultCodeString(wId);
        DataAreaDetails.Event = prepareSolList(wId);

        //1.0 STARTS
        //Fetching record from Feature Switch Matrix
        List<FSL_Switch__c> lstFeatureMatrix_RSW = [SELECT Id, Name, IsActive__c FROM FSL_Switch__c 
                    WHERE (Name = 'Enable_FTR_Switch' OR Name ='Enable_RSWIntegrationforFTR') 
                    AND IsActive__c = true ];
        Set<String> set_FeatureMatrix = new Set<String>();
        for(FSL_Switch__c fsm : lstFeatureMatrix_RSW) {
            set_FeatureMatrix.add(fsm.name);
        }
        if(WORec.Service_Order_Extension__r.size() > 0 && 
            WORec.Service_Order_Extension__r[0].FSL_ABRFlag__c == true
            && set_FeatureMatrix.contains('Enable_FTR_Switch')
            && set_FeatureMatrix.contains('Enable_RSWIntegrationforFTR')) {
                DataAreaDetails.eventType = 'FTR';
        }
        else {
            DataAreaDetails.eventType = 'DBR';
        }
        //1.0 ENDS
        //started by Naga Anusha Malepati 8/8/22 ,NIN-470, regarding Class variables doesn't have public accessibility
        //reqJSON.DataArea = DataAreaDetails;
        reqJSON.setDataArea(DataAreaDetails);
        
        EVL_WS_RSW.sendSerOrdInfoToRSW(reqJSON);
        //Ended by Naga Anusha Malepati 8/8/22 ,NIN-470, regarding Class variables doesn't have public accessibility
                                                    
    }
    
    public static EVL_RSW_ReqWrapper.DataArea handleSolDates(EVL_RSW_ReqWrapper.DataArea dWrapArea, Id wId, String woNumber){
        
        DateTime createdDate;
        DateTime lastModifiedDate;
        
        for(css_Solutions__c  solObj : [Select Id, CreatedDate, LastModifiedDate, FSL_Service_Job__c FROM CSS_Solutions__c where FSL_Service_Job__c =: wId]){
            
            if(createdDate == NULL){
                createdDate = solObj.CreatedDate;
            }
            else if(solObj.CreatedDate < createdDate){
                createdDate = solObj.createdDate;
            }
            if(lastModifiedDate == NULL){
                lastModifiedDate = solObj.lastModifiedDate;
            }
            else if(solObj.lastModifiedDate < lastModifiedDate){
                lastModifiedDate = solObj.lastModifiedDate;
            }
        }
        
        dWrapArea.dsID = createdDate!= null ? woNumber : '';
        dWrapArea.timestamp = lastModifiedDate != null ? lastModifiedDate.format('MM/dd/yyyy HH:mm:ss') : ''; //Time Zone Changes - Sruthi
        dWrapArea.createDate = createdDate != null ? createdDate.format('MM/dd/yyyy HH:mm:ss') : '';
        
        
        return dWrapArea;
    }
    
    public static list<EVL_RSW_ReqWrapper.Event> prepareSolList(Id wId){
        List<css_solutions__c> solList = new List<css_solutions__c>();
        list<EVL_RSW_ReqWrapper.Event> RSWSolList = new List<EVL_RSW_ReqWrapper.Event>();
        EVL_RSW_ReqWrapper.Event RSWSolRec = new EVL_RSW_ReqWrapper.Event();
        
        solList = [SELECT Id, Name, LastModifiedDate, Diagnostic_Response__c, FSL_Solution_Position__c, Repair_Response__c, Rank__c,(Select id,name,Component_Id__c,Selected_Component__c from CSS_Solution_Components__r), FaultCode__c, FaultCode__r.EVL_Sequence__c, FSL_Service_Job__c FROM CSS_Solutions__c where FSL_Service_Job__c =: wId AND Diagnostic_Response__c != NULL]; //Query modifications - Added condition to pull only records with Response - Sruthi
        
        for(css_solutions__c solRec:solList){
        RSWSolRec = new EVL_RSW_ReqWrapper.Event();
            
        RSWSolRec.componentID = prepareComponentString(solRec.CSS_Solution_Components__r);
        RSWSolRec.informationType = '';
        RSWSolRec.repairStatus = ((solRec.Repair_Response__c == 'Repair Successful.' || solRec.Repair_Response__c == 'Repair Successful with additional parts/procedures.') ? 'Y' : 'N');
        RSWSolRec.searchCompleted = 'True';
            //Changes to send the Fault Code sequence number - Sruthi
            if(solRec.FaultCode__c != NULL && solRec.FaultCode__r.EVL_Sequence__c != NULL){
                RSWSolRec.searchNumber = String.ValueOf(solRec.FaultCode__r.EVL_Sequence__c);
            }else{
                RSWSolRec.searchNumber = '1';   
            }
        RSWSolRec.solutionId = solRec.Name;
        RSWSolRec.solutionSeq = solRec.FSL_Solution_Position__c;
        RSWSolRec.timestamp = solRec.LastModifiedDate.format('MM/dd/yyyy HH:mm:ss');
        RSWSolRec.verificationStatus = (solRec.Diagnostic_Response__c == 'Could not perform the solution verification' ? 'N' : 'Y');
        RSWSolList.add(RSWSolRec);
        }
        
        return RSWSolList;
    }
    
    public static string prepareComponentString(List<CSS_Solution_Component__c> lstSolComp){
        string concatenatedSolComp = '';
        if(lstSolComp != null && lstSolComp.size()>0){
        for(CSS_Solution_Component__c solComp:lstSolComp){
            if(solComp.Selected_Component__c == false)
                continue;
            if(concatenatedSolComp != '' && concatenatedSolComp != null){
                concatenatedSolComp += ',' + solComp.Component_Id__c;
            }else{
                concatenatedSolComp = solComp.Component_Id__c;
            }
        }
        }else{
            concatenatedSolComp = '';
        }
       return concatenatedSolComp; 
    }
    
    public static string prepareAccessSRTString(Id wId){
        list<FSL_SRT__c> lstSRT = new list<FSL_SRT__c>();
        Set<String> srtNameSet = new Set<String>();
        String AccessSRT;
        lstSRT = [SELECT Name, Id, SRT_ID__c, Step_Id__c, type__c,Service_Order__c FROM FSL_SRT__c where Service_Order__c =: wId and type__c LIKE '%Access%'];
        if(lstSRT != null && lstSRT.size()>0){
            for(FSL_SRT__c srtRec:lstSRT){
                if(!srtNameSet.contains(srtRec.Step_Id__c)){
                    srtNameSet.add(srtRec.Step_Id__c);
                    if(AccessSRT != null && AccessSRT != ''){
                        AccessSRT += ',' + srtRec.Step_Id__c;
                    }else{
                        AccessSRT = srtRec.Step_Id__c;
                    }
                }                
            }
        }else{
            AccessSRT = '';
        }
        return AccessSRT;
    }
    
    public static string prepareFaultCodeString(Id wId){
        list<CSS_Fault_Code__c> lstFCodes = new list<CSS_Fault_Code__c>();
        String FaultCodeString;
        lstFCodes = [SELECT Id, Name, FaultCode__c, Fault_Code__c, Type__c, Service_Order__c FROM CSS_Fault_Code__c where Service_Order__c =: wId];
        if(lstFCodes != null && lstFCodes.size()>0){
            for(CSS_Fault_Code__c FCRec:lstFCodes){
                if(FaultCodeString != null && FaultCodeString != ''){
                    FaultCodeString += ',' + FCRec.Name;
                }else{
                    FaultCodeString = FCRec.Name;
                }
            }
        }else{
            FaultCodeString = '';
        }
        return FaultCodeString;
    }  
    
}