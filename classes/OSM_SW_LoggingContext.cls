/************************************************************
Name:  OSM_SW_LoggingContext
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is utility class that will upsert integration log record.
It will get paramters from respective business class.              
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            18/04/2018     INITIAL DEVELOPMENT          

*************************************************************/

public class OSM_SW_LoggingContext {

    public static OSM_Integration_Log__c integrationLog {get;set;}  //Getter setter for integration log
    
     public static OSM_Integration_Log__c saveIntegrationLog(OSM_Integration_Log__c integrationLogNew){
        if(integrationLogNew != null){   
            
            if(integrationLogNew.Error_Description__c!=null && integrationLogNew.Error_Description__c.length()>32700){
               System.debug('Error_Description Length:'+integrationLogNew.Error_Description__c.length());
               integrationLogNew.Error_Description__c= integrationLogNew.Error_Description__c.substring(0, 32700);              
            }
            upsert integrationLogNew; //upsert log
            integrationLog = integrationLogNew;
            return integrationLogNew; 
         }else{
             return null;
         }
     }
    
    public static void saveIntegrationLogList(List<OSM_Integration_Log__c> integrationLogNewLst){
        
         if(integrationLogNewLst != null){
            system.debug('@@@@@integrationLogNewLst'+integrationLogNewLst);
            try
            {
                upsert integrationLogNewLst; //upsert log
            }
            Catch(Exception ex)
            {
                System.debug('issue in method saveIntegrationLogList: '+ex);
            }
            
         }
     }
    
}