//adding
// added by chanchala
@isTest
public class PdfGeneratorController_Test{

    @testSetup static void setup() {
        try{
          
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            String orgId = UserInfo.getOrganizationId();
            String dateString = String.valueof(Datetime.now().getTime());
            String uniqueName = orgId + dateString +'@test.com';
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName);
            insert u;
            Contact ObjContact = new Contact(FirstName='fname', LastName = 'lname', Email = 'email@gmail.com', Phone = '9743800309', IAM_Contact_Owner__c = UserInfo.getUserId(), Username__c = 'email@gmail.com.fulluat');//UserInfo.getUserName());  
            insert ObjContact;
            
            
            //System.runAs(u) {
                System.debug('UserId\t'+UserInfo.getUserName()+'??Contact\t'+ObjContact);
                List<Account>  lstacc = new List<Account>();
                Account acc = new Account();
                RecordType recid =[select id from recordType where name='wwsps' limit 1];  
                acc.RecordTypeId= recid.id;       
                acc.Name = 'Test Account';
                
                acc.CMI_Account_Status__c = 'Active';
                acc.CMI_CDA_Status__c = 'New Customer Request';
                acc.CMI_Region__c = 'NORTH AMERICA';
                acc.CSS_Language__c = 'English';
                lstacc.add(acc);
                insert lstacc;

                
              List<ccrz__E_Order__c>  lstCCOrder = new List<ccrz__E_Order__c>();
                ccrz__E_Order__c  objCCOrder = new ccrz__E_Order__c();               
                objCCOrder.ccrz__Account__c = acc.ID;
                objCCOrder.OSM_SW_Should_mail_Send__c = true;
                objCCOrder.OSM_SW_Is_InterCompany_Order__c = false;
                objCCOrder.ccrz__OrderStatus__c='Order Submitted'; 
                objCCOrder.Send_SSOEM_Customer_Email__c = true;                 
              lstCCOrder.add(objCCOrder);
              ccrz__E_Order__c  objCCOrder2 = objCCOrder.clone();
              objCCOrder2.Purchased_By_User_Type__c = Label.OSM_SSOEM_Admin_UserType;
              lstCCOrder.add(objCCOrder2);
                insert lstCCOrder;
                
                  ccrz__E_Product__c pro1 = new ccrz__E_Product__c();
                    pro1.Name = 'guidenz';
                    pro1.ccrz__SKU__c = '5678902-OHT11';
                    pro1.ccrz__Quantityperunit__c = 1;
                    pro1.Group_Name__c = 'SES';
                    //pro.ccrz__ParentProduct__c = parentpro.id;
                    pro1.Product_Class_Code__c = 'SW-Web Access';
                    insert pro1;
                
                ccrz__E_OrderItem__c oi11 = new ccrz__E_OrderItem__c();
                oi11.ccrz__Price__c = 500;
                oi11.ccrz__OriginalItemPrice__c = 400;
                oi11.ccrz__Quantity__c = 1;
                oi11.ccrz__SubAmount__c = 123;
                oi11.ccrz__Order__c = lstCCOrder[0].id;
                oi11.ccrz__Product__c =pro1.id;
                oi11.ccrz__Subscription_Auto_Renewal__c = true;
                oi11.ccrz__DisplayProduct__c = pro1.id;
                //oi11.ccrz__SubProdTerm__c = spt.id;
                oi11.Dn_Price__c = 1000;
                insert oi11;
                
                ccrz__E_Product__c objCCProduct = new ccrz__E_Product__c(name = 'Test', ccrz__SKU__c = '1234', ccrz__Quantityperunit__c = 1.000000, ccrz__StartDate__c = Date.parse('5/14/2020'), ccrz__EndDate__c = Date.parse('12/31/2099'));                insert objCCProduct;
              List<ccrz__E_Subscription__c> lstobjE_Subscription = new List<ccrz__E_Subscription__c>();
                ccrz__E_Subscription__c objE_Subscription = new ccrz__E_Subscription__c();
                
                objE_Subscription.OSM_Display_Product__c = objCCProduct.id;
                objE_Subscription.ccrz__SubscriptionProduct__c = objCCProduct.Id;
                objE_Subscription.ccrz__CCOrder__c = lstCCOrder[0].Id;
                objE_Subscription.ccrz__SubscriptionStartDate__c = System.today()- Integer.valueof('10'); 
                objE_Subscription.OSM_Subscription_End_Date__c = system.now().addDays(-29);
                objE_Subscription.ccrz__SubscriptionStatus__c = 'Active' ;
                objE_Subscription.Contact__c = ObjContact.Id;
                objE_Subscription.ccrz__Sequence__c = 1234567;
              objE_Subscription.ccrz__Storefront__c = 'SoftwareStore'  ;
              objE_Subscription.ccrz__Quantity__c = 10;
              objE_Subscription.ccrz__Account__c = acc.ID;
              objE_Subscription.ccrz__Sequence__c = 500;             
              lstobjE_Subscription.add(objE_Subscription);
              ccrz__E_Subscription__c objE_Subscription2 = objE_Subscription.clone();
              lstobjE_Subscription.add(objE_Subscription2);
              objE_Subscription.ccrz__CCOrder__c = lstCCOrder[1].Id;
                insert lstobjE_Subscription;
              System.assert(objE_Subscription.Id != null);
              
                List<ccrz__E_Invoice__c> listInv = new List<ccrz__E_Invoice__c>();
                ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c ();
                inv.BMS_InvoiceNumber__c = 987454;
                inv.ccrz__CurrencyCode__c = 'USD';
                inv.Recurring_Invoice__c=false;
                inv.OSM_SW_Is_Bolt_PO__c=false;
                inv.OSM_SW_IsIntercompanyInvoice__c=false;
                inv.OSM_PDF_Received__c=false;
                inv.ccrz__CCOrder__c=objCCOrder.id;
                listInv.add(inv);
                insert listInv;
                
                 //invoice items
                ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
                invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
                invoiceItem_Item.ccrz__Invoice__c = listInv[0].id;
                invoiceItem_Item.ccrz__CCOrderItem__c = oi11.id;
                invoiceItem_Item.ccrz__CCOrder__c = lstCCOrder[0].id;
                invoiceItem_Item.Quantity__c = 1;
                //invoiceItem_Item.CC_Subscription__c = subscriptionID;
                invoiceItem_Item.ccrz__Status__c = 'Open';
                invoiceItem_Item.ccrz__Type__c = 'Item';
                insert invoiceItem_Item;
                 
                Attachment att = new Attachment();
                att.name = 'Invoice.PDF';
                att.parentId = listInv[0].id;
                //att.Body = req.requestBody;
                insert att;
               
                
              
            //}
        }catch(Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }  
                    
    }
     // Create CC Invoices
   public static testMethod void createTestData(){
        PdfGeneratorController.InvoiceLineItemDetail rec=new PdfGeneratorController.InvoiceLineItemDetail(); 
        rec.productName='test';
        rec.orderName='test';
        rec.quantity=1;
        rec.amount=1.0;
        rec.BillingFrequency='1';
        rec.subLength='1';
        rec.NumberofBundles = 1.0;//LL55 3rd Aug 2022 @Vishnu NoB InvPDF
        ccrz__E_Invoice__c invoice=[select id from ccrz__E_Invoice__c where BMS_InvoiceNumber__c = 987454];
        ccrz__E_TransactionPayment__c transPayment=new ccrz__E_TransactionPayment__c();
        transPayment.ccrz__InvoiceAppliedTo__c=invoice.id;
        transPayment.ccrz__AccountType__c='cc';
        transPayment.Transaction_Status__c='Order Placed Success';
        //transPayment.ccrz__CCOrder__c=lstCCOrder[0].id;
        insert transPayment;
        PageReference pref = Page.PdfGeneratorTemplate;       
        pref.getParameters().put('id',invoice.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController con = new ApexPages.StandardController(invoice);
        PdfGeneratorController mycon = new PdfGeneratorController(con);

    }
    
}