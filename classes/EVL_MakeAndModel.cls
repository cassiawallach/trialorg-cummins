/*****************************************************************************************************************************
Name:EVL_MakeAndModel
Copyright © 2020  Cummins
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
1.0 - Krishnamoorthi     05/19/2020      INITIAL DEVELOPMENT 
2.0 - Piyush             07/27/2020      Logic to update SO Application field on Asset, Method to insert MakeModelStg record.  
******************************************************************************************************************************/
public class EVL_MakeAndModel {
    
    @auraenabled
    public static Boolean getLockAssetStatus(Id woId)
    {
        /* Updated by Sriprada for POC of MakeModel lockdown before proceeding to Troubleshooting*/
        
       // String isAssetLocked = [SELECT FSL_Locked_Assest__c FROM WorkOrder WHERE id=:woId].FSL_Locked_Assest__c;
       WorkOrder wor = [SELECT AssetId,Asset.Make__c, Asset.Model__c, Status,FSL_Locked_Assest__c FROM WorkOrder WHERE id=:woId];
        List<CSS_Fault_Code__c> FCcount = [SELECT id, Name from CSS_Fault_Code__c where Service_Order__c =:woId LIMIT 1];
        system.debug('Lockdown::'+FCcount);

        if((FCcount.size() > 0 && wor.Asset.Make__c != null && wor.Asset.Model__c != null) || (wor.Status == 'Closed' && wor.FSL_Locked_Assest__c == null)){
            return true;
        } else{
            return false;
        }
      /*  if(String.isBlank(isAssetLocked)) {
            return false;
        }            
        else {
            return true;
        }*/
    }
    
    @AuraEnabled
    public static List<String> getWOMakeModels(Id woId) {
        WorkOrder wo = [SELECT  Make__c, Model__c, Asset.Engine_Family__c, Asset.Engine_Family_Code__c, FSL_Locked_Assest__c 
                        FROM WorkOrder WHERE id=:woId];
        // commented condition by vinod 9/25
        // if(String.isNotBlank(wo.make__c) && String.isNotBlank(wo.model__c))
        return new list<String>{wo.Make__c, wo.Model__c};
        // else return new list<String>{''};
    }
    
