public class FSL_CommunicationTextEmail {
    @AuraEnabled
    public static List<String> fetchEmailTextData(Id woId){
        try{
            
          workorder woData = new workOrder();
          woData = [SELECT Id,FSL_Additional_Email_Notifications__c,
                    FSL_Additional_Text_Notifications__c,Payer__r.Language_Preference__c 
                    FROM WorkOrder WHERE Id =: woId];
            system.debug('** Data'+woData); 
            
            
            return new List<String>{woData.FSL_Additional_Email_Notifications__c,woData.FSL_Additional_Text_Notifications__c};    
                }catch(Exception e){
                  system.debug('** error'+e.getMessage());  
                  return null;
                }
    }
    
  /*  @AuraEnabled
    public static String fetchLanguagePref(Id woId){
        
        try{
          workorder woData = new workOrder();
          String langPreferences;
          woData = [SELECT Id,Payer__r.Language_Preference__c 
                    FROM WorkOrder WHERE Id =: woId];
            
            if((woData.Language_Preferences__c == '' || woData.Language_Preferences__c != null)  && (woData.Payer__r.Language_Preference__c == '' && woData.Payer__r.Language_Preference__c == null)){
               // langPreferences = null;
            }else if(woData.Language_Preferences__c != null && woData.Language_Preferences__c != ''){
               langPreferences = String.valueOf(woData.Language_Preferences__c);
            }else if(woData.Payer__r.Language_Preference__c != null && woData.Payer__r.Language_Preference__c != ''){
                langPreferences = String.valueOf(woData.Payer__r.Language_Preference__c);
            }
            return langPreferences;
        }catch(Exception E){
            system.debug('** Error '+e.getMessage());
            return null;
        }
        
    }*/
    
    @AuraEnabled
    public static Boolean saveEmailTextData(Id woId, String EmailInfo, String TextInfo){
        try{
            workOrder woInfo = new workOrder(Id = woId, FSL_Additional_Email_Notifications__c = EmailInfo, FSL_Additional_Text_Notifications__c = TextInfo);        
            update woInfo;
            system.debug('** Information'+woInfo);
            return true;
        }catch(System.Exception e){
            return false;
        }
    }
    
  /*  @AuraEnabled
    public static List<String> getLangPref(){
        
        Map<String, String> options = new Map<String, String>();
        List<String> langValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = WorkOrder.Language_Preferences__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            langValues.add(p.getValue());
        }
        return langValues;
    }*/
    
    
}