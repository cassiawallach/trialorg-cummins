/**********************************************************************
Name: FSL_SPCertificationInfoBatch_Test
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for FSL_SPCertificationInfoBatch
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 

1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT
1.1     Vamsi                    
***********************************************************************/
@isTest
public class FSL_SPCertificationInfoBatch_Test
{
    static testMethod void Method1()
    {
     
         list<FSL_SPCertifications_Stage__c> lstSPCert =new list<FSL_SPCertifications_Stage__c>();
        FSL_SPCertifications_Stage__c spobj=new FSL_SPCertifications_Stage__c();
        spobj.EndDate__c =date.today();
        spobj.OEM_Name__c  = 'CUMMINS';
        spobj.ServiceLevel__c  ='FULL SERVICE';
        spobj.OEMCode__c   ='302';
        spobj.SMN__c ='QSB3.3 CM2150';
        spobj.SPCertRowId__c  ='1-QAMD-20';
        spobj.SPCode__c=   '13569';
        spobj.SPRowId__c=   '1-KX7-181';
        spobj.StartDate__c  =date.today();
        upsert spobj;
        lstSPCert.add(spobj);
        upsert lstSPCert;
        
        List<Account> accList = new List<Account>();
        Account acc =new Account();
       	acc.name='ZAPATA CAMIONES S.A. DE C.V.';
        acc.IAM_Service_Provider_Code__c='13569';
        //acc.IAM_Service_Provider_Code__c = '13362';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        //acc.IAM_Service_Provider_Code__c = '562551';
        //acc.IAM_Service_Provider_Code__c = '33333';
        acc.CSS_DistributorCode__c='19134';
        //acc.dealerCodeSet = '13362';
        insert acc;
        accList.add(acc);
        upsert acc;
        
        Test.startTest();
        FSL_SPCertificationInfoBatch spBatchCert =  new FSL_SPCertificationInfoBatch();
        Database.QueryLocator ql = spBatchCert.start(null);
        spBatchCert.execute(null,lstSPCert);
        spBatchCert.finish(null);
        Test.stopTest();
  
    }
    
   /* static testMethod void Method2(){
        Test.startTest();
         list<FSL_SPCertifications_Stage__c> lstSPCert1 =new list<FSL_SPCertifications_Stage__c>();
        FSL_SPCertificationInfoBatch spBatchCert =  new FSL_SPCertificationInfoBatch();
        spBatchCert.execute(null,lstSPCert1);
        spBatchCert.finish(null);
        Test.stopTest();
    }*/
}