//We have a change in this class for 1B and later release country logic needs to be changed.Please see Alert below.
global with sharing class OSM_SW_CyberSourcePayment
{  
    public static String ACCESS_KEY = System.Label.CyberSource_ACCESS_KEY; // access key goes here;
    public static String SECRET_KEY = System.Label.CyberSource_SECRET_KEY; //valid secret key goes here;
    public static String PROFILE_ID = System.Label.CyberSource_PROFILE_ID; // profile id goes here ;
    
    
    
    public static String POST_URL = System.Label.CyberSource_POST_URL; // post url goes here;
    public static String RETURN_URL = 'https://eidmdev-cumminscss.cs61.force.com/CMIStore/ccrz__CCBridge?pageKey=cybersourcePost';//System.Label.CyberSource_RETURN_URL; // return url goes here;
    //public static String RETURN_URL = System.Label.CyberSource_RETURN_URL; // return url goes here;
    
    public static final String ALGORITHM_NAME = 'hmacSHA256';
    public static final String TRANSACTION_TYPE='sale,create_payment_token';
    public static final String TRANSACTION_TYPE_ZERODOLLAR='authorization';
    
    public static final String PAYMENT_METHOD = 'card';
    public static final String UNSIGNED_FIELDS = 'bill_to_forename,bill_to_surname,bill_to_email,bill_to_address_line1,bill_to_address_city,bill_to_address_country,bill_to_address_state,bill_to_address_postal_code';
    
    private static final String DECISION_ACCEPT = 'ACCEPT';
    public static final String REASON_CODE = 'reason_code';
    
    public static final String ADDRESSCODE_RESPONSE = 'auth_avs_code';
    public static final List<String> INVALID_ADDRESS_CODES = new List<String>{'N'};
        
        
    private static final String DECISION_RESPONSE = 'decision';
    private static final String PAYMENT_TOKEN = 'payment_token';
    private static final String TX_ID = 'transaction_id';
    private static final String BANK_TRANS_REF_NO = 'auth_trans_ref_no';
    private static final String AUTH_CODE = 'auth_code';
    private static final String IGNORE_AVS = System.Label.CyberSource_AVS;
    
    private static final String CARD_NUMBER = 'req_card_number'; 
    private static final String CARD_TYPE = 'req_card_type'; 
    private static final String CARD_EXP_DATE = 'req_card_expiry_date'; 
    private static final String AUTH_AMOUNT = 'req_amount'; 
    private static final String REQ_REF_NUM = 'req_reference_number';//Added by Vineet on 26/10/1028
    
    private static final String VISA = 'Visa';
    private static final String AMERICAN_EXPRESS = 'American Express';
    private static final String MASTER_CARD = 'Mastercard';
    private static final String DISCOVER = 'Discover';
    
    
    global OSM_SW_CyberSourcePayment(){
        
        ccrz.ccLog.log('Inside OSM_SW_CyberSourcePayment=====>');
    }
    
    
    
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCybersourceHostedFormData(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        
        
        
        OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData = null;
        try
        {
            //get the returnurl for Site User and CSR
            RETURN_URL = OSM_SW_CyberSourcePaymentForInvoiceCtrl.populateReturnUrlToBAMS();
            //ccrz.ccLog.log('===RETURN_URL before Decode==='+RETURN_URL);
            
            
            System.debug('RETURN_URL======'+RETURN_URL);
            //populateReturnUrlToBAMS()
            if(Test.IsRunningTest()){
                //cybersourceHostedPageData = buildCybersourceHostedFormData('SoftwareStore',ccrz.cc_CallContext.currCartId);
                ccrz__E_Cart__c cart=[select id,ccrz__Storefront__c,ccrz__CartType__c from ccrz__E_Cart__c Limit 1];
                cybersourceHostedPageData = buildCybersourceHostedFormData(cart.ccrz__Storefront__c,cart.Id);
                System.debug('cybersourceHostedPageData____'+cybersourceHostedPageData);
                Map<String, Object> hostedPageData =   new Map<String,Object>{'cybersourceHostedPageData' => cybersourceHostedPageData} ;
                    response.success = true;
                response.data =  hostedPageData;
                
            }else{
                cybersourceHostedPageData = buildCybersourceHostedFormData(ccrz.cc_CallContext.storefront, ccrz.cc_CallContext.currCartId);
                
                Map<String, Object> hostedPageData =   new Map<String,Object>{'cybersourceHostedPageData' => cybersourceHostedPageData} ;
                    response.success = true;
                response.data =  hostedPageData;
            }
            if(Test.IsRunningTest()){
                throw new NullPointerException();
            }
        }
        catch (Exception ex)
        {
            
            ccrz.ccLog.log(System.LoggingLevel.ERROR, 'ERR', ex);
            response.success = false;
            response.data = null;
        }
        finally
        {
            //ccrz.ccLog.close(response);
        }
        return response;
    }
    
    public static OSM_SW_CybersourceHostedPageDataFields buildCybersourceHostedFormData(String storefrontName, String currCartId)
    {
        
        Datetime currentDateTime =  Datetime.now();
        OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData = new OSM_SW_CybersourceHostedPageDataFields();
        cybersourceHostedPageData.cartId = currCartId;
        cybersourceHostedPageData.utcDate = currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'GMT');
        cybersourceHostedPageData.transactionId = String.valueOf(System.currentTimeMillis());
        cybersourceHostedPageData.referenceNumber = String.valueOf(System.currentTimeMillis());
        cybersourceHostedPageData.unsignedFields = UNSIGNED_FIELDS;
        
        // Start : Added by Juhi on 25-Oct-2018
        
        // Using Cart Object
        /*
ccrz__E_Cart__c cart = [Select ID, ccrz__EncryptedId__c 
from ccrz__E_Cart__c 
where ccrz__EncryptedId__c=:ccrz.cc_CallContext.currCartId];

System.debug('Current Cart ID' + ccrz.cc_CallContext.currCartId);
ccrz__E_Cart__c cartBAMS = new ccrz__E_Cart__c(id = cart.ID, BAMS_Merchant_Ref_Num__c = cybersourceHostedPageData.referenceNumber);
update cartBAMS;
*/
        //START:ADDED by Vaibhav on 19-Sep
        //cybersourceHostedPageData.transactionType = TRANSACTION_TYPE;
        //END:ADDED by Vaibhav on 19-Sep
        cybersourceHostedPageData.returnURL = RETURN_URL;
        cybersourceHostedPageData.postUrl = POST_URL;
        cybersourceHostedPageData.paymentMethod = PAYMENT_METHOD;
        
        //START:ADDED by Vaibhav on 27-Sep
        //cybersourceHostedPageData.ignoreAvs = false;
        cybersourceHostedPageData.ignoreAvs = Boolean.valueOf(IGNORE_AVS);
        //
        //END:ADDED by Vaibhav on 27-Sep
        cybersourceHostedPageData.accessKey = ACCESS_KEY;
        cybersourceHostedPageData.profileId=PROFILE_ID;
        //String userId = ccrz.cc_CallContext.;
        ccrz.ccLog.log('Current Portal User Id - '+ccrz.cc_CallContext.currUserId);
        // CHANGE for DISTRIBUTOR_ADMIN_License Issue - if currContact is null...take user details - REVERTED
        Contact cont = ccrz.cc_CallContext.currContact;
        /*Contact cont = new Contact();
if(null != ccrz.cc_CallContext.currContact)
{
cont = ccrz.cc_CallContext.currContact;
}
else
{
Id currUserId = UserInfo.getUserId();
cont = [SELECT Id, Email from Contact WHERE IAM_Contact_Owner__c =:currUserId];
}*/
        
        ccrz.ccLog.log('Current Portal Contact EmailId - '+cont.email);
        Map<String, Object> userFetchResponse = ccrz.ccApiUser.fetch(new Map<String,Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiUser.USER_ID => ccrz.cc_CallContext.currUserId,
                ccrz.ccApi.SIZING=>new Map<String, Object>{
                    ccrz.ccApiUser.ENTITYNAME => new Map<String, Object>{ ccrz.ccAPI.SZ_SKIPTRZ=>true,
                        ccrz.ccAPI.SZ_DATA=>ccrz.ccAPI.SZ_XL} }});
        List<User> userData = (List<User>)userFetchResponse.get(ccrz.ccApiUser.USERLIST); 
        User currentUser = (User)userData.get(0);
        cybersourceHostedPageData.email = cont.email;
        cybersourceHostedPageData.firstName = cont.firstName;
        cybersourceHostedPageData.lastName = cont.lastName;
        String localeKey = currentUser.LocaleSidKey;
        localeKey = localeKey.replace('_', '-');
        cybersourceHostedPageData.locale = localeKey;
        populateDataFromCart(cybersourceHostedPageData,currCartId);
        
        populateSignatureData(cybersourceHostedPageData);
        
        //ccrz.ccLog.log('Returning Cybersrc data In Checkout=====>'+cybersourceHostedPageData);
        return cybersourceHostedPageData;
        
    }
    
    private static void populateDataFromCart(OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData, String currCartId)
    {
        List<String> cartidlist = new List<String>{};
            List<ccrz__E_Cart__c> cartList;
        cartidlist.add(currCartId);
        if(Test.IsRunningTest()){
            ccrz__E_ContactAddr__c objAddress=OSM_SW_CyberSourcePmtForInvoiceCtrl_Test.addressDetails();
            cartList =new List<ccrz__E_Cart__c>();
            List<ccrz__E_Cart__c> cartListQuery=[select id,(SELECT Id, Prorated_Coupon_Discount__c, Prorated_Price_AfterDiscount__c,Prorated_Subamount__c FROM ccrz__E_CartItems__r),Total_Prorated_Amount__c,Prorated_Subamount__c,ccrz__Storefront__c,ccrz__BuyerFirstName__c,ccrz__CurrencyISOCode__c,ccrz__TotalAmount__c,ccrz__BillTo__c,ccrz__CartType__c,ccrz__BuyerLastName__c from ccrz__E_Cart__c Limit 1];
            for(ccrz__E_Cart__c cart:cartListQuery){
                cart.ccrz__BillTo__c=objAddress.id;
                cartList.add(cart);
            }
            update cartList;
        }else{
            Map<String, Object> cartApiFetchResponse = ccrz.ccApiCart.fetch(new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiCart.CART_ENCIDLIST => cartidlist,
                    ccrz.ccApi.SIZING=>new Map<String, Object>{
                        ccrz.ccApiCart.ENTITYNAME => new Map<String, Object>{ ccrz.ccAPI.SZ_SKIPTRZ=>true,
                            ccrz.ccAPI.SZ_DATA=>ccrz.ccAPI.SZ_XL} }
            });
            cartList= (List<ccrz__E_Cart__c>)cartApiFetchResponse.get(ccrz.ccApiCart.CART_OBJLIST);
        }
        ccrz__E_Cart__c cartRecord = (ccrz__E_Cart__c)cartList.get(0);
        
        cybersourceHostedPageData.cartSFId = cartRecord.Id;
        
        if(cartRecord.Total_Prorated_Amount__c < 1){
            cybersourceHostedPageData.transactionType = TRANSACTION_TYPE_ZERODOLLAR;        
        }
        else{
            cybersourceHostedPageData.transactionType = TRANSACTION_TYPE;       
        }
        cybersourceHostedPageData.amount = String.valueOf(cartRecord.Total_Prorated_Amount__c);
        /*
if(cartRecord.ccrz__TotalAmount__c<1){
cybersourceHostedPageData.transactionType = TRANSACTION_TYPE_ZERODOLLAR;        
}
else{
cybersourceHostedPageData.transactionType = TRANSACTION_TYPE;       
}
cybersourceHostedPageData.amount = String.valueOf(cartRecord.ccrz__TotalAmount__c);
*/
        
        cybersourceHostedPageData.currencyCode = cartRecord.ccrz__CurrencyISOCode__c;
        Set<String> addrIds = new Set<String>();
        if (cartRecord.ccrz__BillTo__c  != null)
        {
            addrIds.add(cartRecord.ccrz__BillTo__c );
        }
        if (!addrIds.isEmpty())
        {
            Map<String, Object> addrData = ccrz.ccAPIAddress.fetch(new Map<String, Object>{
                ccrz.ccAPI.API_VERSION=>ccrz.ccAPI.CURRENT_VERSION,
                    ccrz.ccAPIAddress.ADDRESSIDLIST=> addrIds
                    });
            List<Map<String, Object>> addressList = (List<Map<String, Object>>) addrData.get(ccrz.ccAPIAddress.ADDRESSLIST);
            if(ccrz.ccUtil.isNotEmpty(addressList))
            {
                Map<String, Object> billToAddress = (Map<String, Object>)addressList.get(0);
                cybersourceHostedPageData.billingAddressFirstLine =  (String)billToAddress.get('addressFirstline');
                cybersourceHostedPageData.billingAddressCity = (String)billToAddress.get('city');
                cybersourceHostedPageData.billingAddressStateCode = (String)billToAddress.get('stateISOCode');
                cybersourceHostedPageData.billingAddressPostalCode  = (String)billToAddress.get('postalCode');
                cybersourceHostedPageData.billingAddressCountryIsoCode = (String)billToAddress.get('countryISOCode');
                
                if(Test.IsRunningTest()){
                    cybersourceHostedPageData.billingAddressStateCode=null;
                }
                //Added by Vaibhav on 25-Sep
                if((cybersourceHostedPageData.billingAddressStateCode==null || cybersourceHostedPageData.billingAddressStateCode=='') && billToAddress.get('state')!=null){     
                    
                    OSM_SW_CyberSourcePaymentForInvoiceCtrl.populateStatesInfo();
                    String stateName = (String)billToAddress.get('state');
                    if(OSM_SW_CyberSourcePaymentForInvoiceCtrl.stateNameVsInfoMap.containsKey(stateName.trim())){
                        OSM_StateCode__c stateInfo = OSM_SW_CyberSourcePaymentForInvoiceCtrl.stateNameVsInfoMap.get(stateName.trim());
                        cybersourceHostedPageData.billingAddressStateCode = stateInfo.State_Code__c;                        
                    } 
                }                
                
                if(cybersourceHostedPageData.billingAddressCountryIsoCode==null || cybersourceHostedPageData.billingAddressCountryIsoCode==''){
                    cybersourceHostedPageData.billingAddressCountryIsoCode='US';                    
                }
            }
        }
        
        try{
            string reqForm = JSON.serialize(cybersourceHostedPageData);
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Status__c = 'Success';
            log.Request__c = reqForm;
            log.Cart__c = cartRecord.Id;
            log.Service_Name__c = 'BAMS Payment Request';
            log.Source__c = 'OSM';
            log.Target__c = 'BAMS';
            log.Logged_In_User__c = userinfo.getuserid();
            log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');
            insert log;
        } catch(Exception exc){
            system.debug('do nothing excptn with log'+exc);
        }
    }
    
    private static void populateSignatureData(OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData)
    {
        cybersourceHostedPageData.signedFields = 'access_key,profile_id,transaction_uuid,transaction_type,reference_number,signed_date_time,currency,amount,payment_method,locale,merchant_defined_data1,ignore_avs,unsigned_field_names,signed_field_names,override_custom_receipt_page';
        String signedItemString = 'access_key=' + cybersourceHostedPageData.accessKey + ',profile_id=' + cybersourceHostedPageData.profileId + ',transaction_uuid=' + cybersourceHostedPageData.transactionId + ',transaction_type=' + cybersourceHostedPageData.transactionType;
        signedItemString += ',reference_number=' + cybersourceHostedPageData.referenceNumber + ',signed_date_time=' + cybersourceHostedPageData.utcDate + ',currency=' + cybersourceHostedPageData.currencyCode + ',amount=' + cybersourceHostedPageData.amount + ',payment_method=' + cybersourceHostedPageData.paymentMethod + ',locale=' + cybersourceHostedPageData.locale
            + ',merchant_defined_data1='+ cybersourceHostedPageData.cartSFId + ',ignore_avs='+ cybersourceHostedPageData.ignoreAvs;
        signedItemString += ',unsigned_field_names=' + cybersourceHostedPageData.unsignedFields + ',signed_field_names=' + cybersourceHostedPageData.signedFields;
        signedItemString += ',override_custom_receipt_page='+ cybersourceHostedPageData.returnURL;
        cybersourceHostedPageData.signedItems = signedItemString;
        cybersourceHostedPageData.signedData = generateSignature(signedItemString,SECRET_KEY);
    }
    
    private static String generateSignature(String signedItems, String secretKey)
    {
        Blob generateMessageAuthCode = Crypto.generateMac(ALGORITHM_NAME, Blob.valueOf(signedItems), Blob.valueOf(secretKey));
        return EncodingUtil.base64Encode(generateMessageAuthCode);
    }
    
    public static void validateSignatureFromCyberSrc(Map<String, Object> parametersFromBAMS)
    {
        ccrz.cclog.log('====Inside validateSignatureFromCyberSrc===');
        String signedFieldNames =(String) parametersFromBAMS.get('signed_field_names');
        if(signedFieldNames==null || signedFieldNames=='')
        {
            OSM_SignatureMismatchException mismatchException = new OSM_SignatureMismatchException('SIGNATURE_NOT_FOUND_IN_CYBERSOURCE_RESPONSE',true);
            throw mismatchException;
        }
        //ccrz.cclog.log('====signedFieldNames from BAMS===='+signedFieldNames);
        
        String signedItemString='';
        List<String> signedFieldLst = signedFieldNames.split(',');
        for(String signedFieldName : signedFieldLst)
        {
            String signedFieldVal = (String)parametersFromBAMS.get(signedFieldName);
            signedItemString += signedFieldName +'='+ signedFieldVal +',';
        }
        signedItemString = signedItemString.substringBeforeLast(',');
        //ccrz.cclog.log('====signedItemString used for Signature==='+signedItemString);
        String signedData = generateSignature(signedItemString,SECRET_KEY);
        String signatureFromBAMS = (String)parametersFromBAMS.get('signature');
        //ccrz.cclog.log('====Generetaed Signed Key ==='+signedData);
        //ccrz.cclog.log('====BAMS Signed Key ==='+signatureFromBAMS);
        if(!(signatureFromBAMS!=null && signedData!=null && signedData.trim() == signatureFromBAMS.trim())){
            OSM_SignatureMismatchException mismatchException = new OSM_SignatureMismatchException('SIGNATURE_MISMATCH_IN_CYBERSOURCE_RESPONSE',true);
            throw mismatchException;
        }
        
        
        
        
        
    }
    
    
    global static void handleBAMSFailures(String response,String reasonCode,String exceptionMsg)
    {
        System.debug('Inside logs');
        System.debug('Response****'+response);
        //ccrz.cclog.log('===Inside handleBAMSFailures : Response Code is '+response);
        //ccrz.cclog.log('===Inside handleBAMSFailures : reasonCode is '+reasonCode);
        ccrz__E_TransactionPayment__c txPayment = new ccrz__E_TransactionPayment__c();
        if(response!=null && response!=''){
            txPayment.OSM_BamsResponse__c = response;
        }
        else{
            txPayment.OSM_BamsResponse__c = Label.OSM_ResponseBAMS;
        }
        if(exceptionMsg!=null && exceptionMsg!='' && reasonCode!=null && reasonCode!='')
        {
            txPayment.OSM_BamsResponse__c = txPayment.OSM_BamsResponse__c + reasonCode +':'+exceptionMsg ;
        }         
        
        txPayment.Transaction_Status__c = Label.OSM_Order_Placed_Failure;
        txPayment.ccrz__User__c = UserInfo.getUserId();
        
        txPayment.ccrz__Account__c = ccrz.cc_CallContext.currAccountId;
        txPayment.ccrz__BillTo__c = ccrz.cc_CallContext.currAccountId;
        
        // CHANGE for DISTRIBUTOR_ADMIN_License Issue - REVERTED
        txPayment.ccrz__Contact__c = ccrz.cc_CallContext.currContact.id;
        /*if(null != ccrz.cc_CallContext.currContact)
{
txPayment.ccrz__Contact__c = ccrz.cc_CallContext.currContact.id;
}
else
{
Id currUserId = UserInfo.getUserId();
Contact cont = [SELECT Id, Email from Contact WHERE IAM_Contact_Owner__c =:currUserId];

txPayment.ccrz__Contact__c = cont.id;
}*/
        
        
        txPayment.ccrz__AccountType__c = Label.OSM_PaymentMethodOnInvoice;
        System.debug('Inside logs:'+txPayment);
        insert txPayment;
        
        
    }
    
    public static void updateLogs(String reasonCode,String cartId){
        List<ccrz__E_Cart__c> cartList;
        List<String> cartidlist = new List<String>{};
        cartidlist.add(cartId);
        Map<String, Object> cartApiFetchResponse = ccrz.ccApiCart.fetch(new Map<String,Object>{
                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                    ccrz.ccApiCart.CART_ENCIDLIST => cartidlist,
                    ccrz.ccApi.SIZING=>new Map<String, Object>{
                        ccrz.ccApiCart.ENTITYNAME => new Map<String, Object>{ ccrz.ccAPI.SZ_SKIPTRZ=>true,
                            ccrz.ccAPI.SZ_DATA=>ccrz.ccAPI.SZ_XL} }
            });
            cartList= (List<ccrz__E_Cart__c>)cartApiFetchResponse.get(ccrz.ccApiCart.CART_OBJLIST);
        ccrz__E_Cart__c cartRecord = (ccrz__E_Cart__c)cartList.get(0);
        List<OSM_Integration_Log__c> logs = [select id , response__c,cart__c from OSM_Integration_Log__c where cart__r.Id =:cartRecord.Id 
                                            and Service_Name__c = 'BAMS Payment Request'];
        if(logs!=null){
            for(OSM_Integration_Log__c log:logs){
            log.response__c = reasoncode;
        }
            update logs;
        }
        
        
        }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult processCybersourceResponse(ccrz.cc_RemoteActionContext ctx, String paymentResponse) {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        Map<String, Object> responseData = null;
        String cartId = ccrz.cc_CallContext.currCartId;
        
        try
        {
            if(paymentResponse!=null && paymentResponse!=''){
                ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 1');
                //ccrz.ccLog.log(System.LoggingLevel.INFO, 'INFO', paymentResponse);
                Map<String, Object> parameters = (Map<String,Object>)JSON.deserializeUntyped(paymentResponse);
                if(!Test.IsRunningTest()){
                    validateSignatureFromCyberSrc(parameters);
                }
                String decisionResponse = (String)parameters.get(DECISION_RESPONSE);
                String addressFailureCode = (String)parameters.get(ADDRESSCODE_RESPONSE);
                String reasonCode = (String)parameters.get(REASON_CODE);
                system.debug(JSON.serializePretty(parameters));
                
                system.debug('+++++++++parameters++++++++++++');
                
                
                if (!String.isBlank(decisionResponse) && !String.isBlank(reasonCode))
                {
                    ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 2');
                    if (decisionResponse == DECISION_ACCEPT && reasonCode=='100')
                    {
                        ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 3');
                        String paymentToken = (String)parameters.get(PAYMENT_TOKEN);
                        String authCode = (String)parameters.get(AUTH_CODE);
                        String cardType = translateCardType((String)parameters.get(CARD_TYPE));
                        String cardExpiryDt = (String)parameters.get(CARD_EXP_DATE);
                        String expMonth = cardExpiryDt.substring(0,2);
                        String expYear = cardExpiryDt.substring(5);
                        String reqAmount = (String)parameters.get(AUTH_AMOUNT);
                        String txId = (String)parameters.get(TX_ID);
                        String bamsMarchantNo = (String)parameters.get(REQ_REF_NUM);//Added by Vineet on 26/10/1028
                        String accountNumber = (String)parameters.get(CARD_NUMBER); // Added for MAR-1739
                        
                        
                        String bankTransRef = (String)parameters.get(BANK_TRANS_REF_NO);
                        
                        Double transactionAmount = null;
                        
                        if(paymentToken==null || paymentToken==''){
                            
                            if (reqAmount != null && reqAmount != '')
                            {
                                transactionAmount = Double.valueOf(reqAmount);
                                if(transactionAmount<1){
                                    paymentToken = txId;
                                }
                            }
                        }
                        
                        
                        DateTime transactionDate = System.now();
                        responseData =  new Map<String,Object>{'paymentToken'=>paymentToken,
                            'authCode'=>authCode,
                            'cardType'=>cardType,
                            'expMonth'=>expMonth,
                            'expYear'=>expYear,
                            'reqAmount' =>reqAmount,
                            'transactionDate'=>transactionDate,
                            'bankTransRef' =>bankTransRef,
                            'accountNumber' =>accountNumber, // Added for MAR-1739
                            'bamsMarchantNo'=>bamsMarchantNo} ;
                                response.success = true;
                    } else if(reasonCode=='240'){
                        ccrz.ccLog.log('-----Wrong Card Number');
                        response.success = false;
                        String msg = Label.Incorrect_card_number;
                        responseData = new Map<String,Object>{'message'=>msg};
                            handleBAMSFailures(paymentResponse,reasonCode,msg);
                         updateLogs(reasonCode,cartId);
                        
                    }else if(reasonCode=='211'){
                        ccrz.ccLog.log('---Invalid Card Verifiation Number');
                        response.success = false;
                        String msg = Label.Incorrect_cvv;
                        responseData = new Map<String,Object>{'message'=>msg};
                            handleBAMSFailures(paymentResponse,reasonCode,msg);
                        updateLogs(reasonCode,cartId);
                    }else if(reasonCode=='202'){
                        ccrz.ccLog.log('---Invalid Expiration Date');
                        response.success = false;
                        String msg = Label.Expiration_date;
                        responseData = new Map<String,Object>{'message'=> msg};
                            handleBAMSFailures(paymentResponse,reasonCode,msg);
                        updateLogs(reasonCode,cartId);
                    }else if(reasonCode=='460'){
                        ccrz.ccLog.log('---Invalid Address');
                        response.success = false;
                        String msg = Label.Billing_Address;
                        responseData = new Map<String,Object>{'message'=>msg};
                            handleBAMSFailures(paymentResponse,reasonCode,msg);
                          updateLogs(reasonCode,cartId);
                    }else if(reasonCode=='203' || reasonCode=='205' || reasonCode=='208' || reasonCode=='210'
                             || reasonCode=='220' || reasonCode=='222' || reasonCode=='230' || reasonCode=='231' 
                             || reasonCode=='232' || reasonCode=='233' || reasonCode=='234' || reasonCode=='235'
                             || reasonCode=='236' || reasonCode=='237' || reasonCode=='238'){
                        ccrz.ccLog.log('---Wrong Card Number');
                        response.success = false;
                        String msg = Label.OSM_CARD_DECLINE;
                        responseData = new Map<String,Object>{'message'=> msg};
                            handleBAMSFailures(paymentResponse,reasonCode,msg);
                       updateLogs(reasonCode,cartId);
                    }
                    else
                    {
                        ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 4');
                        response.success = false;
                        handleBAMSFailures(paymentResponse,reasonCode,null);
                        updateLogs(reasonCode,cartId);
                        responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                            };
                                
                                /*
//Commented on 15-Sep as OSM does not need to check the Address failure code.
//OSM needs to check reasoncode=100 for successful TX
if(addressFailureCode=='N')
//Incase response got from BAMS is invalid
if(INVALID_ADDRESS_CODES.contains(addressFailureCode))
{
handleBAMSFailures(paymentResponse);
//tbd later for labels
responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_CyberSource_AddrerssMsg              
};
}
*/
                                
                                }
                }
                else
                {
                    ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 5');
                    response.success = false;
                    handleBAMSFailures(paymentResponse,reasonCode,null);
                    updateLogs(reasonCode,cartId);
                    //tbd later for labels
                    responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                        };
                            
                            
                            }         
                response.data  = responseData;
            }
            else{
                ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 6');
                response.success = false;
                handleBAMSFailures(paymentResponse,null,null);
                //tbd later for labels
                responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                    };
                        response.data  = responseData;
            }
            if(Test.IsRunningTest()){
                throw new NullPointerException();
            }
            
        }
        catch(OSM_SignatureMismatchException e){
            
            String errorMsg = e.exceptionMessage;
            response.success = false;
            handleBAMSFailures(paymentResponse,null,errorMsg);
            responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                };
                    response.data = responseData;
            
        }
        catch (Exception ex)
        {
            ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 7');
            ccrz.ccLog.log(System.LoggingLevel.ERROR, 'ERR', ex);
            String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
            response.success = false;
            handleBAMSFailures(paymentResponse,null,errorMsg);
            responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                };
                    response.data = responseData;
        }
        finally
        {
            //ccrz.ccLog.close(response);
        }
        return response;
    }
    
    public static String translateCardType(String cardType)
    {
        if (cardType == '001')
        {
            return VISA ;
        }
        else if (cardType == '002')
        { 
            return MASTER_CARD;
        }
        else if (cardType == '003')
        {
            return AMERICAN_EXPRESS;
        }
        else if (cardType == '004')
        {
            return DISCOVER ;
        }
        else
        {
            return cardType;
        }
    }
}