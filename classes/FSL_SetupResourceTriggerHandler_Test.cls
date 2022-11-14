@isTest
public class FSL_SetupResourceTriggerHandler_Test {
    static testMethod void testlogic1() {
        Id profid = [select id from profile where name='CSS_Service_Advanced'].id;
       user usr = [Select id, name from user where id =:UserInfo.getUserId()] ;
        System.runAs(usr){
            UserRole usrrole = new UserRole(DeveloperName = 'AdvancedTimothy', Name = 'ADVANCED-TIMOTHY');
            insert usrrole;
        }
       
       
        User us = new User(username='testabcsrtesting@xyz.com',email='testabcteting@xyz.com',
                           LastName='testlastname', Alias='tesname', ProfileId=profid,LanguageLocaleKey='en_US');
        list<user> uss = new List<User>();
        uss.add( new User(
            ProfileId = profid,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000ljljljkljlkjl@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
           
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true
        ));
        uss.add( new User(
            ProfileId = profid,
            LastName = 'last',
            Email = 'puser000@amamamdldlda.com',
            Username = 'puser00xjdksks0@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TESTfsds',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true
        ));
        uss.add( new User(
            ProfileId = profid,
            LastName = 'last',
            Email = 'puser000@amamamdldlda3.com',
            Username = 'puser00xjdksks03@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TESTfsds',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true
        ));
        uss.add( new User(
            ProfileId = profid,
            LastName = 'lasdfdfdfdt',
            Email = 'puser000@amamamdldlda4.com',
            Username = 'puser00xjdkskjjjkkuygggs04@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TESTfsds',
            Title = 'title',
            Alias = 'altds',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true
        ));
        uss.add( new User(
            ProfileId = profid,
            LastName = 'last',
            Email = 'puser000@amamamdldlda5.com',
            Username = 'puser00xjdksks05@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TESTfsds',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true
        ));
        uss.add( new User(
            ProfileId = profid,
            LastName = 'last',
            Email = 'puser000@amamamdldlda6.com',
            Username = 'puser00xjdksks06@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TESTfsds',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true
        ));
        uss.add( new User(
            ProfileId = profid,
            LastName = 'last',
            Email = 'puser000@amamamdldlda7.com',
            Username = 'puser00xjdksks07@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TESTfsds',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true
           
        ));
        insert uss;
       
        List<OperatingHours> ohs = new List<OperatingHours>();
       
        OperatingHours oh;
        oh=new OperatingHours();
        oh.name ='test operating hours';
        ohs.add(oh);
        oh=new OperatingHours();
        oh.name ='test operating hours222';
        ohs.add(oh);
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert ohs;
        List<ServiceTErritory> stts= new List<ServiceTerritory>();
        ServiceTerritory st;
        st = new ServiceTerritory();
        st.name = 'TEST ST Mobilennnnnkkk';
        st.OperatingHoursId=ohs[0].id;
        st.Location_Code__c='0325055-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AMERICA';
        st.Territory__c = 'AMERICAS';
        stts.add(st);
        st = new ServiceTerritory();
        st.name = 'TEST ST Mobilexyzzzz';
        st.OperatingHoursId=ohs[1].id;
        st.Location_Code__c='03250555';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02853';
        st.Region__c = 'AUSTRALIA / NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        stts.add(st);
       
        insert stts;
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
       
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        acc.IAM_Service_Provider_Code__c = '03250-02851';
        acc.Authorize_Work_Started__c = false;
        acc.Invoice_Ready__c = false;
        acc.Service_Work_Completed__c = false;
        acc.Troubleshooting_Started__c = false;
        acc.Equipment_Available__c = false;
        insert acc;
       
       
        List<ServiceResource> srcs = new List<ServiceResource>();
        srcs.add(new ServiceResource(User__c = uss[0].Id, IsActive=true, RelatedRecordId = uss[0].Id, name='s-00001'));
        srcs.add(new ServiceResource(User__c = uss[1].Id, IsActive=true, RelatedRecordId = uss[1].Id, name='s-00002'));
        srcs.add(new ServiceResource(User__c = uss[2].Id, IsActive=true, RelatedRecordId = uss[2].Id, name='s-00003'));
        srcs.add(new ServiceResource(User__c = uss[3].Id, IsActive=true, RelatedRecordId = uss[3].Id, name='s-00004'));
        srcs.add(new ServiceResource(User__c = uss[4].Id, IsActive=true, RelatedRecordId = uss[4].Id, name='s-00005'));
        srcs.add(new ServiceResource(User__c = uss[5].Id, IsActive=true, RelatedRecordId = uss[5].Id, name='s-00006'));
        srcs.add(new ServiceResource(User__c = uss[6].Id, IsActive=true, RelatedRecordId = uss[6].Id, name='s-00007'));
        insert srcs;
        Schema.DescribeSObjectResult d = Schema.SObjectType.Setup_Resource__c;
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        // Schema.RecordTypeInfo rtById =  rtMapById.get(rt.id);
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByDeveloperName();
        Contact ct=new Contact(
            firstName='fname1', lastname='lname2',
            email='adfafafdalfalkj@gma.com',
            RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId(), MobilePhone='1234512345',
            IAM_Internal__c = true, IAM_Legacy_User__c = true, IAM_Contact_Status__c = 'Active', Created_User_Id__c = false);
        insert ct;
        Test.startTest();
        List<Setup_Resource__c> sts = new List<Setup_Resource__c>();
        sts.add(new Setup_Resource__c(Service_Resource__c=srcs[0].Id, resource_type__c='Advanced', Access__c = 'Gantt;Dispatcher',recordtypeid=rtMapByName.get('Convert_Classic_User').getRecordTypeId()));
        sts.add(new Setup_Resource__c(Service_Resource__c=srcs[1].Id, resource_type__c='Technician', Access__c = 'Mobile', recordtypeid=rtMapByName.get('Convert_Classic_User').getRecordTypeId()));
        sts.add(new Setup_Resource__c(user__c=uss[1].Id, resource_type__c='Advanced', Access__c = 'Mobile',
                                      recordtypeid=rtMapByName.get('Convert_Classic_User').getRecordTypeId(), Primary_Service_Territory__c = stts[0].id));
        sts.add(new Setup_Resource__c(Service_Resource__c=srcs[2].Id, resource_type__c='Advanced', Access__c = 'Mobile;Base;Dispatcher'));        
        sts.add(new Setup_Resource__c(Service_Resource__c=srcs[3].Id, resource_type__c='Bay', Access__c = 'Mobile', lastName__c='testlastName'+system.currentTimeMillis(), firstName__c='testfirstName'+system.currentTimeMillis() , recordtypeid=rtMapByName.get('Tool_and_Bay').getRecordTypeId()));
        sts.add(new Setup_Resource__c(Service_Resource__c=srcs[4].Id, resource_type__c='Advanced', Access__c = 'Gantt;Dispatcher',recordtypeid=rtMapByName.get('Convert_Classic_User').getRecordTypeId()));
        sts.add(new Setup_Resource__c(resource_type__c='Advanced', contact__c=ct.Id,
                                      Access__c = 'Gantt;Dispatcher',recordtypeid=rtMapByName.get('WWID_New_User').getRecordTypeId()));
        sts.add(new Setup_Resource__c(Service_Resource__c=srcs[6].Id, contact__c=ct.Id, resource_type__c='Bay', Access__c = 'Mobile', lastName__c='testlastName2'+system.currentTimeMillis(), firstName__c='testfirstName2'+system.currentTimeMillis() , recordtypeid=rtMapByName.get('Tool_and_Bay').getRecordTypeId()));
       
        insert sts;
        sts[0].Access__c='Basic';
        update sts[0];
        sts[0].Access__c='Basic;Dispatcher';// 449
        update sts[0];// 449
        sts[2].access__c='Gantt;Basic';
        update sts[2];
        sts[5].access__c=null;
        //update sts[5];
        srcs[1].IsActive=false;        
        update srcs[1];
        sts[2].Primary_Service_Territory__c=stts[1].id;
        update sts[2];
        sts[2].Primary_Service_Territory__c=stts[0].id;
        update sts[2];
        FSL_SetupResourceTriggerHelper.isTestNull = true;
        sts[0].access__c='';
        //update sts[0];
        sts[6].resource_type__c='Advanced';
        update sts[6];
        //sts[6].resource_type__c='Technician';
        //update sts[6];
        Test.stopTest();
    }
}