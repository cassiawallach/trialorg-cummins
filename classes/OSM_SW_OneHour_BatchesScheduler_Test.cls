/** 
     * @author   Nandigam Sasi
     *  Added as part of  MAR-1482
     * Updated As part of MAR-1662 Subbu
     */
@isTest
public class OSM_SW_OneHour_BatchesScheduler_Test {

    static testMethod void testScheduleAndCancel() {
       
         //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = UserInfo.getUserId()
        );
        Database.insert(portalAccount1);

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,IAM_Contact_Status__c = 'Active',
        Username__c='Test666uni298'+'test@test.com',
        Email = 'test' + 'test@test.com'
        );
        
        Database.insert(contact1);
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.ccrz__Contact__c=contact1.id;
        insert order;
        
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Fleet Count';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c = order.ID; 
        orderItem.ccrz__Price__c = 50.00;
        orderItem.OMS_Item_ID__c='1234';
        orderItem.OSM_Tool_Instance_Key__c='123456';
        orderItem.OMS_Instance_ID__c='F159DF1D';
        orderItem.OMS_Product__c=true;
        //orderItem.OMS_Activation_Key__c='C8QV7BPP1BJ2';
        orderItem.ccrz__Quantity__c = 1;
        orderItem.ccrz__SubAmount__c = 50.00;
        orderItem.ccrz__Product__c=prod.id;
        orderItem.OMS_Product__c=true;
        orderItem.OMS_Order_ID__c = '123';
        insert orderItem;
        
        Set<Id> orderItemIdSet=new Set<Id>();
        orderItemIdSet.add(orderItem.id);
        
        OSM_Order_Item_License__c license=new OSM_Order_Item_License__c();
        license.CC_Order_Item__c=orderItem.id;
        license.Status__c ='New';
        license.OMS_Item_Id__c='1234';
        license.Tool_Instance_Key__c='123456';
        license.Activation_Key__c='C8QV7BPP1BJ2';
        insert license;
        
        OSM_Order_Item_License__c licenseChild=new OSM_Order_Item_License__c();
        licenseChild.CC_Order_Item__c=orderItem.id;
        licenseChild.Status__c ='Revoke Initiated';
        licenseChild.OMS_Item_Id__c='1234';
        licenseChild.Tool_Instance_Key__c='123456';
        licenseChild.Parent_Activation_Key__c=license.id;
        licenseChild.Activation_Key__c='C8QV7BPP1BJ2';
        licenseChild.type__c = 'Tool instance';
        insert licenseChild;
        
        OSM_Order_Item_License__c licenseChild1=new OSM_Order_Item_License__c();
        licenseChild1.CC_Order_Item__c=orderItem.id;
        licenseChild1.Status__c ='Revoke Initiated';
        licenseChild1.OMS_Item_Id__c='1234';
        licenseChild1.Tool_Instance_Key__c='123456';
        licenseChild1.Parent_Activation_Key__c=license.id;
        licenseChild1.type__c = 'Tool instance';
        licenseChild1.Activation_Key__c='C8QV7BPP1BJ2';
        insert licenseChild1;

        // start test
        Test.startTest();
        
        // schedule job
        OSM_SW_OneHour_BatchesScheduler.schedule();
        
        Database.executebatch(new OSM_SW_RevokeOIBatch(null),1);
        //Database.executebatch(new OSM_SW_RevokeInstanceBatch(),1);
        //Database.executebatch(new OSM_SW_CreateGetOrder_ON_ReIssueBatch(),1);
        Database.executebatch(new OSM_SW_CancelOIBatch(null),1);
        //Database.executebatch(new OSM_OMS_GetTI_ON_Revoked_Batch(),1);
        
        // stop test
        Test.stopTest();

        // assert job scheduled
        List<CronTrigger> jobs = [SELECT Id
                                  FROM CronTrigger
                                  WHERE CronJobDetail.Name = :OSM_SW_OneHour_BatchesScheduler.jobName];
        System.assertEquals(1, jobs.size(), 'Job not scheduled.');

        // cancel job
        OSM_SW_OneHour_BatchesScheduler.cancel();
        
        // assert job cancelled
        jobs = [SELECT Id
                FROM CronTrigger
                WHERE CronJobDetail.Name = :OSM_SW_OneHour_BatchesScheduler.jobName];
        System.assertEquals(0, jobs.size(), 'Job not cancelled.');
    }

}