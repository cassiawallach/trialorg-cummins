public class InvoiceItemWrpr
    {
        
        public String productName{get;set;}
        public String invoiceItemNumber{get;set;}
        public Integer quantity{get;set;}
        public Decimal tax{get;set;}
        public String isReturnable{get;set;}
        public Decimal unitPrice{get;set;}
        public Decimal discPrice{get;set;}
        public Decimal price{get;set;}
        public String proImage{get;set;}
        public Decimal refundAmount {get;set;}
        public String returnDate{get;set;}
        public Boolean isShipTo{get;set;} // Inventory Changes 
    }