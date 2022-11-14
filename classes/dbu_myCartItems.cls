public class dbu_myCartItems {
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_CartItem__c> getMyCartItems(){
        return [SELECT Id, Name, ccrz__Cart__c, ccrz__Price__c FROM ccrz__E_CartItem__c];
    }
}