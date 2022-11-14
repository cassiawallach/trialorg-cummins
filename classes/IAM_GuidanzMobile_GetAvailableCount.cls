/************************************************************
Purpose: It is used to check available count for a user
=============================================================
History                                                                                                                     
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Shubhangi Sardar              02/08/2021        INITIAL DEVELOPMENT
***********************************************************************************/

@RestResource(urlMapping='/GetAvailableCount/*')
global with sharing class IAM_GuidanzMobile_GetAvailableCount {
    
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
                return sendResponse('Error', 'IAMG05 - ' + Label.IAM_UserDoesNotExist, 0);
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
                return sendResponse('Success', 'There is no ' + typeStr +' Units subscription assigned to this User', 0);
            }
            Integer remainingCount = 0;
            Integer paidCount, freeCount;
            if(!paidCountSubscriptionList.isEmpty()) {
                paidCount = Integer.valueOf(paidCountSubscriptionList[0].IAM_Remaining_Units__c);
                remainingCount += paidCount;
            }
            if(!freeCountSubscriptionList.isEmpty()) {
                freeCount = Integer.valueOf(freeCountSubscriptionList[0].IAM_Remaining_Units__c);
                remainingCount += freeCount;
            }
            IAM_GuidanzMobile_CountUtility.addHistory('GetAvailableUnits', typeStr, req.UserID,
                paidCount, freeCount, remainingCount, req.DeviceInfo);
            return sendResponse('Success', '', remainingCount);
        } catch(Exception ex) {
            IAM_GuidanzMobile_CountUtility.addError(ex.getMessage(), JSON.serialize(req));
            return sendResponse('Error', 'IAMG06 - ' + ex.getMessage(), 0);
        }        
    }   

    /* Validate request, check if all required fields are available */
    private static String validateRequest(InputRequest req) {
        if(req.Type == null) {
            return 'IAMG01 - Type is missing';
        }
        if(String.isBlank(req.UserID)) {
            return 'IAMG02 - UserID is missing';
        }
        if(String.isBlank(req.DeviceInfo)) {
            return 'IAMG03 - DeviceInfo is missing';
        }
        if(req.Type != null && req.Type != 0 && req.Type != 1 && req.Type != 2) {
            return 'IAMG04 - ' + Label.IAM_InvalidTypeValue;
        }
        return null;
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
    }  

    /* Response returned after success or failure of operation */
    global class CMI_ResponseHandler{    
        global String Status {get; set;}
        global String Message {get;set;}
        global Integer ServerRemainingCount {get; set;}
    }  
}