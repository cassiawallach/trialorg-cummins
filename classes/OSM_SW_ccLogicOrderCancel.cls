global class OSM_SW_ccLogicOrderCancel extends ccrz.ccLogicOrderCancel {

    global override Map<String, Object> process(Map<String, Object> inputData)
    {
        
      
        
         for(String key:inputData.keySet())
        {
            ccrz.ccLog.log('************OSM_SW_ccLogicOrderCancel--cancelOrder*****************KEY********** '+key);
            ccrz.ccLog.log('************OSM_SW_ccLogicOrderCancel--cancelOrder*****************VALUE********** '+inputData.get(key));
    		System.debug('************OSM_SW_ccLogicOrderCancel--cancelOrder*****************KEY********** '+key);
            System.debug('************OSM_SW_ccLogicOrderCancel--cancelOrder*****************VALUE********** '+inputData.get(key));
        }
        
        OSM_SW_ccServiceOrder.orderOperation = 'OrderCancel';
        Map<String,Object> returnMap = super.process(inputData);
        ccrz.ccLog.log('************OSM_SW_ccLogicOrderCancel--cancelOrder 1*************************** '+(returnMap!=null && returnMap.containsKey('success') && returnMap.get('success')=='true'));
         
        
        /*if(returnMap!=null && returnMap.containsKey('success') )
        {
            
            Boolean success = (Boolean)returnMap.get('success');
            if(success==true)
            {
            
                if(inputData!=null && inputData.containsKey('orderId'))
             	{
                    String orderId = (String)inputData.get('orderId');
                    String orderCancelledByUserId = System.UserInfo.getUserId();  
                    List<ccrz__E_Order__c> order = [select id,Order_Cancelled_By_CSR__c from ccrz__E_Order__c where id=:orderId limit 1] ;
                    order[0].Order_Cancelled_By_CSR__c = orderCancelledByUserId;
                     update order[0];
                }
        	}
        }
		*/
        
		//Map<String,Object> returnMap = new Map<String,Object>();
		 for(String key:returnMap.keySet())
        {
            ccrz.ccLog.log('************OSM_SW_ccLogicOrderCancel--cancelOrder*****************KEY********** '+key);
            ccrz.ccLog.log('************OSM_SW_ccLogicOrderCancel--cancelOrder*****************VALUE********** '+returnMap.get(key));
    		System.debug('**************OSM_SW_ccLogicOrderCancel--cancelOrder*****************KEY********** '+key);
            System.debug('***********OSM_SW_ccLogicOrderCancel--cancelOrder*****************VALUE******* '+returnMap.get(key));
        }
        
        
        return returnMap;
    }
    
}