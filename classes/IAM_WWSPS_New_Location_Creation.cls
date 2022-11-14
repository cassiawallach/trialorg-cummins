/*************************************************************************************
Name:  IAM_WWSPS_New_Location_Creation
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Create and update account from the data received from WWSPS
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Shubhnagi Sardar          12/16/2020        INITIAL DEVELOPMENT 
1.1      Brant Logan               03/20/2021        Made changes for capturing extra attributes.
1.2      Sandeep Vuyyuri           02/02/2021        Changed Cummins Fully Owned to Cummisn Wholly Owned     
1.3      Ravi Sakali               06/18/2021        Added new attributes
1.4      Lavanya Javvadi           01/25/2022        Added billing address same as physical address
1.5      Ganesh K M                06/01/2022        Made changes to ServiceLevel and DTNA field logic
**************************************************************************************
**************************************************************************************/
public class IAM_WWSPS_New_Location_Creation{
    
    /* This method is called when Action from WWSPS = New */
    public static String createWWSPSlocation(IAM_WWSPS_Location_Parser.locationInfo location) {        
        System.debug('Printing Service PRovider code information'+ location.SPCode);
        List<Account> accList = IAM_WWSPS_Utility.getWWSPSLocationAccountDetails(location.SPCode);
        if(accList.isEmpty()) {
            // New Location in IAM
            createAccount(location);            
        } else {
            // Update existing location in IAM for different BU
            updateAccount(location, accList[0]);
        }
        return 'Location added successfully in IAM';
    }
    
    /* This method is called when Action from WWSPS = Change */
    public static String updateWWSPSlocation(IAM_WWSPS_Location_Parser.locationInfo location) {
        System.debug('Printing Service PRovider code information'+ location.SPCode);
        List<Account> accList = IAM_WWSPS_Utility.getWWSPSLocationAccountDetails(location.SPCode);
        if(accList.isEmpty()) {
            return 'Location is not avilable in IAM';        
        } else {
            // Update existing location in IAM
            updateAccount(location, accList[0]);
            return 'Location updated successfully in IAM';
        }        
    }
    
    /* Create accounts when location.Action = New */
    private static void createAccount(IAM_WWSPS_Location_Parser.locationInfo location) {
        Account acc = new Account();
        acc.IAM_Service_Provider_Code__c = location.SPcode;
        acc.Type = IAM_WWSPS_Utility.getTypeFromCOD(location.COD);
        if(location.SPcode == location.DistributorCode) {
            getParentBasedOnRegion(location.DistributorRegion, acc);
        } else {
            getParentBasedOnDistCode(location.DistributorCode, acc);
        }
        acc = getAccount(location, acc);
        System.debug('### Before Acc Insert '+acc);
        insert acc;
        System.debug('### After Acc Insert '+acc);
        createCUMPASAccountFeatureAccess(acc.Id);
    }
    
    /* Update accounts when (location.Action = Changed) OR (location.Action = New && Business Entity Name is Changed) */
    private static void updateAccount(IAM_WWSPS_Location_Parser.locationInfo location, Account acc) {
        if(acc.CSS_DistributorCode__c != location.DistributorCode) {
            List<Account> parentAcc = getParentBasedOnDistCode(location.DistributorCode, acc);
            if(parentAcc.isEmpty()) {
                getParentBasedOnRegion(location.DistributorRegion, acc);
            }
        } 
        acc = getAccount(location, acc);
        /* While populating Account Type, we need to consider sequence of values from 
        * 1. EBU, 2. PSBU, 3. Filtration, 4. Turbo Channel of Distribution */
        if(String.isNotBlank(acc.EBU_Channel_of_Distribution__c)) {
            acc.Type = IAM_WWSPS_Utility.getTypeFromCOD(acc.EBU_Channel_of_Distribution__c);
        } else if(String.isNotBlank(acc.PSBU_Channel_of_Distribution__c)) {
            acc.Type = IAM_WWSPS_Utility.getTypeFromCOD(acc.PSBU_Channel_of_Distribution__c);
        } else if(String.isNotBlank(acc.IAM_Filtration_Channel_Of_Distribution__c)) {
            acc.Type = IAM_WWSPS_Utility.getTypeFromCOD(acc.IAM_Filtration_Channel_Of_Distribution__c);
        } else if(String.isNotBlank(acc.Turbo_Channel_Of_Distribution__c)) {
            acc.Type = IAM_WWSPS_Utility.getTypeFromCOD(acc.Turbo_Channel_Of_Distribution__c);
        }
        System.debug('### Before Acc Update '+acc);
        update acc;
        System.debug('### After Acc Update '+acc);
        createCUMPASAccountFeatureAccess(acc.Id);
    }
    
