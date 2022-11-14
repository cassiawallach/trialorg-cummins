Public Class CSS_WS_RSW_US_Async{

    @future(callout = true)   
    Public Static Void claimSubmissionWSCallout(Id ClaimID){        
        CSS_WS_Warranty__c currentClaim = [SELECT 
            CSS_Authorization_Number__c,
            CSS_WS_Approval_Code__c,
            CSS_WS_Account_Code__c,
            CSS_WS_Account_Code_Type__c,
            CSS_WS_Authorized_Amount__c,
            CSS_WS_Campaign_Labor_Percentage__c,
            CSS_WS_Campaign_OC_Percentage__c,
            CSS_WS_Campaign_Parts_Percentage__c,
            CSS_WS_Campaign_Towing_Percentage__c,
            CSS_WS_Campaign_Travel_Percentage__c,
            CSS_WS_Campaigns_TRPs__c,
            CSS_WS_Catastrophic__c,
            CSS_WS_Certificate_Number__c,
            CSS_WS_Certificate_Number_Id__c,
            CSS_WS_Claim_Creation_Date__c,
            CSS_WS_Claim_Narrative__c,
            CSS_WS_Claim_Number__c,
            CSS_WS_Claim_Status__c,
            CSS_WS_Claim_Type__c,
            CSS_WS_Complaints1__c,
            CSS_WS_Complaints2__c,
            CSS_WS_Complaints3__c,
            CSS_WS_Covered_Labor_Hours__c,
            CSS_WS_Covered_Meals_Lodging__c,
            CSS_WS_Covered_OC_Amount__c,
            CSS_WS_Covered_Parts_Qty__c,
            CSS_WS_Covered_Towing_Miles__c,
            CSS_WS_Covered_Travel_Labor__c,
            CSS_WS_Covered_Travel_Miles__c,
            CSS_WS_Customer_Name_Internal__c,
            CSS_WS_Customer_Name__c,
            CSS_WS_Deductible_Amount__c,
            CSS_WS_DSID__c,
            CSS_WS_ECM_Calibration_After__c,
            CSS_WS_Revision_After__c,
            CSS_WS_ECM_Calibration_Before__c,
            CSS_WS_Revision_Before__c,
            CSS_WS_ECM_Calib_Justification__c,
            CSS_WS_Engine_Application_Code__c,
            CSS_WS_Engine_Serial_Number__c,
            CSS_WS_Error_US_Reason__c,
            CSS_WS_ESN_Count__c,
            CSS_WS_Failure_Date_Time__c,
            CSS_WS_Failure_Measure__c,
            CSS_WS_Failure_Point_Quantity__c,
            CSS_WS_In_shop_Labor_Rate__c,
            CSS_WS_Labor_Rate__c,
            CSS_WS_Labor_rate_penalty__c,
            CSS_WS_Lodging__c,
            CSS_WS_Manufacturer__c,
            CSS_WS_Mission_Disabling_Severity_Code__c,
            CSS_WS_Model_Series__c,
            CSS_WS_Multi_ESN__c,
            CSS_WS_Pay_Code__c,
            CSS_WS_Penalty_Flag__c,
            CSS_WS_Policy_Flag__c,
            CSS_WS_Promotion_ID__c,
            CSS_WS_Repair_Work_Order_Number__c,
            CSS_WS_Repair_Description__c,
            CSS_WS_Replacement_Part__c,
            CSS_WS_Requested_Amount__c,
            CSS_WS_RescueNumber__c,
            CSS_WS_Service_Provider_Dealer__c,
            CSS_WS_Service_Provider_DR__c,
            CSS_WS_Siebel_Claim_Number__c,
            CSS_WS_SP_Service_Model_Certified__c,
            //CSS_WS_SP_Warranty_Certified__c,
            CSS_WS_Travel_Detail_Mode__c,
            CSS_WS_Travel_Distance__c,
            CSS_WS_Travel_Hours__c,
            CSS_WS_Travel_Mode__c,
            CSS_WS_Travel_penalty__c,
            CSS_WS_Travel_Rate__c,
            CSS_WS_Travel_Type__c,
            CSS_WS_TSR_Number__c,
            CSS_WS_VIN__c,
            CSS_WS_Warranty_Start_Date__c,
            CSS_WS_Warranty_Subtype__c,
            CSS_WS_WarrantyId__c,
            CSS_WS_Manual_Adjudication_Flag__c,
            CSS_WS_Other_Approver__c,
            CSS_WS_Possession_Flag__c,
            CSS_WS_Total_Amount_Travel__c,
            CSS_WS_SRTPenaltyPercentage__c,
            CSS_WS_Towing_Amount__c,
            CSS_WS_Total_Amount_SRT_Hours__c,
            Other_Approver_Picklist_WW__c
        FROM CSS_WS_Warranty__c WHERE CSS_WS_Warranty__c.id =: ClaimID];            
        System.debug('Current Claim: '+currentClaim);
        try{
            Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(currentClaim.CSS_WS_Service_Provider_DR__c, currentClaim.CSS_WS_Service_Provider_Dealer__c);       
            Map<String, String> header = new Map<String,String>{};
            header.put('ServiceProviderCode',currentClaim.CSS_WS_Service_Provider_Dealer__c);
            header.put('DistributorCode',currentClaim.CSS_WS_Service_Provider_DR__c);
            header.put('EngineSerialNumber',currentClaim.CSS_WS_Engine_Serial_Number__c);
            header.put('RONumber',currentClaim.CSS_WS_Repair_Work_Order_Number__c);
            header.put('WarrantyStartDate',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
            header.put('EngineApplicationCode',currentClaim.CSS_WS_Engine_Application_Code__c);
            header.put('Manufacturer',currentClaim.CSS_WS_Manufacturer__c);
            header.put('ModelSeries',currentClaim.CSS_WS_Model_Series__c);
            header.put('FirstName','');
            header.put('LastName','');
            header.put('BISFlag',(currentClaim.CSS_WS_Warranty_Subtype__c == 'BIS')?'Y':'N');
            header.put('MultiESNFlg',(currentClaim.CSS_WS_Multi_ESN__c)?'Y':'N');
            header.put('CampaignNumber',(currentClaim.CSS_WS_Campaigns_TRPs__c!= null ?currentClaim.CSS_WS_Campaigns_TRPs__c:''));
            header.put('NewPartsWarrantyFlg',(currentClaim.CSS_WS_Claim_Type__c == 'Nuevo')?'Y':'N');
            header.put('ReConPartsWarrantyFlg',(currentClaim.CSS_WS_Claim_Type__c == 'Recon')?'Y':'N');
            header.put('RoadRelayWarrantyFlg',(currentClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio')?'Y':'N');
            header.put('FailureDate',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
            header.put('FailurePoint',currentClaim.CSS_WS_Failure_Point_Quantity__c);
            header.put('FailureMeasure',currentClaim.CSS_WS_Failure_Measure__c);
            header.put('MissionDisablingFlag',currentClaim.CSS_WS_Mission_Disabling_Severity_Code__c);
            header.put('CatastrophicFlag',(currentClaim.CSS_WS_Catastrophic__c == 'Si')?'Y':'N');
            String repairDescription = (currentClaim.CSS_WS_Repair_Description__c!=null)?((currentClaim.CSS_WS_Repair_Description__c.Length()>=199)?currentClaim.CSS_WS_Repair_Description__c.subString(0,199):currentClaim.CSS_WS_Repair_Description__c):'';
            header.put('RepairDescription',repairDescription.escapeJava());
            header.put('ReplacementPart',(currentClaim.CSS_WS_Replacement_Part__c!= null ?currentClaim.CSS_WS_Replacement_Part__c:''));
            header.put('WarrantyTrainedFlag',(SPPreferences.Warranty_Training_Certification__c)?'Y':'N');
            header.put('DISDNumber',(currentClaim.CSS_WS_DSID__c!= null ?currentClaim.CSS_WS_DSID__c:''));
            header.put('CustomerPossession',(currentClaim.CSS_WS_Possession_Flag__c != null ?currentClaim.CSS_WS_Possession_Flag__c :''));
            header.put('CustomerName','');
            if((currentClaim.CSS_WS_Warranty_Subtype__c == 'BIS')){
                header.put('CustomerName','BIS');
            } else if( currentClaim.CSS_WS_Customer_Name_Internal__c != null ){
                String Name = [SELECT Name from Account WHERE Id =: currentClaim.CSS_WS_Customer_Name_Internal__c].Name;
                String New_Name = (Name != null)?((Name.Length()>=49)?Name.subString(0,49):Name):'';
                header.put('CustomerName',New_Name); 
            }  
            header.put('ECMCalibAfter',(currentClaim.CSS_WS_ECM_Calibration_After__c!= null ? currentClaim.CSS_WS_ECM_Calibration_After__c:''));
            header.put('ReviewAfter',(currentClaim.CSS_WS_Revision_After__c!= null ? currentClaim.CSS_WS_Revision_After__c:''));
            header.put('ECMCalibBefore',(currentClaim.CSS_WS_ECM_Calibration_Before__c!= null ? currentClaim.CSS_WS_ECM_Calibration_Before__c:''));
            header.put('RevisionBefore',(currentClaim.CSS_WS_Revision_Before__c!= null ? currentClaim.CSS_WS_Revision_Before__c:''));
            header.put('Justification',(currentClaim.CSS_WS_ECM_Calib_Justification__c!= null ? currentClaim.CSS_WS_ECM_Calib_Justification__c:''));
            header.put('ESNCount',(currentClaim.CSS_WS_ESN_Count__c!= null ? currentClaim.CSS_WS_ESN_Count__c:''));
            header.put('TSRNumber',(currentClaim.CSS_WS_TSR_Number__c!= null ? currentClaim.CSS_WS_TSR_Number__c:''));
            header.put('PenaltyFlag','');
            header.put('SRTPenaltyPercentage',(currentClaim.CSS_WS_SRTPenaltyPercentage__c!= null && currentClaim.CSS_WS_SRTPenaltyPercentage__c!= '0'?currentClaim.CSS_WS_SRTPenaltyPercentage__c:''));
            header.put('DealerClaimNumber',currentClaim.CSS_WS_Claim_Number__c);
            header.put('manualAdjudicationFlag',(currentClaim.CSS_WS_Manual_Adjudication_Flag__c != null )?currentClaim.CSS_WS_Manual_Adjudication_Flag__c:'');
            header.put('ClaimFiledDate',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Claim_Creation_Date__c, 'MM/dd/yyyy'));
            header.put('SPInShopLaborRate',(currentClaim.CSS_WS_In_shop_Labor_Rate__c!= null ?currentClaim.CSS_WS_In_shop_Labor_Rate__c:''));
            header.put('SPLaborRate',(currentClaim.CSS_WS_Labor_Rate__c!= null ?currentClaim.CSS_WS_Labor_Rate__c:''));
            header.put('SPTravelRate',(currentClaim.CSS_WS_Travel_Rate__c!= null ?currentClaim.CSS_WS_Travel_Rate__c:''));
            
            CSS_WS_SLP_DR_Contacts__c [] contact = [SELECT WWID__c FROM CSS_WS_SLP_DR_Contacts__c WHERE Name =: currentClaim.CSS_WS_Service_Provider_DR__c LIMIT 1];
            
            header.put('Contact',(contact.size() > 0 )?contact[0].WWID__c:'');
            List<String> complaints = new String[]{};
            complaints.add(currentClaim.CSS_WS_Complaints1__c); //ComplaintCode
            if(currentClaim.CSS_WS_Complaints2__c != null){
                complaints.add(currentClaim.CSS_WS_Complaints2__c);
            }
            if(currentClaim.CSS_WS_Complaints3__c != null){
                complaints.add(currentClaim.CSS_WS_Complaints3__c);
            }
            List<String> promotionIds = new String[]{};
            promotionIds.add((currentClaim.CSS_WS_Promotion_ID__c != null)?currentClaim.CSS_WS_Promotion_ID__c:'No Promotion Id');
                        
            List<CSS_WS_MultiESN__c> multi = [SELECT 
                CSS_WS_MultiESN__c, 
                CSS_WS_BIS_2__c, 
                CSS_WS_FailureDate__c,
                CSS_WS_FailurePoint__c, 
                CSS_WS_FailurePointType__c, 
                CSS_WS_ESNCalibrationEnd__c, 
                CSS_WS_ESNCalibrationStart__c, 
                CSS_WS_WarrantyStartDate__c, 
                CSS_WS_Revision_After__c, 
                CSS_WS_Revision_Before__c
            FROM CSS_WS_MultiESN__c WHERE CSS_WS_Warranty__c = :currentClaim.Id ];        
                    
            List<Map<String, String>> multiESN = new List<Map<String, String>> ();
            for(CSS_WS_MultiESN__c cont: multi){
                Map<String, String> esnData = new Map<String,String>{};
                esnData.put('EngineSerialNumber',cont.CSS_WS_MultiESN__c);//EngineSerialNumber
                esnData.put('BISFlag',(cont.CSS_WS_BIS_2__c == 'BIS')?'Y':'N');
                esnData.put('FailureDate',CSS_WS_ControllerClaim.dateToString(cont.CSS_WS_FailureDate__c, 'MM/dd/yyyy'));
                esnData.put('FailurePoint',cont.CSS_WS_FailurePoint__c);
                esnData.put('FailureMeasure',cont.CSS_WS_FailurePointType__c);
                esnData.put('ECMCalibAfter',(cont.CSS_WS_ESNCalibrationEnd__c!= null ?cont.CSS_WS_ESNCalibrationEnd__c:''));
                esnData.put('ReviewAfter',(cont.CSS_WS_Revision_After__c!= null ?cont.CSS_WS_Revision_After__c:''));
                esnData.put('ECMCalibBefore',(cont.CSS_WS_ESNCalibrationStart__c!= null?cont.CSS_WS_ESNCalibrationStart__c:''));
                esnData.put('RevisionBefore',(cont.CSS_WS_Revision_Before__c!= null?cont.CSS_WS_Revision_Before__c:''));
                esnData.put('WarrantyStartDate',CSS_WS_ControllerClaim.dateToString(cont.CSS_WS_WarrantyStartDate__c, 'MM/dd/yyyy'));
                multiESN.add(esnData);  
            }
                       
            List<Map<String, String>> notes = new List<Map<String, String>> ();
            if(currentClaim.CSS_WS_Claim_Narrative__c != null){
                Map<String, String> notesNarrative = new Map<String,String>{};
                notesNarrative.put('Note', currentClaim.CSS_WS_Claim_Narrative__c.escapeJava());
                notesNarrative.put('NoteType', 'Narrative');
                //notes.add(currentClaim.CSS_WS_Claim_Narrative__c.escapeJava());
                notes.add(notesNarrative);
            }
            
            List<CSS_WS_Warranty_Parts__c> epr_parts_list = [SELECT  
                CSS_WS_Long_Part_Number_del__c, 
                CSS_WS_EPR_Attention__c,
                CSS_WS_EPR_Note__c
            FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c = :currentClaim.Id AND CSS_WS_Part_Return_Flag__c = true ORDER BY CSS_WS_EPR_Attention__c];  
            
            if(epr_parts_list.size() > 0){
                
                String note_parts_return = '';
                Integer i = 0;
                for(i = 0; i < epr_parts_list.size(); i++){
                    if(i == 0){
                        note_parts_return = epr_parts_list[i].CSS_WS_EPR_Note__c + ' FOLLOWING PARTS TO BE RETURNED: ' + epr_parts_list[i].CSS_WS_Long_Part_Number_del__c;
                    } else if(epr_parts_list[i].CSS_WS_EPR_Attention__c == epr_parts_list[i-1].CSS_WS_EPR_Attention__c){
                        note_parts_return = note_parts_return + ', ' + epr_parts_list[i].CSS_WS_Long_Part_Number_del__c;
                    } else {
                        note_parts_return = note_parts_return + '\nSEPARATOR\n';
                        note_parts_return = note_parts_return + epr_parts_list[i].CSS_WS_EPR_Note__c + ' FOLLOWING PARTS TO BE RETURNED: ' + epr_parts_list[i].CSS_WS_Long_Part_Number_del__c;
                    }                    
                } 
                String[] notes_splited_list = note_parts_return.split('\nSEPARATOR\n');
                for(String notes_splited : notes_splited_list){
                    Map<String, String> notesPartsReturn = new Map<String,String>{};
                    notesPartsReturn.put('Note', notes_splited);
                    notesPartsReturn.put('NoteType', 'Parts Return');                
                    notes.add(notesPartsReturn); 
                }                 
          
            } 
            
            
            List<CSS_WS_Failure__c> fail = [SELECT 
                CSS_WS_EngineSystemCode__c, 
                CSS_WS_ComponentCode__c, 
                CSS_WS_FailureModeCode__c 
            FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :currentClaim.Id ];  
                    
            List<Map<String, String>> failure = new List<Map<String, String>> ();
            for(CSS_WS_Failure__c cont_fail: fail){
                Map<String, String> failureData = new Map<String,String>{};
                failureData.put('SystemCode',cont_fail.CSS_WS_EngineSystemCode__c);
                failureData.put('ComponentCode',cont_fail.CSS_WS_ComponentCode__c);
                failureData.put('FailMode',cont_fail.CSS_WS_FailureModeCode__c);
                failureData.put('AccountCode',currentClaim.CSS_WS_Account_Code__c);
                failureData.put('PayCode',currentClaim.CSS_WS_Pay_Code__c);
                failureData.put('CertificateNumber',(currentClaim.CSS_WS_Certificate_Number__c!=null && currentClaim.CSS_WS_Certificate_Number_Id__c!=null)?currentClaim.CSS_WS_Certificate_Number__c+'-'+currentClaim.CSS_WS_Certificate_Number_Id__c:'');
                failureData.put('CampaignNumber',(currentClaim.CSS_WS_Campaigns_TRPs__c!= null ?currentClaim.CSS_WS_Campaigns_TRPs__c:''));
                failureData.put('WarrantyId',(currentClaim.CSS_WS_WarrantyId__c!=null)?currentClaim.CSS_WS_WarrantyId__c:'');
                if(currentClaim.CSS_WS_Policy_Flag__c == 'Policy WW' ){
                    String approver = currentClaim.Other_Approver_Picklist_WW__c;
                    String approverCode = '';
                    if(approver != null && approver.contains('-')){
                        String[] ValuesFromSplit = approver.split('-');
                        if(ValuesFromSplit != null){
                            approverCode = ValuesFromSplit[0].trim();
                        }  
                    }
                    failureData.put('ApproverCode',approverCode);
                } else {
                    failureData.put('ApproverCode',(currentClaim.CSS_WS_Other_Approver__c!=null)?currentClaim.CSS_WS_Other_Approver__c:'');
                }
                failureData.put('CoverageType',(currentClaim.CSS_WS_Account_Code_Type__c!=null)?currentClaim.CSS_WS_Account_Code_Type__c:'');
                failureData.put('CoveredLaborHours',(currentClaim.CSS_WS_Covered_Labor_Hours__c != NULL)?String.valueOf(currentClaim.CSS_WS_Covered_Labor_Hours__c):'');
                failureData.put('CoveredMealsLodgingAmt',(currentClaim.CSS_WS_Covered_Meals_Lodging__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Covered_Meals_Lodging__c):'');
                failureData.put('CoveredOCAmount',(currentClaim.CSS_WS_Covered_OC_Amount__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Covered_OC_Amount__c):'');   
                failureData.put('CoveredPartsQuantity',(currentClaim.CSS_WS_Covered_Parts_Qty__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Covered_Parts_Qty__c):'');
                failureData.put('CoveredTowingMiles',(currentClaim.CSS_WS_Covered_Towing_Miles__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Covered_Towing_Miles__c):'');
                failureData.put('CoveredTravelLabor',(currentClaim.CSS_WS_Covered_Travel_Labor__c != NULL)?String.valueOf(currentClaim.CSS_WS_Covered_Travel_Labor__c ):'');
                failureData.put('CoveredTravelMiles',(currentClaim.CSS_WS_Covered_Travel_Miles__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Covered_Travel_Miles__c):'');
                failureData.put('DeductibleAmount',(currentClaim.CSS_WS_Deductible_Amount__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Deductible_Amount__c):'');
                failureData.put('AuthorizationNum',(currentClaim.CSS_Authorization_Number__c!= NULL)?String.valueOf(currentClaim.CSS_Authorization_Number__c):'');
                failureData.put('CampaignLabourPrcnt',(currentClaim.CSS_WS_Campaign_Labor_Percentage__c != NULL)?String.valueOf(currentClaim.CSS_WS_Campaign_Labor_Percentage__c ):'');
                failureData.put('CampaignOCPrcnt',(currentClaim.CSS_WS_Campaign_OC_Percentage__c != NULL)?String.valueOf(currentClaim.CSS_WS_Campaign_OC_Percentage__c ):'');
                failureData.put('CampaignPartsPrcnt',(currentClaim.CSS_WS_Campaign_Parts_Percentage__c != NULL)?String.valueOf(currentClaim.CSS_WS_Campaign_Parts_Percentage__c ):'');
                failureData.put('CampaignTowingPrcnt',(currentClaim.CSS_WS_Campaign_Towing_Percentage__c != NULL)?String.valueOf(currentClaim.CSS_WS_Campaign_Towing_Percentage__c ):'');
                failureData.put('CampaignTravelPrcnt',(currentClaim.CSS_WS_Campaign_Travel_Percentage__c != NULL)?String.valueOf(currentClaim.CSS_WS_Campaign_Travel_Percentage__c ):'');
                failure.add(failureData);   
            }
                
            List<CSS_WS_Other_Claimable__c> other_claimable = [SELECT  
                CSS_WS_Description__c, 
                CSS_WS_Claimable__c, 
                CSS_WS_Claimed_Reason__c, 
                CSS_WS_Requested_Amount__c       
            FROM CSS_WS_Other_Claimable__c WHERE CSS_WS_Warranty__c = :currentClaim.Id ];  
                
            List<Map<String, String>> claimable = new List<Map<String, String>> ();
            for(CSS_WS_Other_Claimable__c cont_claimable: other_claimable){
                Map<String, String> ocData = new Map<String,String>{};
                ocData.put('Item',cont_claimable.CSS_WS_Claimable__c);
                ocData.put('OtherClaimableDetails',(cont_claimable.CSS_WS_Description__c!=null)?cont_claimable.CSS_WS_Description__c.escapeJava():'');
                ocData.put('ClaimedReason','');
                ocData.put('ClaimedAmount',(cont_claimable.CSS_WS_Requested_Amount__c!= NULL)?String.valueOf(cont_claimable.CSS_WS_Requested_Amount__c):'');
                claimable.add(ocData); 
            }
                
            List<CSS_WS_Warranty_Parts__c> parts_list = [SELECT  
                CSS_WS_Long_Part_Number_del__c, 
                CSS_WS_Quantity__c, 
                CSS_WS_Siebel_Unit_Part_Price__c, 
                Part_Percentage__c, 
                CSS_WS_ReplacementReasonPicklist__c, 
                CSS_WS_Part_Return_Flag__c, 
                CSS_WS_Shipping_Company__c, 
                CSS_WS_Tracking_Guide_Code__c,
                CSS_WS_Waiver_Process__c,
                CSS_WS_priceBook__c
            FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c = :currentClaim.Id ];      
                    
            List<Map<String, String>> parts = new List<Map<String, String>> ();
            for(CSS_WS_Warranty_Parts__c cont_parts: parts_list){
                Map<String, String> partData = new Map<String,String>{};
                partData.put('PartNumber',cont_parts.CSS_WS_Long_Part_Number_del__c);
                partData.put('QtyClaimed',(cont_parts.CSS_WS_Quantity__c!= NULL)?String.valueOf(cont_parts.CSS_WS_Quantity__c):'');
                partData.put('PartUnitPrice',(cont_parts.CSS_WS_Siebel_Unit_Part_Price__c!= NULL)?String.valueOf(cont_parts.CSS_WS_Siebel_Unit_Part_Price__c):'');
                partData.put('PartPercentage',(cont_parts.Part_Percentage__c!= NULL)?String.valueOf(cont_parts.Part_Percentage__c):'');
                partData.put('ReplacementReason',cont_parts.CSS_WS_ReplacementReasonPicklist__c);
                partData.put('PartsReturnFlag',(cont_parts.CSS_WS_Part_Return_Flag__c)?'Y':'N'); 
                partData.put('RIDNumber',(cont_parts.CSS_WS_Shipping_Company__c != NULL)?cont_parts.CSS_WS_Shipping_Company__c:'');
                partData.put('TrackingNumber',(cont_parts.CSS_WS_Tracking_Guide_Code__c != NULL)?cont_parts.CSS_WS_Tracking_Guide_Code__c:'');
                partData.put('WaiverProcess',(cont_parts.CSS_WS_Waiver_Process__c != NULL)?cont_parts.CSS_WS_Waiver_Process__c:'');
                partData.put('PricebookName',cont_parts.CSS_WS_priceBook__c);
                parts.add(partData); 
            }
               
            List<CSS_WS_Warranty_SRT__c> srt_list = [SELECT  
                CSS_WS_SRT__c, 
                CSS_WS_Access_Code__c, 
                CSS_WS_Description__c, 
                CSS_WS_Hours__c, 
                CSS_WS_Quantity__c, 
                CSS_WS_Hours_Percentage__c, 
                CSS_WS_OutOfChassis__c, 
                CSS_WS_Overlap_Hours__c, 
                CSS_WS_Offsite__c 
            FROM CSS_WS_Warranty_SRT__c WHERE CSS_WS_WarrantyID__c = :currentClaim.Id ];      
                    
            List<Map<String, String>> srt= new List<Map<String, String>> ();
            for(CSS_WS_Warranty_SRT__c cont_srt: srt_list){
                Map<String, String> srtData = new Map<String,String>{};
                String SRTCode = CSS_WS_SRTGridController.getLongSRTCode(cont_srt.CSS_WS_SRT__c).touppercase();
                srtData.put('SRTCode',SRTCode);
                srtData.put('SRTAccessCode',cont_srt.CSS_WS_Access_Code__c);
                srtData.put('SRTHours',(cont_srt.CSS_WS_Hours__c!= NULL)?String.valueOf(cont_srt.CSS_WS_Hours__c):'');
                srtData.put('SRTQty',(cont_srt.CSS_WS_Quantity__c!= NULL)?String.valueOf(cont_srt.CSS_WS_Quantity__c):'');
                srtData.put('SRTPrcnt',(cont_srt.CSS_WS_Hours_Percentage__c != NULL)?String.valueOf(cont_srt.CSS_WS_Hours_Percentage__c ):'');
                srtData.put('OutOfChasis',(cont_srt.CSS_WS_OutOfChassis__c)?'Y':'N');
                srtData.put('OverlapHrs',(cont_srt.CSS_WS_Overlap_Hours__c!= NULL)?String.valueOf(cont_srt.CSS_WS_Overlap_Hours__c):'');
                srtData.put('Offiste',(cont_srt.CSS_WS_Offsite__c)?'Y':'N');
                srt.add(srtData);   
            }
                     
            List<Map<String, String>> travels = new List<Map<String, String>> ();    
            if(currentClaim.CSS_WS_Total_Amount_Travel__c > 0){
                Map<String, String> travel = new Map<String,String>{};
                travel.put('TravelType',currentClaim.CSS_WS_Travel_Type__c);
                travel.put('TravelMode',(currentClaim.CSS_WS_Travel_Mode__c!= NULL)?currentClaim.CSS_WS_Travel_Mode__c:'');
                travel.put('OtherModeDetails',(currentClaim.CSS_WS_Travel_Detail_Mode__c!= NULL)?currentClaim.CSS_WS_Travel_Detail_Mode__c:'');
                travel.put('TowingAmount','');
                if(SPPreferences.BillingCountry.touppercase() == 'MEXICO'){
                //// Change for Travel coverage and campaign - Apr 22nd 2020
                
                    if(currentClaim.CSS_WS_Campaigns_TRPs__c == null || currentClaim.CSS_WS_Campaigns_TRPs__c == ''){//Warranty not campaing
                        Decimal laborHours = (currentClaim.CSS_WS_Covered_Travel_Labor__c!= null)? currentClaim.CSS_WS_Covered_Travel_Labor__c:0;
                        if(laborHours < currentClaim.CSS_WS_Travel_Hours__c && currentClaim.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && currentClaim.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                            travel.put('Hours',String.valueof(laborHours));
                        } else {
                            travel.put('Hours',String.valueof(currentClaim.CSS_WS_Travel_Hours__c));
                        }
                        Decimal travelMiles = (currentClaim.CSS_WS_Covered_Travel_Miles__c != null)? currentClaim.CSS_WS_Covered_Travel_Miles__c:0;
                        if(travelMiles < currentClaim.CSS_WS_Travel_Distance__c && currentClaim.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && currentClaim.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                            travel.put('Distance',String.valueof(travelMiles));
                        } else {
                            travel.put('Distance',String.valueof(currentClaim.CSS_WS_Travel_Distance__c));
                        }
                        Decimal mealsAmount = (currentClaim.CSS_WS_Covered_Meals_Lodging__c != null)? currentClaim.CSS_WS_Covered_Meals_Lodging__c:0;
                        Decimal srtHours = (currentClaim.CSS_WS_Total_Amount_SRT_Hours__c!= null)? currentClaim.CSS_WS_Total_Amount_SRT_Hours__c:0;
                        Decimal travelHours = (currentClaim.CSS_WS_Travel_Hours__c!= null)? currentClaim.CSS_WS_Travel_Hours__c:0;
                        if((travelHours + srtHours) < 8){//Rule 04-295
                            travel.put('MealsAmount','');
                        } else if( mealsAmount < currentClaim.CSS_WS_Lodging__c && currentClaim.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && currentClaim.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                            travel.put('MealsAmount',String.valueof(mealsAmount));
                        } else {
                            travel.put('MealsAmount',String.valueof(currentClaim.CSS_WS_Lodging__c));
                        }                           
                    } else { // Warranty with campaign              
                        if ((currentClaim.CSS_WS_Campaign_Travel_Percentage__c == 0 || currentClaim.CSS_WS_Campaign_Travel_Percentage__c == null) && (currentClaim.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && currentClaim.CSS_WS_Account_Code_Type__c != 'OTH – Other')){ //Campaign percentage equal to 0 or null, and Reinstatement flag to false
                            travel.put('Hours','0');
                            travel.put('Distance','0');
                            travel.put('MealsAmount','0');
                        } else {//Campaign percentage greater than 0
                            travel.put('Hours',(currentClaim.CSS_WS_Travel_Hours__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Travel_Hours__c):'');
                            travel.put('Distance',(currentClaim.CSS_WS_Travel_Distance__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Travel_Distance__c):'');
                            travel.put('MealsAmount',(currentClaim.CSS_WS_Lodging__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Lodging__c):'');
                        }                       
                    }
                    
                //// End change for Travel coverage and campaign - Apr 22nd 2020
                } else {
                    travel.put('Hours',(currentClaim.CSS_WS_Travel_Hours__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Travel_Hours__c):'');
                    travel.put('Distance',(currentClaim.CSS_WS_Travel_Distance__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Travel_Distance__c):'');
                    travel.put('MealsAmount',(currentClaim.CSS_WS_Lodging__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Lodging__c):'');
                }
                travels.add(travel);
                if(currentClaim.CSS_WS_Towing_Amount__c > 0){
                    travel = new Map<String,String>{};
                    travel.put('TravelType','Towing');
                    travel.put('TravelMode','');
                    travel.put('OtherModeDetails','');
                    travel.put('Hours','');
                    travel.put('Distance','');
                    travel.put('MealsAmount','');
                    if(SPPreferences.BillingCountry.touppercase() == 'MEXICO'){
                    //// Change for Towing coverage and campaign - Apr 22nd 2020
                    
                        if(currentClaim.CSS_WS_Campaigns_TRPs__c == null || currentClaim.CSS_WS_Campaigns_TRPs__c == ''){//Warranty not campaing
                            Decimal towingAmount = (currentClaim.CSS_WS_Covered_Towing_Miles__c!= null)? currentClaim.CSS_WS_Covered_Towing_Miles__c:0;
                            if(towingAmount < currentClaim.CSS_WS_Towing_Amount__c && currentClaim.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && currentClaim.CSS_WS_Account_Code_Type__c != 'OTH – Other'){
                                travel.put('TowingAmount',String.valueof(towingAmount));
                            } else {
                                travel.put('TowingAmount',String.valueof(currentClaim.CSS_WS_Towing_Amount__c));
                            }
                        } else {// Warranty with campaign               
                            if ((currentClaim.CSS_WS_Campaign_Towing_Percentage__c == 0 || currentClaim.CSS_WS_Campaign_Towing_Percentage__c == null) && (currentClaim.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && currentClaim.CSS_WS_Account_Code_Type__c != 'OTH – Other')){ //Campaign percentage equal to 0 or null, and Reinstatement flag to false
                                travel.put('TowingAmount','0');
                            } else { //Campaign percentage greater than 0 or Reinstatement Flag                             
                                travel.put('TowingAmount',String.valueof(currentClaim.CSS_WS_Towing_Amount__c));                     
                            }
                        }     
                        
                    //// End change for Towing coverage and campaign - Apr 22nd 2020
                    } else {
                        travel.put('TowingAmount',String.valueof(currentClaim.CSS_WS_Towing_Amount__c));
                    }
                    travels.add(travel);
                }
            }
            CSS_WS_J2A_ClaimSubmission claimSubmisionResponse = CSS_WS_GetWebServiceData.getClaimSubmission(header, complaints, promotionIds, multiESN, notes, failure, claimable, parts, srt, travels);
                
            if(claimSubmisionResponse != null){
                if(claimSubmisionResponse.Header.Status.touppercase()=='SUCCESS') {
                    currentClaim.CSS_WS_Siebel_Claim_Number__c = claimSubmisionResponse.DataArea.ClaimNumber;
                    //currentClaim.CSS_WS_US_Date__c = System.today(); 
                    currentClaim.CSS_WS_Claim_Status__c='Pending US';
                } else {
                    currentClaim.CSS_WS_Claim_Status__c='Error in US';
                    if(claimSubmisionResponse.Header.ReturnCodeDescription != null){
                        currentClaim.CSS_WS_Error_US_Reason__c = claimSubmisionResponse.Header.ReturnCodeDescription;
                    }
                }
            } else {
                currentClaim.CSS_WS_Claim_Status__c='Error sending claim';
            }
            update currentClaim ;
        } catch(System.Exception e){
            currentClaim.CSS_WS_Claim_Status__c='Error sending claim';
            System.debug('Error sending claim: '+e.getMessage());
            update(currentClaim);
        }
    }   
}