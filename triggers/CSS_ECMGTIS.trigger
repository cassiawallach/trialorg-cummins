trigger CSS_ECMGTIS on CSS_ECM__c (after insert){ 
    //****************** This is for GUIDANZ*******************/
    boolean guidanzFlag = false;
    for(CSS_ECM__c ecm : Trigger.New) {
        if(ecm.Job_Order__c != null) {
            guidanzFlag = true;
            break;
        }
    }  
    //****************** This is for GUIDANZ*******************/ 
    if(guidanzFlag) {
        
        if(trigger.isInsert){
            
            List<CSS_ECM__c> ecmLst = Trigger.new;
            
            List<Id> joIds = New List<Id>();
            integer messageType ;
            System.debug('calling Trigger');
            
            for(CSS_ECM__c ecm:ecmLst){
                
                if(ecm.ECM_Number__c==0 && (ecm.CORE__c == 'GTIS_20'|| ecm.CORE__c == 'PREGTIS' || ecm.CORE__c == 'Unknown')){
                    
                    joIds.add(ecm.Job_Order__c);
                    messageType = 1;
                    CSS_TndRepOverController.UpdateGTIS(joIds,messageType);                
                }
                else if(ecm.ECM_Number__c==0 && ecm.CORE__c == 'GTIS_38'){
                    
                    joIds.add (ecm.Job_Order__c);
                    messageType = 2 ;
                    CSS_TndRepOverController.UpdateGTIS(joIds,messageType);                
                }            
            } 
        }
    }
}