Public Class CSS_WS_NoAvailabilityController {
        
    String username;
    Public CSS_WS_No_Availability__c noAvailability { get; set; }
    Public String language {get{return userinfo.getLanguage();} set;}
    Public String esn { get; set; }
    Public String model { get; set; }
    Public String brand { get; set; }
    Public String startDate { get; set; }
    Public String ESNR { get; set; } 
    Public String getUsername() { return username; }
    Private ApexPages.StandardController stdController;
    Public Boolean distributorsDisable { get; set; }
    Public Boolean dealersDisable { get; set; } 
    Public String LogInVariable { get; set; }  
    Public Boolean isDRRegion { get; set; }
    Public Map<String, String> group_region { get; set;} 
    
    Public CSS_WS_NoAvailabilityController(ApexPages.StandardController stdController){
        this.noAvailability = (CSS_WS_No_Availability__c)stdController.getRecord();
        this.stdController = stdController;
        Id id = ApexPages.currentPage().getParameters().get('id'); 
        this.group_region = this.getSPCodeMapRegion();
        if(this.group_region.IsEmpty()){
            this.isDRRegion = false;
        } else {
            this.isDRRegion = true;
        }
        getSPList();
    }
    
    Public List<SelectOption> getnaDistributorsSelectList(){
        List<SelectOption> distributors = new List<SelectOption>();
        distributors.add(new SelectOption('',Label.CSS_WS_Selection_Distributor));
        List<Account> distributorAccounts = new List<Account>();
        distributorAccounts = [SELECT Name, CSS_DBCode__c, IAM_Service_Provider_Code__c FROM Account 
            WHERE (Type = 'Distributor Account' OR Type = 'Distributor Branch Account') AND BillingCountry = 'MEXICO' AND 
            (IAM_Service_Provider_Code__c = '56153' OR IAM_Service_Provider_Code__c = '54699' OR IAM_Service_Provider_Code__c = '54809' OR IAM_Service_Provider_Code__c = '55910' 
            OR IAM_Service_Provider_Code__c = '04734' OR IAM_Service_Provider_Code__c = '54700' OR IAM_Service_Provider_Code__c = '55108' OR IAM_Service_Provider_Code__c = '56155' 
            OR IAM_Service_Provider_Code__c = '74798' OR IAM_Service_Provider_Code__c = '54681' OR IAM_Service_Provider_Code__c = '73011' OR IAM_Service_Provider_Code__c = '54665' 
            OR IAM_Service_Provider_Code__c = '56092' OR IAM_Service_Provider_Code__c = '54701' OR IAM_Service_Provider_Code__c = '40711' OR IAM_Service_Provider_Code__c = '00863' 
            OR IAM_Service_Provider_Code__c = '54734') AND CMI_Account_Status__c = 'Active' ORDER BY Name];
        
        // Validation to populate the "Distributors" options in Claim format when a DR Region is logged in        
        if(distributorAccounts != null){
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
        }
        return distributors;
    }
    
    Public List<SelectOption> getnaDealersSelectList(){
        Integer dis = 0;
        List<SelectOption> dealers = new List<SelectOption>();
        dealers.add(new SelectOption('', Label.CSS_WS_Selection_Dealer));
        List<Account> dealerAccounts = new List<Account>();
        if(!String.isEmpty(this.noAvailability.CSS_WS_Regional_Distributor__c)){
            dealerAccounts = [SELECT Name, IAM_Service_Provider_Code__c, CSS_DBCode__c FROM Account WHERE 
                              CSS_DBCode__c =: this.noAvailability.CSS_WS_Regional_Distributor__c AND (type = 'Dealer Account' OR 
                              type = 'Distributor Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') 
                              AND CMI_Account_Status__c = 'Active' ORDER BY Name];
                   //(Type = 'Dealer Account' AND CSS_DistributorCode__c =: this.noAvailability.CSS_WS_Regional_Distributor__c) ORDER BY Name];
                //OR (Type = 'Distributor Account' AND CSS_DistributorCode__c =: this.noAvailability.CSS_WS_Regional_Distributor__c) ORDER BY Name];
            for(Account dealer : dealerAccounts){
                if(dealer.IAM_Service_Provider_Code__c != null && dealer.Name  != null){
                    dealers.add(new SelectOption((String)dealer.IAM_Service_Provider_Code__c, (String)dealer.Name));
                }
            }
        }
        return dealers;
    }
    
    Public Void getSPList(){
        this.distributorsDisable = false;
        this.dealersDisable = false;
        if(userinfo.getUserType() == 'PowerCustomerSuccess' || Test.isRunningTest()){
            Account userAccount = new Account();
            if(this.noAvailability.CSS_WS_Regional_Distributor__c != null && this.noAvailability.CSS_WS_Dealer__c != null){
                userAccount = [SELECT IAM_Service_Provider_Code__c, CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE 
                (type = 'Distributor Account' OR type = 'Distributor Branch Account' OR type = 'Dealer Account' OR type = 'Dealer Branch Account') 
                AND CSS_DBCode__c =: this.noAvailability.CSS_WS_Regional_Distributor__c AND IAM_Service_Provider_Code__c =: this.noAvailability.CSS_WS_Dealer__c 
                AND CMI_Account_Status__c = 'Active' ORDER BY type LIMIT 1];
                System.debug( 'userAccount when edit= ' + userAccount );
            } else {
                Contact userContact = [SELECT Account.Name FROM Contact WHERE Id In (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
                userAccount = [SELECT IAM_Service_Provider_Code__c, CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE Account.Name =: userContact.Account.Name 
                        AND (type = 'Dealer Account' OR type = 'Distributor Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active'];
                System.debug( 'userAccount when new= ' + userAccount );
                if(userAccount != null){
                    if (userAccount.Type == 'Distributor Account' || userAccount.Type == 'Distributor Branch Account'){
                        this.noavailability.CSS_WS_Login_Variable__c='DRLoggedIn';
                    } else if(userAccount.Type == 'Dealer Account' || userAccount.Type == 'Dealer Branch Account'){ 
                        this.noavailability.CSS_WS_Login_Variable__c='DealerLoggedIn';              
                    }
                }
            }
            
            if(userAccount != null){
                this.noAvailability.CSS_WS_Regional_Distributor__c = userAccount.CSS_DBCode__c;
                this.noAvailability.CSS_WS_Dealer__c = userAccount.IAM_Service_Provider_Code__c;
                
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
            //throw error
            LogInVariable = 'DRLoggedIn';
            this.noAvailability.CSS_WS_Login_Variable__c = 'FactoryLoggedIn';
        }
        System.debug ( 'CSS_WS_Login_Variable__c = ' + this.noavailability.CSS_WS_Login_Variable__c );
    } 
            
    Public CSS_WS_Engine_Application_Code__c mapEngineApplication(String engineApplicationCodeStr){
        try {
            CSS_WS_Engine_Application_Code__c engineApplicationCode = [
                SELECT 
                    Name,
                    Application_Description__c,
                    Default_Measurement__c,
                    Automotive_Flag__c,
                    Marine_Flag__c
                FROM
                    CSS_WS_Engine_Application_Code__c 
                WHERE 
                    Application_Description__c = :engineApplicationCodeStr
            ];
            
            System.debug(engineApplicationCode.Name);
            return engineApplicationCode;
        } catch (Exception e){
            return null;
        }
    }  
    
    Public Void nagetESN(){
        if(this.noAvailability.CSS_WS_ESN__c != null) { 
            this.ESNR = this.noAvailability.CSS_WS_ESN__c;
        } else {
            this.ESNR = '';
        } 
        if(this.ESNR.isNumeric() && this.ESNR.length() == 8) {
            CSS_WS_J2A_GetEngineData objec = CSS_WS_GetWebServiceData.getEngineData(this.noAvailability.CSS_WS_ESN__c); //Web service call
            if(objec != null){
                if(objec.Header.Status.touppercase() == 'SUCCESS' && objec.DataArea != null){
                    CSS_WS_Engine_Application_Code__c code = mapEngineApplication(objec.DataArea.EngineAppDesc);
                    this.noAvailability.CSS_WS_Client__c = objec.DataArea.CustomerName;
                    this.noAvailability.CSS_WS_Model_Unit__c = objec.DataArea.Model;
                    this.noAvailability.CSS_WS_Brand_Unit__c = objec.DataArea.Manufacturer;
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,objec.Header.ReturnCodeDescription));
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Global_E001));//'Unexpected error, please contact your System Administrator'
                deletESN();
            }
        } else {
            deletESN();
        }
    }  
    
    Public Void deletESN(){
        this.noAvailability.CSS_WS_ESN__c = null;
        this.noAvailability.CSS_WS_Client__c = null;
        this.noAvailability.CSS_WS_Model_Unit__c = null;
        this.noAvailability.CSS_WS_Brand_Unit__c = null;
    }
    
    Public PageReference Save_NoAvailability_Format(){
        try {
            if(this.noAvailability.CSS_WS_Regional_Distributor__c == null || this.noAvailability.CSS_WS_Dealer__c == null || 
               this.noAvailability.CSS_WS_Special_Delivery__c == null || this.noAvailability.CSS_WS_DR_Contact__c == null || 
               this.noAvailability.CSS_WS_After_Sales_Engineer__c == null || this.noAvailability.CSS_WS_Factory_Distribution__c == null || 
               this.noAvailability.CSS_WS_ESN__c == null || this.noAvailability.CSS_WS_Brand_Unit__c == null || 
               this.noAvailability.CSS_WS_Model_Unit__c == null || this.noAvailability.CSS_WS_Number_Unit__c == null || 
               this.noAvailability.CSS_WS_Client__c == null || this.noAvailability.CSS_WS_No_attention_reason__c == null || 
               this.noAvailability.CSS_WS_Comments__c == null || this.noAvailability.CSS_WS_Attention_DR__c == null || 
               this.noAvailability.CSS_WS_Attention_Dealer__c == null || this.noAvailability.CSS_WS_OEM__c == null){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.CSS_WS_NoAvailability_E001));//'There are empty fields in the form.'
                   return null;
               } else {
                   //Update the claim with the values of this section      
                   upsert NoAvailability ;
                   //Redirect to Claim view page
                   PageReference NoAvailabilityPage = new ApexPages.StandardController(NoAvailability).view(); 
                   NoAvailabilityPage.setRedirect(true); 
                   return NoAvailabilityPage; 
               }
        } catch(DMLException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected error, please contact your System Administrator'));
            system.debug('Error: '+e.getMessage());
            return null;
        }
    }
    
    Public PageReference getRouter(){
        PageReference p;  
        if(this.NoAvailability.Id != null){
            if(system.approval.isLocked(this.NoAvailability.Id) != true){  
                return null;
            } else {
                string profileName = '';
                CSS_WS_No_Availability__c approverId;
                string userId = System.userinfo.getUserId();
                if(userId != null){
                    profileName = [SELECT Profile.Name FROM User WHERE Id =: userId LIMIT 1].Profile.Name;
                    approverId  = [SELECT CreatedBy.Community_Approver__c FROM CSS_WS_No_Availability__c WHERE id =: this.NoAvailability.Id LIMIT 1];
                }
                //if(profileName == 'CSS_WS_Factory_Warranty_Manager' || profileName =='System Admin' || profileName =='System Administrator' || userId == String.valueOf(approverId.CreatedBy.Community_Approver__c)) {
                if(getPermissionSet('CSS_WS_Factory_Warranty_Manager') || profileName =='System Admin' || profileName =='System Administrator' || userId == String.valueOf(approverId.CreatedBy.Community_Approver__c)) {
                    return null;
                } else {                
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_Global_E002);//Record is Locked
                    ApexPages.addMessage(errorMsg);
                    PageReference pageRef = Page.CSS_WS_Locked_record;
                    pageRef.setRedirect(true);
                    return pageRef;
                }            
            }
        }
        return null;
    }    

    Public List<SelectOption> getnaAttentionDRSelectList(){
        List<SelectOption> AttentionDistributors = new List<SelectOption>();
        AttentionDistributors.add(new SelectOption('', Label.CSS_WS_Selection_Distributor));
        List<Account> AttentionDistributorAccounts = new List<Account>();
        AttentionDistributorAccounts = [SELECT Name, CSS_DBCode__c, IAM_Service_Provider_Code__c FROM Account WHERE (Type = 'Distributor Account' OR 
                    Type = 'Distributor Branch Account') AND BillingCountry = 'MEXICO' AND 
                    (IAM_Service_Provider_Code__c = '56153' OR IAM_Service_Provider_Code__c = '54699' OR IAM_Service_Provider_Code__c = '54809' OR IAM_Service_Provider_Code__c = '55910' 
                    OR IAM_Service_Provider_Code__c = '04734' OR IAM_Service_Provider_Code__c = '54700' OR IAM_Service_Provider_Code__c = '55108' OR IAM_Service_Provider_Code__c = '56155' 
                    OR IAM_Service_Provider_Code__c = '74798' OR IAM_Service_Provider_Code__c = '54681' OR IAM_Service_Provider_Code__c = '73011' OR IAM_Service_Provider_Code__c = '54665' 
                    OR IAM_Service_Provider_Code__c = '56092' OR IAM_Service_Provider_Code__c = '54701' OR IAM_Service_Provider_Code__c = '40711' OR IAM_Service_Provider_Code__c = '00863' 
                    OR IAM_Service_Provider_Code__c = '54734') AND CMI_Account_Status__c = 'Active' ORDER BY Name];
        for(Account AttentionDistributor : AttentionDistributorAccounts){
            AttentionDistributors.add(new SelectOption((String)AttentionDistributor.IAM_Service_Provider_Code__c, (String)AttentionDistributor.Name));
        }
        return AttentionDistributors;
    }
    
    Public List<SelectOption> getnaAttentionDealersSelectList(){
        List<SelectOption> AttentionDealers = new List<SelectOption>();
        AttentionDealers .add(new SelectOption('',Label.CSS_WS_Selection_Dealer));
        List<Account> AttentionDealerAccounts = new List<Account>();
        if(this.noAvailability.CSS_WS_Attention_DR__c != null ){
            AttentionDealerAccounts = [SELECT Name, IAM_Service_Provider_Code__c, CSS_DBCode__c FROM Account WHERE 
                              CSS_DBCode__c =: this.noAvailability.CSS_WS_Attention_DR__c AND (type = 'Dealer Account' OR 
                              type = 'Distributor Account' OR type = 'Dealer Branch Account' OR 
                              type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active' ORDER BY Name];
            for(Account AttentionDealer : AttentionDealerAccounts){
                if(AttentionDealer.IAM_Service_Provider_Code__c != null && AttentionDealer.Name  != null){
                    AttentionDealers.add(new SelectOption((String)AttentionDealer.IAM_Service_Provider_Code__c, (String)AttentionDealer.Name));
                }
            }
        }
        return AttentionDealers;
    }
    
    Public Map<String, String> getSPCodeMapRegion(){//This method will return a map of SPCodes of DRs where the current user is associated to (Public Groups)
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