/**********************************************************************
Name:CG_CL_ClaimsUserRequestedParts
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
---------
We are using this Component Controller for Claims User Requested accordion under Parts and Other Claimables.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Shreerath Nair     3/20/2018      Added for UserRequested Popoup   
1.0 - Arpita Sarangee    4/2/2018       Added code as part of user story 137880
1.0 - Rupesh Pande       23/07/2018     Added code as part of user story 148891
***********************************************************************/
public class CG_CL_ClaimsUserRequestedParts{

    //public Boolean isReturnWaiver{get;set;}
    public Boolean dealerLocation{get; set;}
    public Boolean failAccCodeErrorMessage{get; set;}
    public Id Wid {get; set{Wid = value; 
                            //Commented as part of the defect # 191853 - START
                            /*system.debug('in setter Wid>>>>>>>>>>:'+Wid);
                            system.debug('singleRun>>:'+singleRun);
                            if(singleRun==1){
                                listpartWrapper = new List<partWrapperClass>();
                                setpartWrapper = new Set<partWrapperClass>();
                                listpartWrapper.clear();
                                setpartWrapper.clear();

                                getallCustomPartsData(false);
                                singleRun+=1;
                                System.debug('in setter Wid');
                            }
                            //getallCustomPartsData(false);*/
                            //Commented as part of the defect # 191853 - END
                           } }
    public String CLaimNumberErrlog {get; set;}
    public String errorMsg {get;set;}
    public Boolean isReturnwaiver{get;set;}
    public Boolean isAutomatedClaim{get;set;}
    public Id Cid{get; set;}
    public Boolean displayPopup2{get;set;}
    public boolean chkReqField{get;set;}
    public  boolean ErrorMessage {get; set;}
    public  boolean ErrorMessage2 {get; set;}
    public  boolean accountcodeReadOnly {get; set;}
    public Integer assignedParts{get;set;}
    public Id recTypeIdpart;
    public integer singleRun=0;
    public Set<partWrapperClass> setpartWrapper {get;set;}
    public List<partWrapperClass> listpartWrapper {get;set;}
    public List<partWrapperClass> listpartWrapper2 {get;set;}
    public list<CSS_Parts_Options__c> customPartlstUI{get; set;}
    //Added for accountcodes dropdown
    public CSS_Claims__c claimsObj {get;set;}
    public List<SelectOption> accCodes{get;set;}
    public list<CSS_JobEventTemporary__c> jobEventTemp {get;set;}
    public list<CSS_JobEventTemporary__c> jobEventLst;

    public String SelectedFailCode{get;set;}
    public integer  SelectedPartID{get;set;}
    public Map<Id, String> removeIdsMap = new Map<Id, String>();
    public String SelectedAccountCode{get;set;}    
    public list<CSS_Parts_Options__c> existPartList{get; set;}
    public list<CSS_Parts_Options__c> eprPartList{get; set;}
    public transient list<CSS_Parts_Options__c> partsList{get; set;}
    public Decimal totalurp{get;set;}
    public Boolean isDealer {get;set;}
    public Integer selPartnum{get;set;}
    public string selpartnum1{get;set;}
    public boolean PartNotFoundError{get;set;}
    public boolean PartNoValidationError{get;set;}
    public String coverageType;
    public Map<String,Set<String>> failAccountCodeMap{get;set;}
    public Set<String> errMsgLst{get;set;}
    public List<String> errMsgLstNew{get;set;}
    public Integer selectedPart{get;set;}
    public boolean numberTracking{get; set;}
    public boolean isURPCovered{get;set;}
    public boolean disableSave{get;set;} //Added for Defect GSSC-635
    //method for getting update the TrackingNumber
    public void enableTrackingNumber(){
        errorMsg='';
        numberTracking=false;
        system.debug('****In side Method***');
        system.debug('****isReturnwaiver***'+isReturnwaiver);
        system.debug('****selectedPart***'+selectedPart);
        system.debug('****partotionWrapperList***'+partotionWrapperList);
        if(isReturnwaiver==true){
            system.debug('****inside isReturnwaiver ***');
            if(partotionWrapperList != null && partotionWrapperList.size()>0){
                for(partOptionWrapperClass poWarrper:partotionWrapperList){
                    system.debug('****inside poWarrper.partcout ***'+poWarrper.partcout);
                    if(poWarrper.partcout==selectedPart){                           
                        //numberTracking=true;
                        poWarrper.partoption.ReturnWaiver__c=true;
                        system.debug('****poWarrper.partoption.ReturnWaiver__c***'+poWarrper.partoption.ReturnWaiver__c);
                        break;
                    }           
                }
            }
        }
    }


    //Adding for story#
    public decimal ConsolidateTemptotal{get;set;}
    //Method for getting picklist values for Tracking Number as per 24 sprint #161414,-By RAJESH 04th Sec 2018
    public List<SelectOption> getTrackingNumber(){
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
    public CG_CL_ClaimsUserRequestedParts()
    {
        singleRun = 1;
        isURPCovered = true;
        errorMsg='';
        isAutomatedClaim = false;

        accountcodeReadOnly=false;
        isDealer = true;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        }
        Cid=ApexPages.CurrentPage().getParameters().get('id');
    }
    public void LoadConstructor() {
        System.debug('in consturctor CG_CL_ClaimsUserRequestedParts');
        jobEventLst = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c,Account_Code__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes'];
        system.debug('jobEventLst*size***'+jobEventLst.size());

        // below code for checking dealer location from utility class as per story #176379 Kung Fu Panda sprint,-By RAJESH 11th Mar 2019
        system.debug('****Cid****'+Cid);
        CSS_Claims__c  claimrecord=[SELECT Id, Location_Code__c, Account__c, Account__r.type, Location__c FROM CSS_Claims__c where id=:Cid];
        system.debug('****claimrecord****'+claimrecord);
        dealerLocation = false;
        if(claimrecord!=null){
            string claimLocation=claimrecord.Location_Code__c;
            if(claimLocation!=null){
                boolean DealerTypeFlag = CSS_utility.getAccounttype(claimrecord.Account__r.Type); 
                if(DealerTypeFlag==true)
                    dealerLocation = true;
            }
        }
        //End
    }    
    public List<partOptionWrapperClass> partotionWrapperList{get;set;}
    public class partOptionWrapperClass{
        public CSS_Parts_Options__c partoption{get;set;}
        public Double totalUrp{get;set;}
        public integer partcout{get;set;}

    }
    public CSS_Parts_Options__c partsoption{get;set;}
    public double temptotalurp{get; set;}
    public void getUserAddedParts(){
        LoadConstructor();
        partotionWrapperList = new List<partOptionWrapperClass>();
        ConsolidateTemptotal =0;
        System.debug('***Widgetparts****'+Wid);
        Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>(); //GSSC-138
        if(Wid != null) 
        {
            //partsList = [select Id, ExpenseTotal__c,isManual__c,Name, CSS_Claims__c, Selected_part__c, FailurepartId__c, Tracking_Number__c, RID__c,Service_partnumber__c, Account_Code__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c from CSS_Parts_Options__c where CSS_Claims__c =: Wid AND Parts_Type__c = 'Custom' AND ReturnToFactory__c = ''];
            //Added " ReturnWaiver__c " in below query for Return Waiver as per 24 sprint #161414,-By RAJESH 04th Sec 2018-->
            //Added CSS_Claims__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c in below query as part of the story GSSC-138
            existPartList = [SELECT Id,CSS_Claims__c, ExpenseTotal__c, isManual__c,Notes__c, OEM__c, Tracking_Number__c, RID__c,Quantity__c, Selected_part__c, Replacement_Reason__c, Part_Name__c, 
                             Service_partnumber__c, Service_Job__c, Assignment__c, Part_Description__c, Option_Number__c, 
                             Part_size__c, ReturnToFactory__c,ReturnWaiver__c,RecordTypeId, Fail_Code__c, Account_Code__c, Covered__c,Unit_Price__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c
                             FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: Wid AND Parts_Type__c = 'Custom'];
            //End 
            /*if(partsList.size() > 0) 
             {
                 eprPartList = CSS_FN_SIEBEL.getPartsReturnClaims(partsList);
                 System.debug('**eprPartList'+eprPartList);
                 if(eprPartList.size() > 0)
                 {
                     update eprPartList;
                     //isAutomatedClaim = true;
                 }

             }*/

            if(existPartList.size() > 0) 
            {
                //GSSC-138 - Start
                css_utility controller = new css_utility();
                mapPartsList = controller.displayParts(existPartList);
                //GSSC-138 - End
                for(CSS_Parts_Options__c prt : existPartList){
                    if(prt.ReturnToFactory__c == '')
                        partsList.add(prt);
                }
                if(partsList != null && partsList.size() > 0)
                    eprPartList = CSS_FN_SIEBEL.getPartsReturnClaims(partsList);
                System.debug('**eprPartList'+eprPartList);
                if(eprPartList != null && eprPartList.size() > 0)
                {
                    update eprPartList;
                    //isAutomatedClaim = true;
                }

            }
            integer i=0;
            for(CSS_Parts_Options__c partsoption:existPartList)
            { 

                system.debug('partsoption.Covered__c'+partsoption.Covered__c);
                system.debug('partsoption.Unit_Price__c'+partsoption.Unit_Price__c);
                system.debug('partsoption.Quantity__c'+partsoption.Quantity__c);
                
                //GSSC-138 - Start
                if(userinfo.getDefaultCurrency() != 'USD'){
                    Map<decimal, decimal> expTotalTempMap = mapPartsList.get(partsoption.Id);
                    Decimal unitPriceTemp; 
                    if(expTotalTempMap != null){
                        for(decimal up : expTotalTempMap.keyset()){
                            unitPriceTemp = up;
                        }
                    }
                    if(unitPriceTemp != null)
                        partsoption.Unit_Price__c = string.valueof(unitPriceTemp);
                    
                }
                //GSSC-138 - End

                if(partsoption.Covered__c != null ){
                    if(partsoption.Unit_Price__c!=null && partsoption.Unit_Price__c.trim()!= '')
                        try{ 
                            temptotalurp= (partsoption.Covered__c/100)*(Decimal.valueof(partsoption.Unit_Price__c)!=null?Decimal.valueof(partsoption.Unit_Price__c):0)*partsoption.Quantity__c;

                        }catch(exception e){
                            System.debug('The error occurred: ' + e.getMessage());
                        }
                }
                if(partsoption!=null){
                    system.debug('partsoption>>>>insidekarthik'+partsoption);
                    i=i+1;
                }
                
                partOptionWrapperClass temp = new partOptionWrapperClass();
                temp.partoption=partsoption;
                partsoption.ExpenseTotal__c=temptotalurp;
                temp.totalUrp=temptotalurp;
                temp.partcout=i;
                partotionWrapperList.add(temp);
                if(temptotalurp!=null)
                    ConsolidateTemptotal += temptotalurp;

            }
            System.debug('***existPartList****'+existPartList);
            System.debug('***partotionWrapperListkarthik****'+partotionWrapperList);

            //totalurp= existPartList.Covered__c*integer.valueof(existPartList.Unit_Price__c)*existPartList.Quantity__c;
            //Added as part of the defect # 191853 - START
            listpartWrapper = new List<partWrapperClass>();
            setpartWrapper = new Set<partWrapperClass>();
            listpartWrapper.clear();
            setpartWrapper.clear();
            getallCustomPartsData(false);
            //Added as part of the defect # 191853 - END
        }
    }

