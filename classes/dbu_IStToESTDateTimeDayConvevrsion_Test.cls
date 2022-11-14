@isTest
public class dbu_IStToESTDateTimeDayConvevrsion_Test {
    static testMethod void testloginTime() {
        //added for production deploymet by komal-sk102
        /*String loginTime;
        String startTime = '06:59:59';
        String endTime = '19:59:59';
        String weekEndFirst = 'Mon';
        String weekEndySecond = 'Sat'; 
       // String ManualOption ='ON';
        String ManualDisable;
        
        Datetime dt = System.now();
        String dtEST = dt.format('HH:mm:ss', 'EST');
        String dayofWeek = DateTime.now().format('EEE');
        //String dayofWeek = DateTime.now().format('EEE');*/
        dbu_Manage_Chat__c mChat= new dbu_Manage_Chat__c();
        mChat.dbu_Store_Name__c='US';
        mChat.dbu_Day_Of_The_Week__c='Monday';
        mChat.dbu_StartTime__c='00:00:00';
        mChat.dbu_End_Time__c='23:59:59';
        mChat.dbu_Time_Zone__c='CST';
        insert mChat;
        Test.startTest();
        	dbu_IStToESTDateTimeDayConvevrsion.getloginTime('US'); 
      Test.stopTest(); 
    }
}