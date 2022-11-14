Public Class CSS_WS_Claim_Reliability_Async{

    @future(callout = true)   
    Public Static Void claimReliabilityWSCallout(Id ClaimID){        
        CSS_WS_Warranty__c currentClaim = [SELECT 
            CSS_WS_Access_Code__c,
            CSS_WS_Claim_Creation_Date__c,
            CSS_WS_Claim_Number__c,
            CSS_WS_Claim_Status__c,
            CSS_WS_COMC__c,
            CSS_WS_Customer_Name_Internal__c,
            CSS_WS_Engine_Application__c,
            CSS_WS_Engine_Serial_Number__c,
            CSS_WS_Factory_Payment_Date__c,
            CSS_WS_Failure_Date_Time__c,
            CSS_WS_Failure_Point_Quantity__c,
            CSS_WS_Mission_Disabling_Severity_Code__c,
            CSS_WS_Model_Series__c,
            CSS_WS_Manufacturer__c,
            CSS_WS_Pay_Code__c,
            CSS_WS_Service_Provider_Dealer__c,
            CSS_WS_Service_Provider_DR__c,
            CSS_WS_Total_Claim_Approved__c,
            CSS_WS_WarrantyId__c 
        FROM CSS_WS_Warranty__c WHERE CSS_WS_Warranty__c.id =: ClaimID];            
        System.debug('Current Claim: '+currentClaim);
        try{
            Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(currentClaim.CSS_WS_Service_Provider_DR__c, currentClaim.CSS_WS_Service_Provider_Dealer__c);       
            Map<String, String> header = new Map<String,String>{};
            header.put('operationCode','I');
            header.put('distributorCode',currentClaim.CSS_WS_Service_Provider_DR__c);
            header.put('claimNum',currentClaim.CSS_WS_Claim_Number__c);
            header.put('claimYear',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Claim_Creation_Date__c, 'yyyy'));
            header.put('reinstatementCode','R0');
            header.put('engineSerialNum',currentClaim.CSS_WS_Engine_Serial_Number__c);
            header.put('programPaymentCode',currentClaim.CSS_WS_Pay_Code__c);
            header.put('programAccountCode','88');
            header.put('authorizationNum','');
            header.put('claimDate',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Claim_Creation_Date__c, 'yyyyMMdd'));
            header.put('materialsAmount','0');
            header.put('repairLaborAmount','0');
            header.put('otherExpenseAmount','0');
            header.put('engineMiles','');
            header.put('engineKm',(currentClaim.CSS_WS_Failure_Point_Quantity__c!= null)?((currentClaim.CSS_WS_Failure_Point_Quantity__c.Length()>7)?currentClaim.CSS_WS_Failure_Point_Quantity__c.subString(0,7):currentClaim.CSS_WS_Failure_Point_Quantity__c):'');
            header.put('engineHours','');
            header.put('failureDate',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Failure_Date_Time__c, 'yyyyMMdd'));
            header.put('failureSeverityCode',(currentClaim.CSS_WS_Mission_Disabling_Severity_Code__c!= NULL)?currentClaim.CSS_WS_Mission_Disabling_Severity_Code__c:'');
            
            List<CSS_WS_Failure__c> fail_code = [SELECT 
                CSS_WS_EngineSystemCode__c, 
                CSS_WS_ComponentCode__c, 
                CSS_WS_FailureModeCode__c 
            FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :currentClaim.Id ];  
            
            header.put('dataToCalcSyscdCompcdFlcd',fail_code[0].CSS_WS_EngineSystemCode__c + fail_code[0].CSS_WS_ComponentCode__c + fail_code[0].CSS_WS_FailureModeCode__c);
            header.put('claimCustomerName','');
            if( currentClaim.CSS_WS_Customer_Name_Internal__c != null ){
                String Name = [SELECT Name from Account WHERE Id =: currentClaim.CSS_WS_Customer_Name_Internal__c].Name;
                String New_Name = (Name != null)?((Name.Length()>=29)?Name.subString(0,29):Name):'';
                header.put('claimCustomerName',New_Name); 
            }  
            header.put('claimCustomerAddress','');
            header.put('deductibleAmount','0');
            header.put('laborHours','');
            header.put('travelLodgingAmount','0');
            header.put('claimSourceCode','M');
            header.put('paymentDate',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Factory_Payment_Date__c, 'yyyyMMdd'));  
            header.put('dataToCalcPartNum','');
            header.put('taxAmount','0');
            header.put('markupAmount','0');
            header.put('beyondFactCharge','0');
            header.put('netAmount',(currentClaim.CSS_WS_Total_Claim_Approved__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Total_Claim_Approved__c):'');
            header.put('engineCoverageGrpCode','');
            header.put('engineUseCode','');
            header.put('serviceAreaCode','');
            header.put('cumminsAdminAmount','0');
            header.put('claimRapidserveId','');
            header.put('travelLaborAmount','0');
            header.put('travelToSiteAmount','0');
            header.put('undetailedPartsAmount','0');
            header.put('dollarDifferAmount','0');
            header.put('creditStatement',currentClaim.CSS_WS_COMC__c);
            header.put('claimStatusCode','Z');
            header.put('dealerCode',currentClaim.CSS_WS_Service_Provider_Dealer__c);
            header.put('equipManufac',currentClaim.CSS_WS_Manufacturer__c);
            header.put('equipModel',currentClaim.CSS_WS_Model_Series__c);
            header.put('equipConfig',(currentClaim.CSS_WS_Engine_Application__c!= null)?((currentClaim.CSS_WS_Engine_Application__c.Length()>15)?currentClaim.CSS_WS_Engine_Application__c.subString(0,15):currentClaim.CSS_WS_Engine_Application__c):'');
            header.put('accessCode',currentClaim.CSS_WS_Access_Code__c);
            
            List<CSS_WS_Failure__c> fail = [SELECT 
                CSS_WS_EngineSystemCode__c, 
                CSS_WS_ComponentCode__c, 
                CSS_WS_FailureModeCode__c 
            FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :currentClaim.Id ];  
            
            Integer i = 0;
            List<Map<String, String>> failure = new List<Map<String, String>> ();
            for(CSS_WS_Failure__c cont_fail: fail){
                Map<String, String> failureData = new Map<String,String>{};
                failureData.put('dataToCalcSyscdCompcdFlcd',cont_fail.CSS_WS_EngineSystemCode__c + cont_fail.CSS_WS_ComponentCode__c + cont_fail.CSS_WS_FailureModeCode__c);
                if(i == 0){
                    failureData.put('netAmount',(currentClaim.CSS_WS_Total_Claim_Approved__c!= NULL)?String.valueOf(currentClaim.CSS_WS_Total_Claim_Approved__c):'0'); 
                } else {
                    failureData.put('netAmount','0');
                }
                i = i + 1;
                failure.add(failureData);               
            }                
                           
            List<CSS_WS_Warranty_Parts__c> parts_list = [SELECT  
                CSS_WS_Long_Part_Number_del__c, 
                CSS_WS_Quantity__c, 
                CSS_WS_Siebel_Unit_Part_Price__c, 
                CSS_WS_Description__c
            FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c = :currentClaim.Id ];      
                    
            List<Map<String, String>> parts = new List<Map<String, String>> ();
            for(CSS_WS_Warranty_Parts__c cont_parts: parts_list){
                Map<String, String> partData = new Map<String,String>{};       
                partData.put('distributorCode',currentClaim.CSS_WS_Service_Provider_DR__c);
                partData.put('claimYear',CSS_WS_ControllerClaim.dateToString(currentClaim.CSS_WS_Claim_Creation_Date__c, 'yyyy'));
                partData.put('claimNum',currentClaim.CSS_WS_Claim_Number__c);
                partData.put('reinstatementCode','R0');
                partData.put('engineSerialNum',currentClaim.CSS_WS_Engine_Serial_Number__c);
                partData.put('partNumType','R'); 
                partData.put('partNum',cont_parts.CSS_WS_Long_Part_Number_del__c);
                partData.put('partDesc',cont_parts.CSS_WS_Description__c);
                partData.put('partQty',(cont_parts.CSS_WS_Quantity__c!= NULL)?String.valueOf(cont_parts.CSS_WS_Quantity__c):'');
                partData.put('partAdjdPct','');
                partData.put('partUnitPrice',(cont_parts.CSS_WS_Siebel_Unit_Part_Price__c!= NULL)?String.valueOf(cont_parts.CSS_WS_Siebel_Unit_Part_Price__c):'');
                partData.put('partExtdPrice','');
                partData.put('taxStatusFlg','');
                partData.put('partStatusFlg','');
                parts.add(partData); 
            }
               
            
            CSS_WS_J2A_ClaimReliability claimReliabilityResponse = CSS_WS_GetWebServiceData.getClaimReliability(header, failure, parts);
                
            if(claimReliabilityResponse != null){
                if(claimReliabilityResponse.status.touppercase()=='SUCCESS') {
                    currentClaim.CSS_WS_Claim_Status__c = 'Pending DR Payment to DL';
                    currentClaim.CSS_WS_Claim_Reliability_Flag__c = true;                   
                    currentClaim.CSS_WS_Claim_Reliability_Description__c = claimReliabilityResponse.message;
                    currentClaim.CSS_WS_Claim_Reliability_Date__c = System.today(); 
                } else {
                    currentClaim.CSS_WS_Claim_Status__c = 'Error in Reliability';
                    currentClaim.CSS_WS_Claim_Reliability_Flag__c = true;
                    currentClaim.CSS_WS_Claim_Reliability_Date__c = System.today(); 
                    currentClaim.CSS_WS_Claim_Reliability_Description__c = claimReliabilityResponse.message;
                    currentClaim.CSS_WS_Claim_Reliability_Error_Message__c = claimReliabilityResponse.ReturnCodeDescription;
                }
            } else {
                currentClaim.CSS_WS_Claim_Status__c='Error sending claim to Reliability';
            }
            update currentClaim ; 
        } catch(System.Exception e){
            currentClaim.CSS_WS_Claim_Status__c='Error sending claim to Reliability';
            System.debug('Error sending claim to Reliability: '+e.getMessage());
            update(currentClaim);
        }
    }
}