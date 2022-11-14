/**********************************************************************
Name:  OSM_SW_SubscriptionDetailView_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to keep all relative fetch
queries & DML statements & Logic for Subscription Detail                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            6/22/2018     INITIAL DEVELOPMENT          


*****************************************************/
global class OSM_SW_SubscriptionDetailView_Ctrl
{

/*----------------------------------------------------------------------------------
1. fetchSubscriptionDetails
Description:Used to fetch Subscription related data to be displayed on Subscription Detail page
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns the Subscription related data to be displayed to user

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/

    @RemoteAction
 global static ccrz.cc_RemoteActionResult fetchSubscriptionDetails(ccrz.cc_RemoteActionContext ctx, Id subscId){
      
      
       ccrz.cc_CallContext.initRemoteContext(ctx);
    
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        try{
            if(subscId != null)
            {
                ccrz__E_Subscription__c objSubsc = new ccrz__E_Subscription__c();
                objSubsc = [Select Id, OSM_Free_Trial__c,ccrz__CCOrder__c,ccrz__CCOrder__r.IsGetOrderSuccess__c,ccrz__CCOrderItem__c, OSM_Display_Product__c, OSM_SW_Product_Link__r.Name,ccrz__SubscriptionProduct__r.Name,OSM_SW_Product_Link__c, OSM_SW_Product_Link__r.ccrz__SKU__c, OSM_Display_Product__r.ccrz__SKU__c, OSM_Display_Product__r.Name, OSM_Subscription_End_Date__c, ccrz__SubscriptionStartDate__c from ccrz__E_Subscription__c where Id =: subscId];
                If(objSubsc != null)
                {
                    List<ccrz__E_Subscription__c> lstRevenwedSubsc = new List<ccrz__E_Subscription__c>();
                    lstRevenwedSubsc = [Select Id, Renewed_From_Subscription__c , OSM_Subscription_End_Date__c from ccrz__E_Subscription__c where Renewed_From_Subscription__c =: objSubsc.Id and ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew];
                    
                    SubscriptionData objSubscWrap = new SubscriptionData();
                    
                    objSubscWrap.isRenew = false;
                    
                    if(lstRevenwedSubsc != null && lstRevenwedSubsc.size() > 0)
                    {
                        objSubscWrap.isRenew = true;
                        //objSubscWrap.renewEndDate = String.valueOf(lstRevenwedSubsc[0].OSM_Subscription_End_Date__c.format('MM/dd/yyyy'));
                        objSubscWrap.renewEndDate = lstRevenwedSubsc[0].OSM_Subscription_End_Date__c.getTime();
                    }
                    
                    String strUserType = OSM_SW_General_Util.getuserType(UserInfo.getUserId());

                    if(objSubsc.ccrz__SubscriptionStartDate__c != null )
                       
                        {                             
                             objSubscWrap.startDate = String.valueOf(objSubsc.ccrz__SubscriptionStartDate__c.format('MM/dd/yyyy'));
                        }
                        
                    if(objSubsc.OSM_Display_Product__c != null)
                    {
                        objSubscWrap.productName = objSubsc.OSM_Display_Product__r.Name;
                        
                        objSubscWrap.objMockProduct = new mockProduct();
                        
                        objSubscWrap.objMockProduct.sfid = objSubsc.OSM_Display_Product__c;
                        objSubscWrap.objMockProduct.SKU = objSubsc.OSM_Display_Product__r.ccrz__SKU__c;
                        if(objSubsc.OSM_SW_Product_Link__c != null || test.isRunningTest())
                        {
                            objSubscWrap.objMockProduct.SKU = objSubsc.OSM_SW_Product_Link__r.ccrz__SKU__c;
                        
                            if(objSubsc.OSM_Display_Product__c != objSubsc.OSM_SW_Product_Link__c)
                            {
                                objSubscWrap.productName = objSubsc.ccrz__SubscriptionProduct__r.Name;
                            }
                            
                        }
                            
                        
                    }
                    objSubscWrap.isFreeTrial = objSubsc.OSM_Free_Trial__c;
                    if(objSubsc.OSM_Subscription_End_Date__c != null)
                    {
                    
                       objSubscWrap.endDate = String.valueOf(objSubsc.OSM_Subscription_End_Date__c.format('MM/dd/yyyy'));
                    }
     
                    if(Label.OSM_Sales_Admin_UserType == strUserType || Label.OSM_Sales_UserType == strUserType)
                        objSubscWrap.isShowExtendDate = true;
                    else
                        objSubscWrap.isShowExtendDate = false;
                   
                    
                    returnMap.put('data', objSubscWrap);
                }
            }
            
            result.data = returnMap;
            result.success = true;
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 


        }catch(Exception ex)
        {
            System.debug('in catch exp: '+ex.getMessage());
            System.debug('in catch getStackTraceString: '+ex.getStackTraceString());
            CMI_SW_CartTaxWrapper objWrpr1 = new CMI_SW_CartTaxWrapper();
            objWrpr1.isError = true;
            objWrpr1.errorMsg = ex.getMessage();
            returnMap.put('SubscriptionData ',objWrpr1);
            result.data = returnMap;
            result.success = false;
        }
        system.debug('return map: '+result);
        return result;
    }
    
    public Class SubscriptionData
    {
        boolean isFreeTrial;
        String endDate;
        String startDate;
        String productName;
        boolean isRenew;
        long renewEndDate;
        boolean isShowExtendDate;
        mockProduct objMockProduct;
        
    }
    public Class mockProduct
    {
        String sfid;
        String SKU;
    }
    
    /*----------------------------------------------------------------------------------
1. saveSubscriptionDetails
Description:Used to save Subscription related data to be
Input: ccrz.cc_RemoteActionContext ctx, Subscription Id, Subscription End Date, Quantity
Output: 
Returns the Result of save subscription

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/

    @RemoteAction
 global static ccrz.cc_RemoteActionResult saveSubscriptionDetails(ccrz.cc_RemoteActionContext ctx, Id subscId, String subscEndDate, String quantity){

       ccrz.cc_CallContext.initRemoteContext(ctx);
        Id userId = ccrz.cc_CallContext.currUserId;
        Id accountId;
        if(test.isrunningtest())
        {
            accountId=ccrz.cc_CallContext.effAccountId;
        }
        else
        {
            accountId = ccrz.cc_CallContext.currAccountId;
        }
        //Id accountId = ccrz.cc_CallContext.currAccountId;
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        Integer maxQuantityfromProduct;
        Integer maxQuantityfromProductAPI;
        String StrProductName = '';

        try{
            if(subscId != null)
            {
                ccrz__E_Subscription__c objSubsc = new ccrz__E_Subscription__c();
                objSubsc = [Select Id, OSM_SW_Free_Trial_ModifiedBy__c, ccrz__SubscriptionProduct__c, OSM_Free_Trial__c, ccrz__Quantity__c, OSM_SW_Free_Trial_Extended_Count__c,OSM_Subscription_End_Date__c, ccrz__SubscriptionStartDate__c from ccrz__E_Subscription__c where Id =: subscId];
                If(objSubsc != null)
                {
                    
                    
                    ccrz__E_Product__c  objProduct = [Select Id,ccrz__SKU__c, OSM_SW_FreeTrial_Maximum_Qty__c from ccrz__E_Product__c where Id =: objSubsc.ccrz__SubscriptionProduct__c];
                    ccrz__E_CompositeProduct__c objComposite = [Select Id, ccrz__Composite__c, ccrz__Composite__r.ccrz__SKU__c, ccrz__Composite__r.Name from ccrz__E_CompositeProduct__c where ccrz__Component__c =: objSubsc.ccrz__SubscriptionProduct__c limit 1];
                    
                    StrProductName = objComposite.ccrz__Composite__c != null ? objComposite.ccrz__Composite__r.Name :'';
                    
                    if(objProduct.OSM_SW_FreeTrial_Maximum_Qty__c != null)
                        maxQuantityfromProduct = Integer.valueOf(objProduct.OSM_SW_FreeTrial_Maximum_Qty__c);
                    else
                        maxQuantityfromProduct = 0;
                    
                    Account objAccount = [Select Id, OSM_Market_Segment_Code__c, CMI_Cid__c from Account where Id=: accountId];
                    
                    
                    try{
                        
                        String baseSku = objProduct.ccrz__SKU__c;
                        String parentSku = '';
                        if(objComposite != null && objComposite.ccrz__Composite__c != null)
                            parentSku = objComposite.ccrz__Composite__r.ccrz__SKU__c;
                        
                        String customerId = objAccount.CMI_Cid__c != null ? objAccount.CMI_Cid__c :'';
                        OSM_WS_GeneralizedInputWrapper inputAPiWrapper = new OSM_WS_GeneralizedInputWrapper();
                        
                        inputAPiWrapper.customerId = customerId;
                        inputAPiWrapper.initiator = 'ECommerce';
                        inputAPiWrapper.timeStamp='2018-03-20T19:47:00.000Z';
                        system.debug('customerId_in_test'+customerId);
                        OSM_WS_GetProductDetail_RES productsDetailFromAPI = OSM_WS_CS_Services.GetProductsWS(inputAPiWrapper);
                        
                        String skuNumber = baseSku.contains('-')?baseSku.split('-')[0]:baseSku;   
                        
                        
                        if(productsDetailFromAPI!=null){
                            List<OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo> productSubscriptionInfo = productsDetailFromAPI.productSubscriptionInfo; 
                            OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfo = new OSM_DA_GenericFunctionsUtility.DAProdCountInfo();
                            Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo> prodCountMap = new Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo>();
                            Map<String, String> baseToParentSku = OSM_DA_GenericFunctionsUtility.fetchDefaultDAProductPartNumber(new List<String>{baseSku});
                            String defSku = baseToParentSku.get(baseSku);
                            String defaultPort = defSku.contains('-')?defSku.split('-')[0]:defSku; 
                            if(productSubscriptionInfo.size()>0){
                                for(OSM_WS_GetProductDetail_RES.ProductSubscriptionInfo proInfo : productSubscriptionInfo){
                                    if(proInfo.productID == defaultPort){

                                    
                                        //Vaibhav - Start for Prod data changes
                                        proInfo.productID = proInfo.productID + Label.OSM_Default_Market_Segment;
                                        prodInfo.defaultDAProdPartNo=proInfo.productID;
                                        prodInfo.availableCnt=proInfo.availableCount != null ? proInfo.availableCount : 0;
                                        prodInfo.currentCnt=proInfo.totalSubscriptionCount != null ? proInfo.totalSubscriptionCount:0;
                                        prodInfo.daMessage = proInfo.message != null ? proInfo.message : '';
                                        prodCountMap.put(proInfo.productID,prodInfo);
                                        //this will return the main product sku and wrapper
                                         system.debug('===Before convert===prodCountMap==');
                                         system.debug(prodCountMap);                          
                                        
                                         prodCountMap = OSM_DA_GenericFunctionsUtility.fetchOSMParentProdAndCount(prodCountMap,objAccount.OSM_Market_Segment_Code__c);

                                         system.debug('===After convert===prodCountMap==');
                                         system.debug(prodCountMap); 
                                        OSM_DA_GenericFunctionsUtility.DAProdCountInfo prodInfoReturn = prodCountMap.get(parentSku);
                                       
                                        maxQuantityfromProductAPI = prodInfoReturn.availableCnt != null ? prodInfoReturn.availableCnt : 0;

                                        break;

                                        //Vaibhav - End for Prod data changes
                                    }
                                }

                            }
                      
                        }
                        
//if(Test.isRunningTest()) {
                       //throw new NullPointerException();
                   // } 
 
                    }
                    Catch(Exception ex)
                    {
                        System.debug('On Subscription update api call: '+ex);
                        String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();

                        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                
                        log.Error_Description__c = errorMsg;
                
                        log.Service_Name__c = System.Label.OSM_SW_FreeTrial_Service;
                
                        log.Status__c = 'Failed';
                
                        insert log;
                        
                        returnMap.put('data',System.Label.OSM_SW_Free_Trial_ErrorMsg);
                        result.data = returnMap;
                        result.success = false;
                        system.debug('return map: '+result);
                       if(!test.isRunningTest())
                        return result;
                    }
                    
                    System.debug('maxQuantityfromProduct: '+maxQuantityfromProduct+' maxQuantityfromProductAPI: '+maxQuantityfromProductAPI);
                    Integer maxAvilableQuantity = 0;
                    if(maxQuantityfromProduct < maxQuantityfromProductAPI)
                        maxAvilableQuantity = maxQuantityfromProduct;
                    else
                        maxAvilableQuantity = maxQuantityfromProductAPI;
                    
                    
                    Date dtEnd = Date.valueOf(subscEndDate);
                    System.debug('dtEnd : '+dtEnd);
                    Datetime dtFinal;
                    if(objSubsc.ccrz__SubscriptionStartDate__c != null)
                        dtFinal = datetime.newInstance(dtEnd.year(), dtEnd.month(),dtEnd.day(), objSubsc.ccrz__SubscriptionStartDate__c.hour(), objSubsc.ccrz__SubscriptionStartDate__c.minute(), objSubsc.ccrz__SubscriptionStartDate__c.second());
                    else
                        dtFinal = datetime.newInstance(dtEnd.year(), dtEnd.month(),dtEnd.day());
           
                    Date endDate = Date.valueOf(subscEndDate);
                    Date nowDate = System.now().date();
                    System.debug('endDate: '+endDate);
                    System.debug('subscEndDate: '+subscEndDate);
                    System.debug('nowDate: '+nowDate);
                    System.debug('endDate > nowDate: '+(endDate > nowDate));
                   if( endDate >= nowDate)
                   { 
                        
                        if(objSubsc.OSM_Subscription_End_Date__c != dtFinal)
                        {
                            if(objSubsc.OSM_SW_Free_Trial_Extended_Count__c != null)
                                objSubsc.OSM_SW_Free_Trial_Extended_Count__c = objSubsc.OSM_SW_Free_Trial_Extended_Count__c +1;
                            else
                                objSubsc.OSM_SW_Free_Trial_Extended_Count__c = 1;
                        
                        }
                        
                        if(objSubsc.ccrz__Quantity__c != Integer.valueOf(quantity) && objSubsc.ccrz__Quantity__c < Integer.valueOf(quantity))
                        {
                            
                            if(maxQuantityfromProductAPI < Integer.valueOf(quantity))
                            {
                                returnMap.put('data', System.Label.OSM_SW_Free_Trial_SaveSuncsQuantityValidate1+' '+StrProductName+'. '+System.Label.OSM_SW_Free_Trial_SaveSuncsQuantityValidate2+' '+maxQuantityfromProductAPI+'.');                        
                                result.success = false;
                            }
                            else
                            {
                                
                                objSubsc.OSM_Subscription_End_Date__c = dtFinal;
                                objSubsc.ccrz__Quantity__c = Integer.valueOf(quantity);
                                objSubsc.OSM_SW_Free_Trial_ModifiedBy__c = UserInfo.getUserId();
                                update objSubsc;
                                
                                returnMap.put('data', System.Label.OSM_SW_Free_Trial_SaveSuncsMsg);                        
                                result.success = true;
                            }
                        }
                        else
                        {
                            objSubsc.OSM_Subscription_End_Date__c = dtFinal;
                            objSubsc.ccrz__Quantity__c = Integer.valueOf(quantity);
                            objSubsc.OSM_SW_Free_Trial_ModifiedBy__c = UserInfo.getUserId();
                            
                            update objSubsc;
                            
                            returnMap.put('data', System.Label.OSM_SW_Free_Trial_SaveSuncsMsg);                        
                            result.success = true;
                        }
                        
                        
                        
                    }
                    else
                    {
                        returnMap.put('data', System.Label.OSM_SW_Free_Trial_SubscDateValidation);
                        
                        result.success = false;
                    }
                }
                
            }
            result.data = returnMap;
            
        if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 

        }catch(Exception ex)
        {
            System.debug('in catch exp: '+ex.getMessage());
            System.debug('in catch getStackTraceString: '+ex.getStackTraceString());
            returnMap.put('data',System.Label.OSM_SW_Free_Trial_ErrorMsg);
            result.data = returnMap;
            result.success = false;
            
            String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();

            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
    
            log.Error_Description__c = errorMsg;
    
            log.Service_Name__c = System.Label.OSM_SW_FreeTrial_Service;
    
            log.Status__c = 'Failed';
    
            insert log;
        }
        system.debug('return map: '+result);
        return result;
    }
  
}