    public void saveUserAddedParts()
    {

        system.debug('inside saveUserAddedParts');
        System.debug('***existPartList****'+existPartList);
        set<boolean> setTrackingNumReqErrorMessage = new set<boolean>();
        try{
            /* if(existPartList!= null && !existPartList.isEmpty())
            {   
                // totalurp= existPartList.Covered__c*integer.valueof(existPartList.Unit_Price__c)*existPartList.Quantity__c;
                update existPartList;
            }*/
            //Added below method as per 24 #161414 showing the validation,-By RAJESH 6th Sec 2018 
            numberTracking=false;
            if(existPartList!= null && !existPartList.isEmpty())
            {
                for(CSS_Parts_Options__c partsoption:existPartList){
                    System.debug('***partsoption.ReturnWaiver__c****'+partsoption.ReturnWaiver__c);
                    System.debug('***partsoption.Tracking_Number__c****'+partsoption.Tracking_Number__c+'partnumber**'+partsoption.Service_partnumber__c);
                    if(partsoption.ReturnWaiver__c==true && partsoption.Tracking_Number__c!='Select One' && partsoption.Tracking_Number__c!=''){
                        //errorMsg='';
                        //numberTracking=false;
                        update existPartList;    
                        system.debug('testIn**'+existPartList);
                    }
                    else if (partsoption.Tracking_Number__c=='Select One' && partsoption.ReturnWaiver__c==true && partsoption.ReturnToFactory__c=='Y'){
                        //errorMsg= Label.CG_Please_enter_value;
                        partsoption.Tracking_Number__c=null;
                        //numberTracking=true;
                        setTrackingNumReqErrorMessage.add(true);
                    }
                    //Commented below else if, as part of defect fix GSSC-593
                    else if ((partsoption.Tracking_Number__c=='Select One' || partsoption.Tracking_Number__c=='' || partsoption.Tracking_Number__c==null) && partsoption.ReturnWaiver__c==false && partsoption.ReturnToFactory__c== 'Y'){
                        //errorMsg= Label.CG_Please_enter_value;
                        partsoption.Tracking_Number__c=null;
                        numberTracking=true;
                        setTrackingNumReqErrorMessage.add(true);
                    }
                    else{
                        // errorMsg='';
                        //numberTracking=false;
                        update existPartList;
                        system.debug('testelse**'+existPartList);
                    }
                }
            }
            if(setTrackingNumReqErrorMessage.contains(true)){
                numberTracking=true;
                errorMsg= Label.CG_Please_enter_value;
            }
            else{
                numberTracking=false;
                errorMsg='';
            }
            //8888888888888888888888888888888888------END     
        }catch(exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }        
    }

    public void resetUserAddedParts()
    {
        system.debug('inside resetUserAddedParts');
        errorMsg = '';
        getUserAddedParts();
    }


