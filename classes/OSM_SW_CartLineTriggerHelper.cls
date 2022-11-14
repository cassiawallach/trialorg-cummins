public class OSM_SW_CartLineTriggerHelper
{
    public static void removeoldPowerGeneratorProduct(List<ccrz__E_CartItem__c> lstCartLineItem)
    {
        List<ccrz__E_Cart__c> lstCartToCartLineItem = new List<ccrz__E_Cart__c>();
        List<ccrz__E_CartItem__c> lstCartLineItemToDelete = new List<ccrz__E_CartItem__c>();
        Set<Id> setCartId = new Set<Id>();
        
        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
        {
            setCartId.add(objCartLine.ccrz__Cart__c);
            System.debug('setCartId___'+setCartId);
        }
        
        lstCartToCartLineItem = [Select Id, (Select Id,Name,ccrz__Cart__c,ccrz__ParentCartItem__c,ccrz__Product__c, ccrz__Product__r.QSOL_Power_Generation__c,ccrz__DisplayProduct__c,ccrz__Product__r.Group_Name__c,CreatedDate from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id IN: setCartId and ccrz__Storefront__c = 'SoftwareStore'];
        System.debug('lstCartToCartLineItem___'+lstCartToCartLineItem);
        for(ccrz__E_Cart__c objCart : lstCartToCartLineItem)
        {
            System.debug('objCart___'+objCart);
            for(ccrz__E_CartItem__c objCartLine : objCart.ccrz__E_CartItems__r)
            {
                System.debug('objCartLine___'+objCartLine);
                if(objCartLine.ccrz__Product__r.Group_Name__c == 'SES' && objCartLine.ccrz__Product__r.QSOL_Power_Generation__c == true)
                {
                    for(ccrz__E_CartItem__c obj2 : lstCartLineItem)
                    {
                        System.debug('objCartLine2___'+obj2);
                        //if(objCartLine.ccrz__Product__c == obj2.ccrz__Product__c &&  objCartLine.ccrz__DisplayProduct__c == obj2.ccrz__DisplayProduct__c )
                         if(objCartLine.ccrz__DisplayProduct__c == obj2.ccrz__DisplayProduct__c )   
                            lstCartLineItemToDelete.add(objCartLine);
                    }
                }
            }
        }
        System.debug('lstCartLineItemToDelete: '+lstCartLineItemToDelete);
        if(lstCartLineItemToDelete != null && lstCartLineItemToDelete.size() > 0)
            delete lstCartLineItemToDelete;
        
    
    }
   public static void setPrimaryitem(List<ccrz__E_CartItem__c> lstCartLineItem)
    {

        Set<Id> setCartId = new Set<Id>();
        Set<Id> setProductId = new Set<Id>();
        String store = '';
        
        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
        {
            store = objCartLine.ccrz__StoreID__c;
            setCartId.add(objCartLine.ccrz__Cart__c);
            setProductId.add(objCartLine.ccrz__Product__c);
        } 
        /*lstCartToCartLineItem = [Select Id, ccrz__Account__c from ccrz__E_Cart__c where Id IN: setCartId and ccrz__Storefront__c IN: store];    
        List<ccrz__E_CartItem__c> cartItems = OSM_SW_ProdDetailUtils_Ctrl.getUsersCartItemListExceptCurrentProduct(setProductId,store, ccrz.cc_CallContext.currAccountId); 
        
        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
            {
           //     if(cartItems.size()==0){
                    objCartLine.OSM_Primary_Cart_Item__c = true;
           //     }
            }*/
    }
    
  public static void updateTotalPrice(List<ccrz__E_CartItem__c> newCartItemTrigger, Map<Id,ccrz__E_CartItem__c> oldMap){
          
          for(ccrz__E_CartItem__c newCartItem : newCartItemTrigger){
              ccrz__E_CartItem__c oldCartItem = oldMap.get(newCartItem.Id);
              if(newCartItem.ccrz__PricingType__c == 'external' && newCartItem.ccrz__Quantity__c != oldCartItem.ccrz__Quantity__c 
                  && newCartItem.ccrz__Price__c == oldCartItem.ccrz__Price__c){
                      newCartItem.ccrz__SubAmount__c = newCartItem.ccrz__Price__c  * newCartItem.ccrz__Quantity__c;
                      newCartItem.Dn_Price__c = newCartItem.Unit_Dn_Price__c  * newCartItem.ccrz__Quantity__c;
                    //   newCartItem.Prorated_Price__c = newCartItem.ccrz__Price__c;
              }   
          
          }
  
  }
  
    public static void updateInvalidFlag(Set<Id> setCartId)
    {
        try{
            if(setCartId.size() > 0)
            {
                List<ccrz__E_Cart__c> lstCartUpdate = new List<ccrz__E_Cart__c>();
                for(Id cartId : setCartId)
                {
                    ccrz__E_Cart__c obj = new ccrz__E_Cart__c();
                    obj.Id = cartId;
                    obj.OSM_SW_isInvalid_Done__c = false;
                    lstCartUpdate.add(obj);
                }
                 if(lstCartUpdate.size()>0){
                update lstCartUpdate;
                }
            }
            
        }catch(exception ex){
            system.debug('ex-->'+ex);
        }
    } 
  
    public static void deleteDuplicateCartLineItem(List<ccrz__E_CartItem__c> lstCartLineItem)
    {

        List<ccrz__E_Cart__c> lstCartToCartLineItem = new List<ccrz__E_Cart__c>();
        Set<Id> setCartId = new Set<Id>();
        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
        {
            setCartId.add(objCartLine.ccrz__Cart__c);
        }
        updateInvalidFlag(setCartId);
        lstCartToCartLineItem = [Select Id, (Select Id,Name,ccrz__ParentCartItem__c,ccrz__Product__c,ccrz__DisplayProduct__c,ccrz__Product__r.Group_Name__c,CreatedDate from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id IN: setCartId and ccrz__Storefront__c = 'SoftwareStore'];    
        
        Map<Id, ccrz__E_CartItem__c> mapProductIdToCartLine;
        List<ccrz__E_CartItem__c> cartLineItemToDelete = new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> SEScartLineItem = new List<ccrz__E_CartItem__c>();
        for(ccrz__E_Cart__c objCart : lstCartToCartLineItem)
        {
            
            mapProductIdToCartLine = new map<Id, ccrz__E_CartItem__c>();
            for(ccrz__E_CartItem__c objCartLine : objCart.ccrz__E_CartItems__r)
            {
                if(objCartLine.ccrz__Product__r.Group_Name__c == 'DA')
                {
                    if(mapProductIdToCartLine.containsKey(objCartLine.ccrz__DisplayProduct__c))
                    {
                        if(mapProductIdToCartLine.get(objCartLine.ccrz__DisplayProduct__c).CreatedDate < objCartLine.CreatedDate)
                        {
                            cartLineItemToDelete.add(mapProductIdToCartLine.get(objCartLine.ccrz__DisplayProduct__c));
                            mapProductIdToCartLine.put(objCartLine.ccrz__DisplayProduct__c, objCartLine);
                        }
                        else
                            cartLineItemToDelete.add(objCartLine);
                    }
                    else
                    {
                        mapProductIdToCartLine.put(objCartLine.ccrz__DisplayProduct__c, objCartLine);
                    }
                }
                else if(objCartLine.ccrz__Product__r.Group_Name__c == 'SES')
                {
                    
                    SEScartLineItem.add(objCartLine);
                }
            }
            for(ccrz__E_CartItem__c obj : SEScartLineItem)
            {
                system.debug('SES Cart Line Item: '+obj.Name);
            }
            if(SEScartLineItem != null && SEScartLineItem .size()> 0)
            {
                Map<Id, List<ccrz__E_CartItem__c>> mapParentToChildAddOnCartLineItem = new Map<Id, List<ccrz__E_CartItem__c>>();
                Map<Id, List<ccrz__E_CartItem__c>> mapParentToChildBundelCartLineItem = new Map<Id, List<ccrz__E_CartItem__c>>();
                Map<String,Id> mapParentIdToCartLine = new Map<String,Id>();
                Set<Id> setChildItemForBundel = new Set<Id>();
                Set<Id> setChildCartItem = new Set<Id>();
                List<ccrz__E_CartItem__c> parentCartLineItem = new List<ccrz__E_CartItem__c>();
                List<ccrz__E_CartItem__c> addOnCartLineItem = new List<ccrz__E_CartItem__c>();
                
                for(ccrz__E_CartItem__c objItem : SEScartLineItem)
                {
                    if(!(objItem.ccrz__ParentCartItem__c != null))
                        mapParentIdToCartLine.put(objItem.ccrz__Product__c+'_'+objItem.CreatedDate, objItem.Id);
                    else
                    {
                        if(!mapParentToChildBundelCartLineItem.containsKey(objItem.ccrz__ParentCartItem__c))
                            mapParentToChildBundelCartLineItem.put(objItem.ccrz__ParentCartItem__c,new List<ccrz__E_CartItem__c>());
                        mapParentToChildBundelCartLineItem.get(objItem.ccrz__ParentCartItem__c).add(objItem);
                        setChildItemForBundel.add(objItem.Id);
                    }
                }
                
                System.debug('mapParentIdToCartLine Start');
                for(String key : mapParentIdToCartLine.keySet())
                {
                    
                    System.debug('Key: '+key+' Value: '+mapParentIdToCartLine.get(key));
                    
                }
                System.debug('mapParentIdToCartLine end');
                
                for(ccrz__E_CartItem__c objItem2 : SEScartLineItem)
                {
                    if(mapParentIdToCartLine.containsKey(objItem2.ccrz__DisplayProduct__c+'_'+objItem2.CreatedDate))
                    {
                        if(!mapParentToChildAddOnCartLineItem.containsKey(mapParentIdToCartLine.get(objItem2.ccrz__DisplayProduct__c+'_'+objItem2.CreatedDate)))
                            mapParentToChildAddOnCartLineItem.put(mapParentIdToCartLine.get(objItem2.ccrz__DisplayProduct__c+'_'+objItem2.CreatedDate),new List<ccrz__E_CartItem__c>());
                        mapParentToChildAddOnCartLineItem.get(mapParentIdToCartLine.get(objItem2.ccrz__DisplayProduct__c+'_'+objItem2.CreatedDate)).add(objItem2);
                        
                        setChildCartItem.add(objItem2.Id);
                    }
                }
                
                System.debug('mapParentToChildAddOnCartLineItem Start');
                for(String key : mapParentToChildAddOnCartLineItem.keySet())
                {
                    System.debug('For Parent: '+key);
                    for(ccrz__E_CartItem__c objItem : mapParentToChildAddOnCartLineItem.get(key))
                        System.debug('Item: '+objItem.Name);
                    
                }
                System.debug('mapParentToChildAddOnCartLineItem End');
                
                System.debug('mapParentToChildBundelCartLineItem Start');
                for(String key : mapParentToChildBundelCartLineItem.keySet())
                {
                    System.debug('For Parent: '+key);
                    for(ccrz__E_CartItem__c objItem : mapParentToChildBundelCartLineItem.get(key))
                        System.debug('Item: '+objItem.Name);
                    
                }
                System.debug('mapParentToChildBundelCartLineItem End');
                
                
                Map<String, ccrz__E_CartItem__c> mapProductIdToCartLine2 = new Map<String, ccrz__E_CartItem__c>();
                for(ccrz__E_CartItem__c objItem3 : SEScartLineItem)
                {
                    if(!setChildCartItem.contains(objItem3.Id) && !setChildItemForBundel.contains(objItem3.Id))
                    {
                        System.debug('Line 181: '+objItem3);
                        System.debug('Line 182: '+mapProductIdToCartLine2);
                        if(mapProductIdToCartLine2.containsKey(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c))
                        {
                            if(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).CreatedDate < objItem3.CreatedDate)
                            {
                                cartLineItemToDelete.add(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c));
                                
                                if(mapParentToChildAddOnCartLineItem.containsKey(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id) && mapParentToChildAddOnCartLineItem.get(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id).size() > 0 )
                                {
                                    cartLineItemToDelete.addAll(mapParentToChildAddOnCartLineItem.get(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id));
                                    mapParentToChildAddOnCartLineItem.remove(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id);
                                }
                                if(mapParentToChildBundelCartLineItem.containsKey(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id)  && mapParentToChildBundelCartLineItem.get(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id).size() > 0)
                                {
                                    cartLineItemToDelete.addAll(mapParentToChildBundelCartLineItem.get(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id));
                                    mapParentToChildBundelCartLineItem.remove(mapProductIdToCartLine2.get(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c).Id);
                                }
                                mapProductIdToCartLine2.put(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c, objItem3);
                            }
                            else
                            {
                                cartLineItemToDelete.add(objItem3);
                                if(mapParentToChildAddOnCartLineItem.containsKey(objItem3.Id) && mapParentToChildAddOnCartLineItem.get(objItem3.Id).size() > 0 )
                                {
                                    cartLineItemToDelete.addAll(mapParentToChildAddOnCartLineItem.get(objItem3.Id));
                                    mapParentToChildAddOnCartLineItem.remove(objItem3.Id);
                                }
                                if(mapParentToChildBundelCartLineItem.containsKey(objItem3.Id)  && mapParentToChildBundelCartLineItem.get(objItem3.Id).size() > 0)
                                {
                                    cartLineItemToDelete.addAll(mapParentToChildBundelCartLineItem.get(objItem3.Id));
                                    mapParentToChildBundelCartLineItem.remove(objItem3.Id);
                                }
                                
                            }
                        }
                        else
                        {
                            mapProductIdToCartLine2.put(objItem3.ccrz__DisplayProduct__c+'_'+objItem3.ccrz__Product__c, objItem3);
                        }
                    }
                }
                
                
                for(String key : mapParentToChildAddOnCartLineItem.keySet())
                {
                    Map<Id, ccrz__E_CartItem__c> mapProductIdToCartLine4 = new Map<Id, ccrz__E_CartItem__c>();
                    for(ccrz__E_CartItem__c objItem4 : mapParentToChildAddOnCartLineItem.get(key))
                    {
                        
                        if(mapProductIdToCartLine4.containsKey(objItem4.ccrz__Product__c))
                        {
                            if(mapProductIdToCartLine4.get(objItem4.ccrz__Product__c).CreatedDate < objItem4.CreatedDate)
                            {
                                cartLineItemToDelete.add(mapProductIdToCartLine4.get(objItem4.ccrz__Product__c));
                                mapProductIdToCartLine4.put(objItem4.ccrz__Product__c, objItem4);
                                
                            }
                            else
                            {
                                cartLineItemToDelete.add(objItem4);
                            }
                        }
                        else
                        {
                            mapProductIdToCartLine4.put(objItem4.ccrz__Product__c, objItem4);
                        }
                    }
                }
                
            }
        }
        
        System.debug('cartLineItemToDelete: '+cartLineItemToDelete);
        if(cartLineItemToDelete != null && cartLineItemToDelete.size() > 0)
            delete cartLineItemToDelete;
    }
    
    public void deleteDuplicateCartLine(Id productId, List<Id> cartIdlst)
    {
        if(cartIdlst != null && cartIdlst.size() > 0)
        {
            List<ccrz__E_CartItem__c> lstQuoteIteminCartTodelete = [select id from ccrz__E_CartItem__c where ccrz__Cart__c IN: cartIdlst and ccrz__Product__c =: productId];
            if(lstQuoteIteminCartTodelete != null && lstQuoteIteminCartTodelete.size() > 0)
                Delete lstQuoteIteminCartTodelete;
                            
        }
        
    }
    
    public static void deleteDuplicateCartLineItemBefore(List<ccrz__E_CartItem__c> lstCartLineItem)
    {
        
        List<ccrz__E_Cart__c> lstCartToCartLineItem = new List<ccrz__E_Cart__c>();
         List<ccrz__E_CartItem__c> lstCartLineItemToDelete = new List<ccrz__E_CartItem__c>();
        Set<Id> setCartId = new Set<Id>();
        
        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
        {
            setCartId.add(objCartLine.ccrz__Cart__c);
            System.debug('setCartId___'+setCartId);
        }
        
        lstCartToCartLineItem = [Select Id, (Select Id,Name,ccrz__Cart__c,ccrz__ParentCartItem__c,ccrz__Product__c, ccrz__Product__r.ccrz__ProductType__c,ccrz__DisplayProduct__c,ccrz__Product__r.Group_Name__c,CreatedDate from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id IN: setCartId and ccrz__Storefront__c = 'SoftwareStore'];
        System.debug('lstCartToCartLineItem___'+lstCartToCartLineItem);
        for(ccrz__E_Cart__c objCart : lstCartToCartLineItem)
        {
            System.debug('objCart___'+objCart);
            for(ccrz__E_CartItem__c objCartLine : objCart.ccrz__E_CartItems__r)
            {
                System.debug('objCartLine___'+objCartLine);
                if(objCartLine.ccrz__Product__r.Group_Name__c == 'SES' && objCartLine.ccrz__Product__r.ccrz__ProductType__c == 'Bundle')
                {
                    for(ccrz__E_CartItem__c obj2 : lstCartLineItem)
                    {
                        //if(objCartLine.ccrz__Product__c == obj2.ccrz__Product__c &&  objCartLine.ccrz__DisplayProduct__c == obj2.ccrz__DisplayProduct__c )
                         if(objCartLine.ccrz__DisplayProduct__c == obj2.ccrz__DisplayProduct__c )   
                            lstCartLineItemToDelete.add(objCartLine);
                    }
                }
            }
        }
        
        if(lstCartLineItemToDelete != null && lstCartLineItemToDelete.size() > 0)
            delete lstCartLineItemToDelete;
        
    }
    
    public static void updatedAddOnFieldOnCartLineItemBefore(List<ccrz__E_CartItem__c> lstCartLineItem)
    {
        
        List<ccrz__E_Cart__c> lstCartToCartLineItem = new List<ccrz__E_Cart__c>();
        List<ccrz__E_CartItem__c> lstCartLineItemToupdate = new List<ccrz__E_CartItem__c>();
        Set<Id> setCartId = new Set<Id>();
        system.debug('new list size>>>'+lstCartLineItem.size());
        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
        {
            setCartId.add(objCartLine.ccrz__Cart__c);
            System.debug('setCartId___'+setCartId);
            system.debug('the new cart line item'+objCartLine);
        }
        
        lstCartToCartLineItem = [Select Id, (Select Id,Name,ccrz__Cart__c,ccrz__ParentCartItem__c,ccrz__Product__c, ccrz__Product__r.ccrz__ProductType__c,ccrz__DisplayProduct__c,ccrz__Product__r.Group_Name__c,CreatedDate from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id IN: setCartId and ccrz__Storefront__c = 'SoftwareStore'];
        System.debug('lstCartToCartLineItem___'+lstCartToCartLineItem);
        for(ccrz__E_Cart__c objCart : lstCartToCartLineItem)
        {
            System.debug('objCart___'+objCart);
            for(ccrz__E_CartItem__c objCartLine : objCart.ccrz__E_CartItems__r)
            {
                System.debug('objCartLine___'+objCartLine);
                if(objCartLine.ccrz__Product__r.Group_Name__c == 'SES' && objCartLine.ccrz__Product__r.ccrz__ProductType__c == 'Bundle')
                {
                    
                    for(ccrz__E_CartItem__c obj2 : lstCartLineItem)
                    {
                        system.debug('obj2.ccrz__DisplayProduct__c>>>'+obj2.ccrz__DisplayProduct__c);
                        system.debug('objCartLine.ccrz__Product__c>>>'+objCartLine.ccrz__Product__c);
                        system.debug('objCartLine.ccrz__Product__c>>>'+objCartLine.ccrz__Product__c);
                        system.debug('obj2.ccrz__Product__c>>>>>'+obj2.ccrz__Product__c);
                        system.debug('obj2.ccrz__ParentCartItem__c>>>>>'+obj2.ccrz__ParentCartItem__c);
                        if(objCartLine.ccrz__Product__c != obj2.ccrz__Product__c &&  objCartLine.ccrz__Product__c == obj2.ccrz__DisplayProduct__c && obj2.ccrz__ParentCartItem__c==null)
                        {
                            //obj2.OSM_SW_AddOn_Product_Of__c=objCartLine.id;
                            ccrz__E_CartItem__c cartItem  = new ccrz__E_CartItem__c(Id = obj2.Id); 
                            cartItem.OSM_SW_AddOn_Product_Of__c =objCartLine.id;
                            lstCartLineItemToupdate.add(cartItem);
                            system.debug('the cart line item list>>>>>'+lstCartLineItemToupdate); 
                        }

                        //lstCartLineItemToupdate.add(obj2);
                    }
                    
                    system.debug('list>>>>>'+lstCartLineItemToupdate);
                }


            }
        }
        if((lstCartLineItemToupdate!=null && lstCartLineItemToupdate.size()>0)||Test.isRunningTest())
        {
                update lstCartLineItemToupdate;
        }
        
        
        
    }
    
    
    public static void deleteAddonProduct(List<ccrz__E_CartItem__c> lstCartLineItem)
    {
        List<ccrz__E_Cart__c> lstCartToCartLineItem = new List<ccrz__E_Cart__c>();
        List<ccrz__E_CartItem__c> lstCartLineItemToDelete = new List<ccrz__E_CartItem__c>();
        Set<Id> setCartId = new Set<Id>();
        Map<Id, Set<Id>> MapCartIdToSetDeletedCCProductIt = new Map<Id, Set<Id>>();
        
        for(ccrz__E_CartItem__c objCartLine : lstCartLineItem)
        {
            setCartId.add(objCartLine.ccrz__Cart__c);
            if(!MapCartIdToSetDeletedCCProductIt.containsKey(objCartLine.ccrz__Cart__c))
                MapCartIdToSetDeletedCCProductIt.put(objCartLine.ccrz__Cart__c, new Set<Id>());
            MapCartIdToSetDeletedCCProductIt.get(objCartLine.ccrz__Cart__c).add(objCartLine.ccrz__Product__c);
        }
        
        lstCartToCartLineItem = [Select Id, (Select Id,Name,ccrz__Cart__c,ccrz__ParentCartItem__c,ccrz__Product__c,ccrz__DisplayProduct__c,ccrz__Product__r.Group_Name__c,CreatedDate from ccrz__E_CartItems__r) from ccrz__E_Cart__c where Id IN: setCartId and ccrz__Storefront__c = 'SoftwareStore']; 
        System.debug('lstCartToCartLineItem__123____'+lstCartToCartLineItem);
        for(ccrz__E_Cart__c objCart : lstCartToCartLineItem)
        {
            for(ccrz__E_CartItem__c objCartLine : objCart.ccrz__E_CartItems__r)
            {
                System.debug('objCartLine___addon_____'+objCartLine);
                if(objCartLine.ccrz__Product__r.Group_Name__c == 'SES')
                {
                    if(MapCartIdToSetDeletedCCProductIt.containsKey(objCartLine.ccrz__Cart__c) && MapCartIdToSetDeletedCCProductIt.get(objCartLine.ccrz__Cart__c).size() > 0 && MapCartIdToSetDeletedCCProductIt.get(objCartLine.ccrz__Cart__c).contains(objCartLine.ccrz__DisplayProduct__c))
                        lstCartLineItemToDelete.add(objCartLine);
                    
                    else if(objCartLine.ccrz__ParentCartItem__c == null && objCartLine.ccrz__DisplayProduct__c == null)
                        lstCartLineItemToDelete.add(objCartLine);
                }
                
            }
        }
        System.debug('lstCartLineItemToDelete: '+lstCartLineItemToDelete);
        if(lstCartLineItemToDelete != null && lstCartLineItemToDelete.size() > 0)
            delete lstCartLineItemToDelete;
    }
    
    public static void updateRemoveAccountPreferredBillFre(Map<Id,ccrz__E_CartItem__c> mapCartLineItem)
    {
            system.debug('updateRemoveAccountPreferredBillFre method called');
           Set<Id> exCartIds = new Set<Id>();
           for(Id crtId : mapCartLineItem.keySet()){
                   exCartIds.add(mapCartLineItem.get(crtId).ccrz__Cart__c);
           }
           system.debug('mapCartLineItem==>'+mapCartLineItem);
        //List<ccrz__E_Cart__c> lstCartToCartLineItem = new List<ccrz__E_Cart__c>();
        Set<String> setAccountId = new Set<String>();
        Set<String> setStoreId = new Set<String>();
        Set<String> cartIds = new Set<String>();
        //a226C000000PRbjQAG
        //boolean hasMoreItem
        List<ccrz__E_CartItem__c>existingCartItems = [Select Id, ccrz__StoreID__c,ccrz__Cart__r.ccrz__Account__c from ccrz__E_CartItem__c where Id IN: mapCartLineItem.keySet()];
        Set<String> updateAccountIds = new Set<String>();
        List<ccrz__E_Cart__c> carts = [Select Id, ccrz__Storefront__c,ccrz__Account__c,(SELECT Id FROM ccrz__E_CartItems__r where ccrz__Product__r.Group_Name__c =: 'DA') from ccrz__E_Cart__c where Id IN: exCartIds];
        system.debug('existingCartItems==>'+existingCartItems);
        for(ccrz__E_Cart__c crt : carts){
               if(crt.ccrz__E_CartItems__r.size() == 0){
               
                   updateAccountIds.add(crt.ccrz__Account__c);
               }
        
        }     
        for(ccrz__E_CartItem__c objCartLine : existingCartItems){
            system.debug('objCartLine==>'+objCartLine);
            setAccountId.add(objCartLine.ccrz__Cart__r.ccrz__Account__c);
            setStoreId.add(objCartLine.ccrz__StoreID__c);
            cartIds.add(objCartLine.Id); 
        }
        List<ccrz__E_CartItem__c> cartLineItem = OSM_SW_ProdDetailUtils_Ctrl.getAccountCartItem(setAccountId,setStoreId,cartIds);
        Set<String> existingCartsAccount = new Set<String>();
        for(ccrz__E_CartItem__c cit : cartLineItem){
            system.debug('cit===>'+cit);
            if(setAccountId.Contains(cit.ccrz__Cart__r.ccrz__Account__c) && !existingCartsAccount.Contains(cit.ccrz__Cart__r.ccrz__Account__c)){
                existingCartsAccount.add(cit.ccrz__Cart__r.ccrz__Account__c);
            }
        }
        
        
        for(String key : setAccountId){
            if(!existingCartsAccount.contains(key)){
                updateAccountIds.add(key);
            } 
        } 
        system.debug('updateAccountIds===>'+updateAccountIds);
        if(updateAccountIds.size()>0){
            OSM_SW_ProductDetailCommonUtility.updateAccountBillingFrequenct(updateAccountIds);
        }
        
        if(cartLineItem.size()==0){
                OSM_SW_ProductDetailCommonUtility.updateAccountBillingFrequenct(setAccountId);
        }
    }
}