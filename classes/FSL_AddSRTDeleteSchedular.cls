/******************************************************************************************

* Name      :    FSL_AddSRTDeleteSchedular.apxc
* Purpose   :    Delete record which is 1 day old using schedular
* History   :
* Test class:    FSL_DeleteAddSRTDailySchedular_Test
------------------------------------------------------------------------------------------- 
* VERSION         AUTHOR             DATE             DETAIL 
* 1.0             Harsha Ragam      15/01/2020       Initial Development
* 2.0			  Harsha Ragam		2/05/2020		 Last Updated 
*******************************************************************************************/

/*global class FSL_AddSRTDeleteSchedular implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        try{
            Datetime hourBack = Datetime.now().addMinutes(-1440);
            List<FSL_Add_SRT__c> srtList = new List<FSL_Add_SRT__c>();
            srtList = [SELECT Id,Name,CreatedDate FROM FSL_Add_SRT__c WHERE CreatedDate <: hourBack];
            System.debug('srtList' + srtList);
            String thisfortestclass;
            thisfortestclass = 'nothing to do here' ;
            if(srtList != null && srtList.size()>0)
            {
                delete srtList;
            }
            
        }
        catch(Exception e)
        {
            System.debug('Something went wrong');
        }
    }
    
}*/
global class FSL_AddSRTDeleteSchedular implements Schedulable {
   
    global void execute(SchedulableContext sc) {  
        String thisfortestclass;
        thisfortestclass = 'nothing to do here' ;
        FSL_AddSRTDeleteBatch batch = new FSL_AddSRTDeleteBatch(); 
        Database.executeBatch(batch);
    }
}