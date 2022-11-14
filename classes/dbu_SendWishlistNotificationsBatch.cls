global class dbu_SendWishlistNotificationsBatch implements Database.Batchable<sObject>,Database.stateful{
    String query;    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
                
        //Previous logic commented
        //query = 'select id,ccrz__Product__c,ccrz__Cart__c,ccrz__Product__r.Name,ccrz__Product__r.id,ccrz__Product__r.ccrz__SKU__c,ccrz__Cart__r.ccrz__Contact__c,ccrz__Cart__r.ccrz__Contact__r.Email,ccrz__Cart__r.ccrz__Contact__r.FirstName,ccrz__Cart__r.ccrz__Contact__r.LastName,ccrz__Cart__r.ccrz__CartType__c,ccrz__Cart__r.id,DBU_SaveForLater__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__CartType__c = \'WishList\'and DBU_SaveForLater__c = \'WishList\' and ccrz__Product__r.dbu_Inventory_Status_Check__c = true and ccrz__Cart__r.ccrz__Contact__c != NULL';
    	
        //Query as per new Logic
        query = 'select id, ccrz__Product__c, ccrz__Cart__c, ccrz__Cart__r.dbu_Cart_StoreCountry__c, ccrz__Cart__r.dbu_storeLanguage__c, ccrz__Product__r.Name, ccrz__Product__r.id,ccrz__Product__r.ccrz__SKU__c, ccrz__Cart__r.ccrz__Contact__c, ccrz__Cart__r.ccrz__Contact__r.Email, ccrz__Cart__r.ccrz__Contact__r.FirstName, ccrz__Cart__r.ccrz__Contact__r.LastName, ccrz__Cart__r.ccrz__CartType__c, ccrz__Cart__r.id, DBU_SaveForLater__c, dbu_Item_ProductStatus__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__r.ccrz__Storefront__c = \'CSSNAStore\' and ccrz__Cart__r.ccrz__CartType__c = \'WishList\' and DBU_SaveForLater__c = \'WishList\'  and ccrz__Product__r.dbu_Has_Core_Child__c = false and dbu_Item_ProductStatus__c = false and ccrz__Cart__r.ccrz__Contact__c != NULL';
        
        system.debug('query' +query);
        return Database.getQueryLocator(query);
    } 
    
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_CartItem__c>cartList){   
        system.debug('scope' +cartList);
        string emailTemplateName = 'dbu_Wishlist_Email_Notification';
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = :emailTemplateName];
        
        Map<string,string> ContactIdEmailMap = new Map<string,string>();
        
        if(cartList != null){
        	    
            for(ccrz__E_CartItem__c eachCartitem : cartList){               
                ContactIdEmailMap.put((string)eachCartitem.ccrz__Cart__r.ccrz__Contact__c, (string)eachCartitem.ccrz__Cart__r.ccrz__Contact__r.Email);                    
            }
			system.debug('ContactIdEmailMap > ' + ContactIdEmailMap);            
            
           	system.debug('cartList > ' + cartList);            
            dbu_CallCCWishListApi.getInventoryStatusforWishlistProductsForAllContacts(cartList);
   
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
  
}