    public void getallCustomPartsData(Boolean displayPopup2){

        chkReqField = false;
        PartNoValidationError= false;
        PartNotFoundError= false;
        ErrorMessage2 = false;
        getfailcodeDropDown();
        if(displayPopup2){
            ErrorMessage = true;
        }else
            ErrorMessage = false;

        customPartlstUI = new list<CSS_Parts_Options__c>();
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();


        try{
            if(wid != null) {
                recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                system.debug('***recTypeIdpart***'+recTypeIdpart +'-----------> ' +  Wid);
                map<string,CSS_Solution_Component__c> mapSolCompRec = new map<string,CSS_Solution_Component__c>();
                lstSolComp= [SELECT Id, FailCode_Formula__c ,Covered_Parts__c, CSS_Claims__c,CSS_Account_Formula__c,Selected_Component__c  from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Selected_Component__c= true];


                for(CSS_Solution_Component__c compRec:lstSolComp){
                    mapSolCompRec.put(compRec.FailCode_Formula__c + compRec.CSS_Account_Formula__c,compRec);
                }

                lstSolComp = null;
                //Added field "CSS_Claims__r.Information_Only_Claim__c" in below query as part of the defect #GSSC-197
                customPartlstUI = [select Id,Notes__c,OEM__c,isManual__c,Replacement_Reason__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c, CSS_Claims__r.Information_Only_Claim__c,
                                   ReturnToFactory__c,Service_Job__c,Covered__c,Fail_Code__c,Account_Code__c,Solutions__c,Unit_Price__c, CoverageLimitExceedMsg__c, CoverageLimitExceedMsg_Status__c 
                                   from CSS_Parts_Options__c where CSS_Claims__c =:Wid and RecordTypeId=:recTypeIdpart and Parts_Type__c ='Custom'];
                system.debug('customPartlstUI size>>>:'+customPartlstUI.size()+'customPartlstUI querry>>>>>>>>>>:'+customPartlstUI);

                List<SelectOption> options =  new List<SelectOption>();
                options.add(new SelectOption('Select One','Select One'));
                errMsgLstNew = new List<String>();
                if(customPartlstUI.size()>0){

                    listpartWrapper = new List<partWrapperClass>();
                    setpartWrapper = new Set<partWrapperClass>();
                    CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                    errMsgLst = new Set<String>();
                    errMsgLst = contr.covLimitValidation(null, Cid, customPartlstUI, null);
                    for(integer i=0;i<customPartlstUI.size();i++){
                        string CovType;
                        string covPolPartValue;
                        CSS_Solution_Component__c solCompRec = new CSS_Solution_Component__c();
                        //Commented below line as part of the defect # GSSC-197
                        //solCompRec = mapSolCompRec.get(customPartlstUI[i].Fail_Code__c + customPartlstUI[i].Account_Code__c);
                        //Added as part of the defect # GSSC-197 - START
                        String tempAC;
                        if(customPartlstUI[i].CSS_Claims__r.Information_Only_Claim__c != true){
                            tempAC = customPartlstUI[i].Account_Code__c;
                        }
                        else{
                            tempAC = (customPartlstUI[i].Account_Code__c != null  && customPartlstUI[i].Account_Code__c != '' && customPartlstUI[i].Account_Code__c != 'Select One') ? customPartlstUI[i].Account_Code__c.RIGHT(2) : customPartlstUI[i].Account_Code__c;
                        }
                        solCompRec = mapSolCompRec.get(customPartlstUI[i].Fail_Code__c + tempAC);
                        //Added as part of the defect # GSSC-197 - END
                        system.debug('KarthiksolCompRec>>>'+solCompRec);
                        if(customPartlstUI[i].Replacement_Reason__c == null || customPartlstUI[i].Replacement_Reason__c == '' || customPartlstUI[i].Replacement_Reason__c == 'Select One'){
                            customPartlstUI[i].Replacement_Reason__c = 'Refer to Narrative';
                        }
                        List<String> tempStr = new List<String>();
                        if(customPartlstUI[i].Fail_Code__c != null && customPartlstUI[i].Fail_Code__c != '' && customPartlstUI[i].Fail_Code__c != 'Select One'){
                            tempStr = customPartlstUI[i].Fail_Code__c.split('-'); 
                        }
                        String temp1;
                        if(tempStr.size() > 0){
                            temp1 = tempStr[tempStr.size()-1];
                        }

                        String temp = temp1+';;'+customPartlstUI[i].Account_Code__c;
                        Boolean isPartsCovLimitExceedPWtemp;
                        Boolean isPartsCovLimitExceedtemp;
                        system.debug('temp'+temp);
                        system.debug('customPartlstUI.CoverageLimitExceedMsg_Status__c'+customPartlstUI[i].CoverageLimitExceedMsg_Status__c);
                        system.debug('errMsgLst'+errMsgLst);
                        if(errMsgLst != null){
                            if(errMsgLst.contains(customPartlstUI[i].Account_Code__c)){
                                isPartsCovLimitExceedtemp = true;
                            }
                            else{
                                if(errMsgLst.contains(temp)){
                                    isPartsCovLimitExceedtemp = true;
                                    isPartsCovLimitExceedPWtemp = true;
                                }
                                else{
                                    isPartsCovLimitExceedtemp = false;
                                    isPartsCovLimitExceedPWtemp = false;
                                }
                            }
                        }

                        /*if(customPartlstUI[i].CoverageLimitExceedMsg_Status__c == 'ERROR'){
                                if(!customPartlstUI[i].CoverageLimitExceedMsg__c.contains(';;')){
                                    if(customPartlstUI[i].CoverageLimitExceedMsg__c.contains(customPartlstUI[i].Account_Code__c)){
                                        isPartsCovLimitExceedtemp = true;
                                    }
                                }
                                else{
                                    if(customPartlstUI[i].CoverageLimitExceedMsg__c.contains(temp)){
                                        isPartsCovLimitExceedtemp = true;
                                        isPartsCovLimitExceedPWtemp = true;
                                    }
                                    else{
                                        isPartsCovLimitExceedtemp = false;
                                        isPartsCovLimitExceedPWtemp = false;
                                    }
                                }
                            }*/ system.debug('isPartsCovLimitExceedtemp'+isPartsCovLimitExceedtemp);
                        if(isPartsCovLimitExceedtemp == true && isPartsCovLimitExceedPWtemp != true){
                            if(!errMsgLstNew.contains(Label.CSS_CoverageLimitExceedMsg+' '+customPartlstUI[i].CoverageLimitExceedMsg__c)){
                                errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg+' '+customPartlstUI[i].CoverageLimitExceedMsg__c);
                            }
                        }
                        else if(isPartsCovLimitExceedtemp == true && isPartsCovLimitExceedPWtemp == true){
                            if(!errMsgLstNew.contains(Label.CSS_CoverageLimitExceedMsg_PW1+' '+temp1+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+customPartlstUI[i].Account_Code__c)){
                                errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg_PW1+' '+temp1+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+customPartlstUI[i].Account_Code__c);
                            }
                        }
                        //Added null check for "solCompRec" in below line as part of the defect #GSSC-371
                        setpartWrapper.add(new partWrapperClass(i,customPartlstUI[i].Id,String.valueof(customPartlstUI[i].Quantity__c),customPartlstUI[i].Service_partnumber__c,customPartlstUI[i].Part_Name__c,customPartlstUI[i].Replacement_Reason__c,customPartlstUI[i].Notes__c,customPartlstUI[i].OEM__c,customPartlstUI[i].Selected_part__c,customPartlstUI[i].ReturnToFactory__c,String.valueof(customPartlstUI[i].Covered__c),customPartlstUI[i].Fail_Code__c,customPartlstUI[i].Account_Code__c,getAccountCodeDropDown(customPartlstUI[i].Fail_Code__c),customPartlstUI[i].isManual__c,false,false,false,false,isPartsCovLimitExceedtemp, isPartsCovLimitExceedPWtemp,coverageType, (solCompRec != null ? solCompRec.Covered_Parts__c : '')));
                    }
                    if(customPartlstUI.size()<=9) {
                        for(integer i=0;i<10-customPartlstUI.size();i++){
                            CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                            // CSS_Solution_Component__c solCompRec = new CSS_Solution_Component__c();
                            //solCompRec = mapSolCompRec.get(partsoption.Fail_Code__c + partsoption.Account_Code__c);
                            //system.debug('KarthiksolCompRec'+solCompRec);

                            partsoption.Notes__c = '';
                            partsoption.OEM__c = '';
                            //partsoption.Quantity__c = '';
                            partsoption.Selected_part__c = false;
                            partsoption.Part_Name__c = '';
                            partsoption.ReturnToFactory__c = '';
                            //partsoption.Covered__c = '';
                            partsoption.Fail_Code__c = '';
                            partsoption.Account_Code__c = '';
                            //partsoption.Replacement_Reason__c='Refer to Narrative';
                            partsoption.Replacement_Reason__c='Select One';
                            partsoption.Service_partnumber__c = '';
                            partsoption.Parts_Type__c='Custom';
                            partsoption.isManual__c=false;
                            try{
                                System.debug('setpartWrapper size>>>>:'+setpartWrapper.size()+' i===:'+i+' size:'+customPartlstUI.size()+i);
                                setpartWrapper.add(new partWrapperClass(customPartlstUI.size()+i,null,'',partsoption.Service_partnumber__c,partsoption.Part_Name__c,partsoption.Replacement_Reason__c,partsoption.Notes__c,partsoption.OEM__c,partsoption.Selected_part__c,partsoption.ReturnToFactory__c,'',partsoption.Fail_Code__c,partsoption.Account_Code__c,options,partsoption.isManual__c,false,false,false,false,false,false,'',''));
                            }catch(Exception ex){
                                System.debug('in catch of getallCustomPartsData of CSS_GSQParts adding wrapper>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                            }
                            System.debug('setpartWrapper>>>:'+setpartWrapper);
                        }
                        system.debug('customPartlstUI>>>>>>>>>>:'+customPartlstUI);
                    }
                    system.debug('setpartWrapper exist>>>>>>>>>>:'+setpartWrapper);
                } 
                else{  
                    listpartWrapper = new List<partWrapperClass>();
                    setpartWrapper = new Set<partWrapperClass>();
                    for(integer i=0;i<10;i++){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        // CSS_Solution_Component__c solCompRec = new CSS_Solution_Component__c();
                        //solCompRec = mapSolCompRec.get(partsoption.Fail_Code__c + partsoption.Account_Code__c);
                        //system.debug('KarthiksolCompRec>>>2'+solCompRec);
                        partsoption.Notes__c = '';
                        partsoption.OEM__c = '';
                        //partsoption.Quantity__c ='';
                        partsoption.Selected_part__c = false;
                        partsoption.Part_Name__c = '';
                        partsoption.ReturnToFactory__c = '';
                        //partsoption.Covered__c = '';
                        partsoption.Fail_Code__c = '';
                        partsoption.Account_Code__c = '';
                        //partsoption.Replacement_Reason__c='Refer to Narrative';
                        partsoption.Replacement_Reason__c='Select One';
                        partsoption.Service_partnumber__c = '';
                        partsoption.Parts_Type__c='Custom';
                        partsoption.isManual__c=false;

                        setpartWrapper.add(new partWrapperClass(i,null,'',partsoption.Service_partnumber__c,partsoption.Part_Name__c,partsoption.Replacement_Reason__c,partsoption.Notes__c,partsoption.OEM__c,partsoption.Selected_part__c,partsoption.ReturnToFactory__c,'',partsoption.Fail_Code__c,partsoption.Account_Code__c,options,partsoption.isManual__c,false,false,false,false,false,false,'',''));
                    }


                    system.debug('setpartWrapper else>>>>>>>>>>:'+setpartWrapper);
                }
                /*if(errMsgLst != null && errMsgLst.size() > 0){
                    for(partWrapperClass  prtslist:listpartWrapper){
                        if(errMsgLst != null && errMsgLst.contains(prtslist.accountCode)){
                            prtslist.isPartsCovLimitExceed = true;
                        }
                        else{
                            prtslist.isPartsCovLimitExceed = false;
                        }
                    }
                }
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
                }*/
                System.debug('11The listpartWrapper list is>>>>>>>>>:'+setpartWrapper+' displayPopup2>>>>:'+displayPopup2);
            }

            System.debug('111The listpartWrapper list is>>>>>>>>>:'+setpartWrapper+' displayPopup2>>>>:'+displayPopup2);
            if(setpartWrapper.size()>0){
                listpartWrapper.addAll(setpartWrapper);
            }

            System.debug('12The listpartWrapper list is>>>>>>>>>:'+setpartWrapper+' displayPopup2>>>>:'+displayPopup2);
            system.debug('customPartlstUI.size()'+customPartlstUI.size());
            if(customPartlstUI.size() > 0){
                isURPCovered = true;
                system.debug('if part');
            }
            else{
                system.debug('else part');
                CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                List<Boolean> coverageResult = new List<Boolean>();
                coverageResult = contr.checkFailuresCovered(Cid, false);
                system.debug('coverageResult--'+coverageResult);
                isURPCovered = coverageResult[0];
                //isURPCovered = false;
                system.debug('isURPCovered--'+isURPCovered);
            }
            System.debug('Final returning listpartWrapper list is>>>>>>>>>:'+listpartWrapper);

        }catch(Exception ex){
            System.debug('in catching of getallCustomPartsData of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }

    public void deleteParts(){
        System.debug('in deleteParts CG_CL_ClaimsUserRequestedParts');
        try{
            List<CSS_Parts_Options__c> toDeleteCustPartsList = new list<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> deleteCustPartsList = new List<CSS_Parts_Options__c>([select Id,Notes__c,OEM__c,Replacement_Reason__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c,Service_Job__c,Solutions__c
                                                                                             from CSS_Parts_Options__c where Id in:removeIdsMap.keySet()]);
            if(deleteCustPartsList.size()>0){
                for(CSS_Parts_Options__c d: deleteCustPartsList){
                    for(partWrapperClass  prtslist:listpartWrapper ){
                        System.debug('prtslist.servPartNumber'+prtslist.servPartNumber);
                        System.debug('prtslist.servPartNumber'+d.id + '------->'+prtslist.ids);
                        if(d.id==prtslist.ids && prtslist.servPartNumber=='' ){  //why servPartNumber included in if condition?
                            toDeleteCustPartsList.add(d); 
                            System.debug('delete list');}
                        else{
                        }

                    }     
                }
                if(toDeleteCustPartsList.size()>0)
                    delete toDeleteCustPartsList;
            }
            removeIdsMap = new Map<Id, String>();
        }catch(Exception ex) {
            System.debug('in catch of deleteParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    //Method for getting failcodes codes- 
    public List<SelectOption> getfailcodeDropDown(){
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        failAccountCodeMap = new  Map<String, Set<String>>();
        system.debug('Test+solsComp'+Wid+'99');
        if(Wid !=null){
            solsComp= [SELECT Id, SysCodeAndCompCode__c, Failure_Mode__c,FailCode_Formula__c , CSS_Claims__c,Type__c,CSS_Account_Formula__c,CoveredPartsQty__c,CampaignPartsPercentage__c,Selected_Component__c  from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Selected_Component__c= true]; 
        }
        system.debug('solsCompsize***'+solsComp.size()+'**solcomp***'+solsComp);
        options.add(new SelectOption('Select One','Select One'));
        if(solsComp.size()>0){
            Set<string> acCodeSet;
            for(CSS_Solution_Component__c f:solsComp)  {
                if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                    if(jobEventLst != null){
                        for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                            if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                coverageType = jobEntObj.Attribute1__c;
                            }
                        }
                    }
                    system.debug('coverageType***'+coverageType);
                }
                string cusFailCode = '';
                if(f.Type__c != null && f.Type__c != '')
                    cusFailCode = f.SysCodeAndCompCode__c + f.Failure_Mode__c;
                else
                    cusFailCode = f.SysCodeAndCompCode__c;
                system.debug('cusFailCode'+cusFailCode);
                if(f.FailCode_Formula__c!='Select One'&& cusFailCode !=null){//f.FailCode_Formula__c!='Select One'&& f.SysCodeAndCompCode__c!=null
                    if((f.CoveredPartsQty__c != null && Integer.valueOf(f.CoveredPartsQty__c) > 0 && (coverageType != 'OTH' && coverageType != 'POL')) ||
                       (f.CampaignPartsPercentage__c != null && Integer.valueOf(f.CampaignPartsPercentage__c) > 0 && (f.Type__c == 'TRP' || f.Type__c =='ATC' || f.Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))){
                        sortableSet.add(f.FailCode_Formula__c);
                        if(failAccountCodeMap.containsKey(cusFailCode)){//f.SysCodeAndCompCode__c
                            system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                            acCodeSet = failAccountCodeMap.get(cusFailCode);//f.SysCodeAndCompCode__c
                            system.debug('**acCodeSet**'+acCodeSet);
                            if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            system.debug('**acCodeSet*'+cusFailCode+'***'+acCodeSet);
                            failAccountCodeMap.put(cusFailCode, acCodeSet);////f.SysCodeAndCompCode__c
                        }  
                        else{
                            system.debug('**insidecontainkey---else');
                            acCodeSet = new Set<string>();
                            if(f.CSS_Account_Formula__c != null){
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            system.debug('**sortableSet*'+cusFailCode+'***'+sortableSet);
                            failAccountCodeMap.put(cusFailCode, acCodeSet);////f.SysCodeAndCompCode__c
                        }
                    }
                    else{
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            sortableSet.add(f.FailCode_Formula__c);
                            system.debug('failAccountCodeMap'+failAccountCodeMap);
                            if(failAccountCodeMap.containsKey(cusFailCode)){//f.SysCodeAndCompCode__c
                                system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                                acCodeSet = failAccountCodeMap.get(cusFailCode);//f.SysCodeAndCompCode__c
                                system.debug('**acCodeSet**'+acCodeSet);
                                if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**acCodeSet*'+cusFailCode+'***'+acCodeSet);
                                failAccountCodeMap.put(cusFailCode, acCodeSet);//f.SysCodeAndCompCode__c
                            }
                            else{
                                system.debug('**insidecontainkey---else');
                                acCodeSet = new Set<string>();
                                if(f.CSS_Account_Formula__c != null){
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**sortableSet*'+cusFailCode+'***'+sortableSet);
                                failAccountCodeMap.put(cusFailCode, acCodeSet);////f.SysCodeAndCompCode__c
                            }
                        }
                    }
                    /*if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                        system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                        acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                        system.debug('**acCodeSet**'+acCodeSet);
                        if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                            if(coverageType == 'OTH' || coverageType == 'POL'){
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            else{
                                if(f.CSS_Account_Formula__c !='Select One' && Integer.valueOf(f.CoveredPartsQty__c) >0 && f.Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL'))
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignPartsPercentage__c != null  && Integer.valueOf(f.CampaignPartsPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                        }
                        system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                        failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                    }
                    else{
                        system.debug('**insidecontainkey---else');
                        acCodeSet = new Set<string>();
                        if(f.CSS_Account_Formula__c != null){
                            if(jobEventLst != null){
                                for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                                    if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                        coverageType = jobEntObj.Attribute1__c;
                                    }
                                }
                            }
                            system.debug('coverageType***'+coverageType);
                            if(coverageType == 'OTH' || coverageType == 'POL'){
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            else{
                                system.debug('CSS_Account_Formula__c***'+f.CSS_Account_Formula__c);
                                system.debug('CoveredPartsQty__c***'+f.CoveredPartsQty__c);
                                system.debug('CampaignPartsPercentage__c***'+f.CampaignPartsPercentage__c);
                                system.debug('Type__c***'+f.Type__c);
                                if(f.CSS_Account_Formula__c !='Select One' && f.CoveredPartsQty__c != null && Integer.valueOf(f.CoveredPartsQty__c) >0 && f.Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL'))
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignPartsPercentage__c != null  && Integer.valueOf(f.CampaignPartsPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                        }
                        system.debug('**sortableSet*'+f.SysCodeAndCompCode__c+'***'+sortableSet);
                        failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                    }*/


                }
                system.debug('sortableSet  ' +  sortableSet);
                system.debug('failAccountCodeMap***' +  failAccountCodeMap);
            }
        }


        if(sortableSet.size()>0){
            system.debug('sortableSet2  ' +  sortableSet.size());
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            system.debug('sortable3  ' +  sortable);
            for(String s:sortable)    
            {    
                options.add(new selectOption(s,s));                    
            }  
            system.debug('options  ' +  options);
        }
        return Options;   
    }
    //END

    //Old account code drop down
    /*public List<SelectOption> getAccountCodeDropDown() {
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        system.debug('Inside method');
        try{

            string orgtype=css_utility.getOrgType(userinfo.getUserId());
            system.debug('****Cidacc***'+Cid);
            claimsObj=[Select Id,Name,Customer_Name__c,Shop_Work_Order__c,
                       Service_Model__c, Customer_Code__c,Status__c, Location__c,ESN__c, Location_Code__c 
                       from CSS_Claims__c where id= :Cid];
            system.debug('****ClaimsObjacc***'+claimsObj);
            //List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:Cid and Type__c NOT IN ('TRP','ATC','Campaign')];
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c,CampaignPartsPercentage__c,Selected_Component__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:Cid];
            system.debug('****Location__c***'+claimsObj.Location__c);
            Account Regionterritory = css_utility.getRegionTerritory(claimsObj.Location__c);

            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;

            system.debug('orgtype--->'+orgtype);
            system.debug('Regionterritory--->'+Regionterritory);
            system.debug('userRole--->'+userRole);

            if(userRole != null && (userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE'))) 
            {
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            else{ 
                if (orgtype=='DISTR'){
                    system.debug('Inside DISTR');
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc LIMIT 1];
                }
                else{
                    if(Regionterritory != null && Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute7__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Account_Code__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                }
            }
            accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Select One','Select One'));

            for(CSS_Solution_Component__c solcmp : SolCmps){ 
                if(solcmp.CSS_Account_Formula__c != null){
                    if(jobEventLst != null){
                        for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                            if(jobEntObj.Account_Code__c == solcmp.CSS_Account_Formula__c){
                                coverageType = jobEntObj.Attribute1__c;
                            }
                        }
                    }
                    system.debug('coverageType***'+coverageType);
                    if(coverageType == 'OTH' || coverageType == 'POL'){
                        sortableSet.add(solcmp.CSS_Account_Formula__c); 
                    }
                    else{
                        if(solcmp.CSS_Account_Formula__c !='Select One' && Integer.valueOf(solcmp.CoveredPartsQty__c) >0 && solcmp.Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL'))
                            sortableSet.add(solcmp.CSS_Account_Formula__c);
                        else if(solcmp.CSS_Account_Formula__c !='Select One' && SolCmp.CampaignPartsPercentage__c != null  && Integer.valueOf(solcmp.CampaignPartsPercentage__c) >0 && (solcmp.Type__c == 'TRP'|| solcmp.Type__c =='ATC'||solcmp.Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))
                            sortableSet.add(solcmp.CSS_Account_Formula__c);
                    }


                }
                //if(solcmp.CSS_Account_Formula__c !=null)
                  //  sortableSet.add(solcmp.CSS_Account_Formula__c);
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
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage() + ex.getLineNumber());

        }
        system.debug('accCodes***'+ accCodes);
        return accCodes;        

    }*/

    public List<SelectOption> getAccountCodeDropDown(String selectedFailCode) {
        List<SelectOption> options;
        try{
            //system.debug('failAccountCodeMapsize****'+failAccountCodeMap.size());
            system.debug('failAccountCodeMap****'+failAccountCodeMap);
            system.debug('selectedFailCode****'+selectedFailCode);
            String failCode1;
            String[] tempStr;
            if(selectedFailCode != null && selectedFailCode != ''){ //Added null check for "selectedFailCode" as part of the defect #GSSC-371
                if(selectedFailCode.contains('-')){
                    tempStr = selectedFailCode.split('-');
                    failCode1=tempStr[1];
                }
                else{
                  failCode1=selectedFailCode;
                }
            } else {
                failCode1=selectedFailCode;
            }
            /*if(selectedFailCode.contains('-')){
                tempStr = selectedFailCode.split('-');
                if(tempStr[1].length()>4){
                    failCode1=tempStr[1].LEFT(4);
                }
                else{
                    failCode1=tempStr[1];
                }
            }
            else{
                if(selectedFailCode.length()>4){
                    failCode1=selectedFailCode.LEFT(4);
                }
                else{
                    failCode1=selectedFailCode;
                }
            }*/
            options =  new List<SelectOption>();
            system.debug('failCode1****'+failCode1);
            //system.debug('selectedFailCodecontains****'+failAccountCodeMap.containsKey(failCode1));
            if(selectedFailCode==null || failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || !failAccountCodeMap.containsKey(failCode1)){
                system.debug('insideFCIFnull***');
                options.add(new SelectOption('Select One','Select One'));
                return options;
            }

            List<string> sortable = new  List<string>();

            if(failAccountCodeMap.containsKey(failCode1)){
                system.debug('**insidefailaccMap');
                Set<string> acCodeSet = failAccountCodeMap.get(failCode1);
                if(acCodeSet.size()>0){
                    options.add(new SelectOption('Select One','Select One'));
                    sortable.AddAll(acCodeSet);}
                else{
                    options.add(new SelectOption('Select One','Select One'));
                }
                sortable.sort();
                if (sortable.size()>0){
                    for(String s:sortable){    
                        options.add(new selectOption(s,s));                    
                    }   
                }
            }
            system.debug('***final ac options' + options);
        }catch(Exception ex) {
            System.debug('in catch of getAccountCodeOptionList>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }

    public void onChangeofPartNumber(Integer selPartnumberr){
        try{
            system.debug('Method goining inside onChangeofPartNumber');
            system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
            system.debug('SelectedPartID>>>>>>>>>>: '+selPartnumberr);
            String accCode;
            String CoveredPar ='';

            list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();

            lstSolComp= [SELECT Id, SysCodeAndCompCode__c,In_Shop_SRT_Limit_Flag__c,CampaignLaborPercentage__c,fail_code__c, FailCode_Formula__c ,CSS_CoverageType__c,Covered_Parts__c,Failure_Mode__c, CSS_Claims__c,Type__c,CSS_Account_Formula__c,CoveredPartsQty__c,CampaignPartsPercentage__c,Selected_Component__c  from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Selected_Component__c= true];
            
            //GSSC-300
            List<SelectOption> options;
            
            String failCode;
            String[] tempStr;
            Map<String,List<CSS_Solution_Component__c>> solCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
            Map<String,List<CSS_Solution_Component__c>> FAMap = new Map<String,List<CSS_Solution_Component__c>>();
            List<CSS_Solution_Component__c> failureList;
            List<CSS_Solution_Component__c> FAList;
            system.debug('lstSolComp>>'+lstSolComp);
            if(lstSolComp != null && lstSolComp.size() > 0){
                system.debug('lstSolComp>>'+lstSolComp);
                List<CSS_Solution_Component__c> tempList;
                for(CSS_Solution_Component__c slcp : lstSolComp){
                    String FARec;
                    if(slcp.Type__c == 'Campaign' || slcp.Type__c == 'TRP' || slcp.Type__c == 'ATC')
                        FARec='FieldAction';
                    else
                        FARec='Failure';
                    system.debug('FARec>>'+FARec);
                    if(solCmpMap.containsKey(FARec)){
                        tempList = solCmpMap.get(FARec);
                        system.debug('tempList'+tempList);
                        tempList.add(slcp);
                        system.debug('tempList'+tempList);
                        solCmpMap.put(FARec, tempList);
                    }
                    else{
                        tempList = new List<CSS_Solution_Component__c>();
                        tempList.add(slcp);
                        system.debug('tempList'+tempList);
                        solCmpMap.put(FARec, tempList);
                    }
                    system.debug('solCmpMap'+solCmpMap);
                }
                failureList = new List<CSS_Solution_Component__c>();
                FAList = new List<CSS_Solution_Component__c>();
                Map<String,List<CSS_Solution_Component__c>> accSolCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
                List<CSS_Solution_Component__c> accSlCmp;
                if(solCmpMap != null){
                    failureList = solCmpMap.get('Failure');
                    FAList = solCmpMap.get('FieldAction');
                }
                system.debug('FAList**'+FAList);
                if(FAList!=null && failureList == null){
                    options=getAccountCodeDropDown(FAList[0].fail_code__c);
                    List<CSS_Solution_Component__c> tempListFA;
                    for(CSS_Solution_Component__c slcp : FAList){
                        String InshopFlag;
                        if(slcp.In_Shop_SRT_Limit_Flag__c == true)
                            InshopFlag='Y';
                        else
                            InshopFlag='N';
                        if(FAMap.containsKey(InshopFlag)){
                            tempListFA = FAMap.get(InshopFlag);
                            system.debug('tempListFA'+tempListFA);
                            tempListFA.add(slcp);
                            system.debug('tempListFA'+tempListFA);
                            FAMap.put(InshopFlag, tempListFA);
                        }
                        else{
                            tempListFA = new List<CSS_Solution_Component__c>();
                            tempListFA.add(slcp);
                            FAMap.put(InshopFlag, tempListFA);
                        }
                    }
                    tempListFA = new List<CSS_Solution_Component__c>();
                    for(String slcmpKey: FAMap.keySet()){
                        tempListFA = FAMap.get(slcmpKey);
                        system.debug('tempListFA****'+tempListFA);
                        if(slcmpKey == 'N' && tempListFA.size()==1){
                            system.debug('insideIf***');
                            if((tempListFA[0].CampaignLaborPercentage__c != null && tempListFA[0].CampaignLaborPercentage__c != '' && Double.valueOf(tempListFA[0].CampaignLaborPercentage__c) >0 && (tempListFA[0].CSS_CoverageType__c != 'OTH' && tempListFA[0].CSS_CoverageType__c != 'POL')) || (tempListFA[0].CSS_CoverageType__c == 'OTH' || tempListFA[0].CSS_CoverageType__c == 'POL')){
                                failCode=String.valueof(tempListFA[0].FailCode_Formula__c);
                                system.debug('CSS_Account_Formula__c****'+tempListFA[0].CSS_Account_Formula__c);
                                AccCode=tempListFA[0].CSS_Account_Formula__c;
                            }
                            system.debug('failCode***'+failCode);
                            system.debug('AccCode***'+AccCode);
                        }
                        else
                            continue;
                    }
                }
                
                if(failureList!=null)
                options=getAccountCodeDropDown(failureList[0].fail_code__c);//GSSC-190 changed from systemcode and comp code field to fail_code to fix auto population issue
                
                system.debug('**failureList*'+failureList);
                system.debug('**options*'+options);
                if(failureList!=null && failureList.size() >1){
                    for(CSS_Solution_Component__c sc:failureList){
                        if(accSolCmpMap.containsKey(sc.CSS_Account_Formula__c)){
                            accSlCmp=accSolCmpMap.get(sc.CSS_Account_Formula__c);
                            accSlCmp.add(sc);
                            accSolCmpMap.put(sc.CSS_Account_Formula__c,accSlCmp);
                        }
                        else{
                            accSlCmp = new List<CSS_Solution_Component__c>();
                            accSlCmp.add(sc);
                            accSolCmpMap.put(sc.CSS_Account_Formula__c, accSlCmp);
                        }
                    }
                }
                
                if(failureList !=null && failureList.size() >0){
                    if((failureList.size() == 1 && failureList[0].CoveredPartsQty__c != null && Integer.valueOf(failureList[0].CoveredPartsQty__c) >0 && failureList[0].CSS_CoverageType__c != 'OTH' && failureList[0].CSS_CoverageType__c != 'POL') || (failureList.size() == 1 &&(failureList[0].CSS_CoverageType__c == 'OTH' || failureList[0].CSS_CoverageType__c == 'POL'))){
                        CoveredPar =  failureList[0].CoveredPartsQty__c; 
                        failCode =  String.valueof(failureList[0].FailCode_Formula__c);
                        accCode = failureList[0].CSS_Account_Formula__c;
                    }
                    else if((failureList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1 && failureList[0].CoveredPartsQty__c != null && Integer.valueOf(failureList[0].CoveredPartsQty__c) >0 && failureList[0].CSS_CoverageType__c != 'NPW' && failureList[0].CSS_CoverageType__c != 'RPW' && failureList[0].CSS_CoverageType__c != 'RRW' && failureList[0].CSS_CoverageType__c != 'OTH' && failureList[0].CSS_CoverageType__c != 'POL') || (failureList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1 &&(failureList[0].CSS_CoverageType__c == 'OTH' || failureList[0].CSS_CoverageType__c == 'POL'))){
                        system.debug('**insideelseIf*'+failureList[0].CSS_Account_Formula__c);
                        CoveredPar =  failureList[0].CoveredPartsQty__c; 
                        failCode =  String.valueof(failureList[0].FailCode_Formula__c);
                        accCode = failureList[0].CSS_Account_Formula__c;
                    }
                    else{
                        failCode =  'Select One';
                        accCode = 'Select One';
                    }
                    
                }
            }
            
            if(CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0 && (failureList!=null && failureList[0].CSS_CoverageType__c!='POL')){  // karthik G Added POL condtion  as part of defect 191853
                CoveredPar = '100'; 

            }
            else if(((CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0) || (CoveredPar=='' || Integer.ValueOf(CoveredPar) == 0)) && (failureList!=null && failureList[0].CSS_CoverageType__c == 'POL')){
                CoveredPar = lstSolComp[0].Covered_Parts__c;  // karthik G added as part of story GSSC-57 

            }
            else if(CoveredPar!='' && Integer.ValueOf(CoveredPar) == 0 ){
                CoveredPar = '0';
            }

            else{
                CoveredPar = '';
            } 
            for(partWrapperClass  prtslist:listpartWrapper2 ){
                system.debug( 'prtslist.counting'+prtslist.counting);
                if(prtslist.counting == selPartnumberr)
                {
                    prtslist.failCode =  failCode;
                    prtslist.returnToFactory='';
                    prtslist.accountCode = accCode ;
                  // if(failureList[0].CSS_CoverageType__c!=null || )
                      if(failureList!=null){
                    prtslist.coveragetypeval = failureList[0].CSS_CoverageType__c; //coverage type added GSSC-57
                    prtslist.coveredpartsper = String.valueof(failureList[0].Covered_Parts__c);
                      }
                    prtslist.lstAccountCodes=options;
                    system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                    if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                        prtslist.coveredPercent='';
                    else
                        prtslist.coveredPercent=CoveredPar;
                    if(failureList!=null)
                     prtslist.coveredpartsper = failureList[0].Covered_Parts__c;

                }


            }
            //GSSC-300

            /*if(lstSolComp != null && lstSolComp.size() == 1){
                system.debug('***wid****'+Wid);
                //List<SelectOption> options=getAccountCodeDropDown(lstSolComp[0].SysCodeAndCompCode__c);
                 List<SelectOption> options=getAccountCodeDropDown(lstSolComp[0].fail_code__c);//GSSC-190 changed from systemcode and comp code field to fail_code to fix auto population issue
                system.debug('lstSolComp'+lstSolComp);
                system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
                system.debug('lstSolComp[0].CoveredPartsQty__c'+lstSolComp[0].CoveredPartsQty__c);
                if((lstSolComp[0].CoveredPartsQty__c!=null && lstSolComp[0].CoveredPartsQty__c!='' && Double.valueOf(lstSolComp[0].CoveredPartsQty__c) >0 && lstSolComp[0].Selected_Component__c== true && coverageType != 'OTH' && coverageType != 'POL') || ((coverageType == 'OTH' || coverageType == 'POL') &&  lstSolComp[0].Selected_Component__c== true) ){//&& (coverageType != 'OTH' && coverageType != 'POL')
                    CoveredPar =  lstSolComp[0].CoveredPartsQty__c; 
                    accCode =lstSolComp[0].CSS_Account_Formula__c;    

                }
                else if((lstSolComp[0].CampaignPartsPercentage__c != null && lstSolComp[0].CampaignPartsPercentage__c!='' && Double.valueOf(lstSolComp[0].CampaignPartsPercentage__c) >0 && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign') && coverageType != 'OTH' && coverageType != 'POL') ||((coverageType == 'OTH' && coverageType == 'POL') && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign')) ){
                    accCode =lstSolComp[0].CSS_Account_Formula__c; 
                    CoveredPar =  lstSolComp[0].CampaignPartsPercentage__c; 

                }


                if(CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0 && (coverageType!='POL')){  // karthik G Added POL condtion  as part of defect 191853
                    CoveredPar = '100'; 

                }
                else if(((CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0) || (CoveredPar=='' || Integer.ValueOf(CoveredPar) == 0)) && coverageType == 'POL'){
                    CoveredPar = lstSolComp[0].Covered_Parts__c;  // karthik G added as part of story GSSC-57 

                }
                else if(CoveredPar!='' && Integer.ValueOf(CoveredPar) == 0 ){
                    CoveredPar = '0';
                }

                else{
                    CoveredPar = '';
                }            
                system.debug('CoveredParts>>>>>>>>>>: '+CoveredPar);
                system.debug('listpartWrapper'+listpartWrapper2);
                for(partWrapperClass  prtslist:listpartWrapper2 ){
                    system.debug( 'prtslist.counting'+prtslist.counting);
                    if(prtslist.counting == selPartnumberr)
                    {
                        prtslist.failCode =  String.valueof(lstSolComp[0].FailCode_Formula__c);
                        prtslist.returnToFactory='';
                        prtslist.accountCode = accCode ;
                        prtslist.coveragetypeval = lstSolComp[0].CSS_CoverageType__c; //coverage type added GSSC-57
                        prtslist.coveredpartsper = String.valueof(lstSolComp[0].Covered_Parts__c);
                        prtslist.lstAccountCodes=options;
                        system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                        if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                            prtslist.coveredPercent='';
                        else
                            prtslist.coveredPercent=CoveredPar;
                         prtslist.coveredpartsper = lstSolComp[0].Covered_Parts__c;

                    }


                }
            }*/
        }catch(exception e){
            system.debug('Entered into catch block of onChangeofPartNumber method in cg_cl_claimsuserRequestedParts class'+e.getlinenumber()+e.getMessage());
        }
    }

    public void onChangeofFailCode(){
        system.debug('Method goining inside onChangeofFailCode');
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('SelectedPartID>>>>>>>>>>: '+SelectedPartID);
        failAccCodeErrorMessage=false;
        String accCode;
        String CoveredPar ='';
        String failCode1;
        String[] tempStr;
        if(selectedFailCode.contains('-')){
            tempStr = selectedFailCode.split('-');
            //if(tempStr[1].length()>4){
            //system.debug('insideFCIF '+tempStr[1]);
            //failCode1=tempStr[1].LEFT(4);
            //}
            //else{
            failCode1=tempStr[1];
            //}
        }
        else{
            failCode1=selectedFailCode;
        }

        system.debug('failCode1.length()' + failCode1.length());
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        if(SelectedFailCode!='Select One'){
            try{
            system.debug('***wid****'+Wid);
            List<SelectOption> options=getAccountCodeDropDown(failCode1);
            //lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,AccountCode__c,CoveredOCAmount__c,AccountCodeType__c,AccountCodeEdit__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c = :SelectedFailCode AND CSS_Account_Formula__c!='' and Type__c NOT IN ('TRP','ATC','Campaign')];
            if(failCode1!=null && failCode1!='' && failCode1.length()==4) 
                lstSolComp = [SELECT  Id,CSS_Account_Formula__c,SysCodeAndCompCode__c,CSS_CoverageType__c, Covered_Parts__c,Failure_Mode__c,CoveredPartsQty__c,AccountCode__c,CoveredOCAmount__c,AccountCodeType__c,AccountCodeEdit__c,CampaignPartsPercentage__c,Selected_Component__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and SysCodeAndCompCode__c = :failCode1 AND CSS_Account_Formula__c!=''];
            else
                lstSolComp = [SELECT  Id,CSS_Account_Formula__c,SysCodeAndCompCode__c, CSS_CoverageType__c,Covered_Parts__c,Failure_Mode__c,CoveredPartsQty__c,AccountCode__c,CoveredOCAmount__c,AccountCodeType__c,AccountCodeEdit__c,CampaignPartsPercentage__c,Selected_Component__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and Fail_Code__c = :failCode1 AND CSS_Account_Formula__c!=''];

            system.debug('lstSolComp'+lstSolComp);
            system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
            // system.debug('lstSolCompsize'+lstSolComp[0].CSS_Account_Formula__c);
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
                    system.debug('karthikG');
                    accCode =lstSolComp[0].CSS_Account_Formula__c; 
                }
                //if(lstSolComp[0].CoveredOCAmount__c!=null && lstSolComp[0].CoveredOCAmount__c!='')
                //CoveredPar =  lstSolComp[0].CoveredOCAmount__c; 
                if(jobEventLst != null){
                    for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                        if(jobEntObj.Account_Code__c == lstSolComp[0].CSS_Account_Formula__c){
                            coverageType = jobEntObj.Attribute1__c;
                            break;
                        }
                    }
                }
                system.debug('coverageType***'+coverageType);
                /*if(coverageType == 'OTH' || coverageType == 'POL'){
                    if(lstSolComp[0].Selected_Component__c== true){
                        CoveredPar =  lstSolComp[0].CoveredPartsQty__c; 
                    }
                    else if(lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign'){
                        CoveredPar =  lstSolComp[0].CampaignPartsPercentage__c; 
                    }
                }
                else{*/
                system.debug('lstSolComp[0].CoveredPartsQty__c'+lstSolComp[0].CoveredPartsQty__c);
                if((lstSolComp[0].CoveredPartsQty__c!=null && lstSolComp[0].CoveredPartsQty__c!='' && Double.valueOf(lstSolComp[0].CoveredPartsQty__c) >0 && lstSolComp[0].Selected_Component__c== true && coverageType != 'OTH' && coverageType != 'POL') )//&& (coverageType != 'OTH' && coverageType != 'POL')
                    CoveredPar =  lstSolComp[0].CoveredPartsQty__c; 
                else if (lstSolComp[0].Covered_Parts__c!=null && lstSolComp[0].Covered_Parts__c!='' && Double.valueOf(lstSolComp[0].Covered_Parts__c) >0 && lstSolComp[0].Selected_Component__c== true && (coverageType == 'OTH' || coverageType == 'POL'))
                    CoveredPar =  lstSolComp[0].Covered_Parts__c;
                    else if((lstSolComp[0].CampaignPartsPercentage__c != null && lstSolComp[0].CampaignPartsPercentage__c!='' && Double.valueOf(lstSolComp[0].CampaignPartsPercentage__c) >0 && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign') && coverageType != 'OTH' && coverageType != 'POL') ||((coverageType == 'OTH' && coverageType == 'POL') && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign')) )//&& (coverageType != 'OTH' && coverageType != 'POL')
                        CoveredPar =  lstSolComp[0].CampaignPartsPercentage__c; 
                //}

            }

            //Defect:190397.
            system.debug('amount'+CoveredPar);
            system.debug('amount'+CoveredPar);
            if(coverageType != 'POL' && coverageType != 'OTH'){
                if(CoveredPar!=null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0){
                    CoveredPar = '100';
                }
                else{
                    CoveredPar = '0';
                }
            }
            else{
                if(coverageType == 'POL' || coverageType == 'OTH'){
                    if(CoveredPar!=null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0){
                        CoveredPar =  lstSolComp[0].Covered_Parts__c;
                    }
                    else{
                        CoveredPar = '0';
                    }
                }
            }


            /* if((CoveredPar != null && CoveredPar != '') || (lstSolComp[0].CSS_CoverageType__c!=null && lstSolComp[0].CSS_CoverageType__c == 'POL' )) { // Karthik G Added POl condtion as part of 191853
                system.debug('karthikGentered');
                if((CoveredPar!=null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0) && ( lstSolComp[0].CSS_CoverageType__c != null && lstSolComp[0].CSS_CoverageType__c == 'POL')  ){
                    // CoveredPar = '100';
                    CoveredPar = lstSolComp[0].Covered_Parts__c;  // karthik G added as part of story GSSC-57 
                }
                else if((CoveredPar!=null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0) && ( lstSolComp[0].CSS_CoverageType__c != null && lstSolComp[0].CSS_CoverageType__c != 'POL' && lstSolComp[0].CSS_CoverageType__c != 'OTH')  ){
                    system.debug('KarthikG++'+CoveredPar);
                   CoveredPar = '100';
                }

                else if(Integer.ValueOf(CoveredPar) == 0){
                    system.debug('KarthikG++'+CoveredPar);
                    CoveredPar = '0';
                }
                else
                    CoveredPar = '';
            } else
                CoveredPar = '';  
                */

            /*
            if(CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0 ){
                CoveredPar = '100';
            }
            else if(CoveredPar!='' && Integer.ValueOf(CoveredPar) == 0){
                CoveredPar = '0';

            }
            else{
                CoveredPar = '';
            } 
            */
            system.debug('CoveredParts>>>>>>>>>>: '+CoveredPar);

            for(partWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.failCode =  String.valueof(SelectedFailCode);
                    prtslist.returnToFactory='';
                    prtslist.accountCode = accCode ;
                    prtslist.coveragetypeval = lstSolComp[0].CSS_CoverageType__c; // coverage type added GSSC-57
                    prtslist.lstAccountCodes=options;
                    system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                    if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                        prtslist.coveredPercent='';
                    else
                        prtslist.coveredPercent=CoveredPar;
                         prtslist.coveredpartsper = lstSolComp[0].Covered_Parts__c;

                }
                system.debug('CoveredParts>>>>>>>>>>: '+prtslist.coveredPercent);

            }
        } catch (Exception e) {
                system.debug('Error in Cust Parts Delete Component ## ' + e.getmessage());
            
        }
        }
        else{
            accCode='Select One';
            CoveredPar='';
            List<SelectOption> options =  new List<SelectOption>();
            options.add(new SelectOption('Select One','Select One'));

            for(partWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.failCode =  String.valueof(SelectedFailCode);
                    prtslist.coveredPercent='';
                    prtslist.accountCode = accCode ;
                    prtslist.lstAccountCodes=options;
                    prtslist.returnToFactory='';
                    prtslist.coveragetypeval = ''; //coverage type added GSSC-57
                    prtslist.coveredpartsper = '';
                }
            } 
        }
        system.debug('listpartWrapper>>>>>>>>>>: '+listpartWrapper);
    }

    public void onChangeofAccountCode(){
        system.debug('Method goining inside onChangeofAccountCode');
        system.debug('SelectedAccountCode>>>>>>>>>>: '+SelectedAccountCode);
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('SelectedPartID>>>>>>>>>>: '+SelectedPartID);
        String CoveredParAC ='';
        list<CSS_Solution_Component__c> lstSolComp1 = new list<CSS_Solution_Component__c>();
        String[] tempStr;
        String failCode1;
        tempStr = selectedFailCode.split('-');
        //if(tempStr[1].length()>4){
        //system.debug('insideFCIF '+tempStr[1]);
        //failCode1=tempStr[1].LEFT(4);
        //}
        //else{
        failCode1=tempStr[1];
        //}
        if(SelectedAccountCode!='Select One'){
            //lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and (CSS_Account_Formula__c = :SelectedAccountCode and FailCode_Formula__c = :SelectedFailCode and CSS_Account_Formula__c!='' and Type__c NOT IN ('TRP','ATC','Campaign')) ];
            lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CSS_CoverageType__c,CoveredOCAmount__c,Covered_Parts__c,FailCode_Formula__c,Failure_Mode__c, SysCodeAndCompCode__c,CampaignPartsPercentage__c,Selected_Component__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and CSS_Account_Formula__c = :SelectedAccountCode and SysCodeAndCompCode__c = :failCode1 and CSS_Account_Formula__c!=''];
            system.debug('lstSolComp1'+lstSolComp1);
            if(lstSolComp1!=null && lstSolComp1.size()!=0){
                system.debug('listpartWrapper-->'+listpartWrapper);

                //if(lstSolComp1[0].CoveredOCAmount__c!=null && lstSolComp1[0].CoveredOCAmount__c!='')
                //CoveredParAC =  lstSolComp1[0].CoveredOCAmount__c; 
                system.debug('jobEventLst..'+jobEventLst);

                if(jobEventLst != null){
                    for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                        if(jobEntObj.Account_Code__c == SelectedAccountCode){
                            coverageType = jobEntObj.Attribute1__c;
                            break;
                        }
                    }
                }
                system.debug('coverageType***'+coverageType);
                if(coverageType == 'OTH' || coverageType == 'POL' ){
                    if(lstSolComp1[0].Selected_Component__c== true){
                        CoveredParAC =  lstSolComp1[0].Covered_Parts__c; 
                    }
                    else if(lstSolComp1[0].Type__c == 'TRP'|| lstSolComp1[0].Type__c =='ATC'||lstSolComp1[0].Type__c =='Campaign'){
                        CoveredParAC =  lstSolComp1[0].CampaignPartsPercentage__c; 
                    }

                }
                else{
                    if(Integer.valueOf(lstSolComp1[0].CoveredPartsQty__c) >0 && lstSolComp1[0].Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL'))
                        CoveredParAC =  lstSolComp1[0].CoveredPartsQty__c; 
                    else if(lstSolComp1[0].CampaignPartsPercentage__c != null && Integer.valueOf(lstSolComp1[0].CampaignPartsPercentage__c) >0 && (lstSolComp1[0].Type__c == 'TRP'|| lstSolComp1[0].Type__c =='ATC'||lstSolComp1[0].Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))
                        CoveredParAC =  lstSolComp1[0].CampaignPartsPercentage__c; 
                }

                if(coverageType != 'POL' && coverageType != 'OTH'){
                    if(CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0){
                        CoveredParAC = '100';
                    }
                    else{
                        CoveredParAC = '0';
                    }
                }
                else{
                    if(coverageType == 'POL' || coverageType == 'OTH'){
                        if(CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0){
                            CoveredParAC =  lstSolComp1[0].Covered_Parts__c;
                        }
                        else{
                            CoveredParAC = '0';
                        }
                    }
                }
                
                for(partWrapperClass  prtslist:listpartWrapper ){
                    if(prtslist.counting == SelectedPartID){
                        prtslist.accountCode =  String.valueof(SelectedAccountCode);
                        prtslist.coveragetypeval = lstSolComp1[0].CSS_CoverageType__c; //coverage type added GSSC-57
                        prtslist.returnToFactory='';
                        if((prtslist.accountCode == null || prtslist.accountCode == 'Select One') && (prtslist.failCode == null || prtslist.failCode == 'Select One'))
                            prtslist.coveredPercent='';
                        else
                            prtslist.coveredPercent=CoveredParAC; 
                             prtslist.coveredpartsper = lstSolComp1[0].Covered_Parts__c;


                    }              
                }
            } 
            else{
                for(partWrapperClass  prtslist:listpartWrapper ){
                    if(prtslist.counting == SelectedPartID){
                        prtslist.accountCode =  String.valueof(SelectedAccountCode);
                        prtslist.returnToFactory='';
                        system.debug('****CoveredParAC****'+CoveredParAC);
                        if(CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0 ){
                            CoveredParAC = '100';
                        } 

                        else if(CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) == 0){
                            CoveredParAC = '0';

                        }
                        else{
                            CoveredParAC = '';
                        }
                        // prtslist.coveredPercent='0';
                        prtslist.coveredPercent=CoveredParAC;
                        //Commented below 2 lines becasue we never get index values as per defect #GSSC-346,-By RAJESH 15th Nov 2019        
                        //prtslist.coveragetypeval = lstSolComp1[0].CSS_CoverageType__c;  //coverage type added GSSC-57
                         //prtslist.coveredpartsper = lstSolComp1[0].Covered_Parts__c;
                    }    
                }
            }
        }
        else  {
            CoveredParAC='';
            system.debug('else part');
            for(partWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.accountCode =  String.valueof(SelectedAccountCode);
                    prtslist.coveredPercent='';
                    prtslist.returnToFactory='';
                    system.debug('coveredPercent-->'+prtslist.coveredPercent);
                    prtslist.coveragetypeval = '';  //coverage type added GSSC-57
                     prtslist.coveredpartsper = '';
                }
            }            
        }
    } 

    public PageReference saveCustomParts()
    {

        system.debug('The Is manual is set to be true.');
        System.debug('in saveCustomParts CG_CL_ClaimsUserRequestedParts');
        Integer count =0;
        system.debug('############inside saveCustomParts##############');
        chkReqField = false;
        ErrorMessage = false;
        failAccCodeErrorMessage = false;
        PartNotFoundError = false;
        PartNoValidationError = false;
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();//The list containing part data that to be saved
        PageReference pageRef;
        try{
            system.debug(' count'+count);

            //Remove logic here
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            try{
                if(removeIdsMap.keySet().size()>0){
                    deleteParts();
                }
            }catch(Exception e) {
                system.debug('Error in Cust Parts Delete Component ## ' + e.getmessage());
            }

            System.debug('The listpartWrapper savelist list is>>>>>>>>>:'+listpartWrapper);
            integer count1=0;
            integer count2=0;
            integer m=0;
            set<boolean> setduplicatecheck = new set<boolean>();
            set<boolean> setFCACCMess = new set<boolean>();
            for(partWrapperClass  prtslist:listpartWrapper )
            {
                boolean z;
                system.debug('***prtslist.servPartNumber'+prtslist.servPartNumber);
                system.debug('***prtslist.quantity'+prtslist.quantity);
                system.debug('***prtslist.replacementReasson'+prtslist.replacementReasson);
                system.debug('***prtslist.oem'+prtslist.oem);
                system.debug('***prtslist.failCode'+prtslist.failCode);
                system.debug('***prtslist.failCode'+prtslist.accountcode);
                system.debug('***prtslist.partName'+prtslist.partName);
                system.debug('***prtslist.coveredPercent'+prtslist.coveredPercent);
                
                //if(((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') || (prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.oem!=null && prtslist.oem!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='')) && (prtslist.partName == '' || prtslist.partName == null)){
                if(((prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.oem!=null && prtslist.oem!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='')) && (prtslist.servPartNumber == '' || prtslist.servPartNumber == null)){
                    system.debug('****insideifpartlist');
                    ErrorMessage =true;
                    displayPopup2 = true;
                    count=count+1;
                    system.debug(' count'+count);
                    System.debug('inside error displayPopup2:'+displayPopup2);
                    return null;
                }
                //<!--Added below  code for showing filcode and account code error message as per story #176379 Kung Fu Panda sprint,-By RAJESH 11th Mar 2019----->                 
                if((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') && (prtslist.failcode==null || prtslist.failcode=='Select One' ) && dealerLocation==true) {
                    system.debug('*****Inside fail code****');
                    prtslist.failcodeMessage=true;
                    Boolean FC=true;
                    setFCACCMess.add(FC);
                }
                if((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') && (prtslist.accountcode==null || prtslist.accountcode=='Select One' || prtslist.accountcode=='') && dealerLocation==true ){
                    system.debug('*****Inside Account code****');
                    prtslist.accountcodeMessage=true;
                    Boolean ACC=true;
                    setFCACCMess.add(ACC);
                }
                if((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') && prtslist.failcode!='Select One' && (prtslist.accountcode==null || prtslist.accountcode=='Select One' || prtslist.accountcode=='') && dealerLocation==true)  {
                    system.debug('*****Inside Account code with Fail code****');
                    prtslist.failcodeMessage=false;
                    prtslist.accountcodeMessage=true;
                    Boolean ACC1=true;
                    setFCACCMess.add(ACC1);
                }
                //<!--End above code for showing filcode and account code error message as per story #176379 Kung Fu Panda sprint,-By RAJESH 11th Mar 2019----->               
                if((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') && (prtslist.partName==null || prtslist.partName=='') && prtslist.isprtntfd == true)
                {

                    count=count+1;
                    PartNotFoundError=true;
                    // Added below 2 lines for should not highlated the faile code and Account code when Part is in-correct as per onshore team words,-By RAJESH 19th Mar 2019                   
                    prtslist.failcodeMessage=false;
                    prtslist.accountcodeMessage=false;
                    // // End below 2 lines for should not highlated the faile code and Account code when Part is in-correct as per onshore team words,-By RAJESH 19th Mar 2019                   
                    displayPopup2 = TRUE;
                    return null;
                }
                if((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') && (prtslist.partName==null || prtslist.partName=='') && prtslist.isprtinval == true)
                {

                    count=count+1;
                    PartNoValidationError=true;
                    displayPopup2 = TRUE;
                    return null;
                }
                //Logic to check duplicate parts:148891 Rupesh
                // for(integer i=0;i<listpartWrapper.size();i++)
                for(integer i=listpartWrapper.size()-1;i>=0;i--)
                {
                    //if(m!=i && prtslist.accountcode==listpartWrapper[i].accountcode && prtslist.servPartNumber !='')
                    if((prtslist.servPartNumber !='' && prtslist.servPartNumber !=null) && (prtslist.counting!=listpartWrapper[i].counting) &&  (listpartWrapper[i].accountcode!='Select One'))
                        if(prtslist.servPartNumber==listpartWrapper[i].servPartNumber && prtslist.accountcode==listpartWrapper[i].accountcode)
                        {
                            z = true;
                            setduplicatecheck.add(z);
                            // Added below 2 lines for should not highlated the faile code and Account code when Part is duplicate as per onshore team words,-By RAJESH 19th Mar 2019                   
                            prtslist.failcodeMessage=false;
                            prtslist.accountcodeMessage=false;
                            // // End below 2 lines for should not highlated the faile code and Account code when Part is duplicate as per onshore team words,-By RAJESH 19th Mar 2019                             
                            if(count1<=0)
                            {
                                count2+=1;
                            }
                            //if(count2>=1&& count1>=0)
                            if(count2>=1&& count1==0)
                            {
                                listpartWrapper[i].accountcode='Select One';

                            }
                            count1=count1+1;
                            break;
                        }
                }
                m++;
            }

            if(setduplicatecheck.contains(true))
            {
                //  ErrorMessage =true;
                displayPopup2 = true;
                //errorDisplay1 = true;
                ErrorMessage2 = true;
                System.debug('inside ErrorMessage:'+ErrorMessage);
                return null;
            }

            //code for sowing  Error messages when fail code and Account code are ' Select One 'as same as per story #176379 Kung Fu Panda sprint,-By RAJESH 18th Mar 2019-----> 
            if(setFCACCMess.contains(true)){
                system.debug('***inside ErrorMessage both sets:***');
                failAccCodeErrorMessage=true;
                return null;
            }
            //End code for sowing Error messages as same as per story #176379 Kung Fu Panda sprint,-By RAJESH 18th Mar 2019----->             
            System.debug('count count:'+count);
            if(count==0 ){
                //System.debug('listpartWrapper size before save>>>:'+listpartWrapper.size()+' The listpartWrapper save list is>>>>>>>>>:'+listpartWrapper);
                for(partWrapperClass  prtslist:listpartWrapper )
                {
                    if((prtslist.servPartNumber==null || prtslist.servPartNumber=='') && (prtslist.quantity==null || prtslist.quantity=='')  && (prtslist.notes==null || prtslist.notes=='') && (prtslist.oem==null && prtslist.oem=='') && (prtslist.failCode==null && prtslist.failCode=='Select One') && (prtslist.coveredPercent==null && prtslist.coveredPercent=='') && (prtslist.partName == '' || prtslist.partName == null)){
                        if(prtslist.ids != null && String.valueOf(prtslist.ids).trim() !=''){
                            removeIdsMap.put(prtslist.ids, String.valueOf(prtslist.ids));
                        }
                    }

                    if((prtslist.partName!=null &&  prtslist.partName!='') && (prtslist.isprtinval==false && prtslist.isprtntfd == false) && (prtslist.servPartNumber!=null || prtslist.servPartNumber!=''))
                    {
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.recordtypeId  = recTypeIdpart;
                        partsoption.Notes__c = prtslist.notes;
                        partsoption.OEM__c = prtslist.oem;
                        if(prtslist.quantity!='' && prtslist.quantity!=null)
                            partsoption.Quantity__c = Decimal.ValueOf(prtslist.quantity);
                        if(prtslist.quantity=='' || prtslist.quantity==null)
                            partsoption.Quantity__c = 0;
                        partsoption.Selected_part__c = prtslist.selectedPart;
                        //Added as per story 152495
                        system.debug('Replacement Reason--'+prtslist.replacementReasson);

                        if(prtslist.replacementReasson=='' || prtslist.replacementReasson == 'Select One'){
                            partsoption.Replacement_Reason__c = 'Refer to Narrative';
                            system.debug('Replacement Reason'+partsoption.Replacement_Reason__c);
                        }
                        else{
                            system.debug('Inside Else');
                            partsoption.Replacement_Reason__c=prtslist.replacementReasson;
                        }

                        partsoption.Part_Name__c = prtslist.partName;
                        partsoption.Part_Description__c = prtslist.partName;
                        partsoption.ReturnToFactory__c = prtslist.returnToFactory;

                        //Id is the variable in the wrapper, if this is null then make the isManual__c as true
                        if(prtslist.Ids==null)
                            partsoption.isManual__c = true;//Make it true if it is a manually created record which is not cloned from Job

                        if(prtslist.failCode=='' && prtslist.failCode == 'Select One'){
                            partsoption.Covered__c = null;
                        }else{
                            if(prtslist.coveredPercent!='' && prtslist.coveredPercent!=null)
                                partsoption.Covered__c = Decimal.valueOf(prtslist.coveredPercent);
                            if(prtslist.coveredPercent=='' || prtslist.coveredPercent==null)
                                partsoption.Covered__c = null;
                        }
                        if(prtslist.failCode != '' && prtslist.failCode != 'Select One'){
                            partsoption.Fail_Code__c = prtslist.failCode; 
                        }
                        else{
                            partsoption.Fail_Code__c = '';
                        }
                        system.debug('RAJESH+partsoption.Fail_Code__c'+partsoption.Fail_Code__c);
                        if(prtslist.failCode=='' || prtslist.failCode == 'Select One'){
                            if(prtslist.accountCode !='' && prtslist.accountCode != 'Select One'){
                                partsoption.Account_Code__c = prtslist.accountCode;
                                system.debug('RAJESH+partsoption.Account_Code__c'+partsoption.Account_Code__c);
                            }
                            else{
                                partsoption.Account_Code__c = '';
                            }
                        } 
                        else{
                            if(prtslist.accountCode !='' && prtslist.accountCode != 'Select One'){
                                partsoption.Account_Code__c = prtslist.accountCode;
                                system.debug('else+RAJESH+partsoption.Account_Code__c'+partsoption.Account_Code__c);
                            }
                            else{
                                partsoption.Account_Code__c = '';
                            }
                        }                                                
                        partsoption.Id=prtslist.ids;
                        partsoption.Id=prtslist.idStr;

                        System.debug('Existing Id>>:'+prtslist.ids+' Part_Name__c>>>>:'+partsoption.Part_Name__c+' OEM__c>>>>:'+partsoption.OEM__c);
                        //GSSC-255 START
                        if(prtslist.servPartNumber!= null && prtslist.servPartNumber != '') {
                            partsoption.Service_partnumber__c = prtslist.servPartNumber.toUpperCase();
                        }
                        //partsoption.Service_partnumber__c = prtslist.servPartNumber;
                        //GSSC-255 END
                       
                        partsoption.Parts_Type__c='Custom';
                        partsoption.CSS_Claims__c = Wid;      
                        partsoption.selected_part__c = true;
                        selectedCustPartsList.add(partsoption);
                        System.debug('Parts_Option__c>>>>:'+partsoption);
                        if(partsoption.Covered__c != null)
                        {
                            totalurp= (partsoption.Covered__c/100)*(partsoption.Unit_Price__c!=null?Decimal.valueof(partsoption.Unit_Price__c):0)*partsoption.Quantity__c;
                        }
                        partsoption.ExpenseTotal__c = totalurp;


                    }
                }
                //  CSS_Parts_Options__c  partsoption1 =  new CSS_Parts_Options__c();
                //  totalurp= partsoption1.Covered__c*value(partsoption1.Unit_Price__c)*partsoption1.Quantity__c;

                //Remove logic here
                System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
                try{
                    if(removeIdsMap.keySet().size()>0){
                        deleteParts();
                    }
                }catch(Exception ex) {
                    System.debug('first in catch of saveCustomParts of CG_CL_ClaimsUserRequestedParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                }
            }
            /*     if(setduplicatecheck.contains(true))
            {
                //  ErrorMessage =true;
                displayPopup2 = true;
                //errorDisplay1 = true;
                ErrorMessage2 = true;
                System.debug('inside ErrorMessage:'+ErrorMessage);
                return null;
            }*/
            CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            errMsgLst = new Set<String>();
            if(selectedCustPartsList != null && selectedCustPartsList.size() > 0){
                errMsgLst = contr.covLimitValidation(null, Cid, selectedCustPartsList, null);
            }
            system.debug('errMsgLst--'+errMsgLst);
            if(errMsgLst != null && errMsgLst.size() > 0){
                for(partWrapperClass prtslist : listpartWrapper){

                    List<String> tempStr = new List<String>();
                    if(prtslist.failCode != null && prtslist.failCode != '' && prtslist.failCode != 'Select One'){
                        tempStr = prtslist.failCode.split('-'); 
                    }
                    system.debug('prtslist.failCode'+prtslist.failCode);
                    String temp1;
                    if(tempStr.size() > 0){
                        temp1 = tempStr[tempStr.size()-1];
                    }
                    system.debug('temp1'+temp1);
                    String temp = temp1+';;'+prtslist.accountCode;
                    system.debug('temp'+temp);
                    if(errMsgLst != null && errMsgLst.contains(prtslist.accountCode)){
                        prtslist.isPartsCovLimitExceed = true;
                    }
                    else{
                        if(errMsgLst != null && errMsgLst.contains(temp)){
                            prtslist.isPartsCovLimitExceedPW = true;
                            prtslist.isPartsCovLimitExceed = true;
                        }
                        else{
                            prtslist.isPartsCovLimitExceed = false;
                            prtslist.isPartsCovLimitExceedPW = false;
                        }
                    }
                    system.debug('prtslist.isPartsCovLimitExceed'+prtslist.isPartsCovLimitExceed);
                    system.debug('prtslist.isPartsCovLimitExceed'+prtslist.isPartsCovLimitExceedPW);
                }
            }else{
                if(selectedCustPartsList.size()>0){
                    System.debug('upsert selectedCustPartsList size>>>>:'+selectedCustPartsList.size()+' selectedCustPartsList>>>>:'+selectedCustPartsList);
                    displayPopup2 = false;
                    List<CSS_Parts_Options__c> partsEPRFlag = new List<CSS_Parts_Options__c>();
                    partsEPRFlag = CSS_FN_SIEBEL.getPartsReturnClaims(selectedCustPartsList);
                    for(CSS_Parts_Options__c selParts : selectedCustPartsList){
                        if(totalurp!=null)
                        {
                            selParts.ExpenseTotal__c=totalurp;
                        }
                        if(selParts.Id != null){
                            for(CSS_Parts_Options__c eprParts : partsEPRFlag)
                            {
                                if(selParts.Id == eprParts.Id)
                                {
                                    selParts.ReturnToFactory__c = eprParts.ReturnToFactory__c;
                                    break;
                                }                            
                            }
                        }
                    }
                    System.debug('***final upsert selectedCustPartsList'+selectedCustPartsList);
                    upsert selectedCustPartsList;// Id;
                    //isManual=true;
                }
                //getallCustomPartsData(displayPopup2); //Commented as part of the defect GSSC-426
            }

            //Remove lsogic here
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());

        }catch(Exception ex) {
            System.debug('second in catch of saveCustomParts of CG_CL_ClaimsUserRequestedParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }


        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        pageRef = new PageReference(sDestURL+'id='+Wid); 
        system.debug('sDestURL' + sDestURL);
        pageRef.setRedirect(true);
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
            return null;
        }
        else{
            return pageRef;
        }
    }

    public void closePopup1(){
        chkReqField = false;
        PartNoValidationError= false;
        PartNotFoundError= false;
        ErrorMessage2 = false;
        ErrorMessage = false;
        displayPopup2 = false;
        failAccCodeErrorMessage = false;
        errMsgLstNew = new List<String>();
        getallCustomPartsData(false);

        //displayPopup2 = false;
    }

    public List<SelectOption> getreplacementReasonOptions(){    
        System.debug('in getreplacementReasonOptions GSQ Parts:7');
        List<SelectOption> options =  new List<SelectOption>();    
        Schema.DescribeFieldResult fieldResult = CSS_Parts_Options__c.Replacement_Reason__c.getDescribe();    
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();    
        for(Schema.picklistEntry f:ple)    
        {   
            if(f.getValue()!='GSQ Part')//Story # 175940, Should not display GSQ Part
                options.add(new selectOption(f.getLabel(),f.getValue()));                    
        }    
        return Options;    
    }

    public void AddRow(){
        try{
            System.debug('in AddRow... GSQ Parts:5 listpartWrapper size>>>:'+listpartWrapper.size()+' listpartWrapper>>:'+listpartWrapper);
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();
            for(integer i=0;i<10;i++){
                listpartWrapper2.add(new partWrapperClass(listpartWrapper2.size(),null,'',null,null,null,null,null,false,null,'',null,null,null,false,false,false,false,false,false,false,'',''));
            }
            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
        }catch(Exception ex) {
            System.debug('in catch of AddRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    } 

    public void partvalidate()
    {
        disableSave = false;
        ErrorMessage2 = false;
        ErrorMessage = false;
        //failAccCodeErrorMessage=false;
        system.debug('listpartWrapper>>'+listpartWrapper);
        system.debug('selPartnum>>'+selPartnum);
        listpartWrapper2=listpartWrapper.clone();
        listpartWrapper.clear();
        for(integer i=0;i<listpartWrapper2.size();i++)
        {

            if(listpartWrapper2[i].counting == selPartnum)
            {
                if(string.isNotBlank(listpartWrapper2[i].servPartNumber) && string.isNotEmpty(listpartWrapper2[i].servPartNumber))
                {   
                    CG_OP_OAGWrapper opres = new CG_OP_OAGWrapper();
                    opres = CSS_FN_SIEBEL.getpartsdata(listpartWrapper2[i].servPartNumber.toUpperCase());

                    system.debug('Quantity>>>'+listpartWrapper2);
                    system.debug('Quantity2>>>'+listpartWrapper2[i]);

                    listpartWrapper2[i].quantity=listpartWrapper2[i].quantity;
                    listpartWrapper2[i].partName = '';


                    if(opres!=null && opres.response.getbody()!=null && opres.response.getbody()!='')
                    {
                        CG_GetPartsdataresWrapper res = (CG_GetPartsdataresWrapper) System.JSON.deserialize(opres.response.getBody(), CG_GetPartsdataresWrapper.class);
                        if(res.header.status=='Success'){
                            if(string.isNotBlank(res.DataArea.PartDescription) || string.isNotEmpty(res.DataArea.PartDescription))
                            {
                                listpartWrapper2[i].partName = res.DataArea.PartDescription;
                                PartNotFoundError = false;
                                PartNoValidationError= false;
                                listpartWrapper2[i].isprtntfd=false;
                                listpartWrapper2[i].isprtinval=false;
                                onChangeofPartNumber(selPartnum);

                                IF(listpartWrapper2[i].quantity==null || listpartWrapper2[i].quantity=='' || string.isBlank(listpartWrapper2[i].quantity))
                                    listpartWrapper2[i].quantity='1';
                            }
                            else
                            {
                                PartNotFoundError = true;
                                listpartWrapper2[i].isprtntfd = true;
                                system.debug('Response Wrapper is error in status.Set the flag for part not found');
                            }
                            //Added if condition as per Stroy 166393,-By  Rajesh/Rupesh 2nd Nov 2018
                            if(string.isNotBlank(res.DataArea.PartNumberLong) || string.isNotEmpty(res.DataArea.PartNumberLong)){
                                if(listpartWrapper2[i].servPartNumber !=res.DataArea.PartNumberLong){
                                    system.debug('The part no long is..'+res.DataArea.PartNumberLong);
                                    listpartWrapper2[i].servPartNumber =res.DataArea.PartNumberLong;
                                }
                            }
                            //End
                        }
                        else{
                            IF(string.isNotBlank(res.header.ReturnCodeDescription) && string.valueOf(res.header.ReturnCodeDescription).containsIgnoreCase('failed with connection error'))
                            {
                                PartNoValidationError= true;
                                listpartWrapper2[i].isprtinval = true;
                                system.debug('Response Wrapper is error in status.Set the flag for parts validation invalid.Please retry');
                            }
                            else{
                                PartNotFoundError = true;
                                listpartWrapper2[i].isprtntfd = true;
                                system.debug('Response Wrapper is error in status.Set the flag for part not found');
                            }
                            String reqBody =  '{"Header":{"Sender":{ "MessageID":"UniqueID","ServiceName": "getpartsdata","SenderID":"CSS" }},"DataArea":{"PartNumberShort": "'+ listpartWrapper2[i].servPartNumber +'"}}';
                            CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
                            intDetails.Response_Body__c = opres.response.getbody();
                            intDetails.Processed_Data__c = reqBody;
                            intDetails.Service_Name__c = 'GetPartsData';
                            intDetails.Source__c = 'Siebel';
                            intDetails.Service_Job_Number__c=CLaimNumberErrlog;
                            intDetails.Service_Call_Time__c =opres.totalServiceCallTime;
                            insert intDetails;

                        }
                    }
                    else
                    {
                        PartNoValidationError= true;
                        listpartWrapper2[i].isprtinval = true;
                        String reqBody =  '{"Header":{"Sender":{ "MessageID":"UniqueID","ServiceName": "getpartsdata","SenderID":"CSS" }},"DataArea":{"PartNumberShort": "'+ listpartWrapper2[i].servPartNumber +'"}}';
                        CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
                        intDetails.Response_Body__c = 'Access Denied';
                        intDetails.Processed_Data__c = reqBody;
                        intDetails.Service_Name__c = 'GetPartsData';
                        intDetails.Source__c = 'Siebel';
                        intDetails.Service_Job_Number__c=CLaimNumberErrlog;
                        insert intDetails;
                        system.debug('Output wrapper itself id null,Set the flag for part validation invalid,Please try again');
                    }
                }
                else{
                    PartNotFoundError = false;
                    PartNoValidationError=false;
                    listpartWrapper2[i].servPartNumber=null;
                    listpartWrapper2[i].partName=null;
                    listpartWrapper2[i].quantity=null;
                    listpartWrapper2[i].isprtntfd=false;
                    listpartWrapper2[i].isprtinval=false;

                    removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                }
            }

        }

        listpartWrapper=listpartWrapper2.clone();
        listpartWrapper2.clear();
    }
    
    public void removingRow(){
        PartNotFoundError = false;
        PartNoValidationError = false;
        ErrorMessage2 = false;
        ErrorMessage = false;
        failAccCodeErrorMessage=false;
        System.debug('in removingRow GSQ Parts:6');
        System.debug('listpartWrapper IN REMOVE ROW'+listpartWrapper);
        try{
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();
            for(Integer i=0;i<listpartWrapper2.size();i++){
                if(listpartWrapper2[i].counting==assignedParts){
                    System.debug('assignedParts '+assignedParts);
                    System.debug('listpartWrapper[i].counting '+listpartWrapper2[i].counting);
                    listpartWrapper2[i].quantity='';
                    listpartWrapper2[i].servPartNumber='';
                    listpartWrapper2[i].partName='';
                    listpartWrapper2[i].oem='';
                    listpartWrapper2[i].returnToFactory='';
                    listpartWrapper2[i].coveredPercent='';
                    listpartWrapper2[i].failCode='';
                    listpartWrapper2[i].accountCode='';
                    listpartWrapper2[i].replacementReasson='Select one';
                    listpartWrapper2[i].notes='';
                    listpartWrapper2[i].isprtntfd=false;
                    listpartWrapper2[i].isprtinval=false;
                    listpartWrapper2[i].failcodeMessage=false;
                    listpartWrapper2[i].accountcodeMessage=false;
                    listpartWrapper2[i].coveragetypeval= '';
                    listpartWrapper2[i].coveredpartsper='';
                    if(listpartWrapper2[i].ids != null && String.valueOf(listpartWrapper2[i].ids).trim() !=''){
                        removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                    }
                    //listpartWrapper2.remove(i);
                    System.debug('removeIdsMap>>>:'+removeIdsMap);
                }
            }

            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    public class partWrapperClass 
    {
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        public String quantity {get;set;}
        public String servPartNumber {get;set;}
        public String partName {get;set;}
        public String returnToFactory {get;set;}
        public String coveredPercent {get;set;}
        public String failCode {get;set;}
        public String accountCode {get;set;}
        public String replacementReasson {get;set;}
        public String notes {get;set;}
        public String oem {get;set;}
        public Boolean selectedPart {get;set;}
        public list<SelectOption> lstAccountCodes{get;set;}
        public boolean IsManual{get;set;}
        public boolean isprtntfd{get;set;}
        public boolean isprtinval{get;set;}
        public boolean failcodeMessage{get;set;}
        public boolean accountcodeMessage{get;set;}
        public boolean isPartsCovLimitExceed{get;set;}
        public boolean isPartsCovLimitExceedPW{get;set;}
        public String coveragetypeval{get;set;}
        public String coveredpartsper{get;set;}

        public partWrapperClass(Integer counting,Id ids,String quantity,String servPartNumber,String partName,String replacementReasson,String notes,String oem,Boolean selectedPart,String returnToFactory,String coveredPercent,String failCode,String accountCode,list<SelectOption> lstAccountCodes,boolean isManual,boolean isprtntfd,boolean isprtinval,boolean failcodeMessage,boolean accountcodeMessage, boolean isPartsCovLimitExceed, boolean isPartsCovLimitExceedPW,String coveragetypeval, String coveredpartsper) {
            this.counting = counting;
            this.ids = ids;
            this.idStr = ids;
            this.quantity = quantity;
            this.servPartNumber = servPartNumber;
            this.partName = partName;
            this.replacementReasson = replacementReasson;
            this.notes = notes;
            this.oem = oem;
            this.selectedPart = selectedPart;
            this.returnToFactory = returnToFactory;
            this.coveredPercent = coveredPercent;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.lstAccountCodes = lstAccountCodes;
            this.isManual=isManual;
            this.isprtntfd = isprtntfd;
            this.isprtinval = isprtinval;
            this.failcodeMessage = failcodeMessage;
            this.accountcodeMessage = accountcodeMessage;
            this.isPartsCovLimitExceed = isPartsCovLimitExceed;
            this.isPartsCovLimitExceedPW = isPartsCovLimitExceedPW;
            this.coveragetypeval = coveragetypeval;
            this.coveredpartsper = coveredpartsper;
        }        
    }
    
}