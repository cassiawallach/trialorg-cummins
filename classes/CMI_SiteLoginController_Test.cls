@isTest
private class CMI_SiteLoginController_Test{

    static testMethod void TestCMISLoginController()
    {
    
    Account a=new account();
    a.name='test';    
    insert a;
   
    contact c=new contact();
    c.firstname='fn';
    c.lastname='ln';
    c.accountid=a.id;
    c.Username__c= 'test@gmail.com';
    insert c;
    
    Id p = [select id from profile where name='CS_Community_User'].id;
    User user = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                ContactId = c.Id,
                timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
     insert user;
    CMI_SiteLoginController cmiSiteLoginObj = new CMI_SiteLoginController();
    cmiSiteLoginObj.username = 'test@gmail.com';
    cmiSiteLoginObj.forwardToCustomAuthPage();
    System.currentPageReference().getParameters().put('startUrl', 'https://www.google.com');
    cmiSiteLoginObj.login();
    }
    }