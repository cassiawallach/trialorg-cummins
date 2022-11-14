public class FSL_SendServiceOrderTextCommunication {
    
    public FSL_SendServiceOrderTextCommunication(){ 
        
    }   
    
    @InvocableMethod(label='SendTextCommunication' description='sends sms' category='WorkOrder')
    public static void sendSOTextCommunication(List<ID> SOIds){
        List<Service_Order_Communication__c> socList = new List<Service_Order_Communication__c>();
         List<ServiceOrderContact__c> servOrderCont = new List<ServiceOrderContact__c>();
        Set<Id> socIds=new Set<Id>();
        FSL_TextNotificationReq textReqJson;
        String reqJSON;
        
        try{
            if(SOIds != null){
                for(Id soc :SOIds){
                   socIds.add(soc); 
                }            
            }
            if(socIds != null){
                socList=[select id, Action__c, Address__c, Communication_SMS_Status__c, Communication_Trigger_Name__c, ERP__c, Event_Type__c, 
                         From_Address__c, Language__c, Make__c, Model__c, Notification_Body__c, Notification_Unique_Id__c, Phone_Number__c, Product_Serial_Number__c, 
                         Service_Order__c, Service_Order__r.WorkOrderNumber, Service_Request__c, Service_Status__c, Sms_Multiple_Phone_Numbers__c, Status__c, 
                         Target_Phone_Number__c, Unit__c, VIN__c from Service_Order_Communication__c where Service_order__c =: SOIds[0] and Action__c='sms' and Communication_SMS_Status__c = false];
                         
                //servOrderCont=[select id,Service_Order__c,Text_SMS_Notification_Frequency__c from ServiceOrderContact__c where Service_Order__c=: socList[0].Service_Order__c];
                
            }
            system.debug('socList***'+socList);
            if(socList != null){
                for(Integer i=0;i<socList.size();i++){
                    //if(servOrderCont[0].Text_SMS_Notification_Frequency__c!='Never/Unsubscribed')
                    //{
                    textReqJson = new FSL_TextNotificationReq();
                    FSL_TextNotificationReq.Header headerObj = new FSL_TextNotificationReq.Header();
                    FSL_TextNotificationReq.Target targetObj = new FSL_TextNotificationReq.Target();
                    FSL_TextNotificationReq.DataArea dataAreaObj = new FSL_TextNotificationReq.DataArea();
                    FSL_TextNotificationReq.Source sourceObj = new FSL_TextNotificationReq.Source();            
                    FSL_TextNotificationReq.BranchContact branchObj = new FSL_TextNotificationReq.BranchContact();
                    FSL_TextNotificationReq.AssetDetails assetObj = new FSL_TextNotificationReq.AssetDetails();
                    system.debug('** Target Number '+socList[i].Target_Phone_Number__c);
                    targetObj.TargetPhoneNumber =socList[i].Target_Phone_Number__c;
                    
                    branchObj.Address=socList[i].Address__c;
                    branchObj.PhoneNumber=socList[i].Phone_Number__c;
                    
                    assetObj.Unit=socList[i].Unit__c;
                    assetObj.Make=socList[i].Make__c;
                    assetObj.Model=socList[i].Model__c;
                    assetObj.ProductSerialNumber=socList[i].Product_Serial_Number__c;
                    assetObj.VIN=socList[i].VIN__c;
                    
                    sourceObj.SenderID='Guidanz';
                    sourceObj.FromEmailAddress=socList[i].From_Address__c;
                    
                    headerObj.Language=socList[i].Language__c;
                    headerObj.Action=socList[i].Action__c;
                    headerObj.EventType=socList[i].Event_Type__c;
                    headerObj.Source=sourceObj;
                    headerObj.Target=targetObj;
                    
                    dataAreaObj.ServiceStatus=socList[i].Service_Status__c;
                    dataAreaObj.WorkOrderNumber=socList[i].Service_Order__r.WorkOrderNumber;
                    dataAreaObj.BranchContact=branchObj;
                    dataAreaObj.AssetDetails=assetObj;
                    dataAreaObj.NotificationSubject = 'Cummins Service Update';
                    textReqJson.Header = headerObj;
                    textReqJson.DataArea = dataAreaObj;            
                    
                    reqJSON=JSON.serialize(textReqJson).replace('null','""');
                    
                    //if(!System.isFuture()){
                     sendTextCommfuturemethod(reqJSON,socList[i].Id); 
                    //} 
                 //}             
                }  
                
                    WorkOrder SO = new WorkOrder();
                    SO.ID = SOIds[0];
                    SO.Invoice_Ready_Text_Communication__c = false;
                    System.debug('in sendSOTextCommunication of FSL_SendServiceOrderTextCommunication SO.Type__c:'+SO.Type__c);
                    
                    if(SO.Type__c != null && SO.Type__c !='Dealer')
                    update SO;
                    
                    updateWOIASNumber(SOIds[0]);
                
            }
        }
        catch(exception e){
            system.debug('Entered into catch block of sendSOTextCommunication method in FSL_SendServiceOrderTextCommunication class' + e.getMessage() + ' ' + e.getLineNumber());
        }
        
    }
    
    @future
    public static void updateWOIASNumber(Id woRecId){
        WorkOrder wo = new WorkOrder();
        wo.ID = woRecId;
        wo.IAS_Number_Populated__c = false;
        system.debug('WOType:::'+wo.Type__c);
        if(wo.Type__c != null && wo.Type__c != 'Dealer'){
            update wo;
            
        }
    }
    
    @future(callout=true)
    public static void sendTextCommfuturemethod(String reqJSON,Id socIds){
       
        List<Service_Order_Communication__c> socData = new List<Service_Order_Communication__c>();
        List<Service_Order_Communication__c> socSuccFailLst = new List<Service_Order_Communication__c>();
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        string accessToken;
        string statusSoc;
        string messageTypeResult;
        HttpResponse httpRes;
        FSL_TextNotificationRespJSON textResp;
        
        if(socIds != null){
            socData = [SELECT Id,Name FROM Service_Order_Communication__c WHERE Id =: socIds];
        }
        
        try{
            reqWrapper = new CG_IP_OAGWrapper();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('FSL_TextNotification').AuthEnv__c,'FSL_TextNotification');
            accesstoken = accessTokenOPWrap.accessToken;
            conDetails=CSS_getConnnectionDetails.getConnection('FSL_TextNotification');
            reqWrapper.jsonReqBody=reqJSON;
            reqWrapper.serviceName = 'FSL_TextNotification';
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.endPoint = conDetails.End_Point__c;
            if(reqJSON != null){
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }
            if(returnWrapper != null){
                httpRes=new HttpResponse();
                if(!Test.isRunningTest()){
                   httpRes = returnWrapper.response; 
                }
                else{                    
                    httpRes.setBody('{"CustCommunicationResp": [{"MessageIdentifier": "2-17881040-d0c1-11ea-ab89-02c39419982e","ReturnCode": "sms","ReturnCodeDescription": "SMS sent successfully to +13304027474","Status": "SUCCESS","MessageType": "S"}]}');
                    httpres.setStatus('Success');
                    httpRes.setStatusCode(200);
                }                
                system.debug('httpRes--'+httpRes);
                if(httpRes != null)
                    textResp = (FSL_TextNotificationRespJSON)JSON.deserializeStrict(httpRes.getBody(), FSL_TextNotificationRespJSON.class);
                system.debug('**textResp**'+textResp);
                
                if(textResp != null && textResp.CustCommunicationResp.size()>0 && httpRes.getStatusCode() == 200){
                    
                    for(FSL_TextNotificationRespJSON.CustCommunicationResp  successandfailureRes : textResp.CustCommunicationResp){
                        
                        if(statusSoc != null && statusSoc != ''){
                           // socSuccessFailure.put('SUCCESS',String.valueOf(successandfailureRes.ReturnCodeDescription));
                            statusSoc += statusSoc+'  '+String.valueOf(successandfailureRes.ReturnCodeDescription);
                            messageTypeResult += messageTypeResult+String.valueOf(successandfailureRes.MessageType);
                        }else{
                            //socSuccessFailure.put('FAILURE',String.valueOf(successandfailureRes.ReturnCodeDescription));
                            statusSoc = String.valueOf(successandfailureRes.ReturnCodeDescription);
                            messageTypeResult  = String.valueOf(successandfailureRes.MessageType);
                        }
                    }
                    
                  if(string.isNotBlank(statusSoc) && socData.size() >0 && socData != null){
                        
                      Service_Order_Communication__c socSuccFail = new Service_Order_Communication__c();
                        socSuccFail.id = socData[0].Id;
                        socSuccFail.Response_Body__c = statusSoc;
                        socSuccFail.Status__c = messageTypeResult.contains('E')?'Failed':'Sent';
                        socSuccFail.Communication_SMS_Status__c = true;
                        socSuccFailLst.add(socSuccFail);
                    }
                    
                    if(socSuccFailLst != null && socSuccFailLst.size() > 0){
                        update socSuccFailLst;
                    }
                }else if(httpRes.getStatusCode() != 200){
                    try{
                        FSL_ApplicationLogger.insertFSLIntegrationErrorLog(String.valueOf(reqWrapper),String.valueOf(returnWrapper),'SMS','Failure','First','Mule','Guidanz');
                    }catch(Exception e){
                        system.debug('** error '+e.getMessage());
                    }
                }
                
                
            }
            
        }
        catch(Exception e){
            system.debug('Entered into catch block of sendTextCommfuturemethod method in FSL_SendServiceOrderTextCommunication class' + e.getMessage() + ' ' + e.getLineNumber());
        } 
    }
    
    

}