Public Class CSS_WS_ControllerApproveClaims{
    
    Public List<claimsList> claimsLists { get; set; }
    Public Integer index { get; set; }
    Public String PolicyFlag { get; set; }
    Public String Status { get; set; }
    Public Decimal ClaimAmount { get; set; }
    Public Integer claimToUpdate { get; set; }
    Public String ClaimNumber { get; set; }
    Public String CustomerName { get; set; }
    Public String Dealer { get; set; }
    Public String Distributor { get; set; }
    Public String DRName { get; set; }
    Public String DealerName { get; set; }
    Public String DealerSel { get; set; } 
    Public String DistributorSel { get; set; } 
    Public String ComcValue { get; set; } 
    Public String COMC { get; set; }
    Public Boolean SelectAll { get; set; }
    Public Boolean DistributorsDisable { get; set; }
    Public List<CSS_WS_Warranty__c> Claims { get; set; } 
    Public CSS_WS_Warranty__c claimTemp { get; set; }
    Public Boolean isDRRegion { get; set; }
    Public Map<String, String> group_region { get; set;}
    
    Public CSS_WS_ControllerApproveClaims(ApexPages.StandardController stdController){
        System.debug('Inicio CSS_WS_ControllerApproveClaims ****** CSS_WS_ControllerApproveClaims');
        this.claimTemp = (CSS_WS_Warranty__c)stdController.getRecord();
        this.ClaimsLists = new List<claimsList>();
        this.Claims = new List<CSS_WS_Warranty__c>();
        this.SelectAll = false;
        this.group_region = this.getSPCodeMapRegion();
        if(this.group_region.IsEmpty()){
            this.isDRRegion = false;
        } else {
            this.isDRRegion = true;
        }
        this.getSPList();
    }
    
    Public List<SelectOption> getDistributorsSelectList(){
        List<SelectOption> distributors = new List<SelectOption>();
        distributors.add(new SelectOption('', Label.CSS_WS_Selection_Distributor)); 
        List<Account> distributorAccounts = new List<Account>();
        distributorAccounts = [
            SELECT Account.Name, Account.CSS_DBCode__c, IAM_Service_Provider_Code__c FROM Account WHERE (Account.Type = 'Distributor Account' OR type = 'Distributor Branch Account')
            AND (IAM_Service_Provider_Code__c = '56153' OR IAM_Service_Provider_Code__c = '54699' OR IAM_Service_Provider_Code__c = '54809' OR IAM_Service_Provider_Code__c = '55910' 
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
        List<SelectOption> dealers = new List<SelectOption>();
            dealers.add(new SelectOption('', Label.CSS_WS_Selection_Dealer));
            List<Account> dealerAccounts = new List<Account>();
            if(this.DistributorSel != null ){
                dealerAccounts = [SELECT Name, IAM_Service_Provider_Code__c, CSS_DBCode__c FROM Account WHERE 
                              CSS_DBCode__c =: this.DistributorSel AND (type = 'Dealer Account' OR type = 'Distributor Account' OR 
                              type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active' ORDER BY Name];
                for(Account dealer : dealerAccounts){
                    if(dealer.IAM_Service_Provider_Code__c != null && dealer.Name  != null){
                        dealers.add(new SelectOption((String)dealer.IAM_Service_Provider_Code__c, (String)dealer.Name));
                    }
                    
                }  
                dealers.add(new SelectOption('All Dealers', 'All Dealers')); 
            }
        return dealers;
    }
    
    Public Void getSPList(){
        this.distributorsDisable = false;
        Account userAccount = new Account();
        if(userinfo.getUserType() == 'PowerCustomerSuccess'){
            Contact userContact = [SELECT Account.Name FROM Contact WHERE Id In (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
            userAccount = [SELECT IAM_Service_Provider_Code__c, CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE Account.Name =: userContact.Account.Name AND 
                          (type = 'Dealer Account' OR type = 'Distributor Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') 
                          AND CMI_Account_Status__c = 'Active'];
            if(userAccount != null){//Rule SF49
                this.DistributorSel = userAccount.CSS_DBCode__c;
                if(userAccount.Type == 'Distributor Account' || userAccount.Type == 'Distributor Branch Account'){
                    //this.distributorsDisable = true;
                    // validation to enable select list to select DR when DR Region is logged in
                    if (this.isDRRegion){
                        this.distributorsDisable = false;
                    } else {
                        this.distributorsDisable = true;
                    }  
                }
            }
        } 
    }
    
    Public Class claimsList{
        //Add records new record to the SRTGrid Object
        Public CSS_WS_Warranty__c Claim { get; set; }
        Public Integer Index { get; set; }
        Public String ClaimNumber { get; set; }
        Public String PolicyFlag { get; set; }
        Public String Distributor { get; set; }
        Public String Dealer { get; set; }
        Public String DRName { get; set; }
        Public String DealerName { get; set; }
        Public String CustomerName { get; set; }
        Public String COMC { get; set; }
        Public Decimal ClaimAmount { get; set; }
        Public Boolean UpdateClaim { get; set; }
        Public Boolean ChangeValueClaim { get; set; }
        Public claimsList(Integer Index, String ClaimNumber, String PolicyFlag, String DistributorCL, String DealerCl, String DRNameCl, String DealerNameCl, String CustomerName, String Status, Decimal ClaimAmount, String COMC){
            this.Index = Index;
            this.ClaimNumber = ClaimNumber;
            this.PolicyFlag = PolicyFlag;
            this.Distributor = DistributorCL;
            this.Dealer = DealerCl;
            this.DRName = DRNameCl;
            this.DealerName = DealerNamecl;
            this.CustomerName = CustomerName;
            this.COMC = COMC;
            this.ChangeValueClaim = ChangeValueClaim;
            this.UpdateClaim = false;
                try {//Validate not nulls
                    Claim = new CSS_WS_Warranty__c(CSS_WS_Claim_Status__c = Status);
                } catch(Exception e){}
            }
    }
    
    Public Void getClaimsList(){
        this.claimTemp.CSS_WS_DLR_Payment_Date__c = null;
        this.claimTemp.CSS_WS_DLR_Credit_Number__c = null;
        Claims = new List<CSS_WS_Warranty__c>();
        ClaimsLists = new List<claimsList>();
        String comc_filter = this.ComcValue + '%';
        if(this.DistributorSel != '' && this.DealerSel != ''){
            if(this.DealerSel == 'All Dealers'){
                try{
                    Claims = [SELECT Id, CSS_WS_Policy_Flag__c, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c, CSS_WS_Customer_Name__c,
                        CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c, CSS_WS_Claim_Amount__c, CSS_WS_Total_Claim_Approved__c, CSS_WS_Customer_Name_Internal__c,
                        CSS_WS_Total_Amount_Part__c, CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Amount_Other_Claimables__c, 
                        CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Amount_Travel__c, CSS_WS_DLR_Credit_Number__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_COMC__c FROM CSS_WS_Warranty__c 
                        WHERE CSS_WS_Belongs_To__c =: 'DR' AND CSS_WS_Claim_Status__c =: 'Pending DR Payment to DL' AND CSS_WS_Service_Provider_DR__c =: this.DistributorSel 
                        AND CSS_WS_COMC__c LIKE :comc_filter ORDER BY Name DESC LIMIT 90];
                } catch (Exception e){
                    System.debug('Error '+ e.getMessage());
                }
            } else {
                try{
                    Claims = [SELECT Id, CSS_WS_Policy_Flag__c, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c, CSS_WS_Customer_Name__c,
                        CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c, CSS_WS_Claim_Amount__c, CSS_WS_Total_Claim_Approved__c, CSS_WS_Customer_Name_Internal__c,
                        CSS_WS_Total_Amount_Part__c, CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Amount_Other_Claimables__c, 
                        CSS_WS_Total_Other_Approved__c, CSS_WS_DLR_Credit_Number__c, CSS_WS_DLR_Payment_Date__c, CSS_WS_Total_Amount_Travel__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_COMC__c
                        FROM CSS_WS_Warranty__c WHERE CSS_WS_Belongs_To__c =: 'DR' AND CSS_WS_Claim_Status__c =: 'Pending DR Payment to DL' AND CSS_WS_Service_Provider_DR__c =: this.DistributorSel 
                        AND CSS_WS_Service_Provider_Dealer__c =: this.DealerSel AND CSS_WS_COMC__c LIKE :comc_filter ORDER BY Name DESC LIMIT 90];
                } catch (Exception e){
                    System.debug('Error '+ e.getMessage());
                }
            }
        }
        System.debug(Claims);
        if(Claims != null){
            if(Claims.size() > 0){
                for(Integer i = 0; i < Claims.size(); i++){
                    if(Claims[i].CSS_WS_Customer_Name_Internal__c != null){
                        List<Account> customer = [SELECT Name FROM Account WHERE Id =: Claims[i].CSS_WS_Customer_Name_Internal__c LIMIT 1];
                        if(customer != null){
                            this.CustomerName = customer[0].Name;
                        }
                    } else {
                        this.CustomerName = 'BIS';
                    }
                    this.Index = i + 1;
                    this.ClaimNumber = Claims[i].Name;
                    this.PolicyFlag = Claims[i].CSS_WS_Policy_Flag__c;
                    this.Distributor = Claims[i].CSS_WS_Service_Provider_DR__c;
                    this.Dealer = Claims[i].CSS_WS_Service_Provider_Dealer__c;
                    this.DRName = Claims[i].CSS_WS_Service_Provider_Name_DR__c;
                    this.DealerName = Claims[i].CSS_WS_Service_Provider_Name_Dealer__c;
                    this.Status = Claims[i].CSS_WS_Claim_Status__c;                
                    this.ClaimAmount = Claims[i].CSS_WS_Total_Claim_Approved__c;//CSS_WS_Claim_Amount__c;
                    this.COMC = Claims[i].CSS_WS_COMC__c;
                    this.AddNewClaim();
                }
                System.debug('List of claims ' + ClaimsLists);
            }
        }
    }
    
    Public Void updateClaimsList(){
        this.ClaimsLists = new List<claimsList>();
        this.getClaimsList();
    } 
    
    Public Void AddNewClaim(){
        try{
            claimsList ClaimToAdd = new claimsList(
                this.Index,
                this.ClaimNumber,
                this.PolicyFlag,
                this.Distributor,
                this.Dealer,
                this.DRName,
                this.DealerName,
                this.CustomerName,
                this.Status,
                this.ClaimAmount,
                this.COMC);
            this.ClaimsLists.add(ClaimToAdd);
            System.debug('Add Claim ' + this.Index);
        } catch(Exception e){
            System.debug('Error Adding ' + e.getMessage());
        }
    }
    
    Public PageReference updateSelectedClaim(){
        System.debug('Row ' + this.claimToUpdate + ' to update');        
        if(this.ClaimsLists != null && this.claimToUpdate != null){
            Integer pos = this.claimToUpdate - 1;
            System.debug('Claim: ' + this.ClaimsLists[pos]);
            List<CSS_WS_Warranty__c> tem = [SELECT Id, CSS_WS_DLR_Payment_Date__c, CSS_WS_Claim_Status__c, CSS_WS_DLR_Credit_Number__c, CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Name =: this.ClaimsLists[pos].ClaimNumber];
            System.debug('Claim to update: ' + tem);
            if(tem != null && tem.size() > 0){
                tem[0].CSS_WS_DLR_Payment_Date__c = this.ClaimsLists[pos].claim.CSS_WS_DLR_Payment_Date__c;
                tem[0].CSS_WS_DLR_Credit_Number__c = this.ClaimsLists[pos].claim.CSS_WS_DLR_Credit_Number__c;
                tem[0].CSS_WS_Claim_Status__c = 'Paid';
            }
            update tem;
            this.updateClaimsList();
        }
        return null;
    }
    
    Public PageReference updateAllSelectedClaims(){
        Integer ClaimToUp = 0;
        if(ClaimsLists != null && ClaimsLists.size() != 0){
            for(claimsList actualClaim : this.ClaimsLists){
                if(actualClaim.claim.CSS_WS_DLR_Payment_Date__c != null && actualClaim.claim.CSS_WS_DLR_Credit_Number__c != null){
                    ClaimToUp = ClaimToUp + 1;
                }
            }
        }
        if(ClaimToUp == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Claim_E076));//Please select at least one claim to Update
            return null;
        }
        if(this.ClaimsLists != null){
            for(Integer i = 0; i < this.ClaimsLists.size(); i++){
                if(this.ClaimsLists[i].UpdateClaim == true){
                    List<CSS_WS_Warranty__c> tem = [SELECT CSS_WS_DLR_Payment_Date__c, CSS_WS_Claim_Status__c, CSS_WS_DLR_Credit_Number__c, CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Name =: this.ClaimsLists[i].ClaimNumber];
                    if(tem != null && tem.size() > 0){
                        tem[0].CSS_WS_DLR_Payment_Date__c = this.ClaimsLists[i].claim.CSS_WS_DLR_Payment_Date__c;
                        tem[0].CSS_WS_DLR_Credit_Number__c = this.ClaimsLists[i].claim.CSS_WS_DLR_Credit_Number__c;
                        tem[0].CSS_WS_Claim_Status__c = 'Paid';
                    }
                    update tem;
                }
            }
            this.updateClaimsList();
        }
        return null;
    }
    
    Public Void enableDisabledButtons(){
        if(this.ClaimsLists != null && this.claimToUpdate != null){
            Integer pos = this.claimToUpdate - 1;
            if(this.ClaimsLists[pos].claim.CSS_WS_DLR_Payment_Date__c != null && this.ClaimsLists[pos].claim.CSS_WS_DLR_Credit_Number__c != null){
                this.ClaimsLists[pos].UpdateClaim = true;
            } else {
                this.ClaimsLists[pos].UpdateClaim = false;
            }
            pos = 0;
            for(Integer tem = 0; tem < this.ClaimsLists.size(); tem++){
                if(this.ClaimsLists[tem].UpdateClaim == true){
                    pos = pos + 1;
                } 
            }
        }
    } 
    
    Public Void enableDisabledButtonApplyAll(){
        if(this.ClaimsLists != null){
            for(Integer tem = 0; tem < this.ClaimsLists.size(); tem++){
                if(SelectAll){
                    this.ClaimsLists[tem].ChangeValueClaim = true;
                } else {
                    this.ClaimsLists[tem].ChangeValueClaim = false;
                }
            }
        }
    } 
    
    Public Void CheckSelected(){
        Integer check = 0;
        if(this.ClaimsLists.size() > 0){
            for(claimsList actualClaim : this.ClaimsLists){
                if(actualClaim.ChangeValueClaim){
                    check = check + 1;
                }
            }
        }
        if(this.ClaimsLists.size() == check){
            SelectAll = true;
        } else {
            SelectAll = false;
        }
    }
    
    Public PageReference exitClaimsUpdate(){
        PageReference claimPage = new ApexPages.StandardController(claimTemp).cancel(); 
        claimPage.setRedirect(true); 
        return claimPage;
    }
    
    Public PageReference updateClaimsListValues(){
        Integer ClaimToUp = 0;
        if(this.ClaimsLists != null && this.ClaimsLists.size() != 0){
            for(claimsList actualClaim : this.ClaimsLists){
                if(actualClaim.ChangeValueClaim == true){
                    ClaimToUp = ClaimToUp + 1;
                }
            }
            if(SelectAll){
                ClaimToUp = ClaimToUp + 1;
            }
        }
        if(ClaimToUp == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Claim_E078));//Please select at least one claim
            return null;
        }
        if(this.ClaimsLists != null){
            if(this.claimTemp.CSS_WS_DLR_Payment_Date__c != null && this.claimTemp.CSS_WS_DLR_Credit_Number__c != null){
                for(Integer i = 0; i < this.ClaimsLists.size(); i++){
                    if(this.ClaimsLists[i].ChangeValueClaim == true){
                        this.ClaimsLists[i].claim.CSS_WS_DLR_Payment_Date__c = this.claimTemp.CSS_WS_DLR_Payment_Date__c;
                        this.ClaimsLists[i].claim.CSS_WS_DLR_Credit_Number__c = this.claimTemp.CSS_WS_DLR_Credit_Number__c;
                        this.ClaimsLists[i].UpdateClaim = true;
                    }
                }
                this.claimTemp.CSS_WS_DLR_Payment_Date__c = null;
                this.claimTemp.CSS_WS_DLR_Credit_Number__c = null;
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Claim_E077));//DLR Payment Date or DLR Credit Number could not be empty
                return null;
            }
        }
        return null;
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
}