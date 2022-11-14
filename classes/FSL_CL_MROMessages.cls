/**********************************************************************
Name: FSL_CL_MROMessages
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose: This class is used for MRO Messages Integration.

=======================================================================
=======================================================================

VERSION  AUTHOR             DATE                DETAIL                                 
1.0      PiyushR            2/8/2019            INITIAL DEVELOPMENT
2.0      Harsha Ragam       10/15/2020          Mule API Changes
2.1     Sunitha Mattaparthi 1/12/2021           Added logic to make Individual Item Number field as Blank for CMI Assets
3.0		Prasanna Savalam	6/9/2022			Changes to add Named Credentials
***********************************************************************/
public class FSL_CL_MROMessages {
    
    /* static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    static Boolean isEligibleForAppLogging = true;
    static String executionLog = 'Log Start'; */
    
    public static WorkOrder woData {get;set;}
    public static String requestJSON;
    //CT2-416 : Repair_Site_Name__r.FSL_MoveX_Site_Id__c replaced by Repair_Site_Address__r.FSL_Site_ID__c
    public static WorkOrder getMROMEssageHeader(String jobID) {
        woData = [SELECT Id, ServiceTerritory.Location_Code__c, Repair_Site_Address__r.FSL_Site_ID__c, 
                  Account.FSL_ERP_Customer_Code__c, Asset.Name, Asset.Service_Model__c, Asset.Engine_Manufacturer__c, Asset.Individual__c, CreatedDate 
                  FROM WorkOrder WHERE Id=: jobID LIMIT 1]; //CT3-262 - Added Asset.Engine_Manufacturer__c
        return woData;
    }
    
    public static void MROMessageTriggerHelper(Map<Id, workorder> newMap, Map<Id,workorder> oldMap) {
        Set<ID> wordOrdIdsAccChange = new Set<Id>();
        Set<ID> wordOrdIdsAssChange = new Set<Id>();
        Set<ID> wordOrdIdsTerChange = new Set<Id>();
        for(workorder wo : newMap.values()) {
            if(wo.AccountId != oldMap.get(wo.Id).AccountId) {
                wordOrdIdsAccChange.add(wo.Id);
            }
            if(wo.AssetId != oldMap.get(wo.Id).AssetId ) {
                wordOrdIdsAssChange.add(wo.Id);
            }
            if(wo.ServiceTerritoryId != oldMap.get(wo.Id).ServiceTerritoryId) {
                wordOrdIdsTerChange.add(wo.Id);
            }
        }
        Map<String, Set<Id> > ChangeMap = new Map<String, Set<ID>>();
        ChangeMap.put('AccountChange', wordOrdIdsAccChange);
        ChangeMap.put('AssetChange',wordOrdIdsAssChange);
        ChangeMap.put('TerritoryChange', wordOrdIdsTerChange);
        System.debug(':::Changes - '+ChangeMap);
        updateChangeOnErpMessage(changeMap);
    }
    
