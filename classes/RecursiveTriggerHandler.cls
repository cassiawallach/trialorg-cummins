//To stop trigger from calling recurrsively
public class RecursiveTriggerHandler {
    public static Boolean isFirstTimeServiceRequestTrigger = true;//Added by Anirudh
    public static Boolean isFirstTimePartsTrigger = true;
    //Solution Component Trigger variables
    public static Boolean isFirstTimeFailuresTriggerBeforeUpdate = true;
    public static Boolean isFirstTimeFailuresTriggerAfterUpdate = true;
    //SRT Trigger variables
    public static Boolean isFirstTimeSRTsTriggerBeforeUpdate = true;  
    public static Boolean isFirstTimeSRTsTriggerAfterUpdate = true;
    public static Boolean isFirstTimeSRTsTriggerAfterInsert = true; //101 SOQL issue fix
    //Claims Trigger variables
    public static Boolean isFirstTimeClaimsTriggerAfterUpdate = true; //101 SOQL issue fix
    //Parts Trigger variables
    public static Boolean isFirstTimePartsTriggerBeforeUpdate = true; //101 SOQL issue fix
    public static Boolean isFirstTimePartsTriggerAfterUpdate = true; //101 SOQL issue fix
    public static Boolean isCallFromCaseComments = true; 
    public static Boolean chkSRAccountId = true;
    public static Boolean checkResource=true;//Added by Ravi for bug CT2-507
    public static Boolean isCheckFieldActions = true; //Added by Charan for bug CT3-380
    public static Boolean isNotCalledfromWOPB = true; // Bharat - CT3-454, 101 from WO PB
    public static Boolean isDealerWOUpdate = true; // Added to avoid 101 SOQL issue
    public static Boolean isWorkOrderUpdate = true; // Added to avoid 101 SOQL issue
    public static Boolean isWorkOrderBeforeUpdate = true; // Added to avoid 101 SOQL issue(Trigger Recursion re design)
    public static Boolean isSRUpdate = true; // Added to avoid 101 SOQL issue(Trigger Recursion re design)
    public static Boolean isSABeforeUpdate = true; // Added to avoid 101 SOQL issue(Trigger Recursion re design)
    public static Boolean isYourekaWorkOrderAfterUpdate = true;
    public static Boolean isYourekaCaseAfterUpdate = true;
    public static Boolean isSAAfterUpdate = true; // Added to avoid 101 SOQL issue(Trigger Recursion re design)
    public static Boolean isAssignedResource = true; //To stop recursion(Trigger Recursion re design)
    public static Boolean isUpdFSLFailureFlag = true; //Use in FSL_GETCampaignServices class
}