/********************************************
HISTORY  :-CG_populateNoWarrantyFlagClass_Test

VERSION  AUTHOR               DATE                DETAILS                                 
1.0 -    Rajesh Pasupuleti    13/03/2020          Test class for CG_populateNoWarrantyFlagClass class
********************************************/
@istest
public class CG_populateNoWarrantyFlagClass_Test {
    public static testmethod void CG_populateNoWarrantyFlagClass_Method(){
        
        list<CSS_Job_Order__c> listjobs = new list<CSS_Job_Order__c>();
        List<Asset> AssRecs = new List<Asset>();
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
                Date d = Date.Today();
                SerRec.DSID__c='12345';
                SerRec.DSID_Status__c='open';
                SerRec.ESN__c ='79464646';
                SerRec.CSS_Channel_Code__c ='7943';
                SerRec.Customer_Name__c='ABC';
                SerRec.Failure_Date__c =d;
                SerRec.Failure_Point__c=2.2;
                SerRec.Unit_Number__c='1234';
                SerRec.Territory_Class__c='test';
                SerRec.Qsol_Engine_Family_Code__c='1234';
                SerRec.Service_Model__c='ESN';
                SerRec.Service_Model_N__c = 445566;
                SerRec.Make__c='test';
                SerRec.Model__c='test1';
                SerRec.VIN__c='1XKAD49X6CJ305490';
                SerRec.Customer_Name__c='ABC';
                SerRec.Warranty_Start_Date__c=d;
                SerRec.Application_Desc__c='test1';
                SerRec.Failure_Point_Measure__c = 'MI'; 
                SerRec.Application__c='Automotive'; 
                SerRec.sub_Type__c='cedan';
                SerRec.INSITE_UpdateTimeStamp__c= system.today();
                 SerRec.INSITE_ESN_Choice__c='Not Selected';
                 SerRec.Shop_Work_Order__c='1234';
                 SerRec.DSID_Creation_Timestamp__c=system.today();
                 SerRec.DSID_WorkGroup__c='Wrkgrp';
                 SerRec.Equipment_ID__c='Equip';
                 SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
                 SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
                 SerRec.CSS_Job_Location_Code__c='56270-56255';
                 SerRec.PSN_Not_Available__c = true;
                 SerRec.Actual_Technician_Time__c=1.2;
                SerRec.CSS_Resolution__c='Customer Rejected';
                SerRec.warrantyIndicatorFlag__c='Y';
              insert SerRec;
        List<String> PSNsString = new List<String>();
        PSNsString.add(SerRec.ESN__c);
        system.debug('**PSNsString**'+PSNsString);
        listjobs.add(SerRec);
        upsert listjobs;
        
        Account acc=new Account();
        acc.name='ZAPATA CAMIONES S.A. DE C.V.';
        acc.IAM_Service_Provider_Code__c='133621';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.CSS_DistributorCode__c='19134';
        insert acc;
        list<account> aclist=new list<account>();
        aclist.add(acc);
        upsert aclist;
        
        
        Asset newAssetRef = new Asset();
        newAssetRef.name='79464647';
        newAssetRef.Type__c='Engines';
        //newAssetRef.AccountId=acc.id;
        newAssetRef.No_Warranty__c=true;
        insert newAssetRef;
        
        Asset newAssetRef1 = new Asset();
        newAssetRef1.name='79462880';
        newAssetRef1.Type__c='Engines';
        //newAssetRef1.AccountId=acc.id;
        newAssetRef1.No_Warranty__c=true;
        insert newAssetRef1;
        
        
        //AssRecs.add(newAssetRef);
        //AssRecs.add(newAssetRef1);
        //upsert AssRecs;
        Map<String,Boolean> AssRecsMap = new Map<String,Boolean>();
        AssRecsMap.put(newAssetRef.Name,newAssetRef.No_Warranty__c);
        //Query Created  Claims History
        list<CSS_Job_Order__c> listofJobs= [SELECT Id, name, ESN__c from CSS_Job_Order__c where status__c !='' and warrantyIndicatorFlag__c != '' and ESN__c != null and ESN__c != ''];
        test.startTest();
            CG_populateNoWarrantyFlagClass classRef = new CG_populateNoWarrantyFlagClass();
            Database.QueryLocator ql = classRef.start(null);
            classRef.execute(null,listofJobs);
            classRef.finish(null);
        test.stopTest();
    }
}