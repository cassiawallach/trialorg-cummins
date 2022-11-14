public class OSM_CC_Vertex_Service_Helper
{
    public static OSM_VERTEX_WS_CalculateTaxReq populateDynamicData(OSM_VERTEX_WS_GeneralizedInputWrapper objGeneralInputWrp)
    {
        
    // Defining variable whose values will come through custom label(Static)

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
        String Service_Name_Invoice = System.Label.OSM_Vertex_Service_Name_Invoice;
        String Service_Name_Invoice_Refund = System.Label.OSM_Vertex_Service_Name_Invoice_Refund;
        String Sender_ID = System.Label.OSM_Vertex_Sender_ID;
        String Target_ID = System.Label.OSM_Vertex_Target_ID;
        //String Transaction_ID = System.Label.OSM_Vertex_Transaction_ID;
        String Transaction_ID = '';
        String Transaction_Type = System.Label.OSM_Vertex_Transaction_Type;
        String Invoice_Request_Document_Number = System.Label.OSM_Vertex_Invoice_Request_Document_Number;
        String Quotation_Request_Document_Number = System.Label.OSM_Vertex_Quotation_Request_Document_Number;
        String strUOM = System.Label.OSM_SW_Vertex_UOM;
        
    
    OSM_VERTEX_WS_CalculateTaxReq objReq = new OSM_VERTEX_WS_CalculateTaxReq();
    objReq.Header = new OSM_VERTEX_WS_CalculateTaxReq.Header();
    objReq.Header.Sender = new OSM_VERTEX_WS_CalculateTaxReq.Sender();
    objReq.Header.Target = new OSM_VERTEX_WS_CalculateTaxReq.Target();
    objReq.Header.Transaction_Z = new OSM_VERTEX_WS_CalculateTaxReq.Transaction_Z();
    objReq.DataArea = new OSM_VERTEX_WS_CalculateTaxReq.DataArea();
    objReq.DataArea.Seller = new OSM_VERTEX_WS_CalculateTaxReq.Seller();
    objReq.DataArea.Seller.Physical_Origin = new OSM_VERTEX_WS_CalculateTaxReq.Physical_Origin();
    objReq.DataArea.Seller.AdministrativeOrigin = new OSM_VERTEX_WS_CalculateTaxReq.Physical_Origin();
    objReq.DataArea.Customer = new OSM_VERTEX_WS_CalculateTaxReq.Customer();
    objReq.DataArea.Customer.Destination_Addesss = new OSM_VERTEX_WS_CalculateTaxReq.Physical_Origin();
    objReq.DataArea.Customer.Administrive_Destination = new OSM_VERTEX_WS_CalculateTaxReq.Administrive_Destination();
    objReq.DataArea.ProductList = new List<OSM_VERTEX_WS_CalculateTaxReq.ProductList>();
    objReq.Header.Transaction_Z.DocumentDate = String.valueOf(System.Today());
    
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
    else
        objReq.Header.Transaction_Z.InvoiceRequestDocumentNumber = objGeneralInputWrp.InvoiceRequestDocumentNumber;
    
   
    
    objReq.DataArea.DiscountPercent = '';
    //objReq.DataArea.DiscountAmount  = objGeneralInputWrp.DataArea.DiscountAmount;
    objReq.DataArea.DiscountAmount  = '';
    objReq.DataArea.Customer.Customer_Code = objGeneralInputWrp.DataArea.Customer.Customer_Code;
    //objReq.DataArea.Customer.Customer_Class_Code  = objGeneralInputWrp.DataArea.Customer.Customer_Class_Code ;
    
    objReq.DataArea.Seller.Company_Code = CompanyCode;
    //MAR-1947 Code Start
    if(objGeneralInputWrp.DataArea.divisionCode != Null){
        objReq.DataArea.Seller.Division_Code = objGeneralInputWrp.DataArea.divisionCode;
    }else{
        objReq.DataArea.Seller.Division_Code = DivingCode;
    }//MAR-1947 Code End
    
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
    
    
        
        for(OSM_VERTEX_WS_GeneralizedInputWrapper.ProductList objCartLine : objGeneralInputWrp.DataArea.ProductList)
        {
            OSM_VERTEX_WS_CalculateTaxReq.ProductList objProductLineItem = new OSM_VERTEX_WS_CalculateTaxReq.ProductList();
            
            objProductLineItem.LineItemNumber = objCartLine.LineItemNumber;
            objProductLineItem.ProductCode = objCartLine.ProductCode;
            objProductLineItem.ProductClassCode = objCartLine.ProductClassCode ;
            objProductLineItem.Quantity = objCartLine.Quantity;
            //objProductLineItem.UnitOfMeasure = objCartLine.UnitOfMeasure;
            objProductLineItem.ExtendedPrice = objCartLine.ExtendedPrice;
            objProductLineItem.UnitOfMeasure = strUOM;
            objProductLineItem.DiscountPercentage = '';
            objProductLineItem.DiscountAmount = objCartLine.DiscountAmount;
            if(objProductLineItem.DiscountAmount == '0.00')
                objProductLineItem.UserDefinedDiscountCode = '';   //Mar-1434
            else 
                objProductLineItem.UserDefinedDiscountCode = 'Discount';
            objProductLineItem.CustomerName = objCartLine.CustomerName;
	    //MAR-1947 Code Start
            if(objGeneralInputWrp.DataArea.SPFRC != Null){
                objProductLineItem.RC = objGeneralInputWrp.DataArea.SPFRC;
            }else{
                objProductLineItem.RC = Flex_Field_Code_RC;
            }
            if(objGeneralInputWrp.DataArea.SPFBC != Null){
                objProductLineItem.BC = objGeneralInputWrp.DataArea.SPFBC;
            }else{
                objProductLineItem.BC = objCartLine.BC;
            }//MAR-1947 Code End
            
            objReq.DataArea.ProductList.add(objProductLineItem);
        }
    
        
        return objReq;
    }
    
    

}