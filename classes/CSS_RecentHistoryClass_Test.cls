@isTest
public class CSS_RecentHistoryClass_Test {
    static testmethod void test(){
    Test.startTest();
       CSS_RecentHistoryClass r = new CSS_RecentHistoryClass();
        r.ServiceHistList = 'List';
        string strESNTest = '79464646';
        datetime datetimetest = System.now().addDays(31);
        system.debug('DATETIME*****'+datetimetest);
        CSS_RecentHistoryClass.strESN = strESNTest;
        CSS_RecentHistoryClass.strhESN = strESNTest;
        CSS_RecentHistoryClass.dtCreated = datetimetest;
                CSS_RecentHistoryClass.dthCreated = datetimetest;
        //r.strESN = '79464646';
        //r.strhESN = '79464646';
        CSS_RecentHistoryClass.ServiceHistWrap Wrap = new CSS_RecentHistoryClass.ServiceHistWrap();
        Wrap.brepeatFlg = false;
        CSS_RecentHistoryClass.ServiceHistWrap2 Wrap2 = new CSS_RecentHistoryClass.ServiceHistWrap2();
        Wrap2.brepeatFlg2 = false;
        List < CSS_Job_Order__c > lstjo = new List < CSS_Job_Order__c >();
            CSS_Job_Order__c jo = new CSS_Job_Order__c();
              jo.createdDate=dateTime.now();
               jo.ESN__c = '79464646';
              jo.Customer_Name__c='test';
              jo.Shop_Work_Order__c='uiafh';
              jo.Mileage__c=123;
              insert jo;
            lstjo.add(jo);
        CSS_RecentHistoryClass.getRecentHistJobs();
        //CSS_RecentHistoryClass.getRecentHistJobs().lstjob=lstjo;
        Test.stopTest();
        }
}