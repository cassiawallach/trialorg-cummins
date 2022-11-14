public class dbu_HelperEmailToCustomerTrigger {
    
    public static boolean firstRun = true;
    
    public static void sendEmail(ccrz__E_OrderItem__c oderItems) {
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        //EmailTemplate etCoreReturn=[Select id from EmailTemplate where name=:'dbu_EmailForCoreReturnRejected'];
        EmailTemplate etRefunded=[Select id from EmailTemplate where name=:'dbu_EmailForRefunded'];
        //EmailTemplate et=[Select id from EmailTemplate where name=:'dbu_EmailForReturnRejected'];
        String[] toaddress = new String[]{}; 
        toaddress.add(oderItems.ccrz__Order__r.ccrz__BuyerEmail__c);
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        ccrz__E_OrderItem__c orderItemLst = new ccrz__E_OrderItem__c();
        orderItemLst = [Select Id,ccrz__Order__c,ccrz__Order__r.ccrz__Contact__c,ccrz__Order__r.OwnerId from ccrz__E_OrderItem__c where Id =: oderItems.Id];
        
        User userMap = new User();
        userMap = [Select Id,ContactId from User where Id =: orderItemLst.ccrz__Order__r.OwnerId];
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];      
            if(oderItems.ccrz__Order__r.ccrz__Contact__c == null ){
                mail.setToAddresses(toaddress);
                //mail.setTargetObjectId(oderItems.ccrz__Order__r.ccrz__User__c);
                mail.setTargetObjectId(userMap.ContactId);
            }else{
                mail.setTargetObjectId(oderItems.ccrz__Order__r.ccrz__Contact__c); 
            }
            
            //mail.setSenderDisplayName('Company Support'); 
           // mail.setReplyTo('no-reply@company.com');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setWhatId(oderItems.Id);
        	mail.setOrgWideEmailAddressId(owea[0].Id);
            mail.setSaveAsActivity(false);
            if(oderItems.ccrz__OrderItemStatus__c == 'Refunded'){
                mail.setTemplateID(etRefunded.Id);
            }
            /*else{
                if(oderItems.ccrz__Product__r.dbu_Has_Core_Charge__c == True){
                    mail.setTemplateID(etCoreReturn.Id);
                }else{
                    mail.setTemplateID(et.Id);
                }
            }*/
            //mail.setTemplateID(et.Id);
            mails.add(mail);
            Messaging.sendEmail(mails);
    }
}