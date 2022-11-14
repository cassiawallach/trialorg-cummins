/**********************************************************************
Name:CG_CL_ClaimsUEOneBMS
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rupesh Pande         06/02/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_CL_ClaimsCustOneBMS
{
    //public String filterCountry;
    //public String filterState;
    
    public DateTime dt_shopIn { get; set; }
     public String getDtShopIn() {
        //css_utility cUtil = new css_utility();
     system.debug('dt_shopIn--'+dt_shopIn);     
     String serviceDate ='';
     if(dt_shopIn != null){
        // locale_formatted_date_time_value = dt_shopIn.format('dd MMM YYYY', 'GMT');
         String locale_formatted_date_time_value = css_utility.getFormattedDate(dt_shopIn); //Get formatted String from Utility Class
         serviceDate = string.valueOf(locale_formatted_date_time_value);
         List<String> tempStr = new List<String>();
               if(serviceDate != null && serviceDate != '')
                tempStr = serviceDate.split(' ');
               if(tempStr.size() >= 3){
                   serviceDate = tempStr[0]+' '+tempStr[1]+' '+tempStr[2];
               }
     }     
        return serviceDate; 
    }
    
    public DateTime lastupdateSubStatus { get; set; }
    public String getRepCom() {
        String  RepairCompletion='';
    if(lastupdateSubStatus!=null){
            String locale_formatted_date_time_value = css_utility.getFormattedDate(lastupdateSubStatus);
               RepairCompletion = string.valueOf(locale_formatted_date_time_value);
               List<String> tempStr = new List<String>();
               if(RepairCompletion != null && RepairCompletion != '')
                tempStr = RepairCompletion.split(' ');
               if(tempStr.size() >= 3){
                   RepairCompletion = tempStr[0]+' '+tempStr[1]+' '+tempStr[2];
               }
        }   
        system.debug('RepairCompletion--->'+RepairCompletion);
        return RepairCompletion;        
    }
    public String filterlocation;
    public string strCntry{get;set;}
    public string strCntryState{get;set;}
    public CG_BL_Intake CG_BL_IntakeObj = new CG_BL_Intake();
    public CG_CL_ClaimsIntake mainContr{set; get;}
    public boolean BMSCustSearchPopup {get;set;}
    public String filterCountry;
    public String filterState;
    public Boolean BMSContactSearchPopup{get;set;}
    
    public String selectedCustCode{get;set;}
    public string selectedLocation {get;set;}
    public boolean showOutageError{get;set;}
    public string errorMessage{get;set;}
    public String selectedContactID{get;set;}
    public boolean BMScrAcFlag;
    public string strBMSAccountMsg {get; set;}
    public string bmsContacterrorMessage {get;set;}
    public CSS_CustomerInboundJSON2APEX CustomerInboundRes{get;set;}
    public Boolean contactshowOutageError {get;set;}
    public CSS_BMSContactLookupResponseJ2A CustomerContactDetails{get;set;}
    public list<CSS_UserLocation__c> lstUserLocations;
    public List<CSS_customerOutboundJSON2Apex.DataArea> paginatedCustDetails {get;set;}
    Transient CSS_customerOutboundJSON2Apex customerDetail{get;set;}
    Transient List<CSS_customerOutboundJSON2Apex.DataArea> fullCustDetails {get;set;}
    List<SelectOption> options;
    map<string,string> mapDescriptionToCode;
    //GETER SETER METHODS
    public String getfilterState() {
        return filterState;
    }

    public void setfilterState(String mfilterState) {
        this.filterState = mfilterState;
    }

    public String getfilterCountry() {
        return filterCountry;
    }

    public void setfilterCountry(String mfilterCountry) {
        this.filterCountry = mfilterCountry; 
    }
    //GETER SETER METHODS
    public CG_CL_ClaimsCustOneBMS()
    {

       
    }
    //method to fecth all the locations based on the logged in user 
    public List<SelectOption> getLocationsName() {
        options = new List<SelectOption>();
        try {
            options = CG_BL_IntakeObj.fetchLocationName(lstUserLocations);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustLegacyBMS - getLocationsName Method ...');
        return options;
    }
     //Selected Contact Details Functionality.
    public void selectedContactDetails(){
        try {
            BMSContactSearchPopup=false; 
            //system.debug('selectedContactID: '+selectedContactID);
            if(selectedContactID != null && selectedContactID != ''){
                system.debug('CustomerContactDetails: '+CustomerContactDetails);
                if ( CustomerContactDetails != null) {
                    for(CSS_BMSContactLookupResponseJ2A.DataArea dt:CustomerContactDetails.DataArea){
                        if(selectedContactID == dt.ContactID ){                
                            system.debug('inside Loop Id: '+dt.ContactID);
                            mainContr.claimsRec.Contact_First_Name__c = dt.FirstName;
                            mainContr.claimsRec.Contact_Last_Name__c = dt.LastName;
                            mainContr.claimsRec.Customer_Contact_Phone__c = '(' + dt.PhoneAreaCode + ')' + ' ' + dt.PhoneNumber;
                            mainContr.claimsRec.Contact_Id__c = dt.ContactID; 
                            //workJob.Email_Address__c = dt.Email;
                            if(dt.Email != null && dt.Email != '' && dt.Email.contains('@')) {
                                string[] emails = dt.Email.split('@');
                                mainContr.EmailAddress = emails[0];
                                mainContr.EmailAddress1 = emails[1];
                               // mainContr.claimsRec.Email_Address__c = false;
                            }
                            //Venkat Added below Code for defect 134455(19/03)
                            if(dt.Email == null || dt.Email == ''){
                                mainContr.EmailAddress = '';
                                mainContr.EmailAddress1 = '';
                               // mainContr.claimsRec.Email_Address__c = false;
                            }
                        }
                    } 
                    CustomerContactDetails = null;
                }
            }
            selectedContactID = null;
            contactshowOutageError = false;
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - selectedContactDetails Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());            
        }
    }


    //Contact lookup Functionality.
    public void ContactLookup() {
        system.debug('inside contact look up >>>>>>>');
        try {
            BMSContactSearchPopup = true;
            CSS_FN_BMS BMSFunctionality = new CSS_FN_BMS();
            //Modified code for story# 76192 (Added Selected Location code parameter)
            //CustomerContactDetails = BMSFunctionality.getBMSContactDetails(mainContr.workJob.Customer_Code__c);
            System.debug('*****Customer Code*******'+mainContr.claimsRec.Customer_Code__c);
             System.debug('*****Customer Code Location__c*******'+mainContr.claimsRec.Location__c);
            System.debug('*****Selected Location*******'+selectedLocation);
            if(selectedLocation==null){
            User user = css_utility.getUserAttributes(userInfo.getUserId());
                selectedLocation = user.User_Location__c; } 
                  System.debug('*****Selected Location2*******'+selectedLocation);
            CustomerContactDetails = BMSFunctionality.getBMSContactDetails(mainContr.claimsRec.Customer_Code__c, selectedLocation);
           
            
           // CustomerContactDetails = BMSFunctionality.getBMSContactDetails('1234','03520-56255');
            system.debug('response body>>>>CustomerContactDetails'+CustomerContactDetails);
            if(CustomerContactDetails !=null && CustomerContactDetails.Header.Status == 'ERROR') {
                system.debug('system outage error*******>>>');
                contactshowOutageError = true;
                if(CustomerContactDetails.Header!=null && CustomerContactDetails.Header.ReturnCodeDescription == 'Contact not Found') {
                    //errorMessage = 'No data available.  Please create customer account.';
                    bmsContacterrorMessage = System.Label.CSS_bms_Contact_NotAvailable;
                }
                else{
                    bmsContacterrorMessage = CustomerContactDetails.Header.ReturnCodeDescription;
                }    
            }
            //Checking if there is no Customer records return from the server displaying the message Stroy-7105
            else if(CustomerContactDetails != null && CustomerContactDetails.DataArea.isEmpty()) {
                system.debug('list is empty popup ******');
                //CSS_PageErrorHandlingUtility.showInfo('No data available.  Please create customer account.');
                contactshowOutageError = true;
                bmsContacterrorMessage = System.Label.CSS_bms_Contact_NotAvailable;
            }
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - ContactLookup Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());            
        }           
    }
     //Reset BMS Fields.
    public void resetBMSFields() {
        try {
            mainContr.claimsRec.Customer_Name__c = null;
            mainContr.claimsRec.Customer_Code__c = null;
            mainContr.claimsRec.Customer_Phone__c = null;
            mainContr.claimsRec.Contact_First_Name__c = null;
            mainContr.claimsRec.Contact_Last_Name__c = null;
            mainContr.claimsRec.Customer_Contact_Phone__c = null;
            mainContr.claimsRec.Address__c = null;
          //  mainContr.claimsRec.Application_Desc__c = null;
            mainContr.claimsRec.Claims_city__c = null;
            mainContr.claimsRec.State__c = null;
            mainContr.claimsRec.ZipCode__c = null;
            mainContr.claimsRec.Country__c = null;
           // mainContr.claimsRec.CSS_Charge_Account_Status__c = null;
           // mainContr.claimsRec.Available_Credit__c = null;
           // mainContr.claimsRec.Amount_Due__c = null;
          //  mainContr.claimsRec.Credit_Limit__c = null;
            mainContr.claimsRec.Shop_Work_Order__c = null;
           // mainContr.claimsRec.Date_in_Shop__c = null;   
            mainContr.EmailAddress = '';
            mainContr.EmailAddress1 = '';
          //  mainContr.AppointmentName = 'No';
           // mainContr.claimsRec.Email_check_box__c = false;
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - resetBMSFields Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());            
        }         
    } 



    //method to get the label of the selected location code from the Ui i.e it returs the location name which we will stamp on the work job .
    public string getLocationLabel(string selectedLocation){
        string selectedLocationName;
        try {
            if(options !=null && options.size()>0) {
                //for loop to set the location name selected on the user screen based on the location code .
                for(SelectOption s : options){
                    if(s.getValue() == selectedLocation){
                        selectedLocationName = s.getLabel();
                    }
                    system.debug('selectedLocationName--->'+selectedLocationName);
                }
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationLabel Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return selectedLocationName;
    }

    //Changing Location Functionality.
    public pagereference changeLocation() {
        PageReference pageRef;
        try {
            //Cache.Session.put('UserERPSystem', 'No ERP System');
            Cache.Session.put('selectedLocation', selectedLocation);
            System.debug('selectedLocation>>>:'+selectedLocation);
            css_utility.setSessionVariables(selectedLocation);
        //Added for defect 124454
list<CSS_JobEventTemporary__c>  lUnitType=[select Reason__c from CSS_JobEventTemporary__c  where attribute1__c='UnitTypes' and Key__c=:selectedLocation];
            System.debug('lUnitType>>>:'+lUnitType);
        if (lUnitType.size()==0 || lUnitType == null ){
            System.debug('lunitType');
                CSS_WS_BMS cbms=new CSS_WS_BMS();
            System.debug('Webservice Call--');
                cbms.getSubTypesUnitTypesService(selectedLocation);
            
        }
            
            if(mainContr.Cid== null) 
                pageRef= new pageReference('/apex/CG_IntakeCustomer'); 
            else
                pageRef= new pageReference('/apex/CG_IntakeCustomer?id=' + mainContr.Cid); 
            //pageRef= new pageReference('/apex/CG_IntakeCustomer'); 
            pageRef.setRedirect(true);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return pageRef;
    }
    //Fetching Country Values.
    public List<SelectOption> getCountry() 
    {
        List<SelectOption> CountryList = new List<SelectOption>(); 
        try {  
            CountryList = CG_BL_IntakeObj.getCountry();
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_ClaimsCustOneBMS - getCountry Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return CountryList;
    }

    //Fetching States based on Country Values.
    public List<SelectOption> getStates()
    {     
        List<SelectOption> StatesList = new List<SelectOption>();
        try {
            StatesList = CG_BL_IntakeObj.getStates(mainContr.filterCountry);
        }
        catch(exception e) { 
            system.debug('EXCEPTION of CG_CL_ClaimsCustOneBMS- getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return StatesList;
    }
    
    //Method for getting Repair locations
    public List<SelectOption> getRepairLocation(){
        List<SelectOption> repairLocList = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = CSS_Claims__c.Repair_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            repairLocList.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
        //CG_CL_ClaimsFC.upsertAdminSRT();
        return repairLocList;
    }
    
    public void autoAdminSrt(){
        Boolean allInShopYesFlag = false;
        Boolean allFailuresFlag = true;
        system.debug('Inside Auto AdminSRT');
        CG_CL_ClaimsFC claimsFC = new CG_CL_ClaimsFC();
       if(mainContr.solComps != null && mainContr.solComps.size() >0 && mainContr.claimsRec !=null ) 
        claimsFC.upsertAdminSRT(mainContr.claimsRec,mainContr.solComps,allInShopYesFlag,allFailuresFlag);
    }

    //Fetching BMS Customer Details.
     //Selected Customer from BMS Popup.
    public void selectedCustDetails() {
        BMSCustSearchPopup=false; 
        //system.debug('selectedCustCode: '+selectedCustCode);
        try {
            if(selectedCustCode != null && selectedCustCode != '') {
                system.debug('selectedCustCode: '+paginatedCustDetails);
                if ( paginatedCustDetails != null && !paginatedCustDetails.isEmpty() ) {
                    system.debug('testing purpose');
                    for(CSS_customerOutboundJSON2Apex.DataArea dt:paginatedCustDetails){
                        system.debug('inside Loop: '+dt.CustomerCode);
                        if(selectedCustCode == dt.CustomerCode ) {                
                            system.debug('inside Loop Id: '+dt.CustomerCode);
                            mainContr.claimsRec.bmsCreateAccount__c = true;
                            mainContr.claimsRec.Customer_Name__c = dt.CustomerName;
                            mainContr.claimsRec.Customer_Code__c = dt.CustomerCode;
                            mainContr.claimsRec.Customer_Phone__c = '(' + dt.AreaCode + ')' + ' ' + dt.PhoneNumber;
                             
                            mainContr.claimsRec.Address__c = dt.LocationAddressline1 + ' ' + dt.LocationAddressline2 + ' ' + dt.LocationAddressline3;
                            mainContr.claimsRec.Claims_city__c = dt.City;
                            mainContr.claimsRec.State__c=dt.State;
                            mainContr.claimsRec.Country__c=dt.country;
                            //Added if condition for defect 108703
                            if (dt.country!=null && dt.country!='' && dt.State!=null && dt.State!=''){
                            mainContr.strCntryState= css_utility.getStateDesc(dt.country,dt.State);}
                           // mainContr.claimsRec.CSS_State__c = mainContr.strCntryState;//css_utility.getStdPicklistCode('User', 'Statecode', dt.State, 'LBL'); //dt.State;
                            System.debug('State++++++++ '+ mainContr.strCntryState);
                            mainContr.claimsRec.ZipCode__c = dt.Postalcode1;
                            //Added if condition for defect 108703
                            if (dt.country!=null && dt.country !=''){
                            mainContr.strCntry = css_utility.getCountryDesc(dt.country);}
                            mainContr.claimsRec.Country__c = mainContr.strCntry; //css_utility.getStdPicklistCode('User', 'Countrycode', dt.country, 'LBL');  //'United Sates';//dt.country;
                            mainContr.claimsRec.State__c = mainContr.strCntryState;
                            //  mainContr.claimsRec.CSS_Charge_Account_Status__c = dt.PaymentType;
                           // mainContr.claimsRec.Available_Credit__c = Decimal.valueOf(dt.AvailableCredit);
                          //  mainContr.claimsRec.Credit_Limit__c = Decimal.valueOf(dt.CreditLimit);
                          //  mainContr.claimsRec.Amount_Due__c = Decimal.valueOf(dt.AmountDue);
                            mainContr.claimsRec.Contact_First_Name__c = '';
                            mainContr.claimsRec.Contact_Last_Name__c = '';
                            mainContr.claimsRec.Customer_Contact_Phone__c = '';
                            //workJob.Shop_Work_Order__c
                        //    mainContr.claimsRec.bmsCreateAccount__c = true;
                        //    mainContr.claimsRec.CSS_Bms_ContactBoolean__c = true;
                        //    mainContr.claimsRec.Unit_Number__c = '';
                            System.debug('mainContr.claimsRec++++++++ '+mainContr.claimsRec);
                        }
                    } 
                    paginatedCustDetails.clear();
                }
            }
            selectedCustCode = null;
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - selectedCustDetails Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());            
        }
    }
    public void getBMSCustDetails() {
        //initializing the error block lable 
        try {
            if ((mainContr.claimsRec.Customer_Name__c!=null && mainContr.claimsRec.Customer_Name__c!='') || (mainContr.claimsRec.Customer_Code__c!=null && mainContr.claimsRec.Customer_Code__c!='')) {
                system.debug('Customer Name>>>>'+mainContr.claimsRec.Customer_Name__c);
                showOutageError = false; 
                BMSCustSearchPopup=true;
                string usrLoc = selectedLocation;
                customerDetail = new CSS_customerOutboundJSON2Apex();
                String custParam = Apexpages.currentPage().getParameters().get('custNameParam');
                system.debug('param value Anvesh>>>'+custParam);

                if(custParam != null && custParam == 'CustomerParam'){
                    mainContr.claimsRec.Customer_Code__c = '';
                }
                else{
                    mainContr.claimsRec.Customer_Name__c = '';
                }

                //customerDetail = CSS_WS_BMS.callCustOutboundService(mainContr.workJob.Customer_Name__c, mainContr.workJob.Customer_Code__c,usrLoc);
                CG_OP_OAGWrapper outputWrapper = CG_BL_Intake.fetchBMSCustomerDetails(mainContr.claimsRec.Customer_Name__c, mainContr.claimsRec.Customer_Code__c,'03520-56255');
                customerDetail = (CSS_customerOutboundJSON2Apex)JSON.deserialize(outputWrapper.response.getBody(),CSS_customerOutboundJSON2Apex.class);

                system.debug('in intake job customerDetail >>> '+customerDetail );
                if(customerDetail !=null && customerDetail.Header.Status == 'ERROR'){
                    system.debug('system outage error*******>>>');
                    showOutageError = true;
                    if(customerDetail.Header!=null && customerDetail.Header.ReturnCodeDescription == 'Customer not Found'){
                        //errorMessage = 'No data available.  Please create customer account.';
                        errorMessage = System.Label.CSS_Cust_No_Data_Available;
                    } else {
                        errorMessage = customerDetail.Header.ReturnCodeDescription;
                    }    
                }
                //Checking if there is no Customer records return from the server displaying the message Stroy-7105
                else if(customerDetail != null && customerDetail.DataArea.isEmpty()){
                    system.debug('list is empty popup ******');
                    //CSS_PageErrorHandlingUtility.showInfo('No data available.  Please create customer account.');
                    showOutageError = true;
                    errorMessage = System.Label.CSS_Cust_No_Data_Available;
                } else {
                    fullCustDetails = customerDetail.DataArea;
                    paginatedCustDetails = new List<CSS_customerOutboundJSON2Apex.DataArea>();
                    if(fullCustDetails != null){
                    for(Integer i=0;i<1000;i++){
                        if(i<1000)
                            paginatedCustDetails.add(fullCustDetails.get(i));
                    }}
                    fullCustDetails = new List<CSS_customerOutboundJSON2Apex.DataArea>(); 
                    customerDetail = null;
                    //trimListSize();                    
                }
            }
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getBMSCustDetails Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());            
        }
    }
        //Calling BMS services on Create Account Functionality.
    public boolean bmsCustInbound() {
        CustomerInboundRes = new CSS_CustomerInboundJSON2APEX();
        BMScrAcFlag=false;
        //making a callout to send the details to BMS
        try {
            //Modified as per story# 64030
            String primarySgmntCD = css_utility.getCodes('Primary Segment',mainContr.filterApplication,null,null);
            system.debug('primarySgmntCD -->'+ primarySgmntCD);
            string usrLoc ='';
            if(!Test.isRunningTest()) {
                usrLoc = selectedLocation;
            } else {
                usrLoc  = '56270-56270';
            }
            System.debug('SelCountryCode '+ mainContr.filterCountry + ' SelectedStateCode '+ mainContr.filterState);
            //CustomerInboundRes = CSS_WS_BMS.callBMSCustInboundService(mainContr.workJob.Customer_Name__c, mainContr.workJob.Address__c, '', '', mainContr.workJob.Phone_Number__c.substring(1,4), mainContr.workJob.Phone_Number__c.substring(6,14), mainContr.workJob.City__c, filterState, mainContr.workJob.ZipCode__c, '', css_utility.getSubStringValue(mainContr.workJob.First_Name__c, 0, 15) + css_utility.getSubStringValue(mainContr.workJob.BMS_Last_Name__c, 0, 15), filterCountry, 'en', primarySgmntCD, usrLoc);
            CG_OP_OAGWrapper outputWrapper = CG_BL_Intake.createBMSAccount(mainContr.claimsRec.Customer_Name__c, mainContr.claimsRec.Address__c, '', '', mainContr.claimsRec.Customer_Contact_Phone__c.substring(1,4), mainContr.claimsRec.Customer_Phone__c.substring(6,14), mainContr.claimsRec.Claims_city__c, mainContr.filterState, mainContr.claimsRec.ZipCode__c, '', css_utility.getSubStringValue(mainContr.claimsRec.Contact_First_Name__c, 0, 15) + css_utility.getSubStringValue(mainContr.claimsRec.Claims_city__c, 0, 15), mainContr.filterCountry, 'en', primarySgmntCD, usrLoc);

            CustomerInboundRes = (CSS_CustomerInboundJSON2APEX )JSON.deserializeStrict(outputWrapper.response.getBody(),CSS_CustomerInboundJSON2APEX.class);
            system.debug('sj>>>>'+CustomerInboundRes.Header +'*************'+CustomerInboundRes );
            if(CustomerInboundRes.Header.Status=='SUCCESS') {
                BMScrAcFlag=true;
                mainContr.claimsRec.Customer_Code__c = CustomerInboundRes.DataArea.CustomerCode;
            } else {
                BMScrAcFlag=false;
                strBMSAccountMsg=CustomerInboundRes.Header.ReturnCodeDescription;
                system.debug('strBMSAccountMsg>>>'+strBMSAccountMsg);
            }
        } catch(exception ex) {
            System.debug('Excepton in CG_CL_IntakeCustLegacyBMS Class - bmsCustInbound Method '+ex.getLineNumber() +' '+ ex.getMessage());
        }
        return BMScrAcFlag;
    }  

    public void closeBMSContDetails() {
        BMSContactSearchPopup = false;
        contactshowOutageError = false;
    }
    public void closeBMSCustDetails() {
        BMSCustSearchPopup=false;
    }
    public void selectedBMSCustCode() {

    }
 
   
}