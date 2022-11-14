public class OSM_VERTEX_WS_GeneralizedInputWrapper{

     public DataArea DataArea {get;set;} 
     public boolean isForQuote{get;set;}
     public String recordId{get;set;}
     public String QuotationRequestDocumentNumber{get;set;}
     public String InvoiceRequestDocumentNumber{get;set;}
     public boolean isRefundInvoiceReq{get;set;}
     public String orderPlacementDate{get;set;}

    public class Physical_Origin {
        public String AddressLine1 {get;set;} 
        public String AddressLine2 {get;set;} 
        public String City {get;set;} 
        public String State {get;set;} 
        public String Postal_Code {get;set;} 
        public String Country {get;set;} 
    }
    
    public class ProductList {
        public String LineItemNumber {get;set;} 
        public String ProductCode {get;set;} 
        //public String ProductName {get;set;} 
        public String ProductClassCode {get;set;} 
        public String Quantity {get;set;} 
        public String UnitOfMeasure {get;set;} 
        public String ExtendedPrice {get;set;} 
        //public String DiscountType {get;set;} 
        public String DiscountPercentage {get;set;} 
        public String DiscountAmount {get;set;} 
        public String UserDefinedDiscountCode {get;set;}       //Mar-1434
        public String CustomerName {get;set;} 
        public String BC {get;set;} 
        public String RC {get;set;} 
    }
    
    
    public class DataArea {
        public Seller Seller {get;set;} 
        public Customer Customer {get;set;} 
        public String DiscountAmount{get;set;}
        public List<ProductList> ProductList {get;set;} 
        public String divisionCode {get;set;} //MAR-1947
        public String SPFRC{get;set;} //MAR-1947
        public String SPFBC{get;set;} //MAR-1947
    }
    
    public class Customer {
        public String Customer_Code {get;set;} 
        public Physical_Origin Destination_Addesss {get;set;} 
        public Administrive_Destination Administrive_Destination {get;set;} 
    }
    
    public class Seller {
        public String Company_Code {get;set;} 
        public String Division_Code {get;set;} 
        public Physical_Origin Physical_Origin {get;set;} 
        public Physical_Origin AdministrativeOrigin {get;set;} 
    }
    
    public class Administrive_Destination {
        public String AddressLine1 {get;set;} 
        public String AddressLine2 {get;set;} 
        public String City {get;set;} 
        public String State {get;set;} 
        public String Postal_Code {get;set;} 
        public String Country {get;set;} 
    }
}