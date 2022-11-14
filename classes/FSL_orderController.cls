/*********************************************************************************
Name:FSL_orderController
===================================================================================
===================================================================================
Purpose:                                                            
-------  
This class is to Prioritize the fault codes from Insite based on the FC type to display
Prioritized and Non-Prioritized table. 
===================================================================================
===================================================================================
History                                                            
-------                                                            
VERSION                 AUTHOR                              DATE                                   
1.0                     PiyushR                             3/27/2019
2.0                     Rajender Mittapalli                 07/25/2022
3.0                     Lochana Rajput                      08/25/2022
**********************************************************************************************/ 
global class FSL_orderController {
    @AuraEnabled
    public static List<WrapObject> fetchPriorityFaultCodes(String JobId,Integer maxSeq){
        system.debug('fetchPriorityFaultCodes****');
        id orderID = Id.valueof(JobId);
        List<WrapObject> WrapObjects = new List<WrapObject>();
        String sObjName = orderID.getSObjectType().getDescribe().getName();
        if(sObjName == 'WorkOrder'){
            WrapObjects = fetchPServiceOrderFaultCodes(JobId,maxSeq);
        }
        else{
            WrapObjects = fetchPOJobOrderFaultCodes(JobId,maxSeq);
        }
        return WrapObjects;        
    }
    @AuraEnabled
    public static List<WrapObject> fetchNonPriorityFaultCodes(String JobId,Integer maxSeq){
        List<WrapObject> WrapObjects = new List<WrapObject>();
        id orderID = Id.valueof(JobId);
        String sObjName = orderID.getSObjectType().getDescribe().getName();
        
        if(sObjName == 'WorkOrder'){
            WrapObjects = fetchNPServOrdFaultCodes(JobId,maxSeq);
        }
        else{
            WrapObjects = fetchNPOJobOrderFaultCodes(JobId,maxSeq);
        }
        return WrapObjects;        
    }
    
    @AuraEnabled
    public static List<WrapObject>  fetchPOJobOrderFaultCodes(String JobId,Integer maxSequence) {
        List<WrapObject> WrapObjects = new List<WrapObject>();
        system.debug('maxSequence**'+maxSequence);
        List<CSS_Fault_Code__c> faultCodesforSolution = new List<CSS_Fault_Code__c>();
        Map<id,CSS_Fault_Code__c> faultCodeSolutionMap = new Map<id,CSS_Fault_Code__c>();
        integer maxSeq = (maxSequence == null || maxSequence == 0)?maxSequenceMethod(JobId):maxSequence;  
        System.debug(':: maxSeq = '+maxSeq);
        System.debug('::: Query Result - '+[Select Job_Order__c, Status__c, Count__c, Fault_Code_Type__c, sequence__c from CSS_Fault_Code__c]);
        List<CSS_Fault_Code__c> priorityFaultCode = [Select Name, Primary_Fault_Code__c, isPole__c, Status__c, CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,Fault_Code_Type__c,RelatedFaultCode__c, 
                                                     Related_Fault_Code__c,Number_of_Solutions__c from CSS_Fault_Code__c where Job_Order__c =:JobId and  
                                                    (Fault_Code_Type__c ='APD-P' OR Fault_Code_Type__c ='BPD' OR Fault_Code_Type__c ='BLANK') 
                                                     and sequence__c =:maxSeq order by Order__c,sequence__c ];
        
        system.debug('priorityFaultCode**'+priorityFaultCode);
        
        for(CSS_Fault_Code__c ps : priorityFaultCode){
            if(ps.Number_of_Solutions__c == null && ps.sequence__c == maxSeq ){
                faultCodesforSolution.add(ps);
            }
        }
        if(!faultCodesforSolution.isEmpty() && !Test.isRunningTest()){
            faultCodeSolutionMap = FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions( JobId, faultCodesforSolution);
        }
        for(CSS_Fault_Code__c ps : priorityFaultCode){
            ps.Status__c =  ps.Status__c == 'A'?'Active': (ps.Status__c == 'I'?'Inactive':'');
                ps.Number_of_Solutions__c = faultCodeSolutionMap.get(ps.id)!=null?faultCodeSolutionMap.get(ps.id).Number_of_Solutions__c:ps.Number_of_Solutions__c;
            //WrapObjects.add(new WrapObject(ps));   
        }
        return WrapObjects;
    }
    @AuraEnabled
    public static List<WrapObject> fetchNPOJobOrderFaultCodes(String JobId,Integer maxSequence) {
        List<WrapObject> WrapObjects = new List<WrapObject>();
        List<CSS_Fault_Code__c> faultCodesforSolution = new List<CSS_Fault_Code__c>();
        Map<id,CSS_Fault_Code__c> faultCodeSolutionMap = new Map<id,CSS_Fault_Code__c>();
        //integer maxSeq = maxSequenceMethod(JobId);    
        integer maxSeq = (maxSequence == null || maxSequence == 0)?maxSequenceMethod(JobId):maxSequence;  
        List<CSS_Fault_Code__c> nonPriorityFaultCode = [select Job_Order__c,id,name,DSID__c,Number_of_Solutions__c,sequence__c from CSS_Fault_Code__c where Job_Order__c != null AND Job_Order__c=:JobId and  
                                                       (Fault_Code_Type__c !='APD-P' AND Fault_Code_Type__c !='APD-R' AND Fault_Code_Type__c !='BPD') and sequence__c =:maxSeq ];
        
        system.debug('nonPriorityFaultCode**'+nonPriorityFaultCode);
        for(CSS_Fault_Code__c ps : nonPriorityFaultCode){
            if(ps.Number_of_Solutions__c == null && ps.sequence__c == maxSeq ){
                faultCodesforSolution.add(ps);
            }
        }
        if(!faultCodesforSolution.isEmpty()){
            faultCodeSolutionMap = FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions( JobId, faultCodesforSolution);
        }
        for(CSS_Fault_Code__c ps : nonPriorityFaultCode){
            ps.Status__c =  ps.Status__c == 'A'?'Active': (ps.Status__c == 'I'?'Inactive':'');
                ps.Number_of_Solutions__c = faultCodeSolutionMap.get(ps.id)!=null?faultCodeSolutionMap.get(ps.id).Number_of_Solutions__c:ps.Number_of_Solutions__c;
            //WrapObjects.add(new WrapObject(ps));   
        }
        return WrapObjects;
    }
    @AuraEnabled
    global  static List<WrapObject>  fetchPServiceOrderFaultCodes(String JobId ,Integer maxSequence ) {
        system.debug('JobId***'+JobId);
         system.debug('maxSequence**'+maxSequence);
        //integer maxSeq = maxSequenceMethod(JobId);
        integer maxSeq = (maxSequence == null || maxSequence == 0)?maxSequenceMethod(JobId):maxSequence;  
        system.debug('maxSeq**'+maxSeq);
        List<CSS_Fault_Code__c> faultCodesforSolution = new List<CSS_Fault_Code__c>();
        Map<id,CSS_Fault_Code__c> faultCodeSolutionMap = new Map<id,CSS_Fault_Code__c>();
        List<WrapObject> WrapObjects = new List<WrapObject>();
        List<CSS_Fault_Code__c> priorityFaultCode = [Select id,Primary_Fault_Code__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c
                                                        , Mod__c,Fault_Code_Type__c,RelatedFaultCode__c, Fault_Code_Description__c
                                                        , Related_Fault_Code__c,Number_of_Solutions__c,name,Status__c,Count__c
                                                        , Service_Order__r.Fault_codes_Symptoms_Searched__c, Service_Order__c
                                                     from CSS_Fault_Code__c where Service_Order__c=:JobId and  
                                                     (Fault_Code_Type__c ='APD-P' OR Fault_Code_Type__c='BPD' OR Fault_Code_Type__c='BLANK') 
                                                     and sequence__c =:maxSeq order by Order__c,sequence__c ];
        system.debug('priorityFaultCode**'+priorityFaultCode);
        for(CSS_Fault_Code__c ps : priorityFaultCode){
            if(ps.Number_of_Solutions__c == null && ps.sequence__c == maxSeq){
                faultCodesforSolution.add(ps);
            }
        }
        if(!faultCodesforSolution.isEmpty() && !Test.isRunningTest()){
            faultCodeSolutionMap = FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions( JobId, faultCodesforSolution);
        }
        //added from 
        Map<id,list<CSS_Solutions__c>> solMap= new Map<id,list<CSS_Solutions__c>>();
        set<Id> fcId=new set<Id>();
        for(CSS_Fault_Code__c cfc:priorityFaultCode){
            fcId.add(cfc.id);
        }
        List<CSS_Solutions__c> solLi=[SELECT id,name,Solution_Title__c,userTimestamp__c,FSL_Solution_Position__c,Diagnostic_Response__c,
                                      FaultCode__c, Repair_Response__c,
                                      FSL_Service_Job__r.Service_Order_Extension__r.FSL_ABRFlag__c //Added by Prasanna to remove the displaying Solution ID for FTR Event - ROAD -572 
                                      FROM CSS_Solutions__c WHERE FaultCode__c in:fcId AND userTimestamp__c!=Null order by userTimestamp__c];
        
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
        
        //Added the code logic to calcualte Diagnostic time and Repair time
        Map<Id,List<FSL_SRT__c>> mapListSRTByFaultCodeId = new Map<Id,List<FSL_SRT__c>>();
        List<FSL_SRT__c> objSRTList = [SELECT Id, CSS_Fault_Code__c,SRT_Time__c,Type__c
                                       FROM FSL_SRT__c 
                                       WHERE SRT_Select__c=TRUE AND (Type__c='Diagnosis' OR Type__c='Repair')
                                       AND CSS_Fault_Code__c IN: fcId AND Solution_Number__c IN : solLi ];  
        
        System.debug('::: objSRTList - '+objSRTList);
        for(FSL_SRT__c srtList : objSRTList ){
            List<FSL_SRT__c> listTempSRT = new List<FSL_SRT__c>();
            if(mapListSRTByFaultCodeId.containsKey(srtList.CSS_Fault_Code__c)){
                listTempSRT = mapListSRTByFaultCodeId.get(srtList.CSS_Fault_Code__c);
            }
            listTempSRT.add(srtList);
            mapListSRTByFaultCodeId.put(srtList.CSS_Fault_Code__c, listTempSRT);                        
            
        }
        System.debug('::: Map List SRT Fault Codes - '+mapListSRTByFaultCodeId);
        Map<Id, Decimal> mapDigTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()){
            Decimal dcmDigTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)){
                System.debug('::: LN#169 - '+objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c!=null && objSRT.Type__c=='Diagnosis')
                    dcmDigTime = dcmDigTime + objSRT.SRT_Time__c;
            }
            mapDigTimeByFaultCodeId.put(idKey, dcmDigTime);
        }
        System.debug('::: map DigTime By FaultCodeId'+mapDigTimeByFaultCodeId);
        
        Map<Id, Decimal> mapRepairTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()){
            Decimal dcmRepairTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)){
                System.debug('::: LN#182 - '+objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c!=null && objSRT.Type__c=='Repair')
                    dcmRepairTime = dcmRepairTime + objSRT.SRT_Time__c;
            }
            mapRepairTimeByFaultCodeId.put(idKey, dcmRepairTime);
        }
        System.debug('::: map Repairtime By FaultCodeId'+mapRepairTimeByFaultCodeId);
        
        List<WorkOrder> lstUpd = new List<WorkOrder>();
        for(CSS_Fault_Code__c fcode : priorityFaultCode) {
            System.debug('::: DigTime and Repair Time for FaultCode - '+mapDigTimeByFaultCodeId.get(fcode.Id)+' and '+mapRepairTimeByFaultCodeId.get(fcode.Id));
            fcode.Status__c =  fcode.Status__c == 'A'?'Active': (fcode.Status__c == 'I'?'Inactive':'');
            fcode.Number_of_Solutions__c = faultCodeSolutionMap.get(fcode.id)!=null?faultCodeSolutionMap.get(fcode.id).Number_of_Solutions__c:fcode.Number_of_Solutions__c;
            WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
            WrapObjects.add(wobj);
            
            //CT3-269
           /* WorkOrder woUpd = new WorkOrder(Id=fcode.Service_Order__c);
            Boolean chk = false;
            if(fcode.Service_Order__r.Fault_codes_Symptoms_Searched__c != null){
                if(fcode.Service_Order__r.Fault_codes_Symptoms_Searched__c.contains(fcode.Name) == false){
                    woUpd.Fault_codes_Symptoms_Searched__c =woUpd.Fault_codes_Symptoms_Searched__c + ','+ fcode.Name;
                    chk = true;
                }
            }
            else{
                woUpd.Fault_codes_Symptoms_Searched__c = fcode.Name;
                chk = true;
            }
            if(chk == true)
                lstUpd.add(woUpd);
            */
        }
        
       /* //CT3-269
        if(lstUpd != null && lstUpd.size() >0 && Test.isRunningTest() == false){
            FSL_workorderListTriggerHandle.avoidAfterupdate=true;
            FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
            update lstUpd;
        }*/
        //added from
        /*for(CSS_Fault_Code__c ps : priorityFaultCode){
            ps.Status__c =  ps.Status__c == 'A'?'Active': (ps.Status__c == 'I'?'Inactive':'');
                ps.Number_of_Solutions__c = faultCodeSolutionMap.get(ps.id)!=null?faultCodeSolutionMap.get(ps.id).Number_of_Solutions__c:ps.Number_of_Solutions__c;
            WrapObjects.add(new WrapObject(ps));   
        }*/
        system.debug('priorityFaultCode**'+priorityFaultCode);
        System.debug('::: Wrapper Class Object - '+WrapObjects);
        return WrapObjects;
    }
    @AuraEnabled
    public static List<WrapObject>  fetchNPServOrdFaultCodes(String JobId,Integer maxSequence) {
        List<WrapObject> WrapObjects = new List<WrapObject>();
         system.debug('maxSequence**'+maxSequence);
        //integer maxSeq = maxSequenceMethod(JobId);
        integer maxSeq = (maxSequence == null || maxSequence == 0)?maxSequenceMethod(JobId):maxSequence; 
         system.debug('maxSeq**'+maxSeq);
        List<CSS_Fault_Code__c> faultCodesforSolution = new List<CSS_Fault_Code__c>();
        Map<id,CSS_Fault_Code__c> faultCodeSolutionMap = new Map<id,CSS_Fault_Code__c>();
        List<CSS_Fault_Code__c> nonPriorityFaultCode = [select Service_Order__c,id,name,DSID__c,Number_of_Solutions__c
                                                        , Status__c,Count__c,sequence__c, Related_Fault_Code__c,Fault_Code_Description__c
                                                        , Service_Order__r.Fault_codes_Symptoms_Searched__c                                                        from CSS_Fault_Code__c 
                                                        where Service_Order__c != null AND Service_Order__c=:JobId 
                                                         AND (Fault_Code_Type__c !='APD-P' AND Fault_Code_Type__c !='APD-R' AND Fault_Code_Type__c !='BPD') AND sequence__c =:maxSeq ];
        system.debug('nonPriorityFaultCode**'+nonPriorityFaultCode);
        for(CSS_Fault_Code__c ps : nonPriorityFaultCode){
            if(ps.Number_of_Solutions__c == null && ps.sequence__c == maxSeq ){
                faultCodesforSolution.add(ps);
            }
        }
        if(!faultCodesforSolution.isEmpty()){
            faultCodeSolutionMap = FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions(JobId, faultCodesforSolution);
        }
        
        //added from 
        Map<id,list<CSS_Solutions__c>> solMap= new Map<id,list<CSS_Solutions__c>>();
        set<Id> fcId=new set<Id>();
        for(CSS_Fault_Code__c cfc:nonPriorityFaultCode){
            fcId.add(cfc.id);
        }
        List<CSS_Solutions__c> solLi=[SELECT id,name,Solution_Title__c,userTimestamp__c,FSL_Solution_Position__c,Diagnostic_Response__c,
                                      FaultCode__c,Repair_Response__c,
                                      FSL_Service_Job__r.Service_Order_Extension__r.FSL_ABRFlag__c //Added by Prasanna to remove the displaying Solution ID for FTR Event - ROAD -572
                                      FROM CSS_Solutions__c WHERE FaultCode__c in:fcId AND userTimestamp__c!=Null order by userTimestamp__c];
        
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
        
        //Added the code logic to calcualte Diagnostic time and Repair time
        Map<Id,List<FSL_SRT__c>> mapListSRTByFaultCodeId = new Map<Id,List<FSL_SRT__c>>();
        List<FSL_SRT__c> objSRTList = [SELECT Id, CSS_Fault_Code__c,SRT_Time__c,Type__c
                                       FROM FSL_SRT__c 
                                       WHERE SRT_Select__c=TRUE AND (Type__c='Diagnosis' OR Type__c='Repair')
                                       AND CSS_Fault_Code__c IN: fcId AND Solution_Number__c IN : solLi ];  
        
        System.debug('::: objSRTList - '+objSRTList);
        for(FSL_SRT__c srtList : objSRTList ){
            List<FSL_SRT__c> listTempSRT = new List<FSL_SRT__c>();
            if(mapListSRTByFaultCodeId.containsKey(srtList.CSS_Fault_Code__c)){
                listTempSRT = mapListSRTByFaultCodeId.get(srtList.CSS_Fault_Code__c);
            }
            listTempSRT.add(srtList);
            mapListSRTByFaultCodeId.put(srtList.CSS_Fault_Code__c, listTempSRT);                        
            
        }
        System.debug('::: Map List SRT Fault Codes - '+mapListSRTByFaultCodeId);
        Map<Id, Decimal> mapDigTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()){
            Decimal dcmDigTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)){
                System.debug('::: LN#169 - '+objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c!=null && objSRT.Type__c=='Diagnosis')
                    dcmDigTime = dcmDigTime + objSRT.SRT_Time__c;
            }
            mapDigTimeByFaultCodeId.put(idKey, dcmDigTime);
        }
        System.debug('::: map DigTime By FaultCodeId'+mapDigTimeByFaultCodeId);
        
        Map<Id, Decimal> mapRepairTimeByFaultCodeId = new Map<Id, Decimal>();
        
        for(Id idKey : mapListSRTByFaultCodeId.keySet()){
            Decimal dcmRepairTime = 0.0;
            for(FSL_SRT__c objSRT : mapListSRTByFaultCodeId.get(idKey)){
                System.debug('::: LN#182 - '+objSRT+'******'+objSRT.SRT_Time__c);
                if(objSRT.SRT_Time__c!=null && objSRT.Type__c=='Repair')
                    dcmRepairTime = dcmRepairTime + objSRT.SRT_Time__c;
            }
            mapRepairTimeByFaultCodeId.put(idKey, dcmRepairTime);
        }
        System.debug('::: map Repairtime By FaultCodeId'+mapRepairTimeByFaultCodeId);
        
        List<WorkOrder> lstUpd = new List<WorkOrder>();
        for(CSS_Fault_Code__c fcode : nonPriorityFaultCode) {
            fcode.Status__c =  fcode.Status__c == 'A'?'Active': (fcode.Status__c == 'I'?'Inactive':'');
            fcode.Number_of_Solutions__c = faultCodeSolutionMap.get(fcode.id)!=null?faultCodeSolutionMap.get(fcode.id).Number_of_Solutions__c:fcode.Number_of_Solutions__c;
            WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id),mapDigTimeByFaultCodeId.get(fcode.Id),mapRepairTimeByFaultCodeId.get(fcode.Id));
            WrapObjects.add(wobj);
            
            //CT3-269
            /*
            WorkOrder woUpd = new WorkOrder(Id=fcode.Service_Order__c);
            Boolean chk = false;
            if(fcode.Service_Order__r.Fault_codes_Symptoms_Searched__c != null){
                if(fcode.Service_Order__r.Fault_codes_Symptoms_Searched__c.contains(fcode.Name) == false){
                    woUpd.Fault_codes_Symptoms_Searched__c =woUpd.Fault_codes_Symptoms_Searched__c + ','+ fcode.Name;
                    chk = true;
                }
            }
            else{
                woUpd.Fault_codes_Symptoms_Searched__c = fcode.Name;
                chk = true;
            }
            if(chk == true)
                lstUpd.add(woUpd);
                
            */
        }
        
       /* 
        //CT3-269
        if(lstUpd != null && lstUpd.size() >0 && Test.isRunningTest() == false){
            FSL_workorderListTriggerHandle.avoidAfterupdate=true;
            FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
            update lstUpd;
        }
        */
        /*
        for(CSS_Fault_Code__c ps : nonPriorityFaultCode){
            ps.Status__c =  ps.Status__c == 'A'?'Active': (ps.Status__c == 'I'?'Inactive':'');
                ps.Number_of_Solutions__c = faultCodeSolutionMap.get(ps.id)!=null?faultCodeSolutionMap.get(ps.id).Number_of_Solutions__c:ps.Number_of_Solutions__c;
            WrapObjects.add(new WrapObject(ps));   
        }*/
        system.debug('nonPriorityFaultCode**'+nonPriorityFaultCode);
        return WrapObjects;
    }
   /* @AuraEnabled
    public static Map<String, List<WrapObject>> fetchPriorityDetails(String JobId,Integer maxSequence){
        system.debug('JobId***'+JobId);
        //integer maxSeq = maxSequenceMethod(JobId);
        integer maxSeq = (maxSequence == null || maxSequence == 0)?maxSequenceMethod(JobId):maxSequence;  
        List<CSS_Fault_Code__c> faultCodesforSolution = new List<CSS_Fault_Code__c>();
        Map<id,CSS_Fault_Code__c> faultCodeSolutionMap = new Map<id,CSS_Fault_Code__c>();
        List<WrapObject> WrapObjects = new List<WrapObject>();
        List<CSS_Fault_Code__c> priorityFaultCode = [Select id,Primary_Fault_Code__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,Fault_Code_Type__c,RelatedFaultCode__c, 
                                                     Related_Fault_Code__c,Number_of_Solutions__c,name,Status__c,Count__c from CSS_Fault_Code__c where Service_Order__c=:JobId and Status__c != null 
                                                     and Count__c != null AND (Fault_Code_Type__c ='APD-P' OR Fault_Code_Type__c ='APD-R' OR Fault_Code_Type__c='BPD' OR Fault_Code_Type__c='BLANK') 
                                                     and sequence__c <= :maxSeq order by Order__c,sequence__c ];
        system.debug('priorityFaultCode**'+priorityFaultCode);
        for(CSS_Fault_Code__c ps : priorityFaultCode){
            if(ps.Number_of_Solutions__c == null && ps.sequence__c == maxSeq){
                faultCodesforSolution.add(ps);
            }
        }
        if(!faultCodesforSolution.isEmpty()){
            faultCodeSolutionMap = FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions( JobId, faultCodesforSolution);
        }
        
        Map<String, List<WrapObject>> faultCodeMap = new Map<String, List<WrapObject>>();
        for(CSS_Fault_Code__c ps : priorityFaultCode){
            ps.Status__c =  ps.Status__c == 'A'?'Active': (ps.Status__c == 'I'?'Inactive':'');
                ps.Number_of_Solutions__c = faultCodeSolutionMap.get(ps.id)!=null?faultCodeSolutionMap.get(ps.id).Number_of_Solutions__c:ps.Number_of_Solutions__c;
            WrapObject wrp = new WrapObject(ps);   
            
            String sftdDate = String.ValueOf(ps.CreatedDate.format('dd MMM yyyy - hh:mm a z'));
            List<WrapObject> wrapList = new List<WrapObject>();
            if(faultCodeMap.containskey(sftdDate)){
                wrapList = faultCodeMap.get(sftdDate);
            }
            wrapList.add(wrp);
            system.debug('wrp***'+wrp);
            faultCodeMap.put(sftdDate,wrapList);
            system.debug('faultCodeMap***'+faultCodeMap);
            
        }
        system.debug('priorityFaultCode**'+priorityFaultCode);
        return faultCodeMap;
    }*/
    
    @AuraEnabled
    public static Map<String, Map<String, List<WrapObject>>> fetchPriorityDetMap(String JobId,Integer maxSequence){
        system.debug('JobId***'+JobId);
        system.debug('maxSequence***'+maxSequence);
        //integer maxSeq = maxSequenceMethod(JobId);
        Map<String, Map<String, List<WrapObject>>>  priorityFullMap=new Map<String, Map<String, List<WrapObject>>> ();
        integer maxSeq = (maxSequence == null || maxSequence == 0)?maxSequenceMethod(JobId):maxSequence;  
        List<CSS_Fault_Code__c> faultCodesforSolution = new List<CSS_Fault_Code__c>();
        Map<id,CSS_Fault_Code__c> faultCodeSolutionMap = new Map<id,CSS_Fault_Code__c>();
        List<WrapObject> WrapObjects = new List<WrapObject>();
        List<CSS_Fault_Code__c> priorityFaultCode = [Select id,Primary_Fault_Code__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,Fault_Code_Type__c,RelatedFaultCode__c, 
                                                     Related_Fault_Code__c,Number_of_Solutions__c,name,Status__c,Count__c,Fault_Code_Description__c from CSS_Fault_Code__c where Service_Order__c=:JobId  
                                                     AND (Fault_Code_Type__c ='APD-P' OR Fault_Code_Type__c='BPD' OR Fault_Code_Type__c='BLANK') 
                                                     and sequence__c < :maxSeq order by Order__c,sequence__c ];
        system.debug('priorityFaultCode**'+priorityFaultCode);
        
        List<CSS_Fault_Code__c> nonPriorityFaultCode = [select Service_Order__c,CreatedDate,id,name,DSID__c,Number_of_Solutions__c,Status__c,Count__c,sequence__c, Related_Fault_Code__c, Fault_Code_Description__c from CSS_Fault_Code__c where Service_Order__c!= null AND Service_Order__c=:JobId 
                                                       AND (Fault_Code_Type__c!='APD-P' AND Fault_Code_Type__c!='APD-R' AND Fault_Code_Type__c!='BPD') and sequence__c < :maxSeq];
        system.debug('nonPriorityFaultCode**'+nonPriorityFaultCode);
        for(CSS_Fault_Code__c ps : nonPriorityFaultCode){
            if(ps.Number_of_Solutions__c == null && ps.sequence__c == maxSeq){
                faultCodesforSolution.add(ps);
            }
        }
               
        for(CSS_Fault_Code__c ps : priorityFaultCode){
            if(ps.Number_of_Solutions__c == null && ps.sequence__c == maxSeq){
                faultCodesforSolution.add(ps);
            }
        }
        system.debug('faultCodesforSolution*****'+faultCodesforSolution);
        if(!faultCodesforSolution.isEmpty()){
            faultCodeSolutionMap = FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions( JobId, faultCodesforSolution);
        }
        
        //added from 
        Map<id,list<CSS_Solutions__c>> solMap= new Map<id,list<CSS_Solutions__c>>();
        set<Id> fcId=new set<Id>();
        for(CSS_Fault_Code__c cfc:priorityFaultCode){
            fcId.add(cfc.id);
             //fcId.add(cfc.Fault_Code_Description__c);
        }
        for(CSS_Fault_Code__c cfc:nonPriorityFaultCode){
            fcId.add(cfc.id);
            // fcId.add(cfc.Fault_Code_Description__c);
        }
        List<CSS_Solutions__c> solLi=[SELECT id,name,Solution_Title__c,userTimestamp__c,FSL_Solution_Position__c,Diagnostic_Response__c,
                                      FaultCode__c,
                                      FSL_Service_Job__r.Service_Order_Extension__r.FSL_ABRFlag__c //Added by Prasanna to remove the displaying Solution ID for FTR Event - ROAD -572
                                       FROM CSS_Solutions__c WHERE FaultCode__c in:fcId AND userTimestamp__c!=Null order by userTimestamp__c];
        
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

       /* for(CSS_Fault_Code__c fcode : nonPriorityFaultCode) {
            fcode.Status__c =  fcode.Status__c == 'A'?'Active': (fcode.Status__c == 'I'?'Inactive':'');
            fcode.Number_of_Solutions__c = faultCodeSolutionMap.get(fcode.id)!=null?faultCodeSolutionMap.get(fcode.id).Number_of_Solutions__c:fcode.Number_of_Solutions__c;
            WrapObject wobj=new WrapObject(fcode,solMap.get(fcode.id));
            WrapObjects.add(wobj);
        }*/
        //

        //FaultCode_Max_Sequence__c
        //system.debug('priorityFaultCode***'+priorityFaultCode);
        Map<String,String> seqDateMap = new Map<String,String>();
        for(CSS_Fault_Code__c ps : priorityFaultCode){
            ps.Status__c =  ps.Status__c == 'A'?'Active': (ps.Status__c == 'I'?'Inactive':'');
            ps.Number_of_Solutions__c = faultCodeSolutionMap.get(ps.id)!=null?faultCodeSolutionMap.get(ps.id).Number_of_Solutions__c:ps.Number_of_Solutions__c;
            WrapObject wrp=new WrapObject(ps,solMap.get(ps.id), null, null);
           // WrapObject wrp = new WrapObject(ps);  
           
            Map<String, List<WrapObject>> faultCodeMap = new Map<String, List<WrapObject>>();
            
            String faultDate = String.ValueOf(ps.CreatedDate.format('dd MMM yyyy - hh:mm a z'));
            String seqNum = String.valueof(ps.Sequence__c);
            List<WrapObject> wrapList = new List<WrapObject>();
            seqDateMap.put(seqNum,faultDate);
            //system.debug('###priorityFullMap##'+priorityFullMap);
            if(priorityFullMap.containsKey(seqNum)){
                faultCodeMap = priorityFullMap.get(seqNum);
                //system.debug('faultCodeMap****'+faultCodeMap);
                if(faultCodeMap.containsKey('Priority')){
                    wrapList = faultCodeMap.get('Priority');
                    //system.debug('###wrapList##'+wrapList);
                }
            }
            wrapList.add(wrp); 
            //system.debug('wrapList***'+wrapList);
            faultCodeMap.put('Priority',wrapList);
            priorityFullMap.put(seqNum,faultCodeMap); 
        }
        system.debug('priorityFullMap***'+priorityFullMap);
        
        for(CSS_Fault_Code__c ps : nonPriorityFaultCode){
            ps.Status__c =  ps.Status__c == 'A'?'Active': (ps.Status__c == 'I'?'Inactive':'');
            ps.Number_of_Solutions__c = faultCodeSolutionMap.get(ps.id)!=null?faultCodeSolutionMap.get(ps.id).Number_of_Solutions__c:ps.Number_of_Solutions__c;
            WrapObject wrp=new WrapObject(ps,solMap.get(ps.id), null, null);
            
            //WrapObject wrp = new WrapObject(ps);   
            Map<String, List<WrapObject>> faultCodeMap = new Map<String, List<WrapObject>>();
           // String sftdDate = String.ValueOf(ps.CreatedDate.format('dd MMM yyyy - hh:mm a z'));
            //String sftdDate = String.valueof(ps.Sequence__c);
            String faultDate = String.ValueOf(ps.CreatedDate.format('dd MMM yyyy - hh:mm a z'));
            String seqNum = String.valueof(ps.Sequence__c);
            List<WrapObject> wrapList = new List<WrapObject>();
            seqDateMap.put(seqNum,faultDate);
            if(priorityFullMap.containsKey(seqNum)){
                faultCodeMap = priorityFullMap.get(seqNum);
                if(faultCodeMap.containsKey('NonPriority')){
                    wrapList = faultCodeMap.get('NonPriority');
                }
            }
            wrapList.add(wrp); 
            faultCodeMap.put('NonPriority',wrapList);
            priorityFullMap.put(seqNum,faultCodeMap);
        }
        system.debug('priorityFullMap***'+priorityFullMap.size());
        Map<String, Map<String, List<WrapObject>>>  priorityFullMapReturn = new Map<String, Map<String, List<WrapObject>>>();
        List<String> keyList = new List<String>();
        keyList.addAll(priorityFullMap.keyset());
        for(Integer i=keyList.size()-1; i>=0;i--)
        {
            //descValue.add(value.get(i));
            priorityFullMapReturn.put(seqDateMap.get(keyList[i]) , priorityFullMap.get(keyList[i]));
        }
        for(String priMap  :priorityFullMap.keyset()){
            system.debug('priMap***'+priMap);
            //priorityFullMapReturn.put(seqDateMap.get(priMap) , priorityFullMap.get(priMap));
        }
        return priorityFullMapReturn;
    }
    
    
    global class WrapObject {
        @AuraEnabled global String recid { get; set; }
        // @AuraEnabled global String name { get; set; }
        @AuraEnabled global String FCdesc { get; set; }
        @AuraEnabled global String diagnose { get; set; }
        @AuraEnabled global String status { get; set; }
        @AuraEnabled global Integer count { get; set; }
        @AuraEnabled global String solutionPosistion { get; set; }
        @AuraEnabled global String repairsMade { get; set; }
        @AuraEnabled global String SRTs { get; set; }
        @AuraEnabled global string solCount { get; set; }
        @AuraEnabled global list<CSS_Solutions__c> solList { get; set; }
        global list<sObject> soldes { get; set; } 
        /* digTime and repairTime variables added to show Diagnosis and Repair time */
        @AuraEnabled global Decimal digTime {get;set;}
        @AuraEnabled global Decimal repairTime {get;set;}
        @AuraEnabled global String relatedFaultCode{get;set;}
        //global WrapObject(CSS_Fault_Code__c fc) {
        
        global WrapObject(CSS_Fault_Code__c fc,list<CSS_Solutions__c> fcsol, Decimal digTime, Decimal repairTime) {
            this.recid = fc.id;
            this.solCount = (fc.Number_of_Solutions__c == null? '0':fc.Number_of_Solutions__c) + ' Solutions Found'; //String.valueOF(fc.CSS_Solutions__r.size());
            this.diagnose = fc.Name;
            this.status = fc.Status__c;
            this.FCdesc = fc.Fault_Code_Description__c;
            this.count = (integer)fc.Count__c;
            this.solutionPosistion = 'NA';
            this.repairsMade = 'NA';
            this.SRTs = 'NA';
            this.solList=fcsol;
            this.digTime = digTime;
            this.repairTime = repairTime;
            this.relatedFaultCode = fc.Related_Fault_Code__c;
        }
        
        /* global WrapObject(CSS_SymptomQA__c sym) {
        this.recid = sym.id;
        this.name = sym.name;
        this.solCount = sym.CSS_Solutions__r.size()+' Solutions found';
        // this.soldes = sym.CSS_Solutions__r.name;
        }*/
    }
    
    //added by sriprada
    @AuraEnabled
    public static void changeRecord(string workId)
    {
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName()
            .get('SolutionT_D').getRecordTypeId();
        WorkOrder wo = new WorkOrder();
        wo.Id        = workId;
        wo.RecordTypeId = recdtypeId;
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            update wo;   
        }    
        
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
    Public static list<Knowledge__kav> getknowledge(String solutionId)
    {
        string solname = '';
        string solTitle = '';
        for(CSS_Solutions__c sol :[select name,Solution_Title__c from CSS_Solutions__c where Id =:solutionId])
        {
            solname = sol.name;
            solTitle = sol.Solution_Title__c;
            
        }        
        list<Knowledge__kav> knwList = new list<Knowledge__kav>();
        knwList = [Select Id,UrlName,Validations__c,Verification__c,Repairs__c from Knowledge__kav where UrlName =:solname];
        
        return knwList;
    }
    
    public static integer maxSequenceMethod(id ordId){
        integer maxSeq=0;
        String sObjName = ordId.getSObjectType().getDescribe().getName();
        
        if(sObjName != 'WorkOrder'){
            AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:ordId]; 
            
           maxSeq = integer.valueOf(sequence [0].get('maxSeq')) != null?integer.valueOf(sequence [0].get('maxSeq')):0;
        }
        else{
            AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Service_Order__c=:ordId]; 
            system.debug('sequence***'+sequence);
            maxSeq = integer.valueOf(sequence [0].get('maxSeq')) != null?integer.valueOf(sequence [0].get('maxSeq')):0;
        }
        system.debug('maxSeq***>>>>>'+maxSeq);
        return maxSeq;
    }

    //Start Road-468 - Rajender added on 07/25/2022
    //Returns the FTR value from SOE object
    @AuraEnabled
    public static Boolean fetchFTRFlag(Id woId){
        try{
            Service_Order_Extension__c soExtensionObj = [SELECT Id, FSL_ABRFlag__c, Service_Order_Id__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =: woId LIMIT 1];
            Boolean FTRflag = soExtensionObj.FSL_ABRFlag__c;
            if(FTRflag != null){
                system.debug('FTRflag>>>>> '+ FTRflag);
                return FTRflag;
            }
            else {
                return false;
            }
        } catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    //3.0 STARTS Added by Lochana SG-114
    @AuraEnabled
    public static WrapperClass fetchFTRDetails(Id woId){
        WrapperClass obj = new WrapperClass();
        List<Service_Order_Extension__c> soExtensionObj = [SELECT Id, FSL_ABRFlag__c, Service_Order_Id__c,
                                                            Service_Order_Id__r.EVL_Stage__c
                                                        FROM Service_Order_Extension__c 
                                                        WHERE Service_Order_Id__c =: woId LIMIT 1];
        if(soExtensionObj != null && soExtensionObj.size() > 0) {
            obj.isFTR = soExtensionObj[0].FSL_ABRFlag__c;
            obj.dealerStagestr = soExtensionObj[0].Service_Order_Id__r.EVL_Stage__c;
        }
        System.debug('========='+obj);
        return obj;
    }
    
    global class WrapperClass {
        @AuraEnabled global Boolean isFTR { get; set; }
        @AuraEnabled global String dealerStagestr { get; set; }
    }

    @AuraEnabled
    public static void updateWOStatus(Id woId, String Status) {
        try {
            WorkOrder wo = new WorkOrder();
            wo.Id = woId;
            wo.EVL_Stage__c = Status;
            wo.Status = Status;
            update wo;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    //3.0 ENDS Added by Lochana SG-114

    //Updates the chevron to Job Plan
    @AuraEnabled
    public static void updateStatustoJobPlan(Id woId) {
        try {
            Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Job_Plan').getRecordTypeId();
            system.debug('record type Id >>>>>> '+recdtypeId);
            WorkOrder wo = new WorkOrder();
            wo = [Select id, Process_Step__c, Status, Sub_Status__c, RecordTypeId from WorkOrder where id=: woId];
            wo.Process_Step__c = 'Job Plan';
            wo.Status = 'Job Plan';
            wo.Sub_Status__c = '';
            wo.RecordTypeId = recdtypeId;
            update wo;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //Updates the chevron to Repair
    @AuraEnabled
    public static void updateStatustoRepair(Id woId) {
        try {
            Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
            system.debug('record type Id >>>>>> '+recdtypeId);
            WorkOrder wo = new WorkOrder();
            wo = [Select id, Process_Step__c, Status, Sub_Status__c, RecordTypeId from WorkOrder where id=: woId];
            wo.Process_Step__c = 'Repair';
            wo.Status = 'Repair';
            wo.Sub_Status__c = '';
            wo.RecordTypeId = recdtypeId;
            update wo;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    //It is to not to display the text and buttons from UI on any chevron except T&D
    @AuraEnabled
    public static Boolean getWOStatus(Id woId) {
        try {
            WorkOrder wo = new WorkOrder();
            wo = [Select id, Process_Step__c from WorkOrder where id=: woId];
            system.debug('getStatus####### '+wo.Process_Step__c);
            if(wo.Process_Step__c == 'Triage & Diagnosis') {
                system.debug('woStatus true#####');
                return true;
            } else {
                system.debug('woStatus false#####');
                return false;
            }
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    //End Road-468 - Rajender added on 07/25/2022  
}