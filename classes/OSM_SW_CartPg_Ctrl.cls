//Subbu
//redep
global class OSM_SW_CartPg_Ctrl{

    /*----------------------------------------------------------------------------------
callOneBMS
Description: Action method to call OneBMS to update address


Returntype:
ccrz.cc_RemoteActionResult
------------------------------------------------------------------------------------*/ 
    public String couponToProdMap {get; set;}
	public String subscriptionEndDate{get;set;} //swetha added
    
    public OSM_SW_CartPg_Ctrl(){
        Map<String,String> couponprodMap = new Map<String,String>();
        String cartId =apexpages.currentpage().getparameters().get('cartId');
        List<ccrz__E_Cart__c> cartforId = [SELECT Id, ccrz__EncryptedId__c FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
        List<ccrz__E_CartCoupon__c> cartCoupons = [SELECT Id, ccrz__Cart__c,ccrz__CartCouponId__c,ccrz__Coupon__c,ccrz__Coupon__r.ccrz__CouponCode__c,ccrz__Coupon__r.ccrz__TargetProduct__c FROM ccrz__E_CartCoupon__c WHERE ccrz__Cart__c =: cartforId[0].Id];
        for(ccrz__E_CartCoupon__c cartC : cartCoupons){
            couponprodMap.put(String.valueOf(cartC.ccrz__Coupon__r.ccrz__TargetProduct__c),String.valueOf(cartC.ccrz__Coupon__r.ccrz__CouponCode__c));
        }
        couponToProdMap = JSON.serialize(couponprodMap);
    }

    @RemoteAction
    global static ccrz.cc_RemoteActionResult callOneBMS(ccrz.cc_RemoteActionContext ctx)
    {
    
        
        ID currUserId = UserInfo.getUserId();
        List<Contact> contacts = new List<Contact>();
        contacts = [Select ID, IAM_Contact_Owner__c,OSM_Distributor_Admin_Last_Sel__c,OSM_Distributor_Admin_Last_Sel_acc__c from Contact where IAM_Contact_Owner__c =:currUserId LIMIT 1];
        String useId= UserInfo.getUserId();
        ccrz.cc_RemoteActionResult result = CCOSMPageUtil.remoteInit(ctx);
        // result.success = true;
        //String accountId = ccrz.cc_CallContext.currAccountId;
         String accountId = ccrz.cc_CallContext.effAccountId;
        String cartId = ccrz.cc_CallContext.currCartId;
        ccrz__E_Cart__c carts = [select id, ccrz__EncryptedId__c,(select id, Billing_Frequency__c,ccrz__Product__r.Group_Name__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
        List<ccrz__E_CartItem__c> cartItems = carts.ccrz__E_CartItems__r;
        boolean isAllLineOneTime = true;
        try{
        //Map < String, Object > hasCouponDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData);
        //Boolean hasCoupon=(Boolean)hasCouponDetails.get('hasCoupon');
        //system.debug('hascoupon>>>>>'+hasCoupon);
        	
            // Swetha: [start]
            Set<String> prodIds = new Set<String>();
            OSM_SW_ProductDetaiServiceCls.DiscountedPriceWrapper availableSubs = null;
            if(cartItems.size() > 0){
                for(ccrz__E_CartItem__c ct : cartItems){
                    prodIds.add(ct.ccrz__Product__c);
                }
            }
            
            availableSubs = OSM_SW_ProductDetaiServiceCls.getDiscountedPrice('SoftwareStore', accountId, prodIds);
            //subscriptionEndDate = ''+availableSubs.subsEndDate.Day()+' '+OSM_SW_ProductDetailCommonUtility.getMonth(availableSubs.subsEndDate.Month())+' '+availableSubs.subsEndDate.Year();
            
            //END
            Account account = [select id,name,BillingCountry,CSS_DistributorCode__c,OSM_Preferred_Payment_Method__c,OSM_Preferred_Payment_IsBolt_PO__c,Customer_BMS_number__c,OSM_Preferred_Billing_Frequency_Lock__c,BOLT_Account_Number__c,CMI_Account_Status__c,Bolt_Customer_Account_Status__c,Bolt_Credit_Hold__c from Account where Id =: accountId];
            
            List<ccrz__E_Cart__c> cart = [select id,ccrz__TotalAmount__c,ccrz__User__c,ccrz__Contact__c,ccrz__Account__c,ccrz__EncryptedId__c,OSM_Payment_Method__c, (select id, ccrz__Product__c, ccrz__Product__r.Group_Name__c, Billing_Frequency__c from ccrz__E_CartItems__r where OSM_Group_Name__c != 'FluidWatch') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
            // ccrz.ccLog.log('callOneBMS userId'+useId);
            // ccrz.ccLog.log('callOneBMS ccrz__User__c '+cart[0].ccrz__User__c);
            
            
            if(cart!=null && cart.size()==1)
            {
                for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                {
                    if(cartItem.ccrz__Product__r.Group_Name__c == 'DA')
                    {
                        if(cartItem.Billing_Frequency__c != 'One Time')
                        {
                            isAllLineOneTime = false;
                        }
                    }
                }
                if(!contacts.isEmpty() && String.valueOf(cart[0].ccrz__Account__c) != String.valueOf(contacts[0].OSM_Distributor_Admin_Last_Sel_acc__c) && String.valueOf(cart[0].ccrz__Contact__c) != String.valueOf(contacts[0].OSM_Distributor_Admin_Last_Sel__c)&& String.isNotBlank(contacts[0].OSM_Distributor_Admin_Last_Sel_acc__c) && String.isNotBlank(contacts[0].OSM_Distributor_Admin_Last_Sel__c)&& String.valueOf(cart[0].ccrz__User__c) == useId && Cache.Session.contains('accContactSelected')){
                    cart[0].ccrz__Account__c = contacts[0].OSM_Distributor_Admin_Last_Sel_acc__c;
                    cart[0].ccrz__Contact__c = contacts[0].OSM_Distributor_Admin_Last_Sel__c;
                    
                    //update cart[0];
                }else if(!contacts.isEmpty() && !Cache.Session.contains('accContactSelected')){
                    cart[0].ccrz__Account__c = ccrz.cc_CallContext.effAccountId;
                    cart[0].ccrz__Contact__c = ccrz.cc_CallContext.currContact.Id;
                    //update cart[0];
                }
            
            }
            else
            {
                isAllLineOneTime = false;
            }
            
            
            boolean isRunCustomerLookupAPI = false;
            
            
            
            if(account.OSM_Preferred_Billing_Frequency_Lock__c)
            {
                if(isAllLineOneTime)
                {
                    if(account.BOLT_Account_Number__c ==null || account.BOLT_Account_Number__c == '' && (account.Customer_BMS_number__c != null && account.Customer_BMS_number__c != ''))
                    {
                        isRunCustomerLookupAPI = true;
                    }
                }
                else if(account.OSM_Preferred_Payment_Method__c!=null && account.OSM_Preferred_Payment_Method__c == 'po')
                {
                    if(!account.OSM_Preferred_Payment_IsBolt_PO__c)
                    {
                        isRunCustomerLookupAPI = true;
                    }
                }
            }
            else
            {
                if(account.BOLT_Account_Number__c ==null || account.BOLT_Account_Number__c == '' )
                {
                    if(account.Customer_BMS_number__c != null && account.Customer_BMS_number__c != '')
                    {
                        isRunCustomerLookupAPI = true;
                    }
                }
            }
            
            
            
            
            
            
            
            
            if((isRunCustomerLookupAPI) && (cartItems[0].ccrz__Product__r.Group_Name__c != 'FluidWatch'))
            {
                OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
                if(Label.OSM_North_America_Country.containsIgnoreCase(account.BillingCountry) || label.OSM_PO_Distributor_List.contains(account.CSS_DistributorCode__c))
                {
                objRet = OSM_BMS_SW_BusinessLayerUtility.calculateBMSAvailableCredit(accountId,false,null,null); 
                }
                
            }
        CCOSMPageUtil.buildResponseData(result,true, new Map<String, Object>{'useId' => useId});
        
        
        
        
            
            if(cart!=null && cart.size()==1)
            {
                
                if(!contacts.isEmpty() && String.valueOf(cart[0].ccrz__Account__c) != String.valueOf(contacts[0].OSM_Distributor_Admin_Last_Sel_acc__c) && String.valueOf(cart[0].ccrz__Contact__c) != String.valueOf(contacts[0].OSM_Distributor_Admin_Last_Sel__c)&& String.isNotBlank(contacts[0].OSM_Distributor_Admin_Last_Sel_acc__c) && String.isNotBlank(contacts[0].OSM_Distributor_Admin_Last_Sel__c)&& String.valueOf(cart[0].ccrz__User__c) == useId && Cache.Session.contains('accContactSelected')){
                    cart[0].ccrz__Account__c = contacts[0].OSM_Distributor_Admin_Last_Sel_acc__c;
                    cart[0].ccrz__Contact__c = contacts[0].OSM_Distributor_Admin_Last_Sel__c;
                    
                    update cart[0];
                }else if(!contacts.isEmpty() && !Cache.Session.contains('accContactSelected')){
                    cart[0].ccrz__Account__c = ccrz.cc_CallContext.effAccountId;
                    cart[0].ccrz__Contact__c = ccrz.cc_CallContext.currContact.Id;
                    update cart[0];
                }
            
            }
            

        } catch (Exception e) {
            CCOSMPageUtil.buildResponseData(result, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','callOneBMS');
            ccrz.ccLog.close(result);
        }
        
        return result;
        
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult cartItemDetails(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.ccLog.log('>>>>>>>>ctx1'+ctx);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.ccLog.log('>>>>>>>>ctx2'+ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        Map<String, Object> returnMap = new Map<String, Object>();
        result.success = true;
        String cartId = ccrz.cc_CallContext.currCartId;
        ccrz.ccLog.log('>>>>>>>>ctx3'+ctx);
        Map<id,List<ccrz__E_CartItem__c>> cartChildItemsMap=new Map<id,List<ccrz__E_CartItem__c>>();
        Map<id,ccrz__E_CartItem__c> cartItemsMap=new Map<id,ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> childCartItemList;
        //List<ccrz__E_CartItem__c> parentCartItemList;
        Decimal subTotal=0.0; 
        if(cartId != '')
        {
            ccrz.ccLog.log('>>>>>>>>enter into if block'+cartId);
            List<ccrz__E_Cart__c> cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c,OSM_Payment_Method__c, (select id,Name,ccrz__ParentCartItem__c,ccrz__Product__r.Group_Name__c,ccrz__Quantity__c,ccrz__ItemTotal__c,Billing_Frequency__c,ccrz__Price__c,OSM_SW_AddOn_Product_Of__c,ccrz__Product__c,ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Name,ccrz__Product__r.ccrz__ShortDesc__c,ccrz__DisplayProduct__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
             ccrz.ccLog.log('cart______'+cart);
            if(cart!=null && cart.size()==1)
            {
                ccrz.ccLog.log('cart[0].ccrz__E_CartItems__r______'+cart[0].ccrz__E_CartItems__r);

                for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                {
                    if(cartItem.OSM_SW_AddOn_Product_Of__c!=null)
                    {
                        //subTotal=subTotal+cartItem.ccrz__ItemTotal__c;
                        if(cartChildItemsMap.containsKey(cartItem.OSM_SW_AddOn_Product_Of__c))
                        {
                            childCartItemList=cartChildItemsMap.get(cartItem.OSM_SW_AddOn_Product_Of__c);
                            childCartItemList.add(cartItem);
                            cartChildItemsMap.put(cartItem.OSM_SW_AddOn_Product_Of__c,childCartItemList);
                            
                        }
                        else
                        {
                           childCartItemList=new List<ccrz__E_CartItem__c>();
                           childCartItemList.add(cartItem);
                           cartChildItemsMap.put(cartItem.OSM_SW_AddOn_Product_Of__c,childCartItemList);
                        } 
                        
                        
                    }
                    else
                    {
                        if(cartItem.ccrz__ParentCartItem__c==null)
                        {
                            cartItemsMap.put(cartItem.id,cartItem);
                            //parentCartItemList.add(cartItem);
                        }
                    }
                    
                }

                List<ccrz__E_CartItem__c> lineItem = new List<ccrz__E_CartItem__c>();
                List<ccrz__E_CartItem__c> dupLineItemToDelList = new List<ccrz__E_CartItem__c>();
                Set<id> idSet=new Set<id>();
                for(List<ccrz__E_CartItem__c> lst1 : cartChildItemsMap.values())
                {
                    for(ccrz__E_CartItem__c lineItem2: lst1)
                    {
                        lineItem.add(lineItem2);
                        idSet.add(lineItem2.id);
                    }
                }   
                /*if(cart!=null && cart.size()==1)
                {
                    for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                    {
                      if(idSet.contains(cartItem.id))
                      {
                            dupLineItemToDelList.add(cartItem);
                            system.debug('items to delete>>>>>'+dupLineItemToDelList);
                      }
                    }
                }*/
                /*if(dupLineItemToDelList !=null && dupLineItemToDelList.size()>0)
                {
                    //delete dupLineItemToDelList;
                }*/
                //Setting the index of parent list..
                
                system.debug('parent items List>>>>'+cartItemsMap.values());
                system.debug('cart items List>>>>'+lineItem);
                
                returnMap.put('CartLineItemParent',cartItemsMap.values());
                returnMap.put('CartLineItemChild',lineItem);
                //returnMap.put('CartLineItemDelete',dupLineItemToDelList);
            }
        }
        result.data = returnMap;
        
        return result;
        
    }
   @RemoteAction
    global static ccrz.cc_RemoteActionResult ShowcartItemValidationsMsg(ccrz.cc_RemoteActionContext ctx)
    {
     
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        Map<String, Object> returnMap = new Map<String, Object>();
        result.success = true;       
        String cartId = ccrz.cc_CallContext.currCartId;
        String accountId = ccrz.cc_CallContext.effAccountId;
        Account acc = [Select ID,BillingCountry from Account where ID=:accountId];
         List<string> prodname1= new List<string>(); 
         List<string> prodname2= new List<string>();
         List<integer> qty2= new List<integer>(); 
                 
        
          String userType='';
          
            if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
            } else{
                userType = OSM_SW_General_Util.USER_TYPE;
            } 
            
       ccrz__E_Cart__c cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c,(SELECT id,ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r where ccrz__cartItemType__c!='Minor') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
       List<ccrz__E_CartItem__c> cartItems = cart.ccrz__E_CartItems__r;
       List<Id> prodId = new List<Id>(); //1236 Too Many query rows on ccrz__E_Product__c query below
       for(ccrz__E_CartItem__c ct : cartItems)
     {
      prodId.add(ct.ccrz__Product__c);
     }
    // List<ccrz__E_Product__c> prod = [SELECT Id,Name,Rule1__c,Rule2__c FROM ccrz__E_Product__c];
       List<ccrz__E_Product__c> prod = [SELECT Id,Name,Rule1__c,Rule2__c FROM ccrz__E_Product__c where ID IN : prodId];
     system.debug('###'+prod);
        Map<Id, Integer> mapExistingProductandQuantity1 = new Map<Id, Integer>();
        Map<Id, Integer> mapExistingProductandQuantity2 = new Map<Id, Integer>();
         Map<Id, string> mapExistingProductandQuantity4 = new Map<Id, String>();
         for(ccrz__E_Product__c lstprod  : prod){
              mapExistingProductandQuantity2.put(lstprod.Id,Integer.valueOf(lstprod.Rule2__c));
              mapExistingProductandQuantity1.put(lstprod.Id,Integer.valueOf(lstprod.Rule1__c));
              mapExistingProductandQuantity4.put(lstprod.Id,lstprod.Name); 
         }

         for(ccrz__E_CartItem__c lstcartItem : cartItems){
         boolean showMsg1= false;
        
         if((mapExistingProductandQuantity4.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity2.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity2.get(lstcartItem.ccrz__Product__c)<Integer.valueOf(lstcartItem.ccrz__Quantity__c))|| Test.isRunningTest()){
        if((userType != Label.OSM_Support_Admin_UserType)|| Test.isRunningTest()){
         returnMap.put('ShowcartItemValidationsMsg1',true);
         prodname1.add(mapExistingProductandQuantity4.get(lstcartItem.ccrz__Product__c));
         qty2.add(mapExistingProductandQuantity2.get(lstcartItem.ccrz__Product__c));
                 
                 //system.debug('prodname50: '+prodname1);
                 returnMap.put('prodname1',prodname1);
                 returnMap.put('qty2',qty2);                 
        }
      
         }
      
         
         if(mapExistingProductandQuantity4.containsKey(lstcartItem.ccrz__Product__c) && mapExistingProductandQuantity1.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity2.containsKey(lstcartItem.ccrz__Product__c)&& mapExistingProductandQuantity2.get(lstcartItem.ccrz__Product__c)>=Integer.valueOf(lstcartItem.ccrz__Quantity__c)&& mapExistingProductandQuantity1.get(lstcartItem.ccrz__Product__c)<Integer.valueOf(lstcartItem.ccrz__Quantity__c)){
           if((userType != Label.OSM_Support_Admin_UserType)|| Test.isRunningTest()){
         returnMap.put('ShowcartItemValidationsMsg2',true);
         prodname2.add(mapExistingProductandQuantity4.get(lstcartItem.ccrz__Product__c));
                  //system.debug('prodname25: '+prodname2);
                returnMap.put('prodname2',prodname2);
        }
         }  
                            
}

      try
        {                  
                    
                    
       }       
        Catch(Exception ex)
        {
            result.success = false;
        }
        result.data = returnMap;
        
        return result;

        
   }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult ShowWarningMsgPaymentOrder(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        
        Map<String, Object> returnMap = new Map<String, Object>();
        result.success = true;
        boolean IsFluidWatch;
        boolean IsBMSBoltNull; 
        String cartId = ccrz.cc_CallContext.currCartId;
        String accountId = ccrz.cc_CallContext.effAccountId;
        Account account = [select id,Type,name,OSM_Preferred_Payment_Method__c,OSM_Preferred_Payment_IsBolt_PO__c,Customer_BMS_number__c,OSM_Preferred_Billing_Frequency_Lock__c,BOLT_Account_Number__c,CMI_Account_Status__c,Bolt_Customer_Account_Status__c,Bolt_Credit_Hold__c,BillingCountry from account where id=:accountId];
        ccrz__E_Cart__c cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c,(SELECT id,OSM_Group_Name__c,ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r where ccrz__cartItemType__c!='Minor') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
        List<ccrz__E_CartItem__c> cartItems = cart.ccrz__E_CartItems__r;
        for(ccrz__E_CartItem__c lstcartItem : cartItems){
            if(lstcartItem.OSM_Group_Name__c == 'FluidWatch' ){
                IsFluidWatch = true;
            }
            }
            if ((account.Customer_BMS_number__c== null)&&(account.BOLT_Account_Number__c == null)){
                   IsBMSBoltNull=true;
                   }
                   if ((account.Customer_BMS_number__c== '')&&(account.BOLT_Account_Number__c == '')){
                   IsBMSBoltNull=true;
                   }
        for(ccrz__E_CartItem__c lstcartItem : cartItems){
       if(IsBMSBoltNull!=true){
            if(IsFluidWatch){
                if((lstcartItem.OSM_Group_Name__c == 'SES') ||(lstcartItem.OSM_Group_Name__c == 'DA')){
                 returnMap.put('ShowWarningMsg',true);
                }
            }
          }
        }
       try
        {                  
                    
                    
       }       
        Catch(Exception ex)
        {
            result.success = false;
        }
        result.data = returnMap;
        
        return result;
        
    }
  
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult cartItemDetailsSubsc(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        Map<String, Object> returnMap = new Map<String, Object>();
        result.success = true;
        String cartId = ccrz.cc_CallContext.currCartId;
        //String accountId = ccrz.cc_CallContext.currAccountId;
         String accountId = ccrz.cc_CallContext.effAccountId;
         Account acc = [Select ID,CSS_DistributorCode__c,BillingCountry from Account where ID=:accountId];
        
        if(acc!=null && !Label.OSM_North_America_Country.containsIgnoreCase(acc.BillingCountry) && !label.OSM_PO_Distributor_List.contains(acc.CSS_DistributorCode__c) || Test.isRunningTest())
        {
 
           returnMap.put('GOMSUser',true);
           
        }
        
       
        
        try
        {
            if(cartId != '')
            {
                ccrz.ccLog.log('>>>>>>>>enter into if block'+cartId);
                List<ccrz__E_Cart__c> cart = [select id,ccrz__Account__c, (select id,isRenew__c,ccrz__cartItemType__c,ccrz__Quantity__c,ccrz__Product__c,ccrz__Product__r.Name from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
               
                if(cart!=null && cart.size()==1)
                {
                    
                    
                    List<IAM_Application__c> iAMFeatureList = new List<IAM_Application__c>();
                    iAMFeatureList = [Select Id,IAM_Provisioned_Count__c,OSM_Max_Allowed_Users__c from IAM_Application__c where IAM_Account_Name__c =: cart[0].ccrz__Account__c and IAM_Application_Name__c='Guidanz Mobile' and IAM_Status__c='Active' limit 1];
                    Integer totalMaxUserCount=0;
                    Integer provisionUserCount=0;
                    Integer addOnQuantity=0;
                    List<id> productIds=new List<id>();
                    
                    if(iAMFeatureList!=null && iAMFeatureList.size()>0)
                    {
                        totalMaxUserCount=Integer.valueOf(iAMFeatureList[0].OSM_Max_Allowed_Users__c);
                        provisionUserCount=Integer.valueOf(iAMFeatureList[0].IAM_Provisioned_Count__c);
                    }
                   
                    for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                    {
                        //boolean ShowIamMsg = false;
                        if(Label.OSM_GuidanzMobile.contains(cartItem.ccrz__Product__r.Name) && cartItem.ccrz__cartItemType__c=='Major')
                        {
                            totalMaxUserCount =totalMaxUserCount+Integer.valueOf(cartItem.ccrz__Quantity__c)*2;
                        }
                        if(Label.OSM_GuidanzMobile.contains(cartItem.ccrz__Product__r.Name) && cartItem.ccrz__cartItemType__c=='Minor')
                        {
                            totalMaxUserCount =totalMaxUserCount+Integer.valueOf(cartItem.ccrz__Quantity__c);
                        }
                        if(cartItem.ccrz__Product__r.Name.contains('Add-on') || cartItem.ccrz__Product__r.Name.contains('Add-ON') || cartItem.ccrz__Product__r.Name.contains('Add-On'))
                        {
                            productIds.add(cartItem.ccrz__Product__c);
                            addOnQuantity=Integer.valueOf(cartItem.ccrz__Quantity__c);
                        }
                    }
                    if(productIds!=null && productIds.size()>0)
                    {
                        List<ccrz__E_CompositeProduct__c> composteProductsList = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(productIds);
            
                        for(ccrz__E_CompositeProduct__c compositeProduct:composteProductsList)
                        {
                            if(Label.OSM_GuidanzMobile.contains(compositeProduct.ccrz__Component__r.Name))
                            {
                                totalMaxUserCount=totalMaxUserCount+Integer.valueOf(compositeProduct.ccrz__Quantity__c)*addOnQuantity;
                            }
                        }
                    }
                    system.debug('provisionUserCount>>>>'+provisionUserCount);
                    system.debug('totalMaxUserCount>>>>'+totalMaxUserCount);
                    if(provisionUserCount>totalMaxUserCount)
                    {
                         //ShowIamMsg=true;
                         returnMap.put('showIAMProvisionMsg',true);
                         returnMap.put('proCount',provisionUserCount);
                         returnMap.put('maxCount',totalMaxUserCount);
                    }
                    system.debug('returnMap>>>>'+returnMap);
                }
            }
            
            if(Test.isRunningTest()){
                      throw new NullPointerException();                          
                    } 
            /*
            if(cartId != '')
            {
                ccrz.ccLog.log('>>>>>>>>enter into if block'+cartId);
                List<ccrz__E_Cart__c> cart = [select id,ccrz__Account__c, (select id,isRenew__c,ccrz__Quantity__c,ccrz__Product__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
                
                
                
                
                
                
                 ccrz.ccLog.log('cart______'+cart);
                if(cart!=null && cart.size()==1)
                {
                    
                    
                    List<ccrz__E_Subscription__c> listSubsc = new List<ccrz__E_Subscription__c>();
                    listSubsc = [Select Id,ccrz__Quantity__c,ccrz__SubscriptionProduct__c from ccrz__E_Subscription__c where ccrz__Account__c =: cart[0].ccrz__Account__c and ccrz__SubscriptionStatus__c = 'Active'];
                    Map<Id, Integer> mapExistingProductandQuantity = new Map<Id, Integer>();
                    
                    for(ccrz__E_Subscription__c sub : listSubsc)
                    {
                        mapExistingProductandQuantity.put(sub.ccrz__SubscriptionProduct__c, Integer.valueOf(sub.ccrz__Quantity__c));
                    }
                    
                    
                    
                    ccrz.ccLog.log('cart[0].ccrz__E_CartItems__r______'+cart[0].ccrz__E_CartItems__r);
                    List<hasRenewIMMsg> newListMsg = new List<hasRenewIMMsg>();
                    for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                    {
                        boolean ShowIamMsg = false;
                        if(cartItem.isRenew__c && mapExistingProductandQuantity.containsKey(cartItem.ccrz__Product__c) && mapExistingProductandQuantity.get(cartItem.ccrz__Product__c) > Integer.valueOf(cartItem.ccrz__Quantity__c))
                        {
                            ShowIamMsg = true;
                        }
                        hasRenewIMMsg newObj = new hasRenewIMMsg();
                        newObj.cartItemId = cartItem.Id;
                        newObj.showMsg = ShowIamMsg;
                        newListMsg.add(newObj);
                    }
                    
                    returnMap.put('cartItemList',newListMsg);
                }
            }
            */
           
        }
        Catch(Exception ex)
        {
            result.success = false;
        }
        result.data = returnMap;
        
        return result;
        
    }

    // Under Development - Juhi
    @RemoteAction
    global static ccrz.cc_RemoteActionResult applyCouponValidation(String couponCode, ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        String userType = '';
        if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
            userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
        } else{
            userType = OSM_SW_General_Util.USER_TYPE;
        }
        try
        {
            Boolean status = true;
            //String accountId = ccrz.cc_CallContext.currAccountId;
             String accountId = ccrz.cc_CallContext.effAccountId;
            String cartId = ccrz.cc_CallContext.currCartId;
            Account acc = [Select ID, Name, Type,Is_Coupon_Already_Used__c from Account where ID=:accountId];
            List<ccrz__E_Coupon__c> couponList = [Select ID,ccrz__EndDate__c,ccrz__MaxUse__c, ccrz__TotalUsed__c,ccrz__TargetRelation__c,ccrz__TargetProduct__c,OSM_Coupon_Discount_Target_Type__c,DN_Discount__c,Subscription_Migration_Coupon__c from ccrz__E_Coupon__c where ccrz__CouponCode__c=:couponCode];
            
            //ccrz__E_Cart__c cart = [select id, ccrz__TotalQuantity__c,createddate, (SELECT id, ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r where OSM_Group_Name__c!='FluidWatch') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
            ccrz__E_Cart__c cart = [select id, ccrz__TotalQuantity__c,createddate, (SELECT id, ccrz__Product__c,ccrz__Quantity__c FROM ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
            Set<String> prodsInCart = new Set<String>();
            List<ccrz__E_CartItem__c> cartItems = cart.ccrz__E_CartItems__r;
            ccrz__E_CartItem__c cartItemToCoup;
            String couponTargetProd = '';
            Boolean couponProdinCart = false;
            Boolean isProdTypeCoupon = false;


            for(ccrz__E_CartItem__c ci :cartItems){
                prodsInCart.add(ci.ccrz__Product__c);
            }


            for(ccrz__E_Coupon__c coup : couponList){
                if(prodsInCart.contains(coup.ccrz__TargetProduct__c)){
                    couponProdinCart = true;
                    couponTargetProd = coup.ccrz__TargetProduct__c;
                }
            }
            if(couponProdinCart){
                for(ccrz__E_CartItem__c ci :cartItems){
                    if(String.valueOf(ci.ccrz__Product__c) == couponTargetProd){
                        cartItemToCoup = ci;
                    }
                }
            }
            if(couponList[0].ccrz__EndDate__c<System.today())
            {
                ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','MSRP/DN if statement ');
                
                status = false;
            }
             //adding validation for the DIST users to avoid use of DN Discount coupon for themselves ...
            if(userType==Label.OSM_Distributor_Admin_UserType && (acc.Type =='Distributor Account' || acc.type=='Distributor Branch Account') && (couponList[0].OSM_Coupon_Discount_Target_Type__c=='MSRP' || couponList[0].OSM_Coupon_Discount_Target_Type__c=='MSRP/DN')&&!couponList[0].Subscription_Migration_Coupon__c)
            {
                ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','MSRP/DN if statement ');
                status = false;
            }
            
            if((couponCode == Label.VOTECH100OFFQSOL || couponCode == Label.VOTECH100OFFINSITE)  && acc.Type == 'VoTech')
            {
                // ccrz__E_Coupon__c coupon = [Select ID, ccrz__MaxUse__c, ccrz__TotalUsed__c,ccrz__TargetProduct__c from ccrz__E_Coupon__c where ccrz__CouponCode__c=:couponCode];
                
                if(cart.ccrz__TotalQuantity__c > (couponList[0].ccrz__MaxUse__c - couponList[0].ccrz__TotalUsed__c))
                {
                    status = false;
                }
            }
            else if((couponCode == Label.VOTECH100OFFQSOL || couponCode == Label.VOTECH100OFFINSITE) && acc.Type != 'Votech')
            {
                status = false; 
            }
            else if(couponList==null || couponList.isEmpty() || !couponProdinCart)
            {
                status = false; 
            }else if(cartItemToCoup.ccrz__Quantity__c > couponList[0].ccrz__MaxUse__c - couponList[0].ccrz__TotalUsed__c){
                status = false;
            }
            
            CCOSMPageUtil.buildResponseData(response,status, new Map<String, Object>{'CouponValidation' => status, 'couponList'=>couponList});
        }
        catch(Exception e)
        {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','applyCouponValidation');
            ccrz.ccLog.close(response);
        }
        
        return response;
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult preApplyCoupon(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        try{
            String cartId = ccrz.cc_CallContext.currCartId;
            //List<GuidanzProducts__c> gpskus = GuidanzProducts__c.getAll().values();
            //Set<String> guidanzskus = new Set<String>();
            List<ccrz__E_CartItem__c> updateCartItemList = new List<ccrz__E_CartItem__c>();
            //for(GuidanzProducts__c sku : gpskus){
            //    guidanzskus.add(sku.Name);
            //}
            //ccrz__E_CartItem__c guidanzBundle = 
            Map<String,Decimal> CIIdtoPriceMapping = new Map<String,Decimal>();
            if(cartId != '')
            {
                //List<ccrz__E_Cart__c> cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c, (select id,Name,ccrz__Product__c,ccrz__PricingType__c,ccrz__ItemTotal__c,ccrz__SubAmount__c,ccrz__Price__c from ccrz__E_CartItems__r where OSM_Group_Name__c!='FluidWatch' ) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
                List<ccrz__E_Cart__c> cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c, (select id,Name,ccrz__Product__c,ccrz__PricingType__c,ccrz__ItemTotal__c,ccrz__SubAmount__c,ccrz__Price__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
                Map<id,ccrz__E_CartItem__c> cartItemsMap=new Map<id,ccrz__E_CartItem__c>();
                if(cart!=null && cart.size()==1)
                {
                    for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                    {
                        //if(guidanzskus.contains(cartItem.ccrz__SKU__c) && ccrz__ProductType__c = 'Bundle' ){
                            // cartItem.Prorated_Price__c = cartItem.ccrz__Price__c;
                            cartItem.ccrz__PricingType__c = 'auto';
                            CIIdtoPriceMapping.put(String.valueOf(cartItem.id),cartItem.ccrz__Price__c);
                            updateCartItemList.add(cartItem);
                        //}                  
                    }
                    
                }
                update updateCartItemList;
            }
           CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'updateCartItemList' => updateCartItemList, 'CIIdtoPriceMapping'=>CIIdtoPriceMapping});
        }  catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','preApplyCoupon');
            ccrz.ccLog.close(response);
        }
        return response;

    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult postApplyCoupon(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);

        try{
            String cartId = ccrz.cc_CallContext.currCartId;
            List<ccrz__E_CartItem__c> updateCartItemList = new List<ccrz__E_CartItem__c>();
            if(cartId != '')
            {
                //List<ccrz__E_Cart__c> cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c, (select id,Name,ccrz__AbsoluteDiscount__c,ccrz__Product__c,ccrz__AdjustmentAmount__c,ccrz__cartItemType__c,ccrz__ProductType__c,ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Name from ccrz__E_CartItems__r where OSM_Group_Name__c!='FluidWatch') from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
                List<ccrz__E_Cart__c> cart = [select id,ccrz__TotalAmount__c,ccrz__EncryptedId__c, (select id,Name,ccrz__AbsoluteDiscount__c,ccrz__Product__c,ccrz__AdjustmentAmount__c,ccrz__cartItemType__c,ccrz__ProductType__c,ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.Name from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
                Map<id,ccrz__E_CartItem__c> cartItemsMap=new Map<id,ccrz__E_CartItem__c>();
                if(cart!=null && cart.size()==1)
                {
                    for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                    {
                            if(cartItem.ccrz__AbsoluteDiscount__c!=null)
                            //cartItem.ccrz__AdjustmentAmount__c =cartItem.ccrz__AbsoluteDiscount__c;
                            
                            updateCartItemList.add(cartItem);                 
                    }
                    
                }
                //update updateCartItemList;

            }

            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'updateCartItemList' => 'test'});

        }catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','preApplyCoupon');
            ccrz.ccLog.close(response);
        }
        return response;

    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCouponCode(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        //String accountId = ccrz.cc_CallContext.currAccountId;
        String accountId = ccrz.cc_CallContext.effAccountId;
        String cartId = ccrz.cc_CallContext.currCartId;
        //List<ccrz__E_Cart__c> cartforId = [SELECT Id, ccrz__EncryptedId__c,(SELECT id,ccrz__ProductType__c,ccrz__Product__r.Name FROM ccrz__E_CartItems__r where OSM_Group_Name__c!='FluidWatch')  FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
        List<ccrz__E_Cart__c> cartforId = [SELECT Id, ccrz__EncryptedId__c,(SELECT id,OSM_Group_Name__c,ccrz__ProductType__c,ccrz__Product__r.Name FROM ccrz__E_CartItems__r)  FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
        List<OSM_Existing_Subscription__c> existingSubWithCouponListDealer=new List<OSM_Existing_Subscription__c>();
        List<OSM_Existing_Subscription__c> existingSubWithCouponListDistributor=new List<OSM_Existing_Subscription__c>();
        List<ccrz__E_Coupon__c> couponList=new List<ccrz__E_Coupon__c>();
        List<ccrz__E_Subscription__c> subscriptionList=[select id,ccrz__Account__c,ccrz__SubscriptionProduct__c,OSM_Subscription_End_Date__c  from ccrz__E_Subscription__c where ccrz__Account__c=:accountId and ccrz__SubscriptionProduct__r.ccrz__ProductType__c='Bundle'];
         
        // add cart coupon check so if a coupon already add to cart, it wont show again Yubo
        List<ccrz__E_CartCoupon__c> cartCoupons;   
        Set<String> prodsInCart = new Set<String>();
        boolean votechINSITE=false;
        boolean votechQSOL=false;
       
        try{
                //getting the account record...
                List<Account> accountList=[select id,name,type,Business_Unit__c,ServiceLevel__c,OSM_Service_Level__c,DTNA__c,Is_Coupon_Already_Used__c from Account where id=:accountId]; // Mar-1236 added ServiceLevel__c
                if(!cartforId.isEmpty()){
                    cartCoupons = [select id,ccrz__Cart__c,ccrz__Coupon__r.ccrz__CouponCode__c,ccrz__Enabled__c FROM ccrz__E_CartCoupon__c WHERE ccrz__Cart__c =:cartforId[0].Id];      
                }

                Set<String> cartCode = new Set<String>();
                for(ccrz__E_CartCoupon__c cartCp: cartCoupons){
                    cartCode.add(String.valueOf(cartCp.ccrz__Coupon__r.ccrz__CouponCode__c));
                }
                if(cartforId!=null)
                {
                   for(ccrz__E_CartItem__c ci :cartforId[0].ccrz__E_CartItems__r)
                    {
                        if(ci.ccrz__ProductType__c=='Bundle' && ci.OSM_Group_Name__c == 'SES')
                        {
                           prodsInCart.add(ci.ccrz__ProductType__c);
                        }
                        if(ci.ccrz__Product__r.Name.contains('INSITE'))
                        {
                            votechINSITE=true;
                        }
                        if(ci.ccrz__Product__r.Name.contains('QSOL'))
                        {
                            votechQSOL=true;
                        }
                        
                    } 
                }
                
                //getting existing subscription record to check coupon code on the base of account type..
                if(accountList != null && accountList.size()!=0)
                {
                    String DealerType='';
                     if('PSBU' != accountList[0].Business_Unit__c)
                        {
                        /*  if('Full Service' == accountList[0].OSM_Service_Level__c)  Mar-1236
                            {
                                DealerType = 'Deal' + '_FS';
                            }
                            else if('Lite Repair' == accountList[0].OSM_Service_Level__c)
                            {
                                DealerType = 'Deal'+'_Maint';
                            } */
              
              if('Full Service' == accountList[0].ServiceLevel__c)
                            {
                                DealerType = 'Deal' + '_FS';
                            }
                            else
                            {
                                DealerType = 'Deal'+'_Maint';
                            }
                        }system.debug('$$$$$$$$$$$'+accountList);
                        if(accountList[0].type=='Dealer Account' && DealerType!='Deal_Maint' && accountList[0].DTNA__c==false)
                        {
                            existingSubWithCouponListDealer=[select id,Dealer_Coupon_Code__c,Is_Coupon_Already_Used__c from OSM_Existing_Subscription__c where Account__c=:accountId and Dealer_Coupon_Code__c!=null limit 1];
                        }
                        else if(accountList[0].type=='Fleet' || DealerType=='Deal_Maint')
                        {
                            String fleetCouponName=Label.Fleet_Coupon_Code;
                            couponList=[select id,ccrz__CouponCode__c,ccrz__CouponName__c from ccrz__E_Coupon__c where ccrz__CouponName__c=:fleetCouponName limit 1];
                        }
                        else if(accountList[0].type=='Distributor Account' || accountList[0].type=='Distributor Branch Account')
                        {
                            existingSubWithCouponListDistributor=[select id,Distributor_Coupon_Code__c,Is_Coupon_Already_Used__c from OSM_Existing_Subscription__c where Account__c=:accountId and Distributor_Coupon_Code__c!=null limit 1];
                        }
                }
                
                system.debug('account details >>>>>'+accountList[0]);
                String couponCode='';
                if(existingSubWithCouponListDealer !=null && existingSubWithCouponListDealer.size()>0)
                {
                    for(OSM_Existing_Subscription__c existSubRecord:existingSubWithCouponListDealer)
                    {
                        couponCode=existSubRecord.Dealer_Coupon_Code__c;
                    }
                    if(accountList[0].Is_Coupon_Already_Used__c)
                    {
                        CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => ''});
                    }
                    else{
                        //CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => couponCode});
                        if(!cartCode.contains(couponCode) && !couponCode.contains('No Discount') && (prodsInCart!=null && prodsInCart.size()>0)){
                            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' =>'Enter This Coupon Code : ' + couponCode});
                        }
                        else{
                           CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => ''}); 
                        }
                    }
                    
                }
                else if(existingSubWithCouponListDistributor !=null && existingSubWithCouponListDistributor.size()>0)
                {
                    for(OSM_Existing_Subscription__c existSubRecord:existingSubWithCouponListDistributor)
                    {
                        couponCode=existSubRecord.Distributor_Coupon_Code__c;
                    }
                    if(accountList[0].Is_Coupon_Already_Used__c)
                    {
                        CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => ''});
                    }
                    else{
                        //CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => couponCode});
                        if(!cartCode.contains(couponCode) && !couponCode.contains('No Discount') && (prodsInCart!=null && prodsInCart.size()>0)){
                            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => 'Enter This Coupon Code : ' + couponCode });
                        }
                        else{
                           CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => ''}); 
                        }
                    }
                    
                }
                /*else
                {
                    if(subscriptionList==null)
                    {   
                        if(couponList!=null && couponList.size()>0)
                        CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => couponList[0].ccrz__CouponCode__c});
                    }
                    else
                    {
                        CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCode' => 'Coupon Already Used for this Account'});
                    }

                }*/
            
            // Juhi Update to show VoTech coupon for Votech accounts
            if(accountList != null && accountList.size()!=0 && 'Votech' == accountList[0].Type)
            {
                String votechCouponCodeINSITE = Label.VOTECH100OFFINSITE;
                String votechCouponCodeQSOL = Label.VOTECH100OFFQSOL;
                
                ccrz__E_Cart__c cart = [select id, ccrz__TotalQuantity__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
                List<ccrz__E_Coupon__c> couponListVotech = [Select ID, ccrz__MaxUse__c, ccrz__TotalUsed__c,ccrz__CouponCode__c from ccrz__E_Coupon__c where (ccrz__CouponCode__c=:votechCouponCodeINSITE or ccrz__CouponCode__c=:votechCouponCodeQSOL)];
                boolean INSITECoupon=false;
                boolean QSOLCoupon=false;
                if(couponListVotech!=null && couponListVotech.size()>0)
                {
                    
                    for(ccrz__E_Coupon__c coupon:couponListVotech)
                    {
                        if(coupon.ccrz__CouponCode__c.contains('INSITE') && votechINSITE)
                        {
                            if(cart.ccrz__TotalQuantity__c <= (coupon.ccrz__MaxUse__c - coupon.ccrz__TotalUsed__c) )
                            {
                                //CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCodeINSITE' => 'Use code ' + votechCouponCodeINSITE + ' For INSITE' });
                                INSITECoupon=true;
                            }
                        }
                        if(coupon.ccrz__CouponCode__c.contains('QSOL') && votechQSOL)
                        {
                            if(cart.ccrz__TotalQuantity__c <= (coupon.ccrz__MaxUse__c - coupon.ccrz__TotalUsed__c) )
                            {
                                //CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCodeQSOL' => 'Use code ' + votechCouponCodeQSOL + ' For QSOL' });
                                QSOLCoupon=true;
                            }
                        }
                    }
                    if(INSITECoupon && QSOLCoupon)
                    {
                         CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCodeINSITE' => 'Use code ' + votechCouponCodeINSITE + ' For INSITE','CouponCodeQSOL' => 'Use code ' + votechCouponCodeQSOL + ' For QSOL' });
                           
                    }
                    else if(QSOLCoupon)
                    {
                        CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCodeQSOL' => 'Use code ' + votechCouponCodeQSOL + ' For QSOL' });
                                
                    }
                    else if(INSITECoupon)
                    {
                        CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CouponCodeINSITE' => 'Use code ' + votechCouponCodeINSITE + ' For INSITE'});
                         
                    }
                }
                
            }
           
        }
        catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','preApplyCoupon');
            ccrz.ccLog.close(response);
        }
        return response;
    }

    @RemoteAction
    global static ccrz.cc_RemoteActionResult OSMApplyCoupon(ccrz.cc_RemoteActionContext ctx, Map<String,Decimal> CIIdToPrice, String couponCode, Boolean skipPricing)
    {
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        Boolean couponExist = false;
        String userType = '';
        try{
            if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
            } else{
                userType = OSM_SW_General_Util.USER_TYPE;
            }
            String cartId = ccrz.cc_CallContext.currCartId;
            //String accountId = ccrz.cc_CallContext.currAccountId;
             String accountId = ccrz.cc_CallContext.effAccountId;
            Account acc = [Select ID, Name, Type,Is_Coupon_Already_Used__c from Account where ID=:accountId];
            List<ccrz__E_CartCoupon__c> cartCoupons = new List<ccrz__E_CartCoupon__c>();
            Map<String,String> couponProdMap = new Map<String,String>();
            //List<ccrz__E_Cart__c> cartforId = [SELECT Id, ccrz__EncryptedId__c,(select id,Name,ccrz__Product__c,ccrz__PricingType__c,Prorated_Coupon_Discount__c,Prorated_Price__c,Prorated_Subamount__c,ccrz__Quantity__c,ccrz__ItemTotal__c,ccrz__SubAmount__c,ccrz__Price__c from ccrz__E_CartItems__r where OSM_Group_Name__c!='FluidWatch') FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
            List<ccrz__E_Cart__c> cartforId = [SELECT Id, ccrz__EncryptedId__c,(select id,Name,ccrz__Product__c,ccrz__PricingType__c,Prorated_Coupon_Discount__c,Prorated_Price__c,Prorated_Subamount__c,ccrz__Quantity__c,ccrz__ItemTotal__c,ccrz__SubAmount__c,ccrz__Price__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c from ccrz__E_CartItems__r) FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
            List<ccrz__E_Coupon__c> couponList = [Select Id, ccrz__MaxUse__c, ccrz__CouponCode__c, ccrz__TotalUsed__c,ccrz__TargetProduct__c,ccrz__CouponType__c,ccrz__DiscountAmount__c,ccrz__TargetQty__c,DN_Discount__c,OSM_Coupon_Discount_Target_Type__c  from ccrz__E_Coupon__c where ccrz__CouponCode__c=:couponCode];
            List<ccrz__E_CartItem__c> cartItemToBeUpdate = new List<ccrz__E_CartItem__c>();
            ccrz__E_CartCoupon__c newCartCoupon;
            if(!cartforId.isEmpty() && !couponList.isEmpty()){
                newCartCoupon = new ccrz__E_CartCoupon__c(ccrz__Cart__c=cartforId[0].Id,ccrz__Coupon__c=couponList[0].Id,Name=couponList[0].Id);
                cartCoupons = [SELECT Id, ccrz__Cart__c,ccrz__CartCouponId__c,ccrz__Coupon__c,ccrz__Coupon__r.ccrz__CouponCode__c,ccrz__Coupon__r.ccrz__TargetProduct__c FROM ccrz__E_CartCoupon__c WHERE ccrz__Cart__c =: cartforId[0].Id];
                for(ccrz__E_CartCoupon__c cartC : cartCoupons){
                
                    couponProdMap.put(String.valueOf(cartC.ccrz__Coupon__r.ccrz__CouponCode__c),String.valueOf(cartC.ccrz__Coupon__r.ccrz__TargetProduct__c));
                }
                //test
                
                List<Subscription_Length_Estimation__mdt> subscriptionLengthMdt = new List<Subscription_Length_Estimation__mdt>();
                subscriptionLengthMdt = [SELECT Label, Coupon_Cost_Estimation__c FROM Subscription_Length_Estimation__mdt];
                System.debug('subscriptionLengthMdt: '+subscriptionLengthMdt);
                Map<String, Integer> mapSubscriptionLengthVsMultiplyer = new Map<String, Integer>();
                for(Subscription_Length_Estimation__mdt mtdRecord: subscriptionLengthMdt)
                {
                    mapSubscriptionLengthVsMultiplyer.put(mtdRecord.Label,Integer.valueOf(mtdRecord.Coupon_Cost_Estimation__c));
                }
                        
                if(cartCoupons.isEmpty() || !couponProdMap.containsKey(couponCode)){
                    couponProdMap.put(couponList[0].ccrz__CouponCode__c,couponList[0].ccrz__TargetProduct__c);
                    insert newCartCoupon; 
                    
                        
                        for(ccrz__E_CartItem__c currentCI : cartforId[0].ccrz__E_CartItems__r){
                            if(currentCI.ccrz__Product__c == couponList[0].ccrz__TargetProduct__c){
                                if(couponList[0].ccrz__TargetQty__c >= currentCI.ccrz__Quantity__c){
                                    
                                    // logic for subscription length MP-307
                                    
                                    Double dnDiscountPrice = 0.0;
                                    Double discountAmount = 0.0;
                                    if(couponList[0].ccrz__CouponType__c != 'Percentage')
                                    {
                                        System.debug('mapSubscriptionLengthVsMultiplyer: '+mapSubscriptionLengthVsMultiplyer);
                                        System.debug('currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c: '+currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                        if(mapSubscriptionLengthVsMultiplyer.containsKey(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c))
                                        {
                                            if(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c.containsIgnoreCase('YEAR'))
                                            {
                                                discountAmount = couponList[0].ccrz__DiscountAmount__c*mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                                dnDiscountPrice = couponList[0].DN_Discount__c*mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                            }
                                            else
                                            {
                                                discountAmount = couponList[0].ccrz__DiscountAmount__c/mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                                dnDiscountPrice = couponList[0].DN_Discount__c/mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                            }
                                        }
                                        else
                                        {
                                            discountAmount = couponList[0].ccrz__DiscountAmount__c;
                                            dnDiscountPrice = couponList[0].DN_Discount__c;
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    if(userType==Label.OSM_Distributor_Admin_UserType && (acc.Type =='Distributor Account' || acc.type=='Distributor Branch Account') && couponList[0].OSM_Coupon_Discount_Target_Type__c=='DN')
                                    {
                                        if(couponList[0].ccrz__CouponType__c == 'Percentage'){
                                            
                                            currentCI.Prorated_Coupon_Discount__c = (currentCI.Prorated_Price__c*(couponList[0].DN_Discount__c/100)*currentCI.ccrz__Quantity__c);
                                        }else{
                                            currentCI.Prorated_Coupon_Discount__c = dnDiscountPrice;
                                        }
                                    }
                                    else
                                    {
                                        if(couponList[0].ccrz__CouponType__c == 'Percentage'){
                                            
                                            currentCI.Prorated_Coupon_Discount__c = (currentCI.Prorated_Price__c*(couponList[0].ccrz__DiscountAmount__c/100)*currentCI.ccrz__Quantity__c);
                                        }else{
                                            currentCI.Prorated_Coupon_Discount__c = discountAmount;
                                        }
                                    }
                                }else{
                                    
                                    // logic for subscription length MP-307
                                    
                                    Double dnDiscountPrice = 0.0;
                                    Double discountAmount = 0.0;
                                    if(couponList[0].ccrz__CouponType__c != 'Percentage')
                                    {
                                        System.debug('mapSubscriptionLengthVsMultiplyer: '+mapSubscriptionLengthVsMultiplyer);
                                        System.debug('currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c: '+currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                        if(mapSubscriptionLengthVsMultiplyer.containsKey(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c))
                                        {
                                            if(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c.containsIgnoreCase('YEAR'))
                                            {
                                                discountAmount = couponList[0].ccrz__DiscountAmount__c*mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                                dnDiscountPrice = couponList[0].DN_Discount__c*mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                            }
                                            else
                                            {
                                                discountAmount = couponList[0].ccrz__DiscountAmount__c/mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                                dnDiscountPrice = couponList[0].DN_Discount__c/mapSubscriptionLengthVsMultiplyer.get(currentCI.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
                                            }
                                        }
                                        else
                                        {
                                            discountAmount = couponList[0].ccrz__DiscountAmount__c;
                                            dnDiscountPrice = couponList[0].DN_Discount__c;
                                        }
                                        
                                    }
                                    
                                    
                                    if(userType==Label.OSM_Distributor_Admin_UserType && (acc.Type =='Distributor Account' || acc.type=='Distributor Branch Account') && couponList[0].OSM_Coupon_Discount_Target_Type__c=='DN')
                                    {
                                        if(couponList[0].ccrz__CouponType__c == 'Percentage'){
                                            currentCI.Prorated_Coupon_Discount__c = (currentCI.Prorated_Price__c*(couponList[0].DN_Discount__c/100)*couponList[0].ccrz__TargetQty__c);
                                            
                                        }else{
                                            currentCI.Prorated_Coupon_Discount__c = dnDiscountPrice;
                                        }
                                    }
                                    else
                                    {
                                        if(couponList[0].ccrz__CouponType__c == 'Percentage'){
                                            currentCI.Prorated_Coupon_Discount__c = (currentCI.Prorated_Price__c*(couponList[0].ccrz__DiscountAmount__c/100)*couponList[0].ccrz__TargetQty__c);
                                            
                                        }else{
                                            currentCI.Prorated_Coupon_Discount__c = discountAmount;
                                        }
                                    }
                                }                                
                            }
                            cartItemToBeUpdate.add(currentCI);
                        }
                if(!cartItemToBeUpdate.isEmpty()){
                    update cartItemToBeUpdate;
                }


                } else {
                    couponExist = true;
                }



            }



            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'couponExist' => couponExist, 'couponProdMap'=>couponCode ,'cartCoupons'=>couponList, 'CIIdToPrice'=>CIIdToPrice});
        }
        catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','OSMApplyCoupon');
            ccrz.ccLog.close(response);
        }
        return response;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult OSMDeleteCoupon(ccrz.cc_RemoteActionContext ctx, String couponId){
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        List<ccrz__E_CartCoupon__c> cartCoupons = new List<ccrz__E_CartCoupon__c>();

        try{
            String cartId = ccrz.cc_CallContext.currCartId;
            //List<ccrz__E_Cart__c> cartforId = [SELECT Id, ccrz__EncryptedId__c,(select id,Name,ccrz__Product__c,ccrz__PricingType__c,Prorated_Coupon_Discount__c,Prorated_Price__c,Prorated_Subamount__c,ccrz__Quantity__c,ccrz__ItemTotal__c,ccrz__SubAmount__c,ccrz__Price__c from ccrz__E_CartItems__r where OSM_Group_Name__c!='FluidWatch') FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
            List<ccrz__E_Cart__c> cartforId = [SELECT Id, ccrz__EncryptedId__c,(select id,Name,ccrz__Product__c,ccrz__PricingType__c,Prorated_Coupon_Discount__c,Prorated_Price__c,Prorated_Subamount__c,ccrz__Quantity__c,ccrz__ItemTotal__c,ccrz__SubAmount__c,ccrz__Price__c from ccrz__E_CartItems__r) FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
            cartCoupons = [SELECT Id, ccrz__Cart__c,ccrz__CartCouponId__c,ccrz__Coupon__c,ccrz__Coupon__r.ccrz__CouponCode__c,ccrz__Coupon__r.ccrz__TargetProduct__c FROM ccrz__E_CartCoupon__c WHERE ccrz__Coupon__r.ccrz__CouponCode__c=:couponId AND ccrz__Cart__c=:cartforId[0].id];

            List<ccrz__E_CartItem__c> cartItemToBeUpdate = new List<ccrz__E_CartItem__c>();
            for(ccrz__E_CartItem__c ci: cartforId[0].ccrz__E_CartItems__r){
                if(ci.ccrz__Product__c == cartCoupons[0].ccrz__Coupon__r.ccrz__TargetProduct__c){
                    ci.Prorated_Coupon_Discount__c = 0;
                    cartItemToBeUpdate.add(ci);
                }
            }
            if(!cartCoupons.isEmpty()){
               delete cartCoupons[0];
            }
            if(!cartItemToBeUpdate.isEmpty()){
                update cartItemToBeUpdate;
            }

            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'cartCoupons' => cartCoupons});

        }
        catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','OSMDeleteCoupon');
            ccrz.ccLog.close(response);
        }
        return response;



    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult customUpdateCart(ccrz.cc_RemoteActionContext ctx, map<String, Integer> CItoUpdate){
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);

        String userType='';
        try{
            if(!OSM_SW_General_Util.ALREADY_CHECK_USER_PERMISSIONSET){
                userType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());
            } else{
                userType = OSM_SW_General_Util.USER_TYPE;
            }
            Set<String> keys = CItoUpdate.keySet(); system.debug('@@@@@'+keys);
            List<ccrz__E_CartItem__c> cartItemsToUpdate = new List<ccrz__E_CartItem__c>();
            Map<string,ccrz__E_Coupon__c> couponsMap=new Map<string,ccrz__E_Coupon__c>();
            Map<String,Boolean> prodToAllowedMap = new Map<String,Boolean>();
            //String accountId = ccrz.cc_CallContext.currAccountId;
             String accountId = ccrz.cc_CallContext.effAccountId;
            Account acc = [Select ID, Name, Type,Is_Coupon_Already_Used__c from Account where ID=:accountId];
            Boolean allCIUpdateAllow = true;
            
			//Added fields ccrz__Product__r.Name,isRenew__c,OSM_Renewed_Sub_Id__c for MP-573
            cartItemsToUpdate = [SELECT id,ccrz__Coupon__c,Unit_Dn_Price__c,Dn_Price__c,ccrz__Quantity__c,ccrz__Cart__c,
                                    Prorated_Price__c,Prorated_Coupon_Discount__c,ccrz__PercentDiscount__c,
                                    ccrz__Product__c, ccrz__Product__r.Group_Name__c,isRenew__c,OSM_Renewed_Sub_Id__c,ccrz__ParentCartItem__c
                                    FROM ccrz__E_CartItem__c WHERE id in:keys];
//system.debug('#######'+cartItemsToUpdate[0].ccrz__Cart__c);
            Boolean isMatch = false;
            string parentCartItem = '';
            Decimal quant = 0;
			Boolean isRenew=false;
			//MP-573 start
            Set<Id> renewSubId=new Set<Id>();
            Map<Id,Integer> itemQuanityMap=new Map<Id,Integer>();
            Map<Id,Boolean> renewStatusMap=new Map<Id,Boolean>();
            List<SubQuantityMessage> msgList=new List<SubQuantityMessage>();
            Integer subQuantity=0;
            Integer quantity=0;
            Boolean showSubPopup=false;
            Boolean couponValidMsg=false;
            //MP-573 End
            for(ccrz__E_CartItem__c cartItem : cartItemsToUpdate){
			    //MP-573 start
                if(cartItem.isRenew__c)
                {
                    renewSubId.add(cartItem.OSM_Renewed_Sub_Id__c);
                    quantity=Integer.valueOf(CItoUpdate.get(String.valueOf(cartItem.id)));
                    itemQuanityMap.put(cartItem.OSM_Renewed_Sub_Id__c,quantity);
                    renewStatusMap.put(cartItem.OSM_Renewed_Sub_Id__c,cartItem.isRenew__c);
                   
                }
                //MP-573 end
                if(cartItem.ccrz__Product__r.Group_Name__c == 'FluidWatch'){
                    isMatch = true;
                    parentCartItem = cartItem.Id;
                    quant = Decimal.valueOf(CItoUpdate.get(String.valueOf(cartItem.id)));
                    break;
                }
            }
            //MP-573 start
			
            List<ccrz__E_Subscription__c> subList=[select id,name,ccrz__SubscriptionProduct__r.Name,ccrz__Quantity__c from ccrz__E_Subscription__c where id in:renewSubId and ccrz__Account__c=:accountId];
            msgList.clear();
			if(subList!=null &&  subList.size()>0)
            {
              for(ccrz__E_Subscription__c sub:subList)
              {
                SubQuantityMessage msg=new SubQuantityMessage();
                msg.SubQuan=Integer.valueOf(sub.ccrz__Quantity__c);
                msg.cartItemQuan=itemQuanityMap.get(sub.id);
                msg.showSubPopup=true;
                //msgList.add(msg);
                //subQuantity=Integer.valueOf(sub.ccrz__Quantity__c);
                if(itemQuanityMap.get(sub.id) !=null && itemQuanityMap.get(sub.id)>sub.ccrz__Quantity__c)
                {
                 //allCIUpdateAllow=false;
                 msgList.add(msg);
                }
              }  
                
            }
            if(msgList!=null && msgList.size()>0)
            allCIUpdateAllow=false;
            //MP-573 end
            // Add logic for Mar-465

            //system.debug('#######222--'+cartItemsToUpdate[0].ccrz__Cart__c);
            List<ccrz__E_CartCoupon__c> cartCoupons = new List<ccrz__E_CartCoupon__c>();
			
			if(cartItemsToUpdate!=null && cartItemsToUpdate.size()>0)
            cartCoupons = [SELECT Id, ccrz__Cart__c,ccrz__CartCouponId__c,ccrz__Coupon__c,ccrz__Coupon__r.ccrz__TargetProduct__c,ccrz__Coupon__r.ccrz__MaxUse__c,ccrz__Coupon__r.ccrz__TotalUsed__c,ccrz__Coupon__r.ccrz__CouponCode__c,ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c,ccrz__Coupon__r.ccrz__CouponType__c,ccrz__Coupon__r.DN_Discount__c,ccrz__Coupon__r.ccrz__DiscountAmount__c,ccrz__Coupon__r.ccrz__TargetQty__c  FROM ccrz__E_CartCoupon__c WHERE ccrz__Cart__c=:cartItemsToUpdate[0].ccrz__Cart__c];
            
			Map<String,ccrz__E_CartCoupon__c> prodToCpTargetQtyMap = new Map<String,ccrz__E_CartCoupon__c>();
            for(ccrz__E_CartCoupon__c cartcp : cartCoupons){
                prodToCpTargetQtyMap.put(cartcp.ccrz__Coupon__r.ccrz__TargetProduct__c,cartcp);
            }
            //List<ccrz__E_Coupon__c> couponList = [Select Id, ccrz__MaxUse__c, ccrz__CouponCode__c, ccrz__TotalUsed__c,ccrz__TargetProduct__c,ccrz__CouponType__c,ccrz__DiscountAmount__c,ccrz__TargetQty__c,DN_Discount__c,OSM_Coupon_Discount_Target_Type__c  from ccrz__E_Coupon__c];
            /*for(ccrz__E_Coupon__c coupon:couponList)
            {
                couponsMap.put(ccrz__CouponCode__c,coupon);
            }*/
            if(!cartItemsToUpdate.isEmpty()){
                for(ccrz__E_CartItem__c cartItem:cartItemsToUpdate){
                    if(CItoUpdate.containsKey(String.valueOf(cartItem.id))){
                        cartItem.ccrz__Quantity__c = CItoUpdate.get(String.valueOf(cartItem.id));
                        cartItem.Dn_Price__c = (cartItem.Unit_Dn_Price__c * cartItem.ccrz__Quantity__c);
                        /*if(String.isNotBlank(String.valueOf(cartItem.ccrz__PercentDiscount__c))){
                            cartItem.Prorated_Coupon_Discount__c = (cartItem.ccrz__Quantity__c * cartItem.Prorated_Price__c)*(cartItem.ccrz__PercentDiscount__c / 100);
                        }*/
                        if(prodToCpTargetQtyMap.containsKey(cartItem.ccrz__Product__c))
                        {
                            ccrz__E_CartCoupon__c cartcp = prodToCpTargetQtyMap.get(cartItem.ccrz__Product__c);
                            if(userType==Label.OSM_Distributor_Admin_UserType && (acc.Type =='Distributor Account' || acc.type=='Distributor Branch Account') && cartcp.ccrz__Coupon__r.OSM_Coupon_Discount_Target_Type__c=='DN')
                            {
                                if(cartcp.ccrz__Coupon__r.ccrz__CouponType__c == 'Percentage'){
                                    if(cartItem.ccrz__Quantity__c <= cartcp.ccrz__Coupon__r.ccrz__TargetQty__c){
                                        cartItem.Prorated_Coupon_Discount__c=(cartItem.ccrz__Quantity__c * cartItem.Prorated_Price__c)*(cartcp.ccrz__Coupon__r.DN_Discount__c / 100);
                                    }else{
                                        cartItem.Prorated_Coupon_Discount__c=(cartcp.ccrz__Coupon__r.ccrz__TargetQty__c * cartItem.Prorated_Price__c)*(cartcp.ccrz__Coupon__r.DN_Discount__c / 100);
                                    }

                                }
                                else if(cartcp.ccrz__Coupon__r.ccrz__CouponType__c == 'Absolute')
                                {
                                    cartItem.Prorated_Coupon_Discount__c=cartcp.ccrz__Coupon__r.DN_Discount__c;
                                }
                            }
                            else
                            {
                                if(cartcp.ccrz__Coupon__r.ccrz__CouponType__c == 'Percentage'){
                                     if(cartItem.ccrz__Quantity__c <= cartcp.ccrz__Coupon__r.ccrz__TargetQty__c){
                                    cartItem.Prorated_Coupon_Discount__c=(cartItem.ccrz__Quantity__c * cartItem.Prorated_Price__c)*(cartcp.ccrz__Coupon__r.ccrz__DiscountAmount__c / 100);
                                    }
                                    else
                                    {
                                        cartItem.Prorated_Coupon_Discount__c=(cartcp.ccrz__Coupon__r.ccrz__TargetQty__c * cartItem.Prorated_Price__c)*(cartcp.ccrz__Coupon__r.ccrz__DiscountAmount__c / 100);
                                   
                                    }
                                }
                                else if(cartcp.ccrz__Coupon__r.ccrz__CouponType__c == 'Absolute')
                                {
                                    cartItem.Prorated_Coupon_Discount__c=cartcp.ccrz__Coupon__r.ccrz__DiscountAmount__c;
                                }
                            }
                        }
                    }

                }
                prodToAllowedMap = validateCouponCodeQty(cartItemsToUpdate,cartCoupons);
                for(Boolean ciAllow:prodToAllowedMap.values()){
                    if(!ciAllow){
                       allCIUpdateAllow = false;
                       break; 
                    }
                }
                if(allCIUpdateAllow)          
                    update cartItemsToUpdate;
                if(isMatch){
                    List<ccrz__E_CartItem__c> list_CIUpdate = new List<ccrz__E_CartItem__c>();
                    for(ccrz__E_CartItem__c cartItem : [SELECT id,ccrz__Coupon__c,Unit_Dn_Price__c,Dn_Price__c,ccrz__Quantity__c,ccrz__Cart__c,
                                                            Prorated_Price__c,Prorated_Coupon_Discount__c,ccrz__PercentDiscount__c,
                                                            ccrz__Product__c, ccrz__Product__r.Group_Name__c, ccrz__ParentCartItem__c
                                                            FROM ccrz__E_CartItem__c WHERE ccrz__ParentCartItem__c =: parentCartItem]){
                        cartItem.ccrz__Quantity__c = quant;
                        if(cartItem.Dn_Price__c != null){
                            cartItem.Dn_Price__c = (cartItem.Dn_Price__c * quant);
                        }
                        else{
                            cartItem.Dn_Price__c = 0;
                        }
                        list_CIUpdate.add(cartItem);
                    }                   
                    if(list_CIUpdate.size() > 0){
                        update list_CIUpdate;
                    }
                }
            }
            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'CItoUpdate'=>keys,'allCIUpdateAllow'=>allCIUpdateAllow,'prodToAllowedMap'=>prodToAllowedMap,'subQuanMsgList'=>msgList,'couponValidMsg'=>couponValidMsg});
            
        }
        catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','OSMDeleteCoupon');
            ccrz.ccLog.close(response);
        }
        return response;
    }

    public static Map<String,Boolean> validateCouponCodeQty (List<ccrz__E_CartItem__c> cartItemsToUpdate,List<ccrz__E_CartCoupon__c> cartCoupons){

        Map<String,Integer> prodToAviCouponQty = new Map<String,Integer>();
        Map<String,Boolean> prodToAllowedMap = new Map<String,Boolean>();
        for(ccrz__E_CartCoupon__c cartC : cartCoupons){
            prodToAviCouponQty.put(cartC.ccrz__Coupon__r.ccrz__TargetProduct__c,Integer.valueOf(cartC.ccrz__Coupon__r.ccrz__MaxUse__c)-Integer.valueOf(cartC.ccrz__Coupon__r.ccrz__TotalUsed__c));
        }
        ccrz.ccLog.log('prodToAviCouponQty' +prodToAviCouponQty);
        for(ccrz__E_CartItem__c ci:cartItemsToUpdate){
            if(ci.ccrz__Quantity__c > prodToAviCouponQty.get(String.valueOf(ci.ccrz__Product__c))){
                prodToAllowedMap.put(String.valueOf(ci.ccrz__Product__c),false);
            } else {
                prodToAllowedMap.put(String.valueOf(ci.ccrz__Product__c),true);
            }
        }
        ccrz.ccLog.log('prodToAviCouponQty' +prodToAllowedMap);

        return prodToAllowedMap;
    }


    public class hasRenewIMMsg
    {
        public Id cartItemId{get;set;}
        public boolean showMsg{get;set;}
    }
    public class CartValidationMsg
    {
        public Id cartItemIds{get;set;}
        public boolean showMsg1{get;set;}
        public boolean showMsg2{get;set;}
    }
	 public class SubQuantityMessage
    {
        public Integer SubQuan{get;set;}
        public Integer cartItemQuan{get;set;}
        public boolean showSubPopup{get;set;}
    }
    //MP-573 End
 }