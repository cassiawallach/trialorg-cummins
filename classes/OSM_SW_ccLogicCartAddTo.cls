global class OSM_SW_ccLogicCartAddTo extends ccrz.ccLogicCartAddTo{

/*
global override Map<String,Object> processInputData(Map<String,Object> inputData) {  
    Map<String,Object> retData = super.process(inputData);
    system.debug('####### processInputData ####');
     List<Map<String,Object>> cartItemList
                = (List<Map<String,Object>>)inputData.get('cartItem');
      system.debug(cartItemList);
    return retData;
}*/
                
global override Map<String,Object> process(Map<String,Object> inputData) {                  
        ccrz.ccLog.log('debug:subscLogicProductPricing:inputData:E', inputData);
        Map<String,Object> retData = super.process(inputData);
        try {
            // inputData should now have priceResults and cartItem
            List<Map<String,Object>> cartItemList
                = (List<Map<String,Object>>)inputData.get('cartItem');
            ccrz.ccLog.log('debug:subscLogicProductPricing:productList', cartItemList);              
              
            system.debug('$$$$$$$$$$$$$$ cartItem $$$$$$$$$$$');
                    system.debug(cartItemList);
                
            }catch(Exception ex) {
            ccrz.ccLog.log('debug:subscLogicProductPricing:EXCEPTION',ex);
            ccrz.ccLog.log('debug:subscLogicProductPricing:EXCEPTION',ex.getLineNumber());
            }
            
            return retData;
        }
        
        
        global override Map<String,Object> setCartItemFields(Map<String,Object> inputData) {                  
       
        Map<String,Object> retData = null;
        try {
                System.debug('====Inside setCartItemFields=====');
                ccrz__E_CartItem__c wlItemTobeMoved = (ccrz__E_CartItem__c)inputData.get('Wishlist_Record');
            
            retData = super.setCartItemFields(inputData);
            ccrz__E_CartItem__c currentLine =(ccrz__E_CartItem__c)  retData.get('currItem');
            if(wlItemTobeMoved!=null)
            {
                currentLine.ccrz__DisplayProduct__c = wlItemTobeMoved.ccrz__DisplayProduct__c;
                System.debug('===wlItemTobeMoved is not null=='+currentLine);
            }
            
            System.debug('===retData==='+retData);
            for(String key : retData.keySet())
            {
                System.debug('=====Key===='+key);
            }
            
                
            }catch(Exception ex) {
                
            ccrz.ccLog.log('debug:subscLogicProductPricing:EXCEPTION',ex);
            System.debug('debug:subscLogicProductPricing:EXCEPTION'+ex.getStackTraceString());
            }
            
            return retData;
        }
        
        
       
        


}