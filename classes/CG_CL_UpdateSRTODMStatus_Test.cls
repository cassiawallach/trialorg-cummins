@istest
public class CG_CL_UpdateSRTODMStatus_Test {
    static TestMethod void testSRT1() {
        test.startTest();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        jo.ESN__c = '79464646';
        jo.Unit_Number__c ='12345';
        jo.Make__c = 'test';
        jo.Service_Model__c = null;
        jo.VIN__c = '';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'NotCert';
        jo.ESN_IA__c = '5678909078';
        jo.Failure_Date__c = system.today();
        jo.Before_In_Service__c = false;
        jo.Warranty_Start_Date__c = system.today()+10;
        insert jo;
       
        id wid = apexpages.currentpage().getparameters().put('id',jo.id);
        
        List<CSS_SRT__c> srtList=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
			srt.Job_Order__c = wid;
            //srt.CSS_Claims__c = jo.id;
            srt.Access_Code_A__c = 65;
            srt.name = 'TestClassName';
			srt.type__c = 'Admin';
           	srt.Assignment__c = 'PRIMARY';
           	srt.srt_time__c = 1;
           	srt.SRT_ID__c = '00-901-10';
		    srt.isPerformed__c = true;
            srt.ODM_Status__c = '';
            srt.Access_Code__c = 'A';
            srt.Account_Code__c = '61';
                srtList.add(srt);
        
        CSS_SRT__c SRT1 = new CSS_SRT__c();
                srt1.Job_Order__c = wid;
                //srt1.CSS_Claims__c = testclaimsRec.id;
                srt1.Access_Code_A__c = 65;
                srt1.name = 'TestClassName';
                srt1.type__c = 'Admin';
                srt1.Assignment__c = 'PRIMARY';
                srt1.srt_time__c = 0;
                srt1.SRT_ID__c = '00-901-10';
                srt1.isPerformed__c = true;
                srt1.ODM_Status__c = '';
                srt1.Access_Code__c = 'A';
                srt1.Account_Code__c = 'EMISSION WARRANTY 70';
               srt1.Flex_Flag__c = true;
               srtList.add(srt1);
           
           insert srtList;
        
       List<CSS_Job_Order__c> jobLst = new List<CSS_Job_Order__c>();
        CSS_Job_Order__c obj = new CSS_Job_Order__c();
          obj.id = wid;
          insert obj;
        CSS_Job_Order__c obj1 = new CSS_Job_Order__c();
          obj1.id = wid;
          insert obj1;
         jobLst.add(obj);
         jobLst.add(obj1);
        
        List<css_claims__c> clmsLst = new List<css_claims__c>();
        css_claims__c clmObj = new css_claims__c();
           clmObj.id = wid;
           //insert clmObj;
         css_claims__c clmObj1 = new css_claims__c();
           clmObj1.id = wid;
           //insert clmObj1;
           clmsLst.add(clmObj);
           clmsLst.add(clmObj1);
           insert clmsLst;
           
           List<CSS_Parts_Options__c> prtLst = new List<CSS_Parts_Options__c>();
           CSS_Parts_Options__c prtsObj = new CSS_Parts_Options__c();
           prtsObj.id = wid;
           insert prtsObj;
           CSS_Parts_Options__c prtsObj1 = new CSS_Parts_Options__c();
           prtsObj1.id = wid;
           insert prtsObj1;
            prtLst.add(prtsObj);
            prtLst.add(prtsObj1);
           
        list<id> idlist = new list<id>();
        idlist.add(wid);
        CG_CL_UpdateSRTODMStatus.updateSRTODMStatus(idlist);
        test.stopTest();
    } 

