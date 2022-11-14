public class CG_CL_GSQParts {
    public CSS_getPartsListSRTRequestJ2A PartsSRTREq;
    public Boolean isReturnwaiver{get;set;}
    public map<Id,string>failidmap {get; set;}
    public map<id, string> solutionmap{get;set;}
    public boolean chkReqField{get;set;}
    public boolean srtpb{get;set;}
    public Id compSolId{get;set;}
    public Id pgId{get;set;}
    public CSS_Claims__c claimRec{get; set;}
    public list<CSS_Solutions__c> solutiondetails{get; set;}
    public List<CSS_Solution_Component__c> SolCmps;
    public Id recTypeIdpart {get; set;} 
    public List<srtsolWrapper> listsrtsolWrapper {get;set;} 
    public List<srtCompWrapper> listsrtCompWrapper {get;set;} 
    public list<srtPartWrapper> lstsrtPartWrapper{get;set;}
    public List<srtsolWrapper> listsrtsolWrapperDisp {get;set;} 
    public String ParentSol;
    map<id,boolean> mapSolutionCompToSelComp = new map<id,boolean>();
    public list<string> lstAccountCodes{get;set;}
    public List<SelectOption> accCodes{get;set;}
    public List<CSS_JobEventTemporary__c> jobEventTemp;
    Set<CSS_Parts_Options__c> partsset = new Set<CSS_Parts_Options__c>();
    List<CSS_Parts_Options__c> partslst = new List<CSS_Parts_Options__c>();
    public list<CSS_Parts_Options__c> existPartList{get; set;}
    public String SelectedAccountCode{get;set;}
    public Integer selectedPartRowCount{get;set;}
    public String servicePartNumber{get;set;}
    public String SelectedFailCode{get;set;}
    public integer  SelectedPartID{get;set;}
    public boolean isDealer;
    public boolean isFactory {get; set;}
    public String errorMsg {get;set;}
    public Boolean errMSG{get;set;}
    public Integer selectedPart{get;set;}
    public Boolean unitPriceField{get;set;}
    public String coverageType;
    public Map<String,Set<String>> failAccountCodeMap{get;set;}
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
    public Boolean dealerLocation{get; set;}
    public Boolean partsODMMesasgeflag;
    public Set<String> errMsgLst{get;set;}
    public List<String> errMsgLstNew{get;set;} 
    public List<CSS_Solution_Component__c> solsCompNew = new List<CSS_Solution_Component__c>();
    public decimal ConsolidateTemptotal{get;set;}
    CSS_Claims__c  claimrecord;
    public CG_CL_GSQParts(){
        //errorMsg='';
        integer i = ApexPages.CurrentPage().getParameters().size();
        system.debug('QueryString--'+i);
        JETFA = new list<CSS_JobEventTemporary__c>();
        JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c,Account_Code__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
        if(i>0){
            pgId = ApexPages.CurrentPage().getParameters().get('id');
            solsCompNew = [SELECT  Id, Name,FailCode_Formula__c,Fail_Code_Editable__c,CoveredPartsQty_Percentage__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c,Selected_Component__c, CSS_Account_Formula__c,Solutions__r.Name ,Solutions__r.Solution_title__c,Unique_Component__c,
                           (Select id,Option_Number__c,Tracking_Number__c,RID__c,Service_Job__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,ReturnToFactory__c,ReturnWaiver__c,Fail_Code__c,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c,Unit_Price__c,Sell_Price__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary')
                           from CSS_Solution_Component__c where CSS_Claims__c =:pgId and type__C NOT IN ('TRP','ATC','Campaign')]; 

            getAccountCodes();
            getfailcodeDropDown();
            getPartsList();

        }
        //Below code is added for Story # 161010
        isDealer = false;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType!=null && userType!= '') {
                if(userType == 'DLR') {
                    isDealer = true;
                }else if(userType == 'DISTR') {
                    isDealer = false;
                }
            } 

        }
        isFactory = false;
        User usr = css_utility.getUserAttributes(userinfo.getUserId());
        string userRole = usr.UserRoleName__c;
        if(userrole.contains('Factory'))
            isFactory = true;
        system.debug('****pgId*****'+pgId);
        // below code for checking dealer location from utility class as per story #176379 Kung Fu Panda sprint,-By RAJESH 11th Mar 2019
        dealerLocation = false;
        if(pgId!=null){
            claimrecord=[SELECT Id, Location_Code__c, Account__c, Account__r.type, Location__c FROM CSS_Claims__c where id=:pgId];
            system.debug('****claimrecord****'+claimrecord);
            if(claimrecord!=null){
                string claimLocation=claimrecord.Location_Code__c;
                if(claimLocation!=null){
                    if(claimrecord.Account__c != null && claimrecord.Account__r.type != null && claimrecord.Account__r.type == 'Dealer Account')
                        dealerLocation = true;
                    //String locationcode = css_Utility.dealerUserLocation(claimLocation);
                    //if(locationcode!=null && locationcode!='' ){
                    //  if(locationcode=='true')
                    //   dealerLocation=true;
                    //else
                    //dealerLocation=false;
                    //}
                }
            }
        }
        //End
    }
    public boolean trackingNumberBoo{get; set;}
    public void enableTrackingNumber1(){
        system.debug('****In side Method***');
        system.debug('****isReturnwaiver***'+isReturnwaiver);
        system.debug('****listsrtsolWrapper***'+listsrtsolWrapper);
        system.debug('****listsrtsolWrapper.size()***'+listsrtsolWrapper.size());
        trackingNumberBoo=false;
        errMSG = false;
        if(isReturnwaiver){
            if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                for(srtsolWrapper parentWarrper:listsrtsolWrapper){
                    for(srtCompWrapper comchildWrapper:parentWarrper.compWrapper){
                        for(srtPartWrapper subchild:comchildWrapper.partWrapper){
                            if(subchild.partRowCount==selectedPart){
                                system.debug('inside child wrapper');
                                subchild.returnWaiver='true';
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    public void getPartsList(){
        try{
            ConsolidateTemptotal =0.00;
            system.debug('pgId- Get parts List-'+pgId);
            system.debug('Calling from GSQ');
            //getAccountCodes();
            chkReqField = false;
            //pgId = ApexPages.CurrentPage().getParameters().get('id');
            PartsSRTREq = new CSS_getPartsListSRTRequestJ2A(); 
            failidmap = new map<Id,string>();
            solutionmap = new map<id, string>();
            srtpb =false;
            claimRec = [Select id,CSS_Job__c,Dealer_Service_Job__c from CSS_Claims__c where id= :pgId];
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
            /*solutiondetails = [Select id,Name,Solution_title__c,CSS_Nested_Solutions__c,
                       (Select id,name,Selected_Component__c,Component_Id__c,Service_Job__c,Solutions__c,Solutions__r.Name ,Solutions__r.Solution_title__c,Fail_Code__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c,FailCode_Formula__c from CSS_Solution_Components__r where Solutions__r.Diagnostic_Response__c='Most likely the solution' ),
                       (Select id,Option_Number__c,Service_Job__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,ReturnToFactory__c,Fail_Code__c,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary' order by Part_Name__c)
                       from CSS_Solutions__c where Diagnostic_Response__c='Most likely the solution' and Service_Job__c = 'a093B000000r7f1QAA' order by LastModifiedDate desc];
    system.debug('SolutionDetails**'+solutiondetails);*/

            //defect 191849 
            Map<String, String> accCodeCovTypeMap = new Map<String, String>();
            for(CSS_JobEventTemporary__c jet : [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes']){
                if(!accCodeCovTypeMap.containsKey(jet.Attribute3__c)){
                    accCodeCovTypeMap.put(jet.Attribute3__c, jet.Attribute1__c);
                }
            }


            if(pgId != null) {
                //Added CSS_Claims__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c in below query as part of the story GSSC-138
                if(claimRec.CSS_Job__c!=null){
                    SolCmps = [SELECT  Id, Name,Type__c,CampaignPartsPercentage__c,FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty_Percentage__c,Covered_Parts__c,CoveredPartsQty__c,Fail_Code__c,Selected_Component__c, CSS_Account_Formula__c,Solutions__r.Name ,Solutions__r.Solution_title__c,Unique_Component__c,
                               (Select id, ExpenseTotal__c, CSS_Claims__c, Option_Number__c,Tracking_Number__c,RID__c,Service_Job__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,ReturnToFactory__c,ReturnWaiver__c,Fail_Code__c,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c, CoverageLimitExceedMsg__c, CoverageLimitExceedMsg_Status__c, RecordTypeId, Parts_Type__c,Unit_Price__c,Sell_Price__c, Get_Fail_Code_Formula__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary')
                               from CSS_Solution_Component__c where CSS_Claims__c =:pgId];}
                else{
                    SolCmps = [SELECT  Id, Name,Type__c,CampaignPartsPercentage__c,FailCode_Formula__c,Fail_Code_Editable__c,Covered_Parts__c,CoveredPartsQty_Percentage__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c,Selected_Component__c, CSS_Account_Formula__c,Solutions__r.Name ,Solutions__r.Solution_title__c,Unique_Component__c,
                               (Select id, ExpenseTotal__c, CSS_Claims__c, Option_Number__c,Tracking_Number__c,RID__c,Service_Job__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,ReturnToFactory__c,ReturnWaiver__c,Fail_Code__c,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c, CoverageLimitExceedMsg__c, CoverageLimitExceedMsg_Status__c, RecordTypeId, Parts_Type__c,Unit_Price__c,Sell_Price__c, Get_Fail_Code_Formula__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary')
                               from CSS_Solution_Component__c where CSS_Claims__c =:pgId and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')]; 
                }

                /*   existPartList = [SELECT Id, Notes__c, OEM__c, Tracking_Number__c, FailurepartId__c,RID__c,Quantity__c, Selected_part__c, Replacement_Reason__c, Part_Name__c, 
                     Service_partnumber__c, Service_Job__c, Assignment__c, Part_Description__c, Option_Number__c, FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c,
                     Part_size__c, ReturnToFactory__c, Fail_Code__c, Account_Code__c, Covered__c
                     FROM CSS_Parts_Options__c WHERE CSS_Claims__c =:pgId];*/
                //GSSC-138 - Start
                List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
                for(CSS_Solution_Component__c sc : SolCmps){
                    for(CSS_Parts_Options__c p : sc.CSS_Parts_Options__r){
                        partsList.add(p);
                    }  
                }
                
                Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
                css_utility controller = new css_utility();
                mapPartsList = controller.displayParts(partsList);
                //GSSC-138 - End
                
                User u = css_utility.getUserAttributes(userinfo.getUserId()); 
                string lang = u.LanguageLocaleKey;

                datetime systemDate = System.now();
                string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00'; 

                Id recTypeIdoption = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
                recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');

                system.debug('SolCmps--'+SolCmps);
                errMsgLstNew = new List<String>();
                //Code for Service Parts - Start.
                if(SolCmps!=null){  
                    Integer i=1;
                    listsrtsolWrapper= new list<srtsolWrapper>();
                    for(CSS_Solution_Component__c c: SolCmps){
                        Integer partscount = 0;
                        Integer compCount = 0;
                        listsrtCompWrapper= new list<srtCompWrapper>();
                        if(c != null){
                            system.debug('Inside IF');
                            //Kalpana story 117210 display Parent Solution Name for a Nested Solution START
                            /*if(sol.CSS_Nested_Solutions__c != null){
                    ParentSol = [Select id, Name from css_solutions__c where id = :sol.CSS_Nested_Solutions__c].Name;
                    system.debug('ParentSol**'+ParentSol);
                }
                else ParentSol = '';*/
                            //Kalpana story 117210 display Parent Solution Name for a Nested Solution END
                            //system.debug('serviceJobdetails.CSS_Solution_Components__r--> '+sol.CSS_Solution_Components__r);
                            //for(CSS_Solution_Component__c c : sol.CSS_Solution_Components__r ){

                            //story 111469
                            mapSolutionCompToSelComp.put(c.id,c.Selected_Component__c);
                            //End Story 111469
                            system.debug('Anirudh components'+c);
                            boolean componentspart = false;
                            Integer compPartsCount = 0;
                            compCount = compCount + 1;
                            lstsrtPartWrapper = new list<srtPartWrapper>();
                            //if(c.Solutions__c == sol.id){

                            system.debug('serviceJobdetails.CSS_Solution_Components__r-->2 '+c);
                            system.debug('serviceJobdetails.CSS_Solution_Components__r-->2 '+c.CSS_Parts_Options__r);
                            //system.debug('serviceJobdetails.CSS_Parts_Options__r--> '+sol.CSS_Parts_Options__r);
                            // if(c.CSS_Parts_Options__r != null){
                            //system.debug('KALAccountCode***'+sol.CSS_Parts_Options__r);
                            //Integer i=1;
                            for(CSS_Parts_Options__c p : c.CSS_Parts_Options__r){
                                //if(c.Id == p.FailurepartId__c){
                                //if(p.Solutions__c==sol.id ){

                                compPartsCount = compPartsCount+1;
                                componentspart = true;
                                //}
                                system.debug('serviceJobdetails.CSS_Parts_Options__r-->2 '+p);
                                //system.debug('y.id--> '+c.id);
                                system.debug('p.FailurepartId__c --> '+p.selected_part__c);
                                system.debug('KalAccountCodes'+lstAccountCodes);
                                if(p.FailurepartId__c == c.id){// && c.Selected_Component__c == true){
                                    partscount=partscount+1;
                                    system.debug(' ***'+p.Account_Code__c);
                                    string failcodetemp;
                                    string accountcodetemp;

                                    //Setting the failcode value
                                    system.debug('****p.Fail_Code__c***'+p.Fail_Code__c);
                                    system.debug('****c.FailCode_Formula__c***'+c.FailCode_Formula__c);
                                    if(p.Fail_Code__c!='' && p.Fail_Code__c!=null){
                                        failcodetemp = p.Fail_Code__c;

                                    }
                                    else
                                    {
                                        failcodetemp =c.FailCode_Formula__c;

                                    }
                                    //Setting Accountcode value.
                                    system.debug('****p.Account_Code__c***'+p.Account_Code__c);
                                    system.debug('****c.CSS_Account_Formula__c***'+c.CSS_Account_Formula__c);
                                    if(p.Account_Code__c!='' && p.Account_Code__c!=null)
                                        accountcodetemp=p.Account_Code__c;
                                    else
                                    {
                                        //Defect 191849
                                        String covtype = '';
                                        system.debug('accCodeCovTypeMap>>'+accCodeCovTypeMap);
                                        system.debug('CSS_Account_Formula__c>>'+c.CSS_Account_Formula__c.RIGHT(2));
                                        if(accCodeCovTypeMap != null && c.CSS_Account_Formula__c != null){
                                            covtype = accCodeCovTypeMap.get(c.CSS_Account_Formula__c.RIGHT(2));
                                        }
                                        system.debug('covtype>>'+covtype);
                                        /*if(c.Type__c != null && c.Type__c != '' && !c.Type__c.equalsignorecase('Campaign') && !c.Type__c.equalsignorecase('ATC') && !c.Type__c.equalsignorecase('TRP')){
                                        if(c.CampaignPartsPercentage__c != null && c.CampaignPartsPercentage__c != '' && double.valueof(c.CampaignPartsPercentage__c) > 0){
                                            accountcodetemp = c.CSS_Account_Formula__c;
                                        }
                                    }
                                    else{
                                        if(c.CoveredPartsQty__c != null && c.CoveredPartsQty__c != '' && double.valueof(c.CoveredPartsQty__c) > 0){
                                            accountcodetemp = c.CSS_Account_Formula__c;
                                        }
                                    }*/
                                        if(c.type__c != 'Campaign' && c.type__c != 'TRP' && c.type__c != 'ATC'){
                                            if((c.CoveredPartsQty__c != null && c.CoveredPartsQty__c != '' && double.valueof(c.CoveredPartsQty__c) > 0)|| (covtype == 'OTH' || covtype == 'POL')){
                                                accountcodetemp = c.CSS_Account_Formula__c;
                                            }
                                        }
                                        else{
                                            if(c.CampaignPartsPercentage__c != null && c.CampaignPartsPercentage__c != '' && double.valueof(c.CampaignPartsPercentage__c) > 0){
                                                accountcodetemp = c.CSS_Account_Formula__c;
                                            }
                                        }
                                    }
                                    system.debug('failcodetemp>>'+failcodetemp+'accountcodetemp>>>'+accountcodetemp);
                                    List<String> tempStr = new List<String>();
                                    if(failcodetemp != null && failcodetemp != '' && failcodetemp != 'Select One'){
                                        tempStr = failcodetemp.split('-'); 
                                    }
                                    String temp1;
                                    if(tempStr.size() > 0){
                                        temp1 = tempStr[tempStr.size()-1];
                                    }
                                    String temp = temp1+';;'+accountcodetemp;
                                    Boolean isPartsCovLimitExceedPWtemp;
                                    Boolean isPartsCovLimitExceedtemp;
                                    system.debug('temp'+temp);
                                    system.debug('p.CoverageLimitExceedMsg_Status__c'+p.CoverageLimitExceedMsg_Status__c);
                                    system.debug('accountcodetemp'+accountcodetemp);
                                    system.debug('accountcodetemp'+accountcodetemp);
                                    Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                                    if(p.CoverageLimitExceedMsg_Status__c == 'ERROR' && p.Parts_Type__c != 'Custom' && p.RecordTypeId == recTypeIdpart && p.selected_part__c == true){
                                        if(!p.CoverageLimitExceedMsg__c.contains(';;')){
                                            if(p.CoverageLimitExceedMsg__c.contains(accountcodetemp)){
                                                isPartsCovLimitExceedtemp = true;
                                            }
                                        }
                                        else{
                                            if(p.CoverageLimitExceedMsg__c.contains(temp)){
                                                isPartsCovLimitExceedtemp = true;
                                                isPartsCovLimitExceedPWtemp = true;
                                            }
                                            else{
                                                isPartsCovLimitExceedtemp = false;
                                                isPartsCovLimitExceedPWtemp = false;
                                            }
                                        }
                                    }
                                    if(isPartsCovLimitExceedtemp == true && isPartsCovLimitExceedPWtemp != true){
                                        if(!errMsgLstNew.contains(Label.CSS_CoverageLimitExceedMsg+' '+p.CoverageLimitExceedMsg__c)){
                                            errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg+' '+p.CoverageLimitExceedMsg__c);
                                        }
                                    }
                                    else if(isPartsCovLimitExceedtemp == true && isPartsCovLimitExceedPWtemp == true){
                                        if(!errMsgLstNew.contains(Label.CSS_CoverageLimitExceedMsg_PW1+' '+temp1+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+accountcodetemp)){
                                            errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg_PW1+' '+temp1+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+accountcodetemp);
                                        }
                                    }
                                    system.debug('isPartsCovLimitExceedtemp'+isPartsCovLimitExceedtemp);
                                    system.debug('isPartsCovLimitExceedPWtemp'+isPartsCovLimitExceedPWtemp);
                                    decimal price = 0.00;
                                    decimal totalprice = 0.00;
                                    //GSSC-138 - Start
                                    if(userinfo.getDefaultCurrency() == 'USD'){
                                        if(p.Unit_Price__c != null && p.Unit_Price__c != '')
                                            price = decimal.valueof(p.Unit_Price__c);
                                        
                                        if(p.Covered__c != null){
                                            totalprice= (p.Covered__c/100)*(p.Unit_Price__c!=null?Decimal.valueof(p.Unit_Price__c):0)*p.Quantity__c;
                                        }
                                    }
                                    else{
                                        Map<decimal, decimal> expTotalTempMap = mapPartsList.get(p.Id);
                                        Decimal unitPriceTemp; 
                                        if(expTotalTempMap != null){
                                            for(decimal up : expTotalTempMap.keyset()){
                                                unitPriceTemp = up;
                                            }
                                        }
                                        if(unitPriceTemp != null)
                                            price = unitPriceTemp;
                                        
                                        if(p.Covered__c != null){
                                            totalprice= (p.Covered__c/100)*(unitPriceTemp!=null?unitPriceTemp:0)*p.Quantity__c;
                                        }
                                    }
                                    price = price == 0 ? 0.00 : price;
                                    totalprice = totalprice == 0 ? 0.00 : totalprice;
                                    //GSSC-138 - End
                                    ConsolidateTemptotal +=totalprice;
                                    String coveredpercentPOL;
                                    string coveragetypewer;
                                    String covtype = '';
                                    system.debug('accCodeCovTypeMap>>'+accCodeCovTypeMap);
                                    system.debug('CSS_Account_Formula__c>>'+c.CSS_Account_Formula__c.RIGHT(2));
                                    if(accCodeCovTypeMap != null && c.CSS_Account_Formula__c != null){
                                        covtype = accCodeCovTypeMap.get(c.CSS_Account_Formula__c.RIGHT(2));
                                        system.debug('covtype'+covtype);
                                    }
                                   String coveredpercent;
                                   
                                  if(claimRec.CSS_Job__c!=null){
                                         system.debug('inside autoclaim');
                                        //karthik G added as part of GSSC57
                                        if(string.ValueOf(p.Covered__c)!=null && string.ValueOf(p.Covered__c)!='' && c.Covered_Parts__c!=null && c.Covered_Parts__c!=''){
                                            coveredpercentPOL=string.ValueOf(c.Covered_Parts__c);
                                            coveredpercent=string.ValueOf(p.Covered__c);
                                            system.debug('Testg23');
                                            if(covtype == 'OTH' || covtype == 'POL')//Defect GSSC-204 - Added if condition
                                            {
                                                system.debug('inside POL Account code');
                                                coveredpercent = coveredpercentPOL;
                                            }
                                        }
                                        else if(p.Fail_Code__c!='' && p.Fail_Code__c!=null && (p.Fail_Code__c=='Select One'||p.Account_Code__c=='Select One')){
                                            coveredpercentPOL ='';
                                            coveredpercent ='';
                                            system.debug('Testg232');
                                        }
                                        else
                                          coveredpercent=string.ValueOf(c.CoveredPartsQty_Percentage__c);
                                
                                        coveragetypewer = covtype;
                                        
                                         system.debug('coveredpercentPOL'+coveredpercentPOL);
                                        //karthikG
                                        lstsrtPartWrapper.add(new srtPartWrapper(i++,p.Id,p.FailurepartId__c,p.selected_part__c,p.Service_partnumber__c,p.Part_Name__c,p.Part_Description__c,coveredpercent,accountcodetemp,p.ReturnToFactory__c,string.ValueOf(p.ReturnWaiver__c),p.Option_Number__c,Integer.ValueOf(p.Quantity__c),p.part_size__c,p.Replacement_Reason__c ,p.Notes__c,p.OEM__c, accountCodelistN(failcodetemp),failcodetemp,p.Tracking_Number__c,p.RID__c,false,false,isPartsCovLimitExceedtemp,isPartsCovLimitExceedPWtemp,price,totalprice,false,coveragetypewer,coveredpercentPOL));
                                   system.debug('autoclaim lstsrtPartWrapper--> '+lstsrtPartWrapper);
                                        
                                    }
                                  else{
                                        
                                        if(string.ValueOf(p.Covered__c)!=null && string.ValueOf(p.Covered__c)!='' && c.Covered_Parts__c!=null && c.Covered_Parts__c!=''){
                                            coveredpercent=string.ValueOf(p.Covered__c);
                                            coveredpercentPOL=string.ValueOf(c.Covered_Parts__c);
                                            system.debug('Test1');
                                            if(covtype == 'OTH' || covtype == 'POL')//Defect GSSC-204 - Added if condition
                                            {
                                                system.debug('inside POL Account code');
                                                coveredpercent = coveredpercentPOL;
                                            }
                                        }    
                                        
                                        else if(p.Fail_Code__c!='' && p.Fail_Code__c!=null && (p.Fail_Code__c=='Select One'||p.Account_Code__c=='Select One')){
                                            coveredpercentPOL ='';
                                            coveredpercent=''; 
                                            system.debug('Test2');
                                        }
                                        else
                                            coveredpercent=string.ValueOf(c.CoveredPartsQty_Percentage__c);
                                        /*if(c.Covered_Parts__c!=null || c.Covered_Parts__c!=''){
                                            coveredpercentPOL=string.ValueOf(c.Covered_Parts__c);
                                            coveragetypewer = covtype;
                                        }*/
                                        coveragetypewer = covtype;
                                        system.debug('Inside Manual coveredpercent>>' + coveredpercent + ' coveredpercentPOL  ' + coveredpercentPOL);
                                        lstsrtPartWrapper.add(new srtPartWrapper(i++,p.Id,p.FailurepartId__c,p.selected_part__c,p.Service_partnumber__c,p.Part_Name__c,p.Part_Description__c,coveredpercent,accountcodetemp,p.ReturnToFactory__c,string.ValueOf(p.ReturnWaiver__c),p.Option_Number__c,Integer.ValueOf(p.Quantity__c),p.part_size__c,p.Replacement_Reason__c ,p.Notes__c,p.OEM__c, accountCodelistN(failcodetemp),failcodetemp,p.Tracking_Number__c,p.RID__c,false,false,isPartsCovLimitExceedtemp,isPartsCovLimitExceedPWtemp,price,totalprice,false,coveragetypewer,coveredpercentPOL));
                                        //lstsrtPartWrapper.add(new srtPartWrapper(i++,p.Id,p.FailurepartId__c,p.selected_part__c,p.Service_partnumber__c,p.Part_Name__c,p.Part_Description__c,coveredpercent,c.CSS_Account_Formula__c,p.ReturnToFactory__c,string.ValueOf(p.ReturnWaiver__c),p.Option_Number__c,Integer.ValueOf(p.Quantity__c),p.part_size__c,p.Replacement_Reason__c ,p.Notes__c,p.OEM__c, accountCodelistN(p.Account_Code__c,p.FailurepartId__r.CSS_Account_Formula__c,p.FailurepartId__r.AccountCode__c),c.FailCode_Formula__c,p.Tracking_Number__c,p.RID__c));
                                    }
                                  system.debug('lstsrtPartWrapper--> '+lstsrtPartWrapper);

                                }

                                //}
                            }
                            // }
                            if(componentspart == false){
                                partscount = partscount + 1;
                                lstsrtPartWrapper.add(new srtPartWrapper(0,null,null,false,'','','','',null,'','','',0,'','','','',null,'','','',false,false,false,false,0.0,0.0,false,'',''));

                                system.debug('Anirudh entered else');
                            }
                            system.debug('failcode****'+c.Fail_Code__c);
                            system.debug('failcode editable****'+c.Fail_Code_Editable__c);
                            listsrtCompWrapper.add(new srtCompWrapper(c.id,c.Name,c.Solutions__r.Name ,c.Solutions__r.Solution_title__c,c.Fail_Code__c,c.Fail_Code_Editable__c,c.AccountCode__c,c.AccountCodeEdit__c,lstsrtPartWrapper,compPartsCount));     
                            system.debug('compPartsCount--> '+compPartsCount); 


                            //}

                            //}

                        }

                        //listsrtsolWrapper.add(new srtsolWrapper(sol.id,sol.Name,sol.Solution_title__c,listsrtCompWrapper,partscount,compCount,sol.CSS_Nested_Solutions__c,ParentSol) );  
                        system.debug('listsrtCompWrapper--'+listsrtCompWrapper);
                        system.debug('partscount--'+partscount);
                        system.debug('compCount--'+compCount);
                        listsrtsolWrapper.add(new srtsolWrapper('','','',listsrtCompWrapper,partscount,compCount,'','') );  
                        //system.debug('listsrtsolWrapper-->'+listsrtsolWrapper);

                    }
                    system.debug('listsrtsolWrapper-->'+listsrtsolWrapper);
                }
                listsrtsolWrapperDisp=listsrtsolWrapper;
                system.debug('<<<<<<<< listsrtsolWrapper >>>>>>>>>>>>>>>>>> ' + listsrtsolWrapper);
            }
            system.debug('<<<<<<<< before returing  >>>>>>>>>>>>>>>>>>');
        }
        Catch(Exception ex){
            system.debug('Exception in Constructor--'+ex.getMessage()+ex.getLineNumber());
        }

    }

    public class srtsolWrapper{
        public string solIds {get;set;}
        public string solName {get;set;}
        public string solTitle {get;set;}
        public list<srtCompWrapper> compWrapper {get;set;}
        public Integer allParts {get;set;}
        public Integer solcompCount {get;set;}
        public string ParentSolId {get;set;} //Kalpana story 117210 display Parent Solution Name for a Nested Solution
        public String ParentSolName {get;set;} //Kalpana story 117210 display Parent Solution Name for a Nested Solution
        public srtsolWrapper(string solIds,string solName,string solTitle,list<srtCompWrapper> compWrapper,Integer allParts,Integer solcompCount, string ParentSolId, string ParentSolName){
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

    public class srtPartWrapper{
        public Integer partRowCount{get;set;}
        public Id partIds {get;set;}
        public Id compParentId {get;set;}
        public boolean partChildCheckbox {get;set;}
        public string servicePartNumber {get;set;}
        public string partName {get;set;}
        public string partDesc {get;set;}
        public string covered {get;set;}
        public string accountCode {get;set;}
        public string returnToFactory {get;set;}
        public string returnWaiver {get;set;}
        public string optionNumber{get;set;}
        public integer qty {get;set;}
        public string partSize{get;set;}
        public String replacementReason {get;set;}
        public String notes {get;set;}
        public String oem {get;set;}
        public List<string> lstAccountCodes {get;set;}
        public String failCode {get;set;}
        public List<selectOption> accCodes {get;set;}
        public String TrackingNumber {get;set;}
        public String RID {get;set;}
        public boolean failcodeMessage {get;set;}
        public boolean accountcodeMessage {get;set;}
        public Boolean isPartsCovLimitExceed{get; set;}
        public Boolean isPartsCovLimitExceedPW{get; set;}
        public Decimal UnitPrice{get;set;}
        public Decimal TotalPrice{get;set;}
        public Boolean trackingNumberReq{get;set;}
        public String coveragetypeval{get;set;}
        public String coveredpartsper{get;set;}
        public srtPartWrapper(Integer partRowCount, Id partIds,Id compParentId,boolean partChildCheckbox,string servicePartNumber,string partName,string partDesc,string covered,string accountCode,string returnToFactory,string returnWaiver,string optionNumber,Integer qty,string partSize,String replacementReason,string notes,String oem,List<selectOption> accCodes,String failCode,String TrackingNumber,String RID,Boolean failcodeMessage,Boolean accountcodeMessage, Boolean isPartsCovLimitExceed, Boolean isPartsCovLimitExceedPW,Decimal UnitPrice, Decimal TotalPrice, Boolean trackingNumberReq,String coveragetypeval, String coveredpartsper){
            this.partRowCount = partRowCount;
            this.partIds=partIds;
            this.compParentId = compParentId;
            this.partChildCheckbox = partChildCheckbox;
            this.servicePartNumber= servicePartNumber;
            this.partName = partName;
            this.partDesc=partDesc;
            this.covered=covered;
            this.accountCode=accountCode;
            this.returnToFactory=returnToFactory;
            this.returnWaiver=returnWaiver;
            this.optionNumber=optionNumber;
            this.qty = qty;
            this.partSize=partSize;
            this.replacementReason = replacementReason;
            this.notes=notes;
            this.oem = oem;
            //this.lstAccountCodes = lstAccountCodes;
            this.accCodes = accCodes;
            this.failCode = failCode;
            this.TrackingNumber = TrackingNumber;
            this.failcodeMessage = failcodeMessage;
            this.accountcodeMessage = accountcodeMessage;
            this.RID = RID;
            this.isPartsCovLimitExceed = isPartsCovLimitExceed;
            this.isPartsCovLimitExceedPW = isPartsCovLimitExceedPW;
            this.UnitPrice = UnitPrice;
            this.TotalPrice = TotalPrice;
            this.trackingNumberReq = trackingNumberReq;
            this.coveragetypeval = coveragetypeval;
            this.coveredpartsper = coveredpartsper;
        }
    }
    //Method for getting picklist values for Tracking Number as per 24 sprint #161414,-By RAJESH 04th Sec 2018
    public List<SelectOption> gettrackingNumber2(){
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption('Select One','Select One'));
        options.add( new SelectOption('Progressive Damage','Progressive Damage'));
        options.add( new SelectOption('Claim Refile','Claim Refile'));
        options.add( new SelectOption('Not Returned','Not Returned'));
        options.add( new SelectOption('EPR Restricted','EPR Restricted'));
        /* Schema.DescribeFieldResult fieldResult =  CSS_Parts_Options__c.Item__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry f : ple)
    {
        options.add(new SelectOption(f.getValue(),f.getLabel()));
    }  */     
        return options;
    }
    //End
    public List<selectOption> accountCodelistN(string selFailcode)
    {
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();

        accCodes = new List<SelectOption>();

        try{
            /*for(CSS_Solution_Component__c solcmp : SolCmps){

            if(solcmp.Type__c != null && solcmp.Type__c != '' && !solcmp.Type__c.equalsignorecase('Campaign') && !solcmp.Type__c.equalsignorecase('ATC') && !solcmp.Type__c.equalsignorecase('TRP')){
                if(solcmp.CSS_Account_Formula__c != null && solcmp.CSS_Account_Formula__c != '' && solcmp.CampaignPartsPercentage__c != null && solcmp.CampaignPartsPercentage__c != '' && double.valueof(solcmp.CampaignPartsPercentage__c) > 0){
                    sortableSet.add(solcmp.CSS_Account_Formula__c);
                }
            }
            else{
                if(solcmp.CSS_Account_Formula__c != null && solcmp.CSS_Account_Formula__c != '' && solcmp.CoveredPartsQty__c != null && solcmp.CoveredPartsQty__c != '' && double.valueof(solcmp.CoveredPartsQty__c) > 0){
                    sortableSet.add(solcmp.CSS_Account_Formula__c);
                }
            }
        }


        system.debug('sortableSet'+ sortableSet);
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {accCodes.add(new selectOption(s,s));  }   
        }*/
            system.debug('failAccountCodeMap***'+failAccountCodeMap);
            system.debug('selFailcode***'+selFailcode);
            if(selFailcode==null || failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || !failAccountCodeMap.containsKey(selFailcode)){
                system.debug('insideFCIFnull***');
                accCodes.add(new SelectOption('Select One','Select One'));
                return accCodes;
            }
            if(failAccountCodeMap.containsKey(selFailcode)){
                system.debug('**insidefailaccMap');
                Set<string> acCodeSet = failAccountCodeMap.get(selFailcode);
                if(acCodeSet.size()>0){
                    accCodes.add(new SelectOption('Select One','Select One'));
                    sortable.AddAll(acCodeSet);}
                else{
                    accCodes.add(new SelectOption('Select One','Select One'));
                }
                sortable.sort();
                if (sortable.size()>0){
                    for(String s:sortable){    
                        accCodes.add(new selectOption(s,s));                    
                    }   
                }
            }
            system.debug('***final ac options' + accCodes);
        }catch (System.NullPointerException e) {

            System.debug('e');  // can be assigned to a variable to display a user-friendly error message

        }
        return accCodes; 


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

    /*Place holder for story 175940--Prabhakar/Rupesh*/
    public void SPCheckboxChecked()
    {
        system.debug('GSQ parts Select Checkbox checked..');
	try{
        for(srtsolWrapper lstprt :listsrtsolWrapper)
        {

            for( srtCompWrapper cowpart:lstprt.compWrapper)
            {
                for(srtPartWrapper part:cowpart.partWrapper)
                {
                    if(part.partChildCheckbox==true)
                    {
                        part.replacementReason='GSQ Part';
                    }

                }
            }
        }
        system.debug('final listsrtsolWrapper:'+listsrtsolWrapper);
        
        }catch(exception ex){
            system.debug('Exception in SPCheckboxChecked--'+ex.getMessage()+' Line No:'+ex.getLineNumber());
        }

    }    



    public Boolean failAccCodeErrorMessage{get; set;}
    public void saveParts(){
        System.debug('save parts');
        errMSG = false;
        trackingNumberBoo=false;
        Boolean AccCodeErrorMessage;
        Boolean failCodeErrorMessage;
        set<Id> setPartsRelatedsolCompid = new set<Id>();
        partslst = new List<CSS_Parts_Options__c>();
        partsset = new set<CSS_Parts_Options__c>();
        set<boolean> setfailAccCodeErrorMessage = new set<boolean>();
        set<boolean> setTrackingNumReqErrorMessage = new set<boolean>();
        try{
            System.debug('listsrtsolWrapper-->'+listsrtsolWrapper);
            string coveredvalue;
            string replacementReason;
            decimal coveredValueDec;
            string TrackingNumber;
            if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                for(srtsolWrapper sol:listsrtsolWrapper){
                    if(sol.compWrapper != null ){
                        for(srtCompWrapper s: sol.compWrapper){
                            if(s.partWrapper != null){
                                system.debug('s.partWrapper--->'+s.partWrapper);
                                for(srtPartWrapper y: s.partWrapper){
                                    system.debug('ypartsid>>>>>>>>'+y.partIds);
                                    if(y.partIds != null){
                                        system.debug('errorMsg***'+errorMsg);
                                        system.debug('TrackingNumber Value'+y.TrackingNumber);
                                        system.debug('RID__c is'+y.RID);
                                        system.debug('returnWaiver Value'+y.returnWaiver);

                                        if(y.TrackingNumber=='Select One' && y.returnWaiver=='true' && y.partChildCheckbox==true){
                                            system.debug('*********entered***;');
                                            //errMSG = true;
                                            //trackingNumberBoo=true;
                                            y.TrackingNumberReq=true;
                                            setTrackingNumReqErrorMessage.add(true);
                                            system.debug('TrackingNumber if '+TrackingNumber);

                                        }
                                        else if((y.TrackingNumber=='Select One' || y.TrackingNumber=='' || y.TrackingNumber==null) && y.returnWaiver=='false' && y.partChildCheckbox==true && y.returnToFactory == 'Y'){
                                            system.debug('*********entered 2***;');
                                            //errMSG = true;
                                            //trackingNumberBoo=true;
                                            y.TrackingNumberReq=true;
                                            setTrackingNumReqErrorMessage.add(true);
                                            system.debug('TrackingNumber if2 '+TrackingNumber);

                                        }
                                        else if(y.TrackingNumber!='Select One' && y.TrackingNumber!='' && y.returnWaiver=='true' ){                                            
                                            TrackingNumber=y.TrackingNumber;
                                            //trackingNumberBoo=false;
                                            y.TrackingNumberReq=false;
                                            setTrackingNumReqErrorMessage.add(false);
                                        }
                                        else if(y.partChildCheckbox == false && (y.trackingNumber=='Select One' || y.trackingNumber=='' || y.trackingNumber==null)){
                                            y.TrackingNumberReq=false;
                                            setTrackingNumReqErrorMessage.add(false);
                                        }
                                        system.debug('covered Value'+y.covered);
                                        if(y.covered != null && y.covered != '')
                                            coveredValueDec = decimal.valueof(y.covered);
                                        else
                                            coveredValueDec = null;
                                        if(claimRec.CSS_Job__c!=null && isDealer==false){
                                            replacementReason = y.replacementReason;
                                        }
                                        else if(claimRec.CSS_Job__c!=null && isDealer==true)
                                        {
                                            if(y.partChildCheckbox==true && (y.replacementReason == null || y.replacementReason == '' || y.replacementReason=='Select One')){
                                                replacementReason = 'Refer to Narrative';
                                                y.replacementReason= 'Refer to Narrative';
                                            }
                                            else 
                                                replacementReason = y.replacementReason;

                                        }
                                        else{
                                            if(y.partChildCheckbox==true && (y.replacementReason == null || y.replacementReason == '' || y.replacementReason=='Select One')){
                                                replacementReason = 'Refer to Narrative';
                                                y.replacementReason= 'Refer to Narrative';
                                            }
                                            else 
                                                replacementReason = y.replacementReason;
                                        }

                                        system.debug('coveredValueDec'+coveredValueDec);
                                        system.debug('***y.partChildCheckbox***'+y.partChildCheckbox);
                                        system.debug('***y.failcode***'+y.failcode);
                                        system.debug('**y.accountCode***'+y.accountCode);
                                        if((y.accountCode == 'Select One' || y.accountCode == '' || y.accountCode ==null) && y.partChildCheckbox==true){
                                            system.debug('*****Inside if checking with Account codes');
                                            AccCodeErrorMessage=true;
                                            y.accountcodeMessage=false;
                                            setfailAccCodeErrorMessage.add(AccCodeErrorMessage);
                                        }
                                        if(y.failcode=='Select one' && y.partChildCheckbox==true){
                                            system.debug('*****Inside if checking with fail codes');
                                            failCodeErrorMessage=true;
                                            setfailAccCodeErrorMessage.add(failCodeErrorMessage);
                                        }
                                        CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(Id = y.partIds,FailurepartId__c=y.compParentId,selected_part__c = y.partChildCheckbox,Replacement_Reason__c=replacementReason,Quantity__c=y.qty,Notes__c=y.notes,ReturnToFactory__c=y.returnToFactory,Tracking_Number__c=y.TrackingNumber,RID__c=y.RID,Covered__c=coveredValueDec,Account_Code__c=y.accountCode,Fail_Code__c=y.failcode,OEM__c=y.oem,Service_partnumber__c=y.servicePartNumber,ReturnWaiver__c= y.returnWaiver == 'true' ? true : false);
                                        partsset.add(partComp);

                                        //story 111469    
                                        setPartsRelatedsolCompid.add(y.compParentId);
                                        //End 111469    
                                        System.debug('partslst inside for :'+partsset); 
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(setfailAccCodeErrorMessage.contains(true)){
                failAccCodeErrorMessage=true;
            }
            else{
                failAccCodeErrorMessage=false;
            }
            system.debug('failAccCodeErrorMessage***'+failAccCodeErrorMessage);
            if(setTrackingNumReqErrorMessage.contains(true)){
                errMSG=true;
            }
            else{
                errMSG=false;
            }
            system.debug('errMSG***'+errMSG);
            list<CSS_Solution_Component__c> lstUpdateSolComp = new list<CSS_Solution_Component__c>();
            map<id,list<CSS_Parts_Options__c>> mapSolCompToParts=new map<id,list<CSS_Parts_Options__c>>();
            for(CSS_Parts_Options__c prts :partslst){
                if(mapSolCompToParts != null && !mapSolCompToParts.containsKey(prts.FailurepartId__c)){
                    mapSolCompToParts.put(prts.FailurepartId__c, new list<CSS_Parts_Options__c>());
                }
                mapSolCompToParts.get(prts.FailurepartId__c).add(prts);
            }
            system.debug('mapSolCompToParts--->'+mapSolCompToParts);
            if(mapSolCompToParts != null && mapSolCompToParts.size() >0){
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
                    if(mapSolCompToParts.get(solCompId).size() == count){
                        CSS_Solution_Component__c cmp = new CSS_Solution_Component__c();
                        cmp.id = solCompId;
                        cmp.Selected_Component__c = false;
                        lstUpdateSolComp.add(cmp);
                    }
                }
            }

            if(partsset.size()>0){
                partslst.addAll(partsset);
            }
            system.debug('***before parts update failAccCodeErrorMessage***'+failAccCodeErrorMessage);
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            errMsgLst = new Set<String>();
            system.debug('errMSG'+errMSG);
            
            //Added below lines for GSSC-232 By Krishna.
            //if(partslst.size()>0 && failAccCodeErrorMessage==false && errMSG== false) {  // Defect 191532
                //update partslst;
            //}
            if(partslst.size()>0 && failAccCodeErrorMessage==false) {  
                update partslst;
            }
            //Added Above lines for GSSC-232 By Krishna.
            
            if(partslst != null && partslst.size() > 0){
                errMsgLst = contr.covLimitValidation(null, pgId, null, null);
            }
            system.debug('errMsgLst--'+errMsgLst);
            if(errMsgLst != null && errMsgLst.size() > 0){
                if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                    for(srtsolWrapper sol:listsrtsolWrapper){
                        if(sol.compWrapper != null ){
                            for(srtCompWrapper s: sol.compWrapper){
                                if(s.partWrapper != null){
                                    system.debug('s.partWrapper--->'+s.partWrapper);
                                    for(srtPartWrapper y: s.partWrapper){
                                        List<String> tempStr = new List<String>();
                                        if(y.failCode != null && y.failCode != '' && y.failCode != 'Select One'){
                                            tempStr = y.failCode.split('-'); 
                                        }
                                        String temp1;
                                        if(tempStr.size() > 0){
                                            temp1 = tempStr[tempStr.size()-1];
                                        }
                                        String temp = temp1+';;'+y.accountCode;
                                        if(errMsgLst != null && errMsgLst.contains(y.accountCode)){
                                            y.isPartsCovLimitExceed = true;
                                        }
                                        else{
                                            if(errMsgLst != null && errMsgLst.contains(temp)){
                                                y.isPartsCovLimitExceedPW = true;
                                            }
                                            else{
                                                y.isPartsCovLimitExceed = false;
                                                y.isPartsCovLimitExceedPW = false;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } 
            else{
                if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                    for(srtsolWrapper sol:listsrtsolWrapper){
                        if(sol.compWrapper != null ){
                            for(srtCompWrapper s: sol.compWrapper){
                                if(s.partWrapper != null){
                                    system.debug('s.partWrapper--->'+s.partWrapper);
                                    for(srtPartWrapper y: s.partWrapper){
                                        y.isPartsCovLimitExceed = false;
                                        y.isPartsCovLimitExceedPW = false;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if(lstUpdateSolComp != null && lstUpdateSolComp.size() > 0 ){
                system.debug('lstUpdateSolComp'+lstUpdateSolComp);
                update lstUpdateSolComp;
            }


            //<!--Start  code for checking dealer location from utility class and showing error when we are not getting Fail and Account code as per story #176379 Kung Fu Panda sprint,-By RAJESH 14th Mar 2019-->                
            CSS_Claims__c claimRecPart = new CSS_Claims__c();
            List<CSS_Claims__c> clmUpdRec = new List<CSS_Claims__c>();
            list<CSS_Parts_Options__c> lstPartsRec = new list<CSS_Parts_Options__c>();
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            lstPartsRec=[SELECT Id,Account_Code__c,Fail_Code__c from CSS_Parts_Options__c where CSS_Claims__c =:pgId and selected_part__c = true and RecordTypeId =: recTypeIdpart];
            system.debug('***lstPartsRec.size()***'+lstPartsRec.size());
            if(lstPartsRec.size()>0){
                for(CSS_Parts_Options__c partsLists:lstPartsRec){
                    system.debug('***partsLists.Fail_Code__c***'+partsLists.Fail_Code__c);
                    system.debug('***partsLists.Account_Code__c***'+partsLists.Account_Code__c);
                    if(partsLists.Fail_Code__c=='Select One' || partsLists.Account_Code__c=='Select One'){
                        system.debug('***inside parts with dealer location***');
                        partsODMMesasgeflag=true;
                        if(partsODMMesasgeflag==true){
                            claimRecPart.id=pgId;
                            claimRecPart.PartsRelatedODMMessage__c='failed';
                            //update claimRecPart;
                            if(!clmUpdRec.contains(claimRecPart))
                                clmUpdRec.add(claimRecPart);
                        }
                    }
                    else{
                        claimRecPart.id=pgId;
                        claimRecPart.PartsRelatedODMMessage__c='passed';
                        //update claimRecPart;
                        if(!clmUpdRec.contains(claimRecPart))
                            clmUpdRec.add(claimRecPart);
                    }
                }

            } else {
                //Defect: # 191382 - Adding else condition for updating parts message value.
                claimRecPart.id=pgId;
                claimRecPart.PartsRelatedODMMessage__c='passed';
                //update claimRecPart;
                if(!clmUpdRec.contains(claimRecPart))
                    clmUpdRec.add(claimRecPart);
                //Defect: # 191382 - Adding else condition for updating parts message value.
            }
            //Defect: # 191382 - cut and paste the if loop.
            if(clmUpdRec != null && clmUpdRec.size() > 0){
                update clmUpdRec;
                system.debug('******record clmUpdRec enter inside the method***'+clmUpdRec);
            }
            //Defect: # 191382 - cut and paste the if loop.
            errMsgLstNew = new List<String>();
            system.debug('errMsgLst-->'+errMsgLst);
            if(errMsgLst != null && errMsgLst.size() > 0){
                for(String err : errMsgLst){
                    if(!err.contains(';;')){
                        errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg+' '+err);
                    }
                    else{
                        List<String> failCodeAccCode = new List<String>();
                        failCodeAccCode = err.split(';;');
                        errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg_PW1+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1]);
                    }
                }
            }

            system.debug('***claimRecPart***'+claimRecPart);
            // <!--End  code for checking dealer location from utility class and showing error when we are not getting Fail and Account code as per story #176379 Kung Fu Panda sprint,-By RAJESH 14th Mar 2019--> 
            System.debug('partslst After save returning-->'+partslst);
        }catch(exception e){
            system.debug('Entered into catch block of save parts method in css_srt parts class' + e.getmessage() + ' ' + e.getLineNumber());
        }

        //pageReference ReturnPage = ApexPages.currentPage(); 
        //return ReturnPage;
    }

    //public list<string> lstAccountCodes{get;set;}
    //public List<SelectOption> accCodes{get;set;}

    //public List<CSS_JobEventTemporary__c> jobEventTemp;
    public void getAccountCodes() {
        system.debug('in getAccountCodes ....');
        try{
            lstAccountCodes = new list<String>();

            string orgtype=css_utility.getOrgType(userinfo.getUserId());
            //public css_job_order__c  workJob;
            system.debug('PageID'+pgId);
            //string Location = [select Creator_Location__c from CSS_Job_Order__c where id = :pgId].Creator_Location__c;
            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;
            string Location = usr.User_Location__c;
            Account Regionterritory = css_utility.getRegionTerritory(Location);





            system.debug('orgtype--->'+orgtype);
            //system.debug('Regionterritory--->'+Regionterritory.Region__c);
            system.debug('userRole--->'+userRole);

            jobEventTemp = new List<CSS_JobEventTemporary__c>();

            if(userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE')) 
            {
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            else{ 
                if (orgtype=='DISTR'){
                    system.debug('Inside DISTR');
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                }
                else{
                    if(Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute7__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                }
            }


            system.debug('KAL--->'+jobEventTemp);
            system.debug('lstAccountCodes before returning--->'+lstAccountCodes);
        }
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage() + ex.getLineNumber());

        }

    }
    //Method to get failcode
    public List<SelectOption> getfailcodeDropDown(){    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();

        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        system.debug('Test+solsComp'+pgid+'99');
        failAccountCodeMap = new  Map<String, Set<String>>();

        if(solsCompNew != null && solsCompNew.size() >0)
            solsComp.addall(solsCompNew);

        /*if(pgId != null) {
        solsComp = [SELECT  Id, Name,FailCode_Formula__c,Fail_Code_Editable__c,CoveredPartsQty_Percentage__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c,Selected_Component__c, CSS_Account_Formula__c,Solutions__r.Name ,Solutions__r.Solution_title__c,Unique_Component__c,
                           (Select id,Option_Number__c,Tracking_Number__c,RID__c,Service_Job__c,Replacement_Reason__c,Option_ESN__c,selected_part__c,FailureName__c,Assignment__c,FailurepartId__c,FailurepartId__r.Selected_Component__c,Notes__c,Solutions__c,RecordType.Name,OEM__c,Part_Description__c,Part_Name__c,part_size__c,Quantity__c,Covered__c,Service_partnumber__c,ReturnToFactory__c,ReturnWaiver__c,Fail_Code__c,Account_Code__c,FailurepartId__r.CSS_Account_Formula__c,FailurepartId__r.AccountCode__c from CSS_Parts_Options__r where Part_Assignment__c = 'Primary')
                           from CSS_Solution_Component__c where CSS_Claims__c =:pgId and type__C NOT IN ('TRP','ATC','Campaign')]; 
  }*/
        options.add(new SelectOption('Select One','Select One'));
        system.debug('Test+solsComp'+SolCmps);
        if(solsComp.size()>0){
            Set<string> acCodeSet;
            for(CSS_Solution_Component__c f:solsComp){
                if(f.FailCode_Formula__c!='Select One'){
                    if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                        if(JETFA != null){
                            for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                                if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        system.debug('coverageType***'+coverageType); 
                    }
                    if(f.CoveredPartsQty__c != null && Integer.valueOf(f.CoveredPartsQty__c) >0 && (coverageType != 'OTH' && coverageType != 'POL')){
                        sortableSet.add(f.FailCode_Formula__c);
                        if(failAccountCodeMap.containsKey(f.FailCode_Formula__c)){
                            system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                            acCodeSet = failAccountCodeMap.get(f.FailCode_Formula__c);
                            if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            system.debug('**acCodeSet***'+acCodeSet);
                            failAccountCodeMap.put(f.FailCode_Formula__c, acCodeSet);
                        }
                        else{
                            system.debug('**insidecontainkey---else');
                            acCodeSet = new Set<string>();
                            if(f.CSS_Account_Formula__c != null){
                                system.debug('coverageType***'+coverageType);
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            system.debug('**acCodeSet**'+acCodeSet);
                            failAccountCodeMap.put(f.FailCode_Formula__c, acCodeSet);
                        }
                    }
                    else{
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            sortableSet.add(f.FailCode_Formula__c);
                            if(failAccountCodeMap.containsKey(f.FailCode_Formula__c)){
                                system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                                acCodeSet = failAccountCodeMap.get(f.FailCode_Formula__c);
                                if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**acCodeSet***'+acCodeSet);
                                failAccountCodeMap.put(f.FailCode_Formula__c, acCodeSet);
                            }
                            else{
                                system.debug('**insidecontainkey---else');
                                acCodeSet = new Set<string>();
                                if(f.CSS_Account_Formula__c != null){
                                    system.debug('coverageType***'+coverageType);
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**acCodeSet**'+acCodeSet);
                                failAccountCodeMap.put(f.FailCode_Formula__c, acCodeSet);
                            }
                        }
                    }
                    /*if(failAccountCodeMap.containsKey(f.FailCode_Formula__c)){
                    system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                    acCodeSet = failAccountCodeMap.get(f.FailCode_Formula__c);
                    if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                        else{
                            if(f.CSS_Account_Formula__c !='Select One' && f.CoveredPartsQty__c != null && Integer.valueOf(f.CoveredPartsQty__c) >0 && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                    }
                    system.debug('**acCodeSet***'+acCodeSet);
                    failAccountCodeMap.put(f.FailCode_Formula__c, acCodeSet);
                }
                else{
                    system.debug('**insidecontainkey---else');
                    acCodeSet = new Set<string>();
                    if(f.CSS_Account_Formula__c != null){
                        system.debug('coverageType***'+coverageType);
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                        else{
                            if(f.CSS_Account_Formula__c !='Select One' && f.CoveredPartsQty__c != null && Integer.valueOf(f.CoveredPartsQty__c) >0 && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                    }
                    system.debug('**acCodeSet**'+acCodeSet);
                    failAccountCodeMap.put(f.FailCode_Formula__c, acCodeSet);
                }*/
                }
                system.debug('sortableSet  ' +  sortableSet);
                system.debug('failAccountCodeMap***' +  failAccountCodeMap);

            }
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {    
                if(s != null && s != '')
                    options.add(new selectOption(s,s));                    
            }   
        }
        return Options;   
    }

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
            lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CSS_CoverageType__c,Covered_Parts__c,CoveredOCAmount__c,FailCode_Formula__c,AccountCodeEdit__c from CSS_Solution_Component__c where CSS_Claims__c =:pgid and (CSS_Account_Formula__c = :SelectedAccountCode and FailCode_Formula__c = :SelectedFailCode and CSS_Account_Formula__c!='') ];
            //   lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c,AccountCodeEdit__c from CSS_Solution_Component__c where Service_Job__c =:wid and CSS_Account_Formula__c = :SelectedAccountCode AND CSS_Account_Formula__c!='' ];
            system.debug('lstSolComp1'+lstSolComp1);
            //system.debug('SelectedFailCode1>>>>>>>>>>: '+lstSolComp1[0].FailCode_Formula__c);
            system.debug('lstSolComp1size'+lstSolComp1.size());
            if(lstSolComp1!=null && lstSolComp1.size()!=0){
                //system.debug('listpartWrapper-->'+listpartWrapper);

                if(jobEventTemp != null){
                    for(CSS_JobEventTemporary__c jobEntObj : jobEventTemp){
                        if(jobEntObj.Account_Code__c == lstSolComp1[0].CSS_Account_Formula__c){
                            coverageType = jobEntObj.Attribute1__c;
                        }
                    }
                }
                system.debug('coverageType***'+coverageType);
                system.debug('lstSolComp1[0].CoveredPartsQty__c'+lstSolComp1[0].CoveredPartsQty__c);  
                if(lstSolComp1[0].Covered_Parts__c!=null && lstSolComp1[0].Covered_Parts__c!='' && (coverageType == 'OTH' || coverageType == 'POL')){
                    //CoveredParAC =  lstSolComp1[0].CoveredPartsQty__c; 
                    CoveredParAC =  lstSolComp1[0].Covered_Parts__c;   // karthik G added GSSC 57
                }
                else if (lstSolComp1[0].Covered_Parts__c==null || lstSolComp1[0].Covered_Parts__c=='' && (coverageType == 'OTH' || coverageType == 'POL')){
                    CoveredParAC = '100';
                }
                else if(lstSolComp1[0].CoveredPartsQty__c!=null && lstSolComp1[0].CoveredPartsQty__c!='' && (coverageType != 'OTH' && coverageType != 'POL'))
                    CoveredParAC =  lstSolComp1[0].CoveredPartsQty__c; 
                system.debug('CoveredParAC>>>>'+CoveredParAC);

                if (CoveredParAC!= null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0  && (coverageType == 'OTH' || coverageType == 'POL')){
                    CoveredParAC = CoveredParAC;
                }else if((CoveredParAC == null || CoveredParAC == '' || (CoveredParAC != null && CoveredParAC != '' && Integer.ValueOf(CoveredParAC) == 0))  && (coverageType == 'OTH' || coverageType == 'POL')){
                    CoveredParAC = '100';
                }
                else if(CoveredParAC!='' && integer.valueof(CoveredParAC) > 0 && (coverageType != 'OTH' && coverageType != 'POL')){  // karthik G added GSSC 57
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
                                                prtslist.coveragetypeval =  lstSolComp1[0].CSS_CoverageType__c;
                                                prtslist.coveredpartsper =  lstSolComp1[0].Covered_Parts__c;
                                                system.debug('prtslist.coveragetypeval >'+prtslist.coveragetypeval);

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
                                                prtslist.coveragetypeval =  lstSolComp1[0].CSS_CoverageType__c;
                                                prtslist.coveredpartsper =  lstSolComp1[0].Covered_Parts__c;
                                                system.debug('prtslist.coveragetypeval >'+prtslist.coveragetypeval);

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
                                            prtslist.coveragetypeval =  '';
                                            prtslist.coveredpartsper =  '';
                                            system.debug('prtslist.coveragetypeval >'+prtslist.coveragetypeval);
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
    public void onChangeofFailCode(){
        system.debug('SelectedFailCode'+SelectedFailCode);
        system.debug('SelectedPartID'+selectedPartRowCount);
        system.debug('servicePartNumber-->'+servicePartNumber);
        String accCode;
        String CoveredPar ='';
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        if(SelectedAccountCode!='Select One'){
            //Getting last four letters of failcode
            string SelectedFailCode1= SelectedFailCode.right(4);
            system.debug('SelectedFailCode1'+SelectedFailCode1);
            List<SelectOption> options=accountCodelistN(SelectedFailCode);
            system.debug('options'+options);
            lstSolComp = [SELECT  Id,CSS_Account_Formula__c,SysCodeAndCompCode__c,CSS_CoverageType__c, Covered_Parts__c,CoveredPartsQty__c,AccountCode__c,CoveredOCAmount__c,AccountCodeType__c,AccountCodeEdit__c,CampaignPartsPercentage__c,Selected_Component__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:pgid and SysCodeAndCompCode__c = :SelectedFailCode1 AND CSS_Account_Formula__c!=''];
            system.debug('lstSolComp'+lstSolComp);
            system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
            if(lstSolComp != null && lstSolComp.size()!=0){
                if(lstSolComp.size() > 1){
                    //string acCode = lstSolComp[0].CSS_Account_Formula__c;
                    string acCode;
                    string compAcCode;                    
                    acCode = lstSolComp[0].CSS_Account_Formula__c;
                    compAcCode = lstSolComp[0].CSS_Account_Formula__c;
                    system.debug('acCode'+acCode);
                    boolean setAcCode = false;
                    for(integer i=0;i<lstSolComp.size();i++ ){
                        if(lstSolComp[0].Id != lstSolComp[i].Id && acCode != lstSolComp[i].CSS_Account_Formula__c){
                            setAcCode = true;
                            break;
                        }
                    }
                    if(setAcCode==true){
                        accCode='Select One';
                        CoveredPar='';
                    }else{
                        accCode=acCode;
                    }
                }
                else{
                    accCode =lstSolComp[0].CSS_Account_Formula__c; 
                }

                if(jobEventTemp != null){
                    for(CSS_JobEventTemporary__c jobEntObj : jobEventTemp){
                        if(jobEntObj.Account_Code__c == lstSolComp[0].CSS_Account_Formula__c){
                            coverageType = jobEntObj.Attribute1__c;
                        }
                    }
                }
                system.debug('coverageType***'+coverageType);
                if( lstSolComp[0].Covered_Parts__c!=null && lstSolComp[0].Covered_Parts__c!= '' && (coverageType == 'OTH' || coverageType == 'POL')){

                    //  CoveredPar =  lstSolComp[0].CoveredPartsQty__c; 
                    CoveredPar = lstSolComp[0].Covered_Parts__c; 


                }
                else if((lstSolComp[0].Covered_Parts__c==null || coverageType== '') && (coverageType == 'OTH' || coverageType == 'POL')){
                    CoveredPar = '100'; 
                    system.debug('CoveredPar1'+CoveredPar);

                }
                else if(lstSolComp[0].CoveredPartsQty__c != null && Integer.valueOf(lstSolComp[0].CoveredPartsQty__c) >0 && lstSolComp[0].Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL')){
                    CoveredPar =  lstSolComp[0].CoveredPartsQty__c; 
                }

                if (CoveredPar!= null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0  && (coverageType == 'OTH' || coverageType == 'POL')){
                    CoveredPar = CoveredPar;
                    system.debug('CoveredPar2'+CoveredPar);
                }else if((CoveredPar == null || CoveredPar == '' || (CoveredPar != null && CoveredPar != '' && Integer.ValueOf(CoveredPar) == 0))  && ( coverageType != '' && (coverageType == 'OTH' || coverageType == 'POL'))){
                    CoveredPar = '100';
                    system.debug('CoveredPar3'+CoveredPar);
                }
                else if(CoveredPar!= null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0  && (coverageType != 'OTH' && coverageType != 'POL')){
                    CoveredPar = '100';
                    system.debug('CoveredPar4'+CoveredPar);
                }
                else if(CoveredPar!= null && CoveredPar!='' && Integer.ValueOf(CoveredPar) == 0){
                    CoveredPar = '0';      
                    system.debug('CoveredPar5'+CoveredPar);
                }
                else{                 
                    CoveredPar = '';
                }

            }
            system.debug('CoveredPar'+CoveredPar);


            system.debug('CoveredParts>>>>>>>>>>: '+CoveredPar);

            if(listsrtsolWrapper != null && listsrtsolWrapper.size()>0){
                try{
                    system.debug('firstforloop');
                    for(srtsolWrapper sol:listsrtsolWrapper){
                        if(sol.compWrapper != null ){
                            for(srtCompWrapper s: sol.compWrapper){
                                if(s.partWrapper != null){
                                    system.debug('s.partWrapper--->'+s.partWrapper);
                                    for(srtPartWrapper prtslist: s.partWrapper){
                                        if(prtslist.partIds != null){
                                            system.debug('prtslist.partRowCount****'+prtslist.partRowCount);
                                            system.debug('selectedPartRowCount****'+selectedPartRowCount);
                                            if(prtslist.partRowCount == selectedPartRowCount && prtslist.servicePartNumber == servicePartNumber){
                                                //  if(prtslist.servicePartNumber == servicePartNumber){
                                                system.debug('Inside IF');
                                                prtslist.returnToFactory = '';
                                                prtslist.failCode =  String.valueof(SelectedFailCode);
                                                prtslist.accountCode = accCode ;
                                                prtslist.accCodes=options;
                                                system.debug('prtslist.accountCode '+prtslist.accountCode);
                                                if((prtslist.accountCode == null ||prtslist.accountCode == '' || prtslist.accountCode == 'Select One')){
                                                    prtslist.covered='';                                                    
                                                }
                                                else
                                                    prtslist.covered=CoveredPar;
                                                if(prtslist.failCode=='Select One'){
                                                    prtslist.accountcodeMessage=true;
                                                }
                                                else
                                                    prtslist.accountcodeMessage=false;
                                                prtslist.coveragetypeval =  lstSolComp[0].CSS_CoverageType__c;
                                                prtslist.coveredpartsper =  lstSolComp[0].Covered_Parts__c;
                                                system.debug('prtslist.coveragetypeval >'+prtslist.coveragetypeval);

                                            }  
                                            system.debug('covered'+CoveredPar);  
                                            system.debug('prtslist.failcode >'+prtslist.failcode); 
                                        }
                                    }
                                }
                            }
                        }
                    }
                }catch(exception e){
                    system.debug('Entered into catch block of failcode' + e.getmessage() + ' ' + e.getLineNumber());
                }

            }
        }
    }
}