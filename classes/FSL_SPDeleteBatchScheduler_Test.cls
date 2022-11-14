/*=======================================================================
Purpose:    Test Class for FSL_SPDeleteBatchScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Anvesh Reddy Sama         05/06/2020           INITIAL DEVELOPMENT 
//comment added for sep release
***********************************************************************/
//pushing through Git Testing
@isTest
public class FSL_SPDeleteBatchScheduler_Test
{
    static testMethod void FSL_SPDeleteBatchScheduler_Test()
    {
        List<sObject> allObjects =  new List<sObject>();
        //Batch Records:
        system.debug('begining allObjects ' +allObjects);
        list<sObject> listRecordsSP = new list<sObject>();
        FSL_SPHeader_Stage__c spobj=new FSL_SPHeader_Stage__c();
        spobj.AccountStatus__c ='Active';
        spobj.BusinessUnit__c = 'EBU';
        spobj.CampaignTRP__c  ='Y';
        spobj.CertificationEndDate__c = date.today();
        spobj.City__c ='LINFEN, SHAXI';
        spobj.ClaimAllowedDays__c = 365;
        spobj.CMISPExpirationDate__c= date.today();
        spobj.CommunicationMethod__c= null;
        spobj.CommunicationOccurrence__c  =null;
        spobj.CostEffectiveExclusion__c ='N';
        spobj.Country__c = 'CN';
        spobj.CreatedDate__c =date.today();
        spobj.CutOffClaimAmt__c = 250;
        spobj.DisableWebAccessFlag__c = 'N';
        spobj.DistHQCode__c = '02020';
        spobj.DistHQName__c ='CUMMINS (CHINA) INVESTMENT CO., LTD(04534)';
        spobj.DSID__c = 'N';
        spobj.DTNAFlag__c ='N';
        spobj.FreezeSubmitButton__c ='N';
        spobj.GroupName__c ='North America';
        spobj.LTAFlag__c = null;
        spobj.MaxClaimAmt__c =999999;
        spobj.NewOEM__c ='N';
        spobj.OutFileAllClaims__c ='N';
        spobj.PACCAR__c ='N';
        spobj.PMUSplitPayment__c ='Y';
        spobj.Policy__c ='N';
        spobj.primaryOEMCode__c =null;
        spobj.PrimaryOEMName__c =null;
        spobj.ProductCertificationFlag__c ='N';
        spobj.PromotionId__c ='N';
        spobj.PromotionIdFlag__c ='N';
        spobj.PSBUProductCertification__c ='N';
        spobj.Region__c ='North America';
        spobj.RegionCode__c = 'USCA';
        spobj.RepairLevel__c ='N';
        spobj.RespBranchCode__c = '02026';
        spobj.RespBranchName__c = 'CUMMINS (CHINA) INVESTMENT CO., LTD. - XI';
        spobj.RSSRespBranchName__c ='CUMMINS (CHINA) INVESTMENT CO., LTD. - XI';
        spobj.SCMDeductible__c =0;
        spobj.SCMDollarAmt__c =0;
        spobj.SPBillToCode__c ='02020';
        spobj.SPBillToName__c ='CUMMINS (CHINA) INVESTMENT CO., LTD(04534)';
        spobj.SPChannelCode__c ='747';
        spobj.SPChannelOfDistribution__c ='747-NATIONAL ACCT_CIHR - HQ';
        spobj.SPCode__c ='13569';
        spobj.SPEmail__c = '';
        spobj.SPFirstName__c ='Bo';
        spobj.SPLastName__c ='Feng';
        spobj.SPRecertificationDate__c =date.today();
        spobj.SPRow_Id__c ='1-U0A-78';
        spobj.State__c = 'NY';
        spobj.StreetAddress1__c ='YICHENG LINGXIA';
        spobj.StreetAddress2__c ='YICHENG LINGXIA';
        spobj.StreetAddress3__c ='YICHENG LINGXIA';
        spobj.StreetAddress4__c ='YICHENG LINGXIA';
        spobj.TechActualHoursRequired__c ='N';
        spobj.Territory__c ='UNITED STATES';
        spobj.TerritoryCode__c = '100';
        spobj.UpdatedDate__c =date.today();
        spobj.ViewDollarAmount__c = 'N';
        //spobj.WarrantyEmail__c = null;
        spobj.WarrantyFax__c = '716 825-2753';
        spobj.WarrantyTrainingStatus__c ='R';
        spobj.WrntyTrainingCertification__c ='N';
        spobj.WWSPSFlag__c = 'Y';
        spobj.ZipPostalCode__c ='14206';
        listRecordsSP.add(spobj);
        allObjects.addAll(listRecordsSP);
        insert listRecordsSP;
        
        system.debug('listRecordsSP ' +listRecordsSP);
        system.debug('1 allObjects ' +allObjects);
        system.debug('1 size allObjects ' +allObjects.size());
        
        list<sObject> lstSPCert =new list<sObject>();
        FSL_SPCertifications_Stage__c spobj1=new FSL_SPCertifications_Stage__c();
        spobj1.EndDate__c =date.today();
        spobj1.OEM_Name__c  = 'CUMMINS';
        spobj1.ServiceLevel__c  ='FULL SERVICE';
        spobj1.OEMCode__c   ='302';
        spobj1.SMN__c ='QSB3.3 CM2150';
        spobj1.SPCertRowId__c  ='1-QAMD-20';
        spobj1.SPCode__c=   '13569';
        spobj1.SPRowId__c=   '1-KX7-181';
        spobj1.StartDate__c  =date.today();
        lstSPCert.add(spobj1);
        allObjects.addAll(lstSPCert);
        insert lstSPCert;
        
        system.debug('lstSPCert ' +lstSPCert);
        system.debug('2nd allObjects ' +allObjects);
        system.debug('2 size allObjects ' +allObjects.size());
        
        list<sObject> listRecords1 = new list<sObject>();
       for(integer i=0; i<=375; i++) {
            
            if(i < 35) {
                FSL_SPCertDetails_Stage__c  record1 = new FSL_SPCertDetails_Stage__c();
                record1.ProductRange__c = string.valueOf('krishna ' + i);
                record1.MarketApplication__c = string.valueOf('moorthi ' + i);
                record1.ProductType__c = string.valueOf('nkm ' + i);
                record1.SPCode__c = string.valueOf('5432' + i);
                record1.SPRowId__c = string.valueOf('5432' + i);
                record1.SPCertRowId__c = string.valueOf('SPCRI-' + i);
                listRecords1.add(record1);
                allObjects.addAll(listRecords1);
            } else {
                FSL_SPCertDetails_Stage__c  record1 = new FSL_SPCertDetails_Stage__c();
                record1.ProductRange__c = string.valueOf('krishna');
                record1.MarketApplication__c = string.valueOf('moorthi');
                record1.ProductType__c = string.valueOf('nkm');
                record1.SPCode__c = string.valueOf('543256');
                record1.SPRowId__c = string.valueOf('543256');
                record1.SPCertRowId__c = string.valueOf('SPCRI-56');
                listRecords1.add(record1);
                allObjects.addAll(listRecords1);
            }
        }
        
        insert listRecords1;
        system.debug('listRecords1 ' +listRecords1);
        system.debug('3rd allObjects ' +allObjects);
        system.debug('3 size allObjects ' +allObjects.size());
        
        list<sObject> lstSPCertTech =new list<sObject>();
        FSL_SPTechCert_Stage__c spobj2=new FSL_SPTechCert_Stage__c();
        spobj2.ServiceModelName__c  ='ISX12N CM2380 X120B';
        spobj2.SMNRowId__c  ='1PAUC26';
        spobj2.SPCode__c=   '02934';
        spobj2.SPRowId__c=   '1-KX7-41';
        spobj2.TechRowId__c  ='1-P9E9-33';
        spobj2.Certification__c= 0.0;
        lstSPCertTech.add(spobj2);
        allObjects.addAll(lstSPCertTech);
        insert lstSPCertTech;
        
        system.debug('lstSPCertTech ' +lstSPCertTech);
        system.debug('4th d allObjects ' +allObjects);
        system.debug('4 size allObjects ' +allObjects.size());
        
        list<sObject> listRecords = new list<sObject>();
         for(integer i=0; i<=375; i++) {
            FSL_SPTechnicians_Stage__c record = new FSL_SPTechnicians_Stage__c();
            record.FirstName__c = string.valueOf('krishna ' + i);
            record.LastName__c = string.valueOf('moorthi ' + i);
            record.PromotionId__c = string.valueOf('nkm ' + i);
            record.SPCode__c = string.valueOf('5432' + i);
            record.SPRowId__c = string.valueOf('812-' + i);
            record.TechRowId__c = string.valueOf('TRI-' + i);
            listRecords.add(record);
            allObjects.addAll(listRecords);
        }
        
        insert listRecords;
        system.debug('listRecords ' +listRecords);
        system.debug('5th allObjects ' +allObjects);
        system.debug('5 size allObjects ' +allObjects.size());
        
        list<sObject> listRecords2 = new list<sObject>();
         for(integer i=0; i<=375; i++) {
            FSL_SPAffilations_Stage__c record2 = new FSL_SPAffilations_Stage__c();
            record2.Name = string.valueOf('krishna ' + i);
            record2.Affiliation__c = string.valueOf('krishna ' + i);
            record2.LastUpdated_By__c = string.valueOf('moorthi ' + i);
            record2.Primary__c = string.valueOf('nkm ' + i);
            record2.SPCode__c = string.valueOf('5432' + i);
            record2.SPRowId__c = string.valueOf('812-' + i);
            record2.AffiliationRowId__c = string.valueOf('ARID-' + i);
            record2.LastUpdatedDate__c = Date.Today();
            listRecords2.add(record2);
            allObjects.addAll(listRecords2);
        }
        insert listRecords2;     
        system.debug('allObjects size '+ allObjects.size() );
        system.debug('allObjects size '+ allObjects);
        
        Test.startTest();
         FSL_SPDeleteBatchScheduler sh1 = new FSL_SPDeleteBatchScheduler();
        String sch = '0 0 23 * * ?' ;
        system.schedule('FSL SP DeleteBatch Scheduler', sch, sh1); 
        Test.stoptest();
        
    }
    
    static testMethod void methodExecute(){
        Test.startTest();
        FSL_SPDeleteBatch spBatchCert =  new FSL_SPDeleteBatch();
        spBatchCert.start(null);
        spBatchCert.execute(null,null);
        spBatchCert.finish(null);
        FSL_SPDeleteBatchScheduler sh1 = new FSL_SPDeleteBatchScheduler();
        String sch = '0 0 23 * * ?' ;
        system.schedule('FSL SP DeleteBatch Scheduler', sch, sh1); 
        Test.stoptest();
    }
    
     static testMethod void methodExecuteRerun(){
        Test.startTest();
        FSL_SPDeleteBatch spBatchCert =  new FSL_SPDeleteBatch();
         spBatchCert.bReRun = true;
         spBatchCert.finish(null);
        FSL_SPDeleteBatchScheduler sh1 = new FSL_SPDeleteBatchScheduler();
        String sch = '0 0 23 * * ?' ;
        system.schedule('FSL SP DeleteBatch Scheduler', sch, sh1); 
        Test.stoptest();
    }
    
}