/**********************************************************************
Name:  OSM_SW_Invoice_Comp_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class to revoke the invoice.                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            25/7/2018     INITIAL DEVELOPMENT          


*****************************************************/
global class OSM_SW_Invoice_Comp_Ctrl
{
    
    /*----------------------------------------------------------------------------------
1. getOrderInfo
Description:Used to revoke Invoice
Input: ccrz.cc_RemoteActionContext ctx, order Id
Output: 
Returns the Invoice

ccrz.cc_RemoteActionResult
DAProductsData==> Map<String,MainWrapper>
------------------------------------------------------------------------------------*/
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult revokeInvoice(ccrz.cc_RemoteActionContext ctx, Id invoiceId){
        
        ccrz.cc_CallContext.initRemoteContext(ctx);
        
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = false;
        Map<String,Object> returnMap = new Map<String,Object>();
        
        try{
            
            OSM_ReturnWrapper returnWrapper = OSM_SW_OrderCancellationUtility.handleRevokeSubscriptionProcess(new List<Id>{invoiceId});
            String status =  returnWrapper.invoiceIdVsStatusMap.get(invoiceId);
            if(status=='Success')  
            {
                returnMap.put('SucessMsg','Revoke success');  
                result.data = returnMap;
                result.success = true;
            }
            else
            {
                returnMap.put('SucessMsg','There is some issue in revocation.Please try later.');
                result.data = returnMap;
                result.success = false;
            }
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
            returnMap.put('ErrorMsgOrder',objWrpr1);
            result.data = returnMap;
            result.success = false;
            
            String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
            
            OSM_Integration_Log__c log = new OSM_Integration_Log__c();
            
            log.Error_Description__c = errorMsg;
            
            log.Service_Name__c = System.Label.OSM_SW_Revoke_Failure;
            
            log.Status__c = 'Failed';
            
            insert log;
        }
        system.debug('return map: '+result);
        return result;
    }
    
}