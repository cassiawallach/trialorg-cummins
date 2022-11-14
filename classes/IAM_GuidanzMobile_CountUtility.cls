/************************************************************
Purpose: Utility class for Unit subscriptions API.                       
=============================================================
History                                                                                                                     
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Shubhangi Sardar              02/08/2021        INITIAL DEVELOPMENT
***********************************************************************************/

public with sharing class IAM_GuidanzMobile_CountUtility {

    /* It return type string equivalent to Type (Integer) value */
    public static String getTypeString(Integer typeVal) {
        String typeStr = '';
        if(typeVal == 0) { typeStr = 'CalAssist'; }
        if(typeVal == 1) { typeStr = 'Intapp'; }
        if(typeVal == 2) { typeStr = 'Intapp OEM'; }
        return typeStr;
    }

    /* Return paid subscription list based on type and */
    public static List<IAM_Contact_Provisioning__c> getPaidSubsriptionList(Integer typeVal, Id contactId) {
        if(typeVal == 0) {
            return getUserSubscription(contactId,  Label.IAM_AppName_guidanzmobile,
                Label.IAM_GuidanzMobileFleetCount);
        } else if(typeVal == 1) {
            return getUserSubscription(contactId, Label.IAM_AppName_guidanzmobile,
                Label.IAM_GuidanzMobileZapitCount);
        } else if(typeVal == 2) {
            return getUserSubscription(contactId, Label.IAM_AppName_guidanzmobile,
                Label.IAM_GuidanzMobileZapitOEMCount);
        }
        return new List<IAM_Contact_Provisioning__c>();
    }

    /* Return free subscription list based on type and */
    public static List<IAM_Contact_Provisioning__c> getFreeSubsriptionList(Integer typeVal, Id contactId) {
        if(typeVal == 0) {
            return getUserSubscription(contactId, Label.IAM_App_GuidanzMobileFieldTest,
                Label.IAM_FieldTestFleetCountGM);
        } else if(typeVal == 1) {
            return getUserSubscription(contactId, Label.IAM_App_GuidanzMobileFieldTest,
                Label.IAM_FieldTestZapitCountGM);
        } else if(typeVal == 2) {
           return getUserSubscription(contactId, Label.IAM_App_GuidanzMobileFieldTest,
                Label.IAM_FieldTestZapitOEMCountGM);
        }
        return new List<IAM_Contact_Provisioning__c>();
    }


    /* Return user feature access list of Guidanz Mobile paid & free count subscriptions for given user */
    public static List<IAM_Contact_Provisioning__c> getUserSubscription(Id contactId,
        String applicationName, String subscriptionName) {
        return [
            SELECT Id
                 , IAM_Assigned_Units__c
                 , IAM_Remaining_Units__c
              FROM IAM_Contact_Provisioning__c
             WHERE IAM_Contact__r.Id = :contactId
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND IAM_Application_Name__c = :applicationName               
               AND IAM_Role__c = :subscriptionName 
               AND IAM_Subscription_Name__c = :subscriptionName
        ];
    }

    /* Return Contact with given username */    
    public static List<Contact> getContact(String username) {
        return [
            SELECT Id
              FROM Contact
             WHERE Username__c = :username
        ]; 
    }

    /* If there is error in subscription creation/renewal/revokation then it is captured 
     * in CSS_Integration_Error__c object */
    public static void addError(String msg, String request){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c = 'IAM';
        errObj.Error_Description__c = msg;
        errObj.Processed_Data__c = request;        
        insert errObj;
    }

    /* Add captured input deatils of API in custom History of API to track it in report */
    public static void addHistory(String apiName, String typeStr, String username, Integer paidCount,
    Integer freeCount, Integer remainingCount, String deviceInfo) {
        IAM_Unit_Subscriptions_History__c obj = new IAM_Unit_Subscriptions_History__c();
        obj.IAM_API_Name__c = apiName;
        obj.IAM_Type__c = typeStr;
        obj.IAM_Username__c = username;
        if(paidCount != null) {
            obj.IAM_Paid_Units__c = paidCount;
        }
        if(freeCount != null) {
            obj.IAM_Free_Units__c = freeCount;
        }        
        obj.IAM_Server_Remaining_Units__c = remainingCount;
        obj.IAM_Device_Info__c = deviceInfo;
        insert obj;
    }
}