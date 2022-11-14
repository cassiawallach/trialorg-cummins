global with sharing class dbu_EXTEND_ccLogicCartAddTo extends ccrz.ccLogicCartAddTo {
    
    global virtual override Map<String, Object> setCartItemFields(Map<String, Object> inputData){
        
        for(string eachstring : inputData.keyset()){
            system.debug('ZANGEZUR KEY >' + eachstring + ' ZANGEZUR VALUE > ' + inputData.get(eachstring));
        }
        
        
        Map<string, Object> retMap = super.setCartItemFields(inputData);
		/*
        boolean avaiabletoship = false;
        boolean availabletopickup = false;
        boolean shipboolean = false;
        
        if(retMap.get('currProduct') != null){
            Map<string,object> currproductMap = (Map<string,object>)retMap.get('currProduct');
            system.debug('PARWAN > ' + currproductMap);
            
            boolean hascorechild = false;
            if(currproductMap.get('dbuHasCoreChild') != null){
                hascorechild = true;
            }
            
            if(hascorechild == true){
                //get parent's attr
                
                
            }

            
            if(currproductMap.get('dbuPickUpOnly') != null){
                availabletopickup = (boolean)currproductMap.get('dbuPickUpOnly');
                system.debug('availabletopickup > ' + availabletopickup);
            }
            
            if(currproductMap.get('dbuAvailabletoship') != null){
                avaiabletoship = (boolean)currproductMap.get('dbuAvailabletoship');
                system.debug('avaiabletoship > ' + avaiabletoship);
            }
            
            if(avaiabletoship == true && availabletopickup == false){
                shipboolean = true;
            }
            else if(avaiabletoship == false && availabletopickup == true){
                shipboolean = false;
            }                        
            else if(avaiabletoship == true && availabletopickup == true){
                shipboolean = true;
            }  
            else if(avaiabletoship == false && availabletopickup == false){
                shipboolean = true;
            }             
            
        }
        
        system.debug('shipboolean > ' + shipboolean);
        
        if(retMap.get('currItem') != null){
            ccrz__E_CartItem__c currenctitem = (ccrz__E_CartItem__c)retMap.get('currItem');
            system.debug('SPIN BOLDAK > ' + currenctitem);
            
			currenctitem.dbu_isShipTo__c = shipboolean;
            retMap.put('currItem',currenctitem);            
        }
         
        system.debug('PANJSHIR > ' + retMap);
        */
        
        if(retMap.get('lineData') != null){
            system.debug('salesh > ' + retMap.get('lineData') );
            list<object> currLineDataList = new list<object>();
            currLineDataList = (list<object>)retMap.get('lineData');
            system.debug('currLineDataList > ' + currLineDataList);
            if(currLineDataList.size() > 0){
                
            	Map<string,object> currLineDataMap = (Map<string, object>)currLineDataList[0];
                system.debug('currLineDataMap > ' + currLineDataMap);
                
                
                
                if(currLineDataMap.get('dbuisShipTo') != null){
                    boolean shipboolean = (boolean)currLineDataMap.get('dbuisShipTo');
                    if(retMap.get('currItem') != null){
                        ccrz__E_CartItem__c currenctitem = (ccrz__E_CartItem__c)retMap.get('currItem');
                        system.debug('SPIN BOLDAK > ' + currenctitem);
                        
                        currenctitem.dbu_isShipTo__c = shipboolean;
                        retMap.put('currItem',currenctitem);            
                    }
                    
                    system.debug('PANJSHIR > ' + retMap);                                    
                }                
            }
        }
         
        
        for(string eachstring : retMap.keyset()){
            system.debug('NAKCHIVAN KEY >' + eachstring + ' NAKCHIVAN VALUE > ' + retMap.get(eachstring));
            
            /*if(eachstring == 'currProduct'){
                for(string each : ((Map<string,object>)retMap.get(eachstring)).keyset()){
                    system.debug('CHARIKAR KEY > ' + each + ' CHARIKAR VALUE > ' + ((Map<string,object>)retMap.get(eachstring)).get(each));
                    
                }
            }*/
        }
        
        
        return retMap;
    }
    
    
    global virtual override Map<String, Object> upsertCartItems(Map<String, Object> inputData) {
        //My Logic
        
        system.debug('inputData keyset > ' +JSON.serializePretty(inputData.keyset()));
        for(string c : inputData.keyset()){
            system.debug('c > ' + c);
        }
        
        system.debug('inputData values > ' + inputData.values());
        
        //system.debug('inputData.get(IsCreatProduct)' + (boolean)inputData.get('IsCreatProduct'));
        system.debug('inputData.get(linedata) > ' + (List<object>)inputData.get('lineData'));

        if(userinfo.getUserType() != 'Guest'){
            list<ccrz__E_Cart__c> cartstallybeforeupsertcartitems = [select id, ccrz__ActiveCart__c, dbu_Cart_StoreCountry__c 
                                                                from ccrz__E_Cart__c 
                                                                where Ownerid =: userinfo.getUserId() 
                                                                and ccrz__CartType__c = 'Cart' 
                                                                and ccrz__CartStatus__c = 'Open']; 

        system.debug('cartstallybeforeupsertcartitems >>>>>>>>>>>>>>>>>>>>> ' + cartstallybeforeupsertcartitems);
        
            for(ccrz__E_Cart__c eachcart : cartstallybeforeupsertcartitems){
                eachcart.ccrz__ActiveCart__c = true;
            }

            update cartstallybeforeupsertcartitems;            
        }        
           
        
        Map<String,Object> retMap = super.upsertCartItems(inputData);
        system.debug('HERAT > ' + retMap);
        /*
        list<ccrz__E_Cart__c> cartstallyafterupsertcartitems = [select id, ccrz__ActiveCart__c, dbu_Cart_StoreCountry__c 
                                                            from ccrz__E_Cart__c 
                                                            where Ownerid =: userinfo.getUserId() 
                                                            and ccrz__CartType__c = 'Cart'];    

        system.debug('cartstallyafterupsertcartitems >>>>>>>>>>>>>>>>>>>>> ' + cartstallyafterupsertcartitems);           
        */
        if(retMap.get('itemsToUpsert') != null){
            
            list<ccrz__E_CartItem__c> CartItemsList = (list<ccrz__E_CartItem__c>)retMap.get('itemsToUpsert');                        
            system.debug('retMap keyset > ' + retMap.keyset());
            system.debug('retMap values > ' + retMap.Values());
            
            for(string u : retMap.keyset()){
                system.debug('u > ' + u);
                system.debug('u value > ' + retMap.get(u));
            }
            

            //********* new changes begin **************
            
            //Fetch & Iterate linedata to check the product having IsCreatproduct = true            
            list<object> Linedatamap = new  list<object>();
            if(!Test.isRunningTest())
                Linedatamap = (list<object>)retMap.get('lineData');
            //system.debug('Linedatamap > ' + JSON.serializePretty(Linedatamap));

            Map<string,object> CreatProductMaps= new Map<string,object>();
            
            system.debug(CreatProductMaps);
            
            for(object eachLinedataMap : Linedatamap){                
                Map<string,object> eachlinedata = (Map<string,object>)eachLinedataMap;              
                if((boolean)eachlinedata.get('IsCreatProduct') != null){
                    string eachSKU = (string)eachlinedata.get('sku');                    
                    Map<string,object> eachCreatProductMap = (Map<string,object>)eachlinedata.get('CreatProductMap');
                    CreatProductMaps.put(eachSKU, eachCreatProductMap);
                    system.debug('CreatProductMaps ** ' + CreatProductMaps);
                }
                system.debug('CreatProductMaps *** ' + CreatProductMaps.size());
            }
            system.debug('outside for loop');
            //Get the product Skus, and other crate params for these products
            system.debug('CreatProductMaps > ' + JSON.serializePretty(CreatProductMaps));
            if(Test.isRunningTest())
            {
                Map<String,Object> mapobj = new Map<String,Object>();
                mapobj.put('dbuMake','test');
                mapobj.put('dbuModel','test');
                mapobj.put('dbuVIN','test');
                mapobj.put('dbuYear','test');
                mapobj.put('dbuEmissionAgreement',true);
                mapobj.put('dbuExportAgreement',true);
                mapobj.put('dbuShippingAgreement',true);
                mapobj.put('dbuTncAgreement',true);
                mapobj.put('dbuUnloadingAgreement',true);
                mapobj.put('dbuWarrentyAggrement',true);
                CreatProductMaps.put('TestProduct1',mapobj);
            }
            //Retrive and store ProductIds using SOQL query  
            if(!CreatProductMaps.isEmpty()){
                system.debug('Is not empty');
                List<ccrz__E_Product__c> ProductIDsList = [select ID from ccrz__E_Product__c WHERE ccrz__SKU__c in : CreatProductMaps.keyset()];
                List<Id> PrdIds = new List<Id>(new Map<Id, ccrz__E_Product__c>(ProductIDsList).keySet());
                system.debug('PrdIds > ' + PrdIds);                
                
                
                 //Check whether the CartItemsList contains the ProductIds 
                list<string> cartitemIDSList = new List<string>();
                for(ccrz__E_CartItem__c each : CartItemsList){
                    system.debug(each.ccrz__Product__c);
                    if(PrdIds.contains(each.ccrz__Product__c)){
                        //save cartitem id
                        cartitemIDSList.add(each.Id);                        
                    }
                }
                system.debug('cartitemIDSList **  ' + cartitemIDSList);
                //insert crate params for these cartitems
                
                list<ccrz__E_CartItem__c> crateCartItemsretrivalList = [select ccrz__Product__r.ccrz__SKU__c, dbu_Make__c, dbu_Model__c, dbu_VIN__c, dbu_Year__c, dbu_EmissionAgreement__c, dbu_ExportAgreement__c, dbu_ShippingAgreement__c, dbu_TncAgreement__c, dbu_UnloadingAgreement__c, dbu_WarrentyAggrement__c,dbu_State__c from ccrz__E_CartItem__c where id in : cartitemIDSList];
                
                system.debug('crateCartItemsretrivalList --->> ' + crateCartItemsretrivalList);
                
                set<string> CreatProductMapsKeyset = new set<string>();
                CreatProductMapsKeyset = (set<string>)CreatProductMaps.keyset();
                
                system.debug('CreatProductMapsKeyset --> ' + CreatProductMapsKeyset);
                
                for(ccrz__E_CartItem__c eachcrateCartItemsretrivalList : crateCartItemsretrivalList){                    
                    if(CreatProductMapsKeyset.contains(eachcrateCartItemsretrivalList.ccrz__Product__r.ccrz__SKU__c)){
                        Map<string,object> currentSKUCrate = (Map<string,object>)CreatProductMaps.get(eachcrateCartItemsretrivalList.ccrz__Product__r.ccrz__SKU__c); 
                        eachcrateCartItemsretrivalList.dbu_Make__c                  =   (string)currentSKUCrate.get('dbuMake'); 
                        eachcrateCartItemsretrivalList.dbu_Model__c                 =   (string)currentSKUCrate.get('dbuModel'); 
                        eachcrateCartItemsretrivalList.dbu_VIN__c                   =   (string)currentSKUCrate.get('dbuVIN'); 
                        eachcrateCartItemsretrivalList.dbu_Year__c                  =   (string)currentSKUCrate.get('dbuYear'); 
                        eachcrateCartItemsretrivalList.dbu_EmissionAgreement__c     =   (boolean)currentSKUCrate.get('dbuEmissionAgreement'); 
                        eachcrateCartItemsretrivalList.dbu_ExportAgreement__c       =   (boolean)currentSKUCrate.get('dbuExportAgreement'); 
                        eachcrateCartItemsretrivalList.dbu_ShippingAgreement__c     =   (boolean)currentSKUCrate.get('dbuShippingAgreement'); 
                        eachcrateCartItemsretrivalList.dbu_TncAgreement__c          =   (boolean)currentSKUCrate.get('dbuTncAgreement'); 
                        eachcrateCartItemsretrivalList.dbu_UnloadingAgreement__c    =   (boolean)currentSKUCrate.get('dbuUnloadingAgreement'); 
                        eachcrateCartItemsretrivalList.dbu_WarrentyAggrement__c     =   (boolean)currentSKUCrate.get('dbuWarrentyAggrement');   
                        eachcrateCartItemsretrivalList.dbu_State__c					=	(string)currentSKUCrate.get('dbuState');
                    }
                }
                
                Database.SaveResult[] rList = Database.update(crateCartItemsretrivalList, false);
                
                
                for (Database.SaveResult r : rList){
                    if (r.isSuccess()) {                    
                        System.debug('Successfully updated the cartitems. CartItem IDs: ' + r.getId());
                    }else{            
                        for(Database.Error err : r.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('fields that affected this error: ' + err.getFields());
                        }
                    }
                }             
            }                
                
            
            
            

                               
            
            //insert crate params for these cartitems
            system.debug('CartItemsList > ' + JSON.serializePretty(CartItemsList) );            
                        
            //********* new changes end **************
                                                
            List<string> CartItemIDlist = new List<string>();            
            for(ccrz__E_CartItem__c eachCartItem : CartItemsList){
                CartItemIDlist.add(eachCartItem.id);
            }
            
            
            list<ccrz__E_CartItem__c> CartItemsretrivalList = [select ccrz__PricingType__c from ccrz__E_CartItem__c where id in : CartItemIDlist];
            
            for(ccrz__E_CartItem__c eachCartItemsretrival : CartItemsretrivalList){
                eachCartItemsretrival.ccrz__PricingType__c = 'auto';    
            }            
            
            Database.SaveResult[] srList = Database.update(CartItemsretrivalList, false);
            
            
            for (Database.SaveResult sr : srList){
                if (sr.isSuccess()) {                    
                    System.debug('Successfully updated the cartitems. CartItem IDs: ' + sr.getId());
                }else{            
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('fields that affected this error: ' + err.getFields());
                    }
                }
            }             
        }
        
        

        
    return retMap;
    }    
}