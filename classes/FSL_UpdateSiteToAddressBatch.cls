/****
Run Batch for WorkOrder->

UpdateSiteToAddressBatch batchObj = new UpdateSiteToAddressBatch('WorkOrder');
Database.executeBatch(batchObj);

Run Batch for Asset->

UpdateSiteToAddressBatch batchObj = new UpdateSiteToAddressBatch('Asset');
Database.executeBatch(batchObj);
****/

public class FSL_UpdateSiteToAddressBatch implements Database.Batchable<sobject> {
    
    public String sobjectName;
    
    public FSL_UpdateSiteToAddressBatch(String sobjectName){
        this.sobjectName = sobjectName;
    }
    
    public Database.QueryLocator start(Database.batchablecontext BC){
        String query = '';
        if(sobjectName.equalsIgnoreCase('WorkOrder')){
            query = 'select id,Repair_Site_Name__c,Repair_Site_Address__c From WorkOrder Where Repair_Site_Address__c = null AND Repair_Site_Name__c != null';
        } else if(sobjectName.equalsIgnoreCase('Asset')){
            query = 'Select id,Site__c,FSL_Site__c From Asset Where FSL_Site__c = null AND Site__c != null';
        }
        return Database.getQueryLocator(query);
    } 
    
    public void execute(Database.BatchableContext BC,List<sobject> scope){
        Set<Id> SiteIdSet = new Set<Id>();
        //FOR WORKORDER
        if(sobjectName.equalsIgnoreCase('WorkOrder')){
            List<WorkOrder> woList = (List<WorkOrder>)scope;
            for(WorkOrder wo : woList){
                SiteIdSet.add(wo.Repair_Site_Name__c);      
            }
            Map<Id,Id> siteToAddressMap = getSiteToAddressMap(SiteIdSet);
            for(WorkOrder wo : woList){
                if(siteToAddressMap.containsKey(wo.Repair_Site_Name__c)){
                    wo.Repair_Site_Address__c = siteToAddressMap.get(wo.Repair_Site_Name__c);
                }
            }
            Database.update(woList,false); 
        }
        //FOR ASSET
        if(sobjectName.equalsIgnoreCase('Asset')){
            List<Asset> assetList = (List<Asset>)scope;
            for(Asset assetObj : assetList){
                SiteIdSet.add(assetObj.Site__c);      
            }
            Map<Id,Id> siteToAddressMap = getSiteToAddressMap(SiteIdSet);
            for(Asset assetObj : assetList){
                if(siteToAddressMap.containsKey(assetObj.Site__c)){
                    assetObj.FSL_Site__c = siteToAddressMap.get(assetObj.Site__c);
                }
            }
            Database.update(assetList ,false); 
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
    
    public Map<ID,ID> getSiteToAddressMap(Set<Id> SiteIdSet){
        List<Schema.Address> addressList = [Select id,IAM_Site__c From Address Where IAM_Site__c IN :SiteIdSet];
        Map<Id,Id> siteToAddressMap = new Map<Id,Id>();
        for(Schema.Address addr:addressList){
            siteToAddressMap.put(addr.IAM_Site__c,addr.id);
        }
        return siteToAddressMap;
    }
}