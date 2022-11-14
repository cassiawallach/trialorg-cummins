public class HAPI_ProductLoad_ExcelSheetGenerator 
{
    public static void generateProductLoadExcelSheet(String version, String emailId)
    {
        List<HAPI_ProductLoad_ExcelSheetGenerator_Wrapper>  wrapperList = new List<HAPI_ProductLoad_ExcelSheetGenerator_Wrapper>();
        
        List<ccrz__E_Product__c> productList = HAPI_DataLoad_Queries.getProducts();
        
        Map<ID, String> productIDToStringMap = new Map<ID, String>();
        for(ccrz__E_Product__c product : productList)
        {
            productIDToStringMap.put(product.ID, product.ccrz__SKU__c);
        }
        
        Map<ID, ccrz__E_Category__c> categoryIdMap = new Map<ID, ccrz__E_Category__c>();
        for(ccrz__E_Category__c category : HAPI_DataLoad_Queries.getCategories())
        {
            categoryIdMap.put(category.ID, category);
        }
        
        Map<ID, ccrz__E_Menu__c> menuIdMap = new Map<ID, ccrz__E_Menu__c>();
        Map<ID, ID> categoryIdToMenuIdMap = new Map<ID, ID>();
        
        for(ccrz__E_Menu__c menu : HAPI_DataLoad_Queries.getAllExistingMenus())
        {
            menuIdMap.put(menu.ID, menu);
           
            if(null != menu.ccrz__Category__c)
            {
                categoryIdToMenuIdMap.put(menu.ccrz__Category__c, menu.ID);
            }
        }
        
        Map<ID, ID> categoryIdToMenuItemIdMap = new Map<ID, ID>();
        Map<ID, ccrz__E_MenuItem__c> menuItemIdMap = new Map<ID, ccrz__E_MenuItem__c>();
        
        for(ccrz__E_MenuItem__c menuItem : HAPI_DataLoad_Queries.getAllExistingMenuItems())
        {
            menuItemIdMap.put(menuItem.ID, menuItem);
            
            if(null != menuItem.ccrz__Category__c)
            {
                 categoryIdToMenuItemIdMap.put(menuItem.ccrz__Category__c, menuItem.ID);
            }
           
        }
        
        // featured Product
        Map<ID, List<ccrz__E_FeaturedProduct__c>> productToFeaturedProductMap = new Map<ID, List<ccrz__E_FeaturedProduct__c>>();

        for(ccrz__E_FeaturedProduct__c featuredProduct : HAPI_DataLoad_Queries.getAllExistingFeaturedProducts())
        {
            if(null == productToFeaturedProductMap.get(featuredProduct.ccrz__Product__c))
            {
                productToFeaturedProductMap.put(featuredProduct.ccrz__Product__c, new List<ccrz__E_FeaturedProduct__c>());
            	productToFeaturedProductMap.get(featuredProduct.ccrz__Product__c).add(featuredProduct);
            }
            else
            {
                productToFeaturedProductMap.get(featuredProduct.ccrz__Product__c).add(featuredProduct);
            }
        }
        
        // composite product list
        Map<ID, List<ccrz__E_CompositeProduct__c>> productToCompositeProductMap = new Map<ID, List<ccrz__E_CompositeProduct__c>>();

        for(ccrz__E_CompositeProduct__c compositeProduct : HAPI_DataLoad_Queries.getAllExistingCompositeProducts())
        {
            if(null == productToCompositeProductMap.get(compositeProduct.ccrz__Composite__c))
            {
                productToCompositeProductMap.put(compositeProduct.ccrz__Composite__c, new List<ccrz__E_CompositeProduct__c>());
            	productToCompositeProductMap.get(compositeProduct.ccrz__Composite__c).add(compositeProduct);
            }
            else
            {
                productToCompositeProductMap.get(compositeProduct.ccrz__Composite__c).add(compositeProduct);
            }
        }
        
        // related products list
        Map<ID, List<ccrz__E_RelatedProduct__c>> productToRelatedProductMap = new Map<ID, List<ccrz__E_RelatedProduct__c>>();

        for(ccrz__E_RelatedProduct__c relatedProduct : HAPI_DataLoad_Queries.getAllExistingRelatedProducts())
        {
            if(null == productToRelatedProductMap.get(relatedProduct.ccrz__Product__c))
            {
                productToRelatedProductMap.put(relatedProduct.ccrz__Product__c, new List<ccrz__E_RelatedProduct__c>());
            	productToRelatedProductMap.get(relatedProduct.ccrz__Product__c).add(relatedProduct);
            }
            else
            {
                productToRelatedProductMap.get(relatedProduct.ccrz__Product__c).add(relatedProduct);
            }
        }
        
        // category list
        Map<ID, List<ccrz__E_ProductCategory__c>> productToProductCategoryMap = new Map<ID, List<ccrz__E_ProductCategory__c>>();

        for(ccrz__E_ProductCategory__c productCategory : HAPI_DataLoad_Queries.getAllExistingProductCategories())
        {
            if(null == productToProductCategoryMap.get(productCategory.ccrz__Product__c))
            {
                productToProductCategoryMap.put(productCategory.ccrz__Product__c, new List<ccrz__E_ProductCategory__c>());
            	productToProductCategoryMap.get(productCategory.ccrz__Product__c).add(productCategory);
            }
            else
            {
                productToProductCategoryMap.get(productCategory.ccrz__Product__c).add(productCategory);
            }
        }
        
        // spec list
        Map<ID, List<ccrz__E_ProductSpec__c>> productToProductSpecMap = new Map<ID, List<ccrz__E_ProductSpec__c>>();

        for(ccrz__E_ProductSpec__c productSpec : HAPI_DataLoad_Queries.getAllExistingProductSpecs())
        {
            if(null == productToProductSpecMap.get(productSpec.ccrz__Product__c))
            {
                productToProductSpecMap.put(productSpec.ccrz__Product__c, new List<ccrz__E_ProductSpec__c>());
            	productToProductSpecMap.get(productSpec.ccrz__Product__c).add(productSpec);
            }
            else
            {
                productToProductSpecMap.get(productSpec.ccrz__Product__c).add(productSpec);
            }
        }
        
        for(ccrz__E_Product__c product : productList)
        {
            HAPI_ProductLoad_ExcelSheetGenerator_Wrapper wrapper = new HAPI_ProductLoad_ExcelSheetGenerator_Wrapper();
            
            wrapper.version = version;
        	wrapper.productDataOperation = true;
            
            //productData
            wrapper = mapProductDataToWrapper(product, wrapper);
            
            // product Media
            wrapper.productMediaOperation = false;
        	wrapper.productMediaDataList = '';
            
            // featured Product
            List<ccrz__E_FeaturedProduct__c> featuredProductList= productToFeaturedProductMap.get(product.ID);
            
            wrapper.featuredProductsOperation = false;
            wrapper.featuredProductsDataList = '';
            
            if(null != featuredProductList && featuredProductList.size() > 0)
            {
                wrapper.featuredProductsOperation = true;
                
                for(ccrz__E_FeaturedProduct__c featuredProduct : featuredProductList)
                {
                    wrapper.featuredProductsDataList = wrapper.featuredProductsDataList + '{' + featuredProduct.ccrz__Type__c + '}#';
                }
                
                wrapper.featuredProductsDataList = wrapper.featuredProductsDataList.subString(0, wrapper.featuredProductsDataList.length()-1);
                
                wrapper.featuredProductsDataList = '[' + wrapper.featuredProductsDataList + ']';
            }
            
            // composite product list
            List<ccrz__E_CompositeProduct__c> compositeProductList= productToCompositeProductMap.get(product.ID);
            
            wrapper.compositeProductsOperation = false;
            wrapper.compositeProductsDataList = '';
            
            if(null != compositeProductList && compositeProductList.size() > 0)
            {
                wrapper.compositeProductsOperation = true;
                
                for(ccrz__E_CompositeProduct__c compositeProduct : compositeProductList)
                {
                    wrapper.compositeProductsDataList = wrapper.compositeProductsDataList 
                        + '{' + productIDToStringMap.get(compositeProduct.ccrz__Component__c) 
                        + '~' + compositeProduct.ccrz__Quantity__c;
                    
                    if(null != compositeProduct.Unit__c)
                    {
                        wrapper.compositeProductsDataList = wrapper.compositeProductsDataList + '~' + compositeProduct.Unit__c;
                    }
                    
                    wrapper.compositeProductsDataList = wrapper.compositeProductsDataList + '}#';
                }
                
                wrapper.compositeProductsDataList = wrapper.compositeProductsDataList.subString(0, wrapper.compositeProductsDataList.length()-1);
                
                wrapper.compositeProductsDataList = '[' + wrapper.compositeProductsDataList + ']';
            }
            
            // related products list
            List<ccrz__E_RelatedProduct__c> relatedProductList= productToRelatedProductMap.get(product.ID);
            
            wrapper.relatedProductsOperation = false;
            wrapper.relatedProductsDataList = '';
            
            if(null != relatedProductList && relatedProductList.size() > 0)
            {
                wrapper.relatedProductsOperation = true;
                
                for(ccrz__E_RelatedProduct__c relatedProduct : relatedProductList)
                {
                    wrapper.relatedProductsDataList = wrapper.relatedProductsDataList 
                        + '{' + productIDToStringMap.get(relatedProduct.ccrz__RelatedProduct__c) 
                        + '~' + relatedProduct.ccrz__RelatedProductType__c + '}#';
                }
                
                wrapper.relatedProductsDataList = wrapper.relatedProductsDataList.subString(0, wrapper.relatedProductsDataList.length()-1);
                
                wrapper.relatedProductsDataList = '[' + wrapper.relatedProductsDataList + ']';
            }
            
            // category list
            List<ccrz__E_ProductCategory__c> productCategoryList= productToProductCategoryMap.get(product.ID);
            
            wrapper.categoryOperation = false;
            wrapper.categoryDataList = '';
            /*
            if(null != productCategoryList && productCategoryList.size() > 0)
            {
                wrapper.categoryOperation = true;
                
                for(ccrz__E_ProductCategory__c productCategory : productCategoryList)
                {
                    String categoryName = categoryIdMap.get(productCategory.ccrz__Category__c).Name;
                    ID menuId;
                    
                    // it is in the Menu directly
                    if(null != categoryIdToMenuIdMap.get(productCategory.ccrz__Category__c))
                    {
                        menuId = categoryIdToMenuIdMap.get(productCategory.ccrz__Category__c);
                    }
                    if(null != categoryIdToMenuItemIdMap.get(productCategory.ccrz__Category__c))
                    {
                        ID menutItemID = categoryIdToMenuItemIdMap.get(productCategory.ccrz__Category__c);
                        menuId = menuItemIdMap.get(menutItemID).ccrz__Menu__c;
                    }
                    
                    if(null !=menuId )
                    {
                        String menuName = menuIdMap.get(menuId).ccrz__DisplayName__c;
                        String menuLinkType = menuIdMap.get(menuId).ccrz__LinkType__c;
                        if(null == menuLinkType)
                        {
                            menuLinkType = 'None';
                        }
                        wrapper.categoryDataList = wrapper.categoryDataList + '{' + categoryName + '~' + menuName + '~' + menuLinkType + '}#';   
                    }         
                }
                
                wrapper.categoryDataList = wrapper.categoryDataList.subString(0, wrapper.categoryDataList.length()-1);
                
                wrapper.categoryDataList = '[' + wrapper.categoryDataList + ']';
            }
            */
            // spec list
            wrapper.specOperation = false;
            wrapper.specDataList = '';
            
            wrapperList.add(wrapper);
        }
        
        createExcelSheet(wrapperList, emailId);
    }
    
    public static void createExcelSheet(List<HAPI_ProductLoad_ExcelSheetGenerator_Wrapper> wrapperList, String emailId)
    {
        string header = 'Version, Product Data Operation, Product Name, Product SKU, Product Version, Product Reference Name, Product Status, '
            + 'QuantityperUnit, StartDate, End Date, Group Name, Package, Stand Alone Product, Product Type, ' 
            + 'Storefront, Unit Of Measure, Product Class Code, Lead Time, Product Weight, Short Desc, Short Desc RT, Long Desc, Long Desc RT, '
            + 'Product Media Operation, Product Media List, Featured Products Operation, Featured Products List, Composite Products Operation, Composite Products List, ' 
            + 'Related Products Operation, Related Products List, Category Operation, Category List, Spec Operation, Spec List ' + '\n';
        
        String finalString = header;
        
        for(HAPI_ProductLoad_ExcelSheetGenerator_Wrapper wrapper : wrapperList)
        {
            /*wrapper.productName = wrapper.productName.replace(',', ' ');
            wrapper.productReferenceName = ''; */
            
            wrapper.shortDescRT = wrapper.shortDesc;
            //wrapper.longDesc = '';
            
            wrapper.longDesc = wrapper.longDesc.replace(',', ' ');
            wrapper.longDesc = wrapper.longDesc.replace('\r\n', ' ');
			wrapper.longDesc = wrapper.longDesc.replace('\n', ' ');
			wrapper.longDesc = wrapper.longDesc.replace('\r', ' ');
            
            wrapper.longDescRT = '';
            
            
            String recordString = '"' + wrapper.version + '","' + wrapper.productDataOperation + '","' + wrapper.productName 
                + '","' + wrapper.productSku + '","' + wrapper.productVersion + '","' + wrapper.productReferenceName + '","' + wrapper.productStatus 
                + '","' + wrapper.quantityPerUnit + '","' + wrapper.startDate + '","' + wrapper.EndDate + '","' + wrapper.groupName + '","' + wrapper.packageValue 
                + '","' + wrapper.standAloneProduct + '","' + wrapper.productType + '","' + wrapper.storefront + '","' + wrapper.unitOfMeasure 
                + '","' + wrapper.productClassCode + '","' + wrapper.leadTime + '","' + wrapper.productWeight 
                + '","' + wrapper.shortDesc + '","' + wrapper.shortDescRT 
                + '","' + wrapper.longDesc + '","' + wrapper.longDescRT  
                + '","' + wrapper.productMediaOperation + '","' + wrapper.productMediaDataList 
                + '","' + wrapper.featuredProductsOperation + '","' + wrapper.featuredProductsDataList 
                + '","' + wrapper.compositeProductsOperation + '","' + wrapper.compositeProductsDataList 
                + '","' + wrapper.relatedProductsOperation + '","' + wrapper.relatedProductsDataList 
                + '","' + wrapper.categoryOperation + '","' + wrapper.categoryDataList 
                + '","' + wrapper.specOperation + '","' + wrapper.specDataList + '"'
                + '\n';
            
            finalString = finalString + recordString;
        }
        
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalString);
        string csvname= 'SESProductLoad.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        
        Messaging.SingleEmailMessage email1 =new Messaging.SingleEmailMessage();
        String[] toAddresses1 = new list<string> {emailId};
            String subject1 ='SESProductLoad : ' + Datetime.now().format('dd MMMM YYYY');
        email1.setSubject(subject1);
        email1.setToAddresses(toAddresses1);
        
        
        //email1.setPlainTextBody('Total Percentage covered of org is : ' + intTotalPercentageCovered);
        String messageBody='';
        email1.setHtmlBody(messageBody);
        email1.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email1});
    }
	
    public static HAPI_ProductLoad_ExcelSheetGenerator_Wrapper mapProductDataToWrapper(ccrz__E_Product__c product, HAPI_ProductLoad_ExcelSheetGenerator_Wrapper wrapper)
    {
        if(null != product.Name)
            wrapper.productName = product.Name;
        
        if(null != product.ccrz__SKU__c)
        	wrapper.productSku = product.ccrz__SKU__c;
        
        if(null != product.ccrz__Quantityperunit__c)
            wrapper.quantityPerUnit = product.ccrz__Quantityperunit__c;
        
        if(null != product.ccrz__StartDate__c)
            wrapper.startDate = product.ccrz__StartDate__c;
        
        if(null != product.ccrz__EndDate__c)
            wrapper.endDate = product.ccrz__EndDate__c;
        
        if(null != product.Group_Name__c)
            wrapper.groupName = product.Group_Name__c;
        
        if(null != product.ccrz__ProductType__c)
            wrapper.productType = product.ccrz__ProductType__c;
        
        if(null != product.Package__c)
            wrapper.packageValue = product.Package__c;
        
        if(null != product.Stand_Alone_Product__c)
            	wrapper.standAloneProduct = product.Stand_Alone_Product__c;
        
        if(null != product.Product_Version__c)
            wrapper.productVersion = product.Product_Version__c;
        
        if(null != product.Product_Reference_Name__c)
            wrapper.productReferenceName = product.Product_Reference_Name__c;
        
        if(null != product.ccrz__ProductStatus__c)
            wrapper.productStatus = product.ccrz__ProductStatus__c;
        
        if(null != product.ccrz__Storefront__c)
            wrapper.storefront = product.ccrz__Storefront__c;
        
        if(null != product.ccrz__UnitOfMeasure__c)
            wrapper.unitOfMeasure = product.ccrz__UnitOfMeasure__c;
        
        if(null != product.Product_Class_Code__c)
            wrapper.productClassCode = product.Product_Class_Code__c;
        
        if(null != product.ccrz__LeadTime__c)
            wrapper.leadTime = product.ccrz__LeadTime__c;
        
        if(null != product.ccrz__ProductWeight__c)
            wrapper.productWeight = product.ccrz__ProductWeight__c;
        
        if(null != product.ccrz__ShortDesc__c)
            wrapper.shortDesc = product.ccrz__ShortDesc__c;
        
        if(null != product.ccrz__ShortDescRT__c)
            wrapper.shortDescRT = product.ccrz__ShortDescRT__c;
        
        if(null != product.ccrz__LongDesc__c)
            wrapper.longDesc = product.ccrz__LongDesc__c;
        
        if(null != product.ccrz__LongDescRT__c)
            wrapper.longDescRT = product.ccrz__LongDescRT__c;
        
        return wrapper;
    }
    
    public class HAPI_ProductLoad_ExcelSheetGenerator_Wrapper
    {
        public String version = '';
        public Boolean productDataOperation;
        public String productName = '';
        public String productSku = '';
        public Decimal quantityPerUnit;
        public Date startDate;
        public Date endDate;
        public String groupName = '';
        public String productType = '';
        public String packageValue = '';
        public String standAloneProduct = '';
        public String productVersion = '';
        public String productReferenceName = '';
        public String productStatus = '';
        public String storefront = '';
        public String unitOfMeasure = '';
        public String productClassCode = '';
        public Decimal leadTime;
        public Decimal productWeight;
        public String shortDesc = '';
        public String shortDescRT = '';
        public String longDesc = '';
        public String longDescRT = '';
        
        public Boolean productMediaOperation;
        public String productMediaDataList;
        
        public Boolean featuredProductsOperation;
        public String featuredProductsDataList;
        
        public Boolean compositeProductsOperation;
        public String compositeProductsDataList;
        
        public Boolean relatedProductsOperation;
        public String relatedProductsDataList;
        
        public Boolean categoryOperation;
        public String categoryDataList;
        
        public Boolean specOperation;
        public String specDataList;
        
    }
}