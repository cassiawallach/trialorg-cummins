/**********************************************************************
Name: FSLSPTechInfoScheduler_Test
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for FSLSPTechInfoScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT  
1.1     Vamsi                  
***********************************************************************/
@isTest
public class FSLSPTechInfoScheduler_Test 
{
	static testmethod void testScheduledJob() {
        RecordType rtbms = [SELECT id,Name 
                                FROM RecordType 
                                WHERE name='WWSPS' and sobjecttype='Account'];
								
        List<Account> accountList = new List<Account>();
        for(integer i=0; i<=5; i++) {
            Account Acc = new Account();
            Acc.Name = string.valueOf('krishna ' + i);
            Acc.recordtypeId = rtbms.Id;
            Acc.CSS_DistributorCode__c = string.valueOf(i+ '2345');
            Acc.IAM_Service_Provider_Code__c = string.valueOf('5432' + i);
            accountList.add(Acc);
        }
        insert accountList;
        
        //Test Records:
        list<CSS_AccredUser__c> testRecords = new list<CSS_AccredUser__c>();
        for(integer i=0; i<=10; i++) {
            CSS_AccredUser__c testR = new CSS_AccredUser__c();
            testR.First_Name__c = string.valueOf('krishna ' + i);
            testR.Last_Name__c = string.valueOf('moorthi ' + i);
            testR.Promotion_Id__c = string.valueOf('nkm ' + i);
            testR.TECH_ROW_ID__c = string.valueOf('TRI-' + i);
            testRecords.add(testR);
        }
        insert testRecords;
         
        //Batch Records:
        list<FSL_SPTechnicians_Stage__c> listRecords = new list<FSL_SPTechnicians_Stage__c>();
        for(integer i=0; i<=75; i++) {
            FSL_SPTechnicians_Stage__c record = new FSL_SPTechnicians_Stage__c();
            record.FirstName__c = string.valueOf('krishna ' + i);
            record.LastName__c = string.valueOf('moorthi ' + i);
            record.PromotionId__c = string.valueOf('nkm ' + i);
            record.SPCode__c = string.valueOf('5432' + i);
            record.SPRowId__c = string.valueOf('812-' + i);
            record.TechRowId__c = string.valueOf('TRI-' + i);
            listRecords.add(record);
        }
        insert listRecords;
        
    	Test.startTest();
		FSLSPTechInfoScheduler sh1 = new FSLSPTechInfoScheduler();
		String sch = '0 0 23 * * ?'; 
    	system.schedule('FSL SP Tech Info Scheduler', sch, sh1); 
    	Test.stoptest();
    }
    
    static testmethod void testScheduledJob1() {
        //Batch Records:
        list<FSL_SPTechnicians_Stage__c> listRecords = new list<FSL_SPTechnicians_Stage__c>();
        for(integer i=0; i<=75; i++) {
            FSL_SPTechnicians_Stage__c record = new FSL_SPTechnicians_Stage__c();
            record.FirstName__c = string.valueOf('krishna ' + i);
            record.LastName__c = string.valueOf('moorthi ' + i);
            record.PromotionId__c = string.valueOf('nkm ' + i);
            record.SPCode__c = string.valueOf('5432' + i);
            record.SPRowId__c = string.valueOf('812-' + i);
            record.TechRowId__c = string.valueOf('TRI-' + i);
            listRecords.add(record);
        }
        insert listRecords;
        
    	Test.startTest();
		FSLSPTechInfoScheduler sh1 = new FSLSPTechInfoScheduler();
		String sch = '0 0 23 * * ?'; 
    	system.schedule('FSL SP Tech Info Scheduler', sch, sh1); 
    	Test.stoptest();
    }
}