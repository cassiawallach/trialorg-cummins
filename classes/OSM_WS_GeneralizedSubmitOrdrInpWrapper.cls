public class OSM_WS_GeneralizedSubmitOrdrInpWrapper {
    public Header header{get;set;}
    public DataArea dataArea{get;set;}
    
    public class Header{
        public Sender sender{get;set;}
        public Target target{get;set;}
    }
    
    public class Sender{
        public String serviceName{get;set;}
        public String senderId{get;set;}
        public String messageId {get; set;}
    }
    
    public class Target{
        public String targetId{get;set;}
    }
    
    public class DataArea {
        public String locationId {get; set;}
        public String customerCode {get; set;}
        public String sender {get; set;}
        public String orderReferenceNumber {get; set;}
        public String emailAddress {get; set;}
        public String phoneNumber {get; set;}
        
        public List<FSDList> headerList{get;set;}
        public List<TaxList> taxList{get;set;}
        public List<ChargeList> chargeList{get;set;}
        public List<PartList> partList{get;set;}
		public String AcctId{get; set;} //Added by Dhiraj			
    }
    
    public class FSDList {
        public String customerLocationCode {get; set;}
        public String vendor {get; set;}
        public String salesOrderId {get; set;}
        public String orderSourceType {get; set;}
        public String taxDistrict {get; set;}
        public String paymentType {get; set;}
        public String status {get; set;}
        public String invoiceNumber {get; set;}
        public Date invoiceDate {get; set;}
        public Double invoiceTotal {get; set;}
        public String billToCustomerNumber {get; set;}
        public String billToName {get; set;}
        public String shipToName {get; set;}
        public String shipToAddress1 {get; set;}
        public String shipToAddress2 {get; set;}
        public String shipToAddress3 {get; set;}
        public String shipToCountry {get; set;}
        public String shipToCity {get; set;}
        public String shipToState {get; set;}
        public String shipToPostalCode {get; set;}
        public String orderComments {get; set;}
        public String customerPONumber {get; set;}
        /*public Integer attribute01 {get; set;}
        public String attribute02 {get; set;}
        public String attribute03 {get; set;}*/
    }
    public class TaxList {
        public String taxAuthorities {get; set;}
        public String printGroup {get; set;}
        public String salesCategories {get; set;}
        public Decimal taxAmount {get; set;}
        public Decimal saleAmount {get; set;}
        /*public Integer attribute01 {get; set;}
        public String attribute02 {get; set;}
        public String attribute03 {get; set;}*/
    }
    public class ChargeList {
        public String discountType {get; set;}
        public Decimal totalDiscount {get; set;}
        /*public Integer attribute01 {get; set;}
        public String attribute02 {get; set;}*/
    }
    public class PartList {
        public String itemNumber {get; set;}
        public String product {get; set;}
        public String description {get; set;}
        public Integer quantity {get; set;}
        public String unitOfMeasurement {get; set;}
        public Decimal sellingPrice {get; set;}
        public Decimal itemCost {get; set;}
        public String nonstockType {get; set;}
        public String lineType {get; set;}
        public String customerPONumber {get; set;}
        /*public Integer attribute01 {get; set;}
        public String attribute02 {get; set;}
        public String attribute03 {get; set;}*/
    }
    
    public static OSM_WS_GeneralizedSubmitOrdrInpWrapper parse(String json) {
        return (OSM_WS_GeneralizedSubmitOrdrInpWrapper) System.JSON.deserialize(json, OSM_WS_GeneralizedSubmitOrdrInpWrapper.class);
    }
}