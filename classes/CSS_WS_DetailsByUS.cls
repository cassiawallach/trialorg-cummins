Public Class CSS_WS_DetailsByUS implements Queueable{
    
    //Public CSS_WS_DetailsByUS tem { get; set;}
    Public Id claim { get; set;}
    
    Public Void CSS_WS_DetailsByUS(Id ClaimID){
        claim = ClaimID; 
    }    
    //<<-- New section to allow executing asynchronous jobs
    Public Void execute(QueueableContext context) {
        callFutureMethod(claim);
    }  
    
    @Future(callout=true)
    Public Static Void callFutureMethod(Id claim){
        detailsByUS(claim);
        CSS_WS_PartsGridUSDetailsController jobUSDetailsParts = new CSS_WS_PartsGridUSDetailsController();
        jobUSDetailsParts.claim = claim;
        if(Test.isRunningTest() != true){    
            System.enqueueJob(jobUSDetailsParts);
        }
    }
    //-->> 
    /*Public Void execute(QueueableContext context){
        detailsByUS(claim);
        CSS_WS_PartsGridUSDetailsController jobUSDetailsParts = new CSS_WS_PartsGridUSDetailsController();
        jobUSDetailsParts.claim = claim;
        if(Test.isRunningTest() != true){    
            System.enqueueJob(jobUSDetailsParts);
        }
    }*/
 
    Public Static Void detailsByUS(Id ClaimID){        
        CSS_WS_Warranty__c currentClaim = [SELECT 
            Name,
            CSS_WS_IMS_Claim_Number__c,
            CSS_WS_US_Travel_Adjustment_Reason__c,
            CSS_WS_US_Travel_Type__c,
            CSS_WS_US_Details_Status__c
        FROM CSS_WS_Warranty__c WHERE CSS_WS_Warranty__c.id =: ClaimID];            
        System.debug('Claim to get details: '+currentClaim);
        try{
            Map<String, String> Data = new Map<String,String>{};
            Data.put('IMSClaimNumber',currentClaim.CSS_WS_IMS_Claim_Number__c); //IMSClaimNumber
            Data.put('ClaimNumber',currentClaim.Name); //ClaimNumber
            
            CSS_WS_J2A_GetCSSDetails css_details = CSS_WS_GetWebServiceData.getCSSDetails(Data);
            if(css_details != null){
                if(css_details.Header.Status.touppercase()=='SUCCESS') {
                    if(css_details.DataArea != null){//Getting data for Travel section
                        Integer total;
                        if(css_details.DataArea.DetailTravels != null){
                            currentClaim.CSS_WS_US_Travel_Adjustment_Reason__c = css_details.DataArea.DetailTravels[0].AdjustmentReason;
                            currentClaim.CSS_WS_US_Travel_Type__c = css_details.DataArea.DetailTravels[0].TravelType;
                        }
                        if(css_details.DataArea.DetailOtherClaimables != null){//Getting data for Other Claimable section
                            total = css_details.DataArea.DetailOtherClaimables.size();
                            List<CSS_WS_US_Details__c> OC_Details =  new List<CSS_WS_US_Details__c>();
                            for(Integer i = 0; i < total; i++){
                                CSS_WS_US_Details__c OC =  new CSS_WS_US_Details__c();
                                OC.CSS_WS_OC_Adjustment_Reason__c = css_details.DataArea.DetailOtherClaimables[i].AdjustmentReason;
                                OC.CSS_WS_OC_Approved_Amount__c = !String.isEmpty(css_details.DataArea.DetailOtherClaimables[i].ApprovedAmount) ?  decimal.valueOf(css_details.DataArea.DetailOtherClaimables[i].ApprovedAmount): 0;
                                OC.CSS_WS_Description__c = css_details.DataArea.DetailOtherClaimables[i].Description;
                                OC.CSS_WS_Type_Section__c = 'Other Claimables';
                                OC.CSS_WS_Claim__c = currentClaim.Id;
                                OC_Details.add(OC);                          
                            }
                            system.debug('Lista de OC: '+OC_Details);
                            insert OC_Details;                          
                        }
                        if(css_details.DataArea.DetailSRTs != null){//Getting data for SRT section
                            total = css_details.DataArea.DetailSRTs.size();
                            List<CSS_WS_US_Details__c> SRT_Details =  new List<CSS_WS_US_Details__c>();
                            for(Integer i = 0; i < total; i++){
                                CSS_WS_US_Details__c SRT =  new CSS_WS_US_Details__c();
                                SRT.CSS_WS_SRT_Code__c = css_details.DataArea.DetailSRTs[i].SRTCode;
                                SRT.CSS_WS_SRT_Hours__c = !String.isEmpty(css_details.DataArea.DetailSRTs[i].SRTHours) ?  decimal.valueOf(css_details.DataArea.DetailSRTs[i].SRTHours): 0;
                                SRT.CSS_WS_Quantity__c = !String.isEmpty(css_details.DataArea.DetailSRTs[i].SRTQty) ?  decimal.valueOf(css_details.DataArea.DetailSRTs[i].SRTQty): 0;
                                SRT.CSS_WS_SRT_Access_Code__c = css_details.DataArea.DetailSRTs[i].AccessCode;
                                SRT.CSS_WS_SRT_Adjustment_Percentage__c = !String.isEmpty(css_details.DataArea.DetailSRTs[i].PercentageAdjustment) ?  decimal.valueOf(css_details.DataArea.DetailSRTs[i].PercentageAdjustment): 0;
                                SRT.CSS_WS_SRT_Adjustment_Reason__c = css_details.DataArea.DetailSRTs[i].AdjustmentReason;
                                SRT.CSS_WS_Type_Section__c = 'SRTs';
                                SRT.CSS_WS_Claim__c = currentClaim.Id;
                                SRT_Details.add(SRT);                           
                            }
                            system.debug('Lista de SRT: '+SRT_Details);
                            insert SRT_Details;                                         
                        }                       
                        if(css_details.DataArea.DetailParts != null){//Getting data for Parts section
                            total = css_details.DataArea.DetailParts.size();
                            List<CSS_WS_US_Details__c> Part_Details =  new List<CSS_WS_US_Details__c>();
                            for(Integer i = 0; i < total; i++){
                                CSS_WS_US_Details__c Part =  new CSS_WS_US_Details__c();
                                Part.CSS_WS_Part_Number__c = css_details.DataArea.DetailParts[i].PartNumber;
                                Part.CSS_WS_Quantity__c = !String.isEmpty(css_details.DataArea.DetailParts[i].PartQty) ?  decimal.valueOf(css_details.DataArea.DetailParts[i].PartQty): 0;
                                Part.CSS_WS_Part_Adjustment_Reason__c = css_details.DataArea.DetailParts[i].AdjustmentReason;
                                Part.CSS_WS_Part_Adjustment_Percentage__c = !String.isEmpty(css_details.DataArea.DetailParts[i].AdjustmentPartsPercent) ?  decimal.valueOf(css_details.DataArea.DetailParts[i].AdjustmentPartsPercent): 0;
                                Part.CSS_WS_Type_Section__c = 'Parts';
                                Part.CSS_WS_Claim__c = currentClaim.Id;
                                Part_Details.add(Part);                              
                            }
                            system.debug('Lista de Partes: '+Part_Details);
                            insert Part_Details;                                            
                        }
                    }
                    currentClaim.CSS_WS_US_Details_Status__c = 'Success Response'; // + css_details.Header.ReturnCodeDescription;  
                    System.debug('CSS Details webservice is responding with SUCCESS status: ' + css_details.Header.ReturnCodeDescription);
                } else {
                    currentClaim.CSS_WS_US_Details_Status__c = 'Error Response'; // + css_details.Header.ReturnCodeDescription;
                    System.debug('CSS Details webservice is responding with ERROR status: ' + css_details.Header.ReturnCodeDescription);
                }
            } else {
                currentClaim.CSS_WS_US_Details_Status__c = 'Error Retrieving US Details';
                system.debug('CSS Details webservice is not responding');
            }
        } catch(System.Exception e){
            currentClaim.CSS_WS_US_Details_Status__c = 'Error Retrieving US Details';
            System.debug('Error getting CSS Details (exception): '+e.getMessage());
        }
        currentClaim.CSS_WS_Claim_Status__c = 'Getting US Details in Progress';
        update(currentClaim);
        //CSS_WS_PartsGridUSDetailsController.callMethod(ClaimID);
    }
}