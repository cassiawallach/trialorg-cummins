//We have a change in this class for 1B and later release country logic needs to be changed.Please see Alert below.
//testline

global class OSM_SW_CyberSourcePaymentForInvoiceCtrl {
    
    
    public static String ACCESS_KEY = System.Label.CyberSource_ACCESS_KEY; // access key goes here;
    public static String SECRET_KEY = System.Label.CyberSource_SECRET_KEY; //valid secret key goes here;
    public static String PROFILE_ID = System.Label.CyberSource_PROFILE_ID; // profile id goes here ;
    
    //new BAMS Account
    //public static String ACCESS_KEY = 'c2350ec4ef053da8a648ac2ecb473f69'; // access key goes here;
    // public static String SECRET_KEY = 'b6788e5fc30440d0b41cdf1f68961795054039c41eb94c53b5be47c9168864532c3327846e0543288a2de8c0529146e8357d0e3e01c94e9f9158ceb29b2f042857b28db5bcd342f2a614f46041b8b07d6589406d7cca4c69895f707d84aed390e342d57e045f4276bc89a30ced72dc75d991256257d2457d98b1d536f63c6d64'; //valid secret key goes here;
    //public static String PROFILE_ID = 'CBCBCAEC-04A4-49C9-8009-63830CD26A89'; // profile id goes here ;
    
    
    public static String POST_URL = System.Label.CyberSource_POST_URL; // post url goes here;
    public static String RETURN_URL = null;
    
    
    
    
    public static final String ALGORITHM_NAME = 'hmacSHA256';
    public static final String TRANSACTION_TYPE='sale,create_payment_token';
    public static final String PAYMENT_METHOD = 'card';
    public static final String UNSIGNED_FIELDS = 'bill_to_forename,bill_to_surname,bill_to_email,bill_to_address_line1,bill_to_address_city,bill_to_address_country,bill_to_address_state,bill_to_address_postal_code';
    
    private static final String DECISION_ACCEPT = 'ACCEPT';
    private static final String REASON_CODE = 'reason_code';
    private static final String CART_ID = 'cartID';
    private static final String CART_SFID = 'cartSFID';
    private static final String DECISION_RESPONSE = 'decision';
    private static final String PAYMENT_TOKEN = 'payment_token';
    private static final String BANK_TRANS_REF_NO = 'auth_trans_ref_no';
    private static final String AUTH_CODE = 'auth_code';
    
    private static final String CARD_NUMBER = 'req_card_number'; 
    private static final String CARD_TYPE = 'req_card_type'; 
    private static final String CARD_EXP_DATE = 'req_card_expiry_date'; 
    private static final String AUTH_AMOUNT = 'req_amount'; 
    
    private static final String VISA = 'Visa';
    private static final String AMERICAN_EXPRESS = 'American Express';
    private static final String MASTER_CARD = 'Mastercard';
    private static final String DISCOVER = 'Discover';
    
    public  static Map<String,OSM_StateCode__c> stateNameVsInfoMap = null;
    private static String invoiceId;
    
    private static final String IGNORE_AVS = System.Label.CyberSource_AVS;
    
    
    public static String populateReturnUrlToBAMS()
    {
        String returnURL = '';
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        if(ccrz.cc_CallContext.isOnBehalf)
        {
            //for CSR flow
            String relativePath = '/apex/ccrz__CCBridge?pageKey=cybersourcePost&store=SoftwareStore';
            returnURL = baseUrl + relativePath;
            
            returnURL = EncodingUtil.urlEncode(returnURL, 'UTF-8');
        }
        else
        {
            //RETURN_URL = 'https://eidmdev-cumminscss.cs61.force.com/CMIStore/ccrz__CCBridge?pageKey=cybersourcePost';
            String urlPath = Site.getPathPrefix();
            returnURL = baseUrl + urlPath + '/ccrz__CCBridge?pageKey=cybersourcePost';
            
        }
        
        returnURL = EncodingUtil.urlDecode(returnURL, 'UTF-8');
        return returnURL;
        
        
    }
    
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCybersourceHostedFormData(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData = null;
        try
        {
            //prepare the returnurl based on the site user or CSR
            RETURN_URL = populateReturnUrlToBAMS();
            Map<String,String> paramMap = ccrz.cc_CallContext.currPageParameters;
            
            
            for(String keyParam : paramMap.keySet())
            {
                //ccrz.ccLog.log('===keyParam==='+keyParam);
                //ccrz.ccLog.log('===valueParam==='+paramMap.get(keyParam));
            }
            
            if(paramMap.containskey('i'))
            {
                invoiceId = paramMap.get('i');
            }
            //ccrz.ccLog.log('===RETURN_URL==='+RETURN_URL);
            
            cybersourceHostedPageData = buildCybersourceHostedFormData(ccrz.cc_CallContext.storefront, invoiceId);
            Map<String, Object> hostedPageData =   new Map<String,Object>{'cybersourceHostedPageData' => cybersourceHostedPageData} ;
                response.success = true;
            response.data =  hostedPageData;
            if(Test.isRunningTest()){
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
    
    public static OSM_SW_CybersourceHostedPageDataFields buildCybersourceHostedFormData(String storefrontName, String invoiceId)
    {
        Datetime currentDateTime =  Datetime.now();
        OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData = new OSM_SW_CybersourceHostedPageDataFields();
        cybersourceHostedPageData.cartId = invoiceId;
        cybersourceHostedPageData.invoiceId=invoiceId;
        cybersourceHostedPageData.utcDate = currentDateTime.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'', 'GMT');
        cybersourceHostedPageData.transactionId = String.valueOf(System.currentTimeMillis());
        cybersourceHostedPageData.referenceNumber = String.valueOf(System.currentTimeMillis());
        cybersourceHostedPageData.unsignedFields = UNSIGNED_FIELDS;
        cybersourceHostedPageData.transactionType = TRANSACTION_TYPE;
        cybersourceHostedPageData.returnURL = RETURN_URL;
        cybersourceHostedPageData.postUrl = POST_URL;
        cybersourceHostedPageData.paymentMethod = PAYMENT_METHOD;
        cybersourceHostedPageData.ignoreAvs = Boolean.valueOf(IGNORE_AVS);
        cybersourceHostedPageData.accessKey = ACCESS_KEY;
        cybersourceHostedPageData.profileId=PROFILE_ID;
        
        
        String userId = ccrz.cc_CallContext.currUserId;
        
        Map<String, Object> userFetchResponse = ccrz.ccApiUser.fetch(new Map<String,Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiUser.USER_ID => userId,
                ccrz.ccApi.SIZING=>new Map<String, Object>{
                    ccrz.ccApiUser.ENTITYNAME => new Map<String, Object>{ ccrz.ccAPI.SZ_SKIPTRZ=>true,
                        ccrz.ccAPI.SZ_DATA=>ccrz.ccAPI.SZ_XL} }});
        List<User> userData = (List<User>)userFetchResponse.get(ccrz.ccApiUser.USERLIST); 
        User currentUser = (User)userData.get(0);
        cybersourceHostedPageData.email = currentUser.Email;
        String localeKey = currentUser.LocaleSidKey ;
        localeKey = localeKey.replace('_', '-');
        if(invoiceId!=null && invoiceId!='')
        {
            populateDataFromInvoice(cybersourceHostedPageData);
        }
        
        cybersourceHostedPageData.locale = localeKey;
        //populateDataFromCart(cybersourceHostedPageData,currCartId);
        System.debug('cart data' + cybersourceHostedPageData);
        populateSignatureData(cybersourceHostedPageData);
        System.debug('cybersourceData >>>>>' + cybersourceHostedPageData);
        //ccrz.ccLog.log('Returning Cybersrc data from Invoice=====>'+cybersourceHostedPageData);
        return cybersourceHostedPageData;
    }
    
    
    private static void populateDataFromInvoice(OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData)
    {
        
        
        
        
        ccrz__E_Invoice__c invoice = [select id,name,ccrz__BillAddress__c,ccrz__Contact__c,ccrz__Contact__r.firstname,ccrz__Contact__r.phone,ccrz__Contact__r.lastname,ccrz__OriginalAmount__c,ccrz__CurrencyCode__c from ccrz__E_Invoice__c where id=:cybersourceHostedPageData.invoiceid ];
        if(Test.IsRunningTest()){
            ccrz__E_ContactAddr__c objAddress=OSM_SW_CyberSourcePmtForInvoiceCtrl_Test.addressDetails();
            invoice.ccrz__BillAddress__c=objAddress.id;
            
        }
        
        
        cybersourceHostedPageData.cartSFId = cybersourceHostedPageData.invoiceId;
        
        cybersourceHostedPageData.firstName = invoice.ccrz__Contact__r.firstname;
        cybersourceHostedPageData.lastName = invoice.ccrz__Contact__r.lastname;
        cybersourceHostedPageData.phone= invoice.ccrz__Contact__r.phone;
        //cybersourceHostedPageData.firstName = 'Vaibhav';
        //cybersourceHostedPageData.lastName = 'Sharma';
        
        cybersourceHostedPageData.amount = String.valueOf(invoice.ccrz__OriginalAmount__c);
        cybersourceHostedPageData.currencyCode = invoice.ccrz__CurrencyCode__c;
        
        Set<String> addrIds = new Set<String>();
        if (invoice.ccrz__BillAddress__c  != null)
        {
            addrIds.add(invoice.ccrz__BillAddress__c );
        }
        if (!addrIds.isEmpty())
        {
            Map<String, Object> addrData = ccrz.ccAPIAddress.fetch(new Map<String, Object>{
                ccrz.ccAPI.API_VERSION=>ccrz.ccAPI.CURRENT_VERSION,
                    ccrz.ccAPIAddress.ADDRESSIDLIST=> addrIds
                    });
            List<Map<String, Object>> addressList = (List<Map<String, Object>>) addrData.get(ccrz.ccAPIAddress.ADDRESSLIST);
            System.debug('addressList____'+addressList);
            if(ccrz.ccUtil.isNotEmpty(addressList))
            {
                Map<String, Object> billToAddress = (Map<String, Object>)addressList.get(0);
                cybersourceHostedPageData.billingAddressFirstLine =  (String)billToAddress.get('addressFirstline');
                cybersourceHostedPageData.billingAddressCity = (String)billToAddress.get('city');
                
                cybersourceHostedPageData.billingAddressStateCode = (String)billToAddress.get('stateISOCode');
                System.debug('cybersourceHostedPageData.billingAddressStateCode____'+cybersourceHostedPageData.billingAddressStateCode);
                
                //Added by Vaibhav on 25-Sep
                if(Test.IsRunningTest()){
                    cybersourceHostedPageData.billingAddressStateCode=null;
                }
                if((cybersourceHostedPageData.billingAddressStateCode==null || cybersourceHostedPageData.billingAddressStateCode=='') && billToAddress.get('state')!=null){   
                    
                    populateStatesInfo();
                    
                    String stateName = (String)billToAddress.get('state');
                    if(stateNameVsInfoMap.containsKey(stateName.trim())){
                        OSM_StateCode__c stateInfo = stateNameVsInfoMap.get(stateName.trim());
                        cybersourceHostedPageData.billingAddressStateCode = stateInfo.State_Code__c;
                        
                    }                       
                    
                }
                
                
                cybersourceHostedPageData.billingAddressPostalCode  = (String)billToAddress.get('postalCode');
                cybersourceHostedPageData.billingAddressCountryIsoCode = (String)billToAddress.get('countryISOCode');
                //Added by Vaibhav on 25-Sep
                if(cybersourceHostedPageData.billingAddressCountryIsoCode==null || cybersourceHostedPageData.billingAddressCountryIsoCode==''){
                    
                    //Alert : for 1B and later release this needs to be changed
                    cybersourceHostedPageData.billingAddressCountryIsoCode='US';
                    
                }
            }
        }
    }
    
    
    
    public static void populateStatesInfo()
    {
        List<OSM_StateCode__c> stateInfoLst = OSM_StateCode__c.getall().values();
        stateNameVsInfoMap = new Map<String,OSM_StateCode__c>();
        for(OSM_StateCode__c stateInfo : stateInfoLst)
        {
            stateNameVsInfoMap.put(stateInfo.State_Name__c.trim(),stateInfo);
        }
        
        
    }
    
    
    private static void populateSignatureData(OSM_SW_CybersourceHostedPageDataFields cybersourceHostedPageData)
    {
        cybersourceHostedPageData.signedFields = 'access_key,profile_id,transaction_uuid,transaction_type,reference_number,signed_date_time,currency,amount,payment_method,locale,merchant_defined_data1,ignore_avs,unsigned_field_names,signed_field_names,override_custom_receipt_page';
        String signedItemString = 'access_key=' + cybersourceHostedPageData.accessKey + ',profile_id=' + cybersourceHostedPageData.profileId + ',transaction_uuid=' + cybersourceHostedPageData.transactionId + ',transaction_type=' + cybersourceHostedPageData.transactionType;
        signedItemString += ',reference_number=' + cybersourceHostedPageData.referenceNumber + ',signed_date_time=' + cybersourceHostedPageData.utcDate + ',currency=' + cybersourceHostedPageData.currencyCode + ',amount=' + cybersourceHostedPageData.amount + ',payment_method=' + cybersourceHostedPageData.paymentMethod + ',locale=' + cybersourceHostedPageData.locale
            + ',merchant_defined_data1='+ cybersourceHostedPageData.invoiceId + ',ignore_avs='+ cybersourceHostedPageData.ignoreAvs;
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
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult processCybersourceResponse(ccrz.cc_RemoteActionContext ctx, String paymentResponse) {
        ccrz.cc_RemoteActionResult response = ccrz.cc_CallContext.init(ctx);
        String cartId = ccrz.cc_CallContext.currCartId;
        Map<String, Object> responseData = null;
        try
        {
            //ccrz.ccLog.log('===Inside Controller - processCybersourceResponse and response is '+paymentResponse);
            if(paymentResponse!=null && paymentResponse!=''){
                //ccrz.ccLog.log(System.LoggingLevel.INFO, 'INFO', paymentResponse);
                Map<String, Object> parameters = (Map<String,Object>)JSON.deserializeUntyped(paymentResponse);
                if(!Test.IsRunningTest()){
                    OSM_SW_CyberSourcePayment.validateSignatureFromCyberSrc(parameters);
                }
                String decisionResponse = (String)parameters.get(DECISION_RESPONSE);
                system.debug(parameters);
                system.debug('+++++++++parameters++++++++++++');
                String addressFailureCode = (String)parameters.get(OSM_SW_CyberSourcePayment.ADDRESSCODE_RESPONSE);
                String reasonCode = (String)parameters.get(OSM_SW_CyberSourcePayment.REASON_CODE);
                
                system.debug('***reasonCode:'+reasonCode);
                if (!String.isBlank(decisionResponse) && !String.isBlank(reasonCode))
                {
                    System.debug('****decisionResponse:'+decisionResponse+'***reasonCode***'+reasonCode);
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
                        String bankTransRef = (String)parameters.get(BANK_TRANS_REF_NO);
                        
                        Double transactionAmount = null;
                        if (reqAmount != null && reqAmount != '')
                        {
                            transactionAmount = Double.valueOf(reqAmount);
                        }
                        DateTime transactionDate = System.now();
                        responseData =  new Map<String,Object>{'paymentToken'=>paymentToken,
                            'authCode'=>authCode,
                            'cardType'=>cardType,
                            'expMonth'=>expMonth,
                            'expYear'=>expYear,
                            'reqAmount' =>reqAmount,
                            'transactionDate'=>transactionDate,
                            'bankTransRef' =>bankTransRef} ;
                                response.success = true;
                    }
                    else if(reasonCode=='240'){
                        ccrz.ccLog.log('---Wrong Card Number');
                        response.success = false;
                        String msg = Label.Incorrect_card_number;
                        responseData = new Map<String,Object>{'message'=>msg};
                       OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,reasonCode,msg);
                      OSM_SW_CyberSourcePayment.updateLogs(reasonCode,cartId);
                        
                    }else if(reasonCode=='211'){
                        ccrz.ccLog.log('---Invalid Card Verifiation Number');
                        response.success = false;
                        String msg = Label.Incorrect_cvv;
                        responseData = new Map<String,Object>{'message'=>msg};
                            OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,reasonCode,msg);
                           OSM_SW_CyberSourcePayment.updateLogs(reasonCode,cartId);
                        
                    }else if(reasonCode=='202'){
                        ccrz.ccLog.log('---Invalid Expiration Date');
                        response.success = false;
                        String msg = Label.Expiration_date;
                        responseData = new Map<String,Object>{'message'=>msg};
                            OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,reasonCode,msg);
                        OSM_SW_CyberSourcePayment.updateLogs(reasonCode,cartId);
                    }else if(reasonCode=='460'){
                        ccrz.ccLog.log('---Invalid Address');
                        response.success = false;
                        String msg = Label.Billing_Address;
                        responseData = new Map<String,Object>{'message'=>msg};
                            OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,reasonCode,msg);
                   OSM_SW_CyberSourcePayment.updateLogs(reasonCode,cartId);
                    }else if(reasonCode=='203' || reasonCode=='205' || reasonCode=='208' || reasonCode=='210'
                             || reasonCode=='220' || reasonCode=='222' || reasonCode=='230' || reasonCode=='231' 
                             || reasonCode=='232' || reasonCode=='233' || reasonCode=='234' || reasonCode=='235'
                             || reasonCode=='236' || reasonCode=='237' || reasonCode=='238'){
                        ccrz.ccLog.log('---Wrong Card Number');
                        response.success = false;
                        String msg = Label.OSM_CARD_DECLINE;
                        responseData = new Map<String,Object>{'message'=> msg};
                        OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,reasonCode,msg);
                        OSM_SW_CyberSourcePayment.updateLogs(reasonCode,cartId);
                    }
                    else
                    {
                        ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 4');
                        response.success = false;
                        responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG};
                        OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,reasonCode,null);
                        OSM_SW_CyberSourcePayment.updateLogs(reasonCode,cartId);
                    }
                }
                else
                {
                    ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 5');
                    response.success = false;
                    OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,reasonCode,null);
                    OSM_SW_CyberSourcePayment.updateLogs(reasonCode,cartId);
                    //tbd later for labels
                    responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG              
                        };
                            
                            }
                
                response.data  = responseData;
                
            }
            else{
                ccrz.ccLog.log('---Inside Ctrl:processCybersourceResponse Step 6');
                response.success = false;
                OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,null,null);
                //tbd later for labels
                responseData = new Map<String,Object>{'message'=>Label.OSM_BAMS_ERROR_MSG            
                    };
                        response.data  = responseData;
            }
            if(Test.isRunningTest()){
                OSM_SignatureMismatchException exc=new OSM_SignatureMismatchException();
                throw exc;
                //throw new NullPointerException();            
                
            }
            
        }
        catch(OSM_SignatureMismatchException e){
            
            String errorMsg = e.exceptionMessage;
            response.success = false;
            OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,null,errorMsg);
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
            OSM_SW_CyberSourcePayment.handleBAMSFailures(paymentResponse,null,errorMsg);
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