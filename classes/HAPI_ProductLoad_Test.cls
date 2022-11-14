//Test Class for the class HAPI_DataLoad_Queries**
@isTest
public class HAPI_ProductLoad_Test 
{
	public static HAPI_Product_Load__c createTestHAPIProductLoad(String version, String productName, String productSKU, String productMediaList, 
                                                String featuredProductList, String compositeProductsList, String relatedProductsList, 
                                                String categoryList, String specList, Boolean doInsert)
    {
        HAPI_Product_Load__c hapiProductLoad = new HAPI_Product_Load__c();
        
        hapiProductLoad.Version__c = version;
        hapiProductLoad.Data_Fully_Uploaded__c = false;
        hapiProductLoad.Data_Partially_Uploaded__c = false;
        
        hapiProductLoad.Product_Data_Operation__c = true;
        hapiProductLoad.Product_Name__c = productName;
        hapiProductLoad.Product_SKU__c = productSKU;
        hapiProductLoad.Quantityperunit__c = 1.00;
        hapiProductLoad.Version_Display__c = 'Consumer';
        hapiProductLoad.FIN_BUSINESS_CODE__c = 'PI';
        hapiProductLoad.FIN_RESP_CODE__c = '207';
        hapiProductLoad.FIN_SUB_BUSINESS_CODE__c = 'QSETB';
        hapiProductLoad.Start_Date__c = System.today();
        hapiProductLoad.End_Date__c = System.today().addMonths(12);
        
        hapiProductLoad.Product_Media_List__c = productMediaList;
        if(null != productMediaList && !String.isEmpty(productMediaList))
        	hapiProductLoad.Product_Media_Operation__c = true;
        
        hapiProductLoad.Featured_Products_List__c = featuredProductList;
        if(null != featuredProductList && !String.isEmpty(featuredProductList))
        	hapiProductLoad.Featured_Products_Operation__c = true;
        
        hapiProductLoad.Composite_Products_List__c = compositeProductsList;
        if(null != compositeProductsList && !String.isEmpty(compositeProductsList))
        	hapiProductLoad.Composite_Products_Operation__c = true; 
        
        hapiProductLoad.Related_Products_List__c = relatedProductsList;
        if(null != relatedProductsList && !String.isEmpty(relatedProductsList))
            hapiProductLoad.Related_Products_Operation__c = true;
        
        hapiProductLoad.Category_List__c = categoryList;
        if(null != categoryList && !String.isEmpty(categoryList))
            hapiProductLoad.Category_Operation__c = true;
        
        hapiProductLoad.Spec_List__c = specList;
        if(null != specList && !String.isEmpty(specList))
            hapiProductLoad.Spec_Operation__c = true;
        
        if(doInsert)
       		insert hapiProductLoad;
        
        return hapiProductLoad;
    }
    
    static testMethod void insertProducts()
    {
        try
        {
            List<HAPI_Product_Load__c> hapiProductLoadList = new List<HAPI_Product_Load__c>(); 
            
            // insert Aggregate Product
            hapiProductLoadList.add(createTestHAPIProductLoad('t1.1', 'Test Product 1', 'Test-1', '[{Datasheets}#{Alternate Images}]', 
                                                              '[{Spotlight}]', null, '[{Test-1-1~Related}]', 
                                                              '[{Test Cat 1~Test Menu 1~None}#{Test Cat 2~Test Menu 2~Category}]', null, false));
            
            // insert Base Product
            hapiProductLoadList.add(createTestHAPIProductLoad('t1.1', 'Test Product Lite 1', 'Test-1-1', null,
                                                              null, '[{Test-1~15}]', null, 
                                                              null, '[{Test Spec 1~500}]', false));
            
            // Product Required Fields Missing
            hapiProductLoadList.add(createTestHAPIProductLoad('t1.1', null, 'Test-1-1', null,
                                                              null, '[{Test-1~15}]', null, 
                                                              null, '[{Test Spec 1~500}]', false));
            
            // Product SKU Missing
            hapiProductLoadList.add(createTestHAPIProductLoad('t1.1', 'Test Product Lite 1', null, null,
                                                              null, '[{Test-1~15}]', null, 
                                                              null, '[{Test Spec 1~500}]', false));
            insert hapiProductLoadList;
            
            HAPI_ProductLoader.loadProductData('t1.1'); 
            
            // Update Product data Section
            List<HAPI_Product_Load__c> hapiProductLoadList2 = new List<HAPI_Product_Load__c>();
            
            // update Aggregate Product
            hapiProductLoadList2.add(createTestHAPIProductLoad('t1.2', 'Test Product 1', 'Test-1', '[{Datasheets}#{Alternate Images}]', 
                                                              '[{Spotlight}#{Featured}]', null, null, 
                                                              '[{Test Cat 1~Test Menu 1~None}', null, false));
            
            // update Base Product
            hapiProductLoadList2.add(createTestHAPIProductLoad('t1.2', 'Test Product Lite 1', 'Test-1-1', null,
                                                              null, '[{Test-1~10}]', null, 
                                                              null, '[{Test Spec 2~500}]', false));
            
            insert hapiProductLoadList2;
            
            HAPI_ProductLoader.loadProductData('t1.2'); 
            
            // Incorrect values Section
            List<HAPI_Product_Load__c> hapiProductLoadList3 = new List<HAPI_Product_Load__c>();
            
            // insert Aggregate Product
            hapiProductLoadList3.add(createTestHAPIProductLoad('t1.3', 'Test Product 1', 'Test-1', '[{Datasheets}{Alternate Images}]', 
                                                              '[{Spotlight}', null, '[{Test-1-1Related}]', 
                                                              '[{Test Cat 1~Test Menu 1}#{Test Cat 2~Test Menu 2~Category}]', null, false));
            
            // insert Base Product
            hapiProductLoadList3.add(createTestHAPIProductLoad('t1.3', 'Test Product Lite 1', 'Test-1-1', '[{Datashee}#{Alternate Images}]',
                                                              '[{Spotlig}]', '[{Test-115}]', '[{Test-1~Relat}]', 
                                                              null, '[{Test Spec 1~abc500}]', false));
            
            insert hapiProductLoadList3;
            
            HAPI_ProductLoader.loadProductData('t1.3'); 
        }
        catch(Exception e)
        {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
}