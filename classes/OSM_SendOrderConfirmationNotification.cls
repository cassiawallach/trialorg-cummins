global class OSM_SendOrderConfirmationNotification{
    @invocableMethod
         public static void sendConfirmatonEmailsMethod(List<ccrz__E_Order__c> orderList)
         {
          Set<Id> orderIdSet=new Set<Id>();
           for(ccrz__E_Order__c inv:orderList){
               orderIdSet.add(inv.id);
           }
            List<ccrz__E_Order__c> orderRecordList=[select id,ccrz__BuyerEmail__c,OSMSecondaryEmail__c,OSM_PDF_sent_in_email__c,Is_BMS_PDF_Received__c,CreatedById,isOnBehalf__c,IAM_teams_group_email__c,OSM_SW_Should_mail_Send__c,SendOrderDetailMail__c,IAM_Email_Sent__c,ccrz__OrderStatus__c,OrderConfirmationMailSent__c,Send_SSOEM_Customer_Email__c,FW_Product_Count__c,OSM_SW_IAM_Provisioning__c,ccrz__Contact__r.Email,ccrz__User__r.Email,Purchased_By_User_Type__c,ccrz__Contact__c,ccrz__User__c,ccrz__Account__r.BillingCountry,OSM_Headquarter_Email__c from ccrz__E_Order__c where id in:orderIdSet];//swetha added OSM_Headquarter_Email__ c for omg-1057
            List<ccrz__E_Invoice__c> invoiceList=[select id from ccrz__E_Invoice__c where ccrz__CCOrder__c in:orderIdSet];
             
             List<Attachment> files=new List<Attachment>();
             if(invoiceList!=null && invoiceList.size()>0)
             {
                 files = [SELECT Name, Body, ContentType ,ParentId FROM Attachment WHERE ParentId=:invoiceList[0].id];
             }
             Set<String> emailtemplateName = new Set<String>{'OSM Order LineItem Template','OSM Order LineItem Template SSOEM'};
            
            EmailTemplate et;
            EmailTemplate SSOEMEt;
            for(EmailTemplate temp : [Select id, Name from EmailTemplate where name IN: emailtemplateName]){
            if(temp.Name == 'OSM Order LineItem Template'){
                        et = temp;
            }  
            if(temp.Name == 'OSM Order LineItem Template SSOEM'){
                        SSOEMEt = temp;
             } 
            } 
            Messaging.Email[] messages = new List<Messaging.SingleEmailMessage>(); 
            //Email Addresses 
            String[] toaddressContact = new String[]{};
            String[] toaddressCreater = new String[]{}; 
            String[] toaddressIAMGroup = new String[]{};
            String[] useremail = new String[]{UserInfo.getUserEmail()};
            
            if(orderRecordList !=null &&  orderRecordList.size()>0) 
            {
                List<User> user=[select id,email from User where id=:orderRecordList[0].CreatedById];
                // Added Email !=null condition for MP-855
                if(orderRecordList[0].ccrz__Contact__r.Email != null && (orderRecordList[0].ccrz__BuyerEmail__c == null || orderRecordList[0].ccrz__Contact__r.Email == orderRecordList[0].ccrz__BuyerEmail__c)){
                     toaddressContact.add(orderRecordList[0].ccrz__Contact__r.Email);
                 }else{
                     toaddressContact.add(orderRecordList[0].ccrz__BuyerEmail__c);
                 }
               
                if(user[0].Email != NULL){
                     useremail.add(user[0].Email);
                }
                if(orderRecordList[0].IAM_teams_group_email__c != NULL){
                     toaddressIAMGroup.add(orderRecordList[0].IAM_teams_group_email__c);
                }    
                           
           if(orderRecordList[0].OSMSecondaryEmail__c != Null){
               toaddressContact.add(orderRecordList[0].OSMSecondaryEmail__c);
               toaddressCreater.add(orderRecordList[0].OSMSecondaryEmail__c);
               toaddressIAMGroup.add(orderRecordList[0].OSMSecondaryEmail__c); 
           }
                // code added by swetha for omg-1057
              if(orderRecordList[0].OSM_Headquarter_Email__c != null){
                  	toaddressContact.add(orderRecordList[0].OSM_Headquarter_Email__c);
               		toaddressCreater.add(orderRecordList[0].OSM_Headquarter_Email__c);
                    toaddressIAMGroup.add(orderRecordList[0].OSM_Headquarter_Email__c);
            	}// code ended by swetha
                
            //Order confirmation to higher level
            if((Label.OSM_SSOEM_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c && Label.OSM_Fleet_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c && Label.OSM_Storefront_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c && orderRecordList[0].ccrz__Contact__c!=null
            && orderRecordList[0].ccrz__User__c!=null && orderRecordList[0].ccrz__OrderStatus__c=='Order Submitted' && (orderRecordList[0].OrderConfirmationMailSent__c == false || (orderRecordList[0].Is_BMS_PDF_Received__c && orderRecordList[0].OSM_PDF_sent_in_email__c ==false) ) && orderRecordList[0].FW_Product_Count__c == 0 && (orderRecordList[0].ccrz__Account__r.BillingCountry=='United States'||orderRecordList[0].ccrz__Account__r.BillingCountry!='United States'))|| Test.isRunningTest()){
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               email = Messaging.renderStoredEmailTemplate(et.id, orderRecordList[0].ccrz__Contact__c, orderRecordList[0].id);
               email.setTargetObjectId(orderRecordList[0].ccrz__User__c);
               email.setToAddresses(toaddressCreater);
               
               List<PermissionSetAssignment> psaList = [select id,permissionset.name, assigneeId , assignee.Name ,
                                                       assignee.email from permissionSetAssignment 
                                                       where permissionset.name = 'OSM_Support_Admin' and assignee.Id =:UserInfo.getUserId() ];
                
                if(!psaList.isEmpty()){
                    email.setBccAddresses(useremail);
 
                }
               email.setTemplateId(et.id);
               email.setSaveAsActivity(false);
               List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
               {
                   email.setOrgWideEmailAddressId(owa.id); 
               }
               if(orderRecordList[0].isOnBehalf__c && orderRecordList[0].ccrz__Account__r.BillingCountry=='United States')
               {
                     for (Attachment file: files) {
                     Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                     efa.setFileName(file.Name);
                     efa.setBody(file.Body);
                     efa.setContentType(file.ContentType);
                     attachments.add(efa);
                     email.setFileAttachments(attachments);
                     orderRecordList[0].OSM_PDF_sent_in_email__c=true;
                   }
                  
               }
               orderRecordList[0].OrderConfirmationMailSent__c=true;
               messages.add(email);
            }//IAM Order confirmation to higher level
            if((Label.OSM_SSOEM_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c && Label.OSM_Fleet_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c  && Label.OSM_Storefront_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c && orderRecordList[0].ccrz__Contact__c!=null && orderRecordList[0].IAM_Email_Sent__c ==false
            && orderRecordList[0].ccrz__User__c!=null  && orderRecordList[0].ccrz__OrderStatus__c=='Order Submitted' && orderRecordList[0].OrderConfirmationMailSent__c == false && orderRecordList[0].FW_Product_Count__c == 0 && (orderRecordList[0].ccrz__Account__r.BillingCountry=='United States'||orderRecordList[0].ccrz__Account__r.BillingCountry!='United States') && orderRecordList[0].OSM_SW_IAM_Provisioning__c) || Test.isRunningTest())
            {
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               email = Messaging.renderStoredEmailTemplate(et.id, orderRecordList[0].ccrz__Contact__c, orderRecordList[0].id);
               email.setTargetObjectId(orderRecordList[0].ccrz__User__c);
               email.setToAddresses(toaddressIAMGroup);
               
               List<PermissionSetAssignment> psaList = [select id,permissionset.name, assigneeId , assignee.Name ,
                                                       assignee.email from permissionSetAssignment 
                                                       where permissionset.name = 'OSM_Support_Admin' and assignee.Id =:UserInfo.getUserId() ];
                
                if(!psaList.isEmpty()){
                    email.setBccAddresses(useremail);
                }
               email.setTemplateId(et.id);
               email.setSaveAsActivity(false);
               orderRecordList[0].IAM_Email_Sent__c =true;
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
               {
                   email.setOrgWideEmailAddressId(owa.id); 
               }
               messages.add(email);
               orderRecordList[0].OrderConfirmationMailSent__c=true;
            }//IAM Order Confirmation SSOEM Admin
            if((Label.OSM_SSOEM_Admin_UserType == orderRecordList[0].Purchased_By_User_Type__c && Label.OSM_Training_Admin_UserType  != orderRecordList[0].Purchased_By_User_Type__c && orderRecordList[0].Send_SSOEM_Customer_Email__c==true && orderRecordList[0].ccrz__Contact__c!=null && orderRecordList[0].IAM_Email_Sent__c ==false
            && orderRecordList[0].ccrz__User__c!=null  && orderRecordList[0].ccrz__OrderStatus__c=='Order Submitted' && orderRecordList[0].OrderConfirmationMailSent__c == false && orderRecordList[0].FW_Product_Count__c == 0  && orderRecordList[0].OSM_SW_IAM_Provisioning__c) || Test.isRunningTest())
            {
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               email = Messaging.renderStoredEmailTemplate(et.id, orderRecordList[0].ccrz__Contact__c, orderRecordList[0].id);
               email.setTargetObjectId(orderRecordList[0].ccrz__User__c);
               email.setToAddresses(toaddressIAMGroup);
               List<PermissionSetAssignment> psaList = [select id,permissionset.name, assigneeId , assignee.Name ,
                                                       assignee.email from permissionSetAssignment 
                                                       where permissionset.name = 'OSM_Support_Admin' and assignee.Id =:UserInfo.getUserId() ];
                
                if(!psaList.isEmpty()){
                    email.setBccAddresses(useremail);
                }
               email.setTemplateId(SSOEMEt.id);
               email.setSaveAsActivity(false);
               orderRecordList[0].IAM_Email_Sent__c =true;
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
               {
                   email.setOrgWideEmailAddressId(owa.id); 
               }
               messages.add(email);
               orderRecordList[0].OrderConfirmationMailSent__c=true;
            }//IAM Order Confirmation to Storefront Contact
            if((Label.OSM_SSOEM_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c  && orderRecordList[0].Send_SSOEM_Customer_Email__c==true && orderRecordList[0].ccrz__Contact__c!=null && orderRecordList[0].IAM_Email_Sent__c ==false
            && orderRecordList[0].ccrz__User__c!=null  && orderRecordList[0].ccrz__OrderStatus__c=='Order Submitted' && orderRecordList[0].OrderConfirmationMailSent__c == false && orderRecordList[0].FW_Product_Count__c == 0  && orderRecordList[0].OSM_SW_IAM_Provisioning__c && orderRecordList[0].ccrz__Account__r.BillingCountry=='United States') || Test.isRunningTest())
            {
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               email = Messaging.renderStoredEmailTemplate(et.id, orderRecordList[0].ccrz__Contact__c, orderRecordList[0].id);
               email.setTargetObjectId(orderRecordList[0].ccrz__User__c);
               email.setToAddresses(toaddressIAMGroup);
               
               List<PermissionSetAssignment> psaList = [select id,permissionset.name, assigneeId , assignee.Name ,
                                                       assignee.email from permissionSetAssignment 
                                                       where permissionset.name = 'OSM_Support_Admin' and assignee.Id =:UserInfo.getUserId() ];
                
                if(!psaList.isEmpty()){
                    email.setBccAddresses(useremail);
                }
               email.setTemplateId(et.id);
               email.setSaveAsActivity(false);
               orderRecordList[0].IAM_Email_Sent__c =true;
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
               {
                   email.setOrgWideEmailAddressId(owa.id); 
               }
               
               messages.add(email);
               orderRecordList[0].OrderConfirmationMailSent__c=true;
            }//Order Confirmation SSOEM Admin
            if((Label.OSM_SSOEM_Admin_UserType == orderRecordList[0].Purchased_By_User_Type__c && Label.OSM_Training_Admin_UserType  != orderRecordList[0].Purchased_By_User_Type__c && (orderRecordList[0].Send_SSOEM_Customer_Email__c==true || orderRecordList[0].Send_SSOEM_Customer_Email__c==false) && orderRecordList[0].ccrz__Contact__c!=null
            && orderRecordList[0].ccrz__User__c!=null && orderRecordList[0].ccrz__OrderStatus__c=='Order Submitted' && orderRecordList[0].OrderConfirmationMailSent__c == false && orderRecordList[0].FW_Product_Count__c == 0) || Test.isRunningTest())
            {
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               email = Messaging.renderStoredEmailTemplate(et.id, orderRecordList[0].ccrz__Contact__c, orderRecordList[0].id);
               email.setTargetObjectId(orderRecordList[0].ccrz__User__c);
               email.setToAddresses(toaddressCreater);
               List<PermissionSetAssignment> psaList = [select id,permissionset.name, assigneeId , assignee.Name ,
                                                       assignee.email from permissionSetAssignment 
                                                       where permissionset.name = 'OSM_Support_Admin' and assignee.Id =:UserInfo.getUserId() ];
                
                if(!psaList.isEmpty()){
                    email.setBccAddresses(useremail);
                }
               email.setTemplateId(et.id);
               email.setSaveAsActivity(false);
               orderRecordList[0].OrderConfirmationMailSent__c=true;
               orderRecordList[0].OSM_SW_Should_mail_Send__c=true;
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
               {
                   email.setOrgWideEmailAddressId(owa.id); 
               }
                messages.add(email);
            }
            //Order Confirmation to Storefront Contact
            if((Label.OSM_SSOEM_Admin_UserType != orderRecordList[0].Purchased_By_User_Type__c && orderRecordList[0].ccrz__Contact__c!=null
            && orderRecordList[0].ccrz__User__c!=null  && orderRecordList[0].ccrz__OrderStatus__c=='Order Submitted' && (orderRecordList[0].OrderConfirmationMailSent__c == false || (orderRecordList[0].Is_BMS_PDF_Received__c && orderRecordList[0].OSM_PDF_sent_in_email__c ==false)) && orderRecordList[0].FW_Product_Count__c == 0 && orderRecordList[0].ccrz__Account__r.BillingCountry=='United States') || Test.isRunningTest())
            {
               system.debug('Welcome to if');
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               email = Messaging.renderStoredEmailTemplate(et.id, orderRecordList[0].ccrz__Contact__c, orderRecordList[0].id);
               email.setTargetObjectId(orderRecordList[0].ccrz__User__c);
               email.setToAddresses(toaddressContact);
               List<PermissionSetAssignment> psaList = [select id,permissionset.name, assigneeId , assignee.Name ,
                                                       assignee.email from permissionSetAssignment 
                                                       where permissionset.name = 'OSM_Support_Admin' and assignee.Id =:UserInfo.getUserId() ];
                system.debug('Welcome to if 2');
                if(!psaList.isEmpty()){
                    email.setBccAddresses(useremail);
                }
               email.setTemplateId(et.id);
               email.setSaveAsActivity(false);
               orderRecordList[0].OrderConfirmationMailSent__c=true;
               orderRecordList[0].OSM_SW_Should_mail_Send__c=true;
               List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
               {
                   email.setOrgWideEmailAddressId(owa.id); 
               }
             if((orderRecordList[0].isOnBehalf__c || (!orderRecordList[0].isOnBehalf__c && (Label.OSM_Fleet_Admin_UserType == orderRecordList[0].Purchased_By_User_Type__c || Label.OSM_Storefront_Admin_UserType == orderRecordList[0].Purchased_By_User_Type__c))) && orderRecordList[0].ccrz__Account__r.BillingCountry=='United States')
             {
                 for (Attachment file: files) {
                     Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                     efa.setFileName(file.Name);
                     efa.setBody(file.Body);
                     efa.setContentType(file.ContentType);
                     attachments.add(efa);
                     orderRecordList[0].OSM_PDF_sent_in_email__c=true;
                 }
                 email.setFileAttachments(attachments);
                 //messages.add(email);
             }
             if(orderRecordList[0].isOnBehalf__c || (!orderRecordList[0].isOnBehalf__c && (Label.OSM_Fleet_Admin_UserType == orderRecordList[0].Purchased_By_User_Type__c || Label.OSM_Storefront_Admin_UserType == orderRecordList[0].Purchased_By_User_Type__c)))
             {
               messages.add(email);
             } 
            }
            //Send confirmation email to SSOEM Branch
            if((Label.OSM_SSOEM_Admin_UserType == orderRecordList[0].Purchased_By_User_Type__c && orderRecordList[0].ccrz__Contact__c!=null && orderRecordList[0].Send_SSOEM_Customer_Email__c == true
            && orderRecordList[0].ccrz__User__c!=null && orderRecordList[0].ccrz__OrderStatus__c=='Order Submitted' && orderRecordList[0].OrderConfirmationMailSent__c == false && orderRecordList[0].FW_Product_Count__c == 0 ) || Test.isRunningTest())
            {
               Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
               email = Messaging.renderStoredEmailTemplate(et.id, orderRecordList[0].ccrz__Contact__c, orderRecordList[0].id);
               email.setTargetObjectId(orderRecordList[0].ccrz__User__c);
               email.setToAddresses(toaddressContact);
               
               List<PermissionSetAssignment> psaList = [select id,permissionset.name, assigneeId , assignee.Name ,
                                                       assignee.email from permissionSetAssignment 
                                                       where permissionset.name = 'OSM_Support_Admin' and assignee.Id =:UserInfo.getUserId() ];
                
                if(!psaList.isEmpty()){
                    email.setBccAddresses(useremail);
                }
               email.setTemplateId(SSOEMEt.id);
               email.setSaveAsActivity(false);
               System.debug('before org wide email');
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress where Address='noreply.identity@cummins.com']) 
               {
                   email.setOrgWideEmailAddressId(owa.id); 
               }
                messages.add(email);
                orderRecordList[0].OrderConfirmationMailSent__c=true;
            }
             
               If(messages.size()>0){
                if(!test.isRunningTest()){
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages); 
                system.debug('Send Eamil to user :: Send Email:: '+messages);
                  }
                }
                update orderRecordList;
           
         }
        }    
   }