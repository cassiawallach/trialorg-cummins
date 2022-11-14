public class Dbu_Vertex_Service_Helper {
	public static dbu_VertexQuoteRequestWrapper populateDynamicData(dbu_Vertex_GeneralizedInputWrapper objGeneralInputWrp)
    {
        
    // Defining variable whose values will come through custom label(Static)

        /*String CompanyCode = System.Label.OSM_Vertex_Company_Code;
        String DivingCode = System.Label.OSM_Vertex_Diving_Code;
        String Physical_Origin_AddressLine1 = System.Label.OSM_Vertex_Physical_Origin_AddressLine1;
        String Physical_Origin_City = System.Label.OSM_Vertex_Physical_Origin_City;
        String Physical_Origin_State = System.Label.OSM_Vertex_Physical_Origin_State;
        String Physical_Origin_Postal_Code = System.Label.OSM_Vertex_Physical_Origin_Postal_Code;
        String Physical_Origin_Country = System.Label.OSM_Vertex_Physical_Origin_Country;
        String Flex_Field_Code_BC = System.Label.OSM_Vertex_Flex_Field_Code_BC;
        String Flex_Field_Code_RC = System.Label.OSM_Vertex_Flex_Field_Code_RC;
        
        String Service_Name_Quote = System.Label.OSM_Vertex_Service_Name_Quote;
        String Service_Name_Invoice = System.Label.OSM_Vertex_Service_Name_Invoice;
        String Service_Name_Invoice_Refund = System.Label.OSM_Vertex_Service_Name_Invoice_Refund;
        String Sender_ID = System.Label.OSM_Vertex_Sender_ID;
        String Target_ID = System.Label.OSM_Vertex_Target_ID;
        //String Transaction_ID = System.Label.OSM_Vertex_Transaction_ID;
        String Transaction_ID = '';
        String Transaction_Type = System.Label.OSM_Vertex_Transaction_Type;
        String Invoice_Request_Document_Number = System.Label.OSM_Vertex_Invoice_Request_Document_Number;
        String Quotation_Request_Document_Number = System.Label.OSM_Vertex_Quotation_Request_Document_Number;
        String strUOM = System.Label.OSM_SW_Vertex_UOM;*/

        String CompanyCode = System.Label.dbu_Vertex_Company_Code;//Done
        /**
         * shriram: 4th Feb 2021 This code is for Canada/USA address and division change custom labels
        */

        String DivingCode = '',Physical_Origin_AddressLine1 = '',Physical_Origin_City= '',Physical_Origin_State = '',Physical_Origin_Postal_Code= '',Physical_Origin_Country = '',Flex_Field_Code_BC = '',Flex_Field_Code_RC = '';
        if(String.isNotBlank(objGeneralInputWrp.DataArea.Customer.Destination_Addesss.Country) && ((objGeneralInputWrp.DataArea.Customer.Destination_Addesss.Country).equalsIgnoreCase('CANADA') || (objGeneralInputWrp.DataArea.Customer.Destination_Addesss.Country).equalsIgnoreCase('CA'))){
                DivingCode = System.Label.dbu_Vertex_Diving_Code_CANADA;//Done
                Physical_Origin_AddressLine1 = System.Label.dbu_Vertex_Physical_Origin_AddressLine1_CANADA;//Done
                Physical_Origin_City = System.Label.dbu_Vertex_Physical_Origin_City_CANADA;//Done
                Physical_Origin_State = System.Label.dbu_Vertex_Physical_Origin_State_CANADA;//Done
                Physical_Origin_Postal_Code = System.Label.dbu_Vertex_Physical_Origin_Postal_Code_CANADA;//Done
                Physical_Origin_Country = System.Label.dbu_Vertex_Physical_Origin_Country_CANADA;//Done
                Flex_Field_Code_BC = System.Label.dbu_Vertex_Flex_Field_Code_BC_CANADA;
                Flex_Field_Code_RC = System.Label.dbu_Vertex_Flex_Field_Code_RC_CANADA;
        }else{

                DivingCode = System.Label.dbu_Vertex_Diving_Code;//Done
                Physical_Origin_AddressLine1 = System.Label.dbu_Vertex_Physical_Origin_AddressLine1;//Done
                Physical_Origin_City = System.Label.dbu_Vertex_Physical_Origin_City;//Done
                Physical_Origin_State = System.Label.dbu_Vertex_Physical_Origin_State;//Done
                Physical_Origin_Postal_Code = System.Label.dbu_Vertex_Physical_Origin_Postal_Code;//Done
                Physical_Origin_Country = System.Label.dbu_Vertex_Physical_Origin_Country;//Done
                Flex_Field_Code_BC = System.Label.dbu_Vertex_Flex_Field_Code_BC;
                Flex_Field_Code_RC = System.Label.dbu_Vertex_Flex_Field_Code_RC;
        }
        /**
         * Ended here
         */
        /*Shriram:12th Feb 2021 commented bcoz using specifice code country wise String Flex_Field_Code_BC = System.Label.dbu_Vertex_Flex_Field_Code_BC;//Done
        String Flex_Field_Code_RC = System.Label.dbu_Vertex_Flex_Field_Code_RC;//Done*/
        
        String Service_Name_Quote = System.Label.dbu_Vertex_Service_Name_Quote;//Done
        String Service_Name_Invoice = System.Label.dbu_Vertex_Service_Name_Invoice;//Done
        String Service_Name_Invoice_Refund = System.Label.dbu_Vertex_Service_Name_Invoice_Refund;//Done
        String Sender_ID = System.Label.dbu_Vertex_Sender_ID;//Need to change the value as DBU instead of OSM
        String Target_ID = System.Label.dbu_Vertex_Target_ID;//Done
        //String Transaction_ID = System.Label.OSM_Vertex_Transaction_ID;
        String Transaction_ID = '';
        String Transaction_Type = System.Label.dbu_Vertex_Transaction_Type;
        String Invoice_Request_Document_Number = System.Label.dbu_Vertex_Invoice_Request_Document_Number;
        String Quotation_Request_Document_Number = System.Label.dbu_Vertex_Quotation_Request_Document_Number;
        String strUOM = System.Label.dbu_SW_Vertex_UOM;
        
    
    dbu_VertexQuoteRequestWrapper objReq = new dbu_VertexQuoteRequestWrapper();
    objReq.Header = new dbu_VertexQuoteRequestWrapper.Header();
    objReq.Header.Sender = new dbu_VertexQuoteRequestWrapper.Sender();
    objReq.Header.Target = new dbu_VertexQuoteRequestWrapper.Target();
    objReq.Header.Transaction_Z = new dbu_VertexQuoteRequestWrapper.Transaction_Z();
    objReq.DataArea = new dbu_VertexQuoteRequestWrapper.DataArea();
    objReq.DataArea.Seller = new dbu_VertexQuoteRequestWrapper.Seller();
    objReq.DataArea.Seller.Physical_Origin = new dbu_VertexQuoteRequestWrapper.Physical_Origin();
    objReq.DataArea.Seller.AdministrativeOrigin = new dbu_VertexQuoteRequestWrapper.AdministrativeOrigin();
    objReq.DataArea.Customer = new dbu_VertexQuoteRequestWrapper.Customer();
    objReq.DataArea.Customer.Destination_Addesss = new dbu_VertexQuoteRequestWrapper.Physical_Origin();
    objReq.DataArea.Customer.Administrive_Destination = new dbu_VertexQuoteRequestWrapper.Administrive_Destination();
    objReq.DataArea.ProductList = new List<dbu_VertexQuoteRequestWrapper.ProductList>();
    objReq.Header.Transaction_Z.DocumentDate = String.valueOf(System.Today());
    objReq.orderPlacementDate = String.valueOf(System.Today());
    objReq.recordId = objGeneralInputWrp.recordId;
    objReq.QuotationRequestDocumentNumber = objGeneralInputWrp.QuotationRequestDocumentNumber;//shriram:16Feb21    
    if(objGeneralInputWrp.isForQuote)
        objReq.Header.Sender.ServiceName = Service_Name_Quote;
    else
    {
        if(objGeneralInputWrp.isRefundInvoiceReq){
            objReq.Header.Sender.ServiceName = Service_Name_Invoice_Refund;
            objReq.Header.Transaction_Z.DocumentDate =objGeneralInputWrp.orderPlacementDate;}
        else
            objReq.Header.Sender.ServiceName = Service_Name_Invoice;
    }
        
        
    objReq.Header.Sender.SenderID = Sender_ID;
    objReq.Header.Target.TargetID = Target_ID;
    objReq.Header.Transaction_Z.TransactionID = Transaction_ID;
    objReq.Header.Transaction_Z.Transaction_Type = Transaction_Type;
    objReq.Header.Transaction_Z.Trusted_ID = '';
    if(objGeneralInputWrp.isForQuote)
        objReq.Header.Transaction_Z.QuotationRequestDocumentNumber = objGeneralInputWrp.QuotationRequestDocumentNumber;
    //else shriram
        //objReq.Header.Transaction_Z.InvoiceRequestDocumentNumber = objGeneralInputWrp.InvoiceRequestDocumentNumber;
    
   
    
    objReq.DataArea.DiscountPercent = '';
    objReq.DataArea.DiscountAmount  = objGeneralInputWrp.DataArea.DiscountAmount;
    objReq.DataArea.Customer.Customer_Code = objGeneralInputWrp.DataArea.Customer.Customer_Code;
    //objReq.DataArea.Customer.Customer_Class_Code  = objGeneralInputWrp.DataArea.Customer.Customer_Class_Code ;
    
    objReq.DataArea.Seller.Company_Code = CompanyCode;

    objReq.DataArea.Seller.Division_Code = DivingCode;
     
    objReq.DataArea.Seller.Physical_Origin.AddressLine1 = Physical_Origin_AddressLine1;
    objReq.DataArea.Seller.Physical_Origin.AddressLine2 = '';
    objReq.DataArea.Seller.Physical_Origin.City = Physical_Origin_City;
    objReq.DataArea.Seller.Physical_Origin.State = Physical_Origin_State;
    objReq.DataArea.Seller.Physical_Origin.Postal_Code = Physical_Origin_Postal_Code;
    objReq.DataArea.Seller.Physical_Origin.Country = Physical_Origin_Country;
    
    
    
    objReq.DataArea.Seller.AdministrativeOrigin.AddressLine1 = Physical_Origin_AddressLine1;
    objReq.DataArea.Seller.AdministrativeOrigin.AddressLine2 = '';
    objReq.DataArea.Seller.AdministrativeOrigin.City = Physical_Origin_City;
    objReq.DataArea.Seller.AdministrativeOrigin.State = Physical_Origin_State;
    objReq.DataArea.Seller.AdministrativeOrigin.Postal_Code = Physical_Origin_Postal_Code;
    objReq.DataArea.Seller.AdministrativeOrigin.Country = Physical_Origin_Country;
    
    
    objReq.DataArea.Customer.Destination_Addesss.AddressLine1 = objGeneralInputWrp.DataArea.Customer.Destination_Addesss.AddressLine1;
    objReq.DataArea.Customer.Destination_Addesss.AddressLine2 = objGeneralInputWrp.DataArea.Customer.Destination_Addesss.AddressLine2;
    objReq.DataArea.Customer.Destination_Addesss.City = objGeneralInputWrp.DataArea.Customer.Destination_Addesss.City;
    objReq.DataArea.Customer.Destination_Addesss.State = objGeneralInputWrp.DataArea.Customer.Destination_Addesss.State;
    objReq.DataArea.Customer.Destination_Addesss.Postal_Code = objGeneralInputWrp.DataArea.Customer.Destination_Addesss.Postal_Code;
    objReq.DataArea.Customer.Destination_Addesss.Country = objGeneralInputWrp.DataArea.Customer.Destination_Addesss.Country;
    
    
    objReq.DataArea.Customer.Administrive_Destination.AddressLine1 = objGeneralInputWrp.DataArea.Customer.Administrive_Destination.AddressLine1;
    objReq.DataArea.Customer.Administrive_Destination.AddressLine2 = objGeneralInputWrp.DataArea.Customer.Administrive_Destination.AddressLine2;
    objReq.DataArea.Customer.Administrive_Destination.City = objGeneralInputWrp.DataArea.Customer.Administrive_Destination.City;
    objReq.DataArea.Customer.Administrive_Destination.Administrative_Main_Division = objGeneralInputWrp.DataArea.Customer.Administrive_Destination.State;
    objReq.DataArea.Customer.Administrive_Destination.Postal_Code = objGeneralInputWrp.DataArea.Customer.Administrive_Destination.Postal_Code;
    objReq.DataArea.Customer.Administrive_Destination.Country = objGeneralInputWrp.DataArea.Customer.Administrive_Destination.Country;
    
    
        
        for(dbu_Vertex_GeneralizedInputWrapper.ProductList objCartLine : objGeneralInputWrp.DataArea.ProductList)
        {
            dbu_VertexQuoteRequestWrapper.ProductList objProductLineItem = new dbu_VertexQuoteRequestWrapper.ProductList();
            
            objProductLineItem.LineItemNumber = objCartLine.LineItemNumber;
            objProductLineItem.ProductCode = objCartLine.ProductCode;
            objProductLineItem.ProductClassCode = objCartLine.ProductClassCode ;
            objProductLineItem.Quantity = objCartLine.Quantity;
            /* Added on 16th April 2021*/
            objProductLineItem.UnitOfMeasure = objCartLine.UnitOfMeasure;
            // if((objProductLineItem.UnitOfMeasure).equalsIgnoreCase('Each')){
            //     objProductLineItem.UnitOfMeasure = System.Label.dbu_Vertex_Each;
            // }
            objProductLineItem.Quantityperunit = objCartLine.Quantityperunit;
            objProductLineItem.ExtendedPrice = objCartLine.ExtendedPrice;
            //objProductLineItem.UnitOfMeasure = strUOM;
            objProductLineItem.UserDefinedDiscountCode = objCartLine.UserDefinedDiscountCode;
            ///* Commented on 16th April 2021*/ objProductLineItem.UnitOfMeasure = '1';
            objProductLineItem.DiscountPercentage = '';
            objProductLineItem.DiscountAmount = objCartLine.DiscountAmount;
            objProductLineItem.CustomerName = objCartLine.CustomerName;
            //commented on 12thfeb21 objProductLineItem.BC = objCartLine.BC;
            objProductLineItem.BC = Flex_Field_Code_BC;
            objProductLineItem.RC = Flex_Field_Code_RC;
            objReq.DataArea.ProductList.add(objProductLineItem);
        }
    
        
        return objReq;
    }
    
}