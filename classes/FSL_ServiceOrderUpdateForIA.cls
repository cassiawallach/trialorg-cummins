/******************************************************************************************************
Name : FSL_serviceOrderUpdateForIA 
Description : apex class used for update event on FSL_ServiceRequestTrigger
Description2 : using this class to update prod hours, mileage when prod hours,mileage are updated on service request for IA type
Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   01/21/2021             Sailaja Guntupalli                   Apex cls created for update event on FSL_ServiceRequestTrigger
2.0                   01/29/2021             Dinesh Yadav                         Updated class code for Bulkify trigger & added code to map Description to General Symptons
3.0                   02/18/2021             Sunitha M                            Updating SO Asset with IA Request  
4.0                   03/02/2021             Charan                               CT3-294 update WO with assetId for IA Request
5.0                   07/20/2022             Lochana R                            SG-71 - Updated class to update WO with FTR atrributes
                                                                                  when SR gets updated with ABRFlag and TransactionID
6.0                   07/26/2022             Shailender                           Optimizing code to move SOQL & DML out of loop
*********************************************************************************************************/
public class FSL_ServiceOrderUpdateForIA {
    
    public static voId updateServiceOrderForIAType(Map<Id, Case> newMap, Map<Id, Case> oldMap) {
        List<Case> csList = new List<Case>(newMap.values());
        Map<Id, Case> serviceRequestMap = new Map<Id, Case>();
        Boolean prodMileageMeasureModified = false;
        csList = [SELECT Id, Product_Hours__c, Product_Mileage__c, Customer__c, Status, Service_Model__c, Make__c, Model__c, AssetId, ServiceJob__r.AssetId, IAS_Number__C, 

                  Product_Mileage_Unit__c,Service_Territory__c, Available_for_Service__c, Description, AccountId, Asset.AccountId 
                  FROM Case WHERE Id IN: newMap.KeySet()];
        
        set<Id> setCaseId = new set<Id>();
        map<Id, WorkOrder> mapCaseIdToWO = new map<Id, WorkOrder>();
        List<WorkOrder> lstUpdWO = new List<WorkOrder>();
        
        // CT3-289, Dinesh Yadav, Added cs.AccountId.
        for(case cs: csList) {
            // added by Sailaja, CT3-337 - to update WO with IASNumber for IA Request
            if(cs.Product_Hours__c != oldMap.get(cs.Id).Product_Hours__c 
               || cs.Product_Mileage__c != oldMap.get(cs.Id).Product_Mileage__c 
               || cs.Product_Mileage_Unit__c != oldMap.get(cs.Id).Product_Mileage_Unit__c 
               || cs.Description != oldMap.get(cs.Id).Description 
               || cs.AccountId != oldMap.get(cs.Id).AccountId 
               || cs.Available_for_Service__c != oldMap.get(cs.Id).Available_for_Service__c 
               || cs.AssetId != oldMap.get(cs.Id).AssetId // added by Charan, CT3-294 - to update WO with assetId for IA Request
               || cs.IAS_Number__C != oldMap.get(cs.Id).IAS_Number__C
               || cs.Service_Territory__c != oldMap.get(cs.Id).Service_Territory__c)
            {
                setCaseId.add(cs.Id);
            }
        }
       List<Service_Order_Extension__c> lstSOExtension = new List<Service_Order_Extension__c>();
       //5.0 
       List<FSL_Switch__c> lstFeatureMatrix = [SELECT Id, Name, IsActive__c FROM FSL_Switch__c 
                                            WHERE Name = 'Enable_FTR_Switch' AND IsActive__c = true LIMIT 1];

        if(setCaseId != null && setCaseId.size() > 0) {
            List<workorder> lstWO = [SELECT Id,Type__c, CSS_Hours__c, EVL_Customer__c, Mileage__c, Mileage_Measure__c, CaseId, General_Symptoms__c, Available_for_Service__c, IAS_Number__C, 

                                     AccountId, ContactId, Contact.AccountId ,ServiceTerritoryId,
                                     Case.FSL_ABRFlag__c, Case.FSL_TransactionID__c,
                                     (SELECT Id, FSL_ABRFlag__c, FSL_TransactionID__c 
                                     FROM Service_Order_Extension__r)
                                     FROM WorkOrder 
                                     WHERE CaseId in :setCaseId];
            for(workorder wo : lstWO) {
                mapCaseIdToWO.put(wo.CaseId, wo);
                //5.0 STARTS
                if( wo.Service_Order_Extension__r != null 
                    && wo.Service_Order_Extension__r.size() > 0 
                    && lstFeatureMatrix != null 
                    && lstFeatureMatrix.size() > 0) {
                    wo.Service_Order_Extension__r[0].FSL_ABRFlag__c = wo.Case.FSL_ABRFlag__c;
                    wo.Service_Order_Extension__r[0].FSL_TransactionID__c = wo.Case.FSL_TransactionID__c;
                    lstSOExtension.add(wo.Service_Order_Extension__r[0]);
                }
                //5.0 ENDS
            }//for
        }//if

        
        
        for(case cs: csList) {
            // added by Sailaja, CT3-337 - to update WO with IASNumber for IA Request
            if(cs.Product_Hours__c!=oldMap.get(cs.Id).Product_Hours__c 
               || cs.Product_Mileage__c!=oldMap.get(cs.Id).Product_Mileage__c 
               || cs.Product_Mileage_Unit__c!=oldMap.get(cs.Id).Product_Mileage_Unit__c 
               || cs.Description!=oldMap.get(cs.Id).Description 
               || cs.AccountId != oldMap.get(cs.Id).AccountId 
               || cs.Available_for_Service__c != oldMap.get(cs.Id).Available_for_Service__c 
               || cs.AssetId != oldMap.get(cs.Id).AssetId // added by Charan, CT3-294 - to update WO with assetId for IA Request
               || cs.IAS_Number__C != oldMap.get(cs.Id).IAS_Number__C
               || cs.Service_Territory__c != oldMap.get(cs.Id).Service_Territory__c)
            {
                if(mapCaseIdToWO != null && mapCaseIdToWO.size() > 0) {
                    if(mapCaseIdToWO.get(cs.Id)  != null) {
                        workorder wo= mapCaseIdToWO.get(cs.Id);
                        system.debug('updateWOMileage:wo ' + wo);
                        if(cs.Product_Mileage_Unit__c!=oldMap.get(cs.Id).Product_Mileage_Unit__c) {
                            prodMileageMeasureModified = true;
                        } 
                        if(prodMileageMeasureModified && (cs.Product_Mileage_Unit__c == 'Km'|| cs.Product_Mileage_Unit__c == 'Kilometers')) {
                            wo.Mileage_Measure__c = System.label.FSL_Mileage_Kilometers;
                        }
                        if(prodMileageMeasureModified && (cs.Product_Mileage_Unit__c == 'mi' || cs.Product_Mileage_Unit__c == 'Miles')) {
                            wo.Mileage_Measure__c = System.label.FSL_Mileage_Miles;
                        }
                        if(cs.Product_Mileage__c!=oldMap.get(cs.Id).Product_Mileage__c) {
                            wo.Mileage__c = cs.Product_Mileage__c;
                        }
                        if(cs.Product_Hours__c!=oldMap.get(cs.Id).Product_Hours__c) {
                            wo.CSS_Hours__c = cs.Product_Hours__c;
                        }
                        if(cs.Description!=oldMap.get(cs.Id).Description) {
                            wo.General_Symptoms__c = cs.Description;
                        }
                        if(cs.Service_Territory__c!=oldMap.get(cs.Id).Service_Territory__c) {
                            wo.ServiceTerritoryId = cs.Service_Territory__c;
                            system.debug(' wo.ServiceTerritoryId'+  wo.ServiceTerritoryId);
                        }
                        wo.EVL_Customer__c = cs.Customer__c;

                        // added by sailaja, CT3-284 - to update the earliest start permitted
                        if(cs.Available_for_Service__c!= oldMap.get(cs.Id).Available_for_Service__c) {
                            if(cs.Available_for_Service__c != null) {
                                wo.Available_for_Service__c = cs.Available_for_Service__c;
                                system.debug(' wo.Available_for_Service__c'+  wo.Available_for_Service__c);
                            }
                        }
                        
                        //CT3-289, Dinesh Yadav 
                        /*if (cs.AssetId != null && cs.AccountId != null && cs.AccountId != cs.Asset.AccountId) {
                            RecursiveTriggerHandler.chkSRAccountId = false;
                            wo.AccountId = cs.AccountId;
                            wo.ContactId = null;
                        }
                        else if(cs.AccountId != oldMap.get(cs.Id).AccountId) {
                            wo.AccountId = cs.AccountId;
                        }
                        */
                        
                        if(cs.AccountId == null || (cs.AssetId != null && cs.AccountId !=null && cs.AccountId == cs.Asset.AccountId)) {
                            // Current Logic - Continue with the auto population logic of the Account and related information from Asset.
                            // Payer get auto populated based on the Account populated - Logic already present
                        }
                        else {
                            wo.AccountId = cs.AccountId;
                            // Don't perform the current logic (auto population logic from Account and related information from Asset).
                            RecursiveTriggerHandler.chkSRAccountId = false;
                            // Payer get auto populated based on the Account populated - Logic already present

                            if(wo.Contact.AccountId != wo.AccountId && wo.Type__c != 'Dealer') {
                                //Need to clear the contact because Contact lookup filter on Work Order
                                //Please select an Active Job Contact associated to the Customer
                                wo.ContactId = null;
                            }
                            system.debug('wo :::'+wo);
                        }

                        // added by Charan, CT3-294 - to update WO with assetId for IA Request
                        if(cs.AssetId != oldMap.get(cs.Id).AssetId ) {
                            wo.AssetId = cs.AssetId;
                            if(cs.Asset.AccountId != null && cs.AccountId != cs.Asset.AccountId && wo.Type__c != 'Dealer') {// added by sailaja , CT3-414
                                RecursiveTriggerHandler.chkSRAccountId = false; 
                                wo.AccountId = cs.Asset.AccountId;// added by sailja, Bug fix- CT3-408
                                if(wo.Contact.AccountId != wo.AccountId && wo.Type__c != 'Dealer'){
                                    //Need to clear the contact because Contact lookup filter on Work Order 
                                    //Please select an Active Job Contact associated to the Customer
                                    wo.ContactId= null; 
                                }
                                system.debug('In Asset wo :::'+wo);
                            }
                        }
                        
                         // added by Charan, CT3-398 to update General symptoms
                        if(cs.Description != oldMap.get(cs.Id).Description) {
                            wo.General_Symptoms__c = cs.Description;
                        }
                        
                        // added by Sailaja, CT3-337 - to update WO with IASNumber for IA Request
                        if(cs.IAS_Number__C != oldMap.get(cs.Id).IAS_Number__C) {
                            wo.IAS_Number__C = cs.IAS_Number__C;
                        }
                        lstUpdWO.add(wo);                   
                    }
                }
            }
        }
        
        if(lstUpdWO != null && lstUpdWO.size() > 0) {
            update lstUpdWO;
        }
        if(lstSOExtension != null && lstSOExtension.size() > 0) {
            update lstSOExtension;
        }
        //Below logic to invoke updateMakeModelSmn method if the status of sr is Updated from IA
        if(!csList.isEmpty()) {
            for(case serviceRequestRec : csList) {
                if(((serviceRequestRec.status != oldMap.get(serviceRequestRec.Id).status) 
                    && (serviceRequestRec.status == 'Schedule'||serviceRequestRec.Status == 'Intake')) ||
                   (serviceRequestRec.AssetId != oldMap.get(serviceRequestRec.Id).AssetId) ||
                   (serviceRequestRec.Make__c != oldMap.get(serviceRequestRec.Id).Make__c)  ||
                   (serviceRequestRec.Model__c != oldMap.get(serviceRequestRec.Id).Model__c) ||
                   (serviceRequestRec.Service_Model__c != oldMap.get(serviceRequestRec.Id).Service_Model__c) 
                  ) {
                      serviceRequestMap.put(serviceRequestRec.Id,serviceRequestRec);
                  }
            }
            
            if(serviceRequestMap.values() != null && csList[0].IAS_Number__c != null) {
                updateMakeModelSmn(serviceRequestMap);
            }
        } 
    }
    
