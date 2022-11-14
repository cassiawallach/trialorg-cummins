global class OSM_SW_ccLogicCartPlace extends ccrz.ccLogicCartPlace {
    global override Map<String, Object> process(Map<String, Object> inputData) {
        ccrz.ccLog.log('******************OSM_SW_ccLogicCartPlace process***************************');
        ccrz.ccLog.log('*OSM_SW_ccLogicCartPlace ****inputData' + inputData);        
        Map<String, Object> outputData = super.process(inputData);
        ccrz.ccLog.log('*OSM_SW_ccLogicCartPlace ****outputData' + outputData);     
        Boolean isSuccess = (Boolean) outputData.get(ccrz.ccAPI.SUCCESS);
        String cartId = (String) inputData.get('cartId'); 
        List<ccrz__E_Cart__c> carts = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
        //List<ccrz__E_CartCoupon__c> couponApplied = [SELECT Id,ccrz__Cart__c,ccrz__Coupon__c FROM ccrz__E_CartCoupon__c WHERE ccrz__Cart__c =:cartId];
        List<String> ciCoupons = new List<String>();
        List<ccrz__E_CartItem__c> citems = new List<ccrz__E_CartItem__c>();
        if(!carts.isEmpty()){
            citems = [SELECT Id, ccrz__Product__c,ccrz__Quantity__c,ccrz__Coupon__c,ccrz__Cart__c, ccrz__Cart__r.ccrz__TotalQuantity__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: carts[0].Id]; 
        }
        ccrz.ccLog.log('*OSM_SW_ccLogicCartPlace ****carts' + carts); 

        Map<String,ccrz__E_CartItem__c> couponToCiMap = new Map<String,ccrz__E_CartItem__c>();
        for(ccrz__E_CartItem__c citem: citems){
            if(citem.ccrz__Coupon__c != null){
                ciCoupons.add(String.valueOf(citem.ccrz__Coupon__c));
                couponToCiMap.put(String.valueOf(citem.ccrz__Coupon__c),citem);
            }
        }
        ccrz.ccLog.log('*OSM_SW_ccLogicCartPlace ****citems' + citems); 
		ccrz.ccLog.log('*OSM_SW_ccLogicCartPlace ****couponToCiMap' + couponToCiMap);  
        ccrz.ccLog.log('****************** end OSM_SW_ccLogicCartPlace process***************************');  
        List<ccrz__E_Coupon__c> coupons = [SELECT Id, ccrz__RuleType__c, ccrz__TotalUsed__c FROM ccrz__E_Coupon__c WHERE Id IN: ciCoupons];
        ccrz.ccLog.log('*OSM_SW_ccLogicCartPlace ****coupons' + coupons);  
        for(ccrz__E_Coupon__c cp: coupons){
            // JK Changes to update total used for CartTotal Coupons - Total Quantity taken from Cart record July 11, 2019
            if(cp.ccrz__RuleType__c == 'CartTotal')
            {
               cp.ccrz__TotalUsed__c = cp.ccrz__TotalUsed__c + couponToCiMap.get(cp.Id).ccrz__Cart__r.ccrz__TotalQuantity__c - 1; 
            }
            else
            {
                cp.ccrz__TotalUsed__c = cp.ccrz__TotalUsed__c + couponToCiMap.get(cp.Id).ccrz__Quantity__c - 1;
            }
        }
        update coupons;

        return outputData;        
    }
}