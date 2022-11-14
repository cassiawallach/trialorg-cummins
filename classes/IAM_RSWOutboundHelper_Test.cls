/************************************************************
Name:  IAM_RSWOutboundHelper_Test
Copyright © 2020  Cummins
============================================================= 
=============================================================
Purpose:                                                            
This is Class for RSW out bound service                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakaram       09/02/2020        INITIAL DEVELOPMENT 
1.1 -    Karthik Golakaram       12/09/2020    Made changes for Mule API conversion.   
*****************************************************/
@IsTest
public class IAM_RSWOutboundHelper_Test {


  static testMethod void testRSWOutbound() {
      
      //IAM_TestData.createCSSIntegrationDetails('IAM_RSW_Registration_Mule');
	//CSS_Integration_Details__c iamRSW = IAM_getConnnectionDetails.getConnection('IAM_RSW_Registration_Mule'); 
      CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_RSW_Registration_Mule';
        csID.ApplicationName__c ='IAM_RSW_Registration_Mule';
        csID.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        csId.IsActive__c = true;
        csID.Key__c='jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==';
        csID.Passcode__c = 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==';
        csId.Username__c = 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        csID.Resource__c = 'https://api-ue-stgnf-aw-ex.cummins.com/salesforce-iam';
        insert csID;
      
    RSWOutboundCalloutMock testResponse = new RSWOutboundCalloutMock(200, 'Complete', '[{"Name": "sForceTest1"}]', null); 
    Test.setMock(HttpCalloutMock.class, testResponse);
      IAM_RSW_OutBoundReqParser_Test.setup();
      Contact c=[select id from Contact where Username__c='testRSW@eiam.com']; 
        IAM_Contact_Provisioning__c user = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c='Active' and IAM_Application_Name__c='Rapid Serve Web' and IAM_Contact__c=:c.id LIMIT 1];
      IAM_RSWOutboundHelper.RSWOutboundCall(user.id);
  }
    
    static testMethod void testRSWOutbound2() {
      CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_RSW_Registration_Mule';
        csID.ApplicationName__c ='IAM_RSW_Registration_Mule';
        csID.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        csId.IsActive__c = true;
        csID.Key__c='jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==';
        csID.Passcode__c = 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==';
        csId.Username__c = 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        csID.Resource__c = 'https://api-ue-stgnf-aw-ex.cummins.com/salesforce-iam';
        insert csID;
        
    RSWOutboundCalloutMock testResponse = new RSWOutboundCalloutMock(401, 'Complete', '[{"Name": "sForceTest1"}]', null); 
    Test.setMock(HttpCalloutMock.class, testResponse);
      IAM_RSW_OutBoundReqParser_Test.setup();
      Contact c=[select id from Contact where Username__c='testRSW@eiam.com']; 
        IAM_Contact_Provisioning__c user = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c='Active' and IAM_Application_Name__c='Rapid Serve Web' and IAM_Contact__c=:c.id LIMIT 1];
      IAM_RSWOutboundHelper.RSWOutboundCall(user.id);

  }
    static testMethod void testRSWOutbound3() {

      //IAM_TestData.createIntegrationDetails('IAM_RSW_Registration_Mule');
      CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_RSW_Registration_Mule';
        csID.ApplicationName__c ='IAM_RSW_Registration_Mule';
        csID.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        csId.IsActive__c = true;
        csID.Key__c='jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==';
        csID.Passcode__c = 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==';
        csId.Username__c = 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        csID.Resource__c = 'https://api-ue-stgnf-aw-ex.cummins.com/salesforce-iam';
        insert csID;
        
    RSWOutboundCalloutMock testResponse = new RSWOutboundCalloutMock(401, 'Complete', '[{"Name": "sForceTest1"}]', null); 
    Test.setMock(HttpCalloutMock.class, testResponse);
      IAM_RSW_OutBoundReqParser_Test.setup();
       Contact c=[select id from Contact where Username__c='testRSW@eiam.com']; 
        IAM_Contact_Provisioning__c user = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c='Active' and IAM_Application_Name__c='Rapid Serve Web' and IAM_Contact__c=:c.id LIMIT 1];
      IAM_RSWOutboundHelper.RSWOutboundCall(user.id);

  }
}