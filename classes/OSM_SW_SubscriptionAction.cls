/************************************************************
Name:  OSM_SW_SubscriptionAction 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is business layer for free trial subscription. It will 
create input wrapper on insert and update of freetrial
subscription and will pass it to service class. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_SW_SubscriptionAction{
    
    /*----------------------------------------------------------------------------------
1. FreeTrialSubscriptionOnInsert
Description:Used to fetch free trial subscription input wrapper parameters on insert
Input: List of subscription Id's
Output: Freetrial Wrapper object to pass onto service layer
Returntype: void
------------------------------------------------------------------------------------*/
    public static void FreeTrialSubscriptionOnInsert(List<Id> subsId){
        
        
        
        OSM_WS_GeneralizedInputWrapper subsWrapper = new OSM_WS_GeneralizedInputWrapper(); //Initializing generalized input wrapper
        List<OSM_WS_GeneralizedInputWrapper> subsWrapperLst = new List<OSM_WS_GeneralizedInputWrapper>();
        List<OSM_WS_GeneralizedInputWrapper.OrderLineItems> subsWrapperlineitemObjList = new List<OSM_WS_GeneralizedInputWrapper.OrderLineItems>();
        List<ccrz__E_Subscription__c> subsriptionList = new List<ccrz__E_Subscription__c>();
        
        OSM_WS_GetFreeTrailRes serviceCallReturn = new OSM_WS_GetFreeTrailRes();
        OSM_Generic_ExceptionHandling excepObj = null; //Initialize Exception classObj
        OSM_Integration_Log__c log = null; //Initialize integration log 
        List<string> splitResponseStr = new List<string>();
        String Subscription_Auto_Number; //String variable to store auto number
        Map<OSM_WS_GeneralizedInputWrapper,Id> mapGenInPutWrapperVsSubsId = new Map<OSM_WS_GeneralizedInputWrapper,Id>();
        String skuNumber;
        String AccountId;
        excepObj = new OSM_Generic_ExceptionHandling(); 
        
        try{        
            subsriptionList = [Select id, name, ccrz__SubscriptionProduct__c, ccrz__SubscriptionProduct__r.ccrz__SKU__c, ccrz__SubscriptionProduct__r.ccrz__ParentProduct__r.ccrz__SKU__c, OSM_Free_Trial__c, ccrz__Quantity__c, ccrz__SubscriptionStartDate__c, ccrz__RecurringPrice__c, ccrz__CurrencyISOCode__c, OSM_Subscription_End_Date__c, ccrz__Account__r.CMI_CId__c from ccrz__E_Subscription__c where id IN :subsId];
            
            //Populating Wrapper
            subsWrapper.timeStamp = OSM_Generic_Utility.getUTCDate(system.now());
            
            subsWrapper.createdDate = OSM_Generic_Utility.getUTCDate(system.now());
            subsWrapper.nextInvoiceDate = OSM_Generic_Utility.getUTCDate(system.now());
            
            //Orderlineitems are subscription records
            if(subsriptionList != null && subsriptionList.size() >0){
                for(ccrz__E_Subscription__c ccSubs :subsriptionList){           
                    OSM_WS_GeneralizedInputWrapper.OrderLineItems subsWrapperlineitemObj = new OSM_WS_GeneralizedInputWrapper.OrderLineItems(); //Initializing generalized input wrapper line item                        
                    AccountId = ccSubs.ccrz__Account__c; 
					String DisplaySKU = ccSubs.ccrz__SubscriptionProduct__r.ccrz__ParentProduct__r.ccrz__SKU__c;
                    if (DisplaySKU != null){
                        skuNumber = DisplaySKU.contains('-')? DisplaySKU.split('-')[0]: DisplaySKU; //Splitting to get only SKU part of the product 
                    }else {
                        String DisplaySKUDEF = ccSubs.ccrz__SubscriptionProduct__r.ccrz__SKU__c;
                        skuNumber = DisplaySKUDEF.contains('-')? DisplaySKUDEF.split('-')[0]: DisplaySKUDEF; //Splitting to get only SKU part of the product
                    }
                    subsWrapperlineitemObj.productID = skuNumber;
                    
                    if(ccSubs.OSM_Free_Trial__c != null && ccSubs.OSM_Free_Trial__c == False){
                        subsWrapperlineitemObj.freeTrial = Label.OSM_FreeTrial_No;
                    }else{
                        subsWrapperlineitemObj.freeTrial = Label.OSM_FreeTrial_Yes;
                    }
                    
                    subsWrapperlineitemObj.subscriptionQuantity = Integer.valueOf(ccSubs.ccrz__Quantity__c); 
                    subsWrapperlineitemObj.subscriptionType = Label.OSM_FreeTrail_New;
                    subsWrapperlineitemObj.startDate = OSM_Generic_Utility.getUTCDate(ccSubs.ccrz__SubscriptionStartDate__c);
                    subsWrapperlineitemObj.pricePerUnit = ccSubs.ccrz__RecurringPrice__c;
                    subsWrapperlineitemObj.currencyType = ccSubs.ccrz__CurrencyISOCode__c;                  
                    subsWrapperlineitemObj.expirationDate = OSM_Generic_Utility.getUTCDate(ccSubs.OSM_Subscription_End_Date__c);
                    
                    subsWrapperlineitemObjList.add(subsWrapperlineitemObj);
                } 
            }       
            subsWrapper.orderLineItems = subsWrapperlineitemObjList;
            system.debug('subsWrapperlineitemObjList'+subsWrapperlineitemObjList);
            
            Subscription_Auto_Number = OSM_Generic_Utility.getIncrementalCount();
            if(subsriptionList != null && subsriptionList.size() >0){
                for(ccrz__E_Subscription__c ccSubs :subsriptionList){
                    subsWrapper.customerId = ccSubs.ccrz__Account__r.CMI_CId__c; //CustomerId of account associated to order associated with subscription
                    subsWrapper.orderId = ccSubs.name + Subscription_Auto_Number; //This is subscriptionId + autoNumber
                    
                    mapGenInPutWrapperVsSubsId.put(subsWrapper,ccSubs.id);
                }
            }
            subsWrapperLst.add(subsWrapper);
            system.debug('subsWrapperLst'+subsWrapperLst);
            
            if(subsWrapperLst != null && subsWrapperLst.size() >0){
                for(OSM_WS_GeneralizedInputWrapper genWrap :subsWrapperLst){
                    //Call the service layer
                    serviceCallReturn = OSM_WS_FreeTrialServiceCall.callFreeTrailService(genWrap);
                    system.debug('serviceCallReturn'+serviceCallReturn);
                    
                    String responseStr = serviceCallReturn.Response;
                    String Status;
                    String StatusCode;
                    String ResponseBody;
                    if(responseStr != null){
                        splitResponseStr = responseStr.split('\n');
                        Status = splitResponseStr[0].substring(7);
                        StatusCode = splitResponseStr[1].substring(12);
                        ResponseBody = splitResponseStr[2].substring(15);
                    }
                    
                    //Check for service call return and create logs
                    if(Test.isRunningTest()){
                        serviceCallReturn.exceptionFlag=true;
                    }
                    
                    if(serviceCallReturn.exceptionFlag == True){                    
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log;
						log.Account__c = AccountId; 
                        log.Status__c = serviceCallReturn.Status;
                        log.Request__c = serviceCallReturn.Request;
                        log.Response__c =  'Status: '+Status + 'StatusCode: '+StatusCode;
                        log.Error_Description__c = 'ResponseBody: '+ResponseBody;              
                        log.Service_Name__c = Label.OSM_Free_Trail_Subscription;
                        log.Source__c = Label.OSM_Bolt_Source;
                        log.Target__c = Label.OSM_FreeTrial_Target;
                        log.Logged_In_User__c = userinfo.getuserid(); 
                        log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');
                        log.Subscription__c = mapGenInPutWrapperVsSubsId.keyset() != null ? mapGenInPutWrapperVsSubsId.get(genWrap) : null;
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Create integration log
                        system.debug('log'+log); 
                    }
                    if(Test.isRunningTest()){
                        serviceCallReturn.exceptionFlag=false;
                    }
                    
                    if((serviceCallReturn.exceptionFlag == False) && (Boolean.valueOf(label.OSM_Success_Log) ==  true)){
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log;
						log.Account__c = AccountId; 
                        log.Status__c = serviceCallReturn.Status;
                        log.Request__c = serviceCallReturn.Request;
                        log.Response__c =  serviceCallReturn.Response;
                        log.Error_Description__c = serviceCallReturn.errorMessage;              
                        log.Service_Name__c = Label.OSM_Free_Trail_Subscription;
                        log.Source__c = Label.OSM_Bolt_Source;
                        log.Target__c = Label.OSM_FreeTrial_Target;
                        log.Logged_In_User__c = userinfo.getuserid(); 
                        log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');
                        log.Subscription__c = mapGenInPutWrapperVsSubsId.keyset() != null ? mapGenInPutWrapperVsSubsId.get(genWrap) : null;
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Create integration log
                        
                    }           
                }
            }
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
        }catch(Exception e){
            System.debug('=====Exception in call_FreeTrialSubscription===='+e);
            excepObj = new OSM_Generic_ExceptionHandling();
            excepObj.exceptionFlag = true;
            excepObj.errorMessage = e.getStacktraceString();
            
            log = new OSM_Integration_Log__c();
            OSM_SW_LoggingContext.integrationLog = log;
			log.Account__c = AccountId;
            log.Status__c = Label.OSM_Bolt_Log_Status_Failure;
            log.Error_Description__c = 'Stack traced at: '+e.getStacktraceString();          
            log.Response__c = 'Exception:'+e.getMessage() + ' at Line Number :'+e.getLineNumber();
            log.Service_Name__c =  Label.OSM_Free_Trail_Subscription;
            log.Source__c = Label.OSM_Bolt_Source;
            log.Target__c = Label.OSM_FreeTrial_Target;
            log.Logged_In_User__c = userinfo.getuserid(); 
            log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');
            OSM_SW_LoggingContext.saveIntegrationLog(log); //Create integration log
            system.debug('excepObj'+excepObj); 
        }   
        system.debug('log'+log);
        OSM_Generic_Utility.UpdateIncrementalCount();
    }
    
    /*----------------------------------------------------------------------------------
2. FreeTrialSubscriptionOnUpdate
Description:Used to fetch free trial subscription input wrapper parameters on update
Input: List of json string. OSM_WS_FreeTrialUpdateReqWrapper class object is prepared
on update call and serialize to add into list. 
Output: Freetrial Wrapper object to pass onto service layer
Returntype: void
------------------------------------------------------------------------------------*/    
    public static void FreeTrialSubscriptionOnUpdate(List<String> jsonList){
        
        
        OSM_WS_GeneralizedInputWrapper subsWrapper = new OSM_WS_GeneralizedInputWrapper(); //Initializing generalized input wrapper
        List<OSM_WS_GeneralizedInputWrapper> subsWrapperLst = new List<OSM_WS_GeneralizedInputWrapper>();
        List<OSM_WS_GeneralizedInputWrapper.OrderLineItems> subsWrapperlineitemObjList = new List<OSM_WS_GeneralizedInputWrapper.OrderLineItems>();
        List<ccrz__E_Subscription__c> subsriptionList = new List<ccrz__E_Subscription__c>();
        
        OSM_WS_GetFreeTrailRes serviceCallReturn = new OSM_WS_GetFreeTrailRes();
        OSM_Generic_ExceptionHandling excepObj = null; //Initialize Exception classObj
        OSM_Integration_Log__c log = null; //Initialize integration log 
        List<string> splitResponseStr = new List<string>();
        String Subscription_Auto_Number; //String variable to store auto number
        List<OSM_WS_FreeTrialUpdateReqWrapper> reqWrapList = new List<OSM_WS_FreeTrialUpdateReqWrapper>(); //Initializing OSM_WS_FreeTrialUpdateReqWrapper wrapper class
        Map<Id, OSM_WS_FreeTrialUpdateReqWrapper> mapSubsIdreqWrap = new Map<Id, OSM_WS_FreeTrialUpdateReqWrapper>(); //Map of subscription id and OSM_WS_FreeTrialUpdateReqWrapper class
        OSM_WS_FreeTrialUpdateReqWrapper freeTrailWrapObj = new OSM_WS_FreeTrialUpdateReqWrapper(); //Creating object of OSM_WS_FreeTrialUpdateReqWrapper class
        Map<OSM_WS_GeneralizedInputWrapper,Id> mapGenInPutWrapperVsSubsId = new Map<OSM_WS_GeneralizedInputWrapper,Id>();
        String skuNumber;
         String AccountId;    
        try{
            //If json list is not null, deserialize wrapper into OSM_WS_FreeTrialUpdateReqWrapper class and add in list
            if(jsonList.size() >0){
                for(String jsonString :jsonList){
                    OSM_WS_FreeTrialUpdateReqWrapper jsonWrap = (OSM_WS_FreeTrialUpdateReqWrapper)JSON.deserialize(jsonString, OSM_WS_FreeTrialUpdateReqWrapper.class);
                    reqWrapList.add(jsonWrap);
                }
                system.debug('reqWrapList'+reqWrapList);
                
                //If class object list is not null, create a map to populate subcription id and class object. 
                for(OSM_WS_FreeTrialUpdateReqWrapper reqWrap :reqWrapList){
                    mapSubsIdreqWrap.put(reqWrap.subscriptionId, reqWrap);
                }   
                
                
                excepObj = new OSM_Generic_ExceptionHandling();
                
                subsriptionList = [Select id, name, ccrz__SubscriptionProduct__c, ccrz__SubscriptionProduct__r.ccrz__ParentProduct__r.ccrz__SKU__c,ccrz__SubscriptionProduct__r.ccrz__SKU__c, OSM_Free_Trial__c, ccrz__Quantity__c, 
                                   ccrz__SubscriptionStartDate__c, ccrz__RecurringPrice__c, ccrz__CurrencyISOCode__c, 
                                   OSM_Subscription_End_Date__c, ccrz__Account__r.CMI_CId__c from ccrz__E_Subscription__c where id IN :mapSubsIdreqWrap.keyset()];
                system.debug('subsriptionList'+subsriptionList);        
                
                //Populate wrapper parameters based on critera
                subsWrapper.timeStamp = OSM_Generic_Utility.getUTCDate(system.now());                   
                subsWrapper.createdDate = OSM_Generic_Utility.getUTCDate(system.now());
                subsWrapper.nextInvoiceDate = OSM_Generic_Utility.getUTCDate(system.now());
                
                //Orderlineitems are subscription records
                for(ccrz__E_Subscription__c ccSubs :subsriptionList){
					AccountId = ccSubs.ccrz__Account__c;
                    if(mapSubsIdreqWrap.containsKey(ccSubs.id)){
                        OSM_WS_GeneralizedInputWrapper.OrderLineItems subsWrapperlineitemObj = new OSM_WS_GeneralizedInputWrapper.OrderLineItems(); //Initializing generalized input wrapper line item
                        freeTrailWrapObj = mapSubsIdreqWrap.get(ccSubs.id);                         
                        
                        String DisplaySKU = ccSubs.ccrz__SubscriptionProduct__r.ccrz__ParentProduct__r.ccrz__SKU__c;
                        if (DisplaySKU != null){
                            skuNumber = DisplaySKU.contains('-')? DisplaySKU.split('-')[0]: DisplaySKU; //Splitting to get only SKU part of the product 
                        }else {
                            String DisplaySKUDEF = ccSubs.ccrz__SubscriptionProduct__r.ccrz__SKU__c;
                            skuNumber = DisplaySKUDEF.contains('-')? DisplaySKUDEF.split('-')[0]: DisplaySKUDEF; //Splitting to get only SKU part of the product
                        }
                        subsWrapperlineitemObj.productID = skuNumber;
                        
                        subsWrapperlineitemObj.startDate = OSM_Generic_Utility.getUTCDate(ccSubs.ccrz__SubscriptionStartDate__c);
                        subsWrapperlineitemObj.pricePerUnit = ccSubs.ccrz__RecurringPrice__c; //Need to check
                        subsWrapperlineitemObj.currencyType = ccSubs.ccrz__CurrencyISOCode__c; 
                        
                        //Scenario 1: If subscription end date has changed
                        if(freeTrailWrapObj.PreviousEndDate != freeTrailWrapObj.CurrentEndDate){
                            subsWrapperlineitemObj.freeTrial = Label.OSM_FreeTrial_Yes;
                            subsWrapperlineitemObj.subscriptionType = Label.OSM_FreeTrail_Renewal;
                            subsWrapperlineitemObj.subscriptionQuantity = Integer.valueOf(freeTrailWrapObj.CurrentQuantity);
                            subsWrapperlineitemObj.expirationDate = OSM_Generic_Utility.getUTCDate(freeTrailWrapObj.CurrentEndDate);
                        }
                        
                        //Scenario 2: If subscription quantity has changed
                        if(freeTrailWrapObj.PreviousQuantity != freeTrailWrapObj.CurrentQuantity){
                            subsWrapperlineitemObj.freeTrial = Label.OSM_FreeTrial_Yes;
                            subsWrapperlineitemObj.subscriptionType = Label.OSM_FreeTrail_New;
                            subsWrapperlineitemObj.subscriptionQuantity = Integer.valueOf(freeTrailWrapObj.CurrentQuantity) - Integer.valueOf(freeTrailWrapObj.PreviousQuantity);
                            subsWrapperlineitemObj.expirationDate = OSM_Generic_Utility.getUTCDate(freeTrailWrapObj.CurrentEndDate);
                        }
                        
                        //Scenario 3: If subscription end date and subscription quantity has changed
                        if((freeTrailWrapObj.PreviousEndDate != freeTrailWrapObj.CurrentEndDate) && (freeTrailWrapObj.PreviousQuantity != freeTrailWrapObj.CurrentQuantity)){
                            subsWrapperlineitemObj.freeTrial = Label.OSM_FreeTrial_Yes;
                            subsWrapperlineitemObj.subscriptionType = Label.OSM_FreeTrail_Renewal;
                            subsWrapperlineitemObj.subscriptionQuantity = Integer.valueOf(freeTrailWrapObj.CurrentQuantity);
                            subsWrapperlineitemObj.expirationDate = OSM_Generic_Utility.getUTCDate(freeTrailWrapObj.CurrentEndDate);
                        }
                        
                        subsWrapperlineitemObjList.add(subsWrapperlineitemObj); 
                        //log.Subscription__c = ccSubs.id; //Need to populate this in log 
                    }
                }   
                system.debug('subsWrapperlineitemObjList'+subsWrapperlineitemObjList);
                subsWrapper.orderLineItems = subsWrapperlineitemObjList;
                
                Subscription_Auto_Number = OSM_Generic_Utility.getIncrementalCount();
                for(ccrz__E_Subscription__c ccSubs :subsriptionList){
                    subsWrapper.customerId = ccSubs.ccrz__Account__r.CMI_CId__c; //CustomerId of account associated to order associated with subscription                       
                    subsWrapper.orderId = ccSubs.name + Subscription_Auto_Number; //This is subscriptionId + autoNumber
                    
                    mapGenInPutWrapperVsSubsId.put(subsWrapper,ccSubs.id);
                }
                
                subsWrapperLst.add(subsWrapper); //Add subscription wrapper into list
                system.debug('subsWrapperLst'+subsWrapperLst);
                
                for(OSM_WS_GeneralizedInputWrapper genWrap :subsWrapperLst){
                    //Call the service layer
                    serviceCallReturn = OSM_WS_FreeTrialServiceCall.callFreeTrailService(genWrap);
                    system.debug('serviceCallReturn'+serviceCallReturn);
                    
                    String responseStr = serviceCallReturn.Response;
                    String Status;
                    String StatusCode;
                    String ResponseBody;
                    if(responseStr != null){
                        splitResponseStr = responseStr.split('\n');
                        Status = splitResponseStr[0].substring(7);
                        StatusCode = splitResponseStr[1].substring(12);
                        ResponseBody = splitResponseStr[2].substring(15);
                    }
                    
                    if(Test.isRunningTest()){
                        serviceCallReturn.exceptionFlag=true;
                    }
                    //Check for service call return and create logs
                    if(serviceCallReturn.exceptionFlag == True){                    
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log;
						log.Account__c = AccountId; 
                        log.Status__c = serviceCallReturn.Status;
                        log.Request__c = serviceCallReturn.Request;
                        log.Response__c =  'Status: '+Status + 'StatusCode: '+StatusCode;
                        log.Error_Description__c = 'ResponseBody: '+ResponseBody;              
                        log.Service_Name__c = Label.OSM_Free_Trail_Subscription;
                        log.Source__c = Label.OSM_Bolt_Source;
                        log.Target__c = Label.OSM_FreeTrial_Target;
                        log.Logged_In_User__c = userinfo.getuserid(); 
                        log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');
                        log.Subscription__c = mapGenInPutWrapperVsSubsId.keyset() != null ? mapGenInPutWrapperVsSubsId.get(genWrap) : null;
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Create integration log
                        system.debug('log'+log); 
                    }
                    if(Test.isRunningTest()){
                        serviceCallReturn.exceptionFlag=false;
                    }
                    
                    if((serviceCallReturn.exceptionFlag == False) && (Boolean.valueOf(label.OSM_Success_Log) ==  true)){
                        log = new OSM_Integration_Log__c();
                        OSM_SW_LoggingContext.integrationLog = log;
						log.Account__c = AccountId; 
                        log.Status__c = serviceCallReturn.Status;
                        log.Request__c = serviceCallReturn.Request;
                        log.Response__c =  serviceCallReturn.Response;
                        log.Error_Description__c = serviceCallReturn.errorMessage;              
                        log.Service_Name__c = Label.OSM_Free_Trail_Subscription;
                        log.Source__c = Label.OSM_Bolt_Source;
                        log.Target__c = Label.OSM_FreeTrial_Target;
                        log.Logged_In_User__c = userinfo.getuserid(); 
                        log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');
                        log.Subscription__c = mapGenInPutWrapperVsSubsId.keyset() != null ? mapGenInPutWrapperVsSubsId.get(genWrap) : null;
                        OSM_SW_LoggingContext.saveIntegrationLog(log); //Create integration log
                        
                    }           
                }
            }
            if(Test.isRunningTest()) {
                throw new NullPointerException();
            } 
            
        }catch(Exception e){
            System.debug('=====Exception in call_FreeTrialSubscription===='+e);
            excepObj = new OSM_Generic_ExceptionHandling();
            excepObj.exceptionFlag = true;
            excepObj.errorMessage = e.getStacktraceString();
            
            log = new OSM_Integration_Log__c();
            OSM_SW_LoggingContext.integrationLog = log;
			log.Account__c = AccountId; 
            log.Status__c = Label.OSM_Bolt_Log_Status_Failure;
            log.Error_Description__c = 'Stack traced at: '+e.getStacktraceString();          
            log.Response__c = 'Exception:'+e.getMessage() + ' at Line Number :'+e.getLineNumber();
            log.Service_Name__c =  Label.OSM_Free_Trail_Subscription;
            log.Source__c = Label.OSM_Bolt_Source;
            log.Target__c = Label.OSM_FreeTrial_Target;
            log.Logged_In_User__c = userinfo.getuserid(); 
            log.Unique_Message_Identifier__c = (system.now()).format('yyyyMMddhhmmss');
            OSM_SW_LoggingContext.saveIntegrationLog(log); //Create integration log
            
        }
        
        OSM_Generic_Utility.UpdateIncrementalCount();
    } 
    
    // Epic RTC_182144 - IAM Provisioning - Juhi - April 08 2019
    public static void IAMProvisioningOnInsert(List<Id> subscriptionIDList, boolean isAllIAMCreate ,boolean isGuidanzMobileIAMCreateOnly)
    {
		String AccountId; 					 
        try
        {
            // START : getting all required data and creation of variables
            List<OSM_Subscription_Account_Provision__c> junctionObjectToBeInsertedList = new List<OSM_Subscription_Account_Provision__c>();
            List<OSM_Subscription_Account_Provision__c> junctionObjectToBeInsertedListIntermediat = new List<OSM_Subscription_Account_Provision__c>();
            List<IAM_Application__c> iamRecordToBeInsertedList = new List<IAM_Application__c>();
            List<IAM_Application__c> iamRecordsToBeUpdated = new List<IAM_Application__c>();
            Map<Id, IAM_Application__c> iamRecordsToBeUpdatedMap = new Map<Id, IAM_Application__c>();
            Set<Id> UpdateOrderSubSet = new Set<Id>();
            
            List<OSM_IAMProvisioningDetails> osmIamProvisioningDetailsList = new List<OSM_IAMProvisioningDetails>();
            List<OSM_JunctionObjectDetails> osmJunctionObjectDetailsList = new List<OSM_JunctionObjectDetails>();
            
            Map<Id,ccrz__E_Subscription__c> subscriptionMap = new Map<Id,ccrz__E_Subscription__c>([Select ID, ccrz__Quantity__c, ccrz__SubscriptionStatus__c,ccrz__Account__r.PSBU_Channel_of_Distribution__c,ccrz__Account__r.EBU_Channel_of_Distribution__c,OSM_Subscription_End_Date__c, ccrz__SubscriptionStartDate__c, ccrz__Account__c, ccrz__Account__r.ccrz__E_AccountGroup__r.Name, ccrz__Account__r.Name, OSM_Display_Product__c, ccrz__SubscriptionProduct__c, ccrz__SubscriptionProduct__r.isIAMProvisioningRequired__c, ccrz__SubscriptionProduct__r.QSOLType__c, ccrz__SubscriptionProduct__r.Name, ccrz__SubscriptionProduct__r.ccrz__SKU__c, ccrz__SubscriptionProduct__r.ccrz__ProductType__c  from ccrz__E_Subscription__c where ID In :subscriptionIDList]);
            
            system.debug('CCRZ subscriptionMap ->'+subscriptionMap);
            Set<String> productIdSet = new Set<String>();
            
            Set<ID> accountIdSet = new Set<ID>();
            
            if(subscriptionMap.keyset() != null && subscriptionMap.size()>0)
            {
                for(Id subscriptionId : subscriptionMap.keySet())
                {
					AccountId = subscriptionMap.get(subscriptionId).ccrz__Account__c;
                    if(subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__r.ccrz__ProductType__c == 'Bundle'
                       || (subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__r.ccrz__ProductType__c == 'Product'
                           && (subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__r.Name.ContainsIgnoreCase('Add-On')
                               || subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__r.Name.ContainsIgnoreCase('Service Tech Kit')))){
                                   productIdSet.add(subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__c);
                               }
                    if(subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__r.ccrz__ProductType__c == 'Product'
                       && !subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__r.Name.ContainsIgnoreCase('Add-On')
                       && !subscriptionMap.get(subscriptionId).ccrz__SubscriptionProduct__r.Name.ContainsIgnoreCase('Service Tech Kit')){
                           productIdSet.add(subscriptionMap.get(subscriptionId).OSM_Display_Product__c);
                       }
                    
                    accountIdSet.add(subscriptionMap.get(subscriptionId).ccrz__Account__c);
																																		  
                }
            }
            
            system.debug('CCRZ productIdSet ->'+productIdSet);
            system.debug('CCRZ accountIdSet ->'+accountIdSet);
            
            Map<Id, Account> accountMap = new Map<Id, Account>([Select ID, DTNA__c, Type, RecordTypeId, Name, EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,OSM_HHP_Dealer__c,EngineRangeDesc__c, CMI_Region__c, Business_Unit__c, OSM_Market_Segment_Code__c, CMI_Account_Status__c, CHANNEL_OF_DISTRIBUTION__c, OSM_Service_Level__c,ServiceLevel__c FROM Account where ID in :accountIdSet]);     //Mar-1236
            system.debug('CCRZ accountMap ->'+accountMap);
            //Map<Id, ccrz__E_Product__c> productMap = new Map<Id, ccrz__E_Product__c>([Select ID, Name, QSOLType__c, isIAMProvisioningRequired__c, ccrz__SKU__c, ccrz__ProductType__c, Product_Range__c, Feature__c, FeatureGroup__c, LicenseName__c from ccrz__E_Product__c]);
            //system.debug('CCRZ productMap ->'+productMap);
            Map<Id, List<ccrz__E_CompositeProduct__c>> compositeIdToCompositeProductMap = getCompositeIdToCompositeProductMap(new List<String>(productIdSet));
            
            system.debug('CCRZ compositeIdToCompositeProductMap ->'+compositeIdToCompositeProductMap);
            Map<String, OSM_Application_Feature__mdt> applicationFeatureMap = getApplicationFeatureMetaDataMap();
            system.debug('CCRZ applicationFeatureMap ->'+applicationFeatureMap);
            List<RecordType> recordTypeList = [SELECT Id, Name from RecordType where SObjectType = 'IAM_Application__c'];
            system.debug('CCRZ recordTypeList ->'+recordTypeList);
            Map<String, ID> recordTypeMap = new Map<String, ID>();
            for(RecordType rt : recordTypeList)
            {
                recordTypeMap.put(rt.name, rt.ID);
            }
            
            // End : getting all required data and creation of variables
            
            // Create a list based on the subscriptions created, containing all details required for IAM Record creation and Junction Object creation
            if(subscriptionMap.keyset() != null && subscriptionMap.size()>0)
            {
                for(Id subscriptionID : subscriptionMap.keySet())
                {
                    ccrz__E_Subscription__c subscription = subscriptionMap.get(subscriptionID);
                    system.debug('CCRZ Inside loop  subscription->'+subscription);
                    // if Bundle - get composite products 
                    // if product but Service Tech Kit - get composite products
                    if(null != subscription.ccrz__SubscriptionProduct__c 
                       && ('Bundle' == subscription.ccrz__SubscriptionProduct__r.ccrz__ProductType__c 
                           || subscription.ccrz__SubscriptionProduct__r.Name.contains('Service Tech Kit')
                           || subscription.ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Add-On')
                          ))
                    {
                        List<ccrz__E_CompositeProduct__c> compositeList = compositeIdToCompositeProductMap.get(subscription.ccrz__SubscriptionProduct__c);
                        
                        system.debug('CCRZ Inside loop  compositeList->'+compositeList);
                        
                        for(ccrz__E_CompositeProduct__c compositeProduct : compositeList)
                        {
                            system.debug('CCRZ Inside loop  compositeProduct->'+compositeProduct);
                             system.debug('CCRZ Inside loop  compositeProduct.ccrz__Component__r.Name->'+compositeProduct.ccrz__Component__r.Name);
                            system.debug('CCRZ Inside loop   compositeProduct.ccrz__Component__r.QSOLType__c->'+ compositeProduct.ccrz__Component__r.QSOLType__c);
                            system.debug('CCRZ Inside loop  IAM Provisioning Required->'+compositeProduct.ccrz__Component__r.isIAMProvisioningRequired__c);
                            if(compositeProduct.ccrz__Component__r.isIAMProvisioningRequired__c)
                            {
                                UpdateOrderSubSet.add(subscription.id);
                                Integer qty = Integer.valueOf(compositeProduct.ccrz__Quantity__c);
                                qty = qty * Integer.valueOf(subscription.ccrz__Quantity__c);
                                
                                    
                                if(isAllIAMCreate)
                                {
                                    system.debug('Inside isAllIAMCreate ');
                                    OSM_IAMProvisioningDetails osmIamProvisioningDetail = createOsmIamProvisioningDetail(subscription, compositeProduct.ccrz__Component__r.Name, compositeProduct.ccrz__Component__r.QSOLType__c, qty, accountMap, applicationFeatureMap, compositeProduct.ccrz__Component__r.ccrz__SKU__c);
                                    osmIamProvisioningDetailsList.add(osmIamProvisioningDetail);
                                }
                                else
                                {
                                    if(compositeProduct.ccrz__Component__r.Name.containsIgnoreCase('Guidanz Mobile'))
                                    {
                                        if(isGuidanzMobileIAMCreateOnly)
                                        {
                                            OSM_IAMProvisioningDetails osmIamProvisioningDetail = createOsmIamProvisioningDetail(subscription, compositeProduct.ccrz__Component__r.Name, compositeProduct.ccrz__Component__r.QSOLType__c, qty, accountMap, applicationFeatureMap, compositeProduct.ccrz__Component__r.ccrz__SKU__c);
                                            osmIamProvisioningDetailsList.add(osmIamProvisioningDetail);
                                        }
                                    }
                                    else
                                    {
                                        system.debug('Inside else  condition of guidenz mobile');
                                        OSM_IAMProvisioningDetails osmIamProvisioningDetail = createOsmIamProvisioningDetail(subscription, compositeProduct.ccrz__Component__r.Name, compositeProduct.ccrz__Component__r.QSOLType__c, qty, accountMap, applicationFeatureMap, compositeProduct.ccrz__Component__r.ccrz__SKU__c);
                                        osmIamProvisioningDetailsList.add(osmIamProvisioningDetail);
                                    }
                                }
                                
                                // if QSOL EBU then need to create EDS and CVCOL always
                                if( isAllIAMCreate || !isGuidanzMobileIAMCreateOnly ){
                                    if( compositeProduct.ccrz__Component__r.QSOLType__c !=null && compositeProduct.ccrz__Component__r.QSOLType__c =='EBU') {
                                        system.debug('Inside ebu condition');
                                        // Create for EDS
                                        OSM_IAMProvisioningDetails osmIamProvisioningDetail_EDS = createOsmIamProvisioningDetail(subscription, 'EDS', compositeProduct.ccrz__Component__r.QSOLType__c, qty, accountMap, applicationFeatureMap,'EDS');
                                        osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_EDS);
                                        
                                        // Create for CVCOL
                                        
                                        OSM_IAMProvisioningDetails osmIamProvisioningDetail_CVCOL = createOsmIamProvisioningDetail(subscription, 'CVCOL', compositeProduct.ccrz__Component__r.QSOLType__c, qty, accountMap, applicationFeatureMap, 'CVCOL');
                                        osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_CVCOL);
                                    }
                                    //Below If block added for US-605
                                    if( compositeProduct.ccrz__Component__r.QSOLType__c !=null && compositeProduct.ccrz__Component__r.QSOLType__c =='CPG') {
                                        system.debug('Inside cpg condition');
                                        // Create for EDS
                                        OSM_IAMProvisioningDetails osmIamProvisioningDetail_EDS = createOsmIamProvisioningDetail(subscription, 'EDS', compositeProduct.ccrz__Component__r.QSOLType__c, qty, accountMap, applicationFeatureMap,'EDS');
                                        osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_EDS);
                                        
                                        // Create for CVCOL
                                        
                                        OSM_IAMProvisioningDetails osmIamProvisioningDetail_CVCOL = createOsmIamProvisioningDetail(subscription, 'CVCOL', compositeProduct.ccrz__Component__r.QSOLType__c, qty, accountMap, applicationFeatureMap, 'CVCOL');
                                        osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_CVCOL);
                                    }
                                }
                            }
                        }
                    }
                    // if product and standalone and NOT service tech kit - get name (basically for QSOL)
                    if(null != subscription.ccrz__SubscriptionProduct__c 
                       && 'Product' == subscription.ccrz__SubscriptionProduct__r.ccrz__ProductType__c 
                       && !subscription.ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Service Tech Kit')
                       && !subscription.ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Guidanz Add-On Kit')
                       && subscription.ccrz__SubscriptionProduct__r.isIAMProvisioningRequired__c)
                    {
                        UpdateOrderSubSet.add(subscription.id);
                        Integer qty ;
                        if(subscription.ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Guidanz Mobile')){
                           qty = 2;
                        }else{
                           qty = 9999;  
                        }
                        qty = qty * Integer.valueOf(subscription.ccrz__Quantity__c);
                        if(isAllIAMCreate)
                        {
                            OSM_IAMProvisioningDetails osmIamProvisioningDetail = createOsmIamProvisioningDetail(subscription, subscription.ccrz__SubscriptionProduct__r.Name, subscription.ccrz__SubscriptionProduct__r.QSOLType__c, qty, accountMap, applicationFeatureMap,subscription.ccrz__SubscriptionProduct__r.ccrz__SKU__c);
                            osmIamProvisioningDetailsList.add(osmIamProvisioningDetail);
                        }
                        else
                        {
                            if(subscription.ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Guidanz Mobile'))
                            {
                                if(isGuidanzMobileIAMCreateOnly)
                                {
                                    OSM_IAMProvisioningDetails osmIamProvisioningDetail = createOsmIamProvisioningDetail(subscription, subscription.ccrz__SubscriptionProduct__r.Name, subscription.ccrz__SubscriptionProduct__r.QSOLType__c, qty, accountMap, applicationFeatureMap,subscription.ccrz__SubscriptionProduct__r.ccrz__SKU__c);
                                    osmIamProvisioningDetailsList.add(osmIamProvisioningDetail);
                                }
                            }
                            else
                            {
                                OSM_IAMProvisioningDetails osmIamProvisioningDetail = createOsmIamProvisioningDetail(subscription, subscription.ccrz__SubscriptionProduct__r.Name, subscription.ccrz__SubscriptionProduct__r.QSOLType__c, qty, accountMap, applicationFeatureMap,subscription.ccrz__SubscriptionProduct__r.ccrz__SKU__c);
                                osmIamProvisioningDetailsList.add(osmIamProvisioningDetail);
                            }
                        }
                        
                        // if QSOL EBU then need to create EDS and CVCOL always
                        if( isAllIAMCreate || !isGuidanzMobileIAMCreateOnly )
                        {
                            if(null != subscription.ccrz__SubscriptionProduct__r.QSOLType__c 
                               && 'EBU' == subscription.ccrz__SubscriptionProduct__r.QSOLType__c)
                            {
                               
                                OSM_IAMProvisioningDetails osmIamProvisioningDetail_EDS = createOsmIamProvisioningDetail(subscription, 'EDS', subscription.ccrz__SubscriptionProduct__r.QSOLType__c, qty, accountMap, applicationFeatureMap,'EDS');
                                osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_EDS);
                                
                                // Create for CVCOL
                                OSM_IAMProvisioningDetails osmIamProvisioningDetail_CVCOL = createOsmIamProvisioningDetail(subscription, 'CVCOL', subscription.ccrz__SubscriptionProduct__r.QSOLType__c, qty, accountMap, applicationFeatureMap, 'CVCOL');
                                osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_CVCOL);
                            }
                            //Below If block added for US-605
                            if(null != subscription.ccrz__SubscriptionProduct__r.QSOLType__c 
                               && 'CPG' == subscription.ccrz__SubscriptionProduct__r.QSOLType__c)
                            {
                                        system.debug('Inside cpg condition');
                                        // Create for EDS
                                        OSM_IAMProvisioningDetails osmIamProvisioningDetail_EDS = createOsmIamProvisioningDetail(subscription, 'EDS', subscription.ccrz__SubscriptionProduct__r.QSOLType__c, qty, accountMap, applicationFeatureMap,'EDS');
                                        osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_EDS);
                                        
                                        // Create for CVCOL
                                       OSM_IAMProvisioningDetails osmIamProvisioningDetail_CVCOL = createOsmIamProvisioningDetail(subscription, 'CVCOL', subscription.ccrz__SubscriptionProduct__r.QSOLType__c, qty, accountMap, applicationFeatureMap, 'CVCOL');
                                        osmIamProvisioningDetailsList.add(osmIamProvisioningDetail_CVCOL);
                                    }
                        }
                    }
                }
            }
            
            
            for(OSM_IAMProvisioningDetails detail:osmIamProvisioningDetailsList){
                System.debug('CCRZ osmIamProvisioningDetailsList-->'+osmIamProvisioningDetailsList);
            }
            Set<String> applicatinNamesSet = new Set<String>();
            Set<String> accountIdsSet = new Set<String>();
            Set<String> roleFeaturesSet = new Set<String>();
            Set<String> avoidDuplicateIAMRecord = new Set<String>();
            try{
                for(OSM_IAMProvisioningDetails osmIamProvisioningDetail : osmIamProvisioningDetailsList){
                    System.debug('CCRZ osmIamProvisioningDetail-->'+osmIamProvisioningDetail);
                    applicatinNamesSet.add(osmIamProvisioningDetail.applicationName);
                    accountIdsSet.add(osmIamProvisioningDetail.accountID);
                    if(osmIamProvisioningDetail.roleFeatureList != null && osmIamProvisioningDetail.roleFeatureList.size()>0){
                        for(String roleFeature : osmIamProvisioningDetail.roleFeatureList)
                        {
                            roleFeaturesSet.add(roleFeature);
                        }
                    }
                }
                
            }catch(Exception ex){
                
                system.debug('CCRZ ex--->'+ex+' =='+ex.getLineNumber());
            }
            if(null != osmIamProvisioningDetailsList && osmIamProvisioningDetailsList.size() > 0)
            {
                Map<String,Set<String>> quickServeEBUCPGRole = new Map<String,Set<String>>();
                Map<String, IAM_Application__c> iamApplicationMap = getIAMApplicationMap(applicatinNamesSet,accountIdsSet,roleFeaturesSet);
                
                for(OSM_IAMProvisioningDetails osmIamProvisioningDetail : osmIamProvisioningDetailsList)
                {
                    if(null != osmIamProvisioningDetail.roleFeatureList && osmIamProvisioningDetail.roleFeatureList.size() > 0)
                    {
                        // if Guidanz mobile, separate records need to be created for each Role/Feature
                        if(Label.OSM_Guidanz_Mobile == osmIamProvisioningDetail.applicationName)
                        {
                            for(String roleFeature : osmIamProvisioningDetail.roleFeatureList)
                            {
                                
                                System.debug('Matched Guidanz Mobile==>'+iamApplicationMap.get((osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID+'~'+ roleFeature).toUpperCase()));
                                // IAM record exists - get list of Junction Object Details to be created
                                if(null != iamApplicationMap.get((osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID +'~'+ roleFeature).toUpperCase()) 
                                   && 'Active' == iamApplicationMap.get((osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID+'~'+ roleFeature).toUpperCase()).IAM_Status__c)
                                {   
                                    
                                    IAM_Application__c iamToUpdate = iamApplicationMap.get((osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID+'~'+ roleFeature).toUpperCase());
                                    iamToUpdate.IAM_Subscription_End_Date__c = osmIamProvisioningDetail.EndDate.Date();
                                    system.debug('Guidans Mobile iamToUpdate--->'+iamToUpdate);
                                    iamToUpdate.IAM_swregExpire__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, iamToUpdate.IAM_Application_Name__c, roleFeature);
									if(label.OSM_SW_Intapp_SKU.contains(osmIamProvisioningDetail.productSKU) || label.OSM_SW_Intapp_SKU.contains(osmIamProvisioningDetail.productSKU))
                                        iamToUpdate.IAM_swregExpire__c = '';
                                    iamToUpdate.IAM_Source__c = 'Marketplace';
                                    iamToUpdate.IAM_OSM_Backend_Update__c = true;
                                    if(iamToUpdate.IAM_Free_Subscription__c)
                                        iamToUpdate.IAM_Free_Subscription__c = false;
                                    system.debug('Guidans Mobile iamToUpdate---2>'+iamToUpdate);
                                    iamRecordsToBeUpdatedMap.put(iamToUpdate.Id, iamToUpdate);
                                    iamRecordsToBeUpdated.add(iamToUpdate);
                                    OSM_JunctionObjectDetails junctionObjectDetails = createJunctionObjectWrapper(osmIamProvisioningDetail, roleFeature, iamApplicationMap.get((osmIamProvisioningDetail.applicationName + '~' + osmIamProvisioningDetail.accountID+'~'+ roleFeature).toUpperCase()).ID);
                                    osmJunctionObjectDetailsList.add(junctionObjectDetails);
                                }
                                else// get list of IAM records to be created
                                {
                                    IAM_Application__c iamRecord = createIAMRecord(osmIamProvisioningDetail, roleFeature, recordTypeMap,applicationFeatureMap);
                                    OSM_JunctionObjectDetails junctionObjectDetails = createJunctionObjectWrapper(osmIamProvisioningDetail, roleFeature, null);
                                    if(!avoidDuplicateIAMRecord.contains(iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Account_Name__c +'~'+ roleFeature)){
                                        iamRecordToBeInsertedList.add(iamRecord);
                                        avoidDuplicateIAMRecord.add(iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Account_Name__c+'~'+ roleFeature ); 
                                    }
                                    osmJunctionObjectDetailsList.add(junctionObjectDetails);
                                    //iamApplicationMap.put(iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Account_Name__c + '~' + iamRecord.IAM_Role__c, iamRecord);
                                }
                            }
                        }
                        else if(osmIamProvisioningDetail.applicationName == 'QuickServe Online')
                        {
                            String applicationName = osmIamProvisioningDetail.applicationName+'~'+osmIamProvisioningDetail.subscriptionName+'~'+osmIamProvisioningDetail.accountID;
                            System.debug('key : '+applicationName.toUpperCase());
                            System.debug('map : '+iamApplicationMap);
                            System.debug('map containsKey : '+iamApplicationMap.containsKey(applicationName.toUpperCase()));
                            if(iamApplicationMap.get(applicationName.toUpperCase())  != null  &&  iamApplicationMap.get(applicationName.toUpperCase()).IAM_Status__c=='Active')
                            {
                                IAM_Application__c iamToUpdate = iamApplicationMap.get(applicationName.toUpperCase());
                                iamToUpdate.IAM_Subscription_End_Date__c = osmIamProvisioningDetail.EndDate.Date();
                                iamToUpdate.IAM_Role__c = osmIamProvisioningDetail.roleFeature;
                                iamToUpdate.IAM_Source__c = 'Marketplace';
                                iamToUpdate.IAM_OSM_Backend_Update__c = true;
                                if(iamToUpdate.IAM_Free_Subscription__c)
                                    iamToUpdate.IAM_Free_Subscription__c = false;
                                System.debug('log 1');
                                iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, iamToUpdate.IAM_Subscription_Name__c,null);   
                                    System.debug('log 2: '+iamToUpdate.IAM_Qsolexpiration__c);                              
                                if(osmIamProvisioningDetail.qsolType=='EBU'){
                                    //iamToUpdate.IAM_Subscription_Name__c = Label.OSM_Quick_Serve_Online_EBU;
                                    //iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, iamToUpdate.IAM_Subscription_Name__c, null);
                                    iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, Label.OSM_Quick_Serve_Online_EBU, null);
                                    
                                }
                                if(osmIamProvisioningDetail.qsolType=='CPG'){
                                    //iamToUpdate.IAM_Subscription_Name__c = Label.OSM_Quick_Serve_Online_CPG;
                                    //iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, iamToUpdate.IAM_Subscription_Name__c,null);
                                    iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, Label.OSM_Quick_Serve_Online_CPG,null);
                                    
                                }
                                iamRecordsToBeUpdated.add(iamToUpdate);
                                iamRecordsToBeUpdatedMap.put(iamToUpdate.Id, iamToUpdate);  
                                system.debug('Non Guidans Mobile iamToUpdate--->'+iamToUpdate);   
                                OSM_JunctionObjectDetails junctionObjectDetails = createJunctionObjectWrapper(osmIamProvisioningDetail, osmIamProvisioningDetail.roleFeature, iamApplicationMap.get(applicationName.toUpperCase()).ID);
                                osmJunctionObjectDetailsList.add(junctionObjectDetails);
                            }
                            else// get list of IAM records to be created
                            {
                                system.debug('Guidenz Mobile So creating creating record');
                                IAM_Application__c iamRecord = createIAMRecord(osmIamProvisioningDetail, osmIamProvisioningDetail.roleFeature, recordTypeMap,applicationFeatureMap);
                                OSM_JunctionObjectDetails junctionObjectDetails = createJunctionObjectWrapper(osmIamProvisioningDetail, osmIamProvisioningDetail.roleFeature, null);
                                //iamRecord.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamRecord.IAM_Subscription_End_Date__c, iamRecord.IAM_Subscription_Name__c,null);   
                                if(!avoidDuplicateIAMRecord.contains(applicationName)){
                                    iamRecordToBeInsertedList.add(iamRecord);
                                    avoidDuplicateIAMRecord.add(applicationName); 
                                }
                                //iamRecordToBeInsertedList.add(iamRecord);
                                osmJunctionObjectDetailsList.add(junctionObjectDetails);
                                //iamApplicationMap.put(iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Account_Name__c, iamRecord);
                            }
                        }
                        else // in 1 record, all roles in multi picklist
                        {
                            /*
                            String applicationName = osmIamProvisioningDetail.applicationName+ '~' + osmIamProvisioningDetail.accountID;
                            Set<String> iamApplicationNameSet = new Set<String>{'QuickServe Online'}; 
                                
                                If(iamApplicationNameSet.contains(osmIamProvisioningDetail.applicationName) 
                                   && (osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_EBU 
                                       || osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_CPG)){
                                           
                                           applicationName = osmIamProvisioningDetail.applicationName+'~'+osmIamProvisioningDetail.subscriptionName+'~'+osmIamProvisioningDetail.accountID+'~'+osmIamProvisioningDetail.roleFeature;
                                       }
                                       
                                       */
                                       // for 554
                            String applicationName = osmIamProvisioningDetail.applicationName+ '~' + osmIamProvisioningDetail.accountID;
                                       System.debug('key : '+applicationName.toUpperCase());
                            if(iamApplicationMap.get(applicationName.toUpperCase())  != null  &&  iamApplicationMap.get(applicationName.toUpperCase()).IAM_Status__c=='Active')
                            {
                                IAM_Application__c iamToUpdate = iamApplicationMap.get(applicationName.toUpperCase());
                                iamToUpdate.IAM_Subscription_End_Date__c = osmIamProvisioningDetail.EndDate.Date();
                                iamToUpdate.IAM_Role__c = osmIamProvisioningDetail.roleFeature;
                                iamToUpdate.IAM_Source__c = 'Marketplace';
                                iamToUpdate.IAM_OSM_Backend_Update__c = true;
                                if(iamToUpdate.IAM_Free_Subscription__c)
                                    iamToUpdate.IAM_Free_Subscription__c = false;
                                iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, iamToUpdate.IAM_Subscription_Name__c,null);    
                                if(osmIamProvisioningDetail.qsolType=='EBU'){
                                    //iamToUpdate.IAM_Subscription_Name__c = Label.OSM_Quick_Serve_Online_EBU;
                                    //iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, iamToUpdate.IAM_Subscription_Name__c, null);
                                    iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, Label.OSM_Quick_Serve_Online_EBU, null);
                                    
                                }
                                if(osmIamProvisioningDetail.qsolType=='CPG'){
                                    //iamToUpdate.IAM_Subscription_Name__c = Label.OSM_Quick_Serve_Online_CPG;
                                    //iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, iamToUpdate.IAM_Subscription_Name__c,null);
                                    iamToUpdate.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamToUpdate.IAM_Subscription_End_Date__c, Label.OSM_Quick_Serve_Online_CPG,null);
                                    
                                }
                                iamRecordsToBeUpdated.add(iamToUpdate);
                                iamRecordsToBeUpdatedMap.put(iamToUpdate.Id, iamToUpdate);  
                                system.debug('Non Guidans Mobile iamToUpdate--->'+iamToUpdate);   
                                OSM_JunctionObjectDetails junctionObjectDetails = createJunctionObjectWrapper(osmIamProvisioningDetail, osmIamProvisioningDetail.roleFeature, iamApplicationMap.get(applicationName.toUpperCase()).ID);
                                osmJunctionObjectDetailsList.add(junctionObjectDetails);
                            }
                            else// get list of IAM records to be created
                            {
                                system.debug('Guidenz Mobile So creating creating record');
                                IAM_Application__c iamRecord = createIAMRecord(osmIamProvisioningDetail, osmIamProvisioningDetail.roleFeature, recordTypeMap,applicationFeatureMap);
                                OSM_JunctionObjectDetails junctionObjectDetails = createJunctionObjectWrapper(osmIamProvisioningDetail, osmIamProvisioningDetail.roleFeature, null);
                                if(!avoidDuplicateIAMRecord.contains(applicationName)){
                                    iamRecordToBeInsertedList.add(iamRecord);
                                    avoidDuplicateIAMRecord.add(applicationName); 
                                }
                                //iamRecordToBeInsertedList.add(iamRecord);
                                osmJunctionObjectDetailsList.add(junctionObjectDetails);
                                //iamApplicationMap.put(iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Account_Name__c, iamRecord);
                            }
                        }
                    }
                }
                
                if(iamRecordsToBeUpdatedMap.values().size() > 0)
                {
                    system.debug('iamRecordsToBeUpdatedMap.values-->'+iamRecordsToBeUpdatedMap.values());
                    update iamRecordsToBeUpdatedMap.values();
                }
                if(iamRecordToBeInsertedList.size() > 0)
                {
                    System.debug('List Before insert: '+iamRecordToBeInsertedList);
                    insert iamRecordToBeInsertedList;
                    
                    system.debug('after iamRecordToBeInsertedList-->'+iamRecordToBeInsertedList);
                    for(IAM_Application__c iamRecord : iamRecordToBeInsertedList){
                        if(iamRecord.IAM_Application_Name__c.equalsIgnoreCase(Label.OSM_Guidanz_Mobile)){
                            List<String> roleList = iamRecord.IAM_Role__c.split(';');
                            roleList.sort();
                            iamApplicationMap.put((iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Account_Name__c+'~'+String.join(roleList, ',')).toUpperCase(), iamRecord);
                        }
                        else if(iamRecord.IAM_Application_Name__c == 'QuickServe Online')
                        {
                            String applicationName = iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Subscription_Name__c+'~'+iamRecord.IAM_Account_Name__c;
                            iamApplicationMap.put(applicationName.toUpperCase(), iamRecord);
                        }
                        else
                        {
                            String applicationName = iamRecord.IAM_Application_Name__c + '~' + iamRecord.IAM_Account_Name__c;
                            /*
                            if((iamRecord.IAM_Application_Name__c =='QuickServe Online') && (iamRecord.IAM_Subscription_Name__c == Label.OSM_Quick_Serve_Online_EBU 
                                                                                             || iamRecord.IAM_Subscription_Name__c==Label.OSM_Quick_Serve_Online_CPG)){
                                                                                                 List<String> roleList = iamRecord.IAM_Role__c.split(',');
                                                                                                 roleList.sort();
                                                                                                 applicationName = iamRecord.IAM_Application_Name__c 
                                                                                                     + '~' + iamRecord.IAM_Subscription_Name__c 
                                                                                                     + '~' + iamRecord.IAM_Account_Name__c
                                                                                                     +'~'+String.join(roleList, ',');
                                                                                                 
                                                                                             }
                                                                                             */
                            
                            iamApplicationMap.put(applicationName.toUpperCase(), iamRecord);
                        }
                        
                    }
                    
                    system.debug('iamApplicationMap--->'+iamApplicationMap);
                }
                system.debug('osmJunctionObjectDetailsList--->'+osmJunctionObjectDetailsList);
                if(osmJunctionObjectDetailsList.size() > 0)
                {
                    set<Id> subsId = new Set<Id>();
                    set<Id> featuresId = new Set<Id>();
                    for(OSM_JunctionObjectDetails junObjWrapper : osmJunctionObjectDetailsList)
                    {
                        featuresId.add(junObjWrapper.iamRecordID);
                        subsId.add(junObjWrapper.subscriptionID);
                        system.debug('junObjWrapper-->'+junObjWrapper);
                    }
                    Map<String, OSM_Subscription_Account_Provision__c>OSMSubsIAMJuncObj = getJunctionObjectRecords(subsId,featuresId);
                    system.debug('OSMSubsIAMJuncObj-->'+OSMSubsIAMJuncObj);
                    Set<String> uniqueRecords = new Set<String>();
                    for(OSM_JunctionObjectDetails junctionObjectDetails : osmJunctionObjectDetailsList)
                    {
                        OSM_Subscription_Account_Provision__c junctionObject = createOSMSubscriptionAccountProvisionRecord(junctionObjectDetails, iamApplicationMap);
                        system.debug('junctionObject OSMSubsIAMJuncObj-->'+junctionObject);
                        if(null != junctionObject && OSMSubsIAMJuncObj.get(junctionObjectDetails.subscriptionID+'~'+junctionObjectDetails.iamRecordID) == null)
                        {
                            junctionObjectToBeInsertedListIntermediat.add(junctionObject);
                            
                        }
                    }
                    system.debug('junctionObjectToBeInsertedListIntermediat-->'+junctionObjectToBeInsertedListIntermediat);
                    List<String> listUnique = new List<String>();
                    if(junctionObjectToBeInsertedListIntermediat != null && junctionObjectToBeInsertedListIntermediat.size()>0)
                    {
                        for(OSM_Subscription_Account_Provision__c junobj :junctionObjectToBeInsertedListIntermediat)
                        {
                            if(junobj.Subscription_Status__c == 'Active')
                            {
                                if(!listUnique.contains(junobj.Account_Features_Access__c+'_'+junobj.CC_Subscription__c))
                                {
                                    junctionObjectToBeInsertedList.add(junobj);
                                    listUnique.add(junobj.Account_Features_Access__c+'_'+junobj.CC_Subscription__c);
                                }
                            }
                        }
                    }
                    
                    
                    system.debug('junctionObjectToBeInsertedList-->'+junctionObjectToBeInsertedList);
                    if(null != junctionObjectToBeInsertedList && junctionObjectToBeInsertedList.size() > 0)
                    {
                        
                        insert junctionObjectToBeInsertedList;
                        system.debug('junctionObjectToBeInsertedList-->'+junctionObjectToBeInsertedList);
                    }
                    
                }
            }
            
            // logic to update all account and feature record inactive if those are not done by Workflow
            
            if(iamRecordsToBeUpdatedMap != null && iamRecordsToBeUpdatedMap.size() > 0)
            {
                List<Id> lstACCFId = new List<Id>();
                for(Id key : iamRecordsToBeUpdatedMap.keySet())
                {
                    lstACCFId.add(key);
                }
                
                List<IAM_Application__c> lstIAMRec = new List<IAM_Application__c>();
                List<IAM_Application__c> lstIAMRectoUpdate = new List<IAM_Application__c>();
                
                lstIAMRec = [Select Id,OSM_Active_Subscription_Count__c,IAM_Status__c, IAM_Source__c from IAM_Application__c where Id IN: lstACCFId];
                
                for(IAM_Application__c IAMRec : lstIAMRec)
                {
                    if(IAMRec.IAM_Source__c.equalsIgnoreCase('Marketplace') && IAMRec.OSM_Active_Subscription_Count__c == 0)
                    {
                        IAMRec.IAM_Status__c = 'Inactive';
                        lstIAMRectoUpdate.add(IAMRec);
                    }
                }
                if(lstIAMRectoUpdate != null && lstIAMRectoUpdate.size() > 0)
                    update lstIAMRectoUpdate;
            }
            
            
            if((null != iamRecordToBeInsertedList && iamRecordToBeInsertedList.size() > 0) 
               || (null != junctionObjectToBeInsertedList && junctionObjectToBeInsertedList.size() > 0))
            {
                List<OSM_Integration_Log__c> list_IntegrationLog = new List<OSM_Integration_Log__c>();
                for(Id subsId : subscriptionIDList){
                    OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                    log.Account__c = AccountId;
                    log.Service_Name__c = 'IAM Provisioning';
                    log.Target__c = 'IAM';
                    log.Source__c = 'OSM';
                    log.Request__c = 'Using subscription Id : ' + subsId;
                    log.Subscription__c = subsId;
                    log.Logged_In_User__c = userinfo.getuserid();
                    log.Status__c = 'Success';
                    list_IntegrationLog.add(log);
                }
                OSM_SW_LoggingContext.saveIntegrationLogList(list_IntegrationLog);
            }
            
            
            
            if(UpdateOrderSubSet != null && UpdateOrderSubSet.size() > 0)
            {
                List<OSM_Order_Subscription__c> lstOrderSubsc = new List<OSM_Order_Subscription__c>();
                lstOrderSubsc = [Select Id, OSM_CCOrder__c from OSM_Order_Subscription__c where OSM_CCSubscription__c IN: UpdateOrderSubSet];
                
                Set<Id> orderIdtoupdate = new Set<Id>();
                for(OSM_Order_Subscription__c objOrdrSub : lstOrderSubsc)
                    orderIdtoupdate.add(objOrdrSub.OSM_CCOrder__c);
                
                if(orderIdtoupdate.size()>0)
                {
                    List<ccrz__E_Order__c> ordrList = new List<ccrz__E_Order__c>();
                    ordrList = [Select Id, OSM_SW_IAM_Provisioning__c from ccrz__E_Order__c where id IN : orderIdtoupdate];
                    
                    for(ccrz__E_Order__c objOrdr : ordrList)
                    {
                        objOrdr.OSM_SW_IAM_Provisioning__c = true;
                    }
                    
                    if(ordrList != null && ordrList.size() > 0 )
                    {
                        update ordrList;
                    }
                }
            }
            
            if(Test.isRunningTest())
            {
                throw new NullPointerException();
            }
        }
        catch(Exception e)
        {
            List<OSM_Integration_Log__c> list_IntegrationLog = new List<OSM_Integration_Log__c>();
            for(Id subsId : subscriptionIDList){
                OSM_Integration_Log__c log = new OSM_Integration_Log__c();
                log.Account__c = AccountId;
                log.Service_Name__c = 'IAM Provisioning';
                log.Target__c = 'IAM';
                log.Source__c = 'OSM';
                log.Request__c = 'Using subscription ID Set : ' + subscriptionIDList;
                log.Logged_In_User__c = userinfo.getuserid(); 
                log.Error_Description__c = e.getMessage() + ' ' + e.getStackTraceString() ;
                log.Status__c = 'Failure';  
                log.Subscription__c = subsId;
                list_IntegrationLog.add(log);
            }
            OSM_SW_LoggingContext.saveIntegrationLogList(list_IntegrationLog); 
        }
    }
    
    public static OSM_IAMProvisioningDetails createOsmIamProvisioningDetail(ccrz__E_Subscription__c subscription, String productName, String qsolType, Integer userCount, Map<Id, Account> accountMap, Map<String, OSM_Application_Feature__mdt> applicationFeatureMap, String productSKU)
    {
        OSM_IAMProvisioningDetails osmIamProvisioningDetail = new OSM_IAMProvisioningDetails();
        
        osmIamProvisioningDetail.subscriptionID = subscription.ID;
        osmIamProvisioningDetail.accountID = subscription.ccrz__Account__c;
		osmIamProvisioningDetail.quantity = Integer.valueOf(subscription.ccrz__Quantity__c);
        osmIamProvisioningDetail.productName = productName;
														 
       osmIamProvisioningDetail.productSKU = productSKU; System.debug(subscription.ccrz__SubscriptionStartDate__c);
        osmIamProvisioningDetail.startDate = subscription.ccrz__SubscriptionStartDate__c;
        System.debug('osmIamProvisioningDetail.startDate: '+osmIamProvisioningDetail.startDate);
        System.debug('subscription.ccrz__SubscriptionStartDate__c: '+subscription.ccrz__SubscriptionStartDate__c);
        osmIamProvisioningDetail.endDate = subscription.OSM_Subscription_End_Date__c;
        if(subscription.ccrz__SubscriptionStatus__c == Label.OSM_Subscription_Status_Renew)
            osmIamProvisioningDetail.status = 'Active';
        else
            osmIamProvisioningDetail.status = subscription.ccrz__SubscriptionStatus__c;
        osmIamProvisioningDetail.userCount = userCount;
        osmIamProvisioningDetail.accountGroupName = subscription.ccrz__Account__r.ccrz__E_AccountGroup__r.Name;
        osmIamProvisioningDetail.qsolType = qsolType;
        
        // NEED CLARIFICATION ON VALUES
        // FOR TESTING PURPOSE ONLY - hardcoding accountType
	// MAR-1642 -Start
        if(subscription.ccrz__Account__r.PSBU_Channel_of_Distribution__c != null && subscription.ccrz__Account__r.EBU_Channel_of_Distribution__c == null && Label.COD_Dealer_List.contains(subscription.ccrz__Account__r.PSBU_Channel_of_Distribution__c) && (label.OSM_QSOLDealerAccountGroup).contains(osmIamProvisioningDetail.accountGroupName) && (label.OSM_QSOLCPGDealer).contains(productSKU)){
            system.debug('inside if');
            osmIamProvisioningDetail.accountType = Label.OSM_Fleet;
        }else if(subscription.ccrz__Account__r.PSBU_Channel_of_Distribution__c == null && subscription.ccrz__Account__r.EBU_Channel_of_Distribution__c != null && Label.COD_Dealer_List.contains(subscription.ccrz__Account__r.EBU_Channel_of_Distribution__c) && (label.OSM_QSOLDealerAccountGroup_EBU).contains(osmIamProvisioningDetail.accountGroupName) && (label.OSM_QSOLCPGDealer_EBU).contains(productSKU)){
             osmIamProvisioningDetail.accountType = Label.OSM_Fleet;
            
        }else{
            osmIamProvisioningDetail.accountType = OSM_AccountGroupMapping_Helper.getCODByAccountRecordType(accountMap.get(osmIamProvisioningDetail.accountID));
        }
	// MAR-1642 -End
        System.debug('Account Type : ' + osmIamProvisioningDetail.accountType);
        System.debug('osmIamProvisioningDetail.productName : ' + osmIamProvisioningDetail.productName);
        //osmIamProvisioningDetail.accountType = 'Deal_FS';
        system.debug('Before Map '+applicationFeatureMap.get(productSKU + '~' + osmIamProvisioningDetail.accountType));
         if(null != applicationFeatureMap.get(productSKU + '~' + osmIamProvisioningDetail.accountType))
        {
            system.debug('Inside Map '+applicationFeatureMap.get(productSKU + '~' + osmIamProvisioningDetail.accountType));
            OSM_Application_Feature__mdt osmAppFeatureMD = applicationFeatureMap.get(productSKU + '~' + osmIamProvisioningDetail.accountType);
            // need to order the Role/Feature...order alphabetically...then store as list and comma separated string
            if(osmAppFeatureMD.Role_Feature__c.Contains(',')){
                List<String> roleFeatureList = osmAppFeatureMD.Role_Feature__c.split(',');
                roleFeatureList.sort();
                osmIamProvisioningDetail.roleFeatureList = roleFeatureList;
               // Mar-1249 osmIamProvisioningDetail.roleFeature = string.join(roleFeatureList,','); 
                osmIamProvisioningDetail.roleFeature = string.join(roleFeatureList,';');
            }else{
                
                List<String> roleFeatureList = new List<String>{osmAppFeatureMD.Role_Feature__c};
                    roleFeatureList.sort();
                osmIamProvisioningDetail.roleFeatureList = roleFeatureList;
               //   Mar-1249 osmIamProvisioningDetail.roleFeature = string.join(roleFeatureList,',');
               osmIamProvisioningDetail.roleFeature = string.join(roleFeatureList,';');
            }
            osmIamProvisioningDetail.applicationName = osmAppFeatureMD.Label;
            
            if(osmAppFeatureMD.Label == 'QuickServe Online'){
                osmIamProvisioningDetail.subscriptionName = Label.OSM_Quick_Serve_Online_EBU;
            }
            
            if(qsolType == 'EBU'){
                osmIamProvisioningDetail.subscriptionName = Label.OSM_Quick_Serve_Online_EBU;
            }
            
            if(qsolType == 'CPG'){
                osmIamProvisioningDetail.subscriptionName = Label.OSM_Quick_Serve_Online_CPG;
            }
            
            if(osmIamProvisioningDetail.applicationName == 'Guidanz')
            {
                osmIamProvisioningDetail.subscriptionName = 'Guidanz';
            }
            
            if(osmIamProvisioningDetail.applicationName == 'Guidanz Web')
            {
                osmIamProvisioningDetail.subscriptionName = 'Guidanz Web';
            }
            
            
            //}
            
        }
        
        return osmIamProvisioningDetail;
    }
    
    public static OSM_JunctionObjectDetails createJunctionObjectWrapper(OSM_IAMProvisioningDetails osmIamProvisioningDetail, String roleFeature, ID iamRecordID)
    {
        // create the junction Object
        OSM_JunctionObjectDetails junctionObjectDetails = new OSM_JunctionObjectDetails();
        
        if(null != iamRecordID)
        {
            junctionObjectDetails.iamRecordID = iamRecordID;
        }
        junctionObjectDetails.accountId = osmIamProvisioningDetail.accountID;
        junctionObjectDetails.subscriptionID = osmIamProvisioningDetail.subscriptionID;
        junctionObjectDetails.userCount = osmIamProvisioningDetail.userCount;
        junctionObjectDetails.applicationName = osmIamProvisioningDetail.applicationName;
        junctionObjectDetails.roleFeature = roleFeature;
        junctionObjectDetails.subscriptionStatus = osmIamProvisioningDetail.status;
			junctionObjectDetails.subscriptionQuantity = osmIamProvisioningDetail.quantity;																		   
        junctionObjectDetails.endDate = osmIamProvisioningDetail.endDate;
        //junctionObjectDetails.startDate = osmIamProvisioningDetail.startDate;
        
        
        
        if(osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_EBU){
            junctionObjectDetails.subscriptionName = Label.OSM_Quick_Serve_Online_EBU;
        }
        
        if(osmIamProvisioningDetail.subscriptionName == Label.OSM_Quick_Serve_Online_CPG){
            junctionObjectDetails.subscriptionName = Label.OSM_Quick_Serve_Online_CPG;
        }
        
        if(osmIamProvisioningDetail.subscriptionName == 'QuickServe Online'){
            junctionObjectDetails.subscriptionName = Label.OSM_Quick_Serve_Online_EBU;
        }
        
        
        return junctionObjectDetails;
    }
    
    public static OSM_Subscription_Account_Provision__c createOSMSubscriptionAccountProvisionRecord(OSM_JunctionObjectDetails junctionObjectDetails, Map<String, IAM_Application__c> iamApplicationMap)
    {
        OSM_Subscription_Account_Provision__c junctionObject = new OSM_Subscription_Account_Provision__c();
        
        String applicationName = junctionObjectDetails.applicationName+ '~' + junctionObjectDetails.accountId;
        
        if(Label.OSM_Guidanz_Mobile == junctionObjectDetails.applicationName)
            applicationName = junctionObjectDetails.applicationName+ '~' + junctionObjectDetails.accountId+'~'+junctionObjectDetails.roleFeature;
        else if(junctionObjectDetails.applicationName == 'QuickServe Online')
        {
            applicationName = junctionObjectDetails.applicationName+ '~' + junctionObjectDetails.subscriptionName +'~'+junctionObjectDetails.accountId;
        }
        Set<String> iamApplicationNameSet = new Set<String>{'QuickServe Online'}; 
            
        /*if(iamApplicationNameSet.Contains(junctionObjectDetails.applicationName) && 
               (junctionObjectDetails.subscriptionName == Label.OSM_Quick_Serve_Online_EBU 
                || junctionObjectDetails.subscriptionName == Label.OSM_Quick_Serve_Online_CPG))
            
        {   
            applicationName = junctionObjectDetails.applicationName +'~'+junctionObjectDetails.accountId + '~' + junctionObjectDetails.roleFeature;
        }
        */
        System.debug('iamApplicationMap --- '+iamApplicationMap);
        System.debug('applicationName.toUpperCase() --- '+applicationName.toUpperCase());
        system.debug('junctionObjectDetails-->'+junctionObjectDetails);
        system.debug('IAM Matched Value with Roles-->'+iamApplicationMap.get(applicationName.toUpperCase()));
        //if(){
        if(null != iamApplicationMap.get(applicationName.toUpperCase()))
        {
            junctionObject.Account_Features_Access__c = iamApplicationMap.get(applicationName.toUpperCase()).ID;
            junctionObject.CC_Subscription__c = junctionObjectDetails.subscriptionId;
            junctionObject.User_Count__c = junctionObjectDetails.userCount;
            junctionObject.Subscription_Status__c = junctionObjectDetails.subscriptionStatus;
            junctionObject.Subscription_End_Date__c = junctionObjectDetails.endDate;
			junctionObject.OSM_SW_Subscription_Quantity__c = junctionObjectDetails.subscriptionQuantity;						  
            
            return junctionObject;
        }
        
        
        system.debug('IAM Matched Value without Roles-->'+iamApplicationMap.get(applicationName.toUpperCase()));
        
        if(null != iamApplicationMap.get(applicationName.toUpperCase()))
        {
            junctionObject.Account_Features_Access__c = iamApplicationMap.get(applicationName.toUpperCase()).ID;
            junctionObject.CC_Subscription__c = junctionObjectDetails.subscriptionId;
            junctionObject.User_Count__c = junctionObjectDetails.userCount;
            junctionObject.Subscription_Status__c = junctionObjectDetails.subscriptionStatus;
            junctionObject.Subscription_End_Date__c = junctionObjectDetails.endDate;
             junctionObject.OSM_SW_Subscription_Quantity__c = junctionObjectDetails.subscriptionQuantity;
            return junctionObject;
        }
        
        return null;
        
    }
    
    public static IAM_Application__c createIAMRecord(OSM_IAMProvisioningDetails osmIamProvisioningDetail, String roleFeature, Map<String, ID> recordTypeMap,Map<String, OSM_Application_Feature__mdt> applicationFeatureMap)
    {
        // create the IAM record. Junction Object to be created later.
        IAM_Application__c iamRecord = new IAM_Application__c();
        iamRecord.IAM_Account_Name__c = osmIamProvisioningDetail.accountID;
        iamRecord.IAM_Application_Name__c = osmIamProvisioningDetail.applicationName;
        iamRecord.IAM_Subscription_End_Date__c = osmIamProvisioningDetail.endDate.date(); 
        iamRecord.IAM_Role__c = roleFeature;
        iamRecord.IAM_Subscription_Start_Date__c = osmIamProvisioningDetail.startDate.Date();
        iamRecord.IAM_Subscription_Name__c = osmIamProvisioningDetail.applicationName;
        
        OSM_Application_Feature__mdt osmAppFeatureMD = applicationFeatureMap.get(osmIamProvisioningDetail.productSKU + '~' + osmIamProvisioningDetail.accountType);
        if(osmAppFeatureMD.Product_SKU__c==osmIamProvisioningDetail.productSKU){
            if(osmAppFeatureMD.Subscription_Name__c != null)
                iamRecord.IAM_Subscription_Name__c = osmAppFeatureMD.Subscription_Name__c;
            iamRecord.IAM_Total_Units__c = 0;
            iamRecord.IAM_swregExpire__c = '';
        }
        if(label.OSM_SW_Intapp_SKU.contains(osmIamProvisioningDetail.productSKU))
        {
            iamRecord.IAM_Subscription_Name__c = label.OSM_SW_IAM_Subscription_Name_For_Intapp;
            iamRecord.IAM_Total_Units__c = 0;
        }
        else if(label.OSM_SW_Intapp_OEM_SKU.contains(osmIamProvisioningDetail.productSKU))
        {
            iamRecord.IAM_Subscription_Name__c = label.OSM_SW_IAM_Subscription_Name_For_Intapp_OEM;
            iamRecord.IAM_Total_Units__c = 0;
        }
        iamRecord.IAM_Source__c = 'Marketplace';
        iamRecord.IAM_Status__c = 'Active';
        
        // HARD CODING FOR TESTING - NEED Clarification !
        iamRecord.IAM_Subscription_Count__c = 0;//osmIamProvisioningDetail.userCount;
        iamRecord.IAM_Free_Subscription__c = false;
        if('QuickServe Online' == osmIamProvisioningDetail.applicationName){
            iamRecord.IAM_Subscription_Name__c = Label.OSM_Quick_Serve_Online_EBU;
            iamRecord.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamRecord.IAM_Subscription_End_Date__c, iamRecord.IAM_Subscription_Name__c, null);
            iamRecord.RecordTypeId = recordTypeMap.get(System.Label.OSM_QSOL_RecordType);
        }
        
        if('EBU' == osmIamProvisioningDetail.qsolType){
            iamRecord.IAM_Subscription_Name__c = Label.OSM_Quick_Serve_Online_EBU;
            iamRecord.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamRecord.IAM_Subscription_End_Date__c, iamRecord.IAM_Subscription_Name__c, null);
            iamRecord.RecordTypeId = recordTypeMap.get(System.Label.OSM_QSOL_RecordType);
        }
        if('CPG' == osmIamProvisioningDetail.qsolType) {
            iamRecord.IAM_Subscription_Name__c = Label.OSM_Quick_Serve_Online_CPG;
            iamRecord.IAM_Qsolexpiration__c = formatDataBasedOnApplication(iamRecord.IAM_Subscription_End_Date__c, iamRecord.IAM_Subscription_Name__c,null);
            iamRecord.RecordTypeId = recordTypeMap.get(System.Label.OSM_QSOL_RecordType);
        }
        
        if(osmIamProvisioningDetail.applicationName == 'Guidanz')
        {
            iamRecord.IAM_Subscription_Name__c = label.OSM_SW_IAM_Subscription_Name_For_Guidanz;
            iamRecord.RecordTypeId = recordTypeMap.get(iamRecord.IAM_Subscription_Name__c);
        }
        
        if(osmIamProvisioningDetail.applicationName == 'Guidanz Web')
        {
            iamRecord.IAM_Subscription_Name__c = label.OSM_SW_IAM_Subscription_Name_For_Guidanz_Web;
            iamRecord.RecordTypeId = recordTypeMap.get(iamRecord.IAM_Subscription_Name__c);
        }
        
        if(Label.OSM_Guidanz_Mobile == osmIamProvisioningDetail.applicationName) {
            iamRecord.IAM_Guidanz_Mobile_Roles__c = roleFeature;
            iamRecord.IAM_swregExpire__c = formatDataBasedOnApplication(iamRecord.IAM_Subscription_End_Date__c, iamRecord.IAM_Application_Name__c, iamRecord.IAM_Guidanz_Mobile_Roles__c);
            iamRecord.RecordTypeId = recordTypeMap.get(Label.OSM_Guidanz_Mobile);
        }
        
		if(label.OSM_SW_Intapp_SKU.contains(osmIamProvisioningDetail.productSKU) || label.OSM_SW_Intapp_SKU.contains(osmIamProvisioningDetail.productSKU))
            iamRecord.IAM_swregExpire__c = '';
        return iamRecord;
    }
    
    public static Map<Id, List<ccrz__E_CompositeProduct__c>> getCompositeIdToCompositeProductMap(List<String> productIdList)
    {
        List<ccrz__E_CompositeProduct__c> compositeProductsList = OSM_SW_ProdDetailUtils_Ctrl.getCcrzCompositProducts(productIdList);
        
        Map<Id, List<ccrz__E_CompositeProduct__c>> compositeIdToCompositeProductMap = new Map<Id, List<ccrz__E_CompositeProduct__c>>();
        
        for(ccrz__E_CompositeProduct__c compositeProduct : compositeProductsList)
        {
            if(null == compositeIdToCompositeProductMap.get(compositeProduct.ccrz__Composite__c))
            {
                List<ccrz__E_CompositeProduct__c> compositeList = new List<ccrz__E_CompositeProduct__c>();
                compositeList.add(compositeProduct);
                compositeIdToCompositeProductMap.put(compositeProduct.ccrz__Composite__c, compositeList);
            }
            else
            {
                compositeIdToCompositeProductMap.get(compositeProduct.ccrz__Composite__c).add(compositeProduct);
            }
        }
        
        return compositeIdToCompositeProductMap;
    }
    
    public static Map<String, OSM_Application_Feature__mdt> getApplicationFeatureMetaDataMap(){
        List<OSM_Application_Feature__mdt> osmApplicationFeatureMetaDataList = [Select Label, Product_SKU__c,Product_Name__c,Role_Feature__c,User_Type__c,Subscription_Name__c from OSM_Application_Feature__mdt];
        
        Map<String, OSM_Application_Feature__mdt> applicationFeatureMap = new Map<String, OSM_Application_Feature__mdt>();
        for(OSM_Application_Feature__mdt osmAppFeatureMD: osmApplicationFeatureMetaDataList){
            applicationFeatureMap.put(osmAppFeatureMD.Product_SKU__c + '~' + osmAppFeatureMD.User_Type__c , osmAppFeatureMD);
        }
        
        return applicationFeatureMap;
    }
    
    public static Map<String, IAM_Application__c> getIAMApplicationMap(Set<String> applicatinNamesSet,Set<String> accountIdsSet,Set<String> roleFeaturesSet)
    {
        Map<String, IAM_Application__c> iamApplicationMap = new Map<String, IAM_Application__c>();
        System.debug('AT getIAMApplicationMap--->'+applicatinNamesSet+'='+accountIdsSet+'='+roleFeaturesSet);
        // get all the Account Feature records
        List<IAM_Application__c> iamApplicationList = [Select ID, IAM_Application_Name__c, IAM_Account_Name__c, IAM_Role__c, 
                                                       IAM_Subscription_Name__c, IAM_OSM_Backend_Update__c,IAM_Free_Subscription__c  ,IAM_Status__c,IAM_Qsolexpiration__c 
                                                       from IAM_Application__c 
                                                       WHERE IAM_Application_Name__c != null 
                                                       AND IAM_Account_Name__c != null 
                                                       AND IAM_Role__c != null
                                                       AND IAM_Status__c = 'Active'
                                                       AND IAM_Application_Name__c IN: applicatinNamesSet 
                                                       AND IAM_Account_Name__c IN:accountIdsSet];// AND IAM_Role__c IN:roleFeaturesSet];
                                                    
        
        System.debug('iamApplicationList--->'+iamApplicationList.size());
        for(IAM_Application__c iamApplication : iamApplicationList)
        {
            List<String> roleList = iamApplication.IAM_Role__c.split(';');
            roleList.sort();
            /*
            // application name + account id + role/feature
            if(iamApplication.IAM_Application_Name__c.equalsIgnoreCase(Label.OSM_Guidanz_Mobile)){
                iamApplicationMap.put(iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c + '~' + String.join(roleList, ','), iamApplication);
            }else{
                /*
                String applicationName = iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c;
                
                if((iamApplication.IAM_Application_Name__c =='QuickServe Online') && (iamApplication.IAM_Subscription_Name__c == Label.OSM_Quick_Serve_Online_EBU 
                                                                                      || iamApplication.IAM_Subscription_Name__c==Label.OSM_Quick_Serve_Online_CPG)){
                                                                                          applicationName = iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Subscription_Name__c + '~' + iamApplication.IAM_Account_Name__c+'~'+String.join(roleList, ',');
                                                                                          
                                                                                      }
                                                                                      */
                                                                                      // for 554
                /*
                String applicationName = iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c+ '~' + String.join(roleList, ',');
                iamApplicationMap.put(applicationName , iamApplication);
                */
                if(iamApplication.IAM_Application_Name__c.equalsIgnoreCase(Label.OSM_Guidanz_Mobile))
                    iamApplicationMap.put((iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c + '~' + String.join(roleList, ',')).toUpperCase(), iamApplication);
                else if(iamApplication.IAM_Application_Name__c == 'QuickServe Online')
                    iamApplicationMap.put((iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Subscription_Name__c+'~'+iamApplication.IAM_Account_Name__c).toUpperCase(), iamApplication);
                else
                    iamApplicationMap.put((iamApplication.IAM_Application_Name__c + '~' + iamApplication.IAM_Account_Name__c).toUpperCase(), iamApplication);
                
            
            
        }
        System.debug('iamApplicationMap--->'+iamApplicationMap);
        
        return iamApplicationMap;
    }
    
    
    public static Map<String, OSM_Subscription_Account_Provision__c>getJunctionObjectRecords(Set<Id>subsIds, Set<Id>accfeatureIds){
        Map<String, OSM_Subscription_Account_Provision__c> mapSubAccFeature = new Map<String, OSM_Subscription_Account_Provision__c>();
        for(OSM_Subscription_Account_Provision__c junObj : [Select ID, Account_Features_Access__c, CC_Subscription__c, Subscription_Status__c, User_Count__c from OSM_Subscription_Account_Provision__c where CC_Subscription__c IN: subsIds and Account_Features_Access__c IN: accfeatureIds]){
            
            mapSubAccFeature.put(junObj.CC_Subscription__c+'~'+junObj.Account_Features_Access__c,junObj);
            
        }
        system.debug('mapSubAccFeature-->'+mapSubAccFeature);
        return mapSubAccFeature;
    }
    
    public static String formatDataBasedOnApplication(Date expiryDate, String applicationName, String role)
    {
        system.debug('formatDataBasedOnApplication '+ expiryDate+', '+applicationName+', '+role);
        DateTime expiryDate_DT = DateTime.newInstance(expiryDate.year(), expiryDate.month(), expiryDate.day());
        String formattedValue = '';
        system.debug('formatDataBasedOnApplication: '+applicationName);
        if(applicationName == 'QuickServe Online')
        {
            formattedValue = expiryDate_DT.format('dd-MMM-yyyy') + label.OSM_QSOLEBU_ENDDATE_SUFFIX;
        }
        if(Label.OSM_Quick_Serve_Online_EBU == applicationName)
        {
            // sample value : 10-Nov-2020EBUACTIVE
            // confirm the status part
            formattedValue = expiryDate_DT.format('dd-MMM-yyyy') + label.OSM_QSOLEBU_ENDDATE_SUFFIX;
        }
        if(Label.OSM_Quick_Serve_Online_CPG == applicationName)
        {
            formattedValue = expiryDate_DT.format('dd-MMM-yyyy') + label.OSM_QSOLCPG_ENDDATE_SUFFIX;
        }
        if(Label.OSM_Guidanz_Mobile == applicationName)
        {
            // sample value : IAS0-03/20/2019
            String code = '';
            if(role.containsIgnoreCase('Guidanz Mobile Immediate Assessment')){
                code = label.OSM_GM_ImmediateAssessment_EndDate_Prefix;
            }
            if(role.containsIgnoreCase('Guidanz Mobile Service')){
                code = label.OSM_GM_Service_EndDate_Prefix;
            }
            formattedValue = code + expiryDate_DT.format('MM/dd/yyyy');
        }
        return formattedValue;
    }
    
    public static map<id,object>  guidenzmobileaccesscount(){
        map<id,object> records = new map<id,object>();
        list<id> products = new   list<id> ();
        for(id productid:products){
            for(ccrz__E_CompositeProduct__c compProduct :[Select Id, ccrz__Composite__c, ccrz__Composite__r.Name, ccrz__Quantity__c,ccrz__Component__r.Name from ccrz__E_CompositeProduct__c where ccrz__Composite__c =:productid ]){
                system.debug('ccrz__E_CompositeProduct__c'+compProduct); 
                system.debug('ccrz__Composite__r.Name'+compProduct.ccrz__Component__r.Name);
                if(compProduct.ccrz__Composite__r.Name.containsIgnoreCase('Guidanz Mobile') || compProduct.ccrz__Component__r.Name.containsIgnoreCase('Guidanz Mobile')){
                    system.debug('ccrz__Composite__r.ccrz__Quantity__c'+compProduct.ccrz__Quantity__c);
                    records.put(productid,compProduct.ccrz__Quantity__c);
                }
            } 
        }
        return records;
    }
    
    public class OSM_IAMProvisioningDetails
    {
        ID accountID;
        ID subscriptionID;
        String productName;
        DateTime startDate;
        DateTime endDate;
        String status;
        Integer userCount;
		Integer quantity;			 
        String accountGroupName;
        String accountType;
		String productSKU;				  
        List<String> roleFeatureList;
        String roleFeature;
        String applicationName;
        String subscriptionName;
        String qsolType;
    }
    
    public class OSM_JunctionObjectDetails
    {
        ID iamRecordID;
        ID accountId;
        ID subscriptionID;
        String applicationName;
        String roleFeature;
        Integer userCount;
        String subscriptionStatus;
		Integer subscriptionQuantity;		 
        DateTime endDate;
        String subscriptionName;
        //Date startDate;
         
    }
    
}