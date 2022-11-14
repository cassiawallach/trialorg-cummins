@isTest
public class dbu_Integration_Vertex_Test 
{
    public static testMethod void testMethod1(){
        // dbu_Vertex_GeneralizedInputWrapper objGeneralInputWrp ;
        // 
        list<dbu_Vertex_GeneralizedInputWrapper.ProductList> prodlst = new list<dbu_Vertex_GeneralizedInputWrapper.ProductList>();
        
        dbu_Vertex_GeneralizedInputWrapper.ProductList ProductList = new dbu_Vertex_GeneralizedInputWrapper.ProductList();
        ProductList.BC='';
        ProductList.CustomerName='';
        ProductList.DiscountAmount='';
        ProductList.DiscountPercentage='';
        ProductList.ExtendedPrice='';
        ProductList.LineItemNumber='';
        ProductList.ProductClassCode='';
        ProductList.ProductCode='';
        ProductList.Quantity='';
        ProductList.RC='';
        ProductList.UnitOfMeasure='';
        prodlst.add(ProductList); 
        
        dbu_Vertex_GeneralizedInputWrapper.Administrive_Destination Administrive_Destination = new dbu_Vertex_GeneralizedInputWrapper.Administrive_Destination();
        Administrive_Destination.AddressLine1='';
        Administrive_Destination.AddressLine2='';
        Administrive_Destination.City='';
        Administrive_Destination.Country='';
        Administrive_Destination.Postal_Code='';
        Administrive_Destination.State='';
        

        
        dbu_Vertex_GeneralizedInputWrapper.Physical_Origin Physical_Origin = new dbu_Vertex_GeneralizedInputWrapper.Physical_Origin();
        Physical_Origin.AddressLine1='';
        Physical_Origin.AddressLine2='';
        Physical_Origin.City='';
        Physical_Origin.Country='';
        Physical_Origin.Postal_Code='';
        Physical_Origin.State='';
        
         dbu_Vertex_GeneralizedInputWrapper.Seller Seller = new dbu_Vertex_GeneralizedInputWrapper.Seller();
        Seller.Company_Code='';
        Seller.Division_Code='';
        Seller.Physical_Origin=Physical_Origin;
        Seller.AdministrativeOrigin =Physical_Origin;
        
        dbu_Vertex_GeneralizedInputWrapper.Customer Customer= new dbu_Vertex_GeneralizedInputWrapper.Customer();
        Customer.Customer_Code='';
        Customer.Administrive_Destination =Administrive_Destination;
        Customer.Destination_Addesss=Physical_Origin;
        
                
        dbu_Vertex_GeneralizedInputWrapper.DataArea DataArea = new dbu_Vertex_GeneralizedInputWrapper.DataArea();
        DataArea.Customer=Customer;
        DataArea.DiscountAmount='';
        DataArea.ProductList=prodlst; 
        DataArea.Seller=Seller;
        
        dbu_Vertex_GeneralizedInputWrapper objGeneralInputWrp = new dbu_Vertex_GeneralizedInputWrapper();
        objGeneralInputWrp.isForQuote=true;
        objGeneralInputWrp.isRefundInvoiceReq=true;
        objGeneralInputWrp.orderPlacementDate='';
        objGeneralInputWrp.recordId='';
        objGeneralInputWrp.QuotationRequestDocumentNumber='';
        objGeneralInputWrp.InvoiceRequestDocumentNumber='';
        objGeneralInputWrp.DataArea=DataArea;
        Dbu_Vertex_Service_Helper obj =new Dbu_Vertex_Service_Helper();
     
        //= dbu_Vertex_GeneralizedoutputWrapper;
        Dbu_Vertex_Service_Helper.populateDynamicData(objGeneralInputWrp);
       // dbu_Vertex_GeneralizedoutputWrapper inputparam;
       // 
       
       List<CSS_Integration_Details__c> lstcus = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c customsettn = new CSS_Integration_Details__c();
        customsettn.Name = 'dbu_VertexQuote_Service';
        customsettn.Method_Type__c = 'GET';
        customsettn.End_Point__c = 'tstets';
        customsettn.Key__c = 'sss';
        customsettn.Passcode__c = 'dd';
        customsettn.Resource__c = 'dsss';
        customsettn.Logging__c = 'ppp';
        
        
        
        lstcus.add(customsettn);
        
        CSS_Integration_Details__c customsettn2 = new CSS_Integration_Details__c();
        customsettn2.Name = 'dbu_VertexQuote_Auth';
        customsettn2.Method_Type__c = 'GET';
        customsettn2.End_Point__c = 'tstets';
        customsettn2.Key__c = 'sss';
        customsettn2.Passcode__c = 'dd';
        customsettn2.Resource__c = 'dsss';
        customsettn2.Logging__c = 'ppp';
        lstcus.add(customsettn2);
        
        CSS_Integration_Details__c customsettn3 = new CSS_Integration_Details__c();
        customsettn3.Name = 'VertexQuote';
        customsettn3.Method_Type__c = 'GET';
        customsettn3.End_Point__c = 'tstets';
        customsettn3.Key__c = 'sss';
        customsettn3.Passcode__c = 'dd';
        customsettn3.Resource__c = 'dsss';
        customsettn3.Logging__c = 'ppp';
        lstcus.add(customsettn3);
        
        
        insert lstcus;
         Test.startTest();
            Test.setMock(HttpCalloutMock.class, new dbu_Integration_Vertex_Mock()); 
        dbu_Integration_Vertex.getTaxQuote(objGeneralInputWrp);
        dbu_Integration_Vertex.getTaxInvoice(objGeneralInputWrp);
        //dbu_Integration_Vertex.getAccessToken();
        
        dbu_Integration_Vertex.dbuVertexInvoiceRequestWrapper ii = new dbu_Integration_Vertex.dbuVertexInvoiceRequestWrapper();
        ii.Header = new dbu_Integration_Vertex.Header();
        ii.Header.Transaction_Z = new dbu_Integration_Vertex.Transaction_Z();
        ii.Header.Transaction_Z.Trusted_ID = 'test';
        ii.Header.Transaction_Z.TransactionID = 'test';
        ii.Header.Transaction_Z.Transaction_Type = 'test';
        ii.Header.Transaction_Z.InvoiceRequestDocumentNumber = 'test';
        ii.Header.Transaction_Z.DocumentDate = 'test';
        
        ii.Header.Target = new dbu_Integration_Vertex.Target();
        ii.Header.Target.TargetID = 'dd';
        
        ii.Header.Sender = new dbu_Integration_Vertex.Sender();
        ii.Header.Sender.ServiceName = 'ssss';
        ii.Header.Sender.SenderID = 'ssss';
        
        ii.DataArea = new dbu_Integration_Vertex.DataArea();
        ii.DataArea.Seller = new dbu_Integration_Vertex.Seller();
        ii.DataArea.Seller.Physical_Origin = new dbu_Integration_Vertex.Physical_Origin();
        ii.DataArea.Seller.Physical_Origin.State = 'sdd';
        ii.DataArea.Seller.Physical_Origin.Postal_Code = 'sdd';
        ii.DataArea.Seller.Physical_Origin.Country = 'sdd';
        ii.DataArea.Seller.Physical_Origin.City = 'sdd';
        ii.DataArea.Seller.Physical_Origin.AddressLine2 = 'sdd';
        ii.DataArea.Seller.Physical_Origin.AddressLine1 = 'sdd';
        ii.DataArea.Seller.Division_Code = 'sdd';
        ii.DataArea.Seller.Company_Code = 'sdd';
        
        ii.DataArea.Seller.AdministrativeOrigin = new dbu_Integration_Vertex.AdministrativeOrigin();
        ii.DataArea.Seller.AdministrativeOrigin.Postal_Code = 'ss';
        ii.DataArea.Seller.AdministrativeOrigin.Country = 'ss';
        ii.DataArea.Seller.AdministrativeOrigin.City = 'ss';
        //ii.DataArea.Seller.AdministrativeOrigin.Administrative_Main_Division = 'ss';
        ii.DataArea.Seller.AdministrativeOrigin.AddressLine2 = 'ss';
        ii.DataArea.Seller.AdministrativeOrigin.AddressLine1 = 'ss';
        
        
        ii.DataArea.Customer = new dbu_Integration_Vertex.Customer();
        ii.DataArea.Customer.Destination_Addesss = new dbu_Integration_Vertex.Destination_Addesss();
        ii.DataArea.Customer.Customer_Code ='ddd';
        ii.DataArea.Customer.Administrive_Destination = new dbu_Integration_Vertex.Administrive_Destination();
        
        
        ii.DataArea.DiscountPercent = 'sss';
        ii.DataArea.DiscountAmount = 'sss';
        ii.DataArea.ProductList = new List<dbu_Integration_Vertex.ProductList>();
        dbu_Integration_Vertex.ProductList ll = new dbu_Integration_Vertex.ProductList();
        
        ll.UnitOfMeasure = 'sss';
        ll.RC = 'sss';
        ll.Quantity = 'sss';
        ll.ProductCode = 'sss';
        ll.ProductClassCode = 'sss';
        ll.LineItemNumber = 'sss';
        ll.ExtendedPrice = 'sss';
        ll.DiscountPercentage = 'sss';
        ll.DiscountAmount = 'sss';
        ll.CustomerName = 'sss';
        ll.BC = 'sss';
        ii.DataArea.ProductList.add(ll);
        
        
        
        Test.stopTest();
    }
}
//Prod Deployment 23-09-22