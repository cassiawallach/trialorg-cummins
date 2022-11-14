/************************************************************
Name:  CS_header_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for CS_header_Test CS_HEADER Class for recliaim Modification 2                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION   AUTHOR                   DATE              DETAIL                                
1.0 -   Keerthy Gurumurthy      23/04/2018        INITIAL DEVELOPMENT 
1.1 -   KArthik Golakaram       11/02/2020        Made Changes to display language  
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
private class CS_header_Test {

   
    static testMethod void dologin1() 
    {     
      App_Mapping__c app=new App_Mapping__c();
        app.name='FleetguardFit';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_OAM_Resource_URL__c = 'https://csouat-cumminscss.cs3.force.com/cw/idp/login?app=0spQ0000000CaZk&resource_url=https://rsweb-stg-ac.cummins.com/RSW/home.action';
        app.IAM_Default_Role__c='User';
        app.IAM_App_Protected_By__c='SAML';
        insert app;
       
       test.startTest();
       ApexPages.currentPage().getParameters().put('appid', app.id);
       CS_header controller = new CS_header();     
       controller.currentRecordId =app.id;
       controller.app = app;
       test.stopTest();    
    } 
}