public class CSS_WS_HistoricalFailuresController {
    
    Public CSS_WS_Warranty__c claim { get; set; }
    List<CSS_WS_Failure__c> failures {get; set;} 
    
    public CSS_WS_HistoricalFailuresController(ApexPages.StandardController stdController){
        if(!test.isRunningTest()){
            if(ApexPages.currentPage().getUrl().indexOf('CSS_WS_HistoricalFailures') > -1 ){
                stdController.addFields(new List <String> {'CSS_WS_Engine_Serial_Number__c'});
            }
            this.claim = (CSS_WS_Warranty__c)stdController.getRecord();
        }
  
        System.debug(failures);
    }
    

    public List<CSS_WS_Failure__c> getFailures (){
        List<CSS_WS_Warranty__c> warranties = new List<CSS_WS_Warranty__c>();
        if(failures == null){
            try{
                failures = [
                SELECT Id, CSS_WS_Warranty__r.CSS_WS_Failure_Date_Time__c, CSS_WS_Warranty__r.CSS_WS_Claim_Number__c, CSS_WS_Warranty__r.CSS_WS_Account_Code__c ,
                CSS_WS_Warranty__r.CSS_WS_Failure_Measure__c, CSS_WS_Warranty__c, CSS_WS_Warranty__r.CSS_WS_Failure_Point_Quantity__c, 
                CSS_WS_Warranty__r.CSS_WS_Service_Provider_Name_Dealer__c , CSS_WS_Failure_Name__c, CSS_WS_Warranty__r.CSS_WS_Claim_Status__c
                FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c IN (
                    SELECT Id FROM CSS_WS_Warranty__c WHERE CSS_WS_Engine_Serial_Number__c = :this.claim.CSS_WS_Engine_Serial_Number__c AND Id != :this.claim.Id AND CSS_WS_Claim_Status__c != 'Draft' AND CSS_WS_Claim_Status__c != 'Canceled'
                ) ORDER BY CSS_WS_Warranty__r.CSS_WS_Failure_Date_Time__c DESC];
            } catch (Exception e){
                System.debug('Error '+e.getMessage());
            }
            
        }
        return failures;
    }
}