    private static void updateChangeOnErpMessage(Map<String, Set<Id> > mapChanges) {
        List<ERP_Message__c> erpMessageToUpdate = new List<ERP_Message__c>();
        if(!mapChanges.isEmpty()) {
            Set<Id> accChangeIds = mapChanges.get('AccountChange');
            Set<Id> assetChangeIds = mapChanges.get('AssetChange');
            Set<Id> terrChangeIds =  mapChanges.get('TerritoryChange');
            for(ERP_Message__c erpm : [SELECT Id, Payer_Change__c FROM ERP_Message__c 
                                       WHERE Service_Order__c IN: accChangeIds]) {
                                           erpm.Account_Change__c = true;
                                           erpMessageToUpdate.add(erpm);
                                       }
        }
        System.debug('::: updatePayerChangeOnErpMessage = '+erpMessageToUpdate);
        if(!erpMessageToUpdate.isEmpty()) update erpMessageToUpdate;
    }
    
    
    public static List<messageWrapper> getMROMessageWebService(String serviceJob) {    
        FSL_CL_MROMessageData mro;
        String response ='';
        CG_OP_OAGWrapper outputWrapper = new CG_OP_OAGWrapper();
        List<messageWrapper> messageList = new List<messageWrapper>();
        messageWrapper msgWrap;

        // Added by Prasanna For ROAD-371
        FSL_IP_NamedCredentialWrapper reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Jobs';
        reqWrapper.Path = '/mromessages';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;  
        system.debug('endPointURL MRO Messages' +  ' ' + reqWrapper.endPoint);
        
        ERP_Message__c erpMessage = new ERP_Message__c();
        List<ERP_Message__c> erpMessageList = [SELECT Id, Service_Order__c, MRO_Messages__c,MRO_Messages_Received__c  FROM ERP_Message__c where Service_Order__c =: serviceJob];
        System.debug('::: erpMessageList - '+erpMessageList);
        if(erpMessageList.isEmpty()) {
            erpMessage = new ERP_Message__c();
            erpMessage.Service_Order__c = serviceJob;
            erpMessage.MRO_Messages_Received__c = true;
        } else {
            erpMessage = erpMessageList[0];
        }
        System.debug('::: erpMessage - '+erpMessage);
        User usr = new User();
                usr = [SELECT Id,ERP__c
                       FROM User
                       WHERE Id=:UserInfo.getUserId() LIMIT 1];
                String TargetERP;
                TargetERP = (String)usr.ERP__c;
        try {
            // Hardcoded request to test Mule Integration
                WorkOrder wo = FSL_CL_MROMessages.getMROMEssageHeader(serviceJob);
        		String locationCode = wo.ServiceTerritory.Location_Code__c;
        		String[] locationCodes = locationCode.split('\\-');
        		String IndividualItemNumber = (wo.Asset.Individual__c == null || wo.Asset.Individual__c == '' || wo.Asset.Engine_Manufacturer__c == 'CUMMINS') ? '' : wo.Asset.Individual__c; //CT3-262

                requestJSON =  '{' +
                    '\"Header\":{' +
                    '      \"Sender\":{' +
                    '          \"ServiceName\": \"GetMROMessages\",' +
                    '           \"SenderID\": \"CSS\"'+
                    '      },' +
                    '      \"Target\": { \"TargetID\": \"'+TargetERP+'\" },' +
                    '      \"Location\": { \"LocationID\": \"'+ wo.ServiceTerritory.Location_Code__c +'\" }' +
                    '  },'+
                    '   \"DataArea\":{' +
                    '       \"PSN\": \"'+ wo.Asset.Name +'\",' +
                    '       \"CustomerCode\": \"'+ wo.Account.FSL_ERP_Customer_Code__c +'\",' +
                    '       \"SiteID\": \"'+ wo.Repair_Site_Address__r.FSL_Site_ID__c +'\",' + //CT2-416 : Repair_Site_Name__r.FSL_MoveX_Site_Id__c replaced by Repair_Site_Address__r.FSL_Site_ID__c
                    // '       \"IndividualItemNumber\": \"'+ wo.Asset.Individual__c +'\",' + //added by Sriprada for MoveX-U
                    '       \"IndividualItemNumber\": \"'+ IndividualItemNumber +'\",' + //CT3-262
                    '       \"SMN\": \"'+ wo.Asset.Service_Model__c +'\",' + 
                    '       \"JobCreatedDate\": \"'+ wo.CreatedDate +'\",' +
                    '       \"DistributorCode\": \"'+ locationCodes[0] +'\",'+
                    '       \"BranchCode\": \"'+ locationCodes[1] +'\"'+
                    '   }' +
                    '} ';
            requestJSON = requestJSON.replaceAll('"null"', '""');
            reqWrapper.jsonReqBody = requestJSON;
            reqWrapper.WorkOrder = serviceJob;
             //Added by Prasanna for ROAD-371
            if(reqWrapper!=null){
                 outputWrapper =  FSL_WS_Mule.calloutNamedCredentials(reqWrapper); 
                 response = outputWrapper.response.getBody();
                 system.debug('response--'+response);
            }
            erpMessage.MRO_Messages__c = response;
            upsert erpMessage;
            System.debug('::: MRO erpMessage - '+erpMessage);
            
            mro = (FSL_CL_MROMessageData)JSON.deserialize(response, FSL_CL_MROMessageData.Class); 
            System.debug('::: MRO - '+mro);
            if(mro.DataArea.MessageDetails != null){  //Added null check by Prasanna for ROAD-371
                for(FSL_CL_MROMessageData.MessageDetails msgDetails: mro.DataArea.MessageDetails) {
                String priority;
                String messageId;
                String fullMessage;
                msgWrap = new messageWrapper();
                priority = msgDetails.Priority;
                messageId = msgDetails.messageId;
                String textMsg = '';
                for(FSL_CL_MROMessageData.TextDetails text : msgDetails.TextDetails) {
                    textMsg += ' '+ text.MessageText ;
                }
                fullMessage = textMsg;
                fullMessage = fullMessage.replaceAll('/B', ' ');
                msgWrap.priority = priority;
                msgWrap.messageID = messageId;
                msgWrap.message = fullMessage;
                messageList.add(msgWrap);
            }
            }
            
        } catch(Exception ex) {
            System.debug('::: Error in MRO Message Servive Call : ' + ex.getMessage());
            System.debug('::: Error in MRO Message Servive Call Error Stack: ' + ex.getStackTraceString());
            //System.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'MROMessages',res.getStatus(),'code','toolid',''));
            //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'MROMessages',res.getStatus(),'code','toolid','Guidanz',Null,'SiteCreateUpdate')); 
        }
        return messageList;
    }
    
