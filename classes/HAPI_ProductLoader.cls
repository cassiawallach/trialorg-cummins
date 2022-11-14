/*
* Class to take data from the HAPI Product Loads Custom Object and load it into Cloud Craze Objects with required relations
* 
* @author : Juhi Krishnamurthy
* @created date : November 07, 2018 
* 
*/

public class HAPI_ProductLoader 
{
    public static final String deltaSeparator = '~';
    
    public static void loadProductData(String version)
    {
        try
        {
            System.debug('START - HAPI_ProductLoader : loadProductData');
            
            List<HAPI_Product_Load__c> masterHapiProductLoadList = HAPI_DataLoad_Queries.getHapiProductLoads(version);
            
            system.debug('masterHapiProductLoadList-->'+masterHapiProductLoadList.size());
            // Lists to be upserted at the start------------------------------------------
            
            List<ccrz__E_Product__c> updatedProductList = new List<ccrz__E_Product__c>();
            Set<String>prodToUpdateId = new set<String>();
            
            List<ccrz__E_Spec__c> newSpecList = new List<ccrz__E_Spec__c>();
            List<ccrz__E_Category__c> newCategoryList = new List<ccrz__E_Category__c>();
            //----------------------------------------------------------------------------
            
            // Lists to be inserted/updated at the end------------------------------------------
            
            List<ccrz__E_ProductMedia__c> finalProductMediaList = new List<ccrz__E_ProductMedia__c>();
            
            List<ccrz__E_CompositeProduct__c> finalCompositeProductList = new List<ccrz__E_CompositeProduct__c>();
            List<ccrz__E_CompositeProduct__c> finalToBeDeletedCompositeProductList = new List<ccrz__E_CompositeProduct__c>();
            
            List<ccrz__E_RelatedProduct__c> finalRelatedProductList = new List<ccrz__E_RelatedProduct__c>();
            
            List<ccrz__E_ProductSpec__c> finalProductSpecList = new List<ccrz__E_ProductSpec__c>();
            List<ccrz__E_ProductSpec__c> finalToBeDeletedProductSpecList = new List<ccrz__E_ProductSpec__c>();
            
            List<ccrz__E_ProductCategory__c> finalProductCategoryList = new List<ccrz__E_ProductCategory__c>();
            List<ccrz__E_ProductCategory__c> finalToBeDeletedProductCategoryList = new List<ccrz__E_ProductCategory__c>();
            
            List<ccrz__E_FeaturedProduct__c> finalFeaturedProductsList = new List<ccrz__E_FeaturedProduct__c>();
            
            //----------------------------------------------------------------------------
            
            // Maps Set Up------------------------------------------
            
            // Product Map -> Product Sku : Product
            Map<String, ccrz__E_Product__c> productMap = new Map<String, ccrz__E_Product__c>();
            
            for(ccrz__E_Product__c product : HAPI_DataLoad_Queries.getProducts())
            {
                productMap.put(product.ccrz__SKU__c, product);
            }
            
            Map<String, ccrz__E_Spec__c> specMap = new Map<String, ccrz__E_Spec__c>();
            Map<ID, String> specIDMap = new Map<ID, String>();
            
            for(ccrz__E_Spec__c spec : HAPI_DataLoad_Queries.getSpecs())
            {
                specMap.put(spec.Name, spec);
            }
            
            Map<String, ccrz__E_Category__c> categoryMap = new Map<String, ccrz__E_Category__c>();
            Map<ID, String> categoryIDMap = new Map<ID, String>();
            
            for(ccrz__E_Category__c category : HAPI_DataLoad_Queries.getCategories())
            {
                categoryMap.put(category.Name, category);
            }
            
            //End of Maps Set Up--------------------------------------
            
			List<String> lisenceNamePickList = HAPI_DataLoad_CommonUtility.getValidPicklistValues(ccrz__E_Product__c.LicenseName__c);
			List<String> productRangePickList = HAPI_DataLoad_CommonUtility.getValidPicklistValues(ccrz__E_Product__c.Product_Range__c);
				
            for(HAPI_Product_Load__c hapiProductLoad : masterHapiProductLoadList)
            {
                hapiProductLoad.Error_Message__c = '';
                hapiProductLoad.Message__c = '';
                
                ccrz__E_Product__c product = null;
				boolean proceedWithProcess = true;
				
				if(null != hapiProductLoad.License_Name__c && !lisenceNamePickList.contains(hapiProductLoad.License_Name__c))
					{
						//product.LicenseName__c = hapiProductLoad.License_Name__c;
						hapiProductLoad.Error_Message__c = hapiProductLoad.License_Name__c+' is not valid Picklist value of LicenseName__c field of CC Product'; 
						proceedWithProcess = false;
					}
				if(null != hapiProductLoad.Product_Range__c && !productRangePickList.contains(hapiProductLoad.Product_Range__c))
					{
						hapiProductLoad.Error_Message__c = hapiProductLoad.Error_Message__c + ' /n '+hapiProductLoad.Product_Range__c+' is not valid Picklist value of Product_Range__c field of CC Product';
						
						proceedWithProcess = false;
					}
                
                if(null != hapiProductLoad.Product_SKU__c && !String.isEmpty(hapiProductLoad.Product_SKU__c)  && proceedWithProcess)
                {
                    // if sku is present....check if product already exists else product is null
                    product = productMap.get(hapiProductLoad.Product_SKU__c);
                    
                    // product does not exist
                    if(null == product)
                    {
                        if(checkRequiredFields(hapiProductLoad))
                        {
                            product = mapHapiLoadToProduct(new ccrz__E_Product__c(), hapiProductLoad);  
                        }
                    }
                    else // product already exists....choose whether to update the product data
                    {
                        if(hapiProductLoad.Product_Data_Operation__c)
                        {
                            product = mapHapiLoadToProduct(product, hapiProductLoad);
                        }
                    }
                    
                    if(null != product)
                    {
                        // add the product to UpdateProductList
                      if(!prodToUpdateId.Contains(product.ccrz__SKU__c)){
                            updatedProductList.add(product);
                            prodToUpdateId.add(product.ccrz__SKU__c);
                     }
                        
                        // create CC Spec for those that dont already exist
                        List<ccrz__E_Spec__c> hapiLoadSpecList = createSpecList(hapiProductLoad, specMap);
                        newSpecList.addAll(hapiLoadSpecList);
                        
                        if(null != hapiLoadSpecList && hapiLoadSpecList.size() > 0)
                        {
                            hapiProductLoad.Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoad.Message__c) 
                                + '\n Specs created : ';
                        }
                        
                        // so the same spec is not repeatedly created
                        for(ccrz__E_Spec__c spec : hapiLoadSpecList)
                        {
                            specMap.put(spec.Name, spec);
                            hapiProductLoad.Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoad.Message__c) 
                                + '{'+spec.Name + '}'; 
                        }
                        
                        // create CC Category for those that dont already exist
                        List<ccrz__E_Category__c> hapiLoadCategoryList = createCategoryList(hapiProductLoad, categoryMap);
                        newCategoryList.addAll(hapiLoadCategoryList);
                        
                        if(null != hapiLoadCategoryList && hapiLoadCategoryList.size() > 0)
                        {
                            hapiProductLoad.Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoad.Message__c) 
                                + '\n Categories created : ';
                        }
                        
                        for(ccrz__E_Category__c category : hapiLoadCategoryList)
                        {
                            categoryMap.put(category.Name, category);
                            hapiProductLoad.Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoad.Message__c) 
                                + '{'+category.Name + '}'; 
                        }
                    }
                    else
                    {
                        hapiProductLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoad.Error_Message__c) 
                            + '\n Required Fields for Product Incorrect/Missing';
                    }
                }
                else
                {
                    hapiProductLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoad.Error_Message__c) 
                        + '\n Product SKU can not be NULL/EMPTY';
                } 
            }
            
            // upsert products and hapiProductLoads
            Upsert updatedProductList;
            
            system.debug('updatedProductList-->'+updatedProductList.size());
            update masterHapiProductLoadList;
            
            insert newSpecList;
            insert newCategoryList;
            
            // creates the menu items for the categories
            // DML operations occur
            createMenuItemsAndUpdateCategories();
            
            // Get Existing Data from Objects
            List<ccrz__E_ProductMedia__c> existingProductMediaList = HAPI_DataLoad_Queries.getAllExistingProductMedia();
            List<ccrz__E_CompositeProduct__c> existingCompositeProductsList = HAPI_DataLoad_Queries.getAllExistingCompositeProducts();
            List<ccrz__E_RelatedProduct__c> existingRelatedProductsList = HAPI_DataLoad_Queries.getAllExistingRelatedProducts();
      List<ccrz__E_ProductSpec__c> existingProductSpecsList = HAPI_DataLoad_Queries.getAllExistingProductSpecs();  
            List<ccrz__E_ProductCategory__c> existingProductCategoriesList = HAPI_DataLoad_Queries.getAllExistingProductCategories();
            List<ccrz__E_FeaturedProduct__c> existingFeaturedProductsList = HAPI_DataLoad_Queries.getAllExistingFeaturedProducts();
            
            // Update the Maps----------------------------------------------------
            
            // get the map of product SKU to Product ID and vice versa
            Map<String,ID> productSKUMap = new Map<String,ID>();
            Map<ID, String> productIDMap = new Map<ID, String>();

            // Product Maps
            for(ccrz__E_Product__c product : HAPI_DataLoad_Queries.getProducts())
            {
                productSKUMap.put(product.ccrz__SKU__c, product.ID);
                productIDMap.put(product.ID, product.ccrz__SKU__c);
                productMap.put(product.ccrz__SKU__c, product);
            }
            
            // Update Spec Maps
            for(ccrz__E_Spec__c spec : HAPI_DataLoad_Queries.getSpecs())
            {
                specMap.put(spec.Name, spec);
                specIDMap.put(spec.ID, spec.Name);
            }
            
            // Update Category Maps
            for(ccrz__E_Category__c category : HAPI_DataLoad_Queries.getCategories())
            {
                categoryMap.put(category.Name, category);
                categoryIDMap.put(category.ID, category.Name);
            }
            
            //------------------------------------------------------------------------
            
            List<HAPI_ProductLoad_Wrapper> hapiProductLoadWrapperList = new List<HAPI_ProductLoad_Wrapper>();
            
            for(HAPI_Product_Load__c hapiProductLoad : masterHapiProductLoadList)
            {
              // make sure this HapiProductLoad's SKU exists in Salesforce
              if(null != hapiProductLoad.Product_SKU__c && !String.isEmpty(hapiProductLoad.Product_SKU__c) 
                   && null != productSKUMap.get(hapiProductLoad.Product_SKU__c))
                {
                  HAPI_ProductLoad_Wrapper hapiProductLoadWrapper = new HAPI_ProductLoad_Wrapper();
                  
                  // CC Product Media
                  hapiProductLoadWrapper = createProductMediaList(hapiProductLoadWrapper, hapiProductLoad, productSKUMap, existingProductMediaList);
                  
                  // for CC Composite Products
                    if(hapiProductLoad.Composite_Products_Operation__c)
                    {
                        hapiProductLoadWrapper = createCompositeProductsList(hapiProductLoadWrapper, hapiProductLoad, productIDMap, 
                                                                      productSKUMap, existingCompositeProductsList);
                    }
                  
                  // for CC Related Products
                    if(hapiProductLoad.Related_Products_Operation__c)
                    {
                        hapiProductLoadWrapper = createRelatedProductsList(hapiProductLoadWrapper, hapiProductLoad, productIDMap, 
                                                                    productSKUMap, existingRelatedProductsList);
                    }
                  
                  // for CC Spec and CC Product Spec
                    if(hapiProductLoad.Spec_Operation__c)
                    {   
                        hapiProductLoadWrapper = createProductSpecsList(hapiProductLoadWrapper, hapiProductLoad, productSKUMap, 
                                                                 specIDMap, specMap, existingProductSpecsList);
                    }
                  
                  // for CC Category and CC Product Category
                    if(hapiProductLoad.Category_Operation__c)
                    {
                        hapiProductLoadWrapper = createProductCategoriesList(hapiProductLoadWrapper, hapiProductLoad, productSKUMap, 
                                                                      categoryIDMap, categoryMap, existingProductCategoriesList);
                    }
                    
                    // for Featured Products - creates only of 
                    if(hapiProductLoad.Featured_Products_Operation__c)
                    {
                         hapiProductLoadWrapper = createFeaturedProductsList(hapiProductLoadWrapper, hapiProductLoad, 
                                                                             productSKUMap, productMap, existingFeaturedProductsList);
                    }
                  
                    hapiProductLoadWrapperList.add(hapiProductLoadWrapper);   
                    
                    hapiProductLoad.Error_Message__c = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoad.Error_Message__c) 
                        + HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage);        
                }
              // else CC Product not created for this SKU...mostly coz reqd fields not present
              
              // if no error message....all went good...it was loaded properly
                if(null == hapiProductLoad.Error_Message__c || String.isEmpty(hapiProductLoad.Error_Message__c))
                {
                    hapiProductLoad.Data_Fully_Uploaded__c = true;
                }
                else
                {
                    hapiProductLoad.Data_Partially_Uploaded__c = true;
                }
            }
            
            // once we have all the hapiProductLoadWrappers....enter in all the final Lists
            for(HAPI_ProductLoad_Wrapper hapiProductLoadWrapper : hapiProductLoadWrapperList)
            {
              if(HAPI_DataLoad_CommonUtility.SUCCESS == hapiProductLoadWrapper.productMediaStatus)
                {
                    finalProductMediaList.addAll(hapiProductLoadWrapper.productMediaList);
                }
                if(HAPI_DataLoad_CommonUtility.SUCCESS == hapiProductLoadWrapper.compositeProductStatus)
                {
                    finalCompositeProductList.addAll(hapiProductLoadWrapper.compositeProductList);
                    finalToBeDeletedCompositeProductList.addAll(hapiProductLoadWrapper.toBeDeletedcompositeProductList);
                }
                if(HAPI_DataLoad_CommonUtility.SUCCESS == hapiProductLoadWrapper.relatedProductStatus)
                {
                    finalRelatedProductList.addAll(hapiProductLoadWrapper.relatedProductList);
                }
                if(HAPI_DataLoad_CommonUtility.SUCCESS == hapiProductLoadWrapper.productSpecStatus)
                {
                    finalProductSpecList.addAll(hapiProductLoadWrapper.productSpecList);
                    finalToBeDeletedProductSpecList.addAll(hapiProductLoadWrapper.toBeDeletedProductSpecList);
                }
                if(HAPI_DataLoad_CommonUtility.SUCCESS == hapiProductLoadWrapper.productCategoryStatus)
                {
                    finalProductCategoryList.addAll(hapiProductLoadWrapper.productCategoryList);
                    finalToBeDeletedProductCategoryList.addAll(hapiProductLoadWrapper.toBeDeletedProductCategoryList);
                }
                if(HAPI_DataLoad_CommonUtility.SUCCESS == hapiProductLoadWrapper.featuredProductStatus)
                {
                    finalFeaturedProductsList.addAll(hapiProductLoadWrapper.featuredProductsList);
                }
            }
            
            upsert masterHapiProductLoadList;
            
            upsert finalProductMediaList;
            
            upsert finalCompositeProductList;
            delete finalToBeDeletedCompositeProductList;
            
            upsert finalRelatedProductList;
            
            upsert finalProductSpecList;
            delete finalToBeDeletedProductSpecList;
            
            upsert finalProductCategoryList;
            delete finalToBeDeletedProductCategoryList;
            
            upsert finalFeaturedProductsList;
            
            System.debug('END - HAPI_ProductLoader : loadProductData');
        }
        catch(Exception e)
        {
            // Any exception occuring in the load
             String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();

            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
    
            log.Error_Description__c = errorMsg;
    
            log.Service_Name__c = 'HAPI Product Load';
    
            log.Status__c = 'Failed';
    
            insert log;
            System.debug('EXCEPTION : Ocurred when loading Product Data');
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    } 
    
    //-------------------------------------------
    
    // creation of relation for CC Product Media
    public static HAPI_ProductLoad_Wrapper createProductMediaList(HAPI_ProductLoad_Wrapper hapiProductLoadWrapper, 
                                                                  HAPI_Product_Load__c hapiProductLoad, Map<String,ID> productSKUMap, 
                                                                  List<ccrz__E_ProductMedia__c> existingProductMediaList)
    {
        hapiProductLoadWrapper.productMediaStatus = HAPI_DataLoad_CommonUtility.SUCCESS;
        hapiProductLoadWrapper.productMediaList = new List<ccrz__E_ProductMedia__c>();
        
        Map<String, Boolean> requiredProductMedia = new Map<String, Boolean>();
        requiredProductMedia.put('Product Search Image',false);
        requiredProductMedia.put('Product Image',false);
        requiredProductMedia.put('Product Image Thumbnail',false);
        
        // get remaining from the user
        if(hapiProductLoad.Product_Media_Operation__c)
        {
          List<String> userProductMediaList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Product_Media_List__c);
          
          if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(userProductMediaList))
          {
            for(String userProductMedia : userProductMediaList)
            {
                    if(HAPI_DataLoad_CommonUtility.getValidPicklistValues(ccrz__E_ProductMedia__c.ccrz__MediaType__c).contains(userProductMedia))
                    {
                        requiredProductMedia.put(userProductMedia,false);
                    }
                    else
                    {
                        hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                            + '\n ' + userProductMedia + ' is not a valid picklist value';
                    }
            }
          }
          else
          {
            hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                    + '\n Error in Format of CC Product Media';
          }
        }
        
        List<ccrz__E_ProductMedia__c> productSpecificProductMediaList = new List<ccrz__E_ProductMedia__c>();
        
        for(ccrz__E_ProductMedia__c productMedia : existingProductMediaList)
        {
            if(productSKUMap.get(hapiProductLoad.Product_SKU__c) == productMedia.ccrz__Product__c && null != productMedia.ccrz__MediaType__c)
            {
                requiredProductMedia.put(productMedia.ccrz__MediaType__c, true);
            }
        }
        
        for(String mediaType : requiredProductMedia.keySet())
        {  
            if(!requiredProductMedia.get(mediaType))
            {
                ccrz__E_ProductMedia__c productMedia = new ccrz__E_ProductMedia__c();
                productMedia.ccrz__Product__c = productSKUMap.get(hapiProductLoad.Product_SKU__c);
                productMedia.ccrz__MediaType__c = mediaType;
                productMedia.ccrz__Enabled__c = true;
                productMedia.ccrz__Locale__c = 'en_US';
                productMedia.ccrz__ProductMediaSource__c = 'Attachment';
                productMedia.ccrz__EndDate__c = HAPI_DataLoad_CommonUtility.getEndDate();
                productMedia.ccrz__StartDate__c = HAPI_DataLoad_CommonUtility.getStartDate();
                
                hapiProductLoadWrapper.productMediaList.add(productMedia);
            }
            // else product media of media type key already exists
        }
        
        return hapiProductLoadWrapper;
    }
    
    // creation of relation for CC Composite Products
    public static HAPI_ProductLoad_Wrapper createCompositeProductsList(HAPI_ProductLoad_Wrapper hapiProductLoadWrapper, 
                                                                  HAPI_Product_Load__c hapiProductLoad,  
                                                                  Map<ID, String> productIDMap, Map<String,ID> productSKUMap, 
                                                                  List<ccrz__E_CompositeProduct__c> existingCompositeProductsList)
    {
        hapiProductLoadWrapper.compositeProductStatus = HAPI_DataLoad_CommonUtility.SUCCESS;
        hapiProductLoadWrapper.compositeProductList = new List<ccrz__E_CompositeProduct__c>();
        hapiProductLoadWrapper.toBeDeletedcompositeProductList = new List<ccrz__E_CompositeProduct__c>();
        
        Map<String, String> compositeProductDetailsMap = new Map<String, String>();
        
        List<ccrz__E_CompositeProduct__c> productSpecificCompositeProductList = new List<ccrz__E_CompositeProduct__c>();
        for(ccrz__E_CompositeProduct__c compositeProduct : existingCompositeProductsList)
        {
            if(productSKUMap.get(hapiProductLoad.Product_SKU__c) == compositeProduct.ccrz__Composite__c)
                productSpecificCompositeProductList.add(compositeProduct);
        }
        
        if(null != hapiProductLoad.Composite_Products_List__c && !String.isEmpty(hapiProductLoad.Composite_Products_List__c))
        {
            List<String> compositeProductDetailsList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Composite_Products_List__c);
            
            // check format
            if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(compositeProductDetailsList))
            {
              List<String> compositeProductSKUList = new List<String>();
              
              for(String compositeProductDetails : compositeProductDetailsList)
              {
                List<String> compositeProductDataList = compositeProductDetails.split(deltaSeparator);
                
                if(2 == compositeProductDataList.size() || 3 == compositeProductDataList.size())
                {
                  compositeProductSKUList.add(compositeProductDataList.get(0));
                  compositeProductDetailsMap.put(compositeProductDataList.get(0), compositeProductDetails);
                }
                else
                {
                  // incorrect data format within a block
                  hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                      + '\n Error in Format of Composite Products Details Block : ' + compositeProductDataList;
                }
              }
              
                List<String> productSpecificExisitingCompositeProductsSKUList = new List<String>();
                
                // check if business user input the composite product...if not...add to delete list
                for(ccrz__E_CompositeProduct__c compositeProduct : productSpecificCompositeProductList)
                {
                    productSpecificExisitingCompositeProductsSKUList.add(productIDMap.get(compositeProduct.ccrz__Component__c));
                    
                    // if the input string does not contains this Composite products sku...then delete
                    if(! compositeProductSKUList.contains(productIDMap.get(compositeProduct.ccrz__Component__c)))
                    {
                        // exists...but shudnt anymore...so add to delete list
                        hapiProductLoadWrapper.toBeDeletedcompositeProductList.add(compositeProduct);
                    }
                    else // already exists update the data (for example quantity)
                    {
                      compositeProduct.ccrz__Quantity__c = Decimal.valueOf(compositeProductDetailsMap.get(productIDMap.get(compositeProduct.ccrz__Component__c)).split(deltaSeparator).get(1));
                      // LATER : check picklist value
                      if(3 == compositeProductDetailsMap.get(productIDMap.get(compositeProduct.ccrz__Component__c)).split(deltaSeparator).size())
                        {
                            compositeProduct.Unit__c = compositeProductDetailsMap.get(productIDMap.get(compositeProduct.ccrz__Component__c)).split(deltaSeparator).get(2);
                        }
                        
                        hapiProductLoadWrapper.compositeProductList.add(compositeProduct);
                    }
                }
                
                for(String compositeProductSKU : compositeProductSKUList)
                {
                    // this relation was never created...create it now
                    if(!productSpecificExisitingCompositeProductsSKUList.contains(compositeProductSKU))
                    {
                        // if the composite product exists in product table...then start creating the composite
                        if(null != productSKUMap.get(compositeProductSKU))
                        {
                            ccrz__E_CompositeProduct__c compositeProduct = new ccrz__E_CompositeProduct__c();
                            compositeProduct.ccrz__Composite__c = productSKUMap.get(hapiProductLoad.Product_SKU__c);
                            compositeProduct.ccrz__Component__c = productSKUMap.get(compositeProductSKU);
                            compositeProduct.ccrz__Quantity__c = Decimal.valueOf(compositeProductDetailsMap.get(compositeProductSKU).split(deltaSeparator).get(1));
                            
                            if(3 == compositeProductDetailsMap.get(compositeProductSKU).split(deltaSeparator).size())
                            {
                               compositeProduct.Unit__c = compositeProductDetailsMap.get(compositeProductSKU).split(deltaSeparator).get(2);   
                            }
                        
                            hapiProductLoadWrapper.compositeProductList.add(compositeProduct);
                        }
                        else
                        {
                            // Composite Product SKU number given is incorrect
                            // Remaining will be added to list and inserted
                            hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) + '\n There exists no CC Product for given Composite Product SKU : ' + compositeProductSKU;
                        }
                    }
                }
            }
            else
            {
                // Error in Format of Composite Product SKU List....Dont do anything
                hapiProductLoadWrapper.compositeProductStatus = HAPI_DataLoad_CommonUtility.FAILURE;
                hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                + '\n Error in Format of CC Composite Product Details List';
            }
        }
        else
        {
            // no Composite Product SKU List.... add all to delete list
            hapiProductLoadWrapper.toBeDeletedcompositeProductList.addAll(productSpecificCompositeProductList);
        }
        
        return hapiProductLoadWrapper;
    }
    
    // creation of relation for CC Related Products
    public static HAPI_ProductLoad_Wrapper createRelatedProductsList(HAPI_ProductLoad_Wrapper hapiProductLoadWrapper, HAPI_Product_Load__c hapiProductLoad, 
                                                                Map<ID, String> productIDMap, Map<String,ID> productSKUMap, 
                                                                List<ccrz__E_RelatedProduct__c> existingRelatedProductsList)
    {
        hapiProductLoadWrapper.relatedProductStatus = HAPI_DataLoad_CommonUtility.SUCCESS;
        hapiProductLoadWrapper.relatedProductList = new List<ccrz__E_RelatedProduct__c>();
        
        List<ccrz__E_RelatedProduct__c> productSpecificRelatedProductList = new List<ccrz__E_RelatedProduct__c>();
        
        Map<String, String> relatedProductDetailsMap = new Map<String, String>();
        
        for(ccrz__E_RelatedProduct__c relatedProduct : existingRelatedProductsList)
        {
            if(productSKUMap.get(hapiProductLoad.Product_SKU__c) == relatedProduct.ccrz__Product__c)
                productSpecificRelatedProductList.add(relatedProduct);
        }
        
        if(null != hapiProductLoad.Related_Products_List__c && !String.isEmpty(hapiProductLoad.Related_Products_List__c))
        {
            List<String> relatedProductDetailsList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Related_Products_List__c);
            
            if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(relatedProductDetailsList))
            {
              List<String> relatedProductSKUList = new List<String>();
              
              for(String relatedProductDetails : relatedProductDetailsList)
              {
                List<String> relatedProductDataList = relatedProductDetails.split(deltaSeparator);
                
                if(2 == relatedProductDataList.size())
                {
                        if(HAPI_DataLoad_CommonUtility.getValidPicklistValues(ccrz__E_RelatedProduct__c.ccrz__RelatedProductType__c)
                           .contains(relatedProductDataList.get(1)))
                        {
                            relatedProductSKUList.add(relatedProductDataList.get(0));
                    relatedProductDetailsMap.put(relatedProductDataList.get(0), relatedProductDetails);
                        }
                  else
                        {
                            // incorrect data format within a block
                            hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                                + '\n ' + relatedProductDataList.get(1) + ' is not a valid picklist value';
                        }
                    }
                else
                {
                  // incorrect data format within a block
                  hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                      + '\n Error in Format of Related Products Details Block : ' + relatedProductDataList;
                }
              }
            
                List<String> productSpecificExisitingRelatedProductsSKUList = new List<String>();
                
                // check if business user input the related product...if not...disable
                for(ccrz__E_RelatedProduct__c relatedProduct : productSpecificRelatedProductList)
                {
                    productSpecificExisitingRelatedProductsSKUList.add(productIDMap.get(relatedProduct.ccrz__RelatedProduct__c));
                    
                    // if the input string contains this Related products sku...then update the data
                    if(relatedProductSKUList.contains(productIDMap.get(relatedProduct.ccrz__RelatedProduct__c)))
                    {
                      relatedProduct.ccrz__Enabled__c = true;
                        relatedProduct.ccrz__RelatedProductType__c = relatedProductDetailsMap.get(productIDMap.get(relatedProduct.ccrz__RelatedProduct__c)).split(deltaSeparator).get(1);
                    }
                    else
                    {
                        relatedProduct.ccrz__Enabled__c = false;
                    }
                    
                    hapiProductLoadWrapper.relatedProductList.add(relatedProduct);
                }
                
                for(String relatedProductSKU : relatedProductSKUList)
                {
                    // this relation was never created...create it now
                    if(!productSpecificExisitingRelatedProductsSKUList.contains(relatedProductSKU))
                    {
                        // if the related product exists in product table
                        if(null != productSKUMap.get(relatedProductSKU))
                        {
                            ccrz__E_RelatedProduct__c relatedProduct = new ccrz__E_RelatedProduct__c();
                            relatedProduct.ccrz__Product__c = productSKUMap.get(hapiProductLoad.Product_SKU__c);
                            relatedProduct.ccrz__RelatedProduct__c = productSKUMap.get(relatedProductSKU);
                            relatedProduct.ccrz__RelatedProductType__c = relatedProductDetailsMap.get(relatedProductSKU).split(deltaSeparator).get(1);
                            relatedProduct.ccrz__Enabled__c = true;
                            
                            hapiProductLoadWrapper.relatedProductList.add(relatedProduct);
                        }
                        else
                        {
                            // Related Product SKU number given is incorrect
                            // Remaining will be added to list and inserted
                            hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                                + '\n There exists no CC Product for given Related Product SKU : ' + relatedProductSKU;
                        }
                    }
                }
            }
            else
            {
                // Error in Format of Related Product SKU List....Dont do anything
                hapiProductLoadWrapper.relatedProductStatus = HAPI_DataLoad_CommonUtility.FAILURE;
                hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                    + '\n Error in Format of CC Related Product List';
            }
        }
        else
        {
            // no Related Product SKU List.... disable all
            for(ccrz__E_RelatedProduct__c relatedProduct : productSpecificRelatedProductList)
            {
                relatedProduct.ccrz__Enabled__c = false;
                hapiProductLoadWrapper.relatedProductList.add(relatedProduct);
            }
        }
        
        return hapiProductLoadWrapper;
    }
    
    // creation of CC Spec
    public static List<ccrz__E_Spec__c> createSpecList(HAPI_Product_Load__c hapiProductLoad, Map<String, ccrz__E_Spec__c> specMap)
    {
        List<ccrz__E_Spec__c> newSpecList = new List<ccrz__E_Spec__c>();
        
        // create CC Spec for those that dont already exist
        if(hapiProductLoad.Spec_Operation__c)
        {
            if(null != hapiProductLoad.Spec_List__c  && !String.isEmpty(hapiProductLoad.Spec_List__c))
            {
                List<String> specDataList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Spec_List__c);
                
                // check format
                if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(specDataList))
                {
                    for(String specData : specDataList)
                    {
                        List<String> dataList = specData.split(deltaSeparator);
                        
                        if(2 == dataList.size())
                        {
                            String specName = dataList.get(0);
                            String specSequence = dataList.get(1);
                            // this spec does not exist....create a spec with this name
                            // we need this...coz ID needs to exist to create product spec later
                            if(null == specMap.get(specName))
                            {
                                ccrz__E_Spec__c spec = new ccrz__E_Spec__c();
                                spec.Name = specName;
                                spec.ccrz__Desc__c = specName;
                                spec.ccrz__DisplayName__c = specName;
                                spec.ccrz__SpecGroup__c = 'General';
                                spec.ccrz__IsVisibleInCatalog__c = true;
                                
                                try
                                {
                                    spec.ccrz__Sequence__c = Integer.valueOf(specSequence);
                                }
                                catch(Exception e)
                                {
                                    System.debug('Sequence must be an Integer');
                                }

                                newSpecList.add(spec);
                            }
                            // spec exists...no need to create
                        }
                        else
                        {
                            System.debug('\n Error in format of Spec data : ' + specData);
                        }
                    }
                }
            }
            // else - taken care of later....in the product spec relation creation
        }
        
        return newSpecList;
    }
    
    // creation of relation for CC Product Spec
    public static HAPI_ProductLoad_Wrapper createProductSpecsList(HAPI_ProductLoad_Wrapper hapiProductLoadWrapper, HAPI_Product_Load__c hapiProductLoad, 
                                                             Map<String,ID> productSKUMap, Map<ID, String> specIDMap, 
                                                             Map<String, ccrz__E_Spec__c> specMap, List<ccrz__E_ProductSpec__c> existingProductSpecsList)
    {
        hapiProductLoadWrapper.productSpecStatus = HAPI_DataLoad_CommonUtility.SUCCESS;
        hapiProductLoadWrapper.productSpecList = new List<ccrz__E_ProductSpec__c>();
        hapiProductLoadWrapper.toBeDeletedProductSpecList = new List<ccrz__E_ProductSpec__c>();
        
        List<ccrz__E_ProductSpec__c> productSpecificProductSpecList = new List<ccrz__E_ProductSpec__c>();
        
        for(ccrz__E_ProductSpec__c productSpec : existingProductSpecsList)
        {
            if(productSKUMap.get(hapiProductLoad.Product_SKU__c) == productSpec.ccrz__Product__c)
                productSpecificProductSpecList.add(productSpec);
        }
        
        if(null != hapiProductLoad.Spec_List__c  && !String.isEmpty(hapiProductLoad.Spec_List__c))
        {
            List<String> specDataList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Spec_List__c);
            
            // check format
            if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(specDataList))
            {
                List<String> productSpecificExisitingProductSpecList = new List<String>();
                
                // check if business user input the Spec Name...if not...add to delete list
                for(ccrz__E_ProductSpec__c productSpec : productSpecificProductSpecList)
                {
                    productSpecificExisitingProductSpecList.add(specIDMap.get(productSpec.ccrz__Spec__c));
                    
                    // if the input string does not contains this Spec...then delete
                    if(! specDataList.contains(specIDMap.get(productSpec.ccrz__Spec__c)))
                    {
                        // exists...but shudnt anymore...so add to delete list
                        hapiProductLoadWrapper.toBeDeletedProductSpecList.add(productSpec);
                    }
                    // else - already exists...dont do anything
                }
                
                for(String specData : specDataList)
                {
                    List<String> dataList = specData.split(deltaSeparator);
                    
                    if(2 == dataList.size())
                    {
                        String specName = dataList.get(0);
                        
                        // this relation was never created...create it now
                        if(!productSpecificExisitingProductSpecList.contains(specName))
                        {
                            // if the CC Spec exists...then start creating the CC Product Spec
                            if(null != specMap.get(specName))
                            {
                                ccrz__E_ProductSpec__c productSpec = new ccrz__E_ProductSpec__c();
                                productSpec.ccrz__Product__c = productSKUMap.get(hapiProductLoad.Product_SKU__c);
                                productSpec.ccrz__Spec__c = specMap.get(specName).ID;
                                
                                hapiProductLoadWrapper.productSpecList.add(productSpec);
                            }
                            else
                            {
                                // Spec Name given is incorrect...it was not created for unknown reason previously
                                // Remaining will be added to list and inserted
                                hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                                    + '\n There exists no CC Spec with Name : ' + specName;
                            }
                        }
                    }
                    else
                    {
                        // format of this particular pricing data is incorrect
                        // this block is ignored....go on to next
                        hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                            + '\n Error in format of spec data : ' + specData;
                        
                    }
                }
            }
            else
            {
                // Error in Format of CC Spec List....Dont do anything
                hapiProductLoadWrapper.productSpecStatus = HAPI_DataLoad_CommonUtility.FAILURE;
                hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                    + '\n Error in Format of CC Spec List Here';
            }
        }
        else
        {
            // delete all
            hapiProductLoadWrapper.toBeDeletedProductSpecList.addAll(productSpecificProductSpecList);
        }
        
        return hapiProductLoadWrapper;
    }
    
    // creation of CC Category
    public static List<ccrz__E_Category__c> createCategoryList(HAPI_Product_Load__c hapiProductLoad, 
                                                               Map<String, ccrz__E_Category__c> categoryMap)
    {
        List<ccrz__E_Category__c> newCategoryList = new List<ccrz__E_Category__c>();
        
        // create CC Category for those that dont already exist
        if(hapiProductLoad.Category_Operation__c)
        {
            if(null != hapiProductLoad.Category_List__c && !String.isEmpty(hapiProductLoad.Category_List__c))
            {
                List<String> categoryList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Category_List__c);
                
                // check format
                if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(categoryList))
                {
                    for(String categoryData : categoryList)
                    {
                        List<String> dataList = categoryData.split(deltaSeparator);
                        
                        if(3 == dataList.size())
                        {
                            String categoryName = dataList.get(0);
                            String categoryMenuName = dataList.get(1);
                            String categoryMenuType = dataList.get(2);
                            
                            // this category does not exist....create a category with this name
                            // we need this...coz ID needs to exist to create product category later
                            // here unique is name
                            if(null == categoryMap.get(categoryName))
                            {
                                ccrz__E_Category__c category = new ccrz__E_Category__c();
                                category.Name = categoryName;
                                category.ccrz__CategoryID__c = 'ID-' + categoryName;
                                category.ccrz__EndDate__c = HAPI_DataLoad_CommonUtility.getEndDate();
                                category.ccrz__StartDate__c = HAPI_DataLoad_CommonUtility.getStartDate();
                                category.ccrz__LongDesc__c = categoryMenuName + '-' + categoryMenuType;
                                newCategoryList.add(category);
                            }
                            // category exists...no need to create
                        }
                    }
                }                
            }
            // else - taken care of later....in the product category relation creation
        }
        
        return newCategoryList;
    }
    
    public static HAPI_ProductLoad_Wrapper createProductCategoriesList(HAPI_ProductLoad_Wrapper hapiProductLoadWrapper, 
                                                                  HAPI_Product_Load__c hapiProductLoad, 
                                                                  Map<String,ID> productSKUMap, 
                                                                  Map<ID, String> categoryIDMap, Map<String, ccrz__E_Category__c> categoryMap,  
                                                                  List<ccrz__E_ProductCategory__c> existingProductCategoriesList)
    {
        hapiProductLoadWrapper.productCategoryStatus = HAPI_DataLoad_CommonUtility.SUCCESS;
        hapiProductLoadWrapper.productCategoryList = new List<ccrz__E_ProductCategory__c>();
        hapiProductLoadWrapper.toBeDeletedProductCategoryList = new List<ccrz__E_ProductCategory__c>();
        
        List<ccrz__E_ProductCategory__c> productSpecificProductCategoryList = new List<ccrz__E_ProductCategory__c>();
        
        for(ccrz__E_ProductCategory__c productCategory : existingProductCategoriesList)
        {
            if(productSKUMap.get(hapiProductLoad.Product_SKU__c) == productCategory.ccrz__Product__c)
                productSpecificProductCategoryList.add(productCategory);
        }
        
        if(null != hapiProductLoad.Category_List__c && !String.isEmpty(hapiProductLoad.Category_List__c))
        {
            List<String> categoryList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Category_List__c);
            
            // check format
            if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(categoryList))
            {
                List<String> productSpecificExisitingProductCategoryList = new List<String>();
                
                // check if business user input the Category Name...if not...add to delete list
                for(ccrz__E_ProductCategory__c productCategory : productSpecificProductCategoryList)
                {
                    productSpecificExisitingProductCategoryList.add(categoryIDMap.get(productCategory.ccrz__Category__c));
                    
                    // if the input string does not contains this Category...then delete
                    if(! categoryList.contains(categoryIDMap.get(productCategory.ccrz__Category__c)))
                    {
                        // exists...but shudnt anymore...so add to delete list
                        hapiProductLoadWrapper.toBeDeletedProductCategoryList.add(productCategory);
                    }
                    // else - already exists...dont do anything
                }
                
                for(String categoryData : categoryList)
                {
                    List<String> dataList = categoryData.split(deltaSeparator);
                    
                    if(3 == dataList.size())
                    {
                        String categoryName = dataList.get(0);
                        // this relation was never created...create it now
                        if(!productSpecificExisitingProductCategoryList.contains(categoryName))
                        {
                            // if the CC Category exists...then start creating the CC Product Category
                            if(null != categoryMap.get(categoryName))
                            {
                                ccrz__E_ProductCategory__c productCategory = new ccrz__E_ProductCategory__c();
                                productCategory.ccrz__Product__c = productSKUMap.get(hapiProductLoad.Product_SKU__c);
                                productCategory.ccrz__Category__c = categoryMap.get(categoryName).ID;
                                
                                hapiProductLoadWrapper.productCategoryList.add(productCategory);
                            }
                            else
                            {
                                // Category Name + Group Name combo given is incorrect...it was not created for unknown reason previously
                                // Remaining will be added to list and inserted
                                hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                                    + '\n There exists no CC Category with Name : ' + categoryName;
                            }
                        }
                    }
                    else
                    {
                        // format of this particular pricing data is incorrect
                        // this block is ignored....go on to next
                        hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                            + '\n Error in format of category data : ' + categoryData;
                    }
                }
            }
            else
            {
                // Error in Format of CC Category List....Dont do anything
                hapiProductLoadWrapper.productCategoryStatus = HAPI_DataLoad_CommonUtility.FAILURE;
                hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                    + '\n Error in Format of CC Category List';
            }
        }
        else
        {
            // delete all
            hapiProductLoadWrapper.toBeDeletedProductCategoryList.addAll(productSpecificProductCategoryList);
        }
        
        return hapiProductLoadWrapper;
    }
    
    public static HAPI_ProductLoad_Wrapper createFeaturedProductsList(HAPI_ProductLoad_Wrapper hapiProductLoadWrapper, 
                                                                      HAPI_Product_Load__c hapiProductLoad, 
                                                                      Map<String,ID> productSKUMap, Map<String, ccrz__E_Product__c> productMap, 
                                                                      List<ccrz__E_FeaturedProduct__c> existingFeaturedProductsList)
    {
        hapiProductLoadWrapper.featuredProductStatus = HAPI_DataLoad_CommonUtility.SUCCESS;
        hapiProductLoadWrapper.featuredProductsList = new List<ccrz__E_FeaturedProduct__c>();
        
        List<ccrz__E_FeaturedProduct__c> productSpecificFeaturedProductsList = new List<ccrz__E_FeaturedProduct__c>();
        List<String> productSpecificFeaturedProductTypes = new List<String>();
        
        for(ccrz__E_FeaturedProduct__c featuredProduct : existingFeaturedProductsList)
        {
            if(productSKUMap.get(hapiProductLoad.Product_SKU__c) == featuredProduct.ccrz__Product__c)
            {
                productSpecificFeaturedProductsList.add(featuredProduct);
                productSpecificFeaturedProductTypes.add(featuredProduct.ccrz__Type__c);
            }
                
        }
        
        if(null != hapiProductLoad.Featured_Products_List__c && !String.isEmpty(hapiProductLoad.Featured_Products_List__c))
        {
            List<String> featuredProductsList = HAPI_DataLoad_CommonUtility.splitAndValidate_DetailsList(hapiProductLoad.Featured_Products_List__c);
            
            // check format
            if(HAPI_DataLoad_CommonUtility.notListIsEmptyOrNull(featuredProductsList))
            {
                for(String featuredProductType : featuredProductsList)
                {
                    // LATER : check the picklist value
                    if(!productSpecificFeaturedProductTypes.contains(featuredProductType))
                    {
                        if(HAPI_DataLoad_CommonUtility.getValidPicklistValues(ccrz__E_FeaturedProduct__c.ccrz__Type__c)
                           .contains(featuredProductType))
                        {
                            ccrz__E_FeaturedProduct__c featuredProduct = new ccrz__E_FeaturedProduct__c();
                            featuredProduct.Name = productMap.get(hapiProductLoad.Product_SKU__c).Name + ' ' + featuredProductType;
                            featuredProduct.ccrz__Product__c = productSKUMap.get(hapiProductLoad.Product_SKU__c);
                            featuredProduct.ccrz__Enabled__c = true;
                            featuredProduct.ccrz__Type__c = featuredProductType;
                            if(null != hapiProductLoad.Storefront__c)
                            {
                                featuredProduct.ccrz__Storefront__c = hapiProductLoad.Storefront__c;
                            }
                            else
                            {
                                featuredProduct.ccrz__Storefront__c = 'SoftwareStore';
                            }
                            
                            hapiProductLoadWrapper.featuredProductsList.add(featuredProduct);
                        }
                        else
                        {
                            hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                                + '\n ' + featuredProductType + ' is not a valid picklist value';
                        }
                    }
                    // else already exists - do not do anything
                }
            }
            else
            {
                // Error in Format of CC Category List....Dont do anything
                hapiProductLoadWrapper.featuredProductStatus = HAPI_DataLoad_CommonUtility.FAILURE;
                hapiProductLoadWrapper.errorMessage = HAPI_DataLoad_CommonUtility.getNonNullString(hapiProductLoadWrapper.errorMessage) 
                    + '\n Error in Format of CC Featured Products List';
            }
        }
        
        return hapiProductLoadWrapper;
    }
    
    public static void createMenuItemsAndUpdateCategories()
    {
        List<String> menuNamesAndType = new List<String>();
        
        // for all newly created Categories, we need to create the Menu Items based on Group Name
        List<ccrz__E_MenuItem__c> newMenuItemList = new List<ccrz__E_MenuItem__c>();
        
        Map<String,ID> menuNameMap = new Map<String,ID>();
        
        for(ccrz__E_Menu__c menu : HAPI_DataLoad_Queries.getAllExistingMenus())
        {
            menuNameMap.put(menu.ccrz__DisplayName__c, menu.ID);
            
            if(!menuNamesAndType.contains(menu.ccrz__DisplayName__c + '-' + menu.ccrz__LinkType__c))
            {
                menuNamesAndType.add(menu.ccrz__DisplayName__c + '-' + menu.ccrz__LinkType__c);
            }
        }
        
        List<ccrz__E_Menu__c> finalMenuList = new List<ccrz__E_Menu__c>();
        
        for(ccrz__E_Category__c category : HAPI_DataLoad_Queries.getCategories())
        {
            if(null != category.ccrz__LongDesc__c && !menuNamesAndType.contains(category.ccrz__LongDesc__c))
            {
                List<String> menuDataList = category.ccrz__LongDesc__c.split('-');
                String menuName;
                String menuLinkType;
                if(menuDataList.size() > 0){
                     menuName = menuDataList.get(0); 
                }
               if(menuDataList.size() > 1){
                 menuLinkType = menuDataList.get(1);
               }
                ccrz__E_Menu__c menu = new ccrz__E_Menu__c();
                menu.ccrz__DisplayName__c = menuName;
                menu.ccrz__LocationType__c = 'Header';
                menu.ccrz__PageLocation__c = 'All Pages';
                menu.ccrz__LinkType__c = menuLinkType;
                menu.ccrz__Enabled__c = true;
                menu.ccrz__StoreID__c = 'SoftwareStore';
                
                finalMenuList.add(menu);
                
                menuNamesAndType.add(category.ccrz__LongDesc__c);
                menuNameMap.put(menu.ccrz__DisplayName__c, menu.ID);
            }
        }
        
        insert finalMenuList;
        
        for(ccrz__E_Menu__c menu : HAPI_DataLoad_Queries.getAllExistingMenus())
        {
            menuNameMap.put(menu.ccrz__DisplayName__c, menu.ID);
        }
        
        Map<String, ccrz__E_MenuItem__c> menuItemMap = new Map<String, ccrz__E_MenuItem__c>();
        
        for(ccrz__E_MenuItem__c menuItem : HAPI_DataLoad_Queries.getAllExistingMenuItems())
        {
            menuItemMap.put(menuItem.ccrz__Menu__c+','+menuItem.ccrz__Category__c, menuItem);
        }
        
        List<ccrz__E_Category__c> existingCategoriesList = HAPI_DataLoad_Queries.getCategories();
        
        for(ccrz__E_Category__c category : existingCategoriesList)
        {
            if(null != category.ccrz__LongDesc__c)
            {
                List<String> menuDataList = category.ccrz__LongDesc__c.split('-');
                 String menuName;
                String menuLinkType;
                if(menuDataList.size() > 1){
                     menuName = menuDataList.get(0); 
                }
               if(menuDataList.size() > 2){
                 menuLinkType = menuDataList.get(1);
               }
                
                if('None' == menuLinkType && null == menuItemMap.get(menuNameMap.get(menuName)+','+category.ID))
                {
                    ccrz__E_MenuItem__c menuItem = new ccrz__E_MenuItem__c();
                    menuItem.ccrz__Category__c = category.ID;
                    menuItem.ccrz__LinkType__c = 'Category';
                    menuItem.ccrz__DisplayName__c = category.Name;
                    menuItem.ccrz__Menu__c = menuNameMap.get(menuName);
                    newMenuItemList.add(menuItem);
                } 
            }
            category.ccrz__LongDesc__c = '';
        }
        
        insert newMenuItemList;
        update existingCategoriesList;
    }
    
    // OPTIONAL CHANGES HERE
    // add any other fields that are in CC Product - as required by project
    public static Boolean checkRequiredFields(HAPI_Product_Load__c hapiProductLoad)
    {
        if(null != hapiProductLoad && null != hapiProductLoad.Product_SKU__c 
           && null != hapiProductLoad.Product_Name__c && null != hapiProductLoad.Quantityperunit__c 
           && null != hapiProductLoad.Start_Date__c && null != hapiProductLoad.End_Date__c)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    // OPTIONAL CHANGES HERE
    // add any other fields that are in CC Product - make sure to add into the query as well
    public static ccrz__E_Product__c mapHapiLoadToProduct(ccrz__E_Product__c product , HAPI_Product_Load__c hapiProductLoad)
    {
        if(null != hapiProductLoad.Product_Name__c)
        {
            product.Name = hapiProductLoad.Product_Name__c;
        }
        if(null != hapiProductLoad.Product_SKU__c)
        {
            product.ccrz__SKU__c = hapiProductLoad.Product_SKU__c;
        }
        if(null != hapiProductLoad.Quantityperunit__c)
        {
            product.ccrz__Quantityperunit__c = hapiProductLoad.Quantityperunit__c;
        }
        if(null != hapiProductLoad.Start_Date__c)
        {
            product.ccrz__StartDate__c = hapiProductLoad.Start_Date__c;
        }
        if(null != hapiProductLoad.End_Date__c)
        {
            product.ccrz__EndDate__c = hapiProductLoad.End_Date__c;
        } 
        if(null != hapiProductLoad.Group_Name__c)
        {
            product.Group_Name__c = hapiProductLoad.Group_Name__c;
        }
        if(null != hapiProductLoad.Lead_Time__c)
        {
            product.ccrz__LeadTime__c = hapiProductLoad.Lead_Time__c;
        }
        if(null != hapiProductLoad.Long_Desc__c)
        {
            product.ccrz__LongDesc__c = hapiProductLoad.Long_Desc__c;
        }
        if(null != hapiProductLoad.Long_Desc_RT__c)
        {
            product.ccrz__LongDescRT__c = hapiProductLoad.Long_Desc_RT__c;
        }
        if(null != hapiProductLoad.Package__c)
        {
            product.Package__c = hapiProductLoad.Package__c;
        }
        if(null != hapiProductLoad.Stand_Alone_Product__c)
        {
            product.Stand_Alone_Product__c = hapiProductLoad.Stand_Alone_Product__c;
        }
        if(null != hapiProductLoad.Product_Class_Code__c)
        {
            product.Product_Class_Code__c = hapiProductLoad.Product_Class_Code__c;
        }
        if(null != hapiProductLoad.Product_Status__c)
        {
            product.ccrz__ProductStatus__c = hapiProductLoad.Product_Status__c;
        }
        if(null != hapiProductLoad.Product_Type__c)
        {
            product.ccrz__ProductType__c = hapiProductLoad.Product_Type__c;
        }
        if(null != hapiProductLoad.Product_Weight__c)
        {
            product.ccrz__ProductWeight__c = hapiProductLoad.Product_Weight__c;
        }
        if(null != hapiProductLoad.Short_Desc__c)
        {
            product.ccrz__ShortDesc__c = hapiProductLoad.Short_Desc__c;
        }
        if(null != hapiProductLoad.Short_Desc_RT__c)
        {
            product.ccrz__ShortDescRT__c = hapiProductLoad.Short_Desc_RT__c;
        }
        if(null != hapiProductLoad.Storefront__c)
        {
            product.ccrz__Storefront__c = hapiProductLoad.Storefront__c;
        }
        if(null != hapiProductLoad.Unit_of_Measure__c)
        {
            product.ccrz__UnitOfMeasure__c = hapiProductLoad.Unit_of_Measure__c;
        }
        if(null != hapiProductLoad.Product_Reference_Name__c)
        {
            product.Product_Reference_Name__c = hapiProductLoad.Product_Reference_Name__c;
        }
        if(null != hapiProductLoad.Product_Version__c)
        {
            product.Product_Version__c = hapiProductLoad.Product_Version__c;
        }
        if(null != hapiProductLoad.License_Name__c)
        {
            product.LicenseName__c = hapiProductLoad.License_Name__c;
        }
    if(null != hapiProductLoad.Product_Range__c)
        {
            product.Product_Range__c = hapiProductLoad.Product_Range__c;
        }
    if(null != hapiProductLoad.QSOLType__c)
        {
            product.QSOLType__c = hapiProductLoad.QSOLType__c;
        }
    if(null != hapiProductLoad.isIAMProvisioningRequired__c)
        {
            product.isIAMProvisioningRequired__c = hapiProductLoad.isIAMProvisioningRequired__c;
        }
        //MAR-298
        if(null != hapiProductLoad.Version_Display__c)
        {
            product.Version_Display__c = hapiProductLoad.Version_Display__c;
        }
        //MAR-35 - START
        if(null != hapiProductLoad.FIN_BUSINESS_CODE__c)
        {
            product.FIN_BUSINESS_CODE__c = hapiProductLoad.FIN_BUSINESS_CODE__c;
        }
        if(null != hapiProductLoad.FIN_RESP_CODE__c)
        {
            product.FIN_RESP_CODE__c = hapiProductLoad.FIN_RESP_CODE__c;
        }
        if(null != hapiProductLoad.FIN_SUB_BUSINESS_CODE__c)
        {
            product.FIN_SUB_BUSINESS_CODE__c = hapiProductLoad.FIN_SUB_BUSINESS_CODE__c;
        }
        //MAR-35 - END
        
        return product;
    }
}