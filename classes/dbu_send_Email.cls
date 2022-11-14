public class dbu_send_Email{

    @InvocableMethod(label='ForMailSend' description='yourDescription')
    public static void toSendMailForReturn(List<Id> orderIds)
    {
        dbuSendMailForReturn(orderIds);
   }
   
    public static void dbuSendMailForReturn(List<Id> lstOrderId)
    {
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents'];
        List<ccrz__E_Order__c> listOrders = new List<ccrz__E_Order__c>();
        Map < String, List < ccrz__E_OrderItem__c >> mapOrderItemList = new Map < String, List < ccrz__E_OrderItem__c >> ();
        listOrders =[Select id,name,CC_Order__c,dbu_StoreLocationAddress__c,ccrz__User__c,ccrz__Note__c,dbu_Dropoff_Location__c,ccrz__ShipTo__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__PostalCode__c, ccrz__Contact__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__BuyerEmail__c,ccrz__BuyerMobilePhone__c,
        (Select id,Name,ccrz__Product__c,dbu_Estimated_Return_Amount__c,ccrz__Price__c,ccrz__AbsoluteDiscount__c,ccrz__Product_Name__c,ccrz__Product__r.dbu_GenuinePart__c,ccrz__Quantity__c,Vertex_Tax__c,dbu_Dropoff_Location__c,
        ccrz__Order__r.ccrz__Account__c, ccrz__OrderItemStatus__c,dbu_Reason_for_Return__c,ccrz__ItemTotal__c,dbu_Is_return_mail_sent__c,dbu_Shipto__c from ccrz__E_OrderItems__r where ccrz__OrderItemStatus__c = 'Return Initiated' and dbu_Is_return_mail_sent__c = false) from ccrz__E_Order__c where id IN: lstOrderId And CC_Order__c != Null];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        String shippingIns = '<h3>Return Shipping Instructions:</h3><strong>Here is what you need to do next:</strong> ' + 
    '<ul><li> Pack the item(s) you are returning. </li><li> Print and include the return document inside your return package.</li><li> Ship back to the appropriate location.</li><li> Use a carrier/shipper that provides package tracking capability. This is vital for resolving any dispute related to the return to Cummins; it also provides a record of the return date. </li><li>  Be sure to cover any prior shipping labels on the package. </li></ul>'+ 
    '<h6>Reminders:</h6> '+
    '<ul><li>Eligible parts can be returned for up to 30 days from the date of purchase. Products purchased on shop.cummins,com must be returned in saleable condition — in other words, unused, in the original packaging, and undamaged. Please note, all accepted returns will incur a 15% handling fee. </li><li>If Cummins shipped the wrong product or the product is damaged, we will cover the cost of shipping and send you a return label. For all other types of returns, you will be responsible for shipping the return package to the appropriate Cummins location. </li><li>We will let you know when your return is received and a decision on approval or rejection has been made.</li><li>Once we have approved the return, a refund will be issued within 7-10 business days. </li></ul>';
        
        String dropOffIns = '<h3>Return Drop Off Instructions:</h3><strong>Here is what you need to do next:</strong> ' + 
        '<ul><li> Pack the item(s) you are returning. </li><li> Print and include the return document inside your return package.</li><li> Ship back to the appropriate location.</li><li> Use a carrier/shipper that provides package tracking capability. This is vital for resolving any dispute related to the return to Cummins; it also provides a record of the return date. </li><li>  Be sure to cover any prior shipping labels on the package. </li></ul>'+ 
        '<h6>Reminders:</h6> '+
        '<ul><li>Eligible parts can be returned for up to 30 days from the date of purchase. Products purchased on shop.cummins,com must be returned in saleable condition — in other words, unused, in the original packaging, and undamaged. Please note, all accepted returns will incur a 15% handling fee. </li><li>If Cummins shipped the wrong product or the product is damaged, we will cover the cost of shipping and send you a return label. For all other types of returns, you will be responsible for shipping the return package to the appropriate Cummins location. </li><li>We will let you know when your return is received and a decision on approval or rejection has been made.</li><li>Once we have approved the return, a refund will be issued within 7-10 business days. </li></ul>';

        for(ccrz__E_Order__c ord : listOrders)
        {   
            if(ord.ccrz__E_OrderItems__r.size() == 0)
                continue;
            String body;
                        
            String lineItemHTML = '';
            boolean flag;
            String droppLocation;
            for(ccrz__E_OrderItem__c oItem: ord.ccrz__E_OrderItems__r)
            {
               system.debug('oItem---->>>'+oItem);
               if(oItem.dbu_Dropoff_Location__c != Null){
                    droppLocation=oItem.dbu_Dropoff_Location__c;
               }
                if(oItem.dbu_Shipto__c == false){
                    flag = true;
                    
                if(ord.ccrz__ShipTo__r.ccrz__Country__c == 'US'){    
                    if(oItem.dbu_Reason_for_Return__c != null){
                        lineItemHTML = lineItemHTML + '<tr><td class="tg-0lax">'+ oItem.ccrz__Product_Name__c+'</td><td class="tg-0lax">'+ oItem.ccrz__Quantity__c+'</td> <td class="tg-0lax">'+oItem.dbu_Reason_for_Return__c+'</td><td class="tg-0lax">Drop Off</td><td class="tg-0lax">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td></tr>';
                    }
                    else{
                        lineItemHTML = lineItemHTML + '<tr><td class="tg-0lax">'+ oItem.ccrz__Product_Name__c+'</td><td class="tg-0lax">'+ oItem.ccrz__Quantity__c+'</td> <td class="tg-0lax">Core Refund</td><td class="tg-0lax">Drop Off</td><td class="tg-0lax">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td></tr>';
                        }
                  }else if(ord.ccrz__ShipTo__r.ccrz__Country__c == 'CA' && (oItem.dbu_Reason_for_Return__c == 'Part no longer wanted' || oItem.dbu_Reason_for_Return__c == 'Ordered the wrong part')){
                        lineItemHTML = lineItemHTML + '<tr><td class="tg-0lax">'+ oItem.ccrz__Product_Name__c+'</td><td class="tg-0lax">'+ oItem.ccrz__Quantity__c+'</td> <td class="tg-0lax">'+oItem.dbu_Reason_for_Return__c+'</td><td class="tg-0lax">Ship To</td><td class="tg-0lax">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td></tr>';
                    }
                  
                }else{
                    flag = false;
                    
                    if(ord.ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                        if(oItem.dbu_Reason_for_Return__c != Null){
                            lineItemHTML = lineItemHTML + '<tr><td class="tg-0lax">'+ oItem.ccrz__Product_Name__c+'</td><td class="tg-0lax">'+ oItem.ccrz__Quantity__c+'</td> <td class="tg-0lax">'+oItem.dbu_Reason_for_Return__c+'</td><td class="tg-0lax">Ship To</td><td class="tg-0lax">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td></tr>';
                        }
                        else{
                            lineItemHTML = lineItemHTML + '<tr><td class="tg-0lax">'+ oItem.ccrz__Product_Name__c+'</td><td class="tg-0lax">'+ oItem.ccrz__Quantity__c+'</td> <td class="tg-0lax">Core Refund</td><td class="tg-0lax">Ship To</td><td class="tg-0lax">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td></tr>';
                        }
                        
                    }else if(ord.ccrz__ShipTo__r.ccrz__Country__c == 'CA' && (oItem.dbu_Reason_for_Return__c == 'Part no longer wanted' || oItem.dbu_Reason_for_Return__c == 'Ordered the wrong part')){
                        lineItemHTML = lineItemHTML + '<tr><td class="tg-0lax">'+ oItem.ccrz__Product_Name__c+'</td><td class="tg-0lax">'+ oItem.ccrz__Quantity__c+'</td> <td class="tg-0lax">'+oItem.dbu_Reason_for_Return__c+'</td><td class="tg-0lax">Ship To</td><td class="tg-0lax">'+'$'+(oItem.dbu_Estimated_Return_Amount__c).setScale(2)+'</td></tr>';
                    }
                }
            }
            if(flag){
                body = '<html><body><h1 style=\"text-align:center;\">Return Order information</h1><br/><br/><p>'+ 'Return Confirmation Code :' + ord.Name +'</p><p><div><div style=\"width: 10%;float: left;\">Drop off location : </div><div style=\"width: 90%;float: left;\">'+droppLocation+'';
                 body = body+ '</div></div></p><br/><br/><p>Return order items:</p><br/><table border="1"  ><thead><tr><th style="width: 40.0743%; background-color: rgb(239, 239, 239); text-align: left;">Product</th><th style="width: 10.0743%; background-color: rgb(239, 239, 239); text-align: left;">Quantity<br></th><th style="background-color: rgb(239, 239, 239); text-align: left;">Reason for Return</th><th style="background-color: rgb(239, 239, 239); text-align: left;">Return method</th><th style="background-color: rgb(239, 239, 239); text-align: left;">Estimated refund amount</th></tr></thead><tbody>';
                 body = body + lineItemHTML + '</tbody></table>';
                body = body + dropOffIns + '</body></html>';
                
            }else{
                body = '<html><body><h1 style=\"text-align:center;\">Return Order information</h1><br/><br/><p>'+ 'Return Confirmation Code :' + ord.Name +'</p><p><div style=\"width: 10%;float: left;\">Ship to location : </div><div>'+ord.dbu_StoreLocationAddress__c+'';
                body = body + '</div></div></p><br/><br/><p>Return order items:</p><br/><table border="1"  ><thead><tr><th style="width: 40.0743%; background-color: rgb(239, 239, 239); text-align: left;">Product</th><th style="width: 10.0743%; background-color: rgb(239, 239, 239); text-align: left;">Quantity<br></th><th style="background-color: rgb(239, 239, 239); text-align: left;">Reason for Return</th><th style="background-color: rgb(239, 239, 239); text-align: left;">Return method</th><th style="background-color: rgb(239, 239, 239); text-align: left;">Estimated refund amount</th></tr></thead><tbody>';
                body = body + lineItemHTML +'</tbody></table>';
                body = body + shippingIns + '</body></html>';
            }
            
            System.debug('HTML is ' + body);

            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName('Return Order information.pdf');
            System.debug('HTML is ' + body);
            System.debug('UserInfo.getUserType()---->>' + UserInfo.getUserType());
            attach.Body = Blob.toPDF(body);
            String[] toaddress = new String[]{}; 
            toaddress.add(ord.ccrz__BuyerEmail__c);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if(UserInfo.getUserType() == 'Guest'){
            mail.setToAddresses(toaddress);
            mail.setTargetObjectId(ord.ccrz__User__c);
            }else{
            mail.setTargetObjectId(ord.ccrz__Contact__c); 
            }
            mail.setSenderDisplayName('Company Support'); 
            mail.setReplyTo('no-reply@company.com');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);
            mail.setTemplateID(emailTemplate.Id);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });     

            mails.add(mail);
        }
        system.debug('mails---->>'+mails);                       
        if(!mails.isEmpty())
        {
            Messaging.SendEmail(mails);
        }
        List<ccrz__E_OrderItem__c> toUpdateOI = new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_Order__c ord : listOrders)
        {   
            for(ccrz__E_OrderItem__c oItem: ord.ccrz__E_OrderItems__r)
            {
                oItem.dbu_Is_return_mail_sent__c = true;
                toUpdateOI.add(oItem);
            }
        }
        if(toUpdateOI.size() > 0)
            update toUpdateOI;
    }
}