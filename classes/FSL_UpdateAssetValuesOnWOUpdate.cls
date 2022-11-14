/**********************************************************************
Name: FSL_UpdateAssetValuesOnWOUpdate
Copyright Â© 2021  Cummins
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -                                   INITIAL DEVELOPMENT
2.0 - Vijay/Rajkumar      07/07/2021    Added logic to update Duration and DurationType on WO and SA
***********************************************************************/
public with sharing class FSL_UpdateAssetValuesOnWOUpdate {
    
    public static void updateWoDetails(Map<Id, WorkOrder> newMap, Map<Id, WorkOrder> oldMap) {
        updateFields();
        system.debug('Inside updateWoDetails:::'+ newMap.get(newMap.values()[0].id).AssetId + 'Inside updateWoDetails:::'+  oldMap.get(oldMap.values()[0].id).AssetId);
        list<WorkOrder> woList = new list<WorkOrder>(newMap.values());
        list<WorkOrder> workOrderToUpdate = new list<WorkOrder>();
        List<ServiceAppointment> lstSA = new List<ServiceAppointment>(); //Added to avoid Flow Error as part of Trigger re design
        
        woList = [SELECT Id, EVL_DX_SONumber__c,AccountId,Type__c,Repair_Location__c,Shop_Work_Order__c,Repair_Site_Address__c,
                  ContactId,ServiceTerritoryId,Mileage_Measure__c,Warranty_Start_Date__c,
                  //Asset Values
                  AssetId,Asset.AccountId,Asset.ContactId,Asset.FSL_Site__c, Asset.Unit_Number__c, Asset.Registration__c, WorkTypeId, WorkType.EstimatedDuration, WorkType.DurationType,
                  Asset.Warranty_Start_Date__c, Asset.Customer_Name__c, Asset.City__c, Asset.State__c, Asset.Contact_Name__c, 
                  Asset.MoveX_Customer_Address_1__c, Asset.MoveX_Customer_Address_2__c, Asset.MoveX_Customer_Address_3__c, 
                  Asset.MoveX_Phone_Number__c, Asset.MoveX_Email_ID__c, Asset.Application__c, Asset.Equipment_Id__c, 
                  Asset.Make__c,Asset.Model__c,Asset.Equipment_Configuration__c, Asset.Service_Model__c,
                  Asset.FSL_Site__r.City,Asset.FSL_Site__r.State,Asset.FSL_Site__r.Country,Asset.FSL_Site__r.PostalCode,
                  Asset.FSL_Site__r.Street,
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
                  Account.BillingCountry, Account.RecordTypeId, Account.RecordType.DeveloperName, Duration, DurationType,
                  (Select Id, Duration, DurationType, StatusCategory from ServiceAppointments) //Added to avoid Flow Error as part of Trigger re design
                  FROM WorkOrder WHERE Id IN: newMap.KeySet()];
        system.debug('workType Fields>>>'+woList[0].WorkType.EstimatedDuration+' '+woList[0].WorkType.DurationType);
        
        for (WorkOrder wo : woList) {
            
            // Vijay/Rajkumar - Added below logic to update Duration and DurationType of SA to avoid Flow Error as part of Trigger re design - START
            for(ServiceAppointment SA: wo.ServiceAppointments){
                
                ServiceAppointment saRec = new ServiceAppointment();
                if(SA.StatusCategory == 'None'){
                    if(newMap.get(wo.Id).WorkTypeId != null && oldMap.get(wo.Id).WorkTypeId != newMap.get(wo.Id).WorkTypeId){
                        saRec.Id = SA.Id;
                        saRec.Duration = wo.WorkType.EstimatedDuration;
                        saRec.DurationType = wo.WorkType.DurationType;
                        lstSA.add(saRec);
                	}
                    else if(newMap.get(wo.Id).Duration != oldMap.get(wo.Id).Duration){
                        saRec.Id = SA.Id;
                        saRec.Duration = wo.Duration;
                        saRec.DurationType = wo.DurationType;
                        lstSA.add(saRec);
                    }
                }
            }
            // Vijay/Rajkumar - Added below logic to update Duration and DurationType of SA to avoid Flow Error as part of Trigger re design - START
            
            WorkOrder wor = new WorkOrder();
            wor.Id = wo.Id; 
            // Vijay/Rajkumar- Added below code to update Duration and DurationType from WorkType to avoid Flow Error as part of trigger re design - START
            if(newMap.get(wo.Id).WorkTypeId != null && oldMap.get(wo.Id).WorkTypeId != newMap.get(wo.Id).WorkTypeId){
                if(newMap.get(wo.Id).Duration == oldMap.get(wo.Id).Duration ){
                    wor.Duration = wo.WorkType.EstimatedDuration;
                    wor.DurationType = wo.WorkType.DurationType;
            	}
            }
            // Vijay/Rajkumar - Added below code to update Duration and DurationType from WorkType to avoid Flow Error as part of trigger re design - END
        
            
            System.debug('wo.Type__c::'+ wo.Type__c+ ':: wo.AssetId::'+ wo.AssetId + ':: oldMap.get(wo.Id).AssetId::'+ oldMap.get(wo.Id).AssetId + 'wo.Repair_Location__c::'+ wo.Repair_Location__c);
            if(wo.Type__c == 'Dealer' && wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId) {
                //Condition-1
                //Assign Asset Values
                wor = updateAssetWorkOrderFields(wo);
                if(wo.Asset.Warranty_Start_Date__c != null) {
                    wor.Warranty_Start_Date__c = wo.Asset.Warranty_Start_Date__c;
                } else {
                    wor.Warranty_Start_Date__c = null;
                }
                unskipValidationRule(wor);
                workOrderToUpdate.add(wor);
                continue;//Dont execute any of the below conditions if this is satisfied.
            }
           
            if(wo.Type__c != 'Dealer') {
                switch on wo.Repair_Location__c {
                    //Block to check conditions when repair location is Mobile.
                    when 'Mobile' {
                        //Condition-1
                        system.debug('wo.AssetId >>>>' + wo.AssetId);
                        system.debug('oldMap.get(wo.Id).AssetId >>>>' + oldMap.get(wo.Id).AssetId);
                        if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Asset.AccountId != null){
                            //Assign Asset Values
                            wor = updateAssetWorkOrderFields(wo);
                            
                            //CT3-289, Dinesh Yadav
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){
                                wor.AccountId = wo.AccountId;
                                wor.ContactId = wo.ContactId;
                                wor.Repair_Site_Address__c = wo.Repair_Site_Address__c;
                            } 
                            else if (wo.Shop_Work_Order__c == null && wo.Asset.AccountId != null){
                                wor.AccountId = wo.Asset.AccountId;
                                if(wo.Asset.ContactId != null){
                                    wor.ContactId = wo.Asset.ContactId;       
                                }
                                if(wo.Asset.FSL_Site__c != null){
                                    wor.Repair_Site_Address__c = wo.Asset.FSL_Site__c;       
                                }
                            }
                            else{
                                wor.AccountId = null;
                                wor.ContactId = null;
                                wor.Repair_Site_Address__c = null;
                            }
                            if(wo.Asset.Warranty_Start_Date__c != null){
                                wor.Warranty_Start_Date__c = wo.Asset.Warranty_Start_Date__c;
                            } else{
                                wor.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                            if(wo.Asset.Customer_Name__c != null){
                                wor.Customer_Name__c = wo.Asset.Customer_Name__c; 
                                wor.Customer_City__c   = wo.Asset.City__c;
                                wor.Customer_State__c = wo.Asset.State__c;
                                wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                                wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                                wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                                wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                                wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                                wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
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
                            if(wo.Asset.FSL_Site__c != null){
                                wor.City  = wo.Asset.FSL_Site__r.City;
                                wor.State = wo.Asset.FSL_Site__r.State;
                                wor.Country = wo.Asset.FSL_Site__r.Country;
                                wor.PostalCode = wo.Asset.FSL_Site__r.PostalCode;
                                wor.Street = wo.Asset.FSL_Site__r.Street;
                            }
                            
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId &&  wo.Asset.AccountId != null) { // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            wor.Make__c = wo.Asset.Make__c;
                            wor.Model__c = wo.Asset.Model__c;
                            wor.Service_Model__c = wo.Asset.Service_Model__c;   
                            //added by sravanthi
                            if(wo.Repair_Site_Address__c != null){
                                wor.City  = wo.Repair_Site_Address__r.City;
                                wor.State = wo.Repair_Site_Address__r.State;
                                wor.Country = wo.Repair_Site_Address__r.Country;
                                wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                                wor.Street = wo.Repair_Site_Address__r.Street;
                            }
                            else if(wo.Repair_Site_Address__c == null && wo.Asset.FSL_Site__c != null){
                                wor.City  = wo.Asset.FSL_Site__r.City;
                                wor.State = wo.Asset.FSL_Site__r.State;
                                wor.Country = wo.Asset.FSL_Site__r.Country;
                                wor.PostalCode = wo.Asset.FSL_Site__r.PostalCode;
                                wor.Street = wo.Asset.FSL_Site__r.Street;
                            }
                        }
                        //Condition - 2
                        else if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Asset.AccountId == null){
                            //Assign Asset Values
                            wor = updateAssetWorkOrderFields(wo);
                            //CT3-289, Dinesh Yadav
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){
                                wor.AccountId = wo.AccountId;
                                wor.ContactId = wo.ContactId;
                                wor.Repair_Site_Address__c = wo.Repair_Site_Address__c;
                            } else{
                                wor.AccountId = null;
                                wor.ContactId = null;
                                wor.Repair_Site_Address__c = null;
                            }
                            if(wo.Asset.Warranty_Start_Date__c != null){
                                wor.Warranty_Start_Date__c = wo.Asset.Warranty_Start_Date__c;
                            } else{
                                wor.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                            wor.Customer_Name__c = wo.Asset.Customer_Name__c;  
                            wor.Customer_City__c   = wo.Asset.City__c;
                            wor.Customer_State__c = wo.Asset.State__c;
                            wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                            wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                            wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                            wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                            wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                            wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                            
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId &&  wo.Asset.AccountId == null){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            wor.Make__c = wo.Asset.Make__c;
                            wor.Model__c = wo.Asset.Model__c;
                            wor.Service_Model__c = wo.Asset.Service_Model__c;
                            //added by sravanthi
                            if(wo.Repair_Site_Address__c != null){
                                wor.City  = wo.Repair_Site_Address__r.City;
                                wor.State = wo.Repair_Site_Address__r.State;
                                wor.Country = wo.Repair_Site_Address__r.Country;
                                wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                                wor.Street = wo.Repair_Site_Address__r.Street;
                            }
                        }
                        //Condition - 3
                        else if(wo.AssetId == null && wo.Repair_Site_Address__c != null && wo.Repair_Site_Address__c == oldMap.get(wo.Id).Repair_Site_Address__c){
                            
                            //Cash Customer Details
                            if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                wor.Customer_Name__c = wo.Account.Name;  
                                wor.Customer_City__c   = wo.Account.BillingCity;
                                wor.Customer_State__c = wo.Account.BillingState;
                                wor.Customer_Address_Line1__c = wo.Account.Billingstreet;
                                wor.Customer_Country__c = wo.Account.BillingCountry;
                                wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                if(wo.ContactId != null){
                                    wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                    wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                    wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;  
                                } else{
                                    wor.Cash_Customer_Contact_Name__c = '';
                                    wor.Cash_Customer_Contact_Email__c = '';
                                    wor.Cash_Customer_Contact_Phone__c = '';
                                }
                            } 
                            else {
                                wor.Customer_Name__c = '';  
                                wor.Customer_City__c   = '';
                                wor.Customer_State__c = '';
                                wor.Customer_Address_Line1__c ='';
                                wor.Customer_Address_Line2__c = '';
                                wor.Customer_Address_Line3__c = '';
                                wor.Cash_Customer_Contact_Name__c = '';
                                wor.Cash_Customer_Contact_Email__c = '';
                                wor.Cash_Customer_Contact_Phone__c = '';
                            }
                            //Address update on WO
                            wor.City  = wo.Repair_Site_Address__r.City;
                            wor.State = wo.Repair_Site_Address__r.State;
                            wor.Country = wo.Repair_Site_Address__r.Country;
                            wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                            wor.Street = wo.Repair_Site_Address__r.Street;
                            
                        }
                        //Condition - 4 (Wo-Addres update when Repair Site is null and is changed)
                        else if(wo.AssetId != null && wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Repair_Site_Address__c == null &&  wo.Repair_Site_Address__c != oldMap.get(wo.Id).Repair_Site_Address__c && wo.AccountId != null  && wo.Repair_Location__c != oldMap.get(wo.Id).Repair_Location__c ){
                            if(wo.Repair_Site_Address__c != null){
                                wor.City  = wo.Repair_Site_Address__r.City;
                                wor.State = wo.Repair_Site_Address__r.State;
                                wor.Country = wo.Repair_Site_Address__r.Country;
                                wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                                wor.Street = wo.Repair_Site_Address__r.Street;
                            }
                        }
                        //Condition - 5 (Wo-Address update when Repair Site is changed & not blank)
                        else if(wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Repair_Site_Address__c != null && wo.Repair_Site_Address__c != oldMap.get(wo.Id).Repair_Site_Address__c && wo.Repair_Location__c == oldMap.get(wo.Id).Repair_Location__c){
                            wor.City  = wo.Repair_Site_Address__r.City;
                            wor.State = wo.Repair_Site_Address__r.State;
                            wor.Country = wo.Repair_Site_Address__r.Country;
                            wor.PostalCode = wo.Repair_Site_Address__r.PostalCode;
                            wor.Street = wo.Repair_Site_Address__r.Street;
                        }
                        unskipValidationRule(wor);
                        workOrderToUpdate.add(wor);
                    }
                    //Block to check conditions when repair location is inShop.
                    when 'In Shop' {
                        system.debug('Entered into INSHOP conditions::::'+wo.AssetId+'>>>'+oldMap.get(wo.Id).AssetId+'>>>>>'+wo.Asset.AccountId+'>>>>'+wo.Asset.ContactId);
                        //Condition - 1
                        if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Asset.AccountId != null) { 
                            
                            //Assign Asset Values
                            system.debug('Entered into INSHOP condition1::::');
                            
                            wor = updateAssetWorkOrderFields(wo);
                            system.debug('Entered into INSHOP condition1::::'+wor);
                            
                            //CT3-289, Dinesh
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){
                                wor.AccountId = wo.AccountId;
                                wor.ContactId = wo.ContactId;
                                wor.Repair_Site_Address__c = wo.Repair_Site_Address__c;
                            } 
                            else {
                                if (wo.Shop_Work_Order__c == null && wo.Asset.AccountId != null){
                                    wor.AccountId = wo.Asset.AccountId;
                                    if(wo.Asset.ContactId != null){
                                        wor.ContactId = wo.Asset.ContactId;     
                                    }else{
                                        wor.ContactId = null;
                                    }
                                    /* if(wo.Asset.FSL_Site__c != null){
wor.Repair_Site_Address__c = wo.Asset.FSL_Site__c;
} else{
wor.Repair_Site_Address__c = null;
}*/
                                    system.debug('Asset Change Account Value:::'+wor.AccountId);
                                }  
                            }
                            
                            if(wo.Asset.Warranty_Start_Date__c != null){
                                wor.Warranty_Start_Date__c = wo.Asset.Warranty_Start_Date__c;
                            } else{
                                wor.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                            wor.Customer_Name__c = wo.Asset.Customer_Name__c;  
                            wor.Customer_City__c   = wo.Asset.City__c;
                            wor.Customer_State__c = wo.Asset.State__c;
                            wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                            wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                            wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                            wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                            wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                            wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                            
                            //Address update from Repair Site
                            wor.City  = wo.ServiceTerritory.City;
                            wor.State = wo.ServiceTerritory.State;
                            wor.Country = wo.ServiceTerritory.Country;
                            wor.PostalCode = wo.ServiceTerritory.PostalCode;
                            wor.Street = wo.ServiceTerritory.Street;
                            
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start(); 
                        }
                        
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId &&  wo.Asset.AccountId != null ){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            wor.Make__c = wo.Asset.Make__c;
                            wor.Model__c = wo.Asset.Model__c;
                            wor.Service_Model__c = wo.Asset.Service_Model__c;
                            //Added by sravanthi
                            if(wo.ServiceTerritoryId != null){
                                wor.City  = wo.ServiceTerritory.City;
                                wor.State = wo.ServiceTerritory.State;
                                wor.Country = wo.ServiceTerritory.Country;
                                wor.PostalCode = wo.ServiceTerritory.PostalCode;
                                wor.Street = wo.ServiceTerritory.Street;
                            }
                        }
                        //Condition - 1.1 : Added as part of Defect CT2-273
                        else if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Asset.AccountId == null){
                            //Assign Asset  Values
                            wor = updateAssetWorkOrderFields(wo);
                            
                            //CT3-289, Dinesh Yadav
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){
                                wor.AccountId = wo.AccountId;
                                wor.ContactId = wo.ContactId;
                                wor.Repair_Site_Address__c = wo.Repair_Site_Address__c;
                            } else{
                                wor.AccountId = null;
                                wor.ContactId = null;
                                wor.Repair_Site_Address__c = null;
                            }
                            if(wo.Asset.Warranty_Start_Date__c != null){
                                wor.Warranty_Start_Date__c = wo.Asset.Warranty_Start_Date__c;
                            } else{
                                wor.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                            wor.Customer_Name__c = wo.Asset.Customer_Name__c;  
                            wor.Customer_City__c   = wo.Asset.City__c;
                            wor.Customer_State__c = wo.Asset.State__c;
                            wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                            wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                            wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                            wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                            wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                            wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                            
                            //Address update from Repair Site
                            wor.City  = wo.ServiceTerritory.City;
                            wor.State = wo.ServiceTerritory.State;
                            wor.Country = wo.ServiceTerritory.Country;
                            wor.PostalCode = wo.ServiceTerritory.PostalCode;
                            wor.Street = wo.ServiceTerritory.Street;
                            
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Asset.AccountId == null){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            wor.Make__c = wo.Asset.Make__c;
                            wor.Model__c = wo.Asset.Model__c;
                            wor.Service_Model__c = wo.Asset.Service_Model__c;
                            //Added by sravanthi
                            if(wo.ServiceTerritoryId != null){
                                wor.City  = wo.ServiceTerritory.City;
                                wor.State = wo.ServiceTerritory.State;
                                wor.Country = wo.ServiceTerritory.Country;
                                wor.PostalCode = wo.ServiceTerritory.PostalCode;
                                wor.Street = wo.ServiceTerritory.Street;
                            }
                        }
                        //Condition - 2
                        else if((wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && wo.AccountId == wo.Asset.AccountId) ){
                            //Assign Asset Values
                            wor = updateAssetWorkOrderFields(wo);
                            system.debug('Entered into INSHOP condition2::::');
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){
                                wor.AccountId = wo.AccountId;
                                wor.ContactId = wo.ContactId;
                                wor.Repair_Site_Address__c = wo.Repair_Site_Address__c;
                            } 
                            else{
                                wor.AccountId = null;
                                wor.ContactId = null;
                                wor.Repair_Site_Address__c = null;
                            }
                            if(wo.Asset.Warranty_Start_Date__c != null){
                                wor.Warranty_Start_Date__c = wo.Asset.Warranty_Start_Date__c;
                            } else{
                                wor.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                            wor.Customer_Name__c = wo.Asset.Customer_Name__c;  
                            wor.Customer_City__c   = wo.Asset.City__c;
                            wor.Customer_State__c = wo.Asset.State__c;
                            wor.Customer_Address_Line1__c = wo.Asset.MoveX_Customer_Address_1__c;
                            wor.Customer_Address_Line2__c = wo.Asset.MoveX_Customer_Address_2__c;
                            wor.Customer_Address_Line3__c = wo.Asset.MoveX_Customer_Address_3__c;
                            wor.Cash_Customer_Contact_Name__c = wo.Asset.Contact_Name__c;
                            wor.Cash_Customer_Contact_Email__c = wo.Asset.MoveX_Email_ID__c;
                            wor.Cash_Customer_Contact_Phone__c = wo.Asset.MoveX_Phone_Number__c;
                            
                            //Address update from Repair Site
                            wor.City  = wo.ServiceTerritory.City;
                            wor.State = wo.ServiceTerritory.State;
                            wor.Country = wo.ServiceTerritory.Country;
                            wor.PostalCode = wo.ServiceTerritory.PostalCode;
                            wor.Street = wo.ServiceTerritory.Street;
                            
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', wo.Asset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId && wo.AccountId == wo.Asset.AccountId){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            wor.Make__c = wo.Asset.Make__c;
                            wor.Model__c = wo.Asset.Model__c;
                            wor.Service_Model__c = wo.Asset.Service_Model__c;
                            //Added by sravanthi
                            if(wo.ServiceTerritoryId != null){
                                wor.City  = wo.ServiceTerritory.City;
                                wor.State = wo.ServiceTerritory.State;
                                wor.Country = wo.ServiceTerritory.Country;
                                wor.PostalCode = wo.ServiceTerritory.PostalCode;
                                wor.Street = wo.ServiceTerritory.Street;
                            }
                        }
                        //Condition - 3
                        else if(wo.AssetId == null && wo.ServiceTerritoryId != null && wo.ServiceTerritoryId == oldMap.get(wo.Id).ServiceTerritoryId){
                            //Cash Customer Details
                            if(wo.AccountId != null && wo.Account.RecordType.DeveloperName == 'Guidanz_Cash'){
                                wor.Customer_Name__c = wo.Account.Name;  
                                wor.Customer_City__c   = wo.Account.BillingCity;
                                wor.Customer_State__c = wo.Account.BillingState;
                                wor.Customer_Address_Line1__c = wo.Account.Billingstreet;
                                wor.Customer_Country__c = wo.Account.BillingCountry;
                                wor.Customer_Postal_Code__c = wo.Account.BillingPostalCode;
                                if(wo.ContactId != null){
                                    wor.Cash_Customer_Contact_Name__c = wo.Contact.FirstName + ' '+wo.Contact.LastName;
                                    wor.Cash_Customer_Contact_Email__c = wo.Contact.Email;
                                    wor.Cash_Customer_Contact_Phone__c = wo.Contact.Phone;  
                                } else{
                                    wor.Cash_Customer_Contact_Name__c = '';
                                    wor.Cash_Customer_Contact_Email__c = '';
                                    wor.Cash_Customer_Contact_Phone__c = '';
                                }
                            } else {
                                wor.Customer_Name__c = '';  
                                wor.Customer_City__c   = '';
                                wor.Customer_State__c = '';
                                wor.Customer_Address_Line1__c ='';
                                wor.Customer_Address_Line2__c = '';
                                wor.Customer_Address_Line3__c = '';
                                wor.Cash_Customer_Contact_Name__c = '';
                                wor.Cash_Customer_Contact_Email__c = '';
                                wor.Cash_Customer_Contact_Phone__c = '';
                            }
                            //Address update from Repair Site
                            wor.City  = wo.ServiceTerritory.City;
                            wor.State = wo.ServiceTerritory.State;
                            wor.Country = wo.ServiceTerritory.Country;
                            wor.PostalCode = wo.ServiceTerritory.PostalCode;
                            wor.Street = wo.ServiceTerritory.Street;
                        }
                        //Condition - 4
                        else if(wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Repair_Location__c != oldMap.get(wo.Id).Repair_Location__c){
                            //Address update from Repair Site
                            wor.City  = wo.ServiceTerritory.City;
                            wor.State = wo.ServiceTerritory.State;
                            wor.Country = wo.ServiceTerritory.Country;
                            wor.PostalCode = wo.ServiceTerritory.PostalCode;
                            wor.Street = wo.ServiceTerritory.Street;
                        }
                        //Condition - 5
                        else if(wo.ServiceTerritoryId != null && wo.ServiceTerritoryId != oldMap.get(wo.Id).ServiceTerritoryId){
                            //Address update from Repair Site
                            wor.City  = wo.ServiceTerritory.City;
                            wor.State = wo.ServiceTerritory.State;
                            wor.Country = wo.ServiceTerritory.Country;
                            wor.PostalCode = wo.ServiceTerritory.PostalCode;
                            wor.Street = wo.ServiceTerritory.Street;
                        }
                        unskipValidationRule(wor);
                        workOrderToUpdate.add(wor);  
                    }
                }
            }
            //workOrderToUpdate.add(wor);  
            system.debug('WoListUpdate:'+wor);
        }     
        FSL_WorkOrderListTriggerHandle.avoidAfterupdate = true;
        FSL_WorkOrderListTriggerHandle.avoidBeforeUpdate = true;
        
        if(workOrderToUpdate.size() > 0) {
            system.debug('Inside Asset Update');
            RecursiveTriggerHandler.isWorkOrderUpdate = false;
            update workOrderToUpdate;
        }

        // Added below code to avoid Flow Error as part of trigger re design - START
        if(lstSA != null){
            update lstSA;
        }
        // Added below code to avoid Flow Error as part of trigger re design - END
    }
    
    public static workOrder updateAssetWorkOrderFields(workOrder wo) {
        Boolean Flag;
        workOrder woRec = new workOrder();
        woRec.Id = wo.Id;
        
        
        //Asset Details on WO    
        woRec.Application__c = wo.Asset.Application__c;
        woRec.Unit_NB__c = wo.Asset.Unit_Number__c;
        woRec.Registration__c = wo.Asset.Registration__c;
         if( wo.Type__c == 'Dealer' && wo.EVL_DX_SONumber__c == false){
            woRec.Before_In_Service__c = false;
        } else if( wo.Type__c != 'Dealer'){
            woRec.Before_In_Service__c = false;
        }
        woRec.Equipment_Id__c = wo.Asset.Equipment_Id__c;
        woRec.Failure_Date__c = system.today();
        woRec.Fuel_Burn__c = null;    
        woRec.Make__c = wo.Asset.Make__c;
        woRec.Model__c = wo.Asset.Model__c;
        woRec.Service_Model__c = wo.Asset.Service_Model__c;            
        woRec.Unit_Type__c = wo.Asset.Equipment_Configuration__c;
        woRec.Payer_ContactID__c = null;     
        woRec.Skip_WSD_VR__c = true;
        // Commented the below 3 fileds by sailja, CT3-257-to update WO with case hours, mileage for IA Request
        // woRec.Mileage__c = null;
        // woRec.CSS_Hours__c = null;
        // added by sailaja, CT3-257 to update WO only if SR record type is not IA Request
        if(wo.CaseId!= null) {
            Id recordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();  
            List<case> lstCS = [SELECT Id, RecordTypeId , Product_Mileage_Unit__c FROM Case WHERE Id =: wo.CaseId];
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
            if(wo.ServiceTerritory.Mileage_Measure__c != '' && wo.Type__c != 'Dealer'){
                woRec.Mileage_Measure__c = wo.ServiceTerritory.Mileage_Measure__c;  
            } 
            //Added by Sriprada to populate Mileage Measure for Dealer jobs
            else if(wo.Type__c == 'Dealer'){
             woRec.Mileage_Measure__c = wo.Mileage_Measure__c;  
            }       
        }
        system.debug('woRec' + woRec);
        return woRec; 
    }
    
    public static workOrder unskipValidationRule(workOrder wo) {
        workOrder woRec = new workOrder();
        woRec.Id = wo.Id;
        woRec.Skip_WSD_VR__c = false;
        return woRec; 
    }
    
    public static void updateFields() {
        
        String s1;
        String s2;
        String s3;
        String s4;
        String s5;
        String s6;
        String s7;
        String s8;
        String s9;
        String s10;
        String s11;
        String s12;
        String s13;
        String s14;
        String s15;
        String s16;
        String s17;
        String s18;
        String s19;
        String s20;
        String s21;
        String s22;
        String s23;
        String s24;
        String s25;
        String s26;
        String s27;
        String s28;
        String s29;
        String s30;
        String s31;
        String s32;
        String s33;
        String s34;
        String s35;
        String s36;
        String s37;
        String s38;
        String s39;
        String s40;
        String s41;
        String s42;
        String s43;
        String s44;
        String s45;
        String s46;
        String s47;
        String s48;
        String s49;
        String s50;
        String s51;
        String s52;
        String s53;
        String s54;
        String s55;
        String s56;
        String s57;
        String s58;
        String s59;
        String s60;
        String s61;
        String s62;
        String s63;
        String s64;
        String s65;
        String s66;
        String s67;
        String s68;
        String s69;
        String s70;
        String s71;
        String s72;
        String s73;
        String s74;
        String s75;
        String s76;
        String s77;
        String s78;
        String s79;
        String s80;
        String s81;
        String s82;
        String s83;
        String s84;
        String s85;
        String s86;
        String s87;
        String s88;
        String s89;
        String s90;
        String s91;
        String s92;
        String s93;
        String s94;
        String s95;
        String s96;
        String s97;
        String s98;
        String s99;
        String s100;
        String s101;
        String s102;
        String s103;
        String s104;
        String s105;
        String s106;
        String s107;
        String s108;
        String s109;
        String s110;
        String s111;
        String s112;
        String s113;
        String s114;
        String s115;
        String s116;
        String s117;
        String s118;
        String s119;
        String s120;
        String s121;
        String s122;
        String s123;
        String s124;
        String s125;
        String s126;
        String s127;
        String s128;
        String s129;
        String s130;
        String s131;
        String s132;
        String s133;
        String s134;
        String s135;
        String s136;
        String s137;
        String s138;
        String s139;
        String s140;
        String s141;
        String s142;
        String s143;
        String s144;
        String s145;
        String s146;
        String s147;
        String s148;
        String s149;
        String s150;
            
    }
}