//Test Class for the class OSMCustomerLookupPopup
//updated on 25th May 

@isTest(seealldata=false)
public class OSMCustomerLookupPopup_Test {
    static testMethod void doTest(){
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        OSMCustomerLookupPopup testAccPlan = new OSMCustomerLookupPopup(sc);
        PageReference pageRef = Page.OSMCustomerLookup;
        pageRef.getParameters().put('id', String.valueOf(a.Id));
        Test.setCurrentPage(pageRef);
        testAccPlan.selectedaccname='test';
        testAccPlan.SearchaccountBMS();
        testAccPlan.closePopup();
        testAccPlan.updateBMSNo();
        testAccPlan.selectedaccname='';
        testAccPlan.account.BMS_Customer_ID_Junction__c='38820';
        testAccPlan.SearchaccountBMS();
        testAccPlan.account.BMS_Customer_ID_Junction__c='';
        testAccPlan.SearchaccountBMS();
        testAccPlan.UnlinkBMSNumber();
        testAccPlan.getSelected();
        testAccPlan.getdistributorcodes();
        
        Test.stopTest();
        
    }

static testMethod void doTest2(){
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        OSMCustomerLookupPopup testAccPlan = new OSMCustomerLookupPopup(sc);
        PageReference pageRef = Page.OSMCustomerLookup;
        pageRef.getParameters().put('id', String.valueOf(a.Id));
        Test.setCurrentPage(pageRef);
        testAccPlan.selectedaccname='test';
        testAccPlan.selectedDisCode='123';
        testAccPlan.SearchaccountBMS();
        testAccPlan.closePopup();
        testAccPlan.updateBMSNo();
        testAccPlan.selectedaccname='';
        testAccPlan.account.BMS_Customer_ID_Junction__c='38820';
        testAccPlan.SearchaccountBMS();
        testAccPlan.account.BMS_Customer_ID_Junction__c='';
        testAccPlan.SearchaccountBMS();
        testAccPlan.UnlinkBMSNumber();
        testAccPlan.getSelected();
        testAccPlan.getdistributorcodes();
        
        Test.stopTest();
        
    }
    static testMethod void doTest3(){
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        OSMCustomerLookupPopup testAccPlan = new OSMCustomerLookupPopup(sc);
        PageReference pageRef = Page.OSMCustomerLookup;
        pageRef.getParameters().put('id', String.valueOf(a.Id));
        Test.setCurrentPage(pageRef);
        testAccPlan.selectedaccname='';
        testAccPlan.selectedDisCode='';
        testAccPlan.SearchaccountBMS();
        testAccPlan.closePopup();
        testAccPlan.updateBMSNo();
        testAccPlan.selectedaccname='';
        testAccPlan.account.BMS_Customer_ID_Junction__c='38820';
        testAccPlan.SearchaccountBMS();
        testAccPlan.account.BMS_Customer_ID_Junction__c='';
        testAccPlan.SearchaccountBMS();
        testAccPlan.UnlinkBMSNumber();
        testAccPlan.getSelected();
        testAccPlan.getdistributorcodes();
        
        Test.stopTest();
        
    }

}