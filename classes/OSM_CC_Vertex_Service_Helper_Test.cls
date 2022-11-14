//Adding test class for deployment
@isTest
public class OSM_CC_Vertex_Service_Helper_Test {

    static testMethod void testVertex_Service_Helper(){
    
    String CompanyCode = System.Label.OSM_Vertex_Company_Code;
    String DivingCode = System.Label.OSM_Vertex_Diving_Code;
    String Physical_Origin_AddressLine1 = System.Label.OSM_Vertex_Physical_Origin_AddressLine1;
    String Physical_Origin_City = System.Label.OSM_Vertex_Physical_Origin_City;
    String Physical_Origin_State = System.Label.OSM_Vertex_Physical_Origin_State;
    String Physical_Origin_Postal_Code = System.Label.OSM_Vertex_Physical_Origin_Postal_Code;
    String Physical_Origin_Country = System.Label.OSM_Vertex_Physical_Origin_Country;
    String Flex_Field_Code_BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
    String Flex_Field_Code_RC = System.Label.OSM_Vertex_Flex_Field_Code_RC;
    String Service_Name_Quote = System.Label.OSM_Vertex_Service_Name_Quote;
      
    test.starttest();
    
    
    OSM_VERTEX_WS_GeneralizedInputWrapper.DataArea gendata = new OSM_VERTEX_WS_GeneralizedInputWrapper.DataArea();
    gendata.DiscountAmount = '579'; 
    
     OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin org1 = new OSM_VERTEX_WS_GeneralizedInputWrapper.Physical_Origin();
    org1.AddressLine1 ='adderss1';
    org1.AddressLine2  ='adderss22';
    org1.City  ='Noida';
    org1.Postal_Code  ='201001';
    org1.Country  ='India';
    org1.State  ='UP';
    
    OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList prodList = new OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList();
    prodList.LineItemNumber  = '12';
    prodList.ProductCode   = '11';
    prodList.ProductClassCode  = '12';
    prodList.Quantity   = '1';
    prodList.UnitOfMeasure   = '2';
    prodList.ExtendedPrice   = '120';
    prodList.DiscountPercentage   = '2';
    prodList.DiscountAmount   = '5';
    prodList.CustomerName   = 'TestName';
    prodList.BC = 'TestBC';
    prodList.RC = 'TestRC';
    
    OSM_VERTEX_WS_GeneralizedInputWrapper.Administrive_Destination dest1 = new OSM_VERTEX_WS_GeneralizedInputWrapper.Administrive_Destination ();
    dest1.AddressLine1 ='adderss1';
    dest1.AddressLine2  ='adderss22';
    dest1.City  ='Noida';
    dest1.Postal_Code  ='201001';
    dest1.Country  ='India';
    dest1.State  ='UP';
    
    OSM_VERTEX_WS_GeneralizedInputWrapper.Seller sell1 = new OSM_VERTEX_WS_GeneralizedInputWrapper.Seller();
    sell1.Company_Code = '101';
    sell1.Division_Code = '102';
    
    OSM_VERTEX_WS_GeneralizedInputWrapper.Customer cust = new OSM_VERTEX_WS_GeneralizedInputWrapper.Customer();
    cust.Customer_Code = '101';
    
      

    
    system.debug('>>>>>'+gendata.DiscountAmount);
    //wrap.DataArea.DiscountAmount = gendata.DiscountAmount;
    OSM_VERTEX_WS_CalculateTaxReq.DataArea dataar = new OSM_VERTEX_WS_CalculateTaxReq.DataArea();
    //dataar.DiscountAmount = '552';
    //dataar.DiscountPercent ='';
    //dataar.Seller = 
    
    
    OSM_VERTEX_WS_CalculateTaxReq.Seller sell  = new OSM_VERTEX_WS_CalculateTaxReq.Seller();
    sell.Company_Code = CompanyCode;
    sell.Division_Code  = DivingCode;
    
    OSM_VERTEX_WS_CalculateTaxReq.Physical_Origin  org  = new OSM_VERTEX_WS_CalculateTaxReq.Physical_Origin();
    org.AddressLine1 =Physical_Origin_AddressLine1;
    org.AddressLine2  ='';
    org.City  =Physical_Origin_City;
    org.State  =Physical_Origin_State;
    org.Postal_Code  =Physical_Origin_Postal_Code;
    org.Country  =Physical_Origin_Country;
    
    OSM_VERTEX_WS_CalculateTaxReq.Customer customers  = new OSM_VERTEX_WS_CalculateTaxReq.Customer();
    customers.Customer_Code = '101';
    
    OSM_VERTEX_WS_CalculateTaxReq.Administrive_Destination dest  = new OSM_VERTEX_WS_CalculateTaxReq.Administrive_Destination();
    dest.AddressLine1 ='adderss1';
    dest.AddressLine2  ='adderss22';
    dest.City  ='Noida';
    dest.Postal_Code  ='201001';
    dest.Country  ='India';
    dest.Administrative_Main_Division  ='India';
    
    OSM_VERTEX_WS_CalculateTaxReq.Sender send  = new OSM_VERTEX_WS_CalculateTaxReq.Sender();
    send.ServiceName  = 'QuotationRequest';
    send.SenderID ='abc';
    
    OSM_VERTEX_WS_CalculateTaxReq.Target  targt  = new OSM_VERTEX_WS_CalculateTaxReq.Target();
    targt.TargetID ='abcTargetId';
    
    OSM_VERTEX_WS_CalculateTaxReq.Transaction_Z trans  = new OSM_VERTEX_WS_CalculateTaxReq.Transaction_Z();
    trans.TransactionID = 'TransactionID';
    trans.Transaction_Type = 'Transaction_Type';
    trans.Trusted_ID = '222222';
    trans.QuotationRequestDocumentNumber = '222';
    trans.InvoiceRequestDocumentNumber = '2222';
    trans.DocumentDate = '4/19/2018';
    
    

   
    
    OSM_VERTEX_WS_CalculateTaxReq req = new OSM_VERTEX_WS_CalculateTaxReq();
    OSM_VERTEX_WS_GeneralizedInputWrapper wrap = new OSM_VERTEX_WS_GeneralizedInputWrapper();
    wrap.isForQuote = true;
    wrap.recordId = '1111';
    wrap.QuotationRequestDocumentNumber = '11';
    wrap.InvoiceRequestDocumentNumber = '22';
    wrap.isRefundInvoiceReq = true;  
   
    if(wrap.isForQuote){
     send.ServiceName  = 'QuotationRequest';
    }
    
    OSM_CC_Vertex_Service_Helper obj = new OSM_CC_Vertex_Service_Helper();
    try{
    OSM_CC_Vertex_Service_Helper.populateDynamicData(wrap);
    }catch(Exception e){}
    test.stoptest();
    
    
    }
 }