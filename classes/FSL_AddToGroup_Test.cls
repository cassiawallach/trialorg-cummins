@isTest 
public class FSL_AddToGroup_Test {
    public static List<User> uss = new List<User>();
    static testMethod void testMethod1() {
        Test.startTest();
        Id profId = [SELECT Id FROM Profile WHERE Name = 'CSS_Service_Advanced'].Id;
        uss.add( new User(
            ProfileId = profId,
            LastName = 'AdminPortal',
            Email = 'testuser@cummins.com',
            Username = 'adminportalvinod@cummins.com',
            CompanyName = 'Cummins',
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
        /* Id permId = [SELECT Id FROM PermissionSet WHERE Name = 'FSL_Manage_Resources'].Id;
List<PermissionSetAssignment> psas = new List<PermissionSetAssignment>();
PermissionSetAssignment psa1 = new PermissionSetAssignment(AssigneeId = uss[0].Id, PermissionSetId = permId1);
psas.add(psa1);
insert psas; */
        Schema.DescribeSObjectResult d = Schema.SObjectType.Setup_Resource__c;
        Map<Id, Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        // Schema.RecordTypeInfo rtById =  rtMapById.get(rt.id);
        Map<String, Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByDeveloperName();
        List<OperatingHours> ohs = new List<OperatingHours>();
        OperatingHours oh;
        oh = new OperatingHours();
        oh.name = 'test operating hours';
        ohs.add(oh);
        oh = new OperatingHours();
        oh.name = 'test operating hours222';
        ohs.add(oh);
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert ohs;
        List<ServiceTErritory> stts = new List<ServiceTerritory>();
        ServiceTerritory st;
        st = new ServiceTerritory();
        st.name = 'TEST ST Mobilennnnn';
        st.OperatingHoursId = ohs[0].id;
        st.Location_Code__c = '03250-02851';
        st.IsActive = true;
        st.Type__c ='Group';
        st.FSL_Service_Territory_Code__c = '02851';
        st.Region__c = 'AMERICA';
        st.Territory__c = 'AMERICAS';
        stts.add(st);
        st = new ServiceTerritory();
        st.name = 'TEST ST Mobilexyzzzz';
        st.OperatingHoursId = ohs[1].id;
        st.Location_Code__c = '03250-02853';
        st.IsActive = true;
        //st.Type__c ='Group';
        st.FSL_Service_Territory_Code__c = '02853';
        st.Region__c = 'AUSTRALIA / NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        stts.add(st);
        insert stts;
        User usr = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (usr) {
            ServiceResource src = new ServiceResource(User__c = usr.Id,
                                                      IsActive = true, 
                                                      RelatedRecordId = usr.Id,
                                                      Name = 'AP-00001');
            insert src;
            Setup_Resource__c sr = new Setup_Resource__c(Service_Resource__c = src.Id, 
                                                         Resource_Type__c = 'Advanced', 
                                                         Access__c = 'Gantt;Dispatcher', 
                                                         RecordTypeId = rtMapByName.get('Convert_Classic_User').getRecordTypeId());
            insert sr;
            sr.User__c = uss[0].Id;
            update sr;
            FSL__User_Territory__c userT = new FSL__User_Territory__c();
            userT.FSL__ServiceTerritory__c = stts[0].Id;
            userT.FSL__User__c = uss[0].Id;
            userT.FSL_Setup_Resource__c = sr.Id;
            insert userT;
            Group grp = new Group();
            grp.name = 'Admin Portal';
            grp.Type = 'Regular';
            insert grp;
            GroupMember gpm = new GroupMember();
            gpm.GroupId = grp.Id;
            gpm.UserOrGroupId = usr.Id;
            insert gpm;
        }
        Test.stopTest();
    }
}