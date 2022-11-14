/**********************************************************************
Name: FSL_SPTechCertificationBatch_Test
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for FSL_SPTechCertificationBatch
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT
1.1     Vamsi                    
***********************************************************************/
@isTest
public class FSL_SPTechCertificationBatch_Test {
    
    static testMethod void FSL_SPTechCertBatch_Test(){
         list<FSL_SPTechCert_Stage__c> lstSPCert =new list<FSL_SPTechCert_Stage__c>();
        FSL_SPTechCert_Stage__c spobj=new FSL_SPTechCert_Stage__c();
        spobj.ServiceModelName__c  ='ISX12N CM2380 X120B';
        spobj.SMNRowId__c  ='1-PAUC-26';
        spobj.SPCode__c=   '02934';
        spobj.SPRowId__c=   '1-KX7-41';
        spobj.TechRowId__c  ='1-P9E9-33';
        spobj.Certification__c= 0.0;
        upsert spobj;
        lstSPCert.add(spobj);
        upsert lstSPCert;
        
        List<Account> accList = new List<Account>();
        Account acc =new Account();
        acc.name='ZAPATA CAMIONES S.A. DE C.V.';
        acc.IAM_Service_Provider_Code__c='02934';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.CSS_DistributorCode__c='19134';
        insert acc;
        accList.add(acc);
        upsert acc;
        
        Test.startTest();
        FSL_SPTechCertificationBatch spBatchCert =  new FSL_SPTechCertificationBatch();
        Database.QueryLocator ql = spBatchCert.start(null);
        spBatchCert.execute(null,lstSPCert);
        spBatchCert.finish(null);
        Test.stopTest();
    }
}