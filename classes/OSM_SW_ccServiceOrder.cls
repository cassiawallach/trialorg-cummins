/*****************************************************************
Name:  OSM_SW_ccServiceOrder
Copyright © 2018  Cummins
==================================================================
==================================================================
Purpose:                                                            
This is CC extension to display the orders for account.Standard CC
API display orders for a particular user.This is overriden to display
the orders for particular account to Admins and any other user of account.
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE              DETAIL                                
1.0 -   Vaibhav Sharma         07/05/2018     INITIAL DEVELOPMENT          

******************************************************************/

global with sharing  class OSM_SW_ccServiceOrder extends ccrz.ccServiceOrder // <1>
{
    global static String orderOperation='';
    public static final String numberOfMonths = Label.LastNMonths;
    
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
        inputData = super.getFieldsMap(inputData); // <3>
        
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>
        String viewState = ccrz.cc_CallContext.currPageParameters.get('viewState');
        
        system.debug('Limits.getheapsize() - 4'+Limits.getheapsize());
        system.debug('viewState---->>'+viewState);
        system.debug('orderOperation--->>'+orderOperation);
        system.debug('Current Page name-->>' +ccrz.cc_CallContext.currPageName);
        if(ccrz.cc_CallContext.currPageName == 'ccrz__MyAccount' && viewState == 'myOrders')
        {
            objectFields += ',OSM_SW_Purchase_By__c,OSM_SW_Days_Since_Order_Date__c,'
                        +'ccrz__Account__r.CSS_DistributorCode__c,ccrz__Account__r.Type,OSM_SW_Bundle_Product_Count__c,OSM_SW_Is_InterCompany_Order__c,'
                        +'OrderProcessedforFSD__c,Hours_Since_Order_Date__c,isOnBehalf__c,Purchased_By_User_Type__c' ;  // <4> 
            
                } 
        else
        {
                    
            objectFields += ',OSM_SW_Purchase_By__c,CreatedBy.Name,OSM_SW_Days_Since_Order_Date__c,OSM_SW_No_Revoke_Item_status__c,OSM_SW_No_of_Revoked_OrderItem__c,'
                        +'ccrz__Account__r.name,ccrz__Account__r.BillingCountry,ccrz__Account__r.CSS_DistributorCode__c,ccrz__Account__r.Type,Minimum_Subscription_length__c,OSM_SW_Bundle_Product_Count__c,OSM_SW_Is_InterCompany_Order__c,'
                        +'OrderProcessedforFSD__c,Refund_status__c,Hours_Since_Order_Date__c,Max_Activation_Keys__c,'
                        +'Successful_Tool_Insatanc_Activation_Keys__c,Original_Order_Subtotal__c,Calculated_Total_Discount__c,'
                        +'isOnBehalf__c,Purchased_By_User_Type__c,OSM_Logged_In_User_Type__c,Purchased_By_Followed_Text__c,ccrz__Contact__r.Name,ccrz__Contact__r.Phone,ccrz__Contact__r.Email,(Select Id,ccrz__AccountType__c,ccrz__AccountNumber__c from ccrz__TransactionPayments__r)' ;  // <4> 
        }
        system.debug('***************************');
         system.debug(inputData);
        system.debug(objectFields);
        system.debug('***************************');
        system.debug('Limits.getheapsize() - 5'+Limits.getheapsize());
        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};  // <5>
    }
    

/**
 * Method : getFilterMap 
 * This method has logic to return the correct filters in where clause
 * to display the orders for CSR user and also for all users of same account.
 * This is overriden mainly when user navigates to My Orders in My Account.
 * This will fetch orders for a particular account and display to CSR or any
 * user of that account.
 * 
 * @param  inputData: CC param
 */
   
   global virtual override Map<String, Object> getFilterMap(Map<String, Object> inputData)
{
    ccrz.ccLog.log('******************getFilterMap ********************* '+orderOperation);
      system.debug('Limits.getheapsize() - 6'+Limits.getheapsize());
    Map<String,Object> localizedFilterMap = new Map<String,Object>();
     
    if(ccrz.cc_CallContext.currPageName == 'ccrz__MyAccount' && !(orderOperation=='OrderCancel'))
    {
        ccrz.ccLog.log('******************getFilterMap ccrz__MyAccount********************* '+ccrz.cc_CallContext.currAccountId);
        ccrz.ccService callbackSvc = (ccrz.ccService) ccrz.ccService.resolveServiceCallback(
        new Map<String, Object>{
            ccrz.ccService.PASSEDINPUTMAP=>inputData,
            ccrz.ccService.DEFINEDSERVICE=>this
            }
        ).get(ccrz.ccService.CALLBACKSERVICE);
            
        //Added by swetha 1061      
        Set<Id> orderIdSet = new Set<Id>();
        
        String query = 'select id from ccrz__E_Order__c where ccrz__Account__c= \'' + ccrz.cc_CallContext.effAccountId +'\' AND (ccrz__OrderDate__c = ' + numberOfMonths + 
            ' OR ccrz__OrderDate__c = THIS_MONTH) AND ccrz__OrderStatus__c <> \'Failed\'';
        
        for(ccrz__E_Order__c order : Database.query(query)){
            orderIdSet.add(order.Id);
        }
        
               
        ccrz.ccLog.log('====OrderId==='+orderIdSet);
        ccrz.ccLog.log('******************getFilterMap PARAM_ORDER_ID_LIST ********************* '+ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST);
        inputData.put(ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST,orderIdSet);
     
        Map<String, Object>   FILTERMAP1 = new Map<String, Object>{
        ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST=>' Id in :'+ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST
        };
    
        //call CC API for adding the filter in My Order SOQL
        localizedFilterMap = ccrz.ccService.filterConditionAccumulator(new Map<String, Object>{
            ccrz.ccService.FCFILTERSMAP=>FILTERMAP1,
            ccrz.ccService.PASSEDINPUTMAP=>inputData,
            ccrz.ccService.FCACCUMULATEDFILTERS=>localizedFilterMap,
                                                ccrz.ccService.FCCONJUNCTION=>' AND ',
            ccrz.ccService.FCKEY=>ccrz.ccAPIOrder.PARAM_ORDER_ID_LIST
        });
        
        system.debug('localizedFilterMap'+localizedFilterMap);
        
        //display all field in log
         
        //this orderOperation is important else order Cancel will start failing during order refresh after order cancellation
        orderOperation='';
     }
     else
     {
        //if not My Account then call standard CC services
       localizedFilterMap = super.getFilterMap(inputData);
     }
         system.debug('Limits.getheapsize()'+Limits.getheapsize());
         system.debug('Limits.getLimitHeapSize()'+Limits.getLimitHeapSize()) ;
     return localizedFilterMap;

 }
 
}