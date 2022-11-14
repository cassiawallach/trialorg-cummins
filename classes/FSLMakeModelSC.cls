/**********************************************************************
Name: FSLMakeModelSC
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is Schdule batch class it is used to Run daily batch to send Make and Model vaules from FSL Guidanz to Siebel 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         07/30/2019                         
***********************************************************************/
global class FSLMakeModelSC implements Schedulable {
    global void execute(SchedulableContext sc) {        
          FSLMakeModelBatch ST= new FSLMakeModelBatch();
          Database.executeBatch(ST, 10);
    }    
}