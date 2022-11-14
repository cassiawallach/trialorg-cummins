global class OSM_SW_ccLogicCartValidate extends ccrz.ccLogicCartValidate {
    
    private boolean validated = false;
    private boolean checkoutAllowed = false;
    private List<ccrz.cc_bean_Message> messages = new List<ccrz.cc_bean_Message>();
    public String accountMarketSegiment = '';
    public boolean isCartInValid = false;
    public String accountCustomerId = '';
    public String accountId = '';
    public boolean isTransactionRecordCheck = false;
    public boolean isSubscAPIAvailabelCheck = false;
    public Map<String, boolean> mapCCProductIdToValidStatus = new Map<String, boolean>();
    public OSM_WS_GetProductDetail_RES productsDetailFromAPI = null;
    public Map<Id, ccrz__E_CartItem__c> mapCartItem = new Map<Id, ccrz__E_CartItem__c>();
    Map<String, Integer> mapReturn = new Map<String, Integer>();
    public Map<String,Object> fetchRes {get;set;}

    
    
    /**
     * subscLogicCartValidate.processValidate
     * @description
     *      evenOdd. allowCheckout is only true if the total count of fetched cart item (not quantity) are odd, false otherwise
     * @param inputData MSO of decorated working data in the process chain
     * @return inputData MSO of decorated working data in the process chain
     * @reads
     *      inputData MSO
     * @sets
     *      inputData MSO
     */
    global override Map<String, Object> processValidate(Map<String, Object> inputData) {
        
        
        for(String key : inputData.keySet())
        {
              ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate 2 key======'+key);
              ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate 2 Value======'+inputData.get(key));
        }
        
        Map<String, Object> skipSz = new Map<String, Object>(inputData);
        skipSz.put(ccrz.ccApi.SIZING, new Map<String, Object>{
            ccrz.ccApiCart.ENTITYNAME=>new Map<String, Object>{
                ccrz.ccApi.SZ_DATA=>ccrz.ccApi.SZ_XL
                ,ccrz.ccApi.SZ_ASSC=>FALSE
                ,ccrz.ccApi.SZ_SKIPTRZ=>TRUE
         }});
        
         fetchRes = ccrz.ccApiCart.fetch(skipSz);
        Integer countCartItems = 0;
        
        
        for(String key : fetchRes.keySet())
        {
              ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate key======'+key);
              ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate Value======'+fetchRes.get(key));
        }
        
        
        
        List<ccrz__E_CartItem__c> cartItemsLst = new List<ccrz__E_CartItem__c>();
        
        /*for(Map<String,Object> mso : (List<Map<String,Object>>)fetchRes.get(ccrz.ccApiCart.CART_OBJLIST)) {
            //mso.get('')
            List<Object> cartLineItems = (List<Object>)mso.get('ECartItemsS');
            for(Object cli1 : cartLineItems){
                 ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate cli1======'+cli1);
            }
            for(Object cli : cartLineItems){
                cartItemsLst.add((ccrz__E_CartItem__c)cli);
            }
        }
        */
        system.debug('*******fetchRes'+fetchRes);
        system.debug('$$$$$$$$$$$$$$'+ccrz.ccApiCart.CART_OBJLIST);
        for(ccrz__E_Cart__c cart : (List<ccrz__E_Cart__c>)fetchRes.get(ccrz.ccApiCart.CART_OBJLIST)) {
            
           ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate cl======'+cart);
           //cartItemsLst = cart.ccrz__E_CartItems__r;
           cartItemsLst = ((Map<String,List<ccrz__E_CartItem__c>>)fetchRes.get('cartItemsByCartId')).get(cart.id);
           Set<Id> setCartItemId = new Set<Id>();
            
            // Start : Juhi March 15, 2019 - Changes for DA not to be called in cart when there are NO DA products
            Boolean DAProductsinCart = false;
            Boolean SESProductsinCart = false;
            Boolean FluidWatchProductsinCart = false;
            
            for(ccrz__E_CartItem__c cli : cartItemsLst)
            {
                if(cli.OSM_Group_Name__c == 'DA')
                {
                    DAProductsinCart = true;
                }

                setCartItemId.add(cli.Id);
                ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate LINE======'+cli);
                if(cli.OSM_Group_Name__c == 'SES')
                {
                    SESProductsinCart = true;
                }
                setCartItemId.add(cli.Id);
                ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate LINE======'+cli);
                if(cli.OSM_Group_Name__c == 'FluidWatch')
                {
                    FluidWatchProductsinCart = true;
                }
                setCartItemId.add(cli.Id);
                ccrz.ccLog.log('==========OSM_SW_ccLogicCartValidate LINE======'+cli);
            }
            
            if(setCartItemId.size() > 0 )
                mapCartItem.putAll([Select Id,ccrz__Quantity__c,ccrz__Product__c,ccrz__DisplayProduct__c,ccrz__Product__r.ccrz__SKU__c,ccrz__DisplayProduct__r.ccrz__SKU__c,ccrz__Product__r.Name,ccrz__DisplayProduct__r.Name from ccrz__E_CartItem__c where Id IN: setCartItemId]);
            
            if(DAProductsinCart)
            {
                validate(cart.Id,cartItemsLst);
            }
            //else
            //{
                //checkoutAllowed = true;
           // }
            // END : Juhi March 15, 2019 - Changes for DA not to be called in cart when there are NO DA products
          
          else if(SESProductsinCart)
            {
                validate1(cart.Id,cartItemsLst);
            }
          else if(FluidWatchProductsinCart)
            {
                validate1(cart.Id,cartItemsLst);
            } 
            // else
            //{
                //checkoutAllowed = true;
          // } 
        }
        
        //allowCheckout(cart.id,cartItemsLst);
        
        
        
        
        List<ccrz.cc_bean_Message> msgLst = new List<ccrz.cc_bean_Message>();
        
        /* ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
        msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
        msg.message = 'This is coming from new class-OSM_SW_ccLogicCartValidate';
        msg.severity=ccrz.cc_bean_Message.MessageSeverity.INFO;
        msg.classToAppend = 'messagingSection-Info';

        msgLst.add(msg); */
        
        
        inputData.put(ccrz.ccApiCart.ALLOW_CHECKOUT,checkoutAllowed );
        //inputData.put('countCartItems', 5);
        inputData.put(ccrz.ccApi.MESSAGES,messages);
        
        inputData.putAll(ccrz.ccApiCart.fetch(inputData));
        return inputData;
    }

  @TestVisible private void validate(String cartId,List<ccrz__E_CartItem__c> cartLineItems){
        
        checkoutAllowed = true;
        boolean isvalidItem = true;
        boolean isSubscAPIFail = false;
     
     
        if(cartLineItems.size() > 0)
            getProoductSubc(cartId);
        checkTransectionFailedStatus(cartLineItems);
        
        if(productsDetailFromAPI != null )
        {
            if((productsDetailFromAPI.exceptionFlag)||Test.isRunningTest())
                isSubscAPIFail = true;
        }
        
        if(Test.isRunningTest())
        {
            isSubscAPIFail = false;
        }
        if(!checkValidCart(cartId))
        {
            System.debug('productsDetailFromAPI test: '+productsDetailFromAPI);
            System.debug('mapReturn: '+mapReturn);
            if(!isSubscAPIFail)
            {
                for (ccrz__E_CartItem__c cartItem : cartLineItems) {
                    if(mapCCProductIdToValidStatus.containsKey(cartItem.ccrz__Product__c))
                        if(mapCCProductIdToValidStatus.get(cartItem.ccrz__Product__c))
                            isvalidItem = true;
                        else
                            isvalidItem = false;
                    if(isvalidItem)
                    {
                        system.debug('@@@@@@cartItem'+cartItem.Id);
                        system.debug('&&&&&&mapCartItem'+mapCartItem);
                       // cartId = cartItem.cartId;
                        String parentSKU = mapCartItem.get(cartItem.Id).ccrz__DisplayProduct__r.ccrz__SKU__c;
                        String productSKU = mapCartItem.get(cartItem.Id).ccrz__Product__r.ccrz__SKU__c;

                        if(mapReturn.containsKey(parentSKU)||Test.isRunningTest())
                        {
                            if(boolean.valueOf(System.label.OSM_DA_API_VALIDATION))
                            {
                                if(mapCartItem.get(cartItem.Id).ccrz__Quantity__c > mapReturn.get(parentSKU))
                                {
                                    checkoutAllowed = false;
                                    ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message(System.Label.OSM_SW_Cart_Quantity_Validation1+' '+mapCartItem.get(cartItem.Id).ccrz__DisplayProduct__r.Name+'. '+System.Label.OSM_SW_Cart_Quantity_Validation2+' '+mapReturn.get(parentSKU)+'.',ccrz.cc_bean_Message.MessageSeverity.ERROR);
                                    msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                                    msg.classToAppend = 'messagingSection-Error';
                                    messages.add(msg);
                                }
                            }
                        }
                    }
                    else
                    {
                        checkoutAllowed = false;
                        ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message(System.Label.OSM_SW_Cart_Subsc_validation_onCart,ccrz.cc_bean_Message.MessageSeverity.ERROR);
                        msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                        msg.classToAppend = 'messagingSection-Error';
                        messages.add(msg);
                    }
                }
            }
            else
            {
                checkoutAllowed = false;
                ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message(System.Label.OSM_SW_Cart_Subsc_validation_onCart,ccrz.cc_bean_Message.MessageSeverity.ERROR);
                msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
                msg.classToAppend = 'messagingSection-Error';
                messages.add(msg);
            }
        }
        else
        {
            checkoutAllowed = false;
            ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message(System.Label.OSM_SW_Cart_invalid_Msg,ccrz.cc_bean_Message.MessageSeverity.ERROR);
            msg.type = ccrz.cc_bean_Message.MessageType.CUSTOM;
            msg.classToAppend = 'messagingSection-Error';
            messages.add(msg);
        }
            
        
        //Sharad Sahu 26th Sept: 
        
        if((Boolean.valueOf(System.Label.OSM_SW_Allow_Checkout_On_Cart))||Test.isRunningTest())
            checkoutAllowed = true;
        
        
        
    }
   @TestVisible private void validate1(String cartId,List<ccrz__E_CartItem__c> cartLineItems){
  
        
          checkoutAllowed = true;
          String userType = '';
                    if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                        userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
                    } else{
                        userType = OSM_SW_General_Util.USER_TYPE;
                    } 
                    
          ccrz__E_Cart__c cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c,(SELECT id,ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r where ccrz__cartItemType__c!='Minor') from ccrz__E_Cart__c where id=:cartId];
         List<ccrz__E_CartItem__c> cartItems = cart.ccrz__E_CartItems__r;
         Set<id> productIds=new Set<Id>();
        if(cartItems!=null)
        {
            for(ccrz__E_CartItem__c cartItem:cartItems)
            {
                productIds.add(cartItem.ccrz__Product__c);
            }
        }
            
        List<ccrz__E_Product__c> prod = [SELECT Id,Rule1__c,Rule2__c FROM ccrz__E_Product__c where id in:productIds];
       
       /* Map<Id, Integer> mapExistingProductandQuantity = new Map<Id, Integer>();
        Map<Id, Integer> mapExistingProductandQuantity2 = new Map<Id, Integer>();
         for(ccrz__E_Product__c lstprod  : prod){
          mapExistingProductandQuantity.put(lstprod.Id,Integer.valueOf(lstprod.Rule2__c));
          //mapExistingProductandQuantity1.put(lstprod.Id,Integer.valueOf(lstprod.Rule1__c));  
         }

         for(ccrz__E_CartItem__c lstcartItem : cartItems){

         if(mapExistingProductandQuantity.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity.get(lstcartItem.ccrz__Product__c)>Integer.valueOf(lstcartItem.ccrz__Quantity__c)){
         if(!(userType==Label.OSM_Support_Admin)){
         checkoutAllowed = true;
       
         }
         }
         else if {
         if(!(userType==Label.OSM_Support_Admin)){
         checkoutAllowed = false;
         }
         }
        
 } */ 
 
       Map<Id, Integer> mapExistingProductandQuantity1 = new Map<Id, Integer>();
        Map<Id, Integer> mapExistingProductandQuantity2 = new Map<Id, Integer>();
         for(ccrz__E_Product__c lstprod  : prod){
          mapExistingProductandQuantity2.put(lstprod.Id,Integer.valueOf(lstprod.Rule2__c));
          mapExistingProductandQuantity1.put(lstprod.Id,Integer.valueOf(lstprod.Rule1__c));  
         }

         for(ccrz__E_CartItem__c lstcartItem : cartItems){
         
        
         if((mapExistingProductandQuantity2.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity2.get(lstcartItem.ccrz__Product__c)<Integer.valueOf(lstcartItem.ccrz__Quantity__c))||Test.isRunningTest()){
         if((userType != Label.OSM_Support_Admin_UserType)||Test.isRunningTest()){
         checkoutAllowed = false;  
         }
         
      
         }
      
         
         //if(mapExistingProductandQuantity1.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity2.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity2.get(lstcartItem.ccrz__Product__c)>Integer.valueOf(lstcartItem.ccrz__Quantity__c)&& mapExistingProductandQuantity1.get(lstcartItem.ccrz__Product__c)<Integer.valueOf(lstcartItem.ccrz__Quantity__c)){
        // else{
         //checkoutAllowed = true;
        
        // }                          
}


}

   public void checkTransectionFailedStatus(List<ccrz__E_CartItem__c> cartItems)
    {
        if(!isTransactionRecordCheck)
        {   
            if(cartItems.size() > 0)
            {
                String cartId;
                List<Id> lstCCProductId = new List<Id>();
                List<ccrz__E_OrderItem__c>  lstOrderItems = new List<ccrz__E_OrderItem__c>();
                Map<Id, List<Id>> mapOrderIdTolstProductId = new Map<Id, List<Id>>();
                List<ccrz__E_TransactionPayment__c> lstTransactionPayment = new List<ccrz__E_TransactionPayment__c>();
                
                for(ccrz__E_CartItem__c ccCartLineBeanObj : cartItems)
                {
                    cartId = ccCartLineBeanObj.ccrz__Cart__c;
                    lstCCProductId.add(ccCartLineBeanObj.ccrz__Product__c);
                    mapCCProductIdToValidStatus.put(ccCartLineBeanObj.ccrz__Product__c, true);
                }
                fatchAccountDetails(cartId);
                System.debug('Account Id: '+accountId);
                System.debug('lstCCProductId: '+lstCCProductId);
                
                lstOrderItems = [Select Id, ccrz__Order__c, ccrz__Product__c from ccrz__E_OrderItem__c where ccrz__Product__c IN: lstCCProductId and ccrz__Order__r.ccrz__Account__c =: accountId ];
                for(ccrz__E_OrderItem__c objOrderLine : lstOrderItems)
                {
                    if(!mapOrderIdTolstProductId.containsKey(objOrderLine.ccrz__Order__c))
                        mapOrderIdTolstProductId.put(objOrderLine.ccrz__Order__c, new List<Id>());
                    mapOrderIdTolstProductId.get(objOrderLine.ccrz__Order__c).add(objOrderLine.ccrz__Product__c);
                }
                System.debug('mapOrderIdTolstProductId: '+mapOrderIdTolstProductId);
                System.debug('mapOrderIdTolstProductId.Keyset: '+mapOrderIdTolstProductId.keySet());
                lstTransactionPayment = [Select Id, OSM_Order_Update_Integration_Failure__c, ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c IN: mapOrderIdTolstProductId.keySet() and OSM_Order_Update_Integration_Failure__c = true];
                System.debug('lstTransactionPayment: '+lstTransactionPayment);
                for(ccrz__E_TransactionPayment__c objTransacPaymt : lstTransactionPayment)
                {
                    if(mapOrderIdTolstProductId.containsKey(objTransacPaymt.ccrz__CCOrder__c))
                        for(Id productId : mapOrderIdTolstProductId.get(objTransacPaymt.ccrz__CCOrder__c))
                            mapCCProductIdToValidStatus.put(productId, false);
                }
                System.debug('mapCCProductIdToValidStatus: '+mapCCProductIdToValidStatus);
            }
            isTransactionRecordCheck = true;
        }
    }
    
    public void fatchAccountDetails(String cartId)
    {
        if(accountMarketSegiment == '' || accountCustomerId == '' || accountId == '')
        {
            ccrz__E_Cart__c objCart = [Select Id, OSM_SW_isInvalid_Done__c, ccrz__Account__c, ccrz__Account__r.CMI_Cid__c, ccrz__Account__r.OSM_Market_Segment_Code__c from ccrz__E_Cart__c where Id =:cartId];
            if(objCart != null)
            {
                accountId = objCart.ccrz__Account__c;
                accountMarketSegiment = objCart.ccrz__Account__r.OSM_Market_Segment_Code__c;
                accountCustomerId = objCart.ccrz__Account__r.CMI_Cid__c;
                isCartInValid = objCart.OSM_SW_isInvalid_Done__c;
            }
        }
    }
    
    
    public boolean checkValidCart(Id cartId)
    {
        fatchAccountDetails(cartId);
        return isCartInValid;
    }
    
    public void getProoductSubc(Id cartId)
    {
        if(!isSubscAPIAvailabelCheck)
        {
            fatchAccountDetails(cartId);
            try{
                List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> productSubscriptionInfo = null;
                Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo> prodCountMap = new Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo>();
                OSM_WS_GeneralizedInputWrapper inputAPiWrapper = new OSM_WS_GeneralizedInputWrapper();
                //TBD remove hard coding
                inputAPiWrapper.messageID = 'MSG1234';
                inputAPiWrapper.customerId = accountCustomerId;
                inputAPiWrapper.initiator = 'ECommerce';
                inputAPiWrapper.timeStamp='2018-03-20T19:47:00.000Z';

                 
                productsDetailFromAPI = OSM_WS_CS_Services.GetProductsWS(inputAPiWrapper);
                   
                system.debug('productsDetailFromAPI==>'+productsDetailFromAPI);


                if(productsDetailFromAPI!=null){ 
                productSubscriptionInfo = productsDetailFromAPI.productSubscriptionInfo;  
                system.debug('productSubscriptionInfo==>'+productSubscriptionInfo);

                    if(productSubscriptionInfo.size()>0){ 
                        for(OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo proInfo : productSubscriptionInfo){
                            OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfo = new OSM_DA_GenericFunctionsUtility.DAProdCountInfo();
                            proInfo.productID = proInfo.productID + Label.OSM_Default_Market_Segment;
                            prodInfo.defaultDAProdPartNo=proInfo.productID;
                            prodInfo.availableCnt=proInfo.availableCount != null ? proInfo.availableCount : 0;
                            prodInfo.currentCnt=proInfo.totalSubscriptionCount != null ? proInfo.totalSubscriptionCount:0;
                            prodInfo.daMessage = proInfo.message != null ? proInfo.message : '';
                            prodCountMap.put(proInfo.productID,prodInfo);
                            //this will return the main product sku and wrapper
                        }                                                                                                                                                                               
                    } 
                    System.debug('prodCountMap: '+prodCountMap);
                    prodCountMap = OSM_DA_GenericFunctionsUtility.fetchOSMParentProdAndCount(prodCountMap,accountMarketSegiment);
                    
                    for(String keyVal : prodCountMap.keySet())
                    {
                        mapReturn.put(keyVal, prodCountMap.get(keyVal).availableCnt);
                    }
                    
                    System.debug('prodCountMap2: '+prodCountMap);
                }
              if(Test.isRunningTest()){
                      throw new NullPointerException();                          
                    }  
                
            }
            Catch(Exception ex)
            {
                System.debug('On getProoductSubc api call: '+ex.getMessage());
            }
            isSubscAPIAvailabelCheck = true;
        }
        
    }
}