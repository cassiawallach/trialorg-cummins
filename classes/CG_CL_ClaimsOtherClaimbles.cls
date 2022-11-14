/**********************************************************************
Name:CG_CL_ClaimsOtherClaimables
Copyright © 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Page Controller for Claims - Other Claimables
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -                      02/12/2018          Added Constructor 
***********************************************************************/

public class CG_CL_ClaimsOtherClaimbles {
    
    public List<claimablesWrapperClass> listpartWrapper {get;set;} 
    public List<claimablesWrapperClass> listpartWrapper2 {get;set;} 
    public Set<claimablesWrapperClass> setpartWrapper {get;set;}
    public Integer assignedParts{get;set;}
    public Boolean ocperror{get;set;}//Added for story 180117
    public Map<Id, String> removeIdsMap = new Map<Id, String>();
    public String SelectedFailCode{get;set;}
    public integer  SelectedPartID{get;set;}
    public String SelectedItem{get;set;}
    public String SelectedType{get;set;}
    public String SelectedAccountCode{get;set;}
    public boolean MaxAmtError {get; set;}   //Added for Story 148914
    public boolean qtyErrorMessage{get;set;} //Added for Story 175943
    public boolean unitPriceErrorMessage{get;set;} // Added for Story 175943
    public boolean ErrorMessage1 {get; set;}
    public boolean ErrorMessage2 {get; set;}
    public boolean ErrorMessage {get; set;}
    public boolean errorDisplay{get;set;}
    public boolean errorDisplay1 {get;set;}
    public boolean isExpenseTotalError {get;set;}
    public css_job_order__c workJob {get;set;}
    //ttml story variables
    public decimal comt {get;set;}       
    public decimal ncomt {get;set;}           
    public decimal towt {get;set;}     
    public decimal meals {get;set;}    
    public decimal lodg {get;set;}    
    public decimal totalexp {get;set;}
    public Boolean towErrorOutputMsg {get;set;}
    public Boolean displayPopup2{get;set;}
    public boolean showPopup{get;set;}
    public Boolean ttmlReqErrMsg {get;set;}
    public Boolean TravelTowingError {get;set;}
    public List<ttmlWrapperClass> listTTMLWrapper {get; set;}
    public List<ttmlWrapperClass> listTTMLWrapper2 {get; set;}
    public List<ttmlWrapperClass> listTTMLWrapper3 {get; set;}
    public Set<ttmlWrapperClass> setTTMLWrapper {get;set;}
    public Integer selectedRemoveRow {get; set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public string dealer {get; set; }
    public id cId{get;set;}
    public id wid;
    //Added for accountcodes dropdown
    public CSS_Claims__c claimsObj {get;set;}
    public list<string> lstAccountCodes{get;set;}
    public List<SelectOption> accCodes{get;set;}
    public list<CSS_JobEventTemporary__c> jobEventTemp {get;set;}
    //end
    public boolean chkReqField{get;set;}
    public Id recTypeIdpart;
    public Id recTypeIdTTML;
    public list<CSS_Parts_Options__c> customPartlstUI{get; set;}
    public list<CSS_Parts_Options__c> otherClaimPartList{get; set;}
    public List<CSS_Parts_Options__c> ttmlPartsList{get; set;}
    public List<CSS_Parts_Options__c> ttmlPartlstUI {get;set;}
    public Boolean duplicateAccountCode {get;set;}
    public Integer selectedRecordRowID {get; set;}
    public String DLR;
    public String coverageType;
    public String setSelectedItem;
    public Boolean reqaccountcode {get;set;}
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
    public Map<String,CSS_JobEventTemporary__c> accCodeMapJET = new Map<String,CSS_JobEventTemporary__c>();
    Boolean DealerUser;
    public boolean travelRateError{get;set;}
    public boolean hideAccCode{get;set;}
    public boolean dispEditLink{get;set;}
    //public list<CSS_Solution_Component__c> SolCompList = new list<CSS_Solution_Component__c>();
    public Map<String,Set<String>> failAccountCodeMap{get;set;}
    public String ttmlAccCode;
    public Set<String> errMsgLst{get; set;}
    public List<String> errMsgLstNew{get;set;}
    public Boolean isOCCovered{get;set;}
    public Boolean isTTMLCovered{get;set;}
    public List<String> errTTML{get; set;}
    public Boolean TravelTowingTTMLError {get;set;}
    public List<CSS_Solution_Component__c> solsCompFailCodeVal = new List<CSS_Solution_Component__c>();
    public List<CSS_Solution_Component__c> solsCompFailCodeValNew = new List<CSS_Solution_Component__c>();
    public CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
    public boolean DealerTypeFlag{get; set;}
    public List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
    //GSSC-142
    public List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
    public CG_CL_ClaimsOtherClaimbles()
    {
        isOCCovered = true;
        isTTMLCovered = true;
        ocperror=false;
        travelRateError=false;
        hideAccCode=false;
        dispEditLink = true;
        CID=ApexPages.CurrentPage().getParameters().get('id');
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        failAccountCodeMap = new  Map<String, Set<String>>();
        if(cId == null) {
            claimsRec = new CSS_Claims__c();  
            psnRec = new CSS_PSN__c();
        }
        else{
            claimsRec =[Select Id,Name, ESN__c, createdDate, css_job__c,Dealer_Service_Job__c,Location__c,Location_Code__c,Account__r.type,CSS_Travel_Rate__c,IsDealerCreatedClaim__c from CSS_Claims__c where id= :cId];
             solCompList = [SELECT Id, Over_The_Counter__c, FailCode_Formula__c,Fail_Code_Editable__c,Fail_code__c,Type__c,SysCodeAndCompCode__c
                                                           ,CSS_Account_Formula__c,Selected_Component__c,CoveredOCAmount__c,CampaignOCPercentage__c
                                                           , CSS_CoverageType__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c
                                                           , Parts_Warranty__c,CoveredPartsQty__c ,AccountCodeEdit__c,AccountCodeType__c
                                                           ,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c
                                                           , CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c, Solutions__r.Diagnostic_Response__c
                                                           FROM CSS_Solution_Component__c where CSS_Claims__c =: cId];
            if(solCompList != null && solCompList.size() >0) {
                for(CSS_Solution_Component__c solcompCon : solCompList) {
                    if(solcompCon.FailCode_Formula__c != null  && solcompCon.Selected_Component__c)
                        solsCompFailCodeVal.add(solcompCon);
                    
                    if((solcompCon.Selected_Component__c && solcompCon.FailCode_Formula__c != null && solcompCon.CSS_Account_Formula__c != null ) || 
                       (solcompCon.Selected_Component__c && solcompCon.FailCode_Formula__c != null && solcompCon.CSS_Account_Formula__c != null && solcompCon.Type__c != null && (solcompCon.Type__c.contains('Campaign') || solcompCon.Type__c.contains('ATC') || solcompCon.Type__c.contains('TRP'))))
                        solsCompFailCodeValNew.add(solcompCon);
                }
            }
            
            //solsCompFailCodeVal = [SELECT Id, FailCode_Formula__c,Fail_Code_Editable__c,Fail_code__c,Type__c,SysCodeAndCompCode__c,CSS_Account_Formula__c,Selected_Component__c,CoveredOCAmount__c,CampaignOCPercentage__c from CSS_Solution_Component__c where CSS_Claims__c =:cId and FailCode_Formula__c!=null  and Selected_Component__c= true];
            //solsCompFailCodeValNew = [SELECT Id,CSS_Account_Formula__c, Type__c, CSS_CoverageType__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, Parts_Warranty__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =: cId AND ((Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null ) OR (Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
            
        }
        
        JETFA = new list<CSS_JobEventTemporary__c>();
        JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c,Account_Code__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
        for(CSS_JobEventTemporary__c jet : JETFA){
            string temp = jet.Attribute2__c+jet.Attribute3__c; 
            if(!accCodeMapJET.containskey(temp))
                accCodeMapJET.put(temp,jet);
        }
        //GSSC-138-start    
        if(userinfo.getDefaultCurrency() == 'USD'){
            lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c order by Bolt_Version__c desc limit 1];
        }
        else{
            lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1];
        }
        //GSSC-138-end
        ErrorMessage1 = false;
        ErrorMessage = false;
        qtyErrorMessage = false;
        unitPriceErrorMessage = false;
        MaxAmtError = false;
        isExpenseTotalError = false;
        getallCustomPartsData(false);
        //getAllTTMLPartsData();
        isTowingExpenseTotalError = false;      //NEW-----
        isLodgingExpenseTotalError = false;     //NEW-----
        isMealsExpenseTotalError = false;       //NEW-----
        ncomt = 0;
        comt = 0;
        towt = 0;
        meals = 0;
        lodg = 0;
        totalexp = 0.00;
        // OtherUSd = 0;
        // saveClaimExpenseTotal();
        getOCData();
        // saveOtherClaimablesTotal();
        // belwo is for ttml accountcode mandatoty check
        css_header_nav__c rswBotton =css_header_nav__c.getInstance(UserInfo.getUserId());
        DealerUser=rswBotton.RSWButtonEnable__c;
        system.debug('****DealerUser***'+DealerUser);
        //getAllTTMLPartsData();    Commented the Method and calling below after getting the DealerTypeFlag value as per Defect GSSC-601,-By RAJESH 13th Feb 2020
        reqaccountcode = false;
        if(claimsRec.CSS_Job__c!= null || claimsRec.Dealer_Service_Job__c!=null){ // automatic
            
            if(DealerUser == true){
                reqaccountcode = true;
            }else{
                reqaccountcode = false;   
            }
        }else{          // manual
            reqaccountcode = true; 
            
        }
        
         /*IAM AccountType change*/
          DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
         /*IAM AccountType change*/
         
