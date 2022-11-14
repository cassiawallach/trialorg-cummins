public class dbu_availCurrentPromotions {
   /**
* Author : Mounika V
* Created on 13th October 2020
* Description : This class is used to fetch all available current promotions
*/
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_Product__c> getAllPromotionProducts(string urlParam){
        List<ccrz__E_Coupon__c> lstOfCoupan = new List<ccrz__E_Coupon__c>();
        List<ccrz__E_ProductSpec__c> lstOfSpec = new List<ccrz__E_ProductSpec__c>();
        List<ccrz__E_Product__c> lstOfProSpec = new List<ccrz__E_Product__c>();
        List<String> specIds = new List<String>();
        List<String> pSpecIds = new List<String>();
        lstOfCoupan = [Select id,ccrz__CouponName__c, ccrz__TargetSpec__c from ccrz__E_Coupon__c where DBU_Promotion__c = true];
        system.debug('lstOfCoupan ' + lstOfCoupan);
        for(ccrz__E_Coupon__c obj :  lstOfCoupan){
            specIds.add(obj.ccrz__TargetSpec__c);
        }//a3O19000000X9D9EAK
        lstOfSpec = [select id,ccrz__Product__c from ccrz__E_ProductSpec__c where ccrz__Spec__c IN :  specIds ];
        system.debug('lstOfSpec ' + lstOfSpec);
        for(ccrz__E_ProductSpec__c pSpec : lstOfSpec){
            pSpecIds.add(pSpec.ccrz__Product__c);
        }
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);
    
        string currencyISOvalue = (string)countryCurrencyMap.get(urlParam); 
        system.debug('urlParam>>' +urlParam);
        system.debug('currencyISOvalue' +currencyISOvalue); 
        List<String> urlStoreLoc = new List<String>{urlParam};
        
        //following query modified by malhar for store toggling of location - 4/12/2020
        lstOfProSpec = [select id, name,dbu_Image_Src__c,(select id,ccrz__Price__c,ccrz__Pricelist__c,ccrz__Pricelist__r.ccrz__CurrencyISOCode__c,dbu_Original_Price__c from ccrz__E_PriceListItems__r Where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),(select id,ccrz__MediaType__c,ccrz__URI__c from ccrz__E_ProductMedias__r WHERE ccrz__MediaType__c =: 'Product Image' limit 1) from ccrz__E_Product__c where  DBU_Product_Location__c INCLUDES (:urlParam)  and Group_Name__c='Ecom' and  id IN : pSpecIds];
        // lstOfProSpec = [select id,ccrz__Product__c from ccrz__E_ProductSpec__c where id IN :  pSpecIds];
        system.debug('lstOfProSpec ' + lstOfProSpec);
        return lstOfProSpec;
    }


}