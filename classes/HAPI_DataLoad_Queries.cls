/***
* Class containing queries commonly used for the HAPI Data Load
* 
* @author : Juhi Krishnamurthy
* @created date : November 07, 2018 
* 
*/

public class HAPI_DataLoad_Queries 
{
    public static List<HAPI_Product_Load__c> getHapiProductLoads(String version)
    {
        return [SELECT Version__c, Start_Date__c, Spec_Operation__c, Spec_List__c, 
                Related_Products_Operation__c, Related_Products_List__c, Quantityperunit__c,
                Product_SKU__c, Product_Name__c, Message__c, Error_Message__c, End_Date__c, 
                Data_Partially_Uploaded__c, Data_Fully_Uploaded__c, Composite_Products_Operation__c,
                Composite_Products_List__c, Category_Operation__c, Category_List__c, 
                Product_Data_Operation__c, Product_Media_Operation__c, Product_Media_List__c, 
                Featured_Products_Operation__c, Featured_Products_List__c, 
                Group_Name__c, Lead_Time__c, Long_Desc__c, Long_Desc_RT__c, Package__c, 
                Product_Class_Code__c, Product_Status__c, Product_Type__c, Product_Weight__c, 
                Short_Desc__c, Short_Desc_RT__c, Storefront__c, Unit_of_Measure__c, 
                Product_Reference_Name__c, Product_Version__c, Stand_Alone_Product__c, License_Name__c,
                isIAMProvisioningRequired__c,Product_Range__c, QSOLType__c,Version_Display__c,
                FIN_BUSINESS_CODE__c, FIN_RESP_CODE__c, FIN_SUB_BUSINESS_CODE__c
                FROM HAPI_Product_Load__c 
                WHERE Data_Fully_Uploaded__c=false 
                AND Data_Partially_Uploaded__c=false 
                AND Version__c=:version ORDER BY Composite_Products_Operation__c,Related_Products_Operation__c ASC];
        
    } 
    
    public static List<HAPI_Price_Load__c> getHapiPriceLoads(String version)
    {
        return [SELECT Account_Group_Name__c, Currency__c, Data_Fully_Uploaded__c, Data_Partially_Uploaded__c, 
                Error_Message__c, Message__c, Price__c, Distributor_Price__c, PriceList_Name__c, Price_Selection_Method__c, 
                Product_SKU__c, Version__c, Subscription_Product__c, Subscription_Length__c, Billing_Frequency__c  
                FROM HAPI_Price_Load__c 
                WHERE Data_Fully_Uploaded__c=false 
                AND Data_Partially_Uploaded__c=false 
                AND Version__c=:version];
    }
    
    public static List<ccrz__E_Product__c> getProducts()
    {
        return [Select ID, Name, ccrz__SKU__c, ccrz__Quantityperunit__c, ccrz__StartDate__c, ccrz__EndDate__c, 
                Group_Name__c, ccrz__LeadTime__c, ccrz__LongDesc__c, ccrz__LongDescRT__c, Package__c, Stand_Alone_Product__c, 
                Product_Class_Code__c, ccrz__ProductStatus__c, ccrz__ProductType__c, ccrz__ProductWeight__c, 
                ccrz__ShortDesc__c, ccrz__ShortDescRT__c, ccrz__Storefront__c, ccrz__UnitOfMeasure__c, 
                Product_Reference_Name__c, Product_Version__c, LicenseName__c, Product_Range__c,
                QSOLType__c,isIAMProvisioningRequired__c,Version_Display__c,
                FIN_BUSINESS_CODE__c, FIN_RESP_CODE__c, FIN_SUB_BUSINESS_CODE__c  
                from ccrz__E_Product__c where ccrz__Storefront__c ='SoftwareStore' ORDER BY ccrz__SKU__c ASC];
    }
    
    public static List<ccrz__E_ProductMedia__c> getAllExistingProductMedia()
    {
        return [Select ID, ccrz__MediaType__c, ccrz__ProductMediaSource__c, 
                ccrz__Product__c, ccrz__Locale__c, ccrz__Enabled__c,ccrz__Product__r.ccrz__Storefront__c 
                from ccrz__E_ProductMedia__c where ccrz__Product__r.ccrz__Storefront__c ='SoftwareStore'];
    }
    
    public static List<ccrz__E_CompositeProduct__c> getAllExistingCompositeProducts()
    {
        return [Select ID, ccrz__Composite__c, ccrz__Component__c, Unit__c, ccrz__Quantity__c 
                from ccrz__E_CompositeProduct__c];
    }
    