       static TestMethod void testSRT2() {
        test.startTest();
           
           
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Distributor Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';      
        
        insert acc;
           
         
            List<css_claims__c> clmsLst = new List<css_claims__c>();
            CSS_Claims__c  testclaimsRec= new CSS_Claims__c();
               testclaimsRec.Customer_Name__c='TestCustomer';
               testclaimsRec.location__c ='Cummins NPower';    
               testclaimsRec.Location_Code__c = '02650-97895';
               testclaimsRec.Email_Address__c='abc@abc.com';
               testclaimsRec.CSS_Channel_Of_Distribution__c = 'test1';  
               testclaimsRec.Account__c=acc.id;
               clmsLst.add(testclaimsRec);
               insert clmsLst;
               
               list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
                CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
                
                solCompObj.Type__c ='OTH' ;//'Campaign';
                solCompObj.Selected_Component__c= true; 
                solCompObj.AccountCode__c ='testing';
                // solCompObj.Fail_Code__c = 'test';
                solCompObj.Notes__c = 'testNotes';
                solCompObj.Pay_Code__c='A';
                solCompObj.Status__c='Approved';
                solCompObj.CSS_Claims__c =clmsLst[0].id;
                lstsolcomp.add(solCompObj);
                insert lstsolcomp;
               
           List<CSS_SRT__c> srtList=new List<CSS_SRT__c>();
               CSS_SRT__c SRT = new CSS_SRT__c();
                //srt.Job_Order__c = wid;
                srt.CSS_Claims__c = testclaimsRec.id;
                srt.Access_Code_A__c = 65;
                srt.name = 'TestClassName';
                srt.type__c = 'Admin';
                srt.Assignment__c = 'PRIMARY';
                srt.srt_time__c = 0;
                srt.SRT_ID__c = '00-901-10';
                srt.isPerformed__c = true;
                srt.ODM_Status__c = '';
                srt.Access_Code__c = 'A';
                srt.Account_Code__c = '61';
               srt.Flex_Flag__c = true;
               srtList.add(srt);
           
           CSS_SRT__c SRT1 = new CSS_SRT__c();
                //srt.Job_Order__c = wid;
                srt1.CSS_Claims__c = testclaimsRec.id;
                srt1.Access_Code_A__c = 65;
                srt1.name = 'TestClassName';
                srt1.type__c = 'Admin';
                srt1.Assignment__c = 'PRIMARY';
                srt1.srt_time__c = 0;
                srt1.SRT_ID__c = '00-901-10';
                srt1.isPerformed__c = true;
                srt1.ODM_Status__c = '';
                srt1.Access_Code__c = 'A';
                srt1.Account_Code__c = 'EMISSION WARRANTY 70';
               srt1.Flex_Flag__c = true;
               srtList.add(srt1);
           
           insert srtList;
               
            list<id> idlist = new list<id>();
            idlist.add(testclaimsRec.Id);
            CG_CL_UpdateSRTODMStatus.updateSRTODMStatus(idlist);
         //  }
        test.stopTest();
    }
    
