/**********************************************************************
Name: FSLSPProductRangeScheduler_Test
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for FSLSPProductRangeScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT
1.1     Vamsi                    
***********************************************************************/
@istest
public class FSLSPProductRangeScheduler_Test 
{
    
	static testmethod void testScheduledJob() {
        /*RecordType rtbms = [SELECT id,Name 
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
        insert accountList;*/
        
        //Test Records:
        list<CSS_Accreditation__c> testRecords = new list<CSS_Accreditation__c>();
        for(integer i=0; i<=10; i++) {
            CSS_Accreditation__c testR = new CSS_Accreditation__c();
            testR.CERT_ROW_ID__c = string.valueOf('SPCRI-' + i);
            testR.SPCode__c = string.valueOf('5432' + i);
            string  jsonValues =  '{' +
                                '\"PRODUCT_TYPE\": \"Product_Type' + i + '\",' +
                                '\"PRODUCT_RANGE\": \"PRODUCT_RANGE' + i + '\",' +
                                '\"MARKET_APPLICATION\": \"MARKET_APPLICATION' + i + '\"' +
                                '}'; 
            if(i != 8)
            	testR.Product_Details__c = '[' + jsonValues + ']';
            else 
                testR.Product_Details__c = '';
            testRecords.add(testR);
        }
        insert testRecords;
         
        //Batch Records:
        list<FSL_SPCertDetails_Stage__c> listRecords = new list<FSL_SPCertDetails_Stage__c>();
        for(integer i=0; i<=75; i++) {
            
            if(i < 35) {
                FSL_SPCertDetails_Stage__c  record = new FSL_SPCertDetails_Stage__c();
                record.ProductRange__c = string.valueOf('krishna ' + i);
                record.MarketApplication__c = string.valueOf('moorthi ' + i);
                record.ProductType__c = string.valueOf('nkm ' + i);
                record.SPCode__c = string.valueOf('5432' + i);
                record.SPRowId__c = string.valueOf('5432' + i);
                record.SPCertRowId__c = string.valueOf('SPCRI-' + i);
                //record.SPCertDetailRowId__c = string.valueOf('TRI-' + i);
                listRecords.add(record);
            } else {
                FSL_SPCertDetails_Stage__c  record = new FSL_SPCertDetails_Stage__c();
                record.ProductRange__c = string.valueOf('krishna');
                record.MarketApplication__c = string.valueOf('moorthi');
                record.ProductType__c = string.valueOf('nkm');
                record.SPCode__c = string.valueOf('543256');
                record.SPRowId__c = string.valueOf('543256');
                record.SPCertRowId__c = string.valueOf('SPCRI-56');
                //record.SPCertDetailRowId__c = string.valueOf('TRI-' + i);
                listRecords.add(record);
            }
        }
        insert listRecords;
        
    	Test.startTest();
		FSLSPProductRangeScheduler sh1 = new FSLSPProductRangeScheduler();
		String sch = '0 0 23 * * ?'; 
    	system.schedule('FSL SP Tech Info Scheduler', sch, sh1); 
    	Test.stoptest();
    }
    
    static testmethod void testScheduledJob1() {
        list<FSL_SPCertDetails_Stage__c> listRecords = new list<FSL_SPCertDetails_Stage__c>();
        for(integer i=0; i<=75; i++) {
            
            if(i < 35) {
                FSL_SPCertDetails_Stage__c  record = new FSL_SPCertDetails_Stage__c();
                record.ProductRange__c = string.valueOf('krishna ' + i);
                record.MarketApplication__c = string.valueOf('moorthi ' + i);
                record.ProductType__c = string.valueOf('nkm ' + i);
                record.SPCode__c = string.valueOf('5432' + i);
                record.SPRowId__c = string.valueOf('5432' + i);
                record.SPCertRowId__c = string.valueOf('SPCRI-' + i);
                //record.SPCertDetailRowId__c = string.valueOf('TRI-' + i);
                listRecords.add(record);
            } else {
                FSL_SPCertDetails_Stage__c  record = new FSL_SPCertDetails_Stage__c();
                record.ProductRange__c = string.valueOf('krishna');
                record.MarketApplication__c = string.valueOf('moorthi');
                record.ProductType__c = string.valueOf('nkm');
                record.SPCode__c = string.valueOf('543256');
                record.SPRowId__c = string.valueOf('543256');
                record.SPCertRowId__c = string.valueOf('SPCRI-56');
                //record.SPCertDetailRowId__c = string.valueOf('TRI-' + i);
                listRecords.add(record);
            }
        }
        insert listRecords;
        
    	Test.startTest();
		FSLSPProductRangeScheduler sh1 = new FSLSPProductRangeScheduler();
		String sch = '0 0 23 * * ?'; 
    	system.schedule('FSL SP Product Range Scheduler', sch, sh1); 
    	Test.stoptest();
    }
}