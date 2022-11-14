Public Class CSS_WS_ControllerStatement {
    
    Public CSS_WS_Statement__c Statement { get; set; }
    Public List<claimsList> ClaimsLists { get; set; }
    Public Integer index { get; set; }
    Public Boolean selected { get; set; }
    Public String DRCode { get; set; }
    Public String DealerCode { get; set; }
    Public String PolicyFlag { get; set; }
    Public String DRName { get; set; }
    Public String DealerName { get; set; }
    Public String Status { get; set; }
    Public Decimal ClaimAmount { get; set; }
    Public String ClaimNumber { get; set; }
    Public String CustomerName { get; set; }
    Public String TSMApproverName { get; set; }
    Public String ServiceModel { get; set; }
    Public String ModelSeries { get; set; }
    Public String AccountCode { get; set; }
    Public String FailureName { get; set; }
    Public Decimal TotalAmountClaims { get; set; }
    Public Integer ClaimToSum { get; set; }
    Public List<CSS_WS_Warranty__c> Claims { get; set; } 
    Public ApexPages.standardController stdControllerExit { get; set; } 
    
    Public CSS_WS_ControllerStatement(ApexPages.StandardController stdController){
        System.debug('Inicio CSS_WS_ControllerStatement ****** CSS_WS_ControllerStatement');
        this.stdControllerExit = stdController;
        this.ClaimsLists = new List<claimsList>();
        this.Claims = new List<CSS_WS_Warranty__c>();
        this.TotalAmountClaims = 0;
        this.selected = false;
        this.Statement = (CSS_WS_Statement__c)stdController.getRecord();
    }
    
    Public List<SelectOption> getDistributorsSelectList(){
        List<SelectOption> distributors = new List<SelectOption>();
        distributors.add(new SelectOption('', Label.CSS_WS_Selection_Distributor)); 
        List<Account> distributorAccounts = new List<Account>();
        distributorAccounts = [
            SELECT Account.Name, Account.CSS_DBCode__c, IAM_Service_Provider_Code__c FROM Account WHERE (Account.Type = 'Distributor Account' OR Account.Type = 'Distributor Branch Account')
            AND  (IAM_Service_Provider_Code__c = '56153' OR IAM_Service_Provider_Code__c = '54699' OR IAM_Service_Provider_Code__c = '54809' OR IAM_Service_Provider_Code__c = '55910' 
            OR IAM_Service_Provider_Code__c = '04734' OR IAM_Service_Provider_Code__c = '54700' OR IAM_Service_Provider_Code__c = '55108' OR IAM_Service_Provider_Code__c = '56155' 
            OR IAM_Service_Provider_Code__c = '74798' OR IAM_Service_Provider_Code__c = '54681' OR IAM_Service_Provider_Code__c = '73011' OR IAM_Service_Provider_Code__c = '54665' 
            OR IAM_Service_Provider_Code__c = '56092' OR IAM_Service_Provider_Code__c = '54701' OR IAM_Service_Provider_Code__c = '40711' OR IAM_Service_Provider_Code__c = '00863' 
            OR IAM_Service_Provider_Code__c = '54734') AND CMI_Account_Status__c = 'Active' ORDER BY Account.Name];
        for(Account distributor : distributorAccounts ){
            if((String)distributor.Name != 'PACCAR PARTS MEXICO'){
                distributors.add(new SelectOption((String)distributor.IAM_Service_Provider_Code__c, (String)distributor.Name));
            }
        }
        distributors.add(new SelectOption('All Distributors', Label.CSS_WS_Statement_E006));
        return distributors;
    }
    
    Public List<SelectOption> getDealersSelectList(){
        List<SelectOption> dealers = new List<SelectOption>();
        if(this.Statement.CSS_WS_Service_Provider_DR__c == 'All Distributors'){
            dealers.add(new SelectOption('All Dealers', Label.CSS_WS_Statement_E007)); 
            this.Statement.CSS_WS_Service_Provider_Dealer__c = 'All Dealers';
        } else {
            //this.Statement.CSS_WS_Service_Provider_Dealer__c = '';
            dealers.add(new SelectOption('', Label.CSS_WS_Selection_Dealer));
            List<Account> dealerAccounts = new List<Account>();
            if(this.Statement.CSS_WS_Service_Provider_DR__c != null ){
                dealerAccounts = [SELECT Name, IAM_Service_Provider_Code__c, CSS_DBCode__c FROM Account WHERE 
                              CSS_DBCode__c =: this.Statement.CSS_WS_Service_Provider_DR__c AND (type = 'Dealer Account' OR 
                              type = 'Distributor Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account') 
                              AND CMI_Account_Status__c = 'Active' ORDER BY Name];

                for(Account dealer : dealerAccounts){
                    if(dealer.IAM_Service_Provider_Code__c != null && dealer.Name  != null){
                        dealers.add(new SelectOption((String)dealer.IAM_Service_Provider_Code__c, (String)dealer.Name));
                    }
                }
            }  
            dealers.add(new SelectOption('All Dealers', 'All Dealers')); 
        }
        return dealers;
    }
    
    Public Class claimsList{
        //Add records new record to the SRTGrid Object
        Public CSS_WS_Warranty__c Claim { get; set; }
        Public Integer Index { get; set; }
        Public String ClaimNumber { get; set; }
        Public String PolicyFlag { get; set; }
        Public String DRCode { get; set; }
        Public String DealerCode { get; set; }
        Public String DRName { get; set; }
        Public String DealerName { get; set; }
        Public String CustomerName { get; set; }
        Public String TSMApproverName { get; set; }
        Public String ServiceModel { get; set; }
        Public String ModelSeries { get; set; }
        Public String AccountCode { get; set; }
        Public String FailureName { get; set; }
        Public Decimal ClaimAmount { get; set; }
        Public Boolean UpdateClaim { get; set; }
        Public claimsList(Integer Index, String ClaimNumber, String PolicyFlag, String DRCode, String DealerCode, String DRName, String DealerName, String CustomerName, String TSMApproverName, String ServiceModel, String ModelSeries, String AccountCode, String FailureName, String Status, Decimal ClaimAmount){
            this.Index = Index;
            this.ClaimNumber = ClaimNumber;
            this.PolicyFlag = PolicyFlag;
            this.DRCode = DRCode;
            this.DealerCode = DealerCode;
            this.DRName = DRName;
            this.DealerName = DealerName;
            this.CustomerName = CustomerName;
            this.TSMApproverName = TSMApproverName;
            this.ServiceModel = ServiceModel;
            this.ModelSeries = ModelSeries;
            this.AccountCode = AccountCode;
            this.FailureName = FailureName;
            //this.ClaimAmount = ClaimAmount;
            this.UpdateClaim = false;
                try {//Validate not nulls
                    Claim = new CSS_WS_Warranty__c(
                        CSS_WS_Total_Claim_Approved__c = ClaimAmount,
                        CSS_WS_Claim_Status__c = Status);
                } catch(Exception e){}
            }
    }
    
    Public Void getClaimsList(){
        Claims = new List<CSS_WS_Warranty__c>();
        ClaimsLists = new List<claimsList>();
        if(this.Statement.CSS_WS_Service_Provider_DR__c != '' && this.Statement.CSS_WS_Service_Provider_Dealer__c != ''){
            if(this.Statement.CSS_WS_Service_Provider_DR__c == 'All Distributors'){
                try{
                    Claims = [SELECT Id, CSS_WS_Policy_Flag__c, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c,
                        CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c, CSS_WS_Claim_Amount__c, CSS_WS_Total_Claim_Approved__c, CSS_WS_Customer_Name_Internal__c,
                        CSS_WS_Total_Amount_Part__c, CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Amount_Other_Claimables__c, 
                        CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Amount_Travel__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_Authorized_Amount__c, CSS_WS_Account_Code__c,
                        CSS_WS_Service_Model__c, CSS_WS_Model_Series__c, CSS_WS_TSM_Approver_Name__c, (SELECT CSS_WS_Failure_Name__c FROM CSS_WS_FailureW__r LIMIT 1) FROM CSS_WS_Warranty__c 
                        WHERE CSS_WS_Claim_Status__c =: 'Pending Planta Payment Policy' AND CSS_WS_Policy_Flag__c =: 'Policy' ORDER BY Name DESC LIMIT 90];
                } catch (Exception e){
                    System.debug('Error '+ e.getMessage());
                }
            } else if(this.Statement.CSS_WS_Service_Provider_Dealer__c == 'All Dealers'){
                try{
                    Claims = [SELECT Id, CSS_WS_Policy_Flag__c, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c,
                        CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c, CSS_WS_Claim_Amount__c, CSS_WS_Total_Claim_Approved__c, CSS_WS_Customer_Name_Internal__c,
                        CSS_WS_Total_Amount_Part__c, CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Amount_Other_Claimables__c, 
                        CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Amount_Travel__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_Authorized_Amount__c, CSS_WS_Account_Code__c,
                        CSS_WS_Service_Model__c, CSS_WS_Model_Series__c, CSS_WS_TSM_Approver_Name__c, (SELECT CSS_WS_Failure_Name__c FROM CSS_WS_FailureW__r LIMIT 1) FROM CSS_WS_Warranty__c 
                        WHERE CSS_WS_Claim_Status__c =: 'Pending Planta Payment Policy' AND CSS_WS_Policy_Flag__c =: 'Policy' AND CSS_WS_Service_Provider_DR__c =: this.Statement.CSS_WS_Service_Provider_DR__c
                        ORDER BY Name DESC LIMIT 90];
                } catch (Exception e){
                    System.debug('Error '+ e.getMessage());
                }
            } else {
                try{
                    Claims = [SELECT Id, CSS_WS_Policy_Flag__c, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c,
                        CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c, CSS_WS_Claim_Amount__c, CSS_WS_Total_Claim_Approved__c, CSS_WS_Customer_Name_Internal__c,
                        CSS_WS_Total_Amount_Part__c, CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Amount_Other_Claimables__c, 
                        CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Amount_Travel__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_Authorized_Amount__c, CSS_WS_Account_Code__c,
                        CSS_WS_Service_Model__c, CSS_WS_Model_Series__c, CSS_WS_TSM_Approver_Name__c, (SELECT CSS_WS_Failure_Name__c FROM CSS_WS_FailureW__r LIMIT 1) FROM CSS_WS_Warranty__c 
                        WHERE CSS_WS_Claim_Status__c =: 'Pending Planta Payment Policy' AND CSS_WS_Policy_Flag__c =: 'Policy' AND CSS_WS_Service_Provider_DR__c =: this.Statement.CSS_WS_Service_Provider_DR__c 
                        AND CSS_WS_Service_Provider_Dealer__c =: this.Statement.CSS_WS_Service_Provider_Dealer__c ORDER BY Name DESC LIMIT 90];
                } catch (Exception e){
                    System.debug('Error '+ e.getMessage());
                }
            }
        }
        System.debug(Claims);
        if(Claims.size() > 0){
            for(Integer i = 0; i < Claims.size(); i++){
                this.sumSubTotal(Claims[i], i);
                Account customer = [SELECT Name FROM Account WHERE id =: Claims[i].CSS_WS_Customer_Name_Internal__c LIMIT 1];
                this.Index = i + 1;
                this.ClaimNumber = Claims[i].Name;
                this.PolicyFlag = Claims[i].CSS_WS_Policy_Flag__c;
                this.DRCode = Claims[i].CSS_WS_Service_Provider_DR__c;
                this.DealerCode = Claims[i].CSS_WS_Service_Provider_Dealer__c;
                this.DRName = Claims[i].CSS_WS_Service_Provider_Name_DR__c;
                this.DealerName = Claims[i].CSS_WS_Service_Provider_Name_Dealer__c;
                this.CustomerName = customer.Name;
                this.TSMApproverName = Claims[i].CSS_WS_TSM_Approver_Name__c;
                this.ServiceModel = Claims[i].CSS_WS_Service_Model__c;
                this.ModelSeries = Claims[i].CSS_WS_Model_Series__c;
                this.AccountCode = Claims[i].CSS_WS_Account_Code__c;
                CSS_WS_Failure__c[] failure_list = claims[i].CSS_WS_FailureW__r;
                if (failure_list.size() > 0){
                    this.FailureName = failure_list[0].CSS_WS_Failure_Name__c;
                }                
                this.Status = Claims[i].CSS_WS_Claim_Status__c;                
                this.ClaimAmount = Claims[i].CSS_WS_Total_Claim_Approved__c;//CSS_WS_Claim_Amount__c;
                this.AddNewClaim();
            }
            this.sumTotal();
        }
        System.debug('List of claims ' + ClaimsLists);
    }
    
    Public Void updateClaimsList(){
        this.selected = false;
        this.ClaimsLists = new List<claimsList>();
        TotalAmountClaims = 0;
        ClaimToSum = 0;
        if(this.Statement.CSS_WS_Service_Provider_DR__c == 'All Distributors'){
            this.getClaimsList();
        } else {
            this.Statement.CSS_WS_Service_Provider_Dealer__c = '';
            this.getClaimsList();
        }
    } 
    
    Public Void AddNewClaim(){
        try{
            claimsList ClaimToAdd = new claimsList(
                this.Index,
                this.ClaimNumber,
                this.PolicyFlag,
                this.DRCode,
                this.DealerCode,
                this.DRName,
                this.DealerName,
                this.CustomerName,
                this.TSMApproverName,
                this.ServiceModel,
                this.ModelSeries,
                this.AccountCode,
                this.FailureName,
                this.Status,
                this.ClaimAmount);
            this.ClaimsLists.add(ClaimToAdd);
            System.debug('Add Claim ' + this.Index);
        } catch(Exception e){
            System.debug('Error Adding ' + e.getMessage());
            //this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
        }
    }
    
    Public Void selectAllClaims(){
        if(this.ClaimsLists.size() > 0){
            if(this.selected){
                for(claimsList actualClaim : this.ClaimsLists){
                    actualClaim.UpdateClaim = true;
                }
            } else {
                for(claimsList actualClaim : this.ClaimsLists){
                    actualClaim.UpdateClaim = false;
                }
            }
        }
        this.sumTotal();
    }
    
    Public Void sumTotal(){
        TotalAmountClaims = 0;
        if(this.ClaimsLists.size() > 0){
            for(claimsList actualClaim : this.ClaimsLists){
                if(actualClaim.UpdateClaim){
                    TotalAmountClaims =  TotalAmountClaims + actualClaim.Claim.CSS_WS_Total_Claim_Approved__c;
                }
            }
        }
        this.CheckSelected();
    }
    
    Public PageReference declineStatement(){
        ClaimToSum = 0;
        for(claimsList actualClaim : this.ClaimsLists){
            if(actualClaim.UpdateClaim){
                ClaimToSum = ClaimToSum + 1;
            }
        }
        if(ClaimToSum == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Statement_E001));
            return null;
        }
        upsert Statement;
        System.debug('Claims to update ' + ClaimsLists);
        if(this.ClaimsLists.size() > 0){
            for(claimsList actualClaim : this.ClaimsLists){
                if(actualClaim.UpdateClaim){
                    List<CSS_WS_Warranty__c> claimUpdate = [SELECT Id, CSS_WS_Claim_Status__c, CSS_WS_Statement_ID__c, CSS_WS_Total_Amount_Part__c,
                        CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Amount_Other_Claimables__c,
                        CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Amount_Travel__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_Authorized_Amount__c,
                        CSS_WS_Account_Code__c FROM CSS_WS_Warranty__c WHERE Name =: actualClaim.ClaimNumber];
                    System.debug('Claim to update ' + actualClaim.index + ' ' + claimUpdate[0]);
                    if(claimUpdate[0].CSS_WS_Total_Amount_Part__c > 0){
                        claimUpdate[0].CSS_WS_Total_Parts_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_Part__c.setscale(2);
                    } else {
                        claimUpdate[0].CSS_WS_Total_Parts_Approved__c = 0;
                    }   
                    if(claimUpdate[0].CSS_WS_Total_Amount_SRT__c > 0){
                        claimUpdate[0].CSS_WS_Total_Labor_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_SRT__c.setscale(2);
                    } else {
                        claimUpdate[0].CSS_WS_Total_Labor_Approved__c = 0;
                    }                           
                    if(claimUpdate[0].CSS_WS_Total_Amount_Other_Claimables__c > 0){
                        claimUpdate[0].CSS_WS_Total_Other_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_Other_Claimables__c;
                    } else {
                        claimUpdate[0].CSS_WS_Total_Other_Approved__c = 0;
                    }                           
                    if(claimUpdate[0].CSS_WS_Total_Amount_Travel__c > 0){
                        claimUpdate[0].CSS_WS_Total_Travel_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_Travel__c;
                    } else {
                        claimUpdate[0].CSS_WS_Total_Travel_Approved__c = 0;
                    }
                    claimUpdate[0].CSS_WS_Total_Claim_Approved__c = claimUpdate[0].CSS_WS_Total_Parts_Approved__c + claimUpdate[0].CSS_WS_Total_Labor_Approved__c + claimUpdate[0].CSS_WS_Total_Other_Approved__c + claimUpdate[0].CSS_WS_Total_Travel_Approved__c;
                    // For Policy P88 and P93, the Authorized Amount should be assigned
                    if (claimUpdate[0].CSS_WS_Account_Code__c == 'P88' || claimUpdate[0].CSS_WS_Account_Code__c == 'P93' || claimUpdate[0].CSS_WS_Account_Code__c == 'P100') {
                        claimUpdate[0].CSS_WS_Total_Parts_Approved__c = 0;
                        claimUpdate[0].CSS_WS_Total_Labor_Approved__c = 0;
                        claimUpdate[0].CSS_WS_Total_Other_Approved__c = 0;
                        claimUpdate[0].CSS_WS_Total_Travel_Approved__c = 0;
                        if (claimUpdate[0].CSS_WS_Authorized_Amount__c != null){
                            claimUpdate[0].CSS_WS_Total_Claim_Approved__c = claimUpdate[0].CSS_WS_Authorized_Amount__c.setscale(2);
                        } else {
                            claimUpdate[0].CSS_WS_Total_Claim_Approved__c = 0;
                        }
                    }
                    
                    claimUpdate[0].CSS_WS_Claim_Status__c = 'Declined by CSM';
                    claimUpdate[0].CSS_WS_Statement_ID__c = Statement.id;
                    update claimUpdate[0];
                }
            }
        }
        if(this.Statement.CSS_WS_Service_Provider_DR__c == 'All Distributors' && this.Statement.CSS_WS_Service_Provider_Dealer__c == 'All Dealers'){
            this.Statement.CSS_WS_Service_Provider_Name_DR__c = 'All Distributors';
            this.Statement.CSS_WS_Service_Provider_Name_Dealer__c = 'All Dealers';
        } else if(this.Statement.CSS_WS_Service_Provider_DR__c != 'All Distributors' && this.Statement.CSS_WS_Service_Provider_Dealer__c == 'All Dealers') {
            this.Statement.CSS_WS_Service_Provider_Name_DR__c = this.getSpName(this.Statement.CSS_WS_Service_Provider_DR__c, 'DR');
            this.Statement.CSS_WS_Service_Provider_Name_Dealer__c = 'All Dealers';
        } else {
            this.Statement.CSS_WS_Service_Provider_Name_DR__c = this.getSpName(this.Statement.CSS_WS_Service_Provider_DR__c, 'DR');
            this.Statement.CSS_WS_Service_Provider_Name_Dealer__c = this.getSpName(this.Statement.CSS_WS_Service_Provider_Dealer__c, 'DLR');
        }
        this.Statement.CSS_WS_Statement_Amount__c = TotalAmountClaims;
        this.Statement.CSS_WS_Quantity_Of_Claims__c = ClaimToSum;
        this.Statement.CSS_WS_Statement_Status__c = 'Declined';
        update Statement;
        /*String temDR = this.Statement.CSS_WS_Service_Provider_DR__c;
        String temDealer = this.Statement.CSS_WS_Service_Provider_Dealer__c;
        Statement = new CSS_WS_Statement__c();
        this.Statement.CSS_WS_Service_Provider_DR__c = temDR;
        this.Statement.CSS_WS_Service_Provider_Dealer__c = temDealer;
        this.updateClaimsList();
        return null;*/
        PageReference claimPage = new ApexPages.StandardController(Statement).view(); 
        claimPage.setRedirect(true); 
        return claimPage;
    }
    
    Public PageReference approveStatement(){
        ClaimToSum = 0;
        for(claimsList actualClaim : this.ClaimsLists){
            if(actualClaim.UpdateClaim){
                ClaimToSum = ClaimToSum + 1;
            }
        }
        if(ClaimToSum == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.CSS_WS_Statement_E001));
            return null;
        }
        upsert Statement;
        System.debug('Claims to update ' + ClaimsLists);
        if(this.ClaimsLists.size() > 0){
            for(claimsList actualClaim : this.ClaimsLists){
                if(actualClaim.UpdateClaim){
                    List<CSS_WS_Warranty__c> claimUpdate = [SELECT Id, CSS_WS_Claim_Status__c, CSS_WS_Statement_ID__c, CSS_WS_Total_Amount_Part__c,
                        CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Amount_Other_Claimables__c,
                        CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Amount_Travel__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_Authorized_Amount__c,
                        CSS_WS_Account_Code__c FROM CSS_WS_Warranty__c WHERE Name =: actualClaim.ClaimNumber];
                    if(claimUpdate[0].CSS_WS_Claim_Status__c != 'Declined by TSM'){
                        System.debug('Claim to update ' + actualClaim.index + ' ' + claimUpdate[0]);
                        if(claimUpdate[0].CSS_WS_Total_Amount_Part__c > 0){
                            claimUpdate[0].CSS_WS_Total_Parts_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_Part__c.setscale(2);
                        } else {
                            claimUpdate[0].CSS_WS_Total_Parts_Approved__c = 0;
                        }   
                        if(claimUpdate[0].CSS_WS_Total_Amount_SRT__c > 0){
                            claimUpdate[0].CSS_WS_Total_Labor_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_SRT__c.setscale(2);
                        } else {
                            claimUpdate[0].CSS_WS_Total_Labor_Approved__c = 0;
                        }                           
                        if(claimUpdate[0].CSS_WS_Total_Amount_Other_Claimables__c > 0){
                            claimUpdate[0].CSS_WS_Total_Other_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_Other_Claimables__c;
                        } else {
                            claimUpdate[0].CSS_WS_Total_Other_Approved__c = 0;
                        }                           
                        if(claimUpdate[0].CSS_WS_Total_Amount_Travel__c > 0){
                            claimUpdate[0].CSS_WS_Total_Travel_Approved__c = claimUpdate[0].CSS_WS_Total_Amount_Travel__c;
                        } else {
                            claimUpdate[0].CSS_WS_Total_Travel_Approved__c = 0;
                        }
                        claimUpdate[0].CSS_WS_Total_Claim_Approved__c = claimUpdate[0].CSS_WS_Total_Parts_Approved__c + claimUpdate[0].CSS_WS_Total_Labor_Approved__c + claimUpdate[0].CSS_WS_Total_Other_Approved__c + claimUpdate[0].CSS_WS_Total_Travel_Approved__c;
                        // For Policy P88 and P93, the Authorized Amount should be assigned
                        if (claimUpdate[0].CSS_WS_Account_Code__c == 'P88' || claimUpdate[0].CSS_WS_Account_Code__c == 'P93' || claimUpdate[0].CSS_WS_Account_Code__c == 'P100') {
                            claimUpdate[0].CSS_WS_Total_Parts_Approved__c = 0;
                            claimUpdate[0].CSS_WS_Total_Labor_Approved__c = 0;
                            claimUpdate[0].CSS_WS_Total_Other_Approved__c = 0;
                            claimUpdate[0].CSS_WS_Total_Travel_Approved__c = 0;
                            if (claimUpdate[0].CSS_WS_Authorized_Amount__c != null){
                                claimUpdate[0].CSS_WS_Total_Claim_Approved__c = claimUpdate[0].CSS_WS_Authorized_Amount__c.setscale(2);
                            } else {
                                claimUpdate[0].CSS_WS_Total_Claim_Approved__c = 0;
                            }
                        }
                        
                        claimUpdate[0].CSS_WS_Claim_Status__c = 'Approved for Payment';
                        claimUpdate[0].CSS_WS_Statement_ID__c = Statement.id;
                        update claimUpdate[0];
                    }
                }
            }
        } 
        if(this.Statement.CSS_WS_Service_Provider_DR__c == 'All Distributors' && this.Statement.CSS_WS_Service_Provider_Dealer__c == 'All Dealers'){
            this.Statement.CSS_WS_Service_Provider_Name_DR__c = 'All Distributors';
            this.Statement.CSS_WS_Service_Provider_Name_Dealer__c = 'All Dealers';
        } else if(this.Statement.CSS_WS_Service_Provider_DR__c != 'All Distributors' && this.Statement.CSS_WS_Service_Provider_Dealer__c == 'All Dealers') {
            this.Statement.CSS_WS_Service_Provider_Name_DR__c = this.getSpName(this.Statement.CSS_WS_Service_Provider_DR__c, 'DR');
            this.Statement.CSS_WS_Service_Provider_Name_Dealer__c = 'All Dealers';
        } else {
            this.Statement.CSS_WS_Service_Provider_Name_DR__c = this.getSpName(this.Statement.CSS_WS_Service_Provider_DR__c, 'DR');
            this.Statement.CSS_WS_Service_Provider_Name_Dealer__c = this.getSpName(this.Statement.CSS_WS_Service_Provider_Dealer__c, 'DLR');
        }
        this.Statement.CSS_WS_Statement_Amount__c = TotalAmountClaims;
        this.Statement.CSS_WS_Quantity_Of_Claims__c = ClaimToSum;
        this.Statement.CSS_WS_Statement_Status__c = 'Approved';
        update Statement;   
        PageReference claimPage = new ApexPages.StandardController(Statement).view(); 
        claimPage.setRedirect(true); 
        return claimPage;
    }
    
    /*Public PageReference exitStatement(){
        return stdControllerExit.cancel();
    }*/
    
    Public String getSpName(String spCode, String accType){
        Account sp = new Account();
        try {
            if(accType.toUpperCase() == 'DR'){
                sp = [SELECT Account.Name FROM Account WHERE IAM_Service_Provider_Code__c = :spCode AND (Account.Type = 'Distributor Account' 
                        OR Account.Type = 'Distributor Branch Account') LIMIT 1];
            } else {
                sp = [SELECT Account.Name FROM Account WHERE IAM_Service_Provider_Code__c = :spCode AND (Account.Type = 'Dealer Account' OR
                        Account.Type = 'Dealer Branch Account' OR Account.Type = 'Distributor Account' OR Account.Type = 'Distributor Branch Account')
                        AND Account.CSS_DBCode__c =: this.Statement.CSS_WS_Service_Provider_DR__c AND CMI_Account_Status__c = 'Active' LIMIT 1];
            }
            return sp.Name;
        } catch(Exception e){
            System.debug(e.getMessage());
        }
        return null;
    } 
    
    Public Void sumSubTotal(CSS_WS_Warranty__c claim, Integer i){
        
        // For Policy P88 and P93, the Authorized Amount should be assigned
        if (claim.CSS_WS_Account_Code__c == 'P88' || claim.CSS_WS_Account_Code__c == 'P93' || claim.CSS_WS_Account_Code__c == 'P100') {
            claim.CSS_WS_Total_Parts_Approved__c = 0;
            claim.CSS_WS_Total_Labor_Approved__c = 0;
            claim.CSS_WS_Total_Other_Approved__c = 0;
            claim.CSS_WS_Total_Travel_Approved__c = 0;
            if (claim.CSS_WS_Authorized_Amount__c != null){
                claims[i].CSS_WS_Total_Claim_Approved__c = claim.CSS_WS_Authorized_Amount__c.setscale(2);
            } else {
                claims[i].CSS_WS_Total_Claim_Approved__c = 0;
            }
        } else { //For all other Policy Claims
            if(claim.CSS_WS_Total_Amount_Part__c > 0){
                claim.CSS_WS_Total_Parts_Approved__c = claim.CSS_WS_Total_Amount_Part__c.setscale(2);
            } else {
                claim.CSS_WS_Total_Parts_Approved__c = 0;
            }   
            if(claim.CSS_WS_Total_Amount_SRT__c > 0) {
                claim.CSS_WS_Total_Labor_Approved__c = claim.CSS_WS_Total_Amount_SRT__c.setscale(2);
            } else {
                claim.CSS_WS_Total_Labor_Approved__c = 0;
            }                           
            if(claim.CSS_WS_Total_Amount_Other_Claimables__c > 0){
                claim.CSS_WS_Total_Other_Approved__c = claim.CSS_WS_Total_Amount_Other_Claimables__c;
            } else {
                claim.CSS_WS_Total_Other_Approved__c = 0;
            }                           
            if(claim.CSS_WS_Total_Amount_Travel__c > 0){
                claim.CSS_WS_Total_Travel_Approved__c = claim.CSS_WS_Total_Amount_Travel__c;
            } else {
                claim.CSS_WS_Total_Travel_Approved__c = 0;
            }
            claims[i].CSS_WS_Total_Claim_Approved__c = claim.CSS_WS_Total_Parts_Approved__c + claim.CSS_WS_Total_Labor_Approved__c + claim.CSS_WS_Total_Other_Approved__c + claim.CSS_WS_Total_Travel_Approved__c;
            claims[i].CSS_WS_Total_Claim_Approved__c = claims[i].CSS_WS_Total_Claim_Approved__c.setscale(2);
        }

    }
    
    Public Void CheckSelected(){
        integer check = 0;
        if(this.ClaimsLists.size() > 0){
            for(claimsList actualClaim : this.ClaimsLists){
                if(actualClaim.UpdateClaim){
                    check = check + 1;
                }
            }
        }
        if(this.ClaimsLists.size() == check){
            selected = true;
        } else {
            selected = false;
        }
    }
    
    /*Public List<CSS_WS_Warranty__c> getClaims(){
        Claims = new List<CSS_WS_Warranty__c>();
        if(this.Statement.CSS_WS_Service_Provider_DR__c != null && this.Statement.CSS_WS_Service_Provider_Dealer__c != null){
            try{
                Claims = [SELECT Id, CSS_WS_Policy_Flag__c, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c,
                    CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c FROM CSS_WS_Warranty__c 
                    WHERE CSS_WS_Claim_Status__c =: 'Pending Planta Payment Policy' AND CSS_WS_Policy_Flag__c =: 'Policy' AND CSS_WS_Service_Provider_DR__c =: this.Statement.CSS_WS_Service_Provider_DR__c 
                    AND CSS_WS_Service_Provider_Dealer__c =: this.Statement.CSS_WS_Service_Provider_Dealer__c];
                    //SELECT Id FROM CSS_WS_Warranty__c WHERE CSS_WS_Engine_Serial_Number__c = :this.claim.CSS_WS_Engine_Serial_Number__c AND Id != :this.claim.Id AND CSS_WS_Claim_Status__c != 'Draft' AND CSS_WS_Claim_Status__c != 'Canceled'
            } catch (Exception e){
                System.debug('Error '+e.getMessage());
            }
        }
        return Claims;
    }//Not
    
    Public Void callGetClaims(){
        System.debug('Enter ****** Enter');
        this.getClaims();
    }//Not*/
}