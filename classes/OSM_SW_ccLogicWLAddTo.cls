global with sharing class OSM_SW_ccLogicWLAddTo extends ccrz.ccLogicWLAddTo
{

   /* global virtual override Map<String,Object> createWishListItems(Map<String,Object> inputData)
    {
        System.debug('======input data : '+inputData);
        for(String key: inputData.keySet())
        {
            ccrz.ccLog.log('testing.........Key...'+key);
            ccrz.ccLog.log('testing.........Key...'+inputData.get(key));
            
        }
        
        Map<String,Object> outputMap = super.createWishListItems(inputData);
        System.debug('======Inside CMI_SW_ccLogicWLAddTo====createWishListItems==='+outputMap);
        ccrz.ccLog.log('======Inside CMI_SW_ccLogicWLAddTo====createWishListItems===');
        System.debug('======ccrz.ccAPIWishList.WISHLIST_ITEMS==='+ccrz.ccAPIWishList.WISHLIST_ITEMS);
        
        Map<String,Object> productIdVsWLMap =(Map<String,Object>) outputMap.get(ccrz.ccAPIWishList.WISHLIST_ITEMS);
        System.debug('======productIdVsWLMap==='+productIdVsWLMap);
         
                if(inputData!=null && inputData.containsKey('wishlistItemNew'))
                {
                     ccrz__E_CartItem__c wishlistItem = (ccrz__E_CartItem__c)inputData.get('wishlistItemNew');
                     String productId = wishlistItem.ccrz__Product__c;
                     if(productId!=null && productIdVsWLMap !=null && productIdVsWLMap.containsKey(productId))
                     {
                     
                        System.debug('====Got the product in CC API==='+productId);
                        ccrz__E_CartItem__c wlItem =(ccrz__E_CartItem__c)productIdVsWLMap.get(productId);
                        System.debug('===ccrz__E_CartItem__c from Services==='+wlItem);
                          
                          wlItem.ccrz__OriginalItemPrice__c=wishlistItem.ccrz__OriginalItemPrice__c;
                          wlItem.ccrz__OriginalQuantity__c=wishlistItem.ccrz__OriginalQuantity__c;
                          wlItem.ccrz__DisplayProduct__c = wishlistItem.ccrz__DisplayProduct__c;
                          wlItem.ccrz__Price__c=wishlistItem.ccrz__Price__c;
                          wlItem.ccrz__SubAmount__c=wishlistItem.ccrz__SubAmount__c;
                          wlItem.ccrz__RecurringPriceSubAmt__c=wishlistItem.ccrz__RecurringPriceSubAmt__c;
                          wlItem.ccrz__RecurringPrice__c=wishlistItem.ccrz__RecurringPrice__c;
                          wlItem.ccrz__SubProdTerm__c = wishlistItem.ccrz__SubProdTerm__c;
                          wlItem.ccrz__StoreID__c = wishlistItem.ccrz__StoreID__c;
                          wlItem.ccrz__Quantity__c = wishlistItem.ccrz__Quantity__c;
                     
                     System.debug('===wlItem from Services==='+wlItem);                      
                     }
                     

                     System.debug('===wishlistItem==='+wishlistItem);
                }
                else
                {
                   System.debug('===wishlistItem is null===');
                }
                
        
        return outputMap;
       
    }
 */ 

}