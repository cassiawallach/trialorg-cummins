/**********************************************************************
Name: FSL_CL_TSoverview
Copyright Â© 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
-------  
This class is to Display Troubleshooting Overview in Job Plan
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION    AUTHOR                    DATE
1.0        Mallika Subhashini        05/13/2019
1.1        Rajashekar Nallapati      05/18/2019
1.2        Sriprada Sesham           11/18/2019
1.3        Shirisha Pedditi          07/06/2022
***********************************************************************/
global class FSL_CL_TSoverview {
    /*
* Author :-Mallika.P
Method to get and display fault code related to service order &
solutions,solution components to related solution 

*/
    @AuraEnabled
    global static List<WrapObject> tsOverview(id serviceOrderId) {
        List<WrapObject> WrapObjects = new List<WrapObject>();
        Map<string,list<string>> failMap = new Map<string,List<string>>();
        Map<string,list<CSS_Solutions__c>> solMap = new Map<string,list<CSS_Solutions__c>>();
        Map<string,list<CSS_Solution_Component__c>> compMap = new Map<string,list<CSS_Solution_Component__c>>();
        Set<Id> fcId = new Set<Id>();
        Set<Id> solfcId = new Set<Id>();
        String accCode = '';
        List<CSS_Fault_Code__c> fau=[SELECT Id, Name, Service_Order__c,Fault_Code_Description__c, Number_of_Solutions__c, Fault_Code_Type__c, Service_Order__r.FSL_Locked_Assest__c, 
                                     Service_Order__r.ESN_Insite__c, Service_Order__r.Asset.Name, 
                                     (SELECT Id, Name FROM CSS_Solutions__r) FROM CSS_Fault_Code__c 
                                     WHERE Service_Order__c =: serviceOrderId 
                                     ORDER BY LastModifieddate DESC];
        
        for(CSS_Fault_Code__c cfc:fau) {
            fcId.add(cfc.id);
        }
        
        List<CSS_Solutions__c> solLi = [SELECT Id, Name, Solution_Title__c, userTimestamp__c, FSL_Solution_Position__c, FaultCode__r.Fault_Code_Description__c,
                                        Diagnostic_Response__c, FaultCode__c, FaultCode__r.Id, FaultCode__r.Name, 
                                        (SELECT Id FROM Parts__r WHERE Select__c = TRUE),
                                        FSL_Service_Job__r.Service_Order_Extension__r.FSL_ABRFlag__c // Added by Prasanna to remove the displaying Solution ID for FTR Event - ROAD -474 
                                        FROM CSS_Solutions__c 
                                        WHERE FaultCode__r.Service_Order__c =: serviceOrderId  AND userTimestamp__c != null ORDER BY userTimestamp__c];
        system.debug('**solLi**'+solLi.size());
        system.debug('**solLi**'+solLi);
        for(CSS_Solutions__c sol:solLi) {
            fcId.add(sol.FaultCode__c);
            solfcId.add(sol.id);
            system.debug('SolfcId is:'+sol.Id);
            system.debug('fcid is:'+sol.FaultCode__c);
        }
        system.debug('**solfcId**'+solfcId);
        List<CSS_Solution_Component__c> complist = [SELECT Id, Name, Failure_Mode__c, Fail_Mode__r.Name, Solutions__c, 
                                                    Solutions__r.Diagnostic_Response__c, Solutions__r.FaultCode__r.Name, 
                                                    Account_Code__r.Name, Failure_Value__c, Failure_Code__r.Failure_Name__c, Failure_Code__r.Name, 
                                                    Fail_Mode__c, Solutions__r.Name, FSL_Account_Code__c, Selected_Component__c,Part_Warranty_Start_Date__c, 
                                                    Failure_Date__c, Failure_Point__c
                                                    FROM CSS_Solution_Component__c 
                                                    WHERE Selected_Component__c = TRUE AND Solutions__c in:solfcId ORDER BY Solutions__r.userTimestamp__c];
        system.debug('**complist**'+complist);
        for(CSS_Solution_Component__c comp:complist) {
            // accCode = comp.AccountCode__c;
            system.debug('*failure**'+comp.Failure_value__c+'**comp Name**'+comp.Name+'*solutions *'+comp.Solutions__r.Name);
            List<string> fvalue = new List<string>();
            if(failMap.containsKey(comp.Solutions__r.Name)) {
                fvalue = failMap.get(comp.Solutions__r.Name);
            }
            fvalue.add(comp.Failure_value__c);
            failMap.put(comp.Solutions__r.Name, fvalue);
            system.debug('Failure Value:'+fvalue);
        }
        system.debug('**failMap**'+failMap);
        for(CSS_Solution_Component__c comp : complist) {
            // if(comp.Failure_value__c != null) {
            List<CSS_Solution_Component__c> scomplist = new List<CSS_Solution_Component__c>();
            
            if(compMap.containsKey(comp.Solutions__r.FaultCode__r.Name)) {
                scomplist = compMap.get(comp.Solutions__r.FaultCode__r.Name);
            }
            scomplist.add(comp);
            compMap.put(comp.Solutions__r.FaultCode__r.Name, scomplist);
            // }
        }
        system.debug('**compMap**'+compMap);
        for(list<CSS_Solution_Component__c> cmap:compMap.values()) {
            system.debug('**cmap**'+cmap);
        }
        for(CSS_Solutions__c objSolution : solLi) {
            if(objSolution.userTimestamp__c != null) {
                List<CSS_Solutions__c> sollist = new List<CSS_Solutions__c>();
                if(solMap.containsKey(objSolution.FaultCode__r.Name)) {
                    sollist = solMap.get(objSolution.FaultCode__r.Name);
                }
                sollist.add(objSolution);
                solMap.put(objSolution.FaultCode__r.Name, sollist);
            }
        }
        system.debug('**solMap**'+solMap);
        
        List<FSL_Parts__c> partList = [SELECT id, Name from FSL_Parts__C WHERE CSS_Solution_Component__c IN :complist ];
        for(FSL_Parts__c listParts: partList){
            
            FSL_CL_getEPRFlag.getEPRFlagTriggerHelper(partList);
            
        }
        
        
        /* Rajashekar : Start :- To display Total Diagnosis time for each fault code*/
        List<FSL_SRT__c> listSRT = [SELECT Id, CSS_Fault_Code__c, SRT_Time__c,Type__c
                                    FROM FSL_SRT__c 
                                    WHERE SRT_Select__c=TRUE 
                                    AND (Type__c='Diagnosis' OR Type__c='Diag Access' OR Type__c='Repair' OR Type__c='Repair Access' )
                                    AND CSS_Fault_Code__c IN: fcId AND Solution_Number__c IN : solLi ];
        System.debug('SRT List'+listSRT);
        Map<Id, List<FSL_SRT__c>> mapListSRTByFaultCodeId = new Map<Id, List<FSL_SRT__c>>();
        
        for(FSL_SRT__c objSRT : listSRT) {
            List<FSL_SRT__c> listTempSRT = new List<FSL_SRT__c>();
            if(mapListSRTByFaultCodeId.containsKey(objSRT.CSS_Fault_Code__c)) {
                listTempSRT = mapListSRTByFaultCodeId.get(objSRT.CSS_Fault_Code__c);
            }
            listTempSRT.add(objSRT);
            mapListSRTByFaultCodeId.put(objSRT.CSS_Fault_Code__c, listTempSRT);
        }
        System.debug('Map List SRT Fault Codes'+mapListSRTByFaultCodeId);
        
        Map<Id, Decimal> mapDigTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmDigTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)) {
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && (objSRT.Type__c == 'Diag Access' || objSRT.Type__c == 'Diagnosis' )) {
                    dcmDigTime = dcmDigTime + objSRT.SRT_Time__c;
                }
            }
            mapDigTimeByFaultCodeId.put(idKey, dcmDigTime);
        }
        System.debug('map DigTime By FaultCodeId'+mapDigTimeByFaultCodeId);
        //Repair time calcualtion based on fault code id
        
        Map<Id, Decimal> mapRepTimeByFaultCodeId = new Map<Id, Decimal>();
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmRepTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)) {
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && (objSRT.Type__c == 'Repair' || objSRT.Type__c == 'Repair Access')) {
                    dcmRepTime = dcmRepTime + objSRT.SRT_Time__c;
                }
            }
            mapRepTimeByFaultCodeId.put(idKey, dcmRepTime);
        }
        /* for(CSS_Fault_Code__c fcode : fau) {

} */
        
        Set<String> faultStr = new Set<String>();
        List<CSS_Solutions__c> cssSolList1 = new List<CSS_Solutions__c>();
        WrapObject wobj;
        for(list<CSS_Solutions__c> fName:solmap.values()) {
            for(CSS_Solutions__c cs : fName) {
                // system.debug('**cs.CSS_Parts_Options__r.size()**'+cs.CSS_Parts_Options__r.size());
                system.debug('**cs.FaultCode__r.Name**'+cs.FaultCode__r.Name+' Solmap size:'+solMap.get(cs.FaultCode__r.Name).size());
                wobj = new WrapObject(cs.FaultCode__r.Name,cs.FaultCode__r.Fault_Code_Description__c,solMap.get(cs.FaultCode__r.Name), 
                                      mapDigTimeByFaultCodeId.get(cs.FaultCode__c),
                                      mapRepTimeByFaultCodeId.get(cs.FaultCode__c),
                                      compMap.get(cs.FaultCode__r.Name), 
                                      failMap.get(cs.Name));
                
                if(!faultStr.contains(cs.FaultCode__r.Name)) {
                    faultStr.add(cs.FaultCode__r.Name);
                    faultStr.add(cs.FaultCode__r.Fault_Code_Description__c);
                    faultStr.add(cs.FaultCode__r.Id);
                    WrapObjects.add(wobj);
                }
            }
        }
        system.debug('**WrapObjects**'+WrapObjects);
        return WrapObjects;
    }
    
    // method added by Mallika.P to edit the solution component record
    @AuraEnabled
    public static List<CSS_Solution_Component__c> UpdateSolComp(String recId) {
        system.debug('**recId**'+recId);
        //CSS_Fault_Code__r.Name
        //return [SELECT Id,Failure_Code__c,Custom_Failure_Name__c,Fail_Mode__c,Pay_Code__C, Authorization_Number__c,Approval_Code__c,Part_Warranty_Start_Date__c,Failure_Date__c,Failure_Point__c,Failure_Measure__c FROM CSS_Solution_Component__c  WHERE id=:recId LIMIT 1];
        return [SELECT Id, Failure_Mode__c, Component_Id__c, Failure_Code__c, Custom_Failure_Name__c, 
                Fail_Mode__c, Fail_Mode__r.Name, Pay_Code__C, Authorization_Number__c, Parts__c,
                Approval_Code__c, Part_Warranty_Start_Date__c, Failure_Date__c, Failure_Point__c, Failure_Measure__c, 
                System_Code__c, Component_Code__c, AccountCode__c, Account_Code__c, FSL_Account_Code__c, FSL_Service_Job__c, 
                FSL_Service_Job__r.ServiceTerritory.Location_Code__c, FSL_Service_Job__r.Application__c, FSL_Service_Job__r.Asset.Name, 
                FSL_Service_Job__r.Failure_Date__c, FSL_Service_Job__r.Mileage__c, Cummins_Fault_Code__r.Name, 
                FSL_Service_Job__r.Mileage_Measure__c, FSL_Service_Job__r.Warranty_Start_Date__c, FC_Type__c, FC_Description__c
                FROM CSS_Solution_Component__c WHERE Id =: recId LIMIT 1];
    }
    
    //Method added by Rajashekar to get the Coverage type
    @AuraEnabled
    public static String getCoverageTypeFromApex(String strAccountId) {
        List<FSL_Account_Code__c> lstFSLAccCode = [SELECT Id, Coverage_Type__c 
                                                   FROM FSL_Account_Code__c 
                                                   WHERE Name =:strAccountId LIMIT 1];
        
        string strCoverageType = '';
        if(lstFSLAccCode != null && lstFSLAccCode.size() > 0){
            strCoverageType =  lstFSLAccCode[0].Coverage_Type__c;
        }
        
        return strCoverageType;
    }
    
    //Method added by Rajashekar to get the Coverage type
    @AuraEnabled
    public static String getCoverageApex(CSS_Solution_Component__c solCmp) {
        String strCoverageMsg = FSL_getDetailCoverage.checkCoverage(solCmp);
        return strCoverageMsg;
    }
    //Method added by Sai Bharadwaj for CT1-95
    @AuraEnabled
    public static boolean getStatus(string recId) {
        system.debug('recId==>'+recId);
        boolean showRecord = false;        
        workorder wo = [select id, status, EVL_Stage__c from workorder where id =: recId];
        if(wo.Status == 'Closed' && wo.EVL_Stage__c == 'Closed' ){
            showRecord = true;
        }
        return showRecord;
    }
    
    /*
* @Author : Rajashekar Nallapati
* @Arguments : String type of Approval Code
*/
    @AuraEnabled
    global static Integer validateApprovalAndAuthorizationNumber(String AppCode) {
        System.debug('ApprovalCode'+AppCode);
        List<FSL_Approval_Code__c> objList = [SELECT Id, Approval_Code__c 
                                              FROM FSL_Approval_Code__c 
                                              WHERE Approval_Code__c =: AppCode];
        return objList.size();
    }
    
    /*
* @Author : Rajashekar Nallapati
*  
*/
    @AuraEnabled
    global static String getAccountCodeCoverageType(String strSolComId) {
        String accCodeCovType  = [SELECT Id, Failure_Mode__c, Account_Code__r.Coverage_Type__c 
                                  FROM CSS_Solution_Component__c 
                                  WHERE Id=:strSolComId].Account_Code__r.Coverage_Type__c;
        return accCodeCovType;
    }
    
    @AuraEnabled
    global static String updateAccountCode(String strSolComId) {        
        String accCodeVal  = [SELECT Id, Failure_Mode__c, FSL_Account_Code__c, Account_Code__r.Coverage_Type__c 
                              FROM CSS_Solution_Component__c 
                              WHERE Id=:strSolComId].FSL_Account_Code__c;
        system.debug('Account Code:'+accCodeVal);
        
        return accCodeVal;
    }
    
    
    global class WrapObject {
        // @AuraEnabled global String recid { get; set; }
        @AuraEnabled global String Name { get; set; }
        @AuraEnabled global String FaultCodeDescription { get; set; }
        @AuraEnabled global List<CSS_Solutions__c> solList { get; set; }
        @AuraEnabled global Decimal digTime { get; set; }
        @AuraEnabled global Decimal repTime { get; set; }
        @AuraEnabled global List<CSS_Solution_Component__c> compList { get; set; }
        @AuraEnabled global List<String> failList { get; set; }
        List<CSS_Solutions__c> cssSol = new List<CSS_Solutions__c>();
        global WrapObject(String fc,String FaultCodeDescription, List<CSS_Solutions__c> fcsol, Decimal digTime,Decimal repTime,
                          List<CSS_Solution_Component__c> clist, List<string> fvalue) {
                              // this.recid = fc.id;
                              this.Name = fc;
                              this.FaultCodeDescription = FaultCodeDescription;
                              this.solList = fcsol;
                              this.digTime = digTime;
                              this.repTime = repTime;
                              this.compList = clist;
                              this.failList = fvalue;
                              system.debug('fault id:' + fc);
                          }
    }
    
    @AuraEnabled
    public static void changeRecord(String workId, String faultID) {
        Id recdtypeId;
        List<WorkOrder> wo1 = new List<WorkOrder>();
        wo1 = [SELECT Id, Process_Step__c, RecordTypeId FROM WorkOrder WHERE id =: workId];
        if(wo1.size() > 0) {
            if(wo1[0].Process_Step__c == 'Job Plan') {
                recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
            }
        }
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, Service_Order_Id__c, FaultCodeId__c,Service_Order_Id__r.RecordTypeId,Service_Order_Id__r.Process_Step__c, Service_Order_Id__r.Status from Service_Order_Extension__c where Service_Order_Id__c =: workId];
        
        Service_Order_Extension__c woExtn        = new Service_Order_Extension__c();
        if(woExtList.size() > 0){
            woExtn.Id               = woExtList[0].id;
            woExtn.FaultCodeId__c   = faultID;
            
            update woExtn;
            system.debug('to update wo ' + woExtn);
        }
        
        wo1[0].RecordTypeId     = recdtypeId;
        wo1[0].Process_Step__c  = 'Triage & Diagnosis';
        wo1[0].Status           = 'Triage & Diagnosis';
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId)) {
            update wo1;
            system.debug('RecordType' + recdtypeId);
        }
    }
    
    // Added
    @AuraEnabled
    Public static String getFaultId(String woId, String faultID) {
        List<CSS_Fault_Code__c> cssFaultID  = [SELECT Id 
                                               FROM CSS_Fault_Code__c 
                                               WHERE Service_Order__c =: woId AND Name =: faultID LIMIT 1];
        system.debug('Fault Id::::' + cssFaultID);
        if(cssFaultID.size() > 0) {
            return cssFaultID[0].Id;
        }
        return null;
    }
    
    @AuraEnabled
    public static void saveAccountCode(String strRecordId, String accountCode){
        try{
            List<CSS_Solution_Component__c> cssSol = [SELECT ID, FSL_Account_Code__c,FSL_Service_Job__c
                                                      FROM CSS_Solution_Component__c 
                                                      WHERE Id=:strRecordId];
            system.debug('accountCode'+accountCode);
            cssSol[0].FSL_Account_Code__c = accountCode;
            update cssSol;
            system.debug('AccountUpdate:'+accountCode);
            
            List<WorkOrder> wo = [select Id,Status,Sub_Status__c,EVL_Stage__c 
                                  from WorkOrder
                                  where id=:cssSol[0].FSL_Service_Job__c and Type__c = 'Dealer'];
            system.debug('Workorder'+wo);
            wo[0].Status = 'Job Plan';
            wo[0].EVL_Stage__c = 'Job Plan';
            update wo;
        }catch(Exception ex){
            System.debug('Catch Exception in saveAccountCode '+ex.getMessage());
        }
        
    }
    
    //Added by Sriprada for Profile check 
    @AuraEnabled
    public static Profile getProfileInfo(){
        try{
            String profileId = UserInfo.getProfileId();
            Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
            system.debug('profile>>>>>>>>>>>'+profile.Name);
            return profile;
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Added by Sruthi for Profile check VGRS2-105 11/15/2021
    @AuraEnabled
    public static User fetchUserInfo(){
        try{
            
            // added role and profile by Priyanka VGRS2-17
            User us = [Select Id, Name,Profile.Name, UserRole.Name, FSL_Mileage_Measure__c from User where Id =: UserInfo.getUserId()]; 
            
            return us;
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Added by Shirisha for FTR ROAD-477
    @AuraEnabled
    public static Boolean fetchFTRFlag(Id woId){
        try{
            Service_Order_Extension__c soExtensionObj = [SELECT Id, FSL_ABRFlag__c, Service_Order_Id__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =: woId LIMIT 1];
            Boolean flag = soExtensionObj.FSL_ABRFlag__c;
            if(flag != null){
                return flag;
            }
            else {
                return false;
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}