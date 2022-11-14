Public Class CSS_WS_SRTGridController{
    
    Public CSS_WS_Warranty__c ActualClaim { get; set; }
    Public Id warrantyId { get; set; }
    Public List<CSS_WS_Warranty_SRT__c> SRTsFromCampaign { get; set; }
    //Public CSS_WS_J2A_GetGSQSRT GSQSRTResponse { get; set; }
    Public Boolean savedGSQSRTData { get; set; }
    Public Map<String, CSS_WS_J2A_GetGSQSRT> GSQSRTResponseMap { get; set; }
    Public List<GSQSRTCaseResponse> SRTListTem { get; set; }
    Public List<CreateNewSRT> SRTsList { get; set; }
    Public List<CreateNewSRT> GSQsList { get; set; }
    Public List<SelectOption> getSRTOptions2 { get; set; }
    Public List<String> SRTData { get; set; }
    Public List<String> SelectedSRTValues { get; set; }
    Public List<String> SRTOverlap { get; set; }
    Public Integer SRTToUpdate { get; set; }
    Public Integer SRTCounter = 0;
    Public Integer SRTToDelete { get; set; } 
    Public Integer SRTToAdd { get; set; }
    Public Integer TableTotals { get; set; }
    Public Decimal IsFromCampaign {get; set;}
    Public Decimal Adjust_Percentage { get; set; }
    Public Decimal Actual_Hours { get; set; }
    Public Decimal Amount { get; set; }  
    Public Decimal Extended_Hours { get; set; }
    Public Decimal Hours { get; set; }
    Public Decimal Hours_Percentage { get; set; }
    Public Decimal Labor_Rate { get; set; } 
    Public Decimal Overlap_Hours { get; set; }
    Public Decimal Quantity { get; set; }
    Public Decimal Requested_Amount { get; set; }
    Public Decimal Total { get; set; }
    Public Decimal TotalAmountSRTHours { get; set; }
    Public Decimal TotalAmountSRTHoursExtended { get; set; }
    Public Decimal TotalAmountSRTHoursToPay { get; set; }
    Public Decimal TotalAmountSRTAmount { get; set; }
    Public String SRTCode { get; set; }
    Public String selectedSRT { get; set; }
    Public String Access_Code { get; set; }
    Public String Description { get; set; }
    Public Boolean LoadSRTs { get; set; }
    Public Boolean Offsite { get; set; }
    Public Boolean OutOfChassis { get; set; }
    Public Boolean disableRows { get; set; }   
    Public Boolean callGetSRTInfoFlag { get; set; } 
    Public Boolean IsCampaign = true;
    Public List<CSS_WS_Warranty_SRT__c> ListToInsert{get; set;}
    Public String StepId { get; set; }  //AQUI
    Public String GSQAssignment { get; set; }  //GSQ
    Public Boolean GSQEnabled {get; set;} 
    Public Boolean SelectedGSQ {get; set;}
    Public Boolean SelectAll { get; set; }
    Public Boolean ButtonAddAll { get; set; }
    Public Boolean load_srt_not_overlap = true; // Dec10th2020. Flag for not consuming srtoverlap in load saved srt data 
     
    Public CSS_WS_SRTGridController(ApexPages.StandardController controller){
        System.debug('Inicio CSS_WS_SRTGridController ****** CSS_WS_SRTGridController');
        callGetSRTInfoFlag = true;
        this.ActualClaim = (CSS_WS_Warranty__c)controller.getRecord();
        this.SelectAll = false;
        this.ButtonAddAll = false;
        if(this.ActualClaim != null){
            this.GetSRTInfo();
            this.SRTClassIni();
            this.SumSRTTotals();
        }
    }
    
    Public Class SRTtoSelect{
        Public Decimal Hours{get;set;}
        Public Decimal HoursR {get;set;}
        Public String  Description{get;set;}
        Public String SRTCode{get;set;}
        Public String AccessCode{get; set;} 
        Public String StepId{get;set;}      //AQUI
        Public String GSQAssignment{get;set;}      //GSQ
        Public SRTtoSelect(Decimal pHours, String pDescription, String pSRTCode, String AccessCode, String pStepId, String pGSQAssignment, Decimal pHoursR) {
            this.Hours = (pHours != null) ? pHours : 0;
            this.Description = (pDescription != null || pDescription != '') ? pDescription : '';
            this.SRTCode = (pSRTCode != null || pSRTCode != '') ? pSRTCode : '';
            this.StepId = (pStepId != null || pStepId != '') ? pStepId : '';  //AQUI
            this.GSQAssignment = (pGSQAssignment != null || pGSQAssignment != '') ? pGSQAssignment : '';  //GSQ
            this.HoursR = (pHoursR != null) ? pHoursR : 0;
        }
        
    }
    
    Public Class CreateNewSRT{
        //Add records new record to the SRTGrid Object
        Public CSS_WS_Warranty_SRT__c SRT { get; set; }
        Public Integer Index { get; set; }
        Public Boolean SelectedGSQ { get; set; }
        Public Boolean IsReadOnly { get; set; }      
        Public CreateNewSRT(
            Integer index,
            Boolean SelectedGSQ, //SelectedGSQ
            Decimal Adjust_Percentage,
            String  Access_Code,
            Decimal Actual_Hours,
            Decimal Amount,
            String  Description,
            Decimal Extended_Hours,
            Decimal Hours,
            Decimal Hours_Percentage,
            Decimal Labor_Rate,
            Boolean Offsite,
            Boolean OutOfChassis,
            Decimal Overlap_Hours,
            Decimal Quantity,
            Decimal Requested_Amount,
            String SRTCode,
            Decimal Total,
            String StepId,  //AQUI
            String GSQAssignment,  //GSQ
            Id WarrantyID){ 
                this.Index = Index;
                this.SelectedGSQ = SelectedGSQ;
                this.IsReadOnly = false;
                try {//Validate not nulls
                    SRT = new CSS_WS_Warranty_SRT__c(
                        CSS_WS_Adjust_Percentage__c = Adjust_Percentage,
                        CSS_WS_Access_Code__c = Access_Code,
                        CSS_WS_Actual_Hours__c = (Actual_Hours != null) ? Actual_Hours : 0,
                        CSS_WS_Amount__c = (Amount != null) ? Amount : 0,
                        CSS_WS_Description__c = Description,
                        CSS_WS_Extended_Hours__c = (Extended_Hours != null) ? Extended_Hours : 0,
                        CSS_WS_Hours__c = (Hours != null) ? Hours : 0,
                        CSS_WS_Hours_Percentage__c = (Hours_Percentage != null) ? Hours_Percentage : 0,
                        CSS_WS_Labor_Rate__c = (Labor_Rate != null) ? Labor_Rate : 0,
                        CSS_WS_Offsite__c = Offsite,
                        CSS_WS_OutOfChassis__c = OutOfChassis,
                        CSS_WS_Overlap_Hours__c = (Overlap_Hours != null) ? Overlap_Hours : 0,
                        CSS_WS_Quantity__c = (Quantity != null) ? Quantity : 0,
                        CSS_WS_Requested_Amount__c = (Requested_Amount != null) ? Requested_Amount : 0,
                        CSS_WS_SRT__c = SRTCode,
                        CSS_WS_Total__c = (Total != null) ? Total : 0,
                        CSS_WS_Step_Id__c = (StepId != null) ? StepId : '',  //AQUI
                        CSS_WS_GSQ_Assignment__c = (GSQAssignment != null) ? GSQAssignment : '',  //GSQ
                        CSS_WS_WarrantyID__c = WarrantyID);
                } catch(Exception e){}
            }
    }
    
    Public Void SRTClassIni(){
        this.IsCampaign = (String.isEmpty(this.ActualClaim.CSS_WS_Campaigns_TRPs__c)) ? false : true;
        this.SRTsList = new List<CreateNewSRT>();
        this.GSQsList = new List<CreateNewSRT>();
        this.GSQEnabled = false;
        Decimal IsClaimCloned = 0;
        if(this.ActualClaim.id != null){
            IsClaimCloned = [SELECT Is_Clone__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id].Is_Clone__c;
        }
        if(this.ActualClaim.id != null && IsClaimCloned != 1){
            this.SetSRTOptionList();
            //if(this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c == '0 - Not consumed'){
            //    this.CallWSToGetGSQSRT();
            //}
            //if(this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c == '1 - Consumed with proper response' && this.GSQSRTResponse != null){
            //    this.LoadGSQSRT();
            //} 
            this.LoadPreviousSRT();
        }
    }
    
    Public Void LoadPreviousSRT() {
        this.SetDefaultValues();
        //this.GetSRTInfo();
        List<CSS_WS_Warranty_SRT__c> SavedSRTs = [
            SELECT id, CSS_WS_Adjust_Percentage__c, CSS_WS_Access_Code__c, CSS_WS_Actual_Hours__c,
            CSS_WS_Amount__c, CSS_WS_Description__c,  CSS_WS_Extended_Hours__c, CSS_WS_Hours__c,
            CSS_WS_Hours_Percentage__c,  CSS_WS_Labor_Rate__c, CSS_WS_Offsite__c, CSS_WS_OutOfChassis__c,
            CSS_WS_Overlap_Hours__c, CSS_WS_Quantity__c, CSS_WS_Requested_Amount__c, CSS_WS_SRT__c,
            CSS_WS_Total__c, CSS_WS_WarrantyID__c, CameFromWebService__c, CSS_WS_Step_Id__c, CSS_WS_GSQ_Assignment__c
            FROM CSS_WS_Warranty_SRT__c WHERE CSS_WS_WarrantyID__c = : this.ActualClaim.id];
        
        if(SavedSRTs.size() > 0){
            for(Integer i = 0; i < SavedSRTs.size(); i++){
                this.IsFromCampaign = (SavedSRTs[i].CameFromWebService__c != null) ? SavedSRTs[i].CameFromWebService__c : this.IsFromCampaign;
                this.Adjust_Percentage = (SavedSRTs[i].CSS_WS_Adjust_Percentage__c != null) ? SavedSRTs[i].CSS_WS_Adjust_Percentage__c : this.Adjust_Percentage;
                this.Access_Code = (SavedSRTs[i].CSS_WS_Access_Code__c != null) ? SavedSRTs[i].CSS_WS_Access_Code__c : this.Access_Code;
                this.Actual_Hours = (SavedSRTs[i].CSS_WS_Actual_Hours__c != null) ? SavedSRTs[i].CSS_WS_Actual_Hours__c : this.Actual_Hours;
                this.Amount = (SavedSRTs[i].CSS_WS_Amount__c != null) ? SavedSRTs[i].CSS_WS_Amount__c : this.Amount;
                this.Description = (SavedSRTs[i].CSS_WS_Description__c != null) ? SavedSRTs[i].CSS_WS_Description__c : this.Description;
                this.Extended_Hours = (SavedSRTs[i].CSS_WS_Extended_Hours__c != null) ? SavedSRTs[i].CSS_WS_Extended_Hours__c : this.Extended_Hours;
                this.Hours = (SavedSRTs[i].CSS_WS_Hours__c != null) ? SavedSRTs[i].CSS_WS_Hours__c : this.Hours;
                this.Hours_Percentage = (SavedSRTs[i].CSS_WS_Hours_Percentage__c != null) ? SavedSRTs[i].CSS_WS_Hours_Percentage__c : this.Hours_Percentage;
                this.Labor_Rate = (SavedSRTs[i].CSS_WS_Labor_Rate__c != null) ? SavedSRTs[i].CSS_WS_Labor_Rate__c : this.Labor_Rate;
                this.Offsite = (SavedSRTs[i].CSS_WS_Offsite__c != null) ? SavedSRTs[i].CSS_WS_Offsite__c : this.Offsite;
                this.OutOfChassis = (SavedSRTs[i].CSS_WS_OutOfChassis__c != null) ? SavedSRTs[i].CSS_WS_OutOfChassis__c : this.OutOfChassis;
                this.Overlap_Hours = (SavedSRTs[i].CSS_WS_Overlap_Hours__c != null) ? SavedSRTs[i].CSS_WS_Overlap_Hours__c : this.Overlap_Hours;
                this.Quantity = (SavedSRTs[i].CSS_WS_Quantity__c != null) ? SavedSRTs[i].CSS_WS_Quantity__c : this.Quantity;
                this.Requested_Amount = (SavedSRTs[i].CSS_WS_Requested_Amount__c != null) ? SavedSRTs[i].CSS_WS_Requested_Amount__c : this.Requested_Amount;
                this.SRTCode = (SavedSRTs[i].CSS_WS_SRT__c != null) ? SavedSRTs[i].CSS_WS_SRT__c.touppercase() : this.SRTCode;
                this.Total = (SavedSRTs[i].CSS_WS_Total__c != null) ? SavedSRTs[i].CSS_WS_Total__c : this.Total;
                this.StepId = (SavedSRTs[i].CSS_WS_Step_Id__c != null) ? SavedSRTs[i].CSS_WS_Step_Id__c : this.StepId;  //AQUI
                this.GSQAssignment = (SavedSRTs[i].CSS_WS_GSQ_Assignment__c != null) ? SavedSRTs[i].CSS_WS_GSQ_Assignment__c : this.GSQAssignment;  //GSQ
                this.AddNewSRT();
            }
            this.AssignSRTDescription();            
        }
        this.SetDefaultValues();
        /*if(this.IsCampaign == true){ // Dec11th2020. CheckOutOfChassis is not needed during loading data
            load_srt_not_overlap = false; // Dec10th2020. Flag for not consuming srtoverlap in load saved srt data 
            for(integer i = 0 ; i < SRTsFromCampaign.size(); i++){
                this.SRTToUpdate = i;
                CheckOutOfChassis();
            } 
            load_srt_not_overlap = true; // Dec10th2020. Flag for not consuming srtoverlap in load saved srt data 
        } */       
    }
    
    Public Void SetDefaultValues(){
        String lr = '';
        lr = (this.ActualClaim.CSS_WS_RescueNumber__c != null) ? this.ActualClaim.CSS_WS_Labor_Rate__c : this.ActualClaim.CSS_WS_In_shop_Labor_Rate__c;
        This.SRTCode = '';
        This.Adjust_Percentage = (this.ActualClaim.CSS_WS_SRTPenaltyPercentage__c != null && this.ActualClaim.CSS_WS_SRTPenaltyPercentage__c != '0') ? Decimal.valueof(this.ActualClaim.CSS_WS_SRTPenaltyPercentage__c) : 100.0;
        This.Access_Code = '';
        This.Actual_Hours = 0.0;
        This.Amount = 0.00;
        This.Description = '';
        This.Extended_Hours = 0.00;
        This.Hours = 0;
        This.Hours_Percentage = This.Adjust_Percentage;
        This.Labor_Rate = String.isEmpty(lr) ? 0 : Decimal.valueOf(lr);
        This.Offsite = false;
        This.OutOfChassis = false;
        This.Overlap_Hours = 0.0;
        This.Quantity = 1;
        This.Requested_Amount = 0;
        This.Total = 0;
        this.IsFromCampaign = 0;
        This.StepId = '';  //AQUI
        This.GSQAssignment = '';  //GSQ
    }
    
    Public Void SetSRTOptionList(){       
        if(this.IsCampaign == true){
            this.SRTsFromCampaign = [
                SELECT CSS_WS_SRT__c, CSS_WS_Hours__c, CSS_WS_Description__c, CSS_WS_Access_Code__c
                FROM CSS_WS_Warranty_SRT__c WHERE CSS_WS_WarrantyID__c = : this.ActualClaim.Id LIMIT 999];
        }
    }
    
    Public Void AddNewSRT(){
        try{
            CreateNewSRT SRT = new CreateNewSRT(
                This.SRTCounter ++,
                This.SelectedGSQ,
                This.Adjust_Percentage,
                This.Access_Code,
                This.Actual_Hours,
                This.Amount,
                This.Description,
                This.Extended_Hours,
                This.Hours,
                This.Hours_Percentage,
                This.Labor_Rate,
                This.Offsite,
                This.OutOfChassis,
                This.Overlap_Hours,
                This.Quantity,
                This.Requested_Amount,
                This.SRTCode,
                This.Total,
                This.StepId,  //AQUI
                This.GSQAssignment,  //GSQ
                this.ActualClaim.Id
            );
            SRT.SRT.CameFromWebService__c = this.IsFromCampaign;
            this.SRTsList.add(SRT);
            this.SetDefaultValues();
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
        }
    }
    
    Public Void DeleteSRT(){
        Integer SRTPosToDelete = -1;
        Integer i;
        Integer ListSize = this.SRTsList.size();
        for(i = 0; i < ListSize; i++){
            if(this.SRTsList[i].Index == this.SRTToDelete){
                SRTPosToDelete = i;
            }
        }
        if(SRTPosToDelete != -1){
            this.SRTsList.remove(SRTPosToDelete);
            this.AssignSRTDescription();    
        }
    }
    
    Public PageReference SaveSRTGrids(){
        
        CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Covered_Labor_Hours__c, CSS_WS_Campaign_Labor_Percentage__c, CSS_WS_Policy_Flag__C, CSS_WS_Campaigns_TRPs__c, CSS_WS_Account_Code_Type__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
        try{
            if (!this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c){
                return null;
            }
            this.ActualClaim.CSS_WS_HasError__c = 0;
            this.ActualClaim.CSS_WS_HasMessage__c = '';
            this.ListToInsert = new List<CSS_WS_Warranty_SRT__c>();
            this.SelectedSRTValues = new List<String>();
            for(CreateNewSRT srt : this.SRTsList){
                if(!String.isEmpty(srt.SRT.CSS_WS_SRT__c)){
                    srt.SRT.Id = null;
                    this.ListToInsert.add(srt.SRT);
                    if(claimData.CSS_WS_Policy_Flag__c == 'Policy'){//Rule SF-P11
                        if(CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '19-611-00'|| CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '19-601-00' || CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '19-606-00' || CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '19-030-00' || CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) =='19-031-00'){
                            if(this.ActualClaim.CSS_WS_ECM_Calibration_After__c == null){
                                this.ActualClaim.CSS_WS_HasError__c = 1;
                                this.ActualClaim.CSS_WS_HasMessage__c = Label.CSS_WS_Claim_E010;
                                return null;
                            } else if(this.ActualClaim.CSS_WS_ECM_Calibration_Before__c == null){
                                this.ActualClaim.CSS_WS_HasError__c = 1;
                                this.ActualClaim.CSS_WS_HasMessage__c = Label.CSS_WS_Claim_E011;
                                return null;
                            }
                        }
                        if(CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '99-999-00'){
                            if(String.isEmpty(srt.SRT.CSS_WS_Description__c) || srt.SRT.CSS_WS_Hours__c == 0){//Rule SF53
                                this.ActualClaim.CSS_WS_HasError__c = 1;
                                this.ActualClaim.CSS_WS_HasMessage__c = label.CSS_WS_SRTGrid_E008;//Please inform the dealer of the SRT 99-999 documentation requirements. Reference Warranty Memo 1209
                                return null;
                            }
                        }
                    }
                    if(claimData.CSS_WS_Policy_Flag__c == 'Warranty'){
                        if(CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '99-999-00'){
                            if(String.isEmpty(srt.SRT.CSS_WS_Description__c) || srt.SRT.CSS_WS_Hours__c == 0){//Rule SF53
                                this.ActualClaim.CSS_WS_HasError__c = 1;
                                this.ActualClaim.CSS_WS_HasMessage__c = label.CSS_WS_SRTGrid_E008;//Please inform the dealer of the SRT 99-999 documentation requirements. Reference Warranty Memo 1209
                                return null;
                            }
                        }
                    }
                    this.SelectedSRTValues.add(srt.SRT.CSS_WS_SRT__c); 
                }
            } 
            List<CSS_WS_Warranty_SRT__c> ListToDelete = [SELECT Id FROM CSS_WS_Warranty_SRT__c WHERE CSS_WS_WarrantyID__c = : this.ActualClaim.Id];
            delete ListToDelete;
            if(ListToInsert.size() > 0){
                this.CheckRepeatedSRT();
                this.SumSRTTotals();
                if(this.ActualClaim.CSS_WS_HasError__c == 0){
                    if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c == null || claimData.CSS_WS_Campaigns_TRPs__c == '')){//Warranty not campaing
                        if((this.TotalAmountSRTHoursExtended <= claimData.CSS_WS_Covered_Labor_Hours__c && (claimData.CSS_WS_Campaigns_TRPs__c == null || claimData.CSS_WS_Campaigns_TRPs__c == '')) || claimData.CSS_WS_Account_Code_Type__c == 'POL-Policy adjustment' || claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){//Rule SF81
                                this.ActualClaim.CSS_WS_Total_Amount_SRT__c = this.TotalAmountSRTAmount;//Rule SF76
                                this.ActualClaim.CSS_WS_Total_Amount_SRT_Hours__c = this.TotalAmountSRTHoursToPay;
                                upsert this.ActualClaim;
                                insert ListToInsert;
                        } else {
                            this.DisplayErrorHandler(Label.CSS_WS_SRTGrid_E001 + ' ' + (claimData.CSS_WS_Covered_Labor_Hours__c == null ? 0: claimData.CSS_WS_Covered_Labor_Hours__c) + ' ' + Label.CSS_WS_SRTGrid_E002);//The coverage doesnt cover more than ' ' hours'
                        }
                    } else if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c != null && claimData.CSS_WS_Campaigns_TRPs__c != '')){//Warranty whit campaing
                        if((claimData.CSS_WS_Campaign_Labor_Percentage__c != null && claimData.CSS_WS_Campaign_Labor_Percentage__c != 0 && (claimData.CSS_WS_Campaigns_TRPs__c != null && claimData.CSS_WS_Campaigns_TRPs__c != '')) || claimData.CSS_WS_Account_Code_Type__c == 'POL-Policy adjustment' || claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){//Rule SF81
                            this.ActualClaim.CSS_WS_Total_Amount_SRT__c = this.TotalAmountSRTAmount;//Rule SF76
                            this.ActualClaim.CSS_WS_Total_Amount_SRT_Hours__c = this.TotalAmountSRTHoursToPay;
                            upsert this.ActualClaim;
                            insert ListToInsert;
                        } else {
                            this.DisplayErrorHandler(Label.CSS_WS_SRTGrid_E001 + ' ' + (ActualClaim.CSS_WS_Campaign_Labor_Percentage__c == null ? 0: ActualClaim.CSS_WS_Campaign_Labor_Percentage__c) + ' ' + Label.CSS_WS_PartsGrid_E006);//'The coverage doesnt cover more than ' ' porcentage'
                        }
                        
                    } else {//When is diferent of Warranty
                        this.ActualClaim.CSS_WS_Total_Amount_SRT__c = this.TotalAmountSRTAmount;//Rule SF76
                        this.ActualClaim.CSS_WS_Total_Amount_SRT_Hours__c = this.TotalAmountSRTHoursToPay;
                        upsert this.ActualClaim;
                        insert ListToInsert;
                    }
                }
            } else if(ListToInsert.size() == 0){ //No records for SRTs; Total Amount for SRT should be cero.
                this.SumSRTTotals();
                this.ActualClaim.CSS_WS_Total_Amount_SRT__c = this.TotalAmountSRTAmount;
                this.ActualClaim.CSS_WS_Total_Amount_SRT_Hours__c = this.TotalAmountSRTHoursToPay;
                upsert this.ActualClaim;
            }
            return null;
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            return null;
        }
    }
    
    Public Void AssignSRTDescription(){
        this.SetDefaultValues();
        List<SRTtoSelect> SelectableSRT = this.GetSRTInfo();
        String ValDescription = '';
        String valStepId = '';
        Decimal valHours = 1.00, Quantity;
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        this.SelectedSRTValues = new List<String>();
        Boolean Founded = false;
        for(CreateNewSRT srt : this.SRTsList){
            this.SelectedSRTValues.add(srt.SRT.CSS_WS_SRT__c);
        }
        this.CheckRepeatedSRT();
        if(this.ActualClaim.CSS_WS_HasError__c == 0){
            for(CreateNewSRT srt : this.SRTsList){
                if(srt.Index == this.SRTToUpdate && SelectableSRT != null) {
                    srt.SRT.CSS_WS_SRT__c = srt.SRT.CSS_WS_SRT__c.touppercase();//Uppercase to the SRT Code
                    for(SRTtoSelect rec : SelectableSRT){
                        if(rec.SRTCode == CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c)){
                            Founded = true; 
                            Quantity = (CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '00-117-00') ? 0 : srt.SRT.CSS_WS_Quantity__c;//Rule SF64
                            valDescription = rec.Description;
                            valStepId = rec.StepId;
                            valHours = rec.Hours;
                            System.debug(Founded);
                            break;
                        }
                    }
                    if(Founded == true || CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '99-999-00'){
                        if(CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '99-999-00'){//SF18
                            srt.SRT.CSS_WS_Quantity__c = 0;
                            srt.SRT.CSS_WS_Description__c = '';
                            srt.SRT.CSS_WS_GSQ_Assignment__c = '';
                            srt.SRT.CSS_WS_Hours__c = 0;
                            srt.SRT.CSS_WS_OutOfChassis__c = false;
                            srt.SRT.CSS_WS_Access_Code__c = this.ActualClaim.CSS_WS_Access_Code__c;
                        } else {
                            srt.SRT.CSS_WS_Quantity__c = Quantity;
                            srt.SRT.CSS_WS_Description__c = valDescription;
                            srt.SRT.CSS_WS_Step_Id__c = valStepId;
                            srt.SRT.CSS_WS_GSQ_Assignment__c = '';
                            srt.SRT.CSS_WS_Hours__c = valHours;
                            srt.SRT.CSS_WS_OutOfChassis__c = false;
                            srt.SRT.CSS_WS_Access_Code__c = this.ActualClaim.CSS_WS_Access_Code__c;
                        }
                    } else{
                        srt.SRT.CSS_WS_SRT__c = '';
                        srt.SRT.CSS_WS_Quantity__c = 0;
                        srt.SRT.CSS_WS_Description__c = null;
                        srt.SRT.CSS_WS_GSQ_Assignment__c = '';
                        srt.SRT.CSS_WS_Hours__c = 0;
                        srt.SRT.CSS_WS_OutOfChassis__c = false;
                        srt.SRT.CSS_WS_Access_Code__c = '';
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_SRTGrid_E003 + ' ' + srt.SRT.CSS_WS_SRT__c + ' ' + Label.CSS_WS_SRTGrid_E004));
                        srt.SRT.CSS_WS_SRT__c = '';
                        this.GetSRTOverlapInfo();
                        this.SumSRTTotals();
                    }
                    break;
                }
            }            
            this.GetSRTOverlapInfo();
            this.SumSRTTotals();
        }
    }
    
    Public List<SRTtoSelect> GetSRTInfo(){
        try{//SRT data 
            CSS_WS_Warranty__c TemClaim = [SELECT CSS_WS_Service_Model__c, CSS_WS_Engine_Family_Code__c, CSS_WS_Access_Code__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id LIMIT 1];
            List<String> SRTData = new String[3];
            SRTData[0] = (!String.isEmpty(TemClaim.CSS_WS_Service_Model__c)) ? TemClaim.CSS_WS_Service_Model__c : '';  
            SRTData[1] = (!String.isEmpty(TemClaim.CSS_WS_Engine_Family_Code__c)) ? TemClaim.CSS_WS_Engine_Family_Code__c : '';  
            SRTData[2] = (!String.isEmpty(TemClaim.CSS_WS_Access_Code__c)) ? TemClaim.CSS_WS_Access_Code__c : ''; 
            List<String> SRTDataR = new String[3];
            SRTDataR[0] = (!String.isEmpty(TemClaim.CSS_WS_Service_Model__c)) ? TemClaim.CSS_WS_Service_Model__c : '';
            SRTDataR[1] = (!String.isEmpty(TemClaim.CSS_WS_Engine_Family_Code__c)) ? TemClaim.CSS_WS_Engine_Family_Code__c : '';
            SRTDataR[2] = 'R';
            String JSONValues;
            List<SRTtoSelect> SelectableSRT = new List<SRTtoSelect>();
            CSS_WS_J2A_GetSRTData response = CSS_WS_GetWebServiceData.getSRTData(SRTData);//Rule SF33
            CSS_WS_J2A_GetSRTData responseR = CSS_WS_GetWebServiceData.getSRTData(SRTDataR);
            if(response == NULL && responseR == NULL){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Global_E001));//Unexpected error, please contact your System Administrator
                return SelectableSRT;
            } else if(response.Header.Status.touppercase() == 'SUCCESS' && response.DataArea != null && responseR.Header.Status.touppercase() == 'SUCCESS' && responseR.DataArea != null){
                Map<String, Decimal> hoursRTem = new Map<String, Decimal>{};//Add the reponse to a Map
                for(integer i = 0; i < responseR.DataArea.Details.size(); i++){
                    if(responseR.DataArea.Details[i].HrsUnit != null){
                        Decimal HrsUnit = Decimal.valueOf(responseR.DataArea.Details[i].HrsUnit);//(String.isEmpty(responseR.DataArea.Details[i].HrsUnit)) ? 0 : Decimal.valueOf(responseR.DataArea.Details[i].HrsUnit);
                        if(HrsUnit >= 0){
                            hoursRTem.put(responseR.DataArea.Details[i].SrtCode, HrsUnit);
                        }
                    }   
                }
                SRTtoSelect SRTOption;
                /*if(this.IsCampaign == true && this.SRTsFromCampaign.size() > 0){
                    for(Integer i=0; i < this.SRTsFromCampaign.size(); i++){
                        for(Integer j = 0; j < response.DataArea.Details.size(); j++){
                            if(response.DataArea.Details[j].HrsUnit != null){
                                Decimal HoursUnit = Decimal.valueOf(response.DataArea.Details[j].HrsUnit);//(String.isEmpty(response.DataArea.Details[j].HrsUnit)) ? 0 : Decimal.valueOf(response.DataArea.Details[j].HrsUnit);
                                if((CSS_WS_SRTGridController.getLongSRTCode(this.SRTsFromCampaign[i].CSS_WS_SRT__c) == response.DataArea.Details[j].SRTCode && HoursUnit >= 0) || (CSS_WS_SRTGridController.getLongSRTCode(this.SRTsFromCampaign[i].CSS_WS_SRT__c) == '99-999-00') ){
                                    SRTOption = new SRTtoSelect(
                                        HoursUnit,
                                        this.SRTsFromCampaign[i].CSS_WS_Description__c == null ? '': this.SRTsFromCampaign[i].CSS_WS_Description__c,
                                        this.SRTsFromCampaign[i].CSS_WS_SRT__c  == null ? '': this.SRTsFromCampaign[i].CSS_WS_SRT__c,
                                        this.SRTsFromCampaign[i].CSS_WS_Access_Code__c  == null ? '': this.SRTsFromCampaign[i].CSS_WS_Access_Code__c,
                                        this.SRTsFromCampaign[i].CSS_WS_SRT__c == null ? 0: hoursRTem.get(this.SRTsFromCampaign[i].CSS_WS_SRT__c));
                                    SelectableSRT.add(SRTOption);
                                    //break;
                                }
                            }                            
                        }
                    }
                    return SelectableSRT;
                } else {*/
                    for(Integer i=0; i < response.DataArea.Details.size(); i++) {
                        if(response.DataArea.Details[i].HrsUnit != null){
                            Decimal HoursUnit = Decimal.valueOf(response.DataArea.Details[i].HrsUnit);//(String.isEmpty(response.DataArea.Details[i].HrsUnit)) ? 0 : Decimal.valueOf(response.DataArea.Details[i].HrsUnit);
                            if(HoursUnit >= 0 || (CSS_WS_SRTGridController.getLongSRTCode(this.SRTsFromCampaign[i].CSS_WS_SRT__c) == '99-999-00')){
                                SRTOption = new SRTtoSelect(
                                    HoursUnit,
                                    response.DataArea.Details[i].SRTDescription == null ? '': String.valueOf(response.DataArea.Details[i].SRTDescription),
                                    response.DataArea.Details[i].SRTCode == null ? '': String.valueOf(response.DataArea.Details[i].SRTCode),
                                    this.ActualClaim.CSS_WS_Access_Code__c == null ? '': this.ActualClaim.CSS_WS_Access_Code__c,
                                    response.DataArea.Details[i].StepId == null ? '': String.valueOf(response.DataArea.Details[i].StepId),  //AQUI
                                    '',  //GSQ
                                    response.DataArea.Details[i].SRTCode == null ? 0: hoursRTem.get(response.DataArea.Details[i].SRTCode)
                                );
                                SelectableSRT.add(SRTOption);
                            }
                        }
                    }
                    return SelectableSRT;
                //}
            } else if(response.Header.Status.touppercase() == 'ERROR'){
                this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                return SelectableSRT;
            }
            return SelectableSRT;
        } catch(exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            System.debug('Error in GetSRTInfo: ' + e.getMessage() + '\n In line: ' + e.getLineNumber());
            return new List<SRTtoSelect>();
        }
    }
    
    Public Void GetSRTOverlapInfo(){
        /*try{
            if(this.ActualClaim.CSS_WS_HasError__c == 0){
                string JSONValues;
                List<Map<String,String>> SRTs = new List<Map<String,String>>();
                for(CreateNewSRT SRT: this.SRTsList){
                    Map<String,String> srtData = new Map<String,String>{};
                    srtData.put('EngineFamilyCode',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
                    //srtData.put('SrtAccessCode',this.ActualClaim.CSS_WS_Access_Code__c);
                    srtData.put('SrtAccessCode',(SRT.SRT.CSS_WS_Access_Code__c != '')?String.valueOf(SRT.SRT.CSS_WS_Access_Code__c):this.ActualClaim.CSS_WS_Access_Code__c);
                    srtData.put('SrtCode',CSS_WS_SRTGridController.getLongSRTCode(SRT.SRT.CSS_WS_SRT__c));
                    srtData.put('SrtHours',(SRT.SRT.CSS_WS_Hours__c != null)?String.valueOf(SRT.SRT.CSS_WS_Hours__c ):'0');
                    srtData.put('SrtQty',(SRT.SRT.CSS_WS_Quantity__c != null)?String.valueOf(SRT.SRT.CSS_WS_Quantity__c):'0');
                    SRTs.add(srtData);
                }
                CSS_WS_J2A_GetSRTOverlap response = CSS_WS_GetWebServiceData.getSRTOverlap(SRTs);
                if(response == NULL ){
                    this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                } else if(response.Header.Status.touppercase() == 'SUCCESS'){
                    for(Integer i=0; i < this.SRTsList.size(); i++){
                        for(Integer j = 0; j < response.DataArea.Details.size(); j++){//Rule SF83
                            if(response.DataArea.Details[j].SrtCode == CSS_WS_SRTGridController.getLongSRTCode(this.SRTsList[i].SRT.CSS_WS_SRT__c)){
                                this.SRTsList[i].SRT.CSS_WS_Access_Code__c = (String.IsEmpty(this.SRTsList[i].SRT.CSS_WS_Access_Code__c)) ? response.DataArea.Details[j].SrtAccessCode : this.SRTsList[i].SRT.CSS_WS_Access_Code__c;
                                this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c = (!String.IsEmpty(response.DataArea.Details[j].OverlapHours)) ? Decimal.valueOf(response.DataArea.Details[j].OverlapHours) : 0;
                                //this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c = (this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c != null && this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c > 0) ? this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c : Decimal.valueOf(response.DataArea.Details[j].OverlapHours);
                                break;
                            }
                        }
                    }
                } else if(response.Header.Status.touppercase() == 'ERROR'){
                    this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                }   
            }
        } catch(exception e) {
            system.debug(e.getMessage());
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
        }*/
        
        // Using new SRT_OVERLAP WebService
        try{
            if(this.ActualClaim.CSS_WS_HasError__c == 0){
                string JSONValues;
                String claim_number = String.ValueOf(this.ActualClaim.CSS_WS_Claim_Number__c);
                List<Map<String,String>> SRTs = new List<Map<String,String>>();
                for(CreateNewSRT SRT: this.SRTsList){
                    Map<String,String> srtData = new Map<String,String>{};
                    srtData.put('StepId',SRT.SRT.CSS_WS_Step_Id__c);
                    srtData.put('AccessCode',(SRT.SRT.CSS_WS_Access_Code__c != '')?String.valueOf(SRT.SRT.CSS_WS_Access_Code__c):this.ActualClaim.CSS_WS_Access_Code__c);
                    srtData.put('Qty',(SRT.SRT.CSS_WS_Quantity__c != null)?String.valueOf(SRT.SRT.CSS_WS_Quantity__c):'0');
                    SRTs.add(srtData);
                }
                
                // Verify if just one SRT is in the list, if it is the Overlap Callout is not performed and the overlap value is assigned as "0"
                if(SRTs.size() <= 1){
                    if(SRTs.size() == 1){
                        this.SRTsList[0].SRT.CSS_WS_Overlap_Hours__c = 0;
                    }
                } else {
                    // if SRT's list contains more than 1 SRT the callout is performed
                    CSS_WS_J2A_GetSRTOverlap2 response = CSS_WS_GetWebServiceData.getSRTOverlap2(claim_number, SRTs);
                    if(response == NULL ){
                        this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                    } else if (response.Header.MessageIdentifier != null){
                        if(response.Header.MessageIdentifier.touppercase() == 'S'){
                            Decimal srt_hours = 0;
                            Decimal srt_adj_hours = 0;
                            Decimal srt_qty = 0;
                            Decimal srt_overlap = 0;
                            for(Integer i=0; i < this.SRTsList.size(); i++){
                                for(Integer j = 0; j < response.DataArea.Steps.size(); j++){//Rule SF83
                                    if(response.DataArea.Steps[j].StepId == this.SRTsList[i].SRT.CSS_WS_Step_Id__c){
                                        this.SRTsList[i].SRT.CSS_WS_Access_Code__c = (String.IsEmpty(this.SRTsList[i].SRT.CSS_WS_Access_Code__c)) ? response.DataArea.Steps[j].AccessCode : this.SRTsList[i].SRT.CSS_WS_Access_Code__c;
                                        srt_hours = (!String.IsEmpty(response.DataArea.Steps[j].SRTHours)) ? Decimal.valueOf(response.DataArea.Steps[j].SRTHours) : 0;
                                        srt_adj_hours = (!String.IsEmpty(response.DataArea.Steps[j].SRTAdjustedHours)) ? Decimal.valueOf(response.DataArea.Steps[j].SRTAdjustedHours) : 0;
                                        srt_qty = (!String.IsEmpty(response.DataArea.Steps[j].Qty)) ? Decimal.valueOf(response.DataArea.Steps[j].Qty) : 0;
                                        srt_overlap = ((srt_qty * srt_hours) - srt_adj_hours) / srt_qty;
                                        this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c = (srt_overlap < 0) ? 0.0 : srt_overlap;                                             
                                        break;
                                    }
                                }
                            }
                        } else if(response.Header.MessageIdentifier.touppercase() == 'E'){
                            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                        }
                    } else if (response.Header.Status != null){
                        if(response.Header.Status.touppercase() == 'ERROR'){
                            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                        }
                    }   
                }
            }
        } catch(exception e) {
            system.debug(e.getMessage());
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
        } 
    }
    
    Public Void SumSRTTotals(){
        this.TotalAmountSRTHours = 0;
        this.TotalAmountSRTHoursExtended = 0;
        this.TotalAmountSRTHoursToPay = 0;
        this.TotalAmountSRTAmount = 0;
        Integer HoursWithZeroValue = 0;
        this.CalculateExtendedHours();
        for(CreateNewSRT SRT: this.SRTsList){
            if(SRT.SRT.CSS_WS_Hours__c == null){//Rule SF79
                this.DisplayErrorHandler(Label.CSS_WS_SRTGrid_E005);//SRT Hours are required
                break;
            }
            if(SRT.SRT.CSS_WS_Hours__c != null && SRT.SRT.CSS_WS_Hours__c > 0)
                this.TotalAmountSRTHours += SRT.SRT.CSS_WS_Hours__c;
            if(SRT.SRT.CSS_WS_Extended_Hours__c!= null && SRT.SRT.CSS_WS_Extended_Hours__c> 0)
                this.TotalAmountSRTHoursExtended += SRT.SRT.CSS_WS_Extended_Hours__c;
            if(SRT.SRT.CSS_WS_Actual_Hours__c!= null && SRT.SRT.CSS_WS_Actual_Hours__c> 0)
                this.TotalAmountSRTHoursToPay += SRT.SRT.CSS_WS_Actual_Hours__c;
            if(SRT.SRT.CSS_WS_Amount__c!= null && SRT.SRT.CSS_WS_Amount__c> 0)
                this.TotalAmountSRTAmount += SRT.SRT.CSS_WS_Amount__c;
            
        }
    }
    
    Public Void CalculateExtendedHours(){
        try{
            Decimal Hours, ExtendedHours, ActualHours, Amount, Quantity, OverlapHours, InShopLaborRate;
            String lr = this.ActualClaim.CSS_WS_RescueNumber__c != null ? this.ActualClaim.CSS_WS_Labor_Rate__c : this.ActualClaim.CSS_WS_In_shop_Labor_Rate__c;
            Decimal Labor = !String.isEmpty(lr) ? Decimal.valueof(lr).setScale(2) : 0;
            for(Integer i=0; i < this.SRTsList.size(); i++){//Rule SF29 and SF83
                Hours = this.SRTsList[i].SRT.CSS_WS_Hours__c != null ? this.SRTsList[i].SRT.CSS_WS_Hours__c: 0;
                Quantity = this.SRTsList[i].SRT.CSS_WS_Quantity__c != null ? this.SRTsList[i].SRT.CSS_WS_Quantity__c: 0;
                OverlapHours = this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c != null ? this.SRTsList[i].SRT.CSS_WS_Overlap_Hours__c: 0;
                ExtendedHours = (Quantity * Hours);
                ActualHours = 1 * (Hours - OverlapHours) * Quantity;
                ActualHours = (ActualHours < 0) ? ActualHours * -1 : ActualHours;
                //Amount = ActualHours * InShopLaborRate;
                Amount = (ActualHours * Labor * Hours_Percentage)/100;
                this.SRTsList[i].SRT.CSS_WS_Extended_Hours__c = ExtendedHours;
                this.SRTsList[i].SRT.CSS_WS_Actual_Hours__c = ActualHours;
                this.SRTsList[i].SRT.CSS_WS_Amount__c = Amount.setScale(2);
            }
        } catch(Exception e){
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
        }       
    }
    
    Public Void CheckRepeatedSRT(){
        Integer SRTSize = this.SelectedSRTValues.size();
        Integer RepeatedCounter = 0;
        for(Integer i = 0; i < SRTSize; i++){
            for(Integer j = 0; j < SRTSize; j++){
                if(i != j){
                    if(CSS_WS_SRTGridController.getLongSRTCode(this.SelectedSRTValues[i]) == CSS_WS_SRTGridController.getLongSRTCode(this.SelectedSRTValues[j]) && CSS_WS_SRTGridController.getLongSRTCode(this.SelectedSRTValues[i]) != '99-999-00'){//Rule SF19 and SF18
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_SRTGrid_E006));//Duplicate SRT entry is not allowed. Please fill in quantity > 1 in case SRT is required multiple times
                        break;
                    }
                }
            }
        }
    }
    
    Public Void CheckOutOfChassis(){
        List<SRTtoSelect> SelectableSRT = this.GetSRTInfo();
        String AccessCode;
        Decimal Hours;
        Boolean Found = false;
        for(CreateNewSRT srt : this.SRTsList){
            if(srt.Index == this.SRTToUpdate){
                for(SRTtoSelect rec : SelectableSRT){
                    if(rec.SRTCode == CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c ) ||  CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) == '99-999-00'){
                        Found = true;
                        AccessCode = (srt.SRT.CSS_WS_OutOfChassis__c == true) ? 'R' : this.ActualClaim.CSS_WS_Access_Code__c;//Rule SF82 and SF84
                        if(AccessCode == 'R'){
                            Hours = rec.HoursR; 
                        } else {
                            Hours = rec.Hours;
                        }                      
                        break;
                    }
                }
                if(Found == true){
                    srt.SRT.CSS_WS_Access_Code__c =  AccessCode;
                    if(CSS_WS_SRTGridController.getLongSRTCode(srt.SRT.CSS_WS_SRT__c) != '99-999-00'){
                        srt.SRT.CSS_WS_Hours__c = Hours;
                    }
                    //if (load_srt_not_overlap){ // Dec10th2020. Flag for not consuming srtoverlap in load saved srt data
                        this.GetSRTOverlapInfo();
                    //}
                    this.SumSRTTotals();
                }
                break;
            }
        }
    }
    
    Public void SRCallODMWebService(){
        this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c = true;
        //system.debug('Flag de ODM ' + this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c);
        if(this.ActualClaim.CSS_WS_Policy_Flag__c != 'Policy WW'){
            try{            
                //Query fields not available in the frontend
                CSS_WS_Warranty__c claimData = [
                    SELECT CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Build_Date__c, CSS_WS_Engine_Family_Code__c, CSS_WS_Marine_Application_Flag__c, CSS_WS_Product_Application_Code__c, CSS_WS_SP_Region__c, CSS_WS_SP_Channel_Of_Distribution__c, CSS_WS_SP_Territory__c, CSS_WS_Total_Labor__c,
                    CSS_Authorization_Number__c, CSS_WS_Approval_Code__c, CSS_WS_Towing_Amount__c, CSS_WS_Account_Code_Type__c, CSS_WS_Product_Application_Description__c, CSS_WS_Pay_Code__c, CSS_WS_InShopCampaignFlag__c
                    FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
                Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.ActualClaim.CSS_WS_Service_Provider_DR__c , this.ActualClaim.CSS_WS_Service_Provider_Dealer__c); 
                
                //Header
                Map<String, String> ODMRequestBodyHeader = new Map<String,String>{};                               
                ODMRequestBodyHeader.put('bisFlag',(this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
                ODMRequestBodyHeader.put('cmiEngineSerialNumber',this.ActualClaim.CSS_WS_Engine_Serial_Number__c);
                ODMRequestBodyHeader.put('cmiServiceProviderCode',this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
                ODMRequestBodyHeader.put('engineFamily',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
                ODMRequestBodyHeader.put('failureDate',CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                ODMRequestBodyHeader.put('failureMeasure',this.ActualClaim.CSS_WS_Failure_Measure__c);
                ODMRequestBodyHeader.put('failurePoint',this.ActualClaim.CSS_WS_Failure_Point_Quantity__c);
                ODMRequestBodyHeader.put('manualAdjudicationFlag','');
                ODMRequestBodyHeader.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                ODMRequestBodyHeader.put('productApplicationCode',claimData.CSS_WS_Product_Application_Code__c);
                ODMRequestBodyHeader.put('roNumber',this.ActualClaim.CSS_WS_Repair_Work_Order_Number__c);
                ODMRequestBodyHeader.put('serviceModelName',this.ActualClaim.CSS_WS_Service_Model__c);
                ODMRequestBodyHeader.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
                ODMRequestBodyHeader.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
                ODMRequestBodyHeader.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c);
                ODMRequestBodyHeader.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
                ODMRequestBodyHeader.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
                ODMRequestBodyHeader.put('outfileAllClaimsFlag','Y');
                ODMRequestBodyHeader.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
                ODMRequestBodyHeader.put('engineFamilyCode',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
                ODMRequestBodyHeader.put('marineFlag',(claimData.CSS_WS_Marine_Application_Flag__c!=null)?claimData.CSS_WS_Marine_Application_Flag__c:'');
                ODMRequestBodyHeader.put('buildDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Build_Date__c, 'MM/dd/yyyy'));
                ODMRequestBodyHeader.put('etoConversionDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Engine_Trade_Out_conversion_date__c, 'MM/dd/yyyy'));
                ODMRequestBodyHeader.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c == true)? 'Y' : 'N');
                ODMRequestBodyHeader.put('productApplicationDesp',(claimData.CSS_WS_Product_Application_Description__c!=null)?claimData.CSS_WS_Product_Application_Description__c:'');
                if(this.ActualClaim.CSS_WS_Account_Code__c == '61'){
                    ODMRequestBodyHeader.put('reconPartsWarrantyFlag','N');
                    ODMRequestBodyHeader.put('newPartsWarrantyFlag','N');
                    ODMRequestBodyHeader.put('roadRelayWarrantyFlag','N');
                } else {
                    ODMRequestBodyHeader.put('reconPartsWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N');
                    ODMRequestBodyHeader.put('newPartsWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Nuevo') ? 'Y' : 'N');
                    ODMRequestBodyHeader.put('roadRelayWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
                }
                ODMRequestBodyHeader.put('engineApplicationCode',this.ActualClaim.CSS_WS_Engine_Application_Code__c);
                
                // failure section
                List<CSS_WS_Failure__c> fail = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c, CSS_WS_FailureModeCode__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :this.ActualClaim.Id ];  
            
                List<Map<String, String>> failure = new List<Map<String, String>> ();
                for(CSS_WS_Failure__c cont_fail: fail){
                    Map<String, String> failureData = new Map<String,String>{};
                    failureData.put('campaignId',(String.isEmpty(this.ActualClaim.CSS_WS_Campaigns_TRPs__c)) ? '' : this.ActualClaim.CSS_WS_Campaigns_TRPs__c);    
                    failureData.put('payCode',claimData.CSS_WS_Pay_Code__c);
                    failureData.put('totalLaborAmt','');
                    failureData.put('authorizationNumber',(this.ActualClaim.CSS_Authorization_Number__c!= NULL)?String.valueOf(this.ActualClaim.CSS_Authorization_Number__c):'');
                    failureData.put('approvalCode',(claimData.CSS_WS_Approval_Code__c!=null)?claimData.CSS_WS_Approval_Code__c:'');
                    failureData.put('totalTowingAmt','');
                    failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c);
                    failureData.put('failCode',cont_fail.CSS_WS_EngineSystemCode__c + cont_fail.CSS_WS_ComponentCode__c);
                    failureData.put('coverageType',claimData.CSS_WS_Account_Code_Type__c);
                    failureData.put('failMode',cont_fail.CSS_WS_FailureModeCode__c);
                    failureData.put('accountCodeType',claimData.CSS_WS_Account_Code_Type__c);
                    failureData.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                    failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c); 
                    failureData.put('inShopCampaignFlag',(claimData.CSS_WS_InShopCampaignFlag__c != null) ? claimData.CSS_WS_InShopCampaignFlag__c : 'N');  
                    failure.add(failureData);
                }
                                
                /*for(CSS_WS_Warranty_SRT__c SRT_values: this.ListToInsert){//SRT
                    List<Map<String, String>> srt = new List<Map<String, String>> ();     
                    Map<String, String> srtData = new Map<String, String>{};
                    srtData.put('description',SRT_values.CSS_WS_Description__c);
                    srtData.put('hours',String.valueOf(SRT_values.CSS_WS_Hours__c));
                    srtData.put('offsiteCheck',(SRT_values.CSS_WS_Offsite__c == true) ? 'Y' : 'N');
                    srtData.put('quantity',String.valueOf(SRT_values.CSS_WS_Quantity__c));
                    srtData.put('code',CSS_WS_SRTGridController.getLongSRTCode(SRT_values.CSS_WS_SRT__c));
                    srt.add(srtData);*/
                    
                for(CreateNewSRT SRT_ODM: this.SRTsList){//SRT
                    List<Map<String, String>> srt = new List<Map<String, String>> ();     
                    Map<String, String> srtData = new Map<String, String>{};
                    srtData.put('description',SRT_ODM.SRT.CSS_WS_Description__c);
                    srtData.put('hours',String.valueOf(SRT_ODM.SRT.CSS_WS_Hours__c));
                    srtData.put('offsiteCheck',(SRT_ODM.SRT.CSS_WS_Offsite__c == true) ? 'Y' : 'N');
                    srtData.put('quantity',String.valueOf(SRT_ODM.SRT.CSS_WS_Quantity__c));
                    srtData.put('code',CSS_WS_SRTGridController.getLongSRTCode(SRT_ODM.SRT.CSS_WS_SRT__c));
                    srt.add(srtData);
                    
                    CSS_WS_J2A_ODM_Validation ODMResponse = CSS_WS_GetWebServiceData.getODMValidationSRT(ODMRequestBodyHeader, failure, srt);

                    if(ODMResponse == null){
                        this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                        this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c = false;
                        break;
                    } else if(ODMResponse.Response.claim.status.toUpperCase() == 'ERROR') {
                        for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ODMResponse.Response.claim.messages[i].description + '. "' + SRT_ODM.SRT.CSS_WS_SRT__c + '"'));
                            this.DisplayErrorHandler(ODMResponse.Response.claim.messages[i].description + '. "' + SRT_ODM.SRT.CSS_WS_SRT__c + '"');//
                            this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c = false;
                            break;                                                                                  
                        }                        
                    } else if(ODMResponse.Response.claim.status.toUpperCase() == 'WARNING'){
                        for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                            if(ODMResponse.Response.claim.messages[i].code == 'ODM-SR-WAR-119'){
                                this.DisplayErrorHandler(ODMResponse.Response.claim.messages[i].description + '. "' + SRT_ODM.SRT.CSS_WS_SRT__c + '"');
                                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ODMResponse.Response.claim.messages[i].description));
                                this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c = false;
                                break;  
                            } else {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, ODMResponse.Response.claim.messages[i].description));
                            }                            
                        }
                    } 
                }
            } catch(Exception e){
                system.debug(e.getMessage());
                this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator  
                this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c = false; 
            }
        }
        //system.debug(this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c);
    }
    
    Public Void DisplayErrorHandler(String MsgError){
        this.ActualClaim.CSS_WS_HasError__c = 1;
        this.ActualClaim.CSS_WS_HasMessage__c = MsgError != null ? MsgError: '';
    }
    
    Public Static String getLongSRTCode(String SRTCode){
        if(SRTCode != null){
            if(SRTCode.length() == 6){
                SRTCode += '-00';            
            }
        }
        return SRTCode;
    }
  
    Public Void Rule1108(){//Rule 1108
        /*if(this.ActualClaim.CSS_WS_ECM_Calibration_After__c != null && this.ActualClaim.CSS_WS_ECM_Calibration_Before__c != null){
            if(this.ActualClaim.CSS_WS_ECM_Calibration_After__c <= this.ActualClaim.CSS_WS_ECM_Calibration_Before__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_SRTGrid_E007));//ECM Calibration After must be greater than ECM Calibration Before
            }
        }*/
    }
    
    //#######################
    
    Public Void LoadGSQSRTEdition() {
        this.SRTListTem = new List<GSQSRTCaseResponse>();
        this.SetDefaultValues();
        if (this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c == '1 - Consumed with proper response' && this.GSQSRTResponseMap.size() > 0 && This.Labor_Rate > 0){
            for(String key_fail_srt : this.GSQSRTResponseMap.keySet()) {
                CSS_WS_J2A_GetGSQSRT GSQSRTResponse = new CSS_WS_J2A_GetGSQSRT();
                GSQSRTResponse = this.GSQSRTResponseMap.get(key_fail_srt);
                if(GSQSRTResponse != null){
                    if(GSQSRTResponse.Header != null){
                        if(GSQSRTResponse.Header.Status.touppercase() == 'SUCCESS'){                
                            if(GSQSRTResponse.DataArea != null){
                                if(GSQSRTResponse.DataArea.CaseResponse != null){
                                    for(integer i=0; i< GSQSRTResponse.DataArea.CaseResponse.size(); i++) {      
                                        if(GSQSRTResponse.DataArea.CaseResponse[i].Assignment.touppercase() != 'UNLISTED' && GSQSRTResponse.DataArea.CaseResponse[i].Assignment.touppercase() != 'NOT CLAIMABLE' && GSQSRTResponse.DataArea.CaseResponse[i].Assignment.touppercase() != 'NOT APPLICABLE' && GSQSRTResponse.DataArea.CaseResponse[i].Assignment.touppercase() != 'PRIMARY'){
                                            GSQSRTCaseResponse gsq_srt_reponse_item = new GSQSRTCaseResponse();
                                            gsq_srt_reponse_item.SRTAccessCode = GSQSRTResponse.DataArea.CaseResponse[i].SRTAccessCode;
                                            gsq_srt_reponse_item.SRTTitle = GSQSRTResponse.DataArea.CaseResponse[i].SRTTitle;
                                            gsq_srt_reponse_item.SRTTime = GSQSRTResponse.DataArea.CaseResponse[i].SRTTime;
                                            gsq_srt_reponse_item.SRTQuantity = GSQSRTResponse.DataArea.CaseResponse[i].SRTQuantity;
                                            gsq_srt_reponse_item.SRTDetails = GSQSRTResponse.DataArea.CaseResponse[i].SRTDetails;
                                            gsq_srt_reponse_item.VerifyRepeatValue.Step.StepID = GSQSRTResponse.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepID;  
                                            gsq_srt_reponse_item.Assignment = GSQSRTResponse.DataArea.CaseResponse[i].Assignment;   
                                            this.SRTListTem.add(gsq_srt_reponse_item); 
                                        }                                                           
                                    }         
                                }
                            }             
                        }
                    }
                }
            }            
            if(SRTListTem.size() > 0){
                system.debug('Lista total: ' + SRTListTem.size());
                integer j = 0;
                while (j < this.SRTListTem.size()) { 
                    boolean srt_found = false;
                    integer duplicated_srt = 0;
                    integer k = 0;
                    while (k < this.SRTListTem.size()){
                        if(this.SRTListTem[j].SRTDetails.touppercase() == this.SRTListTem[k].SRTDetails.touppercase()){
                            duplicated_srt++;
                        }
                        if(duplicated_srt > 1 && srt_found == false){
                            this.Access_Code = (this.SRTListTem[j].SRTAccessCode != null) ? this.SRTListTem[j].SRTAccessCode : this.Access_Code;
                            this.Description = (this.SRTListTem[j].SRTTitle != null) ? this.SRTListTem[j].SRTTitle : this.Description;
                            this.Hours = (this.SRTListTem[j].SRTTime != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTTime) : this.Hours;
                            Decimal quantity_j = (this.SRTListTem[j].SRTQuantity != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTQuantity) : 0; 
                            Decimal quantity_k = (this.SRTListTem[k].SRTQuantity != null) ? Decimal.ValueOf(this.SRTListTem[k].SRTQuantity) : 0;
                            this.SRTCode = (this.SRTListTem[j].SRTDetails != null) ? this.SRTListTem[j].SRTDetails.touppercase() : this.SRTCode;
                            this.StepId = (this.SRTListTem[j].VerifyRepeatValue.Step.StepID != null) ? this.SRTListTem[j].VerifyRepeatValue.Step.StepID : this.StepId;  
                            String GSQAssignment_j = (this.SRTListTem[j].Assignment != null) ? this.SRTListTem[j].Assignment : '';
                            String GSQAssignment_k = (this.SRTListTem[k].Assignment != null) ? this.SRTListTem[k].Assignment : '';
                            
                            if (GSQAssignment_j.touppercase() == 'ALTERNATIVE' && GSQAssignment_k.touppercase() == 'ALTERNATIVE'){
                                this.GSQAssignment = 'ALTERNATIVE';
                                this.Quantity = (quantity_j > quantity_k)? quantity_j : quantity_k; 
                            } else if (GSQAssignment_j.touppercase() == 'ALTERNATIVE' && GSQAssignment_k.touppercase() != 'ALTERNATIVE'){
                                this.GSQAssignment = 'ALTERNATIVE';
                                this.Quantity = quantity_j; 
                            } else if (GSQAssignment_j.touppercase() != 'ALTERNATIVE' && GSQAssignment_k.touppercase() == 'ALTERNATIVE'){
                                this.GSQAssignment = 'ALTERNATIVE';
                                this.Quantity = quantity_k; 
                            } else {
                                this.GSQAssignment = GSQAssignment_j.touppercase();
                                this.Quantity = quantity_j; 
                            }         
                            this.AddNewGSQ();
                            this.GSQEnabled = true;                            
                            srt_found = true;                
                            this.SRTListTem.remove(k);
                            k--;
                        } else if (duplicated_srt > 2){
                            this.SRTListTem.remove(k);
                            break;
                        }
                        k++;
                    }
                    if(!srt_found){
                        this.Access_Code = (this.SRTListTem[j].SRTAccessCode != null) ? this.SRTListTem[j].SRTAccessCode : this.Access_Code;
                        this.Description = (this.SRTListTem[j].SRTTitle != null) ? this.SRTListTem[j].SRTTitle : this.Description;
                        this.Hours = (this.SRTListTem[j].SRTTime != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTTime) : this.Hours;
                        this.Quantity = (this.SRTListTem[j].SRTQuantity != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTQuantity) : this.Quantity; 
                        this.SRTCode = (this.SRTListTem[j].SRTDetails != null) ? this.SRTListTem[j].SRTDetails.touppercase() : this.SRTCode;
                        this.StepId = (this.SRTListTem[j].VerifyRepeatValue.Step.StepID != null) ? this.SRTListTem[j].VerifyRepeatValue.Step.StepID : this.StepId;  
                        this.GSQAssignment = (this.SRTListTem[j].Assignment != null) ? this.SRTListTem[j].Assignment : this.GSQAssignment;
                        this.AddNewGSQ();
                        this.GSQEnabled = true;
                    }  
                    j++;                 
                }
            }
        }       
    }  
    
    Public Void AddNewGSQ(){
        try{
            CreateNewSRT SRT = new CreateNewSRT(
                This.SRTCounter ++,
                This.SelectedGSQ,
                This.Adjust_Percentage,
                This.Access_Code,
                This.Actual_Hours,
                This.Amount,
                This.Description,
                This.Extended_Hours,
                This.Hours,
                This.Hours_Percentage,
                This.Labor_Rate,
                This.Offsite,
                This.OutOfChassis,
                This.Overlap_Hours,
                This.Quantity,
                This.Requested_Amount,
                This.SRTCode,
                This.Total,
                This.StepId,  //AQUI
                This.GSQAssignment,  //GSQ
                this.ActualClaim.Id
            );
            this.GSQsList.add(SRT);
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
        }
    }
    
    Public Void enableDisabledSelectAll(){
        if(this.GSQsList != null){
            // to select or unselect the checkbox for each GSQ item
            for(Integer tem = 0; tem < this.GSQsList.size(); tem++){
                if(SelectAll){
                    this.GSQsList[tem].SelectedGSQ = true;
                } else {
                    this.GSQsList[tem].SelectedGSQ = false;
                }
            }
            // to enable or disable the Add Selected SRTs button
            if(SelectAll){
                this.ButtonAddAll = true;
            } else {
                this.ButtonAddAll = false;
            }
        }
    } 
       
    Public Void CheckSelected(){
        Integer check = 0;
        Integer i;
        if(this.GSQsList.size() > 0){
            for(i = 0; i < this.GSQsList.size(); i++){
                if(this.GSQsList[i].SelectedGSQ){
                    check = check + 1;
                }
            }
        }
        // to select or unselect the SelectAll checkbox
        if(this.GSQsList.size() == check){
            SelectAll = true;
        } else {
            SelectAll = false;
        }
        // to enable or disable the Add Selected SRTs button
        if(check == 0){
            this.ButtonAddAll = false;
        } else {
            this.ButtonAddAll = true;
        }
    }
    
    Public Void AddGSQSRT(){
        Integer SRTPosToAdd = -1;
        Integer i;
        Integer ListSize = this.GSQsList.size();
        Boolean duplicated_GSQSRT = false;
        // to find GSQ item to add
        for(i = 0; i < ListSize; i++){
            if(this.GSQsList[i].Index == this.SRTToAdd){
                SRTPosToAdd = i;
            }
        }
        // check if this GSQ item was added previously
        for(i = 0; i < this.SRTsList.size(); i++){
            if(CSS_WS_SRTGridController.getLongSRTCode(this.SRTsList[i].SRT.CSS_WS_SRT__c) == CSS_WS_SRTGridController.getLongSRTCode(this.GSQsList[SRTPosToAdd].SRT.CSS_WS_SRT__c)){
                duplicated_GSQSRT = true;
            }
        }
        if(SRTPosToAdd != -1 && duplicated_GSQSRT == false){
            this.SRTsList.add(this.GSQsList[SRTPosToAdd]);
            //this.AssignSRTDescription();  
            this.GetSRTOverlapInfo();
            this.SumSRTTotals();  
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_SRTGrid_E006));//Duplicate SRT entry is not allowed. Please fill in quantity > 1 in case SRT is required multiple times
        }
    }
    
    Public Void AddAllSelectedClaims(){
        Boolean duplicated_GSQSRT = false;
        // check if at least one of the selected GSQ items was added previously 
        integer i;
        integer j;       
        for(i = 0; i < this.GSQsList.size(); i++){
            for(j = 0; j < this.SRTsList.size(); j++){
                if(this.GSQsList[i].SelectedGSQ && CSS_WS_SRTGridController.getLongSRTCode(this.GSQsList[i].SRT.CSS_WS_SRT__c) == CSS_WS_SRTGridController.getLongSRTCode(this.SRTsList[j].SRT.CSS_WS_SRT__c)){
                    duplicated_GSQSRT = true;
                    break;
                }
            }
        }
        
        // Add all selected GSQ items 
        if(duplicated_GSQSRT == false){
            for(i = 0; i < this.GSQsList.size(); i++){
                if(this.GSQsList[i].SelectedGSQ){
                    this.SRTsList.add(this.GSQsList[i]);
                }
            }
            //this.AssignSRTDescription(); 
            this.GetSRTOverlapInfo();
            this.SumSRTTotals();
            this.SelectAll = false;
            enableDisabledSelectAll();   
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_SRTGrid_E006));//Duplicate SRT entry is not allowed. Please fill in quantity > 1 in case SRT is required multiple times
        }   
    }
    
    Public Void CallWSToGetGSQSRT(){
        Try{            
            List<CSS_WS_Failure__c> FailureData = [SELECT CSS_WS_Failure_ID__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c =: this.ActualClaim.Id AND CSS_WS_Failure_ID__c != '' LIMIT 3];
            this.GSQSRTResponseMap = New Map<String, CSS_WS_J2A_GetGSQSRT>();
            if (FailureData.size() > 0){
                Boolean gsq_flag = true;
                for(integer i = 0 ; i < FailureData.size() ; i++){
                    Map<String, String> GSQSRTRequest = new Map<String,String>{};
                    GSQSRTRequest.put('EngineFamilyCode',this.ActualClaim.CSS_WS_Engine_Family_Code__c); //EngineFamilyCode
                    GSQSRTRequest.put('SRTType','REP'); //SRTType
                    GSQSRTRequest.put('EquipmentID',this.ActualClaim.CSS_WS_Equipment_Code__c); //EquipmentID
                    GSQSRTRequest.put('FailureID',FailureData[i].CSS_WS_Failure_ID__c); //FailureID
                    GSQSRTRequest.put('ServiceModelName',this.ActualClaim.CSS_WS_Service_Model__c); //ServiceModelName
                    GSQSRTRequest.put('CSSJobId',this.ActualClaim.CSS_WS_Claim_Number__c); //CSSJobId
                    GSQSRTRequest.put('Timestamp',string.valueof(date.today()));
                    GSQSRTRequest.put('EffectiveDateTime',string.valueof(date.today()));
                     
                    CSS_WS_J2A_GetGSQSRT GSQSRTResponseLocal = CSS_WS_GetWebServiceData.getGSQSRT(GSQSRTRequest);
                    
                    //system.debug('respuesta #' + i + ' : ' + GSQSRTResponseLocal);
                    
                    this.GSQSRTResponseMap.put(FailureData[i].CSS_WS_Failure_ID__c, GSQSRTResponseLocal);
                    
                    if(gsq_flag){
                        if(GSQSRTResponseLocal == null){
                            this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c = '3 - Consumed with null response';
                        } else if(GSQSRTResponseLocal.Header != null){
                            if(GSQSRTResponseLocal.Header.Status.touppercase() == 'SUCCESS'){
                                this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c = '1 - Consumed with proper response';
                                gsq_flag = false;
                            } else if(GSQSRTResponseLocal.Header.Status.touppercase() == 'ERROR'){
                                this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c = '2 - Consumed with error response';
                            }
                        }
                    }
                }
                system.debug('Mapa: ' + this.GSQSRTResponseMap);
            } else {
                this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c = '5 - Failure with not FailureID value';
            }
        } catch(Exception e) {
            this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c = '4 - Consumed with exception';
            System.debug('Exception error trying to get GSQ SRT data: ' + e.getMessage());
        }
    }    
    
    Public Void LoadGSQSRT() {
        this.SRTListTem = new List<GSQSRTCaseResponse>();
        this.SetDefaultValues();
        if (this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c == '1 - Consumed with proper response' && this.GSQSRTResponseMap.size() > 0 && This.Labor_Rate > 0){
            for(String key_fail_srt : this.GSQSRTResponseMap.keySet()) {
                CSS_WS_J2A_GetGSQSRT GSQSRTResponse = new CSS_WS_J2A_GetGSQSRT();
                GSQSRTResponse = this.GSQSRTResponseMap.get(key_fail_srt);
                if(GSQSRTResponse != null){
                    if(GSQSRTResponse.Header != null){
                        if(GSQSRTResponse.Header.Status.touppercase() == 'SUCCESS'){                
                            if(GSQSRTResponse.DataArea != null){
                                if(GSQSRTResponse.DataArea.CaseResponse != null){
                                    for(integer i=0; i< GSQSRTResponse.DataArea.CaseResponse.size(); i++) {      
                                        if(GSQSRTResponse.DataArea.CaseResponse[i].Assignment.touppercase() != 'UNLISTED' && GSQSRTResponse.DataArea.CaseResponse[i].Assignment.touppercase() != 'NOT CLAIMABLE' && GSQSRTResponse.DataArea.CaseResponse[i].Assignment.touppercase() != 'NOT APPLICABLE'){
                                            GSQSRTCaseResponse gsq_srt_reponse_item = new GSQSRTCaseResponse();
                                            gsq_srt_reponse_item.SRTAccessCode = GSQSRTResponse.DataArea.CaseResponse[i].SRTAccessCode;
                                            gsq_srt_reponse_item.SRTTitle = GSQSRTResponse.DataArea.CaseResponse[i].SRTTitle;
                                            gsq_srt_reponse_item.SRTTime = GSQSRTResponse.DataArea.CaseResponse[i].SRTTime;
                                            gsq_srt_reponse_item.SRTQuantity = GSQSRTResponse.DataArea.CaseResponse[i].SRTQuantity;
                                            gsq_srt_reponse_item.SRTDetails = GSQSRTResponse.DataArea.CaseResponse[i].SRTDetails;
                                            gsq_srt_reponse_item.VerifyRepeatValue.Step.StepID = GSQSRTResponse.DataArea.CaseResponse[i].VerifyRepeatValue.Step.StepID;  
                                            gsq_srt_reponse_item.Assignment = GSQSRTResponse.DataArea.CaseResponse[i].Assignment;   
                                            this.SRTListTem.add(gsq_srt_reponse_item); 
                                        }                                                           
                                    }         
                                }
                            }             
                        }
                    }
                }
            }            
            if(SRTListTem.size() > 0){
                system.debug('Lista total: ' + SRTListTem.size());
                //for(integer j=0; j < this.SRTListTem.size(); j++) {
                integer j = 0;
                while (j < this.SRTListTem.size()) {
 
                    boolean srt_found = false;
                    integer duplicated_srt = 0;
                    integer k = 0;
                    while (k < this.SRTListTem.size()){
                    //for(integer k=0; k < this.SRTListTem.size(); k++) {
                        if(this.SRTListTem[j].SRTDetails.touppercase() == this.SRTListTem[k].SRTDetails.touppercase()){
                            duplicated_srt++;
                        }
                        if(duplicated_srt > 1 && srt_found == false){
                            this.Access_Code = (this.SRTListTem[j].SRTAccessCode != null) ? this.SRTListTem[j].SRTAccessCode : this.Access_Code;
                            this.Description = (this.SRTListTem[j].SRTTitle != null) ? this.SRTListTem[j].SRTTitle : this.Description;
                            this.Hours = (this.SRTListTem[j].SRTTime != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTTime) : this.Hours;
                            Decimal quantity_j = (this.SRTListTem[j].SRTQuantity != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTQuantity) : 0; 
                            Decimal quantity_k = (this.SRTListTem[k].SRTQuantity != null) ? Decimal.ValueOf(this.SRTListTem[k].SRTQuantity) : 0;
                            this.SRTCode = (this.SRTListTem[j].SRTDetails != null) ? this.SRTListTem[j].SRTDetails.touppercase() : this.SRTCode;
                            this.StepId = (this.SRTListTem[j].VerifyRepeatValue.Step.StepID != null) ? this.SRTListTem[j].VerifyRepeatValue.Step.StepID : this.StepId;  
                            String GSQAssignment_j = (this.SRTListTem[j].Assignment != null) ? this.SRTListTem[j].Assignment : '';
                            String GSQAssignment_k = (this.SRTListTem[k].Assignment != null) ? this.SRTListTem[k].Assignment : '';
                            
                            if(GSQAssignment_j.touppercase() == 'PRIMARY' && GSQAssignment_k.touppercase() == 'PRIMARY'){
                                this.GSQAssignment = 'PRIMARY';
                                this.Quantity = (quantity_j > quantity_k)? quantity_j : quantity_k; 
                            } else if (GSQAssignment_j.touppercase() == 'PRIMARY' && GSQAssignment_k.touppercase() != 'PRIMARY'){
                                this.GSQAssignment = 'PRIMARY';
                                this.Quantity = quantity_j; 
                            } else if (GSQAssignment_j.touppercase() != 'PRIMARY' && GSQAssignment_k.touppercase() == 'PRIMARY'){
                                this.GSQAssignment = 'PRIMARY';
                                this.Quantity = quantity_k; 
                            } else if (GSQAssignment_j.touppercase() == 'ALTERNATIVE' && GSQAssignment_k.touppercase() == 'ALTERNATIVE'){
                                this.GSQAssignment = 'ALTERNATIVE';
                                this.Quantity = (quantity_j > quantity_k)? quantity_j : quantity_k; 
                            } else if (GSQAssignment_j.touppercase() == 'ALTERNATIVE' && GSQAssignment_k.touppercase() != 'ALTERNATIVE'){
                                this.GSQAssignment = 'ALTERNATIVE';
                                this.Quantity = quantity_j; 
                            } else if (GSQAssignment_j.touppercase() != 'ALTERNATIVE' && GSQAssignment_k.touppercase() == 'ALTERNATIVE'){
                                this.GSQAssignment = 'ALTERNATIVE';
                                this.Quantity = quantity_k; 
                            } else {
                                this.GSQAssignment = GSQAssignment_j.touppercase();
                                this.Quantity = quantity_j; 
                            }                           
                            
                            //this.AddNewSRT(); 
                            if(this.GSQAssignment == 'PRIMARY'){
                                this.AddNewSRT();
                            } else {
                                this.AddNewGSQ();
                                this.GSQEnabled = true;
                            }      
                            
                            srt_found = true;                
                            this.SRTListTem.remove(k);
                            k--;
                        } else if (duplicated_srt > 2){
                            this.SRTListTem.remove(k);
                            break;
                        }
                        //system.debug('valor de k: ' + k);
                        //system.debug('valore del listado al momento: ' + SRTListTem.size());
                        k++;
                    }
                    if(!srt_found){
                        this.Access_Code = (this.SRTListTem[j].SRTAccessCode != null) ? this.SRTListTem[j].SRTAccessCode : this.Access_Code;
                        this.Description = (this.SRTListTem[j].SRTTitle != null) ? this.SRTListTem[j].SRTTitle : this.Description;
                        this.Hours = (this.SRTListTem[j].SRTTime != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTTime) : this.Hours;
                        this.Quantity = (this.SRTListTem[j].SRTQuantity != null) ? Decimal.ValueOf(this.SRTListTem[j].SRTQuantity) : this.Quantity; 
                        this.SRTCode = (this.SRTListTem[j].SRTDetails != null) ? this.SRTListTem[j].SRTDetails.touppercase() : this.SRTCode;
                        this.StepId = (this.SRTListTem[j].VerifyRepeatValue.Step.StepID != null) ? this.SRTListTem[j].VerifyRepeatValue.Step.StepID : this.StepId;  
                        this.GSQAssignment = (this.SRTListTem[j].Assignment != null) ? this.SRTListTem[j].Assignment : this.GSQAssignment;
                        
                        if(this.GSQAssignment == 'PRIMARY'){
                            this.AddNewSRT();
                        } else {
                            this.AddNewGSQ();
                            this.GSQEnabled = true;
                        } 
                        //this.AddNewSRT(); 
                    }  
                    //system.debug('valor de j: ' + j);
                    //system.debug('valor del listado al momento: ' + SRTListTem.size()); 
                    j++;                 
                }
                /*if(this.GSQsList.size() > 0){
                    this.GSQsList.sort();
                }
                if(this.SRTsList.size() > 0){
                    this.SRTsList.sort();
                }*/
            }
            this.AssignSRTDescription(); 
            this.SetDefaultValues();
            this.savedGSQSRTData = false;
        }       
    }   
    
    public class GSQSRTCaseResponse { // to construct the object to collect all GSQ SRT responses
        public String SRTDetails;
        public String SRTAccessCode;
        public String Assignment;
        public String SRTTime;
        public String SRTQuantity;
        public String SRTTitle;
        public VerifyRepeatValue VerifyRepeatValue = New VerifyRepeatValue();
    }

    public class Step {
        public String StepID;
    }

    public class VerifyRepeatValue {
        public Step Step = New Step();
    } // End here the construction of object for GSQ SRT response
    
    
    Public Void GSQSRTData(){
        if(this.ActualClaim.CSS_WS_Account_Code__c != 'P89'){
            this.savedGSQSRTData = true;
            system.debug('GSQSRTData - flag for savedGSQSRTData: ' + this.savedGSQSRTData);
            if(this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c == '0 - Not consumed'){
                this.CallWSToGetGSQSRT();
            }
            if(this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c == '1 - Consumed with proper response' && this.GSQSRTResponseMap != null && this.SRTListTem == null){
                this.LoadGSQSRT();
            } else if(this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c != '0 - Not consumed' && this.GSQSRTResponseMap == null){
                this.CallWSToGetGSQSRT();
                this.LoadGSQSRTEdition();
            }
        }
    }
    
    Public Void SaveGSQSRTData(){
        if(this.ActualClaim.CSS_WS_Account_Code__c != 'P89'){
            system.debug('SaveGSQSRTData - flag for savedGSQSRTData - before: ' + this.savedGSQSRTData);
            if(this.ActualClaim.CSS_WS_GSQ_SRT_Flag__c == '1 - Consumed with proper response' && this.GSQSRTResponseMap != null && this.SRTListTem != null && !this.savedGSQSRTData){
                //this.SaveSRTGrids();
                this.ListToInsert = new List<CSS_WS_Warranty_SRT__c>();
                this.SelectedSRTValues = new List<String>();
                for(CreateNewSRT srt : this.SRTsList){
                    if(!String.isEmpty(srt.SRT.CSS_WS_SRT__c)){
                        srt.SRT.Id = null;
                        this.ListToInsert.add(srt.SRT);
                        this.SelectedSRTValues.add(srt.SRT.CSS_WS_SRT__c); 
                    }
                } 
                List<CSS_WS_Warranty_SRT__c> ListToDelete = [SELECT Id FROM CSS_WS_Warranty_SRT__c WHERE CSS_WS_WarrantyID__c = : this.ActualClaim.Id];
                delete ListToDelete;
                if(ListToInsert.size() > 0){
                    this.ActualClaim.CSS_WS_Total_Amount_SRT__c = this.TotalAmountSRTAmount;//Rule SF76
                    this.ActualClaim.CSS_WS_Total_Amount_SRT_Hours__c = this.TotalAmountSRTHoursToPay;
                    upsert this.ActualClaim;
                    insert ListToInsert;
                } 
                            
                this.savedGSQSRTData = true;
                system.debug('SaveGSQSRTData - flag for savedGSQSRTData - after: ' + this.savedGSQSRTData);
            }
        } 
    }

}