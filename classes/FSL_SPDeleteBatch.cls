/************************************************************************************************************************************
HISTROY

VERSION  AUTHOR                      DATE                DETAILS                                 
1.0 - Anvesh Reddy Sama          05/01/2020      These batch is used to delete older than last 1 week unprocessed records from staging objects
************************************************************************************************************************************/
//pushing through Git Testing
global class FSL_SPDeleteBatch implements Database.Batchable<string>, Database.Stateful  {
global boolean bReRun = false; 
global Iterable<string> start(Database.BatchableContext ctx) {
system.debug('Start Method');  
return new list<String> { 'FSL_SPHeader_Stage__c', 'FSL_SPCertifications_Stage__c','FSL_SPCertDetails_Stage__c','FSL_SPAffilations_Stage__c','FSL_SPTechCert_Stage__c', 'FSL_SPTechnicians_Stage__c'}; //list of strings with stage object names
    }
global void execute(Database.BatchableContext ctx, list<string> lstsObjectName) {
try{
    system.debug('lstsObjectName ' +lstsObjectName); 
    list<sObject> lstDeleteRecords = new list<sObject>();
    for(string strObjectName : lstsObjectName) {
        for(sObject objsObject : database.query('Select Id,createdDate from '+ strObjectName +' where createdDate < LAST_WEEK LIMIT 45000')) {
                system.debug('objsObject ' + objsObject);
            if(lstDeleteRecords.size() <  200*(11 - lstsObjectName.size()) + lstsObjectName.size())
                lstDeleteRecords.add(objsObject);
            else {
                bReRun = true;
                break;
            }
        }
    }
    system.debug('lstDeleteRecords ' + lstDeleteRecords);
    system.debug('Size oflstDeleteRecords ' + lstDeleteRecords.size());
    lstDeleteRecords.sort();
    delete lstDeleteRecords;
}
catch(Exception e)  {
    system.debug('EXCEPTION of FSL_SPDelteBatch execute e.getMessage>>> '+e.getMessage() + ' e.getLineNumber ' + e.getLineNumber() + ' getCause ' +e.getCause());
    css_utility.LogOutIntError('FSL_SPDelteBatch', e.getMessage() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSL_SPDelteBatch');
}
}
global void finish(Database.BatchableContext ctx) {
if(bReRun) {
    Database.executebatch(new FSL_SPDeleteBatch());
}
system.debug('Finish method Executed Successfully');
}
}