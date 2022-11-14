/**********************************************************************
Name: FSL_populatePayer
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for populating Payer on WorkOrder
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0         SRIPRADA SESHAM            1/20/2019     INITIAL DEVELOPMENT
********************************************************************************************************************/

public class FSL_populatePayer {
    
    private static boolean skipAssetCheck = false;
    public static void updatePayer(Map<Id, WorkOrder> newMap, Map<Id, WorkOrder> oldMap) {
        Set<Id> idToUpdate = new Set<Id>();
        Set<Id> setAssetIds = new Set<Id>();
        map<Id, String> mapAccIdsCode = new map<Id, String>();
        map<string,id> mapCodeAccIds = new map<string,id>();
        map<Id, Id> mapAssetAccIds = new map<Id, Id>();
        list<WorkOrder> woList = new list<WorkOrder>(newMap.values());
        Set<Id> accIds = new Set<Id>();
        
        for (WorkOrder wo : woList) 
        {
            if((wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Process_Step__c == 'Intake') || Test.isRunningTest()) {
                setAssetIds.add(wo.AssetId);
            } else if(wo.AccountId != oldMap.get(wo.Id).AccountId) {
                accIds.add(wo.AccountId);
            }
        }
        
        for(asset ast:[select id,accountId from asset where id in:setAssetIds])
        {
            mapAssetAccIds.put(ast.Id,ast.accountId);
            if(ast.AccountId != null) {
                accIds.add(ast.AccountId);
            }
        }
        
        for(account acc:[SELECT Id,name,FSL_Payer_Name__c,FSL_Payer_Code__c FROM Account WHERE ID IN :accIds])
        {
            if(string.isNotBlank(acc.FSL_Payer_Code__c))
            {
                mapAccIdsCode.put(acc.id,acc.FSL_Payer_Code__c);    
            }
        }
        
        for(account acc:[SELECT Id,name,FSL_ERP_Customer_Code__c FROM Account WHERE FSL_ERP_Customer_Code__c IN :mapAccIdsCode.values()])
        {
            mapCodeAccIds.put(acc.FSL_ERP_Customer_Code__c,acc.id);
        }
        
        list<WorkOrder> workOrderToUpdate = new list<WorkOrder>();
        
        for(WorkOrder wor : woList)
        {
            Id WorkAccountId;
            Id AssetAccId;
            Id AccountId;
            WorkOrder wo = new WorkOrder();
            wo.Id = wor.id;
            //When Asset is Changd
            if((wor.AssetId != oldMap.get(wor.Id).AssetId && wor.AssetId != null && wor.Process_Step__c == 'Intake') || Test.isRunningTest()) {
                //System.debug('::: wor.Process_Step__c = '+wor.Process_Step__c);
                if(mapAssetAccIds.get(wor.AssetId) != null) { // Means Asset have an Account
                    AccountId = mapAssetAccIds.get(wor.AssetId);
                    
                    //Check if Account Has Payer or not
                    if(mapAccIdsCode.get(AccountId) != null) {
                        wo.Payer__c = mapCodeAccIds.get(mapAccIdsCode.get(AccountId));
                        wo.Payer_ContactID__c = null;
                    } 
                    else if(wor.Payer__c == null){ //CT3-473: When Asset is updated. // Account Dont have payer
                        wo.Payer__c = AccountId;
                        wo.Payer_ContactID__c = null;
                    }
                } 
                else { // Asset Dont have Account
                    wo.Payer__c = null;
                    wo.Payer_ContactID__c = null;
                }
            } 
            //When Account is Changed
            else if(wor.AccountId != oldMap.get(wor.Id).AccountId) {
                System.debug('::: Account Change BEGIN');
                //Check if Account Has Payer or not
                if(mapAccIdsCode.get(wor.AccountId) != null) {
                    wo.Payer__c = mapCodeAccIds.get(mapAccIdsCode.get(wor.AccountId));
                    wo.Payer_ContactID__c = null;
                } 
                else if(wor.Payer__c == null){ //CT3-473: When Asset is updated.  // Account Dont have payer
                    wo.Payer__c = wor.AccountId;
                    wo.Payer_ContactID__c = null;
                }
            } else {
                System.debug('::: Not Asset or Account Changed...');
            }
            workOrderToUpdate.add(wo);
        }
        FSL_WorkOrderListTriggerHandle.avoidAfterupdate = true;
        FSL_WorkOrderListTriggerHandle.avoidBeforeUpdate = true;
        if(workOrderToUpdate.size() > 0) {
            update workOrderToUpdate;    
        }
    }
    
