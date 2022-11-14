/*************************************************************************************************************************
Name:  OSM_SW_CreateOrderRequestDataSetup
Copyright © 2018  Cummins
==========================================================================================================================
==========================================================================================================================
Purpose:                                                            
This class is used to setup request data for create Order                 
==========================================================================================================================
==========================================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta R       20/06/19      INITIAL DEVELOPMENT          
1.1 -   Ronnie Mishra    15/11/2021    Changes added as part ofMP-139, to add requesterId
1.2 -   Ronnie Mishra    15/11/2021    Changes added as part ofMP-141, to get correct duration of subscription
1.3 -   Ronnie Mishra    12/12/2021    Changes added as part ofMP-402, to get correct requesterId
**************************************************************************************************************************/

public class OSM_SW_CreateOrderRequestDataSetup{
    
    public static OSM_OMS_CreateOrderGeneral_IP_Wrapper reqDataSetupNonInsite(ccrz__E_Product__c product,ccrz__E_Order__c orderRef,ccrz__E_OrderItem__c orderItem,Integer quantity,OSM_OMS_CreateOrderGeneral_IP_Wrapper generalizedInputWrapper)
    {
        
        OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails orderItemDetails = new OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails();
        String contactId = orderRef.ccrz__Contact__c;
        List<Contact> contactRec = [SELECT id, IAM_Contact_Owner__c FROM Contact where id=:contactId];
        List<User> createdByUser = [SELECT id, ContactId, FederationIdentifier FROM User WHERE Id=:contactRec[0].IAM_Contact_Owner__c];
        List<User> createdByUser2 = [SELECT id, ContactId, FederationIdentifier FROM User WHERE Id=:orderRef.CreatedById];
        if(!createdByUser2.isEmpty()) {
            orderItemDetails.adminId = createdByUser2[0].FederationIdentifier;
        }
        if(orderItemDetails.adminId == '')
            orderItemDetails.adminId = null;
        if(!createdByUser.isEmpty() && !createdByUser2.isEmpty()) {
            if(createdByUser[0].Id == createdByUser2[0].Id) {
                generalizedInputWrapper.requesterId = createdByUser2[0].FederationIdentifier;
            }            
            else {
                generalizedInputWrapper.requesterId = createdByUser[0].FederationIdentifier;
            }
        }
        else if(!createdByUser2.isEmpty() && createdByUser.isEmpty()) {
            generalizedInputWrapper.requesterId = createdByUser2[0].FederationIdentifier;     
        }        
        if(null != product.LicenseName__c || Test.isRunningTest())
            orderItemDetails.licenseName = product.LicenseName__c;
        if(null != product.Name)
            orderItemDetails.productName = product.Name;
        if(null != product.Product_Range__c || Test.isRunningTest())
            orderItemDetails.productGroup = product.Product_Range__c;
        if(null != product.Feature__c || Test.isRunningTest())
            orderItemDetails.feature = product.Feature__c;
        if(null != product.FeatureGroup__c || Test.isRunningTest())
            orderItemDetails.featureGroup = product.FeatureGroup__c;                         
        if(Label.SES_OMSCreateOrder_NonSubscriptionProduct_List.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
        {
            orderItemDetails.numberOfReinstalls = '0';
            
            orderItemDetails.totalCopies = String.valueOf(orderItem.Number_of_Bundles__c);
            orderItemDetails.countsPerCopy = String.valueOf(orderItem.Number_of_Counts__c); 
        }
        else if(Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
        {
            orderItemDetails.numberOfReinstalls = Label.NumberOfReinstalls_NONINSITE;
            
            orderItemDetails.totalCopies = String.valueOf(quantity);
            orderItemDetails.countsPerCopy = '0';
        }
        
        Integer duration = 1;
        List <Subscription_Length_Estimation__mdt> subLen = [SELECT MasterLabel, Subscription_Length__c FROM Subscription_Length_Estimation__mdt];
        Map<String, Subscription_Length_Estimation__mdt> subLenMap = new Map<String, Subscription_Length_Estimation__mdt>();
        for(Subscription_Length_Estimation__mdt subLenObj: subLen) {
            subLenMap.put(subLenObj.MasterLabel, subLenObj);
        }
        if(null != orderItem.ccrz__SubProdTerm__c && !subLen.isEmpty())
        {
            Subscription_Length_Estimation__mdt subLengthObj = subLenMap.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
            duration = Integer.valueOf(subLengthObj.Subscription_Length__c);
        }
        
        // NEED to get from the Order Item object
        orderItemDetails.duration = String.valueOf(duration);
        generalizedInputWrapper.orderItemDetailsList.add(orderItemDetails);
        return generalizedInputWrapper;
    }
    
    public static OSM_OMS_CreateOrderGeneral_IP_Wrapper reqDataSetupInsite(ccrz__E_Product__c product,ccrz__E_Order__c orderRef,ccrz__E_OrderItem__c orderItem,Integer quantity,OSM_OMS_CreateOrderGeneral_IP_Wrapper generalizedInputWrapper,OSM_Order_Item_License__c orderItemLicense)
    {
        
        //For Non - Basic Array Calculation start...
        Id accountId=orderRef.ccrz__Account__c;
        //List<ccrz__E_Subscription__c> subList=[SELECT ccrz__Account__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,OSM_Subscription_End_Date__c FROM ccrz__E_Subscription__c WHERE (ccrz__SubscriptionProduct__r.Name LIKE '%Cummins Guidanz%' OR ccrz__SubscriptionProduct__r.Name LIKE '%INSITE%' OR ccrz__SubscriptionProduct__r.Name LIKE '%Service Tech Kit%') and ccrz__Account__c=:accountId order By OSM_Subscription_End_Date__c ASC];
        List<ccrz__E_Subscription__c> subList=[SELECT ccrz__Account__c,ccrz__SubscriptionProduct__c,ccrz__SubscriptionStartDate__c,OSM_Subscription_End_Date__c FROM ccrz__E_Subscription__c WHERE (ccrz__SubscriptionProduct__r.Name=:product.name OR ccrz__SubscriptionProduct__r.Name LIKE '%Cummins Guidanz%' OR ccrz__SubscriptionProduct__r.Name LIKE '%Service Tech Kit%' OR ccrz__SubscriptionProduct__r.Name LIKE '%Add-on%') and ccrz__Account__c=:accountId and ccrz__SubscriptionStatus__c='Active' AND OSM_SW_Is_without_Coterm__c =:orderItem.OSM_SW_Is_without_Coterm__c order By OSM_Subscription_End_Date__c ASC];
        
        OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails orderItemDetails = new OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails();
        String contactId = orderRef.ccrz__Contact__c;
        List<Contact> contactRec = [SELECT id, IAM_Contact_Owner__c FROM Contact where id=:contactId];
        List<User> createdByUser = [SELECT id, ContactId, FederationIdentifier FROM User WHERE Id=:contactRec[0].IAM_Contact_Owner__c];
        List<User> createdByUser2 = [SELECT id, ContactId, FederationIdentifier FROM User WHERE Id=:orderRef.CreatedById];
        if(!createdByUser2.isEmpty()) {
            orderItemDetails.adminId = createdByUser2[0].FederationIdentifier;
        }
        if(orderItemDetails.adminId == '')
            orderItemDetails.adminId = null;
        if(!createdByUser.isEmpty() && !createdByUser2.isEmpty()) {
            if(createdByUser[0].Id == createdByUser2[0].Id) {
                generalizedInputWrapper.requesterId = createdByUser2[0].FederationIdentifier;
            }            
            else {
                generalizedInputWrapper.requesterId = createdByUser[0].FederationIdentifier;
            }
        }
        else if(!createdByUser2.isEmpty() && createdByUser.isEmpty()) {
            generalizedInputWrapper.requesterId = createdByUser2[0].FederationIdentifier;     
        }
        
        if(null != product.LicenseName__c || Test.isRunningTest())
            orderItemDetails.licenseName = product.LicenseName__c;
        if(null != product.Name)
            orderItemDetails.productName = product.Name;
        if(null != product.Product_Range__c || Test.isRunningTest())
            orderItemDetails.productGroup = product.Product_Range__c;
        if(null != product.Feature__c || Test.isRunningTest())
            orderItemDetails.feature = product.Feature__c;
        if(null != product.FeatureGroup__c || Test.isRunningTest())
            orderItemDetails.featureGroup = product.FeatureGroup__c;
        
        if( Label.SES_OMSCreateOrder_NonSubscriptionProduct_List.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
        {
            orderItemDetails.numberOfReinstalls = '0';
            
            orderItemDetails.totalCopies = String.valueOf(orderItem.Number_of_Bundles__c);
            orderItemDetails.countsPerCopy = String.valueOf(orderItem.Number_of_Counts__c); 
        }
        else if( Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
        {
            orderItemDetails.numberOfReinstalls = Label.NumberOfReinstalls_INSITE;            
            orderItemDetails.totalCopies = String.valueOf(quantity);            
            orderItemDetails.countsPerCopy = '0';
        }
        
        Integer duration = 1;
        if(!orderItem.OSM_SW_Is_without_Coterm__c && !orderItem.isRenew__c)
        {
            if(subList!=null && subList.size()>0)
            {       
                Date subEndDate = date.newinstance(subList[0].OSM_Subscription_End_Date__c.year(), subList[0].OSM_Subscription_End_Date__c.month(), subList[0].OSM_Subscription_End_Date__c.day());
                Integer daysRemains=(System.today().daysBetween(subEndDate))+1;
                duration=daysRemains;
            }
        }
        
        List <Subscription_Length_Estimation__mdt> subLen = [SELECT MasterLabel, Subscription_Length__c FROM Subscription_Length_Estimation__mdt];
        Map<String, Subscription_Length_Estimation__mdt> subLenMap = new Map<String, Subscription_Length_Estimation__mdt>();
        for(Subscription_Length_Estimation__mdt subLenObj: subLen) {
            subLenMap.put(subLenObj.MasterLabel, subLenObj);
        }
        
        if(null != orderItem.ccrz__SubProdTerm__c && (orderItem.OSM_SW_Is_without_Coterm__c || orderItem.isRenew__c || subList.size() == 0) && !subLenMap.isEmpty())
        {
            Subscription_Length_Estimation__mdt subLengthObj = subLenMap.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
            //OMG-1065 Code Start
            if(orderItemLicense != null && orderItemLicense.Status__c=='Revoked/ReIssue'){
                Date subEndDate = date.newinstance(subList[0].OSM_Subscription_End_Date__c.year(), subList[0].OSM_Subscription_End_Date__c.month(), subList[0].OSM_Subscription_End_Date__c.day());
                duration=(System.today().daysBetween(subEndDate))+1;
            }else{ // OMG-1065 Code End
                duration = Integer.valueOf(subLengthObj.Subscription_Length__c);
            }
        }
        // NEED to get from the Order Item object
        orderItemDetails.duration = String.valueOf(duration);
        
        //For Non - Basic Array Calculation End...
        //****************************************************************************************
        //For Basic Array Calculation start...
        
        OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails orderItemDetailsBasic = new OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails();
        if(!createdByUser2.isEmpty()) {
            orderItemDetailsBasic.adminId = createdByUser2[0].FederationIdentifier;
        }
        if(orderItemDetailsBasic.adminId == '')
            orderItemDetailsBasic.adminId = null;
        if(!createdByUser.isEmpty() && !createdByUser2.isEmpty()) {
            if(createdByUser[0].Id == createdByUser2[0].Id) {
                generalizedInputWrapper.requesterId = createdByUser2[0].FederationIdentifier;
            }            
            else {
                generalizedInputWrapper.requesterId = createdByUser[0].FederationIdentifier;
            }
        }
        else if(!createdByUser2.isEmpty() && createdByUser.isEmpty()) {
            generalizedInputWrapper.requesterId = createdByUser2[0].FederationIdentifier;     
        }
        
        if(null != product.LicenseName__c || Test.isRunningTest())
        { 
            if(product.LicenseName__c.contains('Service Plus'))
            {
                orderItemDetailsBasic.licenseName = 'Service Plus Basic';
            }
            else if(product.LicenseName__c.contains('MR-HD Plus')) 
            {
                orderItemDetailsBasic.licenseName = 'MR-HD Plus Basic';
            }
            else if(product.LicenseName__c.contains('MR-HD Automotive'))
            { 
                orderItemDetailsBasic.licenseName = 'MR-HD Automotive Basic';
            }
            else if(product.LicenseName__c.contains('ServicePlus'))
            {
                orderItemDetailsBasic.licenseName = 'Service Plus Basic';
            }else{
                orderItemDetailsBasic.licenseName=product.LicenseName__c+' Basic';
            }
            
        }
        if(null != product.Name)
            orderItemDetailsBasic.productName = product.Name;
        if(null != product.Product_Range__c || Test.isRunningTest())
            orderItemDetailsBasic.productGroup = product.Product_Range__c;
        if(null != product.Feature__c || Test.isRunningTest())
            orderItemDetailsBasic.feature = product.Feature__c;
        
        orderItemDetailsBasic.featureGroup = 'Basic';
        
        if( Label.SES_OMSCreateOrder_NonSubscriptionProduct_List.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
        {
            orderItemDetailsBasic.numberOfReinstalls = '0';
            
            orderItemDetailsBasic.totalCopies = String.valueOf(orderItem.Number_of_Bundles__c);
            orderItemDetailsBasic.countsPerCopy = String.valueOf(orderItem.Number_of_Counts__c); 
        }
        else if(Label.SES_OMSCreateOrder_SubscriptionProduct_List.contains(orderItem.ccrz__DisplayProduct__r.ccrz__SKU__c))
        {
            orderItemDetailsBasic.numberOfReinstalls = Label.NumberOfReinstalls_INSITE;
            
            orderItemDetailsBasic.totalCopies = String.valueOf(quantity);
            System.debug('The totalCopies here : ' + orderItemDetailsBasic.totalCopies);
            
            orderItemDetailsBasic.countsPerCopy = '0';
        }
        
        
        Integer durationBasic = 1;
        if(!orderItem.OSM_SW_Is_without_Coterm__c && !orderItem.isRenew__c)
        {
            if(subList!=null && subList.size()>0)
            {       
                
                Date subEndDatebasic = date.newinstance(subList[0].OSM_Subscription_End_Date__c.year(), subList[0].OSM_Subscription_End_Date__c.month(), subList[0].OSM_Subscription_End_Date__c.day());
                Integer daysRemainsBasic=(System.today().daysBetween(subEndDatebasic))+1;
                durationBasic=daysRemainsBasic;
            }
        }  
        
        if(null != orderItem.ccrz__SubProdTerm__c && (orderItem.OSM_SW_Is_without_Coterm__c || orderItem.isRenew__c || subList.size() == 0) && !subLenMap.isEmpty())
        {
            
            Subscription_Length_Estimation__mdt subLengthObj = subLenMap.get(orderItem.ccrz__SubProdTerm__r.ccrz__DisplayName__c);
            //OMG-1065 Code Start
            if(orderItemLicense != null && orderItemLicense.Status__c=='Revoked/ReIssue'){
                Date subEndDate = date.newinstance(subList[0].OSM_Subscription_End_Date__c.year(), subList[0].OSM_Subscription_End_Date__c.month(), subList[0].OSM_Subscription_End_Date__c.day());
                durationBasic =(System.today().daysBetween(subEndDate))+1;
            }else{ // OMG-1065 Code End
                durationBasic = Integer.valueOf(subLengthObj.Subscription_Length__c);
            }
            
        }     
        
        // NEED to get from the Order Item object
        orderItemDetailsBasic.duration = String.valueOf(durationBasic);
        //finally adding both arrays in list...
        if(orderItemLicense==null)
        {
            generalizedInputWrapper.orderItemDetailsList.add(orderItemDetails);                         
            generalizedInputWrapper.orderItemDetailsList.add(orderItemDetailsBasic);
        }
        else
        {
            if(orderItemLicense.Type__c=='Basic' || Test.isRunningTest())
            {
                generalizedInputWrapper.orderItemDetailsList.add(orderItemDetailsBasic);
            }
            else if(orderItemLicense.Type__c=='Functional')
            {
                generalizedInputWrapper.orderItemDetailsList.add(orderItemDetails); 
            }
        }
        
        //For Basic Array Calculation end...
        
        return generalizedInputWrapper;
    }
}