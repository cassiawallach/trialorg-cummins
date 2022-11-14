Public Class CSS_WS_Narrative{
    
    Public CSS_WS_Warranty__c ActualClaim { get; set; }
    Public List<SelectOption> PromotionIDsList { get; set; }
    //Public List<SelectOption> promotionIds { get; set; }
    Public CSS_WS_J2A_GetSPData SPDataResponse { get; set; }
    
    Public CSS_WS_Narrative(ApexPages.StandardController stdController) {
        System.debug('Inicio CSS_WS_Narrative ****** CSS_WS_Narrative');
        this.ActualClaim = (CSS_WS_Warranty__c)stdController.getRecord();
        Decimal IsClaimCloned = 0;
        if(this.ActualClaim.id != null){
            IsClaimCloned = [SELECT Is_Clone__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id].Is_Clone__c;
        }
        if(this.ActualClaim.id != null && IsClaimCloned != 1){
            this.getPromotionIDs();
        }   
    }
    
    Public PageReference validateNarrative(){
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        if(this.ActualClaim.CSS_WS_Claim_Narrative__c == null || this.ActualClaim.CSS_WS_Claim_Narrative__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Narrative_E001);//Narrative should not be empty
        }
        if(this.ActualClaim.CSS_WS_Promotion_ID__c == null || this.ActualClaim.CSS_WS_Promotion_ID__c == ''){
            this.DisplayAsincErrorHandler(Label.CSS_WS_Selection_Technician);//Please Select a Technician
        }
        return null;
    }

    Public void getPromotionIDs(){//Rule SF69
        List<SelectOption> promotionIds = new List<SelectOption>();
        List<String> SPData = new List<String>();
        String FailureDate = '';
        promotionIds.add(new SelectOption('',Label.CSS_WS_Selection_Technician));
        promotionIds.add(new SelectOption('No Promotion Id', 'No Promotion Id'));
        SPData.add(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
        SPData.add(this.ActualClaim.CSS_WS_Service_Model__c);
        SPData.add(CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Failure_Date_Time__c, 'dd-MMM-yy'));
        try{
            SPDataResponse = CSS_WS_GetWebServiceData.getSPData(SPData);
            if(SPDataResponse != null){
                if(SPDataResponse.Header.Status.touppercase()=='SUCCESS'){
                    if(SPDataResponse.DataArea != null){
                        if( SPDataResponse.DataArea.Details != null){
                            for(integer i=0; i< SPDataResponse.DataArea.Details.size(); i++) {
                                if(SPDataResponse.DataArea.Details[i].PromotionId != null && SPDataResponse.DataArea.Details[i].LastName != null){
                                    String PromotionId = SPDataResponse.DataArea.Details[i].PromotionId;
                                    String FistName = (SPDataResponse.DataArea.Details[i].FirstName !=null)?SPDataResponse.DataArea.Details[i].FirstName:'' ;
                                    String LastName = (SPDataResponse.DataArea.Details[i].LastName !=null)?SPDataResponse.DataArea.Details[i].LastName:'';
                                    promotionIds.add(new SelectOption(PromotionId, FistName + ' ' + LastName));
                                 }
                            }
                        }
                    }             
                } else {
                    this.DisplayAsincErrorHandler(SPDataResponse.Header.ReturnCodeDescription);
                }
            } else {
                this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact Your System Administrator
            }
        } catch(Exception e) {
            this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact Your System Administrator
            system.debug('Error: '+e.getMessage());
        }
        this.PromotionIDsList = promotionIds;
    }
    
    Public void saveNarratives(){
        if(this.ActualClaim.CSS_WS_Promotion_ID__c != 'No Promotion Id'){
            if(SPDataResponse.DataArea != null){
                if( SPDataResponse.DataArea.Details != null){        
                    for(integer i=0; i< SPDataResponse.DataArea.Details.size(); i++) {
                        if(SPDataResponse.DataArea.Details[i].PromotionId != null && SPDataResponse.DataArea.Details[i].LastName != null){
                            if(SPDataResponse.DataArea.Details[i].PromotionId == this.ActualClaim.CSS_WS_Promotion_ID__c){
                                String FistName = (SPDataResponse.DataArea.Details[i].FirstName !=null)?SPDataResponse.DataArea.Details[i].FirstName:'' ;
                                String LastName = (SPDataResponse.DataArea.Details[i].LastName !=null)?SPDataResponse.DataArea.Details[i].LastName:'';
                                this.ActualClaim.CSS_WS_Technician_Name__c = FistName + ' ' + LastName;
                            }
                        }
                    }
                }
            }
        } else {
            this.ActualClaim.CSS_WS_Technician_Name__c = 'No Promotion Id';
        }
    }
    
    Public void DisplayAsincErrorHandler(String MsgError){
        this.ActualClaim.CSS_WS_HasError__c = 1;
        this.ActualClaim.CSS_WS_HasMessage__c = MsgError;
    }
}