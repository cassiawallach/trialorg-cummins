global class OSM_VERTEX_WS_CalculateTaxRes {

    public DataArea DataArea {get;set;} 
    public Header Header {get;set;} 
    
    
    public class ProductList {
        public String Product {get;set;} 
        public String ProductCode{get;set;}
        public Double LineItemTotalTax {get;set;} 
        public String ProductClassCode {get;set;} 
        public Integer LineItemNumber {get;set;} 
        public List<Taxes> Taxes{get;set;}  

    }   
    public class Taxes{
        public String taxResult {get;set;} 
        public String taxType {get;set;} 
        public String reasonCode {get;set;} 
        public String isService {get;set;} 
        public String situs {get;set;} 
        public String taxCollectedFromParty {get;set;} 
        public String taxStructure {get;set;} 
        public String jurisdictionLevel {get;set;} 
        public String jurisdictionId {get;set;} 
        public String JurisdictionValue {get;set;} 
        public String CalculatedTax {get;set;} 
        public String EffectiveRate {get;set;} 
        public String Taxable {get;set;} 
        public String NonTaxable {get;set;} 
        public String impositionId {get;set;} 
        public String impositionValue {get;set;} 
        public String impositionTypeId {get;set;} 
        public String ImpositionTypevalue {get;set;} 
        public String TaxRuleId {get;set;}  
        }

    public class DataArea {
        public Double TotalTax {get;set;} 
        public List<ProductList> ProductList {get;set;}  
        
    }
    
    public class Header {
        public Transaction_Z Transaction_Z {get;set;} // in json: Transaction
        public Sender Sender{get;set;}
            
        public String Status {get; set;}
        public String ReturnCodeDescription {get; set;}
        public Target Target{get;set;}

    }
    
    public class Transaction_Z {
        public String TransactionID {get;set;} 
        public String QuotationResponseDocumentNumber {get;set;}
        public String InvoiceResponseDocumentNumber{get;set;}
        public String Transaction_Type{get;set;}
        public String DocumentDate{get;set;}

    }
    
    public class Sender
    {
        public String ServiceName{get;set;}
        public String SenderID{get; set;}
    }
    
    public class Target
    {
        public String TargetID{get;set;}
        
    }
    public static OSM_VERTEX_WS_CalculateTaxRes parse(String json) {
        return (OSM_VERTEX_WS_CalculateTaxRes) System.JSON.deserialize(json, OSM_VERTEX_WS_CalculateTaxRes.class);
    }
    
}