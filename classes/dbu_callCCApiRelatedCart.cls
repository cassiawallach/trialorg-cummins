/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class dbu_callCCApiRelatedCart {
    
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_CCApiCartRelatedResponseWrapper> getProductList(List<String> productIdList){
        system.debug('productIdList>>' +productIdList);
        Set<Id> prodIdSet = new Set<ID>();
        
        List<ccrz__E_Product__c> productListByID = new List<ccrz__E_Product__c>();
        Boolean shipAvailable ;
        Boolean returnable ;
        Boolean pickUpOnlyProduct ;
        //added by Saikomal for crate engine 
        Boolean crateEngine;
        for(String productIDRec: productIdList){
            prodIdSet.add(productIDRec);
        }
        system.debug('prodIdSet>>' +prodIdSet);
        // If(prodIdSet != null)
        productListByID = [Select id,dbu_Available_to_ship__c,dbu_Non_Returnable__c,dbu_Crate_Engine__c,dbu_Pick_Up_Only__c from ccrz__E_Product__c 
        where id = :prodIdSet];
        system.debug('productListByID' +productListByID);
        for(ccrz__E_Product__c productBooleanData : productListByID){
            if(productBooleanData.dbu_Available_to_ship__c){
                shipAvailable = true;
            }else{
                shipAvailable = false; 
                
            }
            if(productBooleanData.dbu_Non_Returnable__c){
                returnable = true;
            }else{
                returnable = false;
            }
            if(productBooleanData.dbu_Pick_Up_Only__c){
                pickUpOnlyProduct = true;
            }else{
                pickUpOnlyProduct = false;
            }
             if(productBooleanData.dbu_Crate_Engine__c){
                crateEngine = true;
            }else{
                crateEngine = false;
            }
        }
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPIProduct.PRODUCTIDLIST => productIdList,
                ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccAPI.SIZING => new Map<String, Object>{
                    
                    ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                        ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                            }       
                }
        };
            list<dbu_CCApiCartRelatedResponseWrapper> wrapperlist = new list<dbu_CCApiCartRelatedResponseWrapper>();    
        Map<String, Object> outputData = ccrz.ccAPIProduct.fetch(inputData);
        System.debug('?????\t'+outputData);
        if (outputData.get(ccrz.ccAPIProduct.PRODUCTLIST) != null) {
            
            List<Map<String, Object>> outputProductList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIProduct.PRODUCTLIST);
            for(Map<String, Object> myProduct:outputProductList)
            {
                dbu_CCApiCartRelatedResponseWrapper wrapper = new dbu_CCApiCartRelatedResponseWrapper();
                String sfid = (String)myProduct.get('sfid');
                wrapper.SKU =(String)myProduct.get('SKU');
                wrapper.sfdcName = (String)myProduct.get('sfdcName');
                wrapper.sfid = (String)myProduct.get('sfid');
                system.debug('wrapper.sfid'+wrapper.sfid);  
                system.debug('productListByID.sfid'+productListByID); 
               
                for(ccrz__E_Product__c prod :productListByID){
                    if(wrapper.sfid == prod.id){
                        system.debug('inside if equal id'+prod.Id);
                        system.debug('inside if equal id');
                     wrapper.availableToShip = prod.dbu_Available_to_ship__c;
                     wrapper.nonReturnable = prod.dbu_Non_Returnable__c;
                     wrapper.pickUpOnly = prod.dbu_Pick_Up_Only__c; 
                        wrapper.dbuCrateEngine = prod.dbu_Crate_Engine__c;
                } 
                }
               
               
               // system.debug('availableToShip' +wrapper.availableToShip);
               
               // system.debug('pickUpOnly' +wrapper.pickUpOnly);
               
                List<Map<String,Object >> productMedia = (List<Map<String,Object >>)myProduct.get('EProductMediasS');
                
                if(productMedia!=null && productMedia.size()>0){
                    for(Map<String,Object> ob : productMedia)
                    {
                        if('Product Search Image' == (String)ob.get('mediaType'))
                        {
                            wrapper.URI = (String)ob.get('URI');
                            system.debug('Uri in api related if ' + ob.get('URI'));
                        }else{
                            system.debug('Uri in api related else ' + ob.get('URI'));
                            wrapper.URI = (String)ob.get('URI');
                        }
                    }
                }
                wrapperlist.add(wrapper);
            }        
        }
        return wrapperlist;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String,dbu_CCApiCartRelatedResponseWrapper> getProductMap(List<String> productIdList,String currencyCode){   
                system.debug('productIdListCart>>' +productIdList);
        Set<Id> prodIdSet = new Set<ID>();
       Set<String> pIdList=new set<String>();//Added CECI-958
        Map<string,string> CategoryMap = new map<string,string>();//Added CECI-958
        Map<string,string> BrandMap = new map<string,string>();//Added CECI-958
        List<ccrz__E_Product__c> productListByID = new List<ccrz__E_Product__c>();
        Boolean shipAvailable = false;
        Boolean returnable = false;
        Boolean pickUpOnlyProduct = false;
        for(String productIDRec: productIdList){
            prodIdSet.add(productIDRec);
            pIdList.add(productIDRec);
        }
         //START CECI-958
        string locationcode;
        if(currencyCode=='USD')
        {
            locationcode='US';
        }
        else if(currencyCode=='CAD')
        {
            locationcode='EN';
        }

       
        if(pIdList!=null && pIdList.size()>0 )
        {
        CategoryMap=dbu_ProductCtrl.getcategoryfromproductid(pIdList,locationcode);//Added CECI-958
        system.debug('CategoryMap'+CategoryMap);
        BrandMap=dbu_ProductCtrl.getBrandfromproductid(pIdList,locationcode);//Added CECI-958
        system.debug('BrandMap'+BrandMap);
        }
        //END CECI-958
        system.debug('prodIdSet>>' +prodIdSet);
        // If(prodIdSet != null)
         productListByID = [Select id,
         (select id,name, ccrz__Category__r.Name from ccrz__Promotions__r  
         WHERE ccrz__Enabled__c = true 
         AND ccrz__EndDate__c >= today 
         AND ccrz__StartDate__c <= today
         AND ccrz__Storefront__c = 'CSSNAStore' AND dbu_store_location__c INCLUDES (:locationcode) ),
         (select id, name, ccrz__Price__c, dbu_Original_Price__c, dbu_Discount_Percent__c from ccrz__E_PriceListItems__r WHERE ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyCode LIMIT 1),
        dbu_Available_to_ship__c,dbu_Non_Returnable__c,dbu_Crate_Engine__c,dbu_Pick_Up_Only__c,dbu_Has_Core_Charge__c,dbu_Has_Core_Child__c,dbu_FullPartNumber__c,dbu_Part_Number__c,dbu_Product_Code__c 
        from ccrz__E_Product__c where id = :prodIdSet];      
        system.debug('productListByID' +productListByID);
        for(ccrz__E_Product__c productBooleanData : productListByID){
            if(productBooleanData.dbu_Available_to_ship__c){
                shipAvailable = true;
            }else{
                shipAvailable = false; 
                
            }
            if(productBooleanData.dbu_Non_Returnable__c){
                returnable = true;
            }else{
                returnable = false;
            }
            if(productBooleanData.dbu_Pick_Up_Only__c){
                pickUpOnlyProduct = true;
            }else{
                pickUpOnlyProduct = false;
            }
        }
        Map<String, Object> inputData = new Map<String, Object>{
            ccrz.ccAPIProduct.PRODUCTIDLIST => productIdList,
                ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccAPI.SIZING => new Map<String, Object>{
                    
                    ccrz.ccAPIProduct.ENTITYNAME => new Map<String, Object>{
                        ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                            }       
                }
        };
            Map<String, dbu_CCApiCartRelatedResponseWrapper> wrapperMap = new Map<String,dbu_CCApiCartRelatedResponseWrapper>();    
        Map<String, Object> outputData = ccrz.ccAPIProduct.fetch(inputData);
        if (outputData.get(ccrz.ccAPIProduct.PRODUCTLIST) != null) {
            system.debug('PRODUCTLIST'+outputData);
            List<Map<String, Object>> outputProductList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIProduct.PRODUCTLIST);
                        system.debug('outputProductList'
                                    +outputProductList);

             
            for(Map<String, Object> myProduct:outputProductList){
                dbu_CCApiCartRelatedResponseWrapper wrapper = new dbu_CCApiCartRelatedResponseWrapper();
                String sfid = (String)myProduct.get('sfid');
                SYSTEM.DEBUG('Insidesku'+sfid);
                wrapper.SKU =(String)myProduct.get('SKU');
                wrapper.sfdcName = (String)myProduct.get('sfdcName');
                wrapper.sfid = (String)myProduct.get('sfid');
                //START CECI-958
                if(BrandMap.containsKey(sfid))
                {
                    SYSTEM.DEBUG('Inside'+BrandMap.get(sfid));
                   wrapper.Brandname=BrandMap.get(sfid);
                }

                if(CategoryMap.containsKey(sfid))
                {
                   wrapper.Categoryname=CategoryMap.get(sfid);
                }
                //END CECI-958
                System.debug('myProduct.get=>productInventoryItemsS'+myProduct.get('productInventoryItemsS'));
                List<Map<String,Object >> objInvMap= (List<Map<String,Object >>)myProduct.get('productInventoryItemsS');
                if(objInvMap != null && objInvMap.size() > 0 &&  objInvMap[0].get('qtyAvailable') != null){
                     //wrapper.qtyAvailable = (Integer)objInvMap[0].get('qtyAvailable');
                     wrapper.qtyAvailable = (Decimal)objInvMap[0].get('qtyAvailable');
                     System.debug('wrapper.qtyAvailable'+wrapper.qtyAvailable);
                }
                 for(ccrz__E_Product__c prod :productListByID){
                    if(wrapper.sfid == prod.id){
                        system.debug('inside if equal id'+prod.Id);
                        system.debug('inside if equal id');
                     wrapper.availableToShip = prod.dbu_Available_to_ship__c;
                     wrapper.nonReturnable = prod.dbu_Non_Returnable__c;
                     wrapper.pickUpOnly = prod.dbu_Pick_Up_Only__c; 
                     wrapper.dbuCrateEngine = prod.dbu_Crate_Engine__c;
                     wrapper.FullPartNumber = prod.dbu_FullPartNumber__c;
                     wrapper.partNumber = prod.dbu_Part_Number__c; 
                     wrapper.productCode = prod.dbu_Product_Code__c;
                     
                     if(prod.dbu_Has_Core_Charge__c && prod.dbu_Has_Core_Child__c == True){
                        wrapper.isCoreProduct = true; 
                    }else{	
                        wrapper.isCoreProduct = false; 
                        if(prod.ccrz__Promotions__r.size() > 0){
                            wrapper.promotionTag = prod.ccrz__Promotions__r[0].ccrz__Category__r.Name;
                        }
                        if(prod.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c != null){
                            wrapper.discountPercentage = Integer.valueOf(prod.ccrz__E_PriceListItems__r[0].dbu_Discount_Percent__c.round(System.RoundingMode.HALF_EVEN));
                        }
                        if(prod.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c != null){
                            wrapper.originalPrice = prod.ccrz__E_PriceListItems__r[0].dbu_Original_Price__c;
                        }
                    }
                   

                } 
                }
               // wrapper.availableToShip = shipAvailable;
               // system.debug('availableToShip' +wrapper.availableToShip);
               // wrapper.nonReturnable = returnable;
               // wrapper.pickUpOnly = pickUpOnlyProduct;  
                List<Map<String,Object >> productMedia = (List<Map<String,Object >>)myProduct.get('EProductMediasS');
                if(productMedia!=null && productMedia.size()>0){
                    for(Map<String,Object> ob : productMedia){
                        if('Product Image' == (String)ob.get('mediaType')){
                            wrapper.URI = (String)ob.get('URI');
                            system.debug('Uri in api related if ' + ob.get('URI'));
                        }
                        /*else{
                            system.debug('Uri in api related else ' + ob.get('URI'));
                            wrapper.URI = (String)ob.get('URI');
                        }*/
                    }
                }
                wrapperMap.put(sfid, wrapper);
            }        
        }
        SYSTEM.DEBUG('Testdata'+wrapperMap);
        return wrapperMap;
    }
}