/******************************************************************************************************
Name : FSL_WorkOrderTrigger 
Description : Work Order object Trigger.
Description2 : using this trigger to insert/update WO INSITE Images when before image/after image is modified on work order obj
Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   12/10/2020               Sailaja Guntupalli                   Apex cls created for WO after update event trigger
*********************************************************************************************************/
public class FSL_WO_INSITEImageFeed {

    public static void woINSITEImageChange(Map<Id, workorder> newMap, Map<Id,workorder> oldMap){
        list<WorkOrder> woList = new list<WorkOrder>(newMap.values());
        Boolean beforeImageModified;
        Boolean afterImageModified;
        woList = [SELECT ID,Before_Image__c,After_Image__c,WorkOrderNumber FROM WorkOrder where id IN: newMap.KeySet()];
        for(workorder wo: woList){
            beforeImageModified = false;
            afterImageModified = false;
           if(wo.Before_Image__c!=oldMap.get(wo.Id).Before_Image__c || wo.After_Image__c!=oldMap.get(wo.Id).After_Image__c){
                 if(wo.Before_Image__c!=oldMap.get(wo.Id).Before_Image__c){
                     beforeImageModified = true;
                 }
                  if(wo.After_Image__c!=oldMap.get(wo.Id).After_Image__c){
                     afterImageModified = true;
                 }
                 FSL_WO_INSITEImageFeed.upsertWOInsiteImages(wo, beforeImageModified, afterImageModified);
                }
        }
        
    }    
    
    public static void upsertWOInsiteImages(WorkOrder wo,Boolean beforeImageModified,Boolean afterImageModified){
        WO_INSITE_Images__c woInsiteImage = new WO_INSITE_Images__c();
        List<WO_INSITE_Images__c> woInsiteImageList = [SELECT ID, Eif_Before_Image__c, Eif_After_Image__c,Csv_Before_Image__c,Csv_After_Image__c,Service_Order__c
                                            FROM WO_INSITE_Images__c
                                            where Service_Order__c =:wo.id limit 1];
        
        system.debug('FSL_WO_INSITEImageFeed.upsertWOInsiteImages woInsiteImage Result: ' + woInsiteImage);
        if(woInsiteImageList.isEmpty()){         
            woInsiteImage.Service_Order__c = wo.id;
        } else {
           woInsiteImage = woInsiteImageList[0];
            if(beforeImageModified){
                woInsiteImage.Eif_Before_Image_Present__c = 'New';
                woInsiteImage.Csv_Before_Image_present__c = 'New';
            }
            if(afterImageModified){
                woInsiteImage.Eif_After_Image_Present__c = 'New';
                woInsiteImage.Csv_After_Image_present__c = 'New'; 
            }
        }
        if(wo.Before_Image__c !=null){
        woInsiteImage.Eif_Before_Image__c = wo.Before_Image__c+'.eif';
        woInsiteImage.Csv_Before_Image__c = wo.Before_Image__c+'.csv';
        }
        if(wo.After_Image__c != null){
        woInsiteImage.Eif_After_Image__c = wo.After_Image__c+'.eif';
        woInsiteImage.Csv_After_Image__c = wo.After_Image__c+'.csv';
        }
        system.debug('FSL_WO_INSITEImageFeed.upsertWOInsiteImages woInsiteImage Modified: ' + woInsiteImage);
        
        upsert woInsiteImage Id;
    }
    
}