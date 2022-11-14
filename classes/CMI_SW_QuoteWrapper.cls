public class CMI_SW_QuoteWrapper {

    public Id id{get;set;}
    public String wishlistName {get;set;}
    public String storefront {get;set;}
    public List<QuoteItemWrapper> quoteItems{get;set;}
    
    
    public class QuoteItemWrapper
    {
        public String sfId{get;set;}
        public String description{get;set;}
      public String quoteStatus {get;set;}
        public String Status {get;set;}
      public Decimal listPrice {get;set;}
      public Decimal discountedPrice {get;set;}
      public Decimal discountedTotalPrice {get;set;}
        public Decimal totalPrice {get;set;}
    //quantity is number of subscriptions
        public Integer quantity{get;set;} 
    public String productId{get;set;} 
    public String productType{get;set;}
        public String productPackage{get;set;}
        public String displayProductName{get;set;}
        public String currencySymbol{get;set;}
        public Boolean isActionVisible{get;set;}
        public Boolean hasDiscount{get;set;}
        public String billingFreq{get;set;}
        public String expiredDate{get;set;}
        
        
        public CMI_SW_ProductDetailWrapper productDetail {get;set;}
        public CMI_SW_ProductDetailWrapper.MediaWrapper mediaWrapper {get;set;}
        
        
  }
    
}