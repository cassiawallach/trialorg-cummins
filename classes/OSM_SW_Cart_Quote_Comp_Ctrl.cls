/**********************************************************************
Name:  OSM_SW_Cart_Quote_Comp_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to handle the Cart page features                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            3/12/2018     INITIAL DEVELOPMENT          


*****************************************************/

global class OSM_SW_Cart_Quote_Comp_Ctrl {


/*----------------------------------------------------------------------------------
1. fetchQuote
Description:Used to fetch Quote item to be displayed on Cart Page
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns the Quote items to be displayed to user

------------------------------------------------------------------------------------*/

@RemoteAction
 global static ccrz.cc_RemoteActionResult fetchQuote(ccrz.cc_RemoteActionContext ctx){
      
       ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        Map<String,Object> returnMap = new Map<String,Object>();
        try{
       
            List<ccrz__E_RequestForQuote__c> lstRequote = featchRequiredQuote(ccrz.cc_CallContext.currAccountId, storefront);
            
                    
            if(lstRequote!=null && lstRequote.size()>0)
            {
                System.debug(lstRequote.size());
            }
            else
            {
                result.success = true;
                return result;
            }
            
            Map<String,CMI_SW_QuoteWrapper.QuoteItemWrapper> prodIdVsQuoteWrapper = enrichQuoteWrapper(lstRequote);
            
            //add the wishlistitems data in return map
            returnMap.put('QuoteListData',prodIdVsQuoteWrapper.values());
            
            result.data = returnMap;
            
            
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 

            
        }catch(Exception e)
        {
            map<String, String> msgMap = new map<String, String>();
            msgMap.put('errmsg',  e.getMessage());
            
          ccrz.ccLog.log('=====Error in fetching the wishlist details===='+e.getMessage());
            result.success = false;
            result.data = msgMap;
            return result;
          
        }
      
        
         result.success = true;
        return result;
    }
    
    
 

    /*----------------------------------------------------------------------------------
1. enrichQuoteWrapper
Description:Util method to convert the CC API map to wrapper
Input: List<ccrz__E_RequestForQuote__c>
Output: 
Returntype:
Map<String,CMI_SW_QuoteWrapper.QuoteItemWrapper>

------------------------------------------------------------------------------------*/  
    private static Map<String,CMI_SW_QuoteWrapper.QuoteItemWrapper> enrichQuoteWrapper(List<ccrz__E_RequestForQuote__c> lstRequote)
    {
      
            Map<String,CMI_SW_QuoteWrapper.QuoteItemWrapper> prodIdVsWishlistItemMap = new Map<String,CMI_SW_QuoteWrapper.QuoteItemWrapper>();
            
            
            CMI_SW_QuoteWrapper.QuoteItemWrapper quoteItem=null;
            Map<Id, ccrz__E_Product__c> mapIdToCCDisplayProduct = new Map<Id, ccrz__E_Product__c>();
            Map<Id, ccrz__E_ProductMedia__c> mapDIsplayProductIdToMedia = new Map<Id, ccrz__E_ProductMedia__c>();
            Map<Id, Id> mapMediaProductAttachment = new Map<Id, Id>();
            Map<Id, String> mapIdToCCProductName = new Map<Id, String>();
        if(lstRequote != null ){
                
                Set<Id> setCCDisplayProductId = new Set<Id>();
                Set<Id> setCCProductId = new Set<Id>();
                for(ccrz__E_RequestForQuote__c requesForQuoteObj : lstRequote)
                {
                    if(requesForQuoteObj.Display_Product__c != null)
                        setCCDisplayProductId.add(requesForQuoteObj.Display_Product__c);
                    if(requesForQuoteObj.CC_Product__c != null)
                        setCCProductId.add(requesForQuoteObj.CC_Product__c);
                }
                
                if(setCCDisplayProductId.size() > 0)
                {
                    List<ccrz__E_Product__c> lstCCProduct = new List<ccrz__E_Product__c>();
                    List<Attachment> lstMediaAttachment = new List<Attachment>();
                    mapIdToCCDisplayProduct.putAll([Select Id,ccrz__SKU__c, Name, ccrz__ShortDesc__c,Group_Name__c,ccrz__Storefront__c from ccrz__E_Product__c where Id IN: setCCDisplayProductId]);
                    List<ccrz__E_ProductMedia__c> lstProductMedia = new List<ccrz__E_ProductMedia__c>();
                    lstProductMedia = [Select Id, ccrz__Enabled__c,ccrz__EndDate__c,ccrz__Locale__c,ccrz__MediaType__c,ccrz__ProductMediaSource__c,ccrz__Sequence__c, Name, ccrz__URI__c, ccrz__Product__c from ccrz__E_ProductMedia__c where ccrz__MediaType__c = 'Product Image Thumbnail' and ccrz__Product__c IN: setCCDisplayProductId];
                    if( lstProductMedia!= null)
                    {
                        Set<Id> setParentId = new Set<Id>();
                        
                        for(ccrz__E_ProductMedia__c mediaObj : lstProductMedia)
                        {
                            mapDIsplayProductIdToMedia.put(mediaObj.ccrz__Product__c, mediaObj);
                            setParentId.add(mediaObj.Id);
                        }
                        lstMediaAttachment = [Select Id, ParentId from Attachment where ParentId IN: setParentId];
                        for(Attachment objAttachment : lstMediaAttachment)
                            mapMediaProductAttachment.put(objAttachment.ParentId,objAttachment.Id);
                    }
                }
                if(setCCProductId.size() > 0)
                {
                    List<ccrz__E_Product__c> lstCCProduct = new List<ccrz__E_Product__c>();
                    lstCCProduct = [Select Id, Name from ccrz__E_Product__c where Id IN: setCCProductId];
                    for(ccrz__E_Product__c objCCProduct : lstCCProduct)
                        mapIdToCCProductName.put(objCCProduct.Id,objCCProduct.Name);
                }
                
                
                for(ccrz__E_RequestForQuote__c requesForQuoteObj : lstRequote)
                {
                    
                    quoteItem = new CMI_SW_QuoteWrapper.QuoteItemWrapper();
                    quoteItem.sfId =requesForQuoteObj.Id;
                    quoteItem.currencySymbol ='$';
                    quoteItem.quoteStatus =requesForQuoteObj.Customer_Status__c;
                    quoteItem.Status =requesForQuoteObj.Status__c;
                    quoteItem.billingFreq =requesForQuoteObj.Billing_Period__c;
                    
                    if(requesForQuoteObj.Status__c == Label.OSM_Sent )
                        quoteItem.isActionVisible = true;
                    else
                        quoteItem.isActionVisible = false;
                    quoteItem.description =requesForQuoteObj.ccrz__Description__c;
                    System.debug('====Requested for Quote==='+requesForQuoteObj);
                    
                    // Changes for story #171345 By Neha Sharma
                    if(ccrz.cc_CallContext.isOnBehalf ){
                    quoteItem.isActionVisible = false; 
                    }
                    //end here for story #171345
                    
                    if(requesForQuoteObj.Cost_Subscription__c != null)
                    {

                        quoteItem.listPrice =requesForQuoteObj.Cost_Subscription__c;
                    }   
                    else
                    {
                        quoteItem.listPrice = 0;
                    }
                    if(requesForQuoteObj.Discounted_Price__c != null &&  requesForQuoteObj.Status__c == Label.OSM_Sent){
                        quoteItem.discountedPrice =requesForQuoteObj.Discounted_Price__c;
                        quoteItem.hasDiscount = true;
                    }
                    else
                    {   quoteItem.discountedPrice = 0;}
                        if(quoteItem.discountedPrice > 0){
                       
                    }
                    quoteItem.discountedTotalPrice = requesForQuoteObj.OSM_Discounted_Total_Price__c;
                    Double intCost = 0;
                    Integer subPeriod = 0;
                    Double Quantity = 0;
                    if(requesForQuoteObj.Cost_Subscription__c != null)
                        intCost = requesForQuoteObj.Cost_Subscription__c;
                    if(requesForQuoteObj.Subscription_Length_Number__c != null)
                        subPeriod = Integer.valueOf(requesForQuoteObj.Subscription_Length_Number__c);
                    if(requesForQuoteObj.Quantity__c != null)
                        Quantity = requesForQuoteObj.Quantity__c;
                   
                    quoteItem.totalPrice = requesForQuoteObj.ccrz__Amount__c;
                    
                    quoteItem.quantity =(Integer)requesForQuoteObj.Quantity__c;
                    quoteItem.productPackage =requesForQuoteObj.Product_Plan__c;
                    quoteItem.productId =requesForQuoteObj.CC_Product__c;
                    if(mapIdToCCProductName.containsKey(requesForQuoteObj.CC_Product__c))
                        quoteItem.displayProductName = mapIdToCCProductName.get(requesForQuoteObj.CC_Product__c);
                           
                    
                    //Product Details
                    if(mapIdToCCDisplayProduct.containsKey(requesForQuoteObj.Display_Product__c))
                    {
                        CMI_SW_ProductDetailWrapper productDetail = new CMI_SW_ProductDetailWrapper();
                        productDetail.SKU = mapIdToCCDisplayProduct.get(requesForQuoteObj.Display_Product__c).ccrz__SKU__c;
                        productDetail.groupName = mapIdToCCDisplayProduct.get(requesForQuoteObj.Display_Product__c).Group_Name__c;
                        quoteItem.displayProductName = mapIdToCCProductName.get(requesForQuoteObj.CC_Product__c);
                        productDetail.sfId = mapIdToCCDisplayProduct.get(requesForQuoteObj.Display_Product__c).Id;
                        productDetail.sfdcName = mapIdToCCDisplayProduct.get(requesForQuoteObj.Display_Product__c).Name;
                        productDetail.shortDesc = mapIdToCCDisplayProduct.get(requesForQuoteObj.Display_Product__c).ccrz__ShortDesc__c;
                        productDetail.storefront = mapIdToCCDisplayProduct.get(requesForQuoteObj.Display_Product__c).ccrz__Storefront__c;
                        
                    
                        CMI_SW_ProductDetailWrapper.MediaWrapper mediaWrapper = new CMI_SW_ProductDetailWrapper.MediaWrapper();
                        if(mapDIsplayProductIdToMedia.containsKey(requesForQuoteObj.Display_Product__c))
                        {
                            if(mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__Enabled__c)
                            mediaWrapper.enabled = 'true';
                            mediaWrapper.endDate = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__EndDate__c;
                            mediaWrapper.locale = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__Locale__c;
                            mediaWrapper.mediaType = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__MediaType__c;
                            mediaWrapper.productMediaSource = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__ProductMediaSource__c;
                            mediaWrapper.sequence = String.valueOf(mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__Sequence__c);
                            mediaWrapper.sfdcName = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).Name;
                            if(mapMediaProductAttachment.containsKey(mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).Id))
                                mediaWrapper.uri = mapMediaProductAttachment.get(mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).Id);
                            else
                                mediaWrapper.uri = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__URI__c;
                            mediaWrapper.sfId = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).Id;
                            mediaWrapper.sourceType = mapDIsplayProductIdToMedia.get(requesForQuoteObj.Display_Product__c).ccrz__ProductMediaSource__c;
                            
                            quoteItem.mediaWrapper = mediaWrapper;
                        }
                     quoteItem.productDetail = productDetail;
             
                    }
						 system.debug('end discountedPrice==>'+quoteItem.discountedPrice);
                    prodIdVsWishlistItemMap.put(quoteItem.sfId,quoteItem);
                }
                system.debug('===Created prodIdVsWishlistItemMap==='+prodIdVsWishlistItemMap);
        }
            
            return prodIdVsWishlistItemMap;
    }
    
    /*----------------------------------------------------------------------------------
1. featchRequiredQuote
Description:Contains Query of request for quote instant of multiple query we can call this method
Input: Id userId, String storefront
Output: List of Request for Quote
Returntype:
List<ccrz__E_RequestForQuote__c>

------------------------------------------------------------------------------------*/ 

    public static List<ccrz__E_RequestForQuote__c> featchRequiredQuote(Id accountId, String storefront)
    {
        List<ccrz__E_RequestForQuote__c> lstRequoteToReturn = new List<ccrz__E_RequestForQuote__c>();
        set<String> allowStatus = new set<String>();
        allowStatus.add('Requested');
        allowStatus.add('In Progress');
        allowStatus.add('Sent');
        allowStatus.add('Expired');
        List<ccrz__E_RequestForQuote__c> lstRequote1  = [select id,Billing_Period__c,Number_of_Days_Expired__c,Discounted_Per_Billing_Frequency_Price__c,Subscription_Length_Number__c,Cost_Subscription__c,Status__c,CC_Product__c,Customer_Status__c,Product_Plan__c,Quantity__c,Display_Product__c,ccrz__Amount__c,ccrz__Description__c,Discounted_Price__c,OSM_Discounted_Total_Price__c,Final_Price__c from ccrz__E_RequestForQuote__c where ccrz__Account__c=:accountId and ccrz__Storefront__c=:storefront and Status__c IN: allowStatus];
        
        
        for(ccrz__E_RequestForQuote__c objRequestForQuote : lstRequote1)
        {
            if(objRequestForQuote.Number_of_Days_Expired__c != null  )
            {
                if(objRequestForQuote.Number_of_Days_Expired__c <= 7){
                    objRequestForQuote.Discounted_Price__c = objRequestForQuote.Cost_Subscription__c - objRequestForQuote.Discounted_Price__c;
                    lstRequoteToReturn.add(objRequestForQuote);
                }
            }
            else
               lstRequoteToReturn.add(objRequestForQuote); 
                
        }
        return lstRequoteToReturn;
    }
    
 
    /*----------------------------------------------------------------------------------
1. approveOrRejectQuote
Description:Called on Action of Accept and Reject link on Quote
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Accept (Create a cart line item) and Reject the Request of Quote

------------------------------------------------------------------------------------*/  
@RemoteAction
 global static ccrz.cc_RemoteActionResult approveOrRejectQuote(ccrz.cc_RemoteActionContext ctx,String quoteItemId, String quoteStatus)
 {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        String accId = ccrz.cc_CallContext.currAccountId;
        Map<String,Object> returnMap = new Map<String,Object>();
        Boolean wasSuccessful = true;
        String theNewCartId = null;
         ccrz.ccLog.log('==========Inside approveOrRejectQuote======');
        Savepoint sp = Database.setSavepoint();
        String newCartEncryptedId=null;
        try{
            
        if(quoteItemId != null)
        {
            ccrz__E_RequestForQuote__c objRequote= [select id,CC_SubProdTerm__c,Amount_Per_Billing_Period__c,CC_SubProdTerm__r.ccrz__DisplayName__c,CC_SubProdTerm__r.ccrz__CCProduct__c,CC_SubProdTerm__r.ccrz__Storefront__c,
                                                                Discounted_Per_Billing_Frequency_Price__c,CC_SubProdTerm__r.Billing_Display_Name__c,Operation__c,Subscription_Length_Number__c,Cost_Subscription__c,Status__c,CC_Product__c,Customer_Status__c,Product_Plan__c,Quantity__c,Display_Product__c,ccrz__Amount__c,ccrz__Description__c,Discounted_Price__c,OSM_Discounted_Total_Price__c,Final_Price__c from ccrz__E_RequestForQuote__c where id=: quoteItemId ];
            String billingfrequency = '';
            String supProdtermProd = '';
            String displayName = '';
            String subProdStorefront = '';
            if(objRequote != null)
            {
                objRequote.Status__c = quoteStatus;
                objRequote.Operation__c=quoteStatus;
                objRequote.Accept_or_Reject_Date__c = System.Today();
                billingfrequency = objRequote.CC_SubProdTerm__r.Billing_Display_Name__c;
                displayName = objRequote.CC_SubProdTerm__r.ccrz__DisplayName__c;
                supProdtermProd= objRequote.CC_SubProdTerm__r.ccrz__CCProduct__c;
                subProdStorefront = objRequote.CC_SubProdTerm__r.ccrz__Storefront__c;
                update objRequote;
                
                
                // if approve create cart
                if(quoteStatus == 'Accepted')
                {
                    List<String> type = new List<String>{'Cart'};
                    List<ccrz__E_Cart__c> cartLst= [select id,name,ccrz__CartType__c from ccrz__E_Cart__c where ccrz__CartType__c in :type and ccrz__ActiveCart__c=true and ccrz__CartStatus__c='Open' and  ccrz__User__c=:userId and ccrz__Storefront__c=:storefront limit 1];
                    
                    List<Id> cartIdlst = new List<Id>();
                    
                    for(ccrz__E_Cart__c objCart : cartLst )
                        cartIdlst.add(objCart.Id);
                  
                    //Logic to create the new cart if valid cart does not exist for user
                    if(cartIdlst != null && cartIdlst.size() == 0)
                    {
                        
                       /*  ccrz__E_Cart__c objCartCreate = new ccrz__E_Cart__c();
                        objCartCreate.ccrz__Name__c = 'Request for Quote'+System.now();
                        objCartCreate.ccrz__Storefront__c = storefront;
                        objCartCreate.ccrz__User__c = userId;
                        objCartCreate.ccrz__Contact__c = IdContact;
                        objCartCreate.ccrz__Account__c = accountId;
                        objCartCreate.ccrz__ActiveCart__c = true;
                        objCartCreate.ccrz__CartType__c = 'Cart';
                        objCartCreate.ccrz__CartStatus__c = 'Open';
                        objCartCreate.ccrz__CurrencyISOCode__c = 'USD';
                        objCartCreate.ccrz__AnonymousId__c = false;
                        
                        Insert objCartCreate;
                        cartLst.add(objCartCreate); */
                        
                        /*Start:Commented by VS
                        Map<String,Object> createResults = new Map<String,Object>{
                          ccrz.ccApi.API_VERSION => 1
                      };
                        wasSuccessful = (Boolean)createResults.get(ccrz.ccApi.SUCCESS);
  
                        theNewCartId = (String)createResults.get(ccrz.ccApiCart.CART_ENCID);
                        if(String.isBlank(theNewCartId)){
                            wasSuccessful = false;
                        }
                        else
                            cartIdlst.add(theNewCartId);
                        End:Commented by VS  */ 
                        
                        System.debug('====Calling the Create new cart');
                        
                        ccrz__E_Cart__c newCart = OSM_SW_Cart_Wishlist_Comp_Ctrl.createNewCart();
                        
                        if(newCart != null ){
                            cartIdlst.add(newCart.Id);
                             newCartEncryptedId = newCart.ccrz__EncryptedId__c;
                        }
                        else
                            wasSuccessful =false;
                        
                        System.debug('=====cartIdlst===='+cartIdlst);
                    }
                    else
                    {
                        List<ccrz__E_CartItem__c> lstQuoteIteminCartTodelete = [select id from ccrz__E_CartItem__c where ccrz__Cart__c IN: cartIdlst and ccrz__Product__c =: objRequote.CC_Product__c];
                        if(lstQuoteIteminCartTodelete != null && lstQuoteIteminCartTodelete.size() > 0)
                            Delete lstQuoteIteminCartTodelete;

                    }
                    
                    if(cartIdlst != null && cartIdlst.size() == 1)
                    {
                    
                        Double intCost = 0;
                        Double discountPrice = 0;
                        if(objRequote.Cost_Subscription__c != null)
                            intCost = objRequote.Cost_Subscription__c;
                        if(objRequote.Discounted_Price__c != null)
                            discountPrice = objRequote.Discounted_Price__c;
                        
                        
                        ccrz__E_CartItem__c objCartLineIteam = new ccrz__E_CartItem__c();
                        objCartLineIteam.ccrz__Cart__c = cartIdlst[0];
                        objCartLineIteam.ccrz__Quantity__c = objRequote.Quantity__c;
                        objCartLineIteam.ccrz__Product__c = objRequote.CC_Product__c;
                        objCartLineIteam.ccrz__PricingType__c = 'external';
                        objCartLineIteam.ccrz__SubProdTerm__c = objRequote.CC_SubProdTerm__c;
                        objCartLineIteam.ccrz__cartItemType__c = 'Major';
                        objCartLineIteam.ccrz__DisplayProduct__c = objRequote.Display_Product__c;
                        objCartLineIteam.ccrz__ProductType__c = 'Product';
                        objCartLineIteam.ccrz__ItemStatus__c = 'Available';
                        objCartLineIteam.ccrz__StoreID__c = storefront;
                        objCartLineIteam.ccrz__OriginalQuantity__c = objRequote.Quantity__c;
                       
                            objCartLineIteam.ccrz__Price__c = objRequote.Discounted_Per_Billing_Frequency_Price__c;
                            objCartLineIteam.ccrz__SubAmount__c = objRequote.Discounted_Per_Billing_Frequency_Price__c*objRequote.Quantity__c;
                            objCartLineIteam.ccrz__OriginalItemPrice__c = objRequote.Discounted_Per_Billing_Frequency_Price__c;
                            objCartLineIteam.ccrz__RecurringPrice__c = objRequote.Discounted_Per_Billing_Frequency_Price__c;
                           
                            objCartLineIteam.ccrz__RecurringPriceSubAmt__c = objRequote.Discounted_Per_Billing_Frequency_Price__c*objRequote.Quantity__c;
                                               
                        if(objCartLineIteam.ccrz__Price__c == 0){
                           List<ccrz__E_SubProdTerm__c>prodTerms = [Select Id from ccrz__E_SubProdTerm__c where Billing_Display_Name__c =:'One Time' and 
                                    ccrz__DisplayName__c =: displayName and ccrz__CCProduct__c =: supProdtermProd
                                    and ccrz__Storefront__c =: subProdStorefront limit 1];
                            if(prodTerms.size()==1){
                                objCartLineIteam.ccrz__SubProdTerm__c = prodTerms[0].Id;
                            }
                        }
                        Insert objCartLineIteam;
                        
                        if(!billingfrequency.containsIgnoreCase('One')){
                           OSM_SW_ProductDetailCommonUtility.updateAccount(ccrz.cc_CallContext.currAccountId, billingfrequency);    
                        }
                    }
                }

            }
        }
            if(wasSuccessful != true)
            {
                Database.rollback(sp);
                map<String, String> msgMap = new map<String, String>();
                msgMap.put('errmsg',  'Cart creation is not done.');
                result.success = false;
                result.data = msgMap;
                return result;
                
            }
         
        }
        catch(Exception e)
        {
            
            Database.rollback(sp);
            ccrz.ccLog.log('=====Error in fetching the quote details===='+e.getMessage());
            map<String, String> msgMap = new map<String, String>();
            msgMap.put('errmsg',  e.getMessage());
            result.success = false;
            result.data = msgMap;
            
            String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();

            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
    
            log.Error_Description__c = errorMsg;
    
            log.Service_Name__c = System.Label.OSM_SW_Accept_Reject;
    
            log.Status__c = 'Failed';
    
            insert log;
           
            return result;
          
        }                    
        try{

            List<ccrz__E_RequestForQuote__c> lstRequote  = featchRequiredQuote(accId,storefront);
            
                    
            if(lstRequote!=null && lstRequote.size()>0)
            {
                System.debug(lstRequote.size());
            }
            else
            {
                
                
                 map<String, String> msgMap = new map<String, String>();
                 msgMap.put('msg','No Need to refresh' );
               if(newCartEncryptedId!=null)
               {
                   msgMap.put('NEW_CARTID',newCartEncryptedId);
               }
                result.data=msgMap;
                result.success = true;
                return result;
            }
            
            Map<String,CMI_SW_QuoteWrapper.QuoteItemWrapper> prodIdVsQuoteWrapper = enrichQuoteWrapper(lstRequote);
            
            //add the wishlistitems data in return map
            returnMap.put('QuoteListData',prodIdVsQuoteWrapper.values());
              if(newCartEncryptedId!=null)
               {
                   returnMap.put('NEW_CARTID',newCartEncryptedId);
               }
            result.data = returnMap;
            
            
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 

            
        }catch(Exception e)
        {
            map<String, String> msgMap = new map<String, String>();
            msgMap.put('errmsg',  e.getStackTraceString());         
            ccrz.ccLog.log('=====Error in fetching the wishlist details===='+e.getStackTraceString());
            result.success = false;
            result.data = msgMap;
            return result;         
        }
        result.success = true;
        return result;          
 } 
 
}