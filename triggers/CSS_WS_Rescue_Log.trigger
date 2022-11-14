trigger CSS_WS_Rescue_Log on CSS_WS_Rescue__c (before insert) {
    for (CSS_WS_Rescue__c  record: Trigger.new){ 
        if(Trigger.isBefore){
            if (record.CSS_WS_RescueStatus__c == 'Pending Planta Review') {
                record.CSS_WS_Date_Dealer__c = System.Today();
            }
            if (record.CSS_WS_RescueStatus__c == 'Authorized by Planta' || record.CSS_WS_RescueStatus__c == 'Rejected by Planta') {
                record.CSS_WS_Date_Rev_Plant__c = System.Today();
                
            }
        }
    }  
}