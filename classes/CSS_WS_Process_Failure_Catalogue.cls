Global Class CSS_WS_Process_Failure_Catalogue implements Schedulable{
    
    Public Static String CRON_EXP = '0 0 5 ? * MON-FRI';
    
    Global Void execute(SchedulableContext ctx) {    
        processFailureCatalogue();
    }
    
    @future(callout = true) 
    Public Static Void processFailureCatalogue(){        

        try{
            String LAST_PROCESSED_DATE = datetime.now().addDays(-1).format('yyyy-MM-dd'); //LastProcessedDate is a day before

            CSS_WS_J2A_GetFailCodes failure_response = CSS_WS_GetWebServiceData.getFailCodes(LAST_PROCESSED_DATE);
            if(failure_response != null){
                if(failure_response.Header.Status.touppercase()=='SUCCESS') {
                    if(failure_response.DataArea != null){
                        if(failure_response.DataArea.Details != null){
                            integer total = failure_response.DataArea.Details.size();
                            Map<String, CSS_WS_Failure_Master__c> failure_master_code_map = new Map<String, CSS_WS_Failure_Master__c>();
                            for(Integer i = 0; i < total; i++){                                                                 
                                if(failure_response.DataArea.Details[i].Active == 'Y'){
                                    CSS_WS_Failure_Master__c failure_code =  new CSS_WS_Failure_Master__c();
                                    failure_code.Engine_Component_Code__c = failure_response.DataArea.Details[i].ComponentCode;
                                    failure_code.Engine_Component_Code_Description__c = failure_response.DataArea.Details[i].ComponentName;
                                    failure_code.Engine_Family_Code__c = failure_response.DataArea.Details[i].ServiceGroupCode;
                                    failure_code.Engine_System_Code__c = failure_response.DataArea.Details[i].SystemCode;
                                    failure_code.Engine_System_Code_Description__c = failure_response.DataArea.Details[i].SystemName;
                                    failure_code.CSS_WS_Unique_Id__c = failure_response.DataArea.Details[i].ServiceGroupCode + '-' + failure_response.DataArea.Details[i].SystemCode + '-' + failure_response.DataArea.Details[i].ComponentCode;
                                    failure_code.Name = failure_response.DataArea.Details[i].ServiceGroupCode + '-' + failure_response.DataArea.Details[i].SystemCode + '-' + failure_response.DataArea.Details[i].ComponentCode;
                                    failure_master_code_map.put(failure_code.CSS_WS_Unique_Id__c, failure_code);
                                }
                            }
                            //system.debug('Lista de Failure Master Codes: '+ failure_master_code_map);
                            upsert failure_master_code_map.values() CSS_WS_Unique_Id__c;  
                        }                                       
                    }
                    System.debug('GetFailCodes webservice is responding with SUCCESS status: ' + failure_response.Header.ReturnCodeDescription);
                } else {
                    System.debug('GetFailCodes webservice is responding with ERROR status: ' + failure_response.Header.ReturnCodeDescription);
                }
            } else {
                system.debug('GetFailCodes webservice is not responding');
            }
        } catch(System.Exception e){
            System.debug('Error getting GetFailCodes (exception): '+e.getMessage());
        }
    }
}