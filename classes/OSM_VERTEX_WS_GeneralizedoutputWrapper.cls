global class OSM_VERTEX_WS_GeneralizedoutputWrapper
{
    public String errorMsg;
    public Boolean errorFlag;
    public OSM_Integration_Log__c log;
    
    public DataArea DataArea {get;set;} 
    public Header Header {get;set;} 
    
    public class ProductList {
        public String Product {get;set;} 
        public String ProductCode{get;set;}
        public Double LineItemTotalTax {get;set;} 
        public String ProductClassCode {get;set;} 
        public Integer LineItemNumber {get;set;} 
        public List<Taxes> Taxes {get;set;} 

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

    }
    
    public class Transaction_Z {
        public String TransactionID {get;set;} 

    }
}