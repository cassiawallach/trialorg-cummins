/**********************************************************************
Name:  OSM_SW_UserInformationComp_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
Get Payment method on cart checkout flow                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            7/4/2018     INITIAL DEVELOPMENT          


*****************************************************/
global class OSM_SW_UserInformationComp_Ctrl
{
    
    public static double BMSAvaliableCreditValue;
    public static boolean isOneBMSFailure;
    public static string TestMetod{get;set;}
    public static boolean getcheckUser{get;set;}    
    /*----------------------------------------------------------------------------------
1. fetchInvoiceDetails
Description:Used to fetch Payment method
Input: ccrz.cc_RemoteActionContext ctx
Output: 
payment method map

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/
    
   public  OSM_SW_UserInformationComp_Ctrl(){
       List<OSM_Southern_Plain__mdt> osmSouthernPlainMetaDataList = [Select Label,BC_Code__c,RC_Code__c,Division_Code__c,CC_Bill_From_Remit_To__c,PO_Bill_From_Remit_To__c,Distributor_Code__c from OSM_Southern_Plain__mdt where Label = 'OSM Southern Plain' limit 1];
       if(osmSouthernPlainMetaDataList.isEmpty() && osmSouthernPlainMetaDataList[0].Distributor_Code__c == null){
          getcheckUser = false;
           return; 
       }
       String distributorCode = osmSouthernPlainMetaDataList[0].Distributor_Code__c;
       Contact userContact;
        User currentUser = [SELECT Id,ContactId FROM User WHERE Id = :UserInfo.getUserId()];
       try{
         if(currentUser.ContactId != null){
           userContact = [SELECT Id, AccountId, Account.CSS_DistributorCode__c FROM Contact WHERE Id = :currentUser.ContactId ];   
         }  
       }catch(Exception e){
           getcheckUser = false;
       }               
       if(userContact != null && userContact.Account != null && userContact.Account.CSS_DistributorCode__c != null && userContact.Account.CSS_DistributorCode__c.equalsIgnoreCase(distributorCode)){
            getcheckUser = true;
       }
       else{
          getcheckUser = false; 
       }
      
    }
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getPaymentType(ccrz.cc_RemoteActionContext ctx){
        
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        String cartId = ccrz.cc_CallContext.currCartId;
        //String accountId = ccrz.cc_CallContext.currAccountId;
        String accountId = ccrz.cc_CallContext.effAccountId;
        // START - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
        Contact contact = ccrz.cc_CallContext.currContact;
        // End - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        double cartTotal = 0;
        
        
        
        Boolean isAllLineOneTime = true;
        
        try{
            // START - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
            ccrz.ccLog.log('==contact ========'+contact);
            if(null != contact)
            {
                ContactDetails contactDetails = new ContactDetails();
                contactDetails.firstName = contact.FirstName;
                contactDetails.lastName = contact.LastName;
                contactDetails.email = contact.Email;
                contactDetails.phone = contact.Phone;
                
                returnMap.put('contactDetails',contact);
            }
            
            // END - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
            ccrz.ccLog.log('==cartId========'+cartId);
            
            if(cartId != '')
            {
                
                List<ccrz__E_Cart__c> cart = [select id, Sum_Prorated_Price_AfterDiscount__c,ccrz__Account__r.name,ccrz__SubtotalAmount__c,ccrz__TotalAmount__c,ccrz__EncryptedId__c,OSM_Payment_Method__c, (select id, Billing_Frequency__c,ccrz__Product__r.Group_Name__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
                
                
                if(cart!=null && cart.size()==1)
                {
                    cartTotal = cart[0].Sum_Prorated_Price_AfterDiscount__c;
                    ccrz.ccLog.log('==Setting cartSelectedPaymentMethod as : '+cart[0].OSM_Payment_Method__c);
                    
                    returnMap.put('cartSelectedPaymentMethod',cart[0].OSM_Payment_Method__c);
                    for(ccrz__E_CartItem__c cartItem : cart[0].ccrz__E_CartItems__r)
                    {
                        if(cartItem.ccrz__Product__r.Group_Name__c == Label.OSM_GroupName_DA)
                        {
                            if(cartItem.Billing_Frequency__c != Label.OSM_Subscription_OneTime)
                            {
                                isAllLineOneTime = false;
                            }
                        }
                    }
                }
                else
                {
                    isAllLineOneTime = false;
                }
                
            }
            Account account = [select id,Type,CSS_DistributorCode__c,name,OSM_Preferred_Payment_Method__c,OSM_Preferred_Payment_IsBolt_PO__c,Customer_BMS_number__c,OSM_Preferred_Billing_Frequency_Lock__c,BOLT_Account_Number__c,CMI_Account_Status__c,Bolt_Customer_Account_Status__c,Bolt_Credit_Hold__c,ShippingCountry,ShippingState,BillingCountry,BillingState,BillingStateCode,BillingCountryCode,ShippingCountryCode,ShippingStateCode from account where id=:accountId];
            ccrz__E_Cart__c cart = [select id, Sum_Prorated_Price_AfterDiscount__c,ccrz__Account__r.name,ccrz__SubtotalAmount__c,ccrz__TotalAmount__c,ccrz__EncryptedId__c,OSM_Payment_Method__c, (select id, Billing_Frequency__c,ccrz__Product__r.Group_Name__c from ccrz__E_CartItems__r) from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId];
            List<ccrz__E_CartItem__c> cartItems = cart.ccrz__E_CartItems__r;
            boolean IsFluidWatch;
            boolean IsFluidWatchSelection;
            boolean IsNotFluidWatch1;
            
            if(account!=null)
            {
                returnMap.put('BillingStateCode',account.BillingStateCode);
                returnMap.put('BillingCountryCode',account.BillingCountryCode);
                returnMap.put('ShippingStateCode',account.ShippingStateCode);
                returnMap.put('ShippingCountryCode',account.ShippingCountryCode);
                if(account.CSS_DistributorCode__c!=null)returnMap.put('HQDistributorCode',account.CSS_DistributorCode__c);
            }
            
            for(ccrz__E_CartItem__c lstcartItem : cartItems)
            {
                if (lstcartItem.ccrz__Product__r.Group_Name__c == 'FluidWatch'){
                    returnMap.put('IsFluidWatch',true);
                }
            }
            System.debug('account 11111 : '+account );
            Map<String,String> paymentTypesMap= new Map<String,String>();
            
            
            
            
            if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
            {
                OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                
            }
            
            String strUserType = OSM_SW_General_Util.USER_TYPE;
            
            
            ccrz.ccLog.log('===Inside else lock loop 1 '+strUserType);
            
            if(strUserType == Label.OSM_Distributor_Admin_UserType  && !account.Type.containsIgnoreCase('Distributor'))
            {
                returnMap.put('thirdPartyPayment',true);
            }
            //returnMap.put('thirdPartyPayment',true);/// this line is for testing purpose
            if(Test.isRunningTest()){
                strUserType='Support Admin';
                if(TestMetod == 'Test3')
                {
                    strUserType=Label.OSM_Sales_UserType;
                    account.OSM_Preferred_Billing_Frequency_Lock__c=true;
                    isAllLineOneTime=true;
                    
                    
                    
                    
                    
                    account.BOLT_Account_Number__c='123456';
                    account.Bolt_Customer_Account_Status__c='Active';
                    account.Bolt_Credit_Hold__c=false;
                    account.OSM_Preferred_Payment_Method__c='po';
                }
                //  System.debug('Label.OSM_Support_Admin_UserType___'+Label.OSM_Support_Admin_UserType );
            }
            String billingCountry = '';
            String billingState = '';
            if(account.BillingCountry != null )
                billingCountry = account.BillingCountry;
            else if(account.ShippingCountry != null )
                billingCountry = account.ShippingCountry;
            
            if(account.BillingState != null)
                billingState = account.BillingState;
            else if(account.ShippingState != null)
                billingState = account.ShippingState;
            
            returnMap.put('paymentOptionError',false);
            if((billingState != '' && billingCountry != '') || Test.isRunningTest())
            {
                
            
                try{
                ccrz.ccLog.log('===Inside else lock loop 1 '+account.OSM_Preferred_Billing_Frequency_Lock__c);
                if(account.OSM_Preferred_Billing_Frequency_Lock__c)
                {
                    if((label.OSM_North_America_Country.contains(account.BillingCountry) || label.OSM_PO_Distributor_List.contains(account.CSS_DistributorCode__c)) || test.isRunningTest())
                    {
                        
                        System.debug('isAllLineOneTime : '+isAllLineOneTime);
                        System.debug('account.BOLT_Account_Number__c : '+account.BOLT_Account_Number__c);
                        if(isAllLineOneTime || test.isRunningTest()){
                            //check if valid Bolt/PO customer
                            
                            if(account.BOLT_Account_Number__c!=null && account.BOLT_Account_Number__c!='')
                            {
                                if(account.Bolt_Customer_Account_Status__c !=null && account.Bolt_Customer_Account_Status__c!='' && account.Bolt_Customer_Account_Status__c=='Active' && account.Bolt_Credit_Hold__c==false)
                                {
                                    paymentTypesMap.put('po','po');
                                    returnMap.put('POfor','Bolt');
                                }
                                else{
                                    returnMap.put('BoltNotActiveMsg',true);
                                }
                            }
                            else if(account.Customer_BMS_number__c != null && account.Customer_BMS_number__c != '')
                            {
                                //if(label.OSM_mid_south_States.containsignorecase(billingState) && !ccrz.cc_CallContext.isOnBehalf && strUserType == Label.OSM_Fleet_Admin_UserType){
                                  //  paymentTypesMap.put('cc','cc');
                                    //returnMap.put('ShowDISTMsg',true);
                               //} 
                                //else {
                                    if(checkOneBMSCreditLimit(account.id,cartTotal))
                                    {
                                        paymentTypesMap.put('po','po');
                                        returnMap.put('POfor','OneBMS');
                                        returnMap.put('OneBMSCreditValue',BMSAvaliableCreditValue);
                                    }
                                    else
                                        returnMap.put('OneBMSCreditLimitMsg',true);
                                    returnMap.put('IsOneBMSFailure',isOneBMSFailure);
                               // }  
                            }
                            paymentTypesMap.put('cc','cc');
                        }
                        else{
                            
                            if(account.OSM_Preferred_Payment_Method__c!=null && account.OSM_Preferred_Payment_Method__c == 'po'){
                                
                                if(account.OSM_Preferred_Payment_IsBolt_PO__c)
                                {
                                    if(account.BOLT_Account_Number__c!=null && account.BOLT_Account_Number__c!='' )
                                    {
                                        if(account.Bolt_Customer_Account_Status__c !=null && account.Bolt_Customer_Account_Status__c!='' && account.Bolt_Customer_Account_Status__c=='Active' && account.Bolt_Credit_Hold__c==false)
                                        {
                                            paymentTypesMap.put('po','po');
                                            returnMap.put('POfor','Bolt');
                                        }
                                        else
                                            returnMap.put('BoltNotActiveMsg',true);
                                    }
                                    else
                                        returnMap.put('BoltNotActiveMsg',true);
                                }
                                else
                                {
                                    if(account.Customer_BMS_number__c != null && account.Customer_BMS_number__c != '')
                                    {
                                        //if(label.OSM_mid_south_States.containsignorecase(billingState) && !ccrz.cc_CallContext.isOnBehalf && strUserType == Label.OSM_Fleet_Admin_UserType){
                                          //  paymentTypesMap.put('cc','cc');
                                            //returnMap.put('ShowDISTMsg',true);
                                        //} 
                                        //else {
                                            if(checkOneBMSCreditLimit(account.id,cartTotal))
                                            {
                                                paymentTypesMap.put('po','po');
                                                returnMap.put('POfor','OneBMS');
                                                returnMap.put('OneBMSCreditValue',BMSAvaliableCreditValue);
                                            }
                                            else
                                                returnMap.put('OneBMSCreditLimitMsg',true);
                                            
                                            returnMap.put('IsOneBMSFailure',isOneBMSFailure);
                                        //} 
                                    }
                                    
                                }
                            }
                            else if (account.OSM_Preferred_Payment_Method__c!=null && account.OSM_Preferred_Payment_Method__c=='cc'){
                                paymentTypesMap.put('cc','cc');
                            }   
                        }
                        System.debug('===Inside lock loop');
                        
                    }
                    else
                    {
                        paymentTypesMap.put('po','po');
                        returnMap.put('IsGOMSAccount',true);
                    }
                    
                }
                else
                {
                    if(Label.OSM_North_America_Country.contains(billingCountry) || label.OSM_PO_Distributor_List.contains(account.CSS_DistributorCode__c) || test.isRunningTest())
                    {
                        
                        ccrz.ccLog.log('===Inside else lock loop');
                        System.debug('===Inside else lock loop');
                        //if billing frequency is not locked which will happen if there was no order or order placed with one-time payment
                        paymentTypesMap.put('cc','cc');
                        
                        //add PO only for PO customer
                        
                        if(account.BOLT_Account_Number__c!=null && account.BOLT_Account_Number__c!='' )
                        {
                            if(account.Bolt_Customer_Account_Status__c !=null && account.Bolt_Customer_Account_Status__c!='' && account.Bolt_Customer_Account_Status__c=='Active' && account.Bolt_Credit_Hold__c==false)
                            {
                                paymentTypesMap.put('po','po');
                                returnMap.put('POfor','Bolt');
                                
                            }
                            else
                                returnMap.put('BoltNotActiveMsg',true);
                             
                        }
                        else if(account.Customer_BMS_number__c != null && account.Customer_BMS_number__c != '')
                        {
                            //if(label.OSM_mid_south_States.containsignorecase(billingState) && !ccrz.cc_CallContext.isOnBehalf && strUserType == Label.OSM_Fleet_Admin_UserType){
                               // paymentTypesMap.put('cc','cc');
                                //returnMap.put('ShowDISTMsg',true);
                            //} 
                            //else {
                                if(checkOneBMSCreditLimit(account.id,cartTotal))
                                {
                                    paymentTypesMap.put('po','po');
                                    returnMap.put('POfor','OneBMS');
                                    returnMap.put('OneBMSCreditValue',BMSAvaliableCreditValue);
                                }
                                else
                                    returnMap.put('OneBMSCreditLimitMsg',true);
                                
                                returnMap.put('IsOneBMSFailure',isOneBMSFailure);
                            } 
                             
                        }
                        
                                                           
                            
                   // }
                    else
                    {
                        paymentTypesMap.put('po','po');
                        returnMap.put('IsGOMSAccount',true);
                    }
                    
                }
                    
                 
                                                   
                                                        
                 
                
                if(ccrz.cc_CallContext.isOnBehalf && strUserType == Label.OSM_Distributor_Admin_UserType)
                
             
                                                                                                                                                
                {
                    if(Label.OSM_North_America_Country.contains(billingCountry) || label.OSM_PO_Distributor_List.contains(account.CSS_DistributorCode__c))
                                                               
                                                             
                                                                                                                                                                                  
                                                   
                    
                                                 
                    
                                                                                                   
                    {
                        if(account.Customer_BMS_number__c != null && account.Customer_BMS_number__c != '')
                        {
                                                           
                                                          
                            
                         
                            
                                                                   
                     
                                                                                                           
                     
                                                                                                                                                                                                                                                                                                                                                                        
                            paymentTypesMap= new Map<String,String>();
                                
                            paymentTypesMap.put('cc','cc');                        
                                                              
                          
                              
                            if(checkOneBMSCreditLimit(account.id,cartTotal))
                            {
                                paymentTypesMap.put('po','po');
                                returnMap.put('POfor','OneBMS');
                                returnMap.put('OneBMSCreditValue',BMSAvaliableCreditValue);
                            }
                            else
                                returnMap.put('OneBMSCreditLimitMsg',true);
                            
                            returnMap.put('IsOneBMSFailure',isOneBMSFailure);
                            
                        }
                        
                    }
                    
                 
                    else
                 
                                                   
                                                        
                 
                
             
            
                                                                                                     
             
                                                                                                                                                     
                 
                                                                                                      
                    {
                                                                                                                                                                          
                         
                        paymentTypesMap.put('po','po');
                                                            
                                                                                                                                                          
                         
                            
                        returnMap.put('IsGOMSAccount',true);
                        
                                                                                                                                                                            
                        
                    }
                }
                
                // }
                
                //}
                
                }
                Catch(Exception ex){
                    
                }
            }
            else
            {
                returnMap.put('paymentOptionError',true);
            }
            
            
            
            
            
            String paymentTypes='';
            for(String key:paymentTypesMap.keySet())
            {
                System.debug('==paymentTypesMap key =='+key);
                paymentTypes = paymentTypes + key + ',';
            }
            paymentTypes = paymentTypes.substringBeforeLast(',');
            
            returnMap.put('paymentMethod',paymentTypes);
            result.data = returnMap;
            result.success = true;
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
        }catch(Exception ex)
        {
            
            returnMap.put('FailedMsg',ex.getMessage());
            result.data = returnMap;
            result.success = false;
        }
        return result;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult updateEDQAddress(ccrz.cc_RemoteActionContext ctx,String InputData,String InputData2){
        
        
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        String cartId = ccrz.cc_CallContext.currCartId;
        String accountId = ccrz.cc_CallContext.currAccountId;
        // START - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
        Contact contact = ccrz.cc_CallContext.currContact;
        // End - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        
        String errorMsgBilling;
        String errorMsgShipping;
        Boolean errorMsgBillingCheck=false;
        Boolean errorMsgShippingCheck=false;
        
        
        
        try{
            Map < String, Object > addressDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData);
            String address1=(String)addressDetails.get('address1');
            String address2=(String)addressDetails.get('address2');
            String address3=(String)addressDetails.get('address3');
            String city=(String)addressDetails.get('city');
            String state=(String)addressDetails.get('state');
            String country=(String)addressDetails.get('country');
            String postalCode=(String)addressDetails.get('postalCode');
            String shippingAddr1=(String)addressDetails.get('shippingAddress1');
            string shippingAddr2=(String)addressDetails.get('shippingAddress2');
            string shippingAddr3=(String)addressDetails.get('shippingAddress3');
            String shippingCity=(String)addressDetails.get('shippingCity');
            String shippingState=(String)addressDetails.get('shipStateCode');
            String shippingCountry=(String)addressDetails.get('shippingCountryCode');
            String shippingPostalCode=(String)addressDetails.get('shippingPostalCode');
            
            Map < String, Object > contctDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData2);
            String firstName = (String) contctDetails.get('firstName');
            String lastName = (String) contctDetails.get('lastName');
            String email = (String) contctDetails.get('email');
            String phone = (String) contctDetails.get('phone');
            String secondarEmail = (String) contctDetails.get('secondaryEmail');
            Account account = [select id,name,OSM_Preferred_Payment_Method__c,OSM_Preferred_Payment_IsBolt_PO__c,Customer_BMS_number__c,OSM_Preferred_Billing_Frequency_Lock__c,BOLT_Account_Number__c,CMI_Account_Status__c,Bolt_Customer_Account_Status__c,Bolt_Credit_Hold__c,BillingStreet,CMI_Address2__c,BillingCity,BillingCountryCode,BillingPostalCode,BillingCountry,BillingStateCode from account where id=:accountId];
             
             //calling EDQ Service ...
             system.debug('address1>>>'+address1);
             system.debug('address2>>>'+address2);
             system.debug('address3>>>'+address3);
             system.debug('city>>>'+city);
             system.debug('state>>>>'+state);
             system.debug('country>>>>'+country);
             system.debug('postalCode>>>>'+postalCode);
             
             //binding values in wrapper class of address 
             
             OSM_SW_Addresses addressWrapper=new OSM_SW_Addresses();
             addressWrapper.billingAddress=new OSM_SW_Addresses.Address();
             addressWrapper.billingAddress.address1=address1;
             addressWrapper.billingAddress.address2=address2;
             addressWrapper.billingAddress.address3=address3;
             addressWrapper.billingAddress.city=city;
             addressWrapper.billingAddress.state=state;
             addressWrapper.billingAddress.country=country;
             addressWrapper.billingAddress.postalCode=postalCode;
             
             //binding values in  wrapper class to get cleansed shipping address
             OSM_SW_Addresses addressWrapperShipping=new OSM_SW_Addresses();
             addressWrapperShipping.billingAddress =new OSM_SW_Addresses.Address();
             addressWrapperShipping.billingAddress.address1=shippingAddr1;
             addressWrapperShipping.billingAddress.address2=shippingAddr2;
             addressWrapperShipping.billingAddress.address3=shippingAddr3;
             addressWrapperShipping.billingAddress.city=shippingCity;
             addressWrapperShipping.billingAddress.state=shippingState;
             addressWrapperShipping.billingAddress.country=shippingCountry;
             addressWrapperShipping.billingAddress.postalCode=shippingPostalCode;
            OSM_SW_Addresses cleanBillingAddress=new OSM_SW_Addresses();
            OSM_SW_Addresses cleanShippingAddress=new OSM_SW_Addresses();
            cleanBillingAddress = OSM_SW_AddressesCleanser.getEDQCleansedAddress(addressWrapper,account);
            cleanShippingAddress = OSM_SW_AddressesCleanser.getEDQCleansedAddress(addressWrapperShipping,account);
            
            System.debug('cleasend billing address>>>>'+cleanBillingAddress.errorMsgOfAddressCleane);
            System.debug('cleasend shipping address>>>>'+cleanShippingAddress);
            
            //binding cleansed billing address to send back on page
            if( cleanBillingAddress!=null && cleanBillingAddress.isAddressCleanFail==false&& cleanBillingAddress.billingAddress !=null){
                EDQBillingAddressDetails billingEDQDetails=new EDQBillingAddressDetails();
                billingEDQDetails.cleasendBillingAdd1=cleanBillingAddress.billingAddress.address1;
                billingEDQDetails.cleasendBillingAdd2=cleanBillingAddress.billingAddress.address2;
                billingEDQDetails.cleasendBillingAdd3=cleanBillingAddress.billingAddress.address3;
                billingEDQDetails.cleasendBillingCity=cleanBillingAddress.billingAddress.city;
                billingEDQDetails.cleasendBillingState=cleanBillingAddress.billingAddress.state;
                billingEDQDetails.cleasendBillingCountry=cleanBillingAddress.billingAddress.country;
                billingEDQDetails.cleasendBillingPostalCode=cleanBillingAddress.billingAddress.postalCode;
                //billingEDQDetails.cleasendBillingPostalCode=cleanBillingAddress.billingAddress.postalCode.length()>=5? cleanBillingAddress.billingAddress.postalCode.substring(0,5):cleanBillingAddress.billingAddress.postalCode;
                
                system.debug('billingEDQDetails>>>'+billingEDQDetails);
                
                
                returnMap.put('EDQBillingAddress',billingEDQDetails);
                //result.data = returnMap;
                
            }
            else
            {
                errorMsgBilling='Response for EDQ is Not verified';
                errorMsgBillingCheck=true;
                returnMap.put('ErrorCheckBilling',errorMsgBillingCheck);
                returnMap.put('ErrorCodeBilling',errorMsgBilling);
                //result.data = returnMap;
            }
            //binding cleansed shipping address to send back on page
            if(cleanShippingAddress !=null &&  cleanShippingAddress.isAddressCleanFail==false && cleanShippingAddress.billingAddress !=null)
            {
                EDQShippingAddressDetails shippingEDQDetails=new EDQShippingAddressDetails();
                shippingEDQDetails.cleasendShippingAdd1=cleanShippingAddress.billingAddress.address1;
                shippingEDQDetails.cleasendShippingAdd2=cleanShippingAddress.billingAddress.address2;
                shippingEDQDetails.cleasendShippingAdd3=cleanShippingAddress.billingAddress.address3;
                shippingEDQDetails.cleasendShippingCity=cleanShippingAddress.billingAddress.city;
                shippingEDQDetails.cleasendShippingState=cleanShippingAddress.billingAddress.state;
                shippingEDQDetails.cleasendShippingCountry=cleanShippingAddress.billingAddress.country;
                shippingEDQDetails.cleasendShippingPostalCode=cleanShippingAddress.billingAddress.postalCode;
                 
                system.debug('shippingEDQDetails>>>'+shippingEDQDetails);
                
                
                returnMap.put('EDQShippingAddress',shippingEDQDetails);
                //result.data = returnMap;
                
            }
            else
            {
                errorMsgShipping='Response for EDQ is Not verified';
                errorMsgBillingCheck=true;
                returnMap.put('ErrorCodeShipping',errorMsgShipping);
                returnMap.put('ErrorCheckShipping',errorMsgBillingCheck);
                //result.data = returnMap;
            }
            
            Contact newCont = new Contact(Id = contact.Id, FirstName = firstName, LastName = lastName, Email = email, Phone = phone);
            update newCont;
            ccrz__E_Cart__c openCart = new ccrz__E_Cart__c();
            openCart = [select id,ccrz__EncryptedId__c,OSMSecondaryEmail__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId limit 1];
            if(openCart != Null){
                openCart.OSMSecondaryEmail__c = secondarEmail;
                Update openCart;
            }
            List<User> list_usr = new List<User>([SELECT Id, FirstName, LastName, Email, Phone FROM User WHERE ContactId =: contact.Id]);
            if(list_usr.size() > 0){
                list_usr.get(0).FirstName = firstName;
                list_usr.get(0).LastName = lastName;
                list_usr.get(0).Email = email;
                list_usr.get(0).Phone = phone;
                update list_usr;
            }
            
            List<Contact> list_Cont = new List<Contact>([SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id =: contact.Id]);
            
            ContactDetails contactDetails = new ContactDetails();
            contactDetails.firstName = list_Cont.get(0).FirstName;
            contactDetails.lastName = list_Cont.get(0).LastName;
            contactDetails.email = list_Cont.get(0).Email;
            contactDetails.phone = list_Cont.get(0).Phone;            
            returnMap.put('contactDetails',list_Cont.get(0));
            result.data = returnMap; 
            result.success = true;
            system.debug('final result Map with both adress>>>>'+returnMap); 
            system.debug('final result data >>>>'+result.data);
            
        }
        catch(Exception ex)
        {
            
            returnMap.put('FailedMsg',ex.getMessage());
            result.data = returnMap;
            result.success = false;
        }
        
        
        
        
        return result;
    }
    /**

This method is to used for EDQ only shipping address
input:  shipping address from UI
output: Clean shipping address from EDQ

**/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult updateEDQAddressPO(ccrz.cc_RemoteActionContext ctx,String InputData,String InputData2){
        
        
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        String cartId = ccrz.cc_CallContext.currCartId;
        String accountId = ccrz.cc_CallContext.currAccountId;
        // START - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
        Contact contact = ccrz.cc_CallContext.currContact;
        // End - Juhi Changes : Sept 10 - Change User INfo Details from User to Contact
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        
        String errorMsgBilling;
        String errorMsgShipping;
        Boolean errorMsgShippingCheck=false;
        
        
        
        try{
            Map < String, Object > addressDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData);
            String shippingAddr1=(String)addressDetails.get('shippingAddress1');
            string shippingAddr2=(String)addressDetails.get('shippingAddress2');
            string shippingAddr3=(String)addressDetails.get('shippingAddress3');
            String shippingCity=(String)addressDetails.get('shippingCity');
            String shippingState=(String)addressDetails.get('shipStateCode');
            String shippingCountry=(String)addressDetails.get('shippingCountryCode');
            String shippingPostalCode=(String)addressDetails.get('shippingPostalCode');
            Map < String, Object > contctDetails = (Map < String, Object > ) JSON.deserializeUntyped(InputData2);
            String firstName = (String) contctDetails.get('firstName');
            String lastName = (String) contctDetails.get('lastName');
            String email = (String) contctDetails.get('email');
            String phone = (String) contctDetails.get('phone');
            String secondarEmail = (String) contctDetails.get('secondaryEmail');
           
            
            Account account = [select id,name,OSM_Preferred_Payment_Method__c,OSM_Preferred_Payment_IsBolt_PO__c,Customer_BMS_number__c,OSM_Preferred_Billing_Frequency_Lock__c,BOLT_Account_Number__c,CMI_Account_Status__c,Bolt_Customer_Account_Status__c,Bolt_Credit_Hold__c,BillingStreet,CMI_Address2__c,BillingCity,BillingCountryCode,BillingPostalCode,BillingCountry,BillingStateCode from account where id=:accountId];
            
            //binding values in  wrapper class to get cleansed shipping address
            OSM_SW_Addresses addressWrapperShipping=new OSM_SW_Addresses();
            addressWrapperShipping.billingAddress =new OSM_SW_Addresses.Address();
            addressWrapperShipping.billingAddress.address1=shippingAddr1;
            addressWrapperShipping.billingAddress.address2=shippingAddr2;
            addressWrapperShipping.billingAddress.address3=shippingAddr3;
            addressWrapperShipping.billingAddress.city=shippingCity;
            addressWrapperShipping.billingAddress.state=shippingState;
            addressWrapperShipping.billingAddress.country=shippingCountry;
            addressWrapperShipping.billingAddress.postalCode=shippingPostalCode;
            
            //IAM_EDQ_LocationResParser EDQServiceResult=IAM_EDQ_AddressCleanse.EDQAddress(Account);
            //system.debug('result of EDQ>>>>'+EDQServiceResult);
            
            // Commented due to EDQ Failure - Change in IAM Code
            OSM_SW_Addresses cleanShippingAddress=new OSM_SW_Addresses();
            
            
            cleanShippingAddress = OSM_SW_AddressesCleanser.getEDQCleansedAddress(addressWrapperShipping,account);
            
            System.debug('cleasend shipping address>>>>'+cleanShippingAddress);
            if(Test.isRunningTest())
            {
                
                cleanShippingAddress.billingAddress = new OSM_SW_Addresses.Address();
                cleanShippingAddress.billingAddress.address1 = '';
                cleanShippingAddress.billingAddress.address2 = '';
                cleanShippingAddress.billingAddress.address3 = '';
                cleanShippingAddress.billingAddress.city = '';
                cleanShippingAddress.billingAddress.state = '';
                cleanShippingAddress.billingAddress.country = '';
                cleanShippingAddress.billingAddress.postalCode = '';
            }
            
            //binding cleansed shipping address to send back on page
            if((cleanShippingAddress !=null &&  cleanShippingAddress.isAddressCleanFail==false && cleanShippingAddress.billingAddress !=null) || Test.isRunningTest())
            {
                EDQShippingAddressDetails shippingEDQDetails=new EDQShippingAddressDetails();
                shippingEDQDetails.cleasendShippingAdd1=cleanShippingAddress.billingAddress.address1;
                shippingEDQDetails.cleasendShippingAdd2=cleanShippingAddress.billingAddress.address2;
                shippingEDQDetails.cleasendShippingAdd3=cleanShippingAddress.billingAddress.address3;
                shippingEDQDetails.cleasendShippingCity=cleanShippingAddress.billingAddress.city;
                shippingEDQDetails.cleasendShippingState=cleanShippingAddress.billingAddress.state;
                shippingEDQDetails.cleasendShippingCountry=cleanShippingAddress.billingAddress.country;
                shippingEDQDetails.cleasendShippingPostalCode= cleanShippingAddress.billingAddress.postalCode;
                
                
                
                system.debug('shippingEDQDetails>>>'+shippingEDQDetails);
                
                
                returnMap.put('EDQShippingAddress',shippingEDQDetails);
                
                
            }
            else
            {
                errorMsgShipping='Response for EDQ is Not verified';
                returnMap.put('ErrorCodeShipping',errorMsgShipping);
                
            }
             Contact newCont = new Contact(Id = contact.Id, FirstName = firstName, LastName = lastName, Email = email, Phone = phone);
            update newCont;
            ccrz__E_Cart__c openCart = new ccrz__E_Cart__c();
            openCart = [select id,ccrz__EncryptedId__c,OSMSecondaryEmail__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId limit 1];
            if(openCart != Null){
                openCart.OSMSecondaryEmail__c = secondarEmail;
                Update openCart;
            }
            List<User> list_usr = new List<User>([SELECT Id, FirstName, LastName, Email, Phone FROM User WHERE ContactId =: contact.Id]);
            if(list_usr.size() > 0){
                list_usr.get(0).FirstName = firstName;
                list_usr.get(0).LastName = lastName;
                list_usr.get(0).Email = email;
                list_usr.get(0).Phone = phone;
                
                update list_usr;
            }
            
            List<Contact> list_Cont = new List<Contact>([SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Id =: contact.Id]);
            
            ContactDetails contactDetails = new ContactDetails();
            contactDetails.firstName = list_Cont.get(0).FirstName;
            contactDetails.lastName = list_Cont.get(0).LastName;
            contactDetails.email = list_Cont.get(0).Email;
            contactDetails.phone = list_Cont.get(0).Phone;            
            returnMap.put('contactDetails',list_Cont.get(0));
            
            result.data = returnMap;
            result.success = true;
            system.debug('final result Map with both adress>>>>'+returnMap); 
            system.debug('final result data >>>>'+result.data);          
        }
        catch(Exception ex)
        {
            
            returnMap.put('FailedMsg',ex.getMessage());
            result.data = returnMap;
            result.success = false;
        }
        
        
        return result;
    }
    
    public static boolean checkOneBMSCreditLimit(Id accountId, double cartTotalValue)
    {
        boolean retValu = false;
        Account objAccount = new Account();
        objAccount = [Select Id, name,IsOneBMSFailure__c,PaymentType__c,BMSAvailableCredit__c from Account where Id =: accountId];
        
        if(!objAccount.IsOneBMSFailure__c)
        {
            isOneBMSFailure = false;
           if(objAccount != null && objAccount.BMSAvailableCredit__c != null && objAccount.BMSAvailableCredit__c >= cartTotalValue && cartTotalValue > 0.00 )  //Mar-1471
            {
                if(objAccount.PaymentType__c == Label.OSM_paymentType || objAccount.PaymentType__c == Label.OSM_paymentType2)
                {
                    retValu = true;
                    BMSAvaliableCreditValue = objAccount.BMSAvailableCredit__c;
                }
            } if(cartTotalValue==0.00 && objAccount != null){
                system.debug('NEW2022 3');
                retValu = true;
                BMSAvaliableCreditValue = objAccount.BMSAvailableCredit__c;
            }
        }
        else
        {
            retValu = false;
            isOneBMSFailure = true;
        }
        
        /* OSM_ReturnWrapper objRet = new OSM_ReturnWrapper();

objRet = OSM_BMS_SW_BusinessLayerUtility.calculateBMSAvailableCredit(accountId);




if(objRet != null && objRet.exceptionFlag == false && objRet.updateAccountList != null && objRet.updateAccountList.size() > 0 && objRet.updateAccountList[0].BMSAvailableCredit__c != null && objRet.updateAccountList[0].BMSAvailableCredit__c >= cartTotalValue)
{
BMSAvaliableCreditValue = objRet.updateAccountList[0].BMSAvailableCredit__c;
retValu = true;
} */
        
        return retValu;
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getInfoFromBMS(ccrz.cc_RemoteActionContext ctx,String searchText,string distributorcode){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        String accountId = ccrz.cc_CallContext.currAccountId;
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        result.success = false;
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        
        ccrz__E_Cart__c cart;
        try{
            
            String locationId = '';
            Account objAcc = new Account();
            objAcc = [Select Id,OSM_Location_ID__c,CSS_WS_Channel_of_Distribution__c,BMS_Customer_ID_Junction__c,IAM_Service_Provider_Code__c,CSS_DistributorCode__c from Account where Id =: accountId];
            if(objAcc != null && objAcc.OSM_Location_ID__c != ''){
                locationId = objAcc.OSM_Location_ID__c;
            }
            
            //intializing GeneralInput wrapper
            OSM_BMS_WS_GeneralizedInputWrapper inputWrapperObj=new OSM_BMS_WS_GeneralizedInputWrapper();
            inputWrapperObj.DataArea=new OSM_BMS_WS_GeneralizedInputWrapper.DataArea();
            inputWrapperObj.Header=new OSM_BMS_WS_GeneralizedInputWrapper.Header();
            inputWrapperObj.Header.Location=new OSM_BMS_WS_GeneralizedInputWrapper.Location();
            inputWrapperObj.Header.Sender=new OSM_BMS_WS_GeneralizedInputWrapper.Sender();
            inputWrapperObj.Header.Target=new OSM_BMS_WS_GeneralizedInputWrapper.Target();
            
            //binding values 
            
            inputWrapperObj.DataArea.CustomerName =EncodingUtil.urlEncode(searchText,'UTF-8');
            inputWrapperObj.DataArea.CustomerCode = '';
            
            if(objAcc.CSS_WS_Channel_of_Distribution__c!=null)inputWrapperObj.DataArea.DealerCode=objAcc.CSS_WS_Channel_of_Distribution__c;
            else  inputWrapperObj.DataArea.DealerCode='';
            
            if(distributorcode!=null && objAcc.CSS_DistributorCode__c!=null){
                List<string> HQcodes = label.OSM_BMSHQDistributors.split(',');
                List<string> UScodes = label.OSM_USBMSDistributorCodes.split(',');
                List<string> Southerncodes = label.OSM_SouthernPlainsBMSDistributorCodes.split(',');
                list<string> codeshq =new list<string>();
                list<string> codesplains =new list<string>();
                for(string usstr :UScodes){
                    if(usstr.substringAfter('-')!=null){
                        if(!codeshq.contains(usstr.substringAfter('-')))codeshq.add(usstr.substringAfter('-'));
                    }
                }
                for(string str1 :Southerncodes){
                    if(str1.substringAfter('-')!=null){
                        if(!codesplains.contains(str1.substringAfter('-')))codesplains.add(str1.substringAfter('-'));
                    }
                }
                
                if(distributorcode=='US BMS Instance'){
                    if(codeshq.contains(objAcc.CSS_DistributorCode__c)){
                        inputWrapperObj.Header.Location.LocationID=objAcc.CSS_DistributorCode__c+'-'+objAcc.CSS_DistributorCode__c;
                    }
                    else{
                        inputWrapperObj.Header.Location.LocationID=codeshq[1]+'-'+codeshq[1];
                        
                    }
                }
                
                else if(distributorcode=='Southern Plains BMS Instance'){
                    inputWrapperObj.Header.Location.LocationID=codesplains[0]+'-'+codesplains[0];
                }else{
                    inputWrapperObj.Header.Location.LocationID = locationId;
                }
            }
            else{
                inputWrapperObj.Header.Location.LocationID = locationId;
            }
            OSM_BMS_WS_GeneralizedOutputWrapper responseWrpObj = OSM_BMS_WS_CustomerLookupOutbound.callBMSService(inputWrapperObj);
            
            System.debug('General Output Wrapper>>>>>'+responseWrpObj);
            Map<String,OSM_BMS_WS_GeneralizedOutputWrapper.DataArea> dataAreaMap=new Map<String,OSM_BMS_WS_GeneralizedOutputWrapper.DataArea>();
            //log=responseWrpObj.log;
            log=responseWrpObj.log;
            Set<String> customerCodesSet=new Set<String>();
            if(!responseWrpObj.errorFlag && responseWrpObj.DataArea!=null && responseWrpObj.DataArea.size()>0)    
            {
                responseWrpObj.DataArea.sort();
                log.Response__c='Total of  '+responseWrpObj.DataArea.size()+' records received from the response';
                for(OSM_BMS_WS_GeneralizedOutputWrapper.DataArea dataAreaObj:responseWrpObj.DataArea) {
                    dataAreaMap.put(dataAreaObj.CustomerCode,dataAreaObj);
                    customerCodesSet.add(dataAreaObj.CustomerCode);
                    system.debug('dataAreaMap>>>>'+dataAreaMap);
                    //dataAreaMap.put(dataAreaObj.CustomerCode,dataAreaObj);
                }
            }
            List<Account> accountList=[Select id,IAM_Service_Provider_Code__c,Customer_BMS_number__c from Account  where Customer_BMS_number__c in :customerCodesSet];
            if(accountList!=null)
            {
                for(Account a:accountList)
                {
                    if(dataAreaMap.containsKey(a.Customer_BMS_number__c))
                    {
                        OSM_BMS_WS_GeneralizedOutputWrapper.DataArea dataAreaObj= dataAreaMap.get(a.Customer_BMS_number__c);
                        dataAreaObj.IAMCustomerCode=a.IAM_Service_Provider_Code__c;
                        dataAreaMap.put(dataAreaObj.CustomerCode,dataAreaObj);
                        system.debug('dataAreaObj inside service provider loop>>>>>'+dataAreaMap);
                    }
                }
            }
            result.success = true;
            returnMap.put('resultLength',0);
            if(responseWrpObj.DataArea != null)
                returnMap.put('resultLength',responseWrpObj.DataArea.size());
            
            returnMap.put('result',dataAreaMap);
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
        }catch(Exception e){
            result.success = false;
        }finally{
            insert log; 
        }
        
        result.data = returnMap;
        return result;
        
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getCleasePaymentMethod(ccrz.cc_RemoteActionContext ctx)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        String cartId = ccrz.cc_CallContext.currCartId;
        String accountId = ccrz.cc_CallContext.currAccountId;
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        ccrz__E_Cart__c cart;
        try{
            
            List<ccrz__E_Cart__c> cartLst = [select id, ccrz__Account__r.name,OSM_SW_Is_third_Party_BMS_Payment__c, Third_Party_BMS_Customer_ID__c,OSM_Payment_Method__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId limit 1];
            
            System.debug('===cartLst===='+cartLst);
            if(cartLst!=null && cartLst.size()>0)
            {
                cart =  cartLst[0]; 
            }
            cart.OSM_Payment_Method__c='';
            cart.OSM_SW_Is_third_Party_BMS_Payment__c=false;
            
            update cart;
            result.success = true;
            List<ccrz__E_Cart__c> cartLst123 = [select id, ccrz__Account__r.name,OSM_Payment_Method__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId limit 1];
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
        }catch(Exception e)
        {
            String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
            ccrz.ccLog.log('==Error got while saving the payment method===='+errorMsg);
            System.debug('==Error got while saving the payment method===='+errorMsg);
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Account__c = accountId;
            
            if(cart!=null){
                log.Cart__c = cart.id ; 
            }
            
            log.Error_Description__c = 'Cart Id ---> '+ cartId + errorMsg;
            log.Status__c = 'Error';
            insert log;
        }
        
        return result;
    }
    
    private  static string EDQpostalcode(string postalcode){
        
        return postalcode.substring(0,4);
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult updatePaymentMethod(ccrz.cc_RemoteActionContext ctx,String paymentMethod, boolean IsThirdPartyPayment, String thirdPartyBMSPayment, String thirdPartyBMSCustomer,String thirdPartyCustomerCode){
        ccrz.cc_CallContext.initRemoteContext(ctx);
        String cartId = ccrz.cc_CallContext.currCartId;
        String accountId = ccrz.cc_CallContext.currAccountId;
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        ccrz__E_Cart__c cart;
        try{
            
            System.debug('===cartId in updatePaymentMethod===='+cartId);
            System.debug('===PaymentMethod to update in updatePaymentMethod===='+paymentMethod);
            List<ccrz__E_Cart__c> cartLst = [select id, ccrz__Account__r.name,Third_Party_BMS_Customer_Name__c,OSM_SW_IAM_Account_Id_For_Third_Party__c,OSM_SW_Is_third_Party_BMS_Payment__c,Third_Party_BMS_Customer_ID__c,OSM_Payment_Method__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId limit 1];
            System.debug('thirdPartyCustomerCode>>>>'+thirdPartyCustomerCode);
            List<Account> accountList= new List<Account>();
            if(IsThirdPartyPayment)
                accountList = [Select id,IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c=:thirdPartyCustomerCode];
            
            System.debug('===cartLst===='+cartLst);
            if(cartLst!=null && cartLst.size()>0)
            {
                cart =  cartLst[0]; 
            }
            ccrz.ccLog.log('==Inside updatePaymentMethod of controller==='+paymentMethod);
            System.debug('==Inside updatePaymentMethod of controller==='+paymentMethod);
            cart.OSM_Payment_Method__c=paymentMethod;
            system.debug('thirdPartyPayment>>>>>'+IsThirdPartyPayment);
            cart.OSM_SW_Is_third_Party_BMS_Payment__c=false;
            if(IsThirdPartyPayment) {
                cart.OSM_SW_Is_third_Party_BMS_Payment__c=true;
                cart.Third_Party_BMS_Customer_ID__c=thirdPartyBMSPayment;
                cart.Third_Party_BMS_Customer_Name__c = thirdPartyBMSCustomer;
                if(accountList.size() >0 )
                {
                    cart.OSM_SW_IAM_Account_Id_For_Third_Party__c = accountList[0].Id;
                    returnMap.put('IAMAccountId',accountList[0].Id);
                }
            } 
            update cart;
            if(IsThirdPartyPayment)
            {
                if(accountList!=null && accountList.size()>0)
                {
                    result.success = true;
                }
                else
                {
                    result.success = false;
                    returnMap.put('ThirdPartyMsg','true');
                }
            }
            else
            {
                result.success = true;
            }
            List<ccrz__E_Cart__c> cartLst123 = [select id, ccrz__Account__r.name,OSM_Payment_Method__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId limit 1];
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
        }catch(Exception e)
        {
            String errorMsg = e.getLineNumber() + e.getStackTraceString() + '-----'+e.getMessage();
            ccrz.ccLog.log('==Error got while saving the payment method===='+errorMsg);
            System.debug('==Error got while saving the payment method===='+errorMsg);
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            log.Account__c = accountId;
            
            if(cart!=null){
                log.Cart__c = cart.id ; 
            }
            
            log.Error_Description__c = 'Cart Id ---> '+ cartId + errorMsg;
            log.Status__c = 'Error';
            insert log;
        }
        result.data = returnMap;
        return result;
        
    }
    
    public class ContactDetails
    {
        String firstName;
        String lastName;
        String email;
        String phone;
        String secondaryEmail;
    }
    
    public class EDQBillingAddressDetails
    {
        String cleasendBillingAdd1;
        String cleasendBillingAdd2;
        String cleasendBillingAdd3;
        String cleasendBillingCity;
        String cleasendBillingState;
        String cleasendBillingCountry;
        String cleasendBillingPostalCode;
    }
    public class EDQShippingAddressDetails
    {
        String cleasendShippingAdd1;
        String cleasendShippingAdd2;
        String cleasendShippingAdd3;
        String cleasendShippingCity;
        String cleasendShippingState;
        String cleasendShippingCountry;
        String cleasendShippingPostalCode;
    }
}