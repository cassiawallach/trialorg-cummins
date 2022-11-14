/*
* Wrapper Class used for the HAPI Product Data Load
* 
* @author : Juhi Krishnamurthy
* @created date : November 07, 2018 
* 
*/

public class HAPI_ProductLoad_Wrapper 
{
	public String errorMessage;
	public String message;
    
    public String relatedProductStatus;
    public List<ccrz__E_RelatedProduct__c> relatedProductList;
    
    public String compositeProductStatus;
    public List<ccrz__E_CompositeProduct__c> compositeProductList;
    public List<ccrz__E_CompositeProduct__c> toBeDeletedcompositeProductList;
    
    public String productSpecStatus;
    public List<ccrz__E_ProductSpec__c> productSpecList;
    public List<ccrz__E_ProductSpec__c> toBeDeletedProductSpecList;
    
    public String productCategoryStatus;
    public List<ccrz__E_ProductCategory__c> productCategoryList;
    public List<ccrz__E_ProductCategory__c> toBeDeletedProductCategoryList;
    
    public String productMediaStatus;
    public List<ccrz__E_ProductMedia__c> productMediaList;
    
    public String featuredProductStatus;
    public List<ccrz__E_FeaturedProduct__c> featuredProductsList;
    
    public HAPI_ProductLoad_Wrapper()
    {
        
    }
}