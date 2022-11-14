public class GOMS_IP_Wrapper{
    
    public Header Header {get; set;}
    public DataArea DataArea {get; set;}
    
    public class Header{
        public Target Target {get; set;}
        public Sender Sender {get; set;}
    }
    
    public class Target {
        public String TargetID {get; set;}
    }
    
    public class Sender {
        public string ServiceName {get; set;}
        public string SenderID {get; set;}
    }
    
    public class DataArea {
        public InvoiceHeaders invoiceHeaders {get; set;}
        public List<InvoiceLines>  invoiceLines {get; set;}
    }
    
    public class InvoiceHeaders {
        public string transactionID {get; set;}
        public string shipToAbbreviation {get; set;}
        public string invoiceCode {get; set;}
        public string createdBy {get; set;}
        public string updatedBy {get; set;}
        public string createDate {get; set;}
        public string recordDate {get; set;}
        public List<InvoiceHeaderNotes> invoiceHeaderNotes {get; set;}
    }
    
    public class InvoiceLines {
        public string transactionID {get; set;}
        public string shipToAbbreviation {get; set;}
        public Integer transactionLineNumber {get; set;}
        public string partNumber {get; set;}
        public Integer invoiceQuantity {get; set;}
        public Decimal unitPrice {get; set;}
        public string lineDescription {get; set;}
        public string financeBusinessCode {get; set;}
        public string financeResponseCode {get; set;}
        public string financeSubBusinessCode {get; set;}
        public string createdBy {get; set;}
        public string updatedBy {get; set;}
        public string createDate {get; set;}
        public string recordDate {get; set;}
        public List<InvoiceLineNotes> invoiceLineNotes  {get; set;}
    }
    
    public class InvoiceHeaderNotes {
        public string transactionID {get; set;}
        public string shipToAbbreviation {get; set;}
        public Integer transactionLineNumber {get; set;}
        public Integer noteNumber {get; set;}
        public string noteText {get; set;}
        public string createdBu {get; set;}
        public string updatedBy {get; set;}
        public string createDate {get; set;}
        public string recordDate {get; set;}
    }
    
    //Added for Mar-920
    public class InvoiceLineNotes {
        public Integer noteNumber {get; set;}
        public string noteText {get; set;}
        public string transactionID {get; set;}
        public string shipToAbbreviation {get; set;}
        public Integer transactionLineNumber {get; set;}
        /*public string createdBy {get; set;}
        public string updatedBy {get; set;}
        public string createDate {get; set;}
        public string recordDate {get; set;}*/
    }
    
}