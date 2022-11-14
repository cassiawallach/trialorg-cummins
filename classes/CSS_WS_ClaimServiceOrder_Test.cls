@IsTest
Public Class CSS_WS_ClaimServiceOrder_Test {
    
    @isTest static void createClaimServiceOrder(){
               
        Account CustomerTest = new Account(
            Type = 'Customer',
            Name = 'Sony');
        insert CustomerTest;
               
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c(
            CSS_WS_Access_Code__c = 'B', 
            CSS_WS_Warranty_Relationship__c = null, 
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id, 
            CSS_WS_Engine_Application__c = 'AUTOMOTIVE', 
            CSS_WS_Engine_Application_Code__c = '130', 
            CSS_WS_Build_Date__c = date.parse('9/12/2016'), 
            CSS_WS_Engine_Family_Code__c = '10', 
            CSS_WS_Engine_Serial_Number__c = '79640575', 
            CSS_WS_Failure_Measure__c = 'Km', 
            CSS_WS_Failure_Point_Quantity__c = '1000', 
            CSS_WS_Lodging_Amount__c = 53.28, 
            CSS_WS_LunchAmount__c = 26.64, 
            CSS_WS_Manufacturer__c = 'ACREMASTER', 
            CSS_WS_Model_Series__c = 'C210M', 
            CSS_WS_RescueCost__c = 409.12, 
            CSS_WS_RepairEnding__c = date.parse('5/5/2018'), 
            CSS_WS_Service_Model__c = 'ISX CM871 E', 
            CSS_WS_Service_Provider_Dealer__c = '73011', 
            CSS_WS_Service_Provider_DR__c = '73011',  
            CSS_WS_Service_Provider_Name_Dealer__c = 'CUMMINS ALESSO MONTERREY', 
            CSS_WS_Service_Provider_Name_DR__c = 'CUMMINS ALESSO MONTERREY', 
            CSS_WS_ServiceRequest__c = date.parse('4/4/2018'), 
            CSS_WS_TechnicianName__c = 'Jose Ramirez Arevalo', 
            CSS_WS_TechnicianPromotion__c = '1045839', 
            CSS_WS_TowingAmount__c = null, 
            CSS_WS_TravelKmRoundTripPolicy__c = 130, 
            CSS_WS_TravelHoursRoundTripPolicy__c = 20, 
            CSS_WS_Warranty_Start_Date__c = date.parse('9/9/2017'),
            CSS_WS_Years_In_Service__c = 2);
        insert rescue;
        
        Test.startTest();
        // 
        Id test_claim_id = CSS_WS_ClaimServiceOrder.RescueToClaim(String.ValueOf(rescue.Id));
        //stem.assertEquals(test_claim_id, true);  
        System.assert(test_claim_id != null, 'P101 has been created properly');

        Test.stopTest();
    }
}