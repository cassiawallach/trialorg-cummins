/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-13-2022
 * @last modified by  : Modified by devaraj for Common repo test pick up
**/
//Method created & modified by Malhar Ulhas Agale last on 12 Dec, 2021
global without sharing class dbu_EXTEND_cc_hk_Order extends ccrz.cc_hk_Order{
    
    global override Map<String,Object> place(Map<String,Object> inputData){
        
                /*
        for(string each : inputData.keyset()){
        system.debug('KRASNOVDOVORSK IP KEY > ' + each + ' KRASNOVDOVORSK IP VALUE > ' + inputData.get(each) );          
        }
        */
        
        
        if(inputData.get('placeStep') == 'createOrderPre'){
            system.debug('IN PLACE STEP > ' + inputData.get('cartId'));
            if(inputData.get('cartId') != null){
                system.debug('IN PLACE STEP ' );
                string cartidBeforeOrderCreation = (string)inputData.get('cartId');
                system.debug('cartidBeforeOrderCreation > '  + cartidBeforeOrderCreation );
                
                list<ccrz__E_Cart__c> pickupAddressOfCurrentCart = new list<ccrz__E_Cart__c>();
                pickupAddressOfCurrentCart = [select id, 
                                              dbu_Pick_Up_From_Store__c,
                                              dbu_Pick_Up_From_Store__r.dbu_PickUp_Store_Name__c,
                                              dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,
                                              dbu_Pick_Up_From_Store__r.ccrz__City__c,
                                              dbu_Pick_Up_From_Store__r.ccrz__State__c,
                                              dbu_Pick_Up_From_Store__r.ccrz__Country__c,
                                              dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,                                              
                                              dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c,
                                              dbu_Pick_Up_From_Store__r.dbu_zone__c,
                                              dbu_Pick_Up_From_Store__r.dbu_TimeZone__c
                                              from ccrz__E_Cart__c where id =: cartidBeforeOrderCreation];
                system.debug('pickupAddressOfCurrentCart > ' + pickupAddressOfCurrentCart);                							
                if(pickupAddressOfCurrentCart.size() > 0){
                    if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__c != null){
                        system.debug('pickupAddressOfCurrentCart[0] > ' + pickupAddressOfCurrentCart[0]);
                        
                        ccrz__E_ContactAddr__c pickupaddressforOrder = new ccrz__E_ContactAddr__c();
                        
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_PickUp_Store_Name__c != null){
                            pickupaddressforOrder.dbu_PickUp_Store_Name__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_PickUp_Store_Name__c;
                        }                        
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c != null){
                            pickupaddressforOrder.ccrz__AddressFirstline__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c;
                        }
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__City__c != null){
                            pickupaddressforOrder.ccrz__City__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__City__c;
                        }
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c != null){
                            pickupaddressforOrder.ccrz__Country__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__Country__c;
                        }
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__State__c != null){
                            pickupaddressforOrder.ccrz__State__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__State__c;
                        }                                                                       
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c != null){
                            pickupaddressforOrder.ccrz__PostalCode__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c;
                        }
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c != null){
                            pickupaddressforOrder.dbu_StartEndTimeOfStore__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c;
                        }
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_zone__c != null){
                            pickupaddressforOrder.dbu_zone__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_zone__c;
                        }
                        if(pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_TimeZone__c != null){
                            pickupaddressforOrder.dbu_TimeZone__c = pickupAddressOfCurrentCart[0].dbu_Pick_Up_From_Store__r.dbu_TimeZone__c;
                        }                          
                        
                        insert pickupaddressforOrder;
                        
                        if(inputData.get('order') != null){
                            ccrz__E_Order__c currentOrder = new ccrz__E_Order__c();
                            currentOrder = (ccrz__E_Order__c)inputData.get('order');
                            
                            currentOrder.dbu_PickUp_From__c = pickupaddressforOrder.id;
                            inputData.put('order', currentOrder);
                            
                        }
                        
                        
                        
                    }
                    
                }
                
            }
        }
        
        
        
        if(inputData.get('placeStep') == 'fetchCartItems'){
            if(inputData.get('cartItems') != null){
                list<ccrz__E_CartItem__c> cartitemslist = new list<ccrz__E_CartItem__c>();
                
                cartitemslist = (list<ccrz__E_CartItem__c>)inputData.get('cartItems');
                if(cartitemslist.size() > 0){
                    string currentCartId;
                    if(inputData.get('cartId') != null){
                        currentCartId = (string)inputData.get('cartId');
                        Map<id,ccrz__E_CartItem__c>  cartitemfetchedMap = new Map<id,ccrz__E_CartItem__c>([select id, dbu_Estimated_PickUp__c ,dbu_Estimated_Delivery__c ,dbu_isShipTo__c, dbu_isInStock__c from ccrz__E_CartItem__c where ccrz__Cart__c =: currentCartId]);
                        system.debug('cartitemfetchedMap > ' + cartitemfetchedMap); 
                        //cartitemfetchedMap = ;
                        
                        for(ccrz__E_CartItem__c each : cartitemslist){
                            if(cartitemfetchedMap.get(each.id) != null){
                                ccrz__E_CartItem__c currentcartitem = new ccrz__E_CartItem__c();
                                currentcartitem = (ccrz__E_CartItem__c)cartitemfetchedMap.get(each.id);
                                
                                each.dbu_isShipTo__c 			= currentcartitem.dbu_isShipTo__c;
                                
                                each.dbu_isInStock__c			= currentcartitem.dbu_isInStock__c;
                                
                                system.debug('currentcartitem.dbu_Estimated_PickUp__c > ' + currentcartitem.dbu_Estimated_PickUp__c); 
                                system.debug('currentcartitem.dbu_Estimated_Delivery__c > ' + currentcartitem.dbu_Estimated_Delivery__c); 
                                if(currentcartitem.dbu_Estimated_PickUp__c != null){
                                    system.debug('INSIDE PLO');
                                    each.dbu_Estimated_PickUp__c 	= currentcartitem.dbu_Estimated_PickUp__c;    
                                }else{
                                    system.debug('INSIDE else PLO');
                                    each.dbu_Estimated_PickUp__c = ''; 
                                }
                                
                                if(currentcartitem.dbu_Estimated_Delivery__c != null){
                                    system.debug('INSIDE ETA');
                                    each.dbu_Estimated_Delivery__c 	= currentcartitem.dbu_Estimated_Delivery__c;
                                }else{
                                    system.debug('INSIDE else ETA');
                                    each.dbu_Estimated_Delivery__c = '';
                                }
                                
                            }
                        }
                        inputData.put('cartItems', cartitemslist);						 
                    }
                    
                }
                
            }
        } 
        system.debug('ASHGABAT > ' + inputData.get('cartItems'));
        
        if(inputData.get('placeStep') == 'orderItemsPre'){			
            if(inputData.get('cartItems') != null){
                list<ccrz__E_CartItem__c> cartitemslist = new list<ccrz__E_CartItem__c>();
                cartitemslist = (list<ccrz__E_CartItem__c>)inputData.get('cartItems');
                Map<id,ccrz__E_CartItem__c> currentCartitemsMap = new Map<id,ccrz__E_CartItem__c>();
                if(cartitemslist.size() > 0 ){
                    for(ccrz__E_CartItem__c each : cartitemslist){
                        currentCartitemsMap.put(each.id, each);
                    }
                    
                    list<ccrz__E_OrderItem__c> orderitemslist = new list<ccrz__E_OrderItem__c>();
                    orderitemslist = (list<ccrz__E_OrderItem__c>)inputData.get('orderItems');
                    
                    string CustomerEmail;
                    ccrz__E_Order__c currentorder = new ccrz__E_Order__c();
                    if(inputData.get('order') != null){
                        currentorder = (ccrz__E_Order__c)inputData.get('order');
                        if(currentorder.ccrz__BuyerEmail__c != null && currentorder.ccrz__BuyerEmail__c != ''){
                            CustomerEmail = currentorder.ccrz__BuyerEmail__c;
                        }
                    }
                    system.debug('CustomerEmail > ' + CustomerEmail); 
                    
                    for(ccrz__E_OrderItem__c each : orderitemslist){
                        if(currentCartitemsMap.get(each.ccrz__OrderItemId__c) != null){
                            ccrz__E_CartItem__c eachcartitem = new ccrz__E_CartItem__c();
                            eachcartitem = (ccrz__E_CartItem__c)currentCartitemsMap.get(each.ccrz__OrderItemId__c); 
                            
                            
                            each.dbu_isShipTo__c = 	eachcartitem.dbu_isShipTo__c;
                            each.dbu_isInStock__c = eachcartitem.dbu_isInStock__c;
                            
                            system.debug('eachcartitem.dbu_Estimated_PickUp__c > ' + eachcartitem.dbu_Estimated_PickUp__c); 
                            system.debug('eachcartitem.dbu_Estimated_Delivery__c > ' + eachcartitem.dbu_Estimated_Delivery__c);                            
                            
                            if(eachcartitem.dbu_Estimated_PickUp__c != null){                            
                                each.dbu_Estimated_PickUp__c = 	eachcartitem.dbu_Estimated_PickUp__c;
                            }
                            if(eachcartitem.dbu_Estimated_Delivery__c != null){
                                each.dbu_Estimated_Delivery__c = 	eachcartitem.dbu_Estimated_Delivery__c;
                            }
                            
                            if(CustomerEmail != null){
                                each.dbu_BuyerEmailAddress__c = CustomerEmail;
                            }
                            
                        }
                    }
                    
                    inputData.put('orderItems', orderitemslist);
                }
            }
        }
        
        system.debug('khiva > ' + inputData.get('orderItems'));
        Map<String,Object> retMap = super.place(inputData);
        
        /*
for(string each : retMap.keyset()){
system.debug('TURKMENBASHY IP KEY > ' + each + ' TURKMENBASHY IP VALUE > ' + retMap.get(each) );           
}
*/
        return  retMap;
    }
    
}