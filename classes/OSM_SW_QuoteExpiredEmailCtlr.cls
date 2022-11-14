Public class OSM_SW_QuoteExpiredEmailCtlr {
    
    public static void SendEmail(List<ccrz__E_RequestForQuote__c> quoteList, Map<Id,ccrz__E_RequestForQuote__c> oldmapReq)
    {
        Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate et=[Select id from EmailTemplate where name = 'OSM_RFQ_Email_Template' limit 1];
        for(ccrz__E_RequestForQuote__c quote : quoteList)
        {
            ccrz__E_RequestForQuote__c oldDBvalue = oldmapReq.get(quote.id);
            system.debug('****quotestatus'+quote.Status__c);
              system.debug('****oldDBvalue'+oldDBvalue.Status__c);
            if(quote.Status__c!=oldDBvalue.Status__c && quote.Status__c == 'Expired'){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email = Messaging.renderStoredEmailTemplate(et.id, quote.OwnerId, quote.id);
                email.setTargetObjectId(quote.OwnerId);
                email.setSaveAsActivity(false);
                email.setSubject(Label.OSM_RFQ_Quote_Expired_Sub +' '+quote.CompanyName__c);
                email.setTemplateId(et.id);
                System.debug('email----'+email);
                messages.add(email);
            }
            
            system.debug('$$$$mail sent');
        }  
        If(messages.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
        }
    }
    
}