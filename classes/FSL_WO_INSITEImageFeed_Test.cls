@isTest(SeeAllData=true)
public class FSL_WO_INSITEImageFeed_Test {
    
   public static testMethod void TestInsiteImageFeed(){
    
   WorkOrder  wo = [SELECT ID,Before_Image__c,After_Image__c,WorkOrderNumber,Process_Step__c ,LastModifiedDate FROM WorkOrder where Process_Step__c = 'Job Plan' limit 1];
            workorder wo2 = new workorder();
            wo2.id = wo.id;
            Map<id,workorder> woInfoTest = new Map<id,workorder>();
            woInfoTest.put(wo.id,wo);
            Map<id,workorder> woInfoTest1 = new Map<id,workorder>();
            woInfoTest1.put(wo2.id,wo2);
            map<id,WorkOrder> mapOldServiceorder = new  map<id,WorkOrder>();
            mapOldServiceorder.put(wo2.id,wo2);
            wo2.Before_Image__c = 'I-20160615-155015040';
            wo2.After_Image__c = 'SI-20200723-144301365-279FD266';
            update wo2;
            Test.startTest();
            FSL_WO_INSITEImageFeed.woINSITEImageChange(woInfoTest,woInfoTest1);
          Boolean  beforeImageModified = true;
          Boolean  afterImageModified = true;
                 FSL_WO_INSITEImageFeed.upsertWOInsiteImages(wo2, true, true);
           Test.stopTest();
                }
        }