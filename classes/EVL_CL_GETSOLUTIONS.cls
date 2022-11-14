/**********************************************************************
Name:EVL_CL_GETSOLUTIONS
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
***********************************************************************/
global class EVL_CL_GETSOLUTIONS {
    @AuraEnabled
    global static List<WrapObject> wrapRec(id serviceOrderId,string spn,String cumminsfaultCode,string pcode,
                                           string highLevelSymptom,string lowLevelSymptom) {
                                               // WorkOrder wo;
                                               //Anirudh Test
                                               
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
                                               
                                               FSL_SymptomfcSearch.callODMHeaderService(serviceOrderId,spn,cumminsfaultCode,pcode,highLevelSymptom,lowLevelSymptom);
                                               // }
                                               
                                               fau = [SELECT Id, Name, Service_Order__c, Number_of_Solutions__c, Fault_Code_Type__c, Service_Order__r.FSL_Locked_Assest__c,Fault_Code_Description__c, 
                                                      Service_Order__r.ESN_Insite__c, Service_Order__r.Asset.Name, 
                                                      (SELECT Id, Name FROM CSS_Solutions__r) FROM CSS_Fault_Code__c 
                                                      WHERE Service_Order__c =: serviceOrderId 
                                                      AND (Fault_Code_Type__c='0' OR Fault_Code_Type__c='1' OR Fault_Code_Type__c='2' OR Fault_Code_Type__c='3') ORDER BY LastModifieddate DESC];
                                             
                                               system.debug('*serviceOrderId***'+serviceOrderId);
                                               system.debug('*fau***'+fau);
                                               for(CSS_Fault_Code__c cfc:fau) {
                                                   fcId.add(cfc.id);
                                                 //  fcId.add(cfc.Fault_Code_Description__c);
                                               }
                                               
                                               List<CSS_Solutions__c> solLi=[SELECT Id, Name, Solution_Title__c, userTimestamp__c, FSL_Solution_Position__c, Diagnostic_Response__c, 
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
                                               
                                               for(CSS_Fault_Code__c fcode : fau) {
                                                   // WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),null,null);
                                                   WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
                                                   WrapObjects.add(wobj);
                                               }
                                               //Piyush Start
                                               //to lock asset updation, if not alreay locked.
                                               if(!fau.isEmpty() ) {
                                                   system.debug('###**'+fau[0].Service_Order__r.FSL_Locked_Assest__c);
                                                   if(fau[0].Service_Order__r.FSL_Locked_Assest__c == null || fau[0].Service_Order__r.FSL_Locked_Assest__c !='') {
                                                       Workorder wo = new Workorder();
                                                       wo.id=serviceOrderId;
                                                       //Piyush Asset Lockdown
                                                       
                                                       wo.FSL_Locked_Assest__c = fau[0].Service_Order__r.asset.name;
                                                       system.debug('wo update**'+wo);
                                                       
                                                       FSL_CL_RetrieveOptionList.insertOptions(wo.FSL_Locked_Assest__c,serviceOrderId);
                                                       system.debug('Asset:'+wo.AssetId);
                                                       wo.EVL_Solution_Marked_Most_Likely__c = false;                                                      
                                                       update wo;
                                                   }
                                                   //Added by Sriprada to trigger Options service if it fails on first pull of fault code
                                                   else if(fau[0].Service_Order__r.FSL_Locked_Assest__c != null && fau[0].Service_Order__r.FSL_Locked_Assest__c !='') {
                                                       FSL_CL_RetrieveOptionList.insertOptions(fau[0].Service_Order__r.FSL_Locked_Assest__c,serviceOrderId);
                                                       
                                                   }
                                               }
                                               //CT1-532                                               
                                             if(serviceOrderId!=null){
                                                   List<Case> caseRecodList=[Select id,status from case where ServiceJob__c=:serviceOrderId];
                                                   if(!caseRecodList.isEmpty()){
                                                       Case caseRecord =new Case();
                                                       caseRecord.id=caseRecodList[0].id;
                                                       caseRecord.Bypass_Validation_Rule__c =true;
                                                       caseRecord.Status='Triage & Diagnosis';
                                                       //VGRS2-672  by Priyanka
                                                    //  update caseRecord; 
                                                     //  caseRecord.Bypass_Validation_Rule__c =false;
                                                     //  update caseRecord;
                                                     ID jobID = System.enqueueJob(new FSL_CaseQueueable(caseRecord));
                                                   }
                                               }
                                               //Piyush End
                                               
                                               system.debug('**WrapObjects***'+WrapObjects);
                                               return WrapObjects;
                                           }
    
    // for table by Mallika
    @AuraEnabled
    global static List<WrapObject> wrapRecTable(id serviceOrderId,string spn,String cumminsfaultCode,string pcode,
                                                string highLevelSymptom,string lowLevelSymptom) {
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
                                                           AND (Fault_Code_Type__c='0' OR Fault_Code_Type__c='1' OR Fault_Code_Type__c='2' OR Fault_Code_Type__c='3') ORDER BY LastModifieddate DESC];
                                                    system.debug('*serviceOrderId***'+serviceOrderId);
                                                    system.debug('*fau***'+fau);
                                                    for(CSS_Fault_Code__c cfc:fau) {
                                                        fcId.add(cfc.id);
                                                      //  fcId.add(cfc.Fault_Code_Description__c);
                                                    }
                                                    List<CSS_Solutions__c> solLi=[SELECT Id, Name, Solution_Title__c, userTimestamp__c, FSL_Solution_Position__c, Diagnostic_Response__c, 
                                                                                  FaultCode__c,Repair_Response__c,
                                                                                  FSL_Service_Job__r.Service_Order_Extension__r.FSL_ABRFlag__c //Added by Prasanna to remove the displaying Solution ID for FTR Event - ROAD -474
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
                                                    
                                                    /*  for(CSS_Fault_Code__c fcode : fau) {
                                                    WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
                                                    WrapObjects.add(wobj);
                                                    }*/
                                                    
                                                    for(CSS_Fault_Code__c fcode : fau) {
                                                        // WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),null,null);
                                                        WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
                                                        WrapObjects.add(wobj);
                                                    }
                                                    //Piyush Start
                                                    //to lock asset updation, if not alreay locked.
                                                    if(!fau.isEmpty() ) {
                                                        system.debug('###**'+fau[0].Service_Order__r.FSL_Locked_Assest__c);
                                                        if(fau[0].Service_Order__r.FSL_Locked_Assest__c == null  || fau[0].Service_Order__r.FSL_Locked_Assest__c =='') {
                                                            Workorder wo = new Workorder();
                                                            wo.id=serviceOrderId;
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
    public static string changeRecord(string workId,string faultID,string TabName)
    {
        //Sruthi - Moved logic onto Service Order Extension Object
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c,AssetId,Asset.Make__c,Asset.Model__c, Asset.Equipment_Id__c, RecordTypeId from WorkOrder where Id =: workId];
        if(wo1.size() > 0){
            if(wo1[0].Process_Step__c == 'Repair'){
                recdtypeId = Schema.SObjectType.Service_Order_Extension__c.getRecordTypeInfosByDeveloperName()
                    .get('SolutionRepair').getRecordTypeId();
            }
        }
        //  Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
        //     .get('SolutionT_D').getRecordTypeId();
        Service_Order_Extension__c woExt        = new Service_Order_Extension__c();
        list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
        wo1Ext = [Select Id,FaultCodeId__c from Service_Order_Extension__c where Service_Order_Id__c =: wo1[0].Id LIMIT 1];
        if(wo1Ext.size() > 0){
            woExt.Id            = wo1Ext[0].Id;
            woExt.FaultCodeId__c    = faultID;
        }
       // wo.RecordTypeId   = recdtypeId;Commented By Anirudh for Dealer POC. Can be reverted later.
        //Added by Anirudh for Dealer Evolution POC.Can be removed during Sprint Work.
        // commenting this for VGRS2-201 by Priyanka
       /* if(TabName == 'Triage & Diagnosis'){
        WO.Status = 'Triage & Diagnosis';  
        WO.Process_Step__c = 'Triage & Diagnosis';
        WO.EVL_Stage__c = 'Triage & Diagnosis';
        } 
        else 
        if(TabName == 'Repair'){
         WO.Status = 'Repair';
        WO.Process_Step__c = 'Repair';
        WO.EVL_Stage__c = 'Repair';
    } */
            //Added by Anirudh for Dealer Evolution POC.Can be removed during Sprint Work.-End.
        system.debug('to update wo '+woExt);
        system.debug('to update woValues '+wo1[0].Asset.Make__c+wo1[0].Asset.Model__c+wo1[0].Asset.Equipment_Id__c);
        
        /* Added by Sriprada for POC of MakeModel lockdown before proceeding to Troubleshooting*/
        String errMsg;
        if(string.isBlank(wo1[0].Asset.Make__c) && string.isBlank(wo1[0].Asset.Model__c) && string.isBlank(wo1[0].Asset.Equipment_Id__c)){
            system.debug('to update wo '+errMsg);

            errMsg = 'No data';
        }
        else if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId) && wo1Ext.size() > 0 && string.isNotBlank(wo1[0].Asset.Make__c) && string.isNotBlank(wo1[0].Asset.Model__c) && string.isNotBlank(wo1[0].Asset.Equipment_Id__c))
        {   
            errMsg = 'Success';
            update woExt;   
            system.debug('RecordType'+recdtypeId);
        }    
        system.debug('to update wo '+errMsg);

        return errMsg; /* Code ends here --- Sriprada */
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
    @AuraEnabled
    public static string validateMMOnWO(string workOrderId){
        WorkOrder wo = [Select Id, AssetId, Asset.Make__c, Asset.Model__c, Asset.Equipment_Id__c, Mileage__c, CSS_Hours__c, Application__c from WorkOrder where Id =: workOrderId LIMIT 1];
        String errMsg;
        if(string.isBlank(wo.Asset.Make__c) && string.isBlank(wo.Asset.Model__c) && string.isBlank(wo.Asset.Equipment_Id__c)){
            system.debug('to update wo '+errMsg);
            
            errMsg = 'No data';
        }
        
        return errMsg;
    }
    // Method added by Mallika.P to update the record type on click of perform repair.
    @AuraEnabled
    public static string changesolRecord(string workId,string solId)
    {
        //Sruthi - Moved entire logic onto Service Order Extension object
        string solname='';
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        list<WorkOrder> wo1 = new list<WorkOrder>();
        wo1 = [Select id,Process_Step__c, RecordTypeId from WorkOrder where Id =: workId];
        if(wo1.size() > 0){
            if(wo1[0].Process_Step__c == 'Repair'){
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
        wo1Ext = [Select Id,Service_Order_Id__c ,Selectedsolution__c  from Service_Order_Extension__c where Service_Order_Id__c =: wo1[0].Id LIMIT 1];
        if(wo1Ext.size() > 0){
            wo1Ext[0].FaultCodeId__c    =sol.FaultCode__c;
            wo1Ext[0].Selectedsolution__c=solname; 
            system.debug('to update wo '+wo1Ext[0]);
            if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
            {
                update wo1Ext;
                system.debug('RecordType'+recdtypeId);
            }
        }
                
        //For Dealers we are using a Single record type for Work Orders. 
        //So we are commenting recordtype code.
        //wo.RecordTypeId   = recdtypeId;
        //For Dealers we are using a Single record type for Work Orders. 
        //So we are commenting recordtype code.

        // wo.Status           = 'Repair';
        //woselecomnull(wo.id);
        return solname;
    } // End of update the record type on click of perform repair method.
    
    // Method added by Mallika.P to update the record type on click of perform repair in T&D
    @AuraEnabled
    public static string updatesolRecordtd(string workId,string solId)
    {
        //Sruhti - Moved entire logic onto Service Order Extension object
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
        WorkOrder wo2 = new WorkOrder();
        Service_Order_Extension__c WorExt = new Service_Order_Extension__c();
        list<Service_Order_Extension__c> wo1Ext = new list<Service_Order_Extension__c>();
        wo1Ext = [Select Id, Service_Order_Id__c, Service_Order_Id__r.EVL_Solution_Marked_Most_Likely__c from Service_Order_Extension__c where Service_Order_Id__c =: wo1[0].Id LIMIT 1];
        // Added by Ramya - VGRS2-491 Moved the updates from wo1Ext to wo1
        if(wo1Ext.size() > 0){
            WorExt.Id = wo1Ext[0].Id;
            WorExt.FaultCodeId__c    = sol.FaultCode__c;
            WorExt.Selectedsolution__c = solname;
            update WorExt;
            
        }
        
        //woselecomnull(wo.id);
        return solname;
    } // End of update the record type on click of perform repair method in T&D.

    
    @AuraEnabled
    Public static list<Knowledge__kav> getknowledge(String solutionId)
    {
        string solname = '';
        string solTitle = '';
        for(CSS_Solutions__c sol :[select name,Solution_Title__c from CSS_Solutions__c where Id =:solutionId])
        {
            solname = sol.name;
            solTitle = sol.Solution_Title__c;
        }
        list<Knowledge__kav> knowledgeList = new list<Knowledge__kav>();
        knowledgeList = [Select Id,UrlName,Validations__c,Verification__c,Repairs__c from Knowledge__kav where UrlName =:solname];
        
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
        
        //  FSL_SymptomfcSearch.callODMHeaderService(serviceOrderId,spn,cumminsfaultCode,pcode,highLevelSymptom,lowLevelSymptom);
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
        List<CSS_Solutions__c> solLi=[SELECT Id, Name, Solution_Title__c, userTimestamp__c, FSL_Solution_Position__c, Diagnostic_Response__c, 
                                      FaultCode__c, Repair_Response__c
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
            if(fau[0].Service_Order__r.FSL_Locked_Assest__c == null  || fau[0].Service_Order__r.FSL_Locked_Assest__c =='') {
                Workorder wo = new Workorder();
                wo.id=serviceOrderId;
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
    
    //Method to get Product Mileage and Product Hours part of Reload Error fix (NIN-40)
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
    
    //Method to update Product Mileage and Product Hours NIN-40
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
}