    public static voId updateMakeModelSmn(Map<Id, Case> newMap) {
        system.debug('newmap' + newMap);
        List<Case> caseList = new List<Case>();
        List<Asset> asstList = new List<Asset>();
        Set<Id> assetIdSet = new Set<Id>();
        List<WorkOrder> updateWorkOrderList = new List<WorkOrder>();
        Set<Id> setWorkOrderIds = new Set<Id>();
        String efcmm = '';
        
        for(Case objCase : newMap.values()) {
            system.debug('objCase'+ objCase);
            if((objCase.Status == 'Intake'|| objCase.Status == 'Schedule')) {                
                caseList.add(objCase);
                assetIdSet.add(objCase.AssetId);
                setWorkOrderIds.add(objCase.ServiceJob__c);
            }
        }
        
        Map<Id, Asset> assetRecMap = new Map<Id, Asset>([SELECT Id, Name, Make__c, Model__c, Service_Model__c, Engine_Family_Code__c 
                                                         FROM Asset 
                                                         WHERE Id IN:assetIdSet]);
        
        Map<Id, WorkOrder> serviceOrderRecMap = new Map<Id, WorkOrder>([SELECT Id, AssetId, CaseId
                                                                        FROM WorkOrder 
                                                                        WHERE Id IN:setWorkOrderIds]);
        
        Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        //added As a part of FBI-393
        Map<String, CSS_Make_Model_Access__c> cssMMAMap = new Map<String, CSS_Make_Model_Access__c>();
        Map<String, CSS_Make_Model_Access__c> familyCodeMakeModelToCSSMakeModelMap = new Map<String, CSS_Make_Model_Access__c>();
        List<String> engineFamilyCodeToQuery = new List<String>();
        List<String> makeListToQuery = new List<String>();
        List<String> modelListToQuery = new List<String>();
        
        for(case caseUpdate:caseList) {
            engineFamilyCodeToQuery.add(assetRecMap.get(caseUpdate.AssetId).Engine_Family_Code__c);
            makeListToQuery.add(caseUpdate.Make__c);
            modelListToQuery.add(caseUpdate.Model__c);
        }
        
        for(CSS_Make_Model_Access__c mMARec : [SELECT Id, Family_Code_Make_Model__c, EngineFamilyCode__c, Make__c, Model__c  FROM CSS_Make_Model_Access__c WHERE RecordTypeId =: SRTRecordTypeId AND EngineFamilyCode__c IN :engineFamilyCodeToQuery AND Make__c IN :makeListToQuery AND Model__c IN :modelListToQuery]) {
            familyCodeMakeModelToCSSMakeModelMap.put(mMARec.EngineFamilyCode__c+'_'+mMARec.Make__c+'_'+mMARec.Model__c, mMARec);
        }
        
        for(case caseUpdate:caseList) {
            /* for(CSS_Make_Model_Access__c objmakeAcc : [SELECT Id, Family_Code_Make_Model__c 
                                                       FROM CSS_Make_Model_Access__c 
                                                       WHERE RecordTypeId =: SRTRecordTypeId 
                                                       AND EngineFamilyCode__c =: assetRecMap.get(caseUpdate.AssetId).Engine_Family_Code__c 
                                                       AND Make__c =: caseUpdate.Make__c 
                                                       AND Model__c =: caseUpdate.Model__c LIMIT 1]) 
            {
cssMMAMap.put(objmakeAcc.Family_Code_Make_Model__c, objmakeAcc);
} */
            String mMAKey = assetRecMap.get(caseUpdate.AssetId).Engine_Family_Code__c+'_'+caseUpdate.Make__c+'_'+caseUpdate.Model__c;
            if (familyCodeMakeModelToCSSMakeModelMap.containsKey(mMAKey)) {
                CSS_Make_Model_Access__c objmakeAcc = familyCodeMakeModelToCSSMakeModelMap.get(mMAKey);
                cssMMAMap.put(objmakeAcc.Family_Code_Make_Model__c, objmakeAcc);
            }
            if((caseUpdate.Make__c == assetRecMap.get(caseUpdate.AssetId).Make__c &&
                caseUpdate.Model__c == assetRecMap.get(caseUpdate.AssetId).Model__c &&
                caseUpdate.Service_Model__c == assetRecMap.get(caseUpdate.AssetId).Service_Model__c)) 
            {
                if(caseUpdate.ServiceJob__c != NULL) {
                    if(caseUpdate.AssetId == serviceOrderRecMap.get(caseUpdate.ServiceJob__c).AssetId || 
                       caseUpdate.AssetId != serviceOrderRecMap.get(caseUpdate.ServiceJob__c).AssetId) 
                    {
                        WorkOrder objWorkOrder = new WorkOrder();
                        objWorkOrder.Id = caseUpdate.ServiceJob__c;
                        objWorkOrder.AssetId = caseUpdate.AssetId;
                        objWorkOrder.make__c = caseUpdate.make__c;
                        objWorkOrder.Model__c = caseUpdate.Model__c;
                        objWorkOrder.Service_Model__c = caseUpdate.Service_Model__c;
                        updateWorkOrderList.add(objWorkOrder);
                    }
                }
            }
            else {
                Asset objAset = new Asset(Id = caseUpdate.AssetId);
                if(caseUpdate.Make__c == 'Other Manufacturer' || caseUpdate.Model__c == 'Other Model') {                             
                    objAset.Service_Model__c = caseUpdate.Service_Model__c;
                    objAset.Make__c = 'UNLISTED';
                    objAset.Model__c = 'ALL';
                    efcmm = objAset.Engine_Family_Code__c +'UNLISTED'+'ALL';
                }
                else {
                    objAset.Service_Model__c = caseUpdate.Service_Model__c;
                    objAset.Make__c = caseUpdate.Make__c;
                    objAset.Model__c = caseUpdate.Model__c;
                    efcmm = objAset.Engine_Family_Code__c+caseUpdate.Make__c+caseUpdate.Model__c;
                }
                system.debug('Engine Family Code Make Model' + efcmm);
                if(cssMMAMap != null && cssMMAMap.containskey(efcmm)) {
                    objAset.Make_Model__c = cssMMAMap.get(efcmm).Id;
                } else {
                    objAset.Make_Model__c = null;
                }
                asstList.add(objAset);
                if((caseUpdate.AssetId == serviceOrderRecMap.get(caseUpdate.ServiceJob__c).AssetId)
                   || caseUpdate.AssetId != serviceOrderRecMap.get(caseUpdate.ServiceJob__c).AssetId) 
                {
                    WorkOrder objWorkOrder = new WorkOrder();
                    objWorkOrder.Id = caseUpdate.ServiceJob__c;
                    objWorkOrder.AssetId = caseUpdate.AssetId;
                    objWorkOrder.make__c = caseUpdate.make__c;
                    objWorkOrder.Model__c = caseUpdate.Model__c;
                    objWorkOrder.Service_Model__c = caseUpdate.Service_Model__c;     
                    updateWorkOrderList.add(objWorkOrder);
                }
            }
        }
        
        if(asstList.size() > 0) {
            update asstList;
        }
        if(updateWorkOrderList.size() > 0) {
            update updateWorkOrderList;
        }
    }
}