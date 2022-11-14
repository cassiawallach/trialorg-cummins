public class CSS_SymSolDetails {
    
    
    public String selSolution {get; set;}
    public User u3{get;set;}
    public CSS_accountLanguage__c aLang{get;set;}
    public String selectedSymId{set;get;}
    public String selectedSolId{set;get;}
    public string rankFromTs{get;set;}
    public String rank {get;set;}
    public Id Ins_JobId{set;get;}
    public css_job_order__c rJobOrd {get;set;}
    public boolean nestedacessrtboolean{get;set;}
    public Boolean failDiagResp{get;set;}
    public boolean accesserorboolean{get;set;}
    public Boolean nestFailDiagResp{get;set;}
    public CSS_J2ASolution_EDS solDet{get;set;}
    public List<CSS_Solutions__c> solDetails{get;set;}
  //  public NestedSolutionsClass selectedNestSol{set;get;}
 //   public map<string,NestedSolutionsClass> respNestedSolutionsMap;
    public boolean inddsid{get; set;}
    public Boolean isSolnExpired {get;set;}
    public string successMessage{get;set;}
    public Boolean reportMessage{get;set;}
    public String solutionId {get;set;}
    public String solutionTitle {get;set;}
    public CSS_Solutions__c selectedSol{get;set;}
    public Id JobsolutionId {get;set;}
    public map<string,CSS_Solutions__c> nestedSolutionsMap;
    public Boolean solDetFailed{set;get;}
    public String solErrorMsg{set;get;}
    public List<CSS_Solutions__c> solListNew = new List<CSS_Solutions__c>();
    public List<CSS_Solution_Component__c> solCompNew = new List<CSS_Solution_Component__c>();
 //   public list<NestedSolutionsClass> nestedSolutionsList{get;set;}
    public boolean Out_Of_Order_Popup_displayed {get;set;}
    public Boolean displayOutofOrd {set;get;}
    public Boolean displayOutofOrder {set;get;}
/*    public Class NestedSolutionsClass {
        public CSS_J2ASolution_EDS.verCompoundSolutions repCompSol{get;set;} 
        public CSS_Solutions__c solRec{set;get;}
        
        //constructor
        public NestedSolutionsClass(CSS_J2ASolution_EDS.verCompoundSolutions nestSol,CSS_Solutions__c sol){
            this.repCompSol = nestSol;
            this.solRec = sol;
        }
    }*/
    public CSS_SymSolDetails(){
   
     selSolution=''; 
        u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
        aLang = css_utility.getLanguage(u3.LanguageLocaleKey);
        solDetFailed = false;
        displayOutofOrder = false;
        displayOutofOrd = false;
        selectedSymId = ApexPages.CurrentPage().getParameters().get('symid');
        system.debug('selectedSymId****'+selectedSymId);
        
        selectedSolId = ApexPages.CurrentPage().getParameters().get('solutionid');
        system.debug('selectedSolId****'+selectedSolId);
        rankFromTs = ApexPages.CurrentPage().getParameters().get('rank');
        system.debug('Comcastfireeye'+rankFromTs );
        if(rankFromTs != null){
            system.debug('inside here***' + rank +'***'+ rankFromTs); 
            rank = string.valueOf(Integer.valueOf(rankFromTs));
           
        } 
        else {
            system.debug('inside here');
            rank = string.valueOf(Integer.valueOf(0));
            system.debug('inside THIS' + rank);
        }
  
        Ins_JobId = ApexPages.CurrentPage().getParameters().get('Id');  
       
            
            rJobOrd =[Select Id,Name,Service_Model__c, ReconEngineFlag__c, EngineFamilyCode__c, ESN__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Mileage__c, Mileage_Measure__c,DSID__C,ESN_Insite__c,INSITE_UpdateTimeStamp__c,INSITE_ESN_Choice__c,Status__c,Previous_Status__c,DSID_WorkGroup__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Warranty_Start_Date__c,CSS_Job_Location_Code__c,ApplicationCode__c,Creator_Location__c from CSS_Job_Order__c where id= :Ins_JobId];
            
    }
  
    public void getSolutionDetails() {
        nestedacessrtboolean=false;
        failDiagResp = false;
        accesserorboolean = false;
        nestFailDiagResp=false;
        string dsidIndic;
        solDet = null;
        solDetails = null;
     //   selectedNestSol = null;
        inddsid = true;
        isSolnExpired = false;
        reportMessage = false;
        successMessage = '';
        system.debug('nestedacessrtboolean--'+nestedacessrtboolean);
        system.debug('failDiagResp--'+failDiagResp);
        System.debug('Start of getSolution');
        String soql = 'select Id,Symptom__r.id,Symptom__r.isPole__c,Out_Of_Order__c,No_Access_SRT_required__c,Diagnosis_Icon__c,Name,Rank__c,Out_Of_Order_Popup_displayed__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Report_Comments__c,Diagnostic_notes__c,CSS_Nested_Solutions__c, CSS_Nested_Solutions__r.rank__c,'; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
        soql += '(select Id,Nested_Rank__c,FaultCode__r.isPole__c,Symptom__r.isPole__c,No_Access_SRT_required__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, CSS_Nested_Solutions__c, Solution__c, FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r order by Nested_Rank__c) '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
        soql += 'from CSS_Solutions__c where Symptom__c = :selectedSymId  order by Rank__c';        
        try{       
            system.debug(rJobOrd + 'rJobOrd');
            system.debug(rJobOrd.DSID__c + 'rJobOrd2**');
            
            if(rJobOrd.DSID__c!=null){
                dsidIndic = css_utility.getDSIDEditIndicator(userinfo.getUserId(),rJobOrd.DSID__c, rJobOrd.DSID_WorkGroup__c);
                // Story - 65995 DS Read Only - start
                if(dsidIndic != null && (dsidIndic.containsIgnoreCase('N') || dsidIndic.containsIgnoreCase('G')))
                    inddsid = false;
                system.debug('inddsid'+inddsid);
                // Story - 65995 DS Read Only - end
                
            }
            if(solDetails == null)
                solDetails = DataBase.query(soql);
            system.debug('soql'+soql);
            system.debug('solDetails'+solDetails);
            //String solutionId = null;
            solutionId = null;
            solutionTitle = null;
            integer lrank;
            nestedSolutionsMap = new Map<String,CSS_Solutions__c>();
            if(!solDetails.isEmpty() && solDetails.size() > 0){
                for(CSS_Solutions__c sol:solDetails){
                    system.debug('sol.rank__c'+sol.rank__c);
                    system.debug('rank'+rank);
                    system.debug('sol.I******d'+sol.Id);
                    system.debug('selectedSolId****'+selectedSolId);
                    if(sol.rank__c != null && Integer.valueOf(rank) == Integer.valueOf(sol.rank__c) && sol.Id==selectedSolId){
                        selectedSol = sol;
                        System.debug('123 selectedSol Symptom__c>>>:'+selectedSol.Symptom__c+' selectedSol Symptom__r>>:'+selectedSol.Symptom__r);
                        //added as a part of parts
                        JobsolutionId = sol.Id;
                        //end
                        solutionId = sol.Name;
                        solutionTitle = sol.Solution_Title__c;
                        lrank = integer.valueof(sol.Rank__c);
                        system.debug('sol.CSS_Solutions__r>>>:'+sol.CSS_Solutions__r);
                        if(sol.CSS_Solutions__r != null && !sol.CSS_Solutions__r.isEmpty()){
                            for(CSS_Solutions__c nestSol : sol.CSS_Solutions__r){
                                nestedSolutionsMap.put(nestSol.Name ,nestSol);
                            }
                        }                      
                        break;
                    }
                    else{
                        if(sol.Id==selectedSolId){
                            solutionId = sol.id;
                            solutionTitle = null;
                            system.debug('kal**'+sol.CSS_Nested_Solutions__r.rank__c);
                            lrank = Integer.valueof(sol.CSS_Nested_Solutions__r.rank__c);
                           
                       }
                    }
                    
                }
                
                string language = 'en';
                System.debug('solutionId'+solutionId);
                System.debug('DSID response is:@@@@@'+rJobOrd.DSID__c);
                System.debug('aLang.CSS_EDSLanguage__c'+aLang.CSS_EDSLanguage__c);
                System.debug('lrank'+lrank);
                System.debug('dsidIndic'+dsidIndic);
                
                
                //Http Callout 
                HttpResponse res = CSS_EDSAuthentication.getSolutionDetails(solutionId,rJobOrd.DSID__c,aLang.CSS_EDSLanguage__c,lrank,dsidIndic);
                system.debug('res.Check'+res);
                system.debug('res.getStatusCode()'+res.getStatusCode());
                if(res.getStatusCode() == 200){
                    solDetFailed = false;
                    solDet = (CSS_J2ASolution_EDS)JSON.deserializeStrict(res.getBody(),CSS_J2ASolution_EDS.class);
                    System.debug('The soldet is#!#!@'+res.getBody());
                    System.debug('The soldet is#!#!@'+solDet);
                    solDet.verification = (solDet.verification).replace('<a','<a style="text-decoration: underline"');
                    //Added for defect 121742
                    //solDet.verification = (solDet.verification).replace('strong>','<br/>+<b>');
                    //solDet.verification = (solDet.verification).replace('<div>','<br/>'); //Adds Line breaks but bolds the bullets too, hence commented.
                    solDet.verification = (solDet.verification).replace('strong>','b>');
                    solDet.resolution = (solDet.resolution).replace('<a','<a style="text-decoration: underline"');
                    solDet.resolution = (solDet.resolution).replace('strong>','b>');
                    solDet.validation = (solDet.validation).replace('<a','<a style="text-decoration: underline"');
                    solDet.validation = (solDet.validation).replace('strong>','b>');
                    
                    solutionId = null;
                    solutionTitle = null;
                }else{
                    system.debug('StatusCode**'+res.getStatusCode());
                    system.debug('REs.body()'+res.getBody());
                    
                    solDet = (CSS_J2ASolution_EDS)JSON.deserializeStrict(res.getBody(),CSS_J2ASolution_EDS.class);
                    System.debug('OTHER soldet is#!#!@'+solDet);
                    if(solDet.key=='Solution is not visible to the current user: Expired'){
                        isSolnExpired=true;
                    }
                    else{
                        solDetFailed = true;
                        solErrorMsg = res.getStatus();
                    }
                }
            }
            System.debug('End of getSolution');
        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());
        }
       
    }
}