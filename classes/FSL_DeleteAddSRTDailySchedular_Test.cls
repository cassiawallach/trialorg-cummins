/******************************************************************************************

* Name      :    FSL_DeleteAddSRTDailySchedular_Test.apxc
* Purpose   :    Delete record which is 1 day old using schedular
* History   :
* Apex class:    FSL_AddSRTDeleteSchedular
------------------------------------------------------------------------------------------- 
* VERSION         AUTHOR             DATE             DETAIL 
* 1.0             Harsha Ragam      15/01/2020       Initial Development
*******************************************************************************************/

@IsTest

public class FSL_DeleteAddSRTDailySchedular_Test {
    
    static TestMethod void testScheduler() {
        
      FSL_AddSRTDeleteSchedular schClass = new FSL_AddSRTDeleteSchedular();
        String runTime = '0 59 * * * ?';
        Test.startTest();
        system.schedule('Delete_FSLAddSRTEveryHour', runTime, schClass);
        Test.stopTest();
    }
    
}