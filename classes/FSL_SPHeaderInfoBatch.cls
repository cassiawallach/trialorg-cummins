/************************************************************************************************************************************
HISTROY

VERSION  AUTHOR            	          DATE                DETAILS                                 
1.0 - Anvesh Reddy Sama          	03/25/2020			fetching staging Object of FSL_SPHeader_Stage__c and convert into Account object.
************************************************************************************************************************************/
global class FSL_SPHeaderInfoBatch implements Database.Batchable <sObject>, Database.allowscallouts{

    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select id, AccountStatus__c,BusinessUnit__c,CampaignTRP__c,CertificationEndDate__c,City__c,ClaimAllowedDays__c,CMISPExpirationDate__c,CommunicationMethod__c,CommunicationOccurrence__c,CostEffectiveExclusion__c,Country__c,CreatedDate__c,CutOffClaimAmt__c,DisableWebAccessFlag__c,DistHQCode__c,DistHQName__c,DSID__c,DTNAFlag__c,FreezeSubmitButton__c,GroupName__c,LTAFlag__c,MaxClaimAmt__c,NewOEM__c,OutFileAllClaims__c,PACCAR__c,PMUSplitPayment__c,Policy__c,PrimaryOEMCode__c,PrimaryOEMName__c,ProductCertificationFlag__c,PromotionId__c,PromotionIdFlag__c,PSBUProductCertification__c,Region__c,RegionCode__c,RepairLevel__c,RespBranchCode__c,RespBranchName__c,RSSRespBranchName__c,SCMDeductible__c,SCMDollarAmt__c,SPBillToCode__c,SPBillToName__c,SPChannelCode__c,SPChannelOfDistribution__c,SPCode__c,SPEmail__c,SPFirstName__c,SPLastName__c, SPRecertificationDate__c,SPRow_Id__c,State__c,StreetAddress1__c,StreetAddress2__c,StreetAddress3__c,StreetAddress4__c,TechActualHoursRequired__c,Territory__c,TerritoryCode__c,UpdatedDate__c,ViewDollarAmount__c,WarrantyEmail__c,WarrantyFax__c,WarrantyTrainingStatus__c,WrntyTrainingCertification__c,WWSPSFlag__c,ZipPostalCode__c FROM FSL_SPHeader_Stage__c WHERE FailureReason__c = null ORDER BY lastmodifieddate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<FSL_SPHeader_Stage__c> Scope){   
        try {
            if(Scope != null && Scope.size() > 0) {
				System.debug('<----- inside CG_GetSPHeaderInfoBatchExecute ------>');
        		FSLSPInfo.getSPHeaderInfoData(Scope);
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSL_SPHeaderInfoBatch execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSL_SPHeaderInfoBatch', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSL_SPHeaderInfoBatch');
        }
    } 

    global void finish(Database.BatchableContext BC){
         system.debug('Finish Method executed');
       /* List<FSL_SPHeader_Stage__c> SPHData = [SELECT Id FROM FSL_SPHeader_Stage__c WHERE FailureReason__c = null];   //40
        if(SPHData != null && SPHData.size() > 0) {
            try {
                FSL_SPHeaderInfoBatch SchdBatch = new FSL_SPHeaderInfoBatch();
            	System.scheduleBatch (SchdBatch,'FSL_SPHeaderInfoBatch1', 5 ); 
            } catch(exception e) {
                 system.debug('message and line number>>'+e.getMessage()+'and '+e.getLineNumber());
            }
        }*/
    }

}