    @AuraEnabled
    public static List<messageWrapper> getMROMessage(String serviceJob) {
        FSL_CL_MROMessageData mroMessageData;
        messageWrapper msgWrap;
        List<messageWrapper> messageList = new List<messageWrapper>();
        try {
            System.debug(':::MRO ServiceJob - '+serviceJob);
            //List<WorkOrder> workOrders = [Select Id, MRO_Messages__c From WorkOrder where Id =: serviceJob];
            List<ERP_Message__c> erpMsgList = [SELECT Id, Service_Order__c, Account_Change__c, Asset_Change__c, 
                                               Service_Territory_Change__c, MRO_Messages__c, MRO_Messages_Received__c 
                                               FROM ERP_Message__c WHERE Service_Order__c =: serviceJob AND MRO_Messages_Received__c = true];
            //String message = erpMsgList[0].MRO_Messages__c;
            System.debug('::: erpMsgList = '+erpMsgList);
            //String jsonString = message.unescapeHtml4();
            if(erpMsgList.isEmpty() || (!erpMsgList.isEmpty() && erpMsgList[0].Account_Change__c) ) { 
                System.debug('::: getMROMessageWebService ');
                messageList = getMROMessageWebService(serviceJob);
            } else {
                //MRO_Message is NULL - Exception is throwing
                String message = erpMsgList[0].MRO_Messages__c;
                mroMessageData = (FSL_CL_MROMessageData)JSON.deserialize(message.unescapeHtml4(), FSL_CL_MROMessageData.Class);
                system.debug('::: mroMessageData = '+mroMessageData);
                if(mroMessageData!=null && mroMessageData.DataArea!=null && mroMessageData.DataArea.MessageDetails!=null) 
                {
                    for(FSL_CL_MROMessageData.MessageDetails msgDetails: mroMessageData.DataArea.MessageDetails) { 
                        String priority;
                        String messageId;
                        String fullMessage;
                        msgWrap = new messageWrapper();
                        priority = msgDetails.Priority;
                        messageId = msgDetails.messageId;
                        String textMsg = '';
                        system.debug(':::msgDetails.TextDetails **'+msgDetails.TextDetails);
                        for(FSL_CL_MROMessageData.TextDetails text : msgDetails.TextDetails) {
                            textMsg += ' '+ text.MessageText ;
                        }
                        fullMessage = textMsg;   
                        fullMessage = fullMessage.replaceAll('/B', ' ');
                        msgWrap.priority = priority;
                        msgWrap.messageID = messageId;
                        msgWrap.message = fullMessage;
                        system.debug('mroMessageData***'+msgWrap);
                        messageList.add(msgWrap);
                    } 
                }
            }
        } catch(Exception ex) {
            System.debug('::: Error in fetching MRO Message : ' + ex.getMessage());
        }
        return messageList;  
    }
    
    public class messageWrapper {
        @AuraEnabled public String priority{get;set;}
        @AuraEnabled public String message{get;set;}
        @AuraEnabled public String messageID{get;set;}
    }
}