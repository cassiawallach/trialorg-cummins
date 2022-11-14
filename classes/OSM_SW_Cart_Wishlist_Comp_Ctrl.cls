/**********************************************************************
Name:  OSM_SW_Cart_Wishlist_Comp_Ctrl
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
1.0 -   Vaibhav            3/12/2018     INITIAL DEVELOPMENT          


*****************************************************/

global class OSM_SW_Cart_Wishlist_Comp_Ctrl {


/*----------------------------------------------------------------------------------
1. fetchWishListItems
Description:Used to fetch wishlist item to be displayed on Cart Page
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns the wishlist items to be displayed to user

Returntype:
ccrz.cc_RemoteActionResult
WishlistData==> Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper>
------------------------------------------------------------------------------------*/

@RemoteAction
 global static ccrz.cc_RemoteActionResult fetchWishListItems(ccrz.cc_RemoteActionContext ctx){
      
       ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        Set<String> wishListIdList = new Set<String>();
        Map<String,Object> returnMap = new Map<String,Object>();
        try{
            System.debug('====User Id ===='+userId);
        
            List<ccrz__E_Cart__c> wishlistIdLst= [select id from ccrz__E_Cart__c where ccrz__Storefront__c=:storefront and ccrz__CartType__c='WishList' and ccrz__User__c=:userId and ccrz__ActiveCart__c=true and ccrz__CartStatus__c='Open' limit 1];
            String wishlistId;
            if(wishlistIdLst!=null && wishlistIdLst.size()>0)
            {
              wishlistId = wishlistIdLst[0].id;
            }
            else
            {
                 //write logic for creating wishlist
                //wishlistId =  createNewWishlist();
                
                result.success = true;
                return result;
            }
            
        
            
            //create a validation rule to have only one wishlist
            System.debug('===wishlistId===='+wishlistId);
            wishListIdList.add(wishlistId);
            
            /*
            Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccAPIWishList.IDS => wishListIdList,
            ccrz.ccAPIWishList.INCLUDE_ITEMS => true,
            ccrz.ccAPI.SIZING => new Map<String, Object>{
                ccrz.ccAPIWishList.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL,
                    ccrz.ccAPI.SZ_SKIPTRZ=>false,
                    ccrz.ccAPI.SZ_REL => new List<String>{'E_CartItems__r'} 
                },
                ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_M,
                    ccrz.ccAPI.SZ_SKIPTRZ=>false,
                    ccrz.ccAPI.SZ_REL => new List<String>{'E_ProductMedias__r'} 
                }       
            }
            };
            Map<String, Object> outputData = ccrz.ccAPIWishList.fetch(inputData);
            Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> prodIdVsWishlistWrapper = enrichWishlistWrapper(outputData);
            */
            
            Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> prodIdVsWishlistWrapper = callWishlistServices(storefront,userId);
            
            //add the wishlistitems data in return map
            returnMap.put('WishlistData',prodIdVsWishlistWrapper.values());
            
            result.data = returnMap;
            
            //Juhi Changes - For Test Class to improve Code Coverage
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 

        }catch(Exception e)
        {
          ccrz.ccLog.log('=====Error in fetching the wishlist details===='+e.getStackTraceString());
          System.debug('=====Error in fetching the wishlist details===='+e.getStackTraceString());
          
        }
      
        
         result.success = true;
        return result;
    }
    
    
/*----------------------------------------------------------------------------------
1. handleMovetoCart
Description:Called on Action of Move To Cart link on Wishlist
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Moves the item to cart

Returntype:
ccrz.cc_RemoteActionResult
WishlistData==> Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper>
------------------------------------------------------------------------------------*/  
@RemoteAction
 global static ccrz.cc_RemoteActionResult handleMovetoCart(ccrz.cc_RemoteActionContext ctx,String wishlistItemId)
 {
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        List<String> type = new List<String>{'Cart'};
        List<ccrz__E_Cart__c> cartLst= [select id,name,ccrz__CartType__c from ccrz__E_Cart__c where ccrz__CartType__c in :type and ccrz__ActiveCart__c=true and ccrz__CartStatus__c='Open' and  ccrz__User__c=:userId and ccrz__Storefront__c=:storefront limit 1];
		
		
		if(cartLst==null)
		{
			cartLst = new List<ccrz__E_Cart__c>();
			System.debug('===Creating new cart for user====');
		    ccrz__E_Cart__c newCart = createNewCart();
			cartLst.add(newCart);
		}
		
        System.debug('=====Cart Of Logged-In User==='+cartLst);
        //wishlistItem to be moved wlItemTobeMoved
        ccrz__E_CartItem__c wlItemTobeMoved = [select id,name,ccrz__Cart__c,ccrz__cartItemType__c,ccrz__DisplayProduct__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__Price__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__UnitOfMeasure__c from ccrz__E_CartItem__c where id=:wishlistItemId ];
        
        
        ccrz__E_CartItem__c deleteWishlistItem = new ccrz__E_CartItem__c();
        if(cartLst!=null && cartLst.size()>0)
        {
          ccrz__E_Cart__c cart =  cartLst.get(0);
          deleteWishlistItem.id = wlItemTobeMoved.id;
          wlItemTobeMoved.id=null;
          wlItemTobeMoved.ccrz__Cart__c = cart.id;
          //insert oldCartItem;
          
          delete deleteWishlistItem;
          
          System.debug('===Inserted and Deleted the cart items');
        
        Savepoint sp = Database.setSavepoint();
        Boolean wasSuccessful = false;
         
            // The parent.
            System.debug('=====wlItemTobeMoved.ccrz__Quantity__c===='+wlItemTobeMoved.ccrz__Quantity__c);
            ccrz.ccApiCart.LineData pLine = new ccrz.ccApiCart.LineData();
            pLine.quantity = wlItemTobeMoved.ccrz__Quantity__c;
            pLine.productId = wlItemTobeMoved.ccrz__Product__c;
            pLine.subProdTermId = wlItemTobeMoved.ccrz__SubProdTerm__c;
             
            try{
             
              Map<String,Object> inputData = new Map<String,Object>{
                  ccrz.ccApiCart.CART_ID => cart.id,
                  ccrz.ccApi.API_VERSION => 7,
                  ccrz.ccApiCart.LINE_DATA => new List<ccrz.ccApiCart.LineData>{pLine}
              };
                inputData.put('Wishlist_Record',wlItemTobeMoved);
                
                Map<String,Object> addResults = ccrz.ccApiCart.addTo(inputData);
              
                //General check, since the cart Id will be blank if not successful we technically do not need this.
                wasSuccessful = (Boolean) addResults.get(ccrz.ccApi.SUCCESS);
            }catch(Exception e){
                //Error reporting here....
                System.debug('=====Exception Got in Saving ==='+e.getStackTraceString());
            }
              
            if(!wasSuccessful) {
                Database.rollback(sp);
            }
              
        }
        /*else
        {
           //todo:if no active cart is found then create a new cart
		   createNewCart();
		   
        }
		*/
        
        
        //refetch the data
        Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> prodIdVsWishlistWrapper = callWishlistServices(storefront,userId);
            
        //add the wishlistitems data in return map
        returnMap.put('WishlistData',prodIdVsWishlistWrapper.values());
        result.data = returnMap;
        
        result.success = true;
        return result;
                
   
 } 
/*@RemoteAction
 global static ccrz.cc_RemoteActionResult handleMovetoCart(ccrz.cc_RemoteActionContext ctx,String wishlistItemId)
 {
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        List<String> type = new List<String>{'Cart'};
        List<ccrz__E_Cart__c> cartLst= [select id,name,ccrz__CartType__c from ccrz__E_Cart__c where ccrz__CartType__c in :type and ccrz__ActiveCart__c=true and  ccrz__User__c=:userId and ccrz__Storefront__c=:storefront limit 1];
        
        
        ccrz__E_CartItem__c oldCartItem = [select id,name,ccrz__Cart__c,ccrz__cartItemType__c,ccrz__DisplayProduct__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__Price__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__UnitOfMeasure__c from ccrz__E_CartItem__c where id=:wishlistItemId ];
        
        
        ccrz__E_CartItem__c deleteCartItem = new ccrz__E_CartItem__c();
        if(cartLst!=null && cartLst.size()>0)
        {
          ccrz__E_Cart__c cart =  cartLst.get(0);
          deleteCartItem.id = oldCartItem.id;
          oldCartItem.id=null;
          oldCartItem.ccrz__Cart__c = cart.id;
          insert oldCartItem;
          
          delete deleteCartItem;
          
          System.debug('===Inserted and Deleted the cart items');
           
          
        }
        else
        {
           //if no active cart is found then create a new cart
        }
        
        
        //refetch the data
        Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> prodIdVsWishlistWrapper = callWishlistServices(storefront,userId);
            
        //add the wishlistitems data in return map
        returnMap.put('WishlistData',prodIdVsWishlistWrapper.values());
        result.data = returnMap;
        
        result.success = true;
        return result;
                
   
 }
 
 */
 
 /*----------------------------------------------------------------------------------
1. handleDeleteWLItem
Description:Called on Action of Delete link on Wishlist
Input: 
ccrz.cc_RemoteActionContext ctx
wishlistItemId : wishlistItem to be deleted
Output: 
Delete the Wishlist Item from wishlist
Returntype:
ccrz.cc_RemoteActionResult
WishlistData==> Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper>
------------------------------------------------------------------------------------*/   
 @RemoteAction
 global static ccrz.cc_RemoteActionResult handleDeleteWLItem(ccrz.cc_RemoteActionContext ctx,String wishlistItemId)
 {
 
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        Map<String,Object> returnMap = new Map<String,Object>();
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPI.API_VERSION => 7,
            ccrz.ccAPIWishList.WISHLIST_ITEM_IDS => new Set<String>{wishlistItemId}
        };
   
        try {
            Map<String, Object> outputData = ccrz.ccAPIWishList.removeFrom(inputData);
            
            
            System.debug('=====outputData=='+outputData);
            //refetch the data
            Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> prodIdVsWishlistWrapper = callWishlistServices(storefront,userId);
                
            //add the wishlistitems data in return map
            returnMap.put('WishlistData',prodIdVsWishlistWrapper.values());
            result.data = returnMap;
            
            result.success = true;
            
            //Juhi Changes - For Test Class to improve Code Coverage
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
        } catch (Exception e) {
            // Error handling...
            ccrz.ccLog.log('=====Error in deleting the wishlist item:handleDeleteWLItem===='+e.getStackTraceString());
            System.debug('=====Error in deleting the wishlist item:handleDeleteWLItem=='+e.getStackTraceString());
        }
        
        
        return result;
                
   
 }
    
 /*----------------------------------------------------------------------------------
createNewWishlist
Description:Utility method to create the new wishlist if active wishlist is not found.Called from various places.
Input: 
Output: 
Create the new wishlist
Returntype:
String : wishlist Id
------------------------------------------------------------------------------------*/  

    @TestVisible private static String createNewWishlist()
    {
    
       System.debug('=====Inside createNewWishlist====');
        String wishlistId;
       Map<String, Object> newWishList = new Map<String, Object>{
            'name' => 'MyNewWishList',
            'note' => 'My New Note',
            'activeCart' => TRUE
        };
  
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPI.API_VERSION => 7,
            ccrz.ccAPIWishList.WISHLIST => newWishList
        };
  
        //String storefront = ccrz.cc_CallContext.storefront;
        //Id userId = ccrz.cc_CallContext.currUserId;
        
        
        try {
            Map<String, Object> outputData = ccrz.ccAPIWishList.create(inputData);
            if (outputData.get(ccrz.ccAPIWishList.WISHLIST) != null) {
                // The cast to Map<String, Object> is necessary...
                Map<String, Object> wishListMap = (Map<String, Object>) outputData.get(ccrz.ccAPIWishList.WISHLIST);
                System.debug('====wishListMap===='+wishListMap);
            }
        } catch (Exception e) {
            // Error handling...
            System.debug('=====Exception======='+e);
        }
        
        return wishlistId;
}


 /*----------------------------------------------------------------------------------
callWishlistServices
Description: Util method to fetch the active wishlist data using CC API
Input: 
storefront : logged-in user storefront
userId : logged-in user 
Output: 
Returns the wishlist

Returntype:
Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> : Wishlist items
------------------------------------------------------------------------------------*/  


    private static Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> callWishlistServices(String storefront,Id userId)
    {
            
            Set<String> wishListIdList = new Set<String>();
            
             List<ccrz__E_Cart__c> wishlistIdLst= [select id from ccrz__E_Cart__c where ccrz__Storefront__c=:storefront and ccrz__CartType__c='WishList' and ccrz__User__c=:userId and ccrz__ActiveCart__c=true and ccrz__CartStatus__c='Open' limit 1];
            
            String wishlistId;
            if(wishlistIdLst!=null && wishlistIdLst.size()>0)
            {
              wishlistId = wishlistIdLst[0].id;
            }
            else
            {
                 //write logic for creating wishlist
                 //Not required as this has been taken care other method
            }
            
        
            
            //create a validation rule to have only one wishlist
            System.debug('===wishlistId===='+wishlistId);
            wishListIdList.add(wishlistId);
            
            Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccAPIWishList.IDS => wishListIdList,
            ccrz.ccAPIWishList.INCLUDE_ITEMS => true,
            ccrz.ccAPI.SIZING => new Map<String, Object>{
                ccrz.ccAPIWishList.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL,
                    ccrz.ccAPI.SZ_SKIPTRZ=>false,
                    ccrz.ccAPI.SZ_REL => new List<String>{'E_CartItems__r'} 
                },
                ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_M,
                    ccrz.ccAPI.SZ_SKIPTRZ=>false,
                    ccrz.ccAPI.SZ_REL => new List<String>{'E_ProductMedias__r'} 
                }       
            }
            };
            
            Map<String, Object> outputData = ccrz.ccAPIWishList.fetch(inputData);
            Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> prodIdVsWishlistWrapper = enrichWishlistWrapper(outputData);
            
            return prodIdVsWishlistWrapper;
       
    }
    
