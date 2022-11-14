/**********************************************************************
Name:FSL_CL_ApplicationErrorMessage
Copyright Â© 2020  Cummins
================================================================
================================================================
Purpose:                                                            
-------  
This is used for the display of Application and validate to show
 error message on the WorkOrder.
===================================================================
===================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -    Sriprada Sesham   08/11/2020         INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_CL_ApplicationErrorMessage {
    
    public static void insertErrMessage(List<WorkOrder> woList) {
        System.debug('::: WorkOrders = '+woList);
        Set<Id> setAssetIds = new Set<Id>();
        for (WorkOrder wo : woList) 
        {
            if(wo.AssetId != null)
            setAssetIds.add(wo.AssetId);
        }
        List<WorkOrder> wo = new list<WorkOrder>();
        Map<Id,String> assetToApplicationCode=new  Map<Id,String>();
        if(!setAssetIds.isempty()){
        wo = [SELECT id,AssetId, Asset.Type__c, Asset.Product_Application_Code__c, Asset.Application__c FROM WorkOrder WHERE AssetId =: setAssetIds LIMIT 1];
        System.debug('WorkOrderRecord:***'+wo);
        //Map<Id,String> assetToApplicationCode=new  Map<Id,String>();
        for (Asset assert : [SELECT ID,Product_Application_Code__c FROM Asset where id =:setAssetIds]) 
        {
            assetToApplicationCode.put(assert.id,assert.Product_Application_Code__c);
        }
        }
        //System.debug('WorkOrderRecord:***'+wo[0].AssetId +'-'+ wo[0].Asset.Type__c+'-'+wo[0].Asset.Product_Application_Code__c);
        String appCode;
        if(!wo.isEmpty()) {
            if(wo[0].Asset.Application__c != null) {
                appCode = wo[0].Asset.Application__c.substringBefore('-').trim();
            } 
            
            String ErrorMessage = System.Label.FSL_MarketingApplicationErrMsg;
            List<CSS_JobEventTemporary__c> jeProductCodes = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c jeProductCode = new CSS_JobEventTemporary__c();
system.debug('####'+wo[0].Asset.Product_Application_Code__c);
            try{
                jeProductCodes = [SELECT id, Attribute1__c,Attribute2__c ,Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'MarketingApplicationCodes'  AND Attribute1__c =: wo[0].Asset.Product_Application_Code__c AND Attribute2__c =: appCode ];
                if(!jeProductCodes.isEmpty()){
                    jeProductCode=jeProductCodes[0];
                }
                system.debug('AppRecVal:'+jeProductCode.Attribute1__c+'----'+jeProductCode.Attribute2__c);
            }
            catch(Exception ex ){
                system.debug('in catch block exception -->'+ex.getMessage()+' Exception LineNo:'+ex.getLineNumber());
            }
            
            for(WorkOrder  wor : woList) {  
             
                if(wor.AssetId != null && appCode != null && assetToApplicationCode.get(wor.AssetId)!= null){
                    if(jeProductCode.Attribute1__c != assetToApplicationCode.get(wor.AssetId) && jeProductCode.Attribute2__c != appCode ){
                        wor.FSL_Application_Error_Message__c = ErrorMessage;
                        
                        System.debug('WorkOrderErrMessage:***'+wor.FSL_Application_Error_Message__c );
                        
                    }
                    else if(jeProductCode.Attribute1__c == wor.Asset.Product_Application_Code__c && jeProductCode.Attribute2__c == appCode){
                        wor.FSL_Application_Error_Message__c = '';
                        
                    }
                } 
            }
            
        }
        
    }
    
    public static void updateErrMessage(Map<Id, WorkOrder> newMap, Map<Id, WorkOrder> oldMap) {
        Set<Id> setAssetIds = new Set<Id>();
        list<WorkOrder> woList = new list<WorkOrder>(newMap.values());
        String appCode;
        String ProdAppCode;
        for (WorkOrder wo : woList) 
        {
            if(wo.AssetId != oldMap.get(wo.Id).AssetId && wo.Asset.Application__c != null && wo.Asset.Product_Application_Code__c != null) {
                setAssetIds.add(wo.AssetId);
                appCode = wo.Asset.Application__c.substringBefore('-');  
                ProdAppCode = wo.Asset.Product_Application_Code__c;
            } 
        }    
        
        list<WorkOrder> workOrderToUpdate = new list<WorkOrder>();
        List<CSS_Solution_Component__c> insertSolCmp = new List<CSS_Solution_Component__c>();
        
        String ErrorMessage = System.Label.FSL_MarketingApplicationErrMsg;
        Boolean checkErr;
        //   if(wo[0].Asset.Product_Application_Code__c != null) {
        
        CSS_JobEventTemporary__c jeProductAppCode = new CSS_JobEventTemporary__c();
        
        try{
            List<CSS_JobEventTemporary__c> jeProductAppCodeList = [SELECT id, Attribute1__c,Attribute2__c ,Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'MarketingApplicationCodes'  AND Attribute1__c =: ProdAppCode AND Attribute2__c =: appCode ];
            if(jeProductAppCodeList != null && !jeProductAppCodeList.isEmpty()) //CT2-388 : null check added
                jeProductAppCode = jeProductAppCodeList[0];
            system.debug('AppRecVal:'+jeProductAppCode.Attribute1__c+'----'+jeProductAppCode.Attribute2__c);
        }
        catch(Exception ex ){
            system.debug('in catch block exception -->'+ex.getMessage()+' Exception LineNo:'+ex.getLineNumber());
        }
        
        for(WorkOrder  wor : woList) {  
            WorkOrder wo = new WorkOrder();
            wo.Id = wor.id;
            if(wor.AssetId != null && appCode != null && wor.Asset.Product_Application_Code__c != null){
                if(jeProductAppCode.Attribute1__c != wor.Asset.Product_Application_Code__c && jeProductAppCode.Attribute2__c != appCode ){
                    
                    wo.FSL_Application_Error_Message__c = ErrorMessage;
                    System.debug('WorkOrderErrMessage:***'+wor.FSL_Application_Error_Message__c );
                    
                } else{
                     wo.FSL_Application_Error_Message__c = '';
                }
                
            }  else if(wor.AssetId != oldMap.get(wor.Id).AssetId) {
                if(jeProductAppCode.Attribute1__c != wor.Asset.Product_Application_Code__c && jeProductAppCode.Attribute2__c != appCode ){
                    
                    wo.FSL_Application_Error_Message__c = ErrorMessage;
                    System.debug('WorkOrderErrMessage:***'+wor.FSL_Application_Error_Message__c );
                    
                } else{
                    wo.FSL_Application_Error_Message__c = '';
                }
            }
            
            workOrderToUpdate.add(wo);  
        }
        
        FSL_WorkOrderListTriggerHandle.avoidAfterupdate = true;
        FSL_WorkOrderListTriggerHandle.avoidBeforeUpdate = true;
        if(workOrderToUpdate.size() > 0) {
            update workOrderToUpdate;  
        }
    }
    
}