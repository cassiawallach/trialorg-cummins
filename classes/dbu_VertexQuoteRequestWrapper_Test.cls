@isTest
public class dbu_VertexQuoteRequestWrapper_Test {
    static testMethod void testParse() {
        
        dbu_VertexQuoteRequestWrapper.Transaction_z Transaction_z = new  dbu_VertexQuoteRequestWrapper.Transaction_z();
        Transaction_z.DocumentDate='55-77-2020';
        Transaction_z.QuotationRequestDocumentNumber='00000313';
        Transaction_z.Transaction_Type='SALE';
        Transaction_z.TransactionID='09887978676';
        Transaction_z.Trusted_ID='87789798';
        
        dbu_VertexQuoteRequestWrapper.Target Target = new  dbu_VertexQuoteRequestWrapper.Target();
        Target.TargetID ='Vertex';
        dbu_VertexQuoteRequestWrapper.Sender Sender = new  dbu_VertexQuoteRequestWrapper.Sender();
        Sender.SenderID='OSM';
        Sender.ServiceName='QuotationRequest';
        
        dbu_VertexQuoteRequestWrapper.Header header = new  dbu_VertexQuoteRequestWrapper.Header();
        header.Transaction_z=Transaction_z;
        header.Sender=Sender;
        header.Target=Target;
        
        dbu_VertexQuoteRequestWrapper.Administrive_Destination AD = new dbu_VertexQuoteRequestWrapper.Administrive_Destination();
        AD.AddressLine1='3701';
        AD.AddressLine2='Ashbrook Dr';
        AD.Administrative_Main_Division='IN';
        AD.City='Indiana';
        AD.Country='United States';
        AD.Postal_Code='47201';
        
        dbu_VertexQuoteRequestWrapper.AdministrativeOrigin AO = new dbu_VertexQuoteRequestWrapper.AdministrativeOrigin();
        AO.AddressLine1='IN';
        AO.AddressLine2='500 Jackson St';
        AO.City='Columbus';
        AO.Country='USA';
        AO.Postal_Code='47201-6258';
        AO.State='IN';
        
        list<dbu_VertexQuoteRequestWrapper.ProductList> prodlst = new list<dbu_VertexQuoteRequestWrapper.ProductList>();
        
        dbu_VertexQuoteRequestWrapper.ProductList product = new dbu_VertexQuoteRequestWrapper.ProductList();
        product.BC='598';
        product.CustomerName='USA Truck Inc';
        product.DiscountAmount='20.01';
        product.DiscountPercentage='2';
        product.ExtendedPrice='470.40';
        product.LineItemNumber='00001140';
        product.ProductClassCode='SW-Web Access';
        product.ProductCode='5678901-OHT';
        product.Quantity='4';
        product.RC='207';
        product.UnitOfMeasure='1';
        prodlst.add(product);
        
        dbu_VertexQuoteRequestWrapper.Physical_Origin PO = new  dbu_VertexQuoteRequestWrapper.Physical_Origin();
        PO.AddressLine1='500 Jackson St';
        PO.AddressLine2='';
        PO.City='Columbus';
        PO.Country='USA';
        PO.Postal_Code='47201-6258';
        PO.State='IN';
        dbu_VertexQuoteRequestWrapper.Seller Seller = new dbu_VertexQuoteRequestWrapper.Seller();
        Seller.Physical_Origin=PO;
        Seller.Division_Code ='';
        Seller.Company_Code='';
        Seller.AdministrativeOrigin=AO;
        
        dbu_VertexQuoteRequestWrapper.Customer Customer = new dbu_VertexQuoteRequestWrapper.Customer();
        Customer.Customer_Code='';
        Customer.Destination_Addesss=PO;
        Customer.Administrive_Destination=AD;
        
        dbu_VertexQuoteRequestWrapper.DataArea DataArea = new  dbu_VertexQuoteRequestWrapper.DataArea(); 
        DataArea.ProductList=prodlst;
        DataArea.DiscountPercent='';
        DataArea.DiscountAmount='';
        DataArea.Seller=Seller;
        DataArea.Customer=Customer;
        
        
        dbu_VertexQuoteRequestWrapper obj = new dbu_VertexQuoteRequestWrapper();
        obj.recordId='';
        obj.QuotationRequestDocumentNumber='';
        obj.orderPlacementDate='';
        obj.Header=header;
        obj.DataArea=DataArea;
        
        //DataArea.Seller=
        //header.
        /* String json = '{'+
'   \"Header\": {'+
'       \"Transaction\": {'+
'           \"Trusted_ID\": \"\",'+
'           \"TransactionID\": \"\",'+
'           \"Transaction_Type\": \"SALE\",'+
'           \"QuotationRequestDocumentNumber\": \"00000313\",'+
'           \"DocumentDate\": \"2018-07-13\"'+
'       },'+
'       \"Target\": {'+
'           \"TargetID\": \"Vertex\"'+
'       },'+
'       \"Sender\": {'+
'           \"ServiceName\": \"QuotationRequest\",'+
'           \"SenderID\": \"OSM\"'+
'       }'+
'   },'+
'   \"DataArea\": {'+
'       \"Seller\": {'+
'           \"Physical_Origin\": {'+
'               \"State\": \"IN\",'+
'               \"Postal_Code\": \"47201-6258\",'+
'               \"Country\": \"USA\",'+
'               \"City\": \"Columbus\",'+
'               \"AddressLine2\": \"\",'+
'               \"AddressLine1\": \"500 Jackson St\"'+
'           },'+
'           \"Division_Code\": \"CMI\",'+
'           \"Company_Code\": \"00\",'+
'           \"AdministrativeOrigin\": {'+
'               \"State\": \"IN\",'+
'               \"Postal_Code\": \"47201-6258\",'+
'               \"Country\": \"USA\",'+
'               \"City\": \"Columbus\",'+
'               \"AddressLine2\": \"\",'+
'               \"AddressLine1\": \"500 Jackson St\"'+
'           }'+
'       },'+
'       \"ProductList\": [{'+
'           \"UnitOfMeasure\": \"\",'+
'           \"RC\": \"207\",'+
'           \"Quantity\": \"4\",'+
'           \"ProductCode\": \"5678901-OHT\",'+
'           \"ProductClassCode\": \"SW-Web Access\",'+
'           \"LineItemNumber\": \"00001140\",'+
'           \"ExtendedPrice\": \"470.40\",'+
'           \"DiscountPercentage\": \"\",'+
'           \"DiscountAmount\": \"\",'+
'           \"CustomerName\": \"USA Truck Inc\",'+
'           \"BC\": \"598\"'+
'       }],'+
'       \"DiscountPercent\": \"\",'+
'       \"DiscountAmount\": \"\",'+
'       \"Customer\": {'+
'           \"Destination_Addesss\": {'+
'               \"State\": \"IN\",'+
'               \"Postal_Code\": \"47201\",'+
'               \"Country\": \"United States\",'+
'               \"City\": \"Indiana\",'+
'               \"AddressLine2\": \"Ashbrook Dr\",'+
'               \"AddressLine1\": \"3701\"'+
'           },'+
'           \"Customer_Code\": \"409280\",'+
'           \"Administrive_Destination\": {'+
'               \"Postal_Code\": \"47201\",'+
'               \"Country\": \"United States\",'+
'               \"City\": \"Indiana\",'+
'               \"Administrative_Main_Division\": \"IN\",'+
'               \"AddressLine2\": \"Ashbrook Dr\",'+
'               \"AddressLine1\": \"3701\"'+
'           }'+
'       }'+
'   }'+
'}';
dbu_VertexQuoteRequestWrapper r = dbu_VertexQuoteRequestWrapper.parse(json);
System.assert(r != null);*/
    }
}
//UAT Deployment