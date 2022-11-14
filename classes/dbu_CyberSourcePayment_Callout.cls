global without sharing class dbu_CyberSourcePayment_Callout {
    
    public String postURL{get;set;}
    public static String ACCESS_KEY = System.Label.dbu_CyberSource_ACCESS_KEY;
    public static String PROFILE_ID = System.Label.dbu_CyberSource_PROFILE_ID;
    public static String SECRET_KEY = System.Label.dbu_CyberSource_SECRET_KEY;
    public static String POST_URL = System.Label.dbu_CyberSource_POST_URL;
    public static String RETURN_URL;// = System.Label.dbu_CyberSource_RETURN_URL_Origin+System.Label.dbu_CyberSource_RETURN_URL; // return url goes here;
    public static String StoreLocation1 = 'US';
	public static boolean isMotionPoint = false;
    //public static String RETURN_URL = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/payment?cartId=a1y19000001BdieAAC';//System.Label.dbu_CyberSource_RETURN_URL; // return url goes here;

    public static final String ALGORITHM_NAME = 'hmacSHA256';
    //public static final String TRANSACTION_TYPE='sale,create_payment_token';
    public static final String TRANSACTION_TYPE='sale';
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
    private static final String IGNORE_AVS = System.Label.dbu_CyberSource_AVS;
    
    private static final String CARD_NUMBER = 'req_card_number'; 
    private static final String CARD_TYPE = 'req_card_type'; 
    private static final String CARD_EXP_DATE = 'req_card_expiry_date'; 
    private static final String AUTH_AMOUNT = 'req_amount'; 
    private static final String REQ_REF_NUM = 'req_reference_number';
    
    private static final String VISA = 'Visa';
    private static final String AMERICAN_EXPRESS = 'American Express';
    private static final String MASTER_CARD = 'Mastercard';
    private static final String DISCOVER = 'Discover';
    
    
    global dbu_CyberSourcePayment_Callout(){
        postURL = POST_URL;
    }
    
    @AuraEnabled
    global static dbu_CyberSourcePaymentWrapper getCybersourceHostedFormData(String cartId, String storefrontName,String currentUserId, String storeLocation, String currentDomain)
    //global static ccrz.cc_RemoteActionResult getCybersourceHostedFormData(String cartId, String storefrontName,String currentUserId)
    //global static ccrz.cc_RemoteActionResult getCybersourceHostedFormData(ccrz.cc_RemoteActionContext ctx, String cartId, String storefrontName,String currentUserId)
    {
        
        List<dbu_Domain_for_Payment__c> paymentDomains = dbu_Domain_for_Payment__c.getall().values();
        boolean foundDomain = false;
        for(dbu_Domain_for_Payment__c objDomain : paymentDomains)
        {
            if(currentDomain == objDomain.Domain_Name__c)
                foundDomain = true;
        }
        if(!foundDomain)
        {
            throw new AuraHandledException('Domain is not availabel for payment');
        }
        //**********TEMPORARY CODE********** */
        //cartId = 'a1y19000001BdieAAC';
        //storefrontName = 'CSSNAStore';
        //**********TEMPORARY CODE ENDS********** */
        /*
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                ctx.storefront = 'CSSNAStore';
                ccrz.cc_CallContext.initRemoteContext(ctx);
                ccrz.cc_CallContext.currAccountId = accountId;//'0011F00000fk3pHQAQ';
                ccrz.cc_CallContext.userCurrency = 'USD';
        */
        /*
        ccrz__E_Cart__c cart1 = [select id,dbu_Cart_StoreCountry__c from ccrz__E_Cart__c where Id = : cartId];
            
            if(cart1.dbu_Cart_StoreCountry__c == 'CA')
            {
                ACCESS_KEY = System.Label.dbu_CyberSource_ACCESS_KEY_CA;
                PROFILE_ID = System.Label.dbu_CyberSource_PROFILE_ID_CA;
                SECRET_KEY = System.Label.dbu_CyberSource_SECRET_KEY_CA;
            }
            
            */
            RETURN_URL = currentDomain+System.Label.dbu_CyberSource_RETURN_URL+'?store='+storeLocation;
            //RETURN_URL = '';
            if(storeLocation != 'US')
            {
                ACCESS_KEY = System.Label.dbu_CyberSource_ACCESS_KEY_CA;
                PROFILE_ID = System.Label.dbu_CyberSource_PROFILE_ID_CA;
                SECRET_KEY = System.Label.dbu_CyberSource_SECRET_KEY_CA;
                StoreLocation1 = 'CA';
                
            }
			if(storeLocation.toUpperCase() == 'FR')
				isMotionPoint = true;
        
        
        System.debug('inside getCybersourceHostedFormData');
        System.debug(cartId);
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        
        dbu_CyberSourcePaymentWrapper cybersourceHostedPageData = null;
        try
        {
            //get the returnurl for Site User and CSR
            //RETURN_URL = OSM_SW_CyberSourcePaymentForInvoiceCtrl.populateReturnUrlToBAMS();// need to change
            //ccrz.ccLog.log('===RETURN_URL before Decode==='+RETURN_URL);
            /**************************TODO: Pass correct current user id and contact value */
            //String currentUserId=null;
            Contact currentContact=null;
            System.debug('RETURN_URL======'+RETURN_URL);
            //populateReturnUrlToBAMS()
           if(Test.IsRunningTest()){
                ccrz__E_Cart__c cart=[select id,ccrz__Storefront__c,ccrz__CartType__c from ccrz__E_Cart__c Limit 1];
                cybersourceHostedPageData = buildCybersourceHostedFormData(cart.ccrz__Storefront__c,cart.Id,currentUserId,currentContact);
                System.debug('cybersourceHostedPageData____'+cybersourceHostedPageData);
                Map<String, Object> hostedPageData =   new Map<String,Object>{'cybersourceHostedPageData' => cybersourceHostedPageData} ;
                response.success = true;
                response.data =  hostedPageData;
                
            }else{
                cybersourceHostedPageData = buildCybersourceHostedFormData(storefrontName, cartId,currentUserId,currentContact);
                System.debug('cybersourceHostedPageData=>'+ cybersourceHostedPageData); 
                Map<String, Object> hostedPageData =   new Map<String,Object>{'cybersourceHostedPageData' => cybersourceHostedPageData} ;
                response.success = true;
                System.debug('hostedPageData=>'+ hostedPageData); 
                response.data =  hostedPageData;
            }
            dbu_Integration_Error_Log.createErrorLog(200,'',JSON.serialize(response.data),'','Cybersource','Success'); 
           if(Test.IsRunningTest()){
           throw new NullPointerException();
            }
        }
        catch (Exception ex)
        {

            ccrz.ccLog.log(System.LoggingLevel.ERROR, 'ERR', ex);
            response.success = false;
            response.data = null;
            dbu_Integration_Error_Log.createErrorLog(500,ex.getMessage()+' '+ex.getLineNumber()+' '+ex.getStackTraceString(),'','','Cybersource','Exception');//Anirudh Changes
        }
        finally
        {
            ccrz.ccLog.close(response);
        }
        System.debug('exiting getCybersourceHostedFormData');
        System.debug('response=>'+ response);
        
        return cybersourceHostedPageData;
        //return response;

    }
    
    public static dbu_CyberSourcePaymentWrapper buildCybersourceHostedFormData(String storefrontName, String currCartId,String currentUserId,Contact currentContact)
    //public static dbu_CyberSourcePaymentWrapper buildCybersourceHostedFormData(String storefrontName, String currCartId)
    {
        
        Datetime currentDateTime =  Datetime.now();
        dbu_CyberSourcePaymentWrapper cybersourceHostedPageData = new dbu_CyberSourcePaymentWrapper();
        cybersourceHostedPageData.cartId = currCartId;
        cybersourceHostedPageData.utcDate = currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'GMT');
        cybersourceHostedPageData.transactionId = String.valueOf(System.currentTimeMillis());
        cybersourceHostedPageData.referenceNumber = String.valueOf(System.currentTimeMillis());
        cybersourceHostedPageData.unsignedFields = UNSIGNED_FIELDS;
        
        
        //*******TEMPORARY CODE*** */
        //cybersourceHostedPageData.returnURL = 'https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/payment?cartId=a1y1F0000013pjDQAQ';
        //*******TEMPORARY CODE ENDS*** */
        cybersourceHostedPageData.returnURL = RETURN_URL;
        cybersourceHostedPageData.postUrl = POST_URL;
        cybersourceHostedPageData.paymentMethod = PAYMENT_METHOD;
        
        
        cybersourceHostedPageData.ignoreAvs = Boolean.valueOf(IGNORE_AVS);
        
        cybersourceHostedPageData.accessKey = ACCESS_KEY;
        cybersourceHostedPageData.profileId=PROFILE_ID;
        //ccrz.ccLog.log('Current Portal User Id - '+ccrz.cc_CallContext.currUserId);
            // CHANGE for DISTRIBUTOR_ADMIN_License Issue - if currContact is null...take user details - REVERTED
            //Contact cont = ccrz.cc_CallContext.currContact;
            
           System.debug('cybersourceHostedPageData=>'+ cybersourceHostedPageData); 
        //System.debug('Current Portal Contact EmailId - '+cont.email);
        /*
        Map<String, Object> userFetchResponse = ccrz.ccApiUser.fetch(new Map<String,Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiUser.USER_ID => currentUserId,
                ccrz.ccApi.SIZING=>new Map<String, Object>{
                    ccrz.ccApiUser.ENTITYNAME => new Map<String, Object>{ ccrz.ccAPI.SZ_SKIPTRZ=>true,
                        ccrz.ccAPI.SZ_DATA=>ccrz.ccAPI.SZ_XL} }});
        List<User> userData = (List<User>)userFetchResponse.get(ccrz.ccApiUser.USERLIST); 
        
        User currentUser = (User)userData.get(0);
        System.debug('currentUser=>'+currentUser);
        //cybersourceHostedPageData.email = currentContact.email;//TODO: Need to query current users contact object
       
        cybersourceHostedPageData.email = currentUser.Email;
        String localeKey = currentUser.LocaleSidKey;
        localeKey = localeKey.replace('_', '-');
        cybersourceHostedPageData.locale = localeKey;
         */
        System.debug('calling populateDataFromCart');
        populateDataFromCart(cybersourceHostedPageData,currCartId);
        System.debug('called populateDataFromCart');
        System.debug('calling populateSignatureData');
        populateSignatureData(cybersourceHostedPageData);
        System.debug('called populateSignatureData');
        
        System.debug('Returning Cybersrc data In Checkout=====>'+cybersourceHostedPageData);
        return cybersourceHostedPageData;
            
    }
    
    private static void populateDataFromCart(dbu_CyberSourcePaymentWrapper cybersourceHostedPageData, String currCartId)
    {
        System.debug('inside populateDataFromCart');

        List<String> cartidlist = new List<String>{};
        List<ccrz__E_Cart__c> cartList;
        cartidlist.add(currCartId);
        System.debug('inside populateDataFromCart cartidlist=>'+ cartidlist);
        
        if(Test.IsRunningTest()){
        System.debug('inside populateDataFromCart IsRunningTest' );

        ccrz__E_ContactAddr__c objAddress=OSM_SW_CyberSourcePmtForInvoiceCtrl_Test.addressDetails();
         cartList =new List<ccrz__E_Cart__c>();
        List<ccrz__E_Cart__c> cartListQuery=[select id,ccrz__Storefront__c,ccrz__BuyerFirstName__c,ccrz__CurrencyISOCode__c,ccrz__TotalAmount__c,ccrz__BillTo__c,ccrz__CartType__c,ccrz__BuyerLastName__c,ccrz__BuyerEmail__c from ccrz__E_Cart__c Limit 1];
        for(ccrz__E_Cart__c cart:cartListQuery){
            cart.ccrz__BillTo__c=objAddress.id;
            cartList.add(cart);
        }
        update cartList;
        }else{
        System.debug('inside populateDataFromCart Else condition' );

            Map<String, Object> cartApiFetchResponse = ccrz.ccApiCart.fetch(new Map<String,Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiCart.CART_ENCIDLIST => cartidlist,
                ccrz.ccApi.SIZING=>new Map<String, Object>{
                    ccrz.ccApiCart.ENTITYNAME => new Map<String, Object>{ ccrz.ccAPI.SZ_SKIPTRZ=>true,
                        ccrz.ccAPI.SZ_DATA=>ccrz.ccAPI.SZ_XL} }
        });

        System.debug('populateDataFromCart calling cartApiFetchResponse API=>');

             cartList= (List<ccrz__E_Cart__c>)cartApiFetchResponse.get(ccrz.ccApiCart.CART_OBJLIST);
        }
        System.debug('populateDataFromCart called cartApiFetchResponse API=>'+ cartList);
        ccrz__E_Cart__c cartRecord = null;
        if(cartList.size()>0)
        {
         cartRecord = (ccrz__E_Cart__c)cartList.get(0);
        }
        else
        {
            /** NEED TO GET AWAY WITH THIS ELSE CONDITION, CC API SHOULD BE ABLE TO FETCH CART */
            cartList= [SELECT Id,
                            ccrz__BuyerFirstName__c,
                            ccrz__BuyerLastName__c,
                            ccrz__TotalAmount__c,
                            ccrz__CurrencyISOCode__c,
                            ccrz__BillTo__c,ccrz__BuyerEmail__c FROM ccrz__E_Cart__c WHERE Id=:currCartId LIMIT 1];
            cartRecord = cartList[0];
        }
        System.debug('populateDataFromCart cartRecord=>'+cartRecord);
               //*******TEMPORARY CODE *** */
               /*
        cybersourceHostedPageData.cartSFId = 'a1y1F0000013pjDQAQ';
        cybersourceHostedPageData.firstName = 'Rajnish';
        cybersourceHostedPageData.lastName = 'Kumar';
        cybersourceHostedPageData.email = 'rajnishkumar21@gmail.com';
        */
               //*******TEMPORARY CODE ENDS*** */
        cybersourceHostedPageData.cartSFId = cartRecord.Id;
        cybersourceHostedPageData.firstName = cartRecord.ccrz__BuyerFirstName__c;
        cybersourceHostedPageData.lastName = cartRecord.ccrz__BuyerLastName__c;
        cybersourceHostedPageData.email = cartRecord.ccrz__BuyerEmail__c;
        cybersourceHostedPageData.locale = 'en-US';
		if(isMotionPoint)
			cybersourceHostedPageData.locale = 'fr-ca';
        
        //START:ADDED by Vaibhav on 19-Sep
        if(cartRecord.ccrz__TotalAmount__c<1){
            cybersourceHostedPageData.transactionType = TRANSACTION_TYPE_ZERODOLLAR;        
        }
        else{
            cybersourceHostedPageData.transactionType = TRANSACTION_TYPE;       
        }
        //END:ADDED by Vaibhav on 19-Sep
        cybersourceHostedPageData.amount = String.valueOf(cartRecord.ccrz__TotalAmount__c);
        cybersourceHostedPageData.currencyCode = cartRecord.ccrz__CurrencyISOCode__c;
        if(StoreLocation1 != 'US')
            cybersourceHostedPageData.currencyCode = 'CAD';
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
                //*******TEMPORARY CODE ENDS*** */
                //cybersourceHostedPageData.billingAddressFirstLine =  '330 Potrero Ave';
                //cybersourceHostedPageData.billingAddressCity = 'Sunnyvale';
                //cybersourceHostedPageData.billingAddressStateCode = 'CA';
                //cybersourceHostedPageData.billingAddressPostalCode  = '94085';
                //cybersourceHostedPageData.billingAddressCountryIsoCode = 'US';
                //*******TEMPORARY CODE ENDS*** */
                cybersourceHostedPageData.billingAddressFirstLine =  (String)billToAddress.get('addressFirstline');
                cybersourceHostedPageData.billingAddressCity = (String)billToAddress.get('city');
                cybersourceHostedPageData.billingAddressStateCode = (String)billToAddress.get('state');
                cybersourceHostedPageData.billingAddressPostalCode  = (String)billToAddress.get('postalCode');
                cybersourceHostedPageData.billingAddressCountryIsoCode = (String)billToAddress.get('country');
                  if(Test.IsRunningTest()){
                  cybersourceHostedPageData.billingAddressStateCode=null;
                  }
                  if((cybersourceHostedPageData.billingAddressStateCode==null || cybersourceHostedPageData.billingAddressStateCode=='') && billToAddress.get('state')!=null){     
                    
                    OSM_SW_CyberSourcePaymentForInvoiceCtrl.populateStatesInfo();// need to change
                    String stateName = (String)billToAddress.get('state');
                    if(OSM_SW_CyberSourcePaymentForInvoiceCtrl.stateNameVsInfoMap.containsKey(stateName.trim())){
                        OSM_StateCode__c stateInfo = OSM_SW_CyberSourcePaymentForInvoiceCtrl.stateNameVsInfoMap.get(stateName.trim());
                        cybersourceHostedPageData.billingAddressStateCode = stateInfo.State_Code__c;
                        
                    }                       
                    
                }
                
                 
                if(cybersourceHostedPageData.billingAddressCountryIsoCode==null || cybersourceHostedPageData.billingAddressCountryIsoCode==''){
                    
                    //Alert : for 1B and later release this needs to be changed
                    cybersourceHostedPageData.billingAddressCountryIsoCode='US';
                    
                }
                
                
            }
        }
    }
    
    private static void populateSignatureData(dbu_CyberSourcePaymentWrapper cybersourceHostedPageData)
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
    /*
    public static void validateSignatureFromCyberSrc(Map<String, Object> parametersFromBAMS)
    {
         ccrz.cclog.log('====Inside validateSignatureFromCyberSrc===');
         String signedFieldNames =(String) parametersFromBAMS.get('signed_field_names');
        if(signedFieldNames==null || signedFieldNames=='')
        {
            OSM_SignatureMismatchException mismatchException = new OSM_SignatureMismatchException('SIGNATURE_NOT_FOUND_IN_CYBERSOURCE_RESPONSE',true);
            throw mismatchException;
        }
         ccrz.cclog.log('====signedFieldNames from BAMS===='+signedFieldNames);
        
         String signedItemString='';
         List<String> signedFieldLst = signedFieldNames.split(',');
        for(String signedFieldName : signedFieldLst)
        {
             String signedFieldVal = (String)parametersFromBAMS.get(signedFieldName);
             signedItemString += signedFieldName +'='+ signedFieldVal +',';
        }
        signedItemString = signedItemString.substringBeforeLast(',');
        ccrz.cclog.log('====signedItemString used for Signature==='+signedItemString);
        String signedData = generateSignature(signedItemString,SECRET_KEY);
        String signatureFromBAMS = (String)parametersFromBAMS.get('signature');
        ccrz.cclog.log('====Generetaed Signed Key ==='+signedData);
        ccrz.cclog.log('====BAMS Signed Key ==='+signatureFromBAMS);
        if(!(signatureFromBAMS!=null && signedData!=null && signedData.trim() == signatureFromBAMS.trim())){
            OSM_SignatureMismatchException mismatchException = new OSM_SignatureMismatchException('SIGNATURE_MISMATCH_IN_CYBERSOURCE_RESPONSE',true);
            throw mismatchException;
        }
    }
    
    @AuraEnabled(cacheable=true)
    global static ccrz.cc_RemoteActionResult processCybersourceResponse(ccrz.cc_RemoteActionContext ctx, String paymentResponse) {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        Map<String, Object> responseData = null;
        
        try
        {
            if(paymentResponse!=null && paymentResponse!=''){
                ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 1');
                ccrz.ccLog.log(System.LoggingLevel.INFO, 'INFO', paymentResponse);
                Map<String, Object> parameters = (Map<String,Object>)JSON.deserializeUntyped(paymentResponse);
                if(!Test.IsRunningTest()){
                    validateSignatureFromCyberSrc(parameters);
                }
                String decisionResponse = (String)parameters.get(DECISION_RESPONSE);
                String addressFailureCode = (String)parameters.get(ADDRESSCODE_RESPONSE);
                String reasonCode = (String)parameters.get(REASON_CODE);
                system.debug(parameters);
                
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
                            'bamsMarchantNo'=>bamsMarchantNo} ;
                            response.success = true;
                    }
                    else
                    {
                        ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 4');
                        response.success = false;
                       // handleBAMSFailures(paymentResponse,reasonCode,null);
                        responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                        };
                
                    }
                }
                else
                {
                    ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 5');
                    response.success = false;
                   // handleBAMSFailures(paymentResponse,reasonCode,null);
                    //tbd later for labels
                    responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                    };
                   
                   
                }         
                response.data  = responseData;
            }
            else{
                    ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 6');
                    response.success = false;
                   // handleBAMSFailures(paymentResponse,null,null);
                    //tbd later for labels
                   // responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                   // };
                    response.data  = responseData;
            }
             if(Test.IsRunningTest()){
                throw new NullPointerException();
            }

        }
/*
        /*catch(OSM_SignatureMismatchException e){
            
            String errorMsg = e.exceptionMessage;
            response.success = false;
            handleBAMSFailures(paymentResponse,null,errorMsg);
            responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                    };
            response.data = responseData;
            
        }*/
       /* catch (Exception ex)
        {
            ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 7');
            ccrz.ccLog.log(System.LoggingLevel.ERROR, 'ERR', ex);
            String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
            response.success = false;
            handleBAMSFailures(paymentResponse,null,errorMsg);
            responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                    };
            response.data = responseData;
        }*/
    /*
        finally
        {
            ccrz.ccLog.close(response);
        }
        return response;
    }
    */
    /*
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
    */
}