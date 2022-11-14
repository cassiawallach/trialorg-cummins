/**********************************************************************
Name:FSLMakeModelCls
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the display of Make Model on the WorkOrder.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLMakeModelCls {
    
    @auraenabled
    public static Boolean getLockAssetStatus(Id woId)
    {
        String isAssetLocked = [SELECT FSL_Locked_Assest__c FROM WorkOrder WHERE id=:woId].FSL_Locked_Assest__c;
        if(String.isBlank(isAssetLocked)) {
            return false;
        }            
        else {
            return true;
        }
    }
    //Below Method Added by Harish Kolasani for CT2-
    
     @auraenabled
    public static Boolean isAssetCumminsOrNot(Id woId)
    {
        List<WorkOrder> workOrderWithCumminsAsset = [SELECT Asset.Engine_Manufacturer__c FROM WorkOrder WHERE id=:woId AND Asset.Engine_Manufacturer__c = 'CUMMINS'];
        if(workOrderWithCumminsAsset!=null && !workOrderWithCumminsAsset.isEmpty()) {
            return true;
        }            
        else {
            return false;
        }
    }
    @AuraEnabled
    public static List<String> getWOMakeModels(Id woId) {
        WorkOrder wo = [SELECT  Make__c, Model__c, Asset.Engine_Family__c, Asset.Engine_Family_Code__c, FSL_Locked_Assest__c 
                        FROM WorkOrder WHERE id=:woId];
        // commented condition by vinod 9/25
        // if(String.isNotBlank(wo.make__c) && String.isNotBlank(wo.model__c))
        String make = String.isNotBlank(wo.Make__c) ? wo.Make__c:'';
        return new list<String>{make, wo.Model__c};
        // else return new list<String>{''};
    }
    
    @AuraEnabled
    public static Map<String, List<String>> getMakeModels(Id woId)
    {
        Map<String, List<String>> makeModelsMap = new Map<String, List<String>>();
        WorkOrder wo = [SELECT Asset.Engine_Family__c, Asset.Engine_Family_Code__c, FSL_Locked_Assest__c FROM WorkOrder WHERE id=:woId];
        Set<String> modelsKeys = new Set<String>();
        List<String> modelLst;
        system.debug(wo.Asset.Engine_Family__c);
        
        Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        for(CSS_Make_Model_Access__c mm : [SELECT Make__c, Model__c, EngineFamilyCode__c, RecordTypeId FROM CSS_Make_Model_Access__c 
                                           WHERE EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c AND RecordTypeId =: SRTRecordTypeId 
                                           AND Make__c != null AND Make__c != '' ORDER BY Make__c, Model__c])
        {
            if(makeModelsMap == null) {
                makeModelsMap = new Map<String, List<String>>();
            }
            if(makeModelsMap.containsKey(mm.Make__c)) {
                makeModelsMap.get(mm.Make__c).add(mm.Model__c);
            }
            else {
                makeModelsMap.put(mm.Make__c, new List<String>{mm.Model__c});
            }
        }
        system.debug('after sorting>>'+makeModelsMap);
        return makeModelsMap;
    }
    
    @AuraEnabled
    public static Boolean saveMakeModels(Id atId, String make, String model, String woId)
    {
        try
        {
            Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
            Asset ats = [SELECT Id, Engine_Family_Code__c, Make_Model__c FROM Asset WHERE Id = : atId LIMIT 1];
            CSS_Make_Model_Access__c cssMakeModelAcc = [SELECT Id, Access__c, EquipmentId__c, RecordTypeId FROM CSS_Make_Model_Access__c 
                                                        WHERE Make__c =: make 
                                                        AND Model__c =: model 
                                                        AND EngineFamilyCode__c =: ats.Engine_Family_Code__c 
                                                        AND RecordTypeId =: SRTRecordTypeId 
                                                        LIMIT 1];
            
            // ats.Access_Code__c = cssMakeModelAcc.Access__c;
            ats.Make_Model__c  = cssMakeModelAcc.Id;
            
            update ats;
            
            WorkOrder wo = new WorkOrder(Id = woID, Make__c = make, Model__c = model);
            update wo;
            return true;
        }
        
        catch(System.Exception e)
        {
            return false;
        }
    }
    @AuraEnabled
    public static Boolean saveMakeModelsForNonCumminsAsset(Id atId, String make, String model, String woId)
    {
        System.debug('atId'+atId);
        System.debug('make'+make);
        System.debug('model'+model);
        System.debug('woId'+woId);
        try
        {
            Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
            Asset ats = [SELECT Id, Engine_Family_Code__c, Make_Model__c FROM Asset WHERE Id = : atId LIMIT 1];
            /*CSS_Make_Model_Access__c cssMakeModelAcc = [SELECT Id, Access__c, EquipmentId__c, RecordTypeId FROM CSS_Make_Model_Access__c 
                                                        WHERE Make__c =: make 
                                                        AND Model__c =: model 
                                                        AND EngineFamilyCode__c =: ats.Engine_Family_Code__c 
                                                        AND RecordTypeId =: SRTRecordTypeId 
                                                        LIMIT 1];*/
            
            // ats.Access_Code__c = cssMakeModelAcc.Access__c;
            ats.Make__c	  = make;
            ats.Model__c = model;
            update ats;
            
            WorkOrder wo = new WorkOrder(Id = woID, Make__c = make, Model__c = model);
            update wo;
            return true;
        }
        
        catch(System.Exception e)
        {
            return false;
        }
    }
    
    @auraEnabled
    public static String getAssetId(Id woId)
    {
        system.debug('woId::'+woId);
        return [SELECT assetId FROM workorder WHERE id=:woId].assetId;
    }
    
    @AuraEnabled
    public static List<String> getApplicationCode(Id woId) {
        WorkOrder wo = [SELECT  Application__c, Asset.Application__c 
                        FROM WorkOrder WHERE id=:woId];  
        return new list<String>{wo.Application__c};
      
    }
    
    @AuraEnabled
    public static String getAppErrorMsg(Id woId) {
        WorkOrder wo = [SELECT  FSL_Application_Error_Message__c  
                        FROM WorkOrder WHERE id=:woId];  
        return wo.FSL_Application_Error_Message__c;
      
    }
    
   // Below method Added by Sripal Kotha for Application definition LOV on 03/05/2021 |CT2-85 
    @AuraEnabled
    public static Map<String,String>getApplicationDescMetadata(){
        List<FSL_Application_Description__mdt> AppDescMetadaList = new List<FSL_Application_Description__mdt>();
        AppDescMetadaList = [SELECT Application__c,Description__c FROM FSL_Application_Description__mdt];
        Map<String,String> AppMetadataMap = new Map<String,String>();
        for(FSL_Application_Description__mdt meta:AppDescMetadaList){
            if(!AppMetadataMap.containsKey(meta.Application__c)){
                AppMetadataMap.put(meta.Application__c,meta.Description__c);
            } else{
                AppMetadataMap.get(meta.application__c);
            }
            
        }
        
        
        return AppMetadataMap;
        
    }
    @AuraEnabled
    public static boolean validateApplicationCode(string woId,string appCode) {
        string applicationCode;
        string checkApplicationCode;
        Boolean checkAppCode;
        String ErrorMessage = System.Label.FSL_MarketingApplicationErrMsg;

        WorkOrder wo = [SELECT  Application__c, Asset.Application__c, Asset.Product_Application_Code__c
                        FROM WorkOrder WHERE id=:woId];  
        if(appCode != null || appCode != ''){
             applicationCode = appCode.substringBefore('-');
            checkApplicationCode = applicationCode.trim();
           
        }
        system.debug('AppCodeVal:'+applicationCode);
        system.debug('CheckAppCodeVal:'+checkApplicationCode);

        system.debug('AppProdCodeVal:'+wo.Asset.Product_Application_Code__c);

        List<CSS_Solution_Component__c> insertSolCmp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c cssSol = new CSS_Solution_Component__c();
        CSS_JobEventTemporary__c jeProductCode = new CSS_JobEventTemporary__c();
        try{
        jeProductCode = [SELECT id, Attribute1__c,Attribute2__c ,Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'MarketingApplicationCodes'  AND Attribute1__c =: wo.Asset.Product_Application_Code__c AND Attribute2__c =: checkApplicationCode ];
               system.debug('AppRecVal:'+jeProductCode.Attribute1__c+'----'+jeProductCode.Attribute2__c);
        }
        catch(Exception ex ){
            system.debug('in catch block exception -->'+ex.getMessage()+' Exception LineNo:'+ex.getLineNumber());
        }

        if(jeProductCode.Attribute1__c != wo.Asset.Product_Application_Code__c && jeProductCode.Attribute2__c != checkApplicationCode && (checkApplicationCode != '' )){
          
            checkAppCode = false;
            wo.Application__c = appCode; 
            wo.FSL_Application_Error_Message__c = ErrorMessage;
            cssSol.Name = 'TestAppErr';
            cssSol.FSL_Service_Order__c = wo.Id;
            insert cssSol;                        // Inserted for Auto refresh to update application on WO
            update wo;
            system.debug('Updated WO:'+wo);
            delete cssSol;
            
        } else if(jeProductCode.Attribute1__c == wo.Asset.Product_Application_Code__c && jeProductCode.Attribute2__c == checkApplicationCode && (checkApplicationCode != '' )){
           checkAppCode = true;
            wo.Application__c = appCode; 
            wo.FSL_Application_Error_Message__c = '';
            cssSol.Name = 'TestAppErr';
            cssSol.FSL_Service_Order__c = wo.Id;
            insert cssSol;                        // For Auto refresh to update application on WO
            update wo;
            system.debug('Updated WO:'+wo);
            delete cssSol;
            
        } else{
            checkAppCode = true;
            wo.FSL_Application_Error_Message__c = '';
            wo.Application__c = appCode;
            cssSol.Name = 'TestAppErr';
            cssSol.FSL_Service_Order__c = wo.Id;
            insert cssSol;                         // For Auto refresh to update application on WO
            update wo;
            system.debug('Updated WO:'+wo);
            delete cssSol;
        }
        
        /* CT3-609 */
        if(appCode != null || appCode != '' && wo.AssetId != null){
            Asset ats = [SELECT Id, Application_Description__c, Application_Code__c, Application__c, Product_Application_Code__c FROM Asset WHERE Id = : wo.AssetId LIMIT 1];
            string appDescription = appCode.substringAfter('-');
            ats.Application__c = appCode;
            ats.Application_Code__c = checkApplicationCode;
            ats.Application_Description__c = appDescription.trim();

            update ats;

            system.debug('appCode ::'+appCode+ ' ::ats :: '+ats);
        }
       

        return checkAppCode;
    }
    
    @AuraEnabled
    public static List<String> getPicklistvalues(String objectName, String field_apiname,Boolean nullRequired){
        List<String> optionlist = new List<String>();       
        Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String, Schema.SObjectField> field_map = gd.get(objectName.toLowerCase()).getDescribe().fields.getMap();        
        List<Schema.PicklistEntry> picklistValues = field_map.get(field_apiname).getDescribe().getPickListValues(); 
       
        if(nullRequired == true){
            optionlist.add('--None--');
        }       
        for (Schema.PicklistEntry pv : picklistValues) {
            optionlist.add(pv.getValue());
        }
        return optionlist;
    }
}