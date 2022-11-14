/**********************************************************************
Name:FSLSMNDTCBatchProcess
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                              
-------  
This class is used for the update or the SMNDTC Batch.
======================================================
======================================================
History                                               
-------                                               
VERSION  AUTHOR            DATE                DETAIL 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT             
***********************************************************************/

global class FSLSMNDTCBatchProcess implements Database.batchable<FSLSMNDTCRespWrapper>, Database.AllowsCallouts, Database.Stateful
{
    global String tokenStr;
    global String query;
    /*STARTS -- START METHOD*/
    global Iterable<FSLSMNDTCRespWrapper> start(Database.BatchableContext BC)
    {
        system.debug('*****************START METHOD**********************');
        return new FSLSMNDTCRespIterable();                                        //Database.getQueryLocator(query);
    }
    /*ENDS -- START METHOD*/
    /*STARTS -- EXECUTE METHOD*/
    global void execute(Database.BatchableContext info, List<FSLSMNDTCRespWrapper> scope)
    {
        system.debug('*****************START METHOD:::::::::::::::STARTS**********************');
        system.debug('query::'+scope.size());
        Set<String> cdsIdsSet = new Set<String>();
        for(FSLSMNDTCRespWrapper fsr : scope)
        {
            cdsIdsSet.add(fsr.id);
        }
        if(cdsIdsSet.size() > 0)
        {
            FSL_SMN_DTC__c tempFS;
            List<FSL_SMN_DTC__c> fsToUpsert = new List<FSL_SMN_DTC__c>();
            Map<String,FSL_SMN_DTC__c> smndtcMap = new Map<String, FSL_SMN_DTC__c>();
            for(FSL_SMN_DTC__c fs : Database.query('Select Id, CDSID__c '+ 
                                                   ' From FSL_SMN_DTC__c where CDSID__c in :cdsIdsSet'))
            {
                smndtcMap.put(fs.CDSID__c, fs);
            }
            for(FSLSMNDTCRespWrapper fsr : scope)
            {
                if(String.isNotBlank(fsr.id) )
                {
                    tempFS = new FSL_SMN_DTC__c();
                    if(smndtcMap.size() > 0 && smndtcMap.containsKey(fsr.id))
                    {
                        tempFS.Id = smndtcMap.get(fsr.id).Id;
                    }
                    tempFS.CDSID__c = fsr.ID;
                    tempFS.Name = fsr.Name;
                    tempFS.BusinessUnit__c = fsr.BusinessUnit;
                    tempFS.FaultTypeFC__c = fsr.FaultTypeFC;
                    tempFS.FaultTypeSPNFMI__c = fsr.FaultTypeSPNFMI;
                    tempFS.FaultTypePCode__c = fsr.FaultTypePCode;
                    tempFS.Status__c = fsr.Status;
                    tempFS.FaultTypeSPNFMI__c=fsr.FaultTypeSPNFMI;
                    tempFS.CreatedBy__c = fsr.CreatedBy;
                    fsToUpsert.add(tempFS);
                }
            }
            system.debug('fsToUpsert::'+fsToUpsert);
            if(fsToUpsert.size() > 0) {
                upsert fsToUpsert;
            }
            system.debug('*****************EXECUTE METHOD::::::::::::::::::::ENDS**********************');
        }
    }
    /*ENDS -- EXECUTE METHOD*/
    /*STARTS -- FINISH METHOD*/
    global void finish(Database.BatchableContext info){
        system.debug('*****************FINISH METHOD**********************');
    }
    /*ENDS -- FINISH METHOD*/    
}