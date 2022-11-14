/*
 * Block comments with details of changes
 */
public class CSS_OtherClaimablesController_RO
{
    //Variable Declarations 
    public boolean showPopup{get;set;}
    public boolean ErrorMessage {get; set;}
    public boolean ErrorMessage1 {get; set;}
    public boolean ErrorMessage2 {get; set;}
    public boolean qtyErrorMessage{get;set;}//Added for Story 175943
    public boolean twoerrormsg{get; set;}
    public boolean errorDisplay{get;set;}
    public boolean errorDisplay1 {get;set;}
    public boolean NonPartsWarrantyFlag {get;set;} // 53
    public boolean PartsWarrantyFlag {get;set;}
    public String compareaccode {get;set;}
    public id Wid; 
    public Id pgId{get;set;}
    public user usercurreny{get;set;}
    public list<CSS_Parts_Options__c> customPartlstUI{get; set;}
    public list<CSS_Parts_Options__c> otherClaimPartList{get; set;}
    public Boolean displayPopup2{get;set;}  
    public boolean chkReqField{get;set;}
    public boolean isTTMLNPWAccCodeCovLimitError{get;set;}
    public boolean isTTMLPWAccCodeCovLimitError{get;set;}
    public Id recTypeIdpart;
    public Id recTypeIdTTML;
    public String AccCodeError {get;set;} //Story-53
    public String AccCodeLabError {get;set;} //Story-53
    public String AccCodeMealsError {get;set;} //Story-53
    public Map<Id, String> removeIdsMap = new Map<Id, String>();
    public String JobId { get; set; }
    public List<claimablesWrapperClass> listpartWrapper {get;set;}   
    public List<claimablesWrapperClass> listpartWrapper2 {get;set;}   
    public Set<claimablesWrapperClass> setpartWrapper {get;set;}    
    public Set<claimablesWrapperClass> setpartWrapper1 {get;set;} 
    //Added for percentage Covered based on fail Code*
    public String SelectedFailCode{get;set;}
    public integer  SelectedPartID{get;set;}
    public String SelectedItem{get;set;}
    public String SelectedAccountCode{get;set;}
    public Integer selectedRemoveRow {get; set;}
    public Boolean selectedEstimate{get;set;}
    public String SelectedQty{get;set;}
    public Id selectedPart{get;set;}
    public boolean isExpenseTotalError {get;set;}
    public List<CSS_Parts_Options__c> ttmlPartsList{get; set;}
    public List<ttmlWrapperClass> listTTMLWrapper {get; set;}
    public List<ttmlWrapperClass> listTTMLWrapper2 {get; set;}
    public List<ttmlWrapperClass> listTTMLWrapper3 {get; set;}
    public Set<ttmlWrapperClass> setTTMLWrapper {get;set;}
    public List<CSS_Parts_Options__c> ttmlPartlstUI {get;set;}
    public Transient List<CSS_Parts_Options__c> newPartlstUI {get;set;} // Added by rajesh and vamshi defect 737
    public String selectedType {get;set;}
    public Boolean ttmlReqErrMsg {get;set;}
    public Boolean trveltowingerrmsg {get;set;}
    public Boolean duplicateAccountCode {get;set;}
    public Boolean amountcodegrt {get;set;}
    public decimal totalamount{get;set;}
    //public Boolean showFailCode {get;set;}
    public decimal comt {get;set;}       
    public decimal ncomt {get;set;}           
    public decimal towt {get;set;}     
    public decimal meals {get;set;}    
    public decimal lodg {get;set;}    
    public decimal totalexp {get;set;}
    public Boolean towErrorOutputMsg {get;set;}
    public boolean isOneBMS { get; set; }
    public boolean checktravelratedlr{get;set;} 
    public boolean checktravelratedist{get;set;}
    public boolean ShowTravelRateerr{get;set;}
    public string dealer {get; set; }
    public Integer selectedRecordRowID {get; set;}
    public list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
    // public String coverageType;
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
    String ttmlAccCode;
    public Map<String,CSS_JobEventTemporary__c> accCodeMapJET = new Map<String,CSS_JobEventTemporary__c>();
    public Map<String, String> accCodeCovTypeMap = new Map<String, String>();
    public Map<String,set<String>> failAccountCodeMap{get;set;}
    public String coverageType;
    public Boolean isDealer {get; set;}
    public Set<String> errMsgLst{get; set;}
    public List<String> errMsgLstNew{get;set;}
    public boolean DealerTypeFlag {get;set;}//venkat
    public List<String> Parterrors{get;set;}
    public List<String> NonParterrors{get;set;}
    public Boolean TravelTowingError {get;set;}
    public Boolean TravelTowingTTMLError {get;set;}
    public List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
    
    public CSS_OtherClaimablesController_RO()
    {
        isOneBMS = false;
        isExpenseTotalError = false;
        qtyErrorMessage = false;
        isMealsExpenseTotalError = false;
        isLodgingExpenseTotalError=false;
        isTowingExpenseTotalError=false;
        checktravelratedlr=false;
        checktravelratedist=false;
        ShowTravelRateerr=false;
        Parterrors = new List<String>(); 
        NonParterrors = new List<String>(); 
        pgId = ApexPages.CurrentPage().getParameters().get('id');
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        
        String orgType = css_utility.getOrgType(UserInfo.getUserId());
        if(orgType == 'DLR'){
            isDealer = true;
        }
        else{
            isDealer = false;
        }
        
        usercurreny = [SELECT id,Name,DefaultCurrencyIsoCode,CurrencyIsoCode FROM user where Id = : UserInfo.getUserId() limit 1];
        system.debug('Testcurr'+usercurreny);
//GSSC-442 commented below query
        /*css_job_order__c jobData = [select Id,Account__r.Type,CSS_Travel_Rate__c, Account__c from css_job_order__c where Id = : Wid];//, Account__r.ERP_System__c
        if(jobData != null && jobData.Account__c != null ) {//&& jobData.Account__r.ERP_System__c != null && jobData.Account__r.ERP_System__c == 'One BMS'
            Account Acc = [Select Id, ERP_System__c from Account where Id =: jobData.Account__c];
            if(Acc.ERP_System__c != null && Acc.ERP_System__c == 'One BMS') 
                isOneBMS = true;
        }
        if(string.isBlank(jobData.CSS_Travel_Rate__c) || (string.isNotBlank(jobData.CSS_Travel_Rate__c) && double.valueOf(jobData.CSS_Travel_Rate__c)==0))
        {
            if(isDealer == true)//(jobData.IsDealerjob__c)
            {
                checktravelratedlr=true;
                checktravelratedist=false;
            }
            else
            {
                checktravelratedlr=false;
                checktravelratedist=true;
            }
        }
        JETFA = new list<CSS_JobEventTemporary__c>();
        JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,Account_Code__c ,key__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
        for(CSS_JobEventTemporary__c jet : JETFA){
            string temp = jet.Attribute2__c+jet.Attribute3__c; 
            if(!accCodeMapJET.containskey(temp))
                accCodeMapJET.put(temp,jet);
        }
        for(CSS_JobEventTemporary__c jet : JETFA){
            if(!accCodeCovTypeMap.containsKey(jet.Attribute3__c)){
                accCodeCovTypeMap.put(jet.Attribute3__c, jet.Attribute1__c);
            }
        }
        //GSSC-442 commented below query
        //GSSC-138-start    
       /* if(userinfo.getDefaultCurrency() == 'USD'){
            lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c order by Bolt_Version__c desc limit 1];
        }
        else{
            lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1];
        }*/
        //GSSC-138-end
        
        newPartlstUI = new List<CSS_Parts_Options__c>(); 
        newPartlstUI = [select Id,Service_Job__c,Item__c,Part_Description__c,Get_Fail_Code_Formula__c,Quantity__c,Unit_Price__c,amount__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Exchange_Rate__c, Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,Comments__c,PartOC__c,Covered__c,Fail_Code__c,Account_Code__c,
                             Technician__c, Type__c, Siebel_Value__c,Misc_LOV__c,Days__c, Mileage__c, HoursTravelled__c, Notes__c, ExpenseTotal__c,FailurepartId__r.CoveredOCAmount__c,RecordType.Name,ODM_Status__c 
                             from CSS_Parts_Options__c where Service_Job__c =:Wid ORDER BY CreatedDate];
                             
        /*getItems();
        getTTMLType();
        getallCustomPartsData(false);
        getAllTTMLPartsData();*/
        saveExpenseTotal();
        //Start code   as per story #148900 ,By RAJESH 10th Jan 2019
        /*isMealsExpenseTotalError=false;
        isLodgingExpenseTotalError=false;
        isTowingExpenseTotalError=false;
        //End code   as per story #148900 ,By RAJESH 10th Jan 2019
        system.debug('workJOb.Account__'+jobData);
        DealerTypeFlag = CSS_utility.getAccounttype(jobData.Account__r.Type);//Venkat
        dealer = css_utility.getOrgType(userInfo.getUserID()); 
        lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,Type__c,Selected_Component__c,CoveredOCAmount__c ,CampaignTowingPercentage__c,CoveredTravelBaseFareAmt__c,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c,FailCode_Formula__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c,CSS_CoverageType__c from CSS_Solution_Component__c where Service_Job__c =:wid AND Selected_Component__c = true AND CSS_Account_Formula__c != null];
        */
    }
    
    
    public string BMSChargesErrMsg{get;set;}
    
