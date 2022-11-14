/********************************************
HISTROY

VERSION  AUTHOR            DATE                DETAILS                                 
2.0 - Rajesh Narra      05/17/2019             Modified CSS_DealerCode with IAM_Service_Provider_Code__c as per the IAM Changes
2.1 - Krishnamoorthi 	08/14/2019			   Updating IMS claim Number from Staging object to Claim submission object based on Story #190067.

********************************************/

global class CG_SPClaimHistoryBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        //Updating Query based on Story #190067.
        string query = 'SELECT Id, FailureReason__c, ClaimCreatedDate__c,ClaimStatus__c,ClaimSubmittedDate__c, CustomerName__c,FailureDate__c,LastUpdatedBy__c,LastUpdatedDate__c, PartiallyPaidFlag__c,PSN__c,SiebelClaimNumber__c,SourceSystemName__c,SPCode__c,SPName__c,WarrantyStartDate__c,WorkOrderNumber__c, IMS_Claim_Number__c FROM CG_StgSPClaimHistory__c WHERE FailureReason__c = null ORDER BY lastmodifieddate LIMIT 50';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<CG_StgSPClaimHistory__c> Scope){   
        try {

            system.debug('Scope ' + Scope);
            list<CG_StgSPClaimHistory__c> updateSPClaimHistoryList = new list<CG_StgSPClaimHistory__c>();
            list<CG_StgSPClaimHistory__c> deleteSPClaimHistoryList = new list<CG_StgSPClaimHistory__c>();

            List<CSS_PSN__c> updatePSNList   = new List<CSS_PSN__c>();
            List<CSS_Claim_Submission__c> updateCSList = new List<CSS_Claim_Submission__c>();
            List<CSS_Claims__c>  updateClaimsList = new List<CSS_Claims__c>();
            
            List<CSS_PSN__c>  DeletePSNList = new List<CSS_PSN__c>();	//GSSC-245 By Krishna
            List<CSS_Claim_Submission__c> DeleteCSList = new List<CSS_Claim_Submission__c>();	//GSSC-245 By Krishna
            List<CSS_Claims__c>  DeleteClaimsList = new List<CSS_Claims__c>();	//GSSC-245 By Krishna
            
            List<CSS_PSN__c> existingPSNList   = new List<CSS_PSN__c>();
            Map<string,Id> existingSiebelPSNMap = new Map<string,Id>();
            List<CSS_Claim_Submission__c> existingCSList = new List<CSS_Claim_Submission__c>();
            Map<string,Id> existingSiebelCSMap = new Map<string,Id>();
            List<CSS_Claims__c>  existingClaimsList = new List<CSS_Claims__c>();
            Map<string,Id> existingSiebelClaimsMap = new Map<string,Id>();

            List<Account>  accountlist = new List<Account>();
            Map<string,CG_StgSPClaimHistory__c> siebelStageRecordMap = new Map<string,CG_StgSPClaimHistory__c>();
            Map<string,Account> dealerAccountIdMap = new Map<string,Account>();
            Map<string,Id> siebelClaimIdMap = new Map<string,Id>();
            Set<String> dealerCodeSet = new Set<String>();

            List<Group> existingQueueList   = new List<Group>();
            set<string> locationCodeQueueSet = new set<string>();
            set<string> locationCodeEXISTINGQueueSet = new set<string>();
            set<string> locationCodeNEWQueueSet = new set<string>();
            //Map<string,string> dealerAccountQueueMap = new Map<string,string>();
            

            for(CG_StgSPClaimHistory__c spclaimhist : Scope){
                siebelStageRecordMap.put(spclaimhist.SiebelClaimNumber__c, spclaimhist);          
                system.debug('siebelStageRecordMap ' + siebelStageRecordMap);
                dealerCodeSet.add(spclaimhist.SPCode__c);
                system.debug('dealerCodeSet ' + dealerCodeSet);
            }

            accountlist = [select id, Name,  location__c, IAM_Service_Provider_Code__c from account where IAM_Service_Provider_Code__c=:dealerCodeSet];
            system.debug('accountlist ' + accountlist);
            for(account acc : accountlist){
                dealerAccountIdMap.put(acc.IAM_Service_Provider_Code__c, acc);
                locationCodeQueueSet.add('CQ' + '-' + acc.location__c);
                //dealerAccountQueueMap.put(acc.IAM_Service_Provider_Code__c, 'CQ' + '-' + acc.location__c);
            }

            existingQueueList = [select id, Name from Group where Type='queue' AND Name IN: locationCodeQueueSet];
            for(Group existqueue : existingQueueList) {
                locationCodeEXISTINGQueueSet.add(existqueue.Name);
            }

            /*for(string AllLocationCodes : locationCodeQueueSet){
                if(!locationCodeEXISTINGQueueSet.contains(AllLocationCodes))
                    locationCodeNEWQueueSet.add(AllLocationCodes);
            }*/

            existingPSNList = [select Id, PSN__c, Siebel_Claim_No__c from CSS_PSN__c where Siebel_Claim_No__c =: siebelStageRecordMap.keyset()];
            system.debug('existingPSNList ' + existingPSNList);
            for(CSS_PSN__c psn : existingPSNList){
                existingSiebelPSNMap.put(psn.Siebel_Claim_No__c, psn.Id);
            }

            existingCSList = [select Id, Siebel_Claim_Number__c from CSS_Claim_Submission__c where Siebel_Claim_Number__c =: siebelStageRecordMap.keyset()];
            system.debug('existingCSList ' + existingCSList);
            for(CSS_Claim_Submission__c cs : existingCSList){
                existingSiebelCSMap.put(cs.Siebel_Claim_Number__c, cs.Id);
            }

            existingClaimsList = [select Id, SiebelClaimNumber__c from CSS_Claims__c where SiebelClaimNumber__c =: siebelStageRecordMap.keyset()];
            system.debug('existingClaimsList ' + existingClaimsList);
            for(CSS_Claims__c claim : existingClaimsList){
                existingSiebelClaimsMap.put(claim.SiebelClaimNumber__c, claim.Id);
            }

            for(CG_StgSPClaimHistory__c spclaimhist : Scope){

                CSS_Claims__c claims = new CSS_Claims__c();

                claims.Status__c= 'Submitted';
                claims.SiebelClaimNumber__c=spclaimhist.SiebelClaimNumber__c;
                claims.Claim_Submitted__c=spclaimhist.ClaimSubmittedDate__c;
                claims.Customer_Name__c=spclaimhist.CustomerName__c;
                claims.Shop_Work_Order__c=spclaimhist.WorkOrderNumber__c;
				claims.LastSavedDate__c = DateTime.Now();	//GSSC-245 By Krishna
                claims.Last_saved_by__c = 'Warranty System Admin';	//GSSC-245 By Krishna
                claims.ID = existingSiebelClaimsMap.get(spclaimhist.SiebelClaimNumber__c);
                if(claims.ID == null) {
                    claims.createddate = spclaimhist.ClaimCreatedDate__c;
                }

                if(spclaimhist.SPCode__c != null && spclaimhist.SPCode__c != '') {
                    Account acc = dealerAccountIdMap.get(spclaimhist.SPCode__c);
                    if(acc != null) {
                        claims.Account__c = acc.Id;
                        claims.Location_Code__c = acc.location__c;
                        claims.Location__c = acc.Name;
                        string queueLocationCode = 'CQ' + '-' + acc.location__c;
                        if(locationCodeEXISTINGQueueSet.contains(queueLocationCode)) {
                            //START GSSC-245 By Krishna
                            if(spclaimhist.ClaimStatus__c != null && spclaimhist.ClaimStatus__c != '' && spclaimhist.ClaimStatus__c != 'Void') {
                            	updateClaimsList.add(claims); 
                            } else {
                                if(claims.ID != null) {
                                	DeleteClaimsList.add(claims);
                                }
                            }
                            //END GSSC-245 By Krishna
                            deleteSPClaimHistoryList.add(spclaimhist);
                        } else {
                            spclaimhist.FailureReason__c = 'No Queues Available';
                            updateSPClaimHistoryList.add(spclaimhist);
                        }                     
                    } else {
                        spclaimhist.FailureReason__c = 'No Account and Queues Available';
                        updateSPClaimHistoryList.add(spclaimhist);
                    }
                }     
            }

            /*
            List<QueueSobject> newQueueSobject = new List<QueueSobject>();
            List<Group> newQueue = new List<Group>();
            if(locationCodeNEWQueueSet != null && locationCodeNEWQueueSet.size() >0) {
                for(string CL : locationCodeNEWQueueSet) {
                    Group newGroup =  new Group();
                    newGroup.Type = 'queue';
                    newGroup.Name = CL;
                    newQueue.add(newGroup);
                }
            }

            if(newQueue != null && newQueue.size() > 0)
                //upsert newQueue;
                system.debug('newQueue Final ' + newQueue);

            for(Group Qsobject : newQueue){
                QueueSobject sObjRec = new QueueSobject();
                sObjRec.QueueId = Qsobject.Id;
                sObjRec.SobjectType = 'CSS_Claims__c';
                newQueueSobject.add(sObjRec);
            }

            if(newQueueSobject != null && newQueueSobject.size()>0)
                //upsert newQueueSobject;
                system.debug('newQueueSobject Final ' + newQueueSobject);
            */
            
            if(updateClaimsList != null && updateClaimsList.size() > 0)
                upsert updateClaimsList;
            system.debug('updateClaimsList Final ' + updateClaimsList);

            for(CSS_Claims__c claim : updateClaimsList){
                siebelClaimIdMap.put(claim.SiebelClaimNumber__c, claim.Id);
            }

            for(CG_StgSPClaimHistory__c spclaimhist : Scope){
                CSS_PSN__c psn = new CSS_PSN__c();

                psn.CSS_Claims__c = siebelClaimIdMap.get(spclaimhist.SiebelClaimNumber__c);   
                psn.Failure_Date__c=spclaimhist.FailureDate__c;
                psn.PSN__c=spclaimhist.PSN__c;
                psn.Warranty_Start_Date__c=spclaimhist.WarrantyStartDate__c; 
                psn.ID = existingSiebelPSNMap.get(spclaimhist.SiebelClaimNumber__c);
                psn.Primary__c = true;
                if(psn.CSS_Claims__c != null) {
                    //START GSSC-245 By Krishna
                    if(spclaimhist.ClaimStatus__c != null && spclaimhist.ClaimStatus__c != '' && spclaimhist.ClaimStatus__c != 'Void') {
                        updatePSNList.add(psn);
                    } else {
                        if(psn.ID!= null) 
                            DeletePSNList.add(psn);
                    }
                    //END GSSC-245 By Krishna
                    
                }
                CSS_Claim_Submission__c claimSubmission = new CSS_Claim_Submission__c();
                if(spclaimhist.ClaimStatus__c != null && spclaimhist.ClaimStatus__c != '') {
                    if(spclaimhist.ClaimStatus__c == 'Admin Outfile' || spclaimhist.ClaimStatus__c == 'Draft' || spclaimhist.ClaimStatus__c == 'In Review' || 
                       spclaimhist.ClaimStatus__c == 'Marked For Payment' || spclaimhist.ClaimStatus__c == 'System Error' || spclaimhist.ClaimStatus__c == 'Submitted For Payment')
                        claimSubmission.Status__c = 'In Review'; 
                    else if(spclaimhist.ClaimStatus__c == 'Denied')
                        claimSubmission.Status__c = 'Denied';  
                    else if(spclaimhist.ClaimStatus__c == 'Info Only')
                        claimSubmission.Status__c = 'Information Only';  
                    else if(spclaimhist.ClaimStatus__c == 'Paid')
                        claimSubmission.Status__c = 'Paid';  
                }
                claimSubmission.Siebel_Claim_Number__c=spclaimhist.SiebelClaimNumber__c;
                //claimSubmission.Individual_Claim_Id__c = '01';
                claimSubmission.LastUpdatedDate__c=spclaimhist.LastUpdatedDate__c;
                //claimSubmission.LastUpdatedBy__c=spclaimhist.LastUpdatedBy__c;
                claimSubmission.SourceSystemName__c=spclaimhist.SourceSystemName__c;
                claimSubmission.PartiallyPaidFlag__c=spclaimhist.PartiallyPaidFlag__c;
                claimSubmission.Credit_Date__c = spclaimhist.ClaimSubmittedDate__c;	//Story : #190067.
                claimSubmission.IMS_Claim_Number__c = spclaimhist.IMS_Claim_Number__c;	//Story : #190067.
                claimSubmission.CSS_Claims__c = siebelClaimIdMap.get(spclaimhist.SiebelClaimNumber__c);
                claimSubmission.ID = existingSiebelCSMap.get(spclaimhist.SiebelClaimNumber__c);
                claimSubmission.SiebelPaymentReceived__c = true;
                if(claimSubmission.CSS_Claims__c != null) {
                    //START GSSC-245 By Krishna
                    if(spclaimhist.ClaimStatus__c != null && spclaimhist.ClaimStatus__c != '' && spclaimhist.ClaimStatus__c != 'Void') {
                        updateCSList.add(claimSubmission);
                    } else {
                        if(claimSubmission.ID != null)
                            DeleteCSList.add(claimSubmission);
                    }
                    //END GSSC-245 By Krishna
                    
                }
            }

            if(updatePSNList != null && updatePSNList.size() > 0)
                upsert updatePSNList;
            system.debug('updatePSNList Final ' + updatePSNList);

            if(updateCSList != null && updateCSList.size() > 0)
                upsert updateCSList;
            system.debug('updateCSList Final ' + updateCSList);

            system.debug('updateSPClaimHistoryList Final ' + updateSPClaimHistoryList);
            if(updateSPClaimHistoryList != null && updateSPClaimHistoryList.size() >0)
                update updateSPClaimHistoryList;

            system.debug('deleteSPClaimHistoryList Final ' + deleteSPClaimHistoryList);
            if(deleteSPClaimHistoryList != null && deleteSPClaimHistoryList.size() >0)
                delete deleteSPClaimHistoryList;
            
            //START GSSC-245 By Krishna
            system.debug('DeleteClaimsList Final ' + DeleteClaimsList);
            if(DeleteClaimsList != null && DeleteClaimsList.size() >0)
                delete DeleteClaimsList;
            
            system.debug('DeleteCSList Final ' + DeleteCSList);
            if(DeleteCSList != null && DeleteCSList.size() >0)
                delete DeleteCSList;
            
            system.debug('DeletePSNList Final ' + DeletePSNList);
            if(DeletePSNList != null && DeletePSNList.size() >0)
                delete DeletePSNList;
            
            //END GSSC-245 By Krishna

        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_SPClaimHistoryBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('CG_SPClaimHistoryBatch', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'SP Siebel Batch');
        }
    } 

    global void finish(Database.BatchableContext BC){
        //Removing unwanted Query fields. Story : #190067.
        List<CG_StgSPClaimHistory__c> CSSCSC = [SELECT Id FROM CG_StgSPClaimHistory__c WHERE FailureReason__c = null];   //40
        if(CSSCSC != null && CSSCSC.size() > 0) {
            try {
                CG_SPClaimHistoryBatch  SchdBatch = new CG_SPClaimHistoryBatch();
            System.scheduleBatch (SchdBatch,'submissionSPClaimHistBatchSchedule', 5 ); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }
    }

}