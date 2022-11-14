//This class is test class for OSM_AccreditationInsert_Batch and OSM_AccreditationUpdate_Batch
@isTest
public class OSM_AccreditationInsert_Batch_Test {
     static testMethod void OSM_AccreditationInsert_BatchMethod(){
        RecordType recid =[select id from recordType where name='WWSPS' limit 1]; 
        Account acc = new Account();
        acc.Name = 'US Xpress - Terrell';
        acc.IAM_Service_Provider_Code__c = '38409';
        acc.CSS_DistributorCode__c = '23093';
        acc.Type = 'CIHR';
        acc.RecordTypeId= recid.id;
        acc.EBU_Channel_of_Distribution__c = 'CIHR';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Accreditation__c accredRec = new CSS_Accreditation__c();
        accredRec.Name = 'Test Accred Record one';
        accredRec.Account__c = acc.Id;
        accredRec.isSMNAccountLevel__c = false;
        accredRec.MARKET_APPLICATION__c = 'AUTOMOTIVE';
        accredRec.PRODUCT_RANGE__c = 'Heavy Duty';
        accredRec.Service_Level__c = 'CIHR LEVEL 2';
        accredRec.SP_CODE__c = '38409';
        accredRec.SpRowId__c = '1-3WDM-9';
        accredRec.Service_Level_Update__c = false;
        insert accredRec;
        
        CSS_Accreditation__c accredRec1 = new CSS_Accreditation__c();
        accredRec1.Name = 'Test Accred Record two';
        accredRec1.Account__c = acc.Id;
        accredRec1.isSMNAccountLevel__c = false;
        accredRec1.MARKET_APPLICATION__c = 'AUTOMOTIVE';
        accredRec1.PRODUCT_RANGE__c = 'Heavy Duty';
        accredRec1.Service_Level__c = 'CIHR LEVEL 2';
        accredRec1.SP_CODE__c = '38409';
        accredRec1.SpRowId__c = '1-3WDM-9';
        accredRec1.Service_Level_Update__c = false;
        insert accredRec1;
        
        OSM_AccreditationInsert_Batch batchIns = new OSM_AccreditationInsert_Batch();
        database.executeBatch(batchIns);
        
        accredRec1.Service_Level_Update__c = true;
        update accredRec1;
        
        OSM_AccreditationUpdate_Batch batchUpd = new OSM_AccreditationUpdate_Batch();
        database.executeBatch(batchUpd);
    }
}