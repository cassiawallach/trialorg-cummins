public class OSM_VERTEX_WS_CalculateTaxReq   {
    
    public Header Header {get;set;} 
    public DataArea DataArea {get;set;} 

    
    public class Sender {
        public String ServiceName {get;set;} 
        public String SenderID {get;set;} 
    }
    
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
        public String ProductClassCode {get;set;} 
        public String Quantity {get;set;} 
        public String UnitOfMeasure {get;set;} 
        public String ExtendedPrice {get;set;} 
        public String DiscountPercentage {get;set;} 
        public String DiscountAmount{get;set;}
        public String UserDefinedDiscountCode {get;set;}         //Mar-1434
        public String CustomerName {get;set;} 
        public String BC {get;set;} 
        public String RC {get;set;} 
    }
    
    public class Target {
        public String TargetID {get;set;} 
    }
    
    public class DataArea {
        public Seller Seller {get;set;} 
        public String DiscountPercent{get;set;}
        public String DiscountAmount{get;set;}
        public Customer Customer {get;set;} 
        public List<ProductList> ProductList {get;set;} 
    }
    
    public class Header {
        public Sender Sender {get;set;} 
        public Target Target {get;set;} 
        public Transaction_Z Transaction_Z {get;set;} 
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
        public String Administrative_Main_Division {get;set;} 
        public String Postal_Code {get;set;} 
        public String Country {get;set;} 
    }
    
    public class Transaction_Z {
        public String TransactionID {get;set;} 
        public String Transaction_Type {get;set;} 
        public String Trusted_ID {get;set;} 
        public String QuotationRequestDocumentNumber {get;set;} 
        public String InvoiceRequestDocumentNumber {get;set;}
        public String DocumentDate {get;set;} 
    }
    
    
    public static OSM_VERTEX_WS_CalculateTaxReq parse(String json) {
        return (OSM_VERTEX_WS_CalculateTaxReq) System.JSON.deserialize(json, OSM_VERTEX_WS_CalculateTaxReq.class);
    }
    
}