public class CSS_OtherClaimablesController
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
public List<CSS_Parts_Options__c> newPartlstUI {get;set;}
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
List<CSS_Solution_Component__c> solsCompR; //101 issue
public List<CSS_Solution_Component__c> solsCompTTML{get;set;} // Added this as part of 101 fix
public Map<string,string> mapAccCodes = new Map<string,string>();
public CSS_OtherClaimablesController()
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

    css_job_order__c jobData = [select Id,Account__r.Type,CSS_Travel_Rate__c, Account__c from css_job_order__c where Id = : Wid];	//, Account__r.ERP_System__c
    if(jobData != null && jobData.Account__c != null ) {	//&& jobData.Account__r.ERP_System__c != null && jobData.Account__r.ERP_System__c == 'One BMS'
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
    //GSSC-138-start    
    if(userinfo.getDefaultCurrency() == 'USD'){
        lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c order by Bolt_Version__c desc limit 1];
    }
    else{
        lstCurrencyDetails = [Select Id, Bolt_Conversion_Rate__c, Bolt_To_Currency__c, Bolt_Version__c from Currency_Conversion__c where Bolt_To_Currency__c =: userinfo.getDefaultCurrency() order by Bolt_Version__c desc limit 1];
    }
    //GSSC-138-end
    
    newPartlstUI = new List<CSS_Parts_Options__c>();
    newPartlstUI = [select Id,Service_Job__c,Item__c,Part_Description__c,Get_Fail_Code_Formula__c,Quantity__c,Unit_Price__c,amount__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Exchange_Rate__c, Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,Comments__c,PartOC__c,Covered__c,Fail_Code__c,Account_Code__c,
                         Technician__c, Type__c, Siebel_Value__c,Misc_LOV__c,Days__c, Mileage__c, HoursTravelled__c, Notes__c, ExpenseTotal__c,FailurepartId__r.CoveredOCAmount__c,RecordType.Name,ODM_Status__c 
                         from CSS_Parts_Options__c where Service_Job__c =:Wid ORDER BY CreatedDate];
    system.debug('newPartlstUI>>>'+newPartlstUI);    
    system.debug('otherClaimPartList>>>'+otherClaimPartList); 
    
    
    getItems();
    getTTMLType();
    getallCustomPartsData(false);
    getAllTTMLPartsData();
    saveExpenseTotal();
    //Start code   as per story #148900 ,By RAJESH 10th Jan 2019
    isMealsExpenseTotalError=false;
    isLodgingExpenseTotalError=false;
    isTowingExpenseTotalError=false;
    //End code   as per story #148900 ,By RAJESH 10th Jan 2019
    DealerTypeFlag = CSS_utility.getAccounttype(jobData.Account__r.Type);//Venkat
    dealer = css_utility.getOrgType(userInfo.getUserID()); 
    lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,Type__c,Selected_Component__c,CoveredOCAmount__c ,CampaignTowingPercentage__c,CoveredTravelBaseFareAmt__c,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c,FailCode_Formula__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c,CSS_CoverageType__c from CSS_Solution_Component__c where Service_Job__c =:wid AND Selected_Component__c = true AND CSS_Account_Formula__c != null];
   //101 issue
    solsCompR = new List<CSS_Solution_Component__c>();
    solsCompR = [SELECT Id, FailCode_Formula__c,CSS_Account_Formula__c ,SysCodeAndCompCode__c,CoveredTravelBaseFareAmt__c,CoveredTravelLabor__c,CoveredTowingMiles__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CSS_CoverageType__c,Selected_Component__c ,Parts_Warranty__c,CoveredOCAmount__c,CampaignOCPercentage__c,Type__c from CSS_Solution_Component__c where Service_Job__c =:Wid and FailCode_Formula__c!=null and (((Type__c != 'Campaign' and Type__c != 'ATC' and Type__c != 'TRP') and Selected_Component__c= true and Root_Cause__c= true) or ((Type__c = 'Campaign' or Type__c = 'ATC' or Type__c = 'TRP') and Performed_review__c = true))];//and Solutions__r.Diagnostic_Response__c='Most likely the solution'
    //system.debug('workJOb.Account__'+jobData);
    //solsCompTTML = new List<CSS_Solution_Component__c>();
    //solsCompTTML= [SELECT Id,CSS_Account_Formula__c, Type__c,CoveredTravelBaseFareAmt__c, CSS_CoverageType__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, Parts_Warranty__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: wid AND ((Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution') OR (Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];

}


