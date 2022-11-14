/**********************************************************************
Name: FSLMakeModelBatch
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is batch class it is used to send Make and Model values from Guidanz to Siebel 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         07/30/2019                         
***********************************************************************/
global class FSLMakeModelBatch implements Database.batchable<sobject>,Database.AllowsCallouts,Database.Stateful {
    
    list<FSL_MakeModelResWrap> FSL_MakeModelWrap = new list<FSL_MakeModelResWrap>();
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Manufacturer__c,ModelSeries__c,ProductApplicationCode__c,PSN__c,Type__c,VIN__c FROM FSL_MakeModel_Stage__c ';
       
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext info, List<FSL_MakeModel_Stage__c> scope) { 
        system.debug('scope--->'+scope);
        if(Scope.size()>0){
           FSL_MakeModelWrap = FSL_CL_MakeModelUpdateService.exposeMakemodel(scope);
            
        }
       
    }
    
    public void finish(Database.BatchableContext info){
        system.debug('test---->'+FSL_MakeModelWrap);
        // if(FSL_MakeModelWrap.DataArea !=null && FSL_MakeModelWrap.Header !=null){
      /*  for(FSL_MakeModelResWrap objMResWrapOut : FSL_MakeModelWrap){
            // for(FSL_MakeModelResWrap.Header  objMResWrap : objMResWrapOut.Header){
            system.debug('check'+objMResWrapOut.DataArea);
            if( objMResWrapOut.DataArea!=null ){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'ravikanth.macherla@cummins.com'};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Make Model Status: ' +objMResWrapOut.Header.Status);
                mail.setPlainTextBody(objMResWrapOut.Header.ReturnCodeDescription);
                system.debug('check email'+mail);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } 
            // if(objMResWrapOut.Header.Status == 'Success'){
            
            // }
            // }
        } */
    } 
    // } 
}