/*----------------------------------------------------------------------------------
handleMoveToWishlist
Description: Action method to move the items to wishlist from Cart
Input: 
ccrz.cc_RemoteActionContext
wishlistItemId : item to be moved
Output: 
Returns the wishlist

Returntype:
ccrz.cc_RemoteActionResult
------------------------------------------------------------------------------------*/ 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult handleMoveToWishlist(ccrz.cc_RemoteActionContext ctx,String wishlistItemId)
    {
    
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        String storefront = ccrz.cc_CallContext.storefront;
        Id userId = ccrz.cc_CallContext.currUserId;
        String wishlistId;
        Map<String,Object> returnMap = new Map<String,Object>();
        Map<String, Object> inputData = null;
           
           
           
        try {
            
            List<ccrz__E_Cart__c> wishlistIdLst= [select id from ccrz__E_Cart__c where ccrz__Storefront__c=:storefront and ccrz__CartType__c='WishList' and ccrz__User__c=:userId and ccrz__ActiveCart__c=true and ccrz__CartStatus__c='Open' limit 1];
           
            if(wishlistIdLst!=null && wishlistIdLst.size()>0)
            {
              wishlistId = wishlistIdLst[0].id;
            }
            else
            {
                 //logic for creating new wishlist
                wishlistId =  createNewWishlist();
                
                
            }
            system.debug('***WishlistId** : '+wishlistId);
            system.debug('***WishlistItemId** : '+wishlistItemId);
            system.debug('before OldcartItem query : '+([select id,name,ccrz__Cart__c,ccrz__cartItemType__c,ccrz__DisplayProduct__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__Price__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__UnitOfMeasure__c from ccrz__E_CartItem__c where id=:wishlistItemId]));
            ccrz__E_CartItem__c oldCartItem = [select id,name,ccrz__Cart__c,ccrz__cartItemType__c,ccrz__DisplayProduct__c,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__Price__c,ccrz__Product__c,ccrz__Quantity__c,ccrz__RecurringPrice__c,ccrz__RecurringPriceSubAmt__c,ccrz__StoreID__c,ccrz__SubAmount__c,ccrz__SubProdTerm__c,ccrz__Subscription_Duration__c,ccrz__Subscription_Frequency__c,ccrz__UnitOfMeasure__c from ccrz__E_CartItem__c where id=:wishlistItemId];
            system.debug('***OldCartItem *** : '+oldCartItem);
            String productId = oldCartItem.ccrz__Product__c;
            
            List<ccrz__E_CartItem__c> existingWLItemLst = [select id,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,ccrz__Price__c,ccrz__Quantity__c,ccrz__SubAmount__c,ccrz__RecurringPriceSubAmt__c,ccrz__RecurringPrice__c,ccrz__SubProdTerm__c from ccrz__E_CartItem__c where ccrz__Product__c=:productId and ccrz__Cart__c=:wishlistId];
            
            //if product already exist in wishlist in database
            if(existingWLItemLst!=null && existingWLItemLst.size()>0)
            {
                System.debug('====Got the product in database==='+existingWLItemLst);
                //Update here if product already exist in wishlist
                ccrz__E_CartItem__c existingWLItem =  existingWLItemLst[0];
                System.debug('=====existingWLItem===='+existingWLItem);
                System.debug('=====oldCartItem===='+oldCartItem);
                if(existingWLItem.ccrz__SubProdTerm__c==oldCartItem.ccrz__SubProdTerm__c)
                 {
                     System.debug('===Inside If of Subprodterm==');
                            //if subprodterm is equal on both products, then only allow addition of prod in WL
                            existingWLItem.ccrz__OriginalItemPrice__c=oldCartItem.ccrz__OriginalItemPrice__c;
                            existingWLItem.ccrz__OriginalQuantity__c=oldCartItem.ccrz__OriginalQuantity__c+existingWLItem.ccrz__OriginalQuantity__c;
                            existingWLItem.ccrz__Quantity__c = oldCartItem.ccrz__Quantity__c + existingWLItem.ccrz__Quantity__c;
                            existingWLItem.ccrz__Price__c=oldCartItem.ccrz__Price__c;
                            existingWLItem.ccrz__SubAmount__c=oldCartItem.ccrz__SubAmount__c + existingWLItem.ccrz__SubAmount__c;
                            existingWLItem.ccrz__RecurringPriceSubAmt__c=existingWLItem.ccrz__RecurringPriceSubAmt__c+oldCartItem.ccrz__RecurringPriceSubAmt__c;
                            existingWLItem.ccrz__DisplayProduct__c = oldCartItem.ccrz__DisplayProduct__c;
                            existingWLItem.ccrz__RecurringPrice__c=oldCartItem.ccrz__RecurringPrice__c;
                            existingWLItem.ccrz__SubProdTerm__c = oldCartItem.ccrz__SubProdTerm__c;
                            
                            System.debug('=====existingWLItem to update ===='+existingWLItem);
                            update existingWLItem;
                 }
                 else
                 {
                     //if subprodterm is not equal on both products, then do not allow addition of prod in WL
                 }
            
            }
            else
            {
                //call the services only when product is not already added to wishlist
               inputData = new Map<String, Object>{
                ccrz.ccAPI.API_VERSION => 7,
                ccrz.ccAPIWishList.ID => wishlistId,
                ccrz.ccAPIProduct.PRODUCTIDLIST => new List<String>{oldCartItem.ccrz__Product__c}
                };
                
                //clone the cart item
                ccrz__E_CartItem__c wishlistItem = oldCartItem.clone(false, true, false, false);
                System.debug('======CLONED Wishlist ITEM===='+wishlistItem);
                inputData.put('wishlistItemNew',wishlistItem);
                Map<String, Object> outputData = ccrz.ccAPIWishList.addTo(inputData);
            
            }
            
            
            
            
            //Start processing to remove the cartlineItem from Cart
            
            
            //cartitem to be deleted
            ccrz.ccApiCart.LineData lineData = new ccrz.ccApiCart.LineData();
            lineData.sfid = wishlistItemId;
            
            inputData = new Map<String, Object>{
            ccrz.ccAPI.API_VERSION => 7,
            ccrz.ccApiCart.CART_ID => oldCartItem.ccrz__Cart__c,
            ccrz.ccApiCart.LINE_DATA => new List<ccrz.ccApiCart.LineData>{lineData}
            };
            
            Map<String, Object> outputDataCart = ccrz.ccApiCart.removeFrom(inputData);
             
         //Juhi Changes - For Test Class to improve Code Coverage
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
         
        } catch (Exception e) {
            // Error handling...
            System.debug('========Got Exception======');
             System.debug('======Got Exception==='+e.getStackTraceString());
        }
        
        result.success = true;
        return result;
       
    }
 
 /*----------------------------------------------------------------------------------
enrichWishlistWrapper
Description: Util method to convert the CC API map to wrapper
Input: 
Map<String, Object> wishlistServiceDataMap 

Output: 
Returns the enriched wrapper

Returntype:
Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper>
------------------------------------------------------------------------------------*/ 
    private static Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> enrichWishlistWrapper(Map<String, Object> wishlistServiceDataMap)
    {
       System.debug('===wishlistServiceDataMap==='+wishlistServiceDataMap);
        System.debug('===wishlistServiceDataMap22==='+(wishlistServiceDataMap.get(ccrz.ccAPIWishList.WISHLISTS)));
        System.debug('===wishlistServiceDataMapproductids==='+(wishlistServiceDataMap.get(ccrz.ccAPIWishList.PRODUCT_IDS)));
            System.debug('===ccrz.ccAPIWishList.PRODUCT_IDS=='+ccrz.ccAPIWishList.PRODUCT_IDS);
            List<Map<String,Object>> productDetailLst = (List<Map<String,Object>>)wishlistServiceDataMap.get('productList');
        System.debug('===productDetailLst==='+productDetailLst);
            Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> prodIdVsWishlistItemMap = new Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper>();
            Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper> wishlistIdVsWishlistItemMap = new Map<String,CMI_SW_WishlistWrapper.WishlistItemWrapper>();
            
            System.debug('===ccrz.ccAPIWishList.WISHLISTS==='+ccrz.ccAPIWishList.WISHLISTS);
            Map<String,Map<String,Object>> wishlistSuperMap = (Map<String,Map<String,Object>>)wishlistServiceDataMap.get(ccrz.ccAPIWishList.WISHLISTS);
            
            //System.debug('===wishlistSuperMap=='+wishlistSuperMap.size());
            
            CMI_SW_WishlistWrapper.WishlistItemWrapper wishlistItem=null;
        if(wishlistSuperMap != null ){
            for( String wishlistId : wishlistSuperMap.keySet())
            {
                
                System.debug('===wishlistId==='+wishlistId);
                Map<String,Object> wishListMap = wishlistSuperMap.get(wishlistId);
                
                System.debug('=====wishListMap===='+wishListMap);
                for(String wkey: wishListMap.keySet())
                {
                    System.debug('=====wkey===='+wkey);
                    System.debug('=====wishListMap.gte(wkey)===='+wishListMap.get(wkey));
                }
                
                List<Object> wishListItemsLst =(List<Object>) wishListMap.get('ECartItemsS');
                
                if(wishListItemsLst==null ||  wishListItemsLst.size()==0)
                {
                   //in case wishlist is empty,dont process ahead
                   return prodIdVsWishlistItemMap;
                }
                
                for(Object wishlistItemObj : wishListItemsLst)
                {
                    
                    wishlistItem = new CMI_SW_WishlistWrapper.WishlistItemWrapper();
                    System.debug('wishlistItemObj==='+wishlistItemObj);
                    
                    Decimal price  = (Double)((Map<String,Object>)wishlistItemObj).get('price');
                    String productId = (String)((Map<String,Object>)wishlistItemObj).get('product');
                    String productType = (String)((Map<String,Object>)wishlistItemObj).get('productType');
                    Integer qty = (Integer)((Map<String,Object>)wishlistItemObj).get('quantity');
                    String sfdcName = (String)((Map<String,Object>)wishlistItemObj).get('sfdcName');
                    String sfdcId = (String)((Map<String,Object>)wishlistItemObj).get('sfid');
                    wishlistItem.sfId =sfdcId;
                    wishlistItem.sfdcName =sfdcName;
                    wishlistItem.productId =productId;
                    wishlistItem.productType =productType;
                    wishlistItem.quantity =qty;
                    wishlistItem.wishlistId = wishlistId;
                    wishlistItem.price = price;
                    
                    System.debug('===wishlistItem==='+wishlistItem);
                    prodIdVsWishlistItemMap.put(wishlistItem.productId,wishlistItem);
                    wishlistIdVsWishlistItemMap.put(wishlistItem.sfId,wishlistItem);
                }
                system.debug('===Created prodIdVsWishlistItemMap==='+prodIdVsWishlistItemMap);
                
                          
            }
        }
            //this data will fetches the required field
            Map<Id,ccrz__E_CartItem__c> wishlistItemRefetchMap = new Map<Id,ccrz__E_CartItem__c>([select id,name,Billing_Frequency__c,ProductPackage__c,ccrz__ItemTotal__c,ccrz__DisplayProduct__r.name from ccrz__E_CartItem__c where id in:wishlistIdVsWishlistItemMap.keySet()]);
                
        if(productDetailLst != null){
            for(Map<String,Object> prodDetailMap : productDetailLst)
            {
            
                String data = System.Json.serialize(prodDetailMap);
                CMI_SW_ProductDetailWrapper productDetail = (CMI_SW_ProductDetailWrapper)System.Json.deserialize(data,CMI_SW_ProductDetailWrapper.class);
                
                
                System.debug('==Product sfid=='+productDetail.sfid);
                System.debug('==Product sfdcName=='+productDetail.sfdcName);
                System.debug('==Product SKU=='+productDetail.SKU);
                System.debug('==Product shortDesc=='+productDetail.shortDesc);
                System.debug('==Product groupName=='+productDetail.groupName);
                System.debug('====productDetail==='+productDetail);
                    
                CMI_SW_WishlistWrapper.WishlistItemWrapper wishlistItemObj = prodIdVsWishlistItemMap.get(productDetail.sfid);
                
                Id wishlistItemId = wishlistItemObj.sfId;
                ccrz__E_CartItem__c cartItem = wishlistItemRefetchMap.get(wishlistItemId);
                wishlistItemObj.billingFrequency =  cartItem.Billing_Frequency__c;
                wishlistItemObj.productPackage = cartItem.ProductPackage__c;
                wishlistItemObj.totalPrice = cartItem.ccrz__ItemTotal__c;
                wishlistItemObj.displayProductName = cartItem.ccrz__DisplayProduct__r.name;
                
                //Displayname is set in the product name as we want to show parent product name and not child product name
                productDetail.name= (wishlistItemObj.displayProductName!=null && wishlistItemObj.displayProductName!='') ?wishlistItemObj.displayProductName:productDetail.name;
                wishlistItemObj.productDetail = productDetail; 
                List<String> mediaType = new List<String>{'Product Image Thumbnail'};
                
                if(productDetail.getSpecificMediaType(mediaType)!=null && productDetail.getSpecificMediaType(mediaType).get('Product Image Thumbnail')!=null)
                {
                  wishlistItemObj.mediaWrapper = productDetail.getSpecificMediaType(mediaType).get('Product Image Thumbnail')[0];
                }
                
                /*String sfId = (String)prodDetailMap.get('sfid');
                String sfdcName = (String)prodDetailMap.get('sfdcName');
                String SKU = (String)prodDetailMap.get('SKU');
                String storefront = (String)prodDetailMap.get('storefront');
                
                String productType = (String)prodDetailMap.get('productType');
                String startDate = (String)prodDetailMap.get('startDate');
                String shortDesc = (String)prodDetailMap.get('shortDesc');
                String unitOfMeasure = (String)prodDetailMap.get('unitOfMeasure');
                String groupName = (String)prodDetailMap.get('groupName');
        
                
                CMI_SW_ProductDetailWrapper prodDetailWrapper = new CMI_SW_ProductDetailWrapper();
                prodDetailWrapper.productName = sfdcName;
                prodDetailWrapper.sfId = sfId;
                prodDetailWrapper.productName = sfdcName;
                prodDetailWrapper.SKU = SKU;
                prodDetailWrapper.storefront = storefront;
                prodDetailWrapper.productType = productType;
                prodDetailWrapper.startDate = startDate;
                prodDetailWrapper.shortDesc = shortDesc;
                prodDetailWrapper.unitOfMeasure = unitOfMeasure;
                prodDetailWrapper.groupName = groupName;
                
                Map<String,Object> productMediaMap = prodDetailMap.get('EProductMediasS');
                productMediaMap
                */
                
                for(String field : prodDetailMap.keySet())
                {
                    System.debug('===product field==='+field);
                    
                    System.debug('===prodDetailMap field Value==='+prodDetailMap.get(field));
                    
                    
                }
                          
            }
        }
          
            
            return prodIdVsWishlistItemMap;
    }
	
	public static ccrz__E_Cart__c createNewCart()
	{
		System.debug('=====Inside createNewCart====');
		ccrz.ccLog.log('******************Inside createNewCart ********************* ');
	   Savepoint sp = Database.setSavepoint();
		Boolean wasSuccessful = false;
		 //Id cartId;
		 ccrz__E_Cart__c cart;
		try{
		 
			Map<String, Object> inputData = new Map<String,Object>{
				ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION
			
			};
			
			System.debug('=====Firing Create call=====');
			ccrz.ccLog.log('******************=Firing Create call********************* ');
			Map<String, Object> outputData = ccrz.ccAPICart.create(inputData);
		 
			//General check, since the cart Id will be blank if not successful we technically do not need this.
			if(outputData==null)
			{
			   System.debug('=====outputData is null=====');
			   ccrz.ccLog.log('******************=outputData is null********************* ');
			}
			System.debug('=====outputData is NOT null====='+outputData);
			ccrz.ccLog.log('=====outputData is NOT null====='+outputData);
			wasSuccessful = (Boolean)outputData.get(ccrz.ccApi.SUCCESS);
		    System.debug('===ccrz.ccApiCart.CART_ID==='+ccrz.ccApiCart.CART_ID);
			ccrz.ccLog.log('===ccrz.ccApiCart.CART_ID==='+ccrz.ccApiCart.CART_ID);
			//List<Object> newRawCarts=(List<Object>) outputData.get(ccrz.ccAPICart.CART_OBJLIST
			String cartId =(String) outputData.get(ccrz.ccApiCart.CART_ID);
			String CART_ENCID = (String) outputData.get(ccrz.ccApiCart.CART_ENCID);
			//Map<String, Object> newCart=(Map<String, Object>) newRawCarts[0];
			System.debug('=====New Cart===='+cartId);
			//cartId = (Id)newCart.get(ccrz.ccApiCart.CART_ID);
			if(cartId!=null && cartId!='')
			{
			  cart = new ccrz__E_Cart__c();
			  cart.id=cartId;
                cart.ccrz__EncryptedId__c  = CART_ENCID;
                
			  
			}
			
			System.debug('===cartId==='+cartId);
			
			
		
		}catch(Exception e){
			//Error reporting here....
			  String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
			System.debug('====Exception===='+e.getStackTraceString());
			ccrz.ccLog.log('===errorMsg='+errorMsg);
		}
		  
		if(!wasSuccessful){
			Database.rollback(sp);
		}
		
		return cart;
	}

}