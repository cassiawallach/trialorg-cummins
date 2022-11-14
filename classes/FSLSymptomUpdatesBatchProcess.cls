/**********************************************************************
Name: FSLSymptomUpdatesBatchProcess
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the symptomBatchProcess, were we updating the all the symptoms through the Batch.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/ 
global class FSLSymptomUpdatesBatchProcess implements Database.batchable<FSLSymptomRespWrapper>,Database.AllowsCallouts,Database.Stateful
{
    global String tokenStr;
    global String query;
    
    /*STARTS -- START METHOD*/
    global Iterable<FSLSymptomRespWrapper> start(Database.BatchableContext BC)
    {
        system.debug('*****************START METHOD**********************');
        return new FSLSymptomsRespIterable(); //FSLSymptomsGenerator; //Database.getQueryLocator(query);
    }
    /*ENDS -- START METHOD*/
    /*STARTS -- EXECUTE METHOD*/
    global void execute(Database.BatchableContext info, List<FSLSymptomRespWrapper> scope)
    {
        system.debug('*****************START METHOD:::::::::::::::STARTS**********************');
        system.debug('scope.size');
        system.debug('query::'+scope.size());
        Set<String> cdsIdsSet = new Set<String>();
        for(FSLSymptomRespWrapper fsr : scope)
        {
            cdsIdsSet.add(fsr.id);
        }
        if(cdsIdsSet.size()>0)
        {
            Map<String,FSL_Symptom__c> sympsMap = new Map<String, FSL_Symptom__c>();
            for(FSL_Symptom__c fs : Database.query('Select '+ FSL_CumminsUtilities.queryStringFromFieldSet('FSL_Symptom__c', 'FSLSymptomBatch') +
                                                   ' From FSL_Symptom__c where CDS_ID__c in :cdsIdsSet'))
            {
                sympsMap.put(fs.CDS_ID__c, fs);
            }
            FSL_Symptom__c tempFS;
            List<FSL_Symptom__c> fsToUpsert = new List<FSL_Symptom__c>();
            for(FSLSymptomRespWrapper fsr : scope)
            {
                //changed the IF conditions to incldue the business unit value to read only engine realted records.
                //String.isNotBlank(fsr.BusinessUnit) && fsr.BusinessUnit == 'Engine' &&
                if(String.isNotBlank(fsr.id) && String.isNotBlank(fsr.cds_highlevelcategoryId))
                {
                    tempFS = new FSL_Symptom__c();
                    if(sympsMap.size() > 0 && sympsMap.containsKey(fsr.id))
                    {
                        tempFS.Id = sympsMap.get(fsr.id).Id;
                    }
                    tempFS.CDS_ID__c = fsr.ID;
                    tempFS.Name = fsr.ID;
                    tempFS.Symptom__c = fsr.Name; 
                    tempFS.Business_Unit__c = fsr.BusinessUnit; // Added this Part for the CT2-98: As a Guidanz user, I need the symptoms to be filtered to show only the required business unitIN DEVELOPMENT 
                    tempFS.Status__c = fsr.Status;
                    tempFS.Symptom_Category__c = fsr.cds_highlevelcategory; 
                    tempFS.CreatedBy__c = fsr.CreatedBy;
                    tempFS.LanguageKey__c = fsr.LanguageKey;
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