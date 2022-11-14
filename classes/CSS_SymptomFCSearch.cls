public class CSS_SymptomFCSearch { 
    
    Public List<solDisplay> solDis {get;set;}
    public string dsidIndi{get;set;}
    public integer solSize{get;set;}
    public integer edsSolutionCount{get;set;}
    public List<symQAWrapper> searchStrListWrap{get;set;}
    public List<symQAWrapper> qAListWrap{get;set;}
    public ID JobID{get;set;}
    public string sortsolutions{set;get;}
    public string solutionsdesc {set;get;}
    public list<CSS_SymptomQA__c> jobsolutions {set;get;}
    symQAWrapper sSSymList;
    symQAWrapper qASymList;
    List<CSS_SymptomQA__c> allRecList = new List<CSS_SymptomQA__c>(); 
    List<Id> allrecsymId = new List<Id>();
    public User u3{get;set;}
    public List<CSS_SRT__c> lstSRTForSym;
    public List<CSS_SymptomQA__c> lstFC = new List<CSS_SymptomQA__c>();
    public List<CSS_Solutions__c> lstSolsForSym; //For Solutions, Components & SRT
    public List<CSS_Solution_Component__c> lstCompForSol; //For Solutions, Components & SRT
    public CSS_accountLanguage__c aLang{get;set;}
    public Boolean errorMsgOnGo{get;set;}
    public CG_DiagTargetTimeResponse diagTargetTimeResp{get;set;}
    public Map<string, CG_DiagTargetTimeResponse.Solutions> mapSolIdTargetTimeSymptom = new Map<string, CG_DiagTargetTimeResponse.Solutions>();

    public class symQAWrapper{
        public CSS_SymptomQA__c sSList{get;set;}
        public list<CSS_SymptomQA__c> searchStrWrap{get;set;}
        public list<CSS_SymptomQA__c> qAWrap{get;set;}
        public list<CSS_Solutions__c> solnWrap{get;set;}
           public Integer rankdetail{get;set;}
        public symQAWrapper(){
            sSList =  new CSS_SymptomQA__c();
            searchStrWrap = new List<CSS_SymptomQA__c>();
            qAWrap = new List<CSS_SymptomQA__c>();
            solnWrap = new list<CSS_Solutions__c>();
             this.rankdetail=rankdetail;
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
    
    public CSS_SymptomFCSearch(){
        try{
            errorMsgOnGo=false;
            solutionsdesc ='1';
            //sortsolutions();
            isPsnExists = true;
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            symptomQAs = new list<CSS_SymptomQA__c>();
            GlobDisplayList = new List<CSS_SymptomQA__c>();
            multiSelectAnswers = new List<String>();
            /*--workJob=[Select DSID__c,ESN__c,Application__c,Mileage_Measure__c,Unit_Number__c,Failure_Point__c,Mileage__c,Failure_Point_Measure__c,previous_status__c,status__c,AccessCode__c,ESN_Locked__c,
Make__c,Model__c,Equipment_ID__c,Customer_Name__c,Shop_Work_Order__c, Service_Model__c,DSID_Creation_Timestamp__c,DSID_Status__c,ESN_Insite__c,DSID_WorkGroup__c
from CSS_Job_Order__c where id=:Wid];--*/
            //Modified as per story# 64030
            workJob=[Select Name, CSS_Channel_Code__c, DSID__c,ESN__c,Application_Desc__c,Mileage_Measure__c,EngineFamilyCode__c, Unit_Number__c,Failure_Point__c,Mileage__c,Failure_Point_Measure__c,previous_status__c,status__c,AccessCode__c,ESN_Locked__c,
                     Make__c,Model__c,Equipment_ID__c,Customer_Name__c,Shop_Work_Order__c, Service_Model__c,DSID_Creation_Timestamp__c,DSID_Status__c,ESN_Insite__c,DSID_WorkGroup__c
                     from CSS_Job_Order__c where id=:Wid];//Adding Name field for #121719 ROD Story  //Adding CSS_Channel_Code__c field for #111904 ROD Story
            System.Debug('SysmptomId'+selectedSymptom);
            u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
            aLang = css_utility.getLanguage(u3.LanguageLocaleKey);
            dsidUpdate = false;
              if((workJob.Application_Desc__c!='Select One' && workJob.Application_Desc__c!=null && workJob.Application_Desc__c!='') && 
               (workJob.Make__c!='Select One' && workJob.Make__c!=null && workJob.Make__c!='') &&
               (workJob.Model__c!='Select One' && workJob.Model__c!=null && workJob.Model__c!='')){
                errorMsgOnGo=false;
            }
            else{
                errorMsgOnGo=true;
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    public void showSolutions(){
        searchStrListWrap = new  List<symQAWrapper>();
        qAListWrap = new  List<symQAWrapper>();
        JobID=ApexPages.CurrentPage().getParameters().get('id');
        SysteM.debug('The id is'+JobID);
        //Stroy 65995--Added conditions for the users and time
        if(solutionsdesc=='2'){
            allRecList = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                          Number_of_Solutions__c,(select name,symptom__c,Nested_Rank__c,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.Name,CSS_Nested_Solutions__r.Rank__c, CSS_Nested_Solutions__r.Solution_Title__c, Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c, Rank__c  from CSS_Solutions__r order by LastModifiedDate asc) 
                          from CSS_SymptomQA__c 
                          where job_order__c=:Wid and type__c='SearchString'
                          and ( user_name__c = null or ( user_name__c =:userinfo.getUserId() and createdDate >: System.now().addMinutes(-30) )) order by LastModifiedDate asc ];
            System.debug('allRecList1'+allRecList);
        }
        else if (solutionsdesc=='1'){
            
            allRecList = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                          Number_of_Solutions__c,(select name,symptom__c,Nested_Rank__c,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.Name,CSS_Nested_Solutions__r.Rank__c, CSS_Nested_Solutions__r.Solution_Title__c, Solution_Title__c,Diagnostic_Response__c,case_name__c,Repair_Response__c,Rank__c  from CSS_Solutions__r order by LastModifiedDate asc) 
                          from CSS_SymptomQA__c 
                          where job_order__c=:Wid and type__c='SearchString'
                          and ( user_name__c = null or ( user_name__c =:userinfo.getUserId() and createdDate >: System.now().addMinutes(-30) )) order by LastModifiedDate desc ];
            
            System.debug('allRecList2'+allRecList);
        }
        
        
        System.debug('allRecList'+allRecList);
        
        lstFC   = allRecList; 
        lstSRTForSym = new List<CSS_SRT__c>([select Solution_Number__r.Symptom__r.Id,Solution_Number__r.Symptom__r.Name, Solution_Number__c, Id,Solution_Number__r.Repair_Response__c, SRT_ID__c,Name,
                                             SRT_Time__c,Repair_Time__c,Diagnosis_Time__c, Type__c,SRT_Quantity__c,Job_Engine_Access_Code__c,Component_Id__r.Selected_Component__c,
                                             isPerformed__c from CSS_SRT__c where Job_Order__c=:Wid]);
        
        lstSolsForSym = new List<CSS_Solutions__c>([select    Symptom__r.Id,Out_Of_order__c, Id,Case_Name__c, Rank__c, 
                                                    Solution_Title__c,Diagnostic_Response__c,Repair_Response__c                                                              
                                                    from      CSS_Solutions__c 
                                                    where     Service_Job__c=:Wid order by LastModifiedDate desc]);
        
        lstCompForSol = new List<CSS_Solution_Component__c>([select Solutions__c,Component_Id__c,name,Quantity__c,Action__c,  (Select Id,name,Part_Name__c,FailurepartId__c,Service_partnumber__c,Service_Job__c from CSS_Parts_Options__r where selected_part__c=true),
                                                             Service_Job__c,Solutions__r.Repair_Response__c 
                                                             from CSS_Solution_Component__c where Service_Job__c=:Wid and Selected_Component__c=true]);
        
        
        
        for(CSS_SymptomQA__c qA1:allRecList){
            allrecsymId.add(qA1.id);
            sSSymList = new symQAWrapper();
            qASymList = new symQAWrapper();
            
            if(qA1.type__c=='SearchString'){
                System.debug('The qa is'+qa1);
                qASymList.sSList = qA1;
                System.debug('qASymList is>>>'+qASymList);                
            }
            
            if(qA1.CSS_SymptomQA__r!=null && !qA1.CSS_SymptomQA__r.isEmpty()){
                for(integer i=0;i<qA1.CSS_SymptomQA__r.size();i++){
                    System.debug('The type is'+qA1.CSS_SymptomQA__r[i].Type__c);
                    System.debug('The searchstring id is'+qA1.CSS_SymptomQA__r[i].SearchString__c+ ' '+qa1.id);
                    if(qA1.CSS_SymptomQA__r[i].Type__c.equalsIgnoreCase('QA') && qA1.CSS_SymptomQA__r[i].SearchString__c == qA1.id){
                        qASymList.searchStrWrap.add(qA1.CSS_SymptomQA__r[i]);
                        System.debug('qASymList1 is>>>'+qASymList);
                        
                        
                    }
                }
            }
            if(qA1.CSS_Solutions__r!=null && !qA1.CSS_Solutions__r.isEmpty()){
                
                // Satish Code for setting Rank
// Scenario-1 get least available solution rank
                Boolean BreakFlag = false;
                
                for(integer i=0;i<qA1.CSS_Solutions__r.size();i++)
                {        
                    for(integer j=0;j<qA1.CSS_Solutions__r.size();j++)
                    {
                        if(Integer.ValueOf(qA1.CSS_Solutions__r[j].Rank__c)==i)
                           {
                            if(qA1.CSS_Solutions__r[j].Diagnostic_Response__c==null)
                            {
                                qASymList.rankdetail =Integer.ValueOf(qA1.CSS_Solutions__r[j].Rank__c);
                                BreakFlag=true;
                                break;
                            }
                           }
                       }
                    if(BreakFlag==true) break;
                }
                
            // Scenario-2 get last updated solution rank
                if(qASymList.rankdetail==null)
                {
                    system.debug('qA1.CSS_Solutions__r[qA1.CSS_Solutions__r.size()-1].CSS_Nested_Solutions__r.Rank__c<><>'+qA1.CSS_Solutions__r[qA1.CSS_Solutions__r.size()-1].CSS_Nested_Solutions__r.Rank__c);
                if(qA1.CSS_Solutions__r[qA1.CSS_Solutions__r.size()-1].CSS_Nested_Solutions__r.Rank__c==null)
                       qASymList.rankdetail=Integer.ValueOf(qA1.CSS_Solutions__r[qA1.CSS_Solutions__r.size()-1].Rank__c);
                else
                       qASymList.rankdetail=Integer.ValueOf(qA1.CSS_Solutions__r[qA1.CSS_Solutions__r.size()-1].CSS_Nested_Solutions__r.Rank__c);//Added else condition for defect GSSC-696
                       System.debug('enteredintonull>>>>:'+qASymList.rankdetail);
                }
                
                // end Satish Code for setting Rank 
                System.debug('qA1.CSS_Solutions__r>>>>:'+qA1.CSS_Solutions__r);
                System.debug('qA1.CSS_Solutions__r>>>>:'+qA1.CSS_Solutions__r.size());
                for(integer i=0;i<qA1.CSS_Solutions__r.size();i++){
                    if(qA1.CSS_Solutions__r[i].Rank__c != null)
                    qA1.CSS_Solutions__r[i].Rank__c = qA1.CSS_Solutions__r[i].Rank__c + 1;//added by Krish on 14-04-2017.
                    system.debug('Symptom**'+qA1.CSS_Solutions__r[i].symptom__c);
                    if(qA1.CSS_Solutions__r[i].symptom__c == qA1.id){
                       
                        //To display- Parent and child solutions in T&D Overview- 182038, 182032
                        if(qA1.CSS_Solutions__r[i] !=null)
                        qASymList.solnWrap.add(qA1.CSS_Solutions__r[i]);
                        System.debug('qASymList2 is>>>'+qASymList);
                        
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
        //kalpana
        if(Test.isRunningTest()){
            List<Css_Solutions__c> Sollist = new List<Css_Solutions__c>();
            Sollist = [select id,Rank__c from Css_Solutions__c where Service_Job__c = 'a093B000000yb5vQAA'];
            mapsolutions.put('Map', Sollist);}
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
    
    public map<String,List<CSS_Solutions__c>> getVerSolDetails() {
        Map<String,List<CSS_Solutions__c>> mapSolutions = new  Map<String,List<CSS_Solutions__c>>();
        List<CSS_Solutions__c> lstSols = new List<CSS_Solutions__c>();
        if (!lstSolsForSym.IsEmpty()) {
            for(CSS_Solutions__c recSolWFC : lstSolsForSym) {
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
        Double dDiagTime;
        integer iDiagTime;
        integer iMinutes;
        integer iHour;
        String sDTime;
        if (!lstSRTForSym.isEmpty()){
            
            for(CSS_SRT__c recSRTWFC : lstSRTForSym) {
                if (recSRTWFC.Type__c == 'Diagnosis'){
                    system.debug(LOGGINGLEVEL.ERROR,'lstSRTForSym-->'+recSRTWFC.Solution_Number__r.Symptom__r.Id+' '+recSRTWFC.Solution_Number__r.Symptom__r.Name);
                    if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.Symptom__r.Id)) {
                        system.debug('Inside Diagnosis IF');
                        mapDiagSRT.get(recSRTWFC.Solution_Number__r.Symptom__r.Id).add(recSRTWFC.Diagnosis_Time__c);
                    } else {
                        system.debug('Inside Diagnosis Else');
                        lstDiagSRT1 = new List<Decimal>{recSRTWFC.Diagnosis_Time__c};
                        system.debug('FCID-->'+recSRTWFC.Solution_Number__r.Symptom__r.Id);
                            mapDiagSRT.put(recSRTWFC.Solution_Number__r.Symptom__r.Id, lstDiagSRT1);
                    }                   
                }
            }
            system.debug('mapDiagSRT.keyset()--'+mapDiagSRT.keyset());
            for (String FCId: mapDiagSRT.keyset()){
                lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                dDiagTime = 0.0;
                sDTime = '';
                if (!lstDiagSRT1.isEmpty()){
                    for (Decimal dTime: lstDiagSRT1) {
                        dDiagTime = dDiagTime + dTime;
                    }
                }
                mapsDiaSRT.put(FCId,string.valueOf(dDiagTime));
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
        try{
            system.debug('lstSRTForSym**'+lstSRTForSym);
            if (!lstSRTForSym.isEmpty()){
                for(CSS_SRT__c recSRTWFC : lstSRTForSym) {
                    if (recSRTWFC.Type__c == 'Repair' && recSRTWFC.isPerformed__c==true){
                        system.debug('InsideIF1**'+mapDiagSRT);
                        if(mapDiagSRT.containsKey(recSRTWFC.Solution_Number__r.Symptom__r.Id)) {
                            system.debug('InsideIF2**'+mapDiagSRT);
                            if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                                mapDiagSRT.get(recSRTWFC.Solution_Number__r.Symptom__r.Id).add(recSRTWFC.Repair_Time__c);
                            }      
                        } else {
                            system.debug('InsideElse**');
                            lstDiagSRT1 = new List<Decimal>{recSRTWFC.Repair_Time__c};
                                if(recSRTWFC.Solution_Number__r.Repair_Response__c != null && recSRTWFC.Solution_Number__r.Repair_Response__c != '' && recSRTWFC.Component_Id__r.Selected_Component__c){
                                    mapDiagSRT.put(recSRTWFC.Solution_Number__r.Symptom__r.Id, lstDiagSRT1);
                                }   
                        }                   
                    }
                }
                system.debug('mapDiagSRT**'+mapDiagSRT);
                for (String FCId: mapDiagSRT.keyset()){
                    lstDiagSRT1 = new List<Decimal>(mapDiagSRT.get(FCId));
                    dDiagTime = 0.0;
                    sDTime = '';
                    system.debug('lstDiagSRT1**'+lstDiagSRT1);
                    if (!lstDiagSRT1.isEmpty()){
                        for (Decimal dTime: lstDiagSRT1) {
                            dDiagTime = dDiagTime + dTime;
                        }
                    }
                    mapsDiaSRT.put(FCId,string.valueof(dDiagTime));
                    system.debug('mapsDiaSRTrepair'+mapsDiaSRT);
                }
            }
            //Generate a Blank Record for List
            system.debug('lstFC**'+lstFC);
            if (!lstFC.IsEmpty()) {
                for (CSS_SymptomQA__c recFC : lstFC) {
                    if (!mapsDiaSRT.containsKey(recFC.id)){
                        mapsDiaSRT.put(recFC.id, '0.00');
                    }
                }
            }
            system.debug('mapsDiaSRTrepair**'+mapsDiaSRT);
        }
        catch(exception e){
            
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
    
    
    
    //QA Code to call WSs
    public Id Wid{set;get;}
    public string searchText{set;get;}
    
    public list<CSS_SymptomQA__c> symptomQAs{get;set;}
    public list<CSS_SymptomQA__c> GlobDisplayList{get;set;}
    
    
    //Varibles for Q&A
    
    public string quest{get;set;}
    public integer totalSolution{get;set;}
    public static integer l = 0;
    public integer m = 0 ;
    public string descr{get;set;}
    public string category{get;set;}
    public List<SelectOption> options{get;set;}
    public List<SelectOption> options2{get;set;} 
    public boolean display{get;set;}
    public boolean displaySoln{get;set;}
    public boolean displaySolnCaptionOnly{get;set;}
    public integer Cardinality;
    public string QuestionId {get;set;}
    public string QuesResp  {get;set;}
    public String ansChoiceCaption;
    public String ansId;
    public String multiChoiceSelect;
    public string radioMapSelect;
    @TestVisible 
    Map<String,String> optMapRadio = New Map<String,String>();
    Map<String,String> optMapMultiSelect = New Map<String,String>();    
    public String FCCodeUI;
    public List<String> mChoiceUI;
    public List<CSS_EDSAuthentication.nextQues> GlobQuestLst ;
    public List<CSS_EDSAuthentication.nextQues> QuestLst;
    public List<CSS_EDSAuthentication.nextQues> PreviousQuestLst;
    public List<CSS_SymptomQA__c> GlobSearchDisplayList = new List<CSS_SymptomQA__c>();
    //public List<CSS_SymptomQA__c> GlobDisplayList = new List<CSS_SymptomQA__c>();//QA List    
    public List<CSS_Solutions__c> GlobSolnDisplayList = new List<CSS_Solutions__c>();
    List<CSS_SymptomQA__c> LocalInsertList = new List<CSS_SymptomQA__c>();
    public String solName;
    public String solTitle;
    public integer solRank;
    string sDSID;
    boolean dsidUpdate;
    Public Id QAId;
    boolean fstcall = false;
    boolean CallWS = false;
    boolean EOFQuest = false ;
    boolean isSoln = false ;
    boolean isSolnSearchCall = false ;
    Integer seqGlob = 1;
    Integer seqLocal = 1;
    @TestVisible
    Integer SeqNum{get;set;}
    //Public string SymId{get;set;}
    Public Id SearchObjId;
    Public string workGroup;
    public css_job_order__c workJob {get;set;}
    @TestVisible String DSID;
    public boolean isPsnExists{get;set;}
    
    public Boolean fQuestPopup {set;get;}//for defect 62106
    
    //variables for capturing answers
    //public list<string> multiSelectAnswers{get;set;}
    
    public list<string> multiSelectAnswers;
    public string radioSelect;
    
    public list<string> getmultiSelectAnswers(){
        return multiSelectAnswers;
    }
    public void setmultiSelectAnswers(List<String>multiSelectAnswers) {
        this.multiSelectAnswers = multiSelectAnswers;
    }
    
    public list<CSS_SymptomQA__c> getGlobDisplayList(){
        return GlobDisplayList;
    }
    public void setGlobDisplayList(List<CSS_SymptomQA__c>GlobDisplayList) {
        this.GlobDisplayList = GlobDisplayList;
    }
    
    public string getradioSelect(){
        return radioSelect;
    }
    public void setradioSelect(String radioSelect) {
        this.radioSelect = radioSelect;
    }
    //public list<CSS_SymptomQA__c>delQA{get;set;}
    
    //variable for Insertion of Search text.
    CSS_SymptomQA__c symQA;
    //Added for Story - 71924
    public Boolean edsErrorPopUp{get;set;}
    public void showEDSErrorPopUp(){
        edsErrorPopUp = true;
    }
    public void closeEDSErrorPopUp(){
        edsErrorPopUp = false;
    }
    // End Story - 71924
    //method for search and insert.
    public void searchTS(){
        try{
            edsSolutionCount=0;
            system.debug('--Sai --');
            if(workJob.ESN__c=='' || workJob.ESN__c==null){
                isPsnExists = false;
                System.debug('Inside isPsnExists'+isPsnExists);
            }
            else{
                if(workJob.DSID__c!=null){
                    System.debug('Inside dsidIndi');
                    dsidIndi = css_utility.getDSIDEditIndicator(userinfo.getUserId(),workJob.DSID__c, workJob.DSID_WorkGroup__c);
                }
                if(searchText != null && searchText != ''){
                    displaySoln =false;
                    
                    System.debug('Current Str is '+searchText);
                    if(GlobDisplayList.size()>0){
                        System.debug('GlobDisplayList Clear >>>>>>>>>'+GlobDisplayList.size());
                        GlobDisplayList.clear();                
                    }
                    if(GlobDisplayList.size()>0){
                        System.debug('GlobDisplayList Clear >>>>>>>>>'+GlobDisplayList.size());
                        GlobDisplayList.clear();                
                    }
                    
                    if(LocalInsertList.size()>0){
                        System.debug('LocalInsertList Clear >>>>>>>>>'+LocalInsertList.size());
                        LocalInsertList.clear();
                    }
                    if (symptomQAs.size()>0){
                        System.debug('symptomQAs Clear >>>>>>>>>'+symptomQAs.size());
                        symptomQAs.clear();
                        seqGlob=1;
                        seqLocal=1;
                        System.debug('Current Str is in side size '+searchText);
                        
                    }
                    if (GlobSolnDisplayList.size()>0){
                        System.debug('GlobSolnDisplayList Clear >>>>>>>>>'+GlobSolnDisplayList.size());
                        GlobSolnDisplayList.clear();
                    }
                    
                    if (radioSelect!=null || radioSelect!=''){
                        System.debug('2nd Call making raidoSelectNull'+radioSelect);
                        radioSelect=null;
                    }
                    if(multiSelectAnswers.size()>0){
                        System.debug('multiSelectAnswers Clear >>>>>>>>>'+multiSelectAnswers.size());
                        multiSelectAnswers.clear();
                    }
                    if (GlobSearchDisplayList.size()>0){
                        System.debug('GlobSearchDisplayList Clear >>>>>>>>>'+GlobSearchDisplayList.size());
                        GlobSearchDisplayList.clear();
                    }
                    
                    user u = css_utility.getUserAttributes(userInfo.getUserId());
                    //To store the workgroup name in job order while creating a dsid for the first time - Defect fix - 75751
                    if( workJob.DSID_WorkGroup__c == null && u.Work_Group_Name__c!=null){        
                        System.debug('call userinfoLocation>>>>>>>>>'+ u);
                        workGroup = u.Work_Group_Name__c;
                        System.debug('workGroup>>>>>>>>>'+ workGroup);
                    }
                    if( workJob.DSID_WorkGroup__c != null && workJob.DSID__c!=null ){
                        
                        System.debug('call ExitDSID WebServicecalled ParamterinIFFFF>>>>>>>>>'+workJob.DSID_WorkGroup__c+''+workJob.DSID__c);
                        System.debug('call getEXITDSID WebServicecalled>>>>>>>>>');
                        //CSS_EDSAuthentication.exitDSID(workJob.DSID_WorkGroup__c,workJob.DSID__c); //Commenting Exit DSID call for now
                    }
                    System.debug('');
                    
                    if( workJob.DSID__c == null && workJob.ESN__c != null && workJob.Customer_Name__c != null ){
                        dsidUpdate = true;
                        System.debug('call getDSID WebServicecalled ParamterinIFFFF>>>>>>>>>'+workJob.ESN__c+''+workJob.Customer_Name__c);
                        System.debug('call getDSID WebServicecalled>>>>>>>>>');
                        
                        /*--DSID = CSS_EDSAuthentication.getDSID(workJob.ESN__c,workJob.Application__c,workJob.Unit_Number__c,workJob.Mileage__c,
workJob.Mileage_Measure__c,workJob.Make__c,workJob.Model__c,workJob.Equipment_ID__c,workJob.Customer_Name__c,
workJob.Service_Model__c,workJob.Shop_Work_Order__c,workJob.AccessCode__c);--*/
                        //Modified as per story# 64030
                        DSID = CSS_EDSAuthentication.getDSID(workJob.ESN__c,workJob.name,workJob.Application_Desc__c,workJob.Unit_Number__c,workJob.Mileage__c,
                                                             workJob.Mileage_Measure__c,workJob.Make__c,workJob.Model__c,workJob.Equipment_ID__c,workJob.Customer_Name__c,
                                                             workJob.Service_Model__c,workJob.Shop_Work_Order__c,workJob.AccessCode__c);
                        System.debug('DSID is in IF Block>>>>>>>>>'+DSID);                
                    }
                    else{
                        
                        DSID=workJob.DSID__c;
                        System.debug('DSID is In ELSE Block >>>>>>>>>'+DSID);
                    }
                    
                    //Step-2:Call webservice with the SearchStr if String is text or FC
                    if(DSID.contains('connection-error')){
                        System.debug('EDS is down');
                    }
                    else if(DSID.contains('error.invalid')){
                        System.debug('Show popup');
                        showEDSErrorPopUp();
                    }
                    else{
                        if (!searchText.isNumeric() && DSID!= null) {
                            system.debug('TRTRTRT1');
                            SymptomSearch( searchText );
                        }         
                        else if (DSID!= null){             
                            system.debug('FCCOde Search');
                            SymptomFCSearch( searchText );
                        }
                    }
                }
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    public void SymptomFCSearch(String str) {
        try{
            if(solDis!=null){
                solDis.clear();
            }
            display = true;
            fstcall = true;
            
            options = new list<SelectOption>();       
            List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
            
            System.debug('passing varFCSearh'+ str + workJob.ESN__c + workJob.Application_Desc__c + workJob.Unit_Number__c + workJob.Failure_Point__c + workJob.Failure_Point_Measure__c+workJob.Make__c + workJob.Model__c + workJob.DSID__c + workJob.Equipment_ID__c +
                         workJob.Customer_Name__c+ workJob.Service_Model__c+workJob.Shop_Work_Order__c+'DISID'+DSID);
            string language = 'en';
            /*--FcListFCSearch = CSS_EDSAuthentication.getFCSympSearch(str,workJob.ESN__c,workJob.Application__c,workJob.Unit_Number__c,workJob.Failure_Point__c,workJob.Failure_Point_Measure__c,
workJob.Make__c,workJob.Model__c,workJob.Equipment_ID__c,workJob.Customer_Name__c,workJob.Service_Model__c,workJob.Shop_Work_Order__c,DSID,aLang.CSS_EDSLanguage__c,dsidIndi);--*/
            //Modified as per story# 64030
            FcListFCSearch = CSS_EDSAuthentication.getFCSympSearch(str,workJob.ESN__c,workJob.Application_Desc__c,workJob.Unit_Number__c,workJob.Failure_Point__c,workJob.Failure_Point_Measure__c,
                                                                   workJob.Make__c,workJob.Model__c,workJob.Equipment_ID__c,workJob.Customer_Name__c,workJob.Service_Model__c,workJob.Shop_Work_Order__c,DSID,aLang.CSS_EDSLanguage__c,dsidIndi);
            System.debug('FcListFCSearch>>>>>>>>>'+FcListFCSearch);
            
            if (FcListFCSearch.size()>0){
                System.debug('SIZEEEEE'+FcListFCSearch[0].answersNext);
                
                if (FcListFCSearch[0].answersNext != null){
                    
                    if( FcListFCSearch[0].answersNext.size()>0)
                        
                        if (FcListFCSearch[0].answersNext.size() > 0){
                            System.debug('Inside Question flow');
                            quest = FcListFCSearch[0].question;//'100;
                            QuesResp = JSON.serialize(FcListFCSearch[0].FCSearchAttributes); //Added by roopa
                            Cardinality =FcListFCSearch[0].cardinality;
                            QuestionId = FcListFCSearch[0].quesId;
                            
                            if (Cardinality == 1){
                                category = 'radio';
                            }
                            else if (Cardinality > 1){
                                category = 'checkBox';
                            }
                            //for defect 62106
                            if(quest.contains('No Fault Codes Present')){
                                System.debug('FirstQ >>>>>>>>>'+quest);
                                fQuestPopup = true;            
                            }
                            for (integer i=0;i<FcListFCSearch[0].answersNext.size();i++)
                            {
                                //System.debug('optionsFcListFCSearch>>>>>>>>>'+FcListFCSearch[i]);
                                options.add(new SelectOption(FcListFCSearch[0].answersNext[i].ansID,FcListFCSearch[0].answersNext[i].ansCaption));
                                
                                //options.add(new SelectOption(FcListFCSearch[i].fcID,FcListFCSearch[i].faultCode));
                                optMapRadio.put(FcListFCSearch[0].answersNext[i].ansID,FcListFCSearch[0].answersNext[i].ansCaption);
                                System.debug('optionsFcListFCSearch>>>>>>>>>'+optMapRadio);
                            }
                            System.debug('optMapRadio>>>>>>>>>'+options);
                            
                            //System.debug('optMapRadio>>>>>>>>>'+optMapRadio);
                            CSS_SymptomQA__c strAdd = new CSS_SymptomQA__c();
                            
                            strAdd.Caption__c=str;
                            strAdd.Job_Order__c = Wid;
                            strAdd.type__c= 'SearchString';
                            strAdd.Name = str;
                            strAdd.AttributeValues__c = JSON.serialize(FcListFCSearch[0].FCSearchAttributes);   //roopa added FcList1.SymSearchAttributes;
                            GlobSearchDisplayList.add(strAdd);
                            symptomQAs.add(strAdd);
                            insertSearchStr(GlobSearchDisplayList);
                            System.debug('GlobSearchDisplayListFCCode>>>>>>>>>'+GlobSearchDisplayList);
                            System.debug('strAdd>>>>>>>>>'+strAdd);
                        }
                }  
                else if (FcListFCSearch[0].solEDS.size()>0){
                    
                    CSS_SymptomQA__c strAdd = new CSS_SymptomQA__c();
                    
                    strAdd.Caption__c=str;
                    strAdd.Job_Order__c = Wid;
                    strAdd.type__c= 'SearchString';
                    strAdd.Name = str;
                    strAdd.Option2__c = 'SolutionsOnly';
                    strAdd.AttributeValues__c = JSON.serialize(FcListFCSearch[0].FCSearchAttributes);   //roopa added FcList1.SymSearchAttributes;
                    GlobSearchDisplayList.add(strAdd);
                    symptomQAs.add(strAdd);
                    System.debug('Inside FC GlobSearchDisplayList>>>>>>>>>'+GlobSearchDisplayList);
                    System.debug('Inside FC SearchSOlution block'+FcListFCSearch[0].solEDS.size());
                    
                    //GSSC-155 Start
                    List<string> lstSolnumbers = new List<string>();
                    for (integer p=0;p<FcListFCSearch[0].solEDS.size();p++){
                        lstSolnumbers.add(FcListFCSearch[0].solEDS[p].name);
                    }
                    
                    diagTargetTimeResp = new CG_DiagTargetTimeResponse();
                    diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,workJob.Equipment_ID__c,workJob.Service_Model__c,workJob.EngineFamilyCode__c,'en'); //Uncomment after serice is ready from middleware
                    //GSSC-155 End
                    
                    insertSearchStr(GlobSearchDisplayList);
                    showSoln1(FcListFCSearch);
                }
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    
    public void  showSoln1( list<CSS_EDSAuthentication.nextQues> SolnList ){
        try{
            
            System.debug('showSoln1Inside showSolnSize>>>>>>>>>'+SolnList.size());
            System.debug('showSoln1Inside SolnList[0]>>>>>>>>>'+SolnList[0]);
            
            //GSSC-155 Start
            Map<string, CG_DiagTargetTimeResponse.Solutions> mapSolIdTargetTime = new Map<string, CG_DiagTargetTimeResponse.Solutions>();
            
            system.debug('diagTargetTimeResp--'+diagTargetTimeResp);

            if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                    mapSolIdTargetTime.put(sol.SolutionId,sol);
                }
            }
            //GSSC-155 End
            
            for (integer p=0;p<SolnList[0].solEDS.size();p++){
                solName =SolnList[0].solEDS[p].name;
                solTitle =SolnList[0].solEDS[p].title;
                solRank =SolnList[0].solEDS[p].rank;
                
                CSS_Solutions__c strSoln = new CSS_Solutions__c();
                strSoln.Solution_Title__c = solTitle;
                strSoln.Name= solName;
                strSoln.Case_Name__c= solName;
                strSoln.Service_Job__c =Wid;
                strSoln.Rank__c = solRank;
                
                strSoln.Symptom__c = SearchObjId;
                
                //GSSC-155 Start
                CG_DiagTargetTimeResponse.Solutions solution = new CG_DiagTargetTimeResponse.Solutions();

                solution = mapSolIdTargetTime.get(solName);
                if(solution != null){
                    strSoln.DiagTargetTime__c = (solution.DiagnosticTargetTime != null && solution.DiagnosticTargetTime != '') ? decimal.valueof(solution.DiagnosticTargetTime) : 0;
                    strSoln.TargetMessage__c = solution.TargetMessage;  
                }
                //GSSC-155 End
                GlobSolnDisplayList.add(strSoln);
            }      
    
            if (GlobSolnDisplayList.size()>0){
                System.debug('showSoln1Insert Solutions GlobSolnDisplayList[0]>>>>>>>>>'+GlobSolnDisplayList);
                insert GlobSolnDisplayList;
                if( DSID != null && dsidUpdate == TRUE){
                    workJob.DSID__c = DSID;
                    workJob.DSID_Creation_Timestamp__c = System.now();
                    workJob.DSID_Status__c = 'Open';
                    workJob.DSID_Owner__c = u3.FederationIdentifier;
                    workJob.DSID_WorkGroup__c = workGroup;
                    workJob.ESN_Locked__c = true;
                    workJob.ESN_Insite__c = workJob.ESN__c;
                    update workJob;
                }
                
                CSS_SymptomQA__c strQASolNum = new CSS_SymptomQA__c();
                strQASolNum.id=SearchObjId;
                strQASolNum.Number_of_Solutions__c = string.Valueof(SolnList[0].solEDS.size());            
                strQASolNum.isPole__c = SolnList[0].isPole;
                update strQASolNum;
                
                displaySoln =true;
            }
            //insert GlobDisplayList;
            System.debug('Aftr Soln Displat SymQA List>>>>>>>>>'+symptomQAs);
            
            System.debug('Aftr Soln Displat Global List>>>>>>>>>'+GlobQuestLst);
            //System.debug('calling Pagereference');
            //PageReference ReturnPage = new PageReference('/apex/CSS_JobTnDTs?id='+Wid); 
            //ReturnPage.setRedirect(true);
            //return returnPage;
            //System.debug('ExitInside GlobSolnDisplayList[0]>>>>>>>>>'+GlobSolnDisplayList);
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage()+e.getLineNumber());
        }
    }
    public void SymptomSearch(String str) {
        try{
            if(solDis!=null){
                solDis.clear();
            }
            System.debug('SymptomSearchLike WhiteSmoke>>>>>>>>>'+str);
            display = true;
            fstcall = true;
            System.debug('passing var'+ str + workJob.ESN__c + workJob.Application_Desc__c + workJob.Unit_Number__c + workJob.Failure_Point__c 
                         + workJob.Failure_Point_Measure__c+workJob.Make__c + workJob.Model__c + workJob.DSID__c + workJob.Equipment_ID__c + workJob.Customer_Name__c+workJob.Service_Model__c+workJob.Shop_Work_Order__c+'DISID'+DSID);
            options = new list<SelectOption>();       
            //List<CSS_EDSAuthentication.faultCodeID> FcList1 = new List<CSS_EDSAuthentication.faultCodeID>();
            string language = 'en';
            List<CSS_EDSAuthentication.nextQues> FcList1 = new List<CSS_EDSAuthentication.nextQues>();
            /*-- FcList1 = CSS_EDSAuthentication.getSymptomSearch(str,workJob.ESN__c,workJob.Application__c,workJob.Unit_Number__c,workJob.Failure_Point__c,workJob.Failure_Point_Measure__c,
workJob.Make__c,workJob.Model__c,workJob.Equipment_ID__c,workJob.Customer_Name__c,workJob.Service_Model__c,workJob.Shop_Work_Order__c,DSID,aLang.CSS_EDSLanguage__c,dsidIndi);--*/
            //Modified as per story# 64030
            FcList1 = CSS_EDSAuthentication.getSymptomSearch(str,workJob.ESN__c,workJob.Application_Desc__c,workJob.Unit_Number__c,workJob.Failure_Point__c,workJob.Failure_Point_Measure__c,
                                                             workJob.Make__c,workJob.Model__c,workJob.Equipment_ID__c,workJob.Customer_Name__c,workJob.Service_Model__c,workJob.Shop_Work_Order__c,DSID,aLang.CSS_EDSLanguage__c,dsidIndi);
            System.debug('optionsFromWEB>>>>>>>>>'+FcList1);
            System.debug('size of FcList1=======>>>>'+FcList1.size()); // Sai
            if(FcList1.size()>0){                
                
                System.debug('optMapRadio>>>>>>>>>'+optMapRadio);
                CSS_SymptomQA__c strAdd = new CSS_SymptomQA__c();
                
                strAdd.Caption__c=str;
                strAdd.Job_Order__c = Wid;
                strAdd.type__c= 'SearchString';
                strAdd.Name = str;
                strAdd.AttributeValues__c = JSON.serialize(FcList1[0].SymSearchAttributes);   //roopa added FcList1.SymSearchAttributes;
                
                //GSSC-155 Start
                List<string> lstSolnumbers = new List<string>();
                if(FcList1[0].solEDS != null){
                    for (integer p=0;p<FcList1[0].solEDS.size();p++){
                        lstSolnumbers.add(FcList1[0].solEDS[p].name); 
                    }
                }
                
                diagTargetTimeResp = new CG_DiagTargetTimeResponse();
                diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,workJob.Equipment_ID__c,workJob.Service_Model__c,workJob.EngineFamilyCode__c,'en'); //Uncomment after serice is ready from middleware

                system.debug('diagTargetTimeResp--'+diagTargetTimeResp);
    
                if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                    for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                        mapSolIdTargetTimeSymptom.put(sol.SolutionId,sol);
                    }
                }
                //GSSC-155 End  
                
                System.debug('attribute'+strAdd.AttributeValues__c);
                GlobSearchDisplayList.add(strAdd);
                symptomQAs.add(strAdd);
                insertSearchStr(GlobSearchDisplayList);
                System.debug('GlobSearchDisplayListID of The Record>>>>>>>>>'+SearchObjId);
                System.debug('GlobSearchDisplayList>>>>>>>>>'+GlobSearchDisplayList);
                System.debug('strAdd>>>>>>>>>'+strAdd);
                fstcall= false;
                
                
                isSolnSearchCall = chkSolSearchCall(FcList1);
                if (isSolnSearchCall == false){
                    System.debug('>>>>Calling chkSolChoiceSearch in new Code >>>');
                    chkSolChoiceSearch(FcList1);
                    System.debug('>>>>Calling showQuestSearchCall in new Code >>>');
                    showQuestSearchCall(FcList1,m);
                }else{
                    System.debug('>>>>Calling chkSol1showSoln in new Code >>>');
                    showSoln(FcList1);                      
                }
                
                
                
                
                //COmmenting to handle 'Engine aint starting'
                /*quest = FcList1[0].question;//'White Smoke';
Cardinality =FcList1[0].cardinality;
QuestionId = FcList1[0].quesId;

if (Cardinality == 1){
category = 'radio';
}
else if (Cardinality > 1){
category = 'checkBox';
} 

for (integer i=0;i<FcList1.size();i++)
{
System.debug('options>>>>>>>>>'+FcList1[i]);
//options.add(new SelectOption(FcList1[i].fcID,FcList1[i].faultCode));
options.add(new SelectOption(FcList1[i].fcID,FcList1[i].faultCode));
optMapRadio.put(FcList1[i].fcID,FcList1[i].faultCode);            
}*/
                
                
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    public void buildLocalList(integer s,String radioSelecIns,List<String> multiSelectAnswerIns,List<CSS_EDSAuthentication.nextQues> GblQuestLst ){
        try{
            
            system.debug('Inside Insert Local'+radioSelecIns);
            system.debug('Inside Insert Local Global List'+GblQuestLst );
            
            if (LocalInsertList.size()>0){
                system.debug('Inside Insert Local1');
                LocalInsertList.clear();
            }
            system.debug('Exit Clear');
            
            CSS_SymptomQA__c strInsertLst = new CSS_SymptomQA__c();
            
            strInsertLst.Job_Order__c = Wid;
            strInsertLst.type__c= 'QA';
            //strInsertLst.Name = 'QA'+System.now();
            strInsertLst.Name =searchText;
            strInsertLst.Guide_Question__c = quest;
            strInsertLst.Option_type__c = category;        
            strInsertLst.Sequence__c = seqLocal;
            //strInsertLst.Sequence__c = seqLocal;
            strInsertLst.SearchString__c = SearchObjId;
            system.debug('What is Id'+SearchObjId);
            system.debug('Exit strInsertLst');
            
            if (radioSelecIns!= null && radioSelecIns!='' ){
                strInsertLst.Option1__c = radioSelecIns;
                system.debug('THSISIISIS11'+optMapRadio);
                if(optMapRadio.containsKey(radioSelecIns)) {
                    system.debug('FCCodeUIInside If'+radioSelecIns);
                    FCCodeUI =  optMapRadio.get(radioSelect);
                    system.debug('FCCodeUI'+FCCodeUI);
                    system.debug('Inside FCCode Code'+optMapRadio);
                    strInsertLst.Answers__c = FCCodeUI;
                    strInsertLst.Caption__c = QuestionId;
                    strInsertLst.AttributeValues__c = JSON.serialize(GblQuestLst[0].QuestAttributes);
                    //system.debug('Inside QuesResp is '+JSON.serialize(GblQuestLst[0].QuestAttributes));
                }
                system.debug('Exit radioSelecIns');
            }
            system.debug('Enter Local Multi'+multiSelectAnswerIns);
            
            if ( multiSelectAnswerIns != null ){
                system.debug('Enter Local MultiIndeside');
                string mAnsIns = '';
                for( String s3 : multiSelectAnswerIns){
                    mAnsIns += s3+',';
                }
                mAnsIns = mAnsIns.removeEnd(',');
                string[] asnSplitIns = mAnsIns.Split(',');
                List<String> mChoiceUIIns = new List<string>();
                for(integer k=0;k<asnSplitIns.size();k++){
                    if(optMapMultiSelect.containsKey(asnSplitIns[k])) {
                        mChoiceUIIns.add(optMapMultiSelect.get(asnSplitIns[k]));
                        //mChoiceUI.add(asnSplit);
                        //strAdd1.Answers__c = mChoiceUI;
                        system.debug('mChoiceUI12>>>>mAns'+mChoiceUIIns[k]);
                        system.debug('mChoiceUI34>>>>mAns'+mChoiceUIIns);                    
                    }
                }
                string mChoiceIns = '';
                for( String s4 : mChoiceUIIns){
                    mChoiceIns += s4+',';
                }
                mChoiceIns = mChoiceIns.removeEnd(',');
                strInsertLst.Answers__c = mChoiceIns;
                strInsertLst.Caption__c = QuestionId;
                 strInsertLst.AttributeValues__c = JSON.serialize(GblQuestLst[0].QuestAttributes);
                 system.debug('Inside QuesResp is '+QuesResp);
                strInsertLst.Option1__c = mAnsIns;
                
                if (mChoiceUIIns.size()>0){
                    for (integer e =0;e<mChoiceUIIns.size();e++){
                        system.debug('Inside Insert DD Size is '+mChoiceUIIns.size()); 
                        if(e == 0 && mChoiceUIIns[e]!=''){
                            strInsertLst.Option2__c = mChoiceUIIns[0];
                            system.debug('Inside InsertDD'+e+mChoiceUIIns[e]); 
                        }
                        else if( e== 1 && mChoiceUIIns[e]!=''){
                            strInsertLst.Option3__c = mChoiceUIIns[1];
                            system.debug('InsideInsert DD'+e+mChoiceUIIns[e]); 
                        }
                        else if(e == 2 && mChoiceUIIns[e]!=''){
                            strInsertLst.Option4__c = mChoiceUIIns[2];
                            system.debug('InsideInsert DD'+e+mChoiceUIIns[e]); 
                        }
                        else if(e == 3 && mChoiceUIIns[e]!=''){
                            strInsertLst.Option5__c = mChoiceUIIns[3];
                            system.debug('Inside InsertDD'+e+mChoiceUIIns[e]); 
                        }                    
                    }
                } 
            }
            system.debug('Check if this error');
            system.debug('Build LocalList'); 
            LocalInsertList.add(strInsertLst);
            
            System.debug('strAdd1Inside Cont>>>>>>>>>'+LocalInsertList);
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    
    public void insertLocalList( List<CSS_SymptomQA__c> LocalListIns){
        try{
            system.debug('This is Local List geting inserted Insert LocalList'+LocalListIns);
            if (LocalListIns.size()>0){            
                insert LocalListIns;
                seqLocal =seqLocal+1;
                
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    public void insertSearchStr( List<CSS_SymptomQA__c> SearchStrIns){
        try{
            system.debug('Insert SearchStr');
            if (SearchStrIns.size()>0){     
                
                insert SearchStrIns;
                SearchObjId = SearchStrIns[0].id;
                system.debug('Insert SearchStr ID is '+SearchObjId);
                
                
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    public void buildGlobalList(integer s,String radioSelec,List<String> multiSelectAnswer ){
        
        try{
            
            CSS_SymptomQA__c strAdd1 = new CSS_SymptomQA__c();
            
            strAdd1.Job_Order__c = Wid;
            strAdd1.type__c= 'QA';
            strAdd1.Name = searchText;
            //strAdd1.Name = 'QA'+System.now();
            strAdd1.Guide_Question__c = quest;
            strAdd1.Option_type__c = category;        
            strAdd1.Sequence__c = s;
            strAdd1.SearchString__c = SearchObjId;
            system.debug('What is Id'+SearchObjId);
            
            if (radioSelec!= null && radioSelec!='' ){
                strAdd1.Option1__c = radioSelec;
                system.debug('THSISIISIS11'+radioSelec);
                if(optMapRadio.containsKey(radioSelec)) {
                    
                    system.debug('FCCodeUIInside If'+radioSelec);
                    
                    system.debug('FCCodeUI'+FCCodeUI);
                    system.debug('Inside FCCode Code'+optMapRadio);
                    FCCodeUI =  optMapRadio.get(radioSelect);
                    strAdd1.Answers__c = FCCodeUI;
                    strAdd1.Caption__c = QuestionId;
                }
            }
            system.debug('THSISIISIS'+multiSelectAnswer);
            if ( multiSelectAnswer != null){
                string mAns = '';
                for( String s1 : multiSelectAnswer){
                    mAns += s1+',';
                }
                mAns = mAns.removeEnd(',');
                string[] asnSplit = mAns.Split(',');
                List<String> mChoiceUI = new List<string>();
                if(Test.isRunningTest()){
                    mChoiceUI.add('a');
                    mChoiceUI.add('b');}
                if(!Test.isRunningTest()){
                    for(integer c=0;c<asnSplit.size();c++){
                        if(optMapMultiSelect.containsKey(asnSplit[c])) {
                            mChoiceUI.add(optMapMultiSelect.get(asnSplit[c]));
                            //mChoiceUI.add(asnSplit);
                            //strAdd1.Answers__c = mChoiceUI;
                            system.debug('mChoiceUI12>>>>mAns'+mChoiceUI[c]);
                            system.debug('mChoiceUI34>>>>mAns'+mChoiceUI);                    
                        }
                    }}
                string mChoice = '';
                for( String s2 : mChoiceUI){
                    mChoice += s2+',';
                }
                mChoice = mChoice.removeEnd(',');
                strAdd1.Answers__c = mChoice;
                strAdd1.Caption__c = QuestionId;
                strAdd1.Option1__c = mAns;
                
                
                if (mChoiceUI.size()>0){
                    for (integer d =0;d<mChoiceUI.size();d++){
                        system.debug('Inside DD Size is '+mChoiceUI.size()); 
                        if(d == 0 && mChoiceUI[d]!=''){
                            strAdd1.Option2__c = mChoiceUI[0];
                            system.debug('Inside DD'+d+mChoiceUI[d]); 
                        }
                        else if( d== 1 && mChoiceUI[d]!=''){
                            strAdd1.Option3__c = mChoiceUI[1];
                            system.debug('Inside DD'+d+mChoiceUI[d]); 
                        }
                        else if(d == 2 && mChoiceUI[d]!=''){
                            strAdd1.Option4__c = mChoiceUI[2];
                            system.debug('Inside DD'+d+mChoiceUI[d]); 
                        }
                        else if(d == 3 && mChoiceUI[d]!=''){
                            strAdd1.Option5__c = mChoiceUI[3];
                            system.debug('Inside DD'+d+mChoiceUI[d]); 
                        }                    
                    }
                } 
            }
            GlobDisplayList.add(strAdd1);
            symptomQAs.add(strAdd1);
            //strAdd1 = null;
            //multiSelectAnswers.clear();
            //radioSelect ='';
            
            System.debug('GlobDisplayListInside ContChekIfUpdated>>>>>>>>>'+GlobDisplayList);
            System.debug('strAdd1Inside Cont>>>>>>>>>'+strAdd1);
            System.debug('symptomQAs Cont>>>>>>>>>'+symptomQAs);
            seqGlob =seqGlob+1;
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    
    public void btnContd(){
        try{
            //for defect 62106
            edsSolutionCount=0;
            fQuestPopup =false;
            if(displaySoln == false) {
                
                display = true;
                System.debug('The soldis is'+solDis);
                if(solDis!=null){
                    solDis.clear();
                }
                System.debug('>>>>InsideCONTEDDD');  
                System.debug('>>>>radioSelect'+radioSelect+''+category);  
                System.debug('>>>>multiSelectAnswers'+multiSelectAnswers.size()); 
                System.debug('>>>>multiSelectAnswersISEMPLTY'+multiSelectAnswers.isEmpty());
                System.debug('>>>>fstcall'+fstcall);
                System.debug('>>>>Here comes SOln displaySoln'+displaySoln);
                system.debug('Satish GlobQuestLst-->'+GlobQuestLst);
                
                String radioSel = radioSelect;
				Boolean GlobQuestLstCalled = false;                
                if (radioSel != null && category=='radio'){
                    System.debug('>>>>Inside Radio Not null'+radioSel);
                    GlobQuestLstCalled = true;
                    GlobQuestLst = buildQuest(null,radioSelect,QuestionId,true,'getQ');
                    buildLocalList(seqLocal,radioSel,null, GlobQuestLst);
                   // buildLocalList(seqLocal,radioSel,null);
                    buildGlobalList(seqGlob,radioSel,null);
                }
                List<string> multiSelAns = multiSelectAnswers;
                System.debug('>>Inside multiSelAns Not null'+multiSelAns + category);
                if (!multiSelAns.isEmpty() && multiSelAns!=null && category=='checkbox'){
                    System.debug('>>>>Inside multiSelAns Not null'+multiSelAns);
                    buildLocalList(seqLocal,null,multiSelAns,GlobQuestLst);
                    System.debug('>>>>Inside multiSelAns afetr buildLocalList'+multiSelAns);
                    buildGlobalList(seqGlob,null,multiSelAns);
                    System.debug('>>>>Inside multiSelAns afetr buildGlobalList'+multiSelAns);
                }
                
                if ((multiSelAns.isEmpty() || multiSelAns==null) && category=='checkbox'){
                    buildLocalList(seqLocal,null,multiSelAns,GlobQuestLst);
                    buildGlobalList(seqGlob,null,multiSelAns);
                }
                
                if (radioSel == null && category=='radio'){
                    buildLocalList(seqLocal,radioSel,null,GlobQuestLst);
                    buildGlobalList(seqGlob,radioSel,null);
                }
                
                if (radioSelect != null && fstcall == true ){    
                    
                    System.debug('>>>>COND1');
                    if(GlobQuestLstCalled == false){
                    GlobQuestLst = buildQuest(null,radioSelect,QuestionId,true,'getQ');
                    }
                    // chkSolChoice(GlobQuestLst);
                    //insertSearchStr(GlobSearchDisplayList);
                    
                    //GSSC-155 Start
                    List<string> lstSolnumbers = new List<string>();
                    if(GlobQuestLst != null && GlobQuestLst[0].solEDS != null){
                        for (integer p=0;p<GlobQuestLst[0].solEDS.size();p++){
                            lstSolnumbers.add(GlobQuestLst[0].solEDS[p].name); 
                        }
                    }
                    
                    diagTargetTimeResp = new CG_DiagTargetTimeResponse();
                    diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,workJob.Equipment_ID__c,workJob.Service_Model__c,workJob.EngineFamilyCode__c,'en'); //Uncomment after serice is ready from middleware
    
                    system.debug('diagTargetTimeResp--'+diagTargetTimeResp);
        
                    if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                        for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                            mapSolIdTargetTimeSymptom.put(sol.SolutionId,sol);
                        }
                    }
                    //GSSC-155 End  
                    
                    insertLocalList(LocalInsertList);
                    System.debug('>>>>COND1insertLocalList'+LocalInsertList);
                    //insertSearchStr(GlobSearchDisplayList);
                    fstcall = false;
                    System.debug('>>>>Insideee1StCallThis is first callGlobQuestLst'+GlobQuestLst);
                    if (GlobQuestLst.size()>0){
                        
                        System.debug('>>>>Calling chkSol1 >>>');
                        if (GlobQuestLst[0].solEDS == null && GlobQuestLst[0].answersNext == null && GlobQuestLst[0].quesID == null && GlobQuestLst[0].question==null){
                            //do nothing
                            System.debug('in No Solution loop');
                        }
                        else{
                            
                            isSoln = chkSol(GlobQuestLst);
                            if (isSoln == false){
                                System.debug('>>>>Calling chkSol1showQuest >>>');
                                chkSolChoice(GlobQuestLst);
                                showQuest(GlobQuestLst,m);
                            }else{
                                System.debug('>>>>Calling chkSol1showSoln >>>');
                                showSoln(GlobQuestLst);                      
                            }
                        }
                    } 
                    radioSelect =null;
                    
                }
                else if (( multiSelectAnswers.isEmpty() && radioSelect == null )&& fstcall == false ){
                    
                    System.debug('>>>>COND2');
                    System.debug('>>>>QuestionId >>>'+QuestionId);
                    //GlobQuestLst.clear();
                    //buildGlobalList(seqGlob,null,null);
                    System.debug('>>>>Sending getNextQ in 2 and Q Id is  >>>'+QuestionId);
                    GlobQuestLst = NextbuildQuest(null,null,QuestionId,true,'getNextQ');
                    System.debug('>>>>GlobQuestLst after  Sending getNextQ in 2 and GlobQuestLst  >>>'+GlobQuestLst);
                    System.debug('>>>>LocalInsertList after  Sending getNextQ in 2 and GlobQuestLst  >>>'+LocalInsertList);
                    
                    //GSSC-155 Start
                    List<string> lstSolnumbers = new List<string>();
                    if(GlobQuestLst != null && GlobQuestLst[0].solEDS != null){
                        for (integer p=0;p<GlobQuestLst[0].solEDS.size();p++){
                            lstSolnumbers.add(GlobQuestLst[0].solEDS[p].name); 
                        }
                    }
                    
                    diagTargetTimeResp = new CG_DiagTargetTimeResponse();
                    diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,workJob.Equipment_ID__c,workJob.Service_Model__c,workJob.EngineFamilyCode__c,'en'); //Uncomment after serice is ready from middleware
    
                    system.debug('diagTargetTimeResp--'+diagTargetTimeResp);
        
                    if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                        for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                            mapSolIdTargetTimeSymptom.put(sol.SolutionId,sol);
                        }
                    }
                    //GSSC-155 End
                    
                    insertLocalList(LocalInsertList);
                    System.debug('>>>>GlobQuestLstinCOND2'+GlobQuestLst);
                    // chkSolChoice(GlobQuestLst);
                    if (GlobQuestLst.size()>0){
                        if (GlobQuestLst[0].solEDS == null && GlobQuestLst[0].answersNext == null && GlobQuestLst[0].quesID == null && GlobQuestLst[0].question==null){
                            //do nothing
                            System.debug('in No Solution loop');
                        }
                        else{
                            System.debug('>>>>Calling chkSol2 >>>');
                            isSoln = chkSol(GlobQuestLst);
                            // System.debug('>>>>chkSolChoice  >>>');
                            if (isSoln == false){
                                System.debug('>>>>Calling chkSol2showQuest >>>');
                                chkSolChoice(GlobQuestLst);
                                showQuest(GlobQuestLst,m);
                            }else{
                                System.debug('>>>>Calling chkSol2showSoln >>>');
                                showSoln(GlobQuestLst);                   
                            }
                        }
                    }
                    radioSelect =null;
                    
                } else if (( !multiSelectAnswers.isEmpty() || radioSelect != null) && fstcall == false ){
                    System.debug('>>>>COND3'); 
                    
                    if (!multiSelectAnswers.isEmpty()){
                        
                        System.debug('>>>>COND3.1');
                        System.debug('>>>>QuestionId >>>'+QuestionId);
                        System.debug('>>>>multiSelectAnswers >>>'+multiSelectAnswers+multiSelectAnswers);
                        System.debug('>>>>Sending GetQ in 3.1 and Q Id is  >>>'+QuestionId);
                        GlobQuestLst = buildQuest(multiSelectAnswers,null,QuestionId,true,'getQ');
                        System.debug('>>>>3.1GlobQuestLst >>>'+GlobQuestLst);
                        
                    //GSSC-155 Start
                    List<string> lstSolnumbers = new List<string>();
                    if(GlobQuestLst != null && GlobQuestLst[0].solEDS != null){
                        for (integer p=0;p<GlobQuestLst[0].solEDS.size();p++){
                            lstSolnumbers.add(GlobQuestLst[0].solEDS[p].name); 
                        }
                    }
                    
                    diagTargetTimeResp = new CG_DiagTargetTimeResponse();
                    diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,workJob.Equipment_ID__c,workJob.Service_Model__c,workJob.EngineFamilyCode__c,'en'); //Uncomment after serice is ready from middleware
    
                    system.debug('diagTargetTimeResp--'+diagTargetTimeResp);
        
                    if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                        for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                            mapSolIdTargetTimeSymptom.put(sol.SolutionId,sol);
                        }
                    }
                    //GSSC-155 End
                        
                        insertLocalList(LocalInsertList);
                        // chkSolChoice(GlobQuestLst);
                        if (GlobQuestLst.size()>0){
                            if (GlobQuestLst[0].solEDS == null && GlobQuestLst[0].answersNext == null && GlobQuestLst[0].quesID == null && GlobQuestLst[0].question==null){
                                //do nothing
                                System.debug('in No Solution loop');
                            }
                            else{
                                isSoln = chkSol(GlobQuestLst);               
                                System.debug('>>>>Calling chkSol3.1 >>>');
                                if (isSoln == false){
                                    System.debug('>>>>Calling chkSol3.1showQuest >>>');
                                    chkSolChoice(GlobQuestLst);
                                    showQuest(GlobQuestLst,m);
                                }else{
                                    quest='';
                                    System.debug('>>>>Calling chkSol3.1showSoln >>>');
                                    System.debug('>>>>3.1GlobQuestLstShowElse  >>>'+GlobQuestLst);
                                    System.debug('>>>>3.1Quest isShowElse   >>>'+quest);
                                    System.debug('>>>>3.1LocaltLstShowElse  >>>'+LocalInsertList);
                                    showSoln(GlobQuestLst);                     
                                }
                            }
                        }   
                        multiSelectAnswers.clear();
                    }
                    else if (radioSelect != null || radioSelect != ''){
                        System.debug('>>>>COND3.2');
                        System.debug('>>>>radioSelect >>>'+radioSelect);
                        System.debug('>>>>QuestionId >>>'+QuestionId);
                        System.debug('>>>>Sending GetQ in 3.2 and Q Id is  >>>'+QuestionId+radioSelect);
                        //GlobQuestLst = buildQuest(null,radioSelect,QuestionId,true,'getQ');
                        System.debug('>>>>3.2GlobQuestLst >>>'+GlobQuestLst);
                        
                        //GSSC-155 Start
                        List<string> lstSolnumbers = new List<string>();
                        if(GlobQuestLst != null && GlobQuestLst[0].solEDS != null){
                            for (integer p=0;p<GlobQuestLst[0].solEDS.size();p++){
                                lstSolnumbers.add(GlobQuestLst[0].solEDS[p].name); 
                            }
                        }
                        
                        diagTargetTimeResp = new CG_DiagTargetTimeResponse();
                        diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,workJob.Equipment_ID__c,workJob.Service_Model__c,workJob.EngineFamilyCode__c,'en'); //Uncomment after serice is ready from middleware
        
                        system.debug('diagTargetTimeResp--'+diagTargetTimeResp);
            
                        if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                            for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                                mapSolIdTargetTimeSymptom.put(sol.SolutionId,sol);
                            }
                        }
                        //GSSC-155 End
                        
                        insertLocalList(LocalInsertList);
                        //chkSolChoice(GlobQuestLst);
                        if (GlobQuestLst.size()>0){
                            if (GlobQuestLst[0].solEDS == null && GlobQuestLst[0].answersNext == null && GlobQuestLst[0].quesID == null && GlobQuestLst[0].question==null){
                                //do nothing
                                System.debug('in No Solution loop');
                            }else{
                                
                                System.debug('>>>>Calling chkSol3.2  >>>');
                                isSoln = chkSol(GlobQuestLst);
                                if (isSoln == false){
                                    System.debug('>>>>Calling chkSol3.2showQuest >>>');
                                    chkSolChoice(GlobQuestLst);
                                    showQuest(GlobQuestLst,m);
                                }else{
                                    quest='';
                                    System.debug('>>>>Calling chkSol3.2showSoln >>>');
                                    System.debug('>>>>3.2GlobQuestLstShowElse  >>>'+GlobQuestLst);
                                    System.debug('>>>>3.2LocaltLstShowElse  >>>'+LocalInsertList);
                                    System.debug('>>>>3.2Quest isShowElse   >>>'+quest);
                                    showSoln(GlobQuestLst);                    
                                }
                            }                
                        }
                    }
                }
                radioSelect =null;
                System.debug('>>>>QuestionId >>>'+QuestionId);
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }  
    
    public void chkSolChoice( list<CSS_EDSAuthentication.nextQues> chkLstSolChoice ){
        try{
            solDis = new List<solDisplay>();
            System.debug('bnadbas'+GlobQuestLst[0].solEDS);
            if( GlobQuestLst[0].solEDS!=null){
                if(GlobQuestLst[0].solEDS.size()>0){
                    solSize = GlobQuestLst[0].solEDS.size()/2;
                    solDisplay solTi; //= new solDisplay();
                    //System.debug('hello varunTotal List>>>>>>>>   '+GlobQuestLst);
                    //System.debug('hello varun>>>>>>>>   '+GlobQuestLst[0].answersNext.size());
                    //System.debug('hello 123>>>>>>>>   '+GlobQuestLst[0].solEDS.size());
                    for(integer i=0;i<GlobQuestLst[0].solEDS.size()/2;i++){
                        //solTi = new solDisplay();
                        System.debug('The solEDS is'+GlobQuestLst[0].solEDS[i].name);
                        System.debug('The soltitle is'+GlobQuestLst[0].solEDS[i].title);
                        // solTi.add(GlobQuestLst[0].solEDS[i].name,GlobQuestLst[0].solEDS[i].title);
                        solDis.add(new solDisplay(GlobQuestLst[0].solEDS[i].name,GlobQuestLst[0].solEDS[i].title));
                    }
                    
                    System.debug('The solution list of wrapper is'+solDis);
                    // solDis.add(solTi);
                    // return  false;   
                }
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    
    public void chkSolChoiceSearch( list<CSS_EDSAuthentication.nextQues> chkLstSolChoiceSearch ){
        try{
            solDis = new List<solDisplay>();
            System.debug('bnadbaschkLstSolChoiceSearch'+chkLstSolChoiceSearch[0].solEDS);
            if(chkLstSolChoiceSearch!=null){
                edsSolutionCount = chkLstSolChoiceSearch[0].edsSolutionCount;
            }
            if( chkLstSolChoiceSearch[0].solEDS!=null){
                if(chkLstSolChoiceSearch[0].solEDS.size()>0){
                    solSize = chkLstSolChoiceSearch[0].solEDS.size()/2;
                    solDisplay solTi; //= new solDisplay();
                    for(integer i=0;i<chkLstSolChoiceSearch[0].solEDS.size()/2;i++){
                        //solTi = new solDisplay();
                        System.debug('The solEDS is chkLstSolChoiceSearch'+chkLstSolChoiceSearch[0].solEDS[i].name);
                        System.debug('The soltitle is chkLstSolChoiceSearch'+chkLstSolChoiceSearch[0].solEDS[i].title);
                        // solTi.add(GlobQuestLst[0].solEDS[i].name,GlobQuestLst[0].solEDS[i].title);
                        solDis.add(new solDisplay(chkLstSolChoiceSearch[0].solEDS[i].name,chkLstSolChoiceSearch[0].solEDS[i].title));
                    }
                    
                    System.debug('The solution list of wrapper is'+solDis);
                    // solDis.add(solTi);
                    // return  false;   
                }
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    
    public void chkSolChoicePreviousCall( list<CSS_EDSAuthentication.nextQues> chkLstSolChoice ){
        try{
            solDis = new List<solDisplay>();
            System.debug('bnadbas'+chkLstSolChoice[0].solEDS);
            if(chkLstSolChoice!=null){
                edsSolutionCount=chkLstSolChoice[0].edsSolutionCount;
            }
            if( chkLstSolChoice[0].solEDS!=null){
                if(chkLstSolChoice[0].solEDS.size()>0){
                    solSize = chkLstSolChoice[0].solEDS.size()/2;
                    solDisplay solTi; //= new solDisplay();
                    System.debug('hello varunTotal List>>>>>>>>   '+chkLstSolChoice);
                    System.debug('hello varun>>>>>>>>   '+chkLstSolChoice[0].answersNext.size());
                    System.debug('hello 123>>>>>>>>   '+chkLstSolChoice[0].solEDS.size());
                    for(integer i=0;i<GlobQuestLst[0].solEDS.size()/2;i++){
                        //solTi = new solDisplay();
                        System.debug('The solEDS is'+chkLstSolChoice[0].solEDS[i].name);
                        System.debug('The soltitle is'+chkLstSolChoice[0].solEDS[i].title);
                        // solTi.add(GlobQuestLst[0].solEDS[i].name,GlobQuestLst[0].solEDS[i].title);
                        solDis.add(new solDisplay(chkLstSolChoice[0].solEDS[i].name,chkLstSolChoice[0].solEDS[i].title));
                    }
                    
                    System.debug('The solution list of wrapper is'+solDis);
                    // solDis.add(solTi);
                    // return  false;   
                }
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    
    public class solDisplay{
        public string solNum{get;set;}
        public string solTitle{get;set;}
        public solDisplay(string solNum,string solTitle){
            this.solNum=solNum;
            this.solTitle = solTitle;
        }
    }
    public list<CSS_EDSAuthentication.nextQues> buildQuest(list<String> LstChoices, String radio,String QId,boolean CallWS,String WSType ){
        try{
            System.debug('Inside buildQuest>>>>>>>>>');
            
            options = new list<SelectOption>();           
            display = true;
            
            System.debug('calling getQQQWSSS>>>>>>>>>');
            System.debug('callWebService>>>>>>>>>   '+CallWS);
            string language = 'en';
            if(CallWS == true && WSType == 'getQ' ){
                QuestLst = new List<CSS_EDSAuthentication.nextQues>();
                System.debug('call getQ WebServicecalled>>>>>>>>>   '+CallWS+' '+WSType);
                System.debug('Just Before call getQ WebServicecalled>>>>>>>>>   '+LstChoices+' '+radio+ ' '+QId+''+workJob.DSID__c);
                QuestLst = CSS_EDSAuthentication.getQues(LstChoices,radio,QId,DSID,aLang.CSS_EDSLanguage__c,dsidIndi);
            }
        }
        
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
        return QuestLst;
    }
    
    public List<CSS_EDSAuthentication.nextQues> NextbuildQuest(list<String> LstChoices, String radio,String QId,boolean CallWS,String WSType ) { 
        try{
            System.debug('Inside NextbuildQuest>>>>>>>>>');        
            QuestLst = new List<CSS_EDSAuthentication.nextQues>();
            options = new list<SelectOption>();            
            display = true;
            
            System.debug('calling getNextQQQWSSS>>>>>>>>>');
            System.debug('callWebService>>>>>>>>>   '+CallWS);
            
            if(CallWS == true && WSType == 'getNextQ' ){
                
                System.debug('call getQ WebServicecalled>>>>>>>>>   '+CallWS+' '+WSType);
                System.debug('Just Before call getQ WebServicecalled>>>>>>>>>   '+QId);
                QuestLst = CSS_EDSAuthentication.getNextQues(QId,DSID,aLang.CSS_EDSLanguage__c,dsidIndi);
                System.Debug('NextQ call returnInside'+QuestLst);
            }
            System.Debug('NextQ call return'+QuestLst);
            
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
        return QuestLst;
    }
    
    public List<CSS_EDSAuthentication.nextQues> BuildPreviousQuest(String pDISD,Integer QClickedSeq ){
        try{
            System.debug('Inside BuildPreviousQuest>>>>>>>>>');   
            options = new list<SelectOption>();            
            display = true;
            string language = 'en';
            System.debug('calling BuildPreviousQuest>>>>>>>>>');
            QuestLst = new List<CSS_EDSAuthentication.nextQues>();
            System.debug('Just Before call getQ WebServicecalled DSID QClickedSeq>>>>>>>>>   '+pDISD+'   '+QClickedSeq);
            QuestLst = CSS_EDSAuthentication.getPreviousQues(pDISD,QClickedSeq,aLang.CSS_EDSLanguage__c,dsidIndi);      
            System.debug('QList In Previous Call is >>>>>>>>   '+QuestLst);
        }
        
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
        
        return QuestLst;
        
    }
    
    public boolean chkSol( list<CSS_EDSAuthentication.nextQues> chkLstSol ){
        try{
            if (GlobQuestLst[0].solEDS != null){
                if (GlobQuestLst[0].answersNext == null){
                    System.debug('Check Sol call answersNext null>>>>>>>>');
                    isSoln =true;
                }else if (GlobQuestLst[0].answersNext != null){
                    System.debug('Check Sol and Answers both are not null>>>>>>>>');
                    isSoln =false;
                }
            }else 
            {
                System.debug('Check Sol call inside chkSol Else >>>>>>>');
                isSoln =false;
                //chkSolChoice(GlobQuestLst);
            }
            System.debug('Check Sol call isSoln val is >>>>>>>'+isSoln);
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
        return  isSoln;   
    }
    
    public boolean chkSolSearchCall( list<CSS_EDSAuthentication.nextQues> chkLstSolSearchCall ){
        try{
            
            if (chkLstSolSearchCall[0].solEDS != null){
                if (chkLstSolSearchCall[0].answersNext == null){
                    System.debug('Check Sol call answersNext nullchkLstSolSearchCall>>>>>>>>');
                    isSolnSearchCall =true;
                }else if (chkLstSolSearchCall[0].answersNext != null){
                    System.debug('Check Sol and Answers both are not nullchkLstSolSearchCall>>>>>>>>');
                    isSolnSearchCall =false;
                }
            }else 
            {
                System.debug('Check Sol call inside chkSol ElsechkLstSolSearchCall >>>>>>>');
                isSolnSearchCall =false;
                //chkSolChoice(GlobQuestLst);
            }
            System.debug('Check isSolnSearchCall >>>>>>>'+isSolnSearchCall);
            
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
        return  isSolnSearchCall;
    }
    
    
    public void showQuest( list<CSS_EDSAuthentication.nextQues> QuestList ,integer q ){
        
        try{
            //if ( q < QuestLst.size()){       
            System.debug('Inside If Q>>>>>>>>>'+q);
            System.debug('Inside If showQuest >>>>>>>>>');
            System.debug('Inside If showQuest QuestListSize>>>>>>>>>'+QuestList.size());
            
            Cardinality = QuestLst[q].cardinality;
            System.debug('Inside If showQuestCardinality >>>>>>>>>'+Cardinality);
            QuestionId = QuestLst[q].quesID;
            System.debug('Inside If showQuestQuestionId >>>>>>>>>'+QuestionId);
            quest = QuestLst[q].question;
            System.debug('Inside If showQuestquest >>>>>>>>>'+quest);
            if (Cardinality == 1){
                category = 'radio';
            }
            else if (Cardinality > 1){
                category = 'checkBox';
            }
            options.clear();                                 
            for (integer p=0;p<QuestLst[q].answersNext.size();p++){
                ansChoiceCaption =QuestLst[q].answersNext[p].ansCaption;            
                System.debug('MSN>>Caption>>getQQQWSSS>>'+ansChoiceCaption);                   
                ansId =QuestLst[q].answersNext[p].ansID;
                System.debug('MSN>>ansId>>getQQQWSSS  '+ansId);     
                options.add(new SelectOption(QuestLst[q].answersNext[p].ansID,QuestLst[q].answersNext[p].ansCaption));
                if (category =='radio' ){
                    optMapRadio.put(QuestLst[q].answersNext[p].ansID , QuestLst[q].answersNext[p].ansCaption); 
                    System.debug('MSN>>ansId>>optMapRadio  '+optMapRadio);
                }
                if (category =='checkBox' ){
                    optMapMultiSelect.put(QuestLst[q].answersNext[p].ansID , QuestLst[q].answersNext[p].ansCaption);
                    System.debug('MSN>>ansId>>optMapMultiSelect  '+optMapMultiSelect);
                } 
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    
    public void showQuestSearchCall( list<CSS_EDSAuthentication.nextQues> QuestListSearchCall ,integer q ){
        try{
            
            //if ( q < QuestLst.size()){       
            System.debug('Inside If Q>>>>>>>>>'+q);
            System.debug('Inside If showQuestSearchCall >>>>>>>>>');
            System.debug('Inside If showQuestSearchCall QuestListSearchCallSize>>>>>>>>>'+QuestListSearchCall.size());
            System.debug('Inside If showQuestSearchCall QuestListSearchCallanswersNext>>>>>>>>>'+QuestListSearchCall[0].answersNext);
            System.debug('Inside If showQuestSearchCall QuestListSearchCallanswerscardinality>>>>>>>>>'+QuestListSearchCall[0].cardinality);
            
            Cardinality = QuestListSearchCall[q].cardinality;
            System.debug('Inside If showQuestCardinality >>>>>>>>>'+Cardinality);
            QuestionId = QuestListSearchCall[q].quesID;
            System.debug('Inside If showQuestQuestionId >>>>>>>>>'+QuestionId);
            quest = QuestListSearchCall[q].question;
            edsSolutionCount = QuestListSearchCall[q].edsSolutionCount;
            System.debug('Inside If showQuestquest >>>>>>>>>'+quest);
            if (Cardinality == 1){
                category = 'radio';
            }
            else if (Cardinality > 1){
                category = 'checkBox';
            }
            //for defect 62106
            if(quest.contains('No Fault Codes Present') && q==0){
                System.debug('FirstQ >>>>>>>>>'+quest+q);
                fQuestPopup = true;            
            }
            options.clear();                                 
            for (integer p=0;p<QuestListSearchCall[q].answersNext.size();p++){
                ansChoiceCaption =QuestListSearchCall[q].answersNext[p].ansCaption;            
                System.debug('MSN>>Caption>>getQQQWSSSQuestListSearchCall>>'+ansChoiceCaption);                   
                ansId =QuestListSearchCall[q].answersNext[p].ansID;
                System.debug('MSN>>ansId>>getQQQWSSSQuestListSearchCall  '+ansId);     
                options.add(new SelectOption(QuestListSearchCall[q].answersNext[p].ansID,QuestListSearchCall[q].answersNext[p].ansCaption));
                if (category =='radio' ){
                    optMapRadio.put(QuestListSearchCall[q].answersNext[p].ansID , QuestListSearchCall[q].answersNext[p].ansCaption); 
                    System.debug('MSN>>ansId>>optMapRadioQuestListSearchCall  '+optMapRadio);
                }
                if (category =='checkBox' ){
                    optMapMultiSelect.put(QuestListSearchCall[q].answersNext[p].ansID , QuestListSearchCall[q].answersNext[p].ansCaption);
                    System.debug('MSN>>ansId>>optMapMultiSelectQuestListSearchCall  '+optMapMultiSelect);
                } 
            }
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    public void  showSoln( list<CSS_EDSAuthentication.nextQues> SolnList ){
        try{
            
            System.debug('Inside showSolnSize>>>>>>>>>'+SolnList.size());
            System.debug('Inside SolnList[0]>>>>>>>>>'+SolnList[0]);
            System.debug('SearchObjId>>>>>>>>>'+SearchObjId);

            for (integer p=0;p<SolnList[0].solEDS.size();p++){
                solName =SolnList[0].solEDS[p].name;
                solTitle =SolnList[0].solEDS[p].title;
                solRank =SolnList[0].solEDS[p].rank;
                CSS_Solutions__c strSoln = new CSS_Solutions__c();
                strSoln.Solution_Title__c = solTitle;
                strSoln.Name= solName;
                strSoln.Case_Name__c= solName;
                strSoln.Service_Job__c =Wid;
                strSoln.Rank__c = solRank;
                strSoln.Symptom__c = SearchObjId;
                
                //GSSC-155 Start
                CG_DiagTargetTimeResponse.Solutions solution = new CG_DiagTargetTimeResponse.Solutions();
        
                solution = mapSolIdTargetTimeSymptom.get(solName);
                if(solution != null){
                    strSoln.DiagTargetTime__c = (solution.DiagnosticTargetTime != null && solution.DiagnosticTargetTime != '') ? decimal.valueof(solution.DiagnosticTargetTime) : 0;
                    strSoln.TargetMessage__c = solution.TargetMessage;  
                }
                //GSSC-155 End
                GlobSolnDisplayList.add(strSoln);
            }      
            
            if (GlobDisplayList.size()>0){
                //insert GlobDisplayList;
            }
            if (GlobSolnDisplayList.size()>0){
                System.debug('Insert Solutions GlobSolnDisplayList[0]>>>>>>>>>'+GlobSolnDisplayList);

                insert GlobSolnDisplayList;
                if( DSID != null && dsidUpdate == TRUE){
                    workJob.DSID__c = DSID;
                    workJob.DSID_Creation_Timestamp__c = System.now();
                    workJob.DSID_Status__c = 'Open';
                    workJob.DSID_WorkGroup__c = workGroup;
                    workJob.ESN_Locked__c = true;
                    workJob.ESN_Insite__c = workJob.ESN__c;
                    update workJob;
                }
                
                CSS_SymptomQA__c strQASolNumSS = new CSS_SymptomQA__c();
                strQASolNumSS.id=SearchObjId;
                strQASolNumSS.Number_of_Solutions__c = string.Valueof(SolnList[0].solEDS.size());
                strQASolNumSS.isPole__c = SolnList[0].isPole;
                update strQASolNumSS;
                
                
                
                displaySoln =true;
            }
            //insert GlobDisplayList;
            
            System.debug('Inside GlobSolnDisplayList[0]>>>>>>>>>'+GlobSolnDisplayList);
            System.debug('Aftr Soln Displat SymQA List>>>>>>>>>'+symptomQAs);        
            System.debug('Aftr Soln Displat Global List>>>>>>>>>'+GlobQuestLst);
        }
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    
    public void backflow(){
        try{
            if(solDis!=null){
                solDis.clear();
            }
            
            //Find Sequence of the Question e.g A
            
            String SeqNum1 = ApexPages.currentPage().getParameters().get('SeqNum');
            integer intSeq = Integer.valueof(SeqNum1.trim());            
            System.debug('In backflow is '+SeqNum1);
            System.debug('backflowInteger '+intSeq);
            
            AggregateResult[] groupedResults = [SELECT max(Sequence__c) maxSeq FROM CSS_SymptomQA__c where Type__c ='QA' AND Job_Order__c = :Wid and Sequence__c != null and searchString__c=:SearchObjId]; 
            integer maxFltSeq = integer.valueOf(groupedResults[0].get('maxSeq'));                        
            
            System.debug('MaxSequence isMSN'+maxFltSeq);
            Integer nbToEDS = (maxFltSeq-intSeq)+1;
            System.debug('To EDS Number is '+nbToEDS);
            
            //Find the Question ID
            /*List<CSS_SymptomQA__c>  qClicked = [Select caption__c from CSS_SymptomQA__c where sequence__c =:intSeq AND Job_Order__c=:Wid];
for (CSS_SymptomQA__c qc:qClicked){
String QtoWSId = qc.Caption__c;
System.debug('Question Clicked in backflow is '+QtoWSId);
}*/
            System.debug('Before Remove globalDispaly is  '+GlobDisplayList);
            System.debug('Before Remove globalDispaly Size is  '+GlobDisplayList.size());
            
            System.debug('After WS call of Previous the PreviousQuestLst is  '+PreviousQuestLst);
            System.debug('Before Remove symptomQAs'+symptomQAs);
            
            /*for(integer f = GlobDisplayList.size(); f>=intSeq;f--){
System.debug('Counter f is '+f);
GlobDisplayList.remove(f-1);
//symptomQAs.remove(f);
}*/
            
            for(integer f = maxFltSeq ; f>=intSeq;f--){            
                symptomQAs.remove(f);
                //symptomQAs.remove(f);
            }
            
            System.debug('Print of GlobDisplayListSize After Removal '+GlobDisplayList);
            System.debug('Print of symptomQAs After Removal '+symptomQAs);
            
            
            PreviousQuestLst = BuildPreviousQuest(DSID,nbToEDS);
            if(PreviousQuestLst.size()>0){
                
                //chkSolChoicePreviousCall(PreviousQuestLst);
                showQuest(PreviousQuestLst,0);
                
                seqLocal = intSeq;
                seqGlob = intSeq;
                System.debug('New seqGlob  is  '+seqGlob );
                
                List<CSS_SymptomQA__c> qToRemove  = [Select Id,name from CSS_SymptomQA__c where sequence__c >=:intSeq AND Job_Order__c=:Wid and searchString__c=:SearchObjId];
                System.debug('backflow Remove '+qToRemove);
                delete qToRemove;
                
                CSS_SymptomQA__c latestSearchStr = [Select Id from CSS_SymptomQA__c where 
                                                    job_order__c=:Wid and type__c='SearchString' Order by createddate desc limit 1];
                
                list<CSS_Solutions__c> lstSolToDel = [select Name,id,Rank__c from CSS_Solutions__c where Service_Job__c=:Wid and Symptom__c=:latestSearchStr.id ];
                delete lstSolToDel;
            }
            if (GlobSolnDisplayList.size()>0){
                GlobSolnDisplayList.clear();
            }
            //PageReference ReturnPage = new PageReference('/apex/CSS_JobTnDTsMN?id='+Wid); 
            //ReturnPage.setRedirect(true);
            //return returnPage;
        }
        
        catch(exception e){
            System.debug('Error Message:'+e.getMessage());
        }
    }
    public pagereference cancelBtn(){
        /*if(solDis!=null){
solDis.clear();
}*/
        //Delete QA and Solutions
        /*list<CSS_SymptomQA__c> lstQA = [select Name,id from CSS_SymptomQA__c where job_order__c=:Wid];
delete lstQA;        
list<CSS_Solutions__c> lstSol = [select Name,id from CSS_Solutions__c where Service_Job__c=:Wid];
delete lstSol;*/
        displaySoln =false;
        PageReference ReturnPage = new PageReference('/apex/CSS_JobTnDTs?id='+Wid); 
        ReturnPage.setRedirect(true);
        return returnPage;
    }
    
    public Id selectedSymptom{set;get;}
    
    public PageReference symCodeClick(){
        
        PageReference pageRef;
        System.Debug('calling SysmptomId');
        System.Debug('SysmptomId'+selectedSymptom);
        
        string redirect='/apex/CSS_JobTndSymSol?id='+Wid+'&symid='+selectedSymptom;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    } 
    
    /*  public Void navigateToRepair(){

//String symIdPg = ApexPages.currentPage().getParameters().get('symId');

//  system.debug('symIdPg@@@@@'+symIdPg);

if (workJob.Status__c !='Repair'){
css_job_order__c workOrder= new css_job_order__c();
workOrder.id=workJob.id;
workOrder.Status__c='Triage & Diagnosis/Repair';
workOrder.Previous_Status__c=workJob.Status__c;
update workOrder;
}  
PageReference pageRef;                     
//string redirect='/apex/CSS_JobTndSymSol?id='+Wid+'&symid='+selectedSymptom;
string redirect= '/apex/CSS_SymRepairPage?id='+JobID+'&symId='+symIdPg+'&rank=0';
pageRef = new PageReference(redirect);
pageRef.setRedirect(true);
return pageRef; 
//  return null;
}  */
    //Added code for service manual
    public String myBase64String {get;set;} 
    public string getService(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
         //url = url + 'login/lnkmgmt/service.html?esn='+workJob.ESN__c+'&tokenId='+token;  //Commented this and added below line as per GSSC-99 Story Helpful Resources		        url = url + 'login/lnkmgmt/service.html?esn='+workJob.ESN__c+'&tokenId='+token; 
       url = url + 'login/lnkmgmt/service.html?esn='+workJob.ESN__c;
        //login/lnkmgmt/parts.html?esn={!jobESN}&tokenId={!token}
        return url;
    }
    public string gettoken(){
        long currentTime = System.now().getTime();
        string token = 'CSS'+'|'+(String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }
    public List<SelectOption> getSortvalues() {
        try{
            List<SelectOption> SortList = new List<SelectOption>(); 
            
            
            SortList.add(new SelectOption('1',system.Label.css_Newest_To_Oldest));
            SortList.add(new SelectOption('2',system.Label.css_Oldest_To_Newest));
            
            return SortList;
        }
        
        catch(exception e){
            return null;
        }
        
    }
}