public string BMSChargesErrMsg{get;set;}
public void SendOtherClaimablestoERP(){
    try{
        css_job_order__c jobData = new css_job_order__c();
        JobData = [select id, Creator_Location__c,DistributorCode__c,branch__c,Customer_Code__c,Shop_Work_Order__c,Shop_s_Work_Order__c from css_job_order__c where id=:Wid];
        css_quote__c Quote = new css_quote__c();
        if(jobData.id!=null){
            try{
                Quote=[select id,Service_Job__c from css_quote__c where Service_Job__c =:jobData.id];}
            catch(Exception ex){
                Quote.id=null;
            }
        }
        List<string> lstLocCodes = new list<string>();
        list<css_parts_options__c> lstEstimatedpart = new list<css_parts_options__c>();
        list<css_parts_options__c> lstSelectedpart = new list<css_parts_options__c>();
        list<css_parts_options__c> lstEstimatedpartTTML = new list<css_parts_options__c>();
        list<css_parts_options__c> lstSelectedpartTTML = new list<css_parts_options__c>();
        BMSChargesErrMsg = '';
        lstLocCodes = JobData.Creator_Location__c.split('-');
        system.debug('TestoC2********'+otherClaimPartList);
        for(css_parts_options__c part: otherClaimPartList){
            
            if(part.css_estimate__c == true && part.selected_part__c==true)
                lstEstimatedpart.add(part);
            if(part.css_estimate__c == false && part.selected_part__c==true)
                lstSelectedpart.add(part);
        }
       if(lstEstimatedpart!=null && lstEstimatedpart.size()>0)
        {  CG_OP_OAGWrapper WOQTOPWrap = new CG_OP_OAGWrapper();
          WOQTOPWrap = cg_sl_bms.sendMISCCharges(jobData.Creator_Location__c,jobData.id,lstLocCodes[0],lstLocCodes[1],jobData.Customer_Code__c,'WOQT',Quote.id, lstEstimatedpart, 'N');
          BMSChargesErrMsg = BMSChargesErrMsg+WOQTOPWrap.errorMessage;
        } 
        if(lstSelectedpart!=null && lstSelectedpart.size()>0)
        {  CG_OP_OAGWrapper WOOPWrap = new CG_OP_OAGWrapper();
        WOOPWrap = cg_sl_bms.sendMISCCharges(jobData.Creator_Location__c,jobData.id,lstLocCodes[0],lstLocCodes[1],jobData.Customer_Code__c,'WO',jobData.Shop_Work_Order__c, lstSelectedpart, 'N');
        BMSChargesErrMsg = BMSChargesErrMsg+WOOPWrap.errorMessage;
        } 
        for(css_parts_options__c part: ttmlPartsList){
            system.debug('ttmlPartsList********'+ttmlPartsList);
            if(part.css_estimate__c == true && part.selected_part__c==true){
                if(part.Type__c.equalsignorecase('Commercial-Travel') || part.Type__c.equalsignorecase('Non Commercial-Travel')){
                    part.Quantity__c = part.Mileage__c;
                }
                if(part.Type__c.equalsignorecase('Lodging') || part.Type__c.equalsignorecase('Meals') || part.Type__c.equalsignorecase('Towing')){
                    part.Quantity__c = part.Days__c;
                 }
                lstEstimatedpartTTML.add(part);
            }
            if(part.css_estimate__c == false && part.selected_part__c==true){
                if(part.Type__c.equalsignorecase('Commercial-Travel') || part.Type__c.equalsignorecase('Non Commercial-Travel')){
                    part.Quantity__c = part.Mileage__c;
                }
                if(part.Type__c.equalsignorecase('Lodging') || part.Type__c.equalsignorecase('Meals') || part.Type__c.equalsignorecase('Towing')){
                    part.Quantity__c = part.Days__c;
                 }
                lstSelectedpartTTML.add(part);
            }
        } 
        if(lstEstimatedpartTTML!=null && lstEstimatedpartTTML.size()>0)
        {  CG_OP_OAGWrapper WOQTOPWrapttml = new CG_OP_OAGWrapper();
         WOQTOPWrapttml = cg_sl_bms.sendMISCCharges(jobData.Creator_Location__c,jobData.id,lstLocCodes[0],lstLocCodes[1],jobData.Customer_Code__c,'WOQT',jobData.Shop_Work_Order__c, lstEstimatedpartTTML, 'N');
         BMSChargesErrMsg = BMSChargesErrMsg+WOQTOPWrapttml.errorMessage;
        } 
        if(lstSelectedpartTTML!=null && lstSelectedpartTTML.size()>0)
        {  CG_OP_OAGWrapper WOOPWrapttml = new CG_OP_OAGWrapper();
         WOOPWrapttml = cg_sl_bms.sendMISCCharges(jobData.Creator_Location__c,jobData.id,lstLocCodes[0],lstLocCodes[1],jobData.Customer_Code__c,'WO',jobData.Shop_Work_Order__c, lstSelectedpartTTML, 'N');
       
         BMSChargesErrMsg = BMSChargesErrMsg+WOOPWrapttml.errorMessage;
        } 
    }
    catch(Exception ex){
        System.debug('in catch of SendOtherClaimablestoERP of OtherClaimables >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
}
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
    system.debug('Testpartslist'+newPartlstUI);
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
    system.debug('Test OC>>>'+otherClaimPartList);
    system.debug('Test PC>>>'+ttmlPartsList);
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
    system.debug('TestoC1********'+otherClaimPartList);
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

public void getallCustomPartsData(Boolean displayPopup2){
    //getfailcodeDropDown();
    chkReqField = false;
    if(displayPopup2){
        ErrorMessage1 = true;
    }else     
        ErrorMessage1 = false;
    
    customPartlstUI = new list<CSS_Parts_Options__c>();
    try{
        recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        /*Commented below query as part of 101 SOQL fix
        customPartlstUI = [select Id, Service_Job__c, Item__c,PartOC__c,Part_Description__c,Get_Fail_Code_Formula__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Exchange_Rate__c, Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,Quantity__c,amount__c,Covered__c,Fail_Code__c,Account_Code__c,RecordType.Name,ODM_Status__c 
                           from CSS_Parts_Options__c where Service_Job__c =:Wid and (RecordTypeId=:recTypeIdpart or PartOC__c ='OC')];
        */
        if(newPartlstUI!=null && newPartlstUI.size()>0){
            for(CSS_Parts_Options__c p :newPartlstUI){
                if(p.RecordTypeId == recTypeIdpart || p.PartOC__c == 'OC'){
                    customPartlstUI.add(p);
                }
            }
        }
        
        
        //GSSC-138 start
        css_utility utility = new css_utility();
        
        Map<id, Map<decimal,decimal>> mapPartsList = new Map<id, Map<decimal,decimal>>();
        
        mapPartsList = utility.displayParts(customPartlstUI);
        system.debug('mapPartsList--'+mapPartsList);
        system.debug('customPartlstU>>I--'+customPartlstUI);
        //GSSC-138 end
        
        List<SelectOption> codesAC =  new List<SelectOption>();
        codesAC.add(new SelectOption('Select One','Select One'));
         if(customPartlstUI.size()>0){
            listpartWrapper = new List<claimablesWrapperClass>();
            setpartWrapper = new Set<claimablesWrapperClass>();
            for(integer i=0;i<customPartlstUI.size();i++){
                Boolean flag = true;
                if(mpItemNewWarranty.containskey(customPartlstUI[i].Item__c)){
                   string NewWarrantyClass = mpItemNewWarranty.get(customPartlstUI[i].Item__c);
                   if(NewWarrantyClass!=null && NewWarrantyClass == 'Unlisted (Warrantable)'){
                       flag=true;
                    }
                    else{
                        flag=false;
                        
                    }
                }
                
                Decimal partAmount;
                if(customPartlstUI[i].PartOC__c =='OC'){
                    system.debug('Inside Parts OC');
                    if(customPartlstUI[i].Quantity_Ordered__c != null)
                    system.debug('Inside Parts Quantity');
                        system.debug(customPartlstUI[i].Sell_Price__c + 'Selling Price***');
                        partAmount = Integer.valueOf(customPartlstUI[i].Quantity_Ordered__c)*customPartlstUI[i].Sell_Price__c;
                }
                else{
                    partAmount = customPartlstUI[i].amount__c;
                }
                
                //GSSC-138 START
                decimal unitPrice;
                decimal amount;
                Map<decimal, decimal> mapTemp = new Map<decimal, decimal>();
                
                system.debug('customPartlstUI[i].Currency_Type__c--'+customPartlstUI[i].Currency_Type__c);

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
                system.debug('customPartlstUI--'+customPartlstUI);
                
                //GSSC-138 end
                //setpartWrapper.add(new claimablesWrapperClass(i,customPartlstUI[i].Id,customPartlstUI[i].Item__c,customPartlstUI[i].Part_Description__c,String.valueof(customPartlstUI[i].Quantity__c),partAmount,String.valueof(customPartlstUI[i].Covered__c),customPartlstUI[i].Fail_Code__c,customPartlstUI[i].Account_Code__c,customPartlstUI[i].PartOC__c,customPartlstUI[i].Warranty_Allocation__c,customPartlstUI[i].Quantity_Ordered__c,customPartlstUI[i].Sell_Price__c,flag,customPartlstUI[i].Sell_Price__c,getfailcodeDropDownBasedOnItem(customPartlstUI[i].Item__c ,null),getAccountCodeDropDown(customPartlstUI[i].Fail_Code__c),false,false));
                setpartWrapper.add(new claimablesWrapperClass(i,customPartlstUI[i].Id,customPartlstUI[i].Item__c,customPartlstUI[i].Part_Description__c,String.valueof(customPartlstUI[i].Quantity__c),amount,String.valueof(customPartlstUI[i].Covered__c),customPartlstUI[i].Fail_Code__c,customPartlstUI[i].Account_Code__c,customPartlstUI[i].PartOC__c,customPartlstUI[i].Warranty_Allocation__c,customPartlstUI[i].Quantity_Ordered__c,unitPrice,flag,unitPrice,getfailcodeDropDownBasedOnItem(customPartlstUI[i].Item__c ,null),getAccountCodeDropDown(customPartlstUI[i].Fail_Code__c),false,false, null, null, unitPrice, amount));
                system.debug('setpartWrapper--'+setpartWrapper);
            }
            if(customPartlstUI.size()<=4) {
               for(integer i=0;i<5-customPartlstUI.size();i++){
                    CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                    partsoption.Item__c = 'Select One';
                    partsoption.Part_Description__c = 'N/A';
                    partsoption.Quantity__c = null ;
                    partsoption.amount__c = 0;
                    partsoption.Covered__c = null;
                    partsoption.Fail_Code__c = '';
                    partsoption.Account_Code__c = '';
                    partsoption.PartOC__c = null;
                    partsoption.Warranty_Allocation__c = null;
                    partsoption.Quantity_Ordered__c = '';
                    partsoption.Sell_Price__c = null;
                    try{
                         setpartWrapper.add(new claimablesWrapperClass(customPartlstUI.size()+i,null,partsoption.Item__c,partsoption.Part_Description__c,String.valueof(partsoption.Quantity__c),partsoption.amount__c,String.valueof(partsoption.Covered__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,partsoption.PartOC__c,partsoption.Warranty_Allocation__c,partsoption.Quantity_Ordered__c,partsoption.Sell_Price__c,true,partsoption.Sell_Price__c,codesAC,codesAC,false,false, null, null, null, null));
                    }catch(Exception ex){
                        System.debug('in catch of getallCustomPartsData of CSS_GSQParts adding wrapper>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                    }
                  
                }
               
            }
           
        }else{
            listpartWrapper = new List<claimablesWrapperClass>();
            setpartWrapper = new Set<claimablesWrapperClass>();
            for(integer i=0;i<5;i++){
                CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                partsoption.Item__c = 'Select One';
                partsoption.Part_Description__c='N/A';
                partsoption.Quantity__c = null;
                partsoption.amount__c = 0;
                //partsoption.Quantity__c ='';
                partsoption.Covered__c =null ;
                partsoption.Fail_Code__c = '';
                partsoption.Account_Code__c = '';
                partsoption.PartOC__c = null;
                partsoption.Warranty_Allocation__c = null;
                partsoption.Quantity_Ordered__c = '';
                partsoption.Sell_Price__c = null;
                
                setpartWrapper.add(new claimablesWrapperClass(customPartlstUI.size()+i,null,partsoption.Item__c,partsoption.Part_Description__c,String.valueof(partsoption.Quantity__c),partsoption.amount__c,String.valueof(partsoption.Covered__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,partsoption.PartOC__c,partsoption.Warranty_Allocation__c,partsoption.Quantity_Ordered__c,partsoption.Sell_Price__c,true,partsoption.Sell_Price__c,codesAC,codesAC,false,false, null, null, null, null));
            system.debug('Testwrapperdata'+setpartWrapper);
                
            }
        }
       
    }catch(Exception ex){
        System.debug('in catch of getallCustomPartsData of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
    if(setpartWrapper != null && setpartWrapper.size()>0 ){
        system.debug('setpartWrapper>>>'+setpartWrapper);
        
         listpartWrapper.addAll(setpartWrapper);
         system.debug('setpartWrapper>>>2'+setpartWrapper);
    }
    
}
public void displayPopUp(){
    showPopup = true;
}



//Method to close the pop up 
public void closePopup(){
    getallCustomPartsData(false);
    getAllTTMLPartsData();
    qtyErrorMessage = false;
    showPopup = false;     
    ErrorMessage=false;
    ErrorMessage2=false;
    ttmlReqErrMsg=false;
    trveltowingerrmsg = false;
    duplicateAccountCode=false;
    amountcodegrt=false;
    TravelTowingTTMLError = false;
    TravelTowingError =false;
    towErrorOutputMsg=false;
    ShowTravelRateerr=false;
    //Start code as per story #148900 ,By RAJESH 08th Jan 2019-->       
    isMealsExpenseTotalError=false;
    isLodgingExpenseTotalError=false;
    isTowingExpenseTotalError=false;
    isExpenseTotalError=false;
    Parterrors.clear();
    NonParterrors.clear();
    //compareaccode = 'false';
    //End code as per story #148900 ,By RAJESH 08th Jan 2019--> 

    errMsgLstNew = new List<String>();
}
//Method to save the part's records from Popup
public PageReference saveOtherClaimablesPopup(){
    amountcodegrt=false;
    Integer count =0;
    chkReqField = false;
    ErrorMessage = false;
    ErrorMessage1 = false;
    ErrorMessage2 = false;
    TravelTowingError = false;
    qtyErrorMessage = false;//Quantity Error Message
    List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
    List<CSS_Parts_Options__c> TTMLList = new list<CSS_Parts_Options__c>();
    PageReference pageRef;
    Boolean validationOnAccUpQu;
    //Remove logic here
    
    try{
        if(removeIdsMap.keySet().size()>0){
            deleteParts();
        }
    }catch(Exception e) {
        system.debug('Error in Cust Parts Delete Component ## ' + e.getmessage());
    }
    
    set<boolean> setItemNullCheck = new set<boolean>() ;
    set<boolean> setUnlistedCheck = new set<boolean>();
    set<boolean> setduplicatecheck = new set<boolean>();
    set<boolean> setamounterror = new set<boolean>();
    set<boolean> setaccountcode = new set<boolean>();
    set<boolean> qUASet = new set<boolean>();
    
    integer count1=0;
    integer count2=0;
    integer m=0;
    totalamount = 0;
    String towCommErrMessage; 
    for(claimablesWrapperClass  prtslist:listpartWrapper ){
        System.debug('The listpartWrapper savelist list is>>>>>>>>>:'+prtslist);
        boolean x = ((prtslist.PartDescription!=null && prtslist.PartDescription!='' && prtslist.PartDescription!='N/A') || (prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.amount!=null && prtslist.amount!=0) || (prtslist.Unitprice!=0 && prtslist.Unitprice!=null) || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One' && prtslist.failCode!='') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='') || (prtslist.accountCode!=null && prtslist.accountCode!='Select One' && prtslist.accountCode!='')) && (prtslist.item== '' || prtslist.item== null || prtslist.item=='Select one');
        boolean  y = ((prtslist.PartDescription=='' || prtslist.PartDescription==null || prtslist.PartDescription=='N/A') &&   prtslist.item=='Unlisted');
        boolean z;
        boolean b;
        boolean k;
        setItemNullCheck.add(x);
        setUnlistedCheck.add(y);

        //condition for display Description value should blank
        if((prtslist.item=='Unlisted' || prtslist.item=='DCA' || prtslist.item=='Antifreeze/Coolant'|| prtslist.item=='Belt'|| prtslist.item=='Clamp'|| prtslist.item=='Coolant Filter'|| prtslist.item=='Crankcase Breather Element'|| prtslist.item=='Fuel Filter'|| prtslist.item=='Handling Allowance'|| prtslist.item=='Hose' || prtslist.item=='Import Charges' || prtslist.item=='Oil'|| prtslist.item=='Oil Filter'|| prtslist.item=='Replacement Engine' || prtslist.item=='Ties') && prtslist.PartDescription=='N/A')  {
            prtslist.PartDescription='';
        } 
        
        if((string.valueOf(prtslist.Unitprice)=='' || prtslist.Unitprice==null || prtslist.Unitprice==0) && prtslist.item!='Select One') {
            validationOnAccUpQu=true;
            qUASet.add(validationOnAccUpQu);
            prtslist.errorUP=true;
           
        }
        else{
            prtslist.errorUP=false;
        }
        
        if((prtslist.quantity == null || prtslist.quantity =='' || prtslist.quantity =='0') && prtslist.item!='Select One'){
            validationOnAccUpQu=true;
            qUASet.add(validationOnAccUpQu);
            prtslist.errorQua=true;
            
        }
        else{
            prtslist.errorQua=false;
        }
        
        //Condition for displaying duplicate alert.
        for(integer i=0;i<listpartWrapper.size();i++)
        {
            if(m!=i && prtslist.accountcode==listpartWrapper[i].accountcode && prtslist.item !='Select One')
            {
                if(prtslist.item !='Unlisted' && (prtslist.item==listpartWrapper[i].item))
                {
                    z = true;
                    setduplicatecheck.add(z);
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
                
            }
            
            
        }
        
        m++;
        
    }
    //below logic for to display error message for amount>$100,00
    integer l=0;
    for(claimablesWrapperClass  prtslist1:listpartWrapper )
    {
        for(integer i=0;i<listpartWrapper.size();i++)
        {
           if(l!=i&& prtslist1.accountcode == listpartWrapper[i].accountcode)
            {  
                if(prtslist1.accountcode !='Select One')
                    totalamount+= prtslist1.amount;
                if(totalamount>99999.99)
                {
                    boolean v=true;
                    setamounterror.add(v);
                    break;
                }
            }
        }
        l++;
    }
    //End
    //story 105553 validations logic
    if(setItemNullCheck.contains(true) && setUnlistedCheck.contains(true)){
        ErrorMessage1 =true;
        displayPopup2 = true;
        errorDisplay = true;
        ErrorMessage =true;
        displayPopup2 = true;
        errorDisplay1 = true;
        return null;
    }
    if(setItemNullCheck.contains(true)){
       ErrorMessage1 =true;
        displayPopup2 = true;
        errorDisplay = true;
        return null;
    }
    
    if(setUnlistedCheck.contains(true)){
        ErrorMessage =true;
        displayPopup2 = true;
        errorDisplay1 = true;
        return null;
    }
    if(setduplicatecheck.contains(true)){
        
        displayPopup2 = true;
        errorDisplay1 = true;
        ErrorMessage2 = true;
        return null;
        
        
    }
    if(setamounterror.contains(true)){
        
        displayPopup2 = true;
        errorDisplay1 = true;
        amountcodegrt = true;
        return null;
        
    }
    
    if(qUASet.contains(true)){
        qtyErrorMessage = true;
        return null;
    }
    
    
    // integer j=0;
    Map<String, List<String>> OCMap = new Map<String, List<String>>();
         TTMLList = [select Id, FailurepartId__r.CoveredOCAmount__c, Unit_Price__c,Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,PartOC__c,selected_part__c, Item__c, Part_Description__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                     Account_Code__c, Notes__c, ExpenseTotal__c, HoursTravelled__c, Mileage__c,Comments__c, Technician__c, Type__c, Days__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c,RecordType.Name,ODM_Status__c 
                     from CSS_Parts_Options__c where Service_Job__c =:Wid and (RecordType.Name ='TTML')];
            system.debug('TTMLList****' + TTMLList);
    
    if(count==0){
        List<String> tempList;
        for(claimablesWrapperClass  prtslist:listpartWrapper ){
            if((prtslist.quantity==null || prtslist.quantity=='') && (prtslist.PartDescription==null || prtslist.PartDescription=='' || prtslist.PartDescription=='N/A') && (prtslist.item==null || prtslist.item=='' || prtslist.item=='Select One' ) && (prtslist.amount==null  && prtslist.amount==0) && (prtslist.coveredPercent==null || prtslist.coveredPercent=='') && (prtslist.failCode==null && prtslist.failCode=='Select One') && (prtslist.accountCode==null && prtslist.accountCode=='Select One')){
                if(prtslist.ids != null && String.valueOf(prtslist.ids).trim() !=''){
                    removeIdsMap.put(prtslist.ids, String.valueOf(prtslist.ids));
                }
                
            }
            if(prtslist.item!=null &&  prtslist.item!='Select One'){
                CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                partsoption.recordtypeId  = recTypeIdpart;
                partsoption.Item__c = prtslist.item;
                partsoption.Misc_LOV__c = prtslist.item;
                partsoption.Part_Description__c = prtslist.PartDescription;
                partsoption.selected_part__c = true;//venkat
                if(prtslist.quantity!='' && prtslist.quantity!=null)
                    partsoption.Quantity__c = Decimal.ValueOf(prtslist.quantity);
                /*partsoption.Amount__c = prtslist.amount;
                partsoption.Sell_Price__c = prtslist.Unitprice;*/
                
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
                                partsoption.Sell_Price__c = (prtslist.Unitprice) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                                partsoption.Amount__c = (prtslist.amount) / (lstCurrencyDetails[0].Bolt_Conversion_Rate__c);
                            }
                            else{
                                partsoption.Exchange_Rate__c = 1;
                                partsoption.Unit_Price_Local_Currency__c = prtslist.Unitprice;
                                partsoption.Amount_Local_Currency__c = prtslist.amount;
                                partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                partsoption.Sell_Price__c = prtslist.Unitprice;
                            }
                            partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                        }
                    }
                }
                else{
                    partsoption.Amount__c = prtslist.amount;
                    partsoption.Sell_Price__c = prtslist.Unitprice;
                }
                //GSSC-138 end
                
                if(prtslist.coveredPercent!='' && prtslist.coveredPercent!=null)
                    partsoption.Covered__c = Decimal.valueOf(prtslist.coveredPercent);
                if(prtslist.coveredPercent == '0' || prtslist.coveredPercent == null || prtslist.coveredPercent == ''){
                    partsoption.Account_Code__c = 'Select One';
                    partsoption.Claimtype__c = '';
                }
                else
                    partsoption.Account_Code__c = prtslist.accountCode;
                partsoption.Fail_Code__c = prtslist.failCode;
                if(prtslist.failCode=='Select One')
                    partsoption.Account_Code__c = 'Select One';
                if(prtslist.failCode=='Select One')
                    partsoption.Covered__c = null;
                partsoption.Id=prtslist.ids;
                partsoption.Id=prtslist.idStr;
                partsoption.Service_Job__c = JobId;
               if(mpItemNewWarranty.containskey(prtslist.item)){
                   string NewWarrantyClass = mpItemNewWarranty.get(prtslist.item);
                   if(NewWarrantyClass == 'Unlisted (Warrantable)')
                        partsoption.Siebel_Value__c = NewWarrantyClass;
                }
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
                        
                
               if(duplicateAccountCode == true)
                    if(amountcodegrt==true)
                    break;
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
        
         for(string Str : OCMap.keySet()){
               List<string> tempvar;
               tempvar = OCMap.get(Str);
               if(tempvar!=null && (tempvar.contains('COMMERCIAL TRAVEL') || tempvar.contains('Commercial-Travel') || tempvar.contains('NON COMMERCIAL TRAVEL') || tempvar.contains('Non Commercial-Travel')) && tempvar.contains('TOWING')){
                TravelTowingError=true;
                system.debug('TravelTowingError***' + TravelTowingError);
                return null;
           }
           }
            

       try{
            if(removeIdsMap.keySet().size()>0){
                deleteParts();
            }
        }catch(Exception ex) {
            System.debug('first in catch of saveCustomParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    displayPopup2 = false;
    CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
    errMsgLst = new Set<String>();
    if(selectedCustPartsList != null && selectedCustPartsList.size() > 0){
        errMsgLst = contr.covLimitValidation(Wid, null, null, selectedCustPartsList);
    }
    if(errMsgLst != null && errMsgLst.size() > 0){
        for(claimablesWrapperClass prtslist:listpartWrapper){
            if(errMsgLst != null && errMsgLst.contains(prtslist.accountCode)){
                prtslist.isPartsCovLimitExceed = true;
            }
            else{
                prtslist.isPartsCovLimitExceed = false;
            }
        }
    }else{
        if(selectedCustPartsList.size()>0 && qtyErrorMessage==false){
            upsert selectedCustPartsList Id;
        }
        getallCustomPartsData(displayPopup2);
    }
    
    String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
    pageRef = new PageReference(sDestURL+'id='+Wid); 
    pageRef.setRedirect(true);
    errMsgLstNew = new List<String>();
    if(errMsgLst != null && errMsgLst.size() > 0){
        for(String err : errMsgLst){
            errMsgLstNew.add(Label.CSS_OC_CoverageLimitExceedMsg+' '+err);
        }
        return null;
    }else{
        return pageRef;
    }
} 


public void deleteParts(){
    try{
        List<CSS_Parts_Options__c> toDeleteOtherClaimablesList = new list<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> deleteOtherClaimablesList = new List<CSS_Parts_Options__c>([select Id,Covered__c,Amount__c,Fail_Code__c,Quantity__c,Account_Code__c,Item__c,
                                                                                               Service_Job__c,Solutions__c from CSS_Parts_Options__c where Id in:removeIdsMap.keySet()]);
        if(deleteOtherClaimablesList.size()>0){
            for(CSS_Parts_Options__c d: deleteOtherClaimablesList){
                for(claimablesWrapperClass  prtslist:listpartWrapper ){
                    
                    if(d.id==prtslist.ids){  //why servPartNumber included in if condition?
                        toDeleteOtherClaimablesList.add(d); 
                    }
                    else{
                    }
                    
                }     
            }
            if(toDeleteOtherClaimablesList.size()>0)
                delete toDeleteOtherClaimablesList;
        }
        removeIdsMap = new Map<Id, String>();
    }catch(Exception ex) {
        System.debug('in catch of deleteParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
}

public void deleteTTMLParts(){
    try{
        List<CSS_Parts_Options__c> toDeleteTTMLList = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> deleteTTMLList = new List<CSS_Parts_Options__c>([SELECT Id FROM CSS_Parts_Options__c WHERE Id IN:removeIdsMap.keySet()]);
        if(deleteTTMLList.size()>0)
            delete deleteTTMLList;
        removeIdsMap = new Map<Id, String>();
    }catch(Exception ex) {
        System.debug('in catch of delete TTML Parts'+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
}
//Method for display the fail codes from UI side as per #105558 (RAJESH)
public List<SelectOption> getfailcodeDropDown()    
{    
    List<SelectOption> options =  new List<SelectOption>(); 
    Set<string> sortableSet = new  Set<string>();
    List<string> sortable = new  List<string>();
    failAccountCodeMap = new  Map<String, set<String>>();
    List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
    if(Wid==null){
        solsComp = null;
    }
    else{
        //solsComp= [SELECT Id, FailCode_Formula__c,CSS_Account_Formula__c ,SysCodeAndCompCode__c,Selected_Component__c ,Parts_Warranty__c,CoveredOCAmount__c,CampaignOCPercentage__c,Type__c from CSS_Solution_Component__c where Service_Job__c =:Wid and FailCode_Formula__c!=null and (((Type__c != 'Campaign' and Type__c != 'ATC' and Type__c != 'TRP') and Selected_Component__c= true) or ((Type__c = 'Campaign' or Type__c = 'ATC' or Type__c = 'TRP') and Performed__c = true))];//and Solutions__r.Diagnostic_Response__c='Most likely the solution' // Commented this and added performed_review__c field as per story 190513
    solsComp= [SELECT Id, FailCode_Formula__c,CSS_Account_Formula__c ,SysCodeAndCompCode__c,CSS_CoverageType__c,Selected_Component__c ,Parts_Warranty__c,CoveredOCAmount__c,CampaignOCPercentage__c,Type__c from CSS_Solution_Component__c where Service_Job__c =:Wid and FailCode_Formula__c!=null and (((Type__c != 'Campaign' and Type__c != 'ATC' and Type__c != 'TRP') and Selected_Component__c= true and Root_Cause__c = true) or ((Type__c = 'Campaign' or Type__c = 'ATC' or Type__c = 'TRP') and Performed_review__c = true))];//and Solutions__r.Diagnostic_Response__c='Most likely the solution'
        
    }
    options.add(new SelectOption('Select One','Select One'));
    system.debug('solsComp-->'+solsComp);
    if(solsComp.size()>0){
        set<string> acCodeSet;
        for(CSS_Solution_Component__c f:solsComp)  {
            system.debug('failAccountCodeMap-->'+failAccountCodeMap);
            system.debug(f.FailCode_Formula__c+f.SysCodeAndCompCode__c);
            if(f.FailCode_Formula__c!='Select One' && f.FailCode_Formula__c!=null && f.SysCodeAndCompCode__c !='Select One'){
                sortableSet.add(f.FailCode_Formula__c);
                if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                    
                    acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                    if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                        if(JETFA != null){
                            for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                                if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                        else{
                            if(f.CSS_Account_Formula__c !='Select One' && f.CoveredOCAmount__c != null && Integer.valueOf(f.CoveredOCAmount__c) >0 && f.Selected_Component__c== true  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignOCPercentage__c != null && Integer.valueOf(f.CampaignOCPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign')  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                    }
                    
                    failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                }
                else{
                    acCodeSet = new set<string>();
                    if(f.CSS_Account_Formula__c != null){
                        if(JETFA != null){
                            for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                                if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                        else{
                            if(f.CSS_Account_Formula__c !='Select One' && f.CoveredOCAmount__c != null && Integer.valueOf(f.CoveredOCAmount__c) >0 && f.Selected_Component__c== true  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignOCPercentage__c != null && Integer.valueOf(f.CampaignOCPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign')  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                    }
                    failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                }
            }
        }
    }
    if(sortableSet.size()>0){
        sortable.AddAll(sortableSet);}
    sortable.sort();
    if (sortable.size()>0){
        for(String s:sortable)    {   
            options.add(new selectOption(s,s));   
        }   
    }
    system.debug('**Options**'+Options);
    return Options; 
    
}
//END


    //New Method for getting Failcode and Account codes as per story GSSC-142 -By RAJESH 22nd Oct 2019 
public List<SelectOption> getfailcodeDropDownBasedOnItem(string selectedItem, Integer selectedPartId){    
    List<SelectOption> options =  new List<SelectOption>(); 
    Set<string> sortableSet = new  Set<string>();
    List<string> sortable = new  List<string>();
    
            failAccountCodeMap = new  Map<String, set<String>>();
   // List<CSS_Solution_Component__c> solsCompR = new List<CSS_Solution_Component__c>(); // Commented and declared as public to fix 101 issue
    if(Wid==null){
        solsCompR = null;
    }
    else{
        //solsCompR= [SELECT Id, FailCode_Formula__c,CSS_Account_Formula__c ,SysCodeAndCompCode__c,CoveredTravelBaseFareAmt__c,CoveredTravelLabor__c,CoveredTowingMiles__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CSS_CoverageType__c,Selected_Component__c ,Parts_Warranty__c,CoveredOCAmount__c,CampaignOCPercentage__c,Type__c from CSS_Solution_Component__c where  Service_Job__c =:Wid and FailCode_Formula__c!=null and (((Type__c != 'Campaign' and Type__c != 'ATC' and Type__c != 'TRP') and Selected_Component__c= true and Root_Cause__c= true) or ((Type__c = 'Campaign' or Type__c = 'ATC' or Type__c = 'TRP') and Performed_review__c = true))];//and Solutions__r.Diagnostic_Response__c='Most likely the solution'
      solsCompR=solsCompR;  
    }
    failAccountCodeMap = new  Map<String, Set<String>>();
    options.add(new SelectOption('Select One','Select One'));
  if(selectedItem != 'COMMERCIAL TRAVEL' && selectedItem != 'TOWING'){
    if(solsCompR != null && solsCompR.size()>0){
        set<string> acCodeSet;
        for(CSS_Solution_Component__c f:solsCompR)  {
            system.debug('failAccountCodeMap-->'+failAccountCodeMap);
            system.debug(f.FailCode_Formula__c+f.SysCodeAndCompCode__c);
            if(f.FailCode_Formula__c!='Select One' && f.FailCode_Formula__c!=null && f.SysCodeAndCompCode__c !='Select One'){
                sortableSet.add(f.FailCode_Formula__c);
                if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                    
                    acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                    if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                        if(JETFA != null){
                            for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                                if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                        else{
                            if(f.CSS_Account_Formula__c !='Select One' && f.CoveredOCAmount__c != null && Integer.valueOf(f.CoveredOCAmount__c) >0 && f.Selected_Component__c== true  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignOCPercentage__c != null && Integer.valueOf(f.CampaignOCPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign')  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                    }
                    
                    failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                }
                else{
                    acCodeSet = new set<string>();
                    if(f.CSS_Account_Formula__c != null){
                        if(JETFA != null){
                            for(CSS_JobEventTemporary__c jobEntObj : JETFA){
                                if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                        else{
                            if(f.CSS_Account_Formula__c !='Select One' && f.CoveredOCAmount__c != null && Integer.valueOf(f.CoveredOCAmount__c) >0 && f.Selected_Component__c== true  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignOCPercentage__c != null && Integer.valueOf(f.CampaignOCPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign')  && (coverageType != 'OTH' && coverageType != 'POL'))
                                acCodeSet.add(f.CSS_Account_Formula__c);
                        }
                    }
                    failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                }
            }
        }
    }
  }
  else{
    if(solsCompR != null && solsCompR.size()>0){
                Set<string> acCodeSet;
                for(CSS_Solution_Component__c solComRec:solsCompR){
                    if(solComRec.Selected_Component__c==true){
                        if(solComRec.Type__c==null || solComRec.Type__c==''){
                            system.debug('**inside main if**'+solComRec.CSS_CoverageType__c);
                                if(solComRec.CSS_CoverageType__c!='OTH' || solComRec.CSS_CoverageType__c!='POL'){
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
                        if(solComRec.CSS_CoverageType__c!='OTH' || solComRec.CSS_CoverageType__c!='POL'){
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
            system.debug('prtslist.lstFailcodes>>>' +  prtslist.lstFailcodes);
         }
   }
    }
    
   system.debug('***Final options****' +  options);
    return options;    
}
//END






//Logic for account Code dispaly  #105559 story 

public css_job_order__c workJob {get;set;}
public list<string> lstAccountCodes{get;set;}
public List<SelectOption> accCodes{get;set;}
public list<CSS_JobEventTemporary__c> jobEventTemp {get;set;}
 public List<SelectOption> getAccountCodeDropDown(String selectedFailCode) {
    List<SelectOption> options;
    try{
        String failCode1;
        String[] tempStr;
        if(selectedFailCode.contains('-')){
            tempStr = selectedFailCode.split('-');
            if(tempStr.size()==2){
               failCode1=tempStr[1].trim().LEFT(4);
            }
            else if(tempStr.size()==3){
                failCode1=tempStr[2].trim().LEFT(4);
            }
            else if(tempStr.size()==4){
                failCode1=tempStr[3].trim().LEFT(4);
            }
        }
        else{
            failCode1=selectedFailCode;
        }
        options =  new List<SelectOption>();
        if(selectedFailCode==null || failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || !failAccountCodeMap.containsKey(failCode1)){
            options.add(new SelectOption('Select One','Select One'));
            return options;
        }
        List<string> sortable = new  List<string>();
         if(failAccountCodeMap.containsKey(failCode1)){
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
        
    }catch(Exception ex) {
        System.debug('in catch of getAccountCodeOptionList>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
    return options;
}

public void onChangeofEstimate(){
    if(selectedEstimate==true)
    {
        system.debug('TestoC1********'+otherClaimPartList);
        if(otherClaimPartList!=null && otherClaimPartList.size()>0){
            for(css_parts_options__c part:otherClaimPartList)
            {
                if(part.id==SelectedPart)
                {
                    part.selected_part__c=true;   
                }
            }
        }
        
    }
}
public void onChangeofItem(){
    system.debug('mpItemNewWarranty**'+mpItemNewWarranty);
     if(mpItemNewWarranty.containskey(SelectedItem)){
      string NewWarrantyClass = mpItemNewWarranty.get(SelectedItem);
       if(NewWarrantyClass!=null && NewWarrantyClass == 'Unlisted (Warrantable)'){
            //Start code for syory GSSc-142,-BY RAJESH 21st Oct 2019                
                getfailcodeDropDownBasedOnItem(SelectedItem,SelectedPartID);
    //End code for syory GSSc-142,-BY RAJESH 21st Oct 2019   
           for(claimablesWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID){ 
                    prtslist.showaccountcode = true;
                    prtslist.Unitprice=null;
                       
                 }
                else if(prtslist.Unitprice==0){
                    prtslist.Unitprice=null;
                }
                
            }
        }
        else{
            //Start code for syory GSSc-142,-BY RAJESH 21st Oct 2019                
                getfailcodeDropDownBasedOnItem(SelectedItem,SelectedPartID);
    //End code for syory GSSc-142,-BY RAJESH 21st Oct 2019 
            for(claimablesWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.showaccountcode = false;
                    prtslist.accountCode=null;
                    prtslist.coveredPercent='';
                    prtslist.quantity = '';
                    prtslist.Unitprice=null;
                    prtslist.amount=0;
                    prtslist.failCode = null;
                }
                else if(prtslist.Unitprice==0){
                    prtslist.Unitprice=null;
                 }
            }   
        }
    }
    
    else
    {
         //Start code for syory GSSc-142,-BY RAJESH 21st Oct 2019                
                getfailcodeDropDownBasedOnItem(SelectedItem,SelectedPartID);
    //End code for syory GSSc-142,-BY RAJESH 21st Oct 2019     
        for(claimablesWrapperClass  prtslist:listpartWrapper ){
            if(prtslist.counting == SelectedPartID)
            {
                prtslist.PartDescription =  '';
                prtslist.accountCode=null;
                prtslist.coveredPercent='';
                prtslist.quantity = '';
                prtslist.Unitprice=null;
                prtslist.amount=0;
                prtslist.failCode = null;
             }
            else if(prtslist.Unitprice==0){
                prtslist.Unitprice=null;
            }
        } 
        
    }
    
   populateOCFailCodenAccountCode(SelectedItem); 
}

public void populateOCFailCodenAccountCode(String selItem){
    system.debug('Method goining inside onChangeofFailCode'+selItem);
    system.debug('failAccountCodeMap>>>>>>>>>>: '+failAccountCodeMap);
    
    list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
    lstSolComp= [SELECT Id, Over_The_Counter__c, SysCodeAndCompCode__c, FailCode_Formula__c , CampaignTravelPercentage__c, CSS_CoverageType__c,CSS_Claims__c,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CampaignOCPercentage__c,Selected_Component__c,Type__c  from CSS_Solution_Component__c where Service_Job__c =:wid and FailCode_Formula__c!=null and CSS_Account_Formula__c!='' and Selected_Component__c= true];
    
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
        system.debug('***accSolCmpMap***'+accSolCmpMap);
        if((tempListFA!=null && tempListFA.size() == 1 && selItem == 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL' && tempListFA[0].CampaignOCPercentage__c != null && Integer.valueOf(tempListFA[0].CampaignOCPercentage__c) >0) || (tempListFA!=null && tempListFA.size() == 1 && selItem == 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL' && (tempListFA[0].CSS_CoverageType__c == 'POL' || tempListFA[0].CSS_CoverageType__c == 'OTH'))){
            CoveredPar =  tempListFA[0].CampaignOCPercentage__c; 
            failCode =  String.valueof(tempListFA[0].FailCode_Formula__c);
            accCode = tempListFA[0].CSS_Account_Formula__c;
            options=getAccountCodeDropDown(tempListFA[0].SysCodeAndCompCode__c);
        }
        else if(tempList !=null && tempList.size() >0 && selItem != 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL'){
            if((tempList.size() == 1 && tempList[0].CoveredOCAmount__c != null && Integer.valueOf(tempList[0].CoveredOCAmount__c) >0) || (selItem != 'Campaign Supplies' && selItem != 'COMMERCIAL TRAVEL' && (tempList[0].CSS_CoverageType__c == 'POL' || tempList[0].CSS_CoverageType__c == 'OTH'))){
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
        system.debug('***failCode***'+failCode);
        system.debug('***accCode***'+accCode);
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
            if(prtslist.counting == SelectedPartID)
            {
                system.debug('**insideif*failCode***'+failCode);
                prtslist.failCode =  String.valueof(failCode);
                if(prtslist.Unitprice ==0)
                    prtslist.Unitprice = null;
                
                if(prtslist.showaccountcode==true){
                    
                    prtslist.accountCode = accCode ;
                    prtslist.lstFCAC = options;
                }
                else{
                    
                    prtslist.accountCode=null;
                }
                
                if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                    prtslist.coveredPercent='';
                else
                    prtslist.coveredPercent=CoveredPar;
            }
            else
                if (prtslist.Unitprice ==0){
                    prtslist.Unitprice=null;
                    
                }
            system.debug('**prtslist.failCode***'+prtslist.failCode);
            system.debug('**prtslist.showaccountcode***'+prtslist.showaccountcode);
            system.debug('**prtslist.accountCode***'+prtslist.accountCode);
        }
        
        populateAmountValue();
        
    }
    
    //GSSC-300
}

public void onChangeofFailCode(){
    
    system.debug('SelectedFailCode**'+selectedFailCode);
    String failCode1;
    String[] tempStr;
    if(selectedFailCode.contains('-')){
        
        tempStr = selectedFailCode.split('-');
        system.debug('Inside -**'+tempStr);
        if(tempStr.size()==2){
            failCode1=tempStr[1].trim().LEFT(4);
        }
        else if(tempStr.size()==3){
            failCode1=tempStr[2].trim().LEFT(4);
        }
        else if(tempStr.size()==4){
            failCode1=tempStr[3].trim().LEFT(4);
        }
    }
    else{
        failCode1=selectedFailCode;
    }
    system.debug('SelectedFailCode2**'+selectedFailCode);
    String accCode;
    String CoveredPar ='';
    list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
    if(SelectedFailCode!='Select One'){
        List<SelectOption> options=getAccountCodeDropDown(failCode1);
        lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,CSS_CoverageType__c,AccountCode__c,CampaignOCPercentage__c,Type__c,Selected_Component__c from CSS_Solution_Component__c where Service_Job__c =:wid and FailCode_Formula__c = :SelectedFailCode and CSS_Account_Formula__c!=''];
        system.debug('lstSolComp**'+lstSolComp);
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
            
            
            if(lstSolComp[0].CoveredOCAmount__c != null && lstSolComp[0].CoveredOCAmount__c != '' && Double.valueOf(lstSolComp[0].CoveredOCAmount__c) >0 && lstSolComp[0].Selected_Component__c == true)//(lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'|| lstSolComp[0].Type__c =='Campaign') && (coverageType != 'OTH' && coverageType != 'POL'))
                CoveredPar =  lstSolComp[0].CoveredOCAmount__c; 
            else if(lstSolComp[0].CampaignOCPercentage__c != null && lstSolComp[0].CampaignOCPercentage__c != '' && Double.valueOf(lstSolComp[0].CampaignOCPercentage__c) >0 && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC' || lstSolComp[0].Type__c =='Campaign'))
                CoveredPar =  lstSolComp[0].CampaignOCPercentage__c;
}
         if(CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0 ){
            CoveredPar = '100';
        }
        else if(CoveredPar!='' && Integer.ValueOf(CoveredPar) == 0){
            CoveredPar = '0';
            
        }
        else{
            CoveredPar = '';
        }
        
        
        for(claimablesWrapperClass  prtslist:listpartWrapper ){
            
            if(prtslist.counting == SelectedPartID)
            {
                prtslist.failCode =  String.valueof(SelectedFailCode);
                if(prtslist.Unitprice ==0)
                    prtslist.Unitprice = null;
                
                if(prtslist.showaccountcode==true){
                    
                    prtslist.accountCode = accCode ;
                    prtslist.lstFCAC = options;
                }
                else{
                    
                    prtslist.accountCode=null;
                }
                
                if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                    prtslist.coveredPercent='';
                else
                    prtslist.coveredPercent=CoveredPar;
            }
            else
                if (prtslist.Unitprice ==0){
                    prtslist.Unitprice=null;
                    
                }
            
            
        } 
    }
    else{
        accCode='Select One';
        CoveredPar='';
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
        for(claimablesWrapperClass  prtslist:listpartWrapper ){
            if(prtslist.counting == SelectedPartID)
            {
                prtslist.failCode =  String.valueof(SelectedFailCode);
                prtslist.coveredPercent='';
                prtslist.accountCode = accCode ;
                prtslist.lstFCAC = options;
                if(prtslist.Unitprice ==0)
                    prtslist.Unitprice = null;
                
                
            }
            else
                if (prtslist.Unitprice ==0){
                    prtslist.Unitprice=null;
                }
        } 
        
    }
    
    populateAmountValue();
}
//Method for getting %coverd when we are chaning Account codes as per #105557 (RAJESH)
public void onChangeofAccountCode(){
    String CoveredParAC ='';
    list<CSS_Solution_Component__c> lstSolComp1 = new list<CSS_Solution_Component__c>();
    if(SelectedAccountCode!='Select One'){
        for(claimablesWrapperClass  prtslist:listpartWrapper ){
             if(prtslist.counting == SelectedPartID){
                prtslist.accountCode =  String.valueof(SelectedAccountCode);
                if((prtslist.accountCode == null || prtslist.accountCode == 'Select One') && (prtslist.failCode == null || prtslist.failCode == 'Select One'))
                    prtslist.coveredPercent='';
                else
                    prtslist.coveredPercent = '100';//CoveredParAC;  
               if (prtslist.Unitprice ==0)
                    prtslist.Unitprice=null;
                
            }
             else if(prtslist.Unitprice ==0){
                prtslist.Unitprice=null;
            }
            
        }
   }else{
        CoveredParAC='';            
        for(claimablesWrapperClass  prtslist:listpartWrapper ){
            if(prtslist.counting == SelectedPartID)
            {
                prtslist.accountCode =  String.valueof(SelectedAccountCode);
                prtslist.coveredPercent='';
                if(prtslist.Unitprice == 0)
                    prtslist.Unitprice=null;
                
            }
            else
                if(prtslist.Unitprice == 0){
                    prtslist.Unitprice=null;
                }
            
            
        }          
    }
    populateAmountValue();
}  


public void populateAmountValue(){
    try
    {
        for(Integer i=0;i<listpartWrapper.size();i++)
        {
            if(listpartWrapper[i].counting==selectedRecordRowID)
            {
                if((Decimal.valueOf(listpartWrapper[i].quantity)!=null) && 
                   (listpartWrapper[i].Unitprice!= null || listpartWrapper[i].Unitprice != 0) &&
                   (listpartWrapper[i].accountCode == 'Select One' || listpartWrapper[i].accountCode == '' || listpartWrapper[i].accountCode == null)) 
                {
                    listpartWrapper[i].amount =  Decimal.valueOf(listpartWrapper[i].quantity) * listpartWrapper[i].Unitprice;
                   
                }
                
                if((Decimal.valueOf(listpartWrapper[i].quantity)!=null) && 
                   (listpartWrapper[i].Unitprice!= null) &&
                   (Decimal.valueOf(listpartWrapper[i].coveredPercent) !=null) &&
                   (listpartWrapper[i].accountCode != 'Select One' && listpartWrapper[i].accountCode != '' && listpartWrapper[i].accountCode != null))
                {
                    listpartWrapper[i].amount =  Decimal.valueOf(listpartWrapper[i].quantity) * (Decimal.valueOf(listpartWrapper[i].coveredPercent)/100) * listpartWrapper[i].Unitprice;
                    //Below code is added as part of the defect # 190703
                    listpartWrapper[i].amount = listpartWrapper[i].amount.setScale(2);
                }
                
                if((Decimal.valueOf(listpartWrapper[i].coveredPercent) ==0) ||(Decimal.valueOf(listpartWrapper[i].coveredPercent) ==null))
                {
                    listpartWrapper[i].accountCode = 'Select One';
                    listpartWrapper[i].amount =  Decimal.valueOf(listpartWrapper[i].quantity) * listpartWrapper[i].Unitprice;
                   
                }
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
 public void AddRow(){
    try{
        listpartWrapper2=listpartWrapper.clone();
        listpartWrapper.clear();
        
        listpartWrapper2.add(new claimablesWrapperClass(listpartWrapper2.size(),null,null,'N/A',null,0,null,null,null,null,null,null,null,true,null,null,null,false,false, null, null, null, null));
        listpartWrapper=listpartWrapper2.clone();
        listpartWrapper2.clear();
    }catch(Exception ex) {
        System.debug('in catch of AddRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
}

public void addTTMLRow(){
    try{  
       List<SelectOption> lstFc = new List<SelectOption>();
        lstFc.add(new SelectOption('Select One','Select One'));
        listTTMLWrapper.add(new ttmlWrapperClass(listTTMLWrapper.size(),null,null,'Select One',null,null,null,null,null,null,null,false,false,false,false,false,lstFc,null,null,null,null,null,false,null,null,false,lstFc,false, null));
        
    }catch(Exception ex) {
        System.debug('in catch of AddRow of TTML Popup>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
}
public Integer assignedParts{get;set;}
//public Map<Id, String> removeIdsMap = new Map<Id, String>();
public void removingRow(){
     try{
        listpartWrapper2=listpartWrapper.clone();
        listpartWrapper.clear();
        for(Integer i=0;i<listpartWrapper2.size();i++){
            if(listpartWrapper2[i].counting==assignedParts){
                listpartWrapper2[i].quantity='';
                listpartWrapper2[i].PartDescription='N/A';
                listpartWrapper2[i].Item='';
                listpartWrapper2[i].amount=0;
                listpartWrapper2[i].unitprice=null;
                listpartWrapper2[i].coveredPercent='';
                listpartWrapper2[i].failCode='';
                listpartWrapper2[i].accountCode='';
                
                if(listpartWrapper2[i].ids != null && String.valueOf(listpartWrapper2[i].ids).trim() !=''){
                    removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                }
                
            }
        }
        
        listpartWrapper=listpartWrapper2.clone();
        listpartWrapper2.clear();
    }catch(Exception ex) {
        System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
}


public void removingTTMLRow(){
     try{
        listTTMLWrapper2=listTTMLWrapper.clone();
        listTTMLWrapper.clear();
        for(Integer i=0;i<listTTMLWrapper2.size();i++){
            if(listTTMLWrapper2[i].counting==selectedRemoveRow){
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
                listTTMLWrapper2[i].showMileageHT = false;
                listTTMLWrapper2[i].accCoverage = false;
                listTTMLWrapper2[i].unitprice = '';
                listTTMLWrapper2[i].isTTMLFailcodeCovLimitExceed =false;
                listTTMLWrapper2[i].isTTMLAccCodeCovLimitExceed =false;
                if(listTTMLWrapper2[i].ids != null && String.valueOf(listTTMLWrapper2[i].ids).trim() !=''){
                    removeIdsMap.put(listTTMLWrapper2[i].ids, String.valueOf(listTTMLWrapper2[i].ids));
                }
                
            }
        }
        
        listTTMLWrapper=listTTMLWrapper2.clone();
        listTTMLWrapper2.clear();
    }catch(Exception ex) {
        System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
}
public PageReference saveOtherClaimables()
{
   
    List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
    if(pgId != null){
        solsComp = [select name,action__c,FailCode_Formula__c,Parts_Warranty__c,Component_Id__c,Failure_Date__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,Failure_Measure__c,CSS_Account_Formula__c,Selected_Component__c,Solutions__c,Quantity__c,Service_Job__c,Fail_Code__c ,Fail_Code_Editable__c,AccountCodeEdit__c,AccountCode__c,AccountCodeType__c,Authorization_Number__C,Approval_Code__c,Pay_Code__c,CSS_CoverageType__c,
                    Claim_Type__c,RoadRelay_Warranty__c,Failure_Mode__c,CoveredPartsQty__c,System_Code__c,Component_Code__c
                    from CSS_Solution_Component__c where Service_Job__c=:pgId and FailCode_Formula__c!=null and Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true];
    }
    system.debug('TestoC1********'+otherClaimPartList);
   if(otherClaimPartList!= null && !otherClaimPartList.isEmpty()){
        if(dealer != 'DLR')
            boolean ocValidation = CG_BL_ODM.callODMOtherClaimableValidationService(workJob,null,null,'JOB',solsComp,otherClaimPartList);
        update otherClaimPartList;
        system.debug('TestoC********'+otherClaimPartList);
        
    }
    //Karthik Edited to populate Data In Attachement section
    String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
    PageReference pageRef = new PageReference(sDestURL+'id='+Wid); 
    pageRef.setRedirect(true);
    return pageRef; 
}

public PageReference saveTTMLParts(){
    try{
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        if(pgId != null){
            solsComp = [select name,action__c,FailCode_Formula__c,Parts_Warranty__c,Component_Id__c,Failure_Date__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,Failure_Measure__c,CSS_Account_Formula__c,Selected_Component__c,Solutions__c,Quantity__c,Service_Job__c,Fail_Code__c ,Fail_Code_Editable__c,AccountCodeEdit__c,AccountCode__c,AccountCodeType__c,Authorization_Number__C,Approval_Code__c,Pay_Code__c,CSS_CoverageType__c,
                        Claim_Type__c,Failure_Mode__c,RoadRelay_Warranty__c,CoveredPartsQty__c,System_Code__c,Component_Code__c
                        from CSS_Solution_Component__c where Service_Job__c=:pgId and FailCode_Formula__c!=null and Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true];
        
            system.debug('Testsol'+solsComp);
        }
        if(ttmlPartsList != null && !ttmlPartsList.isEmpty()){ 
             system.debug('Testsol>>>');
            //Call ODM Travel Service
            if(dealer != 'DLR')
                boolean ocValidation = CG_BL_ODM.callODMTravelValidationService(workJob,null,null,'JOB',solsComp,ttmlPartsList);
            update ttmlPartsList;
        }
    }catch(exception e){
        System.debug('The following exception has occurred in Save TTML Parts: ' + e.getMessage());
        
    }  
    //Karthik Edited to populate Data In Attachement section
    String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
    PageReference pageRef = new PageReference(sDestURL+'id='+Wid); 
    pageRef.setRedirect(true);
    return pageRef; 
}

/* public void TTMLData(){
    System.debug('calling getAllTTMLPartsData');
    closePopup();
    //getAllTTMLPartsData();
    System.debug('After calling getAllTTMLPartsData');
} */

public void getAllTTMLPartsData(){
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
    Map<String, List<CSS_Solution_Component__c>> lcsolfail = new Map<String, List<CSS_Solution_Component__c>>();
    list<CSS_Solution_Component__c> listsolfail = new List<CSS_Solution_Component__c>();
    
    try{
        recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        /*Commented below query as part of 101 SOQL fix
        ttmlPartlstUI = [select Id,Service_Job__c,Item__c,Part_Description__c,Quantity__c,Unit_Price__c,amount__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c, Exchange_Rate__c, Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,Comments__c,PartOC__c,Covered__c,Fail_Code__c,Account_Code__c,
                         Technician__c, Type__c, Siebel_Value__c,Misc_LOV__c,Days__c, Mileage__c, HoursTravelled__c, Notes__c, ExpenseTotal__c,FailurepartId__r.CoveredOCAmount__c,RecordType.Name,ODM_Status__c 
                         from CSS_Parts_Options__c where Service_Job__c =:Wid and (RecordTypeId=:recTypeIdTTML or PartOC__c = 'TOW') ORDER BY CreatedDate];
        */
        
               // lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,Type__c,Selected_Component__c,CoveredOCAmount__c ,CampaignTowingPercentage__c,CoveredTravelBaseFareAmt__c,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c,FailCode_Formula__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c,CSS_CoverageType__c from CSS_Solution_Component__c where Root_Cause__c= true AND Service_Job__c =:wid AND Selected_Component__c = true AND CSS_Account_Formula__c != null];

        
        jobObj = [select id, CSS_Travel_Rate__c,CSS_In_Shop_Labor_Rate__c from css_job_order__c where id=:Wid];
        css_header_nav__c rswBotton =css_header_nav__c.getInstance(UserInfo.getUserId());	
        
        system.debug('Testttml>>'+newPartlstUI);
        
        solsCompTTML = new List<CSS_Solution_Component__c>();
        solsCompTTML= [SELECT Id,CSS_Account_Formula__c, Type__c,CoveredTravelBaseFareAmt__c, CSS_CoverageType__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, Parts_Warranty__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: wid AND ((Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution') OR (Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
    
    /*for(CSS_Solution_Component__c lc :lstSolComp){
            listsolfail.add(lc);
            lcsolfail.put(lc.FailCode_Formula__c,listsolfail);
        } */
        
        system.debug('Test222>'+lcsolfail);
        if(newPartlstUI!=null && newPartlstUI.size()>0){
            for(CSS_Parts_Options__c p :newPartlstUI){
              //  if(lcsolfail.containskey(p.Fail_Code__c)){
                    system.debug('Test222>');
                if( p.RecordType.Name =='TTML' || p.RecordTypeId == recTypeIdTTML || p.PartOC__c == 'TOW'){
                    ttmlPartlstUI.add(p);
                    system.debug('Test2221>');
                }
         /*   }
            else{ //remove
                system.debug('Test2221>esle');
            } */
            }
        }
        
        //GSSC-138 start
        css_utility utility = new css_utility();
        
        mapPartsList = utility.displayParts(ttmlPartlstUI);
    //    system.debug('mapPartsList--'+mapPartsList);
        //GSSC-138 end 
        
        system.debug('ttmlPartlstUIttml>>'+ttmlPartlstUI);
        
        Boolean DealerUser=rswBotton.RSWButtonEnable__c;		
         if(ttmlPartlstUI.size()>0){
            listTTMLWrapper = new List<ttmlWrapperClass>();
            setTTMLWrapper = new Set<ttmlWrapperClass>();
            for(integer i=0;i<ttmlPartlstUI.size();i++){
                List<SelectOption> fC = new List<SelectOption>();
                accCoverage = false;
                fC = fetchfailCodeValuesNew(ttmlPartlstUI[i].Type__c, solsCompTTML);
                if(fC.size() == 1 && ttmlPartlstUI[i].Fail_Code__c!=null){
                    fC.add(new SelectOption(ttmlPartlstUI[i].Fail_Code__c,ttmlPartlstUI[i].Fail_Code__c));
                }
                List<SelectOption> aC = new List<SelectOption>();
                aC = fetchAccCodeValues(ttmlPartlstUI[i].Type__c,ttmlPartlstUI[i].Fail_Code__c, solsCompTTML);
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
}

//Method to get the Technician Details for TTML popup
public List<SelectOption> getTechnicians()    
{    
    List<SelectOption> lstTechnicians =  new List<SelectOption>(); 
    List<String> technicianList = new List<String>();
    Set<String> technicianSet = new Set<String>();
    CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
    jobOrder= [SELECT Id, Assigned_to__c, Assigned_to__r.FirstName, Assigned_to__r.LastName,
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
               FROM CSS_Job_Order__c WHERE Id =: Wid];
    
    lstTechnicians.add(new SelectOption('Select One','Select One'));
    if(jobOrder != null){
        if(jobOrder.Additional_Tech1__c != null)
            technicianList.add(jobOrder.Additional_Tech1__r.LastName+'--'+jobOrder.Additional_Tech1__r.FirstName);
        if(jobOrder.Additional_Tech2__c != null)
            technicianList.add(jobOrder.Additional_Tech2__r.LastName+'--'+jobOrder.Additional_Tech2__r.FirstName);
        if(jobOrder.Additional_Tech3__c != null)
            technicianList.add(jobOrder.Additional_Tech3__r.LastName+'--'+jobOrder.Additional_Tech3__r.FirstName);
        if(jobOrder.Additional_Tech4__c != null)
            technicianList.add(jobOrder.Additional_Tech4__r.LastName+'--'+jobOrder.Additional_Tech4__r.FirstName);
        if(jobOrder.Additional_Tech5__c != null)
            technicianList.add(jobOrder.Additional_Tech5__r.LastName+'--'+jobOrder.Additional_Tech5__r.FirstName);
        if(jobOrder.Additional_Tech6__c != null)
            technicianList.add(jobOrder.Additional_Tech6__r.LastName+'--'+jobOrder.Additional_Tech6__r.FirstName);
        if(jobOrder.Additional_Tech7__c != null)
            technicianList.add(jobOrder.Additional_Tech7__r.LastName+'--'+jobOrder.Additional_Tech7__r.FirstName);
        if(jobOrder.Additional_Tech8__c != null)
            technicianList.add(jobOrder.Additional_Tech8__r.LastName+'--'+jobOrder.Additional_Tech8__r.FirstName);
        if(jobOrder.Additional_Tech9__c != null)
            technicianList.add(jobOrder.Additional_Tech9__r.LastName+'--'+jobOrder.Additional_Tech9__r.FirstName);
        if(jobOrder.Assigned_to__c != null)
            technicianList.add(jobOrder.Assigned_to__r.LastName+'--'+jobOrder.Assigned_to__r.FirstName);
        technicianList.add(jobOrder.CreatedBy.LastName+'--'+jobOrder.CreatedBy.FirstName);
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
  return lstTechnicians;
}
//Method for getting Type values for Dealer as per story #Despicable Me #168027,-By RAJESH 14th Nov 2018
public List<SelectOption> getDLRTTMLType(){
    List<SelectOption> typeList = new List<SelectOption>();
    Schema.DescribeFieldResult fieldResult =  CSS_Parts_Options__c.Type__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for(Schema.PicklistEntry f : ple)
    {
        typeList.add(new SelectOption(f.getValue(),f.getLabel()));
    }       
    return typeList;
}
//End#Despicable Me #168027
public Map<string,string> mapTTMLItemWarnty;
//Method to get TTML Types
public List<SelectOption> getTTMLType() {
   List<SelectOption> typeList = new List<SelectOption>();
    try {
        if(!isOneBMS) {	//dealer == 'DLR'
            Schema.DescribeFieldResult fieldResult =  CSS_Parts_Options__c.Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for(Schema.PicklistEntry f : ple) {
                typeList.add(new SelectOption(f.getValue(),f.getLabel()));
            } 
            
        } else {
            List<SelectOption> sortable = new  List<SelectOption>();
            try {
               List<CSS_JobEventTemporary__c> lstTTMLType;
                mapTTMLItemWarnty = new Map<string,string>();
                lstTTMLType = [select id, Key__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'TTML'];
                typeList.add(new SelectOption('Select One','Select One'));
                CG_MiscChargeLOVResWrapper TTMLBMSLovResponse = new CG_MiscChargeLOVResWrapper();
                List<CG_MiscChargeLOVResWrapper.DataArea> lstdtTTMLTypeObj = new List<CG_MiscChargeLOVResWrapper.DataArea>();
                if(lstTTMLType != null && lstTTMLType.size() > 0){
                    if(lstTTMLType[0].Reason__c !=null){
                      TTMLBMSLovResponse = (CG_MiscChargeLOVResWrapper)JSON.deserializeStrict(lstTTMLType[0].Reason__c, CG_MiscChargeLOVResWrapper.class);
                    }
                    
                }
                if(TTMLBMSLovResponse != null){
                   for(CG_MiscChargeLOVResWrapper.DataArea dt : TTMLBMSLovResponse.DataArea)
                    {   
                        sortable.add(new SelectOption(dt.MiscName,dt.MiscName));
                        mapTTMLItemWarnty.put(dt.MiscName,dt.NewWarrantyClass);
                    }
                    
                }
            } catch(Exception e) {
                system.debug('EXCEPTION of getTTMLType Webservice method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            }
            sortable.add(new SelectOption('TOWING','TOWING'));
            sortable.sort();
            typeList = sortable;
           if(typeList.size() > 0) {
                typeList.add(0,new SelectOption('Select One','Select One'));
            }
        }           
    } catch(Exception e)  {
        system.debug('EXCEPTION of getTTMLType Original method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
    }
   return typeList;
}



public void typeListChange(){
    try{
        system.debug('justtypelistchange');
        duplicateAccountCode=false;
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c,CSS_CoverageType__c, CoveredTowingMiles__c from CSS_Solution_Component__c where Service_Job__c =:wid AND Selected_Component__c = true AND CSS_Account_Formula__c != null];
        for(ttmlWrapperClass  prtslist : listTTMLWrapper){
            if(prtslist.counting == SelectedPartID){
                prtslist.days = '';
                prtslist.Quantity = '';
                prtslist.mileage = '';
                prtslist.hoursTraveled = '';
                prtslist.expenseTotal = '';
                prtslist.failCode = 'Select One';
                prtslist.failCodelst = new List<SelectOption>();
                List<SelectOption> fC = new List<SelectOption>();
                prtslist.accountCode = '';
                prtslist.accCoverage = false;
                fC = fetchfailCodeValuesNew(SelectedItem, lstSolComp);
                prtslist.failCodelst.addAll(fc);
                css_header_nav__c rswBotton =css_header_nav__c.getInstance(UserInfo.getUserId());
                DealerUser=rswBotton.RSWButtonEnable__c;
                system.debug('***DealerUser***'+DealerUser);
                system.debug('***SelectedPartID***'+SelectedPartID);
                system.debug('***prtslist.counting***'+prtslist.counting);
               if(DealerUser!=null && DealerUser==true){
                    if(prtslist.type == 'Commercial-Travel' )
                    {
                        system.debug('***inside Commercial-Travel***');
                        prtslist.showDays = false;
                        prtslist.showUp = true;
                        prtslist.showMileageHT = true;
                        prtslist.showMileage = false;
                    }
                    else if(prtslist.type == 'Non Commercial-Travel' )
                    {  
                        system.debug('***inside non Commercial-Travel***');
                        prtslist.showDays = false;
                        prtslist.showUp = false;
                        prtslist.showMileageHT = true;
                        prtslist.showMileage = true;
                    }
                    else if(prtslist.type =='Towing' || prtslist.type =='Meals' || prtslist.type =='Lodging'){
                        prtslist.showDays = true;
                        prtslist.showUP=true;
                        prtslist.showMileage = false;
                        prtslist.showMileageHT = false;
                    }
                    else{
                        prtslist.showDays = false;
                        prtslist.showUP=false;
                        prtslist.showMileage = false;
                        prtslist.showMileageHT = false;
                        ShowTravelRateerr=false;
                    }
                    //Adding logic for displaying travel rate validation msg.
                    if(prtslist.type =='Towing')
                    {
                        ShowTravelRateerr=false;
                    }
                    else
                    {
                        if(prtslist.type!='Select One' && (checktravelratedlr == true || checktravelratedist == true))
                            ShowTravelRateerr=true;
                        else
                            ShowTravelRateerr=false;
                    }
                }
                else{
                    if(prtslist.type != 'Select One' && prtslist.type != 'Towing'){
                        prtslist.showDays = true;
                        prtslist.showMileageHT = true;
                        prtslist.towErrorMsg = false;
                        towErrorOutputMsg = false;
                        
                        if(checktravelratedlr == true || checktravelratedist == true)
                            ShowTravelRateerr=true;
                        else
                            ShowTravelRateerr=false;
                    }
                    else if(prtslist.type == 'Towing'){
                        
                        if(!isOneBMS){
                            towErrorOutputMsg = false;
                            prtslist.towErrorMsg = false;
                            
                        }
                        else{
                            towErrorOutputMsg = true; 
                            
                            prtslist.towErrorMsg = true;    
                        }
                        //prtslist.showDays = false;
                        if(!isOneBMS)
                            prtslist.showDays = true;
                        else
                            prtslist.showDays = false;
                        if(!isOneBMS)
                            prtslist.showMileageHT = true;
                        else
                            prtslist.showMileageHT = false;
                        
                        ShowTravelRateerr=false;
                    }
                    else{
                        if(prtslist.type == 'Select One')
                            prtslist.notes = '';
                        prtslist.days = '';
                        prtslist.mileage = '';
                        prtslist.hoursTraveled = '';
                        prtslist.expenseTotal = '';                            
                        prtslist.showDays = false;
                        prtslist.showUp = false;
                        prtslist.showMileageHT = false;
                        prtslist.towErrorMsg = false;
                        towErrorOutputMsg = false;
                        ShowTravelRateerr=false;
                    }
         }
                
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
    Boolean isAccCodeAdded = false;
    list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
    Map<String,List<CSS_Solution_Component__c>> solCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
    
    lstSolComp = [SELECT  Id,Over_The_Counter__c, Type__c,FailCode_Formula__c,CSS_Account_Formula__c,CampaignTravelPercentage__c,CampaignTowingPercentage__c,CoveredTravelLabor__c,CoveredTravelBaseFareAmt__c,CoveredTravelMiles__c,CoveredTowingMiles__c,CoveredMealsLodgingAmt__c,CSS_CoverageType__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =: wid AND ((Selected_Component__c = true AND FailCode_Formula__c != '' AND CSS_Account_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution') OR (Selected_Component__c = true AND FailCode_Formula__c !='' AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))]; //Added "Over_The_Counter__c != true" as part of the story GSSC-298
    
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
                if(tempListFA !=null && tempListFA.size() ==1 && tempList == null){
                    if(tempListFA[0].CSS_CoverageType__c!= null && (tempListFA[0].CSS_CoverageType__c == 'OTH' || tempListFA[0].CSS_CoverageType__c == 'POL')){
                        accCode =tempListFA[0].CSS_Account_Formula__c; 
                    }
                    if(tempListFA[0].Type__c == 'Campaign' || tempListFA[0].Type__c == 'TRP' || tempListFA[0].Type__c == 'ATC' && (tempListFA[0].CSS_CoverageType__c != 'OTH' && tempListFA[0].CSS_CoverageType__c != 'POL')){
                        
                        
                        if(ttmlwr.type != null && ttmlwr.type != '' && (ttmlwr.type.equalsIgnoreCase('Commercial-Travel') || ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel') || ttmlwr.type.equalsIgnoreCase('Meals') || ttmlwr.type.equalsIgnoreCase('Lodging') || 
                                                      ttmlwr.type.equalsIgnoreCase('PARKING-FSE') || ttmlwr.type.equalsIgnoreCase('PARKING-FSPG') || ttmlwr.type.equalsIgnoreCase('TOLLS-FSE') || ttmlwr.type.equalsIgnoreCase('TOLLS-FSPG') || ttmlwr.type.equalsIgnoreCase('MILE WARR FSE') || ttmlwr.type.equalsIgnoreCase('MILE WARR FSPG') || 
                                                      ttmlwr.type.equalsIgnoreCase('LODGE- FSE') || ttmlwr.type.equalsIgnoreCase('MEAL- FSE') || ttmlwr.type.equalsIgnoreCase('MEAL- FSPG'))){
                                                          if(tempListFA[0].CampaignTravelPercentage__c!=null && double.valueof(tempListFA[0].CampaignTravelPercentage__c)>0){
                                                              accCode = tempListFA[0].CSS_Account_Formula__c;
                                                              isAccCodeAdded = true;
                                                          }
                                                      }
                        else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                            if(tempListFA[0].CampaignTowingPercentage__c!=null && double.valueof(tempListFA[0].CampaignTowingPercentage__c)>0){
                                accCode = tempListFA[0].CSS_Account_Formula__c;
                                isAccCodeAdded = true;
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
                            else{
                                system.debug('***inside with field action***');
                                system.debug('***inside with field action and type value ***'+ttmlwr.type);
                                if(ttmlwr.type != null && ttmlwr.type != '' && (ttmlwr.type.equalsIgnoreCase('Commercial-Travel') || ttmlwr.type.equalsIgnoreCase('PARKING-FSE') || ttmlwr.type.equalsIgnoreCase('PARKING-FSPG') || ttmlwr.type.equalsIgnoreCase('TOLLS-FSE') || ttmlwr.type.equalsIgnoreCase('TOLLS-FSPG'))){
                                    if(tempList[0].CoveredTravelBaseFareAmt__c!= null && double.valueof(tempList[0].CoveredTravelBaseFareAmt__c)>0 && tempList[0].CoveredTravelLabor__c!= null && double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                        accCode=tempList[0].CSS_Account_Formula__c;
                                        isAccCodeAdded = true;
                                    }
                                }else if(ttmlwr.type != null && ttmlwr.type != '' && (ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel') || ttmlwr.type.equalsIgnoreCase('MILE WARR FSE') || ttmlwr.type.equalsIgnoreCase('MILE WARR FSPG'))){
                                    if(tempList[0].CoveredTravelMiles__c!=null && double.valueof(tempList[0].CoveredTravelMiles__c)>0 && tempList[0].CoveredTravelLabor__c != null && double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                        accCode=tempList[0].CSS_Account_Formula__c;
                                        isAccCodeAdded = true;
                                        system.debug('isAccCodeAdded-->'+isAccCodeAdded);
                                    } 
                                }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                                    if(tempList[0].CoveredTowingMiles__c!=null && double.valueof(tempList[0].CoveredTowingMiles__c)>0){
                                        accCode=tempList[0].CSS_Account_Formula__c;
                                        isAccCodeAdded = true;
                                        system.debug('Getting enter into Towing>>>'+isAccCodeAdded);
                                    }
                                    //}else if((type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                                }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals') || ttmlwr.type.equalsIgnoreCase('Lodging') || ttmlwr.type.equalsIgnoreCase('LODGE- FSE') || ttmlwr.type.equalsIgnoreCase('MEAL- FSE') || ttmlwr.type.equalsIgnoreCase('MEAL- FSPG')){
                                    system.debug('***inside with field action with type value***');
                                    if(tempList[0].CoveredMealsLodgingAmt__c!=null && double.valueof(tempList[0].CoveredMealsLodgingAmt__c)>0){
                                        accCode=tempList[0].CSS_Account_Formula__c;
                                        isAccCodeAdded = true;
                                    }
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
                            if(ttmlwr.type != null && ttmlwr.type != '' && (ttmlwr.type.equalsIgnoreCase('Commercial-Travel') || ttmlwr.type.equalsIgnoreCase('PARKING-FSE') || ttmlwr.type.equalsIgnoreCase('PARKING-FSPG') || ttmlwr.type.equalsIgnoreCase('TOLLS-FSE') || ttmlwr.type.equalsIgnoreCase('TOLLS-FSPG'))){
                                if(tempList[0].CoveredTravelBaseFareAmt__c!= null && double.valueof(tempList[0].CoveredTravelBaseFareAmt__c)>0 && tempList[0].CoveredTravelLabor__c!= null && double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                    accCode=tempList[0].CSS_Account_Formula__c;
                                    isAccCodeAdded = true;
                                }
                            }else if(ttmlwr.type != null && ttmlwr.type != '' && (ttmlwr.type.equalsIgnoreCase('Non Commercial-Travel') || ttmlwr.type.equalsIgnoreCase('MILE WARR FSE') || ttmlwr.type.equalsIgnoreCase('MILE WARR FSPG'))){
                                if(tempList[0].CoveredTravelMiles__c!=null && double.valueof(tempList[0].CoveredTravelMiles__c)>0 && tempList[0].CoveredTravelLabor__c != null && double.valueof(tempList[0].CoveredTravelLabor__c)>0){
                                    accCode=tempList[0].CSS_Account_Formula__c;
                                    isAccCodeAdded = true;
                                    system.debug('isAccCodeAdded-->'+isAccCodeAdded);
                                } 
                            }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Towing')){
                                if(tempList[0].CoveredTowingMiles__c!=null && double.valueof(tempList[0].CoveredTowingMiles__c)>0){
                                    accCode=tempList[0].CSS_Account_Formula__c;
                                    isAccCodeAdded = true;
                                    system.debug('Getting enter into Towing>>>'+isAccCodeAdded);
                                }
                                //}else if((type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                            }else if(ttmlwr.type != null && ttmlwr.type != '' && ttmlwr.type.equalsIgnoreCase('Meals') || ttmlwr.type.equalsIgnoreCase('Lodging') || ttmlwr.type.equalsIgnoreCase('LODGE- FSE') || ttmlwr.type.equalsIgnoreCase('MEAL- FSE') || ttmlwr.type.equalsIgnoreCase('MEAL- FSPG')){
                                system.debug('***inside with field action with type value***');
                                if(tempList[0].CoveredMealsLodgingAmt__c!=null && double.valueof(tempList[0].CoveredMealsLodgingAmt__c)>0){
                                    accCode=tempList[0].CSS_Account_Formula__c;
                                    isAccCodeAdded = true;
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
                aC = fetchAccCodeValues(ttmlwr.Type,ttmlwr.failCode, lstSolComp);
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
}

//Method to save the TTML Popup
Boolean DealerUser;  
    public PageReference saveTTMLPopup(){
    css_header_nav__c rswBotton =css_header_nav__c.getInstance(UserInfo.getUserId());
    DealerUser=rswBotton.RSWButtonEnable__c;
    css_solution_component__c solComp = new css_solution_component__c();
    ttmlReqErrMsg = false;
    isExpenseTotalError=false;
    isMealsExpenseTotalError=false;
    isLodgingExpenseTotalError=false;
    isTowingExpenseTotalError=false;
    trveltowingerrmsg=false;
    TravelTowingTTMLError = false;
    duplicateAccountCode = false;
    List<CSS_Parts_Options__c> selectedTTMLPartsList = new list<CSS_Parts_Options__c>();
    List<CSS_Parts_Options__c> OCList = new list<CSS_Parts_Options__c>();
    PageReference pageRefTTML;
    Set<Boolean> setTtmlReqErrMsg = new Set<Boolean>() ;
    Set<Boolean> setTtmlTOWErrMsg  = new Set<Boolean>();
    
    Map<String, CSS_Solution_Component__c> solCompexp = new Map<String, CSS_Solution_Component__c>();
    for(CSS_Solution_Component__c solcom : lstSolComp){
        String covtype='';
        if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null)
            covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
        if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW' && !solCompexp.containsKey(solcom.CSS_Account_Formula__c)){
           solCompexp.put(solcom.CSS_Account_Formula__c, solcom);
        }
        else if(covtype != 'NPW' || covtype != 'RPW' || covtype != 'RRW' || covtype != 'OTH' || covtype != 'POL' && !solCompexp.containsKey(solcom.CSS_Account_Formula__c)){
            solCompexp.put(solcom.CSS_Account_Formula__c, solcom);
        }
    }
   //Start code for Non Dealer user
    if(DealerUser!=null && DealerUser==false){
        try{
            for(ttmlWrapperClass prtslist : listTTMLWrapper){
                system.debug('listTTMLWrapperds**'+prtslist.expenseTotal);
                Boolean x;
                prtslist.accCoverage=false;
                    prtslist.dispAccountCode=false;
                if(prtslist.technician == 'Select One' || prtslist.technician == '' || prtslist.technician == null){
                    prtslist.mandateTechnician = true;
                    x = true;
                }
                else{                    
                    prtslist.mandateTechnician = false;
                }
                if(prtslist.type == 'Select One' || prtslist.type == '' || prtslist.type == null){
                    prtslist.mandateType = true;
                    x = true;
                }
                else{
                    prtslist.mandateType = false;
                }
                if(prtslist.showDays == true && prtslist.type != 'TOWING' && (String.valueOf(prtslist.quantity) == null || String.valueOf(prtslist.quantity) == '')){
                    prtslist.mandateDays = true;
                    x = true;
               }else{
                    prtslist.mandateDays = false;
                }
               if(prtslist.showMileageHT == true && prtslist.type != 'TOWING' && (prtslist.UnitPrice == null || prtslist.UnitPrice == '')){
                    x = true;
                    prtslist.mandateHrTr = true;
                }else{
                    prtslist.mandateHrTr = false;
                }
                if(prtslist.type == 'TOWING' && prtslist.PartOC != 'TOW' && isOneBMS == true){
                    prtslist.towErrorMsg = true;
                }
                else
                    prtslist.towErrorMsg = false;
                if(prtslist.mandateTechnician == true && prtslist.mandateType == true && (prtslist.days == null || prtslist.days == '') && 
                   (prtslist.mileage == null || prtslist.mileage == '') && (prtslist.hoursTraveled == null || prtslist.hoursTraveled == '') && 
                   (prtslist.expenseTotal == null || prtslist.expenseTotal == '')) {
                       prtslist.mandateTechnician = false;
                       prtslist.mandateType = false;
                       prtslist.mandateDays = false;
                       prtslist.mandateMileage = false;
                       prtslist.mandateHrTr = false;
                       prtslist.mandateExpTotal = false;
                       x = false;
                       if(prtslist.notes != null && prtslist.notes != '') {
                           prtslist.mandateTechnician = true;
                           prtslist.mandateType = true;
                           x = true;
                       }                        
                   }
                setTtmlReqErrMsg.add(x);
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Meals'  && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.expenseHeaderRedBox=true;
                    isMealsExpenseTotalError=true;
                }
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Lodging' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.expenseHeaderRedBox=true;
                    isLodgingExpenseTotalError=true;
                }
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Towing' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.expenseHeaderRedBox=true;
                    isTowingExpenseTotalError=true;
                }
                if(prtslist.type=='Commercial-Travel' || prtslist.type=='Non Commercial-Travel' || prtslist.type == 'PARKING-FSPG' || prtslist.type == 'PARKING-FSE' || prtslist.type == 'TOLLS-FSE' || prtslist.type == 'TOLLS-FSPG' ){//|| prtslist.type == 'MILE WARR FSE' || prtslist.type == 'MILE WARR FSPG'
                    if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='')  && (Decimal.valueOf(prtslist.expenseTotal) > 10000 )){
                        prtslist.expenseHeaderRedBox=true;
                        isExpenseTotalError = true;
                    }
                }
                if(prtslist.towErrorMsg == true && isOneBMS == true){
                    x=true;
                    setTtmlTOWErrMsg.add(x);
                }
                else
                    x=false;
            }
            if(setTtmlReqErrMsg.contains(true))
                ttmlReqErrMsg = true;
            else
                ttmlReqErrMsg = false;
            
            if(setTtmlTOWErrMsg.contains(true) && isOneBMS == true)
                towErrorOutputMsg = true;
            else
                towErrorOutputMsg = false;
                Map<String, List<String>> TTMLMap = new Map<String, List<String>>();
                 OCList = [select Id, selected_part__c,ExpenseTotal__c, Item__c, Part_Description__c,Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,PartOC__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                          Account_Code__c, Notes__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c,RecordType.Name,ODM_Status__c  from CSS_Parts_Options__c where Service_Job__c =:Wid and (RecordType.Name ='OtherClaimables')];
                                                                                  
            if(!ttmlReqErrMsg && !towErrorOutputMsg && isMealsExpenseTotalError==false && isLodgingExpenseTotalError==false && isTowingExpenseTotalError==false && isExpenseTotalError==false){
                                                                                     
                css_job_order__c jobObj = new css_job_order__c();
                jobObj = [select id, CSS_Travel_Rate__c from css_job_order__c where id=:Wid];
                Integer j=0;
                duplicateAccountCode=false;
                List<String> tempList;
                for(ttmlWrapperClass prtslist : listTTMLWrapper){
                    
                      system.debug('selectedTTMLPartsList prtslist'+prtslist.expenseTotal);
                    prtslist.accCoverage=false;
                    prtslist.dispAccountCode=false;
                    if(prtslist.type == 'MILE WARR FSE' || prtslist.type == 'MILE WARR FSPG'){
                         if(prtslist.Quantity!=null && prtslist.Quantity!= '' && jobObj.CSS_Travel_Rate__c!=null && jobObj.CSS_Travel_Rate__c!='')
                            prtslist.expenseTotal=String.valueOf(Decimal.valueof(prtslist.Quantity) * Decimal.valueof(jobObj.CSS_Travel_Rate__c));
                        else
                            prtslist.expenseTotal='';
                        
                    }
                    else{
                        if(prtslist.UnitPrice != null && prtslist.UnitPrice != '' && prtslist.Quantity!=null && prtslist.Quantity!='')
                            prtslist.expenseTotal=String.valueOf(Decimal.valueof(prtslist.Quantity) * Decimal.valueof(prtslist.UnitPrice));	
                    }
                    if(prtslist.type == 'Non Commercial-Travel' || prtslist.type == 'Commercial-Travel' || prtslist.type == 'Towing'){
                        
                        for(Integer i =0;i<listTTMLWrapper.size();i++)
                        {
                             if(j!=i && prtslist.accountCode == listTTMLWrapper[i].accountCode)
                            {
                                if((prtslist.type.containsIgnoreCase('Travel') && listTTMLWrapper[i].type == 'Towing') || (prtslist.type.containsIgnoreCase('Towing') && listTTMLWrapper[i].type.containsIgnoreCase('Travel')))
                                {
                                    duplicateAccountCode = true;
                                    break;
                                } 
                             }
                            
                        }
                    }
                        system.debug('selectedTTMLPartsList prtslist1'+prtslist.expenseTotal);
                    //Start code as per story #148900 ,By RAJESH 08th Jan 2019-->
                     if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Meals'  && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                        prtslist.expenseHeaderRedBox=true;
                        isMealsExpenseTotalError=true;
                    }
                    if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Lodging' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                        prtslist.expenseHeaderRedBox=true;
                       isLodgingExpenseTotalError=true;
                     }
                    if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Towing' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                        prtslist.expenseHeaderRedBox=true;
                        isTowingExpenseTotalError=true;
                    }
                    //End code as per story #148900 ,By RAJESH 08th Jan 2019-->                                                                        
                    j++;
                    if(prtslist.type == null || prtslist.type == '' || prtslist.type == 'Select One'){
                        if(prtslist.ids != null && String.valueOf(prtslist.ids).trim() != ''){
                            removeIdsMap.put(prtslist.ids, String.valueOf(prtslist.ids));
                            displayPopup2 = false;
                        }
                    }
                    else{
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.recordtypeId  = recTypeIdTTML;
                        partsoption.Technician__c = prtslist.technician;
            //added " && prtslist.showDays == true " in if part and added else part as per defect #189601 by RAJESH July 19th 2019
                     if(prtslist.quantity != null && prtslist.quantity != '' && (prtslist.showDays==null || prtslist.showDays == true)){
                         partsoption.quantity__c = Integer.valueOf(prtslist.quantity);
                      }
                      else
                          partsoption.quantity__c=null;
           //added " && prtslist.showUp == true " in if part and added else part as per defect #189601 by RAJESH July 19th 2019 
           system.debug('***prtslist.unitPrice***'+prtslist.unitPrice);
           system.debug('***prtslist.showUp***'+prtslist.showUp);
                     
                     /*if(prtslist.unitPrice != null && prtslist.unitPrice != '' && (prtslist.showUp==null || prtslist.showUp == true)){
                         system.debug('***inside if part***');
                         system.debug('***prtslist.unitPrice***'+prtslist.unitPrice);
                         partsoption.Unit_Price__c = prtslist.unitPrice;
                     }
                     else{
                         system.debug('***inside else part***');
                         partsoption.Unit_Price__c=null;
                     }
                     */
                     
                     
                //GSSC-138 start
                system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                system.debug('prtslist.ids--'+prtslist.ids);
                 system.debug('selectedTTMLPartsList prtslist2'+prtslist.expenseTotal);
                 system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                if(prtslist.ids != null){
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
                     system.debug('selectedTTMLPartsList prtslist3'+prtslist.expenseTotal);
                     system.debug('prtslist.ExpenseTotal__c out--'+partsoption.ExpenseTotal__c);
                }
                else{
                    partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                    partsoption.Unit_Price__c = prtslist.unitPrice;
                     system.debug('selectedTTMLPartsList prtslist4'+prtslist.expenseTotal);
                     system.debug('prtslist.ExpenseTotal__c out else--'+partsoption.ExpenseTotal__c);
                }
                
                 system.debug('selectedTTMLPartsList prtslist'+prtslist.expenseTotal);
                 system.debug('prtslist.ExpenseTotal__c out out--'+partsoption.ExpenseTotal__c);
                //GSSC-138 end
                
                    if(partsoption.ExpenseTotal__c == null){
                        partsoption.ExpenseTotal__c = Decimal.valueOf(prtslist.expenseTotal);
                     }

                        partsoption.Misc_LOV__c = prtslist.type;
                        //partsoption.Item__c = prtslist.type;//Modified since ttml values are saved only to type__c field - Rajesh
                        partsoption.type__c = prtslist.type;
                        if(prtslist.type == 'LODGE- FSE'){
                            partsoption.Siebel_Value__c = 'Lodging';
                        } else if(prtslist.type == 'MEAL- FSE'){
                            partsoption.Siebel_Value__c = 'Meals';
                        } else if(prtslist.type == 'MEAL- FSPG'){
                            partsoption.Siebel_Value__c = 'Meals';
                        } else if(prtslist.type == 'MILE WARR FSE'){
                            partsoption.Siebel_Value__c = 'Non Commercial- Travel';
                        } else if(prtslist.type == 'MILE WARR FSPG'){
                            partsoption.Siebel_Value__c = 'Non Commercial- Travel';
                        } else if(prtslist.type == 'PARKING-FSE'){
                            partsoption.Siebel_Value__c = 'Commercial- Travel';
                        } else if(prtslist.type == 'PARKING-FSPG'){
                            partsoption.Siebel_Value__c = 'Commercial- Travel';
                        } else if(prtslist.type == 'TOLLS-FSE'){
                            partsoption.Siebel_Value__c = 'Commercial- Travel';
                        } else if(prtslist.type == 'TOLLS-FSPG'){
                            partsoption.Siebel_Value__c = 'Commercial- Travel';
                        } else{
                            //Added below if condition as part of the defect #190629
                            if(prtslist.type == 'Commercial-Travel' || prtslist.type == 'Non Commercial-Travel' || prtslist.type == 'Towing' || prtslist.type == 'Meals' || prtslist.type == 'Lodging'){
                                partsoption.Siebel_Value__c = prtslist.type;
                            }
                            else{
                                partsoption.Siebel_Value__c = '';
                            }
                        }
                        if(prtslist.days != null && prtslist.days != '')
                            partsoption.Days__c = Integer.valueOf(prtslist.days);
                            else
                            partsoption.Days__c =null;
                //added " && prtslist.showMileage == true " in if part and added else part as per defect #189601 by RAJESH July 19th 2019                     
                     if(prtslist.mileage != null && prtslist.mileage != '' && (prtslist.showMileage==null || prtslist.showMileage == true))
                         partsoption.Mileage__c = Decimal.valueOf(prtslist.mileage);
                     else
                         partsoption.Mileage__c=null;
            //added " && prtslist.showMileageHT == true " in if part and added else part as per defect #189601 by RAJESH July 19th 2019              
                         if(prtslist.hoursTraveled != null && prtslist.hoursTraveled != '' && (prtslist.showMileageHT ==null ||prtslist.showMileageHT == false)){
                            
                            partsoption.HoursTravelled__c = Decimal.valueOf(prtslist.hoursTraveled);
                        }
                            else{
                            partsoption.HoursTravelled__c =null;
                            }
                         
                        if(prtslist.failCode != 'Select One')
                            partsoption.Fail_Code__c = prtslist.failCode;
                        else
                            partsoption.Fail_Code__c = 'Select One'; 
                       //  if(partsoption.Siebel_Value__c == ''){ //Added to avoid accountcode association upon saving for BMS LOvs not having Mapping,as per Task 176475
//commented above condition we shouldn't get Account code is null when type equals to non bms values,found observation while doing testing story #183916-By RAJESH 17th May 2019
                       if(partsoption.Siebel_Value__c == '' && prtslist.type!='Towing' ){
                           partsoption.Account_Code__c ='';
                           prtslist.accCoverage=false;
                           prtslist.dispAccountCode=false;
                            system.debug('*****inside if part****'+partsoption.Account_Code__c);
                       }
                        else if(prtslist.accountCode != '' && prtslist.accountCode != null && prtslist.accountCode !='Select One'){
                            partsoption.Account_Code__c = prtslist.accountCode;
                            prtslist.accCoverage=true;
                            prtslist.dispAccountCode=true;
                            system.debug('*****inside else if part****'+partsoption.Account_Code__c);
                        }
                        else{
                            partsoption.Account_Code__c ='Select One'; 
                            prtslist.accCoverage=false;
                            prtslist.dispAccountCode=false;
                            system.debug('*****inside else part****'+partsoption.Account_Code__c);
                        }
                        if(prtslist.ids != null)
                            partsoption.Id = prtslist.ids;
                        else
                            partsoption.selected_part__c = true;
                        partsoption.Service_Job__c = JobId;
                        partsoption.Notes__c = prtslist.notes;
                        system.debug('prtslist.ExpenseTotal__c before adding list--'+partsoption.ExpenseTotal__c);
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
                 
                 //Remove logic here
                 if(duplicateAccountCode!= true){
                    try{
                        if(duplicateAccountCode!= true && removeIdsMap.keySet().size()>0){
                            deleteTTMLParts();
                        }
                    }catch(Exception ex) {
                        System.debug('In first catch of saveTTMLParts: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                    }
                    //
                 //53
                 Parterrors.clear();
                 NonParterrors.clear();
                 isTTMLPWAccCodeCovLimitError=false;
                 isTTMLNPWAccCodeCovLimitError=false;  
                for(CSS_Parts_Options__c parts : selectedTTMLPartsList){
                      system.debug('selectedTTMLPartsList parts'+parts.ExpenseTotal__c);
                if(solCompexp.containsKey(parts.Account_Code__c) && parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Fail_Code__c!=null && parts.Fail_Code__c!='' )
                {
                    system.debug('testflag'+NonPartsWarrantyFlag);
                CSS_Solution_Component__c solCmpTemp =solCompexp.get(parts.Account_Code__c);
                String covtype = '';
                
                if(accCodeCovTypeMap != null && solCmpTemp.CSS_Account_Formula__c != null){
                covtype = accCodeCovTypeMap.get(solCmpTemp.CSS_Account_Formula__c.RIGHT(2));
                }
                
                system.debug('selectedTTMLPartsList'+selectedTTMLPartsList);
                CG_CL_CoverageLimitExceedValidation validate = new CG_CL_CoverageLimitExceedValidation();
                 Map<string,Map<string,string>> cssparterrors = validate.CoverageLimitValidation_TTML(Wid,selectedTTMLPartsList);
                 system.debug('cssparterrors'+cssparterrors);
                 
                
                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW' ){
                	NonPartsWarrantyFlag = false;
                	for(ttmlWrapperClass prtslist:listTTMLWrapper){
                     if(prtslist.failCode!=null  && prtslist.type!=null  && prtslist.type!='' && prtslist.failCode!='' && prtslist.accountCode!=null && prtslist.accountCode!=''){
                     string partkey =prtslist.type.trim()+'&'+prtslist.accountCode.trim()+'&'+prtslist.failCode.trim();
                     //system.debug('Testpartkey'+partkey);
                     //system.debug('cssparterrors.containskey'+cssparterrors.containskey(partkey));
                     if(cssparterrors.containskey(partkey)){
                         for(string val :cssparterrors.get(partkey).values()){
                             //system.debug('val**'+val);
                             if(!Parterrors.contains(val))
                             Parterrors.add(val); 
                             system.debug('Teste***'+Parterrors);
                         }
                         prtslist.isTTMLFailcodeCovLimitExceed=true;
                         //prtslist.isTTMLAccCodeCovLimitExceed=true;
                         isTTMLPWAccCodeCovLimitError = true;
                         system.debug('erromsg');
                     }else{
                        prtslist.isTTMLFailcodeCovLimitExceed=false;
                        //prtslist.isTTMLAccCodeCovLimitExceed=false;
                        //isTTMLPWAccCodeCovLimitError = false;
                        system.debug('erromsg1');
                     }
                         system.debug('prtslist.isTTMLAccCodeCovLimitExceed'+prtslist.isTTMLAccCodeCovLimitExceed);
                         system.debug('Parterrors'+Parterrors);
                     
                   }
                 }
                }
                else  if (covtype != 'NPW' || covtype != 'RPW' || covtype != 'RRW' || covtype != 'OTH' || covtype != 'POL'){
                	NonPartsWarrantyFlag = true;
                	for(ttmlWrapperClass prtslist:listTTMLWrapper){
                     if(prtslist.failCode!=null  && prtslist.type!=null  && prtslist.type!='' && prtslist.failCode!='' && prtslist.accountCode!=null && prtslist.accountCode!=''){
                     string partkey =prtslist.type.trim()+'&'+prtslist.accountCode.trim();
                      if(cssparterrors.containskey(partkey)){
                         for(string val :cssparterrors.get(partkey).values()){
                             system.debug('val**'+val);
                             if(!NonParterrors.contains(val))
                             NonParterrors.add(val); 
                         }
                         prtslist.isTTMLAccCodeCovLimitExceed=true;
                         isTTMLNPWAccCodeCovLimitError=true;
                         system.debug('erromsg');
                     }else{
                       
                        prtslist.isTTMLAccCodeCovLimitExceed=false; 
                        
                     }
                      
                     
                   }
                 } 
                }
                
                
                }
                }
                 //53
                 system.debug('selectedTTMLPartsList saving records'+selectedTTMLPartsList);
                 if(selectedTTMLPartsList.size()>0 && (Parterrors.isEmpty() && NonParterrors.isEmpty())){
                     displayPopup2 = false;
                     upsert selectedTTMLPartsList Id;
                 }
                 if(!Parterrors.isEmpty() || !NonParterrors.isEmpty())
                    return null;
                    getAllTTMLPartsData();
                    saveExpenseTotal();
                    
                    String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
                    pageRefTTML = new PageReference(sDestURL+'id='+Wid); 
                    pageRefTTML.setRedirect(true);
                    return pageRefTTML; 
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
    if(DealerUser!=null && DealerUser==true){
        ttmlReqErrMsg = false;//Initially we assume there is no error
        duplicateAccountCode = false;
        List<CSS_Parts_Options__c> selectedTTMLPartsList1 = new list<CSS_Parts_Options__c>();//This will be saved to the object
         try{
            for(ttmlWrapperClass prtslist : listTTMLWrapper){
                prtslist.accCoverage=false;
                    prtslist.dispAccountCode=false;
                Boolean x;
                if(prtslist.technician == 'Select One' || prtslist.technician == '' || prtslist.technician == null)
                {
                    prtslist.mandateTechnician = true;
                    x = true;
                }
                else{                    
                    prtslist.mandateTechnician = false;
                }
                if(prtslist.type == 'Select One' || prtslist.type == '' || prtslist.type == null)
                {
                    prtslist.mandateType = true;
                    x = true;
                }
                else
                {
                    prtslist.mandateType = false;
                }                       
                if(prtslist.mandateTechnician == true && prtslist.mandateType == true )
                 {
                    prtslist.mandateTechnician = false;
                    prtslist.mandateType = false;
                    prtslist.mandateDays = false;
                    prtslist.mandateMileage = false;
                    prtslist.mandateHrTr = false;
                    prtslist.mandateExpTotal = false;
                    x = false;
                                          
                }
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Meals'  && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.expenseHeaderRedBox=true;
                    isMealsExpenseTotalError=true;
                }
                if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='') && prtslist.type == 'Lodging' && (Decimal.valueOf(prtslist.expenseTotal) > 99999.99 )){
                    prtslist.expenseHeaderRedBox=true;
                    isLodgingExpenseTotalError=true;
                }
                if((prtslist.expenseTotal!=null ) && prtslist.type == 'Towing' && string.isNotBlank(prtslist.expenseTotal)){
                    if(Decimal.valueOf(prtslist.expenseTotal) > 99999.99)
                    {
                        prtslist.expenseHeaderRedBox=true;
                        isTowingExpenseTotalError=true;
                    }
                }
                if(prtslist.type=='Commercial-Travel' || prtslist.type=='Non Commercial-Travel' || prtslist.type == 'PARKING-FSPG' || prtslist.type == 'PARKING-FSE' || prtslist.type == 'TOLLS-FSE' || prtslist.type == 'TOLLS-FSPG' ){//|| prtslist.type == 'MILE WARR FSE' || prtslist.type == 'MILE WARR FSPG'
                    if((prtslist.expenseTotal!=null && prtslist.expenseTotal!='')  && (Decimal.valueOf(prtslist.expenseTotal) > 10000 )){
                        prtslist.expenseHeaderRedBox=true;
                        isExpenseTotalError = true;
                    }
                }
                setTtmlReqErrMsg.add(x);
            }
            if(setTtmlReqErrMsg.contains(true)){
                 ttmlReqErrMsg = true;
            }
            else{
                 ttmlReqErrMsg = false;
            }
            Map<String, List<String>> TTMLMap = new Map<String, List<String>>();
            OCList = [select Id, selected_part__c,ExpenseTotal__c, Item__c, Part_Description__c,Warranty_Allocation__c,Quantity_Ordered__c,Sell_Price__c,PartOC__c, Quantity__c, amount__c, Covered__c, Fail_Code__c,
                          Account_Code__c, Notes__c,Css_Estimate__c,Claim_Type__c,Part_Name__c,Create_User__c,Change_User__c,RecordType.Name,ODM_Status__c  from CSS_Parts_Options__c where  Service_Job__c =:Wid and (RecordType.Name ='OtherClaimables')];
                system.debug('OCList****' + OCList);
           if(!ttmlReqErrMsg && isMealsExpenseTotalError==false && isLodgingExpenseTotalError==false && isTowingExpenseTotalError==false && isExpenseTotalError==false)
            {   
             Integer j=0;
             duplicateAccountCode=false;
             List<String> tempList;
             for(ttmlWrapperClass prtslist : listTTMLWrapper){
                  system.debug('selectedTTMLPartsList prtslist DealerUser'+prtslist.expenseTotal);
                 if(prtslist.type == 'Non Commercial-Travel' || prtslist.type == 'Commercial-Travel' || prtslist.type == 'Towing')
                 {
                     for(Integer i =0;i<listTTMLWrapper.size();i++)
                     {
                        if(j!=i && prtslist.accountCode == listTTMLWrapper[i].accountCode)
                         {
                             if((prtslist.type.containsIgnoreCase('Travel') && listTTMLWrapper[i].type == 'Towing') || (prtslist.type.containsIgnoreCase('Towing') && listTTMLWrapper[i].type.containsIgnoreCase('Travel')))
                             {
                                 duplicateAccountCode = true;
                                 break;
                             } 
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
                 
                 system.debug('selectedTTMLPartsList prtslist DealerUser1'+prtslist.expenseTotal);
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
                     if(prtslist.quantity != null && prtslist.quantity != '' && prtslist.showDays == true){
                         partsoption.quantity__c = Integer.valueOf(prtslist.quantity);
                      }
                      else
                          partsoption.quantity__c=null;
                          
                    
                     if(prtslist.mileage != null && prtslist.mileage != '' && prtslist.showMileage == true)
                         partsoption.Mileage__c = Decimal.valueOf(prtslist.mileage);
                     else
                         partsoption.Mileage__c=null;
                    if(prtslist.hoursTraveled != null && prtslist.hoursTraveled != '' && prtslist.showMileageHT == true){
                         partsoption.HoursTravelled__c = Decimal.valueOf(prtslist.hoursTraveled);
                     }
                     else{
                        partsoption.HoursTravelled__c =null; 
                     }
                     
                     /*if(prtslist.unitPrice != null && prtslist.unitPrice != '' && (prtslist.showUp == true || prtslist.showUp == null)){ // && prtslist.showUp == true
                         partsoption.Unit_Price__c = prtslist.unitPrice;
                     }
                     else{
                         partsoption.Unit_Price__c=null;
                     }
                     if(prtslist.expenseTotal != null && prtslist.expenseTotal != ''){
                         partsoption.ExpenseTotal__c = Decimal.valueOf(prtslist.expenseTotal);
                     }   
                     
                    system.debug('selectedTTMLPartsList prtslist DealerUser1'+prtslist.expenseTotal);*/
                    
                    
                    //GSSC-138 start
                    system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                    system.debug('prtslist.ids--'+prtslist.ids);
                     system.debug('selectedTTMLPartsList prtslist2'+prtslist.expenseTotal);
                     system.debug('prtslist.UnitpriceModified--'+prtslist.UnitpriceModified);
                    if(prtslist.ids != null){
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
                                }
                                else{
                                    partsoption.Exchange_Rate__c = 1;
                                    partsoption.Unit_Price_Local_Currency__c = decimal.valueof(prtslist.unitPrice);
                                    partsoption.Amount_Local_Currency__c = decimal.valueof(prtslist.expenseTotal);
                                    partsoption.Exchange_Rate_Version__c = lstCurrencyDetails[0].Bolt_Version__c;
                                    partsoption.Unit_Price__c = prtslist.unitPrice;
                                }
                                partsoption.Currency_Type__c = userinfo.getDefaultCurrency();
                            }
                        }
                         system.debug('selectedTTMLPartsList prtslist3'+prtslist.expenseTotal);
                    }
                    else{
                        partsoption.ExpenseTotal__c = decimal.valueof(prtslist.expenseTotal);
                        partsoption.Unit_Price__c = prtslist.unitPrice;
                         system.debug('selectedTTMLPartsList prtslist4'+prtslist.expenseTotal);
                    }
                    
                     system.debug('selectedTTMLPartsList prtslist'+prtslist.expenseTotal);
                    //GSSC-138 end
                    if(partsoption.ExpenseTotal__c == null ){
                        partsoption.ExpenseTotal__c = Decimal.valueOf(prtslist.expenseTotal);
                     }
                    
                     if(prtslist.failCode != 'Select One')
                         partsoption.Fail_Code__c = prtslist.failCode; 
                     else
                         partsoption.Fail_Code__c = 'Select One'; 
                     if(prtslist.accountCode != '' && prtslist.accountCode != null && prtslist.accountCode !='Select One'){
                        partsoption.Account_Code__c = prtslist.accountCode;
                        prtslist.accCoverage=true;
                        prtslist.dispAccountCode=true;
                     }
                     else{
                         partsoption.Account_Code__c ='Select One'; 
                         prtslist.accCoverage=false;
                         prtslist.dispAccountCode=false;
                     }
                     if(prtslist.ids != null){
                         partsoption.Id = prtslist.ids;
                         partsoption.selected_part__c = true;
                     }
                     partsoption.Service_Job__c = Wid;
                     partsoption.Notes__c = null;
                     selectedTTMLPartsList1.add(partsoption);
                     
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
                 
                  system.debug('selectedTTMLPartsList prtslist DealerUser11'+prtslist.expenseTotal);
             }
            
             if (OCList != null && OCList.size() > 0 )
            {
                system.debug('INSIDE OCLIST***');
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
           system.debug('TravelTowingTTMLError***' + TravelTowingTTMLError);
           }
             
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
                 system.debug('Wid'+Wid);
                 system.debug('selectedTTMLPartsList1'+selectedTTMLPartsList1);
                 //53
                 Parterrors.clear();
                 NonParterrors.clear();
                 isTTMLPWAccCodeCovLimitError=false;
                 isTTMLNPWAccCodeCovLimitError=false;
                for(CSS_Parts_Options__c parts : selectedTTMLPartsList1){

                if(solCompexp.containsKey(parts.Account_Code__c) && parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Fail_Code__c!=null && parts.Fail_Code__c!='' )
                {
                    system.debug('testflag'+NonPartsWarrantyFlag);
                CSS_Solution_Component__c solCmpTemp =solCompexp.get(parts.Account_Code__c);
                String covtype = '';
                
                if(accCodeCovTypeMap != null && solCmpTemp.CSS_Account_Formula__c != null){
                covtype = accCodeCovTypeMap.get(solCmpTemp.CSS_Account_Formula__c.RIGHT(2));
                }
                
                system.debug('selectedTTMLPartsList1'+selectedTTMLPartsList1);
                CG_CL_CoverageLimitExceedValidation validate = new CG_CL_CoverageLimitExceedValidation();
                 Map<string,Map<string,string>> cssparterrors = validate.CoverageLimitValidation_TTML(Wid,selectedTTMLPartsList1);
                 system.debug('cssparterrors'+cssparterrors);

                
                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW' ){
                	NonPartsWarrantyFlag = false;
                	for(ttmlWrapperClass prtslist:listTTMLWrapper){
                     if(prtslist.failCode!=null  && prtslist.type!=null  && prtslist.type!='' && prtslist.failCode!='' && prtslist.accountCode!=null && prtslist.accountCode!=''){
                     string partkey =prtslist.type.trim()+'&'+prtslist.accountCode.trim()+'&'+prtslist.failCode.trim();
                     system.debug('Testpartkey'+partkey);
                     system.debug('cssparterrors.containskey'+cssparterrors.containskey(partkey));
                     if(cssparterrors.containskey(partkey)){
                         for(string val :cssparterrors.get(partkey).values()){
                             system.debug('val**'+val);
                             if(!Parterrors.contains(val))
                             Parterrors.add(val); 
                             system.debug('Teste***'+Parterrors);
                         }
                         prtslist.isTTMLFailcodeCovLimitExceed=true;
                         //prtslist.isTTMLAccCodeCovLimitExceed=true;
                         isTTMLPWAccCodeCovLimitError = true;
                         system.debug('erromsg');
                     }else{
                        prtslist.isTTMLFailcodeCovLimitExceed=false;
                        //prtslist.isTTMLAccCodeCovLimitExceed=false;
                        //isTTMLPWAccCodeCovLimitError = false;
                        system.debug('erromsg1');
                     }
                         system.debug('prtslist.isTTMLAccCodeCovLimitExceed'+prtslist.isTTMLAccCodeCovLimitExceed);
                         system.debug('Parterrors'+Parterrors);
                     
                   }
                 }
                }
                else  if (covtype != 'NPW' || covtype != 'RPW' || covtype != 'RRW' || covtype != 'OTH' || covtype != 'POL'){
                	NonPartsWarrantyFlag = true;
                	for(ttmlWrapperClass prtslist:listTTMLWrapper){
                     if(prtslist.failCode!=null  && prtslist.type!=null  && prtslist.type!='' && prtslist.failCode!='' && prtslist.accountCode!=null && prtslist.accountCode!=''){
                     string partkey =prtslist.type.trim()+'&'+prtslist.accountCode.trim();
                     system.debug('Testpartkey'+partkey);
                     system.debug('cssparterrors.containskey'+cssparterrors.containskey(partkey));
                     if(cssparterrors.containskey(partkey)){
                         for(string val :cssparterrors.get(partkey).values()){
                             system.debug('val**'+val);
                             if(!NonParterrors.contains(val))
                             NonParterrors.add(val); 
                         }
                         //prtslist.isTTMLFailcodeCovLimitExceed=true;
                         prtslist.isTTMLAccCodeCovLimitExceed=true;
                         isTTMLNPWAccCodeCovLimitError=true;
                         system.debug('erromsg');
                     }else{
                        //prtslist.isTTMLFailcodeCovLimitExceed=false;
                        prtslist.isTTMLAccCodeCovLimitExceed=false; 
                        //isTTMLNPWAccCodeCovLimitError = false;
                            
                        system.debug('erromsg1');
                     }
                         system.debug('prtslist.isTTMLAccCodeCovLimitExceed'+prtslist.isTTMLAccCodeCovLimitExceed);
                         system.debug('Parterrors'+NonParterrors);
                     
                   }
                 } 
                }
                system.debug('testflag'+NonPartsWarrantyFlag);
                
                }
                }
                
                
                system.debug('Parterrors'+Parterrors);
                system.debug('NonParterrors'+NonParterrors);
                 //53
                 if(selectedTTMLPartsList1.size()>0 && (Parterrors.isEmpty() && NonParterrors.isEmpty())){
                     displayPopup2 = false;
                     system.debug('Testpopupsclo');
                     upsert selectedTTMLPartsList1 Id;
                 }
                 if(!Parterrors.isEmpty() || !NonParterrors.isEmpty())
                 return null;
                 getAllTTMLPartsData();
                 system.debug('Test$$#'+Parterrors);
                 
                 String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
                 pageRefTTML = new PageReference(sDestURL+'id='+Wid); 
                 pageRefTTML.setRedirect(true);
                 return pageRefTTML;
                 
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
    return null;
} 

//Method to get accound codes on change of fail code for TTML
public void calculateExpTotal(){
    isExpenseTotalError = false;
    set<string> setbol = new set<string>();
    
    css_job_order__c jobObj = new css_job_order__c();
    jobObj = [select id, CSS_Travel_Rate__c from css_job_order__c where id=:Wid];
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
    
    //Added below for loop for showing error message after selecting second recond based on criteria as per story #148903,-By Rajesh 29th Jan 2019   
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
//End
//Method to get accound codes on change of fail code for TTML
public void getAccCodesonChngofFailCode(){
    duplicateAccountCode=false;
    String accCode;
    list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
    if(SelectedFailCode!='Select One'){
        lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,CSS_CoverageType__c,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Root_Cause__c= true AND Service_Job__c =:wid and FailCode_Formula__c = :SelectedFailCode AND CSS_Account_Formula__c!=''];
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
       // cpolist =[SELECT Siebel_Value__c, Service_Job__c, CSS_Claims__c, ExpenseTotal__c, Type__c, RecordType.Name, ODM_Status__c, Unit_Price__c, Exchange_Rate__c, Currency_Type__c, Unit_Price_Local_Currency__c, Amount_Local_Currency__c, Exchange_Rate_Version__c  FROM CSS_Parts_Options__c WHERE RecordType.Name = 'TTML' AND Service_Job__c =:Wid];
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
public List<SelectOption> getfailCodeValues(){
    List<SelectOption> options =  new List<SelectOption>(); 
    Set<string> sortableSet = new  Set<string>();
    List<string> sortable = new  List<string>();
    
    options.add(new SelectOption('Select One','Select One'));
    if(solsComp.size()>0){
        for(CSS_Solution_Component__c f:solsComp) {
            if(f.FailCode_Formula__c != 'Select One')
                sortableSet.add(f.FailCode_Formula__c);
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
    return options;    
}

public List<SelectOption> fetchfailCodeValuesNew(String type, List<CSS_Solution_Component__c> solsComp){
    List<SelectOption> options =  new List<SelectOption>(); 
    Set<string> sortableSet = new  Set<string>();
    List<string> sortable = new  List<string>();
    //Commented below lines to avoid SOQL 101 since this method is inside for loop
    //List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
    //solsComp= [SELECT Id,CSS_Account_Formula__c, Type__c,CoveredTravelBaseFareAmt__c, CSS_CoverageType__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, Parts_Warranty__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: wid AND ((Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution') OR (Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
    options.add(new SelectOption('Select One','Select One'));
    system.debug('solsComp--'+solsComp);
    if(solsComp != null && solsComp.size()>0 && type !='Select One'){
        for(CSS_Solution_Component__c sollst1:solsCompTTML) {
            Boolean isFailCodeAdded = false;
            if(sollst1.CSS_CoverageType__c!= null){ 
                if(sollst1.CSS_CoverageType__c == 'OTH' || sollst1.CSS_CoverageType__c == 'POL'){
                    sortableSet.add(sollst1.FailCode_Formula__c);
                    isFailCodeAdded = true;
                }
            }
            else{
                string temp = sollst1.CSS_Account_Formula__c.substring(0,sollst1.CSS_Account_Formula__c.length()-3);
                string temp1 = sollst1.CSS_Account_Formula__c.substring(sollst1.CSS_Account_Formula__c.length()-3,sollst1.CSS_Account_Formula__c.length()); 
                temp1 = temp1.trim();
                temp = temp.trim();
                string temp2 = temp + temp1;
                CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                jetSingle = accCodeMapJET.get(temp2);
                if(jetSingle!= null){
                    if(jetSingle.Attribute1__c == 'OTH' || jetSingle.Attribute1__c == 'POL'){
                        sortableSet.add(sollst1.FailCode_Formula__c);
                        isFailCodeAdded = true;
                    } 
                    
                }
            }
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
                    if((type != null && type != '' && type.equalsIgnoreCase('Commercial-Travel')) || (type != null && type != '' && type.equalsIgnoreCase('Non Commercial-Travel')) || (type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                        if(sollst1.CampaignTravelPercentage__c!=null && double.valueof(sollst1.CampaignTravelPercentage__c)>0){
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
    if(sortableSet.size()>0){
        sortable.AddAll(sortableSet);
    }
    sortable.sort();
    if(sortable.size()>0){
        for(String s:sortable){    
            options.add(new selectOption(s,s));                    
        }   
    }
    return options;    
}
//Method for getting gyedout part on change of Type for Dealer user as per Despicable Me #168027
public void typeListChangeforDealer(){
    try{
        system.debug('tyspelistfordealer');
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        for(ttmlWrapperClass  prtslist : listTTMLWrapper){
            if(prtslist.counting == SelectedPartID){
                prtslist.days = '';
                prtslist.quantity = '';
                prtslist.unitPrice = '';     
                prtslist.mileage = '';
                prtslist.hoursTraveled = '';
                prtslist.expenseTotal = '';
                prtslist.failCode = 'Select One';
                prtslist.failCodelst = new List<SelectOption>();
                List<SelectOption> fC = new List<SelectOption>();
                prtslist.accountCode = '';
                prtslist.accCoverage = false;
                if(prtslist.type != '' && prtslist.type != null)
                {
                    if(prtslist.type == 'Commercial-Travel')
                    {
                        prtslist.showDays = false;
                        prtslist.showUp = true;
                        prtslist.showMileageHT = false;
                        prtslist.mandateMileage = true;
                    }
                    if(prtslist.type == 'Non Commercial-Travel')
                    {
                        prtslist.showDays = false;
                        prtslist.showUp = false;
                        prtslist.showMileageHT = true;
                        prtslist.mandateMileage = true;
                    }
                    if(prtslist.type == 'Meals' || prtslist.type == 'Lodging' || prtslist.type == 'Towing')
                    {
                        prtslist.showDays = true;
                        prtslist.showUp = true;
                        prtslist.showMileageHT = false;
                        prtslist.mandateMileage = false;
                    }
                    
                    else
                    {
                        if( prtslist.type == 'Commercial-Travel' )
                        {
                            //Quan-G,UP-E,Mile-G,Hourt=E
                            prtslist.showDays = false;//Quantity greyed out
                            prtslist.showUP=true;
                            prtslist.showMileage = false;//Mileage greyed out
                            prtslist.showMileageHT = true;//HT editable
                            
                        }
                        else if(prtslist.type == 'Non Commercial-Travel')
                        {
                            prtslist.showDays = false;//Quantity greyed out
                            prtslist.showUP=false;//UP greyed out
                            prtslist.showMileage = true;//Mileage editable
                            prtslist.showMileageHT = true;//HT editable
                        }
                        else{
                            prtslist.showDays = True;//True
                            prtslist.showUP=true;
                            prtslist.showMileage = false;
                            prtslist.showMileageHT = false;
                        }
                        
                    }
                    
                }
                break;
            }  
        }               
    }
    catch(Exception ex){
        System.debug('In catch of typelistchange: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());    
    }
}
public void typeListChangeNewttmlacc(){
    try{
        
         solsCompTTML = new List<CSS_Solution_Component__c>();
        solsCompTTML= [SELECT Id,CSS_Account_Formula__c, Type__c,CoveredTravelBaseFareAmt__c, CSS_CoverageType__c, CampaignTowingPercentage__c, CampaignTravelPercentage__c, Parts_Warranty__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: wid AND ((Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution') OR (Selected_Component__c = true AND FailCode_Formula__c != null AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
    
        List<SelectOption> aC = new List<SelectOption>();
        aC = fetchAccCodeValues(SelectedItem,SelectedFailCode, solsCompTTML);
        
        for(ttmlWrapperClass  prtslist : listTTMLWrapper){
            if(prtslist.counting == SelectedPartID){
                prtslist.failCode = SelectedFailCode;
                prtslist.accCodelst = new List<SelectOption>();
                
                if(prtslist.failCode != 'Select One'){
                    prtslist.accountCode = ttmlAccCode;
                    if(aC.size() <=2 ){  
                        prtslist.accCodelst.addAll(aC);
                    }
                    else{
                        prtslist.accCodelst.addAll(aC);
                        prtslist.accountCode = 'Select One';
                    }
                }
                else{
                    List<SelectOption> options = new List<SelectOption>();
                    options.add(new SelectOption('Select One','Select One'));
                    prtslist.accountCode = 'Select One';
                    prtslist.accCodelst.addAll(options);
                    
                }
    //commented becasue we are getting enable the quantity tab,need to know the Requirment for below code-BY RAJESH july 03 2019            
                /*if(prtslist.type != 'Select One' && prtslist.type != 'Towing'){
                    prtslist.showDays = true;
                    prtslist.showMileageHT = true;
                    prtslist.towErrorMsg = false;
                    towErrorOutputMsg = false;
                }
                else if(prtslist.type == 'Towing'){
                    if(!isOneBMS){
                        towErrorOutputMsg = false;
                        prtslist.towErrorMsg = false;
                    }
                    else{
                        towErrorOutputMsg = true;
                        prtslist.towErrorMsg = true;    
                    }
                    if(dealer == 'DLR')
                        prtslist.showDays = true;
                    else
                        prtslist.showDays = false;
                    if(dealer == 'DLR')
                        prtslist.showMileageHT = true;
                    else
                        prtslist.showMileageHT = false;
                }
                else{
                    if(prtslist.type == 'Select One')
                        prtslist.notes = '';
                    prtslist.showDays = false;
                    prtslist.showUp = false;
                    prtslist.showMileageHT = false;
                    prtslist.towErrorMsg = false;
                    towErrorOutputMsg = false;
                }*/
               break;
            }
        }
        
    }catch(Exception ex){
        system.debug('catch---->>:' +ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
    }
    
}

//End Despicale Me #168027

public List<SelectOption> fetchAccCodeValues(String type, String failCodeSelected, List<CSS_Solution_Component__c> solsCompAccCodes){
    system.debug('inside fetchAccCodeValues');
    ttmlAccCode = '';
    List<SelectOption> options =  new List<SelectOption>(); 
    Set<string> sortableSet = new  Set<string>();
    List<string> sortable = new  List<string>();
    List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
    //solsComp= [SELECT  Id,CSS_Account_Formula__c, CSS_CoverageType__c, Parts_Warranty__c,Type__c, CampaignTowingPercentage__c, CoveredTravelBaseFareAmt__c,CampaignTravelPercentage__c, CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CoveredTravelLabor__c,CoveredTravelMiles__c, CoveredMealsLodgingAmt__c, CoveredTowingMiles__c, Solutions__r.Diagnostic_Response__c, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =: wid AND ((Root_Cause__c= true AND Selected_Component__c = true AND FailCode_Formula__c =: failCodeSelected AND CSS_Account_Formula__c != null AND Solutions__r.Diagnostic_Response__c = 'Most likely the solution') OR (Selected_Component__c = true AND FailCode_Formula__c =: failCodeSelected AND CSS_Account_Formula__c != null AND Type__c IN ('Campaign','ATC','TRP')))];
    options.add(new SelectOption('Select One','Select One'));
    system.debug('mapAccCodes--'+mapAccCodes);
    system.debug('failCodeSelected--'+failCodeSelected);
    system.debug('solsCompTTML--'+solsCompAccCodes);
    if(solsComp != null){
        for(CSS_Solution_Component__c scomp :solsCompAccCodes){
            if(scomp.FailCode_Formula__c == failCodeSelected){
                solsComp.add(scomp);
            }
        }
    }
    system.debug('solsComp--'+solsComp);
    if(solsComp != null && solsComp.size()>0){
        for(CSS_Solution_Component__c sollst1:solsComp) {
            Boolean isAccCodeAdded = false;
            if(sollst1.CSS_CoverageType__c!= null){ 
                if(sollst1.CSS_CoverageType__c == 'OTH' || sollst1.CSS_CoverageType__c == 'POL'){
                    sortableSet.add(sollst1.CSS_Account_Formula__c);
                    isAccCodeAdded = true;
                   }
            }
            else{
                string temp = sollst1.CSS_Account_Formula__c.substring(0,sollst1.CSS_Account_Formula__c.length()-3);
                string temp1 = sollst1.CSS_Account_Formula__c.substring(sollst1.CSS_Account_Formula__c.length()-3,sollst1.CSS_Account_Formula__c.length()); 
                temp1 = temp1.trim();
                temp = temp.trim();
                string temp2 = temp + temp1;
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
            system.debug('***solsComp***'+solsComp);
            system.debug('***isAccCodeAdded***'+isAccCodeAdded);
            system.debug('***sollst1.Type__c***'+sollst1.Type__c);
            system.debug('***sollst1.CoveredMealsLodgingAmt__c***'+sollst1.CoveredMealsLodgingAmt__c);
            if(isAccCodeAdded == false){
                if(sollst1.Type__c != 'Campaign' && sollst1.Type__c != 'TRP' && sollst1.Type__c != 'ATC'){
                    system.debug('***inside with field action***');
                    system.debug('***inside with field action and type value ***'+type);
                    if(type != null && type != '' && (type.equalsIgnoreCase('Commercial-Travel') || type.equalsIgnoreCase('PARKING-FSE') || type.equalsIgnoreCase('PARKING-FSPG') || type.equalsIgnoreCase('TOLLS-FSE') || type.equalsIgnoreCase('TOLLS-FSPG'))){
                        if(sollst1.CoveredTravelBaseFareAmt__c!= null && double.valueof(sollst1.CoveredTravelBaseFareAmt__c)>0 && sollst1.CoveredTravelLabor__c!= null && double.valueof(sollst1.CoveredTravelLabor__c)>0){
                            sortableSet.add(sollst1.CSS_Account_Formula__c);
                            isAccCodeAdded = true;
                        }
                    }else if(type != null && type != '' && (type.equalsIgnoreCase('Non Commercial-Travel') || type.equalsIgnoreCase('MILE WARR FSE') || type.equalsIgnoreCase('MILE WARR FSPG'))){
                        system.debug('sollst1.CoveredTravelMiles__c-->'+sollst1.CoveredTravelMiles__c);
                        system.debug('sollst1.CoveredTravelLabor__c-->'+sollst1.CoveredTravelLabor__c);
                        if(sollst1.CoveredTravelMiles__c!=null && double.valueof(sollst1.CoveredTravelMiles__c)>0 && sollst1.CoveredTravelLabor__c != null && double.valueof(sollst1.CoveredTravelLabor__c)>0){
                            sortableSet.add(sollst1.CSS_Account_Formula__c);
                            isAccCodeAdded = true;
                            system.debug('isAccCodeAdded-->'+isAccCodeAdded);
                        } 
                    }else if(type != null && type != '' && type.equalsIgnoreCase('Towing')){
                        if(sollst1.CoveredTowingMiles__c!=null && double.valueof(sollst1.CoveredTowingMiles__c)>0){
                            sortableSet.add(sollst1.CSS_Account_Formula__c);
                            isAccCodeAdded = true;
                            system.debug('Getting enter into Towing>>>'+isAccCodeAdded);
                        }
                        //}else if((type != null && type != '' && type.equalsIgnoreCase('Meals')) || (type != null && type != '' && type.equalsIgnoreCase('Lodging'))){
                    }else if(type != null && type != '' && type.equalsIgnoreCase('Meals') || type.equalsIgnoreCase('Lodging') || type.equalsIgnoreCase('LODGE- FSE') || type.equalsIgnoreCase('MEAL- FSE') || type.equalsIgnoreCase('MEAL- FSPG')){
                        system.debug('***inside with field action with type value***');
                        if(sollst1.CoveredMealsLodgingAmt__c!=null && double.valueof(sollst1.CoveredMealsLodgingAmt__c)>0){
                            sortableSet.add(sollst1.CSS_Account_Formula__c);
                            isAccCodeAdded = true;
                        }
                    }
                }
                else{
                    if(type != null && type != '' && (type.equalsIgnoreCase('Commercial-Travel') || type.equalsIgnoreCase('Non Commercial-Travel') || type.equalsIgnoreCase('Meals') || type.equalsIgnoreCase('Lodging') || 
                                                      type.equalsIgnoreCase('PARKING-FSE') || type.equalsIgnoreCase('PARKING-FSPG') || type.equalsIgnoreCase('TOLLS-FSE') || type.equalsIgnoreCase('TOLLS-FSPG') || type.equalsIgnoreCase('MILE WARR FSE') || type.equalsIgnoreCase('MILE WARR FSPG') || 
                                                      type.equalsIgnoreCase('LODGE- FSE') || type.equalsIgnoreCase('MEAL- FSE') || type.equalsIgnoreCase('MEAL- FSPG'))){
                                                          if(sollst1.CampaignTravelPercentage__c!=null && double.valueof(sollst1.CampaignTravelPercentage__c)>0){
                                                              sortableSet.add(sollst1.CSS_Account_Formula__c);
                                                              isAccCodeAdded = true;
                                                          }
                                                      }
                    else if(type != null && type != '' && type.equalsIgnoreCase('Towing')){
                        if(sollst1.CampaignTowingPercentage__c!=null && double.valueof(sollst1.CampaignTowingPercentage__c)>0){
                            sortableSet.add(sollst1.CSS_Account_Formula__c);
                            isAccCodeAdded = true;
                        }
                    }
                }
            }
        }
        /*if(solsComp.size()==1)
            ttmlAccCode=solsComp[0].CSS_Account_Formula__c;
        else
            ttmlAccCode='Select One';*/
        
    }
    system.debug('***sortableSet***'+sortableSet);
    if(sortableSet.size()>0){
        sortable.AddAll(sortableSet);
    }
    sortable.sort();
    if(solsComp.size()==1 && sortable.size() > 0)
        ttmlAccCode=sortable[0];
    else
        ttmlAccCode='Select One';
    if(sortable.size()>0){
        for(String s:sortable){    
            options.add(new selectOption(s,s));                    
        }   
    }
    system.debug('ttmlAccCode-->'+ttmlAccCode);
    system.debug('options-->'+options);
    return options;    
}
}