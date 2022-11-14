public class FSL_cssp_customersupportController {
    
   //Rajesh Added 
    @AuraEnabled
    public static FSL_Cummins_Care_Number__mdt getMetaData(String country){ 
        FSL_Cummins_Care_Number__mdt metaData = new FSL_Cummins_Care_Number__mdt();
        
        for(FSL_Cummins_Care_Number__mdt meta:[SELECT DeveloperName,MasterLabel,
                                               Cummins_Care_Numbers__c,
                                               ActiveCheck__c,
                                               Asia_and_Europe__c
                                               FROM FSL_Cummins_Care_Number__mdt 
                                               WHERE ActiveCheck__c = true]){
                                                   if(meta.MasterLabel == country){
                                                       metaData = meta;                                                     
                                                       break;
                                                   }
                                               }
        return metaData;
    }
    
   /* @AuraEnabled
    public static String getLocaleSidKeyLabal(){
        User oUser = [select LocaleSidKey FROM User Where id =: userInfo.getUserId()];
        String localeSidKeyLabel;
        for(PicklistEntry value: User.LocaleSidKey.getDescribe().getPicklistValues()) {
            if(value.getValue() == oUser.LocaleSidKey) {
                localeSidKeyLabel = value.getLabel();
                break;
            }
        } 
        
        return localeSidKeyLabel;
    }*/
    

    
    /*@AuraEnabled
    public static List<FSL_Cummins_Care_Number__mdt> queryAllMetrics(){        
        List<FSL_Cummins_Care_Number__mdt> allMetrics = 
            [SELECT DeveloperName,MasterLabel,
             Cummins_Care_Numbers__c,
             ActiveCheck__c 
             FROM FSL_Cummins_Care_Number__mdt 
             WHERE ActiveCheck__c = true];
        return allMetrics;
    }
    
    @AuraEnabled 
    public static String getLocaleSidKey (){
        // query current user information  
        User oUser = [select LocaleSidKey FROM User Where id =: userInfo.getUserId()];
        String localeSidKey;
        for(PicklistEntry value: User.LocaleSidKey.getDescribe().getPicklistValues()) {
            if(value.getValue() == oUser.LocaleSidKey) {
                localeSidKey = value.getLabel();
                break;
            }
        }
        return localeSidKey;
    }*/
    //Prabhakar Added below method
    @AuraEnabled 
    public static user fetchUser(){
      User loggedUser = [select id,Name,ERP__c,Address 
                 FROM User Where id =: userInfo.getUserId()];
        return loggedUser;
    }
}