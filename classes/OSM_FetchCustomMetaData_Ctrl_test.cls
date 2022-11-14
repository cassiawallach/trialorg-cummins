@isTest
public class OSM_FetchCustomMetaData_Ctrl_test{

    static testMethod void tetsMethod1(){
        OSM_Southern_Plain__mdt lstSouthernPlain = [SELECT Label, CC_Bill_From_Remit_To__c,PO_Bill_From_Remit_To__c,Distributor_Code__c from OSM_Southern_Plain__mdt
                                                                 WHERE DeveloperName='OSM_Southern_Plain' limit 1];
    OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();                                                             
        
    }
    static testMethod void tetsMethod2(){
        OSM_SubscriptionLength__mdt lstSouthernPlain = [SELECT Label, Product_SKU__c,Subscription_Length__c from OSM_SubscriptionLength__mdt
                                                                 WHERE DeveloperName='INCAL_Automotive' limit 1];
    OSM_FetchCustomMetaData_Ctrl.getSubscriptionMetaDataMap();                                                             
        
    }
}