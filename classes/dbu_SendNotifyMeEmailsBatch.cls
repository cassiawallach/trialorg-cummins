global class dbu_SendNotifyMeEmailsBatch implements Database.Batchable<sObject>,Database.stateful{
	string query;
    
    global database.QueryLocator start(database.BatchableContext BatchContext){
             
        query = 'Select id, CC_Product_Name__c, dbu_NotifyMe_Email_Sending_Initiated__c,dbu_Emailer_Email_Address__c, dbu_NotifyMe_Email_Sent__c, dbu_Product_Inventory_Status__c, dbu_Product_Name__c, dbu_Product_Price__c, dbu_Product_URI__c, dbu_Emailer__r.dbu_Store_Country__c, dbu_Emailer__r.dbu_Store_Language__c, dbu_Emailer__r.dbu_Email_for_NotifyMe__c, dbu_Emailer__r.dbu_Email_Contact__c, dbu_Emailer__r.dbu_Contact_Name__c, dbu_Emailer__r.dbu_Contact_Email__c,CurrencyIsoCode  from dbu_Email_Content__c where dbu_Emailer__r.dbu_Email_for_NotifyMe__c = true and dbu_Emailer__r.dbu_Email_for_Wishlist__c = false and dbu_NotifyMe_Email_Sent__c = false and dbu_NotifyMe_Email_Sending_Initiated__c = false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(database.BatchableContext BatchContext, list<dbu_Email_Content__c> emailContentList){
        system.debug('emailContentList >>> ' + emailContentList);
        system.debug('emailContentList size >>> ' + emailContentList.size());
        dbu_NotifyMeCtrl.ProceedToSendNotifyMeEmail(emailContentList);
        
    }
    
    global void finish(Database.BatchableContext BatchContext){
        
    }    
}