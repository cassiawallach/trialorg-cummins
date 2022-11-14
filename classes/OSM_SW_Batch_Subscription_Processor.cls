global class OSM_SW_Batch_Subscription_Processor implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
    
    global final String query;
    public List<String> accIdLst;
    public String testNumber;
    public Set<Id> orderIdToDAUpdate; 
    //public Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
    //public Messaging.Email[] messagesForBolt = new List<Messaging.SingleEmailMessage>();
    
    global OSM_SW_Batch_Subscription_Processor(){
        orderIdToDAUpdate = new Set<Id>();
    }
    public List<Id> accLst = new List<Id>();
    
    global OSM_SW_Batch_Subscription_Processor(String q){
        query=q; 
        orderIdToDAUpdate = new Set<Id>();
        /// add payment method
    }
    
    global OSM_SW_Batch_Subscription_Processor(List<String> accId)
    {
        accIdLst = accId;
        orderIdToDAUpdate = new Set<Id>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String accountid = '0014C00000Evjct';
        //List<String> accLst = new List<String>{'0014C00000Evjct','0014C00000Evjcu'};
        //String query = 'select id,name,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c,OSM_Preferred_Payment_IsBolt_PO__c,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c   from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where id in :accLst';
        
        if(accIdLst!=null && accIdLst.size()>0)
        {
            String queryForBatch = 'select id,name,BillingCountry,CSS_DistributorCode__c,IAM_Cummins_Support_User__c,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c, OSM_Preferred_Payment_IsBolt_PO__c, BMS_Customer_ID__c, BOLT_Account_Number__c, Bolt_Customer_Account_Status__c , Bolt_Credit_Hold__c,Bolt_BC_Code__c,Type,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c  from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where  id in:accIdLst';
            return Database.getQueryLocator(queryForBatch);
        }
        else
        {
            Date todayDt = System.Today();
            String queryForBatch = 'select id,name,BillingCountry,CSS_DistributorCode__c,IAM_Cummins_Support_User__c,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c,BMS_Customer_ID__c, BOLT_Account_Number__c, Bolt_Customer_Account_Status__c , OSM_Preferred_Payment_IsBolt_PO__c,Bolt_Credit_Hold__c, Bolt_BC_Code__c,Type,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c   from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where Next_Invoice_Generation_Date__c = LAST_N_DAYS:5';
            // String queryForBatch = 'select id,name,CMI_Primary_Contact__c,Next_Invoice_Generation_Date__c,OSM_Preferred_Payment_Method__c,(select id,ccrz__Account__c,ccrz__AccountNumber__c,ccrz__AccountType__c   from ccrz__TransactionPayments__r where ccrz__AccountType__c=\'po\' and Transaction_Status__c in (\'Order Placed Success\',\'Recurring Payment Success\') order by createddate desc limit 1),(select id from contacts where IAM_Contact_Status__c=\'Active\') from account where Is_Active_Subscription_Exists__c=true';
            return Database.getQueryLocator(queryForBatch);
        }
        
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        Map<Id,Account> accountMap = new Map<Id,Account>();
        
        
        Savepoint sp;
        Map<Id,OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper>  accoundVsWrapperMap;
        List<ccrz__E_Subscription__c> subLst = null;
        ccrz__E_Invoice__c invoice = null;
        ccrz__E_TransactionPayment__c transPayment=null;
        List<ccrz__E_InvoiceItem__c> invoiceLineItems = null;
        OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper singleInvWrap;
        List<OSM_Integration_Log__c> osmLogLst = new List<OSM_Integration_Log__c>();
        Map<String,Map<String,String>> invoiceIdVsEmailMap = new Map<String,Map<String,String>>();
        Map<String,Set<String>> invoiceIdVsOwnerMap = new Map<String,Set<String>>();
        List<String> ownerIdLst = new List<String>();
        OSM_InvoiceLine_And_OrderLine__c lineJunctionWrapper = null;
        List<OSM_InvoiceLine_And_OrderLine__c> lineJunctionWrapperLst = new List<OSM_InvoiceLine_And_OrderLine__c>();
        List<CC_Tax__c> listTaxObjeToCreate = new List<CC_Tax__c>();
        Map<Id,Account> accToUpdateMap = new Map<Id,Account>();
        Map<Id, Date> mapAccountToNextInvoiceGenDate = new Map<Id, Date>();
        List<SubscRevoke> lstForRevokeSubsc = new List<SubscRevoke>();
        
        
        try{
            Map<Id, Double> MapIdToAccountCreditLimit = new Map<Id, Double>();
            Map<Id, String> MapIdToUserToEmailId = new Map<Id, String>();
            Map<Id, boolean> MapIdToOneBMSFailure = new Map<Id, boolean>();
            for(sobject s : scope){
                Account acc = (Account)s;
                accountMap.put(acc.id,acc);
                System.debug('===Include account for Invoice Generation=== '+acc.name);
                mapAccountToNextInvoiceGenDate.put(acc.Id,acc.Next_Invoice_Generation_Date__c.Date());
                if(acc.IAM_Cummins_Support_User__c != null)
                    MapIdToUserToEmailId.put(acc.IAM_Cummins_Support_User__c, '');
            }
            
            if(MapIdToUserToEmailId != null && MapIdToUserToEmailId.size() > 0)
            {
                List<User> lstUser = [Select Id, Email from User where Id IN: MapIdToUserToEmailId.keySet()];
                if(lstUser != null && lstUser.size() > 0 )
                {
                    for(User objUsr : lstUser)
                        MapIdToUserToEmailId.put(objUsr.Id,objUsr.Email);
                }
            }
            
            
            EmailTemplate etforRecurring = [Select id from EmailTemplate where name = 'Recurring Invoice not generated template' limit 1];
            EmailTemplate etforRevoke = [Select id from EmailTemplate where name = 'Revocation Recurring Invoice generate' limit 1];
            
            
            OSM_SW_Batch_Subscription_Helper helper = new OSM_SW_Batch_Subscription_Helper();
            OSM_ReturnWrapper returnWrapper = helper.createInvoicesForAccount(accountMap);
            accoundVsWrapperMap = returnWrapper.accountIdVsInvoiceWrapperMap;
            //accoundVsWrapperMap = helper.createInvoicesForAccount(accountMap);
            
            System.debug('returnWrapper: '+returnWrapper);
            System.debug('accoundVsWrapperMap: '+accoundVsWrapperMap);
            
            Map<Id,Decimal> orderIdVsOrderTaxMap2 = new Map<Id,Decimal>();
            orderIdVsOrderTaxMap2 = OSM_SW_VertexActions.getVirtualVertexQuoteTax(accoundVsWrapperMap );
            
            List<OSM_Integration_Log__c> newLogLst = new List<OSM_Integration_Log__c>();    
            /*   
for(Id accId : accoundVsWrapperMap.keySet())
{
OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper singleInvWrap1 = new OSM_SW_Batch_Subscription_Helper.SingleInvoiceForAccountWrapper();

singleInvWrap1 = accoundVsWrapperMap.get(accId);
System.debug('singleInvWrap1: '+singleInvWrap1);
System.debug('singleInvWrap1.exceptionFlag: '+singleInvWrap1.exceptionFlag);
System.debug(singleInvWrap1.exceptionFlag !=true);
if(singleInvWrap1 !=null && singleInvWrap1.exceptionFlag !=true)
{
System.debug('singleInvWrap1.Invoice.Payment_Method__c: '+singleInvWrap1.Invoice.Payment_Method__c);
System.debug('singleInvWrap1.Invoice.OSM_SW_Is_Bolt_PO__c: '+singleInvWrap1.Invoice.OSM_SW_Is_Bolt_PO__c);

if(singleInvWrap1.Invoice.Payment_Method__c == 'po' && !singleInvWrap1.Invoice.OSM_SW_Is_Bolt_PO__c)
{
OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();
objRet = OSM_BMS_SW_BusinessLayerHandler.getBMSAvailableCredit(accId);
newLogLst.addAll(objRet.lstToInsertLog);
System.debug('((((((((((((((((((((objRet : '+objRet );
if(objRet != null && !objRet.exceptionFlag && objRet.updateAccountList.size() > 0 && objRet.updateAccountList[0].BMSAvailableCredit__c != null && objRet.updateAccountList[0].PaymentType__c == 'CHARGE')
{
MapIdToAccountCreditLimit.put(accId,objRet.updateAccountList[0].BMSAvailableCredit__c);
MapIdToOneBMSFailure.put(accId, false);
}
else
{
MapIdToOneBMSFailure.put(accId, true);
}
}
}
}
*/
            if(newLogLst != null && newLogLst.size() > 0 )
            {
                insert newLogLst;
            }
            
            for(Id accId : accoundVsWrapperMap.keySet())
            {
                
                boolean skipTaxForNonUSUser = false;
                if(!label.OSM_North_America_Country.containsIgnoreCase(accountMap.get(accId).BillingCountry) && !label.OSM_PO_Distributor_List.contains(accountMap.get(accId).CSS_DistributorCode__c))
                    skipTaxForNonUSUser = true;
                boolean isCreditLimitDeducted = false;
                transPayment = null;
                invoiceLineItems = null;
                subLst = null;
                invoice = null;
                singleInvWrap =  accoundVsWrapperMap.get(accId);
                
                
                Set<String> ownerIds = singleInvWrap.orderOwnerIds;
                
                System.debug('orderIdVsOrderTaxMap2: '+orderIdVsOrderTaxMap2);
                System.debug('singleInvWrap: '+singleInvWrap);
                
                // Map<ccrz__E_Invoice__c,List<ccrz__E_InvoiceItem__c>> invoiceMap = singleInvWrap.invoiceVsInvoiceLineMap;
                
                try{
                    sp = Database.setSavepoint();
                    if(singleInvWrap!=null && singleInvWrap.exceptionFlag==true && !Test.isRunningTest())
                    {
                        OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception(singleInvWrap.exceptionMessage,true);
                        throw reqEx; 
                    }
                    else if(singleInvWrap==null)
                    {
                        OSM_RequiredFields_Exception reqEx = new OSM_RequiredFields_Exception('Invoice record not created for account-'+accId,true);
                        throw reqEx; 
                    }
                    
                    if(!singleInvWrap.isQuoteTaxFailed || skipTaxForNonUSUser || Test.isRunningTest())
                    {
                        boolean isCreateRecurringInvoice = false;
                        String jsonStringForMail = '';
                        
                        
                        
                        
                        System.debug('======Starting Invoice Saving for Account==='+accId  +'===Accounr Name ===='+singleInvWrap.acc.name);
                        subLst = singleInvWrap.subsList;
                        invoice = singleInvWrap.Invoice;
                        if(invoice.Payment_Method__c=='po')
                        {
                            transPayment = singleInvWrap.transPayment;
                        }
                        
                        
                        invoiceLineItems = singleInvWrap.invoiceLineLst;
                        
                        List<invoiceItem> listObj = new List<invoiceItem>();
                        List<subscData> lstSubD = new List<subscData>();
                        List<Id> lstOrderIdToDAUpdate = new List<Id>();
                        
                        for(ccrz__E_InvoiceItem__c objInvoiceItem : invoiceLineItems)
                        {
                            if(!objInvoiceItem.ccrz__Type__c.equalsIgnoreCase('Tax'))
                            {
                                invoiceItem objNew = new invoiceItem();
                                objNew.subscription = objInvoiceItem.CC_Subscription__c;
                                objNew.quantity = objInvoiceItem.Quantity__c;
                                if(skipTaxForNonUSUser)
                                {
                                    objNew.price = 0.0;
                                }
                                else
                                {
                                    objNew.price = objInvoiceItem.ccrz__OriginalAmount__c;
                                }
                                listObj.add(objNew);
                                subscData newSubDataObj = new subscData();
                                newSubDataObj.subscId = objInvoiceItem.CC_Subscription__c;
                                newSubDataObj.Quantity = objInvoiceItem.Quantity__c;
                                lstSubD.add(newSubDataObj);
                            }
                        }
                        
                        jsonStringForMail = JSON.serialize(listObj);
                        
                        
                        for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                        {
                            lstOrderIdToDAUpdate.add(lineJunctionWrapperTmp.orderId);
                        }
                        
                        System.debug('----Invoice---'+invoice);
                        
                        Decimal totalTax = 0.0;
                        
                        Set<Id> setOrderIdToCheckOnlyOneTime = new Set<Id>();
                        if(!skipTaxForNonUSUser)
                        {
                            for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                            {
                                
                                if(orderIdVsOrderTaxMap2 != null && orderIdVsOrderTaxMap2.containsKey(lineJunctionWrapperTmp.orderId) && orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId) != null  )
                                {
                                    if(!setOrderIdToCheckOnlyOneTime.contains(lineJunctionWrapperTmp.orderId))
                                    {
                                        totalTax = totalTax+orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId);
                                        setOrderIdToCheckOnlyOneTime.add(lineJunctionWrapperTmp.orderId);
                                    }
                                }
                            }
                        }
                        
                        invoice.ccrz__OriginalAmount__c = totalTax+invoice.ccrz__OriginalAmount__c;
                        if(invoice.Payment_Method__c == 'cc')
                            invoice.ccrz__RemainingAmount__c=invoice.ccrz__OriginalAmount__c;
                        
                        
                        if(singleInvWrap.acc.OSM_Preferred_Payment_Method__c == 'po')
                        {
                            if(invoice.OSM_SW_Is_Bolt_PO__c || Test.isRunningTest())
                            {
                                isCreateRecurringInvoice = true;
                                
                                if(singleInvWrap.acc.Bolt_Credit_Hold__c)
                                {
                                    
                                    isCreateRecurringInvoice = false;
                                    System.debug(mapAccountToNextInvoiceGenDate);
                                    
                                    System.debug('in bolt hold');
                                    
                                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                                    log.Service_Name__c ='Recurring Invoice not generated';
                                    log.Request__c = jsonStringForMail;
                                    insert log;
                                    
                                    if(mapAccountToNextInvoiceGenDate.get(singleInvWrap.acc.Id).daysBetween(System.Today()) < 5)
                                    {
                                        Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
                                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                        message = Messaging.renderStoredEmailTemplate(etforRecurring.id,singleInvWrap.acc.CMI_Primary_Contact__c,log.id);
                                        message.setSaveAsActivity(false);
                                        List<String> emailAddress = new List<String>();
                                        emailAddress.add('sharad.sa@hcl.com');
                                        emailAddress.add('OSMSupport@cummins.com');
                                        if(singleInvWrap.acc.IAM_Cummins_Support_User__c != null && MapIdToUserToEmailId.containsKey(singleInvWrap.acc.IAM_Cummins_Support_User__c) && MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c) != '')
                                            emailAddress.add(MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c));
                                        message.setToAddresses(emailAddress);
                                        messagesForBMS.add(message);
                                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
                                    }
                                    else
                                    {
                                        System.debug('Revoke Subscription');
                                        
                                        SubscRevoke objRev = new SubscRevoke();
                                        objRev.lstSubscData = lstSubD;
                                        objRev.lstOrderId = lstOrderIdToDAUpdate;
                                        
                                        
                                        
                                        //Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
                                        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                        message = Messaging.renderStoredEmailTemplate(etforRevoke.id,singleInvWrap.acc.CMI_Primary_Contact__c,log.id);
                                        message.setSaveAsActivity(false);
                                        List<String> emailAddress = new List<String>();
                                        emailAddress.add('sharad.sa@hcl.com');
                                        emailAddress.add('OSMSupport@cummins.com');
                                        if(singleInvWrap.acc.IAM_Cummins_Support_User__c != null && MapIdToUserToEmailId.containsKey(singleInvWrap.acc.IAM_Cummins_Support_User__c) && MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c) != '')
                                            emailAddress.add(MapIdToUserToEmailId.get(singleInvWrap.acc.IAM_Cummins_Support_User__c));
                                        message.setToAddresses(emailAddress);
                                        //messagesForBMS.add(message);
                                        //Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
                                        
                                        objRev.mailTosent = message;
                                        lstForRevokeSubsc.add(objRev);
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            else
                            {
                                isCreateRecurringInvoice = true;
                                /*
// check credit limit
boolean sendMail = false;
if(MapIdToOneBMSFailure.containsKey(singleInvWrap.acc.Id) && !MapIdToOneBMSFailure.get(singleInvWrap.acc.Id))
{
if(MapIdToAccountCreditLimit.get(singleInvWrap.acc.Id) - invoice.ccrz__OriginalAmount__c >=0)
{
Double leftCredit = MapIdToAccountCreditLimit.get(singleInvWrap.acc.Id) - invoice.ccrz__OriginalAmount__c;
MapIdToAccountCreditLimit.put(singleInvWrap.acc.Id, leftCredit);
isCreateRecurringInvoice  = true;
isCreditLimitDeducted = true;
}
else
{
sendMail = true;
isCreateRecurringInvoice = false;
}
}
else
{
sendMail = true;
isCreateRecurringInvoice = false;
}

if(sendMail)
{

OSM_Integration_Log__c log = new OSM_Integration_Log__c();
log.Service_Name__c='Recurring Invoice not generated';
insert log;

EmailTemplate et = [Select id from EmailTemplate where name = 'Recurring Invoice not generated template' limit 1];

Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
//message = Messaging.renderStoredEmailTemplate(et.id,'sharad.sa@hcl.com',log.id);
message.setSaveAsActivity(false);
//message.setSubject('test subject');
message.setTemplateId(et.id);
List<String> emailAddress = new List<String>();
emailAddress.add('sharad.sahu@cummins.com');
message.setToAddresses(emailAddress);

messagesForBMS.add(message);
Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
}
*/
                            }
                            
                        }
                        else
                        {
                            isCreateRecurringInvoice = true;
                        }
                        
                        
                        if(isCreateRecurringInvoice)
                        {
                            
                            insert invoice; 
                            
                            invoiceIdVsOwnerMap.put(invoice.id,ownerIds);
                            if(transPayment!=null)
                            {
                                transPayment.ccrz__InvoiceAppliedTo__c = invoice.id;
                            }
                            for(ccrz__E_InvoiceItem__c invItem : invoiceLineItems)
                            {
                                invItem.ccrz__Invoice__c = invoice.id;
                                if(invItem.ccrz__Type__c == 'Tax')
                                    invItem.ccrz__OriginalAmount__c = totalTax;
                                
                                
                            }
                            System.debug('===invoiceLineItems size==='+invoiceLineItems.size());
                            for(ccrz__E_Subscription__c sub:subLst)
                            {
                                System.debug('====subscription before saving==='+sub);
                                sub.Latest_Invoice__c = invoice.id;
                            }
                            if(!test.isRunningTest()){
                                Database.insert(invoiceLineItems);
                                Database.update(subLst);  
                            } 
                            
                            Map<Id,Decimal> orderIdVsOrderTaxMap = new Map<Id,Decimal>();
                            Decimal taxPerOrderLine=0;
                            
                            /* for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
{
if(!orderIdVsOrderTaxMap.containsKey(lineJunctionWrapperTmp.orderId))
{
orderIdVsOrderTaxMap.put(lineJunctionWrapperTmp.orderId,0);

}
taxPerOrderLine = lineJunctionWrapperTmp.vertexTax + orderIdVsOrderTaxMap.get(lineJunctionWrapperTmp.orderId);
orderIdVsOrderTaxMap.put(lineJunctionWrapperTmp.orderId,taxPerOrderLine);

}
*/
                            //lineJunctionWrapperLst = singleInvWrap.invoiceLineOrderLineWrapperLst;
                            OSM_Orders_In_Invoice__c parentJun;
                            Map<Id,OSM_Orders_In_Invoice__c> junctionForEachOrder = new Map<Id,OSM_Orders_In_Invoice__c>();
                            for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp : singleInvWrap.invoiceLineOrderLineWrapperLst)
                            {
                                
                                parentJun = new OSM_Orders_In_Invoice__c();
                                parentJun.CC_Invoice__c = invoice.id;
                                parentJun.CC_Order__c = lineJunctionWrapperTmp.orderId;
                                if(invoice.Payment_Method__c=='po'){
                                    if(skipTaxForNonUSUser)
                                    {
                                        parentJun.Vertex_Call_Status__c = 'Success';
                                        parentJun.Vertex_Refund_Call_Status__c = 'Success';
                                    }
                                    else{
                                        parentJun.Vertex_Call_Status__c = 'Pending';
                                    }
                                }
                                if(orderIdVsOrderTaxMap2 != null && orderIdVsOrderTaxMap2.containsKey(lineJunctionWrapperTmp.orderId) && orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId) != null  )
                                    parentJun.vertex_tax__c = orderIdVsOrderTaxMap2.get(lineJunctionWrapperTmp.orderId);
                                else
                                    parentJun.vertex_tax__c = 0;
                                //breaking as any line item will have orderid and invoice id
                                if(!junctionForEachOrder.containskey(lineJunctionWrapperTmp.orderId))
                                {
                                    junctionForEachOrder.put(lineJunctionWrapperTmp.orderId,parentJun);
                                }
                                //insert parentJun;
                                //break;
                            }
                            
                            insert junctionForEachOrder.values();
                            
                            
                            for(OSM_SW_Batch_Subscription_Helper.InvoiceLineAndOrderLineWrapper lineJunctionWrapperTmp2 : singleInvWrap.invoiceLineOrderLineWrapperLst)
                            {
                                
                                System.debug('lineJunctionWrapperTmp2'+lineJunctionWrapperTmp2);
                                lineJunctionWrapper = new OSM_InvoiceLine_And_OrderLine__c();
                                
                                for(ccrz__E_InvoiceItem__c invItem : invoiceLineItems)
                                {
                                    if(invItem.CC_Subscription__c == lineJunctionWrapperTmp2.subsId)
                                    {
                                        lineJunctionWrapper.CC_Invoice_Item__c = invItem.id;
                                        break;
                                    }
                                }
                                
                                lineJunctionWrapper.CC_Order_Item__c = lineJunctionWrapperTmp2.orderLineId;
                                if(junctionForEachOrder.containsKey(lineJunctionWrapperTmp2.orderId))
                                {
                                    OSM_Orders_In_Invoice__c parentJunction = junctionForEachOrder.get(lineJunctionWrapperTmp2.orderId);
                                    lineJunctionWrapper.OSM_Orders_In_Invoice__c = parentJunction.id;
                                }
                                lineJunctionWrapper.Quantity__c = lineJunctionWrapperTmp2.qty;
                                lineJunctionWrapper.Sales_Amount__c =lineJunctionWrapperTmp2.totalSalesAmt;
                                lineJunctionWrapper.vertex_tax__c = lineJunctionWrapperTmp2.vertexTax;
                                //creating tax record: sharad
                                if(lineJunctionWrapperTmp2.lstTax != null && lineJunctionWrapperTmp2.lstTax.size() > 0)
                                {
                                    for(CC_Tax__c objTax : lineJunctionWrapperTmp2.lstTax)
                                    {
                                        objTax.Invoice_Item__c = lineJunctionWrapper.CC_Invoice_Item__c;
                                        listTaxObjeToCreate.add(objTax);
                                    }
                                }
                                
                                
                                //end of creating tax record: sharad
                                
                                //lineJunctionWrapper.CC_Subscription__c = lineJunctionWrapperTmp2.subsId;
                                lineJunctionWrapperLst.add(lineJunctionWrapper);
                            }
                            
                            insert lineJunctionWrapperLst;
                            
                            if(listTaxObjeToCreate != null && listTaxObjeToCreate.size() > 0)
                            {
                                insert listTaxObjeToCreate;
                            }
                            
                            
                            if(transPayment!=null)
                            {
                                //for PO INvoice..make the immediate payment by creating the TX Payment and set the Bolt Calls
                                //transPayment.Bolt_Recurring_AR_Call_Status__c='Pending';
                                //transPayment.Bolt_Recurring_JE_Call_Status__c ='Pending';
                                transPayment.Bolt_AR_Call_Status__c ='Pending';
                                transPayment.Bolt_JE_Call_Status__c ='Pending';
                                transPayment.ccrz__InvoiceAppliedTo__c = invoice.id;
                                //transPayment.ccrz__AccountType__c='po';
                                Database.insert(transPayment);
                            }
                            
                            
                            //if all goes well then make an entry to update the account with next installment date...
                            accToUpdateMap.put(singleInvWrap.acc.id,singleInvWrap.acc);
                            
                            if(Test.isRunningTest() && 'test1'==testNumber) {
                                throw new OSM_RequiredFields_Exception();
                            }
                            else if(Test.isRunningTest() && 'test2'==testNumber) {
                                throw new NullPointerException();
                            }
                        }
                        
                    }
                }
                catch(OSM_RequiredFields_Exception ex)
                {
                    Database.rollback(sp);
                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                    log.Account__c =accId;
                    log.Error_Description__c = ex.exceptionMessage;
                    log.Service_Name__c=Label.OSM_Recurring_Invoice_Process;
                    log.Status__c = 'Error';
                    osmLogLst.add(log);
                }      
                catch(Exception e)
                {
                    Database.rollback(sp);
                    String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
                    System.debug('=====Got the exception while saving the records====='+errorMsg);
                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                    log.Account__c =accId;
                    log.Error_Description__c = errorMsg;
                    log.Service_Name__c=Label.OSM_Recurring_Invoice_Process;
                    log.Status__c = 'Error';
                    osmLogLst.add(log);
                    if(isCreditLimitDeducted)
                    {
                        Double addCredit = MapIdToAccountCreditLimit.get(singleInvWrap.acc.Id) + invoice.ccrz__OriginalAmount__c;
                        MapIdToAccountCreditLimit.put(singleInvWrap.acc.Id, addCredit);
                    }
                }
                
            }
            
            // sharad code for revoke subscription
            if(lstForRevokeSubsc != null && lstForRevokeSubsc.size() > 0)
            {
                Map<Id,Double> mapSubToQuantity = new Map<Id,Double>();
                Set<Id> orderIdSet = new Set<Id>();
                Messaging.Email[] messagesForBMS = new List<Messaging.SingleEmailMessage>();
                
                for(SubscRevoke objCls : lstForRevokeSubsc)
                {
                    for(subscData obj : objCls.lstSubscData)
                    {
                        mapSubToQuantity.put(obj.subscId,obj.Quantity);
                    }
                    
                    for(Id idvalue : objCls.lstOrderId)
                    {
                        orderIdSet.add(idvalue);
                    }
                    
                    messagesForBMS.add(objCls.mailTosent);
                    
                }
                if(mapSubToQuantity != null && mapSubToQuantity.size() > 0)
                {
                    List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
                    lstSubsc = [Select Id,ccrz__Quantity__c,ccrz__SubscriptionStatus__c from ccrz__E_Subscription__c where Id IN: mapSubToQuantity.keySet()];
                    
                    if(lstSubsc.size() > 0 )
                    {
                        for(ccrz__E_Subscription__c objSubsc : lstSubsc)
                        {
                            if(mapSubToQuantity.containsKey(objSubsc.Id))
                            {
                                objSubsc.ccrz__Quantity__c = objSubsc.ccrz__Quantity__c - mapSubToQuantity.get(objSubsc.Id);
                                if(objSubsc.ccrz__Quantity__c == 0)
                                    objSubsc.ccrz__SubscriptionStatus__c = 'Inactive';
                            }
                        }
                        update lstSubsc;
                    }
                }
                
                if(messagesForBMS != null && messagesForBMS.size() > 0 )
                {
                    
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messagesForBMS);
                    
                }
                
                if(orderIdSet != null && orderIdSet.size() >0 )
                {
                    orderIdToDAUpdate.addAll(orderIdSet);
                    
                    
                    List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
                    
                    lstOrderItem = [Select Id, ccrz__Quantity__c from ccrz__E_OrderItem__c where ccrz__Product__r.Group_Name__c = 'DA' AND ccrz__SubProdTerm__r.Billing_Display_Name__c != 'One Time' AND ccrz__Order__c IN: orderIdSet];
                    
                    if(lstOrderItem != null && lstOrderItem.size() > 0)
                    {
                        for(ccrz__E_OrderItem__c objOrderItem : lstOrderItem)
                        {
                            objOrderItem.ccrz__Quantity__c = 0;
                        }
                        
                        update lstOrderItem;
                        
                    }
                    
                    
                    
                }
                
                
            }
            
            
            
            
            //email notification processing start
            Set<String> allOwnerIds = new Set<String>();
            for(String invId : invoiceIdVsOwnerMap.keySet())
            {
                Set<String> ownerIdsSetTmp = invoiceIdVsOwnerMap.get(invId);
                allOwnerIds.addAll(ownerIdsSetTmp);
            }
            System.debug('====allOwnerIds===='+allOwnerIds);
            //email should be fetched from contact
            Map<Id,User> userMap = new Map<Id,User>([select id,email,contactId,Distributor_User_Related_Contact__c,contact.email from user where id in :allOwnerIds]);
            
            for(String invId : invoiceIdVsOwnerMap.keySet())
            {
                Set<String> ownerIdsSetTmp = invoiceIdVsOwnerMap.get(invId);
                for(String ownerId : ownerIdsSetTmp)
                {
                    User user = userMap.get(ownerId);
                    
                    if(!invoiceIdVsEmailMap.containsKey(invId))
                    {
                        invoiceIdVsEmailMap.put(invId,new Map<String,String>());
                        
                    }
                    //invoiceIdVsEmailMap.get(invId).put(user.contact.email,ownerId);
                    if(user.contactId != null){
                        invoiceIdVsEmailMap.get(invId).put(user.contact.email,user.contactId);
                    }else if(user.Distributor_User_Related_Contact__c != null){
                        invoiceIdVsEmailMap.get(invId).put(user.email,user.Distributor_User_Related_Contact__c);
                    }
                    
                    
                }
            }
            //invoiceIdVsEmailMap contains the emails of all the users who owns the orders
            List<OSM_Integration_Log__c> logLst = OSM_Email_Alert_Processor.sendRecurringInvoiceEmails(invoiceIdVsEmailMap);
            osmLogLst.addAll(logLst);
            
            if(Test.isRunningTest() && 'test3'==testNumber) {
                throw new OSM_RequiredFields_Exception();
            }
            
        }
        catch(OSM_RequiredFields_Exception ex)
        {
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Error_Description__c = ex.exceptionMessage;
            log.Service_Name__c=Label.OSM_Recurring_Invoice_Process;
            log.Status__c = 'Fail';
            osmLogLst.add(log);
        }   
        catch(Exception e)
        {
            System.debug('Exception got in batch  OSM_SW_Batch_Subscription_Processor'+e);
            String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Error_Description__c = errorMsg;
            log.Service_Name__c=Label.OSM_Recurring_Invoice_Process;
            log.Status__c = 'Fail';
            insert log;
        }
        finally{
            
            
            List<Database.SaveResult> srList = Database.update(accToUpdateMap.values(),false);
            
            
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                        log.Account__c = sr.getId();
                        log.Error_Description__c = err.getMessage();
                        log.Service_Name__c=Label.OSM_Recurring_Invoice_Process+'-Unable_to_update_the_accounts_Next_Invoice_Generation_Date__c';
                        log.Status__c = 'Fail';
                        osmLogLst.add(log);
                    }
                }
            }
            
            
            for(OSM_Integration_Log__c log : osmLogLst)
            {
                System.debug('===log==='+log);
            }
            if(osmLogLst!=null && osmLogLst.size()>0)
            {
                insert osmLogLst;
            }
            
        }
        
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='Scheduled:' + Label.OSM_Recurring_Invoice_Process;
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        insert log;
        
        /*
        * Commented by Ashish as duplicate AR invoices are getting triggered.
        OSM_WS_RetryARInvoiceJobs boltARJob  = new OSM_WS_RetryARInvoiceJobs();
        boltARJob.operation = 'Order Placed';
        boltARJob.state = 'Order Placed';
        boltARJob.query = 'Select id,ccrz__InvoiceAppliedTo__r.ccrz__BillTo__r.BillingCountry,ccrz__InvoiceAppliedTo__r.OSM_SW_IsIntercompanyInvoice__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__c,ccrz__InvoiceAppliedTo__r.OSM_Child_Account__r.BillingCountry, OSM_Child_Account__r.CSS_DistributorCode__c,ccrz__InvoiceAppliedTo__c, Bolt_AR_Call_Status__c, OSM_ARInvoice_Integration_Failure__c from ccrz__E_TransactionPayment__c where Bolt_AR_Call_Status__c = :pendingsts';
        if(!Test.isRunningTest())
        {     
            Database.executeBatch(boltARJob,5);
        }*/
        
        OSM_IntercompanyOfRecurringBatch batchJob=new OSM_IntercompanyOfRecurringBatch();
        if(!Test.isRunningTest())
        {
            Database.executeBatch(batchJob,1);
        }
        
        OSM_WS_RetryVertexJobs vertexJob  = new OSM_WS_RetryVertexJobs();
        if(!Test.isRunningTest())
        {
            Database.executeBatch(vertexJob,5);
        }
        System.debug('limit');
        System.debug(Limits.getLimitFutureCalls());
        System.debug(Limits.getFutureCalls());
        if(orderIdToDAUpdate != null && orderIdToDAUpdate.size() > 0)
        {
            OSM_SW_CallDAUpdate objQue = new OSM_SW_CallDAUpdate(orderIdToDAUpdate);
            System.enqueueJob(objQue);
        }
        
        
        
        
        
    }
    
    public class invoiceItem
    {
        public String subscription;
        public double quantity;
        public double price;
    }
    
    public class SubscRevoke
    {
        public List<subscData> lstSubscData;
        public List<Id> lstOrderId;
        Messaging.SingleEmailMessage mailTosent;
        
        public SubscRevoke()
        {
            lstOrderId = new List<Id>();
            lstSubscData = new List<subscData>();
            mailTosent = new Messaging.SingleEmailMessage();
        }
    }
    
    public class subscData
    {
        public Id subscId;
        public double Quantity;
    }
    
}