    @AuraEnabled
    public static WorkOrder fetchWORecord(String recordId){
        
        return [Select Id, Status from WorkOrder where Id =: recordId LIMIT 1];
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
    public static Boolean saveMakeModels(Id atId, String make, String model, String woId, String app,Boolean flag)
    {
        try
        {
            Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
            List<Asset> ats = [SELECT Id, Engine_Family_Code__c, Application__c, Application_Code__c, Make_Model__c FROM Asset WHERE Id = : atId AND Engine_Manufacturer__c = 'CUMMINS' LIMIT 1];
            if(!ats.isEmpty()) {
                CSS_Make_Model_Access__c cssMakeModelAcc = [SELECT Id, Access__c, EquipmentId__c, RecordTypeId FROM CSS_Make_Model_Access__c 
                                                            WHERE Make__c =: make 
                                                            AND Model__c =: model 
                                                            AND EngineFamilyCode__c =: ats[0].Engine_Family_Code__c 
                                                            AND RecordTypeId =: SRTRecordTypeId 
                                                            LIMIT 1];
                // ats.Access_Code__c = cssMakeModelAcc.Access__c;
                ats[0].Make_Model__c  = cssMakeModelAcc.Id;
                if(app != null || app != '') {
                    ats[0].Application__c = app;
                    ats[0].Application_Code__c = app.substringBefore('-').trim();
                }
                
                update ats[0];
                
                try {
                    system.debug('Flag:::'+flag);
                    String str = insertMakeModelStaging(woId,flag);
                } catch(exception ex) {
                    System.debug('::: Exception in insertMakeModelStaging - '+ex.getMessage());
                }
                
                    
            }
            
            WorkOrder wo = new WorkOrder(Id = woID, Make__c = make, Model__c = model);
            update wo;
            return true;
        }
        
        catch(System.Exception e)
        {
            System.debug('::: saveMakeModels - '+e.getMessage());
            return false;
        }
    }
    
    @auraEnabled
    public static String getAssetId(Id woId)
    {
        system.debug('woId::'+woId);
        return [SELECT assetId FROM workorder WHERE id=:woId].assetId;
    }
    
    // Below method Added by Priyanka for Application definition LOV on 11/10/2021 |VGRS2-76 
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
            if(appCode != null || appCode != ''){
                wo.Application__c = appCode;  
            }
            cssSol.Name = 'TestAppErr';
            cssSol.FSL_Service_Order__c = wo.Id;
            insert cssSol;                         // For Auto refresh to update application on WO
            update wo;
            system.debug('Updated WO:'+wo);
            delete cssSol;
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
    //Method to insert record in FSL_MakeModel_Stage__c object for batch -Added by Piyush
    @AuraEnabled
    public static string  insertMakeModelStaging(string servicejobid,boolean flag) {
        // string strResult;
        list<FSL_MakeModel_Stage__c> lstmake = new list<FSL_MakeModel_Stage__c>();
        if(servicejobid != null && servicejobid != '') {
            for(WorkOrder objorder : [SELECT Id, Make__c, Model__c,FSL_SMN__c, FSL_Make_Model_Flag__c,Asset.Name,Asset.Type__c, Asset.Make__c, Asset.Model__c, Asset.Product_Application_Code__c,Application__c FROM WorkOrder WHERE Id=:servicejobid]) {
                System.debug('::: WorkOrder Value - Make = '+objorder.Make__c+' Model__c = '+objorder.Model__c+' FSL_Make_Model_Flag__c = '+objorder.FSL_Make_Model_Flag__c);
                if(objorder.Asset.Make__c != null && objorder.Asset.Model__c != null && flag && objorder.FSL_SMN__c != null){
                    FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
                    //objstage.Manufacturer__c = objorder.Make__c;
                    //objstage.ModelSeries__c = objorder.Model__c;
                    objstage.Manufacturer__c = objorder.Asset.Make__c;
                    objstage.ModelSeries__c = objorder.Asset.Model__c;
                    if(objorder.Application__c !=null){
                        objstage.ProductApplicationCode__c = string.valueof(objorder.Application__c.SubStringBefore('-'));
                    }
                    objstage.PSN__c = objorder.Asset.Name;
                    
                    if(objorder.Asset.Type__c == 'ENGINE' ||
                       objorder.Asset.Type__c == 'GENSET' ||
                       objorder.Asset.Type__c == 'Engines'){
                           objstage.Type__c = 'Engines';
                           objstage.Type_PSN__c = 'Engines-' + objorder.Asset.Name;
                     } else if( objorder.Asset.Type__c == 'FIREPUMP' ||
                                objorder.Asset.Type__c == 'ENGINE CORE' ||
                                objorder.Asset.Type__c == 'SWITCH GEAR' ||
                                objorder.Asset.Type__c == 'TRANSFER SWITCH' ||
                                objorder.Asset.Type__c == 'TRANSMISSIONS' ||
                                objorder.Asset.Type__c == 'BATTERY' ||
                                objorder.Asset.Type__c == 'PARSYS' ||
                                objorder.Asset.Type__c == 'MARINE GEAR' ||
                                objorder.Asset.Type__c == 'Products') {
                                    
                                    objstage.Type__c = 'Products';
                                    objstage.Type_PSN__c = 'Products-' + objorder.Asset.Name;
                                }
                    
                    lstmake.add(objstage);
                }
            }
            system.debug('*** Record Size---->'+lstmake.size());
            if(lstmake.size() > 0) {
                List<Database.upsertResult> updateinsertResults = Database.upsert(lstmake, FSL_MakeModel_Stage__c.Type_PSN__c.getDescribe().getSObjectField(), false);
                for (Database.upsertResult sr : updateinsertResults ) {
                    if (sr.isSuccess()) {
                        System.debug('*** Successfully inserted/updated MakeModelStage: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            // strResult = err.getMessage();
                            System.debug('Asset fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }
        return null;
    }
}