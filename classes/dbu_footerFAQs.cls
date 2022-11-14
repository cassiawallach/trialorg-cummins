public class dbu_footerFAQs {
    /**
* Author : Mounika V
* Created on 12th October 2020
* Description : This class will fetch the FAQs
*/
    
    @AuraEnabled(cacheable=true)
    public static Map<String,List<dbu_FAQ__c>> fetchFAQsName(){
        Map<String,List<dbu_FAQ__c>> faqMap = new Map<String,List<dbu_FAQ__c>>();
        for(dbu_FAQ__c faqObj : [SELECT Id,Question__c,Answer__c,FAQCategory__c FROM dbu_FAQ__c]) {
            if(faqMap.containsKey(faqObj.FAQCategory__c)) {
                List<dbu_FAQ__c> faqList = faqMap.get(faqObj.FAQCategory__c);
                faqList.add(faqObj);
                faqMap.put(faqObj.FAQCategory__c, faqList);
            } else {
                faqMap.put(faqObj.FAQCategory__c, new List<dbu_FAQ__c> { faqObj });
            }
        }
        return faqMap;
    }
}