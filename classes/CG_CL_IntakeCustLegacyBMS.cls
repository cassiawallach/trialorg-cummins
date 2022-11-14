/**********************************************************************
Name:CG_CL_IntakeCustLegacyBMS
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this component Controller when the user has LEgacy BMS ERP.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Krishnamoorthi      12/19/2017      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_CL_IntakeCustLegacyBMS {

    //Global Veriables
    public CG_CL_IntakeCustomer mainContr{set; get;}
    public CG_CL_IntakeVH mainContrVH{set; get;}
    public CG_CL_IntakeRJ mainContrRJ{set; get;}
    public CG_CL_IntakeWarranty mainContrWR{set; get;}
    public string AppointmentName{get;set;}
    public string selectedLocation {get;set;}
    public boolean reqBoolean {get;set;}
    public string EmailAddress {get;set;}
    public string EmailAddress1 {get;set;}
    public string datebyLocaleValue {get;set;}
    public String filterApplication {get;set;}
    public boolean BMSCustSearchPopup {get;set;}
    public Boolean BMSContactSearchPopup{get;set;}
    public string bmsContacterrorMessage {get;set;}
    public Boolean contactshowOutageError {get;set;}
    public string strBMSAccountMsg {get; set;}
    public String selectedContactID{get;set;}
    public List<CSS_customerOutboundJSON2Apex.DataArea> paginatedCustDetails {get;set;}
    public CSS_CustomerInboundJSON2APEX CustomerInboundRes{get;set;}
    public CSS_BMSContactLookupResponseJ2A CustomerContactDetails{get;set;}
    public boolean showOutageError{get;set;} 
    public String selectedCustCode{get;set;}
    public string cacheSL { get; set; }  
    public string strCntry{get;set;}
    public string strCntryState{get;set;}
    public string errorMessage{get;set;}
    public boolean BMScrAcFlag;
    public Boolean isDealer {get;set;}
    public String filterCountry;
    public String filterState;
    public boolean prErrorFlag {get;set;} //Stroy Number174846 
    public string showPRErrorMessage {get;set;} //Stroy Number174846
    public list<CSS_UserLocation__c> lstUserLocations;
    public CG_BL_Intake CG_BL_IntakeObj = new CG_BL_Intake();

    Transient CSS_customerOutboundJSON2Apex customerDetail{get;set;}
    Transient List<CSS_customerOutboundJSON2Apex.DataArea> fullCustDetails {get;set;}

    List<SelectOption> options;
    map<string,string> mapDescriptionToCode;

    //Global Veriables

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

    //Constructor.
    public CG_CL_IntakeCustLegacyBMS() {
        System.debug('IN CG_CL_IntakeCustLegacyBMS constructor...');
        system.debug('mainContr--'+mainContr);
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        } 
        try {
            system.debug('Cache.Session.get(UserERPSystem) ' +  Cache.Session.get('UserERPSystem'));
            system.debug('Cache.Session.get(selectedLocation) ' +  Cache.Session.get('selectedLocation'));
            if(Cache.Session.get('UserERPSystem') == 'BMS Legacy'  || Cache.Session.get('UserERPSystem') == 'One BMS'){
                lstUserLocations = new list<CSS_UserLocation__c>();
                //query to get the user locations 
                lstUserLocations = CG_BL_Intake.fetchMultiLocation();
                cacheSL = (String) Cache.Session.get('selectedLocation');
                if(cacheSL == null || cacheSL == '')
                    selectedLocation = CG_BL_Intake.selectedLocation(lstUserLocations);
                else
                    selectedLocation = cacheSL;
                system.debug('selectedLocation****'+selectedLocation);
                datebyLocaleValue = css_utility.getFormattedDate();
                system.debug('datebyLocaleValue****'+datebyLocaleValue);
                if(maincontr.AppointmentName!=null )
                mainContr.AppointmentName = 'No';  
                
                prErrorFlag = false;             
            }
            mainContr.AppointmentName = 'No';
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustLegacyBMS constructor...' + Cache.Session.get('UserERPSystem'));
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

            if(mainContr.Wid== null) 
                pageRef= new pageReference('/apex/CG_IntakeCustomer'); 
            else
                pageRef= new pageReference('/apex/CG_IntakeCustomer?id=' + mainContr.Wid); 
            //pageRef= new pageReference('/apex/CG_IntakeCustomer'); 
            pageRef.setRedirect(true);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return pageRef;
    }

    //Fetching Country Values.
    public List<SelectOption> getCountry() {
        List<SelectOption> CountryList = new List<SelectOption>(); 
        try {  
            CountryList = CG_BL_IntakeObj.getCountry();
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getCountry Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return CountryList;
    }

    //Fetching States based on Country Values.
    public List<SelectOption> getStates(){     
        List<SelectOption> StatesList = new List<SelectOption>();
        try {
            StatesList = CG_BL_IntakeObj.getStates(mainContr.filterCountry);
        }
        catch(exception e) { 
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return StatesList;
    }   

    //Fetching Application values.
    public List<SelectOption> getApplication() {
        List<SelectOption> lstApplications;
        try {
            CSS_JobEventTemporary__c[] applicationCodes;
            applicationCodes = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'ApplicationCodes'];
            system.debug('applicationCodes>>>'+applicationCodes);
            string jsonResponse = applicationCodes[0].Reason__c;
            CSS_WPR_SBL_ApplicationResJSON resJSON;
            resJSON = (CSS_WPR_SBL_ApplicationResJSON)JSON.deserialize(jsonResponse ,CSS_WPR_SBL_ApplicationResJSON.class);
            mapDescriptionToCode = new map<string,string>();
            lstApplications = new List<SelectOption>();
            lstApplications.add(new SelectOption('','----None----'));
            if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                     if(det.ActiveFlag == 'Y' && det.ApplicationCode!='890' && det.ApplicationCode!='891'){  // karthik G added as part of GSSC-512
                        lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                        //populating description to code map 
                        mapDescriptionToCode.put(det.Description,det.ApplicationCode);
                    }
                }
            }
            system.debug('lstApplications>>>'+lstApplications);
            lstApplications.sort();
        }
        catch(exception e) {
            system.debug('EXCEPTION of CG_BL_Intake - getApplication Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return lstApplications;
    }

    //Fetching BMS Customer Details.
    public void getBMSCustDetails() {
        //initializing the error block lable 
        try {
            if ((mainContr.workJob.Customer_Name__c!=null && mainContr.workJob.Customer_Name__c!='') || (mainContr.workJob.Customer_Code__c!=null && mainContr.workJob.Customer_Code__c!='')) {
                system.debug('Customer Name>>>>'+mainContr.workJob.Customer_Name__c);
                showOutageError = false; 
                BMSCustSearchPopup=true;
                prErrorFlag = false;
                string usrLoc = selectedLocation;
                customerDetail = new CSS_customerOutboundJSON2Apex();
                String custParam = Apexpages.currentPage().getParameters().get('custNameParam');
                system.debug('param value Anvesh>>>'+custParam);

                if(custParam != null && custParam == 'CustomerParam'){
                    mainContr.workJob.Customer_Code__c = '';
                }
                else{
                    mainContr.workJob.Customer_Name__c = '';
                }

                //customerDetail = CSS_WS_BMS.callCustOutboundService(mainContr.workJob.Customer_Name__c, mainContr.workJob.Customer_Code__c,usrLoc);
                CG_OP_OAGWrapper outputWrapper = CG_BL_Intake.fetchBMSCustomerDetails(mainContr.workJob.Customer_Name__c, mainContr.workJob.Customer_Code__c,usrLoc);
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

    //Selected Customer from BMS Popup.
    public void selectedCustDetails() {
        BMSCustSearchPopup=false; 
        //system.debug('selectedCustCode: '+selectedCustCode);
        try {
            if(selectedCustCode != null && selectedCustCode != '' && prErrorFlag == false) {
                system.debug('selectedCustCode: '+paginatedCustDetails);
                if ( paginatedCustDetails != null && !paginatedCustDetails.isEmpty() ) {
                    system.debug('testing purpose');
                    for(CSS_customerOutboundJSON2Apex.DataArea dt:paginatedCustDetails){
                        system.debug('inside Loop: '+dt.CustomerCode);
                        if(selectedCustCode == dt.CustomerCode ) {                
                            system.debug('inside Loop Id: '+dt.CustomerCode);
                            mainContr.workJob.Customer_Name__c = dt.CustomerName;
                            mainContr.workJob.Customer_Code__c = dt.CustomerCode;
                            mainContr.workJob.Phone_Number__c = '(' + dt.AreaCode + ')' + ' ' + dt.PhoneNumber;
                            // workJob.Contact_Name__c = dt.CustomerName;
                            //workJob.Cstmr_Contacts_Phone__c = 
                            mainContr.workJob.Address__c = dt.LocationAddressline1 + ' ' + dt.LocationAddressline2 + ' ' + dt.LocationAddressline3;
                            mainContr.workJob.City__c = dt.City;
                            mainContr.filterState=dt.State;
                            mainContr.filterCountry=dt.country;
                            //Added if condition for defect 108703
                            if (dt.country!=null && dt.country!='' && dt.State!=null && dt.State!=''){
                                mainContr.strCntryState= css_utility.getStateDesc(dt.country,dt.State);}
                            mainContr.workJob.CSS_State__c = mainContr.strCntryState;//css_utility.getStdPicklistCode('User', 'Statecode', dt.State, 'LBL'); //dt.State;
                            System.debug('State++++++++ '+ mainContr.strCntryState);
                            mainContr.workJob.ZipCode__c = dt.Postalcode1;
                            //Added if condition for defect 108703
                            if (dt.country!=null && dt.country !=''){
                                mainContr.strCntry = css_utility.getCountryDesc(dt.country);}
                            mainContr.workJob.Country__c = mainContr.strCntry; //css_utility.getStdPicklistCode('User', 'Countrycode', dt.country, 'LBL');  //'United Sates';//dt.country;
                            mainContr.workJob.CSS_Charge_Account_Status__c = dt.PaymentType;
                            if(dt.AvailableCredit != null && dt.AvailableCredit != '')
                                mainContr.workJob.Available_Credit__c = Decimal.valueOf(dt.AvailableCredit);
                            if(dt.CreditLimit != null && dt.CreditLimit != '')
                                mainContr.workJob.Credit_Limit__c = Decimal.valueOf(dt.CreditLimit);
                            if(dt.AmountDue != null && dt.AmountDue != '')
                                mainContr.workJob.Amount_Due__c = Decimal.valueOf(dt.AmountDue);
                            mainContr.workJob.First_Name__c = '';
                            mainContr.workJob.BMS_Last_Name__c = '';
                            mainContr.workJob.Cstmr_Contacts_Phone__c = '';
                            //workJob.Shop_Work_Order__c
                            mainContr.workJob.bmsCreateAccount__c = true;
                            mainContr.workJob.CSS_Bms_ContactBoolean__c = true;
                            mainContr.workJob.Unit_Number__c = '';
                            System.debug('mainContr.workJob++++++++ '+mainContr.workJob);
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
                            mainContr.workJob.First_Name__c = dt.FirstName;
                            mainContr.workJob.BMS_Last_Name__c = dt.LastName;
                            mainContr.workJob.Cstmr_Contacts_Phone__c = '(' + dt.PhoneAreaCode + ')' + ' ' + dt.PhoneNumber;
                            mainContr.workJob.Contact_ID__c = dt.ContactID; 
                            //workJob.Email_Address__c = dt.Email;
                            if(dt.Email != null && dt.Email != '' && dt.Email.contains('@')) {
                                string[] emails = dt.Email.split('@');
                                mainContr.EmailAddress = emails[0];
                                mainContr.EmailAddress1 = emails[1];
                                mainContr.workJob.Email_check_box__c = false;
                            }
                            //Venkat Added below Code for defect 134455(19/03)
                            if(dt.Email == null || dt.Email == ''){
                                mainContr.EmailAddress = '';
                                mainContr.EmailAddress1 = '';
                                mainContr.workJob.Email_check_box__c = false;
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
            CustomerContactDetails = BMSFunctionality.getBMSContactDetails(mainContr.workJob.Customer_Code__c, selectedLocation);
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
            mainContr.workJob.Customer_Name__c = null;
            mainContr.workJob.Customer_Code__c = null;
            mainContr.workJob.Phone_Number__c = null;
            mainContr.workJob.First_Name__c = null;
            mainContr.workJob.BMS_Last_Name__c = null;
            mainContr.workJob.Cstmr_Contacts_Phone__c = null;
            mainContr.workJob.Address__c = null;
            mainContr.workJob.Application_Desc__c = null;
            mainContr.workJob.City__c = null;
            mainContr.workJob.CSS_State__c = null;
            mainContr.workJob.ZipCode__c = null;
            mainContr.workJob.Country__c = null;
            mainContr.workJob.CSS_Charge_Account_Status__c = null;
            mainContr.workJob.Available_Credit__c = null;
            mainContr.workJob.Amount_Due__c = null;
            mainContr.workJob.Credit_Limit__c = null;
            mainContr.workJob.Shop_Work_Order__c = null;
            mainContr.workJob.Date_in_Shop__c = null;   
            mainContr.EmailAddress = '';
            mainContr.EmailAddress1 = '';
            mainContr.AppointmentName = 'No';
            mainContr.workJob.Email_check_box__c = false;
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - resetBMSFields Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());            
        }         
    } 

    //Create Account Functionality.
    public PageReference createAccount() {

        css_job_order__c worecord= new css_job_order__c();
        system.debug('filterCountry >>>> ' + mainContr.filterCountry);
        system.debug('filterState >>>> ' + mainContr.filterState);
        system.debug('EmailAddress >>>> ' + mainContr.EmailAddress + ' <<<< EmailAddress1 >>>>' + mainContr.EmailAddress1);
        try {
            //***** Venkat commented below Code for defect 134455(19/03) ******
            // CSS_JobOrderWrapper wrap = new CSS_JobOrderWrapper(mainContr.workJob,null,null,null,null,mainContr.filterCountry,mainContr.filterState,true,mainContr.EmailAddress,mainContr.EmailAddress1,false);//bms enabled is wrong
            //system.debug('wrap >>>> ' + wrap);
            //worecord = wrap.worecord;
            System.debug('createAccount Entered Here');
            //Modified as per story# 64030
            //String appCode = css_utility.getCodes('Application Code',workJob.Application__c,null,null);
            String appCode = css_utility.getCodes('Application Code',mainContr.filterApplication,null,null);

            system.debug('appCode -->' + appCode);
            if(!bmsCustInbound())
                return null;
            strBMSAccountMsg=null;        
            system.debug('mainContr.workJob.Customer_Code__c ***' + mainContr.workJob.Customer_Code__c);

            if (mainContr.workJob.Customer_Code__c==null || mainContr.workJob.Customer_Code__c=='') {
                mainContr.workJob.bmsCreateAccount__c = false; }else{
                mainContr.workJob.bmsCreateAccount__c = true;               
            }        

            //System.debug('bmsCreateAccount'+bmsCreateAccount);

            //worecord.bmsCreateAccount__c = true;
            worecord.bmsCreateAccount__c = mainContr.workJob.bmsCreateAccount__c;                
            worecord.Customer_Name__c= mainContr.workJob.Customer_Name__c;
            worecord.Customer_Code__c= mainContr.workJob.Customer_Code__c;
            worecord.Phone_Number__c= mainContr.workJob.Phone_Number__c;
            // worecord.Contact_Name__c=mainContr.workJob.Contact_Name__c;
            worecord.First_Name__c= mainContr.workJob.First_Name__c;
            worecord.BMS_Last_Name__c= mainContr.workJob.BMS_Last_Name__c;
            worecord.Cstmr_Contacts_Phone__c= mainContr.workJob.Cstmr_Contacts_Phone__c;
            //system.debug('checkbox*********'+Email_check_box__c);
            if(mainContr.workJob.Email_check_box__c==true) {
                worecord.Email_Address__c='declined@cummins.com';
            } else {
                if(mainContr.EmailAddress == null)
                    mainContr.EmailAddress = '';
                if(mainContr.EmailAddress1 == null)
                    mainContr.EmailAddress1 = '';    
                if((mainContr.EmailAddress == null || mainContr.EmailAddress == '') && (mainContr.EmailAddress1 == null || mainContr.EmailAddress1 == ''))
                    worecord.Email_Address__c='';
                else
                    worecord.Email_Address__c=mainContr.EmailAddress+'@'+mainContr.EmailAddress1;
            }
            worecord.Address__c= mainContr.workJob.Address__c;
            worecord.City__c= mainContr.workJob.City__c;
            worecord.CSS_State__c = mainContr.filterState;
            system.debug('SelectedStateCode*********'+ mainContr.filterCountry + ' '+ mainContr.filterState);
            // worecord.CSS_State__c = workJob.CSS_State__c;
            worecord.ZipCode__c= mainContr.workJob.ZipCode__c;
            // worecord.Country__c= mainContr.workJob.Country__c;
            worecord.Country__c = mainContr.filterCountry;
            //    worecord.Country__c = mainContr.workJob.Country__c;
            worecord.Primary_Segment__c = mainContr.workJob.Primary_Segment__c;
            worecord.CSS_Charge_Account_Status__c= mainContr.workJob.CSS_Charge_Account_Status__c;
            worecord.Available_Credit__c = mainContr.workJob.Available_Credit__c;
            worecord.Amount_Due__c = mainContr.workJob.Amount_Due__c;
            worecord.Credit_Limit__c = mainContr.workJob.Credit_Limit__c;
            if(mainContr.workJob.Date_in_Shop__c!=null)
                worecord.Date_In__c = datetime.newInstance(mainContr.workJob.Date_in_Shop__c.year(), mainContr.workJob.Date_in_Shop__c.month(),mainContr.workJob.Date_in_Shop__c.day(),12,0,0);
            worecord.Shop_Work_Order__c= mainContr.workJob.Shop_Work_Order__c;
            // Moddified as per story# 64030 start 
            //worecord.Application__c= mainContr.workJob.Application__c;
            worecord.Application_Desc__c = mainContr.filterApplication;
            //***** Venkat Added below Code for defect 134455(19/03) ******
            worecord.Email_check_box__c = mainContr.workJob.Email_check_box__c;
            worecord.CSS_Bms_ContactBoolean__c = mainContr.workJob.CSS_Bms_ContactBoolean__c;
            // Moddified as per story# 64030 end 
            if(mainContr.filterApplication != '' && mapDescriptionToCode != null) {
                appCode = mapDescriptionToCode.get(mainContr.filterApplication);
            }
            worecord.ApplicationCode__c = appCode;

            if(mainContr.workJob.Date_in_Shop__c!=null)
                worecord.Date_In__c = datetime.newInstance(mainContr.workJob.Date_in_Shop__c.year(), mainContr.workJob.Date_in_Shop__c.month(),mainContr.workJob.Date_in_Shop__c.day(),12,0,0);
            worecord.Date_in_Shop__c = mainContr.workJob.Date_in_Shop__c;
            //worecord.Previous_Status__c = mainContr.workJob.Status__c;
            //story# 105531 start
            if(mainContr.AppointmentName != '' && mainContr.AppointmentName == 'Yes') {
                worecord.Status__c='Appointment';
                worecord.IsAppointment__c = 'Yes';
            } else {
                worecord.Status__c='Intake';
                worecord.IsAppointment__c = 'No';
            }
            //story# 105531 end
            // Calling Unit Inbound Method     
            System.debug('createAccount Ended Here');
            if (mainContr.Wid == null) {
                //worecord.jobLocation__c=jobLocation;
                //start story 92895 setting location field based on the advace profile
                worecord.jobLocation__c = getLocationLabel(selectedLocation);
                worecord.CSS_Job_Location_Code__c = selectedLocation;
                //end story 92895
                System.debug('**Worecord** '+worecord);
                insert worecord;
                System.debug('**Worecord '+worecord);
                mainContr.Wid = worecord.id;
                System.debug('**Rajesh-worecord.id**'+worecord.id);            
                mainContr.Wid = worecord.id;
                System.debug('**Rajesh-Wid**'+ mainContr.Wid);
            } else {
                System.Debug('value of customer==== '+ mainContr.workJob.customer_name__c);
                worecord.id=mainContr.workJob.id;
                //start story 92895 setting location field based on the advace profile
                worecord.jobLocation__c = getLocationLabel(selectedLocation);
                worecord.CSS_Job_Location_Code__c = selectedLocation;
                //end story 92895
                update worecord;
                System.Debug('record updated====='+worecord);
            }
            PageReference pageRef = new pageReference('/apex/CG_IntakeCustomer?id='+worecord.id); 
            pageRef.setRedirect(true);
            return pageRef;
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - createAccount Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause()); 
            return null;
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
                //usrLoc  = 'testLoc';
                usrLoc  = '56270-56270';
            }
            System.debug('SelCountryCode '+ mainContr.filterCountry + ' SelectedStateCode '+ mainContr.filterState);
            //CustomerInboundRes = CSS_WS_BMS.callBMSCustInboundService(mainContr.workJob.Customer_Name__c, mainContr.workJob.Address__c, '', '', mainContr.workJob.Phone_Number__c.substring(1,4), mainContr.workJob.Phone_Number__c.substring(6,14), mainContr.workJob.City__c, filterState, mainContr.workJob.ZipCode__c, '', css_utility.getSubStringValue(mainContr.workJob.First_Name__c, 0, 15) + css_utility.getSubStringValue(mainContr.workJob.BMS_Last_Name__c, 0, 15), filterCountry, 'en', primarySgmntCD, usrLoc);
            CG_OP_OAGWrapper outputWrapper = CG_BL_Intake.createBMSAccount(mainContr.workJob.Customer_Name__c, mainContr.workJob.Address__c, '', '', mainContr.workJob.Phone_Number__c.substring(1,4), mainContr.workJob.Phone_Number__c.substring(6,14), mainContr.workJob.City__c, mainContr.filterState, mainContr.workJob.ZipCode__c, '', css_utility.getSubStringValue(mainContr.workJob.First_Name__c, 0, 15) + css_utility.getSubStringValue(mainContr.workJob.BMS_Last_Name__c, 0, 15), mainContr.filterCountry, 'en', primarySgmntCD, usrLoc);

            CustomerInboundRes = (CSS_CustomerInboundJSON2APEX )JSON.deserializeStrict(outputWrapper.response.getBody(),CSS_CustomerInboundJSON2APEX.class);
            system.debug('sj>>>>'+CustomerInboundRes.Header +'*************'+CustomerInboundRes );
            if(CustomerInboundRes.Header.Status=='SUCCESS') {
                BMScrAcFlag=true;
                mainContr.workJob.Customer_Code__c = CustomerInboundRes.DataArea.CustomerCode;
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
    
            BMSCustSearchPopup=false; 
        String invalidCountryStateVal;
        try {
            if(selectedCustCode != null && selectedCustCode != '') {
                system.debug('selectedCustCode: '+paginatedCustDetails);
                if (paginatedCustDetails != null && !paginatedCustDetails.isEmpty()) {
                    system.debug('testing purpose');
                    for(CSS_customerOutboundJSON2Apex.DataArea dt:paginatedCustDetails){
                        system.debug('inside Loop: '+dt.CustomerCode);
                        if(selectedCustCode == dt.CustomerCode ) { 
                            //Added if condition for defect 108703
                            if (dt.country!=null && dt.country!='' && dt.State!=null && dt.State!=''){
                                    //mainContr.strCntryState
                                 invalidCountryStateVal = css_utility.getStateDesc(dt.country,dt.State);
                                 
                                if(invalidCountryStateVal == system.label.CSS_State_and_Country_Error){
                                    prErrorFlag = true;
                                    showPRErrorMessage = system.label.CSS_Invalid_Guidanz_Country_and_State;
                                    break;
                                }else{
                                    mainContr.strCntryState = css_utility.getStateDesc(dt.country,dt.State);
                                }
                             }
                            
                        }
                    } 
                }
            }
            system.debug('prErrorFlag'+prErrorFlag);
            system.debug('showPRErrorMessage '+showPRErrorMessage);
        } catch(Exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - selectedCustDetails Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());            
        }

    }


}