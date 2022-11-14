public class CMI_SW_WishlistWrapper {

    public Id id{get;set;}
    public String wishlistName {get;set;}
    public String storefront {get;set;}
    public List<WishlistItemWrapper> wishlistItems{get;set;}
    
    
    public class WishlistItemWrapper
    {
        public String sfId{get;set;}
		public String sfdcName{get;set;}
    	public String wishlistName {get;set;}
		public String wishlistId {get;set;}
    	public Decimal price {get;set;}
        public Decimal totalPrice {get;set;}
        public String billingFrequency {get;set;}
		//quantity is number of subscriptions
        public Integer quantity{get;set;} 
		public String productId{get;set;} 
		public String productType{get;set;}
        public String productPackage{get;set;}
        public String displayProductName{get;set;}
        
        public CMI_SW_ProductDetailWrapper productDetail {get;set;}
        public CMI_SW_ProductDetailWrapper.MediaWrapper mediaWrapper {get;set;}
        
        
	}
    
}