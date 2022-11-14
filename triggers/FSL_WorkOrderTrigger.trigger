/*****************************************************************************************************************************
Name : FSL_WorkOrderTrigger 
Description : Work Order object Trigger.
Description2 : using this trigger to call getcampaign service on change of PSN

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                  26/02/2019                Srinivas Reddy Katkam               Trigger created
2.0                  05/28/2019                Ravikanth Macherla                  Trigger for GetCampaign
3.0                  07/13/2020                Krishnamoorthi N                    Assign queues to Dealer
4.0                  08/03/2020                Mallika Subhashini                  Trigger for AdminSRT
5.0                  10/20/2020                Dinesh Yadav                        Delete TSBs once Work Order closed or Cancelled
6.0                  03/23/2021                Charan Teja                         Avoiding recursive action for bug CT3-380
7.0                  06/25/2021                Vijay/Rajkumar                      Added logic to avoid Trigger Recursion
8.0                  07/08/2021                Vijay/Rajkumar                      Added logic to avoid FSL Review error  
******************************************************************************************************************************/
trigger FSL_WorkOrderTrigger on WorkOrder (before insert, after insert, before update, after update) {
    
    Boolean flag = true; //need to get this flag from Custom Label/Setting
    if(flag) { //To activate or deactivate trigger in PROD
        system.debug('@FSL_WorkOrderTrigger ');
        if(trigger.isBefore && trigger.isInsert) {
            
            // Added logic to populate Edit Complaint value - START
            for(WorkOrder wo : Trigger.new){
                wo.EditComplaint__c = wo.General_Symptoms__c;
            }
            // Added logic to populate Edit Complaint value - END
            
            FSL_workorderListTriggerHandle.validateSTCUser(Trigger.New);
            EVL_WorkOrderListTriggerHandle.changeOwnerInfo(Trigger.New, null, true);
            FSL_workorderListTriggerHandle.workorderTriggerHandleBeforeInsert(Trigger.New);
            FSL_workorderListTriggerHandle.populateGeneralSymptoms(Trigger.New);
            FSL_workorderListTriggerHandle.updateSubStatus(Trigger.New,Trigger.oldMap); // CT4-714//
        }
        
        if(trigger.isBefore && trigger.isUpdate && RecursiveTriggerHandler.isWorkOrderBeforeUpdate == true) {
            
            // Added logic to populate Edit Complaint value - START
            for(WorkOrder wo : Trigger.new){
                if((Trigger.oldmap.get(wo.Id).General_Symptoms__c != wo.General_Symptoms__c) || (Trigger.oldmap.get(wo.Id).Category1__c != wo.Category1__c) || (Trigger.oldmap.get(wo.Id).Complaint_Type1__c != wo.Complaint_Type1__c)){
                    wo.EditComplaint__c = wo.General_Symptoms__c;
                }
            }
            // Added logic to populate Edit Complaint value - END
            FSL_workorderListTriggerHandle.updateSubStatus(Trigger.New, Trigger.oldMap);// CT4-714
            
            RecursiveTriggerHandler.isWorkOrderBeforeUpdate = false;
            system.debug('Inside Before update Trigger For updateWoDetails:::1'+ Trigger.newMap.get(Trigger.newMap.values()[0].id).AssetId + 'Inside updateWoDetails:::'+  Trigger.oldMap.get(Trigger.oldMap.values()[0].id).AssetId);
            FSL_workorderListTriggerHandle.validateSTCUser(Trigger.New);
            EVL_WorkOrderListTriggerHandle.changeOwnerInfo(Trigger.New, Trigger.oldMap, false);
            FSL_workorderListTriggerHandle.updateSubStatus(Trigger.New, Trigger.oldMap);// CT4-714
            FSL_workorderListTriggerHandle.workorderTriggerHandleBeforeUpdate(Trigger.NewMap, Trigger.oldMap);
            EVL_WorkOrderListTriggerHandle.validateProductMH(Trigger.New, Trigger.oldMap); // Sruthi - Changes to validate Product Mileage and Hours before update
            
            system.debug('Inside Before update Trigger For updateWoDetails:::2'+ Trigger.newMap.get(Trigger.newMap.values()[0].id).AssetId + 'Inside updateWoDetails:::'+  Trigger.oldMap.get(Trigger.oldMap.values()[0].id).AssetId);
             System.debug('SOQL Count---> ' + Limits.getQueries());
        }
        
        if(trigger.isAfter && trigger.isInsert && RecursiveTriggerHandler.isDealerWOUpdate == true) {
            FSL_workorderListTriggerHandle.workorderTriggerHandleAfterInsert(Trigger.New);
            FSL_workorderListTriggerHandle.getcampaingintegration(Trigger.New,Trigger.oldMap,false); // Added Ravikanth
            FSL_workorderListTriggerHandle.getTSBQSOLcall(Trigger.New,Trigger.oldMap,false); // Added Ravikanth TSB integration
            FSL_workorderListTriggerHandle.insertServiceOrderContactList(Trigger.New);
             FSL_PrimarySubTypeAccount.createPrimarySubType(Trigger.new,trigger.newMap,null);//Added by Raghav for CT2-344
            
           
            String jsonString = json.serialize(Trigger.NEW);
            String jsonStringMap = json.serialize(Trigger.newmap);
            FSL_workorderListTriggerHandle.populateMaintenanceAsset_Parts(jsonString);
            FSL_workorderListTriggerHandle.attachFormToPMWO(jsonStringMap);
        }
        
        if(trigger.isAfter && trigger.isUpdate) {
          FSL_PrimarySubTypeAccount.createPrimarySubType(Trigger.new,trigger.newMap, trigger.oldmap);//Added by Raghav for CT2-344
            if(RecursiveTriggerHandler.isWorkOrderUpdate == true){
                
                RecursiveTriggerHandler.isWorkOrderUpdate = false;
                
                EVL_WorkOrderListTriggerHandle.populateAuditTrial(Trigger.New, Trigger.OldMap); //Added by Sruthi
                FSL_workorderListTriggerHandle.workorderTriggerHandleAfterUpdate(trigger.newMap, trigger.oldMap);
                //Commented below condition to avoid multiple checks
                /*if(RecursiveTriggerHandler.isCheckFieldActions == true) //Added by Charan for bug CT3-380
                {*/
                    FSL_workorderListTriggerHandle.getcampaingintegration(Trigger.New,Trigger.oldMap,true); // Added Ravikanth
                //}
                FSL_workorderListTriggerHandle.getTSBQSOLcall(Trigger.New,Trigger.oldMap,true); // Added Ravikanth TSB integration
               // FSL_workorderListTriggerHandle.getAdminSRTCall(Trigger.NewMap,Trigger.oldMap,true);line 47 commented for april release 
                FSL_workorderListTriggerHandle.insertServiceOrderContactList(Trigger.new);
                FSL_workorderListTriggerHandle.serviceOrderSharing(Trigger.NewMap,Trigger.oldMap);
                FSL_workorderListTriggerHandle.workorderTriggerHandleSOContactDEL(Trigger.NewMap, Trigger.oldMap);//Added by Vijay CT4-103
                FSL_workorderListTriggerHandle.DeleteTSBOnCloseWorkOrder(Trigger.NewMap, Trigger.oldMap);  //Added by Dinesh Yadav, CT3-153
                /*
                * Commented below method call as we have moved logic to 
                * FSL_ServiceOrder_LightningPath componenet on change of sub status field value to
                * 'Troubleshooting Complete' or 'Send Account Updates'
                */
                // FSL_workorderListTriggerHandle.subStatusToTroubleshootingComplete(trigger.newMap, trigger.oldMap);
                System.debug('SOQL Count---> ' + Limits.getQueries());
            }
        }
    }
}