    public double octotalusd{get; set;}
    public void getOCData()
    {
        List<CSS_Parts_Options__c> lstAllParts = new List<CSS_Parts_Options__c>();
        css_utility utility = new css_utility();
        Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
        
        /*Commented below code as part of 101 SOQL fix
        otherClaimPartList = [select Id, Service_Job__c, selected_part__c,ExpenseTotal__c, Item__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Part_Description__c,Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,PartOC__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                              Account_Code__c, Notes__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c,RecordType.Name,ODM_Status__c  from CSS_Parts_Options__c where Service_Job__c =:Wid and (RecordType.Name ='OtherClaimables' or PartOC__c = 'OC')];
        
        ttmlPartsList = [select Id, Service_Job__c, FailurepartId__r.CoveredOCAmount__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Unit_Price__c,Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,PartOC__c,selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                         Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c,Comments__c, Technician__c, Type__c, Days__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c,RecordType.Name,ODM_Status__c 
                         from CSS_Parts_Options__c where Service_Job__c =:Wid and (RecordType.Name ='TTML'  or PartOC__c = 'TOW')];
        */
        otherClaimPartList = new List<CSS_Parts_Options__c>();
        ttmlPartsList = new List<CSS_Parts_Options__c>();
        if(newPartlstUI!=null && newPartlstUI.size()>0){
            for(CSS_Parts_Options__c p :newPartlstUI){
                if(p.RecordType.Name == 'OtherClaimables' || p.PartOC__c == 'OC'){
                    otherClaimPartList.add(p);
                }
                if(p.RecordType.Name =='TTML'  || p.PartOC__c == 'TOW'){
                    ttmlPartsList.add(p);
                }
            }
        }
        
        lstAllParts.addAll(otherClaimPartList);
        lstAllParts.addAll(ttmlPartsList);
        
        mapPartsList = utility.displayParts(lstAllParts);
        system.debug('mapPartsList--'+mapPartsList);
        
        for(CSS_Parts_Options__c ttmlPart : ttmlPartsList){
            //GSSC-138 start
            if(mapPartsList != null){
                Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                mapTemp = mapPartsList.get(ttmlPart.Id);
                
                if(mapTemp != null){
                    for(decimal up : mapTemp.keyset()){
                        ttmlPart.Unit_Price__c = string.valueof(up);
                        ttmlPart.ExpenseTotal__c = mapTemp.get(up);
                    }
                }
            }
            //GSSC-138 end
        }
            
        //Updating total OC to Expense Total
        for(CSS_Parts_Options__c ocp:otherClaimPartList)
        {
            integer ocperreq = Integer.valueOf(ocp.Covered__c);
            octotalusd= (ocperreq!=null?ocperreq:0/100)*(ocp.Sell_Price__c!=null?integer.valueof(ocp.Sell_Price__c):0)*(ocp.Quantity__c!=null?ocp.Quantity__c:0);
            ocp.ExpenseTotal__c=octotalusd;
            
            //GSSC-138 start
            if(mapPartsList != null){
                Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                mapTemp = mapPartsList.get(ocp.Id);
                
                if(mapTemp != null){
                    for(decimal up : mapTemp.keyset()){
                        ocp.Sell_Price__c = up;
                        ocp.amount__c = mapTemp.get(up);
                    }
                }
            }
            //GSSC-138 end
            
        }
        getItems();
       
    }
    
    
    
    
    //Method to close the pop up 
    
    //Method to save the part's records from Popup
    
    
    
    
    
    
    //Method for display the fail codes from UI side as per #105558 (RAJESH)
    
    //END
    
    
        //New Method for getting Failcode and Account codes as per story GSSC-142 -By RAJESH 22nd Oct 2019 
    
    //END
    
    
    
    
    
    
    //Logic for account Code dispaly  #105559 story 
    
    public css_job_order__c workJob {get;set;}
    public list<string> lstAccountCodes{get;set;}
    public List<SelectOption> accCodes{get;set;}
    public list<CSS_JobEventTemporary__c> jobEventTemp {get;set;}
     
    
    
   
    

   
    //Method for getting %coverd when we are chaning Account codes as per #105557 (RAJESH)
    
    
    
  
    
