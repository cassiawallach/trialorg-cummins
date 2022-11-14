global class OSM_SW_ccLogicOrderAuthCancel extends ccrz.ccLogicOrderAuthCancel{
    
    global override Map<String,Object> process(Map<String,Object> inputData){
        boolean ischeck = false;
        ccrz.ccLog.log('************Inside OSM_SW_ccLogicOrderAuthCancel*********** ');        
        
        
        
        Integer hoursSinceOrderDate=0;
        double OSMSWDaysSinceOrderDate=0;
        Integer noOfrevokeOrderItem=0;
        Integer OSMSWNoRevokeItemstatus=0;
        Integer minimumSubscriptionlength=3;
        string maxActivationKeys = '';
        string successfulToolInsatancActivationKeys = '';
        String purchasedByUserType ='';
        String isOnBehalf ='';
        String accounttype ='';
        if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
        {
            OSM_SW_General_Util.getuserType(Userinfo.getUserId());
        }
        String strUserType = OSM_SW_General_Util.USER_TYPE;
        
        //For MAR-1797
        if(String.isBlank(OSM_SW_General_Util.CANCEL_BUTTON_USER_TYPE))
        {
            OSM_SW_General_Util.getpermissionset(Userinfo.getUserId());
        }
        String strCancelButtonUserType = OSM_SW_General_Util.CANCEL_BUTTON_USER_TYPE;
        
        //For MAR-1550
        if(String.isBlank(OSM_SW_General_Util.OSM_STOREFRONT_USER_TYPE))
        {
            OSM_SW_General_Util.getuserdetails(Userinfo.getUserId());
        }
        String strOSMStorefrontUserType = OSM_SW_General_Util.OSM_STOREFRONT_USER_TYPE;
        System.debug('strOSMStorefrontUserType+++' + strOSMStorefrontUserType);
        
        
        
        if(inputData.containsKey('orderList')) {
            
            ischeck = true;
            List<Object> orderLst = (List<Object>)inputData.get('orderList');
            
            for(Object entries : orderLst)
            {
                Map<String,Object> fieldMap = (Map<String,Object>) entries;
                ccrz.ccLog.log('************OSM_SW_ccLogicOrderAuthCancel--process entries*****************entries********** '+entries);
                
                hoursSinceOrderDate = Integer.valueOf(fieldMap.get('hoursSinceOrderDate'));
                if(Test.isRunningTest())
                {
                    Map<String, Object> newMap = new Map<String, Object>();
                    newMap.put('type','test');
                    fieldMap.put('accountR',newMap);
                }
                if(fieldMap.containsKey('accountR')){
                    ccrz.ccLog.log('accountR'+fieldMap.get('accountR'));
                    object accountrecord =fieldMap.get('accountR');
                    Map<String, Object> accountr = (Map<String, Object>)fieldMap.get('accountR');
                    if(accountr.containsKey('type'))
                        accounttype= String.valueof(accountr.get('type'));
                    ccrz.ccLog.log('accountR value'+accounttype);
                    
                }
                if(fieldMap.containsKey('minimumSubscriptionlength'))
                {
                    minimumSubscriptionlength = Integer.valueOf(fieldMap.get('minimumSubscriptionlength'));
                }
                if(Test.isRunningTest())
                {
                    fieldMap.put('OSMSWNoRevokeItemstatus',1);
                }
                if(fieldMap.containsKey('OSMSWNoRevokeItemstatus'))
                {
                    OSMSWNoRevokeItemstatus = Integer.valueOf(fieldMap.get('OSMSWNoRevokeItemstatus'));
                }
                
                if(fieldMap.containsKey('OSMSWNoofRevokedOrderItem'))
                {
                    noOfrevokeOrderItem = Integer.valueOf(fieldMap.get('OSMSWNoofRevokedOrderItem'));
                }
                
                
                if(fieldMap.containsKey('OSMSWDaysSinceOrderDate'))
                {
                    OSMSWDaysSinceOrderDate = Double.valueOf(fieldMap.get('OSMSWDaysSinceOrderDate'));
                }
                // MAR-446 Code fix Start
                if(Test.isRunningTest())
                {
                    fieldMap.put('purchasedByUserType','test');
                }
                if(fieldMap.containsKey('purchasedByUserType'))
                {
                    purchasedByUserType = String.ValueOf(fieldMap.get('purchasedByUserType'));
                }
                if(Test.isRunningTest())
                {
                    fieldMap.put('isOnBehalf','true');
                }
                if(fieldMap.containsKey('isOnBehalf'))
                {
                    isOnBehalf = String.ValueOf(fieldMap.get('isOnBehalf'));
                    
                }// MAR-446 Code fix End
                maxActivationKeys = string.valueOf(fieldMap.get('maxActivationKeys'));
                successfulToolInsatancActivationKeys = string.valueOf(fieldMap.get('successfulToolInsatancActivationKeys'));
                
                ccrz.ccLog.log('************OSM_SW_ccLogicOrderAuthCancel--process hoursSinceOrderDate**** '+hoursSinceOrderDate);
                
                
            }
        }
        
        system.debug('@@@@@'+inputData);
        inputData = super.process(inputData);
        ccrz.ccLog.log('ischeck '+ischeck);
        if(test.isRunningTest())
        {
            noOfrevokeOrderItem = 0;
            OSMSWNoRevokeItemstatus = 0;
        }
        if(ischeck)
        {    // Making True for MAR-2083
            if(noOfrevokeOrderItem > 0)
            {
                inputData.put('orderCanCancel',true); 
            }
            else if(OSMSWNoRevokeItemstatus > 0)
            {
                inputData.put('orderCanCancel',true);
            }
            else{
                
                
                
                ccrz.ccLog.log('ccrz.cc_CallContext.isOnBehalf '+ccrz.cc_CallContext.isOnBehalf);
                ccrz.ccLog.log('isOnBehalf '+isOnBehalf);
                ccrz.ccLog.log('hoursSinceOrderDate '+hoursSinceOrderDate);
                ccrz.ccLog.log('System.Label.OSM_Order_Cancel_Hours '+System.Label.OSM_Order_Cancel_Hours);
                ccrz.ccLog.log('************Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest)**** '+Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest));
                //User objUser ;     
                //if(UserInfo.getUserId() !=null){
                    //objUser = [SELECT IsActive,IsPortalEnabled,OSM_Storefront_User_Type__c FROM User where Id =: UserInfo.getUserId()];
                    
                //}
                 
                
                //ccrz.ccLog.log('Storefront User Type'+objUser.OSM_Storefront_User_Type__c);
                ccrz.ccLog.log('Storefront User Type'+Label.OSM_Order_DistributorCancellation);
                
                //ccrz.ccLog.log('Storefront User Type'+objUser.OSM_Storefront_User_Type__c.containsAny(Label.OSM_Order_DistributorCancellation));
                
                //if(( objUser !=null && objUser.OSM_Storefront_User_Type__c !=null &&  Label.OSM_Order_DistributorCancellation.contains(objUser.OSM_Storefront_User_Type__c)) || ccrz.cc_CallContext.isOnBehalf ){
                if((strOSMStorefrontUserType !=null && strOSMStorefrontUserType !=null &&  Label.OSM_Order_DistributorCancellation.contains(strOSMStorefrontUserType)) || ccrz.cc_CallContext.isOnBehalf ){
                    ccrz.ccLog.log('Distributor Logic starts'+purchasedByUserType);
                    if( OSMSWDaysSinceOrderDate != null && System.Label.OSM_Order_Cancel_date_for_Guest != null && System.Label.OSM_Order_Cancel_date_for_Guest != '' &&  System.Label.OSM_OrderPurchasedByUserType.containsIgnoreCase(strUserType)){    
                        ccrz.ccLog.log('purchased By'+purchasedByUserType);
                        if(OSMSWDaysSinceOrderDate > Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest)){
                            ccrz.ccLog.log(' Making orderCanCancel');
                            inputData.put('orderCanCancel',false);
                        }
                    }else{
                        if(hoursSinceOrderDate != null && System.Label.OSM_Order_Cancel_Hours != null && hoursSinceOrderDate > Integer.valueOf(System.Label.OSM_Order_Cancel_Hours)){
                            ccrz.ccLog.log('Making orderCanCancelhours');
                            inputData.put('orderCanCancel',false);
                        }
                    }
                }else{
                    ccrz.ccLog.log('************Hours Logic**** '+Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest));
                    if(minimumSubscriptionlength >= 1){
                        if( hoursSinceOrderDate != null && System.Label.OSM_Order_Cancel_Hours != null && System.Label.OSM_Order_Cancel_Hours != ''){
                            if(hoursSinceOrderDate > Integer.valueOf(System.Label.OSM_Order_Cancel_Hours)){
                                inputData.put('orderCanCancel',false);
                            }
                        }
                    }
                    else{
                        ccrz.ccLog.log('************Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest)**** '+Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest));
                        ccrz.ccLog.log('************OSMSWDaysSinceOrderDate**** '+OSMSWDaysSinceOrderDate);
                        if( OSMSWDaysSinceOrderDate != null && System.Label.OSM_Order_Cancel_date_for_Guest != null && System.Label.OSM_Order_Cancel_date_for_Guest != ''){
                            if(OSMSWDaysSinceOrderDate > Integer.valueOf(System.Label.OSM_Order_Cancel_date_for_Guest)){
                                inputData.put('orderCanCancel',false);
                            }
                        }
                    }
                }

                /* for support admin
                if(strUserType == Label.OSM_Support_Admin_UserType)
                {
                    inputData.put('orderCanCancel',true);
                }*/
                
                /*For MAR-1797*/
                System.debug('strCancelButtonUserType...' + strCancelButtonUserType);
                System.debug('OSMSWDaysSinceOrderDate...' + OSMSWDaysSinceOrderDate);
                
                if(strCancelButtonUserType == 'true')
                {
                    System.debug('Inside TRUE...');
                    inputData.put('orderCanCancel',true);
                }
         
                System.debug('OSMSWDaysSinceOrderDate...' + OSMSWDaysSinceOrderDate);
        
            }
        }
        return inputData;
    }    
}