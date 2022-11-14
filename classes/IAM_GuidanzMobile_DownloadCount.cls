/************************************************************
Purpose: It is used to download mobile count to be consumed by user
=============================================================
History                                                                                                                     
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Shubhangi Sardar              02/08/2021        INITIAL DEVELOPMENT
***********************************************************************************/

@RestResource(urlMapping='/DownloadCount/*')
global with sharing class IAM_GuidanzMobile_DownloadCount {
    
    @HttpPost
    global static CMI_ResponseHandler doPost(InputRequest params) {
        System.debug('#### params - '+params);
        InputRequest req;        
        try {
            req = params;
            String errMsg = validateRequest(req);
            if(String.isNotBlank(errMsg)) {
                return sendResponse('Error', errMsg, 0, new List<String>());
            }
            List<Contact> conList = IAM_GuidanzMobile_CountUtility.getContact(req.UserID);
            if(conList.isEmpty()) {
                return sendResponse('Error', 'IAMD07 - ' + Label.IAM_UserDoesNotExist, 0, new List<String>());
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
                return sendResponse('Error', 'IAMD11 - There is no ' + typeStr +' Units subscription assigned to this User', 
                    0, new List<String>());
            }
            CMI_ResponseHandler response 
                = getDownloadCountArray(paidCountSubscriptionList, freeCountSubscriptionList, req, typeStr);
            if(response != null) {
                return response;
            } else {
                return sendResponse('Error', 'IAMD08 - ' + Label.IAM_UnknownError, 0, new List<String>());
            }
            
        } catch(Exception ex) {
            IAM_GuidanzMobile_CountUtility.addError(ex.getMessage(), JSON.serialize(req));
            return sendResponse('Error', 'IAMD09 - ' + ex.getMessage(), 0, new List<String>());
        }        
    }

    /* Return download count */
    private static CMI_ResponseHandler getDownloadCountArray(List<IAM_Contact_Provisioning__c> paidCountSubscriptionList,
    List<IAM_Contact_Provisioning__c> freeCountSubscriptionList, InputRequest req, String typeStr) {
        CMI_ResponseHandler response;
        List<IAM_Contact_Provisioning__c> conProToUpdateList = new List<IAM_Contact_Provisioning__c>();
        Integer downloadCountFree = 0;
        
        if(freeCountSubscriptionList.isEmpty() || freeCountSubscriptionList[0].IAM_Remaining_Units__c == 0) {
            downloadCountFree = 0;
        } else if(freeCountSubscriptionList[0].IAM_Remaining_Units__c >= req.RequestedCount) {
            downloadCountFree = req.RequestedCount;
            freeCountSubscriptionList[0].IAM_Remaining_Units__c 
                = freeCountSubscriptionList[0].IAM_Remaining_Units__c - req.RequestedCount;
                       
            List<String> countArray = createCountArray(downloadCountFree, 0, req.Type);
            Integer serverRemainingCount = 0;
            serverRemainingCount = Integer.valueOf(
                freeCountSubscriptionList[0].IAM_Remaining_Units__c);
            if(!paidCountSubscriptionList.isEmpty()) {
                serverRemainingCount 
                = serverRemainingCount + Integer.valueOf(paidCountSubscriptionList[0].IAM_Remaining_Units__c);
            }
            IAM_GuidanzMobile_CountUtility.addHistory('DownloadUnits', typeStr, req.UserID,
                0, downloadCountFree, serverRemainingCount, req.DeviceInfo);
            update freeCountSubscriptionList[0];
            return sendResponse('Success', '', serverRemainingCount, countArray);
        } else if(freeCountSubscriptionList[0].IAM_Remaining_Units__c < req.RequestedCount) {
            downloadCountFree = Integer.valueOf(freeCountSubscriptionList[0].IAM_Remaining_Units__c);
            freeCountSubscriptionList[0].IAM_Remaining_Units__c = 0;
            conProToUpdateList.add(freeCountSubscriptionList[0]);
        }

        if(downloadCountFree < req.RequestedCount) {
            Integer downloadCountPaid = 0;
            Integer requiredPaidCount = req.RequestedCount - downloadCountFree;
            if(paidCountSubscriptionList.isEmpty() || paidCountSubscriptionList[0].IAM_Remaining_Units__c == 0
            || paidCountSubscriptionList[0].IAM_Remaining_Units__c < requiredPaidCount) {
                Integer serverRemainingCount = 0;
                if(!freeCountSubscriptionList.isEmpty()) {
                    serverRemainingCount = downloadCountFree;
                }
                if(!paidCountSubscriptionList.isEmpty()) {
                    serverRemainingCount = serverRemainingCount 
                    + Integer.valueOf(paidCountSubscriptionList[0].IAM_Remaining_Units__c);
                }
                return sendResponse('Error', 'IAMD10 - ' + Label.IAM_InsufficientUnitsType, serverRemainingCount, new List<String>());
            } else if(paidCountSubscriptionList[0].IAM_Remaining_Units__c >= requiredPaidCount) {
                downloadCountPaid = requiredPaidCount;
                paidCountSubscriptionList[0].IAM_Remaining_Units__c 
                    = paidCountSubscriptionList[0].IAM_Remaining_Units__c - requiredPaidCount;          
                conProToUpdateList.add(paidCountSubscriptionList[0]);
                List<String> countArray = createCountArray(downloadCountFree, downloadCountPaid, req.Type);
                Integer serverRemainingCount = 0;
                serverRemainingCount = 
                    Integer.valueOf(paidCountSubscriptionList[0].IAM_Remaining_Units__c);
                IAM_GuidanzMobile_CountUtility.addHistory('DownloadUnits', typeStr, req.UserID,
                    downloadCountPaid, downloadCountFree, serverRemainingCount, req.DeviceInfo);
                update conProToUpdateList;
                return sendResponse('Success', '', serverRemainingCount, countArray);
            }
        }
        return response;
    }

    /* Create unique Id for each paid and free count and return array of string  */
    private static List<String> createCountArray(Integer freeCount, Integer paidCount, Integer typeVal) {
        List<String> countArray = new List<String>();
        String sub;
        if(typeVal == 0) { sub = 'T0'; }
        if(typeVal == 1) { sub = 'T1'; }
        if(typeVal == 2) { sub = 'T2'; }
        if(freeCount != 0) {
            String formattedDate = DateTime.now().formatGMT('MMddyyhhmmss');
            for(Integer i = 1; i<=freeCount; i++) {
                String uniqueId = 'F'+sub+formattedDate+i;
                countArray.add(uniqueId);
            }
        }
        if(paidCount != 0) {
            String formattedDate = DateTime.now().formatGMT('MMddyyhhmmss');
            for(Integer i = 1; i<=paidCount; i++) {
                String uniqueId = 'P'+sub+formattedDate+i;
                countArray.add(uniqueId);
            }
        }
        return countArray;
    }

    /* Validate request, check if all required fields are available */
    private static String validateRequest(InputRequest req) {
        if(req.Type == null) {
            return 'IAMD01 - Type is missing';
        }
        if(String.isBlank(req.UserID)) {
            return 'IAMD02 - UserID is missing';
        }
        if(String.isBlank(req.DeviceInfo)) {
            return 'IAMD03 - DeviceInfo is missing';
        }
        if(req.RequestedCount == null) {
            return 'IAMD04 - RequestedCount is missing';
        }
        if(req.Type != null && req.Type != 0 && req.Type != 1 && req.Type != 2) {
            return 'IAMD05 - ' + Label.IAM_InvalidTypeValue;
        }
        if(req.RequestedCount != null && req.RequestedCount <= 0) {
            return 'IAMD06 - RequestedCount must be greater than 0';
        }
        return null;
    }

    /* Initialize response object and assign given values to parameters */
    private static CMI_ResponseHandler sendResponse(String status, String msg, Integer count,
      List<String> countArray) {
        CMI_ResponseHandler resp = new CMI_ResponseHandler();
        resp.Status = status;
        resp.Message = msg;
        resp.ServerRemainingCount = count;
        resp.RequestedCount = countArray;
        return resp;
    }

    /* Accept request in given format */
    global class InputRequest {    
        global Integer Type {get; set;}
        global String UserID {get;set;}
        global String DeviceInfo {get; set;}
        global Integer RequestedCount {get; set;}
    }  

    /* Response returned after success or failure of operation */
    global class CMI_ResponseHandler{    
        global String Status {get; set;}
        global String Message {get;set;}
        global List<String> RequestedCount {get; set;}
        global Integer ServerRemainingCount {get; set;}
    }  
}