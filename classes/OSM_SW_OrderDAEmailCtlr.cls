/*****************************************************************
Name:  OSM_SW_OrderDAEmailCtlr
Copyright © 2018  Cummins
==================================================================
==================================================================
Purpose:                                                            
This controller we are using to send email to DAFinance, controller calling from Flow.
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE              DETAIL                                
1.0 -   Neha Sharma         11/06/2018     INITIAL DEVELOPMENT          

******************************************************************/
Public class OSM_SW_OrderDAEmailCtlr {
     @InvocableMethod(label='SendEmailToDAFinance' description='Returns the list of account names corresponding to the specified account IDs.')
    public static void SendEmailToDAFinance(List<ccrz__E_Order__c> orderList){
         OrgWideEmailAddress orgWideAddress = getOrgWideAddress();
        Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate et = [Select id from EmailTemplate where name = 'OSM Order LineItem Template' limit 1];
        set<String> OrderIds = new Set<String>();
        set<Id> contactId = new Set<Id>();
        for(ccrz__E_Order__c order : orderList){
            OrderIds.add(order.id);
            
        }     
        List<ccrz__E_TransactionPayment__c> tranList = [Select id,ccrz__AccountType__c,ccrz__CCOrder__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c =: OrderIds];
        
        for(ccrz__E_Order__c order : orderList)
        {
            for(ccrz__E_TransactionPayment__c trans : tranList){
                   
           system.debug('$$$BMS ID'+order.BMS_Customer_ID__c);
            if(order.ccrz__OrderStatus__c == Label.OSM_OrderSubmitted && order.BMS_Customer_ID__c!=null){
                if(order.id == trans.ccrz__CCOrder__c && trans.ccrz__AccountType__c == 'po' ){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email = Messaging.renderStoredEmailTemplate(et.id,label.OSM_DAFinance_Contact,order.id);
                 if(orgWideAddress!=null){
                  email.setOrgWideEmailAddressId(orgWideAddress.id);
                 }
                
                email.setSaveAsActivity(false);
                email.setSubject(Label.OSM_FreeTrial_Marketplace +' '+order.Name);
                email.setTemplateId(et.id);
              
                messages.add(email);
                }
            }
            } 
            
        }  
        If(messages.size()>0){
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
        }
    }
    
     public static OrgWideEmailAddress getOrgWideAddress(){
            
            
            List<OrgWideEmailAddress> owLst = new List<OrgWideEmailAddress>([select id, Address, DisplayName from OrgWideEmailAddress where DisplayName=:Label.OSM_emailNoReply]);
            
            OrgWideEmailAddress returnOW=null;
             
            if(owLst!=null && owLst.size()>0){
                returnOW = owLst[0];
            }
            
            return returnOW;
            
    }
    
}