         getAllTTMLPartsData();
        
    }
    
    public void getallCustomPartsData(Boolean displayPopup2){
        system.debug('inside getallCustomPartsData');
        //getfailcodeDropDown();
        chkReqField = false;
        Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
        if(displayPopup2){
            ErrorMessage1 = true;
        }else     
            ErrorMessage1 = false;
        try{
            system.debug('Cid Value--'+cId);
            if(cId!=null)
            {
                recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
                customPartlstUI = [select Id,RecordTypeId, Service_Job__c, CSS_Claims__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Exchange_Rate__c, isManual__c,selected_part__c, Item__c,Previous_Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                                   Account_Code__c,Unit_Price__c, Notes__c,Sell_Price__c, ExpenseTotal__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and RecordType.Name ='OtherClaimables' ORDER BY CreatedDate];
                system.debug('customPartlstUI Manual Claims----->'+customPartlstUI);
                //GSSC-138 start
                css_utility utility = new css_utility();
                
                mapPartsList = utility.displayParts(customPartlstUI);
                system.debug('mapPartsList--'+mapPartsList);
                //GSSC-138 end
            }
            else
            {
                
            } 
            List<SelectOption> options =  new List<SelectOption>();
            options.add(new SelectOption('Select One','Select One'));
            if(customPartlstUI != null && customPartlstUI.size()>0){
                system.debug('Inside IF');
                listpartWrapper = new List<claimablesWrapperClass>();
                setpartWrapper = new Set<claimablesWrapperClass>();
                system.debug('customPartlstUI.size>>>>'+customPartlstUI.size());
                for(integer i=0;i<customPartlstUI.size();i++){
                    system.debug('customPartlstUI[i].Fail_Code__c>>>>'+customPartlstUI[i].Fail_Code__c);
                    system.debug('accoptions>>>>'+getAccountCodeDropDown(customPartlstUI[i].Fail_Code__c));
                    //GSSC-138 START
                    decimal unitPrice;
                    decimal amount;
                    Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                    
                    if(mapPartsList != null){
                        mapTemp = mapPartsList.get(customPartlstUI[i].Id);
                        
                        if(mapTemp != null){
                            for(decimal up : mapTemp.keyset()){
                                unitPrice = up;
                                amount = mapTemp.get(up);
                            }
                        }
                    }
                    unitPrice = unitPrice.setscale(2);
                    amount = amount.setscale(2);
                    system.debug('unitPrice--'+unitPrice);
                    system.debug('amount--'+amount);
                    
                    //GSSC-138 end
                    //setpartWrapper.add(new claimablesWrapperClass(i,customPartlstUI[i].Id,customPartlstUI[i].Item__c,customPartlstUI[i].Part_Description__c,String.valueof(customPartlstUI[i].Quantity__c),customPartlstUI[i].ExpenseTotal__c,String.valueof(customPartlstUI[i].Covered__c),customPartlstUI[i].Fail_Code__c,customPartlstUI[i].Account_Code__c,getfailcodeDropDownBasedOnItem(customPartlstUI[i].Item__c ,null),getAccountCodeDropDown(customPartlstUI[i].Fail_Code__c),customPartlstUI[i].isManual__c,customPartlstUI[i].Item__c,customPartlstUI[i].Unit_Price__c == null ? null : decimal.valueOf(customPartlstUI[i].Unit_Price__c),false,false,false));
                    setpartWrapper.add(new claimablesWrapperClass(i,customPartlstUI[i].Id,customPartlstUI[i].Item__c,customPartlstUI[i].Part_Description__c,String.valueof(customPartlstUI[i].Quantity__c),amount,String.valueof(customPartlstUI[i].Covered__c),customPartlstUI[i].Fail_Code__c,customPartlstUI[i].Account_Code__c,getfailcodeDropDownBasedOnItem(customPartlstUI[i].Item__c ,null),getAccountCodeDropDown(customPartlstUI[i].Fail_Code__c),customPartlstUI[i].isManual__c,customPartlstUI[i].Item__c,unitPrice == null ? null : unitPrice,false,false,false, null, null, unitPrice, amount));
                }
                system.debug('setpartwrapper>>>>'+setpartWrapper.size());
                system.debug('setpartwrapper>>>>+++!!+!!'+setpartWrapper);
                if(customPartlstUI.size()<=4) {
                    for(integer i=0;i<5-customPartlstUI.size();i++){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.Item__c = 'Select One';
                        partsoption.Part_Description__c = 'N/A';
                        partsoption.Quantity__c = null ;
                        partsoption.Unit_Price__c = null;
                        partsoption.amount__c = 0;
                        partsoption.Covered__c = null;
                        partsoption.Fail_Code__c = 'Select One';
                        partsoption.Account_Code__c = 'Select One';
                        //partsoption.Previous_Item__c = '';
                        
                        try{
                            setpartWrapper.add(new claimablesWrapperClass(customPartlstUI.size()+i,null,partsoption.Item__c,partsoption.Part_Description__c,String.valueof(partsoption.Quantity__c),partsoption.amount__c,String.valueof(partsoption.Covered__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,options,options,partsoption.isManual__c,partsoption.Previous_Item__c,partsoption.Unit_Price__c == null ? null : decimal.valueOf(partsoption.Unit_Price__c),false,false,false, null, null, null, null));
                        }catch(Exception ex){
                            System.debug('in catch of getallCustomPartsData of CSS_GSQParts adding wrapper>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                        }
                        System.debug('setpartWrapper>>>:'+setpartWrapper);
                    }
                    system.debug('customPartlstUI>>>>>>>>>>:'+customPartlstUI);
                }
                system.debug('setpartWrapper exist>>>>>>>>>>:'+setpartWrapper);
            }else{
                system.debug('Inside else');
                listpartWrapper = new List<claimablesWrapperClass>();
                setpartWrapper = new Set<claimablesWrapperClass>();
                for(integer i=0;i<5;i++){
                    CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                    partsoption.Item__c = 'Select One';
                    partsoption.Part_Description__c='N/A';
                    partsoption.Quantity__c = null;
                    partsoption.amount__c = 0;
                    partsoption.Covered__c =null ;
                    partsoption.Fail_Code__c = 'Select One';
                    partsoption.Account_Code__c = 'Select One';
                    partsoption.Unit_Price__c = null;
                    setpartWrapper.add(new claimablesWrapperClass(customPartlstUI.size()+i,null,partsoption.Item__c,partsoption.Part_Description__c,String.valueof(partsoption.Quantity__c),partsoption.amount__c,String.valueof(partsoption.Covered__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,options,options,partsoption.isManual__c,partsoption.Previous_Item__c,null,false,false,false, null, null, null, null));
                }
                
                system.debug('setpartWrapper else>>>>>>>>>>:'+setpartWrapper);
            }
            System.debug('The listpartWrapper list is>>>>>>>>>:'+setpartWrapper+' displayPopup2>>>>:'+displayPopup2);
        }catch(Exception ex){
            System.debug('in catch of getallCustomPartsData of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        //system.debug('customPartlstUI.size()'+customPartlstUI.size());
        if(setpartWrapper.size()>0){
            listpartWrapper.addAll(setpartWrapper);
            system.debug('listpartWrapper>>>>>>>'+listpartWrapper.size());
        }
        if(customPartlstUI != null && customPartlstUI.size() > 0){
            isOCCovered = true;
        }
        else{
            //CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            List<Boolean> coverageResult = new List<Boolean>();
            coverageResult = contr.checkFailuresCovered(Cid, false);
            system.debug('coverageResult--'+coverageResult);
            isOCCovered = coverageResult[1];
            //isURPCovered = false;
            system.debug('isOCCovered--'+isOCCovered);
        }
        
    }
    
    public void displayPopUp(){
        showPopup = true;
    }
    
    //Method to close the pop up 
    public void closePopup(){
        getallCustomPartsData(false);
        getAllTTMLPartsData();
        qtyErrorMessage=false;
        ErrorMessage2 = false;//This has been added here to rectify defect 157619 on edit the message was appearing.
        MaxAmtError = false;
        showPopup = false;     
        ErrorMessage=false;
        ttmlReqErrMsg=false;
        duplicateAccountCode=false;
        travelRateError=false;
        TravelTowingTTMLError = false;
        TravelTowingError =false;
        //Start code as per story #148925 ,By RAJESH 08th Jan 2019-->       
        isMealsExpenseTotalError=false;
        isLodgingExpenseTotalError=false;
        isTowingExpenseTotalError=false;
        //End code as per story #148925 ,By RAJESH 08th Jan 2019-->
        errMsgLstNew = new List<String>();
    }

    public PageReference saveOtherClaimablesPopup(){
        system.debug('save method enter');
        Integer count =0;
        MaxAmtError = false;
        chkReqField = false;
        ErrorMessage = false;//Please provide description error message
        ErrorMessage1 = false;//Please select item error message
        ErrorMessage2=false;//Duplicate item not allowed error message
        qtyErrorMessage = false;//Quantity Error Message
        TravelTowingError = false;
        //unitPriceErrorMessage = false;//Unit Price Error Message
        List<string> accountCodeList= new List<String>();
        List<string> failCodeList= new List<String>();
        list<CSS_SRT__c> lstSRTRec = new list<CSS_SRT__c>();    
        list<CSS_Solution_Component__c> lstSOCRec = new list<CSS_Solution_Component__c>();
        List<CSS_Parts_Options__c> lstPoRec = new list<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> TTMLList = new list<CSS_Parts_Options__c>();
        PageReference pageRef;
        system.debug('**solCompList**'+solCompList);
        try
        {
            Boolean validationOnAccUpQu;
            system.debug('wrapper sizeb'+listpartWrapper.size());
            System.debug('recTypeIdpart>>>>:'+recTypeIdpart);
            
            //Remove logic here
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            try
            {
                if(removeIdsMap.keySet().size()>0)
                {
                    deleteParts();
                }
            }
            catch(Exception e) 
            {
                system.debug('Error in Cust Parts Delete Component ## ' + e.getmessage());
            }
            
            set<boolean> setItemNullCheck = new set<boolean>() ;
            set<boolean> setUnlistedCheck = new set<boolean>();
            set<boolean> setduplicatecheck = new set<boolean>();
            set<boolean> setamounterror1 = new set<boolean>();
            set<boolean> qUASet = new set<boolean>();
            set<boolean> itemSet = new set<boolean>();
            Boolean ErrorMessageforItem;
            integer count1=0;
            integer count2=0;
            integer m=0;
            system.debug('**listpartWrapper**'+listpartWrapper);
            for(claimablesWrapperClass  prtslist:listpartWrapper )
            {
                
                boolean z;
                boolean qaupacErr;
                System.debug('The listpartWrapper savelist list is>>>>>>>>>:'+prtslist);
                boolean x = ((prtslist.PartDescription!=null && prtslist.PartDescription!='' && prtslist.PartDescription!='N/A') || (prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.amount!=null && prtslist.amount!=0) || (prtslist.Unitprice!=null && prtslist.Unitprice!=0) || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One' && prtslist.failCode!='') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='') || (prtslist.accountCode!=null && prtslist.accountCode!='Select One' && prtslist.accountCode!='')) && (prtslist.item== '' || prtslist.item== null || prtslist.item=='Select one');
                boolean  y = ((prtslist.PartDescription=='' || prtslist.PartDescription==null || prtslist.PartDescription=='N/A') &&   prtslist.item=='Unlisted');
                setItemNullCheck.add(x);
                system.debug('***first setItemNullCheck****'+setItemNullCheck);
                setUnlistedCheck.add(y);
            
                //condition for display Description value should blank
                if((prtslist.item=='Unlisted' || prtslist.item=='DCA' || prtslist.item=='Antifreeze/Coolant'|| prtslist.item=='Belt'|| prtslist.item=='Clamp'|| prtslist.item=='Coolant Filter'|| prtslist.item=='Crankcase Breather Element'|| prtslist.item=='Fuel Filter'|| prtslist.item=='Handling Allowance'|| prtslist.item=='Hose' || prtslist.item=='Import Charges' || prtslist.item=='Oil'|| prtslist.item=='Oil Filter'|| prtslist.item=='Replacement Engine' || prtslist.item=='Ties') && prtslist.PartDescription=='N/A')  
                {
                    prtslist.PartDescription='';
                } 
                
                if(((prtslist.quantity!=null && prtslist.quantity!='') || (string.valueOf(prtslist.Unitprice)!=null && prtslist.Unitprice!=0 && string.valueOf(prtslist.Unitprice)!='') || (prtslist.accountCode!=null && prtslist.accountCode!='Select One' && prtslist.accountCode!='')) && (prtslist.item== '' || prtslist.item== null || prtslist.item=='Select one')){
                    system.debug('****inside if when item is null****');
                    ErrorMessageforItem =true;
                    itemSet.add(ErrorMessageforItem);
                }
                else{
                    system.debug('****inside if when item is not null****');
                    ErrorMessageforItem =false;
                }
                system.debug('****Item value from wrapper***'+prtslist.item);
                if(prtslist.item !='Select One' && prtslist.item != null){
                    //quantity error Message Checking
                    if(prtslist.quantity==null || prtslist.quantity==''|| prtslist.quantity =='0'){
                        system.debug('****quantity error Message Checking***');
                        prtslist.errorQuaUPAC=true;
                        qaupacErr=true;
                    }
                    else{
                        prtslist.errorQuaUPAC=false;
                    }
                    //unitPrice error Message Checking 
                    if(string.valueOf(prtslist.Unitprice)=='' || prtslist.Unitprice==null || prtslist.Unitprice==0){
                        system.debug('****unitprice error Message Checking***');
                        prtslist.errorUP=true;
                        qaupacErr =true;
                    }
                    else{
                        prtslist.errorUP=false;
                    }
                    //account code error Message Checking 
                    if((prtslist.accountcode == 'Select One' ||  prtslist.accountCode==null ||  prtslist.accountCode=='')){
                        system.debug('****account code error Message Checking***');
                        prtslist.errorAC=true;
                        qaupacErr =true;
                    }
                    else{
                        prtslist.errorAC=false;
                    }
                }
                qUASet.add(qaupacErr);
                
                /*  if(((string.valueOf(prtslist.Unitprice)=='' || prtslist.Unitprice==null || prtslist.Unitprice==0) && prtslist.item !='Select One') ||
((prtslist.quantity!=null && prtslist.quantity!='') || (string.valueOf(prtslist.Unitprice)!=null && prtslist.Unitprice!=0 && string.valueOf(prtslist.Unitprice)!='') || (prtslist.accountCode!=null && prtslist.accountCode!='Select One' && prtslist.accountCode!='')) && (prtslist.item== '' || prtslist.item== null || prtslist.item=='Select one'))
{
system.debug('***inside Unitprice***');
prtslist.errorUP=true;
prtslist.errorAC=false;
prtslist.errorQuaUPAC=false;
validationOnAccUpQu=true;
qUASet.add(validationOnAccUpQu);
}


if(((prtslist.quantity == null || prtslist.quantity =='' || prtslist.quantity =='0') && prtslist.item!='Select One') ||
(prtslist.item =='Select One' && (string.valueOf(prtslist.Unitprice)!=null || prtslist.accountcode != 'Select One')))
{
system.debug('***inside quantity***');
prtslist.errorQuaUPAC=true;
prtslist.errorUP=false;
prtslist.errorAC=false;
validationOnAccUpQu=true;
qUASet.add(validationOnAccUpQu);


}

if((prtslist.item!='Select One' && (prtslist.accountcode == 'Select One' ||  prtslist.accountCode==null ||  prtslist.accountCode=='') && (prtslist.failCode!='Select One' || prtslist.failCode =='Select One' || prtslist.failCode ==null || prtslist.failCode ==''))||
(prtslist.item =='Select One' && (string.valueOf(prtslist.Unitprice)!=null || prtslist.quantity != '')))
{
system.debug('***inside accountcode***');
prtslist.errorAC=true;
prtslist.errorUP=false;
prtslist.errorQuaUPAC=false;
validationOnAccUpQu=true;
qUASet.add(validationOnAccUpQu);

}*/
                
                system.debug('prtslist.errorAC>>>' + prtslist.errorAC);
                
                //Condition for displaying duplicate alert.
                
                for(integer i=0;i<listpartWrapper.size();i++)
                {
                    if(m!=i && prtslist.accountcode==listpartWrapper[i].accountcode && prtslist.item !='Select One')
                    {
                        if(prtslist.item !='Unlisted' && (prtslist.item==listpartWrapper[i].item))
                        {
                            z = true;
                            setduplicatecheck.add(z);
                            system.debug('Duplicate Claim');
                            
                            if(count1<=0)
                            {
                                
                                count2+=1;
                                
                            }
                            if(count2>=1 && count1>=0)
                            {
                                listpartWrapper[i].accountcode='Select One';
                                
                            }
                            count1=count1+1;
                            break;
                        }
                        if(prtslist.item =='Unlisted' && prtslist.PartDescription != null && (prtslist.PartDescription==listpartWrapper[i].PartDescription))
                        {
                            z = true;
                            
                            setduplicatecheck.add(z);
                        }
                        /*if(y == true)
{
ErrorMessage =true;
system.debug('Items are unlisteed and desc null.');
}*/
                        
                    }
                    system.debug('*****listpartWrapper[i].accountcode' +listpartWrapper[i].accountcode);
                }
                m++;
            }
            //Added for Story 148914
            for(claimablesWrapperClass  prtslist1:listpartWrapper )
            {
                
                if(prtslist1.amount>99999.99)
                {
                    boolean v=true;
                    setamounterror1.add(v);
                    break;
                }
            }
            
            
            //Added for Story 148914
            if(setamounterror1.contains(true) && qUASet.contains(true)){
                
                MaxAmtError = true;
                qtyErrorMessage =true;
                return null;
            }
            if(setamounterror1.contains(true))
            {
                MaxAmtError = true;
                return null;
            }
            system.debug('***qUASet****'+qUASet);
            system.debug('***setItemNullCheck****'+setItemNullCheck);
            system.debug('***itemSet****'+itemSet);
            if(qUASet.contains(true)){
                qtyErrorMessage = true;
                system.debug('***inside qUASet****');
                //return null;
            }
            else{
                qtyErrorMessage = false;
            }
            if(qUASet.contains(true) && itemSet.contains(true)){
                qtyErrorMessage = true;
                ErrorMessage1 =true;
                system.debug('***inside qUASet and itemSet****');
                //return null;
            }
            else{
                ErrorMessage1 =false;
            }
            /*  if(itemSet.contains(true)){
//qtyErrorMessage = true;
ErrorMessage1 =true;
return null;
}*/
            
            
            
            //Added by Rupesh for ITQA observation for two unlisted conditions
            system.debug('setUnlistedCheck'+setUnlistedCheck);
            system.debug('setduplicatecheck'+setduplicatecheck);
            
            /*180117 Rupesh*/ 
            //CG_CL_CoverageLimitExceedValidation cvobj = new CG_CL_CoverageLimitExceedValidation();
            //set<string> errmsglist=cvobj.covLimitValidation(null,CID,null,selectedCustPartsList);
            //system.debug('OC ERROR MESG SIZE:    '+ errmsglist);
            //if(errmsglist!=null || errmsglist!='')
            
            //if(errmsglist.size()>0)
            {
                ocperror=true;
                //return null;
            }
            //system.debug('OC ERROR MESG FLAG:    '+ stqtgtocerror);
            /*180117 Rupesh*/ 
            
            
            
            
            if(setUnlistedCheck.contains(true) && setduplicatecheck.contains(true))
            {
                //ErrorMessage2 = true;
                ErrorMessage2 = false;
                ErrorMessage =true;
                displayPopup2 = true;
                errorDisplay1 = true;
                System.debug('inside ErrorMessage:'+ErrorMessage);
                return null;
                
            }
            //story 105553 validations logic
            if(setduplicatecheck.contains(true))
            {
                // ErrorMessage =true;
                displayPopup2 = true;
                errorDisplay1 = true;
                ErrorMessage2 = true;
                System.debug('inside ErrorMessage:'+ErrorMessage);
                return null;
            }
            
            if(setItemNullCheck.contains(true) && setUnlistedCheck.contains(true))
            {
                ErrorMessage1 =true;
                //qtyErrorMessage = true;
                displayPopup2 = true;
                errorDisplay = true;
                ErrorMessage =true;
                displayPopup2 = true;
                errorDisplay1 = true;
                return null;
            }
            if(setItemNullCheck.contains(true)){
                system.debug('errir if enters');
                ErrorMessage1 =true;
                //qtyErrorMessage = true;
                displayPopup2 = true;
                errorDisplay = true;
                //count=count+1;
                System.debug('inside error displayPopup2:'+displayPopup2);
                System.debug('inside ErrorMessage1:'+ErrorMessage1);
                // return null;
            }
            if(setUnlistedCheck.contains(true))
            {
                ErrorMessage =true;
                displayPopup2 = true;
                errorDisplay1 = true;
                System.debug('inside ErrorMessage:'+ErrorMessage);
                return null;
                
            }
            
            System.debug('count count:'+count);
            // if(count==0)
            Map<String, List<String>> OCMap = new Map<String, List<String>>();
             TTMLList = [select Id, isManual__c,FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                            Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Unit_Price__c
                            from CSS_Parts_Options__c where  CSS_Claims__c=:cId and RecordType.Name ='TTML'];
                system.debug('TTMLList****' + TTMLList);
            if(count==0 && !ErrorMessage1 )
            {
                List<String> tempList;
                System.debug('listpartWrapper size before save>>>:'+listpartWrapper.size()+' The listpartWrapper save list is>>>>>>>>>:'+listpartWrapper);
                for(claimablesWrapperClass  prtslist:listpartWrapper )
                {
                    
                    if((prtslist.quantity==null || prtslist.quantity=='') && (prtslist.PartDescription==null || prtslist.PartDescription=='' || prtslist.PartDescription=='N/A') && (prtslist.item==null || prtslist.item=='' || prtslist.item=='Select One' ) && (prtslist.amount==null && prtslist.amount==0 ) && (prtslist.coveredPercent==null || prtslist.coveredPercent=='') && (prtslist.failCode==null && prtslist.failCode=='Select One') && (prtslist.accountCode==null && prtslist.accountCode=='Select One'))
                    {
                        //if(prtslist.quantity==null || prtslist.quantity=='')    {
                        if(prtslist.ids != null && String.valueOf(prtslist.ids).trim() !=''){
                            removeIdsMap.put(prtslist.ids, String.valueOf(prtslist.ids));
                        }
                        //}
                    }
                    
                    // if(prtslist.quantity!=null &&  prtslist.quantity!=''){
                    if(prtslist.item!=null &&  prtslist.item!='Select One')
                    {
                        system.debug('partsitem>>>>'+prtslist.item);
                        system.debug('partsitem Account_Code__c>>>>'+prtslist.accountCode);
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.recordtypeId  = recTypeIdpart;
                        //Commited the below code as per new story #152681, -By RAJESH 5th July 2018                  
                        /*/Added code  as per The Gap story #147387, -By RAJESH 12th JUNE 2018               
if(prtslist.item=='Unlisted' && prtslist.accountcode != null && prtslist.failcode != null){
partsoption.ODM_Status__c='NA'; 

}


partsoption.Previous_Item__c = prtslist.previousItem;  
//End */               
                        partsoption.Item__c = prtslist.item;
                        partsoption.Part_Description__c = prtslist.PartDescription;
                        if(prtslist.quantity!='' && prtslist.quantity!=null)
                            partsoption.Quantity__c = Decimal.ValueOf(prtslist.quantity);
                        /* if(prtslist.quantity=='' || prtslist.quantity==null)
partsoption.Quantity__c = 0;*/
                        //partsoption.Item__c = prtslist.item;
                        
                        //partsoption.Part_Description__c = prtslist.PartDescription;
                        partsoption.ExpenseTotal__c = prtslist.amount;//Changed as per 148913: Rupesh
                        
                        //Commented as part of story GSSC-138
                        //partsoption.Unit_Price__c = String.valueof(prtslist.Unitprice);
                        
                        if(prtslist.accountcode!=null && prtslist.coveredPercent!=null && prtslist.coveredPercent!= ''  && prtslist.Unitprice!=null  && prtslist.quantity!=null && prtslist.quantity!= '' )
                            partsoption.ExpenseTotal__c = Decimal.valueOf(prtslist.quantity) * (Decimal.valueOf(prtslist.coveredPercent)/100) * prtslist.Unitprice;
                        system.debug('partsoption.ExpenseTotal__c'+partsoption.ExpenseTotal__c);
                        
                        //GSSC-138 start
                        system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                        system.debug('prtslist.ids--'+prtslist.ids);
                        if(prtslist.ids != null){
                            if(prtslist.UnitpriceModified != null){
                                if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                                    if(userinfo.getDefaultCurrency() != 'USD'){
                                        partsoption.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                        partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                        partsoption.Unit_Price_Local_Currency__c = prtslist.Unitprice;
                                        partsoption.Amount_Local_Currency__c = prtslist.amount;
                                        partsoption.Unit_Price__c = string.valueOf((prtslist.Unitprice) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c));
                                        partsoption.ExpenseTotal__c = (prtslist.amount) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                    }
                                    else{
                                        partsoption.Exchange_Rate__c = 1;
                                        partsoption.Unit_Price_Local_Currency__c = prtslist.Unitprice;
                                        partsoption.Amount_Local_Currency__c = prtslist.amount;
                                        partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                        partsoption.Unit_Price__c = string.valueOf(prtslist.Unitprice);
                                    }
                                    partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                                }
                            }
                        }
                        else{
                            partsoption.ExpenseTotal__c = prtslist.amount;
                            partsoption.Unit_Price__c = string.valueOf(prtslist.Unitprice);
                        }
                        //GSSC-138 end
                        
                        if(prtslist.coveredPercent!='' && prtslist.coveredPercent!=null)
                            partsoption.Covered__c = Decimal.valueOf(prtslist.coveredPercent);
                        partsoption.Fail_Code__c = prtslist.failCode;
                        // if(prtslist.coveredPercent == null || prtslist.coveredPercent == '' || prtslist.coveredPercent == '0')
                        system.debug('Testprtslist.accountCode'+prtslist.accountCode+'prtslist.coveredPercent'+prtslist.coveredPercent);
                        if(prtslist.coveredPercent == null || prtslist.coveredPercent == '')
                        {
                            partsoption.Account_Code__c = 'Select One';
                            partsoption.Claimtype__c = '';
                        }
                        else
                            partsoption.Account_Code__c = prtslist.accountCode;
                        if(prtslist.failCode=='Select One')
                            partsoption.Account_Code__c = 'Select One';
                        if(prtslist.failCode=='Select One')
                            partsoption.Covered__c = null;
                        if(prtslist.accountcode != null)
                        {
                            accountCodeList.add(prtslist.accountcode);
                        }
                        if(prtslist.failcode != null)
                        {
                            failCodeList.add(prtslist.failcode);
                        }
                        
                        
                        partsoption.Id=prtslist.ids;
                        partsoption.Id=prtslist.idStr;
                        
                        if(partsoption.Id==null)
                            partsoption.isManual__c = true;
                        
                        partsoption.CSS_Claims__c = cId;
                        partsoption.selected_part__c = true;
                       
                        selectedCustPartsList.add(partsoption);
                        
                        if(OCMap != null && OCMap.containsKey(partsoption.Account_Code__c)){
                            tempList = OCMap.get(partsoption.Account_Code__c);
                            tempList.add(partsoption.Item__c);
                            OCMap.put(partsoption.Account_Code__c, tempList);
                        }
                        else{
                            tempList = new List<String>();
                            tempList.add(partsoption.Item__c);
                            OCMap.put(partsoption.Account_Code__c, tempList);
                        } 
                                               
                                                
                        // system.debug('HSEJAR+partsoption.prtslist.item'+prtslist.item);
                        // System.debug('HSEJAR+partsoption.Previous_Item__c'+partsoption.Previous_Item__c);
                        // System.debug('HSEJAR+partsoption.partsoption.ODM_Status__c'+partsoption.ODM_Status__c);
                        System.debug('selectedCustPartsList test'+selectedCustPartsList);
                    }
                }
                if (TTMLList != null && TTMLList.size() > 0 )
                {
                for(CSS_Parts_Options__c po: TTMLList){
                    if(OCMap != null && OCMap.containsKey(po.Account_Code__c)){
                        tempList = OCMap.get(po.Account_Code__c);
                        tempList.add(po.Type__c);
                        OCMap.put(po.Account_Code__c, tempList);
                    }
                    else{
                        tempList = new List<String>();
                        tempList.add(po.Type__c);
                        OCMap.put(po.Account_Code__c, tempList);
                    }
                }
                }
                System.debug('selectedCustPartsList test----->>>>>>'+selectedCustPartsList);
                //Remove logic here
                System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
               for(string Str : OCMap.keySet()){
                   List<string> tempvar;
                   tempvar = OCMap.get(Str);
                   if(tempvar!=null && (tempvar.contains('COMMERCIAL TRAVEL') || tempvar.contains('Commercial-Travel') || tempvar.contains('NON COMMERCIAL TRAVEL') || tempvar.contains('Non Commercial-Travel')) && tempvar.contains('TOWING')){
                    TravelTowingError=true;
                    system.debug('TravelTowingError***' + TravelTowingError);
                    return null;
               }
               }
                
             

                try
                {
                    if(removeIdsMap.keySet().size()>0)
                    {
                        deleteParts();
                    }
                }catch(Exception ex) 
                {
                    System.debug('first in catch of saveCustomParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                }
            }
            else
                return null;
            displayPopup2 = false;
            //CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            errMsgLst = new Set<String>();
            if(selectedCustPartsList != null && selectedCustPartsList.size() > 0){
                errMsgLst = contr.covLimitValidation(null, CID, null, selectedCustPartsList);
            }
            system.debug('errMsgLst -->'+errMsgLst);
            if(errMsgLst != null && errMsgLst.size() > 0){
                for(claimablesWrapperClass prtslist:listpartWrapper){
                    List<String> tempLstStr = new List<String>();
                    if(prtslist.failCode != null && prtslist.failCode != '' && prtslist.failCode != 'Select One'){
                        tempLstStr = prtslist.failCode.split('-');
                    }
                    String temp1;
                    if(tempLstStr.size() > 0){
                        temp1 = tempLstStr[tempLstStr.size()-1];
                    }
                    String temp = temp1+';;'+prtslist.accountCode;
                    system.debug('temp -->'+temp);
                    if(errMsgLst != null && errMsgLst.contains(prtslist.accountCode)){
                        prtslist.isPartsCovLimitExceed = true;
                    }
                    else{
                        if(errMsgLst != null && errMsgLst.contains(temp)){
                            prtslist.isPartsCovLimitExceedPW = true;
                        } 
                        else{
                            prtslist.isPartsCovLimitExceed = false;
                            prtslist.isPartsCovLimitExceedPW = false;
                        }
                    }
                    system.debug('isPartsCovLimitExceed'+prtslist.isPartsCovLimitExceed);
                    system.debug('isPartsCovLimitExceedPW'+prtslist.isPartsCovLimitExceedPW);
                }
                
            }else{
                if(selectedCustPartsList != null && selectedCustPartsList.size()>0){
                    upsert selectedCustPartsList Id;
                }
                getallCustomPartsData(displayPopup2);
            }
            
            //Commited the below code as per new story #152681, -By RAJESH 5th July 2018          
            /*/Added code  as per The Gap story #147387, -By RAJESH 12th JUNE 2018       
CSS_Claims__c comClaimRec  =[select id,ODM_Status__c,
(select id,ODM_Status__c,Account_Code__c,Fail_Code__c,Previous_Item__c from CSS_Parts_Options__r
where Account_Code__c IN:accountCodeList AND Fail_Code__c IN:failCodeList),
(select id,ODM_Status__c,Fail_Code__c,AccountCode__c,CSS_Account_Formula__c,FailCode_Formula__c from CSS_Solution_Components__r
where (AccountCode__c IN:accountCodeList OR CSS_Account_Formula__c IN:accountCodeList) AND (FailCode_Formula__c IN:failCodeList OR Fail_Code__c IN:failCodeList)),
(select id,ODM_Status__c,FailCode__c,Account_Code__c,AccountCode_Formula__c,Fail_Code_Description__c from CSS_SRTs__r
where (Account_Code__c IN: accountCodeList OR AccountCode_Formula__c IN:accountCodeList)  AND (FailCode__c IN: failCodeList OR Fail_Code_Description__c IN: failCodeList)) 
from  CSS_Claims__c 
where id=:cid];
// System.debug('**RAJESH+comClaimRec'+comClaimRec);
for(claimablesWrapperClass  prtslist:listpartWrapper ){
//system.debug('*RAJESH Inside For loop*');
if(prtslist.Item=='Unlisted' && prtslist.AccountCode!=null && prtslist.FailCode!=null){
//system.debug('*RAJESH Inside if loop*');
for(CSS_Solution_Component__c solQurRec :comClaimRec.CSS_Solution_Components__r){
if(prtslist.AccountCode== solQurRec.CSS_Account_Formula__c && prtslist.FailCode==solQurRec.FailCode_Formula__c){
solQurRec.ODM_Status__c='NA';
}
lstSOCRec.add(solQurRec);
}
for(CSS_SRT__c srtQurRec :comClaimRec.CSS_SRTs__r){
if(prtslist.AccountCode== srtQurRec.AccountCode_Formula__c && prtslist.FailCode==srtQurRec.Fail_Code_Description__c){
srtQurRec.ODM_Status__c='NA';
}
lstSRTRec.add(srtQurRec);
} 
for(CSS_Parts_Options__c paOpQurRec :comClaimRec.CSS_Parts_Options__r){
if(prtslist.AccountCode== paOpQurRec.Account_Code__c && prtslist.FailCode==paOpQurRec.Fail_Code__c){
paOpQurRec.ODM_Status__c='NA';
}
lstPoRec.add(paOpQurRec);
}
}
else if(prtslist.Item!='Unlisted' && prtslist.previousItem=='Unlisted'){
// system.debug('*RAJESH Inside else if loop*');
for(CSS_Solution_Component__c solQurRec :comClaimRec.CSS_Solution_Components__r){
if(prtslist.AccountCode== solQurRec.CSS_Account_Formula__c && prtslist.FailCode==solQurRec.FailCode_Formula__c){
solQurRec.ODM_Status__c='YTBV';
}
lstSOCRec.add(solQurRec);
// system.debug('**RAJESH+solQurRec'+lstSOCRec);
}
for(CSS_SRT__c srtQurRec :comClaimRec.CSS_SRTs__r){
if(prtslist.AccountCode== srtQurRec.AccountCode_Formula__c && prtslist.FailCode==srtQurRec.Fail_Code_Description__c){
srtQurRec.ODM_Status__c='YTBV';
}
lstSRTRec.add(srtQurRec);
// system.debug('**RAJESH+srtQurRec'+lstSRTRec);
}
for(CSS_Parts_Options__c paOpQurRec :comClaimRec.CSS_Parts_Options__r){
if(prtslist.AccountCode== paOpQurRec.Account_Code__c && prtslist.FailCode==paOpQurRec.Fail_Code__c){
paOpQurRec.ODM_Status__c='YTBV';
}
lstPoRec.add(paOpQurRec);
// system.debug('**RAJESH+paOpQurRec'+lstPoRec);
}
}
}

update lstSOCRec;
update lstSRTRec;
update lstPoRec;
//End  */     
            
            
            
            //saveExpenseTotal();
            //Remove logic here
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            
        }catch(Exception ex) {
            System.debug('second in catch of saveCustomParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        pageRef = new PageReference(sDestURL+'id='+cId); 
        system.debug('sDestURL' + sDestURL);
        pageRef.setRedirect(true);
        errMsgLstNew = new List<String>();
        if(errMsgLst != null && errMsgLst.size() > 0){
            for(String err : errMsgLst){
                if(!err.contains(';;')){
                    errMsgLstNew.add(Label.CSS_OC_CoverageLimitExceedMsg+' '+err);
                }
                else{
                    List<String> failCodeAccCode = new List<String>();
                    failCodeAccCode = err.split(';;');
                    //Rupesh Label
                    //errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg_PW1+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1]);
                    errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg_PW3+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW4+' '+failCodeAccCode[1]);
                }
            }
            return null;
        }else{
            return pageRef;
        }
    }
    
    public void deleteParts(){
        System.debug('in deleteParts GSQ Parts:8');
        try{
            List<CSS_Parts_Options__c> toDeleteOtherClaimablesList = new list<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> deleteOtherClaimablesList = new List<CSS_Parts_Options__c>([SELECT Id,isManual__c FROM CSS_Parts_Options__c WHERE Id IN:removeIdsMap.keySet()]);
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            system.debug('delete OC' +deleteOtherClaimablesList);
            if(deleteOtherClaimablesList.size()>0){
                delete deleteOtherClaimablesList;
                removeIdsMap = new Map<Id, String>();
            }
        }catch(Exception ex) {
            System.debug('in catch of deleteParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    public void AddRow(){
        try{
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();
            
            listpartWrapper2.add(new claimablesWrapperClass(listpartWrapper2.size(),null,null,'N/A',null,null,null,null,null,null,null,null,null,null,false,false,false, null, null, null, null));
            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
            system.debug('listpartWrapper data--->'+listpartWrapper);
            system.debug('listpartWrapper size--->'+listpartWrapper.size());   
        }catch(Exception ex) {
            System.debug('in catch of AddRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    public void removingRow(){
        System.debug('in removingRow GSQ Parts:6');
        System.debug('listpartWrapper IN REMOVE ROW'+listpartWrapper);
        System.debug('assignedParts '+assignedParts);
        try{
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();
            for(Integer i=0;i<listpartWrapper2.size();i++){
                if(listpartWrapper2[i].counting==assignedParts){
                    System.debug('Selected Remove Row '+assignedParts);
                    System.debug('listpartWrapper[i].counting '+listpartWrapper2[i].counting);
                    listpartWrapper2[i].quantity='';
                    listpartWrapper2[i].PartDescription='N/A';
                    listpartWrapper2[i].Item='Select One';
                    listpartWrapper2[i].amount=0;
                    listpartWrapper2[i].Unitprice= null;
                    listpartWrapper2[i].coveredPercent='';
                    listpartWrapper2[i].failCode='Select One';
                    listpartWrapper2[i].accountCode='Select One';
                    
                    if(listpartWrapper2[i].ids != null && String.valueOf(listpartWrapper2[i].ids).trim() !=''){
                        removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                    }
                    System.debug('removeIdsMap>>>:'+removeIdsMap);
                    //listpartWrapper2.remove(i);
                }
            }
            
            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        //options.add( new SelectOption('','Select'));
        Schema.DescribeFieldResult fieldResult =  CSS_Parts_Options__c.Item__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getValue(),f.getLabel()));
        }       
        return options;
    }
    
    public void onChangeofItem(){
        system.debug('SelectedItem***'+SelectedItem);
        if(SelectedItem == 'Unlisted'){
            system.debug('Inside***'+listpartWrapper);
            system.debug('Inside1***'+SelectedPartID);
            for(claimablesWrapperClass  prtslist:listpartWrapper){
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.PartDescription =  '';  
                    prtslist.accountCode=null;
                    prtslist.coveredPercent='';
                    prtslist.quantity = '';
                    prtslist.Unitprice=null;
      //Start code for syory GSSc-142,-BY RAJESH 21st Oct 2019                
                    setSelectedItem=SelectedItem;
                    system.debug('setSelectedItem*********'+setSelectedItem);
                        getfailcodeDropDownBasedOnItem(SelectedItem ,SelectedPartID);

        //End code for syory GSSc-142,-BY RAJESH 21st Oct 2019
                    prtslist.amount=0;
                    prtslist.failCode = null;
                    
                }
                else{
                    if(prtslist.Unitprice==0){
                        prtslist.Unitprice=null;
                    }
                }
                
            } 
            
        }
        else{
            for(claimablesWrapperClass  prtslist:listpartWrapper){
                if(prtslist.counting == SelectedPartID)
                {
                    //prtslist.PartDescription =  '';
                    prtslist.accountCode=null;
                    prtslist.coveredPercent='';
                    prtslist.quantity = '';
                    prtslist.Unitprice=null;
      //Start code for syory GSSc-142,-BY RAJESH 21st Oct 2019
                          setSelectedItem=SelectedItem;
                          system.debug('setSelectedItem*********'+setSelectedItem);
                        getfailcodeDropDownBasedOnItem(SelectedItem,SelectedPartID);

        //End code for syory GSSc-142,-BY RAJESH 21st Oct 2019               
                    prtslist.amount=0;
                    prtslist.failCode = null;
                }
                else{
                    if(prtslist.Unitprice==0){
                        prtslist.Unitprice=null;
                    }
                }
            } 
            
            
        }
            populateOCFailCodenAccountCode(SelectedItem);
    }
    
    public void populateOCFailCodenAccountCode(String selItem){
        system.debug('Method goining inside onChangeofFailCode'+selItem);
        system.debug('failAccountCodeMap>>>>>>>>>>: '+failAccountCodeMap);
        
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        //GSSC-298 - START
        if(selItem == 'COMMERCIAL TRAVEL' || selItem == 'TOWING'){
            lstSolComp= [SELECT Id, name,Over_The_Counter__c, SysCodeAndCompCode__c, FailCode_Formula__c , CampaignTravelPercentage__c, CSS_CoverageType__c,CSS_Claims__c,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CampaignOCPercentage__c,Selected_Component__c,Type__c  from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Selected_Component__c= true AND Over_The_Counter__c != true];
        }
        else{//GSSC-298 - END
            lstSolComp= [SELECT Id, name, Over_The_Counter__c, SysCodeAndCompCode__c, FailCode_Formula__c , CampaignTravelPercentage__c, CSS_CoverageType__c,CSS_Claims__c,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CampaignOCPercentage__c,Selected_Component__c,Type__c  from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Selected_Component__c= true];
        }
        String accCode;
        String failCode;
        String CoveredPar ='';
        
        //GSSC-300
        Map<String,List<CSS_Solution_Component__c>> solCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
        
        if(lstSolComp != null && lstSolComp.size() > 0){
            List<CSS_Solution_Component__c> tempList;
            for(CSS_Solution_Component__c slcp : lstSolComp){
                String FARec;
                if(slcp.Type__c == 'Campaign' || slcp.Type__c == 'TRP' || slcp.Type__c == 'ATC')
                    FARec='FieldAction';
                else
                    FARec='Failure';
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
                    solCmpMap.put(FARec, tempList);
                }
            }
            tempList = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> tempListFA = new List<CSS_Solution_Component__c>();
            Map<String,List<CSS_Solution_Component__c>> accSolCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
            List<CSS_Solution_Component__c> accSlCmp;
            tempList = solCmpMap.get('Failure');
            tempListFA = solCmpMap.get('FieldAction');
            List<SelectOption> options;
            
            if(tempList!=null && tempList.size() >1){
                for(CSS_Solution_Component__c sc:tempList){
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
            system.debug('***tempListFA***'+tempListFA);
            system.debug('***tempList***'+tempList);
            system.debug('***selItem***'+selItem);
            if((tempListFA!=null && tempListFA.size() == 1 && selItem == 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL' && tempListFA[0].CampaignOCPercentage__c != null && Integer.valueOf(tempListFA[0].CampaignOCPercentage__c) >0) || (tempListFA!=null && tempListFA.size() == 1 && selItem == 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL' && (tempListFA[0].CSS_CoverageType__c == 'POL' || tempListFA[0].CSS_CoverageType__c == 'OTH'))){
                CoveredPar =  tempListFA[0].CampaignOCPercentage__c; 
                failCode =  String.valueof(tempListFA[0].FailCode_Formula__c);
                accCode = tempListFA[0].CSS_Account_Formula__c;
                options=getAccountCodeDropDown(tempListFA[0].SysCodeAndCompCode__c);
            }
            else if(tempList !=null && tempList.size() >0 && selItem != 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL'){
                if((tempList.size() == 1  && tempList[0].CoveredOCAmount__c != null && Integer.valueOf(tempList[0].CoveredOCAmount__c) >0) || (selItem != 'Campaign Supplies'  && selItem != 'COMMERCIAL TRAVEL' && (tempList[0].CSS_CoverageType__c == 'POL' || tempList[0].CSS_CoverageType__c == 'OTH'))){
                    CoveredPar =  tempList[0].CoveredOCAmount__c; 
                    failCode =  String.valueof(tempList[0].FailCode_Formula__c);
                    accCode = tempList[0].CSS_Account_Formula__c;
                    options=getAccountCodeDropDown(tempList[0].SysCodeAndCompCode__c);
                }
                else if((tempList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1 && tempList[0].CoveredOCAmount__c != null && Integer.valueOf(tempList[0].CoveredOCAmount__c) >0 && tempList[0].CSS_CoverageType__c != 'NPW' && tempList[0].CSS_CoverageType__c != 'RPW' && tempList[0].CSS_CoverageType__c != 'RRW') || (selItem != 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL' && (tempList[0].CSS_CoverageType__c == 'POL' || tempList[0].CSS_CoverageType__c == 'OTH'))){
                    CoveredPar =  tempList[0].CoveredOCAmount__c; 
                    failCode =  String.valueof(tempList[0].FailCode_Formula__c);
                    accCode = tempList[0].CSS_Account_Formula__c;
                    options=getAccountCodeDropDown(tempList[0].SysCodeAndCompCode__c);
                }
                else{
                    failCode =  'Select One';
                    accCode = 'Select One';
                    CoveredPar ='';
                }
                
            }
            else if((selItem == 'COMMERCIAL TRAVEL' && tempListFA!=null && tempListFA.size() >= 0 && tempList == null && tempListFA[0].CampaignTravelPercentage__c != null && Integer.valueOf(tempListFA[0].CampaignTravelPercentage__c) >0) || (selItem == 'COMMERCIAL TRAVEL' && tempListFA!=null && tempListFA.size() >= 0 && tempList == null && (tempListFA[0].CSS_CoverageType__c == 'POL' || tempListFA[0].CSS_CoverageType__c == 'OTH'))){// Added below 3 conditions as part of defect gssc 583
                system.debug('insideifelse1***');
                CoveredPar =  tempListFA[0].CampaignTravelPercentage__c; 
                failCode =  String.valueof(tempListFA[0].FailCode_Formula__c);
                accCode = tempListFA[0].CSS_Account_Formula__c;
                options=getAccountCodeDropDown(tempListFA[0].SysCodeAndCompCode__c);
            }
            else if((selItem == 'COMMERCIAL TRAVEL' && tempList!=null && tempList.size() >= 0 && tempListFA == null && tempList[0].CoveredOCAmount__c != null && Integer.valueOf(tempList[0].CoveredOCAmount__c) >0) || (selItem == 'COMMERCIAL TRAVEL' && tempList!=null && tempList.size() >= 0 && tempListFA == null && (tempList[0].CSS_CoverageType__c == 'POL' || tempList[0].CSS_CoverageType__c == 'OTH'))){
                system.debug('insideifelse2***');
                CoveredPar =  tempList[0].CoveredOCAmount__c; 
                failCode =  String.valueof(tempList[0].FailCode_Formula__c);
                accCode = tempList[0].CSS_Account_Formula__c;
                options=getAccountCodeDropDown(tempList[0].SysCodeAndCompCode__c);
            }
            else if((selItem == 'COMMERCIAL TRAVEL' && tempList!=null && tempList.size() >= 0 && tempListFA != null && tempList[0].CoveredOCAmount__c != null && Integer.valueOf(tempList[0].CoveredOCAmount__c) >0) || (selItem == 'COMMERCIAL TRAVEL' && tempList!=null && tempList.size() >= 0 && tempListFA != null && (tempList[0].CSS_CoverageType__c == 'POL' || tempList[0].CSS_CoverageType__c == 'OTH'))){
                system.debug('insideifelse3**');
                CoveredPar =  tempList[0].CoveredOCAmount__c; 
                failCode =  String.valueof(tempList[0].FailCode_Formula__c);
                accCode = tempList[0].CSS_Account_Formula__c;
                options=getAccountCodeDropDown(tempList[0].SysCodeAndCompCode__c);
            }// Added above 3 conditions as part of defect gssc 583 end
            else if((selItem != 'COMMERCIAL TRAVEL' && selItem != 'Campaign Supplies' && tempListFA!=null && tempListFA.size() ==1 && tempList == null && tempListFA[0].CampaignOCPercentage__c != null && Integer.valueOf(tempListFA[0].CampaignOCPercentage__c) >0) || (selItem == 'COMMERCIAL TRAVEL' && tempListFA!=null && tempListFA.size() >= 0 && tempList == null && (tempListFA[0].CSS_CoverageType__c == 'POL' || tempListFA[0].CSS_CoverageType__c == 'OTH'))){// Added condition as part of defect gssc 591
                system.debug('insideifelse1***');
                CoveredPar =  tempListFA[0].CampaignOCPercentage__c; 
                failCode =  String.valueof(tempListFA[0].FailCode_Formula__c);
                accCode = tempListFA[0].CSS_Account_Formula__c;
                options=getAccountCodeDropDown(tempListFA[0].SysCodeAndCompCode__c);
            }
            if((CoveredPar != null && CoveredPar != '') || (tempList!=null && tempList[0].CSS_CoverageType__c == 'POL')) {
                if((CoveredPar !=null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0) || (tempList!=null && tempList[0].CSS_CoverageType__c == 'POL'))
                    CoveredPar = '100';
                else if(Integer.ValueOf(CoveredPar) == 0)
                    CoveredPar = '0';
                else
                    CoveredPar = '';
            } else
                CoveredPar = '';    
            
            for(claimablesWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID){
                    if((prtslist.Item != 'COMMERCIAL TRAVEL' && prtslist.Item != 'TOWING') || ((prtslist.Item == 'COMMERCIAL TRAVEL' || prtslist.Item == 'TOWING') && lstSolComp[0].Over_The_Counter__c != true)){
                        prtslist.failCode =  failCode;
                        prtslist.accountCode = accCode ;
                        prtslist.lstAccountCodes=options;
                        system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                        if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                            prtslist.coveredPercent='';
                        else
                            prtslist.coveredPercent=CoveredPar;
                    }
                }
                else{
                    system.debug('prtslist.countinginsideelse>>>>>>>>>>: ');
                    if(prtslist.Unitprice==0){
                        prtslist.Unitprice=null;
                    }
                }
            }
            
            populateAmountValue();
            
        }
        
        //GSSC-300
        
        /*if(lstSolComp != null && lstSolComp.size() == 1){
            List<SelectOption> options=getAccountCodeDropDown(lstSolComp[0].SysCodeAndCompCode__c);
            
            accCode =lstSolComp[0].CSS_Account_Formula__c; 
            
            if(JETFA != null){
                for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                    if(jobEntObj.Account_Code__c == lstSolComp[0].CSS_Account_Formula__c){
                        coverageType = jobEntObj.Attribute1__c;
                    }
                }
            }
            system.debug('coverageType***'+coverageType);
            if((coverageType == 'OTH' || coverageType == 'POL') && lstSolComp[0].Selected_Component__c== true){
                CoveredPar =  lstSolComp[0].CoveredOCAmount__c; 
            }
            else if((coverageType == 'OTH' || coverageType == 'POL') && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign')){
                CoveredPar =  lstSolComp[0].CampaignOCPercentage__c; 
            }
            if(lstSolComp[0].CoveredOCAmount__c != null && Integer.valueOf(lstSolComp[0].CoveredOCAmount__c) >0 && lstSolComp[0].Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL'))
                CoveredPar =  lstSolComp[0].CoveredOCAmount__c; 
            else if(lstSolComp[0].CampaignOCPercentage__c != null && Integer.valueOf(lstSolComp[0].CampaignOCPercentage__c) >0 && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))
                CoveredPar =  lstSolComp[0].CampaignOCPercentage__c; 
            
            system.debug('amount'+CoveredPar);
            //Defect:190397.
            if((CoveredPar != null && CoveredPar != '') || (coverageType !=null && coverageType == 'POL')) {
                if((CoveredPar !=null && CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0) || coverageType == 'POL')
                    CoveredPar = '100';
                else if(Integer.ValueOf(CoveredPar) == 0)
                    CoveredPar = '0';
                else
                    CoveredPar = '';
            } else
                CoveredPar = '';    
            
            
            //Defect:190397.
            system.debug('CoveredParts>>>>>>>>>>: '+CoveredPar);
            system.debug('listpartWrapper123>>>>>>>>>>: '+listpartWrapper);
            for(claimablesWrapperClass  prtslist:listpartWrapper ){
                
                if(prtslist.counting == SelectedPartID)
                {
                    system.debug('prtslist.countinginsideif>>>>>>>>>>: ');
                    //prtslist.failCode =  String.valueof(SelectedFailCode);
                    //Below if condition is added as part of the story GSSC-298
                    if((prtslist.Item != 'COMMERCIAL TRAVEL' && prtslist.Item != 'TOWING') || ((prtslist.Item == 'COMMERCIAL TRAVEL' || prtslist.Item == 'TOWING') && lstSolComp[0].Over_The_Counter__c != true)){
                        prtslist.failCode =  String.valueof(lstSolComp[0].FailCode_Formula__c);
                        // prtslist.coveredPercent = String.valueof(CoveredPar);
                        
                        prtslist.accountCode = accCode ;
                        prtslist.lstAccountCodes=options;
                        system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                        if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                            prtslist.coveredPercent='';
                        else
                            prtslist.coveredPercent=CoveredPar;
                        //   prtslist.accountCode = accCode ;
                    }
                    
                }
                else{
                    system.debug('prtslist.countinginsideelse>>>>>>>>>>: ');
                    if(prtslist.Unitprice==0){
                        prtslist.Unitprice=null;
                    }
                }
                
                
            }
            
            populateAmountValue();
        }*/
    }
   
    public void onChangeofFailCode(){
        system.debug('Method goining inside onChangeofFailCode');
        system.debug('setSelectedItem****'+setSelectedItem);
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        String failCode1;
        String[] tempStr;
        if(selectedFailCode.contains('-')){
            tempStr = selectedFailCode.split('-');
            if(tempStr[1].length()>4){
                system.debug('insideFCIF '+tempStr[1]);
                failCode1=tempStr[1].LEFT(4);
            }
            else{
                failCode1=tempStr[1];
            }
        }
        else{
            failCode1=selectedFailCode;
        }
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('failAccountCodeMap>>>>>>>>>>: '+failAccountCodeMap);
        
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        String accCode;
        String CoveredPar ='';
        if(SelectedFailCode!='Select One')
        {
            List<SelectOption> options=getAccountCodeDropDown(failCode1);
            lstSolComp = [SELECT  Id,Over_The_Counter__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c, CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CampaignOCPercentage__c,Selected_Component__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:cId and SysCodeAndCompCode__c   = :failCode1 AND SysCodeAndCompCode__c!=''];
            if(lstSolComp != null && lstSolComp.size()!=0)
            {
                system.debug('lstSolComp1>>>>>>>>>'+lstSolComp);
                if(lstSolComp.size() > 1)
                {
                    string acCode;
                    acCode = lstSolComp[0].CSS_Account_Formula__c;
                    boolean setAcCode = false;
                    for(integer i=0;i<lstSolComp.size();i++ ){
                        if(lstSolComp[0].Id != lstSolComp[i].Id && acCode != lstSolComp[i].CSS_Account_Formula__c)
                        {
                            setAcCode = true;
                            break;
                        }
                    }
                    system.debug('Anirudh>>>'+setAcCode);
                    if(setAcCode==true)
                    {
                        accCode='Select One';
                    }else{
                        accCode=acCode;
                    }
                }
                else{
                    accCode =lstSolComp[0].CSS_Account_Formula__c; 
                    system.debug('accCode'+accCode);
                }
                if(JETFA != null){
                    for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                        if(jobEntObj.Account_Code__c == lstSolComp[0].CSS_Account_Formula__c){
                            coverageType = jobEntObj.Attribute1__c;
                        }
                    }
                }
                system.debug('coverageType***'+coverageType);
                if((coverageType == 'OTH' || coverageType == 'POL') && lstSolComp[0].Selected_Component__c== true){
                    CoveredPar =  lstSolComp[0].CoveredOCAmount__c; 
                }
                else if((coverageType == 'OTH' || coverageType == 'POL') && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign')){
                    CoveredPar =  lstSolComp[0].CampaignOCPercentage__c; 
                }
                if(lstSolComp[0].CoveredOCAmount__c != null && Integer.valueOf(lstSolComp[0].CoveredOCAmount__c) >0 && lstSolComp[0].Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL'))
                    CoveredPar =  lstSolComp[0].CoveredOCAmount__c; 
                    //CoveredPar =  '103'; 
                else if(lstSolComp[0].CampaignOCPercentage__c != null && Integer.valueOf(lstSolComp[0].CampaignOCPercentage__c) >0 && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))
                    CoveredPar =  lstSolComp[0].CampaignOCPercentage__c;
                
                system.debug('amount'+CoveredPar);
            }
            if((CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0 ) || coverageType == 'POL'){
                CoveredPar = '100';
                system.debug('setSelectedItem'+setSelectedItem+'CampaignTowingPercentage__c'+lstSolComp[0].CampaignTowingPercentage__c);
            }
            else if(CoveredPar!='' && Integer.ValueOf(CoveredPar) == 0){
                CoveredPar = '0';
                
            }
            else{
                system.debug('setSelectedItem'+setSelectedItem);
                CoveredPar = '';
            }
            
            //Story 605
            if(setSelectedItem == 'COMMERCIAL TRAVEL' && lstSolComp[0].CampaignTravelPercentage__c!=null){
               CoveredPar =  lstSolComp[0].CampaignTravelPercentage__c; 
                
            }
            else if(setSelectedItem == 'TOWING' && lstSolComp[0].CampaignTowingPercentage__c!=null){
               CoveredPar =  lstSolComp[0].CampaignTowingPercentage__c; 
                
            }
            //Story 605 end
            
            
            system.debug('CoveredParts>>>>>>>>>>: '+CoveredPar);
            system.debug('listpartWrapper123>>>>>>>>>>: '+listpartWrapper);
            for(claimablesWrapperClass  prtslist:listpartWrapper ){
                
                if(prtslist.counting == SelectedPartID)
                {
                    system.debug('prtslist.countinginsideif>>>>>>>>>>: ');
                    //prtslist.failCode =  String.valueof(SelectedFailCode);
                    prtslist.failCode =  String.valueof(SelectedFailCode);
                    // prtslist.coveredPercent = String.valueof(CoveredPar);
                    
                    prtslist.accountCode = accCode ;
                    prtslist.lstAccountCodes=options;
                    system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                    if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                        prtslist.coveredPercent='';
                    else
                        prtslist.coveredPercent=CoveredPar; 
                    //   prtslist.accountCode = accCode ;
                    
                }
                else{
                    system.debug('prtslist.countinginsideelse>>>>>>>>>>: ');
                    if(prtslist.Unitprice==0){
                        prtslist.Unitprice=null;
                    }
                }
                
                
            }
            for(ttmlWrapperClass  ttmlprtslist:listTTMLWrapper ){
                
                if(ttmlprtslist.counting == SelectedPartID)
                {
                    ttmlprtslist.failCode =  String.valueof(SelectedFailCode);
                    ttmlprtslist.accountCode = accCode ;
                    ttmlprtslist.accCodelst = options;
                }
            }
            system.debug('listpartWrapperinsideif***'+listpartWrapper);
        }
        else
        {
            accCode='Select One';
            CoveredPar = '';
            List<SelectOption> options =  new List<SelectOption>();
            options.add(new SelectOption('Select One','Select One'));
            system.debug('listpartWrapperinsideelse***'+listpartWrapper);
            for(claimablesWrapperClass  prtslist:listpartWrapper )
            {
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.failCode =  String.valueof(SelectedFailCode);
                    prtslist.accountCode = accCode ;
                    prtslist.lstAccountCodes=options;
                    if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                        prtslist.coveredPercent='';
                    else
                        prtslist.coveredPercent=CoveredPar;
                }
                else{
                    if(prtslist.Unitprice==0){
                        prtslist.Unitprice=null;
                    }
                }
            }
            for(ttmlWrapperClass  ttmlprtslist:listTTMLWrapper ){
                
                if(ttmlprtslist.counting == SelectedPartID)
                {
                    ttmlprtslist.failCode =  String.valueof(SelectedFailCode);
                    ttmlprtslist.accountCode = accCode ;
                }
            } 
        }
        populateAmountValue();
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
        if(tempStr[1].length()>4){
            system.debug('insideFCIF '+tempStr[1]);
            failCode1=tempStr[1].LEFT(4);
        }
        else{
            failCode1=tempStr[1];
        }
        if(SelectedAccountCode!='Select One'){
            lstSolComp1 = [SELECT  Id,Over_The_Counter__c, CSS_Account_Formula__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c,AccountCodeEdit__c,CampaignOCPercentage__c,Selected_Component__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:cId and CSS_Account_Formula__c = :SelectedAccountCode and SysCodeAndCompCode__c = :failCode1 and CSS_Account_Formula__c!=''];            
            system.debug('lstSolComp1'+lstSolComp1);
            system.debug('lstSolComp1size'+lstSolComp1.size());
            if(lstSolComp1!=null && lstSolComp1.size()!=0){
                system.debug('listpartWrapper-->'+listpartWrapper);
                
                //if(lstSolComp1[0].CoveredOCAmount__c!=null && lstSolComp1[0].CoveredOCAmount__c!='')
                //CoveredParAC =  lstSolComp1[0].CoveredOCAmount__c; 
                
                if(JETFA != null){
                    for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                        if(jobEntObj.Account_Code__c == SelectedAccountCode){
                            coverageType = jobEntObj.Attribute1__c;
                        }
                    }
                }
                system.debug('coverageType***'+coverageType);
                
                if((coverageType == 'OTH' || coverageType == 'POL') && lstSolComp1[0].Selected_Component__c== true){
                    CoveredParAC =  lstSolComp1[0].CoveredOCAmount__c; 
                }
                else if((coverageType == 'OTH' || coverageType == 'POL') && (lstSolComp1[0].Type__c == 'TRP'|| lstSolComp1[0].Type__c =='ATC'||lstSolComp1[0].Type__c =='Campaign')){
                    CoveredParAC =  lstSolComp1[0].CampaignOCPercentage__c; 
                }
                
                if(lstSolComp1[0].CoveredOCAmount__c != null && Integer.valueOf(lstSolComp1[0].CoveredOCAmount__c) >0 && lstSolComp1[0].Selected_Component__c== true && (coverageType != 'OTH' && coverageType != 'POL'))
                    CoveredParAC =  lstSolComp1[0].CoveredOCAmount__c; 
                else if(lstSolComp1[0].CoveredOCAmount__c != null && lstSolComp1[0].CampaignOCPercentage__c!=null && Integer.valueOf(lstSolComp1[0].CampaignOCPercentage__c) >0  && lstSolComp1[0].Type__c!=null && (lstSolComp1[0].Type__c == 'TRP'|| lstSolComp1[0].Type__c =='ATC'||lstSolComp1[0].Type__c =='Campaign')  && (coverageType != 'OTH' && coverageType != 'POL'))
                    CoveredParAC =  lstSolComp1[0].CampaignOCPercentage__c; 
                
                if((CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0 ) || coverageType == 'POL'){
                    CoveredParAC = '100';
                } 
                
                else if(CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) == 0){
                    CoveredParAC = '0';
                    
                }
                else{
                    CoveredParAC = '';
                }
                
                //Story 605
                if(setSelectedItem == 'COMMERCIAL TRAVEL' && lstSolComp1[0].CampaignTravelPercentage__c!=null){
                   CoveredParAC =  lstSolComp1[0].CampaignTravelPercentage__c; 
                    
                }
                else if(setSelectedItem == 'TOWING' && lstSolComp1[0].CampaignTowingPercentage__c!=null){
                   CoveredParAC =  lstSolComp1[0].CampaignTowingPercentage__c; 
                    
                }
                //Story 605 end
                
                system.debug('CoveredParAC>>>>'+CoveredParAC);
                
                for(claimablesWrapperClass  prtslist:listpartWrapper ){
                    system.debug('first for loop');
                    system.debug('***selectedpartid**'+SelectedPartID);
                    system.debug('***partlistcounting**'+prtslist.counting);
                    system.debug('***partlist**'+prtslist);
                    if(prtslist.counting == SelectedPartID){
                        prtslist.accountCode =  String.valueof(SelectedAccountCode);
                        if((prtslist.accountCode == null || prtslist.accountCode == 'Select One') && (prtslist.failCode == null || prtslist.failCode == 'Select One'))
                            prtslist.coveredPercent='';
                        else
                            prtslist.coveredPercent=CoveredParAC;                
                    }
                    else{
                        if(prtslist.Unitprice==0){
                            prtslist.Unitprice=null;
                        }
                    }
                    system.debug('CoveredParACfor1>>>>'+prtslist.coveredPercent);
                }
            } 
            else{
                for(claimablesWrapperClass  prtslist:listpartWrapper ){
                    system.debug('else first for loop');
                    system.debug('***selectedpartid**'+SelectedPartID);
                    system.debug('***partlistcounting**'+prtslist.counting);
                    system.debug('***partlist**'+prtslist);
                    if(prtslist.counting == SelectedPartID){
                        prtslist.accountCode =  String.valueof(SelectedAccountCode);
                        // prtslist.coveredPercent='0';
                        // system.debug('CoveredParACfor2>>>>'+prtslist.coveredPercent);
                        if(CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0 ){
                            CoveredParAC = '100';
                        } 
                        
                        else if(CoveredParAC!=null && CoveredParAC!='' && Integer.ValueOf(CoveredParAC) == 0){
                            CoveredParAC = '0';
                            
                        }
                        else{
                            CoveredParAC = '';
                        }
                        
                        prtslist.coveredPercent=CoveredParAC;
                    }
                    else{
                        if(prtslist.Unitprice==0){
                            prtslist.Unitprice=null;
                        }
                    }
                    system.debug('CoveredParACfor2>>>>'+CoveredParAC); 
                }
            }
            
        }
        else  {
            CoveredParAC='';            
            for(claimablesWrapperClass  prtslist:listpartWrapper ){
                system.debug('***partlist**'+prtslist);
                system.debug('last first for loop');
                system.debug('***selectedpartid**'+SelectedPartID);
                system.debug('***partlistcounting**'+prtslist.counting);
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.accountCode =  String.valueof(SelectedAccountCode);
                    prtslist.coveredPercent='';
                    system.debug('coveredPercentlastfor-->'+prtslist.coveredPercent);
                }
                else{
                    if(prtslist.Unitprice==0){
                        prtslist.Unitprice=null;
                    }
                }
            }          
        }
        populateAmountValue();
    }
   /* Have commented below method as per story GSSC-142 and Create a new mthod below covered with commented method functionality,-By RAJESH 22nd Oct 2019 
    public List<SelectOption> getfailcodeDropDown(){    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        failAccountCodeMap = new  Map<String, Set<String>>();
        //solsComp= [SELECT Id, FailCode_Formula__c,Fail_Code_Editable__c,Fail_code__c,Type__c,SysCodeAndCompCode__c,CSS_Account_Formula__c,Selected_Component__c,CoveredOCAmount__c,CampaignOCPercentage__c from CSS_Solution_Component__c where CSS_Claims__c =:cId and FailCode_Formula__c!=null  and Selected_Component__c= true];
        solsComp.addAll(solsCompFailCodeVal);
        options.add(new SelectOption('Select One','Select One'));
        system.debug('solsCompsize****'+solsComp.size()+'****Test+solsComp'+solsComp);
        if(solsComp.size()>0){
            Set<string> acCodeSet;
            for(CSS_Solution_Component__c f:solsComp)  {
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
                if(f.FailCode_Formula__c!='Select One' && f.FailCode_Formula__c!=null && f.SysCodeAndCompCode__c !='Select One'){
                    if((f.CoveredOCAmount__c != null && Integer.valueOf(f.CoveredOCAmount__c) > 0 && (coverageType != 'OTH' && coverageType != 'POL')) ||
                       (f.CampaignOCPercentage__c != null && Integer.valueOf(f.CampaignOCPercentage__c) > 0 && (f.Type__c == 'TRP' || f.Type__c =='ATC' || f.Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))){
                           sortableSet.add(f.FailCode_Formula__c);
                           if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                               system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                               acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                               if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                   acCodeSet.add(f.CSS_Account_Formula__c);
                               }
                               system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                               failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                           }
                           else{
                               system.debug('**insidecontainkey---else');
                               acCodeSet = new Set<string>();
                               if(f.CSS_Account_Formula__c != null){
                                   system.debug('coverageType***'+coverageType);
                                   acCodeSet.add(f.CSS_Account_Formula__c);
                               }
                               system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                               failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                           }
                       }
                    else{
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            sortableSet.add(f.FailCode_Formula__c);
                            if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                                system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                                acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                                if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                                failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                            }
                            else{
                                system.debug('**insidecontainkey---else');
                                acCodeSet = new Set<string>();
                                if(f.CSS_Account_Formula__c != null){
                                    system.debug('coverageType***'+coverageType);
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                                failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                            }
                        }
                    }
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
                //String[] tempStr;
                //if(s !='Select One'){
                //tempStr = s.split('-');
                //system.debug('***str***'+tempStr[1]);
                options.add(new selectOption(s,s));   
                // }
            }   
        }
        system.debug('options****' +  options);
        return options;    
    }
    //END
    
    */
    
    
    //New Method for getting Failcode and Account codes as per story GSSC-142 -By RAJESH 22nd Oct 2019 
        public List<SelectOption> getfailcodeDropDownBasedOnItem(string selectedItem, Integer selectedPartId){    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        failAccountCodeMap = new  Map<String, Set<String>>();
        solsComp.addAll(solsCompFailCodeVal);
        options.add(new SelectOption('Select One','Select One'));
        if(selectedItem != 'COMMERCIAL TRAVEL' && selectedItem != 'TOWING'){
        if(solsComp.size()>0){
            Set<string> acCodeSet;
            for(CSS_Solution_Component__c f:solsComp)  {
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
                if(f.FailCode_Formula__c!='Select One' && f.FailCode_Formula__c!=null && f.SysCodeAndCompCode__c !='Select One'){
                    if((f.CoveredOCAmount__c != null && Integer.valueOf(f.CoveredOCAmount__c) > 0 && (coverageType != 'OTH' && coverageType != 'POL')) ||
                       (f.CampaignOCPercentage__c != null && Integer.valueOf(f.CampaignOCPercentage__c) > 0 && (f.Type__c == 'TRP' || f.Type__c =='ATC' || f.Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))){
                           sortableSet.add(f.FailCode_Formula__c);
                           if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                               acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                               if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                   acCodeSet.add(f.CSS_Account_Formula__c);
                               }
                               failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                           }
                           else{
                               system.debug('**insidecontainkey---else');
                               acCodeSet = new Set<string>();
                               if(f.CSS_Account_Formula__c != null){
                                   acCodeSet.add(f.CSS_Account_Formula__c);
                               }
                               failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                           }
                       }
                    else{
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            sortableSet.add(f.FailCode_Formula__c);
                            if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                                system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                                acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                                if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                                failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                            }
                            else{
                                system.debug('**insidecontainkey---else');
                                acCodeSet = new Set<string>();
                                if(f.CSS_Account_Formula__c != null){
                                    system.debug('coverageType***'+coverageType);
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                                failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                            }
                        }
                    }
                }
                system.debug('sortableSet  ' +  sortableSet);
                system.debug('failAccountCodeMap***' +  failAccountCodeMap);
            }
        }
        }
        else{
            if(solsComp != null && solsComp.size()>0){
                    Set<string> acCodeSet;
                    for(CSS_Solution_Component__c solComRec:solsComp){ //Added solComRec.Over_The_Counter__c != true in below condition as part of the story GSSC-298
                        if(solComRec.Selected_Component__c==true && solComRec.Over_The_Counter__c != true){
                            if(solComRec.Type__c==null || solComRec.Type__c==''){
                                system.debug('**inside main if**');
                                   if(solComRec.CSS_CoverageType__c!='OTH' && solComRec.CSS_CoverageType__c!='POL'){
                                        if(selectedItem =='COMMERCIAL TRAVEL'){
                                        system.debug('**inside main if for Commer**');
                                            if(solComRec.CoveredTravelBaseFareAmt__c!= null && double.valueof(solComRec.CoveredTravelBaseFareAmt__c)>0 && solComRec.CoveredTravelLabor__c!=null &&  double.valueof(solComRec.CoveredTravelLabor__c)>0){
                                                system.debug('**inside main RAJESH**');
                                                sortableSet.add(solComRec.FailCode_Formula__c);
                                                 if(failAccountCodeMap.containsKey(solComRec.SysCodeAndCompCode__c)){
                                                       system.debug('**insidecontainkey**'+solComRec.CSS_Account_Formula__c);
                                                       acCodeSet = failAccountCodeMap.get(solComRec.SysCodeAndCompCode__c);
                                                       if(solComRec.CSS_Account_Formula__c != null && solComRec.CSS_Account_Formula__c !='Select One' && solComRec.CSS_Account_Formula__c !=''){
                                                           acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                       }
                                                       system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                       failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                   }
                                                   else{
                                                       system.debug('**insidecontainkey---else');
                                                       acCodeSet = new Set<string>();
                                                       if(solComRec.CSS_Account_Formula__c != null){
                                                           system.debug('coverageType***'+coverageType);
                                                           acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                       }
                                                       system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                       failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                   }
                                             }
                                        }
                                        system.debug('inside method SelectedItem***'+SelectedItem);
                                        if(selectedItem =='TOWING'){
                                             system.debug('**inside main if for Towing**');
                                             if(solComRec.CoveredTowingMiles__c != null && double.valueof(solComRec.CoveredTowingMiles__c)>0){
                                                 system.debug('**Towing**');
                                                 sortableSet.add(solComRec.FailCode_Formula__c);
                                                 if(failAccountCodeMap.containsKey(solComRec.SysCodeAndCompCode__c)){
                                                       system.debug('**insidecontainkey**'+solComRec.CSS_Account_Formula__c);
                                                       acCodeSet = failAccountCodeMap.get(solComRec.SysCodeAndCompCode__c);
                                                       if(solComRec.CSS_Account_Formula__c != null && solComRec.CSS_Account_Formula__c !='Select One' && solComRec.CSS_Account_Formula__c !=''){
                                                           acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                       }
                                                       system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                       failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                   }
                                                   else{
                                                       system.debug('**insidecontainkey---else');
                                                       acCodeSet = new Set<string>();
                                                       if(solComRec.CSS_Account_Formula__c != null){
                                                           system.debug('coverageType***'+coverageType);
                                                           acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                       }
                                                       system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                       failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                   }
                                             }
                                         }
                                    }
                                    else{
                                // if(coverageType == 'OTH' || coverageType == 'POL'){
                                    sortableSet.add(solComRec.FailCode_Formula__c);
                                    if(failAccountCodeMap.containsKey(solComRec.SysCodeAndCompCode__c)){
                                        system.debug('**insidecontainkey**'+solComRec.CSS_Account_Formula__c);
                                        acCodeSet = failAccountCodeMap.get(solComRec.SysCodeAndCompCode__c);
                                        if(solComRec.CSS_Account_Formula__c != null && solComRec.CSS_Account_Formula__c !='Select One' && solComRec.CSS_Account_Formula__c !=''){
                                            acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                        }
                                        system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                        failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                    }
                                    else{
                                        system.debug('**insidecontainkey---else');
                                        acCodeSet = new Set<string>();
                                        if(solComRec.CSS_Account_Formula__c != null){
                                            system.debug('coverageType***'+coverageType);
                                            acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                        }
                                        system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                        failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                    }
                              //}
                            }
                            }
                            else{
                                system.debug('*MY main else***');
                                if(solComRec.CSS_CoverageType__c!='OTH' && solComRec.CSS_CoverageType__c!='POL'){
                                     if(selectedItem == 'COMMERCIAL TRAVEL'){
                                          if(solComRec.CampaignTravelPercentage__c != null && double.valueof(solComRec.CampaignTravelPercentage__c)>0){
                                              sortableSet.add(solComRec.FailCode_Formula__c);
                                              if(failAccountCodeMap.containsKey(solComRec.SysCodeAndCompCode__c)){
                                                           system.debug('**insidecontainkey**'+solComRec.CSS_Account_Formula__c);
                                                           acCodeSet = failAccountCodeMap.get(solComRec.SysCodeAndCompCode__c);
                                                           if(solComRec.CSS_Account_Formula__c != null && solComRec.CSS_Account_Formula__c !='Select One' && solComRec.CSS_Account_Formula__c !=''){
                                                               acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                           }
                                                           system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                           failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                       }
                                                       else{
                                                           system.debug('**insidecontainkey---else');
                                                           acCodeSet = new Set<string>();
                                                           if(solComRec.CSS_Account_Formula__c != null){
                                                               system.debug('coverageType***'+coverageType);
                                                               acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                           }
                                                           system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                           failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                       }
                                          }
                                     }
                                     if(SelectedItem == 'TOWING'){
                                         system.debug('**inside main RAJESH**');
                                         if(solComRec.CampaignTravelPercentage__c != null && double.valueof(solComRec.CampaignTowingPercentage__c)>0){
                                             system.debug('**inside main RAJESH**');
                                             sortableSet.add(solComRec.FailCode_Formula__c);
                                             if(failAccountCodeMap.containsKey(solComRec.SysCodeAndCompCode__c)){
                                                           system.debug('**insidecontainkey**'+solComRec.CSS_Account_Formula__c);
                                                           acCodeSet = failAccountCodeMap.get(solComRec.SysCodeAndCompCode__c);
                                                           if(solComRec.CSS_Account_Formula__c != null && solComRec.CSS_Account_Formula__c !='Select One' && solComRec.CSS_Account_Formula__c !=''){
                                                               acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                           }
                                                           system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                           failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                       }
                                                       else{
                                                           system.debug('**insidecontainkey---else');
                                                           acCodeSet = new Set<string>();
                                                           if(solComRec.CSS_Account_Formula__c != null){
                                                               system.debug('coverageType***'+coverageType);
                                                               acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                                           }
                                                           system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                                           failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                                       }
                                             system.debug('**inside main RAJESH**'+options);
                                         }
                                         
                                     }
                                }
                                else{
                                    // if(coverageType == 'OTH' || coverageType == 'POL'){
                                        sortableSet.add(solComRec.FailCode_Formula__c);
                                        if(failAccountCodeMap.containsKey(solComRec.SysCodeAndCompCode__c)){
                                            system.debug('**insidecontainkey**'+solComRec.CSS_Account_Formula__c);
                                            acCodeSet = failAccountCodeMap.get(solComRec.SysCodeAndCompCode__c);
                                            if(solComRec.CSS_Account_Formula__c != null && solComRec.CSS_Account_Formula__c !='Select One' && solComRec.CSS_Account_Formula__c !=''){
                                                acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                            }
                                            system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                            failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                        }
                                        else{
                                            system.debug('**insidecontainkey---else');
                                            acCodeSet = new Set<string>();
                                            if(solComRec.CSS_Account_Formula__c != null){
                                                system.debug('coverageType***'+coverageType);
                                                acCodeSet.add(solComRec.CSS_Account_Formula__c);
                                            }
                                            system.debug('**acCodeSet*'+solComRec.SysCodeAndCompCode__c+'***'+acCodeSet);
                                            failAccountCodeMap.put(solComRec.SysCodeAndCompCode__c, acCodeSet);
                                        }
                                  //}
                                }
                            }
                        }
                    }
           }
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {  
                options.add(new selectOption(s,s)); 
            }   
        }
        if(SelectedPartID!=null){
        for(claimablesWrapperClass  prtslist:listpartWrapper ){
            if(prtslist.counting == SelectedPartID)
            {
                prtslist.lstFailcodes = options;
             }
       }
        }
       system.debug('***Final options****' +  options);
        return options;    
    }
    //END
    
    
    
    
    //Old account code drop down method
    /*public List<SelectOption> getAccountCodeDropDown() {
Set<string> sortableSet = new  Set<string>();
List<string> sortable = new  List<string>();
system.debug('Inside method');
system.debug('failAccountCodeMap****'+failAccountCodeMap);
try{
lstAccountCodes = new list<String>();
system.debug('userinfo.getUserId()88888'+userinfo.getUserId());
string orgtype=css_utility.getOrgType(userinfo.getUserId());
system.debug('****orgtype***'+orgtype);
system.debug('****Cidacc***'+Cid);
claimsObj=[Select Id,Name,Customer_Name__c,CSS_Job__c,Shop_Work_Order__c,
Service_Model__c, Customer_Code__c,Status__c, Location__c,ESN__c 
from CSS_Claims__c where id= :Cid];
system.debug('****ClaimsObjacc***'+claimsObj);
//List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:Cid and Type__c NOT IN ('TRP','ATC','Campaign')];
List<CSS_Solution_Component__c> SolCmps = new List<CSS_Solution_Component__c> ();
SolCmps = [SELECT  Id, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c,Selected_Component__c,Type__c,CoveredOCAmount__c,CampaignOCPercentage__c from CSS_Solution_Component__c where CSS_Claims__c =:Cid];
system.debug('****Location__c***'+claimsObj.Location__c);
Account Regionterritory = css_utility.getRegionTerritory(claimsObj.Location__c);

User usr;
usr = css_utility.getUserAttributes(userinfo.getUserId());
string userRole = usr.UserRoleName__c;

system.debug('orgtype--->'+orgtype);
//system.debug('Regionterritory--->'+Regionterritory.Region__c);
system.debug('userRole--->'+userRole);

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
if(Regionterritory!= null && Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
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
if(JETFA != null){
for(CSS_JobEventTemporary__c jobEntObj : JETFA){
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
if(solcmp.CSS_Account_Formula__c !='Select One' && solcmp.CoveredOCAmount__c != null && Integer.valueOf(solcmp.CoveredOCAmount__c) >0 && solcmp.Selected_Component__c== true  && (coverageType != 'OTH' && coverageType != 'POL'))
sortableSet.add(solcmp.CSS_Account_Formula__c);
else if(solcmp.CSS_Account_Formula__c !='Select One' && solcmp.CampaignOCPercentage__c != null && Integer.valueOf(solcmp.CampaignOCPercentage__c) >0 && (solcmp.Type__c == 'TRP'|| solcmp.Type__c =='ATC'||solcmp.Type__c =='Campaign')  && (coverageType != 'OTH' && coverageType != 'POL'))
sortableSet.add(solcmp.CSS_Account_Formula__c);
}

}
//if(solcmp.CSS_Account_Formula__c !=null)
// sortableSet.add(solcmp.CSS_Account_Formula__c);
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
            system.debug('failAccountCodeMapsize****'+failAccountCodeMap.size());
            system.debug('failAccountCodeMap****'+failAccountCodeMap);
            system.debug('selectedFailCode****'+selectedFailCode);
            
            String failCode1;
            String[] tempStr;
            if(selectedFailCode.contains('-')){
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
            }
            options =  new List<SelectOption>();
            system.debug('failCode1****'+failCode1);
            system.debug('selectedFailCodecontains****'+failAccountCodeMap.containsKey(failCode1));
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
    
    public void saveOtherClaimables(){
        
    }
    
    public void getOCData(){        
        //The below condition is written as because TTML Data has to be shown where there is a service job else not.
        if(cId != null) {
            css_utility utility = new css_utility();
            Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
            list<CSS_Parts_Options__c> POListClaims = new list<CSS_Parts_Options__c>();
            ttmlPartsList = new list<CSS_Parts_Options__c>();
            otherClaimPartList = new list<CSS_Parts_Options__c>();
            POListClaims = [select Id,Service_Job__c, CSS_Claims__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, RecordType.Name,isManual__c,FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                             Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Unit_Price__c, RecordTypeId,Sell_Price__c
                             from CSS_Parts_Options__c where  CSS_Claims__c=:cId and (RecordType.Name ='TTML' OR RecordType.Name ='OtherClaimables')];
            
            mapPartsList = utility.displayParts(POListClaims);
            system.debug('mapPartsList--'+mapPartsList);
            
            for(CSS_Parts_Options__c  PO : POListClaims) {
                //GSSC-138 start
                if(mapPartsList != null){
                    Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                    mapTemp = mapPartsList.get(PO.Id);
                    
                    if(mapTemp != null){
                        for(decimal up : mapTemp.keyset()){
                            PO.Unit_Price__c = string.valueof(up);
                            PO.ExpenseTotal__c = mapTemp.get(up);
                        }
                    }
                }
                //GSSC-138 end
                if(PO.RecordType.Name == 'TTML')
                    ttmlPartsList.add(PO);
                if(PO.RecordType.Name == 'OtherClaimables') 
                    otherClaimPartList.add(PO);
            }
            
            /*
            otherClaimPartList = [select Id,ExpenseTotal__c,isManual__c ,selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                                  Account_Code__c, Notes__c,Unit_Price__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and RecordType.Name ='OtherClaimables'];
            
            ttmlPartsList = [select Id, isManual__c,FailurepartId__r.CoveredOCAmount__c, selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                             Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c, Technician__c, Type__c, Days__c,Unit_Price__c
                             from CSS_Parts_Options__c where  CSS_Claims__c=:cId and RecordType.Name ='TTML'];
          
            */ 
            System.debug('Test TTMLPartList  value >> '+ttmlPartsList.size()+ttmlPartsList);
            System.debug('Test otherClaimPartList  value >> '+otherClaimPartList);         
            //getallCustomPartsData(false);
            //saveExpenseTotal();
        }
    }
    
    public List<SelectOption> getTechnicians(){   
        
        List<SelectOption> lstTechnicians =  new List<SelectOption>(); 
        
        List<String> technicianList = new List<String>();
        Set<String> technicianSet = new Set<String>();
        CSS_Claims__c claimHeader = new CSS_Claims__c();
        //List<User> u = new List<User>();
        if(claimsRec.css_job__c!=null){ 
            claimHeader= [SELECT Id, Assigned_to__c, Assigned_to__r.FirstName, Assigned_to__r.LastName,
                          Additional_Tech1__c, Additional_Tech1__r.FirstName, Additional_Tech1__r.LastName, 
                          Additional_Tech2__c, Additional_Tech2__r.FirstName, Additional_Tech2__r.LastName,
                          Additional_Tech3__c, Additional_Tech3__r.FirstName, Additional_Tech3__r.LastName,
                          Additional_Tech4__c, Additional_Tech4__r.FirstName, Additional_Tech4__r.LastName,
                          Additional_Tech5__c, Additional_Tech5__r.FirstName, Additional_Tech5__r.LastName,
                          Additional_Tech6__c, Additional_Tech6__r.FirstName, Additional_Tech6__r.LastName,
                          Additional_Tech7__c, Additional_Tech7__r.FirstName, Additional_Tech7__r.LastName,
                          Additional_Tech8__c, Additional_Tech8__r.FirstName, Additional_Tech8__r.LastName,
                          Additional_Tech9__c, Additional_Tech9__r.FirstName, Additional_Tech9__r.LastName, 
                          CreatedBy.Name, CreatedBy.FirstName, CreatedBy.LastName
                          FROM CSS_Claims__c WHERE Id =: Wid];
            
            
            lstTechnicians.add(new SelectOption('Select One','Select One'));
            if(claimHeader != null){
                if(claimHeader.Additional_Tech1__c != null)
                    technicianList.add(claimHeader.Additional_Tech1__r.LastName+'--'+claimHeader.Additional_Tech1__r.FirstName);
                if(claimHeader.Additional_Tech2__c != null)
                    technicianList.add(claimHeader.Additional_Tech2__r.LastName+'--'+claimHeader.Additional_Tech2__r.FirstName);
                if(claimHeader.Additional_Tech3__c != null)
                    technicianList.add(claimHeader.Additional_Tech3__r.LastName+'--'+claimHeader.Additional_Tech3__r.FirstName);
                if(claimHeader.Additional_Tech4__c != null)
                    technicianList.add(claimHeader.Additional_Tech4__r.LastName+'--'+claimHeader.Additional_Tech4__r.FirstName);
                if(claimHeader.Additional_Tech5__c != null)
                    technicianList.add(claimHeader.Additional_Tech5__r.LastName+'--'+claimHeader.Additional_Tech5__r.FirstName);
                if(claimHeader.Additional_Tech6__c != null)
                    technicianList.add(claimHeader.Additional_Tech6__r.LastName+'--'+claimHeader.Additional_Tech6__r.FirstName);
                if(claimHeader.Additional_Tech7__c != null)
                    technicianList.add(claimHeader.Additional_Tech7__r.LastName+'--'+claimHeader.Additional_Tech7__r.FirstName);
                if(claimHeader.Additional_Tech8__c != null)
                    technicianList.add(claimHeader.Additional_Tech8__r.LastName+'--'+claimHeader.Additional_Tech8__r.FirstName);
                if(claimHeader.Additional_Tech9__c != null)
                    technicianList.add(claimHeader.Additional_Tech9__r.LastName+'--'+claimHeader.Additional_Tech9__r.FirstName);
                if(claimHeader.Assigned_to__c != null)
                    technicianList.add(claimHeader.Assigned_to__r.LastName+'--'+claimHeader.Assigned_to__r.FirstName);
                technicianList.add(claimHeader.CreatedBy.LastName+'--'+claimHeader.CreatedBy.FirstName);
            } 
        }
        else
            //if(claimsRec.id!=null && claimsRec.id!='')
        {
            system.debug('entered into manual claim tech users');
            //U = [SELECT Id, Name,User_Location__c,LastName,FirstName, Profile.Name,IsActive  FROM User where Profile.Name Like '%Technician%' AND User_Location__c=:claimsRec.Location_Code__c AND IsActive=true];
            List <CSS_UserLocation__c> U = [Select id,Name,UserId__r.Name,UserId__r.lastname,UserId__r.firstname,Location_code__c,Location_Name__c FROM CSS_UserLocation__c WHERE Location_code__c=:claimsRec.Location_Code__c and IsActive__c =true and Location_Name__c!=null and Location_Source__c != 'ARF' order by UserId__r.lastname asc]; 
            system.debug('usernames'+U);
            // U = [SELECT Id, Name,User_Location__c,LastName,FirstName, Profile.Name  FROM User where Profile.Name Like '%Technician%' ];
            lstTechnicians.add(new SelectOption('Select One','Select One'));
            if(U!=null && U.size()>0)
                for(CSS_UserLocation__c u1:U){
                    technicianList.add(u1.UserId__r.lastname+'--'+u1.UserId__r.firstname);
                }
            system.debug('claim tech list'+technicianList);
            
            
        }
        technicianList.sort();
        if(technicianList.size() > 0) {
            for(String techLst : technicianList)    
            {    
                if(!technicianSet.Contains(techLst))
                    technicianSet.add(techLst);                    
            }
            if(technicianSet.size() > 0) {
                for(String techSet : technicianSet)    
                {    
                    String[] temp = techSet.split('--');
                    String techLstOption = temp[1] + ' ' + temp[0];
                    lstTechnicians.add(new selectOption(techLstOption,techLstOption));                    
                }
            }
        }
        //else
        //lstTechnicians.add(new selectOption(jobOrder.CreatedBy.Name,jobOrder.CreatedBy.Name));
        // lstTechnicians.add(new SelectOption('Select One','Select One'));
        system.debug('***lstTechnicians***'+lstTechnicians);    
        return lstTechnicians;
    }
    
    //Method to get TTML Types
    public List<SelectOption> getTTMLType(){
        List<SelectOption> typeList = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =  CSS_Parts_Options__c.Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
            typeList.add(new SelectOption(f.getValue(),f.getLabel()));
        }       
        return typeList;
    }
    //Start code   as per story #148925 ,By RAJESH 09th Jan 2019-->      
    public boolean isMealsExpenseTotalError {get;set;}
    public boolean isLodgingExpenseTotalError {get;set;}
    public boolean isTowingExpenseTotalError {get;set;}
    //End code   as per story #148925 ,By RAJESH 09th Jan 2019-->  
    //New Method for getting Expense Total value as per "I Survived" sprint story #152963,-By RAJESH 27rd July 2018
    public void getExpenseTotal(){
        isTowingExpenseTotalError = false;
        isLodgingExpenseTotalError = false;
        isMealsExpenseTotalError = false;
        system.debug('** inside getExpenseTotal**');
        CSS_Claims__c claimRec = new CSS_Claims__c();
        set<string> setbol = new set<string>();
        css_header_nav__c rswBotton =css_header_nav__c.getInstance(UserInfo.getUserId());
        Boolean DealerUser=rswBotton.RSWButtonEnable__c;
        system.debug('******Dealer User in get Expense ******'+DealerUser);
        claimRec =[SELECT Id, CSS_Job__c,CSS_Travel_Rate__c, SP_INSHOP_LABOR_RATE__c FROM CSS_Claims__c where Id=:cId];
        system.debug('** claimRec.CSS_Travel_Rate__c**'+claimRec.CSS_Travel_Rate__c);
        system.debug('** claimRec.SP_INSHOP_LABOR_RATE__c**'+claimRec.SP_INSHOP_LABOR_RATE__c);
        system.debug('** claimRec.SP_INSHOP_LABOR_RATE__c**'+isTowingExpenseTotalError);
        Boolean checkExpTotal = false;
        for(ttmlWrapperClass  prtslist : listTTMLWrapper){
            if((prtslist.type == 'Meals' || prtslist.type == 'Lodging' || prtslist.type == 'Towing')) {
                if(prtslist.quantity != null && prtslist.quantity != '' && prtslist.unitPrice != null && prtslist.unitPrice != ''){
                    prtslist.expenseTotal=String.valueOf(Decimal.valueOf(prtslist.quantity)*Decimal.valueOf(prtslist.unitPrice));
                    if(Decimal.valueOf(prtslist.expenseTotal) > 99999.99) {
                        if(prtslist.type == 'Meals' && !isMealsExpenseTotalError) {
                            isMealsExpenseTotalError = true;
                        }
                        
                        if(prtslist.type == 'Lodging' && !isLodgingExpenseTotalError) {
                            isLodgingExpenseTotalError = true;
                        }
                        
                        if(prtslist.type == 'Towing' && !isTowingExpenseTotalError) {
                            isTowingExpenseTotalError = true;
                        }
                    }
                    
                    
                } else {
                    prtslist.expenseTotal = '';
                }
                
            }
            if(prtslist.counting == SelectedPartID){
                if(isMealsExpenseTotalError && prtslist.type == 'Meals'){
                    prtslist.isExpenseTotal=true;
                }
                else if(isLodgingExpenseTotalError && prtslist.type == 'Lodging'){
                    prtslist.isExpenseTotal=true;
                }
                else if(isTowingExpenseTotalError && prtslist.type == 'Towing'){
                    prtslist.isExpenseTotal=true;
                }
                else
                    prtslist.isExpenseTotal=false;
                
                if(prtslist.type != '' && prtslist.type != null){
                    if((prtslist.type == 'Meals' || prtslist.type == 'Lodging' || prtslist.type == 'Towing') && (prtslist.counting == SelectedPartID)){
                        system.debug('**prtslist.quantity**'+prtslist.quantity);
                        system.debug('**prtslist.unitPrice**'+prtslist.unitPrice);
                        if(prtslist.quantity != null && prtslist.quantity != '' && prtslist.unitPrice != null && prtslist.unitPrice != ''){
                            system.debug('** inside prtslist.unitPrice**'); 
                            prtslist.expenseTotal=String.valueOf(Decimal.valueOf(prtslist.quantity)*Decimal.valueOf(prtslist.unitPrice));
                        }
                        // else{
                        //     prtslist.expenseTotal = '';
                        // }
                    }
                    else if(prtslist.type == 'Commercial-Travel'){
                        //Added code if and else part as per defect #175168 for getting expense total based type like Commercial-Travel,-By RAJESH 02nd Jan 2019                     
                        if(DealerTypeFlag== true){ 
                            if(prtslist.unitPrice != null && prtslist.unitPrice != '' && prtslist.hoursTraveled != null && prtslist.hoursTraveled != '' && prtslist.hoursTraveled != '.' && claimRec.SP_INSHOP_LABOR_RATE__c!='' && claimRec.SP_INSHOP_LABOR_RATE__c!=null){
                                prtslist.expenseTotal = String.valueOf(Decimal.valueOf(prtslist.unitPrice)+(Decimal.valueOf(prtslist.hoursTraveled)*0.4*Decimal.valueOf(claimRec.SP_INSHOP_LABOR_RATE__c))); 
                                if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                    prtslist.isExpenseTotal = true;
                                    setbol.add('true');
                                }if(Decimal.valueOf(prtslist.expenseTotal) < 10000 ){
                                    prtslist.isExpenseTotal = false;
                                    setbol.add('false');
                                }
                            }
                        }
                        if(DealerTypeFlag != true){
                            system.debug('** NOt a Dealer Account prtslist.quantity**');
                            system.debug('** in commertial claimsRec.CSS_Job__c**'+claimsRec.CSS_Job__c);
                            //Added code for if and else part for getting expense total based on job for Distributor user,-By RAJESH 02nd Jan 2019                            
                            if(claimsRec.CSS_Job__c != null){
                                if(DealerUser==true){
                                    if(prtslist.unitPrice != null && prtslist.unitPrice != '' && prtslist.hoursTraveled != null && prtslist.hoursTraveled != '' && prtslist.hoursTraveled != '.' && claimRec.SP_INSHOP_LABOR_RATE__c!='' && claimRec.SP_INSHOP_LABOR_RATE__c!=null){
                                        //system.debug('** inside if prtslist.hoursTraveled**');
                                        prtslist.expenseTotal = String.valueOf(Decimal.valueOf(prtslist.unitPrice)+(Decimal.valueOf(prtslist.hoursTraveled)*0.4*Decimal.valueOf(claimRec.SP_INSHOP_LABOR_RATE__c))); 
                                        if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                            prtslist.isExpenseTotal = true;
                                            //checkExpTotal = true;
                                            //isExpenseTotalError = true;
                                            setbol.add('true');
                                            //system.debug('isExpenseTotalError'+prtslist.isExpenseTotal);
                                            
                                        }if(Decimal.valueOf(prtslist.expenseTotal) < 10000 ){
                                            prtslist.isExpenseTotal = false;
                                            setbol.add('false');
                                            //isExpenseTotalError = false;
                                            //system.debug('isExpenseTotalError1'+prtslist.isExpenseTotal);
                                        }
                                    }
                                }
                                else{
                                    if(prtslist.quantity != null && prtslist.quantity != '' && prtslist.unitPrice != null && prtslist.unitPrice != ''){
                                        //system.debug('** inside prtslist.unitPrice**'); 
                                        prtslist.expenseTotal=String.valueOf(Decimal.valueOf(prtslist.quantity)*Decimal.valueOf(prtslist.unitPrice));
                                        if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                            prtslist.isExpenseTotal = true;
                                            //checkExpTotal = true;
                                            //isExpenseTotalError = true;
                                            setbol.add('true');
                                            //system.debug('isExpenseTotalError'+prtslist.isExpenseTotal);
                                            
                                        }
                                        if(Decimal.valueOf(prtslist.expenseTotal) < 10000 ){
                                            prtslist.isExpenseTotal = false;
                                            setbol.add('false');
                                            //isExpenseTotalError = false;
                                            //system.debug('isExpenseTotalError1'+prtslist.isExpenseTotal);
                                        }
                                    }
                                }
                            }
                            else{
                                if(prtslist.unitPrice != null && prtslist.unitPrice != '' && prtslist.hoursTraveled != null && prtslist.hoursTraveled != '' && prtslist.hoursTraveled != '.' && claimRec.SP_INSHOP_LABOR_RATE__c!='' && claimRec.SP_INSHOP_LABOR_RATE__c!=null){
                                    // system.debug('** inside if prtslist.hoursTraveled**');
                                    prtslist.expenseTotal = String.valueOf(Decimal.valueOf(prtslist.unitPrice)+(Decimal.valueOf(prtslist.hoursTraveled)*0.4*Decimal.valueOf(claimRec.SP_INSHOP_LABOR_RATE__c))); 
                                    
                                    if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                        prtslist.isExpenseTotal = true;
                                        setbol.add('true');
                                    }
                                    if(Decimal.valueOf(prtslist.expenseTotal) < 10000 ){
                                        prtslist.isExpenseTotal = false;
                                        setbol.add('false');
                                    }
                                }
                            }
                            //End code for if and else part for getting expense total based on job for Distributor user,-By RAJESH 02nd Jan 2019
                        }
                        //End code if and else part as per defect #175168 for getting expense total based on type like Commercial-Travel,-By RAJESH 02nd Jan 2019
                    }
                    else{
                        system.debug('** inside else for Non Comm');
                        if(DealerTypeFlag==true){
                            if(prtslist.hoursTraveled != null && prtslist.mileage != null && prtslist.mileage != '' && prtslist.mileage != '.' && claimRec.CSS_Travel_Rate__c!=null && claimRec.CSS_Travel_Rate__c!='' && claimRec.SP_INSHOP_LABOR_RATE__c!=null && claimRec.SP_INSHOP_LABOR_RATE__c!=null ){
                                prtslist.expenseTotal = String.valueOf((Decimal.valueOf(prtslist.mileage)*Decimal.valueof(claimRec.CSS_Travel_Rate__c))+((prtslist.hoursTraveled == null || prtslist.hoursTraveled == '' || prtslist.hoursTraveled == '.')?0:Decimal.valueOf(prtslist.hoursTraveled)*Decimal.valueof(claimRec.SP_INSHOP_LABOR_RATE__c)));
                                
                                if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                    prtslist.isExpenseTotal = true;    
                                    setbol.add('true');
                                    system.debug('isExpenseTotalError'+prtslist.isExpenseTotal);
                                }
                                if(Decimal.valueOf(prtslist.expenseTotal) < 10000 ){
                                    prtslist.isExpenseTotal = false;  
                                    setbol.add('false');
                                    system.debug('isExpenseTotalError1'+prtslist.isExpenseTotal);
                                }
                            }
                        }
                        else if(DealerTypeFlag != true){
                            if(claimsRec.CSS_Job__c != null){
                                if(DealerUser==true){
                                    system.debug('***inside Distributor DealerUser****'+DealerUser);
                                    if(prtslist.hoursTraveled != null && prtslist.mileage != null && prtslist.mileage != '' && prtslist.mileage != '.' && claimRec.CSS_Travel_Rate__c!=null && claimRec.CSS_Travel_Rate__c!='' && claimRec.SP_INSHOP_LABOR_RATE__c!=null && claimRec.SP_INSHOP_LABOR_RATE__c!=null ){
                                        prtslist.expenseTotal = String.valueOf((Decimal.valueOf(prtslist.mileage)*Decimal.valueof(claimRec.CSS_Travel_Rate__c))+((prtslist.hoursTraveled == null || prtslist.hoursTraveled == '' || prtslist.hoursTraveled == '.')?0:Decimal.valueOf(prtslist.hoursTraveled)*Decimal.valueof(claimRec.SP_INSHOP_LABOR_RATE__c)));
                                        
                                        if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                            prtslist.isExpenseTotal = true;    
                                            setbol.add('true');
                                            system.debug('isExpenseTotalError'+prtslist.isExpenseTotal);
                                        }
                                        if(Decimal.valueOf(prtslist.expenseTotal) < 10000 ){
                                            prtslist.isExpenseTotal = false;  
                                            setbol.add('false');
                                            system.debug('isExpenseTotalError1'+prtslist.isExpenseTotal);
                                        }
                                    }
                                }
                                else{
                                    if(prtslist.quantity != null && prtslist.quantity != '' && prtslist.unitPrice != null && prtslist.unitPrice != ''){
                                        prtslist.expenseTotal=String.valueOf(Decimal.valueOf(prtslist.quantity)*Decimal.valueOf(prtslist.unitPrice));
                                        
                                        if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                            prtslist.isExpenseTotal = true;
                                            setbol.add('true');
                                            system.debug('isExpenseTotalError'+prtslist.isExpenseTotal);
                                        }
                                        if(Decimal.valueOf(prtslist.expenseTotal) < 10000 ){
                                            prtslist.isExpenseTotal = false;
                                            setbol.add('false');
                                            system.debug('isExpenseTotalError1'+prtslist.isExpenseTotal);
                                        }
                                    }
                                }    
                            }
                            else{
                                if(prtslist.hoursTraveled != null && prtslist.mileage != null && prtslist.mileage != '' && prtslist.mileage != '.' && claimRec.CSS_Travel_Rate__c!=null && claimRec.CSS_Travel_Rate__c!='' && claimRec.SP_INSHOP_LABOR_RATE__c!=null && claimRec.SP_INSHOP_LABOR_RATE__c!=null ){
                                    prtslist.expenseTotal = String.valueOf((Decimal.valueOf(prtslist.mileage)*Decimal.valueof(claimRec.CSS_Travel_Rate__c))+((prtslist.hoursTraveled == null || prtslist.hoursTraveled == '' || prtslist.hoursTraveled == '.')?0:Decimal.valueOf(prtslist.hoursTraveled)*Decimal.valueof(claimRec.SP_INSHOP_LABOR_RATE__c)));
                                    
                                    if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                        prtslist.isExpenseTotal = true;
                                        setbol.add('true');
                                        system.debug('isExpenseTotalError'+prtslist.isExpenseTotal);
                                    }
                                    if(Decimal.valueOf(prtslist.expenseTotal) > 10000 ){
                                        prtslist.isExpenseTotal = false;
                                        setbol.add('false');
                                        system.debug('isExpenseTotalError1'+prtslist.isExpenseTotal);
                                    }
                                }
                            }
                        }
                        else{
                            prtslist.expenseTotal = '';
                            prtslist.isExpenseTotal = false;
                            isExpenseTotalError = false;
                        }
                    }
                }
                 //GSSC-138 start
                system.debug('prtslist.UnitpriceActual--'+prtslist.UnitpriceActual);
                system.debug('prtslist.unitPrice--'+prtslist.unitPrice);
                if(prtslist.unitPrice != null && prtslist.unitPrice != '' && decimal.valueof(prtslist.unitPrice) != prtslist.UnitpriceActual){
                    prtslist.UnitpriceModified = decimal.valueof(prtslist.unitPrice);
                    if(prtslist.expenseTotal!=null && prtslist.expenseTotal!='')
                    prtslist.amountModified = decimal.valueof(prtslist.expenseTotal);
                }
                system.debug('UnitpriceModified--'+prtslist.UnitpriceModified);
                system.debug('amountModified--'+ prtslist.amountModified);
                //GSSC-138 end
            }
        }
        for(ttmlWrapperClass  prtslist : listTTMLWrapper){
            if(prtslist.type=='Commercial-Travel' || prtslist.type=='Non Commercial-Travel'){
                if(prtslist.expenseTotal!='' && prtslist.expenseTotal!=null && Decimal.valueof(prtslist.expenseTotal)>10000){
                    system.debug('****Another if Above 10000 inside if when type equals to Comm and Non-Comme***');
                    prtslist.isExpenseTotal=true;
                    setbol.add('true');
                }
            }
        }
        if(setbol.contains('true')){
            isExpenseTotalError = true;
        }
        else{
            isExpenseTotalError = false;
        }
    }
    //End
    
    public void typeListChange(){
        try{
            duplicateAccountCode=false;
            system.debug('SelectedPartID-->'+SelectedPartID);
            system.debug('**SelectedItem**-->'+SelectedItem);
            system.debug('SelectedType-->'+SelectedType);
            
            //showFailCode = false;
            list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
            lstSolComp = [SELECT  Id,Over_The_Counter__c, CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c from CSS_Solution_Component__c where CSS_Claims__c=:cId AND Selected_Component__c = true AND CSS_Account_Formula__c != null AND Over_The_Counter__c != true]; //Added "Over_The_Counter__c != true" as part of the story GSSC-298
            system.debug('lstSolComp-->'+lstSolComp); 
            //story 148912
            if(SelectedType != 'Towing'){
                hideAccCode=false;
                travelRateError=false;
                if((claimsRec.CSS_Travel_Rate__c != null && claimsRec.CSS_Travel_Rate__c != '' && Decimal.valueOf(claimsRec.CSS_Travel_Rate__c) == 0 ) || claimsRec.CSS_Travel_Rate__c == null || claimsRec.CSS_Travel_Rate__c == ''){
                    hideAccCode = true;
                    travelRateError = true;
                }
                else{
                    hideAccCode=false;
                    travelRateError = false;
                }
            }
            //story 148912
            for(ttmlWrapperClass  prtslist : listTTMLWrapper){
                if(prtslist.counting == SelectedPartID){
                    prtslist.days = '';
                    //Added quantity and Unit price as per "I Survived" sprint story #152963,-By RAJESH 24th July 2018                 
                    prtslist.quantity = '';
                    prtslist.unitPrice = '';
                    //End                  
                    prtslist.mileage = '';
                    prtslist.hoursTraveled = '';
                    prtslist.expenseTotal = '';
                    //prtslist.failCode = 'Select One';
                    prtslist.failCodelst = new List<SelectOption>();
                    List<SelectOption> fC = new List<SelectOption>();
                    prtslist.accountCode = '';
                    prtslist.accCoverage = false;
                    fC = fetchfailCodeValuesNew(SelectedType);
                    prtslist.failCodelst.addAll(fC);
                    if(SelectedType=='Select One'){
                        prtslist.accCodelst = new List<SelectOption>();
                        List<SelectOption> aC = new List<SelectOption>();
                        aC.add(new SelectOption('Select One','Select One'));
                        prtslist.accCodelst.addAll(aC);
                    }
                    
                    if(prtslist.type != '' && prtslist.type != null)
                    {
                        /* fC = getfailCodeValues(prtslist.type);
system.debug('Fail Codes--'+fc);
if(fc.size() > 1){        
prtslist.failCodelst.addAll(fC);
}
else{
prtslist.failCodelst.addAll(fC);
prtslist.accountCode = '';
}*/
                        //comminted below code as per "I Survived" sprint story #152963,-By RAJESH 24th July 2018                   
                        /*  if(prtslist.type == 'Meals' || prtslist.type == 'Lodging'){
prtslist.showDays = true;
prtslist.showMileageHT = false;
}                        
else if(prtslist.type == 'Commercial-Travel' || prtslist.type == 'Non Commercial-Travel'){
prtslist.showDays = false;
prtslist.showMileageHT = true;
}*/
                        //End          
                        //Added below code for getting enable and disable the fields basend on Type as per "I Survived" sprint story #152963,-By RAJESH 24th July 2018
                        //168028 Story Rupesh DEALER USER AUTOMATED CLAIM TTML POP UP
                        //if(claimsRec.css_job__c!=null) //Original Condition by Rajesh
                        
                        //**********************************************************//
                        //Extraction of the Custom Settings if this is a dealer....Rupesh
                        css_header_nav__c rswBotton =css_header_nav__c.getInstance(UserInfo.getUserId());
                        Boolean DealerUser=rswBotton.RSWButtonEnable__c;
                        system.debug('******Dealer User in type change ******'+DealerUser);
                        //**********************************************************//
                        system.debug('******claimsRec.Account__r.type******'+claimsRec.Account__r.type);
                        //if(  (claimsRec.css_job__c!=null) && (DealerUser=='true') )//If this is automated claim and Dealer User(Modified Condition)
                       // if( (claimsRec.css_job__c!=null) && (claimsRec.Account__r.type=='Dealer Account') )
                       
                                 
                       if( claimsRec.css_job__c!=null && DealerTypeFlag== true )
                       
                        {
                            system.debug('RUPESH STORY 168028 STARTING..');
                            if(prtslist.type == 'Commercial-Travel')
                            {
                                system.debug('****inside If DEALER USER AUTOMATED CLAIM****');
                                prtslist.showDays = false;
                                prtslist.showUp = true;
                                prtslist.showMileage = false;
                                prtslist.showMileageHT = true;
                                // prtslist.mandateMileage = true;
                            }
                            else if(prtslist.type == 'Non Commercial-Travel')
                            {   
                                system.debug('****inside else If for Non Comm DEALER USER AUTOMATED CLAIM****');
                                prtslist.showDays = false;
                                prtslist.showUp = false;
                                prtslist.showMileage = true;
                                prtslist.showMileageHT = true;
                                // prtslist.mandateMileage = true;
                            }
                            else if(prtslist.type == 'Meals' || prtslist.type == 'Lodging' || prtslist.type == 'Towing')
                            {
                                system.debug('****inside else If for MLT DEALER USER AUTOMATED CLAIM****');
                                prtslist.showDays = true;
                                prtslist.showUp = true;
                                prtslist.showMileage = false;
                                prtslist.showMileageHT = false;
                                // prtslist.mandateMileage = false;
                            }
                            else{
                                system.debug('****inside final else If DEALER USER AUTOMATED CLAIM****');
                                prtslist.showDays = false;
                                prtslist.showUp = false;
                                prtslist.showMileage = false;
                                prtslist.showMileageHT = false;
                                // prtslist.mandateMileage = false;
                            }
                        }
                        //Automated Claim and Distributor User
                        
                        
                        //if(claimsRec.css_job__c!=null) //AUTOMATED CLAIM..This was the original condition by Rajesh
                        //if( (claimsRec.css_job__c!=null) && (DealerUser='false')  )//If this is an automated claim but not a dealer User..New Condition
                        else if( claimsRec.css_job__c!=null && DealerTypeFlag != true) 
                        { 
                            system.debug('****inside If Main****');
                            if(DealerUser==true){
                                if(prtslist.type == 'Commercial-Travel')
                                {
                                    system.debug('****inside If DEALER USER AUTOMATED CLAIM****');
                                    prtslist.showDays = false;
                                    prtslist.showUp = true;
                                    prtslist.showMileage = false;
                                    prtslist.showMileageHT = true;
                                    // prtslist.mandateMileage = true;
                                }
                                else if(prtslist.type == 'Non Commercial-Travel')
                                {   
                                    system.debug('****inside else If for Non Comm DEALER USER AUTOMATED CLAIM****');
                                    prtslist.showDays = false;
                                    prtslist.showUp = false;
                                    prtslist.showMileage = true;
                                    prtslist.showMileageHT = true;
                                    // prtslist.mandateMileage = true;
                                }
                                else if(prtslist.type == 'Meals' || prtslist.type == 'Lodging' || prtslist.type == 'Towing')
                                {
                                    system.debug('****inside else If for MLT DEALER USER AUTOMATED CLAIM****');
                                    prtslist.showDays = true;
                                    prtslist.showUp = true;
                                    prtslist.showMileage = false;
                                    prtslist.showMileageHT = false;
                                    // prtslist.mandateMileage = false;
                                }
                                else{
                                    system.debug('****inside final else If DEALER USER AUTOMATED CLAIM****');
                                    prtslist.showDays = false;
                                    prtslist.showUp = false;
                                    prtslist.showMileage = false;
                                    prtslist.showMileageHT = false;
                                    // prtslist.mandateMileage = false;
                                } 
                            }
                            
                            else{
                                if(prtslist.type == 'Meals' || prtslist.type == 'Lodging' || prtslist.type == 'Commercial-Travel'|| prtslist.type == 'Non Commercial-Travel' || prtslist.type == 'Towing')
                                {
                                    system.debug('****inside If MLCT****');
                                    prtslist.showDays = true;
                                    prtslist.showUp = true;
                                    prtslist.showMileage = false;
                                    prtslist.showMileageHT = false;
                                    // prtslist.mandateMileage = false;
                                }
                                /* else if(prtslist.type == 'Non Commercial-Travel')
{
system.debug('****inside If Non****');
prtslist.showDays = false;
prtslist.showUp = true;
prtslist.showMileage = false;
prtslist.showMileageHT = true;
//prtslist.mandateMileage = true;

}*/
                                //End            
                                else
                                {
                                    //prtslist.technician = '';
                                    if(prtslist.type == 'Select One')
                                        prtslist.notes = '';
                                    prtslist.days = '';
                                    //Added quantity and Unit price as per "I Survived" sprint story #152963,-By RAJESH 24th July 2018                 
                                    prtslist.quantity = '';
                                    prtslist.unitPrice = '';
                                    prtslist.technician ='';
                                    //End                   
                                    prtslist.mileage = '';
                                    prtslist.hoursTraveled = '';
                                    prtslist.expenseTotal = '';                            
                                    prtslist.showDays = false;
                                    prtslist.showMileageHT = false;
                                }
                            }
                        }
                        //Manual Claim
                        else
                        {
                            system.debug('***For Manual Claims + prtslist.type**'+prtslist.type);
                            if( prtslist.type == 'Commercial-Travel' )
                            {
                                system.debug('***inside Comm+**'+prtslist.type);
                                //Quan-G,UP-E,Mile-G,Hourt=E
                                prtslist.showDays = false;   //Quantity greyed out
                                prtslist.showUP=true;
                                prtslist.showMileage = false;   //Mileage greyed out
                                prtslist.showMileageHT=true;  //HT editable
                                
                            }
                            else if(prtslist.type == 'Non Commercial-Travel')
                            {
                                system.debug('***inside Non+**'+prtslist.type);
                                prtslist.showDays = false;//Quantity greyed out
                                prtslist.showUP=false; //UP greyed out
                                prtslist.showMileage =true;     //Mileage editable
                                prtslist.showMileageHT=true;    //HT editable
                            }
                            else if((prtslist.type == 'Meals' || prtslist.type == 'Lodging' || prtslist.type == 'Towing') && (prtslist.counting == SelectedPartID))
                            {
                                system.debug('***inside MLT+**'+prtslist.type);
                                prtslist.showDays = true;
                                prtslist.showUp = true;
                                prtslist.showMileage = false;
                                prtslist.showMileageHT = false;
                                //prtslist.mandateMileage = false;
                            }
                            else{
                                system.debug('***inside else+**'+prtslist.type);
                                prtslist.showDays = false;
                                prtslist.showUp = false;
                                prtslist.showMileage = false;
                                prtslist.showMileageHT = false;
                                //prtslist.mandateMileage = false;
                            }
                            
                        }
                        
                        
                        
                    }
                    break;
                }  
            }   
            populateTTMLFailCodenAccountCode();
        }
        catch(Exception ex){
            System.debug('In catch of typelistchange: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());    
        }
    }
    
    public void populateTTMLFailCodenAccountCode(){
        system.debug('Anirudh listTTMLWrapper>>>>>>>>>>: '+listTTMLWrapper);
        String accCode;
        String failCode;
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        Map<String,List<CSS_Solution_Component__c>> solCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
        
        lstSolComp = [SELECT  Id,Over_The_Counter__c, Type__c,FailCode_Formula__c,CSS_Account_Formula__c,CampaignTravelPercentage__c,CampaignTowingPercentage__c,CoveredTravelLabor__c,CoveredTravelBaseFareAmt__c,CoveredTravelMiles__c,CoveredTowingMiles__c,CoveredMealsLodgingAmt__c,CSS_CoverageType__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where CSS_Claims__c=:CID AND Selected_Component__c= true AND CSS_Account_Formula__c!='' AND Over_The_Counter__c != true]; //Added "Over_The_Counter__c != true" as part of the story GSSC-298
        
        if(lstSolComp != null && lstSolComp.size() == 1){
            if(lstSolComp[0].CSS_CoverageType__c!= null && (lstSolComp[0].CSS_CoverageType__c == 'OTH' || lstSolComp[0].CSS_CoverageType__c == 'POL')){
                accCode =lstSolComp[0].CSS_Account_Formula__c; 
            }
            for(ttmlWrapperClass ttmlwr : listTTMLWrapper){
                if(ttmlwr.counting == SelectedPartID){
                    if(lstSolComp[0].Type__c == 'Campaign' || lstSolComp[0].Type__c == 'TRP' || lstSolComp[0].Type__c == 'ATC'){
                        if((ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Commercial-Travel')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Lodging'))){
                            if((lstSolComp[0].CampaignTravelPercentage__c!=null && double.valueof(lstSolComp[0].CampaignTravelPercentage__c)>0)){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            }
                        }
                        else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                            if(lstSolComp[0].CampaignTowingPercentage__c!=null && double.valueof(lstSolComp[0].CampaignTowingPercentage__c)>0){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            }
                        }
                        failCode=lstSolComp[0].FailCode_Formula__c;
                    }
                }
            }
        }
        if(lstSolComp != null && lstSolComp.size() > 0){
            List<CSS_Solution_Component__c> tempList;
            for(CSS_Solution_Component__c slcp : lstSolComp){
                String FARec;
                if(slcp.Type__c == 'Campaign' || slcp.Type__c == 'TRP' || slcp.Type__c == 'ATC')
                    FARec='FieldAction';
                else
                    FARec='Failure';
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
                    solCmpMap.put(FARec, tempList);
                }
            }
            
            tempList = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> tempListFA = new List<CSS_Solution_Component__c>();
            Map<String,List<CSS_Solution_Component__c>> accSolCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
            List<CSS_Solution_Component__c> accSlCmp;
            tempList = solCmpMap.get('Failure');
            tempListFA = solCmpMap.get('FieldAction');
            if(tempList!=null && tempList.size() >1){
                for(CSS_Solution_Component__c sc:tempList){
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
            for(ttmlWrapperClass ttmlwr : listTTMLWrapper){
                if(ttmlwr.counting == SelectedPartID){
                    system.debug('tempList****'+tempList);
                    //system.debug('tempListFA'+tempListFA.size());
                    //system.debug('tempList[0].CSS_CoverageType__c'+tempList[0].CSS_CoverageType__c);
                    if(tempListFA !=null && tempListFA.size() >=0 && tempList == null){
                        if(tempListFA[0].CSS_CoverageType__c!= null && (tempListFA[0].CSS_CoverageType__c == 'OTH' || tempListFA[0].CSS_CoverageType__c == 'POL')){
                            accCode =tempListFA[0].CSS_Account_Formula__c; 
                        }
                        if(tempListFA[0].Type__c == 'Campaign' || tempListFA[0].Type__c == 'TRP' || tempListFA[0].Type__c == 'ATC'){
                            if((ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Commercial-Travel')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Lodging'))){
                                if(tempListFA[0].CampaignTravelPercentage__c!=null && double.valueof(tempListFA[0].CampaignTravelPercentage__c)>0){
                                    accCode =tempListFA[0].CSS_Account_Formula__c;
                                }
                            }
                            else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                                if(tempListFA[0].CampaignTowingPercentage__c!=null && double.valueof(tempListFA[0].CampaignTowingPercentage__c)>0){
                                    accCode =tempListFA[0].CSS_Account_Formula__c;
                                }
                            }
                            failCode=tempListFA[0].FailCode_Formula__c;
                        }
                    }
                    else if(tempList !=null && tempList.size() >0){
                        if(tempList.size() == 1){
                           //if(tempList[0].CSS_CoverageType__c != null && tempList[0].CSS_CoverageType__c == 'NPW' || tempList[0].CSS_CoverageType__c == 'RPW' || tempList[0].CSS_CoverageType__c == 'RRW'){
                               if(tempList[0].CSS_CoverageType__c!= null && (tempList[0].CSS_CoverageType__c == 'OTH' || tempList[0].CSS_CoverageType__c == 'POL')){
                                    accCode =tempList[0].CSS_Account_Formula__c; 
                                }
                                if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Commercial-Travel') && lstSolComp[0].CoveredTravelBaseFareAmt__c!=null){
                                    if(tempList[0].CoveredTravelBaseFareAmt__c!= null && double.valueof(tempList[0].CoveredTravelBaseFareAmt__c)>0 && tempList[0].CoveredTravelLabor__c!=null &&  double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    }
                                }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel')){
                                    if(tempList[0].CoveredTravelMiles__c!=null && double.valueof(tempList[0].CoveredTravelMiles__c)>0 && tempList[0].CoveredTravelLabor__c!=null && double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    } 
                                }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                                    if(tempList[0].CoveredTowingMiles__c!=null && double.valueof(tempList[0].CoveredTowingMiles__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    }
                                }else if((ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Lodging'))){
                                    if(tempList[0].CoveredMealsLodgingAmt__c!=null && double.valueof(tempList[0].CoveredMealsLodgingAmt__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    }
                                }
                                failCode=tempList[0].FailCode_Formula__c;
                           // } 
                        }
                        else if(tempList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1){
                            if(tempList[0].CSS_CoverageType__c!= null && (tempList[0].CSS_CoverageType__c == 'OTH' || tempList[0].CSS_CoverageType__c == 'POL')){
                                accCode =tempList[0].CSS_Account_Formula__c; 
                            }
                            if(tempList[0].CSS_CoverageType__c != 'NPW' && tempList[0].CSS_CoverageType__c != 'RPW' && tempList[0].CSS_CoverageType__c != 'RRW' && tempList[0].CSS_CoverageType__c != 'OTH' && tempList[0].CSS_CoverageType__c != 'POL'){
                                if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Commercial-Travel') && lstSolComp[0].CoveredTravelBaseFareAmt__c!=null){
                                    if(tempList[0].CoveredTravelBaseFareAmt__c!= null && double.valueof(tempList[0].CoveredTravelBaseFareAmt__c)>0 && tempList[0].CoveredTravelLabor__c!=null &&  double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    }
                                }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel')){
                                    if(tempList[0].CoveredTravelMiles__c!=null && double.valueof(tempList[0].CoveredTravelMiles__c)>0 && tempList[0].CoveredTravelLabor__c!=null && double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    } 
                                }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                                    if(tempList[0].CoveredTowingMiles__c!=null && double.valueof(tempList[0].CoveredTowingMiles__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    }
                                }else if((ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Lodging'))){
                                    if(tempList[0].CoveredMealsLodgingAmt__c!=null && double.valueof(tempList[0].CoveredMealsLodgingAmt__c)>0){
                                        accCode =tempList[0].CSS_Account_Formula__c;
                                    }
                                }
                                failCode=tempList[0].FailCode_Formula__c;
                            }
                        }
                        
                    }
                    system.debug('Anirudh accCode>>>>'+accCode);
                    ttmlwr.accountCode = accCode ;
                    system.debug('Anirudh accCode>>>>'+ttmlwr.accountCode);
                    ttmlwr.failCode = failCode;
                    List<SelectOption> aC = new List<SelectOption>();
                    aC = fetchAccCodeValues(ttmlwr.Type,ttmlwr.failCode);
                    ttmlwr.accCodelst = aC;
                    if(ttmlwr.accountCode == null || ttmlwr.accountCode == 'Select One' || ttmlwr.accountCode == '')
                        ttmlwr.accCoverage=false;
                    else {
                        system.debug('inside else 1st true');
                        ttmlwr.accCoverage= true;
                    }
                }
            }
                    
            
        }
        /*if(lstSolComp != null && lstSolComp.size() == 1){   
            
            for(ttmlWrapperClass ttmlwr : listTTMLWrapper){
                if(ttmlwr.counting == SelectedPartID){
                    
                    if(lstSolComp[0].CSS_CoverageType__c!= null){ 
                        if(lstSolComp[0].CSS_CoverageType__c == 'OTH' || lstSolComp[0].CSS_CoverageType__c == 'POL'){
                            accCode =lstSolComp[0].CSS_Account_Formula__c;  
                        }
                    }
                    else{
                        string temp = lstSolComp[0].CSS_Account_Formula__c.substring(0,lstSolComp[0].CSS_Account_Formula__c.length()-3);
                        string temp1 = lstSolComp[0].CSS_Account_Formula__c.substring(lstSolComp[0].CSS_Account_Formula__c.length()-3,lstSolComp[0].CSS_Account_Formula__c.length()); 
                        system.debug('temp--->>>>'+temp);
                        system.debug('temp1--->>>>'+temp1);
                        temp1 = temp1.trim();
                        temp = temp.trim();
                        string temp2 = temp + temp1;
                        CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                        jetSingle = accCodeMapJET.get(temp2);
                        if(jetSingle!= null){
                            if(jetSingle.Attribute1__c == 'OTH' || jetSingle.Attribute1__c == 'POL'){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            } 
                            
                        }
                    }
                    system.debug('line 1987>>>>>>>');
                    if(lstSolComp[0].Type__c != 'Campaign' && lstSolComp[0].Type__c != 'TRP' && lstSolComp[0].Type__c != 'ATC'){
                        if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Commercial-Travel') && lstSolComp[0].CoveredTravelBaseFareAmt__c!=null){
                            if(lstSolComp[0].CoveredTravelBaseFareAmt__c!= null && double.valueof(lstSolComp[0].CoveredTravelBaseFareAmt__c)>0 && lstSolComp[0].CoveredTravelLabor__c!=null &&  double.valueof(lstSolComp[0].CoveredTravelLabor__c)>0){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            }
                        }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel')){
                            if(lstSolComp[0].CoveredTravelMiles__c!=null && double.valueof(lstSolComp[0].CoveredTravelMiles__c)>0 && lstSolComp[0].CoveredTravelLabor__c!=null && double.valueof(lstSolComp[0].CoveredTravelLabor__c)>0){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            } 
                        }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                            if(lstSolComp[0].CoveredTowingMiles__c!=null && double.valueof(lstSolComp[0].CoveredTowingMiles__c)>0){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            }
                        }else if((ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Lodging'))){
                            if(lstSolComp[0].CoveredMealsLodgingAmt__c!=null && double.valueof(lstSolComp[0].CoveredMealsLodgingAmt__c)>0){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            }
                        }
                    }
                    else{
                        if((ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Commercial-Travel')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals')) || (ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Lodging'))){
                            if(lstSolComp[0].CampaignTravelPercentage__c!=null && double.valueof(lstSolComp[0].CampaignTravelPercentage__c)>0){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            }
                        }
                        else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                            if(lstSolComp[0].CampaignTowingPercentage__c!=null && double.valueof(lstSolComp[0].CampaignTowingPercentage__c)>0){
                                accCode =lstSolComp[0].CSS_Account_Formula__c;
                            }
                        }
                    }
                    system.debug('Anirudh accCode>>>>'+accCode);
                    ttmlwr.accountCode = accCode ;
                    system.debug('Anirudh accCode>>>>'+ttmlwr.accountCode);
                    ttmlwr.failCode = lstSolComp[0].FailCode_Formula__c;
                    List<SelectOption> aC = new List<SelectOption>();
                    aC = fetchAccCodeValues(ttmlwr.Type,ttmlwr.failCode);
                    ttmlwr.accCodelst = aC;
                    if(ttmlwr.accountCode == null || ttmlwr.accountCode == 'Select One' || ttmlwr.accountCode == '')
                        ttmlwr.accCoverage=false;
                    else {
                        system.debug('inside else 1st true');
                        ttmlwr.accCoverage= true;
                    }
                }
            }
        }*/
    }
    
    public void addTTMLRow(){
        try{  
            system.debug('listTTMLWrapper data befor adding--->'+listTTMLWrapper);
            List<SelectOption> lstFc = new List<SelectOption>();
            lstFc.add(new SelectOption('Select One','Select One'));
            listTTMLWrapper.add(new ttmlWrapperClass(listTTMLWrapper.size(),null,null,'Select One',null,null,null,null,null,null,'jfhgf',null,null,false,false,false,false,false,lstFc,null,false,lstFc,false,false,false,false,false));
            system.debug('listTTMLWrapper data--->'+listTTMLWrapper);
            system.debug('listTTMLWrapper size--->'+listTTMLWrapper.size());
        }catch(Exception ex) {
            System.debug('in catch of AddRow of TTML Popup>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    public PageReference saveTTMLPopup(){ 
        system.debug('INSIDE saveTTMLPopup method');
        system.debug('****listTTMLWrapper****RAJESH'+listTTMLWrapper);
        ttmlReqErrMsg = false;//Initially we assume there is no error
        duplicateAccountCode = false;
        isExpenseTotalError = false;
        TravelTowingTTMLError = false;
        //Start code   as per story #148925 ,By RAJESH 09th Jan 2019-->        
        isMealsExpenseTotalError=false;
        isLodgingExpenseTotalError=false;
        isTowingExpenseTotalError=false;
        List<CSS_Parts_Options__c> OCList = new list<CSS_Parts_Options__c>();
        //End code   as per story #148925 ,By RAJESH 09th Jan 2019
        List<CSS_Parts_Options__c> selectedTTMLPartsList = new list<CSS_Parts_Options__c>();//This will be saved to the object
        PageReference pageRefTTML;//After Save from Pop up the page is to be redirected.
        Set<Boolean> setTtmlReqErrMsg = new Set<Boolean>();//Set of error messages
        set<boolean> setexpenserror = new set<boolean>();
        system.debug('The wrapper to be operated for total is.: '+listTTMLWrapper);
        try{
            for(ttmlWrapperClass prtslist : listTTMLWrapper)
            {
                Boolean x;
                //If the Technician is not selected
                if(prtslist.technician == 'Select One' || prtslist.technician == '' || prtslist.technician == null)
                {
                    prtslist.mandateTechnician = true;//mandateTechnician is a boolean value on TTML wrapper class
                    x = true;
                }
                else
                {                    
                    prtslist.mandateTechnician = false;
                }
                //If the type of expense is not selected
                system.debug('prtslist.type'+prtslist.type);
                if(prtslist.type == 'Select One' || prtslist.type == '' || prtslist.type == null)
                {
                    system.debug('inside prtslist.type'+prtslist.type);
                    prtslist.mandateType = true;
                    x = true;
                }
                else
                {
                    prtslist.mandateType = false;
                }
                system.debug('inside prtslist.type'+prtslist.mandateType);
                if(prtslist.mandateType == false && (prtslist.accountCode == 'Select One' || prtslist.accountCode == '' || prtslist.accountCode == null) && DealerTypeFlag == true)//Need to remove  reqaccountcode == true and Add DealerTypeFlag == true as per Defect GSSC-601
                {
                    prtslist.mandateaccountcode = true;
                    system.debug('prtslist.mandateaccountcode'+prtslist.mandateaccountcode);
                    x = true;
                    
                }
                else{
                    prtslist.mandateaccountcode = false;
                }
                
                
                
                //If the days is not filled
                /*if(prtslist.showDays == true && (prtslist.days == null || prtslist.days == ''))
{
prtslist.mandateDays = true;
x = true;
}
else
{
prtslist.mandateDays = false;
}*/
                //If the quantity is not filled
                if(prtslist.showDays == true && (prtslist.quantity == null || prtslist.quantity == '')){
                    prtslist.mandateDays = true;
                    x = true;
                }
                else{
                    prtslist.mandateDays = false;
                }
                //If the unitPrice is not filled
                if(prtslist.showUP == true && (prtslist.unitPrice == null || prtslist.unitPrice == '')){
                    prtslist.mandateUP = true;
                    x = true;
                }
                else{
                    prtslist.mandateUP = false;
                }
                //If the mileage is not filled
                if(prtslist.showMileage == true && (prtslist.mileage == null || prtslist.mileage == ''))
                {
                    prtslist.mandateMileage = true;
                    x = true;
                }
                else
                {
                    prtslist.mandateMileage = false;
                }
                //If the hoursTraveled is not filled
                if(prtslist.showMileageHT == true && (prtslist.hoursTraveled == null || prtslist.hoursTraveled == '' || prtslist.hoursTraveled == '.'))
                {
                    prtslist.mandateHrTr = true;
                    x = true;
                }
                else
                {
                    prtslist.mandateHrTr = false;
                }
                /*If the expenseTotal is not filled
if(prtslist.type != 'Select One' && (prtslist.expenseTotal == null || prtslist.expenseTotal == ''))
{
prtslist.mandateExpTotal = true;
x = true;
}
else
{
prtslist.mandateExpTotal = false;
}*/
                //RAJESH
                system.debug('prtslist.mandateTechnician>>>>'+prtslist.mandateTechnician + ' ' + prtslist.mandateType);
                /*   if(prtslist.mandateTechnician == true && prtslist.mandateType == true && (prtslist.Days == null || prtslist.Days == '') 
&& (prtslist.mileage == null || prtslist.mileage == '') && (prtslist.hoursTraveled == null || prtslist.hoursTraveled == '') 
&& (prtslist.expenseTotal == null || prtslist.expenseTotal == '') ) */
                
                //End                 
                
                if(prtslist.mandateTechnician == true && prtslist.mandateType == true )
                    
                {
                    system.debug('inside if');
                    prtslist.mandateTechnician = false;
                    prtslist.mandateType = false;
                    prtslist.mandateDays = false;
                    prtslist.mandateUP = false;
                    prtslist.mandateMileage = false;
                    prtslist.mandateHrTr = false;
                    prtslist.mandateExpTotal = false;
                    prtslist.mandateaccountcode = false;
                    x = false;
                    if(prtslist.notes != null && prtslist.notes != '') 
                    {
                        system.debug('inside if Notes');
                        prtslist.mandateTechnician = true;
                        prtslist.mandateType = true;
                        x = true;
                    }                        
                }
                system.debug('**valueOf x**'+x);
                setTtmlReqErrMsg.add(x);
                system.debug('**valueOf x**'+setTtmlReqErrMsg);
                /* if((prtslist.type=='Commercial-Travel' || prtslist.type=='Non Commercial-Travel')  && (Decimal.valueOf(prtslist.expenseTotal) > 100000 )){


prtslist.isExpenseTotal = true;
isExpenseTotalError = true;
system.debug('isExpenseTotalError isExpenseTotalError'+isExpenseTotalError);
}
*/
                if((prtslist.type=='Commercial-Travel' || prtslist.type=='Non Commercial-Travel')){
                    if(prtslist.expenseTotal!=null && prtslist.expenseTotal!=''){
                        Decimal expenseTotalValue = Decimal.valueOf(prtslist.expenseTotal);
                        system.debug('***expenseTotalValue***'+expenseTotalValue);
                        if(expenseTotalValue > 10000 ){
                            prtslist.isExpenseTotal = true;
                            isExpenseTotalError = true;
                        }
                    }
                }
                
                //Start code as per story #148925 ,By RAJESH 09th Jan 2019-->
                system.debug('****prtslist.expenseTotal***'+prtslist.expenseTotal);
                
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='' ) && prtslist.type == 'Meals'  && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.isExpenseTotal=true;
                    isMealsExpenseTotalError=true;
                }
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='' ) && prtslist.type == 'Lodging' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.isExpenseTotal=true;
                    isLodgingExpenseTotalError=true;
                    
                }
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='' ) && prtslist.type == 'Towing' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.isExpenseTotal=true;
                    isTowingExpenseTotalError=true;
                }
                //End code as per story #148925 ,By RAJESH 09th Jan 2019--> 
            }
            system.debug('***setTtmlReqErrMsg***'+setTtmlReqErrMsg);
            if(setTtmlReqErrMsg.contains(true)){
                system.debug('inside if setTtmlReqErrMsg');
                ttmlReqErrMsg = true;
            }
            //Else plan for save
            else{
                system.debug('inside else if setTtmlReqErrMsg');
                ttmlReqErrMsg = false;
            }
            
            //Added for story 148928
            /*for(ttmlWrapperClass prtslist1 : listTTMLWrapper)
{
if((prtslist1.type=='Commercial-Travel' || prtslist1.type=='Non Commercial-Travel') && (Decimal.valueOf(prtslist1.expenseTotal) > 100000 ))
{
boolean k=true;
setexpenserror.add(k);
break;

}
}
if(setexpenserror.contains(true)){
system.debug('inside if setTtmlReqErrMsg');
isExpenseTotalError = true;
return null;
}
else{
isExpenseTotalError = false;
}*/
            
            //If user has not selected any mandatory value or if anywhere in the setTtmlReqErrMsg set contains true then set the boolean value for 
            //pop up error as true(i.e. Pop have error).            
            
            //if(!ttmlReqErrMsg && isExpenseTotalError==false ) 
            
            
            Map<String, List<String>> TTMLMap = new Map<String, List<String>>();
            OCList = [select Id,ExpenseTotal__c,isManual__c ,selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                          Account_Code__c, Notes__c,Unit_Price__c from CSS_Parts_Options__c where CSS_Claims__c=:cId and RecordType.Name ='OtherClaimables'];
                
            if(!ttmlReqErrMsg && isExpenseTotalError==false && isMealsExpenseTotalError==false && isLodgingExpenseTotalError==false && isTowingExpenseTotalError==false)
            {   
                List<String> tempList;
                Integer j=0;
                duplicateAccountCode=false;//If this variable is true the error mesg will be displayed that Travel and Towing can not happen together
                System.debug('listTTMLWrapper size before save>>>:'+listTTMLWrapper.size()+' The listpartWrapper save list is>>>>>>>>>:'+listTTMLWrapper);
                for(ttmlWrapperClass prtslist : listTTMLWrapper)
                {
                    
                    if(prtslist.type == 'Non Commercial-Travel' || prtslist.type == 'Commercial-Travel' || prtslist.type == 'Towing')
                    {
                        for(Integer i =0;i<listTTMLWrapper.size();i++)
                        {
                            
                            if((prtslist.type=='Commercial-Travel' || prtslist.type=='Non Commercial-Travel') && (prtslist != null && prtslist.expenseTotal != null && prtslist.expenseTotal != '' && Decimal.valueOf(prtslist.expenseTotal) > 100000 )){
                                prtslist.isExpenseTotal = true;
                                isExpenseTotalError = true;
                                system.debug('isExpenseTotalError*********'+isExpenseTotalError);
                            }
                            else{
                                prtslist.isExpenseTotal = false;
                                isExpenseTotalError = false;
                            }
                            //Start code as per story #148925 ,By RAJESH 09th Jan 2019-->
                            system.debug('****prtslist.expenseTotal***'+prtslist.expenseTotal);
                            
                            if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Meals'  && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                                prtslist.isExpenseTotal=true;
                                isMealsExpenseTotalError=true;
                                // isLodgingExpenseTotalError=false;
                                // isTowingExpenseTotalError=false;
                            }
                            if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='' ) && prtslist.type == 'Lodging' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                                prtslist.isExpenseTotal=true;
                                // isMealsExpenseTotalError=false;
                                isLodgingExpenseTotalError=true;
                                // isTowingExpenseTotalError=false;
                            }
                            if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='' ) && prtslist.type == 'Towing' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                                prtslist.isExpenseTotal=true;
                                //isMealsExpenseTotalError=false;
                                //isLodgingExpenseTotalError=false;
                                isTowingExpenseTotalError=true;
                            }
                            //End code as per story #148925 ,By RAJESH 11th Jan 2019-->
                            //If the account code is same and claim is raised for travel and towing then show the error
                            if(j!=i && prtslist.accountCode == listTTMLWrapper[i].accountCode)
                            {
                                if((prtslist.type.containsIgnoreCase('Travel') && listTTMLWrapper[i].type == 'Towing') || (prtslist.type.containsIgnoreCase('Towing') && listTTMLWrapper[i].type.containsIgnoreCase('Travel')))
                                {
                                    duplicateAccountCode = true;
                                    break;
                                } 
                                
                                //If the account code is differenct and claim is raised for travel and towing then save the record
                            }
                            if(j!=i && prtslist.accountCode <> listTTMLWrapper[i].accountCode)
                            {
                                if(listTTMLWrapper[i].type.containsIgnoreCase('Travel') &&  listTTMLWrapper[i].type == 'Towing')
                                {
                                    duplicateAccountCode = false;
                                }   
                                
                            }
                        }
                    }
                    
                    system.debug('Today duplicateAccountCode>> ' +duplicateAccountCode);
                    
                    /* if((prtslist.type=='Commercial-Travel' || prtslist.type=='Non Commercial-Travel') && (Decimal.valueOf(prtslist.expenseTotal) > 100000 )){
prtslist.isExpenseTotal = true;
isExpenseTotalError = true;
}
else{
prtslist.isExpenseTotal = false;
isExpenseTotalError = false;
}*/
                    
                    //END
                    if(prtslist.type == null || prtslist.type == '' || prtslist.type == 'Select One')
                    {
                        if(prtslist.ids != null && String.valueOf(prtslist.ids).trim() != '')
                        {
                            removeIdsMap.put(prtslist.ids, String.valueOf(prtslist.ids));
                            displayPopup2 = false;
                        }
                    }
                    else
                    {
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.recordtypeId  = recTypeIdTTML;
                        partsoption.Technician__c = prtslist.technician;
                        partsoption.Type__c = prtslist.type;
                        if(prtslist.days != null && prtslist.days != '')
                            partsoption.Days__c = Integer.valueOf(prtslist.days);
                        //Added below code for saving Quantity and unit price as per "I Survived" sprint story #152963,-By RAJESH 24th July 2018 
                        if(prtslist.quantity != null && prtslist.quantity != ''){
                            partsoption.quantity__c = Integer.valueOf(prtslist.quantity);
                            system.debug('*8RAJESH**prtslist.quantity+'+partsoption.quantity__c);
                        }
                        //Commented below code as part of story GSSC-138
                        /*if(prtslist.unitPrice != null && prtslist.unitPrice != ''){
                            partsoption.Unit_Price__c = prtslist.unitPrice;
                            system.debug('*8RAJESH**prtslist.unitPrice+'+partsoption.Unit_Price__c);
                        }
                        
                        if(prtslist.expenseTotal != null && prtslist.expenseTotal != '')
                            partsoption.ExpenseTotal__c = Decimal.valueOf(prtslist.expenseTotal);
                        */
                        
                        /*  if(prtslist.Notes != null && prtslist.Notes != ''){
partsoption.Notes__c = prtslist.unitPrice;
system.debug('*8RAJESH**prtslist.unitPrice+'+partsoption.Notes__c);
}*/
                        // End                 
                        
                        //GSSC-138 start
                        system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                        system.debug('prtslist.ids--'+prtslist.ids);
                         system.debug('selectedTTMLPartsList prtslist2'+prtslist.expenseTotal);
                         system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                         system.debug('partsoption.ExpenseTotal__c--'+partsoption.ExpenseTotal__c);
                         system.debug('lstCurrencyDetails[0].Bolt_Conversion_Rate__c--'+lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                        if(prtslist.ids != null){
                            
                            system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                            if(prtslist.UnitpriceModified != null){
                                system.debug('Inside TTML Unit Price modified');
                                if(lstCurrencyDetails != null && lstCurrencyDetails.size() > 0){
                                    if(userinfo.getDefaultCurrency() != 'USD'){
                                        system.debug('Inside TTML CAD');
                                        partsoption.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                        partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                        partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                        partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                        partsoption.Unit_Price__c = string.valueof((decimal.valueof(prtslist.unitPrice)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c));
                                        partsoption.ExpenseTotal__c = (decimal.valueof(prtslist.expenseTotal)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                    
                                        system.debug('prtslist.ExpenseTotal__c--'+partsoption.ExpenseTotal__c);
                                    }
                                    else{
                                        partsoption.Exchange_Rate__c = 1;
                                        partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                        partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                        partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                        partsoption.Unit_Price__c = prtslist.unitPrice;
                                        partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                                        system.debug('prtslist.ExpenseTotal__c else--'+partsoption.ExpenseTotal__c);
                                    }
                                    partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                                }
                            }
                            
                             else{
                            if(prtslist.type !='Non Commercial-Travel'){
                                
                                if(userinfo.getDefaultCurrency() != 'USD'){
                                    system.debug('Inside TTML CAD');
                                    partsoption.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                    partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                    partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                    partsoption.Unit_Price__c = string.valueof((decimal.valueof(prtslist.unitPrice)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c));
                                    partsoption.ExpenseTotal__c = (decimal.valueof(prtslist.expenseTotal)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                
                                    system.debug('prtslist.ExpenseTotal__c--'+partsoption.ExpenseTotal__c);
                                }
                                else{
                                    partsoption.Exchange_Rate__c = 1;
                                    partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                    partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                    partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    partsoption.Unit_Price__c = prtslist.unitPrice;
                                    partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                                    system.debug('prtslist.ExpenseTotal__c else--'+partsoption.ExpenseTotal__c);
                                }
                                partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                                
                                
                                /*if(prtslist != null && prtslist.expenseTotal != null && prtslist.expenseTotal != '')
                                    partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                                
                                    partsoption.Unit_Price__c = prtslist.unitPrice;*/
                            }
                            else{
                             system.debug('selectedTTMLPartsList prtslist4'+prtslist.expenseTotal);
                             system.debug('prtslist.ExpenseTotal__c out else--'+partsoption.ExpenseTotal__c);
                             
                             /********************/
                             if(userinfo.getDefaultCurrency() != 'USD'){
                                system.debug('Inside TTML CAD');
                               // partsoption.Unit_Price__c = null;
                                partsoption.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                //partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                //partsoption.Unit_Price__c = string.valueof((decimal.valueof(prtslist.unitPrice)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c));
                                partsoption.ExpenseTotal__c = (decimal.valueof(prtslist.expenseTotal)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                            
                                system.debug('prtslist.ExpenseTotal__c--'+partsoption.ExpenseTotal__c);
                            }
                            else{
                                partsoption.Exchange_Rate__c = 1;
                                //partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                //partsoption.Unit_Price__c = prtslist.unitPrice;
                                partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                                system.debug('prtslist.ExpenseTotal__c else--'+partsoption.ExpenseTotal__c);
                            }
                            partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                                    
                                    /*************************/
                            }
                        }
                            
                             system.debug('selectedTTMLPartsList prtslist3'+prtslist.expenseTotal);
                             system.debug('prtslist.ExpenseTotal__c out--'+partsoption.ExpenseTotal__c);
                        }
                        else{
                            if(prtslist.type !='Non Commercial-Travel'){
                                
                                if(userinfo.getDefaultCurrency() != 'USD'){
                                    system.debug('Inside TTML CAD');
                                    partsoption.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                    partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                    partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                    partsoption.Unit_Price__c = string.valueof((decimal.valueof(prtslist.unitPrice)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c));
                                    partsoption.ExpenseTotal__c = (decimal.valueof(prtslist.expenseTotal)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                
                                    system.debug('prtslist.ExpenseTotal__c--'+partsoption.ExpenseTotal__c);
                                }
                                else{
                                    partsoption.Exchange_Rate__c = 1;
                                    partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                    partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                    partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    partsoption.Unit_Price__c = prtslist.unitPrice;
                                    partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                                    system.debug('prtslist.ExpenseTotal__c else--'+partsoption.ExpenseTotal__c);
                                }
                                partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                                
                                
                                /*if(prtslist != null && prtslist.expenseTotal != null && prtslist.expenseTotal != '')
                                    partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                                
                                    partsoption.Unit_Price__c = prtslist.unitPrice;*/
                            }
                            else{
                             system.debug('selectedTTMLPartsList prtslist4'+prtslist.expenseTotal);
                             system.debug('prtslist.ExpenseTotal__c out else--'+partsoption.ExpenseTotal__c);
                             
                             /********************/
                             if(userinfo.getDefaultCurrency() != 'USD'){
                                system.debug('Inside TTML CAD');
                               // partsoption.Unit_Price__c = null;
                                partsoption.Exchange_Rate__c = lstCurrencyDetails[0].Bolt_Conversion_Rate__c;
                                partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                //partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                //partsoption.Unit_Price__c = string.valueof((decimal.valueof(prtslist.unitPrice)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c));
                                partsoption.ExpenseTotal__c = (decimal.valueof(prtslist.expenseTotal)) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                            
                                system.debug('prtslist.ExpenseTotal__c--'+partsoption.ExpenseTotal__c);
                            }
                            else{
                                partsoption.Exchange_Rate__c = 1;
                                //partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                //partsoption.Unit_Price__c = prtslist.unitPrice;
                                partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                                system.debug('prtslist.ExpenseTotal__c else--'+partsoption.ExpenseTotal__c);
                            }
                            partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                                    
                                    /*************************/
                            }
                        }
                        
                         system.debug('selectedTTMLPartsList prtslist'+prtslist.expenseTotal);
                         system.debug('prtslist.ExpenseTotal__c out out--'+partsoption.ExpenseTotal__c);
                        //GSSC-138 end
                        
                        // if(partsoption.ExpenseTotal__c == null ){
                        //     partsoption.ExpenseTotal__c = Decimal.valueOf(prtslist.expenseTotal);
                        //  }
                        
                        if(prtslist.mileage != null && prtslist.mileage != '' && prtslist.mileage != '.')
                            partsoption.Mileage__c = Decimal.valueOf(prtslist.mileage);
                        if(prtslist.hoursTraveled != null && prtslist.hoursTraveled != '' && prtslist.hoursTraveled != '.')
                            partsoption.HoursTravelled__c = Decimal.valueOf(prtslist.hoursTraveled);
                        if(prtslist.failCode != 'Select One')
                            partsoption.Fail_Code__c = prtslist.failCode;
                        else
                            partsoption.Fail_Code__c = '';
                        if(prtslist.accountCode != '' && prtslist.accountCode != null)
                            partsoption.Account_Code__c = prtslist.accountCode;
                        else
                            partsoption.Account_Code__c ='';
                        if(prtslist.ids != null){
                            partsoption.Id = prtslist.ids;
                            partsoption.selected_part__c = true;
                            partsoption.isManual__c = false;
                            
                        }
                        else
                        {
                            partsoption.isManual__c = true;//Make it true if it is a manually created record which is not cloned from Job
                            partsoption.selected_part__c = true;
                            
                        }
                        
                        
                        partsoption.CSS_Claims__c = cid;
                        String hexdigit=EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf('1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS')))));
                        partsoption.TTMLWrapperID__c=hexdigit;
                        prtslist.ttmlwrapperid =hexdigit;
                        prtslist.isTTMLPartsCovLimitExceed = false;
                        prtslist.isTTMLFailcodeCovLimitExceed=false;
                        
                        selectedTTMLPartsList.add(partsoption);
                        
                        if(TTMLMap != null && TTMLMap.containsKey(partsoption.Account_Code__c)){
                            tempList = TTMLMap.get(partsoption.Account_Code__c);
                            tempList.add(partsoption.Type__c);
                            TTMLMap.put(partsoption.Account_Code__c, tempList);
                        }
                        else{
                            tempList = new List<String>();
                            tempList.add(partsoption.Type__c);
                            TTMLMap.put(partsoption.Account_Code__c, tempList);
                        } 
                                
                        
                        if(duplicateAccountCode == true)
                            break;
                    }
                }
                system.debug('OCList****' + OCList);
                system.debug('Today2 duplicateAccountCode>> ' +duplicateAccountCode);
                
                if (OCList != null && OCList.size() > 0 )
                {
                for(CSS_Parts_Options__c po: OCList){
                    if(TTMLMap != null && TTMLMap.containsKey(po.Account_Code__c)){
                        tempList = TTMLMap.get(po.Account_Code__c);
                        tempList.add(po.Item__c);
                        TTMLMap.put(po.Account_Code__c, tempList);
                    }
                    else{
                        tempList = new List<String>();
                        tempList.add(po.Item__c);
                        TTMLMap.put(po.Account_Code__c, tempList);
                    }
                }
                }
                
                for(string Str : TTMLMap.keySet()){
                   List<string> tempvar;
                   tempvar = TTMLMap.get(Str);
                   if(tempvar!=null && (tempvar.contains('COMMERCIAL TRAVEL') || tempvar.contains('Commercial-Travel') || tempvar.contains('NON COMMERCIAL TRAVEL') || tempvar.contains('Non Commercial-Travel')) && tempvar.contains('TOWING')){
                    TravelTowingTTMLError=true;
                    system.debug('TravelTowingError***' + TravelTowingTTMLError);
                    return null;
               }
               }
            

                
                
                System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
                if(duplicateAccountCode!= true){
                    try{
                        if(duplicateAccountCode!= true && removeIdsMap.keySet().size()>0)
                        {
                            deleteTTMLParts();
                        }
                    }catch(Exception ex) 
                    {
                        System.debug('In first catch of saveTTMLParts: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                    }
                    
                    
                    errTTML = new List<string>();
                    map<string,CSS_Parts_Options__c> selectedTTMLvalidparts = new map<string,CSS_Parts_Options__c>();
                    map<string,map<string,string>> validationerrors;
                    system.debug('selectedTTMLPartsList'+selectedTTMLPartsList);
                    if(selectedTTMLPartsList != null && selectedTTMLPartsList.size() > 0){
                        //CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                        
                        id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                        
                        //allcssparts.addAll([SELECT Id, Account_Code__c,fail_code__c,Type__c,ExpenseTotal__c,Mileage__c,HoursTravelled__c,TTMLWrapperID__c, Quantity__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: cId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart   AND ID NOT IN :selectedTTMLPartsList]);
                        for(CSS_Parts_Options__c rec :selectedTTMLPartsList){
                            // rec.TTMLWrapperID__c=EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf('1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS')))));
                            selectedTTMLvalidparts.put(rec.TTMLWrapperID__c,rec);
                        }
                        validationerrors= contr.covLimitValidation_TTML(CID,selectedTTMLPartsList);
                        system.debug('validationerrors**'+validationerrors);
                        system.debug('selectedTTMLvalidpartsmap**'+selectedTTMLvalidparts);
                        
                        
                    }
                    //if(errMsgLst != null && errMsgLst.size() > 0){
                    if(validationerrors != null && validationerrors.size() > 0){
                    } else{
                        if(selectedTTMLPartsList.size()>0)     {
                            System.debug('upsert selectedTTMLPartsList size>>>>:'+selectedTTMLPartsList.size()+' selectedTTMLPartsList>>>>:'+selectedTTMLPartsList);
                            displayPopup2 = false;
                            upsert selectedTTMLPartsList Id;
                        }
                    }
                    // getAllTTMLPartsData();
                    //saveClaimExpenseTotal();
                    
                    String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
                    //pageRefTTML = new PageReference(sDestURL+'id='+Wid); 
                    pageRefTTML = new PageReference(sDestURL+'id='+cid); 
                    system.debug('sDestURL' + sDestURL);
                    pageRefTTML.setRedirect(true);
                    errMsgLstNew = new List<String>();
                    
                    if(validationerrors != null && validationerrors.size() > 0){
                        for(ttmlWrapperClass prtslist:listTTMLWrapper){
                            system.debug('ttmlWrapperClass**'+listTTMLWrapper);
                            if(validationerrors.containsKey(prtslist.ttmlwrapperid)){
                                prtslist.isTTMLPartsCovLimitExceed = true;
                                system.debug('validationexsist**'+prtslist.isTTMLPartsCovLimitExceed);
                                map<string,string> errortype =validationerrors.get(prtslist.ttmlwrapperid);
                                for(string pss:errortype.keySet()){
                                    string code;
                                    if(errortype.get(pss).contains('@')){
                                        code=errortype.get(pss).substringbefore('@')+errortype.get(pss).substringafter('@') ;
                                        prtslist.isTTMLFailcodeCovLimitExceed=true;
                                    }else{
                                        code=errortype.get(pss); 
                                    }
                                    if(!errMsgLstNew.contains(code)){
                                        errMsgLstNew.add(code);
                                    }
                                    
                                }
                            }else{
                                prtslist.isTTMLPartsCovLimitExceed = false;
                                prtslist.isTTMLFailcodeCovLimitExceed=false;
                            }
                        }
                        return null;
                    }else{
                        return pageRefTTML;
                    }
                    
                }else
                    return null;
            }
            else
                return null;
        }
        catch(Exception ex) {
            System.debug('In second catch of saveTTMLParts: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            return null;
        }
        
        
        
    }
    
    //This is TTML Delete Method
    public void deleteTTMLParts(){
        System.debug('in delete TTML Parts');
        try
        {
            List<CSS_Parts_Options__c> toDeleteTTMLList = new List<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> deleteTTMLList = new List<CSS_Parts_Options__c>([SELECT Id FROM CSS_Parts_Options__c WHERE Id IN:removeIdsMap.keySet()]);
            if(deleteTTMLList.size()>0)
                delete deleteTTMLList;
            removeIdsMap = new Map<Id,String>();
        }
        catch(Exception ex) 
        {
            System.debug('in catch of delete TTML Parts'+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    //TTML Account Code Change Method when Failcode is changed
    public void getAccCodesonChngofFailCode(){
        duplicateAccountCode=false;
        system.debug('Method goining inside getAccCodesonChngofFailCode');
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('SelectedPartID>>>>>>>>>>: '+SelectedPartID);
        String accCode;
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        if(SelectedFailCode!='Select One'){
            if(claimsRec.CSS_Job__c != null && claimsRec.CSS_Job__c != '')
                lstSolComp = [SELECT  Id,Over_The_Counter__c, CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where (Service_Job__c =:claimsRec.CSS_JOb__c OR CSS_Claims__c=:CID) and FailCode_Formula__c = :SelectedFailCode AND CSS_Account_Formula__c!=''];
            else
                lstSolComp = [SELECT  Id,Over_The_Counter__c, CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where CSS_Claims__c=:CID and FailCode_Formula__c = :SelectedFailCode AND CSS_Account_Formula__c!=''];
            system.debug('lstSolComp'+lstSolComp);
            system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
            if(lstSolComp != null && lstSolComp.size()!=0){
                if(lstSolComp.size() > 1)
                {
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
                    if(setAcCode==true)
                        accCode='';
                    else
                        accCode=acCode;
                }
                else
                    accCode =lstSolComp[0].CSS_Account_Formula__c;
            }
            for(ttmlWrapperClass ttmlwr : listTTMLWrapper){
                if(ttmlwr.counting == SelectedPartID){
                    ttmlwr.accountCode = accCode ;
                    if(ttmlwr.accountCode == null || ttmlwr.accountCode == 'Select One' || ttmlwr.accountCode == '')
                        ttmlwr.accCoverage=false;
                    else {
                        system.debug('inside else part 2 true');
                        ttmlwr.accCoverage= true;
                        
                    }
                }
            } 
        }
        else{
            accCode='';
            for(ttmlWrapperClass  ttmlwr : listTTMLWrapper ){
                if(ttmlwr.counting == SelectedPartID)
                {
                    ttmlwr.accCoverage=false;
                    ttmlwr.accountCode = accCode;
                }
            } 
        }
        system.debug('listTTMLWrapper>>>>>>>>>>: '+listTTMLWrapper);
    }
    
   public void getAllTTMLPartsData(){
        
        chkReqField = false;
        Boolean showDaysTTML;
        Boolean showMileageHTTTML;
        boolean showUPTTML;
        boolean showMileageTTML;
        Boolean accCoverage;
        isExpenseTotalError = false;
        ttmlPartlstUI = new list<CSS_Parts_Options__c>();
        Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();//GSSC-138
        system.debug('***claimsRec css_job__c from constractor ***'+claimsRec.css_job__c);
        system.debug('****DealerUser in getAllTTMLPartsData***'+DealerUser);
        try{
            //If it is a automated claim then we have to show all the parts options data which is saved on Service Job Object
            if(CID!=null){
                recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                ttmlPartlstUI = [select Id,RecordTypeId, CSS_Claims__c, Service_Job__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Exchange_Rate__c, isManual__c,Item__c,Part_Description__c,Quantity__c,Unit_Price__c,amount__c,Covered__c,Fail_Code__c,Account_Code__c,
                                 Technician__c, Type__c, Days__c, Mileage__c, HoursTravelled__c, Notes__c, ExpenseTotal__c,FailurepartId__r.CoveredOCAmount__c
                                 from CSS_Parts_Options__c where  CSS_Claims__c=:cId and RecordTypeId=:recTypeIdTTML ORDER BY CreatedDate];
                system.debug('ttmlPartlstUI----->'+ttmlPartlstUI);
            }
            else{
                
            }
            
            //GSSC-138 start
            css_utility utility = new css_utility();
            
            mapPartsList = utility.displayParts(ttmlPartlstUI);
            system.debug('mapPartsList--'+mapPartsList);
            //GSSC-138 end 
            
            if(ttmlPartlstUI != null && ttmlPartlstUI.size()>0){
                listTTMLWrapper = new List<ttmlWrapperClass>();
                setTTMLWrapper = new Set<ttmlWrapperClass>();
                system.debug('ttmlPartlstUI.size>>>>'+ttmlPartlstUI.size());
                for(integer i=0;i<ttmlPartlstUI.size();i++){
                    List<SelectOption> fC = new List<SelectOption>();
                    accCoverage = false;
                    //fC = getfailCodeValues(ttmlPartlstUI[i].Type__c);
                    //  fC = getfailCodeValues();
                    
                    fC = fetchfailCodeValuesNew(ttmlPartlstUI[i].Type__c);
                    if(fC.size() == 1 && ttmlPartlstUI[i].Fail_Code__c!=null){
                        fC.add(new SelectOption(ttmlPartlstUI[i].Fail_Code__c,ttmlPartlstUI[i].Fail_Code__c));
                    }
                    List<SelectOption> aC = new List<SelectOption>();
                    aC = fetchAccCodeValues(ttmlPartlstUI[i].Type__c,ttmlPartlstUI[i].Fail_Code__c);
                    if(aC.size() == 1 && ttmlPartlstUI[i].Account_Code__c!= null){
                        aC.add(new SelectOption(ttmlPartlstUI[i].Account_Code__c,ttmlPartlstUI[i].Account_Code__c));
                    }
                    /* if(ttmlPartlstUI[i].Type__c == 'Meals' || ttmlPartlstUI[i].Type__c == 'Lodging'){
showDaysTTML = true;
showUPTTML = true;
showMileageHTTTML = false;
}*/
                    //Commented the below condityion as per "I Survived" sprint story #152963,-By RAJESH 26rd July 2018                  
                    //else if(ttmlPartlstUI[i].Type__c == 'Commercial-Travel' || ttmlPartlstUI[i].Type__c == 'Non Commercial-Travel'){
                    if(ttmlPartlstUI[i].Type__c == 'Meals' || ttmlPartlstUI[i].Type__c == 'Lodging' || ttmlPartlstUI[i].Type__c == 'Towing'){
                        system.debug('**inside MLT**');
                        showDaysTTML = true;
                        showMileageHTTTML = false;
                        
                        showMileageTTML= false;
                        showUPTTML = true;
                        
                    }
                    else if(ttmlPartlstUI[i].Type__c == 'Commercial-Travel'){
                        system.debug('**inside Commertial**');
                        system.debug('** claimsRec.css_job__c**'+claimsRec.css_job__c);
                        //Added if and else part code inside else if as per defect #175168,-By RAJESH 31st Dec 2018
                        if(DealerTypeFlag== true){
                            system.debug('**claimsRec.Account__r.type**'+claimsRec.Account__r.type);
                            showDaysTTML = false;
                            showMileageHTTTML = true;
                            showMileageTTML= false;
                            showUPTTML = true;
                        }                        
                        else{
                            if( claimsRec.css_job__c==null){
                                system.debug('**else claimsRec.Account__r.type**'+claimsRec.Account__r.type);
                                showDaysTTML = false;
                                showMileageHTTTML = true;
                                showMileageTTML= false;
                                showUPTTML = true;
                            }
                            else{
                                system.debug('**else claimsRec.Account__r.type**'+claimsRec.Account__r.type);
                                system.debug('**else DealerUser**'+DealerUser);
                                if(DealerUser == true){
                                    showDaysTTML = false;
                                    showMileageHTTTML = true;
                                    showMileageTTML= false;
                                    showUPTTML = true;
                                }
                                else{
                                    showDaysTTML = true;
                                    showMileageHTTTML = false;
                                    showMileageTTML= false;
                                    showUPTTML = true;   
                                }
                                
                            }
                        }
                    }
                    else if(ttmlPartlstUI[i].Type__c == 'Non Commercial-Travel'){
                        system.debug('**inside Non Comm**');
                        
                        if(DealerTypeFlag== true){
                            showDaysTTML = false;
                            showUPTTML = false;
                            showMileageTTML= true;
                            showMileageHTTTML = true;
                        }
                        else{
                            //system.debug('***inside else claimsRec css_job__c ***'+claimsRec.css_job__c);
                            //system.debug('**else claimsRec.Account__r.type**'+claimsRec.Account__r.type);
                            //Added if and else part code inside else as per stories #152963 and #152967,-By RAJESH 4th Jan 2019                         
                            if(claimsRec.css_job__c!=null){
                                system.debug('***inside if claimsRec css_job__c ***'+claimsRec.css_job__c);
                                /* showDaysTTML = false;
showUPTTML = true;
showMileageHTTTML = true;
showMileageTTML= false;*/
                                system.debug('**else DealerUser**'+DealerUser);
                                if(DealerUser == true){
                                    showDaysTTML = false;
                                    showMileageHTTTML = true;
                                    showMileageTTML= true;
                                    showUPTTML = false;
                                }
                                else{
                                    showDaysTTML = true;
                                    showMileageHTTTML = false;
                                    showMileageTTML= false;
                                    showUPTTML = true;   
                                }
                            }
                            else{
                                system.debug('***inside if else claimsRec css_job__c ***'+claimsRec.css_job__c);
                                showDaysTTML = false;
                                showUPTTML = false;
                                showMileageHTTTML = true;
                                showMileageTTML= true;   
                            }
                            //End if and else part code inside else as per stories #152963 and #152967,-By RAJESH 4th Jan 2019                            
                        }
                        //End if and else part code inside else if as per defect #175168,-By RAJESH 31st Dec 2018                        
                    }                    
                    else{
                        showDaysTTML = false;
                        showMileageHTTTML = false;
                        showUPTTML= false;
                       showMileageTTML= false;
                    }
                    //Defect 190304 added select one condition by saikomal
                    if(ttmlPartlstUI[i].Account_Code__c != null && ttmlPartlstUI[i].Account_Code__c != '' && ttmlPartlstUI[i].Account_Code__c != 'select one')
                    {
                        system.debug('inside acc code'+ttmlPartlstUI[i].Account_Code__c);
                        accCoverage = true;
                    }
                    /*List<SelectOption> lstFc = new List<SelectOption>();
lstFc.add(new SelectOption('Select One','Select One'));*/
system.debug('ttmlPartlstUI[i].Mileage__cbeforesetttml'+ttmlPartlstUI[i].Mileage__c);
                    setTTMLWrapper.add(new ttmlWrapperClass(i,ttmlPartlstUI[i].Id,ttmlPartlstUI[i].Technician__c,ttmlPartlstUI[i].Type__c,ttmlPartlstUI[i].Days__c!= null ? String.valueof(ttmlPartlstUI[i].Days__c): '',ttmlPartlstUI[i].Quantity__c!= null ? String.valueof(ttmlPartlstUI[i].Quantity__c): '',ttmlPartlstUI[i].Unit_Price__c!= null ? String.valueof(ttmlPartlstUI[i].Unit_Price__c): '',ttmlPartlstUI[i].Mileage__c != null ? String.valueof(ttmlPartlstUI[i].Mileage__c) : '', ttmlPartlstUI[i].HoursTravelled__c != null ? String.valueof(ttmlPartlstUI[i].HoursTravelled__c) : '',ttmlPartlstUI[i].ExpenseTotal__c != null ? String.valueof(ttmlPartlstUI[i].ExpenseTotal__c) : '',ttmlPartlstUI[i].Fail_Code__c != null ? ttmlPartlstUI[i].Fail_Code__c : '',ttmlPartlstUI[i].Account_Code__c,ttmlPartlstUI[i].Notes__c,showDaysTTML,showMileageHTTTML,showUPTTML,showMileageTTML,accCoverage,fC,ttmlPartlstUI[i].isManual__c,false,aC,false,false,false,false,false));
                }
                system.debug('setTTMLwrapper size>>>>'+setTTMLWrapper.size());
                system.debug('setTTMLwrapper>>>>+++!!+!!'+setTTMLWrapper);
                if(ttmlPartlstUI.size()<=4) {
                    
                    system.debug('karthikInside3959');
                    for(integer i=0;i<5-ttmlPartlstUI.size();i++){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.Technician__c = 'Select One';
                        partsoption.Type__c = 'Select One';
                        partsoption.Days__c = null;
                        partsoption.Quantity__c = null;
                        partsoption.Unit_Price__c = null;
                        partsoption.Mileage__c = null ;
                        partsoption.HoursTravelled__c = null;
                        partsoption.ExpenseTotal__c = null;
                        partsoption.Fail_Code__c = '';
                        partsoption.Account_Code__c = '';
                        partsoption.Notes__c = '';
                        List<SelectOption> fcEmpty = new List<SelectOption>();
                        fcEmpty.add(new SelectOption('Select One','Select One'));
                        try{
                            setTTMLWrapper.add(new ttmlWrapperClass(ttmlPartlstUI.size()+i,null,partsoption.Technician__c,partsoption.Type__c,String.valueof(partsoption.Days__c),String.valueof(partsoption.Quantity__c),partsoption.Unit_Price__c,String.valueof(partsoption.Mileage__c),String.valueof(partsoption.HoursTravelled__c),String.valueof(partsoption.ExpenseTotal__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,partsoption.Notes__c,false,false,false,false,false,fcEmpty,null,false,fcEmpty,false,false,false,false,false)); //since accountcode also initial empty, passing same list for both account code and failcode
                        }catch(Exception ex){
                            System.debug('in catch of getallTTMLPartsData adding wrapper>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                        }
                        System.debug('setTTMLWrapper>>>:'+setTTMLWrapper);
                    }
                    system.debug('ttmlPartlstUI>>>>>>>>>>:'+ttmlPartlstUI);
                }
                system.debug('setTTMLWrapper exist>>>>>>>>>>:'+setTTMLWrapper);
            }
            else{
                system.debug('Inside else');
                listTTMLWrapper = new List<ttmlWrapperClass>();
                setTTMLWrapper = new Set<ttmlWrapperClass>();
                for(integer i=0;i<5;i++){
                    CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                    partsoption.Technician__c = 'Select One';
                    partsoption.Type__c = 'Select One';
                    partsoption.Days__c = null;
                    partsoption.Quantity__c = null;
                    partsoption.Unit_Price__c = null;
                    partsoption.Mileage__c = null ;
                    partsoption.HoursTravelled__c = null;
                    partsoption.ExpenseTotal__c = null;
                    partsoption.Fail_Code__c = '';
                    partsoption.Account_Code__c = '';
                    partsoption.Notes__c = '';
                    List<SelectOption> lstFc = new List<SelectOption>();
                    lstFc.add(new SelectOption('Select One','Select One'));
                    setTTMLWrapper.add(new ttmlWrapperClass(ttmlPartlstUI.size()+i,null,partsoption.Technician__c,partsoption.Type__c,String.valueof(partsoption.Days__c),String.valueof(partsoption.Quantity__c),partsoption.Unit_Price__c,String.valueof(partsoption.Mileage__c),String.valueof(partsoption.HoursTravelled__c),String.valueof(partsoption.ExpenseTotal__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,partsoption.Notes__c,false,false,false,false,false,lstFc,null,false,lstFc,false,false,false,false,false));
                }
                
                system.debug('setTTMLWrapper else>>>>>>>>>>:'+setTTMLWrapper);
            }
            //System.debug('The listTTMLWrapper list is>>>>>>>>>:'+setTTMLWrapper+' displayPopup2>>>>:'+displayPopup2);
        }catch(Exception ex){
            System.debug('in catch of getallTTMLPartsData>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        
        
        //GSSC-138 START
        if( setTTMLWrapper!=null && setTTMLWrapper.size()>0){
            system.debug('mapPartsList-->'+mapPartsList);
            for(ttmlWrapperClass  s: setTTMLWrapper){
                if(s.type != null && s.type != '' && s.type != 'Select One'){
                    decimal unitPrice;
                    decimal amount;
                    Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                    
                    if(mapPartsList != null){
                        mapTemp = mapPartsList.get(s.ids);
                        
                        if(mapTemp != null){
                            for(decimal up : mapTemp.keyset()){
                                unitPrice = up;
                                amount = mapTemp.get(up);
                            }
                        }
                    }
                    unitPrice = unitPrice != null ? unitPrice.setScale(2) : null;
                    amount = amount != null ? amount.setScale(2) : null;
                    s.UnitpriceModified = null;
                    s.amountModified = null;
                    s.UnitpriceActual = unitPrice;
                    s.UnitPrice = unitPrice != null ? string.valueof(unitPrice) : null;
                    s.amountActual = amount;
                    s.expenseTotal = amount != null ? string.valueof(amount) : null;
                    system.debug('unitPrice--'+unitPrice);
                    system.debug('amount--'+amount);
                }
                else{
                    s.UnitpriceModified = null;
                    s.amountModified = null;
                    s.UnitpriceActual = null;
                    s.amountActual = null;
                }
                system.debug('s--->'+s);
            }
            listTTMLWrapper.addAll(setTTMLWrapper);
            system.debug('listTTMLWrapper>>>>>>>'+listTTMLWrapper.size());
         }
         //GSSC-138 END

        if(ttmlPartlstUI.size() > 0){
            isTTMLCovered = true;
        }
        else{
            //CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
            List<Boolean> coverageResult = new List<Boolean>();
            coverageResult = contr.checkFailuresCovered(Cid, false);
            system.debug('coverageResult--'+coverageResult);
            isTTMLCovered = coverageResult[2];
            system.debug('isTTMLCovered--'+isTTMLCovered);
        }
    }

    
    public List<SelectOption> getfailCodeValues(){    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        if(CID != null) {
            List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
            //solsComp= [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: wid AND Selected_Component__c = true AND FailCode_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution'];
            //solsComp= [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where   CSS_Claims__c=:CID AND Selected_Component__c = true AND FailCode_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution'];
            //solsComp= [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,Type__c,Fail_Code__c,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where   CSS_Claims__c=:CID AND Selected_Component__c = true AND FailCode_Formula__c != null ];
            solsComp.addAll(solsCompFailCodeVal);
            options.add(new SelectOption('Select One','Select One'));
            if(solsComp.size()>0){            
                for(CSS_Solution_Component__c f:solsComp) {
                    /* if(type == 'Commercial-Travel' || type == 'Non Commercial-Travel'){ 
if((f.CoveredTravelLabor__c != '' && f.CoveredTravelLabor__c != null && f.CoveredTravelLabor__c != '0') || (f.CoveredTravelMiles__c != '' && f.CoveredTravelMiles__c != null && f.CoveredTravelMiles__c != '0')){
if(f.FailCode_Formula__c != 'Select One')
sortableSet.add(f.FailCode_Formula__c);
}
}
else if(type == 'Meals' || type == 'Lodging'){
if(f.CoveredMealsLodgingAmt__c != '' && f.CoveredMealsLodgingAmt__c != null && f.CoveredMealsLodgingAmt__c != '0'){
if(f.FailCode_Formula__c!='Select One')
sortableSet.add(f.FailCode_Formula__c);
}
}
else if(type == 'Towing'){
if(f.CoveredTowingMiles__c != '' && f.CoveredTowingMiles__c != null && f.CoveredTowingMiles__c != '0'){
if(f.FailCode_Formula__c!='Select One')
sortableSet.add(f.FailCode_Formula__c);
}
}*/
                    if(f.FailCode_Formula__c != 'Select One')
                        sortableSet.add(f.FailCode_Formula__c);
                    // if(f.Type__c=='TRP')
                    // sortableSet.add(f.Fail_Code__c);
                }
            }
            if(sortableSet.size()>0){
                sortable.AddAll(sortableSet);
            }
            sortable.sort();
            if (sortable.size()>0){
                for(String s:sortable){    
                    options.add(new selectOption(s,s));                    
                }   
            }
        }
        return options;    
    }
    
    public void removingTTMLRow(){
        System.debug('in removingTTMLRow');
        System.debug('listTTMLWrapper IN REMOVE ROW'+listTTMLWrapper);
        try{
            listTTMLWrapper2=listTTMLWrapper.clone();
            listTTMLWrapper.clear();
            for(Integer i=0;i<listTTMLWrapper2.size();i++){
                if(listTTMLWrapper2[i].counting==selectedRemoveRow){
                    System.debug('selectedRemoveRow '+selectedRemoveRow);
                    System.debug('listTTMLWrapper2[i].counting '+listTTMLWrapper2[i].counting);
                    listTTMLWrapper2[i].technician='';
                    listTTMLWrapper2[i].type='Select One';
                    listTTMLWrapper2[i].days='';
                    listTTMLWrapper2[i].mileage=''; 
                    listTTMLWrapper2[i].hoursTraveled='';
                    listTTMLWrapper2[i].expenseTotal='';
                    listTTMLWrapper2[i].accountCode='';
                    listTTMLWrapper2[i].failCode='';
                    listTTMLWrapper2[i].notes='';
                    listTTMLWrapper2[i].showDays = false;
                    listTTMLWrapper2[i].showUP = false;
                    listTTMLWrapper2[i].showMileage = false;
                    listTTMLWrapper2[i].showMileageHT = false;
                    listTTMLWrapper2[i].accCoverage = false;
                    listTTMLWrapper2[i].isTTMLPartsCovLimitExceed = false;
                    listTTMLWrapper2[i].isTTMLMlsLodPartsCovLimitExceed = false; 
                    if(listTTMLWrapper2[i].ids != null && String.valueOf(listTTMLWrapper2[i].ids).trim() !=''){
                        removeIdsMap.put(listTTMLWrapper2[i].ids, String.valueOf(listTTMLWrapper2[i].ids));
                    }
                    System.debug('removeIdsMap>>>:'+removeIdsMap);
                }
            }
            
            listTTMLWrapper=listTTMLWrapper2.clone();
            listTTMLWrapper2.clear();
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    public void populateAmountValue(){
        
        
        system.debug('selectedRecordRowID' + '' + selectedRecordRowID);
        system.debug('listpartWrapper' + '' + listpartWrapper);
        
        
        try{
            
            for(Integer i=0;i<listpartWrapper.size();i++){
                if(listpartWrapper[i].counting==selectedRecordRowID){
                    
                    system.debug('listpartWrapper[i].coveredPercent' + '' + listpartWrapper[i].coveredPercent);
                    system.debug('listpartWrapper[i].quantity' + '' + listpartWrapper[i].quantity);
                    system.debug('listpartWrapper[i].Unitprice' + '' + listpartWrapper[i].Unitprice);
                    system.debug('listpartWrapper[i].accountCode' + '' + listpartWrapper[i].accountCode);
                    
                    //  listpartWrapper[i].amount =  Decimal.valueOf(listpartWrapper[i].quantity) * Decimal.valueOf(listpartWrapper[i].coveredPercent) * listpartWrapper[i].Unitprice;
                    //system.debug('listpartWrapper[i].amount' + ' ' + listpartWrapper[i].amount);
                    
                    if((listpartWrapper[i].quantity)!=null && 
                       (listpartWrapper[i].Unitprice!= null || listpartWrapper[i].Unitprice != 0) &&
                       //  (Decimal.valueOf(listpartWrapper[i].coveredPercent) == null) &&
                       (listpartWrapper[i].accountCode == 'Select One' || listpartWrapper[i].accountCode == '' || listpartWrapper[i].accountCode == null)) 
                    {
                        listpartWrapper[i].amount =  Decimal.valueOf(listpartWrapper[i].quantity) * listpartWrapper[i].Unitprice;
                        system.debug('sama Acc Code select one listpartWrapper[i].amount' + ' ' + listpartWrapper[i].amount);
                        //AddgetExpenseTotaled for Story 148914
                        if(listpartWrapper[i].amount>99999.99)
                        {
                            MaxAmtError = true;
                        }
                        else
                        {
                            MaxAmtError = false;
                        }
                    }
                    
                    if(listpartWrapper[i].quantity !=null && listpartWrapper[i].quantity != '' &&
                       listpartWrapper[i].Unitprice!= null &&
                       listpartWrapper[i].coveredPercent !=null && listpartWrapper[i].coveredPercent != '' && 
                       (listpartWrapper[i].accountCode != 'Select One' && listpartWrapper[i].accountCode != '' && listpartWrapper[i].accountCode != null))
                    {
                        listpartWrapper[i].amount =  Decimal.valueOf(listpartWrapper[i].quantity) * (Decimal.valueOf(listpartWrapper[i].coveredPercent)/100) * listpartWrapper[i].Unitprice;
                        system.debug(' All values not null listpartWrapper[i].amount' + ' ' + listpartWrapper[i].amount);
                        //Added for Story 148914
                        if(listpartWrapper[i].amount>99999.99)
                        {
                            MaxAmtError = true;
                        }
                        else
                        {
                            MaxAmtError = false;
                        }
                    }
                    //if(listpartWrapper[i].coveredPercent == null || listpartWrapper[i].coveredPercent == '' || listpartWrapper[i].coveredPercent == '0')
                    //  listpartWrapper[i].accountCode = 'Select One';
                    
                    //GSSC-138 start 
                    if(listpartWrapper[i].Unitprice != listpartWrapper[i].UnitpriceActual){
                        listpartWrapper[i].UnitpriceModified = listpartWrapper[i].Unitprice;
                        listpartWrapper[i].amountModified = listpartWrapper[i].amount;
                    }
                    //GSSC-138 end
                    
                }
            }
        }
        catch(exception e){
            system.debug(' sama catch block of populate amount value' + ' ' + e.getLineNumber() + ' ' + e.getMessage() );
        }
        
    }
    
    public void setAccountCode_Covered(){
        system.debug('selectedRecordRowID' + '' + selectedRecordRowID);
        system.debug('listpartWrapper' + '' + listpartWrapper);
        
        
        try{
            
            for(Integer i=0;i<listpartWrapper.size();i++){
                if(listpartWrapper[i].counting==selectedRecordRowID){
                    
                    
                    if(listpartWrapper[i].coveredPercent == null || listpartWrapper[i].coveredPercent == '' || listpartWrapper[i].coveredPercent == '0')
                        listpartWrapper[i].accountCode = 'Select One';
                    
                }
            }
        }
        catch(exception e){
            system.debug(' sama catch block of set account code covered' + ' ' + e.getLineNumber() + ' ' + e.getMessage() );
        }
        
    }
    
    public class claimablesWrapperClass{
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        public String item {get;set;}
        public String PartDescription {get;set;}
        public String quantity {get;set;}
        public Decimal amount {get;set;}
        public String coveredPercent {get;set;}
        public String failCode {get;set;}
        public String accountCode {get;set;}
        public list<SelectOption> lstFailCodes{get;set;}
        public list<SelectOption> lstAccountCodes{get;set;}
        public boolean IsManual{get;set;}
        public string previousItem {get; set;}
        public Decimal Unitprice {get; set;}
        public Decimal UnitpriceModified {get;set;} //GSSC-138
        public Decimal amountModified {get;set;} //GSSC-138
        public Decimal UnitpriceActual {get;set;} //GSSC-138
        public Decimal amountActual {get;set;} //GSSC-138
        public Boolean errorQuaUPAC {get; set;}
        public Boolean errorUP{get;set;}
        public Boolean errorAC{get;set;}
        public Boolean isPartsCovLimitExceed{get;set;}
        public Boolean isPartsCovLimitExceedPW{get;set;}
        
        public claimablesWrapperClass(Integer counting,Id ids,String item,string PartDescription,String Quantity,Decimal amount,String coveredPercent,String failCode,String accountCode, list<SelectOption> lstFailCodes,list<SelectOption> lstAccountCodes, boolean isManual,string previousItem, decimal Unitprice, Boolean errorQuaUPAC, Boolean errorUP, Boolean errorAC, decimal UnitpriceModified, decimal amountModified, decimal UnitpriceActual, decimal amountActual) {
            this.counting = counting;
            this.ids = ids;
            this.idStr = ids;
            this.item = item;
            this.PartDescription=PartDescription;
            this.quantity = quantity;
            this.amount = amount;
            this.coveredPercent = coveredPercent;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.lstFailCodes=lstFailCodes;
            this.lstAccountCodes = lstAccountCodes;
            this.isManual=isManual;
            this.previousItem=previousItem;
            this.Unitprice = Unitprice;
            this.errorQuaUPAC = errorQuaUPAC;
            this.errorUP = errorUP;
            this.errorAC = errorAC;
            this.isPartsCovLimitExceed = isPartsCovLimitExceed;
            this.isPartsCovLimitExceedPW = isPartsCovLimitExceedPW;
            this.UnitpriceModified = UnitpriceModified;
            this.amountModified = amountModified;
            this.UnitpriceActual = UnitpriceActual;
            this.amountActual = amountActual;
        }        
    }
    
    public class ttmlWrapperClass{
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        
        //The below nine columns are displayed on the TTML pop up 
        public String technician {get;set;}
        public String type {get;set;}
        public String days {get;set;}
        public String quantity {get;set;}
        public String unitPrice {get;set;}
        public String mileage {get;set;}
        public String hoursTraveled {get;set;}
        public String expenseTotal {get;set;}
        public String failCode {get;set;}
        public String accountCode {get;set;}
        public Boolean accCoverage{get;set;}
        
        
        public String notes{get;set;}
        public Boolean showDays{get;set;}
        public Boolean showMileageHT{get;set;}
        
        public Boolean showUP{get;set;}
        public Boolean showMileage{get;set;}
        public Boolean isExpenseTotal{get;set;}
        public Boolean mandateTechnician{get;set;}
        public Boolean mandateType{get;set;}
        public Boolean mandateDays{get;set;}
        public Boolean mandateUP{get;set;}
        public Boolean mandateMileage{get;set;}
        public Boolean mandateHrTr{get;set;}
        public Boolean mandateExpTotal{get;set;}
        
        public List<SelectOption> failCodelst{get;set;}
        public boolean IsManual{get;set;}
        public boolean towErrorMsg{get;set;}
        public List<SelectOption> accCodelst{get;set;}
        public Boolean mandateaccountcode{get;set;}
        public Boolean isTTMLPartsCovLimitExceed{get;set;}
        public Boolean isTTMLMlsLodPartsCovLimitExceed{get;set;}
        Public Boolean isTTMLFailcodeCovLimitExceed{get;set;}
        Public string  ttmlwrapperid{get;set;}
        Public Decimal UnitpriceModified {get;set;} //GSSC-138
        public Decimal amountModified {get;set;} //GSSC-138
        Public Decimal UnitpriceActual {get;set;} //GSSC-138
        public Decimal amountActual {get;set;} //GSSC-138
        
        public ttmlWrapperClass(Integer counting,Id ids,String technician,String type,String days,String quantity,String unitPrice,String mileage,String hoursTraveled, String expenseTotal,String failCode,String accountCode, String notes, Boolean showDays, Boolean showMileageHT,boolean showUP,boolean showMileage,Boolean accCoverage, List<SelectOption> failCodelst,boolean isManual,Boolean towErrorMsg, List<SelectOption> accCodelst, Boolean mandateaccountcode, boolean isExpenseTotal, boolean isTTMLPartsCovLimitExceed, Boolean isTTMLFailcodeCovLimitExceed, Boolean isTTMLMlsLodPartsCovLimitExceed) {
            this.counting = counting;
            this.ids = ids;
            this.idStr = ids;
            this.technician = technician;
            this.type = type;
            this.days = days;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.mileage = mileage;
            this.hoursTraveled = hoursTraveled;
            this.expenseTotal = expenseTotal;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.notes = notes;
            this.showDays = showDays;
            this.showMileageHT = showMileageHT;
            
            this.showUP = showUP;
            this.showMileage = showMileage;
            
            this.accCoverage = accCoverage;
            //this.isExpenseTotal=isExpenseTotalError;
            
            this.mandateTechnician = mandateTechnician;
            this.mandateType = mandateType;
            this.mandateDays = mandateDays;
            this.mandateUP = mandateUP;
            this.mandateMileage = mandateMileage;
            this.mandateHrTr = mandateHrTr;
            this.mandateExpTotal = mandateExpTotal;
            this.failCodelst = failCodelst;
            this.isManual=isManual;
            this.towErrorMsg = towErrorMsg;
            this.accCodelst = accCodelst;
            this.mandateaccountcode = mandateaccountcode;
            this.isExpenseTotal=isExpenseTotal;
            this.isTTMLPartsCovLimitExceed = isTTMLPartsCovLimitExceed;
            this.isTTMLFailcodeCovLimitExceed= isTTMLFailcodeCovLimitExceed;
            this.isTTMLMlsLodPartsCovLimitExceed = isTTMLMlsLodPartsCovLimitExceed;
            this.UnitpriceModified = UnitpriceModified; //GSSC-138
            this.amountModified = amountModified; //GSSC-138
            this.UnitpriceActual = UnitpriceActual; //GSSC-138
            this.amountActual = amountActual; //GSSC-138
        }        
    } 
    
    public void typeListChangeNewttmlacc(){
        try{
            /*if(accountcodeDropDownnew!=null && accountcodeDropDownnew.size() > 1){
accountcodeDropDownnew = new List<SelectOption>();
accountcodeDropDownnew.add(new SelectOption('Select One','Select One'));
}*/
            system.debug('SelectedFailCode-->'+SelectedFailCode);
            system.debug('SelectedPartID-->'+SelectedPartID);
            system.debug('SelectedType'+SelectedType);
            List<SelectOption> aC = new List<SelectOption>();
            aC = fetchAccCodeValues(SelectedType,SelectedFailCode);
            /*for(CSS_Solution_Component__c sollst1 : lstSolComp){
system.debug('lstSolComp--->'+ lstSolComp);

boolean isAccCodeAdded = false;
system.debug('isAccCodeAdded-->>>>>'+isAccCodeAdded);
system.debug('sollst1.CSS_CoverageType__c-->>>>>'+sollst1.CSS_CoverageType__c);
if(sollst1.CSS_CoverageType__c!= null){ 
if(sollst1.CSS_CoverageType__c == 'OTH' || sollst1.CSS_CoverageType__c == 'POL'){
system.debug('sollst1.CSS_CoverageType__c-->>>>>'+sollst1.CSS_CoverageType__c);
system.debug('sollst1.CSS_Account_Formula__c>>>>>'+sollst1.CSS_Account_Formula__c);
accountcodeDropDownnew.add(new selectOption(sollst1.CSS_Account_Formula__c,sollst1.CSS_Account_Formula__c));
isAccCodeAdded = true;
system.debug('isAccCodeAdded-->>>>>'+isAccCodeAdded);
}
}else{

list<CSS_JobEventTemporary__c> JETFA = new list<CSS_JobEventTemporary__c>();
string temp = sollst1.CSS_Account_Formula__c.substring(0,sollst1.CSS_Account_Formula__c.length()-3);
string temp1 = sollst1.CSS_Account_Formula__c.substring(sollst1.CSS_Account_Formula__c.length()-3,sollst1.CSS_Account_Formula__c.length()); 
system.debug('temp--->>>>'+temp);
system.debug('temp--->>>>'+temp);
temp1 = temp1.trim();
temp = temp.trim();
JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where Attribute2__c =: temp and Attribute3__c =: temp1 and  key__c = 'AccountCodes' limit 1];
system.debug('JETFA'+JETFA);
if(JETFA!= null && JETFA.size()>0){
if(JETFA[0].Attribute1__c == 'OTH' || JETFA[0].Attribute1__c == 'POL'){
system.debug('JETFA[0].Attribute1__c'+JETFA[0].Attribute1__c);   

accountcodeDropDownnew.add(new selectOption(sollst1.CSS_Account_Formula__c,sollst1.CSS_Account_Formula__c));
isAccCodeAdded = true;
} 

}
}
//  system.debug('isFailCodeAdded--->>>'+isFailCodeAdded);
if(isAccCodeAdded == false){
if( SelectedItem == 'Commercial-Travel'){
if(integer.valueof(sollst1.CoveredTravelBaseFareAmt__c)>0 && integer.valueof(sollst1.CoveredTravelLabor__c)>0){

accountcodeDropDownnew.add(new selectOption(sollst1.CSS_Account_Formula__c,sollst1.CSS_Account_Formula__c));
isAccCodeAdded = true;
}
}else if(SelectedItem =='Non Commercial-Travel'){
if(integer.valueof(sollst1.CoveredTravelMiles__c)>0 && integer.valueof(sollst1.CoveredTravelLabor__c)>0){
accountcodeDropDownnew.add(new selectOption(sollst1.CSS_Account_Formula__c,sollst1.CSS_Account_Formula__c));
isAccCodeAdded = true;
} 
}else if(SelectedItem =='Towing'){
if(integer.valueof(sollst1.CoveredTravelMiles__c)>0){
accountcodeDropDownnew.add(new selectOption(sollst1.CSS_Account_Formula__c,sollst1.CSS_Account_Formula__c));
isAccCodeAdded = true;
}
}else if(SelectedItem == 'Meals'){
if(integer.valueof(sollst1.CoveredMealsLodgingAmt__c)>0){
accountcodeDropDownnew.add(new selectOption(sollst1.CSS_Account_Formula__c,sollst1.CSS_Account_Formula__c));
isAccCodeAdded = true;
}
}else if(SelectedItem == 'Lodging'){
if(integer.valueof(sollst1.CoveredMealsLodgingAmt__c)>0){
accountcodeDropDownnew.add(new selectOption(sollst1.CSS_Account_Formula__c,sollst1.CSS_Account_Formula__c));
isAccCodeAdded = true;
}
}
}

}*/
            
            for(ttmlWrapperClass  prtslist : listTTMLWrapper){
                //  part1.Type__c = 'Commercial-Travel' && (CoveredTravelBaseFareAmt__c< 0) && (CoveredTravelLabor__c<0)
                if(prtslist.counting == SelectedPartID){
                    /*prtslist.days = '';
prtslist.Quantity = '';
prtslist.mileage = '';
prtslist.hoursTraveled = '';
prtslist.expenseTotal = '';*/
                    prtslist.failCode = SelectedFailCode;//'Select One';
                    prtslist.accCodelst = new List<SelectOption>();
                    List<SelectOption> fC = new List<SelectOption>();
                    //prtslist.accountCode = '';
                    prtslist.accCoverage = false;
                    
                    system.debug('aC-->'+aC + 'ac Size()--- ' + aC.size());
                    if(prtslist.failCode != 'Select One'){
                        prtslist.accountCode = ttmlAccCode;
                        if(aC.size() >0 ){  
                            system.debug('**Inside if**');
                            prtslist.accCodelst.addAll(aC);
                        }
                        else{
                            system.debug('**Inside else**');
                            prtslist.accCodelst.addAll(aC);
                            prtslist.accountCode = 'Select One';
                        }
                    }
                    else{
                        List<SelectOption> opt = new List<SelectOption>();
                        opt.add(new SelectOption('Select One','Select One'));
                        prtslist.accountCode = 'Select One';
                        prtslist.accCodelst.addAll(opt);
                        
                    }
                    system.debug('prtslist.accCodelst'+prtslist.accCodelst);
                    system.debug('prtslist.type***'+prtslist.type);
                    if(prtslist.type != 'Select One' && prtslist.type != 'Towing'){
                        /*if(prtslist.type == 'Commercial-Travel'){
prtslist.showDays = false;
prtslist.showMileageHT = true;
prtslist.towErrorMsg = false;
towErrorOutputMsg = false;
}
else if (prtslist.type == 'Commercial-Travel') {
prtslist.showDays = false;
prtslist.showMileageHT = true;
prtslist.towErrorMsg = false;
towErrorOutputMsg = false;
}
else{
prtslist.showDays = true;
prtslist.showMileageHT = true;
prtslist.towErrorMsg = false;
towErrorOutputMsg = false;
}*/
                        if(prtslist.type == 'Meals' || prtslist.type == 'Lodging' ){
                            system.debug('*****Inside M and L***');
                            prtslist.showDays=true;
                            prtslist.showUP = true;
                            prtslist.showMileage=false;
                            prtslist.showMileageHT=false;
                        }
                        else if(prtslist.type == 'Commercial-Travel'){
                            system.debug('**inside Commertial**');
                            system.debug('** claimsRec.css_job__c**'+claimsRec.css_job__c);
                            if(DealerTypeFlag== true){
                                system.debug('**claimsRec.Account__r.type**'+claimsRec.Account__r.type);
                                prtslist.showDays = false;
                                prtslist.showMileageHT = true;
                                prtslist.showMileage= false;
                                prtslist.showUP = true;
                            }                        
                            else{
                                if( claimsRec.css_job__c==null){
                                    system.debug('**else claimsRec.Account__r.type**'+claimsRec.Account__r.type);
                                    prtslist.showDays = false;
                                    prtslist.showMileageHT = true;
                                    prtslist.showMileage= false;
                                    prtslist.showUP = true;
                                }
                                else{
                                    system.debug('**else claimsRec.Account__r.type**'+claimsRec.Account__r.type);
                                    prtslist.showDays = true;
                                    prtslist.showMileageHT = false;
                                    prtslist.showMileage= false;
                                    prtslist.showUP = true;
                                }
                            }
                        }
                        else if(prtslist.type == 'Non Commercial-Travel'){
                            prtslist.UnitpriceModified=null;
                            if(DealerTypeFlag== true){
                                prtslist.showDays = false;
                                prtslist.showUP = false;
                                prtslist.showMileage= true;
                                prtslist.showMileageHT = true;
                                
                            }
                            else{
                                if(claimsRec.css_job__c!=null){
                                    prtslist.showDays = false;
                                    prtslist.showUP = true;
                                    prtslist.showMileageHT = true;
                                    prtslist.showMileage= false;
                                }
                                else{
                                    //system.debug('***inside if else claimsRec css_job__c ***'+claimsRec.css_job__c);
                                    prtslist.showDays = false;
                                    prtslist.showUP = false;
                                    prtslist.showMileageHT = true;
                                    prtslist.showMileage= true;   
                                }
                            }
                        }    
                        else{
                            prtslist.showDays = false;
                            prtslist.showMileageHT = false;
                            prtslist.towErrorMsg = false;
                            towErrorOutputMsg = false;
                        }
                    }
                    else if(prtslist.type == 'Towing'){
                        
                        system.debug('*****Inside Towing Method***');
                        prtslist.showDays=true;
                        prtslist.showUP = true;
                        prtslist.showMileage=false;
                        prtslist.showMileageHT=false;
                        
                        // Need conformation on Dealer and DLR : no data available for Dealer and DLR
                        
                        
                        /*   if(dealer == 'DLR'){
towErrorOutputMsg = false;
prtslist.towErrorMsg = false;
}
else{
towErrorOutputMsg = true; 

prtslist.towErrorMsg = true;    
}
//prtslist.showDays = false;
if(dealer == 'DLR')
prtslist.showDays = true;
else
prtslist.showDays = false;
if(dealer == 'DLR')
prtslist.showMileageHT = true;
else
prtslist.showMileageHT = false;*/
                        //prtslist.showMileageHT = true;
                        //prtslist.showMileageHT = false;
                    }
                    else{
                        //prtslist.technician = '';
                        if(prtslist.type == 'Select One')
                            prtslist.notes = '';
                        prtslist.days = '';
                        prtslist.mileage = '';
                        prtslist.hoursTraveled = '';
                        prtslist.expenseTotal = '';                            
                        prtslist.showDays = false;
                        prtslist.showUp = false;
                        //prtslist.showDays = false;
                        prtslist.showMileageHT = false;
                        prtslist.towErrorMsg = false;
                        towErrorOutputMsg = false;
                    }
                    
                    //}
                    // break;
                }
                
                
            }
        }catch(Exception ex){
            system.debug('catchkarthik---->>:' +ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        
    }
    
    public List<SelectOption> fetchfailCodeValuesNew(String type){
        system.debug('insidefailcodevaluesnew');
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        //solsComp= [SELECT Id,CSS_Account_Formula__c, Type__c, CSS_CoverageType__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, Parts_Warranty__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =: wid AND ((Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null ) OR (Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
        solsComp.addAll(solsCompFailCodeValNew);
        system.debug('solsComp-->'+solsComp);
        options.add(new SelectOption('Select One','Select One'));
        if(solsComp.size()>0 && type!='Select One'){
            for(CSS_Solution_Component__c sollst1:solsComp) {
                if(sollst1.Over_The_Counter__c != true){ //Added if condition as part of the story GSSC-298
                    Boolean isFailCodeAdded = false;
                    if(sollst1.CSS_CoverageType__c!= null){ 
                        if(sollst1.CSS_CoverageType__c == 'OTH' || sollst1.CSS_CoverageType__c == 'POL'){
                            system.debug('sollst1.CSS_CoverageType__c-->>>>>'+sollst1.CSS_CoverageType__c);
                            system.debug('sollst1.FailCode_Formula__c>>>>>'+sollst1.FailCode_Formula__c);
                            sortableSet.add(sollst1.FailCode_Formula__c);
                            isFailCodeAdded = true;
                            system.debug('isFailCodeAdded-->>>>>'+isFailCodeAdded);
                        }
                    }
                    else{
                        system.debug('insideelse');
                        //list<CSS_JobEventTemporary__c> JETFA = new list<CSS_JobEventTemporary__c>();
                        string temp = sollst1.CSS_Account_Formula__c.substring(0,sollst1.CSS_Account_Formula__c.length()-3);
                        string temp1 = sollst1.CSS_Account_Formula__c.substring(sollst1.CSS_Account_Formula__c.length()-3,sollst1.CSS_Account_Formula__c.length()); 
                        system.debug('temp--->>>>'+temp);
                        system.debug('temp1--->>>>'+temp1);
                        temp1 = temp1.trim();
                        temp = temp.trim();
                        string temp2 = temp + temp1;
                        //JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where Attribute2__c =: temp and Attribute3__c =: temp1 and  key__c = 'AccountCodes' limit 1];
                        //system.debug('JETFA'+JETFA);*/
                        CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                        jetSingle = accCodeMapJET.get(temp2);
                        if(jetSingle!= null){
                            if(jetSingle.Attribute1__c == 'OTH' || jetSingle.Attribute1__c == 'POL'){
                                system.debug('jetSingle.Attribute1__c'+jetSingle.Attribute1__c);   
                                sortableSet.add(sollst1.FailCode_Formula__c);
                                isFailCodeAdded = true;
                            } 
                            
                        }
                    }
                    system.debug('isFailCodeAdded--->>>'+isFailCodeAdded);
                    if(isFailCodeAdded == false){
                        if(sollst1.Type__c != 'Campaign' && sollst1.Type__c != 'TRP' && sollst1.Type__c != 'ATC'){
                            if(type != null && type != '' && type.equalsIgnoreCase('Commercial-Travel') && sollst1.CoveredTravelBaseFareAmt__c!=null){
                                if(sollst1.CoveredTravelBaseFareAmt__c!= null && double.valueof(sollst1.CoveredTravelBaseFareAmt__c)>0 && sollst1.CoveredTravelLabor__c!=null &&  double.valueof(sollst1.CoveredTravelLabor__c)>0){
                                    sortableSet.add(sollst1.FailCode_Formula__c);
                                    isFailCodeAdded = true;
                                }
                            }else if(type != null && type != '' && type.equalsIgnoreCase('Non Commercial-Travel')){
                                if(sollst1.CoveredTravelMiles__c!=null && double.valueof(sollst1.CoveredTravelMiles__c)>0 && sollst1.CoveredTravelLabor__c!=null && double.valueof(sollst1.CoveredTravelLabor__c)>0){
                                    sortableSet.add(sollst1.FailCode_Formula__c);
                                    isFailCodeAdded = true;
                                } 
                            }else if(type != null && type != '' && type.equalsIgnoreCase('Towing')){
                                if(sollst1.CoveredTowingMiles__c!=null && double.valueof(sollst1.CoveredTowingMiles__c)>0){
                                    sortableSet.add(sollst1.FailCode_Formula__c);
                                    isFailCodeAdded = true;
                                }
                            }else if((type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                                if(sollst1.CoveredMealsLodgingAmt__c!=null && double.valueof(sollst1.CoveredMealsLodgingAmt__c)>0){
                                    sortableSet.add(sollst1.FailCode_Formula__c);
                                    isFailCodeAdded = true;
                                }
                            }
                        }
                        else{
                            system.debug('inside else'+type);
                            system.debug('sollst1.CampaignTravelPercentage__c'+sollst1.CampaignTravelPercentage__c);
                            if((type != null && type != '' && type.equalsIgnoreCase('Commercial-Travel')) || (type != null && type != '' && type.equalsIgnoreCase('Non Commercial-Travel')) || (type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                                if(sollst1.CampaignTravelPercentage__c!=null && double.valueof(sollst1.CampaignTravelPercentage__c)>0){
                                    system.debug('sollst1.CampaignTravelPercentage__c'+sollst1.CampaignTravelPercentage__c);
                                    sortableSet.add(sollst1.FailCode_Formula__c);
                                    isFailCodeAdded = true;
                                }
                            }
                            else if(type != null && type != '' && type.equalsIgnoreCase('Towing')){
                                system.debug('inside else of Campaign towing'+sollst1.CampaignTowingPercentage__c);
                                if(sollst1.CampaignTowingPercentage__c!=null && double.valueof(sollst1.CampaignTowingPercentage__c)>0){
                                    sortableSet.add(sollst1.FailCode_Formula__c);
                                    isFailCodeAdded = true;
                                }
                            }
                        }
                    }
                }
            }
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);
        }
        sortable.sort();
        if(sortable.size()>0){
            for(String s:sortable){    
                options.add(new selectOption(s,s));                    
            }   
        }
        system.debug('selectOption'+options);
        return options;    
    }
    
    public List<SelectOption> fetchAccCodeValues(String type, String failCodeSelected){
        system.debug('insideaccode');
        system.debug('type'+type);
        system.debug('failCodeSelected'+failCodeSelected);
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        //solsComp= [SELECT  Id,CSS_Account_Formula__c, CSS_CoverageType__c, Parts_Warranty__c,Type__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =: wid AND ((Selected_Component__c = true AND FailCode_Formula__c =: failCodeSelected AND CSS_Account_Formula__c != null) OR (Selected_Component__c = true AND FailCode_Formula__c =: failCodeSelected AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
        for(CSS_Solution_Component__c solsCompFailCodeValNew1 : solsCompFailCodeValNew) {
            if(solsCompFailCodeValNew1.FailCode_Formula__c == failCodeSelected)
                solsComp.add(solsCompFailCodeValNew1);
        }
        //solsComp.addAll(solsCompFailCodeValNew);
        system.debug('solsComp'+solsComp);
        options.add(new SelectOption('Select One','Select One'));
        if(solsComp.size()>0){
            system.debug('inside main if');
            for(CSS_Solution_Component__c sollst1:solsComp) {
                if(sollst1.Over_The_Counter__c != true){ //Added if condition as part of the story GSSC-298
                    Boolean isAccCodeAdded = false;
                    system.debug('sollst1.CSS_CoverageType__c'+sollst1.CSS_CoverageType__c);
                    if(sollst1.CSS_CoverageType__c!= null){ 
                        if(sollst1.CSS_CoverageType__c == 'OTH' || sollst1.CSS_CoverageType__c == 'POL'){
                            system.debug('sollst1.CSS_CoverageType__c-->>>>>'+sollst1.CSS_CoverageType__c);
                            system.debug('sollst1.CSS_Account_Formula__c>>>>>'+sollst1.CSS_Account_Formula__c);
                            sortableSet.add(sollst1.CSS_Account_Formula__c);
                            isAccCodeAdded = true;
                            system.debug('isAccCodeAdded-->>>>>'+isAccCodeAdded);
                        }
                    }
                    else{
                        system.debug('insideelse');
                        //list<CSS_JobEventTemporary__c> JETFA = new list<CSS_JobEventTemporary__c>();
                        string temp = sollst1.CSS_Account_Formula__c.substring(0,sollst1.CSS_Account_Formula__c.length()-3);
                        string temp1 = sollst1.CSS_Account_Formula__c.substring(sollst1.CSS_Account_Formula__c.length()-3,sollst1.CSS_Account_Formula__c.length()); 
                        system.debug('temp--->>>>'+temp);
                        system.debug('temp1--->>>>'+temp1);
                        temp1 = temp1.trim();
                        temp = temp.trim();
                        string temp2 = temp + temp1;
                        //JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where Attribute2__c =: temp and Attribute3__c =: temp1 and  key__c = 'AccountCodes' limit 1];
                        //system.debug('JETFA'+JETFA);*/
                        CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                        jetSingle = accCodeMapJET.get(temp2);
                        if(jetSingle!= null){
                            if(jetSingle.Attribute1__c == 'OTH' || jetSingle.Attribute1__c == 'POL'){
                                system.debug('jetSingle.Attribute1__c'+jetSingle.Attribute1__c);   
                                sortableSet.add(sollst1.CSS_Account_Formula__c);
                                isAccCodeAdded = true;
                            } 
                            
                        }
                    }
                    system.debug('isAccCodeAdded--->>>'+isAccCodeAdded);
                    if(isAccCodeAdded == false){
                        system.debug('type-->'+type);
                        if(sollst1.Type__c != 'Campaign' && sollst1.Type__c != 'TRP' && sollst1.Type__c != 'ATC'){
                            if(type != null && type != '' && type.equalsIgnoreCase('Commercial-Travel')){
                                if(sollst1.CoveredTravelBaseFareAmt__c!=null && double.valueof(sollst1.CoveredTravelBaseFareAmt__c)>0 && sollst1.CoveredTravelLabor__c != null && double.valueof(sollst1.CoveredTravelLabor__c)>0){
                                    sortableSet.add(sollst1.CSS_Account_Formula__c);
                                    isAccCodeAdded = true;
                                    system.debug('isAccCodeAdded'+isAccCodeAdded);
                                }
                            }
                            else if(type != null && type != '' && type.equalsIgnoreCase('Non Commercial-Travel')){
                                system.debug(sollst1.CoveredTravelMiles__c);
                                system.debug(sollst1.CoveredTravelLabor__c);
                                if(sollst1.CoveredTravelMiles__c!=null && double.valueof(sollst1.CoveredTravelMiles__c)>0 && sollst1.CoveredTravelLabor__c!=null && double.valueof(sollst1.CoveredTravelLabor__c)>0){
                                    sortableSet.add(sollst1.CSS_Account_Formula__c);
                                    isAccCodeAdded = true;
                                    system.debug('isAccCodeAdded'+isAccCodeAdded);
                                } 
                            }
                            else if(type != null && type != '' && type.equalsIgnoreCase('Towing')){
                                if(sollst1.CoveredTowingMiles__c!=null && double.valueof(sollst1.CoveredTowingMiles__c)>0){
                                    sortableSet.add(sollst1.CSS_Account_Formula__c);
                                    isAccCodeAdded = true;
                                    system.debug('isAccCodeAdded'+isAccCodeAdded);
                                }
                            }else if((type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                                if(sollst1.CoveredMealsLodgingAmt__c!=null && double.valueof(sollst1.CoveredMealsLodgingAmt__c)>0){
                                    sortableSet.add(sollst1.CSS_Account_Formula__c);
                                    isAccCodeAdded = true;
                                    system.debug('isAccCodeAdded'+isAccCodeAdded);
                                }
                            }
                        }
                        else{
                            if((type != null && type != '' && type.equalsIgnoreCase('Commercial-Travel')) || (type != null && type != '' && type.equalsIgnoreCase('Non Commercial-Travel')) || (type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                                if(sollst1.CampaignTravelPercentage__c!=null && double.valueof(sollst1.CampaignTravelPercentage__c)>0){
                                    sortableSet.add(sollst1.CSS_Account_Formula__c);
                                    isAccCodeAdded = true;
                                    system.debug('isAccCodeAdded'+isAccCodeAdded);
                                }
                            }
                            else if(type != null && type != '' && type.equalsIgnoreCase('Towing')){
                                if(sollst1.CampaignTowingPercentage__c!=null && double.valueof(sollst1.CampaignTowingPercentage__c)>0){
                                    sortableSet.add(sollst1.CSS_Account_Formula__c);
                                    isAccCodeAdded = true;
                                    system.debug('isAccCodeAdded'+isAccCodeAdded);
                                }
                            }
                        }
                    }
                }
            }
            system.debug('sortableSetsize-->'+sortableSet.size()+'****'+sortableSet);
            if(solsComp.size()==1 || sortableSet.size()==1)
                ttmlAccCode=solsComp[0].CSS_Account_Formula__c;
            else
                ttmlAccCode='Select One';
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);
        }
        sortable.sort();
        if(sortable.size()>0){
            for(String s:sortable){    
                options.add(new selectOption(s,s));                    
            }   
        }
        system.debug('options-->'+options);
        return options;    
    }
    
}