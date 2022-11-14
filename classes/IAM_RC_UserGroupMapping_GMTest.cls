@isTest
private class IAM_RC_UserGroupMapping_GMTest{

    @isTest
    static void Test01(){
    
    Account accSampleRecord = new Account(name='AccountTest1',
                                   CMI_Account_Status__c='Pending',
                                   CMI_CDA_Status__c='New Customer Request'
                                                                 
                                   );
    
        insert accSampleRecord;
        
        Contact contSampleRecord = new Contact(
            FirstName = 'Test',
            LastName ='User',
            Email = 'lstTest@test.com',
            AccountId = accSampleRecord.ID,
            IAM_Contact_Status__c = 'Active',
            CMI_Contact_Type__c = 'Primary',
            IAM_Cummins_login_ID__c = 'Amartest@abc.com',
            Phone = '9743800309',
            IAM_Internal__c = true
        );
    
        insert contSampleRecord;
        
         IAM_Application__c iamAppSampleRecord    = new IAM_Application__c(    
            IAM_Account_Name__c = accSampleRecord.ID,
            IAM_Application_Name__c = 'CUMPAS 2.0',
            IAM_Role__c='Vendor User',
            IAM_Status__c='Active',
            IAM_Subscription_Count__c= 10,
            IAM_Provisioned_User_Count__c=5,
            IAM_Subscription_End_Date__c= System.today() + 5,
            IAM_Subscription_Name__c='TestSubscription1',
            IAM_Free_Subscription__c= False,
            IAM_Subscription_Start_Date__c=System.today()
        );
        
        insert iamAppSampleRecord;
        
        IAM_Contact_Provisioning__c iamContSampleRecord = new IAM_Contact_Provisioning__c(
        IAM_Account_Application__c = iamAppSampleRecord.ID,
        RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(),
        IAM_Application_Name__c = 'CUMPAS 2.0',
        IAM_Contact__c= contSampleRecord.Id,
        IAM_End_Date__c= System.today() + 5,
        IAM_Role__c='Dealer User',
        IAM_Start_Date__c=System.today(),
        IAM_Status__c='Active'
        //recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId()
        );
        insert iamContSampleRecord; 
        
        IAM_Application_Groups__c appgroup = new IAM_Application_Groups__c();

        appgroup.name = 'Cumpas 2.6';
        appgroup.IAM_Application_Name__c = 'CUMPAS 2.0';
        appgroup.IAM_DN_value__c    =   'cn=DBU_DN_DEALER_USERS,ou=App_DBU_Commerce,ou=application,dc=cummins,dc=com';
        appgroup.IAM_Free_application__c = true;
        appgroup.IAM_Group_Type__c    = 'dynamic';
        appgroup.IAM_Role_Name__c = 'Dealer User';
        insert appgroup;
        
        Set<Id> cpIds = new set<Id>();
        cpIds.add(iamContSampleRecord.Id);
        list<IAM_Contact_Provisioning__c> lstconpro= new list<IAM_Contact_Provisioning__c >();
        lstconpro.add(iamContSampleRecord);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        IAM_RC_UserGroupMapping_GM obj = new IAM_RC_UserGroupMapping_GM();
        IAM_RC_UserGroupMapping_GM.basicAuthCallout_GM(cpIds,'Test','Test',true,true);
        IAM_RC_UserGroupMapping_GM.UserApp objdata = new IAM_RC_UserGroupMapping_GM.UserApp();
        objdata.uid = 'Test';
        objdata.applicationGroups =  'Test';
        objdata.grouptype = 'Test';
        objdata.workgroupId = 'Test';
        objdata.branch = 'Test';
        objdata.usertype = 'Test';
        IAM_RC_UserGroupMapping_GM.UserPayload userinfo = new  IAM_RC_UserGroupMapping_GM.UserPayload(lstconpro,'Test','Test',true,true);
        Test.stopTest();
    
    }

}