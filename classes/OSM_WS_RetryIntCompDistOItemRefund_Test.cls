// Singaiah : Test Class fix for 1783.
//Update for MAR-2048
//Updated By Singaiah for MAR-1994 27&30-09-2021
@isTest 
public class OSM_WS_RetryIntCompDistOItemRefund_Test{
    
 static testMethod void testMethod1(){
                    
             List<Account>  lstacc = new List<Account>();
                Account acc = new Account();
                RecordType recid =[select id from recordType where name='wwsps' limit 1];  
                acc.RecordTypeId= recid.id;       
                acc.Name = 'Test Account';
                acc.Type= 'Distributor Account';
                acc.CMI_Account_Status__c = 'Active';
                acc.CMI_CDA_Status__c = 'New Customer Request';
                acc.CMI_Region__c = 'NORTH AMERICA';
                acc.CSS_Language__c = 'English';
                acc.BillingCountry='United States';
                lstacc.add(acc);
                insert lstacc;
                
            Contact ObjContact = new Contact(FirstName='fname', LastName = 'lname', Email = 'email@gmail.com', Phone = '9743800309', IAM_Contact_Owner__c = UserInfo.getUserId(), Username__c = 'jsawpuzzle@gmail.com.stg'); 
            insert ObjContact;
            
            list<ccrz__E_Invoice__c> invcList = new list<ccrz__E_Invoice__c>();
            ccrz__E_Invoice__c  invc = new ccrz__E_Invoice__c ();
            invc.ccrz__BillTo__c=acc.id;
            invc.OSM_Child_Account__c=acc.id;
            invc.GOMS_Invoice_ID__c = '123';
            invc.IntercompanyCalled__c= true;
            invc.Invoice_Type__c = 'Credit Memo';
            invc.OSM_SW_Is_Refund_Intercompany_Call_Done__c= false;
            insert invc;
            invcList.add(invc);
                
            List<ccrz__E_Order__c>  lstCCOrder = new List<ccrz__E_Order__c>();
             ccrz__E_Order__c  objCCOrder = new ccrz__E_Order__c();               
             objCCOrder.ccrz__Account__c = acc.ID;
             objCCOrder.OSM_SW_Should_mail_Send__c = true;
             objCCOrder.OSM_SW_Is_InterCompany_Order__c = false;
             objCCOrder.ccrz__OrderStatus__c='Order Submitted';
             insert objCCOrder;
             //objCCOrder.Original_Sales_Order__c = invc.ID;          
             //objCCOrder.OSM_SW_Is_FSD_refund_Call_Done__c  = true;               
             lstCCOrder.add(objCCOrder);
             ccrz__E_Order__c  objCCOrder2 = objCCOrder.clone();
             objCCOrder2.Purchased_By_User_Type__c = Label.OSM_SSOEM_Admin_UserType;
             lstCCOrder.add(objCCOrder2);
             //insert lstCCOrder;
             
             
             List<ccrz__E_Order__c>  lstCCOrders = new List<ccrz__E_Order__c>();
             ccrz__E_Order__c  objCCOrders = new ccrz__E_Order__c();               
             objCCOrders.ccrz__Account__c = acc.ID;
             objCCOrders.OSM_SW_Should_mail_Send__c = true;
             objCCOrders.OSM_SW_Is_InterCompany_Order__c = false;
             objCCOrders.ccrz__OrderStatus__c='Order Submitted';
             objCCOrders.Original_Sales_Order__c = objCCOrder.ID;          
             objCCOrders.OSM_SW_Is_FSD_refund_Call_Done__c  = true;               
             lstCCOrders.add(objCCOrders);
             ccrz__E_Order__c  objCCOrder2s = objCCOrders.clone();
             objCCOrder2s.Purchased_By_User_Type__c = Label.OSM_SSOEM_Admin_UserType;
             lstCCOrders.add(objCCOrder2s);
             insert lstCCOrders;
             
            ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
            parentpro.Name = 'CA Base-DEF';
            parentpro.ccrz__SKU__c = '5678901-DEF';
            parentpro.ccrz__Quantityperunit__c = 1;
            parentpro.Group_Name__c = 'SES';
            parentpro.Product_Class_Code__c = 'SW-Web Access';
            insert parentpro;
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            pro.Name = 'CA Base-OHT';
            pro.ccrz__SKU__c = '5678902-OHT';
            pro.ccrz__Quantityperunit__c = 1;
            pro.Group_Name__c = 'SES';
            pro.ccrz__ParentProduct__c = parentpro.id;
            pro.Product_Class_Code__c = 'SW-Web Access';
            insert pro;
             
            ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
            oi1.ccrz__Price__c = 500;
            oi1.ccrz__OriginalItemPrice__c = 400;
            oi1.ccrz__Quantity__c = 1;
            oi1.ccrz__SubAmount__c = 123;
            //oi1.ccrz__Order__c = o1.id;
            oi1.ccrz__Product__c = pro.id;
            oi1.ccrz__Subscription_Auto_Renewal__c = true;
            oi1.ccrz__DisplayProduct__c = pro.id;
            oi1.ccrz__PercentDiscount__c =8.33;    
            oi1.CurrencyIsoCode='USD';
            oi1.ccrz__Order__c =objCCOrder.id;
             
             oi1.ccrz__OrderItemStatus__c ='Cancelled';
             
            
             insert oi1;
            list<ccrz__E_InvoiceItem__c> listInvItem = new List<ccrz__E_InvoiceItem__c>(); 
            ccrz__E_InvoiceItem__c invItem = new ccrz__E_InvoiceItem__c();
            invItem.ccrz__CCOrder__c  =  objCCOrder.id;
            invItem.ccrz__CCOrderItem__c=oi1.id;
            invItem.ccrz__Invoice__c= invc.id;
            invItem.Is_Refund_Intercompany_Call_Done__c=false;   
            invItem.ccrz__Type__c='Item'; 
            insert invItem;
            listInvItem.add(invItem);
            
            list<ccrz__E_TransactionPayment__c> transPaymntList =new list<ccrz__E_TransactionPayment__c>();
            ccrz__E_TransactionPayment__c payment=new ccrz__E_TransactionPayment__c();
            payment.ccrz__CCOrder__c=objCCOrders.id;
            payment.OSM_ARInvoice_Integration_Failure__c=true;
            payment.ccrz__InvoiceAppliedTo__c= invc.ID;
            payment.Bolt_JE_Reversal_Call_Status__c = 'Success';
            payment.Bolt_Credit_Memo_Call_Status__c= 'Success';
            
            transPaymntList.add(payment);
            insert transPaymntList;
          
           Test.startTest();
            try{
            //OSM_WS_Bolt_ScheduleBatchJobs scheduleTest= new OSM_WS_Bolt_ScheduleBatchJobs();
            //OSM_WS_Bolt_ScheduleBatchJobs.scheduleIntegration();
           // scheduleTest.execute(null);           
            OSM_WS_RetryInterCompanyDistOItemRefund oItemDistJobs = new OSM_WS_RetryInterCompanyDistOItemRefund();
            Database.executeBatch(oItemDistJobs,1);
            
            }
            catch(Exception ex){}
            Test.stopTest();

                    
    }
    
    
    
}