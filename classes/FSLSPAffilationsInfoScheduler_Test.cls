/**********************************************************************
Name: FSLSPAffilationsInfoScheduler_Test
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for FSLSPAffilationsInfoScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT                    
1.1     Vamsi
***********************************************************************/
@istest
public class FSLSPAffilationsInfoScheduler_Test 
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
        list<CSS_OEM_AFFILIATIONS__c> testRecords = new list<CSS_OEM_AFFILIATIONS__c>();
        for(integer i=0; i<=10; i++) {
            CSS_OEM_AFFILIATIONS__c testR = new CSS_OEM_AFFILIATIONS__c();
            testR.AFFILIATION__c = string.valueOf('krishna ' + i);
            testR.LAST_UPDATED_BY__c = string.valueOf('moorthi ' + i);
            testR.PRIMARY__c = string.valueOf('nkm ' + i);
            //testR.SP_CODE__c = fslspAff.SPCode__c;
            testR.SpRowId__c = string.valueOf('nkm ' + i);
            testR.AFFILIATION_ROW_ID__c = string.valueOf('ARID-' + i);	//External Id - unique Key
            testR.LAST_UPDATED_DATE__c = string.valueOf(Date.Today());
            //testR.account__c = mapSpCodeAccountId.get(fslspAff.SPCode__c); //Map Account Id as lookup Id 
            testRecords.add(testR);
        }
        insert testRecords;
        
        //Batch Records:
        list<FSL_SPAffilations_Stage__c> listRecords = new list<FSL_SPAffilations_Stage__c>();
        for(integer i=0; i<=75; i++) {
            FSL_SPAffilations_Stage__c record = new FSL_SPAffilations_Stage__c();
            record.Name = string.valueOf('krishna ' + i);
            record.Affiliation__c = string.valueOf('krishna ' + i);
            record.LastUpdated_By__c = string.valueOf('moorthi ' + i);
            record.Primary__c = string.valueOf('nkm ' + i);
            record.SPCode__c = string.valueOf('5432' + i);
            record.SPRowId__c = string.valueOf('812-' + i);
            record.AffiliationRowId__c = string.valueOf('ARID-' + i);
            record.LastUpdatedDate__c = Date.Today();
            listRecords.add(record);
        }
        insert listRecords;
        
    	Test.startTest();
		FSLSPAffilationsInfoScheduler sh1 = new FSLSPAffilationsInfoScheduler();
		String sch = '0 0 23 * * ?'; 
    	system.schedule('FSL SP Affilations Info Scheduler', sch, sh1); 
    	Test.stoptest();
    }
}