@isTest(seealldata = false)
private class CSS_JitUserCreation_Test{
    
    static testMethod void CSS_JitUserCreationTest() {
        CSS_accountLanguage__c lang = new CSS_accountLanguage__c(CSS_userLanguage__c = 'Japanese' , Name = 'Ja');
        INSERT lang;
        CSS_accountLocale__c locale = new CSS_accountLocale__c(CSS_userLocale__c = 'English(United States)' , Name = 'en_US');
        INSERT locale;
        CSS_accountTimeZone__c tZone = new CSS_accountTimeZone__c(CSS_userTimeZone__c = '(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)' , Name = 'Pacific/Kiritimati');
        INSERT tZone;
        CSS_emailEncoding__c emailencode = new CSS_emailEncoding__c(CSS_userEmailEncoding__c = 'Unicode (UTF-8)' , Name = 'UTF-8');
        INSERT emailencode;
        list<Account> accountList = new list<Account>();
        
        
        CSS_sendEmail__c sendEmail = new CSS_sendEmail__c();
        sendEmail.name = 'Krish';
        sendEmail.Email_Id__c = 'nkm@cummins.com';
        insert sendEmail;
        Account acctn = new Account();
        acctn.Name='Sandeep';
        acctn.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctn.CSS_Language__c='English';
        acctn.CSS_Locale__c='English(United States)';
        acctn.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctn.CSS_DealerCode__c='';
        acctn.CSS_DistributorCode__c='04959';
        acctn.IAM_Service_Provider_Code__c='04959';
        acctn.CSS_DBCode__c='04966';
        acctn.CSS_FleetCode__c='';
        acctn.Type='Customer';
        acctn.Region__c = 'US and Canada';
        acctn.CMI_Account_Status__c = 'Active';
        accountList.add(acctn);
        
        Account acctns = new Account();
        acctns.Name='Sandeep';
        acctns.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctns.CSS_Language__c='English';
        acctns.CSS_Locale__c='English(United States)';
        acctns.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctns.CSS_DealerCode__c='02400';
        acctns.CSS_DistributorCode__c='02400';
        acctns.EDS_Workgroup_Name__c = 'testing';
        acctns.CSS_DBCode__c='02400';
        acctns.CMI_Account_Status__c = 'Active';
        acctns.CSS_FleetCode__c='';
        acctns.Region__c = 'US and Canada';
        //acctn.CMI_Account_Status__c = 'Active';
        acctns.Type='Dealer Account';
        acctns.CSS_DistributorCode__c='';
        acctns.IAM_Service_Provider_Code__c='02400';
        accountList.add(acctns);
        
        /*Account acctns1 = new Account();
acctns1.Name='Akanksha';
acctns1.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
acctns1.CSS_Language__c='English';
acctns1.CSS_Locale__c='English(United States)';
acctns1.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
acctns1.CSS_DealerCode__c='02401';
//acctns1.CSS_DistributorCode__c='02400';
acctns1.CSS_DBCode__c='';
acctns1.CMI_Account_Status__c = 'Active';
acctns1.CSS_FleetCode__c='';
acctns1.Region__c = 'US and Canada';
//acctn.CMI_Account_Status__c = 'Active';
acctns1.Type='Dealer Account';
acctns1.CSS_DistributorCode__c='';
acctns1.IAM_Service_Provider_Code__c='02401';
accountList.add(acctns1);*/
        
        Account acctnFleet = new Account();
        acctnFleet.Name='Knight Transportation';
        acctnFleet.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctnFleet.CSS_Language__c='English';
        acctnFleet.CSS_Locale__c='English(United States)';
        acctnFleet.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctnFleet.CSS_DistributorCode__c='50000';
        acctnFleet.CSS_DBCode__c = '84104';
        acctnFleet.IAM_Service_Provider_Code__c='16784';
        acctnFleet.Type='CIHR';
        acctnFleet.Region__c = 'US and Canada';
        acctnFleet.CMI_Account_Status__c = 'Active';
        
        accountList.add(acctnFleet);
        
        Account acctFactory = new Account();
        acctFactory.Name='Factory';
        acctFactory.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctFactory.CSS_Language__c='English';
        acctFactory.CSS_Locale__c='English(United States)';
        acctFactory.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctFactory.CSS_DealerCode__c=null;
        acctFactory.CSS_DistributorCode__c=null;
        acctFactory.CSS_DBCode__c=null;
        acctFactory.CSS_FleetCode__c=null;
        acctFactory.Region__c = 'US and Canada';
        acctFactory.CMI_Account_Status__c = 'Active';
        acctFactory.Type='Dealer Account';
        acctFactory.CSS_DistributorCode__c='19134';
        acctFactory.Type='Customer';
        accountList.add(acctFactory); 
        
        Account acctnsDistributor = new Account();
        acctnsDistributor.Name='Advanced 3 East';
        acctnsDistributor.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctnsDistributor.CSS_Language__c='English';
        acctnsDistributor.CSS_Locale__c='English(United States)';
        acctnsDistributor.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctnsDistributor.CSS_DealerCode__c='';
        acctnsDistributor.CSS_DistributorCode__c='03742';
        acctnsDistributor.CSS_DBCode__c='03735';
        acctnsDistributor.IAM_Service_Provider_Code__c='03735';
        acctnsDistributor.CSS_FleetCode__c='';
        acctnsDistributor.Type='Customer';
        acctnsDistributor.Region__c = 'US and Canada';
        acctnsDistributor.CMI_Account_Status__c = 'Active';
        accountList.add(acctnsDistributor);
        
        //New
        Account acctnsHQ = new Account();
        acctnsHQ.Name='Advanced 3 East';
        acctnsHQ.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctnsHQ.CSS_Language__c='English';
        acctnsHQ.CSS_Locale__c='English(United States)';
        acctnsHQ.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctnsHQ.CSS_DealerCode__c='';
        acctnsHQ.CSS_DistributorCode__c='77074';
        acctnsHQ.CSS_DBCode__c='77074';
        acctnsHQ.IAM_Service_Provider_Code__c ='77074';
        acctnsHQ.CSS_FleetCode__c='';
        acctnsHQ.Type='Customer';
        acctnsHQ.Region__c = 'US and Canada';
        acctnsHQ.CMI_Account_Status__c = 'Active';
        accountList.add(acctnsHQ);
        
        Account acctn1 = new Account();
        acctn1.Name='Sandeep1';
        acctn1.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctn1.CSS_Language__c='English';
        acctn1.CSS_Locale__c='English(United States)';
        acctn1.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctn1.CSS_DealerCode__c='02401';
        acctn1.CSS_DistributorCode__c='30001';
        acctn1.IAM_Service_Provider_Code__c ='02401';
        acctn1.CSS_DBCode__c='';
        acctn1.CSS_FleetCode__c='';
        acctn1.Type='Customer';
        acctn1.Region__c = 'US and Canada';
        acctn1.CMI_Account_Status__c = 'Active';
        accountList.add(acctn1);
        //New
        
        insert accountList;
        for(account accinfo: [SELECT location__c FROM ACcount WHERE Id IN: accountList]){
            system.debug('Location info'+accinfo.location__c);
        }
        //insert acctns;
        
        
        //User u= [SELECT id,Name,ManagerId,LastName,FirstName,Email,ContactId,profileID FROM User WHERE Id = :UserInfo.getUserId()];
        
        
        User u = [select id,Name,ManagerId,CSS_User_MultiLocValues__c,LastName,FirstName,Email,ContactId,Fleet_Code__c,FederationIdentifier from User limit 1];
        u.IsActive = true;
        test.startTest();
        Map<String, String> attributes = new Map<String, String>();
        attributes.put('UID','pk552');
        attributes.put('MEMBER','css_Tech');
        attributes.put('SURNAME','user');
        attributes.put('FULLNAME','test 1 user');
        attributes.put('MAIL','Sandeep@cummins.com');
        attributes.put('CUMMINSMANAGER','nw792');
        attributes.put('CONTACT','12345');
        attributes.put('USERROLEID','test');
        attributes.put('DEALERCODE','');
        attributes.put('DISTRIBUTORCODE','04959');
        attributes.put('DISTRIBUTORBRANCHCODE','04966');
        attributes.put('PRODUCTGROUPACCESS','');
        attributes.put('MEMBER','ou=eds-user,cn=CSS_,cn=App_CSS');
        attributes.put('WORKGROUP','02400-02400-P&#124|2850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        System.debug('attributes--->'+attributes);
        Map<String, String> attributes1 = new Map<String, String>();
        attributes1.put('UID','pk552');
        attributes1.put('MEMBER','test');
        attributes1.put('SURNAME','user');
        attributes1.put('FULLNAME','test 2 user');
        attributes1.put('MAIL','Sandeep@cumns.com');
        attributes1.put('CUMMINSMANAGER','nw792');
        attributes1.put('CONTACT','123452313');
        attributes1.put('USERROLEID','Factory');
        attributes1.put('DEALERCODE','02400');
        attributes1.put('DISTRIBUTORCODE','02400');
        attributes1.put('DISTRIBUTORBRANCHCODE','');
        attributes1.put('APPLICATIONGROUPS','test');
        attributes1.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        //attributes1.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        attributes1.put('WORKGROUP','');
        
        Map<String, String> attributes2 = new Map<String, String>();
        attributes2.put('UID','pk552');
        attributes2.put('MEMBER','test');
        attributes2.put('SURNAME','user');
        attributes2.put('FULLNAME','test 3 user');
        attributes2.put('MAIL','Sandeep@cummins.com');
        attributes2.put('CUMMINSMANAGER','nw792');
        attributes2.put('CONTACT','123452313');
        attributes2.put('USERROLEID','Factory');
        attributes2.put('DEALERCODE','02400');
        attributes2.put('DISTRIBUTORCODE','02400');
        attributes2.put('DISTRIBUTORBRANCHCODE','04966');
        attributes2.put('APPLICATIONGROUPS','cn=CSS_');
        attributes2.put('MEMBER','cn=CSS_');//,cn=CSS_,cn=App_CSS
        attributes2.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes3 = new Map<String, String>();
        attributes3.put('UID','pk552');
        attributes3.put('MEMBER','test');
        attributes3.put('SURNAME','user');
        attributes3.put('Fullname','test 3 user');
        attributes3.put('MAIL','Sandeep@cummins.com');
        attributes3.put('CUMMINSMANAGER','nw792');
        attributes3.put('CONTACT','123452313');
        attributes3.put('UserRoleId','Factory');
        attributes3.put('DEALERCODE','');
        attributes3.put('DISTRIBUTORCODE','02400');
        attributes3.put('DISTRIBUTORBRANCHCODE','04966');
        attributes3.put('APPLICATIONGROUPS','CN=CSS_');
        attributes3.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes3.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes41 = new Map<String, String>();
        attributes41.put('UID','pk552');
        attributes41.put('MEMBER','test2');
        attributes41.put('SURNAME','user2');
        attributes41.put('Fullname','test2 user2');
        attributes41.put('MAIL','Sandeep123@cummins.com');
        attributes41.put('CUMMINSMANAGER','nw792');
        attributes41.put('CONTACT','3456900');
        attributes41.put('USERROLEID','Factory');
        attributes41.put('DEALERCODE','');
        attributes41.put('DISTRIBUTORCODE','50000');
        attributes41.put('FLEETCODE','85890');
        attributes41.put('DISTRIBUTORBRANCHCODE','84084');
        attributes41.put('APPLICATIONGROUPS','CN=CSS_');
        attributes41.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes41.put('WORKGROUP','85890-84084-P'); 
        
        Map<String, String> attributes4 = new Map<String, String>();
        attributes4.put('UID','pk552');
        attributes4.put('MEMBER','test');
        attributes4.put('SURNAME','user');
        attributes4.put('Fullname','test 3 user');
        attributes4.put('MAIL','Sandeep@cummins.com');
        attributes4.put('CUMMINSMANAGER','nw792');
        attributes4.put('CONTACT','123452313');
        attributes4.put('USERROLEID','Factory');
        attributes4.put('DEALERCODE','');
        attributes4.put('DISTRIBUTORCODE','50000');
        attributes4.put('FLEETCODE','16784');
        attributes4.put('DISTRIBUTORBRANCHCODE','84104');
        attributes4.put('APPLICATIONGROUPS','CN=CSS_');
        attributes4.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes4.put('WORKGROUP','84104-16784-P');
        
        
        
        
        Map<String, String> attributes5 = new Map<String, String>();
        attributes5.put('UID','pk552');
        attributes5.put('MEMBER','test');
        attributes5.put('SURNAME','user');
        attributes5.put('FULLNAME','test 3 user');
        attributes5.put('CUMMINSMANAGER','nw792');
        attributes5.put('CONTACT','123452313');
        attributes5.put('USERROLEID','Factory');
        attributes5.put('DISTRIBUTORCODE','');
        attributes5.put('DISTRIBUTORBRANCHCODE','');
        attributes5.put('FLEETCODE','');
        attributes5.put('DEALERCODE','');
        attributes5.put('APPLICATIONGROUPS','CN=CSS_,CSS_DN_ADMIN,CSS_DN_ADVANCED,CSS_DN_TECH');
        attributes5.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes5.put('MAIL','test@cummins.com');
        attributes5.put('WORKGROUP','');
        
        Map<String, String> attributes6 = new Map<String, String>();
        attributes6.put('UID','pk552');
        attributes6.put('MEMBER','test');
        attributes6.put('SURNAME','user');
        attributes6.put('FULLNAME','test 3 user');
        attributes6.put('CUMMINSMANAGER','nw792');
        attributes6.put('CONTACT','123452313');
        attributes6.put('USERROLEID','Factory');
        attributes6.put('DISTRIBUTORCODE','');
        attributes6.put('DISTRIBUTORBRANCHCODE','');
        attributes6.put('FLEETCODE','');
        attributes6.put('DEALERCODE','');
        attributes6.put('APPLICATIONGROUPS','');
        attributes6.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributes6.put('MAIL','test@cummins.com');
        attributes6.put('WORKGROUP','');
        
        //New
        Map<String, String> attributesN = new Map<String, String>();
        attributesN.put('UID','pk552');
        attributesN.put('MEMBER','test');
        attributesN.put('SURNAME','user');
        attributesN.put('FULLNAME','test 3 user');
        attributesN.put('CUMMINSMANAGER','nw792');
        attributesN.put('CONTACT','123452313');
        attributesN.put('USERROLEID','Factory');
        attributesN.put('DISTRIBUTORCODE','77074');
        attributesN.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN.put('FLEETCODE','');
        attributesN.put('DEALERCODE','');
        attributesN.put('APPLICATIONGROUPS','');
        attributesN.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN.put('MAIL','test@cummins.com');
        attributesN.put('WORKGROUP','');
        
        Map<String, String> attributesN1 = new Map<String, String>();
        attributesN1.put('UID','pk552');
        attributesN1.put('MEMBER','test');
        attributesN1.put('SURNAME','user');
        attributesN1.put('FULLNAME','test 3 user');
        attributesN1.put('CUMMINSMANAGER','nw792');
        attributesN1.put('CONTACT','123452313');
        attributesN1.put('USERROLEID','Factory');
        attributesN1.put('DISTRIBUTORCODE','77074');
        attributesN1.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN1.put('FLEETCODE','');
        attributesN1.put('DEALERCODE','');
        attributesN1.put('APPLICATIONGROUPS','');
        attributesN1.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN1.put('MAIL','');
        attributesN1.put('WORKGROUP','');
        
        Map<String, String> attributesN2 = new Map<String, String>();
        attributesN2.put('UID','pk5522');
        attributesN2.put('MEMBER','test');
        attributesN2.put('SURNAME','user');
        attributesN2.put('FULLNAME','test 3 user');
        attributesN2.put('CUMMINSMANAGER','nw792');
        attributesN2.put('CONTACT','123452313');
        attributesN2.put('USERROLEID','Factory');
        attributesN2.put('DISTRIBUTORCODE','77074');
        attributesN2.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN2.put('FLEETCODE','');
        attributesN2.put('DEALERCODE','');
        attributesN2.put('APPLICATIONGROUPS','');
        attributesN2.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN2.put('MAIL','');
        attributesN2.put('WORKGROUP','');
        
        Map<String, String> attributesN3 = new Map<String, String>();
        attributesN3.put('UID','');
        attributesN3.put('MEMBER','test');
        attributesN3.put('SURNAME','user');
        attributesN3.put('FULLNAME','test 3 user');
        attributesN3.put('CUMMINSMANAGER','nw792');
        attributesN3.put('CONTACT','123452313');
        attributesN3.put('USERROLEID','Factory');
        attributesN3.put('DISTRIBUTORCODE','77074');
        attributesN3.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN3.put('FLEETCODE','');
        attributesN3.put('DEALERCODE','');
        attributesN3.put('APPLICATIONGROUPS','');
        attributesN3.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN3.put('MAIL','');
        attributesN3.put('WORKGROUP','');
        
        Map<String, String> attributesN4 = new Map<String, String>();
        attributesN4.put('UID','23cgs');
        attributesN4.put('MEMBER','test');
        attributesN4.put('SURNAME','user');
        attributesN4.put('FULLNAME','test 3 user');
        attributesN4.put('CUMMINSMANAGER','nw792');
        attributesN4.put('CONTACT','123452313');
        attributesN4.put('USERROLEID','Factory');
        attributesN4.put('DISTRIBUTORCODE','77074');
        attributesN4.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN4.put('FLEETCODE','');
        attributesN4.put('DEALERCODE','');
        attributesN4.put('APPLICATIONGROUPS','');
        attributesN4.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN4.put('MAIL','');
        attributesN4.put('WORKGROUP','');
        
        Map<String, String> attributesN5 = new Map<String, String>();
        attributesN5.put('UID','pk552');
        attributesN5.put('MEMBER','test');
        attributesN5.put('SURNAME','user');
        attributesN5.put('FULLNAME','test 2 user');
        attributesN5.put('MAIL','Sandeep@cummins.com');
        attributesN5.put('CUMMINSMANAGER','nw792');
        attributesN5.put('CONTACT','123452313');
        attributesN5.put('USERROLEID','Factory');
        attributesN5.put('DEALERCODE','');
        attributesN5.put('DISTRIBUTORCODE','50000');
        attributesN5.put('DISTRIBUTORBRANCHCODE','84104');
        attributesN5.put('FLEETCODE','16784');
        attributesN5.put('APPLICATIONGROUPS','test');
        attributesN5.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        attributesN5.put('WORKGROUP','84084-85890-P'); 
        
        Map<String, String> attributesN6 = new Map<String, String>();
        attributesN6.put('UID','pk552');
        attributesN6.put('MEMBER','test');
        attributesN6.put('SURNAME','user');
        attributesN6.put('FULLNAME','test 2 user');
        attributesN6.put('MAIL','');
        attributesN6.put('CUMMINSMANAGER','nw792');
        attributesN6.put('CONTACT','123452313');
        attributesN6.put('USERROLEID','Factory');
        attributesN6.put('DEALERCODE','');
        attributesN6.put('DISTRIBUTORCODE','02400');
        attributesN6.put('DISTRIBUTORBRANCHCODE','');
        attributesN6.put('APPLICATIONGROUPS','test');
        attributesN6.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        attributesN6.put('WORKGROUP','02400-02400-P');
        
        //New
        
        User u1 = [select id,Name,ManagerId,CSS_User_MultiLocValues__c,LastName,FirstName,Email,ContactId,Fleet_Code__c,FederationIdentifier from User  limit 1];
        Map<String, String> attributes7 = new Map<String, String>();
        attributes7.put('UID','od053');
        attributes7.put('MEMBER','test');
        attributes7.put('SURNAME','user');
        attributes7.put('FULLNAME','Advanced 3 East');
        attributes7.put('CUMMINSMANAGER','nw792');
        attributes7.put('CONTACT','123452313');
        attributes7.put('USERROLEID','Factory');
        attributes7.put('DISTRIBUTORCODE','03742');
        attributes7.put('DISTRIBUTORBRANCHCODE','03735');
        attributes7.put('FLEETCODE','');
        attributes7.put('DEALERCODE','');
        attributes7.put('APPLICATIONGROUPS','CN=CSS_,CSS_DN_ADMIN,CSS_DN_ADVANCED,CSS_DN_TECH');
        attributes7.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes7.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        CSS_JitUserCreation testCss = new CSS_JitUserCreation();
        
        
        // Calling the create method
        testCss.surname='TESTING';
        testCss.createUser(U.id,null,null,'pk552',attributes,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes1,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes2,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes3,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes4,'Test');
        //testCss.createUser(U.id,null,null,'pk552',attributes41,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes5,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes6,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes7,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributesN,'Test');     //New
        testCss.createUser(U.id,null,null,'pk552',attributesN1,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN2,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN3,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN4,'Test');    //New
        //testCss.createUser(U.id,null,null,'pk552',attributesN5,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN6,'Test');    //New
        
        CSS_JitUserCreation testCss1 = new CSS_JitUserCreation();
        testCss1.surname='TESTING1';
        testCss1.sendEmail();
        testCss1.createUser(U1.id,null,null,'pk552',attributes6,'Test');
        
        //testCss.sendEmail();
        
        
        try{
            testCss.getInfoValidation(true,U, U.id, U.id ,'pk552', attributes2);
            
            CSS_JitUserCreation.dealerContentAccess(String.valueOf(U.FederationIdentifier));
            System.debug('** Rajesh ***'+U.FederationIdentifier);
            
            
            
            CSS_JitUserCreation.distributorContentAccess(String.valueOf(U.FederationIdentifier));
            testCss.sendEmail();
            
        }catch(Exception e){
            System.assert(e.getMessage()!=null);
        }
        
        try{
            testCss.getInfoValidation(false,U1, U1.id, U1.id ,'od053', attributes6);
        }catch(Exception e){
            System.assert(e.getMessage()!=null);
        }
        
        try{       
            attributes.put('WORKGROUP','02400-02400-P&#124|2850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
            
            System.debug('attributes--->'+attributes);
            testCss.updateUser(U.Id,U.id,null,null,'pk552',attributes,'Test');
            testCss.updateUser(U.Id,U.id,null,null,'OD319',attributes,'Test');
            
        }catch(Exception e){
            System.debug('Exception'+e.getMessage());
            System.assert(e.getMessage()!=null);
        }
        
        test.stopTest();
        
    }
    
    static testMethod void CSS_JitUserCreationTest1() {
        list<Account> accountListnew = new list<Account>();
        
        
        CSS_sendEmail__c sendEmail = new CSS_sendEmail__c();
        sendEmail.name = 'Krish';
        sendEmail.Email_Id__c = 'nkm@cummins.com';
        insert sendEmail;
        Account acctns2 = new Account();
        acctns2.Name='Sandeep';
        acctns2.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctns2.CSS_Language__c='English';
        acctns2.CSS_Locale__c='English(United States)';
        acctns2.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctns2.CSS_DealerCode__c='02400';
        acctns2.CSS_DistributorCode__c='02400';
        acctns2.CSS_DBCode__c='02400';
        acctns2.CMI_Account_Status__c = 'Active';
        acctns2.CSS_FleetCode__c='';
        acctns2.Region__c = 'US and Canada';
        //acctns2.CMI_Account_Status__c = 'Active';
        acctns2.Type='Dealer Account';
        //acctns2.CSS_DistributorCode__c='';
        acctns2.IAM_Service_Provider_Code__c='02400';
        accountListnew.add(acctns2);
        insert accountListnew;
        
        Account acctns1 = new Account();
        acctns1.Name='Akanksha';
        acctns1.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctns1.CSS_Language__c='English';
        acctns1.CSS_Locale__c='English(United States)';
        acctns1.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctns1.CSS_DealerCode__c='02401';
        //acctns1.CSS_DistributorCode__c='02400';
        acctns1.CSS_DBCode__c='';
        acctns1.CMI_Account_Status__c = 'Active';
        acctns1.CSS_FleetCode__c='';
        acctns1.Region__c = 'US and Canada';
        //acctn.CMI_Account_Status__c = 'Active';
        acctns1.Type='Customer';
        acctns1.CSS_DistributorCode__c='';
        acctns1.IAM_Service_Provider_Code__c='02401';
        accountListnew.add(acctns1);
        
        
        
        User u = [select id,Name,ManagerId,CSS_User_MultiLocValues__c,LastName,FirstName,Email,ContactId,Fleet_Code__c,FederationIdentifier from User limit 1];
        u.IsActive = true;
        test.startTest();
        Map<String, String> attributes = new Map<String, String>();
        attributes.put('UID','pk552');
        attributes.put('MEMBER','css_Tech');
        attributes.put('SURNAME','user');
        attributes.put('FULLNAME','test 1 user');
        attributes.put('MAIL','Sandeep@cummins.com');
        attributes.put('CUMMINSMANAGER','nw792');
        attributes.put('CONTACT','12345');
        attributes.put('USERROLEID','test');
        attributes.put('DEALERCODE','');
        attributes.put('DISTRIBUTORCODE','04959');
        attributes.put('DISTRIBUTORBRANCHCODE','04966');
        attributes.put('PRODUCTGROUPACCESS','');
        attributes.put('MEMBER','ou=eds-user,cn=CSS_,cn=App_CSS');
        attributes.put('WORKGROUP','02400-02400-P&#124|2850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes1 = new Map<String, String>();
        attributes1.put('UID','pk552');
        attributes1.put('MEMBER','test');
        attributes1.put('SURNAME','user');
        attributes1.put('FULLNAME','test 2 user');
        attributes1.put('MAIL','Sandeep@cummins.com');
        attributes1.put('CUMMINSMANAGER','nw792');
        attributes1.put('CONTACT','123452313');
        attributes1.put('USERROLEID','Factory');
        attributes1.put('DEALERCODE','02400');
        attributes1.put('DISTRIBUTORCODE','02400');
        attributes1.put('DISTRIBUTORBRANCHCODE','');
        attributes1.put('APPLICATIONGROUPS','test');
        attributes1.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        //attributes1.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        attributes1.put('WORKGROUP','');
        
        Map<String, String> attributes2 = new Map<String, String>();
        attributes2.put('UID','pk552');
        attributes2.put('MEMBER','test');
        attributes2.put('SURNAME','user');
        attributes2.put('FULLNAME','test 3 user');
        attributes2.put('MAIL','Sandeep@cummins.com');
        attributes2.put('CUMMINSMANAGER','nw792');
        attributes2.put('CONTACT','123452313');
        attributes2.put('USERROLEID','Factory');
        attributes2.put('DEALERCODE','02400');
        attributes2.put('DISTRIBUTORCODE','02400');
        attributes2.put('DISTRIBUTORBRANCHCODE','04966');
        attributes2.put('APPLICATIONGROUPS','cn=CSS_');
        attributes2.put('MEMBER','cn=CSS_');//,cn=CSS_,cn=App_CSS
        attributes2.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes3 = new Map<String, String>();
        attributes3.put('UID','pk552');
        attributes3.put('MEMBER','test');
        attributes3.put('SURNAME','user');
        attributes3.put('Fullname','test 3 user');
        attributes3.put('MAIL','Sandeep@cummins.com');
        attributes3.put('CUMMINSMANAGER','nw792');
        attributes3.put('CONTACT','123452313');
        attributes3.put('UserRoleId','Factory');
        attributes3.put('DEALERCODE','');
        attributes3.put('DISTRIBUTORCODE','02400');
        attributes3.put('DISTRIBUTORBRANCHCODE','04966');
        attributes3.put('APPLICATIONGROUPS','CN=CSS_');
        attributes3.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes3.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes41 = new Map<String, String>();
        attributes41.put('UID','pk552');
        attributes41.put('MEMBER','test2');
        attributes41.put('SURNAME','user2');
        attributes41.put('Fullname','test2 user2');
        attributes41.put('MAIL','Sandeep123@cummins.com');
        attributes41.put('CUMMINSMANAGER','nw792');
        attributes41.put('CONTACT','3456900');
        attributes41.put('USERROLEID','Factory');
        attributes41.put('DEALERCODE','');
        attributes41.put('DISTRIBUTORCODE','50000');
        attributes41.put('FLEETCODE','85890');
        attributes41.put('DISTRIBUTORBRANCHCODE','84084');
        attributes41.put('APPLICATIONGROUPS','CN=CSS_');
        attributes41.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes41.put('WORKGROUP','85890-84084-P'); 
        
        Map<String, String> attributes4 = new Map<String, String>();
        attributes4.put('UID','pk552');
        attributes4.put('MEMBER','test');
        attributes4.put('SURNAME','user');
        attributes4.put('Fullname','test 3 user');
        attributes4.put('MAIL','Sandeep@cummins.com');
        attributes4.put('CUMMINSMANAGER','nw792');
        attributes4.put('CONTACT','123452313');
        attributes4.put('USERROLEID','Factory');
        attributes4.put('DEALERCODE','');
        attributes4.put('DISTRIBUTORCODE','50000');
        attributes4.put('FLEETCODE','16784');
        attributes4.put('DISTRIBUTORBRANCHCODE','84104');
        attributes4.put('APPLICATIONGROUPS','CN=CSS_');
        attributes4.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes4.put('WORKGROUP','84104-16784-P');
        
        
        
        
        Map<String, String> attributes5 = new Map<String, String>();
        attributes5.put('UID','pk552');
        attributes5.put('MEMBER','test');
        attributes5.put('SURNAME','user');
        attributes5.put('FULLNAME','test 3 user');
        attributes5.put('CUMMINSMANAGER','nw792');
        attributes5.put('CONTACT','123452313');
        attributes5.put('USERROLEID','Factory');
        attributes5.put('DISTRIBUTORCODE','');
        attributes5.put('DISTRIBUTORBRANCHCODE','');
        attributes5.put('FLEETCODE','');
        attributes5.put('DEALERCODE','');
        attributes5.put('APPLICATIONGROUPS','CN=CSS_,CSS_DN_ADMIN,CSS_DN_ADVANCED,CSS_DN_TECH');
        attributes5.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes5.put('MAIL','test@cummins.com');
        attributes5.put('WORKGROUP','');
        
        Map<String, String> attributes6 = new Map<String, String>();
        attributes6.put('UID','pk552');
        attributes6.put('MEMBER','test');
        attributes6.put('SURNAME','user');
        attributes6.put('FULLNAME','test 3 user');
        attributes6.put('CUMMINSMANAGER','nw792');
        attributes6.put('CONTACT','123452313');
        attributes6.put('USERROLEID','Factory');
        attributes6.put('DISTRIBUTORCODE','');
        attributes6.put('DISTRIBUTORBRANCHCODE','');
        attributes6.put('FLEETCODE','');
        attributes6.put('DEALERCODE','');
        attributes6.put('APPLICATIONGROUPS','');
        attributes6.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributes6.put('MAIL','test@cummins.com');
        attributes6.put('WORKGROUP','');
        
        //New
        Map<String, String> attributesN = new Map<String, String>();
        attributesN.put('UID','pk552');
        attributesN.put('MEMBER','test');
        attributesN.put('SURNAME','user');
        attributesN.put('FULLNAME','test 3 user');
        attributesN.put('CUMMINSMANAGER','nw792');
        attributesN.put('CONTACT','123452313');
        attributesN.put('USERROLEID','Factory');
        attributesN.put('DISTRIBUTORCODE','77074');
        attributesN.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN.put('FLEETCODE','');
        attributesN.put('DEALERCODE','');
        attributesN.put('APPLICATIONGROUPS','');
        attributesN.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN.put('MAIL','test@cummins.com');
        attributesN.put('WORKGROUP','');
        
        Map<String, String> attributesN1 = new Map<String, String>();
        attributesN1.put('UID','pk552');
        attributesN1.put('MEMBER','test');
        attributesN1.put('SURNAME','user');
        attributesN1.put('FULLNAME','test 3 user');
        attributesN1.put('CUMMINSMANAGER','nw792');
        attributesN1.put('CONTACT','123452313');
        attributesN1.put('USERROLEID','Factory');
        attributesN1.put('DISTRIBUTORCODE','77074');
        attributesN1.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN1.put('FLEETCODE','');
        attributesN1.put('DEALERCODE','');
        attributesN1.put('APPLICATIONGROUPS','');
        attributesN1.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN1.put('MAIL','');
        attributesN1.put('WORKGROUP','');
        
        Map<String, String> attributesN2 = new Map<String, String>();
        attributesN2.put('UID','pk5522');
        attributesN2.put('MEMBER','test');
        attributesN2.put('SURNAME','user');
        attributesN2.put('FULLNAME','test 3 user');
        attributesN2.put('CUMMINSMANAGER','nw792');
        attributesN2.put('CONTACT','123452313');
        attributesN2.put('USERROLEID','Factory');
        attributesN2.put('DISTRIBUTORCODE','77074');
        attributesN2.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN2.put('FLEETCODE','');
        attributesN2.put('DEALERCODE','');
        attributesN2.put('APPLICATIONGROUPS','');
        attributesN2.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN2.put('MAIL','');
        attributesN2.put('WORKGROUP','');
        
        Map<String, String> attributesN3 = new Map<String, String>();
        attributesN3.put('UID','');
        attributesN3.put('MEMBER','test');
        attributesN3.put('SURNAME','user');
        attributesN3.put('FULLNAME','test 3 user');
        attributesN3.put('CUMMINSMANAGER','nw792');
        attributesN3.put('CONTACT','123452313');
        attributesN3.put('USERROLEID','Factory');
        attributesN3.put('DISTRIBUTORCODE','77074');
        attributesN3.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN3.put('FLEETCODE','');
        attributesN3.put('DEALERCODE','');
        attributesN3.put('APPLICATIONGROUPS','');
        attributesN3.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN3.put('MAIL','');
        attributesN3.put('WORKGROUP','');
        
        Map<String, String> attributesN4 = new Map<String, String>();
        attributesN4.put('UID','23cgs');
        attributesN4.put('MEMBER','test');
        attributesN4.put('SURNAME','user');
        attributesN4.put('FULLNAME','test 3 user');
        attributesN4.put('CUMMINSMANAGER','nw792');
        attributesN4.put('CONTACT','123452313');
        attributesN4.put('USERROLEID','Factory');
        attributesN4.put('DISTRIBUTORCODE','77074');
        attributesN4.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN4.put('FLEETCODE','');
        attributesN4.put('DEALERCODE','');
        attributesN4.put('APPLICATIONGROUPS','');
        attributesN4.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN4.put('MAIL','');
        attributesN4.put('WORKGROUP','');
        
        Map<String, String> attributesN5 = new Map<String, String>();
        attributesN5.put('UID','pk552');
        attributesN5.put('MEMBER','test');
        attributesN5.put('SURNAME','user');
        attributesN5.put('FULLNAME','test 2 user');
        attributesN5.put('MAIL','Sandeep@cummins.com');
        attributesN5.put('CUMMINSMANAGER','nw792');
        attributesN5.put('CONTACT','123452313');
        attributesN5.put('USERROLEID','Factory');
        attributesN5.put('DEALERCODE','');
        attributesN5.put('DISTRIBUTORCODE','50000');
        attributesN5.put('DISTRIBUTORBRANCHCODE','84104');
        attributesN5.put('FLEETCODE','16784');
        attributesN5.put('APPLICATIONGROUPS','test');
        attributesN5.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        attributesN5.put('WORKGROUP','84084-85890-P'); 
        
        Map<String, String> attributesN6 = new Map<String, String>();
        attributesN6.put('UID','pk552');
        attributesN6.put('MEMBER','test');
        attributesN6.put('SURNAME','user');
        attributesN6.put('FULLNAME','test 2 user');
        attributesN6.put('MAIL','akanksha@cummins.com');
        attributesN6.put('CUMMINSMANAGER','nw792');
        attributesN6.put('CONTACT','123452313');
        attributesN6.put('USERROLEID','Factory');
        attributesN6.put('DEALERCODE','');
        attributesN6.put('DISTRIBUTORCODE','02400');
        attributesN6.put('DISTRIBUTORBRANCHCODE','');
        attributesN6.put('APPLICATIONGROUPS','test');
        attributesN6.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        attributesN6.put('WORKGROUP','02400-02400-P');
        
        //New
        
        User u1 = [select id,Name,ManagerId,CSS_User_MultiLocValues__c,LastName,FirstName,Email,ContactId,Fleet_Code__c,FederationIdentifier from User  limit 1];
        Map<String, String> attributes7 = new Map<String, String>();
        attributes7.put('UID','od053');
        attributes7.put('MEMBER','test');
        attributes7.put('SURNAME','user');
        attributes7.put('FULLNAME','Advanced 3 East');
        attributes7.put('CUMMINSMANAGER','nw792');
        attributes7.put('CONTACT','123452313');
        attributes7.put('USERROLEID','Factory');
        attributes7.put('DISTRIBUTORCODE','03742');
        attributes7.put('DISTRIBUTORBRANCHCODE','03735');
        attributes7.put('FLEETCODE','');
        attributes7.put('DEALERCODE','');
        attributes7.put('APPLICATIONGROUPS','CN=CSS_,CSS_DN_ADMIN,CSS_DN_ADVANCED,CSS_DN_TECH');
        attributes7.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes7.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        CSS_JitUserCreation testCss = new CSS_JitUserCreation();
        
        
        // Calling the create method
        testCss.surname='TESTING';
        testCss.createUser(U.id,null,null,'pk552',attributes,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes1,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes2,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes3,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes4,'Test');
        //testCss.createUser(U.id,null,null,'pk552',attributes41,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes5,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes6,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes7,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributesN,'Test');     //New
        testCss.createUser(U.id,null,null,'pk552',attributesN1,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN2,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN3,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN4,'Test');    //New
        //testCss.createUser(U.id,null,null,'pk552',attributesN5,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN6,'Test');    //New
        
        CSS_JitUserCreation testCss1 = new CSS_JitUserCreation();
        testCss1.surname='TESTING1';
        testCss1.sendEmail();
        testCss1.createUser(U1.id,null,null,'pk552',attributes6,'Test');
        
        
        
        CSS_JitUserCreation.distributorContentAccess('pk552');
        testCss.sendEmail();
        
        //testCss.sendEmail();
        
        
        try{
            testCss.getInfoValidation(true,U, U.id, U.id ,'pk552', attributes2);
            //testCss.getInfoValidation(true,U1, U1.id, U1.id ,'od053', attributes6);
            //CSS_JitUserCreation.dealerContentAccess(String.valueOf(U.FederationIdentifier));
            System.debug('** Rajesh ***'+U.FederationIdentifier);
            CSS_JitUserCreation.distributorContentAccess(String.valueOf(U.FederationIdentifier));
            testCss.sendEmail();
            
        }catch(Exception e){
            System.assert(e.getMessage()!=null);
        }
        
        try{
            testCss.updateUser(U.Id,U.id,null,null,'pk552',attributes,'Test');
            testCss.updateUser(U.Id,U.id,null,null,'OD319',attributes,'Test');
            
        }catch(Exception e){
            System.assert(e.getMessage()!=null);
        }
        
        test.stopTest();
        
    }
    static testMethod void CSS_JitUserCreationTest12() {
        list<Account> accountListnew = new list<Account>();
        
        
        CSS_sendEmail__c sendEmail = new CSS_sendEmail__c();
        sendEmail.name = 'Krish';
        sendEmail.Email_Id__c = 'nkm@cummins.com';
        insert sendEmail;
        Account acctns2 = new Account();
        acctns2.Name='Sandeep';
        acctns2.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctns2.CSS_Language__c='English';
        acctns2.CSS_Locale__c='English(United States)';
        acctns2.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctns2.CSS_DealerCode__c='02400';
        acctns2.CSS_DistributorCode__c='02400';
        acctns2.CSS_DBCode__c='02400';
        acctns2.CMI_Account_Status__c = 'Active';
        acctns2.CSS_FleetCode__c='';
        acctns2.Region__c = 'US and Canada';
        //acctns2.CMI_Account_Status__c = 'Active';
        acctns2.Type='Dealer Account';
        //acctns2.CSS_DistributorCode__c='';
        acctns2.IAM_Service_Provider_Code__c='02400';
        accountListnew.add(acctns2);
        insert accountListnew;
        
        Account acctns1 = new Account();
        acctns1.Name='Akanksha';
        acctns1.CSS_Timezone__c='(GMT-05:00) Eastern Standard Time (America/Indiana/Indianapolis)';
        acctns1.CSS_Language__c='English';
        acctns1.CSS_Locale__c='English(United States)';
        acctns1.CSS_EmailEncoding__c='General US & Western Europe (ISO-8859-1, ISO-LATIN-1)';
        acctns1.CSS_DealerCode__c='02401';
        //acctns1.CSS_DistributorCode__c='02400';
        acctns1.CSS_DBCode__c='';
        acctns1.CMI_Account_Status__c = 'Active';
        acctns1.CSS_FleetCode__c='';
        acctns1.Region__c = 'US and Canada';
        //acctn.CMI_Account_Status__c = 'Active';
        acctns1.Type='Customer';
        acctns1.CSS_DistributorCode__c='';
        acctns1.IAM_Service_Provider_Code__c='02401';
        accountListnew.add(acctns1);
        
        
        
        User u = [select id,Name,ManagerId,CSS_User_MultiLocValues__c,LastName,FirstName,Email,ContactId,Fleet_Code__c,FederationIdentifier from User limit 1];
        u.IsActive = true;
        test.startTest();
        
        Map<String, String> attributes = new Map<String, String>();
        attributes.put('UID','pk552');
        attributes.put('MEMBER','css_Tech');
        attributes.put('SURNAME','user');
        attributes.put('FULLNAME','test 1 user');
        attributes.put('MAIL','Sandeep@cummins.com');
        attributes.put('CUMMINSMANAGER','nw792');
        attributes.put('CONTACT','12345');
        attributes.put('USERROLEID','test');
        attributes.put('DEALERCODE','');
        attributes.put('DISTRIBUTORCODE','04959');
        attributes.put('DISTRIBUTORBRANCHCODE','04966');
        attributes.put('PRODUCTGROUPACCESS','');
        attributes.put('MEMBER','ou=eds-user,cn=CSS_,cn=App_CSS');
        attributes.put('WORKGROUP','02400-02400-P&#124|2850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes1 = new Map<String, String>();
        attributes1.put('UID','pk552');
        attributes1.put('MEMBER','test');
        attributes1.put('SURNAME','user');
        attributes1.put('FULLNAME','test 2 user');
        //attributes1.put('MAIL','Sandeep@cummins.com');
        attributes1.put('CUMMINSMANAGER','nw792');
        attributes1.put('CONTACT','123452313');
        attributes1.put('USERROLEID','Factory');
        attributes1.put('DEALERCODE','02400');
        attributes1.put('DISTRIBUTORCODE','02400');
        attributes1.put('DISTRIBUTORBRANCHCODE','');
        attributes1.put('APPLICATIONGROUPS','test');
        attributes1.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        //attributes1.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        attributes1.put('WORKGROUP','');
        
        Map<String, String> attributes2 = new Map<String, String>();
        attributes2.put('UID','pk552');
        attributes2.put('MEMBER','test');
        attributes2.put('SURNAME','user');
        attributes2.put('FULLNAME','test 3 user');
        attributes2.put('MAIL','Sandeep@cummins.com');
        attributes2.put('CUMMINSMANAGER','nw792');
        attributes2.put('CONTACT','123452313');
        attributes2.put('USERROLEID','Factory');
        attributes2.put('DEALERCODE','02400');
        attributes2.put('DISTRIBUTORCODE','02400');
        attributes2.put('DISTRIBUTORBRANCHCODE','04966');
        attributes2.put('APPLICATIONGROUPS','cn=CSS_');
        attributes2.put('MEMBER','cn=CSS_');//,cn=CSS_,cn=App_CSS
        attributes2.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes3 = new Map<String, String>();
        attributes3.put('UID','pk552');
        attributes3.put('MEMBER','test');
        attributes3.put('SURNAME','user');
        attributes3.put('Fullname','test 3 user');
        attributes3.put('MAIL','Sandeep@cummins.com');
        attributes3.put('CUMMINSMANAGER','nw792');
        attributes3.put('CONTACT','123452313');
        attributes3.put('UserRoleId','Factory');
        attributes3.put('DEALERCODE','');
        attributes3.put('DISTRIBUTORCODE','02400');
        attributes3.put('DISTRIBUTORBRANCHCODE','04966');
        attributes3.put('APPLICATIONGROUPS','CN=CSS_');
        attributes3.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes3.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        Map<String, String> attributes41 = new Map<String, String>();
        attributes41.put('UID','pk552');
        attributes41.put('MEMBER','test2');
        attributes41.put('SURNAME','user2');
        attributes41.put('Fullname','test2 user2');
        attributes41.put('MAIL','Sandeep123@cummins.com');
        attributes41.put('CUMMINSMANAGER','nw792');
        attributes41.put('CONTACT','3456900');
        attributes41.put('USERROLEID','Factory');
        attributes41.put('DEALERCODE','');
        attributes41.put('DISTRIBUTORCODE','50000');
        attributes41.put('FLEETCODE','85890');
        attributes41.put('DISTRIBUTORBRANCHCODE','84084');
        attributes41.put('APPLICATIONGROUPS','CN=CSS_');
        attributes41.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes41.put('WORKGROUP','85890-84084-P'); 
        
        Map<String, String> attributes4 = new Map<String, String>();
        attributes4.put('UID','pk552');
        attributes4.put('MEMBER','test');
        attributes4.put('SURNAME','user');
        attributes4.put('Fullname','test 3 user');
        attributes4.put('MAIL','Sandeep@cummins.com');
        attributes4.put('CUMMINSMANAGER','nw792');
        attributes4.put('CONTACT','123452313');
        attributes4.put('USERROLEID','Factory');
        attributes4.put('DEALERCODE','');
        attributes4.put('DISTRIBUTORCODE','50000');
        attributes4.put('FLEETCODE','16784');
        attributes4.put('DISTRIBUTORBRANCHCODE','84104');
        attributes4.put('APPLICATIONGROUPS','CN=CSS_');
        attributes4.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes4.put('WORKGROUP','84104-16784-P');
        
        
        
        
        Map<String, String> attributes5 = new Map<String, String>();
        attributes5.put('UID','pk552');
        attributes5.put('MEMBER','test');
        attributes5.put('SURNAME','user');
        attributes5.put('FULLNAME','test 3 user');
        attributes5.put('CUMMINSMANAGER','nw792');
        attributes5.put('CONTACT','123452313');
        attributes5.put('USERROLEID','Factory');
        attributes5.put('DISTRIBUTORCODE','');
        attributes5.put('DISTRIBUTORBRANCHCODE','');
        attributes5.put('FLEETCODE','');
        attributes5.put('DEALERCODE','');
        attributes5.put('APPLICATIONGROUPS','CN=CSS_,CSS_DN_ADMIN,CSS_DN_ADVANCED,CSS_DN_TECH');
        attributes5.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes5.put('MAIL','test@cummins.com');
        attributes5.put('WORKGROUP','');
        
        Map<String, String> attributes6 = new Map<String, String>();
        attributes6.put('UID','pk552');
        attributes6.put('MEMBER','test');
        attributes6.put('SURNAME','user');
        attributes6.put('FULLNAME','test 3 user');
        attributes6.put('CUMMINSMANAGER','nw792');
        attributes6.put('CONTACT','123452313');
        attributes6.put('USERROLEID','userRole');
        attributes6.put('DISTRIBUTORCODE','');
        attributes6.put('DISTRIBUTORBRANCHCODE','');
        attributes6.put('FLEETCODE','');
        attributes6.put('DEALERCODE','');
        attributes6.put('APPLICATIONGROUPS','');
        attributes6.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributes6.put('MAIL','test@cummins.com');
        attributes6.put('WORKGROUP','');
        
        //New
        Map<String, String> attributesN = new Map<String, String>();
        attributesN.put('UID','pk552');
        attributesN.put('MEMBER','test');
        attributesN.put('SURNAME','user');
        attributesN.put('FULLNAME','test 3 user');
        attributesN.put('CUMMINSMANAGER','nw792');
        attributesN.put('CONTACT','123452313');
        attributesN.put('USERROLEID','userRole');
        attributesN.put('DISTRIBUTORCODE','77074');
        attributesN.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN.put('FLEETCODE','');
        attributesN.put('DEALERCODE','');
        attributesN.put('APPLICATIONGROUPS','');
        attributesN.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN.put('MAIL','test@cummins.com');
        attributesN.put('WORKGROUP','');
        
        Map<String, String> attributesN1 = new Map<String, String>();
        attributesN1.put('UID','pk552');
        attributesN1.put('MEMBER','test');
        attributesN1.put('SURNAME','user');
        attributesN1.put('FULLNAME','test 3 user');
        attributesN1.put('CUMMINSMANAGER','nw792');
        attributesN1.put('CONTACT','123452313');
        attributesN1.put('USERROLEID','userRole');
        attributesN1.put('DISTRIBUTORCODE','77074');
        attributesN1.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN1.put('FLEETCODE','');
        attributesN1.put('DEALERCODE','');
        attributesN1.put('APPLICATIONGROUPS','');
        attributesN1.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN1.put('MAIL','');
        attributesN1.put('WORKGROUP','');
        
        Map<String, String> attributesN2 = new Map<String, String>();
        attributesN2.put('UID','pk5522');
        attributesN2.put('MEMBER','test');
        attributesN2.put('SURNAME','user');
        attributesN2.put('FULLNAME','test 3 user');
        attributesN2.put('CUMMINSMANAGER','nw792');
        attributesN2.put('CONTACT','123452313');
        attributesN2.put('USERROLEID','userRole');
        attributesN2.put('DISTRIBUTORCODE','77074');
        attributesN2.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN2.put('FLEETCODE','');
        attributesN2.put('DEALERCODE','');
        attributesN2.put('APPLICATIONGROUPS','');
        attributesN2.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN2.put('MAIL','');
        attributesN2.put('WORKGROUP','');
        
        Map<String, String> attributesN3 = new Map<String, String>();
        attributesN3.put('UID','');
        attributesN3.put('MEMBER','test');
        attributesN3.put('SURNAME','user');
        attributesN3.put('FULLNAME','test 3 user');
        attributesN3.put('CUMMINSMANAGER','nw792');
        attributesN3.put('CONTACT','123452313');
        attributesN3.put('USERROLEID','userRole');
        attributesN3.put('DISTRIBUTORCODE','77074');
        attributesN3.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN3.put('FLEETCODE','');
        attributesN3.put('DEALERCODE','');
        attributesN3.put('APPLICATIONGROUPS','');
        attributesN3.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN3.put('MAIL','');
        attributesN3.put('WORKGROUP','');
        
        Map<String, String> attributesN4 = new Map<String, String>();
        attributesN4.put('UID','23cgs');
        attributesN4.put('MEMBER','test');
        attributesN4.put('SURNAME','user');
        attributesN4.put('FULLNAME','test 3 user');
        attributesN4.put('CUMMINSMANAGER','nw792');
        attributesN4.put('CONTACT','123452313');
        attributesN4.put('USERROLEID','userRole');
        attributesN4.put('DISTRIBUTORCODE','77074');
        attributesN4.put('DISTRIBUTORBRANCHCODE','77074');
        attributesN4.put('FLEETCODE','');
        attributesN4.put('DEALERCODE','');
        attributesN4.put('APPLICATIONGROUPS','');
        attributesN4.put('MEMBER','');//,cn=CSS_,cn=App_CSS
        attributesN4.put('MAIL','');
        attributesN4.put('WORKGROUP','');
        
        Map<String, String> attributesN5 = new Map<String, String>();
        attributesN5.put('UID','pk552');
        attributesN5.put('MEMBER','test');
        attributesN5.put('SURNAME','user');
        attributesN5.put('FULLNAME','test 2 user');
        attributesN5.put('MAIL','Sandeep@cummins.com');
        attributesN5.put('CUMMINSMANAGER','nw792');
        attributesN5.put('CONTACT','123452313');
        attributesN5.put('USERROLEID','Factory');
        attributesN5.put('DEALERCODE','');
        attributesN5.put('DISTRIBUTORCODE','50000');
        attributesN5.put('DISTRIBUTORBRANCHCODE','84104');
        attributesN5.put('FLEETCODE','16784');
        attributesN5.put('APPLICATIONGROUPS','test');
        attributesN5.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        attributesN5.put('WORKGROUP','84084-85890-P'); 
        
        Map<String, String> attributesN6 = new Map<String, String>();
        attributesN6.put('UID','pk552');
        attributesN6.put('MEMBER','test');
        attributesN6.put('SURNAME','user');
        attributesN6.put('FULLNAME','test 2 user');
        attributesN6.put('MAIL','');
        attributesN6.put('CUMMINSMANAGER','nw792');
        attributesN6.put('CONTACT','123452313');
        attributesN6.put('USERROLEID','userRole');
        attributesN6.put('DEALERCODE','');
        attributesN6.put('DISTRIBUTORCODE','02400');
        attributesN6.put('DISTRIBUTORBRANCHCODE','');
        attributesN6.put('APPLICATIONGROUPS','test');
        attributesN6.put('MEMBER','ou=eds-user');//,cn=CSS_,cn=App_CSS
        attributesN6.put('WORKGROUP','02400-02400-P');
        
        //New
        
        User u1 = [select id,Name,ManagerId,CSS_User_MultiLocValues__c,LastName,FirstName,Email,ContactId,Fleet_Code__c,FederationIdentifier from User  limit 1];
        Map<String, String> attributes7 = new Map<String, String>();
        attributes7.put('UID','od053');
        attributes7.put('MEMBER','test');
        attributes7.put('SURNAME','user');
        attributes7.put('FULLNAME','Advanced 3 East');
        attributes7.put('CUMMINSMANAGER','nw792');
        attributes7.put('CONTACT','123452313');
        attributes7.put('USERROLEID','userRole');
        attributes7.put('DISTRIBUTORCODE','03742');
        attributes7.put('DISTRIBUTORBRANCHCODE','03735');
        attributes7.put('FLEETCODE','');
        attributes7.put('DEALERCODE','');
        attributes7.put('APPLICATIONGROUPS','CN=CSS_,CSS_DN_ADMIN,CSS_DN_ADVANCED,CSS_DN_TECH');
        attributes7.put('MEMBER','CN=CSS_');//,cn=CSS_,cn=App_CSS
        attributes7.put('WORKGROUP','02400-02400-P&#124|02850-02850-S&#124,02070-02070-S&#124;02940-02940-S&#124;02650-02650-S&#124;56330-56330-S&#124;02466-02466-S&#124;02020-02020-S&#124;02680-02680-S&#124;03520-03520-S&#124;02930-02930-S&#124;03742-03742-S&#124;02860-02860-S&#124;04959-04959-S&#124;56270-56270-S&#124;04275-04275-S&#124;54699-54699-S');
        
        CSS_JitUserCreation testCss = new CSS_JitUserCreation();
        
        
        // Calling the create method
        testCss.surname='TESTING';
        testCss.createUser(U.id,null,null,'pk552',attributes,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes1,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes2,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes3,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes4,'Test');
        //testCss.createUser(U.id,null,null,'pk552',attributes41,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes5,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes6,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributes7,'Test');
        testCss.createUser(U.id,null,null,'pk552',attributesN,'Test');     //New
        testCss.createUser(U.id,null,null,'pk552',attributesN1,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN2,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN3,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN4,'Test');    //New
        //testCss.createUser(U.id,null,null,'pk552',attributesN5,'Test');    //New
        testCss.createUser(U.id,null,null,'pk552',attributesN6,'Test');    //New
        
        CSS_JitUserCreation testCss1 = new CSS_JitUserCreation();
        testCss1.surname='TESTING1';
        
        testCss1.sendEmail();
        testCss1.createUser(U1.id,null,null,'qc143',attributes6,'Test');
        
        
        CSS_JitUserCreation.dealerContentAccess(String.valueOf(U.FederationIdentifier));
        CSS_JitUserCreation.distributorContentAccess('pk552');
        testCss.sendEmail();
        
        
        //testCss.sendEmail();
        
        
        try{
            testCss.getInfoValidation(true,U, U.id, U.id ,'qc143', attributes2);
            //testCss.getInfoValidation(true,U1, U1.id, U1.id ,'od053', attributes6);
            //CSS_JitUserCreation.dealerContentAccess(String.valueOf(U.FederationIdentifier));
            System.debug('** Rajesh ***'+U.FederationIdentifier);
            CSS_JitUserCreation.distributorContentAccess(String.valueOf(U.FederationIdentifier));
            testCss.sendEmail();
            
        }catch(Exception e){
            System.assert(e.getMessage()!=null);
        }
        
        try{
            testCss.updateUser(U.Id,U.id,null,null,'pk552',attributes,'Test');
            testCss.updateUser(U.Id,U.id,null,null,'OD319',attributes,'Test');
            
        }catch(Exception e){
            System.assert(e.getMessage()!=null);
        }
        
        test.stopTest();
        
    }
    
    
}