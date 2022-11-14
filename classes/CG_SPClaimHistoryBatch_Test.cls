@istest
public class CG_SPClaimHistoryBatch_Test 
{
    static testmethod void Method()
    {
        //Create Claims History list
        list<CG_StgSPClaimHistory__c> slhsrty =new list<CG_StgSPClaimHistory__c>();
        CG_StgSPClaimHistory__c clmhobj=new CG_StgSPClaimHistory__c();
        clmhobj.ClaimCreatedDate__c =date.today();
        clmhobj.ClaimFiledDate__c   =date.today();
        clmhobj.ClaimStatus__c  ='Admin Outfile';
        clmhobj.ClaimSubmittedDate__c   =date.today();
        clmhobj.CustomerName__c ='JACINTO LIMON CORTES';
        clmhobj.FailureDate__c  =date.today();
        clmhobj.FailureReason__c=   'TEST';
        clmhobj.LastUpdatedBy__c=   'TEST';
        clmhobj.LastUpdatedDate__c  =date.today();
        clmhobj.Name    ='TEST';
        clmhobj.OwnerId =UserInfo.getUserId();
        clmhobj.PartiallyPaidFlag__c    ='N';
        clmhobj.PSN__c  ='79155862';
        clmhobj.SiebelClaimNumber__c=   '1-6344798';
        clmhobj.SourceSystemName__c ='RSS';
        clmhobj.SPCode__c   ='13362';
        clmhobj.SPName__c   ='MEGAMAK ORIENTE'; 
        clmhobj.WarrantyStartDate__c    =date.today();
        clmhobj.WorkOrderNumber__c='165810';
        upsert clmhobj;
        slhsrty.add(clmhobj);
        upsert slhsrty;
        
        //Create Account list
        Account acc=new Account();
        acc.name='ZAPATA CAMIONES S.A. DE C.V.';
        acc.IAM_Service_Provider_Code__c='13362';
        //acc.IAM_Service_Provider_Code__c = '13362';
        acc.Type='Dealer Account';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        //acc.IAM_Service_Provider_Code__c = '562551';
        //acc.IAM_Service_Provider_Code__c = '33333';
        acc.CSS_DistributorCode__c='19134';
        //acc.dealerCodeSet = '13362';
        insert acc;
        list<account> aclist=new list<account>();
        aclist.add(acc);
        upsert acc;
        
        //Create Group list
        Group newGroup = new Group();
        newGroup.Name = 'CQ-19134-13362';
        newGroup.Type='queue';
        insert newGroup;
        list<Group> grplist=new list<Group>();
        grplist.add(newGroup);
        upsert grplist;
        
        //Create Claims list
        CSS_Claims__c clm1=CSS_TestData.createclaims(false,null);
        clm1.SiebelClaimNumber__c='1-6344798';insert clm1;
        CSS_Claims__c clm2=CSS_TestData.createclaims(false,null);
        clm2.SiebelClaimNumber__c='1-6344798';insert clm2;
        list<CSS_Claims__c> clsmlist=new list<CSS_Claims__c>();
        clsmlist.add(clm1);
        clsmlist.add(clm2);
        upsert clsmlist;
        
        //Create PSN list
        list<CSS_PSN__c> psnlist=new list<CSS_PSN__c>();
        CSS_PSN__c psnrec1=CSS_TestData.createpsn(false,clsmlist[0].id);
        psnrec1.CSS_Claims__c=clsmlist[0].id;
        insert psnrec1;
        CSS_PSN__c psnrec2=CSS_TestData.createpsn(false,clsmlist[1].id);
        psnrec2.CSS_Claims__c=clsmlist[1].id;
        insert psnrec2;
        psnlist.add(psnrec1);
        psnlist.add(psnrec2);
        upsert psnlist;
        
        //Create Claim Sumbmission list
        list<CSS_Claim_Submission__c> csblist=new list<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c csbrec1=CSS_TestData.createclaimsub(false,clsmlist[0].id);
        csbrec1.Siebel_Claim_Number__c='1-6344798';insert csbrec1;
        CSS_Claim_Submission__c csbrec2=CSS_TestData.createclaimsub(false,clsmlist[1].id);
        csbrec1.Siebel_Claim_Number__c='1-6344798';insert csbrec2;
        csblist.add(csbrec1);
        csblist.add(csbrec2);
        upsert csblist;
        
        //Query Created  Claims History
        list<CG_StgSPClaimHistory__c> slhsrtyupd=[SELECT Id, FailureReason__c, ClaimCreatedDate__c,ClaimStatus__c,ClaimSubmittedDate__c, CustomerName__c,FailureDate__c,LastUpdatedBy__c,LastUpdatedDate__c, PartiallyPaidFlag__c,PSN__c,SiebelClaimNumber__c,SourceSystemName__c,SPCode__c,SPName__c,WarrantyStartDate__c,WorkOrderNumber__c FROM CG_StgSPClaimHistory__c ORDER BY lastmodifieddate];
        system.debug('slhsrty:::::'+slhsrtyupd);
        
        //Testing Start and execute batch methods
        Test.startTest();
        CG_SPClaimHistoryBatch cb = New CG_SPClaimHistoryBatch();
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,slhsrty);
        //cb.Finish(null);
        Test.stopTest();
        
    }
   static testmethod void finishMethod(){
        Test.startTest();
     list<CG_StgSPClaimHistory__c> slhsrty =new list<CG_StgSPClaimHistory__c>();
        CG_StgSPClaimHistory__c clmhobj=new CG_StgSPClaimHistory__c();
        clmhobj.ClaimCreatedDate__c =date.today();
        clmhobj.ClaimFiledDate__c   =date.today();
        clmhobj.ClaimStatus__c  ='Draft';
        clmhobj.ClaimSubmittedDate__c   =date.today();
        clmhobj.CustomerName__c ='JACINTO LIMON CORTES';
        clmhobj.FailureDate__c  =date.today();
        clmhobj.FailureReason__c=  null;
        clmhobj.LastUpdatedBy__c=   'TEST';
        slhsrty.add(clmhobj);
        
        CG_StgSPClaimHistory__c clmhobj1=new CG_StgSPClaimHistory__c();
        clmhobj1.ClaimCreatedDate__c =date.today();
        clmhobj1.ClaimFiledDate__c   =date.today();
        clmhobj1.ClaimStatus__c  ='Draft';
        clmhobj1.ClaimSubmittedDate__c   =date.today();
        clmhobj1.CustomerName__c ='JACINTO LIMON CORTES';
        clmhobj1.FailureDate__c  =date.today();
        clmhobj1.FailureReason__c=  null;
        clmhobj1.LastUpdatedBy__c=   'TEST';
        slhsrty.add(clmhobj1);
        
        CG_SPClaimHistoryBatch cb = New CG_SPClaimHistoryBatch();
        cb.Finish(null);
       
        Test.stopTest();
    }
}