Public Class CSS_WS_DynamicOtherClaimablesController{

    Public CSS_WS_Warranty__c ActualClaim { get; set; }
    Public CreateNewClaimable NewClaimables { get; set; }
    Public List<CreateNewClaimable> ClaimablesList { get; set; }
    Public List<String> SelectedClaimablesValues { get; set; }
    Public List<CSS_WS_Other_Claimable__c> ListToInsert { get; set; }
    Public Integer ClaimableCounter = 0;
    Public Integer ClaimableToDelete { get; set; }
    Public Double TotalAmountClaimables { get; set; }
    Public Decimal RequestAmount = 0;   
    Public String Claimable = '';
    Public String Description = '';
        
    Public CSS_WS_DynamicOtherClaimablesController(ApexPages.StandardController controller){
        System.debug('Inicio CSS_WS_DynamicOtherClaimablesController ****** CSS_WS_DynamicOtherClaimablesController');
        this.ActualClaim = (CSS_WS_Warranty__c)controller.getRecord();
        this.ClaimablesList = new List<CreateNewClaimable>();
        this.TotalAmountClaimables = 0;
        Decimal IsClaimCloned = 0;
        if(this.ActualClaim.id != null){
            IsClaimCloned = [SELECT Is_Clone__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id].Is_Clone__c;
        }
        if(this.ActualClaim.id != null && IsClaimCloned != 1){
            transient List<CSS_WS_Other_Claimable__c> SavedClaimables = [
                SELECT CSS_WS_Description__c, CSS_WS_Claimable__c, CSS_WS_Requested_Amount__c
                FROM CSS_WS_Other_Claimable__c WHERE CSS_WS_Warranty__c = : this.ActualClaim.id];
            
            Integer SavedClaimablesCount = SavedClaimables.size();
            if(SavedClaimablesCount > 0){
                for(Integer i = 0; i < SavedClaimablesCount; i++){
                    this.Claimable = SavedClaimables[i].CSS_WS_Claimable__c;
                    this.Description = SavedClaimables[i].CSS_WS_Description__c;
                    this.RequestAmount = SavedClaimables[i].CSS_WS_Requested_Amount__c;
                    this.AddNewClaimable();
                }
                this.ValidateOtherClaimableSelectList();
                this.SumClaimablesAmount();
                this.Claimable = '';
                this.Description = '';
                this.RequestAmount = 0;
            }
        }
    }
    
    Public Class CreateNewClaimable{
        Public CSS_WS_Other_Claimable__c Claimable{get; set;}
        Public Integer Index{get; set;}
        Public String ReadOnly{get; set;}
        Public CreateNewClaimable(Integer Index){
            this.Index = Index;
            this.Claimable = new CSS_WS_Other_Claimable__c();
            this.ReadOnly = '';
        }
    }       
    
    Public Void ValidateOtherClaimableSelectList(){
        this.SelectedClaimablesValues = new List<String>();
        for(CreateNewClaimable Claimable : this.ClaimablesList){
            this.SelectedClaimablesValues.add(Claimable.Claimable.CSS_WS_Claimable__c);
            if(Claimable.Claimable.CSS_WS_Claimable__c != null){ 
                if(Claimable.Claimable.CSS_WS_Claimable__c.contains('Unlisted') || String.isEmpty(Claimable.Claimable.CSS_WS_Claimable__c)){
                    Claimable.ReadOnly = 'false';
                    Claimable.Claimable.CSS_WS_Description__c = (Claimable.Claimable.CSS_WS_Description__c!=null)?Claimable.Claimable.CSS_WS_Description__c:'';
                    //Claimable.Claimable.CSS_WS_Description__c = '';
                } else {
                    Claimable.ReadOnly = 'true';
                    Claimable.Claimable.CSS_WS_Description__c = Claimable.Claimable.CSS_WS_Claimable__c;
                } 
                this.CheckClaimablesRepeated();
            }
        }
    }

    Public Void SumClaimablesAmount(){
        this.TotalAmountClaimables = 0;
        for(CreateNewClaimable Claimable : this.ClaimablesList){//Rule SF34
            if(Claimable.Claimable.CSS_WS_Requested_Amount__c != null && Claimable.Claimable.CSS_WS_Requested_Amount__c > 0){
                this.TotalAmountClaimables += Claimable.Claimable.CSS_WS_Requested_Amount__c;
                if(this.TotalAmountClaimables >= 100000){//Rule SF41
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_OtherC_E004));//Other Claimables cannot be greater than $100,000
                    break;
                }
            }
        }
    }
    
    Public Void AddNewClaimable(){
        try{
            CreateNewClaimable NewClaimable = new CreateNewClaimable(this.ClaimableCounter++);
            NewClaimable.Claimable.CSS_WS_Claimable__c = this.Claimable;
            NewClaimable.Claimable.CSS_WS_Description__c = this.Description;
            NewClaimable.Claimable.CSS_WS_Requested_Amount__c = this.RequestAmount;
            this.ClaimablesList.add(NewClaimable);
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            System.debug('Internal Server Error: ' + e.getMessage());
        }
    }
    
    Public Void DeleteClaimable(){
        Integer ClaimablePosToDelete = -1;
        Integer i = 0;
        Integer ListSize = this.ClaimablesList.size();
        for(i = 0; i < ListSize; i++){
            if(this.ClaimablesList[i].Index == this.ClaimableToDelete){
                ClaimablePosToDelete = i;
            }
        } 
        if(ClaimablePosToDelete != -1){
            this.ClaimablesList.remove(ClaimablePosToDelete);
            this.SumClaimablesAmount();
        }
    }
    
    Public Void BeforeSaveClaimables(){
        Map<String, String> WarningDetails = new Map<String, String>();
        WarningDetails.put(Label.CSS_WS_OtherC_Product1.touppercase(), Label.CSS_WS_OtherC_Product1);
        WarningDetails.put(Label.CSS_WS_OtherC_Product2.touppercase(), Label.CSS_WS_OtherC_Product2);
        WarningDetails.put(Label.CSS_WS_OtherC_Product3.touppercase(), Label.CSS_WS_OtherC_Product3);
        WarningDetails.put(Label.CSS_WS_OtherC_Product4.touppercase(), Label.CSS_WS_OtherC_Product4);
        WarningDetails.put(Label.CSS_WS_OtherC_Product5.touppercase(), Label.CSS_WS_OtherC_Product5);        
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        this.ListToInsert = new List<CSS_WS_Other_Claimable__c>();
        transient CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Covered_OC_Amount__c, CSS_WS_Policy_Flag__c, CSS_WS_Account_Code__c, CSS_WS_Failure_Point_Quantity__c, CSS_WS_Repair_Work_Order_Number__c, 
                                        CSS_WS_Campaign_OC_Percentage__c, CSS_WS_Failure_Date_Time__c, CSS_WS_Campaigns_TRPs__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
        for(CreateNewClaimable Claimable : this.ClaimablesList){
            //if(WarningDetails.containsKey(Claimable.Claimable.CSS_WS_Description__c.touppercase())){
            //    this.DisplayErrorHandler(Label.CSS_WS_OtherC_E003);
            //    Break;
            //}
            if(String.isEmpty(Claimable.Claimable.CSS_WS_Description__c) && !String.isEmpty(Claimable.Claimable.CSS_WS_Claimable__c)){//Rule SF42
                this.DisplayErrorHandler(Label.CSS_WS_OtherC_E002);//Description is required for Unlisted Other Claimables
                Break;
            }
            if(String.isEmpty(Claimable.Claimable.CSS_WS_Claimable__c) == false){
                if(String.isEmpty(Claimable.Claimable.CSS_WS_Warranty__c) == true){
                    Claimable.Claimable.CSS_WS_Warranty__c = this.ActualClaim.id;
                }
                Claimable.Claimable.Id = null;
                ListToInsert.add(Claimable.Claimable); 
            }
        }
        transient CSS_WS_Warranty__c[] claimDataHistory = [SELECT CSS_WS_Account_Code__c, CSS_WS_Repair_Work_Order_Number__c, CSS_WS_Failure_Date_Time__c FROM CSS_WS_Warranty__c 
            WHERE CSS_WS_Engine_Serial_Number__c =: this.ActualClaim.CSS_WS_Engine_Serial_Number__c AND CSS_WS_Account_Code__c =: this.ActualClaim.CSS_WS_Account_Code__c 
            AND CSS_WS_Failure_Point_Quantity__c =: this.ActualClaim.CSS_WS_Failure_Point_Quantity__c LIMIT 999];
        transient CSS_WS_Failure__c[] failureData = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c =: actualClaim.Id LIMIT 1];
        
        for(CSS_WS_Warranty__c act : claimDataHistory){//Rule SF-P12
            transient CSS_WS_Failure__c[] failureHistory = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c FROM CSS_WS_Failure__c 
                WHERE CSS_WS_Warranty__c =: act.Id LIMIT 1];
            
            if(claimData.CSS_WS_Repair_Work_Order_Number__c == act.CSS_WS_Repair_Work_Order_Number__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E059));
                break;
            } else if(claimData.CSS_WS_Failure_Date_Time__c == act.CSS_WS_Failure_Date_Time__c) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E059));
                break;
            } else if(failureHistory.size() > 0){
                if((failureData[0].CSS_WS_EngineSystemCode__c == failureHistory[0].CSS_WS_EngineSystemCode__c) && (failureData[0].CSS_WS_ComponentCode__c == failureHistory[0].CSS_WS_ComponentCode__c)) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E059));
                }
                break;
            }
        }
        this.CheckClaimablesRepeated();
        this.OtherClaimablesCallODM();
    }
    
    Public Void SaveClaimables(){
        /*Map<String, String> WarningDetails = new Map<String, String>();
        WarningDetails.put(Label.CSS_WS_OtherC_Product1.touppercase(), Label.CSS_WS_OtherC_Product1);
        WarningDetails.put(Label.CSS_WS_OtherC_Product2.touppercase(), Label.CSS_WS_OtherC_Product2);
        WarningDetails.put(Label.CSS_WS_OtherC_Product3.touppercase(), Label.CSS_WS_OtherC_Product3);
        WarningDetails.put(Label.CSS_WS_OtherC_Product4.touppercase(), Label.CSS_WS_OtherC_Product4);
        WarningDetails.put(Label.CSS_WS_OtherC_Product5.touppercase(), Label.CSS_WS_OtherC_Product5);        
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        this.ListToInsert = new List<CSS_WS_Other_Claimable__c>();
        transient CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Covered_OC_Amount__c, CSS_WS_Policy_Flag__c, CSS_WS_Account_Code__c, CSS_WS_Failure_Point_Quantity__c, CSS_WS_Repair_Work_Order_Number__c, 
                                        CSS_WS_Campaign_OC_Percentage__c, CSS_WS_Failure_Date_Time__c, CSS_WS_Campaigns_TRPs__c, CSS_WS_Account_Code_Type__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
        for(CreateNewClaimable Claimable : this.ClaimablesList){
            if(WarningDetails.containsKey(Claimable.Claimable.CSS_WS_Description__c.touppercase())){
                this.DisplayErrorHandler(Label.CSS_WS_OtherC_E003);
                Break;
            }
            if(String.isEmpty(Claimable.Claimable.CSS_WS_Description__c) && !String.isEmpty(Claimable.Claimable.CSS_WS_Claimable__c)){//Rule SF42
                this.DisplayErrorHandler(Label.CSS_WS_OtherC_E002);//Description is required for Unlisted Other Claimables
                Break;
            }
            if(String.isEmpty(Claimable.Claimable.CSS_WS_Claimable__c) == false){
                if(String.isEmpty(Claimable.Claimable.CSS_WS_Warranty__c) == true){
                    Claimable.Claimable.CSS_WS_Warranty__c = this.ActualClaim.id;
                }
                Claimable.Claimable.Id = null;
                ListToInsert.add(Claimable.Claimable); 
            }
        }
        transient CSS_WS_Warranty__c[] claimDataHistory = [SELECT CSS_WS_Account_Code__c, CSS_WS_Repair_Work_Order_Number__c, CSS_WS_Failure_Date_Time__c FROM CSS_WS_Warranty__c 
                                                 WHERE CSS_WS_Engine_Serial_Number__c =: this.ActualClaim.CSS_WS_Engine_Serial_Number__c
                                                 AND CSS_WS_Account_Code__c =: this.ActualClaim.CSS_WS_Account_Code__c 
                                                 AND CSS_WS_Failure_Point_Quantity__c =: this.ActualClaim.CSS_WS_Failure_Point_Quantity__c LIMIT 999];
        transient CSS_WS_Failure__c[] failureData = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c FROM CSS_WS_Failure__c 
                                           WHERE CSS_WS_Warranty__c =: actualClaim.Id LIMIT 1];
        
        for(CSS_WS_Warranty__c act : claimDataHistory){//Rule SF-P12
            transient CSS_WS_Failure__c[] failureHistory = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c FROM CSS_WS_Failure__c 
                WHERE CSS_WS_Warranty__c =: act.Id LIMIT 1];
            
            if(claimData.CSS_WS_Repair_Work_Order_Number__c == act.CSS_WS_Repair_Work_Order_Number__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E059));
                break;
            } else if(claimData.CSS_WS_Failure_Date_Time__c == act.CSS_WS_Failure_Date_Time__c) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E059));
                break;
            } else if(failureHistory.size() > 0){
                if((failureData[0].CSS_WS_EngineSystemCode__c == failureHistory[0].CSS_WS_EngineSystemCode__c) && (failureData[0].CSS_WS_ComponentCode__c == failureHistory[0].CSS_WS_ComponentCode__c)) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.CSS_WS_Claim_E059));
                }
                break;
            }
        }
        transient CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Covered_OC_Amount__c, CSS_WS_Policy_Flag__c, CSS_WS_Account_Code__c, CSS_WS_Failure_Point_Quantity__c, CSS_WS_Repair_Work_Order_Number__c, 
            CSS_WS_Campaign_OC_Percentage__c, CSS_WS_Failure_Date_Time__c, CSS_WS_Campaigns_TRPs__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
        try{
            transient CSS_WS_Other_Claimable__c[] ListToRemove = [SELECT Id FROM CSS_WS_Other_Claimable__c WHERE CSS_WS_Warranty__c = : this.ActualClaim.Id];
            delete ListToRemove;
            if(ListToInsert.size() > 0 && this.ActualClaim.CSS_WS_HasError__c == 0){                
                if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c == null || claimData.CSS_WS_Campaigns_TRPs__c == '')){//Warranty not campaing
                    if((this.TotalAmountClaimables <= claimData.CSS_WS_Covered_OC_Amount__c && (claimData.CSS_WS_Campaigns_TRPs__c == null || claimData.CSS_WS_Campaigns_TRPs__c == '')) || claimData.CSS_WS_Account_Code_Type__c == 'POL-Policy adjustment' || claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){ //Rule SF81
                        this.CheckClaimablesRepeated();
                        this.OtherClaimablesCallODM();
                        if(this.ActualClaim.CSS_WS_HasError__c == 0){
                            this.ActualClaim.CSS_WS_Total_Amount_Other_Claimables__c = this.TotalAmountClaimables;//Rule SF76
                            upsert this.ActualClaim;
                            upsert ListToInsert;  
                        }
                    } else {
                        this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E004 + ' ' + (claimData.CSS_WS_Covered_OC_Amount__c == null ? 0: claimData.CSS_WS_Covered_OC_Amount__c) + ' ' + Label.CSS_WS_PartsGrid_E007); 
                    } 
                
                } else if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c != null && claimData.CSS_WS_Campaigns_TRPs__c != '')){//Warranty whit campaing
                    if((claimData.CSS_WS_Campaign_OC_Percentage__c != 0 && claimData.CSS_WS_Campaign_OC_Percentage__c != null && (claimData.CSS_WS_Campaigns_TRPs__c != null && claimData.CSS_WS_Campaigns_TRPs__c != '')) || claimData.CSS_WS_Account_Code_Type__c == 'POL-Policy adjustment' || claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){ //Rule SF81
                        this.CheckClaimablesRepeated();
                        this.OtherClaimablesCallODM();
                        if(this.ActualClaim.CSS_WS_HasError__c == 0){
                            this.ActualClaim.CSS_WS_Total_Amount_Other_Claimables__c = this.TotalAmountClaimables;//Rule SF76
                            upsert this.ActualClaim;
                            upsert ListToInsert;  
                        }
                    } else {
                        this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E004 + ' ' + (claimData.CSS_WS_Campaign_OC_Percentage__c == null ? 0: claimData.CSS_WS_Campaign_OC_Percentage__c) + ' ' + Label.CSS_WS_PartsGrid_E006); 
                    }
                
                } else {//When is diferent of Warranty
                    this.CheckClaimablesRepeated();
                    this.OtherClaimablesCallODM();
                    if(this.ActualClaim.CSS_WS_HasError__c == 0){
                        this.ActualClaim.CSS_WS_Total_Amount_Other_Claimables__c = this.TotalAmountClaimables;//Rule SF76
                        upsert this.ActualClaim;
                        upsert ListToInsert;  
                    }
                }
            }
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            System.debug('Error: ' + e.getMessage());
        }*/
        transient CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Covered_OC_Amount__c, CSS_WS_Policy_Flag__c, CSS_WS_Account_Code__c, CSS_WS_Failure_Point_Quantity__c, CSS_WS_Repair_Work_Order_Number__c, 
            CSS_WS_Campaign_OC_Percentage__c, CSS_WS_Failure_Date_Time__c, CSS_WS_Campaigns_TRPs__c, CSS_WS_Account_Code_Type__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
        try{
            transient CSS_WS_Other_Claimable__c[] ListToRemove = [SELECT Id FROM CSS_WS_Other_Claimable__c WHERE CSS_WS_Warranty__c = : this.ActualClaim.Id];
            delete ListToRemove;
            if(ListToInsert.size() > 0 && this.ActualClaim.CSS_WS_HasError__c == 0){                
                if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c == null || claimData.CSS_WS_Campaigns_TRPs__c == '')){//Warranty not campaing
                    if((this.TotalAmountClaimables <= claimData.CSS_WS_Covered_OC_Amount__c && (claimData.CSS_WS_Campaigns_TRPs__c == null || claimData.CSS_WS_Campaigns_TRPs__c == '')) || claimData.CSS_WS_Account_Code_Type__c == 'POL-Policy adjustment' || claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){ //Rule SF81
                        if(this.ActualClaim.CSS_WS_HasError__c == 0){
                            this.ActualClaim.CSS_WS_Total_Amount_Other_Claimables__c = this.TotalAmountClaimables;//Rule SF76
                            upsert this.ActualClaim;
                            upsert ListToInsert;  
                        }
                    } else {
                        this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E004 + ' ' + (claimData.CSS_WS_Covered_OC_Amount__c == null ? 0: claimData.CSS_WS_Covered_OC_Amount__c) + ' ' + Label.CSS_WS_PartsGrid_E007); 
                    } 
                
                } else if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c != null && claimData.CSS_WS_Campaigns_TRPs__c != '')){//Warranty whit campaing
                    if((claimData.CSS_WS_Campaign_OC_Percentage__c != 0 && claimData.CSS_WS_Campaign_OC_Percentage__c != null && (claimData.CSS_WS_Campaigns_TRPs__c != null && claimData.CSS_WS_Campaigns_TRPs__c != '')) || claimData.CSS_WS_Account_Code_Type__c == 'POL-Policy adjustment' || claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){ //Rule SF81
                        if(this.ActualClaim.CSS_WS_HasError__c == 0){
                            this.ActualClaim.CSS_WS_Total_Amount_Other_Claimables__c = this.TotalAmountClaimables;//Rule SF76
                            upsert this.ActualClaim;
                            upsert ListToInsert;  
                        }
                    } else {
                        this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E004 + ' ' + (claimData.CSS_WS_Campaign_OC_Percentage__c == null ? 0: claimData.CSS_WS_Campaign_OC_Percentage__c) + ' ' + Label.CSS_WS_PartsGrid_E006); 
                    }
                
                } else {//When is diferent of Warranty
                    if(this.ActualClaim.CSS_WS_HasError__c == 0){
                        this.ActualClaim.CSS_WS_Total_Amount_Other_Claimables__c = this.TotalAmountClaimables;//Rule SF76
                        upsert this.ActualClaim;
                        upsert ListToInsert;  
                    }
                }
            } else if (ListToInsert.size() == 0 && this.ActualClaim.CSS_WS_HasError__c == 0){ //No records for Other Claimables; Total Amount for OC should be cero.
                this.ActualClaim.CSS_WS_Total_Amount_Other_Claimables__c = 0.00;
                upsert this.ActualClaim;
            }
            
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            System.debug('Error: ' + e.getMessage());
        }
    }
    
    Public Void CheckClaimablesRepeated(){
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        Integer RepeatedCounter = 0;
        if(this.SelectedClaimablesValues != null){
            Integer ClaimablesSize = this.SelectedClaimablesValues.size();
            for(Integer i = 0; i < ClaimablesSize; i++){
                for(Integer j = 0; j < ClaimablesSize; j++){
                    if(i != j){
                        if(this.SelectedClaimablesValues[i] == this.SelectedClaimablesValues[j]){//Rule SF26
                            this.DisplayErrorHandler(Label.CSS_WS_OtherC_E001);//Claimables cant be repeated
                            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, Label.CSS_WS_OtherC_E001);
                            ApexPages.addMessage(errorMsg);
                            break;
                        }
                    }
                }
            }
        }
    }
    
    Public Void OtherClaimablesCallODM(){
        if(this.ActualClaim.CSS_WS_Policy_Flag__c != 'Policy WW'){
            try{
                Map<String, String> header = new Map<String,String>();  
                transient CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Pay_Code__c, CSS_WS_Product_Application_Code__c, CSS_WS_Product_Application_Description__c,
                    CSS_WS_Marine_Application_Flag__c, CSS_WS_Build_Date__c, CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Approval_Code__c,
                    CSS_WS_Account_Code_Type__c, CSS_WS_InShopCampaignFlag__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
                Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.ActualClaim.CSS_WS_Service_Provider_DR__c , this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
                
                header.put('bisFlag',(this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
                header.put('cmiEngineSerialNumber',this.ActualClaim.CSS_WS_Engine_Serial_Number__c);
                header.put('cmiServiceProviderCode',this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
                header.put('engineFamily',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
                header.put('failureDate',CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                header.put('failureMeasure',this.ActualClaim.CSS_WS_Failure_Measure__c);
                header.put('failurePoint',this.ActualClaim.CSS_WS_Failure_Point_Quantity__c);
                header.put('manualAdjudicationFlag','');
                header.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                header.put('productApplicationCode',claimData.CSS_WS_Product_Application_Code__c);
                header.put('roNumber',this.ActualClaim.CSS_WS_Repair_Work_Order_Number__c);
                header.put('serviceModelName',this.ActualClaim.CSS_WS_Service_Model__c);
                header.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
                header.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
                header.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c); 
                header.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
                header.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
                header.put('outfileAllClaimsFlag','Y');
                header.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
                header.put('engineFamilyCode',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
                header.put('marineFlag',(claimData.CSS_WS_Marine_Application_Flag__c!=null)?claimData.CSS_WS_Marine_Application_Flag__c:'');
                header.put('buildDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Build_Date__c, 'MM/dd/YYYY'));
                header.put('etoConversionDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Engine_Trade_Out_conversion_date__c, 'MM/dd/yyyy'));
                header.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c == true)? 'Y' : 'N');
                header.put('productApplicationDesp',(claimData.CSS_WS_Product_Application_Description__c!=null)?claimData.CSS_WS_Product_Application_Description__c:'');
                if(this.ActualClaim.CSS_WS_Account_Code__c == '61'){
                    header.put('reconPartsWarrantyFlag','N');
                    header.put('newPartsWarrantyFlag','N');
                    header.put('roadRelayWarrantyFlag','N');
                } else {
                    header.put('reconPartsWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N');
                    header.put('newPartsWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Nuevo') ? 'Y' : 'N');
                    header.put('roadRelayWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
                }
                
                transient List<CSS_WS_Failure__c> fail = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c, CSS_WS_FailureModeCode__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :this.ActualClaim.Id ];  
                List<Map<String, String>> failure = new List<Map<String, String>> ();
                
                for(CSS_WS_Failure__c cont_fail: fail){
                    Map<String, String> failureData = new Map<String,String>{};
                    failureData.put('campaignId','');
                    failureData.put('payCode',claimdata.CSS_WS_Pay_Code__c);
                    failureData.put('totalLaborAmt','');
                    failureData.put('authorizationNumber',(this.ActualClaim.CSS_Authorization_Number__c!= NULL)?String.valueOf(this.ActualClaim.CSS_Authorization_Number__c):'');
                    failureData.put('approvalCode',(claimData.CSS_WS_Approval_Code__c!=null)?claimData.CSS_WS_Approval_Code__c:'');
                    failureData.put('totalTowingAmt','');
                    failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c);
                    failureData.put('failCode',cont_fail.CSS_WS_EngineSystemCode__c + cont_fail.CSS_WS_ComponentCode__c);
                    failureData.put('coverageType',claimdata.CSS_WS_Account_Code_Type__c);
                    failureData.put('failMode',cont_fail.CSS_WS_FailureModeCode__c);
                    failureData.put('accountCodeType',claimdata.CSS_WS_Account_Code_Type__c);
                    failureData.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                    failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c);
                    failureData.put('inShopCampaignFlag',(claimData.CSS_WS_InShopCampaignFlag__c != null) ? claimData.CSS_WS_InShopCampaignFlag__c : 'N');   
                    failure.add(failureData);
                }
               
                for(CSS_WS_Other_Claimable__c Claimable: this.ListToInsert){
                    List<Map<String, String>> ClaimablesToSend = new List<Map<String, String>>();
                    Map<String, String> ListOfClaimableValues = new Map<String, String>();
                    String OtherClaimable = (Claimable.CSS_WS_Claimable__c.contains('Unlisted')) ? 'UNLISTED' : Claimable.CSS_WS_Claimable__c.touppercase();
                    ListOfClaimableValues.put('Amount',String.valueOf(Claimable.CSS_WS_Requested_Amount__c));
                    ListOfClaimableValues.put('details',Claimable.CSS_WS_Description__c.touppercase());
                    ListOfClaimableValues.put('item',OtherClaimable);  //item
                    ClaimablesToSend.add(ListOfClaimableValues);
                    
                    transient CSS_WS_J2A_ODM_Validation ODMResponse = CSS_WS_GetWebServiceData.getODMValidationClaimable(header, failure, ClaimablesToSend);
                    if(ODMResponse != null){
                        if(ODMResponse.Response.claim.status.touppercase() == 'ERROR'){
                            for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                                this.DisplayErrorHandler(ODMResponse.Response.claim.messages[0].description);
                                break;
                            }
                        } else if (ODMResponse.Response.claim.status.touppercase() == 'WARNING' && !CSS_WS_ControllerClaim.ignoreWarnings) {
                            for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                                CSS_WS_ControllerClaim.odmWarnings.add(ODMResponse.Response.claim.messages[i].description);
                                this.ActualClaim.CSS_WS_HasError__c = 1;
                            }
                        }
                    } else {
                        this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                        break;
                    }
                }
            } catch(System.Exception e) {
                this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                System.Debug('Error: ' + e.getMessage());
            }
        }
    }
    
    Public Void DisplayErrorHandler(String MsgError){
        this.ActualClaim.CSS_WS_HasError__c = 1;
        this.ActualClaim.CSS_WS_HasMessage__c = MsgError;
    }
}