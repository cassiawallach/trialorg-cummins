/** 
* @Class Name: dbu_Integration_ShipStation    
* @Description      
- Constructor:  
* @Main Author: Ranadip Jha    
* @ Created on: 30/10/2020   
* @Last Modified: 26/03/2021              
*/
public without sharing class dbu_Integration_ShipStation {
    private static String ENP_POINT_URL;
    private static String METHOD_TYPE;
    private static String Content_Type;
    private static String CONSUMER_KEY;
    private static String CONSUMER_SECRET;
    private static String RESOURCE;
    private final static String REQUEST_BODY = 'grant_type=client_credentials&client_id={0}&client_secret={1}&resource={2}';
    public static String AccessToken;
    public static String SHIPSTATION_CONSUMER_KEY;
    public static String SHIPSTATION_CONSUMER_SECRET;
    public static boolean firstRun = true;
    
    //@future(callout = true)
    public static void getShipStation(List<String> orderIds,List<String> orderItemsIds,String locCode){
        
        Boolean isShippingLabel = false;
        Boolean isNotShippingLabel = false;
        Boolean isShipTo = false;
        String shippingIns = '';
        Boolean coreReturnShipping = False;
        Boolean coreReturnDropOff = False;
        string mSec;
        String pdf_ShippingIns;
        String localData;
        Boolean isDropOff = false;
        List<ccrz__E_Order__c>  orderList = new List<ccrz__E_Order__c>();
        List<String> productIds = new List<String>();
        List<ccrz__E_ProductSpec__c> listOfProductSpec = new List<ccrz__E_ProductSpec__c>();
        Map<String,List<ccrz__E_ProductSpec__c>> productSpecMap = new Map<String,List<ccrz__E_ProductSpec__c>>();
        EmailTemplate emailTemplate;
        EmailInsWrapper emailInsWrapper;
        
        String reasonDamageInShipping = System.Label.dbu_Return_Damaged_in_shipping;
        String reasonInCorrectPart = System.Label.dbu_Return_Incorrect_part_was_received; 
        String reasonPartNoLongerWanted = System.Label.dbu_Return_Part_no_longer_wanted; 
        String reasonOrderedWronPart = System.Label.dbu_Return_Ordered_the_wrong_part; 
        
        String reasonPartNoLongerWanted_FR = System.Label.dbu_reason_partNoLongerWanted_Pdf_FR; 
        String reasonDamageInShipping_FR = System.Label.dbu_DamagedInShipping_Pdf_FR;
        String reasonInCorrectPart_FR = System.Label.dbu_IncorrectPartWasReceived_Pdf_FR; 
        String reasonOrderedWronPart_FR = System.Label.dbu_OrderedTheWrongPart_Pdf_FR; 
        
        orderList = [SELECT Id,CC_Order__c,ccrz__CurrencyISOCode__c,ccrz__TotalAmount__c,ccrz__OrderDate__c,ccrz__BuyerEmail__c,ccrz__BuyerCompanyName__c,ccrz__BuyerFirstName__c,ccrz__BuyerMobilePhone__c,ccrz__BuyerPhone__c,ccrz__BuyerLastName__c,ccrz__User__c,dbu_Shipto__c,ccrz__Contact__c,ccrz__ShipTo__r.ccrz__FirstName__c,ccrz__ShipTo__r.ccrz__LastName__c,ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                     ccrz__ShipTo__r.ccrz__CompanyName__c,ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c, ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__PostalCode__c,
                     ccrz__ShipTo__r.ccrz__Country__c,ccrz__ShipTo__r.ccrz__HomePhone__c,Name,OwnerId,(SELECT Id,ccrz__Order__r.ccrz__CurrencyISOCode__c,dbu_Reason_for_Return__c,dbu_store_language__c,dbu_IsShippingLabelSent__c,dbu_Dropoff_Location__c,dbu_Estimated_Return_Amount__c,ccrz__Quantity__c,ccrz__Price__c,ccrz__Product_Name__c,dbu_Shipto__c,ccrz__Product__c,ccrz__OrderItemStatus__c,ccrz__Order__c
                                                                                                       FROM ccrz__E_OrderItems__r WHERE Id IN:orderItemsIds ) FROM ccrz__E_Order__c where Id IN: orderIds AND dbu_IsShippingLabelSent__c = false ];
        system.debug('orderList ' + orderList);
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
        
        for(ccrz__E_Order__c orderObj : orderList){
            
            for(ccrz__E_OrderItem__c orderitemObj : orderObj.ccrz__E_OrderItems__r){
                productIds.add(orderitemObj.ccrz__Product__c);
                localData = orderitemObj.dbu_store_language__c;
                // if(orderitemObj.dbu_Shipto__c == true && (orderitemObj.dbu_Reason_for_Return__c == 'Damaged in shipping' || orderitemObj.dbu_Reason_for_Return__c == 'Incorrect part was received')){
                if(orderitemObj.dbu_Shipto__c == true && (orderitemObj.dbu_Reason_for_Return__c == reasonDamageInShipping || orderitemObj.dbu_Reason_for_Return__c == reasonInCorrectPart || orderitemObj.dbu_Reason_for_Return__c == reasonDamageInShipping_FR || orderitemObj.dbu_Reason_for_Return__c == reasonInCorrectPart_FR )){ 
                    // flag = true;
                    isShippingLabel = true;
                }else if(orderitemObj.dbu_Shipto__c == true && (orderitemObj.dbu_Reason_for_Return__c == reasonPartNoLongerWanted || orderitemObj.dbu_Reason_for_Return__c == reasonOrderedWronPart || orderitemObj.dbu_Reason_for_Return__c == reasonPartNoLongerWanted_FR || orderitemObj.dbu_Reason_for_Return__c == reasonOrderedWronPart_FR)){
                    isNotShippingLabel = true;
                    
                }else if(orderitemObj.dbu_Shipto__c == false && orderitemObj.dbu_Reason_for_Return__c != NULL){
                    isDropOff = true;
                }
                else if(isNotShippingLabel == false && isShippingLabel == false && (orderitemObj.dbu_Reason_for_Return__c == '' || orderitemObj.dbu_Reason_for_Return__c == Null) && isDropOff == false){
                    if(orderitemObj.dbu_Shipto__c == true){
                        coreReturnShipping = True;
                    }else
                        coreReturnDropOff = True;
                }
                if(orderitemObj.dbu_Shipto__c){
                    isShipTo = true;
                }
            }
        }
        /*if(isShippingLabel){
            emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_return_Documents_ShippingLabel'];
        }else if(isShippingLabel == false && isNotShippingLabel == true){
            emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_returnOrderDocNotLabel'];
        }else if(coreReturnShipping){
            emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_CoreReturnShippingNotification'];
        }else if(coreReturnDropOff){
            emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_CoreReturnDropOffNotification'];
        }
        else{
            emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents'];         
        }*/
        
        if(!orderList.isEmpty()){
            emailInsWrapper = getShippingInstruction(localData,isShippingLabel,isNotShippingLabel,isShipTo,coreReturnShipping,coreReturnDropOff);
        }
        List<dbu_OrderItemShippingLabelEmailData> shipLabelData = new List<dbu_OrderItemShippingLabelEmailData>();
        if(isShippingLabel){
            listOfProductSpec = [select ccrz__Product__c,ccrz__SpecValue__c,ccrz__Spec__r.Name from ccrz__E_ProductSpec__c where ccrz__Product__c IN: productIds AND ccrz__Spec__r.Name = 'Shipment Weight'];
            
            for(String pId : productIds){
                List<ccrz__E_ProductSpec__c> listOfProductMapping = new List<ccrz__E_ProductSpec__c>();
                for(ccrz__E_ProductSpec__c productSpec : listOfProductSpec){
                    if(pId == productSpec.ccrz__Product__c){
                        listOfProductMapping.add(productSpec);
                    }
                }
                productSpecMap.put(pId,listOfProductMapping);
            }
            system.debug('productIds ' + productIds);
            
            for(ccrz__E_Order__c orderObj : orderList){
                if(!orderObj.ccrz__E_OrderItems__r.isEmpty()){
                    
                    ShipFrom shipForm = new ShipFrom();
                    shipForm.name = orderObj.ccrz__BuyerFirstName__c + ' ' + orderObj.ccrz__BuyerLastName__c;
                    if(orderObj.ccrz__CurrencyISOCode__c == 'CAD'){
                        shipForm.company = 'Cummins';
                    }else {
                        shipForm.company = orderObj.ccrz__BuyerCompanyName__c;
                    }
                    //shipForm.company = orderObj.ccrz__BuyerCompanyName__c;
                    shipForm.street1 = orderObj.ccrz__ShipTo__r.ccrz__AddressFirstline__c;
                    shipForm.street2 = orderObj.ccrz__ShipTo__r.ccrz__AddressSecondline__c;
                    shipForm.street3 = orderObj.ccrz__ShipTo__r.ccrz__AddressThirdline__c;
                    shipForm.city = orderObj.ccrz__ShipTo__r.ccrz__City__c;
                    shipForm.state = orderObj.ccrz__ShipTo__r.ccrz__State__c;
                    shipForm.postalCode = orderObj.ccrz__ShipTo__r.ccrz__PostalCode__c;
                    String countryForShip = orderObj.ccrz__ShipTo__r.ccrz__Country__c;
                    String shipFromCountry ;
                    if(countryForShip.equalsIgnoreCase('United States') || countryForShip.equalsIgnoreCase('U.S.A') || countryForShip.equalsIgnoreCase('U.S.A.') || countryForShip.equalsIgnoreCase('USA')){
                        shipFromCountry = 'US';
                    }else if(countryForShip.equalsIgnoreCase('Canada')){
                        shipFromCountry = 'CA';
                    }else{
                        shipFromCountry = orderObj.ccrz__ShipTo__r.ccrz__Country__c;
                    }
                    shipForm.country = shipFromCountry;
                    if(orderObj.ccrz__BuyerPhone__c != null){
                        shipForm.phone  = orderObj.ccrz__BuyerPhone__c;
                    }else{
                        shipForm.phone = orderObj.ccrz__BuyerMobilePhone__c;
                    }
                    shipForm.residential = false;
                    
                    ShipTo shipTo = new ShipTo();
                    if(orderObj.ccrz__CurrencyISOCode__c == 'USD'){
                        // Christopher CECI-1101 Start
                        // shipTo.name = System.Label.dbu_CoreReturnAddress + ' '+ System.Label.dbu_CoreReturnAddress1_US;
                        shipTo.name = System.Label.dbu_CoreReturnAddress1_US;
                        // Christopher CECI-1101 End
                        shipTo.company = '';
                        shipTo.street1 = System.Label.dbu_CoreReturnStreet_US;
                        //shipTo.street2 = '';
                        //shipTo.street3 = '';
                        shipTo.city = System.Label.dbu_CoreReturnCity_US;
                        shipTo.state = System.Label.dbu_CoreReturnState_US;
                        shipTo.postalCode = System.Label.dbu_CoreReturnZipCode_US;
                        shipTo.country = 'US';
                        shipTo.phone = '';
                        shipTo.residential = false;
                    }else if(orderObj.ccrz__CurrencyISOCode__c == 'CAD'){
                        shipTo.name = System.Label.dbu_CoreReturnAddress+' '+ System.Label.dbu_CoreReturnAddress1_EN;
                        shipTo.company = '';
                        shipTo.street1 = System.Label.dbu_CoreReturnStreet_EN;
                        //shipTo.street2 = '';
                        //shipTo.street3 = '';
                        shipTo.city = System.Label.dbu_CoreReturnCity_EN;
                        shipTo.state = System.Label.dbu_CoreReturnState_EN;
                        shipTo.postalCode = System.Label.dbu_CoreReturnZipCode_EN;
                        shipTo.country = 'CA';
                        shipTo.phone = '';
                        shipTo.residential = false;
                    }
                    
                    Weight weight = new Weight();
                    weight.units = 'pounds';
                    Decimal weightValues = 0.00;
                    
                    for(ccrz__E_OrderItem__c orderItemObj : orderObj.ccrz__E_OrderItems__r){
                        
                        if(isShippingLabel == true && orderItemObj.dbu_Reason_for_Return__c != NULL){
                            if(productSpecMap.containsKey(orderItemObj.ccrz__Product__c)){
                                List<ccrz__E_ProductSpec__c> productSpecLst = productSpecMap.get(orderItemObj.ccrz__Product__c);
                                for(ccrz__E_ProductSpec__c productSpec : productSpecLst){
                                    system.debug('productSpec ' + productSpec.ccrz__Spec__r.Name);
                                    Decimal weightValue = 0.00;
                                    if(productSpec.ccrz__SpecValue__c.contains(' ')){
                                        weightValue = Decimal.valueOf(productSpec.ccrz__SpecValue__c.substringBefore(' '));
                                    }else {
                                        weightValue = Decimal.valueOf(productSpec.ccrz__SpecValue__c);
                                    }
                                    if(orderItemObj.ccrz__Quantity__c != Null){
                         				weightValue = weightValue * orderItemObj.ccrz__Quantity__c;
                    				}
                                    weightValues = weightValues + weightValue;
                                    system.debug('weightValue ' + weightValue);
                                }
                            }
                        }
                    }
                    system.debug('weightValues ' + weightValues);
                    weight.value = String.valueOf(weightValues);
                    ShipStationRequestWrapper shipStationRequestWrapper = new ShipStationRequestWrapper();
                    if(orderObj.ccrz__CurrencyISOCode__c == 'USD'){
                        shipStationRequestWrapper.carrierCode = 'fedex';
                        shipStationRequestWrapper.serviceCode = 'fedex_ground';
                    }else if(orderObj.ccrz__CurrencyISOCode__c == 'CAD'){
                        shipStationRequestWrapper.carrierCode = 'canada_post';
                        shipStationRequestWrapper.serviceCode = 'regular_parcel';
                    }
                    shipStationRequestWrapper.packageCode = 'package';
                    shipStationRequestWrapper.confirmation = 'delivery';
                    String dateOfShip = string.valueof(orderObj.ccrz__OrderDate__c);
                    shipStationRequestWrapper.shipDate = String.valueof(system.today());
                    shipStationRequestWrapper.weight = weight;
                    shipStationRequestWrapper.shipFrom = shipForm;
                    shipStationRequestWrapper.shipTo = shipTo;
                    shipStationRequestWrapper.insuranceOptions = '';
                    shipStationRequestWrapper.internationalOptions = '';
                    shipStationRequestWrapper.advancedOptions = '';
                    shipStationRequestWrapper.testLabel = false;
                    system.debug('shipStationRequestWrapper ' + JSON.serialize(shipStationRequestWrapper));
                    
                    try{
                        if(AccessToken == null){
                            AccessToken = getAccessToken();
                        }
                        dbu_shipStationResponseWrapper shipStationResponseWrapper = new dbu_shipStationResponseWrapper();
                        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_Shipstation');
                        
                        ENP_POINT_URL = conDetails.End_Point__c;
                        METHOD_TYPE = conDetails.Method_Type__c;
                        Content_Type = conDetails.grant_type__c;
                        SHIPSTATION_CONSUMER_KEY = conDetails.Key__c;
                        SHIPSTATION_CONSUMER_SECRET = conDetails.Passcode__c;
                        
                        HttpRequest req = new HttpRequest();
                        req.setHeader('Content-Type', Content_Type);
                        req.setHeader('Authorization','Bearer '+ AccessToken);
                        req.setHeader('client_id', SHIPSTATION_CONSUMER_KEY);
                        req.setHeader('client_secret', SHIPSTATION_CONSUMER_SECRET);
                        req.setMethod(METHOD_TYPE);
                        req.setTimeout(60000);
                        req.setEndpoint(ENP_POINT_URL);
                        req.setBody(JSON.serialize(shipStationRequestWrapper));
                        Http http = new Http();
                        Long reqTime = DateTime.now().getTime();
                        HTTPResponse res = http.send(req);
                        Long respTime = DateTime.now().getTime();
                        system.debug('res ' + res.getBody());
                        long milliSeconds = respTime-reqTime ;
                        mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
                        if(res.getStatusCode() == 200){
                            shipStationResponseWrapper = (dbu_shipStationResponseWrapper)JSON.deserialize(res.getbody(), dbu_shipStationResponseWrapper.class);
                            if(shipStationResponseWrapper.labelData != null){
                                dbu_OrderItemShippingLabelEmailData itemData = new dbu_OrderItemShippingLabelEmailData();
                                
                                system.debug('labelData ' + shipStationResponseWrapper.labelData);
                                system.debug('labelData length' + shipStationResponseWrapper.labelData.length());
                                orderObj.dbu_Shipping_Label__c = shipStationResponseWrapper.labelData;
                                itemData.orderObject = orderObj;
                                itemData.template = emailInsWrapper.emailTemplate;
                                itemData.shippingInstructions = shippingIns;
                                itemData.owea = owea;
                                itemData.pdf_ShippingIns = emailInsWrapper.pdf_ShippingIns;
                                itemData.localData = localData;
                                shipLabelData.add(itemData);
                            }
                             dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec,JSON.serialize(shipStationRequestWrapper),res.getBody(),'Ship Station','Success');
                        }
                        else{
                             dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec+res.getBody(),JSON.serialize(shipStationRequestWrapper),'','Ship Station',res.getStatus());
                        }
                        system.debug('shipStationResponseWrapper ' + shipStationResponseWrapper);
                    }catch(CallOutException ce){
                        system.debug('error ' + ce.getMessage());
                        
                        dbu_Integration_Error_Log.createErrorLog(null,mSec+ce.getMessage(),JSON.serialize(shipStationRequestWrapper),'','Ship Station','Exception');
                    }      
                }
            } 
        }else if(isShippingLabel == false && isNotShippingLabel == true){
            for(ccrz__E_Order__c orderObj : orderList){
                if(!orderObj.ccrz__E_OrderItems__r.isEmpty()){
                    dbu_OrderItemShippingLabelEmailData itemData = new dbu_OrderItemShippingLabelEmailData();
                    orderObj.dbu_Shipping_Label__c = '';
                    itemData.orderObject = orderObj;
                    itemData.template = emailInsWrapper.emailTemplate;
                    itemData.shippingInstructions = shippingIns;
                    itemData.owea = owea;
                    itemData.pdf_ShippingIns = emailInsWrapper.pdf_ShippingIns;
                    itemData.localData = localData;
                    shipLabelData.add(itemData);
                }
            }
        }else if(coreReturnShipping){
            for(ccrz__E_Order__c orderObj : orderList){
                if(!orderObj.ccrz__E_OrderItems__r.isEmpty()){
                    dbu_OrderItemShippingLabelEmailData itemData = new dbu_OrderItemShippingLabelEmailData();
                    orderObj.dbu_Shipping_Label__c = '';
                    itemData.orderObject = orderObj;
                    itemData.template = emailInsWrapper.emailTemplate;
                    itemData.shippingInstructions = 'core';
                    itemData.owea = owea;
                    itemData.pdf_ShippingIns = emailInsWrapper.pdf_ShippingIns;
                    itemData.localData = localData;
                    shipLabelData.add(itemData);
                }
            }
        }else if(coreReturnDropOff){
            for(ccrz__E_Order__c orderObj : orderList){
                if(!orderObj.ccrz__E_OrderItems__r.isEmpty()){
                    dbu_OrderItemShippingLabelEmailData itemData = new dbu_OrderItemShippingLabelEmailData();
                    orderObj.dbu_Shipping_Label__c = '';
                    itemData.orderObject = orderObj;
                    itemData.template = emailInsWrapper.emailTemplate;
                    itemData.shippingInstructions = 'core';
                    itemData.owea = owea;
                    itemData.pdf_ShippingIns = emailInsWrapper.pdf_ShippingIns;
                    itemData.localData = localData;
                    shipLabelData.add(itemData);
                }
            }
        }
        else{
            for(ccrz__E_Order__c orderObj : orderList){
                if(!orderObj.ccrz__E_OrderItems__r.isEmpty()){
                    dbu_OrderItemShippingLabelEmailData itemData = new dbu_OrderItemShippingLabelEmailData();
                    orderObj.dbu_Shipping_Label__c = '';
                    itemData.orderObject = orderObj;
                    itemData.template = emailInsWrapper.emailTemplate;
                    itemData.shippingInstructions = shippingIns;
                    itemData.owea = owea;
                    itemData.pdf_ShippingIns = emailInsWrapper.pdf_ShippingIns;
                    itemData.localData = localData;
                    shipLabelData.add(itemData);
                }
            }
        }
        System.debug('shipLabelData in shipstation integration=>'+ JSON.serialize(shipLabelData));
        shipLabelData = toupdateContactInfoInWrapper(shipLabelData);
        dbu_ProcessShippingLabelEmail processEmail = new dbu_ProcessShippingLabelEmail(shipLabelData);
        ID jobID = System.enqueueJob(processEmail);
    }
    
    public static List<dbu_OrderItemShippingLabelEmailData> toupdateContactInfoInWrapper(List<dbu_OrderItemShippingLabelEmailData> inputData)
    {
        Set<Id> setOwnerId = new Set<Id>();
        Map<Id,User> userMap = new Map<Id,User>();
        for(dbu_OrderItemShippingLabelEmailData objCls : inputData)
        {
            if(objCls.orderObject.ccrz__Contact__c == null)
                setOwnerId.add(objCls.orderObject.OwnerId);
        }
        if(setOwnerId.size() > 0)
        {
            userMap.putAll([Select Id,ContactId from User where Id IN:  setOwnerId]);
        }
        for(dbu_OrderItemShippingLabelEmailData objCls : inputData)
        {
            if(objCls.orderObject.ccrz__Contact__c == null)
            {
                if(userMap.containsKey(objCls.orderObject.OwnerId) && userMap.get(objCls.orderObject.OwnerId).ContactId != null )
                {
                    objCls.contactId = userMap.get(objCls.orderObject.OwnerId).ContactId;
                }
            }
        }
        return inputData;
    }
    public static EmailInsWrapper getShippingInstruction(String localeData, Boolean isShippingLabel,Boolean isNotShippingLabel , Boolean shipTo, Boolean coreReturnShipping,Boolean coreReturnDropOff){
        EmailInsWrapper emailInsWrapper = new EmailInsWrapper();
        String pdf_ShippingIns;
        dbu_ShippingInstruction__mdt[] shippingInsRecords = [select dbu_dropOff_Instruction__c,dbu_dropOff_Instruction_FR__c,dbu_shipTo_Instruction__c,dbu_shippingInsNoForLabel_FR__c,dbu_shipTo_Instruction_FR__c,dbu_shippingInsNoForLabel__c from dbu_ShippingInstruction__mdt where DeveloperName ='dbu_ShippingInstruction'];
        dbu_ShippingInstruction__mdt[] coreInstructions = [select dbu_dropOff_Instruction__c,dbu_dropOff_Instruction_FR__c,dbu_shipTo_Instruction__c,dbu_shippingInsNoForLabel_FR__c,dbu_shipTo_Instruction_FR__c,dbu_shippingInsNoForLabel__c from dbu_ShippingInstruction__mdt where DeveloperName ='dbu_CoreInstruction'];
        if((isShippingLabel == true && shipTo == true) && (localeData == 'EN' || localeData == 'US')){
            emailInsWrapper.pdf_ShippingIns = shippingInsRecords[0].dbu_shipTo_Instruction__c;  
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_return_Documents_ShippingLabel'];
        }else if((isNotShippingLabel == true && shipTo == true) && (localeData == 'EN' || localeData == 'US')){
            emailInsWrapper.pdf_ShippingIns = shippingInsRecords[0].dbu_shippingInsNoForLabel__c;
            if(localeData == 'US'){
                emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_returnOrderDocNotLabel'];
            }else{
                 emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_returnOrderDocNotLabel_EN'];
            }
        }else if(localeData == 'FR' && (isShippingLabel == true && shipTo == true)){
            emailInsWrapper.pdf_ShippingIns = shippingInsRecords[0].dbu_shipTo_Instruction_FR__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_return_Documents_ShippingLabel_FR'];
        }else if(shipTo == false && (localeData == 'EN' || localeData == 'US') && coreReturnDropOff==False){
            emailInsWrapper.pdf_ShippingIns = shippingInsRecords[0].dbu_dropOff_Instruction__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents'];  
        }else if(shipTo == false && localeData == 'FR' && coreReturnDropOff==false){
            emailInsWrapper.pdf_ShippingIns = shippingInsRecords[0].dbu_dropOff_Instruction_FR__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu Return Documents FR'];  
        }else if(localeData == 'FR' && isShippingLabel == false && shipTo == true && isNotShippingLabel == true){
            emailInsWrapper.pdf_ShippingIns = shippingInsRecords[0].dbu_shippingInsNoForLabel_FR__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_returnOrderDocNotLabel_FR']; 
        }else if((localeData.equalsIgnoreCase('US') || localeData.equalsIgnoreCase('EN')) && coreReturnShipping==True){
            emailInsWrapper.pdf_ShippingIns = coreInstructions[0].dbu_shipTo_Instruction__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_CoreReturnShippingNotification'];
        }else if(localeData.equalsIgnoreCase('FR') && coreReturnShipping==True){
            emailInsWrapper.pdf_ShippingIns = coreInstructions[0].dbu_shipTo_Instruction_FR__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_CoreReturnShippingNotification_FR'];
        }else if((localeData.equalsIgnoreCase('US') || localeData.equalsIgnoreCase('EN')) && coreReturnDropOff==True){
            emailInsWrapper.pdf_ShippingIns = coreInstructions[0].dbu_dropOff_Instruction__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_CoreReturnDropOffNotification'];
        }else if(localeData.equalsIgnoreCase('FR') && coreReturnDropOff==True){
            emailInsWrapper.pdf_ShippingIns = coreInstructions[0].dbu_dropOff_Instruction_FR__c;
            emailInsWrapper.emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'dbu_CoreReturnDropOffNotification_FR'];
        }
        return emailInsWrapper;
    }
    
    public static String getAccessToken(){
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_ShipStation_AccessToken');
            ENP_POINT_URL = conDetails.End_Point__c;
            CONSUMER_KEY = conDetails.Key__c;
            CONSUMER_SECRET = conDetails.Passcode__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            CONTENT_TYPE = conDetails.grant_type__c;
            RESOURCE = conDetails.Resource__c;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);
            req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,
                RESOURCE}));
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            system.debug('res ' + res.getBody());
            TokenResponse resp = (TokenResponse)JSON.deserialize(res.getbody(), TokenResponse.class);
            system.debug('name and acce token '+ resp.token_type +' '+ resp.access_token);
            return resp.access_token;
        }catch(CallOutException ce){
            throw ce;
            //system.debug('Exeption in accessToken' + ce.getMessage());
        }       
    }   
    
    @future(callout = true)
    public static void reprocessShipStation(List<String> orderIds,List<String> orderItemsIds,String locCode){
        getShipStation(orderIds,orderItemsIds,locCode);
    }
    
    public class TokenResponse {       
        public String token_type;        
        public String expires_in;        
        public String ext_expires_in;   
        public String expires_on;
        public String not_before;
        public String resource;
        public String access_token;
    }   
    public class ShipStationRequestWrapper {
        public String carrierCode;
        public String serviceCode;
        public String packageCode;
        public String confirmation;
        public String shipDate;
        public Weight weight;
        public Dimensions dimensions;
        public ShipFrom shipFrom;
        public ShipTo shipTo;
        public String insuranceOptions;
        public String internationalOptions;
        public String advancedOptions;
        public Boolean testLabel;
    }
    public class ShipFrom {
        public String name;
        public String company;
        public String street1;
        public String street2;
        public String street3;
        public String city;
        public String state;
        public String postalCode;
        public String country;
        public String phone;
        public Boolean residential;
    }
    public class Dimensions {
        public String units;
        public String length;
        public String width;
        public String height;
    }
    public class ShipTo {
        public String name;
        public String company;
        public String street1;
        public String street2;
        public String street3;
        public String city;
        public String state;
        public String postalCode;
        public String country;
        public String phone;
        public Boolean residential;
    }
    public class Weight {
        public String value;
        public String units;
    }
    public class EmailInsWrapper{
        public String pdf_ShippingIns;
        public EmailTemplate emailTemplate;
    }
}