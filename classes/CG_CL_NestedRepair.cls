public class CG_CL_NestedRepair {

   public CSS_SRTComponentLookupResponseJ2A failureCodeDetails{get; set;}
   public boolean ErrorMessage {get; set;}
   public string solId;
   public list<css_solutions__c> solsList {get;set;}
   public string solNum{get;set;}
   public string Nsolid{get;set;}
   public CSS_Solutions__c NSoln{get;set;}
    public Integer remCharcounter{set;get;}
    public List<srtCompWrapper> listsrtCompWrapper {get;set;} 
    public List<srtPartWrapper> listsrtPartWrapper {get;set;} 
    //103764 end
    public Boolean isClaimEnabledDealer{get;set;} //GSSC-453
    public CG_CL_NestedRepair(css_repair_job controller) {
        //defetct 103764
        NSoln = new CSS_Solutions__c();
        selectedFaulcodeId = ApexPages.CurrentPage().getParameters().get('fcid');
        source = ApexPages.CurrentPage().getParameters().get('source');
        solId = ApexPages.CurrentPage().getParameters().get('solid');
        nSolId = ApexPages.CurrentPage().getParameters().get('Nsolid');
        
        u3 = css_utility.getUserAttributes(userinfo.getUserId());
        aLang = css_utility.getLanguage(u3.LanguageLocaleKey);

        Ins_JobId = ApexPages.CurrentPage().getParameters().get('Id'); 
        System.debug('Ins_JobId>>>'+Ins_JobId);
        
        try{
            //Added DiagTargetTime__c, TargetMessage__c fields in below query as part of the story #GSSC-156
            solsList = [select id, DiagTargetTime__c, TargetMessage__c, Name,Solution_Title__c,Repair_Response__c,Nested_Rank__c,CSS_Nested_Solutions__r.Rank__c,CSS_Nested_Solutions__r.Name from CSS_Solutions__c where CSS_Nested_Solutions__c =: solId];
            Nsoln = [select id,Name,Report_Comments__c,Solution_Title__c,Repair_Response__c ,Repair_notes__c,Diagnostic_Response__c,Diagnostic_notes__c,Nested_Rank__c,CSS_Nested_Solutions__r.Rank__c from CSS_Solutions__c where id =: Nsolid];
            rJobOrd =[Select Id,Name, Service_Model__c, ReconEngineFlag__c, ESN__c,ESN_Insite__c,DSID__c,DSID_WorkGroup__c,INSITE_UpdateTimeStamp__c,Status__c,Previous_Status__c,INSITE_ESN_Choice__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Mileage__c, Mileage_Measure__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Warranty_Start_Date__c,CSS_Job_Location_Code__c,ApplicationCode__c,Creator_Location__c from CSS_Job_Order__c where id= :Ins_JobId];
            system.debug('rJobOrd'+rJobOrd);
            solNum = Nsoln.Name;
            if(rJobOrd.DSID__C != null){
                dsidind =  css_utility.getDSIDEditIndicator(userinfo.getUserId(),rJobOrd.DSID__C,rJobOrd.DSID_WorkGroup__c); 

                if( dsidind != null && (dsidind.containsIgnoreCase('N') || dsidind.containsIgnoreCase('G')))
                    inddsid = false;

            }

          
        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());            
        }
        if(selectedFaulcodeId != null){
            faultCodeClick();
        }
        //GSSC-453 - START
        Boolean isClaimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
        String isDealer = css_utility.getOrgType(UserInfo.getUserId());
        if(isClaimEnabled == true && isDealer == 'DLR'){
            isClaimEnabledDealer = true;
        }
        else{
            isClaimEnabledDealer = false;
        }
        //GSSC-453 - END
        
    }   

    //QSOL Start


    public Id Ins_JobId{set;get;} 
    // Story - 65995 DS Read Only - start
    public string dsidind{get; set;} 
    public boolean inddsid{get; set;}
    // Story - 65995 DS Read Only - end
    public css_job_order__c rJobOrd {get;set;}
    public String selectedFaulcode{set;get;}
    public String selectedFaulcodeId{set;get;}
    public String sKNumber {set;get;}
    public Boolean isfaultCodeView {set;get;}
    public String selectedReltdFaulcode{set;get;}
    public List<CSS_JobEventTemporary__c> qsolRetrivedFCMasters {set;get;}
    public CSS_JobEventTemporary__c qsolRetrivedFCMaster {set;get;}    
    public List<CSS_Fault_Code__c> recFaultCode {set;get;}
    public List<CSS_SymptomQA__c> recSymCode {set;get;}
    Public string workGroup;
    String DSID;
    public User u3{get;set;}
    public CSS_accountLanguage__c aLang{get;set;}
    public string source;
    
    public PageReference faultCodeClick(){     
        system.debug('******before soql: '+selectedFaulcodeId);
        system.debug('selectedReltdFaulcode: '+selectedReltdFaulcode);
        String fcsoql;
        if(source=='Insite'){
        fcsoql = 'select Id,Name,Related_Fault_Code__c from CSS_Fault_Code__c where id = :selectedFaulcodeId LIMIT 1';
        recFaultCode = DataBase.query(fcsoql);
            
        }else{
            fcsoql = 'select Id,Name from CSS_SymptomQA__c where id = :selectedFaulcodeId LIMIT 1';
            recSymCode = DataBase.query(fcsoql);
        }
        
        if((recFaultCode != null && recFaultCode.size()>0) || (recSymCode != null && recSymCode.size()>0)){
            
            if(source == 'Insite'){
                selectedFaulcode = recFaultCode[0].Name;
            selectedReltdFaulcode = recFaultCode[0].Related_Fault_Code__c;
            }else{
                selectedFaulcode = recSymCode[0].Name;
                selectedReltdFaulcode = '';
            }
            String soql = 'select Circuit_Description__c, Comp_Location__c, Effect__c, Engine__c, Fault_Code_Description__c, File_Name__c, FMI__c, Lamp__c, Reason__c, Service_Model_Name__c, SPN__c from CSS_JobEventTemporary__c where Name = \'' + selectedFaulcode + '\' LIMIT 1';
            system.debug('*****soql: '+soql);
            qsolRetrivedFCMasters = DataBase.query(soql);

            failDiagResp = false;
            failDiagResp1 = false;
            //making a callout to pull if not found in JobEventTemporary
            if(qsolRetrivedFCMasters.isEmpty() && qsolRetrivedFCMasters.size() == 0){
                System.debug('hello 123'+selectedFaulcode+'rjobord'+rJobOrd+'selectedFaultCode'+selectedFaulcode);
                CSS_QuickServe.workJob = rJobOrd;
                qsolRetrivedFCMaster = CSS_QuickServe.getFaultCodeOverview(selectedFaulcode,rJobOrd.ESN__c); 
               
                getSolutionDetails();
                //insert qsolRetrivedFCMaster;
            }else{
                qsolRetrivedFCMaster = qsolRetrivedFCMasters[0];
                getSolutionDetails();
            }             
        }
        isfaultCodeView = false;
        return null;
    }


    public CSS_Solutions__c selectedSol{get;set;}
    public List<CSS_Solutions__c> solDetails{get;set;}
    public CSS_J2ASolution_EDS solDet{get;set;}
    public CSS_J2ANestSol_EDS solDet1{get;set;}
    public Boolean solDetFailed{set;get;}
    public String solErrorMsg{set;get;}
    public List<CSS_Solution_Component__c> solComp{get;set;}

    //Code for Nested Solutions - Start
    //Variable for Nested Solutions
    public CSS_Solution_Component__c nestSolComp{set;get;}
    public NestedSolutionsClass selectedNestSol{get;set;}
    public String selectedNestSolTitle1{set;get;}
    public String selectedNestSolId{set;get;} 
    public String queryFrom{set;get;}  
    public string nestSolNumber{get;set;}
    public map<string,CSS_Solutions__c> kIdSolutionMap;
    public map<string,NestedSolutionsClass> nestedSolutionsMap = new map<string,NestedSolutionsClass>();
    public NestedSolutionsClass nestedSolution{get;set;}

    public Class NestedSolutionsClass{
        public string solID{get;set;}
        public string solNum{get;set;}
        public string solTitle{get;set;}
        public String Resolution{get;set;}
        public String RepairNotes {get;set;}
        public CSS_Solutions__c solRec{set;get;}
        public List<CSS_Solution_Component__c> solCompList{get;set;}

        //constructor
        public NestedSolutionsClass(){
            solRec = new CSS_Solutions__c();
            solCompList = new List<CSS_Solution_Component__c>();
        }
    }


    public String solutionId {get;set;}
    public String solutionTitle {get;set;}
    public Boolean isSolnExpired {get;set;}
    Public String onChangeId{get;set;}
     public void onClickOfNSolns(){
        system.debug('Entered onclickNSols Method onChangeId value'+onChangeId);
        nestFailDiagResp = false;
        Nsoln = [select id,Name,Report_Comments__c,Solution_Title__c,Repair_Response__c ,Repair_notes__c,Diagnostic_Response__c,Diagnostic_notes__c,Nested_Rank__c,CSS_Nested_Solutions__r.Rank__c from CSS_Solutions__c where id =: onChangeId];
        system.debug('Nsoln.Repair_Response__c'+Nsoln.Repair_Response__c);
        solNum = Nsoln.Name;
        getSolutionDetails();
    }
    
    public void getSolutionDetails() {
        //defect 103764
        set<id> setNestSolId = new set<id>();
        string dsidIndi;
        //FeedBackVal = '';
        //FeedBackValNest ='';
        selectedNestSol = null;
        nestedSolution = new NestedSolutionsClass();
        nestedSolutionsMap = null;
        inddsid = true;
        isSolnExpired = false;
        reportMessage = false;
        successMessage = '';
        solComp = new List<CSS_Solution_Component__c>();


        solDet = null;
        solDetails = null;
        solutionId = null;
        solutionTitle = null;
        if(Nsoln.Repair_notes__c != '' && Nsoln.Repair_notes__c !=null){
                    remCharcounter =4000 - (Nsoln.Repair_notes__c).length() ;
            }
        else{
            remCharcounter =4000 ; 
            }
        try{ 
            if(rJobOrd.DSID__c!=null){
                dsidIndi = css_utility.getDSIDEditIndicator(userinfo.getUserId(),rJobOrd.DSID__c, rJobOrd.DSID_WorkGroup__c);
                // Story - 65995 DS Read Only - start
                if( dsidIndi != null && (dsidIndi.containsIgnoreCase('N') || dsidIndi.containsIgnoreCase('G')))
                    inddsid = false;
             }
            //string solutionId = null;
            solutionId = solsList[0].CSS_Nested_Solutions__r.Name;
            solutionTitle = null;
            integer lrank ;
            lrank = Integer.valueof(solsList[0].CSS_Nested_Solutions__r.Rank__c);
                string language = 'en';
                HttpResponse res = CSS_EDSAuthentication.getSolutionDetails(solutionId, rJobOrd.DSID__C,aLang.CSS_EDSLanguage__c,lrank,dsidIndi);
                system.debug('tetsing respo'+res);
                //HttpResponse res = CSS_EDSAuthentication.getSolutionDetails(solutionId, rJobOrd.DSID__C);
                if(res.getStatusCode() == 200){
                    solDetFailed = false;
                    solDet = (CSS_J2ASolution_EDS)JSON.deserializeStrict(res.getBody(),CSS_J2ASolution_EDS.class);
                    System.debug('The soldet is>>>>>>>>>>>>>>#!#!@'+solDet);
                    solDet.resolution = (solDet.resolution).replace('<a','<a style="text-decoration: underline"');
                    //Added for defect 121742
                    solDet.verification = (solDet.verification).replace('strong>','b>');
                    //End of Defect 121742
                    //addSolComponents(selectedSol,solDet);
                    solutionId = null;
                    solutionTitle = null;
                    for(CSS_J2ASolution_EDS.verCompoundSolutions verCom: solDet.verCompoundSolutions){
                        system.debug('Anirudh>>>solNum'+solNum+'verCom.solutionNumber>>>'+verCom.solutionNumber);
                        if(solNum == verCom.solutionNumber){
                            nestedSolution.solID = Nsolid;
                            nestedSolution.solNum = verCom.solutionNumber;
                            nestedSolution.solTitle = verCom.solutionTitle;
                            nestedSolution.Resolution = verCom.resolution;
                            
                            break;
                        }
                    }
                    
                }else{
                    solDet = (CSS_J2ASolution_EDS)JSON.deserializeStrict(res.getBody(),CSS_J2ASolution_EDS.class);
                    if(solDet.key=='Solution is not visible to the current user: Expired'){
                        isSolnExpired=true;
                    }
                    else{
                        solDetFailed = true;
                        solErrorMsg = res.getStatus();
                    }
                }
            //}
        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());
        }
    }
    public class solWrapper{
        public string solNum{get;set;}
        public string status{get;set;}
        public string comment{get;set;}
        public string dsid{get;set;}  
        public solWrapper(string status,string solNum,string comment,string dsid){
            this.solNum = solNum;
            this.status = status;
            this.comment = comment;
            this.dsid=dsid;
        }
    }
    public list<CSS_Solution_Component__c> lstComp{get;set;}
        public void getPartsList(){
        try{
            listsrtCompWrapper= new List<srtCompWrapper>();

            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            System.debug('testing debug');
            System.debug('inside the method parts METHOD...Selected Sol Id>>>'+NSoln.Id);
            //  if(Wid != null){
            //code for parts webservice invokation - Start.
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            Id recTypeIdpart;
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            // solComp = [Select Id,Component_Id__c,Service_Job__c,Solutions__c from CSS_Solution_Component__c where Service_Job__c = : Ins_JobId and Solutions__c = : selectedSol.Id];
            solComp = [Select id,(Select id,Option_Number__c,Replacement_Reason__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r), Name,Component_Id__c,Service_Job__c,Selected_Component__c,Solutions__c,Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : NSoln.Id];
            Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : NSoln.Id and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            if(Parts.size()==0 || Parts.isempty()){
                CSS_FN_SRT.srtPartsService(solComp,rJobOrd,recTypeIdpart);
                Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : Nsoln.Id and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            }
            //code for parts webservice invokation - End. 
            System.debug('recTypeIdpart-->'+recTypeIdpart);
            //if(servicejob.CSS_Parts_Options__r != null){
            Set<CSS_Solution_Component__c> setcomp = new  Set<CSS_Solution_Component__c>();
            lstComp = new list<CSS_Solution_Component__c>();

            //for(CSS_Parts_Options__c z: servicejob.CSS_Parts_Options__r){comp
            system.debug('Parts>>>'+Parts);
            if(solComp.size()>0){
                for(CSS_Solution_Component__c z: solComp){
                    //setcomp.add(z);
                    Set<srtPartWrapper> setsrtPartWrapper  = new Set<srtPartWrapper>(); 
                    listsrtPartWrapper= new List<srtPartWrapper>();
                    list<String> lstChildIds = new list<String>();
                    system.debug('solComp>>>'+solComp);
                    if(Parts != null){
                        system.debug('Parts >>>'+Parts );
                        system.debug('z.CSS_Parts_Options__r >>>'+z.CSS_Parts_Options__r );
                        for(CSS_Parts_Options__c p: Parts){
                            system.debug('p.FailurepartId__c>>>>>>>'+p.FailurepartId__c+ ' ' + 'z.Id>>>>>>' +z.Id);
                            system.debug('p.Part_Assignment__c.trim()>>>>>>>'+p.Part_Assignment__c.trim()+ ' ' + 'p.Part_Assignment__c' +p.Part_Assignment__c);
                            if(p.FailurepartId__c == z.Id && p.Part_Assignment__c.trim() == 'Primary'){
                                system.debug('p.FailurepartId__c>>>>>>>'+p.FailurepartId__c+ ' ' + 'z.Id>>>>>>' +z.Id);
                                if(p.Replacement_Reason__c=='' || p.Replacement_Reason__c=='Select One' || p.Replacement_Reason__c==null)
                                    p.Replacement_Reason__c='GSQ Part';
                                    system.debug('p.Replacement_Reason__c<<<'+p.Replacement_Reason__c);
                                setsrtPartWrapper.add(new srtPartWrapper(p.id,p.FailurepartId__c,p.selected_part__c,p.Part_Name__c,integer.valueof(p.Quantity__c),integer.valueof(p.Quantity__c),p.Replacement_Reason__c)); 
                                lstChildIds.add(p.id);
                                system.debug('setsrtPartWrapper Anirudh>>>'+setsrtPartWrapper);
                                system.debug('setsrtPartWrapper Anirudh>>>'+setsrtPartWrapper.size());
                            }
                        }
                        if(setsrtPartWrapper.size()>0 && !setsrtPartWrapper.isempty()){
                            listsrtPartWrapper.addAll(setsrtPartWrapper);
                            system.debug('listsrtPartWrapper>>>>>>>'+listsrtPartWrapper);
                            listsrtCompWrapper.add(new srtCompWrapper(z.id,z.Selected_Component__c,z.Name,lstChildIds,listsrtPartWrapper,z.solutions__r.FaultCode__c,z.System_Code__c,z.Component_Code__c,z.AccountCode__c)); 

                            system.debug('listsrtCompWrapper>>>>>>'+listsrtCompWrapper);
                        }
                    }
                    if(setsrtPartWrapper.size()==0){
                        listsrtCompWrapper.add(new srtCompWrapper(z.id,z.Selected_Component__c,z.Name,null,null,z.solutions__r.FaultCode__c,z.System_Code__c,z.Component_Code__c,z.AccountCode__c)); 
                    }
                }
            }
        } catch(exception e){
            system.debug('Entered in exception block of getPartslist method>>>>'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }

     public pagereference qsolredirect(){
        PageReference pageRef;
        string redirect = '';
        if(!Test.isRunningTest())
            redirect = qsolRetrivedFCMaster.File_Name__c;        
        else
            redirect = 'CSS_JobTnDRj';
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public String FeedBackVal{set{FeedBackVal=value;} get;}
    public void updateFeedBackForSol(){
        try{
            system.debug('@@@@@FeedBackVal'+FeedBackVal); 
            if(FeedBackVal != null  ){  
                if(NSoln != null){
                    NSoln.Repair_Response__c = FeedBackVal;
                    system.debug('NSoln.Repair_Response__c'+NSoln.Repair_Response__c);
                }
            }
        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());
        }

    }
    public string successMessage{get;set;}
    public Boolean reportMessage{get;set;}
    public void reportProblemComments(){
        CSS_EDSAuthentication.reportProblem(rJobOrd.DSID__c, Nsoln.name, Nsoln.Report_Comments__c);
        //Method Call to create a Case
        Id caseId = css_utility.createCase(Nsoln.Report_Comments__c, rJobOrd.Name, rJobOrd.Service_Model__c, Nsoln.Solution_Title__c, Nsoln.name);
        system.debug('**caseId**>>>>>>:'+caseId+' ErrorMessage>:'+ErrorMessage);
        if(caseId!=null ){
            reportMessage=true;
            successMessage='Thank you! Your problem has been reported. Check the Reported Solution Problems page for updates.';

        }else{
            reportMessage=true;
            successMessage='There was an issue to reporting your problem.';

        }
    }



    //Method to save nested Solution and related Components - Start
    //Prabhakar Added below varaible
    public String selectedDiagRespNested{get;set;}

    //Method to save nested Solution and related Components - End  

    List<string> solRepAdd;
  

 

    public Boolean failDiagResp{get;set;}
    public Boolean failDiagResp1{get;set;}

 



    public Boolean validateResponse(){
        Boolean valFailed = false;
        if(NSoln != null && 
           ('Repair Successful.'.equalsIgnoreCase(NSoln.Repair_Response__c) || 'Repair Successful with additional parts/procedures.'.equalsIgnoreCase(NSoln.Repair_Response__c) || 'Repair performed but didnot resolve the root cause.'.equalsIgnoreCase(NSoln.Repair_Response__c))
           && (NSoln.Repair_notes__c == null || NSoln.Repair_notes__c == '')){ 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
            ApexPages.addMessage(myMsg);               
            valFailed = true;
            return valFailed;
        }else if (NSoln != null && NSoln.Repair_notes__c != null && NSoln.Repair_notes__c != '' && (NSoln.Repair_Response__c == null || NSoln.Repair_Response__c == ''))

        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
            ApexPages.addMessage(myMsg);               
            valFailed = true;
            return valFailed;
        }
        return valFailed;
    }



    //method for Accessbility CheckList For Solutions :
    public PageReference srtAccesscheckList(){
        PageReference pr = new PageReference('/CSS_srtAccessChecklistPae?SolId='+selectedSol.Id);
        return pr;
    }

    public list<string> selectOptionsList{get;set;}
    public string selectedValue{get;set;}
    public string selectedValue1{get;set;}
    public string textEntered{get;set;}
    public list<CSS_Solution_Component__c> Components{get;set;}

    //action Method
    public PageReference actionMethodOf(){
        system.debug('***selectedValue-->'+selectedValue); 
        textEntered = '';       
        return null;
    }






    public List<CSS_Solutions__c> lstSolutions;
    //public boolean ErrorMessage {get; set;}     
    public list<CSS_Parts_Options__c> partdispjbp{get;set;} 
    public CSS_Job_Order__c serviceJob{get; set;}
    public String selSolution {get; set;}
    public void refreshPartsList(){
        listsrtCompWrapper= new List<srtCompWrapper>();
    }

    public void partssave(List<srtCompWrapper> lstToUpdate){
        try{
            List<CSS_Solution_Component__c> complst = new List<CSS_Solution_Component__c>();
            List<CSS_Parts_Options__c> partslst = new List<CSS_Parts_Options__c>();            

            if(lstToUpdate != null && lstToUpdate.size()>0){
                if((selSolution!='' && (selSolution == 'Repair Successful.' || selSolution == 'Repair Successful with additional parts/procedures.' || selSolution == 'Repair performed but didnot resolve the root cause.') ) || (selectedNestSolTitle1!='' && (selectedNestSolTitle1 == 'Repair Successful.' || selectedNestSolTitle1 == 'Repair Successful with additional parts/procedures.' || selectedNestSolTitle1 == 'Repair performed but didnot resolve the root cause.' ))){
                    for(srtCompWrapper s: lstToUpdate){
                        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c(Id = s.CompIds,Selected_Component__c = s.compParentCheckbox);
                        complst.add(solComp);                        
                        if(s.partWrapper != null){
                            for(srtPartWrapper y: s.partWrapper){
                               // CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,selected_part__c = y.partChildCheckbox,Replacement_Reason__c=(y.partChildCheckbox == true ? y.replacementReason : ''),Quantity__c=y.qty);
                                CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,selected_part__c = y.partChildCheckbox,Replacement_Reason__c= y.replacementReason,Quantity__c=y.qty);
                                partslst.add(partComp);
                                /*if(y.partChildCheckbox == false){ 
                                    y.replacementReason = '';
                                }*/
                            }
                        }
                    }
                }
                else{
                    for(srtCompWrapper s: lstToUpdate){
                        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c(Id = s.CompIds,Selected_Component__c = false);
                        complst.add(solComp);
                        if(s.partWrapper != null){
                            for(srtPartWrapper y: s.partWrapper){
                                CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,selected_part__c = false,Replacement_Reason__c= 'Select One',Quantity__c=y.defaultQty);
                                partslst.add(partComp);
                            }
                        }
                    }
                }
            }

            Integer num=0;
            List<srtCompWrapper> fireLst = new List<srtCompWrapper>();
            for(srtCompWrapper wrap : lstToUpdate){
                num++;
                if(num==10){
                    String temp = JSON.serialize(fireLst);
                    //calling Get Warranty determination web service
                    // added Mileage__c, Mileage_Measure__c, - Satish defect# 119170
                    getAccountCodes(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,temp, rJobOrd.ReconEngineFlag__c,rJobOrd.Name);
                    fireLst = new List<srtCompWrapper>();
                    num=0;
                }
                fireLst.add(wrap);
            }

            if(num<10){
                String temp = JSON.serialize(fireLst);
                //calling Get Warranty determination web service
                // added Mileage__c, Mileage_Measure__c, - Satish defect# 119170
                getAccountCodes(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,temp, rJobOrd.ReconEngineFlag__c,rJobOrd.Name);
                fireLst = new List<srtCompWrapper>();
                num=0;
            }

            if(complst.size()>0){
                update complst;
                if(partslst.size()>0)
                    update partslst;
            }
            System.debug('complst--> :'+complst);
            System.debug('partslst-->'+partslst);
        }catch(exception e){
            system.debug('Parts Save - CSS_RepairQsolEDS_V1 --> '+ e.getLineNumber() + ' ' +e.getMessage()); 
        }
    }
    public Boolean nestFailDiagResp{get;set;}
    public void UpdateSolNotes(){ 
        Id solId = NSoln.id;
        NSoln.Repair_Response__c = (selSolution != null && selSolution != '' ? selSolution : FeedBackVal);
        //NSoln.Repair_Response__c = selSolution;
        solRepAdd = new List<string>();
        system.debug('selSolution'+selSolution);
        system.debug('selSolution'+FeedBackVal);
        system.debug('NSoln.Repair_Response__c'+NSoln.Repair_Response__c);
        system.debug('NSoln.Repair_Notes__c>>'+NSoln.Repair_Notes__c);
        if(( 
            ('Repair Successful.'.equalsIgnoreCase(NSoln.Repair_Response__c) || 'Repair Successful with additional parts/procedures.'.equalsIgnoreCase(NSoln.Repair_Response__c) || 'Repair performed but did not resolve the root cause.'.equalsIgnoreCase(NSoln.Repair_Response__c))
            && (NSoln.Repair_Notes__c == null || NSoln.Repair_Notes__c == '')) || 
           (NSoln.Repair_Notes__c != null && NSoln.Repair_Notes__c != '' && (NSoln.Repair_Response__c == null || NSoln.Repair_Response__c == ''))){
            nestFailDiagResp=true;
            System.debug('**inside****'+nestFailDiagResp);

        }
        else
            nestFailDiagResp=false;
        if(nestFailDiagResp==false){
            //Added for EDS - Update Trigger 
            system.debug('FeedBackVal'+FeedBackVal);
            
            CSS_Solutions__c s1 = [select Repair_Response__c,Repair_Notes__c from CSS_Solutions__c where id=:NSoln.id ];
            string oldRepResp = s1.Repair_Response__c;
            string oldRepNotes = s1.Repair_Notes__c;
            if(oldRepResp!=NSoln.Repair_Response__c||oldRepNotes!= NSoln.Repair_Response__c){
                solRepAdd.add(JSON.Serialize(new solWrapper(NSoln.Repair_Response__c,NSoln.Name,NSoln.Repair_Notes__c,rJobOrd.DSID__c)));
                CSS_EDSActionsUpdate.caseRepStatusUpdate(solRepAdd);
            }

            system.debug('rJobOrd.Previous_Status__c**'+NSoln.Repair_Response__c);


           // failDiagResp = validateResponse();
           // system.debug('failDiagResp**'+failDiagResp);

           // if(failDiagResp)
                // return null;


                System.debug('selectedNestSol: '+NSoln);
            try{
                if(NSoln != null){
                    if(solComp != null && !solComp.isEmpty()){
                        //Calling SRT parts and saving
                        partssave(listsrtCompWrapper);
                        upsert NSoln;
                    }                              
                    upsert NSoln;
                } 

                if(rJobOrd.Previous_Status__c != null && rJobOrd.Previous_Status__c.equalsIgnoreCase('Triage & Diagnosis') ){
                    if(rJobOrd.Status__c != null && rJobOrd.Status__c.equalsIgnoreCase('Triage & Diagnosis/Repair')){            
                        rJobOrd.Previous_Status__c = 'Triage & Diagnosis/Repair';
                        rJobOrd.Status__c = 'Repair';

                        update rJobOrd;            
                    }            
                }
            }catch(Exception ex){
                System.debug('Error Line:'+ex.getLineNumber());
                System.debug('Error Message:'+ex.getMessage());
            } 

            //return null; 
        }
       System.debug('**inside2****'+nestFailDiagResp);
    }

    @future(callout=true)
    public static void getAccountCodes(string PSN, string spCode, date failureDate, string failurePoint, string failureMeasure, string engAppCode, date warrStartDt, string temp, string reconFlag,String Name){
        List<srtCompWrapper> srtCompWrapper_lst = new List<srtCompWrapper>();
        srtCompWrapper_lst = (List<srtCompWrapper>)JSON.deserializeStrict(temp,List<srtCompWrapper>.class);
        List<CSS_Solution_Component__c> compListUpd = new List<CSS_Solution_Component__c>();
        for(srtCompWrapper compWrap:srtCompWrapper_lst){
            CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
            if((compWrap.accountCode == null || compWrap.accountCode =='') &&(compWrap.compParentCheckbox==true)){
                comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(PSN,spCode,failureDate,failurePoint,failureMeasure,engAppCode,warrStartDt,compWrap.systemCode,compWrap.compCode,compWrap.faultCode,compWrap.accountCode,compWrap.CompIds,compWrap.compParentCheckbox,'','','First Call', reconFlag, false, Name); //Kalpana Story#117207 added 'First Call' Param
                if(comp!=null)
                    compListUpd.add(comp);  
            }
        }
        if(compListUpd.size()>0)
            update compListUpd;
    }

    public List<SelectOption> getreplacementReasonOptions()     
    { 
        try{
            System.debug('GSQ Parts7');
            List<SelectOption> options =  new List<SelectOption>();    
            Schema.DescribeFieldResult fieldResult = CSS_Parts_Options__c.Replacement_Reason__c.getDescribe();    
            List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();    
            for(Schema.picklistEntry f:ple)    
            {    
                options.add(new selectOption(f.getLabel(),f.getValue()));                    
            }    
            return Options;    
        }catch(exception e){
            return null;
        }
    } 

    public class srtCompWrapper{
        public Id CompIds {get;set;}
        public boolean compParentCheckbox {get;set;}
        public string compName {get;set;}
        public list<String> childIds {get;set;}
        public list<srtPartWrapper> partWrapper {get;set;}
        public String faultCode {get;set;}
        public String systemCode {get;set;}
        public String compCode {get;set;}
        public String accountCode {get;set;}

        public srtCompWrapper(Id CompIds,boolean compParentCheckbox,string compName,list<String> childIds,list<srtPartWrapper> partWrapper,string faultCode,string systemCode,string compCode,string accountCode){
            this.CompIds= CompIds;
            this.compName = compName;
            this.compParentCheckbox = compParentCheckbox;
            this.childIds = childIds;
            this.partWrapper = partWrapper;
            this.faultCode = faultCode;
            this.systemCode = systemCode;
            this.compCode = compCode;
            this.accountCode = accountCode;

        }
    }
    public class srtPartWrapper{
        public Id partIds {get;set;}
        public Id compParentId {get;set;}
        public boolean partChildCheckbox {get;set;}
        public string partName {get;set;}
        public integer qty {get;set;}
        public integer defaultQty;
        public String replacementReason {get;set;}
        public srtPartWrapper(Id partIds,Id compParentId,boolean partChildCheckbox,string partName,Integer qty,Integer defaultQty,String replacementReason){
            this.partIds=partIds;
            this.compParentId = compParentId;
            this.partChildCheckbox = partChildCheckbox;
            this.partName = partName;
            this.qty = qty;
            this.defaultQty = defaultQty;
            this.replacementReason = replacementReason;
        }
    }


    // Method to get Parts list (Story# 103855 End)
    public Id JobsolutionId {get;set;}

    
    public PageReference returnToRepairView(){
        PageReference pageRef;
        string redirect='/apex/CSS_JobRepair?pgFlag=RM&id='+Ins_JobId;
        // string redirect='/apex/CSS_Job?&id='+Ins_JobId;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference returnToParentSolution(){
        PageReference pageRef;
        UpdateSolNotes();
        if(nestFailDiagResp)
        return null;
        string redirect;
        if(source == 'Insite'){
            redirect='/apex/CSS_JobTnDEds?id='+Ins_JobId+'&fcid='+selectedFaulcodeId+'&rank='+NSoln.CSS_Nested_Solutions__r.Rank__c;
         }else{
            redirect='/apex/CSS_SymEDSSolutionsPage?id='+Ins_JobId+'&symId='+selectedFaulcodeId+'&rank='+NSoln.CSS_Nested_Solutions__r.Rank__c;
      }
        // string redirect='/apex/CSS_Job?&id='+Ins_JobId;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }
}