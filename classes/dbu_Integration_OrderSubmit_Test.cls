/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-22-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class dbu_Integration_OrderSubmit_Test {
    
    static testMethod void testGetOrderStatus(){
        // dbu_Integration_OrderSubmit warpOrderObj = new dbu_Integration_OrderSubmit();
        //added for prod - comment4coverage
        List<dbu_Integration_OrderSubmit.ShipToCustomer> shipToCustList = new List<dbu_Integration_OrderSubmit.ShipToCustomer>();
        dbu_Integration_OrderSubmit.ShipToCustomer shipToCustObj = new dbu_Integration_OrderSubmit.ShipToCustomer();
        shipToCustObj.address1 = '4420 Fairfax';
        shipToCustObj.address2 = 'Dr #500';  
        shipToCustObj.address3 = ' #500';
        shipToCustObj.city = 'Arlington';
        shipToCustObj.state = 'Virginia';
        shipToCustObj.country = 'United State of America';
        shipToCustObj.postalCode = '22203';
        shipToCustObj.partyName = 'Testing';
        shipToCustList.add(shipToCustObj);//Replace removed dbu_special_characters 
        
        List<dbu_Integration_OrderSubmit.ShipToDistributor> shipToDistList = new List<dbu_Integration_OrderSubmit.ShipToDistributor>();
        dbu_Integration_OrderSubmit.ShipToDistributor shipToDistObj = new dbu_Integration_OrderSubmit.ShipToDistributor();
        shipToDistObj.address1 = '4420 Fairfax';
        shipToDistObj.address2 = 'Dr #500';
        shipToDistObj.address3 = ' #500';
        shipToDistObj.city = 'Arlington';
        shipToDistObj.state = 'Virginia';
        shipToDistObj.country = 'United State of America';
        shipToDistObj.postalCode = '22203';
        shipToDistObj.partyName = 'Testing';
        shipToDistList.add(shipToDistObj);
        
        List< dbu_Integration_OrderSubmit.BillToCustomer> billToList = new  List< dbu_Integration_OrderSubmit.BillToCustomer>();
        dbu_Integration_OrderSubmit.BillToCustomer billToObj = new dbu_Integration_OrderSubmit.BillToCustomer();
        billToObj.address1 = '4420 Fairfax';
        billToObj.address2 = 'Dr #500';
        billToObj.address3 = ' #500';
        billToObj.city = 'Arlington';
        billToObj.state = 'Virginia';
        billToObj.country = 'United State of America';
        billToObj.postalCode = '22203';
        billToObj.partyName = 'Testing';
        billToObj.contactNumber = '9909999999';
        billToList.add(billToObj);
        
        List<dbu_Integration_OrderSubmit.BuyingPartyAddress> buyPartyAddressList = new List<dbu_Integration_OrderSubmit.BuyingPartyAddress>();
        dbu_Integration_OrderSubmit.BuyingPartyAddress buyPartyAddressObj = new dbu_Integration_OrderSubmit.BuyingPartyAddress();
        buyPartyAddressObj.address1 = '4420 Fairfax';
        buyPartyAddressObj.address2 = 'Dr #500';
        buyPartyAddressObj.address3 = ' #500';
        buyPartyAddressObj.city = 'Arlington';
        buyPartyAddressObj.state = 'Virginia';
        buyPartyAddressObj.country = 'United State of America';
        buyPartyAddressObj.postalCode = '22203';
        buyPartyAddressList.add(buyPartyAddressObj);
        
        List<dbu_Integration_OrderSubmit.Lines> linesList = new List<dbu_Integration_OrderSubmit.Lines>();
        dbu_Integration_OrderSubmit.Lines linesObj = new dbu_Integration_OrderSubmit.Lines();
        linesObj.lineId = '123456';
        linesObj.orderedQuantity = 2;
        linesObj.orderReturnFlag = 'Yes';
        linesObj.productCode = '1234';
        linesObj.shippingMode = 'ship To';
        linesObj.partNumber = '1234567';
        linesObj.unitSellingPrice = 100.00;
        linesObj.deliveryMethod = 'shipTo';
        linesObj.unitDiscount = 2.00;
        linesObj.couponDiscount = 0.00;
        linesObj.shippingCharges = 10.00;
        linesObj.taxAmount = 10.00;
        linesObj.taxClassificationCode = 'Test123';
        linesObj.fulfillmentLocationCode = 'Test123';
        linesObj.shipToDistributor = shipToDistList;
        linesObj.shipToCustomer = shipToCustList;
        linesList.add(linesObj);
        
        dbu_Integration_OrderSubmit.OrderSubmitRequestData orderReqObj = new dbu_Integration_OrderSubmit.OrderSubmitRequestData();
        orderReqObj.buyingPartyName = 'Mukesh Gupta';
        orderReqObj.buyingPartyNumber = '1234567';
        orderReqObj.buyingPartyEmailID = 'test@test.com';
        orderReqObj.BuyingPartyAddress = buyPartyAddressList;
        orderReqObj.distributorCode = '12345678';
        orderReqObj.destinationTransactionSystem = 'BMS System';
        orderReqObj.orderNumber = '123456789';
        orderReqObj.sourceTransactionSystem = 'Salesforce';
        orderReqObj.status = 'Order Submitted';
        orderReqObj.submittedDate = '01/01/2020';
        orderReqObj.shippingMode = 'ShipTo';
        orderReqObj.paymentType = 'Card';
        orderReqObj.totalOrderAmount = 200.00;
        orderReqObj.totalTaxAmount = 20.00;
        orderReqObj.billToCustomer = billToList;
        orderReqObj.lines = linesList;
        System.debug('=Json Req==='+orderReqObj);
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c =  'https://test.com/';
        conDetails.Key__c = 'test123459895';
        conDetails.Passcode__c =  'test@123';
        conDetails.Method_Type__c = 'POST';
        conDetails.Name = 'dbu_Order_AccessToken';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c =  'https://test.com/';
        conDetails1.Method_Type__c = 'POST';
        conDetails1.grant_type__c = 'application/json';
        conDetails1.Key__c = 'test1234';
        conDetails1.Passcode__c =  'test@12398';
        conDetails1.Name = 'dbu_Order_StatusUpdate';
        insert conDetails1;
        dbu_IntegrationErrorLog__c errorLog = new dbu_IntegrationErrorLog__c();
        errorLog.Name='ErrorLogEmail';
        errorLog.SetToAddress__c='test2093@cumminstes.com';
        errorLog.TargetObjectId__c=Userinfo.getUserId();
        insert errorLog;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dbu_MockHttpResponseGenerator());
        dbu_Integration_OrderSubmit.getOrderStatus(orderReqObj);//added settimeout
        Test.stopTest();
        
    }
}
//UAT Deployment