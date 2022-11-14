/************************************************************
Name:  OSM_SW_SubscriptionTriggerHandlerUtility 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Utility class for subscription trigger handler class. 
It will contain future method to invoke during insert and
update trigger calls.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_SW_SubscriptionTriggerHandlerUtility{
    
    @future(callout = true)
    public static void CallFreeTrialBusinessLayerForInsert(List<Id> subsId){ //On Insert, pass list of subscription id's.
        OSM_SW_SubscriptionAction.FreeTrialSubscriptionOnInsert(subsId);
    }
    
    @future(callout = true)
    public static void CallFreeTrialBusinessLayerForUpdate(List<String> jsonList){ //On Update, pass list of json string containing wrapper object
        OSM_SW_SubscriptionAction.FreeTrialSubscriptionOnUpdate(jsonList);
    }
    
    //@future(callout = true)
    public static void callIAMProvisioningBusinessLayerForInsert(List<Id> subsIdList,boolean isAll,boolean isOnlyforGuidanz){ 
        OSM_SW_SubscriptionAction.IAMProvisioningOnInsert(subsIdList,isAll,isOnlyforGuidanz);
    }
}