public class CMI_SW_CartTaxWrapper {

    public Id cartId{get;set;}
    public Decimal vertexTax {get;set;}
    public boolean isError{get; set;}
    public String errorMsg {get; set;}
    public String totalDiscount {get; set;}
    public List<CartLineItem> cartIteams{get;set;}

    public class CartLineItem
    {
        public Id CartLineId{get;set;}
        public Id CartLineProductId{get;set;}
        public Decimal vertexTax{get;set;}
        public String billingFrequency{get;set;}
        public date requestedDate{get;set;} //swetha added for MP-430
        public date SubscriptionExpiryDate{get;set;} //swetha added for MP-430
        public boolean withCoTerm{get;set;} //swetha added for MP_430
        public String groupname{get;set;}//added groupname for mp_680 
        public Long renewStartDate{get;set;}
        public Long renewEndDate{get;set;}
        public boolean isRenew{get;set;}
        public String ProductLinkSKU{get;set;}
        public String couponCode{get;set;}
        public boolean hasCoupon{get;set;}
  }
    
}