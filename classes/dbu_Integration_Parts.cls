/**********************************************************************
Name: dbu_Integration_Parts
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    REST API Service to import bulk data from Parts.Cummins.Com 
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajnish Kumar         07/08/2020                 INITIAL DEVELOPMENT                    

***********************************************************************/

@RestResource(urlMapping='/DBU_Integration_Parts/*')
global with sharing class dbu_Integration_Parts {

    @HttpPost
    global static void InsertProduct(List<dbu_Integration_Parts_Request> data) 
    {
        List<ccrz__E_Product__c> productsTobeAdded = new List<ccrz__E_Product__c>();
        List<ccrz__E_ProductMedia__c> productMediaTobeAdded = new List<ccrz__E_ProductMedia__c>();
        List<ccrz__E_Spec__c> specsTobeAdded = new List<ccrz__E_Spec__c>();
        List<ccrz__E_ProductSpec__c> productSpecsTobeAdded = new List<ccrz__E_ProductSpec__c>();
        List<ccrz__E_PriceListItem__c> productPriceTobeAdded = new List<ccrz__E_PriceListItem__c>();
        List<ccrz__E_RelatedProduct__c> supersedeProductTobeAdded = new List<ccrz__E_RelatedProduct__c>();
        List<ccrz__E_RelatedProduct__c> reconEquivalentPartNumberTobeAdded = new List<ccrz__E_RelatedProduct__c>();
        //List<ccrz__E_RelatedProduct__c> productGroupingTobeAdded = new List<ccrz__E_RelatedProduct__c>();
        List<ccrz__E_ProductCategory__c> productCategoriesTobeAdded = new List<ccrz__E_ProductCategory__c>();

        Map<String,ccrz__E_Product__c> existingProductsMap = new Map<String,ccrz__E_Product__c>();
        Map<String,ccrz__E_ProductMedia__c> existingMediaImageMap = new Map<String,ccrz__E_ProductMedia__c>();
        Map<String,ccrz__E_ProductMedia__c> existingMediaVideoMap = new Map<String,ccrz__E_ProductMedia__c>();
        
        Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionLengthMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionHeightMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionWidthMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionWeightMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionLengthMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionHeightMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionWidthMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionWeightMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingSpecUOMMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingSpecCapacityMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_ProductSpec__c> existingProductSpecsMap = new Map<String,ccrz__E_ProductSpec__c>();
        Map<String,ccrz__E_Spec__c> specsMap = new Map<String,ccrz__E_Spec__c>();
        
        Map<String,ccrz__E_PriceListItem__c> existingPricesMap = new Map<String,ccrz__E_PriceListItem__c>();
        
        Map<String,ccrz__E_Category__c> existingCategoriesMap = new Map<String,ccrz__E_Category__c>();
        Map<String,ccrz__E_ProductCategory__c> existingProductCategoriesMap = new Map<String,ccrz__E_ProductCategory__c>();

        Map<String,ccrz__E_RelatedProduct__c> existingSupersedProductMap = new Map<String,ccrz__E_RelatedProduct__c>();
        Map<String,ccrz__E_RelatedProduct__c> existingReconEquivalentMap = new Map<String,ccrz__E_RelatedProduct__c>();
        //Map<String,ccrz__E_RelatedProduct__c> existingProductGroupMap = new Map<String,ccrz__E_RelatedProduct__c>();
        
        Set<String> existingProductSKUs = new Set<String>();
        Set<String> existingProductIds = new Set<String>();
        Set<String> existingSpecNames  = new Set<String>();

        try 
        {
            /* Constant Values */
          //  String ShipmentDimensionLengthId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Shipment Length' limit 1][0].Id;
          //  String ShipmentDimensionHeightId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Shipment Height' limit 1][0].Id;
          //  String ShipmentDimensionWidthId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Shipment Width' limit 1][0].Id;
          //  String ShipmentDimensionWeightId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Shipment Weight' limit 1][0].Id;

          // String SpecDimensionLengthId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Item Length' limit 1][0].Id;
          //  String SpecDimensionHeightId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Item Height' limit 1][0].Id;
          //  String SpecDimensionWidthId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Item Width' limit 1][0].Id;
          //  String SpecDimensionWeightId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Item Weight' limit 1][0].Id;

          //  String SpecUOMId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='UOM' limit 1][0].Id;
          //  String SpecCapacityId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='Capacity' limit 1][0].Id;
            //String SpecSystemId = [SELECT ID FROM ccrz__E_Spec__c WHERE Name='System' limit 1][0].Id;

            String priceListUS = [SELECT Id FROM ccrz__E_PriceList__c WHERE Name='CSSNA USD Pricelist' LIMIT 1][0].Id;
            String priceListCA = [SELECT Id FROM ccrz__E_PriceList__c WHERE Name='CSSNA CAD Pricelist' LIMIT 1][0].Id;
            
         //   String supersededProductRelatedProductGroupId = [SELECT Id FROM ccrz__E_RelatedProductGroup__c WHERE Name='SupersededProduct' LIMIT 1][0].Id;
         //   String reconEquivalentRelatedProductGroupId = [SELECT Id FROM ccrz__E_RelatedProductGroup__c WHERE Name='ReconEquivalent' LIMIT 1][0].Id;
         //   String productGroupingGroupId = [SELECT Id FROM ccrz__E_RelatedProductGroup__c WHERE Name='ProductGroup' LIMIT 1][0].Id;
            
            /* Product Ids */
            for (dbu_Integration_Parts_Request request : data) {
                existingProductSKUs.add(request.SKU);
            }
          /*  for(dbu_Integration_Parts_Request request : data)
            {
                for (dbu_Integration_Parts_Specs spec : request.Specs) {
                    existingSpecNames.add(spec.Key);
                }
            }
          */    
            System.debug('I have selected all variables');
            List<ccrz__E_Product__c> productItems = [SELECT Id,
                                                            CCRZ__SKU__C,
                                                            MARKET_SEGMENT__C,
                                                            Name,
                                                            PRODUCT_VERSION__C,
                                                            STAND_ALONE_PRODUCT__C,
                                                            CCRZ__ALTERNATENAME__C,
                                                            CCRZ__LONGDESCRT__C,
                                                            CCRZ__LONGDESC__C,
                                                            CCRZ__PRODUCTTYPE__C,
                                                            CCRZ__SHORTDESCRT__C,
                                                            CCRZ__SHORTDESC__C,
                                                            CCRZ__TAXRATEID__C,
                                                            CCRZ__UNITOFMEASURE__C,
                                                            ccrz__EndDate__c,
                                                            ccrz__StartDate__c,
                                                            ccrz__ProductStatus__c,
                                                            ccrz__AvailabilityMessageRT__c,
                                                            ccrz__Quantityperunit__c,
                                                            ccrz__LeadTime__c,
                                                            CCRZ__COOLERPAKFLAG__C,
                                                            CCRZ__DRYICEFLAG__C,
                                                            CCRZ__DRYICEWEIGHT__C,
                                                            CCRZ__HAZARDOUSFLAG__C,
                                                            CCRZ__PRODUCTWEIGHT__C,
                                                            ccrz__OvernightFlag__c,
                                                            ccrz__ReviewFlag__c,
                                                            CCRZ__SEQUENCE__C,
                                                            ccrz__GroundFlag__c,
                                                            ccrz__HazardousOutside48Flag__c,
                                                            CCRZ__SERVICEFLAG__C,
                                                            CCRZ__SHIPSEPARATELY__C,
                                                            CCRZ__SHIPPEDINDIVIDUALLY__C,
                                                            CCRZ__SHIPPINGWEIGHT__C,
                                                            CCRZ__TAXABLE__C,
                                                            ISIAMPROVISIONINGREQUIRED__C,
                                                            dbu_Product_Location__c,
                                                            dbu_BMS_Instance__c,
                                                            dbu_Product_Code__c ,
                                                            dbu_Distributor_Code__c
                                                            FROM ccrz__E_Product__c 
                                                            WHERE CCRZ__SKU__C 
                                                            IN:existingProductSKUs];
            

            for (ccrz__E_Product__c productItem : productItems) {
                existingProductIds.add(productItem.Id);
            }

            List<ccrz__E_PriceListItem__c> priceItems = [SELECT ID,dbu_Original_Price__c,dbu_Discount_Type__c,dbu_Discount_Amount__c,ccrz__Price__c,ccrz__PricingTiers__c,ccrz__Product__c,ccrz__Pricelist__c FROM ccrz__E_PriceListItem__c WHERE ccrz__Product__c IN :existingProductIds]   ;                                           
            
            //List<ccrz__E_ProductMedia__c> mediaImageItems = [SELECT ID,ccrz__URI__c,ccrz__MediaType__c,ccrz__Product__c,ccrz__StartDate__c,ccrz__EndDate__c,ccrz__Sequence__c FROM ccrz__E_ProductMedia__c WHERE ccrz__Product__c IN :existingProductIds ]   ;                                           
            //List<ccrz__E_ProductMedia__c> mediaImageItems = [SELECT ID,ccrz__URI__c,ccrz__MediaType__c,ccrz__Product__c,ccrz__StartDate__c,ccrz__EndDate__c,ccrz__Sequence__c FROM ccrz__E_ProductMedia__c WHERE ccrz__MediaType__c = 'Product Image' AND ccrz__Product__c IN :existingProductIds ]   ;                                           
            //List<ccrz__E_ProductMedia__c> mediaVideoItems = [SELECT ID,ccrz__URI__c,ccrz__MediaType__c,ccrz__Product__c,ccrz__StartDate__c,ccrz__EndDate__c,ccrz__Sequence__c FROM ccrz__E_ProductMedia__c WHERE ccrz__MediaType__c = 'Media' AND ccrz__Product__c IN :existingProductIds ]   ;                                           

                                                                                                                                                                                    
           // List<ccrz__E_ProductSpec__c> shipmentDimensionLengthItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:ShipmentDimensionLengthId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> shipmentDimensionHeightItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:ShipmentDimensionHeightId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> shipmentDimensionWeightItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:ShipmentDimensionWidthId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> shipmentDimensionWidthItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:ShipmentDimensionWeightId AND  ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> specDimensionLengthItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:SpecDimensionLengthId AND  ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> specDimensionHeightItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:SpecDimensionHeightId AND  ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> specDimensionWidthItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:SpecDimensionWidthId AND  ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> specDimensionWeightItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:SpecDimensionWeightId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> specUOMItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:SpecUOMId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> specSystemItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:SpecSystemId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> specCapacityItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__c,ccrz__Spec__c FROM ccrz__E_ProductSpec__c WHERE ccrz__Spec__c=:SpecCapacityId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           // List<ccrz__E_ProductSpec__c> productSpecItems = [SELECT ID,ccrz__SpecValue__c,ccrz__Product__r.Id,ccrz__Spec__r.Name FROM ccrz__E_ProductSpec__c WHERE  ccrz__Product__c IN :existingProductIds];                                           
           // List<ccrz__E_Spec__c> existingSpecItems = [SELECT ID,Name FROM ccrz__E_Spec__c WHERE  Name IN :existingSpecNames];    

            List<ccrz__E_RelatedProduct__c> supersededProductItems = [SELECT ID,ccrz__RelatedProduct__c,ccrz__Product__r.Id,ccrz__RelatedProduct__r.ccrz__SKU__c,ccrz__RelatedProductType__c FROM ccrz__E_RelatedProduct__c WHERE ccrz__RelatedProductType__c='SupersededProduct' AND ccrz__Product__c IN :existingProductIds ]   ;                                           
           //List<ccrz__E_RelatedProduct__c> reconEquivalentItems = [SELECT ID,ccrz__RelatedProduct__c,ccrz__Product__r.Id,ccrz__RelatedProduct__r.ccrz__SKU__c,ccrz__RelatedProductType__c FROM ccrz__E_RelatedProduct__c WHERE ccrz__RelatedProductType__c='ReconEquivalent' AND ccrz__Product__c IN :existingProductIds ]   ;                                           
            //List<ccrz__E_RelatedProduct__c> productGroupItems = [SELECT ID,ccrz__Product__c,ccrz__RelatedProductGroup__c FROM ccrz__E_RelatedProduct__c WHERE ccrz__RelatedProductGroup__c=:productGroupingGroupId AND ccrz__Product__c IN :existingProductIds ]   ;                                           
            List<ccrz__E_Category__c> allCategoryItems = [SELECT ID,Name,ccrz__ParentCategory__c,Storefront__c,ccrz__Sequence__c FROM ccrz__E_Category__c WHERE Storefront__c='CSSNAStore'];                                           
            List<ccrz__E_ProductCategory__c> productCategoryItems = [SELECT ID,ccrz__Category__c,ccrz__Category__r.Name,ccrz__Product__c FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__c IN :existingProductIds];                                           
            List<ccrz__E_Spec__c> existingSpecWithNewItems = new List<ccrz__E_Spec__c>();
            //existingCategoriesMap
            System.debug('All select queries done');
            List<String> existingSpecItemNames = new List<String>();
            List<String> specsItemsTobeAdded = new List<String>();

           /* for (ccrz__E_Spec__c spec : existingSpecItems) {
                existingSpecItemNames.add(spec.Name);
            }
            for(String spec:existingSpecNames)
            {
                if(!existingSpecItemNames.Contains(spec))
                    specsItemsTobeAdded.add(spec);
            }

            for (ccrz__E_ProductSpec__c item : productSpecItems) {
                existingProductSpecsMap.put(item.ccrz__Product__r.Id+item.ccrz__Spec__r.Name,item);
            }
            for (ccrz__E_Category__c item : allCategoryItems) {
                existingCategoriesMap.put(item.Name.toLowerCase(), item);
            }
           
            for (ccrz__E_ProductCategory__c item : productCategoryItems) {
                existingProductCategoriesMap.put(item.ccrz__Product__c+item.ccrz__Category__r.Name.toLowerCase(), item);
            }
            */
            
            for (ccrz__E_RelatedProduct__c item : supersededProductItems) {
                existingSupersedProductMap.put(item.ccrz__Product__r.Id+item.ccrz__RelatedProduct__r.ccrz__SKU__c, item);
            }

          /*  for (ccrz__E_RelatedProduct__c item : reconEquivalentItems) {
                existingReconEquivalentMap.put(item.ccrz__Product__r.Id+item.ccrz__RelatedProduct__r.ccrz__SKU__c, item);
            }

            // for (ccrz__E_RelatedProduct__c item : productGroupItems) {
            //     existingProductGroupMap.put(item.ccrz__Product__c, item);
            // }
          */

            /* PRODUCT  */
            for (ccrz__E_Product__c productItem : productItems) {
                existingProductsMap.put(productItem.CCRZ__SKU__C, productItem);
            }

            /* PRODUCT IMAGES */
           /* for (ccrz__E_ProductMedia__c mediaItem : mediaImageItems) {
                if(mediaItem.ccrz__MediaType__c =='Product Image') //Changed for CSSN-2628,CSSN-2627
                existingMediaImageMap.put(mediaItem.ccrz__Product__c+mediaItem.ccrz__URI__c, mediaItem);
            }
          */
            // /* PRODUCT VIDEO */
            // for (ccrz__E_ProductMedia__c mediaItem : mediaVideoItems) {
            //     existingMediaVideoMap.put(mediaItem.ccrz__Product__c+mediaItem.ccrz__URI__c, mediaItem);
            // }

            /* PRODUCT PRICES */
            for (ccrz__E_PriceListItem__c priceItem : priceItems) {
                //String key = priceItem.ccrz__Product__r.Id+priceItem.ccrz__Pricelist__r.Id;
                existingPricesMap.put(priceItem.ccrz__Product__c +'-'+priceItem.ccrz__Pricelist__c, priceItem);
            }

            /* PRODUCT SPECS */
          /*  for (ccrz__E_ProductSpec__c specItem : shipmentDimensionLengthItems) {
                existingShipmentDimensionLengthMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : shipmentDimensionHeightItems) {
                existingShipmentDimensionHeightMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : shipmentDimensionWeightItems) {
                existingShipmentDimensionWidthMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : shipmentDimensionWidthItems) {
                existingShipmentDimensionWeightMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : specDimensionLengthItems) {
                existingSpecDimensionLengthMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : specDimensionHeightItems) {
                existingSpecDimensionHeightMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : specDimensionWidthItems) {
                existingSpecDimensionWidthMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : specDimensionWeightItems) {
                existingSpecDimensionWeightMap.put(specItem.ccrz__Product__c, specItem);
            }

            for (ccrz__E_ProductSpec__c specItem : specUOMItems) {
                existingSpecUOMMap.put(specItem.ccrz__Product__c, specItem);
            }

            // for (ccrz__E_ProductSpec__c specItem : specSystemItems) {
            //     existingSpecSystemMap.put(specItem.ccrz__Product__c, specItem);
            // }

            for (ccrz__E_ProductSpec__c specItem : specCapacityItems) {
                existingSpecCapacityMap.put(specItem.ccrz__Product__c, specItem);
            }
         */
            System.debug('I have setup all maps');

           /* for(dbu_Integration_Parts_Request item:data)
            {
                //ccrz__E_Product__c product = PopulateProduct(item,existingProductsMap);
                //productsTobeAdded.add(product);

            }*/
            /*if(!specsItemsTobeAdded.isEmpty())
            {
                for (String item :specsItemsTobeAdded) {
                    ccrz__E_Spec__c newSpec = new ccrz__E_Spec__c();
                    newSpec.Name = item;
                    //newSpec.CurrencyIsoCode='USD - U.S. Dollar';
                    newSpec.ccrz__IsVisibleInCatalog__c = true;
                    specsTobeAdded.add(newSpec);
                }
                insert specsTobeAdded;
                System.debug('New specs added');
                existingSpecWithNewItems = [SELECT ID,Name FROM ccrz__E_Spec__c WHERE  Name IN :existingSpecNames];    
            }
            else{
                existingSpecWithNewItems = existingSpecItems;
            }
            for (ccrz__E_Spec__c spec : existingSpecWithNewItems) {
                specsMap.put(spec.Name,spec);
            }
           */
           // if(!productsTobeAdded.isEmpty())
            //{
                System.debug('Products to be updated=>'+JSON.serialize(productsTobeAdded));

              //  upsert productsTobeAdded;
                System.debug('Product insert successfull');

             /*   List<ccrz__E_Product__c> productItemsAfterInsert = [SELECT Id,
                                                            CCRZ__SKU__C,
                                                            MARKET_SEGMENT__C,
                                                            Name,
                                                            PRODUCT_VERSION__C,
                                                            STAND_ALONE_PRODUCT__C,
                                                            CCRZ__ALTERNATENAME__C,
                                                            CCRZ__LONGDESCRT__C,
                                                            CCRZ__LONGDESC__C,
                                                            CCRZ__PRODUCTTYPE__C,
                                                            CCRZ__SHORTDESCRT__C,
                                                            CCRZ__SHORTDESC__C,
                                                            CCRZ__TAXRATEID__C,
                                                            CCRZ__UNITOFMEASURE__C,
                                                            ccrz__EndDate__c,
                                                            ccrz__StartDate__c,
                                                            ccrz__ProductStatus__c,
                                                            ccrz__AvailabilityMessageRT__c,
                                                            ccrz__Quantityperunit__c,
                                                            ccrz__LeadTime__c,
                                                            CCRZ__COOLERPAKFLAG__C,
                                                            CCRZ__DRYICEFLAG__C,
                                                            CCRZ__DRYICEWEIGHT__C,
                                                            CCRZ__HAZARDOUSFLAG__C,
                                                            CCRZ__PRODUCTWEIGHT__C,
                                                            ccrz__OvernightFlag__c,
                                                            ccrz__ReviewFlag__c,
                                                            CCRZ__SEQUENCE__C,
                                                            ccrz__GroundFlag__c,
                                                            ccrz__HazardousOutside48Flag__c,
                                                            CCRZ__SERVICEFLAG__C,
                                                            CCRZ__SHIPSEPARATELY__C,
                                                            CCRZ__SHIPPEDINDIVIDUALLY__C,
                                                            CCRZ__SHIPPINGWEIGHT__C,
                                                            CCRZ__TAXABLE__C,
                                                            ISIAMPROVISIONINGREQUIRED__C,
                                                            dbu_Product_Location__c,
                                                            dbu_BMS_Instance__c,
                                                            dbu_Product_Code__c ,
                                                            dbu_Distributor_Code__c
                                                            FROM ccrz__E_Product__c 
                                                            WHERE CCRZ__SKU__C 
                                                            IN:existingProductSKUs];

                existingProductsMap = new Map<String,ccrz__E_Product__c>();

                for (ccrz__E_Product__c productItem : productItemsAfterInsert) {
                    existingProductsMap.put(productItem.CCRZ__SKU__C, productItem);
                }
             
                System.debug('Updated products=>'+JSON.serialize(existingProductsMap)); */

            //}
            /* Prepare records to be inserted/updated */
            for(dbu_Integration_Parts_Request item:data)
            {
                 ccrz__E_Product__c product = existingProductsMap.get(item.SKU);
                // productsTobeAdded.add(product);
               
                if(product != null){
                    // List<ccrz__E_ProductMedia__c> media = PopulateProductMedia(product,item,existingMediaImageMap,existingMediaVideoMap);
                   /*   List<ccrz__E_ProductMedia__c> media = PopulateProductMedia(product,item,existingMediaImageMap);

                    if (!media.isEmpty())  {
                        productMediaTobeAdded.addAll(media);
                    }

                  List<ccrz__E_ProductSpec__c> spec = PopulateProductSpec(product,
                                                                            item,
                                                                            existingShipmentDimensionLengthMap,
                                                                            existingShipmentDimensionHeightMap,
                                                                            existingShipmentDimensionWidthMap,
                                                                            existingShipmentDimensionWeightMap,
                                                                            existingSpecDimensionLengthMap,
                                                                            existingSpecDimensionHeightMap,
                                                                            existingSpecDimensionWidthMap,
                                                                            existingSpecDimensionWeightMap,
                                                                            existingSpecUOMMap,
                                                                            //existingSpecSystemMap,
                                                                            existingSpecCapacityMap,
                                                                            ShipmentDimensionLengthId,
                                                                            ShipmentDimensionHeightId,
                                                                            ShipmentDimensionWidthId,
                                                                            ShipmentDimensionWeightId,
                                                                            SpecDimensionLengthId,
                                                                            SpecDimensionHeightId,
                                                                            SpecDimensionWidthId,
                                                                            SpecDimensionWeightId,
                                                                            SpecUOMId,
                                                                            SpecCapacityId,
                                                                            specsMap,
                                                                            existingProductSpecsMap);
                                                                            //SpecSystemId);

                    if (!spec.isEmpty()) {
                        productSpecsTobeAdded.addAll(spec);
                    }*/
                    //if()
                    List<ccrz__E_PriceListItem__c> price = PopulateProductPrice(product,item,existingPricesMap,priceListUS,priceListCA);
                     system.debug('@@The Price Updated'+price);
                    if (!price.isEmpty())  {
                        productPriceTobeAdded.addAll(price);
                    }

                  List<ccrz__E_RelatedProduct__c> supersedeProducts = PopulateSupersedeProduct(product,item,existingSupersedProductMap);

                    if (!supersedeProducts.isEmpty())  {
                        supersedeProductTobeAdded.addAll(supersedeProducts);
                    }

                 /* List<ccrz__E_RelatedProduct__c> reconEquivalentPartNumbers = PopulateReconEquivalentPartNumber(product,item,existingReconEquivalentMap);

                    if (!reconEquivalentPartNumbers.isEmpty())  {
                        reconEquivalentPartNumberTobeAdded.addAll(reconEquivalentPartNumbers);
                    }

                    List<ccrz__E_RelatedProduct__c> productGroupings = PopulateProductGrouping(product,item,existingProductGroupMap);

                    if (!productGroupings.isEmpty())  {
                        productGroupingTobeAdded.addAll(productGroupings);
                    }

                    List<ccrz__E_ProductCategory__c> productCategories = PopulateProductCategories(product,item,existingCategoriesMap,existingProductCategoriesMap);

                    if (!productCategories.isEmpty())  {
                        productCategoriesTobeAdded.addAll(productCategories);
                    }*/

                }

               /*if(!productsTobeAdded.isEmpty())
                {
                    System.debug('Products to be updated=>'+JSON.serialize(productsTobeAdded));

                    upsert productsTobeAdded;
                    System.debug('Product insert successfull');

                    if(!productMediaTobeAdded.isEmpty())
                    {
                        System.debug('Product Media to be updated=>'+JSON.serialize(productMediaTobeAdded));

                        upsert productMediaTobeAdded;
                        System.debug('Product Media insert successfull');
                    }
                    if(!productSpecsTobeAdded.isEmpty())
                    {
                        System.debug('Product Specs to be updated=>'+JSON.serialize(productSpecsTobeAdded));

                        upsert productSpecsTobeAdded;
                        System.debug('Product Specs insert successfull');
                    }*/
                    if(!productPriceTobeAdded.isEmpty())
                    {
                        System.debug('Product Price to be updated=>'+JSON.serialize(productPriceTobeAdded));

                        upsert productPriceTobeAdded;
                        System.debug('Product price insert successfull');
                    }
                    if(!supersedeProductTobeAdded.isEmpty())
                    {
                        System.debug('Product supersedeProductTobeAdded to be updated=>'+JSON.serialize(supersedeProductTobeAdded));

                        // CWiebe CHG0111841 START
                        Database.UpsertResult[] urSuperscededList = Database.upsert (supersedeProductTobeAdded, true);

                        List<String> errorMessages = new List<String>();
                        Boolean isSuccess = false;

                        for (Database.UpsertResult result : urSuperscededList) {

                            if (result.isSuccess()) {
                                isSuccess = true;
                            } else {
                                for(Database.Error err : result.getErrors()) {
                                    errorMessages.add(err.getMessage());
                                }

                                isSuccess = false;
                            }
                        }

                        if (!isSuccess) {
                            dbu_Integration_Error_Log.createErrorLog(null,string.join(errorMessages,','),JSON.serialize(data),'','Part Service','Superscession Exception');
                        }
                        
                        // CWiebe CHG0111841 END
                        System.debug('Product supersed product insert successfull');
                    }
                    
                   /* if(!reconEquivalentPartNumberTobeAdded.isEmpty())
                    {
                        System.debug('Product reconEquivalentPartNumberTobeAdded to be updated=>'+JSON.serialize(reconEquivalentPartNumberTobeAdded));

                        upsert reconEquivalentPartNumberTobeAdded;
                        System.debug('Product reconEquivalent insert successfull');
                    }
                    if(!productCategoriesTobeAdded.isEmpty())
                    {
                        System.debug('Product productCategoriesTobeAdded to be updated=>'+JSON.serialize(productCategoriesTobeAdded));

                        upsert productCategoriesTobeAdded;
                        System.debug('Product productCategoriesTobeAdded insert successfull');
                    }
                    if(!productGroupingTobeAdded.isEmpty())
                    {
                        System.debug('Product productGroupingTobeAdded to be updated=>'+JSON.serialize(productGroupingTobeAdded));

                        upsert productGroupingTobeAdded;
                        System.debug('Product Grouping insert successfull');
                    }*/
               // }
            }
            dbu_RestResponseHelper.SetRestResponse(200,'OK','Data inserted successfully');
            dbu_Integration_Error_Log.createErrorLog(200,'',JSON.serialize(data),'Data inserted successfully','Part Service','Success');
        } 
        catch(System.StringException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Invalid input');
            dbu_Integration_Error_Log.createErrorLog(null,e.getMessage(),JSON.serialize(data),'','Part Service','Exception');
        }
        catch(System.QueryException e){
            dbu_RestResponseHelper.SetRestResponse(400,'BAD_REQUEST','Failed to process data');
            dbu_Integration_Error_Log.createErrorLog(null,e.getMessage(),JSON.serialize(data),'','Part Service','Exception');
        }
        catch(Exception e){ //something else happened
            dbu_RestResponseHelper.SetRestResponse(500,'BAD_REQUEST',e.getLineNumber()+ '   '+ e.getMessage());
            dbu_Integration_Error_Log.createErrorLog(null,e.getMessage(),JSON.serialize(data),'','Part Service','Exception');
        }
    }

   /* Private static ccrz__E_Product__c PopulateProduct(dbu_Integration_Parts_Request data,Map<String,ccrz__E_Product__c> existingProductsMap)
    {
        ccrz__E_Product__c product = new ccrz__E_Product__c();
        ccrz__E_Product__c existingProduct = existingProductsMap.get(data.SKU);
        
        if(existingProduct != null)
        {
            product = existingProduct;
        }
        // if (String.isNotBlank(data.MARKET_SEGMENT) && String.isNotEmpty(data.MARKET_SEGMENT)) {
        //     product.MARKET_SEGMENT__C = data.MARKET_SEGMENT; 
        // }
        if (String.isNotBlank(data.BMSInstance) && String.isNotEmpty(data.BMSInstance)) {
            product.dbu_BMS_Instance__c = data.BMSInstance; 
        }
        if (String.isNotBlank(data.AdditionalInformation) && String.isNotEmpty(data.AdditionalInformation)) {
            product.dbu_Additional_Information__c = data.AdditionalInformation; 
        }
        if (String.isNotBlank(data.ProductComment) && String.isNotEmpty(data.ProductComment)) {
            product.dbu_Product_Comment__c = data.ProductComment; 
        }
        if (String.isNotBlank(data.FullPartNumber) && String.isNotEmpty(data.FullPartNumber)) {
            product.dbu_FullPartNumber__c = data.FullPartNumber; 
        }
        
        if (String.isNotBlank(data.Name) && String.isNotEmpty(data.Name)
            && String.isNotBlank(data.ProductCode) && String.isNotEmpty(data.ProductCode))
         {
            if (data.ProductCode == 'CECO') {
                String partNumber =  data.SKU.replace('CECO', '');
                product.NAME = 'Cummins ' + data.Name + ' ' + partNumber;
                product.dbu_Part_Number__c = partNumber;
            }
            else{
                product.NAME = data.Name;
                product.dbu_Part_Number__c = data.SKU;
            }
        }

        
        if (String.isNotBlank(data.PRODUCT_VERSION) && String.isNotEmpty(data.PRODUCT_VERSION)) {
            product.PRODUCT_VERSION__C = data.PRODUCT_VERSION;
        }
        
        // if (String.isNotBlank(data.STAND_ALONE_PRODUCT) && String.isNotEmpty(data.STAND_ALONE_PRODUCT)) {
        //     product.STAND_ALONE_PRODUCT__C = data.STAND_ALONE_PRODUCT;
        // }
        
        if (String.isNotBlank(data.ALTERNATENAME) && String.isNotEmpty(data.ALTERNATENAME)) {
            product.CCRZ__ALTERNATENAME__C = data.ALTERNATENAME;
        }
        
        if (String.isNotBlank(data.LONGDESCRT) && String.isNotEmpty(data.LONGDESCRT)) {
            product.CCRZ__LONGDESCRT__C = data.LONGDESCRT;
        }
        
        if (String.isNotBlank(data.LONGDESC) && String.isNotEmpty(data.LONGDESC)) {
            product.CCRZ__LONGDESC__C = data.LONGDESC;
        }
        
        if (String.isNotBlank(data.PRODUCTTYPE) && String.isNotEmpty(data.PRODUCTTYPE)) {
            product.CCRZ__PRODUCTTYPE__C = data.PRODUCTTYPE;
        }
        
        if (String.isNotBlank(data.SKU) && String.isNotEmpty(data.SKU)) {
            product.CCRZ__SKU__C = data.SKU;
        }
        
        if (String.isNotBlank(data.SHORTDESCRT) && String.isNotEmpty(data.SHORTDESCRT)) {
            product.CCRZ__SHORTDESCRT__C = data.SHORTDESCRT;
        }
        
        if (String.isNotBlank(data.SHORTDESC) && String.isNotEmpty(data.SHORTDESC)) {
            product.CCRZ__SHORTDESC__C = data.SHORTDESC;
        }
        
        if (String.isNotBlank(data.TAXRATEID) && String.isNotEmpty(data.TAXRATEID)) {
            product.CCRZ__TAXRATEID__C = data.TAXRATEID;
        }
        
        if (String.isNotBlank(data.UNITOFMEASURE) && String.isNotEmpty(data.UNITOFMEASURE)) {
            product.CCRZ__UNITOFMEASURE__C = data.UNITOFMEASURE;
        }
        
        if (String.isNotBlank(data.EndDate) && String.isNotEmpty(data.EndDate)) {   
            product.ccrz__EndDate__c = Date.Parse(data.EndDate);
        }
        
        if (String.isNotBlank(data.StartDate) && String.isNotEmpty(data.StartDate)) {   
            product.ccrz__StartDate__c = Date.Parse(data.StartDate);
        }

        if (String.isNotBlank(data.ProductStatus) && String.isNotEmpty(data.ProductStatus)) {
            //product.ccrz__ProductStatus__c = data.ProductStatus;
            product.ccrz__ProductStatus__c = 'Released';
        }
        if (String.isNotBlank(data.ProductCode) && String.isNotEmpty(data.ProductCode)) {
            product.dbu_Product_Code__c = data.ProductCode;
        }

        if (String.isNotBlank(data.AvailabilityMessageRT) && String.isNotEmpty(data.AvailabilityMessageRT)) {
            product.ccrz__AvailabilityMessageRT__c = data.AvailabilityMessageRT;
        }

        if (String.isNotBlank(data.DistributorCode) && String.isNotEmpty(data.DistributorCode)) {
            String productLocation = getProductLocation(data.DistributorCode);

            if(String.isBlank(product.dbu_Distributor_Code__c) || String.isEmpty(product.dbu_Distributor_Code__c))
            {
                product.dbu_Distributor_Code__c = data.DistributorCode;
                product.DBU_Product_Location__c = productLocation;
            }
            else
            {
                if(!product.dbu_Distributor_Code__c.containsIgnoreCase(data.DistributorCode))
                {
                    product.dbu_Distributor_Code__c =product.dbu_Distributor_Code__c +';'+ data.DistributorCode;
                }
                if(!product.DBU_Product_Location__c.containsIgnoreCase(productLocation))
                {
                    product.DBU_Product_Location__c = product.DBU_Product_Location__c +';'+productLocation;
                }
            }
        }

        if (data.Quantityperunit != null) {
            product.ccrz__Quantityperunit__c = data.Quantityperunit;
        }

        if (data.LeadTime!=null) {
            product.ccrz__LeadTime__c = data.LeadTime;
        }

        //product.CCRZ__COOLERPAKFLAG__C = data.COOLERPAKFLAG;
        //product.CCRZ__DRYICEFLAG__C = data.DRYICEFLAG;
        //product.CCRZ__DRYICEWEIGHT__C = data.DRYICEWEIGHT;
        product.CCRZ__HAZARDOUSFLAG__C = data.HAZARDOUSFLAG;
        product.CCRZ__PRODUCTWEIGHT__C = data.PRODUCTWEIGHT;
        //product.ccrz__OvernightFlag__c = data.OvernightFlag;
        //product.ccrz__ReviewFlag__c = data.ReviewFlag;
        //product.CCRZ__SEQUENCE__C = data.SEQUENCE;
        //product.ccrz__GroundFlag__c = data.GroundFlag;
        //product.ccrz__HazardousOutside48Flag__c = data.HazardousOutside48Flag;
        //product.CCRZ__SERVICEFLAG__C = data.SERVICEFLAG;
        //product.CCRZ__SHIPSEPARATELY__C = data.SHIPSEPARATELY;
        //product.CCRZ__SHIPPEDINDIVIDUALLY__C = data.SHIPPEDINDIVIDUALLY;
        //product.CCRZ__SHIPPINGWEIGHT__C = data.SHIPPINGWEIGHT;
        //product.CCRZ__TAXABLE__C = data.TAXABLE;
        //product.ISIAMPROVISIONINGREQUIRED__C = data.ISIAMPROVISIONINGREQUIRED;
        product.dbu_Pick_Up_Only__c = data.AvailableToPickUpFlag;
        product.dbu_Available_to_ship__c = data.AvailableToShipFlag;
        product.dbu_Non_Returnable__c = data.NonReturnableFlag;
        product.dbu_Has_Core_Charge__c = data.IsCoreItem;
        product.Group_Name__c = 'Ecom';
        product.ccrz__Storefront__c = 'CSSNAStore';
        
        return product;
    }*/

    private static String getProductLocation(String distributorCode)
    {
        if(distributorCode == '56330' || distributorCode == '56270')
            return 'CA';
        else
            return 'US';
    }
    
    /*Private static List<ccrz__E_ProductMedia__c> PopulateProductMedia(ccrz__E_Product__c product,
                                                                        dbu_Integration_Parts_Request data,
                                                                        Map<String,ccrz__E_ProductMedia__c> existingMediaImageMap)
    {
        List<ccrz__E_ProductMedia__c> mediaList = new List<ccrz__E_ProductMedia__c>();
        
        if (data.Images.size() >0 ) {
            for(dbu_Integration_Parts_ProductImages image:data.Images)
            {
                ccrz__E_ProductMedia__c mediaImage = new ccrz__E_ProductMedia__c();
                ccrz__E_ProductMedia__c existingMedia = existingMediaImageMap.get(product.ID+image.URL);

                if(existingMedia != null)
                {
                    mediaImage = existingMedia;
                }
                else {
                    mediaImage.ccrz__Product__c =  product.ID;
                    mediaImage.ccrz__URI__c = image.URL;
                    if(image.ContentType == 'image/png')
                    mediaImage.ccrz__MediaType__c = 'Product Image';
                    else {
                    mediaImage.ccrz__MediaType__c = 'Media';
                    }
                }
                
                mediaList.add(mediaImage);
            }
        }
        /*if (String.isNotBlank(data.URIMedia) && String.isNotEmpty(data.URIMedia)) {

            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            ccrz__E_ProductMedia__c existingMedia = existingMediaVideoMap.get(product.ID);

            if(existingMedia != null)
            {
                media = existingMedia;
            }
            else {
                media.ccrz__Product__c = product.ID;
            }
            media.ccrz__URI__c = data.URIMedia;
            media.ccrz__MediaType__c = 'Media';
            media.ccrz__StartDate__c = Date.Parse(data.StartDate);
            media.ccrz__EndDate__c = Date.Parse(data.EndDate);
            media.ccrz__Sequence__c = data.SEQUENCE;

            mediaList.add(media);
        }

        return mediaList;
    }

    Private static List<ccrz__E_ProductSpec__c> PopulateProductSpec(ccrz__E_Product__c product,
                                                                    dbu_Integration_Parts_Request data,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionLengthMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionHeightMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionWidthMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingShipmentDimensionWeightMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionLengthMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionHeightMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionWidthMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingSpecDimensionWeightMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingSpecValueUOMMap,
                                                                    //Map<String,ccrz__E_ProductSpec__c> existingSpecValueSystemMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingSpecValueCapacityMap,
                                                                    String ShipmentDimensionLengthId,
                                                                    String ShipmentDimensionHeightId,
                                                                    String ShipmentDimensionWidthId,
                                                                    String ShipmentDimensionWeightId,
                                                                    String SpecDimensionLengthId,
                                                                    String SpecDimensionHeightId,
                                                                    String SpecDimensionWidthId,
                                                                    String SpecDimensionWeightId,
                                                                    String SpecUOMId,
                                                                    String SpecCapacityId,
                                                                    Map<String,ccrz__E_Spec__c> existingSpecsMap,
                                                                    Map<String,ccrz__E_ProductSpec__c> existingProductSpecsMap)
                                                                    //String SpecSystemId)
    {
        List<ccrz__E_ProductSpec__c> spec = new List<ccrz__E_ProductSpec__c>();
        if (String.isNotBlank(data.ShipmentDimensionLength) && String.isNotEmpty(data.ShipmentDimensionLength)) {
            ccrz__E_ProductSpec__c specDiemension = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingShipmentDimensionLengthMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specDiemension = exitingSpec;
            }
            else{
                specDiemension.ccrz__Product__c = product.ID;
                specDiemension.ccrz__Spec__c = ShipmentDimensionLengthId;
            }
            specDiemension.ccrz__SpecValue__c = data.ShipmentDimensionLength;

            spec.add(specDiemension);
        }
        if (String.isNotBlank(data.ShipmentDimensionHeight) && String.isNotEmpty(data.ShipmentDimensionHeight)) {
            ccrz__E_ProductSpec__c specWeight = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingShipmentDimensionHeightMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specWeight = exitingSpec;
            }else{
                specWeight.ccrz__Product__c = product.ID;
                specWeight.ccrz__Spec__c = ShipmentDimensionHeightId;
            }
            specWeight.ccrz__SpecValue__c = data.ShipmentDimensionHeight;

            spec.add(specWeight);
        }
        if (String.isNotBlank(data.ShipmentDimensionWidth) && String.isNotEmpty(data.ShipmentDimensionWidth)) {
            ccrz__E_ProductSpec__c specWeight = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingShipmentDimensionWidthMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specWeight = exitingSpec;
            }
            else {
                specWeight.ccrz__Product__c = product.ID;
                specWeight.ccrz__Spec__c = ShipmentDimensionWidthId;
            }
            specWeight.ccrz__SpecValue__c = data.ShipmentDimensionWidth;

            spec.add(specWeight);
        }
        if (String.isNotBlank(data.ShipmentDimensionWeight) && String.isNotEmpty(data.ShipmentDimensionWeight)) {
            ccrz__E_ProductSpec__c specWeight = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingShipmentDimensionWeightMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specWeight = exitingSpec;
            }
            else {
            specWeight.ccrz__Product__c = product.ID;
            specWeight.ccrz__Spec__c = ShipmentDimensionWeightId ;

            }
            specWeight.ccrz__SpecValue__c = data.ShipmentDimensionWeight;

            spec.add(specWeight);
        }
        if (String.isNotBlank(data.SpecValueDimensionLength) && String.isNotEmpty(data.SpecValueDimensionLength)) {
            ccrz__E_ProductSpec__c specDiemension = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingSpecDimensionLengthMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specDiemension = exitingSpec;
            }
            else {
                specDiemension.ccrz__Product__c = product.ID;
                specDiemension.ccrz__Spec__c = SpecDimensionLengthId;
            }
            specDiemension.ccrz__SpecValue__c = data.SpecValueDimensionLength;

            spec.add(specDiemension);
        }
        if (String.isNotBlank(data.SpecValueDimensionHeight) && String.isNotEmpty(data.SpecValueDimensionHeight)) {
            ccrz__E_ProductSpec__c specWeight = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingSpecDimensionHeightMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specWeight = exitingSpec;
            }
            else {
            specWeight.ccrz__Product__c = product.ID;
            specWeight.ccrz__Spec__c = SpecDimensionHeightId;
            }
            specWeight.ccrz__SpecValue__c = data.SpecValueDimensionHeight;
            spec.add(specWeight);
        }
        if (String.isNotBlank(data.SpecValueDimensionWidth) && String.isNotEmpty(data.SpecValueDimensionWidth)) {
            ccrz__E_ProductSpec__c specWeight = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingSpecDimensionWidthMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specWeight = exitingSpec;
            }
            else {
                specWeight.ccrz__Product__c = product.ID;
                specWeight.ccrz__Spec__c = SpecDimensionWidthId;
            }
            specWeight.ccrz__SpecValue__c = data.SpecValueDimensionWidth;
            spec.add(specWeight);
        }
        if (String.isNotBlank(data.SpecValueDimensionWeight) && String.isNotEmpty(data.SpecValueDimensionWeight)) {
            ccrz__E_ProductSpec__c specWeight = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingSpecDimensionWeightMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specWeight = exitingSpec;
            }
            else {
                specWeight.ccrz__Product__c = product.ID;
                specWeight.ccrz__Spec__c = SpecDimensionWeightId;
            }
            specWeight.ccrz__SpecValue__c = data.SpecValueDimensionWeight;
            spec.add(specWeight);
        }
        if (String.isNotBlank(data.SpecValueUOM) && String.isNotEmpty(data.SpecValueUOM)) {
            ccrz__E_ProductSpec__c specUOM = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingSpecValueUOMMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specUOM = exitingSpec;
            }
            else {
                specUOM.ccrz__Product__c = product.ID;
                specUOM.ccrz__Spec__c = SpecUOMId;
            }
            specUOM.ccrz__SpecValue__c = data.SpecValueUOM;

            spec.add(specUOM);
        }
        if (String.isNotBlank(data.SpecValueCapacity) && String.isNotEmpty(data.SpecValueCapacity)) {
            ccrz__E_ProductSpec__c specCapacity = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingSpec = existingSpecValueCapacityMap.get(product.ID);
            
            if(exitingSpec != null)
            {
                specCapacity = exitingSpec;
            }
            else {
            specCapacity.ccrz__Product__c = product.ID;
            specCapacity.ccrz__Spec__c = SpecCapacityId;
            }
            specCapacity.ccrz__SpecValue__c = data.SpecValueCapacity;

            spec.add(specCapacity);
        }
        for (dbu_Integration_Parts_Specs productSpec : data.Specs) {
            ccrz__E_ProductSpec__c specToBeAdded = new ccrz__E_ProductSpec__c();
            ccrz__E_ProductSpec__c exitingProductSpec = existingProductSpecsMap.get(product.ID+productSpec.Key);
            ccrz__E_Spec__c exitingSpec = existingSpecsMap.get(productSpec.Key);
            if(exitingProductSpec != null)
            {
                specToBeAdded = exitingProductSpec;
            }
            else {
                specToBeAdded.ccrz__Product__c = product.ID;
                specToBeAdded.ccrz__Spec__c =  exitingSpec.Id;
            }
            specToBeAdded.ccrz__SpecValue__c = productSpec.Value;
            spec.add(specToBeAdded);
        }
        return spec;
    }
*/
    Private static List<ccrz__E_PriceListItem__c> PopulateProductPrice(ccrz__E_Product__c product,
                                                                        dbu_Integration_Parts_Request data,
                                                                        Map<String,ccrz__E_PriceListItem__c> existingPricesMap, 
                                                                        String priceListUS,
                                                                        String priceListCA)
    {
        List<ccrz__E_PriceListItem__c> prices = new List<ccrz__E_PriceListItem__c>();

        if(data.Price ==null)
        {
            return prices;
        }

        ccrz__E_PriceListItem__c price = new ccrz__E_PriceListItem__c();

        String productLocation = getProductLocation(data.distributorCode);
        String mapKey = '';
        if(productLocation =='US')
            mapKey = product.ID + '-'+ priceListUS;
        if(productLocation =='CA')
            mapKey = product.ID + '-'+priceListCA;

        ccrz__E_PriceListItem__c existingPrice = existingPricesMap.get(mapKey);

        if(existingPrice != null )
        {
            price = existingPrice;
            
            system.debug('@@The Existing Price'+data.Price);
            system.debug('@@The Existing Discount'+price.dbu_Discount_Type__c);
            system.debug('@@The Existing Discount'+price.dbu_Discount_Amount__c);
            
            if(price.dbu_Discount_Type__c == 'Absolute')
            {
                price.ccrz__Price__c = (data.Price - price.dbu_Discount_Amount__c);
            }
            if(price.dbu_Discount_Type__c == 'Percentage')
            {
                price.ccrz__Price__c = ((data.Price/100)*price.dbu_Discount_Amount__c);
            }
            if(price.dbu_Discount_Type__c ==null){
             price.ccrz__Price__c = data.Price;}
        }
        else {
            
            if(productLocation == 'US')
            {
                price.CurrencyIsoCode = 'USD';
                price.ccrz__Pricelist__c = priceListUS;
            }
            if(productLocation == 'CA')
            {
                price.ccrz__Pricelist__c = priceListCA;
                price.CurrencyIsoCode = 'CAD';
            }
            price.ccrz__Product__c = product.ID;
            price.ccrz__Price__c = data.Price;
            price.dbu_Discount_Amount__c = 0;
            price.dbu_Discount_Type__c = 'Absolute';
        }
        
        //price.ccrz__Price__c = data.Price;
        price.dbu_Original_Price__c = data.Price;
        price.ccrz__PricingTiers__c = data.PricingTiers;

        prices.add(price);
       
        return prices;
    }

    private static List<ccrz__E_RelatedProduct__c> PopulateSupersedeProduct(ccrz__E_Product__c product,
                                                                            dbu_Integration_Parts_Request data,
                                                                            Map<String,ccrz__E_RelatedProduct__c> existingSupersedProductMap)
    {   List<string> supersededIDs = new List<string>();
        Set<string> supersededsetID = new Set<string>();  
        List<ccrz__E_RelatedProduct__c> supersedeProducts = new List<ccrz__E_RelatedProduct__c>();
         for(String item:data.SupersedeProduct){
              List<String> lstAlpha = item.split(',');
              System.debug('@@@'+lstAlpha);
               for (string str :lstAlpha){
              system.debug('@@The Id'+str.SubStringBefore('|'));
              system.debug('@@The Id'+str.replace('|',''));
              str =str.replace('|','');
              if(supersededsetID.add(str)){
              supersededIDs.add(str);}
              
              }
          }
          
        List<ccrz__E_Product__c> relatedProducts = [SELECT CCRZ__SKU__C,Id FROM ccrz__E_Product__c WHERE CCRZ__SKU__C IN:supersededIDs];
        Map<String,ccrz__E_Product__c> relatedProductsMap = new Map<String,ccrz__E_Product__c>();
        if(relatedProducts.size()>0){
        for (ccrz__E_Product__c p : relatedProducts) {
            relatedProductsMap.put(p.CCRZ__SKU__C,p);
        }
        System.debug('existingSupersedProductMap=>'+existingSupersedProductMap);
        for(String item:supersededIDs)
        {
            ccrz__E_RelatedProduct__c supersedeProduct = new ccrz__E_RelatedProduct__c();
            ccrz__E_RelatedProduct__c existingSupersedeProduct = existingSupersedProductMap.get(product.Id+item);
            System.debug('product.Id+item=>'+product.Id+item);
            System.debug('existingSupersedeProduct=>'+existingSupersedeProduct);
            ccrz__E_Product__c relatedProduct =  relatedProductsMap.get(item);
            System.debug('relatedProduct=>'+relatedProduct);

            if(existingSupersedeProduct == null && relatedProduct != null) //Ramesh CHG0111841
            {
                supersedeProduct.ccrz__Product__c = product.Id;
                supersedeProduct.ccrz__RelatedProduct__c = relatedProduct.Id;
                supersedeProduct.ccrz__RelatedProductId__c = relatedProduct.Id;
                supersedeProduct.ccrz__RelatedProductType__c = 'SupersededProduct';
                supersedeProducts.add(supersedeProduct);}
        }
         return supersedeProducts;
         } 
         else{
         return supersedeProducts;   
         }
    }

  /*  private static List<ccrz__E_RelatedProduct__c> PopulateReconEquivalentPartNumber(ccrz__E_Product__c product,
                                                                                    dbu_Integration_Parts_Request data,
                                                                                    Map<String,ccrz__E_RelatedProduct__c> existingReconEquivalentMap)
    {
        List<ccrz__E_RelatedProduct__c> reconEquivalentPartNumbers = new List<ccrz__E_RelatedProduct__c>();
        List<ccrz__E_Product__c> relatedProducts = [SELECT CCRZ__SKU__C,Id FROM ccrz__E_Product__c WHERE CCRZ__SKU__C IN:data.SupersedeProduct];
        Map<String,ccrz__E_Product__c> relatedProductsMap = new Map<String,ccrz__E_Product__c>();
        for (ccrz__E_Product__c p : relatedProducts) {
            relatedProductsMap.put(p.CCRZ__SKU__C,p);
        }
        //System.debug('existingSupersedProductMap=>'+existingSupersedProductMap);

        for(String item:data.ReconEquivalentPartNumber)
        {
            ccrz__E_RelatedProduct__c reconEquivalentProduct = new ccrz__E_RelatedProduct__c();
            ccrz__E_RelatedProduct__c existingReconEquivalentProduct = existingReconEquivalentMap.get(product.Id);
            ccrz__E_Product__c relatedProduct =  relatedProductsMap.get(item);
            if(existingReconEquivalentProduct == null)
            {
                reconEquivalentProduct.ccrz__Product__c = product.Id;
                reconEquivalentProduct.ccrz__RelatedProduct__c = relatedProduct.Id;
                reconEquivalentProduct.ccrz__RelatedProductId__c = relatedProduct.Id;
                reconEquivalentProduct.ccrz__RelatedProductType__c = 'ReconEquivalent';

            reconEquivalentPartNumbers.add(reconEquivalentProduct);
            }

        }
        
        return reconEquivalentPartNumbers;
    }

    
    private static List<ccrz__E_RelatedProduct__c> PopulateProductGrouping(ccrz__E_Product__c product,
                                                                                    dbu_Integration_Parts_Request data,
                                                                                    Map<String,ccrz__E_RelatedProduct__c> existingProductGroupingMap)
    {
        List<ccrz__E_RelatedProduct__c> reconEquivalentPartNumbers = new List<ccrz__E_RelatedProduct__c>();
        
        for(String item:data.ProductGrouping)
        {
            ccrz__E_RelatedProduct__c productGrouping = new ccrz__E_RelatedProduct__c();
            ccrz__E_RelatedProduct__c existingsproductGrouping = existingProductGroupingMap.get(product.Id);
            if(existingsproductGrouping != null)
            {
                productGrouping = existingsproductGrouping;
            }
            else {
                productGrouping.ccrz__Product__c = product.Id;
            }
            productGrouping.ccrz__RelatedProductId__c = item;
            productGrouping.ccrz__RelatedProductType__c = 'ProductGroup';

            reconEquivalentPartNumbers.add(productGrouping);
        }
        
        return reconEquivalentPartNumbers;
    }
    
    
    private static List<ccrz__E_ProductCategory__c> PopulateProductCategories(ccrz__E_Product__c product,
                                                                            dbu_Integration_Parts_Request data,
                                                                            Map<String,ccrz__E_Category__c> existingCategoriesMap,
                                                                            Map<String,ccrz__E_ProductCategory__c> existingProductCategoriesMap)
    {
        List<ccrz__E_ProductCategory__c> productCategories = new List<ccrz__E_ProductCategory__c>();
        System.debug('existingCategoriesMap=>'+JSON.serialize(existingCategoriesMap));
        for(String productGroup:data.ProductGrouping)
        {
            ccrz__E_Category__c category = existingCategoriesMap.get(productGroup.toLowerCase());
            System.debug('category=>'+JSON.serialize(category));
            ccrz__E_ProductCategory__c existingProductGroup = existingProductCategoriesMap.get(product.ID+productGroup.toLowerCase());

            if(existingProductGroup == null)
            {
                ccrz__E_ProductCategory__c productGroupToBeAdded = new ccrz__E_ProductCategory__c();
                productGroupToBeAdded.ccrz__Product__c = product.ID;
                productGroupToBeAdded.ccrz__Category__c = category.Id;
                productGroupToBeAdded.ccrz__StartDate__c = date.today();
                //productGroupToBeAdded.ccrz__EndDate__c = date.valueOf(‘2099–12–31’);

                productCategories.add(productGroupToBeAdded);
            }
        }

        return productCategories;
    } */
}