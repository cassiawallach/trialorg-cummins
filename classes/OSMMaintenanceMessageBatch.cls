/************************************************************
Name:  OSMMaintenanceMessageBatch
Copyright © 2021  Cummins
=============================================================
Purpose:                                                            
This class for checking start and end date for Maintenance Message Check
and remove the message automatically in case if dates are passed.
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta Rani      18/02/2021    INITIAL DEVELOPMENT 
*************************************************************/
public class OSMMaintenanceMessageBatch implements Database.Batchable<sObject>, Database.Stateful{
      public Database.QueryLocator start(Database.BatchableContext BC){        
        
        return Database.getQueryLocator([SELECT Id,Start_Time__c,End_Time__c,Start_Date__c,End_Date__c, System_Available__c  FROM  OSM_Maintenance_Message__c ORDER BY CreatedDate DESC limit 1]);
    }
    public void execute(Database.BatchableContext BC, List<OSM_Maintenance_Message__c> scope){
        if(scope!=null  && scope.size()>0)
        {
                if(!scope[0].System_Available__c || Test.isRunningTest())
                {
                    String myEndTimeUpdated='';
                    String myStartTimeUpdated='';
                    String myStartTime='';
                    String myEndTime='';
                    Date curruntDate=System.today();
                    DateTime now = System.now();
                    Time nowTime =now.time();
                  
                   
                    system.debug('StartDate>>>>>'+scope[0].Start_Date__c);
                    system.debug('EndDate>>>>>'+scope[0].End_Date__c);
                    system.debug('CurruntTime>>>>>'+nowTime);
                    system.debug('StartTime>>>>>'+scope[0].Start_Time__c);
                    system.debug('EndTime>>>>>'+scope[0].End_Time__c);
                    
                    if(scope[0].Start_Date__c!=null && scope[0].End_Date__c!=null && ((scope[0].Start_Date__c>curruntDate) || (scope[0].End_Date__c<curruntDate) || (scope[0].Start_Date__c==curruntDate && (scope[0].Start_Time__c>nowTime || scope[0].End_Time__c<nowTime))))
                    {
                        scope[0].System_Available__c =true;
                    }
                   
                }
            
            update scope;
     }
  }      
     public void finish(Database.BatchableContext BC){
     }

}