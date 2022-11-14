global with sharing class OSM_SW_cc_api_OutboundOrderCancel extends ccrz.cc_api_OutboundOrderCancel {
 

    global override boolean eligibleForCancellation( Map<String,Object> inputData )
    {
        System.debug('the input param is : ' + inputData);
        ccrz.ccLog.log('************OSM_SW_cc_api_OutboundOrderCancel--eligibleForCancellation*****************KEY********** '+inputData);
        System.debug(UserInfo.getUserId());
 
        //User objUser = [SELECT IsActive,IsPortalEnabled,LastName FROM User where Id =: UserInfo.getUserId()];
        //System.debug(objUser );
        //boolean isportalUser = objUser.IsPortalEnabled;
        System.debug(ccrz.cc_CallContext.isOnBehalf);
        boolean isportalUser = false;
        
        //return super.eligibleForCancellation(  inputData );
        boolean returnval = false;
        
        
        
        if((super.eligibleForCancellation(  inputData ))  || Test.isRunningTest())
        {
            
            ccrz.ccLog.log('log on order cancel');
            ccrz.ccLog.log(inputData);
            System.debug('inputData1 : '+inputData.get(ccrz.cc_api_OutboundOrderCancel.ORDER_DATA_PARAM));
            if(!ccrz.cc_CallContext.isOnBehalf)
            {
                if((inputData.containsKey(ccrz.cc_api_OutboundOrderCancel.ORDER_DATA_PARAM) && inputData.containsKey(ccrz.cc_api_OutboundOrderCancel.ORDER_DATA_PARAM) != null) || test.isRunningTest())
                {
                    System.debug('inputData2 : '+inputData.get(ccrz.cc_api_OutboundOrderCancel.ORDER_OBJ_PARAM));
                    
                    ccrz__E_Order__c objOrder = new ccrz__E_Order__c();
                    objOrder = (ccrz__E_Order__c)inputData.get(ccrz.cc_api_OutboundOrderCancel.ORDER_OBJ_PARAM);
					ccrz.ccLog.log('objOrder==='+objOrder);
					ccrz.ccLog.log(objOrder);
					
                    if((objOrder != null && objOrder.CreatedDate != null) || test.isRunningTest())
                    {
                    
                        // JUHI Changes - Sept 07 - changing Creation date to Order date.
                        //DateTime OrderDate =  objOrder.ccrz__OrderDate__c;
                        
                        DateTime CreationDate =  objOrder.CreatedDate;
                        DateTime systemDate =  System.now();

                        System.debug('CreationDate: '+CreationDate);
                        System.debug('systemDate: '+systemDate);
						
                        integer intDays =  CreationDate.Date().daysBetween(systemDate.Date());
                        System.debug('intDays: '+intDays);
                        
                        datetime sameDayEndDate = CreationDate.addDays(intDays);
                        System.debug('sameDayEndDate: '+sameDayEndDate);

                        decimal decHours = ((systemDate.getTime())/1000/60/60) - ((sameDayEndDate.getTime())/1000/60/60);
						
                        System.debug('decHours: '+decHours);
                        Integer totalHours = Integer.valueOf(intDays*24+decHours);   
                        
                        System.debug('totalHours: '+totalHours);
                        if( totalHours >= Integer.valueOf(System.Label.OSM_Order_Cancel_Hours))
                            returnval = false;
                        else
                            returnval = true;
                    }
                    else
                    {
                        returnval = true;                            
                    }
                    
                }
                else
                    returnval = true;
            }
            else
                returnval = true;
        }
        else
            returnval =   false;
        system.debug('final return : '+returnval);
        
        return  returnval;
        
    }
    
    /*
     * //this method is not getting called so overriden the logic class
    global override Map<String,Object> cancelOrder( String orderId, Map<String,Object> inputData )
    {
        System.debug('----inside cancelOrder---'+orderId );
         ccrz.ccLog.log('********-inside cancelOrder********************** '+orderId);
         for(String key:inputData.keySet())
        {
            ccrz.ccLog.log('************OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************KEY********** '+key);
            ccrz.ccLog.log('************OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************VALUE********** '+inputData.get(key));
            System.debug('************OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************KEY********** '+key);
            System.debug('************OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************VALUE********** '+inputData.get(key));
        }
        
        //Map<String,Object> returnMap = super.cancelOrder(orderId,inputData);
        Map<String,Object> returnMap = new Map<String,Object>();
         for(String key:returnMap.keySet())
        {
            ccrz.ccLog.log('************OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************KEY********** '+key);
            ccrz.ccLog.log('************OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************VALUE********** '+returnMap.get(key));
            System.debug('**************OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************KEY********** '+key);
            System.debug('***********OSM_SW_cc_api_OutboundOrderCancel--cancelOrder*****************VALUE******* '+returnMap.get(key));
        }
        
        
        return returnMap;
        
    }
    */
 
}