/*****************************************************************************************************************************
Name : FSL_TSBHyperlinkcontrollers 
Description : This is Class is used to get TSB and insert in to Css_campTsbtrps object. when we click on hyperlink on the UI.

Version                 Date                    Author                             Summary Of Change
-------------------------------------------------------------------------------------------------------------------------------                  
1.0                   08/03/2019                Ravikanth Macherla                      Inserting TSB and showing on 
2.0                   08/03/2019                 Ravikanth Macherla                     Performing Audit trail action 
3.0                   00/03/2019                 Dinesh Yadav                           Replace field 'FSL_URL__c' with field 'URL__c' 
*******************************************************************************************************************************/
public class FSL_TSBHyperlinkcontrollers {
       
    @AuraEnabled
    public static TSBsWrapper getAccountRecords(Integer initialRows,string strservicejobid){
        system.debug('strservicejobid--->'+strservicejobid);
        TSBsWrapper objwrap= new TSBsWrapper();
        try{
            objwrap.TSBsList = [SELECT Id, Name, Doc_Num__c, Doc_Title__c, URL__c FROM CSS_CampTsbTrp__c where FSL_ServiceJob__c=:strservicejobid AND Type__c='TSB'  LIMIT :initialRows OFFSET 0];
            objwrap.totalRecords = [SELECT COUNT() FROM CSS_CampTsbTrp__c where FSL_ServiceJob__c=:strservicejobid AND Type__c='TSB'];
            objwrap.message = 'TSB records are loaded';
            objwrap.success = true;
        }
        catch(Exception e){
            objwrap.message = e.getMessage();
            objwrap.success = false;
        }
        return objwrap; 
    
    }
    
    //To return additional records based on offset
    @AuraEnabled
    public static List<CSS_CampTsbTrp__c> loadAccountRecords(Integer rowLimit,Integer rowOffset,string strservicejobid){
        system.debug('loadd---->'+strservicejobid );
        return [SELECT Id, Name, Doc_Num__c, Doc_Title__c, URL__c FROM CSS_CampTsbTrp__c where FSL_ServiceJob__c=:strservicejobid AND Type__c='TSB'  LIMIT :rowLimit OFFSET :rowOffset];
    }
    
    // wrapper class
    public class TSBsWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<CSS_CampTsbTrp__c> TSBsList = new List<CSS_CampTsbTrp__c>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
    }
    
    @AuraEnabled
    public static void TSBviewed(string serviceorderId){
        FSL_CumminsUtilities.auditTrailInsert('Event-09',serviceorderId,'','','','');//added by ravikanth to get audit trail when action is performed on the TSB
    }
}