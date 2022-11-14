public class dbu_NoficationsDetailsCtrl {
    @AuraEnabled(cacheable=true)
    public static void fetchNoficationsDetails(String recId) {
        System.debug('recId>>> '+ recId);
        //SELECT Id,dbu_All_Notification__c,dbu_Email_communications__c,dbu_Product_stock_notifications__c,dbu_Special_promotions__c,dbu_Wishlist_notifications__c FROM User where id = '0051F00000l7C4kQAE'
        //return  [SELECT Id,dbu_All_Notification__c,dbu_Email_communications__c,dbu_Product_stock_notifications__c,dbu_Special_promotions__c,dbu_Wishlist_notifications__c FROM User where Id =:recId];
        //return  [SELECT Id,FirstName,LastName,Email,Phone FROM Contact where Phone <> null limit 1];
    }
}


/*
public class dbu_NoficationsDetailsCtrl {
    @AuraEnabled(cacheable=true)
    public static User fetchNoficationsDetails(String recId) {
        System.debug('recId>>> '+ recId);
        //return  [SELECT Id,dbu_All_Notification__c,dbu_Email_communications__c,dbu_Product_stock_notifications__c,dbu_Special_promotions__c,dbu_Wishlist_notifications__c FROM User where Id =:recId];
        
        return  [SELECT Id,dbu_All_Notification__c,dbu_Email_communications__c,dbu_Product_stock_notifications__c,dbu_Special_promotions__c,dbu_Wishlist_notifications__c FROM User where Phone <> null limit 1];

        
        //return  [SELECT Id,FirstName,LastName,Email,Phone FROM Contact where Phone <> null limit 1];
    }
}
*/