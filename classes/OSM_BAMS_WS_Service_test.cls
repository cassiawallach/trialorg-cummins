//Updated by Pooja 8/22/2022
//Updated on 04/12/2022
@isTest
global class OSM_BAMS_WS_Service_test{


public static testMethod void BAMStest12(){
        
    List<Id> productIdList = new List<Id>();
    String AccountId;
    Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
    Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
    List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        
    OSM_BAMS_WS_RefundResponse_Wrapper responsewrap = new OSM_BAMS_WS_RefundResponse_Wrapper(); 
    
    //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        
            // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        insert o1;
        MapOrdero.put(o1.id,o1);
        orderlIst.add(o1);
        System.debug('---CC Order---'+o1);
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        MapOrdern.put(o11.id,o11);
        
        //Put CC Order data Into Map
        Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
        cor.put(o11.id,o11); 
        set<id> ke=cor.keyset();
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o11.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o11.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o11.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o11.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o11.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;

        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'OSM-Bank';
        csInt.ApplicationName__c='BOA';
        csInt.End_Point__c='https://ics2wstesta.ic3.com/commerce/1.x/transactionProcessor';
        csInt.IsActive__c=true;
        csInt.AuthEnv__c='OSM-Bank';
        csInt.Method_Type__c='POST';
    csInt.Timeout__c=120000;
    csInt.Key__c = 'c2350ec4ef053da8a648ac2ecb473f69';
    csInt.Passcode__c = 'CBCBCAEC-04A4-49C9-8009-63830CD26A89';
        insert csint;
        
        /*CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'OSM-Bank';
        
        insert conDetails;  */
    
        OSM_BAMS_WS_GeneralizedInputWrapper genwrap = new OSM_BAMS_WS_GeneralizedInputWrapper();
        genwrap.merchantID = 'bams_cummins'; 
        genwrap.merchantReferenceCode = '14344';
        genwrap.PTcurrency = 'USD';
        genwrap.grandTotalAmount = 100;
        genwrap.subscriptionID = '5269207199376747304107';
        genwrap.orderId = '5269207';
        genwrap.order = o11;
        genwrap.transactionPayment = ctpayment;
        genwrap.invoice = invc;
    
    	
    
    	OSM_BAMS_WS_GeneralizedInputWrapper genwrap2 = new OSM_BAMS_WS_GeneralizedInputWrapper();
        genwrap.merchantID = 'bams_cummins2'; 
        genwrap.merchantReferenceCode = '14344';
        genwrap.PTcurrency = 'USD';
        genwrap.grandTotalAmount = 100;
        genwrap.subscriptionID = '5269207199376747304107';
        genwrap.orderId = '5269207'; 
        genwrap.order = o11;
        genwrap.transactionPayment = ctpayment;
        genwrap.invoice = invc;
        
        OSM_BAMS_WS_RefundResponse_Wrapper respWrap = new OSM_BAMS_WS_RefundResponse_Wrapper();
        respWrap.Status = 'Success';
        respWrap.refundStatusToBAMS = 'Success'; 
        respWrap.Request = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        respWrap.Response = 'Status: OK,Status Code: 200,Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header>       <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        respWrap.ReturnCodeDescription = '';
        respWrap.totalServiceCallTime = 3;
        respWrap.totalAuthCallTime = 5;
        respWrap.exceptionFlag = false;
        respWrap.errorMessage = '';
        
        
        
        
        OSM_WS_IP_CSWrapper ipwrap = new OSM_WS_IP_CSWrapper();
        ipwrap.jsonReqBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        ipwrap.serviceName = 'OSM-Bank';
        ipwrap.AuthEnv = 'OSM-Bank';
        ipwrap.AccesTokenRequired = false;
        
        
        
        //COMMENTED - By Pooja - 08/10/2022
        //String successresponse = 'Status: OK,Status Code: 200, Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        String successresponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
    
        string failresponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-467138702"><wsu:Created>2022-05-09T12:46:29.557Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1648738461943</c:merchantReferenceCode><c:requestID>6521003892646724904084</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTYYEbuppTiiSUABsQ0cuHDNm4YJ5mtA1GeBJ5o89NynpBGibBCjDJpJl6MV2lgcIUmv10ZVgPSVjSIAAASgdG</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-05-09T12:46:29Z</c:requestDateTime><c:amount>831.60</c:amount><c:reconciliationID>49883380</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>';
        
        test.starttest();
        OSM_WS_AccessTokenOPWrapper abc = new OSM_WS_AccessTokenOPWrapper(); 
        abc.exceptionFlag = true;
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(ipwrap);
        resAuthWrapper.exceptionFlag =true;
        //OSM_WS_OP_CSWrapper opwrap = new OSM_WS_OP_CSWrapper();
        //resAuthWrapper.exceptionFlag = true;
        OSM_BAMS_WS_Service.testNumber='Test2';
        OSM_BAMS_WS_Service.prepareBAMSCallForRefund(genwrap);
    	
    	OSM_BAMS_WS_Service.prepareBAMSCallForRefund(genwrap2);
        OSM_BAMS_OrderRefundNodes successRes1 = OSM_BAMS_WS_ServiceHelper.parseBAMSResponseForRefund(successresponse); 
        OSM_BAMS_OrderRefundNodes failRes1 = OSM_BAMS_WS_ServiceHelper.parseFailedBAMSResponseForRefund(failresponse);
    system.assert(successRes1.reasonCode=='100');
        test.stoptest();        
    }

    public static testMethod void BAMStest(){
        
    List<Id> productIdList = new List<Id>();
    String AccountId;
    Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
    Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
    List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        
    OSM_BAMS_WS_RefundResponse_Wrapper responsewrap = new OSM_BAMS_WS_RefundResponse_Wrapper(); 
    
    //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        
            // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        insert o1;
        MapOrdero.put(o1.id,o1);
        orderlIst.add(o1);
        System.debug('---CC Order---'+o1);
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        MapOrdern.put(o11.id,o11);
        
        //Put CC Order data Into Map
        Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
        cor.put(o11.id,o11); 
        set<id> ke=cor.keyset();
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o11.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o11.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o11.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o11.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o11.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;

        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'OSM-Bank';
        csInt.ApplicationName__c='BOA';
        csInt.End_Point__c='https://ics2wstesta.ic3.com/commerce/1.x/transactionProcessor';
        csInt.IsActive__c=true;
        csInt.AuthEnv__c='OSM-Bank';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.Key__c = 'c2350ec4ef053da8a648ac2ecb473f69';
        csInt.Passcode__c = 'CBCBCAEC-04A4-49C9-8009-63830CD26A89';
        insert csint;
        
        /*CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'OSM-Bank';
        insert conDetails;  */
    
        OSM_BAMS_WS_GeneralizedInputWrapper genwrap = new OSM_BAMS_WS_GeneralizedInputWrapper();
        genwrap.merchantID = 'bams_cummins'; 
        genwrap.merchantReferenceCode = '14344';
        genwrap.PTcurrency = 'USD';
        genwrap.grandTotalAmount = 100;
        genwrap.subscriptionID = '5269207199376747304107';
        genwrap.orderId = '5269207';
        genwrap.order = o11;
        genwrap.transactionPayment = ctpayment;
        genwrap.invoice = invc;
        
        OSM_BAMS_WS_RefundResponse_Wrapper respWrap = new OSM_BAMS_WS_RefundResponse_Wrapper();
        respWrap.Status = 'Success';
        respWrap.refundStatusToBAMS = 'Success'; 
        respWrap.Request = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        respWrap.Response = 'Status: OK,Status Code: 200,Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header>       <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        respWrap.ReturnCodeDescription = '';
        respWrap.totalServiceCallTime = 3;
        respWrap.totalAuthCallTime = 5;
        respWrap.exceptionFlag = false;
        respWrap.errorMessage = '';
        
        
        
        
        OSM_WS_IP_CSWrapper ipwrap = new OSM_WS_IP_CSWrapper();
        ipwrap.jsonReqBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        ipwrap.serviceName = 'OSM-Bank';
        ipwrap.AuthEnv = 'OSM-Bank';
        ipwrap.AccesTokenRequired = false;
        
        
        
        //COMMENTED - By Pooja - 08/10/2022
        //String successresponse = 'Status: OK,Status Code: 200, Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        String successresponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-450968792"><wsu:Created>2022-04-01T09:52:30.400Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1642526898746</c:merchantReferenceCode><c:requestID>6488067495186881004079</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTX7gGI54cd0IvABsQ0bMmTdixap5ikhJqoAp5mvQ5IhpBGi35BXDJpJl6MV2lgcGMmuKEOydYdXsUwAAAiA2F</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-04-01T09:52:30Z</c:requestDateTime><c:amount>833.91</c:amount><c:reconciliationID>46227115</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>';
        
        string failresponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-467138702"><wsu:Created>2022-05-09T12:46:29.557Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1648738461943</c:merchantReferenceCode><c:requestID>6521003892646724904084</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTYYEbuppTiiSUABsQ0cuHDNm4YJ5mtA1GeBJ5o89NynpBGibBCjDJpJl6MV2lgcIUmv10ZVgPSVjSIAAASgdG</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-05-09T12:46:29Z</c:requestDateTime><c:amount>831.60</c:amount><c:reconciliationID>49883380</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>';
        
        test.starttest();
        OSM_WS_AccessTokenOPWrapper abc = new OSM_WS_AccessTokenOPWrapper(); 
        abc.exceptionFlag = true;
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(ipwrap);
        resAuthWrapper.exceptionFlag =true;
        //OSM_WS_OP_CSWrapper opwrap = new OSM_WS_OP_CSWrapper();
        //resAuthWrapper.exceptionFlag = true;
        OSM_BAMS_WS_Service.testNumber='Test1';
        OSM_BAMS_WS_Service.prepareBAMSCallForRefund(genwrap);
        OSM_BAMS_OrderRefundNodes successRes2 = OSM_BAMS_WS_ServiceHelper.parseBAMSResponseForRefund(successresponse); 
        OSM_BAMS_OrderRefundNodes failRes2 = OSM_BAMS_WS_ServiceHelper.parseFailedBAMSResponseForRefund(failresponse);
        system.assert(successRes2.reasonCode=='100');
        test.stoptest();        
    }
    
    public static testMethod void BAMStest1(){
        
    List<Id> productIdList = new List<Id>();
    String AccountId;
    Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
    Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
    List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        
    OSM_BAMS_WS_RefundResponse_Wrapper responsewrap = new OSM_BAMS_WS_RefundResponse_Wrapper(); 
    
    //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        
            // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        insert o1;
        MapOrdero.put(o1.id,o1);
        orderlIst.add(o1);
        System.debug('---CC Order---'+o1);
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        MapOrdern.put(o11.id,o11);
        
        //Put CC Order data Into Map
        Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
        cor.put(o11.id,o11); 
        set<id> ke=cor.keyset();
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o11.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o11.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o11.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o11.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o11.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;

        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'OSM-Bank';
        csInt.ApplicationName__c='BOA';
        csInt.End_Point__c='https://ics2wstesta.ic3.com/commerce/1.x/transactionProcessor';
        csInt.IsActive__c=true;
        csInt.AuthEnv__c='OSM-Bank';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.Key__c = 'c2350ec4ef053da8a648ac2ecb473f69';
        csInt.Passcode__c = 'CBCBCAEC-04A4-49C9-8009-63830CD26A89';
        insert csint;
        
        /*CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'OSM-Bank';
        insert conDetails;  */
    
        OSM_BAMS_WS_GeneralizedInputWrapper genwrap = new OSM_BAMS_WS_GeneralizedInputWrapper();
        genwrap.merchantID = 'bams_cummins'; 
        genwrap.merchantReferenceCode = '14344';
        genwrap.PTcurrency = 'USD';
        genwrap.grandTotalAmount = 100;
        genwrap.subscriptionID = '5269207199376747304107';
        genwrap.orderId = '5269207';
        genwrap.order = o11;
        genwrap.transactionPayment = ctpayment;
        genwrap.invoice = invc;
        
        OSM_BAMS_WS_RefundResponse_Wrapper respWrap = new OSM_BAMS_WS_RefundResponse_Wrapper();
        respWrap.Status = 'error';
        respWrap.refundStatusToBAMS = 'FAILURE'; 
        respWrap.Request = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        respWrap.Response = 'Status: OK,Status Code: 200,Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header>       <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        respWrap.ReturnCodeDescription = '';
        respWrap.totalServiceCallTime = 3;
        respWrap.totalAuthCallTime = 5;
        respWrap.exceptionFlag = false;
        respWrap.errorMessage = '';
        
        
        
        
        OSM_WS_IP_CSWrapper ipwrap = new OSM_WS_IP_CSWrapper();
        ipwrap.jsonReqBody = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        ipwrap.serviceName = 'OSM-Bank';
        ipwrap.AuthEnv = 'OSM-Bank';
        ipwrap.AccesTokenRequired = false;
        
        
        
        //COMMENTED - By Pooja - 08/10/2022
        //String successresponse = 'Status: OK,Status Code: 200, Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        String successresponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
        
        string failresponse = '<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-467138702"><wsu:Created>2022-05-09T12:46:29.557Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1648738461943</c:merchantReferenceCode><c:requestID>6521003892646724904084</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTYYEbuppTiiSUABsQ0cuHDNm4YJ5mtA1GeBJ5o89NynpBGibBCjDJpJl6MV2lgcIUmv10ZVgPSVjSIAAASgdG</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-05-09T12:46:29Z</c:requestDateTime><c:amount>831.60</c:amount><c:reconciliationID>49883380</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>';
        
        test.starttest();
        OSM_WS_AccessTokenOPWrapper abc = new OSM_WS_AccessTokenOPWrapper(); 
        abc.exceptionFlag = true;
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductPass());
        OSM_WS_OP_CSWrapper resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(ipwrap);
        resAuthWrapper.exceptionFlag =true;
        //OSM_WS_OP_CSWrapper opwrap = new OSM_WS_OP_CSWrapper();
        //resAuthWrapper.exceptionFlag = true;
        OSM_BAMS_WS_Service.prepareBAMSCallForRefund(genwrap);
        OSM_BAMS_OrderRefundNodes successRes3 = OSM_BAMS_WS_ServiceHelper.parseBAMSResponseForRefund(successresponse); 
        OSM_BAMS_OrderRefundNodes failRe3 = OSM_BAMS_WS_ServiceHelper.parseFailedBAMSResponseForRefund(failresponse);
        system.assert(successRes3.authorizationCode == '888888');
        test.stoptest();        
    }
    
    
    public static testMethod void BAMStest2(){
        
    List<Id> productIdList = new List<Id>();
    String AccountId;
    Map<ID,ccrz__E_Order__c> MapOrdero= new Map<ID,ccrz__E_Order__c>();
    Map<ID,ccrz__E_Order__c> MapOrdern= new Map<ID,ccrz__E_Order__c>();
    List<ccrz__E_Order__c> orderlIst = new List<ccrz__E_Order__c>();
        
    OSM_BAMS_WS_RefundResponse_Wrapper responsewrap = new OSM_BAMS_WS_RefundResponse_Wrapper(); 
    
    //Account
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        
            // JUHI Changes - prevent hard coding of ID
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        
        //testAccount.RecordTypeId = '0124C000000Cimc';
        //testAccount.OwnerId = '0054C0000016Fe3';
        
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        insert testAccount;
        system.debug('testAccount'+testAccount);
            
        //CC Order
        ccrz__E_Order__c o1 = new ccrz__E_Order__c ();
        o1.ccrz__Storefront__c = 'SoftwareStore';
        o1.ccrz__Account__c = testAccount.Id;
        o1.ccrz__CurrencyISOCode__c = 'USD';
        insert o1;
        MapOrdero.put(o1.id,o1);
        orderlIst.add(o1);
        System.debug('---CC Order---'+o1);
        
        ccrz__E_Order__c o11 = new ccrz__E_Order__c (id = o1.id);
        o11.ccrz__OrderStatus__c = 'Order Submitted';
        o11.ccrz__OrderDate__c = system.today();
        update o11;
        MapOrdern.put(o11.id,o11);
        
        //Put CC Order data Into Map
        Map<Id,ccrz__E_Order__c> cor=new Map<Id,ccrz__E_Order__c>();
        cor.put(o11.id,o11); 
        set<id> ke=cor.keyset();
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        parentpro.Group_Name__c = 'DA';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        insert parentpro;
        productIdList.add(parentpro.id);
        System.debug('---CC Parent Product---'+parentpro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        productIdList.add(pro.id);
        System.debug('---CC Product---'+pro);
        
        //CC OrderItem
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = o11.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        insert oi1;
        System.debug('---CC OrderItem---'+oi1); 
        
        //CC Subscription
        ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
        Sub.ccrz__Sequence__c=3;
        Sub.ccrz__Storefront__c='SoftwareStore';
        Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
        Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
        Sub.ccrz__SubscriptionStatus__c= 'Active';
        Sub.ccrz__InstallmentLastDate__c=System.now();
        Sub.ccrz__CCOrder__c=o11.Id;
        Sub.ccrz__CCOrderItem__c=oi1.Id;
        Sub.OSM_Free_Trial__c=false;
        Sub.ccrz__SubscriptionProduct__c=pro.Id;
        Sub.ccrz__RecurringPrice__c = 200;
        Sub.ccrz__OrderLastDate__c = System.now() + 10;
        Sub.ccrz__CurrencyISOCode__c = 'USD';
        Sub.ccrz__Quantity__c = 3;
        Sub.ccrz__Account__c = testAccount.id;
        Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
        Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
        Insert Sub;
        System.debug('---CC Subscription---'+Sub);

        //Order Subscrciption Junction
        OSM_Order_Subscription__c osj = new OSM_Order_Subscription__c();
        osj.OSM_CCOrder__c = o11.id;
        osj.CC_Order_Item__c = oi1.id;
        //osj.CCProduct__c = pro.id;
        osj.CCQuantity__c = 1;
        osj.OSM_CCSubscription__c = Sub.id;
        osj.Billing_Frequency__c = 'Monthly';
        insert osj;
        
        //Invoice
        ccrz__E_Invoice__c invc = new ccrz__E_Invoice__c();
        invc.ccrz__CCOrder__c = o11.id;
        invc.ccrz__Status__c = 'Paid';
        invc.ccrz__Storefront__c = 'SoftwareStore';
        insert invc;
        
        //Transaction payment
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = o11.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = invc.id;
        insert ctpayment;

        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'OSM-Bank';
        csInt.ApplicationName__c='BOA';
        //csInt.End_Point__c='https://ics2wstesta.ic3.com/commerce/1.x/transactionProcessor';
        csInt.IsActive__c=true;
        csInt.AuthEnv__c='OSM-Bank';
        csInt.Method_Type__c='POST';
        csInt.Timeout__c=120000;
        csInt.Key__c = 'c2350ec4ef053da8a648ac2ecb473f69';
        csInt.Passcode__c = 'CBCBCAEC-04A4-49C9-8009-63830CD26A89';
        insert csint;
        
        /*CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting data
        conDetails.name = 'OSM-Bank';
        insert conDetails;  */
    
        OSM_BAMS_WS_GeneralizedInputWrapper genwrap = new OSM_BAMS_WS_GeneralizedInputWrapper();
        genwrap.merchantID = 'bams_cummins'; 
        genwrap.merchantReferenceCode = '14344';
        genwrap.PTcurrency = 'USD';
        genwrap.grandTotalAmount = 100;
        genwrap.subscriptionID = '5269207199376747304107';
        genwrap.orderId = '5269207';
        genwrap.order = o11;
        genwrap.transactionPayment = ctpayment;
        genwrap.invoice = invc;
        
        OSM_BAMS_WS_GeneralizedInputWrapper genwrap1 = new OSM_BAMS_WS_GeneralizedInputWrapper();
        genwrap.merchantID = 'bams_cummins1'; 
        genwrap.merchantReferenceCode = '14344';
        genwrap.PTcurrency = 'USD';
        genwrap.grandTotalAmount = 100;
        genwrap.subscriptionID = '5269207199376747304107'; 
        genwrap.orderId = '5269207';
        genwrap.order = o11;
        genwrap.transactionPayment = ctpayment;
        genwrap.invoice = invc;
        
        OSM_BAMS_WS_RefundResponse_Wrapper respWrap = new OSM_BAMS_WS_RefundResponse_Wrapper();
        respWrap.Status = 'Failure';
        respWrap.refundStatusToBAMS = 'Failure'; 
        respWrap.Request = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>CybsEt219</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">/jWDMoZeoKzFMbrRPUURUb6sK+v0OlQYz0mC5yOFf6K0R0ot5pHPsdCBBYr017aRCuA6AIAuHNtb5bABeXAmvRp8py6WfIWFggPW+FyGN7UMeEDx9IfUvuUHvhlEhxeW7dT5H3tVBKnzxIEonfXvv5sUOK/jhEDiimxQ+osuRPMc4zcR7YqJ+pZOpEMYFKXyWvleEJhIfWg5Wo4aXmHAikjYP1eX2dR6YcB2rNuaf6E3rwPZAbUQlhTGKwgGMlZIQ1zlu5FG7NtjtqCU/gs2haq+dlQSax3geE0pslqkhSuxACBVlsE3JkZ0GHEEvzAFUyNFsWSTOPazQ8XTlOCzhA==</wsse:Password></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-1.92"><merchantID>bams_cummins</merchantID><merchantReferenceCode>null</merchantReferenceCode><purchaseTotals><currency>USD</currency><grandTotalAmount>39.78</grandTotalAmount></purchaseTotals><recurringSubscriptionInfo><subscriptionID>5353825601416867704107</subscriptionID></recurringSubscriptionInfo><ccAuthService run="true"/><ccCaptureService run="true"/></requestMessage></soapenv:Body></soapenv:Envelope>';
        respWrap.Response = 'Status: Internal Server Error,Status Code: 500,Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-1161959898"><wsu:Created>2018-08-28T00:23:50.932Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><soap:Fault xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:c="urn:schemas-cybersource-com:transaction-data-1.0"><faultcode>wsse:FailedCheck</faultcode><faultstring>Security Data : UsernameToken authentication failed.</faultstring></soap:Fault></soap:Body></soap:Envelope>';
        respWrap.ReturnCodeDescription = 'null===Exception:Attempt to de-reference a null object';
        respWrap.totalServiceCallTime = 3;
        respWrap.totalAuthCallTime = 5;
        respWrap.exceptionFlag = true;
        respWrap.errorMessage = 'null===Exception:Attempt to de-reference a null object';
        
        OSM_WS_IP_CSWrapper ipwrap = new OSM_WS_IP_CSWrapper();
        ipwrap.jsonReqBody = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:UsernameToken><wsse:Username>CybsEt219</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">/jWDMoZeoKzFMbrRPUURUb6sK+v0OlQYz0mC5yOFf6K0R0ot5pHPsdCBBYr017aRCuA6AIAuHNtb5bABeXAmvRp8py6WfIWFggPW+FyGN7UMeEDx9IfUvuUHvhlEhxeW7dT5H3tVBKnzxIEonfXvv5sUOK/jhEDiimxQ+osuRPMc4zcR7YqJ+pZOpEMYFKXyWvleEJhIfWg5Wo4aXmHAikjYP1eX2dR6YcB2rNuaf6E3rwPZAbUQlhTGKwgGMlZIQ1zlu5FG7NtjtqCU/gs2haq+dlQSax3geE0pslqkhSuxACBVlsE3JkZ0GHEEvzAFUyNFsWSTOPazQ8XTlOCzhA==</wsse:Password></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><requestMessage xmlns="urn:schemas-cybersource-com:transaction-data-1.92"><merchantID>bams_cummins</merchantID><merchantReferenceCode>null</merchantReferenceCode><purchaseTotals><currency>USD</currency><grandTotalAmount>39.78</grandTotalAmount></purchaseTotals><recurringSubscriptionInfo><subscriptionID>5353825601416867704107</subscriptionID></recurringSubscriptionInfo><ccAuthService run="true"/><ccCaptureService run="true"/></requestMessage></soapenv:Body></soapenv:Envelope>';
        ipwrap.serviceName = 'OSM-Bank';
        ipwrap.AuthEnv = 'OSM-Bank';
        ipwrap.AccesTokenRequired = false;
        
        Test.setMock(HttpCalloutMock.class, new SingleRequestMockProductFail());
        OSM_BAMS_WS_Service.prepareBAMSCallForRefund(genwrap); 
        OSM_BAMS_WS_RefundResponse_Wrapper wrapper = OSM_BAMS_WS_Service.prepareBAMSCallForRefund(genwrap1);
        system.assert(wrapper.Status == 'Failure');
    }
    
    global class SingleRequestMockProductPass implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(200);
                resp.setBody('Status: OK,Status Code: 200,Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header>      <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-672313621"><wsu:Created>2018-06-11T09:06:16.816Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287079765836169803009</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHpz4muD8WPUBESDdyxYuWrJlIksnM2jRqKNPmmAnkA1GnzTATyaQJ+j/FDJpJl6MVz3XYYM5MenPia4PxY9QEAAA9g6t</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T09:06:16Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>79119522HI29MQQT</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T09:06:16Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>79119522HI29MQQT</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>');
                return resp;
            }
    }   
    
    global class SingleRequestMockProductFail implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setBody('Status: Internal Server Error,Status Code: 500,Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-1161959898"><wsu:Created>2018-08-28T00:23:50.932Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><soap:Fault xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:c="urn:schemas-cybersource-com:transaction-data-1.0"><faultcode>wsse:FailedCheck</faultcode><faultstring>Security Data : UsernameToken authentication failed.</faultstring></soap:Fault></soap:Body></soap:Envelope>');
                return resp;
            }
    }
    
    //ADDED - By Pooja - 08/10/2022
    @IsTest
    static void OSM_WS_OP_CSWrapper_Test() {
        OSM_WS_OP_CSWrapper wrapper = new OSM_WS_OP_CSWrapper();
        wrapper.Request = 'Test';
        wrapper.Response = 'Test';
        wrapper.responseBody = 'Test';
        wrapper.totalAuthCallTime = 1;
        wrapper.totalServiceCallTime = 1;
        wrapper.errorMessage = 'Test';
        wrapper.APIURL = 'Test';
        wrapper.requestTime = '1';
        wrapper.responseTime = '1';
    }
}