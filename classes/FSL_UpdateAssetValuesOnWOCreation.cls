/************************************************************************************
Name: FSL_UpdateAssetValuesOnWOCreation
Copyright © 2019  Cummins
=====================================================================================
=====================================================================================
Purpose: For Accept logic from SR to SO
=====================================================================================
=====================================================================================
History
-------
VERSION  AUTHOR            		DATE                DETAIL
1.0      Lochana Rajut          06/21/2022     To copy FTR attributes TransactionID and ABRFlag on Service Order Extension(Work Order) from Case
2.0      Diksha Rajpurohit      08/11/2022     Fix make and model bug.
************************************************************************************/
public with sharing class FSL_UpdateAssetValuesOnWOCreation {
    public static void updateWoDetails(List<workorder> newWoMap){
        
        //update values when repair location is inshop
        list<WorkOrder> workOrderToUpdate = new list<WorkOrder>();
        list<WorkOrder> woList = new list<WorkOrder>();
        Set<Id> idToUpdate = new Set<Id>();
        //Added by divya
        Set<Id> addressIds = new Set<Id>();
        Map<Id,Schema.Address> woWithAddress = new Map<Id,Schema.Address>();
        
        try{
            for (WorkOrder wo : newWoMap) 
            {
                idToUpdate.add(wo.Id);
                
            }
            woList = [select id, AccountId,Type__c,EVL_DX_SONumber__c,Repair_Location__c,Shop_Work_Order__c,Repair_Site_Address__c,
                      ContactId,ServiceTerritoryId,Dealer_Unit_Number__c,Mileage_Measure__c, 	// Mileage Measure field added by Sriprada for VGRS2-200 as it throws exception in updating fields of WO
                      //Asset Values
                      AssetId,Asset.AccountId,Asset.ContactId,Asset.FSL_Site__c,Asset.Unit_Number__c, Asset.Registration__c,
                      Asset.Warranty_Start_Date__c, Asset.Customer_Name__c, Asset.City__c, Asset.State__c, Asset.Contact_Name__c, 
                      Asset.MoveX_Customer_Address_1__c, Asset.MoveX_Customer_Address_2__c, Asset.MoveX_Customer_Address_3__c, 
                      Asset.MoveX_Phone_Number__c, Asset.MoveX_Email_ID__c, Asset.Application__c, Asset.Equipment_Id__c, 
                      Asset.Make__c,Asset.Model__c,Asset.Equipment_Configuration__c, Asset.Service_Model__c,
                      Asset.FSL_Site__r.City,Asset.FSL_Site__r.State,Asset.FSL_Site__r.Country,Asset.FSL_Site__r.PostalCode,
                      Asset.FSL_Site__r.Street,
                      Asset.Account.CMI_Account_Status__c,
                      Asset.Contact.IAM_Contact_Status__c, 
                      //Repair_Site_Name
                      Repair_Site_Address__r.City, Repair_Site_Address__r.Country, Repair_Site_Address__r.State, 
                      Repair_Site_Address__r.PostalCode, Repair_Site_Address__r.Street,
                      //Service Territory
                      ServiceTerritory.City, ServiceTerritory.State, ServiceTerritory.Country, ServiceTerritory.PostalCode, 
                      ServiceTerritory.Street, ServiceTerritory.Mileage_Measure__c,
                      //Contact
                      Contact.FirstName,Contact.LastName,Contact.Email,Contact.Phone, 
                      
                      //Case
                      Case.Id,                              
                      //Account
                      Account.Name, Account.BillingCity, Account.BillingState, Account.BillingStreet, Account.BillingPostalCode, 
                      Account.BillingCountry, Account.RecordTypeId, Account.RecordType.DeveloperName,
                      Case.FSL_ABRFlag__c, Case.FSL_TransactionID__c
                      
                      from workorder where Id IN: idToUpdate];
            
            //*** CT2-927 -Added by Mallika as part of Code Optimization - Starts
            Map<Id,List<Case>> workOrderIdVsCase = woRelatedCaseMap(woList);
            List<Service_Order_Extension__c> woExtInsert = new List<Service_Order_Extension__c>();
            
            //*** Added by Mallika as part of Code Optimization - Ends
            //Added by Divyasri
            for(workOrder wo: woList){
               addressIds.add(wo.Asset.FSL_Site__c);
            }
           List<Schema.Address> addressList1 = new List<Schema.Address>();
            addressList1 =   [Select id,city,state,postalCode,Street,country from Address where id in :addressIds];
            for(Schema.Address saddress :addressList1){
                woWithAddress.put(saddress.Id,saddress);
            }
            //Fetching record from Feature Switch Matrix
            List<FSL_Switch__c> lstFeatureMatrix = [SELECT Id, Name, IsActive__c FROM FSL_Switch__c 
                                                    WHERE Name = 'Enable_FTR_Switch' LIMIT 1];
            for(workOrder wo: woList){
                WorkOrder wor = new WorkOrder();
                wor.Id = wo.id;
                // 1.0 STARTS
                Service_Order_Extension__c soExtention = new  Service_Order_Extension__c();                      
                soExtention.Service_Order_Id__c = wo.id;
                //Adding Event Type parameter when Feature Switch Matrix record for RSW is active
                if(lstFeatureMatrix.size() > 0 && lstFeatureMatrix[0].IsActive__c) {
                    soExtention.FSL_ABRFlag__c = wo.Case.FSL_ABRFlag__c;
                    soExtention.FSL_TransactionID__c = wo.Case.FSL_TransactionID__c;
                }
                woExtInsert.add(soExtention);
                //1.0 ENDS

                if(wo.Type__c == 'Dealer' && wo.AssetId != null){
                    //Condition-1
                    //Assign Asset Values
                    wor = updateAssetWorkOrderFields(wo,workOrderIdVsCase);
                    workOrderToUpdate.add(wor);  
                    continue;//Dont execute any of the below conditions if this is satisfied.
                }
                
                switch on wo.Repair_Location__c{
                    //Block to check conditions when repair location is Mobile.
                    when 'Mobile' {
                        //Condition 1
                        if(wo.AssetId != null && wo.AccountId== null){
                            //Assign Asset Values
                            wor = updateAssetWorkOrderFields(wo,workOrderIdVsCase);
                            
                            
                            //START-----Code added by Naveen Goud --- PHOEN-205 ------
                            string accid = '';
                            string conid = '';
                            if(wo.Asset.AccountId != null ){
                                accid = wo.Asset.Account.CMI_Account_Status__c;
                                wor.AccountId = (accid != 'Inactive' ? wo.Asset.AccountId : (wo.AccountId != null ? wo.AccountId : null));                            
                            }
                            if(wo.Asset.ContactId != null ){
                                accid = wo.Asset.Account.CMI_Account_Status__c; // fix by diksha vgrs2-709// fix by diksha vgrs2-709
                                conid = wo.Asset.Contact.IAM_Contact_Status__c;
                                wor.ContactId = (conid != 'Inactive' && accid != 'Inactive'? wo.Asset.ContactId : (wo.ContactId != null ? wo.ContactId : null)); // fix by diksha vgrs2-709
                            }
                           	// wor.AccountId = (wo.Asset.AccountId != null ? wo.Asset.AccountId : (wo.AccountId != null ? wo.AccountId : null));
                          	//  wor.ContactId = (wo.Asset.ContactId != null ? wo.Asset.ContactId : (wo.ContactId != null ? wo.ContactId : null));
                           	//END-----Code added by Naveen Goud --- PHOEN-205 ------ 
                            wor.Repair_Site_Address__c = (wo.Asset.FSL_Site__c != null ? wo.Asset.FSL_Site__c : (wo.Repair_Site_Address__c != null ? wo.Repair_Site_Address__c : null));     
                            
                            system.debug('wo.ContactId >'+wo.ContactId +'wo.AccountId'+wo.AccountId+'wo.Account.RecordType.DeveloperName>>'+wo.Account.RecordType.DeveloperName);
                            if(wo.Asset.Customer_Name__c != null){
                                wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                                wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                                wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                                wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                                wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                                wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                                wor.Customer_City__c   = wo.Asset.City__c;
                                wor.Customer_State__c = wo.Asset.State__c;                                                   
                            }

                            //Added by Divyasri to update Address from Repair Site
                            if(woWithAddress.keyset().size()>0){
                                wor.City  = woWithAddress.get(Wo.Asset.FSL_Site__c).City;
                                wor.State = woWithAddress.get(Wo.Asset.FSL_Site__c).State;
                                wor.Country = woWithAddress.get(Wo.Asset.FSL_Site__c).Country;
                                wor.PostalCode = woWithAddress.get(Wo.Asset.FSL_Site__c).PostalCode;
                                wor.Street = woWithAddress.get(Wo.Asset.FSL_Site__c).Street;
                                }
                                                  
                            // Call the Flow
                          Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                            
                        }
                        //Condition 2
                        else if(wo.AssetId != null && wo.AccountId != null && wo.AccountId == wo.Asset.AccountId){
                            //Assign Asset Values
                            wor = updateAssetWorkOrderFields(wo,workOrderIdVsCase);
                            
                            wor.AccountId = wo.AccountId;
                            wor.ContactId = (wo.ContactId != null ? wo.ContactId : null);
                            wor.Repair_Site_Address__c = (wor.Repair_Site_Address__c != null ? wor.Repair_Site_Address__c : null);     
                            if(wo.Asset.Customer_Name__c != null){
                                wor.Customer_Name__c = wo.Asset.Customer_Name__c; 
                                wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                                wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                                wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                                wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                                wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                                wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                                wor.Customer_City__c   = wo.Asset.City__c;
                                wor.Customer_State__c = wo.Asset.State__c;                                                   
                            }
                            
                            else {
                                if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Customer_Name__c = wo.Account.Name; 
                                    wor.Customer_City__c   = wo.Account.BillingCity;
                                    wor.Customer_Country__c = wo.Account.BillingCountry;
                                    wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                    wor.Customer_State__c = wo.Account.BillingState;                            
                                }  
                                if(wo.ContactId != null && wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                    wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                    wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;      
                                }
                                
                            }
                            
                            //Address update from Repair Site
                            if(wo.Repair_Site_Address__c != null){
                                wor.City  = wo.Repair_Site_Address__r.City;
                                wor.Country = wo.Repair_Site_Address__r.Country;
                                wor.State = wo.Repair_Site_Address__r.State;
                                wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                                wor.Street = wo.Repair_Site_Address__r.Street;
                            }
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();                    
                        }
                        //Condition 3
                        else if(wo.AssetId != null && wo.AccountId != null && wo.AccountId != wo.Asset.AccountId){
                            //Assign Asset Values
                            wor = updateAssetWorkOrderFields(wo,workOrderIdVsCase);
                            
                            wor.AccountId = wo.AccountId;
                            wor.ContactId = (wo.ContactId != null ? wo.ContactId : null);
                            wor.Repair_Site_Address__c = (wor.Repair_Site_Address__c != null ? wor.Repair_Site_Address__c : null);     
                            
                            if(wo.Asset.Customer_Name__c != null){
                                wor.Customer_Name__c = wo.Asset.Customer_Name__c; 
                                wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                                wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                                wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                                wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                                wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                                wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                                wor.Customer_City__c   = wo.Asset.City__c;
                                wor.Customer_State__c = wo.Asset.State__c;                                                   
                            }
                            else {
                                if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Customer_Name__c = wo.Account.Name; 
                                    wor.Customer_City__c   = wo.Account.BillingCity;
                                    wor.Customer_Country__c = wo.Account.BillingCountry;
                                    wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                    wor.Customer_State__c = wo.Account.BillingState;                            
                                }  
                                if(wo.ContactId != null && wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                    wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                    wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;      
                                }
                                
                            }
                            
                            //Address update from Repair Site
                            if(wo.Repair_Site_Address__c != null){
                                wor.City  = wo.Repair_Site_Address__r.City;
                                wor.Country = wo.Repair_Site_Address__r.Country;
                                wor.State = wo.Repair_Site_Address__r.State;
                                wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                                wor.Street = wo.Repair_Site_Address__r.Street;
                            }
                            
                        }
                        //Condition 4
                        else if(wo.AssetId == null && wo.Repair_Site_Address__c != null){
                            //Assign Asset Values
                            
                            wor.AccountId = (wo.AccountId != null ? wo.AccountId : null);
                            wor.ContactId = (wo.ContactId != null ? wo.ContactId : null);
                            wor.Mileage_Measure__c = wo.ServiceTerritory.Mileage_Measure__c;     
                            
                            if(wo.ContactId != null && wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;      
                            }
                            
                            //Address update from Repair Site
                            if(wo.Repair_Site_Address__c != null){
                                wor.City  = wo.Repair_Site_Address__r.City;
                                wor.Country = wo.Repair_Site_Address__r.Country;
                                wor.State = wo.Repair_Site_Address__r.State;
                                wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                                wor.Street = wo.Repair_Site_Address__r.Street;
                            }
                            
                            if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                wor.Customer_Address_Line1__c = wo.Account.BillingStreet;
                                wor.Customer_Name__c = wo.Account.Name; 
                                wor.Customer_City__c   = wo.Account.BillingCity;
                                wor.Customer_Country__c = wo.Account.BillingCountry;
                                wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                wor.Customer_State__c = wo.Account.BillingState;                            
                            }                        
                        }
                    }
                    //Block to check conditions when repair location is inShop.
                    when 'In Shop' {
                        //Condition 1
                        if(wo.AssetId != null && wo.AccountId == null){
                            //Assign Asset Values
                            
                            wor = updateAssetWorkOrderFields(wo,workOrderIdVsCase);
                            system.debug('Entered into INSHOP condition1::::'+wo.AssetId+'----'+wo.Asset.AccountId);
                            //START-----Code added by Naveen Goud --- PHOEN-205 ------
                            string accid = '';
                            string conid = '';
                            if(wo.Asset.AccountId != null ){
                                accid = wo.Asset.Account.CMI_Account_Status__c;
                                wor.AccountId = (accid != 'Inactive' ? wo.Asset.AccountId : null);                            
                            }
                            if(wo.Asset.ContactId != null ){
                                accid = wo.Asset.Account.CMI_Account_Status__c; // fix by diksha vgrs2-709// fix by diksha vgrs2-709
                                conid = wo.Asset.Contact.IAM_Contact_Status__c;
                                wor.ContactId = (conid != 'Inactive' && accid != 'Inactive'? wo.Asset.ContactId : (wo.ContactId != null ? wo.ContactId : null)); // fix by diksha vgrs2-709
                            }
                           // wor.AccountId = (wo.Asset.AccountId != null ? wo.Asset.AccountId : null);
                           // wor.ContactId = (wo.Asset.ContactId != null ? wo.Asset.ContactId : (wo.ContactId != null ? wo.ContactId : null));
                           //END-----Code added by Naveen Goud --- PHOEN-205 ------ 
                            if(wo.Asset.Customer_Name__c != null){
                                wor.Customer_Name__c = wo.Asset.Customer_Name__c; 
                                wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                                wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                                wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                                wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                                wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                                wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                                wor.Customer_City__c   = wo.Asset.City__c;
                                wor.Customer_State__c = wo.Asset.State__c;                                                   
                            }
                            else if(wo.ContactId != null && wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;      
                            }
                            
                            //Address update from Service Territory
                            if(wo.ServiceTerritory != null || Test.isRunningTest()){
                                wor.City  = wo.ServiceTerritory.City;
                                wor.Country = wo.ServiceTerritory.Country;
                                wor.State = wo.ServiceTerritory.State;
                                wor.PostalCode = wo.ServiceTerritory.PostalCode;
                                wor.Street = wo.ServiceTerritory.Street;
                            }  
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        //Condition 2
                        else if(wo.AssetId != null && wo.AccountId != null && wo.AccountId == wo.Asset.AccountId){
                            //Assign Asset Values
                            
                            wor = updateAssetWorkOrderFields(wo,workOrderIdVsCase);
                            
                            //START-----Code added by Naveen Goud --- PHOEN-205 ------
                            string accid = '';
                            string conid = '';
                            if(wo.Asset.AccountId != null ){
                                accid = wo.Asset.Account.CMI_Account_Status__c;
                                wor.AccountId = (accid != 'Inactive' ? wo.Asset.AccountId : null);                            
                            }
                            if(wo.Asset.ContactId != null ){
                                accid = wo.Asset.Account.CMI_Account_Status__c; // fix by diksha vgrs2-709// fix by diksha vgrs2-709
                                conid = wo.Asset.Contact.IAM_Contact_Status__c;
                                wor.ContactId = (conid != 'Inactive' && accid != 'Inactive'? wo.Asset.ContactId : (wo.ContactId != null ? wo.ContactId : null)); // fix by diksha vgrs2-709
                            }
                            
                           // wor.AccountId = (wo.Asset.AccountId != null ? wo.Asset.AccountId : null);
                           // wor.ContactId = (wo.ContactId != null ? wo.ContactId : null);
                           //END-----Code added by Naveen Goud --- PHOEN-205 ----------------------
                            if(wo.Asset.Customer_Name__c != null){
                                wor.Customer_Name__c = wo.Asset.Customer_Name__c; 
                                wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                                wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                                wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                                wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                                wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                                wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                                wor.Customer_City__c   = wo.Asset.City__c;
                                wor.Customer_State__c = wo.Asset.State__c;                                                   
                            }
                            else {
                                if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Customer_Name__c = wo.Account.Name; 
                                    wor.Customer_City__c   = wo.Account.BillingCity;
                                    wor.Customer_Country__c = wo.Account.BillingCountry;
                                    wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                    wor.Customer_State__c = wo.Account.BillingState;                            
                                }  
                                if(wo.ContactId != null && wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                    wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                    wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;      
                                }
                                
                            }
                            
                            //Address update from Service Territory
                            if(wo.ServiceTerritory != null){
                                wor.City  = wo.ServiceTerritory.City;
                                wor.Country = wo.ServiceTerritory.Country;
                                wor.State = wo.ServiceTerritory.State;
                                wor.PostalCode = wo.ServiceTerritory.PostalCode;
                                wor.Street = wo.ServiceTerritory.Street;
                            }  
                            
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        //Condition 3
                        else if(wo.AssetId != null && wo.AccountId != null && wo.AccountId != wo.Asset.AccountId){
                            //Assign Asset Values
                            
                            wor = updateAssetWorkOrderFields(wo,workOrderIdVsCase);
                            
                            wor.AccountId = (wo.AccountId != null ? wo.AccountId : null);
                            wor.ContactId = (wo.ContactId != null ? wo.ContactId : null);
                            
                            if(wo.Asset.Customer_Name__c != null){
                                wor.Customer_Name__c = wo.Asset.Customer_Name__c; 
                                wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                                wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                                wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                                wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                                wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                                wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                                wor.Customer_City__c   = wo.Asset.City__c;
                                wor.Customer_State__c = wo.Asset.State__c;                                                   
                            }
                            else {
                                if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Customer_Name__c = wo.Account.Name; 
                                    wor.Customer_City__c   = wo.Account.BillingCity;
                                    wor.Customer_Country__c = wo.Account.BillingCountry;
                                    wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                    wor.Customer_State__c = wo.Account.BillingState;                            
                                }  
                                if(wo.ContactId != null && wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                    wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                    wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                    wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;      
                                }
                                
                            }
                            
                            //Address update from Service Territory
                            if(wo.ServiceTerritory != null){
                                wor.City  = wo.ServiceTerritory.City;
                                wor.Country = wo.ServiceTerritory.Country;
                                wor.State = wo.ServiceTerritory.State;
                                wor.PostalCode = wo.ServiceTerritory.PostalCode;
                                wor.Street = wo.ServiceTerritory.Street;
                            }  
                            
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        //Condition 4
                        else if(wo.AssetId == null && wo.ServiceTerritoryId != null){
                            wor.AccountId = (wo.AccountId != null ? wo.AccountId : null);
                            wor.ContactId = (wo.ContactId != null ? wo.ContactId : null);
                            wor.Mileage_Measure__c = wo.ServiceTerritory.Mileage_Measure__c;     
                            
                            if(wo.ContactId != null && wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;      
                            }
                            
                            //Address update from Service Territory
                            if(wo.ServiceTerritory != null){
                                wor.City  = wo.ServiceTerritory.City;
                                wor.Country = wo.ServiceTerritory.Country;
                                wor.State = wo.ServiceTerritory.State;
                                wor.PostalCode = wo.ServiceTerritory.PostalCode;
                                wor.Street = wo.ServiceTerritory.Street;
                            }
                            
                            if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                wor.Customer_Address_Line1__c = wo.Account.BillingStreet;
                                wor.Customer_Name__c = wo.Account.Name; 
                                wor.Customer_City__c   = wo.Account.BillingCity;
                                wor.Customer_Country__c = wo.Account.BillingCountry;
                                wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                wor.Customer_State__c = wo.Account.BillingState;                            
                            }  
                        }
                        
                    }
                }
                workOrderToUpdate.add(wor);
                
            } 

            //1.0 STARTS
            insert woExtInsert;
            
            Map<id,Service_Order_Extension__c> extsor  = new  Map<id,Service_Order_Extension__c>();
            for(Service_Order_Extension__c ext: woExtInsert){
                extsor.put(ext.Service_Order_Id__c, ext);            
            }
            //1.0 ENDS
            //By Priyanka for VGRS2-456 (part of VGRS2-398) 

            if(workOrderToUpdate.size() > 0) {
                for(workorder  word:workOrderToUpdate)
                {
                    if(extsor != null && extsor.get(word.id) != null)
                    {
                        system.debug('testpriyan' + extsor);
                        system.debug('pppp'+extsor.get(word.id).Id+ 'wopriya' + word);
                        
                    word.Service_Order_Extension__c = extsor.get(word.id).Id;
                    }
                }
                update workOrderToUpdate; 
                
            }
            
            
        }catch(exception e){
            system.debug('Entered into catch block of updateWoDetails method in FSL_UpdateAssetValuesOnWOCreation Apex Class'+e.getLineNumber()+e.getMessage());
        }
    }
    
    public static workOrder updateAssetWorkOrderFields(workOrder wo, Map<Id,List<Case>> workOrderIdVsCase){
		List<Case> lstCS = new List<Case>();
        workOrder woRec = new workOrder();
        woRec.Id = wo.Id;
        //Asset Details on WO    
        woRec.Application__c = wo.Asset.Application__c;
        woRec.Unit_NB__c = wo.Asset.Unit_Number__c;
        woRec.Dealer_Unit_Number__c = wo.Asset.Unit_Number__c; // Added by Sriprada - 10/12/2021 as part of VGRS2-28
        woRec.Registration__c = wo.Asset.Registration__c;
        woRec.Repair_Site_Address__c=wo.Repair_Site_Address__c;//bug_CT3155
        //Added by Sriprada for handling BIS check condition for data exchange services for defect CT1-598
        if( wo.Type__c == 'Dealer' && wo.EVL_DX_SONumber__c == false){
            woRec.Before_In_Service__c = false;
        } else if( wo.Type__c != 'Dealer'){
            woRec.Before_In_Service__c = false;
        }
        // Commented by sailja, CT3-257-to update WO with case hours, mileage for IA Request
        // woRec.CSS_Hours__c = null;
        woRec.Equipment_Id__c = wo.Asset.Equipment_Id__c;
        woRec.Failure_Date__c = system.today();
        woRec.Fuel_Burn__c = null;
        woRec.Make__c = wo.Asset.Make__c;
        woRec.Model__c = wo.Asset.Model__c;
        woRec.Warranty_Start_Date__c = wo.Asset.Warranty_Start_Date__c;
        woRec.Service_Model__c = wo.Asset.Service_Model__c;
        woRec.Unit_Type__c = wo.Asset.Equipment_Configuration__c	;
        woRec.Payer_ContactID__c = null; 
        //  woRec.Mileage_Measure__c = wo.ServiceTerritory.Mileage_Measure__c;    
        // wor.Skip_WSD_VR__c = true;
        // Commented the below 3 fileds by sailja, CT3-257-to update WO with case hours, mileage for IA Request
        //  woRec.Mileage__c = null;
        // woRec.CSS_Hours__c = null;
        // added by sailaja, CT3-257 to update WO Mileage Measure with Sterritory measure value only if SR record type is not IA Request
        if(wo.CaseId!= null) {
            Id recordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();  
            //List<case> lstCS = [SELECT Id, RecordTypeId , Product_Mileage_Unit__c FROM Case WHERE Id =: wo.CaseId];
            //**  CT2-927 - by Mallika as part of Code Optimization
            if(workOrderIdVsCase.get(wo.Id) != null){
                lstCS = workOrderIdVsCase.get(wo.Id);
            }
            //** Ends
            if(lstCS != null && lstCS.size() > 0){
                if(lstCS[0].RecordTypeId!=recordTypeId){
                    if(wo.ServiceTerritory.Mileage_Measure__c != '' && wo.Type__c != 'Dealer'){
                        woRec.Mileage_Measure__c = wo.ServiceTerritory.Mileage_Measure__c;  
                    } 
                    //Added by Sriprada to populate Mileage Measure for Dealer jobs
                    else if(wo.Type__c == 'Dealer'){  
                        woRec.Mileage_Measure__c = wo.Mileage_Measure__c;  
                    }
                } 
            }
        }
        else {
            if(wo.ServiceTerritory.Mileage_Measure__c != '' && wo.Type__c != 'Dealer' ){
                woRec.Mileage_Measure__c = wo.ServiceTerritory.Mileage_Measure__c;  
            } 
            //Added by Sriprada to populate Mileage Measure for Dealer jobs
            else if(wo.Type__c == 'Dealer'){
                //  woRec.Mileage_Measure__c = wo.Mileage_Measure__c;  
            }   
            
        } 
        system.debug('woRec' + woRec);
        return woRec; 
    }
    
    /**
*** @date August 17th 2021
*** @description Returns workOrder and related Case Map
*** CT2-927 -changes by Mallika
***/
    public static Map<Id,List<Case>> woRelatedCaseMap(List<WorkOrder> workOrderList){
        Map<Id,Id> wOrderVsCaseIdMap = new Map<Id,Id>();
        Map<Id,List<Case>> workorderIdVsCase = new Map<Id,List<Case>>();
        try{
            for(WorkOrder wOrder:workOrderList){
                wOrderVsCaseIdMap.put(wOrder.Id,wOrder.CaseId);
            }
            Map<Id,Case> caseIdVsRecMap = new Map<Id,Case>([SELECT Id, RecordTypeId , Product_Mileage_Unit__c FROM Case WHERE Id =: wOrderVsCaseIdMap.values()]);
            for(WorkOrder wOrder:workOrderList){
                List<Case> caseList = new List<Case>();
                if(caseIdVsRecMap.get(wOrder.CaseId) != null)
                    caseList.add(caseIdVsRecMap.get(wOrder.CaseId));
                workorderIdVsCase.put(wOrder.Id,caseList);
            }
        }
        catch(Exception ex){
            system.debug('Exception From Server at line: '+ex.getLineNumber()+' '+'The exception is '+ex.getMessage());
        }
        return workorderIdVsCase;
    }
    
}