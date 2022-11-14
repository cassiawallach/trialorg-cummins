//cso dev 

global virtual with sharing class dbu_EXTEND_ccLogicWLAddTo extends ccrz.ccLogicWLAddTo {
 
    global virtual override Map<String,Object> insertWishListItems(Map<String,Object> inputData){
        System.debug(LoggingLevel.INFO, 'Inside Add to');
        system.debug('inputData keyset > ' + inputData.keyset());
        system.debug('inputData values > ' + inputData.values());
        
        //get the products and wishlist ID
        Map<string,object> OriginalInputInformation =  (Map<string,object>)inputData.get('originalInputData');
        system.debug('OriginalInputInformation keyset > ' + OriginalInputInformation.keyset());
        system.debug('OriginalInputInformation > ' + OriginalInputInformation );
        system.debug('wlId > ' +  (string)OriginalInputInformation.get('wlId'));
        system.debug('productIdList > ' + (list<string>)inputData.get('productIdList'));
        
        System.debug(LoggingLevel.INFO, 'Line 17 no');
        
        list<string> ProdIdListToInsert = new list<string>();
         ProdIdListToInsert = (list<string>)inputData.get('productIdList');
        system.debug('ProdIdListToInsert > ' + ProdIdListToInsert);
        
        string WishlstID = (string)OriginalInputInformation.get('wlId');
        system.debug('WishlistID > ' + WishlstID);
        
        string SFL_OR_WL = (string)OriginalInputInformation.get('SaveForLater');
        system.debug('SFL_OR_WL > ' + SFL_OR_WL);
        
		System.debug(LoggingLevel.INFO, 'Line 29 no');
        
        //Check whether the product is in wishlist                
        list<ccrz__E_CartItem__c> CartItemExisting = new list<ccrz__E_CartItem__c>();
        CartItemExisting = [select id,ccrz__Quantity__c, ccrz__Product__c, ccrz__Cart__c, dbu_Item_ProductStatus__c, ccrz__PricingType__c, ccrz__Price__c, DBU_SaveForLater__c, ccrz__cartItemType__c ,ccrz__ProductType__c ,ccrz__ItemStatus__c from ccrz__E_CartItem__c where ccrz__Cart__c =: WishlstID AND DBU_SaveForLater__c !=: SFL_OR_WL AND DBU_SaveForLater__c != 'Cart' AND ccrz__Product__c IN : ProdIdListToInsert];        
        
        
		Map<string,Object> retMap = super.insertWishListItems(inputData);
        
        //system.debug('retMap keyset::: ' + retMap.keyset());
        //system.debug('retMap Values::: ' + retMap.Values());
                
        string wishlistID = (string)retMap.get('wlId');
        string saveforlatervalue = (string)retMap.get('SaveForLater');
        string userSelectedQuantity = (string)retMap.get('USER_SELECTED_QUANTITY');
        string ProductId = (string)(((list<object>)retMap.get('productIdList'))[0]);
        boolean stock_Status = (boolean)inputData.get('dbuItemProductStatus');
        system.debug('stock_Status > ' + stock_Status);	        

        
        list<ccrz__E_CartItem__c> cartitemlist = [select id, DBU_SaveForLater__c, ccrz__Quantity__c, dbu_Item_ProductStatus__c from ccrz__E_CartItem__c where ccrz__Product__c =: ProductId AND ccrz__Cart__c =: wishlistID LIMIT 1];
        system.debug('cartitemlist :::' + cartitemlist);
        
        if(saveforlatervalue == 'Save For Later'){
            system.debug('IS SAVEFORLATER :: ' + saveforlatervalue);
            for(ccrz__E_CartItem__c clst : cartitemlist){
                clst.DBU_SaveForLater__c = 'Save For Later';
                clst.dbu_Item_ProductStatus__c = stock_Status;
                clst.ccrz__Quantity__c = decimal.valueOf(userSelectedQuantity);
            }                        
        }else if(saveforlatervalue == 'WishList'){
            system.debug('IS WISHLIST :: ' + saveforlatervalue);
            for(ccrz__E_CartItem__c clst : cartitemlist){
                clst.DBU_SaveForLater__c = 'WishList';
                clst.dbu_Item_ProductStatus__c = stock_Status;  
                clst.ccrz__Quantity__c = decimal.valueOf(userSelectedQuantity);
            }                           
        }
        
        update cartitemlist; 
        
        list<ccrz__E_CartItem__c> newinserts = new list<ccrz__E_CartItem__c>();
        
        if(!CartItemExisting.isEmpty()){
            Map<string, string> ProdSFLstateMap = new Map<string, string>();
           
            system.debug('CartItemExisting > ' + CartItemExisting);
            for(ccrz__E_CartItem__c eachitem : CartItemExisting){
                //eachitem.id = null;
                ccrz__E_CartItem__c iti = new ccrz__E_CartItem__c();
                iti.DBU_SaveForLater__c = eachitem.DBU_SaveForLater__c;
                iti.ccrz__Quantity__c = eachitem.ccrz__Quantity__c;
                iti.ccrz__Product__c = eachitem.ccrz__Product__c;
                iti.dbu_Item_ProductStatus__c = stock_Status;  
                iti.ccrz__Cart__c = eachitem.ccrz__Cart__c;
                iti.ccrz__cartItemType__c = eachitem.ccrz__cartItemType__c;
                iti.ccrz__ProductType__c = eachitem.ccrz__ProductType__c;
                iti.ccrz__ItemStatus__c = eachitem.ccrz__ItemStatus__c;
                iti.ccrz__Price__c = eachitem.ccrz__Price__c;
                ProdSFLstateMap.put(string.valueof(eachitem.ccrz__Product__c), eachitem.DBU_SaveForLater__c);
                newinserts.add(iti);
            }
            
            list<ccrz__E_CartItem__c> IfCartitemExist = new list<ccrz__E_CartItem__c>();  
            
            system.debug('(ProdSFLstateMap.values())[0] >>> ' + (ProdSFLstateMap.values())[0]);
            
            if((ProdSFLstateMap.values())[0] == 'Save For Later'){
				IfCartitemExist = [select ccrz__Product__c from ccrz__E_CartItem__c where  ccrz__Cart__c =: wishlistID AND ccrz__Product__c in : ProdSFLstateMap.keySet() AND DBU_SaveForLater__c =: 'Save For Later'AND DBU_SaveForLater__c !=: 'WishList' AND DBU_SaveForLater__c !=: 'Cart'];                
				system.debug('IfCartitemExist SFL > ' + IfCartitemExist);                
            }else if((ProdSFLstateMap.values())[0] == 'WishList'){
                IfCartitemExist = [select ccrz__Product__c from ccrz__E_CartItem__c where  ccrz__Cart__c =: wishlistID AND ccrz__Product__c in : ProdSFLstateMap.keySet() AND DBU_SaveForLater__c =: 'WishList' AND DBU_SaveForLater__c !=:'Save For Later' AND DBU_SaveForLater__c !=: 'Cart'];                
				system.debug('IfCartitemExist WL > ' + IfCartitemExist);                  
            }
            
            
            if(IfCartitemExist.isEmpty()){
                system.debug('newinserts  >' + newinserts);
                //insert CartItemExisting;
                Database.SaveResult[] srList = Database.insert(newinserts, false);
                system.debug('srList ' + srList);
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    system.debug('inloop');
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully inserted wishlistitem. wishlistitem ID: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('wishlistitem fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }

            
        }
        
        return retMap;
    }
    
}