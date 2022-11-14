@isTest
public class CG_BL_Claims_Test 
{
    
     Public static testmethod void TMethod1(){
         
     	CG_BL_Claims Claim = new CG_BL_Claims();
        CG_BL_Claims.performClaimCreationBusinessLogic();
     } 
        
     Public static testmethod void TMethod2(){ 
        
        list<CSS_JobEventTemporary__c> jobEventlstRef = new list<CSS_JobEventTemporary__c>();
        
        Test.startTest();  
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'SiebelClaimHistory';
         cid.ApplicationName__c = 'SiebelClaimHistory';
         cid.End_Point__c = 'https://services-test.cummins.com/csswarranty/claimhistory';
         cid.logging__c = 'BOTH';
         cid.AuthEnv__c = 'OAGOAuthTest';
         cid.Method_Type__c = 'POST';
         cid.Timeout__c = 120000;
         insert cid;
        
        Test.setMock(HttpCalloutMock.class, new CG_SL_BMSMock_Test2());
              
        CG_BL_Claims Claim = new CG_BL_Claims();
        jobEventlstRef = CG_BL_Claims.performClaimHistoryBusinessLogic('79464646');
        Test.stopTest(); 
    }

     Public static testmethod void TMethod3(){ 
        
        list<CSS_JobEventTemporary__c> jobEventlstRef1 = new list<CSS_JobEventTemporary__c>();
        
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CSS_WS_OAGMock_Test1()); 
              
