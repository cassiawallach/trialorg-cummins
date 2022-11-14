@isTest
public class CSS_WS_HistoricalFailuresController_test {
    public static testMethod void testGetFailures (){
        PageReference pageRef = Page.CSS_WS_HistoricalFailures;
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Engine_Serial_Number__c = '12345678'
        );
        insert claim;
        ApexPages.StandardController standardController = new ApexPages.StandardController(claim); 
        CSS_WS_HistoricalFailuresController controller = new CSS_WS_HistoricalFailuresController(standardController);  
        controller.getFailures();
    }
}