    static TestMethod void testSRT3() {
        test.startTest();
           
           css_header_nav__c cssHeaderObject = new css_header_nav__c();
           cssHeaderObject.RSWButtonEnable__c = true;
           insert cssHeaderObject;
           
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Distributor Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';      
        
        insert acc;
           
         
            List<css_claims__c> clmsLst = new List<css_claims__c>();
            CSS_Claims__c  testclaimsRec= new CSS_Claims__c();
               testclaimsRec.Customer_Name__c='TestCustomer';
               testclaimsRec.location__c ='Cummins NPower';    
               testclaimsRec.Location_Code__c = '02650-97895';
               testclaimsRec.Email_Address__c='abc@abc.com';
               testclaimsRec.CSS_Channel_Of_Distribution__c = 'test1';  
               testclaimsRec.Account__c=acc.id;
        testclaimsRec.Information_Only_Claim__c=true;
               clmsLst.add(testclaimsRec);
               insert clmsLst;
               
               list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
                CSS_Solution_Component__c solCompObj = new CSS_Solution_Component__c();
                
                solCompObj.Type__c ='OTH' ;//'Campaign';
                solCompObj.Selected_Component__c= true; 
                solCompObj.AccountCode__c ='testing';
                // solCompObj.Fail_Code__c = 'test';
                solCompObj.Notes__c = 'testNotes';
                solCompObj.Pay_Code__c='A';
                solCompObj.Status__c='Approved';
                solCompObj.CSS_Claims__c =clmsLst[0].id;
                lstsolcomp.add(solCompObj);
                insert lstsolcomp;
               
           List<CSS_SRT__c> srtList=new List<CSS_SRT__c>();
               CSS_SRT__c SRT = new CSS_SRT__c();
                //srt.Job_Order__c = wid;
                srt.CSS_Claims__c = testclaimsRec.id;
                srt.Access_Code_A__c = 65;
                srt.name = 'TestClassName';
                srt.type__c = 'Admin';
                srt.Assignment__c = 'PRIMARY';
                srt.srt_time__c = 0;
                srt.SRT_ID__c = '00-901-10';
                srt.isPerformed__c = true;
                srt.ODM_Status__c = '';
                srt.Access_Code__c = 'A';
                srt.Account_Code__c = '61';
               srt.Flex_Flag__c = true;
               srtList.add(srt);
           
           CSS_SRT__c SRT1 = new CSS_SRT__c();
                //srt.Job_Order__c = wid;
                srt1.CSS_Claims__c = testclaimsRec.id;
                srt1.Access_Code_A__c = 65;
                srt1.name = 'TestClassName';
                srt1.type__c = 'Admin';
                srt1.Assignment__c = 'PRIMARY';
                srt1.srt_time__c = 0;
                srt1.SRT_ID__c = '00-901-10';
                srt1.isPerformed__c = true;
                srt1.ODM_Status__c = '';
                srt1.Access_Code__c = 'A';
                srt1.Account_Code__c = 'EMISSION WARRANTY 70';
               srt1.Flex_Flag__c = true;
               srtList.add(srt1);
           
           insert srtList;
               
               List<CSS_Parts_Options__c> prtLst = new List<CSS_Parts_Options__c>();
               CSS_Parts_Options__c prtsObj = new CSS_Parts_Options__c();
               prtsObj.CSS_Claims__c = testclaimsRec.id;
               insert prtsObj;
               CSS_Parts_Options__c prtsObj1 = new CSS_Parts_Options__c();
               prtsObj1.CSS_Claims__c = testclaimsRec.id;
               insert prtsObj1;
                prtLst.add(prtsObj);
                prtLst.add(prtsObj1);
               
            list<id> idlist = new list<id>();
            idlist.add(testclaimsRec.Id);
            CG_CL_UpdateSRTODMStatus.updateSRTODMStatus(idlist);
         //  }
        test.stopTest();
    }
    
    static TestMethod void testSRT4() {
        test.startTest();
           
           css_header_nav__c cssHeaderObject = new css_header_nav__c();
           cssHeaderObject.RSWButtonEnable__c = true;
           insert cssHeaderObject;
           
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.Type='Distributor Account';
        acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        acc.IAM_Service_Provider_Code__c  = '56270';
        acc.CMI_Account_Status__c = 'Active';      
        
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        jo.ESN__c = '79464646';
        jo.Unit_Number__c ='12345';
        jo.Make__c = 'test';
        jo.Service_Model__c = null;
        jo.VIN__c = '';
        jo.Warranty_Start_Date__c = null;
        jo.Location_Certification__c = 'NotCert';
        jo.ESN_IA__c = '5678909078';
        jo.Failure_Date__c = system.today();
        jo.Before_In_Service__c = false;
        jo.Warranty_Start_Date__c = system.today()+10;
        insert jo;
               
        list<id> idlist = new list<id>();
        idlist.add(jo.Id);
        CG_CL_UpdateSRTODMStatus.updateSRTODMStatus(idlist);
         
        test.stopTest();
    }
    }