        CG_BL_Claims Claim = new CG_BL_Claims();
        jobEventlstRef1 = CG_BL_Claims.performClaimHistoryBusinessLogic('79464646');
        Test.stopTest(); 
    }

     Public static testmethod void TMethod4(){ 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];     
        
        userRole r = [Select id from UserRole where name='Factory'];
        
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, userroleid=r.id,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        
        Test.startTest();
        UserlocList = CG_BL_Claims.fetchMultiLocation();
        system.runAs(u){
            
        Account acc = new Account();
        acc.name='Rtest';
        acc.Enable_Claims__c = true;
        acc.CSS_DistributorCode__c='03742';
        acc.IAM_Service_Provider_Code__c='03742';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
    
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742',isClaims__c = true,Location_Source__c = 'ARF');
        insert userLocation;
		
            
        	UserlocList = CG_BL_Claims.fetchMultiLocation();
        }
        test.stopTest();
        } 
    
     Public static testmethod void TMethod5(){
        
        test.startTest();
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.IAM_Service_Provider_Code__c='03742';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
         
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
         jo.Account__c=acc.id;
         update jo;
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Account__C = acc.id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = True;
        insert claimsObj;
        claimsList.add(claimsObj );
        //insert claimsList;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        
        list<CSS_JobEventTemporary__c> jobEventlstRef = new list<CSS_JobEventTemporary__c>();
         CSS_JobEventTemporary__c joObj= new CSS_JobEventTemporary__c();
         joObj.Attribute1__c='POL';
         joObj.Attribute2__c = 'ZCK POLICY CLAIMS';
         joObj.Attribute3__c='ZK';
         joObj.Key__c='AccountCodes';
         jobEventlstRef.add(joObj);
         insert jobEventlstRef;
        
        
        
        List<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solcomp.CSS_Claims__c=claimsobj.id;
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Claim_Type__c = 'Test';
        solComp.Selected_Claim_Type__c = 'Testing';
        solComp.Performed_Review__c = true;
        solComp.Status__c = 'Approved';
        solComp.Complete_Indicator__c =true;
        solComp.Multiple_Times__c =true;
        solComp.Fault_Code__c='turbocharger';
        solComp.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp.AccountCode__c = '27';
        solComp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp.add(solcomp);
        
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Component_Id__c ='F0051000';
        solComp1.Service_Job__c = Jo.id;
        solComp1.Action__c = '';
        solComp1.Type__c = 'Campaign';
        solcomp1.CSS_Claims__c=claimsobj.id;
        solComp1.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp1.CampaignPartsPercentage__c = '20';
        solcomp1.Performed_Review__c = True;
        solcomp1.Claim_Type__c = 'Test';
        solComp1.Selected_Claim_Type__c = 'Testing';
        solComp1.Performed_Review__c = false;
        solComp1.Status__c = 'Approved';
        solComp1.Complete_Indicator__c =true;
        solComp1.Multiple_Times__c =true;
        solComp1.Fault_Code__c='turbocharger';
        solComp1.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp1.AccountCode__c = '27';
        solComp1.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp.add(solcomp1);
         CSS_Solution_Component__c solComp12 = new CSS_Solution_Component__c();
        solComp12.Component_Id__c ='F0051000';
        solComp12.Service_Job__c = Jo.id;
        solComp12.Action__c = '';
        solComp12.Type__c = 'Campaign';
        solcomp12.CSS_Claims__c=claimsobj.id;
        solComp12.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp12.CampaignPartsPercentage__c = '20';
        solcomp12.Performed_Review__c = True;
        solcomp12.Claim_Type__c = 'Test';
        solComp12.Selected_Claim_Type__c = 'Testing';
        solComp12.Performed_Review__c = true;
        solComp12.Status__c = 'Approved';
        solComp12.Complete_Indicator__c =true;
        solComp12.Multiple_Times__c =true;
        solComp12.Fault_Code__c='turbocharger';
        solComp12.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp12.AccountCode__c = '27';
        solComp12.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp.add(solcomp12);
        insert lstsolcomp;
        
        List<CSS_SRT__c> lstsrt = new list<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        //srt.Job_Order__c = jo.id;
        srt.SRT_ID__c = 'Test';
        //srt.SRT_Type__c = 'Diag Access';
        //srt.SRT_Category__c = 'AdditionalRep';
        srt.CSS_Claims__c =claimsobj.id ;
        srt.Component_Id__c = solComp.id;
        srt.Solution_Number__c = solAdd.id;
        lstsrt.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.SRT_ID__c = 'Test1';
        srt1.CSS_Claims__c =claimsobj.id ;
        srt1.Component_Id__c = solComp1.id;
        srt1.Solution_Number__c = solAdd.id;
        lstsrt.add(srt1);
         CSS_SRT__c srt111 = new CSS_SRT__c();
        srt111.SRT_ID__c = 'Test1';
        srt111.CSS_Claims__c =claimsobj.id ;
        srt111.Component_Id__c = solComp12.id;
       // srt111.Solution_Number__c = null;
         srt111.Job_Order__c = jo.id;
        lstsrt.add(srt111);
        insert lstsrt;
        
       RecordType rtbms = [SELECT id,Name 
                                FROM RecordType 
                                WHERE name='BMS Parts'];
       RecordType rtoc = [SELECT id,Name 
                               FROM RecordType 
                               WHERE name='OtherClaimables'];
            
       RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts'];
                              
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
                parts.selected_part__c = True;
                parts.Tracking_Number__c = null;
                parts.Service_partnumber__c = '540571401';
                parts.Part_Name__c = 'TestPart';
            	parts.Parts_Type__c = 'Custom';
                parts.ReturnToFactory__c = 'Y';
                parts.Replacement_Reason__c = 'Campaign-TRP-ATC';
                parts.Quantity__c = 55;
                parts.Notes__c = 'Test Notes';
                parts.CSS_Claims__c = claimsObj.id;
                parts.recordtypeid = rtbms.id;
                parts.Service_Job__c = Jo.id;
                parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
                parts.Fail_Code__c='THAC';
                parts.Covered__c = 100;
                lstparts.add(parts);
             CSS_Parts_Options__c partsn = new CSS_Parts_Options__c();
                partsn.selected_part__c = True;
                partsn.Tracking_Number__c = null;
                partsn.Service_partnumber__c = '540571401';
                partsn.Part_Name__c = 'TestPart';
            	partsn.Parts_Type__c = 'Customs';
                partsn.ReturnToFactory__c = 'Y';
                partsn.Replacement_Reason__c = 'Campaign-TRP-ATC';
                partsn.Quantity__c = 55;
                partsn.Notes__c = 'Test Notes';
                partsn.CSS_Claims__c = claimsObj.id;
                partsn.recordtypeid = rtbms.id;
                partsn.Service_Job__c = Jo.id;
                partsn.Account_Code__c='SERVICE TOOL WARRANTY 52';
                partsn.Fail_Code__c='THAC';
                partsn.Covered__c = 100;
         partsn.recordtypeId=rtp.id;
                lstparts.add(partsn);
            
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
                parts1.selected_part__c = True;
                parts1.Type__c = 'LODGE- FSE';
                parts1.Service_partnumber__c = '540571401';
                parts1.OEM__c = 'OEMWRS';
                parts1.Part_Name__c = 'TestPartCamp';
                parts1.ReturnToFactory__c = 'Campaign-TRP-ATC';
                parts1.Replacement_Reason__c = 'Campaign-TRP-ATC';
                parts1.Quantity__c = 55;
                parts1.Notes__c = 'Test Notes';
                parts1.CSS_Claims__c = claimsObj.id;
                parts1.recordtypeid=rtoc.id;
                parts1.Service_Job__c = Jo.id;
                parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
                parts1.Fail_Code__c='THAC';
                lstparts.add(parts1);
                
            CSS_Parts_Options__c parts2 = new CSS_Parts_Options__c();
                parts2.selected_part__c = True;
                parts2.Service_partnumber__c = '540571401';
                parts2.OEM__c = 'OEMWRS';
                parts2.Part_Name__c = 'TestPartCamp';
                parts2.ReturnToFactory__c = 'Campaign-TRP-ATC';
                parts2.Replacement_Reason__c = 'Campaign-TRP-ATC';
                parts2.Quantity__c = 55;
                parts2.Notes__c = 'Test Notes';
                parts2.CSS_Claims__c = claimsObj.id;
                parts2.recordtypeid=rtp.id;
                parts2.Service_Job__c = Jo.id;
                parts2.Account_Code__c='SERVICE TOOL WARRANTY 52';
                parts2.Fail_Code__c='THAC';
                lstparts.add(parts2);   
                
                
             CSS_Parts_Options__c parts3 = new CSS_Parts_Options__c();
                parts3.selected_part__c = True;
                parts3.Type__c = 'MEAL- FSE';
                parts3.CSS_Claims__c = claimsObj.id;
                parts3.recordtypeid=rtoc.id;
                parts3.Service_Job__c = Jo.id;
                lstparts.add(parts3); 
                
                CSS_Parts_Options__c parts4 = new CSS_Parts_Options__c();
                parts4.selected_part__c = True;
                parts4.Type__c = 'MEAL- FSPG';
                parts4.CSS_Claims__c = claimsObj.id;
                parts4.recordtypeid=rtoc.id;
                parts4.Service_Job__c = Jo.id;
                lstparts.add(parts4);
                
                CSS_Parts_Options__c parts5 = new CSS_Parts_Options__c();
                parts5.selected_part__c = True;
                parts5.Type__c = 'MILE WARR FSE';
                parts5.CSS_Claims__c = claimsObj.id;
                parts5.recordtypeid=rtoc.id;
                parts5.Service_Job__c = Jo.id;
                lstparts.add(parts5);
                
                CSS_Parts_Options__c parts6 = new CSS_Parts_Options__c();
                parts6.selected_part__c = True;
                parts6.Type__c = 'MILE WARR FSPG';
                parts6.CSS_Claims__c = claimsObj.id;
                parts6.recordtypeid=rtoc.id;
                parts6.Service_Job__c = Jo.id;
                lstparts.add(parts6); 
                
                
                
                insert lstparts;                      
        
        
        CG_BL_Claims.cloneAutomatedCampaigns(JO.id,'79464646',claimsList[0].id,SerRec.id,True,'Distributor',True);
        CG_BL_Claims.cloneAutomatedCampaigns(JO.id,'79464646',claimsList[0].id,SerRec.id,False,'Dealer Account',true);
        
        test.stopTest();
        
    }
    
     Public static testmethod void TMethod6(){
         
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.IAM_Service_Provider_Code__c='03742';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;     
        
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
         jo.Account__c=acc.id;
         update jo;
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Account__C = acc.id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = True;
        insert claimsObj;
        claimsList.add(claimsObj );
        //insert claimsList;
        
        
        
        List<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solcomp.CSS_Claims__c=claimsObj.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Claim_Type__c = 'Test';
        solComp.Selected_Claim_Type__c = 'Testing';
        solComp.Performed_Review__c = true;
        solComp.Status__c = 'Approved';
        solComp.Complete_Indicator__c =true;
        solComp.Multiple_Times__c =true;
        solComp.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp.AccountCode__c = '27';
        solComp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        solComp.OldSolCompID__c = 'Test-Test';
CSS_Solution_Component__c solComp12 = new CSS_Solution_Component__c();
        solComp12.Component_Id__c ='F0051000';
        solComp12.Service_Job__c = Jo.id;
        solComp12.Action__c = '';
        solComp12.Type__c = 'Campaign';
        solcomp12.CSS_Claims__c=claimsobj.id;
        solComp12.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp12.CampaignPartsPercentage__c = '20';
        solcomp12.Performed_Review__c = True;
        solcomp12.Claim_Type__c = 'Test';
        solComp12.Selected_Claim_Type__c = 'Testing';
        solComp12.Performed_Review__c = true;
        solComp12.Status__c = 'Approved';
        solComp12.Complete_Indicator__c =true;
        solComp12.Multiple_Times__c =true;
        solComp12.Fault_Code__c='turbocharger';
        solComp12.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp12.AccountCode__c = '27';
        solComp12.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        lstsolcomp.add(solcomp12);
        lstsolcomp.add(solcomp);
        insert lstsolcomp;
        List<recordtype> rdp = [select Id, Name from recordtype where Name = :'Parts' OR name= 'OtherClaimables' order by name asc];
        list<CSS_Parts_Options__c> lstpart = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
            partobj.Account_Code__c='test';
            partobj.recordtypeid = rdp[1].id;
            partobj.Address1__c = 'test';
            partobj.City__c = 'test';
            partobj.Service_Job__c = jo.id;
            partobj.Account_Code__c = 'test';
            partobj.FailurepartId__c = solComp.id;
            lstpart.add(partobj);
            
        CSS_Parts_Options__c partobj1 = new CSS_Parts_Options__c();
            partobj1.Account_Code__c='test';
            //partobj1.Type__c = 'LODGE- FSE';
            partobj1.recordtypeid = rdp[0].id;
            partobj1.CSS_Claims__c = claimsObj.id;
            partobj1.Address1__c = 'test';
            partobj1.City__c = 'test';
            partobj1.Service_Job__c = jo.id;
            partobj1.Account_Code__c = 'test';
            partobj1.Siebel_Value__c = 'Unlisted';
            partobj1.type__c = 'TOLLS-FSPG';
            partobj.FailurepartId__c = solComp.id;
            lstpart.add(partobj1);
        
         CSS_Parts_Options__c parts3 = new CSS_Parts_Options__c();
                parts3.selected_part__c = True;
                parts3.Type__c = 'MEAL- FSE';
                parts3.CSS_Claims__c = claimsObj.id;
                parts3.recordtypeid=rdp[0].id;
                parts3.Service_Job__c = Jo.id;
                lstpart.add(parts3); 
                
        CSS_Parts_Options__c parts4 = new CSS_Parts_Options__c();
                parts4.selected_part__c = True;
                parts4.Type__c = 'MEAL- FSPG';
                parts4.CSS_Claims__c = claimsObj.id;
                parts4.recordtypeid=rdp[0].id;
                parts4.Service_Job__c = Jo.id;
                lstpart.add(parts4);
                
        CSS_Parts_Options__c parts5 = new CSS_Parts_Options__c();
                parts5.selected_part__c = True;
                parts5.Type__c = 'MILE WARR FSE';
                parts5.CSS_Claims__c = claimsObj.id;
                parts5.recordtypeid=rdp[0].id;
                parts5.Service_Job__c = Jo.id;
                lstpart.add(parts5);
                
        CSS_Parts_Options__c parts6 = new CSS_Parts_Options__c();
                parts6.selected_part__c = True;
                parts6.Type__c = 'MILE WARR FSPG';
                parts6.CSS_Claims__c = claimsObj.id;
                parts6.recordtypeid=rdp[0].id;
                parts6.Service_Job__c = Jo.id;
                lstpart.add(parts6); 
                
        
        insert lstpart;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        list < Attachment > attachList = new list < Attachment > ();
        Attachment attach = new Attachment();
        attach.Name = 'Unit Test Attachment1';
        Blob bodyBlob1 = Blob.valueOf('Unit Test Attachment Body');
        attach.body = bodyBlob1;
        attach.parentId = jo.id;
        attachList.add(attach);
        insert attachList;
        
        List<css_srt__c> lstSrt = new List<css_srt__c>();
        css_srt__c srt = new css_srt__c();
        srt.CSS_Claims__c=claimsObj.id;
        //srt.Job_Order__c=jo.Id;
        srt.Step_Id__c='1';
        srt.SRT_ID__c='1';
        srt.Component_Id__c = solcomp.id;
        srt.Account_Code__c='test';
        SRT.SRT_Title__c='Non-SRT detail';
        srt.Type__c='Diagnosis';
        srt.FailCode__c = 'Test';
        srt.SRT_Type__c = 'Test';
        srt.SRT_AccessiblityCheck__c=true;
        srt.SRT_Estimate__c=false;
        srt.isPerformed__c = true;
        srt.Solution_Number__c = solAdd.id;
        srt.SRT_Category__c='AdditionalRep'; 
        lstSrt.add(srt);
         CSS_SRT__c srt111 = new CSS_SRT__c();
        srt111.SRT_ID__c = 'Test1';
        srt111.CSS_Claims__c =claimsObj.id ;
        srt111.Component_Id__c = solComp12.id;
       // srt111.Solution_Number__c = null;
         srt111.Job_Order__c = jo.id;
        lstsrt.add(srt111);
        css_srt__c srt1 = new css_srt__c();
        srt1.CSS_Claims__c=claimsObj.id;
        //srt1.Job_Order__c=jo.Id;
        srt1.Step_Id__c='1';
        srt1.SRT_ID__c='1';
        srt1.Component_Id__c = solcomp.id;
        srt1.Account_Code__c='test';
        SRT1.SRT_Title__c='Non-SRT detail';
        srt1.Type__c='Diagnosis';
        srt1.FailCode__c = 'Test';
        srt1.SRT_Type__c = 'Test';
        srt1.SRT_AccessiblityCheck__c=true;
        srt1.SRT_Estimate__c = false;
        srt1.isPerformed__c = true;
        srt1.Solution_Number__c = solAdd.id;
        srt1.SRT_Category__c='AdditionalRep'; 
        lstSrt.add(srt1);
        insert lstSrt;
        
        List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        ctt.Type__c = 'ATC';
        ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt.Doc_Num__c = 'ATCF0051000';
        ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt.Performed__c = false;
        ctt.Performed_Review__c = true;
        ctt.Reviewed__c = false;
        ctt.Job_Order__c = JO.Id;
        ctt.ESN__c = JO.ESN__c;
        ctt.CSS_Claims__c = claimsObj.id;
        ctt.cu_language__C = 'fr';
        insert ctt;
        lstCAM.add(ctt);
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'GetCampaign';
        cid.ApplicationName__c = 'GetCampaign';
        cid.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
        cid.logging__c = 'SUCCESS';
        cid.AuthEnv__c = 'OAGOAuth';
        cid.Method_Type__c = 'POST';
        cid.Timeout__c = 120000;
        insert cid;
        
       CG_BL_Claims.cloneAutomatedCampaigns(jo.id,'79464646',claimsList[0].id,SerRec.id,True,'Test',False);
       CG_BL_Claims.cloneCopyCampaigns(claimsList[0].id,'79464646',claimsList[0].id);
       
        test.startTest();
        List<SelectOption> claimTypeList = new List<SelectOption>();
        // Set mock callout class    
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        CG_BL_Claims.psnTabOff('79384192');
        CG_BL_Claims.dealercloneAutomatedCampaigns(jo.id,'79464646',claimsList[0].id,SerRec.id,'test',False);
        CG_BL_Claims.getClaimType(claimsList[0].id, 'location', 'JobPlan');
        CG_BL_Claims.getClaimType(null,'','JobPlan');
        test.stopTest();
    }
    
     Public static testMethod void TMethod7(){
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());   
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        //Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
       CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        CSS_getEngineDataReqJ2A enginereq = new CSS_getEngineDataReqJ2A();        
        CSS_getEngineDataReqJ2A.DataArea Req = new CSS_getEngineDataReqJ2A.DataArea();
        Req.ESN='79384192';
        enginereq.DataArea = Req;        
        CSS_getEngineDataResponseJ2A engineData = new CSS_getEngineDataResponseJ2A(); 
        Test.startTest(); 
        
        CG_BL_Claims.psnTabOff('79464646');
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'GetCampaign';
         cid.ApplicationName__c = 'GetCampaign';
         cid.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
         cid.logging__c = 'SUCCESS';
         cid.AuthEnv__c = 'OAGOAuth';
        cid.Method_Type__c = 'POST';
        cid.Timeout__c = 120000;
        insert cid;
        test.stopTest();
        
    }
    
     Public static testmethod void TMethod8(){ 
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.IAM_Service_Provider_Code__c='03742';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        list<CSS_UserLocation__c> UserlocList = new list<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=userInfo.getUserId(),Location_code__c='03742-03742');
        UserlocList.add(userLocation);
        Insert UserlocList;
        
        CG_BL_Claims newObj = new CG_BL_Claims();
        List<SelectOption> optionsList = new List<SelectOption>();
        optionsList  = newObj.fetchLocationName(UserlocList);
     	
        }

	 Public static testmethod void TMethod9(){  
            
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.IAM_Service_Provider_Code__c='03742';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '03742';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
         
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.CSS_Job__c = Jo.id;
        claimsobj.Account__C = acc.id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = True;
        claimsList.add(claimsObj );
        insert claimsList;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
            
        List<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
      	solComp.CSS_Claims__c=claimsObj.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Claim_Type__c = 'Test';
        solComp.Selected_Claim_Type__c = 'Testing';
        solComp.Performed_Review__c = true;
        solComp.Status__c = 'Approved';
        solComp.Complete_Indicator__c =true;
        solComp.Multiple_Times__c =true;
        solComp.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp.AccountCode__c = '27';
        solComp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        solComp.OldSolCompID__c = 'Test-Test';
		lstsolcomp.add(solcomp);
        insert lstsolcomp;
            

        list<CSS_SRT__C> lstsrt = new list<CSS_SRT__C>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.CSS_Claims__c =claimsList[0].id ;
        srt.Component_Id__c = solComp.id;
        srt.Solution_Number__c = solAdd.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Admin';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '99-902-00';
        srt.isPerformed__c = true;
        srt.type__c = 'Diagnosis';
        srt.srt_category__c = '';
        lstsrt.add(srt);
        insert lstsrt;  
            
        list<CSS_SRT__C> DuplicatesrtList = new list<CSS_SRT__C>();
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt.Component_Id__c = solComp.id;
        srt1.Solution_Number__c = solAdd.id;
        srt1.CSS_Claims__c =claimsList[0].id ;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Admin';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.SRT_ID__c = '99-902-00';
        srt1.isPerformed__c = true;
        srt1.type__c = 'Diagnosis';
        srt.srt_category__c = 'trps';    
        DuplicatesrtList.add(srt1); 
        insert DuplicatesrtList;
        
        Test.startTest();
        List<id> ids = new list<id>();   
        id st = solComp.id;
        ids.add(st);    
        CG_BL_Claims.DuplicateSRT(claimsList[0].id,ids);
        Test.stopTest();
       
        }
        
     Public static testmethod void TMethod10(){  
            
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
        
        
         
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = True;
        insert claimsObj;
        claimsList.add(claimsObj );
        //insert claimsList;
            
        List<id> ids = new list<id>();    
        List<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
      	solComp.CSS_Claims__c=claimsObj.id;
        //solcomp.CSS_Classic_SJId__c='test1';
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Claim_Type__c = 'Test';
        solComp.Selected_Claim_Type__c = 'Testing';
        solComp.Performed_Review__c = true;
        solComp.Status__c = 'Approved';
        solComp.Complete_Indicator__c =true;
        solComp.Multiple_Times__c =true;
        solComp.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp.AccountCode__c = '27';
        solComp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        solComp.OldSolCompID__c = 'Test-Test';
        solComp.Component_id__c ='1603';
		lstsolcomp.add(solcomp);
        insert lstsolcomp;
            id st = solComp.id;
            ids.add(st);
        
         list<CSS_Parts_Options__c> lstpart = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
        partobj.Account_Code__c='test';
        partobj.Address1__c = 'test';
        partobj.City__c = 'test';
        partobj.FailurepartId__c = solComp.id;
        lstpart.add(partobj);
        insert lstpart;
        
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'GetCampaign';
        cid.ApplicationName__c = 'GetCampaign';
        cid.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
        cid.logging__c = 'SUCCESS';
        cid.AuthEnv__c = 'OAGOAuth';
        cid.Method_Type__c = 'POST';
        cid.Timeout__c = 120000;
        insert cid;

        CG_BL_Claims.validateGetCampaigns('79464646',system.today(),'UNITED STATES',claimsList[0].id,'CAMPAIGN',solComp.Component_id__c);
        
    }  
    
     Public static testmethod void TMethod11(){   
        
        List<CSS_UserLocation__c> usrLocLst = new List<CSS_UserLocation__c>();
    
  	    CSS_UserLocation__c usrLoc = new CSS_UserLocation__c(); 
        usrLoc.Name = 'TestLoc1';
        usrLoc.Location_code__c = '03520-04892';
        usrLoc.isActive__c = true;
        usrLoc.isPrimary__c = true;
        usrLocLst.add(usrLoc);
        
        CSS_UserLocation__c usrLoc1 = new CSS_UserLocation__c(); 
        usrLoc1.Name = 'TestLoc2';
        usrLoc1.Location_code__c = '56270-56255';
        usrLoc1.isActive__c = true;
        usrLoc1.isPrimary__c = true;
        usrLocLst.add(usrLoc1);
        
        insert usrLocLst;
        
        string LOC;
        LOC = CG_BL_Claims.selectedLocation(usrLocLst);

    }
    
     Public static testmethod void TMethod12(){  
            
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
         
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = True;
            insert claimsObj;
        claimsList.add(claimsObj );
        //insert claimsList;
            
        List<id> ids = new list<id>();    
        List<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
      	solComp.CSS_Claims__c=claimsObj.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Claim_Type__c = 'Test';
        solComp.Selected_Claim_Type__c = 'Testing';
        solComp.Performed_Review__c = true;
        solComp.Status__c = 'Approved';
        solComp.Complete_Indicator__c =true;
        solComp.Multiple_Times__c =true;
        solComp.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp.AccountCode__c = '27';
        solComp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        solComp.OldSolCompID__c = 'Test-Test';
        solComp.Component_id__c ='1603';
		lstsolcomp.add(solcomp);
        insert lstsolcomp;
            id st = solComp.id;
            ids.add(st);
        
         list<CSS_Parts_Options__c> lstpart = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
        partobj.Account_Code__c='test';
        partobj.Address1__c = 'test';
        partobj.City__c = 'test';
        partobj.FailurepartId__c = solComp.id;
        lstpart.add(partobj);
        insert lstpart;
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'GetCampaign';
         cid.ApplicationName__c = 'GetCampaign';
         cid.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
         cid.logging__c = 'SUCCESS';
         cid.AuthEnv__c = 'OAGOAuth';
        cid.Method_Type__c = 'POST';
        cid.Timeout__c = 120000;
        insert cid;

        CG_BL_Claims.validateGetCampaigns('79464646',system.today(),'UNITED STATES',claimsList[0].id,'CAMPAIGN',solComp.Component_id__c);
        
    } 
    
     Public static testmethod void TMethod13(){
        
        test.startTest();
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = True;
         insert claimsObj;
        claimsList.add(claimsObj );
        //insert claimsList;
        
        List<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
         solcomp.CSS_Claims__c=claimsobj.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.AccountCodeType__c  = 'ACCOUNT TEAM COVERAGE';
        solComp.AccountCode__c = '27';
        solComp.AccountCodeEdit__c = 'ACCOUNT TEAM COVERAGE 27';
        solComp.OldSolCompID__c = 'Test-Test';
        solComp.Selected_Component__c=true;
        solComp.Service_Job__c=JO.id;
         solComp.Fault_Code__c='turbocharger';

        lstsolcomp.add(solcomp);
        insert lstsolcomp;
        
        list<CSS_Parts_Options__c> lstpart = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partobj = new CSS_Parts_Options__c();
        partobj.Account_Code__c='test';
        partobj.Address1__c = 'test';
        partobj.City__c = 'test';
        partobj.FailurepartId__c = null;
         
         CSS_Parts_Options__c partobj1 = new CSS_Parts_Options__c();
        partobj1.Account_Code__c='test';
        partobj1.Address1__c = 'test';
        partobj1.City__c = 'test';
        partobj1.FailurepartId__c = solComp.id;
         lstpart.add(partobj1);
        lstpart.add(partobj);
        insert lstpart;
        
        css_srt__c srt = new css_srt__c();
        srt.isPerformed__c = true;
        srt.SRT_Category__c='AdditionalDiag';
        insert srt;
         
         List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = date.today() +6 ;
        psnList.add(psnObj);
        insert psnList;
        
        List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        ctt.Type__c = 'ATC';
        ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt.Doc_Num__c = 'ATCF0051000';
        ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt.Performed__c = false;
        ctt.Performed_Review__c = true;
        ctt.Reviewed__c = false;
        ctt.Job_Order__c = JO.Id;
        ctt.ESN__c = JO.ESN__c;
        ctt.cu_language__C = 'fr';
        insert ctt;
        
        
        list<CSS_JobEventTemporary__c> jobEventlstRef = new list<CSS_JobEventTemporary__c>();
         CSS_JobEventTemporary__c joObj= new CSS_JobEventTemporary__c();
         joObj.Attribute1__c='POL';
         joObj.Attribute2__c = 'ZCK POLICY CLAIMS';
         joObj.Attribute3__c='ZK';
         joObj.Key__c='AccountCodes';
         jobEventlstRef.add(joObj);
         insert jobEventlstRef;
         
        CG_BL_Claims cl= new CG_BL_Claims();
        CG_BL_Claims.dealercloneAutomatedCampaigns(jo.id,'79464646',claimsList[0].id,SerRec.id,'Dealer Account',True);

        
        test.stopTest();
    }
}