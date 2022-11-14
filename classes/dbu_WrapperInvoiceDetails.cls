public class dbu_WrapperInvoiceDetails {
    /************ Added by Harish to identify the order is accesible for user*************/
    @AuraEnabled public boolean isOrderAccesible {get;set;}
    
    @AuraEnabled public String orderId {get;set;}
    @AuraEnabled public String orderCurrency{get;set;}
    @AuraEnabled public date dateinfo {get;set;}
     @AuraEnabled public String dateinfoReturn {get;set;}
    @AuraEnabled public string paymentType {get;set;}
    @AuraEnabled public string name {get;set;}
    @AuraEnabled public string lastName {get;set;}
    @AuraEnabled public string emailID {get;set;}
    @AuraEnabled public string phone {get;set;}
    @AuraEnabled public string orderNumber {get;set;}
    @AuraEnabled public Date orderDate {get;set;}
    @AuraEnabled public Decimal totalAmount {get;set;}
    @AuraEnabled public Decimal subTotalAmount {get;set;}
    @AuraEnabled public String subTotalAmountReturn {get;set;}
    @AuraEnabled public Decimal discountAmount {get;set;}
   //  @AuraEnabled public String discountAmountReturn;
    @AuraEnabled public Decimal estimatedTax {get;set;}
    @AuraEnabled public Decimal shippingCost {get;set;}
    @AuraEnabled public Boolean isPickUpAddress {get;set;}
    @AuraEnabled public Boolean isShipToAddress {get;set;}
    @AuraEnabled public ShipToAddress shipAddress {get;set;}
    @AuraEnabled public BillToAddress billAddress {get;set;}
  //   @AuraEnabled public StorePickupAddress storeAddress {get;set;}
    @AuraEnabled public List<InvoiceDetailsData> invoiceDetails {get;set;}
    @AuraEnabled public List<InvoiceLines> invoiceLineItems {get;set;}
     @AuraEnabled public String productCost {get;set;}
    @AuraEnabled public String handlingFeesReturn {get;set;}
    @AuraEnabled public String totalRefund {get;set;}
 //   @AuraEnabled public Map<String,Decimal> taxMap;
 //   @AuraEnabled public Map<String,Map<String,Decimal>> taxAgainstCloneOrderName;
    @AuraEnabled public list<TaxSummery> currentOrderTaxSummary {get; set;}
    
    public class InvoiceDetailsData {
        @AuraEnabled public Date invoiceDate {get;set;}
        @AuraEnabled public string invoiceNumber {get;set;}
        @AuraEnabled public date dateinfo {get;set;}
        @AuraEnabled public List<InvoiceLines> invoiceLineItem {get;set;}
       // @AuraEnabled public List<Invoices> listinvoice;
    }
    public class InvoiceLines {
        @AuraEnabled public String lineItemName {get;set;}
        @AuraEnabled public Integer quantity {get;set;}
        @AuraEnabled public Double taxAmount {get;set;}
        @AuraEnabled public Double price {get;set;}
        @AuraEnabled public Boolean returnableOrNot {get;set;}
        @AuraEnabled public string productName {get;set;}
        @AuraEnabled public string proImage {get;set;}
        @AuraEnabled public Double unitPrice{get;set;}
        @AuraEnabled public Double unitDiscountedPrice {get;set;}
        @AuraEnabled public String reasonOfReturn {get;set;}
        @AuraEnabled public Boolean returnedOrNot {get;set;}
        @AuraEnabled public Double refundAmount {get;set;}
        @AuraEnabled public Boolean hasCoreCharge {get;set;}
        @AuraEnabled public Boolean hasCoreChild {get;set;}
        @AuraEnabled public Integer daysSinceOrderDate {get;set;}
        @AuraEnabled public Double originalQty {get;set;}
        @AuraEnabled public String cloneOrderId {get;set;}
        @AuraEnabled public String invoiceLineItemDate {get;set;}
         @AuraEnabled public String Id {get;set;}
        @AuraEnabled public String taxAmountReturn {get;set;}
         @AuraEnabled public String priceReturn{get;set;}
         @AuraEnabled public String unitPriceReturn{get;set;}
        @AuraEnabled public String unitDiscountedPriceReturn{get;set;}
        @AuraEnabled public String refundAmountReturn{get;set;}
        @AuraEnabled public Boolean isHandlingFee = false;
         @AuraEnabled public Boolean coreCharge = false;
        @AuraEnabled public Boolean coreChargeHandlingFee = false;
        @AuraEnabled public Boolean isShipTo = false; //Added by Mukesh --27-Sep for Inventory Change=====

        // @AuraEnabled public Boolean isHandlingFee = false;
         
    }
    public class Invoices {
        @AuraEnabled public String invoice {get;set;}
    }
    public class ShipToAddress{
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String address1{get;set;}
        @AuraEnabled public String address2{get;set;}
        @AuraEnabled public String address3{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String country{get;set;}
        @AuraEnabled public String postalCode{get;set;}
    }
    public class BillToAddress{
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String address1{get;set;}
        @AuraEnabled public String address2{get;set;}
        @AuraEnabled public String address3{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String country{get;set;}
        @AuraEnabled public String postalCode{get;set;}
    }
    
  /*  public class StorePickupAddress{
        @AuraEnabled public String firstName{get;set;}
        @AuraEnabled public String lastName{get;set;}
        @AuraEnabled public String address1{get;set;}
        @AuraEnabled public String address2{get;set;}
        @AuraEnabled public String address3{get;set;}
        @AuraEnabled public String city{get;set;}
        @AuraEnabled public String state{get;set;}
        @AuraEnabled public String country{get;set;}
        @AuraEnabled public String postalCode{get;set;}
    }*/
    
}