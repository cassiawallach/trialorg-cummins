/** 
* @author   Swetha

*/

@isTest
public class OSM_SW_WeeklyRevokeReissue_Batch_Test {

    static testMethod void testScheduleAndCancel() {
        
        Account portalAccount1 = TestingUtils.insertAccount();        
        Contact contact1 = TestingUtils.inertContact(portalAccount1.Id);
        ccrz__E_Order__c order = TestingUtils.createOrder(contact1.Id,'', true);        
        ccrz__E_Product__c prod = TestingUtils.insertProduct();
      
        ccrz__E_OrderItem__c orderItem = TestingUtils.createOrderItems(order.Id, prod.Id, true);
        
        Set<Id> orderItemIdSet=new Set<Id>();
        orderItemIdSet.add(orderItem.id);
        
        OSM_Order_Item_License__c license = TestingUtils.insertNewOILParentActivationKey(orderItem.Id);
         
        OSM_Order_Item_License__c licenseChild = TestingUtils.insertNewOrderItemLicense(orderItem.Id, license.Id);
        licenseChild.Status__c ='Revoked/ReIssue';
        update licenseChild;

        OSM_Order_Item_License__c licenseChild1 = TestingUtils.insertNewOrderItemLicense(orderItem.Id, license.Id);
		licenseChild1.Status__c ='Revoke/ReIssue Pending';
        update licenseChild1;
        
        // start test
        Test.startTest();
        
        // schedule job
        OSM_SW_WeeklyRevokeReissue_Batch.schedule();
        
        Database.executebatch(new OSM_SW_RevokeInstanceBatch(),1);
        Database.executebatch(new OSM_SW_CreateGetOrder_ON_ReIssueBatch(),1);
        Database.executebatch(new OSM_OMS_GetTI_ON_Revoked_Batch(),1);

        string sch = '0 0 * * * ?';
        System.schedule('test weekly sch', sch, new OSM_SW_WeeklyRevokeReissue_Batch());  

        // assert job scheduled
        List<CronTrigger> jobs = [SELECT Id
                                  FROM CronTrigger
                                  WHERE CronJobDetail.Name = :OSM_SW_WeeklyRevokeReissue_Batch.jobName];

        // cancel job
        OSM_SW_WeeklyRevokeReissue_Batch.cancel();      
                
        // stop test
        Test.stopTest();
        
        // assert job cancelled
        jobs = [SELECT Id
                FROM CronTrigger
                WHERE CronJobDetail.Name = :OSM_SW_WeeklyRevokeReissue_Batch.jobName];

        System.assertEquals(0, jobs.size(), 'Job not cancelled.');
    }

}