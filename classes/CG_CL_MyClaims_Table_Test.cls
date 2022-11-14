@isTest
public class CG_CL_MyClaims_Table_Test 
{
    public static Testmethod void CG_CL_MyClaims_MethodFive()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Status__c='Draft';
        claimObj.Information_Only_Claim__c=false;
        claimObj.Location_Code__c='56270-56255';
        insert claimObj;
        CSS_claims__c claimObj1 = new CSS_claims__c();
        claimObj1.OwnerId = UserInfo.getUserId();
        claimObj1.Location__c = '562';
        claimObj1.Status__c='Draft';
        claimObj1.Information_Only_Claim__c=true;
        claimObj1.Pending_Authorization__c=' Authorized';
        claimObj1.Location_Code__c='56270-56255';
        insert claimObj1;
        CSS_claims__c claimObj11 = new CSS_claims__c();
        claimObj11.OwnerId = UserInfo.getUserId();
        claimObj11.Location__c = '562';
        claimObj11.Status__c='Draft';
        claimObj11.Information_Only_Claim__c=true;
        claimObj11.Pending_Authorization__c='Not Authorized';
        claimObj11.Location_Code__c='56270-56255';
        insert claimObj11;
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub111 = new CSS_Claim_Submission__c();
        claimsSub111.CSS_Claims__c = claimObj1.Id; 
        claimsSub111.Type__c = 'ytes';
        claimsSub111.Rejection_Reason__c='test';
        claimsSub111.Status__c= 'submitted';
       
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub111);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub11 = new CSS_Claim_Submission__c();
        claimsSub11.CSS_Claims__c = claimObj.Id; 
        claimsSub11.Type__c = 'ytes';
        claimsSub11.Rejection_Reason__c='test';
        claimsSub11.Status__c= 'Information Only';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub11);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.IMS_Claim_Number__c='12443';
        claimsSub3.isPendingResponse__c=true;
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        CSS_PSN__c psnObj41 = new CSS_PSN__c();
        psnObj41.name = 'TestPSN';
        psnObj41.PSN__c = 'TestPSN123';
        psnObj41.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj41.CSS_Claims__c = claimObj.id;
        psnObj41.Service_Model__c = 'test';
        psnObj41.Failure_Date__c=system.today()-9;
        psnList.add(psnObj41);
        CSS_PSN__c psnObj411 = new CSS_PSN__c();
        psnObj411.name = 'TestPSN';
        psnObj411.PSN__c = 'TestPSN123';
        psnObj411.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj411.CSS_Claims__c = claimObj1.id;
        psnObj411.Service_Model__c = 'test';
        psnList.add(psnObj411);
        CSS_PSN__c psnObj4112 = new CSS_PSN__c();
        psnObj4112.name = 'TestPSN';
        psnObj4112.PSN__c = 'TestPSN123';
        psnObj4112.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4112.CSS_Claims__c = claimObj11.id;
        psnObj4112.Service_Model__c = 'test';
        psnList.add(psnObj4112);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        // CG_CL_MyClaims_Table.ClaimsWrap wrp = new CG_CL_MyClaims_Table.ClaimsWrap();
        //CG_CL_MyClaims_Table.ClaimsWrap wrap = new CG_CL_MyClaims_Table.ClaimsWrap();
        Test.startTest();
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'Status',null,'Draft','1',false,'2/23/2018','2/23/2020','Information Only');
      
         CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Response',null,'paymentRefNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');

        
        
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Response',null,'paymentRefNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Response');

        
        CG_CL_MyClaims_Table.copyclaimsGuidz(claimObj.id,'','');
        test.stopTest();
    }


    public static Testmethod void CG_CL_MyClaims_MethodFour()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            claimsObj2.Location_Code__c='56270-56255';
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
             claimsObj.Location_Code__c='56270-56255';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            claimsObj1.Location_Code__c='56270-56255';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Status__c='Draft';
        claimObj.Information_Only_Claim__c=false;
         claimObj.Location_Code__c='56270-56255';
        insert claimObj;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub11 = new CSS_Claim_Submission__c();
        claimsSub11.CSS_Claims__c = claimObj.Id; 
        claimsSub11.Type__c = 'ytes';
        claimsSub11.Rejection_Reason__c='test';
        claimsSub11.Status__c= 'Information Only';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub11);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        CSS_PSN__c psnObj41 = new CSS_PSN__c();
        psnObj41.name = 'TestPSN';
        psnObj41.PSN__c = 'TestPSN123';
        psnObj41.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj41.CSS_Claims__c = claimObj.id;
        psnObj41.Service_Model__c = 'test';
        psnList.add(psnObj41);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        // CG_CL_MyClaims_Table.ClaimsWrap wrp = new CG_CL_MyClaims_Table.ClaimsWrap();
        //CG_CL_MyClaims_Table.ClaimsWrap wrap = new CG_CL_MyClaims_Table.ClaimsWrap();
        Test.startTest();
        
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Paid','Not Authorized','CustomerName',claimsList[0].id,null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Paid');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Paid');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Paid');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Paid');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Paid');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Paid');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Paid');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Paid',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Paid');
        
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'ConsolidatedClaimID',claimsList[0].id,null,null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'Status',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'Status',claimsList[0].id,'Pending ',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Appealed/Resubmitted',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        
        
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Denied',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Draft',null,'Status',null,'Draft','1',false,'2/23/2018','2/23/2020','Draft');
        test.stopTest();
    }
    public static Testmethod void CG_CL_MyClaims_MethodThree()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            claimsObj2.Information_Only_Claim__c=true;
            claimsObj2.Location_Code__c='56270-56255';
            claimsObj2.Pending_Authorization__c='Not Authorized';
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            claimsObj.Information_Only_Claim__c=true;
            claimsObj.Location_Code__c='56270-56255';
            claimsObj.Pending_Authorization__c='NotAAuthorized';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            claimsObj1.Information_Only_Claim__c=true;
            claimsObj1.Location_Code__c='56270-56255';
            claimsObj1.Pending_Authorization__c='NotAAuthorized';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Information_Only_Claim__c=false;
        claimObj.Location_Code__c='56270-56255';
        claimObj.Pending_Authorization__c='NotAAuthorized';
        insert claimObj;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub11 = new CSS_Claim_Submission__c();
        claimsSub11.CSS_Claims__c = claimObj.Id; 
        claimsSub11.Type__c = 'ytes';
        claimsSub11.Rejection_Reason__c='test';
        claimsSub11.Status__c= 'Information Only';
        claimsSub11.IMS_Claim_Number__c='1325543';	
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub11);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        // CG_CL_MyClaims_Table.ClaimsWrap wrp = new CG_CL_MyClaims_Table.ClaimsWrap();
        //CG_CL_MyClaims_Table.ClaimsWrap wrap = new CG_CL_MyClaims_Table.ClaimsWrap();
        Test.startTest();
        
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','Not Authorized','CustomerName',claimsList[0].id,null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'paymentRefNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'ConsolidatedClaimID',claimsList[0].id,null,null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'Status',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'Status',claimsList[0].id,'Pending ',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'paymentRefNumber',claimsList[0].id,'Information Only',null,true,null,null,'Information Only');

        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'paymentRefNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');

        
        test.stopTest();
    }
        public static Testmethod void CG_CL_MyClaims_Methodsix()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            claimsObj2.Information_Only_Claim__c=true;
            claimsObj2.Location_Code__c='56270-56255';
            claimsObj2.Pending_Authorization__c='Authorized';
			claimsObj2.status__c='Submitted';
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            claimsObj.Information_Only_Claim__c=true;
            claimsObj.Location_Code__c='56270-56255';
            claimsObj.Pending_Authorization__c='Authorized';
			claimsObj.status__c='Submitted';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            claimsObj1.Information_Only_Claim__c=true;
            claimsObj1.Location_Code__c='56270-56255';
            claimsObj1.Pending_Authorization__c='Authorized';
			claimsObj1.status__c='Submitted';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Information_Only_Claim__c=false;
        claimObj.Location_Code__c='56270-56255';
        claimObj.Pending_Authorization__c='NotAAuthorized';
        insert claimObj;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        //claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
         claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        //claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub11 = new CSS_Claim_Submission__c();
        //claimsSub11.CSS_Claims__c = claimObj.Id; 
        claimsSub11.Type__c = 'ytes';
        claimsSub11.Rejection_Reason__c='test';
        claimsSub11.Status__c= 'Information Only';
        claimsSub11.IMS_Claim_Number__c='1325543';	
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub11);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        //claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        //claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        //claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        //claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        // CG_CL_MyClaims_Table.ClaimsWrap wrp = new CG_CL_MyClaims_Table.ClaimsWrap();
        //CG_CL_MyClaims_Table.ClaimsWrap wrap = new CG_CL_MyClaims_Table.ClaimsWrap();
        Test.startTest();
        
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','Not Authorized','CustomerName',claimsList[0].id,null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Submitted',null,'paymentRefNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Submitted');
        
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'ConsolidatedClaimID',claimsList[0].id,null,null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'Status',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'Status',claimsList[0].id,'Pending ',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Information Only',null,'paymentRefNumber',claimsList[0].id,'Information Only',null,true,null,null,'Information Only');

        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return',null,'paymentRefNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');

        
        test.stopTest();
    }
    
    
     
    public static Testmethod void CG_CL_MyClaims_MethodTwo()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Information_Only_Claim__c=false;
          claimObj.Location_Code__c='56270-56255';
        insert claimObj;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnObj.Failure_Date__c=system.today()-6;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnObj1.Failure_Date__c=system.today()-6;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnObj2.Failure_Date__c=system.today()-6;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnObj3.Failure_Date__c=system.today()-6;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnObj4.Failure_Date__c=system.today()-6;
        psnList.add(psnObj4);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        // CG_CL_MyClaims_Table.ClaimsWrap wrp = new CG_CL_MyClaims_Table.ClaimsWrap();
        //CG_CL_MyClaims_Table.ClaimsWrap wrap = new CG_CL_MyClaims_Table.ClaimsWrap();
        Test.startTest();
        CG_CL_MyClaims_Table.copysiebelclaims(claimsList[0].name,claimsList[0].Id);
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','In Review',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'paid');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'paid');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'paid');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'paid');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'paid');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'paid');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'paid');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','paid',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'paid');
        
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','In Review',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'In Review');
        
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','test',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'test');
        test.stopTest();
        
        
    }
    public static Testmethod void CG_CL_MyClaims_MethodOne()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Information_Only_Claim__c=false;
        claimObj.Location_Code__c='56270-56255';
        insert claimObj;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        // CG_CL_MyClaims_Table.ClaimsWrap wrp = new CG_CL_MyClaims_Table.ClaimsWrap();
        //CG_CL_MyClaims_Table.ClaimsWrap wrap = new CG_CL_MyClaims_Table.ClaimsWrap();
        Test.startTest();
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Parts to Return',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Parts to Return');
        
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Appealed/Resubmitted',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Appealed/Resubmitted');
        
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Denied',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Denied');
        
        
        
        
        test.stopTest();
    }
    public static Testmethod void CG_CL_MyClaims_Method()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Information_Only_Claim__c=false;
          claimObj.Location_Code__c='56270-56255';
        insert claimObj;
        
        CSS_claims__c claimObj1 = new CSS_claims__c();
        claimObj1.OwnerId = UserInfo.getUserId();
        claimObj1.Location__c = '562';
        claimObj1.Information_Only_Claim__c=true;
          claimObj1.Location_Code__c='56270-56255';
        insert claimObj1;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub11 = new CSS_Claim_Submission__c();
        claimsSub11.CSS_Claims__c = claimObj1.Id; 
        claimsSub11.Type__c = 'ytes';
        claimsSub11.Rejection_Reason__c='test';
        claimsSub11.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub11);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        // CG_CL_MyClaims_Table.ClaimsWrap wrp = new CG_CL_MyClaims_Table.ClaimsWrap();
        //CG_CL_MyClaims_Table.ClaimsWrap wrap = new CG_CL_MyClaims_Table.ClaimsWrap();
        Test.startTest();
        //CG_BL_Claims.fetchMultiLocation();
        CG_CL_MyClaims_Table mt = new CG_CL_MyClaims_Table();
        mt.getLocationsName();
        mt.selectedLocation = 'location';
        lstUserLocations = CG_BL_Claims.fetchMultiLocation(); 
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-',null,null,null,null,null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Draft',null,null,null,null,null,false,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','view all',null,null,null,null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'ConsolidatedClaimID',claimsList[0].id,null,null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'Status',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'Status',claimsList[0].id,'Pending ',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Pending Authorization',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Pending Authorization');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'All',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'ConsolidatedClaimID',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'Status',claimsList[0].id,'Information Only',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'CustomerName',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'ShopWorkOrder',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'ProductSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'VINAssetSerialNumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Information Only',null,'GuidanzJobnumber',claimsList[0].id,'Pending Authorization',null,true,null,null,'Information Only');
        
        // CG_CL_MyClaims_Table.copysiebelclaims(claimsList[0].name,claimsList[0].Id);
        CG_CL_MyClaims_Table.saveRejectCom(claimsList[0].Id,'notes');
        CG_CL_MyClaims_Table.onChangeReject(claimsList[0].Id);
        CG_CL_MyClaims_Table.onchangeAuthorize(claimsList[0].Id);
        //CG_CL_MyClaims_Table.copyclaimsGuidz(claimsList[0].Id,SerRec.Id,SerRec.Id);
        CG_CL_MyClaims_Table.PSNWebserviceTrigger(psnList,psnList[0].id);
        CG_CL_MyClaims_Table cont = new CG_CL_MyClaims_Table();
        cont.claimidarp = claimsList[0].Id;
        cont.selectedRejComm = 'rtest';
        cont.claimsrec = claimsList[0];    
        CG_CL_MyClaims_Table.listpsn = psnList;   
        cont.cs = claimsList[0];  
        cont.NotesBody = 'claimsobj';
        CG_CL_MyClaims_Table.PSNTriggered();
        Test.stopTest();
        
        
    }
    public static Testmethod void CG_CL_MyClaims_MethodName()
    {
        Test.startTest();
        //CG_BL_Claims.fetchMultiLocation();
        //CG_CL_MyClaims_Table mt = new CG_CL_MyClaims_Table();
        //mt.getLocationsName();
        //mt.selectedLocation = 'location';
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56271');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56271';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
         // claimsobj.Location_Code__c='56270-56255';
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56255';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56255';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.Individual_Claim_Id__c ='56270-56255';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        claimsSub1.Individual_Claim_Id__c ='56270-56255';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Parts to Return';
        claimsSub2.Individual_Claim_Id__c ='56270-56255';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Submitted';
        claimsSub3.Individual_Claim_Id__c ='56270-56255';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        testData(u);
        // system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Submitted','','','',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','Submitted','','','56270-56270',null,null,true,null,null,null);
        
        //  CG_CL_MyClaims_Table.ClaimsSearch('-All-','Draft',null,null,null);
        // CG_CL_MyClaims_Table.ClaimsSearch('-All-','view all',null,null,null);
        // }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method1(){
        Test.startTest();
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56271');
        insert u;
        
        
        
        testData(u);
        system.runAs(u){
            //ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
            
            CG_CL_MyClaims_Table.ClaimsSearch('-All-','Submitted','','','',null,null,false,null,null,null);
            Test.stopTest();
            
        }
    }
    public static Testmethod void CG_CL_MyClaims_Method3()
    {
        Test.startTest();
        //CG_CL_MyClaims_Table mt = new CG_CL_MyClaims_Table();
        //mt.getLocationsName();
        //CG_CL_MyClaims_Table.ClaimsWrap();
        //mt.selectedLocation = 'location';
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56270');
        insert u;
        
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '56255';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        //claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56255';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56255';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        //claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.PartReturnToCenter__c = 'Y';
        claimsSub.Individual_Claim_Id__c ='56270-56255';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        claimsSub1.PartReturnToCenter__c = 'Y';
        claimsSub1.Individual_Claim_Id__c ='56270-56255';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Submitted';
        claimsSub2.PartReturnToCenter__c = 'Y';
        claimsSub2.Individual_Claim_Id__c ='56270-56255';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Submitted';
        claimsSub3.Individual_Claim_Id__c ='56270-56255';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        testData(u);
        //system.runAs(u){
        
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Parts to Return','','','',null,'1',true,null,null,null);
        // }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method4()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        //Date dt = system.today()+30;
        
        testData(u);
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','','',null,null,true,null,null,null);
            //CG_CL_MyClaims_Table.ClaimsSearch('aka','test','test1','ConsolidatedClaimID','test3','test4','venkat',true);
            //CG_CL_MyClaims_Table.ClaimsSearch('aka','test','test1','Status','test3','test4',dt,true);
            //CG_CL_MyClaims_Table.ClaimsSearch('aka', 'test','test1',  'CCustomerName',  'test3',  'test4', 'tes95',true);
            ////CG_CL_MyClaims_Table.ClaimsSearch('aka', 'test','test1',  'ShopWorkOrder',  'test3',  'test4', 'test05',true);
            //CG_CL_MyClaims_Table.ClaimsSearch('aka', 'test','test1',  'ProductSerialNumber',  'test3',  'test4', 'test65',true);
            //CG_CL_MyClaims_Table.ClaimsSearch('aka', 'test','test1',  'All',  'test3',  'test4', 'test45',true);
        }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method11()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '56255';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56255';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56255';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Information Only';
        claimsSub.Individual_Claim_Id__c ='56270-56255';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Information Only';
        claimsSub1.Individual_Claim_Id__c ='56270-56255';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Information Only';
        claimsSub2.Individual_Claim_Id__c ='56270-56255';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Information Only';
        claimsSub3.Individual_Claim_Id__c ='56270-56255';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        testData(u);
        
        // system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','Not Authorized','','',null,null,true,null,null,null);
        //}
        Test.stopTest();
        
    }
    public static Testmethod void CG_CL_MyClaims_Method12()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        list<CSS_Claims__c> claimobj1=[select id,name from CSS_Claims__c];
        system.debug('claimobj1>>'+claimobj1);
        CSS_PSN__c psnlist=[select id,name,Primary__c,CSS_Claims__r.Name,CSS_Claims__r.Location__c,CSS_Claims__r.Status__c from CSS_PSN__c limit 1];
        system.debug('Primary__c >>>>>'+psnlist.CSS_Claims__r.Location__c);
        Date DR =system.today() - 30;
        CSS_PSN__c psnlist1=[SELECT Id, VIN__c,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c = 'Draft' AND CSS_Claims__r.Location__c ='562' AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND CSS_Claims__r.Name =:claimobj1[1].name ORDER BY LastModifiedDate DESC limit 1];
        system.debug('psnlist1>>'+psnlist1);
        //system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        
        //system.runAs(u){
        // CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Parts to Return','','','',null,null,true);
        // }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method13()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Draft','','','',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','view all','','','56270-56255',null,null,true,null,null,null);
        }
        Test.stopTest();
        
    }
    public static Testmethod void CG_CL_MyClaims_Method14()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        //system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Pending Authorization','','','',null,null,true,null,null,null);
        //}
        Test.stopTest();
        
    }
    public static Testmethod void CG_CL_MyClaims_Method15()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '56255';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        //claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56255';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56255';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        //claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Information Only';
        claimsSub.Individual_Claim_Id__c ='56270-56255';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Information Only';
        claimsSub1.Individual_Claim_Id__c ='56270-56255';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Information Only';
        claimsSub2.Individual_Claim_Id__c ='56270-56255';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Information Only';
        claimsSub3.Individual_Claim_Id__c ='56270-56255';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        
        
        testData(u);
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','Not Authorized','','',null,'1',true,null,null,null);
        }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method16()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        //system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','TestingforNegative','','','',null,null,true,null,null,null);
        //}
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method17()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            claimsObj2.LastSavedDate__c=Date.today();
            //claimsObj2.CSS_Claims__r.CSS_Job__r.Name = joorder.Id;
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            claimsObj.LastSavedDate__c=Date.today();
            //claimsObj2.CSS_Claims__r.CSS_Job__r.Name = '34354334';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            claimsObj1.LastSavedDate__c=Date.today();
            //claimsObj2.CSS_Claims__r.CSS_Job__r.Name = '34354334';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Status__c='Draft';
        claimObj.Information_Only_Claim__c=false;
        claimObj.Location_Code__c='56270-56255';
        claimObj.LastSavedDate__c=Date.today();
        insert claimObj;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub11 = new CSS_Claim_Submission__c();
        claimsSub11.CSS_Claims__c = claimObj.Id; 
        claimsSub11.Type__c = 'ytes';
        claimsSub11.Rejection_Reason__c='test';
        claimsSub11.Status__c= 'Information Only';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub11);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        CSS_PSN__c psnObj41 = new CSS_PSN__c();
        psnObj41.name = 'TestPSN';
        psnObj41.PSN__c = 'TestPSN123';
        psnObj41.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj41.CSS_Claims__c = claimObj.id;
        psnObj41.Service_Model__c = 'test';
        psnList.add(psnObj41);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        Test.startTest();
        
        
        
        
        // testData(u);
        
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ConsolidatedClaimID',''+claimsList[0].id+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','Status','Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',''+claimsList[0].Status__c+'Pending Authorization','1',true,null,null,null);
        // CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Parts to Return','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','view all','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','All','GuidanzTest',null,null,true);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        
        
        // }
        Test.stopTest();
        
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method19()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        }
        Test.stopTest();
        
    }
    public static Testmethod void CG_CL_MyClaims_Method20()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        //claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56270';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56270';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.Individual_Claim_Id__c ='56270-56255';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        claimsSub1.Individual_Claim_Id__c ='56270-56255';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Submitted';
        claimsSub2.Individual_Claim_Id__c ='56270-56255';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Submitted';
        claimsSub3.Individual_Claim_Id__c ='56270-56255';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        // testData(u);
        //system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('-All-','submitted','','','56270-56255',null,'1',true, null, null,'submitted');
        //}
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method21()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        //system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Guidanz','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        // }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method22()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Guidanz','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','In Review','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'In Review');
            //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Appealed/Resubmitted','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Appealed/Resubmitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Denied','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Denied');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','paid','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'paid');
            // CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Denied','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Denied');
        }
        Test.stopTest();
        
    }
    public static Testmethod void CG_CL_MyClaims_Method23()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        }
        Test.stopTest();
        
    }
    public static Testmethod void CG_CL_MyClaims_Method24()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.type = 'Customer';
        //acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56270');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        //claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56270';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56270';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        //claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.PartReturnToCenter__c = 'Y';
        claimsSub.Individual_Claim_Id__c ='56270-56270';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Information Only';
        claimsSub1.Individual_Claim_Id__c ='56270-56270';
        claimsSub1.PartReturnToCenter__c = 'Y';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Submitted';
        claimsSub2.PartReturnToCenter__c = 'Y';
        claimsSub2.Individual_Claim_Id__c ='56270-56270';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Submitted';
        claimsSub3.Individual_Claim_Id__c ='56270-56270';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        //testData(u);
        List<CSS_Claims__c> claimobj1=[select id,name from CSS_Claims__c];
        system.debug('claimobj1>>'+claimobj1);
        CSS_PSN__c psnlist2=[select id,name,Primary__c,CSS_Claims__r.Name,CSS_Claims__r.Location__c,CSS_Claims__r.Status__c from CSS_PSN__c limit 1];
        system.debug('Primary__c >>>>>'+psnlist2.CSS_Claims__r.Location__c);
        Date DR =system.today() - 30;
        CSS_PSN__c psnlist1=[SELECT Id, VIN__c,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c = 'Draft' AND CSS_Claims__r.Location__c ='562' AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND CSS_Claims__r.Name =:claimobj1[1].name ORDER BY LastModifiedDate DESC limit 1];
        system.debug('psnlist1>>'+psnlist1);
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','Status',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','CustomerName',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ShopWorkOrder',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ProductSerialNumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','VINAssetSerialNumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','GuidanzJobnumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','All',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Parts to Return');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','Status',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','CustomerName',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ShopWorkOrder',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ProductSerialNumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','VINAssetSerialNumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','GuidanzJobnumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','All',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Pending Authorization');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','Status',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','CustomerName',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ShopWorkOrder',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ProductSerialNumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','VINAssetSerialNumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','GuidanzJobnumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','All',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','VINAssetSerialNumber',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'Information Only');
            
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','submitted','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Information Only');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','submitted','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Pending Authorization');
        }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method25()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser44@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser44@testorg.com',User_Location__c = '03520-04893');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56271';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56255';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56255';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Parts to Return';
        claimsSub.Individual_Claim_Id__c ='56270-56255';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Parts to Return';
        claimsSub1.Individual_Claim_Id__c ='56270-56255';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Parts to Return';
        claimsSub2.Individual_Claim_Id__c ='56270-56255';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Submitted';
        claimsSub3.Individual_Claim_Id__c ='56270-56255';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        
        testData(u);
        list<CSS_Claims__c> claimobj1=[select id,name from CSS_Claims__c];
        system.debug('claimobj1>>'+claimobj1);
        CSS_PSN__c psnlist2=[select id,name,Primary__c,CSS_Claims__r.Name,CSS_Claims__r.Location__c,CSS_Claims__r.Status__c from CSS_PSN__c limit 1];
        system.debug('Primary__c >>>>>'+psnlist2.CSS_Claims__r.Location__c);
        Date DR =system.today() - 30;
        CSS_PSN__c psnlist1=[SELECT Id, VIN__c,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c = 'Draft' AND CSS_Claims__r.Location__c ='562' AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND CSS_Claims__r.Name =:claimobj1[1].name ORDER BY LastModifiedDate DESC limit 1];
        system.debug('psnlist1>>ptr'+psnlist1);
        CG_CL_MyClaims_Table.claimdelete(claimsObj1.Id);
        CG_CL_MyClaims_Table.deleteselecteddraftclaims('claim id');
        CG_CL_MyClaims_Table.CopyIconShowHide();
        system.runAs(u){
            //CG_CL_MyClaims_Table.ClaimsSearch( '-All-','submitted','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,'submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method26()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        /*   
Account acc = new Account();
acc.name='Rtest';
acc.CSS_DistributorCode__c='56270';
acc.IAM_Service_Provider_Code__c='56270';
acc.Enable_Claims__c = true;
//acc.Region__c = 'US and Canada';
acc.Type = 'Customer';
acc.CSS_DBCode__c = '33333';
acc.CMI_Account_Status__c = 'Active';
acc.IAM_Service_Provider_Code__c = '56270';
insert acc;
//  CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);

CSS_Claims__c claimsObj = new CSS_Claims__c();
claimsobj.Claim_Submitted__c = date.today();
// claimsobj.Name = 'claims';

claimsobj.Payment_Details__c = 'der';
claimsobj.Customer_Name__c = 'name';
claimsobj.Shop_Work_Order__c = 'wo';
claimsobj.Location__c = 'Rtest';
claimsobj.Status__c = 'Draft';
claimsobj.Account__c = acc.id;
claimsobj.Location_Code__c = '56270-56255';
claimsobj.Pending_Authorization__c = 'Authorization Required';
//claimsobj.Location__c = '562';
// claimsobj.CSS_Job__c = SerRec.id;
claimsobj.CreatedDate = system.today()-30;
insert claimsobj;

CSS_PSN__c psnObj = new CSS_PSN__c();
psnObj.name = 'TestPSN';
psnObj.PSN__c = 'TestPSN123';
psnObj.Primary__c = true;
psnObj.CSS_Claims__c = claimsobj.id;

insert psnObj;

list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
userloc1.UserId__c = u.Id;
userloc1.isActive__c = true;
userloc1.AccountId__c = acc.Id;
UserlocList.add(userloc1);
insert UserlocList;

CSS_PSN__c psnlist=[select id,name,Primary__c,CSS_Claims__r.Name,CSS_Claims__r.Location__c,CSS_Claims__r.Status__c from CSS_PSN__c limit 1];
system.debug('Primary__c >>>>>'+psnlist);
system.debug('claimobj1>>'+claimobj1+'PSN>>'+psnObj);*/
        testData(u);
        list<CSS_Claims__c> claimobj1=[select id,name from CSS_Claims__c];
        system.debug('claimobj1>>'+claimobj1);
        CSS_PSN__c psnlist=[select id,name,Primary__c,CSS_Claims__r.Name,CSS_Claims__r.Location__c,CSS_Claims__r.Status__c from CSS_PSN__c limit 1];
        system.debug('Primary__c >>>>>'+psnlist.CSS_Claims__r.Location__c);
        Date DR =system.today() - 30;
        CSS_PSN__c psnlist1=[SELECT Id, VIN__c,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c = 'Draft' AND CSS_Claims__r.Location__c ='562' AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND CSS_Claims__r.Name =:claimobj1[1].name ORDER BY LastModifiedDate DESC limit 1];
        system.debug('psnlist1>>'+psnlist1);
        //system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','Status',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','Pending Authorization','1',true,null,null,null);
        // CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Parts to Return','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','view all','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','view all','','ConsolidatedClaimID','CSS-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        // }
        Test.stopTest();
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method27()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        css_job_order__c joorder = css_testdata.createJobOrder(true);
        CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(true,joorder.Id);
        claimsObj2.OwnerId = u.Id;
        claimsObj2.LastSavedDate__c=date.today();
        CSS_Claims__c claimsobj = CSS_TestData.createclaims(true,joorder.Id);
        claimsObj.OwnerId = u.Id;
        claimsObj.LastSavedDate__c=date.today();
        CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(true,joorder.Id);
        claimsObj1.OwnerId = u.Id;
        claimsObj1.LastSavedDate__c=date.today();
        
        set<ID> lstClaimIds1 = new set<Id>();
        lstClaimIds1.add(claimsobj1.Id);
        lstClaimIds1.add(claimsObj.Id);
        lstClaimIds1.add(claimsObj2.Id);
        
        
        
        testData(u);
        //system.runAs(u){
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','view all','','GuidanzTest','ConsolidatedClaimID-CSS-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //}
        Test.stopTest();
        
    }
    
       public static Testmethod void CG_CL_MyClaims_Method33()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.ownerid=u.id;
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255',Location_Source__c = 'ARF',isClaims__c = true);
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();  
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            CSS_Claims__c claimsObj2 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj2.OwnerId = u.Id;
            claimsObj2.Location__c = '562';
            claimsObj2.LastSavedDate__c=Date.today();
            //claimsObj2.CSS_Claims__r.CSS_Job__r.Name = joorder.Id;
            CSS_Claims__c claimsobj = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj.OwnerId = u.Id;
            claimsObj.Location__c = '562';
            claimsObj.LastSavedDate__c=Date.today();
            //claimsObj2.CSS_Claims__r.CSS_Job__r.Name = '34354334';
            CSS_Claims__c claimsobj1 = CSS_TestData.createclaims(false,joorder.Id);
            claimsObj1.OwnerId = u.Id;
            claimsObj1.Location__c = '562';
            claimsObj1.LastSavedDate__c=Date.today();
            //claimsObj2.CSS_Claims__r.CSS_Job__r.Name = '34354334';
            set<ID> lstClaimIds1 = new set<Id>();
            lstClaimIds1.add(claimsobj1.Id);            
            claimsList.add(claimsObj2);
            claimsList.add(claimsObj);
            claimsList.add(claimsobj1);
            insert claimsList;
            
        }
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Status__c='Submitted';
        claimObj.Information_Only_Claim__c=false;
        claimObj.Location_Code__c='56270-56255';
        claimObj.LastSavedDate__c=Date.today();
        insert claimObj;
		
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        // claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.CSS_Claims__c = claimObj.Id; 
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Appealed/Resubmitted';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub11 = new CSS_Claim_Submission__c();
        claimsSub11.CSS_Claims__c = claimObj.Id; 
        claimsSub11.Type__c = 'ytes';
        claimsSub11.Rejection_Reason__c='test';
        claimsSub11.Status__c= 'Information Only';
        //claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub11);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.CSS_Claims__c = claimObj.Id; 
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Denied';
        //claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.CSS_Claims__c = claimObj.Id; 
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'In Review';
        claimsSub3.PartReturnToCenter__c = 'Y';
        //claimsSub3.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub3);
        CSS_Claim_Submission__c claimsSub31 = new CSS_Claim_Submission__c();
        claimsSub31.CSS_Claims__c = claimObj.Id; 
        claimsSub31.Type__c = 'ytes';
        claimsSub31.Rejection_Reason__c='test';
        claimsSub31.Status__c= 'Paid';
        claimsSub31.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub31);
        CSS_Claim_Submission__c claimsSub311 = new CSS_Claim_Submission__c();
        claimsSub311.CSS_Claims__c = claimObj.Id; 
        claimsSub311.Type__c = 'ytes';
        claimsSub311.Rejection_Reason__c='test';
        claimsSub311.Status__c= 'Paid';
        claimsSub311.PartReturnToCenter__c = 'Y';
        //claimsSub31.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub311);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        //psnobj1.CSS_Claims__r.status__c = 'Draft';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'test';
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnObj2.Service_Model__c = 'test';
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnObj3.Service_Model__c = 'test';
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnObj4.Service_Model__c = 'test';
        psnList.add(psnObj4);
        CSS_PSN__c psnObj41 = new CSS_PSN__c();
        psnObj41.name = 'TestPSN';
        psnObj41.PSN__c = 'TestPSN123';
        psnObj41.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj41.CSS_Claims__c = claimObj.id;
        psnObj41.Service_Model__c = 'test';
        psnList.add(psnObj41);
        insert psnList;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_GetClaimDetails';
        cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        cid.Timeout__c = 1200;
        cid.Method_Type__c ='POST';
        insert cid;
        
        List<CSS_JobEventTemporary__c> jvtList = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.name = 'TestPSN';
        jobEvt.attribute1__c = 'CategoryComplaintCodes';
        String json1 = '{'+    
            '  \"Header\": {'+
            '    \"ReturnCodeDescription\": \"test\",'+
            '    \"Status\": \"completed\"'+
            '      },'+
            '\"DataArea\": {'+
            '\"Details\": ['+
            '{'+
            '\"ComplaintCode\": \"123\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\": \"aaa\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1234\",'+
            '\"Description\": \"21319736\",'+
            '\"BusinessUnit\": \"inactive\",'+
            
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1235\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            
            '{'+
            '\"ComplaintCode\": \"1236\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '},'+
            '{'+
            '\"ComplaintCode\": \"1237\",'+
            '\"Description\": \"21319736\",'+
            
            '\"BusinessUnit\": \"inactive\",'+
            '\"Category\"    : \"1\"'+
            '}'+
            
            ']'+
            '}'+
            '}';
        jobEvt.Reason__c = json1;
        jvtList.add(jobEvt);
        insert jvtList;
        
        List<String> claimSubmissionId = new List<String>();
        for(CSS_Claim_Submission__c subIDLst : submID) {
            claimSubmissionId.add(subIDLst.CSS_Claims__c);
        }
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        Test.startTest();
        
        
        
        
        // testData(u);
        
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ConsolidatedClaimID',''+claimsList[0].id+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','Status','Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',''+claimsList[0].Status__c+'Pending Authorization','1',true,null,null,null);
        // CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Parts to Return','','ConsolidatedClaimID',''+claimobj1[1].name+'-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All','All','1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '-All-','view all','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','All','GuidanzTest',null,null,true);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Pending Authorization','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Information Only','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,'Information Only');
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Draft','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Submitted','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        //CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        
        
        // }
        Test.stopTest();
        
        
    }
    
    public static Testmethod void CG_CL_MyClaims_Method18()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        
        
        
        testData(u);
        system.runAs(u){
            CG_CL_MyClaims_Table.ClaimsSearch( '56270-56255','Parts to Return','','','',null,null,true,null,null,null);
        }
        Test.stopTest();
        
    }
    
    
    public static Testmethod void CG_CL_MyClaims_Method6()
    {
        String claimSubmitted='Test';
        String Id='null';
        String claimID=null;
        String status='Draft'; 
        String paymentDetails='Test';
        String customerName='Test';
        String shopWO='1234';
        //Added for Claim Hyper link
        string serviceJobId=null;        
        String prodSerialNum='1234';
        String serviceJob=null;
        string cvin='79464646';
        String location='Test';
        String lastSaved='Test';
        String lastSavedBy='Test';
        //CG_CL_MyClaims_Table.ClaimsWrap mcw=new CG_CL_MyClaims_Table.ClaimsWrap(claimSubmitted,id,claimID,status,paymentDetails,customerName,shopWO,serviceJobId,prodSerialNum,serviceJob,cvin,location,lastSaved,lastSavedBy);
        CG_CL_MyClaims_Table.ClaimsWrap cw;
        
        
    }
    public static Testmethod void TestClaimsWrap1()
    {
        String claimSubmitted='Test';
        String Id='null';
        String claimID=null;
        String status='Draft'; 
        String paymentDetails='Test';
        String customerName='Test';
        String Pending_Authorization='Authorization Required';
        String shopWO='1234';
        //Added for Claim Hyper link
        string serviceJobId=null;        
        String prodSerialNum='1234';
        String serviceJob=null;
        string cvin='79464646';
        String location='Test';
        String lastSaved='Test';
        String lastSavedBy='Test';  
    }
    
    public static void testData(User u){
        
        String grpName = 'CQ'+'-'+'56270-56255';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            Account acc = new Account();
            acc.name='562';
            acc.CSS_DistributorCode__c='56270';
            acc.IAM_Service_Provider_Code__c='56270';
            acc.Enable_Claims__c = true;
            acc.Region__c = 'US and Canada';
            acc.type = 'Dealer account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;
            //User Location
            list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
            CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56255');
            lstUserLocations.add(userLocation);
            insert lstUserLocations;
            
            list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
            CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
            userloc1.UserId__c = u.Id;
            userloc1.isActive__c = true;
            userloc1.AccountId__c = acc.Id;
            UserlocList.add(userloc1);
            insert UserlocList;
            
            //Job Order
            CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
            
            
            
            //Claims
            List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
            CSS_Claims__c claimsObj = new CSS_Claims__c();
            claimsobj.Claim_Submitted__c = date.today();
            claimsobj.Rejection_Comments__c = 'rejected';
            // claimsobj.Name = 'claims';
            
            claimsobj.Payment_Details__c = 'der';
            claimsobj.Customer_Name__c = 'name';
            claimsobj.Shop_Work_Order__c = 'wo';
            claimsobj.Location__c = 'code';
            claimsobj.Status__c = 'Submitted';
            claimsobj.Account__c = acc.id;
            claimsobj.Location_Code__c = '56270-56255';
            claimsobj.Pending_Authorization__c = 'Authorization Required';
            claimsobj.Location__c = '562';
            claimsobj.CSS_Job__c = SerRec.id;
            claimsList.add(claimsObj);
            CSS_Claims__c claimsObj1 = new CSS_Claims__c();
            claimsObj1.Claim_Submitted__c = date.today();
            // claimsobj.Name = 'claims';
            
            claimsObj1.Payment_Details__c = 'der';
            claimsObj1.Customer_Name__c = 'name';
            claimsObj1.Shop_Work_Order__c = 'wo';
            //claimsObj1.Location__c = 'code';
            claimsObj1.Status__c = 'Draft';
            claimsObj1.Pending_Authorization__c = 'Authorization Required';
            claimsObj1.Account__c = acc.id;
            claimsObj1.Location_Code__c = '56270-56255';
            
            claimsObj1.Location__c = '562';
            claimsObj1.Rejection_Comments__c = 'rejected';
            claimsObj1.CSS_Job__c = SerRec.id;
            claimsList.add(claimsObj1);
            CSS_Claims__c claimsObj2 = new CSS_Claims__c();
            claimsObj2.Claim_Submitted__c = date.today();
            // claimsobj.Name = 'claims';
            
            claimsObj2.Payment_Details__c = 'der';
            claimsObj2.Customer_Name__c = 'name';
            claimsObj2.Shop_Work_Order__c = 'wo';
            claimsObj2.Location__c = '562';
            claimsObj2.Status__c = 'Not Authorized';
            claimsObj2.Pending_Authorization__c = 'Authorization Required';
            claimsObj2.Account__c = acc.id;
            claimsObj2.Rejection_Comments__c = 'rejected';
            claimsObj2.Location_Code__c = '56270-56255';
            claimsObj2.Location__c = '562';
            claimsObj2.CSS_Job__c = SerRec.id;
            claimsList.add(claimsObj2);
            insert claimsList;
            CSS_Job_Order__c SerRec12 = CSS_TestData.createJobOrder(true);
            SerRec12.Claim_ID__c=claimsList[0].id;
            SerRec12.Sub_Status__c = 'Ready for Claim Creation';
            update SerRec12;
            //Claim Submission 
            List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
            CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
            claimsSub.Type__c = 'ytes';
            claimsSub.Rejection_Reason__c='test';
            claimsSub.Status__c= 'Submitted';
            claimsSub.Individual_Claim_Id__c ='56270-56255';
            claimsSub.CSS_Claims__c=claimsList[0].id;
            submID.add(claimsSub);
            CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
            claimsSub1.Type__c = 'ytes';
            claimsSub1.Rejection_Reason__c='test';
            claimsSub1.Status__c= 'Pending Authorization';
            claimsSub1.Individual_Claim_Id__c ='56270-56255';
            claimsSub1.CSS_Claims__c=claimsList[0].id;
            submID.add(claimsSub1);
            CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
            claimsSub2.Type__c = 'ytes';
            claimsSub2.Rejection_Reason__c='test';
            claimsSub2.Status__c= 'Information Only';
            claimsSub2.Individual_Claim_Id__c ='56270-56255';
            claimsSub2.CSS_Claims__c=claimsList[0].id;
            submID.add(claimsSub2);
            CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
            claimsSub3.Type__c = 'ytes';
            claimsSub3.Rejection_Reason__c='test';
            claimsSub3.Status__c= 'Submitted';
            claimsSub3.Individual_Claim_Id__c ='56270-56255';
            claimsSub3.PartReturnToCenter__c = 'Y';
            claimsSub3.CSS_Claims__c=claimsList[1].id;
            submID.add(claimsSub3);
            insert submID;
            
            
            
            List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
            //PSN
            List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
            CSS_PSN__c psnObj = new CSS_PSN__c();
            psnObj.name = 'TestPSN';
            psnObj.PSN__c = 'TestPSN123';
            psnObj.Primary__c = true;
            psnObj.CSS_Claims__c = claimsList[0].id;
            psnList.add(psnObj);
            CSS_PSN__c psnObj1 = new CSS_PSN__c();
            psnObj1.name = 'TestPSN';
            psnObj1.PSN__c = 'TestPSN123';
            psnObj1.Primary__c = true;
            psnObj1.CSS_Claims__c = claimsList[0].id;
            psnList.add(psnObj1);
            
            CSS_PSN__c psnObj2 = new CSS_PSN__c();
            psnObj2.name = 'TestPSN';
            psnObj2.PSN__c = 'TestPSN123';
            psnObj2.Primary__c = true;
            //psnObj2.CSS_Claims__r.status__c = 'Draft';
            psnObj2.CSS_Claims__c = claimsList[1].id;
            psnList.add(psnObj2);
            
            CSS_PSN__c psnObj3 = new CSS_PSN__c();
            psnObj3.name = 'TestPSN';
            psnObj3.PSN__c = 'TestPSN123';
            psnObj3.Primary__c = true;
            //psnObj2.CSS_Claims__r.status__c = 'Draft';
            psnObj3.CSS_Claims__c = claimsList[1].id;
            psnList.add(psnObj3);
            
            CSS_PSN__c psnObj4 = new CSS_PSN__c();
            psnObj4.name = 'TestPSN';
            psnObj4.PSN__c = 'TestPSN123';
            psnObj4.Primary__c = true;
            //psnObj2.CSS_Claims__r.status__c = 'Draft';
            psnObj4.CSS_Claims__c = claimsList[2].id;
            psnList.add(psnObj4);
            insert psnList;
            
            CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
            cid.name = 'CSS_SBL_GetClaimDetails';
            cid.ApplicationName__c = 'CSS_SBL_GetClaimDetails';
            cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
            cid.Timeout__c = 1200;
            cid.Method_Type__c ='POST';
            insert cid;
        }
    }
    
    public static Testmethod void ClaimsSearchMethod(){
        Test.startTest();
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Draft','','GuidanzTest','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
        
        Test.stopTest();      
    }
    public static Testmethod void CG_CL_MyClaims_Method32()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');
        insert u;
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        //acc.Region__c = 'US and Canada';
        acc.Type = 'Customer';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        //User Location
        list<CSS_UserLocation__c> lstUserLocations = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='56270-56270');
        lstUserLocations.add(userLocation);
        insert lstUserLocations;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userloc1 = new CSS_UserLocation__c();
        userloc1.UserId__c = u.Id;
        userloc1.isActive__c = true;
        userloc1.AccountId__c = acc.Id;
        userloc1.isPrimary__c=true;
        userloc1.Location_Source__c = 'ARF';
        userloc1.isClaims__c = true;
        UserlocList.add(userloc1);
        insert UserlocList;
        
        //Job Order
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        
        
        
        //Claims
        List<CSS_Claims__c> claimsList = new list<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        // claimsobj.Name = 'claims';
        
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        //claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56270';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        claimsobj.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj);
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj1.Payment_Details__c = 'der';
        claimsObj1.Customer_Name__c = 'name';
        claimsObj1.Shop_Work_Order__c = 'wo';
        //claimsObj1.Location__c = 'code';
        claimsObj1.Status__c = 'Draft';
        claimsObj1.Pending_Authorization__c = 'Authorization Required';
        claimsObj1.Account__c = acc.id;
        claimsObj1.Location_Code__c = '56270-56270';
        
        claimsObj1.Location__c = '562';
        claimsObj1.Rejection_Comments__c = 'rejected';
        claimsObj1.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj1);
        CSS_Claims__c claimsObj2 = new CSS_Claims__c();
        claimsObj2.Claim_Submitted__c = date.today();
        // claimsobj.Name = 'claims';
        
        claimsObj2.Payment_Details__c = 'der';
        claimsObj2.Customer_Name__c = 'name';
        claimsObj2.Shop_Work_Order__c = 'wo';
        //claimsObj2.Location__c = '562';
        claimsObj2.Status__c = 'Not Authorized';
        claimsObj2.Pending_Authorization__c = 'Authorization Required';
        claimsObj2.Account__c = acc.id;
        claimsObj2.Rejection_Comments__c = 'rejected';
        claimsObj2.Location_Code__c = '56270-56255';
        claimsObj2.Location__c = '562';
        claimsObj2.CSS_Job__c = SerRec.id;
        claimsList.add(claimsObj2);
        insert claimsList;
        
        //Claim Submission 
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.Individual_Claim_Id__c ='56270-56255';
        claimsSub.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        claimsSub1.Individual_Claim_Id__c ='56270-56255';
        claimsSub1.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub1);
        CSS_Claim_Submission__c claimsSub2 = new CSS_Claim_Submission__c();
        claimsSub2.Type__c = 'ytes';
        claimsSub2.Rejection_Reason__c='test';
        claimsSub2.Status__c= 'Submitted';
        claimsSub2.Individual_Claim_Id__c ='56270-56255';
        claimsSub2.CSS_Claims__c=claimsList[0].id;
        submID.add(claimsSub2);
        CSS_Claim_Submission__c claimsSub3 = new CSS_Claim_Submission__c();
        claimsSub3.Type__c = 'ytes';
        claimsSub3.Rejection_Reason__c='test';
        claimsSub3.Status__c= 'Submitted';
        claimsSub3.Individual_Claim_Id__c ='56270-56255';
        claimsSub3.PartReturnToCenter__c = 'Y';
        claimsSub3.CSS_Claims__c=claimsList[1].id;
        submID.add(claimsSub3);
        insert submID;
        
        
        
        List<CSS_psn__c> psnLst = new List<CSS_psn__c>();
        //PSN
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        
        CSS_PSN__c psnObj2 = new CSS_PSN__c();
        psnObj2.name = 'TestPSN';
        psnObj2.PSN__c = 'TestPSN123';
        psnObj2.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj2.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj2);
        
        CSS_PSN__c psnObj3 = new CSS_PSN__c();
        psnObj3.name = 'TestPSN';
        psnObj3.PSN__c = 'TestPSN123';
        psnObj3.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj3.CSS_Claims__c = claimsList[1].id;
        psnList.add(psnObj3);
        
        CSS_PSN__c psnObj4 = new CSS_PSN__c();
        psnObj4.name = 'TestPSN';
        psnObj4.PSN__c = 'TestPSN123';
        psnObj4.Primary__c = true;
        //psnObj2.CSS_Claims__r.status__c = 'Draft';
        psnObj4.CSS_Claims__c = claimsList[2].id;
        psnList.add(psnObj4);
        insert psnList;
        
        
        
        // testData(u);
        system.runAs(u){         
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,'12/12/2019','12/12/2019',null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            // CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            //CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Pending Authorization','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Information Only','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Draft','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','ConsolidatedClaimID','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,null,true,null,null,null);
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','Status','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','CustomerName','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','ShopWorkOrder','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','ProductSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','VINAssetSerialNumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
            CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','GuidanzJobnumber','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
           // CG_CL_MyClaims_Table.ClaimsSearch( '-All-','Submitted','','All','ConsolidatedClaimID-Status-CustomerName-ShopWorkOrder-ProductSerialNumber-VINAssetSerialNumber-GuidanzJobnumber-All',null,'1',true,null,null,'Submitted');
            
        }
        Test.stopTest();
        
        
    }
    
    public static testmethod void TMethod1(){
        
        CSS_claims__c claimObj = new CSS_claims__c();
        claimObj.OwnerId = UserInfo.getUserId();
        claimObj.Location__c = '562';
        claimObj.Status__c='Parts to Return';
        insert claimObj;
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimObj.id;
        psnObj.Service_Model__c = 'test';
        psnList.add(psnObj);
        insert psnList;
        
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimObj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Parts to Return';
        submID.add(claimsSub);
        insert submID;
        
        
        
        Test.startTest();
        CG_CL_MyClaims_table Table = new CG_CL_MyClaims_table();
        CG_CL_MyClaims_table.listClaim = psnList;
        CG_CL_MyClaims_table.listClaimsub = submID;
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','Parts to Return','','S012345','',null,null,false,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','View all','','S012345','CSS',null,null,false,null,null,null);
        CG_CL_MyClaims_Table.ClaimsSearch('56270-56255','test','','S012345','CSS-102030',null,null,false,null,null,null);
        Test.stopTest();
        
    }
    
}