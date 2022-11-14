public with sharing class dbu_RetryOrderSubmitAPI {
    public static dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper retunOrderOrSubmitDetails(List<ccrz__E_Order__c> orderDetails,String orderSubmitOrReturn){
        
        dbu_Integration_OrderSubmit.OrderSubmitRequestData  orderSubmitRequestData;
        dbu_Integration_OrderSubmit.OrderSubmitResponseWrapper response;
        //List<ccrz__E_Order__c> orderDetails = New List<ccrz__E_Order__c>();
        ccrz__E_Order__c obj =new ccrz__E_Order__c();
        Boolean shippingMethod =False;
        string dropOffLoc;
        Map < String, List < ccrz__E_OrderItem__c >> mapOrderItemList = new Map < String, List < ccrz__E_OrderItem__c >> ();
        System.debug('orderDetails--->>'+orderDetails);
        for (ccrz__E_Order__c orderDeta: orderDetails) {
            if (orderDeta.ccrz__E_OrderItems__r != null) {
                mapOrderItemList.put(orderDeta.id, orderDeta.ccrz__E_OrderItems__r);
            }
            obj.id = orderDeta.Id;
            for(ccrz__E_OrderItem__c oItem: mapOrderItemList.get(orderDeta.id)){
                if(oItem.dbu_Shipto__c == True){
                    shippingMethod=True;
                }else
                dropOffLoc=oItem.dbu_Dropoff_Location__c;
              }
            //if(String.isNotBlank(orderSubmitOrReturn) && orderSubmitOrReturn.equalsIgnoreCase('submit')){
             //   obj.ccrz__OrderStatus__c = 'Order Submitted';
            //}
        }
        system.debug('mapOrderItemList--->>>' + mapOrderItemList);
        if(orderDetails != Null){
        try{ 
            dbu_Integration_OrderSubmit.ShipToCustomer shipToCustomer = new dbu_Integration_OrderSubmit.ShipToCustomer();
            dbu_Integration_OrderSubmit.ShipToCustomer pickFromCustomer = new dbu_Integration_OrderSubmit.ShipToCustomer();
            if( orderSubmitOrReturn == 'submit'){
                //if(orderDetails[0].ccrz__ShipMethod__c =='Ship To Address'){
                  if(orderDetails[0].ccrz__ShipTo__r != null){    
                    shipToCustomer.address1 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                    shipToCustomer.address2 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                    shipToCustomer.address3 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressThirdline__c;
                    shipToCustomer.city =orderDetails[0].ccrz__ShipTo__r.ccrz__City__c;
                    shipToCustomer.state =orderDetails[0].ccrz__ShipTo__r.ccrz__State__c;
                    if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                        shipToCustomer.country ='US';
                    }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                        shipToCustomer.country ='CA';
                    }
                    if(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c != null){
                        //shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                        //6th Feb Changed by Shri Ram 
                        if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                            if((orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).length() >= 5){
                                shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                            }else{
                                shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                            }
                        }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                           shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                            
                        }
                    }
                //}else if(orderDetails[0].ccrz__ShipMethod__c =='Pick Up'){
                  }
                if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r != null){  
                    pickFromCustomer.address1 =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c;
                    pickFromCustomer.address2 =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressSecondline__c;
                    pickFromCustomer.address3 =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__AddressThirdline__c;
                    pickFromCustomer.city =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__City__c;
                    pickFromCustomer.state =orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__State__c;
                    if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'US' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A.'){
                        pickFromCustomer.country ='US';
                    }else if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'CA'){
                        pickFromCustomer.country ='CA';
                    }
                    if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c != null){
                        //shipToCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c).substring(0,5);
                        //6th Feb Changed by Shri Ram 
                        if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'US' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'U.S.A.'){
                            if((orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c).length() >= 5){
                                pickFromCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c).substring(0,5);
                            }else{
                                pickFromCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                            }
                        }else if(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__Country__c == 'CA'){
                            
                            pickFromCustomer.postalCode =(orderDetails[0].ccrz__OriginatedCart__r.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                        }
                    }
                    pickFromCustomer.partyName =orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
                }
            }else{
                if(shippingMethod){
                  shipToCustomer.address1 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                  shipToCustomer.address2 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                  shipToCustomer.address3 =orderDetails[0].ccrz__ShipTo__r.ccrz__AddressThirdline__c;
                  shipToCustomer.city =orderDetails[0].ccrz__ShipTo__r.ccrz__City__c;
                  shipToCustomer.state =orderDetails[0].ccrz__ShipTo__r.ccrz__State__c;
                  if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                      shipToCustomer.country ='US';
                  }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                      shipToCustomer.country ='CA';
                  }
                  if(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c != null){
                      //shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                      //6th Feb Changed by Shri Ram 
                      if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US'){
                          if((orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).length() >= 5){
                              shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c).substring(0,5);
                          }else{
                              shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                          }
                      }else if(orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA'){
                          
                         shipToCustomer.postalCode =(orderDetails[0].ccrz__ShipTo__r.ccrz__PostalCode__c);
                         
                      }
                  }
              }else{
                  List<String> commaSaparate = dropOffLoc.split(',');
                  if(commaSaparate[2] != Null){
                  shipToCustomer.address1 =commaSaparate[2];
                  }
                  shipToCustomer.address2 ='';
                  shipToCustomer.address3 ='';
                  if(commaSaparate[1] != Null)
                  shipToCustomer.city =commaSaparate[1];
                  if(commaSaparate[3] != Null)
                  shipToCustomer.state =commaSaparate[3];
                  if(commaSaparate[4] != Null){
                      if(commaSaparate[4] == 'United States' || commaSaparate[4] == 'US' || commaSaparate[4] == 'U.S.A' || commaSaparate[4] == 'U.S.A.'){
                          shipToCustomer.country ='US';
                      }else if(commaSaparate[4] == 'Canada' || commaSaparate[4] == 'CA'){
                          shipToCustomer.country ='CA';
                      }
                  }
                  
                  if(commaSaparate[5] != null){
                      if(commaSaparate[4] == 'United States' || commaSaparate[4] == 'US' || commaSaparate[4] == 'U.S.A' || commaSaparate[4] == 'U.S.A.'){
                          if((commaSaparate[5]).length() > 5){
                              shipToCustomer.postalCode =(commaSaparate[5]).substring(0,5);
                          }else{
                              shipToCustomer.postalCode =commaSaparate[5];
                          }
                      }else if(commaSaparate[4] == 'Canada' || commaSaparate[4] == 'CA'){
                          
                          shipToCustomer.postalCode =commaSaparate[5];
                       }
                  }
              }
            }    
            shipToCustomer.partyName =orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
           
            List<dbu_Integration_OrderSubmit.ShipToCustomer> shipToCustomerList = new List<dbu_Integration_OrderSubmit.ShipToCustomer>();
            List<dbu_Integration_OrderSubmit.ShipToCustomer> pickFromCustomerList = new List<dbu_Integration_OrderSubmit.ShipToCustomer>();//Inventory related changes

            shipToCustomerList.add(shipToCustomer);
            pickFromCustomerList.add(pickFromCustomer);//Inventory related changes
            // need to create objects depends on the method input parameter dynamically
            dbu_Integration_OrderSubmit.ShipToDistributor shipToDistributor = new  dbu_Integration_OrderSubmit.ShipToDistributor();
            shipToDistributor.address1 = orderDetails[0].ccrz__Account__r.BillingStreet;
            shipToDistributor.address2 = orderDetails[0].ccrz__Account__r.CMI_Address2__c;
            shipToDistributor.address3 = orderDetails[0].ccrz__Account__r.CMI_Address3__c;
            shipToDistributor.city = orderDetails[0].ccrz__Account__r.BillingCity;
            shipToDistributor.state = orderDetails[0].ccrz__Account__r.BillingState;
            if(orderDetails[0].ccrz__Account__r.BillingCountry =='United States' || orderDetails[0].ccrz__Account__r.BillingCountry =='US'){
                shipToDistributor.country = 'US';
            }else if(orderDetails[0].ccrz__Account__r.BillingCountry =='Canada' || orderDetails[0].ccrz__Account__r.BillingCountry =='CA'){
                shipToDistributor.country = 'CA';
            }
            shipToDistributor.postalCode = orderDetails[0].ccrz__Account__r.BillingPostalCode;
            shipToDistributor.partyName = orderDetails[0].ccrz__Account__r.Name;
            List<dbu_Integration_OrderSubmit.ShipToDistributor> shipToDistributorList = new List<dbu_Integration_OrderSubmit.ShipToDistributor>();
            shipToDistributorList.add(shipToDistributor);
           
            // need to create objects depends on the method input parameter dynamically
           // dbu_Integration_OrderSubmit.Lines lines = new dbu_Integration_OrderSubmit.Lines();
            List<dbu_Integration_OrderSubmit.Lines> linesList = new List<dbu_Integration_OrderSubmit.Lines>();
            List<String>  orderListForShipping = new List<String>();
            list<String> orderItemIdsForShipping = new List<String>();
            if(mapOrderItemList.keyset() != null && mapOrderItemList.size() > 0){
                for (ccrz__E_Order__c orderDetil: orderDetails) {
                    orderListForShipping.add(orderDetil.Id);
                    for(ccrz__E_OrderItem__c oItem: mapOrderItemList.get(orderDetil.id)){
                        dbu_Integration_OrderSubmit.Lines lines = new dbu_Integration_OrderSubmit.Lines();
                        orderItemIdsForShipping.add(oItem.Id);
                        lines.lineId = oItem.Name;
                        lines.orderedQuantity = Integer.ValueOf(oItem.ccrz__Quantity__c);
                        if(oItem.ccrz__Product__r.dbu_Has_Core_Charge__c == True && orderSubmitOrReturn.equalsIgnoreCase('return')){
                            lines.orderReturnFlag = 'C';
                                
                        }else if(oItem.ccrz__Product__r.dbu_Has_Core_Charge__c == False && orderSubmitOrReturn.equalsIgnoreCase('return')){
                            lines.orderReturnFlag = 'N';
                        }else if(String.isNotBlank(orderSubmitOrReturn) && orderSubmitOrReturn.equalsIgnoreCase('submit')){
                            lines.orderReturnFlag = '';
                        //  if(oItem.ccrz__Order__r.ccrz__ShipMethod__c == 'Ship To Address'){
                        //       lines.deliveryMethod = 'SHIP';  
                        //   }else if(oItem.ccrz__Order__r.ccrz__ShipMethod__c == 'Pick Up'){
                        //       lines.deliveryMethod = 'PICK';//HardCode
                        //   }
                        // New Inventory chanages
                        if(oItem.dbu_isShipTo__c){
                            lines.deliveryMethod = 'SHIP';
                            lines.shippingMode = 'SHIP';
                        }else{
                            lines.deliveryMethod = 'PICK';
                            if(oItem.dbu_isInStock__c != null && oItem.dbu_isInStock__c){
                                lines.shippingMode = 'PICK';
                            }else{
                                lines.shippingMode = 'pick';
                            }
                        }
                        // End Here
                        }
                        if(oItem.ccrz__Product__r.dbu_Product_Code__c != Null){
                            lines.productCode = oItem.ccrz__Product__r.dbu_Product_Code__c;
                        }
                        
                        //lines.shippingMode = '';
                        lines.partNumber = oItem.ccrz__Product__r.dbu_Part_Number__c;
                        if(oItem.ccrz__Price__c != null){
                            lines.unitSellingPrice = oItem.ccrz__Price__c; //Ramesh change CHG0111237 Reverted
                        }else{
                            lines.unitSellingPrice = 0.00;
                        }
                        lines.unitOfMeasure = oItem.ccrz__Product__r.ccrz__UnitOfMeasure__c;//New
                    if(String.isNotBlank(orderSubmitOrReturn) && orderSubmitOrReturn.equalsIgnoreCase('return')){
                        if(oItem.dbu_Shipto__c == True){
                              lines.deliveryMethod = 'SHIP';  
                          }else 
                              lines.deliveryMethod = 'PICK';//HardCode
                        }  
                        lines.unitDiscount = 0.0;
                        if(oItem.ccrz__AbsoluteDiscount__c != null){
                            lines.couponDiscount = oItem.ccrz__AbsoluteDiscount__c;
                        }else{
                            lines.couponDiscount = 0;
                        }
                        
                        if(oItem.ccrz__Order__r.ccrz__ShipAmount__c != null && orderSubmitOrReturn.equalsIgnoreCase('submit')){
                            lines.shippingCharges = oItem.ccrz__Order__r.ccrz__ShipAmount__c;
                        }else{
                            lines.shippingCharges = 0;
                        }
                        if(oItem.ccrz__Product__r.ccrz__Quantityperunit__c != null){
                                lines.quantityPerUnit = String.valueOf(oItem.ccrz__Product__r.ccrz__Quantityperunit__c);
                        }
                        if(oItem.Vertex_Tax__c != null){
                            lines.taxAmount = oItem.Vertex_Tax__c;
                        }else{
                            lines.taxAmount = 0.00;
                        }
                        //lines.taxAmount = oItem.Vertex_Tax__c;
                        if(oItem.ccrz__Product__r.ccrz__TaxRateId__c != null){
                            lines.taxClassificationCode = oItem.ccrz__Product__r.ccrz__TaxRateId__c;
                          }
                        if(orderSubmitOrReturn.equalsIgnoreCase('submit')){
                            if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US') && (oItem.dbu_isShipTo__c)){
                                  lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_US;
                              }else if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA') && (oItem.dbu_isShipTo__c)){
                                  lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_CA;
                              }else if(!oItem.dbu_isShipTo__c){
                                  lines.fulfillmentLocationCode = oItem.ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c;
                              }
                        }else{
                            if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'US') && oItem.dbu_Shipto__c == True){
                              lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_US;
                              }else if((orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__ShipTo__r.ccrz__Country__c == 'CA') && oItem.dbu_Shipto__c == True){
                                  lines.fulfillmentLocationCode = label.dbu_FulfillmentLocationCode_CA;
                              }else if(oItem.dbu_Shipto__c == False){
                                  lines.fulfillmentLocationCode = oItem.dbu_StoreCode__c;
                              }
                        }
                        //lines.fulfillmentLocationCode = 'F2';//hardcoded
                        lines.shipToDistributor = shipToDistributorList;
                        // New Inventory changes
                        if(oItem.dbu_isShipTo__c){
                            lines.shipToCustomer = shipToCustomerList;
                        }else{
                            lines.shipToCustomer = pickFromCustomerList;
                        }
                        //lines.shipToCustomer = shipToCustomerList;
                        
                        linesList.add(lines);
                    }
                }
            }
            System.debug('linesList=>'+linesList);
            // need to create objects depends on the method input parameter dynamically
            dbu_Integration_OrderSubmit.BillToCustomer billToCustomer = new dbu_Integration_OrderSubmit.BillToCustomer();
            billToCustomer.address1 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressFirstline__c;
            billToCustomer.address2 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressSecondline__c;
            billToCustomer.address3 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressThirdline__c;
            billToCustomer.city = orderDetails[0].ccrz__BillTo__r.ccrz__City__c;
            billToCustomer.state = orderDetails[0].ccrz__BillTo__r.ccrz__State__c;
            if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                billToCustomer.country = 'US';
            }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                billToCustomer.country ='CA';
            }
            if(orderDetails[0].ccrz__BillTo__r !=null && String.isNotBlank((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c))){
               //billToCustomer.postalCode = (orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    if((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).length() >= 5){
                        billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                    }else{
                        billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                    }
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    
                    billToCustomer.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                 }
            }
            billToCustomer.partyName = orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
            billToCustomer.contactNumber = orderDetails[0].ccrz__BuyerPhone__c;//CHG0083792
            List<dbu_Integration_OrderSubmit.BillToCustomer> billToCustomerList = new List<dbu_Integration_OrderSubmit.BillToCustomer>();
            billToCustomerList.add(billToCustomer);
           
   
            // need to create objects depends on the method input parameter dynamically
            dbu_Integration_OrderSubmit.BuyingPartyAddress buyingPartyAddress = new dbu_Integration_OrderSubmit.BuyingPartyAddress();
            buyingPartyAddress.address1 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressFirstline__c;
            buyingPartyAddress.address2 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressSecondline__c;
            buyingPartyAddress.address3 = orderDetails[0].ccrz__BillTo__r.ccrz__AddressThirdline__c;
            buyingPartyAddress.city = orderDetails[0].ccrz__BillTo__r.ccrz__City__c;
            buyingPartyAddress.state = orderDetails[0].ccrz__BillTo__r.ccrz__State__c;
            if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                buyingPartyAddress.country = 'US';
            }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                buyingPartyAddress.country ='CA';
            }
            if(orderDetails[0].ccrz__BillTo__r != null && String.isNotBlank(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c)){
                //buyingPartyAddress.postalCode = (orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                 if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                    if((orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).length() >= 5){
                        buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c).substring(0,5);
                    }else{
                        buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                    }
                }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                    
                    buyingPartyAddress.postalCode =(orderDetails[0].ccrz__BillTo__r.ccrz__PostalCode__c);
                 }
            }
            
            List<dbu_Integration_OrderSubmit.BuyingPartyAddress> buyingPartyAddressList = new List<dbu_Integration_OrderSubmit.BuyingPartyAddress>();
            buyingPartyAddressList.add(buyingPartyAddress);
           
           
            orderSubmitRequestData = new dbu_Integration_OrderSubmit.OrderSubmitRequestData();
            orderSubmitRequestData.buyingPartyName = orderDetails[0].ccrz__BuyerFirstName__c+' '+orderDetails[0].ccrz__BuyerLastName__c;
            orderSubmitRequestData.buyingPartyNumber = '';
            orderSubmitRequestData.buyingPartyEmailID = orderDetails[0].ccrz__BuyerEmail__c;
            orderSubmitRequestData.buyingPartyAddress = buyingPartyAddressList;
            if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'United States' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'US'){
                orderSubmitRequestData.distributorCode = '02930';
            }else if(orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'Canada' || orderDetails[0].ccrz__BillTo__r.ccrz__Country__c == 'CA'){
                orderSubmitRequestData.distributorCode = '56270';
            }
            //orderSubmitRequestData.distributorCode = '';
            if(orderDetails[0].DBU_Customer_BMS_Number__c!=null)
            orderSubmitRequestData.customerCode=orderDetails[0].DBU_Customer_BMS_Number__c;
            orderSubmitRequestData.destinationTransactionSystem = 'BMS';
            //Added new fields 11thMay2021
            orderSubmitRequestData.cartId =orderDetails[0].ccrz__OriginatedCart__c;
            //Ramesh CHG0112651 start
            if(orderDetails[0].ccrz__TransactionPayments__r != null && orderDetails[0].ccrz__TransactionPayments__r.size() > 0){
                if(orderDetails[0].ccrz__PaymentMethod__c == 'credit card'){
                    orderSubmitRequestData.transactionSubcode =orderDetails[0].ccrz__TransactionPayments__r[0].ccrz__TransactionCode__c;
                }else {
                orderSubmitRequestData.transactionSubcode =orderDetails[0].ccrz__TransactionPayments__r[0].ccrz__TransactionSubcode__c;
                }
            }
            //Ramesh CHG0112651END
            //end
            orderSubmitRequestData.orderNumber = orderDetails[0].Name;
            orderSubmitRequestData.sourceTransactionSystem = 'CSSNA ECOM';
            orderSubmitRequestData.status = orderDetails[0].ccrz__OrderStatus__c;
            orderSubmitRequestData.submittedDate = String.ValueOf(orderDetails[0].ccrz__OrderDate__c);
            //orderSubmitRequestData.shippingMode = 'SHIP';//orderDetails[0].ccrz__ShipMethod__c; Its temporary fix
            if(orderSubmitOrReturn.equalsIgnoreCase('submit')){
                // if(orderDetails[0].ccrz__ShipMethod__c =='Ship To Address'){
                //     orderSubmitRequestData.shippingMode = 'SHIP';
                // }else if(orderDetails[0].ccrz__ShipMethod__c =='Pick Up'){
                //     orderSubmitRequestData.shippingMode = 'PICK';
                // }
                // New Inventory chanages
                orderSubmitRequestData.shippingMode = '';
                // End Here
              
            }else{
              if(shippingMethod){
                  orderSubmitRequestData.shippingMode = 'SHIP';
              }else{
                  orderSubmitRequestData.shippingMode = 'PICK';
              }
              
            }
            if(orderDetails[0].ccrz__PaymentMethod__c =='credit card'){
                  orderSubmitRequestData.paymentType = 'Card';
              }else if(orderDetails[0].ccrz__PaymentMethod__c =='PayPal'){
                  orderSubmitRequestData.paymentType = 'PayPal';
              }
            if(orderDetails[0].ccrz__TotalAmount__c != null){
                orderSubmitRequestData.totalOrderAmount = orderDetails[0].ccrz__TotalAmount__c;
            }else{
                orderSubmitRequestData.totalOrderAmount = 0.00;
            }
            if(orderDetails[0].ccrz__TaxAmount__c != null){
              orderSubmitRequestData.totalTaxAmount = orderDetails[0].ccrz__TaxAmount__c;
            }else{
                orderSubmitRequestData.totalTaxAmount = 0.00;
            }
            orderSubmitRequestData.billToCustomer = billToCustomerList;
            orderSubmitRequestData.lines = linesList;
            System.debug('orderSubmitRequestData=>'+orderSubmitRequestData);
            System.debug('JSON.serialize(orderSubmitRequestData)\t'+JSON.serialize(orderSubmitRequestData));
            
            response =  dbu_Integration_OrderSubmit.getOrderStatus(orderSubmitRequestData);
            String dbuLocationCode;
            String req=JSON.serialize(orderSubmitRequestData);
            System.debug('Response===>'+response);
            if(response.Status.equalsIgnoreCase('SUCCESS')){
                    obj.dbu_SubmitOrder_Success__c=True;
                    if(String.isNotBlank(orderSubmitOrReturn) && orderSubmitOrReturn.equalsIgnoreCase('return')){
                        dbuLocationCode = response.locationCode;
                        dbu_Integration_ShipStation.getShipStation(orderListForShipping,orderItemIdsForShipping,dbuLocationCode);
                        dbu_Integration_Error_Log.createErrorLog(200,'',req,Json.serialize(response),'Order Submit Service','Success');
                        List<dbu_Store_Location__c> storeLocation = new List<dbu_Store_Location__c>();
                        storeLocation=[Select id,name,dbu_City__c,dbu_Country__c,dbu_State__c,dbu_StoreCode__c,dbu_Street__c,dbu_ZipCode__c from dbu_Store_Location__c where dbu_StoreCode__c=:dbuLocationCode limit 1];
                        if(storeLocation.size()>0){
                            obj.dbu_StoreLocationAddress__c = storeLocation[0].dbu_Street__c+','+storeLocation[0].dbu_City__c+','+storeLocation[0].dbu_State__c+','+storeLocation[0].dbu_ZipCode__c+','+storeLocation[0].dbu_Country__c;
                        }
                     }else{
                         dbu_Integration_Error_Log.createErrorLog(200,'',req,Json.serialize(response),'Order Submit Service','Success');
                     }
                }
            if(obj.id != null){
               update obj; 
            }
           
        }catch(Exception ex){
            system.debug('Line Number\t'+ex.getLineNumber()+'---'+ex.getMessage());
             // CWiebe Added additional error log CHG0112240 & CHG0112559
            dbu_Integration_Error_Log.createErrorLog(null,ex.getMessage(),'','recordId: ' + orderDetails[0].Id,'Order Submit Service','Exception');
        }
      }
       return response;
    }
}