    /* Populate Account details as per payload values in RestRequest */
    private static Account getAccount(IAM_WWSPS_Location_Parser.locationInfo location, Account acc) {
        acc.Name = location.ServiceProviderName;
        acc.ShippingStreet = location.PhysicalAddress;
        acc.ShippingCity = location.City;
        acc.ShippingState = location.State;
        acc.ShippingCountry = location.Country;
        acc.ShippingPostalCode = location.ZipCode;
		
		/*Billing Address Population Change By Lavanya: START*/
		acc.BillingStreet = location.PhysicalAddress;
        acc.BillingCity = location.City;
        acc.BillingState = location.State;
        acc.BillingCountry = location.Country;
        acc.BillingPostalCode = location.ZipCode;
		/*Billing Address Population Change By Lavanya: END*/
		
        acc.Phone = location.Phone;        
        acc.CSS_DBCode__c = location.ResposibleBranchCode;
        acc.AccountSource = 'WWSPS';
        acc.Ownership = location.OwnershipName;
        acc.CSS_DistributorCode__c = location.DistributorCode;
        acc.IAM_WWSPS_Regions__c = location.DistributorRegion;
        acc.CMI_Account_Status__c = Label.IAM_Status_Active;
        acc.IAM_Movex_Customer_Code__c = location.CustomerNumber;
        acc.IAM_Order_Management_Account_Name__c = location.CustomerName;
        // Made changes by Ravi on - 06/14/2021
        acc.IAM_Partner_Location_Code__c = location.AlternatePartnerId;
        acc.OSM_SW_Responsible_Region__c = location.ResponsibleRegionCode;
        // Made changes by Ravi on -  06/14/2021
        //Logan changes: 3/10/2021 - changes below three fields        
        acc.EngineRangeDesc__c = location.engineRangeDesc;
        //End of changes
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        /*1) Engines, 2) Power Generation, 3) Turbochargers, and 4) Filtration.*/
        if(location.Buss_entity_name.equalsIgnoreCase('Engines')) {
            acc.EBU_Channel_of_Distribution__c = location.COD;
            //Made changes for WWSPS Service level Change request - 06/01/2022
            if(String.isNotEmpty(location.dtna)){
                if(location.dtna.equalsIgnoreCase('Y')){
                    acc.DTNA__c = true;
                }else if(location.dtna.equalsIgnoreCase('N')){
                    acc.DTNA__c = false;
                }
            }
            acc.serviceLevel__c = location.serviceLevel;
            //  End of WWSPS Service level change request.          
        } else if(location.Buss_entity_name.equalsIgnoreCase('Power Generation')) {
            acc.PSBU_Channel_of_Distribution__c = location.COD;
        } else if(location.Buss_entity_name.equalsIgnoreCase('Filtration')) {
            acc.IAM_Filtration_Channel_Of_Distribution__c = location.COD;
        } else if(location.Buss_entity_name.equalsIgnoreCase('Turbochargers')) {
            acc.Turbo_Channel_Of_Distribution__c = location.COD;
        } 
        // Made changes by sandeep vuyyuri on - 02/02/2021
        if(String.isNotBlank(location.OwnershipName) && location.OwnershipName == 'Cummins Wholly Owned') { 
            acc.IAM_Internal_Account__c = true;
        }
        // Made changes by sandeep vuyyuri on - 02/02/2021
        return acc;
    }
    
