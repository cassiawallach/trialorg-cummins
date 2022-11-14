/**********************************************************************
Name:  OSM_SW_MyAccount_ContactInfo_Comp_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to keep all relative fetch
billing Frequency from Account and save it.                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            7/6/2018     INITIAL DEVELOPMENT          


*****************************************************/
global class OSM_SW_MyAccount_ContactInfo_Comp_Ctrl
{

/*----------------------------------------------------------------------------------
1. getBillingFreq
Description:Used to fetch billing freq from account
Input: ccrz.cc_RemoteActionContext ctx
Output: 
Returns the billing freq of account

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/

    @RemoteAction
 global static ccrz.cc_RemoteActionResult getBillingFreq(ccrz.cc_RemoteActionContext ctx){
      System.debug('ctx____'+ctx);
       ccrz.cc_CallContext.initRemoteContext(ctx);
       //Id accountId = ccrz.cc_CallContext.currAccountId;
     Id accountId = ccrz.cc_CallContext.effAccountId;
       String storefront = ccrz.cc_CallContext.storefront;
    
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        
        System.debug('accountId : '+accountId);
        try{
            if(accountId != null)
            {
                Account objAccount = new Account();
                // Start : Juhi Changes Aug 22 : Addition of Account# and Bolt Account Number
                objAccount = [Select Id, OSM_Preferred_Billing_Frequency__c, CMI_Primary_Contact__c, 
                              CMI_Primary_Contact__r.Name, CMI_Primary_Contact__r.Email  , CMI_Primary_Contact__r.Phone, 
							  CMI_Account_Num__c, IAM_Service_Provider_Code__c,                        // added in query as part of MAR-1256
                              CMI_Cid__c, BOLT_Account_Number__c from Account where Id =: accountId];
                
                If(objAccount != null)
                {
                    AccountBillingFreq objBillFrerqCls = new AccountBillingFreq();
                    //objBillFrerqCls.isBillingFreqLock = objAccount.OSM_Preferred_Billing_Frequency_Lock__c;
                    objBillFrerqCls.selectedBillingFreq = objAccount.OSM_Preferred_Billing_Frequency__c;
                    objBillFrerqCls.availabeBillingFreq = new List<String>();
                    objBillFrerqCls.canChandeBillingFreq = checkToChangeBillingFreqForRecInvoice(accountId,storefront);
                    
					// Customer code populated as part of MAR-1256
                    if(null != objAccount.IAM_Service_Provider_Code__c){
                        objBillFrerqCls.accountNumber = objAccount.IAM_Service_Provider_Code__c;
                    }
                    
                    // DA Customer code populated as part of MAR-1256
                    if(null != objAccount.CMI_Account_Num__c){
                        objBillFrerqCls.daAccountNumber = objAccount.CMI_Account_Num__c;
                    }
					
                    // Customer is a Bolt Customer
					/* commented as part of MAR-1256
                    if(null != objAccount.BOLT_Account_Number__c)
                    {
                        objBillFrerqCls.accountNumber = objAccount.BOLT_Account_Number__c;
                    }
                    else if(null != objAccount.CMI_Cid__c)
                    {
                        objBillFrerqCls.accountNumber = objAccount.CMI_Cid__c;
                    }
					*/
                    // End : Juhi Changes Aug 22 : Addition of Account# and Bolt Account Number

                    if(objAccount.CMI_Primary_Contact__c != null)
                    {
                        objBillFrerqCls.pContactName = objAccount.CMI_Primary_Contact__r.Name;
                        objBillFrerqCls.pContactEmail = objAccount.CMI_Primary_Contact__r.Email;
                    }
                    else
                    {
                        objBillFrerqCls.pContactName = '';
                        objBillFrerqCls.pContactEmail = '';
                    }
                    
                    objBillFrerqCls.availabeBillingFreq.add('Monthly');
                    objBillFrerqCls.availabeBillingFreq.add('Quarterly');
                    objBillFrerqCls.availabeBillingFreq.add('Yearly');
                    returnMap.put('data', objBillFrerqCls);
                }
            }
            
            result.data = returnMap;
            result.success = true;

        }catch(Exception ex)
        {
            System.debug('in catch exp: '+ex.getMessage());
            System.debug('in catch getStackTraceString: '+ex.getStackTraceString());
            CMI_SW_CartTaxWrapper objWrpr1 = new CMI_SW_CartTaxWrapper();
            objWrpr1.isError = true;
            objWrpr1.errorMsg = ex.getMessage();
            returnMap.put('ErrorMsgAccount',objWrpr1);
            result.data = returnMap;
            result.success = false;
        }
        system.debug('return map: '+result);
        return result;
    }
    
    public Class AccountBillingFreq
    {
        //boolean isBillingFreqLock;
        boolean canChandeBillingFreq;
        String selectedBillingFreq;
        List<String> availabeBillingFreq;
        String PrimaryContact;
        String phoneNumber;
        String email;
        String pContactName;
        String pContactEmail;
        String daAccountNumber;
        String accountNumber;
    }
    
    /*----------------------------------------------------------------------------------
1. updateBillingFreq
Description:Used to save billing frequency in account
Input: ccrz.cc_RemoteActionContext ctx, billing frequency 
Output: 
Returns the Result of save Account

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/

    @RemoteAction
 global static ccrz.cc_RemoteActionResult updateBillingFreq(ccrz.cc_RemoteActionContext ctx, String billingFrequency){
      
       ccrz.cc_CallContext.initRemoteContext(ctx);
       //Id accountId = ccrz.cc_CallContext.currAccountId;
     Id accountId = ccrz.cc_CallContext.effAccountId;
       String storefront = ccrz.cc_CallContext.storefront;
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        
        System.debug('billingFrequency : '+billingFrequency);
        try{
            if(billingFrequency != null)
            {
                Account objAccount = new Account();
                objAccount = [Select Id, OSM_Preferred_Billing_Frequency__c from Account where Id =: accountId];
                If(objAccount != null && objAccount.OSM_Preferred_Billing_Frequency__c != billingFrequency)
                {
                    objAccount.OSM_Preferred_Billing_Frequency__c = billingFrequency;
                    update objAccount;
                    OSM_SW_ProductDetailCommonUtility.updateCartItemToInavlidOrDelete(accountId , billingFrequency, storefront);
                    
                }
                returnMap.put('data', System.Label.OSM_SW_BillingFreq_SaveSucessMsg);
                result.success = true;
            }
            result.data = returnMap;
            

        }catch(Exception ex)
        {
            System.debug('in catch exp: '+ex.getMessage());
            System.debug('in catch getStackTraceString: '+ex.getStackTraceString());
            returnMap.put('data',System.Label.OSM_SW_BillingFreq_ErrorMsg);
            result.data = returnMap;
            result.success = false;
        }
        system.debug('return map: '+result);
        return result;
    }
    
    public static boolean checkToChangeBillingFreqForRecInvoice(Id accountId,String storefront)
    {
        if(OSM_SW_ProdDetailUtils_Ctrl.getAccountSubscriptionWithoutOneTime(accountId,storefront).size() > 0)
            return false;
        else
            return true;
    }
}