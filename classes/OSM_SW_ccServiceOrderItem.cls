/*****************************************************************
Name:  OSM_SW_ccServiceOrderItem
Copyright © 2019  Cummins
==================================================================
==================================================================
Purpose:                                                            
This is CC extension to display the orderitem for account.Standard CC
API display orderitem for a particular user.This is overriden to display
the orderitems for particular account to Admins and any other user of account.
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE              DETAIL                                
1.0 -   Neha Sharma         01/09/2019     INITIAL DEVELOPMENT          
1.1 -   Charlynn			07/23/2022		Changes added as part of LL-21 & LL-22 to display Number of Bundles
******************************************************************/
global with sharing  class OSM_SW_ccServiceOrderItem extends ccrz.ccServiceOrderItem // <1>
{
    global static String orderOperation='';
    
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
    
         
        system.debug('***************************');
        system.debug(inputData); 
        system.debug('***************************');
        inputData = super.getFieldsMap(inputData); // <3>

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>
		//ccrz__Subscription_End_Date__c,OSM_SW_Is_without_Coterm__c added by swetha
        //LL-21 & LL-22 - Added Number_of_Bundles__c to query
        objectFields += ',OSM_SW_Distributor_Account_Name__c,OSM_SW_Cancel_By_User_Type__c,ccrz__DisplayProduct__r.OSM_SW_Show_Check_your_email_Msg__c,ccrz__DisplayProduct__r.OSM_SW_Show_Assign_User_Link__c,OSM_SW_Product_Link__r.ccrz__SKU__c,ccrz__DisplayProduct__r.ccrz__SKU__c,isRenew__c,'
                       +'OSM_Renew_Subscription_Start_Date__c ,OSM_Renew_Subscription_End_Date__c ,IsCancelPending__c,CancelledBy__c,'
                       +'ccrz__Order__r.ccrz__OrderStatus__c,Revocation_Status__c,IsRevokeLicenseSucess__c,'
                       +'OSM_Tool_Instance_Key__c,OMS_Activation_Key__c,CancelLicenseAPICalled__c,'
                       +'Billing_Frequency__c,OMS_Product__c, ccrz__Coupon__r.ccrz__CouponCode__c,OSM_SW_Coupon_Applied__c,'
                       +'Discounted_Amount__c,Original_Price_without_Discount__c,ccrz__Subscription_End_Date__c,OSM_SW_Is_without_Coterm__c,Number_of_Bundles__c';  // <4>
        system.debug('***************************');
        system.debug(inputData);
        system.debug('***************************');
        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};  // <5>
    }
    
    
    global virtual override Map<String, Object> getSubQueryMap(Map<String, Object> inputData) {
    ccrz.ccLog.log('====sub query map of order item====');
    return OSM_SW_ccServiceOrderItem.SUBQUERYMAP;
    }
    
    private static final Map<String, Object> SUBQUERYMAP = new Map<String, Object>{
        // A subQuery off of a cart.
        'OSM_Oreder_Item_Licenses__r' =>'(SELECT Id,Status__c,Activation_Key__c,Type__c,CC_Order_Item__r.Is_Addon_Product__c,CC_Order_Item__r.Number_of_Bundles__c,CC_Order_Item__r.ccrz__Quantity__c,createdDate,Parent_Activation_Key__c,Tool_Instance_Key__c FROM OSM_Oreder_Item_Licenses__r )'
    };

    //where Status__c = \'New\' OR Status__c = \'Create And Get Done\'
     


 }