    public static void updatePayerOnInsert(List<WorkOrder> woList) {
        System.debug('::: updatePayerOnInsert BEGIN');
        Set<Id> idToUpdate = new Set<Id>();
        Set<Id> setAssetIds = new Set<Id>();
        map<Id, String> mapAccIdsCode = new map<Id, String>();
        map<String, Id> mapCodeAccIds = new map<String, Id>();
        map<Id, Id> mapAssetAccIds = new map<Id, Id>();
        //map<id,id> mapAssetAccIds2 = new map<Id,id>();
        
        for (WorkOrder wo : woList) 
        {
            if(wo.AccountId != null) {
                idToUpdate.add(wo.AccountId);
            } else {
                setAssetIds.add(wo.AssetId);
            }
        }
        
        for(asset ast:[select id,accountId from asset where id in:setAssetIds])
        {
            if(ast.AccountId != null)
            {
                mapAssetAccIds.put(ast.Id,ast.accountId);
                idToUpdate.add(ast.AccountId);
            }
        }
        //System.debug('::: idToUpdate = '+idToUpdate);
        for(account acc:[SELECT Id,name,FSL_Payer_Name__c,FSL_Payer_Code__c FROM Account WHERE ID IN :idToUpdate])
        {
            //System.debug('::: acc.FSL_Payer_Code__c = '+acc.FSL_Payer_Code__c);
            if(string.isNotBlank(acc.FSL_Payer_Code__c))
            {
                mapAccIdsCode.put(acc.id,acc.FSL_Payer_Code__c);    
            }
        }
        //System.debug('::: mapAccIdsCode = '+mapAccIdsCode);
        for(account acc:[SELECT Id,name,FSL_ERP_Customer_Code__c FROM Account WHERE FSL_ERP_Customer_Code__c IN :mapAccIdsCode.values()])
        {
            mapCodeAccIds.put(acc.FSL_ERP_Customer_Code__c,acc.id);
        }
        //System.debug('::: mapCodeAccIds = '+mapCodeAccIds);
        
        list<WorkOrder> workOrderToUpdate = new list<WorkOrder>();
        System.debug('::: mapCodeAccIds = '+mapCodeAccIds);
        for(WorkOrder  wor : woList) {
            Id WorkAccountId; 
            if(wor.AccountId != null) { // When Account is there - Check Account Payer
                System.debug(':::wor.AccountId = '+wor.AccountId);
                WorkAccountId =  wor.AccountId;
                skipAssetCheck = true;
                if(wor.Payer__c == null){ //CT3-473:Override Payer only if payer is not selected in create new screen.
                    if(mapAccIdsCode.get(WorkAccountId) != null) {
                        wor.Payer__c = mapCodeAccIds.get(mapAccIdsCode.get(WorkAccountId));
                    } else{  
                        wor.Payer__c = WorkAccountId;
                    }
                }
            } else { // When Account is Blank and Asset is There - get from Asset's Account
                //System.debug('::: Check Asset > Account Not Direct Account');
                WorkAccountId = mapAssetAccIds.get(wor.assetId) != wor.AccountId ? wor.AccountId : mapAssetAccIds.get(wor.assetId) ;
                //Check Asset's account
                System.debug('::: WorkOrder = '+WorkAccountId);
                if(mapAssetAccIds.get(wor.assetId) != null) {
                    System.debug('::: WorkOrder = '+WorkAccountId);
                    WorkAccountId = mapAssetAccIds.get(wor.assetId);
                    skipAssetCheck = true;
                    if(wor.Payer__c == null){ //CT3-473:Override Payer only if payer is not selected in create new screen.
                        if(mapAccIdsCode.get(WorkAccountId) != null) {
                            wor.Payer__c = mapCodeAccIds.get(mapAccIdsCode.get(WorkAccountId));
                        } else { 
                            wor.Payer__c = WorkAccountId;
                        }
                    }
                } else {
                    wor.Payer__c = null;
                }
            }
            System.debug('::: WorkOrder = '+wor.Payer__c);
        }
        
        /*
FSL_WorkOrderListTriggerHandle.avoidAfterupdate = true;
FSL_WorkOrderListTriggerHandle.avoidBeforeUpdate = true;
if(workOrderToUpdate.size() > 0)
{
update workOrderToUpdate;    
}*/
    }
}