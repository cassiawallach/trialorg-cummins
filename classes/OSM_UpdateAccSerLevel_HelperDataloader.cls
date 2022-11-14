public class OSM_UpdateAccSerLevel_HelperDataloader {
    
       public static void dobeforeinsertOpertions(List<CSS_Accreditation__c> triggerNewList)
       {
           List<String> intList = new List<String>();
           Map<String,Id> strVsIdMap = new Map<String,Id>(); 
           for(CSS_Accreditation__c cssa : triggerNewList)
           {    system.debug('cssa.SP_CODE__c--->'+cssa.SP_CODE__c);
               if(cssa.SP_CODE__c != null )
               {
                   intList.add(cssa.SP_CODE__c+'');
               }
           }
           if(intList != null && intList.size()>0)
           {   
               for(Account a : [SELECT Id,IAM_Service_Provider_Code__c FROM Account WHERE IAM_Service_Provider_Code__c IN:intList ])
               {
                   strVsIdMap.put(a.IAM_Service_Provider_Code__c,a.Id);
               }
           }
           for(CSS_Accreditation__c cssa : triggerNewList)
           {
               if(cssa.SP_CODE__c != null  && !strVsIdMap.isEmpty() && strVsIdMap.containsKey(cssa.SP_CODE__c+'') )
               {
                   cssa.Account__c = strVsIdMap.get(cssa.SP_CODE__c+'');
                   cssa.Product_Details__c = '[{"PRODUCT_TYPE":"Electronics","PRODUCT_RANGE":"'+cssa.PRODUCT_RANGE__c+'","MARKET_APPLICATION":"'+cssa.MARKET_APPLICATION__c+'"}]';
               }
           }
           try{
              // insert triggerNewList;
              update triggerNewList;
           }
           catch (Exception e)
           {
               System.debug('Something went wrong ' + e.getMessage());
           }
       }
}