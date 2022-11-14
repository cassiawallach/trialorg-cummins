Public Class CSS_WS_PartsGridUSDetailsController implements Queueable{
    
    Public Account SPPreferencesDist { get; set;}
    Public Account SPPreferencesDlr { get; set;}
    Public Id claim { get; set;}
 
    Public Void CSS_WS_PartsGridUSDetailsController(Id ClaimID){
        claim = ClaimID;
    }
    
    Public Void execute(QueueableContext context) {
        callFutureMethod(claim);
    }  
    
    @Future(callout=true)
    Public Static Void callFutureMethod(Id claim){
        CSS_WS_PartsGridUSDetailsController tem = new CSS_WS_PartsGridUSDetailsController();
        tem.getPartUSDetailsInfo(claim);
    }
    
    Public Void getPartUSDetailsInfo(Id claimtem){
        List<CSS_WS_Warranty__c> claimTempo = [SELECT CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Dealer__c, CSS_WS_Claim_Number__c, CSS_WS_Warranty_Subtype__c, 
            CSS_WS_Failure_Date_Time__c, CSS_WS_Engine_Application_Code__c, CSS_WS_Claim_Type__c, CSS_WS_Engine_Family_Code__c, CSS_WS_Engine_Serial_Number__c, 
            CSS_WS_Service_Model__c, CSS_WS_Repair_Work_Order_Number__c, CSS_WS_Multi_ESN__c, CSS_WS_Failure_Point_Quantity__c, CSS_WS_Campaigns_TRPs__c,
            CSS_Authorization_Number__c, CSS_WS_Account_Code__c, CSS_WS_Pay_Code__c, CSS_WS_Failure_Measure__c, CSS_WS_Warranty_Start_Date__c, CSS_WS_US_Details_Status__c,
            CSS_WS_Total_Amount_Other_Claimables__c, CSS_WS_Total_Amount_Part__c, CSS_WS_Total_Amount_SRT__c, CSS_WS_Total_Amount_Travel__c,
            CSS_WS_Total_Travel__c, CSS_WS_Total_Parts__c, CSS_WS_Total_Labor__c, CSS_WS_Total_Other__c, CSS_WS_Policy_Flag__c,
            CSS_WS_Total_Parts_Approved__c, CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_Total_Claim_Approved__c,
            CSS_WS_Factory_Payment_Date__c, CSS_WS_Parts_Mark_Up__c, CSS_WS_Beyond_Factory_Charges__c FROM CSS_WS_Warranty__c WHERE id =: claimtem];
        CSS_WS_Warranty__c claim = claimTempo[0];
        
        //Validation for sucess message for getCSSDDetails webservice
        //if we get a success response, then the claim continues its process, otherwise the claim is blocked with Error status
        if (claim.CSS_WS_US_Details_Status__c != 'Success Response'){
            claim.CSS_WS_Claim_Status__c = 'Error in US Details'; 
            update claim;           
        } else {        
            SPPreferencesDist = CSS_WS_ControllerClaim.getSelectedSPAccount(claim.CSS_WS_Service_Provider_DR__c , claim.CSS_WS_Service_Provider_DR__c);
            SPPreferencesDlr = CSS_WS_ControllerClaim.getSelectedSPAccount(claim.CSS_WS_Service_Provider_DR__c , claim.CSS_WS_Service_Provider_Dealer__c);  
            
            // Query to get all claimed parts for this claim
            List<CSS_WS_Warranty_Parts__c> partsWarrantylist = [SELECT CSS_WS_PartNumber__c, CSS_WS_Long_Part_Number_del__c, CSS_WS_Quantity__c, CSS_WS_Description__c, CSS_WS_Siebel_Unit_Part_Price__c, CSS_WS_Unit_Part_Price__c FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c =: claim.id];
            
            // Create a map with all Claimed Parts; the long part number is used as key
            Map<String, CSS_WS_Warranty_Parts__c> mappartsClaimed = new Map<String, CSS_WS_Warranty_Parts__c>();
            for(CSS_WS_Warranty_Parts__c tempartsClaimed: partsWarrantylist){
                mappartsClaimed.put(tempartsClaimed.CSS_WS_Long_Part_Number_del__c, tempartsClaimed);
            }
            // Get list of all Parts is paying US
            List<CSS_WS_US_Details__c> partsUSDetails = [SELECT CSS_WS_Part_Number__c, CSS_WS_Quantity__c, CSS_WS_Description__c, CSS_WS_Price__c, CSS_WS_Claimed_Price__c, CSS_WS_Siebel_Price__c, CSS_WS_Total_Price__c FROM CSS_WS_US_Details__c WHERE CSS_WS_Claim__c =: claim.id AND CSS_WS_Type_Section__c =: 'Parts'];
            
            if(partsUSDetails != null && partsUSDetails.size() >= 1){
                for(CSS_WS_US_Details__c actualPart: partsUSDetails){
                    // Verify if the Part is paying US match to one of the Claimed Parts
                    if(mappartsClaimed.containsKey(actualPart.CSS_WS_Part_Number__c)){
                        actualPart.CSS_WS_Claimed_Price__c = mappartsClaimed.get(actualPart.CSS_WS_Part_Number__c).CSS_WS_Unit_Part_Price__c.setScale(2);
                        actualPart.CSS_WS_Price__c = mappartsClaimed.get(actualPart.CSS_WS_Part_Number__c).CSS_WS_Unit_Part_Price__c.setScale(2);
                        System.debug('US Part matches to one of the Claimed Parts:  ' + mappartsClaimed.get(actualPart.CSS_WS_Part_Number__c).CSS_WS_Unit_Part_Price__c.setScale(2));
                                    
                    } else {
                        // If Part does not match to any claimed Part, then this is a new Part
                        // Verify if this part is in Promotion
                        CSS_WS_Parts_In_Promotion__c pProm = getPartInPromotion(actualPart.CSS_WS_Part_Number__c);
                        if(claim.CSS_WS_Service_Provider_DR__c == claim.CSS_WS_Service_Provider_Dealer__c){//When is Distributor
                            // to get the Part price from Promotion when is Distributor
                            if(pProm != null){
                                actualPart.CSS_WS_Price__c = pProm.DR_Price__c;  
                                system.debug('Part in promotion');
                            } else {
                                // If Part is not in promotion, the ODM callout is needed to get the siebel price for Distributor
                                CSS_WS_J2A_ODM_Validation odmRes = this.GetODMPartsInfo(claim.CSS_WS_Service_Provider_DR__c, SPPreferencesDist, claim, actualPart);
                                if(odmRes == null){
                                    System.debug('Response CSS_WS_J2A_ODM_Validation for US details is ' + odmRes);
                                } else {
                                    if(odmRes.Response.claim.status.touppercase()=='SUCCESS' || odmRes.Response.claim.status.touppercase()=='WARNING'){
                                        actualPart.CSS_WS_Siebel_Price__c = Decimal.valueOf(odmRes.Response.claim.parts.partPrice);    
                                        actualPart.CSS_WS_Price__c = Decimal.valueOf(odmRes.Response.claim.parts.partPrice); 
                                        actualPart.CSS_WS_Price__c = actualPart.CSS_WS_Price__c.setscale(2);
                                    } else {
                                        System.debug('Response GetODMPartsInfo for US details is ' + odmRes.Response.claim.messages[0].description);
                                    }
                                } 
                            }
                        } else {//When is Dealer
                            // to get the Part price from Promotion when is Dealer
                            if(pProm != null){
                                actualPart.CSS_WS_Price__c = pProm.DlR_Price__c;  
                                system.debug('Part in promotion');
                            } else {
                                // If Part is not in promotion, the ODM callout is needed to get the siebel price for Dealer
                                CSS_WS_J2A_ODM_Validation odmRes = this.GetODMPartsInfo(claim.CSS_WS_Service_Provider_Dealer__c, SPPreferencesDlr, claim, actualPart);
                                if(odmRes == null){
                                    System.debug('Response CSS_WS_J2A_ODM_Validation for US details is ' + odmRes);
                                } else {
                                    if(odmRes.Response.claim.status.touppercase()=='SUCCESS' || odmRes.Response.claim.status.touppercase()=='WARNING'){   
                                        actualPart.CSS_WS_Siebel_Price__c = Decimal.valueOf(odmRes.Response.claim.parts.partPrice);
                                        actualPart.CSS_WS_Price__c = Decimal.valueOf(odmRes.Response.claim.parts.partPrice);
                                        actualPart.CSS_WS_Price__c = actualPart.CSS_WS_Price__c.setscale(2);
                                    } else {
                                        System.debug('Response GetODMPartsInfo for US details is ' + odmRes.Response.claim.messages[0].description);
                                    }
                                } 
                            }
                        }
                    }
                }
                Upsert partsUSDetails;
            }
            Account SPAccount = [SELECT BillingCountry FROM Account WHERE IAM_Service_Provider_Code__c =: claim.CSS_WS_Service_Provider_Dealer__c AND
                                    CSS_DBCode__c =: claim.CSS_WS_Service_Provider_DR__c AND CMI_Account_Status__c = 'Active' ORDER BY Type LIMIT 1]; 
            if(SPAccount != null){
                if(SPAccount.BillingCountry.touppercase() == 'MEXICO' && claim.CSS_WS_Service_Provider_DR__c != '54734'){ 
                    //Get approved amounts
                    if (claim.CSS_WS_Policy_Flag__c == 'Warranty' || claim.CSS_WS_Policy_Flag__c == 'Policy WW'){ // For Warranty and PolicyWW claims
                        // Verify amount used for Parts (Paid by US)
                        if(claim.CSS_WS_Total_Amount_Part__c > 0){  
                            // New adjustment (January 9th 2010). Always the payment for parts will be the sum of Total_Parts, Parts_Mark_Up and Beyond_Factory_Charges.                            
                            Decimal Parts_Mark_Up          = !String.isEmpty(claim.CSS_WS_Parts_Mark_Up__c) ? decimal.valueof(claim.CSS_WS_Parts_Mark_Up__c) : 0;
                            Decimal Beyond_Factory_Charges = !String.isEmpty(claim.CSS_WS_Beyond_Factory_Charges__c) ? decimal.valueof(claim.CSS_WS_Beyond_Factory_Charges__c) : 0;
                            Decimal Parts = 0; 
                            if (claim.CSS_WS_Total_Parts__c != null){
                                Parts = claim.CSS_WS_Total_Parts__c.setscale(2);
                            }                                                                                   
                            Decimal Total_Parts = Parts_Mark_Up + Beyond_Factory_Charges + Parts;
                            claim.CSS_WS_Total_Parts_Approved__c = Total_Parts.setscale(2);  
                            // End new adjustment                        
                        } else {
                            claim.CSS_WS_Total_Parts_Approved__c = 0;
                        }
                        // Verify what amount to use for Labor (requested by user or approved by US)
                        if(claim.CSS_WS_Total_Amount_SRT__c > 0){
                            if(claim.CSS_WS_Total_Labor__c != null && claim.CSS_WS_Total_Amount_SRT__c > claim.CSS_WS_Total_Labor__c){                                
                                claim.CSS_WS_Total_Labor_Approved__c = claim.CSS_WS_Total_Labor__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Labor_Approved__c = claim.CSS_WS_Total_Amount_SRT__c.setscale(2);
                            }
                        } else {
                            claim.CSS_WS_Total_Labor_Approved__c = 0;
                        }
                        // Verify what amount to use for Other Claimables (requested by user or approved by US)    
                        if(claim.CSS_WS_Total_Amount_Other_Claimables__c > 0){
                            if (claim.CSS_WS_Total_Other__c != null && claim.CSS_WS_Total_Amount_Other_Claimables__c > claim.CSS_WS_Total_Other__c){
                                claim.CSS_WS_Total_Other_Approved__c = claim.CSS_WS_Total_Other__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Other_Approved__c = claim.CSS_WS_Total_Amount_Other_Claimables__c.setscale(2);
                            }
                        } else {
                            claim.CSS_WS_Total_Other_Approved__c = 0;
                        }
                        // Verify what amount to use for Travel (requested by user or approved by US), the rest will be requested by Rescue    
                        if(claim.CSS_WS_Total_Amount_Travel__c > 0){
                            if(claim.CSS_WS_Total_Travel__c != null && claim.CSS_WS_Total_Amount_Travel__c > claim.CSS_WS_Total_Travel__c){
                                claim.CSS_WS_Total_Travel_Approved__c = claim.CSS_WS_Total_Travel__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Travel_Approved__c = claim.CSS_WS_Total_Amount_Travel__c.setscale(2);
                            }
                        } else {
                            claim.CSS_WS_Total_Travel_Approved__c = 0;
                        }   
                        claim.CSS_WS_Total_Claim_Approved__c = claim.CSS_WS_Total_Parts_Approved__c + claim.CSS_WS_Total_Labor_Approved__c + claim.CSS_WS_Total_Other_Approved__c + claim.CSS_WS_Total_Travel_Approved__c;
                    }
                    //End process to get approved amounts
                    claim.CSS_WS_Claim_Status__c = 'Pending Planta Payment'; 
                } else if (claim.CSS_WS_Service_Provider_DR__c == '54734' || claim.CSS_WS_Policy_Flag__c == 'Policy WW'){ 
                    claim.CSS_WS_Claim_Status__c = 'Paid'; 
                } else { 
                    claim.CSS_WS_Factory_Payment_Date__c = System.Today();
                    claim.CSS_WS_Claim_Status__c = 'Pending DR Payment to DL'; 
                }
                update claim;
            }
        }
    }
    
    Public CSS_WS_Parts_In_Promotion__c getPartInPromotion(String partNumber){//Delete Static
        try {
            CSS_WS_Parts_In_Promotion__c part = [SELECT Id, Name, Long_Part_Number__c, Description__c, DLR_Price__c, DR_Price__c FROM CSS_WS_Parts_In_Promotion__c WHERE Long_Part_Number__c = :partNumber LIMIT 1];
            return part; 
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return null;
    }
        
    Public CSS_WS_J2A_ODM_Validation GetODMPartsInfo(String serviceProviderCode, Account SPPreferences, CSS_WS_Warranty__c claim, CSS_WS_US_Details__c actualPart){
        try{
            List<String> ODMRequestBodyHeader = new List<String>();
            Map<String, String> header = new Map<String,String>();  
            CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Pay_Code__c, CSS_WS_Product_Application_Code__c, CSS_WS_Product_Application_Description__c, CSS_WS_Marine_Application_Flag__c,
                CSS_WS_Build_Date__c, CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Approval_Code__c, CSS_WS_Account_Code_Type__c, CSS_WS_InShopCampaignFlag__c 
                FROM CSS_WS_Warranty__c WHERE Id =: claim.Id];//Query fields not available in the frontend
            
            header.put('bisFlag',(claim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
            header.put('cmiEngineSerialNumber',claim.CSS_WS_Engine_Serial_Number__c);
            header.put('cmiServiceProviderCode', serviceProviderCode);
            header.put('engineFamily',claim.CSS_WS_Engine_Family_Code__c);
            header.put('failureDate',CSS_WS_ControllerClaim.dateToString(claim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
            header.put('failureMeasure',claim.CSS_WS_Failure_Measure__c);
            header.put('failurePoint',claim.CSS_WS_Failure_Point_Quantity__c);
            header.put('manualAdjudicationFlag','');
            header.put('multiESNFlag',(claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
            header.put('productApplicationCode',claimData.CSS_WS_Product_Application_Code__c);
            header.put('roNumber',claim.CSS_WS_Repair_Work_Order_Number__c);
            header.put('serviceModelName',claim.CSS_WS_Service_Model__c);
            header.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(claim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
            header.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
            header.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c );
            header.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
            header.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
            header.put('outfileAllClaimsFlag','Y');
            header.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
            header.put('engineFamilyCode',claim.CSS_WS_Engine_Family_Code__c);
            header.put('marineFlag',(claimData.CSS_WS_Marine_Application_Flag__c!=null)?claimData.CSS_WS_Marine_Application_Flag__c:'');
            header.put('buildDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Build_Date__c, 'MM/dd/yyyy'));
            header.put('etoConversionDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Engine_Trade_Out_conversion_date__c, 'MM/dd/yyyy'));
            header.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c == true)? 'Y' : 'N');
            header.put('productApplicationDesp',(claimData.CSS_WS_Product_Application_Description__c!=null)?claimData.CSS_WS_Product_Application_Description__c:'');
            if(claim.CSS_WS_Account_Code__c == '61'){
                header.put('reconPartsWarrantyFlag','N');
                header.put('newPartsWarrantyFlag','N');
                header.put('roadRelayWarrantyFlag','N');
            } else {
                header.put('reconPartsWarrantyFlag',(claim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N');
                header.put('newPartsWarrantyFlag',(claim.CSS_WS_Claim_Type__c == 'Nuevo') ? 'Y' : 'N');
                header.put('roadRelayWarrantyFlag',(claim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
            }
            header.put('engineApplicationCode',claim.CSS_WS_Engine_Application_Code__c);
        
            String ReconPartsFlag = (claim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N';
            List<CSS_WS_Failure__c> fail = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c, CSS_WS_FailureModeCode__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c =: claim.Id ];  
            
            List<Map<String, String>> failure = new List<Map<String, String>> ();
            for(CSS_WS_Failure__c cont_fail: fail){
                Map<String, String> failureData = new Map<String,String>{};
                failureData.put('campaignId',(String.isEmpty(claim.CSS_WS_Campaigns_TRPs__c)) ? '' : claim.CSS_WS_Campaigns_TRPs__c);    
                failureData.put('payCode',claimdata.CSS_WS_Pay_Code__c);
                failureData.put('totalLaborAmt','');
                failureData.put('authorizationNumber',(claim.CSS_Authorization_Number__c!= NULL)?String.valueOf(claim.CSS_Authorization_Number__c):'');
                failureData.put('approvalCode',(claimData.CSS_WS_Approval_Code__c!=null)?claimData.CSS_WS_Approval_Code__c:'');
                failureData.put('totalTowingAmt','');
                failureData.put('accountCode',claim.CSS_WS_Account_Code__c);
                failureData.put('failCode',cont_fail.CSS_WS_EngineSystemCode__c + cont_fail.CSS_WS_ComponentCode__c);
                failureData.put('coverageType',claimdata.CSS_WS_Account_Code_Type__c);
                failureData.put('failMode',cont_fail.CSS_WS_FailureModeCode__c);
                failureData.put('accountCodeType',claimdata.CSS_WS_Account_Code_Type__c);
                failureData.put('multiESNFlag',(claim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                failureData.put('accountCode',claim.CSS_WS_Account_Code__c);
                failureData.put('inShopCampaignFlag',(claimData.CSS_WS_InShopCampaignFlag__c != null) ? claim.CSS_WS_InShopCampaignFlag__c : 'N'); 
                failure.add(failureData);
            }
            
            List<Map<String, String>> PARTS = new List<Map<String, String>>();
            Map<String, String> partList = new Map<String, String>();
            partList.put('reconPartFlag', ReconPartsFlag); 
            partList.put('partName', ''); //actualPart.CSS_WS_Description__c);  
            partList.put('lineNumber', '1');   
            partList.put('partId', actualPart.CSS_WS_Part_Number__c); 
            partList.put('priceBook', ' ');
            
            Integer FailurePoint = Integer.valueof(claim.CSS_WS_Failure_Point_Quantity__c);
            Integer ClaimAllowedDays = Integer.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c); 
            List<List<String>>ODMRequest = new List <List<String>>();
            List<String> partL = new List<String>();
            List<Decimal>partPrice = new Decimal[2];
            partPrice [0] = 0;
            PARTS.add(partList);
            partPrice.add(0);
            
            CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationParts(header, failure, parts);
            return obj;
        } catch(Exception ex) {
            System.debug(ex.getMessage());
            return null;
        }
        return null;
    }
}