public class CSS_SRTParts {


    public Id pgId{get;set;}
    public CSS_Job_Order__c serviceJob{get; set;}
    public list<CSS_Solutions__c> solutiondetails{get; set;}
    public list<srtPartWrapper> lstsrtPartWrapper{get;set;}
    public List<srtCompWrapper> listsrtCompWrapper {get;set;} 
    public List<srtsolWrapper> listsrtsolWrapper {get;set;} 
    public List<srtsolWrapper> listsrtsolWrapperDisp {get;set;} 
    public CSS_getPartsListSRTRequestJ2A PartsSRTREq;
    public String srtpartsErrorMsg{set;get;}
    public Boolean displayPopup2{get;set;}
    public boolean srtpb{get;set;}
    public CSS_SRTParts(css_repair_job controller){}
    public Id recTypeIdpart {get; set;}
    public map<Id,string>failidmap {get; set;}
    public map<id, string> solutionmap{get;set;}
    public list<string> failids{get; set;}
    //public List<CSS_Solution_Component__c> SolCmps; commented as its no where used - 101 SOQL fix
    public List<SelectOption> accCodesFailcode{get;set;}

    public boolean chkReqField{get;set;}
    public Id compSolId{get;set;}
    public String ParentSol;
    public String SelectedFailCode{get;set;}
    public integer  SelectedPartID{get;set;}
    public String SelectedAccountCode{get;set;}
    public String servicePartNumber{get;set;}
    public List<CSS_Parts_Options__c> partslst = new List<CSS_Parts_Options__c>();
    public Integer selectedPartRowCount{get;set;}
    public Id partRecTypeId;
    public List<CSS_Parts_Options__c> partsList{get;set;}
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
     //public String coverageType;
    public Map<String,CSS_JobEventTemporary__c> accCodeMapJET = new Map<String,CSS_JobEventTemporary__c>();
    //story 111469
    map<id,boolean> mapSolutionCompToSelComp = new map<id,boolean>();
    public CSS_SRTParts(){
        pgId = ApexPages.CurrentPage().getParameters().get('id');
        system.debug('Sama partsList constructor' + ' ' + pgId );
        //ID of the record type as there are five reccord types on the Part Options Object
        partRecTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        //Parts Coming from BMS
        partsList = new List<CSS_Parts_Options__c>();
        partsList = [select Id, Name, Quantity__c, Quantity_Used__c,Part_Description__c,Part_Name__c,Sell_Price__c,
                     Service_partnumber__c, Account_Code__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c,Parts_Return__c,
                     Covered__c,Comments__c,Warranty_Allocation__c from CSS_Parts_Options__c 
                     where Service_Job__c =: pgId AND RecordTypeId=:partRecTypeId AND PartOC__c = 'PART'];
        system.debug('Sama partsList' + ' ' + partsList );

        //getAccountCodes();
        JETFA = new list<CSS_JobEventTemporary__c>();
        JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
        for(CSS_JobEventTemporary__c jet : JETFA){
            string temp = jet.Attribute3__c; 
            if(!accCodeMapJET.containskey(temp))
                accCodeMapJET.put(temp,jet);
        }

        getfailAccountCodeMap();
        system.debug('failAccountCodeMapfinal**'+failAccountCodeMap);
        getPartsList();
    }
    list<CSS_Solution_Component__c> lstSolComp;
    Map<String, List<SelectOption>> failAccountCodeMap;
    public void getfailAccountCodeMap(){
        failAccountCodeMap = new  Map<String, List<SelectOption>>();
        lstSolComp = new list<CSS_Solution_Component__c>();

        lstSolComp = [Select id,name,type__c,Selected_Component__c,Component_Id__c,Service_Job__c,Solutions__c,Solutions__r.Name ,Solutions__r.Solution_title__c, Solutions__r.Diagnostic_Response__c,CSS_Account_Formula__c,Fail_Code__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c,FailCode_Formula__c,CoveredPartsQty__c,CampaignPartsPercentage__c, System_Code__c,Component_Code__c  from CSS_Solution_Component__c where service_job__c = :pgid  and Solutions__r.Diagnostic_Response__c='Most likely the solution' and (Selected_Component__c=true or Type__c IN ('CAMPAIGN' ,'TRP' ,'ATC'))];
        if(lstSolComp.size()>0){
            List<SelectOption> acCodeSet;
            Set<SelectOption> acCodeSet1;
            for(CSS_Solution_Component__c f:lstSolComp )  {
                String coverageType;
                if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c != '' && f.CSS_Account_Formula__c != 'Select One'){
                    string temp = f.CSS_Account_Formula__c.RIGHT(2);
                    CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                    jetSingle = accCodeMapJET.get(temp);
                    if(jetSingle!= null){
                        coverageType = jetSingle.Attribute1__c;
                    }
                }
                
                acCodeSet = new List<SelectOption>();

                acCodeSet.add(new SelectOption('Select One','Select One'));
                if(f.Fail_Code__c!=null && f.Fail_Code__c!='' && f.Fail_Code__c!='Select One'){
                    // sortableSet.add(f.Fail_Code__c);
                    if(failAccountCodeMap.containsKey(f.Fail_Code__c)){
                        system.debug('**insidecontainkey**');
                        acCodeSet = failAccountCodeMap.get(f.Fail_Code__c);
                        acCodeSet1 = new Set<SelectOption>(acCodeSet);
                        if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c != '' && f.CSS_Account_Formula__c !='Select One'){
                            if((f.Selected_Component__c == true && f.CoveredPartsQty__c != null && f.CoveredPartsQty__c != '' && Double.valueOf(f.CoveredPartsQty__c) >0) || ((f.Type__c == 'ATC' || f.Type__c == 'TRP' || f.Type__c == 'CAMPAIGN') && f.CampaignPartsPercentage__c != null && f.CampaignPartsPercentage__c != '' && Double.valueOf(f.CampaignPartsPercentage__c) > 0) || (coverageType == 'OTH' || coverageType == 'POL')){
                                    if(!acCodeSet1.contains(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c))){ // Kalpana: added code to avoid duplicates
                                        acCodeSet.add(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c)); }
                                    failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                                    if(f.Fail_Code__c.length()==6)
                                        failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                                }
                        }
                        else{
                            system.debug('InsideNULLElse**'+f.Fail_Code__c);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                            if(f.Fail_Code__c.length()==6)
                                failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                        }
                    }
                    else{
                        system.debug('Insidedoesnotcontainelse**'+f.Fail_Code__c);
                        system.debug('failAccountCodeMap not contains acCodeSet**'+acCodeSet);
                        //acCodeSet = new List<SelectOption>();
                        /* if(f.CSS_Account_Formula__c != null){
                                if(f.CSS_Account_Formula__c !='Select One'){*/
                        if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c != '' && f.CSS_Account_Formula__c !='Select One'){
                           if((f.Selected_Component__c == true &&  f.CoveredPartsQty__c!=null && f.CoveredPartsQty__c!= '' && Double.valueOf(f.CoveredPartsQty__c) >0) || ((f.Type__c == 'ATC' || f.Type__c == 'TRP' || f.Type__c == 'CAMPAIGN') && f.CampaignPartsPercentage__c!= null && f.CampaignPartsPercentage__c!='' && Double.valueOf(f.CampaignPartsPercentage__c) > 0) || (coverageType == 'OTH' || coverageType == 'POL')){
                                    acCodeSet.add(new SelectOption(f.CSS_Account_Formula__c,f.CSS_Account_Formula__c));
                                    system.debug('CSS_Account_Formula__c**'+f.CSS_Account_Formula__c);
                              		 system.debug('148 failAccountCodeMap not contains acCodeSet**'+acCodeSet);
                                    failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                                    system.debug('failAccountCodeMap**'+failAccountCodeMap);
        
                                    if(f.Fail_Code__c.length()==6){
                                        failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                                        system.debug('failAccountCodeMap1**'+failAccountCodeMap);
                                    }
                                    
                                }
                        }

