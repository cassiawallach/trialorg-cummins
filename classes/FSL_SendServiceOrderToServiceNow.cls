public class FSL_SendServiceOrderToServiceNow 
{
    @AuraEnabled public boolean incidentNocheck {public get;public set;}
    @AuraEnabled public list<Id> incidentIdLst = new list<Id>();
    @AuraEnabled public list<Incident> incidentLst = new list<Incident>();
    @AuraEnabled public String respMessage {public get;public set;}
    @AuraEnabled public String subject {public get;public set;}
    @AuraEnabled public String description {public get;public set;}
    @AuraEnabled public String responseType;
    
    public Static FSL_SendServiceOrderToServiceNow incidentCntrlObj =  new FSL_SendServiceOrderToServiceNow();
    // @InvocableMethod(label='Get service Request Names' description='Returns the list of service Request')
    @AuraEnabled
    //Added boolean IncidentAction to differentiate in the existing method
    public static FSL_SendServiceOrderToServiceNow sendCaseToServicenNowmethod(String incidentId,boolean IncidentAction,boolean incActionType){
        CG_IP_OAGWrapper reqWrapper = null;
        CG_IP_OAGWrapper requestWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        string accessToken;
        String reqJSON;
        HttpResponse httpRes;
        FSL_ServiceNowCreateNewResJSON textResp;
        FSL_SnowUpdateIncidentReqJson snowUpdatereqJson;
        FSL_SnowUpdateIncidentResJson snowUpdateresp;
        String endPointURL;
        try{
            
            reqWrapper = new CG_IP_OAGWrapper();
            String initiatorWWID;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            
            Incident incidentRec = [Select Id,  IncidentNumber, CSM_Case_Origin__c,CSM_Ticket_Incident_Number__c, CSM_Ticket_Work_Notes__c,CSM_Ticket_Incident_URL__c, CSM_Ticket_Short_Description__c,
                                    CSM_Ticket_FSL_Report_a_problem_comment__c, CSM_Ticket_Config_Item__c, Category, SubCategory,
                                    Impact, Urgency, Description, Status, CSM_Ticket_IncidentSysID__c,
                                    Service_Request__c,Service_Request__r.CaseNumber from Incident where Service_Request__c=:incidentId ORDER BY CSM_Ticket_Incident_Number__c DESC NULLS FIRST limit 1];
            
            
            if(incidentRec != null && incidentRec.CSM_Case_Origin__c != 'Web'){
                initiatorWWID = [SELECT MasterLabel,Service_Request_Origin__c, Initiator_wwid__c,SNOW_Assignment_Group__c FROM CSM_SNow_Initiator_wwid__mdt WHERE Service_Request_Origin__c =: incidentRec.CSM_Case_Origin__c]?.Initiator_wwid__c;
            }
            else{
                initiatorWWID = [SELECT FederationIdentifier from User where ID =: UserInfo.getUserId()].FederationIdentifier;
            }
            //Added by Guidanz Development Team from Offshore11-072022
            //string assignmentGroup=[SELECT MasterLabel,SNOW_Assignment_Group__c FROM CSM_SNow_Initiator_wwid__mdt WHERE MasterLabel =:incidentRec.CSM_Ticket_Config_Item__c]?.SNOW_Assignment_Group__c;
            // System.debug('assignmentGroup>>>>' +  assignmentGroup);
            string assignmentGroup;
            System.debug('incidentRec.CSM_Ticket_Config_Item__c>>>' + incidentRec.CSM_Ticket_Config_Item__c);
            if(incidentRec.CSM_Ticket_Config_Item__c == 'Marketplace / CSO Online Subscription Ma' ||  incidentRec.CSM_Ticket_Config_Item__c =='Marketplace / CSO Online Subscription Management Solution')
            {
                
                assignmentGroup =[SELECT MasterLabel,SNOW_Assignment_Group__c FROM CSM_SNow_Initiator_wwid__mdt WHERE MasterLabel =:incidentRec.CSM_Ticket_Config_Item__c]?.SNOW_Assignment_Group__c;
                System.debug('assignmentGroup>>>>' +  assignmentGroup);
                if(assignmentGroup == null){
                    assignmentGroup='Corporate IT - Customer Support Org (CSO) - Marketplace';
                }   
            }
            else
            {
                assignmentGroup=[SELECT MasterLabel,SNOW_Assignment_Group__c FROM CSM_SNow_Initiator_wwid__mdt WHERE MasterLabel =:incidentRec.CSM_Ticket_Config_Item__c]?.SNOW_Assignment_Group__c;
            }
            if(incActionType && !IncidentAction){
                String currentRequestURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + incidentId;
                System.debug('Current request URL: ' + currentRequestURL); 
                CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('FSL_ServiceNow').AuthEnv__c,'FSL_ServiceNow');
                system.debug('@@@ accessTokenOPWrap'+accessTokenOPWrap);
                accesstoken = accessTokenOPWrap.accessToken;
                string incDescription = String.isNotBlank(incidentRec.Description)? incidentRec.Description.replace('\n','\\n'):'';
                
                string jsonreq = '{"api-audit":{"initiator_application":"Guidanz","wwid":"ml237","request_date":"sysdate","application_email_group":"'+System.Label.Application_EmailGroup+'"},"initiator_wwid":"'+ initiatorWWID +'","config_item": "'+ incidentRec.CSM_Ticket_Config_Item__c +'","category":"'+ incidentRec.Category +'" ,"subcategory":"'+ incidentRec.SubCategory +'","impact":"'+incidentRec.Impact+'","urgency":"'+incidentRec.Urgency+'","contact_wwid":"ml237","preferred_contact_number":"9494573773","description":"'+ incDescription +'","assignment_group":"'+assignmentGroup+'","vendor_name":"Salesforce!","short_description":"'+ incidentRec.CSM_Ticket_Short_Description__c +'","vendor_ticket_number":"'+incidentRec.Service_Request__r.CaseNumber+'","work_group":"Infosys Support Group","third_party_system":"Cummins Salesforce - Service Org","ticket_number":"'+ incidentRec.IncidentNumber +'","ticket_url":"'+ currentRequestURL +'"}';
                conDetails=CSS_getConnnectionDetails.getConnection('FSL_ServiceNow');
               // jsonreq= JSON.serialize(jsonreq).replace('null','""');
                system.debug('Debug Connection');
                reqWrapper.jsonReqBody = jsonreq;
                system.debug('Debug jsonreq');
                reqWrapper.serviceName = 'FSL_ServiceNow';
                
                reqWrapper.methodType = conDetails.Method_Type__c;
                
                reqWrapper.endPoint = conDetails.End_Point__c;
                system.debug('reqWrapper=='+reqWrapper);
                if(jsonreq != null){
                    returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                    system.debug('Wrapper=='+returnWrapper);
                    
                }
                if(returnWrapper != null){
                    httpRes=new HttpResponse();
                    if(!Test.isRunningTest()){
                        httpRes = returnWrapper.response; 
                    }
                    else{                    
                        httpRes.setBody('{"result":{"Message":"Incident has been created successfully.","IncidentNumber":"INC0778666","Priority":"2 - High","IncidentSysID":"c91ba8371bff28d4a97e65386e4bcb96","Thirdparty":"","TicketNumber":"","TicketURL":"","URL":"https://cumminsdev.service-now.com/incident.do?sys_id=c91ba8371bff28d4a97e65386e4bcb96"}}');
                        httpres.setStatus('Success');
                        httpRes.setStatusCode(200);
                    }
                    system.debug('httpRes--'+httpRes);
                    
                    
                    if(httpRes != null && httpRes.getStatusCode() == 200){
                        textResp = (FSL_ServiceNowCreateNewResJSON)JSON.deserializeStrict(httpRes.getBody(), FSL_ServiceNowCreateNewResJSON.class);
                        incidentRec.CSM_Ticket_Incident_Number__c = textResp.result.IncidentNumber;
                        incidentRec.CSM_Ticket_IncidentSysID__c = textResp.result.IncidentSysID;
                        incidentRec.CSM_Ticket_Incident_URL__c = textResp.result.URL;
                        incidentRec.Status = 'New';
                        incidentRec.Service_Request__c=incidentId;
                        
                        incidentCntrlObj.respMessage = textResp.result.Message;
                        incidentCntrlObj.responseType='Success';
                        upsert incidentRec;//upsert
                        system.debug('@@@incidentRec'+ incidentRec);
                    }
                    else{
                        incidentCntrlObj.responseType='Error';
                        if( returnWrapper.errorResponse !=null){
                            incidentCntrlObj.respMessage = returnWrapper.errorResponse.returnCodeDescription;
                        } 
                        else {
                            incidentCntrlObj.respMessage = returnWrapper.errorMessage;   
                        }
                    }
                }
                
            }
            //added IncidentAction for the false
            else if(!incActionType &&!IncidentAction){
                //Update Incident Code:-
                System.debug('Update ticket Number'+ incidentRec.CSM_Ticket_Incident_Number__c);
                string IncidentNumber = incidentRec.CSM_Ticket_Incident_Number__c;
                CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('FSL_ServiceNowUpdate').AuthEnv__c,'FSL_ServiceNowUpdate');
                accesstoken = accessTokenOPWrap.accessToken;
                snowUpdatereqJson = new FSL_SnowUpdateIncidentReqJson();
                snowUpdatereqJson.comments = incidentRec.CSM_Ticket_FSL_Report_a_problem_comment__c;
                snowUpdatereqJson.work_notes = incidentRec.CSM_Ticket_Work_Notes__c;
                snowUpdatereqJson.impact = incidentRec.Impact;
                snowUpdatereqJson.urgency =(incidentRec.Urgency != null )? incidentRec.Urgency.left(1):null;
                snowUpdatereqJson.category = incidentRec.Category;
                snowUpdatereqJson.subcategory = incidentRec.SubCategory;
                snowUpdatereqJson.short_description = incidentRec.CSM_Ticket_Short_Description__c;
                string incDesc = String.isNotBlank(incidentRec.Description)? incidentRec.Description.replace('\n','\\n'):'';
                snowUpdatereqJson.description = incDesc;
                reqJSON=JSON.serialize(snowUpdatereqJson).replace('null','""');
                reqWrapper.jsonReqBody=reqJSON;
                conDetails=CSS_getConnnectionDetails.getConnection('FSL_ServiceNowUpdate');
                reqWrapper.serviceName = 'FSL_ServiceNowUpdate';
                reqWrapper.methodType = conDetails.Method_Type__c;
                endPointURL = conDetails.End_Point__c; 
                reqWrapper.endPoint = endPointURL+IncidentNumber;
                if(reqJSON != null){
                    returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                }
                if(returnWrapper != null){
                    httpRes=new HttpResponse();
                    if(!Test.isRunningTest()){
                        httpRes = returnWrapper.response; 
                    }
                    else{                    
                        httpRes.setBody('{"result":{"Message":"Incident has been updated successfully.","IncidentNumber":"INC0778666","URL":"https://cumminsdev.service-now.com/incident.do?sys_id=c91ba8371bff28d4a97e65386e4bcb96"}}');
                        httpres.setStatus('Success');
                        httpRes.setStatusCode(200);
                    }
                    system.debug('httpRes--'+httpRes);
                    
                    if(httpRes != null && httpRes.getStatusCode() == 200){
                        snowUpdateresp = (FSL_SnowUpdateIncidentResJson)JSON.deserializeStrict(httpRes.getBody(), FSL_SnowUpdateIncidentResJson.class);
                        incidentCntrlObj.respMessage = snowUpdateresp.result.Message;
                        incidentCntrlObj.responseType='Success';
                    }
                    else {
                        incidentCntrlObj.responseType='Error';
                        incidentCntrlObj.respMessage = returnWrapper.errorResponse.returnCodeDescription;
                    }
                }
            }
            //New changes start
            else if(incidentRec.CSM_Ticket_Incident_Number__c != null && IncidentAction){
                system.debug('Inside attachments');
                boolean calloutcheck=false;
                string incidentNo = incidentRec.CSM_Ticket_Incident_Number__c;
                set<Id> contentDocIdSet = new set<Id>();
                for(ContentDocumentLink conlink:[SELECT LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:incidentId]){
                    contentDocIdSet.add(conlink.ContentDocumentId);
                }
                list<ContentVersion> conversionList = [SELECT Id,IsLatest,VersionNumber from ContentVersion where ContentDocumentId IN: contentDocIdSet];
                conDetails=CSS_getConnnectionDetails.getConnection('FSL_ServiceNowAttachmentId');
                for(integer i=0;i<conversionList.size();i++){
                    requestWrapper = new CG_IP_OAGWrapper();
                    JSONGenerator JsonreqGen = JSON.createGenerator(true);
                    JsonreqGen.writeStartObject();
                    JsonreqGen.writeStringField('IncidentNumber',incidentNo);
                    JsonreqGen.writeFieldName('AttachmentId');
                    JsonreqGen.writeString(conversionList[i].Id);  
                    JsonreqGen.writeEndObject();
                    string jsonRequest = JsonreqGen.getAsString();
                    requestWrapper.jsonReqBody=jsonRequest;
                    requestWrapper.serviceName = 'FSL_ServiceNowAttachmentId';
                    requestWrapper.methodType = conDetails.Method_Type__c;
                    requestWrapper.endPoint =conDetails.End_Point__c;
                    if(jsonRequest != null){
                        returnWrapper = CG_WS_Mule.calloutGenericMule(requestWrapper);//create a list of return type wrapper class and if any of it status code is not 201 throw error
                        system.debug('returnWrapper=='+returnWrapper);
                        if( returnWrapper != null){
                            if( returnWrapper.response.getStatusCode() == 201 ){
                                incidentCntrlObj.respMessage='Attachments are successfully sent to Service Now Incident.'; 
                                incidentCntrlObj.responseType='Success';
                            }
                            else {
                                incidentCntrlObj.respMessage=returnWrapper.response.getStatus();
                                incidentCntrlObj.responseType='Error';
                            }
                        } 
                    }
                }
                
                
            }
            //changes end
        }
        catch(exception e){
            incidentCntrlObj.responseType='Error';
            incidentCntrlObj.respMessage =e.getMessage();
            system.debug('Exception Ocuured at line number '+ e.getLineNumber()+' due to '+e.getMessage());
            return incidentCntrlObj;
        }
        system.debug('incidentCntrlObj.respMessage==='+incidentCntrlObj);
        return incidentCntrlObj;
    }
    @AuraEnabled(cacheable=true)
    public static Incident incidentRecords(String incidentId){
        
        Incident incidentRec = [Select Id, CSM_Case_Origin__c, IncidentNumber, CSM_Ticket_Incident_URL__c, CSM_Ticket_Short_Description__c, CSM_Ticket_FSL_Report_a_problem_comment__c, CSM_Ticket_Config_Item__c, Category, SubCategory, Impact, Urgency, Description, CSM_Ticket_IncidentSysID__c, CSM_Ticket_Incident_Number__c from Incident where id=:incidentId];
        return incidentRec;
        
        
        
    }
    //Added new method
    //Added new method
    @AuraEnabled
    public static Boolean checkIncidentNo(String caseId){
        
        incidentCntrlObj.incidentNocheck=false;
        if(string.isNotBlank(caseId)){
            list<Incident> incidentRecLst=[SELECT Id,Type,CSM_Ticket_Incident_Number__c,Subject,Priority,Service_Request__c from Incident where Service_Request__c=:caseId];
            if( incidentRecLst != null && !incidentRecLst.isEmpty() ){
                incidentCntrlObj.incidentNocheck=true;
            }
        }
        system.debug('incidentCntrlObj'+incidentCntrlObj);
        // return incidentCntrlObj;
        return incidentCntrlObj.incidentNocheck;
        
    }
    //Added new method 
    @AuraEnabled
    public static FSL_SendServiceOrderToServiceNow checkIncidentRecord(String caseId){
        
        incidentCntrlObj.incidentNocheck=false;
        if(string.isNotBlank(caseId)){
            list<Incident> incidentRecLst=[SELECT Id,Type,CSM_Ticket_Incident_Number__c,Subject,Priority,Service_Request__c from Incident where Service_Request__c=:caseId];
            if( incidentRecLst != null && !incidentRecLst.isEmpty() ){
                if(incidentRecLst.size() > 1){
                    incidentCntrlObj.incidentLst.addAll(incidentRecLst);                    
                }
                if(incidentRecLst.size() == 1){
                    incidentCntrlObj.incidentLst.addAll(incidentRecLst);  
                    incidentCntrlObj.incidentIdLst.add(incidentRecLst[0].id);   
                }
            }
        }
        system.debug('incidentCntrlObj'+incidentCntrlObj);
        return incidentCntrlObj;
        
        
    }
    
    @AuraEnabled
    public static FSL_SendServiceOrderToServiceNow populateIncidentFiled(String caseId){
        Case caseRec= [SELECT Id,Description,Subject FROM Case WHERE Id=:caseId LIMIT 1];
        system.debug('caseRec'+caseRec);
        incidentCntrlObj.subject =caseRec.Subject;
        incidentCntrlObj.description = caseRec.Description;
        //incidentCntrlObj.description =String.isNotBlank(caseRec.Description)? caseRec.Description.replace('\n',' '):'';
        system.debug('incidentCntrlObj'+incidentCntrlObj);
        return incidentCntrlObj;
    }
    
    @AuraEnabled public static boolean checkAttachment(String incidentId){
        List<ContentDocumentLink> ContentDocumentLinkList=[SELECT LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:incidentId];
        return ContentDocumentLinkList.isEmpty()?false:true;
    }
    @AuraEnabled public static CSM_IncidentSNOWUpdateController.responseWrapper getIncidentStatus(String recordId){
        return CSM_IncidentSNOWUpdateController.getIncidentStatus(recordId);
    }   
    
}