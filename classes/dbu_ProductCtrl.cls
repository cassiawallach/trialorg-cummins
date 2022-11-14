/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-21-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class dbu_ProductCtrl {
    /**
    * Author : Shriram 
    * Created on 7th July 2020
    * Description : this class will all the product related operation
    */
    public dbu_ProductCtrl() { }
    /* This method fetching the product list, even this method can be resued in case of redirecting from url*/
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_Product__c> fetchLstProducts(String urlParam) {
        System.debug('url>>>>>>>>>>>>>>>>>'+urlParam);
        list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('searchText')){
                    lstproduct = dbu_CustomSearchController.getProductList(params.get('searchText'));
                }else{
                    lstproduct = [select id, name, dbu_Image_Src__c,ccrz__AverageRating__c,Group_Name__c,ccrz__Quantityperunit__c,(select id,ccrz__Price__c,dbu_Discount_Percent__c,dbu_Original_Price__c from ccrz__E_PriceListItems__r) from ccrz__E_Product__c where Group_Name__c='Ecom' Order By createdDate desc];//Added by Shriram
                    //lstproduct = [select id, name, dbu_Image_Src__c, ccrz__AverageRating__c,ccrz__Quantityperunit__c from ccrz__E_Product__c Order By createdDate asc limit 10];//Commented by shriram
                    // lstproduct=[select id,name,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r),(select id,ccrz__Rating__c from ccrz__E_Reviews__r) from ccrz__E_Product__c Order By createdDate asc limit 10];
                }
            }else{
                //lstproduct = [select id, name, dbu_Image_Src__c, ccrz__AverageRating__c,ccrz__Quantityperunit__c from ccrz__E_Product__c Order By createdDate asc limit 10];//Commented by shriram
                // lstproduct=[select id,name,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r),(select id,ccrz__Rating__c from ccrz__E_Reviews__r) from ccrz__E_Product__c Order By createdDate asc limit 10];
                lstproduct = [select id, name, dbu_Image_Src__c,ccrz__AverageRating__c,Group_Name__c,ccrz__Quantityperunit__c,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r) from ccrz__E_Product__c where Group_Name__c='Ecom' Order By createdDate desc];//Added by Shriram
                
            }    
        }catch (Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        return lstproduct;
    }
     @AuraEnabled(cacheable=true)
        public static  Map<String,Object> fetchFeaturedLstProducts(String urlParam) {
            System.debug('url>>>>>>>>>>>>>>>>>'+urlParam);
            list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
            Map<String,Object> productMap = new  Map<String,Object>();
            //START CECI-958
            string locationcode;
            if(urlParam=='US')
            {
                locationcode='US';    
            }
            else if(urlParam=='CA') 
            {
                locationcode='EN';
            }   
            //END CECI-958
            //get the country cureency iso mapping from custom settings
            Map<string,string> countryCurrencyMap = new Map<string,string>();
            for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
            }
            system.debug('countryCurrencyMap > ' + countryCurrencyMap);
            
            string currencyISOvalue = (string)countryCurrencyMap.get(urlParam);         
            
            try{
                //Malhar added Cart_StoreCountry in following method - 3/12/2020
                lstproduct = [select id, name,ccrz__SKU__c,dbu_Image_Src__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,
                dbu_Has_Core_Charge__c,
                (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r  
                                WHERE ccrz__Enabled__c = true 
                                AND ccrz__EndDate__c >= today
                                AND ccrz__StartDate__c <= today
                                AND ccrz__Storefront__c = 'CSSNAStore'
                                AND dbu_store_location__c INCLUDES (:locationcode)
                                LIMIT 1),
                (select id,ccrz__Price__c,dbu_Original_Price__c,dbu_Discount_Percent__c 
                from ccrz__E_PriceListItems__r where  ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),                
                (select id, ccrz__URI__c from ccrz__E_ProductMedias__r  limit 1) 
                                from ccrz__E_Product__c where name != null AND DBU_Product_Location__c INCLUDES (:urlParam) AND ccrz__ProductStatus__c = 'Released' AND Group_Name__c='Ecom' AND dbu_mostPopularParts__c = true Limit 10];
                Set<String> pIdList = new Set<String>();
                for(ccrz__E_Product__c product:lstproduct){
                    //system.debug(product.id);
                   pIdList.add(String.ValueOf(product.id));
                }
                system.debug(pIdList);
                //CECI-960 get core price map.
                
                Map<string,string> coreProductMap = new map<string,string>();
                Map<string,string> CategoryMap = new map<string,string>();//Added CECI-958
                Map<string,string> BrandMap = new map<string,string>();//Added CECI-958
                coreProductMap = fetchcorepricebyproductid(pIdList, currencyISOvalue);
                 //CECI-960 Send map
                 CategoryMap=getcategoryfromproductid(pIdList,locationcode);//Added CECI-958
                 BrandMap=getBrandfromproductid(pIdList,locationcode);//Added CECI-958

                 productMap.put('productData',lstproduct);
                 productMap.put('corePrice',coreProductMap);
                 productMap.put('categorydata',CategoryMap);//Added CECI-958
                productMap.put('branddata',BrandMap);//Added CECI-958
    
            }catch (Exception ex){
                System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
            }
            SYSTEM.DEBUG('FINALDATA'+productMap);
            System.debug('==lstproduct==='+lstproduct);
            return productMap;
        }
            //START  CECI-958
        public static Map<String,String> getcategoryfromproductid(Set<String> productId,String locationcode){ 
            Map<String,String> categorymap=new  Map<String,String>();
        try{
        
        List<ccrz__E_ProductCategory__c >prodCateObj = new  List <ccrz__E_ProductCategory__c >();
        
        
        prodCateObj = [SELECT Id,ccrz__Category__r.Name,ccrz__Category__c,ccrz__Category__r.ccrz__ParentCategory__c,ccrz__Product__r.Name,ccrz__Category__r.ccrz__ParentCategory__r.name,ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.name FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__r.id IN: productId AND ccrz__Category__r.ccrz__ParentCategory__c != null AND ccrz__Category__r.dbu_isPromotion__c=false AND ccrz__Category__r.dbu_Category_Location__c INCLUDES (:locationcode) AND ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c!=null];
        system.debug('CAT'+prodCateObj);
        if(prodCateObj!=null && prodCateObj.size()>0 )
        {
        for(ccrz__E_ProductCategory__c productcatvar:prodCateObj)
        {
            categorymap.put(productcatvar.ccrz__Product__r.id,productcatvar.ccrz__Category__r.ccrz__ParentCategory__r.name);
            system.debug('Testr'+categorymap);
        }
        
            
        }
    }
        catch(Exception e)
        {
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return categorymap;
    }

        public static Map<String,String> getBrandfromproductid(Set<String> productId,String locationcode){ 
            Map<String,String> brandmap=new  Map<String,String>();
        try{
        
        List<ccrz__E_ProductCategory__c >prodCateObj = new  List <ccrz__E_ProductCategory__c >();
        
        
        prodCateObj = [SELECT Id,ccrz__Category__r.Name,ccrz__Category__c,ccrz__Category__r.ccrz__ParentCategory__c,ccrz__Product__r.Name,ccrz__Category__r.ccrz__ParentCategory__r.name,ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.name FROM ccrz__E_ProductCategory__c WHERE ccrz__Product__r.id IN: productId AND ccrz__Category__r.ccrz__ParentCategory__c != null AND ccrz__Category__r.dbu_isPromotion__c=false AND ccrz__Category__r.ccrz__ParentCategory__r.dbu_Category_Location__c INCLUDES (:locationcode) AND ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__c!=null ];
        system.debug('CAT'+prodCateObj);
        if(prodCateObj!=null && prodCateObj.size()>0 )
        {
        for(ccrz__E_ProductCategory__c productcatvar:prodCateObj)
        {
            brandmap.put(productcatvar.ccrz__Product__r.id,productcatvar.ccrz__Category__r.ccrz__ParentCategory__r.ccrz__ParentCategory__r.name);
            system.debug('Testr'+brandmap);
        }
        
       }
        }
        catch(Exception e)
        {
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return brandmap;
    }
         //END  CECI-958
   

       
    
            // Create new methrod By Ravi
            @AuraEnabled(cacheable=true)
            public static list<ccrz__E_Product__c> fetchFeaturedLstProducts1(String urlParam) {
                System.debug('url NEW>>>>>>>>>>>>>>>>>'+urlParam);
                list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
                Map<String,Object> productMap = new Map<String,Object>();
    
                string locationcode;
                if(urlParam=='US')
                {
                    locationcode='US';    
                }
                else if(urlParam=='CA') 
                {
                    locationcode='EN';
                }   
                //get the country cureency iso mapping from custom settings
                Map<string,string> countryCurrencyMap = new Map<string,string>();
                for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                    system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                    system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                    countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
                }
                system.debug('countryCurrencyMap > ' + countryCurrencyMap);
                
                string currencyISOvalue = (string)countryCurrencyMap.get(urlParam);         
                
                try{
                    //Malhar added Cart_StoreCountry in following method - 3/12/2020
                    date ReleaseDate = Date.today().addDays(-30);
                    //lstproduct = [select id, name,dbu_Image_Src__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,Release_Date__c,(select id,ccrz__Price__c,dbu_Original_Price__c from ccrz__E_PriceListItems__r where  ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),(select id, ccrz__URI__c from ccrz__E_ProductMedias__r  limit 1) 
                                //from ccrz__E_Product__c where name != null AND (ccrz__ProductStatus__c = 'Released' AND Release_Date__c >= LAST_N_DAYS:30) AND Group_Name__c='Ecom' AND dbu_mostPopularParts__c = true  Limit 10];
                                //AND ccrz__ProductStatus__c = 'Released'And dbu_Featured_Product__c = true Limit 50];
                    
                    //And (dbu_Has_Core_Charge__c=false or dbu_Has_Core_Child__c=false) Limit 50];
                    //lstproduct = [select id, name,dbu_Image_Src__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,(select id,ccrz__Price__c,dbu_Original_Price__c from ccrz__E_PriceListItems__r WHERE ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),(select id, ccrz__URI__c from ccrz__E_ProductMedias__r limit 1) from ccrz__E_Product__c where  DBU_Product_Location__c INCLUDES (:urlParam) and Group_Name__c='Ecom' Order By createdDate desc Limit 100];
                   // Set<String> pIdList;
                    for(ccrz__E_Product__c prod:[
                        select id, name,dbu_Image_Src__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,
                        Release_Date__c,dbu_Has_Core_Charge__c,
                        (select id,ccrz__Price__c,dbu_Original_Price__c,dbu_Discount_Percent__c from ccrz__E_PriceListItems__r 
                                where  ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),
                                (select id, ccrz__URI__c from ccrz__E_ProductMedias__r  limit 1),
                                (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r  
                                WHERE ccrz__Enabled__c = true 
                                AND ccrz__EndDate__c >= today
                                AND ccrz__StartDate__c <= today
                                AND ccrz__Storefront__c = 'CSSNAStore'
                                AND dbu_store_location__c INCLUDES (:locationcode)
                                LIMIT 1)
                                from ccrz__E_Product__c where name != null 
                                AND (ccrz__ProductStatus__c = 'Released' 
                                AND Release_Date__c >= LAST_N_DAYS:30) 
                                AND Group_Name__c='Ecom' 
                                AND dbu_mostPopularParts__c = true  Limit 10]){
                        if(prod.ccrz__E_PriceListItems__r!=null && prod.ccrz__E_PriceListItems__r.size()>0){
                            lstproduct.add(prod);
                            ///pIdList.add(prod.id);
                        }
                    }
                    //CECI-960 get core price map.
                    //Map<string,string> coreProductMap = new map<string,string>();
                    //coreProductMap = fetchcorepricebyproductid(pIdList, currencyISOvalue);
                     //CECI-960 Send map
                     //productMap.put('productData',lstproduct);
                    // productMap.put('corePrice',coreProductMap);
                    system.debug('lstproduct ' + lstproduct);
    
                }catch (Exception ex){
                    System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
                }
                System.debug('==lstproduct=== NEW'+lstproduct);
                return lstproduct;
            }
    
    @AuraEnabled(cacheable=true)
    public static list<dbu_CCAPIResponseWrapper> fetchProductById(String urlParam) {
        System.debug('url>>>>>>>>>>>>>>>>>'+urlParam);
        // list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
        list<dbu_CCAPIResponseWrapper> objcallccapi = new list<dbu_CCAPIResponseWrapper>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    productId=productId.substring(0,15);
                    System.debug('productId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    objcallccapi = dbu_callCCApi.fetchProductDetails(productId,urlParam);
                    system.debug('objcallccapi'+objcallccapi);
                    
                    //lstproduct = [select id, name, dbu_Image_Src__c, ccrz__AverageRating__c,ccrz__Quantityperunit__c, ccrz__ShortDescRT__c,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r) from ccrz__E_Product__c where Id =: productId];
                }
            }
        }catch (Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        return objcallccapi;
    }
    
    @AuraEnabled(cacheable=true)
    public static boolean Checkcreateengine(String urlParam){
        boolean crateengine = false;
        system.debug('urlParam'+urlParam);
        list<ccrz__E_Product__c>lstproduct = new list<ccrz__E_Product__c>();
        list<ccrz__E_CartItem__c> cartcreate = new list<ccrz__E_CartItem__c>();
        list<ccrz__E_OrderItem__c > cartorder = new list<ccrz__E_OrderItem__c>();
        string cartIdforuser = urlParam;
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('productId>>>>>>>>>>>>>>>>>\t'+productId);
                    if(productId!=null){
                        lstproduct =[select id,dbu_Crate_Engine__c  from ccrz__E_Product__c where id =:productId];
                    }
                    // crateengine= lstproduct.dbu_Crate_Engine__c;
                    for(ccrz__E_Product__c create:lstproduct){
                        crateengine=create.dbu_Crate_Engine__c;
                    }
                    
                }
                
                
                if(params.size() > 0 && params.containsKey('cartId')){
                    string cartid = params.get('cartId');
                    
                    System.debug('cartId>>>>>>>>>>>>>>>>>\t'+cartid);
                    if(cartid!=null){
                        cartcreate =[select id,ccrz__Product__r.dbu_Crate_Engine__c,ccrz__Cart__c  from ccrz__E_CartItem__c where ccrz__Cart__c=:cartid];
                        system.debug('cartcreate'+cartcreate);
                    }
                    // crateengine= lstproduct.dbu_Crate_Engine__c;
                    for(ccrz__E_CartItem__c create:cartcreate){
                        if(create.ccrz__Product__r.dbu_Crate_Engine__c==true){
                            crateengine=create.ccrz__Product__r.dbu_Crate_Engine__c;
                        }
                        
                    }
                    
                }
                system.debug('crateengine'+crateengine);
                
                if(params.size() > 0 && params.containsKey('orderid')){
                    string orderid = params.get('orderid');
                    System.debug('orderid>>>>>>>>>>>>>>>>>\t'+orderid);
                    if(orderid!=null & orderid!=''){
                        cartorder=[select id,ccrz__Product__r.dbu_Crate_Engine__c,ccrz__Order__c from ccrz__E_OrderItem__c where ccrz__Order__r.id =:orderid];
                        for(ccrz__E_OrderItem__c create:cartorder){
                            if(create.ccrz__Product__r.dbu_Crate_Engine__c==true){
                                crateengine=create.ccrz__Product__r.dbu_Crate_Engine__c; 
                            }
                            // system.debug('crateengine'+crateengine);
                            
                        }
                    }
                    
                }
                
            }  
            system.debug('crateengine'+crateengine);
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        
        return crateengine;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_CrateTnC__mdt> getCrateMetaData(String urlParam){
        List<dbu_CrateTnC__mdt> Cratemetdata = new list<dbu_CrateTnC__mdt>();
        list<ccrz__E_Product__c>lstproduct = new list<ccrz__E_Product__c>();
        list<ccrz__E_CartItem__c> cartcreate = new list<ccrz__E_CartItem__c>();
        string cartIdforuser = urlParam;
        boolean crateengine=false;
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('productId>>>>>>>>>>>>>>>>>\t'+productId);
                    if(productId!=null){
                        lstproduct =[select id,dbu_Crate_Engine__c  from ccrz__E_Product__c where id =:productId];
                        if(lstproduct[0].dbu_Crate_Engine__c==true || crateengine==true){
                            Cratemetdata=[SELECT MasterLabel,dbu_AgreementCheckBox__c,dbu_AgreementShortDesc__c from dbu_CrateTnC__mdt]; 
                        }
                    }
                }
                if(cartIdforuser!='' && cartIdforuser!=null){
                    
                    System.debug('cartId>>>>>>>>>>>>>>>>>\t'+cartIdforuser);
                    if(cartIdforuser!=null){
                        cartcreate =[select id,ccrz__Product__r.dbu_Crate_Engine__c,ccrz__Cart__c  from ccrz__E_CartItem__c where ccrz__Cart__c=:cartIdforuser];
                        system.debug('cartcreate'+cartcreate);
                    }
                    // crateengine= lstproduct.dbu_Crate_Engine__c;
                    for(ccrz__E_CartItem__c create:cartcreate){
                        if(create.ccrz__Product__r.dbu_Crate_Engine__c==true){
                            crateengine=create.ccrz__Product__r.dbu_Crate_Engine__c;
                        }
                        
                    }
                    if(crateengine==true){
                        Cratemetdata=[SELECT MasterLabel,dbu_AgreementCheckBox__c,dbu_AgreementShortDesc__c from dbu_CrateTnC__mdt]; 
                    }
                    
                }
            }
            
            
            
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        
        return Cratemetdata;
    }   
    
    @auraenabled(cacheable=true)
    public static List<dbu_CrateTnC__mdt> getlongdesc(string label)
    {
        List<dbu_CrateTnC__mdt> Cratemetdata = new list<dbu_CrateTnC__mdt>();
        try{
            Cratemetdata=[SELECT MasterLabel,dbu_AgreementLongDesc__c from dbu_CrateTnC__mdt where MasterLabel=:label]; 
        }
        catch(exception e){
            system.debug('exception message'+e.getMessage() +''+'exception line number'+e.getLineNumber());
        }
        
        
        return Cratemetdata;
    }
    
        @auraenabled(cacheable=true)
    public static string getESNPdpPopup()
    {
        List<dbu_ESNData__mdt> ESNMetaData = new list<dbu_ESNData__mdt>();
        string esnContentValue;
        try{
            ESNMetaData=[SELECT MasterLabel,dbu_ESNPDPPopup__c from dbu_ESNData__mdt]; 
            if(ESNMetaData != null){
                for(dbu_ESNData__mdt esnPopupValue: ESNMetaData){
                    esnContentValue = esnPopupValue.dbu_ESNPDPPopup__c;
                    system.debug('esnContentValue' +esnContentValue);
    
                }
            }
        }
        catch(exception e){
            system.debug('exception message'+e.getMessage() +''+'exception line number'+e.getLineNumber());
        }
        system.debug('esnContentValue111' +esnContentValue);
    
        return esnContentValue;
    }
    @auraenabled(cacheable=true)
    public static list<dbu_StateNames__mdt> getStatesForCrateEngine(string pid){
        list<dbu_StateNames__mdt> stateslst = new list<dbu_StateNames__mdt>();
        try{
            stateslst=[select id,dbu_Stateslist__c from dbu_StateNames__mdt];
            
        }
        catch(exception e)
        {
            system.debug('Exception Message'+e.getMessage() +''+'Exception line Number '+e.getLineNumber());
        }
        return stateslst;
    }
    @AuraEnabled
    public static boolean ValidateUserenteredESN(string ESN,string urlParam){
        system.debug('ESN'+ESN);
        system.debug('urlParam'+urlParam);
        boolean ValidESN=false;
        string ProductSKU;
        string trimmedesn = ESN;
        trimmedesn = trimmedesn.trim();
        
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    List<ccrz__E_Product__c> productlst = [SELECT id,dbu_Part_Number__c FROM ccrz__E_Product__c where id=:productId];
                    system.debug('productlst'+productlst);
                    if(productlst!=null && productlst.size()>0){
                        ProductSKU=productlst[0].dbu_Part_Number__c;
                    }
                    dbu_ESNValidationResponse ESNvalidateresponse = dbu_Integration_ESNValidation.getEsnResult(trimmedesn, ProductSKU);
                    system.debug('ESNvalidateresponse.compatible'+ESNvalidateresponse.compatible);
                    ValidESN=ESNvalidateresponse.compatible;
                    system.debug('ValidESN'+ValidESN);
                    
                }
            }
        }
        catch(exception e){
            system.debug('exception message'+e.getMessage() +''+'exception line number'+e.getLineNumber());
        }
        
        return ValidESN;
    }
    
    //This Method is temp only will replace by cc api further
    @AuraEnabled(cacheable=true)
    public static  List<ccrz__E_ProductSpec__c> fetchSpecsByProdId(String urlParam){
        List<ccrz__E_ProductSpec__c> totalSpecs = new List<ccrz__E_ProductSpec__c>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('productId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    if(productId!=null){
                        totalSpecs=[select id,name,ccrz__SpecValue__c,ccrz__Spec__r.name,ccrz__Product__c from ccrz__E_ProductSpec__c where ccrz__Product__c =:productId and ccrz__Spec__r.name!='Model'] ;  
                        //system.debug('ccrz__Spec__r.name'+totalSpecs[0].ccrz__Spec__r.name);
                        system.debug('totalSpecs'+totalSpecs);
                        
                    }
                }
            }
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return totalSpecs;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static  Boolean  fetchmodelSpecsByProdId(String urlParam){
        List<ccrz__E_ProductSpec__c> totalSpecs = new List<ccrz__E_ProductSpec__c>();
        Boolean enablespeclink = false;
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('productId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    if(productId!=null){
                        List<ccrz__E_Product__c> ratingList = [select id,name,dbu_Product_Code__c from ccrz__E_Product__c where id =:productId];
                        for(ccrz__E_Product__c rate : ratingList){
                            if(rate.dbu_Product_Code__c =='ONAN' || rate.dbu_Product_Code__c=='Onan'){
                                /*  totalSpecs=[select id,name,ccrz__SpecValue__c,ccrz__Spec__r.name,ccrz__Product__c from ccrz__E_ProductSpec__c where ccrz__Product__c =:productId and ccrz__Spec__r.name ='Model'] ;  
    //system.debug('ccrz__Spec__r.name'+totalSpecs[0].ccrz__Spec__r.name);
    //
    if(totalSpecs.size()>0){
    system.debug('totalSpecs'+totalSpecs);
    } */
                                enablespeclink = true;
                            }
                        }
                        
                    }
                }
            }
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return enablespeclink;
    }
    
    //This method is temp only will replace by cc api further
    //This method is temp only will replace by cc api further
     @AuraEnabled(cacheable=true)
     public static  List<dbu_CCAPIResponseWrapper> fetchPriceByProdID(string urlParam){
       List<ccrz__E_PriceListItem__c> pricebyprodid = new List<ccrz__E_PriceListItem__c>();
       List <dbu_CCAPIResponseWrapper> productWrapperList = new List<dbu_CCAPIResponseWrapper>();
       Set<String> Productset=new Set <String>();
        Map<String,String> corepricemap=new map <String,String>();
            try{
                if(String.isNotBlank(urlParam)){
                    
                    
                    
                    ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                    Map<String, String> params = ref.getParameters();
                    System.debug('?????????\t'+params.size());
                    if(params.size() > 0 && params.containsKey('pId')){
                        string productId = params.get('pId');
                        Productset.add(productId);
                        string storelanguage = params.get('store');
                        System.debug('productId>>>>>>>>>>>>>>>>>\t'+productId);
                        SYSTEM.debug('storelanguage > ' + storelanguage);
                        
                        if(productId!=null){
                            string storeCountry;
                            //check which country it is
                            if(storelanguage =='US'){
                                storeCountry = system.label.dbu_home_store_U_S_A;
                            }else if(storelanguage == 'CA'|| storelanguage == 'EN'){
                                storeCountry = 'CA';
                            }else if(storelanguage == 'FR'){
                                storeCountry = 'CA';
                            }
                            
                            //get the country cureency iso mapping from custom settings
                            Map<string,string> countryCurrencyMap = new Map<string,string>();
                            for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                                system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                                system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                                countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
                            }
                            system.debug('countryCurrencyMap > ' + countryCurrencyMap);
                            
                            string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry); 
                            system.debug('currencyISOvalue > ' + currencyISOvalue);
                            //Start CECI-956                  
                            //pricebyprodid=[select id,name,dbu_Original_Price__c,ccrz__Price__c,ccrz__Product__c from ccrz__E_PriceListItem__c where ccrz__Product__c =:productId and ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue] ;  
                            List<ccrz__E_Product__c> prodList = [select id, name, dbu_Part_Number__c, ccrz__SKU__c,dbu_Has_Core_Charge__c,dbu_Has_Core_Child__c,(select name, ccrz__Category__r.Name from ccrz__Promotions__r  WHERE  ccrz__Enabled__c = true 
                                                                                                                    AND ccrz__EndDate__c >= today AND ccrz__StartDate__c <= today AND ccrz__Storefront__c = 'CSSNAStore' AND dbu_store_location__c INCLUDES (:storelanguage) LIMIT 1 ),     
                                                                 (select id, name, ccrz__Price__c, dbu_Original_Price__c, dbu_Discount_Percent__c from ccrz__E_PriceListItems__r WHERE ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue LIMIT 1)
                                                                 from ccrz__E_Product__c WHERE Id =:productId AND  ccrz__ProductStatus__c='Released' AND ccrz__StartDate__c <= today AND ccrz__EndDate__c>= today
                                                                 AND ccrz__Storefront__c INCLUDES ('CSSNAStore') AND DBU_Product_Location__c INCLUDES (:storeCountry)];
                            system.debug('prodList'+prodList);
                            corepricemap=fetchcorepricebyproductid(Productset,currencyISOvalue);
                            if(!prodList.isEmpty())
                            {
                                for(ccrz__E_Product__c product : prodList)
                                {
                                    dbu_CCAPIResponseWrapper prodDetail = new dbu_CCAPIResponseWrapper();
                                    prodDetail.sfId = product.id;
                                    prodDetail.sfdcName = product.name;
                                    prodDetail.SKU = product.ccrz__SKU__c;  
                                   
                                    if(product.dbu_Has_Core_Charge__c)
                                    {
                                        prodDetail.hasCoreCharge=TRUE;
                                        
                                    }
                                      //START CECI-839
                                    if(product.dbu_Has_Core_Child__c)
                                    {
                                        prodDetail.hasCoreChild=TRUE;
                                        
                                    }
                                      //END CECI-839
                                                                    
                                    if(product.dbu_Has_Core_Charge__c=true && corepricemap.size()>0 && corepricemap.get(product.id) != null)
                                    {
                                        prodDetail.coreCharge=Decimal.valueof(corepricemap.get(product.id));
                                    }
                                    else
                                    {
                                        prodDetail.coreCharge =0.0;
                                    }
    
                                    if(product.ccrz__E_PriceListItems__r!=null && product.ccrz__E_PriceListItems__r.size()>0 )      
                                    {    
                                        prodDetail.price =Double.valueof(product.ccrz__E_PriceListItems__r[0].ccrz__Price__c) ;         
                                        
                                        prodDetail.originalPrice = product.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                                       
                                        prodDetail.discountPercentage = Integer.valueof(product.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c);                         
                                        
                                    }
                                    
                                    if(product.ccrz__Promotions__r != null && product.ccrz__Promotions__r.size()>0 )
                                    {
                                        prodDetail.promotionCategory= String.valueof(product.ccrz__Promotions__r[0].ccrz__Category__r.Name);                  
                                    }
                                    productWrapperList.add(prodDetail);
                                    
                                }
                                
                            }
                            SYSTEM.DEBUG('FINALWRAPPER'+productWrapperList);
                        }
                    }
                    //End CECI-956 
                }
            }
            catch(Exception E){
                system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
            }
            return productWrapperList;
        }
        
    //START CECI-956
    public static Map<String,String> fetchcorepricebyproductid(Set<String> productset,String currencyISOvalue)
    {
            system.debug('productListByID'+productset);

        Map<String,String> corepricemap=new Map<String,String>();
        Map<Id,id> relatedProductMap= new  Map<Id,id>();
        List<ccrz__E_RelatedProduct__c> productListByID =[select id,ccrz__RelatedProduct__c,ccrz__RelatedProduct__r.id ,
                             ccrz__Product__c,ccrz__Product__r.id from ccrz__E_RelatedProduct__c where ccrz__Product__r.id IN:productset 
                AND ccrz__RelatedProductType__c = 'Core Charge' 
                AND ccrz__Enabled__c=True            
                AND ccrz__Product__r.dbu_Has_Core_Charge__c=TRUE
                AND ccrz__Product__r.ccrz__ProductStatus__c = 'Released' 
                AND ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore'
                AND ccrz__Product__r.ccrz__StartDate__c <= today 
                AND ccrz__Product__r.ccrz__EndDate__c>= today ]; 
        
        system.debug('productListByID'+productListByID);
        for(ccrz__E_RelatedProduct__c productBooleanData : productListByID)
        {  
            
            if(productListByID.size() > 0)
            {
                            system.debug('enter productListByID size if ');

                if( productBooleanData.ccrz__RelatedProduct__c != null)
                {
                                                    system.debug('enter productBooleanData ccrz__RelatedProduct__c null if');

                    //relatedProductMap.put(productBooleanData.ccrz__RelatedProduct__r.id,productBooleanData.ccrz__Product__r.id);
                    relatedProductMap.put(productBooleanData.ccrz__Product__r.id,productBooleanData.ccrz__RelatedProduct__r.id);
                    
                }
                else{                                                        
                    system.debug('enter productBooleanData ccrz__RelatedProduct__c null else');
                    }
            }
        }
            
        
        system.debug('relatedProductMap'+relatedProductMap);

        //List<ccrz__E_PriceListItem__c> corePriceListItems=[Select id,ccrz__Price__c,ccrz__Pricelist__c,ccrz__Product__c,ccrz__Product__r.DBU_Product_Location__c from ccrz__E_PriceListItem__c Where ccrz__Product__c IN:relatedProductMap.keyset() AND ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue];
        List<ccrz__E_PriceListItem__c> corePriceListItems=[Select id,ccrz__Price__c,ccrz__Pricelist__c,ccrz__Product__c,ccrz__Product__r.DBU_Product_Location__c from ccrz__E_PriceListItem__c Where ccrz__Product__c IN:relatedProductMap.values() AND ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue];
        system.debug('corePriceListItems'+corePriceListItems);

        Map<string,string> coreProdPriceMap = new Map<string,string>();
        if(corePriceListItems.size() > 0){
            for(ccrz__E_PriceListItem__c priceListItem : corePriceListItems){
                coreProdPriceMap.put(String.valueof(priceListItem.ccrz__Product__c), String.valueof(priceListItem.ccrz__Price__c));
            }
        }
        system.debug('coreProdPriceMap --> '+coreProdPriceMap);
        
        if(relatedProductMap.size() > 0){
            for(string prodId : relatedProductMap.keyset()){
                if(prodId != null && relatedProductMap.get(prodId) != null ){
                    if(coreProdPriceMap.containsKey(relatedProductMap.get(prodId)) && coreProdPriceMap.get(relatedProductMap.get(prodId)) != null){
                        corepricemap.put(String.valueof(prodId), coreProdPriceMap.get(relatedProductMap.get(prodId)));
                    }
                    
                }
            }
        }
        
        /*for(ccrz__E_PriceListItem__c corepricevar :corePriceListItems)
        {
            if(corePriceListItems.size()>0)
            {
                                        system.debug('corepricemap if'+corepricemap);

                corepricemap.put(String.valueof(relatedProductMap.get(corepricevar.ccrz__Product__c)),String.valueof(corepricevar.ccrz__Price__c));
            }
            
        }*/
        system.debug('corepricemap->'+corepricemap);
        return corepricemap;
    }                                        
    //END CECI-956
        
    
    @AuraEnabled(cacheable=true)
    public static  List<ccrz__E_ProductInventoryItem__c> fetchMessageByProdID(string urlParam){
        List<ccrz__E_ProductInventoryItem__c> messagebyprodid = new List<ccrz__E_ProductInventoryItem__c>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('productId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    if(productId!=null){
                        messagebyprodid=[select id,name,ccrz__ProductItem__c,ccrz__AvailabilityMessage__c from ccrz__E_ProductInventoryItem__c where ccrz__ProductItem__c =:productId] ;
                        
                        system.debug('messagebyprodid'+messagebyprodid);
                        
                    }
                }
            }
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return messagebyprodid;
    }
    
    @AuraEnabled(cacheable=true)
    public static list<ccrz__E_CompositeProduct__c> fetchKitProductsByProdId(string urlParam){
        list<ccrz__E_CompositeProduct__c> kitProductList = new list<ccrz__E_CompositeProduct__c>();
        
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('productkitProductListId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    if(productId!=null){
                        kitProductList=[select id,name ,ccrz__Component__r.name,ccrz__Component__r.id,ccrz__Composite__c,ccrz__Component__c,ccrz__Quantity__c from ccrz__E_CompositeProduct__c where ccrz__Composite__c =:productId] ;
                        
                        system.debug('kitProductList'+kitProductList);
                        
                    }
                }
            }
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        
        
        return kitProductList;
    }
    
    @AuraEnabled(cacheable=true)   
    public static List<ccrz__E_Product__c> fetchrelatedproducts(String urlParam) {
        //public static List<ccrz__E_RelatedProduct__c> fetchrelatedproducts(String urlParam) {
        System.debug('RelatedProductsurlParam >>>>>>>>>>>>>>>>>'+urlParam);
        
        //List<ccrz__E_RelatedProduct__c> relatedProducts = new List<ccrz__E_RelatedProduct__c>();
        list<ccrz__E_Product__c> relatedProducts = new list<ccrz__E_Product__c>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('RelatedProducts?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('RelatedProductsproductId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    if(productId!=null){
                        //pricebyprodid=[select id,name,ccrz__Price__c,ccrz__Product__c from ccrz__E_PriceListItem__c where ccrz__Product__c =:productId] ;  
                        
                        
                        //relatedProducts = [select id,ccrz__RelatedProduct__r.Name,ccrz__RelatedProduct__r.ccrz__AverageRating__c,
                        //ccrz__RelatedProductType__c,ccrz__RelatedProduct__r.dbu_Image_Src__c from ccrz__E_RelatedProduct__c WHERE ccrz__RelatedProductType__c='Related' AND ccrz__Product__c =:productId ];
                        
                        //relatedProducts = [select id,name, ccrz__RelatedProductType__c from ccrz__E_RelatedProduct__c where ccrz__Product__c =:productId];
                        relatedProducts = [select id, name, dbu_Image_Src__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,Group_Name__c,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r) from ccrz__E_Product__c where Group_Name__c='Ecom' Order By createdDate desc Limit 5];
                        system.debug('relatedProducts:'+relatedProducts);
                        
                    }
                }
                
                
            }
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return relatedProducts;
        
    }
    
    @AuraEnabled(cacheable=true)
    
    public static List<ccrz__E_Product__c> fetchsimilarproducts(String urlParam) {
        //public static List<ccrz__E_RelatedProduct__c> fetchsimilarproducts(String urlParam) {
        System.debug('RelatedProductsurlParam >>>>>>>>>>>>>>>>>'+urlParam);
        
        //List<ccrz__E_RelatedProduct__c> similarProducts = new List<ccrz__E_RelatedProduct__c>();
        list<ccrz__E_Product__c> similarProducts = new list<ccrz__E_Product__c>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('SimilarProducts?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('SimilarProductsproductId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    if(productId!=null){
                        //pricebyprodid=[select id,name,ccrz__Price__c,ccrz__Product__c from ccrz__E_PriceListItem__c where ccrz__Product__c =:productId] ;  
                        
                        
                        //similarProducts = [select id,ccrz__RelatedProduct__r.Name,ccrz__RelatedProduct__r.ccrz__AverageRating__c,
                        //ccrz__RelatedProductType__c,ccrz__RelatedProduct__r.dbu_Image_Src__c from ccrz__E_RelatedProduct__c WHERE ccrz__RelatedProductType__c='CrossSell' AND ccrz__Product__c =:productId ];
                        similarProducts = [select id, name, dbu_Image_Src__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,Group_Name__c,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r) from ccrz__E_Product__c where Group_Name__c='Ecom' Order By createdDate desc Limit 5];
                        system.debug('similarProducts:'+similarProducts);
                        
                    }
                }
                
                
            }
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return similarProducts;
        
    }
    
    @AuraEnabled(cacheable=true)
    public static list<Attachment> fetchAttachmentsbyProdId(string urlParam){
        list<Attachment> attachlst = new list<Attachment>();
        system.debug('inside attach'+urlparam);
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('SimilarProducts?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    System.debug('SimilarProductsproductId>>>>>>>>>>>>>>>>>\t'+productId);
                    
                    if(productId!=null){
                        attachlst=[select Id,parentid,Name, ContentType from Attachment where parentid=:productId];
                    }
                }
            }
        }
        catch(exception e){
            system.debug('exception message'+e.getMessage() +''+'exception line number'+e.getLineNumber());
        }
        return attachlst;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Decimal> getProductRating(String urlParam){
        ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
        Map<String, String> params = ref.getParameters();
        // if(params.size() > 0 && params.containsKey('pId')){
        string productId = params.get('pId');
        
        List<Decimal> ratList = new List<Decimal>();            
        List<ccrz__E_Review__c> ratingList = [select ccrz__Rating__c from ccrz__E_Review__c where ccrz__Product__c =:productId];
        for(ccrz__E_Review__c rate : ratingList){
            //system.debug('rate values ' + rate.get(ccrz__E_Review__c.ccrz__Rating__c));
            Decimal rat = (Decimal)rate.get(ccrz__E_Review__c.ccrz__Rating__c);
            system.debug('rat ' + rat);
            ratList.add(rat);
            system.debug('ratzlist ' + ratList);
        }
        //system.debug('ratingdd ' + ratingList);
        return ratList;
        // }
        
    }
    
    @AuraEnabled(cacheable=true)
    public static Boolean getProductcode(String urlParam){
        ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
        Map<String, String> params = ref.getParameters();
        // if(params.size() > 0 && params.containsKey('pId')){
        string productId = params.get('pId');
        Boolean genuine = false ;
        
        List<ccrz__E_Product__c> ratingList = [select id,name,dbu_Product_Code__c from ccrz__E_Product__c where id =:productId];
        for(ccrz__E_Product__c rate : ratingList){
            if((rate.dbu_Product_Code__c =='CECO' || rate.dbu_Product_Code__c=='DRC') && !rate.name.contains('Dodge Ram') ){
                genuine  = true;
                
            } 
            else{
                genuine  = false;
            }
        }
        system.debug('genuine ' + genuine);
        return genuine;
        // }
        
    }
    
    @AuraEnabled(cacheable=true)
    public static  List<ccrz__E_Product__c> getAllProducts(string searchval ,string storeCountry, Integer offset){
        system.debug('searchval'+searchval);
        string val = '%'+searchval+'%';
        string Country;
        system.debug('val'+val);
        if(storeCountry =='US'){
            Country = 'US';
        }
        else if(storeCountry =='EN' || storeCountry =='FR'){
            Country = 'CA';
        }
        list<ccrz__E_Product__c> lstproduct = [select id, name,ccrz__ProductStatus__c,DBU_Product_Location__c  from ccrz__E_Product__c where  name like:val and Group_Name__c='Ecom' and ccrz__ProductStatus__c ='Released'  and ccrz__Storefront__c='CSSNAStore' and  DBU_Product_Location__c INCLUDES (:Country)  and (dbu_Has_Core_Charge__c=false or dbu_Has_Core_Child__c=false) Order By createdDate desc LIMIT 10 OFFSET:offset];
        system.debug('lstproduct'+lstproduct);
        return lstproduct;
    }
    
    
    
    public static  List<ccrz__E_ProductCategory__c> fetchCategoryBySearchResult(set<string> searchid){
        List<ccrz__E_ProductCategory__c> totalCategory = new List<ccrz__E_ProductCategory__c>();
        try{
            if(searchid!=null ){
                totalCategory=[select id,name,ccrz__Product__c,ccrz__Category__r.name
                                from ccrz__E_ProductCategory__c where ccrz__Product__c IN:searchid] ;
                
                //system.debug('ccrz__Spec__r.name'+totalCategory[0].ccrz__Category__r.name);
                system.debug('totalSpecs'+totalCategory);
            }
            
            
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return totalCategory;
    }
    
    public static  List<ccrz__E_Category__c> fetchbrandBySearchResult(set<string> searchid){
        List<ccrz__E_ProductCategory__c> totalCategory = new List<ccrz__E_ProductCategory__c>();
        List<ccrz__E_Category__c > parentcategory = new List<ccrz__E_Category__c >();
        List<ccrz__E_Category__c > grandparentcategory = new List<ccrz__E_Category__c >();
        set<string> parentcat = new set<string>();
        set<string> grandparentcat = new set<string>();
        set<id> parentcatset = new set<id>();
        set<id> grandparentcatset = new set<id>();
        try{
            if(searchid!=null ){
                totalCategory=[select id,name,ccrz__Product__c,ccrz__Category__r.name
                                from ccrz__E_ProductCategory__c where ccrz__Product__c IN:searchid] ;
                system.debug('totalCategory'+totalCategory);
                
                if(totalCategory!=null && totalCategory.size()>0){
                    for(ccrz__E_ProductCategory__c category :totalCategory){
                        parentcat.add(category.ccrz__Category__r.name);
                        parentcatset.add(category.ccrz__Category__r.id);
                    }
                }
                
                system.debug('parentcat'+parentcat);
            }
            parentcategory=[select Id, Name,ccrz__ParentCategory__r.name FROM ccrz__E_Category__c WHERE Id IN:parentcatset];
            system.debug('parentcategory'+parentcategory);
            if(parentcategory!=null && parentcategory.size()>0){
                for(ccrz__E_Category__c grandcategory :parentcategory){
                    grandparentcat.add(grandcategory.ccrz__ParentCategory__r.name);
                    grandparentcatset.add(grandcategory.ccrz__ParentCategory__r.Id);
                }
            }
            
            grandparentcategory=[select Id, Name,ccrz__ParentCategory__r.name FROM ccrz__E_Category__c WHERE Id IN:grandparentcatset];
            system.debug('grandparentcategory'+grandparentcategory);
            // for()
        }
        catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return grandparentcategory;
    }
    
    public static list<ccrz__E_PriceListItem__c> fetchPriceBySearchResult(set<string> searchid){
        list<ccrz__E_PriceListItem__c> price = new list<ccrz__E_PriceListItem__c>();
        try{
            if(searchid!=null ){
                price= [select id,name,ccrz__Price__c,ccrz__Product__c from ccrz__E_PriceListItem__c where ccrz__Product__c IN:searchid] ; 
                system.debug('price'+price);
            }
        }
        catch(Exception e)
        {
            system.debug('exception Message'+e.getMessage()+''+'Exception line number'+e.getLineNumber());    
        }
        return price;
    }
    
    
    
    /**
    * @description updated forCECI-960
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 07-05-2022 
    * @param idList 
    * @param storeCountry 
    * @return Map<String, Object> 
    **/
    @AuraEnabled(cacheable=true)
    public static Map<String,Object> fetchRecentLstProducts(List<String> idList , string storeCountry) {
        System.debug('recently product ids >>>>>>>>>>>>>>>>>'+idList);
        Set<String> pIdList = new Set<String>(idList);
        system.debug('set list ' + pIdList);
        Map<string,string> CategoryMap = new map<string,string>();//Added CECI-958
        Map<string,string> BrandMap = new map<string,string>();//Added CECI-958
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);
        
        string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry);
        
        string currencyCode;
        string productCountryCode;
        if(storeCountry == 'US')
        {
            currencyCode = 'USD';
            productCountryCode = 'US';
        }
        else if (storeCountry == 'EN' || storeCountry == 'FR' )
        {
            currencyCode = 'CAD';
            productCountryCode = 'CA';
        }else if(storeCountry == 'CA'){
            currencyCode = 'CAD';
            productCountryCode = 'CA';
            storeCountry = 'EN';
        }
        //CECI-960 get core price map.
        Map<string,string> coreProductMap = new map<string,string>();
        coreProductMap = fetchcorepricebyproductid(pIdList, currencyCode);

        CategoryMap=getcategoryfromproductid(pIdList,storeCountry);//Added CECI-958
         BrandMap=getBrandfromproductid(pIdList,storeCountry);//Added CECI-958
        list<string> prodsplitdata = new list<string>();
        /*Malhar Modification for handling store based products*/
        for(string str : pIdList){            
            //prodsplitdata = str.split('&store=', 2);
            system.debug('split > ' + prodsplitdata);
            prodsplitdata.add((str.split('&store=', 2))[0]);
        }     
        system.debug('prodsplitdata > ' + prodsplitdata);
        
        /*Malhar Modification for handling store based products*/
        
        //following query modified by Malhar for store toggling - 7/12/2020
        list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
        Map<String,Object> mapProduct = new  Map<String,Object>();
        try{
            lstproduct = [select id, 
                            name,
                            dbu_Image_Src__c,
                            ccrz__AverageRating__c,
                            ccrz__Quantityperunit__c,
                            dbu_Has_Core_Charge__c,ccrz__SKU__c,
                            (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r  
                            WHERE ccrz__Enabled__c = true 
                            AND ccrz__EndDate__c >= today
                            AND ccrz__StartDate__c <= today
                            AND ccrz__Storefront__c = 'CSSNAStore'
                            AND dbu_store_location__c INCLUDES (:storeCountry)
                            LIMIT 1), 
                            (select id,dbu_Discount_Percent__c,ccrz__Price__c,dbu_Original_Price__c from ccrz__E_PriceListItems__r WHERE ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),
                            (select id, ccrz__URI__c from ccrz__E_ProductMedias__r limit 1) 
                            from ccrz__E_Product__c  
                            where  Group_Name__c='Ecom' 
                            and DBU_Product_Location__c INCLUDES (:productCountryCode)  
                            and  id IN : prodsplitdata];
        }catch (Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        //CECI-960 Send map
        mapProduct.put('productData',lstproduct);
        mapProduct.put('corePrice',coreProductMap);
        mapProduct.put('categorydata',CategoryMap);//Added CECI-958
        mapProduct.put('branddata',BrandMap);//Added CECI-958
        system.debug('lstproduct ' + lstproduct);
        return mapProduct;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static list<ccrz__E_Product__c> fetchFrequentlyBoughtTogether(String urlParam){
        list<ccrz__E_RelatedProduct__c> productlist = new list<ccrz__E_RelatedProduct__c>();
        list<ccrz__E_Product__c> plist = new list<ccrz__E_Product__c>();
        List<String> relatedPids = new List<String>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('SimilarProducts?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    if(productId!=null){
                        // productlist= [select id,name,dbu_ReconEquivalentPartNumber__c,dbu_Supersession_Number__c from ccrz__E_Product__c where id =:productId ];a2w190000018XfSAAU
                        productlist = [select ccrz__RelatedProduct__r.id from ccrz__E_RelatedProduct__c where ccrz__Product__c =:productId  AND ccrz__RelatedProductType__c = 'Complementary'];
                    }
                }
                
            }
            system.debug('productlist ' + productlist);
            for(ccrz__E_RelatedProduct__c obj : productlist){
                system.debug('productlist ' + obj.ccrz__RelatedProduct__c);
                relatedPids.add(obj.ccrz__RelatedProduct__c);
            }
            plist =  [select id, name,dbu_Image_Src__c,(select id,ccrz__Price__c from ccrz__E_PriceListItems__r),(select id, ccrz__URI__c from ccrz__E_ProductMedias__r limit 1) from ccrz__E_Product__c where id IN : relatedPids];
            system.debug('plist ' + plist);
        }
        catch(Exception e){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        
        return plist;
    }
    @AuraEnabled(cacheable=true)
    public static list<ccrz__E_Product__c> fetchReconSupersessionNumbers(String urlParam){
        list<ccrz__E_Product__c> productlist = new list<ccrz__E_Product__c>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('SimilarProducts?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    if(productId!=null){
                        productlist= [select id,name,dbu_ReconEquivalentPartNumber__c,dbu_Supersession_Number__c from ccrz__E_Product__c where id =:productId ];
                    }
                }
                
            }
        }
        catch(Exception e){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
            System.debug('productlist-->'+productlist);
        return productlist;
    }
    
    //Sandeep--
    @AuraEnabled(cacheable=true)
    public static list<ccrz__E_RelatedProduct__c> fetchReconSupersessionProducts(String ccProductId){
        list<ccrz__E_RelatedProduct__c > productlist = new list<ccrz__E_RelatedProduct__c >();
        try{
            if(ccProductId!=null){
                //productlist= [Select Id,Name,ccrz__RelatedProduct__c,ccrz__Product__r.Name,ccrz__Product__r.Id from ccrz__E_RelatedProduct__c where ccrz__RelatedProduct__c=:ccProductId ];
                    productlist= [Select Id,Name,ccrz__RelatedProduct__c,ccrz__RelatedProduct__r.Id,ccrz__RelatedProduct__r.Name,ccrz__Product__r.Name,ccrz__Product__r.Id from ccrz__E_RelatedProduct__c where ccrz__Product__c=:ccProductId and ccrz__RelatedProductType__c='SupersededProduct'];
            }
            System.debug('productlistHere-->'+productlist);
        }
        catch(Exception e){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return productlist;
    }
    
    //Method param added by malhar -4/12/2020 for store toggling
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_Product__c> getPromotionProducts(string urlParam){
        List<ccrz__E_Coupon__c> lstOfCoupan = new List<ccrz__E_Coupon__c>();
        List<ccrz__E_ProductSpec__c> lstOfSpec = new List<ccrz__E_ProductSpec__c>();
        List<ccrz__E_Product__c> lstOfProSpec = new List<ccrz__E_Product__c>();
        List<String> specIds = new List<String>();
        List<String> pSpecIds = new List<String>();
        lstOfCoupan = [Select id,ccrz__CouponName__c, ccrz__TargetSpec__c from ccrz__E_Coupon__c where DBU_Promotion__c = true];
        system.debug('lstOfCoupan ' + lstOfCoupan);
        for(ccrz__E_Coupon__c obj :  lstOfCoupan){
            specIds.add(obj.ccrz__TargetSpec__c);
        }//a3O19000000X9D9EAK
        lstOfSpec = [select id,ccrz__Product__c from ccrz__E_ProductSpec__c where ccrz__Spec__c IN :  specIds ];
        system.debug('lstOfSpec ' + lstOfSpec);
        for(ccrz__E_ProductSpec__c pSpec : lstOfSpec){
            pSpecIds.add(pSpec.ccrz__Product__c);
        }
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);
        
        string currencyISOvalue = (string)countryCurrencyMap.get(urlParam); 
        system.debug('urlParam>>' +urlParam);
        system.debug('currencyISOvalue' +currencyISOvalue); 
        List<String> urlStoreLoc = new List<String>{urlParam};
            
            //following query modified by malhar for store toggling of location - 4/12/2020
            lstOfProSpec = [select id, name,dbu_Image_Src__c,(select id,ccrz__Price__c,ccrz__Pricelist__c,ccrz__Pricelist__r.ccrz__CurrencyISOCode__c,dbu_Original_Price__c from ccrz__E_PriceListItems__r Where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue),(select id, ccrz__URI__c from ccrz__E_ProductMedias__r limit 1) from ccrz__E_Product__c where  DBU_Product_Location__c INCLUDES (:urlParam)  and Group_Name__c='Ecom' and  id IN : pSpecIds];
        // lstOfProSpec = [select id,ccrz__Product__c from ccrz__E_ProductSpec__c where id IN :  pSpecIds];
        system.debug('lstOfProSpec ' + lstOfProSpec);
        return lstOfProSpec;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_ProductInvWrapper> getProductInventoryDetails(string urlParam,string storeLocation){
        List<dbu_ProductInvWrapper> productInvDataWrapper = new List<dbu_ProductInvWrapper>();
        try{
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    productId=productId.substring(0,15);
                    productInvDataWrapper = dbu_callCCApi.productInventoryDetails(productId,storeLocation);
                    
                }
            }
        }catch (Exception ex){
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        return productInvDataWrapper;
    }
    
    @AuraEnabled(cacheable=true)
        public static Map<String,Object> fetchGenuineCumminsParts(String locationCode) {
            System.debug('locationCode>>>>>>>>>>>>>>>>>'+locationCode);
            Map<String,Object> productMap = new  Map<String,Object>();
            Map<string,string> CategoryMap = new map<string,string>();//Added CECI-958
             Map<string,string> BrandMap = new map<string,string>();//Added CECI-958
    
            String gCPId = [SELECT Id FROM ccrz__E_Category__c WHERE Name = 'Cummins Genuine Parts' LIMIT 1][0].Id;
            List<ccrz__E_Category__c> categoryIds = [SELECT Id FROM ccrz__E_Category__c WHERE ccrz__ParentCategory__c=:gCPId];
            
            list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
            List<ccrz__E_ProductCategory__c> prodCatList = new List<ccrz__E_ProductCategory__c>();
            set<Id> prdCatSet = new set<Id>();
            
            prodCatList = [Select id,ccrz__Product__c 
                            from ccrz__E_ProductCategory__c 
                            WHERE ccrz__Product__r.ccrz__ProductStatus__c = 'Released' and 
                            ccrz__Product__r.ccrz__Storefront__c = 'CSSNAStore' and 
                            ccrz__Product__r.Group_Name__c = 'Ecom'  and 
                            ccrz__Product__r.ccrz__ProductType__c = 'Product' and 
                            ccrz__Product__r.DBU_Product_Location__c INCLUDES (:locationCode) and
                           ccrz__Category__r.Storefront__c = 'CSSNAStore' and
                            ccrz__Category__c IN : categoryIds LIMIT 50 ];
            
            if(prodCatList != null){
                for(ccrz__E_ProductCategory__c prdCatRec:prodCatList){
                    if(prdCatRec.ccrz__Product__c != null){
                        prdCatSet.add(prdCatRec.ccrz__Product__c);
                    }
                }
            }
            //CECI-960 getting promo, discount and Core charge
            string countryCode;
            if(locationCode == 'US')
            {
                countryCode = 'US';
            }
            else if (locationCode == 'EN' || locationCode == 'FR')
            {
                countryCode = 'EN';
            } else if(locationCode == 'CA'){
                countryCode = 'EN';
            }
            
          
            
            //Convert set of ID to set of String to match the function param
            Set<String> pIdList = new Set<String>();
            pIdList = (Set<String>)JSON.deserialize(JSON.serialize(prdCatSet), Set<String>.class);
            Map<String,String> coreProductMap = new  Map<String,String>();
            list<string> prodsplitdata = new list<string>();
            //get the country cureency iso mapping from custom settings
            Map<string,string> countryCurrencyMap = new Map<string,string>();
            for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
            }
            system.debug('countryCurrencyMap > ' + countryCurrencyMap);
            
            string currencyISOvalue = (string)countryCurrencyMap.get(locationCode);         
                    coreProductMap = fetchcorepricebyproductid(pIdList, currencyISOvalue);
    
            try{
                if(prdCatSet <> null){
                    lstproduct = [select id, name,dbu_Image_Src__c,ccrz__AverageRating__c,ccrz__Quantityperunit__c,
                    dbu_Has_Core_Charge__c,ccrz__SKU__c,
                    (select name, ccrz__ImageURI__c, ccrz__Category__r.Name from ccrz__Promotions__r  
                         WHERE ccrz__Enabled__c = true 
                         AND ccrz__EndDate__c >= today
                         AND ccrz__StartDate__c <= today
                         AND ccrz__Storefront__c = 'CSSNAStore'
                         AND dbu_store_location__c INCLUDES (:countryCode)
                         LIMIT 1), 
                    (select id,ccrz__Price__c,dbu_Original_Price__c,dbu_Discount_Percent__c from ccrz__E_PriceListItems__r 
                                where  ccrz__Price__c != null AND ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue limit 1),
                    (select id, ccrz__URI__c from ccrz__E_ProductMedias__r  limit 1) 
                                    from ccrz__E_Product__c where name != null AND ID IN:prdCatSet AND Group_Name__c='Ecom' 
                                    
                                    Order By createdDate desc Limit 50];
                }
                CategoryMap=getcategoryfromproductid(pIdList,countryCode);//Added CECI-958
                 BrandMap=getBrandfromproductid(pIdList,countryCode);//Added CECI-958

                productMap.put('productData',lstproduct);
                productMap.put('corePrice',coreProductMap);
                productMap.put('categorydata',CategoryMap);//Added CECI-958
                productMap.put('branddata',BrandMap);//Added CECI-958
                
            }catch (Exception ex){
                System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
            }
    
    
            return productMap;
        }
        
    @AuraEnabled(cacheable=true)
    public static String fetchCategoryID() {
        
        String gCPId = [SELECT Id FROM ccrz__E_Category__c WHERE Name = 'Cummins Genuine Parts' LIMIT 1][0].Id;
        if(gCPId != null){
            return gCPId;
        }else{
            return null;
        }
        
        
    }
    
    
    //added by saikomal
    @AuraEnabled(cacheable=true)
    public static string showwarrenty(String urlParam){
        List<ccrz__E_ProductCategory__c> productcategory = new List<ccrz__E_ProductCategory__c>();
        List<ccrz__E_Category__c > parentcategory = new List<ccrz__E_Category__c >();
        List<ccrz__E_Category__c > grandparentcategory = new List<ccrz__E_Category__c >();
        // set<string> parentcat = new set<string>();
        // set<string> grandparentcat = new set<string>();
        set<id> parentcatset = new set<id>();
        set<id> grandparentcatset = new set<id>();
        string enablewarrenty = '';
        try{
            
            if(String.isNotBlank(urlParam)){
                ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                Map<String, String> params = ref.getParameters();
                System.debug('SimilarProducts?????????\t'+params.size());
                if(params.size() > 0 && params.containsKey('pId')){
                    string productId = params.get('pId');
                    if(productId!=''){
                        productcategory =[select id,name,ccrz__Product__c,ccrz__Category__r.name
                                            from ccrz__E_ProductCategory__c where ccrz__Product__c =:productId];
                        if(productcategory!=null && productcategory.size()>0){
                            for(ccrz__E_ProductCategory__c category :productcategory){
                                // parentcat.add(category.ccrz__Category__r.name);
                                parentcatset.add(category.ccrz__Category__r.id);
                            }
                            parentcategory=[select Id, Name,ccrz__ParentCategory__r.name FROM ccrz__E_Category__c WHERE Id IN:parentcatset];
                            system.debug('parentcategory'+parentcategory);
                            if(parentcategory!=null && parentcategory.size()>0){
                                for(ccrz__E_Category__c grandcategory :parentcategory){
                                    // grandparentcat.add(grandcategory.ccrz__ParentCategory__r.name);
                                    grandparentcatset.add(grandcategory.ccrz__ParentCategory__r.Id);
                                }
                            }
                            
                            grandparentcategory=[select Id, Name,ccrz__ParentCategory__r.name FROM ccrz__E_Category__c WHERE Id IN:grandparentcatset];
                            
                            for(ccrz__E_Category__c grand:grandparentcategory ){
                                if(grand.Name == 'Battery'||grand.Name == 'Cummins Batteries' ){
                                    enablewarrenty ='Battery' ;
                                }
                                else if(grand.Name =='Cummins Fluid Analysis' || grand.Name =='Cummins merchandise'){
                                    enablewarrenty = 'valpower';
                                }
                                else if (grand.ccrz__ParentCategory__r.Name=='Webasto'){
                                    enablewarrenty = 'Webasto';
                                }
                                else if(grand.ccrz__ParentCategory__r.Name=='Valvoline'|| grand.ccrz__ParentCategory__r.Name=='Power Service'){
                                    enablewarrenty = 'valpower';
                                }
                                else{
                                    enablewarrenty = 'false';   
                                }
                            }
                            
                        }
                        
                        system.debug('enablewarrenty'+enablewarrenty);
                    }
                    
                }
            }
            
        }
        
        
        catch(exception e){
            system.debug('exception line number '+e.getLineNumber()+'exception message'+e.getMessage());
        }
        return enablewarrenty;
    }
    
    }