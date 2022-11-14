//Updated test class by Sangeeta on 21-02-2022 for MP-652 for major
@IsTest(SeeAllData=true)
public class OSM_SW_CyberSourcePmtForInvoiceCtrl_Test{
       static testMethod void getCybersourceHostedFormData_Test(){
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
       
               
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.runAs(transecRes.objSetupDate.loggedInUser){  
        ccrz__E_ContactAddr__c objAddress=addressDetails();
       /* objAddress.ccrz__AddressFirstLine__c='1460 N National Rd';
        objAddress.ccrz__AddressSecondline__c='';
        objAddress.ccrz__City__c='Columbus';
        objAddress.ccrz__CompanyName__c='HCL';
        objAddress.ccrz__Country__c='United States';
        objAddress.ccrz__CountryISOCode__c='US';
        objAddress.ccrz__FirstName__c='Sharad';
        objAddress.ccrz__Email__c='test@gamil.com';
        objAddress.ccrz__LastName__c='Sahu';
        objAddress.ccrz__PostalCode__c='47201';
        objAddress.ccrz__StateISOCode__c='IN';
        objAddress.ccrz__State__c='Indiana';
        insert objAddress;*/
                      
        transecRes.invoice.ccrz__BillAddress__c=objAddress.id;
        
        System.debug('transecRes: '+transecRes);

        //For   remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        
       //String successResponse ='Status: OK,Status Code: 200, Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
       String successResponse='{"reason_code":"100","decision":"ACCEPT","accountBalance":"70","ownerMerchantID":"bams_cummins","auth_avs_code":"X","payment_token":"","auth_code":"888888","req_card_type":"001","req_card_expiry_date":"03/2019","req_amount":"334","auth_trans_ref_no":"test"}';
       Test.setCurrentPageReference(new PageReference('Page.OSM_SW_CybersourcePostBack')); 
       System.currentPageReference().getParameters().put('Test', 'Test');
       OSM_SW_CyberSourcePaymentPostBack postBack =new OSM_SW_CyberSourcePaymentPostBack();
       OSM_SW_CyberSourcePayment payment=new OSM_SW_CyberSourcePayment();
       //Map<String, Object> parametersFromBAMS=new  Map<String, Object>();
       Test.StartTest();
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.getCybersourceHostedFormData(objRemotCtx);
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.buildCybersourceHostedFormData(objRemotCtx.storefront,transecRes.Invoice.id);
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.processCybersourceResponse(objRemotCtx,successResponse); 
            OSM_SW_CyberSourcePayment.getCybersourceHostedFormData(objRemotCtx);
           // OSM_SW_CyberSourcePayment.buildCybersourceHostedFormData(objRemotCtx.storefront,objRemotCtx.currentCartId);
            OSM_SW_CyberSourcePayment.processCybersourceResponse(objRemotCtx,successResponse);
            //OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
           Map<String, Object> parametersFromBAMS = new Map<String, Object>();
            
            parametersFromBAMS.put('signed_field_names','abc:abc,xyz:xyz');
            try{
            OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            try{
            parametersFromBAMS.put('signed_field_names',null);
            OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            
            
        Test.StopTest();
        }
        }
    static testMethod void cardDeclineTest(){
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
       
               
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.runAs(transecRes.objSetupDate.loggedInUser){  
        ccrz__E_ContactAddr__c objAddress=addressDetails();
       /* objAddress.ccrz__AddressFirstLine__c='1460 N National Rd';
        objAddress.ccrz__AddressSecondline__c='';
        objAddress.ccrz__City__c='Columbus';
        objAddress.ccrz__CompanyName__c='HCL';
        objAddress.ccrz__Country__c='United States';
        objAddress.ccrz__CountryISOCode__c='US';
        objAddress.ccrz__FirstName__c='Sharad';
        objAddress.ccrz__Email__c='test@gamil.com';
        objAddress.ccrz__LastName__c='Sahu';
        objAddress.ccrz__PostalCode__c='47201';
        objAddress.ccrz__StateISOCode__c='IN';
        objAddress.ccrz__State__c='Indiana';
        insert objAddress;*/
                      
        transecRes.invoice.ccrz__BillAddress__c=objAddress.id;
        
        System.debug('transecRes: '+transecRes);

        //For   remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        
       //String successResponse ='Status: OK,Status Code: 200, Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
       String successResponse='{"reason_code":"203","decision":"DECLINED","accountBalance":"70","ownerMerchantID":"bams_cummins","auth_avs_code":"X","payment_token":"","auth_code":"888888","req_card_type":"001","req_card_expiry_date":"03/2019","req_amount":"334","auth_trans_ref_no":"test"}';
       Test.setCurrentPageReference(new PageReference('Page.OSM_SW_CybersourcePostBack')); 
       System.currentPageReference().getParameters().put('Test', 'Test');
       OSM_SW_CyberSourcePaymentPostBack postBack =new OSM_SW_CyberSourcePaymentPostBack();
       OSM_SW_CyberSourcePayment payment=new OSM_SW_CyberSourcePayment();
       //Map<String, Object> parametersFromBAMS=new  Map<String, Object>();
       Test.StartTest();
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.getCybersourceHostedFormData(objRemotCtx);
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.buildCybersourceHostedFormData(objRemotCtx.storefront,transecRes.Invoice.id);
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.processCybersourceResponse(objRemotCtx,successResponse); 
            OSM_SW_CyberSourcePayment.getCybersourceHostedFormData(objRemotCtx);
           // OSM_SW_CyberSourcePayment.buildCybersourceHostedFormData(objRemotCtx.storefront,objRemotCtx.currentCartId);
            OSM_SW_CyberSourcePayment.processCybersourceResponse(objRemotCtx,successResponse);
            //OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
           Map<String, Object> parametersFromBAMS = new Map<String, Object>();
            
            parametersFromBAMS.put('signed_field_names','abc:abc,xyz:xyz');
            try{
            OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            try{
            parametersFromBAMS.put('signed_field_names',null);
            OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            
            
        Test.StopTest();
        }
        }
     static testMethod void invalidVerificationNumberTest(){
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
       
               
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.runAs(transecRes.objSetupDate.loggedInUser){  
        ccrz__E_ContactAddr__c objAddress=addressDetails();
       /* objAddress.ccrz__AddressFirstLine__c='1460 N National Rd';
        objAddress.ccrz__AddressSecondline__c='';
        objAddress.ccrz__City__c='Columbus';
        objAddress.ccrz__CompanyName__c='HCL';
        objAddress.ccrz__Country__c='United States';
        objAddress.ccrz__CountryISOCode__c='US';
        objAddress.ccrz__FirstName__c='Sharad';
        objAddress.ccrz__Email__c='test@gamil.com';
        objAddress.ccrz__LastName__c='Sahu';
        objAddress.ccrz__PostalCode__c='47201';
        objAddress.ccrz__StateISOCode__c='IN';
        objAddress.ccrz__State__c='Indiana';
        insert objAddress;*/
                      
        transecRes.invoice.ccrz__BillAddress__c=objAddress.id;
        
        System.debug('transecRes: '+transecRes);

        //For   remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        
        
       //String successResponse ='Status: OK,Status Code: 200, Response Body: <?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-761668669"><wsu:Created>2018-06-11T11:43:53.055Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>14344</c:merchantReferenceCode><c:requestID>5287174328516960703010</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Ahj//wSTHp5IjyLR5dIiESDdyxZsGTdoxksnM2rBcqNPmmI1YA1GnzTEasaQJ+j/FDJpJl6MVz3XYYM5MenkiPItHl0iIAAA9goY</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccAuthReply><c:reasonCode>100</c:reasonCode><c:amount>5.00</c:amount><c:authorizationCode>888888</c:authorizationCode><c:avsCode>X</c:avsCode><c:avsCodeRaw>I1</c:avsCodeRaw><c:authorizedDateTime>2018-06-11T11:43:52Z</c:authorizedDateTime><c:processorResponse>100</c:processorResponse><c:reconciliationID>791302741I29MUA9</c:reconciliationID><c:accountBalance>70.00</c:accountBalance><c:ownerMerchantID>bams_cummins</c:ownerMerchantID></c:ccAuthReply><c:ccCaptureReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2018-06-11T11:43:53Z</c:requestDateTime><c:amount>5.00</c:amount><c:reconciliationID>791302741I29MUA9</c:reconciliationID></c:ccCaptureReply></c:replyMessage></soap:Body></soap:Envelope>';
       String successResponse='{"reason_code":"211","decision":"DECLINED","accountBalance":"70","ownerMerchantID":"bams_cummins","auth_avs_code":"X","payment_token":"","auth_code":"888888","req_card_type":"001","req_card_expiry_date":"03/2019","req_amount":"334","auth_trans_ref_no":"test"}';
       Test.setCurrentPageReference(new PageReference('Page.OSM_SW_CybersourcePostBack')); 
       System.currentPageReference().getParameters().put('Test', 'Test');
       OSM_SW_CyberSourcePaymentPostBack postBack =new OSM_SW_CyberSourcePaymentPostBack();
       OSM_SW_CyberSourcePayment payment=new OSM_SW_CyberSourcePayment();
       //Map<String, Object> parametersFromBAMS=new  Map<String, Object>();
       Test.StartTest();
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.getCybersourceHostedFormData(objRemotCtx);
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.buildCybersourceHostedFormData(objRemotCtx.storefront,transecRes.Invoice.id);
            OSM_SW_CyberSourcePaymentForInvoiceCtrl.processCybersourceResponse(objRemotCtx,successResponse); 
            OSM_SW_CyberSourcePayment.getCybersourceHostedFormData(objRemotCtx);
           // OSM_SW_CyberSourcePayment.buildCybersourceHostedFormData(objRemotCtx.storefront,objRemotCtx.currentCartId);
            OSM_SW_CyberSourcePayment.processCybersourceResponse(objRemotCtx,successResponse);
            //OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
           Map<String, Object> parametersFromBAMS = new Map<String, Object>();
            
            parametersFromBAMS.put('signed_field_names','abc:abc,xyz:xyz');
            try{
            OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            try{
            parametersFromBAMS.put('signed_field_names',null);
            OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parametersFromBAMS);
            }catch(exception ex){}
            
            
        Test.StopTest();
        }
        }
        //static ccrz__E_ContactAddr__c addressDetails(){
        public static ccrz__E_ContactAddr__c addressDetails(){
        ccrz__E_ContactAddr__c objAddress=new ccrz__E_ContactAddr__c();
        objAddress.ccrz__AddressFirstLine__c='1460 N National Rd';
        objAddress.ccrz__AddressSecondline__c='';
        objAddress.ccrz__City__c='Columbus';
        objAddress.ccrz__CompanyName__c='HCL';
        objAddress.ccrz__Country__c='United States';
        objAddress.ccrz__CountryISOCode__c='US';
        objAddress.ccrz__FirstName__c='Sharad';
        objAddress.ccrz__Email__c='test@gamil.com';
        objAddress.ccrz__LastName__c='Sahu';
        objAddress.ccrz__PostalCode__c='47201';
        objAddress.ccrz__StateISOCode__c='IN';
        objAddress.ccrz__State__c='Indiana';
        insert objAddress;
        return objAddress;
        }
}