Global class CSS_WS_ClaimServiceOrder{

    WebService static id RescueToClaim(String rescue_id){
        
        Id claim_Id;
        List<CSS_WS_Rescue__c> rescues = new List<CSS_WS_Rescue__c>();
        rescues = [SELECT Id, CSS_WS_Access_Code__c, CSS_WS_Warranty_Relationship__c, CSS_WS_Warranty_Relationship__r.CSS_WS_Account_Code__c, CSS_WS_Claim_Service_Order__c, 
                CSS_WS_Customer_Name_Internal__c, CSS_WS_Engine_Application__c, CSS_WS_Engine_Application_Code__c, CSS_WS_Build_Date__c, CSS_WS_Engine_Family_Code__c, 
                CSS_WS_Engine_Serial_Number__c, CSS_WS_Failure_Measure__c, CSS_WS_Failure_Point_Quantity__c, CSS_WS_Lodging_Amount__c, CSS_WS_LunchAmount__c, 
                CSS_WS_Manufacturer__c, CSS_WS_Model_Series__c, CSS_WS_RescueCost__c, CSS_WS_RepairEnding__c, CSS_WS_Service_Model__c, CSS_WS_Service_Provider_Dealer__c, 
                CSS_WS_Service_Provider_DR__c, CSS_WS_Service_Provider_Name_Dealer__c, CSS_WS_Service_Provider_Name_DR__c, CSS_WS_ServiceRequest__c, CSS_WS_TechnicianName__c, 
                CSS_WS_TechnicianPromotion__c, CSS_WS_TowingAmount__c, CSS_WS_TravelKmRoundTripPolicy__c, CSS_WS_TravelHoursRoundTripPolicy__c, 
                CSS_WS_Warranty_Start_Date__c, CSS_WS_Years_In_Service__c, Name 
                FROM CSS_WS_Rescue__c WHERE Id =: rescue_id LIMIT 1];
        
        System.debug('Current Rescue record: '+rescues);
        try{        
            if(rescues.size() > 0){ 
                // Verify if rescue record can be used for creating Claim Service Order
                // Rescue record should not be related to a claim
                // If rescue is related to claim, the account code of claim should be P89
                boolean claim_p89;
                boolean related_claim; 
                if (rescues[0].CSS_WS_Warranty_Relationship__c != null){
                    related_claim = true;
                    if (rescues[0].CSS_WS_Warranty_Relationship__r.CSS_WS_Account_Code__c == 'P89'){
                        claim_p89 = true;
                    } else {
                        claim_p89 = false;
                    }
                } else {
                    related_claim = false;
                    claim_p89 = false;
                }
                
                if (related_claim == false || claim_p89 == true){        
                    CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c();
                    claim.CSS_WS_Access_Code__c = rescues[0].CSS_WS_Access_Code__c;
                    claim.CSS_WS_Customer_Name_Internal__c = rescues[0].CSS_WS_Customer_Name_Internal__c;
                    claim.CSS_WS_Engine_Application__c = rescues[0].CSS_WS_Engine_Application__c;
                    claim.CSS_WS_Engine_Application_Code__c = rescues[0].CSS_WS_Engine_Application_Code__c;
                    claim.CSS_WS_Build_Date__c = rescues[0].CSS_WS_Build_Date__c;
                    claim.CSS_WS_Engine_Family_Code__c = rescues[0].CSS_WS_Engine_Family_Code__c;
                    claim.CSS_WS_Engine_Serial_Number__c = rescues[0].CSS_WS_Engine_Serial_Number__c;
                    claim.CSS_WS_Failure_Measure__c = rescues[0].CSS_WS_Failure_Measure__c;
                    claim.CSS_WS_Failure_Point_Quantity__c = rescues[0].CSS_WS_Failure_Point_Quantity__c;
                    Decimal Lodging = (rescues[0].CSS_WS_Lodging_Amount__c != null) ? rescues[0].CSS_WS_Lodging_Amount__c : 0;
                    Decimal Lunch = (rescues[0].CSS_WS_LunchAmount__c != null) ? rescues[0].CSS_WS_LunchAmount__c : 0;
                    claim.CSS_WS_Lodging__c = Lodging + Lunch;
                    claim.CSS_WS_Manufacturer__c = rescues[0].CSS_WS_Manufacturer__c;
                    claim.CSS_WS_Model_Series__c = rescues[0].CSS_WS_Model_Series__c;
                    Decimal Towing = (rescues[0].CSS_WS_TowingAmount__c != null) ? rescues[0].CSS_WS_TowingAmount__c : 0;
                    Decimal RescueCost = (rescues[0].CSS_WS_RescueCost__c != null) ? rescues[0].CSS_WS_RescueCost__c : 0;
                    claim.CSS_WS_Towing_Amount__c = rescues[0].CSS_WS_TowingAmount__c;      
                    claim.CSS_WS_Total_Amount_Travel__c = Towing + RescueCost;
                    claim.CSS_WS_End_Repair_Date_Time__c = rescues[0].CSS_WS_RepairEnding__c;
                    claim.CSS_WS_Service_Model__c = rescues[0].CSS_WS_Service_Model__c;
                    claim.CSS_WS_Service_Provider_Dealer__c = rescues[0].CSS_WS_Service_Provider_Dealer__c;
                    claim.CSS_WS_Service_Provider_DR__c = rescues[0].CSS_WS_Service_Provider_DR__c;
                    claim.CSS_WS_Service_Provider_Name_Dealer__c = rescues[0].CSS_WS_Service_Provider_Name_Dealer__c;
                    claim.CSS_WS_Service_Provider_Name_DR__c = rescues[0].CSS_WS_Service_Provider_Name_DR__c;
                    claim.CSS_WS_Failure_Date_Time__c = rescues[0].CSS_WS_ServiceRequest__c;
                    claim.CSS_WS_Technician_Name__c = rescues[0].CSS_WS_TechnicianName__c;
                    claim.CSS_WS_Promotion_ID__c = rescues[0].CSS_WS_TechnicianPromotion__c;
                    claim.CSS_WS_Travel_Distance__c = rescues[0].CSS_WS_TravelKmRoundTripPolicy__c;
                    claim.CSS_WS_Travel_Hours__c = rescues[0].CSS_WS_TravelHoursRoundTripPolicy__c;
                    claim.CSS_WS_Warranty_Start_Date__c = rescues[0].CSS_WS_Warranty_Start_Date__c;
                    claim.CSS_WS_Years_On_Service__c = rescues[0].CSS_WS_Years_In_Service__c;
                    claim.CSS_WS_RescueNumber__c = rescues[0].Name;
                    claim.CSS_WS_Warranty_Type__c = 'Motor';
                    claim.CSS_WS_Warranty_Subtype__c = 'No BIS';
                    claim.CSS_WS_Multi_ESN__c = false;
                    claim.CSS_WS_Account_Code__c = 'P101';
                    claim.CSS_WS_Claim_Status__c = 'Draft';
                    claim.CSS_WS_Policy_Flag__c = 'Policy';
                    claim.CSS_WS_Belongs_To__c = 'DR';
                    claim.CSS_WS_Service_Order_Counter_Flag__c = 1;
                    if (claim_p89 == true){
                        claim.CSS_WS_Travel_Paid_Before__c = true;
                    }
                    
                    // Calculate Repair Days
                    if(claim.CSS_WS_Failure_Date_Time__c != null && claim.CSS_WS_End_Repair_Date_Time__c != null){
                        if(claim.CSS_WS_Failure_Date_Time__c > claim.CSS_WS_End_Repair_Date_Time__c){
                            claim.CSS_WS_End_Repair_Date_Time__c = null;
                        } else {//Calculate the Repair Days
                            Date ini = claim.CSS_WS_Failure_Date_Time__c.date();
                            Double i = 0;
                            Double ih = 0;
                            while(ini != claim.CSS_WS_End_Repair_Date_Time__c.date()){
                                ini = ini.addDays(Integer.valueOf(i));
                                if(ini == claim.CSS_WS_End_Repair_Date_Time__c.date()){
                                    break;
                                } else {
                                    ini = claim.CSS_WS_Failure_Date_Time__c.date();  
                                    i = i + 1;
                                }
                            }
                            ih = i; 
                            DateTime inihrs = claim.CSS_WS_Failure_Date_Time__c;
                            i = 0;
                            while(inihrs.hour() != claim.CSS_WS_End_Repair_Date_Time__c.hour()){
                                inihrs = inihrs.addHours(Integer.valueOf(i));
                                if(inihrs.hour() == claim.CSS_WS_End_Repair_Date_Time__c.hour()){
                                    break;
                                } else {
                                    inihrs = claim.CSS_WS_Failure_Date_Time__c;  
                                    i = i + 1;
                                }
                            }
                            i = (i/24);
                            ih = ih + i;
                            claim.CSS_WS_Repair_Days__c = ih;
                            claim.CSS_WS_Repair_Days__c = (claim.CSS_WS_Repair_Days__c).setScale(1);
                        }
                    }
                    
                    // To obtain what kind of user is creating the claim
                    if(userinfo.getUserType() == 'PowerCustomerSuccess'){
                       Contact userContact = [SELECT Account.Name FROM Contact WHERE Id In (SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId())];
                       Account userAccount = [SELECT IAM_Service_Provider_Code__c, CSS_DBCode__c, TYPE, CSS_WS_Paccar_DLR_Flag__c FROM Account WHERE Account.Name =: userContact.Account.Name 
                                           AND (type = 'Dealer Account' OR type = 'Dealer Branch Account' OR type = 'Distributor Branch Account' OR type = 'Distributor Account') AND CMI_Account_Status__c = 'Active'];
                       if(userAccount != null){
                           if(userAccount.Type == 'Distributor Account' || userAccount.Type == 'Distributor Branch Account'){
                               claim.CSS_WS_Login_Variable__c='DRLoggedIn';
                           } else if(userAccount.Type == 'Dealer Account' || userAccount.Type == 'Dealer Branch Account'){
                               claim.CSS_WS_Login_Variable__c='DealerLoggedIn';
                           }
                       }
                    } else {
                        claim.CSS_WS_Login_Variable__c='FactoryLoggedIn';
                    }
                                                       
                    // Save new claim record
                    insert claim;                
                    claim.Name = [SELECT CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Claim_Number__c;
                    update claim;                
                    
                    // save Id of claim into the Rescue record for Claim and Claim Service Order
                    rescues[0].CSS_WS_Claim_Service_Order__c = claim.Id;
                    if (related_claim == false){
                        rescues[0].CSS_WS_Warranty_Relationship__c = claim.Id;
                    }
                    update rescues[0];
                    
                    System.debug('New claim record: '+ claim);
                    // Obtain Id of new created claim record
                    claim_Id = claim.Id;
                }else{
                    System.debug('Rescue has been used in another Warranty/Policy Claim different than P89');
                }                                
            } else {
                System.debug('Query does not provide results');
            }             
        } catch(System.Exception e){
            System.debug('Error creating Service Order claim: '+e.getMessage());
        }
        system.debug('claim id: ' + claim_id);
        return claim_Id;
    }
}