                        else{
                            system.debug('InsideNULLElse**'+f.Fail_Code__c);
                            system.debug('acCodeSetAfterAdd4**'+acCodeSet);
if(acCodeSet.size() == 2  && acCodeSet[0].getValue() == 'Select One')
                                acCodeSet.remove(0);
                            system.debug('acCodeSetAfterAdd4**'+acCodeSet);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                            if(f.Fail_Code__c.length()==6)
                                failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);
                        }

                        /*system.debug('**acCodeSet*'+f.Fail_Code__c+'***'+acCodeSet);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                            if(f.Fail_Code__c.length()==6)
                                failAccountCodeMap.put(f.System_Code__c+f.Component_Code__c, acCodeSet);*/
                    }
                }

            }
        }
        
        // Anvesh  Below code is commented as per the story 176475 from Finding Nemo sprint
   	/*     for(String accCode : failAccountCodeMap.keySet()){
     		List<SelectOption> acCode = new List<SelectOption>();
            acCode = failAccountCodeMap.get(accCode);
   			if(acCode[0].getValue() == 'Select One'&& acCode.size() == 2){
                acCode.remove(0);
            }
            failAccountCodeMap.put(accCode,acCode);
        }*/
        
        system.debug('failAccountCodeMap 190 >>> ' + failAccountCodeMap);
    }


    public void getPartsList(){
        system.debug('Calling from GSQ');
        //getAccountCodes();
        chkReqField = false;
        PartsSRTREq = new CSS_getPartsListSRTRequestJ2A(); 
        failidmap = new map<Id,string>();
        solutionmap = new map<id, string>();
        List<CSS_Solution_Component__c> solcoms = new List<CSS_Solution_Component__c>(); //457 observation
        set<Id> setRootCompid = new set<Id>(); //457 observation
        
        srtpb =false;
        serviceJob = [Select id,Name,Service_Model__c,Equipment_ID__c,Qsol_Engine_Family_Code__c,ESN__c,
                      (Select id,Component_Id__c,Service_Job__c,Solutions__c,Solutions__r.Name from CSS_Solution_Components__r where Solutions__c = : compSolId),
                      (Select id,Option_Number__c,Service_Job__c,Option_ESN__c,selected_part__c,Css_Estimate__c,FailureName__c,Assignment__c,FailurepartId__c,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Service_partnumber__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary')
                      from CSS_Job_Order__c where id= :pgId];
        /*serviceJob = [Select id,Name,Service_Model__c,Equipment_ID__c,Qsol_Engine_Family_Code__c,ESN__c,
                                            (Select id,Component_Id__c,Service_Job__c,Solutions__c,Solutions__r.Name from CSS_Solution_Components__r 
                                             where Solutions__c = : compSolId
                                            ),
                      (Select Type__c,Days__c,ExpenseTotal__c,Mileage__c,HoursTravelled__c,Technician__c,id,Option_Number__c,
                                             Service_Job__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,                                          FailurepartId__c,Notes__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,
                                             Service_partnumber__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary'
                                            )
                      from CSS_Job_Order__c where id= :pgId];*/
        // serviceJob = [SELECT Id,Failure_Date__c,ESN__c FROM CSS_Job_Order__c where id =: pgId];
        system.debug('Dhanvi**'+pgId);
       // 457 observation 
        solcoms = [Select id,name,Solutions__r.id,Solutions__r.Name,Solutions__r.Solution_title__c,Solutions__r.CSS_Nested_Solutions__c,Selected_Component__c,Root_Cause__c,Fail_Code__c,Fail_Code_Editable__c,AccountCode__c,
                    AccountCodeEdit__c,FailCode_Formula__c from CSS_Solution_Component__c where Solutions__r.Diagnostic_Response__c='Most likely the solution' and Root_Cause__c=true and Service_Job__c=:pgId];
        for(CSS_Solution_Component__c sc: solcoms){
            setRootCompid.add(sc.Solutions__r.id);
        }
        
        solutiondetails = [Select id,Name,Solution_title__c,CSS_Nested_Solutions__c,
                           //(Select id,name,Selected_Component__c,Component_Id__c,Service_Job__c,Solutions__c,Solutions__r.Name ,Solutions__r.Solution_title__c,Root_Cause__c,Fail_Code__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c,FailCode_Formula__c from CSS_Solution_Components__r where Solutions__r.Diagnostic_Response__c='Most likely the solution' and Root_Cause__c=true),
                           (Select id,Option_Number__c,Service_Job__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,Css_Estimate__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,ReturnToFactory__c,Fail_Code__c,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary' order by Part_Name__c)
                           from CSS_Solutions__c where Diagnostic_Response__c='Most likely the solution' and Service_Job__c = :pgId and Id IN: setRootCompid order by LastModifiedDate desc];
        system.debug('SolutionDetails**'+solutiondetails);
        
        
        
        //commented as its no where used - 101 SOQL fix
        //SolCmps = [SELECT  Id, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:pgId];

        User u = css_utility.getUserAttributes(userinfo.getUserId()); 
        string lang = u.LanguageLocaleKey;

        datetime systemDate = System.now();
        string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00'; 

        Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
        recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        Map<id,string> ParentSolMap = new Map<id,string>();

        //Code for Service Parts - Start.
        if(solutiondetails!=null){  
            for(CSS_Solutions__c sol: solutiondetails){
                system.debug('Testsolname>>'+sol.Name);
                system.debug('Testsolname>>'+sol.Solution_title__c);
                ParentSolMap.put(sol.id,sol.Name);
            }

            listsrtsolWrapper= new list<srtsolWrapper>();
            if(solutiondetails!=null){
            for(CSS_Solutions__c sol: solutiondetails){
                Integer partscount = 0;
                Integer compCount = 0;
                listsrtCompWrapper= new list<srtCompWrapper>();
                if(sol != null){
                    // story 117210 display Parent Solution Name for a Nested Solution START
                    if(sol.CSS_Nested_Solutions__c != null){
                       //ParentSol = [Select id, Name from css_solutions__c where id = :sol.CSS_Nested_Solutions__c].Name;
                    ParentSol = ParentSolMap.get(sol.CSS_Nested_Solutions__c);
                        system.debug('ParentSol**'+ParentSol);
                    }
                    else ParentSol = '';
                    //Kalpana story 117210 display Parent Solution Name for a Nested Solution END
                    system.debug('serviceJobdetails.CSS_Solution_Components__r--> '+sol.CSS_Solution_Components__r);
                    for(CSS_Solution_Component__c c : solcoms ){
                        system.debug('Testsolname2>>'+c.Name);
                        system.debug('Testsolname22>>'+c);
                        //story 111469
                        mapSolutionCompToSelComp.put(c.id,c.Selected_Component__c);
                        //End Story 111469
                        system.debug('Anirudh components'+c);
                        boolean componentspart = false;
                        Integer compPartsCount = 0;
                        compCount = compCount + 1;
                        lstsrtPartWrapper = new list<srtPartWrapper>();
                        if(c.Solutions__c == sol.id){
                            system.debug('serviceJobdetails.CSS_Solution_Components__r-->2 '+c);
                            system.debug('serviceJobdetails.CSS_Parts_Options__r--> '+sol.CSS_Parts_Options__r);
                            // if(c.CSS_Parts_Options__r != null){
                            system.debug('KALAccountCode***'+sol.CSS_Parts_Options__r);
                            Integer i=1;
                            for(CSS_Parts_Options__c p : sol.CSS_Parts_Options__r){
                                if(c.Id == p.FailurepartId__c){
                                    if(p.Solutions__c==sol.id ){
                                        partscount=partscount+1;
                                        compPartsCount = compPartsCount+1;
                                        componentspart = true;
                                    }
                                    system.debug('serviceJobdetails.CSS_Parts_Options__r-->2 '+p);
                                    //system.debug('y.id--> '+c.id);
                                    system.debug('p.FailurepartId__c --> '+p.FailurepartId__c);
                                    system.debug('KalAccountCodes'+lstAccountCodes);
                                    if(p.FailurepartId__c == c.id){
                                        system.debug(' ***'+p.Account_Code__c);
                                        //the below if block is commented per defect GSSC-524
                                       /* if(p.Account_Code__c == null || p.Account_Code__c == '')
                                        p.Account_Code__c = p.FailurepartId__r.CSS_Account_Formula__c;*/
                                        string failcodestring = '';
                                        if(c.Fail_Code__c != null && c.Fail_Code__c != '')
                                            failcodestring = c.Fail_Code__c;
                                        else
                                            failcodestring = c.Fail_Code_Editable__c;
                                        system.debug('failcodestring**'+failcodestring);
                                        List<SelectOption> aC = new List<SelectOption>();
                                        aC = failAccountCodeMap.get(failcodestring);
                                        //system.debug(' aC output-->'+aC  + 'aC.size()' + aC.size() );
                                        if(aC == null){ 
                                            aC = new List<SelectOption>();
                                            aC.add(new SelectOption('Select One','Select One'));
                                        }
                                        

                                    /*    if(aC.size()>2){
                                              system.debug(' aC size >1-->'+aC.size());
                                           p.Account_Code__c  = 'Select One';
                                        }*/
                                      /*  else {
                                             system.debug(' aC size <1-->'+aC.size());
                                            aC.add(new SelectOption('Select One','Select One'));
                                          
                                        }*/
                                         system.debug('B4 srtpartWrapper add >> p.Account_Code__c' +  p.Account_Code__c + 'aC >>'  + aC);
                                        
                                        //lstsrtPartWrapper.add(new srtPartWrapper(i++,p.Id,p.FailurepartId__c,p.selected_part__c,p.Css_Estimate__c,p.Service_partnumber__c,p.Part_Name__c,p.Part_Description__c,string.ValueOf(p.Covered__c),p.Account_Code__c,p.ReturnToFactory__c,p.Option_Number__c,Integer.ValueOf(p.Quantity__c),p.part_size__c,p.Replacement_Reason__c ,p.Notes__c,p.OEM__c, accountCodelistN(p.Account_Code__c,p.FailurepartId__r.CSS_Account_Formula__c,p.FailurepartId__r.AccountCode__c),c.FailCode_Formula__c));
                                        lstsrtPartWrapper.add(new srtPartWrapper(i++,p.Id,p.FailurepartId__c,p.selected_part__c,p.Css_Estimate__c,p.Service_partnumber__c,p.Part_Name__c,p.Part_Description__c,string.ValueOf(p.Covered__c),p.Account_Code__c,p.ReturnToFactory__c,p.Option_Number__c,Integer.ValueOf(p.Quantity__c),p.part_size__c,p.Replacement_Reason__c ,p.Notes__c,p.OEM__c, aC,c.FailCode_Formula__c));
                                        
                                        system.debug('lstsrtPartWrapper--> '+lstsrtPartWrapper);

                                    }

                                }
                            }
                            // }
                            if(componentspart == false){
                                partscount = partscount + 1;
                                lstsrtPartWrapper.add(new srtPartWrapper(0,null,null,false,false,'','','','',null,'','',0,'','','','',null,''));

                                system.debug('Anirudh entered else');
                            }
                            listsrtCompWrapper.add(new srtCompWrapper(c.id,c.Name,c.Solutions__r.Name ,c.Solutions__r.Solution_title__c,c.Fail_Code__c,c.Fail_Code_Editable__c,c.AccountCode__c,c.AccountCodeEdit__c,lstsrtPartWrapper,compPartsCount));     
                            system.debug('compPartsCount--> '+compPartsCount); 

                        }
                    }

                }

                listsrtsolWrapper.add(new srtsolWrapper(sol.id,sol.Name,sol.Solution_title__c,listsrtCompWrapper,partscount,compCount,sol.CSS_Nested_Solutions__c,ParentSol) );  
                system.debug('listsrtsolWrapper-->'+listsrtsolWrapper);

            }
            }
        }
        system.debug('listsrtsolWrapper-->'+listsrtsolWrapper);
        //  } // else close for partlist from ERP
        listsrtsolWrapperDisp=listsrtsolWrapper;
        system.debug('<<<<<<<< listsrtsolWrapper >>>>>>>>>>>>>>>>>> ' + listsrtsolWrapper);
    }
    //Code ofr Srevice Parts - End. 



    public PageReference saveParts(){
        System.debug('save parts');
        /* if(partdispjbp != null && !partdispjbp.isEmpty()){
            update partdispjbp;
        }*/
        //story 111469 
        set<Id> setPartsRelatedsolCompid = new set<Id>();
        //map<id,CSS_Solution_Component__c> mapSolutionComponent;
        try{
            System.debug('listsrtsolWrapper-->'+listsrtsolWrapper);
            string coveredvalue;
            decimal coveredValueDec;

            if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                for(srtsolWrapper sol:listsrtsolWrapper){
                    if(sol.compWrapper != null ){
                        for(srtCompWrapper s: sol.compWrapper){
                            if(s.partWrapper != null){
                                system.debug('s.partWrapper--->'+s.partWrapper);
                                for(srtPartWrapper y: s.partWrapper){
                                    system.debug('ypartsid>>>>>>>>'+y.partIds);
                                    if(y.partIds != null){
                                        y.notes = (y.notes).replace('\r\n', '');
                                        y.notes = (y.notes).replace('\n', '');
                                        y.notes = (y.notes).replace('\r', '');
                                        system.debug('y.accountCode'+y.accountCode);
                                        if(y.accountCode == 'Select One'){
                                            y.accountCode = '';
                                            //y.covered = '';

                                        }
                                        // if(y.covered!='' && y.covered!=null)
                                        // coveredvalue = '';
                                        //partComp.Covered__c = Decimal.valueOf(y.covered);
                                        /*  if(y.covered==null){
                                            coveredvalue= '';
                                        }*/

                                        //y.covered = integer.valueof(coveredvalue);
                                        system.debug('covered Value'+y.covered);
                                        if(y.covered != null && y.covered != '')
                                            coveredValueDec = decimal.valueof(y.covered);
                                        else
                                            coveredValueDec = null;

                                        system.debug('coveredValueDec'+coveredValueDec);

                                       // CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,Fail_Code__c=y.FailCode,FailurepartId__c=y.compParentId,selected_part__c = y.partChildCheckbox,Css_Estimate__c = y.partEstimateCheckbox,Replacement_Reason__c=(y.partChildCheckbox== true ? y.replacementReason : ''),Quantity__c=y.qty,Notes__c=y.notes,ReturnToFactory__c=y.returnToFactory,Covered__c=coveredValueDec,Account_Code__c=y.accountCode,OEM__c=y.oem,Service_partnumber__c=y.servicePartNumber);
                                        CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,Fail_Code__c=y.FailCode,FailurepartId__c=y.compParentId,selected_part__c = y.partChildCheckbox,Css_Estimate__c = y.partEstimateCheckbox,Replacement_Reason__c=y.replacementReason,Quantity__c=y.qty,Notes__c=y.notes,ReturnToFactory__c=y.returnToFactory,Covered__c=coveredValueDec,Account_Code__c=y.accountCode,OEM__c=y.oem,Service_partnumber__c=y.servicePartNumber);
                                       //Removed (y.partChildCheckbox== true ? y.replacementReason : '') and added Replacement_Reason__c=y.replacementReason -condition as per defect #GSSC-562
                                        partslst.add(partComp);
                                        system.debug('nisha partComp'+partComp);
                                        //story 111469    
                                        setPartsRelatedsolCompid.add(y.compParentId);
                                        //End 111469    
                                        System.debug('partslst inside for :'+partslst); 
                                    }
                                }
                            }
                        }
                    }
                }
            }
            list<CSS_Solution_Component__c> lstUpdateSolComp = new list<CSS_Solution_Component__c>();
            map<id,list<CSS_Parts_Options__c>> mapSolCompToParts=new map<id,list<CSS_Parts_Options__c>>();
            //if(setPartsRelatedsolCompid != null && setPartsRelatedsolCompid.size() > 0){
            /*mapSolutionComponent =  new map<id,CSS_Solution_Component__c>( [SELECT id,Selected_Component__c
                                        FROM   CSS_Solution_Component__c
                                        WHERE id in : setPartsRelatedsolCompid]);*/
            for(CSS_Parts_Options__c prts :partslst){
                if(mapSolCompToParts != null && !mapSolCompToParts.containsKey(prts.FailurepartId__c)){
                    mapSolCompToParts.put(prts.FailurepartId__c, new list<CSS_Parts_Options__c>());
                }
                mapSolCompToParts.get(prts.FailurepartId__c).add(prts);
            }
            system.debug('mapSolCompToParts--->'+mapSolCompToParts);
            if(mapSolCompToParts != null && mapSolCompToParts.size() >0){
                //integer count = 0;
                for(Id solCompId : mapSolCompToParts.keySet()){
                    integer count = 0;
                    for(CSS_Parts_Options__c partsOp : mapSolCompToParts.get(solCompId)){
                        if(partsOp.selected_part__c){
                            CSS_Solution_Component__c cmp = new CSS_Solution_Component__c();
                            cmp.id = solCompId;
                            cmp.Selected_Component__c = true;
                            lstUpdateSolComp.add(cmp);
                            break;
                        }
                        else{
                            count = count + 1;
                        }
                    }
                    system.debug('mapSolCompToParts--->'+mapSolCompToParts.get(solCompId).size());
                    system.debug('count--->'+count);
                    if(mapSolCompToParts.get(solCompId).size() == count){
                        CSS_Solution_Component__c cmp = new CSS_Solution_Component__c();
                        cmp.id = solCompId;
                        //cmp.Selected_Component__c = false;
                        lstUpdateSolComp.add(cmp);
                    }
                }
            }

            // }
            system.debug('partsLst-->'+partsLst);
            if(partslst.size()>0) {
                List<CSS_Parts_Options__c> partsEPRFlag = new List<CSS_Parts_Options__c>();
                partsEPRFlag = CSS_FN_SIEBEL.getPartsReturn(partslst);
                for(CSS_Parts_Options__c selParts : partslst){
                    if(selParts.Id != null){
                        for(CSS_Parts_Options__c eprParts : partsEPRFlag){
                            if(selParts.Id == eprParts.Id){
                                selParts.ReturnToFactory__c = eprParts.ReturnToFactory__c;
                                break;
                            }                            
                        }
                    }
                }
                update partslst;
            }
            if(lstUpdateSolComp != null && lstUpdateSolComp.size() > 0){
                system.debug('lstUpdateSolComp'+lstUpdateSolComp);
                update lstUpdateSolComp;
            }

            System.debug('partslst-->'+partslst);
        }catch(exception e){
            system.debug('Entered into catch block of save parts method in css_srt parts class' + e.getmessage() + ' ' + e.getLineNumber());
        }

        pageReference ReturnPage = ApexPages.currentPage(); 
        return ReturnPage;
    } 





    public class srtsolWrapper{
        public Id solIds {get;set;}
        public string solName {get;set;}
        public string solTitle {get;set;}
        public list<srtCompWrapper> compWrapper {get;set;}
        public Integer allParts {get;set;}
        public Integer solcompCount {get;set;}
        public Id ParentSolId {get;set;} //Kalpana story 117210 display Parent Solution Name for a Nested Solution
        public String ParentSolName {get;set;} //Kalpana story 117210 display Parent Solution Name for a Nested Solution
        public srtsolWrapper(Id solIds,string solName,string solTitle,list<srtCompWrapper> compWrapper,Integer allParts,Integer solcompCount, Id ParentSolId, string ParentSolName){
            this.solIds= solIds;
            this.solName=solName;
            this.solTitle=solTitle;
            this.compWrapper = compWrapper;
            this.allParts = allParts;
            this.solcompCount = solcompCount;
            this.ParentSolId = ParentSolId; 
            this.ParentSolName = ParentSolName;
        }
    }


    public class srtCompWrapper{
        public Id CompIds {get;set;}
        public string compName {get;set;}
        public string solName {get;set;}
        public string solTitle {get;set;}
        public integer count {get;set;}
        //KAL
        public string FailCode {get;set;}
        public string FailCodeEditable {get;set;}
        public string AccountCode {get;set;}
        public string AccountCodeEdit {get;set;}

        public list<srtPartWrapper> partWrapper {get;set;}
        public srtCompWrapper(Id CompIds,string compName,string solName,string solTitle,string FailCode,string FailCodeEditable,string AccountCode,string AccountCodeEdit,list<srtPartWrapper> partWrapper,integer count){
            this.CompIds= CompIds;
            this.compName = compName;
            this.solName=solName;
            this.solTitle=solTitle;
            this.count=count;
            this.FailCode=FailCode;
            this.FailCodeEditable=FailCodeEditable;
            this.AccountCode=AccountCode;
            this.AccountCodeEdit=AccountCodeEdit;
            this.partWrapper = partWrapper;

        }
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
    public class srtPartWrapper{
        public Integer partRowCount{get;set;}
        public Id partIds {get;set;}
        public Id compParentId {get;set;}
        public boolean partChildCheckbox {get;set;}
        public boolean partEstimateCheckbox {get;set;}
        public string servicePartNumber {get;set;}
        public string partName {get;set;}
        public string partDesc {get;set;}
        public string covered {get;set;}
        public string accountCode {get;set;}
        public string returnToFactory {get;set;}
        public string optionNumber{get;set;}
        public integer qty {get;set;}
        public string partSize{get;set;}
        public String replacementReason {get;set;}
        public String notes {get;set;}
        public String oem {get;set;}
        public List<string> lstAccountCodes {get;set;}
        public String failCode {get;set;}
        public List<selectOption> accCodes {get;set;}
        public srtPartWrapper(Integer partRowCount, Id partIds,Id compParentId,boolean partChildCheckbox,boolean partEstimateCheckbox,string servicePartNumber,string partName,string partDesc,string covered,string accountCode,string returnToFactory,string optionNumber,Integer qty,string partSize,String replacementReason,string notes,String oem,List<selectOption> accCodes,String failCode){
            this.partRowCount = partRowCount;
            this.partIds=partIds;
            this.compParentId = compParentId;
            this.partChildCheckbox = partChildCheckbox;
            this.partEstimateCheckbox = partEstimateCheckbox;
            this.servicePartNumber= servicePartNumber;
            this.partName = partName;
            this.partDesc=partDesc;
            this.covered=covered;
            this.accountCode=accountCode;
            this.returnToFactory=returnToFactory;
            this.optionNumber=optionNumber;
            this.qty = qty;
            this.partSize=partSize;
            this.replacementReason = replacementReason;
            this.notes=notes;
            this.oem = oem;
            //this.lstAccountCodes = lstAccountCodes;
            this.accCodes = accCodes;
            this.failCode = failCode;
        }
    }

    public list<string> lstAccountCodes{get;set;}
    public List<SelectOption> accCodes{get;set;}

    /*public void getAccountCodes() {
        try{
            lstAccountCodes = new list<String>();

            string orgtype=css_utility.getOrgType(userinfo.getUserId());
            //public css_job_order__c  workJob;
            system.debug('PageID'+pgId);
            string Location = [select Creator_Location__c from CSS_Job_Order__c where id = :pgId].Creator_Location__c;
            Account Regionterritory = css_utility.getRegionTerritory(Location);

            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;

            system.debug('orgtype--->'+orgtype);
            //system.debug('Regionterritory--->'+Regionterritory.Region__c);
            system.debug('userRole--->'+userRole);

            jobEventTemp = new List<CSS_JobEventTemporary__c>();

            if(userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE')) 
            {
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Account_Code__c  FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            else{ 
                if (orgtype=='DISTR'){
                    system.debug('Inside DISTR');
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Account_Code__c  FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                }
                else{
                    if(Regionterritory != null && Regionterritory.Region__c != null && Regionterritory.Region__c != '' && Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Account_Code__c  FROM CSS_JobEventTemporary__c WHERE Attribute7__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Account_Code__c  FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                }
            }



            /*
            system.debug('JobTemp***'+jobEventTemp);
            if(jobEventTemp.size() > 0){
                system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
                system.debug('jobEventTempData-->'+jobEventTemp);
                accCodes = new List<SelectOption>();
                accCodes.add(new SelectOption('Select One','Select One'));

                for(CSS_JobEventTemporary__c j : jobEventTemp){
                    string s = j.Attribute2__c+' '+ j.Attribute3__c;
                    accCodes.add(new SelectOption(j.Attribute2__c,s));
                    //lstAccountCodes.add(j.Attribute2__c);
                    lstAccountCodes.add(s);
                }
            }
*/
            //getAccountCodes1();
          /*  system.debug('KAL--->'+jobEventTemp);
            system.debug('lstAccountCodes--->'+lstAccountCodes);
        }
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage() + ex.getLineNumber());

        }

    }//end of buildConcatenatedFailCodes method*/
    //story# 111470 end

    /* public List<selectOption> accountCodelistN(string pac, string compAC, string wsAC)
    {
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
accCodes = new List<SelectOption>();
        if(jobEventTemp.size() > 0){
            system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
            system.debug('jobEventTempData-->'+jobEventTemp);

            accCodes.add(new SelectOption('Select One','Select One'));

            for(CSS_JobEventTemporary__c j : jobEventTemp){
                string s = j.Attribute2__c+' '+ j.Attribute3__c;

                sortableSet.add(s); //Ed
                // accCodes.add(new SelectOption(s,s));
                //lstAccountCodes.add(j.Attribute2__c);
                //  lstAccountCodes.add(s);
            }
        }
        for(CSS_Solution_Component__c solcmp : SolCmps){
            /*    if(solcmp.AccountCode__c !=null &&  solcmp.AccountCode__c != '')
                     sortableSet.add(solcmp.AccountCode__c);
                if(solcmp.AccountCodeEdit__c !=null &&  solcmp.AccountCodeEdit__c != '')
                    sortableSet.add(solcmp.AccountCodeEdit__c); */
    /*  if(solcmp.CSS_Account_Formula__c !=null)
                sortableSet.add(solcmp.CSS_Account_Formula__c);
        }
        system.debug('sortableSet'+ sortableSet);
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {accCodes.add(new selectOption(s,s));  }   
        }
        return accCodes;  
    }*/

    /* public List<selectOption> accountCodelistN(string failcode)
    {
         lstSolComp = new list<CSS_Solution_Component__c>();
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
accCodes = new List<SelectOption>();
         accCodes.add(new SelectOption('Select One','Select One'));
       if(failcode !='' && failcode != null){
            //lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c from CSS_Solution_Component__c where Service_Job__c =:wid and FailCode_Formula__c = :SelectedFailCode and AccountCodeEdit__c!=''];
            lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =:pgid and FailCode_Formula__c = :failcode and CSS_Account_Formula__c!='']; // AND CSS_Account_Formula__c!=''];
            system.debug('lstSolComp'+lstSolComp);
            system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
            // system.debug('lstSolCompsize'+lstSolComp[0].CSS_Account_Formula__c);
            if(lstSolComp != null && lstSolComp.size()!=0){
                for(CSS_Solution_Component__c solComp: lstSolComp){
                    system.debug('SolComp loop**'+solComp.CSS_Account_Formula__c);
                    if(solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null)
                        sortableSet.add(solComp.CSS_Account_Formula__c);

               }
            }
        system.debug('sortableSet'+ sortableSet);
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {accCodes.add(new selectOption(s,s));  }   
        }

    }
         return accCodes;  
} */

    /*public void onChangeofAccountCode(){
        system.debug('SelectedAccountCode>>>>>>>>>>: '+SelectedAccountCode);
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('SelectedPartID>>>>>>>>>>: '+SelectedPartID);
        system.debug('listsrtsolWrapper--'+listsrtsolWrapper);
        system.debug('selectedPartRowCount-->'+selectedPartRowCount);
        string CoveredParAC ='';
        if(SelectedAccountCode!='Select One'){
         list<CSS_Solution_Component__c> lstSolComp1 = new list<CSS_Solution_Component__c>();
        lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c,AccountCodeEdit__c from CSS_Solution_Component__c where Service_Job__c =:pgId and (CSS_Account_Formula__c = :SelectedAccountCode and FailCode_Formula__c = :SelectedFailCode and CSS_Account_Formula__c!='') ];
             if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                for(srtsolWrapper sol:listsrtsolWrapper){
                    if(sol.compWrapper != null ){
                        for(srtCompWrapper s: sol.compWrapper){
                            if(s.partWrapper != null){
                                system.debug('s.partWrapper--->'+s.partWrapper);
                                for(srtPartWrapper prtslist: s.partWrapper){
                                    if(prtslist.partIds != null){
                        if(prtslist.partRowCount == selectedPartRowCount){
                            system.debug('Inside IF');
                            prtslist.accountCode =  String.valueof(SelectedAccountCode);
                            if(CoveredParAC!='' && integer.valueof(CoveredParAC) > 0 ){
                             CoveredParAC = '100';
                             } 
                           else if(CoveredParAC!='' && integer.valueof(CoveredParAC) == 0){
                            CoveredParAC = '0';

                           }
                          else{
                           CoveredParAC = '';
                           }
                             prtslist.covered=CoveredParAC;
                           system.debug('prtslist.covered'+prtslist.covered);
                        }  



                                }
                                }
                            }
                        }
                    }
                }
            }
    }


    } */

    /* public List<SelectOption> getAccountCodeDropDown() {
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        list<CSS_Solution_Component__c> lstSolCompacc = new list<CSS_Solution_Component__c>();
        system.debug('Inside method');
        try{
            lstSolCompacc = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c,AccountCodeEdit__c from CSS_Solution_Component__c where Service_Job__c =:pgid and (FailCode_Formula__c = :SelectedFailCode and CSS_Account_Formula__c!='')];
            system.debug('Solution Component--->'+lstSolCompacc);

            accCodesFailcode = new List<SelectOption>();
                accCodesFailcode.add(new SelectOption('Select One','Select One'));        
            if(lstSolCompacc.size()>0)
            {
                for(CSS_Solution_Component__c solcmp : lstSolCompacc){                
                if(solcmp.CSS_Account_Formula__c !=null)
                    sortableSet.add(solcmp.CSS_Account_Formula__c);
                }
                system.debug('sortableSet'+ sortableSet);
                if(sortableSet.size()>0){
                    sortable.AddAll(sortableSet);}
                sortable.sort();
                if (sortable.size()>0){
                    for(String s:sortable)    
                    {accCodesFailcode.add(new selectOption(s,s));  }   
                }

            }
        }catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage() + ex.getLineNumber());
        }

        return accCodesFailcode;
    }*/
    //Method for getting %coverd when we are chaning Account codes as per #105557 (RAJESH)
    public void onChangeofAccountCode(){
        system.debug('Method goining inside onChangeofAccountCode');
        system.debug('SelectedAccountCode>>>>>>>>>>: '+SelectedAccountCode);
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('SelectedPartID>>>>>>>>>>: '+SelectedPartID);
        system.debug('selectedPartRowCount-->'+selectedPartRowCount);
        system.debug('servicePartNumber-->'+servicePartNumber);
        string CoveredParAC ='';
        list<CSS_Solution_Component__c> lstSolComp1 = new list<CSS_Solution_Component__c>();
        if(SelectedAccountCode!='Select One'){
            lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c,AccountCodeEdit__c,CampaignPartsPercentage__c,selected_component__c,type__C from CSS_Solution_Component__c where Service_Job__c =:pgid and (CSS_Account_Formula__c = :SelectedAccountCode and FailCode_Formula__c = :SelectedFailCode and CSS_Account_Formula__c!='') ];
            //   lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c,AccountCodeEdit__c from CSS_Solution_Component__c where Service_Job__c =:wid and CSS_Account_Formula__c = :SelectedAccountCode AND CSS_Account_Formula__c!='' ];
            system.debug('lstSolComp1'+lstSolComp1);
            //system.debug('SelectedFailCode1>>>>>>>>>>: '+lstSolComp1[0].FailCode_Formula__c);
            system.debug('lstSolComp1size'+lstSolComp1.size());
            if(lstSolComp1!=null && lstSolComp1.size()!=0){
                //system.debug('listpartWrapper-->'+listpartWrapper);
                
                if(lstSolComp1[0].CoveredPartsQty__c!=null && lstSolComp1[0].CoveredPartsQty__c!='' && lstSolComp1[0].selected_component__c == true)
                    CoveredParAC =  lstSolComp1[0].CoveredPartsQty__c; 
                else if(lstSolComp1[0].CampaignPartsPercentage__c!=null && lstSolComp1[0].CampaignPartsPercentage__c!='' && (lstSolComp1[0].Type__c == 'TRP' || lstSolComp1[0].Type__c == 'ATC' || lstSolComp1[0].Type__c == 'CAMPAIGN'))
                    CoveredParAC =  lstSolComp1[0].CoveredPartsQty__c; 
                    
                if(CoveredParAC!='' && integer.valueof(CoveredParAC) > 0 ){
                    CoveredParAC = '100';
                } 

                else if(CoveredParAC!='' &&  CoveredParAC!=null && integer.valueof(CoveredParAC) == 0){
                    CoveredParAC = '0';

                }
                else{
                    CoveredParAC = '';
                }
                system.debug('CoveredParAC>>>>'+CoveredParAC);

                if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                    system.debug('firstforloop');
                    for(srtsolWrapper sol:listsrtsolWrapper){
                        if(sol.compWrapper != null ){
                            for(srtCompWrapper s: sol.compWrapper){
                                if(s.partWrapper != null){
                                    system.debug('s.partWrapper--->'+s.partWrapper);
                                    for(srtPartWrapper prtslist: s.partWrapper){
                                        if(prtslist.partIds != null){                                            
                                            if(prtslist.partRowCount == selectedPartRowCount && prtslist.servicePartNumber == servicePartNumber){
                                                system.debug('Inside IF');
                                                prtslist.returnToFactory = '';
                                                prtslist.accountCode =  String.valueof(SelectedAccountCode);
                                                system.debug('prtslist.accountCode '+prtslist.accountCode);
                                                if((prtslist.accountCode == null ||prtslist.accountCode == '' || prtslist.accountCode == 'Select One')){
                                                    prtslist.covered='';                                                    
                                                }
                                                else
                                                    prtslist.covered=CoveredParAC;
                                            }  
                                            system.debug('covered'+CoveredParAC);                                        


                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } 
            else{
                system.debug('elselooop');
                if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                    for(srtsolWrapper sol:listsrtsolWrapper){
                        if(sol.compWrapper != null ){
                            for(srtCompWrapper s: sol.compWrapper){
                                if(s.partWrapper != null){
                                    system.debug('s.partWrapper--->'+s.partWrapper);
                                    for(srtPartWrapper prtslist: s.partWrapper){
                                        if(prtslist.partIds != null){                                            
                                            if(prtslist.partRowCount == selectedPartRowCount && prtslist.servicePartNumber == servicePartNumber){
                                                system.debug('Inside IF');
                                                system.debug('prtslist.accountCode '+prtslist.accountCode);
                                                prtslist.accountCode =  String.valueof(SelectedAccountCode);
                                                prtslist.returnToFactory = '';
                                                if(CoveredParAC!='' && CoveredParAC!=null && integer.valueof(CoveredParAC) > 0 ){
                                                    CoveredParAC = '100';
                                                } 
                                                else if(CoveredParAC!='' && integer.valueof(CoveredParAC) == 0){
                                                    CoveredParAC = '0';

                                                }
                                                else{
                                                    CoveredParAC = '';
                                                }
                                                prtslist.covered=CoveredParAC;
                                                system.debug('prtslistcovered>>>>>'+prtslist.covered);
                                            }  



                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
        else  {
            CoveredParAC='';            
            if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                for(srtsolWrapper sol:listsrtsolWrapper){
                    if(sol.compWrapper != null ){
                        for(srtCompWrapper s: sol.compWrapper){
                            if(s.partWrapper != null){
                                system.debug('s.partWrapper--->'+s.partWrapper);
                                for(srtPartWrapper prtslist: s.partWrapper){
                                    if(prtslist.partIds != null){
                                        if(prtslist.partRowCount == selectedPartRowCount && prtslist.servicePartNumber == servicePartNumber){
                                            system.debug('Inside IF');
                                            system.debug('prtslist.accountCode '+prtslist.accountCode);
                                            prtslist.accountCode =  String.valueof(SelectedAccountCode);
                                            prtslist.covered='';
                                            prtslist.returnToFactory = '';
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }         
        }
    }
}