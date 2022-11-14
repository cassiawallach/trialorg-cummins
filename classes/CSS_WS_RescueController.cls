Public Without Sharing Class CSS_WS_RescueController{

    Public CSS_WS_Rescue__c CurrentRescue { get; set; } 
    Public Id rescueSelectedRowId { get; set; }
    Public ApexPages.StandardController stdController;   
    Public Map <String, Integer> partsMap = new Map<String, Integer>();
    Public List<CreateNewPart> PartList { get; set; }
    Public List<Attachment> rescue_attachment_list { get; set; }
    Public List<SelectOption> PromotionIDsList { get; set; }
    Public List<SelectOption> GetComponentList { get; set; } 
    Public Id wId { get { return System.currentPageReference().getParameters().get('Id'); } set; }
    Public String PointUnit { get; set; }
    Public String CoverageUnit { get; set; }
    Public String ESNR { get; set; }
    Public String partNumber { get; set;}
    Public String LogInVariable { get; set; }    
    Public String description { get; set;}
    Public String OldPartNum { get; set; }
    Public String isClone { get; set; }
    Public String TabInFocus { get; set; }
    Public Integer PartToDelete { get; set; }
    Public Integer PartToUpdate { get; set; }
    Public Integer counter { get; set; }
    Public Integer AbbreviateNumber = 45;   
    Public Integer PartCounter = 1;
    Public Integer SavedPartCount = 0;
    Public Decimal quantity { get; set; }
    Public Decimal diffDate { get; set; }
    Public Decimal diffTime { get; set; }
    Public Decimal KmsPrice { get; set; }
    Public Decimal HrsPrice { get; set; }
    Public Decimal DayPrice { get; set; }
    Public Decimal NightPrice { get; set; }
    Public Decimal CurrencyPrice { get; set; }
    Public Boolean showGeneralData { get; set; }
    Public Boolean renderPartsSection { get; set; }
    Public Boolean editable_Brand { get; set; }   
    Public Boolean customerDis { get; set; }
    Public Integer manufacturerDis { get; set; }
    Public Boolean modelSeriesDis { get; set; }
    Public Boolean engineAppDis { get; set; }
    Public Boolean disableGeneralDataTab { get; set; } 
    Public Boolean disableBitacoraTab { get; set; }  
    Public Boolean disableMinimumFareTab { get; set; } 
    Public Boolean disableServiceDetailTab { get; set; }
    Public Boolean warrantyStartDateFlag { get; set; }
    Public Boolean distributorsDisable { get; set; }
    Public Boolean dealersDisable { get; set; }    
    Public Boolean ServiceDetailError = false;
    Public Date D1 { get; set; }
    Public Date D2 { get; set; }
    Public Boolean isDRRegion { get; set; }
    Public Map<String, String> group_region { get; set;}
    
    Public Double timeOffset{
        get{
            TimeZone tz = UserInfo.getTimeZone();
            return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
        }
    }
       
    Public CSS_WS_RescueController(ApexPages.StandardController controller){
        System.debug('Inicio CSS_WS_RescueController ****** CSS_WS_RescueController');
        this.Rescue = (CSS_WS_Rescue__c)controller.getRecord();
        this.stdController = stdController;
        Id id = ApexPages.currentPage().getParameters().get('id');
        IsClone = ApexPages.currentPage().getParameters().get('clone');
        Decimal IsRescueCloned = 0;
        if(id != null){
            IsRescueCloned = [SELECT Is_Clone__c FROM CSS_WS_Rescue__c WHERE Id =: this.Rescue.Id].Is_Clone__c;
        }
        this.rescueAttachment();
        if(this.Rescue.id != null){
            this.getPromotionIDs();
        }
        //get list of groups where current user is part of
        this.group_region = this.getSPCodeMapRegion();
        if(this.group_region.IsEmpty()){
            this.isDRRegion = false;
        } else {
            this.isDRRegion = true;
        }
        if(IsClone != '1'){
            if(id == null || IsRescueCloned == 1){
                showGeneralData = true;
                getDistributorsSelectList();
                this.Rescue.CSS_WS_Capturer_Name__c = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
                //this.Rescue.CSS_WS_Service_Provider_DR__c = UserInfo.
                customerDis = false;
                this.Rescue.CSS_WS_FailureIsProductProblem__c = 'Yes';
                manufacturerDis = 0;
                modelSeriesDis = false;
                engineAppDis = false;
                disableGeneralDataTab = False;
                disableBitacoraTab = True;  
                disableMinimumFareTab = True;  
                disableServiceDetailTab = True;
                if(IsRescueCloned == 1){
                    this.GetESN();
                }
                SetComponentList();
            } else {//Edit mode  
                showGeneralData = false;
                disableBitacoraTab = False;
                TabInFocus = 'BitacoraTab'; 
                disableGeneralDataTab = True;
                disableMinimumFareTab = True;  
                disableServiceDetailTab = True;
            }
            this.getSPList(); 
            this.SetRates();
            counter = 0;
            if (This.Rescue != NULL) {
               //This.renderPartsSection=(Rescue.CSS_WS_SparePartsUsage__c=='Yes') ? true : false;
            }
            this.CurrentRescue = (CSS_WS_Rescue__c)controller.getRecord();       
            this.partNumber = '';
            this.quantity = 1;
            this.description = ''; 
            this.PartList = new List<CreateNewPart>();
            wId = (this.CurrentRescue.Id != NULL) ? this.CurrentRescue.Id : wId;
            if(wId != null){           
                List<CSS_WS_Rescue_Parts__c> SavedParts = 
                    [SELECT Id, CSS_WS_Part_ID__c, CSS_WS_Quantity__c, CSS_WS_Description__c, Rescue_Id__c FROM CSS_WS_Rescue_Parts__c WHERE Rescue_Id__c =: wId];            
                SavedPartCount = SavedParts.size();            
                if(SavedPartCount > 0){               
                    for(Integer i = 0; i < SavedPartCount; i++) {                    
                        this.partNumber = SavedParts[i].CSS_WS_Part_ID__c;
                        this.quantity = SavedParts[i].CSS_WS_Quantity__c;
                        this.description = SavedParts[i].CSS_WS_Description__c;                    
                        this.AddNewPart();
                    }                
                } else {                
                    this.PartList.add(new CreateNewPart(This.PartCounter++, this.partNumber, this.quantity, this.description, wId));
                }
            }
        }
    }
    
    Public Class CreateNewPart{
        Public CSS_WS_Rescue_Parts__c Part { get; set; }
        Public Integer Index { get; set; }
        Public CreateNewPart(Integer Index, String partNumber, Decimal quantity, String description, Id RescueId){
            this.Index = Index; 
            partNumber = (partNumber == null) ? '' : partNumber;
            quantity = (quantity == null) ? 1 : quantity;
            description = (partNumber == null) ? '' : description; 
            this.Part = new CSS_WS_Rescue_Parts__c(CSS_WS_Part_ID__c = partNumber, CSS_WS_Quantity__c = quantity,
                CSS_WS_Description__c = description, Rescue_Id__c = RescueId);
        }       
    }
    
    Public CSS_WS_Rescue__c Rescue{
        get{
            if(Rescue == null)
                Rescue = new CSS_WS_Rescue__c();                
            return Rescue;
        }
        set;
    }        
    
    Public CSS_WS_Engine_Application_Code__c mapEngineApplication(String engineApplicationCodeStr){
        try {
            CSS_WS_Engine_Application_Code__c engineApplicationCode = [SELECT Name, Application_Description__c, Default_Measurement__c, 
                Automotive_Flag__c, Marine_Flag__c FROM CSS_WS_Engine_Application_Code__c WHERE Application_Description__c = :engineApplicationCodeStr];
            return engineApplicationCode;
        } catch (Exception e){
            return null;
        }
    }
    
    Public List<SelectOption> getEngineApplications(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', Label.CSS_WS_Selection_None));
        //Find all the countries in the custom setting
        Map<String, CSS_WS_Engine_Application_Code__c> codes = CSS_WS_Engine_Application_Code__c.getAll();
        //Sort them by name
        List<String> codesName = new List<String>();
        codesName.addAll(codes.keySet());
        codesName.sort();
        //Create the Select Options.
        for(String codeName : codesName){
            CSS_WS_Engine_Application_Code__c code = codes.get(codeName);
            options.add(new SelectOption(code.Name, String.valueOf(code.Application_Description__c).abbreviate(20)));
        }
        return options;
    }        
        
    Public List<SelectOption> getFailureList{
        get{
            List<selectOption> Options = new List<selectOption>();
            Options.add(new SelectOption('', Label.CSS_WS_Selection_None));
            if(this.Rescue.CSS_WS_Engine_Family_Code__c != null ){
                CSS_WS_Failure_Master__c [] failures = [SELECT Engine_System_Code__c, Engine_System_Code_Description__c FROM CSS_WS_Failure_Master__c
                    WHERE Engine_Family_Code__c =:this.Rescue.CSS_WS_Engine_Family_Code__c 
                    AND Engine_System_Code__c != '' AND Engine_System_Code_Description__c != '' ORDER BY Engine_System_Code__c];
                Map<String,CSS_WS_Failure_Master__c> mapFailureBySC = new Map<String,CSS_WS_Failure_Master__c>();
                for(CSS_WS_Failure_Master__c failure: failures){
                    mapFailureBySC.put(failure.Engine_System_Code__c, failure);
                }
                for( CSS_WS_Failure_Master__c failure: mapFailureBySC.values()){
                    if(mapFailureBySC.size() >= 999) break;
                    Options.add(new SelectOption(failure.Engine_System_Code__c + '&' +failure.Engine_System_Code_Description__c,
                        String.valueof(failure.Engine_System_Code__c + ' - ' + failure.Engine_System_Code_Description__c).abbreviate(this.AbbreviateNumber)));
                }
            }
            return Options;
        }
        set;
    }
    
    Public List<SelectOption> getFailureModeList{        
        get{
            List<selectOption> Options = new List<selectOption>();
            Options.add(new SelectOption('',Label.CSS_WS_Selection_None));
            CSS_WS_Fail_Mode_Catalog__c [] failModes = [SELECT CSS_WS_Name__c, CSS_WS_FailMode__c FROM CSS_WS_Fail_Mode_Catalog__c 
                WHERE CSS_WS_FailMode__c != null AND CSS_WS_Active__c =: 'Y' ORDER BY CSS_WS_FailMode__c LIMIT 999];
            for(CSS_WS_Fail_Mode_Catalog__c failMode: failModes){
                Options.add(new SelectOption(failMode.CSS_WS_FailMode__c + '&' + failMode.CSS_WS_Name__c,
                    String.valueof(failMode.CSS_WS_FailMode__c + ' - ' + failMode.CSS_WS_Name__c).abbreviate(this.AbbreviateNumber)));
            }
            return Options;
        } 
        set;
    }
    
    Public List<SelectOption> getManufacturerSelectList(){
    //Generates manufacturer dropdown from manufacturer settings
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', Label.CSS_WS_Selection_None));    
        AggregateResult[] manufacturers = [SELECT CSS_WS_Make__c FROM CSS_WS_Make_And_Model__c WHERE CSS_WS_Engine_Family_Code__c = :this.Rescue.CSS_WS_Engine_Family_Code__c AND CSS_WS_Status__c = 'ACTIVE' GROUP BY CSS_WS_Make__c];       
        for(AggregateResult manufacturer : manufacturers){
            options.add(new SelectOption((String)manufacturer.get('CSS_WS_Make__c'), (String)manufacturer.get('CSS_WS_Make__c')));
        }
        for(AggregateResult m : manufacturers){
            if(manufacturerDis == 1){
                if(m.get('CSS_WS_Make__c') == this.Rescue.CSS_WS_Manufacturer__c){//Rule RR-13              
                    manufacturerDis++;
                    break;
                }
            } else if(manufacturerDis != 2){
                manufacturerDis = 0;
                break;
            }
        }  
        if(this.Rescue.CSS_WS_Engine_Serial_Number__c == '10000000'){
            options.add(new SelectOption('Unlisted', 'Unlisted'));//Add label
            this.Rescue.CSS_WS_Manufacturer__c = 'Unlisted'; 
        }
        return options;
    }
    
    Public List<SelectOption> getModelSeriesSelectList(){
        //To generate the model series picklist based on the manufacturer selected by user.
        List<SelectOption> options = new List<SelectOption>();        
        List <CSS_WS_Make_And_Model__c> mSeries = new List <CSS_WS_Make_And_Model__c>();
        modelSeriesDis = false;
        try{
            mSeries = [SELECT CSS_WS_Model__c FROM CSS_WS_Make_And_Model__c WHERE CSS_WS_Make__c =: this.Rescue.CSS_WS_Manufacturer__c 
                       AND CSS_WS_Engine_Family_Code__c =: this.Rescue.CSS_WS_Engine_Family_Code__c AND CSS_WS_Status__c = 'ACTIVE' ORDER BY CSS_WS_Model__c];
        } catch(Exception e) {
            System.debug(e.getMessage());
        }                
        for(CSS_WS_Make_And_Model__c s : mSeries){
            if (s.CSS_WS_Model__c == this.Rescue.CSS_WS_Model_Series__c){//Rule RR-14
                modelSeriesDis = true;
                break;
            }
        }
        //Generate the Select Options based on the final sorted list
        options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        for(CSS_WS_Make_And_Model__c mS : mSeries) {
            options.add(new SelectOption(mS.CSS_WS_Model__c, mS.CSS_WS_Model__c));
        }
        if(this.Rescue.CSS_WS_Engine_Serial_Number__c == '10000000'){
            options.add(new SelectOption('All', 'All'));//Add label  
            this.Rescue.CSS_WS_Model_Series__c = 'All';
        }
        return options;
    }
    
    Public List<SelectOption> getDistributorsSelectList(){
        List<SelectOption> distributors = new List<SelectOption>();
        distributors.add(new SelectOption('',Label.CSS_WS_Selection_Distributor));
        List<Account> distributorAccounts = new List<Account>();
        distributorAccounts = [SELECT Account.Name, Account.CSS_DBCode__c, Account.IAM_Service_Provider_Code__c FROM Account WHERE (Account.Type = 'Distributor Account' OR 
                        Account.Type = 'Distributor Branch Account') AND Account.BillingCountry = 'Mexico' AND 
                        (IAM_Service_Provider_Code__c = '56153' OR IAM_Service_Provider_Code__c = '54699' OR IAM_Service_Provider_Code__c = '54809' OR IAM_Service_Provider_Code__c = '55910' 
                        OR IAM_Service_Provider_Code__c = '04734' OR IAM_Service_Provider_Code__c = '54700' OR IAM_Service_Provider_Code__c = '55108' OR IAM_Service_Provider_Code__c = '56155' 
                        OR IAM_Service_Provider_Code__c = '74798' OR IAM_Service_Provider_Code__c = '54681' OR IAM_Service_Provider_Code__c = '73011' OR IAM_Service_Provider_Code__c = '54665' 
                        OR IAM_Service_Provider_Code__c = '56092' OR IAM_Service_Provider_Code__c = '54701' OR IAM_Service_Provider_Code__c = '40711' OR IAM_Service_Provider_Code__c = '00863' 
                        OR IAM_Service_Provider_Code__c = '54734') AND CMI_Account_Status__c = 'Active' ORDER BY Account.Name];
        
        // Validation to populate the "Distributors" options in Claim format when a DR Region is logged in
        if (this.isDRRegion){
            for(Account distributor : distributorAccounts ){
                if (this.group_region.containsKey(distributor.IAM_Service_Provider_Code__c)){
                    distributors.add(new SelectOption((String)distributor.IAM_Service_Provider_Code__c, (String)distributor.Name));
                }
            }
        } else {
            for(Account distributor : distributorAccounts ){
                if((String)distributor.Name != 'PACCAR PARTS MEXICO'){
                    distributors.add(new SelectOption((String)distributor.IAM_Service_Provider_Code__c, (String)distributor.Name));
                }
            }
        }
        
        return distributors;
    }
     
    Public List<SelectOption> getDealersSelectList(){
        Integer dis = 0;
        List<SelectOption> dealers = new List<SelectOption>();
        dealers.add(new SelectOption('', Label.CSS_WS_Selection_Dealer));
        List<Account> dealerAccounts = new List<Account>();
        if(!String.isEmpty(this.Rescue.CSS_WS_Service_Provider_DR__c)){
            dealerAccounts = [SELECT Name, IAM_Service_Provider_Code__c, CSS_DBCode__c FROM Account WHERE 
                              CSS_DBCode__c =: this.Rescue.CSS_WS_Service_Provider_DR__c AND (type = 'Dealer Account' OR 
                              type = 'Distributor Account' OR type = 'Dealer Branch Account' OR 
                              type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active' ORDER BY Name];

            for(Account dealer : dealerAccounts){
                if(dealer.IAM_Service_Provider_Code__c != null && dealer.Name  != null){
                    dealers.add(new SelectOption((String)dealer.IAM_Service_Provider_Code__c, (String)dealer.Name));
                }
            }
        }
        return dealers;
    }

    Public Static String dateToString(DateTime dateToConvert, String format){
        String dateConverted = '';
        if(dateToConvert != null){
            DateTime dtDate = DateTime.newInstance(dateToConvert.year(),dateToConvert.month(),dateToConvert.day());
            dateConverted = dtDate.format(format);
        }
        return dateConverted;
    }
    
    Public Static String dateToString(Date dateToConvert, String format){
        String dateConverted = '';
        if(dateToConvert != null){
            DateTime dtDate = DateTime.newInstance(dateToConvert.year(),dateToConvert.month(),dateToConvert.day());
            dateConverted = dtDate.format(format);
        }
        return dateConverted;
    }
    
    Public Static Date stringToDate(String dateToConvert, String format){
        if(String.isEmpty(dateToConvert) || String.isEmpty(format)) return null;
        String[] str = null;
        String[] dates = null;
        Integer year = 0;
        Integer month = 0;
        Integer day = 0;   
        if(format == 'YYYY-MM-DDTHH:MM:SS'){
            str = dateToConvert.split('T');
            if(str != null){
                dates = str[0].split('-');
                if(dates != null){
                    year = Integer.valueof(dates[0]);
                    month = Integer.valueof(dates[1]);
                    day = Integer.valueof(dates[2]);
                }
            }
        }
        if(format == 'YYYY-MM-DD'){
            dates = dateToConvert.split('-');
            if(dates != null){
                year = Integer.valueof(dates[0]);
                month = Integer.valueof(dates[1]);
                day = Integer.valueof(dates[2]);
            }
        }
        if(dates != null){
            return Date.newInstance(year, month, day);
        }  
        return null;
    }
    
    Public PageReference reloadEngineApplication(){
        try{
            CSS_WS_Engine_Application_Code__c code = [SELECT Application_Description__c, Default_Measurement__c
                FROM CSS_WS_Engine_Application_Code__c WHERE Name = :this.rescue.CSS_WS_Engine_Application_Code__c];
            this.rescue.CSS_WS_Failure_Measure__c = code.Default_Measurement__c;//Rule RR-15, RR-16, RR-17 and RR-18
            this.rescue.CSS_WS_Engine_Application__c = code.Application_Description__c;
            yearsInService();
        } catch(Exception e) {
            this.rescue.CSS_WS_Failure_Measure__c = '';
            this.rescue.CSS_WS_Engine_Application__c = '';
            System.debug('Error: ' + e.getMessage());
        }
        return null;
    }

    Public PageReference saveGeneralData(){
        try{
            if(this.ValidateRequiredFields('header') == 0){
                this.Rescue.Is_Clone__c = 0;
                if(Rescue.CSS_WS_Charged_To__c != null){ 
                    if(Rescue.CSS_WS_Charged_To__c.toUpperCase() == 'CLIENTE' || Rescue.CSS_WS_Charged_To__c.toUpperCase() == 'CUSTOMER'){//Rule RR-34
                        Rescue.CSS_WS_SignalBy__c = 'Customer';
                    }
                }                
                this.getCoverageInfo();                                 
                if( String.isEmpty(this.Rescue.CSS_WS_Access_Code__c) ){
                    List<CSS_WS_Make_And_Model__c> code = [SELECT CSS_WS_Access_Code__c FROM CSS_WS_Make_And_Model__c
                        WHERE CSS_WS_Engine_Family_Code__c =: this.Rescue.CSS_WS_Engine_Family_Code__c AND CSS_WS_Make__c =: this.Rescue.CSS_WS_Manufacturer__c
                        AND CSS_WS_Model__c =: this.Rescue.CSS_WS_Model_Series__c AND CSS_WS_Status__c = 'ACTIVE' LIMIT 1];
                    if(code.size() > 0){
                        this.Rescue.CSS_WS_Access_Code__c = code[0].CSS_WS_Access_Code__c;
                    }
                }                
                this.Rescue.CSS_WS_Service_Provider_Name_DR__c = getSpName(this.rescue.CSS_WS_Service_Provider_DR__c, 'DR');
                this.Rescue.CSS_WS_Service_Provider_Name_Dealer__c = getSpName(this.rescue.CSS_WS_Service_Provider_Dealer__c, 'DLR');
                upsert this.Rescue;
                PageReference rescuePage = new ApexPages.StandardController(this.Rescue).edit(); 
                rescuePage.setRedirect(true); 
                return rescuePage; 
            }
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            system.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveGeneralDataDisabled(){
        disableGeneralDataTab = true;          
        TabInFocus='BitacoraTab'; 
        disableBitacoraTab = false; 
        return null;
    }
    
    Public PageReference saveBitacora(){   
        try {
            GetResponseTime();
            GetRepairingTime();
            GetRescueTotalTime();
            GetSignalBy();
            if(ValidateBitacoraFields() == true){
                validateStartingSignalTime();
                //RR35RR36RR37();
                //Insert Rescue with the values of this section
                update Rescue;
                disableMinimumFareTab=False;
                TabInFocus='MinimumFareTab'; 
                disableBitacoraTab=True;
                return null;             
            } else {
                return null;
            }
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            system.debug('Error: '+e.getMessage());
            return null;
        }
    }   
    
    Public PageReference saveMinimumFare(){
        try{
            //Insert the Rescue with the values of this section     
            if(this.Rescue.Towing_Flag__c){
                if(this.Rescue.CSS_WS_Towing_Amount_MXN__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E054));//Towing Amount is necessary
                    return null;
                }
            } else {
                this.Rescue.CSS_WS_Towing_Amount_MXN__c = 0.0;
            }        
            if(this.Rescue.CSS_WS_Towing_Amount_MXN__c <> 0.0 && this.Rescue.CSS_WS_Crane_Justification__c == null){//Rule RR-39
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.CSS_WS_Rescue_E055));//Crane Justification is necessary
                return null;
            }
            if(this.Rescue.CSS_WS_Towing_Amount_MXN__c <> 0.0 && this.Rescue.CSS_WS_Authorizer__c == null){//Rule RR-40
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.CSS_WS_Rescue_E056));//Authorized by is necessary
                return null;
            }            
            if(this.Rescue.CSS_WS_SignalTime__c == null || this.Rescue.CSS_WS_SignalTime__c == '' || this.Rescue.CSS_WS_SignalBy__c == '' || this.Rescue.CSS_WS_SignalBy__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Rescue_E044));//Signal Time and Signal by is necessary
                return null;
            }      
            upsert Rescue;
            disableServiceDetailTab=False;
            TabInFocus='ServiceDetailTab'; 
            disableMinimumFareTab=True;
            return null;            
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            system.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveRescue(){
        try{
            if(ValidateServiceDetailSection()){
                this.clearHiddenFields();
                this.PromotionIDInformation();
                GetRescueTotalCost();
                if(!String.isEmpty(Rescue.CSS_WS_FailureIsProductProblem__c)){
                    if(Rescue.CSS_WS_FailureIsProductProblem__c == 'No'){
                        this.Rescue.CSS_WS_Charged_To__c = 'Cliente';            
                    } else {
                        RR02RR04(); 
                    }
                }
                update rescue;
                PageReference rescuePage = new ApexPages.StandardController(this.Rescue).view(); 
                rescuePage.setRedirect(true); 
                return rescuePage; 
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            System.debug(e.getMessage());
        }
        return null;
    }
    
    Public PageReference backBitacora(){
        try{
            List<CSS_WS_Rescue__c> temEFC = [SELECT CSS_WS_Engine_Family_Code__c FROM CSS_WS_Rescue__c WHERE Id =: wId];
            this.rescue.CSS_WS_Engine_Family_Code__c = String.isEmpty(temEFC[0].CSS_WS_Engine_Family_Code__c) ? '' : temEFC[0].CSS_WS_Engine_Family_Code__c;
            //Flags to redirect the correct tab
            disableBitacoraTab = true; 
            TabInFocus='GeneralDataTab'; 
            disableGeneralDataTab = false;
            SetComponentList();
            return null;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            system.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference backMinimumFare(){
        try{
            //Update the claim with the values of this section      
            update rescue;
            //Flags to redirect the correct tab
            disableBitacoraTab=False;
            TabInFocus='BitacoraTab'; 
            disableMinimumFareTab=True;
            return null;
        } catch(System.DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            system.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference backServiceDetail(){
        try{
            //Update the claim with the values of this section      
            update rescue;
            //Flags to redirect the correct tab
            disableMinimumFareTab=False;
            TabInFocus='MinimumFareTab'; 
            disableServiceDetailTab=True;
            return null;
            
        } catch(System.DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            system.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference reviewRescue(){
        Rescue.CSS_WS_RescueStatus__c = 'Draft';
        upsert Rescue; 
        Pagereference pg = new Pagereference('/' + Rescue.Name);
        pg.setredirect(true);
        return pg;
    }
    
    Public PageReference savePartsGrids(){
        try{
            List<CSS_WS_Rescue_Parts__c> ListToInsert = new List<CSS_WS_Rescue_Parts__c>();
            Decimal totalQuantity = 0;
            for(CreateNewPart Part : this.PartList){
                if(Part.Part.CSS_WS_Part_ID__c  != ''){
                    if(Part.Part.CSS_WS_Quantity__c > 0){
                        totalQuantity += Part.Part.CSS_WS_Quantity__c;
                        Part.Part.Id = null;
                        ListToInsert.add(Part.Part);
                    } else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Rescue_E023));//Quantity should be more than 0
                        this.ServiceDetailError = true;
                        break;
                    }
                }
            }
            if(totalQuantity <= 25){
                if(this.ServiceDetailError == false){
                    delete [SELECT Id FROM CSS_WS_Rescue_Parts__c WHERE Rescue_Id__c = :wId];
                    insert ListToInsert;
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Rescue_E052));//You cannot add more than 25 parts
                this.ServiceDetailError = true;
            }
        } catch(Exception e){
            System.debug('Error: ' + e.getMessage());
        }
        return null;
    }
    
    Public PageReference getPartsInfo(){ 
        String JSONValues;
        try{
            Integer partPosToUpdate = findPartIndex(this.PartToUpdate);
            if(partPosToUpdate == -1){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, Label.CSS_WS_Global_E001));
                return null;
            }
            if(this.PartList[partPosToUpdate].Part.CSS_WS_Part_ID__c == '' || this.PartList[partPosToUpdate].Part.CSS_WS_Part_ID__c  == null){
                EmptyValues(this.PartList[partPosToUpdate].Part);
                if(partsMap.containsKey(OldPartNum)){
                    partsMap.remove(OldPartNum);
                }
                return null;
            }
            CSS_WS_J2A_GetPartsData response = CSS_WS_GetWebServiceData.getPartsData(this.PartList[partPosToUpdate].Part.CSS_WS_Part_ID__c );
            System.debug (response);  
            if (response == null){
                JSONValues = 'NULL';
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_Rescue_E046));//There is a connectivity problem
            } else if (response.Header.Status.toUpperCase() == 'SUCCESS'){
                this.description = response.DataArea.PartDescription;
                if(UpdatePart()){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_Rescue_E049));//You cannot enter a repeated part
                    return null;
                }
                JSONValues = JSON.serialize(response.DataArea);
            } else if(response.Header.Status.toUpperCase() == 'ERROR'){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_Rescue_E057));//Part not exist or is incorrect
            }  
        } catch(exception e){
            System.debug('Error: '+e.getMessage());
            css_utility.LogOutIntError(JSONValues, 'CSS Error:' + e.getMessage(),'','WS_GetPartsData_Integration');
        }
        return null;
    }
    
    Public PageReference getRouter(){
        PageReference p;
        String IsClone = ApexPages.currentPage().getParameters().get('clone');
        if(this.Rescue.Id != null) {
            if(IsClone == '1'){
                CSS_WS_Rescue__c RescueToClone = [
                    SELECT
                        CSS_WS_Service_Provider_DR__c,
                        CSS_WS_Service_Provider_Dealer__c,
                        CSS_WS_Capturer_Name__c,
                        CSS_WS_Charged_To__c,
                        CSS_WS_CoordinatedBy__c,
                        CSS_WS_Before_In_Service__c,
                        CSS_WS_Engine_Serial_Number__c,
                        CSS_WS_Manufacturer__c,
                        CSS_WS_Model_Series__c,
                        CSS_WS_Customer_Name_Internal__c,
                        CSS_WS_Engine_Application_Code__c,
                        CSS_WS_Service_Model__c,
                        CSS_WS_Failure_Point_Quantity__c,
                        CSS_WS_Warranty_Start_Date__c,
                        CSS_WS_Failure_Measure__c,
                        CSS_WS_ServiceRequest__c,
                        CSS_WS_Years_In_Service__c,
                        CSS_WS_Engine_System__c,
                        CSS_WS_Component__c,
                        CSS_WS_Failure_Mode__c,
                        CSS_WS_AccCoverage__c
                    FROM CSS_WS_Rescue__c
                    WHERE Id =: this.Rescue.Id
                ];
                RescueToClone.CSS_WS_RescueStatus__c = 'Draft';
                RescueToClone.Is_Clone__c = 1;
                RescueToClone.Id = null;
                insert RescueToClone;
                PageReference claimPage = new ApexPages.StandardController(RescueToClone).edit();
                claimPage.setRedirect(true); 
                return claimPage;
            } else {
                if(system.approval.isLocked(this.Rescue.Id) != true){  
                    p = NULL;
                } else {
                    String profileName='';
                    CSS_WS_Rescue__c approverId;
                    String userId = System.userinfo.getUserId();
                    if(userId != null){
                        profileName = [SELECT Profile.Name FROM User WHERE Id =: userId limit 1].Profile.Name;
                        approverId = [SELECT CreatedBy.Community_Approver__c FROM CSS_WS_Rescue__c WHERE id = :this.rescue.id LIMIT 1];
                    }
                    //System.debug('approver Id ->' +approverId.CreatedBy.Community_Approver__c + ' , user logged in ->' + userId);
                    //if(profileName == 'CSS_WS_Factory_Warranty_Manager' || profileName == 'CSS_WS_Factory_Warranty_Manager_2' || profileName == 'System Admin' || profileName == 'fAdministrator' || userId == String.valueOf(approverId.CreatedBy.Community_Approver__c)){
                    if(getPermissionSet('CSS_WS_Factory_Warranty_Manager') || getPermissionSet('CSS_WS_Factory_Warranty_Manager_2') || profileName == 'System Admin' || profileName == 'fAdministrator' || userId == String.valueOf(approverId.CreatedBy.Community_Approver__c)){
                        p = NULL;
                    } else {
                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL,Label.CSS_WS_Global_E002);//Record is Locked
                        ApexPages.addMessage(errorMsg);
                        PageReference pageRef = Page.CSS_WS_Locked_record;
                        pageRef.setRedirect(true);
                        return pageRef;
                    }
                }
            }
            return p;
        }
        return null;
    }
    
    Public String getSpName(String spCode, String accType){
        Account sp = new Account();
        try {
            if(accType.toUpperCase() == 'DR'){
                sp = [SELECT Account.Name FROM Account WHERE IAM_Service_Provider_Code__c = :spCode AND (Account.Type = 'Distributor Account' OR 
                        Account.Type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active' LIMIT 1];
            } else {
                sp = [SELECT Account.Name FROM Account WHERE IAM_Service_Provider_Code__c = :spCode AND (Account.Type = 'Dealer Account' 
                        OR Account.Type = 'Dealer Branch Account' OR Account.Type = 'Distributor Account' OR Account.Type = 'Distributor Branch Account') 
                        AND CMI_Account_Status__c = 'Active' ORDER BY Type LIMIT 1];    
            }
            return sp.Name;
        } catch (Exception e){
            System.debug(e.getMessage());
        }
        return null;
    }
    
    Public Integer validateRequiredFields(String TabToValdiate){
        List<String> RequiredFieldsList = new List<String>();
        List<String> FailureMessageList = new List<String>();        
        if(TabToValdiate == 'header'){
            RequiredFieldsList.add(this.Rescue.CSS_WS_Service_Provider_DR__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Service_Provider_Dealer__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_CoordinatedBy__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Engine_Serial_Number__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Manufacturer__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Service_Model__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Model_Series__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Engine_Application__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Customer_Name_Internal__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Failure_Point_Quantity__c);
            RequiredFieldsList.add(String.valueOf(this.Rescue.CSS_WS_ServiceRequest__c));
            RequiredFieldsList.add(this.Rescue.CSS_WS_Failure_Measure__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Engine_System__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Component__c);
            RequiredFieldsList.add(this.Rescue.CSS_WS_Failure_Mode__c);
            
            FailureMessageList.add(Label.CSS_WS_Rescue_E034);//'Service Provider (DR) field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E032);//'Service Dealer (Dealer) field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E004);//'Cordinated by field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E007);//'Engine Serial Number field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E018);//'Manufacturer field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E033);//'Service Model field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E020);//'Model Series field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E006);//'Engine Application field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E005);//'Customer Name field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E014);//'Failure Point Quantity field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E038);//'Service Request field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E010);//'Failure Measure field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E008);//'Engine System field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E002);//'Component field is required'
            FailureMessageList.add(Label.CSS_WS_Rescue_E011);//'Failure Mode field is required'
            if(this.Rescue.CSS_WS_Before_In_Service__c == false){
                RequiredFieldsList.add(String.valueOf(this.Rescue.CSS_WS_Warranty_Start_Date__c));
                FailureMessageList.add(Label.CSS_WS_Rescue_E050);//'Warranty Start Date field is required'
                RequiredFieldsList.add(String.valueOf(this.Rescue.CSS_WS_Years_In_Service__c));
                FailureMessageList.add(Label.CSS_WS_Rescue_E051);//'Years In Service field is required'
            }
        } else if(TabToValdiate == 'details'){ 
            RequiredFieldsList.add(this.Rescue.CSS_WS_FailurePlace__c);
            FailureMessageList.add(Label.CSS_WS_Rescue_E012);//'Failure Place field is required'
            RequiredFieldsList.add(this.Rescue.CSS_WS_RoadSection__c);
            FailureMessageList.add(Label.CSS_WS_Rescue_E029);//'Road Section field is required'
            RequiredFieldsList.add(this.Rescue.CSS_WS_ReportedFailure__c);
            FailureMessageList.add(Label.CSS_WS_Rescue_E028);//'Reported Failure field is required'
            RequiredFieldsList.add(this.Rescue.CSS_WS_TechnicalCause__c);
            FailureMessageList.add(Label.CSS_WS_Rescue_E039);//'Technical Cause field is required'
            RequiredFieldsList.add(this.Rescue.CSS_WS_TecnhicalCorrection__c);
            FailureMessageList.add(Label.CSS_WS_Rescue_E041);//'Technical Correction field is required'
            RequiredFieldsList.add(this.Rescue.CSS_WS_FailureIsProductProblem__c);
            FailureMessageList.add(Label.CSS_WS_Rescue_E009);//'Failure is Product Problem field is required'
            if(this.Rescue.CSS_WS_FailureIsProductProblem__c == 'Yes'){
                /*RequiredFieldsList.add(this.Rescue.CSS_WS_FailureRelatedTo__c);
                FailureMessageList.add(Label.CSS_WS_Rescue_E015);//'Failure Related To field is required'
                RequiredFieldsList.add(this.Rescue.CSS_WS_OtherObservation__c);
                FailureMessageList.add(Label.CSS_WS_Rescue_E021);//'Other Observation field is required'*/
                RequiredFieldsList.add(this.Rescue.CSS_WS_TechnicianPromotion__c);
                FailureMessageList.add(Label.CSS_WS_Rescue_E045);//'Technician Promotion field is required'
            }
            try{
                if(this.Rescue.CSS_WS_TotalRescueTime__c > 7){
                    RequiredFieldsList.add(this.Rescue.CSS_WS_ReasonNoTargetTime__c);
                    FailureMessageList.add(Label.CSS_WS_Rescue_E024);//'Reasons for no Target Time field is required'
                }
            } catch(Exception e) {
                System.debug(e.getMessage());
            }            
            try{
                if(this.Rescue.CSS_WS_ReasonNoTargetTime__c != null && this.Rescue.CSS_WS_ReasonNoTargetTime__c != ''){
                    if(this.Rescue.CSS_WS_ReasonNoTargetTime__c.indexOf('Other') != -1 || this.Rescue.CSS_WS_ReasonNoTargetTime__c.indexOf('Otra') != -1){
                        RequiredFieldsList.add(this.Rescue.CSS_WS_OtherSituation__c);
                        FailureMessageList.add(Label.CSS_WS_Rescue_E022);//'Other Situation field is required'
                    }
                }              
            } catch(Exception e) {
                System.debug(e.getMessage());
            }            
        }
        for(Integer i = 0; i < RequiredFieldsList.size(); i++){
            if(String.isEmpty(RequiredFieldsList[i])){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, FailureMessageList[i]));
                return 1;
            }
        }
        return 0;
    }
    
    Public Integer findPartIndex(Integer partIndexToFind){
        Integer ListSize = this.PartList.size();
        Integer indexFound = -1;
        for(Integer i = 0; i < ListSize; i++){
            if(this.PartList[i].Index == partIndexToFind){
                indexFound = i;
            }
        }
        return indexFound;
    }
    
    Public Decimal getHrsTravel(){
        this.Rescue.CSS_WS_TravelHoursRoundTrip__c = (this.Rescue.CSS_WS_TravelHoursRoundTrip__c != null && this.Rescue.CSS_WS_TravelHoursRoundTrip__c > 0.00) ? this.Rescue.CSS_WS_TravelHoursRoundTrip__c : 0.0;
        return this.Rescue.CSS_WS_TravelHoursRoundTrip__c / 2;      
    }
    
    Public Decimal durationTime(DateTime start_date_time, DateTime end_date_time){
        Integer start_year_as_int = start_date_time.year();//Grab the start year
        Integer start_day_as_int = start_date_time.dayOfYear();//Grab the start day
        Integer start_hour_as_int = start_date_time.hour();//Grab the start hour
        Integer start_minute_as_int = start_date_time.minute();//Grab the start minute
        Integer start_second_as_int = start_date_time.second(); //Grab the start second
        Integer start_in_seconds = (start_year_as_int * 31556926) + (start_day_as_int * 86400) + (start_hour_as_int * 3600) + (start_minute_as_int * 60) + (start_second_as_int * 1);//Convert the start date to a value in seconds
        Integer end_year_as_int = end_date_time.year();//Grab the end year
        Integer end_day_as_int = end_date_time.dayOfYear();//Grab the end day
        Integer end_hour_as_int = end_date_time.hour();//Grab the end hour
        Integer end_minute_as_int = end_date_time.minute();//Grab the end minute
        Integer end_second_as_int = end_date_time.second();//Grab the end second
        Integer end_in_seconds = (end_year_as_int * 31556926) + (end_day_as_int * 86400) + (end_hour_as_int * 3600) + (end_minute_as_int * 60) + (end_second_as_int * 1);//Convert the end date to a value in seconds
        Integer total_duration_in_seconds = end_in_seconds - start_in_seconds;//Duration in seconds
        Integer year_result = math.mod(math.floor(total_duration_in_seconds/31556926).intValue(),10000000);//Number of years
        Integer day_result = math.mod(math.floor(total_duration_in_seconds/86400).intValue(),365);//Number of days
        Integer hour_result = math.mod(math.floor(total_duration_in_seconds/3600).intValue(),24);//Number of hours
        Integer minute_result = math.mod(math.floor(total_duration_in_seconds/60).intValue(),60);//Number of minutes
        Integer second_result = math.mod(math.floor(total_duration_in_seconds/1).intValue(),60);//Number of seconds
        return (day_result * 24) + hour_result;
    }
    
    Public Boolean validateServiceDetailSection(){
        this.ServiceDetailError = false;
        try {
            this.ValidateRequiredFields('details');
        } catch (Exception e){
            System.debug(e.getMessage());
        }        
        try {
            this.CheckResponsableValue();
        } catch (Exception e){
            System.debug(e.getMessage());
        }        
        try {
            if(this.Rescue.CSS_WS_TotalRescueTime__c > 7){
                //Add code
            }
            this.ReasonNoTargetTimeSelectedValues();//Check
            if(this.Rescue.CSS_WS_SparePartsUsage__c == true){
                this.SavePartsGrids();
            } else {
                delete [SELECT Id FROM CSS_WS_Rescue_Parts__c WHERE Rescue_Id__c = :this.Rescue.Id];
            }
        } catch (Exception e){
            System.debug(e.getMessage());
        } 
        if(this.ServiceDetailError == true || this.ValidateRequiredFields('details') > 0){
            return false;
        }
        return true;
    }
 
    Public Boolean checkifItisWorkingDay(Date currentDate){
        list<holidays__c> holis = holidays__c.getAll().values();
        Date weekStart = currentDate.toStartofWeek();
        for(holidays__c hDay:holis){
            if(currentDate.daysBetween(hDay.Holiday_Date__c) == 0){
                return false;
            }
        }
        String locale = UserInfo.getLocale();
        if(locale == 'es_MX'){//It validates if user has the "Mexico" locale configured
            if(weekStart.daysBetween(currentDate) == 5 || weekStart.daysBetween(currentDate) == 6){
                return false;
            } else {
                return true;
            }       
        } else {//By default the USA locale will be used in case Mexico locale is not configured
            if(weekStart.daysBetween(currentDate) == 6 || weekStart.daysBetween(currentDate) == 0){
                return false;
            } else {
                return true;
            }   
        }
    }
  
    Public Boolean validateBitacoraFields(){
        if(this.Rescue.CSS_WS_ServiceRequest__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E035 ));//Service request can not be empty
            return false;
        }
        if(this.Rescue.CSS_WS_ServiceCoordination__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E030 ));//Service Coordination Date cannot be empty
            return false;
        }
        if(this.Rescue.CSS_WS_ExpertOutput__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E042 ));//Technician Completion Date cannot be empty
            return false;
        }
        if(this.Rescue.CSS_WS_RepairEnding__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E026 ));//Repair Completion Date cannot be empty
            return false;
        }
        if(this.Rescue.CSS_WS_Returns__c == null || this.Rescue.CSS_WS_Returns__c < 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E016 ));//Laps value cannot be empty or lower than 1
            return false;
        }
        if(this.Rescue.CSS_WS_TravelKmRoundTrip__c == null){
            this.Rescue.CSS_WS_TravelKmRoundTrip__c = 0.0;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E048 ));//Travel KM Round Trip value cannot be empty
            return false;
        }
        if(this.Rescue.CSS_WS_TravelHoursRoundTrip__c == null){
            this.Rescue.CSS_WS_TravelHoursRoundTrip__c = 0.0;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E047 ));//Travel Hours Round Trip value cannot be empty
            return false;
        }  

        D1 = this.Rescue.CSS_WS_ServiceRequest__c.date();
        D2 = this.Rescue.CSS_WS_ServiceCoordination__c.date();
        diffDate = D1.daysBetween(D2);
        if(diffDate < 0){//Rule RR-20
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E003));//Service Coordination Date is not valid
            return false;
        }

        D1 = this.Rescue.CSS_WS_ServiceCoordination__c.date();
        D2 = this.Rescue.CSS_WS_ExpertOutput__c.date();
        diffDate = D1.daysBetween(D2);
        if(diffDate < 0){//Rule RR-21
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E017));//Expert Output Date is not valid
            return false;
        }

        D1 = this.Rescue.CSS_WS_ExpertOutput__c.date();
        D2 = this.Rescue.CSS_WS_RepairEnding__c.date();
        diffDate = D1.daysBetween(D2);
        if(diffDate < 0){//Rule RR-22
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E027 ));//Repair Completion Date is not valid
            return false;
        }

        D1 = this.Rescue.CSS_WS_ServiceCoordination__c.date();
        D2 = this.Rescue.CSS_WS_ServiceRequest__c.date();
        diffDate = D2.daysBetween(D1);
        diffTime = this.Rescue.CSS_WS_ServiceCoordination__c.hour() - this.Rescue.CSS_WS_ServiceRequest__c.hour();
        if(diffTime == 0){
            diffTime = this.Rescue.CSS_WS_ServiceCoordination__c.minute() - this.Rescue.CSS_WS_ServiceRequest__c.minute();
        }        
        if(diffDate == 0 && diffTime < 0){//Rule RR-23
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E031));//Service Coordination Time is not valid
            return false;
        }
        
        D1 = this.Rescue.CSS_WS_ServiceCoordination__c.date();
        D2 = this.Rescue.CSS_WS_ExpertOutput__c.date();
        diffDate = D2.daysBetween(D1);
        diffTime = this.Rescue.CSS_WS_ExpertOutput__c.hour() - this.Rescue.CSS_WS_ServiceCoordination__c.hour();
        if (diffTime==0) {
            diffTime = this.Rescue.CSS_WS_ExpertOutput__c.minute() - this.Rescue.CSS_WS_ServiceCoordination__c.minute();
        }        
        if(diffDate == 0 && diffTime < 0){//Rule RR-24
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E040));//Expert Output Time is not valid
            return false;
        }
        
        D1 = this.Rescue.CSS_WS_RepairEnding__c.date();
        D2 = this.Rescue.CSS_WS_ExpertOutput__c.date();
        diffDate = D2.daysBetween(D1);
        diffTime = this.Rescue.CSS_WS_RepairEnding__c.hour() - this.Rescue.CSS_WS_ExpertOutput__c.hour();
        if(diffTime == 0){
            diffTime = this.Rescue.CSS_WS_RepairEnding__c.minute() - this.Rescue.CSS_WS_ExpertOutput__c.minute();
        }        
        if(diffDate==0 && diffTime < 0){//Rule RR-25
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E043));//Repair Completion Time is not valid
            return false;
        }

        D2 = this.Rescue.CSS_WS_ExpertOutput__c.date();
        D1 = this.Rescue.CSS_WS_ServiceCoordination__c.date();
        diffDate = D1.daysBetween(D2);
        if(diffDate < 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E017));//Expert Output Date is not valid
            return false;
        }
        
        diffDate = D2.daysBetween(D1);
        diffTime = this.Rescue.CSS_WS_ExpertOutput__c.hour() - this.Rescue.CSS_WS_ServiceCoordination__c.hour();
        if(diffTime == 0){
            diffTime = this.Rescue.CSS_WS_ExpertOutput__c.minute() - this.Rescue.CSS_WS_ServiceCoordination__c.minute();
        }  
        
        if(diffDate == 0 && diffTime < 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Rescue_E040));//Expert Output Time is not valid
            return true;
        }    
        
        if(this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c > this.Rescue.CSS_WS_TravelHoursRoundTrip__c){//Rule RR-29
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.CSS_WS_Rescue_E053));//Approved travel hours are greather than requested travel hours
            return true;
        } 
        
        if(this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c > this.Rescue.CSS_WS_TravelKmRoundTrip__c){//Rule RR-28
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.CSS_WS_Rescue_E001));//Approved travel KM are greather than requested travel KM
            return true;
        }
        return true;
    }
    
    Public Boolean updatePart(){        
        Integer PartPosToUpdate = -1;
        Integer i = 0;
        Integer ListSize = this.PartList.size();
        Boolean error = false;
        for(i = 0; i < ListSize; i++){
            if(this.PartList[i].Index == this.PartToUpdate){
                PartPosToUpdate = i;
            }
        }
        if(PartPosToUpdate != -1 &&  this.PartList[PartPosToUpdate].Part.CSS_WS_Part_ID__c != ''){
            if(!CheckRepeatedPart(this.PartList[PartPosToUpdate].Part, PartPosToUpdate)){
                this.PartList[PartPosToUpdate].Part.CSS_WS_Description__c = this.description;
            } else {
                EmptyValues(this.PartList[PartPosToUpdate].Part);
                error = true;
            }
            
        } else {
            if(this.PartList.size()>0)
                EmptyValues(this.PartList[PartPosToUpdate].Part);
            if(partsMap.containsKey(OldPartNum)){
                partsMap.remove(OldPartNum);
            }
        }
        return error;
    }
    
    Public Boolean checkRepeatedPart(CSS_WS_Rescue_Parts__c part, Integer Index){
        Boolean res = false;
        if(part.CSS_WS_Part_ID__c == ''){
            if(partsMap.containsKey(OldPartNum)){
                partsMap.remove(OldPartNum);
            }
            return res;
        }
        if(partsMap.containsKey(part.CSS_WS_Part_ID__c) && partsMap.get(part.CSS_WS_Part_ID__c) != Index){
            res = true;
        } else {
            updateMap(part, Index);
        }
        return res;
    }
    
    Public Boolean validateStartingSignalTime(){
        Boolean error = false;
        this.Rescue.CSS_WS_SignalTime__c = 'Night';
        if(Rescue.CSS_WS_ServiceRequest__c == null){
            error = true;
            return error;
        }        
        if((this.Rescue.CSS_WS_ServiceRequest__c.hour() >= 8 && This.Rescue.CSS_WS_ServiceRequest__c.hour() < 18) && checkifItisWorkingDay(This.Rescue.CSS_WS_ServiceRequest__c.DATE()) == true){//Rule RR-30 and RR-31
            this.Rescue.CSS_WS_SignalTime__c = 'Day';
        }
        return error;
    }
        
    Public Void getHRRoundTravelPolicy(){       
        if(this.Rescue.CSS_WS_TravelHoursRoundTrip__c > 0) {
            if(this.Rescue.CSS_WS_Charged_To__c == 'Cliente') {
                this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 0;
            } else {   
                this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c = Rescue.CSS_WS_TravelHoursRoundTrip__c;
            }
        } else {
            this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 0;
        }
    }
    
    Public Void getKMRoundtravelPolicy(){        
        if(this.Rescue.CSS_WS_TravelKmRoundTrip__c > 0) { 
            if(this.Rescue.CSS_WS_Charged_To__c == 'Cliente') {
                this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c = 0;
            } else {   
                this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c = Rescue.CSS_WS_TravelKmRoundTrip__c;
            }    
        } else {
            this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c = 0;
        }
    }
    
    Public Void getResponseTime(){
        if(this.Rescue.CSS_WS_ExpertOutput__c != null && this.Rescue.CSS_WS_ServiceRequest__c != null) {
            this.Rescue.CSS_WS_ResponseExitTime__c = durationTime(this.Rescue.CSS_WS_ServiceRequest__c,this.Rescue.CSS_WS_ExpertOutput__c);
        } else {
            this.Rescue.CSS_WS_ResponseExitTime__c =  0;
        }       
    }

    Public Void getRepairingTime(){
        if(this.Rescue.CSS_WS_TravelHoursRoundTrip__c != null && this.Rescue.CSS_WS_ResponseExitTime__c != null) {
            this.Rescue.CSS_WS_RepairTime__c = durationTime(this.Rescue.CSS_WS_ExpertOutput__c,this.Rescue.CSS_WS_RepairEnding__c);
        } else {
            this.Rescue.CSS_WS_RepairTime__c = 0;
        }       
    }
    
    Public Void getSignalBy(){
        if(this.Rescue.CSS_WS_AccCoverage__c == false){               
            if(this.Rescue.CSS_WS_Years_In_Service__c != null && this.Rescue.CSS_WS_Years_In_Service__c <= 4){//Rule RR-33
                this.Rescue.CSS_WS_SignalBy__c = 'Policy';
            }         
        } else {
            if(this.Rescue.CSS_WS_CoveredTravelLabor__c >= this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c){//Rule RR-32
                this.Rescue.CSS_WS_SignalBy__c = 'Warranty';
            } else {//Rule RR-33
                this.Rescue.CSS_WS_SignalBy__c = 'Policy';
            }         
        }               
    }

    Public Void getRescueTotalTime(){
        System.debug('RepairTimetime ->  ' + this.Rescue.CSS_WS_RepairTime__c);
        System.debug('ResponseExittime ->' + this.Rescue.CSS_WS_ResponseExitTime__c);
        
        if (this.Rescue.CSS_WS_RepairTime__c != NULL && this.Rescue.CSS_WS_ResponseExitTime__c != NULL) {
            this.Rescue.CSS_WS_TotalRescueTime__c = this.Rescue.CSS_WS_ResponseExitTime__c + this.Rescue.CSS_WS_RepairTime__c;
        } else {
            this.Rescue.CSS_WS_TotalRescueTime__c = 0;
        }               
    }

    Public Void getRescueTotalCost(){
        this.SetRates();
        this.Rescue.CSS_WS_BaseFare__c = this.rescue.CSS_WS_SignalTime__c;
        Decimal amount=0.0;
        Decimal kms = (this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c !=NULL) ? this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c - 100  : 0.0;
        Decimal hrs = (this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c !=NULL) ? this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c : 0.0;
        this.Rescue.CSS_WS_AdditionalKMDriven__c = (kms > 0.0) ? kms : 0.0;
        this.Rescue.CSS_WS_AdditionalKMDrivenAmount__c = this.Rescue.CSS_WS_AdditionalKMDriven__c * this.KmsPrice;
        hrs--;
        this.Rescue.CSS_WS_AdditionalHours__c = (hrs > 0.0) ? hrs : 0.0;
        this.Rescue.CSS_WS_AdditionalHoursAmount__c = this.Rescue.CSS_WS_AdditionalHours__c * this.Hrsprice;        
        Decimal extraKM = (kms > 0.0) ? kms * this.KmsPrice : 0.0; 
        Decimal extraHR = (hrs > 0.0) ? hrs * this.Hrsprice : 0.0;
        Decimal extra = extraKM + extraHR;
        if(this.Rescue.CSS_WS_SignalTime__c.toUpperCase() != null){
            if(this.Rescue.CSS_WS_SignalTime__c.toUpperCase() == 'DIURNO' || this.Rescue.CSS_WS_SignalTime__c.toUpperCase() == 'DAY'){
                this.Rescue.CSS_WS_MinimumFare__c = this.dayPrice;
            } else {
                this.Rescue.CSS_WS_MinimumFare__c = this.nightPrice;
            }
            this.Rescue.CSS_WS_MinimumFare__c *= this.Rescue.CSS_WS_Returns__c != null ? this.Rescue.CSS_WS_Returns__c : 0;
            amount = extra + this.Rescue.CSS_WS_MinimumFare__c;
        } else {
            amount = extra;
        }        
        this.Rescue.CSS_WS_Lodging_Amount_MXN__c = this.Rescue.CSS_WS_Lodging_Amount_MXN__c == null ? 0.00 : this.Rescue.CSS_WS_Lodging_Amount_MXN__c;
        this.Rescue.CSS_WS_LunchAmount_MXN__c = this.Rescue.CSS_WS_LunchAmount_MXN__c == null ? 0.00 : this.Rescue.CSS_WS_LunchAmount_MXN__c;
        amount += this.Rescue.CSS_WS_Lodging_Amount_MXN__c;
        amount += this.Rescue.CSS_WS_LunchAmount_MXN__c;        
        this.Rescue.CSS_WS_RescueCost__c = (this.Rescue.CSS_WS_Charged_To__c !='Customer Care') ? amount : 0.00;
        //Convert to USD
        this.CurrencyPrice = (this.CurrencyPrice != null) ? this.CurrencyPrice : 0.0; 
        this.Rescue.CSS_WS_AdditionalKMDrivenAmount__c = CurrencyPrice * this.Rescue.CSS_WS_AdditionalKMDrivenAmount__c; 
        this.Rescue.CSS_WS_AdditionalHoursAmount__c = CurrencyPrice * this.Rescue.CSS_WS_AdditionalHoursAmount__c;
        if(this.Rescue.CSS_WS_MinimumFare__c != null){
            this.Rescue.CSS_WS_MinimumFare__c = CurrencyPrice * this.Rescue.CSS_WS_MinimumFare__c;
        }
        //This.Rescue.CSS_WS_MinimumFare__c = (This.Rescue.CSS_WS_MinimumFare__c != NULL) ? CurrencyPrice * This.Rescue.CSS_WS_MinimumFare__c : NULL;
        this.Rescue.CSS_WS_RescueCost__c = CurrencyPrice * this.Rescue.CSS_WS_RescueCost__c;
    }

    Public Void rescueAttachment(){
        rescue_attachment_list = [SELECT Id, name FROM Attachment WHERE ParentID = :this.Rescue.Id]; 
    }
    
    Public Void rescueDeleteAttachmentRow(){
        for(Integer i = 0; i < rescue_attachment_list.size(); i++) {
            Attachment a = rescue_attachment_list[i];
            if(a.Id == rescueSelectedRowId) {
                delete a;
                rescue_attachment_list.remove(i);
                break;
            }
        }        
    }
    
    Public Void selectExit(){
        if(this.Rescue.CSS_WS_Exit__c){
            this.Rescue.CSS_WS_Repair__c = false;
        }
    }
    
    Public Void selectRepair(){
        if (this.Rescue.CSS_WS_Repair__c){
            this.Rescue.CSS_WS_Exit__c = false;
        }
    }       
       
    Public Void getPromotionIDs(){
        List<SelectOption> promotionIds = new List<SelectOption>();
        List<String> SPData = new List<String>();
        String FailureDate = '';
        promotionIds.add(new SelectOption('',Label.CSS_WS_Selection_Technician));
        promotionIds.add(new SelectOption('No Promotion Id ', 'No Promotion Id'));
        SPData.add(this.Rescue.CSS_WS_Service_Provider_Dealer__c);
        SPData.add(this.Rescue.CSS_WS_Service_Model__c);
        SPData.add(CSS_WS_RescueController.dateToString(this.Rescue.CSS_WS_ServiceRequest__c, 'dd-MMM-yy'));
        try{
            CSS_WS_J2A_GetSPData SPDataResponse = CSS_WS_GetWebServiceData.getSPData(SPData);
            if(SPDataResponse != null){
                if(SPDataResponse.Header.Status.touppercase() == 'SUCCESS'){
                    if( SPDataResponse.DataArea != null){
                        if(!String.isEmpty(SPDataResponse.DataArea.FieldServiceLaborRate)){
                            this.Rescue.Labor_Rate__c = Decimal.valueOf(SPDataResponse.DataArea.FieldServiceLaborRate);
                        }                        
                        if(SPDataResponse.DataArea.Details != null){
                            for (integer i=0; i< SPDataResponse.DataArea.Details.size(); i++) {
                                if(SPDataResponse.DataArea.Details[i].PromotionId != null && SPDataResponse.DataArea.Details[i].LastName != null){
                                    system.debug(SPDataResponse.DataArea.Details[i].PromotionId);
                                    String PromotionId = SPDataResponse.DataArea.Details[i].PromotionId;
                                    String FistName = (SPDataResponse.DataArea.Details[i].FirstName !=null)?SPDataResponse.DataArea.Details[i].FirstName:'' ;
                                    String LastName = (SPDataResponse.DataArea.Details[i].LastName !=null)?SPDataResponse.DataArea.Details[i].LastName:'';
                                    promotionIds.add(new SelectOption(PromotionId, FistName + ' ' + LastName));
                                }
                            }
                        }
                    }             
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, SPDataResponse.Header.ReturnCodeDescription));
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Global_E001));//Unexpected error, please contact Your System Administrator
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Global_E001));//Unexpected error, please contact Your System Administrator
            system.debug('Error: '+e.getMessage());
        }    
        this.PromotionIDsList = promotionIds;   
    }
    
    Public Void reasonNoTargetTimeSelectedValues(){
        if(String.isEmpty(this.Rescue.CSS_WS_ReasonNoTargetTime__c) == false && this.Rescue.CSS_WS_ReasonNoTargetTime__c.contains(';')){
            List<String> ReasonsNoTargetTime = this.Rescue.CSS_WS_ReasonNoTargetTime__c.split(';');
            if(ReasonsNoTargetTime.size() > 2){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Rescue_E019)); //Maximum of 2 options can be allowed for "Reasons for no Target Time"
                this.ServiceDetailError = true;
            }
        }
    }
    
    Public Void checkResponsableValue(){
        if(String.isEmpty(this.Rescue.CSS_WS_Responsable__c) == false && String.isEmpty(this.Rescue.CSS_WS_Comments__c) == true){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Rescue_E025));//Comments can not be empty
            this.ServiceDetailError = true;
        }
    }
    
    Public Void clearHiddenFields(){
        if(this.Rescue.CSS_WS_FailureIsProductProblem__c != 'Yes') {
            this.Rescue.CSS_WS_FailureRelatedTo__c = null;
            this.Rescue.CSS_WS_OtherObservation__c = null;
            this.Rescue.CSS_WS_TechnicianPromotion__c = null;
        }
    }
    
    Public Void promotionIDInformation(){
        for(SelectOption Option: this.PromotionIDsList){
            if(Option.getValue() == this.Rescue.CSS_WS_TechnicianPromotion__c){
                this.Rescue.CSS_WS_TechnicianName__c = Option.getLabel();
                break;
            }
        }
    }
    
    Public Void whoCaptureFunction(){
        if(String.isEmpty(this.Rescue.CSS_WS_Service_Provider_Dealer__c) == false){
            if(this.Rescue.CSS_WS_Service_Provider_Dealer__c == '4759'){//Rule RR-07
                this.Rescue.CSS_WS_Capturer_Name__c = 'Planta';
            } else if(this.Rescue.CSS_WS_Service_Provider_DR__c == this.Rescue.CSS_WS_Service_Provider_Dealer__c){//Rule RR-08 and RR-09
                this.Rescue.CSS_WS_Capturer_Name__c = 'Distributor';
            } else {
                this.Rescue.CSS_WS_Capturer_Name__c = 'Dealer';
            }
        }
    }
    
    Public Void addNewPart(){
        this.PartList.add(new CreateNewPart(this.PartCounter++, this.partNumber, this.quantity, this.description, this.Rescue.Id));
    }
    
    Public Void addRow(){
        this.PartList.add(new CreateNewPart(this.PartCounter++, '', 0, '', this.Rescue.Id));
    }
    
    Public Void emptyValues(CSS_WS_Rescue_Parts__c part){
        part.CSS_WS_Part_ID__c = '';
        part.CSS_WS_Description__c = '';
        part.CSS_WS_Quantity__c  = 0;
    }
    
    Public Void deletePart(){
        Integer PartPosToDelete = -1;
        Integer i = 0;
        Integer ListSize = this.PartList.size();       
        if(ListSize > 1){
            for(i = 0; i < ListSize; i++){
                if(this.PartList[i].Index == this.PartToDelete){
                    PartPosToDelete = i;
                }
            }            
            if(PartPosToDelete != -1){
                this.PartList.remove(PartPosToDelete);
            }
        } 
        countParts();
    }
    
    Public Void updateMap(CSS_WS_Rescue_Parts__c part, Integer Index){
        if(!partsMap.containsKey(part.CSS_WS_Part_ID__c)){
            partsMap.put(part.CSS_WS_Part_ID__c,  Index);
        } else if(partsMap.get(part.CSS_WS_Part_ID__c) != Index){
            partsMap.remove(part.CSS_WS_Part_ID__c);
            partsMap.put(part.CSS_WS_Part_ID__c,  Index);
        }
    }
    
    Public Void yearsInService(){
        if(this.Rescue.CSS_WS_ServiceRequest__c != null && this.Rescue.CSS_WS_Warranty_Start_Date__c != null){
            if(this.Rescue.CSS_WS_Warranty_Start_Date__c > this.Rescue.CSS_WS_ServiceRequest__c){
                this.Rescue.CSS_WS_ServiceRequest__c = null;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Rescue_E037));//Service Request cannot be lesser than Warranty Start Date
                return;
            }
            Date currentDate = System.today();  
            if(this.Rescue.CSS_WS_ServiceRequest__c.date() > currentDate){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Rescue_E036));//Service Request cannot be bigger than the actual date
                return;
            } 
            Date failureDate = this.Rescue.CSS_WS_ServiceRequest__c.date();
            Date warrantyStartDate = this.Rescue.CSS_WS_Warranty_Start_Date__c;             
            integer total_days = warrantyStartDate.daysBetween(failureDate);
            decimal years = decimal.valueof(total_days)/decimal.valueof(365);
            long years_in_service = years.round(RoundingMode.UP);
            this.Rescue.CSS_WS_Years_In_Service__c = years_in_service; 
        } else if (this.Rescue.CSS_WS_Warranty_Start_Date__c == null){
            this.Rescue.CSS_WS_Years_In_Service__c = 0;
        }else {
            this.Rescue.CSS_WS_Years_In_Service__c = null; 
        }
        this.RR02RR04();
    }
    
    Public Void emptyValues(CSS_WS_Warranty_Parts__c part){
        part.CSS_WS_PartNumber__c = '';
        part.CSS_WS_Description__c = '';
        part.CSS_WS_PartService__c = ''; 
        part.CSS_WS_Quantity__c  = 0;
    }
    
    Public Void countParts(){
        Integer i = 1;
        for(CreateNewPart part : PartList){
            part.Index = i++;
        }
        this.PartCounter = i++;
    }
    
    Public Void getSPList(){
        this.distributorsDisable = false;
        this.dealersDisable = false;
        if(userinfo.getUserType() == 'PowerCustomerSuccess'){
            Account userAccount = new Account();
            if(this.Rescue.CSS_WS_Service_Provider_DR__c != null && this.Rescue.CSS_WS_Service_Provider_Dealer__c != null){
                userAccount = [SELECT IAM_Service_Provider_Code__c, CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE 
                            (type = 'Distributor Account' OR type = 'Distributor Branch Account' OR type = 'Dealer Account' OR type = 'Dealer Branch Account') AND CSS_DBCode__c =: this.Rescue.CSS_WS_Service_Provider_DR__c AND IAM_Service_Provider_Code__c =: this.Rescue.CSS_WS_Service_Provider_Dealer__c  
                            AND CMI_Account_Status__c = 'Active' ORDER BY type LIMIT 1];
            } else {
                Contact userContact = [SELECT Account.Name FROM Contact WHERE Id In (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
                userAccount = [SELECT IAM_Service_Provider_Code__c, CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE Account.Name =: userContact.Account.Name 
                            AND (type = 'Dealer Account' OR type = 'Distributor Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') 
                            AND CMI_Account_Status__c = 'Active'];
            }
            if(userAccount != null){
                this.Rescue.CSS_WS_Service_Provider_DR__c = userAccount.CSS_DBCode__c;
                this.Rescue.CSS_WS_Service_Provider_Dealer__c = userAccount.IAM_Service_Provider_Code__c;
                
                if(userAccount.Type == 'Distributor Account' || userAccount.Type == 'Distributor Branch Account'){
                    // validation to enable select list to select DR when DR Region is logged in
                    if (this.isDRRegion){
                        this.distributorsDisable = false;
                    } else {
                        this.distributorsDisable = true;
                    }  
                    LogInVariable = 'DRLoggedIn';
                } else if(userAccount.Type == 'Dealer Account' || userAccount.Type == 'Dealer Branch Account'){
                    this.distributorsDisable = true;
                    this.dealersDisable = true;
                    LogInVariable = 'DealerLoggedIn';
                } else {
                    //Add error
                }
            } else {
                LogInVariable = 'DRLoggedIn';
            }
        }
    }
   
    Public Void SetComponentList(){
        List<selectOption> Options = new List<selectOption>();
        Options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        //String StringToSplit = this.EngineSystemSelectListValue;
        String StringToSplit = this.Rescue.CSS_WS_Engine_System__c; //= this.EngineSystemSelectListValue;
        String[] ValuesFromSplit;
        if(StringToSplit != null){
            if(StringToSplit.contains('&')){
                ValuesFromSplit = StringToSplit.split('&');
            }
        }
        if(ValuesFromSplit != null) {
            CSS_WS_Failure_Master__c [] failures = [SELECT ID, Engine_Component_Code__c, Engine_Component_Code_Description__c
                FROM CSS_WS_Failure_Master__c WHERE Engine_System_Code__c = :ValuesFromSplit[0] AND Engine_Component_Code__c != ''
                AND Engine_Component_Code_Description__c != '' AND Engine_Family_Code__c =: this.Rescue.CSS_WS_Engine_Family_Code__c
                ORDER BY Engine_Component_Code__c LIMIT 999];
            for(CSS_WS_Failure_Master__c failure : failures){
                Options.add(new SelectOption(String.valueof(failure.Engine_Component_Code__c + '&' + failure.Engine_Component_Code_Description__c),
                            String.valueof(failure.Engine_Component_Code__c + ' - ' + failure.Engine_Component_Code_Description__c).abbreviate(this.AbbreviateNumber)));
            }
        }
        this.GetComponentList = Options;
    }
    
    Public Void getCoverageInfo(){
        Boolean error = false;
        String ComponentCode = '';
        String[] ValuesFromSplit;
        String EngineSystemCode = '';        
        String StringToSplit = this.Rescue.CSS_WS_Engine_System__c;
        if( StringToSplit != null ){
            if(StringToSplit.contains('&')){
                ValuesFromSplit = StringToSplit.split('&');
            }
        }
        if(ValuesFromSplit != null){
            EngineSystemCode = ValuesFromSplit[0];
        }
        StringToSplit = this.Rescue.CSS_WS_Component__c;
        if(StringToSplit != null){
            if(StringToSplit.contains('&')){
                ValuesFromSplit = StringToSplit.split('&');
            }
        }
        if(ValuesFromSplit != null){
            ComponentCode = ValuesFromSplit[0];
        }
        List<String> SystemAndComponentCode = new List<String>();
        List<String> ListToAccCoverage = new List<String>();
        String NewPartsWarrantyFlg = 'N', ReConPartsWarrantyFlg = 'N', RoadRelayWarrantyFlg = 'N';
        String AccountCode = '';
        ListToAccCoverage.add(Rescue.CSS_WS_Engine_Serial_Number__c);
        ListToAccCoverage.add(Rescue.CSS_WS_Service_Provider_Dealer__c);  //spcode
        ListToAccCoverage.add(CSS_WS_RescueController.dateToString(this.Rescue.CSS_WS_ServiceRequest__c, 'MM/dd/yyyy'));
        ListToAccCoverage.add(String.valueOf(Rescue.CSS_WS_Failure_Point_Quantity__c));
        ListToAccCoverage.add(Rescue.CSS_WS_Failure_Measure__c);
        ListToAccCoverage.add(Rescue.CSS_WS_Engine_Application_Code__c);
        ListToAccCoverage.add('');  //Need Fault Code for Emission coverage check. Send blank 
        ListToAccCoverage.add(CSS_WS_RescueController.dateToString(this.Rescue.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
        ListToAccCoverage.add('');
        ListToAccCoverage.add(NewPartsWarrantyFlg);  //new parts warranty flag
        ListToAccCoverage.add(ReConPartsWarrantyFlg);  //recon parts warranty flag
        ListToAccCoverage.add(RoadRelayWarrantyFlg);  //road relay warranty flag  
        if(Rescue.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '27' || Rescue.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '48' ||
           Rescue.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '60' || Rescue.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '61'){    
            ListToAccCoverage.add('98');
        } else {
            ListToAccCoverage.add(AccountCode);
        }
        SystemAndComponentCode.add(EngineSystemCode + ',' + ComponentCode);
        CSS_WS_J2A_GetAccountCoverage AccCoverageResponseLocal = CSS_WS_GetWebServiceData.getAccountCoverage(ListToAccCoverage, SystemAndComponentCode); 
        
        if(AccCoverageResponseLocal != null){
           if(AccCoverageResponseLocal.Header.Status.toUpperCase() == 'SUCCESS'){
               if(AccCoverageResponseLocal.DataArea.Details[0].Status.touppercase() == 'ERROR'){  
                   this.Rescue.CSS_WS_AccCoverage__c = false;     
                   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, AccCoverageResponseLocal.DataArea.Details[0].Message));                  
               } else {
                   this.Rescue.CSS_WS_AccCoverage__c = true;
                   this.Rescue.CSS_WS_CoveredTravelLabor__c = Integer.valueof(AccCoverageResponseLocal.DataArea.Details[0].CoveredTravelLabor);
               } 
           } else {
               ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, AccCoverageResponseLocal.Header.ReturnCodeDescription));     
           }            
        }    
    }
    
    Public Void getESN(){   
        if(this.Rescue.CSS_WS_Engine_Serial_Number__c != null) { 
            this.ESNR = this.Rescue.CSS_WS_Engine_Serial_Number__c;
        } else {
            this.ESNR ='';
        } 
        if(this.ESNR.isNumeric() && this.ESNR.length() == 8) {
            CSS_WS_J2A_GetEngineData objESN = CSS_WS_GetWebServiceData.getEngineData(this.Rescue.CSS_WS_Engine_Serial_Number__c); //Web service call
            if(objESN != null){
                if(objESN.Header.Status.touppercase() == 'SUCCESS' && objESN.DataArea != null){
                    deleteESN();
                    this.Rescue.CSS_WS_Engine_Serial_Number__c = this.ESNR; 
                    CSS_WS_Engine_Application_Code__c code = mapEngineApplication(objESN.DataArea.EngineAppDesc);
                    this.Rescue.CSS_WS_Engine_Application__c = code != null ? code.Application_Description__c : '';
                    this.Rescue.CSS_WS_Engine_Application_Code__c = code != null ? code.Name : '';
                    this.Rescue.CSS_WS_Failure_Measure__c= code != null ? code.Default_Measurement__c : 'Not available';//Rule RR-15, RR-16, RR-17 and RR-18
                    this.Rescue.CSS_WS_Service_Model__c = objESN.DataArea.ServiceModelName != null ? objESN.DataArea.ServiceModelName : '';
                    this.Rescue.CSS_WS_Manufacturer__c = objESN.DataArea.Manufacturer != null ? objESN.DataArea.Manufacturer : '';
                    this.Rescue.CSS_WS_Engine_Family_Code__c = objESN.DataArea.EngineFamilyCode != null ? objESN.DataArea.EngineFamilyCode : '';
                    this.Rescue.CSS_WS_Model_Series__c = objESN.DataArea.Model != null ? objESN.DataArea.Model : '';
                    this.Rescue.CSS_WS_Access_Code__c = objESN.DataArea.AccessCode;
                    this.Rescue.CSS_WS_Build_Date__c = objESN.DataArea.BuildDate != null ? stringToDate(objESN.DataArea.BuildDate, 'YYYY-MM-DDTHH:MM:SS') : null;
                    this.Rescue.CSS_WS_Warranty_Start_Date__c =  CSS_WS_ControllerClaim.stringToDate(objESN.DataArea.WarrantyStartDate, 'YYYY-MM-DDTHH:MM:SS');
                    if(this.Rescue.CSS_WS_Warranty_Start_Date__c != null){//Rule RR-10 and RR-11
                        warrantyStartDateFlag = true;
                    }
                    if(this.Rescue.CSS_WS_Manufacturer__c != null && this.Rescue.CSS_WS_Manufacturer__c != ''){
                        manufacturerDis++;
                    } 
                    if(this.Rescue.CSS_WS_Engine_Application__c != null && this.Rescue.CSS_WS_Engine_Application__c != ''){
                        engineAppDis = true;
                    }
                    /*if(objESN.DataArea.EngineAppDesc != null && objESN.DataArea.EngineAppDesc != ''){
                        engineAppDis = true;
                    }*/
                    RR02RR04();
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objESN.Header.ReturnCodeDescription));
                    deleteESN();
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                deleteESN();
            }
        } else {
            deleteESN();
        }
        if(this.Rescue.CSS_WS_Before_In_Service__c == true){//Rule RR-01
            this.Rescue.CSS_WS_Warranty_Start_Date__c = null;
            warrantyStartDateFlag = true;
        }
    }  
    
    Public Void deleteESN(){
        this.Rescue.CSS_WS_Engine_Serial_Number__c = null;
        this.Rescue.CSS_WS_Engine_Application__c = null;
        this.Rescue.CSS_WS_Customer_Name_Internal__c = null;
        this.Rescue.CSS_WS_Service_Model__c = null;
        this.Rescue.CSS_WS_Manufacturer__c = null;
        this.Rescue.CSS_WS_Model_Series__c = null;
        this.Rescue.CSS_WS_Warranty_Start_Date__c = null;
        this.Rescue.CSS_WS_Access_Code__c = null;
        this.Rescue.CSS_WS_Engine_Family_Code__c = null;
        this.Rescue.CSS_WS_Engine_Application_Code__c = null;
        this.Rescue.CSS_WS_Failure_Measure__c = null;
        this.Rescue.CSS_WS_Charged_To__c = null;
        this.Rescue.CSS_WS_Build_Date__c = null;
        warrantyStartDateFlag = false;
        customerDis = false;
        manufacturerDis = 0;
        modelSeriesDis = false;
        engineAppDis = false;
    }
    
    Public Void SetRates(){
        List<CSS_WS_Travel_Prices__c> TravelPrices = CSS_WS_Travel_Prices__c.getAll().values();
        for(CSS_WS_Travel_Prices__c Price: TravelPrices){
            if(Price.Name == 'Tipo Cambio') {
                this.CurrencyPrice = Price.Local_Rate__c;
            } else if(Price.Name == 'KM Adicional') {
                this.KmsPrice = Price.Local_Rate__c;
            } else if(Price.Name == 'Banderazo Nocturno') {
                this.NightPrice = Price.Local_Rate__c;
            } else if(Price.Name == 'HR Adicional') {
                this.HrsPrice = Price.Local_Rate__c;
            } else if(Price.Name == 'Banderazo Diurno') {
                this.DayPrice = Price.Local_Rate__c;
            }
        }
    }
    
    Public Void GetLunchAmount(){
        This.CurrencyPrice = (This.CurrencyPrice != NULL) ? This.CurrencyPrice : 0.0;
        This.Rescue.CSS_WS_LunchAmount_MXN__c = (This.Rescue.CSS_WS_LunchAmount_MXN__c != NULL) ? This.Rescue.CSS_WS_LunchAmount_MXN__c : 0.00;
        This.Rescue.CSS_WS_LunchAmount__c = CurrencyPrice * This.Rescue.CSS_WS_LunchAmount_MXN__c;
        //Validation to not request towing and travel at same time - Oct 7th 2020
        if(this.Rescue.Towing_Flag__c == true && (this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c > 0 || this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c > 0 || this.Rescue.CSS_WS_LunchAmount_MXN__c > 0 || this.Rescue.CSS_WS_Lodging_Amount_MXN__c > 0)){
            This.Rescue.CSS_WS_LunchAmount_MXN__c = 0.00;
            This.Rescue.CSS_WS_LunchAmount__c = 0.00;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Rescue_E059));//It is not possible to request Travel, Lunch and Lodging, when Towing is being requested at same time.
        }
    }
    
    Public Void GetLodgingAmount(){
        This.CurrencyPrice = (This.CurrencyPrice != NULL) ? This.CurrencyPrice : 0.0;
        This.Rescue.CSS_WS_Lodging_Amount_MXN__c = (This.Rescue.CSS_WS_Lodging_Amount_MXN__c != NULL) ? This.Rescue.CSS_WS_Lodging_Amount_MXN__c : 0.00;
        This.Rescue.CSS_WS_Lodging_Amount__c = CurrencyPrice * This.Rescue.CSS_WS_Lodging_Amount_MXN__c;
        //Validation to not request towing and travel at same time - Oct 7th 2020
        if(this.Rescue.Towing_Flag__c == true && (this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c > 0 || this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c > 0 || this.Rescue.CSS_WS_LunchAmount_MXN__c > 0 || this.Rescue.CSS_WS_Lodging_Amount_MXN__c > 0)){
            This.Rescue.CSS_WS_Lodging_Amount_MXN__c = 0.00;
            This.Rescue.CSS_WS_Lodging_Amount__c = 0.00;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Rescue_E059));//It is not possible to request Travel, Lunch and Lodging, when Towing is being requested at same time.
        }
    }

    Public Void GetTowingAmount(){
        System.debug(this.Rescue.Towing_Flag__c);
        This.CurrencyPrice = (This.CurrencyPrice != NULL) ? This.CurrencyPrice : 0.0;
        This.Rescue.CSS_WS_Towing_Amount_MXN__c = (This.Rescue.CSS_WS_Towing_Amount_MXN__c != NULL) ? This.Rescue.CSS_WS_Towing_Amount_MXN__c : 0.00;
        This.Rescue.CSS_WS_TowingAmount__c = CurrencyPrice * This.Rescue.CSS_WS_Towing_Amount_MXN__c;
    }
    
    Public Void RR35RR36RR37(){//Rule RR-35, RR-36 and RR-37
        if(Rescue.CSS_WS_SignalBy__c != null){
            if(Rescue.CSS_WS_SignalBy__c.toUpperCase() == 'CUSTOMER' || Rescue.CSS_WS_SignalBy__c.toUpperCase() == 'CUSTOMER'){
                Rescue.CSS_WS_TravelKmRoundTripPolicy__c = 0;
                Rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 0;
                Rescue.CSS_WS_RescueCost__c = 0;
            }
        }       
    }
    
    Public Void RR02RR04(){
        if(this.Rescue.CSS_WS_Engine_Serial_Number__c != null && this.Rescue.CSS_WS_Engine_Serial_Number__c != '' && this.Rescue.CSS_WS_Years_In_Service__c >= 0 && this.Rescue.CSS_WS_Years_In_Service__c != null) { 
            if(this.Rescue.CSS_WS_Years_In_Service__c <= 4){//Rule RR-02, RR-03 and RR-04
                if(this.Rescue.CSS_WS_Engine_Application_Code__c == '130' || this.Rescue.CSS_WS_Engine_Application_Code__c == '210' || this.Rescue.CSS_WS_Engine_Application_Code__c == '220'){
                    this.Rescue.CSS_WS_Charged_To__c = 'Planta Automotriz';
                } else {
                    this.Rescue.CSS_WS_Charged_To__c = 'Planta Fuera de Carretera';
                }         
            } else {
                if(this.Rescue.CSS_WS_Years_In_Service__c > 4){
                    this.Rescue.CSS_WS_Charged_To__c = 'Cliente';
                }
            }    
        } else {
            this.Rescue.CSS_WS_Charged_To__c = null;
        }
        R04127_SF32();
    }
    
    Public Void R04067_SF17(){
        if(this.Rescue.CSS_WS_Failure_Point_Quantity__c != null && this.Rescue.CSS_WS_Failure_Point_Quantity__c != ''){
            if(this.Rescue.CSS_WS_Failure_Point_Quantity__c < '0' || this.Rescue.CSS_WS_Failure_Point_Quantity__c.isNumeric() != true){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Rescue_E013));//Failure Point cannot be less than zero
                this.Rescue.CSS_WS_Failure_Point_Quantity__c = '';
            }          
        }
    }    
    
    Public Void R04127_SF32(){
        if(this.Rescue.CSS_WS_Warranty_Start_Date__c != null && this.Rescue.CSS_WS_Build_Date__c != null){
            if(this.Rescue.CSS_WS_Warranty_Start_Date__c < this.Rescue.CSS_WS_Build_Date__c){//Rule RR-19
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E064));//Warranty Start Date must be later than Engine Build Date
                this.Rescue.CSS_WS_Warranty_Start_Date__c = null;
            }
        }       
    }
    
    Public Void delTowingInfo(){//Rule RR-38
        //Validation to not request towing and travel at same time - Oct 7th 2020
        if(this.Rescue.Towing_Flag__c == true && (this.Rescue.CSS_WS_TravelKmRoundTripPolicy__c > 0 || this.Rescue.CSS_WS_TravelHoursRoundTripPolicy__c > 0 || this.Rescue.CSS_WS_LunchAmount_MXN__c > 0 || this.Rescue.CSS_WS_Lodging_Amount_MXN__c > 0)){
            this.Rescue.Towing_Flag__c = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Rescue_E060));//It is not possible to request Towing when Travel, Lunch and Lodging is being requested at same time.
        } 
        this.Rescue.CSS_WS_Towing_Amount_MXN__c = null;
        this.Rescue.CSS_WS_TowingAmount__c = null;
        this.Rescue.CSS_WS_Authorizer__c = '';
        this.Rescue.CSS_WS_Crane_Justification__c = '';
    }
    
    Public Void FailureIsProductProblem(){
        this.Rescue.CSS_WS_FailureRelatedTo__c = '';
        this.Rescue.CSS_WS_TechnicianPromotion__c = '';
        this.Rescue.CSS_WS_OtherObservation__c = '';
    }
    
    // This method will return a map of SPCodes of DRs where the current user is associated to (Public Groups) 
    Public Map<String, String> getSPCodeMapRegion (){
        Map<String, String> spcode_group = new Map<String, String>();
        spcode_group.put('CSS_WS_Group_Alesso_Altamira', '00863');    
        spcode_group.put('CSS_WS_Group_Alesso_Leon', '74798');    
        spcode_group.put('CSS_WS_Group_Alesso_Metropolitano', '54699'); 
        spcode_group.put('CSS_WS_Group_Alesso_Monterrey', '73011'); 
        spcode_group.put('CSS_WS_Group_Alesso_Nuevo_Laredo', '56092'); 
        spcode_group.put('CSS_WS_Group_Alesso_Occidente', '56155'); 
        spcode_group.put('CSS_WS_Group_Tijuana', '54809'); 
        spcode_group.put('CSS_WS_Group_Costa_Rica', '56153'); 
        spcode_group.put('CSS_WS_Group_El_Salvador', '55108'); 
        spcode_group.put('CSS_WS_Group_Honduras', '55910'); 
        spcode_group.put('CSS_WS_Group_Panama', '04734'); 
        spcode_group.put('CSS_WS_Group_Megamak_Noroeste', '54681'); 
        spcode_group.put('CSS_WS_Group_Megamak_Occidente', '54701'); 
        spcode_group.put('CSS_WS_Group_Megamak_Oriente', '40711'); 
        spcode_group.put('CSS_WS_Group_Megamak_Pacifico', '54665'); 
        spcode_group.put('CSS_WS_Group_Megamak_Sureste', '54700'); 

        system.debug('map of spcode and groups: ' + spcode_group);

        List<GroupMember> group_list = new List<GroupMember>();
        group_list = [SELECT Group.DeveloperName FROM GroupMember WHERE UserOrGroupId = :UserInfo.getUserId() AND Group.Type = 'Regular'];

        system.debug('list of groups where im part of: ' + group_list);

        Map<String, String> spcode_group_region = new Map<String, String>();
        for (GroupMember public_group : group_list){
            if (spcode_group.containsKey(public_group.Group.DeveloperName)){ 
                    spcode_group_region.put(spcode_group.get(public_group.Group.DeveloperName), spcode_group.get(public_group.Group.DeveloperName));
            }   
        }
        system.debug(spcode_group_region);
        return(spcode_group_region);
    }
    
    Public Boolean getPermissionSet(String permission_set_name){
        List<PermissionSetAssignment> permission_set_list = new List<PermissionSetAssignment>();
        permission_set_list = [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() AND PermissionSet.Name = :permission_set_name];
        if(permission_set_list.size() > 0){
            return(true);
        } else {
            return(false);
        }
    }
}