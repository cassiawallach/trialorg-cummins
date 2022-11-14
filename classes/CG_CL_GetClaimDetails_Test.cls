@isTest
public class CG_CL_GetClaimDetails_Test {  
 
      public static Testmethod void CallGetClaims_Test13()
    {
      
         CSS_Integration_Details__c connection1 = new CSS_Integration_Details__c ();
        connection1.ApplicationName__c='CSS_SBL_GetClaimDetails';
        connection1.Name='CSS_SBL_GetClaimDetails';
        connection1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/claims?sender=CSS&target=CSSWarranty&siebelClaimNumber=1-1011307897';
        connection1.Method_Type__c='GET';
        connection1.Timeout__c=2.0;
        connection1.IsActive__c=true;
          connection1.Key__c='FQ8oAT/x8qGEujKi0UY0sdjsNF7HOCnRtWFjXaQBLMI=';
          connection1.Username__c='	/eOKgAPkL2C/vdW6v20pWSt08Z3NjnUbaa5ZarceWZo/ZG8WZXP7c3waikblHoHlHHA16KLKObCDKmH/tIf1wQ==';
          connection1.Passcode__c='usXis4pEpIhVfhEf7RiHuqV9YqDdZts/vMFtlCUCvHncqwlScZeYX5HqxH8Ru5DAFFvkiesgqP8pkfTYK861FA==';
          connection1.Logging__c='Test';
        insert connection1;
        
         CSS_Integration_Details__c connection2 = new CSS_Integration_Details__c ();
        connection2.ApplicationName__c='CG_SBL_ClaimPaymentStatus';
        connection2.Name='CG_SBL_ClaimPaymentStatus';
        connection2.End_Point__c='https://services-dev.cummins.com/csswarranty/getsiebelclaimdetails/';
        connection2.Method_Type__c='GET';
        connection2.Timeout__c=2.0;
        connection2.IsActive__c=true;
          connection2.Key__c='FQ8oAT/x8qGEujKi0UY0sdjsNF7HOCnRtWFjXaQBLMI=';
          connection2.Username__c='	/eOKgAPkL2C/vdW6v20pWSt08Z3NjnUbaa5ZarceWZo/ZG8WZXP7c3waikblHoHlHHA16KLKObCDKmH/tIf1wQ==';
          connection2.Passcode__c='usXis4pEpIhVfhEf7RiHuqV9YqDdZts/vMFtlCUCvHncqwlScZeYX5HqxH8Ru5DAFFvkiesgqP8pkfTYK861FA==';
          connection2.Logging__c='Test';
        insert connection2;
        
        LIST<CSS_Integration_Details__c> connectionlist = [select id,ApplicationName__c,Name,End_Point__c,Method_Type__c,Timeout__c from CSS_Integration_Details__c];
        system.debug('connectionlist'+connectionlist[0]);
        CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
         connection=CSS_Integration_Details__c.getvalues(connection1.ApplicationName__c);  
        system.assert(connection.Method_Type__c!=null);
       
        CSS_Job_Order__c jo =  CSS_TestData.createJobOrder(true); 
        CSS_Claims__c claimRec = CSS_TestData.createclaims(false,jo.id);
        claimRec.SiebelClaimNumber__c='12-1234356';
        insert claimRec;
        CSS_Claim_Submission__c claimSub = CSS_TestData.createclaimsub(false,claimRec.id);
        claimSub.Siebel_Claim_Number__c='12-1234356';
        insert claimSub;
        CSS_PSN__c psn = CSS_TestData.createpsn(true,claimRec.id);
        apexpages.currentPage().getparameters().put('id',claimRec.id);

        
                Test.startTest();
        CG_CL_GetClaimDetails cls = new CG_CL_GetClaimDetails();
           system.debug('starts>>>');
             test.setMock(httpcalloutmock.class,new CG_CL_GetPaymentDetails_Mock());
        cls.CallgetPaymentDetails();
        system.debug('ends>>');
        Test.stopTest();
        
    }  
         static testmethod void method1(){
         CSS_Integration_Details__c connection1 = new CSS_Integration_Details__c ();
        connection1.ApplicationName__c='CSS_SBL_GetClaimDetails';
        connection1.Name='CSS_SBL_GetClaimDetails';
        connection1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/claims?sender=CSS&target=CSSWarranty&siebelClaimNumber=1-1011307897';
        connection1.Method_Type__c='GET';
        connection1.Timeout__c=2.0;
        connection1.IsActive__c=true;
          connection1.Key__c='FQ8oAT/x8qGEujKi0UY0sdjsNF7HOCnRtWFjXaQBLMI=';
          connection1.Username__c='	/eOKgAPkL2C/vdW6v20pWSt08Z3NjnUbaa5ZarceWZo/ZG8WZXP7c3waikblHoHlHHA16KLKObCDKmH/tIf1wQ==';
          connection1.Passcode__c='usXis4pEpIhVfhEf7RiHuqV9YqDdZts/vMFtlCUCvHncqwlScZeYX5HqxH8Ru5DAFFvkiesgqP8pkfTYK861FA==';
          connection1.Logging__c='Test';
        insert connection1;
        
         CSS_Integration_Details__c connection2 = new CSS_Integration_Details__c ();
        connection2.ApplicationName__c='CG_SBL_ClaimPaymentStatus';
        connection2.Name='CG_SBL_ClaimPaymentStatus';
        connection2.End_Point__c='https://services-dev.cummins.com/csswarranty/getsiebelclaimdetails/';
        connection2.Method_Type__c='GET';
        connection2.Timeout__c=2.0;
        connection2.IsActive__c=true;
          connection2.Key__c='FQ8oAT/x8qGEujKi0UY0sdjsNF7HOCnRtWFjXaQBLMI=';
          connection2.Username__c='	/eOKgAPkL2C/vdW6v20pWSt08Z3NjnUbaa5ZarceWZo/ZG8WZXP7c3waikblHoHlHHA16KLKObCDKmH/tIf1wQ==';
          connection2.Passcode__c='usXis4pEpIhVfhEf7RiHuqV9YqDdZts/vMFtlCUCvHncqwlScZeYX5HqxH8Ru5DAFFvkiesgqP8pkfTYK861FA==';
          connection2.Logging__c='Test';
        insert connection2;
        CSS_Job_Order__c jo =  CSS_TestData.createJobOrder(true); 
        CSS_Claims__c claimRec = CSS_TestData.createclaims(true,jo.id);
        CSS_Claim_Submission__c claimSub = CSS_TestData.createclaimsub(false,claimRec.id);
        claimSub.Claim_Number__c='12-1234356';
        insert claimSub;
        CSS_PSN__c psn = CSS_TestData.createpsn(true,claimRec.id);
        apexpages.currentPage().getparameters().put('id',claimRec.id);
        Account a = new Account();
        CG_CL_GetClaimDetails claimDetail = new CG_CL_GetClaimDetails();
        CG_CL_GetClaimDetails.claimDetailExternalNotesWrapper wrap1 = new CG_CL_GetClaimDetails.claimDetailExternalNotesWrapper();
        wrap1.Note = 'venkat test';
        wrap1.NoteType = 'wenchin Test';
        wrap1.CreatedDate = 'today';
        wrap1.CreatedDateString = 'test';
        
        CG_CL_GetClaimDetails.claimDetailSRTswrapper wrap2 = new CG_CL_GetClaimDetails.claimDetailSRTswrapper();
        wrap2.SRTHours = 0.2;
        wrap2.SRTQty = 2;
        wrap2.PercentageAdjustment = 100;
        wrap2.AdjustmentReason = 'tets';
        wrap2.AccessCode = '123';
        wrap2.SRTCode = '5786';
        wrap2.Hours ='12';
        wrap2.ClaimedQuantity = '12';
        wrap2.Claimedper= '12';
        wrap2.PenaltyAppliedFlag = '12';
        CG_CL_GetClaimDetails.claimDetailOtherClaimableswrapper wrap3 = new CG_CL_GetClaimDetails.claimDetailOtherClaimableswrapper();
        wrap3.Item = 'wenchin';
        wrap3.Description = 'wenchin test';
        wrap3.ApprovedAmount = '123456';
        wrap3.AdjustmentReason = 'test';
        wrap3.ClaimedItemAmount = '56476';
        
        CG_CL_GetClaimDetails.claimDetailPartswrapper wrap4 = new CG_CL_GetClaimDetails.claimDetailPartswrapper();
        wrap4.AdjustmentPartsPercent = 12;
        wrap4.PartQty = '12';
        wrap4.PartNumber = '1234';
        wrap4.AdjustmentReason = 'wenchin test';
        wrap4.PartDescription = 'wenchin test';
        wrap4.ClaimedQuantity = '45';
        wrap4.EPRTracking = 'true';
        wrap4.ReturnID = 'check';
        
        CG_CL_GetClaimDetails.claimDetailTravelwrapper wrap5 = new CG_CL_GetClaimDetails.claimDetailTravelwrapper();
        wrap5.Type = 'test';
        wrap5.TravelType = 'test';
        wrap5.AdjustmentReason = 'test';
        wrap5.Distance = '123321';
        wrap5.Hours = '1233';
        wrap5.LodgingAmount = '12.3';
        wrap5.MealsAmount = '1222';
        wrap5.TowingDetails = '12123';
        wrap5.ClaimedAmount = '123';
        wrap5.ClaimedLodgingMealsAmount = '123';
        wrap5.ClaimedMileage = '123';
        wrap5.ClaimedHours = 122333;
        wrap5.TotalTravel = '123333';
        wrap5.BaseFare = 'test';
        wrap5.TravelAdjustedPercentage = 1233;
        wrap5.PenaltyAppliedFlag = 'test';
        
        CG_CL_GetClaimDetails.ClaimsubmissionNotes wrap6 = new CG_CL_GetClaimDetails.ClaimsubmissionNotes();
        wrap6.Notes = 'test';
        wrap6.AdjudicatorName = 'test';
        wrap6.Notestime = 'test';
        
        //claimDetail.ReturnCodeDescription= 'Message from Siebel';
        //claimDetail.Status= 'Success';
        //claimDetail.ReturnCode= 'MessageCode from Siebel';
        //claimDetail.MessageIdentifier= 'Identifier from MW';
        
        claimDetail.WarrantyStartDate = 'today';
        claimDetail.FailureDate = 'today';
        claimDetail.ServiceProviderCode = 'test';
        claimDetail.DistributorCode = '567';
        claimDetail.DistributorName = 'wenchin';
        claimDetail.PSN = 'test';
        claimDetail.WorkOrderNumber = 'wo-123';
        claimDetail.EngineApplicationCode = '5987';
        claimDetail.Manufacturer = 'test';
        claimDetail.ModelSeries = 'test';
        claimDetail.FailurePoint = 12;
        claimDetail.FailureMeasure = 'test';
        claimDetail.CustomerName = 'wenchin';
        claimDetail.EngineVIN = '476';
        claimDetail.UnitNumber = '123';
        claimDetail.DealerClaimNumber = '46547';
        claimDetail.ClaimSource = 'test';
        claimDetail.ClaimFiledDate = system.today();
        claimDetail.WarrantyStartDates = 'today';
        claimDetail.FailureDates = 'today';
        claimDetail.AccountCode = '123';
        claimDetail.SiebelClaimNumber = 'test';
        claimDetail.IMSClaimNumber = 'test';
        claimDetail.PayCode = 'test';
        claimDetail.ClaimStatus = 'Success';
        claimDetail.RejectionReason = 'test';
        claimDetail.Type = 'test';
        claimDetail.StatementNumber = 'test';
        claimDetail.CreditDate = 'test';
        claimDetail.CreditNumber = 'test';
        claimDetail.Parts = 123;
        claimDetail.Labor =123;
        claimDetail.Travel = 123;
        claimDetail.Other = 123;
        claimDetail.Tax = 123;
        claimDetail.PMU = 123;
        claimDetail.BFC = 123;
        claimDetail.Deductible = 123;
        claimDetail.TotalPaid = 123;
      /*  claimDetail.SystemCode='BS';
        claimDetail.ComponentCode='HS';
        claimDetail.FailMode='BR';
        claimDetail.Failurename='Turbo Charger';
        claimDetail.CampaignNumber='C24523';
        claimDetail.FaultCode=125;
        claimDetail.AccountCode=67;
        claimDetail.PayCode='I';
        claimDetail.PartNumber=345345;
        claimDetail.PartDescription='PartName1';
        claimDetail.ClaimedQty=2;
        claimDetail.AdjustedQty=1;
        claimDetail.TrackingNumber=23456232346;
        claimDetail.RID=34234;
        claimDetail.AdjustmentReason='Quantity used as not covered';
        claimDetail.Item='abc1';
        claimDetail.ItemDescription='abc2';
        claimDetail.ClaimedAmount=1;
        claimDetail.AdjustedAmount=2;
        claimDetail.AdjustmentReason='abc1233';
        claimDetail.SRTCode='abc6';
        claimDetail.SRTDescription='abc7';
        claimDetail.SRTHours=3;
        claimDetail.ClaimedQty=4;
        claimDetail.ClaimedPercent=5;
        claimDetail.ClaimedHours=6;
        claimDetail.AdjustedQty=7;
        claimDetail.AdjustedPercent=8;
        claimDetail.AdjustedHours=9;
        claimDetail.AdjustmentReason='abc8';
        claimDetail.PenaltyAppliedFlag='abc9';
        claimDetail.TravelType='Commercial';
        claimDetail.ClaimedDistance=10;
        claimDetail.ClaimedHours=6;
        claimDetail.ClaimedAmount=1;
        claimDetail.AdjustedDistance=123;
        claimDetail.AdjustedHours=9;
        claimDetail.AdjustedAmount=2;
        claimDetail.LodgingAmount=11;
        claimDetail.MealsAmount=12;
        claimDetail.TowingAmount=13;
        claimDetail.LaborAmount=14;
        claimDetail.TravelAmount=15;
        claimDetail.TotalTravel=16;
        claimDetail.BaseFare=18;
        claimDetail.AdjustmentReason='abc16';
        claimDetail.PenaltyAppliedFlag='abc15';
        claimDetail.AdjustedPercent=8;
        claimDetail.Note='abc';
        claimDetail.NoteType='Correction';
        claimDetail.CreatedDate='2012-06-06';
        claimDetail.ComplaintCode='abc';
        claimDetail.ComplaintText='abc'; */
        
        
        
        claimDetail.CallgetPaymentDetails();
        claimDetail.generatePDF(); 
        claimDetail.getChooserender();
        //claimDetail.fetchClaimSubmissionRecords();
        CSS_GetClaimDetailsResponse cresWrap = new CSS_GetClaimDetailsResponse();
        Test.setMock(HttpCalloutMock.class, new CG_CL_GetClaimDetails_Mock());
        //Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        system.debug('Inside Test class 1');
        claimDetail.CallGetClaimDetails();
    }
    
    
     public static Testmethod void CallGetClaims_Test12()
    {
      
         CSS_Integration_Details__c connection1 = new CSS_Integration_Details__c ();
        connection1.ApplicationName__c='CSS_SBL_GetClaimDetails';
        connection1.Name='CSS_SBL_GetClaimDetails';
        connection1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/claims?sender=CSS&target=CSSWarranty&siebelClaimNumber=1-1011307897';
        connection1.Method_Type__c='GET';
        connection1.Timeout__c=2.0;
        connection1.IsActive__c=true;
          connection1.Key__c='FQ8oAT/x8qGEujKi0UY0sdjsNF7HOCnRtWFjXaQBLMI=';
          connection1.Username__c='	/eOKgAPkL2C/vdW6v20pWSt08Z3NjnUbaa5ZarceWZo/ZG8WZXP7c3waikblHoHlHHA16KLKObCDKmH/tIf1wQ==';
          connection1.Passcode__c='usXis4pEpIhVfhEf7RiHuqV9YqDdZts/vMFtlCUCvHncqwlScZeYX5HqxH8Ru5DAFFvkiesgqP8pkfTYK861FA==';
          connection1.Logging__c='Test';
        insert connection1;
        
         CSS_Integration_Details__c connection2 = new CSS_Integration_Details__c ();
        connection2.ApplicationName__c='CG_SBL_ClaimPaymentStatus';
        connection2.Name='CG_SBL_ClaimPaymentStatus';
        connection2.End_Point__c='https://services-dev.cummins.com/csswarranty/getsiebelclaimdetails/';
        connection2.Method_Type__c='GET';
        connection2.Timeout__c=2.0;
        connection2.IsActive__c=true;
          connection2.Key__c='FQ8oAT/x8qGEujKi0UY0sdjsNF7HOCnRtWFjXaQBLMI=';
          connection2.Username__c='	/eOKgAPkL2C/vdW6v20pWSt08Z3NjnUbaa5ZarceWZo/ZG8WZXP7c3waikblHoHlHHA16KLKObCDKmH/tIf1wQ==';
          connection2.Passcode__c='usXis4pEpIhVfhEf7RiHuqV9YqDdZts/vMFtlCUCvHncqwlScZeYX5HqxH8Ru5DAFFvkiesgqP8pkfTYK861FA==';
          connection2.Logging__c='Test';
        insert connection2;
        
        LIST<CSS_Integration_Details__c> connectionlist = [select id,ApplicationName__c,Name,End_Point__c,Method_Type__c,Timeout__c from CSS_Integration_Details__c];
        system.debug('connectionlist'+connectionlist[0]);
        CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
         connection=CSS_Integration_Details__c.getvalues(connection1.ApplicationName__c);  
        system.assert(connection.Method_Type__c!=null);
       
        CSS_Job_Order__c jo =  CSS_TestData.createJobOrder(true); 
        CSS_Claims__c claimRec = CSS_TestData.createclaims(false,jo.id);
        claimRec.SiebelClaimNumber__c='12-1234356';
        insert claimRec;
        CSS_Claim_Submission__c claimSub = CSS_TestData.createclaimsub(false,claimRec.id);
        claimSub.Siebel_Claim_Number__c='12-1234356';
        insert claimSub;
        CSS_PSN__c psn = CSS_TestData.createpsn(true,claimRec.id);
        apexpages.currentPage().getparameters().put('id',claimRec.id);

        
                Test.startTest();
        CG_CL_GetClaimDetails cls = new CG_CL_GetClaimDetails();
         
        
        test.setMock(httpcalloutmock.class,new CG_CL_GetClaimDetails_Mock());
        //Test.setMock(HttpCalloutMock.class , new CSS_MockHttpResponseGenerator());
        system.debug('Inside Test class 2');
        cls.CallGetClaimDetails();
     
             test.setMock(httpcalloutmock.class,new CG_CL_GetPaymentDetails_Mock());
        cls.CallgetPaymentDetails();
        Test.stopTest();
        
    } 
}