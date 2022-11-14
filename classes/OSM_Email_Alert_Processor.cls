/************************************************************
Name:  OSM_Email_Alert_Processor 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class is using for Sending email for Invoice Object 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma         25/07/2018     INITIAL DEVELOPMENT          


*************************************************************/
   
global class OSM_Email_Alert_Processor{
List<ccrz__E_Order__c> lstorder = new List<ccrz__E_Order__c>();
List<string> toAddress = new List<string>();
List<string> toUserAddress = new List<string>();
Set<Id> lstOrderids= new set<Id>();

    public OSM_Email_Alert_Processor(){
   // lstorder = [Select id,ccrz__User__c,ccrz__User__r.Email,OwnerId,Order_Cancelled_By_CSR__c,ccrz__Contact__r.Email,ccrz__Contact__r.IAM_Contact_Status__c,name,ccrz__Contact__c,ccrz__Contact__r.CMI_Contact_Type__c,ccrz__OrderStatus__c,ccrz__BuyerEmail__c from ccrz__E_Order__c where id='a1v4C0000000Sl6'];
    }

  /*  public void sendEmail(){
    //Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
    EmailTemplate et=[SELECT Id,name,Body FROM EmailTemplate where name='OSM Order LineItem Template' limit 1];
    for(ccrz__E_Order__c ord : lstorder){
        
        lstOrderids.add(ord.id);
        toAddress.add(ord.ccrz__Contact__r.Email);
        toUserAddress.add(ord.ccrz__User__r.Email);
        if(ord.ccrz__OrderStatus__c == 'Order Submitted' && ord.ccrz__User__c == Userinfo.getUserId() && ord.ccrz__Contact__r.CMI_Contact_Type__c=='Primary' && ord.ccrz__Contact__r.IAM_Contact_Status__c=='Active'){  
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(ord.ccrz__User__c);
            email.setToAddresses(toAddress);
            email.setWhatId(ord.Id);
            email.setSaveAsActivity(false);
            email.setSubject('Your Cummins Marketplace Order'+ord.name);
            email.setTemplateId(et.id);
            System.debug('email----'+email);
            messages.add(email);
        }
        
          if(ord.ccrz__OrderStatus__c == 'Order Submitted' && ord.ccrz__User__c != Userinfo.getUserId() && ord.ccrz__Contact__r.IAM_Contact_Status__c=='Active'){  
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(ord.ccrz__User__c);
            email.setToAddresses(toAddress);
            email.setCcAddresses(toUserAddress);
            email.setWhatId(ord.Id);
            email.setSaveAsActivity(false);
            email.setSubject('Your Cummins Marketplace Order'+ord.name);
            email.setTemplateId(et.id);
            System.debug('email----'+email);
            messages.add(email);
        }
        
        if(ord.ccrz__OrderStatus__c == 'Cancelled' && ord.Order_Cancelled_By_CSR__c == ord.OwnerId && ord.ccrz__Contact__r.CMI_Contact_Type__c=='Primary' && ord.ccrz__Contact__r.IAM_Contact_Status__c=='Active'){  
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(ord.ccrz__User__c);
            email.setToAddresses(toAddress);
            email.setWhatId(ord.Id);
            email.setSaveAsActivity(false);
            email.setSubject('Your Cummins Marketplace Order Cancellation'+ord.name);
            email.setTemplateId(et.id);
            System.debug('email----'+email);
            messages.add(email);
        }
        if(ord.ccrz__OrderStatus__c == 'Cancelled' && ord.Order_Cancelled_By_CSR__c != ord.OwnerId && ord.ccrz__Contact__r.CMI_Contact_Type__c=='Primary' && ord.ccrz__Contact__r.IAM_Contact_Status__c=='Active'){  
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(ord.ccrz__User__c);
            email.setToAddresses(toAddress);
            email.setCcAddresses(toUserAddress);
            email.setWhatId(ord.Id);
            email.setSaveAsActivity(false);
            email.setSubject('Your Cummins Marketplace Order Cancellation'+ord.name);
            email.setTemplateId(et.id);
            System.debug('email----'+email);
            messages.add(email);
        }
    }
     Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
} 
*/


public static List<OSM_Integration_Log__c> sendRecurringInvoiceEmails(Map<String,Map<String,String>> invoiceIdVsEmailMap){
Map<Id,ccrz__E_Invoice__c> invoiceMapDb = new Map<Id,ccrz__E_Invoice__c>();
Set<Id> invoiceids= new set<Id>();
Set<Id> accIDSet  = new Set<Id>();
List<Contact> conList  = new List<Contact>();
List<OSM_Integration_Log__c> osmLogLst = new List<OSM_Integration_Log__c>();
 
invoiceMapDb= new Map<Id,ccrz__E_Invoice__c>([select id, name,ccrz__BillTo__c, Recurring_Invoice__c,ccrz__User__c from ccrz__E_Invoice__c where id in :invoiceIdVsEmailMap.keySet() and Recurring_Invoice__c=true]);

/*
List<String> allEmailLst = new List<String>();
for(String invId : invoiceIdVsEmailMap.keySet())
{
   Map<String,String> emailMap = invoiceIdVsEmailMap.get(invId);
   allEmailLst.addAll(emailMap.keySet());
   if(invoiceMapDb.containsKey(invId))
   {
        ccrz__E_Invoice__c invDB =  invoiceMapDb.get(invId);
        accIDSet.add(invDB.ccrz__BillTo__c);
   }
  
}
*/
List<String> contactIdLst  = new List<String>();
for(String invId : invoiceIdVsEmailMap.keySet())
{
   Map<String,String> emailMap = invoiceIdVsEmailMap.get(invId);
   contactIdLst.addAll(emailMap.values());
}

        


    if(!Test.isRunningTest()){
//conList = [select id,name,Email,IAM_Contact_Status__c,AccountId,account.OSM_Preferred_Payment_Method__c from contact where AccountId in :accIDSet and Email in:allEmailLst and IAM_Contact_Status__c='Active'];
conList = [select id,name,Email,IAM_Contact_Status__c,AccountId,account.OSM_Preferred_Payment_Method__c,account.BMS_Customer_ID__c from contact where id in:contactIdLst and IAM_Contact_Status__c='Active'];
    }
    else{
        conList = [select id,name,Email,IAM_Contact_Status__c,AccountId,account.OSM_Preferred_Payment_Method__c,account.BMS_Customer_ID__c  from contact where AccountId != null limit 1];
    }
System.debug('conList==='+conList);
Map<Id,List<String>> accIdVsContactMap = new Map<Id,List<String>>();
Map<Id,List<String>> accIdVsContactIdMap = new Map<Id,List<String>>();
Map<Id,String> accIdVsPaymentMethod = new Map<Id,String>();
Map<Id,String> accIdVsBMSNo = new Map<Id,String>();
for(Contact cc : conList){


    if(!accIdVsPaymentMethod.containsKey(cc.accountId))
    {
        accIdVsPaymentMethod.put(cc.accountId,cc.account.OSM_Preferred_Payment_Method__c);
        accIdVsBMSNo.put(cc.accountId,cc.account.BMS_Customer_ID__c);
    }
    System.debug('accIdVsPaymentMethod===='+accIdVsPaymentMethod);
    System.debug('accIdVsBMSNo===='+accIdVsBMSNo);
    if(!accIdVsContactMap.containsKey(cc.accountId))
    {   
       //accIdVsContactMap.put(cc.accountId).add(cc.email); 
        accIdVsContactMap.put(cc.accountId,new List<String>{cc.email}); 
        accIdVsContactIdMap.put(cc.accountId,new List<String>{cc.id});
        system.debug('inside if map>>>'+accIdVsContactMap);
       
    }
    else{
    accIdVsContactMap.get(cc.accountId).add(cc.email);
    accIdVsContactIdMap.get(cc.accountId).add(cc.id);
         system.debug('inside else map>>>'+accIdVsContactMap);
    }
    
}

    OrgWideEmailAddress orgWideAddress = getOrgWideAddress();
 Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
 List<String> emailName = new List<String>{'OSM_Recurring_Invoice_PO','OSM_Recurring_Invoice_CC'};
 
    List<EmailTemplate> etLst=[SELECT Id,name,Body FROM EmailTemplate where name in :emailName];
    
    if(etLst==null || (etLst!=null && etLst.size()!=2))
    {
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Error_Description__c = 'Email Templates For Recurring Invoice not found in the system.';
        log.Service_Name__c='Email:'+Label.OSM_Recurring_Invoice_Process;
        log.Status__c = 'Fail';
        osmLogLst.add(log);
        return osmLogLst;
    }
    
    String poEmailTemplate = '';
    String ccEmailTemplate = '';
    for(EmailTemplate emailTemp : etLst)
    {
      if(emailTemp.name=='OSM_Recurring_Invoice_PO')
      {
        poEmailTemplate = emailTemp.id;
      }
      else if(emailTemp.name=='OSM_Recurring_Invoice_CC')
      {
        ccEmailTemplate = emailTemp.id;
      }
    }
    
    
    for(String invId:invoiceIdVsEmailMap.keySet()){
    system.debug('invoiceMapDb>>>>>'+invoiceMapDb);
    ccrz__E_Invoice__c inc = invoiceMapDb.get(invId);
    system.debug('accIdVsContactMap>>>>'+accIdVsContactMap);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(!accIdVsContactMap.isEmpty() && accIdVsContactMap.containskey(inc.ccrz__BillTo__c))
        {
            List<String> conLst = accIdVsContactMap.get(inc.ccrz__BillTo__c);
            mail.setToAddresses(conLst);
            if(orgWideAddress!=null){
                mail.setOrgWideEmailAddressId(orgWideAddress.id);
            }
            //mail.setTargetObjectId(inc.ccrz__User__c);
            mail.setWhatId(inc.id);
            mail.setSaveAsActivity(false);
             String emailTemplateId ='';
            if(accIdVsPaymentMethod.containsKey(inc.ccrz__BillTo__c))
            {
               String paymentMethod =   accIdVsPaymentMethod.get(inc.ccrz__BillTo__c);
               system.debug('paymentMethod>>>>'+paymentMethod);
              
               if(paymentMethod=='po')
               {
                  system.debug('poEmailTemplate>>>>'+poEmailTemplate);
                  emailTemplateId = poEmailTemplate;
                    mail.setTemplateId(poEmailTemplate);
                   
               }
               else if(paymentMethod=='cc')
               {
                    mail.setTemplateId(ccEmailTemplate);
                     emailTemplateId = ccEmailTemplate;
                    
               }
               else{
                   OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                    log.Error_Description__c = 'Payment_Method_not_found_on_Account_in_the_system';
                    log.Service_Name__c='Email:'+Label.OSM_Recurring_Invoice_Process;
                    log.Account__c  = inc.ccrz__BillTo__c;
                    log.Status__c = 'Fail';
                    osmLogLst.add(log);
                    continue;
                   
                   
               }
            }
            for(Id conId : accIdVsContactIdMap.get(inc.ccrz__BillTo__c))
            {
            
                Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(emailTemplateId, conId, inc.id);
                if(orgWideAddress!=null){
                    email.setOrgWideEmailAddressId(orgWideAddress.id);
                }
                
                if(accIdVsPaymentMethod.get(inc.ccrz__BillTo__c)=='po'){
                System.debug('inside accIdVsBMSNo.get(inc.ccrz__BillTo__c)  ===='+accIdVsBMSNo.get(inc.ccrz__BillTo__c) +'=='+inc.ccrz__BillTo__c);
                   if(accIdVsBMSNo.get(inc.ccrz__BillTo__c) != null && String.isNotBlank(accIdVsBMSNo.get(inc.ccrz__BillTo__c))){
                       //email.setBccAddresses(new List<String> {Label.OSM_SW_DAFinanceEmail});
                       //
                       //Label.OSM_SW_DAFinanceEmail1
                       Messaging.SingleEmailMessage daFinanceEmail = Messaging.renderStoredEmailTemplate(emailTemplateId, Label.OSM_DAFinance_Contact, inc.id);
                       messages.add(daFinanceEmail);
                       System.debug('mail inside PO ===='+daFinanceEmail);
                   }
                }
                messages.add(email);
            }
          
             //messages.add(mail);
            
            
             //email.setToAddresses(conLst);
             //messages.add(email);
            
            //mails.add(mail);
            System.debug('mail----'+mail);
        }
    }
        if(messages.size()>0)
        {
         Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);  
         for(Messaging.SendEmailResult result : results)
         {
               System.debug('mail result:'+result);
                if (!result.isSuccess()) {
                    
                    System.StatusCode statusCode = result.getErrors()[0].getStatusCode();
                    String errorMessage = result.getErrors()[0].getMessage();
                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                    log.Invoice__c = result.getErrors()[0].TargetObjectId;
                    log.Error_Description__c = 'Payment_Method_not_found_on_Account_in_the_system';
                    log.Service_Name__c='Email:'+Label.OSM_Recurring_Invoice_Process;
                    log.Status__c = 'Fail';
                    osmLogLst.add(log);
            
            }
            
            
         }
         
        } 

    return osmLogLst;
}
 
    public static OrgWideEmailAddress getOrgWideAddress(){
            
            
            List<OrgWideEmailAddress> owLst = new List<OrgWideEmailAddress>([select id, Address, DisplayName from OrgWideEmailAddress where DisplayName='noreply.identity@cummins.com']);
            
            OrgWideEmailAddress returnOW=null;
             
            if(owLst!=null && owLst.size()>0){
                returnOW = owLst[0];
            }
            
            return returnOW;
            
    }
   
    
    
}