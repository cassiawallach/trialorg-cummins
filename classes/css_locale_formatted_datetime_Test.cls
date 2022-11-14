@istest
private class css_locale_formatted_datetime_Test {
    static TestMethod void testCallout() {
        css_locale_formatted_datetime tstControl = new css_locale_formatted_datetime();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
         //JO.name = 'ban';
        //update JO;
       
         String nameId =[select id,name from CSS_Job_Order__c where id = :JO.Id ].name;
        system.debug('jo name'+nameId);
         system.debug('jo.Creator_Location__c>>>>>>>>***'+JO.Creator_Location__c);
        Test.startTest();
        tstControl.JobOrderId = '123456';
        tstControl.JobStatusvalue = 'closed';
        tstControl.dt_created = System.now();
        tstControl.dt_modify = System.now();
        tstControl.dt_shopIn = System.now();
       	tstControl.jobOrdNumber = JO.name;
        tstControl.JobLocation = 'Test';
        String sDTCreated = tstControl.getDtCreated();
        String sDTModify = tstControl.getDtModify();
        String sDTShopIn = tstControl.getDtShopIn();
        String LocCode = tstControl.getLocCode();
        Test.stopTest();
    }
}