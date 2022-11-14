@isTest
public class CSS_WS_Trigger_Rescue_Log_Test{
    static testMethod void TestTrigger(){
        CSS_WS_Rescue__c Rescue = new CSS_WS_Rescue__c(
            CSS_WS_RescueStatus__c = 'Pending Planta Review');       
        insert Rescue;
        
        CSS_WS_Rescue__c Rescue2 = new CSS_WS_Rescue__c(
            CSS_WS_RescueStatus__c = 'Rejected by Planta');       
        insert Rescue2;
    }
}