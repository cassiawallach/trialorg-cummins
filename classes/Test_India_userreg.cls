@IsTest
public class Test_India_userreg
{
    static testMethod void myUnitTest6()
    {
        User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [select id from profile where name='EIDM_Community'];
        System.runAs(thisUser){
            Account a = new Account(Name='testabc',BillingStreet='abc',BillingCity='banglore',billingcountry='India',CMI_CId__c='123456');
            insert a;
            update a;
            Contact con = new Contact(FirstName = 'testbac',LastName='testbac',Email='ca@gmail.com',Phone='8951633664',
            MailingStreet='testbac',MailingCity='Ongole',MailingPostalCode='523002',mailingcountry='India',mailingstate='Andhra Pradesh' ,
            District_ABO__c='Krishna',Customer_Name__c='testabc');
            //insert con;
            Test.startTest();
            ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
            ApexPages.StandardController san = new ApexPages.StandardController(a);
            ABO_userreg usr = new ABO_userreg(san);
            usr.newcon = new Contact();
            usr.getCountries();
            usr.newCon.mailingcountry='India';
            usr.getStates();
            usr.newCon.mailingState='Andhra Pradesh';
            usr.getDistricts();
            usr.newCon.District_ABO__c='Krishna';
            usr.getCities();
            usr.newCon.phone='895163364';
            usr.SendEmail();
            usr.OTP1='123457';
            usr.newCon.Email='prashanth';
            usr.newCon.MailingPostalCode='12345';
            usr.send();
            //usr.doResetPassword();
            pagereference ref = Page.ABO_Regconfirm_page;
            ref.setRedirect(true);
            Test.stopTest();
        }
    }
    static testMethod void myUnitTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpAzure_Service());
        User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [select id from profile where name='EIDM_Community'];
        System.runAs(thisUser){
            Account a = new Account(Name='testabc',BillingStreet='abc',BillingCity='banglore',billingcountry='India',CMI_CId__c='123456');
            insert a;
            update a;
            Contact con = new Contact(FirstName = 'testbac',LastName='testbac',Email='ca@gmail.com',Phone='8951633664',MailingStreet='testbac',MailingCity='Ongole',MailingPostalCode='523002',mailingcountry='India',mailingstate='Andhra Pradesh' ,
            District_ABO__c='prakasam',Customer_Name__c='testabc');
            //insert con;
            Account a1 = new Account(Name='testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
            insert a1;
            update a1;
            PageReference pageRef = Page.ABO_User_Reg;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
            ApexPages.StandardController san = new ApexPages.StandardController(a);
            ABO_userreg usr = new ABO_userreg(san);
            usr.newcon = con;
            // usr.actUpdate();
            // usr.getURL();
            // India_userreg.validateEmail('prahanth434@gmail.com',true);
            // India_userreg.validateEmail('prahanth434@gmail.com,bhas323@gmail.com',false);
            usr.SendEmail();
            usr.OTP1='123456';
            usr.emailcheck();
            usr.getCountries();
            usr.getStates();
            usr.getDistricts();
            usr.getCities();
            usr.newCon.MailingCountry='India';
            usr.newCon.MailingState='Telangana';
            usr.newCon.District_ABO__c='Hyderabad';
            usr.newCon.MailingCity='Secunderabad';
            // usr.reset();
            usr.send();
            usr.back();
            // usr.reset();
            //usr.doResetPassword();
            // pagereference ref = Page.ABO_Regconfirm_page;
            // ref.setRedirect(true);
        }
    }
    static testMethod void myUnitTest2()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpAzure_Service());
        User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [select id from profile where name='EIDM_Community'];
        System.runAs(thisUser){
            Account a = new Account(Name='testabc',BillingStreet=null,BillingCity=null,billingcountry='India',CMI_CId__c='1234');
            insert a;
            update a;
            Contact con = new Contact(FirstName = null,LastName='jas',Email='',Phone='8951633648',MailingStreet='',MailingCity='',MailingPostalCode='52302',mailingcountry='',mailingstate='' ,
            District_ABO__c='',Customer_Name__c='');
            insert con;
            ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
            ApexPages.StandardController san = new ApexPages.StandardController(a);
            ABO_userreg usr = new ABO_userreg(san);
            usr.newcon = con;
            usr.OTP1='123456';
            // usr.actUpdate();
            // usr.getURL();
            usr.SendEmail();
            usr.OTP1='123456';
            usr.emailcheck();
            usr.getCountries();
            usr.getStates();
            usr.getDistricts();
            usr.getCities();
            // usr.reset();
            usr.newCon.MailingCountry='India';
            usr.newCon.MailingState='Andhra Pradesh';
            usr.newCon.District_ABO__c='Hyderabad';
            usr.newCon.MailingCity='Secunderabad';
            usr.send();
            usr.back();
            //usr.doResetPassword();
            pagereference ref = Page.ABO_Regconfirm_page;
            ref.setRedirect(true);
        }
    }
    static testMethod void myUnitTest3()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpAzure_Service());
        User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [select id from profile where name='EIDM_Community'];
        System.runAs(thisUser){
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account a = new Account(Name='testabc',BillingStreet=null,BillingCity=null,billingcountry='India',CMI_CId__c='1234',Recordtypeid=devRecordTypeId );
            insert a;
            update a;
            Contact con = new Contact(LastName='jas',Email='',MailingStreet='',MailingCity='',
            MailingPostalCode='',mailingcountry='',mailingstate='', District_ABO__c='',Customer_Name__c='');
            insert con;
            ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
            ApexPages.StandardController san = new ApexPages.StandardController(a);
            ABO_userreg usr = new ABO_userreg(san);
            usr.newcon.Phone='8791234456';
            // usr.actUpdate();
            // usr.getURL();
            usr.SendEmail();
            usr.OTP1='123456';
            usr.emailcheck();
            usr.getCountries();
            usr.getStates();
            usr.getDistricts();
            usr.getCities();
            //usr.newcon = con;
            usr.newcon.LastName=Null;
            usr.newcon.Email='prasanth@s533@gmail.com';
            usr.newcon.Phone=Null;
            usr.newcon.mailingcity=Null;
            usr.newcon.District_ABO__c=Null;
            usr.newcon.mailingcountry ='None';
            usr.newcon.mailingstate = Null;
            usr.newcon.MailingPostalCode =Null;
            usr.OTP1=Null;
            // usr.reset();
            usr.send();
            usr.newcon.mailingcountry ='Bhutan';
            /// usr.newcon.mailingstate = Null;
            usr.newcon.MailingPostalCode ='1234';
            usr.send();
            usr.back();
            //usr.doResetPassword();
            pagereference ref = Page.ABO_Regconfirm_page;
            ref.setRedirect(true);
        }
    }
    static testMethod void myUnitTest4()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpAzure_Service());
        User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [select id from profile where name='EIDM_Community'];
        System.runAs(thisUser){
            Id recId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account a = new Account(Name='testabc',BillingStreet='abc',BillingCity='banglore',billingcountry='India',CMI_CId__c='123456');
            insert a;
            update a;
            Contact con = new Contact(FirstName = 'testbac',LastName='testbac',Email='ca@gmail.com',Phone='8951633664',MailingStreet='testbac',MailingCity='Ongole',MailingPostalCode='523002',mailingcountry='India',mailingstate='Andhra Pradesh' ,
            District_ABO__c='prakasam',Customer_Name__c='testabc');
            //insert con;
            Account a1 = new Account(Name='testabc testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
            a1.RecordTypeId=recId1;
            a1.Name=con.FirstName+ ' '+con.LastName;
            insert a1;
            update a1;
            PageReference pageRef = Page.ABO_User_Reg;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
            ApexPages.StandardController san = new ApexPages.StandardController(a);
            ABO_userreg usr = new ABO_userreg(san);
            usr.newcon = con;
            // usr.actUpdate();
            // usr.getURL();
            // India_userreg.validateEmail('prahanth434@gmail.com',true);
            // India_userreg.validateEmail('prahanth434@gmail.com,bhas323@gmail.com',false);
            usr.SendEmail();
            usr.OTP1='123456';
            usr.emailcheck();
            usr.getCountries();
            usr.getStates();
            usr.getDistricts();
            usr.getCities();
            usr.reset();
            usr.newCon.MailingCountry='India';
            usr.newCon.MailingState='Andhra Pradesh';
            usr.newCon.District_ABO__c='Hyderabad';
            usr.newCon.MailingCity='Secunderabad';
            usr.newCon.MailingPostalCode='523002';
            usr.send();
            usr.back();
            // usr.reset();
            //usr.doResetPassword();
            // pagereference ref = Page.ABO_Regconfirm_page;
            // ref.setRedirect(true);
        }
    }
    static testMethod void myUnitTest10()
    {
        User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        Profile p = [select id from profile where name='EIDM_Community'];
        Id recId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Account a = new Account(Name='testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
        a.RecordTypeId=recId1;
        insert a;
        update a;
        Contact con = new Contact(FirstName = 'testbac',LastName='testbac',Email='ca@gmail.com',
        Phone='8951633664',MailingStreet='testbac',MailingCity='Ongole',MailingPostalCode='523023',mailingcountry='Nepal',mailingstate='Andhra Pradesh' ,
        District_ABO__c='prakasam',Customer_Name__c='testabc');
        //insert con;
        Account a1 = new Account(Name='testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
        a1.RecordTypeId=recId1;
        //a1.Name=con.FirstName+ ' '+con.LastName;
        insert a1;
        update a1;
        PageReference pageRef = Page.ABO_User_Reg;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
        ApexPages.StandardController san = new ApexPages.StandardController(a);
        ABO_userreg usr = new ABO_userreg(san);
        usr.newcon = con;
        // usr.actUpdate();
        // usr.getURL();
        // India_userreg.validateEmail('prahanth434@gmail.com',true);
        // India_userreg.validateEmail('prahanth434@gmail.com,bhas323@gmail.com',false);
        usr.SendEmail();
        usr.OTP1='123456';
        usr.emailcheck();
        usr.getCountries();
        usr.getStates();
        usr.getDistricts();
        usr.getCities();
        usr.newCon.MailingCountry='India';
        usr.newCon.MailingState='Andhra Pradesh';
        usr.newCon.District_ABO__c='Hyderabad';
        usr.newCon.MailingCity='Secunderabad';
        usr.newCon.MailingPostalCode='523023';
        //usr.reset();
        usr.send();
        // PageReference pageRef1 = Page.ABO_User_Reg;
        // Test.setCurrentPage(pageRef1);
        List<User> u = [Select Id, ContactId FROM User Where ContactId =:usr.newCon.Id] ;
        System.assertnotequals(null, u[0].Id);
        pageRef.getParameters().put('userId',u[0].Id);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(a1);
        ABO_userreg obj1=new ABO_userreg(sc1);
        obj1.OTP1='123456';
        obj1.newCon.MailingCountry='India';
        obj1.newCon.MailingState='Andhra Pradesh';
        obj1.newCon.District_ABO__c='Hyderabad';
        obj1.newCon.MailingCity='Secunderabad';
        obj1.newCon.MailingPostalCode='523002';
        obj1.SendEmail();
        obj1.OTP1='123456';
        obj1.send();
        obj1.back();
        ABO_userreg.sendmailToAdmin(obj1.newCon,'Test mail');
        // ApexPages.StandardController sc2 = new ApexPages.StandardController(a1);
        // India_userreg obj2=new India_userreg(sc2);
        // obj2.actupdate();
        //obj1.actupdate();
    }
    static testMethod void myUnitTest13()
    {
            User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
            UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
            Profile p = [select id from profile where name='EIDM_Community'];
            Id recId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account a = new Account(Name='testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
            a.RecordTypeId=recId1;
            insert a;
            update a;
            Contact con = new Contact(FirstName = 'testbac',LastName='tes',Email='ca@gmail.com',
            Phone='8951633664',MailingStreet='testbac',MailingCity='Ongole',MailingPostalCode='523023',mailingcountry='Nepal',mailingstate='Andhra Pradesh' ,
            District_ABO__c='prakasam',Customer_Name__c='testabc');
            //insert con;
            Account a1 = new Account(Name='testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
            a1.RecordTypeId=recId1;
            //a1.Name=con.FirstName+ ' '+con.LastName;
            insert a1;
            update a1;
            PageReference pageRef = Page.ABO_User_Reg;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
            ApexPages.StandardController san = new ApexPages.StandardController(a);
            ABO_userreg usr = new ABO_userreg(san);
            usr.newcon = con;
            // usr.actUpdate();
            // usr.getURL();
            // India_userreg.validateEmail('prahanth434@gmail.com',true);
            // India_userreg.validateEmail('prahanth434@gmail.com,bhas323@gmail.com',false);
            usr.SendEmail();
            usr.OTP1='123456';
            usr.emailcheck();
            usr.getCountries();
            usr.getStates();
            usr.getDistricts();
            usr.getCities();
            usr.newCon.MailingCountry='India';
            usr.newCon.MailingState='Andhra Pradesh';
            usr.newCon.District_ABO__c='Hyderabad';
            usr.newCon.MailingCity='Secunderabad';
            usr.newCon.MailingPostalCode='523023';
            //usr.reset();
            usr.send();
            // PageReference pageRef1 = Page.ABO_User_Reg;
            // Test.setCurrentPage(pageRef1);
            List<User> u = [Select Id, ContactId FROM User Where ContactId =:usr.newCon.Id] ;
            System.assertnotequals(null, u[0].Id);
            pageRef.getParameters().put('userId',u[0].Id);
            ApexPages.StandardController sc1 = new ApexPages.StandardController(a1);
            ABO_userreg obj1=new ABO_userreg(sc1);
            obj1.OTP1='123456';
            obj1.newCon.MailingCountry='India';
            obj1.newCon.MailingState='Andhra Pradesh';
            obj1.newCon.District_ABO__c='Hyderabad';
            obj1.newCon.MailingCity='Secunderabad';
            obj1.newCon.MailingPostalCode='523002';
            obj1.SendEmail();
            obj1.OTP1='123456';
            obj1.send();
            obj1.back();
        }
        static testMethod void myUnitTest12()
        {
                User thisUser = [select Id,UserRoleId from User where Id = :UserInfo.getUserId()];
                UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
                Profile p = [select id from profile where name='EIDM_Community'];
                Id recId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                Account a = new Account(Name='testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
                a.RecordTypeId=recId1;
                insert a;
                update a;
                Contact con = new Contact(FirstName = 't',LastName='t',Email='ca@gmail.com',
                Phone='8951633664',MailingStreet='tstbac',MailingCity='Ongole',MailingPostalCode='523023',mailingcountry='Nepal',mailingstate='Andhra Pradesh' ,
                District_ABO__c='prakasam',Customer_Name__c='testabc');
                //insert con;
                Account a1 = new Account(Name='testabc',BillingStreet='abc',BillingCity='bangalore',billingcountry='India',CMI_CId__c='123456');
                a1.RecordTypeId=recId1;
                //a1.Name=con.FirstName+ ' '+con.LastName;
                insert a1;
                update a1;
                PageReference pageRef = Page.ABO_User_Reg;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('userId',thisUser.Id);
                ApexPages.StandardController san = new ApexPages.StandardController(a);
                ABO_userreg usr = new ABO_userreg(san);
                usr.newcon = con;
                // usr.actUpdate();
                // usr.getURL();
                // India_userreg.validateEmail('prahanth434@gmail.com',true);
                // India_userreg.validateEmail('prahanth434@gmail.com,bhas323@gmail.com',false);
                usr.SendEmail();
                usr.OTP1='123456';
                usr.emailcheck();
                usr.getCountries();
                usr.getStates();
                usr.getDistricts();
                usr.getCities();
                usr.newCon.MailingCountry='India';
                usr.newCon.MailingState='Andhra Pradesh';
                usr.newCon.District_ABO__c='Hyderabad';
                usr.newCon.MailingCity='Secunderabad';
                usr.newCon.MailingPostalCode='523023';
                //usr.reset();
                usr.send();
                // PageReference pageRef1 = Page.ABO_User_Reg;
                // Test.setCurrentPage(pageRef1);
                List<User> u = [Select Id, ContactId FROM User Where ContactId =:usr.newCon.Id] ;
                System.assertnotequals(null, u[0].Id);
                pageRef.getParameters().put('userId',u[0].Id);
                ApexPages.StandardController sc1 = new ApexPages.StandardController(a1);
                ABO_userreg obj1=new ABO_userreg(sc1);
                obj1.OTP1='123456';
                obj1.newCon.MailingCountry='India';
                obj1.newCon.MailingState='Andhra Pradesh';
                obj1.newCon.District_ABO__c='Hyderabad';
                obj1.newCon.MailingCity='Secunderabad';
                obj1.newCon.MailingPostalCode='523002';
                obj1.SendEmail();
                obj1.OTP1='123456';
                obj1.send();
                obj1.back();
            }
        }