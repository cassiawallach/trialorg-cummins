Public Class CSS_WS_ControllerClaim {
    
    Public CSS_WS_Warranty__c claim { get; set; }
    Public CSS_WS_Rescue__c rescue { get; set; } 
    Public CSS_WS_J2A_GetAccountCoverage campaignCoverageResponse { get; set; }
    Public CSS_WS_J2A_GetSPData SPDataResponse { get; set; }
    Private ApexPages.StandardController stdController;
    Public RecordType rt { get; set; }
    Public Id SelectedRowId { get; set; }    
    Public Map<String, CSS_WS_J2A_GetCampaignData.Details> campaingsTem { get; set;}
    Public List<SelectOption> optionsCam { get; set; }
    Public List<Attachment> attachment_list { get; set; }  
    Public Static List<String> odmWarnings {get; set;}
    Public Static Boolean ignoreWarnings {get; set;}
    Public String ESNR { get; set; } 
    Public String complaints1 { get; set; }
    Public String complaints2 { get; set; } 
    Public String LogInVariable { get; set; }    
    Public String TabInFocus { get; set; } 
    Public String Penaltytem { get; set; }
    Public String laborRate { get; set; }
    Public Integer counter { get; set; }
    Public Integer signalTime { get; set; }
    Public Integer editManufacturerFlag { get; set; }
    Public Decimal additionalKmAmount {get; set;}
    Public Decimal additionalHrAmount {get; set;}
    Public Boolean displayPopup {get; set;}
    Public Boolean isDay { get; set; }
    Public Boolean distributorsDisable { get; set; }
    Public Boolean dealersDisable { get; set; }
    Public Boolean warrantyStartDateFlag { get; set; }
    Public Boolean flagSRT { get; set; }
    Public Boolean showPaccar { get; set; } 
    Public Boolean disableHeader { get; set; } 
    Public Boolean disablePolicy { get; set; }  
    Public Boolean disableFailure { get; set; } 
    Public Boolean disableMultiESN { get; set; }
    Public Boolean disableNarrative { get; set; }
    Public Boolean disableSRT { get; set; }  
    Public Boolean disableParts { get; set; } 
    Public Boolean disableTravel { get; set; }  
    Public Boolean disableClaimable { get; set; } 
    Public Boolean disablePayment { get; set; }  
    Public Boolean disableWarrantyLog { get; set; } 
    Public Boolean showSaveTravelButton { get; set; }
    Public Boolean showSaveNarrativeButton { get; set; }
    Public Boolean disablePolicyLog { get; set; } 
    Public Boolean showPolicy { get; set; }  
    Public Boolean showMultiESN { get; set; }
    Public Boolean isMexico { get; set; }
    Public Boolean isPaccar { get; set; } 
    Public Boolean showRescueTable {get; set; }
    Public Boolean showTravel { get; set; }
    Public Boolean showHeader { get; set; }
    Public Boolean editWSDFlag { get; set; }
    Public Boolean editModelSeriesFlag { get; set; }
    Public Boolean editEngineApplicationFlag { get; set; }
    Public Boolean isDRRegion { get; set; }
    Public Boolean enableCloneButton { get; set; }
    Public Map<String, String> group_region { get; set;}

    Public CSS_WS_ControllerClaim(ApexPages.StandardController stdController){
        System.debug('Inicio CSS_WS_ControllerClaim ****** CSS_WS_ControllerClaim');
        this.claim = (CSS_WS_Warranty__c)stdController.getRecord();
        this.enableCloneButton = getPermissionSet('CSS_WS_Paccar')? False: True;
        this.stdController = stdController;
        this.isMexico = false;
        this.rescue = null;
        this.showTravel = false;
        this.showRescueTable = false;
        this.displayPopup = false;
        this.attachment();
        counter = 0;
        Id id = ApexPages.currentPage().getParameters().get('id');
        String IsClone = ApexPages.currentPage().getParameters().get('clone');
        Decimal IsClaimCloned = 0;
        if(id != null){
            IsClaimCloned = [SELECT Is_Clone__c FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id].Is_Clone__c;
        }      
        if(IsClone != '1' && IsClone != '2'){
            if (id == null || IsClaimCloned == 1){
                editWSDFlag = false;
                showSaveTravelButton = false;
                showSaveNarrativeButton = false;
                showHeader=true;
                warrantyStartDateFlag = false;
                disableHeader=False;
                disablePolicy=True;  
                disableFailure=True;  
                disableMultiESN=True;  
                disableNarrative=True; 
                disableSRT=True;  
                disableParts=True;  
                disableTravel=True;  
                disableClaimable=True;  
                disablePayment=True;  
                disableWarrantyLog=True;  
                disablePolicyLog=True;  
                showPolicy=False;  
                showMultiESN=False;
                showPaccar=True;
                editManufacturerFlag = 0;
                editModelSeriesFlag = false;
                editEngineApplicationFlag = false;
                rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Header' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];  
                this.claim.RecordTypeId = rt.Id; 
                flagSRT = false;
                if((IsClaimCloned == 1)){ //When the claim is a clone
                    CSS_WS_J2A_GetEngineData objec = CSS_WS_GetWebServiceData.getEngineData(this.claim.CSS_WS_Engine_Serial_Number__c);//Web service call
                    if(objec != null){
                        if(objec.Header.Status.touppercase() == 'SUCCESS'){ 
                            if(objec.DataArea != null){
                                CSS_WS_Engine_Application_Code__c code = mapEngineApplication(objec.DataArea.EngineAppDesc);                      
                                this.claim.CSS_WS_Engine_Application__c = code != null ? code.Application_Description__c : '';
                                this.claim.CSS_WS_Engine_Application_Code__c = code != null ? code.Name : '';
                                this.claim.CSS_WS_Failure_Measure__c= code != null ? code.Default_Measurement__c : '';//Rule SF31
                                this.claim.CSS_WS_Engine_Family_Code__c = objec.DataArea.EngineFamilyCode;
                                getManufacturerSelectListOp();
                                if(this.claim.CSS_WS_Engine_Application__c != null && this.claim.CSS_WS_Engine_Application__c != ''){
                                    editEngineApplicationFlag = true;
                                }
                                if(objec.DataArea.Manufacturer != null){
                                    this.claim.CSS_WS_Manufacturer__c = objec.DataArea.Manufacturer;
                                    editManufacturerFlag++;
                                }
                                getManufacturerSelectListOp();
                                if(objec.DataArea.Model != null){
                                    this.claim.CSS_WS_Model_Series__c = objec.DataArea.Model;
                                }
                                if(objec.DataArea.CustomerName != null){
                                    this.claim.CSS_WS_Customer_Name__c = objec.DataArea.CustomerName;
                                }
                                if(objec.DataArea.ServiceModelName != null){
                                    this.claim.CSS_WS_Service_Model__c = objec.DataArea.ServiceModelName;
                                }
                                if(this.claim.CSS_WS_Warranty_Type__c != 'Parte' && this.claim.CSS_WS_Warranty_Type__c != 'Part' && this.claim.CSS_WS_Warranty_Subtype__c != 'BIS' ){
                                    this.claim.CSS_WS_Warranty_Start_Date__c = stringToDate(objec.DataArea.WarrantyStartDate, 'YYYY-MM-DDTHH:MM:SS');
                                } 
                                if(this.claim.CSS_WS_Warranty_Start_Date__c != null){
                                    warrantyStartDateFlag = true;
                                }      
                                if(objec.DataArea.WarrantyStartDate != null){                                           
                                    editWSDFlag = true;                       
                                } 
                            }
                        }
                    }     
                    if(this.claim.CSS_WS_Warranty_SubType__c == 'BIS'){
                         warrantyStartDateFlag = true;
                    }
                } else {//When de claim is new
                    this.claim.CSS_WS_Policy_Flag__c = 'Warranty';
                    this.claim.CSS_WS_Catastrophic__c = 'No';
                    this.claim.CSS_WS_Warranty_Type__c = 'Motor';
                    this.claim.CSS_WS_Warranty_SubType__c = 'No BIS';
                    this.claim.CSS_WS_Belongs_To__c = 'DR';
                    this.claim.CSS_WS_Replacement_Part__c = '';
                    this.claim.CSS_WS_Mission_Disabling_Severity_Code__c = 'B';                    
                }
            } else if((IsClaimCloned == null || IsClaimCloned != 1) && id != null){
                showHeader = False;
                disableHeader = True;
                disablePolicy = True;  
                disableFailure = True;  
                disableMultiESN = True;  
                disableNarrative = True; 
                disableSRT = True;  
                disableParts = True;  
                disableTravel = True;  
                disableClaimable = True;  
                disablePayment = True;  
                disableWarrantyLog = True;  
                disablePolicyLog = True;  
                showPolicy = False;  
                showMultiESN = False;
                if(this.claim.CSS_WS_Policy_Flag__c == 'Policy' && (this.claim.CSS_WS_Account_Code__c == 'P88' || this.claim.CSS_WS_Account_Code__c == 'P93' || this.claim.CSS_WS_Account_Code__c == 'P99' || this.claim.CSS_WS_Account_Code__c == 'P100' || this.claim.CSS_WS_Account_Code__c == 'P101')){
                    showPolicy=True;
                    disablePolicy=False;            
                    TabInFocus='PolicyTab';  
                    this.getCustomerSupportEngineer();  
                } else {    
                    disableFailure=False;           
                    TabInFocus='FailureTab';    
                    rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Failure' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
                    this.claim.RecordTypeId = rt.Id;   
                }
                if(this.claim.CSS_WS_Multi_ESN__c){
                    showMultiESN = True;
                }
                if(this.claim.CSS_WS_Labor_Rate__c == null || this.claim.CSS_WS_Labor_Rate__c == '0' || this.claim.CSS_WS_Labor_Rate__c == ''){
                    flagSRT = true;
                } else {
                    flagSRT = false;
                }
                this.calculateTotalTravelAmount();
            }
            this.group_region = this.getSPCodeMapRegion();
            if(this.group_region.IsEmpty()){
                this.isDRRegion = false;
            } else {
                this.isDRRegion = true;
            }
            if (this.claim.CSS_WS_Account_Code__c == 'P101' && (this.claim.CSS_WS_Product_Application_Code__c == null || this.claim.CSS_WS_Labor_Rate__c == null)){
                this.getSPData();
                this.getESNPolicyP101();
            }
            this.getSPList();
        }
    }
    
    Public CSS_WS_Rescue__c getRescueNumber(String esn, String dealer, Datetime failureDate, String rescueNumber, String policyFlag){
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c();
        if(policyFlag.toUpperCase() == 'POLICY WW'){
            policyFlag = 'Warranty';
        }
        try{
            if(rescueNumber != null && rescueNumber != ''){
                rescue = [
                    SELECT Name, 
                    CSS_WS_Engine_Serial_Number__c, 
                    CSS_WS_Service_Provider_Dealer__c, 
                    CSS_WS_TravelKmRoundTrip__c,
                    CSS_WS_AdditionalKmDriven__c,
                    CSS_WS_AdditionalHours__c,
                    CSS_WS_TravelHoursRoundTripPolicy__c,
                    CSS_WS_TravelKmRoundTripPolicy__c,
                    CSS_WS_MinimumFare__c,
                    CSS_WS_AdditionalKMDrivenAmount__c,
                    CSS_WS_AdditionalHoursAmount__c,
                    CSS_WS_TowingAmount__c,
                    CSS_WS_Lodging_Amount__c,
                    CSS_WS_TravelHoursRoundTrip__c, 
                    CreatedDate,
                    CSS_WS_SignalTime__c,
                    CSS_WS_Warranty_Relationship__c,
                    CSS_WS_BaseFare__c,
                    CSS_WS_RescueCost__c,
                    CSS_WS_LunchAmount__c
                    FROM CSS_WS_Rescue__c WHERE Name = :rescueNumber LIMIT 1];
            } else {
                Date failureD = date.newinstance(failureDate.year(), failureDate.month(), failureDate.day());
                //System.debug(failureD);
                rescue = [
                    SELECT Name, 
                    CSS_WS_Engine_Serial_Number__c, 
                    CSS_WS_Service_Provider_Dealer__c, 
                    CSS_WS_TravelKmRoundTrip__c,
                    CSS_WS_AdditionalKmDriven__c,
                    CSS_WS_AdditionalHours__c,
                    CSS_WS_BaseFare__c,
                    CSS_WS_TravelHoursRoundTripPolicy__c,
                    CSS_WS_TravelKmRoundTripPolicy__c,
                    CSS_WS_MinimumFare__c,
                    CSS_WS_AdditionalKMDrivenAmount__c,
                    CSS_WS_AdditionalHoursAmount__c,
                    CSS_WS_TowingAmount__c,
                    CSS_WS_Lodging_Amount__c,
                    CSS_WS_TravelHoursRoundTrip__c, 
                    CreatedDate,
                    CSS_WS_SignalTime__c,
                    CSS_WS_RescueCost__c,
                    CSS_WS_Warranty_Relationship__c,
                    CSS_WS_LunchAmount__c
                    FROM CSS_WS_Rescue__c WHERE CSS_WS_ServiceRequest__c > :failureD AND CSS_WS_Engine_Serial_Number__c = :esn
                    AND CSS_WS_Service_Provider_Dealer__c = :dealer AND CSS_WS_Warranty_Relationship__c = null AND CSS_WS_RescueStatus__c = 'Authorized by Planta'
                    AND CSS_WS_SignalBy__c = :policyFlag
                    LIMIT 1];
            }
        } catch(Exception ex){
            rescue = null;
            //System.debug(ex.getMessage());
        }        
        return rescue;
    }
    
    Public CSS_WS_Engine_Application_Code__c mapEngineApplication(String engineApplicationCodeStr){
        try {
            CSS_WS_Engine_Application_Code__c engineApplicationCode = [
                SELECT Name, Application_Description__c, Default_Measurement__c, Automotive_Flag__c, Marine_Flag__c
                FROM CSS_WS_Engine_Application_Code__c WHERE Application_Description__c =: engineApplicationCodeStr];//Rule SF55          
            return engineApplicationCode;
        } catch (Exception e){
            return null;
        }
    }
        
    Public List<SelectOption> getEngineApplications() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        // Find all the countries in the custom setting
        Map<String, CSS_WS_Engine_Application_Code__c> codes = CSS_WS_Engine_Application_Code__c.getAll();//Rule SF55    
        List<String> codesName = new List<String>();
        codesName.addAll(codes.keySet());
        codesName.sort();        
        // Create the Select Options.
        for(String codeName : codesName) {
            // Validation to add only "Off Highway" engine application codes when P99 is selected. Otherwise, all engine application codes are added. - Sep 7th 2020
            if(this.claim.CSS_WS_Account_Code__c == 'P99'){
                if(codes.get(codeName).Name == '210' || codes.get(codeName).Name == '410' || codes.get(codeName).Name == '510' || codes.get(codeName).Name == '520' || codes.get(codeName).Name == '530' || codes.get(codeName).Name == '610' || codes.get(codeName).Name == '620' || codes.get(codeName).Name == '635' || codes.get(codeName).Name == '650' || codes.get(codeName).Name == '655' || codes.get(codeName).Name == '660' || codes.get(codeName).Name == '662' || codes.get(codeName).Name == '663' || codes.get(codeName).Name == '810' || codes.get(codeName).Name == '820' || codes.get(codeName).Name == '850' || codes.get(codeName).Name == '890' || codes.get(codeName).Name == '891'){
                    CSS_WS_Engine_Application_Code__c code = codes.get(codeName);
                    options.add(new SelectOption(code.Name, code.Application_Description__c));
                }
            } else {
                CSS_WS_Engine_Application_Code__c code = codes.get(codeName);
                options.add(new SelectOption(code.Name, code.Application_Description__c));
            }
        }
        return options;
    }
    
    Public List<SelectOption> getManufacturerSelectList(){
    //Generates manufacturer dropdown from manufacturer settings
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',Label.CSS_WS_Selection_None)); 
        AggregateResult[] manufacturers;
        if(this.claim.CSS_WS_Engine_Family_Code__c != null && this.claim.CSS_WS_Engine_Serial_Number__c != null){
            if(!String.isEmpty(this.claim.CSS_WS_Engine_Family_Code__c)){
                manufacturers = [SELECT CSS_WS_Make__c FROM CSS_WS_Make_And_Model__c WHERE CSS_WS_Engine_Family_Code__c =: this.claim.CSS_WS_Engine_Family_Code__c 
                                AND CSS_WS_Status__c = 'ACTIVE' GROUP BY CSS_WS_Make__c];       
            } //else if(this.claim.CSS_WS_Engine_Serial_Number__c != null){
              // manufacturers = [SELECT CSS_WS_Equip_Manufacturer__c FROM CSS_WS_Access_Code_Master_Catalog__c GROUP BY CSS_WS_Equip_Manufacturer__c];       
              //}
        } else {
            return options;
        }
        for(AggregateResult manufacturer : manufacturers){
            options.add(new SelectOption((String)manufacturer.get('CSS_WS_Make__c'), (String)manufacturer.get('CSS_WS_Make__c')));
        }
        if(editManufacturerFlag == 1){
            for(AggregateResult m : manufacturers){
                if(m.get('CSS_WS_Make__c') == this.claim.CSS_WS_Manufacturer__c){                
                    editManufacturerFlag ++;
                    break;                    
                } 
            }
            if(editManufacturerFlag == 1){
                editManufacturerFlag = 0;
            }
        } 
        if(this.claim.CSS_WS_Engine_Serial_Number__c == '10000000'){
            options.add(new SelectOption('UNLISTED','UNLISTED'));//Add label
            this.claim.CSS_WS_Manufacturer__c = 'UNLISTED'; 
        }
        return options;
    }
    
    Public List<SelectOption> getModelSeriesSelectList(){
    //To generate the model series picklist based on the manufacturer selected by user.
        List<SelectOption> options = new List<SelectOption>();        
        List<CSS_WS_Make_And_Model__c> mSeries = new List<CSS_WS_Make_And_Model__c>();
        editModelSeriesFlag = false;
        if(!String.isEmpty(this.claim.CSS_WS_Manufacturer__c) && !String.isEmpty(this.claim.CSS_WS_Engine_Family_Code__c)){//Rule SF20
            mSeries = [SELECT CSS_WS_Model__c, CSS_WS_Make__c FROM CSS_WS_Make_And_Model__c 
                       WHERE CSS_WS_Make__c =: this.claim.CSS_WS_Manufacturer__c 
                       AND CSS_WS_Engine_Family_Code__c =: this.claim.CSS_WS_Engine_Family_Code__c
                       AND CSS_WS_Status__c = 'ACTIVE'];
        } else {
            mSeries = [SELECT CSS_WS_Model__c FROM CSS_WS_Make_And_Model__c 
                       WHERE CSS_WS_Make__c =: this.claim.CSS_WS_Manufacturer__c AND CSS_WS_Status__c = 'ACTIVE'];
        }      
        for(CSS_WS_Make_And_Model__c s : mSeries){
            if(s.CSS_WS_Model__c == this.claim.CSS_WS_Model_Series__c){
                editModelSeriesFlag = true;
                break;
            }
        }
        //Generate the Select Options based on the final sorted list
        options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        for(CSS_WS_Make_And_Model__c mS : mSeries) {
            options.add(new SelectOption(mS.CSS_WS_Model__c, mS.CSS_WS_Model__c));
        }
        if(this.claim.CSS_WS_Engine_Serial_Number__c == '10000000'){
            options.add(new SelectOption('ALL','ALL'));//Add label  
            this.claim.CSS_WS_Model_Series__c = 'ALL';
        }
        return options;
    }
    
    Public List<SelectOption> getCampaings(){
        this.optionsCam = new List<SelectOption>();
        campaingsTem = new Map<String, CSS_WS_J2A_GetCampaignData.Details>();
        optionsCam.add(new SelectOption('',Label.CSS_WS_Selection_None));
        if(String.isEmpty(this.claim.CSS_WS_Engine_Serial_Number__c) == false && this.claim.CSS_WS_Failure_Date_Time__c != null) {                      
            List<String> data = new String[2];
            data[0] = this.claim.CSS_WS_Engine_Serial_Number__c;
            data[1] = CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Failure_Date_Time__c, 'dd-MMM-yyyy');
            CSS_WS_J2A_GetCampaignData objec = CSS_WS_GetWebServiceData.getCampaignData(data); 
            if(objec != null){
                if(objec.Header.Status.touppercase() == 'SUCCESS'){
                    if(objec.DataArea != null){
                        for(integer i=0; i<objec.DataArea.Details.size(); i++){
                            if(!campaingsTem.containsKey(objec.DataArea.Details[i].CampaignNumber)){
                                campaingsTem.put(objec.DataArea.Details[i].CampaignNumber, objec.DataArea.Details[i]);
                            }                         
                        }                         
                    }   
                    for(String CampID: campaingsTem.keySet()){
                        optionsCam.add(new SelectOption(CampID, campaingsTem.get(CampID).CampaignDesc + ' (' + CampID + ')'));
                    }              
                    return optionsCam;
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objec.Header.ReturnCodeDescription));
                    return null;
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                System.debug('Null Campaign Object');
                return null;
            }
        } else {
            this.claim.CSS_WS_Campaigns_TRPs__c = null;
            return null;    
        }    
    }
    
    Public List<SelectOption> getComplaintsSelectList(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        List<CSS_WS_Complaints_Master_Catalogue__c> complaints = [
            SELECT CSS_WS_Code_Name__c, CSS_WS_Desc_Text__c FROM CSS_WS_Complaints_Master_Catalogue__c
            WHERE CSS_WS_Code_Name__c != null ORDER BY CSS_WS_Desc_Text__c];
        if(complaints.size() > 0){
            for(CSS_WS_Complaints_Master_Catalogue__c complaint : complaints){//Create the Select Options
                options.add(new SelectOption(complaint.CSS_WS_Code_Name__c, complaint.CSS_WS_Desc_Text__c));
            }
        }
        return options;
    }
    
    Public List<SelectOption> getComplaintsRest1(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        List<CSS_WS_Complaints_Master_Catalogue__c> complaints = [
            SELECT CSS_WS_Code_Name__c, CSS_WS_Desc_Text__c FROM CSS_WS_Complaints_Master_Catalogue__c 
            WHERE CSS_WS_Code_Name__c !=: this.complaints1 AND CSS_WS_Code_Name__c != null ORDER BY CSS_WS_Desc_Text__c];//Rule SF11
        if(complaints.size() > 0){
            for(CSS_WS_Complaints_Master_Catalogue__c complaint : complaints){//Create the Select Options
                options.add(new SelectOption(complaint.CSS_WS_Code_Name__c, complaint.CSS_WS_Desc_Text__c));
            }
        }
        return options;
    }
    
    Public List<SelectOption> getComplaintsRest2(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        List<CSS_WS_Complaints_Master_Catalogue__c> complaints = [
            SELECT CSS_WS_Code_Name__c, CSS_WS_Desc_Text__c FROM CSS_WS_Complaints_Master_Catalogue__c                                                     
            WHERE CSS_WS_Code_Name__c !=: this.complaints1 AND CSS_WS_Code_Name__c !=: this.complaints2                                                                
            AND CSS_WS_Code_Name__c != null ORDER BY CSS_WS_Desc_Text__c ];//Rule SF11
        if( complaints.size() > 0){
            for(CSS_WS_Complaints_Master_Catalogue__c complaint : complaints){//Create the Select Options
                options.add(new SelectOption(complaint.CSS_WS_Code_Name__c, complaint.CSS_WS_Desc_Text__c));
            }
        }
        return options;
    }
    
    Public List<SelectOption> getDistributorsSelectList(){
        List<SelectOption> distributors = new List<SelectOption>();
        distributors.add(new SelectOption('',Label.CSS_WS_Selection_Distributor)); 
        List<Account> distributorAccounts = new List<Account>();
        distributorAccounts = [SELECT Name, CSS_DBCode__c, IAM_Service_Provider_Code__c, CMI_Account_Status__c FROM Account WHERE (Type = 'Distributor Account' OR Type = 'Distributor Branch Account')
            AND  (IAM_Service_Provider_Code__c = '56153' OR IAM_Service_Provider_Code__c = '54699' OR IAM_Service_Provider_Code__c = '54809' OR IAM_Service_Provider_Code__c = '55910' 
            OR IAM_Service_Provider_Code__c = '04734' OR IAM_Service_Provider_Code__c = '54700' OR IAM_Service_Provider_Code__c = '55108' OR IAM_Service_Provider_Code__c = '56155' 
            OR IAM_Service_Provider_Code__c = '74798' OR IAM_Service_Provider_Code__c = '54681' OR IAM_Service_Provider_Code__c = '73011' OR IAM_Service_Provider_Code__c = '54665' 
            OR IAM_Service_Provider_Code__c = '56092' OR IAM_Service_Provider_Code__c = '54701' OR IAM_Service_Provider_Code__c = '40711' OR IAM_Service_Provider_Code__c = '00863' 
            OR IAM_Service_Provider_Code__c = '54734') AND (CMI_Account_Status__c = 'Active') ORDER BY Name];
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
        if(!String.isEmpty(this.claim.CSS_WS_Service_Provider_DR__c)){
            dealerAccounts = [SELECT Name, CSS_DBCode__c, IAM_Service_Provider_Code__c, CMI_Account_Status__c FROM Account WHERE 
                              CSS_DBCode__c =: this.claim.CSS_WS_Service_Provider_DR__c AND (type = 'Dealer Account' OR 
                              type = 'Distributor Account' OR type = 'Dealer Branch Account' OR 
                              type = 'Distributor Branch Account') AND (CMI_Account_Status__c = 'Active') ORDER BY Name];
            for(Account dealer : dealerAccounts){
                if(dealer.IAM_Service_Provider_Code__c != null && dealer.Name  != null){
                    dealers.add(new SelectOption((String)dealer.IAM_Service_Provider_Code__c, (String)dealer.Name));
                }
            }
        }
        return dealers;
    }
    
    Public List<SelectOption> getPolicyOptionsByDR() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Warranty','Warranty'));
        if(this.claim.CSS_WS_Service_Provider_DR__c != null){          
            Account[] Contrys = [SELECT BillingCountry, CSS_DBCode__c, IAM_Service_Provider_Code__c, CMI_Account_Status__c FROM Account WHERE (Type =: 'Distributor Account' OR Type =: 'Distributor Branch Account') AND (IAM_Service_Provider_Code__c =: this.claim.CSS_WS_Service_Provider_DR__c) AND (CMI_Account_Status__c =: 'Active')  LIMIT 1]; 
            if(Contrys != null){   
                if(Contrys[0].IAM_Service_Provider_Code__c == '54734' && this.claim.CSS_WS_Service_Provider_Dealer__c == '54734'){
                    this.claim.CSS_WS_Service_Provider_Dealer__c = '54734';
                    options.add(new SelectOption('Policy','Policy'));
                    options.add(new SelectOption('Policy WW','Policy WW'));
                    return options;                    
                } else if(Contrys[0].BillingCountry.toUpperCase() == 'MEXICO'){
                    options.add(new SelectOption('Policy','Policy'));
                    /*if(this.claim.CSS_WS_Service_Provider_Dealer__c == this.claim.CSS_WS_Service_Provider_DR__c && this.claim.CSS_WS_Login_Variable__c == 'FactoryLoggedIn'){//Factory can select Policy WW for any DR from Mexico
                        options.add(new SelectOption('Policy WW','Policy WW'));
                    }*/ 
                    // Now Policy WW option will be available for all users including Factory, DR y Dealers, even if there are from MX or CA - March 8th 2021
                    options.add(new SelectOption('Policy WW','Policy WW'));
                    return options;                    
                } else {
                    /*if(this.claim.CSS_WS_Service_Provider_Dealer__c == this.claim.CSS_WS_Service_Provider_DR__c){//Only Distributor can select Policy WW
                        options.add(new SelectOption('Policy WW','Policy WW'));
                    }*/
                    // Now Policy WW option will be available for all users including Factory, DR y Dealers, even if there are from MX or CA - March 8th 2021
                    options.add(new SelectOption('Policy WW','Policy WW'));
                    return options;
                }
                
            }
        }
        return options;
    }
          
    Public List<SelectOption> getAccountCodesSelectList(){
        List<SelectOption> accountCodesList = new List<SelectOption>();
        accountCodesList.add(new SelectOption('', Label.CSS_WS_Selection_Account_Code));
        AggregateResult[] accountCodes = [SELECT CSS_WS_Account_Code__c FROM CSS_WS_Account_Code_for_Warranty_Catalog__c 
                                          WHERE CSS_WS_Usage__c =: this.claim.CSS_WS_Policy_Flag__c GROUP BY CSS_WS_Account_Code__c];
        //Generate the Select Options based on the final sorted list
        for(AggregateResult accountCode : accountCodes){
            // Validation to add the P99 option for DR and Factory. Otherwise, this option is not added. - Sep 7th 2020
            if (accountCode.get('CSS_WS_Account_Code__c') == 'P99' && this.claim.CSS_WS_Login_Variable__c == 'DealerLoggedIn'){
                //P99 Account Code is not added for Dealers.
            // Account Code 61 is now available for all; into the Policy WW option.- March 8th 2021
            // } else if (accountCode.get('CSS_WS_Account_Code__c') == '61' && this.claim.CSS_WS_Service_Provider_Dealer__c != '54734'){
                //61 Account Code is not added for all; just it is added for "54734" SPCode. - Oct 6th 2020
            } else {
                accountCodesList.add(new SelectOption((String)accountCode.get('CSS_WS_Account_Code__c'), (String)accountCode.get('CSS_WS_Account_Code__c')));
            }
        }
        return accountCodesList;
    }
    
    Public List<SelectOption> getPayCodeList(){
        List<SelectOption> pay_code = new List<SelectOption>();
        pay_code.add(new SelectOption('',Label.CSS_WS_Selection_Pay_Code));
        pay_code.add(new SelectOption('I', 'I - Distribuidor Internacional'));
        pay_code.add(new SelectOption('R', 'R - Dealer Internacional'));
        pay_code.add(new SelectOption('T', 'T - Distribuidor Internacional (10% PMU, 80% MO, 80% Viaje)'));
        pay_code.add(new SelectOption('C', 'C - Dealer Internacional (10% PMU, 80% MO, 80% Viaje)'));
        pay_code.add(new SelectOption('S', 'S - Distribuidor Internacional (0% PMU, 50% MO, 50% Viaje)'));
        pay_code.add(new SelectOption('L', 'L - Dealer Internacional (0% PMU, 50% MO, 50% Viaje)'));
        pay_code.add(new SelectOption('A', 'A - Solo informativo'));   
        pay_code.add(new SelectOption('P', 'P - Distributor Net Not Markup'));
        pay_code.add(new SelectOption('T', 'T - Programas de Politica o de Garantia Especial ReCon')); 
        pay_code.add(new SelectOption('X', 'X - Reparacion de Garantia del Distribuidor dentro de EE.UU. y Canada'));        
        return pay_code;
    }
    
    Public List<SelectOption> getPolicyCampaignList(){
        List<SelectOption> policyCampaign = new List<SelectOption>();
        policyCampaign.add(new SelectOption('',Label.CSS_WS_Selection_None));       
        if (this.claim.CSS_WS_Failure_Date_Time__c != null && this.claim.CSS_WS_Warranty_Start_Date__c != null && this.claim.CSS_WS_Customer_Name_Internal__c != null && this.claim.CSS_WS_Account_Code__c == 'P90'){
            //Obtain years in service
            Date failureDate = this.claim.CSS_WS_Failure_Date_Time__c.date();
            Date warrantyStartDate = this.claim.CSS_WS_Warranty_Start_Date__c;             
            integer total_days = warrantyStartDate.daysBetween(failureDate);
            decimal years = decimal.valueof(total_days)/decimal.valueof(365);
            long years_in_service = years.round(RoundingMode.UP);
            //Get the name of the selected customer name internal 
            Account customer = [SELECT Name FROM Account WHERE id = :this.claim.CSS_WS_Customer_Name_Internal__c LIMIT 1];
            String business_name = '%' + customer.Name +'%' ; 
            //Filter to policy campaigns that applies for this claim
            List<CSS_WS_Policy_Campaign_Decision_table__c> policy_campaigns = [SELECT Name, Policy_Campaign_Name__c FROM CSS_WS_Policy_Campaign_Decision_table__c 
                    WHERE Business_Name__c LIKE :business_name AND Program_Start_Date__c <= :failureDate AND Program_End_Date__c >= :failureDate AND ((Exp_Years_In_Service__c = '<=' AND Years_In_Service__c >= :years_in_service) OR (Years_In_Service__c = :years_in_service AND Exp_Years_In_Service__c = ''))
                    ORDER BY Name];
            //Generate the Select Options based on the final sorted list
            for(CSS_WS_Policy_Campaign_Decision_table__c policy_campaign : policy_campaigns){
                policyCampaign.add(new SelectOption(policy_campaign.Policy_Campaign_Name__c, policy_campaign.Policy_Campaign_Name__c));
            }
        } 
        return policyCampaign; 
    }  
    
    Public PageReference getRouter(){
        PageReference p;
        Id claim_id = ApexPages.currentPage().getParameters().get('id');
        String IsClone = ApexPages.currentPage().getParameters().get('clone');   
        
        //Validation for not allowing create claims to "CSS_WS_Branch_Warranty_Manager" profile
        //String profileNameBranch='';
        //profileNameBranch = [SELECT Profile.Name FROM User WHERE Id =:UserInfo.getUserId() limit 1].Profile.Name;
        //if(profileNameBranch == 'CSS_WS_Branch_Warranty_Manager' && this.claim.Id == null){//*/
        if(getPermissionSet('CSS_WS_Branch_Warranty_Manager') && this.claim.Id == null){
            PageReference pageRef = new PageReference('/');
            pageRef.setRedirect(true);
            return pageRef;
        }
            
        if(this.claim.Id != null) {
            if(IsClone == '1'){
                CSS_WS_Warranty__c ClaimToClone = [
                    SELECT
                    CSS_WS_Service_Provider_DR__c,
                    CSS_WS_Service_Provider_Dealer__c,
                    CSS_WS_Engine_Serial_Number__c,
                    CSS_WS_Multi_ESN__c,
                    CSS_WS_Policy_Flag__c,
                    CSS_WS_Belongs_To__c,
                    CSS_WS_Warranty_Type__c,
                    CSS_Authorization_Number__c,
                    CSS_WS_Warranty_Subtype__c,
                    CSS_WS_Claim_Type__c,
                    CSS_WS_Account_Code__c,
                    CSS_WS_Pay_Code__c,
                    CSS_WS_Failure_Date_Time__c,
                    CSS_WS_Warranty_Start_Date__c,
                    CSS_WS_End_Repair_Date_Time__c,
                    CSS_WS_Failure_Point_Quantity__c,
                    CSS_WS_Customer_Name__c,
                    CSS_WS_Customer_Name_Internal__c,
                    CSS_WS_Engine_Application_Code__c,
                    CSS_WS_Campaigns_TRPs__c,
                    CSS_WS_Policy_Campaign__c,
                    CSS_WS_Service_Model__c,
                    CSS_WS_Manufacturer__c,
                    CSS_WS_VIN__c,
                    CSS_WS_Model_Series__c,
                    CSS_WS_Complaints1__c,
                    CSS_WS_Repair_Work_Order_Number__c,
                    CSS_WS_Complaints2__c,
                    CSS_WS_Complaints3__c,
                    CSS_WS_Mission_Disabling_Severity_Code__c,
                    CSS_WS_Replacement_Part__c,
                    CSS_WS_Repair_Description__c,
                    CSS_WS_Engine_Family_Code__c,
                    CSS_WS_Catastrophic__c,
                    CSS_WS_Failure_Measure__c
                    FROM CSS_WS_Warranty__c
                    WHERE Id =: this.claim.Id];
                if(userinfo.getUserType() == 'PowerCustomerSuccess'){
                   Contact userContact = [SELECT Account.Name FROM Contact WHERE Id In (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
                   Account userAccount = [SELECT CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE Account.Name =: userContact.Account.Name 
                   AND (type = 'Dealer Account' OR type = 'Distributor Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') AND (CMI_Account_Status__c = 'Active')];
                   if(userAccount != null){
                       if (userAccount.Type == 'Distributor Account' || userAccount.Type == 'Distributor Branch Account'){
                           ClaimToClone.CSS_WS_Login_Variable__c='DRLoggedIn';
                       } else if(userAccount.Type == 'Dealer Account' || userAccount.Type == 'Dealer Branch Account'){
                           ClaimToClone.CSS_WS_Login_Variable__c='DealerLoggedIn';
                       }
                   }
                } else {
                    ClaimToClone.CSS_WS_Login_Variable__c='FactoryLoggedIn';
                }
                
                //Validation to not clone claims already used for Reinstatements
                /*if(ClaimToClone.CSS_WS_Reinstatement_Flag__c){
                    system.debug ('Claim cannot be cloned due to it was used for Reinstatement');                       
                    PageReference pageRef = new PageReference('/' + String.valueof(claim_id));
                    pageRef.setRedirect(true);
                    return pageRef;
                } else {*/
                    ClaimToClone.CSS_WS_Claim_Status__c = 'Draft';
                    ClaimToClone.Is_Clone__c = 1;
                    ClaimToClone.Id = null;
                    insert ClaimToClone;
                    PageReference claimPage = new ApexPages.StandardController(ClaimToClone).edit(); 
                    claimPage.setRedirect(true); 
                    return claimPage;
                //}
                
            } else if(IsClone == '2'){
                CSS_WS_Warranty__c ClaimToClone = [
                    SELECT CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c,
                    CSS_WS_Engine_Serial_Number__c, CSS_WS_Multi_ESN__c,
                    CSS_WS_Policy_Flag__c,  CSS_WS_Belongs_To__c,
                    CSS_WS_Warranty_Type__c, CSS_Authorization_Number__c,
                    CSS_WS_Warranty_Subtype__c, CSS_WS_Claim_Type__c,
                    CSS_WS_Account_Code__c, CSS_WS_Pay_Code__c,
                    CSS_WS_Failure_Date_Time__c, CSS_WS_Warranty_Start_Date__c,
                    CSS_WS_End_Repair_Date_Time__c, CSS_WS_Failure_Point_Quantity__c,
                    CSS_WS_Customer_Name__c, CSS_WS_Customer_Name_Internal__c,
                    CSS_WS_Engine_Application_Code__c,  CSS_WS_Campaigns_TRPs__c,
                    CSS_WS_Policy_Campaign__c,  CSS_WS_Service_Model__c,
                    CSS_WS_Manufacturer__c, CSS_WS_VIN__c,
                    CSS_WS_Model_Series__c, CSS_WS_Complaints1__c,
                    CSS_WS_Repair_Work_Order_Number__c, CSS_WS_Complaints2__c,
                    CSS_WS_Complaints3__c,  CSS_WS_Mission_Disabling_Severity_Code__c,
                    CSS_WS_Replacement_Part__c, CSS_WS_Repair_Description__c,
                    CSS_WS_Engine_Family_Code__c, CSS_WS_Catastrophic__c,
                    CSS_WS_Failure_Measure__c, CSS_WS_Reinstatement_Flag__c,
                    CSS_WS_Claim_Status__c,  CSS_WS_Labor_Rate__c,
                    CSS_WS_In_shop_Labor_Rate__c, CSS_WS_Travel_Rate__c, 
                    CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c, 
                    CSS_WS_Complaints1_Desc__c, CSS_WS_Complaints2_Desc__c, 
                    CSS_WS_Complaints3_Desc__c, CSS_WS_Access_Code__c, 
                    CSS_WS_SRTPenaltyPercentage__c, CSS_WS_ODM_Call_Presubmit_Flag__c, 
                    CSS_WS_Repair_Days__c, CSS_WS_Years_On_Service__c, 
                    CSS_WS_Engine_Application__c, Name
                    FROM CSS_WS_Warranty__c
                    WHERE Id =: this.claim.Id];
                if(userinfo.getUserType() == 'PowerCustomerSuccess'){
                   Contact userContact = [SELECT Account.Name FROM Contact WHERE Id In (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
                   Account userAccount = [SELECT CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE Account.Name =: userContact.Account.Name  
                            AND (type = 'Dealer Account' OR type = 'Distributor Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') AND (CMI_Account_Status__c = 'Active')];
                   if(userAccount != null){
                       if(userAccount.Type == 'Distributor Account' || userAccount.Type == 'Distributor Branch Account'){
                           ClaimToClone.CSS_WS_Login_Variable__c='DRLoggedIn';
                       } else if(userAccount.Type == 'Dealer Account' || userAccount.Type == 'Dealer Branch Account'){
                           ClaimToClone.CSS_WS_Login_Variable__c='DealerLoggedIn';
                       }
                   }
                } else {
                    ClaimToClone.CSS_WS_Login_Variable__c='FactoryLoggedIn';
                }
                
                
                String userId = System.userinfo.getUserId();
                //String profileName='';
                //profileName = [SELECT Profile.Name FROM User WHERE Id =: userId limit 1].Profile.Name;
                //system.debug('Policy/Warranty Flag: ' + ClaimToClone.CSS_WS_Policy_Flag__c);
                //system.debug('Claim Status: ' + ClaimToClone.CSS_WS_Claim_Status__c);
                //if((profileName == 'CSS_WS_Factory_Warranty_Manager' || profileName == 'CSS_WS_Factory_Warranty_Manager_2') && (ClaimToClone.CSS_WS_Policy_Flag__c == 'Warranty') && (ClaimToClone.CSS_WS_Claim_Status__c == 'Pending Planta Payment' || ClaimToClone.CSS_WS_Claim_Status__c == 'Pending CM' || ClaimToClone.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' || ClaimToClone.CSS_WS_Claim_Status__c == 'Paid')){
                if((getPermissionSet('CSS_WS_Factory_Warranty_Manager') || getPermissionSet('CSS_WS_Factory_Warranty_Manager_2')) && (ClaimToClone.CSS_WS_Policy_Flag__c == 'Warranty') && (ClaimToClone.CSS_WS_Claim_Status__c == 'Pending Planta Payment' || ClaimToClone.CSS_WS_Claim_Status__c == 'Pending CM' || ClaimToClone.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' || ClaimToClone.CSS_WS_Claim_Status__c == 'Paid' || ClaimToClone.CSS_WS_Claim_Status__c == 'Denied by US')){
                    ClaimToClone.CSS_WS_Account_Code__c = '61';
                    ClaimToClone.CSS_WS_Reinstatement_Flag__c = true;
                    ClaimToClone.Is_Clone__c = 2;
                    ClaimToClone.CSS_WS_Claim_Status__c = 'Draft';
                    ClaimToClone.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
                    ClaimToClone.Id = null;
                    insert ClaimToClone;                
                    ClaimToClone.Name = [SELECT CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: ClaimToClone.Id].CSS_WS_Claim_Number__c;
                    update ClaimToClone;                
                    PageReference claimPage = new ApexPages.StandardController(ClaimToClone).edit(); 
                    claimPage.setRedirect(true); 
                    return claimPage;
                } else {
                    system.debug ('Claim cannot be used for Reinstatement Purpose');                      
                    PageReference pageRef = new PageReference('/' + String.valueof(claim_id));
                    pageRef.setRedirect(true);
                    return pageRef;
                }
            } else {
                if(System.approval.isLocked(this.claim.Id) != true){  
                    String profileName='';
                    CSS_WS_Warranty__c approverId;
                    String userId = System.userinfo.getUserId();
                    //List<ProcessInstanceWorkitem> Approval_WorkItem = [SELECT ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :this.claim.id LIMIT 1];
                    List<GroupMember> paccarId = new List<GroupMember>();
                    List<GroupMember> tsmId = new List<GroupMember>();
                    List<GroupMember> tsm_central_Id = new List<GroupMember>();
                    List<GroupMember> tsm_north_Id = new List<GroupMember>();
                    List<GroupMember> tsm_pacific_Id = new List<GroupMember>();
                    List<GroupMember> tsm_southeast_Id = new List<GroupMember>();
                    if(userId != null){
                        profileName = [SELECT Profile.Name FROM User WHERE Id =: userId limit 1].Profile.Name;
                        approverId = [SELECT CreatedBy.Community_Approver__c, CreatedBy.Community_Approver_Policy88__c FROM CSS_WS_Warranty__c WHERE id = :this.claim.id LIMIT 1];
                        paccarId = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Queue Paccar' AND UserOrGroupId =: userId limit 1];
                        tsmId = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM' AND UserOrGroupId =: userId limit 1];
                        tsm_central_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_Central' AND UserOrGroupId =: userId limit 1];
                        tsm_north_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_North' AND UserOrGroupId =: userId limit 1];
                        tsm_pacific_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_Pacific' AND UserOrGroupId =: userId limit 1];
                        tsm_southeast_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_Southeast' AND UserOrGroupId =: userId limit 1];
                    }       
                    //if((this.claim.CSS_WS_Claim_Status__c == 'Draft' && profileName != 'CSS_WS_Branch_Warranty_Manager') || (this.claim.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' && (profileName == 'CSS_WS_Branch_Warranty_Manager' || profileName == 'CSS_WS_Distributor_Service' || profileName == 'CSS_WS_Distributor_Warranty_Manager' || profileName == 'CSS_WS_Distributor_Warranty_Rescue_Manager' || profileName == 'CSS_WS_DR_Warranty_Manager_CA')) || (profileName == 'CSS_WS_Factory_Warranty_Manager' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'CSS_WS_Factory_Warranty_Manager_2' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Admin' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Administrator' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver__c) && this.claim.CSS_WS_Claim_Status__c == 'Pending DR') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver_Policy88__c)  && this.claim.CSS_WS_Claim_Status__c == 'Pending DR')) {
                    if((this.claim.CSS_WS_Claim_Status__c == 'Draft' && !getPermissionSet('CSS_WS_Branch_Warranty_Manager')) || (this.claim.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' && (getPermissionSet('CSS_WS_Branch_Warranty_Manager') || getPermissionSet('CSS_WS_Distributor_Service') || getPermissionSet('CSS_WS_Distributor_Warranty_Manager') || getPermissionSet('CSS_WS_Distributor_Warranty_Rescue_Manager') || getPermissionSet('CSS_WS_DR_Warranty_Manager_CA'))) || (getPermissionSet('CSS_WS_Factory_Warranty_Manager') && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (getPermissionSet('CSS_WS_Factory_Warranty_Manager_2') && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Admin' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Administrator' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver__c) && this.claim.CSS_WS_Claim_Status__c == 'Pending DR') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver_Policy88__c)  && this.claim.CSS_WS_Claim_Status__c == 'Pending DR')) {
                        return null;
                    } else if (paccarId.size() > 0) {
                        //if (paccarId[0].UserOrGroupId == userId && this.claim.CSS_WS_Claim_Status__c == 'Pending Paccar'){
                        if((paccarId[0].UserOrGroupId == userId && this.claim.CSS_WS_Claim_Status__c == 'Pending Paccar') || (paccarId[0].UserOrGroupId == userId && this.claim.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' && this.claim.CSS_WS_Belongs_To__c == 'Paccar')){
                            return null; 
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked 
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }             
                    } else if (tsmId.size() > 0) {
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsmId[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsmId[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if (tsm_central_Id.size() > 0){
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_central_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_central_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if (tsm_north_Id.size() > 0) {
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_north_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_north_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if (tsm_pacific_Id.size() > 0) {
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_pacific_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_pacific_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if (tsm_southeast_Id.size() > 0) {
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_southeast_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_southeast_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }                
                    } else {                
                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                        ApexPages.addMessage(errorMsg);
                        PageReference pageRef = Page.CSS_WS_Locked_record;
                        pageRef.setRedirect(true);
                        return pageRef;
                    }
                } else {
                    String profileName='';
                    CSS_WS_Warranty__c approverId;
                    String userId = System.userinfo.getUserId();
                    List<GroupMember> paccarId = new List<GroupMember>();
                    List<GroupMember> tsmId = new List<GroupMember>();
                    List<GroupMember> tsm_central_Id = new List<GroupMember>();
                    List<GroupMember> tsm_north_Id = new List<GroupMember>();
                    List<GroupMember> tsm_pacific_Id = new List<GroupMember>();
                    List<GroupMember> tsm_southeast_Id = new List<GroupMember>();
                    if(userId != null){
                        profileName = [SELECT Profile.Name FROM User WHERE Id =: userId limit 1].Profile.Name;
                        approverId = [SELECT CreatedBy.Community_Approver__c, CreatedBy.Community_Approver_Policy88__c FROM CSS_WS_Warranty__c WHERE id = :this.claim.id LIMIT 1];
                        paccarId = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.Name = 'Queue Paccar' AND UserOrGroupId =: userId limit 1];
                        tsmId = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM' AND UserOrGroupId =: userId limit 1];
                        tsm_central_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_Central' AND UserOrGroupId =: userId limit 1];
                        tsm_north_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_North' AND UserOrGroupId =: userId limit 1];
                        tsm_pacific_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_Pacific' AND UserOrGroupId =: userId limit 1];
                        tsm_southeast_Id = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName = 'CSS_WS_Queue_TSM_Southeast' AND UserOrGroupId =: userId limit 1];
                    }       
                    //if((profileName == 'CSS_WS_Factory_Warranty_Manager' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'CSS_WS_Factory_Warranty_Manager_2' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Admin' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Administrator' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver__c) && this.claim.CSS_WS_Claim_Status__c == 'Pending DR') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver_Policy88__c)  && this.claim.CSS_WS_Claim_Status__c == 'Pending DR') || (this.claim.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' && (profileName == 'CSS_WS_Branch_Warranty_Manager' || profileName == 'CSS_WS_Distributor_Service' || profileName == 'CSS_WS_Distributor_Warranty_Manager' || profileName == 'CSS_WS_Distributor_Warranty_Rescue_Manager' || profileName == 'CSS_WS_DR_Warranty_Manager_CA'))) {
                    if((getPermissionSet('CSS_WS_Factory_Warranty_Manager') && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (getPermissionSet('CSS_WS_Factory_Warranty_Manager_2') && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Admin' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (profileName == 'System Administrator' && this.claim.CSS_WS_Claim_Status__c != 'Pending US') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver__c) && this.claim.CSS_WS_Claim_Status__c == 'Pending DR') || (userId == String.valueOf(approverId.CreatedBy.Community_Approver_Policy88__c)  && this.claim.CSS_WS_Claim_Status__c == 'Pending DR') || (this.claim.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' && (getPermissionSet('CSS_WS_Branch_Warranty_Manager') || getPermissionSet('CSS_WS_Distributor_Service') || getPermissionSet('CSS_WS_Distributor_Warranty_Manager') || getPermissionSet('CSS_WS_Distributor_Warranty_Rescue_Manager') || getPermissionSet('CSS_WS_DR_Warranty_Manager_CA')))){
                        return null;
                    } else if (paccarId.size() > 0) {
                        //if (paccarId[0].UserOrGroupId == userId && this.claim.CSS_WS_Claim_Status__c == 'Pending Paccar'){
                        if((paccarId[0].UserOrGroupId == userId && this.claim.CSS_WS_Claim_Status__c == 'Pending Paccar') || (paccarId[0].UserOrGroupId == userId && this.claim.CSS_WS_Claim_Status__c == 'Pending DR Payment to DL' && this.claim.CSS_WS_Belongs_To__c == 'Paccar')){

                            return null; 
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }             
                    } else if (tsmId.size() > 0) {
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsmId[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsmId[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if(tsm_central_Id.size() > 0){
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_central_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_central_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if(tsm_north_Id.size() > 0){
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_north_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_north_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if(tsm_pacific_Id.size() > 0){
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_pacific_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_pacific_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    } else if(tsm_southeast_Id.size() > 0){
                        //if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && profileName == 'CSS_WS_TSM' && tsm_southeast_Id[0].UserOrGroupId == userId){
                        if(this.claim.CSS_WS_Claim_Status__c == 'Pending TSM' && getPermissionSet('CSS_WS_TSM') && tsm_southeast_Id[0].UserOrGroupId == userId){
                            return null;
                        } else {
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                            ApexPages.addMessage(errorMsg);
                            PageReference pageRef = Page.CSS_WS_Locked_record;
                            pageRef.setRedirect(true);
                            return pageRef;
                        }                                                
                    } else {                
                        ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                        ApexPages.addMessage(errorMsg);
                        PageReference pageRef = Page.CSS_WS_Locked_record;
                        pageRef.setRedirect(true);
                        return pageRef;
                    }
                }
            }
        }
        return null;
    }//Check
    
    Public PageReference validateHeader(){
        this.claim.CSS_WS_HasError__c = 0;
        this.claim.CSS_WS_HasMessage__c = '';
        odmWarnings = new List<String>();
        ignoreWarnings = false;
        if(validateHeaderFields()){
            if(this.validateHeaderODM()){ 
                if((this.claim.CSS_WS_Campaigns_TRPs__c != null && this.claim.CSS_WS_Campaigns_TRPs__c != '') || (this.claim.CSS_WS_Warranty_Type__c == 'Parte' && this.claim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio')){
                    List<String> SystemAndComponentCode = new List<String>();
                    List<String> ListToAccCoverage = new List<String>();
                    String NewPartsWarrantyFlg = 'N', ReConPartsWarrantyFlg = 'N', RoadRelayWarrantyFlg = 'N';
                    String AccountCode = '';
                    String FailCode = '';
                    if(this.claim.CSS_WS_Campaigns_TRPs__c != null && this.claim.CSS_WS_Campaigns_TRPs__c != ''){
                        FailCode = this.campaingsTem.get(this.claim.CSS_WS_Campaigns_TRPs__c).FailCode;
                    }
                    ListToAccCoverage.add(this.claim.CSS_WS_Engine_Serial_Number__c);
                    ListToAccCoverage.add(this.claim.CSS_WS_Service_Provider_Dealer__c);
                    ListToAccCoverage.add(CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                    ListToAccCoverage.add(String.valueOf(this.claim.CSS_WS_Failure_Point_Quantity__c));
                    ListToAccCoverage.add(this.claim.CSS_WS_Failure_Measure__c);
                    ListToAccCoverage.add(this.claim.CSS_WS_Engine_Application_Code__c);
                    ListToAccCoverage.add('');//Need Fault Code for Emission coverage check. Send blank 
                    ListToAccCoverage.add(CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
                    if(this.claim.CSS_WS_Campaigns_TRPs__c!=null && this.claim.CSS_WS_Campaigns_TRPs__c!=''){
                        ListToAccCoverage.add(this.claim.CSS_WS_Campaigns_TRPs__c);
                    } else {
                        ListToAccCoverage.add('');
                    }
                    if(this.claim.CSS_WS_Warranty_Type__c == 'Parte' || this.claim.CSS_WS_Warranty_Type__c == 'Part'){
                        if(this.claim.CSS_WS_Claim_Type__c == 'Nuevo' || this.claim.CSS_WS_Claim_Type__c == 'New'){
                            NewPartsWarrantyFlg = 'Y';
                        } else if(this.claim.CSS_WS_Claim_Type__c == 'Recon'){
                            ReConPartsWarrantyFlg = 'Y';
                        } else if(this.claim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio' || this.claim.CSS_WS_Claim_Type__c == 'Road Relay'){
                            RoadRelayWarrantyFlg = 'Y';
                        }
                    }
                    ListToAccCoverage.add(NewPartsWarrantyFlg);//New parts warranty flag
                    ListToAccCoverage.add(ReConPartsWarrantyFlg);//Recon parts warranty flag
                    ListToAccCoverage.add(RoadRelayWarrantyFlg); //Road relay warranty flag
                    if(this.claim.CSS_WS_Policy_Flag__c == 'Policy WW'){
                        AccountCode = this.claim.CSS_WS_Account_Code__c;
                    } else if(this.claim.CSS_WS_Warranty_Subtype__c == 'ReCon Engine') {
                        AccountCode = '98';
                    }
                    Date failureDate = this.claim.CSS_WS_Failure_Date_Time__c.date();
                    ListToAccCoverage.add(AccountCode);
                    if(this.claim.CSS_WS_Campaigns_TRPs__c != null && this.claim.CSS_WS_Campaigns_TRPs__c != ''){
                        SystemAndComponentCode.add(FailCode.left(2) + ',' + FailCode.right(2));
                    } else {
                        SystemAndComponentCode.add('XM,TO');
                    }
                    this.campaignCoverageResponse = CSS_WS_GetWebServiceData.getAccountCoverage(ListToAccCoverage, SystemAndComponentCode);//Coverage
                    if(this.campaignCoverageResponse != null){
                        if(this.campaignCoverageResponse.Header.Status.touppercase() == 'SUCCESS'){
                            if(this.campaignCoverageResponse.DataArea.Details[0].Status.touppercase() == 'ERROR'){
                                this.DisplayAsincErrorHandler(this.campaignCoverageResponse.DataArea.Details[0].Message);
                                closePopup();  //In case a warning message is being displayed
                                return null;
                            } else {
                                if(this.claim.CSS_WS_Campaigns_TRPs__c != null && this.claim.CSS_WS_Campaigns_TRPs__c != null){
                                    if(this.campaignCoverageResponse.DataArea.AccountCode == '65' || this.campaignCoverageResponse.DataArea.AccountCode == '27'){
                                        if(this.campaignCoverageResponse.DataArea.Details[0].CampaignLaborPercentage == '0' && this.campaignCoverageResponse.DataArea.Details[0].CampaignOCPercentage == '0' 
                                           && this.campaignCoverageResponse.DataArea.Details[0].CampaignPartsPercentage == '0' && this.campaignCoverageResponse.DataArea.Details[0].CampaignTowingPercentage == '0' && this.campaignCoverageResponse.DataArea.Details[0].CampaignTravelPercentage == '0'){//Rule SF63
                                            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E004);//Claimable not covered for this campaign
                                            closePopup();  //In case a warning message is being displayed
                                            return null;
                                        }
                                    }
                                }
                                String certificateNumber = this.campaignCoverageResponse.DataArea.Details[0].CertificateNumber != null ? this.campaignCoverageResponse.DataArea.Details[0].CertificateNumber: '';
                                String certificateNumberId = '';
                                if(certificateNumber != null && certificateNumber.contains('-')){
                                    String[] ValuesFromSplit = certificateNumber.split('-');
                                    if(ValuesFromSplit != null){
                                        certificateNumber = ValuesFromSplit[0];
                                        certificateNumberId = ValuesFromSplit[1];
                                    }
                                }
                                this.claim.CSS_WS_Account_Code__c = this.campaignCoverageResponse.DataArea.AccountCode;
                                this.claim.CSS_WS_Account_Code_Type__c = this.campaignCoverageResponse.DataArea.AccountCodeType;
                                this.claim.CSS_WS_System_Code__c = this.campaignCoverageResponse.DataArea.Details[0].SystemCode;
                                this.claim.CSS_WS_Component_Code__c = this.campaignCoverageResponse.DataArea.Details[0].ComponentCode;
                                this.claim.CSS_WS_Pay_Code__c = this.campaignCoverageResponse.DataArea.Details[0].PayCode;   
                                this.claim.CSS_WS_Certificate_Number__c = certificateNumber ;
                                this.claim.CSS_WS_Certificate_Number_Id__c = certificateNumberId;   
                                this.claim.CSS_WS_WarrantyId__c = this.campaignCoverageResponse.DataArea.Details[0].WarrantyId;
                                if(!String.isEmpty( this.campaignCoverageResponse.DataArea.Details[0].CoveredLaborHrs))
                                    this.claim.CSS_WS_Covered_Labor_Hours__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CoveredLaborHrs);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CoveredMealsLodgingAmt))
                                    this.claim.CSS_WS_Covered_Meals_Lodging__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CoveredMealsLodgingAmt);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CoveredOCAmount))
                                    this.claim.CSS_WS_Covered_OC_Amount__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CoveredOCAmount);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CoveredPartsQty))
                                    this.claim.CSS_WS_Covered_Parts_Qty__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CoveredPartsQty);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CoveredTowingMiles))
                                    this.claim.CSS_WS_Covered_Towing_Miles__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CoveredTowingMiles);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CoveredTravelLabor))
                                    this.claim.CSS_WS_Covered_Travel_Labor__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CoveredTravelLabor);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CoveredTravelMiles))
                                    this.claim.CSS_WS_Covered_Travel_Miles__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CoveredTravelMiles);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].DeductibleAmount))
                                    this.claim.CSS_WS_Deductible_Amount__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].DeductibleAmount);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CampaignLaborPercentage))
                                    this.claim.CSS_WS_Campaign_Labor_Percentage__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CampaignLaborPercentage);//Ready
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CampaignOCPercentage))
                                    this.claim.CSS_WS_Campaign_OC_Percentage__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CampaignOCPercentage);//Ready
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CampaignPartsPercentage))
                                    this.claim.CSS_WS_Campaign_Parts_Percentage__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CampaignPartsPercentage);//Ready
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CampaignTowingPercentage))
                                    this.claim.CSS_WS_Campaign_Towing_Percentage__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CampaignTowingPercentage);
                                if(!String.isEmpty(this.campaignCoverageResponse.DataArea.Details[0].CampaignTravelPercentage))
                                    this.claim.CSS_WS_Campaign_Travel_Percentage__c = integer.valueof(this.campaignCoverageResponse.DataArea.Details[0].CampaignTravelPercentage);
                                //Assign Pay Code when it is different than PolicyWW
                                if(this.claim.CSS_WS_Policy_Flag__c != 'Policy WW'){ assignPayCode();}
                            }
                        } else {
                            this.DisplayAsincErrorHandler(this.campaignCoverageResponse.Header.ReturnCodeDescription);
                            closePopup();  //In case a warning message is being displayed
                            return null;
                        }
                    }
                }
                // To assign the inShopCampaignFlag value of the selected Campaign
                String InShopCampaign = '';
                if(this.claim.CSS_WS_Campaigns_TRPs__c != null && this.claim.CSS_WS_Campaigns_TRPs__c != ''){
                    InShopCampaign = (this.campaingsTem.get(this.claim.CSS_WS_Campaigns_TRPs__c).InShopSrtLimitFlag != null) ? this.campaingsTem.get(this.claim.CSS_WS_Campaigns_TRPs__c).InShopSrtLimitFlag : 'N';
                }
                this.claim.CSS_WS_InShopCampaignFlag__c = InShopCampaign; 
                // end the assignation change of inShopCampaignFlag
                this.getSPData();               
            }
            return null;
        } else {
            return null;
        }
    }
    
    Public PageReference continueSubmission(){
        try {
            //Update the claim with the values of this section
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = true;
            update claim;
            //Redirect to Claim view page
            PageReference claimPage = new ApexPages.StandardController(claim).view(); 
            claimPage.setRedirect(true); 
            return claimPage;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            closePopup();
            return null;
        }
    }

    Public PageReference continueHeader(){
        try {
            //Create a register for this claim
            this.claim.Is_Clone__c = 0;
            this.claim.CSS_WS_Service_Provider_Name_DR__c = this.getSpName(this.claim.CSS_WS_Service_Provider_DR__c, 'DR');
            this.claim.CSS_WS_Service_Provider_Name_Dealer__c = this.getSpName(this.claim.CSS_WS_Service_Provider_Dealer__c, 'DLR');
            //Save the main complaint description
            if(this.claim.CSS_WS_Complaints1__c != null && this.claim.CSS_WS_Complaints1__c != ''){
                this.claim.CSS_WS_Complaints1_Desc__c = [SELECT CSS_WS_Desc_Text__c FROM CSS_WS_Complaints_Master_Catalogue__c WHERE CSS_WS_Code_Name__c = :this.claim.CSS_WS_Complaints1__c LIMIT 1].CSS_WS_Desc_Text__c;
            }
            //Save the complaint2 description if exist
            if(this.claim.CSS_WS_Complaints2__c != null && this.claim.CSS_WS_Complaints2__c != ''){
                this.claim.CSS_WS_Complaints2_Desc__c = [SELECT CSS_WS_Desc_Text__c FROM CSS_WS_Complaints_Master_Catalogue__c WHERE CSS_WS_Code_Name__c = :this.claim.CSS_WS_Complaints2__c LIMIT 1].CSS_WS_Desc_Text__c;
            }
            //Save the complaint3 description if exist
            if(this.claim.CSS_WS_Complaints3__c != null && this.claim.CSS_WS_Complaints3__c != ''){
                this.claim.CSS_WS_Complaints3_Desc__c = [SELECT CSS_WS_Desc_Text__c FROM CSS_WS_Complaints_Master_Catalogue__c WHERE CSS_WS_Code_Name__c = :this.claim.CSS_WS_Complaints3__c LIMIT 1].CSS_WS_Desc_Text__c;
            }
            /*if(String.isEmpty(this.claim.CSS_WS_Access_Code__c)){
                List<CSS_WS_Access_Code_Master_Catalog__c> code = [SELECT CSS_WS_Access_Code__c FROM CSS_WS_Access_Code_Master_Catalog__c
                    WHERE CSS_WS_Engine_Family_Code__c =: this.claim.CSS_WS_Engine_Family_Code__c
                    AND CSS_WS_Equip_Manufacturer__c =: this.claim.CSS_WS_Manufacturer__c AND CSS_WS_Equip_Model_Series__c =: this.claim.CSS_WS_Model_Series__c LIMIT 1];
                if(code.size() > 0){
                    this.claim.CSS_WS_Access_Code__c = code[0].CSS_WS_Access_Code__c;
                }
            }*/
            List<CSS_WS_Make_And_Model__c> code_equipment = [SELECT CSS_WS_Access_Code__c, CSS_WS_Equipment_Id__c FROM CSS_WS_Make_And_Model__c
                    WHERE CSS_WS_Engine_Family_Code__c =: this.claim.CSS_WS_Engine_Family_Code__c
                    AND CSS_WS_Make__c =: this.claim.CSS_WS_Manufacturer__c AND CSS_WS_Model__c =: this.claim.CSS_WS_Model_Series__c 
                    AND CSS_WS_Status__c = 'ACTIVE' LIMIT 1];
            if(code_equipment.size() > 0){
                this.claim.CSS_WS_Equipment_Code__c = code_equipment[0].CSS_WS_Equipment_Id__c;
            }

            if(String.isEmpty(this.claim.CSS_WS_Access_Code__c)){
                if(code_equipment.size() > 0){
                    this.claim.CSS_WS_Access_Code__c = code_equipment[0].CSS_WS_Access_Code__c;
                }
            }

            this.claim.CSS_WS_SRTPenaltyPercentage__c = this.Penaltytem;
            if(this.claim.CSS_WS_Warranty_Subtype__c == 'ReCon Engine' && this.claim.CSS_WS_Policy_Flag__c == 'Warranty') {
                this.claim.CSS_WS_Account_Code__c = '98';
            }
            this.claim.CSS_WS_GSQ_Failure_Flag__c = '0 - Not consumed';
            this.claim.CSS_WS_GSQ_SRT_Flag__c = '0 - Not consumed';
            upsert this.claim;
            this.claim.Name = [SELECT CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id].CSS_WS_Claim_Number__c;//Fix to change Name to Claim Number, cannot use formula at this point 08/11/16, Rule SF5
            update this.claim;
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            if((this.claim.CSS_WS_Campaigns_TRPs__c!=null && this.claim.CSS_WS_Campaigns_TRPs__c!='') || (this.claim.CSS_WS_Warranty_Type__c == 'Parte' && this.claim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio')){
                String campaignInsertResult = failureData();
                if(campaignInsertResult != null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,campaignInsertResult));
                    closePopup();
                    return null;
                }
            }
            PageReference claimPage = new ApexPages.StandardController(claim).edit(); 
            claimPage.setRedirect(true); 
            return claimPage;                   
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            System.Debug(e.getMessage());
            closePopup();
            return null;
        }
        return null;
    }

    Public PageReference saveHeader(){
        if(this.claim.CSS_WS_Policy_Flag__c != 'Policy'){
            Account SPWarrantyTraining = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c); //Rule SF73
            //System.debug(SPWarrantyTraining);
            if(SPWarrantyTraining.Warranty_Training_Certification__c == false){
                closePopup();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E061));//Rule SF73, this location is not warranty certified
                return null;
            }
        }    
        if(this.claim.CSS_WS_HasError__c == 1){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
            return null;
        }        
        if(this.claim.CSS_WS_HasError__c == 2){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, this.claim.CSS_WS_HasMessage__c));
        }   
        odmWarnings = new List<String>();
        if(this.claim.CSS_WS_HasError__c == 4){
            odmWarnings.add(this.claim.CSS_WS_HasMessage__c);
            showPopup();
            return null;
        }
        closePopup();
        return continueHeader();
    }
    
    Public PageReference saveHeaderDisabled(){
        disableHeader = True;
        if(this.claim.CSS_WS_Policy_Flag__c == 'Policy' && (this.claim.CSS_WS_Account_Code__c == 'P88' || this.claim.CSS_WS_Account_Code__c == 'P93' || this.claim.CSS_WS_Account_Code__c == 'P99' || this.claim.CSS_WS_Account_Code__c == 'P100' || this.claim.CSS_WS_Account_Code__c == 'P101')){//Rule SF-P04
            showPolicy = True;
            disablePolicy = False;            
            TabInFocus = 'PolicyTab';  
            this.getCustomerSupportEngineer(); 
        /*} else if(this.claim.CSS_WS_Account_Code__c == 'P89'){
            disableTravel = False; 
            TabInFocus = 'travelTab';
            showTravel = True;
            showSaveTravelButton = True;*/
        } else {            
            disableFailure = False;           
            TabInFocus = 'FailureTab';    
            rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Failure' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
            this.claim.RecordTypeId = rt.Id;  
        }
        return null;
    }
    
    Public PageReference savePolicy(){
        if(validatePolicyFields()){
            try{
                if(this.claim.CSS_WS_Quotation_Total_Amount__c != null && this.claim.CSS_WS_Authorized_Amount__c != null && this.claim.CSS_WS_Account_Code__c != 'P100'){
                    //this.claim.CSS_WS_Requested_Amount__c = this.claim.CSS_WS_Quotation_Total_Amount__c;Delete After
                    //Calculate and save values that are not displayed in the form
                    //this.claim.CSS_WS_Percentaje_Requested__c = (this.claim.CSS_WS_Requested_Amount__c / this.claim.CSS_WS_Quotation_Total_Amount__c) * 100;Delete After
                    this.claim.CSS_WS_Percentaje_Requested__c = 100;
                    this.claim.CSS_WS_Percentaje_Factory__c = (this.claim.CSS_WS_Authorized_Amount__c / this.claim.CSS_WS_Quotation_Total_Amount__c) * 100;
                    this.claim.CSS_WS_Percentaje_Customer__c = 100 - this.claim.CSS_WS_Percentaje_Factory__c;
                    //Calculate values for Pay Code when "Policy P88" is selected
                    Date failureDate = this.claim.CSS_WS_Failure_Date_Time__c.date();
                    Date authorizationDate = this.claim.CSS_WS_Customer_Support_authorization_da__c;
                    //LogInVariable = 'DRLoggedIn';
                    if (failureDate.daysBetween(authorizationDate) < 120){
                        if(LogInVariable == 'DRLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'I';
                        } else if (LogInVariable == 'DealerLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'R';
                        }       
                    } else if((failureDate.daysBetween(authorizationDate) >= 120)  &&  (failureDate.daysBetween(authorizationDate) < 180)){
                        if (LogInVariable == 'DRLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'T';
                        } else if (LogInVariable == 'DealerLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'C';
                        }       
                    } else if((failureDate.daysBetween(authorizationDate) >= 180)  &&  (failureDate.daysBetween(authorizationDate) < 365)){
                        if (LogInVariable == 'DRLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'S';
                        } else if (LogInVariable == 'DealerLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'L';
                        }       
                    } else if(failureDate.daysBetween(authorizationDate) >= 365){
                        if (LogInVariable == 'DRLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'A';
                        } else if (LogInVariable == 'DealerLoggedIn'){
                            this.claim.CSS_WS_Pay_Code__c = 'A';
                        }       
                    }  
                }
                // query to get EquipmentId for claim
                List<CSS_WS_Make_And_Model__c> equipment = [SELECT CSS_WS_Access_Code__c, CSS_WS_Equipment_Id__c FROM CSS_WS_Make_And_Model__c
                    WHERE CSS_WS_Engine_Family_Code__c =: this.claim.CSS_WS_Engine_Family_Code__c
                    AND CSS_WS_Make__c =: this.claim.CSS_WS_Manufacturer__c AND CSS_WS_Model__c =: this.claim.CSS_WS_Model_Series__c 
                    AND CSS_WS_Status__c = 'ACTIVE' LIMIT 1];
                    
                if (this.claim.CSS_WS_Account_Code__c == 'P101'){
                    this.claim.CSS_WS_Service_Provider_Name_DR_ToCharge__c = this.getSpName(this.claim.CSS_WS_Service_Provider_DR_ToCharge__c, 'DR');
                    this.claim.CSS_WS_SP_Name_Dealer_ToCharge__c = this.getSpName(this.claim.CSS_WS_Service_Provider_Dealer_ToCharge__c, 'Dealer');
                    // to assign equipment ID for claims P101 
                    if(equipment.size() > 0){
                        this.claim.CSS_WS_Equipment_Code__c = equipment[0].CSS_WS_Equipment_Id__c;
                    }
                }
                                
                //Update the claim with the values of this section 
                this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
                update claim;                
                disableFailure = False;
                TabInFocus = 'FailureTab'; 
                disablePolicy = True;
                rt = [select Id from RecordType where Name = 'CSS_WS_RT_Failure' and SobjectType = 'CSS_WS_Warranty__c' limit 1];
                this.claim.RecordTypeId = rt.Id; 
                return null;            
            } catch(System.Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                //System.debug('Error: '+e.getMessage());
                return null;
            }
        } else {
            return null;
        }
    }
    
    Public PageReference saveFailure(){        
        try {
            this.rescue = getRescueNumber(this.claim.CSS_WS_Engine_Serial_Number__c, this.claim.CSS_WS_Service_Provider_Dealer__c, 
                                          this.claim.CSS_WS_Failure_Date_Time__c, this.claim.CSS_WS_RescueNumber__c, this.claim.CSS_WS_Policy_Flag__c);
            Account dealerAcc = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
            this.laborRate = this.claim.CSS_WS_In_shop_Labor_Rate__c;
            List<CSS_WS_Rescue__c> temRes = [SELECT Name, CSS_WS_Warranty_Relationship__c FROM CSS_WS_Rescue__c WHERE CSS_WS_Warranty_Relationship__c =: this.claim.id];//Optional
            // Validation for "54734" SPCode - Oct 6th 2020
            if(((this.rescue != null || temRes.size() > 0) && dealerAcc.BillingCountry.toUpperCase() == 'MEXICO' && this.claim.CSS_WS_Service_Provider_Dealer__c != '54734') || ((this.rescue != null || temRes.size() > 0) && this.claim.CSS_WS_Policy_Flag__c != 'Policy WW' && this.claim.CSS_WS_Service_Provider_Dealer__c == '54734')){  
                this.showRescueTable = true;
                this.laborRate = this.claim.CSS_WS_Labor_Rate__c;
                this.showTravel = true;
                if(this.rescue != null){//Optional
                    if (this.rescue.CSS_WS_Warranty_Relationship__c == null){ // validation to not override service order and rescue 
                        this.rescue.CSS_WS_Warranty_Relationship__c = this.claim.Id;
                    }                    
                    update rescue;
                    this.claim.CSS_WS_RescueNumber__c = this.rescue.Name;
                    this.claim.CSS_WS_Travel_Hours__c = this.rescue.CSS_WS_TravelHoursRoundTripPolicy__c;
                    this.claim.CSS_WS_Travel_Distance__c = this.rescue.CSS_WS_TravelKmRoundTripPolicy__c;
                    Decimal Lodging = (this.rescue.CSS_WS_Lodging_Amount__c != null) ? this.rescue.CSS_WS_Lodging_Amount__c : 0;
                    Decimal Lunch = (this.rescue.CSS_WS_LunchAmount__c != null) ? this.rescue.CSS_WS_LunchAmount__c : 0;
                    this.claim.CSS_WS_Lodging__c = Lodging + Lunch;
                    //this.rescue.CSS_WS_Warranty_Relationship__c = this.claim.Id;
                    this.claim.CSS_WS_Towing_Amount__c = (this.rescue.CSS_WS_TowingAmount__c != null)? this.rescue.CSS_WS_TowingAmount__c.setscale(2) : 0;
                    this.claim.CSS_WS_Total_Amount_Travel__c = this.rescue.CSS_WS_RescueCost__c + this.claim.CSS_WS_Towing_Amount__c;
                }//Optional
            // Validation for "54734" SPCode - Oct 6th 2020
            } else if(dealerAcc.BillingCountry.toUpperCase() != 'MEXICO' || (this.claim.CSS_WS_Service_Provider_Dealer__c == '54734' && this.claim.CSS_WS_Policy_Flag__c == 'Policy WW')){
                showTravel = true;
            }
            if(this.claim.CSS_WS_Account_Code__c == 'P89' && this.claim.CSS_WS_RescueNumber__c == null){
                showSaveNarrativeButton = True;
            }
            
            //Validate Other Approver should not be NULL
            if(this.claim.Other_Approver_Picklist_WW__c == null && this.claim.CSS_WS_Policy_Flag__c == 'Policy WW'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E070));//Other Approver should not be empty
                return null;
            }
            Decimal scale = this.laborRate != null ? Decimal.valueOf(this.laborRate).setscale(2) : 0;
            this.laborRate = String.valueOf(scale);
            this.claim.CSS_WS_Travel_Type__c = 'Non-Commercial';
            this.claim.CSS_WS_Travel_Mode__c = 'Car';
            // Add validation actions if apply
            if(this.claim.CSS_WS_HasError__c == 1){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                return null;
            }
            //Pay Code Logic when No Pay Code is returned 17/10/2016            
            if(String.isBlank(this.claim.CSS_WS_Pay_Code__c) && this.claim.CSS_WS_Policy_Flag__c != 'Policy WW' && this.claim.CSS_WS_Reinstatement_Flag__c == false){
                assignPayCode();
            }
            //Update the claim with the values of this section   
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false; 
            update claim;            
            //Validation to check the multiESN flag
            if(this.claim.CSS_WS_Multi_ESN__c){
                disableMultiESN = False;
                TabInFocus = 'MultipleESNTab';            
            } else {
                disableNarrative = False;
                TabInFocus = 'NarrativeTab'; 
            }
            disableFailure = True;
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveMultiESN(){
        try {
            //Add validation actions if apply
            if(this.claim.CSS_WS_HasError__c == 1){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                return null;
            }
            //Update the claim with the values of this section      
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            update claim;       
            disableNarrative = False;
            TabInFocus = 'NarrativeTab'; 
            disableMultiESN = True;
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveNarrative(){
        try {
            //Add validation actions if apply
            if(this.claim.CSS_WS_HasError__c == 1){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                return null;
            }
            if(flagSRT == false && this.claim.CSS_WS_Account_Code__c != 'P89'){//Rule SF56
                this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
                update claim;
                disableSRT = False;
                TabInFocus = 'SRTTab'; 
                disableNarrative = True;
                rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_SRT' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
            } else if(this.claim.CSS_WS_Account_Code__c == 'P89' && this.claim.CSS_WS_RescueNumber__c != null){
                this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
                update claim;
                disableTravel = False; 
                isMexico = true;
                TabInFocus = 'travelTab';
                //showSaveTravelButton = True; //Review button should not be available in Travel section  - Apr 3rd 2019
                disableNarrative = True;
            } else if(this.claim.CSS_WS_Account_Code__c == 'P89' && this.claim.CSS_WS_RescueNumber__c == null){
                //For P89 and not Rescue related, next tab should be Other Claimable - Apr 3rd 2019
                /*odmWarnings = new List <String>();
                if(validatePreSubmitODM()){
                    if(this.claim.CSS_WS_HasError__c == 4){
                        showPopup();
                        odmWarnings.add(this.claim.CSS_WS_HasMessage__c);
                    }
                    return null;
                }
                return continueSubmission();*/
                this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
                update claim;  
                disableClaimable = False; 
                TabInFocus = 'ClaimableTab'; 
                disableNarrative = True;
                rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Claimable' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
            } else {          
                this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
                update claim;
                disableParts = False;
                TabInFocus = 'PartsTab'; 
                disableNarrative = True;
                rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Parts' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
            }
            this.claim.RecordTypeId = rt.Id; 
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveSRT(){
        try {
            if (!this.claim.CSS_WS_ODM_SRT_Success_Flag__c){
                if(this.claim.CSS_WS_HasError__c == 1){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                    return null;
                }
            }
            //Add validation actions if apply
            if(this.claim.CSS_WS_ECM_Calibration_After__c != null || this.claim.CSS_WS_Revision_After__c != null || this.claim.CSS_WS_ECM_Calibration_Before__c != null || this.claim.CSS_WS_Revision_Before__c != null){// || this.claim.CSS_WS_ECM_Calib_Justification__c != null){
                if(this.claim.CSS_WS_ECM_Calibration_After__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E010));//ECM Calibration After should not be empty
                    return null;
                } else if(this.claim.CSS_WS_Revision_After__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E073));//Revision After should not be empty
                    return null;
                } else if(this.claim.CSS_WS_ECM_Calibration_Before__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E011));//ECM Calibration Before should not be empty
                    return null;
                } else if(this.claim.CSS_WS_Revision_Before__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E074));//Revision Before should not be empty
                    return null;
                } else if(this.claim.CSS_WS_ECM_Calib_Justification__c == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E075));//Justification should not be empty
                    return null;
                }
            } 
            if(this.claim.CSS_WS_HasError__c == 1){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                return null;
            }
            CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Claim_Amount__c FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id];
            Account SPMaxAmount = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
            if(claimData.CSS_WS_Claim_Amount__c > SPMaxAmount.CSS_WS_Max_Claim_Amount__c){//Rule SF76
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E003));//Claim amount is greater than allowed claim amount for this service provider
                return null;
            }
            //Update the claim with the values of this section   
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;   
            update claim;              
            disableParts = False;
            TabInFocus = 'PartsTab'; 
            disableSRT = True;
            rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Parts' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
            this.claim.RecordTypeId = rt.Id;  
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveParts(){
        try {
            //Add validation actions if apply
            if(this.claim.CSS_WS_HasError__c >= 1){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                return null;
            }
            CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Claim_Amount__c FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id];
            Account SPMaxAmount = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
            if(claimData.CSS_WS_Claim_Amount__c > SPMaxAmount.CSS_WS_Max_Claim_Amount__c){//Rule SF76
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E003));//Claim amount is greater than allowed claim amount for this service provider
                return null;
            }
            //Update the claim with the values of this section   
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;    
            update claim;
            if(showTravel == true){
                disableTravel = False;
                TabInFocus = 'TravelTab'; 
            } else{
                disableClaimable = False;
                TabInFocus = 'ClaimableTab'; 
            }            
            disableParts = true;
            rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Travel' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
            this.claim.RecordTypeId = rt.Id;  
            checkRegion();
            return null; 
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveTravel(){
        try{
            //System.debug('validateTravelODM');
            if(validateTravelODM()){
                return null;
            }
            // Always after pressing Save in Travel, next tab should be Other Claimable - Apr 3rd 2019
            //if(this.claim.CSS_WS_Account_Code__c != 'P89'){
                //Add validation actions if apply
                CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Claim_Amount__c, CSS_WS_Policy_Flag__c, CSS_WS_Covered_Meals_Lodging__c, CSS_WS_Covered_Towing_Miles__c,
                    CSS_WS_Covered_Travel_Labor__c, CSS_WS_Account_Code_Type__c FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id];
                Account SPMaxAmount = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
                if(claimData.CSS_WS_Claim_Amount__c > SPMaxAmount.CSS_WS_Max_Claim_Amount__c){//Rule SF76
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E003));//Claim amount is greater than allowed claim amount for this service provider
                    return null;
                }
                if(this.claim.CSS_WS_Travel_Hours__c > this.claim.CSS_WS_Travel_Distance__c && SPMaxAmount.BillingCountry.toUpperCase() != 'MEXICO'){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E045));//Travel hours should not be greater than travel distance
                    return null;
                }
                if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && SPMaxAmount.BillingCountry.toUpperCase() != 'MEXICO'){
                    if(this.claim.CSS_WS_Lodging__c != null && claimData.CSS_WS_Covered_Meals_Lodging__c!= null){//Rule SF81
                        if((this.claim.CSS_WS_Lodging__c > claimData.CSS_WS_Covered_Meals_Lodging__c) && claimData.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && claimData.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E043 + ' ' + claimData.CSS_WS_Covered_Meals_Lodging__c + ' ' + Label.CSS_WS_Claim_E021 ));//The coverage doesnt cover more than
                            return null;
                        }
                    } 
                    if(this.claim.CSS_WS_Towing_Amount__c != null && claimData.CSS_WS_Covered_Towing_Miles__c != null){
                        if((this.claim.CSS_WS_Towing_Amount__c > claimData.CSS_WS_Covered_Towing_Miles__c) && claimData.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && claimData.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                            ApexPages.addmessage (new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E043 + ' ' + claimData.CSS_WS_Covered_Towing_Miles__c + ' ' + Label.CSS_WS_Claim_E044 ));//The coverage doesnt cover more than
                            return null;
                        }
                    } 
                    if(this.claim.CSS_WS_Travel_Hours__c != null && claimData.CSS_WS_Covered_Travel_Labor__c != null){
                        if((this.claim.CSS_WS_Travel_Hours__c > claimData.CSS_WS_Covered_Travel_Labor__c) && claimData.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && claimData.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E043 + ' ' + claimData.CSS_WS_Covered_Travel_Labor__c + ' '  +Label.CSS_WS_Claim_E046 ));//The coverage doesnt cover more than
                            return null;
                        }
                    }
                    if((this.claim.CSS_WS_Towing_Amount__c > claimData.CSS_WS_Covered_Towing_Miles__c && this.claim.CSS_WS_Campaigns_TRPs__c == null) && claimData.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && claimData.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E043 + ' ' + claimData.CSS_WS_Covered_Towing_Miles__c));//The coverage doesnt cover more than
                        return null;
                    }
                    if (((this.claim.CSS_WS_Campaign_Towing_Percentage__c == null || this.claim.CSS_WS_Campaign_Towing_Percentage__c < 1) && this.claim.CSS_WS_Campaigns_TRPs__c != null) && claimData.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && claimData.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E043 + ' ' + claimData.CSS_WS_Campaign_Towing_Percentage__c ));//The coverage doesnt cover more than
                        return null;
                    }
                } 
                if(this.claim.CSS_WS_Towing_Amount__c < 0 && SPMaxAmount.BillingCountry.toUpperCase() != 'MEXICO'){//Rule SF81
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Towing_Error ));//The coverage doesnt cover more than
                    return null;
                }
                if(this.claim.CSS_WS_HasError__c >= 1){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                    return null;
                }
                this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
                update claim;  
                disableClaimable = False; 
                TabInFocus = 'ClaimableTab'; 
                disableTravel = True;
                rt = [SELECT Id FROM RecordType WHERE Name = 'CSS_WS_RT_Claimable' AND SobjectType = 'CSS_WS_Warranty__c' LIMIT 1];
                this.claim.RecordTypeId = rt.Id;  
                return null;
            /*} else { 
                if(this.claim.CSS_WS_HasError__c == 1){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                    return null;
                }
                odmWarnings = new List <String>();
                if(validatePreSubmitODM()){
                    if(this.claim.CSS_WS_HasError__c == 4){
                        showPopup();
                        odmWarnings.add(this.claim.CSS_WS_HasMessage__c);
                    }
                    return null;
                }
                return continueSubmission();
            }*/        
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveClaimable(){
        try{
            //Add validation actions if apply
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false; 
            if(this.claim.CSS_WS_HasError__c == 1){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.claim.CSS_WS_HasMessage__c));
                return null;
            }
            CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Claim_Amount__c FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id];
            Account SPMaxAmount = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
            if(claimData.CSS_WS_Claim_Amount__c > SPMaxAmount.CSS_WS_Max_Claim_Amount__c){//Rule SF76
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E003));//Claim amount is greater than allowed claim amount for this service provider
                return null;
            }
            odmWarnings = new List <String>();
            if(validatePreSubmitODM()){
                if(this.claim.CSS_WS_HasError__c == 4){
                    showPopup();
                    odmWarnings.add(this.claim.CSS_WS_HasMessage__c);
                }
                return null;
            }
            return continueSubmission();
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference saveDLRDetails(){
        try {
            if(this.claim.CSS_WS_DLR_Payment_Date__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E007));//DRL Payment Date should not be empty
                return null;
            }
            if(this.claim.CSS_WS_DLR_Credit_Number__c == null || this.claim.CSS_WS_DLR_Credit_Number__c == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E008));//DRL Credit Number should not be empty
                return null;
            }
            this.claim.CSS_WS_Claim_Status__c = 'Paid';
            this.claim.CSS_WS_DR_Payment_Date__c = System.Today();
            update this.claim;
            Approval.LockResult lockResult = Approval.lock(this.claim);
            pagereference pr = new pagereference('/' + claim.id);
            return pr;
        } catch(System.Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            return null;
        }  
    }
    
    Public PageReference backToHeaderDisabled() {
        try {
            //Change Record Type in order to not apply Validation Rules for current tab
            //Update the claim with the values of this section      
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            update claim;
            //Flags to redirect the correct tab
            disablePolicy = true;
            disableFailure = true;
            TabInFocus = 'HeaderTab'; 
            disableHeader = False;
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference backFailure(){
        try {
            //Change Record Type in order to not apply Validation Rules for current tab
            rt = [select Id from RecordType where Name = 'CSS_WS_RT_Header' and SobjectType = 'CSS_WS_Warranty__c' limit 1];
            this.claim.RecordTypeId = rt.Id; 
            //Update the claim with the values of this section      
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            update claim;
            //Flags to redirect the correct tab
            disablePolicy = False;
            TabInFocus = 'PolicyTab'; 
            disableFailure = True;
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference backMultiESN(){
        try {             
            //Update the claim with the values of this section      
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            update claim;
            //Flags to redirect the correct tab
            disableFailure = False;
            TabInFocus = 'FailureTab'; 
            disableMultiESN = True;
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference backNarrative(){
        try {                     
            //Update the claim with the values of this section      
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            update claim; 
            //Flags to redirect the correct tab
            if(this.claim.CSS_WS_Multi_ESN__c){
                disableMultiESN = False;
                TabInFocus = 'MultiESNTab';           
            } else {
                disableFailure = False;
                TabInFocus = 'FailureTab'; 
            }
            disableNarrative = True;
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference backSRT(){
        try {
            //Change Record Type in order to not apply Validation Rules for current tab
            rt = [select Id from RecordType where Name = 'CSS_WS_RT_Failure' and SobjectType = 'CSS_WS_Warranty__c' limit 1];
            this.claim.RecordTypeId = rt.Id;             
            //Update the claim with the values of this section  
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;    
            update claim;            
            //Flags to redirect the correct tab
            disableNarrative = False;
            TabInFocus = 'NarrativeTab'; 
            disableSRT = True;
            return null;
        } catch(System.Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference backParts(){
        try {
            //Update the claim with the values of this section   
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;  
            update claim;            
            if(flagSRT == false){
                disableSRT = False;
                TabInFocus = 'SRTTab'; 
                disableNarrative = True;
                rt = [select Id from RecordType where Name = 'CSS_WS_RT_SRT' and SobjectType = 'CSS_WS_Warranty__c' limit 1];                
            } else {              
                disableNarrative = False;
                TabInFocus = 'NarrativeTab';                
                rt = [select Id from RecordType where Name = 'CSS_WS_RT_Narrative' and SobjectType = 'CSS_WS_Warranty__c' limit 1];
            }
            disableParts = True;  
            this.claim.RecordTypeId = rt.Id; 
            return null;            
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }       
    }
    
    Public PageReference backTravel(){
        try {
            //Change Record Type in order to not apply Validation Rules for current tab
            rt = [select Id from RecordType where Name = 'CSS_WS_RT_Parts' and SobjectType = 'CSS_WS_Warranty__c' limit 1];
            this.claim.RecordTypeId = rt.Id;            
            //Update the claim with the values of this section      
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            update claim;            
            //Flags to redirect the correct tab
            if(claim.CSS_WS_Account_Code__c != 'P89'){
                disableParts = False;
                TabInFocus = 'PartsTab'; 
                disableTravel = True;
            } else {
                disableNarrative = False;
                TabInFocus = 'NarrativeTab'; 
                disableTravel = True;
            }
            return null;
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
    }
    
    Public PageReference backClaimable(){
        try {
            //Change Record Type in order to no apply Validation Rules
            rt = [select Id from RecordType where Name = 'CSS_WS_RT_Travel' and SobjectType = 'CSS_WS_Warranty__c' limit 1];
            this.claim.RecordTypeId = rt.Id;            
            //Update the claim with the values of this section      
            this.claim.CSS_WS_ODM_Call_Presubmit_Flag__c = false;
            update claim;            
            //Flags to redirect the correct tab            
            if(showTravel == true){
                disableTravel = False;
                TabInFocus = 'TravelTab'; 
            } else if (this.claim.CSS_WS_Account_Code__c == 'P89' && this.claim.CSS_WS_RescueNumber__c == null){ //Back button should redirect to Narrative becuase there is not Travel data
                disableNarrative = False;
                TabInFocus = 'NarrativeTab';  
            } else{
                disableParts = False;
                TabInFocus = 'PartsTab'; 
            }             
            disableClaimable = True;
            return null;
        } catch(System.DMLException e){
            ApexPages.addMessages(e);
            return null;
        }
    }    
    
    Public PageReference reloadEngineApplication(){
        try{
            CSS_WS_Engine_Application_Code__c code = [
                SELECT Application_Description__c, Default_Measurement__c FROM CSS_WS_Engine_Application_Code__c
                WHERE Name = :this.claim.CSS_WS_Engine_Application_Code__c];
            this.claim.CSS_WS_Failure_Measure__c = code.Default_Measurement__c;//Rule SF31
            this.claim.CSS_WS_Engine_Application__c = code.Application_Description__c;
        } catch (Exception e){
            this.claim.CSS_WS_Failure_Measure__c = '';
            this.claim.CSS_WS_Engine_Application__c = '';
        }
        R04067_SF17();
        return null;
    }
    
    Public PageReference clearTravelModeDetail(){
        this.claim.CSS_WS_Travel_Detail_Mode__c = '';
        return null;
    }
    
    Public Static Account getSelectedSPAccount(String SPDRCode, String SPDLCode){//ChangesApply
        List<Account> SPAccount = new List<Account>();
        if(!String.isEmpty(SPDRCode) && !String.isEmpty(SPDLCode)){
            if(SPDRCode == SPDLCode){
                SPAccount = [SELECT CSS_WS_Max_Claim_Amount__c, CSS_WS_Paccar_DLR_Flag__c, CSS_WS_Region_Code__c, BillingCountry, 
                             CSS_WS_Territory_Code__c, Warranty_Training_Certification__c, CSS_WS_Address_ID_Bill__c, 
                             CSS_WS_Address_ID_Ship__c, CSS_WS_Campaign_TRP__c, CSS_WS_Claim_Allow_Days__c, CSS_WS_Customer_ID__c, 
                             CSS_WS_Channel_Code__c FROM Account WHERE (Type =: 'Distributor Account' OR Type =: 'Distributor Branch Account') 
                             AND IAM_Service_Provider_Code__c =: SPDRCode AND CMI_Account_Status__c =: 'Active' LIMIT 1];
            } else {
                SPAccount = [SELECT CSS_WS_Max_Claim_Amount__c, CSS_WS_Paccar_DLR_Flag__c, CSS_WS_Region_Code__c, BillingCountry, 
                             CSS_WS_Territory_Code__c, Warranty_Training_Certification__c, CSS_WS_Address_ID_Bill__c, 
                             CSS_WS_Address_ID_Ship__c, CSS_WS_Campaign_TRP__c, CSS_WS_Claim_Allow_Days__c, CSS_WS_Customer_ID__c, 
                             CSS_WS_Channel_Code__c FROM Account WHERE IAM_Service_Provider_Code__c =: SPDLCode AND CSS_DBCode__c =: SPDRCode 
                             AND (Type =: 'Dealer Account' OR Type =: 'Dealer Branch Account') AND CMI_Account_Status__c =: 'Active' LIMIT 1];
            }
        }
        if(SPAccount.size() > 0){    
            return SPAccount[0];
        }
        return null;    
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
                if( dates != null){
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
    
    Public Boolean validateHeaderODM(){
        if(this.claim.CSS_WS_Policy_Flag__c!='Policy WW'){
            Map<String, String> header = new Map<String,String>{};            
            Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
            if(SPPreferences.BillingCountry.toUpperCase() == 'MEXICO'){
                this.isMexico = true;
            }
            header.put('bisFlag',(this.claim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
            header.put('cmiEngineSerialNumber',this.claim.CSS_WS_Engine_Serial_Number__c);
            header.put('cmiServiceProviderCode',this.claim.CSS_WS_Service_Provider_Dealer__c);
            header.put('engineFamily',this.claim.CSS_WS_Engine_Family_Code__c);
            header.put('failureDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
            header.put('failureMeasure',this.claim.CSS_WS_Failure_Measure__c);
            header.put('failurePoint',this.claim.CSS_WS_Failure_Point_Quantity__c);
            header.put('manualAdjudicationFlag','');
            header.put('multiESNFlag',(this.claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
            header.put('productApplicationCode',this.claim.CSS_WS_Product_Application_Code__c);
            header.put('roNumber',this.claim.CSS_WS_Repair_Work_Order_Number__c);
            header.put('serviceModelName',this.claim.CSS_WS_Service_Model__c);
            header.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
            header.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
            header.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c);
            header.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
            //header.put('territory',SPPreferences.BillingCountry);
            header.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
            header.put('outfileAllClaimsFlag','Y');
            header.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
            header.put('engineFamilyCode',this.claim.CSS_WS_Engine_Family_Code__c);
            header.put('marineFlag',(this.claim.CSS_WS_Marine_Application_Flag__c!=null)?this.claim.CSS_WS_Marine_Application_Flag__c:'');
            header.put('buildDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Build_Date__c, 'MM/dd/yyyy'));
            header.put('etoConversionDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Engine_Trade_Out_conversion_date__c, 'MM/dd/yyyy'));
            header.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c== true)? 'Y' : 'N');
            header.put('productApplicationDesp',(this.claim.CSS_WS_Product_Application_Description__c!=null)?this.claim.CSS_WS_Product_Application_Description__c:'');
            header.put('reconPartsWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N');
            header.put('newPartsWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Nuevo') ? 'Y' : 'N');
            header.put('roadRelayWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
            header.put('engineApplicationCode',this.claim.CSS_WS_Engine_Application_Code__c);
            
            CSS_WS_J2A_ODM_Validation ODMResponse = CSS_WS_GetWebServiceData.getODMValidationHeader(header);//WS Call 3            
            if(ODMResponse != null){
                if(ODMResponse.Response.claim.status.touppercase()=='ERROR'){
                    for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                        this.DisplayAsincErrorHandler(ODMResponse.Response.claim.messages[i].description);
                    }                    
                    return false;
                }  else if (ODMResponse.Response.claim.status.touppercase()=='WARNING') {
                    //System.debug('Warning agregado');
                    this.claim.CSS_WS_HasError__c = 4;
                    for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                        showPopup();
                        odmWarnings.add(ODMResponse.Response.claim.messages[i].description);
                        this.claim.CSS_WS_HasMessage__c = ODMResponse.Response.claim.messages[i].description;
                        //System.debug('Warning agregado ' + this.claim.CSS_WS_HasMessage__c);
                    }
                }
                this.Penaltytem = ODMResponse.Response.claim.penalty != null ? ODMResponse.Response.claim.penalty: '0';
                if(ODMResponse.Response.claim.certificationFlag == 'N' && (this.claim.CSS_WS_Service_Provider_DR__c != this.claim.CSS_WS_Service_Provider_Dealer__c) 
                   && SPPreferences.BillingCountry.toUpperCase() == 'MEXICO' && this.claim.CSS_WS_Warranty_Type__c == 'Motor'){
                    this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E063);//It is not possible to process this claim given that this Dealer is not certified in this engine service model. Please contact your Regional Distributor
                    closePopup();
                    return false;
                }
            } else {
                this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                closePopup();
                return false;
            }
        }
        return true;
    } 
    
    Public Boolean validateTravelODM(){
        if(this.claim.CSS_WS_Policy_Flag__c != 'Policy WW'){
            try{
                //Query fields not available in the frontend
                CSS_WS_Warranty__c claimData = [
                    SELECT CSS_WS_Pay_Code__c, CSS_WS_Product_Application_Code__c, CSS_WS_Product_Application_Description__c,
                    CSS_WS_Marine_Application_Flag__c, CSS_WS_Build_Date__c, CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Approval_Code__c,
                    CSS_WS_Account_Code_Type__c, CSS_WS_Towing_Amount__c, CSS_WS_Covered_Travel_Labor__c, CSS_WS_Covered_Travel_Miles__c,
                    CSS_WS_Covered_Meals_Lodging__c, CSS_WS_Covered_Towing_Miles__c,CSS_WS_Total_Amount_SRT_Hours__c, CSS_WS_InShopCampaignFlag__c
                    FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id];
                Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c); 
                Map<String, String> header = new Map<String,String>{};
                    
                header.put('bisFlag',(this.claim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
                header.put('cmiEngineSerialNumber',this.claim.CSS_WS_Engine_Serial_Number__c);
                header.put('cmiServiceProviderCode',this.claim.CSS_WS_Service_Provider_Dealer__c);
                header.put('engineFamily',this.claim.CSS_WS_Engine_Family_Code__c);
                header.put('failureDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                header.put('failureMeasure',this.claim.CSS_WS_Failure_Measure__c);
                header.put('failurePoint',this.claim.CSS_WS_Failure_Point_Quantity__c);
                header.put('manualAdjudicationFlag','');
                header.put('multiESNFlag',(this.claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                header.put('productApplicationCode',claimData.CSS_WS_Product_Application_Code__c);
                header.put('roNumber',this.claim.CSS_WS_Repair_Work_Order_Number__c);
                header.put('serviceModelName',this.claim.CSS_WS_Service_Model__c);
                header.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
                header.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
                header.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c);
                header.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
                //header.put('territory',SPPreferences.BillingCountry);
                header.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
                header.put('outfileAllClaimsFlag','Y');
                header.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
                header.put('engineFamilyCode',this.claim.CSS_WS_Engine_Family_Code__c);
                header.put('marineFlag',(claimData.CSS_WS_Marine_Application_Flag__c!=null)?claimData.CSS_WS_Marine_Application_Flag__c:'');
                header.put('buildDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Build_Date__c, 'MM/dd/yyyy'));
                header.put('etoConversionDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Engine_Trade_Out_conversion_date__c, 'MM/dd/yyyy'));
                header.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c== true)? 'Y' : 'N');
                header.put('productApplicationDesp',(claimData.CSS_WS_Product_Application_Description__c!=null)?claimData.CSS_WS_Product_Application_Description__c:'');
                if(this.claim.CSS_WS_Account_Code__c == '61'){
                    header.put('reconPartsWarrantyFlag','N');
                    header.put('newPartsWarrantyFlag','N');
                    header.put('roadRelayWarrantyFlag','N');
                } else {
                    header.put('reconPartsWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N');
                    header.put('newPartsWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Nuevo') ? 'Y' : 'N');
                    header.put('roadRelayWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
                }                              
                header.put('engineApplicationCode',this.claim.CSS_WS_Engine_Application_Code__c);
                
                //Failure Data ******************************************************************************************************************     
                List<CSS_WS_Failure__c> fail = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c, CSS_WS_FailureModeCode__c
                    FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :this.claim.Id];  
                List<Map<String, String>> failure = new List<Map<String, String>> ();
                for(CSS_WS_Failure__c cont_fail: fail){
                    Map<String, String> failureData = new Map<String,String>{};
                    failureData.put('campaignId',(String.isEmpty(this.claim.CSS_WS_Campaigns_TRPs__c)) ? '' : this.claim.CSS_WS_Campaigns_TRPs__c);
                    failureData.put('payCode',(String.isEmpty(claimdata.CSS_WS_Pay_Code__c)) ? '' : claimdata.CSS_WS_Pay_Code__c);
                    failureData.put('totalLaborAmt','');
                    failureData.put('authorizationNumber',(this.claim.CSS_Authorization_Number__c!= NULL)?String.valueOf(this.claim.CSS_Authorization_Number__c):'');
                    failureData.put('approvalCode',(claimData.CSS_WS_Approval_Code__c!=null)?claimData.CSS_WS_Approval_Code__c:'');
                    failureData.put('totalTowingAmt',(this.claim.CSS_WS_Towing_Amount__c!=null)?String.valueof(this.claim.CSS_WS_Towing_Amount__c):'');
                    failureData.put('accountCode',this.claim.CSS_WS_Account_Code__c);
                    failureData.put('failCode',cont_fail.CSS_WS_EngineSystemCode__c + cont_fail.CSS_WS_ComponentCode__c);
                    failureData.put('coverageType',claimdata.CSS_WS_Account_Code_Type__c);
                    failureData.put('failMode',cont_fail.CSS_WS_FailureModeCode__c);
                    failureData.put('accountCodeType',claimdata.CSS_WS_Account_Code_Type__c);
                    failureData.put('multiESNFlag',(this.claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                    failureData.put('accountCode',this.claim.CSS_WS_Account_Code__c);   
                    failureData.put('inShopCampaignFlag',(claimData.CSS_WS_InShopCampaignFlag__c != null) ? claimData.CSS_WS_InShopCampaignFlag__c : 'N');  
                    failure.add(failureData);
                }
                
                //Travel Data ******************************************************************************************************************
                List<Map<String, String>> travel = new List<Map<String, String>> ();
                Map<String, String> travelData = new Map<String,String>{};
                if(SPPreferences.BillingCountry.toUpperCase() == 'MEXICO'){
                    Decimal laborHours = (claimData.CSS_WS_Covered_Travel_Labor__c != null)? claimData.CSS_WS_Covered_Travel_Labor__c:0;
                    if(laborHours < this.claim.CSS_WS_Travel_Hours__c){
                        travelData.put('hours',String.valueof(laborHours));
                    } else {
                        travelData.put('hours',(this.claim.CSS_WS_Travel_Hours__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Hours__c):'');
                    }
                    Decimal travelMiles = (claimData.CSS_WS_Covered_Travel_Miles__c != null)? claimData.CSS_WS_Covered_Travel_Miles__c:0;

                    if(travelMiles < this.claim.CSS_WS_Travel_Distance__c){
                        travelData.put('travelDistance',String.valueof(travelMiles));
                    } else {
                        travelData.put('travelDistance',(this.claim.CSS_WS_Travel_Distance__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Distance__c):'');
                    }
                    Decimal mealsAmount = (claimData.CSS_WS_Covered_Meals_Lodging__c != null)? claimData.CSS_WS_Covered_Meals_Lodging__c:0;
                    Decimal srtHours = (claimData.CSS_WS_Total_Amount_SRT_Hours__c!= null)? claimData.CSS_WS_Total_Amount_SRT_Hours__c:0;
                    Decimal travelHours = (this.claim.CSS_WS_Travel_Hours__c!= null)? this.claim.CSS_WS_Travel_Hours__c:0;
                    if((travelHours + srtHours) < 8){//Do not send data if Labor is less than 8 -- Rule 04-295
                        travelData.put('mealsCharges','');
                    } else if(mealsAmount < this.claim.CSS_WS_Lodging__c) {
                        travelData.put('mealsCharges',String.valueof(mealsAmount));
                    } else {
                        travelData.put('mealsCharges',(this.claim.CSS_WS_Lodging__c!=null)?String.valueof(this.claim.CSS_WS_Lodging__c):'');
                    }
                    Decimal towingAmount = (claimData.CSS_WS_Covered_Towing_Miles__c!= null)? claimData.CSS_WS_Covered_Towing_Miles__c:0;

                    if(towingAmount < this.claim.CSS_WS_Towing_Amount__c){
                        travelData.put('towingCharges',String.valueof(towingAmount));
                    } else {
                        travelData.put('towingCharges',(claimdata.CSS_WS_Towing_Amount__c!=null)?String.valueof(claimdata.CSS_WS_Towing_Amount__c):'');
                    }
                } else {
                    travelData.put('mealsCharges',(this.claim.CSS_WS_Lodging__c!=null)?String.valueof(this.claim.CSS_WS_Lodging__c):'');
                    travelData.put('towingCharges',(claimdata.CSS_WS_Towing_Amount__c!=null)?String.valueof(claimdata.CSS_WS_Towing_Amount__c):'');
                    travelData.put('hours',(this.claim.CSS_WS_Travel_Hours__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Hours__c):'');
                    travelData.put('travelDistance',(this.claim.CSS_WS_Travel_Distance__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Distance__c):'');
                }        
                travel.add(travelData);
                CSS_WS_J2A_ODM_Validation ODMResponse = CSS_WS_GetWebServiceData.getODMValidationTravel(header, failure, travel);
                if(ODMResponse == null){
                    return true;
                } else if(ODMResponse.Response.claim.status.toUpperCase() == 'ERROR') {
                    for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ODMResponse.Response.claim.messages[i].description));
                    }
                    return true; 
                } else if(ODMResponse.Response.claim.status.toUpperCase() == 'WARNING'){
                    for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ODMResponse.Response.claim.messages[i].description));
                    }
                }
            } catch(System.Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                //System.Debug(e.getMessage());
                return true;
            }
        }
        return false;
    }
    
    Public Boolean validatePreSubmitODM() {
        if(this.claim.CSS_WS_Policy_Flag__c != 'Policy WW'){
             try{
                 CSS_WS_Warranty__c claimData = [
                     SELECT CSS_WS_Pay_Code__c, CSS_WS_Warranty_Subtype__c, CSS_WS_Product_Application_Code__c, CSS_WS_Product_Application_Description__c,
                     CSS_WS_Marine_Application_Flag__c, CSS_WS_Claim_Type__c, CSS_WS_Multi_ESN__c, CSS_WS_Build_Date__c, CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Approval_Code__c,
                     CSS_WS_Account_Code_Type__c, CSS_WS_Towing_Amount__c,CSS_WS_Total_Amount_SRT__c, CSS_WS_Claim_Amount__c, CSS_WS_Total_Amount_Travel__c,
                     CSS_WS_Covered_Travel_Labor__c, CSS_WS_Covered_Travel_Miles__c, CSS_WS_Covered_Meals_Lodging__c, CSS_WS_Covered_Towing_Miles__c,
                     CSS_WS_Total_Amount_SRT_Hours__c, CSS_WS_InShopCampaignFlag__c 
                     FROM CSS_WS_Warranty__c WHERE Id =: this.claim.Id];
                 Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);    
                 Map<String, String> ODMRequestBodyHeader = new Map<String,String>{};   
                     
                 ODMRequestBodyHeader.put('bisFlag',(this.claim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
                 ODMRequestBodyHeader.put('cmiEngineSerialNumber',this.claim.CSS_WS_Engine_Serial_Number__c);
                 ODMRequestBodyHeader.put('cmiServiceProviderCode',this.claim.CSS_WS_Service_Provider_Dealer__c);
                 ODMRequestBodyHeader.put('engineFamily',this.claim.CSS_WS_Engine_Family_Code__c);
                 ODMRequestBodyHeader.put('failureDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                 ODMRequestBodyHeader.put('failureMeasure',this.claim.CSS_WS_Failure_Measure__c);
                 ODMRequestBodyHeader.put('failurePoint',this.claim.CSS_WS_Failure_Point_Quantity__c);
                 ODMRequestBodyHeader.put('manualAdjudicationFlag','');
                 ODMRequestBodyHeader.put('multiESNFlag',(this.claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                 ODMRequestBodyHeader.put('productApplicationCode',claimData.CSS_WS_Product_Application_Code__c);
                 ODMRequestBodyHeader.put('roNumber',this.claim.CSS_WS_Repair_Work_Order_Number__c);
                 ODMRequestBodyHeader.put('serviceModelName',this.claim.CSS_WS_Service_Model__c);
                 ODMRequestBodyHeader.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
                 ODMRequestBodyHeader.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
                 ODMRequestBodyHeader.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c);
                 ODMRequestBodyHeader.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
                 //ODMRequestBodyHeader.put('territory',SPPreferences.BillingCountry);
                 ODMRequestBodyHeader.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
                 ODMRequestBodyHeader.put('outfileAllClaimsFlag','Y');
                 ODMRequestBodyHeader.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
                 ODMRequestBodyHeader.put('engineFamilyCode',this.claim.CSS_WS_Engine_Family_Code__c);
                 ODMRequestBodyHeader.put('marineFlag',(claimData.CSS_WS_Marine_Application_Flag__c!=null)?claimData.CSS_WS_Marine_Application_Flag__c:'');
                 ODMRequestBodyHeader.put('buildDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Build_Date__c, 'MM/dd/yyyy'));
                 ODMRequestBodyHeader.put('etoConversionDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Engine_Trade_Out_conversion_date__c, 'MM/dd/yyyy'));
                 ODMRequestBodyHeader.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c== true)? 'Y' : 'N');
                 ODMRequestBodyHeader.put('productApplicationDesp',(claimData.CSS_WS_Product_Application_Description__c!=null)?claimData.CSS_WS_Product_Application_Description__c:'');
                 if(this.Claim.CSS_WS_Account_Code__c == '61'){
                    ODMRequestBodyHeader.put('reconPartsWarrantyFlag','N');
                    ODMRequestBodyHeader.put('newPartsWarrantyFlag','N');
                    ODMRequestBodyHeader.put('roadRelayWarrantyFlag','N');
                 } else {
                    ODMRequestBodyHeader.put('reconPartsWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N');
                    ODMRequestBodyHeader.put('newPartsWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Nuevo') ? 'Y' : 'N');
                    ODMRequestBodyHeader.put('roadRelayWarrantyFlag',(this.claim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
                 }
                 ODMRequestBodyHeader.put('totalClaimAmt',String.valueof(claimData.CSS_WS_Claim_Amount__c));
                 ODMRequestBodyHeader.put('engineApplicationCode',this.claim.CSS_WS_Engine_Application_Code__c);
                 
                 //Failure Data ******************************************************************************************************************
                 List<CSS_WS_Failure__c> Failures = new List<CSS_WS_Failure__c>([SELECT 
                    CSS_WS_ComponentCode__c,
                    CSS_WS_EngineSystemCode__c,
                    CSS_WS_FailureModeName__c,
                    CSS_WS_FailureModeCode__c
                 FROM CSS_WS_Failure__c WHERE CSS_WS_Failure__c.CSS_WS_Warranty__c =: this.claim.Id]);
                 List<Map<String, String>> ODMRequestFailure = new List<Map<String, String>> ();
                 if(Failures != null){  
                     for(integer i = 0; i<Failures.size(); i++){  
                         Map<String, String> failureData = new Map<String,String>{};
                         failureData.put('campaignId',(String.isEmpty(this.claim.CSS_WS_Campaigns_TRPs__c)) ? '' : this.claim.CSS_WS_Campaigns_TRPs__c);
                         failureData.put('payCode',claimdata.CSS_WS_Pay_Code__c);
                         failureData.put('totalLaborAmt',(this.claim.CSS_WS_Total_Amount_SRT__c!=null)?String.valueof(this.claim.CSS_WS_Total_Amount_SRT__c):'');
                         failureData.put('authorizationNumber',(this.Claim.CSS_Authorization_Number__c!= NULL)?String.valueOf(this.Claim.CSS_Authorization_Number__c):'');
                         failureData.put('approvalCode',(claimData.CSS_WS_Approval_Code__c!=null)?claimData.CSS_WS_Approval_Code__c:'');
                         failureData.put('totalTowingAmt',(this.claim.CSS_WS_Towing_Amount__c!=null)?String.valueof(this.claim.CSS_WS_Towing_Amount__c):'');
                         failureData.put('accountCode',this.Claim.CSS_WS_Account_Code__c);
                         failureData.put('failCode',Failures[i].CSS_WS_EngineSystemCode__c + Failures[i].CSS_WS_ComponentCode__c);
                         failureData.put('coverageType',claimdata.CSS_WS_Account_Code_Type__c);
                         failureData.put('failMode',Failures[i].CSS_WS_FailureModeCode__c);
                         failureData.put('accountCodeType',claimdata.CSS_WS_Account_Code_Type__c);
                         failureData.put('multiESNFlag',(this.Claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                         failureData.put('accountCode',this.Claim.CSS_WS_Account_Code__c);   
                         failureData.put('inShopCampaignFlag',(claimData.CSS_WS_InShopCampaignFlag__c != null) ? claimData.CSS_WS_InShopCampaignFlag__c : 'N');
                         ODMRequestFailure.add(failureData);
                     }
                 }
                 
                 //Parts Data ******************************************************************************************************************
                 String BISFlag = (this.Claim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N';
                 String MultiESNFlag = (this.Claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N';
                 String ReconPartsFlag = (this.Claim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N';
                 List<CSS_WS_Warranty_Parts__c> Parts = new List<CSS_WS_Warranty_Parts__c>([SELECT                                                               
                    CSS_WS_Long_Part_Number_del__c,
                    CSS_WS_Siebel_Unit_Part_Price__c
                 FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_Warranty_Parts__c.CSS_WS_WarrantyID__c =: this.claim.Id]);
                 List<Map<String, String>> ODMRequestPart= new List<Map<String, String>>();
                 if(Parts != null){  
                     for(integer i = 0; i<Parts.size(); i++){
                         Map<String, String> partList = new Map<String, String>();
                         partList.put('partId',Parts[i].CSS_WS_Long_Part_Number_del__c);    //partId
                         partList.put('partPrice',String.valueof(Parts[i].CSS_WS_Siebel_Unit_Part_Price__c));    //price
                         ODMRequestPart.add(partList);
                     }   
                 }
                 
                 //Travel Data ******************************************************************************************************************
                 List<Map<String, String>> ODMRequestTravel = new List<Map<String, String>> ();
                 if(claimData.CSS_WS_Total_Amount_Travel__c > 0 ){
                     Map<String, String> travelData = new Map<String,String>{};
                     if(SPPreferences.BillingCountry.toUpperCase() == 'MEXICO'){
                        Decimal laborHours = (claimData.CSS_WS_Covered_Travel_Labor__c != null)? claimData.CSS_WS_Covered_Travel_Labor__c:0;
                        if(laborHours < this.claim.CSS_WS_Travel_Hours__c){
                            travelData.put('hours',String.valueof(laborHours));
                        } else {
                            travelData.put('hours',(this.claim.CSS_WS_Travel_Hours__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Hours__c):'');
                        }
                        Decimal travelMiles = (claimData.CSS_WS_Covered_Travel_Miles__c != null)? claimData.CSS_WS_Covered_Travel_Miles__c:0;
                        if(travelMiles < this.claim.CSS_WS_Travel_Distance__c){
                            travelData.put('travelDistance',String.valueof(travelMiles));
                        } else {
                            travelData.put('travelDistance',(this.claim.CSS_WS_Travel_Distance__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Distance__c):'');
                        }
                        Decimal mealsAmount = (claimData.CSS_WS_Covered_Meals_Lodging__c != null)? claimData.CSS_WS_Covered_Meals_Lodging__c:0;
                        Decimal srtHours = (claimData.CSS_WS_Total_Amount_SRT_Hours__c!= null)? claimData.CSS_WS_Total_Amount_SRT_Hours__c:0;
                        Decimal travelHours = (this.claim.CSS_WS_Travel_Hours__c!= null)? this.claim.CSS_WS_Travel_Hours__c:0;
                        if((travelHours + srtHours) < 8){ //Do not send data if Labor is less than 8 -- Rule 04-295
                            travelData.put('mealsCharges','');
                        } else if(mealsAmount < this.claim.CSS_WS_Lodging__c){
                            travelData.put('mealsCharges',String.valueof(mealsAmount));
                        } else {
                            travelData.put('mealsCharges',(this.claim.CSS_WS_Lodging__c!=null)?String.valueof(this.claim.CSS_WS_Lodging__c):'');
                        }
                        Decimal towingAmount = (claimData.CSS_WS_Covered_Towing_Miles__c!= null)? claimData.CSS_WS_Covered_Towing_Miles__c:0;
                        if(towingAmount < this.claim.CSS_WS_Towing_Amount__c){
                            travelData.put('towingCharges',String.valueof(towingAmount));
                        } else {
                            travelData.put('towingCharges',(claimdata.CSS_WS_Towing_Amount__c!=null)?String.valueof(claimdata.CSS_WS_Towing_Amount__c):'');
                        }
                    } else {
                        travelData.put('mealsCharges',(this.claim.CSS_WS_Lodging__c!=null)?String.valueof(this.claim.CSS_WS_Lodging__c):'');
                        travelData.put('towingCharges',(claimdata.CSS_WS_Towing_Amount__c!=null)?String.valueof(claimdata.CSS_WS_Towing_Amount__c):'');
                        travelData.put('hours',(this.claim.CSS_WS_Travel_Hours__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Hours__c):'');
                        travelData.put('travelDistance',(this.claim.CSS_WS_Travel_Distance__c!=null)?String.valueof(this.claim.CSS_WS_Travel_Distance__c):'');
                    }  
                    ODMRequestTravel.add(travelData);        
                 }
                 
                 //OtherClaimables Data ******************************************************************************************************************
                 List<CSS_WS_Other_Claimable__c> Claimables = new List<CSS_WS_Other_Claimable__c>([SELECT 
                    Name,                                                                       
                    CSS_WS_Warranty__c,
                    CSS_WS_Claimed_Reason__c,
                    CSS_WS_Description__c,
                    CSS_WS_Claimable__c,
                    CSS_WS_Requested_Amount__c                                               
                 FROM CSS_WS_Other_Claimable__c WHERE CSS_WS_Other_Claimable__c.CSS_WS_Warranty__c =: this.claim.Id]);
                 List<Map<String, String>> ODMRequestClaimables = new List<Map<String, String>>();
                 String OtherClaimable;
                 if(Claimables != null){
                     for(Integer i = 0; i < Claimables.size(); i++){
                         Map<String, String> Claimable = new Map<String, String>();
                         OtherClaimable = (Claimables[i].CSS_WS_Claimable__c.contains('Unlisted')) ? 'UNLISTED' : Claimables[i].CSS_WS_Claimable__c.touppercase();
                         Claimable.put('Amount', String.valueOf(Claimables[i].CSS_WS_Requested_Amount__c));
                         Claimable.put('details', Claimables[i].CSS_WS_Description__c.touppercase());
                         Claimable.put('item', OtherClaimable);
                         ODMRequestClaimables.add(Claimable);
                     }
                 }
                 
                 //SRTs Data ******************************************************************************************************************
                 List<CSS_WS_Warranty_SRT__c> SRTs = new List<CSS_WS_Warranty_SRT__c>([SELECT 
                    CSS_WS_Access_Code__c,
                    CSS_WS_Description__c,
                    CSS_WS_Hours__c,
                    CSS_WS_Offsite__c,
                    CSS_WS_Quantity__c,
                    CSS_WS_SRT__c
                 FROM CSS_WS_Warranty_SRT__c WHERE CSS_WS_Warranty_SRT__c.CSS_WS_WarrantyID__c =: this.claim.Id]);
                 List<Map<String, String>> ODMRequestSRT = new List<Map<String, String>>();
                 if(SRTs != null){
                     for(Integer i = 0; i < SRTs.size(); i++){
                         Map<String, String> SRT = new Map<String, String>();
                         SRT.put('description', SRTs[i].CSS_WS_Description__c);
                         SRT.put('hours', String.valueOf(SRTs[i].CSS_WS_Hours__c));
                         SRT.put('offsiteCheck', (SRTs[i].CSS_WS_Offsite__c == true) ? 'Y' : 'N');
                         SRT.put('quantity', String.valueof(SRTs[i].CSS_WS_Quantity__c));
                         SRT.put('code', CSS_WS_SRTGridController.getLongSRTCode(SRTs[i].CSS_WS_SRT__c));
                         ODMRequestSRT.add(SRT);
                     }
                 }  
                 CSS_WS_J2A_ODM_PreSubmit ODMResponse = CSS_WS_GetWebServiceData.getODMValidationPreSubmit(ODMRequestBodyHeader, ODMRequestFailure, ODMRequestPart, 
                                                                                                           ODMRequestTravel, ODMRequestClaimables, ODMRequestSRT);
                 if(ODMResponse != null){
                     if(ODMResponse.Response.claim.status != null){
                         if(ODMResponse.Response.claim.status.touppercase() == 'ERROR'){
                             for(integer i = 0; i<ODMResponse.Response.claim.messages.size(); i++){
                                 ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, ODMResponse.Response.claim.messages[i].description));
                                 return true;
                             }
                         } else if(ODMResponse.Response.claim.status == 'WARNING') {
                             for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                                 this.claim.CSS_ws_HasError__c = 4;
                                 odmWarnings.add(ODMResponse.Response.claim.messages[i].description);
                                 return false;
                             }
                         } else {
                             this.claim.CSS_WS_Manual_Adjudication_Flag__c = ODMResponse.Response.claim.manualAdjudicationFlag;
                             return false;
                         }
                     } else {
                         this.claim.CSS_WS_Manual_Adjudication_Flag__c = ODMResponse.Response.claim.manualAdjudicationFlag;
                         return false;
                     }
                 } else {
                     ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                     return true;
                 }                
            } catch(System.Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                return true;
            }
        }
        return false;
    }
   
    Public Boolean validateHeaderFields(){
    //Validation for Header fields - Not allow pass to next tab if not all required fields are filled
        //Validate DR should be selected
        if(this.claim.CSS_WS_Service_Provider_DR__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E029);//Please select a Distributor
            return false;
        }
            
        //Validate Dealer should be selected
        else if(this.claim.CSS_WS_Service_Provider_Dealer__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E028);//Please select a Dealer
            return false;            
        }
           
        //Validate ESN should not be null
        else if(this.claim.CSS_WS_Engine_Serial_Number__c == null || this.claim.CSS_WS_Engine_Serial_Number__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E013);//Engine Serial Number should not be empty
            return false;
        }
                    
        //Validate Warranty Type should not be null
        else if(this.claim.CSS_WS_Warranty_Type__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E032);//Please select a Warranty Type
            return false;
        }
            
        //Validate Failure Date should not be null
        else if(this.claim.CSS_WS_Failure_Date_Time__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E016);//Failure Date should not be empty
            return false;
        }
            
        //Validate Warranty Sub-Type should not be null
        else if((this.claim.CSS_WS_Warranty_Type__c == 'Motor') && (this.claim.CSS_WS_Warranty_Subtype__c == NULL) && (this.claim.CSS_WS_Policy_Flag__c == 'Warranty')){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E031);//Please select a Warranty Sub-type
            return false;
        }
        
        //Validate End of Repair Date should not be null
        else if(this.claim.CSS_WS_End_Repair_Date_Time__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E071);//End of Repair Date should not be empty
            return false;
        }
            
        //Validate Claim Type should not be null
        else if(this.claim.CSS_WS_Warranty_Type__c == 'Parte' && this.claim.CSS_WS_Claim_Type__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E027);//Please select a Claim Type
            return false;
        }
            
        //Validate Account Code should not be null
        else if((this.claim.CSS_WS_Policy_Flag__c == 'Policy' || this.claim.CSS_WS_Policy_Flag__c == 'Policy WW') && (this.claim.CSS_WS_Account_Code__c == null)){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E033);//Please select an Account Code
            return false;
        }
            
        //Validate Warranty Start Date should not be null
        else if((this.claim.CSS_WS_Warranty_Type__c == 'Parte') && (this.claim.CSS_WS_Warranty_Start_Date__c == null) && (this.claim.CSS_WS_Policy_Flag__c != 'Policy WW')){//Rule SF30
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E050);//Warranty Start Date should not be empty
            return false;
        }
            
        //Validate Service Model should not be null
        else if(this.claim.CSS_WS_Service_Model__c == null || this.claim.CSS_WS_Service_Model__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E042);//Service Model should not be empty
            return false;
        }
            
        //Validate Engine Application should not be null
        else if(this.claim.CSS_WS_Engine_Application_Code__c == null || this.claim.CSS_WS_Engine_Application_Code__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E012);//Engine Application should not be empty
            return false;
        }
            
        //Validate Customer Name should not be null
        else if(this.claim.CSS_WS_Customer_Name__c == null && this.claim.CSS_WS_Customer_Name_Internal__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E005);//Customer Name should not be empty
            return false;
        }
            
        //Validate Manufacturer should not be null
        else if(this.claim.CSS_WS_Manufacturer__c == null || this.claim.CSS_WS_Manufacturer__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E020);//Manufacturer should not be empty
            return false;
        }
            
        //Validate Failure Point Quantity should not be null
        else if(this.claim.CSS_WS_Failure_Point_Quantity__c == null || this.claim.CSS_WS_Failure_Point_Quantity__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E018);//Failure Point Quantity should not be empty
            return false;
        }
        
        //Validate Failure Point Quantity just allows numeric values
        else if(!Pattern.matches('[0-9]+', this.claim.CSS_WS_Failure_Point_Quantity__c)){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E079);//Failure Point Quantity just allows numeric values 
            return false;
        }
            
        //Validate Model Series should not be null
        else if(this.claim.CSS_WS_Model_Series__c == null || this.claim.CSS_WS_Model_Series__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E023);//Model Series should not be empty
            return false;
        }
            
        //Validate Failure Measure should not be null
        else if(this.claim.CSS_WS_Failure_Measure__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E030);//Please select a Failure Measure
            return false;
        }
            
        //Validate Complaint #1 should not be null
        else if(this.claim.CSS_WS_Complaints1__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E035);//Please select the Main Complaint
            return false;
        }
            
        //Validate Repair/Work Order # should not be null
        else if(this.claim.CSS_WS_Repair_Work_Order_Number__c == null || this.claim.CSS_WS_Repair_Work_Order_Number__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E039);//Repair/Work Order Number should not be empty
            return false;
        }
        
        //Validate Repair/Work Order # should not containg special characters
        else if(!Pattern.matches('[a-zA-Z0-9 ]+', this.claim.CSS_WS_Repair_Work_Order_Number__c)){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E062);//Repair/Work Order Number should not contain special characters
            return false;
        } 

        //Validate Authorization Number should not be null
        else if(this.claim.CSS_Authorization_Number__c == null && this.claim.CSS_WS_Policy_Flag__c == 'Policy WW'){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E037);//Authorization Number should not be empty
            return false;
        }
            
        //Validate Catastrophic should not be null
        else if(this.claim.CSS_WS_Catastrophic__c == null){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E034);//Please select if the failure was catastrophic or not
            return false;
        }
           
        //Validate Replacement Part should not be null
        else if((this.claim.CSS_WS_Catastrophic__c == 'Si' || this.claim.CSS_WS_Catastrophic__c == 'Yes') && (this.claim.CSS_WS_Replacement_Part__c == null)){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E040);//Replacement Part should not be empty
            return false;
        }  
        
        //Validate Campaing should not be null
        else if(this.claim.CSS_WS_Warranty_Subtype__c=='No BIS' && this.claim.CSS_WS_Multi_ESN__c == true && (this.claim.CSS_WS_Campaigns_TRPs__c == null || this.claim.CSS_WS_Campaigns_TRPs__c == '') && this.claim.CSS_WS_Policy_Flag__c == 'Warranty' && this.claim.CSS_WS_Warranty_Type__c == 'Motor'){//Rule SF65
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E026);//Please select a Campaing
            return false;
        }
            
        //Validate Repair Description should not be null
        else if((this.claim.CSS_WS_Catastrophic__c == 'Si' || this.claim.CSS_WS_Catastrophic__c == 'Yes') && (this.claim.CSS_WS_Repair_Description__c == null || this.claim.CSS_WS_Repair_Description__c == '')){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E038);//Repair Description should not be empty
            return false;
        }   
        
        //Validate Repair Pay Code should not be null
        else if(this.claim.CSS_WS_Pay_code__c == null && this.claim.CSS_WS_Policy_Flag__c == 'Policy WW'){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E060);//Please select an Pay Code
            return false;
        }
        
        else if(ValidateIfIsCentralAmerica() == false){
            return false;
        } else {
        
            //Rule SF57
            Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
            if(SPPreferences.CSS_WS_Campaign_TRP__c == false){
                this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E002);//Campaign claims are not allowed for the service provider
                return false;
            } 
            return true;
        }       
    }   
    
    Public Boolean validatePolicyFields(){
    //Validation for Policy Fields - Not allow pass to next tab if not all required fields are filled
        //Validate Customer Support authorization Date should be selectedSelectedRowId
        if((this.claim.CSS_WS_Customer_Support_authorization_da__c == null) && (this.claim.CSS_WS_Policy_Flag__c == 'Policy') && (this.claim.CSS_WS_Account_Code__c == 'P88' || this.claim.CSS_WS_Account_Code__c == 'P93' || this.claim.CSS_WS_Account_Code__c == 'P99' || this.claim.CSS_WS_Account_Code__c == 'P100')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E006));//Customer Support Authorization Date should not be empty
            return false;            
        } 
        
        //Validate Quotation Total Amount should be selected
        else if(((this.claim.CSS_WS_Quotation_Total_Amount__c == null) || (this.claim.CSS_WS_Quotation_Total_Amount__c == 0)) && (this.claim.CSS_WS_Policy_Flag__c == 'Policy') && (this.claim.CSS_WS_Account_Code__c == 'P88' || this.claim.CSS_WS_Account_Code__c == 'P93' || this.claim.CSS_WS_Account_Code__c == 'P99' || this.claim.CSS_WS_Account_Code__c == 'P100')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E036));//Quotation Total Amount should not be empty or cero
            return false;
        }
        
        //Validate Requested Amount should be selectedDelete After
        /*else if((this.claim.CSS_WS_Requested_Amount__c == null) && (this.claim.CSS_WS_Policy_Flag__c == 'Policy') && (this.claim.CSS_WS_Account_Code__c == 'P88')){Delete After
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E041));//Requested Amount should not be emptyDelete After
            return false;Delete After
        }Delete After*/
        
        //Validate Authorized Amount should be selected
        else if((this.claim.CSS_WS_Authorized_Amount__c == null) && (this.claim.CSS_WS_Policy_Flag__c == 'Policy') && (this.claim.CSS_WS_Account_Code__c == 'P88' || this.claim.CSS_WS_Account_Code__c == 'P93' || this.claim.CSS_WS_Account_Code__c == 'P99' || this.claim.CSS_WS_Account_Code__c == 'P100')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E001));//'Authorized Amount should not be empty'
            return false;
        } 
        
        //Validate Requested Amount should NOT be greater than Quotation AmountDelete After
        /*else if((this.claim.CSS_WS_Requested_Amount__c > this.claim.CSS_WS_Quotation_Total_Amount__c) && (this.claim.CSS_WS_Policy_Flag__c == 'Policy') && (this.claim.CSS_WS_Account_Code__c == 'P88')){//Rule SF-P07Delete After
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Policy_E002));//Requested amount does not have to be greater than Quotation amount.Delete After
            return false;Delete After
        }Delete After*/
        
        //Validate Authorized Amount should NOT be greater than Requested Amount
        else if((this.claim.CSS_WS_Authorized_Amount__c > this.claim.CSS_WS_Quotation_Total_Amount__c) && (this.claim.CSS_WS_Policy_Flag__c == 'Policy') && (this.claim.CSS_WS_Account_Code__c == 'P88' || this.claim.CSS_WS_Account_Code__c == 'P93' || this.claim.CSS_WS_Account_Code__c == 'P99' || this.claim.CSS_WS_Account_Code__c == 'P100')){//Rule SF-P08
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Policy_E003));//Authorized amount does not have to be greater than Requested amount.
            return false;
        }
        
        //Validate attachment should not be empty
        else if(this.attachment_list.size() == 0 && this.claim.CSS_WS_Policy_Flag__c == 'Policy' && (this.claim.CSS_WS_Account_Code__c == 'P88' || this.claim.CSS_WS_Account_Code__c == 'P93' || this.claim.CSS_WS_Account_Code__c == 'P99' || this.claim.CSS_WS_Account_Code__c == 'P100')){//Rule SF-P06
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Policy_E004));//Support Evidence should not be null
            return false;
        }
        
        //Validate SP Distributor should not be empty
        else if(this.claim.CSS_WS_Request_Justification__c == null && this.claim.CSS_WS_Policy_Flag__c == 'Policy' && (this.claim.CSS_WS_Account_Code__c == 'P101')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Policy_E005));//Please enter the request justification.
            return false;
        }
        
        //Validate SP Distributor should not be empty
        else if(this.claim.CSS_WS_Service_Provider_DR_ToCharge__c == null && this.claim.CSS_WS_Policy_Flag__c == 'Policy' && (this.claim.CSS_WS_Account_Code__c == 'P101')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E029));//Please select a Distributor.
            return false;
        }
        
        //Validate SP Dealer should not be empty
        else if(this.claim.CSS_WS_Service_Provider_Dealer_ToCharge__c == null && this.claim.CSS_WS_Policy_Flag__c == 'Policy' && (this.claim.CSS_WS_Account_Code__c == 'P101')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E028));//Please select a Dealer
            return false;
        } else {
            return true;
        }
    }
    
    Public Boolean ValidateIfIsCentralAmerica(){
        try{
            String RegionName;
            if(this.claim.CSS_WS_Service_Provider_Dealer__c == this.claim.CSS_WS_Service_Provider_DR__c){
                RegionName = [SELECT BillingCountry FROM Account WHERE (Type =: 'Distributor Account' OR Type =: 'Distributor Branch Account') 
                                     AND IAM_Service_Provider_Code__c =: this.claim.CSS_WS_Service_Provider_DR__c AND CMI_Account_Status__c =: 'Active'].BillingCountry;
            } else {
                RegionName = [SELECT BillingCountry FROM Account WHERE IAM_Service_Provider_Code__c =: this.claim.CSS_WS_Service_Provider_Dealer__c
                                     AND CSS_DBCode__c =: this.claim.CSS_WS_Service_Provider_DR__c AND (Type =: 'Dealer Account' OR 
                                     Type =: 'Dealer Branch Account') AND CMI_Account_Status__c =: 'Active'].BillingCountry;
            }             
            // Now Policy WW option will be available for all users including Factory, DR y Dealers, even if there are from MX or CA - March 18th 2021
            /*if(this.claim.CSS_WS_Policy_Flag__c == 'Policy WW' && this.claim.CSS_WS_Service_Provider_Dealer__c != '54734'){
                if(RegionName.touppercase() == 'MEXICO' && this.claim.CSS_WS_Login_Variable__c != 'FactoryLoggedIn'){
                    this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E048);//Policy WW does not have to be claimed by anyother than Central America Distributors
                    return false;
                }
            }else */
            if(this.claim.CSS_WS_Policy_Flag__c == 'Policy'){
                if(RegionName.touppercase() != 'MEXICO'){
                    this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E052);//Policy does not have to be claimed by anyother than Mexico Distributors
                    return false;
                }
            }
            return true;
        } catch(Exception e) {
            return false;
        }
    }   
    
    Public Boolean checkTravelPercentage(){
        if(this.claim.CSS_WS_Campaigns_TRPs__c != null){
            if(this.claim.CSS_WS_Campaign_Travel_Percentage__c == 0 || this.claim.CSS_WS_Campaign_Travel_Percentage__c == null){
                return true;
            }
        }        
        return false;
    }
    
    Public String getSpName(String spCode, String accType){
        Account sp = new Account();
        try {
            if(accType.toUpperCase() == 'DR'){
                sp = [SELECT Account.Name FROM Account WHERE IAM_Service_Provider_Code__c = :spCode AND (Account.Type = 'Distributor Account'
                        OR Account.Type = 'Distributor Branch Account') AND CMI_Account_Status__c =: 'Active' LIMIT 1];
            } else {
                sp = [SELECT Account.Name FROM Account WHERE IAM_Service_Provider_Code__c = :spCode AND (Account.Type = 'Dealer Account' OR 
                        Account.Type = 'Dealer Branch Account' OR Account.Type = 'Distributor Account' OR Account.Type = 'Distributor Branch Account')
                        AND CMI_Account_Status__c =: 'Active' ORDER BY Type LIMIT 1];
            }
            return sp.Name;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return null;
    }    
    
    Public String failureData(){
        CSS_WS_Failure__c failureCampaing = new CSS_WS_Failure__c();
        String failCode = '';
        String failMode = '';         
        if(this.claim.CSS_WS_Campaigns_TRPs__c!=null && this.claim.CSS_WS_Campaigns_TRPs__c!=''){//Rule RR-85
            failCode = campaingsTem.get(this.claim.CSS_WS_Campaigns_TRPs__c).FailCode;
            failMode = campaingsTem.get(this.claim.CSS_WS_Campaigns_TRPs__c).FailMode;
        } else {
            failCode = 'XMTO';
            failMode = 'OL';
        }
        if(failCode != null && failCode != ''){ 
            CSS_WS_Failure_Master__c[] failure = [SELECT Engine_System_Code_Description__c, Engine_Component_Code_Description__c, Engine_Component_Code__c, Engine_System_Code__c
                                                  FROM CSS_WS_Failure_Master__c WHERE Fail_Code__c =: failCode LIMIT 1];
            CSS_WS_Fail_Mode_Catalog__c[] failModes = [SELECT CSS_WS_Name__c FROM CSS_WS_Fail_Mode_Catalog__c WHERE CSS_WS_FailMode__c=: failMode LIMIT 1];
            failureCampaing.CSS_WS_Warranty__c = this.claim.Id; 
            if(failure.size() > 0){
                failureCampaing.CSS_WS_Failure_Name__c = failure[0].Engine_System_Code_Description__c + failure[0].Engine_Component_Code_Description__c ;
                failureCampaing.CSS_WS_EngineSystemCode__c = failure[0].Engine_System_Code__c;
                failureCampaing.CSS_WS_ComponentCode__c = failure[0].Engine_Component_Code__c;
                failureCampaing.CSS_WS_EngineSystem__c = failure[0].Engine_System_Code_Description__c ;
                failureCampaing.CSS_WS_ComponentName__c = failure[0].Engine_Component_Code_Description__c ;
            } else {
                //System.debug('Campaign FailCode Not found');
                return 'Campaign FailCode '+ failCode +' Not found in Master Data';
            }
            if(failModes.size() > 0){
                failureCampaing.CSS_WS_FailureModeCode__c = failMode;
                failureCampaing.CSS_WS_FailureModeName__c = failModes[0].CSS_WS_Name__c;
            } else{
                //System.debug('FailMode Not found');
                return 'Campaign FailMode '+ failMode + ' Not found in Master Data';
            }  
            if(this.claim.CSS_WS_Campaigns_TRPs__c!=null && this.claim.CSS_WS_Campaigns_TRPs__c!=''){
                //partSRTData();
            }                                            
            upsert(failureCampaing);
            return null;
        }
        return 'Invalid Campaign FailCode or FailMode';
    }
    
    /*Public Void partSRTData(){
        List<CSS_WS_Warranty_Parts__c> parts = new List<CSS_WS_Warranty_Parts__c>();
        Map <String, Integer> uniqueParts = new Map<String, Integer>();
        List<CSS_WS_Warranty_SRT__c> srts = new List<CSS_WS_Warranty_SRT__c>();
        Map <String, Integer> uniqueSrts = new Map<String, Integer>();
        CSS_WS_J2A_GetCampaignData.PartList[] PartList = campaingsTem.get(this.claim.CSS_WS_Campaigns_TRPs__c).PartList;
        if( PartList != null ){
            for (integer i=0; i<PartList.size(); i++) {
                if(!String.isEmpty(PartList[i].PartNumber)){
                    if( uniqueParts.get(PartList[i].PartNumber) == null ){ //Avoid Duplicate Parts
                        CSS_WS_Warranty_Parts__c part = new CSS_WS_Warranty_Parts__c();
                        part.CSS_WS_WarrantyID__c = this.claim.Id;
                        part.CSS_WS_PartNumber__c = PartList[i].PartNumber;
                        part.CSS_WS_Description__c = PartList[i].PartDescription;
                        if(!String.isEmpty(PartList[i].PartQuantity)){
                            part.CSS_WS_Quantity__c = integer.valueof(PartList[i].PartQuantity);
                        }
                        parts.add(part);
                        uniqueParts.put(PartList[i].PartNumber,1);
                    }
                }
            }
        }
        CSS_WS_J2A_GetCampaignData.SrtList[] SrtList = campaingsTem.get(this.claim.CSS_WS_Campaigns_TRPs__c ).SrtList;
        if( SrtList != null){
            for (integer i=0; i<SrtList.size(); i++) {
                if(uniqueSrts.get(SrtList[i].SrtCode) == null){ //Avoid Duplicate SRTs
                    CSS_WS_Warranty_SRT__c srt = new CSS_WS_Warranty_SRT__c();
                    srt.CSS_WS_WarrantyID__c = this.claim.Id;
                    srt.CSS_WS_Access_Code__c = this.claim.CSS_WS_Access_Code__c;
                    srt.CSS_WS_Hours_Percentage__c = 100;
                    srt.CSS_WS_Description__c = SrtList[i].SrtDescription;
                    srt.CSS_WS_SRT__c = SrtList[i].SrtCode;
                    srts.add(srt);
                    uniqueSrts.put(SrtList[i].SrtCode,1);
                }
            }
        }
        if(parts.size() > 0){ upsert(parts); }
        if(srts.size() > 0){ upsert(srts); }
    }*/
        
    Public Void getESN(){
        if(this.claim.CSS_WS_Engine_Serial_Number__c!=null) { 
            this.ESNR = this.claim.CSS_WS_Engine_Serial_Number__c;
        } else {
            this.ESNR ='';
        } 
        if(this.ESNR.isNumeric() && this.ESNR.length()==8) {
            CSS_WS_J2A_GetEngineData objec = CSS_WS_GetWebServiceData.getEngineData(this.claim.CSS_WS_Engine_Serial_Number__c); //Web service call
            if(objec!=null){
                if(objec.Header.Status.touppercase()=='SUCCESS' && objec.DataArea != null){//Rule SF20
                    deletESN();
                    this.claim.CSS_WS_Engine_Serial_Number__c = this.ESNR;
                    CSS_WS_Engine_Application_Code__c code = mapEngineApplication(objec.DataArea.EngineAppDesc);                      
                    this.claim.CSS_WS_Engine_Application__c = code != null ? code.Application_Description__c : '';
                    this.claim.CSS_WS_Engine_Application_Code__c = code != null ? code.Name : '';
                    this.claim.CSS_WS_Failure_Measure__c= code != null ? code.Default_Measurement__c : ''; 
                    this.claim.CSS_WS_Service_Model__c = String.isEmpty(objec.DataArea.ServiceModelName) ? '' : objec.DataArea.ServiceModelName;
                    this.claim.CSS_WS_Customer_Name__c = String.isEmpty(objec.DataArea.CustomerName) ? '' : objec.DataArea.CustomerName;
                    this.claim.CSS_WS_Model_Series__c = String.isEmpty(objec.DataArea.Model) ? '' : objec.DataArea.Model;
                    this.claim.CSS_WS_Manufacturer__c = String.isEmpty(objec.DataArea.Manufacturer) ? '' : objec.DataArea.Manufacturer;
                    if(this.claim.CSS_WS_Warranty_Type__c != 'Parte' && this.claim.CSS_WS_Warranty_Type__c != 'Part' && this.claim.CSS_WS_Warranty_Subtype__c != 'BIS' ){
                        this.claim.CSS_WS_Warranty_Start_Date__c = stringToDate(objec.DataArea.WarrantyStartDate, 'YYYY-MM-DDTHH:MM:SS');
                    } 
                    if(this.claim.CSS_WS_Warranty_Start_Date__c != null){
                        warrantyStartDateFlag = true;
                    }
                    if(this.claim.CSS_WS_Manufacturer__c != null){
                        editManufacturerFlag ++;
                    }              
                    if(this.claim.CSS_WS_Engine_Application__c != null && this.claim.CSS_WS_Engine_Application__c != ''){
                        editEngineApplicationFlag = true;
                    }
                    if(objec.DataArea.WarrantyStartDate != null){                                           
                        editWSDFlag = true;                       
                    } 
                    //Not front end
                    this.claim.CSS_WS_Engine_Family_Code__c = objec.DataArea.EngineFamilyCode;
                    this.claim.CSS_WS_Product_Application_Code__c = objec.DataArea.ProdAppCode;
                    this.claim.CSS_WS_Product_Application_Description__c = objec.DataArea.ProdAppDesc;
                    this.claim.CSS_WS_Build_Date__c = stringToDate(objec.DataArea.BuildDate, 'YYYY-MM-DDTHH:MM:SS');
                    this.claim.CSS_WS_Engine_Bill_to_Code__c = objec.DataArea.EngineBillToCode;
                    this.claim.CSS_WS_Marine_Application_Flag__c = objec.DataArea.MarineAppFlag;
                    this.claim.CSS_WS_Automotive_Application_Flag__c = objec.DataArea.AutomotiveAppFlag;
                    this.claim.CSS_WS_Engine_Trade_Out_conversion_date__c = stringToDate(objec.DataArea.EtoConversionDate, 'YYYY-MM-DDTHH:MM:SS');
                    this.claim.CSS_WS_Equipment_Code__c = objec.DataArea.EquipmentId;
                    this.claim.CSS_WS_Access_Code__c = objec.DataArea.AccessCode;   
                    if(this.claim.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '27' || this.claim.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '48' ||
                       this.claim.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '60' || this.claim.CSS_WS_Engine_Serial_Number__c.substring(0, 2) == '61'){
                           this.claim.CSS_WS_Warranty_Subtype__c = 'ReCon Engine';  
                           this.claim.CSS_WS_Warranty_Type__c = 'Motor';
                           this.claim.CSS_WS_Policy_Flag__c = 'Warranty';
                    }
                    R04127_SF32();
                    getCampaings();
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objec.Header.ReturnCodeDescription));
                    deletESN();
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                deletESN();
            }
        } else {
            deletESN();
        }
    }   
    
    Public Void deletESN(){
        this.claim.CSS_WS_Engine_Serial_Number__c = null;
        this.claim.CSS_WS_Service_Model__c = null;
        this.claim.CSS_WS_Engine_Application__c = null;
        this.claim.CSS_WS_Customer_Name__c = null;
        this.claim.CSS_WS_Model_Series__c = null;
        this.claim.CSS_WS_Manufacturer__c = null;
        this.claim.CSS_WS_Warranty_Start_Date__c = null;
        this.claim.CSS_WS_Failure_Measure__c = null;
        this.claim.CSS_WS_Failure_Point_Quantity__c = null;
        this.claim.CSS_WS_Campaigns_TRPs__c = null;   
        this.claim.CSS_WS_Warranty_Subtype__c = 'No BIS';//Rule SF46
        this.claim.CSS_WS_Account_Code__c = null;
        this.claim.CSS_WS_Multi_ESN__c = false;
        this.claim.CSS_WS_Failure_Date_Time__c = null;
        this.claim.CSS_WS_TSR_Number__c = null;
        this.warrantyStartDateFlag = false;
        editManufacturerFlag = 0;                    
        editModelSeriesFlag = false;                    
        editEngineApplicationFlag = false;
        this.editWSDFlag = false;
        //Not front end
        this.claim.CSS_WS_Engine_Family_Code__c = null;
        this.claim.CSS_WS_Engine_Application_Code__c = null;
        this.claim.CSS_WS_Product_Application_Code__c = null;
        this.claim.CSS_WS_Product_Application_Description__c = null;
        this.claim.CSS_WS_Build_Date__c = null;
        this.claim.CSS_WS_Engine_Bill_to_Code__c = null;
        this.claim.CSS_WS_Marine_Application_Flag__c = null;
        this.claim.CSS_WS_Automotive_Application_Flag__c = null;
        this.claim.CSS_WS_Engine_Trade_Out_conversion_date__c = null;
        this.claim.CSS_WS_Equipment_Code__c = null;
        this.claim.CSS_WS_Access_Code__c = null;
    }

    Public Void getSPList(){
        this.distributorsDisable = false;
        this.dealersDisable = false;
        if(userinfo.getUserType() == 'PowerCustomerSuccess'){
            Account userAccount = new Account();
            System.debug('Service Provider DR: ' + this.claim.CSS_WS_Service_Provider_DR__c);
            System.debug('Service Provider Dealer: ' + this.claim.CSS_WS_Service_Provider_Dealer__c);
            if(this.claim.CSS_WS_Service_Provider_DR__c != null && this.claim.CSS_WS_Service_Provider_Dealer__c != null){
                userAccount = [SELECT CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c, IAM_Service_Provider_Code__c FROM Account WHERE 
                (type = 'Distributor Account' OR type = 'Distributor Branch Account' OR type = 'Dealer Account' 
                OR type = 'Dealer Branch Account') AND IAM_Service_Provider_Code__c =: this.claim.CSS_WS_Service_Provider_Dealer__c 
                AND CMI_Account_Status__c =: 'Active' ORDER BY type LIMIT 1];
                System.debug('UserAccount when edit: ' + userAccount);
            } else {
                Contact userContact = [SELECT Account.Name FROM Contact WHERE Id In (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
                userAccount = [SELECT CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c, IAM_Service_Provider_Code__c FROM Account WHERE 
                Account.Name =: userContact.Account.Name AND (type = 'Dealer Account' OR type = 'Distributor Account' OR 
                type = 'Dealer Branch Account' OR type = 'Distributor Branch Account')];
                System.debug('UserAccount when new: ' + userAccount );
                if(userAccount != null){
                    if(userAccount.Type == 'Distributor Account' || userAccount.Type == 'Distributor Branch Account'){
                        this.claim.CSS_WS_Login_Variable__c = 'DRLoggedIn';
                    } else if(userAccount.Type == 'Dealer Account' || userAccount.Type == 'Dealer Branch Account'){ 
                        this.claim.CSS_WS_Login_Variable__c = 'DealerLoggedIn';              
                    }
                }
            }
            if(userAccount != null){//Rule SF49
                this.claim.CSS_WS_Service_Provider_DR__c = userAccount.CSS_DBCode__c;
                this.claim.CSS_WS_Service_Provider_Dealer__c = userAccount.IAM_Service_Provider_Code__c;
                
                this.isPaccar = userAccount.CSS_WS_Paccar_DLR_Flag__c;
                if(this.isPaccar == false || this.claim.CSS_WS_Policy_Flag__c == 'Policy'){ 
                    this.claim.CSS_WS_Belongs_To__c = 'DR';//Rule SF-P01
                }
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
                    //throw error? no supported account type?
                }
            }
        } else {
            this.isPaccar = false;
            //this.claim.CSS_WS_Belongs_To__c = 'DR';
            if (this.claim.CSS_WS_Belongs_To__c == null) {this.claim.CSS_WS_Belongs_To__c = 'DR';} //when claim is being created, the DR values is assigned
            LogInVariable = 'DRLoggedIn';
            if (this.claim.CSS_WS_Login_Variable__c==null){this.claim.CSS_WS_Login_Variable__c='FactoryLoggedIn';}//When no-DR and no-Dealer
        }
        System.debug('CSS_WS_Login_Variable__c = ' + this.claim.CSS_WS_Login_Variable__c);
    }
        
    Public Void getSPData(){
        List<String> SPData = new List<String>();
        SPData.add(this.claim.CSS_WS_Service_Provider_Dealer__c);
        SPData.add(this.claim.CSS_WS_Service_Model__c);
        SPData.add(CSS_WS_ControllerClaim.dateToString(this.claim.CSS_WS_Failure_Date_Time__c, 'dd-MMM-yy'));
        try{
            this.SPDataResponse = CSS_WS_GetWebServiceData.getSPData(SPData);
            if(this.SPDataResponse != null){
                if(this.SPDataResponse.Header.Status.touppercase() == 'SUCCESS'){
                    if(this.SPDataResponse.DataArea != null){
                        this.claim.CSS_WS_Labor_Rate__c = this.SPDataResponse.DataArea.FieldServiceLaborRate; 
                        this.claim.CSS_WS_In_shop_Labor_Rate__c = this.SPDataResponse.DataArea.InShopLaborRate;
                        this.claim.CSS_WS_Travel_Rate__c= this.SPDataResponse.DataArea.TravelRate;   
                        if((this.SPDataResponse.DataArea.FieldServiceLaborRate == null || this.SPDataResponse.DataArea.FieldServiceLaborRate == '0' || this.SPDataResponse.DataArea.FieldServiceLaborRate == '')){//Rule SF56 
                            flagSRT = true;
                            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E019);//Labor cannot be claimed due to unknown labor rate
                            this.claim.CSS_WS_HasError__c = 2;
                        } else {
                            flagSRT = false;
                        }                        
                    } else {
                        //if(this.claim.CSS_WS_Policy_Flag__c == 'Warranty'){
                            flagSRT = true;
                            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E019);//Labor cannot be claimed due to unknown labor rate
                        //}
                        this.claim.CSS_WS_HasError__c = 2;
                    }
                } else {
                    this.DisplayAsincErrorHandler(SPDataResponse.Header.ReturnCodeDescription);
                }
            } else {
                this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            }
        } catch(Exception e){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            //System.debug('Error: '+e.getMessage());
        }
    }      
    
    Public Void calculateTotalTravelAmount(){        
        Account SPMaxAmount = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
        // Validation for "54734" SPCode - Oct 6th 2020
        if(SPMaxAmount.BillingCountry.toUpperCase() != 'MEXICO' || (this.claim.CSS_WS_Service_Provider_Dealer__c == '54734' && this.claim.CSS_WS_Policy_Flag__c == 'Policy WW')){
            Decimal additionalHrRate = 0;
            Decimal additionalKmRate = 0; 
            String regionName_HR = 'HR Adicional';
            String regionName_KM = 'KM Adicional';  
            try {
                if(SPMaxAmount.BillingCountry.toUpperCase() != 'MEXICO'){
                    regionName_HR = 'HR_Adicional_' + SPMaxAmount.BillingCountry;
                    regionName_KM = 'KM_Adicional_' + SPMaxAmount.BillingCountry;
                }
                additionalHrRate = [SELECT Local_Rate__c FROM CSS_WS_Travel_Prices__c WHERE Name =: regionName_HR LIMIT 1].Local_Rate__c;          
                additionalKmRate = [SELECT Local_Rate__c FROM CSS_WS_Travel_Prices__c WHERE Name =: regionName_KM LIMIT 1].Local_Rate__c;           
            } catch(Exception e) {
                additionalHrRate =0;
                additionalKmRate =0;
            }
            additionalKmAmount = this.claim.CSS_WS_Travel_Distance__c != null ? this.claim.CSS_WS_Travel_Distance__c * additionalKmRate  : 0;        
            additionalHrAmount = this.claim.CSS_WS_Travel_Hours__c != null ? this.claim.CSS_WS_Travel_Hours__c * additionalHrRate  : 0;  
            additionalKmAmount = additionalKmAmount > 0 ? additionalKmAmount.setScale(2) : 0;
            additionalHrAmount = additionalHrAmount > 0 ? additionalHrAmount.setScale(2) : 0;
            Decimal lodging = this.claim.CSS_WS_Lodging__c != null ? this.claim.CSS_WS_Lodging__c : 0;
            Decimal towing = this.claim.CSS_WS_Towing_Amount__c != null ? this.claim.CSS_WS_Towing_Amount__c :0;
            this.claim.CSS_WS_Total_Amount_Travel__c = additionalHrAmount + additionalKmAmount + lodging  + towing;
        }
    }
    
    Public Void assignPayCode(){
        Date failureDate = this.claim.CSS_WS_Failure_Date_Time__c.date();
        Date firstFailDate = System.today();
        if(failureDate.daysBetween(firstFailDate) < 120){
            if(this.claim.CSS_WS_Service_Provider_Dealer__c == this.claim.CSS_WS_Service_Provider_DR__c){
                this.claim.CSS_WS_Pay_Code__c = 'I';
            } else {
                this.claim.CSS_WS_Pay_Code__c = 'R';
            }       
        } else if((failureDate.daysBetween(firstFailDate) >= 120) && (failureDate.daysBetween(firstFailDate) < 180)){
            if(this.claim.CSS_WS_Service_Provider_Dealer__c == this.claim.CSS_WS_Service_Provider_DR__c){
                this.claim.CSS_WS_Pay_Code__c = 'T';
            } else {
                this.claim.CSS_WS_Pay_Code__c = 'C';
            }       
        } else if((failureDate.daysBetween(firstFailDate) >= 180) && (failureDate.daysBetween(firstFailDate) < 365)){
            if(this.claim.CSS_WS_Service_Provider_Dealer__c == this.claim.CSS_WS_Service_Provider_DR__c){
                this.claim.CSS_WS_Pay_Code__c = 'S';
            } else {
                this.claim.CSS_WS_Pay_Code__c = 'L';
            }       
        } else if(failureDate.daysBetween(firstFailDate) >= 365){
            this.claim.CSS_WS_Pay_Code__c = 'A';    
        } 
        //Assign value of Other Approver if Account_Code is "35" or "52" for Warranty claim
        if(this.claim.CSS_WS_Account_Code__c == '35'){
            this.claim.CSS_WS_Other_Approver__c = 'T72';
        } else if(this.claim.CSS_WS_Account_Code__c == '52'){
            this.claim.CSS_WS_Other_Approver__c = 'A57';
        } else if(this.claim.CSS_WS_Account_Code__c != '61'){        
            this.claim.CSS_WS_Other_Approver__c = '';
        }           
    }
   
    Public Void warrantyChanges(){        
        if(this.claim.CSS_WS_Engine_Serial_Number__c != null && (this.claim.CSS_WS_Warranty_Type__c == 'Engine' || this.claim.CSS_WS_Warranty_Type__c == 'Motor') && editWSDFlag == true){
            CSS_WS_J2A_GetEngineData objec = CSS_WS_GetWebServiceData.getEngineData(this.claim.CSS_WS_Engine_Serial_Number__c);//Web service call
            if(objec!=null){
                if(objec.Header.Status.touppercase()=='SUCCESS'){
                    this.claim.CSS_WS_Warranty_Start_Date__c = stringToDate(objec.DataArea.WarrantyStartDate, 'YYYY-MM-DDTHH:MM:SS');
                    if(this.claim.CSS_WS_Warranty_Start_Date__c != null){                       
                        warrantyStartDateFlag = true;                        
                    } else {
                        warrantyStartDateFlag = false;                        
                    }
                }
            }
        } else {
            this.claim.CSS_WS_Warranty_Start_Date__c = null;  
            warrantyStartDateFlag = false; 
        }                    
        if(this.claim.CSS_WS_Warranty_Type__c != 'Parte' && this.claim.CSS_WS_Warranty_Type__c != 'Part'){//Rule SF62
            if(this.claim.CSS_WS_Warranty_Subtype__c == 'BIS' && this.claim.CSS_WS_Warranty_Type__c == 'Motor'){
                warrantyStartDateFlag = true;
                this.claim.CSS_WS_Customer_Name__c = 'BIS';
                this.claim.CSS_WS_Customer_Name_Internal__c = null;
            } else {
                this.claim.CSS_WS_Customer_Name__c = null;
                this.claim.CSS_WS_Customer_Name_Internal__c = null;
                if(this.editWSDFlag == false){                                    
                    warrantyStartDateFlag = false;                                                       
                }
            }
        } else {
            warrantyStartDateFlag = false;
        }
        R04127_SF32();
    }
    
    Public Void changePolicyField(){
        this.claim.CSS_WS_Multi_ESN__c = false;
        this.claim.CSS_WS_Account_Code__c = null;
        this.claim.CSS_WS_Claim_Type__c =  null;
        this.claim.CSS_WS_Campaigns_TRPs__c = null;
        this.claim.CSS_WS_Warranty_Type__c = 'Motor';
        this.claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
        this.claim.CSS_WS_Pay_Code__c = null;
        warrantyChanges();
    }
    
    Public Void R04127_SF32(){
        if(this.claim.CSS_WS_Warranty_Start_Date__c != null && this.claim.CSS_WS_Build_Date__c != null){
            if(this.claim.CSS_WS_Warranty_Start_Date__c < this.claim.CSS_WS_Build_Date__c){//Rule SF32
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E064));//Warranty Start Date must be later than Engine Build Date
                this.claim.CSS_WS_Warranty_Start_Date__c = null;
            }
        } 
        R04165_SF44();
    }
    
    Public Void R04165_SF44(){
        this.claim.CSS_WS_Customer_Name__c = null;
        this.claim.CSS_WS_Customer_Name_Internal__c = null;
        if(this.claim.CSS_WS_Warranty_Subtype__c != null){
            if(this.claim.CSS_WS_Warranty_Subtype__c == 'BIS' && this.claim.CSS_WS_Warranty_Start_Date__c != null){//Rule SF44
                this.claim.CSS_WS_Warranty_Subtype__c = 'No BIS'; 
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E049));//Warranty Start Date cannot be entered on BIS claims. BIS flag was reset
            }
        } 
        if(this.claim.CSS_WS_Warranty_Type__c == 'Parte'){
            this.claim.CSS_WS_Warranty_Subtype__c = null;
        }
        if(this.claim.CSS_WS_Warranty_Start_Date__c != null){
            if(this.claim.CSS_WS_Failure_Date_Time__c < this.claim.CSS_WS_Warranty_Start_Date__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E015));//Failure Date should be greater than Warranty Start Date
                this.claim.CSS_WS_Failure_Date_Time__c = null;
            } else {
                R04190_SF36();
            }
        }
        YearsOnService();
    }
    
    
    Public Void R040611_SF16(){
        if(this.claim.CSS_WS_Failure_Date_Time__c != null){
            if(this.claim.CSS_WS_Failure_Date_Time__c > System.now()){//Rule SF16
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E014));//Failure Date cannot be greater than today
                this.claim.CSS_WS_Failure_Date_Time__c = null;
            } else {
                if(this.claim.CSS_WS_Warranty_Start_Date__c != null){
                    if(this.claim.CSS_WS_Failure_Date_Time__c < this.claim.CSS_WS_Warranty_Start_Date__c){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E015));//Failure Date should be greater than Warranty Start Date
                        this.claim.CSS_WS_Failure_Date_Time__c = null;
                    } else {    
                        this.CheckEndDate();
                        if(this.claim.CSS_WS_End_Repair_Date_Time__c != null){
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.CSS_WS_Claim_E025));//Please ensure the Failure Date and Time are set correctly
                        }
                    }  
                } else {
                    this.CheckEndDate();
                    if(this.claim.CSS_WS_End_Repair_Date_Time__c != null){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.CSS_WS_Claim_E025));//Please ensure the Failure Date and Time are set correctly
                    }
                }               
            }            
        }
        getCampaingsOp();
        YearsOnService();
    }   
    
    Public Void CheckEndDate(){
        this.claim.CSS_WS_Repair_Days__c = null;
        if(this.claim.CSS_WS_Failure_Date_Time__c != null && this.claim.CSS_WS_End_Repair_Date_Time__c != null){
            if(this.claim.CSS_WS_Failure_Date_Time__c > this.claim.CSS_WS_End_Repair_Date_Time__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Claim_E072));//Failure Date cannot be geather than End Repair Date
                this.claim.CSS_WS_End_Repair_Date_Time__c = null;
            } else {//Calculate the Repair Days
                Date ini = this.claim.CSS_WS_Failure_Date_Time__c.date();
                Double i = 0;
                Double ih = 0;
                while(ini != this.claim.CSS_WS_End_Repair_Date_Time__c.date()){
                    ini = ini.addDays(Integer.valueOf(i));
                    if(ini == this.claim.CSS_WS_End_Repair_Date_Time__c.date()){
                        break;
                    } else {
                        ini = this.claim.CSS_WS_Failure_Date_Time__c.date();  
                        i = i + 1;
                    }
                }
                ih = i; 
                DateTime inihrs = this.claim.CSS_WS_Failure_Date_Time__c;
                i = 0;
                while(inihrs.hour() != this.claim.CSS_WS_End_Repair_Date_Time__c.hour()){
                    inihrs = inihrs.addHours(Integer.valueOf(i));
                    if(inihrs.hour() == this.claim.CSS_WS_End_Repair_Date_Time__c.hour()){
                        break;
                    } else {
                        inihrs = this.claim.CSS_WS_Failure_Date_Time__c;  
                        i = i + 1;
                    }
                }
                i = (i/24);
                ih = ih + i;
                this.claim.CSS_WS_Repair_Days__c = ih;
                this.claim.CSS_WS_Repair_Days__c = (this.claim.CSS_WS_Repair_Days__c).setScale(1);
            }
        }
    }
    
    Public Void YearsOnService(){
        if(this.claim.CSS_WS_Failure_Date_Time__c != null && this.claim.CSS_WS_Warranty_Start_Date__c != null){
            Date failureDate = this.claim.CSS_WS_Failure_Date_Time__c.date();
            Date warrantyStartDate = this.claim.CSS_WS_Warranty_Start_Date__c;      
            Decimal years = decimal.valueof(warrantyStartDate.daysBetween(failureDate))/decimal.valueof(365);
            Long yearsInService = years.round(RoundingMode.UP);
            this.claim.CSS_WS_Years_On_Service__c = yearsInService;
        } else {
            this.claim.CSS_WS_Years_On_Service__c = 0;
        }
    }

    Public Void R04067_SF17(){
        if(String.isEmpty(this.claim.CSS_WS_Failure_Point_Quantity__c) == false){
            if(this.claim.CSS_WS_Failure_Point_Quantity__c < '0' || this.claim.CSS_WS_Failure_Point_Quantity__c.isNumeric() != true){//Rule SF17
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E017));//Failure Point cannot be less than zero
                this.claim.CSS_WS_Failure_Point_Quantity__c = '';
            } else if(String.isEmpty(this.claim.CSS_WS_Failure_Measure__c) == false){
                if((this.claim.CSS_WS_Failure_Measure__c == 'KM' && double.valueOf(this.claim.CSS_WS_Failure_Point_Quantity__c) > 9999999) || (this.claim.CSS_WS_Failure_Measure__c == 'HR' && double.valueOf(this.claim.CSS_WS_Failure_Point_Quantity__c) > 99999)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E069));
                }
            } else {
                R04023_SF50();
            }                  
        }
    }
    
    Public Void R04023_SF50(){
        if(String.isEmpty(this.claim.CSS_WS_Account_Code__c) == false && String.isEmpty(this.claim.CSS_WS_Failure_Point_Quantity__c) == false){
            if(this.claim.CSS_WS_Account_Code__c == '41' && this.claim.CSS_WS_Failure_Point_Quantity__c != '0'){//Rule SF50
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E022));//Mi/Km/Hrs must be 0 for Account Code 41 claims
            }
        }
    }    
    
    Public Void R04190_SF36(){
        if(this.claim.CSS_WS_Warranty_Start_Date__c != null){   
            if(this.claim.CSS_WS_Warranty_Start_Date__c > System.now()){//Rule SF36
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E051));//Warranty Start Date: You must enter correct value 
                this.claim.CSS_WS_Warranty_Start_Date__c = null;
            } else {//Rule SF47
                if(this.claim.CSS_WS_Policy_Flag__c != null){
                    if(this.claim.CSS_WS_Policy_Flag__c == 'Warranty'){
                        this.claim.CSS_WS_Account_Code__c = null;
                        this.claim.CSS_WS_Multi_ESN__c = false;
                        this.claim.CSS_WS_Failure_Date_Time__c = null;
                    }                  
                }               
            }
        }
    }   
    
    Public Void R04328_SF48(){
        if(this.claim.CSS_WS_Engine_Serial_Number__c != null && this.claim.CSS_WS_Service_Model__c != null && this.claim.CSS_WS_Engine_Serial_Number__c != '' && this.claim.CSS_WS_Service_Model__c != ''){
            if(this.claim.CSS_WS_Multi_ESN__c == true && this.claim.CSS_WS_ESN_Count__c > '1'){//Rule SF48
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E053));//Engine Serial # has a different Service Model than that of Additional ESN. Please remove Additional ESN before changing this value
            }
        }
    }                                                    

    Public Void R040813_SF22(){
        if(this.claim.CSS_WS_Lodging__c != null){
            if(this.claim.CSS_WS_Lodging__c < 0){//Rule SF22
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E054));//Meals should be greather than 0
                this.claim.CSS_WS_Lodging__c = 0;
            }
        }        
        calculateTotalTravelAmount();
    }     
    
    Public Void R040814_SF23(){
        if(this.claim.CSS_WS_Towing_Amount__c != null){
            if(this.claim.CSS_WS_Towing_Amount__c < 0){//Rule SF23
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E055));//Towing should be greather than 0
                this.claim.CSS_WS_Towing_Amount__c = 0;
            }
        }
    }         
    
    Public Void R040815_SF24(){
        if(this.claim.CSS_WS_Travel_Hours__c != null && this.claim.CSS_WS_Travel_Distance__c != null){
            if(this.claim.CSS_WS_Travel_Hours__c < 0){//Rule SF24
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E056));//Travel Hours should be greather than 0
                this.claim.CSS_WS_Travel_Hours__c=0;
            }  
            R04133_SF72();
        }
        calculateTotalTravelAmount();
    }     

    Public Void R040816_SF25(){
        if(this.claim.CSS_WS_Travel_Distance__c != null){
            if(this.claim.CSS_WS_Travel_Distance__c < 0){//Rule SF25
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E057));//Travel Miles should be greather than 0
                this.claim.CSS_WS_Travel_Distance__c=0;
            } 
            R04133_SF72();
        }
        calculateTotalTravelAmount();
    }    
    
    Public Void R04133_SF72(){
        if(this.claim.CSS_WS_Travel_Distance__c != null && this.claim.CSS_WS_Travel_Hours__c != null){
            if(this.claim.CSS_WS_Penalty_Flag__c != 'Policy'){
                if(this.claim.CSS_WS_Travel_Hours__c > this.claim.CSS_WS_Travel_Distance__c){//Rule SF72
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.CSS_WS_Claim_E058));//Please verify that Travel Hours and Travel Distance is correct
                    //this.claim.CSS_WS_Travel_Hours__c=0;
                } 
            } 
        }
        calculateTotalTravelAmount();
    } 
    
    Public Void SF_P05(){
        String[] start = string.valueOfGmt(this.claim.CSS_WS_Customer_Support_authorization_da__c).split(' ');
        String[] failu = string.valueOfGmt(this.claim.CSS_WS_Failure_Date_Time__c).split(' ');  
        start = start[0].split('/');
        failu = failu[0].split('/');
        if(stringToDate(start[0], 'YYYY-MM-DD') < stringToDate(failu[0], 'YYYY-MM-DD')){//Rule SF-P05
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.CSS_WS_Policy_E001));
            this.claim.CSS_WS_Customer_Support_authorization_da__c = null;
        }
        calculateTotalTravelAmount();
    }
    
    /*Public Void SF_P07(){Delete After
        if(this.claim.CSS_WS_Requested_Amount__c != null && this.claim.CSS_WS_Quotation_Total_Amount__c != null){//Rule SF-P07Delete After
            if(this.claim.CSS_WS_Requested_Amount__c > this.claim.CSS_WS_Quotation_Total_Amount__c){Delete After
                this.claim.CSS_WS_Requested_Amount__c = null;Delete After
                this.claim.CSS_WS_Quotation_Total_Amount__c = null;Delete After
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.CSS_WS_Policy_E002));Delete After
            }Delete After
        }Delete After
        SF_P08();Delete After
    }Delete After*/

    Public Void SF_P08(){
        if(this.claim.CSS_WS_Authorized_Amount__c != null && this.claim.CSS_WS_Quotation_Total_Amount__c != null){//Rule SF-P08
            if(this.claim.CSS_WS_Authorized_Amount__c > this.claim.CSS_WS_Quotation_Total_Amount__c){
                this.claim.CSS_WS_Authorized_Amount__c = null; 
                this.claim.CSS_WS_Quotation_Total_Amount__c = null;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.CSS_WS_Policy_E003));
            }
        }
    } 
    
    Public Void sendApprovalCode(){
        R04023_SF50();
        this.claim.CSS_WS_Multi_ESN__c = false;
        if(this.claim.CSS_WS_Account_Code__c != null || this.claim.CSS_WS_Account_Code__c != ''){
            if(this.claim.CSS_WS_Account_Code__c == '35'){
                this.claim.CSS_WS_Other_Approver__c = 'T72';
            } else if(this.claim.CSS_WS_Account_Code__c == '52'){
                this.claim.CSS_WS_Other_Approver__c = 'A57';
            } else {    
                this.claim.CSS_WS_Other_Approver__c = '';
            }
        }
        YearsOnService();
    }
        
    Public Void checkRegion(){
        Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.claim.CSS_WS_Service_Provider_DR__c , this.claim.CSS_WS_Service_Provider_Dealer__c);
        if(SPPreferences.BillingCountry.toUpperCase() == 'MEXICO'){
            this.isMexico = true;
        }
    }
    
    Public Void getCustomerSupportEngineer(){
        CSS_WS_Support_Engineer_Catalog__c[] engineer_name = [SELECT CSS_WS_Engineer_Name__c FROM CSS_WS_Support_Engineer_Catalog__c WHERE CSS_WS_DR_Code__c = :this.claim.CSS_WS_Service_Provider_DR__c LIMIT 1];
        if(engineer_name.size() > 0)
            this.claim.CSS_WS_Customer_Support_Engineer__c = engineer_name[0].CSS_WS_Engineer_Name__c;
    }
    
    Public Void clearSubTypeFailure(){
        this.claim.CSS_WS_Campaigns_TRPs__c = null;
        this.claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
        this.claim.CSS_WS_Claim_Type__c = null;
        this.claim.CSS_WS_Customer_Name__c = null;
        this.claim.CSS_WS_Customer_Name_Internal__c = null;
        warrantyChanges();
    }
    
    Public Void deleteAttachmentRow(){
    //Method to remove an specific attached file
        for (Integer i = 0; i < attachment_list.size(); i++) {
            Attachment a = attachment_list[i];
            if (a.Id == SelectedRowId) {
                delete a;
                attachment_list.remove(i);
                break;
            }
        }        
    }
    
    Public Void attachment(){
        attachment_list = [SELECT Id, name FROM Attachment WHERE ParentID = :this.claim.Id]; 
    } 
    
    Public Void DisplayAsincErrorHandler(String MsgError){
        this.claim.CSS_WS_HasError__c = 1;
        this.claim.CSS_WS_HasMessage__c = MsgError;
    }
    
    Public Void getCampaingsOp(){  
        getCampaings(); 
    }
    
    Public Void getPolicyOptionsByDROp(){
        getPolicyOptionsByDR(); 
    }     

    Public Void getManufacturerSelectListOp(){
        getManufacturerSelectList();
    }
    
    Public Void showPopup() {
        displayPopup = true;
    }
    
    Public Void closePopup() {
        displayPopup = false;
    }
    
    Public Void alertCautionEnd(){
        this.CheckEndDate();
        if(this.claim.CSS_WS_End_Repair_Date_Time__c != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.CSS_WS_Claim_E024));//Please ensure the End Repair Date and Time are set correctly
        }
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
        permission_set_list = [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() AND PermissionSet.Name =: permission_set_name];
        if(permission_set_list.size() > 0){
            return true;
        } else {
            return false;
        }
    }
    
    Public List<SelectOption> getDRtoChargeSelectList(){
        List<SelectOption> distributors = new List<SelectOption>();
        distributors.add(new SelectOption('',Label.CSS_WS_Selection_Distributor)); 
        List<Account> distributorAccounts = new List<Account>();
        distributorAccounts = [
            SELECT Name, CSS_DBCode__c, IAM_Service_Provider_Code__c FROM Account WHERE (Type = 'Distributor Account' OR Type = 'Distributor Branch Account') AND BillingCountry = 'Mexico' 
            AND  (IAM_Service_Provider_Code__c = '56153' OR IAM_Service_Provider_Code__c = '54699' OR IAM_Service_Provider_Code__c = '54809' OR IAM_Service_Provider_Code__c = '55910' 
            OR IAM_Service_Provider_Code__c = '04734' OR IAM_Service_Provider_Code__c = '54700' OR IAM_Service_Provider_Code__c = '55108' OR IAM_Service_Provider_Code__c = '56155' 
            OR IAM_Service_Provider_Code__c = '74798' OR IAM_Service_Provider_Code__c = '54681' OR IAM_Service_Provider_Code__c = '73011' OR IAM_Service_Provider_Code__c = '54665' 
            OR IAM_Service_Provider_Code__c = '56092' OR IAM_Service_Provider_Code__c = '54701' OR IAM_Service_Provider_Code__c = '40711' OR IAM_Service_Provider_Code__c = '00863' 
            OR IAM_Service_Provider_Code__c = '54734') AND Name != 'PACCAR PARTS MEXICO' AND Name != 'CUMMINS MX' AND CMI_Account_Status__c = 'Active' ORDER BY Name];

        for(Account distributor : distributorAccounts ){
            if((String)distributor.IAM_Service_Provider_Code__c != this.claim.CSS_WS_Service_Provider_DR__c){
                distributors.add(new SelectOption((String)distributor.IAM_Service_Provider_Code__c, (String)distributor.Name));
            }
        }
        
        return distributors;
    }
    
    Public List<SelectOption> getDealersToChargeSelectList(){
        Integer dis = 0;
        List<SelectOption> dealers = new List<SelectOption>();
        dealers.add(new SelectOption('', Label.CSS_WS_Selection_Dealer));
        List<Account> dealerAccounts = new List<Account>();
        if(!String.isEmpty(this.claim.CSS_WS_Service_Provider_DR_ToCharge__c)){
            dealerAccounts = [SELECT Name, CSS_DBCode__c, IAM_Service_Provider_Code__c FROM Account WHERE 
                              CSS_DBCode__c =: this.claim.CSS_WS_Service_Provider_DR_ToCharge__c AND (type = 'Dealer Account' OR type = 'Distributor Account' OR 
                              type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active' ORDER BY Name];
            for(Account dealer : dealerAccounts){
                if(dealer.IAM_Service_Provider_Code__c != null && dealer.Name  != null){
                    dealers.add(new SelectOption((String)dealer.IAM_Service_Provider_Code__c, (String)dealer.Name));
                }
            }
        }
        return dealers;
    }
    
    Public Void getESNPolicyP101(){
        // To obtain some missing values from rescue record
        CSS_WS_J2A_GetEngineData objec = CSS_WS_GetWebServiceData.getEngineData(this.claim.CSS_WS_Engine_Serial_Number__c);//Web service call
        if(objec != null){
            if(objec.Header.Status.touppercase() == 'SUCCESS'){ 
                if(objec.DataArea != null){
                    this.claim.CSS_WS_Product_Application_Code__c = objec.DataArea.ProdAppCode;
                    this.claim.CSS_WS_Product_Application_Description__c = objec.DataArea.ProdAppDesc;
                    this.claim.CSS_WS_Marine_Application_Flag__c = objec.DataArea.MarineAppFlag;
                    this.claim.CSS_WS_Engine_Trade_Out_conversion_date__c = stringToDate(objec.DataArea.EtoConversionDate, 'YYYY-MM-DDTHH:MM:SS');
                    this.claim.CSS_WS_Equipment_Code__c = objec.DataArea.EquipmentId;
                }
            }
        }
    }
}