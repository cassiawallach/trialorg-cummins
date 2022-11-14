global class PdfGeneratorController{
  public ccrz__E_Invoice__c invoice{get;set;} 
   

 public String Name {get;set;}
 public String invoiceDate {get;set;}
 public String accName {get;set;}
 public String invoiceType {get;set;}
 public Decimal amount {get;set;}
 public String status {get;set;}
 public String traid {get;set;}
 List<InvoiceLineItemDetail> lstLineItems{get;set;}
 public Decimal subtotal {get;set;}
 public Decimal totalTax {get;set;}
 public Decimal grandTotal {get;set;}
 public DateTime paymentDateTime {get;set;}
 public String paymentMethod {get;set;}
 public Decimal paymentAmount {get;set;}
 public String BillingAddress {get;set;}
 public Boolean showNumOfBundlesValue {get;set;} //LL55 3rd Aug 2022 @Vishnu NoB InvPDF
 //@Muthukumara-LL16-To show Credit card number/po number on invoice pdf -21-07-2022
 public String AccountNumber {get;set;}
 
 public PdfGeneratorController(ApexPages.StandardController controller) {
   this.invoice = (ccrz__E_Invoice__c)controller.getRecord();
   system.debug(this.invoice );
   ccrz__E_Invoice__c rec=[select id,BMS_PONumber__c,OSM_SW_IsIntercompanyInvoice__c,name,ccrz__BillAddress__r.ccrz__AddressFirstline__c,ccrz__BillAddress__r.ccrz__City__c,ccrz__BillAddress__r.ccrz__State__c,ccrz__BillAddress__r.ccrz__PostalCode__c,ccrz__BillAddress__r.ccrz__Country__c,createddate,ccrz__BillTo__r.Name,Total_Sales_Amount__c,ccrz__Status__c,Total_Vertex_Tax__c,(select id,name,ccrz__CCOrderItem__c,ccrz__CCOrderItem__r.ccrz__Product_Name__c,ccrz__CCOrder__r.Name,Quantity__c,ccrz__CCOrderItem__r.Billing_Frequency__c,ccrz__CCOrderItem__r.ccrz__SubProdTerm__r.ccrz__DisplayName__c,ccrz__OriginalAmount__c,ccrz__CCOrderItem__r.Number_of_Bundles__c From ccrz__InvoiceItems__r where ccrz__Type__c='Item') from ccrz__E_Invoice__c where id=:invoice.id];
   ccrz__E_TransactionPayment__c tra=[select id,ccrz__AccountNumber__c,ccrz__Token__c,ccrz__TransactionTS__c,ccrz__Amount__c,ccrz__AccountType__c from ccrz__E_TransactionPayment__c where ccrz__InvoiceAppliedTo__c=:rec.id];
   
    Name=rec.Name;
    Integer year=rec.createddate.year();
    Integer Day= rec.createddate.Day();
    String monthName = rec.createddate.format('MMMMM');
    invoiceDate=Day+' '+monthName+' '+year;
    accName=rec.ccrz__BillTo__r.Name ;
    invoiceType='Invoice';
    amount=rec.Total_Sales_Amount__c;
    status=rec.ccrz__Status__c;
    subtotal=rec.Total_Sales_Amount__c;
    totalTax=rec.Total_Vertex_Tax__c;
    grandTotal=rec.Total_Vertex_Tax__c+rec.Total_Sales_Amount__c;
    paymentDateTime=tra.ccrz__TransactionTS__c;
    //@Chanchala LL-69  -Added If-else condition to set the value as N/A - 17/8/2022
    if(grandTotal == 0.00 && tra.ccrz__AccountType__c == 'cc'){
       traid = 'N/A';
       paymentMethod='N/A';
    }
    else{
        traid= tra.ccrz__Token__c;
        paymentMethod=tra.ccrz__AccountType__c;
     }//Changes End here for LL-69
    paymentAmount=tra.ccrz__Amount__c;
    //@Muthukumar-LL16-To show Credit card number/po number on invoice pdf -21-07-2022(Add this field to SOQL)
    //@Navas-LL16,56 and LL 57To BMS po number on intercompany invoice pdf -03-08-2022
    if(rec.BMS_PONumber__c != null && rec.BMS_PONumber__c !='' && rec.OSM_SW_IsIntercompanyInvoice__c == true){
        AccountNumber = rec.BMS_PONumber__c;
    }else{
        //@Chanchala LL-69  -Added If-else condition to set the value as N/A - 17/8/2022
            if(grandTotal == 0.00){
                 AccountNumber='N/A';
            }
            else{
                   AccountNumber = tra.ccrz__AccountNumber__c;
            }//Changes End here for LL-69
    }
    showNumOfBundlesValue = false; //LL55 3rd Aug 2022 @Vishnu NoB InvPDF 
    List<String> OSM_ShowNumberofBundlesChkValues = String.isBlank(label.OSM_ShowNumberofBundlesValue) ? new List<String>() : (List<String>) label.OSM_ShowNumberofBundlesValue.split(','); //LL55 3rd Aug 2022 @Vishnu NoB InvPDF

    lstLineItems=new List<InvoiceLineItemDetail>();
     if(rec.ccrz__InvoiceItems__r!=null)
     {
       for(ccrz__E_InvoiceItem__c invoiceItemListRecord:rec.ccrz__InvoiceItems__r)
       {
          InvoiceLineItemDetail lineItem = new InvoiceLineItemDetail();
          lineItem.productName=invoiceItemListRecord.ccrz__CCOrderItem__r.ccrz__Product_Name__c;
          lineItem.orderName=invoiceItemListRecord.ccrz__CCOrder__r.Name;
          lineItem.quantity=Integer.valueOf(invoiceItemListRecord.Quantity__c);
          lineItem.amount=invoiceItemListRecord.ccrz__OriginalAmount__c;
          lineItem.BillingFrequency=invoiceItemListRecord.ccrz__CCOrderItem__r.Billing_Frequency__c;
          lineItem.subLength=invoiceItemListRecord.ccrz__CCOrderItem__r.ccrz__SubProdTerm__r.ccrz__DisplayName__c;
          lineItem.NumberofBundles = invoiceItemListRecord.ccrz__CCOrderItem__r.Number_of_Bundles__c;//LL55 3rd Aug 2022 @Vishnu NoB InvPDF (Add this field to SOQL)
          if(!showNumOfBundlesValue) showNumOfBundlesValue = OSM_ShowNumberofBundlesChkValues.contains(lineItem.productName) ? true : false;//LL55 3rd Aug 2022 @Vishnu NoB InvPDF
          lstLineItems.add(lineItem);          
       }
     }
     BillingAddress=rec.ccrz__BillAddress__r.ccrz__AddressFirstline__c +' '+rec.ccrz__BillAddress__r.ccrz__City__c+','+rec.ccrz__BillAddress__r.ccrz__State__c+' '+rec.ccrz__BillAddress__r.ccrz__PostalCode__c+' '+rec.ccrz__BillAddress__r.ccrz__Country__c;
  }
  
  global Class InvoiceLineItemDetail{
    global string productName{ get; set; }
    global string orderName{ get; set; }
    global Integer quantity{ get; set; }
    global Decimal amount{ get; set; }
    public String BillingFrequency {get;set;}
    public String subLength{get;set;}
    global Decimal NumberofBundles{get;set;} //LL55 3rd Aug 2022 @Vishnu NoB InvPDF
  }
   global List<InvoiceLineItemDetail> getInvoiceItemList ()
   {
       return lstLineItems;
   }

}