@IsTest(seeAllData=True)
public class IAM_ExistCompUserSubCreation_CS_Test {
    static testmethod void createCSrecord(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = acc.id;                
        obj.IAM_Subscription_Start_Date__c = system.today();
        obj.IAM_Subscription_End_Date__c = system.today()+10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'PrimaryContact';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
        Test.startTest();
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo sub =
            getSubscription('checkReNewUser','checkReNewUser','checkReNewUser@test.com','checkReNewUser@test.com','','PC','Secondary','Active',date.valueof('2018-08-06'),date.valueof('2018-09-06'),'Connected Solutions',
                             'AccountManager','Active','External','checkReNewUser@test.com','Connected Solutions');
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(sub);
        System.assertEquals(true, res != null);
        Test.stopTest();
    }
    static testmethod void createCSrecord2(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        Test.startTest();
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo sub =
            getSubscription('checkReNewUser','checkReNewUser','checkReNewUser@test.com','checkReNewUser@test.com','65756577575','PC','Secondary','Active',date.valueof('2018-08-06'),date.valueof('2018-09-06'),'Connected Solutions',
                             'AccountManager','Active','External','checkReNewUser@test.com','Connected Solutions');
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(sub);
        System.assertEquals(true, res != null);
        Test.stopTest();
    }
    static testmethod void createCSrecord3(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = acc.id;                
        obj.IAM_Subscription_Start_Date__c = system.today();
        obj.IAM_Subscription_End_Date__c = system.today()+10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
        Test.startTest();
        
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo();
        List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo> subList = new List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo>();
        List<IAM_ExistCompUserSubCreation_CS.userInfo> usrList = new List<IAM_ExistCompUserSubCreation_CS.userInfo>();
             
            IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub.startDate=system.today();
            sub.endDate=system.today()+100;
            sub.applicationName='Connected Solutions';
            sub.role='AccountManager';
            sub.free=true;
            sub.subscriptionType='Active';
            sub.source='pc';
            sub.userType='External';
            sub.userEmail='checkReNewUser@test.com';
            sub.subscriptionName='Connected Solutions';
            subList.add(sub);
             IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub2 =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub2.startDate=system.today();
            sub2.endDate=system.today()+100;
            sub2.applicationName='Connected Solutions';
            sub2.role='AccountManager';
            sub2.free=true;
            sub2.subscriptionType='Active';
            sub2.source='pc';
            sub2.userType='External';
            sub2.userEmail='checkReNewUser1@test.com';
            sub2.subscriptionName='Connected Solutions';
            subList.add(sub2);  
            mainSub.subscriptionInfo = subList;
        
            IAM_ExistCompUserSubCreation_CS.userInfo usr = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr.source='PC';
            usr.phone='';
            usr.contactType= 'Secondary';
            usr.email='checkReNewUser1@test.com"';
            usr.username='checkReNewUser1@test.com"';
            usr.contactStatus='Active';                                     
            usr.firstName='checkReNewUser';
            usr.lastName='checkReNewUser1'; 
            usrList.add(usr);
            IAM_ExistCompUserSubCreation_CS.userInfo usr2 = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr2.source='PC';
            usr2.phone='';
            usr2.contactType= 'Secondary';
            usr2.email='checkReNewUser@test.com"';
            usr2.username='checkReNewUser@test.com"';
            usr2.contactStatus='Active';                                     
            usr2.firstName='checkReNewUser';
            usr2.lastName='checkReNewUser'; 
            usrList.add(usr2);
            mainSub.userInfo = usrList;
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(mainSub);
        System.assertEquals(true, res != null);
        Test.stopTest();
        
    }    
     static testmethod void createCSrecord4(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = acc.id;                
        obj.IAM_Subscription_Start_Date__c = system.today();
        obj.IAM_Subscription_End_Date__c = system.today()+10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
        Test.startTest();
        
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo();
        List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo> subList = new List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo>();
        List<IAM_ExistCompUserSubCreation_CS.userInfo> usrList = new List<IAM_ExistCompUserSubCreation_CS.userInfo>();
          IAM_ExistCompUserSubCreation_CS.userInfo usr = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr.source='PC';
            usr.phone='';
            usr.contactType= 'Secondary';
            usr.email=null;
            usr.username='checkReNewUser1@test.com"';
            usr.contactStatus='Active';                                     
            usr.firstName='checkReNewUser';
            usr.lastName='checkReNewUser1'; 
            usrList.add(usr);
         mainSub.userInfo = usrList;
         IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub2 =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub2.startDate=system.today();
            sub2.endDate=system.today()+100;
            sub2.applicationName=null;
            sub2.role='AccountManager';
            sub2.free=true;
            sub2.subscriptionType='Active';
            sub2.source='pc';
            sub2.userType='External';
            sub2.userEmail='checkReNewUser1@test.com';
            sub2.subscriptionName='Connected Solutions';
            subList.add(sub2);  
            mainSub.subscriptionInfo = subList;
          RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(mainSub);
        System.assertEquals(true, res != null);
         Test.stopTest();
     }
    static testmethod void createCSrecord5(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = acc.id;                
        obj.IAM_Subscription_Start_Date__c = system.today();
        obj.IAM_Subscription_End_Date__c = system.today()+10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
        Test.startTest();
        
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo();
        List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo> subList = new List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo>();
        List<IAM_ExistCompUserSubCreation_CS.userInfo> usrList = new List<IAM_ExistCompUserSubCreation_CS.userInfo>();
          IAM_ExistCompUserSubCreation_CS.userInfo usr = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr.source='PC';
            usr.phone='';
            usr.contactType= null;
            usr.email='test@test.com';
            usr.username='checkReNewUser1@test.com"';
            usr.contactStatus='Active';                                     
            usr.firstName='checkReNewUser';
            usr.lastName='checkReNewUser1'; 
            usrList.add(usr);
         mainSub.userInfo = usrList;
        IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub2 =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub2.startDate=system.today();
            sub2.endDate=system.today()+100;
            sub2.applicationName='Connected Solutions';
            sub2.role=null;
            sub2.free=true;
            sub2.subscriptionType='Active';
            sub2.source='pc';
            sub2.userType='External';
            sub2.userEmail='checkReNewUser1@test.com';
            sub2.subscriptionName='Connected Solutions';
            subList.add(sub2);  
            mainSub.subscriptionInfo = subList;
          RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(mainSub);
        System.assertEquals(true, res != null);
        IAM_ExistCompUserSubCreation_CS.cmiError('error');
         Test.stopTest();
     }
    static testmethod void createCSrecord6(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = acc.id;                
        obj.IAM_Subscription_Start_Date__c = system.today();
        obj.IAM_Subscription_End_Date__c = system.today()+10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
        Test.startTest();
        
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo();
        List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo> subList = new List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo>();
        List<IAM_ExistCompUserSubCreation_CS.userInfo> usrList = new List<IAM_ExistCompUserSubCreation_CS.userInfo>();
          IAM_ExistCompUserSubCreation_CS.userInfo usr = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr.source=null;
            usr.phone='';
            usr.contactType= 'Secondary';
            usr.email='test@test.com';
            usr.username='checkReNewUser1@test.com"';
            usr.contactStatus='Active';                                     
            usr.firstName='checkReNewUser';
            usr.lastName='checkReNewUser1'; 
            usrList.add(usr);
         mainSub.userInfo = usrList;
        IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub2 =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub2.startDate=system.today();
            sub2.endDate=system.today()+100;
            sub2.applicationName='Connected Solutions';
            sub2.role='AccountManager';
            sub2.free=true;
            sub2.subscriptionType=null;
            sub2.source='pc';
            sub2.userType='External';
            sub2.userEmail='checkReNewUser1@test.com';
            sub2.subscriptionName='Connected Solutions';
            subList.add(sub2);  
            mainSub.subscriptionInfo = subList;
          RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(mainSub);
        System.assertEquals(true, res != null);
         Test.stopTest();
     }  
    static testmethod void createCSrecord7(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = acc.id;                
        obj.IAM_Subscription_Start_Date__c = system.today();
        obj.IAM_Subscription_End_Date__c = system.today()+10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
        Test.startTest();
        
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo();
        List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo> subList = new List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo>();
        List<IAM_ExistCompUserSubCreation_CS.userInfo> usrList = new List<IAM_ExistCompUserSubCreation_CS.userInfo>();
          IAM_ExistCompUserSubCreation_CS.userInfo usr = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr.source='pc';
            usr.phone='';
            usr.contactType= 'Secondary';
            usr.email='test@test.com';
            usr.username='checkReNewUser1@test.com"';
            usr.contactStatus=null;                                     
            usr.firstName='checkReNewUser';
            usr.lastName='checkReNewUser1'; 
            usrList.add(usr);
         mainSub.userInfo = usrList;
        IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub2 =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub2.startDate=system.today();
            sub2.endDate=system.today()+100;
            sub2.applicationName='Connected Solutions';
            sub2.role='AccountManager';
            sub2.free=true;
            sub2.subscriptionType='Active';
            sub2.source=null;
            sub2.userType='External';
            sub2.userEmail='checkReNewUser1@test.com';
            sub2.subscriptionName='Connected Solutions';
            subList.add(sub2);  
            mainSub.subscriptionInfo = subList;
          RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(mainSub);
        System.assertEquals(true, res != null);
         Test.stopTest();
     }  
    static testmethod void createCSrecord8(){
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        
        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        acc.CMI_Account_Status__c ='Active';
        acc.CMI_CDA_Status__c='New Customer Request';
        acc.Type = 'Customer';
        acc.CMI_CId__c='927';
        insert acc;
        system.debug('acc@@@#'+acc.CMI_CId__c);
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = acc.id;                
        obj.IAM_Subscription_Start_Date__c = system.today();
        obj.IAM_Subscription_End_Date__c = system.today()+10;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert obj;
        System.debug('#### Account access obj '+obj);
        Test.startTest();
        
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo();
        List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo> subList = new List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo>();
        List<IAM_ExistCompUserSubCreation_CS.userInfo> usrList = new List<IAM_ExistCompUserSubCreation_CS.userInfo>();
            IAM_ExistCompUserSubCreation_CS.userInfo usr = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr.source='PC';
            usr.phone='';
            usr.contactType= 'Secondary';
            usr.email='checkReNewUser1@test.com';
            usr.username='checkReNewUser1@test.com"';
            usr.contactStatus='Active';                                     
            usr.firstName='checkReNewUser1';
            usr.lastName='checkReNewUser1'; 
            usrList.add(usr);
            IAM_ExistCompUserSubCreation_CS.userInfo usr2 = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr2.source='PC';
            usr2.phone='';
            usr2.contactType= 'Secondary';
            usr2.email='checkReNewUserNishant@test.com';
            usr2.username='checkReNewUserNishant@test.com';
            usr2.contactStatus='Active';                                     
            usr2.firstName='checkReNewUser';
            usr2.lastName='Nishanttest'; 
            usrList.add(usr2);
            mainSub.userInfo = usrList; 
        
        
            IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub.startDate=system.today();
            sub.endDate=system.today()+100;
            sub.applicationName='Connected Solutions';
            sub.role='AccountManager';
            sub.free=true;
            sub.subscriptionType='Active';
            sub.source='pc';
            sub.userType='External';
            sub.userEmail='checkReNewUser1@test.com';
            sub.subscriptionName='Connected Solutions';
            subList.add(sub);
             IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub2 =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub2.startDate=system.today();
            sub2.endDate=system.today()+100;
            sub2.applicationName='Connected Solutions';
            sub2.role='AccountManager';
            sub2.free=true;
            sub2.subscriptionType='Active';
            sub2.source='pc';
            sub2.userType='External';
            sub2.userEmail='checkReNewUserNishant@test.com';
            sub2.subscriptionName='Connected Solutions';
            subList.add(sub2);  
            mainSub.subscriptionInfo = subList;
        
            
        
        RestRequest request = new RestRequest();
        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/location/UserSubscriptioncreation_CS/'
            + acc.CMI_CId__c;
        request.httpMethod = 'POST';
        RestContext.request = request;        
        
        IAM_ExistCompUserSubCreation_CS.CMI_ResponseHandler res =
            IAM_ExistCompUserSubCreation_CS.Post(mainSub);
        System.assertEquals(true, res != null);
        Test.stopTest();
        
    }    
    /* Prepare Subcription Data for Request Body */
    private static IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo getSubscription(String firstName,string lastName,string email,string username, string phone,string source, string contactType,string contactStatus,date startDate,
        date endDate,string applicationName,string role, string subscriptiontype,string userType,string userEmail,string subscriptionName) {          
            
        IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo mainSub = 
            new IAM_ExistCompUserSubCreation_CS.UserLocationSubscriptionInfo();
        List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo> subList = new List<IAM_ExistCompUserSubCreation_CS.subscriptionInfo>();
        List<IAM_ExistCompUserSubCreation_CS.userInfo> usrList = new List<IAM_ExistCompUserSubCreation_CS.userInfo>();
               
        /* Subscription Info */
            IAM_ExistCompUserSubCreation_CS.subscriptionInfo sub =new IAM_ExistCompUserSubCreation_CS.subscriptionInfo();
            sub.startDate=startDate;
            sub.endDate=endDate;
            sub.applicationName=applicationName;
            sub.role=role;
            sub.free=true;
            sub.subscriptionType=subscriptionType;
            sub.source=source;
            sub.userType=userType;
            sub.userEmail=userEmail;
            sub.subscriptionName=subscriptionName;
            subList.add(sub);  
            mainSub.subscriptionInfo = subList;
        
        /* User Info */ 
            IAM_ExistCompUserSubCreation_CS.userInfo usr = new IAM_ExistCompUserSubCreation_CS.userInfo();
            usr.source=source;
            usr.phone=phone;
            usr.contactType= contactType;
            usr.email=email;
            usr.username=username;
            usr.contactStatus=contactStatus;                                     
            usr.firstName=firstName;
            usr.lastName=lastName; 
            usrList.add(usr);
            mainSub.userInfo = usrList;
            
        return mainSub;
    }

}