@istest
public class CG_CL_UpdatePartReturnToCenterFlag_Test {
   static testmethod void testmethod1()
   {
       CG_CL_UpdatePartReturnToCenterFlag upd = new CG_CL_UpdatePartReturnToCenterFlag();
       
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

       
       CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            testclaimsRec.Account__c = acc.id;
            testclaimsRec.Customer_Name__c='Test Customer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.PartReturnToCenter__c = 'Test';
             insert testclaimsRec;
       CSS_PSN__c psn = new CSS_PSN__c();
       psn.CSS_Claims__c = testclaimsRec.id;
       psn.Primary__c = true;
       insert psn;
       
             String stestclaimid = String.valueOf(testclaimsRec.Id);
       
       CSS_Claim_Submission__c claimssub = new CSS_Claim_Submission__c();
             //claimssub.Claim_Submission_Id__c = 'C-12133323';
             claimssub.Claim_Status__c = 'Test';
             claimssub.ClaimCreatedDate__c = date.today();
             claimssub.Claim_Number__c = '23232';
             claimssub.Account_Code__c = '12334';
             claimssub.Credit_Number__c = '3232';
             claimssub.PartReturnToCenter__c = 'Test';
             claimssub.CSS_Claims__c = testclaimsrec.id;
             
       insert claimssub;
       
       CSS_Parts_Options__c prtsopnrec = new CSS_Parts_Options__c();
          prtsopnrec.Account_Code__c = '1212213';
          prtsopnrec.CSS_Claims__c = testclaimsrec.id;
          prtsopnrec.City__c = 'Bangalore';
          prtsopnrec.Claimtype__c = 'Test';
          prtsopnrec.Comments__c = 'Test';
          prtsopnrec.Create_Date__c = '18092018';
          prtsopnrec.Fail_Code__c = '1213232';
          prtsopnrec.Parts_Return__c = 'Test';
          prtsopnrec.ReturnToFactory__c = 'Y';
          prtsopnrec.ReturnWaiver__c = false;
          prtsopnrec.selected_part__c = true;
          prtsopnrec.FailurepartId__c = null;
               insert prtsopnrec;
       
       list<CSS_Solution_Component__c> lstsol = new list<CSS_Solution_Component__c>();
       CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
       solcomp.Selected_Component__c=true;
       solcomp.AccountCode__c='emission';
       solcomp.CSS_Claims__c=testclaimsRec.id;
       //solcomp.Status__c='Approved';
      // solcomp.Type__c='Campaign';
       solcomp.AccountCode__c='emission';
       CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
       solcomp1.Selected_Component__c=true;
       solcomp1.AccountCode__c='emission';
       solcomp1.CSS_Claims__c=testclaimsRec.id;
       //solcomp.Status__c='Approved';
      // solcomp.Type__c='Campaign';
       solcomp1.AccountCode__c='emission';
       lstsol.add(solcomp1);
       
       List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
       CSS_SRT__c srt = new CSS_SRT__c();
         srt.SRT_ID__c = '00-10S-00';
         srt.CSS_Claims__c = testclaimsrec.id; 
         srt.Type__c = 'Admin';
         srt.SRT_Type__c = 'Admin';
         srt.SRT_Warrantable__c = '100';
         srt.SRT_Title__c = 'Test';
         //srt.SRT_Category__c = 'Additional';
         srt.FailCode__c = 'EQ';
         srt.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srt.Account_Code__c = '121232322';
         srt.Account_Code_Description__c = 'Test';
         srt.Adjustment_Reason__c = 'Test';
       
      insert srt;
       
       CSS_SRT__c srtlist = new CSS_SRT__c();
         srtlist.SRT_ID__c = '00-10S-00';
         srtlist.CSS_Claims__c = testclaimsrec.id; 
         srtlist.Type__c = 'Admin';
         srtlist.SRT_Type__c = 'Admin';
         srtlist.SRT_Warrantable__c = '100';
         srtlist.SRT_Title__c = 'Test';
         srtlist.SRT_Category__c = 'AdditionalDiag';
         srtlist.FailCode__c = 'EQ';
         srtlist.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srtlist.Account_Code__c = '121232322';
         srtlist.Account_Code_Description__c = 'Test';
         srtlist.Adjustment_Reason__c = 'Test';
      insert srtlist;
       
        list<String> stringList = new list<String>();
         String s = 'N;;'+'false;;'+stestclaimid;
         system.debug('stestclaimid'+stestclaimid);
       
          stringList.add(s);
           system.debug('stringList'+stringList);
        //stringList.add('N;;');stringList.add('true;;');stringList.add(stestclaimid);
       
       lstSRT.add(srt);
       lstSRT.add(srtlist);
       lstSRT = CSS_WS_SRT.getAllClaimsDigRepSRTs(testclaimsRec.id,'Admin');
       Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
            CG_CL_UpdatePartReturnToCenterFlag.callAdminSRT(testclaimsRec.id, 'Admin', 'EQ', 'Campaigns','test','7');
            CG_CL_UpdatePartReturnToCenterFlag.setPRCtoClaimSubmissions(testclaimsRec.id, 'Test');
            Test.startTest();
            CG_CL_UpdatePartReturnToCenterFlag.updatePRCFlag(stringList);
          Test.stopTest();
      
 }
    public static testmethod void testmethdrecur(){
        
    CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.ESN__c = '79464646';
        insert testclaimsRec;
        
       CSS_Parts_Options__c prtsopnrec = new CSS_Parts_Options__c();
          prtsopnrec.Account_Code__c = '1212213';
          prtsopnrec.CSS_Claims__c = testclaimsrec.id;
          prtsopnrec.City__c = 'Bangalore';
          prtsopnrec.Claimtype__c = 'Test';
          prtsopnrec.Comments__c = 'Test';
          prtsopnrec.Create_Date__c = '18092018';
          prtsopnrec.Fail_Code__c = '1213232';
          prtsopnrec.Parts_Return__c = 'Test';
          prtsopnrec.ReturnToFactory__c ='Y';
          prtsopnrec.ReturnWaiver__c = false;
          prtsopnrec.selected_part__c = true;
          prtsopnrec.FailurepartId__c = null;
              insert prtsopnrec;
        String stestclaimid = String.valueOf(testclaimsRec.Id);
         list<String> stringList = new list<String>();
         String s = 'N;;'+'false;;'+stestclaimid;
         system.debug('stestclaimid'+stestclaimid);
       
          stringList.add(s);
        CG_CL_UpdatePartReturnToCenterFlag.updatePRCFlag(stringList);
    }
    static testmethod void testmethod2()
   {
       CG_CL_UpdatePartReturnToCenterFlag upd = new CG_CL_UpdatePartReturnToCenterFlag();
       
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
       
       CSS_Claims__c testclaimsRec = new CSS_Claims__c();
          testclaimsRec.Account__c = Acc.id;
          testclaimsRec.Customer_Name__c='Test Customer';
          testclaimsRec.Customer_Code__c = '1234';
           testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.PartReturnToCenter__c = 'Test';
             insert testclaimsRec;
       CSS_PSN__c psn = new CSS_PSN__c();
       psn.CSS_Claims__c = testclaimsRec.id;
       psn.Primary__c = true;
       insert psn;
       
             String stestclaimid = String.valueOf(testclaimsRec.Id);
       
       CSS_Claim_Submission__c claimssub = new CSS_Claim_Submission__c();
             //claimssub.Claim_Submission_Id__c = 'C-12133323';
             claimssub.Claim_Status__c = 'Test';
             claimssub.ClaimCreatedDate__c = date.today();
             claimssub.Claim_Number__c = '23232';
             claimssub.Account_Code__c = '12334';
             claimssub.Credit_Number__c = '3232';
             claimssub.PartReturnToCenter__c = 'Test';
             claimssub.CSS_Claims__c = testclaimsrec.id;
             
       insert claimssub;
       
       CSS_Parts_Options__c prtsopnrec = new CSS_Parts_Options__c();
          prtsopnrec.Account_Code__c = '1212213';
          prtsopnrec.CSS_Claims__c = testclaimsrec.id;
          prtsopnrec.City__c = 'Bangalore';
          prtsopnrec.Claimtype__c = 'Test';
          prtsopnrec.Comments__c = 'Test';
          prtsopnrec.Create_Date__c = '18092018';
          prtsopnrec.Fail_Code__c = '1213232';
          prtsopnrec.Parts_Return__c = 'Test';
          prtsopnrec.ReturnToFactory__c = 'Y';
          prtsopnrec.ReturnWaiver__c = false;
          prtsopnrec.selected_part__c = true;
          prtsopnrec.FailurepartId__c = null;
              insert prtsopnrec;
       
       list<CSS_Solution_Component__c> lstsol = new list<CSS_Solution_Component__c>();
       CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
       solcomp.Selected_Component__c=true;
       solcomp.AccountCode__c='emission';
       solcomp.CSS_Claims__c=testclaimsRec.id;
       //solcomp.Status__c='Approved';
      // solcomp.Type__c='Campaign';
       solcomp.AccountCode__c='emission';
       CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
       solcomp1.Selected_Component__c=true;
       solcomp1.AccountCode__c='emission';
       solcomp1.CSS_Claims__c=testclaimsRec.id;
       //solcomp.Status__c='Approved';
      // solcomp.Type__c='Campaign';
       solcomp1.AccountCode__c='emission';
       lstsol.add(solcomp1);
       
       List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
       CSS_SRT__c srt = new CSS_SRT__c();
         srt.SRT_ID__c = '00-10S-00';
         srt.CSS_Claims__c = testclaimsrec.id; 
         srt.Type__c = 'Admin';
         srt.SRT_Type__c = 'Admin';
         srt.SRT_Warrantable__c = '100';
         srt.SRT_Title__c = 'Test';
         //srt.SRT_Category__c = 'Additional';
         srt.FailCode__c = 'EQ';
         srt.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srt.Account_Code__c = '121232322';
         srt.Account_Code_Description__c = 'Test';
         srt.Adjustment_Reason__c = 'Test';
              insert srt;
       
       CSS_SRT__c srtlist = new CSS_SRT__c();
         srtlist.SRT_ID__c = '00-10S-00';
         srtlist.CSS_Claims__c = testclaimsrec.id; 
         srtlist.Type__c = 'Admin';
         srtlist.SRT_Type__c = 'Admin';
         srtlist.SRT_Warrantable__c = '100';
         srtlist.SRT_Title__c = 'Test';
         srtlist.SRT_Category__c = 'AdditionalDiag';
         srtlist.FailCode__c = 'EQ';
         srtlist.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srtlist.Account_Code__c = '121232322';
         srtlist.Account_Code_Description__c = 'Test';
         srtlist.Adjustment_Reason__c = 'Test';
      insert srtlist;
       
        list<String> stringList = new list<String>();
         String s = 'Y;;'+'false;;'+stestclaimid+';;'+'True';
         system.debug('stestclaimid'+stestclaimid);
       
          stringList.add(s);
           system.debug('stringList'+stringList);
        //stringList.add('N;;');stringList.add('true;;');stringList.add(stestclaimid);
       
       lstSRT.add(srt);
       lstSRT.add(srtlist);
       lstSRT = CSS_WS_SRT.getAllClaimsDigRepSRTs(testclaimsRec.id,'Admin');
       Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
            CG_CL_UpdatePartReturnToCenterFlag.callAdminSRT(testclaimsRec.id, 'Admin', 'EQ', 'Campaigns','','7');
            CG_CL_UpdatePartReturnToCenterFlag.setPRCtoClaimSubmissions(testclaimsRec.id, 'Test');
            Test.startTest();
            CG_CL_UpdatePartReturnToCenterFlag.updatePRCFlag(stringList);
          Test.stopTest();
      
 }
    static testmethod void testmethod3()
   {
       CG_CL_UpdatePartReturnToCenterFlag upd = new CG_CL_UpdatePartReturnToCenterFlag();
       
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
       
       CSS_Claims__c testclaimsRec = new CSS_Claims__c();
          
          testclaimsRec.Customer_Name__c='Test Customer';
          testclaimsRec.Account__c = Acc.id;
          testclaimsRec.Customer_Code__c = '1234';
           testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.PartReturnToCenter__c = 'Test';
             insert testclaimsRec;
       CSS_PSN__c psn = new CSS_PSN__c();
       psn.CSS_Claims__c = testclaimsRec.id;
       psn.Primary__c = true;
       insert psn;
       
             String stestclaimid = String.valueOf(testclaimsRec.Id);
       
       CSS_Claim_Submission__c claimssub = new CSS_Claim_Submission__c();
             //claimssub.Claim_Submission_Id__c = 'C-12133323';
             claimssub.Claim_Status__c = 'Test';
             claimssub.ClaimCreatedDate__c = date.today();
             claimssub.Claim_Number__c = '23232';
             claimssub.Account_Code__c = '12334';
             claimssub.Credit_Number__c = '3232';
             claimssub.PartReturnToCenter__c = 'Test';
             claimssub.CSS_Claims__c = testclaimsrec.id;
             
       insert claimssub;
      
       CSS_Parts_Options__c prtsopnrec = new CSS_Parts_Options__c();
          prtsopnrec.Account_Code__c = 'CMP – Field Actions 65';
          prtsopnrec.CSS_Claims__c = testclaimsrec.id;
          prtsopnrec.City__c = 'Bangalore';
          prtsopnrec.Claimtype__c = 'Test';
          prtsopnrec.Comments__c = 'Test';
          prtsopnrec.Create_Date__c = '18092018';
          prtsopnrec.Fail_Code__c = 'TRP 2035-WUSSCB';
          prtsopnrec.Parts_Return__c = 'Test';
          prtsopnrec.ReturnToFactory__c = 'Y';
          prtsopnrec.ReturnWaiver__c = false;
       	  prtsopnrec.selected_part__c=true;
          prtsopnrec.FailurepartId__c=null;
                insert prtsopnrec;
       CSS_Parts_Options__c cp =[select id, FailurepartId__r.Service_Job__c, selected_part__c, ReturnWaiver__c, ReturnToFactory__c, CSS_Claims__c from CSS_Parts_Options__c where id =:prtsopnrec.id];
      system.debug('cp '+cp);
       list<CSS_Solution_Component__c> lstsol = new list<CSS_Solution_Component__c>();
       CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
       solcomp.Name='test';
       solcomp.Selected_Component__c=true;
       solcomp.AccountCode__c='65';
       solcomp.CSS_Claims__c=testclaimsRec.id;
       //solcomp.Service_Job__c=null;
       //solcomp.Status__c='Approved';
       solcomp.Type__c='Campaign';
       solcomp.AccountCodeType__c ='CMP – Field Actions';
       solcomp.CampaignLaborPercentage__c='2';
       solcomp.Fail_Code_Editable__c ='TRP 2035-WUSSCB';
       CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
       solcomp1.Name='test'; 
       solcomp1.Selected_Component__c=true;
       solcomp1.AccountCode__c='65';
       solcomp1.CSS_Claims__c=testclaimsRec.id;
       solcomp1.Service_Job__c=null;
       //solcomp.Status__c='Approved';
      solcomp1.Type__c='Campaign';
       solcomp1.AccountCodeType__c ='CMP – Field Actions';
       solcomp1.CampaignLaborPercentage__c='2';
       lstsol.add(solcomp1);
       lstsol.add(solcomp);
       insert lstsol;
       List<CSS_Solution_Component__c> cs =[select id,CampaignLaborPercentage__c , CSS_Account_Formula__c,FailCode_Formula__c from CSS_Solution_Component__c where id =:solcomp.id or id =:solcomp1.id];
       system.debug('lstsol '+cs);
       
       
       List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
       CSS_SRT__c srt = new CSS_SRT__c();
         srt.SRT_ID__c = '00-10S-00';
         srt.CSS_Claims__c = testclaimsrec.id; 
         srt.Type__c = 'Diagnosis';
         srt.SRT_Type__c = 'Admin';
         srt.SRT_Warrantable__c = '100';
         srt.SRT_Title__c = 'Test';
         //srt.SRT_Category__c = 'Additional';
         srt.FailCode__c = 'EQ';
         srt.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srt.Account_Code__c = '121232322';
         srt.Account_Code_Description__c = 'Test';
         srt.Adjustment_Reason__c = 'Test';
       
      insert srt;
       
       CSS_SRT__c srtlist = new CSS_SRT__c();
         srtlist.SRT_ID__c = '00-10S-00';
         srtlist.CSS_Claims__c = testclaimsrec.id; 
         srtlist.Type__c = 'Diagnosis';
         srtlist.SRT_Type__c = 'Admin';
         srtlist.SRT_Warrantable__c = '100';
         srtlist.SRT_Title__c = 'Test';
         srtlist.SRT_Category__c = 'AdditionalDiag';
         srtlist.FailCode__c = 'EQ';
         srtlist.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srtlist.Account_Code__c = '121232322';
         srtlist.Account_Code_Description__c = 'Test';
         srtlist.Adjustment_Reason__c = 'Test';
      insert srtlist;
       
        list<String> stringList = new list<String>();
         String s = 'Y;;'+'false;;'+stestclaimid+';;'+'True';
         system.debug('stestclaimid'+stestclaimid);
       
          stringList.add(s);
           system.debug('stringList'+stringList);
        //stringList.add('N;;');stringList.add('true;;');stringList.add(stestclaimid);
       
       lstSRT.add(srt);
       lstSRT.add(srtlist);
       lstSRT = CSS_WS_SRT.getAllClaimsDigRepSRTs(testclaimsRec.id,'Admin');
       Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
            CG_CL_UpdatePartReturnToCenterFlag.callAdminSRT(testclaimsRec.id, 'Admin', 'EQ', 'Campaigns','','7');
            CG_CL_UpdatePartReturnToCenterFlag.setPRCtoClaimSubmissions(testclaimsRec.id, 'Test');
            Test.startTest();
            CG_CL_UpdatePartReturnToCenterFlag.updatePRCFlag(stringList);
          Test.stopTest();
      
 }
    static testmethod void testmethod4()
   {
       CG_CL_UpdatePartReturnToCenterFlag upd = new CG_CL_UpdatePartReturnToCenterFlag();
       
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
       
       
       CSS_Claims__c testclaimsRec = new CSS_Claims__c();
          testclaimsRec.Account__c = acc.id;
          testclaimsRec.Customer_Name__c='Test Customer';
          testclaimsRec.Customer_Code__c = '1234';
           testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.PartReturnToCenter__c = 'Test';
       			//testclaimsRec.SP_INSHOP_LABOR_RATE__c='test';
             insert testclaimsRec;
       CSS_PSN__c psn = new CSS_PSN__c();
       psn.CSS_Claims__c = testclaimsRec.id;
       psn.Primary__c = true;
       insert psn;
       
             String stestclaimid = String.valueOf(testclaimsRec.Id);
       
       
      list<CSS_Solution_Component__c> lstsol = new list<CSS_Solution_Component__c>();
       CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
       solcomp.Name='test';
       solcomp.Selected_Component__c=true;
       solcomp.AccountCode__c='65';
       solcomp.CSS_Claims__c=testclaimsRec.id;
       solcomp.Service_Job__c=null;
       //solcomp.Status__c='Approved';
       solcomp.CoveredLaborHrs__c='4';
       solcomp.AccountCodeType__c ='CMP – Field Actions';
       solcomp.CampaignLaborPercentage__c='2';
       solcomp.Fail_Code_Editable__c ='TRP 2035-WUSSCB';
       
       lstsol.add(solcomp);
       insert lstsol;
       List<CSS_Solution_Component__c> cs =[select id,Service_Job__c,CampaignLaborPercentage__c , CSS_Account_Formula__c,FailCode_Formula__c from CSS_Solution_Component__c where id =:solcomp.id];
       system.debug('lstsol '+cs);
       CSS_Parts_Options__c prtsopnrec = new CSS_Parts_Options__c();
          prtsopnrec.Account_Code__c = 'CMP – Field Actions 65';
          prtsopnrec.CSS_Claims__c = testclaimsrec.id;
          prtsopnrec.City__c = 'Bangalore';
          prtsopnrec.Claimtype__c = 'Test';
          prtsopnrec.Comments__c = 'Test';
          prtsopnrec.Create_Date__c = '18092018';
          prtsopnrec.Fail_Code__c = 'TRP 2035-WUSSCB';
          prtsopnrec.Parts_Return__c = 'Test';
          prtsopnrec.ReturnToFactory__c = 'Y';
          prtsopnrec.ReturnWaiver__c = false;
          prtsopnrec.selected_part__c=true;
          prtsopnrec.FailurepartId__c=null;
                 insert prtsopnrec;
       CSS_Parts_Options__c cp =[select id, FailurepartId__r.Service_Job__c, selected_part__c, ReturnWaiver__c, ReturnToFactory__c, CSS_Claims__c from CSS_Parts_Options__c where id =:prtsopnrec.id];
      system.debug('cp '+cp);
       
       
       
       List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
       CSS_SRT__c srt = new CSS_SRT__c();
         srt.SRT_ID__c = '00-10S-00';
         srt.CSS_Claims__c = testclaimsrec.id; 
         srt.Type__c = 'Diagnosis';
         srt.SRT_Type__c = 'Admin';
         srt.SRT_Warrantable__c = '100';
         srt.SRT_Title__c = 'Test';
         //srt.SRT_Category__c = 'Additional';
         srt.FailCode__c = 'EQ';
         srt.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srt.Account_Code__c = '121232322';
         srt.Account_Code_Description__c = 'Test';
         srt.Adjustment_Reason__c = 'Test';
       
      insert srt;
       
       CSS_SRT__c srtlist = new CSS_SRT__c();
         srtlist.SRT_ID__c = '00-10S-00';
         srtlist.CSS_Claims__c = testclaimsrec.id; 
         srtlist.Type__c = 'Diagnosis';
         srtlist.SRT_Type__c = 'Admin';
         srtlist.SRT_Warrantable__c = '100';
         srtlist.SRT_Title__c = 'Test';
         srtlist.SRT_Category__c = 'AdditionalDiag';
         srtlist.FailCode__c = 'EQ';
         srtlist.isPerformed__c = true;
         //srt.SRT_Time__c = '10.0';
         //srt.SRT_Quantity__c = '1';
         srtlist.Account_Code__c = '121232322';
         srtlist.Account_Code_Description__c = 'Test';
         srtlist.Adjustment_Reason__c = 'Test';
      insert srtlist;
       
        list<String> stringList = new list<String>();
         String s = 'Y;;'+'false;;'+stestclaimid+';;'+'True';
         system.debug('stestclaimid'+stestclaimid);
       
          stringList.add(s);
           system.debug('stringList'+stringList);
        //stringList.add('N;;');stringList.add('true;;');stringList.add(stestclaimid);
       
       lstSRT.add(srt);
       lstSRT.add(srtlist);
       lstSRT = CSS_WS_SRT.getAllClaimsDigRepSRTs(testclaimsRec.id,'Admin');
       Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
            CG_CL_UpdatePartReturnToCenterFlag.callAdminSRT(testclaimsRec.id, 'Admin', 'EQ', 'Campaigns','','7');
            CG_CL_UpdatePartReturnToCenterFlag.setPRCtoClaimSubmissions(testclaimsRec.id, 'Test');
            Test.startTest();
            CG_CL_UpdatePartReturnToCenterFlag.updatePRCFlag(stringList);
          Test.stopTest();
      
 }

}