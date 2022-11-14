public class CSS_TndRepSymOverviewControl {
    
    transient public List<symQAWrapper> searchStrListWrap{get;set;}
    transient public List<symQAWrapper> qAListWrap{get;set;}
    public Id Wid{set;get;}
    public css_job_order__c workJob {get;set;}
    public decimal diatime{get;set;}
    public String sDTime1{get;set;}
    transient public List<CSS_SRT__c> lstSRTForSym;
    transient public List<CSS_SymptomQA__c> lstFC = new List<CSS_SymptomQA__c>();
    transient public List<CSS_Solutions__c> lstSolsForSym; //For Solutions, Components & SRT
    transient public List<CSS_Solution_Component__c> lstCompForSol; //For Solutions, Components & SRT
    symQAWrapper sSSymList;
    symQAWrapper qASymList;
    transient List<CSS_SymptomQA__c> allRecList = new List<CSS_SymptomQA__c>(); 
    
    //Constructor
    public CSS_TndRepSymOverviewControl(){
        Wid=ApexPages.CurrentPage().getParameters().get('id');
       System.Debug('>>>>>Wid '+Wid);
        workJob=[Select CSS_Channel_Code__c, DSID__c,ESN__c,Application__c,Unit_Number__c,Failure_Point__c,Failure_Point_Measure__c,
                 Make__c,Model__c,Equipment_ID__c,Customer_Name__c,Shop_Work_Order__c, Service_Model__c,DSID_Creation_Timestamp__c,DSID_Status__c,DSID_WorkGroup__c
                 from CSS_Job_Order__c where id= :Wid];//Adding CSS_Channel_Code__c field for #111904 ROD Story
       showSolutions();
       
    }
    
    public class symQAWrapper{
        public CSS_SymptomQA__c sSList{get;set;}
        public list<CSS_SymptomQA__c> searchStrWrap{get;set;}
        public list<CSS_SymptomQA__c> qAWrap{get;set;}
        public list<CSS_Solutions__c> solnWrap{get;set;}
        
        public symQAWrapper(){
            sSList =  new CSS_SymptomQA__c();
            searchStrWrap = new List<CSS_SymptomQA__c>();
            qAWrap = new List<CSS_SymptomQA__c>();
            solnWrap = new list<CSS_Solutions__c>();
        }
    }
    
    public integer getAllSolnCount(){
        AggregateResult[] solnAgg;
        solnAgg = [Select count(Id) countsoln from CSS_Solutions__c where Service_Job__c =:Wid ];
        integer SolnCount = integer.valueOf(solnAgg[0].get('countsoln'));
        System.Debug('>>>>>SolnCount '+SolnCount);
         showSolutions();
        return SolnCount;
    }
    
    //Solutions
    public void showSolutions(){
        searchStrListWrap = new  List<symQAWrapper>();
        qAListWrap = new  List<symQAWrapper>();
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        //Story 65995-Added user conditions
        allRecList = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                      Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c, rank__c   from CSS_Solutions__r  order by LastModifiedDate asc) 
                      from CSS_SymptomQA__c 
                      where job_order__c=:Wid and type__c='SearchString'
                      and ( user_name__c = null or ( user_name__c =:userinfo.getUserId() and createdDate >: System.now().addMinutes(-30) )) order by LastModifiedDate asc];
        
        lstFC   = allRecList; 
        lstSRTForSym = new List<CSS_SRT__c>([select Solution_Number__r.Symptom__r.Id, Solution_Number__c, Id, SRT_ID__c,Name,
                                            SRT_Time__c, Repair_Time__c , Solution_Number__r.Repair_Response__c , Diagnosis_Time__c, Type__c,SRT_Quantity__c,Job_Engine_Access_Code__c,Component_Id__r.Selected_Component__c,
                                            isPerformed__c from CSS_SRT__c where Job_Order__c=:Wid]);
        
        lstSolsForSym = new List<CSS_Solutions__c>([select   Nested_Rank__c, CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.Name, CSS_Nested_Solutions__r.Solution_Title__c, Symptom__r.Id,Out_Of_order__c, Id,Name, Case_Name__c,
                                                             Solution_Title__c,Diagnostic_Response__c,Repair_Response__c, rank__c,Diagnostic_notes__c,Repair_Notes__c                                                           
                                                   from      CSS_Solutions__c 
                                                   where     Service_Job__c=:Wid  order by LastModifiedDate asc]);

        lstCompForSol = new List<CSS_Solution_Component__c>([select Solutions__c,Component_Id__c,name,Quantity__c,Action__c, (Select Id,name,Part_Name__c,FailurepartId__c,Service_partnumber__c,Service_Job__c from CSS_Parts_Options__r where selected_part__c=true),
                                                            Service_Job__c,Solutions__r.Repair_Response__c 
                                                            from CSS_Solution_Component__c where Service_Job__c=:Wid and Selected_Component__c=true]);
        
        System.debug('lstSolsForSym***'+lstSolsForSym);
        System.debug('allRecList'+allRecList);
        
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
   
    public map<String,List<CSS_Solutions__c>> getAllSolDetails() {
        Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        List<CSS_Solutions__c> lstSols;
        if (!lstSolsForSym.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForSym) {
                if(mapSolutions.containsKey(recSolWFC.Symptom__r.Id)) {
                    mapSolutions.get(recSolWFC.Symptom__r.Id).add(recSolWFC);
                } else {
                    lstSols = new List<CSS_Solutions__c>{recSolWFC};
                    mapSolutions.put(recSolWFC.Symptom__r.Id, lstSols);
                }
            } 
        }
        return mapSolutions;
    }
    
    
    
    
    //saikomal coco
        public boolean symversol {get; set;}
      public map<String,List<CSS_Solutions__c>> getVerSolDetailsV1() {
        symversol = false;
        Transient Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        Transient List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        if (!lstSolsForSym.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForSym) {
                // if (recSolWFC.Diagnostic_Response__c=='Most likely the solution') {
                if(mapSolutions.containsKey(recSolWFC.Symptom__r.Id)) {
                    mapSolutions.get(recSolWFC.Symptom__r.Id).add(recSolWFC);
                    symversol = true;
                } else {
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
    } //end
    public map<String,List<CSS_Solutions__c>> getVerSolDetails() {
        Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        if (!lstSolsForSym.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForSym) {
        //To display- Parent and child solutions in Repair Overview- 182038, 182032
               if(recSolWFC !=null){
                    if(recSolWFC.Rank__c != null)
                    recSolWFC.Rank__c = recSolWFC.Rank__c + 1;//added by Krish on 14-04-2017.

                   // if (recSolWFC.Diagnostic_Response__c=='Most likely the solution') {
                        if(mapSolutions.containsKey(recSolWFC.Symptom__r.Id)) {
                            mapSolutions.get(recSolWFC.Symptom__r.Id).add(recSolWFC);
                        } else {
                            lstSols = new List<CSS_Solutions__c>{recSolWFC};
                            mapSolutions.put(recSolWFC.Symptom__r.Id, lstSols);
                        }
                   // }
                } 
        }
        }
        //Generate a Blank Record for List
        CSS_Solutions__c recSolution  = new CSS_Solutions__c(name='');
        List<CSS_Solutions__c> lstEmptySols = new List<CSS_Solutions__c>{recSolution};
        if (!lstFC.IsEmpty()) {
            for (CSS_SymptomQA__c recFC : lstFC) {
                if (!mapSolutions.containsKey(recFC.id)){
                    mapSolutions.put(recFC.id, lstEmptySols);
                }
            }
        }
        return mapSolutions;
    }
    
    //Diagonstic
    public map<String,String> getDiagSRTDetails() {
        List<Decimal> lstDiagSRT1;
        List<Decimal> lstDiagSRT2;
        Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Decimal dDiagTime;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        String sDTime;
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
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
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
    
    //SRT
    public map<String,String> getRepSRTDetails() {
        List<Decimal> lstDiagSRT1;
        List<Decimal> lstDiagSRT2;
        Map<String,List<Decimal>> mapDiagSRT = new  Map<String,List<Decimal>>();
        Map<String,String> mapsDiaSRT = new  Map<String,String>();
        Decimal dDiagTime;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        String sDTime;
        if (!lstSRTForSym.isEmpty()){
            for(CSS_SRT__c recSRTWFC : lstSRTForSym) {
                //Added 
                if (recSRTWFC.Type__c == 'Repair' && recSRTWFC.Component_Id__r.Selected_Component__c && recSRTWFC.isPerformed__c==true){
                    system.debug('InsideIF1**'+mapDiagSRT);
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.Symptom__r.Id)) {
                        if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                        mapDiagSRT.get(recSRTWFC.Solution_Number__r.Symptom__r.Id).add(recSRTWFC.Repair_Time__c);
                        }
                        system.debug('InsideIF2**'+mapDiagSRT);
                    } else {
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Repair_Time__c};
                        if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                        mapDiagSRT.put(recSRTWFC.Solution_Number__r.Symptom__r.Id, lstDiagSRT1);
                        }
                        system.debug('InsideIF3**'+mapDiagSRT);
                    }                   
                }
            }
            for (String FCId: mapDiagSRT.keyset()){
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                dDiagTime = 0.0;
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        dDiagTime = dDiagTime + dTime;
                    }
                }
                mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
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
    public map<String,List<CSS_Solution_Component__c>> getRepairDetails() {
        Map<String,List<CSS_Solution_Component__c>> mapCompo = new  Map<String,List<CSS_Solution_Component__c>>();
        List<CSS_Solution_Component__c> lstComps;
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
        CSS_Solution_Component__c recComponent  = new CSS_Solution_Component__c(name='');
        List<CSS_Solution_Component__c> lstEmptyComps = new List<CSS_Solution_Component__c>{recComponent};
        if (!lstSolsForSym.IsEmpty()) {
            for (CSS_Solutions__c recSOL : lstSolsForSym) {
                if (!mapCompo.containsKey(recSOL.id)){
                    mapCompo.put(recSOL.id, lstEmptyComps);
                }
            }
        }
        return mapCompo;
    }
    
    
    //Below method Added for coco sprint saikomal
    public map<String,List<CSS_Parts_Options__c>> getPartDetails() {
        system.debug('Inside parts Details');
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
    //end
    
    public void getSolutions(){
        List<CSS_SymptomQA__c> Sym= new List<CSS_SymptomQA__c>();
        Sym = [select id,name,Job_Order__c from CSS_SymptomQA__c where Job_Order__c=:Wid];
        Map<ID,ID>  jobOrder = new Map<ID,ID>();
        Map<ID,String> Symptom = new Map<ID,String>();
        for(integer i=0;i<Sym.size();i++){
            jobOrder.put(Sym[i].id,Sym[i].Job_Order__c);
            Symptom.put(Sym[i].id,Sym[i].name); 
        }
        System.debug('The job order is'+jobOrder);
        System.debug('The faultCode is'+Symptom);
    }
       
}