    public class claimablesWrapperClass {
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
        public String PartOC {get;set;}
        Public Decimal WarrantyAllocation {get;set;}
        Public String QuantityOrdered {get;set;}
        Public Decimal Sellprice {get;set;}
        Public Boolean showaccountcode {get;set;}
        public Boolean errorQua {get; set;}
        public Boolean errorUP {get;set;}
        Public Decimal Unitprice {get;set;}
        Public Decimal UnitpriceModified {get;set;} //GSSC-138
        public Decimal amountModified {get;set;} //GSSC-138
        Public Decimal UnitpriceActual {get;set;} //GSSC-138
        public Decimal amountActual {get;set;} //GSSC-138
        public list<SelectOption> lstFailcodes{get;set;}
        public list<SelectOption> lstFCAC{get;set;}
        public Boolean isPartsCovLimitExceed{get;set;}
        public claimablesWrapperClass(Integer counting,Id ids,String item,string PartDescription,String Quantity,Decimal amount,String coveredPercent,String failCode,String accountCode,String PartOC,Decimal WarrantyAllocation,String QuantityOrdered,Decimal Sellprice,Boolean showaccountcode,Decimal Unitprice,list<SelectOption> lstFailcodes,list<SelectOption> lstFCAC,Boolean errorQua, Boolean errorUP, decimal UnitpriceModified, decimal amountModified, decimal UnitpriceActual, decimal amountActual) {
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
            this.PartOC = PartOC;
            this.WarrantyAllocation = WarrantyAllocation;
            this.QuantityOrdered = QuantityOrdered;
            this.Sellprice = Sellprice;
            this.showaccountcode=showaccountcode;
            this.Unitprice = Unitprice;
            this.lstFailcodes=lstFailcodes;
            this.lstFCAC = lstFCAC;
            this.errorQua = errorQua;
            this.errorUP = errorUP;
            this.isPartsCovLimitExceed = isPartsCovLimitExceed;
            this.UnitpriceModified = UnitpriceModified;
            this.amountModified = amountModified;
            this.UnitpriceActual = UnitpriceActual;
            this.amountActual = amountActual;
        }        
    }
    
    public class ttmlWrapperClass {
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        public String technician {get;set;}
        public String type {get;set;}
        public String days {get;set;}
        public String mileage {get;set;}
        public String hoursTraveled {get;set;}
        public String expenseTotal {get;set;}
        public String failCode {get;set;}
        public String accountCode {get;set;}
        public String notes{get;set;}
        public Boolean showDays{get;set;}
        public Boolean showUp{get;set;}
        public Boolean showMileage{get;set;}
        public Boolean showMileageHT{get;set;}
        public Boolean accCoverage{get;set;}
        public Boolean mandateTechnician{get;set;}
        public Boolean mandateType{get;set;}
        public Boolean mandateDays{get;set;}
        public Boolean mandateMileage{get;set;}
        public Boolean mandateHrTr{get;set;}
        public Boolean mandateExpTotal{get;set;}
        public String PartOC{get;set;}
        public List<SelectOption> failCodelst{get;set;}
        
        Public Decimal WarrantyAllocation {get;set;}
        Public String QuantityOrdered {get;set;}
        Public Decimal Sellprice {get;set;}
        public string Comments{get;set;}
        Public Boolean dispAccountCode {get;set;}
        Public String Quantity {get;set;}
        Public string UnitPrice {get;set;}
        public boolean towErrorMsg{get;set;}
        public List<SelectOption> accCodelst{get;set;}
        public boolean expenseHeaderRedBox{get;set;}
        public string AAA {get;set;}
        public boolean isTTMLFailcodeCovLimitExceed{get;set;}
        public boolean isTTMLAccCodeCovLimitExceed{get;set;}
        Public Decimal UnitpriceModified {get;set;} //GSSC-138
        public Decimal amountModified {get;set;} //GSSC-138
        Public Decimal UnitpriceActual {get;set;} //GSSC-138
        public Decimal amountActual {get;set;} //GSSC-138
        
