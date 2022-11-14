@istest
private class CG_CL_ClaimsIntake_Test
{
    
    @testSetup
    static  void CG_CL_ClaimsIntake_testsetup()
    {
        CSS_Integration_Details__c condetails = new CSS_Integration_Details__c();
        condetails.name='CSS_SPDataLookup';
        condetails.ApplicationName__c='CSS_SPDataLookup';
        condetails.AuthEnv__c='CSS_SPDataLookup';
        condetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
        condetails.grant_type__c='Refresh_full';
        condetails.IsActive__c=true;
        condetails.Key__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Logging__c='BOTH';
        condetails.Method_Type__c='POST';
        condetails.Passcode__c='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL171LYrK6URZB3zKLO45503MD61NA8LTSTQCRvGn5Qroo3CkG7RRlFe9Bw==';
        condetails.Timeout__c=120;
        condetails.Username__c='wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO3QlGuxTVNg/ly+0Sy1nWe59U01nRfRW/q9ogg4q6LfncwdAZmBg==';  
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod1()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        //Cache.Session.put('ManualClaimsSelectedLocation','ManualClaimsSelectedLocation');
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        // String ManualClaimsLoc = 'ManualClaimsSelectedLocation';
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        //UserRole urRole = [Select name from UserRole where name='factory' limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '02650-97895');
        //insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650-97895');
        insert userLocation;
        
        //   system.runAs(u){
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            CG_CL_ClaimsIntake clmsIntakeobj = new CG_CL_ClaimsIntake();
            
            List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
            CSS_Claims__c  testclaimsRec= new CSS_Claims__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.location__c ='Cummins NPower';    
            testclaimsRec.Location_Code__c = '02650-97895';
            //testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.Email_Address__c='abc@abc.com';
            testclaimsRec.CSS_Channel_Of_Distribution__c = 'test1';  
            testclaimsRec.Account__c=acc.id;
            insert testclaimsRec;
            claimsList.add(testclaimsRec);
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testpsnNewRec.Name='Test';
            testpsnNewRec.psn__c='79464646';
            testpsnNewRec.CSS_Claims__c=claimsList[0].id;
            testpsnNewRec.Primary__c=true;
            testpsnNewRec.Failure_Date__c=null;
            clmsIntakeobj.repaircomple=date.today();
            testpsnNewRec.Before_In_Service__c = true;
            insert testpsnNewRec;
            clmsIntakeobj.dealerUser=true;
            clmsIntakeobj.multipsnchecbox();
            
        }
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod112()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        
        // String ManualClaimsLoc = 'ManualClaimsSelectedLocation';
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        Cache.Session.put('ManualClaimsSelectedLocation',location);
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        //UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '02650-97895');//,UserRoleId = empRole.id);
        insert u;
        List<CSS_UserLocation__c> uloc=new List<CSS_UserLocation__c>();
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650');
        insert userLocation;
        uloc.add(userLocation);
        //   system.runAs(u){
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            CG_CL_ClaimsIntake clmsIntakeobj = new CG_CL_ClaimsIntake();
            clmsIntakeobj.dealerUser=true;
            clmsIntakeobj.FailListVar=true;
            clmsIntakeobj.PSNFlag=true;
            List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
            CSS_Claims__c  testclaimsRec= new CSS_Claims__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.location__c ='Cummins NPower'; 
            testclaimsRec.Multi_PSN_Claim__c=false;
            testclaimsRec.Account__c=acc.id;
            testclaimsRec.status__c = 'Submitted';
            testclaimsRec.Location_Code__c = '02650-97895';
            //testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.Email_Address__c='abc@abc.com';
            testclaimsRec.CSS_Channel_Of_Distribution__c = 'test1';  
            insert testclaimsRec;
            claimsList.add(testclaimsRec);
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testpsnNewRec.Name='Test';
            testpsnNewRec.psn__c='79464646';
            testpsnNewRec.CSS_Claims__c=claimsList[0].id;
            testpsnNewRec.Primary__c=true;
            // testpsnNewRec.repaircomple=date.today();
            testpsnNewRec.Before_In_Service__c = false;
            insert testpsnNewRec;
            list<CSS_Solution_Component__c> lstsolcomp=new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCompObj=new CSS_Solution_Component__c();
            solCompObj.Type__c ='Campaign';
            solCompObj.Selected_Component__c= true; 
            solCompObj.AccountCode__c ='testing';
            // solCompObj.Fail_Code__c = 'test';
            solCompObj.Notes__c = 'testNotes';
            solCompObj.Pay_Code__c='testPay';
            solCompObj.Status__c='Approved';
            solCompObj.CSS_Claims__c =claimsList[0].id;
            lstsolcomp.add(solCompObj);
            insert lstsolcomp;
            clmsIntakeobj.multipsnchecbox();
            //clmsIntakeobj.test = 'ddd';
            clmsIntakeobj.accountlang = null;
            clmsIntakeobj.cID = testclaimsRec.Id;
            clmsIntakeobj.continueNext();
            //clmsIntakeobj.uncheckPopupsave();
            
        }
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod2()
    {
        Test.startTest();
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Dealer Account';
        //acc.Location__c='02650-97895';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Account__c=acc.id;
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.css_job__c = jo.id;
        claimsobj.Account__c=acc.id;
        claimsobj.Dealer_Service_Job__c=jo.id;
        claimsobj.Pending_Authorization__c=null;
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = True;
        claimsObj.location__c ='Cummins NPower';    
        claimsObj.Location_Code__c = '02650-97895';
        
        // claimsObj.Country__c='Us';
        //claimsObj.State__c='alabama';
        //claimsObj.ODM_Status_Message__c = 'ODM-HE-WAR-403-1';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_SRT__C> lstsrt = new list<CSS_SRT__C>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.Type__c='Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 1;
        srt.CSS_Claims__c =claimsList[0].id ;
        srt.type__c = 'Diagnosis';
        srt.srt_category__c = 'AdditionalDiag';//'Campaign';//'AdditionalRep';
        srt.SRT_Type__c='Campaign';
        //insert srt;
        //srt.Additional_SRT_Calculated__c=2.3;
        lstsrt.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.Type__c = 'Diagnosis';
        srt1.isPerformed__c=true;
        srt1.srt_category__c = 'AdditionalDiag';
        srt1.Assignment__c = 'Primary';
        srt1.Extended_Hours__c=2.0;
        //insert srt1;
        lstsrt.add(srt1);
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = true;
        srt2.Extended_Hours__c =2.0;
        srt2.CSS_Claims__c =claimsList[0].id ;
        //srt2.type__c = 'Diagnosis';
        srt2.srt_category__c = '';//'Campaign';//'AdditionalRep';
        srt2.SRT_Type__c='Campaign';
        //insert srt2;
        lstsrt.add(srt2);
        CSS_SRT__c srt3 = new CSS_SRT__c();
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.Access_Code_A__c = 65;
        srt3.name = 'TestClassName';
        //srt3.type__c = '';
        srt3.Assignment__c = 'PRIMARY';
        srt3.srt_time__c = 1;
        srt3.SRT_ID__c = '00-901-10';
        srt3.isPerformed__c = true;
        srt3.Extended_Hours__c =2.0;
        srt3.CSS_Claims__c =claimsList[0].id ;
        srt3.type__c = 'Diagnosis';
        srt3.srt_category__c = 'AdditionalRep';//'Campaign';//'AdditionalRep';
        srt3.SRT_Type__c='Campaign';
        //insert srt3;
        lstsrt.add(srt3);
        CSS_SRT__c srt4 = new CSS_SRT__c();
        srt4.SRT_AccessiblityCheck__c=True;
        srt4.Access_Code_A__c = 65;
        srt4.name = 'TestClassName';
        srt4.type__c = 'Campaign';
        srt4.Assignment__c = 'PRIMARY';
        srt4.srt_time__c = 1;
        srt4.SRT_ID__c = '00-901-10';
        srt4.isPerformed__c = true;
        srt4.Extended_Hours__c =2.0;
        srt4.CSS_Claims__c =claimsList[0].id ;
        //srt4.type__c = 'Diagnosis';
        srt4.srt_category__c = 'Campaign';//'Campaign';//'AdditionalRep';
        //srt4.SRT_Type__c='Campaign';
        //insert srt4;
        lstsrt.add(srt4);
        CSS_SRT__c srt5 = new CSS_SRT__c();
        srt5.SRT_AccessiblityCheck__c=True;
        srt5.Access_Code_A__c = 65;
        srt5.name = 'TestClassName';
        srt5.type__c = 'Field Action';
        srt5.Assignment__c = 'PRIMARY';
        srt5.srt_time__c = 1;
        srt5.SRT_ID__c = '00-901-10';
        srt5.isPerformed__c = true;
        srt5.Extended_Hours__c =2.0;
        srt5.CSS_Claims__c =claimsList[0].id ;
        //srt5.type__c = 'Diagnosis';
        srt5.srt_category__c = 'TRP';//'Campaign';//'AdditionalRep';
        srt5.SRT_Type__c='TRP';
        //insert srt5;
        lstsrt.add(srt5);
        CSS_SRT__c srt6 = new CSS_SRT__c();
        srt6.SRT_AccessiblityCheck__c=True;
        srt6.Access_Code_A__c = 65;
        srt6.name = 'TestClassName';
        srt6.type__c = 'Field Action';
        srt6.Assignment__c = 'PRIMARY';
        srt6.srt_time__c = 1;
        srt6.SRT_ID__c = '00-901-10';
        srt6.isPerformed__c = true;
        srt6.Extended_Hours__c =2.0;
        srt6.CSS_Claims__c =claimsList[0].id ;
        //srt6.type__c = 'Diagnosis';
        srt6.srt_category__c = 'ATC';//'Campaign';//'AdditionalRep';
        srt6.SRT_Type__c='ATC';
        //insert srt6;
        lstsrt.add(srt6);
        CSS_SRT__c srt7 = new CSS_SRT__c();
        srt7.SRT_AccessiblityCheck__c=True;
        srt7.Access_Code_A__c = 65;
        srt7.name = 'TestClassName';
        srt7.type__c = '99Time';
        srt7.Assignment__c = 'PRIMARY';
        srt7.srt_time__c = 1.2;
        srt7.SRT_ID__c = '00-901-10';
        srt7.isPerformed__c = true;
        srt7.Extended_Hours__c =2.0;
        srt7.CSS_Claims__c =claimsList[0].id ;
        //srt7.type__c = 'Diagnosis';
        srt7.srt_category__c = 'ATC';//'Campaign';//'AdditionalRep';
        srt7.SRT_Type__c='ATC';
        //insert srt7;
        lstsrt.add(srt7);
        
        //insert lstsrt;
        
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        
        solCompObj.Type__c ='OTH' ;//'Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';
        // solCompObj.Fail_Code__c = 'test';
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';
        solCompObj.Status__c='Approved';
        solCompObj.CSS_Claims__c =claimsList[0].id;
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.Claim_Number__c= claimsObj.name;
        claimsSub.CSS_Claims__c=claimsObj.id;        
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        claimsSub1.Claim_Number__c= claimsObj.name;
        claimsSub1.CSS_Claims__c=claimsObj.id;        
        submID.add(claimsSub1);
        insert submID;
        CSS_Claim_Submission__c claSubRec=   [SELECT Id, Type__c, Rejection_Reason__c, Status__c, Claim_Number__c,Credit_Date__c, CSS_Claims__c from CSS_Claim_Submission__c where Claim_Number__c=:claimsObj.name limit 1];
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        
        psnObj1.name = 'TestPSN1';
        psnObj1.PSN__c = 'TestPSN1231';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnObj1.Service_Model__c = 'ISBE CM800';
        psnObj1.Failure_Date__c = null;//date.today() +6 ;
        psnObj1.Before_In_Service__c=true;
        psnObj1.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj1);
        insert psnList;
        
        List<CSS_Accreditation__c> lstaccr = new List<CSS_Accreditation__c>();       
        CSS_Accreditation__c accr = new CSS_Accreditation__c();
        accr.Service_Model_Name__c = 'ISBE CM800';
        // acc.Account__c = a.id;
        accr.OEM_Code__c = '232';
        accr.EndDate__c = date.today() +7 ;
        accr.StartDate__c = date.today() + 4;
        lstaccr.add(accr);
        insert lstaccr;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
        List<CSS_CampTsbTrp__c> lstTSB = new List<CSS_CampTsbTrp__c>();
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
        insert ctt;
        
        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
        ctt1.Type__c = 'CAM';
        ctt1.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt1.Doc_Num__c = 'CF0051000';
        ctt1.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt1.Performed__c = false;
        ctt1.Performed_Review__c = true;
        ctt1.Reviewed__c = false;
        ctt1.Job_Order__c = JO.Id;
        ctt1.ESN__c = JO.ESN__c;
        insert ctt1;
        
        system.debug('---ctttest--' +ctt1);
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
        ctt2.Type__c = 'TRP';
        ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt2.Doc_Num__c = 'TF0051000';
        ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt2.Performed__c = false;
        ctt2.Performed_Review__c = true;
        ctt2.Reviewed__c = false;
        ctt2.Job_Order__c = JO.Id;
        ctt2.ESN__c = JO.ESN__c;
        insert ctt2;
        CSS_CampTsbTrp__c ctt3 = new CSS_CampTsbTrp__c();
        ctt3.Type__c = 'TSB';
        ctt3.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt3.Doc_Num__c = 'TF0051000';
        ctt3.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt3.Performed__c = false;
        ctt3.Performed_Review__c = true;
        ctt3.Reviewed__c = false;
        ctt3.Job_Order__c = JO.Id;
        ctt3.ESN__c = JO.ESN__c;
        insert ctt3;
        lstTSB.add(ctt3);
        lstTSB.add(ctt);
        lstTSB.add(ctt1);
        lstTSB.add(ctt2);
        lstCAM.add(ctt1);
        lstTRP.add(ctt2);
        lstATC.add(ctt);
        
        CSS_SRT__C srtVar = new CSS_SRT__C();
        srtVar.Solution_Number__c = solAdd.id;
        
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims = new CG_CL_ClaimsIntake();
        claims.justficationErrMsg=true;
        claims.AssignedTo ='siva';
        claims.AdditionalTech1 = 'AdditionalTech1';
        claims.AdditionalTech2 = 'AdditionalTech2';
        claims.AdditionalTech3 = 'AdditionalTech3';
        claims.AdditionalTech4 = 'AdditionalTech4';
        claims.AdditionalTech5 = 'AdditionalTech5';
        claims.AdditionalTech6 = 'AdditionalTech6';
        claims.AdditionalTech7 = 'AdditionalTech7';
        claims.AdditionalTech8 = 'AdditionalTech8';
        claims.AdditionalTech9 = 'AdditionalTech9';
        claims.secondaryPSN = true;
        claims.Information = true;
        claims.prodcodeErrormessage = true;
        claims.strCntry = 'India';
        claims.strCntryState = 'Bangalore';
        claims.strRepairloc = 'Bangalore';
        claims.region = 'India';
        claims.ExternReturnDateFlag = true;
        claims.mainFlag = 'test1';
        claims.idNotNullLocationManualClaims = 'test1';
        claims.warrantyStartDateValidate = true;
        claims.pageName = 'pageName';
        claims.FormattedDate = '10-08-2018';
        claims.tempFailureDate = date.today() +6;
        Test.setMock(HttpCalloutMock.class, new CG_CAmpaignMock_Test());
       // claims.checkPopupsave();
        //claims.pageAction();
        //claims.nvClaimsWC();
        claims.nvClaimsVH();
        claims.nvClaimsCC();
        claims.nvClaimsFC();
        claims.nvClaimsPSN();
        claims.nvClaimsMulti_PSN();
        claims.nvClaimsJobNotes();
        claims.cId=claimsObj.id;
        claims.nvClaimsVS();
        //claims.pgSave();
        claims.resolveErrorNow();
        claims.continueNext();
        claims.paccarPopUP_OK();
        // claims.warrantyStartDateValidate = date.today();
        claims.nvClaimsPOC();
        claims.nvClaimsSRTs();
        claims.setPACCAR_Flag();
        //claims.saveClaim(claimsObj.id, 'submitted');
        // List<List<CSS_CampTsbTrp__c>> lstCamp = CG_BL_Intake.getCampaigns(JO.esn__c, JO.Service_Model__c,JO.Failure_Date__c, 'en',JO.id);
        //claims.callgetCampaigns();
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod101()
    {
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
         Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Dealer Account';
        //acc.Location__c='02650-97895';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Account__c=acc.id;
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.css_job__c = jo.id;
        claimsobj.Account__c=acc.id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = false;
        claimsObj.location__c ='Cummins NPower';    
        claimsObj.Location_Code__c = '02650-97895';
        claimsObj.Country__c='Us';
        claimsObj.State__c='alabama';
        claimsObj.ODM_Status_Message__c = 'ODM-HE-WAR-403-1';
        claimsList.add(claimsObj );
        insert claimsList;
        id wid = ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        
        solCompObj.Type__c ='OTH' ;//'Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';
        solCompObj.Status__c='Approved';
        solCompObj.CSS_Claims__c = claimsList[0].id;
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        List<CSS_Parts_Options__c> prtsLst = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtsObj = new CSS_Parts_Options__c();
        prtsObj.name = 'TestData';
        prtsObj.Account_Code__c = 'TestData';
        prtsObj.FailurepartId__c = lstsolcomp[0].Id;
        prtsObj.CSS_Claims__c = claimsList[0].id;
          insert prtsObj;
        CSS_Parts_Options__c prtsObj3 = new CSS_Parts_Options__c();
        Id recTypeIdpart3 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        prtsObj3.name = 'TestData';
        prtsObj3.Account_Code__c = 'TestData';
        prtsObj3.RecordTypeId = recTypeIdpart3;
        prtsObj3.FailurepartId__c = lstsolcomp[0].Id;
        prtsObj3.CSS_Claims__c = claimsList[0].id;
          insert prtsObj3;
        CSS_Parts_Options__c prtsObj1 = new CSS_Parts_Options__c();
        prtsObj1.name = 'TestData';
        prtsObj1.Account_Code__c = 'TestData';
         prtsObj.FailurepartId__c = lstsolcomp[0].Id;
        prtsObj1.CSS_Claims__c = claimsList[0].id;
          insert prtsObj1;
          prtsLst.add(prtsObj);
          prtsLst.add(prtsObj1);
        List<css_srt__c> srtLst = new List<css_srt__c>();
        css_srt__c srtObj = new css_srt__c();
           srtObj.CSS_Claims__c = claimsList[0].id;
        	srtObj.Component_Id__c = lstsolcomp[0].Id;
           srtObj.Type__c = 'admin';
           insert srtObj;
        css_srt__c srtObj1 = new css_srt__c();
           srtObj1.CSS_Claims__c = claimsList[0].id;
           srtObj.Component_Id__c = lstsolcomp[0].Id;
        	srtObj1.Type__c = 'admin';
           insert srtObj1;
          srtLst.add(srtObj);
           srtLst.add(srtObj1);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        Test.startTest();
        CG_CL_ClaimsIntake claims = new CG_CL_ClaimsIntake();
        //claims.checkPopupsave();
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod121()
    {
        Test.startTest();
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Dealer Account';
        //acc.Location__c='02650-97895';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Account__c=acc.id;
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.css_job__c = jo.id;
        claimsobj.Account__c=acc.id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = false;
        claimsObj.location__c ='Cummins NPower';    
        claimsObj.Location_Code__c = '02650-97895';
        claimsObj.Country__c='Us';
        claimsObj.State__c='alabama';
        claimsObj.ODM_Status_Message__c = 'ODM-HE-WAR-403-1';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_SRT__C> lstsrt = new list<CSS_SRT__C>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Access';//'Admin';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 1.0;
        srt.CSS_Claims__c =claimsList[0].id ;
        srt.type__c = 'Diagnosis';
        srt.srt_category__c = 'AdditionalRep';
        srt.SRT_Type__c='Campaign';
        //srt.Additional_SRT_Calculated__c=2.3
        //insert srt;
        lstsrt.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.Type__c = 'Field Action';
        srt1.isPerformed__c=true;
        srt1.srt_category__c = '';
        srt1.Assignment__c = 'Primary';
        srt1.Extended_Hours__c=2.0;
        srt1.SRT_Type__c='TRP';
        //insert srt1;
        lstsrt.add(srt1);
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        solCompObj.Type__c ='OTH' ;//'Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='02';
        // solCompObj.Fail_Code__c = 'test';
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';
        solCompObj.Status__c='Approved';
        solCompObj.CSS_Claims__c =claimsList[0].id;
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.Claim_Number__c= claimsObj.name;
        claimsSub.CSS_Claims__c=claimsList[0].id;   
        //claimsSub.acc
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        claimsSub1.Claim_Number__c= claimsObj.name;
        claimsSub1.CSS_Claims__c=claimsList[0].id;        
        submID.add(claimsSub1);
        insert submID;
        CSS_Claim_Submission__c claSubRec=   [SELECT Id, Type__c, Rejection_Reason__c, Status__c, Claim_Number__c,Credit_Date__c, CSS_Claims__c from CSS_Claim_Submission__c where Claim_Number__c=:claimsObj.name limit 1];
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        
        psnObj.name = 'TestPSN';
        psnObj.Unit_Type__c=null;
        psnObj.Application__c=null;
        psnObj.Make__c=null;
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.Model__c=null;
        psnObj.Mileage_Measure__c=null;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = system.today();//date.today() +6 ;
        //psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        
        List<CSS_Accreditation__c> lstaccr = new List<CSS_Accreditation__c>();       
        CSS_Accreditation__c accr = new CSS_Accreditation__c();
        accr.Service_Model_Name__c = 'ISBE CM800';
        // acc.Account__c = a.id;
        accr.OEM_Code__c = '232';
        accr.EndDate__c = date.today() +7 ;
        accr.StartDate__c = date.today() + 4;
        lstaccr.add(accr);
        insert lstaccr;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        CSS_SRT__C srtVar = new CSS_SRT__C();
        srtVar.Solution_Number__c = solAdd.id;
        
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims = new CG_CL_ClaimsIntake();
        claims.justficationErrMsg=true;
        //claims.pageAction();
        //Test.setMock(HttpCalloutMock.class, new CG_CAmpaignMock_Test());
       // claims.checkPopupsave();
        
        //claims.nvClaimsWC();
        claims.nvClaimsVH();
        claims.nvClaimsCC();
        claims.nvClaimsFC();
        claims.nvClaimsPSN();
        claims.nvClaimsMulti_PSN();
        claims.nvClaimsJobNotes();
        claims.cId=claimsObj.id;
        claims.nvClaimsVS();
        //claims.pgSave();
        claims.resolveErrorNow();
        claims.continueNext();
        claims.paccarPopUP_OK();
        // claims.warrantyStartDateValidate = date.today();
        claims.nvClaimsPOC();
        claims.nvClaimsSRTs();
        claims.setPACCAR_Flag();
        claims.AssignedTo ='siva';
        claims.AdditionalTech1 = 'AdditionalTech1';
        claims.AdditionalTech2 = 'AdditionalTech2';
        claims.AdditionalTech3 = 'AdditionalTech3';
        claims.AdditionalTech4 = 'AdditionalTech4';
        claims.AdditionalTech5 = 'AdditionalTech5';
        claims.AdditionalTech6 = 'AdditionalTech6';
        claims.AdditionalTech7 = 'AdditionalTech7';
        claims.AdditionalTech8 = 'AdditionalTech8';
        claims.AdditionalTech9 = 'AdditionalTech9';
        claims.secondaryPSN = true;
        claims.Information = true;
        claims.prodcodeErrormessage = true;
        claims.strCntry = 'India';
        claims.strCntryState = 'Bangalore';
        claims.strRepairloc = 'Bangalore';
        claims.region = 'India';
        claims.ExternReturnDateFlag = true;
        claims.mainFlag = 'test1';
        claims.idNotNullLocationManualClaims = 'test1';
        claims.warrantyStartDateValidate = true;
        claims.pageName = 'pageName';
        claims.FormattedDate = '10-08-2018';
        claims.tempFailureDate = date.today() +6;
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod521()
    {
        Test.startTest();
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Dealer Account';
        //acc.Location__c='02650-97895';
        acc.IAM_Service_Provider_Code__c = '56270';
        // acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Account__c=acc.id;
        JO.Mileage_Measure__c='19';
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.css_job__c = jo.id;
        claimsobj.Account__c=acc.id;
        claimsobj.Customer_Name__c = null;
        claimsobj.SPDataWebserviceResult__c = 'Error';
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = true;
        claimsObj.Customer_Name__c =null;
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.Information_Only_Claim__c = false;
        claimsObj.location__c ='Cummins NPower';    
        claimsObj.Location_Code__c = '02650-97895';
        claimsObj.Country__c='Us';
        claimsObj.State__c='alabama';
        claimsObj.ODM_Status_Message__c = 'ODM-HE-WAR-403-1';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_SRT__C> lstsrt = new list<CSS_SRT__C>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Access';//'Admin';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 1.0;
        srt.CSS_Claims__c =claimsList[0].id ;
        srt.type__c = 'Diagnosis';
        srt.srt_category__c = 'AdditionalRep';
        srt.SRT_Type__c='Campaign';
        //srt.Additional_SRT_Calculated__c=2.3;
        //insert srt;
        lstsrt.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.Type__c = 'Field Action';
        srt1.isPerformed__c=true;
        srt1.srt_category__c = '';
        srt1.Assignment__c = 'Primary';
        srt1.Extended_Hours__c=2.0;
        srt1.SRT_Type__c='TRP';
        //insert srt1;
        lstsrt.add(srt1);
        
        
        
        //insert lstsrt;
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        
        solCompObj.Type__c ='OTH' ;//'Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';
        // solCompObj.Fail_Code__c = 'test';
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';
        solCompObj.Status__c='Approved';
        solCompObj.CSS_Claims__c =claimsList[0].id;
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.Claim_Number__c= claimsObj.name;
        claimsSub.CSS_Claims__c=claimsList[0].id;        
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        claimsSub1.Claim_Number__c= claimsObj.name;
        claimsSub1.CSS_Claims__c=claimsList[0].id;        
        submID.add(claimsSub1);
        insert submID;
        CSS_Claim_Submission__c claSubRec=   [SELECT Id, Type__c, Rejection_Reason__c, Status__c, Claim_Number__c,Credit_Date__c, CSS_Claims__c from CSS_Claim_Submission__c where Claim_Number__c=:claimsObj.name limit 1];
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = null;
        psnObj.Unit_Type__c=null;
        psnObj.Application__c=null;
        psnObj.Make__c=null;
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.Model__c=null;
        psnObj.Mileage_Measure__c=null;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = system.today();//date.today() +6 ;
        //psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        
        List<CSS_Accreditation__c> lstaccr = new List<CSS_Accreditation__c>();       
        CSS_Accreditation__c accr = new CSS_Accreditation__c();
        accr.Service_Model_Name__c = 'ISBE CM800';
        // acc.Account__c = a.id;
        accr.OEM_Code__c = '232';
        accr.EndDate__c = date.today() +7 ;
        accr.StartDate__c = date.today() + 4;
        lstaccr.add(accr);
        insert lstaccr;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        CSS_SRT__C srtVar = new CSS_SRT__C();
        srtVar.Solution_Number__c = solAdd.id;
        
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims = new CG_CL_ClaimsIntake();
        claims.justficationErrMsg=true;
        //claims.pageAction();
        //Test.setMock(HttpCalloutMock.class, new CG_CAmpaignMock_Test());
       // claims.checkPopupsave();
        
        //claims.nvClaimsWC();
        claims.nvClaimsVH();
        claims.nvClaimsCC();
        claims.nvClaimsFC();
        claims.nvClaimsPSN();
        claims.nvClaimsMulti_PSN();
        claims.nvClaimsJobNotes();
        claims.cId=claimsObj.id;
        claims.nvClaimsVS();
        claims.emailAdd1 = 'a@cummins.com';
        //claims.pgSave();
        claims.resolveErrorNow();
        claims.continueNext();
        claims.paccarPopUP_OK();
        // claims.warrantyStartDateValidate = date.today();
        claims.nvClaimsPOC();
        claims.nvClaimsSRTs();
        claims.setPACCAR_Flag();
        claims.AssignedTo ='siva';
        claims.AdditionalTech1 = 'AdditionalTech1';
        claims.AdditionalTech2 = 'AdditionalTech2';
        claims.AdditionalTech3 = 'AdditionalTech3';
        claims.AdditionalTech4 = 'AdditionalTech4';
        claims.AdditionalTech5 = 'AdditionalTech5';
        claims.AdditionalTech6 = 'AdditionalTech6';
        claims.AdditionalTech7 = 'AdditionalTech7';
        claims.AdditionalTech8 = 'AdditionalTech8';
        claims.AdditionalTech9 = 'AdditionalTech9';
        claims.secondaryPSN = true;
        claims.Information = true;
        claims.prodcodeErrormessage = true;
        claims.strCntry = 'India';
        claims.strCntryState = 'Bangalore';
        claims.strRepairloc = 'Bangalore';
        claims.region = 'India';
        claims.ExternReturnDateFlag = true;
        claims.mainFlag = 'test1';
        claims.idNotNullLocationManualClaims = 'test1';
        claims.warrantyStartDateValidate = true;
        claims.pageName = 'pageName';
        claims.FormattedDate = '10-08-2018';
        claims.tempFailureDate = date.today() +6;
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod3()
    {
        Test.startTest();
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        lstjo.add(jo);
        insert lstjo;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Repair_Completion__c = date.today() + 5;
        claimsObj.Multi_PSN_Claim__c = false;
        claimsObj.css_job__c = jo.id ;
        claimsObj.Information_Only_Claim__c = False; 
        claimsObj.location__c ='Cummins NPower';    
        claimsObj.Location_Code__c = '02650-97895';
        claimsObj.PACCAR_Auth_Required__c=true;
        claimsObj.PACCAR_Flag__c=true;
        claimsObj.Parts_Warranty_Claim_Only__c=false;
        claimsObj.Css_paccar_approve_reject_flag__c='rejected';
        claimsList.add(claimsObj );
        insert claimsList;
        
       id wid = ApexPages.currentPage().getParameters().put('id', claimsObj.Id);
        CG_CL_ClaimsIntake claims1 = new CG_CL_ClaimsIntake();
        claims1.justficationErrMsg=true;
        //claims1.nvClaimsWC();
        //claims1.uncheckPopupsave();
        Test.stopTest();
        
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod5()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        //acc.Location__c = '02650-97895';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03520-04892');//'02650-97895');
        insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03520-04892');
        insert userLocation;
        CSS_accountLanguage__c accountlang = css_utility.getLanguage(u.LanguageLocaleKey);
        system.runAs(u){
            
            List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
            CSS_Claims__c claimsObj = new CSS_Claims__c();
            claimsObj.Service_Date__c = date.today();
            claimsObj.Repair_Completion__c = date.today() + 5;
            claimsObj.Multi_PSN_Claim__c = true;
            claimsObj.Email_Address__c='abc@abc.com';
            claimsObj.Information_Only_Claim__c = True;
            claimsObj.ODM_Status_Message__c = 'ODM-HE-WAR-403-1';
            claimsObj.ODM_Status__c = 'WARN';
            claimsObj.SP_PACCAR__c = 'N';
            claimsobj.location__c ='Cummins NPower';    
            claimsObj.Location_Code__c = '03520-04892';
            
            claimsList.add(claimsObj );
            insert claimsList;
            list<CSS_PSN__c> lpsn=new list<CSS_PSN__c>();
            CSS_PSN__c psnRec = new CSS_PSN__c();
            psnRec.Name='Test';
            psnRec.psn__c='79464646';
            psnRec.CSS_Claims__c=claimsObj.id;
            psnRec.Primary__c=true;
            psnRec.Failure_Date__c = date.today() + 8;
            psnRec.Application__c = 'filterApplication';
            psnRec.Calibration_Before__c = '';
            psnRec.Calibration_After__c = '';
            psnRec.Justification__c = 'CFSE Direction';
            insert psnRec;
            lpsn.add(psnRec);
            
            list<account> lstAcc = new list<Account>();
            list<CSS_UserLocation__c> lstUsrLoc =new list<CSS_UserLocation__c>();
            Account a= new Account();
            a.name='Rtest';
            a.CSS_DistributorCode__c='02650';
            a.IAM_Service_Provider_Code__c='97895';
            a.IAM_Service_Provider_Code__c = '56270';
            a.Type = 'Customer';
            a.IAM_Service_Provider_Code__c  = '56270';
            a.CMI_Account_Status__c = 'Active';
            
            a.BMS_Enabled__c = true;
            lstAcc.add(a);
            Test.startTest();
            ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
            CG_CL_ClaimsIntake claims2 = new CG_CL_ClaimsIntake();
            claims2.userObj = u;
            claims2.isDealer = true;
            
            Test.stopTest();
        } }
    static testmethod void CG_CL_ClaimsIntake_Testmethod6()
    {	
        Test.startTest();
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='1213';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        lstjo.add(jo);
        insert lstjo;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Information_Only_Claim__c = True;
        claimsObj.CSS_Job__c = jo.id;
        claimsObj.location__c ='Cummins NPower';    
        claimsObj.Location_Code__c = '02650-97895';
        claimsList.add(claimsObj );
        insert claimsList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims3 = new CG_CL_ClaimsIntake();
        claims3.paccarPopUP_OK();
        claims3.setPACCAR_Flag();
        
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod7()
    {	
        Test.startTest();
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='1213';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        lstjo.add(jo);
        insert lstjo;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Information_Only_Claim__c = True;
        // claimsObj.CSS_Job__c = jo.id;
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        //     solCompObj.Service_Job__c = jo.Id;
        solCompObj.Selected_Component__c = true;
        solCompObj.CSS_Claims__c = claimsObj.id;
        solCompObj.Type__c = 'OTH';//'Campaign';
        solCompObj.AccountCode__c ='testing';
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';        
        solCompObj.AccountCodeType__c  = 'NEW-New Engine Warranty';
        solCompObj.AccountCode__c = '67';
        solCompObj.AccountCodeEdit__c = 'NEW-New Engine Warranty 67';
        lstsolcomp.add(solCompObj);
        CSS_Solution_Component__c solCompObj1 = new CSS_Solution_Component__c();
        //     solCompObj1.Service_Job__c = jo.Id;
        solCompObj1.Selected_Component__c = true;
        solCompObj1.CSS_Claims__c = claimsObj.id;
        solCompObj1.Type__c = 'OTH';//'Campaign';
        solCompObj1.AccountCode__c ='testing';
        solCompObj1.Notes__c = 'testNotes';
        solCompObj1.Pay_Code__c='testPay';        
        solCompObj1.AccountCodeType__c  = 'NEW-New Engine Warranty';
        solCompObj1.AccountCode__c = '67';
        solCompObj1.AccountCodeEdit__c = 'NEW-New Engine Warranty 67';
        lstsolcomp.add(solCompObj1);
        insert lstsolcomp;
        
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = true;
        psnRec.Primary__c=true;
        psnRec.Application__c = 'filterApplication';
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        insert psnRec;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims4 = new CG_CL_ClaimsIntake();
        claims4.multipsnchecbox();
        
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_multipsn()
    {	
        
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='1213';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        lstjo.add(jo);
        insert lstjo;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Information_Only_Claim__c = True;
        claimsObj.Status__c='Submitted';
        // claimsObj.CSS_Job__c = jo.id;
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        //     solCompObj.Service_Job__c = jo.Id;
        solCompObj.Selected_Component__c = false;
        solCompObj.CSS_Claims__c = claimsObj.id;
        solCompObj.Type__c = 'POL';//'Campaign';
        solCompObj.AccountCode__c ='testing';
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';        
        solCompObj.AccountCodeType__c  = 'NEW-New Engine Warranty 67';
        solCompObj.AccountCode__c = '67';
        solCompObj.AccountCodeEdit__c = 'NEW-New Engine Warranty 67';
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = true;
        psnRec.Primary__c=true;
        psnRec.Application__c = 'filterApplication';
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        insert psnRec;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        CG_CL_ClaimsIntake claims4 = new CG_CL_ClaimsIntake();
        
        claims4.MultipsncheckboxEnable=false;
        //claims4.hasfieldactions=false;
        
        claims4.multipsnchecbox();
        
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod8()
    {	
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        //Cache.Session.put('ManualClaimsSelectedLocation','ManualClaimsSelectedLocation');
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        // String ManualClaimsLoc = 'ManualClaimsSelectedLocation';
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        //UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, //UserRoleId = empRole.id ,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '02650-97895');
        insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650-97895');
        insert userLocation;
        
        //   system.runAs(u){
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            
            CSS_accountLanguage__c accountlang = css_utility.getLanguage(u.LanguageLocaleKey);
            
            
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Customer_Name__c = 'CumminsTnD';
            JO.ESN__c = '79464646';
            JO.Mileage_Measure__c='19';
            JO.Account__c=acc.id;
            JO.Qsol_Engine_Family_Code__c='IN';
            insert JO;
            
            CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
            accLan.CSS_QsolLanguage__c = 'en';
            accLan.Name = 'en_US';
            insert accLan;
            
            CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
            Blob key = Blob.valueOf('12345678901234567890123456789012');
            string algo = 'AES256';
            inte.Name = 'CSS_SPDataLookup'; 
            inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            inte.ApplicationName__c = 'CSS_SPDataLookup';
            inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte.IsActive__c = true;
            insert inte;
            system.debug('***inte***'+inte);
            CSS_Integration_Details__c inte1 = new CSS_Integration_Details__c();
            Blob key1 = Blob.valueOf('12345678901234567890123456789012');
            string algo1 = 'AES256';
            inte1.Name = 'SiebelClaimHistory';
            inte1.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
            inte1.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
            inte1.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('1234')));
            inte1.ApplicationName__c = 'SiebelClaimHistory';
            inte1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte1.IsActive__c = true;
            insert inte1;
            system.debug('***inte1***'+inte1);
            CSS_Integration_Details__c inte2 = new CSS_Integration_Details__c();
            Blob key2 = Blob.valueOf('12345678901234567890123456789012');
            string algo2 = 'AES256';
            inte2.Name = 'CG_ODMHeaderValidation';
            inte2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
            inte2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
            inte2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('1234')));
            inte2.ApplicationName__c = 'CG_ODMHeaderValidation';
            inte2.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte2.IsActive__c = true;
            insert inte2;
            system.debug('***inte2***'+inte2);
            CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
            Blob key3 = Blob.valueOf('12345678901234567890123456789012');
            string algo3 = 'AES256';
            inte3.Name = 'GetCampaign';
            inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
            inte3.ApplicationName__c = 'GetCampaign';
            inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte3.IsActive__c = true;
            insert inte3;
            system.debug('***inte3***'+inte3);
            CSS_getConnnectionDetails getConnectionDetailsRec = new CSS_getConnnectionDetails();
            CSS_Integration_Details__c endPointURL =CSS_getConnnectionDetails.getConnection(inte.Name);
            system.debug('*****endPointURL***'+endPointURL);
            string endPointURLonly = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
            system.debug('*****endPointURLonly***'+endPointURLonly);
            CSS_Integration_Details__c conDetails12 = CSS_Integration_Details__c.getValues('CSS_SPDataLookup');
            CSS_Integration_Details__c conDetails21 = CSS_Integration_Details__c.getValues('GetCampaign');
            CSS_Integration_Details__c conDetails22 = CSS_Integration_Details__c.getValues('SiebelClaimHistory');
            CSS_Integration_Details__c conDetails23 = CSS_Integration_Details__c.getValues('CG_ODMHeaderValidation');
            system.assert(conDetails12!=null);
            system.debug('conDetails12>>'+conDetails12);
            
            
            Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
            
            
            List<CSS_Accreditation__c> lstaccr = new List<CSS_Accreditation__c>();       
            CSS_Accreditation__c accr = new CSS_Accreditation__c();
            accr.Service_Model_Name__c = 'ISBE CM800';
            accr.Account__c = acc.id;
            accr.OEM_Code__c = '232';
            accr.EndDate__c = date.today() +7 ;
            accr.StartDate__c = date.today() + 4;
            lstaccr.add(accr);
            insert lstaccr;
            
            List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
            CSS_Claims__c claimsObj = new CSS_Claims__c();
            claimsObj.Service_Date__c = date.today();
            claimsObj.Country__c = 'India';
            claimsObj.Account__c=acc.id;
            claimsObj.State__c = 'PB';
            claimsObj.Email_Address__c='abc@abc.com';
            claimsObj.Dealer_Service_Job__c=JO.id;
            claimsObj.CSS_Job__c = JO.id;
            claimsObj.SP_WarrantyCertificationEndDate__c='2017-07-25 00:00:00';
            claimsList.add(claimsObj );
            insert claimsList;
            
            list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
            //     solCompObj.Service_Job__c = jo.Id;
            solCompObj.Selected_Component__c = true;
            solCompObj.CSS_Claims__c = claimsObj.id;
            solCompObj.Type__c = 'OTH';
            solCompObj.Failure_Mode__C = 'Test';
            solCompObj.name = 'Test';   
            solCompObj.AccountCode__c ='testing';
            solCompObj.AccountCodeType__c  = 'NEW-New Engine Warranty';
            solCompObj.AccountCode__c = '67';
            solCompObj.AccountCodeEdit__c = 'NEW-New Engine Warranty 67';
            lstsolcomp.add(solCompObj);
            insert lstsolcomp;
            
            List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
            CSS_PSN__c psnRec = new CSS_PSN__c();
            psnRec.Name='Test';
            psnRec.psn__c='79464646';
            psnRec.CSS_Claims__c=claimsObj.id;
            psnRec.Before_In_Service__c = false;
            psnRec.Primary__c=true;
            psnRec.Calibration_Before__c = '';
            psnRec.Calibration_After__c = '';
            psnRec.Justification__c = 'CFSE Direction';
            psnRec.Warranty_Start_Date__c = date.today();
            psnRec.Unit_Type__c = 'Test';
            psnRec.Application__c = 'Test';
            psnRec.Model__c = 'Test';
            psnRec.Mileage_Measure__c = 'Test';
            psnRec.Service_Model__c='Automotive';
            psnRec.Failure_Date__c=system.today();
            psnRec.Make__c = 'Test';
            psnlist.add(psnRec);
            //    insert psnRec;
            CSS_PSN__c psnRec1 = new CSS_PSN__c();
            psnRec1.Name='Test';
            psnRec1.psn__c='79464646';
            psnRec1.CSS_Claims__c=claimsObj.id;
            psnRec1.Before_In_Service__c = false;
            psnRec1.Primary__c=true;
            psnRec1.Calibration_Before__c = '';
            psnRec1.Calibration_After__c = '';
            psnRec1.Justification__c = 'CFSE Direction';
            psnRec1.Warranty_Start_Date__c = date.today();
            psnRec1.Unit_Type__c = '';
            psnRec1.Service_Model__c='Automotive';
            psnRec1.Failure_Date__c=system.today();
            psnlist.add(psnRec1);
            insert psnlist;
            //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(psnRec.PSN__c, psnRec.Service_Model__c,psnRec.Failure_Date__c, accountlang.CSS_QsolLanguage__c,psnRec.Id);
            
            ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
            CG_CL_ClaimsIntake claims5 = new CG_CL_ClaimsIntake();
            claims5.dealerUser=true;
            claims5.multipsnchecbox();
            //claims5.checkPopupsave();
            claims5.userObj=u;
            Test.setMock(HttpCalloutMock.class, new CG_OP_CampaignsresJSONMOck_Test()); 
            Test.startTest();
            
            claims5.pageAction();
            claims5.callgetCampaigns();
            Test.stopTest();
        } 
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod81()
    {	
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Account__c=acc.id;
        JO.Mileage_Measure__c='19';
        JO.Service_Model__c = 'Test';
        JO.Failure_Date__c = date.today() +6 ;
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.CSS_QsolLanguage__c = 'en';
        accLan.Name = 'en_US';
        insert accLan;
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'CSS_SPDataLookup';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SPDataLookup';
        inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte.IsActive__c = true;
        insert inte;
        system.debug('***inte***'+inte);
        CSS_Integration_Details__c inte1 = new CSS_Integration_Details__c();
        Blob key1 = Blob.valueOf('12345678901234567890123456789012');
        string algo1 = 'AES256';
        inte1.Name = 'SiebelClaimHistory';
        inte1.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
        inte1.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
        inte1.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('1234')));
        inte1.ApplicationName__c = 'SiebelClaimHistory';
        inte1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte1.IsActive__c = true;
        insert inte1;
        system.debug('***inte1***'+inte1);
        CSS_Integration_Details__c inte2 = new CSS_Integration_Details__c();
        Blob key2 = Blob.valueOf('12345678901234567890123456789012');
        string algo2 = 'AES256';
        inte2.Name = 'CG_ODMHeaderValidation';
        inte2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
        inte2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
        inte2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('1234')));
        inte2.ApplicationName__c = 'CG_ODMHeaderValidation';
        inte2.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte2.IsActive__c = true;
        insert inte2;
        system.debug('***inte2***'+inte2);
        CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'GetCampaign';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'GetCampaign';
        inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte3.IsActive__c = true;
        insert inte3;
        system.debug('***inte3***'+inte3);
        CSS_getConnnectionDetails getConnectionDetailsRec = new CSS_getConnnectionDetails();
        CSS_Integration_Details__c endPointURL =CSS_getConnnectionDetails.getConnection(inte.Name);
        system.debug('*****endPointURL***'+endPointURL);
        string endPointURLonly = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
        system.debug('*****endPointURLonly***'+endPointURLonly);
        CSS_Integration_Details__c conDetails12 = CSS_Integration_Details__c.getValues('CSS_SPDataLookup');
        CSS_Integration_Details__c conDetails21 = CSS_Integration_Details__c.getValues('GetCampaign');
        CSS_Integration_Details__c conDetails22 = CSS_Integration_Details__c.getValues('SiebelClaimHistory');
        CSS_Integration_Details__c conDetails23 = CSS_Integration_Details__c.getValues('CG_ODMHeaderValidation');
        system.assert(conDetails12!=null);
        system.debug('conDetails12>>'+conDetails12);
        
        
        Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
        
        List<CSS_Accreditation__c> lstaccr = new List<CSS_Accreditation__c>();       
        CSS_Accreditation__c accr = new CSS_Accreditation__c();
        accr.Service_Model_Name__c = 'ISBE CM800';
        // acc.Account__c = a.id;
        accr.OEM_Code__c = '232';
        accr.EndDate__c = date.today() +7 ;
        accr.StartDate__c = date.today() + 4;
        lstaccr.add(accr);
        insert lstaccr;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Account__c=acc.id;
        claimsObj.Country__c = 'India';
        //claimsObj.Account__c=acc.id;
        claimsObj.State__c = 'PB';
        claimsObj.Email_Address__c='abc@abc.com';
        claimsObj.CSS_Job__c = JO.id;
        claimsObj.SP_WarrantyCertificationEndDate__c='2017-07-25 00:00:00';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
        //     solCompObj.Service_Job__c = jo.Id;
        solCompObj.Selected_Component__c = true;
        solCompObj.CSS_Claims__c = claimsObj.id;
        solCompObj.Type__c = 'OTH';
        solCompObj.Failure_Mode__C = 'Test';
        solCompObj.name = 'Test';   
        solCompObj.AccountCode__c ='testing';
        solCompObj.AccountCodeType__c  = 'NEW-New Engine Warranty';
        solCompObj.AccountCode__c = '67';
        solCompObj.AccountCodeEdit__c = 'NEW-New Engine Warranty 67';
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        
        List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = false;
        psnRec.Primary__c=true;
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Warranty_Start_Date__c = date.today();
        psnRec.Unit_Type__c = null;
        psnRec.Application__c = null;
        psnRec.Model__c = null;
        psnRec.Mileage_Measure__c = null;
        
        psnRec.Make__c =null;
        psnlist.add(psnRec);
        //    insert psnRec;
        CSS_PSN__c psnRec1 = new CSS_PSN__c();
        psnRec1.Name='Test';
        psnRec1.psn__c='79464646';
        psnRec1.CSS_Claims__c=claimsObj.id;
        psnRec1.Before_In_Service__c = false;
        psnRec1.Primary__c=true;
        psnRec1.Calibration_Before__c = '';
        psnRec1.Calibration_After__c = '';
        psnRec1.Justification__c = 'CFSE Direction';
        psnRec1.Warranty_Start_Date__c = date.today();
        psnRec1.Unit_Type__c = '';
        psnlist.add(psnRec1);
        insert psnlist;
        
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims5 = new CG_CL_ClaimsIntake();
        claims5.multipsnchecbox();
        //claims5.checkPopupsave();
        
        Test.setMock(HttpCalloutMock.class, new CG_CAmpaignMock_Test()); 
        
        Test.startTest();
        List<List<CSS_CampTsbTrp__c>> lstCamp = CG_BL_Intake.getCampaigns(JO.esn__c, JO.Service_Model__c,JO.Failure_Date__c, 'en',JO.id);
        
        claims5.pageAction();
        
        //claims5.claimsRec.SP_WarrantyCertificationEndDate__c='12/08/2918';
        claims5.callgetCampaigns();
        Test.stopTest();
        
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod9()
    {	
        Test.startTest();
        
        //Insert Account
        List<Account>aclist = new List<Account>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        aclist.add(acc);
        insert aclist;
        
        string location1 = [select id,location__c from account where id=:aclist[0].id].location__c;
        
        //Insert Claim List
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.CSS_Job__c=null;
        claimsObj.Dealer_Service_Job__c=null;
        claimsObj.Css_paccar_approve_reject_flag__c='Not Applicable';
        claimsObj.Customer_Name__c='prashanthi';
        claimsObj.Shop_Work_Order__c='12345';
        claimsObj.Actual_Technician_Time__c=null;
        claimsObj.Status__c = 'Submitted';
        claimsObj.SP_PACCAR__c='N';
        claimsObj.Account__c=acc.id;
        claimsObj.Territory_Class__c='150';
        claimsObj.CSS_Channel_Code__c='122';
        claimsObj.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj );
        
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Service_Date__c = date.today();
        claimsObj1.Account__c=acc.id;
        claimsObj1.Territory_Class__c='150';
        claimsObj1.CSS_Channel_Code__c='122';
        claimsObj1.Customer_Name__c='';
        claimsObj1.Shop_Work_Order__c='12345';
        claimsObj1.Actual_Technician_Time__c=null;
        claimsObj1.Status__c = 'Submitted';
        ClaimsObj1.PACCAR_Flag__c=true;
        claimsObj1.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj1 );
        
        CSS_Claims__c claimsObj12 = new CSS_Claims__c();
        claimsObj12.Service_Date__c = date.today();
        claimsObj12.Account__c=acc.id;
        claimsObj12.Territory_Class__c='150';
        claimsObj12.CSS_Channel_Code__c='122';
        claimsObj12.Customer_Name__c='';
        claimsObj12.Shop_Work_Order__c='12345';
        claimsObj12.Actual_Technician_Time__c=null;
        claimsObj12.Status__c = 'Draft';
        ClaimsObj12.PACCAR_Flag__c=true;
        claimsObj12.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj12 );
        insert claimsList;
        
        //Insert PsnList
        List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = false;
        psnRec.Primary__c=true;
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Warranty_Start_Date__c = date.today();
        psnRec.Unit_Type__c = null;
        psnRec.Application__c = 'test';
        psnrec.Make__c='test';
        psnRec.Model__c = 'test';
        psnRec.Mileage_Measure__c = null;
        psnRec.PACCAR_Flag__c='N';
        psnRec.Make__c =null;
        psnlist.add(psnRec);
        
        CSS_PSN__c psnRec1 = new CSS_PSN__c();
        psnRec1.Name='Test';
        psnRec1.psn__c='79464646';
        psnRec1.CSS_Claims__c=claimsObj.id;
        psnRec1.Before_In_Service__c = false;
        psnRec1.Primary__c=true;
        psnRec1.Calibration_Before__c = 'test';
        psnRec1.Calibration_After__c = 'test';
        psnRec1.Justification__c = '----Select One----';
        psnRec1.Warranty_Start_Date__c = null;
        psnRec1.Unit_Type__c = '';
        psnRec1.Failure_Date__c=system.today()+6;
        psnRec1.License_Plate_State__c='AK - Alaska';
        psnlist.add(psnRec1);
        insert psnlist;
        
        
        //Insert JET List
        List<CSS_JobEventTemporary__c> claimListOld = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c=claimsObj1.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        claimListOld.add(jobevent);
        insert claimListOld;
        
        
        //Integration details
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>(); 
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c=null;
        ie1.Response_Body__c='test';
        lstClaimsIntDetails.add(ie1);
        
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        lstClaimsIntDetails.add(ie2);
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'CSS_SPDataLookup'; 
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SPDataLookup';
        inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte.IsActive__c = true;
        insert inte;
        
        
        //Mock class
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        
        //Getting current page id    
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        
        CG_PACCAR_Flag_SP_Info_Mapping__c CGPF =  new CG_PACCAR_Flag_SP_Info_Mapping__c();
        CGPF.Name = '122-150';
        CGPF.Channel_of_distribution__c = '122';
        CGPF.Territory__c = '150';
        insert CGPF;
        
        //Instantiating the class
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        claims6.filterApplication='test';
        claims6.filterMake='test';
        claims6.filterModel='test';
        claims6.existingPSN='123456767';
        String temp=claimsObj1.Territory_Class__c +'-'+ claimsObj1.CSS_Channel_Code__c;
        claims6.paccarCustomSettingValues=CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
        
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        Cache.Session.put('ManualClaimsSelectedLocation',location);
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        claims6.saveClaim(claimsObj.id, 'Draft');
        claims6.saveClaim(null, 'Draft');
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=jo.id;
        psnRec.ApplicationCode__c = null;
        
        claimsObj.CSS_Job__c=null;
        claimsObj.Dealer_Service_Job__c=jo.id;
        psnRec.ApplicationCode__c = null;
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=null;
        psnRec.ApplicationCode__c = null;
        
        List<CSS_Integration_Error__c> IEList = CG_BL_ODM.callODMHeaderValidationClaimService(null,claimsObj,psnRec,'CLAIM',null,'WarrantyOverview');
        system.debug('IEList>>88'+IEList);       
        String penaltyValue;
        string repSPdataClaims;
        
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        repSPdataClaims=CSS_FN_SIEBEL.getServiceProviderDataClaims('SPCode', 'ServiceModelName', 'FailureDateString', claimsObj.Id);
        claims6.claimsRec=claimsObj12;
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod989()
    {	
        
        
        List<Account>aclist = new List<Account>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Service_Model__c = 'Test';
        JO.Failure_Date__c = date.today() +6 ;
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Account__c=acc.id;
        insert JO;
        aclist.add(acc);
        string location1 = [select id,location__c from account where id=:aclist[0].id].location__c;
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.CSS_Job__c=JO.id;
        claimsObj.Dealer_Service_Job__c=JO.id;
        claimsObj.Css_paccar_approve_reject_flag__c='Not Applicable';
        claimsObj.Customer_Name__c='prashanthi';
        claimsObj.Shop_Work_Order__c='12345';
        claimsObj.Actual_Technician_Time__c=null;
        claimsObj.Status__c = 'Submitted';
        claimsObj.SP_PACCAR__c='N';
        claimsObj.Account__c=acc.id;
        claimsObj.Territory_Class__c='100';
        claimsObj.CSS_Channel_Code__c='101';
        claimsObj.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj );
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Service_Date__c = date.today();
        claimsObj1.Territory_Class__c='100';
        claimsObj1.CSS_Channel_Code__c='110';
        claimsObj1.Customer_Name__c='';
        claimsObj1.Shop_Work_Order__c='12345';
        claimsObj1.Actual_Technician_Time__c=null;
        claimsObj1.Status__c = 'Submitted';
        ClaimsObj1.PACCAR_Flag__c=true;
        claimsObj1.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj1 );
        CSS_Claims__c claimsObj12 = new CSS_Claims__c();
        claimsObj12.Service_Date__c = date.today();
        claimsObj12.Territory_Class__c='100';
        claimsObj12.CSS_Channel_Code__c='110';
        claimsObj12.Customer_Name__c='';
        claimsObj12.Shop_Work_Order__c='12345';
        claimsObj12.Actual_Technician_Time__c=null;
        claimsObj12.Status__c = 'Draft';
        ClaimsObj12.PACCAR_Flag__c=true;
        claimsObj12.Pending_Authorization__c ='Not Authorized';
        // claimsObj12.Account_Code__c = null;
        //claimsObj12.FailCode__c = 'test';
        claimsList.add(claimsObj12 );
        insert claimsList;
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CSS_Claims__c=claimsList[0].id;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Type__c='test';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBTAC';
        insert solcomp;
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.CSS_Claims__c=claimsList[0].id;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'EEBTAC';
        partsoption.Type__c='Meals'; 
        partsoption.Account_Code__c = '';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        insert partsoption;
        selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.CSS_Claims__c=claimsList[0].id;
        partsoption1.Item__c = 'Unlisted';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'EEBTAC';
        partsoption1.Account_Code__c = '';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.css_estimate__c = true;
        partsoption1.selected_part__c = true;
        partsoption1.PartOC__c = 'OC';
        insert partsoption1;
        
        List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = false;
        psnRec.Primary__c=true;
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Warranty_Start_Date__c = date.today();
        psnRec.Unit_Type__c = null;
        psnRec.Application__c = 'test';
        psnrec.Make__c='test';
        psnRec.Model__c = 'test';
        psnRec.Mileage_Measure__c = null;
        psnRec.PACCAR_Flag__c='N';
        psnRec.Make__c =null;
        psnlist.add(psnRec);
        //    insert psnRec;
        CSS_PSN__c psnRec1 = new CSS_PSN__c();
        psnRec1.Name='Test';
        psnRec1.psn__c='79464646';
        psnRec1.CSS_Claims__c=claimsObj.id;
        psnRec1.Before_In_Service__c = false;
        psnRec1.Primary__c=true;
        psnRec1.Calibration_Before__c = 'test';
        psnRec1.Calibration_After__c = 'test';
        psnRec1.Justification__c = '----Select One----';
        psnRec1.Warranty_Start_Date__c = null;
        psnRec1.Unit_Type__c = '';
        psnRec1.Failure_Date__c=system.today()+6;
        psnRec1.License_Plate_State__c='AK - Alaska';
        psnlist.add(psnRec1);
        insert psnlist;
        
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Name = 'Wenchin Shetty';
        srt.Account_Code__c = null;
        srt.CSS_Claims__c=claimsObj.id;
        srt.FailCode__c = 'EEBTAC';
        insert srt;
        
        List<CSS_JobEventTemporary__c> claimListOld = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c=claimsObj1.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        claimListOld.add(jobevent);
        
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c=null;
        ie1.Response_Body__c='test';
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>();
        lstClaimsIntDetails.add(ie1);
        lstClaimsIntDetails.add(ie2);
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'CSS_SPDataLookup'; 
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SPDataLookup';
        inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte.IsActive__c = true;
        insert inte;
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        
        claims6.filterApplication='test';
        claims6.filterMake='test';
        claims6.filterModel='test';
        claims6.existingPSN='123456767';
        String temp=claimsObj1.Territory_Class__c +'-'+ claimsObj1.CSS_Channel_Code__c;
        claims6.paccarCustomSettingValues=CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
        //  Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        Cache.Session.put('ManualClaimsSelectedLocation',location);
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        claims6.saveClaim(claimsObj.id, 'Draft');
        claims6.saveClaim(null, 'Draft');
        
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod91()
    {	
        Test.startTest();
        List<Account>aclist = new List<Account>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        aclist.add(acc);
        string location1 = [select id,location__c from account where id=:aclist[0].id].location__c;
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.CSS_Job__c=null;
        claimsObj.Dealer_Service_Job__c=null;
        claimsObj.Css_paccar_approve_reject_flag__c='Not Applicable';
        claimsObj.Customer_Name__c='prashanthi';
        claimsObj.Shop_Work_Order__c='12345';
        claimsObj.Actual_Technician_Time__c=null;
        claimsObj.Status__c = 'Draft';
        claimsObj.SP_PACCAR__c='N';
        claimsObj.Account__c=acc.id;
        claimsObj.Territory_Class__c='100';
        claimsObj.CSS_Channel_Code__c='101';
        claimsObj.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj );
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Service_Date__c = date.today();
        claimsObj1.Territory_Class__c='100';
        claimsObj1.CSS_Channel_Code__c='110';
        claimsObj1.Customer_Name__c='';
        claimsObj1.Shop_Work_Order__c='12345';
        claimsObj1.Actual_Technician_Time__c=null;
        claimsObj1.Status__c = 'Draft';
        ClaimsObj1.PACCAR_Flag__c=true;
        claimsObj1.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj1 );
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        CSS_Claims__c claimsObj12 = new CSS_Claims__c();
        claimsObj12.Service_Date__c = date.today();
        claimsObj12.Territory_Class__c='100';
        claimsObj12.CSS_Channel_Code__c='110';
        claimsObj12.Customer_Name__c='';
        claimsObj12.Shop_Work_Order__c='12345';
        claimsObj12.Actual_Technician_Time__c=null;
        claimsObj12.Status__c = 'Draft';
        claimsObj12.CSS_Job__c=jo.id;
        ClaimsObj12.PACCAR_Flag__c=true;
        claimsObj12.Pending_Authorization__c ='Not Authorized';
        claimsObj12.FieldActionWebServiceResult__c='Error';
        claimsList.add(claimsObj12 );
        insert claimsList;
        List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = false;
        psnRec.Primary__c=true;
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Warranty_Start_Date__c = date.today();
        psnRec.Unit_Type__c = null;
        psnRec.Application__c = 'test';
        psnrec.Make__c='test';
        psnRec.Model__c = 'test';
        psnRec.Mileage_Measure__c = null;
        psnRec.PACCAR_Flag__c='N';
        psnRec.Make__c =null;
        psnlist.add(psnRec);
        //    insert psnRec;
        CSS_PSN__c psnRec1 = new CSS_PSN__c();
        psnRec1.Name='Test';
        psnRec1.psn__c='79464646';
        psnRec1.CSS_Claims__c=claimsObj.id;
        psnRec1.Before_In_Service__c = false;
        psnRec1.Primary__c=true;
        psnRec1.Calibration_Before__c = 'test';
        psnRec1.Calibration_After__c = 'test';
        psnRec1.Justification__c = '----Select One----';
        psnRec1.Warranty_Start_Date__c = null;
        psnRec1.Unit_Type__c = '';
        psnRec1.Failure_Date__c=system.today()+6;
        psnRec1.License_Plate_State__c='AK - Alaska';
        psnlist.add(psnRec1);
        insert psnlist;
        List<CSS_JobEventTemporary__c> claimListOld = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c=claimsObj1.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        claimListOld.add(jobevent);
        
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c=null;
        ie1.Response_Body__c='test';
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>();
        lstClaimsIntDetails.add(ie1);
        lstClaimsIntDetails.add(ie2);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        
        claims6.filterApplication='test';
        claims6.filterMake='test';
        claims6.filterModel='test';
        claims6.existingPSN='123456767';
        String temp=claimsObj1.Territory_Class__c +'-'+ claimsObj1.CSS_Channel_Code__c;
        claims6.paccarCustomSettingValues=CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        Cache.Session.put('ManualClaimsSelectedLocation',location);
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        claims6.saveClaim(claimsObj.id, 'Draft');
        claims6.saveClaim(null, 'Draft');
        
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=jo.id;
        psnRec.ApplicationCode__c = null;
        //claims6.saveClaim(null, 'Submitted');
        claimsObj.CSS_Job__c=null;
        claimsObj.Dealer_Service_Job__c=jo.id;
        psnRec.ApplicationCode__c = null;
        // claims6.saveClaim(claimsObj1.id, 'Submitted');
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=null;
        psnRec.ApplicationCode__c = null;
        Test.setMock(HttpCalloutMock.class, new CG_ODM_ResJSONParser_Mock());
        List<CSS_Integration_Error__c> IEList = CG_BL_ODM.callODMHeaderValidationClaimService(null,claimsObj,psnRec,'CLAIM',null,'WarrantyOverview');
        system.debug('IEList>>88'+IEList);       
        String penaltyValue;
        string repSPdataClaims;
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        repSPdataClaims=CSS_FN_SIEBEL.getServiceProviderDataClaims('SPCode', 'ServiceModelName', 'FailureDateString', claimsObj.Id);
        claims6.claimsRec=claimsObj12;
        claims6.psnRec=psnRec;
        claims6.servDate='2/2/2015';
        claims6.repairCompdate='2/2/2015';
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod911()
    {	
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'CSS_SPDataLookup'; 
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SPDataLookup';
        inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte.IsActive__c = true;
        insert inte;
        List<Account>aclist = new List<Account>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        aclist.add(acc);
        string location1 = [select id,location__c from account where id=:aclist[0].id].location__c;
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=null;
        claimsObj.Css_paccar_approve_reject_flag__c='Not Applicable';
        claimsObj.Customer_Name__c='prashanthi';
        claimsObj.Shop_Work_Order__c='12345';
        claimsObj.Actual_Technician_Time__c=null;
        claimsObj.Status__c = 'Draft';
        claimsObj.SP_PACCAR__c='N';
        claimsObj.Account__c=acc.id;
        claimsObj.Territory_Class__c='100';
        claimsObj.CSS_Channel_Code__c='101';
        claimsObj.Pending_Authorization__c ='Not Authorized';
        claimsObj.FieldActionWebServiceResult__c = 'Error';
        claimsList.add(claimsObj );
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Service_Date__c = date.today();
        claimsObj1.Territory_Class__c='100';
        claimsObj1.CSS_Channel_Code__c='110';
        claimsObj1.Customer_Name__c='';
        claimsObj1.Shop_Work_Order__c='12345';
        claimsObj1.Actual_Technician_Time__c=null;
        claimsObj1.Status__c = 'Draft';
        ClaimsObj1.PACCAR_Flag__c=true;
        claimsObj1.Pending_Authorization__c ='Not Authorized';
        claimsObj1.FieldActionWebServiceResult__c = 'Error';
        claimsList.add(claimsObj1 );
        
        CSS_Claims__c claimsObj12 = new CSS_Claims__c();
        claimsObj12.Service_Date__c = date.today();
        claimsObj12.Territory_Class__c='100';
        claimsObj12.CSS_Channel_Code__c='110';
        claimsObj12.Customer_Name__c='';
        claimsObj12.Shop_Work_Order__c='12345';
        claimsObj12.Actual_Technician_Time__c=null;
        claimsObj12.Status__c = 'Draft';
        claimsObj12.CSS_Job__c=jo.id;
        ClaimsObj12.PACCAR_Flag__c=true;
        claimsObj12.Pending_Authorization__c ='Not Authorized';
        claimsObj12.FieldActionWebServiceResult__c='Error';
        claimsList.add(claimsObj12 );
        insert claimsList;
        list<CSS_Solution_Component__c> lstsolcomp=new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj=new CSS_Solution_Component__c();
        solCompObj.Type__c ='Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';
        
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';
        solCompObj.Status__c='Approved';
        solCompObj.CSS_Claims__c =claimsList[0].id;
        solCompObj.Fail_Code_Editable__c='Electrical Connector-abcdef';
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        Id recTypeIdpart2 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart2;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'abcdef';
        partsoption.Type__c='Custom'; 
        partsoption.Account_Code__c = '';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.CSS_Claims__c = claimsList[0].id;
        insert partsoption;
        selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Unlisted';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'abcdef';
        partsoption1.Account_Code__c = '';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.CSS_Claims__c = claimsList[0].id;
        partsoption1.css_estimate__c = true;
        partsoption1.selected_part__c = true;
        partsoption1.PartOC__c = 'OC';
        insert partsoption1;
        CSS_Parts_Options__c partsoption11 = new CSS_Parts_Options__c();
        partsoption11.quantity__c = 100;
        partsoption11.RecordTypeId = recTypeIdpart1;
        partsoption11.Item__c = 'Unlisted';
        partsoption11.Covered__c = 100;
        partsoption11.Amount__c = 122;
        partsoption11.Type__c='Non Commercial-Travel'; 
        partsoption11.Fail_Code__c = 'abcdef';
        partsoption11.Account_Code__c = '';
        partsoption11.Part_Description__c = 'test-PD';
        partsoption11.CSS_Claims__c = claimsList[0].id;
        partsoption11.css_estimate__c = true;
        partsoption11.selected_part__c = true;
        partsoption11.PartOC__c = 'OC';
        insert partsoption11;
        CSS_Parts_Options__c partsoption12 = new CSS_Parts_Options__c();
        partsoption12.quantity__c = 100;
        partsoption12.RecordTypeId = recTypeIdpart1;
        partsoption12.Item__c = 'Unlisted';
        partsoption12.Covered__c = 100;
        partsoption12.Amount__c = 122;
        partsoption12.Type__c='Towing'; 
        partsoption12.Fail_Code__c = 'abcdef';
        partsoption12.Account_Code__c = '';
        partsoption12.Part_Description__c = 'test-PD';
        partsoption12.CSS_Claims__c = claimsList[0].id;
        partsoption12.css_estimate__c = true;
        partsoption12.selected_part__c = true;
        partsoption12.PartOC__c = 'OC';
        insert partsoption12;
        CSS_Parts_Options__c partsoption121 = new CSS_Parts_Options__c();
        partsoption121.quantity__c = 100;
        partsoption121.RecordTypeId = recTypeIdpart1;
        partsoption121.Item__c = 'Unlisted';
        partsoption121.Covered__c = 100;
        partsoption121.Amount__c = 122;
        partsoption121.Type__c='Meals'; 
        partsoption121.Fail_Code__c = 'abcdef';
        partsoption121.Account_Code__c = '';
        partsoption121.Part_Description__c = 'test-PD';
        partsoption121.CSS_Claims__c = claimsList[0].id;
        partsoption121.css_estimate__c = true;
        partsoption121.selected_part__c = true;
        partsoption121.PartOC__c = 'OC';
        insert partsoption121;
        list<CSS_SRT__C> lstsrt = new list<CSS_SRT__C>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.Type__c='Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 1;
        srt.CSS_Claims__c =claimsList[0].id ;
        srt.type__c = 'Diagnosis';
        srt.srt_category__c = '';//'Campaign';//'AdditionalRep';
        srt.SRT_Type__c='Campaign';
        srt.FailCode__c='abcdef';
        //srt.Additional_SRT_Calculated__c=2.3;
        lstsrt.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.Type__c = 'Repair';
        srt1.isPerformed__c=true;
        srt1.srt_category__c = '';
        srt1.Assignment__c = 'Primary';
        srt1.CSS_Claims__c =claimsList[0].id ;
        srt1.Extended_Hours__c=2.0;
        srt1.FailCode__c='abcdef';
        lstsrt.add(srt1);
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = true;
        srt2.Extended_Hours__c =2.0;
        srt2.CSS_Claims__c =claimsList[0].id ;
        srt2.FailCode__c='abcdef';
        //srt2.type__c = 'Diagnosis';
        srt2.srt_category__c = 'AdditionalRep';//'Campaign';//'AdditionalRep';
        srt2.SRT_Type__c='Campaign';
        lstsrt.add(srt2);
        CSS_SRT__c srt3 = new CSS_SRT__c();
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.Access_Code_A__c = 65;
        srt3.name = 'TestClassName';
        //srt3.type__c = '';
        srt3.Assignment__c = 'PRIMARY';
        srt3.srt_time__c = 1;
        srt3.FailCode__c='abcdef';
        srt3.SRT_ID__c = '00-901-10';
        srt3.isPerformed__c = true;
        srt3.Extended_Hours__c =2.0;
        srt3.CSS_Claims__c =claimsList[0].id ;
        srt3.type__c = 'Diagnosis';
        srt3.srt_category__c = 'AdditionalRep';//'Campaign';//'AdditionalRep';
        srt3.SRT_Type__c='99Time';
        lstsrt.add(srt3);
        CSS_SRT__c srt4 = new CSS_SRT__c();
        srt4.SRT_AccessiblityCheck__c=True;
        srt4.Access_Code_A__c = 65;
        srt4.name = 'TestClassName';
        srt4.type__c = 'Campaign';
        srt4.FailCode__c='abcdef';
        srt4.Assignment__c = 'PRIMARY';
        srt4.srt_time__c = 1;
        srt4.SRT_ID__c = '00-901-10';
        srt4.isPerformed__c = true;
        srt4.Extended_Hours__c =2.0;
        srt4.CSS_Claims__c =claimsList[0].id ;
        //srt4.type__c = 'Diagnosis';
        srt4.srt_category__c = 'Campaign';//'Campaign';//'AdditionalRep';
        //srt4.SRT_Type__c='Campaign';
        lstsrt.add(srt4);
        CSS_SRT__c srt5 = new CSS_SRT__c();
        srt5.SRT_AccessiblityCheck__c=True;
        srt5.Access_Code_A__c = 65;
        srt5.name = 'TestClassName';
        srt5.type__c = 'Field Action';
        srt5.Assignment__c = 'PRIMARY';
        srt5.srt_time__c = 1;
        srt5.FailCode__c='abcdef';
        srt5.SRT_ID__c = '00-901-10';
        srt5.isPerformed__c = true;
        srt5.Extended_Hours__c =2.0;
        srt5.CSS_Claims__c =claimsList[0].id ;
        //srt5.type__c = 'Diagnosis';
        srt5.srt_category__c = 'TRP';//'Campaign';//'AdditionalRep';
        srt5.SRT_Type__c='TRP';
        lstsrt.add(srt5);
        CSS_SRT__c srt6 = new CSS_SRT__c();
        srt6.SRT_AccessiblityCheck__c=True;
        srt6.Access_Code_A__c = 65;
        srt6.name = 'TestClassName';
        srt6.type__c = 'Field Action';
        srt6.Assignment__c = 'PRIMARY';
        srt6.srt_time__c = 1;
        srt6.SRT_ID__c = '00-901-10';
        srt6.FailCode__c='abcdef';
        srt6.isPerformed__c = true;
        srt6.Extended_Hours__c =2.0;
        srt6.CSS_Claims__c =claimsList[0].id ;
        //srt6.type__c = 'Diagnosis';
        srt6.srt_category__c = 'ATC';//'Campaign';//'AdditionalRep';
        srt6.SRT_Type__c='ATC';
        lstsrt.add(srt6);
        CSS_SRT__c srt7 = new CSS_SRT__c();
        srt7.SRT_AccessiblityCheck__c=True;
        srt7.Access_Code_A__c = 65;
        srt7.name = 'TestClassName';
        srt7.type__c = '99Time';
        srt7.FailCode__c='abcdef';
        srt7.Assignment__c = 'PRIMARY';
        srt7.srt_time__c = 1.2;
        srt7.SRT_ID__c = '00-901-10';
        srt7.isPerformed__c = true;
        srt7.Extended_Hours__c =2.0;
        srt7.CSS_Claims__c =claimsList[0].id ;
        //srt7.type__c = 'Diagnosis';
        srt7.srt_category__c = 'ATC';//'Campaign';//'AdditionalRep';
        srt7.SRT_Type__c='ATC';
        lstsrt.add(srt7);
        
        
        insert lstsrt;
        List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = false;
        psnRec.Primary__c=true;
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Warranty_Start_Date__c = date.today();
        psnRec.Unit_Type__c = null;
        psnRec.Application__c = 'test';
        psnrec.Make__c='test';
        psnRec.Model__c = 'test';
        psnRec.Mileage_Measure__c = null;
        psnRec.PACCAR_Flag__c='N';
        psnRec.Make__c =null;
        psnlist.add(psnRec);
        //    insert psnRec;
        CSS_PSN__c psnRec1 = new CSS_PSN__c();
        psnRec1.Name='Test';
        psnRec1.psn__c='79464646';
        psnRec1.CSS_Claims__c=claimsObj.id;
        psnRec1.Before_In_Service__c = false;
        psnRec1.Primary__c=true;
        psnRec1.Calibration_Before__c = 'test';
        psnRec1.Calibration_After__c = 'test';
        psnRec1.Justification__c = '----Select One----';
        psnRec1.Warranty_Start_Date__c = null;
        psnRec1.Unit_Type__c = '';
        psnRec1.Failure_Date__c=system.today()+6;
        psnRec1.License_Plate_State__c='AK - Alaska';
        psnlist.add(psnRec1);
        insert psnlist;
        List<CSS_JobEventTemporary__c> claimListOld = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c=claimsObj1.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        claimListOld.add(jobevent);
        
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c=null;
        ie1.Response_Body__c='test';
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>();
        lstClaimsIntDetails.add(ie1);
        lstClaimsIntDetails.add(ie2);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        
        claims6.filterApplication='test';
        claims6.filterMake='test';
        claims6.filterModel='test';
        claims6.existingPSN='123456767';
        String temp=claimsObj1.Territory_Class__c +'-'+ claimsObj1.CSS_Channel_Code__c;
        claims6.paccarCustomSettingValues=CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
        Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        Cache.Session.put('ManualClaimsSelectedLocation',location);
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        claims6.saveClaim(claimsObj.id, 'Draft');
        claims6.saveClaim(null, 'Draft');
        
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=jo.id;
        psnRec.ApplicationCode__c = null;
        //claims6.saveClaim(null, 'Submitted');
        claimsObj.CSS_Job__c=null;
        claimsObj.Dealer_Service_Job__c=jo.id;
        psnRec.ApplicationCode__c = null;
        // claims6.saveClaim(claimsObj1.id, 'Submitted');
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=null;
        psnRec.ApplicationCode__c = null;
        Test.setMock(HttpCalloutMock.class, new CG_ODM_ResJSONParser_Mock());
        List<CSS_Integration_Error__c> IEList = CG_BL_ODM.callODMHeaderValidationClaimService(null,claimsObj,psnRec,'CLAIM',null,'WarrantyOverview');
        system.debug('IEList>>88'+IEList);       
        String penaltyValue;
        string repSPdataClaims;
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        repSPdataClaims=CSS_FN_SIEBEL.getServiceProviderDataClaims('SPCode', 'ServiceModelName', 'FailureDateString', claimsObj.Id);
        claims6.claimsRec=claimsObj12;
        claims6.psnRec=psnRec;
        claims6.servDate='2/2/2015';
        claims6.repairCompdate='2/2/2015';
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod9112()
    {	
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'CSS_SPDataLookup'; 
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SPDataLookup';
        inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte.IsActive__c = true;
        insert inte;
        List<Account>aclist = new List<Account>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        aclist.add(acc);
        string location1 = [select id,location__c from account where id=:aclist[0].id].location__c;
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.CSS_Job__c=jo.id;
        claimsObj.Dealer_Service_Job__c=null;
        claimsObj.Css_paccar_approve_reject_flag__c='Not Applicable';
        claimsObj.Customer_Name__c='prashanthi';
        claimsObj.Shop_Work_Order__c='12345';
        claimsObj.Actual_Technician_Time__c=null;
        claimsObj.Status__c = 'Draft';
        claimsObj.SP_PACCAR__c='N';
        claimsObj.Account__c=acc.id;
        claimsObj.Territory_Class__c='100';
        claimsObj.CSS_Channel_Code__c='101';
        claimsObj.Pending_Authorization__c ='Not Authorized';
        claimsObj.FieldActionWebServiceResult__c = 'Error';
        claimsList.add(claimsObj );
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Service_Date__c = date.today();
        claimsObj1.Territory_Class__c='100';
        claimsObj1.CSS_Channel_Code__c='110';
        claimsObj1.Customer_Name__c='';
        claimsObj1.Shop_Work_Order__c='12345';
        claimsObj1.Actual_Technician_Time__c=null;
        claimsObj1.Status__c = 'Draft';
        ClaimsObj1.PACCAR_Flag__c=true;
        claimsObj1.Pending_Authorization__c ='Not Authorized';
        claimsObj1.FieldActionWebServiceResult__c = 'Error';
        claimsList.add(claimsObj1 );
        
        CSS_Claims__c claimsObj12 = new CSS_Claims__c();
        claimsObj12.Service_Date__c = date.today();
        claimsObj12.Territory_Class__c='100';
        claimsObj12.CSS_Channel_Code__c='110';
        claimsObj12.Customer_Name__c='';
        claimsObj12.Shop_Work_Order__c='12345';
        claimsObj12.Actual_Technician_Time__c=null;
        claimsObj12.Status__c = 'Draft';
        claimsObj12.CSS_Job__c=jo.id;
        ClaimsObj12.PACCAR_Flag__c=true;
        claimsObj12.Pending_Authorization__c ='Not Authorized';
        claimsObj12.FieldActionWebServiceResult__c='Error';
        claimsList.add(claimsObj12 );
        insert claimsList;
        list<CSS_Solution_Component__c> lstsolcomp=new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solCompObj=new CSS_Solution_Component__c();
        solCompObj.Type__c ='Campaign';
        solCompObj.Selected_Component__c= true; 
        solCompObj.AccountCode__c ='testing';
        
        solCompObj.Notes__c = 'testNotes';
        solCompObj.Pay_Code__c='testPay';
        solCompObj.Status__c='Approved';
        solCompObj.CSS_Claims__c =claimsList[0].id;
        solCompObj.Fail_Code_Editable__c='Electrical Connector-abcdef';
        lstsolcomp.add(solCompObj);
        insert lstsolcomp;
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        Id recTypeIdpart2 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart2;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'abcdef';
        partsoption.Type__c='Custom'; 
        partsoption.Account_Code__c = '';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.CSS_Claims__c = claimsList[0].id;
        insert partsoption;
        selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Unlisted';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'abcdef';
        partsoption1.Account_Code__c = '';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.CSS_Claims__c = claimsList[0].id;
        partsoption1.css_estimate__c = true;
        partsoption1.selected_part__c = true;
        partsoption1.PartOC__c = 'OC';
        insert partsoption1;
        CSS_Parts_Options__c partsoption11 = new CSS_Parts_Options__c();
        partsoption11.quantity__c = 100;
        partsoption11.RecordTypeId = recTypeIdpart1;
        partsoption11.Item__c = 'Unlisted';
        partsoption11.Covered__c = 100;
        partsoption11.Amount__c = 122;
        partsoption11.Type__c='Non Commercial-Travel'; 
        partsoption11.Fail_Code__c = 'abcdef';
        partsoption11.Account_Code__c = '';
        partsoption11.Part_Description__c = 'test-PD';
        partsoption11.CSS_Claims__c = claimsList[0].id;
        partsoption11.css_estimate__c = true;
        partsoption11.selected_part__c = true;
        partsoption11.PartOC__c = 'OC';
        insert partsoption11;
        CSS_Parts_Options__c partsoption12 = new CSS_Parts_Options__c();
        partsoption12.quantity__c = 100;
        partsoption12.RecordTypeId = recTypeIdpart1;
        partsoption12.Item__c = 'Unlisted';
        partsoption12.Covered__c = 100;
        partsoption12.Amount__c = 122;
        partsoption12.Type__c='Towing'; 
        partsoption12.Fail_Code__c = 'abcdef';
        partsoption12.Account_Code__c = '';
        partsoption12.Part_Description__c = 'test-PD';
        partsoption12.CSS_Claims__c = claimsList[0].id;
        partsoption12.css_estimate__c = true;
        partsoption12.selected_part__c = true;
        partsoption12.PartOC__c = 'OC';
        insert partsoption12;
        CSS_Parts_Options__c partsoption121 = new CSS_Parts_Options__c();
        partsoption121.quantity__c = 100;
        partsoption121.RecordTypeId = recTypeIdpart1;
        partsoption121.Item__c = 'Unlisted';
        partsoption121.Covered__c = 100;
        partsoption121.Amount__c = 122;
        partsoption121.Type__c='Meals'; 
        partsoption121.Fail_Code__c = 'abcdef';
        partsoption121.Account_Code__c = '';
        partsoption121.Part_Description__c = 'test-PD';
        partsoption121.CSS_Claims__c = claimsList[0].id;
        partsoption121.css_estimate__c = true;
        partsoption121.selected_part__c = true;
        partsoption121.PartOC__c = 'OC';
        insert partsoption121;
        list<CSS_SRT__C> lstsrt = new list<CSS_SRT__C>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.Type__c='Diagnosis';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 1;
        srt.CSS_Claims__c =claimsList[0].id ;
        srt.type__c = 'Diagnosis';
        srt.srt_category__c = '';//'Campaign';//'AdditionalRep';
        srt.SRT_Type__c='Campaign';
        srt.FailCode__c='abcdef';
        //srt.Additional_SRT_Calculated__c=2.3;
        lstsrt.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.Type__c = 'Repair';
        srt1.isPerformed__c=true;
        srt1.srt_category__c = '';
        srt1.Assignment__c = 'Primary';
        srt1.CSS_Claims__c =claimsList[0].id ;
        srt1.Extended_Hours__c=2.0;
        srt1.FailCode__c='abcdef';
        lstsrt.add(srt1);
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = true;
        srt2.Extended_Hours__c =2.0;
        srt2.CSS_Claims__c =claimsList[0].id ;
        srt2.FailCode__c='abcdef';
        //srt2.type__c = 'Diagnosis';
        srt2.srt_category__c = 'AdditionalRep';//'Campaign';//'AdditionalRep';
        srt2.SRT_Type__c='Campaign';
        lstsrt.add(srt2);
        CSS_SRT__c srt3 = new CSS_SRT__c();
        srt3.SRT_AccessiblityCheck__c=True;
        srt3.Access_Code_A__c = 65;
        srt3.name = 'TestClassName';
        //srt3.type__c = '';
        srt3.Assignment__c = 'PRIMARY';
        srt3.srt_time__c = 1;
        srt3.FailCode__c='abcdef';
        srt3.SRT_ID__c = '00-901-10';
        srt3.isPerformed__c = true;
        srt3.Extended_Hours__c =2.0;
        srt3.CSS_Claims__c =claimsList[0].id ;
        srt3.type__c = 'Diagnosis';
        srt3.srt_category__c = 'AdditionalRep';//'Campaign';//'AdditionalRep';
        srt3.SRT_Type__c='99Time';
        lstsrt.add(srt3);
        CSS_SRT__c srt4 = new CSS_SRT__c();
        srt4.SRT_AccessiblityCheck__c=True;
        srt4.Access_Code_A__c = 65;
        srt4.name = 'TestClassName';
        srt4.type__c = 'Campaign';
        srt4.FailCode__c='abcdef';
        srt4.Assignment__c = 'PRIMARY';
        srt4.srt_time__c = 1;
        srt4.SRT_ID__c = '00-901-10';
        srt4.isPerformed__c = true;
        srt4.Extended_Hours__c =2.0;
        srt4.CSS_Claims__c =claimsList[0].id ;
        //srt4.type__c = 'Diagnosis';
        srt4.srt_category__c = 'Campaign';//'Campaign';//'AdditionalRep';
        //srt4.SRT_Type__c='Campaign';
        lstsrt.add(srt4);
        CSS_SRT__c srt5 = new CSS_SRT__c();
        srt5.SRT_AccessiblityCheck__c=True;
        srt5.Access_Code_A__c = 65;
        srt5.name = 'TestClassName';
        srt5.type__c = 'Field Action';
        srt5.Assignment__c = 'PRIMARY';
        srt5.srt_time__c = 1;
        srt5.FailCode__c='abcdef';
        srt5.SRT_ID__c = '00-901-10';
        srt5.isPerformed__c = true;
        srt5.Extended_Hours__c =2.0;
        srt5.CSS_Claims__c =claimsList[0].id ;
        //srt5.type__c = 'Diagnosis';
        srt5.srt_category__c = 'TRP';//'Campaign';//'AdditionalRep';
        srt5.SRT_Type__c='TRP';
        lstsrt.add(srt5);
        CSS_SRT__c srt6 = new CSS_SRT__c();
        srt6.SRT_AccessiblityCheck__c=True;
        srt6.Access_Code_A__c = 65;
        srt6.name = 'TestClassName';
        srt6.type__c = 'Field Action';
        srt6.Assignment__c = 'PRIMARY';
        srt6.srt_time__c = 1;
        srt6.SRT_ID__c = '00-901-10';
        srt6.FailCode__c='abcdef';
        srt6.isPerformed__c = true;
        srt6.Extended_Hours__c =2.0;
        srt6.CSS_Claims__c =claimsList[0].id ;
        //srt6.type__c = 'Diagnosis';
        srt6.srt_category__c = 'ATC';//'Campaign';//'AdditionalRep';
        srt6.SRT_Type__c='ATC';
        lstsrt.add(srt6);
        CSS_SRT__c srt7 = new CSS_SRT__c();
        srt7.SRT_AccessiblityCheck__c=True;
        srt7.Access_Code_A__c = 65;
        srt7.name = 'TestClassName';
        srt7.type__c = '99Time';
        srt7.FailCode__c='abcdef';
        srt7.Assignment__c = 'PRIMARY';
        srt7.srt_time__c = 1.2;
        srt7.SRT_ID__c = '00-901-10';
        srt7.isPerformed__c = true;
        srt7.Extended_Hours__c =2.0;
        srt7.CSS_Claims__c =claimsList[0].id ;
        //srt7.type__c = 'Diagnosis';
        srt7.srt_category__c = 'ATC';//'Campaign';//'AdditionalRep';
        srt7.SRT_Type__c='ATC';
        lstsrt.add(srt7);
        
        
        insert lstsrt;
        List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = false;
        psnRec.Primary__c=true;
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Warranty_Start_Date__c = date.today();
        psnRec.Unit_Type__c = null;
        psnRec.Application__c = 'test';
        psnrec.Make__c='test';
        psnRec.Model__c = 'test';
        psnRec.Mileage_Measure__c = null;
        psnRec.PACCAR_Flag__c='N';
        psnRec.Make__c =null;
        psnlist.add(psnRec);
        //    insert psnRec;
        CSS_PSN__c psnRec1 = new CSS_PSN__c();
        psnRec1.Name='Test';
        psnRec1.psn__c='79464646';
        psnRec1.CSS_Claims__c=claimsObj.id;
        psnRec1.Before_In_Service__c = false;
        psnRec1.Primary__c=true;
        psnRec1.Calibration_Before__c = 'test';
        psnRec1.Calibration_After__c = 'test';
        psnRec1.Justification__c = '----Select One----';
        psnRec1.Warranty_Start_Date__c = null;
        psnRec1.Unit_Type__c = '';
        psnRec1.Failure_Date__c=system.today()+6;
        psnRec1.License_Plate_State__c='AK - Alaska';
        psnlist.add(psnRec1);
        insert psnlist;
        List<CSS_JobEventTemporary__c> claimListOld = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c=claimsObj1.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        claimListOld.add(jobevent);
        
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c=null;
        ie1.Response_Body__c='test';
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>();
        lstClaimsIntDetails.add(ie1);
        lstClaimsIntDetails.add(ie2);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        
        claims6.filterApplication='test';
        claims6.filterMake='test';
        claims6.filterModel='test';
        claims6.existingPSN='123456767';
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        string repSPdataClaims;
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        repSPdataClaims=CSS_FN_SIEBEL.getServiceProviderDataClaims('SPCode', 'ServiceModelName', 'FailureDateString', claimsObj1.Id);
        
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        claims6.saveClaim(claimsObj.id, 'Draft');
        claims6.saveClaim(null, 'Draft');
        
        
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod10()
    {	
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.Status__c = 'Submitted';
        claimsObj.Account__c = acc.id;
        claimsObj.PACCAR_Auth_Required__c = true;
        claimsObj.CSS_Job__c = jo.id ;
        claimsObj.Css_paccar_approve_reject_flag__c = 'Not Applicable';
        claimsObj.Pending_Authorization__c ='Not Authorized';
        claimsObj.State__c = 'Canada';
        claimsObj.CG_Get_Engine_data_flag__c=true;
        claimsList.add(claimsObj );
        
        insert claimsList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        claims6.nvClaimsPSN();
        claims6.nvClaimsFC();
        claims6.nvClaimsCC();
        claims6.nvClaimsPOC();
        claims6.nvClaimsSRTs();
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod10_1()
    {	
        Test.startTest();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Service_Date__c = date.today();
        claimsObj1.Status__c = 'Draft';
        claimsObj1.ODM_Status__c = 'WARN';
        claimsObj1.Warranty_Authorization_Flag__c='testing';
        claimsObj1.Pending_Authorization__c ='Authorization Required';
        claimsList.add(claimsObj1 );
        
        insert claimsList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        claims6.nvClaimsPSN();
        claims6.nvClaimsFC();
        claims6.nvClaimsCC();
        claims6.nvClaimsPOC();
        claims6.nvClaimsSRTs();
        //claims6.nvClaimsWC();
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod11()
    {	
        Test.startTest();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.ODM_Status__c = 'WARN';
        claimsObj.Status__c='draft';
        claimsObj.PACCAR_Flag__c = true;
        claimsObj.Customer_Name__c ='Test';
        claimsObj.Shop_Work_Order__c ='1234';
        
        
        
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_PSN__c> lpsn=new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today() + 8;
        psnRec.Application__c = 'AUTOMOTIVE';
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Service_Model__c = 'EX123';
        psnRec.Unit_Type__c ='Test';
        psnRec.Make__c ='DAEWOO';
        psnRec.Model__c ='7548';
        psnRec.Mileage_Measure__c ='Miles';
        insert psnRec;
        lpsn.add(psnRec);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims7 = new CG_CL_ClaimsIntake();
        claims7.isPaccarAutoClaim=true;
        claims7.nvClaimsPSN();
        claims7.nvClaimsFC();
        claims7.nvClaimsWC();
        claims7.nvClaimsVH();
        claims7.nvClaimsCC();
        claims7.nvClaimsPOC();
        claims7.nvClaimsSRTs();
        claims7.nvClaimsJobNotes();
        claims7.nvClaimsVS();
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod111()
    {	
        Test.startTest();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.ODM_Status__c = 'WARN';
        claimsObj.Status__c='draft';
        claimsObj.PACCAR_Flag__c = true;
        claimsObj.Customer_Name__c ='Test';
        claimsObj.Shop_Work_Order__c ='1234';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_PSN__c> lpsn=new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today() + 8;
        psnRec.Before_In_Service__c=true;
        psnRec.Application__c = 'AUTOMOTIVE';
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Service_Model__c = 'EX123';
        psnRec.Unit_Type__c ='Test';
        psnRec.Make__c ='DAEWOO';
        psnRec.Model__c ='7548';
        psnRec.Mileage_Measure__c ='Miles';
        insert psnRec;
        lpsn.add(psnRec);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims7 = new CG_CL_ClaimsIntake();
        //claims7.isPaccarAutoClaim=true;
        claims7.filterApplication='AUTOMOTIVE';
        claims7.filterMake='DAEWOO';
        claims7.filterModel='7548';
        claims7.nvClaimsPSN();
        claims7.nvClaimsFC();
        claims7.nvClaimsWC();
        claims7.nvClaimsVH();
        claims7.nvClaimsCC();
        claims7.nvClaimsPOC();
        claims7.nvClaimsSRTs();
        claims7.nvClaimsJobNotes();
        claims7.nvClaimsVS();
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod119()
    {	
        Test.startTest();
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Account__c = acc.id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.ODM_Status__c = 'WARN';
        claimsObj.Status__c='draft';
        claimsObj.PACCAR_Flag__c = true;
        claimsObj.Customer_Name__c ='Test';
        claimsObj.Shop_Work_Order__c ='1234';
        claimsObj.Location_Code__c ='03520-04892';
        claimsObj.SP_PACCAR__c ='N';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_PSN__c> lpsn=new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today() + 8;
        psnRec.Before_In_Service__c=true;
        psnRec.Application__c = 'AUTOMOTIVE';
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Service_Model__c = 'EX123';
        psnRec.Unit_Type__c ='Test';
        psnRec.Make__c ='DAEWOO';
        psnRec.Model__c ='7548';
        psnRec.Mileage_Measure__c ='Miles';
        insert psnRec;
        lpsn.add(psnRec);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims7 = new CG_CL_ClaimsIntake();
        //claims7.isPaccarAutoClaim=true;
        claims7.filterApplication='AUTOMOTIVE';
        claims7.filterMake='DAEWOO';
        claims7.filterModel='7548';
        claims7.nvClaimsPSN();
        claims7.nvClaimsFC();
        claims7.nvClaimsWC();
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod118()
    {	
        Test.startTest();
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Account__c=acc.id;
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Account__c = acc.id;
        claimsObj.CSS_Job__c =JO.Id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.ODM_Status__c = 'WARN';
        claimsObj.Status__c='draft';
        claimsObj.PACCAR_Flag__c = true;
        claimsObj.Customer_Name__c ='Test';
        claimsObj.Shop_Work_Order__c ='1234';
        claimsObj.Location_Code__c ='03520-04892';
        claimsObj.SP_PACCAR__c ='N';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_PSN__c> lpsn=new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today() + 8;
        psnRec.Before_In_Service__c=true;
        psnRec.Application__c = 'AUTOMOTIVE';
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Service_Model__c = 'EX123';
        psnRec.Unit_Type__c ='Test';
        psnRec.Make__c ='DAEWOO';
        psnRec.Model__c ='7548';
        psnRec.Mileage_Measure__c ='Miles';
        insert psnRec;
        lpsn.add(psnRec);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims7 = new CG_CL_ClaimsIntake();
        //claims7.isPaccarAutoClaim=true;
        claims7.filterApplication='AUTOMOTIVE';
        claims7.filterMake='DAEWOO';
        claims7.filterModel='7548';
        claims7.nvClaimsWC();
        claims7.setPaccarPW();
        List<SelectOption> opt = new List<SelectOption>();
        opt = claims7.getPreventiveMaintenance();
        Test.stopTest();
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod118_1()
    {	
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Account__c=acc.id;
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO;
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Account__c = acc.id;
        claimsObj.CSS_Job__c =JO.Id;
        claimsObj.Service_Date__c = date.today();
        claimsObj.ODM_Status__c = 'WARN';
        claimsObj.Status__c='draft';
        claimsObj.PACCAR_Flag__c = true;
        claimsObj.Customer_Name__c ='Test';
        claimsObj.Shop_Work_Order__c ='1234';
        claimsObj.Location_Code__c ='03520-04892';
        claimsObj.SP_PACCAR__c ='N';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_PSN__c> lpsn=new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today() + 8;
        psnRec.Before_In_Service__c=true;
        psnRec.Application__c = 'AUTOMOTIVE';
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Service_Model__c = 'EX123';
        psnRec.Unit_Type__c ='Test';
        psnRec.Make__c ='DAEWOO';
        psnRec.Model__c ='7548';
        psnRec.Mileage_Measure__c ='Miles';
        insert psnRec;
        lpsn.add(psnRec);
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claimsList[0].Id;
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Fail_Code_Editable__c='THAC';
        solcomp.Pay_Code__c='A';
        insert solcomp;
        
        List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId(); 
        id recodidTTML = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        css_parts_options__c patop = new css_parts_options__c();
        patop.Parts_Type__c = 'Custom';
        patop.RecordTypeId=recodid;
        patop.Service_Job__c=jo.id;
        patop.ExpenseTotal__c=23;
        patop.Part_Assignment__c = 'Primary';
        patop.Covered__c=23;
        patop.Quantity__c=23;
        patop.CSS_Claims__c=claimsList[0].Id;
        patop.Fail_Code__c='THAC';
        partsList.add(patop);
        css_parts_options__c patop1 = new css_parts_options__c();
        patop1.Parts_Type__c = 'Custom';
        patop1.RecordTypeId=partsrecodid;
        patop1.CSS_Claims__c=claimsList[0].Id;
        patop1.Part_Assignment__c = 'Primary';
        patop1.Fail_Code__c='Select One';
        patop1.Account_Code__c='Select One';
        patop1.ReturnToFactory__c='';
        patop1.selected_part__c = true;
        patop1.Fail_Code__c='THAC';
        partsList.add(patop1);
        css_parts_options__c patop2 = new css_parts_options__c();
        patop2.Parts_Type__c = 'Custom';
        patop2.RecordTypeId=recodidTTML;
        patop2.CSS_Claims__c=claimsList[0].Id;
        patop2.type__c='Non Commercial-Travel';
        patop2.Fail_Code__c='THAC';
        partsList.add(patop2);
        
        css_parts_options__c patop3 = new css_parts_options__c();
        patop3.Parts_Type__c = 'Custom';
        patop3.RecordTypeId=recodidTTML;
        patop3.CSS_Claims__c=claimsList[0].Id;
        patop3.type__c='Commercial-Travel';
        patop3.Fail_Code__c='THAC';
        partsList.add(patop3);
        
        css_parts_options__c patop4 = new css_parts_options__c();
        patop4.Parts_Type__c = 'Custom';
        patop4.RecordTypeId=recodidTTML;
        patop4.CSS_Claims__c=claimsList[0].Id;
        patop4.type__c='Towing';
        patop4.Fail_Code__c='THAC';
        partsList.add(patop4);
        
        css_parts_options__c patop5 = new css_parts_options__c();
        patop5.Parts_Type__c = 'Custom';
        patop5.RecordTypeId=recodidTTML;
        patop5.CSS_Claims__c=claimsList[0].Id;
        patop5.type__c='Meals';
        patop5.Fail_Code__c='THAC';
        partsList.add(patop5);
        
        insert partsList;
        
        CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
        Blob key3 = Blob.valueOf('12345678901234567890123456789012');
        string algo3 = 'AES256';
        inte3.Name = 'CSS_SPDataLookup';
        inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
        inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
        inte3.ApplicationName__c = 'CSS_SPDataLookup';
        inte3.End_Point__c = 'https://services-test.cummins.com/csswarranty/serviceproviderdata';
        inte3.IsActive__c = true;
        insert inte3;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims7 = new CG_CL_ClaimsIntake();
        //claims7.isPaccarAutoClaim=true;
        claims7.filterApplication='AUTOMOTIVE';
        claims7.filterMake='DAEWOO';
        claims7.filterModel='7548';
        claims7.nvClaimsWC();
        claims7.setPaccarPW();
        List<SelectOption> opt = new List<SelectOption>();
        opt = claims7.getPreventiveMaintenance();
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod1122()
    {	
        Test.startTest();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.ODM_Status__c = 'WARN';
        claimsObj.Status__c='draft';
        claimsObj.PACCAR_Flag__c = true;
        claimsObj.PACCAR_Auth_Required__c = true;
        claimsObj.Parts_Warranty_Claim_Only__c = false;
        claimsObj.CG_Get_Engine_data_flag__c = false;
        claimsObj.Css_paccar_approve_reject_flag__c = 'Rejected';
        claimsList.add(claimsObj );
        insert claimsList;
        
        list<CSS_PSN__c> lpsn=new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today() + 8;
        psnRec.Application__c = 'filterApplication';
        psnRec.Calibration_Before__c = '1';
        psnRec.Calibration_After__c = '2';
        psnRec.Justification__c = '----Select One----';
        psnRec.Service_Model__c = 'EX123';
        insert psnRec;
        lpsn.add(psnRec);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims7 = new CG_CL_ClaimsIntake();
        claims7.isPaccarAutoClaim=true;
        claims7.nvClaimsPSN();
        claims7.nvClaimsFC();
        claims7.nvClaimsWC();
        claims7.nvClaimsVH();
        claims7.nvClaimsCC();
        claims7.nvClaimsPOC();
        claims7.nvClaimsSRTs();
        claims7.nvClaimsJobNotes();
        claims7.nvClaimsVS();
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod11221()
    {	
        Test.startTest();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Service_Date__c = date.today();
        claimsObj.ODM_Status__c = 'WARN';
        claimsObj.Status__c='draft';
        claimsObj.PACCAR_Flag__c = true;
        claimsObj.PACCAR_Auth_Required__c = true;
        claimsObj.Parts_Warranty_Claim_Only__c = false;
        claimsObj.CG_Get_Engine_data_flag__c = false;
        claimsObj.Css_paccar_approve_reject_flag__c = 'Rejected';
        claimsList.add(claimsObj );
        insert claimsList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsIntake claims7 = new CG_CL_ClaimsIntake();
        // claims7.isPaccarAutoClaim=true;
        claims7.nvClaimsPSN();
        claims7.nvClaimsFC();
        claims7.nvClaimsWC();
        claims7.nvClaimsVH();
        claims7.nvClaimsCC();
        claims7.nvClaimsPOC();
        claims7.nvClaimsSRTs();
        claims7.nvClaimsJobNotes();
        claims7.nvClaimsVS();
        Test.stopTest();
    }
    static testmethod void CG_CL_ClaimsIntake_Testmethod82()
    {	
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        // acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        //Cache.Session.put('ManualClaimsSelectedLocation','ManualClaimsSelectedLocation');
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        // String ManualClaimsLoc = 'ManualClaimsSelectedLocation';
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        //UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, //UserRoleId = empRole.id ,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '02650-97895');
        insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650-97895');
        insert userLocation;
        
        //   system.runAs(u){
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(u)
        { 
            CSS_accountLanguage__c accountlang = css_utility.getLanguage(u.LanguageLocaleKey);
            
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Customer_Name__c = 'CumminsTnD';
            JO.ESN__c = '79464646';
            JO.Mileage_Measure__c='19';
            JO.Qsol_Engine_Family_Code__c='IN';
            insert JO;
            
            CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
            accLan.CSS_QsolLanguage__c = 'en';
            accLan.Name = 'en_US';
            insert accLan;
            
            CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
            Blob key = Blob.valueOf('12345678901234567890123456789012');
            string algo = 'AES256';
            inte.Name = 'CSS_SPDataLookup'; 
            inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            inte.ApplicationName__c = 'CSS_SPDataLookup';
            inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte.IsActive__c = true;
            insert inte;
            system.debug('***inte***'+inte);
            CSS_Integration_Details__c inte1 = new CSS_Integration_Details__c();
            Blob key1 = Blob.valueOf('12345678901234567890123456789012');
            string algo1 = 'AES256';
            inte1.Name = 'SiebelClaimHistory';
            inte1.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
            inte1.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
            inte1.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('1234')));
            inte1.ApplicationName__c = 'SiebelClaimHistory';
            inte1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte1.IsActive__c = true;
            insert inte1;
            system.debug('***inte1***'+inte1);
            CSS_Integration_Details__c inte2 = new CSS_Integration_Details__c();
            Blob key2 = Blob.valueOf('12345678901234567890123456789012');
            string algo2 = 'AES256';
            inte2.Name = 'CG_ODMHeaderValidation';
            inte2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
            inte2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
            inte2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('1234')));
            inte2.ApplicationName__c = 'CG_ODMHeaderValidation';
            inte2.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte2.IsActive__c = true;
            insert inte2;
            system.debug('***inte2***'+inte2);
            CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
            Blob key3 = Blob.valueOf('12345678901234567890123456789012');
            string algo3 = 'AES256';
            inte3.Name = 'GetCampaign';
            inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
            inte3.ApplicationName__c = 'GetCampaign';
            inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte3.IsActive__c = true;
            insert inte3;
            system.debug('***inte3***'+inte3);
            CSS_getConnnectionDetails getConnectionDetailsRec = new CSS_getConnnectionDetails();
            CSS_Integration_Details__c endPointURL =CSS_getConnnectionDetails.getConnection(inte.Name);
            system.debug('*****endPointURL***'+endPointURL);
            string endPointURLonly = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
            system.debug('*****endPointURLonly***'+endPointURLonly);
            CSS_Integration_Details__c conDetails12 = CSS_Integration_Details__c.getValues('CSS_SPDataLookup');
            CSS_Integration_Details__c conDetails21 = CSS_Integration_Details__c.getValues('GetCampaign');
            CSS_Integration_Details__c conDetails22 = CSS_Integration_Details__c.getValues('SiebelClaimHistory');
            CSS_Integration_Details__c conDetails23 = CSS_Integration_Details__c.getValues('CG_ODMHeaderValidation');
            system.assert(conDetails12!=null);
            system.debug('conDetails12>>'+conDetails12);
            
            
            // Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
            
            
            List<CSS_Accreditation__c> lstaccr = new List<CSS_Accreditation__c>();       
            CSS_Accreditation__c accr = new CSS_Accreditation__c();
            accr.Service_Model_Name__c = 'ISBE CM800';
            accr.Account__c = acc.id;
            accr.OEM_Code__c = '232';
            accr.EndDate__c = date.today() +7 ;
            accr.StartDate__c = date.today() + 4;
            lstaccr.add(accr);
            insert lstaccr;
            
            List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
            CSS_Claims__c claimsObj = new CSS_Claims__c();
            //claimsObj.name='test';
            claimsObj.Service_Date__c = date.today();
            claimsObj.Country__c = 'India';
            claimsObj.State__c = 'PB';
            claimsObj.Email_Address__c='abc@abc.com';
            claimsObj.Dealer_Service_Job__c=JO.id;
            claimsObj.CSS_Job__c = JO.id;
            claimsObj.Location_Code__c = '02650-97895';
            claimsObj.Pending_Authorization__c='--None--';
            claimsObj.SP_WarrantyCertificationEndDate__c='2017-07-25 00:00:00';
            claimsList.add(claimsObj );
            insert claimsList;
            
            list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
            //     solCompObj.Service_Job__c = jo.Id;
            solCompObj.Selected_Component__c = true;
            solCompObj.CSS_Claims__c = claimsObj.id;
            solCompObj.Type__c = 'OTH';
            solCompObj.Failure_Mode__C = 'Test';
            solCompObj.name = 'Test';   
            solCompObj.AccountCode__c ='testing';
            solCompObj.AccountCodeType__c  = 'NEW-New Engine Warranty';
            solCompObj.AccountCode__c = '67';
            solCompObj.AccountCodeEdit__c = 'NEW-New Engine Warranty 67';
            lstsolcomp.add(solCompObj);
            insert lstsolcomp;
            
            List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
            CSS_PSN__c psnRec = new CSS_PSN__c();
            psnRec.Name='Test';
            psnRec.psn__c='79464646';
            psnRec.CSS_Claims__c=claimsObj.id;
            psnRec.Before_In_Service__c = false;
            psnRec.Primary__c=true;
            psnRec.Calibration_Before__c = '';
            psnRec.Calibration_After__c = '';
            psnRec.Justification__c = 'CFSE Direction';
            psnRec.Warranty_Start_Date__c = date.today();
            psnRec.Unit_Type__c = 'Test';
            psnRec.Application__c = 'Test';
            psnRec.Model__c = 'Test';
            psnRec.Mileage_Measure__c = 'Test';
            psnRec.Service_Model__c='Automotive';
            psnRec.Failure_Date__c=system.today();
            psnRec.Make__c = 'Test';
            psnlist.add(psnRec);
            //    insert psnRec;
            CSS_PSN__c psnRec1 = new CSS_PSN__c();
            psnRec1.Name='Test';
            psnRec1.psn__c='79464646';
            psnRec1.CSS_Claims__c=claimsObj.id;
            psnRec1.Before_In_Service__c = false;
            psnRec1.Primary__c=true;
            psnRec1.Calibration_Before__c = '';
            psnRec1.Calibration_After__c = '';
            psnRec1.Justification__c = 'CFSE Direction';
            psnRec1.Warranty_Start_Date__c = date.today();
            psnRec1.Unit_Type__c = '';
            psnRec1.Service_Model__c='Automotive';
            psnRec1.Failure_Date__c=system.today();
            psnlist.add(psnRec1);
            insert psnlist;
            //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(psnRec.PSN__c, psnRec.Service_Model__c,psnRec.Failure_Date__c, accountlang.CSS_QsolLanguage__c,psnRec.Id);
            
            ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
            
            //    Test.setMock(HttpCalloutMock.class, new CG_OP_CampaignsresJSONMOck_Test()); 
            
            
            CG_CL_ClaimsIntake claims5 = new CG_CL_ClaimsIntake();
            
            claims5.userObj=u;
            claims5.claimsRec=claimsList[0];
            claims5.psnRec=psnRec1;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_GetServiceProviderResponseMock_Test());
            claims5.callgetCampaigns();
            claims5.setPACCAR_Flag();
            claims5.paccarPopUP_OK();
            claims5.multipsnchecbox();
            Test.stopTest();
        } 
    }
    
    static testmethod void CG_CL_ClaimsIntake_Testmethod88()
    {	
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        // acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        //Cache.Session.put('ManualClaimsSelectedLocation','ManualClaimsSelectedLocation');
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        // String ManualClaimsLoc = 'ManualClaimsSelectedLocation';
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        //UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, //UserRoleId = empRole.id ,
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '02650-97895');
        insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='02650-97895');
        insert userLocation;
        
        //   system.runAs(u){
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(u)
        { 
            CSS_accountLanguage__c accountlang = css_utility.getLanguage(u.LanguageLocaleKey);
            
            CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
            JO.Customer_Name__c = 'CumminsTnD';
            JO.ESN__c = '79464646';
            JO.Mileage_Measure__c='19';
            JO.Qsol_Engine_Family_Code__c='IN';
            insert JO;
            
            CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
            accLan.CSS_QsolLanguage__c = 'en';
            accLan.Name = 'en_US';
            insert accLan;
            
            CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
            Blob key = Blob.valueOf('12345678901234567890123456789012');
            string algo = 'AES256';
            inte.Name = 'CSS_SPDataLookup'; 
            inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            inte.ApplicationName__c = 'CSS_SPDataLookup';
            inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte.IsActive__c = true;
            insert inte;
            system.debug('***inte***'+inte);
            CSS_Integration_Details__c inte1 = new CSS_Integration_Details__c();
            Blob key1 = Blob.valueOf('12345678901234567890123456789012');
            string algo1 = 'AES256';
            inte1.Name = 'SiebelClaimHistory';
            inte1.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
            inte1.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('test')));
            inte1.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key1, Blob.valueOf('1234')));
            inte1.ApplicationName__c = 'SiebelClaimHistory';
            inte1.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte1.IsActive__c = true;
            insert inte1;
            system.debug('***inte1***'+inte1);
            CSS_Integration_Details__c inte2 = new CSS_Integration_Details__c();
            Blob key2 = Blob.valueOf('12345678901234567890123456789012');
            string algo2 = 'AES256';
            inte2.Name = 'CG_ODMHeaderValidation';
            inte2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
            inte2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('test')));
            inte2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key2, Blob.valueOf('1234')));
            inte2.ApplicationName__c = 'CG_ODMHeaderValidation';
            inte2.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte2.IsActive__c = true;
            insert inte2;
            system.debug('***inte2***'+inte2);
            CSS_Integration_Details__c inte3 = new CSS_Integration_Details__c();
            Blob key3 = Blob.valueOf('12345678901234567890123456789012');
            string algo3 = 'AES256';
            inte3.Name = 'GetCampaign';
            inte3.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('test')));
            inte3.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key3, Blob.valueOf('1234')));
            inte3.ApplicationName__c = 'GetCampaign';
            inte3.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
            inte3.IsActive__c = true;
            insert inte3;
            system.debug('***inte3***'+inte3);
            CSS_getConnnectionDetails getConnectionDetailsRec = new CSS_getConnnectionDetails();
            CSS_Integration_Details__c endPointURL =CSS_getConnnectionDetails.getConnection(inte.Name);
            system.debug('*****endPointURL***'+endPointURL);
            string endPointURLonly = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
            system.debug('*****endPointURLonly***'+endPointURLonly);
            CSS_Integration_Details__c conDetails12 = CSS_Integration_Details__c.getValues('CSS_SPDataLookup');
            CSS_Integration_Details__c conDetails21 = CSS_Integration_Details__c.getValues('GetCampaign');
            CSS_Integration_Details__c conDetails22 = CSS_Integration_Details__c.getValues('SiebelClaimHistory');
            CSS_Integration_Details__c conDetails23 = CSS_Integration_Details__c.getValues('CG_ODMHeaderValidation');
            system.assert(conDetails12!=null);
            system.debug('conDetails12>>'+conDetails12);
            
            
            // Test.setMock(HttpCalloutMock.class , new CG_getServiceProviderDataIntakemock_test());
            
            
            List<CSS_Accreditation__c> lstaccr = new List<CSS_Accreditation__c>();       
            CSS_Accreditation__c accr = new CSS_Accreditation__c();
            accr.Service_Model_Name__c = 'ISBE CM800';
            accr.Account__c = acc.id;
            accr.OEM_Code__c = '232';
            accr.EndDate__c = date.today() +7 ;
            accr.StartDate__c = date.today() + 4;
            lstaccr.add(accr);
            insert lstaccr;
            
            List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
            CSS_Claims__c claimsObj = new CSS_Claims__c();
            //claimsObj.name='test';
            claimsObj.Service_Date__c = date.today();
            claimsObj.Country__c = 'India';
            claimsObj.State__c = 'PB';
            claimsObj.Email_Address__c='abc@abc.com';
            //claimsObj.Dealer_Service_Job__c=JO.id;
            claimsObj.CSS_Job__c = JO.id;
            claimsObj.Location_Code__c = '02650-97895';
            claimsObj.Pending_Authorization__c='--None--';
            claimsObj.SP_WarrantyCertificationEndDate__c='2017-07-25 00:00:00';
            claimsList.add(claimsObj );
            insert claimsList;
            
            list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
            //     solCompObj.Service_Job__c = jo.Id;
            solCompObj.Selected_Component__c = true;
            solCompObj.CSS_Claims__c = claimsObj.id;
            solCompObj.Type__c = 'OTH';
            solCompObj.Failure_Mode__C = 'Test';
            solCompObj.name = 'Test';   
            solCompObj.AccountCode__c ='testing';
            solCompObj.AccountCodeType__c  = 'NEW-New Engine Warranty';
            solCompObj.AccountCode__c = '67';
            solCompObj.AccountCodeEdit__c = 'NEW-New Engine Warranty 67';
            lstsolcomp.add(solCompObj);
            insert lstsolcomp;
            
            List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
            CSS_PSN__c psnRec = new CSS_PSN__c();
            psnRec.Name='Test';
            psnRec.psn__c='79464646';
            psnRec.CSS_Claims__c=claimsObj.id;
            psnRec.Before_In_Service__c = false;
            psnRec.Primary__c=true;
            psnRec.Calibration_Before__c = '';
            psnRec.Calibration_After__c = '';
            psnRec.Justification__c = 'CFSE Direction';
            psnRec.Warranty_Start_Date__c = date.today();
            psnRec.Unit_Type__c = 'Test';
            psnRec.Application__c = 'Test';
            psnRec.Model__c = 'Test';
            psnRec.Mileage_Measure__c = 'Test';
            psnRec.Service_Model__c='Automotive';
            psnRec.Failure_Date__c=system.today();
            psnRec.Make__c = 'Test';
            psnlist.add(psnRec);
            //    insert psnRec;
            CSS_PSN__c psnRec1 = new CSS_PSN__c();
            psnRec1.Name='Test';
            psnRec1.psn__c='79464646';
            psnRec1.CSS_Claims__c=claimsObj.id;
            psnRec1.Before_In_Service__c = false;
            psnRec1.Primary__c=true;
            psnRec1.Calibration_Before__c = '';
            psnRec1.Calibration_After__c = '';
            psnRec1.Justification__c = 'CFSE Direction';
            psnRec1.Warranty_Start_Date__c = date.today();
            psnRec1.Unit_Type__c = '';
            psnRec1.Service_Model__c='Automotive';
            psnRec1.Failure_Date__c=system.today();
            psnlist.add(psnRec1);
            insert psnlist;
            //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(psnRec.PSN__c, psnRec.Service_Model__c,psnRec.Failure_Date__c, accountlang.CSS_QsolLanguage__c,psnRec.Id);
            
            ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
            
            //    Test.setMock(HttpCalloutMock.class, new CG_OP_CampaignsresJSONMOck_Test()); 
            
            
            CG_CL_ClaimsIntake claims5 = new CG_CL_ClaimsIntake();
            
            claims5.userObj=u;
            claims5.claimsRec=claimsList[0];
            claims5.psnRec=psnRec1;
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CG_getSPDataClaimsIntakemock_test());
            claims5.callgetCampaigns();
            claims5.setPACCAR_Flag();
            claims5.paccarPopUP_OK();
            claims5.multipsnchecbox();
            Test.stopTest();
        } 
    }
    
    static testmethod void CG_CL_ClaimsIntake_TestmethodNew()
    {	
        
        //Account
        List<Account>aclist = new List<Account>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        aclist.add(acc);
        insert aclist;
        
        string location1 = [select id,location__c from account where id=:aclist[0].id].location__c;
        
        //Create Job
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Service_Model__c = 'Test';
        JO.Failure_Date__c = date.today() +6 ;
        JO.Account__c = aclist[0].id;
        JO.Qsol_Engine_Family_Code__c='IN';
        insert JO;
        
        //Create Claim
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Location_Code__c = '02466-19134';
        claimsObj.Service_Date__c = date.today();
        claimsObj.CSS_Job__c=JO.id;
        //claimsObj.Dealer_Service_Job__c=JO.id;
        claimsObj.Css_paccar_approve_reject_flag__c='Not Applicable';
        claimsObj.Customer_Name__c='prashanthi';
        claimsObj.Shop_Work_Order__c='12345';
        claimsObj.Actual_Technician_Time__c=null;
        claimsObj.Status__c = 'Submitted';
        claimsObj.SP_PACCAR__c='N';
        claimsObj.Account__c=aclist[0].id;
        claimsObj.Territory_Class__c='100';
        claimsObj.CSS_Channel_Code__c='101';
        claimsObj.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj );
        
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Location_Code__c = '02466-19134';
        claimsObj1.Service_Date__c = date.today();
        claimsObj1.Account__c=aclist[0].id;
        claimsObj1.Territory_Class__c='100';
        claimsObj1.CSS_Channel_Code__c='110';
        claimsObj1.Customer_Name__c='';
        claimsObj1.Shop_Work_Order__c='12345';
        claimsObj1.Actual_Technician_Time__c=null;
        claimsObj1.Status__c = 'Submitted';
        ClaimsObj1.PACCAR_Flag__c=true;
        claimsObj1.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj1 );
        
        CSS_Claims__c claimsObj12 = new CSS_Claims__c();
        claimsObj12.Location_Code__c ='02466-19134';
        claimsObj12.Account__c=aclist[0].id;
        claimsObj12.Service_Date__c = date.today();
        claimsObj12.Territory_Class__c='100';
        claimsObj12.CSS_Channel_Code__c='110';
        claimsObj12.Customer_Name__c='';
        claimsObj12.Shop_Work_Order__c='12345';
        claimsObj12.Actual_Technician_Time__c=null;
        claimsObj12.Status__c = 'Draft';
        ClaimsObj12.PACCAR_Flag__c=true;
        claimsObj12.Pending_Authorization__c ='Not Authorized';
        claimsList.add(claimsObj12 );
        insert claimsList;
        
        //Create psn
        List<CSS_PSN__c> psnlist = new list<CSS_PSN__c>();
        CSS_PSN__c psnRec = new CSS_PSN__c();
        psnRec.Name='Test';
        psnRec.psn__c='79464646';
        psnRec.CSS_Claims__c=claimsObj.id;
        psnRec.Before_In_Service__c = false;
        psnRec.Primary__c=true;
        psnRec.Calibration_Before__c = '';
        psnRec.Calibration_After__c = '';
        psnRec.Justification__c = 'CFSE Direction';
        psnRec.Warranty_Start_Date__c = date.today();
        psnRec.Unit_Type__c = null;
        psnRec.Application__c = 'test';
        psnrec.Make__c='test';
        psnRec.Model__c = 'test';
        psnRec.Mileage_Measure__c = null;
        psnRec.PACCAR_Flag__c='N';
        psnRec.Make__c =null;
        psnlist.add(psnRec);
        
        CSS_PSN__c psnRec1 = new CSS_PSN__c();
        psnRec1.Name='Test';
        psnRec1.psn__c='79464646';
        psnRec1.CSS_Claims__c=claimsObj.id;
        psnRec1.Before_In_Service__c = false;
        psnRec1.Primary__c=true;
        psnRec1.Calibration_Before__c = 'test';
        psnRec1.Calibration_After__c = 'test';
        psnRec1.Justification__c = '----Select One----';
        psnRec1.Warranty_Start_Date__c = null;
        psnRec1.Unit_Type__c = '';
        psnRec1.Failure_Date__c=system.today()+6;
        psnRec1.License_Plate_State__c='AK - Alaska';
        psnlist.add(psnRec1);
        insert psnlist;
        
        
        //Create Sol
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        //Create Solution Comp
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CSS_Claims__c=claimsList[0].id;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Type__c='test';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBTAC';
        insert solcomp;
        
        
        //REcord types-parts
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        Id recTypeIdpart2 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        //Create pars
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.CSS_Claims__c=claimsList[0].id;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'EEBTAC';
        partsoption.Type__c='Meals'; 
        partsoption.Account_Code__c = '';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        selectedCustPartsList.add(partsoption);
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.CSS_Claims__c=claimsList[0].id;
        partsoption1.Item__c = 'Unlisted';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'EEBTAC';
        partsoption1.Account_Code__c = '';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.css_estimate__c = true;
        partsoption1.selected_part__c = true;
        partsoption1.PartOC__c = 'OC';
        selectedCustPartsList.add(partsoption1);
        
        
        CSS_Parts_Options__c partsoption2 = new CSS_Parts_Options__c();
        partsoption2.quantity__c = 100;
        partsoption2.RecordTypeId = recTypeIdpart1;
        partsoption2.CSS_Claims__c=claimsList[0].id;
        partsoption2.Item__c = 'Unlisted';
        partsoption2.Covered__c = 100;
        partsoption2.Amount__c = 122;
        partsoption2.Type__c='Non Commercial-Travel'; 
        partsoption2.Fail_Code__c = 'EEBTAC';
        partsoption2.Account_Code__c = '';
        partsoption2.Part_Description__c = 'test-PD';
        partsoption2.Service_Job__c = JO.id;
        partsoption2.css_estimate__c = true;
        partsoption2.selected_part__c = true;
        partsoption2.PartOC__c = 'OC';
        selectedCustPartsList.add(partsoption2);
        
        CSS_Parts_Options__c partsoption3 = new CSS_Parts_Options__c();
        partsoption3.quantity__c = 100;
        partsoption3.RecordTypeId = recTypeIdpart1;
        partsoption3.CSS_Claims__c=claimsList[0].id;
        partsoption3.Item__c = 'Unlisted';
        partsoption3.Covered__c = 100;
        partsoption3.Amount__c = 122;
        partsoption3.Type__c='Towing'; 
        partsoption3.Fail_Code__c = 'EEBTAC';
        partsoption3.Account_Code__c = '';
        partsoption3.Part_Description__c = 'test-PD';
        partsoption3.Service_Job__c = JO.id;
        partsoption3.css_estimate__c = true;
        partsoption3.selected_part__c = true;
        partsoption3.PartOC__c = 'OC';
        selectedCustPartsList.add(partsoption3);
        
        CSS_Parts_Options__c partsoption4 = new CSS_Parts_Options__c();
        partsoption4.quantity__c = 100;
        partsoption4.CSS_Claims__c=claimsList[0].id;
        partsoption4.Item__c = 'Select One';
        partsoption4.Covered__c = 100;
        partsoption4.RecordTypeId = recTypeIdpart1;
        partsoption4.Amount__c = 122;
        partsoption4.Fail_Code__c = 'EEBTAC';
        partsoption4.Type__c='Meals'; 
        partsoption4.Account_Code__c = '';
        partsoption4.Part_Description__c = 'test-PD';
        partsoption4.Service_Job__c = JO.id;
        selectedCustPartsList.add(partsoption4);
        
        CSS_Parts_Options__c partsoption5 = new CSS_Parts_Options__c();
        partsoption5.quantity__c = 100;
        partsoption5.CSS_Claims__c=claimsList[0].id;
        partsoption5.Item__c = 'Select One';
        partsoption5.Covered__c = 100;
        partsoption5.RecordTypeId = recTypeIdpart2;
        partsoption5.Amount__c = 122;
        partsoption5.Fail_Code__c = 'EEBTAC';
        partsoption5.Type__c='Meals'; 
        partsoption5.Account_Code__c = '';
        partsoption5.Part_Description__c = 'test-PD';
        partsoption5.Service_Job__c = JO.id;
        partsoption5.Parts_Type__c = 'Custom';
        selectedCustPartsList.add(partsoption5);
        
        CSS_Parts_Options__c partsoption6 = new CSS_Parts_Options__c();
        partsoption6.quantity__c = 100;
        partsoption6.CSS_Claims__c=claimsList[0].id;
        partsoption6.Item__c = 'Select One';
        partsoption6.Covered__c = 100;
        partsoption6.RecordTypeId = recTypeIdpart2;
        partsoption6.Amount__c = 122;
        partsoption6.Fail_Code__c = 'EE-BTAC';
        partsoption6.Type__c='Meals'; 
        partsoption6.Account_Code__c = '';
        partsoption6.Part_Description__c = 'test-PD';
        partsoption6.Service_Job__c = JO.id;
        partsoption6.Parts_Type__c = 'Custom';
        selectedCustPartsList.add(partsoption6);
        
        insert selectedCustPartsList;
        
        
        //Create SRT
        List<CSS_SRT__c> srtList = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Name = 'Wenchin Shetty';
        srt.Account_Code__c = null;
        srt.CSS_Claims__c=claimsObj.id;
        srt.FailCode__c = 'EE-BTAC';
        srtList.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Name = 'Wenchin Shetty';
        srt1.Type__c = 'Diagnosis';
        srt1.Account_Code__c = null;
        srt1.CSS_Claims__c=claimsObj.id;
        srt1.FailCode__c = 'EE-BTAC';
        srtList.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Name = 'Wenchin Shetty';
        srt2.Type__c = 'Repair';
        srt2.Account_Code__c = null;
        srt2.CSS_Claims__c=claimsObj.id;
        srt2.FailCode__c = 'EE-BTAC';
        srtList.add(srt2);
        insert srtList;
        
        
        //Create JET
        List<CSS_JobEventTemporary__c> claimListOld = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c=claimsObj1.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        claimListOld.add(jobevent);
        
        
        //Pass Integration Details
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c=null;
        ie1.Response_Body__c='test';
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        List<CSS_Integration_Error__c> lstClaimsIntDetails=new list<CSS_Integration_Error__c>();
        lstClaimsIntDetails.add(ie1);
        lstClaimsIntDetails.add(ie2);
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'CSS_SPDataLookup'; 
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'CSS_SPDataLookup';
        inte.End_Point__c = 'https://services-stg.cummins.com/csswarranty/serviceproviderdata';
        inte.IsActive__c = true;
        insert inte;
        
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        
        Test.startTest();
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        claims6.filterApplication='test';
        claims6.filterMake='test';
        claims6.filterModel='test';
        claims6.existingPSN='123456767';
        
        String temp=claimsObj1.Territory_Class__c +'-'+ claimsObj1.CSS_Channel_Code__c;
        claims6.paccarCustomSettingValues=CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
        string location = [select id,location__c from account where id=:acc.id].location__c;
        Cache.Session.put('ManualClaimsSelectedLocation',location);
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        String ManualClaimsLoc = (String)Cache.Session.get('ManualClaimsSelectedLocation');
        string repSPdataClaims;
        test.setMock(httpcalloutmock.class,new  CSS_GetServiceProviderResponseMock_Test());
        repSPdataClaims=CSS_FN_SIEBEL.getServiceProviderDataClaims('SPCode', 'ServiceModelName', 'FailureDateString', claimsObj1.Id);
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        claims6.saveClaim(claimsObj.id, 'Draft');
        claims6.saveClaim(null, 'Draft');
        claims6.saveClaim(claimsObj1.id, 'Submitted');
        Test.stopTest();
    }
    
    
    static testMethod void uncheckPopupsaveMethod(){
        Test.startTest();
       //Create Claim
        List<Account>aclist = new List<Account>();
        Account acc = new Account();
        acc.name='CENTRAL - WHITE BEAR LAKE';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Distributor Account';
        acc.CMI_Account_Status__c = 'Active';
        aclist.add(acc);
        insert aclist;
        CSS_Claims__c claimsObj1 = new CSS_Claims__c();
        claimsObj1.Location_Code__c = '02466-19134';
        claimsObj1.Account__c = aclist[0].id;
        claimsObj1.Service_Date__c = date.today();
        //claimsObj1.Account__c=aclist[0].id;
        claimsObj1.Territory_Class__c='100';
        claimsObj1.CSS_Channel_Code__c='110';
        claimsObj1.Customer_Name__c='';
        claimsObj1.Shop_Work_Order__c='12345';
        claimsObj1.Actual_Technician_Time__c=null;
        claimsObj1.Status__c = 'Submitted';
        ClaimsObj1.PACCAR_Flag__c=true;
        claimsObj1.Pending_Authorization__c ='Not Authorized';
        claimsObj1.Information_Only_Claim__c = true;
        insert claimsObj1;

        ApexPages.currentPage().getParameters().put('id', claimsObj1.Id);
       Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        List<CSS_Parts_Options__c>octtmllist = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.CSS_Claims__c = claimsObj1.id;
        partsoption.Account_Code__c = 'NEW PARTS WARRANTY 62';
        partsoption.RecordTypeId=recTypeIdpart;
        insert partsoption;
        octtmllist.add(partsoption);
        CSS_Parts_Options__c part2 = new CSS_Parts_Options__c();
        part2.CSS_Claims__c = claimsObj1.id;
        part2.Account_Code__c = 'NEW PARTS WARRANTY 62';
        part2.RecordTypeId=recTypeIdpart;
        insert part2;
        octtmllist.add(part2);
        //srt
        List<css_srt__c>adminsrtlist = new List<css_srt__c>();
        css_srt__c srts = new css_srt__c();
        srts.srt_id__c = '05-02Y-00';
        srts.CSS_Claims__c = claimsObj1.id;
        srts.Account_Code__c = 'CAMPAIGN 65';
        srts.Account_Code_Description__c = 'NEW PARTS WARRANTY 62';
        srts.Type__c = 'admin';
        insert srts;
        adminsrtlist.add(srts);
        css_srt__c srts2 = new css_srt__c();
        srts2.srt_id__c = '05-02Y-00';
        srts2.CSS_Claims__c = claimsObj1.id;
        srts2.Account_Code__c = 'CAMPAIGN 65';
        srts2.Account_Code_Description__c = 'NEW PARTS WARRANTY 62';
        srts2.Type__c = 'admin';
        insert srts2;
        adminsrtlist.add(srts2);
        CG_CL_ClaimsIntake claims6 = new CG_CL_ClaimsIntake();
        claims6.uncheckPopupsave();
        claims6.checkPopupsave();
        Test.stopTest();
    }
    
    
}