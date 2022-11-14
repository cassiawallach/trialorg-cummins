/**********************************************************************
Name:  OSM_ActivationKeyError_Handling
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class to check activation key are available .                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Nandigam Sasi     01/04/2020     INITIAL DEVELOPMENT          
*****************************************************/
public class OSM_SW_ActivationKeyError_Handling {
    
    public static boolean activationkeycheck(string orderid,list<string> orderitem){
        boolean activationKeyErrorMessage = false;
        try{
            list<OSM_Integration_Log__c> osmlog = [select id ,CC_Order_Item__c,CC_Order__c,Service_Name__c,Status__c from OSM_Integration_Log__c where CC_Order__c=:orderid AND (Service_Name__c = 'OMS_GetOrder_Service' OR Service_Name__c='OMS_CreateOrder_Service')];
            if(osmlog.size()>0){
                string query ='';
                if(orderitem.size()>0){
                    query ='select id ,ccrz__DisplayProduct__r.ccrz__SKU__c  from ccrz__E_OrderItem__c where ccrz__Order__c =:orderId and  Id IN: orderitem';  
                }else{
                    query ='select id ,ccrz__DisplayProduct__r.ccrz__SKU__c  from ccrz__E_OrderItem__c where ccrz__Order__c =:orderId';
                }
                system.debug('Query'+query);
                list<ccrz__E_OrderItem__c>  itemslist =database.query(query);
                
                system.debug('itemslist'+itemslist);
                Map<id,ccrz__E_OrderItem__c> orderitems = new  Map<id,ccrz__E_OrderItem__c>();
                for(ccrz__E_OrderItem__c rec :itemslist)orderitems.put(rec.id,rec); 
                list<OSM_Order_Item_License__c> orderItemLicenseList =[select id,Activation_Key__c,CC_Order_Item__c,type__c,CC_Order_Item__r.ccrz__DisplayProduct__r.ccrz__SKU__c from OSM_Order_Item_License__c where CC_Order_Item__c IN :orderitems.keyset()];
                system.debug('orderItemLicenseList'+orderItemLicenseList);
                Map<id,List<OSM_Order_Item_License__c>> orderlicenseActivationKeyMap=new Map<id,List<OSM_Order_Item_License__c>>(); 
                for(OSM_Order_Item_License__c orderLicense:orderItemLicenseList ){
                    if(orderlicenseActivationKeyMap.containsKey(orderLicense.CC_Order_Item__c)){
                        List<OSM_Order_Item_License__c> orderItemLicList=orderlicenseActivationKeyMap.get(orderLicense.CC_Order_Item__c);
                        orderItemLicList.add(orderLicense);
                        orderlicenseActivationKeyMap.put(orderLicense.CC_Order_Item__c,orderItemLicList);
                    }else{
                        orderlicenseActivationKeyMap.put(orderLicense.CC_Order_Item__c,new List<OSM_Order_Item_License__c>{orderLicense});
                    }
                }
                system.debug('orderlicenseActivationKeyMap'+orderlicenseActivationKeyMap);
                 system.debug('Label.OMS_ProductList_OriginalList'+Label.OMS_ProductList_OriginalList);
                for(ccrz__E_OrderItem__c orditem : orderitems.values()){
                    if(activationKeyErrorMessage)break;
                    if((!orderlicenseActivationKeyMap.containskey(orditem.id))){
                        system.debug('orderlicenseActivationKeyMap'+orderlicenseActivationKeyMap);
                        system.debug('orditem.ccrz__DisplayProduct__r.ccrz__SKU__c'+orditem.ccrz__DisplayProduct__r.ccrz__SKU__c);
                        if(orditem.ccrz__DisplayProduct__r.ccrz__SKU__c!=null && Label.OMS_ProductList_OriginalList.contains(orditem.ccrz__DisplayProduct__r.ccrz__SKU__c))
                            activationKeyErrorMessage = true; 
                    }
                }
            }
        }catch(exception ex){
            system.debug('Error------>>>'+ex.getMessage()+'Error Line Number'+ex.getLineNumber());
        }
        system.debug('activationKeyErrorMessage'+activationKeyErrorMessage);
        return activationKeyErrorMessage;
    }
    
}