    /* Return parent Account based on Distributor Region */
    private static void getParentBasedOnRegion(String regionName, Account acc) {
        System.debug('#### IN HQ Locations ');
        List<Account> parentAcc = IAM_WWSPS_Utility.getRegionalParentAccount(regionName);
        System.debug('#### IN HQ parentAcc '+parentAcc);
        if(!parentAcc.isEmpty()) {
            acc.ParentId = parentAcc[0].Id;
        }
        User adminWWSPS = IAM_WWSPS_Utility.getWWSPSAdminUser();
        System.debug('#### IN HQ adminWWSPS '+adminWWSPS);
        if(adminWWSPS != null) {
            acc.OwnerId = adminWWSPS.Id; 
        }
    }
    
    /* Return parent Account based on Distributor Code */
    private static List<Account> getParentBasedOnDistCode(String distributorCode, Account acc) {
        List<Account> parentAcc = IAM_WWSPS_Utility.getWWSPSLocationAccountDetails(distributorCode);
        if(!parentAcc.isEmpty()) {
            acc.ParentId = parentAcc[0].Id;
            acc.OwnerId = parentAcc[0].OwnerId;
        }
        return parentAcc;
    }
    
    private static void createCUMPASAccountFeatureAccess(Id accId) {
        List<Account> accList = [
            SELECT Id
            	 , Type
            	 , CreatedDate
            	 , IAM_Movex_Customer_Code__c
              FROM Account
             WHERE Id =: accId
        ];
        System.debug('#### accList - '+accList);
        List<IAM_Application__c> appList = [
            SELECT Id
              FROM IAM_Application__c
             WHERE IAM_Application_Name__c = 'CUMPAS 2.0'
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND IAM_Account_Name__c = :accId
        ];
        System.debug('#### appList - '+appList);
        if(!accList.isEmpty() && String.isNotBlank(accList[0].IAM_Movex_Customer_Code__c) && appList.isEmpty()) {
            System.debug('#### IN - ');
            Date startDate = Date.valueOf(accList[0].CreatedDate);
            Set<String> moduleSet = IAM_WWSPS_Utility.getPicklistValues('IAM_Cumpas_Modularity__c','IAM_Application__c');
            String modules = moduleSet.toString();
            modules = modules.replace(',', ';');
            IAM_Application__c app = new IAM_Application__c();
            app.IAM_Account_Name__c = accList[0].Id;
            app.IAM_Application_Name__c = 'CUMPAS 2.0';
            app.IAM_Subscription_Start_Date__c = startDate;
            app.IAM_Subscription_End_Date__c = startDate.addYears(100);
            app.IAM_Subscription_Count__c = Integer.valueof(System.Label.IAM_Default_App_Subscription_Count.trim());
            app.IAM_Free_Subscription__c = true;
            app.IAM_Source__c = 'IAM';
            app.IAM_Status__c = Label.IAM_Status_Active;
            //app.IAM_Cumpas_Modularity__c = modules;
            app.IAM_Cumpas_Modularity__c = 'View Credit;Core Returns;Core Swap;Parts Order;Parts Inquiry;Price Extract';
            if(accList[0].Type == 'Distributor Account' || accList[0].Type == 'Distributor Branch Account') {
                app.IAM_Role__c = 'Distributor Admin;Distributor Sales Representative;Distributor Sales Manager;Distributor Customer Support Representative;Distributor Customer Support Manager';
                app.IAM_Cumpas_Roles__c = 'Distributor Admin;Distributor Sales Representative;Distributor Sales Manager;Distributor Customer Support Representative;Distributor Customer Support Manager';
            } else {
                app.IAM_Role__c = 'Dealer User;Dealer Admin';
                app.IAM_Cumpas_Roles__c = 'Dealer Admin';
            }
            System.debug('#### before app - '+app);
            insert app;
            System.debug('#### after app - '+app);
        }
    }
}