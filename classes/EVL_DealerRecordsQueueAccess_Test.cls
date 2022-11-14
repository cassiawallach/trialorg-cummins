/**********************************************************************
Name:EVL_DealerRecordsQueueAccess_Test
Copyright © 2022  Cummins
======================================================
======================================================
Purpose:                                                            
------- Test class for EVL_DealerRecordsQueueAccess
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Ramya Sanikommu    06/15/2022       INITIAL DEVELOPMENT(VGRS2-614)
***********************************************************************/
@isTest
public class EVL_DealerRecordsQueueAccess_Test {
     @testSetup static void dataSetup() 
    {
        Group grp = new Group(Name='JQ-111-111', Type='Queue');
        insert grp;
        
    }
    @isTest  
    static void QueueObjectAssignment() {
        Group grp = new Group(Name='JQ-145-789', Type='Queue');
        List<Group> lstGroup = [select Id,Name,DeveloperName from Group where Name ='JQ-111-111']; 
        lstGroup.add(grp);
        Test.startTest();
        	EVL_DealerRecordsQueueAccess obj = new EVL_DealerRecordsQueueAccess(lstGroup);
        	ID JobID = System.enqueueJob(obj);
        Test.stopTest();
        System.assertEquals('JQ-111-111', lstGroup[0].Name, 'Queue should be same');
    }
}