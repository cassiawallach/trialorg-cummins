/************************************************************
Name:  IAM_CDO_OutboundHelper_Test
Copyright © 2020  Cummins
============================================================= 
=============================================================
Purpose:                                                            
This is Class for CDO out bound service                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Chetan Gaikwad       28/07/2022        INITIAL DEVELOPMENT 
1.1 -    Chetan Gaikwad       09/09/2022        Update API enhancement
*****************************************************/
@IsTest
public class IAM_CDO_OutboundHelper_Test {
    
    static testMethod void testCDOOutbound() {

      CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_CDO_Registration_Mule';
        csID.ApplicationName__c ='IAM_CDO_Registration_Mule';
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
      
    CDOOutboundCalloutMock testResponse = new CDOOutboundCalloutMock(200, 'Complete', '{"Name": "sForceTest1"}', null); 
    Test.setMock(HttpCalloutMock.class, testResponse);
      IAM_CDO_OutboundReqParser_Test.setup();
      Contact c=[select id from Contact where Username__c='testCDO@eiam.com']; 
        IAM_Contact_Provisioning__c user = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c='Active' and IAM_Application_Name__c='Connected Solutions' and IAM_Contact__c=:c.id LIMIT 1];
      IAM_CDO_OutboundHelper.CDOOutboundCall(user.id,'create');
  }
    
    static testMethod void testCDOOutbound2() {
      CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_CDO_Registration_Mule';
        csID.ApplicationName__c ='IAM_CDO_Registration_Mule';
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
        
    CDOOutboundCalloutMock testResponse = new CDOOutboundCalloutMock(401, 'Complete', '[{"Name": "sForceTest1"}]', null); 
    Test.setMock(HttpCalloutMock.class, testResponse);
      IAM_CDO_OutboundReqParser_Test.setup();
      Contact c=[select id from Contact where Username__c='testCDO@eiam.com']; 
        IAM_Contact_Provisioning__c user = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c='Active' and IAM_Application_Name__c='Connected Solutions' and IAM_Contact__c=:c.id LIMIT 1];
      IAM_CDO_OutboundHelper.CDOOutboundCall(user.id,'create');

  }
    static testMethod void testCDOOutbound3() {

      //IAM_TestData.createIntegrationDetails('IAM_RSW_Registration_Mule');
      CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_CDO_Registration_Mule';
        csID.ApplicationName__c ='IAM_CDO_Registration_Mule';
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
        
    CDOOutboundCalloutMock testResponse = new CDOOutboundCalloutMock(401, 'Complete', '[{"Name": "sForceTest1"}]', null); 
    Test.setMock(HttpCalloutMock.class, testResponse);
      IAM_CDO_OutboundReqParser_Test.setup();
       Contact c=[select id from Contact where Username__c='testCDO@eiam.com']; 
        IAM_Contact_Provisioning__c user = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c='Active' and IAM_Application_Name__c='Connected Solutions' and IAM_Contact__c=:c.id LIMIT 1];
      IAM_CDO_OutboundHelper.CDOOutboundCall(user.id,'null');
        Set<Id> ConIds = new Set<Id>();
        ConIds.add(c.id);
       IAM_CDO_OutboundHelper.getConnectedSoltuionProvisionings(ConIds);
  }
}