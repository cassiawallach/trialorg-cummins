public class CSS_SymEDSSolutions {
    
    public string JSONSolsGlob {get; set;}
    public list<CSS_Solution_Component__c> lstComp{get;set;}
    public list<CSS_Parts_Options__c> partdispjbp{get;set;}
    public CSS_Job_Order__c serviceJob{get; set;}
    public Id recTypeIdpart {get; set;}
    public String selSolution {get; set;}
    public list<CSS_Solution_Component__c> comp{get; set;}
    public List<CSS_Solutions__c> lstSolutions;
    public boolean accesserorboolean{get;set;}
    public boolean nestedacessrtboolean{get;set;}
    public string solidCorrectStylClass{get;set;}
    public string correctplusStylClass{get;set;}
    public string solidWrongStylClass{get;set;}
    public string solidQtnStylClass{get;set;}
    public list<CSS_srt__c> lstSRT;//saikomalfinding nemo 171488
    
    //added for part table
    public List<srtCompWrapper> listsrtCompWrapper {get;set;} 
    public List<srtPartWrapper> listsrtPartWrapper {get;set;} 
    public Integer remCharcounter{set;get;}
    public Integer remCharcounterNest{set;get;}
    //end
    
    public List<srtCompWrapper> nestedListsrtCompWrapper {get;set;}
    
    public CSS_SRTComponentLookupResponseJ2A failureCodeDetails{get; set;}
    
    public List<CSS_Solution_Component__c> solCompNew = new List<CSS_Solution_Component__c>(); //GSSC-156
    public List<CSS_Solutions__c> solListNew = new List<CSS_Solutions__c>(); //GSSC-156
    
    public Boolean isClaimEnabledDealer{get;set;} //GSSC-453
    
    public CSS_SymEDSSolutions(){
    }
    
    public CSS_SymEDSSolutions(css_tnd_job controller) {
        
        solidCorrectStylClass ='<i class="cmi-icon icon-correct"></i>';
        //correctplusStylClass = '<i class="cmi-icon icon-correctplus"></i>';
        solidWrongStylClass = '<i class="cmi-icon icon-wrong"></i>';
        solidQtnStylClass ='<i class="cmi-icon icon-qtn"></i>';
        
        selSolution=''; 
        u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
        aLang = css_utility.getLanguage(u3.LanguageLocaleKey);
        isfaultCodeView = true;
        solDetFailed = false;
        displayOutofOrder = false;
        displayOutofOrd = false;
        selectedFaulcodeId = ApexPages.CurrentPage().getParameters().get('fcid');
        selectedSymId = ApexPages.CurrentPage().getParameters().get('symid');
        system.debug('selectedSymId****'+selectedSymId);
        //added for defect 109207
        rankFromTs = ApexPages.CurrentPage().getParameters().get('rank');
        system.debug('Comcastfireeye'+rankFromTs );
        if(rankFromTs != null){
            rank = string.valueOf(Integer.valueOf(rankFromTs));
        } 
        else {
            rank = string.valueOf(Integer.valueOf(0));
        }
        nestedIndentation = Integer.valueOf(rank) + 1;
        //end
        Ins_JobId = ApexPages.CurrentPage().getParameters().get('Id');  
        try{
            
            // added Mileage__c, Mileage_Measure__c, - Satish defect# 119170
            //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156 in below query
            rJobOrd =[Select Id,Name,Service_Model__c, ReconEngineFlag__c, EngineFamilyCode__c, ESN__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Mileage__c, Mileage_Measure__c,DSID__C,ESN_Insite__c,INSITE_UpdateTimeStamp__c,INSITE_ESN_Choice__c,Status__c,Previous_Status__c,DSID_WorkGroup__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Warranty_Start_Date__c,CSS_Job_Location_Code__c,ApplicationCode__c,Creator_Location__c from CSS_Job_Order__c where id= :Ins_JobId];
            lstSolutions = new List<CSS_Solutions__c>([Select Id, name,Case_Name__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Service_Job__c, Rank__c,Report_Comments__C,
                                                       Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,No_Access_SRT_required__c,
                                                       (select Id,Nested_Rank__c,FaultCode__r.isPole__c,Symptom__r.isPole__c,No_Access_SRT_required__c,Diagnosis_Icon__c,
                                                       Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,
                                                       FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r order by Nested_Rank__c)
                                                       from CSS_Solutions__c where Symptom__c = :selectedSymId 
                                                       order by Rank__c]);
            
            
            // Story - 65995 DS Read Only - start
            if(rJobOrd.DSID__C != null){
                dsidind =  css_utility.getDSIDEditIndicator(userinfo.getUserId(),rJobOrd.DSID__C,rJobOrd.DSID_WorkGroup__c); 
                
                if( dsidind != null && (dsidind.containsIgnoreCase('N') || dsidind.containsIgnoreCase('G')))
                    inddsid = false;
                
            }
            // Story - 65995 DS Read Only - end
            JSONSolsGlob =  getSols();
            //css_tnd_job updqsol = new css_tnd_job();
            //updqsol.getQSOLDocs();
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
            
        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());            
        }
        if(selectedSymId != null){
            //faultCodeClick();
        } 
        failureCodeDetails = getSRTComponentOnLoad();
       
        
    }
    //QSOL Docs
    public user userlang{get; set;}
    public CSS_accountLanguage__c accountlang{get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}
    public void getQSOLDocs_Existing() {
        //Get Campaign Information from QSOL based on ESN
        CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc rQSOLDocs = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
        string sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;                    
        List<CSS_quickserveCumminsComWebservices.WarrantyDoc> wCAMTSBTRB = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>();
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();                                    
        lstCAM = new List<CSS_CampTsbTrp__c>();
        system.debug('checking user lang'+accountlang.CSS_QsolLanguage__c);
        rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,rJobOrd.ESN__c,'CAM',accountlang.CSS_QsolLanguage__c);
        system.debug('inside user lang'+accountlang.CSS_QsolLanguage__c);
        if(rQSOLDocs !=null){                                
            wCAMTSBTRB = rQSOLDocs.item;
            if(wCAMTSBTRB!=null){
                for(integer i=0;i<wCAMTSBTRB.size();i++){
                    CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                    ctt1.Name = 'CAM' ;
                    ctt1.Type__c = 'CAM' ;
                    ctt1.Job_Order__c = rJobOrd.Id;
                    ctt1.ESN__c = rJobOrd.ESN__c;
                    ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                    ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                    ctt1.URL__c = wCAMTSBTRB[i].url; 
                    ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
                    lstCAM .add(ctt1);
                } // End CAM Method Call
            }
        }         
        //Get Campaign Information from QSOL based on ESN
        lstTSB = new List<CSS_CampTsbTrp__c>();
        system.debug('qsol language'+accountlang.CSS_QsolLanguage__c);
        rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,rJobOrd.ESN__c,'TSB',accountlang.CSS_QsolLanguage__c);
        if(rQSOLDocs !=null){
            wCAMTSBTRB = rQSOLDocs.item;
            if(wCAMTSBTRB!=null){
                for(integer i=0;i<wCAMTSBTRB.size();i++){
                    CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                    ctt1.Name = 'TSB' ;
                    ctt1.Type__c = 'TSB' ;
                    ctt1.Job_Order__c = rJobOrd.Id;
                    ctt1.ESN__c = rJobOrd.ESN__c;
                    ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                    ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                    ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
                    ctt1.URL__c = wCAMTSBTRB[i].url;
                    /*String s1 = string.valueof(wCAMTSBTRB[i].url);
system.debug('**s1**'+s1);
ctt1.URL__c = s1.substringBeforeLast('/');  
ctt1.Cu_Language__c = 'en'; 
ctt1.File_Name__c = s1.substringAfterLast('/');*/
                    
                    lstTSB .add(ctt1);
                } // End TSB Method Call
            }
        }
        
        //Get Campaign Information from QSOL based on ESN
        lstTRP = new List<CSS_CampTsbTrp__c>();
        rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,rJobOrd.ESN__c,'TRP',accountlang.CSS_QsolLanguage__c);
        if(rQSOLDocs !=null){
            wCAMTSBTRB = rQSOLDocs.item;
            if(wCAMTSBTRB!=null){
                for(integer i=0;i<wCAMTSBTRB.size();i++){
                    CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                    ctt1.Name = 'TRP' ;
                    ctt1.Type__c = 'TRP' ;
                    ctt1.Job_Order__c = rJobOrd.Id;
                    ctt1.ESN__c = rJobOrd.ESN__c;
                    ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                    ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                    ctt1.URL__c = wCAMTSBTRB[i].url;
                    ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
                    lstTRP .add(ctt1);
                } // End TRB Method Call
            }
        } 
        //Get ATC Information from QSOL based on ESN
        lstATC = new List<CSS_CampTsbTrp__c>();
        rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,rJobOrd.ESN__c,'ATC',accountlang.CSS_QsolLanguage__c);
        if(rQSOLDocs !=null){
            wCAMTSBTRB = rQSOLDocs.item;
            if(wCAMTSBTRB!=null){
                for(integer i=0;i<wCAMTSBTRB.size();i++){
                    CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                    ctt1.Name = 'ATC' ;
                    ctt1.Type__c = 'ATC' ;
                    ctt1.Job_Order__c = rJobOrd.Id;
                    ctt1.ESN__c = rJobOrd.ESN__c;
                    ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                    ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                    ctt1.URL__c = wCAMTSBTRB[i].url;
                    ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
                    lstATC.add(ctt1);
                } // End ATC Method Call
            }
        }
        
        //End All CAM,ATC, TSB & TRB
        system.debug('Value of LIST=='+ lstTRP);
        
    }
    public void getQSOLDocs() {
        try{
            //Commented below as part of Defect fix: GSSC 570
            //lstCAM =lstTRP =lstTSB=lstATC= new List<CSS_CampTsbTrp__c>();
            lstCAM = new List<CSS_CampTsbTrp__c>();
            lstTRP = new List<CSS_CampTsbTrp__c>();
            lstTSB = new List<CSS_CampTsbTrp__c>();
            lstATC= new List<CSS_CampTsbTrp__c>();
            map<string,List<CSS_CampTsbTrp__c>>  camprecs =CG_SL_QSOL.getQSOLMapWarrantyDocs(rJobOrd.Id,null,rJobOrd.ESN__c,accountlang.CSS_QsolLanguage__c,new list<string>{'CAMPAIGN','TSB','ATC','TRP'});
            for(string key :camprecs.keySet()){
                switch on key{
                    when 'CAM'{
                        if(camprecs.containskey(key)) lstCAM.addall(camprecs.get(key));  
                    }when 'TRP'{
                        if(camprecs.containskey(key)) lstTRP.addall(camprecs.get(key));
                    }when 'TSB'{
                        if(camprecs.containskey(key)) lstTSB.addall(camprecs.get(key));
                    }when 'ATC'{
                        if(camprecs.containskey(key)) lstATC.addall(camprecs.get(key));
                    }
                }
            }
        }catch(exception e){
            System.debug('The exception is'+e.getMessage()+' '+e.getLineNumber()); 
        }
        
    }
    //
    //Wrapper
    public List<sStrQASolWrap> fList{set;get;}
    sStrQASolWrap sWrapLst;        
    List<CSS_SymptomQA__c> allRecList = new List<CSS_SymptomQA__c>();
    
    public class sStrQASolWrap {            
        public CSS_SymptomQA__c sSearch{set;get;} 
        public list<CSS_SymptomQA__c> sQAWrap{set;get;} 
        public list<CSS_Solutions__c> sSolWrap{set;get;}             
        
        Public sStrQASolWrap(){                
            sSearch = new CSS_SymptomQA__c();
            sQAWrap = new list<CSS_SymptomQA__c>();
            sSolWrap = new list<CSS_Solutions__c>();
        }
    }
    public string successMessage{get;set;}
    public Boolean reportMessage{get;set;}
    public void reportProblemComments(){
        reportMessage=true;
        system.debug('selectedSol/report id:' + selectedSol.Id);
        system.debug('solution name:' + selectedSol.name);
        system.debug('solution title:' + selectedSol.Solution_Title__c);
        system.debug('DSID:'+rJobOrd.DSID__c);
        system.debug('report comments****:' + selectedSol.Report_Comments__c);
        CSS_EDSAuthentication.reportProblem(rJobOrd.DSID__c, selectedSol.name, selectedSol.Report_Comments__c);
        /*       CSS_Solutions__c repsol = new CSS_Solutions__c();
repsol.Report_Comments__c=selectedSol.Report_Comments__c;
repsol.id=selectedSol.Id;
update repsol;*/
        
        //Method Call to create a Case
        Id caseId = css_utility.createCase(selectedSol.Report_Comments__c, rJobOrd.Name, rJobOrd.Service_Model__c, selectedSol.Solution_Title__c, selectedSol.name);
        //ErrorMessage=true;
        //Id caseId =  createCase(selectedSol.Report_Comments__c);
        system.debug('**caseId**>>>>>>:'+caseId);
        if(caseId!=null ){
            reportMessage=true;
            successMessage='Thank you! Your problem has been reported. Check the Reported Solution Problems page for updates.';
            system.debug('**reportMessage**>>>>>>:'+reportMessage);
            system.debug('**successMessage**>>>>>>:'+successMessage);
        }
        else{
            reportMessage=true;
            successMessage='There was an issue to reporting your problem.';
        }
    }
    
    //Method to create a case to Report a Problem with the Solutions 
    /*
public Id createCase(String problem){
case problemCase = new Case();
problemCase.Status = 'New';
problemCase.Description = problem;
problemCase.Origin = 'Web';
problemCase.CSS_Job__c = rJobOrd.name;
problemCase.Service_Model__c = rJobOrd.Service_Model__c;
problemCase.Solution_Id__c = 'solution Id';
problemCase.Solution_Title__c = 'solution Title';
if(problemCase != null){
try{
insert problemCase;
}Catch(Exception e){
system.debug('exception message:-'+e.getMessage());
}

}
system.debug('**problemCase.id**'+problemCase.id);
return problemCase.id; 

} */
    
    
    public string getSols() {
        String sJobId = ApexPages.CurrentPage().getParameters().get('Id'); 
        /*List<CSS_Solutions__c> lstSolutions = new List<CSS_Solutions__c>([Select Id, Case_Name__c,Solution_Title__c, Service_Job__c, Rank__c,Report_Comments__C,
Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c
from CSS_Solutions__c where Symptom__c = :selectedSymId 
order by Rank__c]);*/
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        String sTitle = '';//Defect 62106
        string diagTargetResp; //Story GSSC-156
        Integer iCounter = 0;
        Boolean blnActive = false;
        for (CSS_Solutions__c recSol: lstSolutions )
        {
            String NestedJSONSols  = '[ ';
            String NestedsStat = '0';
            String NestedsSuffix = '';
            String NestedsTitle = '';//Defect 62106
            Integer NestediCounter = 0;
            Boolean NestedblnActive = false;
            system.debug('Anirudh recSol.CSS_Solutions__r>>>>'+recSol.CSS_Solutions__r);
            for(CSS_Solutions__c NesRecSol: recSol.CSS_Solutions__r){
                NestediCounter = NestediCounter + 1;
            if((NesRecSol.Diagnostic_Response__c == null) || (NesRecSol.Diagnostic_Response__c == '')){NestedsStat = '0';}
            if (NesRecSol.Diagnostic_Response__c == 'Not the solution') { NestedsStat = '1' ; }
            else if (NesRecSol.Diagnostic_Response__c == 'Most likely the solution') { NestedsStat = '2' ; }
            else if (NesRecSol.Diagnostic_Response__c == 'Could not perform the solution verification') { NestedsStat = '3' ; }
            //if(recSol.Diagnostic_Response__c = null || recSol.Diagnostic_Response__c = ''){sStat = '';}
            if (recSol.CSS_Solutions__r.size() > 1 && NestediCounter != recSol.CSS_Solutions__r.size()) { NestedsSuffix = ', ';}
            else { NestedsSuffix = ' ';}
            //if (rank== null) { rank = '0'; }
            //added for defect 109207
            /*Anirudh commented if (rank != null){rank = rankFromTs;} 
            else { rank = string.valueOf(Integer.valueOf(0));}
            //end
            if (Integer.valueOf(rank) == recSol.Rank__c) { blnActive = true; } else { blnActive = false; } */
            
            //Defect 62106
            NestedsTitle = NesRecSol.Solution_Title__c.replace('"','\'');
            //Added below for story GSSC-156
            diagTargetResp = (NesRecSol.DiagTargetTime__c != null && NesRecSol.DiagTargetTime__c != 0.00) ? (string.valueof(NesRecSol.DiagTargetTime__c) +' '+ 'Hours') : (NesRecSol.TargetMessage__c != null ? NesRecSol.TargetMessage__c : '' );
            //JSONSols  = JSONSols + '{ "id" : "' + recSol.Id + '" , "CaseName" : "' + recSol.Case_Name__c + '" , "CaseTitle" : "' + recSol.Solution_Title__c + '" , "casestatus" : "' + sStat + '" , "sRank" : "' + recSol.Rank__c + '" , "isActive" : ' + blnActive + ' }' + sSuffix;
            //Added diagTT attribute in below JSON for story GSSC-156
            NestedJSONSols  = NestedJSONSols + '{ "id" : "' + NesRecSol.Id + '" , "Name" : "' + NesRecSol.Name + '", "diagTT" : "' + diagTargetResp + '", "CaseTitle" : "' + NestedsTitle + '" , "casestatus" : "' + NestedsStat + '" , "sRank" : "' + NesRecSol.Rank__c + '" , "isActive" : ' + blnActive + ' }' + NestedsSuffix;
            //JSONSols  = JSONSols + '{ \'id\' : \'' + recSol.Id + '\' , \'CaseName\'; : \'' + recSol.Case_Name__c + '\' , \'CaseTitle\' : \'' + recSol.Solution_Title__c + '\' , \'casestatus\' : \'' + sStat + '\' }' + sSuffix;
            //sStat = '0';
            }
            NestedJSONSols  = NestedJSONSols + ' ]';
            iCounter = iCounter + 1;
            if((recSol.Diagnostic_Response__c == null) || (recSol.Diagnostic_Response__c == '')){sStat = '0';}
            if (recSol.Diagnostic_Response__c == 'Not the solution') { sStat = '1' ; }
            else if (recSol.Diagnostic_Response__c == 'Most likely the solution') { sStat = '2' ; }
            else if (recSol.Diagnostic_Response__c == 'Could not perform the solution verification') { sStat = '3' ; }
            //if(recSol.Diagnostic_Response__c = null || recSol.Diagnostic_Response__c = ''){sStat = '';}
            if (lstSolutions.size() > 1 && iCounter != lstSolutions.size()) { sSuffix = ', ';}
            else { sSuffix = ' ';}
            //if (rank== null) { rank = '0'; }
            //added for defect 109207
            if (rank != null){rank = rankFromTs;} 
            else { rank = string.valueOf(Integer.valueOf(0));}
            //end
            if (Integer.valueOf(rank) == recSol.Rank__c) { blnActive = true; } else { blnActive = false; }
            
            //Defect 62106
            sTitle = recSol.Solution_Title__c.replace('"','\'');
            //Added below for story GSSC-156
            diagTargetResp = (recSol.DiagTargetTime__c != null && recSol.DiagTargetTime__c != 0.00) ? (string.valueof(recSol.DiagTargetTime__c) +' '+ 'Hours') : (recSol.TargetMessage__c != null ? recSol.TargetMessage__c : '' );
            //JSONSols  = JSONSols + '{ "id" : "' + recSol.Id + '" , "CaseName" : "' + recSol.Case_Name__c + '" , "CaseTitle" : "' + recSol.Solution_Title__c + '" , "casestatus" : "' + sStat + '" , "sRank" : "' + recSol.Rank__c + '" , "isActive" : ' + blnActive + ' }' + sSuffix;
            //Added diagTT attribute in below JSON for story GSSC-156
            JSONSols  = JSONSols + '{ "id" : "' + recSol.Id + '" , "Name" : "' + recSol.Name + '" , "diagTT" : "' + diagTargetResp + '" , "CaseTitle" : "' + sTitle + '" , "casestatus" : "' + sStat + '" , "sRank" : "' + recSol.Rank__c + '" , "NestedSols" : ' + NestedJSONSols + ' , "isActive" : ' + blnActive + ' }' + sSuffix;
            //JSONSols  = JSONSols + '{ \'id\' : \'' + recSol.Id + '\' , \'CaseName\'; : \'' + recSol.Case_Name__c + '\' , \'CaseTitle\' : \'' + recSol.Solution_Title__c + '\' , \'casestatus\' : \'' + sStat + '\' }' + sSuffix;
            //sStat = '0';
        }
        JSONSols  = JSONSols + ' ]';
        system.debug('Anirudh JSONSols>>>>>>'+JSONSols);
        return JSONSols.replace('<br />', '');
    }
    
    public string getRefreshedSols() {
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        String sTitle = '';//Defect 62106
        Integer iCounter = 0;
        Boolean blnActive = false;
        system.debug('solDetails111 >>>>>>>>'+ solDetails);
        
        for (CSS_Solutions__c recSol: solDetails )
        {
            String NestedJSONSols  = '[ ';
            String NestedsStat = '0';
            String NestedsSuffix = '';
            String NestedsTitle = '';//Defect 62106
            string NestedDiagTargetResp; //Story GSSC-156
            Integer NestediCounter = 0;
            Boolean NestedblnActive = false;
            system.debug('Anirudh recSol.CSS_Solutions__r>>>>'+recSol.CSS_Solutions__r);
            for(CSS_Solutions__c NesRecSol: recSol.CSS_Solutions__r){
                NestediCounter = NestediCounter + 1;
            if((NesRecSol.Diagnostic_Response__c == null) || (NesRecSol.Diagnostic_Response__c == '')){NestedsStat = '0';}
            if (NesRecSol.Diagnostic_Response__c == 'Not the solution') { NestedsStat = '1' ; }
            else if (NesRecSol.Diagnostic_Response__c == 'Most likely the solution') { NestedsStat = '2' ; }
            else if (NesRecSol.Diagnostic_Response__c == 'Could not perform the solution verification') { NestedsStat = '3' ; }
            //if(recSol.Diagnostic_Response__c = null || recSol.Diagnostic_Response__c = ''){sStat = '';}
            if (recSol.CSS_Solutions__r.size() > 1 && NestediCounter != recSol.CSS_Solutions__r.size()) { NestedsSuffix = ', ';}
            else { NestedsSuffix = ' ';}
            //if (rank== null) { rank = '0'; }
            //added for defect 109207
            /* if (rank != null){rank = rankFromTs;} 
            else { rank = string.valueOf(Integer.valueOf(0));}
            //end
            if (Integer.valueOf(rank) == recSol.Rank__c) { blnActive = true; } else { blnActive = false; } */
            
            //Defect 62106
            NestedsTitle = NesRecSol.Solution_Title__c.replace('"','\'');
            //Added below for story GSSC-156
            NestedDiagTargetResp = (NesRecSol.DiagTargetTime__c != null && NesRecSol.DiagTargetTime__c != 0.00) ? (string.valueof(NesRecSol.DiagTargetTime__c) +' '+ 'Hours') : (NesRecSol.TargetMessage__c != null ? NesRecSol.TargetMessage__c : '' );
            
            //JSONSols  = JSONSols + '{ "id" : "' + recSol.Id + '" , "CaseName" : "' + recSol.Case_Name__c + '" , "CaseTitle" : "' + recSol.Solution_Title__c + '" , "casestatus" : "' + sStat + '" , "sRank" : "' + recSol.Rank__c + '" , "isActive" : ' + blnActive + ' }' + sSuffix;
            //Added diagTT attribute in below JSON for story GSSC-156
            NestedJSONSols  = NestedJSONSols + '{ "id" : "' + NesRecSol.Id + '" , "Name" : "' + NesRecSol.Name + '", "diagTT" : "' + NestedDiagTargetResp + '", "CaseTitle" : "' + NestedsTitle + '" , "casestatus" : "' + NestedsStat + '" , "sRank" : "' + NesRecSol.Rank__c + '" , "isActive" : ' + blnActive + ' }' + NestedsSuffix;
            //JSONSols  = JSONSols + '{ \'id\' : \'' + recSol.Id + '\' , \'CaseName\'; : \'' + recSol.Case_Name__c + '\' , \'CaseTitle\' : \'' + recSol.Solution_Title__c + '\' , \'casestatus\' : \'' + sStat + '\' }' + sSuffix;
            //sStat = '0';
            }
            NestedJSONSols  = NestedJSONSols + ' ]';
            iCounter = iCounter + 1;
            if((recSol.Diagnostic_Response__c == null) || (recSol.Diagnostic_Response__c == '')){sStat = '0';}
            if (recSol.Diagnostic_Response__c == 'Not the solution') { sStat = '1' ; }
            else if (recSol.Diagnostic_Response__c == 'Most likely the solution') { sStat = '2' ; }
            else if (recSol.Diagnostic_Response__c == 'Could not perform the solution verification') { sStat = '3' ; }
            if (solDetails.size() > 1 && iCounter != solDetails.size()) { sSuffix = ', ';}
            else { sSuffix = ' ';}
            if (rank== null) { rank = '0'; }
            if (selectedSol.Id == recSol.Id) { 
                if(recSol.Diagnostic_notes__c != '' && recSol.Diagnostic_notes__c!=null){
                    remCharcounter=4000 - (recSol.Diagnostic_notes__c).length() ;
                    //system.debug('remCharcounter222'+remCharcounter);
                }
                else{
                    remCharcounter=4000 ; 
                }
                
                blnActive = true; } else { blnActive = false; }
            
            //Defect 62106
            sTitle = recSol.Solution_Title__c.replace('"','\'');
            
            //Added below for story GSSC-156
            NestedDiagTargetResp = (recSol.DiagTargetTime__c != null && recSol.DiagTargetTime__c != 0.00) ? (string.valueof(recSol.DiagTargetTime__c) +' '+ 'Hours') : (recSol.TargetMessage__c != null ? recSol.TargetMessage__c : '' );
            //Added diagTT attribute in below JSON for story GSSC-156
            JSONSols  = JSONSols + '{ "id" : "' + recSol.Id + '" , "Name" : "' + recSol.Name + '", "diagTT" : "' + NestedDiagTargetResp + '", "CaseTitle" : "' + sTitle + '" , "casestatus" : "' + sStat + '" , "sRank" : "' + recSol.Rank__c + '" , "NestedSols" : ' + NestedJSONSols + ' , "isActive" : ' + blnActive + ' }' + sSuffix;
            //JSONSols  = JSONSols + '{ \'id\' : \'' + recSol.Id + '\' , \'CaseName\'; : \'' + recSol.Case_Name__c + '\' , \'CaseTitle\' : \'' + recSol.Solution_Title__c + '\' , \'casestatus\' : \'' + sStat + '\' }' + sSuffix;
            //sStat = '0';
        }
        JSONSols  = JSONSols + ' ]';
        system.debug('Anirudh JSONSols2>>>>>>'+JSONSols);
        return JSONSols.replace('<br />', '');
    }
    
    public Id Ins_JobId{set;get;} 
    // Story - 65995 DS Read Only - start
    public string dsidind{get; set;} 
    public boolean inddsid{get; set;}
    // Story - 65995 DS Read Only - end
    public css_job_order__c rJobOrd {get;set;}
    public CSS_SymptomQA__c rSym;
    public String selectedFaulcode{set;get;}
    public String sKNumber {set;get;}
    public String selectedFaulcodeId{set;get;}
    public String selectedSymId{set;get;}
    public Boolean isfaultCodeView {set;get;}
    public static Boolean symFCSerError{get;set;}
    public String selectedReltdFaulcode{set;get;}
    public List<CSS_JobEventTemporary__c> qsolRetrivedFCMasters {set;get;}
    public CSS_JobEventTemporary__c qsolRetrivedFCMaster {set;get;}    
    public List<CSS_Fault_Code__c> recFaultCode {set;get;}
    public User u3{get;set;}
    public CSS_accountLanguage__c aLang{get;set;}
    
    
    public PageReference faultCodeClick(){ 
        system.debug('selectedSymId: '+selectedSymId);
        system.debug('******before soql: '+selectedFaulcodeId);
        system.debug('selectedReltdFaulcode: '+selectedReltdFaulcode);
        rSym = [select Id,name,createddate,Job_Order__c,Caption__c,Option_type__c,Answers__c,Option1__c,Option2__c,Option3__c,Option4__c,Option5__c,Guide_Question__c,Sequence__c,Type__c
                from CSS_SymptomQA__c where job_order__c=:Ins_JobId and Id=:selectedSymId and Type__c='SearchString' Limit 1];
        system.debug('rSym.Caption__c'+rSym.Caption__c);
        //Defect 62085
        CSS_QuickServe.workJob = rJobOrd;
        //added for defect 109207
        if(rank == null ){
            this.rank = '0';}
        symFCSerError = false;
        if(rSym.Caption__c != null && rSym.Caption__c != '' && rSym.Caption__c.isNumeric()){
            qsolRetrivedFCMaster = CSS_QuickServe.getFaultCodeOverview(rSym.Caption__c,rJobOrd.ESN__c);  
            system.debug('qsolRetrivedFCMaster'+qsolRetrivedFCMaster);
            if(qsolRetrivedFCMaster==null){
                symFCSerError = true;//GSSC-91
            }
        }
        //QSOL Docs
        userlang = css_utility.getUserAttributes(userinfo.getUserId());
        accountlang = css_utility.getLanguage(userlang.LanguageLocaleKey); 
        if(!Test.isRunningTest()){
            getQSOLDocs();
        }
        getSolutionDetails();
        //css_tnd_job updqsol = new css_tnd_job();
        //updqsol.updateNotes();
        //list<CSS_CampTsbTrp__c> x = new list<CSS_CampTsbTrp__c>();
        
        //
        //String fcsoql = 'select Id,Name,Related_Fault_Code__c from CSS_Fault_Code__c where id = :selectedFaulcodeId LIMIT 1';
        //recFaultCode = DataBase.query(fcsoql);
        /*if(recFaultCode != null && recFaultCode.size()>0){
selectedFaulcode = recFaultCode[0].Name;
selectedReltdFaulcode = recFaultCode[0].Related_Fault_Code__c;
String soql = 'select Circuit_Description__c, Comp_Location__c, Effect__c, Engine__c, Fault_Code_Description__c, File_Name__c, FMI__c, Lamp__c, Reason__c, Service_Model_Name__c, SPN__c from CSS_JobEventTemporary__c where Name = \'' + selectedFaulcode + '\' LIMIT 1';
system.debug('*****soql: '+soql);
qsolRetrivedFCMasters = DataBase.query(soql);
this.rank = '0';
//making a callout to pull if not found in JobEventTemporary
if(qsolRetrivedFCMasters.isEmpty() && qsolRetrivedFCMasters.size() == 0){
System.debug('hello 123');
CSS_QuickServe.workJob = rJobOrd;
//qsolRetrivedFCMaster = CSS_QuickServe.getFaultCodeOverview(selectedFaulcode,rJobOrd.ESN__c);            
//getSolutionDetails();
//insert qsolRetrivedFCMaster;
}else{
qsolRetrivedFCMaster = qsolRetrivedFCMasters[0];
getSolutionDetails();
}             
}*/
        isfaultCodeView = false;
        //failureCodeDetails = getSRTComponentOnLoad();
        //system.debug('output wrapper-->'+failureCodeDetails);
        return null;
    }
    public String rank {get;set;}
    public integer nestedIndentation{get;set;}
    public string rankFromTs{get;set;}
    public CSS_Solutions__c selectedSol{get;set;}
    
    public List<CSS_Solutions__c> solDetails{get;set;}
    public CSS_J2ASolution_EDS solDet{get;set;}
    public CSS_J2ANestSol_EDS  solDet1{get;set;}
    public Boolean solDetFailed{set;get;}
    public String solErrorMsg{set;get;}
    public map<string,CSS_Solutions__c> nestedSolutionsMap;
    public map<string,NestedSolutionsClass> respNestedSolutionsMap;
    public list<NestedSolutionsClass> nestedSolutionsList{get;set;}    
    public String selectedNestSolTitle{set;get;}    
    public String selectedNestSolTitle1{set;get;}
    public String currentNestSolId{set;get;}
    public String selectedNestSolId{set;get;}  
    public String queryFrom{set;get;}  
    public NestedSolutionsClass selectedNestSol{set;get;}
    public Class NestedSolutionsClass {
        public CSS_J2ASolution_EDS.verCompoundSolutions repCompSol{get;set;} 
        public CSS_Solutions__c solRec{set;get;}
        
        //constructor
        public NestedSolutionsClass(CSS_J2ASolution_EDS.verCompoundSolutions nestSol,CSS_Solutions__c sol){
            this.repCompSol = nestSol;
            this.solRec = sol;
        }
    }
    
    public void getNestSolutionDetails(){
        nestedacessrtboolean=false;
        nestFailDiagResp=false;
        if(selectedNestSolTitle != null && respNestedSolutionsMap.containsKey(selectedNestSolTitle))
            selectedNestSol = respNestedSolutionsMap.get(selectedNestSolTitle);
        Integer nextRank1 = Integer.valueOf(rank);
        HttpResponse res2 = CSS_EDSActionsUpdate.caseViewed(selectedNestSol.solRec.Name, nextRank1, rJobOrd.DSID__c);
        system.debug('Response for nested sol' +res2);
        if(res2.getStatusCode() == 200){
            solDetFailed = false; 
            solDet1 = (CSS_J2ANestSol_EDS)JSON.deserializeStrict(res2.getBody(),CSS_J2ANestSol_EDS.class);
            System.debug('The soldet for nest sol'+solDet1);
        }else{
            solDetFailed = true;
            solErrorMsg = res2.getStatus();
        } 
        system.debug('selectedNestSol-->'+selectedNestSol);
        JSONSolsGlob =  getRefreshedSols();
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1 = [SELECT Id, Name, Diagnostic_notes__c, No_Access_SRT_required__c,Diagnostic_Response__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
        
        if(sol1.Diagnostic_notes__c != '' && sol1.Diagnostic_notes__c!=null){
            remCharcounterNest=4000 - (sol1.Diagnostic_notes__c).length() ;
            //system.debug('remCharcounter222'+remCharcounter);
        }
        else{
            remCharcounterNest=4000 ; 
        }
        if(sol1.Diagnostic_Response__c != ''){
            selectedDiagRespNested = sol1.Diagnostic_Response__c;
        }
         //if(sol1.No_Access_SRT_required__c==true || sol1.No_Access_SRT_required__c==false)
             // srtaccesssrtcheckbox = sol1.No_Access_SRT_required__c;
        
        system.debug('sol1.No_Access_SRT_required__c'+sol1.No_Access_SRT_required__c);
        system.debug('srtaccesssrtcheckbox'+srtaccesssrtcheckbox);
        //getPartsListCompSol(selectedNestSolId);
        getPartsListCompSol();
        partssave(nestedListsrtCompWrapper);
        
        UpdateNestedSolNotes();
        nestedacessrtboolean=false;
        nestFailDiagResp=false;
    }    
    public void UpdateNestSolNotes(){
        system.debug('Inside UpdateNestSolNotes');
        if(selectedNestSol != null && selectedNestSol.solRec != null){
            selectedNestSol.solRec.Service_Job__c = rJobOrd.Id;
            upsert selectedNestSol.solRec;
        }
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1 = [SELECT Id, Name, Diagnostic_notes__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
        system.debug('Inside UpdateNestSolNotes1');
        if(sol1.Diagnostic_notes__c != '' && sol1.Diagnostic_notes__c!=null){
            remCharcounterNest=4000 - (sol1.Diagnostic_notes__c).length() ;
            system.debug('remCharcounter222'+remCharcounterNest);
        }
        else{
            remCharcounterNest=4000 ; 
        }
    }
    public Boolean failDiagResp{get;set;}
    public Boolean nestFailDiagResp{get;set;}
    public List<string> solDiagAdd;
    public PageReference nextSolution(){
        system.debug('Inside Next Solution');
        CSS_Solutions__c s2 = [select Diagnostic_Response__c,Diagnostic_notes__c from CSS_Solutions__c where id=:selectedSol.id ];
        if(s2.Diagnostic_Response__c=='Most likely the solution' && (selectedSol.Diagnostic_Response__c=='Not the solution' || selectedSol.Diagnostic_Response__c=='Could not perform the solution verification')){
            deletesolCompNparts();
        }
        //saikomal finding nemo 171488
        accesserorboolean = false;
        srtaccesssrtcheckbox=false;
        srtaccesssrtcheckbox1=false;
        warningcustomlabel=false;
        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =:selectedSol.Id];
         //scenario1 first time no access checkbox is true and any solution check box enable and disable the link
       /* if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==false){
            srtaccesssrtcheckbox=false;
            srtaccesssrtcheckbox1=false;
            warningcustomlabel=false;

        }*/
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=true;
                    srtaccesssrtcheckbox=false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=true;
                    warningcustomlabel=false;
                }
                   //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=false;
                }
                  //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=false;
                    warningcustomlabel=true;
                }
        
        if(((lstSRT != null && lstSRT.size()==0) || selectedSol.No_Access_SRT_required__c!=true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
            accesserorboolean=true;
            // return null;
        }
        
        else{
            accesserorboolean = false;
        }
        
        if(((lstSRT != null && lstSRT.size()>0)|| selectedSol.No_Access_SRT_required__c==true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
            accesserorboolean = false;
        }
        //end   
        failDiagResp = validateResponse();
        if(accesserorboolean==false && warningcustomlabel==false && failDiagResp==false){
            
            if(rank != null){
                solDiagAdd = new List<string>();
                //failDiagResp = validateResponse();
               // if(failDiagResp)
                  //  return null;
                Id solId = selectedSol.id;
                String solDiagnose = selectedSol.Diagnostic_Response__c;
                       //
                List<string> lstDiagNotes = new List<string>();
                lstDiagNotes = selectedSol.Diagnostic_notes__c.split('\n');
                system.debug('lstDiagNotes--'+lstDiagNotes);
                string diagNotes='';
                for(string s:lstDiagNotes){
                    
                    diagNotes+= s+'\\n';
                }
                system.debug('diagNotes--'+diagNotes);
                
                
                //
                
                String solDiagnoseNotes = selectedSol.Diagnostic_notes__c;
                boolean srtcheckbox = selectedSol.No_Access_SRT_required__c;
                Integer nextRank = Integer.valueOf(rank) +1;
                Integer fstSoln = Integer.valueOf(selectedSol.Rank__c);//Defect63117
                ////Added for EDS - Update Trigger
                CSS_Solutions__c s1 = [select Diagnostic_Response__c,Diagnostic_notes__c,No_Access_SRT_required__c from CSS_Solutions__c where id=:solId ];
                string oldDiagResp = s1.Diagnostic_Response__c;
                string oldDiagNotes = s1.Diagnostic_notes__c;
                
                
                //End EDS Update Trigger
                
                rank = ''+nextRank;
                
                //system.debug('rankisPole2'+selectedsol.Symptom__r.isPole__c);
                //Defect63117:Modified condition
                if((solDiagnose==null || solDiagnose=='') && selectedsol.Symptom__r.isPole__c==true){
                    isPopupReq();
                }
                //Defect63117:Added condition
                if(fstSoln == 0 && (solDiagnose==null || solDiagnose=='') && selectedsol.Symptom__r.isPole__c==true ){
                    system.debug('inFirstSolnPopup'+fstSoln+''+ solDiagnose);
                    displayOutofOrder = true;
                }
                //Added for EDS - Update Trigger
                if(oldDiagResp!=solDiagnose ||oldDiagNotes!= solDiagnoseNotes){
                    solDiagAdd.add(JSON.Serialize(new solWrapper(solDiagnose,selectedSol.Name,diagNotes,rJobOrd.DSID__c)));
                    CSS_EDSActionsUpdate.caseDiagStatusUpdate(solDiagAdd);
                }
                //End EDS Update Trigger
                
                //Calling SRT parts and saving
                //Commented below code as per defect GSSC 697
                /* if(selSolution=='Most likely the solution'){
                    partssave(listsrtCompWrapper);
                 }*/
                // update the prev sol
                    
                if(!displayOutofOrder || Out_Of_Order_Popup_displayed){
                    getSolutionDetails();  
                    
                    //Moved after web service call as per defect GSSC 697
                    //Calling SRT parts and saving
                     if(selSolution=='Most likely the solution'){
                        partssave(listsrtCompWrapper);
                     }

                    updateSol(solId,solDiagnose,solDiagnoseNotes,srtcheckbox);
                    // Begin- Added for refreshing JSON content
                    String soql = 'select Id,Symptom__r.isPole__c,Out_Of_Order__c,Diagnosis_Icon__c,Name,Rank__c,No_Access_SRT_required__c,Out_Of_Order_Popup_displayed__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Report_Comments__c,Diagnostic_notes__c, '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                    soql += '(select Id,Nested_Rank__c,FaultCode__r.isPole__c,Symptom__r.isPole__c,No_Access_SRT_required__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r order by Nested_Rank__c) '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                    soql += 'from CSS_Solutions__c where Symptom__c = :selectedSymId and CSS_Nested_Solutions__c = null order by Rank__c';    
                    solDetails = DataBase.query(soql);          
                    
                    JSONSolsGlob =  getRefreshedSols();

                    // End- Added for refreshing JSON content
                   //scenario1 first time no access checkbox is true and any solution check box enable and disable the link
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=true;
                    srtaccesssrtcheckbox=false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=true;
                }
                    
                }
            }
            
            return null;
        }
        else
            return null;
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
    public void updateSol(Id solId, String solDiagnose,String solDiagnoseNotes,boolean srtcheckbox){
        if(solId != null){
            CSS_Solutions__c updSol = new CSS_Solutions__c(Id = solId,Diagnostic_Response__c = solDiagnose,Diagnostic_notes__c =solDiagnoseNotes,No_Access_SRT_required__c = srtcheckbox);
            update updSol;
        }
    }
    public boolean acceschecbox{get;set;}
    public boolean acceschecbox1{get;set;}
    
    public PageReference UpdateSolNotes(){
        System.debug('UpdateSolNotesselectedSol: ');
        //Prabhakar added for GSSC-120
       
        CSS_Solutions__c s2 = [select Diagnostic_Response__c,Diagnostic_notes__c from CSS_Solutions__c where id=:selectedSol.id ];
        system.debug('solution****'+s2.Diagnostic_Response__c);
        system.debug('selectodsol@@@'+selectedSol.Diagnostic_Response__c);
        if(s2.Diagnostic_Response__c=='Most likely the solution' && (selectedSol.Diagnostic_Response__c=='Not the solution' || selectedSol.Diagnostic_Response__c=='Could not perform the solution verification')){
            deletesolCompNparts();
        }
   
        //
        
        //saikomal finding nemo 171488
        accesserorboolean = false;
        srtaccesssrtcheckbox=false;
        srtaccesssrtcheckbox1=false;
        warningcustomlabel=false;
        
        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =: selectedSol.Id];
        
        System.debug('list size ->>'+lstSRT.size());
        System.debug('selectedSol.No_Access_SRT_required__c ->>'+selectedSol.No_Access_SRT_required__c);
        System.debug('selectedSol.Diagnostic_Response__c ->>'+selectedSol.Diagnostic_Response__c);
        
       /* if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c!=true)
            acceschecbox=true;
         if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true)
            acceschecbox1=true;*/ 
         //scenario1 first time no access checkbox is true and any solution check box enable and disable the link
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=true;
                    srtaccesssrtcheckbox=false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=true;
                    warningcustomlabel=false;
                }
                   //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=false;
                }
                  //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=false;
                    warningcustomlabel=true;
                }
       
        if(((lstSRT != null && lstSRT.size()==0) || selectedSol.No_Access_SRT_required__c!=true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
            accesserorboolean=true;
            //srtaccesssrtcheckbox = false;//Added Prabhakar
           // warningcustomlabel = false;
            // return null;
        }
        
        else{
            System.debug('**inside else part****');
            accesserorboolean = false;
        }
        
        if(((lstSRT != null && lstSRT.size()>0) || selectedSol.No_Access_SRT_required__c==true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
            
            System.debug('**inside if2 part****');
            accesserorboolean = false;
           // srtaccesssrtcheckbox1=false;
           
        }
        //end    
        failDiagResp = validateResponse();
        if(accesserorboolean == false && warningcustomlabel==false && failDiagResp==false){                       
            try{
                solDiagAdd = new List<string>();
                //failDiagResp = validateResponse();
               // if(failDiagResp)
                   // return null;
                //Added for EDS - Update Trigger    
                CSS_Solutions__c s1 = [select Diagnostic_Response__c,Diagnostic_notes__c from CSS_Solutions__c where id=:selectedSol.id ];
                string oldDiagResp = s1.Diagnostic_Response__c;
                string oldDiagNotes = s1.Diagnostic_notes__c;
                System.debug('The sol response is'+oldDiagResp);
                 //
                List<string> lstDiagNotes = new List<string>();
                lstDiagNotes = selectedSol.Diagnostic_notes__c.split('\n');
                system.debug('lstDiagNotes--'+lstDiagNotes);
                string diagNotes='';
                for(string s:lstDiagNotes){
                    
                    diagNotes+= s+'\\n';
                }
                system.debug('diagNotes--'+diagNotes);
                
                
                //
                //System.debug('The sol inside response is'+solDiagnose);
                if(oldDiagResp!=selectedSol.Diagnostic_Response__c||oldDiagNotes!= selectedSol.Diagnostic_notes__c){
                    solDiagAdd.add(JSON.Serialize(new solWrapper(selectedSol.Diagnostic_Response__c,selectedSol.Name,diagNotes,rJobOrd.DSID__c)));
                    CSS_EDSActionsUpdate.caseDiagStatusUpdate(solDiagAdd);
                }
                //End - EDS Update Trigger 
                System.debug('selectedSol-->>>>>'+selectedSol);
                
                if(selectedSol != null){   
                    
                    //Defect63117:Commented---Start
                    /*Boolean isoutOfOrder = false;
for(CSS_Solutions__c sols:solDetails){
if(sols.Rank__c < selectedSol.Rank__c && sols.Diagnostic_Response__c == null){
isoutOfOrder = true;
break;
}
}*/
                    //selectedSol.Out_Of_Order__c = isoutOfOrder;
                    //Defect63117:Modified condition---End
                    //Calling SRT parts and saving
                    if(selSolution=='Most likely the solution')
                    partssave(listsrtCompWrapper);
                    update selectedSol;
                    isPopupReq();
                }
                // Update Nested solutions if any
                /* if(selectedNestSol != null && selectedNestSol.solRec != null){
selectedNestSol.solRec.Service_Job__c = rJobOrd.Id;
upsert selectedNestSol.solRec;
}     */
                getUpdatedsolsDets();
                
                // Begin- Added for refreshing JSON content
                JSONSolsGlob =  getRefreshedSols();
                // End- Added for refreshing JSON content
                warningcustomlabel=false;
              //scenario1 first time no access checkbox is true and any solution check box enable and disable the link
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=true;
                    srtaccesssrtcheckbox=false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=true;
                }
                
            }catch(Exception ex){
                System.debug('Error Line:'+ex.getLineNumber());
                System.debug('Error Message:'+ex.getMessage());
            }    
            //selectedSol = [select Id,FaultCode__r.isPole__c,Out_Of_Order__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c, (select Id,FaultCode__r.isPole__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r) from CSS_Solutions__c where Id = :selectedSol.Id];
            
            return null;
        }
        else
            return null;
    }

    public String selectedDiagRespNested{get;set;}
    public boolean inputbox{get;set;}
    public boolean srtaccesssrtcheckbox{get;set;}
    public boolean srtaccesssrtcheckbox1{get;set;}
    public boolean warningcustomlabel{get;set;}
    public string diagnestnotes{get;set;}
    //Added below method for story GSSC-77 start
    public void AccessSrtdisableMethod(){
        system.debug('entered into disable method');
        inputbox = false;
        srtaccesssrtcheckbox1 = false;
        warningcustomlabel = false;
        srtaccesssrtcheckbox=false;
       lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =: selectedSol.Id];
        system.debug('entered into***'+lstSRT.size());
        if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==true){
           
           // srtaccesssrtcheckbox=true;
            srtaccesssrtcheckbox=false;
            warningcustomlabel=true;
            system.debug('entered***'+srtaccesssrtcheckbox);
           
        }
        else  if(lstSRT != null && lstSRT.size()>0 &&  selectedSol.No_Access_SRT_required__c==false){
            system.debug('chkboxdisable');
            srtaccesssrtcheckbox=true;
            //srtaccesssrtcheckbox=false;
            warningcustomlabel=false;
        }
        else{
            if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==false){
                srtaccesssrtcheckbox=false;
                warningcustomlabel = false;
                srtaccesssrtcheckbox1 = false;
                system.debug('entered into11***'+srtaccesssrtcheckbox);
                system.debug('entered into11*4**'+srtaccesssrtcheckbox1);
            }
            else{
               srtaccesssrtcheckbox1 = true;
                srtaccesssrtcheckbox=false;
                warningcustomlabel = false;
                system.debug('entered into11568***'+srtaccesssrtcheckbox);
                system.debug('entered into11*4*9*'+srtaccesssrtcheckbox1);
            }
      
        }

    }
    //
    public boolean enablelinkvarable{get;set;}
    public boolean enablechecbox{get;set;}
    public boolean warningcustomlabel1{get;set;}
    public void AccessSrtdisableNested(){
        system.debug('entered into disable method');
        enablelinkvarable = false;
        warningcustomlabel1 = false;
        enablechecbox=false;
        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =: selectedNestSolId];
        system.debug('entered into***'+lstSRT.size());
        if(lstSRT != null && lstSRT.size()>0 && selectedNestSol.solRec.No_Access_SRT_required__c==true){
            enablechecbox=false;
            //srtaccesssrtcheckbox=false;
            warningcustomlabel1=true;
        }
        else  if(lstSRT != null && lstSRT.size()>0 &&  selectedNestSol.solRec.No_Access_SRT_required__c==false){
            enablechecbox=true;
            //srtaccesssrtcheckbox=false;
            warningcustomlabel=false;
        }
      
        else{
            if(lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c==false){
                enablelinkvarable=false;
                enablechecbox=false;
                warningcustomlabel1 = false;
               
            }
            else{
                enablelinkvarable=true;
                enablechecbox=false;
                warningcustomlabel1 = false;
            }
        }

    }
    //
    //Added below method for story GSSC-77 start
    public PageReference UpdateNestedSolNotes(){
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1 = [SELECT Id,Diagnostic_Response__c, Name, Diagnostic_notes__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
        system.debug('selectedDiagRespNested'+selectedDiagRespNested);
        system.debug('nestedListsrtCompWrapper--'+nestedListsrtCompWrapper); 
        System.debug('selectedNestSol.solRec.Diagnostic_Response__c'+selectedNestSol.solRec.Diagnostic_Response__c);
         if(sol1.Diagnostic_Response__c=='Most likely the solution' && (selectedDiagRespNested=='Not the solution' || selectedDiagRespNested=='Could not perform the solution verification')){
            deleteNestedSolCompNparts();
        }
        
        nestedacessrtboolean=false;
        nestFailDiagResp=false;
        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =:selectedNestSolId];
                  system.debug('lstSRTSize>>>'+lstSRT);
                  system.debug('sol1.No_Access_SRT_required__c>>>'+srtaccesssrtcheckbox);
                  system.debug('selectedDiagRespNested'+selectedDiagRespNested);
        //
        enablelinkvarable = false;
        warningcustomlabel1 = false;
        enablechecbox=false;
         //scenario1 first time no access checkbox is true and any solution check box enable and disable the link--Prabhakar added code for GSSC-77
                if(lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c==true){
                    enablelinkvarable = true;
                    //srtaccesssrtcheckbox1=true;
                   // srtaccesssrtcheckbox=false;
                    enablechecbox = false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedNestSol.solRec.No_Access_SRT_required__c==false){
                    enablelinkvarable = false;
                    //srtaccesssrtcheckbox1=false;
                    enablechecbox=true;
                   // srtaccesssrtcheckbox=true;
                    warningcustomlabel1=false;
                }
                   //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c==false){
                    enablelinkvarable = false;
                    //srtaccesssrtcheckbox1=false;
                    enablechecbox=false;
                   // srtaccesssrtcheckbox=false;
                }
                  //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedNestSol.solRec.No_Access_SRT_required__c==true){
                    enablelinkvarable = false;
                    enablechecbox=false;
                    warningcustomlabel1=true;
                }
        //End code for GSSC-77
        
        
        
        //
        if(((lstSRT != null && lstSRT.size()==0) || selectedNestSol.solRec.No_Access_SRT_required__c!=true) && (selectedDiagRespNested=='Not the solution'|| selectedDiagRespNested=='Most likely the solution')){
            nestedacessrtboolean = true;
             system.debug('nestedacessrtbooleanif>>>'+nestedacessrtboolean);
        }
        else{
            nestedacessrtboolean = false;
        }
        if(((lstSRT != null && lstSRT.size()>0) || selectedNestSol.solRec.No_Access_SRT_required__c==true) && (selectedDiagRespNested=='Not the solution'|| selectedDiagRespNested=='Most likely the solution')){

            System.debug('**inside nestedacessrtboolean****');
            nestedacessrtboolean = false;
        }
        if(( 
           ('Most likely the solution'.equalsIgnoreCase(selectedDiagRespNested) || 'Not the solution'.equalsIgnoreCase(selectedDiagRespNested))
           && (selectedNestSol.solRec.Diagnostic_notes__c == null || selectedNestSol.solRec.Diagnostic_notes__c == '')) || 
           (selectedNestSol.solRec.Diagnostic_notes__c != null && selectedNestSol.solRec.Diagnostic_notes__c != '' && (selectedDiagRespNested == null || selectedDiagRespNested == ''))){
            nestFailDiagResp=true;
             System.debug('**inside****'+nestFailDiagResp);
        }
        else
            nestFailDiagResp=false;
        System.debug('**outside****'+nestFailDiagResp);
        System.debug('selectedNestSol.solRec.Diagnostic_notes__c'+selectedNestSol.solRec.Diagnostic_notes__c);
              if(selectedNestSol.solRec.Diagnostic_notes__c != '' && selectedNestSol.solRec.Diagnostic_notes__c!=null){
                    remCharcounterNest=4000 - (selectedNestSol.solRec.Diagnostic_notes__c).length() ;
                    system.debug('remCharcounter222'+remCharcounterNest);
                }
           
                else{
                    remCharcounterNest=4000 ; 
                }
        system.debug('remCharcounter222'+remCharcounterNest);
        if(nestFailDiagResp==false && nestedacessrtboolean==false && warningcustomlabel1==false){
            try{
                 solDiagAdd = new List<string>();
                system.debug('selectedDiagRespNested'+selectedDiagRespNested);
                string oldDiagResp = sol1.Diagnostic_Response__c;
                string oldDiagNotes = sol1.Diagnostic_notes__c;
                if(oldDiagResp!=selectedDiagRespNested ||oldDiagNotes!= selectedNestSol.solRec.Diagnostic_notes__c){
                    solDiagAdd.add(JSON.Serialize(new solWrapper(selectedDiagRespNested,selectedNestSol.solRec.Name,selectedNestSol.solRec.Diagnostic_notes__c,rJobOrd.DSID__c)));
                    
                    CSS_EDSActionsUpdate.caseDiagStatusUpdate(solDiagAdd);
                }
                
                
                
                // nestFailDiagResp = nestValidateResponse();
                // if(nestFailDiagResp)
                // return null;
                // Update Nested solutions if any
                if(selectedNestSol != null && selectedNestSol.solRec != null){
                    selectedNestSol.solRec.Service_Job__c = rJobOrd.Id;
                    selectedNestSol.solRec.Diagnostic_Response__c = selectedDiagRespNested;
                    //selectedNestSol.solRec.No_Access_SRT_required__c = srtaccesssrtcheckbox;
                   // selectedNestSol.solRec.Diagnostic_notes__c = diagnestnotes;
                    system.debug('selectedNestSol.solRec.No_Access_SRT_required__c'+selectedNestSol.solRec.No_Access_SRT_required__c);
                    if(selectedDiagRespNested=='Most likely the solution'){
                        partssave(nestedListsrtCompWrapper);
                    }

                    upsert selectedNestSol.solRec;
                    system.debug('output-->'+selectedNestSol.solRec);
                }
               // CSS_Solutions__c sol1 = new CSS_Solutions__c();
               // sol1 = [SELECT Id, Name, Diagnostic_notes__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
                system.debug('Inside UpdateNestSolNotes1');
               /* if(sol1.Diagnostic_notes__c != '' && sol1.Diagnostic_notes__c!=null){
                    remCharcounterNest=4000 - (sol1.Diagnostic_notes__c).length() ;
                    system.debug('remCharcounter222'+remCharcounterNest);
                }*/
                   if(selectedNestSol.solRec.Diagnostic_notes__c != '' && selectedNestSol.solRec.Diagnostic_notes__c!=null){
                    remCharcounterNest=4000 - (selectedNestSol.solRec.Diagnostic_notes__c).length() ;
                    system.debug('remCharcounter222'+remCharcounterNest);
                }
           
                else{
                    remCharcounterNest=4000 ; 
                }
                getUpdatedsolsDets();
               // getNestSolutionDetails();
                JSONSolsGlob =  getRefreshedSols();
               // getUpdatedNestedSols(solDet);
                //Prabhakar added code for story#GSSC-77 scenario1 first time no access checkbox is true and any solution check box enable and disable the link
                if(lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c==true){
                    enablelinkvarable = true;
                    enablechecbox = false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedNestSol.solRec.No_Access_SRT_required__c==false){
                    enablelinkvarable = false;
                    enablechecbox=true;
                }
         //End code for story GSSC-77
            }catch(Exception ex){
                System.debug('Error Line:'+ex.getLineNumber());
                System.debug('Error Message:'+ex.getMessage());
            }    
            //selectedSol = [select Id,FaultCode__r.isPole__c,Out_Of_Order__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c, (select Id,FaultCode__r.isPole__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r) from CSS_Solutions__c where Id = :selectedSol.Id];
            return null;
        }
       return null;
    }
    
    public PageReference prevSolution(){
        CSS_Solutions__c s2 = [select Diagnostic_Response__c,Diagnostic_notes__c from CSS_Solutions__c where id=:selectedSol.id ];
        if(s2.Diagnostic_Response__c=='Most likely the solution' && (selectedSol.Diagnostic_Response__c=='Not the solution' || selectedSol.Diagnostic_Response__c=='Could not perform the solution verification')){
            deletesolCompNparts();
        }
        //saikomal finding nemo 171488
        accesserorboolean = false;
        srtaccesssrtcheckbox=false;
        srtaccesssrtcheckbox1=false;
        warningcustomlabel=false;
        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =: selectedSol.Id];
         //scenario1 first time no access checkbox is true and any solution check box enable and disable the link--Prabhakar added code for GSSC-77
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=true;
                    srtaccesssrtcheckbox=false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=true;
                    warningcustomlabel=false;
                }
                   //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=false;
                }
                  //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=false;
                    warningcustomlabel=true;
                }
        //End code for GSSC-77
        if(((lstSRT != null && lstSRT.size()==0) || selectedSol.No_Access_SRT_required__c!=true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
            accesserorboolean=true;
            // return null;
        }
        else{
             accesserorboolean = false;
        }
        if(((lstSRT != null && lstSRT.size()>0)|| selectedSol.No_Access_SRT_required__c==true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
             accesserorboolean = false;
        }
        //end 
         failDiagResp = validateResponse();
       
        if(accesserorboolean== false && warningcustomlabel==false && failDiagResp==false){
            if(rank != null){
//COmmented below validateResponse method and calling above of the if condition as per Defect #190090,-By RAJESH 1st Aug 2019            
            //failDiagResp = validateResponse();
//End as per Defect #190090,-By RAJESH 1st Aug 2019
               // if(failDiagResp)
                   // return null;
                Id solId = selectedSol.id;
                String solDiagnose = selectedSol.Diagnostic_Response__c;
                String solDiagnoseNotes = selectedSol.Diagnostic_notes__c;
                boolean srtcheckbox = selectedSol.No_Access_SRT_required__c;
                Integer nextRank = Integer.valueOf(rank) -1;
                rank = ''+nextRank;            
                isPopupReq();
                if(!displayOutofOrder || Out_Of_Order_Popup_displayed){
                    // update the prev sol
                    getSolutionDetails();  
                    
                    //Calling SRT parts and saving
                     if(selSolution=='Most likely the solution')
                    partssave(listsrtCompWrapper);
                    
                    updateSol(solId,solDiagnose,solDiagnoseNotes,srtcheckbox);
                    
                    // Begin- Added for refreshing JSON content
                    String soql = 'select Id,Symptom__r.isPole__c,Out_Of_Order__c,Diagnosis_Icon__c,Name,Rank__c,Out_Of_Order_Popup_displayed__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Report_Comments__c,Diagnostic_notes__c, '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                    soql += '(select Id,Nested_Rank__c,FaultCode__r.isPole__c,Symptom__r.isPole__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, CSS_Nested_Solutions__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r order by Nested_Rank__c) '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                    soql += 'from CSS_Solutions__c where Symptom__c = :selectedSymId and CSS_Nested_Solutions__c = null order by Rank__c';    
                    solDetails = DataBase.query(soql);          
                    JSONSolsGlob =  getRefreshedSols();
                    // End- Added for refreshing JSON content
               //Prabhakar added code for story#GSSC-77 scenario1 first time no access checkbox is true and any solution check box enable and disable the link
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=true;
                    srtaccesssrtcheckbox=false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=true;
                }
         //End code for story GSSC-77

                }            
            }
            
            return null;
        }
        else
            return null;
    }  
    // Story 68252 start Modified by Roopa Gadipudi
    public Boolean validateResponse(){
        Boolean valFailed = false;
        if(selectedSol != null && 
           ('Most likely the solution'.equalsIgnoreCase(selectedSol.Diagnostic_Response__c) || 'Not the solution'.equalsIgnoreCase(selectedSol.Diagnostic_Response__c))
           && (selectedSol.Diagnostic_notes__c == null || selectedSol.Diagnostic_notes__c == '')){
               valFailed = true;
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
               ApexPages.addMessage(myMsg);  
               return valFailed;
               
               //  || (selectedSol.Diagnostic_notes__c != null && (selectedSol.Diagnostic_Response__c == null || selectedSol.Diagnostic_Response__c == ''))
               
               
                            
               valFailed = true;
           }else 
               // Story 68252 start Modified by Roopa Gadipudi
               if(selectedSol != null && selectedSol.Diagnostic_notes__c != null && selectedSol.Diagnostic_notes__c != '' && (selectedSol.Diagnostic_Response__c == null || selectedSol.Diagnostic_Response__c == ''))
           {
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
               ApexPages.addMessage(myMsg);               
               valFailed = true;
               return valFailed;
               
           }
           system.debug('valFailed--'+valFailed);
        return valFailed;
    }
    // Story 68252 end Modified by Roopa Gadipudi
    
    public Boolean nestValidateResponse(){
        Boolean nestValFailed = false;
        if(selectedNestSol.solRec != null && 
           ('Most likely the solution'.equalsIgnoreCase(selectedNestSol.solRec.Diagnostic_Response__c) || 'Not the solution'.equalsIgnoreCase(selectedNestSol.solRec.Diagnostic_Response__c))
           && (selectedNestSol.solRec.Diagnostic_notes__c == null || selectedNestSol.solRec.Diagnostic_notes__c == '')){ 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
            ApexPages.addMessage(myMsg);               
            nestValFailed = true;
            return nestValFailed;
            system.debug('insideif>>');
        }
         
            if(selectedNestSol.solRec != null && selectedNestSol.solRec.Diagnostic_notes__c != null && selectedNestSol.solRec.Diagnostic_notes__c != '' && (selectedNestSol.solRec.Diagnostic_Response__c == null || selectedNestSol.solRec.Diagnostic_Response__c == ''))
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
                ApexPages.addMessage(myMsg);               
                nestValFailed = true;
                return nestValFailed;
                 system.debug('insideifelse>>');

            }
        return nestValFailed;
    }

    
    
    //Defect 62657
    public Boolean displayOutofOrder {set;get;}
    public void isPopupReq(){
        system.debug('Inside isPopupFn'+solDetails);
        
        boolean isoutOfOrder = false;
        for(CSS_Solutions__c sols:solDetails){
            system.debug('Inside isPopupFn1'+sols.Rank__c);
            system.debug('Inside isPopupFn2'+selectedSol.Rank__c);
            system.debug('Inside sols'+sols);
            system.debug('Inside selectedSol'+selectedSol);
            system.debug('Inside selectedSolDiaGResp'+sols.Diagnostic_Response__c);
            system.debug('Inside selectedSolDiaGNotes'+sols.Diagnostic_notes__c);
            system.debug('Inside selectedSelectedDiaGNotes'+selectedSol.Diagnostic_Response__c);
            //Defect63117:Modified condition
            if(sols.Rank__c < selectedSol.Rank__c && (selectedSol.Diagnostic_Response__c == null || selectedSol.Diagnostic_Response__c == '')){
                
                system.debug('MSNInside sols'+sols);
                system.debug('MSNsols.Rank__cIS'+sols.Rank__c);
                
                system.debug('MSNselectedSol.Rank__cIS'+selectedSol.Rank__c);
                system.debug('MSNDiagRespPop'+sols.Diagnostic_Response__c);
                
                isoutOfOrder = true;
                system.debug('Inside isPopup1'+isoutOfOrder);
                break;
            }
        }
        
        If(selectedsol.Symptom__r.isPole__c==true && isoutOfOrder==true){            
            displayOutofOrder = true;           
        }
    }
    public boolean Out_Of_Order_Popup_displayed {get;set;}
    public void closeOutofOrder(){
        CSS_Solutions__c solObj =new CSS_Solutions__c();        
        displayOutofOrder = false;
        solObj.Out_Of_Order_Popup_displayed__c = true;
        Out_Of_Order_Popup_displayed = true;
        system.debug('selectedSol.id'+selectedSol.id);
        solObj.Id=selectedSol.id; 
        update solObj;
    }
    public Boolean displayOutofOrd {set;get;} 
    public void closeOutofOrd(){
        displayOutofOrd = false;
    }
    
    public String solutionId {get;set;}
    public String solutionTitle {get;set;}
    public Boolean isSolnExpired {get;set;}
     public void getSolDetailsonPageLoad() {
         getSolutionDetails();
         
     }
    public void getSolutionDetails() {
        //failDiagResp = false;
        //symFCSerError = false;
        srtaccesssrtcheckbox1=false;
        srtaccesssrtcheckbox=false;
        warningcustomlabel=false;
        nestedacessrtboolean=false;
        failDiagResp = false;
        accesserorboolean = false;
        nestFailDiagResp=false;
        string dsidIndic;
        solDet = null;
        solDetails = null;
        selectedNestSol = null;
        inddsid = true;
        isSolnExpired = false;
        reportMessage = false;
        successMessage = '';
        system.debug('nestedacessrtboolean--'+nestedacessrtboolean);
        system.debug('failDiagResp--'+failDiagResp);
        System.debug('Start of getSolution');
        String soql = 'select Id,Symptom__r.id,Symptom__r.isPole__c,Out_Of_Order__c,No_Access_SRT_required__c,Diagnosis_Icon__c,Name,Rank__c,Out_Of_Order_Popup_displayed__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Report_Comments__c,Diagnostic_notes__c, '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
        soql += '(select Id,Nested_Rank__c,FaultCode__r.isPole__c,Symptom__r.isPole__c,No_Access_SRT_required__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, CSS_Nested_Solutions__c, Solution__c, FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r order by Nested_Rank__c) '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
        soql += 'from CSS_Solutions__c where Symptom__c = :selectedSymId and CSS_Nested_Solutions__c = null order by Rank__c';        
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
                    if(sol.rank__c != null && Integer.valueOf(rank) == Integer.valueOf(sol.rank__c)){
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
                }
                System.debug('DSID response is:@@@@@'+rJobOrd.DSID__c);
                string language = 'en';
                HttpResponse res = CSS_EDSAuthentication.getSolutionDetails(solutionId,rJobOrd.DSID__c,aLang.CSS_EDSLanguage__c,lrank,dsidIndic);
                //HttpResponse res = CSS_EDSAuthentication.getSolutionDetails(solutionId, rJobOrd.DSID__C);
                system.debug('res.getStatusCode()'+res.getStatusCode());
                if(res.getStatusCode() == 200){
                    solDetFailed = false;
                    solDet = (CSS_J2ASolution_EDS)JSON.deserializeStrict(res.getBody(),CSS_J2ASolution_EDS.class);
                    System.debug('The soldet is#!#!@'+solDet);
                    solDet.verification = (solDet.verification).replace('<a','<a style="text-decoration: underline"');
                    //Added for defect 121742
                    solDet.verification = (solDet.verification).replace('strong>','b>');
                    //End of Defect 121742
                    addSolComponentsAndVerSols(selectedSol,solDet);
                    getUpdatedNestedSols(solDet);
                    addNestedSolsComponents();
                    solutionId = null;
                    solutionTitle = null;
                }else{
                   // system.debug('entered into91');
                    //symFCSerError = true;//GSSC-91
                    solDet = (CSS_J2ASolution_EDS)JSON.deserializeStrict(res.getBody(),CSS_J2ASolution_EDS.class);
                    //system.debug('solDet.key<><>'+solDet.key);
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
        
        
        
        //wrapper
        
        allRecList = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,option4__c,option2__c,option3__c,
                                                                      Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc),(select name,symptom__c  from CSS_Solutions__r)
                      from CSS_SymptomQA__c where job_order__c=:Ins_JobId and type__c='SearchString' and Id=:selectedSymId];
        
        System.debug('allRecList'+allRecList);
        for(CSS_SymptomQA__c allRecLst:allRecList){               
            sWrapLst =new sStrQASolWrap();
            fList = new List<sStrQASolWrap>();
            if(allRecLst.type__c=='SearchString'){                      
                sWrapLst.sSearch=allRecLst;
            }
            
            if(allRecLst.CSS_SymptomQA__r!=null && !allRecLst.CSS_SymptomQA__r.isEmpty()){                  
                for(integer i=0;i<allRecLst.CSS_SymptomQA__r.size();i++){
                    if(allRecLst.CSS_SymptomQA__r[i].type__c=='QA' && allRecLst.CSS_SymptomQA__r[i].SearchString__c==allRecLst.Id){
                        sWrapLst.sQAWrap.add(allRecLst.CSS_SymptomQA__r[i]);                            
                    }                       
                }
            }
            System.debug('The list is#!@#@sWrapLst!'+sWrapLst);
            if(sWrapLst.sSearch.Id!=null){                  
                fList.add(sWrapLst);
            }
            System.debug('The FLIST IS list is#!@#@!'+fList);
        }
        
        JSONSolsGlob =  getRefreshedSols();
        Out_Of_Order_Popup_displayed = false;
        displayOutofOrder = false;
      // AccessSrtdisableMethod();//Prabhakar
         lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =: selectedSol.Id];
        system.debug('entered into***'+lstSRT.size());
       // CSS_Solutions__c s1 = [select Diagnostic_Response__c,Diagnostic_notes__c from CSS_Solutions__c where id=:selectedSol.id ];
        if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
            srtaccesssrtcheckbox1=true;
            srtaccesssrtcheckbox=false;
        }
        //scenario1 SRT's selected in popup
        if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
            srtaccesssrtcheckbox1=false;
            srtaccesssrtcheckbox=true;
        }
       
    }
    public void addSolComponentsAndVerSols(CSS_Solutions__c sol, CSS_J2ASolution_EDS sDet){
        system.debug('Start of Solution Components');
        //List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>(); //GSSC-156
        if(sDet.components != null) {
            for(CSS_J2ASolution_EDS.Components comp:sDet.components){
                CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c();
                solcmp.Name = comp.value;
                solcmp.Component_Id__c = comp.failureId;
                //solcmp.Action__c = comp.value;
                solcmp.Solutions__c = sol.Id;
                solcmp.Service_Job__c = rJobOrd.Id;
                solcmp.Unique_Component__c = rJobOrd.Id +'-'+sol.Id +'-'+comp.failureId;
                if(failureCodeDetails != null){
                    for(CSS_SRTComponentLookupResponseJ2A.DataArea failComp : failureCodeDetails.DataArea){
                        system.debug('Failure ID-->'+failComp.FailureID);
                        if(comp.failureId == failComp.FailureID){
                            solcmp.Component_Code__c = failComp.ComponentCode;
                            solcmp.Failure_Mode__c = failComp.FailureMode;
                            solcmp.System_Code__c = failComp.SystemCode;
                            break;
                        }                    
                    }
                }
                solCompNew.add(solcmp);
            }
        }
        //List<CSS_Solutions__c> solList = new List<CSS_Solutions__c>(); //GSSC-156
        //System.debug('1selcted SymQAId>>>:'+selectedSol.Symptom__r.id);
        if(sDet.verCompoundSolutions != null){            
            integer i = 0;
            for(CSS_J2ASolution_EDS.verCompoundSolutions  compSol : sDet.verCompoundSolutions){
                i = i + 1;
                //System.debug('2selcted SymQAId>>>:'+selectedSol.Symptom__r.id);
                CSS_Solutions__c presSol = new CSS_Solutions__c();
                System.debug('nestedSolutionsMap>>>:'+nestedSolutionsMap);
                System.debug('Rank>>>:'+selectedSol.Rank__c);
                if(nestedSolutionsMap == null && !nestedSolutionsMap.containsKey(compSol.solutionNumber)){
                    System.debug('entered>>>:'+selectedSol.Symptom__r);
                    presSol.Name = compSol.solutionNumber;
                    presSol.Solution_Title__c = compSol.solutionTitle;
                    presSol.CSS_Nested_Solutions__c = selectedSol.Id;
                    presSol.FaultCode__c = selectedSol.FaultCode__c;
                    presSol.Nested_Rank__c = selectedSol.Rank__c + 1 + '.' + i;
                    if(selectedSol.Symptom__r !=null && selectedSol.Symptom__r.Id !=null ){
                        presSol.Symptom__c = selectedSol.Symptom__r.id;
                        System.debug('selcted SymQAId>>>:'+selectedSol.Symptom__r.id);
                    }
                    solListNew.add(presSol);
                }
            }
        }
        system.debug('solComp--'+solCompNew);
        //Commented as part of the story #GSSC-156
        /*if(solCompNew.size()>0)
            upsert solCompNew Unique_Component__c;
        if(solListNew.size()>0)
            insert solListNew;*/
        System.debug('in addSolComponentsAndVerSols solList>>>:'+solListNew);
        for(CSS_Solutions__c thisSol:solListNew){
            if(nestedSolutionsMap != null && !nestedSolutionsMap.containsKey(thisSol.Name))
                nestedSolutionsMap.put(thisSol.Name,thisSol);
        }
    }
    public void getUpdatedNestedSols(CSS_J2ASolution_EDS sDet){
        system.debug('in getUpdatedNestedSols sDet--'+sDet);
         nestedacessrtboolean=false;
        nestFailDiagResp=false;
        //System.debug('33selcted SymQAId>>>:'+selectedSol.Symptom__r.id);
        List<CSS_Solutions__c> solList = new List<CSS_Solutions__c>();
        nestedSolutionsList = new List<NestedSolutionsClass>();
        system.debug('nestedSolutionsMapOutsideIf-->'+nestedSolutionsMap);
        if(sDet.verCompoundSolutions != null){
            respNestedSolutionsMap =  new map<string,NestedSolutionsClass>();  
            integer i = 0;
            for(CSS_J2ASolution_EDS.verCompoundSolutions  compSol : sDet.verCompoundSolutions){
                i = i + 1;
                System.debug('Rank>>>:'+selectedSol.Rank__c);
                CSS_Solutions__c presSol = new CSS_Solutions__c();
                system.debug('nestedSolutionsMap-->'+nestedSolutionsMap);
                if(nestedSolutionsMap != null && nestedSolutionsMap.size() >0 && nestedSolutionsMap.containsKey(compSol.solutionNumber)){
                    presSol = nestedSolutionsMap.get(compSol.solutionNumber);  
                    //System.debug('40 selcted SymQAId>>>:'+selectedSol.Symptom__r.id);
                }else{
                    presSol.Name = compSol.solutionNumber;
                    presSol.Solution_Title__c = compSol.solutionTitle;
                    presSol.CSS_Nested_Solutions__c = selectedSol.Id;
                    presSol.FaultCode__c = selectedSol.FaultCode__c;
                    presSol.Nested_Rank__c = selectedSol.Rank__c + 1 + '.' + i;
                    system.debug('selectedSol.Symptom__c>>:'+selectedSol.Symptom__c);
                    if(selectedSol.Symptom__r !=null && selectedSol.Symptom__r.Id !=null ){
                        presSol.Symptom__c = selectedSol.Symptom__r.id;
                        System.debug('41selcted SymQAId>>>:'+selectedSol.Symptom__r.id);
                    }
                    presSol.Service_Job__c = rJobOrd.Id;
                    solList.add(presSol);
                }
                NestedSolutionsClass nestSol = new NestedSolutionsClass(compSol,presSol);
                //for story# 75665 start
                if(nestSol.repCompSol != null){
                    nestSol.repCompSol.verification = (nestSol.repCompSol.verification) !=null?(nestSol.repCompSol.verification).replace('<a','<a style="text-decoration: underline"') : (nestSol.repCompSol.verification); 
                        }
                //end
                respNestedSolutionsMap.put(compSol.solutionNumber, nestSol);
                nestedSolutionsList.add(nestSol);
            }
            system.debug('solList-->'+solList);
            
            //GSSC-155 Start
            List<string> lstSolnumbers = new List<string>();
            for (CSS_Solutions__c s : solList){
                lstSolnumbers.add(s.name);
            }
            
            CG_DiagTargetTimeResponse diagTargetTimeResp = new CG_DiagTargetTimeResponse();
            diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,rJobOrd.Equipment_ID__c,rJobOrd.Service_Model__c,rJobOrd.EngineFamilyCode__c,'en'); 

            Map<string, CG_DiagTargetTimeResponse.Solutions> mapSolIdTargetTime = new Map<string, CG_DiagTargetTimeResponse.Solutions>();
            
            system.debug('diagTargetTimeResp--'+diagTargetTimeResp);

            if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
                for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                    mapSolIdTargetTime.put(sol.SolutionId,sol);
                }
            }
            
            for (CSS_Solutions__c sol : solList){
                CG_DiagTargetTimeResponse.Solutions solution = new CG_DiagTargetTimeResponse.Solutions();
    
                solution = mapSolIdTargetTime.get(sol.Name);
                if(solution != null){
                    sol.DiagTargetTime__c = (solution.DiagnosticTargetTime != null && solution.DiagnosticTargetTime != '') ? decimal.valueof(solution.DiagnosticTargetTime) : 0;
                    sol.TargetMessage__c = solution.TargetMessage;  
                }
            }
            if(solList != null && solList.size() > 0)
                insert solList;
            System.debug('in getUpdatedNestedSols solList>>>:'+solList);
        }
        //Added as part of the story #GSSC-156
        if(solCompNew.size()>0)
            upsert solCompNew Unique_Component__c;
        if(solListNew.size()>0)
            insert solListNew;
        //GSSC-155 End
    }
    public void addNestedSolsComponents(){
        system.debug('Start of Nested Sols Components');
        if(nestedSolutionsList != null){
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            for(NestedSolutionsClass wrp:nestedSolutionsList){
                system.debug('solname-->'+wrp.solRec.Name);
                if(wrp.repCompSol.components != null){
                    for(CSS_J2ASolution_EDS.Components comp:wrp.repCompSol.components){
                        CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c();
                        if((comp.value).length()>80){
                            String temp = (comp.value).subString(0,80);
                            solcmp.Name = temp;
                        }
                        else
                            solcmp.Name = comp.value;
                        solcmp.Component_Id__c = comp.failureId;
                        // solcmp.Action__c = comp.value;
                        solcmp.Solutions__c = wrp.solRec.Id;
                        solcmp.Service_Job__c = rJobOrd.Id;
                        solcmp.Unique_Component__c = rJobOrd.Id +'-'+ wrp.solRec.Id+'-'+comp.failureId;
                        if(failureCodeDetails != null){
                            for(CSS_SRTComponentLookupResponseJ2A.DataArea failComp : failureCodeDetails.DataArea){
                                system.debug('Failure ID-->'+failComp.FailureID);
                                if(comp.failureId == failComp.FailureID){
                                    solcmp.Component_Code__c = failComp.ComponentCode;
                                    solcmp.Failure_Mode__c = failComp.FailureMode;
                                    solcmp.System_Code__c = failComp.SystemCode;
                                    break;
                                }                    
                            }
                        }
                        solComp.add(solcmp);
                    }
                }
            }
            if(solComp.size()>0)
                upsert solComp solcmp.Unique_Component__c;            
        }        
        system.debug('End of Nested Sols Components');
    } 
    public PageReference ContinueToRepair(){ 
        CSS_Solutions__c s2 = [select Diagnostic_Response__c,Diagnostic_notes__c from CSS_Solutions__c where id=:selectedSol.id ];
        if(s2.Diagnostic_Response__c=='Most likely the solution' && (selectedSol.Diagnostic_Response__c=='Not the solution' || selectedSol.Diagnostic_Response__c=='Could not perform the solution verification')){
            deletesolCompNparts();
        }
        
        /*  Id solId = selectedSol.id;
String solDiagnose = selectedSol.Diagnostic_Response__c;
String solDiagnoseNotes = selectedSol.Diagnostic_notes__c;
updateSol(solId,solDiagnose,solDiagnoseNotes); */
        //partssave(listsrtCompWrapper);
        
        //saikomal finding nemo 171488
        accesserorboolean = false;
        srtaccesssrtcheckbox=false;
        srtaccesssrtcheckbox1=false;
        warningcustomlabel=false;
        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =: selectedSol.Id];
        
        System.debug('list size ->>'+lstSRT.size());
        System.debug('selectedSol.No_Access_SRT_required__c ->>'+selectedSol.No_Access_SRT_required__c);
        System.debug('selectedSol.Diagnostic_Response__c ->>'+selectedSol.Diagnostic_Response__c);
        //scenario1 first time no access checkbox is true and any solution check box enable and disable the link--Prabhakar added code for GSSC-77
        if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
            srtaccesssrtcheckbox1=true;
            srtaccesssrtcheckbox=false;
        }
        if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
            srtaccesssrtcheckbox1=false;
            srtaccesssrtcheckbox=true;
            warningcustomlabel=false;
        }
        if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==false){
            srtaccesssrtcheckbox1=false;
            srtaccesssrtcheckbox=false;
        }
        if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==true){
            srtaccesssrtcheckbox1=false;
            srtaccesssrtcheckbox=false;
            warningcustomlabel=true;
        }
        //End code for GSSC-77
        
        if(((lstSRT != null && lstSRT.size()==0) || selectedSol.No_Access_SRT_required__c!=true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
            accesserorboolean=true;
            // return null;
        }
     
        else{
            System.debug('**inside else part****');
            accesserorboolean = false;
        }
        
        if(((lstSRT != null && lstSRT.size()>0)|| selectedSol.No_Access_SRT_required__c==true) && (selectedSol.Diagnostic_Response__c=='Not the solution'|| selectedSol.Diagnostic_Response__c=='Most likely the solution')){
            
            System.debug('**inside if2 part****');
            accesserorboolean = false;
        }
        //end 
        failDiagResp = validateResponse();
       /* if(failDiagResp){
            return null;
        }*/
        
        if(accesserorboolean==false && warningcustomlabel==false && failDiagResp==false){
            UpdateSolNotes();
            //UpdateNestedSolNotes();
            
            if (rJobOrd.Status__c !='Repair'){
                css_job_order__c workOrder= new css_job_order__c();
                workOrder.id=rJobOrd.id;
                workOrder.Status__c='Triage & Diagnosis/Repair';
                workOrder.Previous_Status__c=rJobOrd.Status__c;
                update workOrder;
            }
            //Prabhakar added code for story#GSSC-77
                if(lstSRT != null && lstSRT.size()==0 && selectedSol.No_Access_SRT_required__c==true){
                    srtaccesssrtcheckbox1=true;
                    srtaccesssrtcheckbox=false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedSol.No_Access_SRT_required__c==false){
                    srtaccesssrtcheckbox1=false;
                    srtaccesssrtcheckbox=true;
                }
         //End code for story GSSC-77
            PageReference pageref;
            //string redirect='/apex/CSS_JobRepairEDS?id='+Ins_JobId+'&fcid='+selectedFaulcode;    
            string redirect='/apex/CSS_SymRepairPage?id='+Ins_JobId+'&symid='+selectedSymId+'&rank='+rank;    
            pageRef = new PageReference(redirect);
            pageRef.setRedirect(true);
            return pageRef;
        }
        else
            return null;
    }
    public PageReference ContinueToRepairNested(){
        //Prabhakar added for GSSC-120 start
        CSS_Solutions__c solns = new CSS_Solutions__c();
        solns = [SELECT Id,Diagnostic_Response__c, Name, Diagnostic_notes__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
        if(solns.Diagnostic_Response__c=='Most likely the solution' && (selectedDiagRespNested=='Not the solution' || selectedDiagRespNested=='Could not perform the solution verification')){
            deleteNestedSolCompNparts();
        }
        //Prabhakar added for GSSC-120 End
        nestedacessrtboolean=false;
        nestFailDiagResp=false;
        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                  where  Job_order__c=:Ins_JobId and SRT_AccessiblityCheck__c=true and Solution_Number__c =:selectedNestSolId];
        system.debug('lstSRTSize>>>'+lstSRT);
        system.debug('sol1.No_Access_SRT_required__c>>>'+srtaccesssrtcheckbox);
        system.debug('selectedDiagRespNested'+selectedDiagRespNested);
        //
        enablelinkvarable = false;
        warningcustomlabel1 = false;
        enablechecbox=false;
         //scenario1 first time no access checkbox is true and any solution check box enable and disable the link--Prabhakar added code for GSSC-77
                if(lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c==true){
                    enablelinkvarable = true;
                    //srtaccesssrtcheckbox1=true;
                   // srtaccesssrtcheckbox=false;
                    enablechecbox = false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedNestSol.solRec.No_Access_SRT_required__c==false){
                    enablelinkvarable = false;
                    //srtaccesssrtcheckbox1=false;
                    enablechecbox=true;
                   // srtaccesssrtcheckbox=true;
                    warningcustomlabel1=false;
                }
                   //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c==false){
                    enablelinkvarable = false;
                    //srtaccesssrtcheckbox1=false;
                    enablechecbox=false;
                   // srtaccesssrtcheckbox=false;
                }
                  //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedNestSol.solRec.No_Access_SRT_required__c==true){
                    enablelinkvarable = false;
                    enablechecbox=false;
                    warningcustomlabel1=true;
                }
        //End code for GSSC-77
        
        
        
        //
        if((lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c!=true) && (selectedDiagRespNested=='Not the solution'|| selectedDiagRespNested=='Most likely the solution')){
            nestedacessrtboolean = true;
            system.debug('nestedacessrtbooleanif>>>'+nestedacessrtboolean);
            // return null;

        }
        else{
            nestedacessrtboolean = false;
        }
        if(((lstSRT != null && lstSRT.size()>0) || selectedNestSol.solRec.No_Access_SRT_required__c==true) && (selectedDiagRespNested=='Not the solution'|| selectedDiagRespNested=='Most likely the solution')){

            System.debug('**inside nestedacessrtboolean****');
            nestedacessrtboolean = false;
        }
        if(( 
            ('Most likely the solution'.equalsIgnoreCase(selectedDiagRespNested) || 'Not the solution'.equalsIgnoreCase(selectedDiagRespNested))
            && (selectedNestSol.solRec.Diagnostic_notes__c == null || selectedNestSol.solRec.Diagnostic_notes__c == '')) || 
           (selectedNestSol.solRec.Diagnostic_notes__c != null && selectedNestSol.solRec.Diagnostic_notes__c != '' && (selectedDiagRespNested == null || selectedDiagRespNested == ''))){
            nestFailDiagResp=true;
            // return null;
            System.debug('**inside****'+nestFailDiagResp);
        }
        else
            nestFailDiagResp=false;
        System.debug('**outside****'+nestFailDiagResp);
        System.debug('selectedNestSol.solRec.Diagnostic_notes__c'+selectedNestSol.solRec.Diagnostic_notes__c);
        if(selectedNestSol.solRec.Diagnostic_notes__c != '' && selectedNestSol.solRec.Diagnostic_notes__c!=null){
            remCharcounterNest=4000 - (selectedNestSol.solRec.Diagnostic_notes__c).length() ;
            system.debug('remCharcounter222'+remCharcounterNest);
        }

        else{
            remCharcounterNest=4000 ; 
        }
        system.debug('remCharcounter222'+remCharcounterNest);
        if(nestFailDiagResp==false && nestedacessrtboolean==false && warningcustomlabel1==false){
            system.debug('selectedDiagRespNested'+selectedDiagRespNested);
            
            solDiagAdd = new List<string>();
                system.debug('selectedDiagRespNested'+selectedDiagRespNested);
                string oldDiagResp = solns.Diagnostic_Response__c;
                string oldDiagNotes = solns.Diagnostic_notes__c;
                
                if(oldDiagResp!=selectedDiagRespNested ||oldDiagNotes!= selectedNestSol.solRec.Diagnostic_notes__c){
                    solDiagAdd.add(JSON.Serialize(new solWrapper(selectedDiagRespNested,selectedNestSol.solRec.Name,selectedNestSol.solRec.Diagnostic_notes__c,rJobOrd.DSID__c)));
                    CSS_EDSActionsUpdate.caseDiagStatusUpdate(solDiagAdd);
                }
            
            if(selectedNestSol != null && selectedNestSol.solRec != null){
                selectedNestSol.solRec.Service_Job__c = rJobOrd.Id;
                selectedNestSol.solRec.Diagnostic_Response__c = selectedDiagRespNested;
                //selectedNestSol.solRec.No_Access_SRT_required__c = srtaccesssrtcheckbox;
                // selectedNestSol.solRec.Diagnostic_notes__c = diagnestnotes;
                system.debug('selectedNestSol.solRec.No_Access_SRT_required__c'+selectedNestSol.solRec.No_Access_SRT_required__c);
                if(selectedDiagRespNested=='Most likely the solution')
                partssave(nestedListsrtCompWrapper);
                upsert selectedNestSol.solRec;
                system.debug('output-->'+selectedNestSol.solRec);
            }
            CSS_Solutions__c sol1 = new CSS_Solutions__c();
            sol1 = [SELECT Id, Name, Diagnostic_notes__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
            system.debug('Inside UpdateNestSolNotes1');
            if(sol1.Diagnostic_notes__c != '' && sol1.Diagnostic_notes__c!=null){
                remCharcounterNest=4000 - (sol1.Diagnostic_notes__c).length() ;
                system.debug('remCharcounter222'+remCharcounterNest);
            }

            else{
                remCharcounterNest=4000 ; 
            }
            getUpdatedsolsDets();
            //
            //Prabhakar added code for story#GSSC-77 scenario1 first time no access checkbox is true and any solution check box enable and disable the link
                if(lstSRT != null && lstSRT.size()==0 && selectedNestSol.solRec.No_Access_SRT_required__c==true){
                    enablelinkvarable = true;
                    enablechecbox = false;
                }
                 //scenario1 SRT's selected in popup
                if(lstSRT != null && lstSRT.size()>0 && selectedNestSol.solRec.No_Access_SRT_required__c==false){
                    enablelinkvarable = false;
                    enablechecbox=true;
                }
         //End code for story GSSC-77
            
            
            //
            //JSONSolsGlob =  getRefreshedSols();
            //getUpdatedNestedSols(solDet);
            // }

            //end =

            if (rJobOrd.Status__c !='Repair'){
                css_job_order__c workOrder= new css_job_order__c();
                workOrder.id=rJobOrd.id;
                workOrder.Status__c='Triage & Diagnosis/Repair';
                workOrder.Previous_Status__c=rJobOrd.Status__c;
                update workOrder;
            }        
            PageReference pageref;
            //string redirect='/apex/CSS_JobRepairEDS?id='+Ins_JobId+'&fcid='+selectedFaulcode;    
            string redirect='/apex/CG_NestedRepairSolPage?Id='+Ins_JobId+'&fcid='+selectedSymId+'&solid='+selectedNestSol.solRec.CSS_Nested_Solutions__c+'&source=other&Nsolid='+selectedNestSol.solRec.ID;

            pageRef = new PageReference(redirect);
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
    public PageReference returnToFCView(){
        PageReference pageRef;
        string redirect='/apex/CSS_JobTndTs?id='+Ins_JobId;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }     
    public void getUpdatedsolsDets(){
        //Defect 64072
        if (selectedSymId !=''){
            String soql = 'select Id,Symptom__r.id,FaultCode__r.isPole__c,Out_Of_Order__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Report_Comments__c,Diagnostic_notes__c, '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
            soql += '(select Id,Nested_Rank__c,Symptom__r.id,FaultCode__r.isPole__c, DiagTargetTime__c, TargetMessage__c, No_Access_SRT_required__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r order by Nested_Rank__c) '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
            soql += 'from CSS_Solutions__c where Symptom__c = :selectedSymId and CSS_Nested_Solutions__c = null order by Rank__c';        
            solDetails = DataBase.query(soql);
            system.debug('query-->'+soql);
            system.debug('query result-->'+solDetails);
        }  
    }
    
    public pagereference qsolredirect(){
        PageReference pageRef;
        string redirect = qsolRetrivedFCMaster.File_Name__c;
        if(redirect!=null){        
            pageRef = new PageReference(redirect);
            pageRef.setRedirect(true);
            return pageRef;}
        else
            return null;
    }
    
    
    public void refreshPartsList(){
        listsrtCompWrapper= new List<srtCompWrapper>();
    }
    public void refreshPartsListNested(){
        nestedListsrtCompWrapper= new List<srtCompWrapper>();
    }
    //Added for story GSSC-120
    public void deletesolCompNparts(){
        try{
            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            list<CSS_Parts_Options__c> Parts1 = new list<CSS_Parts_Options__c>();
            list<CSS_Parts_Options__c> updatePartselcted = new list<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>();
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> solComp1 = new List<CSS_Solution_Component__c>();
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            solComp = [Select id,Fail_Code__c,(Select id,Service_Job__c,FailurepartId__r.Name from CSS_Parts_Options__r), 
                       Name,Service_Job__c,Selected_Component__c,Solutions__c,SRT_Fetched__c,GetAccountCodeServiceRun__c,Root_Cause__c,
                       Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c,CSS_Account_Formula__c,Fail_Code_Editable__c from 
                       CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : selectedSol.Id and Selected_Component__c=true];

            system.debug('solComp>>>>>'+solComp);
            Parts = [Select id,Fail_Code__c,Account_Code__c,Service_Job__c,selected_part__c,FailureName__c,Solutions__c
                     from CSS_Parts_Options__c 
                     where RecordType.Name = 'Parts' and Solutions__c = :selectedSol.Id and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            system.debug('Parts'+Parts1);
            system.debug('Parts'+Parts1.size());
            system.debug('solComp>>>>>'+solComp.size());
            system.debug('solComp>>>>>'+solComp);
            Parts1 = [Select id,Fail_Code__c,Account_Code__c,Service_Job__c,selected_part__c,FailureName__c
                      from CSS_Parts_Options__c where Fail_Code__c!=null  and Solutions__c=null and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            system.debug('parts1<><>'+Parts1);
            for(CSS_Solution_Component__c slc:solComp){
                if(slc.Selected_Component__c==true){
                    slc.Root_Cause__c = false;
                    slc.Selected_Component__c = false;
                    slc.SRT_Fetched__c = false;
                    slc.GetAccountCodeServiceRun__c = false;
                    
                }
               // slc.GetAccountCodeServiceRun__c = false;
                solComp1.add(slc);
                system.debug('solComp1<><>'+solComp1);
            }
            //
            for(CSS_Parts_Options__c prts:Parts){
                if(prts.selected_part__c==true){
                    prts.selected_part__c = false;
                    

                }
                
                updatePartselcted.add(prts);
                system.debug('updatePartselcted<><>'+updatePartselcted);
            }
            //
            for(CSS_Parts_Options__c prts:Parts1){
                system.debug('prtsfailcode'+prts.Fail_Code__c+'partsaccountcode'+prts.Account_Code__c);
                for(CSS_Solution_Component__c slc:solComp){
                    if((prts.Fail_Code__c !=null && slc.Fail_Code__c!=null && prts.Fail_Code__c.Right(4)==slc.Fail_Code__c) && 
                       (slc.CSS_Account_Formula__c!=null && prts.Account_Code__c !=null && prts.Account_Code__c==slc.CSS_Account_Formula__c)){
                        partsListTemp.add(prts);
                        system.debug('deleteprts'+partsListTemp);
                        system.debug('deleteprts'+partsListTemp.size());

                    }
                    else if(prts.Fail_Code__c !=null && slc.Fail_Code__c!=null && prts.Fail_Code__c.Right(4)==slc.Fail_Code__c){
                        partsListTemp.add(prts);
                        system.debug('elseifdeleteprts'+partsListTemp);
                        system.debug('elseifdeleteprts'+partsListTemp.size());  

                    }
                }

            }
            CSS_SRT__c[] SRTList1 = new List<CSS_SRT__c>();
            if(selSolution=='Could not perform the solution verification'){
                 SRTList1 =[select Id,SRT_AccessiblityCheck__c,SRT_ID__c,Account_Code__c,FailCode__c,AccountCode_Formula__c,Fail_Code_Description__c,Type__c from CSS_SRT__c 
                                                          where 
                                                          Job_Order__c=:rJobOrd.Id and Solution_Number__c=:selectedSol.Id
                                                          and Type__c !='Field Action' and Type__c !='Field Action Access' and Type__c !='CAMPAIGN' 
                                                          and Type__c !='TRP' and Type__c !='ATC'];
                
            }
            else if(selSolution=='Not the solution'){
                   SRTList1 = [select Id,SRT_AccessiblityCheck__c,SRT_ID__c,Account_Code__c,FailCode__c,AccountCode_Formula__c,Fail_Code_Description__c,Type__c from CSS_SRT__c 
                                                          where 
                                                          Job_Order__c=:rJobOrd.Id and Solution_Number__c=:selectedSol.Id
                                                          and Type__c!='Diagnosis' and SRT_Category__c=null and Type__c !='Field Action' and Type__c !='Field Action Access' and Type__c !='CAMPAIGN' 
                                                          and Type__c !='TRP' and Type__c !='ATC'];
                
                
            }
           
            system.debug('SRTList1size'+SRTList1.size());
            system.debug('SRTList1size'+SRTList1);
            List<CSS_SRT__c> deletesrt = new List<CSS_SRT__c>();
            CSS_SRT__c[] SRTList = new List<CSS_SRT__c>([select Id,SRT_AccessiblityCheck__c,SRT_ID__c,Account_Code__c,FailCode__c,AccountCode_Formula__c,Fail_Code_Description__c,Type__c from CSS_SRT__c where FailCode__c !=null  
                                                         and Job_Order__c=:rJobOrd.Id and Solution_Number__c=null
                                                         and Type__c !='Field Action' and Type__c !='Field Action Access' and Type__c !='CAMPAIGN' 
                                                         and Type__c !='TRP' and Type__c !='ATC']);
            MAP<Id,CSS_SRT__c> accMap = new MAP<Id,CSS_SRT__c>();
            for(CSS_SRT__c srt:SRTList){
                for(CSS_Solution_Component__c slc:solComp){
                    if((srt.FailCode__c!=null && slc.Fail_Code__c!=null && srt.FailCode__c.Right(4)==slc.Fail_Code__c) &&
                       (slc.CSS_Account_Formula__c!=null && srt.Account_Code__c !=null && srt.Account_Code__c==slc.CSS_Account_Formula__c)){
                        system.debug('ifsrtsentered');
                        deletesrt.add(srt);

                    }
                    else if(srt.FailCode__c!=null && slc.Fail_Code__c!=null && srt.FailCode__c.Right(4)==slc.Fail_Code__c){
                        system.debug('elsesrtsentered');
                        deletesrt.add(srt);
                    }

                }

            }
            accMap.putAll(deletesrt);
            system.debug('accMap>>>>>'+accMap.size());
            if(accMap != null && accMap.size()>0){
                delete accMap.values();

            }
           // system.debug('Parts>>>>>'+Parts.size());
           // system.debug('Parts>>>>>'+Parts);
           
            if(SRTList1!=null && SRTList1.size()>0){
                delete SRTList1;
            }
            if(updatePartselcted != null && updatePartselcted.size()>0){

                system.debug('updatePartselcted>>>>>'+updatePartselcted);
                update updatePartselcted;

            }
            if(partsListTemp!=null && partsListTemp.size()>0){
                delete partsListTemp;
            }
            system.debug('solComp1'+solComp1);
            if(solComp1.size()>0){
                update solComp1;
            }


        }
        catch(Exception e){
            System.debug('exception in DeleteSolRecord function '+e.getMessage() + ' ' + e.getLineNumber());
        }


    }
    public void deleteNestedSolCompNparts(){
        try{
           // nestedListsrtCompWrapper = new List<srtCompWrapper>();
            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            list<CSS_Parts_Options__c> Parts1 = new list<CSS_Parts_Options__c>();
            list<CSS_Parts_Options__c> updatePartselcted = new list<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>();
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> solComp1 = new List<CSS_Solution_Component__c>();
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            solComp = [Select id,Fail_Code__c,(Select id,FailurepartId__r.Name from CSS_Parts_Options__r), 
                       Name,Service_Job__c,Selected_Component__c,Solutions__c,SRT_Fetched__c,GetAccountCodeServiceRun__c,Root_Cause__c,
                       Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c,CSS_Account_Formula__c,Fail_Code_Editable__c from 
                       CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = :selectedNestSolId and Selected_Component__c=true];		
            system.debug('selectedNestSolId>>>>>'+selectedNestSolId);
            system.debug('solComp>>>>>'+solComp);
            Parts = [Select id,Fail_Code__c,Account_Code__c,Service_Job__c,selected_part__c,FailureName__c
                     from CSS_Parts_Options__c 
                     where RecordType.Name = 'Parts' and Solutions__c = :selectedNestSolId and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            system.debug('solComp>>>>>'+solComp.size());
            system.debug('solComp>>>>>'+solComp);
            Parts1 = [Select id,Fail_Code__c,Account_Code__c,Service_Job__c,selected_part__c,FailureName__c from CSS_Parts_Options__c 
                      where Fail_Code__c!=null  and Solutions__c=null and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            system.debug('parts1<><>'+Parts1);
            for(CSS_Solution_Component__c slc:solComp){
                if(slc.Selected_Component__c==true){
                    slc.Root_Cause__c = false;
                    slc.Selected_Component__c = false;
                    slc.SRT_Fetched__c = false;
                    slc.GetAccountCodeServiceRun__c = false;
                }
                solComp1.add(slc);
            }
            //
            for(CSS_Parts_Options__c prts:Parts){
                if(prts.selected_part__c==true){
                    prts.selected_part__c = false;
                }
                updatePartselcted.add(prts);
                system.debug('updatePartselctednested<><>'+updatePartselcted);
            }
            //
            for(CSS_Parts_Options__c prts:Parts1){
                system.debug('prtsfailcode'+prts.Fail_Code__c+'partsaccountcode'+prts.Account_Code__c);
                for(CSS_Solution_Component__c slc:solComp){
                    if((prts.Fail_Code__c !=null && slc.Fail_Code__c!=null && prts.Fail_Code__c.Right(4)==slc.Fail_Code__c) &&
                       (slc.CSS_Account_Formula__c!=null && prts.Account_Code__c !=null && prts.Account_Code__c==slc.CSS_Account_Formula__c)){
                        partsListTemp.add(prts);
                        system.debug('deleteprts'+partsListTemp);
                        system.debug('deleteprts'+partsListTemp.size());

                    }
                    else if(prts.Fail_Code__c !=null && slc.Fail_Code__c!=null && prts.Fail_Code__c.Right(4)==slc.Fail_Code__c){
                        partsListTemp.add(prts);
                        system.debug('elseifdeleteprts'+partsListTemp);
                        system.debug('elseifdeleteprts'+partsListTemp.size());
                    
                    }
                }

            }
            system.debug('selectedNestSolTitle1 <><>'+selectedNestSolTitle1 );
            system.debug('selectedNestSolId<><>'+selectedNestSolId);
            CSS_SRT__c[] SRTList1 = new List<CSS_SRT__c>();
            if(selectedNestSolTitle1 =='Could not perform the solution verification'){
                 SRTList1 = [select Id,SRT_AccessiblityCheck__c,SRT_ID__c,FailCode__c,Account_Code__c,Solution_Number__c,AccountCode_Formula__c,Fail_Code_Description__c,Type__c from CSS_SRT__c where 
                                                          Job_Order__c=:rJobOrd.Id and Solution_Number__c=:selectedNestSolId
                                                          and Type__c !='Field Action' and Type__c !='Field Action Access' and Type__c !='CAMPAIGN' 
                                                          and Type__c !='TRP' and Type__c !='ATC'];
                
                
            }
            else if(selectedNestSolTitle1 =='Not the solution'){
            SRTList1 = [select Id,SRT_AccessiblityCheck__c,SRT_ID__c,FailCode__c,Account_Code__c,Solution_Number__c,AccountCode_Formula__c,Fail_Code_Description__c,Type__c from CSS_SRT__c where 
                                                          Job_Order__c=:rJobOrd.Id and Solution_Number__c=:selectedNestSolId
                                                          and Type__c!='Diagnosis' and SRT_Category__c=null and Type__c !='Field Action' and Type__c !='Field Action Access' and Type__c !='CAMPAIGN' 
                                                          and Type__c !='TRP' and Type__c !='ATC'];
                
                
            }
           
            system.debug('SRTList1size'+SRTList1.size());
            system.debug('SRTList1size'+SRTList1);
            List<CSS_SRT__c> deletesrt = new List<CSS_SRT__c>();
            CSS_SRT__c[] SRTList = new List<CSS_SRT__c>([select Id,SRT_AccessiblityCheck__c,Account_Code__c,SRT_ID__c,Solution_Number__c,FailCode__c,AccountCode_Formula__c,Fail_Code_Description__c,Type__c from CSS_SRT__c where FailCode__c !=null  
                                                         and Job_Order__c=:rJobOrd.Id and  Solution_Number__c=null
                                                         and Type__c !='Field Action' and Type__c !='Field Action Access' and Type__c !='CAMPAIGN' 
                                                         and Type__c !='TRP' and Type__c !='ATC']);
            MAP<Id,CSS_SRT__c> accMap = new MAP<Id,CSS_SRT__c>();
            for(CSS_SRT__c srt:SRTList){
                for(CSS_Solution_Component__c slc:solComp){
                    if((srt.FailCode__c!=null && slc.Fail_Code__c!=null && srt.FailCode__c.Right(4)==slc.Fail_Code__c) && 
                    (slc.CSS_Account_Formula__c!=null && srt.Account_Code__c !=null && srt.Account_Code__c==slc.CSS_Account_Formula__c)){
                        system.debug('ifdeletesrts'+partsListTemp);
                        deletesrt.add(srt);

                    }
                    else if(srt.FailCode__c!=null && slc.Fail_Code__c!=null && srt.FailCode__c.Right(4)==slc.Fail_Code__c){
                        deletesrt.add(srt);
                        system.debug('elseifdeletesrts'+partsListTemp);
                        system.debug('elseifdeletesrts'+partsListTemp.size());

                    }

                }

            }
            accMap.putAll(deletesrt);
            system.debug('accMap>>>>>'+accMap.size());
            if(accMap != null && accMap.size()>0){
                delete accMap.values();
            }
            if(SRTList1!=null && SRTList1.size()>0){
                delete SRTList1;
            }
            system.debug('Parts>>>>>'+Parts.size());
            system.debug('Parts>>>>>'+Parts);
            if(updatePartselcted != null && updatePartselcted.size()>0){
                system.debug('nestedupdatepart>>>>>'+updatePartselcted);
                update updatePartselcted;
            }
            if(partsListTemp!=null && partsListTemp.size()>0)
                delete partsListTemp;
            system.debug('solComp1'+solComp1);
            if(solComp1.size()>0){
               update solComp1;
            }
           // getPartsListCompSol(selectedNestSolId);
           // partssave(nestedListsrtCompWrapper);

           // UpdateNestedSolNotes();
            
            

        }
        catch(Exception e){
            System.debug('exception in DeleteSolRecord function '+e.getMessage() + ' ' + e.getLineNumber());
        }

    }

    
    
    // Method to get Parts list (Story# 103855 Start)
    
    public void getPartsList(){
        try{
            listsrtCompWrapper= new List<srtCompWrapper>();
            system.debug('Anirudh in get parts list listsrtCompWrapper>>>>>>>>>>>>>>>'+listsrtCompWrapper);
            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            System.debug('testing debug');
            System.debug('inside the method parts METHOD...Selected Sol Id>>>'+selectedSol.Id);
            //  if(Wid != null){
            //code for parts webservice invokation - Start.
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            // solComp = [Select Id,Component_Id__c,Service_Job__c,Solutions__c from CSS_Solution_Component__c where Service_Job__c = : Ins_JobId and Solutions__c = : selectedSol.Id];
            system.debug('selectedSol.Id--'+selectedSol.Id);
            system.debug('selectedNestSolId--'+selectedNestSolId);
            //solComp = [Select id,(Select id,Option_Number__c,Replacement_Reason__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r), Name,Component_Id__c,Service_Job__c,Selected_Component__c,Solutions__c,Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c,CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,CoveredTravelMiles__c,Fail_Code_Editable__c from CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : selectedSol.Id];
            solComp = [Select id,(Select id,Option_Number__c,Replacement_Reason__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r), Name,Component_Id__c,Service_Job__c,Selected_Component__c,Solutions__c,Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c,CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,CoveredTravelMiles__c,Fail_Code_Editable__c from CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : selectedSol.Id];
            
            system.debug('solComp>>>>>'+solComp);
            Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : selectedSol.Id and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            
            if(Parts.size()==0 || Parts.isempty()){
                system.debug('Entered if parts size is empty');
                CSS_FN_SRT.srtPartsService(solComp,rJobOrd,recTypeIdpart);
                Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : selectedSol.Id and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
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
                    List<srtPartWrapper> setsrtPartWrapper  = new List<srtPartWrapper>(); 
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
                                setsrtPartWrapper.add(new srtPartWrapper(p.id,p.FailurepartId__c,p.selected_part__c,p.Part_Name__c,integer.valueof(p.Quantity__c),integer.valueof(p.Default_Part_Quantity__c),p.Replacement_Reason__c)); 
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
  
    
   // public void getPartsListCompSol(Id nestedSolId){
        public void getPartsListCompSol(){
        try{
            system.debug('inside getPartsListCompSol');
            system.debug('inside selectedNestSolId'+selectedNestSolId);
            nestedListsrtCompWrapper = new List<srtCompWrapper>();
            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            solComp = [Select id,(Select id,Option_Number__c,Replacement_Reason__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r), Name,Component_Id__c,Service_Job__c,Selected_Component__c,Solutions__c,Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c,CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,CoveredTravelMiles__c,Fail_Code_Editable__c from CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : selectedNestSolId];
            Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : selectedNestSolId and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            if(Parts.size()==0 || Parts.isempty()){
                system.debug('Entered if parts size is empty');
                CSS_FN_SRT.srtPartsService(solComp,rJobOrd,recTypeIdpart);
                Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : selectedNestSolId and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            }
            //code for parts webservice invokation - End. 
            //if(servicejob.CSS_Parts_Options__r != null){
            Set<CSS_Solution_Component__c> setcomp = new  Set<CSS_Solution_Component__c>();
            lstComp = new list<CSS_Solution_Component__c>();
            
            //for(CSS_Parts_Options__c z: servicejob.CSS_Parts_Options__r){comp
            system.debug('Parts>>>'+Parts);
            if(solComp.size()>0){
                for(CSS_Solution_Component__c z: solComp){
                    //setcomp.add(z);
                    List<srtPartWrapper> setsrtPartWrapper  = new List<srtPartWrapper>(); 
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
                                setsrtPartWrapper.add(new srtPartWrapper(p.id,p.FailurepartId__c,p.selected_part__c,p.Part_Name__c,integer.valueof(p.Quantity__c),integer.valueof(p.Default_Part_Quantity__c),p.Replacement_Reason__c)); 
                                lstChildIds.add(p.id);
                                system.debug('setsrtPartWrapper Anirudh>>>'+setsrtPartWrapper);
                                system.debug('setsrtPartWrapper Anirudh>>>'+setsrtPartWrapper.size());
                            }
                        }
                        if(setsrtPartWrapper.size()>0 && !setsrtPartWrapper.isempty()){
                            listsrtPartWrapper.addAll(setsrtPartWrapper);
                            system.debug('nestedListsrtCompWrapper>>>>>>>'+nestedListsrtCompWrapper);
                            nestedListsrtCompWrapper.add(new srtCompWrapper(z.id,z.Selected_Component__c,z.Name,lstChildIds,listsrtPartWrapper,z.solutions__r.FaultCode__c,z.System_Code__c,z.Component_Code__c,z.AccountCode__c)); 
                            system.debug('nestedListsrtCompWrapper>>>>>>'+nestedListsrtCompWrapper);
                        }
                    }
                    if(setsrtPartWrapper.size()==0){
                        nestedListsrtCompWrapper.add(new srtCompWrapper(z.id,z.Selected_Component__c,z.Name,null,null,z.solutions__r.FaultCode__c,z.System_Code__c,z.Component_Code__c,z.AccountCode__c)); 
                    }
                }
            }
        } catch(exception e){
            system.debug('Entered in exception block of getPartslist method>>>>'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }
    
    
    public void partssave(List<srtCompWrapper> lstToUpdate){
        try{
            List<CSS_Solution_Component__c> complst = new List<CSS_Solution_Component__c>();
            List<CSS_Parts_Options__c> partslst = new List<CSS_Parts_Options__c>();
            
            system.debug('input list>>>>>>>>>>>>>>>>'+lstToUpdate+'Solution--'+selSolution);
              system.debug('input list>>>>>>>>>>>>>>>>'+lstToUpdate+'Solutionkkkkk--'+selSolution);
            if(lstToUpdate != null && lstToUpdate.size()>0){
                if((selSolution!='' && selSolution == 'Most likely the solution') || 
                   (selectedNestSolTitle1!='' && selectedNestSolTitle1 == 'Most likely the solution')){
                    system.debug('Inside Save IF');
                       for(srtCompWrapper s: lstToUpdate){
                           CSS_Solution_Component__c solComp = new CSS_Solution_Component__c(Id = s.CompIds,Selected_Component__c = s.compParentCheckbox);
                           system.debug('solComp'+solComp);
                           complst.add(solComp);
                           if(s.partWrapper != null){
                               for(srtPartWrapper y: s.partWrapper){
                                   system.debug('y.partChildCheckbox'+y.partChildCheckbox);
                                   //CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,FailurepartId__c=y.compParentId,selected_part__c = y.partChildCheckbox,Replacement_Reason__c= (y.partChildCheckbox == true ? y.replacementReason :''),Quantity__c=y.qty);
                                    CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,FailurepartId__c=y.compParentId,selected_part__c = y.partChildCheckbox,Replacement_Reason__c= y.replacementReason,Quantity__c=y.qty);
                                  /* if(y.partChildCheckbox == false){ 
                                       partComp.Replacement_Reason__c = 'GSQ Part';
                                   }*/
                                    
                                   partslst.add(partComp);
                               }
                           }
                       }
                   }
                else{
                    system.debug('Inside Save ELSE');
                    for(srtCompWrapper s: lstToUpdate){
                        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c(Id = s.CompIds,Selected_Component__c = false);
                        complst.add(solComp);
                        if(s.partWrapper != null){
                            for(srtPartWrapper y: s.partWrapper){
                                CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,FailurepartId__c=y.compParentId,selected_part__c = false,Replacement_Reason__c= '',Quantity__c=y.defaultQty);
                               /* if(y.partChildCheckbox == false && (y.replacementReason=='' || y.replacementReason=='Select One')){ 
                                    partComp.Replacement_Reason__c = 'GSQ Part';
                                }*/
                                partslst.add(partComp);
                            }
                        }
                    }
                }
            }
            
            
            /*if(lstToUpdate != null && lstToUpdate.size()>0){
                if(sol1.Diagnostic_Response__c=='Most likely the solution' && (selectedDiagRespNested=='Not the solution' || selectedDiagRespNested=='Could not perform the solution verification')){
                    //deleteNestedSolCompNparts();
                    List<srtPartWrapper> setsrtPartWrapper  = new List<srtPartWrapper>(); 
                    listsrtPartWrapper= new List<srtPartWrapper>();

                    for(srtCompWrapper s: nestedListsrtCompWrapper){
                        for(srtPartWrapper y: s.partWrapper){
                            setsrtPartWrapper.add(new srtPartWrapper(y.partIds,y.compParentId,false,y.partName,y.qty,y.defaultQty,y.replacementReason)); 
                        }
                        if(setsrtPartWrapper.size()>0 && !setsrtPartWrapper.isempty()){
                            listsrtPartWrapper.addAll(setsrtPartWrapper);
                        }
                        nestedListsrtCompWrapper.add(new srtCompWrapper(s.CompIds,false,s.compName,s.childIds,listsrtPartWrapper,s.faultCode,s.systemCode,s.compCode,s.accountCode)); 
                    }
                    //partssave(nestedListsrtCompWrapper);

                }
                system.debug('nestedListsrtCompWrapper--Before Save'+nestedListsrtCompWrapper);
            }*/

            
            
            
            Integer num=0;
            List<srtCompWrapper> fireLst = new List<srtCompWrapper>();
            for(srtCompWrapper wrap : lstToUpdate){
                num++;
                if(num==10){
                    String temp = JSON.serialize(fireLst);
                    //calling Get Warranty determination web service
                    //Included mileage fields instead of Failure point Defect# 119170  - Mileage__c, Mileage_Measure__c    
                    if(rJobOrd.ApplicationCode__c=='130' || rJobOrd.ApplicationCode__c=='210' || rJobOrd.ApplicationCode__c=='220' || rJobOrd.ApplicationCode__c=='310' || rJobOrd.ApplicationCode__c=='320' || rJobOrd.ApplicationCode__c=='410' )
                        getAccountCodes(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,temp, rJobOrd.ReconEngineFlag__c,rJobOrd.Name);
                    else
                        getAccountCodes(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.CSS_Hours__c),'Hours',rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,temp, rJobOrd.ReconEngineFlag__c,rJobOrd.Name);
                    //getAccountCodes(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,temp, rJobOrd.ReconEngineFlag__c);
                    fireLst = new List<srtCompWrapper>();
                    num=0;
                }
                fireLst.add(wrap);
            }
            
            if(num<10){
                String temp = JSON.serialize(fireLst);
                //calling Get Warranty determination web service
                //Included mileage fields instead of Failure point Defect# 119170  - Mileage__c, Mileage_Measure__c
                getAccountCodes(rJobOrd.ESN__c,(rJobOrd.Creator_Location__c).right(5),rJobOrd.Failure_Date__c,string.valueof(rJobOrd.Mileage__c),rJobOrd.Mileage_Measure__c,rJobOrd.ApplicationCode__c,rJobOrd.Warranty_Start_Date__c,temp, rJobOrd.ReconEngineFlag__c,rJobOrd.Name);
                fireLst = new List<srtCompWrapper>();
                num=0;
            }
            system.debug('complst-->'+complst);
            system.debug('partslst-->'+partslst);
            if(complst.size()>0){
                update complst;
                if(partslst.size()>0)
                    update partslst;
            }
        }catch(exception e){
            system.debug('inside partssave exception -->'+ e.getmessage() + e.getLineNumber());
        }
    }
    
    @future(callout=true)
    public static void getAccountCodes(string PSN, string spCode, date failureDate, string failurePoint, string failureMeasure, string engAppCode, date warrStartDt, string temp, string reconFlag, string Name){
        List<srtCompWrapper> srtCompWrapper_lst = new List<srtCompWrapper>();
        srtCompWrapper_lst = (List<srtCompWrapper>)JSON.deserializeStrict(temp,List<srtCompWrapper>.class);
        List<CSS_Solution_Component__c> compListUpd = new List<CSS_Solution_Component__c>();
        for(srtCompWrapper compWrap:srtCompWrapper_lst){
            CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
            if((compWrap.accountCode == null || compWrap.accountCode =='') &&(compWrap.compParentCheckbox==true)){
                comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(PSN,spCode,failureDate,failurePoint,failureMeasure,engAppCode,warrStartDt,compWrap.systemCode,compWrap.compCode,compWrap.faultCode,compWrap.accountCode,compWrap.CompIds,compWrap.compParentCheckbox,'','','First Call', reconFlag, false, Name); //Kalpana Story#117207 added 'First Call' Param
                if(comp != null)
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
    public CSS_SRTComponentLookupResponseJ2A getSRTComponentOnLoad() {
        try{
            String smn_engFamCode = rJobOrd.Service_Model__c + ';;' + rJobOrd.Qsol_Engine_Family_Code__c;
            system.debug('123'+smn_engFamCode);
            CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();
            jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Key__c, Reason__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engFamCode AND Key__c = 'GetFailureCodesSRT' ORDER BY CreatedDate DESC LIMIT 1];
            system.debug('456'+jobEventTemp);
            CSS_SRTComponentLookupResponseJ2A response;
            response = (CSS_SRTComponentLookupResponseJ2A)JSON.deserialize(jobEventTemp.Reason__c,CSS_SRTComponentLookupResponseJ2A.class);
            return response;
        }
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage());
            return null;
        }
        
    }
}