/*************************************************************************************
Name:  IAM_WWSPS_Loc_Data_Tranformation_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class for IAM_WWSPS_Location_Data_Tranformation
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Shubhnagi Sardar          12/16/2020        INITIAL DEVELOPMENT
1.1      Brant Logan               2/3/2021          Made changes for capturing extra attributes.Changes
1.2      Ravi Sakali               06/18/2021        Added new attributes
1.3      Lavanya Javvadi           02/08/2022        Billing Address Population
1.4      Ganesh K M                06/02/2022        Made changes to achieve code coverage

**************************************************************************************
**************************************************************************************/
@isTest
public class IAM_WWSPS_Loc_Data_Tranformation_Test {

    //valid New Scenario
    static testmethod void createTest1() {
        Test.startTest();
        
      
          
        String JsonMsg='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Cummins Fully Owned","Buss_entity_name":"Filtration","Action":"New","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456", "AlternatePartnerId": "A-233312", "ResponsibleRegionCode": "02850","dtna":"Y"}}';
        

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
                
        IAM_WWSPS_Location_Data_Tranformation.captureError('Test','Test');
        
        
        //adding power gen.
        String JsonMsg1='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Cummins Fully Owned","Buss_entity_name":"Filtration","Action":"New","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456", "AlternatePartnerId": "A-233312", "ResponsibleRegionCode": "02850","dtna":"Y"}}';
        

        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();

        req1.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof(JsonMsg1);
        RestContext.request = req1;
        RestContext.response= res1;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
      
        
        
        //updating filtratoin.
        String JsonMsg3='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Private","Buss_entity_name":"Power Generation","Action":"New","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"Y"}}';
        

        RestRequest req3 = new RestRequest(); 
        RestResponse res3 = new RestResponse();

        req3.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        req3.httpMethod = 'POST';
        req3.requestBody = Blob.valueof(JsonMsg3);
        RestContext.request = req3;
        RestContext.response= res3;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
        
        //updating Turbo.
        String JsonMsg4='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Private","Buss_entity_name":"Engines","Action":"New","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"Y"}}';
        

        RestRequest req4 = new RestRequest(); 
        RestResponse res4 = new RestResponse();

        req4.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        req4.httpMethod = 'POST';
        req4.requestBody = Blob.valueof(JsonMsg4);
        RestContext.request = req4;
        RestContext.response= res4;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
        String JsonMsg5='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Cummins Wholly Owned","Buss_entity_name":"Engines","Action":"New","Phone":"+230 340 26 700","DistributorCode":"007132","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"N"}}';
        

        RestRequest req5 = new RestRequest(); 
        RestResponse res5 = new RestResponse();

        req4.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        req4.httpMethod = 'POST';
        req4.requestBody = Blob.valueof(JsonMsg5);
        RestContext.request = req4;
        RestContext.response= res4;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
       
        
        
        //Change
         //updating Turbo.
        String JsonMsgChange='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Private","Buss_entity_name":"Engines","Action":"Change","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"Y"}}';
        

        RestRequest reqChange = new RestRequest(); 
        RestResponse resChange = new RestResponse();

        reqChange.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        reqChange.httpMethod = 'POST';
        reqChange.requestBody = Blob.valueof(JsonMsgChange);
        RestContext.request = reqChange;
        RestContext.response= resChange;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
          
          
          
      
       //Empty JSON Structure
        String JsonMsgEmpty='{"locationInfo":{"SPcode":"","ServiceProviderName":"","PhysicalAddress":"","City":"","State":"","Country":"","COD":"","ISOcode":"","ResposibleBranchCode":"","AccountSource":"","OwnershipName":"","Buss_entity_name":"","Action":"","Phone":"","DistributorCode":"","DistributorRegion":"","ZipCode":"","CustomerName":"BMS","CustomerNumber":"123456"}}';
        

        RestRequest reqEmp = new RestRequest(); 
        RestResponse resEmp = new RestResponse();

        reqEmp.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        reqEmp.httpMethod = 'POST';
        reqEmp.requestBody = Blob.valueof(JsonMsgEmpty);
        RestContext.request = reqEmp;
        RestContext.response= resEmp;
        IAM_WWSPS_Location_Data_Tranformation.post();
      
        Test.stopTest();
        
        //Cancel EBU
        String JsonMsgCancelEBU='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Private","Buss_entity_name":"Engines","Action":"Cancel","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"Y"}}';
        

        RestRequest reqCEBU = new RestRequest(); 
        RestResponse resCEBU = new RestResponse();

        reqCEBU.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        reqCEBU.httpMethod = 'POST';
        reqCEBU.requestBody = Blob.valueof(JsonMsgCancelEBU);
        RestContext.request = reqCEBU;
        RestContext.response= resCEBU;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
        
        //Cancel PSBU
        String JsonMsgCancelPSBU='{"locationInfo":{"SPcode":"007132","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Private","Buss_entity_name":"Power Generation","Action":"Cancel","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"Y"}}';
        

        RestRequest reqCPSBU = new RestRequest(); 
        RestResponse resCPSBU = new RestResponse();

        reqCPSBU.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        reqCPSBU.httpMethod = 'POST';
        reqCPSBU.requestBody = Blob.valueof(JsonMsgCancelPSBU);
        RestContext.request = reqCPSBU;
        RestContext.response= resCPSBU;
        IAM_WWSPS_Location_Data_Tranformation.post();
        
    }



    
    //Cancelled
    static testmethod void createTestCancel() {
    
        //Creating test data for Cancel.
        
        account acc2=new account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc2.name = 'CIHR Location-3';
        //acc2.parentId = pacc.Id;
        acc2.CMI_Account_Status__c = 'Active';
        acc2.CSS_DistributorCode__c='test1';
        acc2.Type='CIHR';
        acc2.IAM_Service_Provider_Code__c='13CIHR';
        insert acc2;
      
      
         Contact c = new Contact();
         c.Accountid= acc2.id;
         c.FirstName='firstName';
         c.LastName='LastName';
         c.Email='oh611@cummins.com';
         c.Username__c='Usernametestclass@gmail.com';
         c.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
         c.IAM_Internal__c=false;
         c.IAM_Legacy_User__c=false;
          
         insert c;
             
      
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Guidanz';
        app4.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc2.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Subscription_Start_Date__c=System.today();
        app4.IAM_Subscription_End_Date__c= System.today() + 5;
        app4.IAM_Subscription_Count__c = 10;
        app4.IAM_Free_Subscription__c= true;
        app4.IAM_License_Type__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Source__c = 'SwReg';
        
        app.add(app4);
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'QuickServe Online';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app5.IAM_Role__c = 'QSOL CPG Dealer Consumer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c =acc2.id;
        app5.IAM_Subscription_Name__c = 'QuickServe Online CPG';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 5;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= False;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c='SwReg';
       
        app.add(app5);
        
        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = 'QuickServe Online';
        app6.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app6.IAM_Role__c = 'QSOL CIHR';
        app6.IAM_Status__c = 'Active';
        app6.IAM_Account_Name__c =acc2.id;
        app6.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        app6.IAM_Subscription_Start_Date__c=System.today();
        app6.IAM_Subscription_End_Date__c= System.today() + 5;
        app6.IAM_Subscription_Count__c = 10;
        app6.IAM_Free_Subscription__c= False;
        app6.IAM_License_Type__c = 'test';
        app6.IAM_Qsolexpiration__c = 'test';
        app6.IAM_Source__c='SwReg';
       
        
        app.add(app6);
        
        
        IAM_Application__c app7 = new IAM_Application__c();
        app7.IAM_Application_Name__c = 'Connected Solutions';
        app7.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        app7.IAM_Role__c = 'AccountManager';
        app7.IAM_Status__c = 'Active';
        app7.IAM_Account_Name__c =acc2.id;
        //app6.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        app7.IAM_Subscription_Start_Date__c=System.today();
        app7.IAM_Subscription_End_Date__c= System.today() + 5;
        app7.IAM_Subscription_Count__c = 10;
        app7.IAM_Free_Subscription__c= True;
        app7.IAM_License_Type__c = 'test';
        app7.IAM_Qsolexpiration__c = 'test';
        app7.IAM_Source__c='Web';
       
        
        app.add(app7);
        
        insert app;
        
        
        //End creating test data
        
    
    
        Test.startTest();
        
      
          
        String JsonMsg='{"locationInfo":{"SPcode":"13CIHR","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Private","Buss_entity_name":"ALL","Action":"Cancel","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"Y"}}';
        

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_WWSPS_Location_Data_Tranformation.post();
                
        IAM_WWSPS_Location_Data_Tranformation.captureError('Test','Test');
        
        
        
      
        Test.stopTest();
    }
    
    
     //Cancelled
    static testmethod void createTestCancel2() {
    
        //Creating test data for Cancel.
        
        account acc2=new account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc2.name = 'CIHR Location-3';
        //acc2.parentId = pacc.Id;
        acc2.CMI_Account_Status__c = 'Active';
        acc2.CSS_DistributorCode__c='test1';
        acc2.Type='CIHR';
        acc2.IAM_Service_Provider_Code__c='13CIHR';
        insert acc2;
      
      
         Contact c = new Contact();
         c.Accountid= acc2.id;
         c.FirstName='firstName';
         c.LastName='LastName';
         c.Email='oh611@cummins.com';
         c.Username__c='Usernametestclass@gmail.com';
         c.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
         c.IAM_Internal__c=false;
         c.IAM_Legacy_User__c=false;
          
         insert c;
             
      
        List<IAM_Application__c> app= new List<IAM_Application__c>();
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Guidanz';
        app4.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc2.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Subscription_Start_Date__c=System.today();
        app4.IAM_Subscription_End_Date__c= System.today() + 5;
        app4.IAM_Subscription_Count__c = 10;
        app4.IAM_Free_Subscription__c= true;
        app4.IAM_License_Type__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Source__c = 'SwReg';
        
        app.add(app4);
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'QuickServe Online';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app5.IAM_Role__c = 'QSOL CPG Dealer Consumer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c =acc2.id;
        app5.IAM_Subscription_Name__c = 'QuickServe Online CPG';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 5;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= False;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c='SwReg';
       
        app.add(app5);
        
        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = 'QuickServe Online';
        app6.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app6.IAM_Role__c = 'QSOL CIHR';
        app6.IAM_Status__c = 'Active';
        app6.IAM_Account_Name__c =acc2.id;
        app6.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        app6.IAM_Subscription_Start_Date__c=System.today();
        app6.IAM_Subscription_End_Date__c= System.today() + 5;
        app6.IAM_Subscription_Count__c = 10;
        app6.IAM_Free_Subscription__c= False;
        app6.IAM_License_Type__c = 'test';
        app6.IAM_Qsolexpiration__c = 'test';
        app6.IAM_Source__c='SwReg';
       
        
        app.add(app6);
        
        
       insert app;
        
        
        //End creating test data
        
    
    
        Test.startTest();
        
      
          
        String JsonMsg='{"locationInfo":{"SPcode":"13CIHR","ServiceProviderName":"EQUIPEMENTS & SERVICES BIA","PhysicalAddress":"Level 4, Nexteracom Tower 1    Republic of Mauritius","City":"Mauritius","State":"Mauritius","Country":"Mauritius","COD":"DEALER","ISOcode":"","ResposibleBranchCode":"00713","AccountSource":"WWSPS","OwnershipName":"Private","Buss_entity_name":"ALL","Action":"Cancel","Phone":"+230 340 26 700","DistributorCode":"00713","DistributorRegion":"Africa","ZipCode":"72201","CustomerName":"BMS","CustomerNumber":"123456","dtna":"Y"}}';
        

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/wwsps/location';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_WWSPS_Location_Data_Tranformation.post();
                
        IAM_WWSPS_Location_Data_Tranformation.captureError('Test','Test');
        
        
        IAM_WWSPS_Utility.getWWSPSAdminUser();
      
        Test.stopTest();
    }
 
    
}