        public ttmlWrapperClass(Integer counting,Id ids,String technician,String type,String days,String mileage,String hoursTraveled, String expenseTotal,String failCode,String accountCode, String notes, Boolean showDays,Boolean showUp,Boolean showMileage, Boolean showMileageHT, Boolean accCoverage, List<SelectOption> failCodelst, String PartOC,Decimal WarrantyAllocation,String QuantityOrdered,Decimal Sellprice,string Comments,Boolean dispAccountCode,String Quantity,string UnitPrice, Boolean towErrorMsg, List<SelectOption> accCodelst, Boolean expenseHeaderRedBox, string aaa) {
            this.counting = counting;
            this.ids = ids;
            this.idStr = ids;
            this.technician = technician;
            this.type = type;
            this.days = days;
            this.mileage = mileage;
            this.hoursTraveled = hoursTraveled;
            this.expenseTotal = expenseTotal;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.notes = notes;
            this.showDays = showDays;
            this.showUp = showUp;
            this.showMileage = showMileage;
            this.showMileageHT = showMileageHT;
            this.accCoverage = accCoverage;
            this.mandateTechnician = mandateTechnician;
            this.mandateType = mandateType;
            this.mandateDays = mandateDays;
            this.mandateMileage = mandateMileage;
            this.mandateHrTr = mandateHrTr;
            this.mandateExpTotal = mandateExpTotal;
            this.failCodelst = failCodelst;
            this.PartOC = PartOC;
            this.WarrantyAllocation = WarrantyAllocation;
            this.QuantityOrdered = QuantityOrdered;
            this.Sellprice = Sellprice;
            this.Comments = Comments;
            this.dispAccountCode = dispAccountCode;
            this.Quantity = Quantity;
            this.UnitPrice = UnitPrice;
            this.towErrorMsg = towErrorMsg; 
            this.accCodelst = accCodelst;
            this.expenseHeaderRedBox=expenseHeaderRedBox;
            this.AAA = aaa;
            this.UnitpriceModified = UnitpriceModified;
            this.amountModified = amountModified;
            this.UnitpriceActual = UnitpriceActual;
            this.amountActual = amountActual;
            isTTMLAccCodeCovLimitExceed=false;
            isTTMLFailcodeCovLimitExceed=false;
        }        
    }
    public Map<string,string> mpItemNewWarranty;
    public List<SelectOption> getItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        Set<SelectOption> sortableSet = new  Set<SelectOption>();
        List<SelectOption> sortable = new  List<SelectOption>();
        List<CSS_JobEventTemporary__c> lstOCItems;
        mpItemNewWarranty = new Map<string,string>();
         lstOCItems = [select id, Key__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'OtherClaimables' ORDER BY createddate DESC LIMIT 1];
        options = new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
        CG_MiscChargeLOVResWrapper ocBMSLovResponse = new CG_MiscChargeLOVResWrapper();
        if(lstOCItems != null && lstOCItems.size() >0  && lstOCItems[0].Reason__c !=null){
            ocBMSLovResponse = (CG_MiscChargeLOVResWrapper)JSON.deserializeStrict(lstOCItems[0].Reason__c, CG_MiscChargeLOVResWrapper.class);
        }
        if(ocBMSLovResponse != null){
            if(ocBMSLovResponse.DataArea != null){
                if(dealer != 'DLR') {
                    for(CG_MiscChargeLOVResWrapper.DataArea dt : ocBMSLovResponse.DataArea)
                    {
                        sortable.add(new SelectOption(dt.MiscName,dt.MiscName));
                        mpItemNewWarranty.put(dt.MiscName,dt.NewWarrantyClass);
                        
                    }
                }
            }
            
        }
        Schema.DescribeFieldResult fieldResult =  CSS_Parts_Options__c.Item__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            if(f.getValue() != 'Select One' && f.getValue() != 'Unlisted'){
                options.add(new SelectOption(f.getValue(),f.getLabel()));
                sortable.add(new SelectOption(f.getValue(),f.getLabel()));
            }
        }
        sortable.sort();
        options = sortable;
        options.sort();
        if(options.size() > 0)
        {
             options.add(0,new SelectOption('Select One','Select One'));
        }
         options.add(new SelectOption('Unlisted','UNLISTED'));
        
        return options;
     }
    
    
   
    public Integer assignedParts{get;set;}
    //public Map<Id, String> removeIdsMap = new Map<Id, String>();
   
    
    
   
 
    
    
    
   /* public void getAllTTMLPartsData(){
       chkReqField = false;
        Boolean showDaysTTML;
        Boolean showupTTML;
        Boolean showMileageTTML;
        Boolean showMileageHTTTML;
        Boolean showTowTTML;
        Boolean accCoverage;
        Decimal expTotal;
        
        ttmlPartlstUI = new list<CSS_Parts_Options__c>();
        css_job_order__c jobObj = new css_job_order__c();
        Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>(); //GSSC-138
        
        try{
            recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            /*Commented below query as part of 101 SOQL fix
            ttmlPartlstUI = [select Id,Service_Job__c,Item__c,Part_Description__c,Quantity__c,Unit_Price__c,amount__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Exchange_Rate__c, Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,Comments__c,PartOC__c,Covered__c,Fail_Code__c,Account_Code__c,
                             Technician__c, Type__c, Siebel_Value__c,Misc_LOV__c,Days__c, Mileage__c, HoursTravelled__c, Notes__c, ExpenseTotal__c,FailurepartId__r.CoveredOCAmount__c,RecordType.Name,ODM_Status__c 
                             from CSS_Parts_Options__c where Service_Job__c =:Wid and (RecordTypeId=:recTypeIdTTML or PartOC__c = 'TOW') ORDER BY CreatedDate];
            */
            /*jobObj = [select id, CSS_Travel_Rate__c,CSS_In_Shop_Labor_Rate__c from css_job_order__c where id=:Wid];
            css_header_nav__c rswBotton =css_header_nav__c.getInstance(UserInfo.getUserId());
            
            if(newPartlstUI!=null && newPartlstUI.size()>0){
                for(CSS_Parts_Options__c p :newPartlstUI){
                    if(p.RecordTypeId == recTypeIdTTML || p.PartOC__c == 'TOW'){
                        ttmlPartlstUI.add(p);
                    }
                }
            }
            
            //GSSC-138 start
            css_utility utility = new css_utility();
            
            mapPartsList = utility.displayParts(ttmlPartlstUI);
        //    system.debug('mapPartsList--'+mapPartsList);
            //GSSC-138 end 
            
            Boolean DealerUser=rswBotton.RSWButtonEnable__c;
             if(ttmlPartlstUI.size()>0){
                listTTMLWrapper = new List<ttmlWrapperClass>();
                setTTMLWrapper = new Set<ttmlWrapperClass>();
                for(integer i=0;i<ttmlPartlstUI.size();i++){
                    List<SelectOption> fC = new List<SelectOption>();
                    accCoverage = false;
                    fC = fetchfailCodeValuesNew(ttmlPartlstUI[i].Type__c);
                    if(fC.size() == 1 && ttmlPartlstUI[i].Fail_Code__c!=null){
                        fC.add(new SelectOption(ttmlPartlstUI[i].Fail_Code__c,ttmlPartlstUI[i].Fail_Code__c));
                    }
                    List<SelectOption> aC = new List<SelectOption>();
                    aC = fetchAccCodeValues(ttmlPartlstUI[i].Type__c,ttmlPartlstUI[i].Fail_Code__c);
                    if(aC.size() == 1 && ttmlPartlstUI[i].Account_Code__c!= null ){
                        aC.add(new SelectOption(ttmlPartlstUI[i].Account_Code__c,ttmlPartlstUI[i].Account_Code__c));
                    }
                    if(DealerUser!=null && DealerUser==true){
                        if(ttmlPartlstUI[i].Type__c == 'Towing' || ttmlPartlstUI[i].Type__c == 'Lodging' || ttmlPartlstUI[i].Type__c == 'Meals'){
                            showDaysTTML = true;
                            showMileageHTTTML = false;
                            showMileageTTML= false;
                            showUPTTML = true;
                        }
                        else if(ttmlPartlstUI[i].Type__c == 'Commercial-Travel'){
                            showDaysTTML = false;
                            showMileageHTTTML = true;
                            showMileageTTML= false;
                            showUPTTML = true;
                        }
                        else if(ttmlPartlstUI[i].Type__c == 'Non Commercial-Travel'){
                            showDaysTTML = false;
                            showMileageHTTTML = true;
                            showMileageTTML= true;
                            showUPTTML = false;
                            
                        }
                        else{
                            showDaysTTML = false;
                            showMileageHTTTML = false;
                            showMileageTTML= false;
                            showUPTTML = false;
                        }
                    }
                    else{
                        if(ttmlPartlstUI[i].Type__c != '' && ttmlPartlstUI[i].Type__c != null && ttmlPartlstUI[i].Type__c != 'Towing'){
                            showDaysTTML = true;
                            showMileageHTTTML = true;
                            showTowTTML = false;
                        }
                        else if(ttmlPartlstUI[i].Type__c != '' && ttmlPartlstUI[i].Type__c != null && ttmlPartlstUI[i].Type__c == 'Towing'){
                            showDaysTTML = true;
                            showMileageHTTTML = true;
                            showTowTTML = true;
                        }
                        else{
                            showDaysTTML = false;
                            showMileageHTTTML = false;
                            showTowTTML = false;
                        }
                        if(ttmlPartlstUI[i].PartOC__c == 'TOW'){
                            ttmlPartlstUI[i].Type__c = 'Towing';
                        }
                    }
                    Boolean accCodeFlag = false;
                    if(mapTTMLItemWarnty != null && mapTTMLItemWarnty.containskey(ttmlPartlstUI[i].Type__c)){
                        string NewWarrantyClass = mapTTMLItemWarnty.get(ttmlPartlstUI[i].Type__c);
                        if(NewWarrantyClass == 'Non Commercial-Travel' || NewWarrantyClass == 'Commercial-Travel' || NewWarrantyClass == 'Lodging' || NewWarrantyClass == 'Meals'){
                            accCodeFlag=true;
                        }
                        else{
                            accCodeFlag=false;
                        }
                        if(NewWarrantyClass == 'Commercial-Travel' || NewWarrantyClass == 'Lodging' || NewWarrantyClass == 'Meals'){
                            expTotal=ttmlPartlstUI[i].Quantity__c * ((ttmlPartlstUI[i].Unit_Price__c != null && ttmlPartlstUI[i].Unit_Price__c != '') ? Decimal.valueof(ttmlPartlstUI[i].Unit_Price__c) : 0);
                        }
                        else if (NewWarrantyClass == 'Non Commercial-Travel'){
                            if(jobObj.CSS_Travel_Rate__c!=null && jobObj.CSS_Travel_Rate__c!='')
                                expTotal=ttmlPartlstUI[i].Quantity__c * Decimal.valueof(jobObj.CSS_Travel_Rate__c);
                            else
                                expTotal=0;
                            
                        }
                    }
                    if(ttmlPartlstUI[i].Account_Code__c != null && ttmlPartlstUI[i].Account_Code__c != '' && accCodeFlag == true)
                    {
                        accCoverage = true;
                    }
                    expTotal = ttmlPartlstUI[i].ExpenseTotal__c;
                    setTTMLWrapper.add(new ttmlWrapperClass(i,ttmlPartlstUI[i].Id,ttmlPartlstUI[i].Technician__c,ttmlPartlstUI[i].Type__c,ttmlPartlstUI[i].Days__c!= null ? String.valueof(ttmlPartlstUI[i].Days__c): '',ttmlPartlstUI[i].Mileage__c!= null ? String.valueof(ttmlPartlstUI[i].Mileage__c): '',ttmlPartlstUI[i].HoursTravelled__c != null ? String.valueof(ttmlPartlstUI[i].HoursTravelled__c): '',expTotal!= null ?String.valueof(expTotal): '0',ttmlPartlstUI[i].Fail_Code__c,ttmlPartlstUI[i].Account_Code__c,ttmlPartlstUI[i].Notes__c,showDaysTTML,showupTTML,showMileageTTML,showMileageHTTTML,accCoverage,fC,ttmlPartlstUI[i].PartOC__c,ttmlPartlstUI[i].Warranty_Allocation__c,ttmlPartlstUI[i].Quantity_Ordered__c,ttmlPartlstUI[i].Sell_Price__c,ttmlPartlstUI[i].Comments__c,accCodeFlag,ttmlPartlstUI[i].Quantity__c != null  ? String.valueOf(ttmlPartlstUI[i].Quantity__c) : '',ttmlPartlstUI[i].Unit_Price__c,showTowTTML,aC,false,null));
                }
                if(ttmlPartlstUI.size()<=4) {
                   for(integer i=0;i<5-ttmlPartlstUI.size();i++){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.Technician__c = 'Select One';
                        partsoption.Type__c = 'Select One';
                        partsoption.Days__c = null;
                        partsoption.Mileage__c = null ;
                        partsoption.HoursTravelled__c = null;
                        partsoption.Fail_Code__c = '';
                        partsoption.Account_Code__c = '';
                        partsoption.Notes__c = '';
                        partsoption.PartOC__c = null;
                        partsoption.Warranty_Allocation__c = null;
                        partsoption.Quantity_Ordered__c = null;
                        partsoption.Sell_Price__c = null;  
                        partsoption.Comments__c = null;
                        partsoption.Quantity__c =null;
                        partsoption.Unit_Price__c=null;
                        List<SelectOption> fcEmpty = new List<SelectOption>();
                        fcEmpty.add(new SelectOption('Select One','Select One'));
                        try{
                            setTTMLWrapper.add(new ttmlWrapperClass(ttmlPartlstUI.size()+i,null,partsoption.Technician__c,partsoption.Type__c,String.valueof(partsoption.Days__c),String.valueof(partsoption.Mileage__c),String.valueof(partsoption.HoursTravelled__c),String.valueof(partsoption.ExpenseTotal__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,partsoption.Notes__c,false,false,false,false,false,fcEmpty,partsoption.PartOC__c,partsoption.Warranty_Allocation__c,partsoption.Quantity_Ordered__c,partsoption.Sell_Price__c,partsoption.Comments__c,false,String.valueof(partsoption.Quantity__c),partsoption.Unit_Price__c,false,fcEmpty,false, null)); //since accountcode also initial empty, passing same list for both account code and failcode
                        }catch(Exception ex){
                            System.debug('in catch of getallTTMLPartsData adding wrapper>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                        }
                        
                    }
                   
                }
                
            }
            else{
                listTTMLWrapper = new List<ttmlWrapperClass>();
                setTTMLWrapper = new Set<ttmlWrapperClass>();
                for(integer i=0;i<5;i++){
                    CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                    partsoption.Technician__c = 'Select One';
                    partsoption.Type__c = 'Select One';
                    partsoption.Days__c = null;
                    partsoption.Mileage__c = null ;
                    partsoption.HoursTravelled__c = null;
                    partsoption.Fail_Code__c = '';
                    partsoption.Account_Code__c = '';
                    partsoption.Notes__c = '';
                    partsoption.PartOC__c = null;
                    partsoption.Warranty_Allocation__c = null;
                    partsoption.Quantity_Ordered__c = null;
                    partsoption.Sell_Price__c = null; 
                    partsoption.Comments__c=null;
                    List<SelectOption> lstFc = new List<SelectOption>();
                    lstFc.add(new SelectOption('Select One','Select One'));
                    setTTMLWrapper.add(new ttmlWrapperClass(ttmlPartlstUI.size()+i,null,partsoption.Technician__c,partsoption.Type__c,String.valueof(partsoption.Days__c),String.valueof(partsoption.Mileage__c),String.valueof(partsoption.HoursTravelled__c),String.valueof(partsoption.ExpenseTotal__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,partsoption.Notes__c,false,false,false,false,false,lstFc,partsoption.PartOC__c,partsoption.Warranty_Allocation__c,partsoption.Quantity_Ordered__c,partsoption.Sell_Price__c,partsoption.Comments__c,false,String.valueOf(partsoption.Quantity__c),partsoption.Unit_Price__c,false,lstFc,false,null)); //when all rows are empty both account code and failcode will be empty, so passing same list
                }
                
                
            }
            
        }catch(Exception ex){
            System.debug('in catch of getallTTMLPartsData>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        //GSSC-138 START
        if(setTTMLWrapper != null && setTTMLWrapper.size()>0){
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
                    unitPrice = (unitPrice != null) ? unitPrice.setScale(2) : null;
                    amount = (amount != null) ? amount.setScale(2) : null;
                    s.UnitpriceModified = null;
                    s.amountModified = null;
                    s.UnitpriceActual = unitPrice;
                    s.UnitPrice = (unitPrice != null) ? string.valueof(unitPrice) : '';
                    s.amountActual = amount;
                    s.expenseTotal = (amount != null) ? string.valueof(amount) : '';
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
            
         }
         //GSSC-138 END
    }*/
    
    //Method to get the Technician Details for TTML popup
    
    //Method for getting Type values for Dealer as per story #Despicable Me #168027,-By RAJESH 14th Nov 2018
    
    //End#Despicable Me #168027
    public Map<string,string> mapTTMLItemWarnty;
    //Method to get TTML Types
    
    
    
    
   
    
    
    
    //Method to save the TTML Popup
    Boolean DealerUser;  
     
    
    //Method to get accound codes on change of fail code for TTML
    public void calculateExpTotal(){
        isExpenseTotalError = false;
        set<string> setbol = new set<string>();
        
        css_job_order__c jobObj = new css_job_order__c();
        jobObj = [select id, CSS_Travel_Rate__c from css_job_order__c where id=:Wid];
        if(listTTMLWrapper != null && listTTMLWrapper.size()>0){
        for(ttmlWrapperClass  ttmlObj:listTTMLWrapper ){ 
            if(ttmlObj.counting == SelectedPartID)
            {
                if(ttmlObj.type == 'Meals' || ttmlObj.type == 'Lodging' || ttmlObj.type == 'Towing'){
                    if(ttmlObj.quantity != null && ttmlObj.quantity != '' && ttmlObj.unitPrice != null && ttmlObj.unitPrice != ''){
                       ttmlObj.expenseTotal=String.valueOf(Decimal.valueOf(ttmlObj.quantity)*Decimal.valueOf(ttmlObj.unitPrice)).trim();
                         if(ttmlObj.type == 'Meals' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99){
                            isMealsExpenseTotalError=true;
                            ttmlObj.expenseHeaderRedBox=true;
                        }
                        
                        if(ttmlObj.type == 'Meals' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                            isMealsExpenseTotalError = false;
                            ttmlObj.expenseHeaderRedBox=false;
                        }
                        
                        if(ttmlObj.type == 'Lodging' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                            isLodgingExpenseTotalError=true;
                            ttmlObj.expenseHeaderRedBox=true;
                        }
                        
                        if(ttmlObj.type == 'Lodging' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                          isLodgingExpenseTotalError = false;
                            ttmlObj.expenseHeaderRedBox=false;
                        }
                        
                        if(ttmlObj.type == 'Towing' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                            isTowingExpenseTotalError=true;
                            ttmlObj.expenseHeaderRedBox=true;
                        }
                        
                        if(ttmlObj.type == 'Towing' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99){
                           ttmlObj.expenseHeaderRedBox=false;
                            isTowingExpenseTotalError=false;
                        }
                                                                                                  
                    }
                    else
                        ttmlObj.expenseTotal = '';
                }
                //End code   as per story #148900 ,By RAJESH 08th Jan 2019-- --Modified by Anvesh on 15th Jan 2019>
                
                //Start code as per story #148903 when type equals to commercial and non commercial travel,-By RAJESH 28th Jan 2019 
                if(ttmlObj.type=='Commercial-Travel' || ttmlObj.type=='Non Commercial-Travel' || ttmlObj.type == 'PARKING-FSPG' || ttmlObj.type == 'PARKING-FSE' || ttmlObj.type == 'TOLLS-FSE' || ttmlObj.type == 'TOLLS-FSPG' ){//|| ttmlObj.type == 'MILE WARR FSE' || ttmlObj.type == 'MILE WARR FSPG'
                   if(ttmlObj.quantity != null && ttmlObj.quantity != '' && ttmlObj.unitPrice != null && ttmlObj.unitPrice != ''){
                        ttmlObj.expenseTotal=String.valueOf(Decimal.valueof(ttmlObj.Quantity) * Decimal.valueof(ttmlObj.UnitPrice)).trim();
                        if(ttmlObj.expenseTotal!='' && ttmlObj.expenseTotal!=null && Decimal.valueof(ttmlObj.expenseTotal)>10000){
                            ttmlObj.expenseHeaderRedBox=true;
                            setbol.add('true');
                        }
                        if(ttmlObj.expenseTotal!='' && ttmlObj.expenseTotal!=null && Decimal.valueof(ttmlObj.expenseTotal)<10000){
                             ttmlObj.expenseHeaderRedBox=false;
                            setbol.add('false');
                        }
                        
                    }
                    
                }
                //End code as per story #148903 when type equals to commercial and non commercial travel,-By RAJESH 28th Jan 2019 
                else {
                    if(ttmlObj.UnitPrice != null && ttmlObj.UnitPrice != '' && ttmlObj.Quantity!=null && ttmlObj.Quantity!= '')
                        ttmlObj.expenseTotal=String.valueOf(Decimal.valueof(ttmlObj.Quantity) * Decimal.valueof(ttmlObj.UnitPrice)).trim();
                    else
                        ttmlObj.expenseTotal='';
                }
                
                //GSSC-138 start
                system.debug('ttmlObj.UnitpriceActual--'+ttmlObj.UnitpriceActual);
                system.debug('ttmlObj.unitPrice--'+ttmlObj.unitPrice);
                if(ttmlObj.unitPrice != null && ttmlObj.unitPrice != '' && decimal.valueof(ttmlObj.unitPrice) != ttmlObj.UnitpriceActual){
                    ttmlObj.UnitpriceModified = decimal.valueof(ttmlObj.unitPrice);
                    ttmlObj.amountModified = decimal.valueof(ttmlObj.expenseTotal);
                }
                system.debug('UnitpriceModified--'+ttmlObj.UnitpriceModified);
                system.debug('amountModified--'+ ttmlObj.amountModified);
                //GSSC-138 end
                
            }
            
            //Added below if condition By Anvesh 15th Jan 2019        
            if(ttmlObj.counting != SelectedPartID){
                if(ttmlObj.type == 'Meals' || ttmlObj.type == 'Lodging' || ttmlObj.type == 'Towing'){
                    if(ttmlObj.type == 'Meals' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                        isMealsExpenseTotalError=true;
                        ttmlObj.expenseHeaderRedBox=true;
                    }
                    if(ttmlObj.type == 'Meals' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                        isMealsExpenseTotalError = false;
                        ttmlObj.expenseHeaderRedBox=false;
                    }
                    if(ttmlObj.type == 'Lodging' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                        isLodgingExpenseTotalError=true;
                        ttmlObj.expenseHeaderRedBox=true;
                    }
                    if(ttmlObj.type == 'Lodging' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                        isLodgingExpenseTotalError = false;
                        ttmlObj.expenseHeaderRedBox=false;
                    }
                    if(ttmlObj.type == 'Towing' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                        isTowingExpenseTotalError=true;
                        ttmlObj.expenseHeaderRedBox=true;
                    }
                    if(ttmlObj.type == 'Towing' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                        ttmlObj.expenseHeaderRedBox=false;
                        isTowingExpenseTotalError=false;
                    }
                    
                }
                
                //GSSC-138 start
                system.debug('ttmlObj.UnitpriceActual--'+ttmlObj.UnitpriceActual);
                system.debug('ttmlObj.unitPrice--'+ttmlObj.unitPrice);
                if(ttmlObj.unitPrice != null && ttmlObj.unitPrice != '' && decimal.valueof(ttmlObj.unitPrice) != ttmlObj.UnitpriceActual){
                    ttmlObj.UnitpriceModified = decimal.valueof(ttmlObj.unitPrice);
                    ttmlObj.amountModified = decimal.valueof(ttmlObj.expenseTotal);
                }
                system.debug('UnitpriceModified--'+ttmlObj.UnitpriceModified);
                system.debug('amountModified--'+ ttmlObj.amountModified);
                //GSSC-138 end
                    
            } 
            //End--Added below if condition By Anvesh 15th Jan 2019
            
        } 
        }
        
        //Added below for loop for showing error message after selecting second recond based on criteria as per story #148903,-By Rajesh 29th Jan 2019   
       if(listTTMLWrapper != null && listTTMLWrapper.size()>0){
        for(ttmlWrapperClass  ttmlObj:listTTMLWrapper ){
            if(ttmlObj.type=='Commercial-Travel' || ttmlObj.type=='Non Commercial-Travel' || ttmlObj.type == 'PARKING-FSPG' || ttmlObj.type == 'PARKING-FSE' || ttmlObj.type == 'TOLLS-FSE' || ttmlObj.type == 'TOLLS-FSPG' ){//|| ttmlObj.type == 'MILE WARR FSE' || ttmlObj.type == 'MILE WARR FSPG'
                if(ttmlObj.quantity != null && ttmlObj.quantity != '' && ttmlObj.unitPrice != null && ttmlObj.unitPrice != ''){
                    ttmlObj.expenseTotal=String.valueOf(Decimal.valueof(ttmlObj.Quantity) * Decimal.valueof(ttmlObj.UnitPrice)).trim();
                    if(ttmlObj.expenseTotal!='' && ttmlObj.expenseTotal!=null && Decimal.valueof(ttmlObj.expenseTotal)>10000){
                        ttmlObj.expenseHeaderRedBox=true;
                        setbol.add('true');
                    }
                }
            }
        }
       }
        if(setbol.contains('true'))
            isExpenseTotalError = true;
        else
            isExpenseTotalError = false;
        
        //End-Added below for loop for showing error message after selecting second recond based on criteria as per story #148903,-By Rajesh 29th Jan 2019   
    }
    
    public boolean isMealsExpenseTotalError {get;set;}
    public boolean isLodgingExpenseTotalError {get;set;}
    public boolean isTowingExpenseTotalError {get;set;}
    //Method for getting expTotal for dealer user as per story #168027,-RAJESH 15th Nov 2018
    public void getExpenseTotal(){
        css_job_order__c jobObj = new css_job_order__c();
        jobObj = [select id, CSS_Travel_Rate__c,CSS_In_Shop_Labor_Rate__c from css_job_order__c where id=:Wid];
        if(listTTMLWrapper != null && listTTMLWrapper.size()>0){
        for(ttmlWrapperClass  ttmlObj:listTTMLWrapper ){
            if(ttmlObj.counting == SelectedPartID){
                if(ttmlObj.type != '' && ttmlObj.type != null){
                    if(ttmlObj.type == 'Meals' || ttmlObj.type == 'Lodging' || ttmlObj.type == 'Towing'){
                        if(ttmlObj.quantity != null && ttmlObj.quantity != '' && ttmlObj.unitPrice != null && ttmlObj.unitPrice != ''){
                             ttmlObj.expenseTotal=String.valueOf(Decimal.valueOf(ttmlObj.quantity)*Decimal.valueOf(ttmlObj.unitPrice)).trim();
                            //Start code   as per story #148900 ,By RAJESH 08th Jan 2019-->                                                        
                            if(ttmlObj.type == 'Meals' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                               isMealsExpenseTotalError=true;
                                ttmlObj.expenseHeaderRedBox=true;
                            }
                            
                            if(ttmlObj.type == 'Meals' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                                isMealsExpenseTotalError = false;
                                ttmlObj.expenseHeaderRedBox=false;
                            }
                            
                            if(ttmlObj.type == 'Lodging' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                                isLodgingExpenseTotalError=true;
                                ttmlObj.expenseHeaderRedBox=true;
                            }
                            
                            if(ttmlObj.type == 'Lodging' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                                isLodgingExpenseTotalError = false;
                                ttmlObj.expenseHeaderRedBox=false;
                            }
                            
                            if(ttmlObj.type == 'Towing' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                                isTowingExpenseTotalError=true;
                                ttmlObj.expenseHeaderRedBox=true;
                            }
                            
                            if(ttmlObj.type == 'Towing' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                                ttmlObj.expenseHeaderRedBox=false;
                                isTowingExpenseTotalError=false;
                            }
                            //End code   as per story #148900 ,By RAJESH 08th Jan 2019-->                                                                                                     
                        }
                        else
                            ttmlObj.expenseTotal = '';
                    }
                    else if(ttmlObj.type == 'Commercial-Travel'){
                        if(ttmlObj.unitPrice != null && ttmlObj.unitPrice != '' && ttmlObj.hoursTraveled != null && ttmlObj.hoursTraveled != '' && jobObj.CSS_In_Shop_Labor_Rate__c!='' && jobObj.CSS_In_Shop_Labor_Rate__c!=null){
                            ttmlObj.expenseTotal=String.valueOf(Decimal.valueOf(ttmlObj.unitPrice)+(Decimal.valueOf(ttmlObj.hoursTraveled)*0.4*Decimal.valueOf(jobObj.CSS_In_Shop_Labor_Rate__c))); 
                            //start code for getting error message when we select type like commercial travel as per Finding Nemo Story #148903,-By RAJESH 28th Jan 2019               
                            if(ttmlObj.expenseTotal!=null && ttmlObj.expenseTotal!='' && Decimal.valueOf(ttmlObj.expenseTotal) > 10000 ){
                                ttmlObj.expenseHeaderRedBox = true;                                    
                                isExpenseTotalError = true;
                            }
                            if(ttmlObj.expenseTotal!=null && ttmlObj.expenseTotal!='' && Decimal.valueOf(ttmlObj.expenseTotal) < 10000 ){
                                ttmlObj.expenseHeaderRedBox = false;
                                isExpenseTotalError = false;
                            }
                            //End code for getting error message when we select type like commercial travel as per Finding Nemo Story #148903,-By RAJESH 28th Jan 2019  
                        }
                        else{
                            ttmlObj.expenseTotal = '';
                        }
                    }
                    //Non commercial Trav
                    else{
                        if(ttmlObj.hoursTraveled != null && ttmlObj.hoursTraveled !='' && ttmlObj.mileage != null && ttmlObj.mileage != '' && jobObj.CSS_Travel_Rate__c!=null && jobObj.CSS_Travel_Rate__c!='' && jobObj.CSS_In_Shop_Labor_Rate__c!=null && jobObj.CSS_In_Shop_Labor_Rate__c!='' ){
                            ttmlObj.expenseTotal=String.valueOf((Decimal.valueOf(ttmlObj.mileage)*Decimal.valueof(jobObj.CSS_Travel_Rate__c))+((ttmlObj.hoursTraveled == null || ttmlObj.hoursTraveled == '')?0:Decimal.valueOf(ttmlObj.hoursTraveled)*Decimal.valueof(jobObj.CSS_In_Shop_Labor_Rate__c)));               
                            if(ttmlObj.expenseTotal!=null && ttmlObj.expenseTotal!='' && Decimal.valueOf(ttmlObj.expenseTotal) > 10000 ){
                                ttmlObj.expenseHeaderRedBox = true;                                    
                                isExpenseTotalError = true;
                            }
                            if(ttmlObj.expenseTotal!=null && ttmlObj.expenseTotal!='' && Decimal.valueOf(ttmlObj.expenseTotal) < 10000 ){
                                ttmlObj.expenseHeaderRedBox = false;
                                isExpenseTotalError = false;
                            }
                        }
                        
                    }
                    
                    //GSSC-138 start
                    if((ttmlObj.unitPrice != null & ttmlObj.unitPrice != '') && decimal.valueof(ttmlObj.unitPrice) != ttmlObj.UnitpriceActual){
                        ttmlObj.UnitpriceModified = (ttmlObj.unitPrice != null && ttmlObj.unitPrice != '') ? decimal.valueof(ttmlObj.unitPrice) : 0;
                        ttmlObj.amountModified = (ttmlObj.expenseTotal != null && ttmlObj.expenseTotal != '') ? decimal.valueof(ttmlObj.expenseTotal) : 0;
                    }
                    //GSSC-138 end
                }
            }
            
            
            if(ttmlObj.counting != SelectedPartID){
                if(ttmlObj.type == 'Meals' || ttmlObj.type == 'Lodging' || ttmlObj.type == 'Towing'){
                    system.debug('ttmlObj.expenseTotal'+ttmlObj.expenseTotal);
                    if(ttmlObj.type == 'Meals' && ttmlObj.expenseTotal!= '' &&  Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                        isMealsExpenseTotalError=true;
                        ttmlObj.expenseHeaderRedBox=true;
                    }
                    
                    if(ttmlObj.type == 'Meals' && ttmlObj.expenseTotal!= '' && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                        isMealsExpenseTotalError = false;
                        ttmlObj.expenseHeaderRedBox=false;
                    }
                    
                    if(ttmlObj.type == 'Lodging'  && ttmlObj.expenseTotal!= '' && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                        isLodgingExpenseTotalError=true;
                        ttmlObj.expenseHeaderRedBox=true;
                    }
                    if(ttmlObj.type == 'Lodging' && ttmlObj.expenseTotal!= ''  && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                        isLodgingExpenseTotalError = false;
                        ttmlObj.expenseHeaderRedBox=false;
                    }
                    if(ttmlObj.type == 'Towing' && ttmlObj.expenseTotal!= ''  && Decimal.valueOf(ttmlObj.expenseTotal) > 99999.99 ){
                        isTowingExpenseTotalError=true;
                        ttmlObj.expenseHeaderRedBox=true;
                    }
                    if(ttmlObj.type == 'Towing' && ttmlObj.expenseTotal!= ''  && Decimal.valueOf(ttmlObj.expenseTotal) < 99999.99 ){
                        ttmlObj.expenseHeaderRedBox=false;
                        isTowingExpenseTotalError=false;
                    }
                 }
           }
            
            //Added below for loop for showing error message after selecting second recond based on criteria as per story #148903,-By Rajesh 29th Jan 2019   
            for(ttmlWrapperClass  ttmlObj1:listTTMLWrapper ){
                if(ttmlObj1.type=='Commercial-Travel' || ttmlObj1.type=='Non Commercial-Travel'){
                    if(ttmlObj1.quantity != null && ttmlObj1.quantity != '' && ttmlObj1.unitPrice != null && ttmlObj1.unitPrice != ''){
                        ttmlObj1.expenseTotal=String.valueOf(Decimal.valueof(ttmlObj1.Quantity) * Decimal.valueof(ttmlObj1.UnitPrice)).trim();
                        if(ttmlObj1.expenseTotal!='' && ttmlObj1.expenseTotal!=null && Decimal.valueof(ttmlObj1.expenseTotal)>10000){
                            ttmlObj1.expenseHeaderRedBox=true;
                            isExpenseTotalError = true;
                            break;
                        }
                        
                    }
                    
                }
            }
            //End-Added below for loop for showing error message after selecting second recond based on criteria as per story #148903,-By Rajesh 29th Jan 2019      
            
        } 
        }
    }
    //End
    //Method to get accound codes on change of fail code for TTML
    public void getAccCodesonChngofFailCode(){
        duplicateAccountCode=false;
        String accCode;
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        if(SelectedFailCode!='Select One'){
            lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,CSS_CoverageType__c,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =:wid and FailCode_Formula__c = :SelectedFailCode AND CSS_Account_Formula__c!=''];
            if(lstSolComp != null && lstSolComp.size()!=0){
                if(lstSolComp.size() > 1){
                    string acCode;
                    string compAcCode;
                    acCode = lstSolComp[0].CSS_Account_Formula__c;
                    compAcCode = lstSolComp[0].CSS_Account_Formula__c;                    
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
            if(listTTMLWrapper != null && listTTMLWrapper.size()>0){
            for(ttmlWrapperClass ttmlwr : listTTMLWrapper){
                if(ttmlwr.counting == SelectedPartID){
                    ttmlwr.accountCode = accCode ;
                    if(ttmlwr.accountCode == null || ttmlwr.accountCode == 'Select One' || ttmlwr.accountCode == '')
                        ttmlwr.accCoverage=false;
                    else 
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
        
    } 
    
    public PageReference redirectToWarranty(){
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.chevron_page__c = 'war';
        jobOrder.Id = wid;
        update jobOrder;
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanWarranty?id='+wid); 
        pageRef.setRedirect(true);                
        return pageRef;
    } 
    
    //Story 117224 To provide Expense Total
    public void saveExpenseTotal() {    
        try
        {
            ncomt = 0;
            comt = 0;
            towt = 0;
            meals = 0;
            lodg = 0;
            totalexp = 0;
            List<CSS_Parts_Options__c> cpolist = new List<CSS_Parts_Options__c>();
            //Added Unit_Price__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c in below query as part of the story GSSC-138
            //Commented below query as part of 101 SOQL fix
            //cpolist =[SELECT Siebel_Value__c, Service_Job__c, CSS_Claims__c, ExpenseTotal__c, Type__c, RecordType.Name, ODM_Status__c, Unit_Price__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c  FROM CSS_Parts_Options__c WHERE RecordType.Name = 'TTML' AND Service_Job__c =:Wid];
            if(newPartlstUI!=null && newPartlstUI.size()>0){
                for(CSS_Parts_Options__c p :newPartlstUI){
                    if(p.RecordType.Name == 'TTML'){
                        cpolist.add(p);
                    }
                }
            }
            system.debug('cpolist-->'+cpolist);
            //GSSC-138 - Start
            Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
            css_utility controller = new css_utility();
            mapPartsList = controller.displayParts(cpolist);
            //GSSC-138 - End
            for(CSS_Parts_Options__c csprt:cpolist){
                //GSSC-138 - Start
                Map<decimal, decimal> expTotalTempMap = mapPartsList.get(csprt.Id);
                Decimal expTotalTemp; 
                if(expTotalTempMap != null){
                    for(decimal up : expTotalTempMap.keyset()){
                        expTotalTemp = expTotalTempMap.get(up);
                    }
                }
                //GSSC-138 - End
                if(csprt.type__c=='Non Commercial-Travel' || csprt.Siebel_Value__c == 'Non Commercial-Travel')
                {
                    ncomt=ncomt+expTotalTemp;  //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Commercial-Travel' || csprt.Siebel_Value__c == 'Commercial-Travel')
                {
                    comt=comt+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Towing' || csprt.Siebel_Value__c == 'Towing')
                {
                    towt=towt+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Meals' || csprt.Siebel_Value__c == 'Meals')
                {
                    meals=meals+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
                if(csprt.type__c=='Lodging' || csprt.Siebel_Value__c == 'Lodging')
                {
                    lodg=lodg+expTotalTemp; //Changed ExpenseTotal__c to expTotalTemp as part of the story GSSC-138
                }
            }
        totalexp=ncomt+comt+towt+meals+lodg;
        system.debug('totalexp-->'+totalexp);
        }
        catch(Exception ex)
        {
            system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
        }
    }
    public List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();//[SELECT  Id,CSS_Account_Formula__c,Parts_Warranty__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: wid AND Selected_Component__c = true AND FailCode_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution'];
   
    
    
    //Method for getting gyedout part on change of Type for Dealer user as per Despicable Me #168027
   
}