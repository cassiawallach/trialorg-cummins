@isTest
private class CMI_Invitepage_Test{

    static testMethod void myUnitCMIInvTest() 
    {
    
        Account acc=new Account();
        acc.CMI_Cummins_Support_Email__c='Test@test.com,Test1@test.com,Test2@test.com';
        acc.name='Test';
        insert acc;
          
        Contact contactObj= new Contact();
        contactObj.FirstName='Test';
        contactObj.LastName='Test';
        contactObj.AccountId=acc.id;
		contactObj.CMI_Contact_Type__c='Primary';

        contactObj.Email='Test@test.com';
        //contactObj.name='Test';      
        insert contactObj;
        System.currentPageReference().getParameters().put('aid', acc.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        CMI_Invitepage obj= new CMI_Invitepage(sc);
        PageReference pageRef = Page.CMI_CompanyReg;
        pageRef.getParameters().put('id', '001234567890123');
        Test.setCurrentPage(pageRef);
        obj.sEmailAddresses='test@gmail.com,test2@gmail.com';
        obj.sendemail();
        //obj.click();
        //obj.getURL();
        obj.reset();
        
        
        obj.userid = acc.id;
        obj.accid = acc.id;
        
        

    }
}