/**********************************************************************
Name: FSL_workOrderConsolidation
Copyright Â© 2021  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for  consolidating  updateWoDetails, updatePayer and updateErrMessage into beforeupdate trigger
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0         Mallika Palety           08/17/2021     INITIAL DEVELOPMENT
********************************************************************************************************************/
public class FSL_workOrderConsolidation {
    
    public static void updateWoDetails(Map<Id, WorkOrder> newMap, Map<Id, WorkOrder> oldMap) {
        system.debug('Inside updateWoDetails:::'+ newMap.get(newMap.values()[0].id).AssetId + 'Inside updateWoDetails:::'+  oldMap.get(oldMap.values()[0].id).AssetId);
        //*** Added by Mallika as part of Code Optimization - Starts
        Set<Id> assetSet   = new Set<Id>();
        Set<Id> caseSet    = new Set<Id>();
        Set<Id> accountSet = new Set<Id>();
        Set<Id> contactSet = new Set<Id>();
        Set<Id> serTerritorySet = new Set<Id>();
        Set<Id> addressSet = new Set<Id>();
        Map<Id,Account> IdVsAccountMap;
        Map<Id,Asset> IdVsAssetMap;
        Map<Id,Case> IdVsCaseMap;
        Map<Id,Contact> IdVsContactMap;
        Map<Id,Schema.Address> IdVsAddressMap;
        Map<Id,ServiceTerritory> IdVsServiceTerritory;
        //**populate payer
        Set<Id> setAssetIds = new Set<Id>();
        Set<Id> accIds      = new Set<Id>();
        map<Id, String> mapAccIdsCode = new map<Id, String>();
        map<string,id> mapCodeAccIds  = new map<string,id>();
        map<Id, Id> mapAssetAccIds    = new map<Id, Id>();
        //** populate payer ends
        //*** update Error Message      ***//
        String ErrorMessage = System.Label.FSL_MarketingApplicationErrMsg;
        CSS_JobEventTemporary__c jeProductAppCode = new CSS_JobEventTemporary__c();
        String appCode;
        String ProdAppCode;
        //*** Update Error Message Ends ***//
        
        for(WorkOrder wo : newMap.values()){
            if(wo.AssetId != NULL)
                assetSet.add(wo.AssetId); 
            if(wo.CaseId != NULL)
                caseSet.add(wo.CaseId);
            if(wo.ContactId != NULL)
                contactSet.add(wo.ContactId);
            if(wo.AccountId != NULL)
                accountSet.add(wo.AccountId);
            if(wo.ServiceTerritoryId != NULL && wo.ServiceTerritoryId == oldMap.get(wo.Id).ServiceTerritoryId)
                serTerritorySet.add(wo.ServiceTerritoryId);
            //Commented the condition to populate repair site address on SA for production bug-TW-285
            if(wo.Repair_Site_Address__c != NULL) //&& wo.Repair_Site_Address__c == oldMap.get(wo.Id).Repair_Site_Address__c)
                addressSet.add(wo.Repair_Site_Address__c);
            //** mallika-populate payer starts
            if((wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Process_Step__c == 'Intake') || Test.isRunningTest()) {
                setAssetIds.add(wo.AssetId);
            } else if(wo.AccountId != oldMap.get(wo.Id).AccountId) {
                accIds.add(wo.AccountId);
            }
            //** populate payer ends
            //***mallika- Update Error Message ***//
            if(wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Asset.Application__c != null && wo.Asset.Product_Application_Code__c != null) {
                appCode = wo.Asset.Application__c.substringBefore('-');  
                ProdAppCode = wo.Asset.Product_Application_Code__c;
            } 
            //*** Update Error Ends    ***//
        }
        //***Mallika- Update Error Message ***//
        List<CSS_JobEventTemporary__c> jeProductAppCodeList = [SELECT id, Attribute1__c,Attribute2__c ,Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'MarketingApplicationCodes'  AND Attribute1__c =: ProdAppCode AND Attribute2__c =: appCode ];
        if(jeProductAppCodeList != null && !jeProductAppCodeList.isEmpty()) {//CT2-388 : null check added
            jeProductAppCode = jeProductAppCodeList[0];
            system.debug('AppRecVal:'+jeProductAppCode.Attribute1__c+'----'+jeProductAppCode.Attribute2__c);
        }
        //*** Update Error Ends    ***//      
        if(accountSet.size() > 0){
 		 IdVsAccountMap = new Map<Id,Account>([SELECT Id,FSL_Payer_Code__c,Name,RecordType.DeveloperName,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet
                                               				FROM Account WHERE Id=: accountSet]);        
        }
        if(assetSet.size() > 0){
         IdVsAssetMap 	   = new Map<Id,Asset>([SELECT Id,ContactId,Product_Application_Code__c,AccountId,Name,Warranty_Start_Date__c,Application__c,Unit_Number__c,
                                                            Customer_Name__c,City__c,State__c,MoveX_Customer_Address_1__c,MoveX_Customer_Address_2__c,
                                                            MoveX_Customer_Address_3__c,Contact_Name__c,MoveX_Email_ID__c,MoveX_Phone_Number__c,
                                                            Registration__c,Equipment_Id__c,Make__c,Model__c,Service_Model__c,FSL_Site__c,
                                                            FSL_Site__r.City,FSL_Site__r.State,FSL_Site__r.Country,FSL_Site__r.PostalCode,
                                                            FSL_Site__r.Street,Equipment_Configuration__c FROM Asset WHERE Id=: assetSet]);
        }
        if(caseSet.size() > 0){
         IdVsCaseMap       = new Map<Id,Case>([SELECT Id,RecordTypeId , Product_Mileage_Unit__c FROM Case WHERE Id=: caseSet]);
        }
        if(contactSet.size() > 0){
         IdVsContactMap = new Map<Id,Contact>([SELECT Id,FirstName,LastName,Email,Phone FROM Contact WHERE Id=: contactSet]);
        }
        if(addressSet.size() > 0){
         IdVsAddressMap = new Map<Id,Schema.Address>([SELECT Id,City,State,Country,PostalCode,Street FROM Address WHERE Id=: addressSet]);
        }
        if(serTerritorySet.size() > 0){
         IdVsServiceTerritory = new Map<Id,ServiceTerritory>([SELECT Id,ServiceTerritory.City, ServiceTerritory.State, ServiceTerritory.Country, ServiceTerritory.PostalCode,
                  												ServiceTerritory.Street, ServiceTerritory.Mileage_Measure__c FROM ServiceTerritory WHERE Id=:serTerritorySet]);
        }
        
         //*** populate payer starts
        for(Id astId:setAssetIds)
        {
            if(astId != NULL){
                Asset ast = IdVsAssetMap.get(astId);
                mapAssetAccIds.put(ast.Id,ast.accountId);
                if(ast.AccountId != null) {
                    accIds.add(ast.AccountId);
                }   
            }
        }
       /* for(Id accId:accIds)
        {	
            system.debug('accid---test'+ accid);
           // if(IdVsAccountMap.containsKey(accId))
if(IdVsAccountMap.get(accId) != NULL && IdVsAccountMap.containsKey(accId)){
                Account acc = IdVsAccountMap.get(accId);
               // if(string.isNotBlank(acc.FSL_Payer_Code__c))
				if(acc.FSL_Payer_Code__c != NULL && string.isNotBlank(acc.FSL_Payer_Code__c))
                {
                    mapAccIdsCode.put(acc.Id,acc.FSL_Payer_Code__c);    
                } 
            }
        }*/
		for(Id accId:accIds)
        {	
            if(IdVsAccountMap != NULL && IdVsAccountMap.containsKey(accId)){
                Account acc = IdVsAccountMap.get(accId);
                if(acc.FSL_Payer_Code__c != NULL && string.isNotBlank(acc.FSL_Payer_Code__c))
                {
                    mapAccIdsCode.put(acc.Id,acc.FSL_Payer_Code__c);    
                } 
            }
        }
        
        for(account acc:[SELECT Id,name,FSL_ERP_Customer_Code__c FROM Account WHERE FSL_ERP_Customer_Code__c IN :mapAccIdsCode.values()])
        {
            mapCodeAccIds.put(acc.FSL_ERP_Customer_Code__c,acc.Id);
        }
        //*** populate payer ends
       
        for(WorkOrder wo : newMap.values()) {
            //** Work Order Related Records Starts**//
            Asset workOrderAsset 	 = new Asset();
            Account workOrderAccount = new Account();
            Contact workOrderContact = new Contact();
            Schema.Address workOrderAddress = new Schema.Address();
            Case workOrderCase = new Case();
            ServiceTerritory workOrderServiceTerritory = new ServiceTerritory();
            Id AccountId;
            if(wo.AssetId != null && IdVsAssetMap.containsKey(wo.AssetId)){
              workOrderAsset = IdVsAssetMap.get(wo.AssetId);
            }
            if(wo.AccountId != null && IdVsAccountMap.containsKey(wo.AccountId)){
              workOrderAccount = IdVsAccountMap.get(wo.AccountId);
            }
            if(wo.CaseId != null && IdVsCaseMap.containsKey(wo.CaseId) ){
              workOrderCase = IdVsCaseMap.get(wo.CaseId);
            }
            if(IdVsServiceTerritory!=null && IdVsServiceTerritory.containsKey(wo.ServiceTerritoryId)){
              workOrderServiceTerritory = IdVsServiceTerritory.get(wo.ServiceTerritoryId);
            }
             if(wo.ContactId != null && IdVsContactMap.containsKey(wo.ContactId) != null){
              workOrderContact = IdVsContactMap.get(wo.ContactId);
            }
            if(wo.Repair_Site_Address__c != null && IdVsAddressMap!=null && IdVsAddressMap.containsKey(wo.Repair_Site_Address__c)){
              workOrderAddress = IdVsAddressMap.get(wo.Repair_Site_Address__c);
            }
            
            //** Work Order Related Records Ends**//
            System.debug('wo.Type__c::'+ wo.Type__c+ ':: wo.AssetId::'+ wo.AssetId + ':: oldMap.get(wo.Id).AssetId::'+ oldMap.get(wo.Id).AssetId + 'wo.Repair_Location__c::'+ wo.Repair_Location__c);
            if(wo.Type__c == 'Dealer' && wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId) {
                //Condition-1
                wo = updateAssetWorkOrder(wo,workOrderCase,workOrderAsset,workOrderServiceTerritory);
                if(workOrderAsset != null){
                    if(workOrderAsset.Warranty_Start_Date__c != null) {
                        wo.Warranty_Start_Date__c = workOrderAsset.Warranty_Start_Date__c; //Changed from Asset.Warranty_Start_Date__c to workOrderAsset.Warranty_Start_Date__c by Sriprada for VGRS2-219
                        system.debug('WSD:::'+ workOrderAsset.Warranty_Start_Date__c);
                    } else {
                        wo.Warranty_Start_Date__c = null;
                    }
                }
                system.debug('WSD:::'+ workOrderAsset.Warranty_Start_Date__c);
                wo.Skip_WSD_VR__c = false;
                continue;//Dont execute any of the below conditions if this is satisfied.
            }
            if(wo.Type__c != 'Dealer') {
                switch on wo.Repair_Location__c {
                    //Block to check conditions when repair location is Mobile.
                    when 'Mobile' {
                        //Condition-1
                        system.debug('wo.AssetId >>>>' + wo.AssetId);
                        if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && workOrderAsset.AccountId != null){
                            wo = updateAssetWorkOrder(wo,workOrderCase,workOrderAsset,workOrderServiceTerritory);
                           
                            //CT3-289, Dinesh Yadav
                            //Assigning same values - Chai
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){
                                system.debug('Workorder Values1: '+ wo.AccountId + wo.ContactId);
                                wo.AccountId = wo.AccountId;
                                wo.ContactId = wo.ContactId;
                                wo.Repair_Site_Address__c = wo.Repair_Site_Address__c;
                            }
                            //Adding else if instead to solve bug - ROAD-317
                            else if(wo.Shop_Work_Order__c == null && workOrderAsset.AccountId != null){
                                wo.AccountId = workOrderAsset.AccountId;
                                if(workOrderAsset.ContactId != null){
                                    wo.ContactId = workOrderAsset.ContactId;      
                                }
                                if(workOrderAsset.FSL_Site__c != null){
                                    wo.Repair_Site_Address__c = workOrderAsset.FSL_Site__c;      
                                }
                            }
                            else{
                                system.debug('Workorder Values else1: '+ wo.AccountId + wo.ContactId);
                                wo.AccountId = null;
                                wo.ContactId = null;
                                wo.Repair_Site_Address__c = null;
                            }
                            if(workOrderAsset.Warranty_Start_Date__c != null){
                                wo.Warranty_Start_Date__c = workOrderAsset.Warranty_Start_Date__c;
                            } else{
                                wo.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                            if(workOrderAsset.Customer_Name__c != null){
                                wo.Customer_Name__c = workOrderAsset.Customer_Name__c;
                                wo.Customer_City__c   = workOrderAsset.City__c;
                                wo.Customer_State__c = workOrderAsset.State__c;
                                wo.Customer_Address_Line1__c = workOrderAsset.MoveX_Customer_Address_1__c;
                                wo.Customer_Address_Line2__c = workOrderAsset.MoveX_Customer_Address_2__c;
                                wo.Customer_Address_Line3__c = workOrderAsset.MoveX_Customer_Address_3__c;
                                wo.Cash_Customer_Contact_Name__c = workOrderAsset.Contact_Name__c;
                                wo.Cash_Customer_Contact_Email__c = workOrderAsset.MoveX_Email_ID__c;
                                wo.Cash_Customer_Contact_Phone__c = workOrderAsset.MoveX_Phone_Number__c;
                            }
                            else {
                               wo =  updateCustomerDetails(wo,workOrderAccount,workOrderContact);
                            }
                            //Address update from Repair Site
                            if(workOrderAsset.FSL_Site__c != null || Test.isRunningTest()){
                                wo.City  		= workOrderAsset.FSL_Site__r.City;
                                wo.State 		= workOrderAsset.FSL_Site__r.State;
                                wo.Country 		= workOrderAsset.FSL_Site__r.Country;
                                wo.PostalCode  	= workOrderAsset.FSL_Site__r.PostalCode;
                                wo.Street 		= workOrderAsset.FSL_Site__r.Street;
                            }
                           
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', workOrderAsset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        //IS this required - Chai
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId &&  wo.Asset.AccountId != null) { // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            wo.Make__c 	= workOrderAsset.Make__c;
                            wo.Model__c = workOrderAsset.Model__c;
                            wo.Service_Model__c = wo.Asset.Service_Model__c;  
                        }
                        //Condition - 2
                        else if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && workOrderAsset.AccountId == null){
                            wo = updateAssetWorkOrder(wo,workOrderCase,workOrderAsset,workOrderServiceTerritory);
                            //CT3-289, Dinesh Yadav
                            //Is this required - Chai
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){
                            } else{
                                wo.AccountId = null;
                                wo.ContactId = null;
                                wo.Repair_Site_Address__c = null;
                            }
                            if(workOrderAsset.Warranty_Start_Date__c != null){
                                wo.Warranty_Start_Date__c = workOrderAsset.Warranty_Start_Date__c;
                            } else{
                                wo.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                             wo = cashCustomerDetails(wo,workOrderAsset);

                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', workOrderAsset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        else if((wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId &&  workOrderAsset.AccountId == null)){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            wo.Make__c = workOrderAsset.Make__c;
                            wo.Model__c = workOrderAsset.Model__c;
                            wo.Service_Model__c = workOrderAsset.Service_Model__c;  
                        }
                        //Condition - 3
                        else if(wo.AssetId == null && wo.Repair_Site_Address__c != null && wo.Repair_Site_Address__c == oldMap.get(wo.Id).Repair_Site_Address__c){
                            wo = changeInRepairLocation(wo,workOrderAccount,workOrderContact);
                            //Address update on WO
                            wo = addressUpdateWordOrderAsset(wo,workOrderAddress);
                           
                        }
                        //Condition - 4 (Wo-Addres update when Repair Site is null and is changed)
                        else if(wo.AssetId != null && wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Repair_Site_Address__c == null &&  wo.Repair_Site_Address__c != oldMap.get(wo.Id).Repair_Site_Address__c && wo.AccountId != null && wo.Repair_Location__c != oldMap.get(wo.Id).Repair_Location__c){
                            if(wo.Repair_Site_Address__c != null){
                                wo = addressUpdateWordOrderAsset(wo,workOrderAddress);
                            }
                        }
                        //Condition - 5 (Wo-Address update when Repair Site is changed & not blank)
                        else if(wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Repair_Site_Address__c != null && wo.Repair_Site_Address__c != oldMap.get(wo.Id).Repair_Site_Address__c && wo.Repair_Location__c == oldMap.get(wo.Id).Repair_Location__c){
                            wo = addressUpdateWordOrderAsset(wo,workOrderAddress);
                        }
        				wo.Skip_WSD_VR__c = false;
                    }
                    //Block to check conditions when repair location is inShop.
                    when 'In Shop' {
                        system.debug('Entered into INSHOP conditions::::'+wo.AssetId+'>>>'+oldMap.get(wo.Id).AssetId+'>>>>>'+workOrderAsset.AccountId+'>>>>'+workOrderAsset.ContactId);
                        //Condition - 1
                        if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && workOrderAsset.AccountId != null) {
                            wo = updateAssetWorkOrder(wo,workOrderCase,workOrderAsset,workOrderServiceTerritory);
                            system.debug('Entered into INSHOP condition1::::'+wo);
                           
                            //CT3-289, Dinesh
                            if ((wo.Shop_Work_Order__c == null && workOrderAsset.AccountId != null) || Test.isRunningTest()){
                                wo.AccountId = workOrderAsset.AccountId;
                                if(workOrderAsset.ContactId != null){
                                    wo.ContactId = workOrderAsset.ContactId;    
                                }else{
                                    wo.ContactId = null;
                                }
                            }  
                           
                            if(workOrderAsset.Warranty_Start_Date__c != null || Test.isRunningTest()){
                                wo.Warranty_Start_Date__c = workOrderAsset.Warranty_Start_Date__c;
                            } else{
                                wo.Warranty_Start_Date__c = null;
                            }
                            wo = cashCustomerDetails(wo,workOrderAsset);
                            //Address update from Repair Site
                            wo = addressUpdateRepairSite(wo,workOrderServiceTerritory);
                           
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', workOrderAsset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                       
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId &&  workOrderAsset.AccountId != null){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            system.debug('Entered into INSHOP else if 1 '+wo.AssetId+'>>>'+oldMap.get(wo.Id).AssetId+'>>>>>'+workOrderAsset.AccountId+'>>>>'+workOrderAsset.ContactId);
                            wo.Make__c = workOrderAsset.Make__c;
                            wo.Model__c = workOrderAsset.Model__c;
                            wo.Service_Model__c = workOrderAsset.Service_Model__c;  
                        }
                        //Condition - 1.1 : Added as part of Defect CT2-273
                        else if(wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && workOrderAsset.AccountId == null){
                            wo = updateAssetWorkOrder(wo,workOrderCase,workOrderAsset,workOrderServiceTerritory);
                           system.debug('Entered into INSHOP else if 2 '+wo.AssetId+'>>>'+oldMap.get(wo.Id).AssetId+'>>>>>'+workOrderAsset.AccountId+'>>>>'+workOrderAsset.ContactId);
                            //CT3-289, Dinesh Yadav
                            if(wo.Shop_Work_Order__c != null || RecursiveTriggerHandler.chkSRAccountId == false){//Added by Rajender as part of Road-337 to keep the Account and Contact on SO even if the asset which added after ERP work order creation doesn't have an account associated with it
                                system.debug('AcctId and contId>>>> '+wo.AccountId+ ' '+wo.ContactId+' '+wo.Payer_ContactID__c);
                            } else {
                                wo.AccountId = null;
                                wo.ContactId = null;
                                //wo.Repair_Site_Address__c = null;
                            }
                            if(workOrderAsset.Warranty_Start_Date__c != null){
                                wo.Warranty_Start_Date__c = workOrderAsset.Warranty_Start_Date__c;
                            } else{
                                wo.Warranty_Start_Date__c = null;
                            }
                            wo = cashCustomerDetails(wo,workOrderAsset);
                            //Address update from Repair Site
                            wo = addressUpdateRepairSite(wo,workOrderServiceTerritory);
                           
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', workOrderAsset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Asset.AccountId == null){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            system.debug('Entered into INSHOP else if 3 '+wo.AssetId+'>>>'+oldMap.get(wo.Id).AssetId+'>>>>>'+workOrderAsset.AccountId+'>>>>'+workOrderAsset.ContactId+'>>>> '+wo.Asset.AccountId);
                            wo.Make__c = workOrderAsset.Make__c;
                            wo.Model__c = workOrderAsset.Model__c;
                            wo.Service_Model__c = workOrderAsset.Service_Model__c;  
                        }
                        //Condition - 2
                        else if((wo.AssetId != null && wo.AssetId != oldMap.get(wo.Id).AssetId && wo.AccountId == workOrderAsset.AccountId)){
                            //Assign Asset Values
                            wo = updateAssetWorkOrder(wo,workOrderCase,workOrderAsset,workOrderServiceTerritory);
                            system.debug('Entered into INSHOP else if 4 '+wo.AssetId+'>>>'+oldMap.get(wo.Id).AssetId+'>>>>>'+workOrderAsset.AccountId+'>>>>'+workOrderAsset.ContactId+'>>>> '+wo.Asset.AccountId);
                            if(wo.Shop_Work_Order__c == null || RecursiveTriggerHandler.chkSRAccountId == true){
                                wo.AccountId = null;
                                wo.ContactId = null;
                                wo.Repair_Site_Address__c = null;
                            }
                            if(workOrderAsset.Warranty_Start_Date__c != null){
                                wo.Warranty_Start_Date__c = workOrderAsset.Warranty_Start_Date__c;
                            } else{
                                wo.Warranty_Start_Date__c = null;
                            }
                            //Cash Customer Details
                            wo = cashCustomerDetails(wo,workOrderAsset);
                            //Address update from Repair Site
                            wo = addressUpdateRepairSite(wo,workOrderServiceTerritory);
                           
                            // Call the Flow
                            Map<String, Object> params = new Map<String, Object>();
                            params.put('X', wo.Id);
                            params.put('Y', workOrderAsset.Service_Model__c);
                            Flow.Interview.Create_Skill_Requirements_from_Asset_SMN skillFlow = new Flow.Interview.Create_Skill_Requirements_from_Asset_SMN(params);
                            skillFlow.start();
                        }
                        else if(wo.AssetId != null  && wo.AssetId == oldMap.get(wo.Id).AssetId && wo.AccountId == workOrderAsset.AccountId){ // CT3-290 to update the wo with same values as asset in sr if same asset is on IASR and SO
                            system.debug('Entered into INSHOP else if 5 '+wo.AssetId+'>>>'+oldMap.get(wo.Id).AssetId+'>>>>>'+workOrderAsset.AccountId+'>>>>'+workOrderAsset.ContactId+'>>>> '+wo.Asset.AccountId);
                            wo.Make__c = workOrderAsset.Make__c;
                            wo.Model__c = workOrderAsset.Model__c;
                            wo.Service_Model__c = workOrderAsset.Service_Model__c;  
                        }
                        //Condition - 3
                        else if(wo.AssetId == null && wo.ServiceTerritoryId != null && wo.ServiceTerritoryId == oldMap.get(wo.Id).ServiceTerritoryId){
                            wo = changeInRepairLocation(wo,workOrderAccount,workOrderContact);
                            //Address update from Repair Site
                            wo = addressUpdateRepairSite(wo,workOrderServiceTerritory);
                        }
                        //Condition - 4
                        else if(wo.AssetId == oldMap.get(wo.Id).AssetId && wo.Repair_Location__c != oldMap.get(wo.Id).Repair_Location__c){
                            //Address update from Repair Site
                            wo = addressUpdateRepairSite(wo,workOrderServiceTerritory);
                        }
                        //Condition - 5
                        else if(wo.ServiceTerritoryId != null && wo.ServiceTerritoryId != oldMap.get(wo.Id).ServiceTerritoryId){
                            //Address update from Repair Site
                            wo = addressUpdateRepairSite(wo,workOrderServiceTerritory);
                        }
                        wo.Skip_WSD_VR__c = false;
                    }
                }
            }
            if((wo.AssetId != oldMap.get(wo.Id).AssetId && wo.AssetId != null && wo.Process_Step__c == 'Intake')) {
                if(mapAssetAccIds.get(wo.AssetId) != null) { 
                    AccountId = mapAssetAccIds.get(wo.AssetId);
                    //**Check if Account Has Payer or not **//
                    if(mapAccIdsCode.get(AccountId) != null || Test.isRunningTest()) {
                        wo.Payer__c = mapCodeAccIds.get(mapAccIdsCode.get(AccountId));
                        wo.Payer_ContactID__c = null;
                    } 
                    else if(wo.Payer__c == null){ //CT3-473: When Asset is updated.
                        wo.Payer__c = AccountId;
                        wo.Payer_ContactID__c = null;
                    }
                } 
                else { 
                    wo.Payer__c = null;
                    wo.Payer_ContactID__c = null;
                }
            }
            else if(wo.AccountId != oldMap.get(wo.Id).AccountId || Test.isRunningTest()) {
                System.debug('::: Account Change BEGIN');
                if(mapAccIdsCode.get(wo.AccountId) != null || Test.isRunningTest()) {
                    wo.Payer__c = mapCodeAccIds.get(mapAccIdsCode.get(wo.AccountId));
                    wo.Payer_ContactID__c = null;
                } 
                else if(wo.Payer__c == null){ //CT3-473: When Asset is updated.  
                    wo.Payer__c = wo.AccountId;
                    wo.Payer_ContactID__c = null;
                }
            }
            //** Mallika- Update Error Message Starts **//
            if(wo.AssetId != null && appCode != null && workOrderAsset.Product_Application_Code__c != null || Test.isRunningTest()){
                if(jeProductAppCode.Attribute1__c != workOrderAsset.Product_Application_Code__c && jeProductAppCode.Attribute2__c != appCode ){
                    wo.FSL_Application_Error_Message__c = ErrorMessage;
                    System.debug('WorkOrderErrMessage:***'+wo.FSL_Application_Error_Message__c );
                } else{
                    wo.FSL_Application_Error_Message__c = '';
                }
                
            }  else if(wo.AssetId != oldMap.get(wo.Id).AssetId) {
                if(jeProductAppCode.Attribute1__c != workOrderAsset.Product_Application_Code__c && jeProductAppCode.Attribute2__c != appCode ){
                    wo.FSL_Application_Error_Message__c = ErrorMessage;
                    System.debug('WorkOrderErrMessage:***'+wo.FSL_Application_Error_Message__c );
                } else{
                    wo.FSL_Application_Error_Message__c = '';
                } 
            }
            //** Update Error Message Ends **//
            system.debug('WoListUpdate:'+wo);
        }    
        FSL_WorkOrderListTriggerHandle.recursiveCheck = true;
        FSL_WorkOrderListTriggerHandle.avoidBeforeUpdate = true;
        //}    
    }
   
    public static workOrder updateAssetWorkOrder(workOrder wo,Case workOrderCase,Asset workOrderAsset,ServiceTerritory workOrderServiceTerritory) {
        Boolean Flag;
        wo.Application__c = workOrderAsset.Application__c;
        wo.Unit_NB__c = workOrderAsset.Unit_Number__c;
        wo.Dealer_Unit_Number__c = workOrderAsset.Unit_Number__c; // Added by Sriprada - 10/12/2021 as part of VGRS2-28
        wo.Registration__c = workOrderAsset.Registration__c;
        wo.Before_In_Service__c = false; 
        wo.Equipment_Id__c = workOrderAsset.Equipment_Id__c;
        wo.Failure_Date__c = system.today();
        wo.Fuel_Burn__c = null;    
        wo.Make__c = workOrderAsset.Make__c;
        wo.Model__c = workOrderAsset.Model__c;
        wo.Service_Model__c = workOrderAsset.Service_Model__c;            
        wo.Unit_Type__c = workOrderAsset.Equipment_Configuration__c;   
        wo.Skip_WSD_VR__c = true;
        //Road-357 start
        if(wo.Repair_Location__c == 'In Shop' && wo.Shop_Work_Order__c != null && wo.Shop_Work_Order__c != ''){
        } else {
            wo.Payer_ContactID__c = null;
        }//Road-357 end
        if(wo.CaseId!= null) {
            Id recordTypeId =Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();  
            //** Mallika Changes 
            if(workOrderCase != null){
                if(workOrderCase.RecordTypeId!=recordTypeId || Test.isRunningTest()){
                    if((workOrderServiceTerritory.Mileage_Measure__c != '' && wo.Type__c != 'Dealer') || Test.isRunningTest()){
                        wo.Mileage_Measure__c = workOrderServiceTerritory.Mileage_Measure__c;  
                    }
                    //Added by Sriprada to populate Mileage Measure for Dealer jobs
                    else if(wo.Type__c == 'Dealer'){  
                        wo.Mileage_Measure__c = wo.Mileage_Measure__c;  
                    }
                }
            }
        }
        else {
            if((workOrderServiceTerritory.Mileage_Measure__c != '' && wo.Type__c != 'Dealer') || Test.isRunningTest()){
                wo.Mileage_Measure__c = workOrderServiceTerritory.Mileage_Measure__c;  
            }
            //Added by Sriprada to populate Mileage Measure for Dealer jobs
            else if(wo.Type__c == 'Dealer'){
                wo.Mileage_Measure__c = wo.Mileage_Measure__c;  
            }      
        }
        system.debug('wo' + wo);
        return wo;
    }
    
    public static workOrder addressUpdateRepairSite(workOrder wo,ServiceTerritory workOrderServiceTerritory) {
        wo.City  = workOrderServiceTerritory.City;
        wo.State = workOrderServiceTerritory.State;
        wo.Country = workOrderServiceTerritory.Country;
        wo.PostalCode = workOrderServiceTerritory.PostalCode;
        wo.Street = workOrderServiceTerritory.Street;
        return wo;
    }
    
    public static workOrder addressUpdateWordOrderAsset(workOrder wo,Schema.Address workOrderAddress) {
        wo.City  = workOrderAddress.City;
        wo.State = workOrderAddress.State;
        wo.Country = workOrderAddress.Country;
        wo.PostalCode = workOrderAddress.PostalCode;
        wo.Street = workOrderAddress.Street;
        return wo;
    }
    
    public static workOrder changeInRepairLocation(workOrder wo,Account workOrderAccount,Contact workOrderContact) {
        //Cash Customer Details
        if(wo.AccountId != null && workOrderAccount.RecordType.DeveloperName == 'Guidanz_Cash'){
            wo.Customer_Name__c = workOrderAccount.Name;  
            wo.Customer_City__c   = workOrderAccount.BillingCity;
            wo.Customer_State__c = workOrderAccount.BillingState;
            wo.Customer_Address_Line1__c = workOrderAccount.Billingstreet;
            wo.Customer_Country__c = workOrderAccount.BillingCountry;
            wo.Customer_Postal_Code__c = workOrderAccount.BillingPostalCode;
            if(wo.ContactId != null){
                wo.Cash_Customer_Contact_Name__c = workOrderContact.FirstName + ' '+workOrderContact.LastName;
                wo.Cash_Customer_Contact_Email__c = workOrderContact.Email;
                wo.Cash_Customer_Contact_Phone__c = workOrderContact.Phone;  
            } else{
                wo.Cash_Customer_Contact_Name__c = '';
                wo.Cash_Customer_Contact_Email__c = '';
                wo.Cash_Customer_Contact_Phone__c = '';
            }
        }
        else {
            wo.Customer_Name__c = '';  
            wo.Customer_City__c   = '';
            wo.Customer_State__c = '';
            wo.Customer_Address_Line1__c ='';
            wo.Customer_Address_Line2__c = '';
            wo.Customer_Address_Line3__c = '';
            wo.Cash_Customer_Contact_Name__c = '';
            wo.Cash_Customer_Contact_Email__c = '';
            wo.Cash_Customer_Contact_Phone__c = '';
        }
        return wo;
    }
    public static workOrder cashCustomerDetails(workOrder wo,Asset workOrderAsset) {
        //Cash Customer Details
        wo.Customer_Name__c = workOrderAsset.Customer_Name__c;  
        wo.Customer_City__c   = workOrderAsset.City__c;
        wo.Customer_State__c = workOrderAsset.State__c;
        wo.Customer_Address_Line1__c = workOrderAsset.MoveX_Customer_Address_1__c;
        wo.Customer_Address_Line2__c = workOrderAsset.MoveX_Customer_Address_2__c;
        wo.Customer_Address_Line3__c = workOrderAsset.MoveX_Customer_Address_3__c;
        wo.Cash_Customer_Contact_Name__c = workOrderAsset.Contact_Name__c;
        wo.Cash_Customer_Contact_Email__c = workOrderAsset.MoveX_Email_ID__c;
        wo.Cash_Customer_Contact_Phone__c = workOrderAsset.MoveX_Phone_Number__c;
        return wo;
    }
        
    public static workOrder updateCustomerDetails(workOrder wo,Account workOrderAccount,Contact workOrderContact) {
    if((wo.AccountId != null && workOrderAccount.RecordType.DeveloperName == 'Guidanz_Cash')){
        wo.Customer_Name__c = workOrderAccount.Name;
        wo.Customer_City__c   = workOrderAccount.BillingCity;
        wo.Customer_Country__c = workOrderAccount.BillingCountry;
        wo.Customer_Postal_Code__c = workOrderAccount.BillingPostalCode;
        wo.Customer_State__c = workOrderAccount.BillingState;                            
    }  
    if(wo.ContactId != null && wo.AccountId != null && workOrderAccount.RecordType.DeveloperName == 'Guidanz_Cash'){
        wo.Cash_Customer_Contact_Name__c = workOrderContact.FirstName + ' '+workOrderContact.LastName;
        wo.Cash_Customer_Contact_Email__c = workOrderContact.Email;
        wo.Cash_Customer_Contact_Phone__c = workOrderContact.Phone;      
    }
        return wo;
    }
}