/**********************************************************************
Name: dbu_Integration_Parts_Test
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    Test class for REST API Service to import bulk data from Parts.Cummins.Com 

======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Ranadip Jha         14/12/2020                 INITIAL DEVELOPMENT                    
2.0    Sandeep             7/2/2020                   PRICE UPDATE
***********************************************************************/

@isTest
public class dbu_Integration_Parts_Test {
    
    public static ccrz__E_Spec__c createSpec(String specName){
        ccrz__E_Spec__c objSpec = new ccrz__E_Spec__c();
        objSpec.Name = specName;
        objSpec.ccrz__Desc__c = 'test';
        objSpec.ccrz__UseForFilter__c = true;
        objSpec.ccrz__FilterType__c = 'Checkbox';
        objSpec.imageText__c = '\\';
        objSpec.ccrz__IsComparable__c = false;
        objSpec.ccrz__IsVisibleInCatalog__c = true;
        objSpec.ccrz__Locale__c = 'en_US';
        objSpec.ccrz__SelectType__c = 'Single';
        objSpec.ccrz__Sequence__c = 1;
        objSpec.ccrz__SpecGroup__c = 'General';
        return objSpec;
    }
    
    public static ccrz__E_ProductSpec__c createProductSpec(Id specId, Id pId, String value){
        ccrz__E_ProductSpec__c specs = new ccrz__E_ProductSpec__c();
        specs.ccrz__SpecValue__c = value;
        specs.ccrz__Spec__c = specId;
        specs.ccrz__Product__c = pId;
        return specs;
    }
    public static ccrz__E_Product__c createProduct(String Name,String sku)
    {
        ccrz__E_Product__c prodObj = new ccrz__E_Product__c();
        prodObj.Name = Name;
        prodObj.ccrz__SKU__c = sku;
        prodObj.ccrz__Quantityperunit__c = 1.00;
        prodObj.ccrz__ProductType__c = 'Product';
        prodObj.ccrz__UnitOfMeasure__c = 'Each';
        prodObj.ccrz__ProductIndexStatus__c = 'Not Current';
        prodObj.ccrz__Storefront__c = 'CSSNAStore';
        prodObj.ccrz__ProductStatus__c = 'Released';
        prodObj.Group_Name__c = 'Ecom';
        prodObj.dbu_Product_Status__c = 'In Stock';
        prodObj.ccrz__InventoryType__c = 'STANDARD';
        prodObj.dbu_BMS_Instance__c ='BMS';
        prodObj.dbu_Additional_Information__c = 'Test additional information';
        prodObj.dbu_Product_Comment__c = 'Test';
        return prodObj;
    }
    
