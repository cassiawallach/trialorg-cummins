/**********************************************************************
Name:FSL_CL_GetSolutions
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is to Display the table for Faultcodes and Symptoms 
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                             

1.0      Mallika Subhashini    03/26/2019
2.0         Dinesh Yadav        11/10/2020
***********************************************************************/
global class FSL_CL_GETSOLUTIONS {
    @AuraEnabled
    global static List<WrapObject> wrapRec(id serviceOrderId,string spn,String cumminsfaultCode,string pcode,
                                           string highLevelSymptom,string lowLevelSymptom) 
    {
        // WorkOrder wo;
        List<WrapObject> WrapObjects = new List<WrapObject>();
        Map<id,list<CSS_Solutions__c>> solMap= new Map<id,list<CSS_Solutions__c>>();
        set<Id> fcId=new set<Id>();
        List<CSS_Fault_Code__c> fau=new  List<CSS_Fault_Code__c>();
        System.debug('Here');
        System.debug('serviceOrderId '+serviceOrderId);
        System.debug('cumminsfaultCode '+cumminsfaultCode); //used for Cummins Fault Code Search
        System.debug('lowLevelSymptom '+lowLevelSymptom);   //used for Symtom search
        System.debug('spn '+spn);
        System.debug('pcode '+pcode);
        System.debug('highLevelSymptom '+highLevelSymptom);
        // if(intFlag){
        FSL_SymptomfcSearch.callODMHeaderService(serviceOrderId,spn,cumminsfaultCode,pcode,highLevelSymptom,lowLevelSymptom);
        // }
        
        fau = [SELECT Id, Name, Service_Order__c, Number_of_Solutions__c, Fault_Code_Type__c, Service_Order__r.FSL_Locked_Assest__c,Fault_Code_Description__c, 
               Service_Order__r.ESN_Insite__c, Service_Order__r.Asset.Name, 
               (SELECT Id, Name FROM CSS_Solutions__r) FROM CSS_Fault_Code__c 
               WHERE Service_Order__c =: serviceOrderId 
               AND (Fault_Code_Type__c = '0' OR Fault_Code_Type__c = '1' OR Fault_Code_Type__c = '2' OR Fault_Code_Type__c = '3') ORDER BY LastModifieddate DESC];
        system.debug('*serviceOrderId***'+serviceOrderId);
        system.debug('*fau***'+fau);
        
        boolean SearchFound = false;       //CT3-354
        for(CSS_Fault_Code__c cfc:fau) {
            fcId.add(cfc.id);
            
            if(cumminsfaultCode != null || cfc.Name == lowLevelSymptom || (string.isBlank(cumminsfaultCode) && string.isBlank(lowLevelSymptom) && string.isBlank(highLevelSymptom))){
                SearchFound = true;
            }
            
            //  fcId.add(cfc.Fault_Code_Description__c);
        }
        
        //CT3-354
        if(SearchFound == false){
            CSS_Fault_Code__c fc = new CSS_Fault_Code__c();
            if(string.isNotBlank(lowLevelSymptom))
                fc.Name=lowLevelSymptom;
            else if(string.isNotBlank(highLevelSymptom))
                fc.Name=lowLevelSymptom;
            else if(string.isNotBlank(cumminsfaultCode)){ //PHOEN-28, Dinesh Yadav, 11 Nov 2021.
                FSL_Fault_Code__c cumminsRecord =  [SELECT Id, Name FROM FSL_Fault_Code__c WHERE id=:cumminsfaultCode LIMIT 1];
                fc.Name=cumminsRecord.Name;               
            }
            
            fc.Number_of_Solutions__c = '0';
            fc.Fault_Code_Type__c ='0';
            fc.Service_Order__c = serviceOrderId;
            insert fc;
            WrapObject wobj=new WrapObject(fc,null,null,null);
            WrapObjects.add(wobj);
        }
        
        List<CSS_Solutions__c> solLi = [SELECT Id, Name, Solution_Title__c, userTimestamp__c, FSL_Solution_Position__c, Diagnostic_Response__c, 
                                        FaultCode__c, Repair_Response__c FROM CSS_Solutions__c WHERE FaultCode__c in:fcId AND userTimestamp__c!=null ORDER BY userTimestamp__c];
        
        for(CSS_Solutions__c cs:solLi) {
            if(solMap.containsKey(cs.FaultCode__c) && solMap.get(cs.FaultCode__c) != null) {
                List<CSS_Solutions__c> sollist = solMap.get(cs.FaultCode__c);
                sollist.add(cs);
                solMap.put(cs.FaultCode__c,sollist);
            }
            else {
                solMap.put(cs.FaultCode__c, new List<CSS_Solutions__c> {cs});
            }
        }
        system.debug('**solMap**'+solMap);
        // Map<Id, Decimal> mapDigTimeByFaultCodeId = new Map<Id, Decimal>();
        // Map<Id, Decimal> mapRepairTimeByFaultCodeId = new Map<Id, Decimal>();
        /*  for(CSS_Fault_Code__c fcode : fau) {
// WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),null,null);
WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
WrapObjects.add(wobj);
} */
        
        Map<Id,List<FSL_SRT__c>> mapListSRTByFaultCodeId = new Map<Id,List<FSL_SRT__c>>();
        List<FSL_SRT__c> objSRTList = [SELECT Id, CSS_Fault_Code__c, SRT_Time__c, Type__c, SRT_Select__c, Repair_SRTs_Boolean__c 
                                       FROM FSL_SRT__c 
                                       WHERE SRT_Select__c=TRUE AND (Type__c = 'Diagnosis' OR Type__c = 'Repair' OR Type__c = 'Diag Access' OR Type__c = 'Repair Access')
                                       AND CSS_Fault_Code__c IN: fcId AND Solution_Number__c IN : solLi ];  
        
        System.debug('objSRTList'+objSRTList);
        
        for(FSL_SRT__c srtList : objSRTList) {
            List<FSL_SRT__c> listTempSRT = new List<FSL_SRT__c>();
            if(mapListSRTByFaultCodeId.containsKey(srtList.CSS_Fault_Code__c)) {
                listTempSRT = mapListSRTByFaultCodeId.get(srtList.CSS_Fault_Code__c);
            }
            listTempSRT.add(srtList);
            mapListSRTByFaultCodeId.put(srtList.CSS_Fault_Code__c, listTempSRT);
        }
        System.debug('Map List SRT Fault Codes'+mapListSRTByFaultCodeId);
        
        Map<Id, Decimal> mapDigTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmDigTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)) {
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && (objSRT.Type__c == 'Diagnosis' || objSRT.Type__c == 'Diag Access'))
                    dcmDigTime = dcmDigTime + objSRT.SRT_Time__c;
            }
            mapDigTimeByFaultCodeId.put(idKey, dcmDigTime);
        }
        System.debug('map DigTime By FaultCodeId'+mapDigTimeByFaultCodeId);
        
        Map<Id, Decimal> mapRepairTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmRepairTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)) {
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && objSRT.Repair_SRTs_Boolean__c == true && (objSRT.Type__c == 'Repair' || objSRT.Type__c == 'Repair Access'))
                    dcmRepairTime = dcmRepairTime + objSRT.SRT_Time__c;
            }
            mapRepairTimeByFaultCodeId.put(idKey, dcmRepairTime);
        }
        System.debug('map DigTime By FaultCodeId'+mapRepairTimeByFaultCodeId);
        
        /*  for(CSS_Fault_Code__c fcode : fau) {
WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
WrapObjects.add(wobj);
}*/
        
        /* ----- CT3-112, Added Fault codes /Symptoms Searched field values ---- */
        WorkOrder objWorkOrder = [select Id, Fault_codes_Symptoms_Searched__c, FSL_Locked_Assest__c, AssetId from WorkOrder where id=:serviceOrderId];
        string strFaultCodeSymtoms = '';
        
        for(CSS_Fault_Code__c fcode : fau) {
            // WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),null,null);
            WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
            WrapObjects.add(wobj);
            
            if(string.isNotBlank(strFaultCodeSymtoms))
                strFaultCodeSymtoms =strFaultCodeSymtoms+','+fcode.Name.trim();
            else
                strFaultCodeSymtoms =fcode.Name.trim();
        }
        
        //Piyush Start
        //to lock asset updation, if not alreay locked.
        
        Boolean checkNeedToUpdate = false;
        /*if(string.isNotBlank(cumminsfaultCode)){
string strFC = mapFaultCode.get(cumminsfaultCode);
if(objWorkOrder.Fault_codes_Symptoms_Searched__c != null){
if(objWorkOrder.Fault_codes_Symptoms_Searched__c.contains(strFC) == false){
strFaultCodeSymtoms = ', '+strFC;
}
}
else
strFaultCodeSymtoms = strFC;
}


if(string.isNotBlank(lowLevelSymptom)){
if(objWorkOrder.Fault_codes_Symptoms_Searched__c != null){
if(objWorkOrder.Fault_codes_Symptoms_Searched__c.contains(lowLevelSymptom) == false){
if(string.isNotBlank(strFaultCodeSymtoms))
strFaultCodeSymtoms =strFaultCodeSymtoms + ', '+lowLevelSymptom;
else
strFaultCodeSymtoms =', '+lowLevelSymptom;
}
}
else{
if(string.isNotBlank(strFaultCodeSymtoms))
strFaultCodeSymtoms =strFaultCodeSymtoms + ', '+lowLevelSymptom;
else
strFaultCodeSymtoms = lowLevelSymptom;
}
}


if(string.isNotBlank(strFaultCodeSymtoms)){
objWorkOrder.Fault_codes_Symptoms_Searched__c = strFaultCodeSymtoms;
checkNeedToUpdate = true;
} 
*/
        system.debug('strFaultCodeSymtoms ::'+strFaultCodeSymtoms);
        system.debug('objWorkOrder.Fault_codes_Symptoms_Searched__c ::'+objWorkOrder.Fault_codes_Symptoms_Searched__c);
        if(string.isNotBlank(strFaultCodeSymtoms)){
            if(objWorkOrder.Fault_codes_Symptoms_Searched__c != null){
                String[] arrTest = strFaultCodeSymtoms.split(',');
                for(string strFCName : arrTest){
                    strFCName = strFCName.trim();
                    if(objWorkOrder.Fault_codes_Symptoms_Searched__c.contains(strFCName)==false){
                        //objWorkOrder.Fault_codes_Symptoms_Searched__c = objWorkOrder.Fault_codes_Symptoms_Searched__c+','+strFCName;
                        system.debug('Inside for loop ::'+objWorkOrder.Fault_codes_Symptoms_Searched__c);
                        checkNeedToUpdate = true;
                    }
                }
            }
            else{
                //objWorkOrder.Fault_codes_Symptoms_Searched__c = strFaultCodeSymtoms;
                checkNeedToUpdate = true;
            }
        }
        system.debug('In last::'+objWorkOrder.Fault_codes_Symptoms_Searched__c);
        //---------CT3-112 end here-----//
        
        if(!fau.isEmpty() ) {
            system.debug('###**'+fau[0].Service_Order__r.FSL_Locked_Assest__c);
            if(fau[0].Service_Order__r.FSL_Locked_Assest__c == null  || fau[0].Service_Order__r.FSL_Locked_Assest__c =='') {
                //Workorder wo = new Workorder();
                //objWorkOrder.id=serviceOrderId;
                //Piyush Asset Lockdown
                objWorkOrder.FSL_Locked_Assest__c = fau[0].Service_Order__r.asset.name;
                system.debug('objWorkOrder update**'+objWorkOrder);
                FSL_CL_RetrieveOptionList.insertOptions(objWorkOrder.FSL_Locked_Assest__c,serviceOrderId);
                system.debug('Asset:'+objWorkOrder.AssetId);
                checkNeedToUpdate = true;
                //update wo;
            }   
            //Added by Sriprada to trigger Options service if it fails on first pull of fault code
            else if(fau[0].Service_Order__r.FSL_Locked_Assest__c != null && fau[0].Service_Order__r.FSL_Locked_Assest__c !='') {
                FSL_CL_RetrieveOptionList.insertOptions(objWorkOrder.FSL_Locked_Assest__c,serviceOrderId);

            }
            
        }
        system.debug('strFaultCodeSymtoms :: '+strFaultCodeSymtoms +' :: objWorkOrder:'+objWorkOrder);
        if(checkNeedToUpdate == true){
            update objWorkOrder;
        }
        //Piyush End
        system.debug('**WrapObjects***'+WrapObjects);
        return WrapObjects;
    }
    
    // for table by Mallika
    @AuraEnabled
    global static List<WrapObject> wrapRecTable(id serviceOrderId,string spn,String cumminsfaultCode,string pcode,
                                                string highLevelSymptom,string lowLevelSymptom)
    {
        // WorkOrder wo;
        List<WrapObject> WrapObjects = new List<WrapObject>();
        Map<id,list<CSS_Solutions__c>> solMap= new Map<id,list<CSS_Solutions__c>>();
        set<Id> fcId=new set<Id>();
        List<CSS_Fault_Code__c> fau=new  List<CSS_Fault_Code__c>();
        System.debug('Here');
        System.debug('serviceOrderId '+serviceOrderId);
        System.debug('cumminsfaultCode '+cumminsfaultCode);
        System.debug('lowLevelSymptom '+lowLevelSymptom);
        System.debug('spn '+spn);
        System.debug('pcode '+pcode);
        System.debug('highLevelSymptom '+highLevelSymptom);
        // if(intFlag){
        //  FSL_SymptomfcSearch.callODMHeaderService(serviceOrderId,spn,cumminsfaultCode,pcode,highLevelSymptom,lowLevelSymptom);
        // }
        
        fau = [SELECT Id, Name, Service_Order__c, Number_of_Solutions__c, Fault_Code_Type__c, Service_Order__r.FSL_Locked_Assest__c, Fault_Code_Description__c,
               Service_Order__r.ESN_Insite__c,  Service_Order__r.Asset.Name, 
               (SELECT Id, Name FROM CSS_Solutions__r) FROM CSS_Fault_Code__c 
               WHERE Service_Order__c =: serviceOrderId 
               AND (Fault_Code_Type__c = '0' OR Fault_Code_Type__c = '1' OR Fault_Code_Type__c = '2' OR Fault_Code_Type__c = '3') ORDER BY LastModifieddate DESC];
        system.debug('*serviceOrderId***'+serviceOrderId);
        system.debug('*fau***'+fau);
        for(CSS_Fault_Code__c cfc:fau) {
            fcId.add(cfc.id);
            //  fcId.add(cfc.Fault_Code_Description__c);
        }
        List<CSS_Solutions__c> solLi=[SELECT Id, Name, Solution_Title__c, userTimestamp__c, FSL_Solution_Position__c, Diagnostic_Response__c, 
                                      FaultCode__c,Repair_Response__c,
                                      FSL_Service_Job__r.Service_Order_Extension__r.FSL_ABRFlag__c // Added by Prasanna to remove the displaying Solution ID for FTR Event - ROAD -474 
                                      FROM CSS_Solutions__c WHERE FaultCode__c in:fcId AND userTimestamp__c!=null ORDER BY userTimestamp__c];
        
        for(CSS_Solutions__c cs:solLi) {
            if(solMap.containsKey(cs.FaultCode__c) && solMap.get(cs.FaultCode__c) != null) {
                List<CSS_Solutions__c> sollist = solMap.get(cs.FaultCode__c);
                sollist.add(cs);
                solMap.put(cs.FaultCode__c,sollist);
            }
            else {
                solMap.put(cs.FaultCode__c, new List<CSS_Solutions__c> {cs});
            }
        }
        system.debug('**solMap**'+solMap);
        Map<Id,List<FSL_SRT__c>> mapListSRTByFaultCodeId = new Map<Id,List<FSL_SRT__c>>();
        List<FSL_SRT__c> objSRTList = [SELECT Id, CSS_Fault_Code__c, SRT_Time__c, Type__c, SRT_Select__c, Repair_SRTs_Boolean__c
                                       FROM FSL_SRT__c 
                                       WHERE SRT_Select__c=TRUE AND (Type__c='Diagnosis' OR Type__c='Repair' OR Type__c='Diag Access' OR Type__c='Repair Access')
                                       AND CSS_Fault_Code__c IN: fcId AND Solution_Number__c IN : solLi ];
        
        System.debug('objSRTList'+objSRTList);
        
        for(FSL_SRT__c srtList : objSRTList) {
            List<FSL_SRT__c> listTempSRT = new List<FSL_SRT__c>();
            if(mapListSRTByFaultCodeId.containsKey(srtList.CSS_Fault_Code__c)) {
                listTempSRT = mapListSRTByFaultCodeId.get(srtList.CSS_Fault_Code__c);
            }
            listTempSRT.add(srtList);
            mapListSRTByFaultCodeId.put(srtList.CSS_Fault_Code__c, listTempSRT);
        }
        System.debug('Map List SRT Fault Codes'+mapListSRTByFaultCodeId);
        
        Map<Id, Decimal> mapDigTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmDigTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)){
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && (objSRT.Type__c == 'Diagnosis' || objSRT.Type__c == 'Diag Access'))
                    dcmDigTime = dcmDigTime + objSRT.SRT_Time__c;
            }
            mapDigTimeByFaultCodeId.put(idKey, dcmDigTime);
        }
        System.debug('map DigTime By FaultCodeId'+mapDigTimeByFaultCodeId);
        
        Map<Id, Decimal> mapRepairTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmRepairTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)){
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && objSRT.Repair_SRTs_Boolean__c == true && (objSRT.Type__c == 'Repair' || objSRT.Type__c == 'Repair Access') )
                    dcmRepairTime = dcmRepairTime + objSRT.SRT_Time__c;
            }
            mapRepairTimeByFaultCodeId.put(idKey, dcmRepairTime);
        }
        System.debug('map DigTime By FaultCodeId'+mapRepairTimeByFaultCodeId);
        
        for(CSS_Fault_Code__c fcode : fau) {
            // WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),null,null);
            WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
            WrapObjects.add(wobj);
        }
        
        //Piyush Start
        //to lock asset updation, if not alreay locked.
        if(!fau.isEmpty() ) {
            system.debug('###**'+fau[0].Service_Order__r.FSL_Locked_Assest__c);
            if(fau[0].Service_Order__r.FSL_Locked_Assest__c == null || fau[0].Service_Order__r.FSL_Locked_Assest__c == '') {
                Workorder wo = new Workorder();
                wo.Id = serviceOrderId;
                //Piyush Asset Lockdown
                wo.FSL_Locked_Assest__c = fau[0].Service_Order__r.Asset.Name;
                system.debug('wo update**'+wo);
                FSL_CL_RetrieveOptionList.insertOptions(wo.FSL_Locked_Assest__c,serviceOrderId);
                system.debug('Asset:'+wo.AssetId);
                update wo;
            }
        }
        //Piyush End
        system.debug('**WrapObjects***'+WrapObjects);
        return WrapObjects;
    }
    
    //added by sriprada
    @AuraEnabled
    public static void changeRecord(string workId,string faultID) {
        //Sruthi - Updating code logic to shift the updates on to Service Order Extension Object
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c, RecordTypeId from WorkOrder where Id =: workId];
        if(wo1.size() > 0){
            if(wo1[0].Process_Step__c == 'Repair') {
                recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
                    .get('SolutionRepair').getRecordTypeId();
            }
            
            list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
            wo1Ext = [Select Id,Service_Order_Id__c,Service_Order_Id__r.RecordTypeId from Service_Order_Extension__c where Service_Order_Id__c =: workId LIMIT 1];
            if(wo1Ext.size() > 0){
                wo1Ext[0].FaultCodeId__c   = faultID;
                system.debug('to update woExt '+wo1Ext[0]);
                    update wo1Ext;   
                
            }
             if(wo1.size() > 0){
                wo1[0].RecordTypeId     = recdtypeId;
                if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId)) {
                    update wo1;   
                    system.debug('RecordType'+recdtypeId);
                }
            }
        }//Sruthi - End

        //  Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
        //     .get('SolutionT_D').getRecordTypeId();
        /* string solname = '';
String solutionId = '';
for(CSS_Solutions__c sol :[select name from CSS_Solutions__c where Id =:solutionId])
{
solname = sol.name;
}
list<Knowledge__kav> knwList = new list<Knowledge__kav>();
knwList = [Select Id,UrlName,Validations__c,Verification__c,Repairs__c from Knowledge__kav where UrlName =:solname];
update knwList;*/
    }
    
    //Added by Sruthi Mudireddy as part of CT1-699 ----- 07/22/2021
    @AuraEnabled
    public static void changeRecordDealer(string workId,string faultID) {
        //Sruthi - Moved code logic onto Service Order Extension object
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c, RecordTypeId, Type__c from WorkOrder where Id=: workId];
        
        if(wo1.size() > 0){
            list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
            wo1Ext = [Select Id from Service_Order_Extension__c where Service_Order_Id__c =: wo1[0].Id LIMIT 1];
            if(wo1Ext.size() > 0){
                wo1Ext[0].FaultCodeId__c   = faultID;
                system.debug('to update woExt '+wo1Ext);
                if(string.isNotBlank(workId) && wo1[0].Type__c == 'Dealer') {
                    update wo1Ext;   
                }
            }
        }
    } // CodeEnds here ---- Sruthi Mudireddy
    
    // Method added by Mallika.P to update the record type on click of perform repair.
    @AuraEnabled
    public static string changesolRecord(string workId,string solId) {
        string solname='';
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c, RecordTypeId, Type__c from WorkOrder where Id =: workId];  //Piyush added Type in query for VGRS2-16
        if(wo1.size() > 0){
            if(wo1[0].Process_Step__c == 'Repair') {
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
            solname ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +sol.FSL_Solution_Position__c+'  '+sol.Solution_Title__c;
            system.debug('**solname'+solname);
        }
        else {
            solname = sol.FSL_Solution_Position__c+'\r\t\r\t\r '+sol.Solution_Title__c;
        }
        system.debug('**solname'+solname);
        
        list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
        wo1Ext = [Select Id,Service_Order_Id__c,FaultCodeId__c,Selectedsolution__c   from Service_Order_Extension__c where Service_Order_Id__c =: wo1[0].Id LIMIT 1];
        if(wo1Ext.size() > 0){
            wo1Ext[0].FaultCodeId__c =sol.FaultCode__c;
            wo1Ext[0].Selectedsolution__c=solname; //Added by Sriprada as part of VGRS2-561
            
        }
        
        if(string.isNotBlank(workId) && wo1Ext.size() > 0) {
            update wo1Ext;
            system.debug('to update wo '+wo1Ext);
        }
        //For Dealers we are using a Single record type for Work Orders. 
        //So we are adding below Conditions for Distributors.
        //wo.RecordTypeId     = recdtypeId;
        Profile po = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        UserRole userRole = [select Id,Name from UserRole WHERE Id =: UserInfo.getUserRoleId()];//Added by Piyush for VGRS2-16 11/30
        if((po != null && po.Name != null && !po.Name.containsIgnoreCase('dealer') && wo1[0].Type__c != 'Dealer') 
           || (userRole != NULL && userRole.Name != NULL && userRole.Name.EqualsIgnoreCase('Factory') && wo1[0].Type__c != 'Dealer') ) //Added by Piyush for VGRS2-16 11/30
        {
            wo1[0].RecordTypeId     = recdtypeId;                 
            system.debug('wo.RecordTypeId ' + wo1[0].RecordTypeId);
            update wo1;
        }
        //For Dealers we are using a Single record type for Work Orders. 
        //So we are adding below Conditions for Distributors.
        
        // wo.Status           = 'Repair';
        
      
        //woselecomnull(wo.id);
        return solname;
    } // End of update the record type on click of perform repair method.
    
    // Method added by Mallika.P to update the record type on click of perform repair in T&D
    @AuraEnabled
    public static string updatesolRecordtd(string workId,string solId) {
        string solname='';
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c, RecordTypeId from WorkOrder where Id =: workId];
        if(wo1.size() > 0){
            if(wo1[0].Process_Step__c == 'Triage & Diagnosis') {
                recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
                    .get('SolutionRepair').getRecordTypeId();
            }
        }
        CSS_Solutions__c sol = [SELECT Id, Name, FSL_Service_Job__c, FaultCode__c, Solution_Title__c, FSL_Solution_Position__c, 
                                Diagnostic_Notes__c, Repair_Response__c, Repair_Notes__c, Diagnostic_Response__c, userTimestamp__c, 
                                CSS_Nested_Solutions__c, CSS_Nested_Solutions__r.userTimestamp__c 
                                FROM CSS_Solutions__c WHERE Id =:solId ORDER BY FSL_Solution_Position__c];
        String position = sol.FSL_Solution_Position__c;
        String subString = position.substringAfter('.');
        system.debug('**subString'+subString);
        
        if(subString.length() > 0) {
            solname ='\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t' +sol.FSL_Solution_Position__c+'  '+sol.Solution_Title__c;
            system.debug('**solname'+solname);
        } 
        else {
            solname = sol.FSL_Solution_Position__c+'\r\t\r\t\r '+sol.Solution_Title__c;
        }
        system.debug('**solname'+solname);
        
        list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
        wo1Ext = [Select Id, Service_Order_Id__c, Selectedsolution__c,FaultCodeId__c  from Service_Order_Extension__c where Service_Order_Id__c =: wo1[0].Id LIMIT 1];
         //Added by Sriprada for VGRS2-561
        if(wo1Ext.size() > 0){
            wo1Ext[0].FaultCodeId__c   = sol.FaultCode__c;
            wo1Ext[0].Selectedsolution__c = solname;
            update wo1Ext;
        }
        
        if(wo1.size() > 0){
           // if(wo1Ext.size() > 0){
                
                wo1[0].RecordTypeId     = recdtypeId;
                wo1[0].Process_Step__c = 'Repair';
                system.debug('to update wo '+wo1Ext[0]);
                if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
                {
                    update wo1;
                    system.debug('RecordType'+recdtypeId);
                }
          //  }
        }
        //woselecomnull(wo.id);
        return solname;
    } // End of update the record type on click of perform repair method in T&D.
    
    @AuraEnabled
    Public static list<Knowledge__kav> getknowledge(String solutionId) {
        string solname = '';
        string solTitle = '';
        for(CSS_Solutions__c sol :[select name,Solution_Title__c from CSS_Solutions__c where Id =:solutionId])
        {
            solname = sol.name;
            solTitle = sol.Solution_Title__c;
        }
        
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        //-----CT3-45 ---
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
        return knowledgeList;
    }
    
    //Rajashekar
    @AuraEnabled
    global static List<WrapObject> getSolutionTable(Id serviceOrderId) {
        // WorkOrder wo;
        List<WrapObject> WrapObjects = new List<WrapObject>();
        Map<id,list<CSS_Solutions__c>> solMap = new Map<id,list<CSS_Solutions__c>>();
        set<Id> fcId = new set<Id>();
        List<CSS_Fault_Code__c> fau = new  List<CSS_Fault_Code__c>();
        System.debug('Here');
        System.debug('serviceOrderId '+serviceOrderId);
        
        // FSL_SymptomfcSearch.callODMHeaderService(serviceOrderId,spn,cumminsfaultCode,pcode,highLevelSymptom,lowLevelSymptom);
        fau = [SELECT Id, Name, Service_Order__c, Number_of_Solutions__c, Fault_Code_Type__c, Service_Order__r.FSL_Locked_Assest__c ,Fault_Code_Description__c,
               Service_Order__r.ESN_Insite__c,  Service_Order__r.Asset.Name, 
               (SELECT Id, Name FROM CSS_Solutions__r) FROM CSS_Fault_Code__c
               WHERE Service_Order__c =: serviceOrderId 
               AND (Fault_Code_Type__c='0' OR Fault_Code_Type__c='1' OR Fault_Code_Type__c='2' OR Fault_Code_Type__c='3') ORDER BY LastModifieddate DESC];
        system.debug('*serviceOrderId***'+serviceOrderId);
        system.debug('*fau***'+fau); 
        for(CSS_Fault_Code__c cfc:fau) {
            fcId.add(cfc.id);
            // fcId.add(cfc.Fault_Code_Description__c);
        }
        List<CSS_Solutions__c> solLi = [SELECT Id, Name,
                                        Solution_Title__c, userTimestamp__c, FSL_Solution_Position__c, Diagnostic_Response__c, 
                                        FaultCode__c, Repair_Response__c,
                                        FSL_Service_Job__r.Service_Order_Extension__r.FSL_ABRFlag__c // Added ABR Flag column by Prasanna for ROAD-474 
                                        FROM CSS_Solutions__c WHERE FaultCode__c in:fcId AND userTimestamp__c!=null ORDER BY userTimestamp__c];
        
        for(CSS_Solutions__c cs:solLi) {
            if(solMap.containsKey(cs.FaultCode__c) && solMap.get(cs.FaultCode__c) != null) {
                List<CSS_Solutions__c> sollist = solMap.get(cs.FaultCode__c);
                sollist.add(cs);
                solMap.put(cs.FaultCode__c,sollist);
            }
            else {
                solMap.put(cs.FaultCode__c, new List<CSS_Solutions__c> {cs});
            }
        }
        system.debug('**solMap**'+solMap);
        
        Map<Id,List<FSL_SRT__c>> mapListSRTByFaultCodeId = new Map<Id,List<FSL_SRT__c>>();
        List<FSL_SRT__c> objSRTList = [SELECT Id, CSS_Fault_Code__c, SRT_Time__c, Type__c, SRT_Select__c, Repair_SRTs_Boolean__c
                                       FROM FSL_SRT__c 
                                       WHERE SRT_Select__c=TRUE AND (Type__c='Diagnosis' OR Type__c='Repair' OR Type__c='Diag Access' OR Type__c='Repair Access')
                                       AND CSS_Fault_Code__c IN: fcId AND Solution_Number__c IN : solLi ];
        
        System.debug('objSRTList'+objSRTList);
        
        for(FSL_SRT__c srtList : objSRTList ) {
            List<FSL_SRT__c> listTempSRT = new List<FSL_SRT__c>();
            if(mapListSRTByFaultCodeId.containsKey(srtList.CSS_Fault_Code__c)) {
                listTempSRT = mapListSRTByFaultCodeId.get(srtList.CSS_Fault_Code__c);
            }
            listTempSRT.add(srtList);
            mapListSRTByFaultCodeId.put(srtList.CSS_Fault_Code__c, listTempSRT);
        }
        System.debug('Map List SRT Fault Codes'+mapListSRTByFaultCodeId);
        
        Map<Id, Decimal> mapDigTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmDigTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)) {
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && (objSRT.Type__c == 'Diagnosis' || objSRT.Type__c == 'Diag Access'))
                    dcmDigTime = dcmDigTime + objSRT.SRT_Time__c;
            }
            mapDigTimeByFaultCodeId.put(idKey, dcmDigTime);
        }
        System.debug('map DigTime By FaultCodeId'+mapDigTimeByFaultCodeId);
        
        Map<Id, Decimal> mapRepairTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()) {
            Decimal dcmRepairTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)) {
                System.debug(objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c != null && objSRT.SRT_Select__c == true && objSRT.Repair_SRTs_Boolean__c == true && (objSRT.Type__c == 'Repair' || objSRT.Type__c == 'Repair Access') )
                    dcmRepairTime = dcmRepairTime + objSRT.SRT_Time__c;
            }
            mapRepairTimeByFaultCodeId.put(idKey, dcmRepairTime);
        }
        System.debug('map DigTime By FaultCodeId'+mapRepairTimeByFaultCodeId);
        
        for(CSS_Fault_Code__c fcode : fau) {
            WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
            WrapObjects.add(wobj);
        }
        
        //Piyush Start
        //to lock asset updation, if not alreay locked.
        if(!fau.isEmpty()) {
            system.debug('###**'+fau[0].Service_Order__r.FSL_Locked_Assest__c);
            if(fau[0].Service_Order__r.FSL_Locked_Assest__c == null  || fau[0].Service_Order__r.FSL_Locked_Assest__c == '') {
                Workorder wo = new Workorder();
                wo.Id = serviceOrderId;
                //Piyush Asset Lockdown
                wo.FSL_Locked_Assest__c = fau[0].Service_Order__r.Asset.Name;
                system.debug('wo update**'+wo);
                FSL_CL_RetrieveOptionList.insertOptions(wo.FSL_Locked_Assest__c,serviceOrderId);
                system.debug('Asset:'+wo.AssetId);
                update wo;
            }
        }
        //Piyush End
        system.debug('**WrapObjects***'+WrapObjects);
        return WrapObjects;
    }
    
    global class WrapObject {
        @AuraEnabled global String recid { get; set; }
        @AuraEnabled global String FCdesc { get; set; }
        @AuraEnabled global String name { get; set; }
        @AuraEnabled global String solname { get; set; }
        @AuraEnabled global string solCount { get; set; }
        @AuraEnabled global list<CSS_Solutions__c> solList { get; set; }
        
        /* digTime and repairTime variables added By Rajashekar to show Diagnosis and Repair time in 
* Repair Soution table for each Fault Code
*/
        @AuraEnabled global Decimal digTime {get;set;}
        @AuraEnabled global Decimal repairTime {get;set;}
        
        global list<sObject> soldes { get; set; }     
        
        global WrapObject(CSS_Fault_Code__c fc,list<CSS_Solutions__c> fcsol,Decimal digTime,Decimal repairTime ) {
            this.recid = fc.id;
            this.name = fc.name;
            this.FCdesc = fc.Fault_Code_Description__c;
            this.solCount = fc.Number_of_Solutions__c+' Solutions found';
            this.solList = fcsol;
            this.digTime = digTime;
            this.repairTime = repairTime;
            //this.solCount = fc.CSS_Solutions__r.size()+' Solutions found';
            //this.solname = fc.CSS_Solutions__r.name;
        }
    }
}