    public static List<ccrz__E_RelatedProduct__c> getAllExistingRelatedProducts()
    {
        return [Select ID, ccrz__Product__c, ccrz__RelatedProduct__c, ccrz__Enabled__c, ccrz__RelatedProductType__c,ccrz__Product__r.ccrz__Storefront__c  
                from ccrz__E_RelatedProduct__c where ccrz__Product__r.ccrz__Storefront__c ='SoftwareStore'];
    }
    
    public static List<ccrz__E_Spec__c> getSpecs()
    {
        return [Select ID, Name, ccrz__Desc__c, ccrz__DisplayName__c, ccrz__SpecGroup__c, 
                ccrz__IsVisibleInCatalog__c, ccrz__Sequence__c 
                from ccrz__E_Spec__c];
    }
    
    public static List<ccrz__E_ProductSpec__c> getAllExistingProductSpecs()
    {
        return [Select ID, ccrz__Product__c, ccrz__Spec__c,ccrz__Product__r.ccrz__Storefront__c 
                from ccrz__E_ProductSpec__c where ccrz__Product__r.ccrz__Storefront__c ='SoftwareStore'];
    }
    
    public static List<ccrz__E_AccountGroup__c> getAllExistingAccountGroups()
    {
        return [Select ID, Name from ccrz__E_AccountGroup__c];
    }
    
    public static List<ccrz__E_PriceList__c> getAllExistingPriceLists()
    {
        return [Select ID, Name, ccrz__Storefront__c, ccrz__CurrencyISOCode__c from ccrz__E_PriceList__c];
    } 
    
    public static List<ccrz__E_AccountGroupPriceList__c> getAllExistingAccountGroupPriceListJunctions()
    {
        return [SELECT ID, ccrz__AccountGroup__c, ccrz__Pricelist__c, ccrz__Enable__c, ccrz__StartDate__c, ccrz__EndDate__c 
                FROM ccrz__E_AccountGroupPriceList__c];
    }
    
    public static List<ccrz__E_PriceListItem__c> getAllExistingPriceListItems()
    {
        return [SELECT ID, ccrz__Price__c, ccrz__RecurringPrice__c,   
                ccrz__Product__c, ccrz__Pricelist__c, ccrz__SubProdTerm__c, ccrz__SubProdTerm__r.HAPI_SubProdTerm_Name__c,Distributor_Price__c  
                FROM ccrz__E_PriceListItem__c where ccrz__Pricelist__r.ccrz__Storefront__c ='SoftwareStore'];
    }
    
    public static List<ccrz__E_Category__c> getCategories()
    {
        return [Select ID, Name, ccrz__CategoryID__c, ccrz__LongDesc__c  
                from ccrz__E_Category__c];
    }
    
    public static List<ccrz__E_ProductCategory__c> getAllExistingProductCategories()
    {
        return [Select ID, ccrz__Category__c, ccrz__Product__c,ccrz__Product__r.ccrz__Storefront__c 
                from ccrz__E_ProductCategory__c where ccrz__Product__r.ccrz__Storefront__c ='SoftwareStore'];
    }
    
    public static List<ccrz__E_FeaturedProduct__c> getAllExistingFeaturedProducts()
    {
        return [SELECT ID, Name, ccrz__Enabled__c, ccrz__Product__c, ccrz__Type__c 
                FROM ccrz__E_FeaturedProduct__c];
    }
    
    public static List<ccrz__E_SubProdTerm__c> getAllExistingSubProdTerms()
    {
         return [Select ID, ccrz__CCProduct__c, ccrz__DisplayName__c, HAPI_SubProdTerm_Name__c, Billing_Display_Name__c, PriceListID__c 
                from ccrz__E_SubProdTerm__c];
    }
    
    public static List<ccrz__E_Menu__c> getAllExistingMenus()
    {
        return [Select ID, ccrz__DisplayName__c, ccrz__StoreID__c, ccrz__Enabled__c, ccrz__LinkType__c, ccrz__Category__c  
                from ccrz__E_Menu__c];
    }
    
    public static List<ccrz__E_MenuItem__c> getAllExistingMenuItems()
    {
        return [Select ID, ccrz__Category__c, ccrz__LinkType__c, ccrz__Menu__c, ccrz__DisplayName__c 
                from ccrz__E_MenuItem__c];
    }
    
}