public without sharing class dbu_ReviewOrder {
    
    @AuraEnabled(cacheable=true)
    public static  list<dbu_ReviewOrderAddressWrapper> fetchOrderDetails(String cartId){
        system.debug('cartId>>' +cartId);
        Set<String> cartIdList = new Set<String>{cartId};  
            list<dbu_ReviewOrderShippingAddWrapper> AddressList = new list<dbu_ReviewOrderShippingAddWrapper>();
        List<dbu_ReviewOrderBillingAddWrapper> billingAddressList = new List<dbu_ReviewOrderBillingAddWrapper>();
        dbu_ReviewOrderAddressWrapper addressWrapper = new dbu_ReviewOrderAddressWrapper();
        List<dbu_ReviewOrderAddressWrapper> shippingBillingAddWrapperList = new List<dbu_ReviewOrderAddressWrapper>();


        Map<String, Object> cartFetchQuery = new Map<String, Object>{
            ccrz.ccApiCart.CART_IDLIST => cartIdList,
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                
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
            
            //############################### FIRE FETCH METHOD OF CC CART API #########################################    
            try {
                Map<String, Object> cartFetchData = ccrz.ccApiCart.fetch(cartFetchQuery); 
                system.debug('cartFetchData'+cartFetchData);
                
                //################## Fetch CC Contact Address Details BillTo & ShipTo #########################
                if(cartFetchData.get(ccrz.ccApiAddress.ADDRESSLIST) != null){
                    List<Map<String, Object>> outputAddressList = (List<Map<String, object>>) cartFetchData.get(ccrz.ccApiAddress.ADDRESSLIST);
                    
                    
                    System.debug('AddressDetails::::: ' +json.serialize(outputAddressList) );
                    if(outputAddressList !=null && outputAddressList.size()>0)
                    {
                        system.debug('inside if');
                        for(Map<String,Object> ob:outputAddressList)
                        {
                            system.debug('inside for'+(string)ob.get('shippingComments'));
                            if((string)ob.get('shippingComments') == 'Shipping Comments' || (string)ob.get('shippingComments') == 'Expédition Comments'){
                                dbu_ReviewOrderShippingAddWrapper wrap = new dbu_ReviewOrderShippingAddWrapper();
                                wrap.firstName= (String)ob.get('firstName');
                                wrap.lastName=(string)ob.get('lastName');
                                wrap.addressFirstline=(string)ob.get('addressFirstline');
                                wrap.addressSecondline=(string)ob.get('addressSecondline');
                                wrap.shippingComments = (string)ob.get('shippingComments');
                                wrap.postalCode = (string)ob.get('postalCode');
                                wrap.city = (string)ob.get('city');
                                wrap.state = (string)ob.get('state');
                                if((string)ob.get('country') == 'US'){
                                    wrap.country = 'U.S.A';
                                }else if((string)ob.get('country') == 'CA'){
                                    wrap.country = 'Canada';
                                }
                                //wrap.country = (string)ob.get('country');
                                AddressList.add(wrap);
                                system.debug('AddressList>>' +AddressList);
                            }
                            if((string)ob.get('shippingComments') == 'Billing Comments' || (string)ob.get('shippingComments') == 'Facturation Comments'){
                                dbu_ReviewOrderBillingAddWrapper wrap = new dbu_ReviewOrderBillingAddWrapper();
                                wrap.firstName= (String)ob.get('firstName');
                                wrap.lastName=(string)ob.get('lastName');
                                wrap.addressFirstline=(string)ob.get('addressFirstline');
                                wrap.addressSecondline=(string)ob.get('addressSecondline');
                                wrap.shippingComments = (string)ob.get('shippingComments');
                                wrap.postalCode = (string)ob.get('postalCode');
                                wrap.city = (string)ob.get('city');
                                wrap.state = (string)ob.get('state');
                                if((string)ob.get('country') == 'US'){
                                    wrap.country = 'U.S.A';
                                }else if((string)ob.get('country') == 'CA'){
                                    wrap.country = 'Canada';
                                }
                                //wrap.country = (string)ob.get('country');
                                billingAddressList.add(wrap);
                                 system.debug('Billing>>' +billingAddressList);
                            }
                              
                        }
                        if(AddressList != null){
                            addressWrapper.AddressList = AddressList ;
                        }
                        if(billingAddressList != null){
                            addressWrapper.billingAddressList =billingAddressList ;
                        }
                        shippingBillingAddWrapperList.add(addressWrapper);
                        system.debug('shippingBillingAddWrapperList' +shippingBillingAddWrapperList);
                    }
                }
                
                
                //################## Fetch Cart Details #########################
                if (cartFetchData.get(ccrz.ccApiCart.CART_OBJLIST) != null) {        
                    List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) cartFetchData.get(ccrz.ccApiCart.CART_OBJLIST);
                    System.debug(JSON.serializePretty('CartDetails::::: ' + outputCartList));        
                }
            } catch (Exception e) {
                // Error handling...
                system.debug('Exception Line Number'+e.getLineNumber()+''+'Exception Message'+e.getMessage());
            }
        
        return shippingBillingAddWrapperList;
    }
    public class dbu_ReviewOrderShippingAddWrapper {
        @AuraEnabled public String lastName;
        @AuraEnabled public String firstName;
        @AuraEnabled public String addressSecondline;
        @AuraEnabled public String addressFirstline;
        @AuraEnabled public String shippingComments;
        @AuraEnabled public String city;
        @AuraEnabled public String postalCode;
        @AuraEnabled public String state;
        @AuraEnabled public String country;
    }
    public class dbu_ReviewOrderBillingAddWrapper {
        @AuraEnabled public String lastName;
        @AuraEnabled public String firstName;
        @AuraEnabled public String addressSecondline;
        @AuraEnabled public String addressFirstline;
        @AuraEnabled public String shippingComments;
        @AuraEnabled public String city;
        @AuraEnabled public String postalCode;
        @AuraEnabled public String state;
        @AuraEnabled public String country;
    }
    
    public class dbu_ReviewOrderAddressWrapper {
       @AuraEnabled public list<dbu_ReviewOrderShippingAddWrapper> AddressList;
       @AuraEnabled public List<dbu_ReviewOrderBillingAddWrapper> billingAddressList;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_Cart__c> fetchPickUpData(String cartId){
        system.debug('cartId>>' +cartId);
        List<ccrz__E_Cart__c> cartList = new List<ccrz__E_Cart__c>();
        cartList = [Select id,ccrz__ShipMethod__c,dbu_Pick_Up_From_Store__c,dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,
                    dbu_Pick_Up_From_Store__r.ccrz__City__c,
                    dbu_Pick_Up_From_Store__r.ccrz__State__c,
                    dbu_Pick_Up_From_Store__r.ccrz__Country__c,
                    dbu_Pick_Up_From_Store__r.ccrz__HomePhone__c,
                    dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,
                    dbu_Pick_Up_From_Store__r.dbu_PickUp_Store_Name__c,
                    dbu_Pick_Up_From_Store__r.ccrz__ShippingComments__c
                   FROM ccrz__E_Cart__c 
                   WHERE id =:cartId];
        system.debug('cartList>>' +cartList);
        return cartList;
                                                            
    }
    
    
}