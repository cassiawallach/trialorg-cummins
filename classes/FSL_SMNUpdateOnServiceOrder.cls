public class FSL_SMNUpdateOnServiceOrder {
    
    public void BeforeInsert(List<WorkOrder> newList){
        List<WorkOrder> sm = new List<WorkOrder>();
        for(WorkOrder wo1 : newList){
            if(wo1.Asset.Service_Model__c != null){
                sm.add(wo1);
            }
        }
        if(!sm.isEmpty()){
            populateSMNLookup(sm);
        }
        
    }
    
    public void BeforeUpdate(Map<ID,WorkOrder> newMap, Map<ID,WorkOrder> oldMap){
        
        List<WorkOrder> smnChange = new List<WorkOrder>();
        List<WorkOrder> newList = new List<WorkOrder>(newMap.values());
        
        for(WorkOrder Wo : newList){
            if(oldMap!=null) {
                system.debug('Asset SMN:'+Wo.AssetId);
                system.debug('oldMap SMN:'+oldMap.get(Wo.id).AssetId);
                if(Wo.AssetId != null && Wo.AssetId != oldMap.get(Wo.id).AssetId ){
                    smnChange.add(Wo);
                    
                }
                else{
                    // newList[0].Service_Model__c =  oldMap.get(Wo.id).Service_Model__c ;
                    smnChange.add(Wo);
                }
            }
        }
        
        if(!smnChange.isEmpty()){
            populateSMNLookup(smnChange);
        }
        // FSL_workorderListTriggerHandle.avoidBeforeUpdate = true;
        // FSL_workorderListTriggerHandle.avoidAfterupdate = true;
    }
    
    private void populateSMNLookup(List<WorkOrder> mySMN){
        Set<String> smnName = new Set<String>();
        List<WorkOrder> assetId = new List<WorkOrder>();
        system.debug('SMN List:'+ mySMN);
       set<id> assetidSet=new set<id>(); //added As a part of FBI 393
        for(WorkOrder wo : mySMN){ 
           assetidSet.add(wo.AssetId);    //added As a part of FBI 393
        } //added As a part of FBI 393
          assetId = [SELECT id, Asset.Name,Asset.Service_Model__c from WorkOrder WHERE AssetId =: assetidSet]; //added As a part of FBI 393
        for(WorkOrder wo : mySMN){
            ////commented as a part of FBI 393- start
           /* if(wo.AssetId != null){
            assetId = [SELECT id, Asset.Name,Asset.Service_Model__c from WorkOrder WHERE AssetId =: wo.AssetId];
            system.debug('assetId:'+assetId[0].Asset.Service_Model__c);
            }*/
            if(!assetId.isEmpty()){             
                if(assetId[0].Asset.Service_Model__c == null){
                    wo.FSL_SMN__c = null;
                }else{
                    smnName.add(assetId[0].Asset.Service_Model__c);
                    system.debug('Asset SMN:'+smnName);
                }
             }           
        }
        Map<String,Id> smnNameToId = new Map<String,Id>();
        for( FSL_SMN_DTC__c c : [SELECT ID, Name FROM FSL_SMN_DTC__c WHERE Name IN :smnName ]){
            smnNameToId.put(c.Name,c.id);
            system.debug('smnName:'+smnNameToId);
            
        }
        
        for(WorkOrder wo : mySMN){
            if(!assetId.isEmpty()){
                if(assetId[0].Asset.Service_Model__c != null ){
                    system.debug('Value:'+smnNameToId.get(assetId[0].Asset.Service_Model__c));
                    wo.FSL_SMN__c = smnNameToId.get(assetId[0].Asset.Service_Model__c);
                }
            }
        }
        
    }
    
}