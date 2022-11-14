public class OSM_FW_Order_Item_Cancelation_Alert {
   
    @InvocableMethod(label='Send Cancellation mail alert for FW Order Item' description='Send Cancellation mail alert for FW Order Item')
    public static List<ID> OSM_FW_Order_Item_Cancelation_Alert_Send_Mail(List<Id> orderIds){
     
        List<ccrz__E_OrderItem__c> lstItem = new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_Order__c> list_lstordr = new List<ccrz__E_Order__c>([select id,name,ccrz__Contact__c,ccrz__User__c,isOnBehalf__c ,ccrz__Account__r.Name,ccrz__Account__r.IAM_Service_Provider_Code__c, 
                                    (select id,Group_Name__c,ccrz__Order__r.ccrz__Contact__r.Email,
                                        ccrz__Order__r.ccrz__User__c from ccrz__E_OrderItems__r 
                                        where ccrz__OrderItemStatus__c='Cancelled' AND OrderItemConfirmationMailSent__c = false) 
                                    from  ccrz__E_Order__c where id=:orderIds AND Partial_Cancellation__c > 0]);
        
        if(list_lstordr.size() > 0 && list_lstordr.get(0).ccrz__E_OrderItems__r.size() > 0){
            ccrz__E_Order__c lstordr = list_lstordr.get(0);
            lstItem = lstordr.ccrz__E_OrderItems__r;                             
           
            Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>();
            //List<string> toaddress = new List<string>();        
            //toaddress.add(lstordr.ccrz__Contact__c);
            String userName = UserInfo.getUserName();
            User activeUser = [Select Email From User where Username = : userName limit 1];
            String userEmail = activeUser.Email;
            List<string> toaddress = new List<string>();        
            toaddress.add(userEmail);
             
            List<OrgWideEmailAddress> list_OWA = new List<OrgWideEmailAddress>([select id, Address, DisplayName FROM OrgWideEmailAddress 
                                                                                    where DisplayName='noreply.identity@cummins.com']);
            if(lstordr.isOnBehalf__c== True){
            
            EmailTemplate templateId = [Select id from EmailTemplate where name = 'OSM FW Order LineItem Cancellation Temp1'];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email = Messaging.renderStoredEmailTemplate(templateId.Id, lstordr.ccrz__Contact__c, lstordr.id);
                //email.setTargetObjectId(lstordr.ccrz__User__c); 
                email.setTargetObjectId(lstordr.ccrz__Contact__c);              
                email.setTemplateID(templateId.Id);
              //email.setTemplateId('00X1F000002Ic8U');               
                email.setSaveAsActivity(false);
                email.setToAddresses(toaddress);
                email.setWhatId(lstordr.id);
                
                if(list_OWA.size() > 0){
                    email.setOrgWideEmailAddressId(list_OWA.get(0).id); 
                }
                        
                //email.setSubject('Cummins Marketplace Order Cancellation:' +' '+ lstordr.Name);
                email.setSubject(lstordr.ccrz__Account__r.Name+'('+lstordr.ccrz__Account__r.IAM_Service_Provider_Code__c+'):'+'Cummins Marketplace Order Cancellation:' +' '+ lstordr.Name);
                messages.add(email);
            } 
            else{
            EmailTemplate templateId = [Select id from EmailTemplate where name = 'OSM FW Order LineItem Cancellation Temp1'];
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email = Messaging.renderStoredEmailTemplate(templateId.Id, lstordr.ccrz__Contact__c, lstordr.id);
                //email.setTargetObjectId(lstordr.ccrz__User__c);
                email.setTargetObjectId(lstordr.ccrz__Contact__c);
                email.setTemplateID(templateId.Id);
              //email.setTemplateId('00X1F000002Ic8U');                
                email.setSaveAsActivity(false);
                email.setWhatId(lstordr.id);
                
                if(list_OWA.size() > 0){
                    email.setOrgWideEmailAddressId(list_OWA.get(0).id); 
                }
              
                System.debug('email-if3---'+email);
                //email.setSubject('Cummins Marketplace Order Cancellation:' +' '+ lstordr.Name);
                email.setSubject(lstordr.ccrz__Account__r.Name+'('+lstordr.ccrz__Account__r.IAM_Service_Provider_Code__c+'):'+'Cummins Marketplace Order Cancellation:' +' '+ lstordr.Name);
               
                messages.add(email);
        
            }
            If(messages.size()>0){          
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);                         
                system.debug('Send Eamil to user'+messages);          
            }

            for(ccrz__E_OrderItem__c ListOrderItems : lstItem){            
                ListOrderItems.OrderItemConfirmationMailSent__c=true;
            }
            update lstItem;
        }    
        return null;    
    }
}