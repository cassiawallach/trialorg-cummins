/**************************************************************************************************************************************
* CT3-237: Test class for class FSL_AddSRTDeleteBatch
* @Author: Sailaja Guntupalli, Created Date: 12/09/2021. 
***************************************************************************************************************************************/ 

@IsTest
public class FSL_AddSRTDeleteBatch_Test {
    
    static testMethod void testParse() {
       Datetime hourBack = Datetime.now().addMinutes(-1440); 
       List<FSL_Add_SRT__c> fslSRTList = new List<FSL_Add_SRT__c>();
       FSL_Add_SRT__c fslSRT = new FSL_Add_SRT__c();
        fslSRT.Access_Code_A__c = 0; 
        fslSRT.Access_Code_B__c	= 0;
        fslSRT.Access_Code_C__c	= 0; 
        fslSRT.Access_Code_D__c	= 0; 
        fslSRT.Access_Code_R__c	= 0.1;
        fslSRT.CreatedDate	= hourBack;
        fslSRT.CurrencyIsoCode	= 'USD'; 
        fslSRT.Engine_Family_Code__c= '10';
        fslSRT.Equipment_Id__c	= 'EQ2564';
        fslSRT.Name = '00-000-00';
        fslSRT.Service_Model__c	 = 'ISX15 CM2350 X101';
        fslSRT.SRT_DESCRIPTION__c = 'Coolant Thermostat Seal - Replace' ;
        fslSRT.SRT_Type__c = 'Repair';
        insert fslSRT;
        
        fslSRTList.add(fslSRT);
     
       /* String CRON_EXP = '0 0 0 15 3 ? *';
       // * String runTime = '0 59 * * * ?';
        
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new FSL_AddSRTDeleteBatch());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered); */
        
        //Calling batch because execute method is not calling
         Test.startTest();
        FSL_AddSRTDeleteBatch cb = New FSL_AddSRTDeleteBatch();
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,fslSRTList);
        cb.Finish(null);
        Test.stopTest();
    }
}