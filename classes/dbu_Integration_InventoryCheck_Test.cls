/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-24-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//Updated
@isTest
public with sharing class dbu_Integration_InventoryCheck_Test
{
    public static testMethod void fetchOrderDetailsTest(){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='dbu_Inventory_Check';
        conDetails.End_Point__c= 'https://api-ue-devnf3-aw-ex.cummins.com/cmi/om/v1/inventories/availablity?';
        conDetails.Method_Type__c= 'GET';
        conDetails.grant_type__c= 'application/json';
        insert conDetails;
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='dbu_Inventory_AccessToken';
        conDetails1.End_Point__c= 'https://api-ue-devnf3-aw-ex.cummins.com/cmi/om/v1/inventories/availablity?';
        conDetails1.Method_Type__c= 'GET';
        conDetails1.grant_type__c= 'application/json';
        conDetails1.Key__c ='b7922fab-cacb-4e10-a9b2-15e1a7ff2641';
        conDetails1.Passcode__c='H4C3Ww1f~uRf5PIv6gi.fCdM4.f8l.u_YV';
        insert conDetails1;
         
        Test.startTest();
       //Test.setMock(HttpCalloutMock.class, new dbu_Integration_getAccessTokenMock());
        //dbu_Integration_InventoryCheck.getAccessToken();
           Test.setMock(HttpCalloutMock.class, new dbu_Integration_InventoryMockGenerator());
           //try{
           dbu_Integration_InventoryCheck.getInventory('391577200','GOMSUS','1234','1234','US'); 
           dbu_Integration_InventoryCheck.getInventory('391577200','GOMSUS');
          // }catch(exception e){}    
        Test.stopTest();
    }
}
//uat deployment