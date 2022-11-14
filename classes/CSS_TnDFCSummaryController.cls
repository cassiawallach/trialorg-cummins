public class CSS_TnDFCSummaryController {
    public integer singleRun = 1;
    public CSS_TnDFCSummaryController(){
        noFaultCodesInsite = false;
        fireSOQL = true;
        nonPriFCbool = False;
        getNonPriFC();
    }
    //End
    public Id Ins_JobId {
        get;
        set {
            Ins_JobId = value;
            system.debug('inTndFC**'+value);
            if(singleRun == 1){
                if ( value != null) {
                    system.debug('Inside set');
                    list<CSS_Fault_Code__c> fcListnonBlank = [select Id from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId and Fault_Code_Type__c !='Blank' Limit 1];
                    if(fcListnonBlank != null && fcListnonBlank.size() > 0){
                        AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId and Id IN:fcListnonBlank];
                        
                            maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
                    }
                    
                }
                singleRun+= 1;
            }
        }
    } 
    public DateTime NewLastModified {get; set;}
    public transient String viewMode{get;set;}
    public transient Integer intLastPull;
    public transient integer maxSeq{get;set;}
    public transient Boolean noFaultCodesInsite{get;set;}
    transient List<CSS_Fault_Code__c> faultCodes {get;set;}
    public transient Boolean fireSOQL {get;set;}
    public List<CSS_Fault_Code__c> getFCCodes()
    {
        if(faultCodes == null){
            faultCodes = new List<CSS_Fault_Code__c>();
            //Integer limit = Limits.getLimitDMLRows();
            integer lmt = Limits.getLimitDMLRows();
            if('shortView'.equalsIgnoreCase(viewMode))
                lmt = 5;
            faultCodes = [Select Primary_Fault_Code__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,
                          Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c 
                          from CSS_Fault_Code__c
                          where Job_Order__c=:Ins_JobId AND (Fault_Code_Type__c ='APD-P' OR Fault_Code_Type__c ='APD-R' OR Fault_Code_Type__c='BPD' OR Fault_Code_Type__c='BLANK') and sequence__c = :maxSeq order by Order__c,sequence__c LIMIT :lmt];
            system.debug('faultCodes: '+faultCodes);
            system.debug('Ins_JobId: '+Ins_JobId);
            for (CSS_Fault_Code__c nFC : faultCodes) {
                if (nFC.Fault_Code_Type__c == 'BLANK'){
                    noFaultCodesInsite = true;
                    break;
                }
            }
            getNonPriFC();
            
            System.debug('=====fireSOQL===='+fireSOQL);
            //if(fireSOQL!=null && fireSOQL)
            //{
            fireSOQL=false;
            //BEGIN - For Solutions, Components & SRT
            lstSolsForFC = new List<CSS_Solutions__c>([select    Name, Symptom__r.Id,CSS_Nested_Solutions__c,Nested_Rank__c, CSS_Nested_Solutions__r.Name, CSS_Nested_Solutions__r.Case_Name__c,FaultCode__r.Id,FaultCode__r.isPole__c,Out_Of_order__c, Id,Case_Name__c,
                                                       Solution_Title__c,Diagnostic_Response__c,rank__c,Repair_Response__c,Diagnostic_notes__c,LastModifiedDate,Repair_Notes__c                                                             
                                                       from      CSS_Solutions__c
                                                       where     Service_Job__c=:Ins_JobId order by LastModifiedDate asc]);
            //}
            lstCompForSol = new List<CSS_Solution_Component__c>([select Id,Solutions__c,Component_Id__c,name,Quantity__c,Action__c,
                                                                 (Select Id,name,Part_Name__c,FailurepartId__c,Service_partnumber__c,Service_Job__c from CSS_Parts_Options__r where selected_part__c=true),Service_Job__c,Solutions__r.Repair_Response__c
                                                                 from CSS_Solution_Component__c where Service_Job__c=:Ins_JobId and Selected_Component__c=true]);
            
            lstParts = [Select id,Service_Job__c,selected_part__c,FailurepartId__c,FailurepartId__r.Name,RecordType.Name,Part_Name__c,part_size__c,Service_partnumber__c
                        from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Service_Job__c =:Ins_JobId order by Part_Name__c];
            
            lstSRTForFC = new List<CSS_SRT__c>([select Solution_Number__r.Symptom__r.Id,Solution_Number__r.FaultCode__r.Id, Solution_Number__c, Id, SRT_ID__c,Name,
                                                SRT_Time__c,Diagnosis_Time__c, Repair_Time__c, Solution_Number__r.Repair_Response__c,Type__c,SRT_Quantity__c,Job_Engine_Access_Code__c,
                                                isPerformed__c,Component_Id__r.Selected_Component__c from CSS_SRT__c where Job_Order__c=:Ins_JobId ]);
            //END - For Solutions, Components & SRT  
            
          
        }  
        
        return faultCodes;
    }         
    
    
    //BEGIN - Code For Solutions, Components & SRT
     public transient List<CSS_Solutions__c> lstSolsForFC; //For Solutions, Components & SRT
     public transient List<CSS_Solution_Component__c> lstCompForSol; //For Solutions, Components & SRT
     public transient List<CSS_SRT__c> lstSRTForFC; //For Solutions, Components & SRT
     public transient List<CSS_Parts_Options__c> lstParts;
    
    public map<String,List<CSS_Solutions__c>> getAllSolDetails() {
        Transient Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        transient List<CSS_Solutions__c> lstSols;
        if (!lstSolsForFC.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForFC) {                     
                if(mapSolutions.containsKey(recSolWFC.FaultCode__r.Id)) {
                    mapSolutions.get(recSolWFC.FaultCode__r.Id).add(recSolWFC);
                } else {
                    lstSols = new List<CSS_Solutions__c>{recSolWFC};
                        mapSolutions.put(recSolWFC.FaultCode__r.Id, lstSols);
                }
            }
            
        }
        return mapSolutions;
    }
    // Defect no - 62481 start
    public map<String,List<CSS_Solutions__c>> getVerSolDetails() {
        
        Transient Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        transient List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        if (!lstSolsForFC.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForFC) {
                if (recSolWFC.Diagnostic_Response__c=='Most likely the solution') {
                    if(mapSolutions.containsKey(recSolWFC.FaultCode__r.Id)) {
                        mapSolutions.get(recSolWFC.FaultCode__r.Id).add(recSolWFC);
                        
                    } else {
                        
                        lstSols = new List<CSS_Solutions__c>{recSolWFC};
                            mapSolutions.put(recSolWFC.FaultCode__r.Id, lstSols);
                        
                    }
                }
            }
        }
        //Generate a Blank Record for List
        transient CSS_Solutions__c recSolution  = new CSS_Solutions__c(name='');
        transient List<CSS_Solutions__c> lstEmptySols = new List<CSS_Solutions__c>{recSolution};
            if (!faultCodes.IsEmpty()) {
                for (CSS_Fault_Code__c recFC : faultCodes) {
                    if (!mapSolutions.containsKey(recFC.id)){
                        mapSolutions.put(recFC.id, lstEmptySols);
                    }
                }
            }
        return mapSolutions;
    }
    
    
    
    
    
    public transient boolean showpanel {get; set;}
    public transient boolean versol1{get; set;}
    public map<String,List<CSS_Solutions__c>> getAllVerSolDetails() {
        versol1= false;
        Transient Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        transient List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        
        if (!lstSolsForFC.IsEmpty()) {
            
            // showpanel = true;
            for(CSS_Solutions__c recSolWFC : lstSolsForFC) {                
                if(mapSolutions.containsKey(recSolWFC.FaultCode__r.Id)) {
                    mapSolutions.get(recSolWFC.FaultCode__r.Id).add(recSolWFC);
                    versol1= true;
                } else {
                    lstSols = new List<CSS_Solutions__c>{recSolWFC};
                        mapSolutions.put(recSolWFC.FaultCode__r.Id, lstSols);
                    versol1= true;
                }
            }
            system.debug('Test mapSolutions value>> '+mapSolutions);
        }
        //Generate a Blank Record for List
        CSS_Solutions__c recSolution  = new CSS_Solutions__c(name='');
        transient List<CSS_Solutions__c> lstEmptySols = new List<CSS_Solutions__c>{recSolution};
            if (!faultCodes.IsEmpty()) {
                for (CSS_Fault_Code__c recFC : faultCodes) {
                    if (!mapSolutions.containsKey(recFC.id)){
                        mapSolutions.put(recFC.id, lstEmptySols);
                    }
                }
            }
        return mapSolutions;
    }
    // Defect 62481 end
    public map<String,boolean> getViewAllVerSolDetails() {
        
        Transient Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        Transient map<string,boolean> showViewAllMap = new map<string,boolean>();
        transient List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        if (!lstSolsForFC.IsEmpty()) {
            // showpanel = true;
            for(CSS_Solutions__c recSolWFC : lstSolsForFC) { 
                if (recSolWFC.Diagnostic_Response__c!=null) {               
                    if(mapSolutions.containsKey(recSolWFC.FaultCode__r.Id)) {
                        mapSolutions.get(recSolWFC.FaultCode__r.Id).add(recSolWFC);
                        //  versol1 = false;
                    } else {
                        lstSols = new List<CSS_Solutions__c>{recSolWFC};
                            mapSolutions.put(recSolWFC.FaultCode__r.Id, lstSols);
                        //versol1 = false;
                    }
                }              
            }
        }
        // versol1 = true;
        //Generate a Blank Record for List
        CSS_Solutions__c recSolution  = new CSS_Solutions__c(name='');
        transient List<CSS_Solutions__c> lstEmptySols = new List<CSS_Solutions__c>{recSolution};
            if (!faultCodes.IsEmpty()) {
                for (CSS_Fault_Code__c recFC : faultCodes) {
                    if (!mapSolutions.containsKey(recFC.id)){
                        showViewAllMap.put(recFC.id, false);
                        //  versol1 = false;
                    }else{
                        showViewAllMap.put(recFC.id, true);
                    }
                }
            }
        return showViewAllMap;
    }
    
    
    
    public map<String,List<CSS_Solution_Component__c>> getRepairDetails() {
        system.debug('Inside Repair Details');
        Transient Map<String,List<CSS_Solution_Component__c>> mapCompo = new  Map<String,List<CSS_Solution_Component__c>>();
        //Map<String,List<CSS_Parts_Options__c>> mapParts = new  Map<String,List<CSS_Parts_Options__c>>();
        Transient List<CSS_Solution_Component__c> lstComps;
        //List<CSS_Parts_Options__c> lstPartsComp;
        if (!lstCompForSol.IsEmpty()) {
            for(CSS_Solution_Component__c recCompFSol : lstCompForSol) {
                //if (recCompFSol.Action__c=='') {
                if(mapCompo.containsKey(recCompFSol.Solutions__c)) {
                    mapCompo.get(recCompFSol.Solutions__c).add(recCompFSol);
                } else {
                    lstComps = new List<CSS_Solution_Component__c>{recCompFSol};
                        mapCompo.put(recCompFSol.Solutions__c,lstComps);
                }
                
                //}
                
                system.debug('mapCompo >>>>>>>>>>> 1' + mapCompo);
                
            }
            
        }
        //Generate a Blank Record for List
        Transient CSS_Solution_Component__c recComponent  = new CSS_Solution_Component__c(name='');
        Transient List<CSS_Solution_Component__c> lstEmptyComps = new List<CSS_Solution_Component__c>{recComponent};
            if (!lstSolsForFC.IsEmpty()) {
                for (CSS_Solutions__c recSOL : lstSolsForFC) {
                    if (!mapCompo.containsKey(recSOL.id)){
                        mapCompo.put(recSOL.id, lstEmptyComps);
                    }
                }
            }
        system.debug('mapCompo >>>>>>>>>>> 12' + mapCompo);
        return mapCompo;
    }
    
    
    public map<String,List<CSS_Parts_Options__c>> getPartDetails() {
        system.debug('Inside Repair Details');
        Transient Map<String,List<CSS_Parts_Options__c>> mapParts = new  Map<String,List<CSS_Parts_Options__c>>();
        Transient List<CSS_Parts_Options__c> lstPartsComp;
        if (!lstCompForSol.IsEmpty()) {
            for(CSS_Solution_Component__c recCompFSol : lstCompForSol) {
                system.debug('Inside Repair Details comp '+ recCompFSol.Id);
                system.debug('Inside Repair Details parts '+ recCompFSol.CSS_Parts_Options__r);
                if(!recCompFSol.CSS_Parts_Options__r.IsEmpty() ){
                    for(CSS_Parts_Options__c p: recCompFSol.CSS_Parts_Options__r){
                        if(p.FailurepartId__c == recCompFSol.Id){
                            system.debug('Inside Parts IF');
                            
                            if(mapParts.containsKey(p.FailurepartId__c)) {
                                mapParts.get(p.FailurepartId__c).add(p);
                            } else {
                                lstPartsComp = new List<CSS_Parts_Options__c>{p};
                                    mapParts.put(p.FailurepartId__c,lstPartsComp);
                            }
                            //lstPartsComp = new List<CSS_Parts_Options__c>{p};
                            //mapParts.put(recCompFSol.Id, lstPartsComp);
                        }
                        
                        system.debug('mapParts Inside 1st For Loop--->'+mapParts);
                        
                    }
                }
            }
            
            //system.debug('lstParts--->'+lstParts);
            system.debug('lstPartsComp--->'+lstPartsComp);
            system.debug('mapParts--->'+mapParts);
            //system.debug('mapCompo--->'+mapCompo);
        }
        //Generate a Blank Record for List
        CSS_Parts_Options__c recPart  = new CSS_Parts_Options__c(name='');
        Transient List<CSS_Parts_Options__c> lstEmptyParts = new List<CSS_Parts_Options__c>{recPart};
            if (!lstCompForSol.IsEmpty()) {
                for (CSS_Solution_Component__c recSOLComp : lstCompForSol) {
                    system.debug('mapParts Inside 2nd For Loop recSOLComp-->'+recSOLComp.Id);
                    if (!mapParts.containsKey(recSOLComp.id)){
                        mapParts.put(recSOLComp.id, lstEmptyParts);
                    }
                    system.debug('mapParts Inside 2nd For Loop--->'+mapParts);
                }
            }
        system.debug('mapParts111--->'+mapParts);
        return mapParts;
    }
    
    public map<String,String> getDiagSRTDetails() {
        Transient List<Decimal> lstDiagSRT1;
        Transient List<Decimal> lstDiagSRT2;
        Transient Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Transient Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Decimal dDiagTime;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        String sDTime;
        system.debug('KALlstSRTForFC:'+lstSRTForFC);
        if (!lstSRTForFC.isEmpty()){
            for(CSS_SRT__c recSRTWFC : lstSRTForFC) {
                if (recSRTWFC.Type__c == 'Diagnosis'){
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.FaultCode__r.Id)) {
                        mapDiagSRT.get(recSRTWFC.Solution_Number__r.FaultCode__r.Id).add(recSRTWFC.Diagnosis_Time__c);
                    } else {
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Diagnosis_Time__c};
                            mapDiagSRT.put(recSRTWFC.Solution_Number__r.FaultCode__r.Id, lstDiagSRT1);
                    }                  
                }
            }
            for (String FCId: mapDiagSRT.keyset()){
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                dDiagTime = 0.0;
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        if(dTime!=null)
                            dDiagTime = dDiagTime + dTime;
                    }
                }
                mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
            }
        }
        //Generate a Blank Record for List
        if (!faultCodes.IsEmpty()) {
            for (CSS_Fault_Code__c recFC : faultCodes) {
                if (!mapsDiaSRT.containsKey(recFC.id)){
                    mapsDiaSRT.put(recFC.id, '0.00');
                }
            }
        }      
        return mapsDiaSRT;
    }
    public map<String,String> getRepSRTDetails() {
        Transient List<Decimal> lstDiagSRT1;
        Transient List<Decimal> lstDiagSRT2;
        Transient Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Transient Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Decimal dDiagTime;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        String sDTime;
        if (!lstSRTForFC.isEmpty()){
            for(CSS_SRT__c recSRTWFC : lstSRTForFC) {
                if (recSRTWFC.Type__c == 'Repair'  && recSRTWFC.isPerformed__c==true) {
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.FaultCode__r.Id)) {
                        if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                            mapDiagSRT.get(recSRTWFC.Solution_Number__r.FaultCode__r.Id).add(recSRTWFC.Repair_Time__c);
                        }
                    } else {
                        
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Repair_Time__c};
                            if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                                mapDiagSRT.put(recSRTWFC.Solution_Number__r.FaultCode__r.Id, lstDiagSRT1);
                            }
                    }                  
                }
            }
            for (String FCId: mapDiagSRT.keyset()){
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                system.debug('shanthi lstDiagSRT1 '+lstDiagSRT1 );
                dDiagTime = 0.0;
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        if (dTime!= null)
                            dDiagTime = dDiagTime + dTime;
                    }
                }
                mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
            }
        }
        //Generate a Blank Record for List
        if (!faultCodes.IsEmpty()) {
            for (CSS_Fault_Code__c recFC : faultCodes) {
                if (!mapsDiaSRT.containsKey(recFC.id)){
                    mapsDiaSRT.put(recFC.id, '0.00');
                }
            }
        }
        return mapsDiaSRT;
    }
    public PageReference returnToFCView(){
        PageReference pageRef;
        string redirect='/apex/CSS_JobTndTs?id='+Ins_JobId;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }
    //added 
    transient public List<symQAWrapper> searchStrListWrap{get;set;}
    transient public List<symQAWrapper> qAListWrap{get;set;} 
    Transient symQAWrapper sSSymList;
    Transient symQAWrapper qASymList;
    transient List<CSS_SymptomQA__c> allRecList = new List<CSS_SymptomQA__c>(); 
    transient public List<CSS_Solutions__c> lstSolsForSym;
    transient public List<CSS_SRT__c> lstSRTForSym;
    transient public List<CSS_SymptomQA__c> lstFC = new List<CSS_SymptomQA__c>();
    
    public class symQAWrapper{
        public Transient CSS_SymptomQA__c sSList{get;set;}
        public Transient list<CSS_SymptomQA__c> searchStrWrap{get;set;}
        public Transient list<CSS_SymptomQA__c> qAWrap{get;set;}
        public Transient list<CSS_Solutions__c> solnWrap{get;set;}
        
        public symQAWrapper(){
            sSList =  new CSS_SymptomQA__c();
            searchStrWrap = new List<CSS_SymptomQA__c>();
            qAWrap = new List<CSS_SymptomQA__c>();
            solnWrap = new list<CSS_Solutions__c>();
        }
    }    
    public integer getAllSolnCount(){
        Transient AggregateResult[] solnAgg;
        solnAgg = [Select count(Id) countsoln from CSS_Solutions__c where Service_Job__c =:Ins_JobId ];
        Transient integer SolnCount = integer.valueOf(solnAgg[0].get('countsoln'));
        System.Debug('>>>>>SolnCount '+SolnCount);
        showSolutions();
        return SolnCount;
    }    
    /* Defect 62581 Start */
    public void showSolutions(){
        searchStrListWrap = new  List<symQAWrapper>();
        qAListWrap = new  List<symQAWrapper>();
        allRecList = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                      Number_of_Solutions__c,isPole__c,(select name,symptom__c,Nested_Rank__c,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.Name, CSS_Nested_Solutions__r.Case_Name__c,Solution_Title__c,Diagnostic_Response__c,Rank__c,Repair_Response__c,case_name__c  from CSS_Solutions__r order by LastModifiedDate asc) from CSS_SymptomQA__c where job_order__c=:Ins_JobId and type__c='SearchString'];
        
        
        System.debug('allRecList'+allRecList);
        
        lstFC   = allRecList; 
        /*
lstSRTForSym = new List<CSS_SRT__c>([select Solution_Number__r.Symptom__r.Id, Solution_Number__c, Id, SRT_ID__c,Name,
SRT_Time__c,Diagnosis_Time__c, Type__c,SRT_Quantity__c,Job_Engine_Access_Code__c,
isPerformed__c from CSS_SRT__c where Job_Order__c=:Ins_JobId]);

lstSolsForSym = new List<CSS_Solutions__c>([select    Symptom__r.Id,Out_Of_order__c, Id,Case_Name__c,
Solution_Title__c,Diagnostic_Response__c,Repair_Response__c                                                              
from      CSS_Solutions__c 
where     Service_Job__c=:Ins_JobId]);

lstCompForSol = new List<CSS_Solution_Component__c>([select Solutions__c,Component_Id__c,name,Quantity__c,Action__c, 
Service_Job__c,Solutions__r.Repair_Response__c 
from CSS_Solution_Component__c where Service_Job__c=:Ins_JobId]);

*/
        lstSRTForSym = lstSRTForFC;
        lstSolsForSym = lstSolsForFC;
        lstCompForSol = lstCompForSol;
        for(CSS_SymptomQA__c qA1:allRecList){
            sSSymList = new symQAWrapper();
            qASymList = new symQAWrapper();
            
            if(qA1.type__c=='SearchString'){
                System.debug('The qa is'+qa1);
                qASymList.sSList = qA1;                   
            }
            
            if(qA1.CSS_SymptomQA__r!=null && !qA1.CSS_SymptomQA__r.isEmpty()){
                for(integer i=0;i<qA1.CSS_SymptomQA__r.size();i++){
                    System.debug('The type is'+qA1.CSS_SymptomQA__r[i].Type__c);
                    System.debug('The searchstring id is'+qA1.CSS_SymptomQA__r[i].SearchString__c+ ' '+qa1.id);
                    if(qA1.CSS_SymptomQA__r[i].Type__c.equalsIgnoreCase('QA') && qA1.CSS_SymptomQA__r[i].SearchString__c == qA1.id){
                        qASymList.searchStrWrap.add(qA1.CSS_SymptomQA__r[i]);                                
                        
                    }
                }
            }
            if(qA1.CSS_Solutions__r!=null && !qA1.CSS_Solutions__r.isEmpty()){
                //System.debug('The inside soln wrap type is'+qA1.CSS_Solutions__r[i].Type__c);
                for(integer i=0;i<qA1.CSS_Solutions__r.size();i++){
                    if(qA1.CSS_Solutions__r[i].symptom__c == qA1.id){
                        //qA1.CSS_Solutions__r[i].Rank__c = qA1.CSS_Solutions__r[i].Rank__c + 1;//added by Krish on 12-04-2017.
                        qASymList.solnWrap.add(qA1.CSS_Solutions__r[i]);
                        
                    }
                }
            }
            
            
            if ( qASymList.sSList.Id!= null){
                qAListWrap.add(qASymList);
            }
            System.debug('The list is#!@#@!'+qAlistWrap);
        }
        
    }
    public PageReference navigateToRepair(){
        
        Transient String symIdPg = ApexPages.currentPage().getParameters().get('symId');
        
        system.debug('symIdPg@@@@@'+symIdPg);
        CSS_Job_Order__c workJob=[Select DSID__c,ESN__c,Application__c,Unit_Number__c,Failure_Point__c,Failure_Point_Measure__c,previous_status__c,status__c,
                                  Make__c,Model__c,Equipment_ID__c,Customer_Name__c,Shop_Work_Order__c, Service_Model__c,DSID_Creation_Timestamp__c,DSID_Status__c,DSID_WorkGroup__c
                                  from CSS_Job_Order__c where id= :Ins_JobId];        
        if (workJob.Status__c !='Repair'){
            css_job_order__c workOrder= new css_job_order__c();
            workOrder.id=workJob.id;
            workOrder.Status__c='Triage & Diagnosis/Repair';
            workOrder.Previous_Status__c=workJob.Status__c;
            update workOrder;
        }  
        PageReference pageRef;                     
        //string redirect='/apex/CSS_JobTndSymSol?id='+Wid+'&symid='+selectedSymptom;
        string redirect= '/apex/CSS_SymRepairPage?id='+Ins_JobId+'&symId='+symIdPg+'&rank=0';
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }         
    
    public boolean symversol {get; set;}
    public map<String,List<CSS_Solutions__c>> getVerSolDetailsV1() {
        symversol = false;
        Transient Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        Transient List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        if (!lstSolsForSym.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForSym) {
                // if (recSolWFC.Diagnostic_Response__c=='Most likely the solution') {
                if(mapSolutions.containsKey(recSolWFC.Symptom__r.Id)) {
                    system.debug('InsideIF2'+recSolWFC.Symptom__r.Id);
                    mapSolutions.get(recSolWFC.Symptom__r.Id).add(recSolWFC);
                    symversol = true;
                } else {
                    system.debug('InsideELSE'+recSolWFC.Symptom__r.Id);
                    lstSols = new List<CSS_Solutions__c>{recSolWFC};
                        mapSolutions.put(recSolWFC.Symptom__r.Id, lstSols);
                    symversol = true;
                }
                //}
            } 
        }
        //Generate a Blank Record for List
        Transient CSS_Solutions__c recSolution  = new CSS_Solutions__c(name='');
        Transient List<CSS_Solutions__c> lstEmptySols = new List<CSS_Solutions__c>{recSolution};
            if (!lstFC.IsEmpty()) {
                for (CSS_SymptomQA__c recFC : lstFC) {
                    if (!mapSolutions.containsKey(recFC.id)){
                        mapSolutions.put(recFC.id, lstEmptySols);
                    }
                }
            }
        //GSSC-443
        getlastmodifieddate();
        return mapSolutions;
    }
    public map<String,Boolean> getAllVerSolDetailsV1() {
        Transient Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        Transient List<CSS_Solutions__c> lstSols;
        if (!lstSolsForSym.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForSym) {
                //Defect- 83311 Valentine Story :Commented by shanthi
                //if (recSolWFC.Diagnostic_Response__c=='Most likely the solution') {
                if(mapSolutions.containsKey(recSolWFC.Symptom__r.Id)) {
                    mapSolutions.get(recSolWFC.Symptom__r.Id).add(recSolWFC);
                } else {
                    lstSols = new List<CSS_Solutions__c>{recSolWFC};
                        mapSolutions.put(recSolWFC.Symptom__r.Id, lstSols);
                }
                //}
            } 
        }
        map<string,boolean> showViewAllMap = new map<string,boolean>();
        //Generate a Blank Record for List
        if (!allRecList.IsEmpty()) {
            for (CSS_SymptomQA__c recSolWFC : allRecList) {
                if (!mapSolutions.containsKey(recSolWFC.Id)){
                    showViewAllMap.put(recSolWFC.Id, false);
                }else{
                    showViewAllMap.put(recSolWFC.Id, true);
                }
            }
        }
        return showViewAllMap;        
        
        //return mapSolutions;
    } 
    //Diagonstic
    public map<String,String> getDiagSRTDetailsV1() {
        Transient List<Decimal> lstDiagSRT1;
        Transient List<Decimal> lstDiagSRT2;
        Transient Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Transient Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Transient Decimal dDiagTime = 0.0;
        Transient integer iDiagTime;
        Transient integer iMinutes;
        Transient integer iHour;
        Transient String sDTime;
        system.debug('getDiagSRTDetailsV1:'+lstSRTForSym);
        if (!lstSRTForSym.isEmpty()){
            for(CSS_SRT__c recSRTWFC : lstSRTForSym) {
                if (recSRTWFC.Type__c == 'Diagnosis'){
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.Symptom__r.Id)) {
                        
                        mapDiagSRT.get(recSRTWFC.Solution_Number__r.Symptom__r.Id).add(recSRTWFC.Diagnosis_Time__c);
                        
                    } else {
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Diagnosis_Time__c};
                            mapDiagSRT.put(recSRTWFC.Solution_Number__r.Symptom__r.Id, lstDiagSRT1);
                        
                    }                   
                }
            }
            for (String FCId: mapDiagSRT.keyset()){
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                dDiagTime = 0.0;
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        if(dTime!=null)
                            dDiagTime = dDiagTime + dTime;
                    }
                }
                mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
                system.debug('mapsDiaSRT'+mapsDiaSRT);
            }
        }
        //Generate a Blank Record for List
        if (!lstFC.IsEmpty()) {
            for (CSS_SymptomQA__c recFC : lstFC) {
                if (!mapsDiaSRT.containsKey(recFC.id)){
                    mapsDiaSRT.put(recFC.id, '0.00');
                }
            }
        }     
        return mapsDiaSRT;
    }
    
    public map<String,String> getRepSRTDetailsV1() {
        Transient List<Decimal> lstDiagSRT1;
        Transient List<Decimal> lstDiagSRT2;
        Transient Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Transient Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Transient Decimal dDiagTime;
        Transient integer iDiagTime;
        Transient integer iMinutes;
        Transient integer iHour;
        Transient String sDTime;
        System.debug('RepairlstSRTForSym:'+lstSRTForSym);
        if (!lstSRTForSym.isEmpty()){
            for(CSS_SRT__c recSRTWFC : lstSRTForSym) {
                system.debug('Inside1stForLoop');
                if (recSRTWFC.Type__c == 'Repair' && recSRTWFC.isPerformed__c == true){
                    System.debug('FirstIFLoopRepair:');
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.Symptom__r.Id)) {
                        system.debug('shanthi if');
                        if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                            
                            mapDiagSRT.get(recSRTWFC.Solution_Number__r.Symptom__r.Id).add(recSRTWFC.Repair_Time__c);
                        }
                    } else {
                        
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Repair_Time__c};
                            system.debug('shanthi lstDiagSRT1'+lstDiagSRT1);
                        if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                            
                            mapDiagSRT.put(recSRTWFC.Solution_Number__r.Symptom__r.Id, lstDiagSRT1);
                        }
                    }                   
                }
            }
            for (String FCId: mapDiagSRT.keyset()){
                system.debug('Inside2ndForLoop');
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                system.debug('shanthi lstDiagSRT1 for '+lstDiagSRT1);
                dDiagTime = 0.0;
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        if(dTime != null)
                            dDiagTime = dDiagTime + dTime;
                        
                    }
                }
                mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
                system.debug('shanthi for loop2 else2'+  mapsDiaSRT);
            }
            
        }
        
        //Generate a Blank Record for List
        if (!lstFC.IsEmpty()) {
            for (CSS_SymptomQA__c recFC : lstFC) {
                if (!mapsDiaSRT.containsKey(recFC.id)){
                    mapsDiaSRT.put(recFC.id, '0.00');
                }
            }
        }
        return mapsDiaSRT;
    }
    
    //Repair
    public map<String,List<CSS_Solution_Component__c>> getRepairDetailsV1() {
        Transient Map<String,List<CSS_Solution_Component__c>> mapCompo = new  Map<String,List<CSS_Solution_Component__c>>();
        Transient List<CSS_Solution_Component__c> lstComps;
        if (!lstCompForSol.IsEmpty()) {
            for(CSS_Solution_Component__c recCompFSol : lstCompForSol) {
                //if (recCompFSol.Action__c=='') {
                if(mapCompo.containsKey(recCompFSol.Solutions__c)) {
                    mapCompo.get(recCompFSol.Solutions__c).add(recCompFSol);
                } else {
                    lstComps = new List<CSS_Solution_Component__c>{recCompFSol};
                        mapCompo.put(recCompFSol.Solutions__c, lstComps);
                }
                //}
            } 
        }
        //Generate a Blank Record for List
        Transient CSS_Solution_Component__c recComponent  = new CSS_Solution_Component__c(name='');
        Transient List<CSS_Solution_Component__c> lstEmptyComps = new List<CSS_Solution_Component__c>{recComponent};
            if (!lstSolsForSym.IsEmpty()) {
                for (CSS_Solutions__c recSOL : lstSolsForSym) {
                    if (!mapCompo.containsKey(recSOL.id)){
                        mapCompo.put(recSOL.id, lstEmptyComps);
                    }
                }
            }
        return mapCompo;
    }
    
    public void getSolutionsV1(){
        Transient List<CSS_SymptomQA__c> Sym= new List<CSS_SymptomQA__c>();
        Sym = [select id,name,Job_Order__c from CSS_SymptomQA__c where Job_Order__c=:Ins_JobId];
        Transient Map<ID,ID>  jobOrder = new Map<ID,ID>();
        Transient Map<ID,String> Symptom = new Map<ID,String>();
        for(integer i=0;i<Sym.size();i++){
            jobOrder.put(Sym[i].id,Sym[i].Job_Order__c);
            Symptom.put(Sym[i].id,Sym[i].name); 
        }
        System.debug('The job order is'+jobOrder);
        System.debug('The faultCode is'+Symptom);
    }
    /* End Defect 62581 */
    /* Start Defect 137215 */
    public boolean nonPriFCbool {get;set;}
    
    public void getNonPriFC(){
        //nonPriFCbool = False;
        if('LongView'.equalsIgnoreCase(viewMode)){
            Transient AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
            Transient integer maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
            Transient List<CSS_Fault_Code__c> nonPriFC= new List<CSS_Fault_Code__c>();
            nonPriFC = [select Job_Order__c,id,name,DSID__c,Number_of_Solutions__c from CSS_Fault_Code__c where Job_Order__c!= null AND Job_Order__c=:Ins_JobId AND (Fault_Code_Type__c!='APD-P' AND Fault_Code_Type__c!='APD-R' AND Fault_Code_Type__c!='BPD') and Sequence__c=:maxSeq];
            System.debug('nonPriFC'+nonPriFC);
            System.debug('Ins_JobId'+Ins_JobId);
            if(nonPriFC != null && nonPriFC.size() >0){
                System.debug('inside nonPriFC if --'+nonPriFC);
                nonPriFCbool = true;}
            else
                nonPriFCbool = false;
            
            system.debug('nonPriFC--'+nonPriFC);
            system.debug('nonPriFCbool--'+nonPriFCbool);
        }
    }
    //GSSC-443
    public map<String,String> lmdSol{get;set;}
    
    public string getlastmodifieddate(){
      String sDate;
      lmdSol = new map<String,String>();
     
      for (CSS_Solutions__c n: lstSolsForFC){
            
          NewLastModified = n.LastModifiedDate;
          system.debug(NewLastModified + 'NewLastModified---------->');
          String datetime_format = 'dd MMM YYYY hh:mm a z';
          sDate = NewLastModified.format(datetime_format,'CST');
          system.debug(sDate + 'sDate-------->');
          lmdSol.put(n.id,sDate);
      }
        
      return sDate; 
        
        
    } 
}