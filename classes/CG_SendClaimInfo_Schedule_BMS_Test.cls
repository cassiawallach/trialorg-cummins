@isTest
public class CG_SendClaimInfo_Schedule_BMS_Test
{
    static testMethod void CG_SendClaimInfo_Schedule_BMS_Test()
    {
        CG_SendClaimInfo_Schedule_BMS schClass = new CG_SendClaimInfo_Schedule_BMS();
        String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        String hour = string.valueOf(system.now().hour());
        String minute = string.valueOf(system.now().minute() + 1);
        String second = string.valueOf(system.now().second());
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
       
         Test.startTest();
         System.schedule('Test Schedule', strSchedule, schClass);
        Test.stopTest();
    }
}