/************************************************************
Purpose: It is used to upload unused mobile count of a user.                        
=============================================================
History                                                                                                                     
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Shubhangi Sardar              02/08/2021        INITIAL DEVELOPMENT
***********************************************************************************/

@RestResource(urlMapping='/UploadCount/*')
global with sharing class IAM_GuidanzMobile_UploadCount {
    //private static CMI_ResponseHandler response;

    @HttpPost
    global static CMI_ResponseHandler doPost(InputRequest params) {
        System.debug('#### params - '+params);
        InputRequest req;
        try {
            req = params;
            String errMsg = validateRequest(req);
            if(String.isNotBlank(errMsg)) {
                return sendResponse('Error', errMsg, 0);
            }
            List<Contact> conList = IAM_GuidanzMobile_CountUtility.getContact(req.UserID);
            if(conList.isEmpty()) {
                return sendResponse('Error', 'IAMU07 - ' + Label.IAM_UserDoesNotExist, 0);
            }
            List<IAM_Contact_Provisioning__c> paidCountSubscriptionList;
            List<IAM_Contact_Provisioning__c> freeCountSubscriptionList;
            /* Type : 0 = CalAssist, 1 = Intapp, 2 = IntappOEM */
            String typeStr = IAM_GuidanzMobile_CountUtility.getTypeString(req.Type);
            paidCountSubscriptionList = 
                IAM_GuidanzMobile_CountUtility.getPaidSubsriptionList(req.Type, conList[0].Id);
            freeCountSubscriptionList =
                IAM_GuidanzMobile_CountUtility.getFreeSubsriptionList(req.Type, conList[0].Id);
            if(paidCountSubscriptionList.isEmpty() && freeCountSubscriptionList.isEmpty()) {
                return sendResponse('Error', 'IAMU12 - There is no ' + typeStr +' Units subscription assigned to this User', 0);
            }
            CMI_ResponseHandler response
                = updateRemainingCount(paidCountSubscriptionList, freeCountSubscriptionList, req, typeStr);
            if(response != null) {
                return response;
            } else {
                return sendResponse('Error', 'IAMU08 - ' + Label.IAM_UnknownError, 0);
            }
            
        } catch(Exception ex) {
            IAM_GuidanzMobile_CountUtility.addError(ex.getMessage(), JSON.serialize(params));
            return sendResponse('Error', 'IAMU09 - ' + ex.getMessage(), 0);
        }        
    }

    /* Update respective subscription remaining count with uploaded value */
    private static CMI_ResponseHandler updateRemainingCount(List<IAM_Contact_Provisioning__c> paidCountSubscriptionList,
    List<IAM_Contact_Provisioning__c> freeCountSubscriptionList, InputRequest req, String typeStr) {
        CMI_ResponseHandler response;
        Set<String> uniqueIdSet = new Set<String>();
        List<IAM_Contact_Provisioning__c> subToUpdateList = new List<IAM_Contact_Provisioning__c>();
        uniqueIdSet.addAll(req.RequestedCount);
        Integer paidCount = 0;
        Integer freeCount = 0;
        for(String str : uniqueIdSet) {
            if(str.startsWith('P')) { paidCount++; }
            if(str.startsWith('F')) { freeCount++; }
        }
        if(paidCountSubscriptionList.isEmpty() && paidCount > 0) {
            return sendResponse('Error', 'IAMU10 - There is no paid ' + typeStr +' Units subscription assigned to this User', 0);
        }
        if(freeCountSubscriptionList.isEmpty() && freeCount > 0) {
            return sendResponse('Error', 'IAMU11 - There is no free ' + typeStr +' Units subscription assigned to this User', 0);
        }
        updateFields(paidCountSubscriptionList, paidCount, subToUpdateList);
        updateFields(freeCountSubscriptionList, freeCount, subToUpdateList);
        Integer serverRemainingCount = 0;
        if(!paidCountSubscriptionList.isEmpty()) {
            System.debug('#### paid remaing count - '+ paidCountSubscriptionList[0].IAM_Remaining_Units__c);
            serverRemainingCount = Integer.valueOf(paidCountSubscriptionList[0].IAM_Remaining_Units__c);
        } 
        if(!freeCountSubscriptionList.isEmpty()) {
            System.debug('#### free remaing count - '+ freeCountSubscriptionList[0].IAM_Remaining_Units__c);
            serverRemainingCount = serverRemainingCount 
                + Integer.valueOf(freeCountSubscriptionList[0].IAM_Remaining_Units__c);
        }
        if(!subToUpdateList.isEmpty()) {
            IAM_GuidanzMobile_CountUtility.addHistory('UploadUnits', typeStr, req.UserID,
            paidCount, freeCount, serverRemainingCount, req.DeviceInfo);
            update subToUpdateList;
            return sendResponse('Success', '', serverRemainingCount);
        }
        return response;
    }

    private static void updateFields(List<IAM_Contact_Provisioning__c> subList, Integer count, 
    List<IAM_Contact_Provisioning__c> updateList) {
        if(!subList.isEmpty() && count != 0) {
            subList[0].IAM_Remaining_Units__c = subList[0].IAM_Remaining_Units__c + count;
            System.debug('#### subList[0] '+ subList[0]);
            updateList.add(subList[0]);
        }
    }

    /* Validate request, check if all required fields are available */
    private static String validateRequest(InputRequest req) {
        if(req.Type == null) {
            return 'IAMU01 - Type is missing';
        }
        if(String.isBlank(req.UserID)) {
            return 'IAMU02 - UserID is missing';
        }
        if(String.isBlank(req.DeviceInfo)) {
            return 'IAMU03 - DeviceInfo is missing';
        }
        if(req.RequestedCount == null || req.RequestedCount.isEmpty()) {
            return 'IAMU04 - RequestedCount is missing';
        }
        if(req.Type != null && req.Type != 0 && req.Type != 1 && req.Type != 2) {
            return 'IAMU05 - ' + Label.IAM_InvalidTypeValue;
        }
        if(req.RequestedCount != null && !req.RequestedCount.isEmpty() && req.Type != null) {
            Boolean isTypeMismatch = validateRequestedCount(req.Type, req.RequestedCount);
            if(isTypeMismatch) {
                return 'IAMU06 - ' + Label.IAM_IDFormatShouldMatchToType;
            }
        }
        return null;
    }

    /* Validate RequestedCount array. Unique ID format should match with Type value */
    private static Boolean validateRequestedCount(Integer typeVal, List<String> requestedCountList) {
        Boolean isTypeMismatch = false;
        for(String uniqueID : requestedCountList) {
            if(typeVal == 0 && uniqueID.substring(0,3) != 'PT0' && uniqueID.substring(0,3) != 'FT0') {
                isTypeMismatch = true;
                break;
            }
            if(typeVal == 1 && uniqueID.substring(0,3) != 'PT1' && uniqueID.substring(0,3) != 'FT1') {
                isTypeMismatch = true;
                break;
            }
            if(typeVal == 2 && uniqueID.substring(0,3) != 'PT2' && uniqueID.substring(0,3) != 'FT2') {
                isTypeMismatch = true;
                break;
            }
        }
        return isTypeMismatch;
    }

    /* Initialize response object and assign given values to parameters */
    private static CMI_ResponseHandler sendResponse(String status, String msg, Integer count) {
        CMI_ResponseHandler resp = new CMI_ResponseHandler();
        resp.Status = status;
        resp.Message = msg;
        resp.ServerRemainingCount = count;
        return resp;
    }

    /* Accept request in given format */
    global class InputRequest {    
        global Integer Type {get; set;}
        global String UserID {get;set;}
        global String DeviceInfo {get; set;}
        global List<String> RequestedCount {get; set;}
    }  

    /* Response returned after success or failure of operation */
    global class CMI_ResponseHandler{    
        global String Status {get; set;}
        global String Message {get;set;}
        global Integer ServerRemainingCount {get; set;}
    }  
}