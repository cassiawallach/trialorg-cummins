@isTest
public class OSM_SW_SalesRepCancelQuoteCtrl_Test
{
    Static TestMethod Void method1()
    {
        ccrz__E_RequestForQuote__c cc=new ccrz__E_RequestForQuote__c();
        cc.status__c='In Progress';
        cc.Discounted_Price__c=17;
        //cc.Discounted_Percentage__c=1;
        insert cc;
        Test.startTest();
        PageReference pageRef = Page.OSM_SW_SalesRepCancelQuotePg;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(cc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(cc);
        OSM_SW_SalesRepCancelQuoteCtrl testAccPlan = new OSM_SW_SalesRepCancelQuoteCtrl(sc);
        testAccPlan.newrequest=cc;
        testAccPlan.cancelAction();
        testAccPlan.backAction();
        Test.stopTest();   
    }
    Static TestMethod Void method2()
    {
        ccrz__E_RequestForQuote__c cc=new ccrz__E_RequestForQuote__c();
        insert cc;
        Test.startTest();
        PageReference pageRef = Page.OSM_SW_SalesRepCancelQuotePg;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('Id', String.valueOf(cc.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(cc);
        OSM_SW_SalesRepCancelQuoteCtrl testAccPlan = new OSM_SW_SalesRepCancelQuoteCtrl(sc);
        testAccPlan.newrequest=cc;
        testAccPlan.cancelAction();
        testAccPlan.backAction();
        Test.stopTest();   
    }
    
}