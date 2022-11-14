/**********************************************************************
Name: FSL_AddSRTDeleteBatch
Copyright Â© 2021  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is batch class it is used to Delete record which is 1 day old using schedular
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Sailaja Guntupalli               12/09/2021                        
***********************************************************************/
global class FSL_AddSRTDeleteBatch implements Database.Batchable<SObject>, Database.Stateful  {
    global Database.QueryLocator start(Database.BatchableContext BC) {
      Datetime hourBack = Datetime.now().addMinutes(-1440);    
      return Database.getQueryLocator([SELECT Id,Name,CreatedDate FROM FSL_Add_SRT__c WHERE CreatedDate <: hourBack]); 
      }
  
      global void execute(Database.BatchableContext BC, list<FSL_Add_SRT__c> scope) {
      try{
              System.debug('entered execute method');
              String thisfortestclass;
              thisfortestclass = 'nothing to do here' ;
              if(scope.size()>0)
              {
                  Database.delete(scope,false);
              }
              }
      catch(Exception e)  {
          system.debug('EXCEPTION of FSL_AddSRTDeleteBatch execute e.getMessage>>> '+e.getMessage() + ' e.getLineNumber ' + e.getLineNumber() + ' getCause ' +e.getCause());
          css_utility.LogOutIntError('FSL_AddSRTDeleteBatch', e.getMessage() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'FSL_AddSRTDeleteBatch');
      }
      }
      global void finish(Database.BatchableContext BC) {
      
      system.debug('Finish method Executed Successfully');
      }
      }