public without sharing class dbu_CheckOutCntrl{
    public static string finalShippingaddressid;
    public static string finalbillingaddressid;
    
    
    @Auraenabled 
    public static String insertShippingInfo(string add1,string add2,string state ,string  zip,string country,string city, string firstname, string lastname) {
        system.debug('shippingInfo>>>' +add1);
        
        Map<string, object> addressmapShipto = new Map<string, object>{
            'addressFirstline' => add1,
                'addressSecondline' => add2,
                'country' => country,
                'firstName' => firstname,
                'lastName' => lastname,
                'postalCode' => zip,
                'city'=> city,
                'state' => state ,
                'shippingComments' => 'Shipping Comments'                
                };            
                    system.debug(addressmapShipto);
        list<Map<string, object>> addressMapList = new list<Map<string, object>>{addressmapShipto};
            system.debug(addressMapList);
        
        
        //############### INPUT DATA FORMAT ##################################################
        Map<String, Object> CreateContactAddress = new Map<String, Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,    
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccApiAddress.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L
                            }
                },
                    ccrz.ccApiAddress.ADDRESSLIST => addressMapList        
                    };
                        //List<ccrz__E_ContactAddr__c>
                        system.debug(CreateContactAddress);
        
        
        
        //############### Fire CCAPIADDRESS API ##################################################
        try {
            Map<String, Object> ResponseAddressApi = ccrz.ccApiAddress.createAddress(CreateContactAddress);
            system.debug('ResponseAddressApi==>'+ResponseAddressApi); 
            //Get the IDs of BillTo and ShipTo cc contact addresses
            List<String> getcontactAddressIDs = (list<string>)ResponseAddressApi.get(ccrz.ccApiAddress.ADDRESSIDLIST);
            finalShippingaddressid=getcontactAddressIDs[0];
            
            system.debug('getcontactAddressIDs==>'+getcontactAddressIDs);
            
            
        }catch (Exception e) {
            // Error handling...
            system.debug('exception message '+e.getMessage()+''+'exception line number '+e.getLineNumber());
        }
        return finalShippingaddressid;
    }
    
    @Auraenabled 
    public static string insertBillingInfo(string add1,string add2,string state ,string  zip,string country,string city) {
        system.debug('billinginfooo>>>' +add1);
        
        Map<string, object> addressmapBillto = new Map<string, object>{
            'addressFirstline' => add1,
                'addressSecondline' => add2,
                'country' => country,
                'postalCode' => zip,
                'state' => state ,
                'city' => city,
                'shippingComments' => 'Billing Comments'
                };            
                    system.debug(addressmapBillto);
        
        
        list<Map<string, object>> addressMapList = new list<Map<string, object>>{addressmapBillto};
            system.debug(addressMapList);
        
        
        //############### INPUT DATA FORMAT ##################################################
        Map<String, Object> CreateContactAddress = new Map<String, Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,    
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccApiAddress.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_L
                            }
                },
                    ccrz.ccApiAddress.ADDRESSLIST => addressMapList        
                    };
                        //List<ccrz__E_ContactAddr__c>
                        system.debug(CreateContactAddress);
        
        
        
        //############### Fire CCAPIADDRESS API ##################################################
        try {
            Map<String, Object> ResponseAddressApi = ccrz.ccApiAddress.createAddress(CreateContactAddress);
            system.debug(ResponseAddressApi); 
            //Get the IDs of BillTo and ShipTo cc contact addresses
            List<String> getcontactAddressIDs = (list<string>)ResponseAddressApi.get(ccrz.ccApiAddress.ADDRESSIDLIST);
            finalbillingaddressid=getcontactAddressIDs[0];
            
            system.debug(getcontactAddressIDs);
        }catch (Exception e) {
            // Error handling...
            system.debug(e);
        }
        return finalbillingaddressid;
    }
    @AuraEnabled
    public static void insertUserInfo(String firstnme, string lstnme, string email, string phn, string cmnyname, string finalShipAddressId, string finalBillingAddressId, string cartID) {
        system.debug('finalShipAddressId' +finalShipAddressId);
        system.debug('cartID in checkout cntrl>>>' +cartID);
        
        Map<String, Object> cartFetchQuery = new Map<String, Object>{
            ccrz.ccApiCart.CART_ID => cartID ,
                //  ccrz.ccApiCart.CART_IDLIST => cartIdList,
                ccrz.ccApi.API_VERSION =>  ccrz.ccApi.CURRENT_VERSION,
                //ccrz.
                
                /*API SIZING set to XL which returns All possible fields*/
                ccrz.ccApi.SIZING => new Map<String, Object> {
                    ccrz.ccApiCart.ENTITYNAME => new Map<String, Object> {
                        ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                            },
                                ccrz.ccApiAddress.ENTITYNAME => new Map<String, Object> {
                                    ccrz.ccApi.SZ_DATA => ccrz.ccApi.SZ_XL
                                        }
                }
        };
            
            //################### PARAMETERS TO BE UPDATED IN THE CART #####################################################################    
            string buyer_FirstName = firstnme;
        string buyer_LastName = lstnme;
        string buyer_Email = email;
        string buyer_BillTo;
        string buyer_ShipTo;
        if(String.ISNotBlank(finalBillingAddressId)){
            buyer_BillTo = finalBillingAddressId;
        }
        if(String.ISNotBlank(finalShipAddressId)){
            
            buyer_ShipTo = finalShipAddressId;
        }
        string buyer_Phone = phn;
        //*** COMPANY NAME FIELD IS DEPRECATED, SO CANT BE UPDATED
        string buyer_CompanyName = 'Felix Gallardo Organization - Guadalajara'; 
        
        //############################### FIRE FETCH METHOD OF CC CART API #########################################    
        try {
            Map<String, Object> cartFetchData = ccrz.ccApiCart.fetch(cartFetchQuery); 
            system.debug('cartFetchData>>' +JSON.serialize(cartFetchData));
            //################## Fetch CC Contact Address Details BillTo & ShipTo #########################
            if(cartFetchData.get(ccrz.ccApiAddress.ADDRESSLIST) != null){
                List<Map<String, Object>> outputAddressList = (List<Map<String, object>>) cartFetchData.get(ccrz.ccApiAddress.ADDRESSLIST);
                System.debug(JSON.serializePretty('AddressDetails::::: ' + outputAddressList));
            }
            
            
            //################## Add the details to be updated in the cart #########################
            List<Map<String, Object>> outputCartList = new List<Map<String, Object>>();
            Map<string,object> CartObj = new Map<string,object>();
            
            if (cartFetchData.get(ccrz.ccApiCart.CART_OBJLIST) != null) {        
                outputCartList = (List<Map<String, Object>>) cartFetchData.get(ccrz.ccApiCart.CART_OBJLIST);
                System.debug(JSON.serializePretty('CartDetails::::: ' + outputCartList)); 
                system.debug('output list>>>' +outputCartList[0]);
                CartObj = outputCartList[0];
                system.debug(JSON.serializePretty('BeforeCartDetails::::: ' + CartObj));        
                CartObj.put('buyerFirstName', buyer_FirstName);
                CartObj.put('buyerLastName', buyer_LastName);
                CartObj.put('buyerEmail', buyer_Email); 
                CartObj.put('buyerMobilePhone', buyer_Phone); //NOT AVAILABLE FOR UPDATE USING Revise() METHOD
                CartObj.put('buyerPhone', buyer_Phone); 
                if(String.ISNotBlank(buyer_BillTo)){
                    CartObj.put('billTo', buyer_BillTo);
                }
                if(String.ISNotBlank(buyer_ShipTo)){
                    
                    CartObj.put('shipTo', buyer_ShipTo);
                }
                CartObj.put('dbuCompanyName', cmnyname);//DEPRECATED FIELD
                system.debug(JSON.serializePretty('AfterCartDetails::::: ' + CartObj));                                
            }
            
            // Set the changed cart into a new list.
            List<Map<String, Object>> writeableCarts = new List<Map<String, Object>>();
            writeableCarts.add(CartObj);   
            system.debug('CartObj mitovejic >  ' + CartObj);
            
            //################## FIRE THE REVISE() METHOD #########################           
            Map<String, Object> writeRes = ccrz.ccApiCart.revise(new Map<String, Object>{
                ccrz.ccApi.API_VERSION=>4,
                    ccrz.ccApiCart.CART_OBJLIST => writeableCarts
                    }); 
            system.debug(JSON.serializePretty('ReviseCartDetails::::: ' + writeRes));
            
            
        } catch (Exception ex) {
            // Error handling...
            System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
        }
        
        
        
    }
    
    @AuraEnabled(cacheable =true)
    public static list<ccrz__E_Cart__c> getShiptoBilltoData(string cartid)
    {
        list<ccrz__E_Cart__c> cartlst = new list<ccrz__E_Cart__c>();
        if(cartid!=null)
        {
            cartlst=[SELECT Id,name,ccrz__BillTo__c,ccrz__ShipTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__AddressSecondline__c,ccrz__BillTo__r.ccrz__City__c,
                     ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__BillTo__r.ccrz__Country__c,
                     ccrz__ShipTo__r.ccrz__AddressFirstline__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__City__c,
                     ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__PostalCode__c,ccrz__ShipTo__r.ccrz__Country__c,ccrz__BuyerFirstName__c,
                     ccrz__BuyerLastName__c,ccrz__BuyerEmail__c,ccrz__BuyerPhone__c,
                     dbu_Pick_Up_From_Store__c
                     from ccrz__E_Cart__c where id=:cartid];    
        }
        system.debug('cartlst'+cartlst);
        return cartlst;
    }
    
    // it will update the shipping Amount on Current Cart Object
    @AuraEnabled
    public static decimal updateShippingAmountOnCart(boolean isShipSelected, String cartId,String stateName){
        Decimal weight = 0.00;
        Decimal totalAmount = 0.00;
        Decimal shippingAmount = 0.00;
        Boolean isFreeShippingCouponApplied = false;
        
        Decimal maxTotalAmount = Decimal.valueOf(System.Label.dbu_ShippingCost_TotalAmout); // value 100
        Decimal maxWeight100 = Decimal.valueOf(System.Label.dbu_ShippingCost_TotalWeight_100); // value 100
        Decimal maxWeight150 = Decimal.valueOf(System.Label.dbu_ShippingCost_TotalWeight_150); // value 150
        
        // Inventory Changes
        List<ccrz__E_CartItem__c> cartItemObjList = new List<ccrz__E_CartItem__c>();
        cartItemObjList =[SELECT ID,ccrz__Quantity__c,ccrz__SubAmount__c,ccrz__Cart__r.ccrz__TotalDiscount__c,ccrz__Cart__r.dbu_Free_Shipping__c FROM ccrz__E_CartItem__c  WHERE dbu_isShipTo__c = true AND ccrz__Cart__c =:cartId];
        
        //if(cartItemObjList.size() > 0 && cartItemObjList[0].ccrz__Cart__r.dbu_Free_Shipping__c != null && cartItemObjList[0].ccrz__Cart__r.dbu_Free_Shipping__c){
            //isFreeShippingCouponApplied = true;
        //}
        //&& !isFreeShippingCouponApplied
        if(cartItemObjList.size() > 0 ){
            for(ccrz__E_CartItem__c cartItemObj : cartItemObjList){
                totalAmount = totalAmount + cartItemObj.ccrz__SubAmount__c;
            }
            totalAmount = totalAmount + cartItemObjList[0].ccrz__Cart__r.ccrz__TotalDiscount__c;
        }
        // End Here
        system.debug('total Amount ' + totalAmount);        
        ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
        List<ccrz__E_Cart__c> cartObjUpdate = new List<ccrz__E_Cart__c>();
        List<ccrz__E_Cart__c> cartObjLst = new list<ccrz__E_Cart__c>();
        
        // && !isFreeShippingCouponApplied
        if(cartItemObjList.size() > 0 ){
            weight = getProductRelatedSpecWeight(cartId);
            system.debug('weight in ' +weight);
            if(weight == null){
                weight = 0.00;
            }
            if (totalAmount >= maxTotalAmount && weight <= maxWeight100) {
                shippingAmount = Decimal.valueOf(System.Label.dbu_Free_Shipping); //shippingAmount = 0.00;
            } else if (totalAmount < maxTotalAmount && weight <= maxWeight100) {
                shippingAmount = Decimal.valueOf(System.Label.dbu_Flat_Rate_Shipping_orders_below_100); //shippingAmount = 15.00;
            } else if (totalAmount < maxTotalAmount && weight > maxWeight100 && weight < maxWeight150) {
                shippingAmount = Decimal.valueOf(System.Label.dbu_Flat_Rate_weight_100_149_99_lbs); //shippingAmount = 30.00;
            } else if (totalAmount < maxTotalAmount && weight >= maxWeight150) {
                shippingAmount = Decimal.valueOf(System.Label.dbu_Flat_Rate_Shipping_grater_150_lbs);//shippingAmount = 40.00;
            } else if (totalAmount >= maxTotalAmount && weight > maxWeight100 && weight < maxWeight150) {
                shippingAmount = Decimal.valueOf(System.Label.dbu_Flat_Rate_weight_100_149_99_lbs); //shippingAmount = 30.00;
            } else if (totalAmount >= maxTotalAmount && weight >= maxWeight150) {
                shippingAmount = Decimal.valueOf(System.Label.dbu_Flat_Rate_Shipping_grater_150_lbs); //shippingAmount = 40.00;
            }
            
        }
        
        cartObj.ccrz__ShipAmount__c = shippingAmount;
        cartObj.Id = cartId;
        system.debug('shippingAmount ' + shippingAmount);
        system.debug('weight after calculation ' + weight);
        
        
        cartObjUpdate.add(cartObj);
        if(stateName != 'isEstimated'){
            try {
                update cartObjUpdate;
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
        cartObjLst = [select id,dbu_Free_Shipping__c from ccrz__E_Cart__c where id =: cartId];
        if(cartObjLst[0].dbu_Free_Shipping__c){
			shippingAmount = 0.00;            
        }
        
        return shippingAmount;
    }
      //Sandeep starts - Cart
      @AuraEnabled
      public static decimal calculateCostShipmentProduct(boolean isShipSelected, String cartId,String stateName){
          Decimal totalAmount = 0.00;
          // Inventory Changes
          List<ccrz__E_CartItem__c> cartItemObjList = new List<ccrz__E_CartItem__c>();
          cartItemObjList =[SELECT ID,ccrz__Quantity__c,ccrz__SubAmount__c FROM ccrz__E_CartItem__c  WHERE dbu_isShipTo__c = true AND ccrz__Cart__c =:cartId];
          if(cartItemObjList.size() > 0){
              for(ccrz__E_CartItem__c cartItemObj : cartItemObjList){
                  totalAmount = totalAmount + cartItemObj.ccrz__SubAmount__c;
              }
          }
          // End Here
          system.debug('total Amount ' + totalAmount);           
          return totalAmount;
      }
      //Sandeep ends- Cart
    @AuraEnabled
    public static void updateCCAddress(String ccAddressID,string companyName,string addType,string fstCCName,
                                       string lstCCName,string emailCC,string phnCC,string add1CC,string add2CC,
                                       string cityCC,string stateCC,string zipCC,string cntryCC,Boolean ccAddressDefaultedCC,string storeName){
                                           ID ccConAddID;
                                           string commentsType;
                                           system.debug(ccAddressID + ' and ' +fstCCName + ' and ' +stateCC+ 'and' +ccAddressDefaultedCC);
                                           List<ccrz__E_ContactAddr__c>ccAddList = new List<ccrz__E_ContactAddr__c>();
                                           List<ccrz__E_ContactAddr__c>updateCCAddList = new List<ccrz__E_ContactAddr__c>();
                                           List<ccrz__E_ContactAddr__c> ccContactOldList = new List<ccrz__E_ContactAddr__c>();
                                           List<ccrz__E_ContactAddr__c> updateContactOldList = new List<ccrz__E_ContactAddr__c>();
                                           List<Contact> contNewList = new List<Contact>();
                                           List<Contact> updNewList = new List<Contact>();
                                           
                                           
                                           if(ccAddressID != null){
                                               system.debug('entering the if loop in updateCCAdress');
                                               ccAddList = [Select id,ccrz__ShippingComments__c,ccrz__CompanyName__c,ccrz__FirstName__c,ccrz__LastName__c,dbu_Contact__c,
                                                            ccrz__Email__c,ccrz__HomePhone__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,
                                                            ccrz__City__c,ccrz__State__c,ccrz__PostalCode__c,ccrz__Country__c,dbu_Default_Address__c,dbu_PickUp_Store_Name__c
                                                            FROM ccrz__E_ContactAddr__c WHERE ID =: ccAddressID];
                                               system.debug('ccAddList' +ccAddList);
                                           }
                                           try{
                                               
                                               
                                               system.debug('ccAddList' +ccAddList);
                                               if(ccAddList.size()>0 && ccAddList != null){
                                                   for(ccrz__E_ContactAddr__c updateRec: ccAddList){
                                                       // if(updateRec.dbu_Contact__c != null){
                                                       ccConAddID = updateRec.dbu_Contact__c;
                                                       //addressID.add(updateRec.id);
                                                       
                                                       //  }
                                                       if(addType != ''){
                                                           updateRec.ccrz__ShippingComments__c = addType +' '+'Comments';  
                                                           commentsType = addType +' '+'Comments';
                                                       }
                                                       updateRec.ccrz__CompanyName__c = companyName; 
                                                       updateRec.ccrz__FirstName__c = fstCCName;
                                                       updateRec.ccrz__LastName__c = lstCCName;
                                                       updateRec.ccrz__AddressFirstline__c = add1CC;
                                                       updateRec.ccrz__AddressSecondline__c = add2CC;
                                                       updateRec.ccrz__City__c = cityCC;
                                                       updateRec.ccrz__State__c = stateCC;
                                                       updateRec.ccrz__PostalCode__c = zipCC;
                                                       updateRec.ccrz__Country__c = cntryCC;
                                                       updateRec.dbu_Default_Address__c = ccAddressDefaultedCC;
                                                       updateRec.dbu_PickUp_Store_Name__c=storeName;
                                                       
                                                       updateCCAddList.add(updateRec);
                                                   }
                                               }
                                               /* code is to update default address of all the cc contact address under this contact to false */
                                               if(ccAddressDefaultedCC == true){
                                                   system.debug('ccAddressDefaultedCC' +ccAddressDefaultedCC);
                                                   updateDefaultAddressData(ccConAddID,ccAddressID,commentsType);
                                                   
                                               }
                                               /*code is to update default address of all the cc contact address under this contact to false */
                                               /*Code to update contacts company name with billing default address cmpany name*/
                                               if(ccAddressDefaultedCC == true && ccConAddID != null && addType == 'Billing'){
                                                   contNewList = [Select id, dbu_Company_Name__c from Contact
                                                                  Where id= :ccConAddID];
                                                   system.debug('contNewList' +contNewList); 
                                                   if(contNewList != null){
                                                       for(Contact updCon :contNewList){
                                                           if(companyName != null){
                                                               updCon.dbu_Company_Name__c = companyName;
                                                               updNewList.add(updCon);
                                                           }
                                                       }
                                                       if(updNewList.size()>0){
                                                           update updNewList;   
                                                       }
                                                   }
                                               }
                                               /*Code to update contacts comoany name with billing default address cmpany name*/
                                               
                                               if(updateCCAddList.size()>0){
                                                   system.debug('enetering the update method>>>' +updateCCAddList);
                                                   update updateCCAddList;
                                               }
                                               
                                               
                                           }catch(exception exc){
                                               system.debug('exception in checkoutctrl-updateCCAddressMethod' +exc.getLineNumber() + 'and' +exc.getMessage());
                                           }
                                           
                                           
                                       }
    
    @AuraEnabled
    public static void addCCContactAddress(String newCCAddress){
        Id contactID;
        String commentsType = '';
        system.debug('newCCAddress' +newCCAddress);   
        List<Map<String,String>> ccAddNew = (List<Map<String,String>>) JSON.deserialize(newCCAddress, List<Map<String,String>>.class);
        System.debug('contact id>>>' +ccAddNew[0].get('contactIdNew'));
        ccrz__E_ContactAddr__c newCCRecord = new ccrz__E_ContactAddr__c();
        newCCRecord.ccrz__CompanyName__c = ccAddNew[0].get('cmnynameNew') == null ? '' : ccAddNew[0].get('cmnynameNew');
        newCCRecord.dbu_Contact__c = ccAddNew[0].get('contactIdNew') == null ? '' : ccAddNew[0].get('contactIdNew');
        newCCRecord.ccrz__ShippingComments__c = ccAddNew[0].get('addTypeNew') == null ? '' : ccAddNew[0].get('addTypeNew') +' '+'Comments';
        newCCRecord.ccrz__FirstName__c = ccAddNew[0].get('firstnameNew') == null ? '' : ccAddNew[0].get('firstnameNew');
        newCCRecord.ccrz__LastName__c = ccAddNew[0].get('lastnameNew') == null ? '' : ccAddNew[0].get('lastnameNew');
        newCCRecord.ccrz__AddressFirstline__c = ccAddNew[0].get('add1New') == null ? '' : ccAddNew[0].get('add1New');
        newCCRecord.ccrz__AddressSecondline__c = ccAddNew[0].get('add2New') == null ? '' : ccAddNew[0].get('add2New');
        newCCRecord.ccrz__City__c = ccAddNew[0].get('cityNew') == null ? '' : ccAddNew[0].get('cityNew');
        newCCRecord.ccrz__State__c = ccAddNew[0].get('stateNew') == null ? '' : ccAddNew[0].get('stateNew');
        newCCRecord.ccrz__PostalCode__c = ccAddNew[0].get('zipNew') == null ? '' : ccAddNew[0].get('zipNew');
        newCCRecord.ccrz__Country__c = ccAddNew[0].get('cntryNew') == null ? '' : ccAddNew[0].get('cntryNew');
        contactID = String.valueOf(ccAddNew[0].get('contactIdNew') == null ? '' : ccAddNew[0].get('contactIdNew')); 
        commentsType = ccAddNew[0].get('addTypeNew') == null ? '' : ccAddNew[0].get('addTypeNew') +' '+'Comments';
        if(Boolean.valueOf(ccAddNew[0].get('defaultedAddressNew')) == true){
            newCCRecord.dbu_Default_Address__c = true;
            updateDefaultAddressData(contactID,null,commentsType);
        }
        // newCCRecord.
        system.debug('newCCRecord' +newCCRecord);
        insert newCCRecord;
        system.debug('newCCRecord' +newCCRecord);
        
    }
    
    @AuraEnabled
    public static List<dbu_ccAddressWrapper> deleteContactAdd(Id ccDeleteID){
        List<dbu_ccAddressWrapper> ccAddwrapper = new List<dbu_ccAddressWrapper>();
        
        system.debug('ccDeleteID>>>' +ccDeleteID);
        List<ccrz__E_ContactAddr__c> ccAddListDel = new List<ccrz__E_ContactAddr__c>();
        List<ccrz__E_ContactAddr__c> updccAddListDel = new List<ccrz__E_ContactAddr__c>();
        
        
        if(ccDeleteID != null){
            ccAddListDel = [Select id,ccrz__ShippingComments__c
                            FROM ccrz__E_ContactAddr__c WHERE ID =: ccDeleteID];
            system.debug('ccAddList' +ccDeleteID);
            
        }
        try{
            /*if(ccAddListDel != null){
system.debug('ccAddListDel' +ccAddListDel);
delete ccAddListDel;
}*/
            
            /*Below method is for time being as we are unable to delete the records in CSO*/
            
            if(ccAddListDel != null){
                for(ccrz__E_ContactAddr__c delccAdd:ccAddListDel){
                    if(delccAdd.ccrz__ShippingComments__c != null){
                        delccAdd.ccrz__ShippingComments__c = null;
                        updccAddListDel.add(delccAdd);
                    }
                }
                if(updccAddListDel != null){
                    update updccAddListDel;
                }
            }
            ccAddwrapper = dbu_LoggedInUsrCntrl.fetchCCAddressShippingAndBilling();
            system.debug('ccAddwrapper list' +ccAddwrapper);
            /*Below method is for time being as we are unable to delete the records in CSO*/
            
            
        }catch (DmlException e) {
            system.debug('exception in checkoutcntrl cls, delete method' +e.getLineNumber() +' '+e.getMessage());
        }
        return ccAddwrapper;
        
    }
    
    public static void updateDefaultAddressData(ID ccConAddID,string ccAddressID,string commentsType){
        List<ccrz__E_ContactAddr__c> ccContactOldList = new List<ccrz__E_ContactAddr__c>();
        List<ccrz__E_ContactAddr__c> updateContactOldListShipping = new List<ccrz__E_ContactAddr__c>();
        List<ccrz__E_ContactAddr__c> updateContactOldListBilling = new List<ccrz__E_ContactAddr__c>();
        List<Contact> updateContactList = new List<Contact>();
        List<Contact> newContactList = new List<Contact>();
        String cmpnyName = '';
        
        ccContactOldList = [SELECT id,dbu_Default_Address__c,ccrz__ShippingComments__c FROM ccrz__E_ContactAddr__c
                            WHERE dbu_Contact__c = :ccConAddID ];
        newContactList = [SELECT id,dbu_Company_Name__c from Contact 
                          Where id =:ccConAddID];
        
        //below if is to update all the cc contact address default address field to false if on edit 
        //customemr selecetd the default address to true for one address(update condition)
        //below else  is to update all the cc contact address default address field to false if on creation 
        //customemr selecetd the default address to true for new address(creation)
        try{
            for(ccrz__E_ContactAddr__c oldCCContctAddRec: ccContactOldList){
                if(oldCCContctAddRec.dbu_Default_Address__c == true && commentsType == 'Shipping Comments'
                   && oldCCContctAddRec.ccrz__ShippingComments__c == 'Shipping Comments'){
                       
                       if(ccAddressID != oldCCContctAddRec.ID && ccAddressID != '' ){
                           oldCCContctAddRec.dbu_Default_Address__c = false;    
                           updateContactOldListShipping.add(oldCCContctAddRec);
                           
                       }else if(ccAddressID == ''){
                           oldCCContctAddRec.dbu_Default_Address__c = false;    
                           updateContactOldListShipping.add(oldCCContctAddRec);
                       }
                   }
                if(oldCCContctAddRec.dbu_Default_Address__c == true && commentsType == 'Billing Comments'
                   && oldCCContctAddRec.ccrz__ShippingComments__c == 'Billing Comments'){
                       if(ccAddressID != oldCCContctAddRec.ID && ccAddressID != '' ){
                           oldCCContctAddRec.dbu_Default_Address__c = false;
                           cmpnyName = oldCCContctAddRec.ccrz__CompanyName__c;
                           system.debug('cmpnyName' +cmpnyName);
                           updateContactOldListBilling.add(oldCCContctAddRec);
                       }else if(ccAddressID == ''){
                           oldCCContctAddRec.dbu_Default_Address__c = false;    
                           updateContactOldListBilling.add(oldCCContctAddRec);
                       }
                       
                   }
            }
            if(updateContactOldListShipping.size()>0){
                update updateContactOldListShipping;
            }
            if(updateContactOldListBilling.size()>0){
                update updateContactOldListBilling;
            }
        }catch(exception exc){
            system.debug('exception in chekcoutctrl in updateDefaultAddressData method' +exc.getLineNumber() +'' + exc.getMessage());
        }
        
        
    }
    //@AuraEnabled
    public static Decimal getProductRelatedSpecWeight(String cartId){
        
        List<String> pIds = new List<String>();
        List<ccrz__E_CartItem__c> cartItemObj = new List<ccrz__E_CartItem__c>();
        Map<String,Decimal> productQuantityMap = new Map<String,Decimal>();
        cartItemObj =[SELECT ID,ccrz__Product__c,ccrz__Product__r.dbu_Crate_Engine__c,ccrz__Quantity__c FROM ccrz__E_CartItem__c  WHERE dbu_isShipTo__c = true AND ccrz__Cart__c =:cartId];
        
        if(cartItemObj.size() > 0){
            for(ccrz__E_CartItem__c obj : cartItemObj){
                system.debug('dbu_Crate_Engine__c ' + obj.ccrz__Product__r.dbu_Crate_Engine__c);
                if(!obj.ccrz__Product__r.dbu_Crate_Engine__c){
                    pIds.add(obj.ccrz__Product__c);
                    productQuantityMap.put(obj.ccrz__Product__c,obj.ccrz__Quantity__c);
                }
            }
        }
        
        system.debug('productQuantityMap ' + productQuantityMap);
        list<ccrz__E_ProductSpec__c > lst = [select  id,ccrz__Spec__r.Name,ccrz__SpecValue__c,ccrz__Product__c from ccrz__E_ProductSpec__c where ccrz__Product__c IN :pIds AND ccrz__Spec__r.Name = 'Shipment Weight'];
        system.debug('lst ' + lst);
        decimal weight = 0.00;
        if(lst != NULL){
            for(ccrz__E_ProductSpec__c obj: lst){
                if(productQuantityMap.containsKey(obj.ccrz__Product__c)){
                    system.debug('weight ' + obj.ccrz__SpecValue__c + 'quantuty ' + productQuantityMap.get(obj.ccrz__Product__c));
                    Decimal weightValue = 0.00;
                    if(obj.ccrz__SpecValue__c.contains('')){
                        weightValue = Decimal.valueOf(obj.ccrz__SpecValue__c.substringBefore(' '));
                    }else{
                        weightValue = Decimal.valueOf(obj.ccrz__SpecValue__c);
                    }
                    if(productQuantityMap.get(obj.ccrz__Product__c) != Null){
                        weightValue = weightValue * productQuantityMap.get(obj.ccrz__Product__c);
                    }
                    System.debug('weightValue ' + weightValue);
                    weight = weight + weightValue;
                }
            }
        }
        system.debug('Weight total ' + weight);
        return weight;
    }
    
    @AuraEnabled
    public static void insertPickUpStoreDataInCCObj(string storeLocCode,string cartID,string shipMethod,string pickupstorename,
                                                    string cityPickup,string streetPickup,string statePickup,
                                                    string zipPickup,string cntryPickup,string phonePickup
                                                   ){   //string updPickupSelectedOnCart
                                                       List<ccrz__E_Cart__c> ccCart = new List<ccrz__E_Cart__c>();
                                                       List<ccrz__E_Cart__c> updateccCart = new List<ccrz__E_Cart__c>();
                                                       ccrz__E_ContactAddr__c newRec = new ccrz__E_ContactAddr__c();
                                                       system.debug('cartID' +cartID);
                                                       try{
                                                           if(cartID != ''){
                                                               
                                                               system.debug('newRec' +newRec);
                                                               ccCart = [Select id,dbu_Pick_Up_From_Store__c,ccrz__ShipMethod__c,ccrz__ShipTo__c from ccrz__E_Cart__c WHERE id=:cartID];
                                                               system.debug('ccCart' +ccCart);
                                                               
                                                               if(ccCart != null){
                                                                   if(ccCart[0].dbu_Pick_Up_From_Store__c == null){
                                                                       
                                                                       newRec.ccrz__ShippingComments__c = shipMethod;
                                                                       newRec.ccrz__AddressFirstline__c = streetPickup;
                                                                       newRec.ccrz__City__c = cityPickup;
                                                                       newRec.ccrz__State__c = statePickup;
                                                                       newRec.ccrz__Country__c = cntryPickup;
                                                                       newRec.ccrz__PostalCode__c=zipPickup;
                                                                       newRec.ccrz__HomePhone__c = phonePickup;
                                                                       newRec.dbu_PickUp_Store_Name__c = pickupstorename;
                                                                       insert newRec;
                                                                   }
                                                                   system.debug('entering');
                                                                   
                                                                   for(ccrz__E_Cart__c updateCart: ccCart){
                                                                       system.debug('updateCart.dbu_Pick_Up_From_Store__c' +updateCart.dbu_Pick_Up_From_Store__c);
                                                                       if(updateCart.dbu_Pick_Up_From_Store__c == null){
                                                                           system.debug('entering the if lopppp>>>');
                                                                           updateCart.dbu_Pick_Up_From_Store__c = newRec.id;
                                                                       }
                                                                       /*
commented by malhar- for new inventory changes
if(updPickupSelectedOnCart != null){
updateCart.ccrz__ShipMethod__c = updPickupSelectedOnCart;
}*/
                                                                       // if(storeLocCode != null){
                                                                       // commented by Shriram- for new inventory changes
                                                                       system.debug('storeLocCode222' +storeLocCode);
                                                                       //updateCart.dbu_StoreCode__c = storeLocCode;
                                                                       system.debug('updateCart.dbu_StoreCode__c' +updateCart.dbu_StoreCode__c);
                                                                       // }
                                                                       updateccCart.add(updateCart);
                                                                       system.debug('updateccCart' +updateccCart);
                                                                       
                                                                       
                                                                   }
                                                                   if(updateccCart.size()>0){
                                                                       system.debug('updateccCart>>>>' +updateccCart);
                                                                       
                                                                       update updateccCart;
                                                                   }
                                                               }
                                                           }
                                                       }
                                                       catch(exception exc){
                                                           system.debug('exception in checkout cntrl insertPickUpStoreDataInCCObj>' +exc.getLineNumber()+''+exc.getMessage());
                                                       }
                                                       
                                                       
                                                   } 
    
    @AuraEnabled
    public static String insertUpdatePickUpStoreDataInCCObj(String storeAddressJson){
        Map<String,object> mapOfAddressFields = (Map<String,object>)JSON.deserializeUntyped(storeAddressJson);
        String cartId = (String)mapOfAddressFields.get('cartId');      
        String cartItemId = (String)mapOfAddressFields.get('cartItemId');  
        List<ccrz__E_Cart__c> ccCart = new List<ccrz__E_Cart__c>();
        List<ccrz__E_Cart__c> updateccCart = new List<ccrz__E_Cart__c>();
        ccrz__E_ContactAddr__c newRec = new ccrz__E_ContactAddr__c();
        List<ccrz__E_ContactAddr__c> updateCCAddress = new List<ccrz__E_ContactAddr__c>();
        boolean isShipTo = (Boolean)mapOfAddressFields.get('isShipTo');
        String productId = (String)mapOfAddressFields.get('productId'); 
        List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
        /**
* New logic for core product
*/
        ccrz__E_Product__c relatedCoreProduct = dbu_CartCtrl.getRelatedProductByProductId(productId);
        System.debug('relatedCoreProduct==\t'+relatedCoreProduct);
        if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
            System.debug('Inside the relatedCoreProduct=== ');
            lstCartItem = [select id, dbu_isShipTo__c from ccrz__E_CartItem__c where (id =: cartItemId) OR (ccrz__Product__c =: relatedCoreProduct.Id AND ccrz__Cart__c =: cartID) ];
            //lstCartItem = [select id, dbu_isShipTo__c from ccrz__E_CartItem__c where (ccrz__Product__c =: productId AND ccrz__Cart__c =: cartID) ];
        }else{
            lstCartItem = [select id, dbu_isShipTo__c from ccrz__E_CartItem__c where id =: cartItemId];
        }
        System.debug('lstCartItem size=\t'+lstCartItem.size()+'\tlstCartItem\t'+lstCartItem);
        /**End of the core product logic */
        //lstCartItem = [select id, dbu_isShipTo__c from ccrz__E_CartItem__c where id =: cartItemId OR ccrz__Product__c =: productId];
        system.debug('cartID\t' +cartId+'\tcartItemId\t' +cartItemId+'\tisShipTo\t' +isShipTo);
        try{
            
            if(cartId != ''){
                ccCart = [Select id,dbu_Pick_Up_From_Store__c,ccrz__ShipMethod__c,ccrz__ShipTo__c from ccrz__E_Cart__c WHERE id=:cartID];
                if(ccCart.size() > 0){
                    if(ccCart[0].dbu_Pick_Up_From_Store__c == null){
                        newRec.ccrz__AddressFirstline__c = (String)mapOfAddressFields.get('streetPickup');
                        newRec.ccrz__City__c = (String)mapOfAddressFields.get('cityPickup');
                        newRec.ccrz__State__c = (String)mapOfAddressFields.get('statePickup');
                        newRec.ccrz__Country__c = (String)mapOfAddressFields.get('cntryPickup');
                        newRec.ccrz__PostalCode__c = (String)mapOfAddressFields.get('zipPickup');
                        newRec.ccrz__HomePhone__c =(String)mapOfAddressFields.get('phonePickup');
                        newRec.dbu_PickUp_Store_Name__c = (String)mapOfAddressFields.get('pickupstorename');
                        newRec.dbu_StartEndTimeOfStore__c = (String)mapOfAddressFields.get('businessHrs');
                        newRec.dbu_TimeZone__c = (String)mapOfAddressFields.get('timeZone');
                        newRec.dbu_zone__c = (String)mapOfAddressFields.get('zone');
                        newRec.dbu_StoreSFId__c = (String)mapOfAddressFields.get('storeId');
                        insert newRec;
                        ccCart[0].dbu_Pick_Up_From_Store__c = newRec.Id;
                    }else {
                        updateCCAddress = [Select id,ccrz__ShippingComments__c,ccrz__AddressFirstline__c,dbu_TimeZone__c,dbu_StoreSFId__c,
                                           ccrz__City__c,ccrz__State__c,ccrz__Country__c,ccrz__PostalCode__c,ccrz__HomePhone__c
                                           FROM ccrz__E_ContactAddr__c WHERE ID =: ccCart[0].dbu_Pick_Up_From_Store__c];
                        if (updateCCAddress.size() > 0) {
                            updateCCAddress[0].ccrz__ShippingComments__c = (String)mapOfAddressFields.get('shipMethod');
                            updateCCAddress[0].ccrz__AddressFirstline__c = (String)mapOfAddressFields.get('streetPickup');
                            updateCCAddress[0].ccrz__City__c = (String)mapOfAddressFields.get('cityPickup');
                            updateCCAddress[0].ccrz__State__c = (String)mapOfAddressFields.get('statePickup');
                            updateCCAddress[0].ccrz__Country__c = (String)mapOfAddressFields.get('cntryPickup');
                            updateCCAddress[0].ccrz__PostalCode__c = (String)mapOfAddressFields.get('zipPickup');
                            updateCCAddress[0].ccrz__HomePhone__c =(String)mapOfAddressFields.get('phonePickup');
                            updateCCAddress[0].dbu_PickUp_Store_Name__c = (String)mapOfAddressFields.get('pickupstorename');
                            updateCCAddress[0].dbu_StartEndTimeOfStore__c = (String)mapOfAddressFields.get('businessHrs');
                            updateCCAddress[0].dbu_TimeZone__c = (String)mapOfAddressFields.get('timeZone');
                            updateCCAddress[0].dbu_zone__c = (String)mapOfAddressFields.get('zone');
                            updateCCAddress[0].dbu_StoreSFId__c = (String)mapOfAddressFields.get('storeId');
                            update updateCCAddress;
                        }
                    }
                    ccCart[0].dbu_StoreCode__c = (String)mapOfAddressFields.get('storeLocCode');
                    update ccCart;
                    if(lstCartItem.size() > 0){
                        lstCartItem[0].dbu_isShipTo__c = isShipTo;
                        if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                            if(lstCartItem.size() > 1){
                                lstCartItem[1].dbu_isShipTo__c = isShipTo;
                            }
                        }
                        update lstCartItem;
                        
                    }
                    try{
                        updateShippingAmountOnCart(true,cartId,'');
                    }catch(Exception ex){
                        System.debug('Exception in checkoutController in updateShippingAmountOnCart '+ex.getMessage()+'\t'+ex.getLineNumber());
                    }
                }
            }
        }catch(exception ex){
            System.debug(ex.getMessage()+ex.getLineNumber());
        }
        
        return (String)mapOfAddressFields.get('cityPickup');     
    } 
     
}