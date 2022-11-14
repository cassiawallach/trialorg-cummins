global class OSM_AccreditationUpdate_Batch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        date d = system.today();
        String query = 'SELECT Id, SP_CODE__c, Account__c, Product_Details__c, PRODUCT_RANGE__c, MARKET_APPLICATION__c, Service_Level_Update__c FROM CSS_Accreditation__c WHERE Service_Level_Update__c = true'; 
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CSS_Accreditation__c> accredList)
    {
        try{
            system.debug('accredList '+accredList.size());
            Set<ID> accountIDSet = new Set<ID>();
            List<CSS_Accreditation__c> updAccLst = new List<CSS_Accreditation__c>();
            if(accredList.size() > 0)
            {
                for(CSS_Accreditation__c accr : accredList)
                {
                    accountIDSet.add(accr.Account__c);
                }
            }
            
            if(null != accountIDSet && accountIDSet.size() > 0)
            {
                OSM_UpdateAccountServiceLevel_Helper.updateAccountServiceLevel(accountIDSet);
            }
            //Updating Service_Level_Update__c to false
            for(CSS_Accreditation__c accr : accredList)
            {
                CSS_Accreditation__c accrTemp = new CSS_Accreditation__c();
                accrTemp.Id = accr.Id;
                accrTemp.Service_Level_Update__c = false;
                updAccLst.add(accrTemp);
            }
            if(updAccLst != null && updAccLst.size() > 0){
                update updAccLst;
            }
        }catch(Exception e){
            system.debug('In exception block of OSM_AccreditationInsert_Batch '+e.getMessage()+'  '+e.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
    } 
}