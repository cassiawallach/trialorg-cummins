/**********************************************************************
Name:CSS_SiebelSendClaimStatusInbound
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get Adjudicator response and Claim Status from Siebel #133403                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -   Rajkumar BT      04/09/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
@RestResource(urlMapping='/Siebel/V01/CSS/SiebelSendClaimStatusToGuidanz/*')

global with sharing class CSS_SiebelSendClaimStatusInbound {
    @HttpPut
    global static void insertSiebelClaimsData(){
        String JSONResponseBody;
        String wsESN;
        String ServiceJobLocation = '';
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Note> lstNotesinsert = new List<Note>();
        List<Note> queryNotes = new List<Note>();
        Map<String, Id> mapNotesId = new Map<String, Id>();
        res.addHeader('Content-Type', 'application/json');
        String jsonRequestBody;
        jSONRequestBody = req.requestBody.toString().trim(); 
        CSS_Claim_Submission__c claimSubRec = new CSS_Claim_Submission__c();
        //Set<String> fedIds = new Set<String>();
        //List<User> userid = new List<User>();
        //Map<String,Id> userFedIdMap = new Map<String,Id>();
        try
        {
            CSS_SiebelSendClaimStatus_Req_Json sendClaimStatusReq = (CSS_SiebelSendClaimStatus_Req_Json)JSON.deserializeStrict(jsonRequestBody, CSS_SiebelSendClaimStatus_Req_Json.class);
            System.debug('===> Request' + sendClaimStatusReq);
            //Fetch the Claim from Salesforce based on the parameter passed on the URL
            //CSS_Claims__c claimRec = [SELECT Id, Name FROM CSS_Claims__c WHERE Name =: sendClaimStatusReq.DataArea.GuidanzClaimNumber];
            claimSubRec = [select Id,Name, isPendingResponse__c from CSS_Claim_Submission__c where Individual_Claim_Id__c = :sendClaimStatusReq.DataArea.GuidanzClaimNumber];
            /* if(claimRec !=null)
            claimSubRec = [Select Id, Name, CSS_Claims__c from CSS_Claim_Submission__c where css_claims__c =: claimRec.Id];
            */
            //System.debug('===> Claim' + claimRec);
            if(claimSubRec != null){
                queryNotes = [SELECT Id, Body FROM Note WHERE ParentId =: claimSubRec.Id];
                if(queryNotes != null){
                    for(Note notelst: queryNotes){
                        List<String> tempStrList = new List<String>();
                        if(notelst.Body != null)
                            tempStrList = (notelst.Body).split(';;');
                        if(tempStrList != null){
                            if(!mapNotesId.containsKey(tempStrList[0])){
                                mapNotesId.put(tempStrList[0], notelst.Id);        
                            }
                        }
                    }
                }
                system.debug('mapNotesId--'+mapNotesId);
                system.debug('Data Area--'+sendClaimStatusReq.DataArea.NoteDetails);
                /*for(CSS_SiebelSendClaimStatus_Req_Json.NoteDetail dArea : sendClaimStatusReq.DataArea.NoteDetails){
                    if(!fedIds.contains(dArea.UserID)){
                        fedIds.add(dArea.UserID);
                    }
                }
                userid = [SELECT Id, FederationIdentifier FROM User WHERE FederationIdentifier=:fedIds];
                for(User u : userid){
                    if(!userFedIdMap.containsKey(u.FederationIdentifier))
                        userFedIdMap.put(u.FederationIdentifier, u.Id);
                }*/
                for(CSS_SiebelSendClaimStatus_Req_Json.NoteDetail dArea : sendClaimStatusReq.DataArea.NoteDetails){
                    Note noteRec = new Note();
                    //Note noteRec1 = new Note();
                    system.debug('dArea.RowId>>>>>>>>>'+dArea.RowId);
                    if(mapNotesId.containsKey(dArea.RowId)){
                        /*system.debug('Inside IF');
                        Id tempId = mapNotesId.get(dArea.RowId);
                        noteRec.Title = dArea.NoteType;
                        noteRec.Body = dArea.RowId + ';;' + dArea.LastUpdateDate + ';;' + dArea.CreatedDate + ';;' +dArea.Note;
                        noteRec.ParentId = claimRec.Id;
                        noteRec.Id = tempId;
                        */
                        Id tempId = mapNotesId.get(dArea.RowId);
                        noteRec.Title = dArea.NoteType+' - Adjudicator Note';
                        noteRec.Body = dArea.RowId + ';;' + dArea.LastUpdateDate + ';;' + dArea.CreatedDate + ';;' +dArea.Note + ';;' +dArea.FirstName + ';;' +dArea.LastName + ';;' +dArea.UserID;
                        noteRec.ParentId = claimSubRec.Id;
                        noteRec.Id = tempId;
                        //if(userFedIdMap != null && userFedIdMap.get(dArea.UserID) != null)
                      //      noteRec.LastModifiedById = userFedIdMap.get(dArea.UserID);
                    }
                    else{
                        /*system.debug('Inside Else');
                        noteRec.Title = dArea.NoteType;
                        noteRec.Body = dArea.RowId + ';;' + dArea.LastUpdateDate + ';;' + dArea.CreatedDate + ';;' +dArea.Note;
                        noteRec.ParentId = claimRec.Id;
                        */
                        noteRec.Title = dArea.NoteType+' - Adjudicator Note';
                        noteRec.Body = dArea.RowId + ';;' + dArea.LastUpdateDate + ';;' + dArea.CreatedDate + ';;' +dArea.Note + ';;' +dArea.FirstName + ';;' +dArea.LastName + ';;' +dArea.UserID;
                        noteRec.ParentId = claimSubRec.Id;
                        //if(userFedIdMap != null && userFedIdMap.get(dArea.UserID) != null)
                        //    noteRec.LastModifiedById = userFedIdMap.get(dArea.UserID);
                    }
                    lstNotesinsert.add(noteRec);

                    System.debug('===>lstNotesinsert' + lstNotesinsert);
                }
                if(lstNotesinsert.size() > 0){
                    upsert lstNotesinsert;
                    JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"Notes and Status details have been updated successfully"}}';
                }
                if(claimSubRec !=null && lstNotesinsert!=null && lstNotesinsert.size() > 0){
                    claimSubRec.isPendingResponse__c = true;
                    update claimSubRec;
                }
                System.debug('===>JSONResponseBody' + JSONResponseBody);
            }
        }
        catch(Exception e){
            if(e.getTypeName() == 'System.JSONException'){
                JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"Invalid JSON Schema"}}';
                // insIntegrationError(JSONResponseBody, 'Invalid JSON. Notify INSITE.',jsonRequestBody);
            }
            else
            {
                JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"Internal Error Occurred"}}';                
                // insIntegrationError(JSONResponseBody, 'CSS Error:' + e.getMessage(),jsonRequestBody);
            }
            System.debug('In Catch block with the message '+e.getmessage()+' and in the line '+e.getLineNumber());
        }
        System.debug('===>JSONResponseBody' +JSONResponseBody);
        res.responseBody = Blob.valueOf(JSONResponseBody);
    }
} 

/* global static void insIntegrationError(string errDesc, string sysError, string reqMsg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + errDesc;
        errObj.Source__c = 'BMS Delete';
        errObj.Processed_Data__c = reqMsg;
        insert errObj;
    }*/