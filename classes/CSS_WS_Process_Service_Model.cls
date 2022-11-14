Global Class CSS_WS_Process_Service_Model implements Schedulable{
    
    Public Static String CRON_EXP = '0 0 23 ? * MON-FRI';
    
    Global Void execute(SchedulableContext ctx) {    
        processServiceModel();
    }
    
    @future(callout = true) 
    Public Static Void processServiceModel(){        

        try{
            Map<String, String> Data = new Map<String,String>{};
            Data.put('LastRunDate',datetime.now().addDays(-1).format('yyyy-MM-dd')); //LastRunDate is a day before
            //Data.put('LastRunDate','2019-01-18'); //LastRunDate using an specific date
            Data.put('LangCode','en'); //LangCode

            CSS_WS_J2A_GetServiceModel service_model = CSS_WS_GetWebServiceData.getServiceModel(Data);
            if(service_model != null){
                if(service_model.Header.Status.touppercase()=='SUCCESS') {
                    if(service_model.DataArea != null){
                        if(service_model.DataArea.EquipmentData != null){
                            integer total = service_model.DataArea.EquipmentData.size();
                            Map<String, CSS_WS_Make_And_Model__c> make_and_model_map = new Map<String, CSS_WS_Make_And_Model__c>();
                            for(Integer i = 0; i < total; i++){                                                                 
                                CSS_WS_Make_And_Model__c make_and_model =  new CSS_WS_Make_And_Model__c();
                                make_and_model.CSS_WS_Status__c = service_model.DataArea.EquipmentData[i].Status;
                                make_and_model.CSS_WS_Configuration__c = service_model.DataArea.EquipmentData[i].Configuration;
                                make_and_model.CSS_WS_Engine_Family_Code__c = service_model.DataArea.EquipmentData[i].EngineFamilyCode;
                                make_and_model.CSS_WS_Equipment_Id__c = service_model.DataArea.EquipmentData[i].EquipmentId;
                                make_and_model.CSS_WS_Model__c = service_model.DataArea.EquipmentData[i].Model;
                                make_and_model.CSS_WS_Access_Code__c = service_model.DataArea.EquipmentData[i].AccessCode;
                                make_and_model.CSS_WS_Make__c = service_model.DataArea.EquipmentData[i].Make;
                                make_and_model.CSS_WS_Application_Category__c = service_model.DataArea.EquipmentData[i].ApplicationCategory;
                                make_and_model.name = service_model.DataArea.EquipmentData[i].EngineFamilyCode + '-' + service_model.DataArea.EquipmentData[i].EquipmentId;
                                make_and_model.CSS_WS_Unique_Id__c = service_model.DataArea.EquipmentData[i].Make + '-' + service_model.DataArea.EquipmentData[i].Model + '-' + service_model.DataArea.EquipmentData[i].EngineFamilyCode + '-' + service_model.DataArea.EquipmentData[i].EquipmentId;
                                make_and_model_map.put(make_and_model.CSS_WS_Unique_Id__c, make_and_model);
                            }
                            //system.debug('Lista de Make and Model: '+ make_and_model_map);
                            upsert make_and_model_map.values() CSS_WS_Unique_Id__c;  
                        }                                       
                    }
                    System.debug('GetServiceModel webservice is responding with SUCCESS status: ' + service_model.Header.ReturnCodeDescription);
                } else {
                    System.debug('GetServiceModel webservice is responding with ERROR status: ' + service_model.Header.ReturnCodeDescription);
                }
            } else {
                system.debug('GetServiceModel webservice is not responding');
            }
        } catch(System.Exception e){
            System.debug('Error getting GetServiceModel (exception): '+e.getMessage());
        }
    }
}