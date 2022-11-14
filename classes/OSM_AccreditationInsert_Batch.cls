global class OSM_AccreditationInsert_Batch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        date d = system.today();
        String query = 'SELECT Id, SP_CODE__c, Account__c, Product_Details__c, PRODUCT_RANGE__c, MARKET_APPLICATION__c FROM CSS_Accreditation__c WHERE CreatedDate >=: d'; 
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CSS_Accreditation__c> accredList)
    {
        try{
            system.debug('accredList '+accredList.size());
            Set<ID> accountIDSet = new Set<ID>();
            if(accredList.size() > 0 ){
                OSM_UpdateAccSerLevel_HelperDataloader.dobeforeinsertOpertions(accredList);
            }
        }catch(Exception e){
            system.debug('In exception block of OSM_AccreditationInsert_Batch '+e.getMessage()+'  '+e.getLineNumber());
        }
    }
    
    global void finish(Database.BatchableContext BC)
    {
    } 
}