    @isTest
    static void CallServicePass(){
        
        List<String> superSetProductIds = new List<String>();
        List<String> reconEquivalentPartNumberList = new List<String>();
        superSetProductIds.add('1234567');
        reconEquivalentPartNumberList.add('1234567');
        
        ccrz__E_Product__c productObj = new ccrz__E_Product__c();
        productObj.Name = 'Test DBU 3684450PUMP,WATER';
        productObj.ccrz__SKU__c = '1234567';
        productObj.ccrz__ProductStatus__c = 'Released';
        productObj.ccrz__Storefront__c = 'CSSNAStore';
        productObj.Group_Name__c = 'Ecom';
        productObj.ccrz__ProductType__c = 'Product';
        Insert  productObj; 
        
        ccrz__E_Product__c productObj1 = new ccrz__E_Product__c();
        productObj1.Name = 'Test Product2';
        productObj1.ccrz__SKU__c = 'Test Sku2';
        productObj1.ccrz__ProductStatus__c = 'Released';
        productObj1.ccrz__Storefront__c = 'CSSNAStore';
        productObj1.Group_Name__c = 'Ecom';
        productObj1.ccrz__ProductType__c = 'Product';
        Insert  productObj1; 
        
        
        ccrz__E_ProductMedia__c productMedia = new ccrz__E_ProductMedia__c();
        productMedia.ccrz__Product__c= productObj.Id;
        productMedia.ccrz__Enabled__c= True;
        productMedia.ccrz__EndDate__c = system.today()+90;
        productMedia.ccrz__StartDate__c= system.today()-1;
        productMedia.ccrz__MediaType__c='Product Image';
        productMedia.ccrz__ProductMediaSource__c='URI';
        productMedia.ccrz__URI__c='https://cssna-parts.gdc-rad.com/3684200.png';
        productMedia.ccrz__Locale__c='en_US';
        insert productMedia;
        
        ccrz__E_RelatedProduct__c relProduct  = new ccrz__E_RelatedProduct__c();
        relProduct.ccrz__RelatedProductType__c = 'SupersededProduct';
        relProduct.ccrz__EndDate__c = Date.parse('6/20/2099');
        relProduct.ccrz__StartDate__c = Date.parse('12/31/2019');
        relProduct.ccrz__Sequence__c = 600;
        relProduct.ccrz__RelatedProduct__c = productObj1.Id;
        relProduct.ccrz__Product__c = productObj.Id;
        insert relProduct;
        
        
        ccrz__E_RelatedProduct__c relProduct1  = new ccrz__E_RelatedProduct__c();
        relProduct1.ccrz__RelatedProductType__c = 'ReconEquivalent';
        relProduct1.ccrz__EndDate__c = Date.parse('6/20/2099');
        relProduct1.ccrz__StartDate__c = Date.parse('12/31/2019');
        relProduct1.ccrz__Sequence__c = 600;
        relProduct1.ccrz__RelatedProduct__c = productObj1.Id;
        relProduct1.ccrz__Product__c = productObj.Id;
        insert relProduct1;
        
        List<ccrz__E_Spec__c> specs = new List<ccrz__E_Spec__c>();
        ccrz__E_Spec__c specObjDimension =  createSpec('Dimension');
        specs.add(specObjDimension);
        
        ccrz__E_Spec__c specObjUOM =  createSpec('UOM');
        specs.add(specObjUOM);
        
        ccrz__E_Spec__c specObjLength =  createSpec('Shipment Length');
        specs.add(specObjLength);
        
        ccrz__E_Spec__c specWeight =  createSpec('Weight');
        specs.add(specWeight);
        
        ccrz__E_Spec__c specObjCapacity =  createSpec('Capacity');
        specs.add(specObjCapacity);
        
        ccrz__E_Spec__c specObjHeight =  createSpec('Shipment Height');
        specs.add(specObjHeight);
        
        ccrz__E_Spec__c specObjWidth =  createSpec('Shipment Width');
        specs.add(specObjWidth);
        
        ccrz__E_Spec__c specObjWeight =  createSpec('Shipment Weight');
        specs.add(specObjWeight);
        
        ccrz__E_Spec__c specObjItemHeight =  createSpec('Item Height');
        specs.add(specObjItemHeight);
        
        ccrz__E_Spec__c specObjItemLength =  createSpec('Item Length');
        specs.add(specObjItemLength);
        
        ccrz__E_Spec__c specObjItemWidth =  createSpec('Item Width');
        specs.add(specObjItemWidth);
        
        ccrz__E_Spec__c specObjItemWeight =  createSpec('Item Weight');
        specs.add(specObjItemWeight);
        Insert specs;
        
        ccrz__E_ProductSpec__c productSpecDimension =  createProductSpec(specObjDimension.Id, productObj.Id, '1.18 in');
        insert productSpecDimension;
        
        ccrz__E_ProductSpec__c productSpecUOM =  createProductSpec(specObjUOM.Id, productObj.Id, '14.61 in');
        insert productSpecUOM;
        
        ccrz__E_ProductSpec__c productSpecLength =  createProductSpec(specObjLength.Id, productObj.Id, '14.61 in');
        insert productSpecLength;
        
        ccrz__E_ProductSpec__c productSpecWeight =  createProductSpec(specWeight.Id, productObj.Id, '4.61 ounces');
        insert productSpecWeight;
        
        ccrz__E_ProductSpec__c productSpecCapacity =  createProductSpec(specObjCapacity.Id, productObj.Id, '7.0');
        insert productSpecCapacity;
        
        ccrz__E_ProductSpec__c productSpecHeight =  createProductSpec(specObjHeight.Id, productObj.Id, '7.0 in');
        insert productSpecHeight;
        
        ccrz__E_ProductSpec__c productSpecWidth =  createProductSpec(specObjWidth.Id, productObj.Id, '7.0 in');
        insert productSpecWidth;
        
        ccrz__E_ProductSpec__c productSpecObjWeight =  createProductSpec(specObjWeight.Id, productObj.Id, '7.0 in');
        insert productSpecObjWeight;
        
        ccrz__E_ProductSpec__c productSpecItemHeight =  createProductSpec(specObjItemHeight.Id, productObj.Id, '7.0 in');
        insert productSpecItemHeight;
        
        ccrz__E_ProductSpec__c productSpecItemLength =  createProductSpec(specObjItemLength.Id, productObj.Id, '7.0 in');
        insert productSpecItemLength;
        
        ccrz__E_ProductSpec__c productSpecItemWidth =  createProductSpec(specObjItemWidth.Id, productObj.Id, '7.0 in');
        insert productSpecItemWidth;
        
        ccrz__E_ProductSpec__c productSpecItemWeight =  createProductSpec(specObjItemWeight.Id, productObj.Id, '7.0 in');
        insert productSpecItemWeight;
        
        ccrz__E_Category__c cat = new ccrz__E_Category__c();
        cat.Name = 'UnCategorized';
        cat.Storefront__c='CSSNAStore' ;
        cat.ccrz__CategoryID__c = 'UnffffCategorized';
        cat.ccrz__DataId__c = 'UnffffddCategorized';
        insert cat;
        
        ccrz__E_ProductCategory__c productCat = new ccrz__E_ProductCategory__c();
        productCat.ccrz__Category__c = cat.id;
        productCat.ccrz__Product__c = productObj.id;
        insert productCat;
        
        List<ccrz__E_PriceList__c> lstPL = new List<ccrz__E_PriceList__c>();
        ccrz__E_PriceList__c objPL = new ccrz__E_PriceList__c();
        objPL.name = 'CSSNA USD Pricelist';
        lstPL.add(objPL);
        
        ccrz__E_PriceList__c objPL2 = new ccrz__E_PriceList__c();
        objPL2.name = 'CSSNA CAD Pricelist';
        lstPL.add(objPL2);
        insert lstPL;
        
        ccrz__E_PriceListItem__c objPriceListItem   =   new ccrz__E_PriceListItem__c();
        objPriceListItem.ccrz__Pricelist__c         =   objPL.Id;
        objPriceListItem.ccrz__StartDate__c         =   Date.parse('6/20/2019');
        objPriceListItem.ccrz__EndDate__c           =   Date.parse('12/31/2099');
        objPriceListItem.dbu_Original_Price__c      =   60.00;
        objPriceListItem.ccrz__Price__c             =   50;
        objPriceListItem.ccrz__Product__c           =   productObj.id;
        insert objPriceListItem;
        
        ccrz__E_PriceListItem__c objPriceListItem2  =   new ccrz__E_PriceListItem__c();
        objPriceListItem2.ccrz__Pricelist__c            =   objPL2.Id;
        objPriceListItem2.ccrz__StartDate__c            =   Date.parse('6/20/2019');
        objPriceListItem2.ccrz__EndDate__c          =   Date.parse('12/31/2099');
        objPriceListItem2.dbu_Original_Price__c     =   60.00;
        objPriceListItem2.ccrz__Price__c                =   50;
        objPriceListItem2.ccrz__Product__c          =   productObj.id;
        
        insert objPriceListItem2;
        
        
        List<ccrz__E_RelatedProductGroup__c> lstPG = new List<ccrz__E_RelatedProductGroup__c>();
        List<String> relIds = new List<String>();
        
        ccrz__E_RelatedProductGroup__c objPG1 = new ccrz__E_RelatedProductGroup__c();
        objPG1.name = 'SupersededProduct';
        lstPG.add(objPG1);
        
        ccrz__E_RelatedProductGroup__c objPG2 = new ccrz__E_RelatedProductGroup__c();
        objPG2.name = 'ReconEquivalent';
        lstPG.add(objPG2);
        
        ccrz__E_RelatedProductGroup__c objPG3 = new ccrz__E_RelatedProductGroup__c();
        objPG3.name = 'ProductGroup';
        lstPG.add(objPG3); 
        
        insert lstPG;
        for(ccrz__E_RelatedProductGroup__c obj : lstPG){
            relIds.add(obj.id);
        }
        
        //CSS_Integration_Details__c details = new CSS_Integration_Details__c(Name = 'dbu_productPriceUpdate'); //sk
        //insert details; //sk
            
            
        List<dbu_Integration_Parts_Specs> partsSpecList = new List<dbu_Integration_Parts_Specs>();
        
        dbu_Integration_Parts_Specs partsSpecDimension = new dbu_Integration_Parts_Specs();
        partsSpecDimension.Key = 'Dimension';
        partsSpecDimension.Value = '1.18 in';
        partsSpecList.add(partsSpecDimension);
        
        dbu_Integration_Parts_Specs partsSpecUOM = new dbu_Integration_Parts_Specs();
        partsSpecUOM.Key = 'UOM';
        partsSpecUOM.Value = '14.61 in';
        partsSpecList.add(partsSpecUOM);
        
        dbu_Integration_Parts_Specs partsSpecShipmentLength = new dbu_Integration_Parts_Specs();
        partsSpecShipmentLength.Key = 'Shipment Length';
        partsSpecShipmentLength.Value = '14.61 in';
        partsSpecList.add(partsSpecShipmentLength);
        
        dbu_Integration_Parts_Specs partsSpecWeight = new dbu_Integration_Parts_Specs();
        partsSpecWeight.Key = 'Weight';
        partsSpecWeight.Value = '4.61 ounces';
        partsSpecList.add(partsSpecWeight);
        
        dbu_Integration_Parts_Specs partsSpecCapacity = new dbu_Integration_Parts_Specs();
        partsSpecCapacity.Key = 'Capacity';
        partsSpecCapacity.Value = '7.0';
        partsSpecList.add(partsSpecCapacity);
        
        dbu_Integration_Parts_Specs partsSpecShipmentHeight = new dbu_Integration_Parts_Specs();
        partsSpecShipmentHeight.Key = 'Shipment Height';
        partsSpecShipmentHeight.Value = '7.0 in';
        partsSpecList.add(partsSpecShipmentHeight);
        
        dbu_Integration_Parts_Specs partsSpecShipmentWidth = new dbu_Integration_Parts_Specs();
        partsSpecShipmentWidth.Key = 'Shipment Width';
        partsSpecShipmentWidth.Value = '7.0 in';
        partsSpecList.add(partsSpecShipmentWidth);
        
        dbu_Integration_Parts_Specs partsSpecShipmentWeight = new dbu_Integration_Parts_Specs();
        partsSpecShipmentWeight.Key = 'Shipment Weight';
        partsSpecShipmentWeight.Value = '7.0 in';
        partsSpecList.add(partsSpecShipmentWeight);
        
        dbu_Integration_Parts_Specs partsSpecItemHeight = new dbu_Integration_Parts_Specs();
        partsSpecItemHeight.Key = 'Item Height';
        partsSpecItemHeight.Value = '7.0 in';
        partsSpecList.add(partsSpecItemHeight);
        
        dbu_Integration_Parts_Specs partsSpecItemLength = new dbu_Integration_Parts_Specs();
        partsSpecItemLength.Key = 'Item Length';
        partsSpecItemLength.Value = '7.0 in';
        partsSpecList.add(partsSpecItemLength);
        
        dbu_Integration_Parts_Specs partsSpecItemWidth = new dbu_Integration_Parts_Specs();
        partsSpecItemWidth.Key = 'Item Width';
        partsSpecItemWidth.Value = '7.0 in';
        partsSpecList.add(partsSpecItemWidth);
        
        dbu_Integration_Parts_Specs partsSpecItemWeight = new dbu_Integration_Parts_Specs();
        partsSpecItemWeight.Key = 'Item Weight';
        partsSpecItemWeight.Value = '7.0 in';
        partsSpecList.add(partsSpecItemWeight);
        
        List<dbu_Integration_Parts_ProductImages> partImagesList = new List<dbu_Integration_Parts_ProductImages>();
        dbu_Integration_Parts_ProductImages partImages = new dbu_Integration_Parts_ProductImages();
        partImages.URL = 'http://d7g69anyp3s9e.cloudfront.net/highlight/AF55814.jpg';
        partImages.ContentType = '';
        
        partImagesList.add(partImages);
        
        List<dbu_Integration_Parts_Request> requestObjList = new List<dbu_Integration_Parts_Request>();
        dbu_Integration_Parts_Request request = new dbu_Integration_Parts_Request();
        
        request.Price = 500;
        request.PricingTiers = '';
        request.COOLERPAKFLAG = true;
        request.DRYICEFLAG = true;
        request.SERVICEFLAG = true;
        request.HAZARDOUSFLAG = true;
        request.SHIPSEPARATELY = true;
        request.SHIPPEDINDIVIDUALLY = true;
        request.GroundFlag = true;
        request.HazardousOutside48Flag = true;
        request.OvernightFlag = true;
        request.ReviewFlag = true;
        request.TAXABLE = true;
        request.ISIAMPROVISIONINGREQUIRED = true;
        request.AvailableToPickUpFlag = true;
        request.AvailableToShipFlag = true;
        request.NonReturnableFlag = true;
        request.IsCoreItem = false;
        request.LeadTime = 10.0;
        request.DRYICEWEIGHT=10.0;
        request.SEQUENCE = 0.0;
        request.PRODUCTWEIGHT = 10.0;
        request.SHIPPINGWEIGHT=10.0;
        request.Quantityperunit = 10.0;
        request.EndDate = '01/01/2020';
        request.StartDate = '01/01/2020';
        request.LONGDESCRT = 'Product Long Description with Rich Text';
        request.LONGDESC = 'Product Long Description';
        request.PRODUCTTYPE = 'Kit';
        request.SKU = '1234567';
        request.MARKET_SEGMENT = 'MIN';
        request.NAME = 'Test DBU 3684450PUMP,WATER';
        request.PRODUCT_VERSION = 'My Version';
        request.STAND_ALONE_PRODUCT = 'Subscription';
        request.ALTERNATENAME = 'My Powerful Engine';
        request.SHORTDESCRT = 'Product Short description with rich text';
        request.SHORTDESC = 'Product Short description';
        request.TAXRATEID = 'product tax rate id';
        request.UNITOFMEASURE = 'Each';
        request.ProductStatus = 'Released';
        request.AvailabilityMessageRT = 'Product will be shipped in 5-7 business days';   
        request.ProductCode ='CECO';
        request.ProductComment = 'Test';
        request.AdditionalInformation = 'Test additional information';
        request.SpecValueDimensionLength = '5.0 in';
        request.SpecValueDimensionHeight = '4.0 in';
        request.SpecValueDimensionWidth = '3.0 in';
        request.SpecValueDimensionWeight = '1 kg';
        request.ShipmentDimensionLength = '7.0 in';
        request.ShipmentDimensionHeight = '7.0 in';
        request.ShipmentDimensionWidth = '7.0 in';
        request.ShipmentDimensionWeight = '7.0 in';
        request.BMSInstance = 'BMS';
        request.DistributorCode = '123456700';
        request.FullPartNumber = 'Test 123';
        request.Images = partImagesList;
        request.Specs = partsSpecList;
        request.SupersedeProduct = superSetProductIds;
        request.ReconEquivalentPartNumber = reconEquivalentPartNumberList;
        request.ProductGrouping = relIds;
        request.SpecValueUOM = 'Items';
        request.SpecValueCapacity = '200 Hp';
        
        String myJSON = JSON.serialize(request);
        RestRequest restRequest = new RestRequest();
        RestResponse restResponse = new RestResponse();
        
        restRequest.requestUri ='/services/apexrest/DBU_Integration_Parts/';
        restRequest.httpMethod = 'POST';
        restRequest.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = restRequest;
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        requestObjList.add(request);
        
        
        Test.startTest();
        dbu_Integration_Parts.InsertProduct(requestObjList);
         dbu_Integration_Parts.InsertProduct(null);
        Test.StopTest();
    }
} //Prod deployment 23-09-2022