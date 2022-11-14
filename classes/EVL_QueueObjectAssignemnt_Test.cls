/**********************************************************************
Name:EVL_QueueObjectAssignemnt_Test
Copyright © 2022  Cummins
======================================================
======================================================
Purpose:                                                            
------- This class is used for testing assigning Queue Objects
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Ramya Sanikommu    06/09/2022       INITIAL DEVELOPMENT(VGRS2-503)
***********************************************************************/
@isTest
public class EVL_QueueObjectAssignemnt_Test {
	 @testSetup static void dataSetup() 
    {
        Group grp = new Group(Name='JQ-111-111', Type='Queue');
        insert grp;
        
    }
    @isTest  
    static void QueueObjectAssignment() {
        List<List<String>> locs = new List<List<String>>();
        List<String> strLocation = new List<String>();
        List<Group> lstGroup = [select Id,Name,DeveloperName from Group where Name ='JQ-111-111'];
        strLocation.add('111-111');
        locs.add(strLocation);
        Test.startTest();
        	EVL_QueueObjectAssignemnt.getQueueObjecs(locs);
        Test.stopTest();
        System.assertEquals('JQ-111-111', lstGroup[0].Name, 'Queue should be same');
    }
     @isTest  
    static void QueueObjectAssignmentNoLoc() {
        List<List<String>> locs = new List<List<String>>();
        List<String> strLocation = new List<String>();
        List<Group> lstGroup = [select Id,Name,DeveloperName from Group where Name ='JQ-111-111'];
        strLocation.add('123-123');
        locs.add(strLocation);
        Test.startTest();
        	EVL_QueueObjectAssignemnt.getQueueObjecs(locs);
        Test.stopTest();        
        System.assertNotEquals('JQ-123-123', lstGroup[0].Name, 'No Queue available for Location');
    }
}