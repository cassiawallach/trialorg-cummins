global with sharing class dbu_EXTEND_ccLogicCartCreate extends ccrz.ccLogicCartCreate{
    
    global virtual override Map<String, Object> createCarts(Map<String, Object> InputData){
        
        system.debug('inputData keyset() > ' + InputData.keySet());
        system.debug('inputData values() > ' + InputData.values());
        
        for(string str :  InputData.keySet()){
            system.debug('i/p > ' + str + ' ======> ' +  InputData.get(str));
        }
        
        
        //List<Map<String, Object>> cartObjList = new List<Map<String, Object>>();
        //cartObjList = (List<Map<String, Object>>)InputData.get(ccrz.ccApiCart.CART_OBJLIST);
        //system.debug('cartObjList > ' + cartObjList);
        
        Map<String, Object> CartTransformIndexMap = new Map<String, Object>();
                
        CartTransformIndexMap = (Map<String, Object>)InputData.get(ccrz.ccService.TRANSFORMINDEX);
        system.debug('CartTransformIndexMap before > ' + CartTransformIndexMap);
        system.debug('CartTransformIndexMap dbu_Cart_StoreCountry__c before > ' +  CartTransformIndexMap.get('dbuCartStoreCountry'));
        
        ((Map<String, Object>)InputData.get(ccrz.ccService.TRANSFORMINDEX)).put('dbuCartStoreCountry' , 'dbu_Cart_StoreCountry__c');
        ((Map<String, Object>)InputData.get(ccrz.ccService.TRANSFORMINDEX)).put('dbustoreLanguage' , 'dbu_storeLanguage__c');
        
        CartTransformIndexMap = (Map<String, Object>)InputData.get(ccrz.ccService.TRANSFORMINDEX);
        system.debug('CartTransformIndexMap before > ' + CartTransformIndexMap);
        system.debug('CartTransformIndexMap dbu_Cart_StoreCountry__c before > ' +  CartTransformIndexMap.get('dbuCartStoreCountry'));
        system.debug('CartTransformIndexMap dbu_storeLanguage__c before > ' +  CartTransformIndexMap.get('dbustoreLanguage'));
        
        Map<string,object> RetMap = super.createCarts(InputData);
        
        list<ccrz__E_Cart__c> cartstallyaftercreatecarts = [select id, ccrz__ActiveCart__c, dbu_Cart_StoreCountry__c,dbu_storeLanguage__c 
                                                            from ccrz__E_Cart__c 
                                                            where Ownerid =: userinfo.getUserId() 
                                                            and ccrz__CartType__c = 'Cart'];
        
		system.debug('cartstallyaftercreatecarts >>>>>>>>>> ' + cartstallyaftercreatecarts);
        //system.debug('RetMap keyset() > ' + RetMap.keySet());
        //system.debug('RetMap values() > ' + RetMap.values());
        /*
        for(string strr :  RetMap.keySet()){
            system.debug('i/p > ' + strr + ' ======> ' + RetMap.get(strr));
        }*/
        
        return RetMap;
    }
        
    global virtual override Map<string,object> insertCarts(Map<string,object> InputData){
        
        system.debug('inputData keyset() > ' + InputData.keySet());
        system.debug('inputData values() > ' + InputData.values());
        
        for(string str :  InputData.keySet()){
            system.debug('insert cart i/p > ' + str + ' ======> ' +  InputData.get(str));
        }        
        

        List<ccrz__E_Cart__c> cartObjList = new List<ccrz__E_Cart__c>();
        cartObjList = (List<ccrz__E_Cart__c>)InputData.get(ccrz.ccApiCart.CART_OBJLIST);
        system.debug('cartObjList > ' + cartObjList);
        system.debug('cartObjList size > ' + cartObjList.size());
        
	        	
        if(cartObjList.size() > 0){	
            string currencycodeValue = cartObjList[0].ccrz__CurrencyISOCode__c;	
            system.debug('currencycodeValue > ' + currencycodeValue);	
            cartObjList[0].CurrencyIsoCode = currencycodeValue;	
			system.debug(' cartObjList[0].CurrencyIsoCode > ' +  cartObjList[0].CurrencyIsoCode);            	
        }        
        
        boolean isSuccess = false;
        
        Map<string,object> OutPutData = new Map<string,object>();
        List<ccrz__E_Cart__c> newInsertedcartDetails = new List<ccrz__E_Cart__c>(); 
        List<ccrz.cc_bean_Message> errormsg = new List<ccrz.cc_bean_Message>();
        ID firstcartID;
        string firstCartENCID;
        string firstStoreFrontName;
        Map<string,object> CartObjMap = new Map<string,object>();
        
        /*
        ID sfid;
        ID ownerId;
        string sfdcName;
        string storefront;
        string encryptedId;
        Boolean activeCart;
        string shipStructure;
        string validationStatus;
        String cartStatus;
        String cartType;
        string lastModifiedDate;
        Decimal subtotalAmount;
        string name;
        String effectiveAccountID;
        Decimal taxAmount;
        Boolean taxExemptFlag;
        Decimal totalAmount;
        Decimal totalDiscount;
        Decimal totalSurcharge;
        string pONumber;
        string paymentMethod;
        Decimal adjustmentAmount;
        string adjustmentReason;
        string currencyISOCode;
        Decimal shipAmount;
        Decimal shipDiscountAmount;
        Decimal taxSubTotalAmount;
        Integer totalQuantity;
        string dbuCartStoreCountry;
        ID dbuPickUpFromStore;
        Decimal totalCartDiscount;
        Decimal totalCartTax;
        Decimal originalCartTotal; 
        */
        
        Map<string,object> basefieldMapobj = (Map<string,object>)InputData.get('baseFieldsMap');
        system.debug('basefieldMapobj > '+ basefieldMapobj);
		OutPutData.put('baseFieldsMap' , basefieldMapobj);

        Map<string,object> transformIndexobj = (Map<string,object>)InputData.get('transformIndex');
        system.debug('transformIndexobj > '+ transformIndexobj);
		OutPutData.put('transformIndex' , transformIndexobj);
		
        Map<string,object> originalInputDataobj = (Map<string,object>)InputData.get('originalInputData'); 
        system.debug('originalInputDataobj > '+ originalInputDataobj);
		OutPutData.put('originalInputData' , originalInputDataobj);

        Map<string,object> sizingobj = (Map<string,object>)InputData.get('sizing'); 
        system.debug('sizingobj > '+ sizingobj);
		OutPutData.put('sizing' , sizingobj);

        double versionobj = (double)InputData.get('version');
        system.debug('versionobj > '+ versionobj);        
        OutPutData.put('version' , versionobj);
        
        
        system.debug('OutPutData imt k > ' + OutPutData.keyset());
        system.debug('OutPutData imt v > ' + OutPutData.values());
		
 		     
        try{
            
            Database.SaveResult[] srList = Database.insert(cartObjList, true);
            isSuccess = true;
            list<string> insertedcartIDlist = new list<string>();
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted cart. cart ID: ' + sr.getId());
                    insertedcartIDlist.add(sr.getId());
                }
                else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('cart fields that affected this error: ' + err.getFields());
                    }
                }
            }
            
            
            //get cartID details            
            newInsertedcartDetails = [select Id,
                                      OwnerId,
                                      Name,
                                      ccrz__Storefront__c,
                                      ccrz__EncryptedId__c,
                                      ccrz__ActiveCart__c,
                                      ccrz__ShipStructure__c,
                                      ccrz__ValidationStatus__c,
                                      ccrz__CartStatus__c,
                                      ccrz__CartType__c,
                                      LastModifiedDate,
                                      ccrz__SubtotalAmount__c,
                                      ccrz__Name__c,
                                      ccrz__EffectiveAccountID__c,
                                      ccrz__TaxAmount__c,
                                      ccrz__TaxExemptFlag__c,
                                      ccrz__TotalAmount__c,
                                      ccrz__TotalDiscount__c,
                                      ccrz__TotalSurcharge__c,
                                      ccrz__PONumber__c,
                                      ccrz__PaymentMethod__c,
                                      ccrz__AdjustmentAmount__c,
                                      ccrz__AdjustmentReason__c,
                                      ccrz__CurrencyISOCode__c,
                                      ccrz__ShipAmount__c,
                                      ccrz__ShipDiscountAmount__c,
                                      ccrz__TaxSubTotalAmount__c,
                                      ccrz__TotalQuantity__c,
                                      dbu_Cart_StoreCountry__c,
                                      dbu_storeLanguage__c,
                                      dbu_Pick_Up_From_Store__c, 
                                      Total_Cart_Discount__c,
                                      Total_Cart_Tax__c,
                                      Original_Cart_Total__c
                                      from ccrz__E_Cart__c 
                                      where id in : insertedcartIDlist];
            
      	
            IF(newInsertedcartDetails.size() > 0){
                
        		firstcartID = (ID)newInsertedcartDetails[0].ID;
                system.debug('strfront > ' + firstcartID);
                                    
        		firstCartENCID = (string)newInsertedcartDetails[0].ccrz__EncryptedId__c;
        		system.debug('encid > ' + firstCartENCID);
                                
                firstStoreFrontName = (string)newInsertedcartDetails[0].ccrz__Storefront__c;
            	system.debug('strfrntName > ' + firstStoreFrontName);
                /*
            	sfid = (ID)newInsertedcartDetails[0].ID;
                ownerId =  (ID)newInsertedcartDetails[0].OwnerId;
                sfdcName = (string)newInsertedcartDetails[0].Name;
                storefront = (string)newInsertedcartDetails[0].ccrz__Storefront__c;
                encryptedId = (string)newInsertedcartDetails[0].ccrz__EncryptedId__c;
                activeCart = (boolean)newInsertedcartDetails[0].ccrz__ActiveCart__c;
				shipStructure = ((string)newInsertedcartDetails[0].ccrz__ShipStructure__c )!= null ? (string)newInsertedcartDetails[0].ccrz__ShipStructure__c : null;
                validationStatus = ((string)newInsertedcartDetails[0].ccrz__ValidationStatus__c)!= null ? (string)newInsertedcartDetails[0].ccrz__ValidationStatus__c : null;
                cartStatus = ((string)newInsertedcartDetails[0].ccrz__CartStatus__c) != null ? (string)newInsertedcartDetails[0].ccrz__CartStatus__c : null ;
                cartType = ((string)newInsertedcartDetails[0].ccrz__CartType__c) != null ? (string)newInsertedcartDetails[0].ccrz__CartType__c : null ;
                lastModifiedDate = string.valueof(newInsertedcartDetails[0].LastModifiedDate);
                subtotalAmount = (decimal)newInsertedcartDetails[0].ccrz__SubtotalAmount__c;
                name =  ((string)newInsertedcartDetails[0].ccrz__Name__c) != null ?  (string)newInsertedcartDetails[0].ccrz__Name__c : null;
                effectiveAccountID = ((string)newInsertedcartDetails[0].ccrz__EffectiveAccountID__c) != null ? (string)newInsertedcartDetails[0].ccrz__EffectiveAccountID__c : null;
                taxAmount = (decimal)newInsertedcartDetails[0].ccrz__TaxAmount__c;
                taxExemptFlag = (boolean)newInsertedcartDetails[0].ccrz__TaxExemptFlag__c;
                totalAmount = (decimal)newInsertedcartDetails[0].ccrz__TotalAmount__c;
                totalDiscount = (decimal)newInsertedcartDetails[0].ccrz__TotalDiscount__c;
                totalSurcharge = (decimal)newInsertedcartDetails[0].ccrz__TotalSurcharge__c;
                pONumber = ((string)newInsertedcartDetails[0].ccrz__PONumber__c) != null ? (string)newInsertedcartDetails[0].ccrz__PONumber__c : null;
                paymentMethod = ((string)newInsertedcartDetails[0].ccrz__PaymentMethod__c) != null ? (string)newInsertedcartDetails[0].ccrz__PaymentMethod__c : null;
                adjustmentAmount = (decimal)newInsertedcartDetails[0].ccrz__AdjustmentAmount__c;
                adjustmentReason = ((string)newInsertedcartDetails[0].ccrz__AdjustmentReason__c) != null ? (string)newInsertedcartDetails[0].ccrz__AdjustmentReason__c : null;
                currencyISOCode = ((string)newInsertedcartDetails[0].ccrz__CurrencyISOCode__c) != null ? (string)newInsertedcartDetails[0].ccrz__CurrencyISOCode__c : 'USD';
                shipAmount = (decimal)newInsertedcartDetails[0].ccrz__ShipAmount__c;
                shipDiscountAmount = (decimal)newInsertedcartDetails[0].ccrz__ShipDiscountAmount__c;
                taxSubTotalAmount =  (decimal)newInsertedcartDetails[0].ccrz__TaxSubTotalAmount__c;
                totalQuantity =  (Integer)newInsertedcartDetails[0].ccrz__TotalQuantity__c;
                dbuCartStoreCountry = ((string)newInsertedcartDetails[0].dbu_Pick_Up_From_Store__c) != null ? (string)newInsertedcartDetails[0].dbu_Pick_Up_From_Store__c : null;
                dbuPickUpFromStore =  (ID)newInsertedcartDetails[0].dbu_Pick_Up_From_Store__c;
                totalCartDiscount = (decimal)newInsertedcartDetails[0].Total_Cart_Discount__c;
                totalCartTax = (decimal)newInsertedcartDetails[0].Total_Cart_Tax__c;
                originalCartTotal = (decimal)newInsertedcartDetails[0].Original_Cart_Total__c;
                */
            }

        }catch(exception e){
            system.debug('cause > '+ e.getCause());
            system.debug('line number > '+ e.getLineNumber());
            system.debug('Message > '+ e.getMessage());
            system.debug('StackTrace error > ' + e.getStackTraceString());
        }      
		

        
        //OutPutData.put('cartId' , firstcartID);ccrz.ccApiCart.CART_ID
        //
        //OutPutData.put(ccrz.ccApiCart.CART_ID, firstcartID);ccrz.ccApiCart.CART_ENCID
       	//'newCartObjects'
       	//
        //OutPutData.put('storefront' , firstStoreFrontName);ccrz.ccApiCart.BYSTOREFRONT
        /*
        CartObjMap.put('sfid',sfid);
        CartObjMap.put('ownerId',ownerId);
        CartObjMap.put('sfdcName',sfdcName);
        CartObjMap.put('storefront',storefront);
        CartObjMap.put('encryptedId',encryptedId);
        CartObjMap.put('activeCart',activeCart);
        CartObjMap.put('shipStructure',shipStructure);
        CartObjMap.put('validationStatus',validationStatus);
        CartObjMap.put('cartStatus',cartStatus);
        CartObjMap.put('cartType',cartType);
        CartObjMap.put('lastModifiedDate',lastModifiedDate);
        CartObjMap.put('subtotalAmount',subtotalAmount);
        CartObjMap.put('name',name);
        CartObjMap.put('effectiveAccountID',effectiveAccountID);
        CartObjMap.put('taxAmount',taxAmount);
        CartObjMap.put('taxExemptFlag',taxExemptFlag);
        CartObjMap.put('totalAmount',totalAmount);
        CartObjMap.put('totalDiscount',totalDiscount);
        CartObjMap.put('totalSurcharge',totalSurcharge);
        CartObjMap.put('pONumber',pONumber);
        CartObjMap.put('paymentMethod',paymentMethod);
        CartObjMap.put('adjustmentAmount',adjustmentAmount);
        CartObjMap.put('adjustmentReason',adjustmentReason);
        CartObjMap.put('currencyISOCode',currencyISOCode);
        CartObjMap.put('shipAmount',shipAmount);
        CartObjMap.put('shipDiscountAmount',shipDiscountAmount);
        CartObjMap.put('taxSubTotalAmount',taxSubTotalAmount);
        CartObjMap.put('totalQuantity',totalQuantity);
        CartObjMap.put('dbuCartStoreCountry',dbuCartStoreCountry);
        CartObjMap.put('dbuPickUpFromStore',dbuPickUpFromStore);
        CartObjMap.put('totalCartDiscount',totalCartDiscount);
        CartObjMap.put('totalCartTax',totalCartTax);
        CartObjMap.put('originalCartTotal',originalCartTotal);     
        OutPutData.put('cartList',new list<Map<string,object>>{CartObjMap});
		*/
        
        
        //OutPutData.put('cartEncId' , firstCartENCID);ccrz.ccApi.SUCCESS
        //OutPutData.put(ccrz.ccApi.SUCCESS , isSuccess);
        //OutPutData.put(ccrz.ccApiCart.CART_ID , firstcartID);
        //OutPutData.put(ccrz.ccApiCart.BYSTOREFRONT , firstStoreFrontName);
        //OutPutData.put(ccrz.ccApiCart.CART_ENCID , firstCartENCID); 
        OutPutData.put('cartId', firstcartID);
        OutPutData.put('storefront', firstStoreFrontName);
        OutPutData.put('cartEncId', firstCartENCID);        
        OutPutData.put('newCartObjects' , newInsertedcartDetails);
        OutPutData.put('success',isSuccess);
        
       // Map<string,object> RetMap = super.insertCarts(InputData);        
        
       //system.debug('RetMap keyset() > ' + RetMap.keySet());
       // system.debug('RetMap values() > ' + RetMap.values());
        
		//system.debug('transformIndex  >' + (Map<string,object>)RetMap.get('transformIndex'));
		//Map<string,object> tt = (Map<string,object>)RetMap.get('transformIndex');
        //for(string t : tt.keySet()){
        //    system.debug('t key > ' + t + ' t value > ' + tt.get(t));
        //}
        
        //list<ccrz__E_Cart__c> no = (list<ccrz__E_Cart__c>)RetMap.get('newCartObjects');
        //system.debug('no --- ' + no[0]);
        //for(ccrz__E_Cart__c ct : no[0]){
          //  system.debug('ct > ' + ct);
        //}
        
        //for(string str :  RetMap.keySet()){
          // system.debug('insert cart o/p > ' + str + ' ======> ' +  RetMap.get(str));
        //}         
        
        system.debug('OutPutData keys > ' + OutPutData.keyset());
        system.debug('OutPutData values >'+ OutPutData.values());

        for(string str :  OutPutData.keySet()){
           system.debug('OutPutData o/p > ' + str + ' ======> ' +  OutPutData.get(str));
        }          
        
       //return RetMap;

        list<ccrz__E_Cart__c> cartstallyafterinsertcarts = [select id, ccrz__ActiveCart__c, dbu_Cart_StoreCountry__c,dbu_storeLanguage__c 
                                                            from ccrz__E_Cart__c 
                                                            where Ownerid =: userinfo.getUserId() 
                                                            and ccrz__CartType__c = 'Cart'];    

        system.debug('cartstallyafterinsertcarts >>>>>>>>>>>>>>>>>>> ' + cartstallyafterinsertcarts);
       
       return OutPutData;
    }
    
    global virtual override Map<String, Object> refetch(Map<String, Object> inputdata){
        
        system.debug('inputdata refetch keys > '+ inputdata.keyset());
        system.debug('inputdata refetch keys > '+ inputdata.values());
        system.debug('inputdata get id > ' + (list<ccrz__E_Cart__c>)inputdata.get('cartList'));
        
        ccrz__E_Cart__c  cartlistObj = ((list<ccrz__E_Cart__c>)inputdata.get('cartList'))[0];
        system.debug('cartlistObj stporefrnt > ' + cartlistObj.ccrz__Storefront__c);
        ID cartId = cartlistObj.Id;
        string cartEncId = cartlistObj.ccrz__EncryptedId__c;
        string storefront = cartlistObj.ccrz__Storefront__c;
        boolean success = true;

		inputdata.put('cartId' , cartId);
        inputdata.put('cartEncId' , cartEncId);
        inputdata.put('storefront' , storefront);
        inputdata.put('success' , success);
        
        inputdata.remove('transformIndex');
        inputdata.remove('originalInputData');
        
        system.debug('inputdata reft keys > ' + inputdata.keyset());
        system.debug('inputdata reft values > ' + inputdata.values());
            

        //system.debug('inputdata get size > ' + ((list<ccrz__E_Cart__c>)inputdata.get('cartList')).size());
        Map<string,object> retmap = super.refetch(inputdata);
        
        system.debug('retmap refetch keys >' + retmap.keyset());
        system.debug('retmap refetch keys >' + retmap.values());
        
        list<ccrz__E_Cart__c> cartstallyafterrefetch = [select id, ccrz__ActiveCart__c, dbu_Cart_StoreCountry__c,dbu_storeLanguage__c 
                                                            from ccrz__E_Cart__c 
                                                            where Ownerid =: userinfo.getUserId() 
                                                            and ccrz__CartType__c = 'Cart'];    

        system.debug('cartstallyafterrefetch >>>>>>>>>>>>>>>>>>>>> ' + cartstallyafterrefetch);
        
        
        return retmap;
    }
            
}