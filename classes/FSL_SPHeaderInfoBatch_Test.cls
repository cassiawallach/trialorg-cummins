@isTest
public class FSL_SPHeaderInfoBatch_Test
{
    static testMethod void FSL_SPHeaderInfoBatch_Test()
    {


        list<FSL_SPHeader_Stage__c> lstSPCert =new list<FSL_SPHeader_Stage__c>();
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
        upsert spobj;
        lstSPCert.add(spobj);
        upsert lstSPCert;

        RecordType rtbms = [SELECT id,Name 
                            FROM RecordType 
                            WHERE name='WWSPS' and sobjecttype='Account'];
        List<Account> accList = new List<Account>();
        Account acc =new Account();

        acc.RecordTypeId = rtbms.id;
        acc.name='ZAPATA CAMIONES S.A. DE C.V.';
        acc.IAM_Service_Provider_Code__c ='13569';
        acc.Type='Dealer Account';
        acc.Region__c =  'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.CSS_DistributorCode__c ='19134';
        insert acc;
        accList.add(acc);
        upsert acc;
        system.debug('Test class debug acc ' + acc );
        Test.startTest();
        FSL_SPHeaderInfoBatch spBatchCert =  new FSL_SPHeaderInfoBatch();
        Database.QueryLocator ql = spBatchCert.start(null);
        spBatchCert.execute(null,lstSPCert);
        spBatchCert.finish(null);
        Test.stopTest();



    }

    static testMethod void Method2(){
        FSL_SPHeaderInfoBatch spBatchCert =  new FSL_SPHeaderInfoBatch();
        spBatchCert.execute(null,null);
        css_utility.LogOutIntError('FSL_SPHeaderInfoBatch', '114', 'BATCH Execution failed', 'FSL_SPHeaderInfoBatch');
    }

}