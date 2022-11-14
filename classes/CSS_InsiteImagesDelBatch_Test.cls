/**********************************************************************
Name:CSS_InsiteImagesDelBatch_Test 
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:   Test class for CSS_InsiteImagesDelBatch                                                   
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -  Shanthi     06/07/2017      INITIAL DEVELOPMENT  
***********************************************************************/

@isTest
private class CSS_InsiteImagesDelBatch_Test {

    static testmethod void testCSS_InsiteImagesDelBatch() { 
  
        
CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
JO.Customer_Name__c = 'CumminsTnD';
JO.Status__c = 'Repair Complete';
JO.Make__c = 'test1234';
JO.Model__c = 'test1234';
JO.DSID__c = 'test1234';
JO.Equipment_ID__c = 'test1234';
JO.Service_Model__c = 'test1234';
JO.Shop_Work_Order__c = 'test1234';
JO.INSITE_UpdateTimeStamp__c = system.now();
JO.Repair_Location__c ='Mobile';
JO.Application_Desc__c='Automotive';
JO.Preventive_Maintenance__c = 'Yes';
Jo.Assigned_To__c = UserInfo.getUserId();        
insert(JO);

        List<Attachment>att=new List<Attachment>();    
        Attachment attach = new Attachment();
attach.Name='Unit Test Attachment';
attach.Description='Unit Test Attachment Body';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
attach.body=bodyBlob1;
attach.parentId=JO.Id;
insert attach;
att.Add(attach);
 string nameattach='Unit Test Attachment';
       String query = 'select id from Attachment limit 1';

       
       Test.startTest();
       CSS_InsiteImagesDelBatch image = new CSS_InsiteImagesDelBatch(query);
       Database.executeBatch(image); 
       Test.stopTest();

      
    }
}