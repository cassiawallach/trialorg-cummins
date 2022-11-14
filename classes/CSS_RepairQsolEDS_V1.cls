public class CSS_RepairQsolEDS_V1 {

    public boolean ErrorMessage {get; set;} 
    //added for part table
    public List<srtCompWrapper> listsrtCompWrapper {get;set;} 
    public List<srtCompWrapper> nestedListsrtCompWrapper {get;set;}
    public List<srtPartWrapper> listsrtPartWrapper {get;set;} 
    public list<CSS_Solution_Component__c> lstComp{get;set;} 
    public list<CSS_Solution_Component__c> comp{get; set;}
    public Id recTypeIdpart {get; set;}
    public Integer remCharcounter{set;get;}
    public Integer remCharcounterNest{set;get;}
    public static Boolean symFCSerError{get;set;}
    
    //end
    //defetct 103764
    public string solidCorrectStylClass{get;set;}
    public string correctplusStylClass{get;set;}
    public string solidWrongStylClass{get;set;}
    public string solidQtnStylClass{get;set;}
    public CSS_SRTComponentLookupResponseJ2A failureCodeDetails{get; set;}
    //103764 end
    
    public Boolean isClaimEnabledDealer{get;set;} //GSSC-453
    
    public CSS_RepairQsolEDS_V1(css_repair_job controller) {
        //defetct 103764
        solidCorrectStylClass ='<i class="cmi-icon icon-solidCorrect"></i>';
        correctplusStylClass = '<i class="cmi-icon icon-correctplus"></i>';
        solidWrongStylClass = '<i class="cmi-icon icon-solidWrong"></i>';
        solidQtnStylClass ='<i class="cmi-icon icon-solidQtn"></i>';
        //defetct 103764 end
        u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
        aLang = css_utility.getLanguage(u3.LanguageLocaleKey);
        x = new css_tnd_job();
        selectOptionsList = new list<string>();
        selectOptionsList.add('Option1');
        selectOptionsList.add('Option2');
        selectOptionsList.add('Option3');
        selectOptionsList.add('Option4');
        selectOptionsList.add('Option5');
        selectOptionsList.add('Option6');
        //  Components = [Select Name,Action__c,Solutions__c,Quantity__c,Service_Job__c from CSS_Solution_Component__c where Service_Job__c=:Ins_JobId];
        isfaultCodeView = true;
        solDetFailed = false;
        FeedBackVal = '';
        selectedFaulcodeId = ApexPages.CurrentPage().getParameters().get('fcid');
        rankFromTs = ApexPages.CurrentPage().getParameters().get('rank');
        system.debug('Comcastfireeye'+rankFromTs );
        if(rankFromTs != null){
            // rankFromTs = string.valueOf(Integer.valueOf(rankFromTs));
            rank = rankFromTs;
        } 
        else {
            rank = string.valueOf(Integer.valueOf(0));


        }

        /*   rankFromTs1 = ApexPages.CurrentPage().getParameters().get('rank');
system.debug('Comcastfireeye'+rankFromTs1 );
if(rankFromTs1 != null){
// rankFromTs = string.valueOf(Integer.valueOf(rankFromTs));
rank1 = rankFromTs1;
}*/

        system.debug('***rank COnstr--->'+rank);
        Ins_JobId = ApexPages.CurrentPage().getParameters().get('Id'); 
        system.debug('***rank COnstr middle--->'+rank); 
        try{
            // added Mileage__c, Mileage_Measure__c, - Satish defect# 119170
            rJobOrd =[Select Id,Name, Service_Model__c, ReconEngineFlag__c, ESN__c,ESN_Insite__c,DSID__c, EngineFamilyCode__c, DSID_WorkGroup__c,INSITE_UpdateTimeStamp__c,Status__c,Previous_Status__c,INSITE_ESN_Choice__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Mileage__c, Mileage_Measure__c,Failure_Date__c,Failure_Point__c,Failure_Point_Measure__c,Warranty_Start_Date__c,CSS_Job_Location_Code__c,ApplicationCode__c,Creator_Location__c from CSS_Job_Order__c where id= :Ins_JobId];
            // Story - 65995 DS Read Only - start
            if(rJobOrd.DSID__C != null){
                dsidind =  css_utility.getDSIDEditIndicator(userinfo.getUserId(),rJobOrd.DSID__C,rJobOrd.DSID_WorkGroup__c); 

                if( dsidind != null && (dsidind.containsIgnoreCase('N') || dsidind.containsIgnoreCase('G')))
                    inddsid = false;

            }
            // Story - 65995 DS Read Only - end

            system.debug('***rank COnstr*****--->'+rank);
            JSONSolsGlob =  getSols();
            system.debug('***rank COnstr2--->'+rank);
            System.debug('After:' + JSONSolsGlob);
        }catch(Exception ex){
            system.debug('***rank COnstr4--->'+rank);
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());            
        }
        system.debug('***rank COnstr5--->'+rank);
        if(selectedFaulcodeId != null){
            system.debug('***rank COnstr6--->'+rank);
            faultCodeClick();
            system.debug('***rank COnstr7--->'+rank);
            // rank = rankFromTs;
        }
        system.debug('***rank COnstr8--->'+rank);
        /*   if(rankFromTs != null){
rankFromTs = string.valueOf(Integer.valueOf(rankFromTs));
rank = rankFromTs;
} */
        // rank = rankFromTs;
        system.debug('***rank COnstr End--->'+rank);
        failureCodeDetails = getSRTComponentOnLoad();
        system.debug('output wrapper-->'+failureCodeDetails); 
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

    //QSOL Docs
    public user userlang{get; set;}
    public CSS_accountLanguage__c accountlang{get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}
    public css_tnd_job x; 
    public integer Camps{get;set;}
    public integer Trps{get;set;}
    public integer Tsbs{get;set;}
    public integer Atcs{get;set;}

   /* public void getQSOLDocs() {



        string sQSOLConn;
        //Get Campaign Information from QSOL based on ESN
        CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc rQSOLDocs = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
        if(!Test.isRunningTest()){        
            sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;                    
        }
        else{
            sQSOLConn = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
        }
        List<CSS_quickserveCumminsComWebservices.WarrantyDoc> wCAMTSBTRB = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>();
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();                                    
        lstCAM = new List<CSS_CampTsbTrp__c>();
        system.debug('checking user lang'+accountlang.CSS_QsolLanguage__c);
        SYSTEM.debug('tHE CONNE IS'+sQSOLConn + rJobOrd.ESN__c + accountlang.CSS_QsolLanguage__c);            
        rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,rJobOrd.ESN__c,'CAM',accountlang.CSS_QsolLanguage__c);
        system.debug('inside user lang'+accountlang.CSS_QsolLanguage__c);
        system.debug('response of qsol'+rQSOLDocs);
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
                    //String s1 = string.valueof(wCAMTSBTRB[i].url);
system.debug('**s1**'+s1);
ctt1.URL__c = s1.substringBeforeLast('/');  
ctt1.Cu_Language__c = 'en'; 
ctt1.File_Name__c = s1.substringAfterLast('/');

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
        Camps = x.getCamps();
        Trps = x.getTrps();
        Tsbs = x.getTsbs();
        Atcs = x.getAtcs();
        //End All CAM,ATC, TSB & TRB
        system.debug('Value of LIST=='+ lstTRP);


    }*/
    //QSOL End
     public void getQSOLDocs() {
        try{
            lstCAM =lstTRP =lstTSB=lstATC= new List<CSS_CampTsbTrp__c>();
            map<string,List<CSS_CampTsbTrp__c>>  camprecs =CG_SL_QSOL.getQSOLMapWarrantyDocs(rJobOrd.Id,null,rJobOrd.ESN__c,accountlang.CSS_QsolLanguage__c,new list<string>{'CAMPAIGN','TSB','ATC','TRP'});
            for(string key :camprecs.keySet()){
                switch on key{
                    when 'CAM'{
                        if(camprecs.containskey(key))  lstCAM.addall(camprecs.get(key));  
                    }when 'TRP'{
                        if(camprecs.containskey(key))  lstTRP.addall(camprecs.get(key));
                    }when 'TSB'{
                        if(camprecs.containskey(key))  lstTSB.addall(camprecs.get(key));
                    }when 'ATC'{
                        if(camprecs.containskey(key))  lstATC.addall(camprecs.get(key));
                    }
                }
            }
            Camps = x.getCamps();
            Trps = x.getTrps();
            Tsbs = x.getTsbs();
            Atcs = x.getAtcs();
        }catch(exception e){
            System.debug('The exception is'+e.getMessage()+' '+e.getLineNumber()); 
        }
        
    }


    public string getSols() {
        String sJobId = ApexPages.CurrentPage().getParameters().get('Id'); 
        //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156 in below query
        List<CSS_Solutions__c> lstSolutions = new List<CSS_Solutions__c>([Select Id,Name, Case_Name__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Service_Job__c, Rank__c,
                                                                          Diagnostic_notes__c, Diagnostic_Response__c, FaultCode__c,
                                                                          Repair_Response__c,Repair_notes__c
                                                                          from CSS_Solutions__c where FaultCode__c = :selectedFaulcodeId 
                                                                          order by Rank__c]);
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        Integer iCounter = 0;
        string diagTargetResp; //Story GSSC-156
        Boolean blnActive = false;
        for (CSS_Solutions__c recSol: lstSolutions )
        {
            iCounter = iCounter + 1;
            if((recSol.Repair_Response__c == null) || (recSol.Repair_Response__c == '')){sStat = '0';}
            if (recSol.Repair_Response__c== 'Repair Successful.') { sStat = '1' ; }
            else if (recSol.Repair_Response__c== 'Repair Successful with additional parts/procedures.') { sStat = '2' ; }
            else if (recSol.Repair_Response__c== 'Repair performed but didnot resolve the root cause.') { sStat = '3' ; }
            else if (recSol.Repair_Response__c== 'Repair not performed.') { sStat = '4' ; }
            if (lstSolutions.size() > 1 && iCounter != lstSolutions.size()) { sSuffix = ', ';}
            else { sSuffix = ' ';}
            if (rank != null){rank = rankFromTs;} 
            else { rank = string.valueOf(Integer.valueOf(0));}
            if (Integer.valueOf(rank) == recSol.Rank__c) { blnActive = true; } else { blnActive = false; }
            
            //Added below for story GSSC-156
            diagTargetResp = (recSol.DiagTargetTime__c != null && recSol.DiagTargetTime__c != 0.0) ? (string.valueof(recSol.DiagTargetTime__c) +' '+ 'Hours') : (recSol.TargetMessage__c != null ? recSol.TargetMessage__c : '' );
            
            //Added diagTT attribute in below JSON for story GSSC-156
            JSONSols  = JSONSols + '{ "id" : "' + recSol.Id + '" , "CaseName" : "' + recSol.Name + '" , "diagTT" : "' + diagTargetResp + '", "CaseTitle" : "' + recSol.Solution_Title__c + '" , "casestatus" : "' + sStat + '" , "sRank" : "' + recSol.Rank__c + '" , "isActive" : ' + blnActive + ' }' + sSuffix;
            //JSONSols  = JSONSols + '{ \'id\' : \'' + recSol.Id + '\' , \'CaseName\'; : \'' + recSol.Case_Name__c + '\' , \'CaseTitle\' : \'' + recSol.Solution_Title__c + '\' , \'casestatus\' : \'' + sStat + '\' }' + sSuffix;
        }
        JSONSols  = JSONSols + ' ]';
        return JSONSols.replace('<br />', '');
    }
    //Santosh end 

    //Santosh tab change code start
    public string getRefreshSols() {
        String JSONSols  = '[ ';
        String sStat = '0';
        String sSuffix = '';
        string diagTargetResp; //Story GSSC-156
        Integer iCounter = 0;
        Boolean blnActive = false;
        for (CSS_Solutions__c recSol: solDetails )
        {
            iCounter = iCounter + 1;
            if((recSol.Repair_Response__c == null) || (recSol.Repair_Response__c == '')){sStat = '0';}
            if (recSol.Repair_Response__c == 'Repair Successful.') { sStat = '1' ; }
            else if (recSol.Repair_Response__c == 'Repair Successful with additional parts/procedures.') { sStat = '2' ; }
            else if (recSol.Repair_Response__c == 'Repair performed but didnot resolve the root cause.') { sStat = '3' ; }
            else if (recSol.Repair_Response__c == 'Repair not performed.') { sStat = '4' ; } 
            if (solDetails.size() > 1 && iCounter != solDetails.size()) { sSuffix = ', ';}
            else { sSuffix = ' ';}
            if (rank != null)
                //{rank = rankFromTs;} 
            {rankFromTs= rank;} 
            else { rank = string.valueOf(Integer.valueOf(0));}
            if (selectedSol.Id == recSol.Id) {
                if(recSol.Diagnostic_notes__c != '' && recSol.Diagnostic_notes__c!=null){
                    remCharcounter=4000 - (recSol.Diagnostic_notes__c).length() ;
                    //system.debug('remCharcounter222'+remCharcounter);
                }
                else{
                    remCharcounter=4000 ; 
                }
                blnActive = true; } else { blnActive = false; }
                
                //Added below for story GSSC-156
                diagTargetResp = (recSol.DiagTargetTime__c != null && recSol.DiagTargetTime__c != 0.0) ? (string.valueof(recSol.DiagTargetTime__c) +' '+ 'Hours') : (recSol.TargetMessage__c != null ? recSol.TargetMessage__c : '' );
            
            //Added diagTT attribute in below JSON for story GSSC-156
            JSONSols  = JSONSols + '{ "id" : "' + recSol.Id + '" , "Name" : "' + recSol.Name + '" , "diagTT" : "' + diagTargetResp + '", "CaseTitle" : "' + recSol.Solution_Title__c + '" , "casestatus" : "' + sStat + '" , "sRank" : "' + recSol.Rank__c + '" , "isActive" : ' + blnActive + ' }' + sSuffix;
            //JSONSols  = JSONSols + '{ \'id\' : \'' + recSol.Id + '\' , \'CaseName\'; : \'' + recSol.Case_Name__c + '\' , \'CaseTitle\' : \'' + recSol.Solution_Title__c + '\' , \'casestatus\' : \'' + sStat + '\' }' + sSuffix;
        }
        JSONSols  = JSONSols + ' ]';
        return JSONSols.replace('<br />', '');
    }    
    //Santosh tab change code end

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
    Public string workGroup;
    String DSID;
    public User u3{get;set;}
    public CSS_accountLanguage__c aLang{get;set;}

    public PageReference faultCodeClick(){     
        //rank = rankFromTs;   
        system.debug('******before soql: '+selectedFaulcodeId);
        system.debug('selectedReltdFaulcode: '+selectedReltdFaulcode);
        symFCSerError = false;
        String fcsoql = 'select Id,Name,Related_Fault_Code__c from CSS_Fault_Code__c where id = :selectedFaulcodeId LIMIT 1';
        recFaultCode = DataBase.query(fcsoql);
        if(recFaultCode != null && recFaultCode.size()>0){
            selectedFaulcode = recFaultCode[0].Name;
            selectedReltdFaulcode = recFaultCode[0].Related_Fault_Code__c;
            String soql = 'select Circuit_Description__c, Comp_Location__c, Effect__c, Engine__c, Fault_Code_Description__c, File_Name__c, FMI__c, Lamp__c, Reason__c, Service_Model_Name__c, SPN__c from CSS_JobEventTemporary__c where Name = \'' + selectedFaulcode + '\' LIMIT 1';
            system.debug('*****soql: '+soql);
            qsolRetrivedFCMasters = DataBase.query(soql);
            if(rank == null){
                this.rank = '0';
            }

            failDiagResp = false;
            failDiagResp1 = false;
            //making a callout to pull if not found in JobEventTemporary
            if(qsolRetrivedFCMasters.isEmpty() && qsolRetrivedFCMasters.size() == 0){
                System.debug('hello 123');
                CSS_QuickServe.workJob = rJobOrd;
                qsolRetrivedFCMaster = CSS_QuickServe.getFaultCodeOverview(selectedFaulcode,rJobOrd.ESN__c); 
                system.debug('33 qsolRetrivedFCMaster:'+qsolRetrivedFCMaster);
                symFCSerError = false;
                if(qsolRetrivedFCMaster==null){
                    symFCSerError = true;//GSSC-91
                }
                userlang = css_utility.getUserAttributes(userinfo.getUserId());
                accountlang = css_utility.getLanguage(userlang.LanguageLocaleKey);  
                if(!Test.isRunningTest()){   
                    getQSOLDocs();
                }

                getSolutionDetails();
                //insert qsolRetrivedFCMaster;
            }else{
                qsolRetrivedFCMaster = qsolRetrivedFCMasters[0];
                userlang = css_utility.getUserAttributes(userinfo.getUserId());
                accountlang = css_utility.getLanguage(userlang.LanguageLocaleKey);  
                if(!Test.isRunningTest()){   
                    getQSOLDocs();
                }
                getSolutionDetails();
            }             
        }
        isfaultCodeView = false;
        //  rank = rankFromTs;
        return null;
    }

    public String rank1 {get;set;}
    public string rankFromTs1{get;set;}
    public String rank {get;set;}
    public string rankFromTs{get;set;}

    public CSS_Solutions__c selectedSol{get;set;}
    public List<CSS_Solutions__c> solDetails{get;set;}
    public CSS_J2ASolution_EDS solDet{get;set;}
    public CSS_J2ANestSol_EDS solDet1{get;set;}
    public Boolean solDetFailed{set;get;}
    public String solErrorMsg{set;get;}
    public string JSONSolsGlob {get; set;}
    public boolean display {get; set;}
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
    public list<NestedSolutionsClass> nestedSolutionsList{get;set;}

    public Class NestedSolutionsClass{
        public CSS_J2ASolution_EDS.RepCompoundSolutions repCompSol{get;set;} 
        public CSS_Solutions__c solRec{set;get;}
        public List<CSS_Solution_Component__c> solCompList{get;set;}

        //constructor
        public NestedSolutionsClass(){
            repCompSol = new CSS_J2ASolution_EDS.RepCompoundSolutions();
            solRec = new CSS_Solutions__c();
            solCompList = new List<CSS_Solution_Component__c>();
        }
    }

    map<Id,NestedSolutionsClass> selectedNestSolMap = new map<Id,NestedSolutionsClass>();

    public void getSelNestSolution(){
        //FeedBackValNest ='';
        //getSolutionDetails();
        system.debug('Inside of getSelNestSolution');
        system.debug('selectedNestSol-->'+selectedNestSol);
        if(selectedNestSol != null){            
            if(selectedNestSolMap != null && selectedNestSolMap.get(selectedNestSol.solRec.Id) != null){
                selectedNestSolMap.put(selectedNestSol.solRec.Id,selectedNestSol);
            }else{
                selectedNestSolMap.put(selectedNestSol.solRec.Id,selectedNestSol);
            }
        }    

        system.debug('selectedNestSolMap-->'+selectedNestSolMap);

        if(nestedSolutionsMap != null && nestedSolutionsMap.get(nestSolNumber) != null){
            selectedNestSol = new NestedSolutionsClass();
            selectedNestSol = nestedSolutionsMap.get(nestSolNumber);
            system.debug('***selectedNestSol-->'+selectedNestSol);
            //EDS Analytics - Case Viewed
            //Integer nextRank1 = Integer.valueOf(selectedNestSol.solRec.rank__c);
            //Defect Fix - 77118
            system.debug('selectedNestSolId-->'+selectedNestSolId);

            Integer nextRank1 = Integer.valueOf(rank);
            HttpResponse res2 = CSS_EDSActionsUpdate.caseViewed(selectedNestSol.solRec.Name, nextRank1, rJobOrd.DSID__c);
            system.debug('Response for nested sol' +res2);
            if(res2.getStatusCode() == 200){
                solDetFailed = false; 
                solDet1 = (CSS_J2ANestSol_EDS)JSON.deserializeStrict(res2.getBody(),CSS_J2ANestSol_EDS.class);
                System.debug('The soldet for nest sol'+solDet);
            }else{
                solDetFailed = true;
                solErrorMsg = res2.getStatus();
            } 
if(!String.isEmpty(selectedNestSolId))
    
{
            CSS_Solutions__c sol1 = new CSS_Solutions__c();
            //Prabhakar Added Repair_Response__c field in the below query
            sol1 = [SELECT Id, Name, Repair_Notes__c,Repair_Response__c, DiagTargetTime__c, TargetMessage__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
            system.debug('sol1.Repair_Response__c'+sol1.Repair_Response__c);
            if(sol1.Repair_Notes__c != '' && sol1.Repair_Notes__c!=null){
                remCharcounterNest=4000 - (sol1.Repair_Notes__c).length() ;
            }
            else{
                remCharcounterNest=4000 ; 
            }
            //Prabhakar Added below if condition
             if(sol1.Repair_Response__c != ''){
                 selectedDiagRespNested = sol1.Repair_Response__c;
             }

            getPartsListNestSol(selectedNestSolId);
            partssave(nestedListsrtCompWrapper);
            UpdateNestSolNotes();
       }
           
            }
    }
    public String solutionId {get;set;}
    public String solutionTitle {get;set;}
    public Boolean isSolnExpired {get;set;}
    public map<string,List<CSS_Solution_Component__c>> mapNestSolToListComponents;////defect 103764
    public void getSolutionDetails() {
        //defect 103764
        set<id> setNestSolId = new set<id>();
        list<CSS_Solutions__c> lstNestedSolution = new list<CSS_Solutions__c>();
        mapNestSolToListComponents = new map<string,list<CSS_Solution_Component__c>>();
        // defect 103764 end
        // rankFromTs = ApexPages.CurrentPage().getParameters().get('rank');
        // Integer rank = Integer.valueOf(rank);
        // rank = rankfromTs;
        string dsidIndi;
        system.debug('**rankFromTs-->'+rankFromTs);    
        system.debug('***rank-->'+rank); 
        FeedBackVal = '';
        //FeedBackValNest ='';
        selectedNestSol = null;
        nestSolNumber = '';
        nestedSolutionsList = null;
        nestedSolutionsMap = null;
        inddsid = true;
        isSolnExpired = false;
        reportMessage = false;
        successMessage = '';
        solComp = new List<CSS_Solution_Component__c>();

        /*   user u = css_utility.getUserAttributes(userInfo.getUserId());

if( rJobOrd.DSID_WorkGroup__c == null && u.User_Location__c!=null){        
System.debug('call userinfoLocation>>>>>>>>>'+ u);
workGroup = u.User_Location__c;
System.debug('workGroup>>>>>>>>>'+ workGroup);
}
if( rJobOrd.DSID_WorkGroup__c != null && rJobOrd.DSID__c!=null ){

System.debug('call ExitDSID WebServicecalled ParamterinIFFFF>>>>>>>>>'+rJobOrd.DSID_WorkGroup__c+''+rJobOrd.DSID__c);
System.debug('call getEXITDSID WebServicecalled>>>>>>>>>');
CSS_EDSAuthentication.exitDSID(rJobOrd.DSID_WorkGroup__c,rJobOrd.DSID__c);
} */

        solDet = null;
        solDetails = null;
        solutionId = null;
        solutionTitle = null;
        System.debug('Inside getSolution');
        String soql = 'select Id,Symptom__r.id,FaultCode__r.isPole__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Report_Comments__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Notes__c,Repair_Response__c,Diagnostic_notes__c, '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
        soql += '(select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c,Service_Job__c from CSS_Solution_Components__r), ';
        soql += '(select Id,Symptom__r.id,FaultCode__r.isPole__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Notes__c,Repair_Response__c,Diagnostic_notes__c,CSS_Nested_Solutions__c '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
        soql += 'from CSS_Solutions__r) ';
        soql += 'from CSS_Solutions__c where FaultCode__c = :selectedFaulcodeId   and CSS_Nested_Solutions__c = null order by Rank__c';
        try{ 
            //    rankFromTs = ApexPages.CurrentPage().getParameters().get('rank');
            if(rJobOrd.DSID__c!=null){
                dsidIndi = css_utility.getDSIDEditIndicator(userinfo.getUserId(),rJobOrd.DSID__c, rJobOrd.DSID_WorkGroup__c);
                // Story - 65995 DS Read Only - start
                if( dsidIndi != null && (dsidIndi.containsIgnoreCase('N') || dsidIndi.containsIgnoreCase('G')))
                    inddsid = false;
                // Story - 65995 DS Read Only - end
            }
            system.debug('**rankFromTs-->'+rankFromTs);    
            system.debug('***rank-->'+rank);  
            if(solDetails == null)
                solDetails = DataBase.query(soql);
            //string solutionId = null;
            solutionId = null;
            solutionTitle = null;
            integer lrank ;
            if(!solDetails.isEmpty() && solDetails.size() > 0){
                kIdSolutionMap = new map<string,CSS_Solutions__c>();
                for(CSS_Solutions__c sol:solDetails){
                    // have changed rank name(variable) here
                    if(sol.rank__c != null && Integer.valueOf(rank) == Integer.valueOf(sol.rank__c)){
                        selectedSol = sol;
                        //added as a part of parts
                        JobsolutionId = sol.Id;
                        //end 
                        solutionId = sol.Name;
                        solutionTitle = sol.Solution_Title__c;
                        lrank = integer.valueOf(sol.Rank__c);
                        FeedBackVal = selectedSol.Repair_Response__c;
                        if(sol.CSS_Solutions__r != null && !sol.CSS_Solutions__r.isEmpty()){
                            for(CSS_Solutions__c nestSol : sol.CSS_Solutions__r){
                                kIdSolutionMap.put(nestSol.Name,nestSol);
                                setNestSolId.add(nestSol.id);//defect 103764
                            }
                        }                    
                        break;
                    }

                }
                //defect 103764 start
                if(setNestSolId != null && setNestSolId.size() > 0){
                    //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156 in below query
                    lstNestedSolution = [Select Id,FaultCode__r.isPole__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,Report_Comments__c,FaultCode__r.Name,FaultCode__c,
                                         Diagnostic_Response__c,Repair_Notes__c,Repair_Response__c,Diagnostic_notes__c,
                                         (select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,
                                          Selected_Component__c,Charlength__c,Service_Job__c 
                                          from CSS_Solution_Components__r)
                                         FROM CSS_Solutions__c where id in : setNestSolId];
                    if(lstNestedSolution != null && lstNestedSolution.size() > 0){
                        for(CSS_Solutions__c nstSol : lstNestedSolution){
                            mapNestSolToListComponents.put(nstSol.Name,new list<CSS_Solution_Component__c>());
                            for(CSS_Solution_Component__c cmp : nstSol.CSS_Solution_Components__r){
                                mapNestSolToListComponents.get(nstSol.Name).add(cmp);
                            }
                        }
                    }
                }

                //defect 103764 End
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
                    addSolComponents(selectedSol,solDet);
                    solutionId = null;
                    solutionTitle = null;
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
            }
        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());
        }
        JSONSolsGlob = getRefreshSols();
        system.debug(' Test JSONSolsGlob' + JSONSolsGlob);
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
    public void addSolComponents(CSS_Solutions__c sol, CSS_J2ASolution_EDS sDet){         
        if(selectedSol.CSS_Solution_Components__r != null && !selectedSol.CSS_Solution_Components__r.isEmpty()){
            solComp = new List<CSS_Solution_Component__c>();
            solComp = selectedSol.CSS_Solution_Components__r;
        }else{
            if(sDet.components != null){
                solComp = new List<CSS_Solution_Component__c>();
                for(CSS_J2ASolution_EDS.Components comp:sDet.components){
                    CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c();
                    solcmp.Component_Id__c = comp.failureId;
                    // Defect id - 64927    start
                    if(comp.value.length()>80){                    
                        solcmp.Name = comp.value.SubString(0,80);
                        solcmp.Charlength__c = true;
                    }
                    else{
                        solcmp.Name = comp.value;                                
                    }
                    // Defect id - 64927    end 
                    solcmp.Name = comp.value;  // added for Defect # 64927  
                    solcmp.Solutions__c = sol.Id;
                    solcmp.Service_Job__c = rJobOrd.Id;
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

        List<CSS_Solutions__c> nestSolListInsert = new List<CSS_Solutions__c>();

        if(sDet.repCompoundSolutions != null){

            NestedSolutionsClass nestSol;
            nestedSolutionsMap = new map<string,NestedSolutionsClass>();

            List<CSS_Solution_Component__c> nestSolComp = new List<CSS_Solution_Component__c>();            
            system.debug('****sDet.repCompoundSolutions-->'+sDet.repCompoundSolutions);
            for(CSS_J2ASolution_EDS.RepCompoundSolutions  compSol : sDet.repCompoundSolutions){
                nestSol = new NestedSolutionsClass();
                nestSol.repCompSol = compSol;
                //for story# 75665 start
                if(nestSol.repCompSol != null){
                    nestSol.repCompSol.verification = (nestSol.repCompSol.verification) !=null?(nestSol.repCompSol.verification).replace('<a','<a style="text-decoration: underline"') : (nestSol.repCompSol.verification); 
                    nestSol.repCompSol.resolution = (nestSol.repCompSol.resolution) !=null?(nestSol.repCompSol.resolution).replace('<a','<a style="text-decoration: underline"') : (nestSol.repCompSol.resolution); 
                }
                //end
                if(kIdSolutionMap != null && !kIdSolutionMap.isEmpty() && kIdSolutionMap.get(compSol.solutionNumber) != null){

                    nestSol.solRec = kIdSolutionMap.get(compSol.solutionNumber);
                    //defect 103764 commented below code and replaced the code with the fixed one 
                    /*  if(nestSol.solRec.CSS_Solution_Components__r != null && !nestSol.solRec.CSS_Solution_Components__r.isEmpty()){
nestSol.solCompList = selectedSol.CSS_Solution_Components__r;
}*/
                    if(mapNestSolToListComponents != null && mapNestSolToListComponents.size() > 0 &&
                       mapNestSolToListComponents.get(compSol.solutionNumber) != null && !mapNestSolToListComponents.get(compSol.solutionNumber).isEmpty()){
                        nestSol.solCompList = mapNestSolToListComponents.get(compSol.solutionNumber);
                    }else{
                        if(compSol.components != null){
                            solComp = new List<CSS_Solution_Component__c>();
                            for(CSS_J2ASolution_EDS.Components compNest : compSol.components){
                                CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c();
                                solcmp.Component_Id__c = compNest.failureId;
                                // Defect id - 64927         start
                                if(compNest.value.length()>80){                    
                                    solcmp.Name = compNest.value.SubString(0,80);
                                    solcmp.Charlength__c = true;
                                }else{
                                    solcmp.Name = compNest.value;                                
                                }
                                // Defect id -  64927        end
                                solcmp.Name = compNest.value; // added for Defect#64927
                                solcmp.Solutions__c = nestSol.solRec.Id;
                                solcmp.Service_Job__c = rJobOrd.Id;
                                if(failureCodeDetails != null){
                                    for(CSS_SRTComponentLookupResponseJ2A.DataArea failComp : failureCodeDetails.DataArea){
                                        system.debug('Failure ID-->'+failComp.FailureID);
                                        if(compNest.failureId == failComp.FailureID){
                                            solcmp.Component_Code__c = failComp.ComponentCode;
                                            solcmp.Failure_Mode__c = failComp.FailureMode;
                                            solcmp.System_Code__c = failComp.SystemCode;
                                            break;
                                        }                    
                                    }
                                }
                                nestSol.solCompList.add(solcmp);
                                solComp.add(solcmp);//Added for Nested Solutions
                            }
                        }
                    }

                }else{                  
                    if(compSol.components != null){
                        for(CSS_J2ASolution_EDS.Components comp : compSol.components){
                            CSS_Solution_Component__c solcmp = new CSS_Solution_Component__c();
                            solcmp.Component_Id__c = comp.failureId;
                            solcmp.Name = comp.value;
                            solcmp.Solutions__c = sol.Id;
                            solcmp.Service_Job__c = rJobOrd.Id;
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
                            nestSol.solCompList.add(solcmp);
                            solComp.add(solcmp);
                        }
                    }
                    nestSol.solRec.Name = compSol.solutionNumber;
                    nestSol.solRec.Solution_Title__c = compSol.solutionTitle;
                    nestSol.solRec.CSS_Nested_Solutions__c = selectedSol.Id;
                    nestSol.solRec.Service_Job__c = rJobOrd.Id;
                    nestSol.solRec.FaultCode__c = selectedSol.FaultCode__c;
                    if(selectedSol.Symptom__r !=null && selectedSol.Symptom__r.Id !=null ){
                        nestSol.solRec.Symptom__c = selectedSol.Symptom__r.id;
                        System.debug('selcted SymQAId>>>:'+selectedSol.Symptom__r.id);
                    }
                    nestSolListInsert.add(nestSol.solRec);
                }
                nestedSolutionsMap.put(compSol.solutionNumber,nestSol);
            }
        }
      getNestSolutionsList();
        system.debug('***nestedSolutionsMap-->'+nestedSolutionsMap);

        system.debug('***nestedSolutionsList-->'+nestedSolutionsList);
        
        //GSSC-155 Start
        List<string> lstSolnumbers = new List<string>();
        for (CSS_Solutions__c s : nestSolListInsert){
            lstSolnumbers.add(s.name);
        }
        
        CG_DiagTargetTimeResponse diagTargetTimeResp = new CG_DiagTargetTimeResponse();
        diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,rJobOrd.Equipment_ID__c,rJobOrd.Service_Model__c,rJobOrd.EngineFamilyCode__c,'en'); 

        Map<string, CG_DiagTargetTimeResponse.Solutions> mapSolIdTargetTime = new Map<string, CG_DiagTargetTimeResponse.Solutions>();
        
        system.debug('diagTargetTimeResp--'+diagTargetTimeResp);

        if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
            for(CG_DiagTargetTimeResponse.Solutions nestsol: diagTargetTimeResp.DataArea.Solutions){
                mapSolIdTargetTime.put(nestsol.SolutionId,nestsol);
            }
        }
        
        for (CSS_Solutions__c nestsol : nestSolListInsert){
            CG_DiagTargetTimeResponse.Solutions solution = new CG_DiagTargetTimeResponse.Solutions();

            solution = mapSolIdTargetTime.get(nestsol.Name);
            if(solution != null){
                nestsol.DiagTargetTime__c = (solution.DiagnosticTargetTime != null && solution.DiagnosticTargetTime != '') ? decimal.valueof(solution.DiagnosticTargetTime) : 0;
                nestsol.TargetMessage__c = solution.TargetMessage;  
            }
        }
        //GSSC-155 End
        
        if( nestedSolutionsList != null){
            if(solComp != null && solComp.size()>0)
                upsert solComp;
            if(nestSolListInsert.size()>0)
                upsert nestSolListInsert; 
        }
        if(!Test.isRunningTest()){
            getNestSolutionsList();
        }
    }        

    public void getNestSolutionsList(){        
        system.debug('Inside getNestSolutionsList Method');
        //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156 in below query
        list<CSS_Solutions__c> nestedSolutionsListQuery = [select Id,FaultCode__r.isPole__c,Name,Rank__c,Solution_Title__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,
                                                           FaultCode__c,Diagnostic_Response__c,Repair_Notes__c,Repair_Response__c,Diagnostic_notes__c,CSS_Nested_Solutions__c,
                                                           (select Id,Name,Action__c,Component_Id__c, Solutions__c,Quantity__c,Selected_Component__c,Charlength__c,
                                                            Service_Job__c from CSS_Solution_Components__r) 
                                                           from CSS_Solutions__c where FaultCode__r.Name = :selectedFaulcode  and 
                                                           CSS_Nested_Solutions__c = :selectedSol.Id];

        NestedSolutionsClass nestSolClsObj;                                                        
        if(nestedSolutionsListQuery != null && !nestedSolutionsListQuery.isEmpty()){

            for(CSS_Solutions__c nestSolRec : nestedSolutionsListQuery){
                if(nestedSolutionsMap != null && nestedSolutionsMap.get(nestSolRec.Name) != null){
                    //nestedSolutionsMap.get(nestSolRec.Name).solRec = nestSolRec;
                    //nestedSolutionsList.add(nestedSolutionsMap.get(nestSolRec.Name));
                    if(nestSolRec.CSS_Solution_Components__r != null && !nestSolRec.CSS_Solution_Components__r.isEmpty()){
                        nestedSolutionsMap.get(nestSolRec.Name).solCompList = new List<CSS_Solution_Component__c>();
                        nestedSolutionsMap.get(nestSolRec.Name).solCompList = nestSolRec.CSS_Solution_Components__r;
                    }
                }
            }            
        }
        if(nestedSolutionsMap != null){
            nestedSolutionsList = new list<NestedSolutionsClass>();
            nestedSolutionsList = nestedSolutionsMap.Values();
        }
        system.debug('***nestedSolutionsList-->'+nestedSolutionsList);

    }

    public PageReference returnToFCView(){
        system.debug('rJobOrd.Previous_Status__c**'+rJobOrd.Previous_Status__c);
        system.debug('rJobOrd.Status__c**'+rJobOrd.Status__c);
        if(rJobOrd.Previous_Status__c != null && rJobOrd.Previous_Status__c.equalsIgnoreCase('Triage & Diagnosis') ){

            if(rJobOrd.Status__c != null && rJobOrd.Status__c.equalsIgnoreCase('Triage & Diagnosis/Repair')){


                rJobOrd.Previous_Status__c = 'Triage & Diagnosis/Repair';
                rJobOrd.Status__c = 'Repair';

                update rJobOrd;


            }

        } 






        PageReference pageRef;
        string redirect='/apex/CSS_JobTnDTs?&id='+Ins_JobId;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference returnToRepairView(){
        PageReference pageRef;
        string redirect='/apex/CSS_JobRepair?pgFlag=RM&id='+Ins_JobId;
        // string redirect='/apex/CSS_Job?&id='+Ins_JobId;
        pageRef = new PageReference(redirect);
        pageRef.setRedirect(true);
        return pageRef;
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
        System.debug('selectedSol in RadioButtin: '+selectedSol);
        //FeedBackVal = ApexPages.CurrentPage().getParameters().get('firstParam');
        try{
            system.debug('@@@@@FeedBackVal'+FeedBackVal);
            if(FeedBackVal != null  ){   

                /*   selectedNestSol.solRec.Repair_Response__c = FeedBackVal;
system.debug('@@@@@FeedBackVal'+FeedBackVal);
upsert selectedNestSol.solRec;*/
                if(selectedSol != null){
                    selectedSol.Repair_Response__c = FeedBackVal;
                    system.debug('@@@@@FeedBackVal'+FeedBackVal);
                    //upsert selectedSol;
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
        CSS_EDSAuthentication.reportProblem(rJobOrd.DSID__c, selectedSol.name, selectedSol.Report_Comments__c);
        //Method Call to create a Case
        Id caseId = css_utility.createCase(selectedSol.Report_Comments__c, rJobOrd.Name, rJobOrd.Service_Model__c, selectedSol.Solution_Title__c, selectedSol.name);
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
    public pagereference UpdateNestSolNotes(){
        
        system.debug('selectedDiagRespNested'+selectedDiagRespNested);

        failDiagResp1 = validatenestResponse();
        if(failDiagResp1)
            return null;

        Id solId = selectedSol.id;
        System.debug('selectedNestSol: '+selectedNestSol);
        try{            
            list<CSS_Solution_Component__c> solCompListToInsert = new list<CSS_Solution_Component__c>();            

            if(selectedNestSol != null){  
                selectedNestSol.solRec.Service_Job__c = rJobOrd.Id;
                selectedNestSol.solRec.Repair_Response__c = selectedDiagRespNested;
                partssave(nestedListsrtCompWrapper);
                upsert selectedNestSol.solRec;

                /*if(selectedNestSol.solCompList != null && !selectedNestSol.solCompList.isEmpty()){
                    for(CSS_Solution_Component__c solCompNest : selectedNestSol.solCompList){
                        solCompNest.Solutions__c = selectedNestSol.solRec.Id;
                    }
                    upsert selectedNestSol.solCompList;
                    solCompListToInsert.addALL(selectedNestSol.solCompList);
                } */                   
            }

            CSS_Solutions__c sol1 = new CSS_Solutions__c();
            sol1 = [SELECT Id, Name, Repair_Notes__c, DiagTargetTime__c, TargetMessage__c FROM CSS_Solutions__c WHERE Id =: selectedNestSolId];
            if(sol1.Repair_Notes__c != '' && sol1.Repair_Notes__c!=null){
                remCharcounterNest=4000 - (sol1.Repair_Notes__c).length() ;
                //system.debug('remCharcounter222'+remCharcounter);
            }
            else{
                remCharcounterNest=4000 ; 
            }

            /*if(solCompListToInsert != null && !solCompListToInsert.isEmpty()){
                upsert solCompListToInsert;
            }     */       

        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());
        } 
        return null;       
    }
    //Method to save nested Solution and related Components - End  

    List<string> solRepAdd;
    public pagereference UpdateSolNotes(){
        Id solId = selectedSol.id;
        solRepAdd = new List<string>();
        //Added for EDS - Update Trigger    
        CSS_Solutions__c s1 = [select Repair_Response__c, Repair_Notes__c, DiagTargetTime__c, TargetMessage__c from CSS_Solutions__c where id=:selectedSol.id ];
        string oldRepResp = s1.Repair_Response__c;
        string oldRepNotes = s1.Repair_Notes__c;
        System.debug('The sol response is'+oldRepResp);
        System.debug('The sol inside response is'+selectedSol.Repair_Response__c);
        System.debug('The sol notes is'+selectedSol.Repair_Notes__c);
        System.debug('The sol name is'+selectedSol.Name);
        System.debug('The sol dsid is'+rJobOrd.DSID__c);
        if(oldRepResp!=selectedSol.Repair_Response__c||oldRepNotes!= selectedSol.Repair_Response__c){
            solRepAdd.add(JSON.Serialize(new solWrapper(selectedSol.Repair_Response__c,selectedSol.Name,selectedSol.Repair_Notes__c,rJobOrd.DSID__c)));
            CSS_EDSActionsUpdate.caseRepStatusUpdate(solRepAdd);
        }

        system.debug('rJobOrd.Previous_Status__c**'+rJobOrd.Previous_Status__c);
        system.debug('rJobOrd.Status__c**'+rJobOrd.Status__c);


        failDiagResp = validateResponse();

        if(failDiagResp)
            return null;


        System.debug('selectedNestSol: '+selectedNestSol);
        try{
            list<CSS_Solutions__c> solListForInsert = new list<CSS_Solutions__c>();
            list<CSS_Solution_Component__c> solCompListToInsert = new list<CSS_Solution_Component__c>();
            if(selectedSol != null){
                solListForInsert.add(selectedSol);
                if(solComp != null && !solComp.isEmpty()){
                    //Calling SRT parts and saving
                    partssave(listsrtCompWrapper);
                    upsert selectedSol;
                    solCompListToInsert.addALL(solComp);
                }                              
                upsert selectedSol;
            } 
            //Commented for removing Nested Solution Save - Start
            /*if(selectedNestSol != null){            
upsert selectedNestSol.solRec;
solListForInsert.add(selectedNestSol.solRec);
if(selectedNestSol.solCompList != null && !selectedNestSol.solCompList.isEmpty()){
for(CSS_Solution_Component__c solCompNest : selectedNestSol.solCompList){
solCompNest.Solutions__c = selectedNestSol.solRec.Id;
}
upsert selectedNestSol.solCompList;
solCompListToInsert.addALL(selectedNestSol.solCompList);
}                    
}*/
            //Commented for removing Nested Solution Save - Start 

            /*if(solListForInsert != null && !solListForInsert.isEmpty()){
upsert solListForInsert;
}*/

            //if(solCompListToInsert != null && !solCompListToInsert.isEmpty()){
            //    upsert solCompListToInsert;
            //} 

            //Commented for removing Nested Solution Save - Start
            /*if(selectedNestSol != null){  
selectedNestSol.solRec.Service_Job__c = rJobOrd.Id;              
upsert selectedNestSol.solrec;
}*/
            //Commented for removing Nested Solution Save - Start

            //Story 89779 Begin- Added for refreshing JSON content
            JSONSolsGlob =  getRefreshSols();
            // End- Added for refreshing JSON content

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

        return null;       
    }

    public void UpdateSolNotesNextPrev(CSS_Solutions__c selectedSolNextPre,List<CSS_Solution_Component__c> solCompNextPrev,NestedSolutionsClass selectedNestSolNextPrev,map<Id,NestedSolutionsClass> selectedNestSolMapNextPrev){
        System.debug('selectedNestSol: '+selectedNestSol);
        try{
            list<CSS_Solutions__c> solListForInsert = new list<CSS_Solutions__c>();
            list<CSS_Solution_Component__c> solCompListToInsert = new list<CSS_Solution_Component__c>();

            if(selectedSolNextPre != null){
                upsert selectedSolNextPre;
                solListForInsert.add(selectedSolNextPre);
                if(solCompNextPrev != null && !solCompNextPrev.isEmpty()){
                    upsert solCompNextPrev;
                    solCompListToInsert.addALL(solCompNextPrev);
                }                              

            }  
            //Commented for removing Nested Solution Save - Start
            /*if(selectedNestSolNextPrev != null){
upsert selectedNestSolNextPrev.solRec;
solListForInsert.add(selectedNestSolNextPrev.solRec);
if(selectedNestSolNextPrev.solCompList != null && !selectedNestSolNextPrev.solCompList.isEmpty()){
for(CSS_Solution_Component__c solCompNest : selectedNestSolNextPrev.solCompList){
solCompNest.solutions__c = selectedNestSol.solRec.Id;
}
upsert selectedNestSolNextPrev.solCompList;
solCompListToInsert.addALL(selectedNestSol.solCompList);
}                    
}*/
            //Commented for removing Nested Solution Save - End

            /*if(solListForInsert != null && !solListForInsert.isEmpty()){
upsert solListForInsert;
}

if(solCompListToInsert != null && !solCompListToInsert.isEmpty()){
upsert solCompListToInsert;
}          

if(selectedNestSol != null){  
selectedNestSol.solRec.Service_Job__c = rJobOrd.Id;              
upsert selectedNestSol.solrec;
}*/
        }catch(Exception ex){
            System.debug('Error Line:'+ex.getLineNumber());
            System.debug('Error Message:'+ex.getMessage());
        }        
    }

    public Boolean failDiagResp{get;set;}
    public Boolean failDiagResp1{get;set;}

    public PageReference nextSolution(){ 
        Id solId = selectedSol.id;
        solRepAdd = new List<string>();
        if(rank!= null ){



            failDiagResp = validateResponse();

            if(failDiagResp)
                return null;



            CSS_Solutions__c selectedSolNextPre = selectedSol;
            List<CSS_Solution_Component__c> solCompNextPrev = solComp;
            NestedSolutionsClass selectedNestSolNextPrev = selectedNestSol;
            map<Id,NestedSolutionsClass> selectedNestSolMapNextPrev = selectedNestSolMap;  

            // have changed rank value
            // Integer rank = Integer.valueOf(rank);
            system.debug('+++++==Rankcon11'+rank);
            Integer nextRank = Integer.valueOf(rank) +1;
            system.debug('+++++==Rankcon13'+rank);

            rank = ''+nextRank;
            system.debug('+++++==Rankcon14'+rank);
            ////Added for EDS - Update Trigger
            CSS_Solutions__c s1 = [select Repair_Response__c,Repair_Notes__c, DiagTargetTime__c, TargetMessage__c from CSS_Solutions__c where id=:solId ];
            string oldRepResp = s1.Repair_Response__c;
            string oldRepNotes = s1.Repair_Notes__c;
            System.debug('The sol repair response is'+oldRepResp);
            System.debug('The sol inside repair response is'+selectedSolNextPre.Repair_Response__c);
            if(oldRepResp!=selectedSolNextPre.Repair_Response__c ||oldRepNotes!= selectedSolNextPre.Repair_Notes__c){
                solRepAdd.add(JSON.Serialize(new solWrapper(selectedSolNextPre.Repair_Response__c,selectedSolNextPre.Name,selectedSolNextPre.Repair_Notes__c,rJobOrd.DSID__c)));
                CSS_EDSActionsUpdate.caseRepStatusUpdate(solRepAdd);
            }
            //End EDS Update Trigger
            // string.valueOf(Integer.valueOf(0))
            //  string x = solDetails.size();
            //
            if(rank != string.valueOf(Integer.valueOf(solDetails.size() ))){
                getSolutionDetails();     
                // update the prev sol
                // updateSol(solId,solDiagnose,solDiagnoseNotes);
                //Calling SRT parts and saving
                partssave(listsrtCompWrapper);
                UpdateSolNotesNextPrev(selectedSolNextPre,solCompNextPrev,selectedNestSolNextPrev,selectedNestSolMapNextPrev);
                //Story 89779 Begin- Added for refreshing JSON content
                String soql = 'select Id,Symptom__r.id,Symptom__r.isPole__c,Out_Of_Order__c,Diagnosis_Icon__c,Name,Rank__c,Out_Of_Order_Popup_displayed__c,Solution_Title__c, Repair_Notes__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Report_Comments__c,Diagnostic_notes__c, '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                soql += '(select Id,Symptom__r.id,FaultCode__r.isPole__c,Symptom__r.isPole__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, Repair_Notes__c, DiagTargetTime__c, TargetMessage__c, CSS_Nested_Solutions__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r) '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                soql += 'from CSS_Solutions__c where FaultCode__c = :selectedFaulcodeId and CSS_Nested_Solutions__c = null order by Rank__c';    
                solDetails = DataBase.query(soql);          

                JSONSolsGlob =  getRefreshSols();
                // End- Added for refreshing JSON content
            }
            // Setting status start        
            if(rJobOrd.Previous_Status__c != null && rJobOrd.Previous_Status__c.equalsIgnoreCase('Triage & Diagnosis') ){        
                if(rJobOrd.Status__c != null && rJobOrd.Status__c.equalsIgnoreCase('Triage & Diagnosis/Repair')){
                    rJobOrd.Previous_Status__c = 'Triage & Diagnosis/Repair';
                    rJobOrd.Status__c = 'Repair';

                    update rJobOrd;            
                }        
            }        
            // Setting status end
        }

        return null;
    }

    public void updateSol(Id solId, String solDiagnose,String solDiagnoseNotes){
        if(solId != null){
            CSS_Solutions__c updSol = new CSS_Solutions__c(Id = solId,Repair_Response__c = solDiagnose,Repair_notes__c =solDiagnoseNotes);

            update updSol;
        }
    }


    public PageReference prevSolution(){

        if(rank != null){

            failDiagResp = validateResponse();
            if(failDiagResp)
                return null;
            Id solId = selectedSol.id;

            CSS_Solutions__c selectedSolNextPre = selectedSol;
            List<CSS_Solution_Component__c> solCompNextPrev = solComp;
            NestedSolutionsClass selectedNestSolNextPrev = selectedNestSol;
            map<Id,NestedSolutionsClass> selectedNestSolMapNextPrev = selectedNestSolMap;
            //Have changed value
            Integer nextRank1 = Integer.valueOf(rank) -1;
            rank = ''+nextRank1; 
            if(rank != '-1'){ 
                getSolutionDetails();
                //Calling SRT parts and saving
                partssave(listsrtCompWrapper);
                //UpdateSolNotes();
                UpdateSolNotesNextPrev(selectedSolNextPre,solCompNextPrev,selectedNestSolNextPrev,selectedNestSolMapNextPrev);
                //Story 89779 Begin- Added for refreshing JSON content
                String soql = 'select Id,Symptom__r.id,Symptom__r.isPole__c,Out_Of_Order__c,Diagnosis_Icon__c,Name,Rank__c,Out_Of_Order_Popup_displayed__c,Solution_Title__c, Repair_Notes__c, DiagTargetTime__c, TargetMessage__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Report_Comments__c,Diagnostic_notes__c, '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                soql += '(select Id,Symptom__r.id,FaultCode__r.isPole__c,Symptom__r.isPole__c,Diagnosis_Icon__c,Name,Rank__c,Solution_Title__c, Repair_Notes__c, DiagTargetTime__c, TargetMessage__c, CSS_Nested_Solutions__c, Solution__c,FaultCode__r.Name,FaultCode__c,Diagnostic_Response__c,Repair_Response__c,Diagnostic_notes__c from CSS_Solutions__r) '; //Added DiagTargetTime__c, TargetMessage__c for story GSSC-156
                soql += 'from CSS_Solutions__c where FaultCode__c = :selectedFaulcodeId and CSS_Nested_Solutions__c = null order by Rank__c';    
                solDetails = DataBase.query(soql);          

                JSONSolsGlob =  getRefreshSols();
                // End- Added for refreshing JSON content
            }
            if(rJobOrd.Previous_Status__c != null && rJobOrd.Previous_Status__c.equalsIgnoreCase('Triage & Diagnosis') ){

                if(rJobOrd.Status__c != null && rJobOrd.Status__c.equalsIgnoreCase('Triage & Diagnosis/Repair')){


                    rJobOrd.Previous_Status__c = 'Triage & Diagnosis/Repair';
                    rJobOrd.Status__c = 'Repair';

                    update rJobOrd;


                }

            }
        }

        return null;        
    }

    /*  public Boolean validateResponse(){
        Boolean valFailed = false;
        if(selectedSol != null && 
           ('Repair Successful.'.equalsIgnoreCase(selectedSol.Repair_Response__c) || 'Repair Successful with additional parts/procedures.'.equalsIgnoreCase(selectedSol.Repair_Response__c) || 'Repair performed but didnot resolve the root cause.'.equalsIgnoreCase(selectedSol.Repair_Response__c))
           && (selectedSol.Repair_notes__c == null || selectedSol.Repair_notes__c == '')){ 
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
               ApexPages.addMessage(myMsg);               
               valFailed = true;
           }
        return valFailed;
    } */
    // Story 68252 end Modified by Roopa Gadipudi
    public Boolean validateResponse(){
        Boolean valFailed = false;
        if(selectedSol != null && 
           ('Repair Successful.'.equalsIgnoreCase(selectedSol.Repair_Response__c) || 'Repair Successful with additional parts/procedures.'.equalsIgnoreCase(selectedSol.Repair_Response__c) || 'Repair performed but didnot resolve the root cause.'.equalsIgnoreCase(selectedSol.Repair_Response__c))
           && (selectedSol.Repair_notes__c == null || selectedSol.Repair_notes__c == '')){ 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
            ApexPages.addMessage(myMsg);               
            valFailed = true;
            return valFailed;
        }else if (selectedSol != null && selectedSol.Repair_notes__c != null && selectedSol.Repair_notes__c != '' && (selectedSol.Repair_Response__c == null || selectedSol.Repair_Response__c == ''))

        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
            ApexPages.addMessage(myMsg);               
            valFailed = true;
            return valFailed;
        }
        return valFailed;
    }
    // Story 68252 end Modified by Roopa Gadipudi

    // Validation for Nested solutions - start
    public Boolean validatenestResponse(){
        Boolean nesFailed = false;
        if(selectedNestSol.solRec != null && 
           ('Repair Successful.'.equalsIgnoreCase(selectedNestSol.solRec.Repair_Response__c) || 'Repair Successful with additional parts/procedures.'.equalsIgnoreCase(selectedNestSol.solRec.Repair_Response__c) || 'Repair performed but didnot resolve the root cause.'.equalsIgnoreCase(selectedNestSol.solRec.Repair_Response__c))
           && (selectedNestSol.solRec.Repair_notes__c == null || selectedNestSol.solRec.Repair_notes__c == '')){ 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please write notes to proceed further');
            ApexPages.addMessage(myMsg);               
            nesFailed = true;
        }
        //selectedNestSol
        return nesFailed;
    }
    // Validation for Nested solutions - end
    //Commented the code updateFeedBackForNestSol method to fix 103764 defect 
    /*
public String FeedBackValNest{set;get;}
public void updateFeedBackForNestSol(){
System.debug('selectedSol in RadioButtin: '+selectedSol);
FeedBackValNest = ApexPages.CurrentPage().getParameters().get('firstParam');
try{
if(FeedBackValNest != null){      
selectedNestSol.solRec.Repair_Response__c = FeedBackValNest;
//update selectedNestSol.solRec;
}
}catch(Exception ex){
System.debug('Error Line:'+ex.getLineNumber());
System.debug('Error Message:'+ex.getMessage());
}
}*/

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

    /*public pagereference  Save(){
list<CSS_Solution_Component__c> x =new list<CSS_Solution_Component__c>();
for(CSS_Solution_Component__c selectopt : Components){
selectopt.Action__c = selectedValue1;

//selectopt.Quantity__c = Quantity__c;
x.add(selectopt);
}
//  update x;
return null;
}   */
    public Void navigateToRepair(){
        if(rJobOrd.Status__c !='Repair'){
            css_job_order__c workOrder= new css_job_order__c();
            workOrder.id=rJobOrd.id;
            workOrder.Status__c='Triage & Diagnosis/Repair';
            workOrder.Previous_Status__c=rJobOrd.Status__c;
            update workOrder;
        }
        //failureCodeDetails = getSRTComponentOnLoad();
        //system.debug('output wrapper-->'+failureCodeDetails);        
    } 
    /* public boolean cancel{get; set;}
    public void close(){
        cancel = false;

    } */



    public List<CSS_Solutions__c> lstSolutions;
    //public boolean ErrorMessage {get; set;}     
    public list<CSS_Parts_Options__c> partdispjbp{get;set;} 
    public CSS_Job_Order__c serviceJob{get; set;}
    public String selSolution {get; set;}

    public void refreshPartsList(){
        listsrtCompWrapper= new List<srtCompWrapper>();
    }
    // Method to get Parts list (Story# 103855 Start)

    public void getPartsList(){
        try{
            listsrtCompWrapper= new List<srtCompWrapper>();

            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            System.debug('testing debug');
            System.debug('inside the method parts METHOD...Selected Sol Id>>>'+selectedSol.Id);
            //  if(Wid != null){
            //code for parts webservice invokation - Start.
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            // solComp = [Select Id,Component_Id__c,Service_Job__c,Solutions__c from CSS_Solution_Component__c where Service_Job__c = : Ins_JobId and Solutions__c = : selectedSol.Id];
            solComp = [Select id,(Select id,Option_Number__c,Replacement_Reason__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r), Name,Component_Id__c,Service_Job__c,Selected_Component__c,Solutions__c,Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : selectedSol.Id];
            Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : selectedSol.Id and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            if(Parts.size()==0 || Parts.isempty()){
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

    public void getPartsListNestSol(Id nestedSolId){
        try{
            nestedListsrtCompWrapper= new List<srtCompWrapper>();

            list<CSS_Parts_Options__c> Parts = new list<CSS_Parts_Options__c>();
            System.debug('testing debug');
            System.debug('inside the method parts METHOD...Selected Sol Id>>>'+selectedSol.Id);
            //  if(Wid != null){
            //code for parts webservice invokation - Start.
            List<CSS_Solution_Component__c> solComp = new List<CSS_Solution_Component__c>();
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            system.debug('queryFrom-->'+queryFrom);
            system.debug('selectedNestSolId-->'+selectedNestSolId);
            //solComp = [Select id,(Select id,Option_Number__c,Replacement_Reason__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r), Name,Component_Id__c,Service_Job__c,Selected_Component__c,Solutions__c,Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : selectedNestSolId];
            solComp = [Select id,(Select id,Option_Number__c,Replacement_Reason__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r), Name,Component_Id__c,Service_Job__c,Selected_Component__c,Solutions__c,Solutions__r.Name,Solutions__r.FaultCode__c,System_Code__c,Component_Code__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =: Ins_JobId and Solutions__c = : nestedSolId];
            Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : selectedNestSolId and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            if(Parts.size()==0 || Parts.isempty()){
                system.debug('Anirudh entered inside parts size is 0 for webservice call');
                CSS_FN_SRT.srtPartsService(solComp,rJobOrd,recTypeIdpart);
                Parts = [Select id,Option_Number__c,Default_Part_Quantity__c,Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Name,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Assignment__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c,Replacement_Reason__c from CSS_Parts_Options__c where RecordType.Name = 'Parts' and Solutions__c = : selectedSol.Id and Service_Job__c =: rJobOrd.Id order by Part_Name__c];
            }
            //code for parts webservice invokation - End. 
            System.debug('recTypeIdpart-->'+recTypeIdpart);
            Set<CSS_Solution_Component__c> setcomp = new  Set<CSS_Solution_Component__c>();
            lstComp = new list<CSS_Solution_Component__c>();
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
                                setsrtPartWrapper.add(new srtPartWrapper(p.id,p.FailurepartId__c,p.selected_part__c,p.Part_Name__c,integer.valueof(p.Quantity__c),integer.valueof(p.Default_Part_Quantity__c),p.Replacement_Reason__c)); 
                                lstChildIds.add(p.id);
                                system.debug('setsrtPartWrapper Anirudh>>>'+setsrtPartWrapper);
                                system.debug('setsrtPartWrapper Anirudh>>>'+setsrtPartWrapper.size());
                            }
                        }
                        if(setsrtPartWrapper.size()>0 && !setsrtPartWrapper.isempty()){
                            listsrtPartWrapper.addAll(setsrtPartWrapper);
                            system.debug('listsrtPartWrapper>>>>>>>'+listsrtPartWrapper);
                            nestedListsrtCompWrapper.add(new srtCompWrapper(z.id,z.Selected_Component__c,z.Name,lstChildIds,listsrtPartWrapper,z.solutions__r.FaultCode__c,z.System_Code__c,z.Component_Code__c,z.AccountCode__c)); 
                            system.debug('listsrtCompWrapper2 >>>>>> '+listsrtCompWrapper);
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


    /*  public void parentCheckBoxUpdateWrapper(){
try{ 
system.debug('parentcheckboxvalue>>>>>'+checkboxvalue + ' ' + 'parentId>>>>>>>' +parentId);
for(srtCompWrapper z: listsrtCompWrapper){
if(z.CompIds == parentId){
system.debug('Entered inside id match if Anirudh');
if(checkboxvalue == true){
z.compParentCheckbox = true;
if(z.partWrapper != null){
for(srtPartWrapper y:z.partWrapper){
y.partChildCheckbox = true; 
}
}
}else{
z.compParentCheckbox = false;
if(z.partWrapper != null){
for(srtPartWrapper y:z.partWrapper){
y.partChildCheckbox = false; 
}
}
}
break;
}
}
system.debug('Anirudh listsrtCompWrapper after update'+listsrtCompWrapper);
} catch(exception e){
system.debug('Entered into catch block of parentCheckBoxUpdateWrapper logic of SymEdsSolutions.>>>>>>'+ e.getLineNumber() + ' ' + e.getMessage());
}
}
public boolean checkboxvalue {get;set;}
public Id parentId {get;set;}
public Id childId {get;set;}
public boolean parentCheckBoxValue {get;set;}
public void childCheckBoxLogic(){
try{
//Id parentId = Apexpages.currentPage().getParameters().get('parentId');
for(srtCompWrapper z: listsrtCompWrapper){
//if parent id come inside
system.debug('parentId>>>>>>>>'+parentId + ' ' + 'z.CompIds>>>>>>>>>'+z.CompIds + ' ' + 'checkboxvalue>>>>'+checkboxvalue);
if(parentId == z.CompIds){
z.compParentCheckbox = parentCheckBoxValue;
for(srtPartWrapper y:z.partWrapper){
system.debug('Outside If childId>>>>>>>'+childId+'y.partIds>>>>>>'+y.partIds);
if(y.partIds == childId){
system.debug('Inside If childId>>>>>>>'+childId+'y.partIds>>>>>>'+y.partIds);
y.partChildCheckbox = checkboxvalue;
break;
}
}
break;
}
}
system.debug('Anirudh listsrtCompWrapper in child logic >>>>'+listsrtCompWrapper);
}catch(exception e){
system.debug('Entered into catch block of child check box logic>>>>>>>>'+ e.getLineNumber() + ' ' + e.getMessage());
}
} */

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
                               CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,selected_part__c = y.partChildCheckbox,Replacement_Reason__c=y.replacementReason,Quantity__c=y.qty); 
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

    @future(callout=true)
    public static void getAccountCodes(string PSN, string spCode, date failureDate, string failurePoint, string failureMeasure, string engAppCode, date warrStartDt, string temp, string reconFlag,String Name){
        List<srtCompWrapper> srtCompWrapper_lst = new List<srtCompWrapper>();
        srtCompWrapper_lst = (List<srtCompWrapper>)JSON.deserializeStrict(temp,List<srtCompWrapper>.class);
        List<CSS_Solution_Component__c> compListUpd = new List<CSS_Solution_Component__c>();
        for(srtCompWrapper compWrap:srtCompWrapper_lst){
            CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
            if((compWrap.accountCode == null || compWrap.accountCode =='') &&(compWrap.compParentCheckbox==true)){
                comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(PSN,spCode,failureDate,failurePoint,failureMeasure,engAppCode,warrStartDt,compWrap.systemCode,compWrap.compCode,compWrap.faultCode,compWrap.accountCode,compWrap.CompIds,compWrap.compParentCheckbox,'','','First Call', reconFlag, false,Name); //Kalpana Story#117207 added 'First Call' Param
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
    public CSS_SRTComponentLookupResponseJ2A getSRTComponentOnLoad() {
        try{
            String smn_engFamCode = rJobOrd.Service_Model__c + ';;' + rJobOrd.Qsol_Engine_Family_Code__c;
            CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();
            jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Key__c, Reason__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engFamCode AND Key__c = 'GetFailureCodesSRT' ORDER BY CreatedDate DESC LIMIT 1];
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